Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3534AC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51326B008A; Thu, 10 Sep 2026 18:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01726B008C; Thu, 10 Sep 2026 18:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CFD6B0092; Thu, 10 Sep 2026 18:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 945E06B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:12:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E03D71402D0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:12:45 +0000 (UTC)
X-FDA: 85199253090.07.7A08007
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf02.hostedemail.com (Postfix) with ESMTP id E455B80008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:12:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NE4okeLt;
	spf=temperror (imf02.hostedemail.com: error in processing during lookup of lkp@intel.com: DNS error) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789078364;
	b=5FkwuOuljhBVuRlcm9Xs3NdJCzTZzk7VEqdS0fyTITdki4l8s0hGwkI4+kXLWmeq6cSWVe
	AXw6boZAXwfPITs3bbzv43vN2RR2eCbbngbbmYdKwwop9hECc3tbAI2rKC9E/8X3JV/Wsa
	2rYaHn6kP1dAWGhOPdcuS+ASKPv9BEg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NE4okeLt;
	spf=temperror (imf02.hostedemail.com: error in processing during lookup of lkp@intel.com: DNS error) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789078364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Vz+ZzGUEPVhyxyWH+ySXaEyNB+ahs1758mxnioQr8x4=;
	b=EDS1tldZEkY86apwi90MDSAiAow+7I9AD2jZC74y14J3dr0W9ZEakgAVwYbvMPPis6DxWd
	mulv5TWdLvhsJpNZNnJnV5OW9oMwwQoEC83a5ouIq4bLIseob8vL+mnchM2nBCOfoDEeCq
	lAlAdoqq4xd/BuHC+n69nZk4qoa/AXY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789078359; x=1820614359;
  h=date:from:to:cc:subject:message-id;
  bh=nNF9sBELwbR1ayruD0KyBbwDZBbIP7B3gFKpePKCzJQ=;
  b=NE4okeLtDSfeJ3ocPbXXHlceNpj9Qe2Yx7wpDnVV0IWyDRUUnzcw+vCw
   PzjGDRgkwJE5XBxIEzGlAMbITnIHMRQ7jQqJJzsI68SM4uUwwiThSJtib
   9KFsYw0ge5dbCuSx4ZsynT647U5/BxX3LSda0B5YEr1+1PjwtGSkxBVsB
   S4vqBK4FvFevVTgVwJJXaZAjzbnzvtLODaX8NXCa7C+eqEHK4jgPMRcjz
   14VfFqLC37TXNLuoPsGwXkMAoctR6CzbRbOCfVxszmgTk3e8muZoUP/XW
   Mx76RWInMZAWrImlzJrAL7vVKsiP/h6so6P2KzjRj1QIimEZqgQmT5VQk
   g==;
X-CSE-ConnectionGUID: /bGHq9PmTlaByRrYa5n+pg==
X-CSE-MsgGUID: TOwHiJuHSh259x34HGLTBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89666450"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="89666450"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 15:12:36 -0700
X-CSE-ConnectionGUID: gkfCVZwpTsKOBF6vIto9Xg==
X-CSE-MsgGUID: UD4uJhQpSGaHeLZFvlRBRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="310002104"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 10 Sep 2026 15:12:34 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4mzG-000000000aT-2tI0;
	Thu, 10 Sep 2026 22:11:38 +0000
Date: Fri, 11 Sep 2026 06:07:30 +0800
From: kernel test robot <lkp@intel.com>
To: "Kuan-Wei Chiu" <visitorckw@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "Guan-Chun Wu" <409411716@gms.tku.edu.tw>,
 David Laight <david.laight.linux@gmail.com>
Subject: lib/base64.c:58:18: warning: implicit conversion from 'int'
 to 's8' (aka 'signed char') changes value from 131 to -125
Message-ID: <202609110514.S0a0FD6a-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E455B80008
X-Rspam-User: 
X-Stat-Signature: afem459ncryhqx4j97ncdc89g1gbehfn
X-HE-Tag: 1789078358-440071
X-HE-Meta: U2FsdGVkX18LmG7r5MpvcnPL+OnY821QE6JnY4YKYUTCz5++2p5H4pGBcNHlt+woD/4NvyLIucas6xGSSMoHYLNE6zrorpIzh4wUO/ZCmA4MxswppaH1LfYRgYh54/LEYQRBTBfsgNVrUSjF5U0F2gub12rhINGg8BUz7NMcwVjsEnDye+AOuYmin97/QNX+/vuSnXuJwnGSBgRdaJaMgr4Q0kWZhucMXtUv6oYjVfGufMQLgFDbJYHxtKbvIWVJUH9gR6cnS8adXUpoGxHs1lQocRIHCg/3BKc9CG33DJ79KmDDC/5osYiAA9dQlB5tvAwQGWVQEHOoxevguDprBMs3PK9W6bMYvivSVhji7yFx8HrR/fK2Ukcz5zXgFZseVYBIskjjz+nZCcbVEx8skJCMeNJj66X1N35f6qKAFzDYLRVhQU0xrAPJOMOG//66hgPPS0bMDNuozF5ZXfHUmrt6Zp+PZIeYbsGjruiIrY/g9AXtWIl1EZiqPF9n2oTQUSZt4sDwoUj3Xk2KJb/5NvjJHrMRD7ICA2/l96snyjcL72mqCo3VCyy9jGHzNQ0rMKAAPUICn+2pAaQo2ILibCGq9JdJnpwDToCoTQpI91j6t5srxTcU/wP/8Xxf9VEDeCrFICN9dEMbgk2WvXqL543lS/gwZR0esuo+9RjfS8Ikt64Wl8cMKJ2ez2wdGH6s9iq27T4RiGjQzUlTew24oP3pvYHNsocVEGLU/TZsi236WT1OdfMgdG50rjYT6sdgbZ6m8PNS3e2fDQoSnn5BR7hZhOkam4ReJrIZma0Y6ZePEEZucI7unZ1aULbZK1pw27iCi8PzxW5iA9cPys2QCnjD9dWGGUrMPv6ps20YvcR6IQVjnYUrBAEmVAstGq9eACecKP0AS7en9KQJX2QO2taDdXHek2yNh59e3Y68irNNUWEOZF1J4hZ5WlfjWKUHDd3xF+x9J+U7BHHYK+M
 ffLc2kDO
 H/HoSH183t9exAwnHJuOM6sZbDX+SzraKbqWzRvGKftnD3m/FzoBC1yM4A1sftzmRHOZWtzQ3XKrAqpJJ9vMuDMIpPaAsP9+JByNuZKvA+ownVvg2m2OWjzG3QsgMuN79I6cJMeiEGMTRCRs12dQCj1FwbZo3arBNSZqpIXrqyFDucTrotqCibtFa5tfD4MOV9eewjDy0WOQxaV4MrWBd2pol/XS6I9p+aJfklsBcQ2FtE2kXrsba85QQHtR5moJMH1/IknJ4cNdz1/n+/pOF+FRJZUwNWXp3PLtEGwn33rZoNIS13HfMn6Xa5x3qhqhkD1N0PWAqaEsaipKHind6KVQN3Vl8vObPVN38O6BnaDbPZyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   50d05c7c76c96b90462f24debacca971d2e86713
commit: c4eb7ad32eab13ba64cc452c6f43d518b63f5e03 lib/base64: optimize base64_decode() with reverse lookup tables
date:   10 months ago
config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20260911/202609110514.S0a0FD6a-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project d3db069999553568848400c84cbf815c03f5470f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260911/202609110514.S0a0FD6a-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: c4eb7ad32eab ("lib/base64: optimize base64_decode() with reverse lookup tables")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609110514.S0a0FD6a-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 131 to -125 [-Wconstant-conversion]
      58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
      48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
         |                                       ~
      49 |         [0 ... 0x1f] = -1, \
      50 |         INIT_32(0x20, ch_62, ch_63), \
      51 |         INIT_32(0x40, ch_62, ch_63), \
      52 |         INIT_32(0x60, ch_62, ch_63), \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:46:50: note: expanded from macro 'INIT_32'
      46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
         |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:45:49: note: expanded from macro 'INIT_16'
      45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
         |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   lib/base64.c:43:48: note: expanded from macro 'INIT_4'
      43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
         |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:42:48: note: expanded from macro 'INIT_2'
      42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
         |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:34:42: note: expanded from macro 'INIT_1'
      34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
         |                                              ~~~~~~~~~~^~~~
   lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 130 to -126 [-Wconstant-conversion]
      58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
      48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
         |                                       ~
      49 |         [0 ... 0x1f] = -1, \
      50 |         INIT_32(0x20, ch_62, ch_63), \
      51 |         INIT_32(0x40, ch_62, ch_63), \
      52 |         INIT_32(0x60, ch_62, ch_63), \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:46:50: note: expanded from macro 'INIT_32'
      46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
         |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:45:49: note: expanded from macro 'INIT_16'
      45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
         |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   lib/base64.c:43:48: note: expanded from macro 'INIT_4'
      43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
         |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:42:24: note: expanded from macro 'INIT_2'
      42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
         |                        ^~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:34:42: note: expanded from macro 'INIT_1'
      34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
         |                                              ~~~~~~~~~~^~~~
   lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 129 to -127 [-Wconstant-conversion]
      58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
      48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
         |                                       ~
      49 |         [0 ... 0x1f] = -1, \
      50 |         INIT_32(0x20, ch_62, ch_63), \
      51 |         INIT_32(0x40, ch_62, ch_63), \
      52 |         INIT_32(0x60, ch_62, ch_63), \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:46:50: note: expanded from macro 'INIT_32'
      46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
         |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:45:49: note: expanded from macro 'INIT_16'
      45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
         |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   lib/base64.c:43:24: note: expanded from macro 'INIT_4'
      43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
         |                        ^~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:42:48: note: expanded from macro 'INIT_2'
      42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
         |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:34:42: note: expanded from macro 'INIT_1'
      34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
         |                                              ~~~~~~~~~~^~~~
   lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 128 to -128 [-Wconstant-conversion]
      58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
      48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
         |                                       ~
      49 |         [0 ... 0x1f] = -1, \
      50 |         INIT_32(0x20, ch_62, ch_63), \
      51 |         INIT_32(0x40, ch_62, ch_63), \
      52 |         INIT_32(0x60, ch_62, ch_63), \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:46:50: note: expanded from macro 'INIT_32'
      46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
         |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/base64.c:45:49: note: expanded from macro 'INIT_16'
      45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
         |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   lib/base64.c:43:24: note: expanded from macro 'INIT_4'
      43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)


vim +58 lib/base64.c

    47	
    48	#define BASE64_REV_INIT(ch_62, ch_63) { \
    49		[0 ... 0x1f] = -1, \
    50		INIT_32(0x20, ch_62, ch_63), \
    51		INIT_32(0x40, ch_62, ch_63), \
    52		INIT_32(0x60, ch_62, ch_63), \
    53		[0x80 ... 0xff] = -1 }
    54	
    55	static const s8 base64_rev_maps[][256] = {
    56		[BASE64_STD] = BASE64_REV_INIT('+', '/'),
    57		[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
  > 58		[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
    59	};
    60	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

