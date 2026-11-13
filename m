Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD32606EBB6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MijHPcsQ
Received: by kanga.kvack.org (Postfix)
	id 2B35A6B00EF; Fri, 13 Nov 2026 11:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264286B05B0; Fri, 13 Nov 2026 11:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17ACC6B05B9; Fri, 13 Nov 2026 11:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D79506B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBBE81A01C4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:03:09 +0000 (UTC)
X-FDA: 85430564898.27.F9BA637
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf14.hostedemail.com (Postfix) with ESMTP id C35F2100017
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:03:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MijHPcsQ;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794585787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=lv8NvC7HZDwkKZVoXw+7O2h5gIlJbnwmSDVX+2upUUs=;
	b=uQvRjbbFrU3d8ZmiszOQCjDzy/lsIdaIZIsEbXV+H5vk2mRFBLmKKqhH4vfQLjZ4ADaLBl
	ffeDxn3POeLQ6S1sykTDPLt/dH0H4gt4wFAo1lAdj8NgL5Ee9ZArlG1zGQEybgedxk0RMz
	xpW3cYYU0Xw1vMGN0PKtvPKD/QSq5Ok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794585787;
	b=jXmzq06PuOZ8niCaAzWf3bA9RS0mFqccTjUpWpV73yjEQBSZnHZaN729giar4CbvkJeBgW
	4+4xpl/pFZUzPKpOB+PabrhFXybiGwl2A8AxZJw+6RRzWMPsRdf4aI7Ju1LqnoNm1WyqCB
	3z7D0t3PuS83S4ZSyordEz9dORM1a5Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MijHPcsQ;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794585787; x=1826121787;
  h=date:from:to:cc:subject:message-id;
  bh=iTh6WixWUDEbiKZbg0v39EPO5GHw8FrjoVYrf52zqFs=;
  b=MijHPcsQt5Yszq90yQvE70aeu7HVcRtAD5KCu9Gk24MUYScUxmMExqXC
   oOZ4x6T9iEumQ1RWpOguwiplRnzzWYi4kuhocXykXNUCCMa7OURZGEWAL
   5dt4WTmSUHJhirA4FwDrd7AP4hqzb7OCYgjDk1WDco1fNpQbzfTAcfOlX
   VB965lL09GTi7TUlFrlFYL7wGmYJuM8IA54DU0Tel8hvMtIkP5XxRXcLK
   UMlsWFZHnWtFXwPXlzWwSYM53GYtKNzc7V/QxU8z9nW87bX0VCQI0MmsG
   aibjoJbKc4TuohOiw/1ni5JoYYlJyq64P39K1+YX0vlZg+Ztnlg8JIyCp
   w==;
X-CSE-ConnectionGUID: LwdRGEdMTvS6rXTkppwnhQ==
X-CSE-MsgGUID: nEbFhwbhQeOlI46qUptFxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3387172"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3387172"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 08:03:06 -0800
X-CSE-ConnectionGUID: Jn5E5HN0Q2SBwu/Ed/juJg==
X-CSE-MsgGUID: rMENWAhJSS+2U0SLEh4nqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="9118710"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 13 Nov 2026 08:03:03 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRtjx-000000001Id-0UlJ;
	Fri, 13 Nov 2026 16:03:01 +0000
Date: Fri, 13 Nov 2026 17:02:14 +0100
From: kernel test robot <lkp@intel.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 130/151] fs/squashfs/namei.c:141
 squashfs_lookup() warn: unsigned 'block' is never less than zero.
Message-ID: <202611131701.jmNjTw9l-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: agjeun6x5kd6tbg3y65j3n6ag818i4pe
X-Rspamd-Queue-Id: C35F2100017
X-Rspam-User: 
X-HE-Tag: 1794585786-830451
X-HE-Meta: U2FsdGVkX1/HNUcWjtT1LopwKWNsNRDfHqBo69tgys5DUXQnDGghQ6RxkQv73GIp6cvpf1gebJtse6t9StGPTslaIV3qKLdCbTxKlHK/WJ6B6bHMu0jHtJ68/CGJYvnNNjxKab4tnEaYhGf7mCnizSHMT1cURVQwXK02+D8kcD0HybIMeMlkxKveJw2sBnuDhBlzZkqdWN8zy22ZAN0ulYZHNIdPMAwuYHQG5y8AfAru95H48MYZGGdLjNQF+wSxe3Gfv+tbqFR29DS8SwQU8GnnbcJZP0mc5xOJPRtuZtflrWxtuctDpAf3lHCxvvx9BCJDNYnOyugQXP0Ja/rJGxVRs7S4puPJ6KxL+c1WTl5TRd6Y/8zy+7JjVVKI/bT9E9wFSJ6GRQBOypN7nTM7KbLvXJktImru1eLvN/lRW+mFAVJms/9n4n/vr11SmnF1Kb+Vui5CPEie1G1JN4DHprl++3BPzaI99W/D3FASBp7gdVU8oH0dmOBo6tZjFCXFvJRW9MmqAJ94XA2aNO714mUB0CEo9WafKMzIa/q1+KzZqJYGVmQ4H3Imn5S0TQ8sk1rTSVzrVOKpjEzml/vEHR3/D//7MFMBEJL0Aea+QeLzBfGanyI05I6nmnZbez4liWY9kQRq8psPHvRXzQqo+kIWsfKbRUxWWaaFvbTCaOpIlwDrK/c/T6gJMsvzUR1C2Q82Hn80vUaDyWUZwwD2P/IPTaf3CTd2Y3GUg5Bcqiqh6lQ4qL0lUG+Vc/lUpkgcyjjEjyZsoc6l/Bc462mgphTZHlz/0mTbZkz/tYbbi/PNYPr7YrOHODrzyizaygwLzH4l5izmOCjymRc/eE3jxaG5zxubuP/OjItfsJg0mEu2MislY53n7TpYdVzO/MZg7u3sZl6dcjnxpNnCeifPDecQTi9bgoDseMlTQXKAYot18uABCGJFWOO0MBkVGuHyV+54Df/RlxJ1Mjh2XSq
 wSmLHKln
 YzCrh1fG7ojCbShYO6Q22VmA6AiNZoRu5mwp05kuUNmHv5cOdDerNVTkLT2znQo6QBG5Z587cQWGbrMj39YyxqHdUSsBtG81PhSR7gzTSVOQtYBVN8Z+N3bzNWoxZv2z+ok59Qr6vAXlh+RwAj1TN5aUYkdf8vS5KFZm95+Pymt+AEb48hXH7XrKbn4wBG7Ea3mTD9mS04yzVjNyE/axegPM9vWXxhrVTPIXPP4IidkpNyXPQ9s4OWHAnHHzCMQzQXbqczPpqiaXS1Ovt0mxZ6MnzUs0yEHoUUrOb7XN2gJouHwv6mQRPtvpqKgLvkJapkk+YBtwipEwXbLc=
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
config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131701.jmNjTw9l-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611131701.jmNjTw9l-lkp@intel.com/

smatch warnings:
fs/squashfs/namei.c:141 squashfs_lookup() warn: unsigned 'block' is never less than zero.
fs/squashfs/namei.c:141 squashfs_lookup() warn: error code type promoted to positive: 'block'

vim +/block +141 fs/squashfs/namei.c

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

