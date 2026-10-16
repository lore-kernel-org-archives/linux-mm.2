Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFCACC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 05:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250036B0088; Fri, 16 Oct 2026 01:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227336B008A; Fri, 16 Oct 2026 01:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E496B0098; Fri, 16 Oct 2026 01:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE2816B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:36:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76B28160347
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:36:59 +0000 (UTC)
X-FDA: 85327380558.24.002F077
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id B57A7A0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:36:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PcrygCc/";
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792129017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JHaII94y4H6LxYPcudoto4QHK24tsT/E+ez0xaLBV4=;
	b=zcR6yzgxp2fWv+i8poVDmyEnnHfnfNcwMGZD6E0LOkKmkLJCm3PN13iWeTffZSG4OMGvJg
	FSCdio1SQPX4hnXGfsfCJ3GFs3jqlbgyDdAk2zVGyBi05A6EaWSecAV5on5ErE1uFIMTrs
	/11gfW11cMNWEb4ii4HIKCfCXbuQSUI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PcrygCc/";
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792129017;
	b=zY5TOvzSrjw0KWUnAdQlYrgKFZuBaUKIDKeYzz3jL809sdoiaX9J+H6f5WDdhqVw5DI7JQ
	5S/avjrVHwOELSDi+8v1RNhYZpccgQmoU1EI39CYCq3SwsOURz8/OyRg0TTAE4heEsPVHS
	B+Vlw0FklP7S2ZywUBRE0ZSV31p2R2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792129018; x=1823665018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OxsimB+IRUojLvT+hziSkxVdTCzcdvyp81HuqPLZG/s=;
  b=PcrygCc/uFHRj3mLXNXFgEaCO3hihAxTqTmkUYklvObUUEPISOjOMUL0
   4Ehx5mGVbu31oEV9JOPm3xHEhYnnHrofOMCt7h07nltvt9hiUJampQKTI
   OmAPi0Dx2EHA1XrAIGrv29AI5ITvGW8bMOFRv2MtPEPP8Ht8rASFKyVcR
   sdEU6kqNaOprjUO8kH6T8+5+ZYtwwrmEbFSAn56hC17GMDfoxSRqJH2aO
   TV5Z5brTxywhnZ39Sub8QTvyEriWMUNEGx556pZIrLmtMS5sbqoBj1Sdi
   OXe41PnebEhi1stRGBQOij+lo44A5Zzt/Dy4WuVUmATy6KBOdsQaakzf0
   g==;
X-CSE-ConnectionGUID: qjaTZo35RgiM7gUlBrs/NQ==
X-CSE-MsgGUID: qNFfMjRnRnaJL1KlGHnZ1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="915289"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="915289"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 22:36:56 -0700
X-CSE-ConnectionGUID: cV+8eTvqSQ2EgdgT1mW2lg==
X-CSE-MsgGUID: jlVQO0VBQtCYTbTBdJ3bkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="2236954"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 15 Oct 2026 22:36:51 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHacZ-00000000Hfu-0y6G;
	Fri, 16 Oct 2026 05:36:47 +0000
Date: Fri, 16 Oct 2026 13:36:22 +0800
From: kernel test robot <lkp@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>
Cc: oe-kbuild-all@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Rae Moar <raemoar63@gmail.com>,
	Ryota Sakamoto <sakamo.ryota@gmail.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Kir Chou <note351@hotmail.com>, Petr Mladek <pmladek@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	linux-kernel@vger.kernel.org,
	"(open list:KERNEL UNIT TESTING FRAMEWORK \\(KUnit\\))" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] lib/tests: kunit for associative array
Message-ID: <202610161338.iIHVeJyP-lkp@intel.com>
References: <20261014160144.1835860-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014160144.1835860-1-jarkko@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B57A7A0006
X-Stat-Signature: zim7dr375u9d8jckn8o1tosqapag3pa6
X-HE-Tag: 1792129016-971866
X-HE-Meta: U2FsdGVkX1+Mexuo9pNN8EltS0mFoKbJk80hqugW6A+wFKsygA3kSeBbQ5EK3oJDMowSuYzwkHjRKwUSADSy4/hBD8Ww0tso36BHTtV3nlv0fPQebJO5tKTYEjncLAVWou8xaUyqAd5gkfrTFEvWR19nwo3gIQ+lraEyohHEV65X1T/uFJyo306HVgUUr16qrGs9YgIXdY2kqCZlR0fDW/qo3qM8PjIT83JMhbJKS9CvhcihRL4KsOKOU5sG3hjE4M1TOuc5AppotmOCpzDLQhYVxyMPCZmx1a3pN3op/kLHHNK9qLWS9NkonNryQtqYb5kdnDhksT2z+IYn2MLyZZI2+FalVeketi0zSnK8zefLbdOng9zP92PqQV7CGhRh8lxkPqZa4rSmXRR4C62o6P31kzaKCu917F8Zht9R+ZDGQ2W+ja4UVHovfJL7Ko4Re2pcCwo+chZb2NdKrZ0eW7KCqpjuLV5Na6AyoMmzltQqwdkgx1CO04xxjYkF3UPKGf8aiTB9/V8QHyENK3U/u+cfINKFWWl1uO6+OSMYOGm1sxXaCumT/GCSn/XKCW577ELTXCw3qpLLd5CikvIkKoniyVhqGEaD65vGS/1/Ic1108Mp5PEQjYW9zhpdVkvb9xFTfml/puGyHK59r4NLf+tPoapR4WDCvQABObx8bhoNGaNiogbsFd0WowfPp4xeiahbyE4700S9FlBUOfCuneX/KiGVpzKXG8jaA8fELEXD6zwoAlgYjOcqKx5sA75xiudFh8a3DttM5tKmWbSErbC5ABBM3BXCkaROftvIpyGXFZim/+lfbASob7wrkNSnpxgD2Gk5ogALLxzNPLamLTh/wb4LhQ/bk3JYB4pJPIfygSBpXh2GMCns4G1dRdIE8+a9Cb5RvyMBscx930iAmFTfdPVmoeVXUvBUISt0Ip4mH5R9oiX8EAsjsXpoaKgybDuKJDKuunjdC6Sd7gH
 ewUxw6Ws
 Av3ZTw7oLHUMeX56aLch68SqOVtKiC62Ns0nSdO29gjpr0I3E23MhPCNIATyHBWzxcFz5ZW1J/cr94lydt6YDMdn63irYC/X0xhRe0fFTQgyQv+x1j9Dcc/w+QPNiP/4BguZI/XkbPBXrYxrtkDkboc6d0VZa59M/zI6mCd7xD9INBBuqKmIYX5YqbRx+b7y6qdFIrJJ1PKVgsazAfNOo9AU6xa/6tDdLltIqp2TYL60c375p9Yh16jpw3eobocjOp+I4g47qb6IA5dXdL42oxa/nttTVDbRUiUgHyGCviDAHXaijrSrwCOYZWUEZ1svIIckNX/qX9jM70xcT1ACHP9Oy108tTZugrnNsXcbgqT5afFBJVMY7lYwrAUCJx+7shrChOD0qPU5K02DDWxkzQ2Z0HQcSqx2x4Amnp0GKpGFLLeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jarkko,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on linus/master v7.3-rc7]
[cannot apply to next-20261012]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jarkko-Sakkinen/lib-tests-kunit-for-associative-array/20261014-190138
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20261014160144.1835860-1-jarkko%40kernel.org
patch subject: [PATCH] lib/tests: kunit for associative array
config: arm-randconfig-1001-20261016 (https://download.01.org/0day-ci/archive/20261016/202610161338.iIHVeJyP-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261016/202610161338.iIHVeJyP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610161338.iIHVeJyP-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/tests/assoc_array_kunit.c:62:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000010UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:63:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000020UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:64:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000030UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:65:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000040UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:66:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000050UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:67:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000060UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:68:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000070UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:69:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000080UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:70:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000090UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:71:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x00000000000000a0UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:72:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x00000000000000b0UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:73:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x00000000000000c0UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:74:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x00000000000000d0UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:75:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x00000000000000e0UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:76:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x00000000000000f0UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:77:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000100UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:78:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000110UL,
     ^~~~~~~~~~~~~~~~~~~~
   lib/tests/assoc_array_kunit.c:79:2: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '16045690984503098046' to '3405691582' [-Woverflow]
     0xdeadbeefcafebabeUL, 0x0000000000000001UL,
     ^~~~~~~~~~~~~~~~~~~~


vim +62 lib/tests/assoc_array_kunit.c

    19	
    20	/*
    21	 * As a quick remainder, these are the basic building blocks of an associative
    22	 * array:
    23	 *
    24	 * - struct assoc_array_node: a tree node representing a nibble of the search
    25	 *   key.
    26	 * - struct assoc_array_shortcut: a tree node representing a sequence of nibbles
    27	 *   shared by multiple search keys with no divergence among them.
    28	 *
    29	 * The keys in array will be created in order in tests, and is a constructed in
    30	 * a way that splits reach the level 8:
    31	 *
    32	 * - 0..16:  Share prefix 0x21 at levels 0 and 4.
    33	 * - 17:     Splits root shortcut at level 4.
    34	 * - 18..34: Share chunk 0.
    35	 * - 35:     Splits shortcut at chunk boundary.
    36	 * - 36..46: Share prefix 0xbeef at levels 0..12.
    37	 * - 47:     Splits shortcut at level 8.
    38	 * - 48..63: Distinct leaves at level 0.
    39	 *
    40	 * The numbers were picked partly based on trial and error, and partly trying to
    41	 * find smallest possible numbers reaching the level 8.
    42	 */
    43	static const unsigned long assoc_array_test_keys[ASSOC_ARRAY_TEST_NR_KEYS * 2] = {
    44		0x0000000000000121UL, 0x0000000000000000UL,
    45		0x0000000000000221UL, 0x0000000000000000UL,
    46		0x0000000000000321UL, 0x0000000000000000UL,
    47		0x0000000000000421UL, 0x0000000000000000UL,
    48		0x0000000000000521UL, 0x0000000000000000UL,
    49		0x0000000000000621UL, 0x0000000000000000UL,
    50		0x0000000000000721UL, 0x0000000000000000UL,
    51		0x0000000000000821UL, 0x0000000000000000UL,
    52		0x0000000000000921UL, 0x0000000000000000UL,
    53		0x0000000000000a21UL, 0x0000000000000000UL,
    54		0x0000000000000b21UL, 0x0000000000000000UL,
    55		0x0000000000000c21UL, 0x0000000000000000UL,
    56		0x0000000000000d21UL, 0x0000000000000000UL,
    57		0x0000000000000e21UL, 0x0000000000000000UL,
    58		0x0000000000000f21UL, 0x0000000000000000UL,
    59		0x0000000000001021UL, 0x0000000000000000UL,
    60		0x0000000000001121UL, 0x0000000000000000UL,
    61		0x0000000000000001UL, 0x0000000000000000UL,
  > 62		0xdeadbeefcafebabeUL, 0x0000000000000010UL,
    63		0xdeadbeefcafebabeUL, 0x0000000000000020UL,
    64		0xdeadbeefcafebabeUL, 0x0000000000000030UL,
    65		0xdeadbeefcafebabeUL, 0x0000000000000040UL,
    66		0xdeadbeefcafebabeUL, 0x0000000000000050UL,
    67		0xdeadbeefcafebabeUL, 0x0000000000000060UL,
    68		0xdeadbeefcafebabeUL, 0x0000000000000070UL,
    69		0xdeadbeefcafebabeUL, 0x0000000000000080UL,
    70		0xdeadbeefcafebabeUL, 0x0000000000000090UL,
    71		0xdeadbeefcafebabeUL, 0x00000000000000a0UL,
    72		0xdeadbeefcafebabeUL, 0x00000000000000b0UL,
    73		0xdeadbeefcafebabeUL, 0x00000000000000c0UL,
    74		0xdeadbeefcafebabeUL, 0x00000000000000d0UL,
    75		0xdeadbeefcafebabeUL, 0x00000000000000e0UL,
    76		0xdeadbeefcafebabeUL, 0x00000000000000f0UL,
    77		0xdeadbeefcafebabeUL, 0x0000000000000100UL,
    78		0xdeadbeefcafebabeUL, 0x0000000000000110UL,
    79		0xdeadbeefcafebabeUL, 0x0000000000000001UL,
    80		0x000000000001beefUL, 0x0000000000000000UL,
    81		0x000000000002beefUL, 0x0000000000000000UL,
    82		0x000000000003beefUL, 0x0000000000000000UL,
    83		0x000000000004beefUL, 0x0000000000000000UL,
    84		0x000000000005beefUL, 0x0000000000000000UL,
    85		0x000000000006beefUL, 0x0000000000000000UL,
    86		0x000000000007beefUL, 0x0000000000000000UL,
    87		0x000000000008beefUL, 0x0000000000000000UL,
    88		0x000000000009beefUL, 0x0000000000000000UL,
    89		0x00000000000abeefUL, 0x0000000000000000UL,
    90		0x00000000000bbeefUL, 0x0000000000000000UL,
    91		0x00000000000000efUL, 0x0000000000000000UL,
    92		0x0000000000001000UL, 0x0000000000000000UL,
    93		0x0000000000001001UL, 0x0000000000000000UL,
    94		0x0000000000001002UL, 0x0000000000000000UL,
    95		0x0000000000001003UL, 0x0000000000000000UL,
    96		0x0000000000001004UL, 0x0000000000000000UL,
    97		0x0000000000001005UL, 0x0000000000000000UL,
    98		0x0000000000001006UL, 0x0000000000000000UL,
    99		0x0000000000001007UL, 0x0000000000000000UL,
   100		0x0000000000001008UL, 0x0000000000000000UL,
   101		0x0000000000001009UL, 0x0000000000000000UL,
   102		0x000000000000100aUL, 0x0000000000000000UL,
   103		0x000000000000100bUL, 0x0000000000000000UL,
   104		0x000000000000100cUL, 0x0000000000000000UL,
   105		0x000000000000100dUL, 0x0000000000000000UL,
   106		0x000000000000100eUL, 0x0000000000000000UL,
   107		0x000000000000100fUL, 0x0000000000000000UL,
   108	};
   109	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

