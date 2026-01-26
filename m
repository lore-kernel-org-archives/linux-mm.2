Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAC3D19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 18:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1A866B0005; Mon, 26 Jan 2026 13:49:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2226B0089; Mon, 26 Jan 2026 13:49:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3D76B008A; Mon, 26 Jan 2026 13:49:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE5A16B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:49:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A33D5B7C0
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:49:32 +0000 (UTC)
X-FDA: 84375003384.03.5619678
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf24.hostedemail.com (Postfix) with ESMTP id E592D18000D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:49:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QyHi3tBF;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769453369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vOwoiAlek4Qc93lk3Tr/y/XocjanBaEAXoKdyjCm6E=;
	b=FIsTb8MYQmlPZpBDGvsr4dLjbNabWdWoUGa8FLDJbXa0/IWuVbpAiQrIG0Qe12ILmd50X2
	qxDe40xH2CZ3Gq/dLG6xMRPnfl01kSI5uf4bWOfikafCwMZsdIHoI4kvwFsEDMBUDhKpx7
	XpYJbr/bFhjIds0QfxefnyWVa0nUwD0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QyHi3tBF;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769453369; a=rsa-sha256;
	cv=none;
	b=JtaeJA9Xsjlp7df8tync4AVWQuirrwSV5Y1DEDtQy7GJpx4rKEL2uVEu3uB9An5JOBAND3
	0auF7JrYqN1fhOCZ2lZoc5GOJEvbV3lB198FK1FOzwTy3FA7DUeqDXHQTZtP2fngu/lfkM
	e80+4VibEXQLABEf7NWKPaH4Bse4pc0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769453369; x=1800989369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WKcCQES3mYtDjO4J/0l2Kt2HUss61JpG/oWxVVOyp6Q=;
  b=QyHi3tBFzeYB4PBJEdlusGFDYprFNplbrRlpMQWU5VHFMrdvEQkLCw64
   yTwUAPc70THNcAIAkfkg2HPrHhJSzNekZXol791QZjxBGoTiBiyLlouQX
   AQnIHgtKMeA9m7+DEwkHg9DBNBjffNuN3ylJQVZA6coUva3gAPn2lgEV8
   4jURGKZU4W436ovqDm8b138qgPDHGqb2oWRPCMfuHD1LKNOUYORGaqJoD
   mwgXX0awzVVafq+HAxHl77qX+T+PHjvBsgRQA6RuOOwpPAfFZvaUcZ9O+
   SPyTyzQuf0SmEEwcpqGyKsN8YgMdNNoa1zqL1k3awnEe9m058J8OSsJgU
   w==;
X-CSE-ConnectionGUID: QQytarboToSzy32IS0U2Pw==
X-CSE-MsgGUID: V2nUxjUdQfeDfLhtB6S45g==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="96100240"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="96100240"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 10:49:27 -0800
X-CSE-ConnectionGUID: lV6W8uJ5TOq52Cdv2LsI7Q==
X-CSE-MsgGUID: GVy41TOAS/q2/EtW8G/9PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="207361133"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 26 Jan 2026 10:49:25 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vkReM-00000000Xay-3k1R;
	Mon, 26 Jan 2026 18:49:22 +0000
Date: Tue, 27 Jan 2026 02:48:44 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v3 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <202601270203.n7gikUG0-lkp@intel.com>
References: <20260126111939.1332983-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126111939.1332983-2-mpenttil@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E592D18000D
X-Stat-Signature: jniez93u5mz1ygggedmqxrd7zwhopbxc
X-Rspam-User: 
X-HE-Tag: 1769453368-744741
X-HE-Meta: U2FsdGVkX19MJc8M+434Fgv3aJ7uMcBKyzlr/XBJOxkR571Uxk5LWOOt9jsM3txaSjmhX2bU26O1wkvAF9kLiyLT2d8FPBeh/H/qxncJ/CYwLpV/JX7u9Rzhg1Y7TVUCStwcrI6pe3/A5+tOrGSmb7iBCyFua34iMrFuS/GzugaTaw0+7Q6HmbeFuMv4mz9DEw/B/oitutNHkTWmG7EiBLZ4FQb4V7gdaeKHpGTzwhkE+DLIYTi6fA7Z/GiOqxVKA/xknVG6Q+yAnV7qUN0n28+d68hRoFh9qUe4tXl+pdyWPsIns147bid8ERKynfI8mtTGHbpk/kSa5rQfzuk1ifleeVCEeLv+854QvMxW2/Lwv2um/WKDxvzd68c6xD4AXgQN3UKb7MMgbAuDuxF96VP6+DjL5NKkr8gXgQweUWP0HdkrXZFSywRDCBc6pV7H8Zr8u1eS3f/16ss3zVdpkvoARbhY0Rb1Jcl4rY5VNRxdXPeO/5uKH+XZ9ljRJ9ClWymHBi5FNBADIsXyxW1FJJszmuy4xdUlw/qfwPCMkdUJoniFrc6G+MGyKeCx1xN+beyfcxEcGHnqBPePSCWg95mz4Lx2gKAjGjj9M468BUcRSfnsVmVRxbxRncYW4hIS7UFwTXAPAB6hh/JB1Z/fLzti/s1Gcw2AMXNX+pr30/zvTEkWULZeMk5HV+bUu3p3LcoCdqJcwE71uMEetJlVTWbJnnswLNJtYZmIfMl+KWGXuikcafJdec3/luF7qXD9LTN0mEhWrAZCbXn7EkWLC+JbeHAMjZHKcpZFz3UHjDepS3U1hO3IBSdpaT4K5Xm67UTZnediv3FPYUqNS0l6AhSRgVNJRTXqALrgjB0FsZWItUXV1b2QPZ3tY5A3kbpyWBa7TrP94qBOqpF6VKtjtL5LgUWSEcEuf64TJ74TCjOZUFaEJmxxV9HZFQZCBOn68uqpHpHZV/hKgfRUtRm
 a9lEPDrI
 ooQMaGfOFwf/TVWF6gN7ynUOPclYsiIIYrZ3gwfqQ2ShDTfLwvTdCtPZs+sBfp8b7+Cuz4Q88pNsYUcxkxi6Fk41mlciZ8Zbt79VWizqRRUWdRZYppig2opOuqKCzc1C9JRzcq6V6Qd306yvRq9Z6XN/DUEGvDbMJiIaEfoY+WV9F5JPIqRRxvt7cDxDjVSNL+EXjEq1H3rfGJK5orYTOlYtx3s8XFc0IfgvxVHLYSKi1zUYjGgVdqd0d97EUvuH+VS7btW3jg5XHjGPRMiDtGus/U6lPvqE7byzHK6KMoweLujuyQ9e7iY/oJY9C2B8RHQ7kETnhq0R1TEZKKInBTjnp6iICZugSqfPY
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
config: x86_64-randconfig-005-20260126 (https://download.01.org/0day-ci/archive/20260127/202601270203.n7gikUG0-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260127/202601270203.n7gikUG0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601270203.n7gikUG0-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/hmm.c: In function 'hmm_vma_capture_migrate_range':
>> mm/hmm.c:927:37: error: 'struct mmu_notifier_range' has no member named 'owner'
     927 |         if (!hmm_vma_walk->mmu_range.owner) {
         |                                     ^
   mm/hmm.c: In function 'hmm_range_fault':
   mm/hmm.c:1343:38: error: implicit declaration of function 'mmu_interval_check_retry' [-Wimplicit-function-declaration]
    1343 |                 if (is_fault_path && mmu_interval_check_retry(range->notifier,
         |                                      ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/hmm.c:1361:35: error: 'struct mmu_notifier_range' has no member named 'owner'
    1361 |             hmm_vma_walk.mmu_range.owner) {
         |                                   ^


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

