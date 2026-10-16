Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A823CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8940C6B008C; Fri, 16 Oct 2026 00:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BDD6B0092; Fri, 16 Oct 2026 00:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759DC6B0098; Fri, 16 Oct 2026 00:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49E396B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:55:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9246F14029F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:55:57 +0000 (UTC)
X-FDA: 85327277154.17.38A2D03
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf20.hostedemail.com (Postfix) with ESMTP id 09AF81C0005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:55:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LERGTXkx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792126555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7OY6SoNqfsY+sngw3BsQ9gzFr7EenDMTFVZDNTfkPE=;
	b=Dn7woeJQ4DzRmSthMgPpfFhy/5Rquo+t+tbRg5zm9k9IWSDC8Zvh4nAY1NPu4vi61RtSs0
	1wC+Uakdak1RW274a5Tst88hLI2lmvVsPJI484a4R1dmwiu2Mwa5DczD09GfqwRMqLNC4b
	fqw7ohUuTrGbV+rvDCBqbbU29ELP11U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LERGTXkx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792126555;
	b=oTmruT80UsWHjrX0Avxa5kwnhgMGhajOmJKiqpyyCrX3Yp6LZ00BIt4/Db/n1FFuw4R/IT
	uNZT2rQ0O/hmoZHITz7b5VuB4f3ABRz56MKa4nnosq+l+JSzbjCndrvyxOV4OAKn1DUF0k
	j3ZzwkYIcU90cW1WCTqI8kuKIaW+iJk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792126555; x=1823662555;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MM1H5CppfKe9TFwEMwX1JK9hEtOIhOo/5H8CuYa9jW8=;
  b=LERGTXkxPy0H+WkADj9k7QbcXXK0IDVBAK5apIxaQC6RyvcHGQ3s3/sT
   BKor/HoUH08CFANr9pooMDPPXCHypFekKeO7XkaQiyK2dXWkO0bf+OsVB
   ALymFTmNGIPEIg3H1suaB7DFocrNsDbrYckEWKqkME0WaQW5364Dns0Ii
   ekQilIZUtliU/kjCET57iMDbxbLbch9nH+ZyiHHyrY7KyalDJ1TwCI2PM
   UWoP1hKa60GaSXsAfHUgDDSZ9UZOOy6yEpggSdMDHWju9BsrmiJDm7aGR
   qjy3uGf9RBmSk/3kCOSR1OXUdy6a5NqY1KdJSNL48WiU/gjELel/ZPy4p
   w==;
X-CSE-ConnectionGUID: k316XoGNS3yR+xTJpkLVtw==
X-CSE-MsgGUID: ymLfQuVWTaeBPBZaMLTEtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="798379"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="798379"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 21:55:53 -0700
X-CSE-ConnectionGUID: YMJcPrrdS6OhA32mx6YObA==
X-CSE-MsgGUID: xpfQAwhUTNmbU4hYwfo8Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="1814166"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 15 Oct 2026 21:55:48 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHZyq-00000000Hcw-0SDE;
	Fri, 16 Oct 2026 04:55:44 +0000
Date: Fri, 16 Oct 2026 12:54:51 +0800
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
Subject: Re: [PATCH v5 4/7] iommu/amd: Program guest-mode IRTEs for GAPPI
 wakeup when IRTE[IsRun] = 0
Message-ID: <202610161241.OoInPYLr-lkp@intel.com>
References: <20261015064515.10700-5-sarunkod@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015064515.10700-5-sarunkod@amd.com>
X-Stat-Signature: rnen6h3omaa35a7fbxg14bxmf7ufxrtz
X-Rspam-User: 
X-Rspamd-Queue-Id: 09AF81C0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1792126554-203240
X-HE-Meta: U2FsdGVkX19YmmfaWdjnmhfYvHCN6gZXLfCsL3rsOsM5ofZ8Y92xIWEeb0dFZGh5MXOF2jE5NMR+8h0O0uy2TPIMZ26S7U1nQkGMrasWYHCv1l3G1PqNURX4/DsA92+zIffEu/VI6O4GM2f/+7hoNuKUH7W5+gftJyJyyFFs9o4CLmlKprMXLJbgE6B+fkN7rCN5tTkEW6hRvfv5TbgihhZKEC56gf2BqYZblrgr/jXo8+1Llp1H9tZ11CJ/SiJP9CQ8mNDivY2Dg9lQW1+V+W6pd/BgZ5WLBqv1S3/4rHGMVGHqaWo7OLffOCR82nx20i/SbAPhBGrb0sE1/6zWL0gKmWDPmZS+JJznWB7BsN9xDke1Tw3jl5482lZBWJ4ETWRC8TfwiWmFbbU3DFdBC6K5eIJY9yhG1l7it6lLQSvTxXHg6yICIIFm4tcEj1lCVnOEWI4YqgGGlE2zPQQwNi8FNxu0xm4O7YrwK4RmfZBXNl9QrWDDpq9Dx7RkwfoVIllExvaiXijcWqr4YJSsJlNrZMA9CUSMCxeZ8dONE9RBstXM2/+/R1rK22+kZYsmrAEGXx7QZ6AJN3ErhbJw3EJemFsumoT9zAUSbH85P96qB0WR8dc5tzObbA9S73Ebv3aqxO0Wsi08ZN9YvJL7zKBTww8VzCVOAfjzaXqKuE1qGINZ5PyWyEjwb+UPOwfVdKKpKZYv2+4XdqmJ0z0Cmylj9LDG4X4jYc+6hEAGQpFvCSbuSWHojg99Wc8DZj+fgdJGnfymauVVv9MSaQgAvG0ADgkafMUle2TykIrZV2yKnj7ckluchR3kPaKVZAcU6ae3EDCr2lPJ/6yGGEHJjyc3IrX/RydikDANBZWBz221lWb71iUVqeyS3KndLI4iwciAF7aOKBuKOnqixtkPrdZNVOkQ2oVvZ/W/yp4oVyn4fb9hyJSh6PXNQT2ZcRlZ5gIHrclY4W4uFWCsDq3
 dLbZlFw9
 1VWt2zmr1NWkaOiMplanZv4Ec4CsZhWfWFfA3nQj7w3qhcxO0cVepDx8x3R605J4TZsSrxRKb37BtnwvZzWkfWRxvKXAU5KNVrkpqMDG2+0t+2PhA7tdAkIh9Px3iFDJLZXfTYp6Z07gHZVSsfucdCSAmJ6YpWBiGuVRyQoeLsNA/JGwvsZ8pepWKkwO8k9lMR35PNgy5YJehZhbuaAdiZeNhjYkVjui+T5PAyKJNpnUbyNMkpXsjyo0CDQ+S5KCK7pxG7grEZFN8tLWjVjJs6cNi4ZzSuea/unCSPj9xVp3vZWU1FP9Asz1T6uSiBmkXjNovNwP36yZPiMVebOn64BioY71JKa/yMLGU
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
patch link:    https://lore.kernel.org/r/20261015064515.10700-5-sarunkod%40amd.com
patch subject: [PATCH v5 4/7] iommu/amd: Program guest-mode IRTEs for GAPPI wakeup when IRTE[IsRun] = 0
config: x86_64-randconfig-1017-20261016 (https://download.01.org/0day-ci/archive/20261016/202610161241.OoInPYLr-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261016/202610161241.OoInPYLr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610161241.OoInPYLr-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/iommu/amd/init.c:163:6: error: redefinition of 'false' as different kind of symbol
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
>> drivers/iommu/amd/init.c:164:1: error: cannot take the address of an rvalue of type 'int'
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
   3 errors generated.


vim +/false +163 drivers/iommu/amd/init.c

   162	
 > 163	bool amd_iommu_gappi;
 > 164	EXPORT_SYMBOL(amd_iommu_gappi);
   165	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

