Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926E1CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 02:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E1C8E0003; Sat, 20 Sep 2025 22:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CECE8E0001; Sat, 20 Sep 2025 22:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4A48E0003; Sat, 20 Sep 2025 22:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0CE8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 22:51:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFF1313A463
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 02:51:12 +0000 (UTC)
X-FDA: 83911730784.03.C688B26
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id 075168000D
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 02:51:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jJ3LQE6o;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758423071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BOWUV6TarORDvUuciv7qNxGxkFMDSsTZrJCXqZpCsU4=;
	b=FmsF5HZPTvqXk4rwmxrOZ7hrsePGm0JDAN9XtnSrKeyZ61diKCMHc8uDH+FWJSBjQLNTkt
	SJp54O0e3YzQHDGhpZBcYcNXInuBodXXh151krC+wHpArp2U6sgSiTIXLUSw3RLJvg4TYI
	+PVIa/maLnSMm73lGTSAWjuZK1WdhKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758423071; a=rsa-sha256;
	cv=none;
	b=CV3onBJ6P+/JU49AhwmlauvI7kLU6V+sxk+0XoEx5L1IV1Tpd4CF3aFHOoKPJSPgV66cG0
	LMlFi0F+DulSyTW2z3TPiQ2nU6SVrOcV2D7eDnaZmDib2sgyflRRoUKXm1PFBwjtbY0Rm8
	3ekEx4FxsQI/zvvWIYa39BRGhVrXOCM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jJ3LQE6o;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758423071; x=1789959071;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=8fhQLFIuGNNY2mxfTC5RKkbbwX1z1TpSWw5hUNknMTo=;
  b=jJ3LQE6oUkoHRsqracQIz7hh1mqW/2JhkgHK/hizcVixx2VvcqtLiDut
   p07njpPznLj8dMnG7krt8TYD11JalMjvdr9y8ig2EQFbEHbXjWAfjKnzF
   beRwjCE+OmcpeQGo7EWVHJxVN46eupkLH08wZojutsgNIj8A3q3BimFUY
   N+jo+ekhWtanN1S2Z3kneNacEmeam7SfWUjkSyu9D099Y2owdcsA8OQWa
   mhHq+7GzUhEU0XmXPWvCn8guU+QqI0XR630RNM/xzlfHhI1CrLf2cSvUg
   2rS6b+DtJhhxh1EgRg9j9sen2TEquIzj5PXNBsdjT/KMjc1l6QQMSYtA3
   A==;
X-CSE-ConnectionGUID: JTYKlVFcRNGvdSJpv10nIw==
X-CSE-MsgGUID: vKDOl1bNSSOBeJ2ov+KIAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11559"; a="78166132"
X-IronPort-AV: E=Sophos;i="6.18,282,1751266800"; 
   d="scan'208";a="78166132"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2025 19:51:09 -0700
X-CSE-ConnectionGUID: f2oCyktZSsyWwJcUGgAP7g==
X-CSE-MsgGUID: /jHam8pIQyKqcQj10J8CcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,282,1751266800"; 
   d="scan'208";a="175312280"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 20 Sep 2025 19:51:07 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v0AAK-0000Nh-0p;
	Sun, 21 Sep 2025 02:51:04 +0000
Date: Sun, 21 Sep 2025 10:49:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [akpm-mm:mm-nonmm-unstable 53/56] kernel/kexec_handover.c:934:26:
 error: too few arguments to function call, expected 2, have 1
Message-ID: <202509211055.qaTxLxQS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 5krcycci3nccsubzkxpdwuw3q11z4z11
X-Rspam-User: 
X-Rspamd-Queue-Id: 075168000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758423069-10298
X-HE-Meta: U2FsdGVkX1/9B4sgOMmJ5LWRpNLj0RHN5pDVl7YrMgI7H4+GqxtVYkv03WsfSJifIXKywSH4kNuKxsVaThSheoRbjK0yhB/ouvtKJ4UEUB+4gJk/pR2JGmzZQe69qyg+HmHWQB2+qNkMUlGN35EqlXUk0WS4I3QsIcPsiuKMEnkrrvnzRGKpfW3Ceyuh1bXP7Q9wcdnPn3VFj7192cEoY757QUf49pzePlhgMxuUnTOmwX5yEtMzyP9iOmvj98h01S7iUOfznMN7fiqFxghviC0qiJdXtY3Rmy7LqdrSiUORQaWevGeUrbtumw8O4QFpBXIOAmoeowI7qtYKbZeyIDyAhXuBfHxgbgrS+iicF8pfqbeCcSFqgfvpacA8etrkDR+r/1El/YjvHDlN1luFZp3dVX7VvfIUhot84XuCxVZw8HAnSJkV0HJqUneAyiq8UW2cf1Z+yiEBNmKrboMDHcx3M0k40N0nyG0U0S1A6iJAsr6GQ4lvbB4pyE4xa5jh0kRVKE8O/BeJ0mSXLWTinYfCiIDCSpzhb9M8bWofYAWtIHAg541EUzCMGxEmL5duuAsF2+gSmOfkmHvo9LzEZhgYTlwwRIcH+7RJnUOUdzJZPAuJH0LsWi416VlXJ7mgctt4XYuQBy35ER6d+oe8whXIp/wegKxZ0qC7SUt/5seZI1RRcvn2pYRFRhBXgdjQPZpO0+wo41JqdMR3a1f6FchzJU/med4CFh85dcOP0dVmEnoCI78sg2oa6ym51toLldM3Phu7nMClSCayDo4fbm6x+LryniyedUD5VDa5wvGEGC7FSyPqk0az9lJ4psrtmSmUDMK4R61hhbhF92PNVgAnqLDhRseZTQ2NyQkyKf51LNEJpSH0EUJ5bnSW/NgufTl9UWFOMxmCpscFvmGPO9wvcfA9jO7lNgMuHoIyYdk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   aceb0f48c0c648f4677bef10dc13f96c49ab4587
commit: 9bb6be995614ed83f0ecddee3c48a706ac2587a0 [53/56] kho-add-support-for-preserving-vmalloc-allocations-fix
config: arm64-randconfig-003-20250921 (https://download.01.org/0day-ci/archive/20250921/202509211055.qaTxLxQS-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project efd96afedf2c0f6f2cc34cf5a9a7e3e78f592255)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250921/202509211055.qaTxLxQS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509211055.qaTxLxQS-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/kexec_handover.c:934:26: error: too few arguments to function call, expected 2, have 1
     934 |                                 kho_restore_page(phys);
         |                                 ~~~~~~~~~~~~~~~~     ^
   kernel/kexec_handover.c:214:13: note: 'kho_restore_page' declared here
     214 | static void kho_restore_page(struct page *page, unsigned int order)
         |             ^                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/kexec_handover.c:942:38: error: too few arguments to function call, expected 2, have 1
     942 |                 kho_restore_page(page_to_phys(page));
         |                 ~~~~~~~~~~~~~~~~                   ^
   kernel/kexec_handover.c:214:13: note: 'kho_restore_page' declared here
     214 | static void kho_restore_page(struct page *page, unsigned int order)
         |             ^                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   2 errors generated.


vim +934 kernel/kexec_handover.c

   890	
   891	/**
   892	 * kho_restore_vmalloc - recreates and populates an area in vmalloc address
   893	 * space from the preserved memory.
   894	 * @preservation: preservation metadata.
   895	 *
   896	 * Recreates an area in vmalloc address space and populates it with memory that
   897	 * was preserved using kho_preserve_vmalloc().
   898	 *
   899	 * Return: pointer to the area in the vmalloc address space, NULL on failure.
   900	 */
   901	void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
   902	{
   903		struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
   904		unsigned int align, order, shift, vm_flags;
   905		unsigned int idx = 0, nr;
   906		unsigned long addr, size;
   907		struct vm_struct *area;
   908		struct page **pages;
   909		int err;
   910	
   911		vm_flags = kho_flags_to_vmalloc(preservation->flags);
   912		if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
   913			return NULL;
   914	
   915		nr = preservation->total_pages;
   916		pages = kvmalloc_array(nr, sizeof(*pages), GFP_KERNEL);
   917		if (!pages)
   918			return NULL;
   919		order = preservation->order;
   920		shift = PAGE_SHIFT + order;
   921		align = 1 << shift;
   922	
   923		while (chunk) {
   924			struct page *page;
   925	
   926			for (int i = 0; chunk->phys[i]; i++) {
   927				phys_addr_t phys = chunk->phys[i];
   928	
   929				if (idx + (1 << order) > nr)
   930					goto err_free_pages_array;
   931	
   932				for (int j = 0; j < (1 << order); j++) {
   933					page = phys_to_page(phys);
 > 934					kho_restore_page(phys);
   935					pages[idx++] = page;
   936					phys += PAGE_SIZE;
   937				}
   938			}
   939	
   940			page = virt_to_page(chunk);
   941			chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
   942			kho_restore_page(page_to_phys(page));
   943			__free_page(page);
   944		}
   945	
   946		if (idx != nr)
   947			goto err_free_pages_array;
   948	
   949		area = __get_vm_area_node(nr * PAGE_SIZE, align, shift, vm_flags,
   950					  VMALLOC_START, VMALLOC_END, NUMA_NO_NODE,
   951					  GFP_KERNEL, __builtin_return_address(0));
   952		if (!area)
   953			goto err_free_pages_array;
   954	
   955		addr = (unsigned long)area->addr;
   956		size = get_vm_area_size(area);
   957		err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
   958		if (err)
   959			goto err_free_vm_area;
   960	
   961		area->pages = pages;
   962		area->nr_pages = nr;
   963	
   964		return area->addr;
   965	
   966	err_free_vm_area:
   967		free_vm_area(area);
   968	err_free_pages_array:
   969		kvfree(pages);
   970		return NULL;
   971	}
   972	EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
   973	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

