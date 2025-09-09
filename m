Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44155CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 03:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64CDF8E0006; Mon,  8 Sep 2025 23:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCFE8E0001; Mon,  8 Sep 2025 23:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB998E0006; Mon,  8 Sep 2025 23:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3AEDA8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 23:27:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98EA81DCDD9
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:27:44 +0000 (UTC)
X-FDA: 83868277248.08.1F77B41
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 87BDC40004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:27:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lRmaqaRm;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757388462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ruo+Lg5dZGlI5FP0jyZPI0kxMIQoQS1MA0e/ucNE9HU=;
	b=lZb9bwNQoF0e7VJrXVtvRK4hqGEj6e9zflQXxkDkYKAG5i93Tno5Nk3ORarSMnGN6Mqhot
	vyybmP29WRwkZiklHjlE9SXRPRumuZZndelfizfw4bT9PBH+38p37DRnYT8S8lqElUC2Up
	Skh4BmcRXH1RMScKdq9sY0zh2aJPa7s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lRmaqaRm;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757388462; a=rsa-sha256;
	cv=none;
	b=PVi+6HojECmg8qBg1Wso4x0vk6O2MrcFkYkJk9ZDe3F9TY1sz3y7NKlNnFQPNAx+WWGpBp
	XLg8NzrLuhjN8Xe+17MvgjwjzeqFavOfBJmwxZJE/b6WuShbHLuZNs+FtxIoGZ9jm+/Knu
	2E0ABgOsFyffN+DitHrMmsOLDAokLRo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757388461; x=1788924461;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eZ3BEh7dIzsbZ8wWnjIfjfaoUhrneuAaCSsHRmPz5F4=;
  b=lRmaqaRmUnV8qAtyg31kFzHBfsstbkYMKAXnL96nrvJtDvEBPo2vPRVU
   WMg+gT7Gp6WOXMrArJn2nUZr4MJ2GVS0+4Vs7kGa1ycGys+ZRBwWtZZx3
   RbI/V6iYHyca6ta+1TIvzuZECz3mGDm8/qOjltBw993d9UdDwelU/9Jtj
   qjdUOR26zoCb4q6Kabnv8qbBxoDq9YanbBBJqASdC0eXOvlpzD5P5DKlq
   ulMnkMWbZDHyvo6jpnbLXJT3DyqtQNYBR+wWU6LePElo2V5xJ6yBN8F//
   Y8+Y28bQ5szmq+yRAb1Efa5kYVeVErpCW6IFOqHpLD6W6ygTb4o5BmycZ
   Q==;
X-CSE-ConnectionGUID: ND+l7kZyS8Csw1mBhX0XgA==
X-CSE-MsgGUID: TLgksJ4SScCLdBsBdQjH+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="63490234"
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="63490234"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 20:27:40 -0700
X-CSE-ConnectionGUID: HleFm4PdSee9xcpbhiGQ4A==
X-CSE-MsgGUID: PlIdZEEHR/ucSkVRcfSFIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="203746262"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 08 Sep 2025 20:27:32 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uvp10-0004Nr-1K;
	Tue, 09 Sep 2025 03:27:30 +0000
Date: Tue, 9 Sep 2025 11:26:50 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH 12/16] mm: update resctl to use mmap_prepare,
 mmap_complete, mmap_abort
Message-ID: <202509091127.USj6agt3-lkp@intel.com>
References: <d9e9407d2ee4119c83a704a80763e5344afb42f5.1757329751.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9e9407d2ee4119c83a704a80763e5344afb42f5.1757329751.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: n784dsro97yhhyp9sdiaytwfrzqirc9s
X-Rspam-User: 
X-Rspamd-Queue-Id: 87BDC40004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757388461-413541
X-HE-Meta: U2FsdGVkX1+FJ6TOj19qacXOiynezXozUaAdF2vRn6ELEYJ+zs13ewsFc9GwEGewqS5z0WGS/UUugkE6sdz7oEgOT72nxLy/babRgQHous6Yxp3cHdREStueAgzlQgbxbPtJC0/vfgFdiK2GJHWgDoJtx6IevtOntUXvRJzqqNON93hoACGRIEHUjGjn7WACxhRDBa8SdWItm9V6M+77F7/UcONtso5EYhj5vJ3Z6UHOWMpZE08CUpUl2K6nVuBlEr4+ikblloiT0Q130J/EkEodNwYulYmZx5GfM5a1ID7Pvk+MuK1MrDWSho4sT5ZsJg3l0E17JYvOdeSnS/8SyzkTeA/4Aph6sVO8Ri6pj9BOYC2T5fzGyuSqBYFgvMardQAt6X4vc2IAlT7YjZQPOLxNDZD++VwDFf2KJjVUldxhRdDrcPxh/JvDZSIKFDeZeWu+UtFt0o5Z60Pesd6JFaIkQqBgv4L5t64S0DsTsTyNEcoCEERa4PuJA9pZZtXXydaqi1lc5SfdN9X40j/sayall1yMLjWAxDSV9IkUGFpLB6fEZX5iUud+40oCVqR71Cy7LoxXv9o7Vg6FXbhKwLdnS1GGpVj4FA+iGW/ODly1Zln4YB8IZ6QXsjzXLNzbSMD6qjSozfuw1n/GUzsl213JNjNaEMbFCnIQ+sLC9OiBJ4pN0s2ek5zebzaEGWvUHB8gsQcIkU2Zv6vkKV3ZwcS5NY+2SHuEpExYd/XXHl2XxyRScHl3c63l3jYPr8DFN5pkd2XKhWScBf5lAE99blCq60lRR6/G/uUIMUe6cD36pfGFBmdBfKp156NGQsEO5jZmAJMXP6+rPjJ4hF/X6mKuvnNT8D/w8ILArJM6vh/hR/88GrM4+J8KYxVZ1iK0tpFd2eQXtPgCBR6l4OLaZvxh0roQkrlVhLBL2i18uWRHo5qq/6fVmfZo0AQrqbYUgV6LanRdCeB/dVVVhAB
 CsAJc5JJ
 Cak62aYH/49QFfatlS5rZed2Rlr+w0Tv2bbDgvW1p9Mz8nuydR/kbM06o7GmZlu9eBo9ZYbLPjVbp3rbBzTvaUxQxZ88bC79fpi6sZxHL7yqz6Q5DkcGkzSuHIn/jZPlXY3MWJ8m5ERY2m1g/NSPAolb1QwdKeMp5Iy6YN4iJJoEeM6BGjudhH8Sgprft9i+63mkGtJwaZnyjL+WSkG/M1cj/DW80PP5qIJTQsdmQtkEPylvcRnOCf1TCP8F1aZbtjCxhwRGK6QvPkXyd30RjLpUfFAEHvnK91hPrbcHLuhFpxACPr/akmI9AfXlPKUG36gGH350Wkkk5pN9qth9L98Z9JX8OCnlktj1nUJgnq8YJw9vSmAIQCrajtK1OLwgwg91u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[cannot apply to brauner-vfs/vfs.all char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus s390/features lwn/docs-next linus/master v6.17-rc5 next-20250908]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-shmem-update-shmem-to-use-mmap_prepare/20250908-191516
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/d9e9407d2ee4119c83a704a80763e5344afb42f5.1757329751.git.lorenzo.stoakes%40oracle.com
patch subject: [PATCH 12/16] mm: update resctl to use mmap_prepare, mmap_complete, mmap_abort
config: i386-buildonly-randconfig-001-20250909 (https://download.01.org/0day-ci/archive/20250909/202509091127.USj6agt3-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250909/202509091127.USj6agt3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509091127.USj6agt3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/mm.h:1096,
                    from include/linux/mman.h:6,
                    from fs/resctrl/pseudo_lock.c:19:
   include/linux/huge_mm.h: In function 'split_huge_page_to_list_to_order':
   include/linux/huge_mm.h:591:23: warning: unused variable 'folio' [-Wunused-variable]
     591 |         struct folio *folio = page_folio(page);
         |                       ^~~~~
   include/linux/huge_mm.h: In function 'split_huge_page':
   include/linux/huge_mm.h:598:23: warning: unused variable 'folio' [-Wunused-variable]
     598 |         struct folio *folio = page_folio(page);
         |                       ^~~~~
   fs/resctrl/pseudo_lock.c: In function 'pseudo_lock_dev_mmap_complete':
>> fs/resctrl/pseudo_lock.c:1006:23: warning: variable 'psize' set but not used [-Wunused-but-set-variable]
    1006 |         unsigned long psize;
         |                       ^~~~~


vim +/psize +1006 fs/resctrl/pseudo_lock.c

7168ae330e8105 James Morse     2025-05-15   997  
5ef190013e9b31 Lorenzo Stoakes 2025-09-08   998  static int pseudo_lock_dev_mmap_complete(struct file *filp, struct vm_area_struct *vma,
5ef190013e9b31 Lorenzo Stoakes 2025-09-08   999  					 const void *context)
7168ae330e8105 James Morse     2025-05-15  1000  {
7168ae330e8105 James Morse     2025-05-15  1001  	unsigned long vsize = vma->vm_end - vma->vm_start;
7168ae330e8105 James Morse     2025-05-15  1002  	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
7168ae330e8105 James Morse     2025-05-15  1003  	struct pseudo_lock_region *plr;
7168ae330e8105 James Morse     2025-05-15  1004  	struct rdtgroup *rdtgrp;
7168ae330e8105 James Morse     2025-05-15  1005  	unsigned long physical;
7168ae330e8105 James Morse     2025-05-15 @1006  	unsigned long psize;
7168ae330e8105 James Morse     2025-05-15  1007  
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1008  	rdtgrp = filp->private_data;
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1009  	plr = rdtgrp->plr;
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1010  
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1011  	physical = __pa(plr->kmem) >> PAGE_SHIFT;
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1012  	psize = plr->size - off;
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1013  
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1014  	memset(plr->kmem + off, 0, vsize);
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1015  
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1016  	if (remap_pfn_range_complete(vma, vma->vm_start, physical + vma->vm_pgoff,
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1017  			    vsize, vma->vm_page_prot)) {
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1018  		mutex_unlock(&rdtgroup_mutex);
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1019  		return -EAGAIN;
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1020  	}
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1021  
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1022  	mutex_unlock(&rdtgroup_mutex);
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1023  	return 0;
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1024  }
5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1025  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

