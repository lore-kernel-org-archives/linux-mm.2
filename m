Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8D2CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D338E00E0; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE738E00B2; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8950B8E00E0; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2DC8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E7CE1A094D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:26:41 +0000 (UTC)
X-FDA: 84052133802.13.6E6FEF3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id CB9654000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:26:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U7BO9GvW;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761765999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4n6IFWWpzZKu6NSmTlY3ut4tNdEbBC9G7UihKubALE=;
	b=YpsoaWaRBpzwFPlPJW4hTlKrJKBP5Jh6QmZlCgS5rJBXhoBGscKJ6xTP8YkI3c5E2YS/0r
	Y1H5Py8N4KPf8x+CmnNQc9TC1e9GDZcNtWtzsV1EGPcoCM06kz0frt1lahsHZiKvHc9nRt
	LE//bd85G9pSYFy7tPc+YMTIrJBBZIg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U7BO9GvW;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761765999; a=rsa-sha256;
	cv=none;
	b=dffoK7odyiL0LqDGNy3g9mZclKTQeffuo5SmBu7xXU+lrvixwlbTwbKNj4q8RL4ohXDqmo
	tLWQqK84aKWWVx1mmtAUQ31HkDc1bJiY46ZJe5ucWczIM8dV51xOzrR0mrFsWjqsdZs+tZ
	qKp6PoEcOFTKzKAWOoUd2bUx7qd8Ycc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761765999; x=1793301999;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=EpU1pZ/ZyCZmWSEaOUHbj1u5kyy/IwYQpYaXIFYmGVA=;
  b=U7BO9GvWCp/Vok8Vishl4H/3a4wC5k5cU/3U2YDTsAw3EaeVX8MjqNdi
   5eMkhIdklaB5PWOc2C3DzsDEUeXAcu9JpixChEEZT+Am9vJFFMJeFjhHa
   O/aK/bey2t8nNdEgMKUQqZgOYHYFYzgjei4N84Eo74FrPrfv9r3XIIJvw
   sdHgbSghlmpyKcEUpLRAw+2w2XOm5gXnoDVjKcBi4fRZIZeMCqz41J7kS
   GiEeKn6gzvUdr7TKq61T4aN1INwfiRP21v2CcSucenFeJOJogJKqFxDy1
   rsytOUdmRG7Sqxe8ecTYfviE+5AdSMWFqg4bkkzodqXzpJ/6Cx3MPj6kT
   A==;
X-CSE-ConnectionGUID: XZxB40LDT7ezKomi6wGfxQ==
X-CSE-MsgGUID: nTo5h43LQ2SqL4oThZz8Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="63934005"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="63934005"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 12:26:37 -0700
X-CSE-ConnectionGUID: H/EVTNAfQxeA64z6D6c6rw==
X-CSE-MsgGUID: 8iWq2G2NRaiK5M3gXls/7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="190884229"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 29 Oct 2025 12:26:32 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vEBoT-000L60-2w;
	Wed, 29 Oct 2025 19:26:29 +0000
Date: Thu, 30 Oct 2025 03:25:46 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 14/19] mm, swap: sanitize swap entry management workflow
Message-ID: <202510300341.cOYqY4ki-lkp@intel.com>
References: <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com>
X-Stat-Signature: ise7pyhzyce6yt93mcioremwjd4oabf5
X-Rspamd-Queue-Id: CB9654000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761765998-605463
X-HE-Meta: U2FsdGVkX1824+3h5XNS0vdxzN7Chf7OzMtrKUZH36n5GruTNF29KvRodnRDgD9gnNMNTDQUkWmaBjYSNxdat3g7JwW4G56JOaJpqe00XA3bizaT7uIc6PH05J/lWc0QXVczlcX3ofXA6QQEcoFszXdygRNc30jO6nVqPMUpEaOV4O5i0lggxjTLNDMgqJBdAqc2iBM7/4BeEjs8S9d6IyH4vVIKBqOLFQTuCRkgYY5BV1Zb5qDg4AUxJK+IGGB/synRsrFWJ9pP/E401Syt6b6uty0zX3Qa2zBj1jpAcurRwJvFb+FdyRZPpgjuNJXhE/+9rieCGyQQdnqy7e1T8gxbGhmLjhBSb7H3vsDopQ2ZnkswFPtu+6r+jmCl02ON2uZsN9mGb8W0iPEeE3AgVbkuEqYU9MfHFefdAnQVJoYSIiwvSQiepBnM79McsdAdZ9AMUVJb5zLsczCLie1lCKq19VW3icQxOZjwip0+h3IcT+9iF/ZhfS0cHYEh3RmduorYyJJ9ri0Jlb05JRyatkOEaR05RIgojNEnT/KKzUwQCTaQ2sGSJVzIF744YU64Qhiz78/qC33sMlB1Rpa/ocJ2QeTVJN6113vVumrEPtItDHl9DPY1Y5A7IMq/yPalOuOUybL/H6xnXd3cy2Fze8fNIKsbTv61EZvwsexvuleHxgT6D9I9QSo6lMBYa5PGqZExq/F3O8u8J0F7iHfXMYjyoFfbcDmzFDwyFWUtlRp8eRLCWBg4CpFZ0DxVEwVY3L8vAukW+kkjPXCl5GPcokMG1mhguDl1gb+S0z6EepgPOrHD11/km21O3rBhSN/dqQI/+ZPnnbGFNnWm72CFE783FevDyTbnIKj/rKeydBk4VWWdCk3qbV7RtX7rub7A23CfpdU3ZYGESl4PmaJSeU/AB8WWt27BlBQJ/MbTuw5OWYZFPGodOabzCBijjtB/7PHXzv2S65kDZ3U3vbr
 b22GuFw8
 IzE5/Bg+YnFLncHMnEB8mQ4/ia4TLHV9Rmer48/bfNGciOau9xOIoyXLspJ8NcerR9vthmWrl5VLW6U/cNt+dsHczPl9tV9SW1z5rbJTD67eFH14E9NVRmUZQfkSTrdjumY0TeKWp6rCC7Me4LirjXV99AfDkhhGsw0S3NAHcFUmBiN6AE0hIN+PacbgxYbLKrodcOSLeWLYXAdBmxqpF967QPPmDR2JkJGoCAfpAZ0J5hCQU8x3ZQWcQzFPvzcGAHD8Zcx2o/E6PV+ofYakNoPZa2Jq2ZcK5sntW24+Sxg4wPh525UFQmcFO1G56YIpsCt0D+makVY06twfwr8d8p5dFjV74RxqUZb7utYe+YuuCJQIj283YQJW5I/gvR4VU6toQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build errors:

[auto build test ERROR on f30d294530d939fa4b77d61bc60f25c4284841fa]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251030-000506
base:   f30d294530d939fa4b77d61bc60f25c4284841fa
patch link:    https://lore.kernel.org/r/20251029-swap-table-p2-v1-14-3d43f3b6ec32%40tencent.com
patch subject: [PATCH 14/19] mm, swap: sanitize swap entry management workflow
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20251030/202510300341.cOYqY4ki-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251030/202510300341.cOYqY4ki-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510300341.cOYqY4ki-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/shmem.c:44:
   mm/swap.h:465:1: warning: non-void function does not return a value [-Wreturn-type]
     465 | }
         | ^
>> mm/shmem.c:1649:29: error: too few arguments to function call, expected 2, have 1
    1649 |         if (!folio_alloc_swap(folio)) {
         |              ~~~~~~~~~~~~~~~~      ^
   mm/swap.h:388:19: note: 'folio_alloc_swap' declared here
     388 | static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp)
         |                   ^                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning and 1 error generated.


vim +1649 mm/shmem.c

^1da177e4c3f41 Linus Torvalds          2005-04-16  1563  
7b73c12c6ebf00 Matthew Wilcox (Oracle  2025-04-02  1564) /**
7b73c12c6ebf00 Matthew Wilcox (Oracle  2025-04-02  1565)  * shmem_writeout - Write the folio to swap
7b73c12c6ebf00 Matthew Wilcox (Oracle  2025-04-02  1566)  * @folio: The folio to write
44b1b073eb3614 Christoph Hellwig       2025-06-10  1567   * @plug: swap plug
44b1b073eb3614 Christoph Hellwig       2025-06-10  1568   * @folio_list: list to put back folios on split
7b73c12c6ebf00 Matthew Wilcox (Oracle  2025-04-02  1569)  *
7b73c12c6ebf00 Matthew Wilcox (Oracle  2025-04-02  1570)  * Move the folio from the page cache to the swap cache.
7b73c12c6ebf00 Matthew Wilcox (Oracle  2025-04-02  1571)  */
44b1b073eb3614 Christoph Hellwig       2025-06-10  1572  int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
44b1b073eb3614 Christoph Hellwig       2025-06-10  1573  		struct list_head *folio_list)
7b73c12c6ebf00 Matthew Wilcox (Oracle  2025-04-02  1574) {
8ccee8c19c605a Luis Chamberlain        2023-03-09  1575  	struct address_space *mapping = folio->mapping;
8ccee8c19c605a Luis Chamberlain        2023-03-09  1576  	struct inode *inode = mapping->host;
8ccee8c19c605a Luis Chamberlain        2023-03-09  1577  	struct shmem_inode_info *info = SHMEM_I(inode);
2c6efe9cf2d784 Luis Chamberlain        2023-03-09  1578  	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
6922c0c7abd387 Hugh Dickins            2011-08-03  1579  	pgoff_t index;
650180760be6bb Baolin Wang             2024-08-12  1580  	int nr_pages;
809bc86517cc40 Baolin Wang             2024-08-12  1581  	bool split = false;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1582  
adae46ac1e38a2 Ricardo Cañuelo Navarro 2025-02-26  1583  	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
9a976f0c847b67 Luis Chamberlain        2023-03-09  1584  		goto redirty;
9a976f0c847b67 Luis Chamberlain        2023-03-09  1585  
9a976f0c847b67 Luis Chamberlain        2023-03-09  1586  	if (!total_swap_pages)
9a976f0c847b67 Luis Chamberlain        2023-03-09  1587  		goto redirty;
9a976f0c847b67 Luis Chamberlain        2023-03-09  1588  
1e6decf30af5c5 Hugh Dickins            2021-09-02  1589  	/*
809bc86517cc40 Baolin Wang             2024-08-12  1590  	 * If CONFIG_THP_SWAP is not enabled, the large folio should be
809bc86517cc40 Baolin Wang             2024-08-12  1591  	 * split when swapping.
809bc86517cc40 Baolin Wang             2024-08-12  1592  	 *
809bc86517cc40 Baolin Wang             2024-08-12  1593  	 * And shrinkage of pages beyond i_size does not split swap, so
809bc86517cc40 Baolin Wang             2024-08-12  1594  	 * swapout of a large folio crossing i_size needs to split too
809bc86517cc40 Baolin Wang             2024-08-12  1595  	 * (unless fallocate has been used to preallocate beyond EOF).
1e6decf30af5c5 Hugh Dickins            2021-09-02  1596  	 */
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1597) 	if (folio_test_large(folio)) {
809bc86517cc40 Baolin Wang             2024-08-12  1598  		index = shmem_fallocend(inode,
809bc86517cc40 Baolin Wang             2024-08-12  1599  			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
809bc86517cc40 Baolin Wang             2024-08-12  1600  		if ((index > folio->index && index < folio_next_index(folio)) ||
809bc86517cc40 Baolin Wang             2024-08-12  1601  		    !IS_ENABLED(CONFIG_THP_SWAP))
809bc86517cc40 Baolin Wang             2024-08-12  1602  			split = true;
809bc86517cc40 Baolin Wang             2024-08-12  1603  	}
809bc86517cc40 Baolin Wang             2024-08-12  1604  
809bc86517cc40 Baolin Wang             2024-08-12  1605  	if (split) {
809bc86517cc40 Baolin Wang             2024-08-12  1606  try_split:
1e6decf30af5c5 Hugh Dickins            2021-09-02  1607  		/* Ensure the subpages are still dirty */
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1608) 		folio_test_set_dirty(folio);
44b1b073eb3614 Christoph Hellwig       2025-06-10  1609  		if (split_folio_to_list(folio, folio_list))
1e6decf30af5c5 Hugh Dickins            2021-09-02  1610  			goto redirty;
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1611) 		folio_clear_dirty(folio);
1e6decf30af5c5 Hugh Dickins            2021-09-02  1612  	}
1e6decf30af5c5 Hugh Dickins            2021-09-02  1613  
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1614) 	index = folio->index;
650180760be6bb Baolin Wang             2024-08-12  1615  	nr_pages = folio_nr_pages(folio);
1635f6a74152f1 Hugh Dickins            2012-05-29  1616  
1635f6a74152f1 Hugh Dickins            2012-05-29  1617  	/*
1635f6a74152f1 Hugh Dickins            2012-05-29  1618  	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
1635f6a74152f1 Hugh Dickins            2012-05-29  1619  	 * value into swapfile.c, the only way we can correctly account for a
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1620) 	 * fallocated folio arriving here is now to initialize it and write it.
1aac1400319d30 Hugh Dickins            2012-05-29  1621  	 *
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1622) 	 * That's okay for a folio already fallocated earlier, but if we have
1aac1400319d30 Hugh Dickins            2012-05-29  1623  	 * not yet completed the fallocation, then (a) we want to keep track
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1624) 	 * of this folio in case we have to undo it, and (b) it may not be a
1aac1400319d30 Hugh Dickins            2012-05-29  1625  	 * good idea to continue anyway, once we're pushing into swap.  So
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1626) 	 * reactivate the folio, and let shmem_fallocate() quit when too many.
1635f6a74152f1 Hugh Dickins            2012-05-29  1627  	 */
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1628) 	if (!folio_test_uptodate(folio)) {
1aac1400319d30 Hugh Dickins            2012-05-29  1629  		if (inode->i_private) {
1aac1400319d30 Hugh Dickins            2012-05-29  1630  			struct shmem_falloc *shmem_falloc;
1aac1400319d30 Hugh Dickins            2012-05-29  1631  			spin_lock(&inode->i_lock);
1aac1400319d30 Hugh Dickins            2012-05-29  1632  			shmem_falloc = inode->i_private;
1aac1400319d30 Hugh Dickins            2012-05-29  1633  			if (shmem_falloc &&
8e205f779d1443 Hugh Dickins            2014-07-23  1634  			    !shmem_falloc->waitq &&
1aac1400319d30 Hugh Dickins            2012-05-29  1635  			    index >= shmem_falloc->start &&
1aac1400319d30 Hugh Dickins            2012-05-29  1636  			    index < shmem_falloc->next)
d77b90d2b26426 Baolin Wang             2024-12-19  1637  				shmem_falloc->nr_unswapped += nr_pages;
1aac1400319d30 Hugh Dickins            2012-05-29  1638  			else
1aac1400319d30 Hugh Dickins            2012-05-29  1639  				shmem_falloc = NULL;
1aac1400319d30 Hugh Dickins            2012-05-29  1640  			spin_unlock(&inode->i_lock);
1aac1400319d30 Hugh Dickins            2012-05-29  1641  			if (shmem_falloc)
1aac1400319d30 Hugh Dickins            2012-05-29  1642  				goto redirty;
1aac1400319d30 Hugh Dickins            2012-05-29  1643  		}
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1644) 		folio_zero_range(folio, 0, folio_size(folio));
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1645) 		flush_dcache_folio(folio);
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1646) 		folio_mark_uptodate(folio);
1635f6a74152f1 Hugh Dickins            2012-05-29  1647  	}
1635f6a74152f1 Hugh Dickins            2012-05-29  1648  
7d14492199f93c Kairui Song             2025-10-24 @1649  	if (!folio_alloc_swap(folio)) {
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1650  		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
6344a6d9ce13ae Hugh Dickins            2025-07-16  1651  		int error;
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1652  
b1dea800ac3959 Hugh Dickins            2011-05-11  1653  		/*
b1dea800ac3959 Hugh Dickins            2011-05-11  1654  		 * Add inode to shmem_unuse()'s list of swapped-out inodes,
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1655) 		 * if it's not already there.  Do it now before the folio is
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1656  		 * removed from page cache, when its pagelock no longer
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1657  		 * protects the inode from eviction.  And do it now, after
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1658  		 * we've incremented swapped, because shmem_unuse() will
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1659  		 * prune a !swapped inode from the swaplist.
b1dea800ac3959 Hugh Dickins            2011-05-11  1660  		 */
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1661  		if (first_swapped) {
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1662  			spin_lock(&shmem_swaplist_lock);
05bf86b4ccfd0f Hugh Dickins            2011-05-14  1663  			if (list_empty(&info->swaplist))
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  1664  				list_add(&info->swaplist, &shmem_swaplist);
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1665  			spin_unlock(&shmem_swaplist_lock);
ea693aaa5ce5ad Hugh Dickins            2025-07-16  1666  		}
b1dea800ac3959 Hugh Dickins            2011-05-11  1667  
80d6ed40156385 Kairui Song             2025-10-29  1668  		folio_dup_swap(folio, NULL);
b487a2da3575b6 Kairui Song             2025-03-14  1669  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
267a4c76bbdb95 Hugh Dickins            2015-12-11  1670  
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1671) 		BUG_ON(folio_mapped(folio));
6344a6d9ce13ae Hugh Dickins            2025-07-16  1672  		error = swap_writeout(folio, plug);
6344a6d9ce13ae Hugh Dickins            2025-07-16  1673  		if (error != AOP_WRITEPAGE_ACTIVATE) {
6344a6d9ce13ae Hugh Dickins            2025-07-16  1674  			/* folio has been unlocked */
6344a6d9ce13ae Hugh Dickins            2025-07-16  1675  			return error;
6344a6d9ce13ae Hugh Dickins            2025-07-16  1676  		}
6344a6d9ce13ae Hugh Dickins            2025-07-16  1677  
6344a6d9ce13ae Hugh Dickins            2025-07-16  1678  		/*
6344a6d9ce13ae Hugh Dickins            2025-07-16  1679  		 * The intention here is to avoid holding on to the swap when
6344a6d9ce13ae Hugh Dickins            2025-07-16  1680  		 * zswap was unable to compress and unable to writeback; but
6344a6d9ce13ae Hugh Dickins            2025-07-16  1681  		 * it will be appropriate if other reactivate cases are added.
6344a6d9ce13ae Hugh Dickins            2025-07-16  1682  		 */
6344a6d9ce13ae Hugh Dickins            2025-07-16  1683  		error = shmem_add_to_page_cache(folio, mapping, index,
6344a6d9ce13ae Hugh Dickins            2025-07-16  1684  				swp_to_radix_entry(folio->swap),
6344a6d9ce13ae Hugh Dickins            2025-07-16  1685  				__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
6344a6d9ce13ae Hugh Dickins            2025-07-16  1686  		/* Swap entry might be erased by racing shmem_free_swap() */
6344a6d9ce13ae Hugh Dickins            2025-07-16  1687  		if (!error) {
6344a6d9ce13ae Hugh Dickins            2025-07-16  1688  			shmem_recalc_inode(inode, 0, -nr_pages);
80d6ed40156385 Kairui Song             2025-10-29  1689  			folio_put_swap(folio, NULL);
6344a6d9ce13ae Hugh Dickins            2025-07-16  1690  		}
6344a6d9ce13ae Hugh Dickins            2025-07-16  1691  
6344a6d9ce13ae Hugh Dickins            2025-07-16  1692  		/*
fd8d4f862f8c27 Kairui Song             2025-09-17  1693  		 * The swap_cache_del_folio() below could be left for
6344a6d9ce13ae Hugh Dickins            2025-07-16  1694  		 * shrink_folio_list()'s folio_free_swap() to dispose of;
6344a6d9ce13ae Hugh Dickins            2025-07-16  1695  		 * but I'm a little nervous about letting this folio out of
6344a6d9ce13ae Hugh Dickins            2025-07-16  1696  		 * shmem_writeout() in a hybrid half-tmpfs-half-swap state
6344a6d9ce13ae Hugh Dickins            2025-07-16  1697  		 * e.g. folio_mapping(folio) might give an unexpected answer.
6344a6d9ce13ae Hugh Dickins            2025-07-16  1698  		 */
fd8d4f862f8c27 Kairui Song             2025-09-17  1699  		swap_cache_del_folio(folio);
6344a6d9ce13ae Hugh Dickins            2025-07-16  1700  		goto redirty;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1701  	}
b487a2da3575b6 Kairui Song             2025-03-14  1702  	if (nr_pages > 1)
b487a2da3575b6 Kairui Song             2025-03-14  1703  		goto try_split;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1704  redirty:
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1705) 	folio_mark_dirty(folio);
f530ed0e2d01aa Matthew Wilcox (Oracle  2022-09-02  1706) 	return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
^1da177e4c3f41 Linus Torvalds          2005-04-16  1707  }
7b73c12c6ebf00 Matthew Wilcox (Oracle  2025-04-02  1708) EXPORT_SYMBOL_GPL(shmem_writeout);
^1da177e4c3f41 Linus Torvalds          2005-04-16  1709  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

