Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A079CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF1E6B0088; Fri, 16 Oct 2026 04:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB61E6B008A; Fri, 16 Oct 2026 04:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB766B008C; Fri, 16 Oct 2026 04:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B15F86B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:25:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ACF121A02E9
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:25:46 +0000 (UTC)
X-FDA: 85327805892.28.8D08B80
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 18C5640007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:25:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WayaYoYi;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792139144;
	b=xNIEdPcFmzdq5aWHJEbbxprv1dXrF7SiqeAKnFXMA8ncpeV8vU7js8y/BjYeH1PLE6WUSR
	VB7riJCd9AfsEmM+Z6uqb/q2//D2uvQrKJ0lHkk8ffum77gFTVu11aOIRPfm1u1x5n21ez
	f2Q24/hZgOXNc2MXUegPGxw1x1Z+hsc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WayaYoYi;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792139144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBsdA28stCeNig7OG1dMSg/VS2DKA7DscfAnfjQ2FdE=;
	b=Tatjd5er/IyzF1NsQEzEyKWRhRhltDomZ6fWZHRSxWymibdDXdzfWbTgzO7xwXmKjIn+UN
	+3XR9CCBlqdd7mOP68MMRncT7GIM5LfiQq8xrKruxXZP2xC9sOPqAiI75tiEvJZ8Juj6Q/
	v6rrwL+KmL79LXtxBA9qjWeZXacPII8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792139144; x=1823675144;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KAfd8tRH2E+vvJpLkFEh63/NAmBOZN4lDvDMX9uzf5s=;
  b=WayaYoYikWtM+tWtoViXW8cAHsaWrtUX8teQYZZ8FoTm1vCQtrQULWKJ
   cWcPDCn2UDb0f77DtebLqi74MJqv4qc11iPTz+84T+j/PZFxhpwgTHtEb
   LzilLRBNE6es3geVYkDFRfZCmFVz+TPfiJ9rFiso4xpTp68EEzOMADtNk
   p2df4cVMj7H1DWG5TjD4jt9O6Za//pOojTZn/1ZcXzSxQPTPoAKoKKM0Q
   w/JCbjgpyEQQY2vk7IwzAIhLr3hEOGcg1v3JUE/YLIKdJtg9sZc14cAdy
   AOpTgxvh43TeKebUuiDJ6jMlmW3YIdsqDSPdYmhkvuWLSzInW5/1X1PrT
   Q==;
X-CSE-ConnectionGUID: n1If6WeKSomrJ2hFXDlNWw==
X-CSE-MsgGUID: Jd0+S70NR/i6Dprnx9tTgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="812312"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="812312"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 01:23:27 -0700
X-CSE-ConnectionGUID: u5J2rt91RgyRRrpNhQby/w==
X-CSE-MsgGUID: kNfHIRW4RAm85ARoSZ/D7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="2143052"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 16 Oct 2026 01:23:20 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHdDg-00000000HtS-105i;
	Fri, 16 Oct 2026 08:23:16 +0000
Date: Fri, 16 Oct 2026 16:23:02 +0800
From: kernel test robot <lkp@intel.com>
To: Sairaj Kodilkar <sarunkod@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <bp@alien8.de>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Kiryl Shutsemau <kas@kernel.org>,
	Li RongQing <lirongqing@baidu.com>, Marco Elver <elver@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v5 7/7] iommu/amd: Provide kernel command line option to
 enable GAPPI
Message-ID: <202610161625.7iSczyVo-lkp@intel.com>
References: <20261015064515.10700-8-sarunkod@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015064515.10700-8-sarunkod@amd.com>
X-Stat-Signature: 9amiywe19x66id8gcne7uk3gotbicuee
X-Rspamd-Queue-Id: 18C5640007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792139143-367768
X-HE-Meta: U2FsdGVkX18pREKtIRpmD0Hni870kN/FBbpbHPnM1XFwPN1mJh+wxTHmjypTgDxowCbFJ9ch+62Zp7Lr63LPFOM4i9BzYLBOlNJpgpZLcuC5LflEkIcwvPbQVRB3gd03ZRPM/mCSvhGieqs8vhzQJRpWK6TFEJCly3pDkDt4UvauCz8xRid1os7UXjTcPYYFUfOGa26GXjaiyX0W8R6/4+P9q4bQMrR7GOGjbRuG1pQ6Wg1lqyk0SbI02Qh1/Nx4xypE0KeIHrt+WPGp11RaNHBvIC7MfYCV7jMqytLSXgQa24mxENBkZDdWISWL1yk3nzeApHQEyzqGsXZH5Qtd/WDbH816QekFeN8PFY8apMlV5yL6ZO2C8UNsvlxMWiaSOFmwi5lFwov/JKH/Keyn6WUXdw+4n5qjqhW/WWezcq0L5yt0z30xegOfwZIsHy9/k6vF3yVax7xMlD75E4xkfn/LgP2PXuLYZqu3k96Bwl+uMcppR0Pb5jbswAKzBi4HJYIxwuJFSRflBxAG4Tadj+3g5lfYEAv+tsAH/Lh5tR34z2Q0OMsf88iKSGC3l5UejhgAb3ieS4TNhieG683k5X4/8gFtyiisWviDXg7Rgt1MvqaxWdsv5zIP5oNBjJ2UPuml4GOqsjGwo75WwozpNa+ymSOpatzaqnt9tZLzPSyXyZAfpIDKn1wJg9rIGqViow9HCF0EVSKCravXdj+sqEPMq1+EvS+MKCuDNyw5XiwY7xahbDEdWgnjMTwL6dXYw+YlpPj+5szQpDqc2CIG6DK0XS/I0bWcuRC8YoCwjnXbT/yfCSiZ4/yEC2XqXen5r8+PE0cUcplT1l54KFtQ3GFPA5VmjeSYePiVI/i1JA3OzFJP4NAJHuUggjNxkPiXVKORNxAbeCraU74f/ghyjwMQ9s8v+nR9uFmltfbksswLp9xymTpmiq/s48hHW6KgvTwnNmxnEsf/ZuaaFiX
 v/ySdNvh
 hMHynd0fqywsQfNlewywAdgiaAbGTsthumRy9u0dcdfZaivbAS8zZLiDhjvaGa/abN4VplFhkf6xDRPoo8jNSH2RbbmEc6/ZlkPnbZFomY444GLOrTzqBd1hSimIOwBwRANmxyeq+wxrbFMAOGhsmtt70yElDdmuF0176gOM5weVHpwoAuETXbAGLuumQlHUZLKNimaKuhpLWzqEvfktipQYo/Av65r9lMc3flz0HNSBCUnaFp+sfzaAdQtrD7iDtYiVDwtxB1Qqc0A7sOb4x0VOJJI/8Tu1nHja6PyMZLi9JoNADct0JY6q9kuEwj+ss18R18V3y11Op1zp7kYJ0XvgDtNWJo++vS8+Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sairaj,

kernel test robot noticed the following build errors:

[auto build test ERROR on 4056b3c9d3c92ea45955641dbafeb9b960e146ef]

url:    https://github.com/intel-lab-lkp/linux/commits/Sairaj-Kodilkar/iommu-amd-KVM-SVM-Rename-cpu-to-apicid-in-IOMMU-interface/20261015-121509
base:   4056b3c9d3c92ea45955641dbafeb9b960e146ef
patch link:    https://lore.kernel.org/r/20261015064515.10700-8-sarunkod%40amd.com
patch subject: [PATCH v5 7/7] iommu/amd: Provide kernel command line option to enable GAPPI
config: x86_64-randconfig-1017-20261016 (https://download.01.org/0day-ci/archive/20261016/202610161625.7iSczyVo-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261016/202610161625.7iSczyVo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610161625.7iSczyVo-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/iommu/amd/init.c:163:6: error: redefinition of 'false' as different kind of symbol
     163 | bool amd_iommu_gappi;
         |      ^
   include/linux/amd-iommu.h:65:25: note: expanded from macro 'amd_iommu_gappi'
      65 | #define amd_iommu_gappi false
         |                         ^
   include/linux/stddef.h:11:2: note: previous definition is here
      11 |         false   = 0,
         |         ^
   drivers/iommu/amd/init.c:164:15: error: redefinition of 'false' as different kind of symbol
     164 | EXPORT_SYMBOL(amd_iommu_gappi);
         |               ^
   include/linux/amd-iommu.h:65:25: note: expanded from macro 'amd_iommu_gappi'
      65 | #define amd_iommu_gappi false
         |                         ^
   include/linux/stddef.h:11:2: note: previous definition is here
      11 |         false   = 0,
         |         ^
   drivers/iommu/amd/init.c:164:1: error: cannot take the address of an rvalue of type 'int'
     164 | EXPORT_SYMBOL(amd_iommu_gappi);
         | ^             ~~~~~~~~~~~~~~~
   include/linux/export.h:89:29: note: expanded from macro 'EXPORT_SYMBOL'
      89 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^              ~~~
   include/linux/export.h:86:38: note: expanded from macro '_EXPORT_SYMBOL'
      86 | #define _EXPORT_SYMBOL(sym, license)    __EXPORT_SYMBOL(sym, license, "")
         |                                         ^               ~~~
   include/linux/export.h:77:2: note: expanded from macro '__EXPORT_SYMBOL'
      77 |         __ADDRESSABLE(sym)                                      \
         |         ^             ~~~
   include/linux/compiler.h:276:2: note: expanded from macro '__ADDRESSABLE'
     276 |         ___ADDRESSABLE(sym, __section(".discard.addressable"))
         |         ^              ~~~
   include/linux/compiler.h:273:63: note: expanded from macro '___ADDRESSABLE'
     273 |         __UNIQUE_ID(__PASTE(addressable_, sym)) = (void *)(uintptr_t)&sym;
         |                                                                      ^~~~
>> drivers/iommu/amd/init.c:3804:20: error: expression is not assignable
    3804 |                         amd_iommu_gappi = true;
         |                         ~~~~~~~~~~~~~~~ ^
   4 errors generated.


vim +3804 drivers/iommu/amd/init.c

  3775	
  3776	static int __init parse_amd_iommu_options(char *str)
  3777	{
  3778		if (!str)
  3779			return -EINVAL;
  3780	
  3781		while (*str) {
  3782			if (strncmp(str, "fullflush", 9) == 0) {
  3783				pr_warn("amd_iommu=fullflush deprecated; use iommu.strict=1 instead\n");
  3784				iommu_set_dma_strict();
  3785			} else if (strncmp(str, "force_enable", 12) == 0) {
  3786				amd_iommu_force_enable = true;
  3787			} else if (strncmp(str, "off", 3) == 0) {
  3788				amd_iommu_disabled = true;
  3789			} else if (strncmp(str, "force_isolation", 15) == 0) {
  3790				amd_iommu_force_isolation = true;
  3791			} else if (strncmp(str, "pgtbl_v1", 8) == 0) {
  3792				amd_iommu_pgtable = PD_MODE_V1;
  3793			} else if (strncmp(str, "pgtbl_v2", 8) == 0) {
  3794				amd_iommu_pgtable = PD_MODE_V2;
  3795			} else if (strncmp(str, "irtcachedis", 11) == 0) {
  3796				amd_iommu_irtcachedis = true;
  3797			} else if (strncmp(str, "nohugepages", 11) == 0) {
  3798				pr_info("Restricting V1 page-sizes to 4KiB");
  3799				amd_iommu_pgsize_bitmap = AMD_IOMMU_PGSIZES_4K;
  3800			} else if (strncmp(str, "v2_pgsizes_only", 15) == 0) {
  3801				pr_info("Restricting V1 page-sizes to 4KiB/2MiB/1GiB");
  3802				amd_iommu_pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
  3803			} else if (strncmp(str, "gappi", 5) == 0) {
> 3804				amd_iommu_gappi = true;
  3805			} else {
  3806				pr_notice("Unknown option - '%s'\n", str);
  3807			}
  3808	
  3809			str += strcspn(str, ",");
  3810			while (*str == ',')
  3811				str++;
  3812		}
  3813	
  3814		return 1;
  3815	}
  3816	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

