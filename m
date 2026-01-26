Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6F9D1950F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 18:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29DB6B008A; Mon, 26 Jan 2026 13:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8136B008C; Mon, 26 Jan 2026 13:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56696B0092; Mon, 26 Jan 2026 13:49:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7B7F6B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:49:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D006D393D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:49:34 +0000 (UTC)
X-FDA: 84375003468.12.59A48FD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E450180005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:49:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="mTv74+D/";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769453372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eO9iVzdfx9FAUt5UjIn8X0pjFgbCELsa4Cryyg3cRGY=;
	b=aSWWnpUmhjStvaHfDFVHTbmkXOiB51cWzGotMDY5/7AMgJj3C0kO4aw8UE19n+qjhEwhSd
	R9MdDo/yQsnrwt6DzapgBNphTrUFp/hl8UA4RZ2Y99e48jCQ7blIAO/MW1ND2U5gBk/+HQ
	vHzB6OWyNJhkLGmlRcr6m+APUgVa7+o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="mTv74+D/";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769453372; a=rsa-sha256;
	cv=none;
	b=GZYjv+JaJPVrCt6PKmHWXA/vWN/xMtBFUuFWilAPVQP60lSK4JS0D5fEYM4k6f+mI4FDVE
	BeAYJnPxoMyZ7ivsf0N361XL3PCJDW+mhy/WfYhmbO5S3nWMyuk25RI+y+2o2JJmSQ2yxZ
	8PiZQN8b7XHBOQyR6/nI8oEi6b5Ug2Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769453372; x=1800989372;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SXbUQi/mPjILsJLm7/839nCdVVFUVngbGnAYOD7YVNs=;
  b=mTv74+D//abuK7zoqG+GIm96DYqTCz7I5DGMn4seqTp8PPxBcMEMHhxX
   Ir2AoLlX3ZevL3UXSAwSkbl4f9e5q+is1oI8eyocEMzX5Py7OsK30ZuCo
   8EORwSEe7NBEtXrK5Ig+Od6SLqF/h7sbayA+ctb6OBlOUp2sYVsn7hF19
   wjM2PmFRBl76BoHn9xNQpjN5LlrEiOsvm4/RD9l7NyuynIld9EraG6Q2o
   eF3rFnB5quI1tBw2GOH7xVD401zqLIaWblhHIVwijpMiqFUgVd7Lk954x
   tHJnC7uFVI5Fhjfd5ryky8NW+IaJP69F2BdLclwdWm+s5RA305ez60CeS
   g==;
X-CSE-ConnectionGUID: Yk8w7e6pSWithOYLHHLK1w==
X-CSE-MsgGUID: 2Qh1SuIwQ1+j7w8q5A6ltw==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="96100246"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="96100246"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 10:49:28 -0800
X-CSE-ConnectionGUID: Ec9Xcv1mReqcQU5/+wEU7g==
X-CSE-MsgGUID: RY3/mLDzQ1Smoy4+ign3qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="207361135"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 26 Jan 2026 10:49:25 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vkReM-00000000Xaw-3Vju;
	Mon, 26 Jan 2026 18:49:22 +0000
Date: Tue, 27 Jan 2026 02:48:43 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v3 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <202601270202.cL2IcE86-lkp@intel.com>
References: <20260126111939.1332983-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126111939.1332983-2-mpenttil@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E450180005
X-Stat-Signature: csph1zt4kw3x1j716wybhron3qpthat4
X-Rspam-User: 
X-HE-Tag: 1769453372-350419
X-HE-Meta: U2FsdGVkX198XXEeZzle80+pynnMhv1dMO6KlW9T8LYYaTXZTue4b23SUXZce1SW2+I+0OJ1KBWqlhJCP+4dOpt4ro+aKiWnhcQI1wgqVQ7WxOGhnZE7YKg8EmUImv3rZDbIMwJRnKssAwWcwEZCSz+lmEmI5FtRoYSM62PCLtUSwSOpFp4P6jyOnu6ZYwUuMxmDE9zxOkYCb016MLKRj5WIf4e52FKWvTcwxUESFg8e5SKlS2JXJ3CD/CdnUYQK/46h7yYxuAmrwgwmy4yV3Kkg2KaPsDNhETkRn6nTpvolrFoKJkqkci/St7Yz1+A9o6HiBU4phqtjOa2yylL11yMrpATco6B091xm/D6QyezchRbUM7XEmOUssLli64WgJjW89huimOdcNXCu84f1egZ9jVJGm+JMCO7vIbkj4f7jhiK7gsflMZ3kXb6j32xDMeWwb9mKI7hTIBB3S69jIrFxsJT5xprBunR1XkIEIJUeXOuXQBj8OgxS7hL0mVR+CRPJ1nviCeiE+wAd3Rn2yD++s4wtY2aAPrzVtNcroMvdiwZtPmQZTl2EITs5HcquYMq8aNAUDx5szwFCmPuTobXa1V5csAwgFZm6zjw9If1Zm/DeIdDjENwM8aWMOnJka1gMTEByRJYCBH0uiusRbZeQyvVhDGXOLbj5rgUXhghdwFi2BlzIq+eT8bzqc/DgqD1DqMmTh6OIESqXKF5vnrMT3Nvx79EFSRr08/Rww6+H8xbIouM4VNv+FNnSSnek7bFQtJe7FUu2SbalJrxcqKxyMJXZcCsZdx2Ct6CIisekeUzUzGN0wkM0zIryfEhY64Wq1JSAjzkdl7dlH9V9CqmtqA/XlZExby2lxVRPH4FEssRK6vxAih2MbrN4Zc9TGBamwTdtNil+tlX/o8tTddrAnc+XY2HIPRr7jZcjgiQ59FT2sd3hTvobK1jE104MeuIo/ZaC8TXc7Vf3icB
 xauGRKsd
 dmyywM8fs+amEETxDUo5KxyBpQT/WcJepNkMdgSOl2YKHmkPIKtGC8dLG/bs3ZLswU3yZXE6ib5pWxK9wbnP6Hs6raLQxwOuLt0WUQ7xHolsTFy1mG3kOmZfXshJ2Q6D+ZgMPJXOUu/Bi0bppa70b//EqmDaSlAgXxAidAPtt925c19aFDomp0fWHTZ3Zyr87RbYNoMQ1Fkp04EDV2hj8sdV8odxOHFuz6YW79JvmIffqIJlJhLSxLTR8sUdf9ZnY7/IXujHakmdw9e6KptMZm2QIAQrH4YL0eZtEkhv3fasCAgpUMeCzENbk08KzZWbfgsU9JH80A4C/4B9FEzVZDRsERoYvgWbJfAZU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 63804fed149a6750ffd28610c5c1c98cce6bd377]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-unified-hmm-fault-and-migrate-device-pagewalk-paths/20260126-192236
base:   63804fed149a6750ffd28610c5c1c98cce6bd377
patch link:    https://lore.kernel.org/r/20260126111939.1332983-2-mpenttil%40redhat.com
patch subject: [PATCH v3 1/3] mm: unified hmm fault and migrate device pagewalk paths
config: x86_64-randconfig-013-20260126 (https://download.01.org/0day-ci/archive/20260127/202601270202.cL2IcE86-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260127/202601270202.cL2IcE86-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601270202.cL2IcE86-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/hmm.c:927:31: error: no member named 'owner' in 'struct mmu_notifier_range'
     927 |         if (!hmm_vma_walk->mmu_range.owner) {
         |              ~~~~~~~~~~~~~~~~~~~~~~~ ^
   mm/hmm.c:1343:24: error: call to undeclared function 'mmu_interval_check_retry'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1343 |                 if (is_fault_path && mmu_interval_check_retry(range->notifier,
         |                                      ^
   mm/hmm.c:1361:29: error: no member named 'owner' in 'struct mmu_notifier_range'
    1361 |             hmm_vma_walk.mmu_range.owner) {
         |             ~~~~~~~~~~~~~~~~~~~~~~ ^
   3 errors generated.


vim +927 mm/hmm.c

   906	
   907	static int hmm_vma_capture_migrate_range(unsigned long start,
   908						 unsigned long end,
   909						 struct mm_walk *walk)
   910	{
   911		struct hmm_vma_walk *hmm_vma_walk = walk->private;
   912		struct hmm_range *range = hmm_vma_walk->range;
   913	
   914		if (!hmm_select_migrate(range))
   915			return 0;
   916	
   917		if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
   918			return -ERANGE;
   919	
   920		hmm_vma_walk->vma = walk->vma;
   921		hmm_vma_walk->start = start;
   922		hmm_vma_walk->end = end;
   923	
   924		if (end - start > range->end - range->start)
   925			return -ERANGE;
   926	
 > 927		if (!hmm_vma_walk->mmu_range.owner) {
   928			mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
   929						      walk->vma->vm_mm, start, end,
   930						      range->dev_private_owner);
   931			mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
   932		}
   933	
   934		return 0;
   935	}
   936	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

