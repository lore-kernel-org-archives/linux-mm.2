Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37351C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1384E6B0118; Wed, 29 Jul 2026 10:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1896B0119; Wed, 29 Jul 2026 10:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9DE76B011A; Wed, 29 Jul 2026 10:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A05D86B0118
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31F1F120614
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:52:14 +0000 (UTC)
X-FDA: 85041197388.26.D3C8A52
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf30.hostedemail.com (Postfix) with ESMTP id B270980004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:52:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U5quJ0q3;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785315132;
	b=l8X/yymVEyMq/kOWQX9WzXO0M36AOPL8441/u51sJD6/npqC66qPK/RD0LYJx0gVhJI3Qp
	JkR3+sI4k/u5aI9j9ilO7vlTjhWOku0MUT2rqou34BiJOxmUmcNxfRUS5XU8CejLtoIEdt
	ZxEKw8NH5jhfB9IgQSmvjyhzIIEuTSs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U5quJ0q3;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785315132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=6bE2YL1u9EN2d8Orh/RsIKswBdeUKvaHcsqweagAKvo=;
	b=GjA+WMq8YWqbxbGZJyWeXE652whkSTvxBoc6SZUe9UezTSqJg4AHA10baXTCGdPAyXAEXN
	cSD8Bxm1nh7J10wU9UKo+4YuTkU5MLvEznev/F9igU/q+QMf+22fkYsXwZvuwH6QaGT6rc
	YbMlEGsHlgSCYtpr+S6REVKl43t0HG4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785315132; x=1816851132;
  h=date:from:to:cc:subject:message-id;
  bh=ZdK2M1zPhw8cyOH4EyaUp7IeSmp7zMaxtDS0khpaKBM=;
  b=U5quJ0q3BdOiPLKwBZGU7VGCSIx4JLro2ERwj3oCIdqo0iw0aCh1RZKP
   PK4t2tulBUhAzJTee2dKqXOJtnMt7iB6trcVdgEb49AzMu2CsMvbxoGfC
   41psE1ko+gXtfja4VhISZZolk618bNEQL8jEtE3folXyrXYHJJqRZW5kx
   dUeccjl4WKrxQpeyqpE2FTu4XMn/hSm/TmPTgPjnnqxxOYmhyME1gghGp
   PIqQMDUEObqGPiqsjddCKLGRZZijSYonRJnobOCqOjkgZbaLRrQWbnCM0
   aZcCPMZ+Ow7+FEwAJVazPPyHDftD9rR+DSUhkU+NUw+1J5HVljBo17G14
   g==;
X-CSE-ConnectionGUID: irLcJ/bJTxuCc//9DdWVEw==
X-CSE-MsgGUID: eRnh9Ah8TUOkoQiSqaSddg==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="85928989"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="85928989"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 01:52:07 -0700
X-CSE-ConnectionGUID: J8R8eAAOT5CRCP3spor84w==
X-CSE-MsgGUID: j2Dw/idwT3ihHY4KJiuH3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="289901204"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 29 Jul 2026 01:52:01 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wp00o-00000000fDG-2BeM;
	Wed, 29 Jul 2026 08:51:46 +0000
Date: Wed, 29 Jul 2026 16:50:27 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Kairui Song <kasong@tencent.com>
Subject: [linux-next:master 9148/9778]
 drivers/gpu/drm/ttm/ttm_backup.c:163 ttm_backup_backup_folio() warn:
 inconsistent indenting
Message-ID: <202607291606.s2Hw3kEj-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B270980004
X-Stat-Signature: 1ro7dq11ng61nqmkw1y4acioe7hndk6j
X-Rspam-User: 
X-HE-Tag: 1785315131-287290
X-HE-Meta: U2FsdGVkX1+tsNUwoQZ45GJfM1EDbsX5uj90/kUUEOXJ/4uRBWDE/4QpBaLC616rffOKRjGVq4BNUrJsZAZ4ZETfvmCZVIBwO1ixZ4S6bF3fML4N1WPMZdFL86Aeno40cUeTqlKfbtfj2Gg9C69jq1u4y2T0hsJulgnfxAUPSOCB1hTT6jGSvD48Mthe3cWfSTOAIh2Dm0zhTKJBFhhm1/N69tlANTLWlYYfgIri/WJdGVYCMFWjrX/2pie+GxSCA0y7rDH+j/YTgT/+17dLKc4ZdeRKgbsSmJNQ4lM1WZVvqzughQiCWFpwnWf7UDs8GJofBXPf8phbjO4fDcTsMY1hoI10l7zCr0W/IJuhH6T27y2VYbT1vDx0bbUi+z31omMUsUXOQcexAOqAJ+hoA+KW/mGiJd0zWWWoYiGLRMsrr3JBR8/VWI3pW6Ahw5lYcokVQDfp3uq6EbNVrsOCai3NCWWHgbH5lwv0T9b+2BLZ7rd5jUimIsSMcbqksxjJDG/3vd4LaWuId+OAwKDRPQncKVWWmAMbRLgP2UmSPSEJi++9SsXODw3F560Y6ZqxWh6isy1eilh8S9YSJTq96+jUyeWpczIlK2bVfyM0n0D4zc37c7d32qmW54G9tdJhakYlM+X4Lkm/0NuVdjgGn7CCxmdDVrWL5BLKBI/mRzNPkNAw27uDZbf5mkQmso5g2EgbVmx4Ws6CSkh2JcD6mcEngl4EhO/D2E2Z4ODZi1MwjWfy25qGC2Ju/vTkiaMSSNNMR/H6+5zzhtsx/OTByjgLurQnAKoPhN3FBHVG2FbakntjJ9rLzlsarYbRCqAE8XPPMJSp5ZFL41NRotXbz/qdD1MIC2hj/53w9yyqZ8KDj5ElCG6PKDPHAa/5eOu9AcN4YHy+CKMI87SFwdnpkVBwfL6znxS5OxhVTrXulXlgBDHmtR81FZhM0/zJp2oNdcqIh8w9pUmYgPCFfhj
 ecb4XSpI
 F53l89cPpuUL3YDZhl9IZd405MZUi/HQTeDG6LRK90tjCnEOgScE44wE9SKyAFKBQr/fq9OnveMYEsTHA8rvKLWl4x2KPojOKCf3yoe7I+72LngAlmeXDs9gtK1MpSeBHFHn6pJcbQShL3ko9KrKJh8sA86miP4UguSIj99S7aStZEiPdrXSAjtGlquYoJdW2jdldM6iuGy3aVngXgTCuwsIvmerP7lE00UY82eURv/Fz6FTamk5Fe9XAyiQSKjKUsoTDfEjTyEDA+ExZTkITl2DaIB8UKi1/Na3o4jR3/aq8QhMNS0vpIO2H5BGHvZVY/hqiqEg9qiFlal0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   3652b49adac266a3d27cb41cdfdb7d8790fc3633
commit: 04b6dc72ddbc3192f17353492f0a9e1669c01725 [9148/9778] shmem: provide a shmem_write_folio wrapper
config: alpha-randconfig-r073-20260729 (https://download.01.org/0day-ci/archive/20260729/202607291606.s2Hw3kEj-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 9.5.0
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607291606.s2Hw3kEj-lkp@intel.com/

smatch warnings:
drivers/gpu/drm/ttm/ttm_backup.c:163 ttm_backup_backup_folio() warn: inconsistent indenting

vim +163 drivers/gpu/drm/ttm/ttm_backup.c

    70	
    71	/**
    72	 * ttm_backup_backup_folio() - Backup a folio
    73	 * @backup: The struct backup pointer to use.
    74	 * @folio: The folio to back up.
    75	 * @order: The allocation order of @folio.  Since TTM allocates higher-order
    76	 *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
    77	 *         return 1; the caller must pass the true order explicitly.
    78	 * @writeback: Whether to perform immediate writeback of the folio's pages.
    79	 * This may have performance implications.
    80	 * @idx: A unique integer for the first page of the folio and each struct backup.
    81	 * This allows the backup implementation to avoid managing
    82	 * its address space separately.
    83	 * @folio_gfp: The gfp value used when the folio was allocated.
    84	 * Currently unused.
    85	 * @alloc_gfp: The gfp to be used when allocating memory.
    86	 * @nr_pages_backed: Output. On a successful return, set to the number of
    87	 * pages actually backed up, which may be less than (1 << @order)
    88	 * if an -ENOMEM was encountered mid-folio.
    89	 *
    90	 * Context: If called from reclaim context, the caller needs to
    91	 * assert that the shrinker gfp has __GFP_FS set, to avoid
    92	 * deadlocking on lock_page(). If @writeback is set to true and
    93	 * called from reclaim context, the caller also needs to assert
    94	 * that the shrinker gfp has __GFP_IO set, since without it,
    95	 * we're not allowed to start backup IO.
    96	 *
    97	 * Return: A handle for the first backed-up page on success (handles for
    98	 * subsequent pages follow sequentially). -ENOMEM if no pages could be backed
    99	 * up. Any other negative error code if a non-ENOMEM failure occurred; in that
   100	 * case any pages backed up so far are truncated before returning.
   101	 */
   102	s64
   103	ttm_backup_backup_folio(struct file *backup, struct folio *folio,
   104				unsigned int order, bool writeback, pgoff_t idx,
   105				gfp_t folio_gfp, gfp_t alloc_gfp,
   106				pgoff_t *nr_pages_backed)
   107	{
   108		struct address_space *mapping = backup->f_mapping;
   109		int nr_pages = 1 << order;
   110		struct folio *to_folio;
   111		int ret, i;
   112	
   113		*nr_pages_backed = 0;
   114	
   115		for (i = 0; i < nr_pages; ) {
   116			int to_nr, j;
   117	
   118			/*
   119			 * Only inject past the first subpage so *nr_pages_backed is
   120			 * always > 0 here, matching a genuine mid-compound -ENOMEM
   121			 * and driving the caller's reactive split fallback instead
   122			 * of an early, no-progress failure.
   123			 */
   124			if (IS_ENABLED(CONFIG_FAULT_INJECTION) && i &&
   125			    ttm_backup_fault_inject_folio())
   126				to_folio = ERR_PTR(-ENOMEM);
   127			else
   128				to_folio = shmem_read_folio_gfp(mapping, idx + i, alloc_gfp);
   129			if (IS_ERR(to_folio)) {
   130				int err = PTR_ERR(to_folio);
   131	
   132				if (err == -ENOMEM && *nr_pages_backed)
   133					return ttm_backup_shmem_idx_to_handle(idx);
   134	
   135				if (*nr_pages_backed) {
   136					shmem_truncate_range(file_inode(backup),
   137							     (loff_t)idx << PAGE_SHIFT,
   138							     ((loff_t)(idx + i) << PAGE_SHIFT) - 1);
   139					/*
   140					 * The pages just truncated are no longer
   141					 * backed up; don't let the caller mistake
   142					 * them for valid handles.
   143					 */
   144					*nr_pages_backed = 0;
   145				}
   146				return err;
   147			}
   148	
   149			to_nr = min_t(int, nr_pages - i,
   150				      folio_next_index(to_folio) - (idx + i));
   151	
   152			folio_mark_accessed(to_folio);
   153			folio_lock(to_folio);
   154			folio_mark_dirty(to_folio);
   155	
   156			for (j = 0; j < to_nr; j++)
   157				copy_highpage(folio_file_page(to_folio, idx + i + j),
   158					      folio_page(folio, i + j));
   159	
   160			if (writeback && !folio_mapped(to_folio) &&
   161			    folio_clear_dirty_for_io(to_folio)) {
   162				folio_set_reclaim(to_folio);
 > 163			ret = shmem_write_folio(to_folio);
   164				if (!folio_test_writeback(to_folio))
   165					folio_clear_reclaim(to_folio);
   166				if (ret == AOP_WRITEPAGE_ACTIVATE)
   167					folio_unlock(to_folio);
   168			} else {
   169				folio_unlock(to_folio);
   170			}
   171	
   172			folio_put(to_folio);
   173			i += to_nr;
   174			*nr_pages_backed = i;
   175		}
   176	
   177		return ttm_backup_shmem_idx_to_handle(idx);
   178	}
   179	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

