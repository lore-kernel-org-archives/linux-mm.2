Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774CFCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 16:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451346B0093; Tue, 23 Jun 2026 12:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401C26B0095; Tue, 23 Jun 2026 12:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2FE6B0096; Tue, 23 Jun 2026 12:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 045C46B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:18:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 811ED4048E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:18:59 +0000 (UTC)
X-FDA: 84911686398.26.59B2B49
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9E2EBC0028
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:18:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782231530;
	b=3YckKcweNn2iFGB3QISEHgRav5nFeQvZjD4Qq7hwum+Xo5489AXqA2bfJ5dcU8cfdb1Rq8
	gcyEDSsVsijpZq8XUxTZgJL5Ujt4nzpTV0JSiQQcIsNwfGOjR9hqCSFz+lMVtND/YHGnqJ
	3QAZKxns8PH57rGZDHLlU1gdfghlhjA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782231530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMgY2n1EfLvlRsgBNgA9MAjJMVDDa30z5+bZN/hVjek=;
	b=hO+SNrYxc/YLWa0X7xZDqKA9dEGGDrubFFGk0uIzBX40ZVgy9c11ufyim1qrM8mi9G3LZK
	OV6/yrRXlzQX6p8GPCgAyAmL5PuxQKz7teSAMqYmQ2NIEfWEAbsfqg0UQgn+o9930ZXYJZ
	QOU5DfzlKh7VDZdt+vcsJt2yfjfm+gk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YhRj2pAr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782231529; x=1813767529;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SFi46IF8yalXzd16nCzIQcS7FPO5l+ORfyWSuo3aTco=;
  b=YhRj2pArjFqYlTGlFFZzJAUHykagXyfOfW7gXEr6CZ06yZi3rUWVxAL+
   Kui6QEP4g4JG/NrsUIczzcwoYUxgYzKNSgZIV/NYVCDGLUT1GyZwjWENq
   kHRG+QJ7Suy55hB5850kSDixquaBNcXxgv5aNmFIVunS4RCthsMSGOZG1
   9jMeBaDha6tg6/Ld03hOk4CmYb/WhPr/VCIVKAo6w4qg/4NvjNu9EYrey
   iOqhQ5y4LBhDmxNhZu32jbVWeC02p3GR9eFtSii91ccnznC3Ti2J8Yprq
   DecjgED7qJ8tUhHPAA3yrotVl+ttShntYpbKzzsLlfF0RmlWvztzgpw4q
   Q==;
X-CSE-ConnectionGUID: MVU+Ho+CTWedu8s68rWNlw==
X-CSE-MsgGUID: +y+mDuw1TASSfEEDxiN8ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="94097752"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="94097752"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 09:18:43 -0700
X-CSE-ConnectionGUID: I16HtoYWTq+aZtMBuje4iw==
X-CSE-MsgGUID: LEQN8IzHT7+niBMXxLJabA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="249672676"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 23 Jun 2026 09:18:40 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wc3pc-000000002hV-1Zpf;
	Tue, 23 Jun 2026 16:18:36 +0000
Date: Wed, 24 Jun 2026 00:18:20 +0800
From: kernel test robot <lkp@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, riel@surriel.com,
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, sj@kernel.org, ziy@nvidia.com, balbirs@nvidia.com
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <202606240042.ffPsEXVc-lkp@intel.com>
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622130651.23359-1-richard.weiyang@gmail.com>
X-HE-Tag: 1782231529-502928
X-HE-Meta: U2FsdGVkX1+n/eA9A5RUFs1CdthxKlxEuxMBM5aj8XektY3ppgcRMD2QHytcFrD/fvLVyWcVmvQ63ompBgRdfhKidNJHlMgTSpiLobc8Md4gHX16X5H5YJ9GRPuPJ42SohFW8nFOBT1Wefic8n9mPEI59XlGbhWNdys1kp/5yXgwWqwcQcB05+O8n3hDSFvn+SgwUVPzngBjpp4xAF12DP0+tEsCLrH9snFqyPiuoIBLl8r0mU80NHnhc75P+DRleVF/mfhFlzrQ2CMQF/wbxaxS5lC+SLfmGNt8nUj6yhgG4AKCkqHrQYQfGoj11ZQj1t9znB8//LhRUID4BKtwgpTmkwFv7l6oEL2A9WL1QCS4tw41cSjuV0WIPvHV58l41PVbEf9CDR/OX0Q40yBFqBryUVo1FnRp/uEiNf1h89eqB1GtNFnuf3+HBtNmYkE5CV2oDkmlUQaVWmVeVRJABNw3k0nHTxWCovTJY8CyMXcyT5Zy7JBkM3J7Oh9ts/Gh/BWufB9NJPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wei,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Wei-Yang/mm-page_vma_mapped-revalidate-and-do-proper-check-before-return-device-private-pmd/20260623-012838
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260622130651.23359-1-richard.weiyang%40gmail.com
patch subject: [PATCH] mm/page_vma_mapped: revalidate and do proper check before return device-private pmd
config: parisc-randconfig-002-20260623 (https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'check_pmd.isra.24',
       inlined from 'page_vma_mapped_walk' at mm/page_vma_mapped.c:283:11:
>> include/linux/compiler_types.h:699:38: error: call to '__compiletime_assert_406' declared with attribute error: BUILD_BUG failed
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:680:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:699:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:60:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
    #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                        ^~~~~~~~~~~~~~~~
   include/linux/huge_mm.h:113:28: note: in expansion of macro 'BUILD_BUG'
    #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
                               ^~~~~~~~~
   include/linux/huge_mm.h:117:26: note: in expansion of macro 'HPAGE_PMD_SHIFT'
    #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
                             ^~~~~~~~~~~~~~~
   include/linux/huge_mm.h:118:26: note: in expansion of macro 'HPAGE_PMD_ORDER'
    #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
                             ^~~~~~~~~~~~~~~
   mm/page_vma_mapped.c:142:13: note: in expansion of macro 'HPAGE_PMD_NR'
     if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
                ^~~~~~~~~~~~


vim +/__compiletime_assert_406 +699 include/linux/compiler_types.h

eb5c2d4b45e3d2d Will Deacon 2020-07-21  685  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  686  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21  687  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  688  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  689  /**
eb5c2d4b45e3d2d Will Deacon 2020-07-21  690   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  691   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d Will Deacon 2020-07-21  692   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  693   *
eb5c2d4b45e3d2d Will Deacon 2020-07-21  694   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  695   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  696   * compiler has support to do so.
eb5c2d4b45e3d2d Will Deacon 2020-07-21  697   */
eb5c2d4b45e3d2d Will Deacon 2020-07-21  698  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21 @699  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  700  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

