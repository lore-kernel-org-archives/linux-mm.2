Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E23D5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 05:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B7A6B0005; Tue, 16 Dec 2025 00:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A8E6B0089; Tue, 16 Dec 2025 00:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327E56B008A; Tue, 16 Dec 2025 00:04:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E92E6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:04:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF99F135D73
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:04:01 +0000 (UTC)
X-FDA: 84224142282.06.323A90D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id 05B1480005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:03:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TXL98qgd;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765861439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzeae7Kjzma4REASGXbOcfQFDQqa+drwL9D0bfozAxs=;
	b=03Q0XKYMqqLcrBEJHjL6pfbuQVI9M8pcfphvkbFQMzjcB3lGxCPVplDcVIfH6nDsyd1OVs
	JskBNZSrpajMLYM53ltwUQcQ70bX8w2fiT85QLXRFt7OuTCnty7gZvjF7nPhq3+nu5n3JN
	yZOGRssdqrOt4ppz1uWnRVRoO/JGcGA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TXL98qgd;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765861439; a=rsa-sha256;
	cv=none;
	b=3K9a5jPuWIupArYJ7y6LiREpVoyTyj9+p4z1C9iwR+rPr1tCl0Xzq9aDkOwzzj6hq36CaX
	bIOdTMDjlYFHUw7987Gvex0UoEfiqVqlWnS7mVjOuslkidP+41iizID7t9YJTvg5pRgyM6
	MYMfn0mgLoOEUipq0P9iuaKoRlF8dC8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765861439; x=1797397439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cdgOM1zNzJWYAFxEAh5KUXxqD0R1ZNnspaoOHRBoaJM=;
  b=TXL98qgd3+CDrLxV9RpBLfNJEQrmAcW/ZMp2M5XknvPE/txgm9cbIWkT
   gfGDBkVr2q0GVGBp3QACBcZAFgyyyf+kcTEN/fKC+dLmJKQEPUSANPkGs
   xwA/gNug/6Ler2VJLSyLpuLPN/4FtA/7H0Cb+EGE7/yPsk98kMMeEGyoB
   gU3+aL7PcgHmuJTXVba1+EKHE1jdWBSKh4XT+5U/DI12QJ+e+7X0f/xu2
   bD6O5A7v4B5assJoxi1jbi2HhHiDwfN3Sy6D8Ld8KbxQhPk/GsgtIIEa4
   rYVNtb1rvKqsOnQ/g/m7j29QUTjwppnNeSRwts5RbYdCDm2kNUb2txJiL
   Q==;
X-CSE-ConnectionGUID: QQ2w9lBTQcKqTf9IVEHRtA==
X-CSE-MsgGUID: xGXavZDJRoachvColQhugQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="90428894"
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="90428894"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 21:03:57 -0800
X-CSE-ConnectionGUID: F+kshmvMTpiLqi7gT6xJGA==
X-CSE-MsgGUID: f6Xb8iMlTgCFrbdiRHph5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="198408906"
Received: from lkp-server02.sh.intel.com (HELO 034c7e8e53c3) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 15 Dec 2025 21:03:52 -0800
Received: from kbuild by 034c7e8e53c3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVNDx-000000001B3-1uyR;
	Tue, 16 Dec 2025 05:03:49 +0000
Date: Tue, 16 Dec 2025 13:03:26 +0800
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
Subject: Re: [PATCH next 1/2] mm/huge_memory: Implementation of THP COW for
 executable file mmap
Message-ID: <202512161240.Ej5BIvIk-lkp@intel.com>
References: <20251215123407.380813-2-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215123407.380813-2-zhangqilong3@huawei.com>
X-Stat-Signature: qceqys14j6scjq1ydscou3o7ymt89451
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 05B1480005
X-HE-Tag: 1765861438-873131
X-HE-Meta: U2FsdGVkX1/6XInNoiXanbM3Bt+RdYq6gvUHrpiLUEjoaHCcFIqX4Q/4kZvgziaVKZ+VevogVks3K3XUUUfkUyeEzkbcPl7FSra3ZWEXUGHV5AOQ0g+3tq/l5RsCxAAEWByb8PMr+k2IDf6YCLx4388tUUHo99ARE8EvTIRMCpH2vHKqMGINvc1qBNQBdWphD1d4S0bDDqpos0k8EA2Lx4X3y5TuzYk/BpY0HcHV9dre6HgMnixj/ZshvjE6q+JDuCtfpfAdcD6EftydO/22AxyiSL/wbXtDfhef81dxbsOTjfzRdjNOgP+I0/rC02IUWuhL6i2DMF7KipuPKzRfYlvyE6Vzkh37f+saV5VENRY4tCjTz5vuY7hrvKBlCSpzv7RV5sbkRDRFO2fFjovNPiHdmn6rsG4wwksvGM3i5zxSw4j5M7G35IunQq4LNDpcY1jfxMtwtvURJqhDcidCnN9iQJQtaEj5hVhd/wntgUiYEFO7rSDpd/rWF3wObcx4bESettRBL9eqIKs4AXxnJt2orxPVdj7/WpLamznDdAN/2ItB1xSG1oFJljuU/YzuSz7FdYPgBdtATV6TrEfIEEnhwGOniYYMm7KkSB5XcUBZdnzDzj7qWIrFWakIVspN2UJLEZZCeLdorN+Q4svxEk2xSgz/lUv2249AXrVZpiERY1zUapZb6unOJsxRsVWdcLv2N5dMF7N1GLPPxF0HJcGooqYEEbCR/q64RibFxh1+GbUttq5GyYsjlDeggTnvf6ZV9hVmLzIzEecGdWKMYdgTdyIqzAI9TbSeaRWZXyA3O96nOVB6A0XuSznvrccqLEjR9Qaz/wmIEX6PExOLDPYjscHYq87e364e0rgG4U/VTl8MHOaL4bMg2CSxxMWz9AjYfGFO+nR4vNb7jOFfOxWFV9rm+2GEaOJK6R+KlfTSwcdx08lkIr/JIwBWF/aIM3gIp86mHMDMnkAbFDj
 YnZDGf+r
 gimC7UIM1IKEui/zDosEr6CAzrN+Z3srtQpwDB3m/z4i/sWGoVEJ2EJX9ydGhZ4fL8LW8jODevNo1aSSNdAQsh4P3jWHBzJqPz6FO0pu/2Kfw+3JSBhZazDcbvrTHj8cm4GNWbKYfssMlFhVahACYkxoLj7NfZela3tvVLFXvgHua28VX1ZdO6vyZdkVw7BkXM0LaPK1JWvZjR5dXZKQM5++elfK8wtsGW44pbVAcC3jFFiKbHkI2rb9WXVFGbErLcon+VsknM74id/cJrasYw+ZGpOCNINJi0Eq2gBxgxHTMr+vdTgLcY1HUz50e5Bu5avPoWKvJ5JK3o4xD784oqxjm1GJ5yDFr/50KPhEocLAEd8f2KDaLIN+mZcPVj+sAT+N0HYf/P+rG5co=
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
patch link:    https://lore.kernel.org/r/20251215123407.380813-2-zhangqilong3%40huawei.com
patch subject: [PATCH next 1/2] mm/huge_memory: Implementation of THP COW for executable file mmap
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20251216/202512161240.Ej5BIvIk-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512161240.Ej5BIvIk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512161240.Ej5BIvIk-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memory.c:6134:7: error: call to undeclared function 'vma_is_special_huge'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    6134 |                 if (vma_is_special_huge(vma) || vma_is_shmem(vma))
         |                     ^
   1 error generated.


vim +/vma_is_special_huge +6134 mm/memory.c

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
  6131		if (is_exec_mapping(vma->vm_flags) &&
  6132		    is_cow_mapping(vma->vm_flags)) {
  6133			/* Skip special and shmem */
> 6134			if (vma_is_special_huge(vma) || vma_is_shmem(vma))
  6135				goto split;
  6136	
  6137			ret = do_huge_pmd_exec_cow(vmf);
  6138			if (!(ret & VM_FAULT_FALLBACK))
  6139				return ret;
  6140		}
  6141	
  6142	split:
  6143		/* COW or write-notify handled on pte level: split pmd. */
  6144		__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
  6145	
  6146		return VM_FAULT_FALLBACK;
  6147	}
  6148	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

