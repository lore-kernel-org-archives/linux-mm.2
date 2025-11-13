Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC75ECD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F8F8E0006; Thu, 13 Nov 2025 02:20:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176E08E0003; Thu, 13 Nov 2025 02:20:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4038E0006; Thu, 13 Nov 2025 02:20:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDEB88E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:20:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9015912E4DE
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:20:44 +0000 (UTC)
X-FDA: 84104736408.08.FC58A48
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf18.hostedemail.com (Postfix) with ESMTP id 989C21C0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:20:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eHFcW1eG;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763018442; a=rsa-sha256;
	cv=none;
	b=skQXcFb7TfHGfHOACqTVl4a6XubPuDL32p0WyJ06PavOWgWdNm+M7xzTAB5+JgM+gsdIpO
	Tzun1J9ItoozhGuwgmdPsYBqkA7uQSNN1mHkODQDSNb2+MzPilzhEJsUu/EveTPDWhFozz
	jUgeGgRql2d033MV29w3IlKD0jAaMfY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eHFcW1eG;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763018442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCldgPT/UQi8UNoTqo2vDJtQSJnRxkI0JviJmN99QME=;
	b=hwr+2HO27Erh8gyijZrtT4E77Qiq/sR4uSuK/gXfcb2Bfr4CoLxeLCskKiZge4P/omqXiu
	zuxoimx4tF3MTdE6v9IbCB4jKwXZNFPinN2DXJdKsmcY11n8X+xbBoM3hER9aNo832IFiV
	7y+3mrde817CKjdEHddT2ZmspWaM+2U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763018442; x=1794554442;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Me6GWqOMV1Te3Vqndd4JPy4GgWbf+TWVFwtSqdGhwE=;
  b=eHFcW1eGUsHtgvJ29Q5yccly9E0NDEZLGMf/h2iuquPYh2CLVUeSv3bO
   Zv4kYNNTASYEPhQgXfR0M52nIPB1f0wJvdYi/dAajf32sO4YqE4TBwiII
   DTjB1NSrpYU76IU0joUqdPT9dTSe4OPcII77+uJPqVatVmVunwJ3fvaUr
   fOGitrKrq08PrBaEQVmNIiS2doZIEiNfr2EUIS5Z8Qplduevhj+C7KZ6z
   11DcrMmkCITq2sGbqKflmWGM4/uhvF5F90MUxBnnXp60Ii1hillYJFT48
   p9kQmeglTfYampCYfkPXd2b/evK9Gl6NfG10zd6ecv35ERmlf8Obuj3zp
   g==;
X-CSE-ConnectionGUID: DQs72nR1TKalkA42cPIX2A==
X-CSE-MsgGUID: d7qWRlfZQX2UqxclFDglAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65018345"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65018345"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 23:20:40 -0800
X-CSE-ConnectionGUID: Gj2hNzySSG+P7YfpZN0+0w==
X-CSE-MsgGUID: Rg/fE/d9SqiQUCtfAuTUPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="189614267"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 12 Nov 2025 23:20:36 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJRdB-00051L-19;
	Thu, 13 Nov 2025 07:20:33 +0000
Date: Thu, 13 Nov 2025 15:19:38 +0800
From: kernel test robot <lkp@intel.com>
To: Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v3 08/22] mm: Allow page table accessors to be
 non-idempotent
Message-ID: <202511131448.ZCsuBlBE-lkp@intel.com>
References: <20251113014656.2605447-9-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113014656.2605447-9-samuel.holland@sifive.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 989C21C0002
X-Stat-Signature: ibhcz8fxkn6f5wzund1bhu3huc5mquc3
X-HE-Tag: 1763018441-880204
X-HE-Meta: U2FsdGVkX19mOYmFKXwpcOP9ok1iCwdn1hEyGYNiwPIKfS5m1sRKfjf+ZBZJAZuuih6p0eEhCi0Da6U19s1sZolJ6lbpSVxxZhBb8eWmEUWGKunBc0OLZb67dKYn4XwqXZw8SIT5Bd0X6z4o4OW+AXrzY7jhwGmHsu/T2Y2BeFvDnjy7DGxJgiiZ+EJlxgxE/hni9ER6aolCJNVDcC5b+wOPr1H17cCa01RISZSS1QJD7TDMkcqyTOx8j6FcG5x0WqsoYCWNk6KsRSjkHFtoMCpA2K8Bs0dT5Yzsj65XPc4X8A1WXQkeOgqPbTG0Q6k72t5t+lzOd/NL6FGxqsLakSENOucjUezntwrSY4sB11ir7zyugm/fVhd278vpGyCcSCqxTQ5wnN6lAd3I9YIkRDT7ZZxmSnFM/Cc37kDV3eTr0Pkuzw6ROTOTTQt7KBpZA9xBYbnteSOHYW4TLHX2kYxUcJgRakWwDJ4esESU5tTHWihzn4aLyPB8VB+avWgLmud2FdN1M1CgOrbM2PBKTJ72rKxAWNQspLifSe5dEPy1RU7l5f1QAjAigAPCk3CbRjyL8VE2Gg1E7/O7MSzryagLPkG/nsSWy5qylSEtCbUXrvWZe+UooRR88pZ/zSfZjwU+Y63orz83YwLHs5sWV9Xm856THLfYmBkPpfnKTvRA1mPzNMe5tiO0G7o4Hj1hwlxQM59LC9vRG0q10ZyQirLbcXFU+hlBY2I0OD8zME2bXLcG8GzujdYxs1qZ8WMldjrVfwOlohrwMBhEYP6qp/wqXzvsSaeZxjWq4R3od6z7emW4sIOsnCsb9C7nEFWESmCCHuN5HndSEn0tzgtBDAOzx+8U26wFPVkmaPhg9/YNDUykE70hgZwxC2UM4HP4sTJNYrEjkcD+g0v9mQgr6KZy+w6NrsyU9ZE8wRtxWaV01s995/Ew1S6IdPuLT6nP8K6monqt8y5dMTFG44g
 fRNG8UAM
 PLnPpHOCStI+FW25l14MfZkPFSsUmsL8tXBJ4a7mPO44Hy2OFMECTlMoH5lrZF/24Yjwlhjecta+So/FVP1B0HdL/oWtovhhyAuMMIxK/uVAzGG8IylvahbMJoUI/RGSBHEQdweWKZjZaXzQpZqVfqIkTKL/e3FDZ6rL6swZhM+iXazQFo+mPHAug8C2kTIjOJjgEV9mvysw7qARZCBcCRN5MnVzWHsK1mjbYEb9T+pl0cFJrpRkPUSFr1SCHKaTTYJwiHfVzDeJEaS/pAArvsyqx6jcfjr+ztNUn29kndrNXcHZfEkhadRIfdwB9W6Mp5KLv/wdVMuQPjZxlMptopseaeKcDzvKWci57oBqZq/bx94Ikzmi4JWKyI0StHlZD1XmVTZZNXQDJ4P8yNgCaOgSFsbdhqYSqIYstQa/nor8nMccYad8UDasQmDsBRiHjEYfOJnrDwZSadcR9Yigay2j/kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Samuel,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24172e0d79900908cf5ebf366600616d29c9b417]

url:    https://github.com/intel-lab-lkp/linux/commits/Samuel-Holland/mm-ptdump-replace-READ_ONCE-with-standard-page-table-accessors/20251113-095117
base:   24172e0d79900908cf5ebf366600616d29c9b417
patch link:    https://lore.kernel.org/r/20251113014656.2605447-9-samuel.holland%40sifive.com
patch subject: [PATCH v3 08/22] mm: Allow page table accessors to be non-idempotent
config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20251113/202511131448.ZCsuBlBE-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251113/202511131448.ZCsuBlBE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511131448.ZCsuBlBE-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/gup.c: In function 'gup_fast_pte_range':
>> mm/gup.c:2848:9: error: implicit declaration of function 'set_pmd'; did you mean 'set_p4d'? [-Wimplicit-function-declaration]
    2848 |         set_pmd(&pmd, pmd);
         |         ^~~~~~~
         |         set_p4d
--
   mm/pgtable-generic.c: In function '___pte_offset_map':
>> mm/pgtable-generic.c:303:9: error: implicit declaration of function 'set_pmd'; did you mean 'set_p4d'? [-Wimplicit-function-declaration]
     303 |         set_pmd(&pmdval, pmdval);
         |         ^~~~~~~
         |         set_p4d


vim +2848 mm/gup.c

  2819	
  2820	#ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
  2821	/*
  2822	 * GUP-fast relies on pte change detection to avoid concurrent pgtable
  2823	 * operations.
  2824	 *
  2825	 * To pin the page, GUP-fast needs to do below in order:
  2826	 * (1) pin the page (by prefetching pte), then (2) check pte not changed.
  2827	 *
  2828	 * For the rest of pgtable operations where pgtable updates can be racy
  2829	 * with GUP-fast, we need to do (1) clear pte, then (2) check whether page
  2830	 * is pinned.
  2831	 *
  2832	 * Above will work for all pte-level operations, including THP split.
  2833	 *
  2834	 * For THP collapse, it's a bit more complicated because GUP-fast may be
  2835	 * walking a pgtable page that is being freed (pte is still valid but pmd
  2836	 * can be cleared already).  To avoid race in such condition, we need to
  2837	 * also check pmd here to make sure pmd doesn't change (corresponds to
  2838	 * pmdp_collapse_flush() in the THP collapse code path).
  2839	 */
  2840	static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
  2841			unsigned long end, unsigned int flags, struct page **pages,
  2842			int *nr)
  2843	{
  2844		int ret = 0;
  2845		pte_t *ptep, *ptem;
  2846	
  2847		/* transform pmd as if &pmd pointed to a hardware page table */
> 2848		set_pmd(&pmd, pmd);
  2849		ptem = ptep = pte_offset_map(&pmd, addr);
  2850		pmd = pmdp_get(&pmd);
  2851		if (!ptep)
  2852			return 0;
  2853		do {
  2854			pte_t pte = ptep_get_lockless(ptep);
  2855			struct page *page;
  2856			struct folio *folio;
  2857	
  2858			/*
  2859			 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
  2860			 * pte_access_permitted() better should reject these pages
  2861			 * either way: otherwise, GUP-fast might succeed in
  2862			 * cases where ordinary GUP would fail due to VMA access
  2863			 * permissions.
  2864			 */
  2865			if (pte_protnone(pte))
  2866				goto pte_unmap;
  2867	
  2868			if (!pte_access_permitted(pte, flags & FOLL_WRITE))
  2869				goto pte_unmap;
  2870	
  2871			if (pte_special(pte))
  2872				goto pte_unmap;
  2873	
  2874			/* If it's not marked as special it must have a valid memmap. */
  2875			VM_WARN_ON_ONCE(!pfn_valid(pte_pfn(pte)));
  2876			page = pte_page(pte);
  2877	
  2878			folio = try_grab_folio_fast(page, 1, flags);
  2879			if (!folio)
  2880				goto pte_unmap;
  2881	
  2882			if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get(pmdp))) ||
  2883			    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
  2884				gup_put_folio(folio, 1, flags);
  2885				goto pte_unmap;
  2886			}
  2887	
  2888			if (!gup_fast_folio_allowed(folio, flags)) {
  2889				gup_put_folio(folio, 1, flags);
  2890				goto pte_unmap;
  2891			}
  2892	
  2893			if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
  2894				gup_put_folio(folio, 1, flags);
  2895				goto pte_unmap;
  2896			}
  2897	
  2898			/*
  2899			 * We need to make the page accessible if and only if we are
  2900			 * going to access its content (the FOLL_PIN case).  Please
  2901			 * see Documentation/core-api/pin_user_pages.rst for
  2902			 * details.
  2903			 */
  2904			if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
  2905				gup_put_folio(folio, 1, flags);
  2906				goto pte_unmap;
  2907			}
  2908			folio_set_referenced(folio);
  2909			pages[*nr] = page;
  2910			(*nr)++;
  2911		} while (ptep++, addr += PAGE_SIZE, addr != end);
  2912	
  2913		ret = 1;
  2914	
  2915	pte_unmap:
  2916		pte_unmap(ptem);
  2917		return ret;
  2918	}
  2919	#else
  2920	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

