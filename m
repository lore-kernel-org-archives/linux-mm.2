Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18CF606A884
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=R2K+7m9a
Received: by kanga.kvack.org (Postfix)
	id E98846B05BD; Fri, 13 Nov 2026 10:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49DB6B05BE; Fri, 13 Nov 2026 10:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D386D6B05BF; Fri, 13 Nov 2026 10:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9C706B05BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:21:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72816C0160
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:21:10 +0000 (UTC)
X-FDA: 85430459100.15.8B56FA9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf11.hostedemail.com (Postfix) with ESMTP id A1A294000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:21:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R2K+7m9a;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794583268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bU5DE/uhWdiN3flCELkoPLF66Si96iQIuQfP3K+4wkA=;
	b=KUr+H0zP++PNAccGizHvgF0aDnuOgwnZBFvuNTYKJyT7S8vmDx538suf/lh/rb+OE80uHV
	uJ8wUeyTU0MjN6vRo6H5AGFauY+V0emGAp9met/tD9EIfLaYPqhIdm4iWlZo6SkjPHBqvC
	GQhaJuMStFuLoq0kzt8+imEVgsuliyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794583268;
	b=n3VG+768lWJna8nIAE/GM99znq4Tpq+ZhHwevUStp8ueh57gM3FIDVZw3h9Z1CRs8FYDAN
	j0Y5x6k2ebwgxWYj5XhZd7fNOgcLwLN6d6Q7OjxIXPQ6a/yq9YjOT8rmroZU78m0Rz13Kc
	mven3JUhjMVZvIgRpCWt3iWLjRDJzQU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R2K+7m9a;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794583267; x=1826119267;
  h=date:from:to:cc:subject:message-id;
  bh=L6QYJH9KZ+SbJEA8B7OE4K6jcnlTKs2PVhoOR56VQKQ=;
  b=R2K+7m9aM7itSpOU3CeiqHaBwrL1+WHn9yGyhW4OeRX/2e3RYY2+m6mE
   Eyi05DFTXvcJTpmBi7uRFQMxecDBXKEHDopHrNrVklpj9zHzCL2SKFqtA
   zIempl0JbEe/r+3UGZdpgyWmeyA7xuqL9h+GkWqFK4tO3/PrulfluRIqn
   q15iuiVEk/0KJAv3SkMi1itiBdo+h7JO1jcJB1fCDsz7/weifGemE9bG9
   SWTWfCG6g4h8P0Lg1nKIgi4m9OUj4aAV3lfquJWtyUygCp3yJkawKZGu0
   s2fmvNAiiuXXHvSBAMdnGQEq5BRPxV0uJx5nCssWNrx312vE7rzwv+eGJ
   w==;
X-CSE-ConnectionGUID: g+pGEt4fQE+OSmSee0155g==
X-CSE-MsgGUID: ZJ9D9WS2TR6PRm+rfPBSeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3376606"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3376606"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 07:21:06 -0800
X-CSE-ConnectionGUID: pC0dXxRSQHe7r7sUecj34Q==
X-CSE-MsgGUID: v0XUbBShR3+ukcwWWO0PAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="9217798"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 13 Nov 2026 07:21:03 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRt5H-000000001IB-42Bs;
	Fri, 13 Nov 2026 15:20:59 +0000
Date: Fri, 13 Nov 2026 16:20:51 +0100
From: kernel test robot <lkp@intel.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 130/151]
 fs/squashfs/namei.c:141:21: sparse: sparse: unsigned value that used to be
 signed checked against zero?
Message-ID: <202611131605.L4Uvbf8p-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam06
X-Stat-Signature: oxsunewbzd865aagop4qo715r3xy9umd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A1A294000E
X-Rspam-User: 
X-HE-Tag: 1794583266-717882
X-HE-Meta: U2FsdGVkX1/EfCJ10TKQmnB28bDAlHY/aCYRoPszXsSeDVlyJQYfghU8EFjSMdGPEVSvulrD+iJzvd9BziXxv41Q+p2GzqEGQkZxT+SkKx8KCrDufJrQ0jYAQzHc2hYMmOjzrPWCTonh7xh/eIv/WttQYuB2/PtANeNuJdZ+wvw/zRDkFaxFkR+Avtix0zTCpaJ4/VWCEbBM5Ee8soUcu/WQmInJWCULmUlR0gz1q/gFVWw/jGn4djys/NH15gXmPCdsSgR0cT81/3o8n5ogA5FVGvLOLWOeXn1GXa5fcspH8Y7Py2MkUQdSr8nJQzz/Fk14rIKWlkhvIlrjs+c+x9annEX6/pTqCwoHLu/m3fFawOfsNJ8qWZZSylDEcYdnDRpuL1MFHClML4uwQX/b2AqNI2998Xbz7RR5qgwW5g5tjo5yRq+LYg/sqpmLs9qwayN/kNUCPVUT3gLi60L6ZT2cdn3Xc72HF06mJbV+Yq1ofQWm8V5guMVuH1z+zwcJt6JpgYEi+flBLxw2kEFdxKCQKOBllDsP8hwnAu9LqHJQb9LsmJPD0t9HQUMKKCFiDjMVrgouSvp7inpoHIcPeLXShpciIyU5wSakwkP06rM8f79Hvx5pdePkRsWHwnOUmZrGAVRQxxvGJC4a0mPDi6mguRn0qlSxdRJuTN2alYzOFQZwG/szDD8fktBE1yaUUvYrSh5Y58bC4qtL3E9ZjcJIkJdNR9SuzHd2HuHVqKUoQ7uQhOkqu+mnGRvVW4E+sHJLFZNOZAj+6XdY5dDRsiEHG3A4jh5PsLrtZtjg2qnNmbdgXjU+gHwEBmq6zwOLnIqjMlKLj7iAhVB/Prl6Cax6qorrVcPUjcfcQVXMM9rmpeX3li2jskLsogtUKZbAkHjZ/IIs30qkWwwCtQmE0Uejj8U49Fna60w40AnLYtvx49Sq0FZe/RgCnqmT9HjnYL9XjlfYLmwzuqf3tCP
 rFn1Y56S
 rRFZv+lR00TBQ9gUkzUsNxOTyPCxusTTJS/2b0J6rN0B0B7prEgidp90DjI4hcCSHnks0MMiAdJDfJNEAt5P5e7VBDaql6PXiyUqBPyn/iDdpvjHg6kzR5z/BzaMBnsk/OKLe6ivBHWjmdsRW0XOxXnFWDFE14VsytTNI7x4Sqid0TXzP/gWC7sYUJ2BciEaCLxl8fpnED65g6u/fZ6ZDCZUGXjTKv0nE3Mx02gvJ/e/2QnfbQKPd4Y7krrJ5XX8veaIxxu6971Ozzqut9KFFTOMOZUU+4htWGUDdjgfKKqjjy1KyzlW4KuclH/v4Gj0mcfhv2YfuE2xBjT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   152f0559e66c079f717de375f133ff127afb1f58
commit: 4dddf794b08bef04e5634dd4b52775a160d2cb6c [130/151] Squashfs: sanity check directory metadata block location
config: sh-randconfig-r2307-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131605.L4Uvbf8p-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 16.2.0
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611131605.L4Uvbf8p-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611131605.L4Uvbf8p-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/squashfs/namei.c:141:21: sparse: sparse: unsigned value that used to be signed checked against zero?
   fs/squashfs/namei.c: note: in included file:
   fs/squashfs/squashfs_helpers.h:79:24: sparse: signed value source

vim +141 fs/squashfs/namei.c

   123	
   124	
   125	static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
   126					 unsigned int flags)
   127	{
   128		const unsigned char *name = dentry->d_name.name;
   129		int len = dentry->d_name.len;
   130		struct inode *inode = NULL;
   131		struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
   132		struct squashfs_dir_header dirh;
   133		struct squashfs_dir_entry *dire = NULL;
   134		u64 block = squashfs_dir_start(squashfs_i(dir)->start, msblk);
   135		int offset = squashfs_i(dir)->offset;
   136		int err, length;
   137		unsigned int dir_count, size;
   138	
   139		TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start, offset);
   140	
 > 141		if (block < 0)
   142			goto data_error;
   143	
   144		dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
   145		if (dire == NULL) {
   146			ERROR("Failed to allocate squashfs_dir_entry\n");
   147			return ERR_PTR(-ENOMEM);
   148		}
   149	
   150		if (len > SQUASHFS_NAME_LEN) {
   151			err = -ENAMETOOLONG;
   152			goto failed;
   153		}
   154	
   155		length = get_dir_index_using_name(dir->i_sb, &block, &offset,
   156					squashfs_i(dir)->dir_idx_start,
   157					squashfs_i(dir)->dir_idx_offset,
   158					squashfs_i(dir)->dir_idx_cnt, name);
   159	
   160		while (length < i_size_read(dir)) {
   161			/*
   162			 * Read directory header.
   163			 */
   164			err = squashfs_read_metadata(dir->i_sb, &dirh, &block,
   165					&offset, sizeof(dirh));
   166			if (err < 0)
   167				goto read_failure;
   168	
   169			length += sizeof(dirh);
   170	
   171			dir_count = le32_to_cpu(dirh.count) + 1;
   172	
   173			if (dir_count > SQUASHFS_DIR_COUNT)
   174				goto data_error;
   175	
   176			while (dir_count--) {
   177				/*
   178				 * Read directory entry.
   179				 */
   180				err = squashfs_read_metadata(dir->i_sb, dire, &block,
   181						&offset, sizeof(*dire));
   182				if (err < 0)
   183					goto read_failure;
   184	
   185				size = le16_to_cpu(dire->size) + 1;
   186	
   187				/* size should never be larger than SQUASHFS_NAME_LEN */
   188				if (size > SQUASHFS_NAME_LEN)
   189					goto data_error;
   190	
   191				err = squashfs_read_metadata(dir->i_sb, dire->name,
   192						&block, &offset, size);
   193				if (err < 0)
   194					goto read_failure;
   195	
   196				length += sizeof(*dire) + size;
   197	
   198				if (name[0] < dire->name[0])
   199					goto exit_lookup;
   200	
   201				if (len == size && !strncmp(name, dire->name, len)) {
   202					unsigned int blk, off, ino_num;
   203					long long ino;
   204					blk = le32_to_cpu(dirh.start_block);
   205					off = le16_to_cpu(dire->offset);
   206					ino_num = le32_to_cpu(dirh.inode_number) +
   207						(short) le16_to_cpu(dire->inode_number);
   208					ino = squashfs_mkinode(blk, off);
   209	
   210					TRACE("calling squashfs_iget for directory "
   211						"entry %s, inode  %x:%x, %d\n", name,
   212						blk, off, ino_num);
   213	
   214					inode = squashfs_iget(dir->i_sb, ino, ino_num);
   215					goto exit_lookup;
   216				}
   217			}
   218		}
   219	
   220	exit_lookup:
   221		kfree(dire);
   222		return d_splice_alias(inode, dentry);
   223	
   224	data_error:
   225		err = -EIO;
   226	
   227	read_failure:
   228		ERROR("Unable to read directory block [%llx:%x]\n",
   229			squashfs_i(dir)->start, squashfs_i(dir)->offset);
   230	failed:
   231		kfree(dire);
   232		return ERR_PTR(err);
   233	}
   234	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

