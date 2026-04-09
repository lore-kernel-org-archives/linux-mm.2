Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A2C7E98FAF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 05:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DDF6B0005; Thu,  9 Apr 2026 01:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F606B0088; Thu,  9 Apr 2026 01:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4245A6B008A; Thu,  9 Apr 2026 01:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 284886B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:25:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B49C1B7B60
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:25:01 +0000 (UTC)
X-FDA: 84637878402.02.900D819
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8FDAD1C0006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:24:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FhjfDfEa;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775712299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ByoqNANAkfykTWtxy44yGiaEWWaScRDVUDHbdDcABCo=;
	b=4ECN/2KmwJy9apowICBJEefiTHh6CILie/HURHsJpQnPn9py4bjsNkIXp7u5ArtpWx6Cn5
	UyfBFjHVlNxknxxKlkEtMVES5PU3GvWN1ncgsKtBu/8VsQ2DCB0jvaIoygJHN3wrFe7VrM
	+4feExLSiEXyXGkMfziZQsTLPJAKkHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775712299; a=rsa-sha256;
	cv=none;
	b=r1SkseYSvU6Fa6Uw7fxDBXgwSLIovdVjHKGA9v/eR/3RNNCGt7kbyBnPs1qnHVKe8p7nH4
	N5grIO3WUDGUIN+4eyB+kqnYYNrAyg5cthbKAKHbICPKWve9shZl2nr9c4HpcS+9Ub5eZT
	1Iysv8LfgBCWwmUHOPzaiVB9GxPBwlg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FhjfDfEa;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775712299; x=1807248299;
  h=date:from:to:cc:subject:message-id;
  bh=rJRYkelNi+0zkRO7MPtEnrqKSPYbIYIS8+pI14nizFA=;
  b=FhjfDfEaYMM4ajHpCJClPmnIqfbqVzdO0zBmlrKpMUZ/uLtNDf46EMaV
   963fYCSuERveQFE6ErlvLnNPigI6UTclHmfBwhX6H+/TX5cKhKExVtQo2
   jfzUUx79RFJ3/V5P5mdprckASwOOesDwrTe8d9v/O4ZMTIxfH2XSalosx
   j0Vw1ffMeRjzq+oED6JANmZ10w5c3rX/RYHY+R3fQFkYNrfIMdgMxWla/
   HJOBCic/3Xp/jh4bX+gwwySfatpPKH1OkvBlgXkV1Z9SBkaeSIwQIl/1U
   1+pwKFNGHOqR8au7yqbFvcLpCd6BEXKV4EfhIJKhaboPY5BiF+7M282kn
   g==;
X-CSE-ConnectionGUID: jLg0cEvJSniPQFk44qGsLg==
X-CSE-MsgGUID: tTrErYr+TA2SbX2WVzCQug==
X-IronPort-AV: E=McAfee;i="6800,10657,11753"; a="87331936"
X-IronPort-AV: E=Sophos;i="6.23,169,1770624000"; 
   d="scan'208";a="87331936"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 22:24:57 -0700
X-CSE-ConnectionGUID: 3Bi5R9VmRZmD7kPzOdGA2w==
X-CSE-MsgGUID: s1Dw/DZHQLOxhQH07RQ3Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,169,1770624000"; 
   d="scan'208";a="233045896"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 08 Apr 2026 22:24:55 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wAhsq-00000000AcT-2hL9;
	Thu, 09 Apr 2026 05:24:52 +0000
Date: Thu, 09 Apr 2026 07:24:47 +0200
From: kernel test robot <lkp@intel.com>
To: Matteo Croce <technoboy85@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 8662/12838] htmldocs: MAINTAINERS:40:
 WARNING: Inline strong start-string without end-string. [docutils]
Message-ID: <202604090741.1kUVXMoc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 8FDAD1C0006
X-Stat-Signature: oaefudbjedqwmpkgdbr3jx8u73sn5ktq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775712298-904764
X-HE-Meta: U2FsdGVkX19fwBTwonSjFkBno93GmgPgustw0zg02dD6Q2a4sA/k9XHKBJFuSyftnAcLrOIpfReVoGbWo2kzGfHHnSJ9qOQHU9nSPqyJKYQNA7+ldXS42qlmepYA4e/iaEBTobK4tzGTQ+eCPoVsyDJJPa6pCkZH+LrGbJ6c/W8EUMmQeHLlBdSANg7ncUlPGTey57cZ8kYYJEpQkWIRSdAIoirnUzvXa6nmRwSmQKeij1xl1efOpYIcY5T1WTLcWGXLv38orCZlC9CZJ3GqnUNj9s5HH0yRMQuAPYXOqwa6Hyf+EU0oe+ISLJlE5m8YOdZg6cUAU77WVPuYMTd+KSGzeFFLRiW+TGpwDMRtFKYMFDFtsHV1UyXyMGXmk86h+ijynQhBYoOI9pMrOP3AjdaMwv9F4ky/ri/KMg/6lMgt5ZW/GOVv8J0eGtXw5yB0oUvFAoMcv2WYKc7dihV6KvKPg7IStE8vdQjPcalz+pN62MTK7J8/f9orRG/9h9rcfIGXkcE1kyfHeq/QQvY98HSIL547ipfMFUdYEJXUJcsF+YUNK07hbfTrCo6QsD8ukGmMnAE9hsCsHXnpGzYIl35recHacRibuX9Hs4K01PyHBEtqm4bbwY74fknWoO/R599HqXGvSNhWHix4jY3IuLure2gcjGbaY80pnHy/6qlTv1zSv+z35fx3LgdwmHQznrfBF7famJq/XSQRt0nqUsZLkfa+7luNcvTRMg8EcTMa4JkPKCSK27IytopQqC3MBNEFybrEmvecMZPUktzL2Mcskd58dBW6tMNop5JA1RF3AMs6QJ+3myVaeiAeQaBWn2Ylf7m0Q1hh5Ji6BneKJniHqZt1UPJzEsDneHMHeMU3Hzf/2eb/WXy/iN9FsxEDXOJocGLn1H77fS+fOcZSx/HVYx8pzqDCNnhM+vrfRE5RGvBtiOaG9gB+HNqDZ97+y+UQpTU6rfnYB+DRKZQ
 WqNT2gtK
 i72R6vfmDVuxxSt3VSo5kW/3f7OxKw9xTo2v8SVy+xXctOODsajqLzM7NFgXt5UxUr+z+8xTngcw/j4ABDosyaaYM8ZODnK8kkm0QmMkSq0chxS6T2mH6F/7reXkueWf8/JOF5C8ulx25zkQyRMkONSysH4VClCgHcpW1oGM1mDZvh7Oe3GyaJaJ4tRrjzHY7i2jMhJ2uzXJmVgJwk1xKYELahHvf/lVLwZW69w5xzky6pSdocmLdQMxr/x98HkokaMjgK7UlptigXT7EPBUQKBOCcHPovQTt+/KPYdOnsBuxQTigEe0St0dZAoULr8z9lE3+3tAE/+PqYy33NtxDOtWVbeJP5dtMwzNjPmn69zXRHec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   db7efce4ae23ad5e42f5f55428f529ff62b86fab
commit: 420849332f9f9f1ce6ff142868ae2e6ae9f98f65 [8662/12838] get_maintainer: add ** glob pattern support
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
reproduce: (https://download.01.org/0day-ci/archive/20260409/202604090741.1kUVXMoc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604090741.1kUVXMoc-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Checksumming on output with GSO
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ [docutils]
>> MAINTAINERS:40: WARNING: Inline strong start-string without end-string. [docutils]
   Documentation/userspace-api/landlock:480: ./security/landlock/errata/abi-4.h:5: ERROR: Unexpected section title.


vim +40 MAINTAINERS

^1da177e4c3f41 Linus Torvalds   2005-04-16   6  
aa204855281389 Kees Cook        2019-10-01   7  	M: *Mail* patches to: FullName <address@domain>
aa204855281389 Kees Cook        2019-10-01   8  	R: Designated *Reviewer*: FullName <address@domain>
eafbaac3093760 Paul E. McKenney 2014-06-02   9  	   These reviewers should be CCed on patches.
aa204855281389 Kees Cook        2019-10-01  10  	L: *Mailing list* that is relevant to this area
aa204855281389 Kees Cook        2019-10-01  11  	S: *Status*, one of the following:
^1da177e4c3f41 Linus Torvalds   2005-04-16  12  	   Supported:	Someone is actually paid to look after this.
^1da177e4c3f41 Linus Torvalds   2005-04-16  13  	   Maintained:	Someone actually looks after it.
^1da177e4c3f41 Linus Torvalds   2005-04-16  14  	   Odd Fixes:	It has a maintainer but they don't have time to do
^1da177e4c3f41 Linus Torvalds   2005-04-16  15  			much other than throw the odd patch in. See below..
^1da177e4c3f41 Linus Torvalds   2005-04-16  16  	   Orphan:	No current maintainer [but maybe you could take the
^1da177e4c3f41 Linus Torvalds   2005-04-16  17  			role as you write your new code].
^1da177e4c3f41 Linus Torvalds   2005-04-16  18  	   Obsolete:	Old code. Something tagged obsolete generally means
^1da177e4c3f41 Linus Torvalds   2005-04-16  19  			it has been replaced by a better system and you
^1da177e4c3f41 Linus Torvalds   2005-04-16  20  			should be using that.
6680125ea5a2a5 Joe Perches      2020-04-06  21  	W: *Web-page* with status/info
6680125ea5a2a5 Joe Perches      2020-04-06  22  	Q: *Patchwork* web based patch tracking system site
6680125ea5a2a5 Joe Perches      2020-04-06  23  	B: URI for where to file *bugs*. A web-page with detailed bug
6680125ea5a2a5 Joe Perches      2020-04-06  24  	   filing info, a direct bug tracker link, or a mailto: URI.
6680125ea5a2a5 Joe Perches      2020-04-06  25  	C: URI for *chat* protocol, server and channel where developers
6680125ea5a2a5 Joe Perches      2020-04-06  26  	   usually hang out, for example irc://server/channel.
bf667efc5672df SeongJae Park    2024-02-16  27  	P: *Subsystem Profile* document for more details submitting
4699c504e603e2 Dan Williams     2019-11-24  28  	   patches to the given subsystem. This is either an in-tree file,
4699c504e603e2 Dan Williams     2019-11-24  29  	   or a URI. See Documentation/maintainer/maintainer-entry-profile.rst
4699c504e603e2 Dan Williams     2019-11-24  30  	   for details.
6680125ea5a2a5 Joe Perches      2020-04-06  31  	T: *SCM* tree type and location.
6680125ea5a2a5 Joe Perches      2020-04-06  32  	   Type is one of: git, hg, quilt, stgit, topgit
aa204855281389 Kees Cook        2019-10-01  33  	F: *Files* and directories wildcard patterns.
679655daffdd27 Joe Perches      2009-04-07  34  	   A trailing slash includes all files and subdirectory files.
679655daffdd27 Joe Perches      2009-04-07  35  	   F:	drivers/net/	all files in and below drivers/net
679655daffdd27 Joe Perches      2009-04-07  36  	   F:	drivers/net/*	all files in drivers/net, but not below
679655daffdd27 Joe Perches      2009-04-07  37  	   F:	*/net/*		all files in "any top level directory"/net
420849332f9f9f Matteo Croce     2026-03-02  38  	   F:	fs/**/*foo*.c	all *foo*.c files in any subdirectory of fs
679655daffdd27 Joe Perches      2009-04-07  39  	   One pattern per line.  Multiple F: lines acceptable.
6680125ea5a2a5 Joe Perches      2020-04-06 @40  	X: *Excluded* files and directories that are NOT maintained, same
6680125ea5a2a5 Joe Perches      2020-04-06  41  	   rules as F:. Files exclusions are tested before file matches.
6680125ea5a2a5 Joe Perches      2020-04-06  42  	   Can be useful for excluding a specific subdirectory, for instance:
6680125ea5a2a5 Joe Perches      2020-04-06  43  	   F:	net/
6680125ea5a2a5 Joe Perches      2020-04-06  44  	   X:	net/ipv6/
6680125ea5a2a5 Joe Perches      2020-04-06  45  	   matches all files in and below net excluding net/ipv6/
aa204855281389 Kees Cook        2019-10-01  46  	N: Files and directories *Regex* patterns.
6680125ea5a2a5 Joe Perches      2020-04-06  47  	   N:	[^a-z]tegra	all files whose path contains tegra
6680125ea5a2a5 Joe Perches      2020-04-06  48  	                        (not including files like integrator)
bbbe96ed899e8e Stephen Warren   2013-04-29  49  	   One pattern per line.  Multiple N: lines acceptable.
6ab88e00704bde Joe Perches      2014-01-23  50  	   scripts/get_maintainer.pl has different behavior for files that
6ab88e00704bde Joe Perches      2014-01-23  51  	   match F: pattern and matches of N: patterns.  By default,
6ab88e00704bde Joe Perches      2014-01-23  52  	   get_maintainer will not look at git log history when an F: pattern
6ab88e00704bde Joe Perches      2014-01-23  53  	   match occurs.  When an N: match occurs, git log history is used
6ab88e00704bde Joe Perches      2014-01-23  54  	   to also notify the people that have git commit signatures.
aa204855281389 Kees Cook        2019-10-01  55  	K: *Content regex* (perl extended) pattern match in a patch or file.
aa204855281389 Kees Cook        2019-10-01  56  	   For instance:
c7c4fb18d0026b Joe Perches      2009-10-26  57  	   K: of_get_profile
bbbe96ed899e8e Stephen Warren   2013-04-29  58  	      matches patches or files that contain "of_get_profile"
c7c4fb18d0026b Joe Perches      2009-10-26  59  	   K: \b(printk|pr_(info|err))\b
bbbe96ed899e8e Stephen Warren   2013-04-29  60  	      matches patches or files that contain one or more of the words
bbbe96ed899e8e Stephen Warren   2013-04-29  61  	      printk, pr_info or pr_err
c7c4fb18d0026b Joe Perches      2009-10-26  62  	   One regex pattern per line.  Multiple K: lines acceptable.
c7c4fb18d0026b Joe Perches      2009-10-26  63  

:::::: The code at line 40 was first introduced by commit
:::::: 6680125ea5a2a5a69eeb8f7dcd89d0a1d23998ce MAINTAINERS: list the section entries in the preferred order

:::::: TO: Joe Perches <joe@perches.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

