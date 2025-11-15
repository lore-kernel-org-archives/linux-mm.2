Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C03DACEACEF
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 00:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26FFE8E001E; Fri, 14 Nov 2025 19:52:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247538E0005; Fri, 14 Nov 2025 19:52:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184878E001E; Fri, 14 Nov 2025 19:52:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08AEE8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:52:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 938FC1405E1
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:52:05 +0000 (UTC)
X-FDA: 84111014610.25.C6720E9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id E01D740005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:52:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M0PMWwwS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763167923; a=rsa-sha256;
	cv=none;
	b=qr7s48QCzigtZG/9alEACrY8mT6H96mo8HwBypajU6fLVRkp6edd7WFHJhSiMOHQMm6GVJ
	CUzpr2QwhlL+U4WNse6QUiYxSdLDcRbXUlHJG03BBlPCEuNxEgmiQXaP12sLtJbg64BO6c
	YfNvAbGMen/RWGesvXm9QhDKYufM9xk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M0PMWwwS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763167923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hG+LBwa2EjGLXVqwz8jiIWNeMYXszVida+/9bn2P5ME=;
	b=6C0D/ClGxvrrSS7f1Bx1kVuQiXc3+EuhX5gTq1y8Hrm64kAZaJKksqsBU6I1gb9AQCcIm4
	JVkStZzrdSbXch4xBh3yI5oxamm5KCz1fxxdtepG6vRPxyV/H/m1Cmc0dQGbBpIQXqC1MW
	aZoq15GtJyaf84rofEWN/M/iGV26J2U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763167923; x=1794703923;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vczM4EmXtUbCfHooelDeHpgPNn3rTsFNVUclJSubvyA=;
  b=M0PMWwwS7U7hhnxResSwDt8vyQZFkryJfP7DTukI21Qari0n38Pg74EG
   h4p78e6RgqOFqBrvipUkAzpkPlccmqLXfMXDWA4PLR607pOlhpvpTT2DJ
   tkMhF4eAgngKZ0dXLyMYQ++zRLNEApsG7I7KjgmniiCgAoADBAQ3B3Avn
   sNd9tDG/C7nbsA3OEY0OBkbT03sUKkCGOTze/wgoom6mBCJNuIFArflPa
   kPSSFoTj+7vC5FYMubULIsdYrDmd5r6Hj0D4oQHQj13a26wx2+oFokXHP
   4GCP+5/K8Mh1rOE8GfpuW36UaYEVtAvOgdFmLPsDMyarSE8nGArLrGF7O
   g==;
X-CSE-ConnectionGUID: NGz2KV8JRx+S9rCImCvVzQ==
X-CSE-MsgGUID: FqTzTQFaS/OjOf5DP1MVSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="76730943"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="76730943"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 16:52:01 -0800
X-CSE-ConnectionGUID: nhmJTMybRgykHV04alN3Xw==
X-CSE-MsgGUID: 35aAR/X3ReWs6zsMfpLkBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="227249100"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 14 Nov 2025 16:51:56 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vK4WA-0007YJ-0f;
	Sat, 15 Nov 2025 00:51:54 +0000
Date: Sat, 15 Nov 2025 08:51:44 +0800
From: kernel test robot <lkp@intel.com>
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
	npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
	akpm@linux-foundation.org, david@redhat.com, ioworker0@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 7/7] mm: make PT_RECLAIM depend on
 MMU_GATHER_RCU_TABLE_FREE && 64BIT
Message-ID: <202511150845.XqOxPJxe-lkp@intel.com>
References: <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E01D740005
X-Stat-Signature: mtwmd7z444yg44ax34z9crny4no9n6sk
X-HE-Tag: 1763167922-103130
X-HE-Meta: U2FsdGVkX1912s0PNbwH7ZaZF/NjP2j2f4UEQrH19aRQx5oCJNcoabklx4TGRQZ12Eow1vGwkzqAfEexB91srxrCrMhx4Zez3ypTii9P+zHLReX6faaOloX4vp6dIMmtJuNanSLSBHGPx+g2RDBFZ8gHqifUYxhGDEjvPa+OD15Knkh1xyLw8HEugJFLgA4/MVmgn1smtfghTtzebxaoLvK/qxR2qWTtGfxO+eLeeWEDm2sIntuZ0Sujo+FavXTyCc5MrU58DsseWkkm8fXS2ReWefhY/v+YeCgbQsx9A4odM3WtsJFJoxqHcGyH8k+Bk8NVk1hiDjlQp4sUBFP1fL2DiOVWMHk0bpf9dIhiK+IP92v4RSz7wOuVFuX2pvAzwDh1CSAZMNyV1VixIDJwQYwx2vv+eHi0AxWAsjNP+7DqxZFSH1I4a4wmQDNDVAM/pejKc768dkYkXJG2LP+zqys1b5Bj8GUl/K2Bxm7ojSf7TJS73mtWiU9IsOzTn3V/Fjv1CaShinw1PLeun7yMJo/Fqp7BIjgCQhp/ey27jL8fWg3fRKcCXncRBvjfbI5Qtt5xgSYb76M/VUOtcx647hTniuoh9RUODdS2oVvo04h+7KsWzRRUpwZxUqsrMBrl6wJ1p63TT4Sic56tkYmmFcgAEdkbAAO3Qim4NkaGAZ6UUOqj8EnLoU+ytIyvAu3oQFaiqii42ED6/5I/EtZkMYLgxXXgbOWrJcI0gaU0l0IZ/RFqalUG/x2TxpweEyGIOTtypTBB1ot0tNcgGXqoPpYZeMQORCSOPk5btUOEdrXStUIMtgQu1/zws1rYvQczVTCJ0YS6KLQbbeCLwFYz00kOTP2KcnCAhWn20cmRJXCvqhrNa2Sv8Ja/bBe0eKxEmIRJXp+aE8VFpK6OAqiJKI0QOzFNgsKFM95/5LsnGMyVsgoJaX6lDYcv/4iIDz/zi1z+ZN9N5mn1Th+HHBR
 C1B2iRKO
 ClRk6U4Y0J+RTvY7Uq5pP4q2vLMXSo/3jF9Hkbkb3/lSutQBYEjeQkBNVvaVGXyjG5dIiAKptbsidtWh6IlDDxlZsRMYAvzBY2Ht7wJkvLNsB1o5AFQytribbryJ7Qk2zsMlshYSWC6PWPwK0Yxl+sT5rxSVqwPTKszfIoBLdNb5FPqKXfEFNEX/Q0SmRJ+ogt7ko2YL0PezVBeft9cHY/tWEUO82eXXZmGZVrKPXfamH/AS+AClVPzgh+944eI/5dnNAofofGvNJ129PSnPslOto3lJuAkpdTmmYR47xlTgDb5gES8HpFECC1SC2j0ozVZbAqiPUNpqLTX+k1oY/fCzEB/LDwpMyGfsMWz6E8ZAIySG+r/PFGdxCwI9KFSsCdx1+HmEL6k17TY1tgqN6Z729kKqC1hD2FO0sNz2HyKCzkjHD9oJVL8LKMOnJoi2tFK1I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

kernel test robot noticed the following build errors:

[auto build test ERROR on deller-parisc/for-next]
[also build test ERROR on uml/next tip/x86/core akpm-mm/mm-everything linus/master v6.18-rc5 next-20251114]
[cannot apply to uml/fixes vgupta-arc/for-next vgupta-arc/for-curr]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/alpha-mm-enable-MMU_GATHER_RCU_TABLE_FREE/20251114-191543
base:   https://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git for-next
patch link:    https://lore.kernel.org/r/0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch%40bytedance.com
patch subject: [PATCH 7/7] mm: make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE && 64BIT
config: arm64-randconfig-004-20251115 (https://download.01.org/0day-ci/archive/20251115/202511150845.XqOxPJxe-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251115/202511150845.XqOxPJxe-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511150845.XqOxPJxe-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/pt_reclaim.c:3:
   mm/pt_reclaim.c: In function 'free_pte':
>> include/asm-generic/tlb.h:731:3: error: implicit declaration of function '__pte_free_tlb'; did you mean 'pte_free_tlb'? [-Werror=implicit-function-declaration]
      __pte_free_tlb(tlb, ptep, address);  \
      ^~~~~~~~~~~~~~
   mm/pt_reclaim.c:31:2: note: in expansion of macro 'pte_free_tlb'
     pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
     ^~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +731 include/asm-generic/tlb.h

a00cc7d9dd93d6 Matthew Wilcox         2017-02-24  701  
a00cc7d9dd93d6 Matthew Wilcox         2017-02-24  702  #define tlb_remove_pud_tlb_entry(tlb, pudp, address)			\
a00cc7d9dd93d6 Matthew Wilcox         2017-02-24  703  	do {								\
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  704) 		tlb_flush_pud_range(tlb, address, HPAGE_PUD_SIZE);	\
a00cc7d9dd93d6 Matthew Wilcox         2017-02-24  705  		__tlb_remove_pud_tlb_entry(tlb, pudp, address);		\
a00cc7d9dd93d6 Matthew Wilcox         2017-02-24  706  	} while (0)
a00cc7d9dd93d6 Matthew Wilcox         2017-02-24  707  
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  708  /*
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  709   * For things like page tables caches (ie caching addresses "inside" the
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  710   * page tables, like x86 does), for legacy reasons, flushing an
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  711   * individual page had better flush the page table caches behind it. This
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  712   * is definitely how x86 works, for example. And if you have an
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  713   * architected non-legacy page table cache (which I'm not aware of
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  714   * anybody actually doing), you're going to have some architecturally
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  715   * explicit flushing for that, likely *separate* from a regular TLB entry
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  716   * flush, and thus you'd need more than just some range expansion..
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  717   *
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  718   * So if we ever find an architecture
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  719   * that would want something that odd, I think it is up to that
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  720   * architecture to do its own odd thing, not cause pain for others
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  721   * http://lkml.kernel.org/r/CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  722   *
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  723   * For now w.r.t page table cache, mark the range_size as PAGE_SIZE
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  724   */
b5bc66b7131087 Aneesh Kumar K.V       2016-12-12  725  
a90744bac57c3c Nicholas Piggin        2018-07-13  726  #ifndef pte_free_tlb
9e1b32caa525cb Benjamin Herrenschmidt 2009-07-22  727  #define pte_free_tlb(tlb, ptep, address)			\
^1da177e4c3f41 Linus Torvalds         2005-04-16  728  	do {							\
2631ed00b04988 Peter Zijlstra (Intel  2020-06-25  729) 		tlb_flush_pmd_range(tlb, address, PAGE_SIZE);	\
22a61c3c4f1379 Peter Zijlstra         2018-08-23  730  		tlb->freed_tables = 1;				\
9e1b32caa525cb Benjamin Herrenschmidt 2009-07-22 @731  		__pte_free_tlb(tlb, ptep, address);		\
^1da177e4c3f41 Linus Torvalds         2005-04-16  732  	} while (0)
a90744bac57c3c Nicholas Piggin        2018-07-13  733  #endif
^1da177e4c3f41 Linus Torvalds         2005-04-16  734  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

