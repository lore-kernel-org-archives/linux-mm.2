Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1142ECA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731CC8E0006; Tue,  9 Sep 2025 05:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2778E0016; Tue,  9 Sep 2025 05:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6C58E0006; Tue,  9 Sep 2025 05:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 462438E0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:42:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12F0E86516
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:42:53 +0000 (UTC)
X-FDA: 83869222626.09.B00EB53
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf18.hostedemail.com (Postfix) with ESMTP id C21851C000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:42:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GoQX0d99;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757410971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaFrG6MURRheP1iaCzdkRdC0EMVQnkZvYVhe3PMdgvk=;
	b=2y3gxm8vASLxUEoJ7GEPtZ14sYcm2ALznQ74rVl6uEi3x9xXUxgn8nWWWEIhsSKWdZ7jYu
	uOCuHQNl2sJq2xOn1mTdxdZZxdjEoNMdWri+DSXqAmQ7Ut+tVvu53INsHWVdDPqr55NuLN
	YMJNTHYLrdEJ3E+YifVToOKqG/mHHwI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757410971; a=rsa-sha256;
	cv=none;
	b=P34tpuppYpTUPC+h3ErlT+fdrbFyZNRmvV/hEI89RyKDd8VLQa36MIuLKaGGzVtaZGmehc
	ibtFd18lozU2jWRspoeXsbG8Jx3X/NbKTk74v41vmWOtsTqJyp0iXyaLh1rHhFTAuuV1Xh
	tu1Ud5qcPjZS1MPuX4qRvSZlumXf5r4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GoQX0d99;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410971; x=1788946971;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YhIsuyT32WR9UdRetO0vSva6rEWQWAdkx7fjgtPvQZQ=;
  b=GoQX0d99KflbutI9dsIWkN+gtKmFx/HmGd8Ypxh8CN5jMEogXvFDuBgf
   Q4+GCkQUy6cgaECB1D15ktaopqOrk8EsZ7CsKz7JRVY0g9L2AQ7oEp6Bz
   cBEoE1QZxLu54M86ZFYaeJ8zQ0QVBrZNUzscfHkOHYrOawvRePdkp+6tX
   9fNNgacSlRHgoyU4IqrSooVlOFkxDSEXH1zOfKeAAmR5qZs2FJ6iztD5u
   Ul5pGXA43htRhxj1k6g+IZ7wuIp6pv4sXFomaJ4otY65yb9aA5W6z+CW+
   T6wNj1j/zuawKcvS3s58V18K2qizBcWqg7dKMZXMTGKHGGI/wG5erJ3Jb
   w==;
X-CSE-ConnectionGUID: AujPBYhyTLO5Zm+9DpgCyQ==
X-CSE-MsgGUID: uNYrREnCT4+gIU2j9ngwzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="59795912"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="59795912"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:42:49 -0700
X-CSE-ConnectionGUID: H9s4sHoTTPmrV+J0WIt+rg==
X-CSE-MsgGUID: rOUG1w+VTQOnr2+LE0peRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="177337465"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 09 Sep 2025 02:42:41 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uvus1-0004iZ-33;
	Tue, 09 Sep 2025 09:42:37 +0000
Date: Tue, 9 Sep 2025 17:41:44 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
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
Subject: Re: [PATCH 13/16] mm: update cramfs to use mmap_prepare,
 mmap_complete
Message-ID: <202509091758.mKPE6Hs0-lkp@intel.com>
References: <e2fb74b295b60bcb591aba5cc521cbe1b7901cd3.1757329751.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2fb74b295b60bcb591aba5cc521cbe1b7901cd3.1757329751.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: cd1fu6pi9ssa98qndt48qzq4edzp1bhg
X-Rspamd-Queue-Id: C21851C000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757410970-768390
X-HE-Meta: U2FsdGVkX1/3h6sTlFh6W/y2TRdSxyrsFtM3onqSyFH9sZsL3S0v95oflHitjAuL/fpCtslYU31NOepCRrlra8TdVhvsIZnqxo30FjRw3eS9CenWSHDN+eqfYOvWJIUhtmiLR6o2oMb6Gs2+7hIfnFCY0vj7R1yz6sXcy3wS9PxJCIHxCjkOOcfljPp5l3hQP/03R2mMxPj/9Lqz1GDSS/u1WMXOjj8CgSlg5Opuw/WU5KwwTvAC8APWIcJHgsKlhdqSAls+agY57GxSPJlZhMF7cOMuID+hS96mjYECMiIglWOZNcBVhvcAj1txwTatA9+1T0D2P+A+Ms4VX0jJ1waW5vDKB1m/gOAvLtbARPHy1Oy2fEkwoQzy0d6PHhHnjpn6aXOrwn45Wt0w9oAZM0s+8/tFMYknyWx4wuV95R/u7HG2EStwpUNHgHv5LBWLuOKH1F/n6FriVBDDrI8/4yXyP3RVgQcGDhhgktvRokUqj92D8f4KUMWahcd1sO1FVtBBOsA3a65wYcnF0kv4UdMw3CSa2zQjsrb5Fx3B8Pl8A00v13yEFh4ILn3Z3bIHx2uLQ2nk7eWBhMDLIyH7N5DbADm6L8tJGYOf9Y09rbDAqbGA1QnxSGte8X6PoYpcz9A/NpMFU+HVWSJS2EX568IISGRfy0ENceuxZnPkVfxtM5WSlSy6dLSfqUgKotNor4kF2AWa9zfJb3r4wGix+0cbQaT9r6O6cU56OOcOzVEC20tNWy5IV3qadaboUr+uaUMdpGJTLXiBvZhqmwDt5vKZpnaZuYJeJ481qhCDGfiiUsM9nlJFlaTRMiSb1zELDmG+WbmI24bB/yWTNakYJngpxRnorVq1GjAGwVKnqKQ1/aF1DyhAKHYRf6m2gDg4ztR96jLDk0COaaNnqHH8BIuxwdIjEh0bb/jRl+SE3XQL10C24Zp10QHnixj1S9broClDnA+T/QAtBUmOAQW
 ZeKM4j8I
 oHznmsw6xoxLqg+gSdU6saL4RLAVf+fWwkbLGH6l84x+jaXhwCD/EYcTVk876LYBI8is99HE8tGM2g/bYvU2XVaCt9nak8LLgGhf2FtUbiERmJj2Jjg3OmG3s/4cFIb3A1aEUi6q1/xLhy+6Je6+ENPikK4FWt1Wd7Y8/iP1fX4o2lK4HfmnsoBZzV68i93K1wb2JwYwxiawhVcNupUv49rkqMYYKOmfxTs+DQ4B3sTfaxS1+GFWEeqjoAL/y0AuTejpZwaJuGm+V4dV9OulJZy0kPQ0FFM7QmdbUTPE+6AEPfZI1VDbsbt68IY2pguO4KRNITbYBf/a1/jdTM6i6kUsIqOt8O3UOObkqltcbMJUOPK6b7LPG1R36SebONFMks7WuN3prKHWTU+wF7R6jzJfEjC2tg5NOpab6N/iMww+Jrao=
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
[cannot apply to brauner-vfs/vfs.all char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus s390/features lwn/docs-next linus/master v6.17-rc5 next-20250909]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-shmem-update-shmem-to-use-mmap_prepare/20250908-191516
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/e2fb74b295b60bcb591aba5cc521cbe1b7901cd3.1757329751.git.lorenzo.stoakes%40oracle.com
patch subject: [PATCH 13/16] mm: update cramfs to use mmap_prepare, mmap_complete
config: arm64-randconfig-001-20250909 (https://download.01.org/0day-ci/archive/20250909/202509091758.mKPE6Hs0-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250909/202509091758.mKPE6Hs0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509091758.mKPE6Hs0-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/cramfs/inode.c:19:
   In file included from include/linux/pagemap.h:8:
   In file included from include/linux/mm.h:1096:
   include/linux/huge_mm.h:591:16: warning: unused variable 'folio' [-Wunused-variable]
           struct folio *folio = page_folio(page);
                         ^
   include/linux/huge_mm.h:598:16: warning: unused variable 'folio' [-Wunused-variable]
           struct folio *folio = page_folio(page);
                         ^
>> fs/cramfs/inode.c:358:38: warning: cast to smaller integer type 'enum cramfs_mmap_state' from 'const void *' [-Wvoid-pointer-to-enum-cast]
           enum cramfs_mmap_state mmap_state = (enum cramfs_mmap_state)context;
                                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   3 warnings generated.


vim +358 fs/cramfs/inode.c

   350	
   351	static int cramfs_physmem_mmap_complete(struct file *file, struct vm_area_struct *vma,
   352						const void *context)
   353	{
   354		struct inode *inode = file_inode(file);
   355		struct cramfs_sb_info *sbi = CRAMFS_SB(inode->i_sb);
   356		unsigned long address, pgoff = vma->vm_pgoff;
   357		unsigned int pages, offset;
 > 358		enum cramfs_mmap_state mmap_state = (enum cramfs_mmap_state)context;
   359		int ret = 0;
   360	
   361		if (mmap_state == NO_PREPOPULATE)
   362			return 0;
   363	
   364		offset = cramfs_get_block_range(inode, pgoff, &pages);
   365		address = sbi->linear_phys_addr + offset;
   366	
   367		/*
   368		 * Now try to pre-populate ptes for this vma with a direct
   369		 * mapping avoiding memory allocation when possible.
   370		 */
   371	
   372		if (mmap_state == PREPOPULATE_PFNMAP) {
   373			/*
   374			 * The entire vma is mappable. remap_pfn_range() will
   375			 * make it distinguishable from a non-direct mapping
   376			 * in /proc/<pid>/maps by substituting the file offset
   377			 * with the actual physical address.
   378			 */
   379			ret = remap_pfn_range_complete(vma, vma->vm_start, address >> PAGE_SHIFT,
   380					pages * PAGE_SIZE, vma->vm_page_prot);
   381		} else {
   382			/*
   383			 * Let's create a mixed map if we can't map it all.
   384			 * The normal paging machinery will take care of the
   385			 * unpopulated ptes via cramfs_read_folio().
   386			 */
   387			int i;
   388	
   389			for (i = 0; i < pages && !ret; i++) {
   390				vm_fault_t vmf;
   391				unsigned long off = i * PAGE_SIZE;
   392	
   393				vmf = vmf_insert_mixed(vma, vma->vm_start + off,
   394						address + off);
   395				if (vmf & VM_FAULT_ERROR)
   396					ret = vm_fault_to_errno(vmf, 0);
   397			}
   398		}
   399	
   400		if (!ret)
   401			pr_debug("mapped %pD[%lu] at 0x%08lx (%u/%lu pages) "
   402				 "to vma 0x%08lx, page_prot 0x%llx\n", file,
   403				 pgoff, address, pages, vma_pages(vma), vma->vm_start,
   404				 (unsigned long long)pgprot_val(vma->vm_page_prot));
   405		return ret;
   406	}
   407	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

