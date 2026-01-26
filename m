Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67955C88E59
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 07:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DF16B00A4; Mon, 26 Jan 2026 02:16:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815546B00A5; Mon, 26 Jan 2026 02:16:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E746B00A6; Mon, 26 Jan 2026 02:16:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E10B6B00A4
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:16:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6323BABFD
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:16:13 +0000 (UTC)
X-FDA: 84373256226.08.772C70F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1CA78180005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:16:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jCZQp1WD;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769411771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EwVridSx581k2gZPt+kEBvAQmUuP02uNP2cG80Byjw=;
	b=KuszbtwlmN7bouajzjvKnKhL/TXjFEfvQaThO9ugAwRYkf5AvXma/ab7pZJmPKdYCUAUys
	RwDvA5+WFpCPDqMYBtbwrykBRayEHxoQDQHc3TBBtER8DoUKaftvvI207tptgjBCBovJLW
	qDOjCZwHM1J+Vemnt1B71FotQXp5LmM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769411771; a=rsa-sha256;
	cv=none;
	b=PN58F1co7S8sclVq2UK/mLtw6pd4ktl2bFImnmTTHAFsqyun8mtbyt6nFzsavJgU5pxc1U
	Wt467auql339lZ4hQs5lzLbWQcLA3bJ3yrPKEE94FT1lBrr508Hg6CDNXEsrgmKU5guAje
	iFhDnTA1Elu+wwPOkgGhS33CXawiBng=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jCZQp1WD;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769411772; x=1800947772;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cuLtFa4X5N8EDw4JojqtUoQ3rGWi3/cxlUCgRiMT6L4=;
  b=jCZQp1WDnxky8v4jeBnwhK4BRTv0PhuDdRMKQmVWJlBOZPDcXs2P4mIC
   UFDW/1quEBQRpdS04lvZ5CCCNdYclGEBgQG2tRfWZ+8/iigKMW+Y7cLnE
   R/GlLEgrLgn6Izd7AUhqo6ZCQNGLPsitOU3RCnF77zvPSKCqLAKyIlhQD
   LJ8EQlHoew6Y+byhriM9UB3NJUfKTQ4b8GzGmXCtrsA/TnO1DPTA6qygC
   yBm++DLSKsUN0SzRMtQ6+UApFfoCdziDb6yEu3yW39unvyBrdn2GQs7/l
   G2esEC+VX+CKM06bk4v695ASM4u5U5GB8jRbcdK4jz0oxcA3cnNO8MKXS
   w==;
X-CSE-ConnectionGUID: wkLMWIsST3enMhjBxOToFQ==
X-CSE-MsgGUID: CwQgt3NSQBqqNQaP2ZONAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="82019789"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="82019789"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2026 23:16:10 -0800
X-CSE-ConnectionGUID: trsgUnd6SlCWjfR5ZCFcqQ==
X-CSE-MsgGUID: +0ide2moQIWlxfHbk/B9dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="207415440"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 25 Jan 2026 23:16:07 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vkGpP-00000000X2M-3B5n;
	Mon, 26 Jan 2026 07:16:03 +0000
Date: Mon, 26 Jan 2026 15:15:21 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 06/12] mm, swap: implement helpers for reserving data in
 the swap table
Message-ID: <202601261555.3oBvFZIt-lkp@intel.com>
References: <20260126-swap-table-p3-v1-6-a74155fab9b0@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126-swap-table-p3-v1-6-a74155fab9b0@tencent.com>
X-Rspamd-Queue-Id: 1CA78180005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: pwo35dcj3dafg1d3g6yxwunn6f5c16sk
X-HE-Tag: 1769411770-949306
X-HE-Meta: U2FsdGVkX19hdK32p+zuMseAl4kEu7FdYoJoTLtVU1UvDk0KEyM/KbDlK68HDGe2UEmiCFTygkElw1+EaIIMfhPikDYcuV/lLXagH55+a5S43mlTVKTCDU5GzcpsxOO7mnmjUcjRbeKHrNyQRbVvX5aYSQ99zXbXL0DJdSk9HCKby1kHXMxgx0YP8pXwg3aFX9kyJEL3Bcw2FMQTjXJwyfdUVogcgYnLtnOKkb0X9xyP+08kvGnUkhrr1aruBHKmiRBt+WYNdS3b6CDmWIHGUXShzUUEF9uF+WnDota+GdPbXshKzQPze3ceOIX+B8c5FON4UYg6vPWrhsyYssBtmsCZlfiZKg7BjX1nU/ZYlWffjjLwY+s3gcHZnFscIixGQ0++16V8u8kU8Y2cvFZPlJqudy0Mw2jTAElMtqpFeV45cv+/RblAT1M3KeNbM32ezJnzChlEOeCcRddn5U5cHFBKWlwFSm6TubikKoMn9UbosMu3EZ7usROaVvTXdHRrnbK9SKlZNQ0TEHNtZymqu/vj8DgBwBneGNPVNZ1YekBgxWzZlBIKOqcg7++NVEnxj/gBPUPeovKrn8/XiFgrnJuOkv1JjfUuJ+l0FrSJtceBwi37SuclH8eyLM4oRlVwCIv6CmFsQm0jEaGmaBG8gdmSQFi5KwL8DFxUtFBNl/7jakkQJzxnQog+MNgQ5Nwfu6lbi3QbxZQZHlKrz+tmFzogsjG2+3fi4XEW94qV4+A9xyTxdKRARl9m7Wd2nh8We5s8VLIs/mrhZP701wzr/xnCG8uFeoty1BVUhbovs1hAKQMLue9PVlVfzeeXaNCwnx2U1ebsHpa8qfu7BCfiFH2QgKyVgcOF8HtheiABhXpbkHh1L+85TQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build errors:

[auto build test ERROR on 10de4550639e9df9242e32e9affc90ed75a27c7d]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator/20260126-020149
base:   10de4550639e9df9242e32e9affc90ed75a27c7d
patch link:    https://lore.kernel.org/r/20260126-swap-table-p3-v1-6-a74155fab9b0%40tencent.com
patch subject: [PATCH 06/12] mm, swap: implement helpers for reserving data in the swap table
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20260126/202601261555.3oBvFZIt-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260126/202601261555.3oBvFZIt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601261555.3oBvFZIt-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'pfn_to_swp_tb',
       inlined from 'folio_to_swp_tb' at mm/swap_table.h:115:9,
       inlined from '__swap_cache_add_folio' at mm/swap_state.c:151:11:
>> include/linux/compiler_types.h:631:45: error: call to '__compiletime_assert_601' declared with attribute error: BUILD_BUG_ON failed: SWAP_CACHE_PFN_BITS > (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_COUNT_BITS)
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:612:25: note: in definition of macro '__compiletime_assert'
     612 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   mm/swap_table.h:104:9: note: in expansion of macro 'BUILD_BUG_ON'
     104 |         BUILD_BUG_ON(SWAP_CACHE_PFN_BITS >
         |         ^~~~~~~~~~~~
   In function 'pfn_to_swp_tb',
       inlined from 'folio_to_swp_tb' at mm/swap_table.h:115:9,
       inlined from '__swap_cache_replace_folio' at mm/swap_state.c:334:11:
>> include/linux/compiler_types.h:631:45: error: call to '__compiletime_assert_601' declared with attribute error: BUILD_BUG_ON failed: SWAP_CACHE_PFN_BITS > (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_COUNT_BITS)
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:612:25: note: in definition of macro '__compiletime_assert'
     612 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   mm/swap_table.h:104:9: note: in expansion of macro 'BUILD_BUG_ON'
     104 |         BUILD_BUG_ON(SWAP_CACHE_PFN_BITS >
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_601 +631 include/linux/compiler_types.h

eb5c2d4b45e3d2d Will Deacon 2020-07-21  617  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  618  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21  619  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  620  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  621  /**
eb5c2d4b45e3d2d Will Deacon 2020-07-21  622   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  623   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d Will Deacon 2020-07-21  624   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  625   *
eb5c2d4b45e3d2d Will Deacon 2020-07-21  626   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  627   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  628   * compiler has support to do so.
eb5c2d4b45e3d2d Will Deacon 2020-07-21  629   */
eb5c2d4b45e3d2d Will Deacon 2020-07-21  630  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21 @631  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  632  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

