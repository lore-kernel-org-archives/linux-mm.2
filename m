Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED555CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 07:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4DF8E000D; Fri, 10 Oct 2025 03:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6278E0002; Fri, 10 Oct 2025 03:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294D28E000D; Fri, 10 Oct 2025 03:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14CE88E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 03:49:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF045855AD
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:49:15 +0000 (UTC)
X-FDA: 83981429070.10.B19C01D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E0DE140003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:49:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jmp8Nj20;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760082553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0yBhefqPVlfdaiWs+lWrTKwHncS2FoO8a/JR8uKlUo=;
	b=t6YdGxHVK/kuNCVliFrXkdxaO3Hx8rsZSPMJSzNMDTsuq8QA0XorYJN95tJX1z+K1xeImO
	u4Wwk8sOPUrVVJfTLgPjLlQyoDMZvwdAiUK6MlUYL0wGQwktbqPm7w3pvhiB4QHYYAe1Ca
	s1JuJsVI9GuxOoOIaWSKhe1/aQAW8jI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760082553; a=rsa-sha256;
	cv=none;
	b=KLxdV3r/pyFeLv0wIbJsOh5pFAuLhENuweIlBANzNo/StJLJlIXPbtssFRokmRm+7HO3IY
	1J7wt4ZynqFPOAbUvszcqniecCqOuclucxBWYOXLbE33eBbiC/WOAdXW4racL3ahXY9efP
	iKD6mvnP3tl1cG04Gmbh/cAPiWwEwfw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jmp8Nj20;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760082553; x=1791618553;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WITPA9UX0mo7jnNcZhH/peun2UL7jtO3QDe+jYYMhxE=;
  b=jmp8Nj20C6jBYDyzxnq2ACLcUwa7Z8CxVTxQhI+qrw++xd5/S14aGcco
   4l8S3sttjzIiOFfUkqoHembeWwHJZGekKaPv7qhr5eyOnSNW0L/8QGQ3o
   aYdDFErML3cHfqcHW/BJkb9fOBP7sN+MYMv0jyeNmI+cyEoLZrdyaJ/E6
   d++EXlXVbP0uo8pBuDBT3UuZHVEHq2q7Ltqps+cr+lL8SO3eDBBYnrqp4
   wLsPkcwoMfnCse5bNAqJTDI9WfJ5QxjVqgcLT2K6m1mUBwA/y7TwmlP5u
   2/r4J2/pDUEfguiQnSuVTzF8jpOqRnndsQLxzSWhFv/zQMvmU7uAwQJzm
   A==;
X-CSE-ConnectionGUID: ebSrsyBZTFmXAbjq0cg7xg==
X-CSE-MsgGUID: N+jRGKKNQ0GBot47sO2EZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="64921811"
X-IronPort-AV: E=Sophos;i="6.19,218,1754982000"; 
   d="scan'208";a="64921811"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 00:49:12 -0700
X-CSE-ConnectionGUID: mXA4EAEiTXqigEW2vYLEcw==
X-CSE-MsgGUID: PgyogO0/TP2+AFnJYA+RAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,218,1754982000"; 
   d="scan'208";a="185304299"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 10 Oct 2025 00:49:05 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v77s6-0002Ql-34;
	Fri, 10 Oct 2025 07:49:02 +0000
Date: Fri, 10 Oct 2025 15:48:34 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Lo=EFc?= Molinari <loic.molinari@collabora.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
	=?iso-8859-1?Q?Ma=EDra?= Canal <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Christopher Healy <healych@amazon.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, kernel@collabora.com
Subject: Re: [PATCH v3 02/10] drm/gem: Introduce drm_gem_get_unmapped_area()
 fop
Message-ID: <202510101507.UiRzhiAP-lkp@intel.com>
References: <20251004093054.21388-3-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251004093054.21388-3-loic.molinari@collabora.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 6cz63iosc1ysoskg4j75mxxjn1jpq6n9
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E0DE140003
X-HE-Tag: 1760082552-856578
X-HE-Meta: U2FsdGVkX19e+LmoFftOHHubbjrsflHBELrzXIiJ3jJLzY7jShFMwWNwMfpmwjJDUmZXWwohLSy9eyaEJhMIxczegffOhpKZWGhLUiBd9MOldsoCd+HKlEwYMvenJ43cpM/UPSzCFCbZYxbyX8YgE6W2Aykhpgw6HGNzxcMrcUwyD2r9MgN8tqqgH9/CqqIBR34rm7FS+6fL2efdnbxzLI+ZA2JN/Lw1RBxjmTnTdVgr6tjVF7NXT88BlIczd8L2I8CFV3ZAjZCdqc/AGczDzttlrSMMdmj7CfLGeyZ6YI8faZeNR5Fd3prJ5aNNh6eY/w2tsXZeD5MHtMhS2eJzEXuALUCYT3ot61qFiA5y19C0PECpGaPZwtmlWNZyJw2B6LgNdTjEmdqgsiXEpwVa/iKnLdtuJQwvwxpmKXDTHv/st9NpT+SEuHO5Lq/Xs/rnL7/QMztBZRp0j8l60BgxuSKb6FF51l396Cpzh0Nhcj0psQdVE52/dFAU7VyH1XINFgG+mmVrwHbJKJexxrdgqiay8MEUIXm4U4pjIbNf9OLmLh8Rt/lyT2/Myc/vIsvX+fyBzwrUlamWDB9r1dqRVqTJJb8RobBzcgS/FMb23OOugFTbygKdnDT/et1hWBAw6n+i85b8kleaFpBuqxmfv591SfLBHlsmSfYC9I3FYMz3N433NsvqgOSbV1xKY6My7CFiJDktWySU3PzFN7soE1js81qIc5bovYHw1HRF/nxcAT1bEEAulIPFb2WLbp7cfoTzPmVXfEp7r+bfWXTuRBZ5CxBjsIpv/4pJD8OkbhbKiJF3KkGk9tHTzaq/b1ZifO2Ap+V8iaJ7Pmcz6IcNI6vZJsreu4YBvLyz7I2BPm2VxHQBbanhRC4HufWMJcsxGkagOlBGb9Nhvnh46xEivCBDFLCbZchWKD7ZkksY/YPRY+/X1vuKAdBXDD7aL1C/vhYhTR9aodExtB6T3IY
 rvYNmXeL
 rFP/3DXqzcOzbkVHED9L/+YXoMSMGcKRAU+NCWDe4hYfeKXQ2TdUBcR8Atd0FF59gnOPHJkcKRoEtIWYJNJSsmG+F/COS8MqQ8dZfQNz5aBtn3bNakm7JXHBWTmx1iIx0i01PL3pUplgWmLS0/94Gy+rN+xd0U5+rCXnd2uQK7d11kInY9m8ihFnR/nOtzoaY22dwZ0EFa49TEeCnInwRd3G+RRVGfdpgsV/W4VSjAzxo1XGE/vb5O5rynJc5JCB60DCoEDvFdKcKSk8YPA49OD/UtdojIZ4UDqr8RqOPufgjBbqErHDKvhg2XWaC8dTv+D/7l6zwrt3Pmijd/QHWamJRB/RnUP+Kc/avtGzNhwGAhv7c/DnlLJgCqsavN3VWHXsMkpz7703wgTWcqLG8vJTocfyW+msRbPrcOlRAhnY03WHjub+OUMkriPcnQBYA716UKWuiytMKAMUwej/jdmn+hIx6cU1Aqgn98jDSNeFBX/Gl7S2SJtIpfd12AMzD3EzvrIF+O1YCaZNQZ3bAz871PirasYczibaDS6W/eaownXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loïc,

kernel test robot noticed the following build errors:

[auto build test ERROR on drm-misc/drm-misc-next]
[also build test ERROR on linus/master v6.17 next-20251009]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lo-c-Molinari/drm-shmem-helper-Add-huge-page-fault-handler/20251004-173347
base:   git://anongit.freedesktop.org/drm/drm-misc drm-misc-next
patch link:    https://lore.kernel.org/r/20251004093054.21388-3-loic.molinari%40collabora.com
patch subject: [PATCH v3 02/10] drm/gem: Introduce drm_gem_get_unmapped_area() fop
config: riscv-randconfig-001-20251010 (https://download.01.org/0day-ci/archive/20251010/202510101507.UiRzhiAP-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 39f292ffa13d7ca0d1edff27ac8fd55024bb4d19)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251010/202510101507.UiRzhiAP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510101507.UiRzhiAP-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/gpu/drm/drm_gem.c:28:
   In file included from include/linux/dma-buf.h:16:
   In file included from include/linux/iosys-map.h:10:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:804:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     804 |         insb(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:104:53: note: expanded from macro 'insb'
     104 | #define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from drivers/gpu/drm/drm_gem.c:28:
   In file included from include/linux/dma-buf.h:16:
   In file included from include/linux/iosys-map.h:10:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:812:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     812 |         insw(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:105:53: note: expanded from macro 'insw'
     105 | #define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from drivers/gpu/drm/drm_gem.c:28:
   In file included from include/linux/dma-buf.h:16:
   In file included from include/linux/iosys-map.h:10:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:820:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     820 |         insl(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:106:53: note: expanded from macro 'insl'
     106 | #define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from drivers/gpu/drm/drm_gem.c:28:
   In file included from include/linux/dma-buf.h:16:
   In file included from include/linux/iosys-map.h:10:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:829:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     829 |         outsb(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:118:55: note: expanded from macro 'outsb'
     118 | #define outsb(addr, buffer, count) __outsb(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from drivers/gpu/drm/drm_gem.c:28:
   In file included from include/linux/dma-buf.h:16:
   In file included from include/linux/iosys-map.h:10:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:838:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     838 |         outsw(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:119:55: note: expanded from macro 'outsw'
     119 | #define outsw(addr, buffer, count) __outsw(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from drivers/gpu/drm/drm_gem.c:28:
   In file included from include/linux/dma-buf.h:16:
   In file included from include/linux/iosys-map.h:10:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:847:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     847 |         outsl(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:120:55: note: expanded from macro 'outsl'
     120 | #define outsl(addr, buffer, count) __outsl(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from drivers/gpu/drm/drm_gem.c:28:
   In file included from include/linux/dma-buf.h:16:
   In file included from include/linux/iosys-map.h:10:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:1175:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1175 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
>> drivers/gpu/drm/drm_gem.c:1271:10: error: call to undeclared function 'mm_get_unmapped_area'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1271 |                 return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
         |                        ^
   drivers/gpu/drm/drm_gem.c:1271:10: note: did you mean '__get_unmapped_area'?
   include/linux/mm.h:3337:1: note: '__get_unmapped_area' declared here
    3337 | __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
         | ^
   7 warnings and 1 error generated.


vim +/mm_get_unmapped_area +1271 drivers/gpu/drm/drm_gem.c

  1239	
  1240	/**
  1241	 * drm_gem_get_unmapped_area - get memory mapping region routine for GEM objects
  1242	 * @filp: DRM file pointer
  1243	 * @uaddr: User address hint
  1244	 * @len: Mapping length
  1245	 * @pgoff: Offset (in pages)
  1246	 * @flags: Mapping flags
  1247	 *
  1248	 * If a driver supports GEM object mapping, before ending up in drm_gem_mmap(),
  1249	 * mmap calls on the DRM file descriptor will first try to find a free linear
  1250	 * address space large enough for a mapping. Since GEM objects are backed by
  1251	 * shmem buffers, this should preferably be handled by the shmem virtual memory
  1252	 * filesystem which can appropriately align addresses to huge page sizes when
  1253	 * needed.
  1254	 *
  1255	 * Look up the GEM object based on the offset passed in (vma->vm_pgoff will
  1256	 * contain the fake offset we created) and call shmem_get_unmapped_area() with
  1257	 * the right file pointer.
  1258	 *
  1259	 * If a GEM object is not available at the given offset or if the caller is not
  1260	 * granted access to it, fall back to mm_get_unmapped_area().
  1261	 */
  1262	unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
  1263						unsigned long len, unsigned long pgoff,
  1264						unsigned long flags)
  1265	{
  1266		struct drm_gem_object *obj;
  1267		unsigned long ret;
  1268	
  1269		obj = drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SHIFT);
  1270		if (IS_ERR(obj))
> 1271			return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
  1272						    flags);
  1273	
  1274		ret = shmem_get_unmapped_area(obj->filp, uaddr, len, 0, flags);
  1275	
  1276		drm_gem_object_put(obj);
  1277	
  1278		return ret;
  1279	}
  1280	EXPORT_SYMBOL(drm_gem_get_unmapped_area);
  1281	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

