Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FBEA1076377
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 06:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6FB6B0088; Wed,  1 Apr 2026 02:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE606B0089; Wed,  1 Apr 2026 02:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B226B008A; Wed,  1 Apr 2026 02:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 528656B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:36:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D94B759B17
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:36:40 +0000 (UTC)
X-FDA: 84609028560.11.08C754B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5AB4A18000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:36:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dGeZguIX;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775025399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=xUFrxi4EN62Or/82RhvALu5rDGlQEVn9RB1olJSTjDA=;
	b=e5v8YY1bmpqxyC1JJ9pqSCxrfgezU6VN1ctBT6bMZWiz+UnHAd/SgVm5FtkE4Rph6fPX7/
	hnWh61WGwHQdN56txEXeersnamljS7jwkrNxxnxQ+3gChTfBfmMMzlSqX2WrbtwcPrRcH2
	NJ4INXtnZHZevHqdt6g63c5xsQmRgt0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dGeZguIX;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775025399; a=rsa-sha256;
	cv=none;
	b=ki+ExLmabnG2F9G/e1fSnFpMlGIlspjmdeNiKcfhP2LHm/26JTqLfz58CCgqrzJVPFEzqc
	mXSWl93ku6cnUWYDR4OsLyxDkU1JH2ePwlB9xyzoC83q4gVcm1gBhcg8tdpbqoMuOrEayh
	FI1uiHIsmZOhZlFLOM44fa4sWopmPGA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775025399; x=1806561399;
  h=date:from:to:cc:subject:message-id;
  bh=QGGQ/Hfa2CU6Z1TD0eYjfEEz/2jPVQelhv8NmTuZqlU=;
  b=dGeZguIX0q8nvF66H35C8H0JeaDomzFQZi49JgRgzpoTksMA0QqQa7hp
   9eHPzDgKpoGR/t2SgfOL+3iOILwKiRkKI4iJfPxWO10zIU/sQjmf3qrSz
   /t9kz5IcQPrUtPy4OzhhN9MTejVsW9DfzEmByS+2ATrxQqwPODnNk0kkH
   OK/REJ2cCT9hphdItRLAhCwgs5pYWEVkuiqV6Wx+LvWAYEqaJxy+boXHC
   RdV8/ipvyuAf/oi+j1q5EBBqKPNh4KEynbLkZEOrPH47GUGWtKnRfgAQB
   Mb6TpL82BVsKnGkKF6kbEzCkY85BoQVj7dhvdMhCItCwJ2bwt6yylFgyS
   w==;
X-CSE-ConnectionGUID: eYSZIhJ0S1G6vmf2CbvIAQ==
X-CSE-MsgGUID: kS73e8uoQi6bvOvJnH5SJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="87514019"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="87514019"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 23:36:37 -0700
X-CSE-ConnectionGUID: vXeGyT6wRp6q3MTLXB2nCw==
X-CSE-MsgGUID: /is4+eUyQsGdwTc92iPQRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="249805329"
Received: from lkp-server01.sh.intel.com (HELO 699e4e600a11) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 31 Mar 2026 23:36:35 -0700
Received: from kbuild by 699e4e600a11 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7pBo-0000000002j-1OO6;
	Wed, 01 Apr 2026 06:36:32 +0000
Date: Wed, 01 Apr 2026 14:36:28 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 124/135]
 include/linux/compiler_types.h:706:45: error: call to
 '__compiletime_assert_350' declared with attribute error: BUILD_BUG_ON
 failed: SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + __ffs(sizeof(struct
 page)), PAGE_SHIFT)
Message-ID: <202604011400.OFLcOOmf-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: 7waxsahywtek85ejni475k1zap6b81fp
X-Rspamd-Queue-Id: 5AB4A18000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1775025398-526380
X-HE-Meta: U2FsdGVkX1/x1RvmlU7oJsOrvbI8bWn0FC/7xnJqrls//tOQRsD+hFoC9t/PhEUcWJGIx4N3B2huNeJh0iEOOI58wS6SyjbPAwGsWWNAUwDVzdr3m7+Y9b8ozpqJar5x64ZiwHWitrFWPv3jxdy1vD0Hw/D8UtpIORKH/Hrpga9D3sgzrWUzxG0MMWmKtU1aGcswEOxrBkQjQoYtRNNWE1PIm3m/9ZX+utOHQodrLIwtLgoA1J2hUzToASkK0LKNM1eS46VlwEhe0Zy+ptxAgmANrVj5WyRv9yuQ2+1FLA9vXaS4kuIDsOTdwN9Y4GHJA1l8dsbLL+30A842hLJHnm02f2uSWrwb3F7lMTXH2Zu6CC7uSStzZ/X6YzaEVWC2LD0dPcIzlmAUYJfFf02MM1np1D2Mo8mrFX9Nq3c+31s9nzkdYD4zM449rRN/kutd9lS4EA//FmSCSSMTxrJsGo7oJ/WyUEJwG7vAkhMloA42/69uKppwn8N/jhOgYvwSbT9gBhAyyM4RmJBcYG0kdTNQsDvMXq8Kyb0v/yKX2yIWtayjNGCl7bnc3BGS1RoSszD1POQLPjqekb0Nur++cf9r7bNVL78GMAJTdEfn/Ht8CaPVlmemMCT56MExz//LocDNEE8vaZ4TwrUCCVNAPV0eYqqLzUn0aOaXydWYN1pEJpeWraWwskfySwowsCRms+KVNdAKJVHZj3fEvJGgZ4bMgaqtMpNOL2ai0bEqkulvCnXjMObNso9cBtuNPH30lcdLqnsBepjsf8/8X1va2Q8nKrru8KX5oCva4lWfTXKSvRxRP80BjjiRMiqhmWPeHUnyFB9Tz8iSaEvB/8HHEH+QKJ+mLbVtGhsq0uSeTGPEHsb2EgGYVZehRqXdk3ijJvUPoc68LMFDTVdOL9FOeQJA9vDprT3hzYVpfh89BLR48o07zCrhv9dxR8HJWVuueBV0MXNmdo0ZthnFrA2
 91nPiWKu
 uNRvOVazTiE6gsnZMpr3g5dK6w3ltvTpviEL8GGoKYLAute5Tt7eOdXI874S3o9JGAAcmlmfzDLcrSm4zL67K3s1/+CFwm6KwvyfddvRHdGheo+HIPAIxLy8qgJYKWDheyxaZQpkpS6IElI3qZ0qDtwmVn19rXT38ntPHJbThSzUVii7K0Mlyv408iwIwyre7L4aL7A0EPn7pS0si6tIl2QRSGNOQZHU/uuX7anMH1gou0L73uiKMlmgN1gZ+AEJVxDwRg+P2MM/voIw+jViFYPSsr4+zlE3tNx//6CIWXwcCXOUeixJKycBo1FncSgTBZBny
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   d873dd7a326a5b9f970008d4b59ae2c9e4e9b12b
commit: 28208ad9dae4d1eccc9280bc3193b4091afd6a1a [124/135] mm/sparse: fix BUILD_BUG_ON check for section map alignment
config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20260401/202604011400.OFLcOOmf-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260401/202604011400.OFLcOOmf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604011400.OFLcOOmf-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'sparse_init_one_section',
       inlined from 'sparse_init_early_section' at mm/sparse.c:323:2:
>> include/linux/compiler_types.h:706:45: error: call to '__compiletime_assert_350' declared with attribute error: BUILD_BUG_ON failed: SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + __ffs(sizeof(struct page)), PAGE_SHIFT)
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:687:25: note: in definition of macro '__compiletime_assert'
     687 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
      40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:51:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      51 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   mm/internal.h:975:9: note: in expansion of macro 'BUILD_BUG_ON'
     975 |         BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + __ffs(sizeof(struct page)),
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_350 +706 include/linux/compiler_types.h

eb5c2d4b45e3d2d Will Deacon 2020-07-21  692  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  693  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21  694  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  695  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  696  /**
eb5c2d4b45e3d2d Will Deacon 2020-07-21  697   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  698   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d Will Deacon 2020-07-21  699   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  700   *
eb5c2d4b45e3d2d Will Deacon 2020-07-21  701   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  702   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  703   * compiler has support to do so.
eb5c2d4b45e3d2d Will Deacon 2020-07-21  704   */
eb5c2d4b45e3d2d Will Deacon 2020-07-21  705  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21 @706  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  707  

:::::: The code at line 706 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

