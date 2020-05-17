# csvzip

**csvzip** is a standalone CLI tool to reduce CSVs size by converting categorical columns in a list of unique integers.

The execution produces two files:

 1. a CSV with the compressed values
 2. a JSON dictionary with the mappings

‼️ Current in input CSV file:‼️
 - the CSV has to have a headers row

We love [csvkit](https://csvkit.readthedocs.io) and csvzip has been inspired by that great tool

## Installation

### GNU/Linux

You can download the latest binary from the [releases page](https://github.com/PopulateTools/csvzip/releases).

### macOS

You can get the latest *darwin* build from the [releases page](https://github.com/PopulateTools/csvzip/releases).

### Windows

Until the [Crystal Windows porting](https://github.com/crystal-lang/crystal/wiki/Porting-to-Windows) is completed,
you can go with [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Usage

Let's say you have downloaded a very big CSV, for example [Madrid census](https://datos.madrid.es/sites/v/index.jsp?vgnextoid=1d755cde99be2410VgnVCM1000000b205a0aRCRD&vgnextchannel=374512b9ace9f310VgnVCM100000171f5a0aRCRD):

If we inspect it, it's a 22Mb file that looks like this:

```
"COD_DISTRITO";"DESC_DISTRITO";"COD_DIST_BARRIO";"DESC_BARRIO";"COD_BARRIO";"COD_DIST_SECCION";"COD_SECCION";"COD_EDAD_INT";"EspanolesHombres";"EspanolesMujeres";"ExtranjerosHombres";"ExtranjerosMujeres"
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1006";"6";"99";"";"1";"";""
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1006";"6";"102";"";"1";"";""
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1007";"7";"0";"2";"2";"";"1"
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1007";"7";"1";"3";"3";"";""
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1007";"7";"2";"4";"3";"";""
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1007";"7";"3";"1";"3";"";""
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1007";"7";"4";"";"6";"";"1"
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1007";"7";"5";"2";"1";"";""
"1";"CENTRO              ";"101";"PALACIO             ";"1";"1007";"7";"6";"3";"4";"";""
...
```

Let's compress it:
```
csvzip -i Rango_Edades_Seccion_202005.csv -o compressed.csv -c "DESC_DISTRITO,DESC_BARRIO" -k census -s ';'
```

```$ head compressed.csv
COD_DISTRITO,DESC_DISTRITO,COD_DIST_BARRIO,DESC_BARRIO,COD_BARRIO,COD_DIST_SECCION,COD_SECCION,COD_EDAD_INT,EspanolesHombres,EspanolesMujeres,ExtranjerosHombres,ExtranjerosMujeres
1,0,101,0,1,1006,6,99,,1,,
1,0,101,0,1,1006,6,102,,1,,
1,0,101,0,1,1007,7,0,2,2,,1
1,0,101,0,1,1007,7,1,3,3,,
1,0,101,0,1,1007,7,2,4,3,,
1,0,101,0,1,1007,7,3,1,3,,
...
```

And the size is now 7.2Mb.

If we inspect the dictionary, it contains the values of those columns:

```$ cat dictionary.json  | jq
{
  "census": {
    "DESC_DISTRITO": {
      "CENTRO": "0",
      "ARGANZUELA": "1",
      "RETIRO": "2",
      "SALAMANCA": "3",
      ...
    },
    "DESC_BARRIO": {
      "PALACIO": "0",
      "EMBAJADORES": "1",
      "UNIVERSIDAD": "2",
      "CHOPERA": "3",
      "PACIFICO": "4",
      ...
    }
  }
}
```

## Todo

- [ ] Improve specs coverage
- [ ] accept headers parameter
- [ ] decompress operation

## Contributing

1. Fork it (<https://github.com/PopulateTools/csvzip/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Thanks

Thanks to marcobellaccini from [nanvault](https://github.com/marcobellaccini/nanvault) for the inspiration to build this CLI tool. The structure of the project and the Github actions scripts are copied from that repository.

## Contributors

- [Fernando Blat](https://github.com/ferblape) - creator and maintainer
