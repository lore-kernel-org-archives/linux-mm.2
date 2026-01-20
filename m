Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144AAD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 04:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7816B035B; Mon, 19 Jan 2026 23:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056006B035D; Mon, 19 Jan 2026 23:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63CF6B035F; Mon, 19 Jan 2026 23:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C27866B035B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:30:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66500D1D21
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:30:41 +0000 (UTC)
X-FDA: 84351066282.23.F36FA5C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf22.hostedemail.com (Postfix) with ESMTP id AACE6C0008
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:30:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TeNDkJxz;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768883439; a=rsa-sha256;
	cv=none;
	b=5DA/KlwUcYCW2yOMUJjp2Q1PQSDRpjCBS8+wCZ8Xp3FPFIppjXsJ8dRVzRoHhXYIL/rkrZ
	bIGiPPh3HtF4CuLrJ97gyScpWQaozaDQWTjOl6aoEMwPf8ewlty0OEBwXjtiGfl1pIrEk8
	3urCrkitJsRjZnFywHLyh48CrEADJ24=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TeNDkJxz;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768883439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=V3JiTEhLyU4q7IDiGq2/OMFlaNEWlkDCm4c9ownhrBw=;
	b=R7XS8kBZCSOR8asx4H4M1Y3hRPf4yMC7qnywh8vxM0n8/WisuV1FmiNANP9ImVpkmJnnam
	YiYulWwHQbA9jltHi2MgLsRQHR8FvoTOIBTVbPMtdH/7hw2P8NhBJx1SBP4vPEdn2ZgDq3
	TLfMwdz37/NXh57GpemI0zo3oc3+2Eg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768883439; x=1800419439;
  h=date:from:to:cc:subject:message-id;
  bh=IvCvtGFMU+zMSiL0kWDIyAHqIaW7BLSXNeH5bGaW47U=;
  b=TeNDkJxzD1N/Z0knr2YUaaxVd/vrM9irU+6EzrF3+cHYorqM1qSOe+KF
   T10yBe1SSMvjfMTdK+gzJwDtXsMxXdBetpM8R1uv88TCVPI6WAqS/p4ZK
   X5p0YXWgunAxZF0ANCDE8+9QQ8DzbuqQ0qCHmeQZj8b6b5ma6QVX0Ati+
   m8ZJxH6vpo6reB8U8NPC612J1+lPX15MEwvn6fjEazwve2dI9/epF19Pq
   nzhxNv0FLVxzo0cmh3kob/hngQkim0CkKm2d+eh6S7aPK2pTMqORQX+FC
   1JJUo+V3GivX78CFAP8UwYglLYVDA4hOa+pld7Wh18NuqH3l7Hw1ouMRQ
   w==;
X-CSE-ConnectionGUID: IXKif00gTaCNSV58/aGbRw==
X-CSE-MsgGUID: srDWZM8eRQueFPQJXM3ODw==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="73712885"
X-IronPort-AV: E=Sophos;i="6.21,239,1763452800"; 
   d="scan'208";a="73712885"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 20:30:38 -0800
X-CSE-ConnectionGUID: FfXQy86jRFGTwne+Pzv4WA==
X-CSE-MsgGUID: gBv55u1URiK0U0cd0gobqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,239,1763452800"; 
   d="scan'208";a="228940070"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 19 Jan 2026 20:30:35 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vi3Nx-00000000OYd-1ptv;
	Tue, 20 Jan 2026 04:30:33 +0000
Date: Tue, 20 Jan 2026 12:30:13 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 417/421] fs/xfs/xfs_file.c:1977:36: error:
 incompatible type for argument 1 of 'daxdev_mapping_supported'
Message-ID: <202601201209.cGuf98oB-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: hon144nug33sdr3fpjbqns8r41dbs36c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AACE6C0008
X-Rspam-User: 
X-HE-Tag: 1768883438-100205
X-HE-Meta: U2FsdGVkX1/7BeD+lJ4T1oCuaJVVq0e9nd8KiT/HgpTV4GjkEhi2qNF414N4koHhmsrWeBKNcJuuIweP5ElNhDqJ5rqEQYwIdfoTPpVDiWZf2psYFa3epaIOqTLarSQZVxSTv4fQV5+kpJj9mh0ugzHM8tcVDb2kBK9vn//bCHEKeXIab6mvVwKhTs07XU+RY9RUjLjMNw7Iq28SkCQcS+o+4WtPhwll4cWXOp4VTuH7gWzvoQBAs06v0EFBhNjTA4HddOMWDDZSPUdd6WYDMfxhQHxDJ1VQjJSe3rFgWgwkc+gaNGMx/SJkI8O3c713OP74llGm2X/PGXxLDmwoXrzcQzObNGGddrDBr587az0EBNe34XXcqiu4rw3DcsxHL/Jl2S1djQmG3N4aFB0tv3iuMmm+euixLs8WRSA7BYlrzZQbbBrQ/xTAn2no6mvUFnFuTkYJvxAn6Up5aTPNc6hqd/hogAnk7KtnyJs6GMoxxktXsoPLGXx/R3UxWiFvNS27H20rDrkqNIVAPbxwcD4robk5hW0kVISI9CW5H9S93cfj+BcpuLcaFZdEpNCp2fERdwKO6qL0OPzES3amIBS/Yfdfau3D3D89bgn+CW5dcU+sr2NdZfgPEPtUp/SkPYnmZwcWiSsrGv34FwCoPhNTCiH/00814PoxW/qqLZpwofECue+bY/4abg51Z1+gzHtcfdEaAttQeErPreR1AxqfhZ9FX/DJiT7XMiYbxDuJmvpUtyHWHzdHQ3lBr1ERqMmDC+m7B+/RlnvG+auVHdoImtWTEM9W38bfUIZmzgs5qlACB6gY+UMsKM5kzxkywyg0gvPVsmdpbHeFxQhl9XiWPtg+KAESiqsOx/Vq4HklTBax5wlwG9aYG9sp/NZW8Z8AM3x3wfN2VV+3yB4vPsR6jPabYlGy+1CCwiAwah11xh2HmPdtqi2fMSu2ahkG2VpM6y6JZchG0jNPJeN
 kAawq7Pj
 v1AdwXZIswfNwGboIxL/5r4/05vgwlcEX+Pr7p2Z6COZ4w4uFHw/hxPl03WjyQ27qXz3tXK9Y0FXbOdLJOtNi3LXqSjAl65qwjEIeeoG5PIHH9TbUL7/PUES2HIo8X2KM7cwR4RU7COICMXm0e/cqS9awp0vVGn2801iiBJ0qU3eVH56vygYw9iW41sUFZlQnCzx0z95G+glY3rt37DYk//Q6UVEleYVrRohUXZao3HfeQpd7Dw0KEziq9RLXuesHgioeg2pupmU/CZOGU73eKEWd8qrRKKWiawm4
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
config: parisc-randconfig-001-20260120 (https://download.01.org/0day-ci/archive/20260120/202601201209.cGuf98oB-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201209.cGuf98oB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601201209.cGuf98oB-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/xfs/xfs_file.c: In function 'xfs_file_mmap_prepare':
>> fs/xfs/xfs_file.c:1977:36: error: incompatible type for argument 1 of 'daxdev_mapping_supported'
     if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file),
                                   ~~~~^~~~~~~~~~~
   In file included from fs/xfs/xfs_buf.h:14,
                    from fs/xfs/xfs_linux.h:81,
                    from fs/xfs/xfs.h:26,
                    from fs/xfs/xfs_file.c:6:
   include/linux/dax.h:114:56: note: expected 'vm_flags_t' {aka 'long unsigned int'} but argument is of type 'vma_flags_t' {aka 'struct <anonymous>'}
    static inline bool daxdev_mapping_supported(vm_flags_t vm_flags,
                                                ~~~~~~~~~~~^~~~~~~~


vim +/daxdev_mapping_supported +1977 fs/xfs/xfs_file.c

  1964	
  1965	STATIC int
  1966	xfs_file_mmap_prepare(
  1967		struct vm_area_desc	*desc)
  1968	{
  1969		struct file		*file = desc->file;
  1970		struct inode		*inode = file_inode(file);
  1971		struct xfs_buftarg	*target = xfs_inode_buftarg(XFS_I(inode));
  1972	
  1973		/*
  1974		 * We don't support synchronous mappings for non-DAX files and
  1975		 * for DAX files if underneath dax_device is not synchronous.
  1976		 */
> 1977		if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file),
  1978					      target->bt_daxdev))
  1979			return -EOPNOTSUPP;
  1980	
  1981		file_accessed(file);
  1982		desc->vm_ops = &xfs_file_vm_ops;
  1983		if (IS_DAX(inode))
  1984			vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
  1985		return 0;
  1986	}
  1987	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

