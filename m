Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AF6CA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 19:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0E3D900023; Tue, 12 Aug 2025 15:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6048E0151; Tue, 12 Aug 2025 15:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2325900023; Tue, 12 Aug 2025 15:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2D598E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:19:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90AA1B6910
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 19:19:29 +0000 (UTC)
X-FDA: 83769069258.04.BE8F600
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92200140007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 19:19:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KLrKe92X;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755026367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7tmZm/Gzul0Eqa7tJ99LUw4Fw8ETTapvSPmBB9EBHnA=;
	b=VpoZgl7fFO2WmCXIYz1+qTFSf8ngmAFk4gd5da+Rrtfudb+lYMxx6lFqsuo6hPQxM/jIyV
	Hrmjn9Qh478zXCh6frKtVsprHIi3qX7JB/xOJlUjHUoNWBEJvFPNqGa5NRe6H8/7BmE82S
	qbA8fWAkgsMngnTk2GJnE80g64pNvgU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KLrKe92X;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755026367; a=rsa-sha256;
	cv=none;
	b=qoDGEjGRKgM16vm+qgOhPSvlb5VQBIdikvXH7YXnotZRnz+5ffRbrXwkrfTDAwb3ohNHzZ
	LlVHGV1wGguYcepMM9F1GScfrKF4s0s+bd7hTdcU96guZMteE41us2lysIrCWgUnbLOKAa
	O0cf1BoDWL8t6AL8p2OmVATy69xSzf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755026366; x=1786562366;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=AI4AXv8xWUmSxBoBjpDgRZHIow4jmjUto7XtO84gmZI=;
  b=KLrKe92XM3+y2Pg3qJStQmcQ0qtOFggGIpRT7u8NTFRGEHnTysqPhepU
   s6asNoE/PKFmzV6Auzru66KyYj/Xu81T+CxIxj392PKZIZPeesVnCJ7TU
   Nq2he1PzmVOBJ7TudSUfOQvD1EZWSkzPVimFKHx9sTxe2QtI+Vmid5Xwi
   Z6EmbIxcmvmogNSIySC0MS/ikoOWQGYP5CaYX9W1K8J0Z/wcjgcGUAaP/
   Ph31vXWOsW2uOPN2fzdUCYo/6eMuy/7bPXga739/LuXsCMFrryOG7yb4a
   uOxKWwC7hUzW8nwP1rQKoICsOffzyYvLBJIxcexrPJflPvVXPJYtM2x3a
   w==;
X-CSE-ConnectionGUID: IOiKrFaEQMWBLxYloMIrZA==
X-CSE-MsgGUID: DGXdusdmTbWfIuJx37+kow==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="56522156"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="56522156"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 12:19:25 -0700
X-CSE-ConnectionGUID: RiX52RMhSFSOjoBGYQ+MwA==
X-CSE-MsgGUID: LOLf/Ur7SZidYyNAp85e2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="170408956"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 12 Aug 2025 12:19:23 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uluWn-00090k-1M;
	Tue, 12 Aug 2025 19:19:21 +0000
Date: Wed, 13 Aug 2025 03:18:33 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 101/118] arch/powerpc/mm/ptdump/shared.c:70:1:
 error: use of 'pgtable_level' with tag type that does not match previous
 declaration
Message-ID: <202508130304.5FJqRz2c-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: mi35brgo7tsch17ndwzb4kthinq46oo6
X-Rspam-User: 
X-Rspamd-Queue-Id: 92200140007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755026366-366847
X-HE-Meta: U2FsdGVkX1/RwrycIyp+VF3qh7eoYIeZS/he+wFEPo2bZocfJ+bTBUTB7xdux/4xZ1NPp2qgQ5NaJ0Fto/fIduibTY4kA6c3zV3W8XryqJSES2awfQiu8x2U2uWbaNZgzeZ2g9PrysPNcNWzw6p/+OtdWjtuYZLH5cjYCcfJc2MHA1j/LtcvwsPRW+TY+tumsdeAa7Fn/h8u3fJvlxdgoBC8MB5MT3NPUI4Wc53nbl3ROMwlg4OUV8AphVNwsED9/IiDryjaqGbujqFFe1F34kVwTiflL4Eqo6ktdfCK+WIvUzxOTOVrLGrALq0ILRdH89QGixzMF/4XHY8W+StwvIaX2fhBwfMOio2niAApB39fsYwmG0+3gGx1e+RwJsOMMcareZRJGaPnqDRH319XBdbT/+bqTEYJSM5OKY4xCkQyu0+Q1f5lYZBzEKYAM6cYsupRXz4V0JJQsMFPc9ml49sX8wa/SEQK3UahtXI+pEQg0O35BQpZoF4XB7AcFXTc2fI6NmQd8ZgMooBmJsfqehDZC32Lv1flm6A13UTLrYt5zG+Vpba12pDNW6lrlen+cY8lKjxFm71Q0LiI51BOzb4NyVec3ow87KaFelOj7ka0S9+IW4+SLNFwTasz3VAsUXxeMwd2vaISFkZyxmp6ydB5v+myQ1bWdH5mpAZV7phOt3XqyAgnKaA14vM688D2j0Y6lYVcQUoMCt42xPMpXUMJD3mZbybH0ZrTRm1pbPupM74YVXL25syLpaRaUrduleI4uNByvBpi3wRf4mOxr8q/Q/YECjOdvsNG5pnSmmqqRsCPpING7XZsu1YB9Vk55zWmYgpUuW8I1g7rzrfHJrkVKM8oBgBCjeXbLfJgmC7mRVumAjm8Jc1WtmQud/0rPEg312w8hNhaKs5i8BCoM9R27dk1t3tfXZ8KHJAE30wsjJ1FMMkPLTyuFK+6EbOaXXehYNjfbfhVHTsYS5b
 HNXkeyT6
 8g0iu6Y8HGNzHQUeHpQ8y1c+iZ3BaMyBVTwMM3AHhBhTHT1T942eDEFjsT+yn7qD+IqcN3cAV1lau1nttiZVHoza6hChKOH8UwicJe5Ae7QekJV8wu57r8hyH215NZ/9IeN4XeWfuIG8Dswto7nl8V9oJF58TtG5XgzVBliMZfMf640k9qSTZ0MPbHX4wWKnHUwDTNzXZfXRKKnQPqJ/2kdvVB1vSHY8Az+tIWrfrwjrTlLp7ljYxz4U/BNAPy5QnSZUUUClmstxC93u3QvhnBs0JQckq17cMaGilJPWyNc6NVvE5epNAjAFjB9iKFvqr1E0IALpJQ+LHGUyfjP3DzN2UTLfuRfZxSDMZWPTeBt7gEe7LXoGJ4aEScA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   33ad02f876604ac2990e510480b0ab3a03cf892e
commit: 627bf62489a6d9a45f6d6f83edd0cb6c0ee610c0 [101/118] mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
config: powerpc-randconfig-001-20250812 (https://download.01.org/0day-ci/archive/20250813/202508130304.5FJqRz2c-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250813/202508130304.5FJqRz2c-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508130304.5FJqRz2c-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/powerpc/mm/ptdump/shared.c:10:
   arch/powerpc/mm/ptdump/ptdump.h:14:1: error: use of 'pgtable_level' with tag type that does not match previous declaration
      14 | struct pgtable_level {
         | ^
   include/linux/pgtable.h:1961:6: note: previous use is here
    1961 | enum pgtable_level {
         |      ^
   In file included from arch/powerpc/mm/ptdump/shared.c:10:
   arch/powerpc/mm/ptdump/ptdump.h:20:8: error: use of 'pgtable_level' with tag type that does not match previous declaration
      20 | extern struct pgtable_level pg_level[5];
         |        ^
   include/linux/pgtable.h:1961:6: note: previous use is here
    1961 | enum pgtable_level {
         |      ^
>> arch/powerpc/mm/ptdump/shared.c:70:1: error: use of 'pgtable_level' with tag type that does not match previous declaration
      70 | struct pgtable_level pg_level[5] = {
         | ^
   include/linux/pgtable.h:1961:6: note: previous use is here
    1961 | enum pgtable_level {
         |      ^
   3 errors generated.


vim +/pgtable_level +70 arch/powerpc/mm/ptdump/shared.c

97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09   9  
e66c3209c7fd17 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2019-02-18 @10  #include "ptdump.h"
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  11  
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  12  static const struct flag_info flag_array[] = {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  13  	{
ceaba662c06598 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2023-09-25  14  		.mask	= _PAGE_READ,
dd8de84b57b02b arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2022-06-28  15  		.val	= 0,
ceaba662c06598 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2023-09-25  16  		.set	= " ",
ceaba662c06598 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2023-09-25  17  		.clear	= "r",
ceaba662c06598 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2023-09-25  18  	}, {
ceaba662c06598 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2023-09-25  19  		.mask	= _PAGE_WRITE,
ceaba662c06598 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2023-09-25  20  		.val	= 0,
ceaba662c06598 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2023-09-25  21  		.set	= " ",
ceaba662c06598 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2023-09-25  22  		.clear	= "w",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  23  	}, {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  24  		.mask	= _PAGE_EXEC,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  25  		.val	= _PAGE_EXEC,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  26  		.set	= " X ",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  27  		.clear	= "   ",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  28  	}, {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  29  		.mask	= _PAGE_PRESENT,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  30  		.val	= _PAGE_PRESENT,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  31  		.set	= "present",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  32  		.clear	= "       ",
3af4786eb429b2 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2020-05-19  33  	}, {
3af4786eb429b2 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2020-05-19  34  		.mask	= _PAGE_COHERENT,
3af4786eb429b2 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2020-05-19  35  		.val	= _PAGE_COHERENT,
3af4786eb429b2 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2020-05-19  36  		.set	= "coherent",
3af4786eb429b2 arch/powerpc/mm/ptdump/shared.c                Christophe Leroy 2020-05-19  37  		.clear	= "        ",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  38  	}, {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  39  		.mask	= _PAGE_GUARDED,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  40  		.val	= _PAGE_GUARDED,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  41  		.set	= "guarded",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  42  		.clear	= "       ",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  43  	}, {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  44  		.mask	= _PAGE_DIRTY,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  45  		.val	= _PAGE_DIRTY,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  46  		.set	= "dirty",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  47  		.clear	= "     ",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  48  	}, {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  49  		.mask	= _PAGE_ACCESSED,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  50  		.val	= _PAGE_ACCESSED,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  51  		.set	= "accessed",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  52  		.clear	= "        ",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  53  	}, {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  54  		.mask	= _PAGE_WRITETHRU,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  55  		.val	= _PAGE_WRITETHRU,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  56  		.set	= "write through",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  57  		.clear	= "             ",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  58  	}, {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  59  		.mask	= _PAGE_NO_CACHE,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  60  		.val	= _PAGE_NO_CACHE,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  61  		.set	= "no cache",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  62  		.clear	= "        ",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  63  	}, {
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  64  		.mask	= _PAGE_SPECIAL,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  65  		.val	= _PAGE_SPECIAL,
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  66  		.set	= "special",
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  67  	}
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  68  };
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09  69  
97026b5a5ac265 arch/powerpc/mm/dump_linuxpagetables-generic.c Christophe Leroy 2018-10-09 @70  struct pgtable_level pg_level[5] = {

:::::: The code at line 70 was first introduced by commit
:::::: 97026b5a5ac26541b3d294146f5c941491a9e609 powerpc/mm: Split dump_pagelinuxtables flag_array table

:::::: TO: Christophe Leroy <christophe.leroy@c-s.fr>
:::::: CC: Michael Ellerman <mpe@ellerman.id.au>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

