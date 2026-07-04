Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37A4C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 06:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45116B00B5; Sat,  4 Jul 2026 02:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DAB6B00B6; Sat,  4 Jul 2026 02:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59DE6B00B7; Sat,  4 Jul 2026 02:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4F06B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:28:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1D311203FE
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:28:09 +0000 (UTC)
X-FDA: 84950114298.26.48C9075
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E19C40006
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:28:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jiKOKGfF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783146487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNDg20YoC8s8bQwkx2yeu1e8eu2LB30CjiLIJ7BaBUg=;
	b=PcMKZoOdM/e8xFYt9aYz4LH73YZq2JA07T7k5RcMRudD4E0MyALbk86suFrsdEghkGq81P
	VK1qfV6t93o3VJVQ/Ivfw7/Z90rmpbFx5snGmOx95tIPh0L+V9G3rbRr/qTZxkf19/E0py
	bNx0NYn5bxLIn2je5S8sxZ4xrKU9O5o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jiKOKGfF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783146487;
	b=7uBcZr1t+jdwTDng+txP03xrI0qyffXd0uPFzn0lzdY9sIlrNOzeoE3wPFTwb3L6yKogsU
	A/tknB1L/m/1/ZGsUIeLK72iqZ3ftRpgv3LVY6zCaZ4YWuAnexSf54fw7OQMAc2G2i6DtF
	tzskXpaW5wq3SbAiawS5VyTlWbl3TVA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783146487; x=1814682487;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SYuftC8uB1rNBHxV7MO5Hs3pXpuRV7EDdT04JM2y5bY=;
  b=jiKOKGfFyP//d5gmQq+8vUHu3cLiq40A/nPrC0S+rLHlhZx92KbhnI+u
   L+GeKg2esEsA74G7s4Xi9LbYBPcgTOkyY9bZ0FmdjsNByO1wdvbN7hky+
   MlljJckQs655gdrxUcZgjDcX/ahgXCxebYLRUOZFZxMsJMd06lXRQBOBN
   iY57yMQBx2p72+GLTmgv306BwSpfPB6FBvOetoUEEIEAgKEpzgeK7MGDL
   Pynd/Oe+yMjQIM0kcxBtXRq/06Hui5JOH0lHleOWXuQD1xWfnIbMEQOOG
   6NMTMlHbnRfk8dq7/WZHcZe1Z71lFbBmJwtlYbUDN9JBmv0Wf6qIE1Se2
   Q==;
X-CSE-ConnectionGUID: JyI2cjvdSf2HRNTom8wYDQ==
X-CSE-MsgGUID: FGS/dP8jQaG0aX0ZjCgpow==
X-IronPort-AV: E=McAfee;i="6800,10657,11836"; a="87784790"
X-IronPort-AV: E=Sophos;i="6.25,147,1779174000"; 
   d="scan'208";a="87784790"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 23:28:05 -0700
X-CSE-ConnectionGUID: zmKUGmO6QxOr/eQyxd19ew==
X-CSE-MsgGUID: W3j9GpVtQQ6Qj8ZBkSEB0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,147,1779174000"; 
   d="scan'208";a="251525268"
Received: from igk-lkp-server01.igk.intel.com (HELO e5a8ed462067) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 03 Jul 2026 23:27:59 -0700
Received: from kbuild by e5a8ed462067 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wftr2-000000001h7-20Is;
	Sat, 04 Jul 2026 06:27:56 +0000
Date: Sat, 4 Jul 2026 08:27:55 +0200
From: kernel test robot <lkp@intel.com>
To: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
	ziy@nvidia.com
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr,
	kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v3 11/11] selftests/mm: add PMD swap entry tests
Message-ID: <202607040838.eEdmRDmU-lkp@intel.com>
References: <20260703173903.3789516-12-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703173903.3789516-12-usama.arif@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9E19C40006
X-Stat-Signature: uuyosrfft673h3cypuhsn1aueyq9fchd
X-Rspam-User: 
X-HE-Tag: 1783146486-36701
X-HE-Meta: U2FsdGVkX1+MOi7VM/bGUe9/LEwxep0Xm+OvX8y/wpr+wz5nRnn+C3MEQ72sJrw0zJleVsvfFMP9ivE6aeyy873CggIZX1lnEXeuMzL0HdFSdGf+t61K1ANXV5FcdGbFakprxZgJ7slDJ2qKijjCh5BtVlo8N0/wm6h79CMAP9zC6JFs7/vkUoBSSmZo3g+pL1TNw1ytEVJj70XW0ryn8Huj+BJCaXcN1hD0jcDBnX4jVWeYFt8WuD6IZ/2Jdt46Ks3Ve4/+28ObGW2+gRaikJEHLhMOFi45thmMNOGvPJl3718aVHayQHiViND9yAhfA6XkOAQy1WlfABNu5GXMb8dI2MEZvDJ/3T+c1PM0Re67YLX476JV5i7aWytSTy9CotyjCOKVMm/Ue1UoTCyz6q+0jRbAnh1Ll+NE9WehVs+5WeKewK8ptPytbEMwQX7KhvmKNaNuKOgHr7CsP01aPex6fiIB7ABJ0QEgVYsrQz0oNxQj+VBFpk8kBTxjW+RYWZlCPDkIcPqDihLsorsR5yzeAWAwafDge191y8lpYDnrNUS/17wnqadDPtOeDfGNEVZcmetbaf39nCUGI5+FldHcJDiGdGhs2GV1ZwfQALid6jsIt/8jNnqFOjviryHgjVKTGQ5PCu5OWvYsEk8DUFv10zYEC07RvPKgWEHQmt8i4woQb5welJEvJXzXhAgk6QVRboGUmMHeph9Q19BqF92jxcTpcqayTsGlhYJt+xyH759GMf9B4bg41OOKEv37AsX8I3SvwMdj5eE2ntcwP6/XqLxc1AAQksUBtCspDfwgUPtDumoZrU1CDYQ93fhcsnwxC7vyhrsPujM2EQb5EplFGkGpFGRkhJIsQ2BBL3TBtYnL8EX1VwCuMBtLVpaVYbwYiKL38nzs18Lx8gxh7QRxYZbQ2kouu07WNmwv1pxN7WuF4jqvfXiq7eML2fYNDt+Fl23+nVbYBVfMSAJ
 XdA/08mE
 JjP6I8sSy4i4oWcR+KuVKQwKchdy0ULLpEgUOrgJTPzG1Yg9rkXA/anXyeyYK7y2Mkbncl+KL2Dy2f6RaP5VBC93CMdCk/CngRAnY8XrLAWW6/8i3xEFq9BrxwrbOnVy1ap2n/ADXcZPOa4XFSHjAsCH7afd1P0RyCGodLbng2SW1ykKhzM8F7H7EDjQKgGS3lWza02IuMKX8A6iiQyZDNByu7xe1Dgf3iPdY+OutdjD6AcMEekR0GKmzvUlynfnW093rJB5NA2YrMoNrfs72v+6tmkyxCAtTTkupTXWpKltNNIJwXul2mwL7zf8cM2QFv6kXyPcGufXm33M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Usama-Arif/mm-add-PMD-swap-entry-detection-support/20260704-014151
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260703173903.3789516-12-usama.arif%40linux.dev
patch subject: [PATCH v3 11/11] selftests/mm: add PMD swap entry tests
config: riscv-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260704/202607040838.eEdmRDmU-lkp@intel.com/config)
compiler: riscv64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260704/202607040838.eEdmRDmU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607040838.eEdmRDmU-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from ./include/linux/pgtable.h:6,
                    from ./include/linux/mm.h:31,
                    from arch/riscv/kernel/asm-offsets.c:9:
   ./arch/riscv/include/asm/pgtable.h: In function 'pmd_swp_exclusive':
>> ./arch/riscv/include/asm/pgtable.h:935:16: error: implicit declaration of function 'pte_swp_exclusive'; did you mean 'pmd_swp_exclusive'? [-Wimplicit-function-declaration]
     935 |         return pte_swp_exclusive(pmd_pte(pmd));
         |                ^~~~~~~~~~~~~~~~~
         |                pmd_swp_exclusive
   ./arch/riscv/include/asm/pgtable.h: In function 'pmd_swp_mkexclusive':
>> ./arch/riscv/include/asm/pgtable.h:940:24: error: implicit declaration of function 'pte_swp_mkexclusive'; did you mean 'pmd_swp_mkexclusive'? [-Wimplicit-function-declaration]
     940 |         return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
         |                        ^~~~~~~~~~~~~~~~~~~
         |                        pmd_swp_mkexclusive
>> ./arch/riscv/include/asm/pgtable.h:940:24: error: incompatible type for argument 1 of 'pte_pmd'
     940 |         return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                        |
         |                        int
   ./arch/riscv/include/asm/pgtable.h:758:35: note: expected 'pte_t' but argument is of type 'int'
     758 | static inline pmd_t pte_pmd(pte_t pte)
         |                             ~~~~~~^~~
   ./arch/riscv/include/asm/pgtable.h: In function 'pmd_swp_clear_exclusive':
>> ./arch/riscv/include/asm/pgtable.h:945:24: error: implicit declaration of function 'pte_swp_clear_exclusive'; did you mean 'pmd_swp_clear_exclusive'? [-Wimplicit-function-declaration]
     945 |         return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
         |                        ^~~~~~~~~~~~~~~~~~~~~~~
         |                        pmd_swp_clear_exclusive
   ./arch/riscv/include/asm/pgtable.h:945:24: error: incompatible type for argument 1 of 'pte_pmd'
     945 |         return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                        |
         |                        int
   ./arch/riscv/include/asm/pgtable.h:758:35: note: expected 'pte_t' but argument is of type 'int'
     758 | static inline pmd_t pte_pmd(pte_t pte)
         |                             ~~~~~~^~~
   ./arch/riscv/include/asm/pgtable.h: At top level:
>> ./arch/riscv/include/asm/pgtable.h:1218:20: error: conflicting types for 'pte_swp_exclusive'; have 'bool(pte_t)' {aka '_Bool(pte_t)'}
    1218 | static inline bool pte_swp_exclusive(pte_t pte)
         |                    ^~~~~~~~~~~~~~~~~
   ./arch/riscv/include/asm/pgtable.h:935:16: note: previous implicit declaration of 'pte_swp_exclusive' with type 'int()'
     935 |         return pte_swp_exclusive(pmd_pte(pmd));
         |                ^~~~~~~~~~~~~~~~~
>> ./arch/riscv/include/asm/pgtable.h:1223:21: error: conflicting types for 'pte_swp_mkexclusive'; have 'pte_t(pte_t)'
    1223 | static inline pte_t pte_swp_mkexclusive(pte_t pte)
         |                     ^~~~~~~~~~~~~~~~~~~
   ./arch/riscv/include/asm/pgtable.h:940:24: note: previous implicit declaration of 'pte_swp_mkexclusive' with type 'int()'
     940 |         return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
         |                        ^~~~~~~~~~~~~~~~~~~
>> ./arch/riscv/include/asm/pgtable.h:1228:21: error: conflicting types for 'pte_swp_clear_exclusive'; have 'pte_t(pte_t)'
    1228 | static inline pte_t pte_swp_clear_exclusive(pte_t pte)
         |                     ^~~~~~~~~~~~~~~~~~~~~~~
   ./arch/riscv/include/asm/pgtable.h:945:24: note: previous implicit declaration of 'pte_swp_clear_exclusive' with type 'int()'
     945 |         return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
         |                        ^~~~~~~~~~~~~~~~~~~~~~~


vim +935 ./arch/riscv/include/asm/pgtable.h

   932	
   933	static inline bool pmd_swp_exclusive(pmd_t pmd)
   934	{
 > 935		return pte_swp_exclusive(pmd_pte(pmd));
   936	}
   937	
   938	static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
   939	{
 > 940		return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
   941	}
   942	
   943	static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
   944	{
 > 945		return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
   946	}
   947	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

