Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1C5C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 11:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D295B6B008A; Thu, 31 Jul 2025 07:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA726B008C; Thu, 31 Jul 2025 07:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0DE6B0092; Thu, 31 Jul 2025 07:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF8D86B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:17:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80A7C134A51
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:17:49 +0000 (UTC)
X-FDA: 83724309858.20.8E1CC9A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDE7D180007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:17:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UCQWA5rE;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753960667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmPdMFG+GMiUokXbT0XDikPiuHVqNV4BIc8yWZYUuKc=;
	b=pzeZ3fFNNM6hKNrxWE3JGmYK/zLkPglwn0zsbqkI+VA6/Y9d0aVKszMbyOhj4vJETNKNE0
	m2nbLXhhXcSDcPx/BDG3VbRUx2QWOBo8j91z4GJp5Z4XTPtWUnWSYNAEPdWw3NY46M2Lcx
	jetUtakR8wCldK0AduKiopXS4qGQqd0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753960667; a=rsa-sha256;
	cv=none;
	b=06ge1T1nrmERi5p03vdANUjkYPsp2pnorjE7NGKlcWpQD1Fj4hGfqSG4ReBcwFnEZsIfzf
	si0/Mp4N5dqRer43i8U9YkC87d0NEqM2APXO+BxMWvVe2mVy0BHv+u+Y1iV8Bx6r8k/eet
	Ae0utmCiR/h2PeRJdRN3Tqwa41uS440=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UCQWA5rE;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753960667; x=1785496667;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rp+0Ud6ehj2ssIqu0fmCm5PueYl31CGyOdfu1XfJBvU=;
  b=UCQWA5rEP4+qBfVUCsUacrW9REnaw0Kf2Rp8/C0/XX4iUDGztDEfsriO
   e7yegIqq7LNxRjTsHXKh+640V1Q33vgYCAfh1KdNWyZ5oce44m0+0dHzd
   LtE+fgtEh4NpgneLzGtDxCQoUitwJsACM9TfnHlHdYpMWUBts5xuKg6K1
   0h2o2csIblt02Ek/vbHI210oavLnjGDgWYrGEuNvGLVZwJ+3sBtU8dpa8
   QOK4PVDdEOUVCxqABGUhA9qnbnqxIrYkINMmvG5momVudI4iHtqta9me+
   GyBbrfxsSKt0cCGhRzFrCs4fZOifv1pqtXRSVPTTezE0UrS0VFVF/zfJp
   A==;
X-CSE-ConnectionGUID: Pyqq2E/JTGekkjp+hR/DSA==
X-CSE-MsgGUID: PLIuW7qFQh+koaEXGaPS0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="73870128"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="73870128"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 04:17:45 -0700
X-CSE-ConnectionGUID: jjq065fqSki3wdC2rxWRMQ==
X-CSE-MsgGUID: JIqMra71RlKfKrcgWid8zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="162514846"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 31 Jul 2025 04:17:39 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhRI0-0003iS-1j;
	Thu, 31 Jul 2025 11:17:36 +0000
Date: Thu, 31 Jul 2025 19:17:31 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v2 05/11] lib/test_hmm: test cases and support for zone device
 private THP
Message-ID: <202507311818.V6HUiudq-lkp@intel.com>
References: <20250730092139.3890844-6-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730092139.3890844-6-balbirs@nvidia.com>
X-Rspamd-Queue-Id: CDE7D180007
X-Stat-Signature: o4pzorh4mmkkda4aimc1ttofkkxaw94o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753960666-649696
X-HE-Meta: U2FsdGVkX1/2nq4lTYn2sOY6f6bFNtzz1/SJ6Jc2n5ZdgRhqTAIWUgrfHkffD4oTYVCfWpdNlL1acxxcrWn57lYSulRQB45ni95cDB78q/hOTFdz53v9lhrn5znuHBElikC+REitHj+NRJXsj8l+C0afSlJC3lPkadWOdiu8Zd9xfjPidaBr2t1gI5WpYTE1xsFT2MG2zCrBugDkhqGPiRq9tviMgBf8htjSwh0+3rDicMAweH9MJRmzpTqjqj482I1r6tovUqIyVb0OdU2yArxk/itwYWrW+YkzhYYTzACcAs0mP+d1cfMNbSDPVME/IPdlfJ/1t6hQ+2+hW4fQqBu0nX5yS1JeP/ENo20RHyBEvq7u0dP4x8mhd10QYfhkxGt+yMmnI0/5rjBFEun9F2VQHU++Sd81P0l99tk99FNR+nyDBSMCbYM4DHXnGpnBtugZ38oEoTLlsO4FsAdNKrXjUAQRB6rrYdeSuuZm1Jt6GjsSADQBZHO0e1S4I7829Tgc0fZpZ2KLtgu500mCXMyIIrh+TGnJbWN7n5jwOzpbhym5gEH0RtBgbCDhsWTqBRglds9q2qm7CDHt7E2+94oj7KE6d3zcCXas6m4bV37XAGxmJvAENGSIzcwfO3WsMioZGbVAmbKsUmBnroaqT9gf61CisKvbIkhYd4464ojPi8HvFdwxN3GmCmTSH+kI56WjHUFPlzzde6ke8ZOtgTyYaV50onSMibhBXlvUHjxgSUfh3Wgcx6gu6Gc52i/9uRMxotbYev/KlMecOZX5F0/HbS+rs/om4+qBIZ4Pzp0kaZu7KVNBsETk7CUccWJavzU5BBPSIeAksNBZLsU5/fJ8ukx7OWHAAbNCmFPjcSqx6XU37wTFxB47SzWo9jm7qXCaDoNtQeuPmbxg1AcRMx8rRB8kRK8++Qv5miF0ZPh0nKBigOvXT8doJcu8J4AQlvyIQwo+Z1z7O4/mZID
 7yhIRa5m
 UK5XV3BYvcZvSz84FD2S8DkxJ/dFU6pZCAo37AdyXJtrYd9M8LFtHFYXeIAxoDA+gIaiLcttGvPEMEXrKrttDwJdykJNDcQUAPjqtjZHixxY+aLoxtg6SwsxbDPLf9uvp0YZUwqrmkAui+MX/TrfIyVvcUluvgq97IzuewEnWVBBOSbNyXp7TqWrmg1zJCCstTo0pgOVHZl9hM+zLNRsVcQmBg/6jex+rrzWT2xxUXnYnrOrBDNPTWZOW+7QzMg+3lJSNcjrBWlz0hkKAC6fUtFVdOehU1yVWJyXQ0GLnB+3QXEKuDLO6854p2QMRjs/OBc/rC5nAfkEhPP1+uex13SJibXulZUFtq8zbZ4pwRT0riOeZW7Mgkd7Z/FmRE1KbfWvS3JLv5VR8A4jWP2PX6zwDufbjQuPiOdm0bph9SWf6cXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Balbir,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on next-20250731]
[cannot apply to akpm-mm/mm-nonmm-unstable shuah-kselftest/next shuah-kselftest/fixes linus/master v6.16]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Balbir-Singh/mm-zone_device-support-large-zone-device-private-folios/20250730-172600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250730092139.3890844-6-balbirs%40nvidia.com
patch subject: [v2 05/11] lib/test_hmm: test cases and support for zone device private THP
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20250731/202507311818.V6HUiudq-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 8f09b03aebb71c154f3bbe725c29e3f47d37c26e)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507311818.V6HUiudq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507311818.V6HUiudq-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/test_hmm.c:1111:6: warning: variable 'dst_pfns' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    1111 |         if (!src_pfns)
         |             ^~~~~~~~~
   lib/test_hmm.c:1176:8: note: uninitialized use occurs here
    1176 |         kfree(dst_pfns);
         |               ^~~~~~~~
   lib/test_hmm.c:1111:2: note: remove the 'if' if its condition is always false
    1111 |         if (!src_pfns)
         |         ^~~~~~~~~~~~~~
    1112 |                 goto free_mem;
         |                 ~~~~~~~~~~~~~
   lib/test_hmm.c:1097:25: note: initialize the variable 'dst_pfns' to silence this warning
    1097 |         unsigned long *dst_pfns;
         |                                ^
         |                                 = NULL
   1 warning generated.


vim +1111 lib/test_hmm.c

  1084	
  1085	static int dmirror_migrate_to_device(struct dmirror *dmirror,
  1086					struct hmm_dmirror_cmd *cmd)
  1087	{
  1088		unsigned long start, end, addr;
  1089		unsigned long size = cmd->npages << PAGE_SHIFT;
  1090		struct mm_struct *mm = dmirror->notifier.mm;
  1091		struct vm_area_struct *vma;
  1092		struct dmirror_bounce bounce;
  1093		struct migrate_vma args = { 0 };
  1094		unsigned long next;
  1095		int ret;
  1096		unsigned long *src_pfns;
  1097		unsigned long *dst_pfns;
  1098	
  1099		start = cmd->addr;
  1100		end = start + size;
  1101		if (end < start)
  1102			return -EINVAL;
  1103	
  1104		/* Since the mm is for the mirrored process, get a reference first. */
  1105		if (!mmget_not_zero(mm))
  1106			return -EINVAL;
  1107	
  1108		ret = -ENOMEM;
  1109		src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns),
  1110				  GFP_KERNEL | __GFP_NOFAIL);
> 1111		if (!src_pfns)
  1112			goto free_mem;
  1113	
  1114		dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns),
  1115				  GFP_KERNEL | __GFP_NOFAIL);
  1116		if (!dst_pfns)
  1117			goto free_mem;
  1118	
  1119		ret = 0;
  1120		mmap_read_lock(mm);
  1121		for (addr = start; addr < end; addr = next) {
  1122			vma = vma_lookup(mm, addr);
  1123			if (!vma || !(vma->vm_flags & VM_READ)) {
  1124				ret = -EINVAL;
  1125				goto out;
  1126			}
  1127			next = min(end, addr + (PTRS_PER_PTE << PAGE_SHIFT));
  1128			if (next > vma->vm_end)
  1129				next = vma->vm_end;
  1130	
  1131			args.vma = vma;
  1132			args.src = src_pfns;
  1133			args.dst = dst_pfns;
  1134			args.start = addr;
  1135			args.end = next;
  1136			args.pgmap_owner = dmirror->mdevice;
  1137			args.flags = MIGRATE_VMA_SELECT_SYSTEM |
  1138					MIGRATE_VMA_SELECT_COMPOUND;
  1139			ret = migrate_vma_setup(&args);
  1140			if (ret)
  1141				goto out;
  1142	
  1143			pr_debug("Migrating from sys mem to device mem\n");
  1144			dmirror_migrate_alloc_and_copy(&args, dmirror);
  1145			migrate_vma_pages(&args);
  1146			dmirror_migrate_finalize_and_map(&args, dmirror);
  1147			migrate_vma_finalize(&args);
  1148		}
  1149		mmap_read_unlock(mm);
  1150		mmput(mm);
  1151	
  1152		/*
  1153		 * Return the migrated data for verification.
  1154		 * Only for pages in device zone
  1155		 */
  1156		ret = dmirror_bounce_init(&bounce, start, size);
  1157		if (ret)
  1158			goto free_mem;
  1159		mutex_lock(&dmirror->mutex);
  1160		ret = dmirror_do_read(dmirror, start, end, &bounce);
  1161		mutex_unlock(&dmirror->mutex);
  1162		if (ret == 0) {
  1163			if (copy_to_user(u64_to_user_ptr(cmd->ptr), bounce.ptr,
  1164					 bounce.size))
  1165				ret = -EFAULT;
  1166		}
  1167		cmd->cpages = bounce.cpages;
  1168		dmirror_bounce_fini(&bounce);
  1169		goto free_mem;
  1170	
  1171	out:
  1172		mmap_read_unlock(mm);
  1173		mmput(mm);
  1174	free_mem:
  1175		kfree(src_pfns);
  1176		kfree(dst_pfns);
  1177		return ret;
  1178	}
  1179	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

