Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA37A606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 11:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dTniAgqI
Received: by kanga.kvack.org (Postfix)
	id E97796B05B0; Sat,  7 Nov 2026 06:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DA36B05B1; Sat,  7 Nov 2026 06:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84C96B05B2; Sat,  7 Nov 2026 06:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF2706B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:46:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E8CB160303
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:46:37 +0000 (UTC)
X-FDA: 85408145634.03.C6F8B55
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id F061040005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:46:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dTniAgqI;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794051996;
	b=ZqRk3FFMDKbg9Q0URu4mZDJfeSnj1UGwz0UGX3Turw5+D6GgkGBHXreniiUW0MgIp8p/tD
	AXmrVQsZFKQ/vYnxLzzcj6feOj5gmcMKS/cpzmJTwGaRwWU/V2IFxXQStdH3nZDgBaqT3j
	NvvNunzlEVzsQM5SjMkh9X1hRsmWLl8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dTniAgqI;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794051996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=zM1/P2ctOrBwtv+YMeVyZT6n0J5gTkq5mrSckM4inFc=;
	b=qAr3hCLoBQWEzeMbdhPM5g++eGMjIrzIxoXx60AFMz8I+lA6KLVG8K+ne8B+Rx9SMCFqN+
	ISQBEobXQI2Vi4V7O2sNnO+NIg0WfTxsXaPkl6DmOG41U+pY/35aQ15bVHTdz0ft9B3JEW
	8cOT5S7/WES+y+9xFZldke9TQprvsqk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794051996; x=1825587996;
  h=date:from:to:cc:subject:message-id;
  bh=j+jS94c1YiejLYng66Mf7QxbZbymVWA3jh9x9DO2sgk=;
  b=dTniAgqIkt/ufVBt45sING9+ffaHa0ibjTYg9kDvjQb8VNvoTn3XCVBp
   mBW4qsH/GAqjEt+azwH6TS061grG+wcTH/v4pxdOtQd3Fww5ufkhiY07P
   fAyYCXwHys9nyJSasCNJdMUVriOdn5DmMNj9Onzi4tmRWhZmoYQBnU3m5
   6vJ8MG1OkVcbcj1pUGhqMWVhhWkCMNO4C2lgZ4qKtsj5+gMzKBVvQPUha
   gZIpJioREazV3A+i1Q1eNOj2UTcHbNWdJ7prq+SJst7R1J0LEBHTfmE+I
   hv7o5M0YtjdeCp9rPS+qvaZuw8wwPBGvYjUmnEllsWuV/qkPLmJN49Pc7
   w==;
X-CSE-ConnectionGUID: KtVejbMPQCa8xf5Fc3OKPg==
X-CSE-MsgGUID: CXhXlAq0RCWYb26+rIKYJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2894826"
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="2894826"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2026 03:46:34 -0800
X-CSE-ConnectionGUID: 0TN2zplJSye1UOzb/1TK/g==
X-CSE-MsgGUID: pG/rMiwlQEq2guKOfReSIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="7374162"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 07 Nov 2026 03:46:30 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPesO-00000000qmJ-1NOq;
	Sat, 07 Nov 2026 11:46:28 +0000
Date: Sat, 07 Nov 2026 19:45:47 +0800
From: kernel test robot <lkp@intel.com>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [akpm-mm:mm-nonmm-unstable 111/117]
 fs/squashfs/file_direct.c:121:1: warning: unused label 'out'
Message-ID: <202611071907.Jdbx14bw-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: x8uo43rxsrsfwzia7zgen8u4px9ynw96
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F061040005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794051994-24370
X-HE-Meta: U2FsdGVkX1++gwL6jlgMadBy4Jc3SwxGfq7LJf7ANv6UXeeog/bLlVSwubpObiTFlVapBA/+TLdVxJJtHNCItRqPxi8cy+noFl0KM2pDTsKoulILfaYSFU/SWGACkvj6fdbc3DRs0qB1yqlak59s/HcNWeYNaxxIFkF73yZdwnp515BSCMZyuj6iNuWm6lSqxxfQzJSeIhueG8Pd1aNl3ekpZLXCmRNzr7z5YrouS5bUya4VElNNkr8gtc5RFQotVt4RGOJwTvYqlvlfiRkrOKJdMVsSiSDgA/cAaN2Pb1PUlv8mpBNO0iPJtchnxJzIVOuE2DnpiPvS1hhhSld4Rv9kn3dqTHP0nDYSEyg8Nq4/GOKKadEYq8opLCBrsZhnIzQqbaw+hGWHEPJzjFLeese90H8/Lh80Fl1HKl8QuVgo9oMq+mt3Xv22KPDAJb/TWZRfwOSt/c3SFRf4w42tWgrIL7Vg0BJCSZsTNUWVmC4btk7Tkf31/ufmZ8yW9d4LeVRvLK3VHZElMlIFUfWYyydjwmZrpQ5w809aQJSk0pXGsvjGVoUkG4Tt/M2pw2PuncBONqB+G7MaVrEnyzb3UWRHIU/AUaGSQOL5dRKbeldGQ3e7qqo4yrQmYFXPrEQPhPhYuVewhOL7lpOR0QMpJ7RunsYE6RLJraO7TRf7O+JqehN/cMTASXMf9S+Q1BDh6WABUxsFPrImMWe8HMBs4T/9m1NVRJW68iH7UgV6SWLMae+Dty3BHpxqmbGlMPovREoXItX8aa+Nsb13nv/JHTK9N7GkKJfmr8t8P3INP8HXs15ClCjjzuKgO46pYhoNo80KtYT9ajsYaLRUNM+SQyzFIVghXLJn1fb9Tc0AnnjvEKc/k5LR5yA2afaTJM8wN/nGeD8UMfVPiCqjKuokyTI+QlxDh3bYosQ4FLGh9qSPxiwAfljyPtHq5EYqrd7xFfOYZfw7XBu6ZBV8Zfi
 W3Rh8s3d
 x4jwD8iftA7ZOFbA4ZTZHJvPxLNX4JA0IO2SZJnK4IatsBXrEkHKuBDU9omJbU6ob7eRuuwnQJvFzcUKl+VkYi9OAhVWqm7YuGa5u6GrqxvsdGIkV/rG3s/TtgBT+5OY7FMXygXHvzXwn7ZTBAWW3s7vdORUrQrlTYkfxP0iwXmdGMZ5cPbT82ivivfDbp5nSs/EUChvT9ud/xQGpHDp6vIi1bu+lpFwSs6Laq3HymqqhBLmVF3MI/nyQcf1NgXxnUT4Kg4+XIJLKWzZZtHhxkK82uZO+RRUklL4/Scl6zrmq7ThY61zfSmRImuibq4Xvp2k+rGI+4AzmDQY+hcQUCR3QOukbjKCPWPIUIGtvfqFsjfGD7UmFA3lnFJQR6oNM7rrTkPy85Vk3niXkbIG/H43v5miUYzITZIiJn4f5ZMfHGqaf6f7+DPQaqRyVUYjGnDBjnWHWiy8m3yURojl/RhRD+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   09658a93dbdf3596b7c0edec1292ae09e58da333
commit: 024c3b9753561e3ad2d6cdd47b405126709633e0 [111/117] squashfs: fix leaked page locks when page actor allocation fails
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20261107/202611071907.Jdbx14bw-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project fc9576e3b179738d99c5babe5cd9d6c1f883e0db)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261107/202611071907.Jdbx14bw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611071907.Jdbx14bw-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/squashfs/file_direct.c:121:1: warning: unused label 'out' [-Wunused-label]
     121 | out:
         | ^~~~
   1 warning generated.


vim +/out +121 fs/squashfs/file_direct.c

0d455c12c64286 Phillip Lougher         2013-11-13   20  
0d455c12c64286 Phillip Lougher         2013-11-13   21  /* Read separately compressed datablock directly into page cache */
2a7aea59cf4dd4 Matthew Wilcox (Oracle  2024-12-20   22) int squashfs_readpage_block(struct folio *folio, u64 block, int bsize,
a3f94cb99a854f Phillip Lougher         2018-08-02   23  		int expected)
0d455c12c64286 Phillip Lougher         2013-11-13   24  {
2a7aea59cf4dd4 Matthew Wilcox (Oracle  2024-12-20   25) 	struct page *target_page = &folio->page;
2a7aea59cf4dd4 Matthew Wilcox (Oracle  2024-12-20   26) 	struct inode *inode = folio->mapping->host;
0d455c12c64286 Phillip Lougher         2013-11-13   27  	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
12427de9439d68 Phillip Lougher         2023-11-13   28  	loff_t file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
09cbfeaf1a5a67 Kiryl Shutsemau         2016-04-01   29  	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
7f73fcde4d9307 Phillip Lougher         2024-08-19   30  	loff_t start_index = folio->index & ~mask;
12427de9439d68 Phillip Lougher         2023-11-13   31  	loff_t end_index = start_index | mask;
d31638ff6c5437 Phillip Lougher         2024-10-21   32  	loff_t index;
d31638ff6c5437 Phillip Lougher         2024-10-21   33  	int i, pages, bytes, res = -ENOMEM;
7f73fcde4d9307 Phillip Lougher         2024-08-19   34  	struct page **page, *last_page;
0d455c12c64286 Phillip Lougher         2013-11-13   35  	struct squashfs_page_actor *actor;
0d455c12c64286 Phillip Lougher         2013-11-13   36  	void *pageaddr;
0d455c12c64286 Phillip Lougher         2013-11-13   37  
0d455c12c64286 Phillip Lougher         2013-11-13   38  	if (end_index > file_end)
0d455c12c64286 Phillip Lougher         2013-11-13   39  		end_index = file_end;
0d455c12c64286 Phillip Lougher         2013-11-13   40  
0d455c12c64286 Phillip Lougher         2013-11-13   41  	pages = end_index - start_index + 1;
0d455c12c64286 Phillip Lougher         2013-11-13   42  
14694888db2c1f Fabian Frederick        2014-08-06   43  	page = kmalloc_array(pages, sizeof(void *), GFP_KERNEL);
0d455c12c64286 Phillip Lougher         2013-11-13   44  	if (page == NULL)
0d455c12c64286 Phillip Lougher         2013-11-13   45  		return res;
0d455c12c64286 Phillip Lougher         2013-11-13   46  
0d455c12c64286 Phillip Lougher         2013-11-13   47  	/* Try to grab all the pages covered by the Squashfs block */
d31638ff6c5437 Phillip Lougher         2024-10-21   48  	for (i = 0, index = start_index; index <= end_index; index++) {
d31638ff6c5437 Phillip Lougher         2024-10-21   49  		page[i] = (index == folio->index) ? target_page :
2a7aea59cf4dd4 Matthew Wilcox (Oracle  2024-12-20   50) 			grab_cache_page_nowait(folio->mapping, index);
0d455c12c64286 Phillip Lougher         2013-11-13   51  
1bb1a07afad973 Phillip Lougher         2022-06-11   52  		if (page[i] == NULL)
0d455c12c64286 Phillip Lougher         2013-11-13   53  			continue;
0d455c12c64286 Phillip Lougher         2013-11-13   54  
0d455c12c64286 Phillip Lougher         2013-11-13   55  		if (PageUptodate(page[i])) {
0d455c12c64286 Phillip Lougher         2013-11-13   56  			unlock_page(page[i]);
09cbfeaf1a5a67 Kiryl Shutsemau         2016-04-01   57  			put_page(page[i]);
1bb1a07afad973 Phillip Lougher         2022-06-11   58  			continue;
0d455c12c64286 Phillip Lougher         2013-11-13   59  		}
0d455c12c64286 Phillip Lougher         2013-11-13   60  
1bb1a07afad973 Phillip Lougher         2022-06-11   61  		i++;
0d455c12c64286 Phillip Lougher         2013-11-13   62  	}
0d455c12c64286 Phillip Lougher         2013-11-13   63  
1bb1a07afad973 Phillip Lougher         2022-06-11   64  	pages = i;
1bb1a07afad973 Phillip Lougher         2022-06-11   65  
f268eedddf3595 Phillip Lougher         2022-06-11   66  	/*
f268eedddf3595 Phillip Lougher         2022-06-11   67  	 * Create a "page actor" which will kmap and kunmap the
f268eedddf3595 Phillip Lougher         2022-06-11   68  	 * page cache pages appropriately within the decompressor
f268eedddf3595 Phillip Lougher         2022-06-11   69  	 */
2258e22f05aff5 Phillip Lougher         2024-08-19   70  	actor = squashfs_page_actor_init_special(msblk, page, pages, expected,
2258e22f05aff5 Phillip Lougher         2024-08-19   71  						start_index << PAGE_SHIFT);
f268eedddf3595 Phillip Lougher         2022-06-11   72  	if (actor == NULL)
024c3b9753561e Nguyen Ngoc Thang       2026-09-27   73  		goto mark_errored;
f268eedddf3595 Phillip Lougher         2022-06-11   74  
0d455c12c64286 Phillip Lougher         2013-11-13   75  	/* Decompress directly into the page cache buffers */
0d455c12c64286 Phillip Lougher         2013-11-13   76  	res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
f268eedddf3595 Phillip Lougher         2022-06-11   77  
7f73fcde4d9307 Phillip Lougher         2024-08-19   78  	last_page = squashfs_page_actor_free(actor);
f268eedddf3595 Phillip Lougher         2022-06-11   79  
0d455c12c64286 Phillip Lougher         2013-11-13   80  	if (res < 0)
0d455c12c64286 Phillip Lougher         2013-11-13   81  		goto mark_errored;
0d455c12c64286 Phillip Lougher         2013-11-13   82  
84e0e03b308816 Phillip Lougher         2024-08-23   83  	if (res != expected || IS_ERR(last_page)) {
a3f94cb99a854f Phillip Lougher         2018-08-02   84  		res = -EIO;
a3f94cb99a854f Phillip Lougher         2018-08-02   85  		goto mark_errored;
a3f94cb99a854f Phillip Lougher         2018-08-02   86  	}
a3f94cb99a854f Phillip Lougher         2018-08-02   87  
1bb1a07afad973 Phillip Lougher         2022-06-11   88  	/* Last page (if present) may have trailing bytes not filled */
09cbfeaf1a5a67 Kiryl Shutsemau         2016-04-01   89  	bytes = res % PAGE_SIZE;
7f73fcde4d9307 Phillip Lougher         2024-08-19   90  	if (end_index == file_end && last_page && bytes) {
7f73fcde4d9307 Phillip Lougher         2024-08-19   91  		pageaddr = kmap_local_page(last_page);
09cbfeaf1a5a67 Kiryl Shutsemau         2016-04-01   92  		memset(pageaddr + bytes, 0, PAGE_SIZE - bytes);
1bb1a07afad973 Phillip Lougher         2022-06-11   93  		kunmap_local(pageaddr);
0d455c12c64286 Phillip Lougher         2013-11-13   94  	}
0d455c12c64286 Phillip Lougher         2013-11-13   95  
0d455c12c64286 Phillip Lougher         2013-11-13   96  	/* Mark pages as uptodate, unlock and release */
0d455c12c64286 Phillip Lougher         2013-11-13   97  	for (i = 0; i < pages; i++) {
0d455c12c64286 Phillip Lougher         2013-11-13   98  		flush_dcache_page(page[i]);
0d455c12c64286 Phillip Lougher         2013-11-13   99  		SetPageUptodate(page[i]);
0d455c12c64286 Phillip Lougher         2013-11-13  100  		unlock_page(page[i]);
0d455c12c64286 Phillip Lougher         2013-11-13  101  		if (page[i] != target_page)
09cbfeaf1a5a67 Kiryl Shutsemau         2016-04-01  102  			put_page(page[i]);
0d455c12c64286 Phillip Lougher         2013-11-13  103  	}
0d455c12c64286 Phillip Lougher         2013-11-13  104  
0d455c12c64286 Phillip Lougher         2013-11-13  105  	kfree(page);
0d455c12c64286 Phillip Lougher         2013-11-13  106  
0d455c12c64286 Phillip Lougher         2013-11-13  107  	return 0;
0d455c12c64286 Phillip Lougher         2013-11-13  108  
0d455c12c64286 Phillip Lougher         2013-11-13  109  mark_errored:
bbf45b7e685555 Matthew Wilcox (Oracle  2024-04-20  110) 	/* Decompression failed.  Target_page is
0d455c12c64286 Phillip Lougher         2013-11-13  111  	 * dealt with by the caller
0d455c12c64286 Phillip Lougher         2013-11-13  112  	 */
0d455c12c64286 Phillip Lougher         2013-11-13  113  	for (i = 0; i < pages; i++) {
6d565409503f4e Phillip Lougher         2013-11-24  114  		if (page[i] == NULL || page[i] == target_page)
0d455c12c64286 Phillip Lougher         2013-11-13  115  			continue;
0d455c12c64286 Phillip Lougher         2013-11-13  116  		flush_dcache_page(page[i]);
0d455c12c64286 Phillip Lougher         2013-11-13  117  		unlock_page(page[i]);
09cbfeaf1a5a67 Kiryl Shutsemau         2016-04-01  118  		put_page(page[i]);
0d455c12c64286 Phillip Lougher         2013-11-13  119  	}
0d455c12c64286 Phillip Lougher         2013-11-13  120  
0d455c12c64286 Phillip Lougher         2013-11-13 @121  out:

:::::: The code at line 121 was first introduced by commit
:::::: 0d455c12c6428647547bacccaaced3cae0f35570 Squashfs: Directly decompress into the page cache for file data

:::::: TO: Phillip Lougher <phillip@squashfs.org.uk>
:::::: CC: Phillip Lougher <phillip@squashfs.org.uk>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

