Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9346D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 04:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027D86B0005; Mon, 15 Dec 2025 23:43:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F189C6B0089; Mon, 15 Dec 2025 23:43:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15DF6B008A; Mon, 15 Dec 2025 23:43:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBC936B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:43:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C3BD1A04CD
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 04:43:00 +0000 (UTC)
X-FDA: 84224089320.21.48AB0E9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf28.hostedemail.com (Postfix) with ESMTP id 09C58C000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 04:42:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IJ+Cc6Pb;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765860178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnhYQwMhgvMG9Ui7ISNjpQjXKuV9J98ED8IL05rJsco=;
	b=BoaENjMmXflM86pimlzY1EhpUdyPOKpm4sBBkISXPfMn7EsXLiTRRitd6//G8ZVVUpsexD
	iI9gGKyfqDRayk8TsRkRxTpR+8XpE+HGovhXC1ARVy/bSr5EEraQuYLtQZ9UC9h3Mhoqga
	LXE6sZyOa/EB+JsBYgLZlsTRntVpA54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765860178; a=rsa-sha256;
	cv=none;
	b=Nhgna4/NSl08MucCyaMG/0eBsYJRtAzZs/4gbOx20KU9VggnRzEl48hqIMMrKRpRNXgelb
	XyTQDjW72FRt8bIuJ+0+Ahudts6bRI3w4pLv1gPnYdi5WNSK4apU+evdOv0J4GS++pJbQS
	TwFKXfvvEoNEs2QtGkg87GMrewwogXQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IJ+Cc6Pb;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765860177; x=1797396177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fkq8HbuoAJDko5Bgr6cLebDBGD2rT8Jq8r/WQ28UcIQ=;
  b=IJ+Cc6Pbkaqd+3axSaZ/JPGvctc/7Yz+Qhtd6ZiqV0YLt2aG8bgIIohl
   qDTHqvl6lSNJaLwSFRb2/RZLD5L9HdFAOn2Ha67YhTF97wVFhzF9P/JUZ
   E0pOYib7WfiRXBN4uH9V4Yx5AOiSOHXzhhTuq27z4/aQ6+d21frGyM7UJ
   sfUiksRmiuVJnWEO1X8DgNbkc5A2NVhz2GdzihF/3KWTPb89UuSdF2WrB
   JNgaFd9A/cW56o4LUlIRuxSZUkLQLh/MGOaYVo340aoYqiHJlTITtCWgP
   6S5BpYtdE3GMd3LoPTHaRZH0yAininlOP0szZjsNsih+RH2hQAGC7oGDd
   Q==;
X-CSE-ConnectionGUID: MQWxxF16QYeJRRKK1bo7Yw==
X-CSE-MsgGUID: KIRvWscxTO6MtJosqewjVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="67844117"
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="67844117"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 20:42:55 -0800
X-CSE-ConnectionGUID: Lf88ju+rRASp+h3UWXr5vA==
X-CSE-MsgGUID: de11S+tETEqRidJqhi4H6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="228986796"
Received: from lkp-server02.sh.intel.com (HELO 034c7e8e53c3) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 15 Dec 2025 20:42:51 -0800
Received: from kbuild by 034c7e8e53c3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVMtc-000000001A9-2XhZ;
	Tue, 16 Dec 2025 04:42:48 +0000
Date: Tue, 16 Dec 2025 12:42:40 +0800
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
Subject: Re: [PATCH next 1/2] mm/huge_memory: Implementation of THP COW for
 executable file mmap
Message-ID: <202512161243.Dm4FDP0T-lkp@intel.com>
References: <20251215123407.380813-2-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215123407.380813-2-zhangqilong3@huawei.com>
X-Stat-Signature: 6m8bhhseb1p1cgj6mfudqxrjtmxdp5fx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 09C58C000A
X-Rspam-User: 
X-HE-Tag: 1765860176-416725
X-HE-Meta: U2FsdGVkX189SFPc9sP7Rx4UgMy5Hd0H2voidmPyh6zPyWVDT2I1Acuf3+jnzzJ1n87FMUpuzl6xfT014Xb+uP98GCiaKxrvoCg9T7RXDsZaE4kqGWuB4P3wv8r8q3VWle0WD7g5LpmxHeisA2OEHKwvAl44kG4qU2BEatJkoAimUF4lYET4hIOlPNQM1R4fRMWQQzLJbxx0wWM+MUdQ/xVR9vfbnTJVaBScX2YOgN2U/6S3l7u3UsbjBkNp9KA17VMhL+n4ksUUJd51wvKVuq/ZuA9x35G4rJ3ynoSqDukclbWlnNNk/GLBUVtQ4r4tiPpJKjBpcYZnJ6EIk/eDzSHINA07DrVheo7OmdE6UbDFv2gSXSJmTg/zwGJY7IUShtxveNG6QeJo4buQ0eIr81HY3o7pe0V/RlajEnV0STB/QpUM2RtxtAjKNcH4N93MtVS28mcz8lb6j7x8H2n1BSQLaxPKMheoK0WRIdv2C4xvzShOOeruXvvXIAvHqpDO5JjHdwTmd7ZdLfQJyocFSr8ccYPUFwZrmJ9uDEejfqIgldMH6yNfNVcLDMA552MUIk6dFkn/qkJ89I3kEyHh+j4eeAYgDazsSae3ZyfKwBna8japMOCqpD57iBNHS7TL3KlSrHZuxEADQE7DPZ1XEuYtze5krO7rdsqwWU6iYbiRUftTBRLjP2/+UA7vD88O+XeiSjG5W/Fl2rnBUzjSDEQmNIWF0zTTguQRH9xAwqGH7CvUMtB3H1RxNya7sQWvnDf5vDacNY2kNxMIblvqVOqV+ytEYrCgKHuuu3yr9G+1gzhSGtzas5a7HURETwGxlKGcv4AO/a/HI/6aVp2zETc/bzyhU8mn8zNJfvB2+DKQKWOBevNyXtsHBkkWordOJShyDe+yNtzwYqM0Y7HqKYbzHfk6sySZtZ8d0CbpDDEafJpk6XRcwP1k5d3Z3dYRtdt7lXdMOCjCzYHvScz
 VvOE0Akf
 EEo+v/cn/aTNP6KyDZG4uHXsaShlJPFxTMHR1BNglL+7Gh27RCRZzQFQpFpeqLcZUK26jVGr4O17EgZdbZRb7LPYVzLJg1wZGswBjU8N3TKm1FtxS1S4pPtz6GUN9lqe1ZL3D6eTvELxaZ5sT6Fli40mrwjZbekDEZq/f9j+HHZAikPu2Ejc/q+ph85KxqtX2fV5mL7SW6FYET5Nj/cuapMHtIUJhFqNy7gPJAyEkrek1q7qeIHXreYZqxP+sPraTcs2AZHVscruidgV7nBhe7YhGhHe1v6XNgJD8t95R2EEzsnDctzju3aXEPNYTUgWuPmQ2su6HQ+hOlkchRywJCYaMkPN7bbO7utau8sdI03EMKGXcyUQFDJF1XqFCdd+Mw16wL5AwVmXb5qNdwGchl0b32Q==
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
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20251216/202512161243.Dm4FDP0T-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512161243.Dm4FDP0T-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512161243.Dm4FDP0T-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory.c: In function 'wp_huge_pmd':
>> mm/memory.c:6134:21: error: implicit declaration of function 'vma_is_special_huge'; did you mean 'vma_is_special_mapping'? [-Werror=implicit-function-declaration]
    6134 |                 if (vma_is_special_huge(vma) || vma_is_shmem(vma))
         |                     ^~~~~~~~~~~~~~~~~~~
         |                     vma_is_special_mapping
   cc1: some warnings being treated as errors


vim +6134 mm/memory.c

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

