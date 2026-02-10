Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7D1EB26F7
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 17:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D2D6B0088; Tue, 10 Feb 2026 12:52:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44AF66B0089; Tue, 10 Feb 2026 12:52:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357036B008A; Tue, 10 Feb 2026 12:52:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 22A5A6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:52:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAB9A1C6BF
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:51:59 +0000 (UTC)
X-FDA: 84429290358.19.B55B4E3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED15E18000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:51:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="NPrxkq/0";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770745917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDndTfSE1y0YRnf9QO165+LJbyLCNrEArpKdSTaQwrM=;
	b=Q/zg/nSZlCqBtk99CFQ8aorfXt+8QDUQ3BpQttw79pP9E564JBK2SAjDlfsEFTr2+/u4UM
	FheftYX/CkBaib+6SJzMrTdmaBEJearGIafq/znWzGfaPKQzoOdb/dQBaEeVUERUSMIiHj
	QL4w0X44Tj90mSRK1U2w7ZBI8mysjX4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="NPrxkq/0";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770745917; a=rsa-sha256;
	cv=none;
	b=2/0+GGl9a68tSNvU0f+IAdKMXd7iU766cPh7apqB8NES31RZ7cpu3PfnC3N2yI1EwPRLat
	wAFMOlk/pLXxsuD6RyfMOGYH4MEb+wSA6cOES+yq599xS6ACk5vzr/BSrbAbs/cTC8Ethe
	i8yOTDlkzmbNqmyw5I7dNGtJ2/dlPSE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770745917; x=1802281917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qA06aqPLShHsei2q4s7sufdt3dRHU5s7RVveGATdUlY=;
  b=NPrxkq/08MCYOOEa4M1JkgfbzC5uMQqHs8ZdWQkdzJahvwi6eBet4REB
   okSYS1frH90uyNAZFrLMdzL4dWbz+4oJBa3O8UvcCErcbqTCqzuaiZzJB
   CFOZphPDfz+b/gJmtmGWg3FsE42InpsOfXkUskm7pdIETIBRsB9sLf3bb
   FwR2jShHS3ohZ3QgyZs4cic8XTf+L4nz50SToqXY7zkRzXRgs76JS14wm
   KcQ0EUhwMzZN3VZArsDIMJvB0FrDmO9ZDm/RRjm1bId8wW/BRLVC6zpRG
   sZHIWbgimZ7nOgW+o8mp19z53mAZn2qQCEdGOTeYTdfDviBYln9UGNZhi
   Q==;
X-CSE-ConnectionGUID: l/G9IYpESqKA78zBgQyEeA==
X-CSE-MsgGUID: 6Z8BoSfoSWGZ2PU/Bg3vyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="89473480"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="89473480"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 09:51:55 -0800
X-CSE-ConnectionGUID: 5euT5pk4QyyxthZ+F314CA==
X-CSE-MsgGUID: DBvC165RT2emIBVDWIIp4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216495371"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 10 Feb 2026 09:51:51 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vprtt-00000000pH0-0MlI;
	Tue, 10 Feb 2026 17:51:49 +0000
Date: Wed, 11 Feb 2026 01:51:22 +0800
From: kernel test robot <lkp@intel.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, ackerleytng@google.com, seanjc@google.com,
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
Message-ID: <202602110124.Y72YFz1K-lkp@intel.com>
References: <20260209033558.22943-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209033558.22943-1-kartikey406@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED15E18000C
X-Stat-Signature: qzwfje1uhk1pdc5k39qn6eq8wrpai6k7
X-Rspam-User: 
X-HE-Tag: 1770745916-491798
X-HE-Meta: U2FsdGVkX19AzLBMTAF0Bz4hvgxDWJCoMx2LIZmp6xZA5DF3AZyWoLf6EezWvcpbFSaFm3VK5Bn1lZlkrTdXa4HmGMhwcmDB2GbJeKtrFS8B2DMBwPU6oWglAaB8Gj/wdO6IOYBPWYZ3SuCFOGZJQSSFgVtDjpywOM8r5x5JS/A2dJoDxMZywyTI9xTAsdSX0eDDQc6HMORq58KplThFhsnn4qoUzsx+Y/sOwqLMB00EAwOrW7UZYhlvhtEp6U8+pNrjSZgvODGewUbzbLop0Tf046PyzeCZDtlo/fU2BMp7do8coZtBbKrxR07SJxBUCvtc14+TZQsKXPXbSXRg3A3Dqz4ebtvpR8CXobVjl8sOUDNi5SAGyvCAMZw6YVaDbcL0lG5qhSnsIO1lU+xi1E+xV/DqE9WhNa8y6rE4/v7k58RQXhK2M6uAqFaO8k4EbvCiKOPRLywIcNMKoXcaYN618PwlaRG3yZBnhVq0AA5nhDRhPIvMU5aYVW5nGlFiKxLitGyRiTa03ww7jeXwbxa2WXjIYW5gL2iIZ5FYSSxpmWETn0gtsFzy5gDyXv9n+i12llJ09hyO7Kf4elgXDxn5+9yJJpnqoIb9iNzdxLcFDrlMrKWT2psvy18mm5rQxoqOjgdhFJzRlYAQAwqnshfihjMZPS/AgbTSx/dOtmOSc5+zQCcjNC3Oxicq1K/7lwY6ioZch40gvKDpPwp6Za7lS4+98TP8tYszg0rtOPFqFw4WYhzHdcHIGundUUOYddn79CuMbPyeum+SgvbIUBt6nBrEuxAHpg3auN8fGzBtsEbxnMvmzrQcZPj3dkG6yuO6P0BVeWNyW+v4yC3ljRYWq/4NlPWd8JFapNq88E6l7NnySKoWNkt5BIMKPX90C0K3aWZ68Go8O9xZQM+1pXYAvFRKm4inctwxsQC2pCmXmdUh3EbDCLaZ17t7f7FDK3dbdTyaBkptm1iLH5F
 /+fQa34z
 5/ZwQ6PD8ZBCwVuNO1gurp19wxfUWHwkoOtT0rB4bsLb6TLgaNHEygvZZ6ElKV85hnUM0TUcw86ZUYmmj0l8jUK2MBkQernZ6QayWYFKy6zOpGVSJLClvT4tIEYV1Nt2idTUWPi77KlhM2Q1/gE4PmHx0aNjPpiqszqCl5XTCU2iDmGlttOZk84lDVyP1R9M/UKlgdHu2md94EsxEo21rlDoWGT0/Oqu4o0+1d0wBmAJ4vP+PFSEd8dRDipDIJWMerJU+ECvV0druVvvHZtY5ATnJ2WZ42/OZj/5fvUeB8LrCKkYdGUr4/jyO7WKijgFBOp6lknLlmyWAYOObsP4srfX5MQhHQ1K6lr1ZURFClXQAOsaIP/1CMrgbDDTMT7O4Y8x34PtGJLTsN1eW4Hq2xq96XYBiMKr/79dEfKGaS+w5vBhoSzfA/UeUKLLcbaK8SDoNxoHk4neq1FJQlc30a+vohnd7lroXic+HDmmSyfBl5QY7gNq/rdwwcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Deepanshu,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Deepanshu-Kartikey/mm-thp-Deny-THP-for-guest_memfd-and-secretmem-in-file_thp_enabled/20260209-113800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260209033558.22943-1-kartikey406%40gmail.com
patch subject: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20260211/202602110124.Y72YFz1K-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260211/202602110124.Y72YFz1K-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602110124.Y72YFz1K-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/huge_memory.c:96:30: error: use of undeclared identifier 'GUEST_MEMFD_MAGIC'
      96 |         if (inode->i_sb->s_magic == GUEST_MEMFD_MAGIC ||
         |                                     ^
>> mm/huge_memory.c:97:30: error: use of undeclared identifier 'SECRETMEM_MAGIC'
      97 |             inode->i_sb->s_magic == SECRETMEM_MAGIC)
         |                                     ^
   2 errors generated.


vim +/GUEST_MEMFD_MAGIC +96 mm/huge_memory.c

    84	
    85	static inline bool file_thp_enabled(struct vm_area_struct *vma)
    86	{
    87		struct inode *inode;
    88	
    89		if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
    90			return false;
    91	
    92		if (!vma->vm_file)
    93			return false;
    94	
    95		inode = file_inode(vma->vm_file);
  > 96		if (inode->i_sb->s_magic == GUEST_MEMFD_MAGIC ||
  > 97		    inode->i_sb->s_magic == SECRETMEM_MAGIC)
    98			return false;
    99	
   100		return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
   101	}
   102	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

