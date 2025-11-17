Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8033ECEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C629F6B0005; Mon, 17 Nov 2025 06:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39E66B0006; Mon, 17 Nov 2025 06:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77836B0007; Mon, 17 Nov 2025 06:23:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A59A16B0005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:23:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A1ADC0C8D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:23:58 +0000 (UTC)
X-FDA: 84119864556.16.D24F24D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id BB00414000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:23:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mfg2a8gs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763378636; a=rsa-sha256;
	cv=none;
	b=ZGAFtcVw7m4eZ/DJuUgtWojAZmlvXoLfguqe8sN2PtYSxhDpti0in5aNessZLS7wqMsI2j
	801iohVlV0fALumXxbDtXwBXMKz+vxqwTzQYrP6DALV2x09Sbm5tprTNLp9IemCKkU2yO/
	GTAiovhf3J5p8GwBrChdhRLo7ktQz+c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mfg2a8gs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763378636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IDPxxmp1K6lgfbW+QcNruHRmQKSB9beYwEQa7qKRoE=;
	b=IQ2MEH9f00+4vZkN5PFCWggWPHbwGPR+I60omGD23mpbkZvrsnC7H8ZBDW7RzfYFDtaKoQ
	Z8Lp1KZmqGRhUZrihLoj82eBtVZpR1DXvCaByB57xfL3lZKOM25NeokDiYyuDv83gt+NlK
	lfU0lfNslj59oXOdP34PGrlbhktUyq0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763378635; x=1794914635;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cTGDxRw5DV/5F6cyNFPFL7KahCJxLa5f7QjjORs1c9I=;
  b=mfg2a8gslZtfIMUCcxC1Szo8HrQK1L+w2WOY0VqnfbqjSoKoi4ysmC6z
   +Ax3CdnRvS3NKB3GD8FVtfVaMwP6gyZMF6Ye8peChdlLuaioJcTDHIVQu
   ZbNOrD4yypCTpf40rnl34aOczKvZi7OnvSt3AKYtH+Z0/Bn/D0czkUkar
   a3MAVmthw8b/QAGTOUUoRnKW8YZ/E6VIcoan48q3Msnjf53E1QvVlTO00
   hadYDVBrCCxDjAKBppsrapM+wCjiLZhtkrTBHQZcCqSgB82oe/zLikNO7
   mTUC+HR+3Pd2XIL5bumooVkOFPXoJWj9l+ZjloQdJ+Z+3+0S7+0UnPSHM
   g==;
X-CSE-ConnectionGUID: ch+xzWsBQ6iEnYutCORsaQ==
X-CSE-MsgGUID: xkp0VXxNR0KGNzs3vNnVhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="75695575"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="75695575"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 03:23:54 -0800
X-CSE-ConnectionGUID: b9ifM0dCTFS+JVYwdDo7VQ==
X-CSE-MsgGUID: OrnG25PlR/6uAcHgIyuVEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="190871048"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 17 Nov 2025 03:23:49 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKxKk-0000U3-1w;
	Mon, 17 Nov 2025 11:23:46 +0000
Date: Mon, 17 Nov 2025 19:23:00 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 14/19] mm, swap: sanitize swap entry management
 workflow
Message-ID: <202511171942.psG9jTRx-lkp@intel.com>
References: <20251117-swap-table-p2-v2-14-37730e6ea6d5@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117-swap-table-p2-v2-14-37730e6ea6d5@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB00414000A
X-Stat-Signature: s8yuo7ipuju4d1k4ep4us3a4xwab35d8
X-HE-Tag: 1763378635-224070
X-HE-Meta: U2FsdGVkX1+h+eq1W9KLEXe9avXiNrvCxMFN+21nC3dpkScbFA/jJlEnkzlqwmhZIbFOXICwuJbfxQi/H8k2Z3fqgn0f8p0mJbLB7Zbz43U4M3z3ehBS+mOJmYjY5Xcm5OSmRdOM9sPioqeEC1jELCtf2zKBtAaDtU9WuYB0lPJ3u18ZzGw1VIihn4I0SFwHe0GIXccMoJz52Mti8MIfIy0bmNfX4jVBmZUque+75ih4/hcMQ3ppfSYHv85IcAiXnSdKtljUuoK4H57U4p+8yUEquVKP34UKyRWNxE0LOifEKaUjg1iz1dXZsCE1jOnwHf96TeSnRRXN36XQ0B6p20ju7nn8wVpswgwWfxYPfCD7/kQrVe4Sbq/Dh8uhJMml8GBADiLDimeCY7+f82hSzji2+J1uteyctFQ2wrRWoBFltl3btRIG4s9Rw2jWvF/BZLfkOfJZhhbFQeLsGjksqnS8SCqv/SwuD543bTJxd/WHgigkc3eDZYPgajA8kB84wVkhnZNgNQ1/bDY1c+NJ4/B+QjtLQrc/dtuKNLGIxvPF0ep7pAMr7OtMAVSrOiLqzXaeAdYdpAWmEUyM4C/nK8j6qHBsKaNAY3EhLxiFKEvaRmM2Tmo4xrJ8dEn8QYkV960fHyGmG6upmKHLcGUhqvk1f+s4Y/UoM05rzuzBEfz5YQNn+d4/m04emYM3lutzJop+yM8xlIuun7N6Wi6OhhUk9GQPZYM2JoGDFzL981Igv73vyEXy716AcvFvnMa/pBfxDOTig/ml8HVE0lBQil4iM7F2QdVXHBLY9Y95Bg+ezyL5ZrHpc8+yxJEfqOlAXJjvx7TY3ACCsQgN6sURG5XeYuHh/eUsvdosRaFlfnH9m1rIMmVl0RMXP73KbQ50T+4xo3ujydlXmRE/DpHuPRa/y4R4y9qqc7kLWo8NXoYtsl0r2SE9OhAsF6sPyRsS8E50aNGl83Zz8yfHZvh
 4DtvfyJe
 7RrUROOMb0YUD2kAqIV9vU7BxhOZTOY1fVK8EnIVZe5JS5U4F8iK0vkWIMig7LC059xQ/z4KLVWVKy+5giqPbXJ6KidmThU1EiSy5cNqjmN77LOx6MkvXjOJcBbi6pC+ZLHYfPmG9UxRUn+LKEB5BBu7WOtrluXQ5vCdlpBqu3Ca9R/vFqgq8HxIvz9m5yG0p1aRMPAJ4iMs8hjn09w8S3hfLYRhyZqEZkxNp/hbDnteS8ecALQUqcfyS0BBB23Ey7tHce4SpPYtbris2cOBn9eOGXIDzHXUh3ShvoPoGNAqy/OlvNrPVjkS90sjclsqqdkaNdz64V6IZ1HgEVHNDbYu+QbQ0+F80C7Wq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build errors:

[auto build test ERROR on 41218ede767f6b218185af65ce919d0cade75f6b]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251117-021532
base:   41218ede767f6b218185af65ce919d0cade75f6b
patch link:    https://lore.kernel.org/r/20251117-swap-table-p2-v2-14-37730e6ea6d5%40tencent.com
patch subject: [PATCH v2 14/19] mm, swap: sanitize swap entry management workflow
config: s390-defconfig (https://download.01.org/0day-ci/archive/20251117/202511171942.psG9jTRx-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251117/202511171942.psG9jTRx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511171942.psG9jTRx-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/s390/mm/gmap_helpers.c:35:2: error: call to undeclared function 'free_swap_and_cache'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      35 |         free_swap_and_cache(entry);
         |         ^
   arch/s390/mm/gmap_helpers.c:35:2: note: did you mean 'free_swap_cache'?
   include/linux/swap.h:435:6: note: 'free_swap_cache' declared here
     435 | void free_swap_cache(struct folio *folio);
         |      ^
   1 error generated.


vim +/free_swap_and_cache +35 arch/s390/mm/gmap_helpers.c

200197908dc4af Claudio Imbrenda 2025-05-28  19  
200197908dc4af Claudio Imbrenda 2025-05-28  20  /**
6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  21   * ptep_zap_softleaf_entry() - discard a software leaf entry.
200197908dc4af Claudio Imbrenda 2025-05-28  22   * @mm: the mm
6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  23   * @entry: the software leaf entry that needs to be zapped
200197908dc4af Claudio Imbrenda 2025-05-28  24   *
6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  25   * Discards the given software leaf entry. If the leaf entry was an actual
6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  26   * swap entry (and not a migration entry, for example), the actual swapped
200197908dc4af Claudio Imbrenda 2025-05-28  27   * page is also discarded from swap.
200197908dc4af Claudio Imbrenda 2025-05-28  28   */
6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  29  static void ptep_zap_softleaf_entry(struct mm_struct *mm, softleaf_t entry)
200197908dc4af Claudio Imbrenda 2025-05-28  30  {
6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  31  	if (softleaf_is_swap(entry))
200197908dc4af Claudio Imbrenda 2025-05-28  32  		dec_mm_counter(mm, MM_SWAPENTS);
6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  33  	else if (softleaf_is_migration(entry))
6539cf8c98a8cc Lorenzo Stoakes  2025-11-10  34  		dec_mm_counter(mm, mm_counter(softleaf_to_folio(entry)));
200197908dc4af Claudio Imbrenda 2025-05-28 @35  	free_swap_and_cache(entry);
200197908dc4af Claudio Imbrenda 2025-05-28  36  }
200197908dc4af Claudio Imbrenda 2025-05-28  37  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

