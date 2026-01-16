Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 223C4D4A5E6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 01:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7486B0005; Thu, 15 Jan 2026 20:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485B86B0088; Thu, 15 Jan 2026 20:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3667A6B0089; Thu, 15 Jan 2026 20:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 202DF6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:30:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B62331A04F6
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:30:40 +0000 (UTC)
X-FDA: 84336097440.17.32C2779
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5684340007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:30:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fDdvxhs9;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768527037; a=rsa-sha256;
	cv=none;
	b=i0RjPpnXyvmTaOc0dILG3z8hJX6a+f0lWNO5Jo6TFysd9Cljgj8PkrQCKV/lLuFJACNpoL
	siOQ2D8ZGODukuRTj8IkB2Gsz6N2m+RshX2nd6CY1u43etMTceyHMjZS0080eeQJbvFj8o
	xDt7FaTwn9iLqnpn1Pc3EJXJRkr/vII=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fDdvxhs9;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768527037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1osPjbOAEmESPZMDxWyeIsVPLZJpvPvY6/q8Z1pBr7M=;
	b=dnl96JX+quVrnORoy59sZvK9GUADDveWPTkz8+fYYTOCYP1V/sWGxP/UWxsGmNcvPmnkNj
	cgbIH5RJGYAJRXo2pVuDrUq8nWbMDrRR9k69DwHmLkcUukSSBuzPSs9qBOkr5mWlgZ3J5z
	hlT8yxmP6caLL/86kC8pj3n5r1+jvmo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768527035; x=1800063035;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UgLsH6ZaFK8pXrgYt6vs97kEThqFEQtzyuoGkVmRNE8=;
  b=fDdvxhs929wGJ4dTHY2EocsWXUP2Z6skideNhfh/tAhCFbxFMMWA29vy
   iMRdXaCYlHEqB9HtcPpK5KfFiIqd8o+HFcM4Z8IKP3kx9iW1osoGKvuBn
   xYXmPqt9yZ/wBgkZ//L/+muem7LAeZVaKjC1Egi6tXsLgz2+EbunLaF/z
   irH7Lzho22vTSbW+MENYfSMZg5sz4OuzYUMMsKAVWbHF//yXLCIHdCq8n
   nvZ20rNMyfJG7LoLJsS7U8m+6zLnc78ql4KB99oVxA+qrqDZf5xmZHD3j
   /wJOcBQWlvU0mxqiXZ6sPjvUWOXKBtj2QDvjOsFWTUEHzWRPvDKgUDZZ+
   g==;
X-CSE-ConnectionGUID: AticxHA3QbawiMnKwkeBfQ==
X-CSE-MsgGUID: mvPnQ4SeRpCMtbk4YDkxXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69893589"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="69893589"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 17:30:33 -0800
X-CSE-ConnectionGUID: UwGt3DyhQWi9BoxDtTCMkQ==
X-CSE-MsgGUID: ra/CJk6KQRGRn2yPb8TWmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="242654490"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 15 Jan 2026 17:30:29 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgYfS-00000000KDs-2rEG;
	Fri, 16 Jan 2026 01:30:26 +0000
Date: Fri, 16 Jan 2026 09:30:13 +0800
From: kernel test robot <lkp@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and
 vms_clear_ptes()
Message-ID: <202601160919.v3GpIeUh-lkp@intel.com>
References: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5684340007
X-Stat-Signature: fy6msyt1xfdcbg33z4urr9pkjc6d1q14
X-Rspam-User: 
X-HE-Tag: 1768527035-31794
X-HE-Meta: U2FsdGVkX192MzyFIjXbzOsPrI1CKd0B2+fozKx/iTV0gvn1mcFOUdtiBMfHPSswDshh88GnBmiYfZmLsCBbeGWZ9DrNRe+3Yz0JidiCOoY3F73sL9gZls+KQzkkPfvV/v+sYTgiEAhmtJ7YKaywkfDE8YRO5dk0x8BMpAro6Ck4g0UojUnrcAVUhjBTSCqF4z30j3vuuRMfvopGq8fbMhPv9epBqMG+sBKPIHNlmT6IhMLqfhK8ImQQHPFzgub3RxNm3uIa3CNdGvMpX/k7WCLfBNblGSzk88Mh0gDcbU2EOFc6ih5KlPh5PrYCIf6VP/NfAZRbzLeUOwfomJlp3IVjPQ8w6HaoREjSadS1F7Xhhu/IktWRclyEJW+7V4Kona5Ge4D/V2yTJ0yVP5k61qK7CqNoN7Yu7gFm4yZ0jErnvJczJbz8QI0EeE71J3FjeYmvfWLG+nCsBUqmHLcJ1fkVoLUpHge/h1glB/gb866OJllYpza3Owe8W4E9pq/Ujq8mX9fi84emF6BCmPkDCY9SeWht4t4VxxlBA7mYQmmZbv5iNZ8O5e3x/WM88K883TY7a/6yk/Z6XHzeklldgUMYfi5pqQsG1uEcyHyxXv12HaVOrrYo+sV3aX+tWGaCSdB5WWDK+KNXEVAqGje7hCFJa2jZvB6+bNVjO4DWLwsyWM5jzrjXA51YMrReASi4WjE+6K/LvkSpljtwoJQR+q7NZfdpG9DraT2q7hDwUuMbtDAcwkhM3iN/o3niivAENFGsQDv0nRTe6daNsBvYUGXebmqtQf4CBM59cD8fC9FWVbY/WGj23yAGIiEKPKRMk0Pqq4aa7kiTNRCWeBgw9noWDGPUMnF8fLvYbgzg3Y30q5+vtG02QPalzXkrYUyzIitogjeuN6PIG4qfYxdvKAvG45LOU+noc5u/8Bpsb5urIEuhl8qDaUVKECqC8+uvkKmpapuywluDkVkTIfb
 paORJebA
 4/x+lA429zqZZ4pzk/XbnhRvt8evCosQ50CDvYVYpt+JTHznlaPsnhU9GlzmCEayWDnHBpzoNqcN1Gz6lCyLzwSkG8bvdpahDhditvYvTk9sYD5/n6rocpHuzwny9Mk0gi1P5VRCVlQ1vqqE1EtbJAqFQLdtjWFIhp7RhXyD0+WNYbE8wvxumOIamaFolmYLMFWU/v/6sACoNhNmLlNeXM1BsgEj2wH7FYQieeANFg/P69IJ+5OkLsho8w8hIlbQwuSgdyMrdPGqjSdpdPDDGLwqmpo5v1/+VrmhZA8cofuvjqZ7kRBAIEh7pldAvdt+B4NBZpPyH4lcJMlRShLpOqc1n9NotR5YMjN/tBQi3AjjlC13SGrYP75BjNAuIwPFy/7K3S33+7iYeCNMM6Jeqnkd5n3YMT9GYqoxvkJ6QN80ht3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.19-rc5 next-20260115]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/mm-mmap-Move-exit_mmap-trace-point/20260116-023126
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260115182720.1691130-9-Liam.Howlett%40oracle.com
patch subject: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20260116/202601160919.v3GpIeUh-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160919.v3GpIeUh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601160919.v3GpIeUh-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/filemap.c:54:
   In file included from mm/internal.h:23:
>> mm/vma.h:176:18: error: use of undeclared identifier 'USER_PGTABLES_CEILING'
     176 |         unmap->pg_end = USER_PGTABLES_CEILING;
         |                         ^~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +/USER_PGTABLES_CEILING +176 mm/vma.h

   169	
   170	static inline void unmap_all_init(struct unmap_desc *unmap,
   171			struct vma_iterator *vmi, struct vm_area_struct *vma)
   172	{
   173		unmap->mas = &vmi->mas;
   174		unmap->first = vma;
   175		unmap->pg_start = FIRST_USER_ADDRESS;
 > 176		unmap->pg_end = USER_PGTABLES_CEILING;
   177		unmap->vma_start = 0;
   178		unmap->vma_end = ULONG_MAX;
   179		unmap->tree_end = ULONG_MAX;
   180		unmap->tree_reset = vma->vm_end;
   181		unmap->mm_wr_locked = false;
   182	}
   183	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

