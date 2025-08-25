Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DD8CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 08:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60498E0006; Mon, 25 Aug 2025 04:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C118D8E0001; Mon, 25 Aug 2025 04:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26F98E0006; Mon, 25 Aug 2025 04:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD058E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 04:47:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2382A83848
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:47:37 +0000 (UTC)
X-FDA: 83814651354.27.1B6C191
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B94E40008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:47:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U4jFo8DY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756111655; a=rsa-sha256;
	cv=none;
	b=a7krQOXHIQduHtnF4mqSnL5MCcT35zM+1GEPNGzDJp+yR/ClTrqv5rJTU+Ch1apzb4vzK1
	Uo+3tbKdCr/4CuYgG8ubyKCwZQPv+swW6MxHXRcz2jSKrGoql7GLDQ+6hb/ZAiyiM9Gz9A
	SzKMgnup/2OHZn/q7DFl8NLuqs+Z56M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U4jFo8DY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756111655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QiXaIjpv1T0QzU0SF/TaUCYVoU6OeF8bD/T+Ozz1X2M=;
	b=seJjFGbnG1ssGYIr5K1PJUdbuc7H57HE5DHO+2MmnMNN4hMzlet2IM9yxb2OyMMC0CxdQm
	USDIJyIHVRyToZH+Sjaj7nQSqSmyWQTGXvS57VygMjYeLeMHPwy8mGQflv9yg+aLIQ1yPl
	SDys9dSkiqUBHQOLyKw66hGyt0zvJ1I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756111654; x=1787647654;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=myRCeTvxawajwk6mq1JjQrSHPOgouZjsTXSjcz0l9II=;
  b=U4jFo8DYlUQPyYV4UPqlMg7B8GzR1saTMqlZe8Y+Kh3QAibFRhb06YVj
   zXJsJEffA0GawqFfSbwhkciLwLJYDXRnDAKDnOnd75+/sX24Naxw+zq3H
   2LGU052+uDTKdf0Rf0YiFTUPbfOFJ2wJEe+fIOSit0mA+r7EOi97EBLsl
   aJxzc3M9ILcJlT+TdFySHVY8rjjR/LrjMa96kmlTWK8PkhqxWnb3URhEh
   PtsJzn4TWh3pryWgDnOFqdHqclQRGTihSy/hiWUON9v7VYAdbm/HiY1jP
   8SAShPeB/gwCHNeZ7pqIChoYjRxIdS5q/GwxeWntA+CSUvax70VyDU4Py
   Q==;
X-CSE-ConnectionGUID: mXOOodRqSeu7ue1IJ4H10w==
X-CSE-MsgGUID: t6b3QfH0Q1KULd42M0INjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="62133712"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62133712"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 01:47:32 -0700
X-CSE-ConnectionGUID: C2CRIJaVQh6BRgFpiHmxGw==
X-CSE-MsgGUID: EpVgtyxDQw+AhyRFP3wI4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="169133597"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 25 Aug 2025 01:47:31 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uqSrN-000NWz-32;
	Mon, 25 Aug 2025 08:47:28 +0000
Date: Mon, 25 Aug 2025 16:47:09 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Rohan McLure <rmclure@linux.ibm.com>
Subject: [akpm-mm:mm-unstable 137/202]
 arch/riscv/include/asm/pgtable.h:951:42: error: too many arguments to
 function call, expected 2, have 3
Message-ID: <202508251910.y6khnd73-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B94E40008
X-Stat-Signature: w3xzyhrf9pxwxgygjwym79eucqc4b4ik
X-HE-Tag: 1756111653-849493
X-HE-Meta: U2FsdGVkX1/i7KnierkYTYJOzS/EWqG8adiQgkK6WWLNiAwfAWY7b7IxA+RwLgYddatHNByz9A/FUib6fvmIqga13jrBba4fFsVMQKIpPqnpU4vqhHL160kVPlNaFr6kvAIPw8J5HBsO4ofthPMxrV7ir/1z5zR7Ll97GoRuaCbc4qpbmWopQnxgPm8XTpU+cZ/h+EkzUlFCMP84Tbb0r9uwt528wH/L+k6PJzvFgPQCEuXphykaQX9SMJLBg0kcV9+FBzUhGOnZq+8sADE6/LWV3Uivm2MRdnv6gi4oFV5nop9E08cRqv1nr75MT6zPufPfTqNmddxilaycBWH4rKe5FMqF2oM+cGYgB3TLtYyMgCWdhBTZWuuXlzGz+kHydluqEqJOePv0TETIkV87WKmM6oQ74twRlRJ16PQpOgU5hhev4qdb6MtxF3Y2QghRxqHa6Gwez8d5jqGAxquu0/1QVMOEgj0QQrynCh6yqrusZllMhHlntfkGbOdVKmJS59FBFHUlVCsWtp8Q0GLH95fYascwVMnVp5Nf/PzZEQoaKZjOjNCPKbHyqeyBRBQRFA5ikSc1+ALZeFBBTrw1QkkS3A19WeJJSXSAnmk6VEXTe7C8sv1AD8tGkNsMl72PuA1G6yVOjFXHaQPp3jL1Q8pIs0QbxgTcfLJiJVkR3g6PmSQgybj6y9jrSEpgwjEKLE2XkK7s4ge/i05n2YmUQnO7Hs2w0jL2DbhXsSbEuuslvhlw1/hiY55OiAy+74Tv4yXdsRj4nwWLVybGtSnBWwv8Zjy5OjDipGxpfhTfdOH/Fh5VSAAJfI6nhbvhWVamKDrW/5ZkrefLNRdb8yco0gtMVyovAfeB6ML4CbnkHLfL8EZB39S8EZ3rd5QsIJI8kuIVNGRulUF9F3kmK5fzg7kDLNlEeuMtdyYafaLxK95nHPgILt6HHwz2+Y49/tD6lHMaF1WXYOciLQsc40b
 4/ayMxsY
 nGXYLt4owdGZzcmsQxya11WQZ7FRI4ZbCVjMEg3tJ33liXbgshY+As+bwI7BKniUcR3nHW7yc4r1FrFIvgb+uSY8/E4tsfkBhW3Z0WfaFnaDB/W8kS0U69dv04YA/Qy4OaJg8mOzRD4uqV8aQa57G/I7vRGq7EtWOgyYXyCjDMB5yIc2zBIlTpNY8reW8oCN4GVQ5krQO7m/bHsLIxHvb9OiDt9QGjybgZHhzDg1Dpg8dOvObWQDNf6RPVQGM81vajRtTjG8hYwfcdhXHH99ZW71bzml1CAkKPgRvAKT18a27JtI1aHElrTRGEpp6nq3PXkcHCqOtKI4j1uDXdJReP3cSpZofy2GvL+C8LPv5eVVmkEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   20ada06259f5ba9c657c3098a15deec1f4c5687d
commit: 3b71766a08b70797f43fe9ea3e4eef1c2665ac8b [137/202] mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix
config: riscv-randconfig-001-20250825 (https://download.01.org/0day-ci/archive/20250825/202508251910.y6khnd73-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250825/202508251910.y6khnd73-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508251910.y6khnd73-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:31:
   In file included from include/linux/pgtable.h:6:
>> arch/riscv/include/asm/pgtable.h:951:42: error: too many arguments to function call, expected 2, have 3
     951 |         page_table_check_pud_clear(mm, address, pud);
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~              ^~~
   include/linux/page_table_check.h:125:20: note: 'page_table_check_pud_clear' declared here
     125 | static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
         |                    ^                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:116:5: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     116 |                         (set1->sig[1] == set2->sig[1]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:116:21: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]


vim +951 arch/riscv/include/asm/pgtable.h

   944	
   945	#define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
   946	static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
   947						    unsigned long address, pud_t *pudp)
   948	{
   949		pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
   950	
 > 951		page_table_check_pud_clear(mm, address, pud);
   952	
   953		return pud;
   954	}
   955	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

