Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CB3F3D600
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 10:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4CC96B008C; Sun, 29 Mar 2026 06:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6776B0095; Sun, 29 Mar 2026 06:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E016B0096; Sun, 29 Mar 2026 06:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74AC16B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 06:49:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2ED1AE044A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:49:51 +0000 (UTC)
X-FDA: 84598780182.26.A27D7E5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5F4841C0005
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:49:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hZ2SD1gv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774781389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0X9tKwjIuG4Z8zXqeuqujENkVK2g4XF5McYtiClONhk=;
	b=mLF9PTPF5Ph5X8/kcvKCAKS2hRcVtw7kWw+YG/54fbCTnNvlIejlnyDtZ2WOnDriWxO8/4
	3gD406icaWNB5VsXtYa0gV2nKBubFXqPbsJ1e6XF4nREHhFcRPZipH5xDdQNfIhIw2uceF
	W86XVU14MJ7EjugWwS7ureQ7QtNLi2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774781389; a=rsa-sha256;
	cv=none;
	b=iegsAYDsrUQJe1iPkHzbX/FalZ2V/M/RrdEcO8ZVAbiumMxwdxr8Z4aYTA3qDL79XShsnu
	1UiugXNI7e4GNDHUMIVWWhaPJG97CVXBvXZtbWPXjp54uQPDdP4umqgwT/ViECqMhrjIob
	DgXGPhMfgAnkUjScuj4lGwRNLDo/xCo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hZ2SD1gv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774781389; x=1806317389;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0jS+lxhtNLNxmUvtXwaJU9vXoM22BiN5K4t003u6/vY=;
  b=hZ2SD1gvvL4HCUry9iBgEAOQJDHLAHIFv509+7KCpR4ItcQo8UPnmxM9
   tjD4trYjUsWfjHAsd6sXFrfL1nguu4YC9FVEf3ofgjQkk0cE/iNI3b9Jr
   ceWAhLxHXKUPH0W7cuoiPRA9C7e0gLp9yCGVs2iMIuBN2dCsz92PnQVY1
   MO4ic4n7tl8tiG20pYW7eXgLOq/+4mz09smHGfDWerK6tNUewmEU5+kmk
   lnkj/4oDh/caKzd8gtPwMJRqCSjPwZJulYXnCSkPXX8TvLwxgHHmwBV+5
   6hyyhGk0umwjElBnLrQz1HPJ4FOrJ5yTMgRY5C9S1TxsMg4MOciz/1lgf
   Q==;
X-CSE-ConnectionGUID: KaD+ZGzXSHq887JfHeQ0Xw==
X-CSE-MsgGUID: PD0LVoHPQT+tCatF8qlM9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="86870758"
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="86870758"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 03:49:47 -0700
X-CSE-ConnectionGUID: xMZyIx/uQNi/bVUaLyn0PQ==
X-CSE-MsgGUID: aNcT5voZTsq2WxuqnuWh7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="224955420"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 29 Mar 2026 03:49:43 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6ni8-00000000CID-0iui;
	Sun, 29 Mar 2026 10:49:40 +0000
Date: Sun, 29 Mar 2026 18:49:02 +0800
From: kernel test robot <lkp@intel.com>
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <202603291844.TWh2Ellp-lkp@intel.com>
References: <20260328075812.11060-3-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328075812.11060-3-21cnbao@gmail.com>
X-Rspamd-Queue-Id: 5F4841C0005
X-Stat-Signature: e8gf9zari7k66z8wzqzet365g8ujaraz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774781388-183478
X-HE-Meta: U2FsdGVkX18OUgTVmXPu6inAxIthNGiUJyqWqlAOkfS8eW7L0TCrsrfoKzv8QQF+pG9jeMJ1hXPieFG7o7AjDFOFbYFMbQIKxQiA203isNTi1E/KV/4aKhpJzm1dXVskyztRg8hhpfSn3q1dXR1WxuGCZVBz+NpxiZ3HwDzIFW/ywogPUyqX3A/jagJk2nqwINiVa8iklJvWD5c8jAc7XMjebuJ3H7GYdWpRpsH9ZJisILHTlRH0z5isxkQkGSrWyJaHu3ueO/fKqZ6ljtBPRu24CDEOkdduyE3CLf9NsFDtDND5Ev8ZxNgojMp9aifuPWnEW+FcG3mRLvm4y83q3qEwie2XntoA8PCI2owcc6ZLnICrVUsUy68B31Q7dtjBhJpSqwF+S1SGmqtwvB43Z8JNcwHMpDtPKcUvIIA1WhJeK9cnnzcB3UqgMHTg+mjPnMo0e7RLYc6bPmHrUZQthszRrP3pgEaLJF2yHG7MxbKS6cWMz+o2WGlr9TlZDT38EDfcTGhH65L0rSMZ+qnRP3WlXtkO6O+W18wrH/ha23lDN43nHma5QE+4plHLj+ynMy+DUkQyLeGrzcp2N0ODKJMgBYEUwaKjR7XZC8PhJTPQYeFVP/ZNQiF6FbJy8n3K79PamsrVqWjYq/fkP1mRbun2U9OFmNJgrM2ouJCr3MqvEGh1rOD67OFtphEyHHectlxyq7eaFmffpDiK8NFl9FuiAPlTDGhctoEzCAE4bgsYk/XApqFJCG/Pdic6RUvdeFZRMvbqQyuN5HH3eJdZgIUnPMMUDh6wsZ533lVqfJKOlZkIacYfTyNo9IdN2RUYevj9tq4jsyinm9AhCHXe0vPSH2vdUrNVp4gIPUCPU0e4Zls97ojmma4P1xFygFtiH17fevXVe4IUZyyulcY9khXXrCPVfmO4D1P0FGvuTocOExOuG9EvKFMEQOCUi6ea0g7udPtvGT8tjFPJyUk
 yoi7HRnw
 4Eb6kxLaMFYH0CfugslpydCX04yzuATAj5NNbLlXGXHWqQtKYXWkTGXJQsNNoYACzntxo6nIksPyEWslQs1GZz2e6uWyPXFmSwX26rZtlWA6wa2sdiBPXNHLps82RBh0ZWFH0mJvzG7AxtXac+ecmcd9Wmg3MSoGyZB1yjaR0yaik6xi5JyJFxXwqjnoDloKfaTlL8/wNlAc3SwGcqjVdKyAGDr7WzFewSivj3ZrMX7Vvt3BvNGHCkFHiEy6z3Dulyaqs1eGd2Yrvbg/ZK5iAYm8UXBmbBd4w8/NFu/Jh65I+Pn+vP0EsdWM7vNWk9mQbw0pT8UYj/bOzeWfz1cIBw9r681zZYIlX+jvL3ZAWTIDifcFPSPpJQQshpEVaBQ+J1EwErB2gICNtAyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Barry-Song/mm-swap-rename-mm-page_io-c-to-mm-swap_io-c/20260328-170852
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260328075812.11060-3-21cnbao%40gmail.com
patch subject: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
config: arm-randconfig-001-20260329 (https://download.01.org/0day-ci/archive/20260329/202603291844.TWh2Ellp-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 054e11d1a17e5ba88bb1a8ef32fad3346e80b186)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603291844.TWh2Ellp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603291844.TWh2Ellp-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/zswap.c:1057:19: error: use of undeclared identifier 'sis'; did you mean 'si'?
    1057 |         VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
         |                          ^~~
         |                          si
   include/linux/mmdebug.h:133:52: note: expanded from macro 'VM_WARN_ON_ONCE'
     133 | #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
         |                                                    ^~~~
   include/linux/build_bug.h:30:63: note: expanded from macro 'BUILD_BUG_ON_INVALID'
      30 | #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
         |                                                               ^
   mm/zswap.c:995:27: note: 'si' declared here
     995 |         struct swap_info_struct *si;
         |                                  ^
   mm/zswap.c:1057:32: error: use of undeclared identifier 'sis'; did you mean 'si'?
    1057 |         VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
         |                                       ^~~
         |                                       si
   include/linux/mmdebug.h:133:52: note: expanded from macro 'VM_WARN_ON_ONCE'
     133 | #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
         |                                                    ^~~~
   include/linux/build_bug.h:30:63: note: expanded from macro 'BUILD_BUG_ON_INVALID'
      30 | #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
         |                                                               ^
   mm/zswap.c:995:27: note: 'si' declared here
     995 |         struct swap_info_struct *si;
         |                                  ^
   2 errors generated.


vim +1057 mm/zswap.c

   971	
   972	/*********************************
   973	* writeback code
   974	**********************************/
   975	/*
   976	 * Attempts to free an entry by adding a folio to the swap cache,
   977	 * decompressing the entry data into the folio, and issuing a
   978	 * bio write to write the folio back to the swap device.
   979	 *
   980	 * This can be thought of as a "resumed writeback" of the folio
   981	 * to the swap device.  We are basically resuming the same swap
   982	 * writeback path that was intercepted with the zswap_store()
   983	 * in the first place.  After the folio has been decompressed into
   984	 * the swap cache, the compressed version stored by zswap can be
   985	 * freed.
   986	 */
   987	static int zswap_writeback_entry(struct zswap_entry *entry,
   988					 swp_entry_t swpentry)
   989	{
   990		struct xarray *tree;
   991		pgoff_t offset = swp_offset(swpentry);
   992		struct folio *folio;
   993		struct mempolicy *mpol;
   994		bool folio_was_allocated;
   995		struct swap_info_struct *si;
   996		int ret = 0;
   997	
   998		/* try to allocate swap cache folio */
   999		si = get_swap_device(swpentry);
  1000		if (!si)
  1001			return -EEXIST;
  1002	
  1003		mpol = get_task_policy(current);
  1004		folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
  1005					       NO_INTERLEAVE_INDEX, &folio_was_allocated);
  1006		put_swap_device(si);
  1007		if (!folio)
  1008			return -ENOMEM;
  1009	
  1010		/*
  1011		 * Found an existing folio, we raced with swapin or concurrent
  1012		 * shrinker. We generally writeback cold folios from zswap, and
  1013		 * swapin means the folio just became hot, so skip this folio.
  1014		 * For unlikely concurrent shrinker case, it will be unlinked
  1015		 * and freed when invalidated by the concurrent shrinker anyway.
  1016		 */
  1017		if (!folio_was_allocated) {
  1018			ret = -EEXIST;
  1019			goto out;
  1020		}
  1021	
  1022		/*
  1023		 * folio is locked, and the swapcache is now secured against
  1024		 * concurrent swapping to and from the slot, and concurrent
  1025		 * swapoff so we can safely dereference the zswap tree here.
  1026		 * Verify that the swap entry hasn't been invalidated and recycled
  1027		 * behind our backs, to avoid overwriting a new swap folio with
  1028		 * old compressed data. Only when this is successful can the entry
  1029		 * be dereferenced.
  1030		 */
  1031		tree = swap_zswap_tree(swpentry);
  1032		if (entry != xa_load(tree, offset)) {
  1033			ret = -ENOMEM;
  1034			goto out;
  1035		}
  1036	
  1037		if (!zswap_decompress(entry, folio)) {
  1038			ret = -EIO;
  1039			goto out;
  1040		}
  1041	
  1042		xa_erase(tree, offset);
  1043	
  1044		count_vm_event(ZSWPWB);
  1045		if (entry->objcg)
  1046			count_objcg_events(entry->objcg, ZSWPWB, 1);
  1047	
  1048		zswap_entry_free(entry);
  1049	
  1050		/* folio is up to date */
  1051		folio_mark_uptodate(folio);
  1052	
  1053		/* move it to the tail of the inactive list after end_writeback */
  1054		folio_set_reclaim(folio);
  1055	
  1056		/* start writeback */
> 1057		VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
  1058		si->ops->write_folio(si, folio, NULL);
  1059	
  1060	out:
  1061		if (ret && ret != -EEXIST) {
  1062			swap_cache_del_folio(folio);
  1063			folio_unlock(folio);
  1064		}
  1065		folio_put(folio);
  1066		return ret;
  1067	}
  1068	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

