Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD07CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B37B6B009D; Thu, 20 Nov 2025 10:08:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AFC6B009E; Thu, 20 Nov 2025 10:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1826B009F; Thu, 20 Nov 2025 10:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65D3E6B009D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:08:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F12EF12DD16
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:08:37 +0000 (UTC)
X-FDA: 84131317074.22.E1B1A82
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id C43F91A0015
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:08:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kA6dn8pC;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVfzmxUuPKS0lqw5vFCMlnc50X2d2BA1t1HrDag24lU=;
	b=x/L3cVjRZzTQJ2Bl22OpYDK9jQWTqEd0AkEXGb5aY0+XlPSo6a7NKRNAra91irvLx5bncR
	yxU6+9tOCPSYiieIzrrDT2Kh/wIYnAcLVTaatH14IeqsQfefWHvwgSvE2YMFIi3g8Re/4r
	qyFwSCOYKLrCti6QY2kAk87gKnbf7cw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651316; a=rsa-sha256;
	cv=none;
	b=Qu3OGfFX1kekvOCnHKXBFmxQaQbo0vAUsG0xz7LI/cK0KrE38D+Son0tCx2kFggN41PalZ
	xeYuh9Rk89XnHAWU3qd+UCfqmNs2llzNXZx/dQ3o/jz7S3NrUdJRPqhBAp+YLDYlZHAbc4
	j9syRS1uhVvTbhOYCi+dsgYtjjpVrjo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kA6dn8pC;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763651315; x=1795187315;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w6TwQck4RtZRaN5bhbwgxiKkgVxB7RKGVAekX7C+lhk=;
  b=kA6dn8pCROtAObi6hpkhqjc17XhxT61RiUaQWhL0D9rIO1/4oUoG8Dg8
   vC7H0GbabaA/U+7/Xjwuc/24xJfigA8cr0eFrGDY9Mal2YcFaIRPpqoQM
   djQ5bN6cPCL5n9UQ1TnLfv/e1wGGhwJ9pL82FeFZ9CbidxwNsR5HOKBpu
   KxLxL1rP/YVhUegfNpBJ26qsNJgLHoTmC4wsf3aG9RdxKYBa6oVh3oBNd
   S5s9x5McyfVCnVxcJ3Zf9fcMUXRamBNY9W6GMv07MVBhMTarxyRgk97uT
   1jprrvYDa8KkgQ2ss5MRscQsvNUq2iivg1R47DR6Ktt8/aQYRt9JtBUij
   A==;
X-CSE-ConnectionGUID: 7hMfu0q+R0aPGmWg25XkHg==
X-CSE-MsgGUID: b48FGJzXQQeumz7sDFbkSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="77085135"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="77085135"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 07:08:34 -0800
X-CSE-ConnectionGUID: 8Ou1fJjxTwG9hXVmY0biCA==
X-CSE-MsgGUID: UaNGhiOURrSS5efMdFg1NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="190634335"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 20 Nov 2025 07:08:27 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vM6Gm-0004AN-1q;
	Thu, 20 Nov 2025 15:08:24 +0000
Date: Thu, 20 Nov 2025 23:07:24 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: oe-kbuild-all@lists.linux.dev, Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH v2] fixup: mm/huge_memory.c: introduce
 folio_split_unmapped
Message-ID: <202511202251.PCvSd2p2-lkp@intel.com>
References: <20251120134232.3588203-1-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120134232.3588203-1-balbirs@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C43F91A0015
X-Stat-Signature: g3w6qr5dzoaqzg1euiqiz1s5apyd6seb
X-HE-Tag: 1763651315-62982
X-HE-Meta: U2FsdGVkX1/q9Sle+il1Fo/WpuW4d1ZsIHSWi0KfeucLmsapQnrIyYHOMyN20aw9KDtSkMApRRWiBX8WFNEvmi//AwFy/CSnm9dHsWw9OQpXSO55AU60n910Ev6VHTYV6R2Rn6QBdScu9AxIDVPl+0THf3eFcnIYHUr3VI2xhM+1CjEsgsPfXCIE5AD3CVpa0F3M7bxaQeLoSQBifpyk6c/mEvpO8GQcqBnjUvrBdfGD5woFuYcRJTqYBSrDwk18TlmPA6oLDLzl10k9zUMJ14Re6yyjh5N0PLHIxuGqEytTlMkmajdomcbS+KGCSBpgMjWeHGSkzJKswevoGgBf2+j4gsrB26A3ApXgqrs+2lPqkCW5ClBcjqxW/IoENxXmNNl0+Dx86gYThHVg8V1w7Qf56rafI1gdTQwUIKe8xh/TPv6pXM2C/9RdJFA/B5c/Km/NXyV5L3j7MYKERemVEjCqHFCZNgPdGIhfxiuu+5lzoh5E/379JmCkbxy+RVO6fBu2/dxRBmTrX4YwwTdqOYc2qEkpUvsYtMK+9FYVS32SlhI6E/fsxY9ZVEnSWWzezV0wiS9FqFah3fDqwsoqx8Xv0JKxDRUGttxYQU8XxCiUkXAJIpUGhYchV3rLA6b+KI4uMFuEiFhfZNF2X5pZFu+9FwnaDxcHd8fHu48VhGlEXSzTim5BAyPwe/6jxndwM+wQKYfA1oS3gTh5nQ+97cS2wWmc57HTwzngmTvEVwcN7L5ynAEomyuShAPcsiN0GaMO2AOXX7nfUYugtJVzwLKCDa91/petLEYrSKrMnfuuam6mWcmIJI60zI8JvX5YBWVylz/6wphDz0MgWkdjVIOcgZ4//bFAE3C/foLzR/zJ/tEY6wi5hxqT//lU46j/Qh6dIEzWEDrFIqIo4bfZADa+T3KgjSlGfRsKOFWDGKlkjR3da7Y/qkYs954U7ha5luhDT8hIRoZ8m9SRSg9
 uQJhKPpF
 lXuuq/2EUIbFv7yULxNyXyqd3ki/TFCQzQn9OedRYyeDnpdkv+HT+mxsEp5mGtdvA/GQ8FKgP+14Mf6t38FS0DVH5v1AUhOpIu8G0HDB2460qtIkDglkyZSZhrEpYmDHUqXrCV9REbxe1/cMTEte5UknInzRjEQnWShCMy4IW+BwDTx8cdYjmvXnEdz9Z8jUusEdB9LzmHGvW1673foq1g94Tksua8EoOUKPBIm1NrujcLMx+X6yaMUXjAWJKHfkb1qkmQ8XyaFroldCtici+CTGneFPcQig/dcrRxaw7UZpLgquNPwITZDrm+HEOVBF548/r4x3g+9i/G04cvgGHQCOuG3Y+BD6Dc/i6QzmuL+ybAmHlFPSFg4X7CEQqn5+h296W0AFdZYUGvW9Z2ylo+rDVdQ3OqH5dPB2rw8cLGeleNXtCCSW8eeH4ojOW26PW4mncKRL0nA4l1RzdGe0wfwxVHoYQBiGn0hluFVXRBzTvlNEnQgWG+hBXw93neVn48/Jp4Ps4YZ56Aq48UXa9o4xF9A==
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
[also build test WARNING on next-20251120]
[cannot apply to drm-misc/drm-misc-next drm-tip/drm-tip linus/master v6.18-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Balbir-Singh/fixup-mm-huge_memory-c-introduce-folio_split_unmapped/20251120-214322
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251120134232.3588203-1-balbirs%40nvidia.com
patch subject: [PATCH v2] fixup: mm/huge_memory.c: introduce folio_split_unmapped
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251120/202511202251.PCvSd2p2-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251120/202511202251.PCvSd2p2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511202251.PCvSd2p2-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/filemap.c:39:
>> include/linux/shmem_fs.h:160:13: warning: 'shmem_uncharge' defined but not used [-Wunused-function]
     160 | static void shmem_uncharge(struct inode *inode, long pages)
         |             ^~~~~~~~~~~~~~
--
   mm/shmem.c: In function '__shmem_file_setup':
   mm/shmem.c:5838:23: warning: unused variable 'flags' [-Wunused-variable]
    5838 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
         |                       ^~~~~
   In file included from mm/shmem.c:36:
   include/linux/shmem_fs.h: At top level:
>> include/linux/shmem_fs.h:160:13: warning: 'shmem_uncharge' defined but not used [-Wunused-function]
     160 | static void shmem_uncharge(struct inode *inode, long pages)
         |             ^~~~~~~~~~~~~~


vim +/shmem_uncharge +160 include/linux/shmem_fs.h

   159	
 > 160	static void shmem_uncharge(struct inode *inode, long pages)
   161	{
   162	}
   163	#endif
   164	extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
   165							pgoff_t start, pgoff_t end);
   166	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

