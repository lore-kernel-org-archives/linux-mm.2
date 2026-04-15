Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C75EF419B6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 13:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B9A6B0005; Wed, 15 Apr 2026 09:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D136B0088; Wed, 15 Apr 2026 09:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632C86B0089; Wed, 15 Apr 2026 09:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 503116B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:32:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5ADA138344
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:32:14 +0000 (UTC)
X-FDA: 84660878988.08.BAA36B7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37F6340016
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:32:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="hcAlNgI/";
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776259932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=R07CHDLJo5eLMDGCFPiClvOfIRm4jNkCYrNdBLkrUzI=;
	b=3mWp0H6UDyRQ4m4n/cWXP3L+9veCeiOU+nSFS2oMnw+oNhnarn9WPhLXySm/FvdhyXbYcF
	mTz12HYQvQZqyXt++oImf6bD6WARA3JAV92HVU0paa7c/fPFrN4AlKOoHTBeH7uRLNYfCv
	VjHmGJyKpJBD5TC3St2wqPJcDk7ZnBw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="hcAlNgI/";
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776259932; a=rsa-sha256;
	cv=none;
	b=pF/NkCCbu80z9XPU0f824dxtFs01GYJZXTBL2uJYDOtj3Mp14mjFi5mi4Q+s1uuZF3T/t6
	TLEfsRXZS6oxvR5V5nJXCWowQoCISZHtdZ5hHDCceEFv+AqeMUGovi55tljTWxog4nro4s
	h5dkZMtaDxeXtqJ/BArw5UbDAILSDIY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776259932; x=1807795932;
  h=date:from:to:cc:subject:message-id;
  bh=aXkGhsVy594aYIb+ZwNsUstG2giINOKSNBMf9ItvRJc=;
  b=hcAlNgI/DhxPhEqfX9ZakcgHQkvkboU+EnDY0ZU4L/6jUJnv+kAXQWMq
   lXyrSj6yJ9H6GCgCS4CNbnV6CoZPlT9Uw++r2P6yK1kkbK21Z+CY63MEc
   nOkV83gub5ESJl2b1zZ/ikHgyCnoBI3QMRB/7Be1MDckuF9u/b9be7dC0
   FIm18A8uOsYHUI64s5pX2wBJkNs9gV8W1vLz9/wHPlA1RN9hF205JIX2y
   ipisWiuBgpj3U8ui/3NPCagnQnF/29N3hodRkfvp9jcmYb/o4ZZdnA+pN
   zOiuwxwY0fV/oXrXVkvFhH/TpDuhVgiSfpGIv+LUp//5UFeQ9JIp60GZw
   w==;
X-CSE-ConnectionGUID: IS/OFmlqQ9CuSop3IEBNlg==
X-CSE-MsgGUID: 1Y90x3xKTK2xbl4NOX6wRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="77260499"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="77260499"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 06:32:10 -0700
X-CSE-ConnectionGUID: lExZ/GPKTMaB/tf6TKYkEA==
X-CSE-MsgGUID: yDOAGoRoTEOysZQUyRSm7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="227253158"
Received: from lkp-server01.sh.intel.com (HELO 7f3b36e5d6a5) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 15 Apr 2026 06:32:08 -0700
Received: from kbuild by 7f3b36e5d6a5 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wD0Ld-000000000Xf-33x5;
	Wed, 15 Apr 2026 13:32:05 +0000
Date: Wed, 15 Apr 2026 21:31:13 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 159/160] include/linux/mmzone.h:2052:18:
 sparse: sparse: incorrect type in return expression (different address
 spaces)
Message-ID: <202604152138.zbTaYxbG-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 37F6340016
X-Stat-Signature: 1qm9hfozrxhtabupd7jfbxgug8qp794a
X-Rspamd-Server: rspam06
X-HE-Tag: 1776259932-606563
X-HE-Meta: U2FsdGVkX18dNtzQDBeozM28qLFj7gzxhuUtuUsIbnzgjP4exZ4TO5zPIR+kSbV18oZK/s5WNmWoNxFMvt31hNsglvbzEyBYI145ddTOjHgssIFVFFb1fyx2AoTK59JAa5/BXBi21qfoAD/pm62mvLLLXXztTb1eqB1XGojRPdK2NjdRJL0nc457kC78rrRjJd3UMftF9lD80mdhJi7xTymnYmyKac5hLZQ5oSKu59A5yDp3odBzZDYNfzER8Tc5ZYeZ9J7YzTEp5gDK5x7Qpkax4t3+GHqmRkbPyNRF7VBKHkb+5WMc6yg/9hDY6eQpiDVANtthDaBEdzSBMGk2gNMpCdimuqPuCbwNQ/Wo7VDqhFy2L3uobTuKrLMg80jvaFedckqcA62VJYxcqJ5eYRTNBc52b8hlDy5ToR9hBUlVD/tAZbQ++hpKJY66a0Rd7PpcpLT9NTiBkA66/1JjCDW4JuQj0kZ0U4hrLgRHcsvEA08UTwY8aWwYQ0E8gbmp4+Sbvi+SmcYd6JwmOP06nHYC0arHNTGj2m5u9+mOU7xC5AOjQmCqTI98sJpF9/8XOUwfy1uO9xYGLmMbe5e5fiODsC4TyE9v9JHO/MIKYuW6GR+OhZoFyORSPw02o0qIfaxhH/s80e5PN27udOp8fbZb+C6qyePJVTqu3npv4Ee1nNMn9EJLSH5qtRcsVJ1NEcVQmAj2GnJIS6IeKVm8CbmZ3B84M/V1Rz43jGw7wyrPOpFciFZlwO4JI1/4KDJKAHLVfHyyYxGW9kC+QvVcB5AJmgToeRMTXoyEjLkdSWKBxJTwx9YrPYOBoXL9ZEWExnaQ03GokdB/6BqwAG9RReXOAYRdRyf06+xH03oWQfN6yZSac9SLka0VmPv8jo4PR2pOp3BZHQ7upVSOzgDNjZk/yVvvfLYQtgGo+DP720WqAM4agKzQYhH9P9dyeK05BShoYEpCeNMtQOYFGcb
 yJdwvN7v
 eckdRrxwjAhcBswG87yMGoNGZMa2ZTi3qkoI1X9YAABWz9JGo7PgoKoDOJZpk5brgx06KXeu7y2IVhpLrkNg3Hz7pKDDG/pCoJ9zG9u3WwgF8mgzP93IU45kvGE5tmS2DaTOc+aBcQl1q9OOl1FH4YgIwqONl7e4sH+X364aEPPfLhCJrePkK7IrlFinRrcW0wLwtq1ufKOAMnfZSZFpijAe8H3TbDTxPLemZ90oTiCi7PsByqkqHN9QQ1rlr6CzMp32d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   f358e95febcb2f3d7ac6aafab0a2b9ace9cc8b7c
commit: 085038a33b6f00e4c43cceab8116315d1d42380c [159/160] mm/sparse: fix race on mem_section->usage in pfn walkers
config: i386-randconfig-r132-20260415 (https://download.01.org/0day-ci/archive/20260415/202604152138.zbTaYxbG-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260415/202604152138.zbTaYxbG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604152138.zbTaYxbG-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/sparse.c: note: in included file:
>> mm/internal.h:987:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct mem_section_usage [noderef] __rcu *usage @@     got struct mem_section_usage *usage @@
   mm/internal.h:987:19: sparse:     expected struct mem_section_usage [noderef] __rcu *usage
   mm/internal.h:987:19: sparse:     got struct mem_section_usage *usage
--
   mm/page_alloc.c: note: in included file (through include/linux/gfp.h, include/linux/mm.h):
>> include/linux/mmzone.h:2052:18: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected unsigned long * @@     got unsigned long [noderef] __rcu * @@
   include/linux/mmzone.h:2052:18: sparse:     expected unsigned long *
   include/linux/mmzone.h:2052:18: sparse:     got unsigned long [noderef] __rcu *
>> include/linux/mmzone.h:2052:18: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected unsigned long * @@     got unsigned long [noderef] __rcu * @@
   include/linux/mmzone.h:2052:18: sparse:     expected unsigned long *
   include/linux/mmzone.h:2052:18: sparse:     got unsigned long [noderef] __rcu *
>> include/linux/mmzone.h:2052:18: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected unsigned long * @@     got unsigned long [noderef] __rcu * @@
   include/linux/mmzone.h:2052:18: sparse:     expected unsigned long *
   include/linux/mmzone.h:2052:18: sparse:     got unsigned long [noderef] __rcu *
>> include/linux/mmzone.h:2052:18: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected unsigned long * @@     got unsigned long [noderef] __rcu * @@
   include/linux/mmzone.h:2052:18: sparse:     expected unsigned long *
   include/linux/mmzone.h:2052:18: sparse:     got unsigned long [noderef] __rcu *
>> include/linux/mmzone.h:2052:18: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected unsigned long * @@     got unsigned long [noderef] __rcu * @@
   include/linux/mmzone.h:2052:18: sparse:     expected unsigned long *
   include/linux/mmzone.h:2052:18: sparse:     got unsigned long [noderef] __rcu *

vim +2052 include/linux/mmzone.h

d41dee369bff3b Andy Whitcroft 2005-06-23  2049  
f1eca35a0dc7cb Dan Williams   2019-07-18  2050  static inline unsigned long *section_to_usemap(struct mem_section *ms)
f1eca35a0dc7cb Dan Williams   2019-07-18  2051  {
f1eca35a0dc7cb Dan Williams   2019-07-18 @2052  	return ms->usage->pageblock_flags;
f1eca35a0dc7cb Dan Williams   2019-07-18  2053  }
f1eca35a0dc7cb Dan Williams   2019-07-18  2054  

:::::: The code at line 2052 was first introduced by commit
:::::: f1eca35a0dc7cb3cdb00c88c8c5e5138a65face0 mm/sparsemem: introduce struct mem_section_usage

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

