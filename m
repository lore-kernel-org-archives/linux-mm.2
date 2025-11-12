Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA19FCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B1F8E0013; Wed, 12 Nov 2025 06:57:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCC38E0003; Wed, 12 Nov 2025 06:57:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5398E0013; Wed, 12 Nov 2025 06:57:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5C918E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:57:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8191A160499
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:57:54 +0000 (UTC)
X-FDA: 84101806068.27.25D8A5D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 047842000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:57:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D3p63S5K;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762948672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WDSSxZjs8DKPPMOAfrHCyNR4Y0PAaFopW6COdasC+9k=;
	b=n4J/aVgCG9Ojxm6Lc71T92BM5bGyD2UVoTmbaUC9F0UQZH5TId0ue9b37JLiTt+6YADD4D
	woq7NrwgJxsqMVHn9tCgysSV1CVSg/oJnbtI5H3DCGAnzbDhnZGMo4oS7J2Uix456BKDRG
	EenxytvO4aovgvHdqrIcjQLAe4R2b0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762948672; a=rsa-sha256;
	cv=none;
	b=ghkxPqlEbTeWZkmzs0EaV5UZCc2vXgX3KtL2NzzeYpuHUHAgI3akbhFSKsNuSNRnz3wYtS
	D0TWWRw/6Vi/+pcltu5AwGYe+cFBKjhVzPdPiq8fCor0jKCehnt8j5MnxFp00XGmVgfsF2
	TeiAMlDblZ108EEU+PCw1VCMSEPa+WY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D3p63S5K;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762948672; x=1794484672;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=SqWLNFidTU/ZZAY/wKmL0pzzMf5lBnZV1EJFPqQvE8Y=;
  b=D3p63S5KZc/mbsZwsgPKXQV2fO1bIddVwkUg86M/v4RXJEJ//xTHQIPg
   x1AGeA6g06O1jGNG4Qrc+2GZ63boXc+yauAm1TDlCSQLqwUewK311NIEe
   ++xqvKcIfm+P/NjgeEdYBaCxYpPIRTUyvi1y9XRqbshaeLK6Mn+Sa0npF
   5x4GjYdpAsz0jOi0ALuo7fwnPdSxOM2Qlwy76a4wxK5A7AILiHtHeDm21
   E42tGy7nawIY9z7DGvwoJkNKJt+B+a3/LGsTDgkN/UAn2vyi5RFLmCO15
   t1ggNBob9LAH6eLFYtlsTSvRgM545jthLBxMi1nL4hcTBrXlqdnQM/y4H
   w==;
X-CSE-ConnectionGUID: GpatjOXnR7WCU7cbu2sNIA==
X-CSE-MsgGUID: R34cSZZSQD2eEtj40kX5gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="75623075"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="75623075"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 03:57:51 -0800
X-CSE-ConnectionGUID: 1/U9Hc9oRAucoYmfJ4f4XQ==
X-CSE-MsgGUID: nz00ygZCTHKQhdyuZoeCIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="189929194"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Nov 2025 03:57:49 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJ9Tv-0004CV-0w;
	Wed, 12 Nov 2025 11:57:47 +0000
Date: Wed, 12 Nov 2025 19:57:23 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 6752/7613]
 drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse: sparse: incorrect
 type in assignment (different base types)
Message-ID: <202511121922.oP20Lzb8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 047842000C
X-Stat-Signature: gz3hqcb4npjpy76hrae88t3stpfwrt8j
X-HE-Tag: 1762948671-160720
X-HE-Meta: U2FsdGVkX18LwjwdhVBK2LrKMAZM49nwEwtDp/gSfSmn9N8x+3nD7IuyHkP4cHRwslxuWMOUSA4JVTga6TrmQiprGk1ai31JT1SW+XCeeqvnR6APqvo1x+H/56fWpcrKpcOzVtmH7SqRwVeHg+JfQlJhAf48YofdGIoo7X6on0a2eSMzESJaOy/Y60tazeM8mAj3aZPnTRVnDWeWYERH7uQC+QgPDlmuu+q8c1KawXJ0De04NZUb9idAu5CK7fab+a57w1fzH7lknD2jL/+jN9Hpxeg74LMRo2Xl7u2dxy8Ae5sB9mZE8gN3PeL7Fw5JhxAofgcSD2S4yDX+1nd9rl7DwMXf2jamLeK19y8fzps0XLHu8z/p/vz1o+s5TK4ebMbBS6TDUFJ9/f75KDMPQMzq17se9kaTJTLsc34Of76JA/DL1yxUoo86c473EUMMytJYEwDGpRrR4cGkD1KypWM8XdSKoErgD15WojPBU6DcncxDFz3A9n0YepwRPSAhntCAPfdNJtFLPaf8lJguYRziUJKzvGHjmPLxwUEDyjgYo+6qNDdTGRtdOMzgzBHhLrZpwu8OR4vYf4GPFZk0k/bMxPYDXUYOI+aZqLhAjSuqO2H4x7L7tzMthI/IMWr6gKDsyH/FCG9mJfZBqlj7F23pn49a1rsfA0HSzbmYD7K96up99HIBc+i6XvW0LP1vOGy1ztPkcKR0roQMiinyJvh0OHD36e0H3keGWw9mI3BekEmvNfXcGc2BDsi+MPXhYdb/VabJzqNMO9nSilLP0kc4Wd5jBp4MVdJuByMDOmc97/Eiv468GaX5kF6Ju8niUF4svbK4lj/9uUmpixIgQD15VRoPb88HxG4OUiICifbVtmFJccweUiO2QXYfUTlBM2y5bvvEI/pRcF31eAlZAMXDH+I1f76CF1TfXlVZS9dQryPpH2Z40KiHI5hrLEp4f6xRn7ytEIXw885KQA2
 3wwlFRxV
 ybEJMGuCe0lhmTulXHd27K+yeWiJX9nzB9+YRv6VeaVhxAsBjS4cBA3hOlXfr0PVYVcI50R/SGjwjDLZ4bLrpU7jIT7AS3Kp+IeZj2HI+OYQAubcF3VhJ2tNdb6TdIsvVLvMjwSdz3Oh4UPhIJ/U23TixO+zQTxIvNkX6p3/1BAi/tp6GgMHz2iFyVxDx6nXxfYFjn9OWHmPy/MNLM1FfAmuIffeECZrL7kp+cWfr8zvMdC6OaG0DjebmtY65QemfEvEyzuC1UVWV2TdqW9SrdHrsEy4Or+Qzh4DBmXv81c6LWT/UZBzpGkFnsOGkfnRkN46yYKU5qaYLbwr58BSMy5yvNOoRDlSVhX3x1+CeBV7YDexhr/298AjHCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   b179ce312bafcb8c68dc718e015aee79b7939ff0
commit: d3b4177bcf978a441cf98b7515d043eb23728194 [6752/7613] gpu/drm/nouveau: enable THP support for GPU memory migration
config: x86_64-randconfig-121-20251112 (https://download.01.org/0day-ci/archive/20251112/202511121922.oP20Lzb8-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251112/202511121922.oP20Lzb8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   drivers/gpu/drm/nouveau/nouveau_dmem.c: note: in included file (through drivers/gpu/drm/nouveau/nouveau_drv.h):
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:9:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:10:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:11:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:12:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:13:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:14:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:17:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:18:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:20:1: sparse: sparse: directive in macro's argument list
   drivers/gpu/drm/nouveau/include/nvif/ioctl.h:21:1: sparse: sparse: directive in macro's argument list
>> drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got int @@
   drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
   drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse:     got int

vim +259 drivers/gpu/drm/nouveau/nouveau_dmem.c

   182	
   183	static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
   184	{
   185		struct nouveau_drm *drm = page_to_drm(vmf->page);
   186		struct nouveau_dmem *dmem = drm->dmem;
   187		struct nouveau_fence *fence;
   188		struct nouveau_svmm *svmm;
   189		struct page *dpage;
   190		vm_fault_t ret = 0;
   191		struct migrate_vma args = {
   192			.vma		= vmf->vma,
   193			.pgmap_owner	= drm->dev,
   194			.fault_page	= vmf->page,
   195			.flags		= MIGRATE_VMA_SELECT_DEVICE_PRIVATE |
   196					  MIGRATE_VMA_SELECT_COMPOUND,
   197			.src = NULL,
   198			.dst = NULL,
   199		};
   200		unsigned int order, nr;
   201		struct folio *sfolio, *dfolio;
   202		struct nouveau_dmem_dma_info dma_info;
   203	
   204		sfolio = page_folio(vmf->page);
   205		order = folio_order(sfolio);
   206		nr = 1 << order;
   207	
   208		/*
   209		 * Handle partial unmap faults, where the folio is large, but
   210		 * the pmd is split.
   211		 */
   212		if (vmf->pte) {
   213			order = 0;
   214			nr = 1;
   215		}
   216	
   217		if (order)
   218			args.flags |= MIGRATE_VMA_SELECT_COMPOUND;
   219	
   220		args.start = ALIGN_DOWN(vmf->address, (PAGE_SIZE << order));
   221		args.vma = vmf->vma;
   222		args.end = args.start + (PAGE_SIZE << order);
   223		args.src = kcalloc(nr, sizeof(*args.src), GFP_KERNEL);
   224		args.dst = kcalloc(nr, sizeof(*args.dst), GFP_KERNEL);
   225	
   226		if (!args.src || !args.dst) {
   227			ret = VM_FAULT_OOM;
   228			goto err;
   229		}
   230		/*
   231		 * FIXME what we really want is to find some heuristic to migrate more
   232		 * than just one page on CPU fault. When such fault happens it is very
   233		 * likely that more surrounding page will CPU fault too.
   234		 */
   235		if (migrate_vma_setup(&args) < 0)
   236			return VM_FAULT_SIGBUS;
   237		if (!args.cpages)
   238			return 0;
   239	
   240		if (order)
   241			dpage = folio_page(vma_alloc_folio(GFP_HIGHUSER | __GFP_ZERO,
   242						order, vmf->vma, vmf->address), 0);
   243		else
   244			dpage = alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vmf->vma,
   245						vmf->address);
   246		if (!dpage) {
   247			ret = VM_FAULT_OOM;
   248			goto done;
   249		}
   250	
   251		args.dst[0] = migrate_pfn(page_to_pfn(dpage));
   252		if (order)
   253			args.dst[0] |= MIGRATE_PFN_COMPOUND;
   254		dfolio = page_folio(dpage);
   255	
   256		svmm = folio_zone_device_data(sfolio);
   257		mutex_lock(&svmm->mutex);
   258		nouveau_svmm_invalidate(svmm, args.start, args.end);
 > 259		ret = nouveau_dmem_copy_folio(drm, sfolio, dfolio, &dma_info);
   260		mutex_unlock(&svmm->mutex);
   261		if (ret) {
   262			ret = VM_FAULT_SIGBUS;
   263			goto done;
   264		}
   265	
   266		nouveau_fence_new(&fence, dmem->migrate.chan);
   267		migrate_vma_pages(&args);
   268		nouveau_dmem_fence_done(&fence);
   269		dma_unmap_page(drm->dev->dev, dma_info.dma_addr, PAGE_SIZE,
   270					DMA_BIDIRECTIONAL);
   271	done:
   272		migrate_vma_finalize(&args);
   273	err:
   274		kfree(args.src);
   275		kfree(args.dst);
   276		return ret;
   277	}
   278	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

