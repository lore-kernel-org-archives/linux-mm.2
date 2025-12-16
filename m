Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27892D5E138
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C02C6B0005; Tue, 16 Dec 2025 06:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E1C6B0089; Tue, 16 Dec 2025 06:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542D36B008A; Tue, 16 Dec 2025 06:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA376B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:39:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 938A96037E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:39:25 +0000 (UTC)
X-FDA: 84225138690.24.73FACD2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf24.hostedemail.com (Postfix) with ESMTP id C960E18000D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:39:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f1NSEKzH;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fnzxf+U2RImUVNFyD7L8Rs6O7/ruk+bBOmo6CN9lyO4=;
	b=NqSSRxeqI/wpX+KCQB4PYEnhFdLMFusnR/lAvN+qzX3WFc6xCqrsfm+95rFgQ+30CieR1j
	guMHGk5RPLNYYiO7p6M3TaeP7mokWvRZt9+6lYs0fTUK2Dd/JgdtO3LoIPgvUKw/ANa2eM
	uMMYbVbiTfI9KqQ6U9X5/6kbymuZz1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885163; a=rsa-sha256;
	cv=none;
	b=Rjhxt3pmc7rUcUquhlrcGZ+s3/hxtdjCjaqo+xJLVXKSstihWueA0n0FyBR2i213+37irI
	2m+9fkm2oKR2PvL5woE+20E9L8bY3GA19yO4f0k0Tct6j7kXvhyekxXGDZXFd4O7m/TKc5
	eHc86SKB+hWV06e3mSQFqcIBmBAVHrw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f1NSEKzH;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765885163; x=1797421163;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G0MliCZ3qoCXzuKR2ADRnq6tPcKVuJjZUHxc2xReJxY=;
  b=f1NSEKzHuQ8Zm2L7IiY6o0McZezXoaTbXi8f3FZ/kE/V2DRqqMeF5evD
   CF4VF2b/bT7Fb3z/UWvj/mj/J2QjbzPd+9U5z0CCa3Bp4Tr8eXaOm5xko
   y6w4OkM9o8QOpcbQjRE6kvz4fIUfAaG3C+psqZIoS2TGSoshl3twg82AB
   r5VPi+ylRv4/Oq402pCbt2k8ffsrJ/QP7fCNlFsiFnuK6NB5nGlU1/C1b
   l07ge805c9Nu2/gCyK0IsBVe6K3jC2H5zA0lSyf3kZ8VeSslzZ1uddhvO
   zgd6oN7mi07NfnbtZMDJHKNLx956bUhczZxNdIVV4xI7ikB7dfnrRuD5G
   Q==;
X-CSE-ConnectionGUID: tsgUHYB4QuqSi/MFzqnZ7Q==
X-CSE-MsgGUID: 1ZKScCVWRc6xe3mWMLMFPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="70376668"
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="70376668"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 03:39:21 -0800
X-CSE-ConnectionGUID: TGYDgSbyRnixB09Tyh1qkQ==
X-CSE-MsgGUID: CDjWge8UQQ+HSo5Hxk15Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="197977625"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 16 Dec 2025 03:39:16 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVTOb-0000000035U-2iLD;
	Tue, 16 Dec 2025 11:39:13 +0000
Date: Tue, 16 Dec 2025 12:38:35 +0100
From: kernel test robot <lkp@intel.com>
To: Zhang Qilong <zhangqilong3@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com, corbet@lwn.net
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, ziy@nvidia.com,
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
Message-ID: <202512161231.CTAFQzip-lkp@intel.com>
References: <20251215123407.380813-3-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215123407.380813-3-zhangqilong3@huawei.com>
X-Stat-Signature: 7szdtbym4bs3ud1x6g6ac5qh54ygpqc8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C960E18000D
X-Rspam-User: 
X-HE-Tag: 1765885162-374313
X-HE-Meta: U2FsdGVkX1+coibXNdbWDSdkebNeHhLeBMMaJfqshroVSj45djy9LiK89SiuDDwcgzOuYEFKfoEv5Wm+tuwuqNZ1onIO90WJHIn81mtPbBmwxRCTcAkDqa5WxfL+wr/O5h6gQAoS4FjrfWOLOUWShlwVhpC3d6t1JO4jlcsfyd4dgYTWxqgkqJLfznUYbM1KArW6PV8243vFTGLJvMSvshFkgx+aE28vBMgAdmXUHUG9YHKpqq0iGGl/CFwSXg2PCNAdQahAwiPYQb01Fic80ZLB1CyGC8GOjUie702MIoX/z7P97OfHeQ4Ixctl6t3IAa7ldAjR8t51YMsWvhfE+UqJ6NBFlrGw43GWAvbFqQRdvZGSNfXWFHpoQ429J9n/tix9/EUsLPD0rSI5zHtpwBKfZ0rJp21K+gh7I+DoNdzuf7DPsoDLNquNQihZemmobluBJ7XF/m5Qm31Yd4f86CdkDoKuYL5ooC70otjeaUTS51/bwfSuxst5oC6E3YP4nPOBAtwtb99sjr5q+QHzezTlByJ2rTHTrQvM+AAMmlwFCfjgyijUd0vaAONqK+fOgncG1y5DUnyjA9iIV1I9+p13OYATGv0nrDI3gcAmmjU5s+dClatqKqx8LpGLa3X9A1o8dN5aR4mUQw2lZ3uJr3WKWmOvyGC7pzOQGcBGsdcDy8mfmNF+bOYLftOWsJ3k5itUSW2/A9BMGyOH7nU0QxLtf/VaG3PvLoX2hnK0FW8t/phe68gtQaYz8OfUp1p2Q2hoZO0zaCGaEi44AH+EzkYGXAuOyTzIR++qpAlt2RQl76bq1o1mppsp0cv3DguFMYw4jGq40whXKWKVEzgTgyRCTx1ShW4u0/iPwQ6qitIsn3EjeCaC6YipQBa+xCAZTz2C3WS5kxapwC/gU1UtDjCnTJuy3B22TWYEdtknQ2piik8581YMa89UFyH4PfK5mQt70dJ1IxgqSEfiXNZ
 +PNOG2LF
 Ufa/ONzCXgCMr1OogmKqsXWMGxP+EsBa2EMhySAsi8AYliIG6/T3bioG0mLoC3yDb/BfHKvWh3LLyHm7oOV6uBOF0RIt2K7La3e5RI5GFxVHzO745bW3WWCaaUDGMw07ltq200S3dNSnB7PEZUl7wEYGNcLxSHvN3V7v6ba1K5H/3OT2VKlj1olvqHiC2bHJIogcTrOP7HwTUi7zRMpLflkICw+wX/4ecD6Mrfs4Cxh8Ibim+++PXFYxGuEpVBd6NlswbX/NbY2x4NJi86CuPf+bMQAHrnzJRc4XUFXThDYMJ0Q66oyXhsnAAgULyhB6D5kJeADdGHZa7aTcLriIoTRHqT1Ud2R/sbaxlE38dQ7oiuaTZFwNSqhiRdcq/d1BwLbMAPC7e+erzNlai3QJ1VJQ96g==
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251216/202512161231.CTAFQzip-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512161231.CTAFQzip-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512161231.CTAFQzip-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memory.c:6131:6: error: call to undeclared function 'transparent_hugepage_use_exec_cow'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    6131 |         if (transparent_hugepage_use_exec_cow() &&
         |             ^
   mm/memory.c:6135:7: error: call to undeclared function 'vma_is_special_huge'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    6135 |                 if (vma_is_special_huge(vma) || vma_is_shmem(vma))
         |                     ^
   2 errors generated.


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

