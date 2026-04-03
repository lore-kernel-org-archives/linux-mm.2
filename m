Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E0FE7E364
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 10:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E6B6B0005; Fri,  3 Apr 2026 06:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437466B0089; Fri,  3 Apr 2026 06:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373BA6B008A; Fri,  3 Apr 2026 06:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2844C6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:16:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02FE3160547
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:16:38 +0000 (UTC)
X-FDA: 84616840518.04.9262D43
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf28.hostedemail.com (Postfix) with ESMTP id A4A40C0014
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:16:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VBN+FCYd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775211397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wB3xWKnFPRk14Pj+ZETrjYXM+zDjSVsbFfZk63XbbDs=;
	b=5zl8oyXduuNZiyhANSwPwDBrnBw5mdO9KP0i9Wng/r3+FcUODY/cPxH8MxvdYTEmNSzngZ
	+ulSh0PNfB35eaa47HFbL8f6ME2qITgllL7dl9EYqUvvAdPhOwzhChQqbu/HmB4prpAtiC
	4Z65FU5ewFZr7aQ3ShZlP3Brpz8dJ5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775211397; a=rsa-sha256;
	cv=none;
	b=Yw0wMOVBUkv98pagSef2pnAoEYgSaCWpNG2B4Cq34kkv5ZdAg6UMwfwThj9NjcOq8DAH3q
	g9KYyhcCB3har4MOl0VRkUs4DdYQRd03dJYbMmYBEJrzTKQxU6eUsbVaxBM5YeOq2BqOJg
	uy1uX75bHxE6MYIhSR50azFyM3ZFBwA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VBN+FCYd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775211396; x=1806747396;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zlVyks2Np9aQk5iEmOrB5Me5s80heOMsW2q1P0Pc6hY=;
  b=VBN+FCYdrjrFdlzmhzOCUJAanCGuElzaL3vGqmO8nxQJzs0iYfyIyY9o
   X/3dpq03YMzhiiHe3naWWnnVfgfEHD+9JD9OPgRQoUsGDwwYqOtIlPTgz
   soitcvHd0E98tymOMm0wnQ+D/o/OmyYfMynJnmgJeI7NiDu+l2tM9XZvg
   SGaGno5sfGM7Ue0yq5FrZTpgxFWOHIJGJPC6oXLKTvHdscteP+9dilFQ2
   T73VtdVClD6UZDnSkiXldDE/1a2kbaJAR493lcQTtrv6mLhnuitjxQJHZ
   w9myzijjCTKKiAAcTOsBoUqxJ1y9zdPX2qIFroGgqfa8OFe519Xkp/zwh
   Q==;
X-CSE-ConnectionGUID: RE18T8D5Qqqiaxwn7sd7Yw==
X-CSE-MsgGUID: Sm1hso/yS/ynuZevlc4mpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11747"; a="76338220"
X-IronPort-AV: E=Sophos;i="6.23,157,1770624000"; 
   d="scan'208";a="76338220"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 03:16:35 -0700
X-CSE-ConnectionGUID: FWZHu/aGQJewoPi3Dpx8ug==
X-CSE-MsgGUID: 0XvFpW2WTICgLDTLnuslTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,157,1770624000"; 
   d="scan'208";a="222867827"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 03 Apr 2026 03:16:33 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w8bZm-000000009H1-2wBT;
	Fri, 03 Apr 2026 10:16:30 +0000
Date: Fri, 3 Apr 2026 12:15:42 +0200
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v7 4/6] mm: setup device page migration in HMM pagewalk
Message-ID: <202604031253.Wm8UgWnQ-lkp@intel.com>
References: <20260330115611.347988-5-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330115611.347988-5-mpenttil@redhat.com>
X-Rspamd-Queue-Id: A4A40C0014
X-Stat-Signature: unmzb89fezzu9w1kqo363x1d1pstbje6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775211396-458366
X-HE-Meta: U2FsdGVkX18E8k/mromYmpFtkTAyDR165VUnBMUzkoQB2ty1IuKI8DK2sa+vKdyvlKgM9dgmGknil+bXHKWMLdvYYwQ6AVg9mefexRWYNzcsJza6xt6ArrPlU6NoreUB+QJoblw8M0cFghHVstMPM+E/smfl66XXmQ2f5jSGaqcIPdY6DKSZ2BbMcd2p3NLSr7/OgiGy7GkKfHIxfSw9SYdGwqZLSbgQyN50KFD2RyK5ngppnY1mxb9lKVcqROyspGDp4T1H7jbGCVFMNV0x3pZzqf7MftTz/ynht0ZP3oy3kHrk9YOBEuGFQJQuKxDFVPMsQNPMucxIm99El1795yotA9yGsU4TnYblPZz/yOYwp3VtdM8rhmzvTyAwvrdrSeMyI4oFp3w2crlAdpIhb5ab6raEz9T5GIBWPATgBhAInWPZB8LQrDkzNT3jQil/Zu425CvFqrICXz0axVqWEXMxcbNizirmjzKxA0nxFuVcVntk1M1PL8/GrJ+UIZxGOrww5WAt3JW6jaAku2c4MvghLrgbUeR+oqQsiZ3dbehtGvoFETs4wkpivRDca7Nd0Gg1rz4lSQ4GFUD6ViZelyAbWCVTwIxZ/BJ9YKOXTN7pAzthTfxCUcaUO9g2FB6TXyuiJ6ltaKmZSnigRTrnpqcEBM4G8W6s0Jvyi7fdoSqg0CW99hT2VpQVrAFV31kv2r8EqSm6QufnJN3bddh0NDbkWFsFrAvaS8vB1ahR0yowtkSMY4weeetnXIXhjULcfiAS8PDsPO6EOP9ZMXU3lLs91pdH4vhjFcWuIJtbxyHiadSUwq40Q38SDFtM98oZ5hQCA5pDYcawzz0Y4+oKz68GEKfdfzFBhmeZcdRAgRpvVB1jHwfzpnblCHXD2s2zklGC8Cz68kNDyIiadzwXexLjwtMVThKDC8lt46m17s10+nn8PRvEkY28k9HrjR0LtvlVQ7hVTRtK4Y3a1CW
 mouWgJeW
 d4wAgxErIAnWBGTmFcUidJsnkOiTKlIFHFsXn9mg0E1n8weA+yJRoV7rFBZv4dMAaRBZwcj2ZmzFUjcTRxKIaj1C8pWduZgN+Gx/gYELqTqT/spwEVSvGCZFanq+AuUSpaq/yV/j6ABBieeBfBNx6oghVR3FKOWBE7GoKTlQwd50w3uJBnydjUM6AFyrX6kSZ/fstF1v5mHJCEENu+xVBtyhFt0cPbRV2R6IXSdt8gd4aSHdO7cRqyiophPGLRNtqBXCaGmQJCB+OgHbk9KRpPWRT2IySYQ64VxWn4lYLHKK/WTXKKF4FBhzMZ39r6ZpGsWEtnsYz+ZN9aO2L3Ccr6Gdf/nWpsrXLOtmN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 7aaa8047eafd0bd628065b15757d9b48c5f9c07d]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-Kconfig-changes-for-migrate-on-fault-for-device-pages/20260330-202258
base:   7aaa8047eafd0bd628065b15757d9b48c5f9c07d
patch link:    https://lore.kernel.org/r/20260330115611.347988-5-mpenttil%40redhat.com
patch subject: [PATCH v7 4/6] mm: setup device page migration in HMM pagewalk
config: x86_64-rhel-9.4-kselftests (https://download.01.org/0day-ci/archive/20260403/202604031253.Wm8UgWnQ-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260403/202604031253.Wm8UgWnQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604031253.Wm8UgWnQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/migrate_device.c:508:13: warning: 'migrate_vma_collect' defined but not used [-Wunused-function]
     508 | static void migrate_vma_collect(struct migrate_vma *migrate)
         |             ^~~~~~~~~~~~~~~~~~~


vim +/migrate_vma_collect +508 mm/migrate_device.c

76cbbead253ddca Christoph Hellwig 2022-02-16  499  
76cbbead253ddca Christoph Hellwig 2022-02-16  500  /*
76cbbead253ddca Christoph Hellwig 2022-02-16  501   * migrate_vma_collect() - collect pages over a range of virtual addresses
76cbbead253ddca Christoph Hellwig 2022-02-16  502   * @migrate: migrate struct containing all migration information
76cbbead253ddca Christoph Hellwig 2022-02-16  503   *
76cbbead253ddca Christoph Hellwig 2022-02-16  504   * This will walk the CPU page table. For each virtual address backed by a
76cbbead253ddca Christoph Hellwig 2022-02-16  505   * valid page, it updates the src array and takes a reference on the page, in
76cbbead253ddca Christoph Hellwig 2022-02-16  506   * order to pin the page until we lock it and unmap it.
76cbbead253ddca Christoph Hellwig 2022-02-16  507   */
76cbbead253ddca Christoph Hellwig 2022-02-16 @508  static void migrate_vma_collect(struct migrate_vma *migrate)
76cbbead253ddca Christoph Hellwig 2022-02-16  509  {
76cbbead253ddca Christoph Hellwig 2022-02-16  510  	struct mmu_notifier_range range;
76cbbead253ddca Christoph Hellwig 2022-02-16  511  
76cbbead253ddca Christoph Hellwig 2022-02-16  512  	/*
76cbbead253ddca Christoph Hellwig 2022-02-16  513  	 * Note that the pgmap_owner is passed to the mmu notifier callback so
76cbbead253ddca Christoph Hellwig 2022-02-16  514  	 * that the registered device driver can skip invalidating device
76cbbead253ddca Christoph Hellwig 2022-02-16  515  	 * private page mappings that won't be migrated.
76cbbead253ddca Christoph Hellwig 2022-02-16  516  	 */
76cbbead253ddca Christoph Hellwig 2022-02-16  517  	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
7d4a8be0c4b2b7f Alistair Popple   2023-01-10  518  		migrate->vma->vm_mm, migrate->start, migrate->end,
76cbbead253ddca Christoph Hellwig 2022-02-16  519  		migrate->pgmap_owner);
76cbbead253ddca Christoph Hellwig 2022-02-16  520  	mmu_notifier_invalidate_range_start(&range);
76cbbead253ddca Christoph Hellwig 2022-02-16  521  
76cbbead253ddca Christoph Hellwig 2022-02-16  522  	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
76cbbead253ddca Christoph Hellwig 2022-02-16  523  			&migrate_vma_walk_ops, migrate);
76cbbead253ddca Christoph Hellwig 2022-02-16  524  
76cbbead253ddca Christoph Hellwig 2022-02-16  525  	mmu_notifier_invalidate_range_end(&range);
76cbbead253ddca Christoph Hellwig 2022-02-16  526  	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
76cbbead253ddca Christoph Hellwig 2022-02-16  527  }
76cbbead253ddca Christoph Hellwig 2022-02-16  528  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

