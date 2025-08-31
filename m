Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F3B0CA0FE8
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 23:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E698E0005; Sun, 31 Aug 2025 19:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8980B8E0001; Sun, 31 Aug 2025 19:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786428E0005; Sun, 31 Aug 2025 19:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 61FBA8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 19:44:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 018861605B6
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:44:54 +0000 (UTC)
X-FDA: 83838685350.05.483CA1C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2548740004
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:44:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=COonwkza;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756683893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QOBIU1No0yNOCSJomcTNhrecA0zx1b/PEgtm9N0Hj4g=;
	b=dL9Rhx225Gk2rM2gs4BLtVXtFfIz7bUHVN4pNzejnEyYLjb1wVALIy15CkeSWPW4AsY7Hs
	l7fxOIxdtcGq/xYmpwlk39eYbAF4P3oBbV4Zk8ErUsJH/m7ERb0+tsCbDJfUS7NG19lkcp
	y/eRNcFXgdyIX3abNdUquIbZUvWcqwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756683893; a=rsa-sha256;
	cv=none;
	b=nAOE9h1pLRNKji/8eyIWfDDRqJx9/VEEPukeLPrA5uOOzI0BquMpJ1kU3ycKzNiOxjK6WI
	+ycAZp/htrSvi2suLv73TgQ/eO+3SJX3fcVI6zjwCyFCquHtugahIfc4jYqqzqa71lmwi+
	1yK2JWivzoOcyE172N1VR2kHET7v9QU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=COonwkza;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756683892; x=1788219892;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UXLiDHkaT0meCoGiGceT0OK9ByY2vye2ZhvRRbo1ZMY=;
  b=COonwkzapPtiyJrGhrb2HQdv1et83wg/poa4D+tQ3qqt9izjwD3gWInb
   84VZ0ZtvnaXrZ5/muRB8kKO9LyzcixEpY38cxa6d+fFKshSv2N/bRwlLH
   J63Aju4/A95P0C3G/JECKNKB2RdH+rwAxJ8QT/Hzrdr5gx3l/cPzcwZSS
   xtWV0sMvr3mHqPwtnvcizo/fIgxoVwwzeHqyEJ9DfLuz/0U3mW3KxKi2a
   w2DJDXJWrY0ZhZBQzklloauv6Jgjizcgw4F5Ns3W5/PobEqbaujhgdVER
   NbrX+ium3pfQbdACj8NxQES9PC+NC35PUTlddo9kYspIJycnZkfpt57Ae
   w==;
X-CSE-ConnectionGUID: VsdfF+0KTAKYoTfXqwJnXg==
X-CSE-MsgGUID: bdy6iW4zQrax0k6/Sz/XDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="69153877"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="69153877"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 16:44:51 -0700
X-CSE-ConnectionGUID: ceyKbt2UQfCozYp4uC63sg==
X-CSE-MsgGUID: 7657w8KNSuajTQaTsSvuvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="171620355"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 31 Aug 2025 16:44:46 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1usriW-000WPr-1b;
	Sun, 31 Aug 2025 23:44:30 +0000
Date: Mon, 1 Sep 2025 07:43:21 +0800
From: kernel test robot <lkp@intel.com>
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
	david@redhat.com, axelrasmussen@google.com, yuanchu@google.com,
	willy@infradead.org, hughd@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>
Subject: Re: [PATCH v2 08/12] arch, mm/util: add const to
 arch_pick_mmap_layout() parameter
Message-ID: <202509010724.bSPPSD1X-lkp@intel.com>
References: <20250831093918.2815332-9-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250831093918.2815332-9-max.kellermann@ionos.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2548740004
X-Stat-Signature: xmp9srqhba64opfgkagfzyxwjiz1f4ti
X-HE-Tag: 1756683891-462675
X-HE-Meta: U2FsdGVkX1+Ps7uUXRjWcLHrxNY6Mt3beGRnEJGGDeDID+2BBHRj1xxr622sNk/nxLK7IVxkBDgeP0GrAoyRW32k9b3Z5ZBtG9VpqmGxSjYwJlD+A+YXSm7qxqyZJ/9dCTsgTSnmw9a2w02uGZrZBQrpVeMuHuicrp4YCYF6iv7mVKEFQP6mnB+9YZnmFRNsNn8EDxdbGArr6l/BjeK1ccizvtzwxclnd+fTSufkM8MMRU39H7Rbp2IkdwbMkUVzHsMQG/pyG5ddebLGi4S2SjCoYh9UqW6GOC8xyH4OmdIVis/nyBVqcgPYvWAr0JLZlp7HExzb95r+wMo2HyZHKcAuU5/OGvgibgFXoEx0ikeXocLZ9Gns9syEVEWrC9ymKj4M7CitBJCNenz3XpXTl8gG5QJcPNBzAkSCEai5AK6AsezXva30M8Rqr405+wXt9RWA1sZfHb/PvmaqDBAGLwHQzUUgiN98mWw37agm/g27tuWSCMPBx99Z3kXPwrUlD3pLixfw2r8R7wkLcMB7Ad56Xa1iMva6R2FBSt+b8a0cin0kBxirK3/sUcW9azTFC8HFaNOsdnZNTTsPYPlpBDgCfzy03FDhBCFxckrsNvE64g2kYqAkd6XQ7F1nH7/pmazHy2lA5J8AdcxKcei+Sc+CU9FN4M5iFBy5M+HV5TiWPz1gVJofoqjCY2QKEQp7ZNto4sAJoyryIYLy3R/AqpGsvR6yLTL1mFoy45+PEHcZiHvZ+EL3riDG3iABateUyJzCIgpS0PjdCh9UZ7lxj9tDun7NRygVw0cOKR8jAYIRfEammT2Xm4gHdbJfZnrtP1pCaoW70PlH7bQiNlZvGjmUNU6AdMzK6DvsbR/zNGOXdwlcBO6jyXiE2hXnNdVYWZlejerEhJj5mA2UMwDFnhqCVrECUb4w4nw69eQwR5VdDviNvgUi7nSRCQxNQY4fc0GZkKymBYYvua1wCA8
 dzfR4gPV
 L7hoS2kMqPu45jfG1AvNsYUbwaVJUb/xScq8uMdGWCF2nJ+X6IkbrEUxLbb1eMykg1dOKdl5GChx15lqjc5KjTURTGi8rXre3aHOfBlOuCyo84/rBsZ7A1gvjOOlaGexbwnb/q7pmpZASIhnAy0BGKdD/Lx+XFz2+Tv4T4u8j41x0ysu4yKScJmR5Df8IaurisXas23U1g3+pYt1oS+UJVy2zZtwDqfD8AvL/wM+Uf2s0p0iGTkU43uDsiKgtFSHC495aMtR/kOnVuqDjAKG2n3T37GDw9PBgYB9IhgvihD0Kw4zpIdMx6uVFtZKgRdTFfvUd08SQmPrv61MN+FzY10Q1arQzQ+rT46Al2Vcv5mgKM/lPuepd2gqPx7WSEQUojeFgJFHXeIyQD09zapHIngrr+5Jrccnc6nnawB9BMIm7DM3nfPVPG5mJlFztX09lhkrKKaAqhSfGa8hVHVJakchtiODc7pmIhAaLqVYv8VrqZlElh/iyfKliTUemZ06C9mFggLvLLKJ6wEHIQqJYkufbhkCiD2mr5yle
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Max,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Max-Kellermann/mm-shmem-add-const-to-lots-of-pointer-parameters/20250831-174136
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250831093918.2815332-9-max.kellermann%40ionos.com
patch subject: [PATCH v2 08/12] arch, mm/util: add const to arch_pick_mmap_layout() parameter
config: sparc64-randconfig-001-20250901 (https://download.01.org/0day-ci/archive/20250901/202509010724.bSPPSD1X-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250901/202509010724.bSPPSD1X-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509010724.bSPPSD1X-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/sparc/kernel/sys_sparc_64.c:1:1: error: unknown type name 'ickj'
       1 | ickj// SPDX-License-Identifier: GPL-2.0
         | ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                                          ^         ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:116:5: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     116 |                         (set1->sig[1] == set2->sig[1]) &&
         |                          ^         ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:116:21: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     116 |                         (set1->sig[1] == set2->sig[1]) &&
         |                                          ^         ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:119:11: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     119 |                 return  (set1->sig[1] == set2->sig[1]) &&
         |                          ^         ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:119:27: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     119 |                 return  (set1->sig[1] == set2->sig[1]) &&
         |                                          ^         ~
   arch/sparc/include/uapi/asm/signal.h:113:8: note: array 'sig' declared here
     113 |        unsigned long sig[_NSIG_WORDS];
         |        ^
   In file included from arch/sparc/kernel/sys_sparc_64.c:11:
   In file included from include/linux/sched/signal.h:6:


vim +/ickj +1 arch/sparc/kernel/sys_sparc_64.c

   > 1	ickj// SPDX-License-Identifier: GPL-2.0
     2	/* linux/arch/sparc64/kernel/sys_sparc.c
     3	 *
     4	 * This file contains various random system calls that
     5	 * have a non-standard calling sequence on the Linux/sparc
     6	 * platform.
     7	 */
     8	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

