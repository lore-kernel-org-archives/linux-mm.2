Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB24BD2ED11
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 04:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5C16B035C; Mon, 19 Jan 2026 23:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73826B035E; Mon, 19 Jan 2026 23:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A316B035D; Mon, 19 Jan 2026 23:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF3AE6B035B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:30:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BD8A1A03F2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:30:41 +0000 (UTC)
X-FDA: 84351066282.25.7464A52
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf08.hostedemail.com (Postfix) with ESMTP id 12ED2160004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:30:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="I1/HolLu";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768883439; a=rsa-sha256;
	cv=none;
	b=4SGqdBjcFZE8V4CxzouhC7qAfa19tXQm5uU3GbDpsH44RwnISQeSpKSanan9Re1Sy89wHR
	7q1ULbDvNLQmc4rt7BE3+5f5HQVdouyi3Qk59L1Zy92Ia9x4gJLpy8CVaoIlnp/+F/aLA+
	Ji5l38iHn9Fjme2+MRXW4/usJGUCtzU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="I1/HolLu";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768883439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UNjieSMd+cl4AHzb7gnfuf6q5V8I9tSHJ3MGmmPL/iU=;
	b=CbOmC18w4TmtQm7xHiLepAnjK9V/I51xTbYhDTZj87hJgPyFNqkZyQyjanEv358twainAZ
	NHUdj5mw18stIyaM9kZRD5hmfW6cSFigazdpo9UG8z3So8Wrt6MLiKt++cMgTg/U3whpmp
	/r0i4WSbrfMg3SjuGDOyCSEV5vIAKmQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768883439; x=1800419439;
  h=date:from:to:cc:subject:message-id;
  bh=bnRrjS8L9XDHdJbNZcmXtK0C52oP4D5RBWCLxdbnX0A=;
  b=I1/HolLuZskYURWacPOGIH7TRpGCaNzPbMYoMfRQHMgwTACQ4qTDDksF
   k8YCREA1q269wKgyqWd5nWnlt2YmiqmXnCZBM4YVqUkUW+UC5WDFImvn+
   BGLAo35R3Xc5UwIK25xxdY+eiUJWb0eIF5/GIPS8rAgNlIN6ugWjopXxq
   iEU1heIiLnrsSF3kuU5fwaiMb65bQBl3s1TwSXx7gXZbvFKBxb/X34Bng
   0SzI3Ew7kU/bkzcEOOnrZbgYKVX2xxJVY0sFqBQUyHqdkjpMt5zMf+bgJ
   PIYRM4iun3xKo2MUScxPaXfQ48cE9gSBy7Svo6NGeqkaSnIc2Pwwt11Q6
   A==;
X-CSE-ConnectionGUID: 85UXLsa3SNWdpZLrp1jSIw==
X-CSE-MsgGUID: 3G2kvuhnR2ORkEj/8EWzIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="87665234"
X-IronPort-AV: E=Sophos;i="6.21,239,1763452800"; 
   d="scan'208";a="87665234"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 20:30:37 -0800
X-CSE-ConnectionGUID: Tp7iMNLSSKelQdRZ/sjSag==
X-CSE-MsgGUID: MfUQDXIxTPunFB4oteBn4A==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 19 Jan 2026 20:30:35 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vi3Nx-00000000OYb-1cIN;
	Tue, 20 Jan 2026 04:30:33 +0000
Date: Tue, 20 Jan 2026 12:30:12 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 417/421] fs/ext4/file.c:825:36: error:
 incompatible type for argument 1 of 'daxdev_mapping_supported'
Message-ID: <202601201215.7iVpmWIM-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 12ED2160004
X-Rspamd-Server: rspam06
X-Stat-Signature: deab65an69i7byaa66tffe5uidhgpubd
X-Rspam-User: 
X-HE-Tag: 1768883438-707030
X-HE-Meta: U2FsdGVkX19dp1kwOSHhWDKvyU6eoiq3ztlBM8PIGQaHNmJ2tIu+Dd1YqJwBvijkedKpLZI9eGxmkojpox7nVZtYvlx/45oEfLs1OxockGqrDxbGoStBkiLHsk1P3/XEJIcK5hu8948buHijfJTJClEecLyMJ3joR+qvcOj9xceaqlZpUsZsF9Nfc0lAOflfZFCjyahuTzeI9je/Y7y13N7vFb4W0KI36vL485+jW4vDTUNLqmfIYRrqu7U9He2Tl1ov81Kv3tsG9Ir6trW9x+J/M36CXHm2/j4GiuO8N99g7kuhvx1PeaNmdbiTAP+33imlQFK4pJBEWWToQPokianoLq8yqyFM0lv8CTnliLy1j1QGy5UaQ7KjIdIqK/v1dEb8TdkcZU679V7t/LAL51npQUIKs/BADp0eIniru4sPrmH2JbngccnshA08daK1lnypVlWW1kkZxxZdo4roU7Hr628AswSV3tylFZyIvnguteL4UhyoINBu25IQk2eoRQL3E0WgO7RQH8N2iHw9bBNlePQbPSgU6nSBAfG/KdNkTF9+nPd1ZjdPBUJK4X3rCOlQGNal7G1QnQBEtLFMqCOhXgBR6G50djKc4MRaybe1FFO9CRQY1KXInXuCkhjktw8faCXld7OiAppiFdzpZkZMkOfeSqQ8IO6gtadaa46XplKTmLfihXPlkqkZSdMMTNNFMaZC0rCG8sRjA29zRbAuo1Vh/tgOjcwrLfVsBnMt/lHDLEtyrzgrjrIy7muQz57HdzXfzYHGzFPoSZaM3DYVyezcK/Tmck97ky5PGLqdnqVdr3LC1bazmKGwy9VucOauN6W4PUQRLr6P+D8tuuKg0WtumPC024ADyIhlJu9OD3RLkygUP+7lQ4hP9vp7135vz9XlqNXSDgH6ezB5qAjGhd3txZCYNlrpAYNW5yiDY9TYku/p+UQHYsUVJevoVmOgpE7M5MTiEvs4Q9B
 7maW0cb7
 huexMoCirD4SIZb753WTYKKTT6dPSfuzcdJx638NKV1rRLdC8TfGUseo/GkNREmZ6WolemP15ckE6loN01aFcpq3pTpwUxhlFVt/2o5xaDjqXSSypSsgpHAABWwaLbGO4tzvVMHX52IY4iZLkYke4NXhAqillq03x56t9KhRZ8j5ZB47HPQdGlD5moes5BXzsc8sFNKbp9SHVKq5AE8Gw2LH3mg2xxc7dFMQiVo02A1gMkPj30U9Y3+u7E6WcHBymZdqDhr/Jrp/UelkUQHZEU85MGJtOqTMX5eyIUjMhtCN1oEb4YE8H7MiKEcSkIr9VIsrO5YmNyU6yaJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   e4348a62bb1acacafcdeb149c9363291fae08c0c
commit: e3900da1b37f861133669d26ae02415f18fa71b9 [417/421] mm: update all remaining mmap_prepare users to use vma_flags_t
config: sparc-randconfig-002-20260120 (https://download.01.org/0day-ci/archive/20260120/202601201215.7iVpmWIM-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201215.7iVpmWIM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601201215.7iVpmWIM-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/ext4/file.c: In function 'ext4_file_mmap_prepare':
>> fs/ext4/file.c:825:36: error: incompatible type for argument 1 of 'daxdev_mapping_supported'
     if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file), dax_dev))
                                   ~~~~^~~~~~~~~~~
   In file included from fs/ext4/file.c:27:
   include/linux/dax.h:114:56: note: expected 'vm_flags_t' {aka 'long unsigned int'} but argument is of type 'vma_flags_t' {aka 'struct <anonymous>'}
    static inline bool daxdev_mapping_supported(vm_flags_t vm_flags,
                                                ~~~~~~~~~~~^~~~~~~~


vim +/daxdev_mapping_supported +825 fs/ext4/file.c

   806	
   807	static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
   808	{
   809		int ret;
   810		struct file *file = desc->file;
   811		struct inode *inode = file->f_mapping->host;
   812		struct dax_device *dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
   813	
   814		if (file->f_mode & FMODE_WRITE)
   815			ret = ext4_emergency_state(inode->i_sb);
   816		else
   817			ret = ext4_forced_shutdown(inode->i_sb) ? -EIO : 0;
   818		if (unlikely(ret))
   819			return ret;
   820	
   821		/*
   822		 * We don't support synchronous mappings for non-DAX files and
   823		 * for DAX files if underneath dax_device is not synchronous.
   824		 */
 > 825		if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file), dax_dev))
   826			return -EOPNOTSUPP;
   827	
   828		file_accessed(file);
   829		if (IS_DAX(file_inode(file))) {
   830			desc->vm_ops = &ext4_dax_vm_ops;
   831			vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
   832		} else {
   833			desc->vm_ops = &ext4_file_vm_ops;
   834		}
   835		return 0;
   836	}
   837	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

