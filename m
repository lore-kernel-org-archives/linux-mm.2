Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C0AD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E6B6B038F; Tue, 20 Jan 2026 04:11:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C3A6B0390; Tue, 20 Jan 2026 04:11:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B116B0391; Tue, 20 Jan 2026 04:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 416AA6B038F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:11:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA80B8ACE2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:11:56 +0000 (UTC)
X-FDA: 84351775032.26.74BE611
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9A8A51C0007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:11:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZTrAZams;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768900314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=szg5IQ98Or5Gi59BEnDoTgnNuPwokGFPQCEApME3dXs=;
	b=xhyRMzb4P3ivFBz0HdMLO1m0VNHVl2qYxcZrZh6iHWTHFisqaRsOo4HCUkJH0st90pbZus
	mWS/1TIlAYmkLkeN5H5J7pTtoVRyE+jR9RdroJd2gVsTwX3ZN90glZJSmuO83MTOiD24fY
	r99o/IKgd5Mvy14+NQ+gGmHwsBNHKoA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZTrAZams;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768900314; a=rsa-sha256;
	cv=none;
	b=GWIngY4GHG6kMH/6s5qP15awFf9fD2+2+SHgL1ktaRgHMOmBigM80LQj/ovNdfsdzRDFez
	Hor76jIYnSwY7HqpFJ/Sh9pgaCASte+YRI+3EQ5Jlswwmzx8+KM8M2Wz7UbVohvVg/BCqc
	40dbbcWJts43cPeNiFhzpNCEGIlnvSg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768900314; x=1800436314;
  h=date:from:to:cc:subject:message-id;
  bh=JrxKwrQLyzmRYseDka1fCr4Iiio7LvUtqyZYyMLehRQ=;
  b=ZTrAZamsWmokwOBsb+1yKFpvIkqKrkk/O+T8PcXz01xRc+BxbZXqAUo2
   b8jKjeJ3A6u75e2XMOZBqoV/KtDbHPiYBwAWC6M8G1r6iGans3gZvaqtm
   Y2JbfbplS3UYVWsgPn3fv9O3rWd7+ZIs8WfkenrKhdfbmKohZs6OEirTg
   M/XIfctjS8tQ0Si/kvn/TpDXTgSBCitkFTVDPdb5dNS1Al3sIxs8FWDp3
   5qvEGbfYFOdaeBJZkZ/IQx2Py3G3BztE4F3SLDspCmRUdLKVy4/7yZXvQ
   5HqaubiZYIa7ZNYBVhaMqHjqQnn7gOr/20vShz1YoLOyHmYeWdmTNZDAp
   w==;
X-CSE-ConnectionGUID: RDzSzpjhSlKNww9P6aal1g==
X-CSE-MsgGUID: K+HomEG7Szy1oHT7LNyLdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="80825466"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="80825466"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 01:11:52 -0800
X-CSE-ConnectionGUID: 91CWJxYbSkaohD/2HqzpPg==
X-CSE-MsgGUID: na7nsREnRH6LNQ3vRqS1uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="206119638"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 20 Jan 2026 01:11:50 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vi7m7-00000000Ol3-09ML;
	Tue, 20 Jan 2026 09:11:47 +0000
Date: Tue, 20 Jan 2026 17:10:47 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 418/422] fs/orangefs/file.c:414:9: sparse:
 sparse: dereference of noderef expression
Message-ID: <202601201701.IhxeGffs-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: qt1gz1djgqst3pz7bczocwyt51xpysue
X-Rspamd-Queue-Id: 9A8A51C0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768900313-327788
X-HE-Meta: U2FsdGVkX19RS2Xeov1FNVkT/I01f+39scRgshjjgfKxyEH9j70FPQUICpyLbJQUafuq+H16/jHvEY+DnImaTWsYEDao+DtP579vPIcF5M7XmwNKi5kDVhQ2s+ULe/yvC/4e1KavxDBODtLRNviAqEZMN4JCrSWFB8jK+34KQIwa4IgSBYJJCqeINy7wCpPDy6DGF1OdnbXoa4bCENEBzd9wiE6N4mYnO+JqL9VAiTPUiN3CGp+k4Gocn5vQYyxG5prkebTl0oKoOEgkP819FjLrAYGvd/CCMZEGn+MDUp9AByXaPsFnC9sU6AnVAOs5U8ZTR2CmA0UsxZ/HQL9gSxsdQsYHS4VyBxWrTd69V6OHdZTkxGZs0FqtL65r3w3z8O97RX6MoNjTd09iUwKE1xLq8VM0/hQaFTjlGkBiyYyzPADalUyPI2F335kioBEjXXehva3Js4Xu5sO3cy5p0ieQyKDSGuAKtmdze6DARbl9flBg+RSydFos5tTPzk++/xFN/MXNrA8QzEhO36c4jfo7jUoCZu+MPn2mEQYhq700DU6mVKxTDhxFlwTSNVh+jj03c9BKvFSKz8DrXn4ABbBNUog3ePtt6Orcb6qjuKKAu6M8ZkrCz3KRwoh8nSe9sRiWbHs7obIsgsbtded6wBa34PqAmTAEq8/COBfrh29HwY8Lefij6yVkrOsbBYjYJpz+8lssueHG63z3lwFJSaPKQOPJ8Sv3mxUyST6kqFCDBDm4VYerJ/c4dpwTFfCsfN20b6o7HBMTgIHHLPp5Ori5NzdgHwy2NWczR6IEMDxIWKd+CB19wPBatl57ADvxgQSeHpEzNAn2una7C9/GyF7/zzcUO5oTpvvjp/oT9/WHAqUi1wTqYzs2UJ7gBW8Jba4c3MwZlHpT318qsnaGzYa7VkEosmztafToqFYbkNVf6C6sOkunI3l/C/ANh3yGLBVOj7mjrIwZy4dXYuI
 /OEgMpFb
 Wf+JPKeaMJ91OdmX8J2xQazOcPtCSAkeSSEXpIpLdH3NbuOIdGNF/4ogiPfH2v2T40+WBz+QZ2XaxbBDW5tFb/L9dqvIhdXhBslA8CVBWSJ1dENle1Ye2AmgYfDlv9KrHi9igFwm6eaYBNwNh36wFKH2eh8Afi2x2gRkWWkVBomT+1z3iJNwdlTvWZLVwm8vqk7AoyrtDEsjNVlj5kC7MZxDYBtkNE61uLE1gMrSd1RBGH9YlefpKjv/KzPSiQLLgS67fkBuSo5ZPkhDC9RkhBXOWRQ==
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
commit: ccbdd8044f13617fe9f2bce61aed556314544664 [418/422] mm: update all remaining mmap_prepare users to use vma_flags_t
config: arm-randconfig-r131-20260120 (https://download.01.org/0day-ci/archive/20260120/202601201701.IhxeGffs-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201701.IhxeGffs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601201701.IhxeGffs-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/orangefs/file.c:414:9: sparse: sparse: dereference of noderef expression
   fs/orangefs/file.c: note: in included file (through arch/arm/include/asm/cacheflush.h, include/linux/cacheflush.h, include/linux/highmem.h, ...):
   include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1199:46: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1199:46: sparse: sparse: dereference of noderef expression
   fs/orangefs/file.c:415:9: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1216:48: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1216:48: sparse: sparse: dereference of noderef expression
--
>> fs/ramfs/file-nommu.c:267:40: sparse: sparse: dereference of noderef expression
>> fs/ramfs/file-nommu.c:267:40: sparse: sparse: dereference of noderef expression
   fs/ramfs/file-nommu.c: note: in included file:
   include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression

vim +414 fs/orangefs/file.c

   397	
   398	/*
   399	 * Memory map a region of a file.
   400	 */
   401	static int orangefs_file_mmap_prepare(struct vm_area_desc *desc)
   402	{
   403		struct file *file = desc->file;
   404		int ret;
   405	
   406		ret = orangefs_revalidate_mapping(file_inode(file));
   407		if (ret)
   408			return ret;
   409	
   410		gossip_debug(GOSSIP_FILE_DEBUG,
   411			     "orangefs_file_mmap: called on %pD\n", file);
   412	
   413		/* set the sequential readahead hint */
 > 414		vma_desc_set_flags(desc, VMA_SEQ_READ_BIT);
   415		vma_desc_clear_flags(desc, VMA_RAND_READ_BIT);
   416	
   417		file_accessed(file);
   418		desc->vm_ops = &orangefs_file_vm_ops;
   419		return 0;
   420	}
   421	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

