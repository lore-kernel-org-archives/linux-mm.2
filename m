Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3356D5CCBF
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327206B0005; Tue, 16 Dec 2025 05:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FEED6B0089; Tue, 16 Dec 2025 05:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207BF6B008A; Tue, 16 Dec 2025 05:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF7B6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:32:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B90325945D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:32:24 +0000 (UTC)
X-FDA: 84224969808.07.9DB2E09
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id D430D8000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:32:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C4k1yitz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765881142; a=rsa-sha256;
	cv=none;
	b=bFG/9esbKjukdJ/rGmU6l3WibpBFmhQtvnCJmfzf/JBSB4DADNjp8hk4xjTHpWRFlpHm3v
	C+XaPjNhJWLCrBOL3+0PdB+CKJZw+XDegbiuTpa3m9Js3rIutbKvpSJbW0Mz9v9jqSNU8Q
	InIDrwMBD/15DltSvl2h82SvC6HV+gY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C4k1yitz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765881142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qm/sfVzXzN/r/15HASTSvF/O2VNYhND1TrYn0wTlNlE=;
	b=ItUIffq9/d0aigtPEYZHGFpIeO3d7wJnpyOchS8mHS6hbkHwEahbUczpKrSbCmCZnNPcD3
	BMfrauCNznCeJaaBTEHEyjBzkTqxiHwdRdUIVenkdJZjk+bMMYVgl7Lxx/s4iAjnHTnX58
	i1SZ2QG8cjZG4huNdnJbveFxf4MRmjI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765881142; x=1797417142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7cbeLTFNkUMvHfix7MAsqCFQvoR6yVcq8vckXttfXLQ=;
  b=C4k1yitzgZwUCTKyVT2JZSlYGOLN0yzHJpmDUq/SL1cb3iV8ggkjOgTZ
   EYQP+x7PVL/WwYlAKLRu0ljRfTNlgcBJYLGlYAtyllyvH6Q/RDUq/UEvo
   w/Dd6wv/AgvZ8f7DmzComqXtYc3tZSdnHihjOJbOrrEE2EcfuRMc67Q4F
   j1UehGTJCR5SsXCTZuoykEre3bKv5Pt0ld3AHYyL7ni6FB/2/FtWzi/qw
   6MDOmujdxD8RWgvjuN/GQer3eOeFNS7MNKF8SXlLMj2Ouihn48Qhctsem
   gofjiKNcTyVU1r+OEkT0ShSgZ9Zm2lLJdn3GDemIMCPwdhEfqXF06Q3v8
   w==;
X-CSE-ConnectionGUID: s0jVWr2GRPWCDTrbzcPTJA==
X-CSE-MsgGUID: lwapwRjIQFijIkzc3f8t+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="90451433"
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="90451433"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 02:32:20 -0800
X-CSE-ConnectionGUID: 4nMHR9xhQQSBSFJ0/6djxg==
X-CSE-MsgGUID: Lth0LVWfRDGgg+SjaaHPGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="198790360"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 16 Dec 2025 02:32:15 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVSLl-0000000034u-17TP;
	Tue, 16 Dec 2025 10:32:13 +0000
Date: Tue, 16 Dec 2025 11:31:56 +0100
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
Message-ID: <202512161154.iIbhbvhS-lkp@intel.com>
References: <20251215123407.380813-2-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215123407.380813-2-zhangqilong3@huawei.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D430D8000B
X-Stat-Signature: 4x8w9h8kj7qo5spxcxg6yqme4yfa4373
X-Rspam-User: 
X-HE-Tag: 1765881141-950943
X-HE-Meta: U2FsdGVkX18vpLt8J5S/gGsaAlcnNAPUxW57UKNKrCRdTykIf3mbXiqYDggIq3ybK1ymF6qKf3Xa4LDvR6S5ReYcm9rECEgyXPqs+AZIjvrOiSC+ETTnOr6SWx5It1EsCS1iYmXAOOcone9iIdQwJmeCfqHl9+2xpe7k7pEroY9YzuPVY9KgGy3cF69MCZiuWYw6fhbaTNiYNsnf84VeS+c8XCUyiPE7X2HF3+FyVjHOmQ6QSFj4RPEb1GBU6sEWdMx1DFDvX36dwrwBsWUrmF7+9KpnhNpt4FSBqt3+jwaQ/+58AZXDbpOxe2whF7daQvVNiZFl/sB6zKLOP5hups7DGddGNkSwBzzafShVMHRSV3oDqQrsdGJZLULdAJczxlgLw6ZPToAH50LLzN5wIfeYhHSNasdfWQfBVqGANN856cE7Iy90Uqgf/Ovtl9+dEQnds7131HRxLETXVsRS8XlR4fZV/yd0sQQdvCGZtxThQ3fCuxoxKw7n6ocgsLc4QS8gdJvgunl/cpVZz1r6mXm+009Y0nJyhuPnUInsz3O1wtOr5LccWgAgiPEC3UaGTEoBPIqHfz0w765CsxHS4vVqcL6FPR8uDFj6AMLK/fFzbhnVtaRT/X2BmKxLekjLUoaxmwEQJW9wo3UE6HHPG8tbYfUe+eLpRT099NFcRFhDUGPH0ysTouw4UKpKumNyGLOhlwiW5uHAoFPQJBoxpUNna72z8klUmjcTsbcj0KNtmvaPBbA+9obXLzbx1aJyZpW3Y9CkngjPqoGZOuo/NwG0gi7GHG8YiWELnjsyadFD55J4pjw3BwApN1bIPB1gXUzEWo9OGZbi6aPBhsttnV8oRxKHhBZikq499ypSChNSpvVrrAZbBxFBuZC/IQe54Vs18LEqoTSUvkwraqy1okJXz/niTNB+raIuPaXatr9xNPGB7lxVQOeD4JlmVcr1Q8Mi9vciAjDqRn0VkRG
 5xCctB0a
 xkH7AC99zRYHX+upHi3UJYee10smwoIjNGFEBRnaLW8g6B5qnZ9I5HJDNMnss+NijeTv4OcHCHC06XIbc3s0ER69gMUrt4qBPkQCD3zjwTQ1p9UwIQ0vgTYuttHxpwV5ZGPLDNUf9j1hKicvQxeK4U+eZqNpL7+FJEevLWIzh6ja3ol2MvJo+ffuhG9w+GQ9XAxb84EpBMWVMooZGyrHmg/gcvooG7kBZ6kf7/FHEuvbL8OVuVpP9OVp+H3M4RdR0gOG7ECC4hKrQilsjYE48uzi1KnJoU/mNfJwKbedZ4MYt/YblQujc8/1M+ZJSdi2yroySLueAfQliQDtqIWg/yUBJbXGJZ0lTs05yBHv/7q3KfOXKymY9PYARoVv6zCarxb+u9zdprjOcJQY=
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251216/202512161154.iIbhbvhS-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512161154.iIbhbvhS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512161154.iIbhbvhS-lkp@intel.com/

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

