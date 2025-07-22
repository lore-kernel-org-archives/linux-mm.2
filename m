Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C1AC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 21:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188E88E0006; Tue, 22 Jul 2025 17:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1399B8E0001; Tue, 22 Jul 2025 17:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027B48E0006; Tue, 22 Jul 2025 17:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0AB68E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:19:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 482221604D7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 21:19:49 +0000 (UTC)
X-FDA: 83693167698.18.EFDF95D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id 42B671A0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 21:19:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B68YggWD;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753219187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WYuFCynX/yZVbZlJ1Nso8NAa6qhfdENcyCuMKWYQSQ=;
	b=19bspaGpG4FkI7siGbzwnkRmGl9INEPxIzNgFUt4moPc+48rXrsUlBeu5nKTa8u8G1rV5x
	OUHoYhElO1Cp2Xl4mnns/6GdJkQiU0UOc4NQaU9qDZnTQ3Ek1ZJUyY65PRWg9qMR0TODa0
	obohKgHbjeCwP65wvVkGSeFuVbh1nHY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B68YggWD;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753219187; a=rsa-sha256;
	cv=none;
	b=aOC9GY+9zS4jM3vcEBvfVQ+ZQ8Dozcwey0kp2HP9L9xnDgpfjPnQhN4DPFJ/Yby9KQIxLq
	nRdYpM+0C+gzXd7BV489prvxrnAhKBrLnnBlTK7ZAwq2AZYSTGJoorm99+OYCFK9C7O6x6
	wurbja/lCLks8FzdaSdS4vl7VyBxNfo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753219188; x=1784755188;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VAFhRCJQknowV+AypDyaME1Ab2ilgI4tc2/Wbqr0Ux0=;
  b=B68YggWDuPpolK0rp2pSFGGJADj69vLqhCmXvt7kuIfk/MlIaazVmf07
   SSnLsccWbHvv/IePxu6lNCja9mRg0mKGKiTrNLriaiPU3FW7BT2bT6knn
   7Tesh3rt0RryAaz3Me22Pb1jbsY0lnmi8s7aaWPx3v7maJr3H5WVsWeMZ
   AtHWHxeFJjAFNtmq9Ga9lL83oQNL045itWq5xg4/HjUdyafRI2Wgr3xnf
   x586rgks7pKusaYANCtG5jgIZF40bnYD518z00i6KUOO7t1S7hxBkBht3
   4RimUUSYh8VPLewHIiqM88lrqZr2v0EB2j7RNJAv7AOaSj5RCeu8+RcDZ
   Q==;
X-CSE-ConnectionGUID: gcZ8Am9+Te6I3u72F7Ix+w==
X-CSE-MsgGUID: riti+nMgSbuhBkB8zBWcyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="59286780"
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="59286780"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 14:19:46 -0700
X-CSE-ConnectionGUID: QPx254goTECh3UVjxe55jg==
X-CSE-MsgGUID: BMGHljmHRY+SotKzCX9Gdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="190217200"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 22 Jul 2025 14:19:44 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ueKOj-000IiB-05;
	Tue, 22 Jul 2025 21:19:41 +0000
Date: Wed, 23 Jul 2025 05:19:40 +0800
From: kernel test robot <lkp@intel.com>
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 11/15] ttm/pool: enable memcg tracking and shrinker. (v2)
Message-ID: <202507230300.pUkL5SQT-lkp@intel.com>
References: <20250722014942.1878844-12-airlied@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722014942.1878844-12-airlied@gmail.com>
X-Stat-Signature: km6dmf7r1ucqit5h8m4o3865b1yjznzj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 42B671A0006
X-Rspam-User: 
X-HE-Tag: 1753219187-823645
X-HE-Meta: U2FsdGVkX19FEWM4T6VVvjDm9X0+SKk4/iQOm688opLHHtoMxW6PtFzSWoARHXIgpb791kZUpiwMc968vu1GaSJdIVYo6+QaNaTFmWH7lSS3WzxBhYIAVCIAdkukgKmeYvzw1aByHw8id0yBISq8l4JYMoCCgZEXbjaEPXauQeutT6NASVD3wzWnJ1iYPgvQQZHwOmhHTnKJmMAwHUiO7tAwSYFUeGbU2CSkGW8bHOmPkubci6F1vtJ+0KXRI2tC+sT4AdqcwkS1/jpVDvrWZjAhMWYRT2eJG4J4TIEEhqatGwBSSLA+DJdkQEAUaQ7zheXK8a4w/0iUUEygkyxr1AL/CeQ1MXWVgljxi7zMoUFAOHb3ntem3pkNb5iXthukZv+I0Gvc9XLIfc6nDpN8BZFMigaNSuaouGGylZLAdJtFVhP2AMrQpRlbZIbIiSXRMpM+kNkbeh6K1EIuZ7kcy/W0KvdireqZfqmMLX+KDuPuLWyw02BCWK1q97100XYIw4pIpX7OTX/kehNDwFlOu1jY5emq5fz1sFLvalEnepkQDZuVd1I0m3ZZIpqBYHD6s15yrpEw/RHZbw6kcbg8MZZeqPGfHZ2rbd0ii8uZm51pPqIfwP3j7/Ei4REjbnR1RsyGB1iJ1hJMFxRn0rTTgjRJLN+poNRpln5W3lX+hE9MTwK2YrboG1d+9EpLyM+LVjHOUS/mfR7cMsdQovhRHRQD0heZccRTWDeHMQ+33WmEWFxufo4t0pJcDBMC75lQp8yD/Ea1vRYHYeJCjWMKz8jfH2+JYTZdvZxkN3NDa+1PuRL30Um9iSz5VYruqzsKuGj0gAVd3dkTMyt0XZZUNV5E8uIzupe2pyy16PK66D5qVMB6oAXhGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

kernel test robot noticed the following build errors:

[auto build test ERROR on drm/drm-next]
[cannot apply to akpm-mm/mm-everything linus/master v6.16-rc7 next-20250722]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Airlie/drm-ttm-use-gpu-mm-stats-to-track-gpu-memory-allocations-v4/20250722-104402
base:   git://anongit.freedesktop.org/drm/drm drm-next
patch link:    https://lore.kernel.org/r/20250722014942.1878844-12-airlied%40gmail.com
patch subject: [PATCH 11/15] ttm/pool: enable memcg tracking and shrinker. (v2)
config: i386-buildonly-randconfig-006-20250722 (https://download.01.org/0day-ci/archive/20250723/202507230300.pUkL5SQT-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250723/202507230300.pUkL5SQT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507230300.pUkL5SQT-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/gpu/drm/ttm/ttm_pool.c:665:7: error: no member named 'memcg_data' in 'struct page'
     665 |                         p->memcg_data = 0;
         |                         ~  ^
   drivers/gpu/drm/ttm/ttm_pool.c:1132:11: error: no member named 'memcg_data' in 'struct page'
    1132 |                                 page->memcg_data = 0;
         |                                 ~~~~  ^
   2 errors generated.


vim +665 drivers/gpu/drm/ttm/ttm_pool.c

   617	
   618	/*
   619	 * When restoring, restore backed-up content to the newly allocated page and
   620	 * if successful, populate the page-table and dma-address arrays.
   621	 */
   622	static int ttm_pool_restore_commit(struct ttm_pool_tt_restore *restore,
   623					   struct file *backup,
   624					   const struct ttm_operation_ctx *ctx,
   625					   struct ttm_pool_alloc_state *alloc)
   626	
   627	{
   628		pgoff_t i, nr = 1UL << restore->order;
   629		struct page **first_page = alloc->pages;
   630		struct page *p;
   631		int ret = 0;
   632	
   633		for (i = restore->restored_pages; i < nr; ++i) {
   634			p = first_page[i];
   635			if (ttm_backup_page_ptr_is_handle(p)) {
   636				unsigned long handle = ttm_backup_page_ptr_to_handle(p);
   637	
   638				if (IS_ENABLED(CONFIG_FAULT_INJECTION) && ctx->interruptible &&
   639				    should_fail(&backup_fault_inject, 1)) {
   640					ret = -EINTR;
   641					break;
   642				}
   643	
   644				if (handle == 0) {
   645					restore->restored_pages++;
   646					continue;
   647				}
   648	
   649				ret = ttm_backup_copy_page(backup, restore->alloced_page + i,
   650							   handle, ctx->interruptible);
   651				if (ret)
   652					break;
   653	
   654				ttm_backup_drop(backup, handle);
   655			} else if (p) {
   656				/*
   657				 * We could probably avoid splitting the old page
   658				 * using clever logic, but ATM we don't care, as
   659				 * we prioritize releasing memory ASAP. Note that
   660				 * here, the old retained page is always write-back
   661				 * cached.
   662				 */
   663				ttm_pool_split_for_swap(restore->pool, p);
   664				copy_highpage(restore->alloced_page + i, p);
 > 665				p->memcg_data = 0;
   666				__free_pages(p, 0);
   667			}
   668	
   669			restore->restored_pages++;
   670			first_page[i] = ttm_backup_handle_to_page_ptr(0);
   671		}
   672	
   673		if (ret) {
   674			if (!restore->restored_pages) {
   675				dma_addr_t *dma_addr = alloc->dma_addr ? &restore->first_dma : NULL;
   676	
   677				ttm_pool_unmap_and_free(restore->pool, restore->alloced_page,
   678							dma_addr, restore->page_caching);
   679				restore->restored_pages = nr;
   680			}
   681			return ret;
   682		}
   683	
   684		ttm_pool_allocated_page_commit(restore->alloced_page, restore->first_dma,
   685					       alloc, nr);
   686		if (restore->page_caching == alloc->tt_caching || PageHighMem(restore->alloced_page))
   687			alloc->caching_divide = alloc->pages;
   688		restore->snapshot_alloc = *alloc;
   689		restore->alloced_pages += nr;
   690	
   691		return 0;
   692	}
   693	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

