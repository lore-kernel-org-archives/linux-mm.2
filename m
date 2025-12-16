Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF36D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836BB6B0005; Tue, 16 Dec 2025 01:08:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCD76B0089; Tue, 16 Dec 2025 01:08:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1C16B008A; Tue, 16 Dec 2025 01:08:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 568A36B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:08:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE2B7B7E4D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:08:12 +0000 (UTC)
X-FDA: 84224304024.11.1B6F55F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf14.hostedemail.com (Postfix) with ESMTP id 136B4100002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:08:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=csTDWruP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765865290; a=rsa-sha256;
	cv=none;
	b=oi0S71L8dP3xDE4v/xReE2005mIpnjH82JUFCjJKAMEGOQqpj6DrsshvJNBTtPrz8kqpnt
	/1H33ZXkdfW9aVtN6zvHgN0iinzm3p/v0IGkDcBeIWJlMV51nmikc66Z+PGVUV1qqg9WMV
	vAUDNbMbD3AY8jH2hrkMkyOOgRggMHE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=csTDWruP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765865290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URthXSnDE2E5x3fbn+E0DvXrOkoUvq4jnJ0oHsZ4Kog=;
	b=iuy3jOI8s8T9sl16KnPInyQxK8lQ2mcyNL45yNGP/KCjEByKZN5xmyifvEpMt5Rcx/4udz
	6qSohwuf/dYoAXUR3XaTHct9GoeTAG6nRVqsuE6ldyBShZTCVvLRVPVP+bkdSZXYwf/nw4
	tPl/dzMrHFOiiFZbhZbAorz/B+/2c98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765865290; x=1797401290;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4tcxfzmAbYpqTaHXuZRdVJ6IwC8c2vzyeVYlJ3uxgzw=;
  b=csTDWruPjYIO9wzjJ4OC1MfAjdRkC69KYtErVGJElZldMdys78C3pUwD
   +8Qx850xBAv1QiDiqo3qqLzqTy6bZZenPtnLzh2UjmcvQefUU7hBqkxzj
   vVmmkvStto2YibqOPbJ3myrRn7qdvAVSIyszwieNU+b6vFU2Cx1T/Owic
   0mqJ+qGQzZEClSn4rVIGIaoT3TI0gqHJN3ZRtDYSbB4kPTUCUUevcIpwT
   UV+VOlPA5pTrLdyQysSoXYiLdo4kHQn5EkSFKS9IaN5C9RYRiFpfK1Uk7
   80M5cYRyVldzJN5ZL1ZolJ9YX49DoR/UfwAPlskoLvQ1NApZIi1l3PIwD
   Q==;
X-CSE-ConnectionGUID: Z+/C0Z0XSjmPB4J4Nqx4nQ==
X-CSE-MsgGUID: YQ76JLhFTpKYTdiqahXvmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="66764339"
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="66764339"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 22:08:08 -0800
X-CSE-ConnectionGUID: 6Gl28I9cRJOmfcFdcuwliA==
X-CSE-MsgGUID: AAVO/iLuTQC2XbyUdxIlEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="235330101"
Received: from lkp-server02.sh.intel.com (HELO 034c7e8e53c3) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 15 Dec 2025 22:08:03 -0800
Received: from kbuild by 034c7e8e53c3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVOE4-000000001E5-2nNw;
	Tue, 16 Dec 2025 06:08:00 +0000
Date: Tue, 16 Dec 2025 14:07:41 +0800
From: kernel test robot <lkp@intel.com>
To: Zhang Qilong <zhangqilong3@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com, corbet@lwn.net
Cc: oe-kbuild-all@lists.linux.dev, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhang Qilong <zhangqilong3@huawei.com>
Subject: Re: [PATCH next 2/2] mm/huge_memory: Add sysfs knob for executable
 THP COW
Message-ID: <202512161352.7XX7Lgv9-lkp@intel.com>
References: <20251215123407.380813-3-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215123407.380813-3-zhangqilong3@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 136B4100002
X-Stat-Signature: n9k94r1brekknzk4faud8z7x3fjsz444
X-HE-Tag: 1765865289-539941
X-HE-Meta: U2FsdGVkX18FQcWg6js+DFI75RDtkx7uPfqCgaIN28dPc5Rk83OtXxfgEYkbN/tFlTxFS0pWLrv8URuXPi94xFRw6bsBQheNT9n7BIwRfUnkvYMU29NxjZ3d3fxTKjUvb+xTx6fFWV1AlHwMiHgeHkiq3W5Y4TrJUhi38RGV1VmnOVxviMugzyhbT1uwoMM7VUwOU0EFE9H7m+CZokNG/yx9smLEA+iYwvKi07d00h6kMTuAV3UxhDWbQJxArblkDsCIJGYUdr2NdKc2X5h6vhoM/5UvyrMlyoWFHh9rDzWUs2Eq8MW2kNDe0xOIUTRw+98RYWHL6pGhPbpHl/2Uh0Uak5Ry6WfySHOmBay+fLX6SrvYCrsQQ90hO93OlRA7heoIdxHdgTo38xJKVGeztpon+o0Uyq7S/xct2jdDOkaohzz3sZ11NTv3PAW7uLtJbWYAI+wDPzep7uM4+B8X4hHubcv6jgrQs9/KU2Y9LDGrnxBPwFyFK3WbqC3w/HSg6kBkPIOiaQAgC/OUpCcsPy8FWOjnPnQpokztRENGxwxyPASk+nahaJkcpPdhwDiBPAvB/NbR1oUqArzsxdzoOS7ylJs07cLf23RS+t0OLycizD8yc4lj9EGmrfK/o+aRUsz6I53hazN1qkEKKWIVBTxXQc834zc3gkvLwnFZbqUuPbCmOjkp+zNfODJ6BxUyemaHMOqtbo/8CLiDhxbntU2A/q+koOT+lIWlws5h1kfvGMXCp5mTydKonhyfEU78MauS+pyQcBGmilhUaueFClWL1IuqbjDB4LDdSH356SdUttWr3yFKJw4vGhw3XxLE4PuDj1WqtYaF0TNLSojG4Mabj9suUmhbSIEyKpRuFNZ+JMxRCb5kSetnA+4WPWcpLcdITdIpgZwjXw533HpJiHAKLaQNaktIOCoWFFJiEJcLYTVTyAf5lXiCVecxxKZvWlS0LbfKufF56Qv5jdk
 hDilfuD5
 Uq8odT+ri3Otz70r7lAYhnAdotu2QtFHC8CmFAQjPs3ElXfJoDUlAeT+OxkOZp3LnmmwKgNtDuXrREJAr9SHqlFPHr/VvhtkUjBmVdEYlsiHBgfvcheExJ+pcowPgtBqBvOzjMW5Y7Uy9rqX8LuAXulkA3rOVwz4CIcU+GJ+hNRjeF4wZtVO83VxDt9m4iz7WT5ftbcB1FGsstQjtROH3g6jY4/MLy2emCHZBDVCMGGtXEUyAGaA6ukyTodlT6KsusVEJQ1SRRv5qbuSU9lZuSPNQhhKrmpT9QeRlUoyg4CwwPETpd8bGbi4ffU69XCoa343ZVqRw+dPIORLR3rhcT1mWTo9JKGKF41adsYko7QYG+Os=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zhang,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20251215]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhang-Qilong/mm-huge_memory-Implementation-of-THP-COW-for-executable-file-mmap/20251215-204035
base:   next-20251215
patch link:    https://lore.kernel.org/r/20251215123407.380813-3-zhangqilong3%40huawei.com
patch subject: [PATCH next 2/2] mm/huge_memory: Add sysfs knob for executable THP COW
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20251216/202512161352.7XX7Lgv9-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512161352.7XX7Lgv9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512161352.7XX7Lgv9-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory.c: In function 'wp_huge_pmd':
>> mm/memory.c:6131:13: error: implicit declaration of function 'transparent_hugepage_use_exec_cow' [-Werror=implicit-function-declaration]
    6131 |         if (transparent_hugepage_use_exec_cow() &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/memory.c:6135:21: error: implicit declaration of function 'vma_is_special_huge'; did you mean 'vma_is_special_mapping'? [-Werror=implicit-function-declaration]
    6135 |                 if (vma_is_special_huge(vma) || vma_is_shmem(vma))
         |                     ^~~~~~~~~~~~~~~~~~~
         |                     vma_is_special_mapping
   cc1: some warnings being treated as errors


vim +/transparent_hugepage_use_exec_cow +6131 mm/memory.c

  6104	
  6105	/* `inline' is required to avoid gcc 4.1.2 build error */
  6106	static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
  6107	{
  6108		struct vm_area_struct *vma = vmf->vma;
  6109		const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
  6110		vm_fault_t ret;
  6111	
  6112		if (vma_is_anonymous(vma)) {
  6113			if (likely(!unshare) &&
  6114			    userfaultfd_huge_pmd_wp(vma, vmf->orig_pmd)) {
  6115				if (userfaultfd_wp_async(vmf->vma))
  6116					goto split;
  6117				return handle_userfault(vmf, VM_UFFD_WP);
  6118			}
  6119			return do_huge_pmd_wp_page(vmf);
  6120		}
  6121	
  6122		if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
  6123			if (vma->vm_ops->huge_fault) {
  6124				ret = vma->vm_ops->huge_fault(vmf, PMD_ORDER);
  6125				if (!(ret & VM_FAULT_FALLBACK))
  6126					return ret;
  6127			}
  6128		}
  6129	
  6130	
> 6131		if (transparent_hugepage_use_exec_cow() &&
  6132		    is_exec_mapping(vma->vm_flags) &&
  6133		    is_cow_mapping(vma->vm_flags)) {
  6134			/* Skip special and shmem */
  6135			if (vma_is_special_huge(vma) || vma_is_shmem(vma))
  6136				goto split;
  6137	
  6138			ret = do_huge_pmd_exec_cow(vmf);
  6139			if (!(ret & VM_FAULT_FALLBACK))
  6140				return ret;
  6141		}
  6142	
  6143	split:
  6144		/* COW or write-notify handled on pte level: split pmd. */
  6145		__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
  6146	
  6147		return VM_FAULT_FALLBACK;
  6148	}
  6149	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

