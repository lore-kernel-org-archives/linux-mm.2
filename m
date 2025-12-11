Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09690D43361
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 23:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ACCC6B0005; Thu, 11 Dec 2025 18:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DC16B0006; Thu, 11 Dec 2025 18:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173006B0007; Thu, 11 Dec 2025 18:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0746D6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 18:41:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F7C5B7F2A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:41:02 +0000 (UTC)
X-FDA: 84208813164.04.FB71C42
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3D17F100002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:40:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UNgM3Hk2;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765496460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8F1MyB30n09w2XnWCOdwRaJnp8yaU5N9F5AvB83Ov0=;
	b=E2sZo96JRhpsvCyGp4PkCU7z2UpqPCn6uO/rBWT/ykcUuGMJJ7qxNTxKY40qm1kdfMYMe6
	APceb1P0yyNdxxvx3L4OHIBfHrI7sybLIzJVBxh/ZvNX9Sqlyhumxxj4bkrkxSKYX6h5DW
	pcifsgGiWEi6nIlFLFUDQkHC5RjFhEA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UNgM3Hk2;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765496460; a=rsa-sha256;
	cv=none;
	b=nChBi7bbBdudZ9glJQCJCogHpn1fyN3yHTakVCyViuh1RFWmBPQUO7qDIo9d/Ximd7CB7f
	jFolgxPD4d06jlL/Pb+zrYbp3kZ6LFgLyVb8ORx599dqYesTrJtYxjyQPguMCFioqCtVX/
	O3M5E5IX9X14uZfmx6vV1RrvPDc+I34=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765496459; x=1797032459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EkQOI6jVqcqmDxCC2zpQcLsEWK0lUcThTIMyL7fnwXw=;
  b=UNgM3Hk2bkSm8ehNHV6RFZVWIy9NJ+AoMHKFT/iIoBqcEznUym+lfE2R
   vj1seJE3DvLfIOjEo9AlHYiT8DCiAvJqn810Q+d7+PYTVKfGODY2OTvq1
   hic1m3sP5Cq1pfo5GM8mo9+q258ZS2AGOxbvGMR659cTyRg1U0BdbDqzR
   bHE0yyPu7l/9tqlhzkYfxGT87x1qNhMSJZyJbkut6jzLPtGJFTUMMQO9S
   XhXNRX97L7OJuj7TrXch6nC7W6fNIRVOyaEQBfq1Y2MmbRzi0aDBQ4+Vd
   I5mF10iQkSA9A5V5/05IBQHXHfQwzyHoqr3Llq0mP1XP79Uw97GK8tCrs
   g==;
X-CSE-ConnectionGUID: C3hUdXMUS5infLsKjGKGpQ==
X-CSE-MsgGUID: cSjBbBskR+uDHryTmodXtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="78855733"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="78855733"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 15:40:58 -0800
X-CSE-ConnectionGUID: Xr4OVmJmRbKPbckglQhbtw==
X-CSE-MsgGUID: 9lUptSQiSpWJOUFt+BwWOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196702616"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 11 Dec 2025 15:40:54 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTqHE-000000005CP-0IV5;
	Thu, 11 Dec 2025 23:40:52 +0000
Date: Fri, 12 Dec 2025 07:40:47 +0800
From: kernel test robot <lkp@intel.com>
To: Samuel Holland <samuel.holland@sifive.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Gavin Shan <gshan@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH 2/2] mm/madvise: Use set_pte() to write page tables
Message-ID: <202512120735.ge1E0s5N-lkp@intel.com>
References: <20251211081117.1126521-3-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211081117.1126521-3-samuel.holland@sifive.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D17F100002
X-Stat-Signature: hkkgu4nuqas1q1fu7irkwshjhdwnx4bj
X-HE-Tag: 1765496459-137904
X-HE-Meta: U2FsdGVkX19aix/h4mzvVHLAUbyQmRN0Vm88yk9r6OdSx0buuA8bU9xffaJb3v+g+r5bss0XR8v27svZ4IpSz0FicxGLuB4fynFtClk7t8+sCDpNwUy969YXzdJTlIsVICyEhUr2chbpRBh2qakorHhfoRF2yAA8NxfnfWZyCkyl/2do1EEzS3vyXF0aCkkc+thK9ig0OL5zE0OTv36J0WzdBTZ26udb9Um9cR6M+dvUGcLLvuXApQDk3rXFwmsHsjemjTNl6cmUcjqeNBbvEdg0FTNDNc5IqY8wgz1FsenKGlGMHBQLO6cugpMnCXS+yMcGdIvaA2dNsUuRSG4JkwwfTzpo+T8rADtmd5KyZFRfA4fw9EsYKALw5gaa6t4brXyQW5INNSFZyaVulDx87XXNnn48OzoZMEGl9xgAZEvHnfOY6t5w1ed5mjFrtZqjvp0QWvYekcd9D0H+Gf0s0VpdjkVK/iBtbWl+Xwa/9E9MMqmRJ69+sstpcCYGfBFSnmvdghu/FiXmeB6alyzs9Mvq5YyUjaMxsUc9WRv/+MecFFmLNvRdreMmGb8wzGHR/qV4q3b8HGu647UT7aJsjwjH4T1l0r+LNtvWBvtQ35ufOPZD7PEaU0SrB9iXawUUO3PVheUpg0kL361vDkvNE0X5JG8IdwyFKGJd8JY9d0sCwmv26bpEakDDZ5cUPMpleiIjUd27QuK06Pb2mJi00+UhogXX8jTwJQTb5OkG8yXxnp0lzQZlasAg5XS/dfUy6edlXZCbj4pk4yxq5H4UZe+k8Lcl1xcijEB21Qo4R5hud6T4TRL2XfcJz3XmrivJ72iJTlAwIWvmYhYjED8gNjuGKH2vIIEtBOa3IEluUqfbcN+COGwi4hwRca//HLibXEXCAIwhS7ib1+rcS35yLBxMX1TgPCEg43ZlrEXjedX49YMX2LJqZHAjc+hSc0+JpiYs8zIWTxy9hNQFw2D
 UWCJ4VrA
 W1Oo2SurfTcDfBQMi/HmjpzkYB2ouf8VFaqERjuDuJVAjbJvy2Y5Uy+IHScpH7peuObBIQ8nav8oANduH964rW+qFryvpCz24NhaMfj8WW1f/n4gBYRaMcJv41tl4ovxWAXa96WVO3VL044MOrLbaB3w5y0f1VtzGYMt1lKM+6kSI7G0Nmo1WbjkIQNjbadGSzhnFopfmdJ4o0cnPtV97bp0n9u2cyZnNGeCwBkYua0SoZiqTEq/kgHLs79M9HY+lzMQhXqLMhWbnxnQZUK1BcMeR8bM9s2i4rliZ1QkKrqfqy7/TYnWwpXI9H+CpGnOzDc5YX1ik5wkNFv2E4SxFsMEs39vyZ9Cnh+aAzB7QfWWWFMVckOpMBeoUpfctb6mH0YmCJ2MaUanCTAy9o5ISLBQedQ3mi9+KBkrWz+nm1A8Au5zpjsbRK2xXgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Samuel,

kernel test robot noticed the following build errors:

[auto build test ERROR on d358e5254674b70f34c847715ca509e46eb81e6f]

url:    https://github.com/intel-lab-lkp/linux/commits/Samuel-Holland/mm-debug_vm_pgtable-Use-set_pXd-to-write-page-tables/20251211-161254
base:   d358e5254674b70f34c847715ca509e46eb81e6f
patch link:    https://lore.kernel.org/r/20251211081117.1126521-3-samuel.holland%40sifive.com
patch subject: [PATCH 2/2] mm/madvise: Use set_pte() to write page tables
config: arm-footbridge_defconfig (https://download.01.org/0day-ci/archive/20251212/202512120735.ge1E0s5N-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251212/202512120735.ge1E0s5N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512120735.ge1E0s5N-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/madvise.c:1117:2: error: call to undeclared function 'set_pte'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1117 |         set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
         |         ^
   mm/madvise.c:1117:2: note: did you mean 'set_ptes'?
   arch/arm/include/asm/pgtable.h:212:6: note: 'set_ptes' declared here
     212 | void set_ptes(struct mm_struct *mm, unsigned long addr,
         |      ^
   1 error generated.


vim +/set_pte +1117 mm/madvise.c

  1110	
  1111	static int guard_install_set_pte(unsigned long addr, unsigned long next,
  1112					 pte_t *ptep, struct mm_walk *walk)
  1113	{
  1114		unsigned long *nr_pages = (unsigned long *)walk->private;
  1115	
  1116		/* Simply install a PTE marker, this causes segfault on access. */
> 1117		set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
  1118		(*nr_pages)++;
  1119	
  1120		return 0;
  1121	}
  1122	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

