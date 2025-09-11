Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43412CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 22:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B018E0007; Thu, 11 Sep 2025 18:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4A48E0001; Thu, 11 Sep 2025 18:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C2E8E0007; Thu, 11 Sep 2025 18:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 610DF8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:04:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E50FC0616
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:04:51 +0000 (UTC)
X-FDA: 83878349982.11.7F6F178
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B15F40003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:04:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ir9+5fn3;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757628289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rc+x/iKjeZbU21elOW/kxr5+i9KS1RB4vM2j3+bXOLA=;
	b=n71GjSIN+G3gAp/B/lFQTmojs2QYN1pJnbjq5x9efOBG46+PNyFVzQeJwPODn6asHB81bR
	WNxGaOlvrdSMrqn+Wz1LK1atk5701GtXI5dNV5VjORAPdKsQURsOcNW//2FVT2lf/uWQLE
	r0dN6YkwniIitmO8lJENfB4JBl+inwc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ir9+5fn3;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757628289; a=rsa-sha256;
	cv=none;
	b=I8sgRg5/7Rc4c5gpBnCMRyMercIbLJvmGtlYbrAPxo1BjmSKwB47FouLsV1l5boOhWy9uQ
	+tfwAmjMplrtDy0GWuu/umyWwNx9wpxb5VuywJMpDdvOyvUXkNNe2lEHGaaAIupoj1/jsF
	LihguIadbb3NDRriHg8M46ml82EOUts=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757628288; x=1789164288;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=oQPPXco+jFT9WyxzhmIkmfnzcqYogRZTYyzvQyks5lA=;
  b=Ir9+5fn3cfMz2v8/KsJi/AMK+MyD1LaKzWwhhh+DJ8f59ROuq3Gq4TyF
   rimMDmooQ8jlub//MECExksyv5Kg7S5VKEe+ObmigWfZtGc8RwUGTrzaV
   GCRU8/TfQbQ8Vng5WtcxGl+dtpGlPK5zd/74ei4/9pvu6AAqxODfm/996
   JlQ6GNGucmBVPx4QIEdwwW9KDoXcTOYqh7P4BgEiMeHKLev/Lc7REGTqF
   O3NtRU8QuQ4u8aTgYnB3qXqp5j6DJiD+4O7UoJ8CQo1NByfalr0pRqX0d
   75nZn/Bpi5H5VmR7YvDEjLqSuG/RaoaEYA7u8YsA2fnaVBmdfxTONQNOb
   A==;
X-CSE-ConnectionGUID: 4lMzP0NeQ/CkZgK8q4Dq7Q==
X-CSE-MsgGUID: OAhITthaQVGd92Ow/i0Hyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="59910277"
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="59910277"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 15:04:47 -0700
X-CSE-ConnectionGUID: HZdXRXlVTaiTT4J7/lsFHA==
X-CSE-MsgGUID: RnQ/MUw0TbuIvYEex13tew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="172983123"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 11 Sep 2025 15:04:45 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwpPH-0000fS-1C;
	Thu, 11 Sep 2025 22:04:43 +0000
Date: Fri, 12 Sep 2025 06:04:19 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 422/440] arch/sparc/include/asm/pgtable_32.h:423:9:
 error: implicit declaration of function 'remap_pfn_range_prepare'; did you
 mean 'io_remap_pfn_range_prepare'?
Message-ID: <202509120538.KccGKzFg-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: rufrr3h1k8fbps4jptr4r6mijggry7pg
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B15F40003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757628288-930911
X-HE-Meta: U2FsdGVkX1/70qYAONq9LJxFMzGfZX/YcEgI8X7bHKBVYMaK1+Xlj+3avLjRYFA5ZQDqEcUkX/dZb16VMuDXzcDZX+zFp06K5mDKkh/8S+e4ij9xMDJjfdWtRbj3wEijr5q6iFofMVfgCu9qoJJW0XoxVVcYMej13FON6j3tiggTjSoEfOJ8I5c8hdsxboYp4LyHU6C0qGNruAP3CccKlzXtZOJB8qHj5Act0vowA3TLBtqJ0ENs0xopJsF+0praixI9u8x1z8/WIJb3OeqMw9rMTnjix09+/bDIo9AormShNOlCb8hbsEjR//VpisDiySYLnZqdvViZ9F4L/qHTO/o4mx57zGp2VvFX6I+Wmt79n8JZScCbce8yTk/lwEVaSpmjIb8NVM6XIxrMwn8ggz3JMqHDA8QNWfCxvC5MyO1jqND7oL4oBUbdCFESsKfIHfAyl7A1A8YbR7kmJvmWAR98PePqJQeYUdWwiYk1ySIlKf0Fpn5VE9DsIRMVuo1hIJQ8rt1bkPTgFAL5S8W/p70fjdo8MuBoOj5n6BGlKY6InAxyECwhiKL3ZZeVV5CAX/wyNTPWuInqCp0LyCgWaRIRR5fgBzOCLWdiafa2clUPUhJUdokpleslW2X96f6wQ87pHS6Ys8tGckvXQgaK/109kDwFN7ycXLjfOqPwkOv7/pF19I4zcN6a6BYC+jWrzp6e2CHXSWzxWDjvef20zA7EzyGm+12sfQ3b526ZNMMtkBd/8dnBjY1Ksw3Ycudu8qMkF4RVD2r4hCP7y16vYJT6wFb94MgApYmqqOHvOM/vz67oNmb5lop6f3rfnPGUrkdMUBw7sTF6QvyUE7dkEncOdQIbaPv1cUdfeU4oCeBb0ZxG6JCnbtPlFItm1hdIx74H7EBrWzB3ZrUIaf3RB3Wqx+jIQQJBYWl5zLDnsqiFwx9c7jcd1txVFa9OulTwh39iIdCJJhLslVfXVz0
 NF8hIwvJ
 hzQkuPmrTF+458/asb+vgjc0h69+iD/xzKdJBnKtvSVGmweIursWxD5yIoQG2P0XnZPx7DhN4nnwwyinNGqjrM2PTyQazHdnfVxm93NrfjXArYxUAMr3EY39ZHMhOrlXmW+wo/Sx0lVdGEqBcHFypliUNeZ9yP6UYnKMEaSuyM1MW3iAVtdIVogv5JnVQKMLpTS8j75L01fvlGneD6Qzxwg0ZN4LntGaig743AJ90Sw/vI4ZYFOWdcfmNCRzvG5YzwitVOOj66/maiGDbGv6Vi+pvRN2oE+GVV9THZ+FlJZqozOtfmqOb1RxFXBcNYWYleCD8UfmOxgOnLQ3PxHUMQfevBVEh+fmSoy5GiavIwMVazGDq00axmODdwB4msu0uW4P6GWM/uhwEDc0majFmUBOQTqmDYaLskvf0TEChUjHRh72rt9/Ku6SN3N2QFN+gH25q3C1OePXJOpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   31690ac95cb30fd036eeda36844c6e2820685e7c
commit: 04ff8d62985b8be5f5fc8547a828fbb051c2f927 [422/440] mm: introduce io_remap_pfn_range_[prepare, complete]()
config: sparc-allnoconfig (https://download.01.org/0day-ci/archive/20250912/202509120538.KccGKzFg-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250912/202509120538.KccGKzFg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509120538.KccGKzFg-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/sparc/include/asm/pgtable.h:7,
                    from arch/sparc/include/asm/viking.h:13,
                    from arch/sparc/include/asm/mbus.h:12,
                    from arch/sparc/include/asm/elf_32.h:94,
                    from arch/sparc/include/asm/elf.h:7,
                    from include/linux/elf.h:6,
                    from include/linux/module.h:20,
                    from init/main.c:18:
   arch/sparc/include/asm/pgtable_32.h: In function 'io_remap_pfn_range_prepare':
>> arch/sparc/include/asm/pgtable_32.h:423:9: error: implicit declaration of function 'remap_pfn_range_prepare'; did you mean 'io_remap_pfn_range_prepare'? [-Wimplicit-function-declaration]
     423 |         remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
         |         ^~~~~~~~~~~~~~~~~~~~~~~
         |         io_remap_pfn_range_prepare
   arch/sparc/include/asm/pgtable_32.h: In function 'io_remap_pfn_range_complete':
>> arch/sparc/include/asm/pgtable_32.h:431:16: error: implicit declaration of function 'remap_pfn_range_complete'; did you mean 'io_remap_pfn_range_complete'? [-Wimplicit-function-declaration]
     431 |         return remap_pfn_range_complete(vma, addr, calc_io_remap_pfn(pfn),
         |                ^~~~~~~~~~~~~~~~~~~~~~~~
         |                io_remap_pfn_range_complete
   In file included from include/linux/ring_buffer.h:5,
                    from include/linux/trace_events.h:6,
                    from include/trace/syscall.h:7,
                    from include/linux/syscalls.h:95,
                    from init/main.c:22:
   include/linux/mm.h: At top level:
   include/linux/mm.h:3643:6: warning: conflicting types for 'remap_pfn_range_prepare'; have 'void(struct vm_area_desc *, long unsigned int)'
    3643 | void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
         |      ^~~~~~~~~~~~~~~~~~~~~~~
   arch/sparc/include/asm/pgtable_32.h:423:9: note: previous implicit declaration of 'remap_pfn_range_prepare' with type 'void(struct vm_area_desc *, long unsigned int)'
     423 |         remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
         |         ^~~~~~~~~~~~~~~~~~~~~~~


vim +423 arch/sparc/include/asm/pgtable_32.h

   419	
   420	static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
   421			unsigned long size)
   422	{
 > 423		remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
   424	}
   425	#define io_remap_pfn_range_prepare io_remap_pfn_range_prepare
   426	
   427	static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
   428			unsigned long addr, unsigned long pfn, unsigned long size,
   429			pgprot_t prot)
   430	{
 > 431		return remap_pfn_range_complete(vma, addr, calc_io_remap_pfn(pfn),
   432				size, prot);
   433	}
   434	#define io_remap_pfn_range_complete io_remap_pfn_range_complete
   435	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

