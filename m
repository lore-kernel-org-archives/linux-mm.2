Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7DBCD6E42
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 12:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A008E0006; Thu, 13 Nov 2025 07:27:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531EE8E0002; Thu, 13 Nov 2025 07:27:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447ED8E0006; Thu, 13 Nov 2025 07:27:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0158E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:27:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCFBA5B255
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:27:16 +0000 (UTC)
X-FDA: 84105508872.25.5BCD99F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id 18A1540002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:27:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YQpBYnGZ;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763036834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MG9mjuEhGeEtzIVSpWfSYzFuQHXulaKesRtBtySwQCM=;
	b=JbQPgVxirN534cFxL7w3euL7B/HCh6OppzRZ+PwbZMGqP7DAoCL1ITAre39MdOatkenE5e
	WSaVdco3myYDwgyWuIALSy8w4cXYTklnvmABNvjmbQC1C4RpzLTfzmE1Br5fZ7TKhNAe/f
	u8Uswt0InPS7izs6Dqvdn41Sg5KpDmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763036834; a=rsa-sha256;
	cv=none;
	b=bSUK8ZRedjn7HYDogUnRNuyBqZAgY0zzZfdx1BF28Kw4IvZ8FmBf1Abl1d8obHikbxtkei
	WbgxNmNTNDaYg2bc2pEvi7V6GBYchtcKj8B7oc+WQg7V4D+ZKV34esxD4tSS0TOWSDjG43
	kMPQWj3DTYncUIX6DX92RDhmUkxxmtM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YQpBYnGZ;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763036834; x=1794572834;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=9YKDJvqo43CiDTABoeX6SOfBTdvF1QGBBQkMMDUt4oA=;
  b=YQpBYnGZEy6o+E43IVTrqOdweQhuR7GmHN5CYPbktE8JmN8rLwjdARxo
   38zFLtBDRx6u39Xa819nMxW3XccRIyd7bDVltO9C4Fs/nLH8duGM2nw7J
   6MORVdl653SqB5Bmm79EOWKaBzjgO9UoHGdRUNTxmlehcEp5PVc4Ke7Sn
   GRTh7KEYNrNCrOcYbkmobrUUpxB/8Pe0vNb1trbwWLxlBaR5zZgJkUpp/
   J1auCSHEJWu5YpTLunop3FnGlr6hSZHalQNEuloIHXtY+8GgD4m3vpURV
   rK05ALzvzn/MbQnOLtcYm+c56aH8jxnPwyutgSlW1MvPwHYRfqb9SnY4j
   g==;
X-CSE-ConnectionGUID: mvkMkmMTS1CgEIO5bF/HzA==
X-CSE-MsgGUID: XWtvg2b2SgOTGSHRysjyPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="75793366"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="75793366"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 04:27:12 -0800
X-CSE-ConnectionGUID: CwEwsBPdQf+Q52xtV60pbQ==
X-CSE-MsgGUID: f5N/fGfJQ0+9LoLGf+QsDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="226789280"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 13 Nov 2025 04:27:11 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJWPs-0005Jn-1a;
	Thu, 13 Nov 2025 12:27:08 +0000
Date: Thu, 13 Nov 2025 20:26:42 +0800
From: kernel test robot <lkp@intel.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 36/283] include/uapi/linux/const.h:20:25:
 warning: conversion from 'long long unsigned int' to 'long unsigned int'
 changes value from '17179869184' to '0'
Message-ID: <202511132024.tfRZgB5P-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 18A1540002
X-Stat-Signature: xn7myeft9rzx6ms7q4aftbw5x9r8tquy
X-HE-Tag: 1763036833-406746
X-HE-Meta: U2FsdGVkX19JkEXLYFM+h51zZFLfvYsnydUdig0aaafw11Oeu7YKEK2pIAxOuHgKvZH98MCAldfNG6gvpjmE7pAaos35BAXW1NErdZHUrQ6Yyre+i2oUiKqauiFV6owAH3XItaet21l8sjpAdDL0RQqDn4GP+rTKu0ONN+XrkuonEq02DlsP1tkkLvaLpnUEU+HDaFbMqGEjb9KdNGPM5kYzGZWUzeQ3q2bVci0Tm59oBZ4ex/2XqSDWQh/B8EwGx02ZdTYEc5JmSYMql6nXOEDw6mYgJIF9MECrhe5ZEga14gYkKmdYdWY0QR1b/9vEE5bRT+Qh8mdh3KiPIQFZXtaJeODrmwDpkxojiw/h4UFScHuZRwaCfQZL5yYxviJMKrTEL5j7lYeYGNITL3GyJ2AdzzEFGRhNTq8RaErVQr2SmsXz3ATtz2K+fbVY20D414DIL50uIlhq8gED28CgcjwTXtJLn0if2DJRd4VTIkLvAZwFQTwNGpwl/5UMFx7sk/1Kfn0hT3pCOxTpQgkl0uK5i6vfj9C9xStCmFvrGklhr9s3V9qx555zXYweHUrnIWBrNOfIwArv5NlL7ULDO3P581qkJXF39UbxlNSDtmKfNNsCeyVOQHa+NC2JFHHkb1F61Xa+avLHjWhY6v6viFq6ERCey6rC6OPS3Ig5pebwnLUUqiQq1PrFc4BlNK/utrytfz9vNF6FdwM3TCV+Em6+wx+2cqIZx2KPSVAuQFYv0DPGJ65435iSzBa2JpioS67Oyq2EKfu7bou9FOK5X2zYq2py1E9BHHSLx1xypj+I/KJSZ0iSaX3YuoneUFn/XeAM4Ba38t6RuLQ+AnCcm61huLpNiN9fwOOpZUjGnHivuX5QVzA8NdJnkGL+9Z4Nk7ovBv39O0Vy5sb/+8eUWJSkG51yyAhRcqYMmwSuKBqp8Nrb50VLHT1Lv6WEsqWFr+TEj/RfK8Cbp1g3W3S
 tWel8yU3
 FKLbG1IpF1qTGMdlkcsAV6ujRGBT7B6Mn5KEFQKwhP/7SbfE/8dRxrOMpSgJoo+zSMJ25QFe86uDhYQjzR0Dn5Hu7X9c771iF3bJdsIIiQBByPI3f/t7hG6JwmwSq08rNU4rgLfJfdLrSbakq9p2Ekktl2gJF87R3/zBzbrVYdNPEdQFLqzUaOZu5M9SQu5nx0Y6l1eHOBvu6RG8luOI3g3SK1jkf1aC+t+WeRmWHOfMKYFO3bHDIlWQ10/yPzNfph/6BnH9ik1oZraNA3sMZldNGXyrEralCIzYm0LqdYp8QSCAxjJdj3Iqij61B9AACFFGz6RU+ysSxX3pxxSEtX1UM2afvuXfHjB+lhNyJbV4eSv2z1fhdnqHsVPwVOx5cYQboOjb73g1LJWK0xGdQliIxu5maGRkg9EDD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   f58b4cb6b0c11172a25c2ade23477f55596d7138
commit: 2f6ff71280ffddb27ad7174d24f573e2683870cd [36/283] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
config: sh-randconfig-002-20251113 (https://download.01.org/0day-ci/archive/20251113/202511132024.tfRZgB5P-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251113/202511132024.tfRZgB5P-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511132024.tfRZgB5P-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from include/linux/migrate.h:5,
                    from mm/migrate.c:16:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   {standard input}: Assembler messages:
   {standard input}:346: Error: offset to unaligned destination
   {standard input}:9897: Error: offset to unaligned destination
--
   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/vfsdebug.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/backing-dev.h:13,
                    from mm/vma_internal.h:12,
                    from mm/vma_init.c:8:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
--
   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/current.h:6,
                    from ./arch/sh/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from include/linux/rcupdate.h:27,
                    from include/linux/rculist.h:11,
                    from include/linux/sched/signal.h:5,
                    from include/linux/oom.h:6,
                    from mm/oom_kill.c:21:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   {standard input}: Assembler messages:
   {standard input}:6594: Error: offset to unaligned destination
   {standard input}:6866: Error: offset to unaligned destination
--
   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/vfsdebug.h:5,
                    from include/linux/fs.h:5,
                    from mm/shmem.c:24:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   {standard input}: Assembler messages:
   {standard input}:4979: Error: offset to unaligned destination
   {standard input}:5987: Error: offset to unaligned destination
--
   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from mm/ksm.c:17:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   {standard input}: Assembler messages:
   {standard input}:14481: Error: offset to unaligned destination
--
   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/sh/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from mm/mmap.c:13:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   {standard input}: Assembler messages:
   {standard input}:4912: Error: offset to unaligned destination
--
   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from mm/page_alloc.c:19:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   mm/page_alloc.c: In function 'alloc_contig_range_noprof':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/page_alloc.c:6910:61: note: in expansion of macro 'MAX_FOLIO_ORDER'
    6910 |         if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
         |                                                             ^~~~~~~~~~~~~~~
--
   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/vfsdebug.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/backing-dev.h:13,
                    from mm/truncate.c:12:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   {standard input}: Assembler messages:
   {standard input}:1964: Error: offset to unaligned destination
--
   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from mm/hugetlb.c:8:
   mm/internal.h: In function 'folio_set_order':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |         ^~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
     758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   In file included from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from mm/hugetlb.c:8:
   mm/hugetlb.c: In function 'hugetlb_add_hstate':
>> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
      20 | #define __AC(X,Y)       (X##Y)
         |                         ^~~~~~
   arch/sh/include/asm/bug.h:69:32: note: in definition of macro 'WARN_ON'
      69 |         int __ret_warn_on = !!(x);                              \
         |                                ^
   include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~
   include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~
   include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                           ^~~~~~
   mm/hugetlb.c:4753:25: note: in expansion of macro 'MAX_FOLIO_ORDER'
    4753 |         WARN_ON(order > MAX_FOLIO_ORDER);
         |                         ^~~~~~~~~~~~~~~
   {standard input}: Assembler messages:
   {standard input}:10762: Error: offset to unaligned destination
   {standard input}:11421: Error: offset to unaligned destination
   {standard input}:15615: Error: offset to unaligned destination
..


vim +20 include/uapi/linux/const.h

9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02   6  
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02   7  /* Some constant macros are used in both assembler and
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02   8   * C code.  Therefore we cannot annotate them always with
6df95fd7ad9a84 include/linux/const.h      Randy Dunlap        2007-05-08   9   * 'UL' and other type specifiers unilaterally.  We
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  10   * use the following macros to deal with this.
74ef649fe847fd include/linux/const.h      Jeremy Fitzhardinge 2008-01-30  11   *
74ef649fe847fd include/linux/const.h      Jeremy Fitzhardinge 2008-01-30  12   * Similarly, _AT() will cast an expression with a type in C, but
74ef649fe847fd include/linux/const.h      Jeremy Fitzhardinge 2008-01-30  13   * leave it unchanged in asm.
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  14   */
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  15  
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  16  #ifdef __ASSEMBLY__
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  17  #define _AC(X,Y)	X
74ef649fe847fd include/linux/const.h      Jeremy Fitzhardinge 2008-01-30  18  #define _AT(T,X)	X
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  19  #else
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02 @20  #define __AC(X,Y)	(X##Y)
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  21  #define _AC(X,Y)	__AC(X,Y)
74ef649fe847fd include/linux/const.h      Jeremy Fitzhardinge 2008-01-30  22  #define _AT(T,X)	((T)(X))
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  23  #endif
9d291e787b2b71 include/asm-x86_64/const.h Vivek Goyal         2007-05-02  24  

:::::: The code at line 20 was first introduced by commit
:::::: 9d291e787b2b71d1b57e5fbb24ba9c70e748ed84 [PATCH] x86-64: Assembly safe page.h and pgtable.h

:::::: TO: Vivek Goyal <vgoyal@in.ibm.com>
:::::: CC: Andi Kleen <andi@basil.nowhere.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

