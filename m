Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78470D5E146
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 12:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2DA26B0005; Tue, 16 Dec 2025 07:14:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD13E6B0089; Tue, 16 Dec 2025 07:14:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC7E6B008A; Tue, 16 Dec 2025 07:14:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99E756B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:14:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F2A7598F7
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:14:25 +0000 (UTC)
X-FDA: 84225226890.21.3F730AB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id 880A0180002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:14:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SaFlm+ak;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765887263; a=rsa-sha256;
	cv=none;
	b=ytMxQwcHWDLpI8U9AIdjgLE7PxOQSBFvLCos9MzvIsAbBM4KAyYkDevwNdQRlINkFFMV4I
	03Co/v09xKQUTAChNvoJa9NSSVX5tMVYTYUFgzDuTHiRBRbdvH4yrLkIn9fqmeHLwZ5MRZ
	YaAzm4gQZx2GP/+VrmihALFVmfIwf7k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SaFlm+ak;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765887263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnLIRVD9L+HrE21aad4KUPKBx378hHk7IyyhIJo1GpY=;
	b=kdzu34uM19hOaioECQJvXP+QcudrlWZ19tw9/bSwyoZXnA67xOLTjkBlMguKrm7PE+aISK
	aNbuGSGcEZ21K8m6RiLBp9Qj78PBFQwNAA9B7W+Use+DzG3UG94gldf3AOXbaNJHIsLlzF
	limj7ZA0ohiC2mf+ncO3KfHkxhQj3So=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765887262; x=1797423262;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TCkb3cMMnCilkXdfgXX/dYrrMGKTqbu3QhFRbmOVoRA=;
  b=SaFlm+akJlBdo5lHvSqtfbSnW+csAGdHm62YhBmNGJvEg1sCONuji87f
   hjp+skwZ4Og321fmqpepr345X0UELNsBhsLH0GS4/ARXYcY0a+g5MhvAB
   MLdZeJjP5XrROfE0Wv2bCXY0t19DGYx6Nu46qfu0ut2dSdBi2NGlPuu7m
   bRhkADGkiwqXjme9lunIqM1XtK92MyGQWPqo6OOIATTiOc6v/BOMixbk4
   REyxS9QxIjnCGs3Uzm5KZ3B3EdaPGyEEeAmgUjwDXRm1iO0e9LwHCvjpU
   j5jU6tBvWKLDdBAbulnd1AY95nMiAek+qgfsV78il5zVLvbSxiwheTET0
   A==;
X-CSE-ConnectionGUID: j+y+1YQPQYq/BGRrXoHd4A==
X-CSE-MsgGUID: sop7/7KwTf2Vs0BOfroiMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="67682249"
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="67682249"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 04:14:21 -0800
X-CSE-ConnectionGUID: 9NsoZwmqQWKxdFmw4UI3kg==
X-CSE-MsgGUID: 5ajR5gmGTO6sJjivMsbeHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="198060024"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 16 Dec 2025 04:14:16 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVTwT-0000000035o-3e26;
	Tue, 16 Dec 2025 12:14:13 +0000
Date: Tue, 16 Dec 2025 13:13:41 +0100
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
Message-ID: <202512161328.lAGmHVt0-lkp@intel.com>
References: <20251215123407.380813-3-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215123407.380813-3-zhangqilong3@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 880A0180002
X-Stat-Signature: 67qhzpnn8ftcek5tiibujwzgzy518k49
X-HE-Tag: 1765887262-633453
X-HE-Meta: U2FsdGVkX1+n8ZRJYvh2BeN0Q9QVa842QD7851nx0KQZLb/td7mq4F/1K9rl6v1CmYbn0GX725LwHARA8s2iJrhcSH5/1VRq5Wzb96lS3r/POgvKKTC4KkCNti3Yfm7501PBPDYSupcEBm49fBX784BuyRQf54OqYntL11AM1np2gb/nwqGeEzf6PHrIMBf7zIPLL9/pEMbdfjN89GFXKALa+2MVDt6bbsl04TEaxPWrJAi2qe9XgqRpr5wcN5Ssm2xYHiQDm7r4Jw/oAAxNFUN831YKcod8wg+bTjKKtC2tKshKasxBIIKZb9E94uHGxEN2x/grZsoGmHCXql6ZvnBhxvYHmMMCi158DIepnXgEVYOwqi4fOMjlY95U0UkfjnA68PzyN0p7coAtwpUJ4u505yCvD1NbiMzkWEqrbd59e3P1eTG5ZrLgOGqKOgeU5ggMX6qL2/K6gZJIwwt49urEirmh+Nt6UqYO2K/k712TaPppa0Toq0Isb43TmeNljrKI8BGcqzztQ29gTXXFG0r6DA8DImllgAfIyP5F37RU9M4go/t1AJe1vQ0cKyfr1oms19IIJyDzTXY8B/rmfGXwbWiz1YYVTIYlOJpbAiPBpXc6K3tcAoq8FOIOQUVNIzDOVg8+4+CEQTdrbBCXWhRGuRVKSTm7tJ8DU5vihrrnhZt8IZKxh7uvV6zSJPBVbyCXXFgrnEXlIYp9KCAFEH5h3skj2ZIDum3IjwbhDJUMIy1ge5ZLNMKJ12nted8seRHgzELGZ7HgIzaQuhx7hp9EQ3NQ/YmD6OynsppjuTwOHg4+gm0rrbwFo+iM87y6v4cTa5kbZLc/+uR8vlX4HXCa/Mc5mpuqJuQ+lXLhtqNGjbPZ8g7UhE/GnvFgK0gkvyy48uv2AgJdGZBjTo5fLgPbgEVy73jGuPbmFrK0nB6i4t1luIE/4PYn3y5f0mhNSP7f5JwIgh0wS5xCkxn
 NeQmhYE6
 5djllrJOa4RMzuCbu0bqaLPpSPtvWqcuQsEMHfRzDh40+RSj3w4RE4cKmMDgRwSih+Y1BQnKbteTT3a7gjA8rQwnDilbUjcWdQMENiY3C1N+XNloC52EJpXOEcUSu7Sapay+7evmDCST4HjsBZg+YjZyEKejTBdxHJKWhIgO3mAIDP+fbDhfNnycutEsVdUcjNsCSK3j9wuae/yynt335YDMcKitwlFYN+OmQqmOjYbykFKilAsemZap4whSyP4TFQ27lahUpoYQ/m6zp1xkDpGdlYnHEljf6g6YVz2XL2/m9NvgzkJUqLH7/5FSQ5QhC754PGy5Zv2de0VoOvwuS2belvADSbCnmjigWk/hESXqw8owQaDEiG8UmQ2P1L/KLqo6d8STPrC88b6FJ3ebBnUWFo8Tz1mCegT8TgJ9gX7TPv/RTAheStDOExQ==
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
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251216/202512161328.lAGmHVt0-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512161328.lAGmHVt0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512161328.lAGmHVt0-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory.c: In function 'wp_huge_pmd':
>> mm/memory.c:6131:13: error: implicit declaration of function 'transparent_hugepage_use_exec_cow' [-Wimplicit-function-declaration]
    6131 |         if (transparent_hugepage_use_exec_cow() &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


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

