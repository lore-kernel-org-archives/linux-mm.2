Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227FDC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 07:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C3D6B009B; Fri, 21 Aug 2026 03:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E216B009D; Fri, 21 Aug 2026 03:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB366B009F; Fri, 21 Aug 2026 03:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 830616B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:43:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF631C03A6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:43:01 +0000 (UTC)
X-FDA: 85124485362.28.A426A84
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf21.hostedemail.com (Postfix) with ESMTP id 297361C0007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:42:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e5lHnmGb;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787298180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zI6PwfqYS6EVdhNMrBqP37OD/s8/ZBSjVruvU/IlLOY=;
	b=NrXPmRcfcRZXPOAJ7eg8X2gXAq6XZOubYj5fgekYa2UMHV510rsAE9OmYVeFowntIhzEJ1
	yQMcgSxjRJV9bNWK/qVTIB9+QDcMRHS5Y9djRaGhxVEQimggoqbjbPdcaqfatqapMtyMtJ
	nOQFhT/dyjeImHNH3e62GfBeFhooqpk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e5lHnmGb;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787298180;
	b=dQ1p0HJT2O7C01vReejlpHonI6Ukswx4AHXLJDPuMOLk2s+Ekogu/zk2mGUzcK4CSh+PW0
	YIl9eDgLokQSnDmimfR4ZyA3ja0VBeJ2Bexi0yM4/KwBrt6+Ay48NnXP5LIDe/9C49ak6M
	R8pBf44hKvLw6biD6COXkWsnvlXqNUk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787298179; x=1818834179;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n92oaTwzuIDIlDAYFtjna6xrHmcjxCuUj+OIEvHizuI=;
  b=e5lHnmGb6SwB3JZQRvi5U+vw40i5Z+4Cod9zXvL330pnnx5NBNdtw+np
   S1R6a8H8TeE0EppGsP4qWrqxbE6MFnH5oWn2xO3ZUdbWXjb9X+zlYp+Im
   KobT+VM+bl0PBb/lNeN4DwqI0nxZZ+SrjsunRbyfeQT2wiHqlu/Y2NY97
   sr1I7f3rmaadDM7pToxo98m65hWWGowqMg2yfUyn02PLYSyBw6UWOgMxL
   vS9EFPIwpa+9UmUnTC6Ck3VL8BPJ3r5Sp4h5g7ysMG5H/7Ck8k31EPTgX
   Mw8U1SIno1wpTgyXYXr0UtnCAbSlGxcfg5isL6xlq4kiXz9v8yAdRZTZh
   Q==;
X-CSE-ConnectionGUID: nrPQU+JvReia2UTOXaK8Ig==
X-CSE-MsgGUID: f4OPdsX9TxaPSxwuYD2bIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="110631226"
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="110631226"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 00:42:58 -0700
X-CSE-ConnectionGUID: pxnUpv0zRjGJH6XSkLtgQA==
X-CSE-MsgGUID: tgZuX/ldSvuwoE4kDYuTFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="264983479"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 21 Aug 2026 00:42:54 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wxJtr-00000000pZJ-3EXX;
	Fri, 21 Aug 2026 07:42:51 +0000
Date: Fri, 21 Aug 2026 15:42:46 +0800
From: kernel test robot <lkp@intel.com>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: add per-order allocation slow path statistics
Message-ID: <202608211553.F2rJl3PW-lkp@intel.com>
References: <20260820133659.712111-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820133659.712111-1-d-tatianin@yandex-team.ru>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 297361C0007
X-Stat-Signature: qmf37tboei9e9bn3cny5ei34ew56ud4x
X-Rspam-User: 
X-HE-Tag: 1787298178-46848
X-HE-Meta: U2FsdGVkX1+sI4YO0nObEn96msALLm+bXyb8oEz8a6br/O25QcWedNkBokEOCVds1rfuN2SudUSJIIkM9yOEDmMurTBEe4yLuxAF85sKLgmRdQc7GYtcWOsEHjdFjqz0JorzvqGe6opv2r8P3YUFqPTQ5vgHHalg+ybU5IsDy0ymwgzvCK1KKv45jo976Fxf3k0lObeJc0cluJDLJ6Fg4a3ksxXQc3Hbg5ZqHof0UWWArUL9WS9QNjLADvp/DdrlP5TqbFLqZJ69/RUQMMBjy9En1dPeqfsY6xRl1VASgMj57sUshxUrlf9bZu8M0PBiF176XEGSq174zBNZOSQeQq89rpK1QrrQ38/ZXw9eeuGqfWAPnUImJl/O6NRbfFuuCZ1w6oEo9ZYkY9g3/ULhTRJjAIzWzZ9y8BBIHl8xSrfDumLE/6mFLT4FRihKTl3TOZuCl7Hcgy0yCfJsHkWZ+rNiTAxlBBkAuK23KP5y4H4fPi+SIOLADrn71I350EY4lP7Cq5FmZ+NQpdpVcJbB2+krCqp7NiYJPN+wrSGXmmmUY3kSkDwY8QWTFozsn1FsaAa12i6QcwPAqAKO4o1XvGPdqi3ILE2b+Q2k1cIRGCKANEcMzShMshwVmXGwZ4OAA4QppURWSd2WCSGsaB1BW3VL83+0yvBlhbUWNumSRYzSaOS+MpbgshZsnjWLVCzEENUpEUz55m5jttGkE/J6NugKuP5JCBKughYEn6xBoaNX/TKo4HiYy7I/unSMnRGBSS28JLFBsMlngLDfyZ8Fj/QxoEbiyM1tAUZole4ilUYNSGjMRY8/HmTW1PWp0nw2PEp7clNiND+cZqSFOXstFBjG5Ibq9FdtT/Nq+rRnvpLQLY1XqVzPmhpYmr5dV+OMFbUCyvb1Y4/kX6k1SRS8XwTplrFq8NbHRBduywIQEm4y9hJ/zPdQqtUYmusMGC4cv7ghdqbt0x/KFEnB6Bt
 f3wGH9qR
 Xy20eA4LtBipsncJz4lkkOTBtqUv7A3QxVB2YJ218f1OtcpP+v2WvMyUYo/SbXRrXQKx9SSWYgWCj7+le++PaozJ20MI3lBCBQIp7TncZhA9ETkLm+lwIJvqQke+dnCkJLeUQnEyG7sf4XrJAoJnxV6ADqMR26t0iyMoXQYf+nF/waOVhGWYkRHEnojnL7IMmKiV4GLzuv8OP3JzG1fursYRECUc9+gvz0ZG7GYKm+4ngXl+ctAyrgbTGanEHrDTzr8YH22Bml42xN0pU+kYea56C9Iz/yPbhGFjMdndNRUMu0Ygq1DwP5SiflWZFzW7yqjVQ9DyznJR4cD3yYr+Cvp/vqvfI8NJf6Z5LPR93cLEGY9RL5mco/fiChlpDJZbyhV5hW8Y/11xITE8ps6p4ffU3sqOuq8WI0hEw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Daniil,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.2]
[cannot apply to akpm-mm/mm-everything next-20260819]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniil-Tatianin/mm-vmstat-add-per-order-allocation-slow-path-statistics/20260820-163658
base:   linus/master
patch link:    https://lore.kernel.org/r/20260820133659.712111-1-d-tatianin%40yandex-team.ru
patch subject: [PATCH] mm/vmstat: add per-order allocation slow path statistics
config: sh-defconfig (https://download.01.org/0day-ci/archive/20260821/202608211553.F2rJl3PW-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260821/202608211553.F2rJl3PW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608211553.F2rJl3PW-lkp@intel.com/

All errors (new ones prefixed by >>):

    1537 |         TEXTS_FOR_ORDERS(PGALLOC_FAIL_ORDER_FIRST, "pgalloc_fail_order")
         |         ^~~~~~~~~~~~~~~~
   mm/vmstat.c:1537:52: warning: initialized field overwritten [-Woverride-init]
    1537 |         TEXTS_FOR_ORDERS(PGALLOC_FAIL_ORDER_FIRST, "pgalloc_fail_order")
         |                                                    ^~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1215:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1215 |         [I((xx) + 3)] = yy "3",                 \
         |                         ^~
   mm/vmstat.c:1537:9: note: in expansion of macro 'TEXTS_FOR_ORDERS'
    1537 |         TEXTS_FOR_ORDERS(PGALLOC_FAIL_ORDER_FIRST, "pgalloc_fail_order")
         |         ^~~~~~~~~~~~~~~~
   mm/vmstat.c:1537:52: note: (near initialization for 'vmstat_text[156]')
   mm/vmstat.c:1215:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1215 |         [I((xx) + 3)] = yy "3",                 \
         |                         ^~
   mm/vmstat.c:1537:9: note: in expansion of macro 'TEXTS_FOR_ORDERS'
    1537 |         TEXTS_FOR_ORDERS(PGALLOC_FAIL_ORDER_FIRST, "pgalloc_fail_order")
         |         ^~~~~~~~~~~~~~~~
   mm/vmstat.c:1540:34: warning: initialized field overwritten [-Woverride-init]
    1540 |                                  "compact_stall_order")
         |                                  ^~~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1213:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1213 |         [I((xx) + 1)] = yy "1",                 \
         |                         ^~
   mm/vmstat.c:1540:34: note: (near initialization for 'vmstat_text[160]')
   mm/vmstat.c:1213:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1213 |         [I((xx) + 1)] = yy "1",                 \
         |                         ^~
   mm/vmstat.c:1540:34: warning: initialized field overwritten [-Woverride-init]
    1540 |                                  "compact_stall_order")
         |                                  ^~~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1214:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1214 |         [I((xx) + 2)] = yy "2",                 \
         |                         ^~
   mm/vmstat.c:1540:34: note: (near initialization for 'vmstat_text[161]')
   mm/vmstat.c:1214:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1214 |         [I((xx) + 2)] = yy "2",                 \
         |                         ^~
   mm/vmstat.c:1540:34: warning: initialized field overwritten [-Woverride-init]
    1540 |                                  "compact_stall_order")
         |                                  ^~~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1215:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1215 |         [I((xx) + 3)] = yy "3",                 \
         |                         ^~
   mm/vmstat.c:1540:34: note: (near initialization for 'vmstat_text[162]')
   mm/vmstat.c:1215:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1215 |         [I((xx) + 3)] = yy "3",                 \
         |                         ^~
   mm/vmstat.c:1540:34: warning: initialized field overwritten [-Woverride-init]
    1540 |                                  "compact_stall_order")
         |                                  ^~~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1216:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1216 |         [I((xx) + 4)] = yy "4",                 \
         |                         ^~
   mm/vmstat.c:1540:34: note: (near initialization for 'vmstat_text[163]')
   mm/vmstat.c:1216:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1216 |         [I((xx) + 4)] = yy "4",                 \
         |                         ^~
   mm/vmstat.c:1542:34: warning: initialized field overwritten [-Woverride-init]
    1542 |                                  "compact_success_order")
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1213:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1213 |         [I((xx) + 1)] = yy "1",                 \
         |                         ^~
   mm/vmstat.c:1542:34: note: (near initialization for 'vmstat_text[166]')
   mm/vmstat.c:1213:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1213 |         [I((xx) + 1)] = yy "1",                 \
         |                         ^~
   mm/vmstat.c:1542:34: warning: initialized field overwritten [-Woverride-init]
    1542 |                                  "compact_success_order")
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1214:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1214 |         [I((xx) + 2)] = yy "2",                 \
         |                         ^~
   mm/vmstat.c:1542:34: note: (near initialization for 'vmstat_text[167]')
   mm/vmstat.c:1214:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1214 |         [I((xx) + 2)] = yy "2",                 \
         |                         ^~
   mm/vmstat.c:1542:34: warning: initialized field overwritten [-Woverride-init]
    1542 |                                  "compact_success_order")
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1215:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1215 |         [I((xx) + 3)] = yy "3",                 \
         |                         ^~
   mm/vmstat.c:1542:34: note: (near initialization for 'vmstat_text[168]')
   mm/vmstat.c:1215:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1215 |         [I((xx) + 3)] = yy "3",                 \
         |                         ^~
   mm/vmstat.c:1542:34: warning: initialized field overwritten [-Woverride-init]
    1542 |                                  "compact_success_order")
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~
   mm/vmstat.c:1216:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1216 |         [I((xx) + 4)] = yy "4",                 \
         |                         ^~
   mm/vmstat.c:1542:34: note: (near initialization for 'vmstat_text[169]')
   mm/vmstat.c:1216:25: note: in definition of macro 'TEXTS_FOR_NONZERO_ORDERS'
    1216 |         [I((xx) + 4)] = yy "4",                 \
         |                         ^~
   In file included from <command-line>:
   mm/vmstat.c: In function 'vmstat_start':
>> include/linux/compiler_types.h:702:45: error: call to '__compiletime_assert_467' declared with attribute error: BUILD_BUG_ON failed: ARRAY_SIZE(vmstat_text) != NR_VMSTAT_ITEMS
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:683:25: note: in definition of macro '__compiletime_assert'
     683 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
      40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:51:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      51 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   mm/vmstat.c:1941:9: note: in expansion of macro 'BUILD_BUG_ON'
    1941 |         BUILD_BUG_ON(ARRAY_SIZE(vmstat_text) != NR_VMSTAT_ITEMS);
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_467 +702 include/linux/compiler_types.h

eb5c2d4b45e3d2d Will Deacon 2020-07-21  688  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  689  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21  690  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  691  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  692  /**
eb5c2d4b45e3d2d Will Deacon 2020-07-21  693   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  694   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d Will Deacon 2020-07-21  695   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  696   *
eb5c2d4b45e3d2d Will Deacon 2020-07-21  697   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  698   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  699   * compiler has support to do so.
eb5c2d4b45e3d2d Will Deacon 2020-07-21  700   */
eb5c2d4b45e3d2d Will Deacon 2020-07-21  701  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21 @702  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  703  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

