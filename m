Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4874CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3FB6B0088; Wed, 30 Sep 2026 11:16:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9BC96B008A; Wed, 30 Sep 2026 11:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A1B6B0096; Wed, 30 Sep 2026 11:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8216B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:16:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 213AC1A006F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:16:15 +0000 (UTC)
X-FDA: 85270779510.17.D10F98D
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33818180007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:16:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cW5uEKiB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790781373;
	b=YdD4+aLciXabtxKvgLhwpB6760nAfBSv68ECNInmG0j4bO2j97s+ODkqYzJRlh/1FAIfYw
	QkMemOA2XlRxwY4qWlG52c+GX0lLG1tthEdYkL5qjXOSJPfYvy7lwcHv+4eyHA3L0H2a3p
	IdjodJ0avoERJHNXF8wUWTG2RrxbZ+0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cW5uEKiB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790781373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9dGLqKNBlMrHbdqAQfcvM1eXGcLD/Xmv99laXST3Cc=;
	b=VbiKY9WfzbKfUUK+ZVIX6gykfm6KcCs70btLCOGk8g9tswaDpvfGMDPbPkRY7QIsB31zA6
	YUnu+G8fPaf/UhaUFr2vrlCFReYIpB9084Nlq/zxgMOPcUmAdGNZIvN02g46CbSCHtB2PY
	L+rwXAZREb9dwAfuQlE0coKFrYIHeTU=
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2e20bb4583so108406666b.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790781372; x=1791386172; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q9dGLqKNBlMrHbdqAQfcvM1eXGcLD/Xmv99laXST3Cc=;
        b=cW5uEKiBQxdNhpj07tboVNjebppg4ojJ9chOaM0r0xNxW2cgN2cpBJfT7OChf1Ev3K
         3WdjpF2k/9VZ9e14C39j0TG8oPyMgf2vQGB762GAevc0n2u7iRYQsV+GFItEy2Uthr11
         jIFUaphyIrP4pwwIseZlrpi8yFlpaQPpmSJWFTE82DShszKhqkvtPRs8OetyDRmuqBtD
         hNTLHaQMTX/w5aVd/Aqxuq7QHwdSSQZiKfxoNar8OFxg9WODpHxbO5B8cPH9B7IzQ3rU
         bDnG+3pY9eIsX81Qx0MXVwU4XKetrIcAxekDQdREUU4iNwFN6q9vZOryeDMZq8QFAp1p
         EgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781372; x=1791386172;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q9dGLqKNBlMrHbdqAQfcvM1eXGcLD/Xmv99laXST3Cc=;
        b=h+hyTTB+bONA5Kum9vtbzpgmLGP02jqOe1UCTJX+LB/WtQpCuLBNraZC8kmzSgf7zi
         YP8C/7SlbHdRu83Jslj4yNvOTXIHpp+O5NS9qzb7Ja2QX0ALraSZ/Zv+bL93ac8xsrLq
         unCWwmP/MnohTT3L2HNVl5dD4/GMV3xKZ6QM/6QwhPCpbaorPl64geLg6c4s/mpGsagF
         TSeDPVavjIe0gB4TmNPQIElnj7gmPuPwsfOMNk7JgdNYy6X5D2E4jKxKiVqc1eveKja1
         L5l/sKow47+e+QiMr03JO5B8fzuy8i+BxLfgD81YSqHIEI9b/B5rm0khBfgHPC6XUBZX
         UkYw==
X-Forwarded-Encrypted: i=1; AKwUvBw1gtRF7LMJsfaNoDymrh1bK3warSyxa/om9ey6vT6zhKnLfK2bD5D1jQacMxRZ4/yFKZGlK52SEQ==@kvack.org
X-Gm-Message-State: AFuF++nZ3T+k90PcScZ/mkdXz/2MoTFiek+Qv+/Rp1jcxwbswITLE87T
	5yCrOpFzePSEhwY482Ih4m0DtZXI9fPMG03xTX2SnEd8pNK8DW0LufYk
X-Gm-Gg: AYBFou2hMopP5tzEf9lpwuB/+2HRELMFT0sBXD3ogXOIufkawrAXPcM83nKNaIJEG7X
	u3fKVDdMWFVHg1BRnPRpoS+PRc5KSG/9wFkcFe7xkflWw+h/8AWoCB+H/mwm9b8zjg5q5Shl0Jq
	R0UoFYau37hxnQlPBIfx8WSbEQftz9xz/g2Wv7Q6zjvXL1Mf0Rumin3yc9H0dJz3Qr3kmpOfcWS
	g7t5RSZDYYq2cgs2HgVk9wVvaSm0DTOckrWpN0JxSYTcVzR2hx9Dwlgtyme9sMmGyuInYtFA4pQ
	jJ+CZwKikuBWI42nxTQyO6rk2I2SP/YOdah/lDgZc3sBTXkrbfAFifh1/SxwzmBF8SwjDodVh+2
	7Oysz7gtKUzUoqjRnxgjmdsA4Ek3NhwLvhvzAS8U8d2ZpVc+hV+y6l6he93yk0R18/g2nGH/3Ad
	ftbUpctWuHluFZz7OvcQOiSMCieFgJD7Os01o=
X-Received: by 2002:a17:907:d1e:b0:c29:cf4b:5cac with SMTP id a640c23a62f3a-c2e23749268mr150465666b.5.1790781371662;
        Wed, 30 Sep 2026 08:16:11 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31ce9e4fsm21985066b.31.2026.09.30.08.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 08:16:11 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 30 Sep 2026 17:16:08 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org,
	chleroy@kernel.org, david@kernel.org, dev.jain@arm.com,
	jiangwen6@xiaomi.com, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v9 07/10] mm/vmalloc: extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
Message-ID: <ar0nuJ7ocTMgbiMu@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-8-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923062832.479455-8-jiangwen6@xiaomi.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: rs3gwepp3i67p3e9k6gi7rnczzitrhfi
X-Rspam-User: 
X-Rspamd-Queue-Id: 33818180007
X-HE-Tag: 1790781373-323094
X-HE-Meta: U2FsdGVkX19edDUBEOICDlfYAWIjTTAWPBX0036DKpf7GcActRXTpz2maLSn4mmqtV2YOXf0XknaQj3KVTbicpRrufFflTKFBJLZtbgpQj8lmJB9k9JK2WOV2T0X/HUjEBtJjOiia0rqeu4ICkFvFcPQiXzuH3ZMlrcIBOcWbQGsUsLnWBwxaPj1kHCMTEfcTY/WIDLWixMuI6juF00Ht4QyF1hdAJoIqBhCHPrN1hjMrNxDTm0lzEusnDkGrimGtkui74iRzH1ba1uBpgkikCatuF/wejb16Ey+FNZla210otidh9Dh1GWPSYOch+LcPitSJDJevEogZrClRGkPqYMSfNqYdCJLo9WS91zTh9KblWE2bc/9/NvFzK+eW14srFihZDXAK1rxcRBo2Ag1+cixXslLgnxNGgIzWU1z2kooXTscs3BtmQn62sb2uhEVLMjgoww0y4sN93KAt+EmGGnXRMOhWFnFTJ63GbplBxjIYmLFlF+i1u45RE4NdJxyTEyHZhHhzYF+fftA045n/7baKBMxX7XCHvAMi9YQMa4Z7bd34HdevrliPP3ReYwj+9ZTBh68vMkFZmQ6S2SZIqdbArMHhtayX66s85DQCTtKSYphZlVUql+8Ag+hIX0f+eoZZTctY+P4wvdV2ABIS7lJySJ7l0FEpFespF6vlggTudByiPBZljS5FhfJU6wQQt8Wj2CGA1zmh2Sryml4mSTepdaM6STx4x9lquUEWX8Cq+TsRhjj/zDduJ3sGokJ+cLOk754zxNcUtTjR/xKyRYM3bsOpm/+kKORy4PbabsPsaTl94ekCDjZOpBalqxtIL+u28z4DVmSxRLt0ymXlygFxtct+ZE+tY4Z8X8kCxDhdbSmWWl479pSpDgzAJQk2wwmTWfC3Dllq82kBsRdGmpkRkFYgmc6pTdghppR8IgATcpaeLNI1OIwf/PAPAmTN4+XTfNce8p7TMnzA+e
 Ew8dqYvQ
 UocwKZhPFDflbKYGOGc2zAkH+vzTTXihO4LZ35M4GRC4pBw7R7Q+iPavhooM8QFeG6yKCOkbHuNhAPiOsg8QNsPuTrDovo2D+O4GDvz6rkvYzKl5amlQrLvBZmJEPmwLoNL3OWxU5NCxO9y9Ub/cgQUF3+Jd6eV6P0r+8noqMG/1A5WUw19BVOyqnB/qd8DhPYqZFHL8YN5dmHeyMaA/JjKAwbNfUXcUlGPfsQhuK90NjFr5D07efGHmfGsbya2tccVWQIbZvhLi4dBuBPwdBCOBjF3+EPN9CKaSIFYTRjilAJzRHkoVioi1WTvjW2cXW7VtS2FjS/aU6CkR7kCbC7B8JrqkPxc16MPJ0uwtjl3uv0+OLAcWSqbSM1zL2A4ycXjn1XHjWkGzB0vvcL3KnkVJGzj0Qw+qmsYB1cJref5RVYzxY2Nal/qLCVijbPODFEeT3Uf3jZ73FvxG7WcLSlsNmAKBMEXw4YUjsLZLtyBvbJJN1Q1ct8BqWndKhZ6Lnuo1B32IMoNpRWN4UF/sIgIJogOorwwVitV5dTrH7+hFGfSVvfwOdpnUDQ/o2OZisxrE06Dsl6GuRaf+KjHX7GxHusVFrVNS2ZzFTajpxc5/9g3Ly/iw0rvbP2OAqC2fgtXk8ddPFjgqbxbtNv7pangu46Mj+YwJX8y+YtIJP2vYFn9UcbyxURbseDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 02:28:29PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
> provides a clean interface by taking struct page **pages and mapping them
> via direct PTE iteration. This avoids the page table rewalk seen when
> using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> 
> Extend it to support larger page_shift values, and add PMD- and
> contiguous-PTE mappings as well.
> 
> Rename it to vmap_pages_range_noflush_walk() since it now handles
> more than just small pages.
> 
> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> iterate over pages one by one via vmap_range_noflush(), which would
> otherwise lead to page table rewalk. The code is now unified with the
> PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/vmalloc.c | 84 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 50 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d475e52110e4a..6e0dec73107a7 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -558,8 +558,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
>  
>  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
> +	unsigned long pfn, size;
> +	unsigned int steps;
>  	int err = 0;
>  	pte_t *pte;
>  
> @@ -590,9 +592,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  			break;
>  		}
>  
> -		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> -		(*nr)++;
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +		pfn = page_to_pfn(page);
> +		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
> +		steps = PFN_DOWN(size);
> +	} while (pte += steps, *nr += steps, addr += size, addr != end);
>
nr_mapped_pages?

>  
>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;
> @@ -602,60 +605,88 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  
>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> +	int err;
>  
>  	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
>  	if (!pmd)
>  		return -ENOMEM;
>  	do {
>  		next = pmd_addr_end(addr, end);
> -		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> -			return -ENOMEM;
> +
> +		if (shift >= PMD_SHIFT) {
> +			struct page *page = pages[*nr];
> +			phys_addr_t phys_addr;
> +
> +			if (WARN_ON(!page))
> +				return -ENOMEM;
> +			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
> +				return -EINVAL;
> +
> +			phys_addr = page_to_phys(page);
> +
> +			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot, shift)) {
> +				*mask |= PGTBL_PMD_MODIFIED;
> +				*nr += 1 << (PMD_SHIFT - PAGE_SHIFT);
>
*nr += 1 << (PMD_SHIFT - PAGE_SHIFT); --->  *nr += 1U << (PMD_SHIFT - PAGE_SHIFT);
as it used to be?

> +				continue;
> +			}
> +		}
> +		err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift);
> +		if (err)
> +			return err;
>  	} while (pmd++, addr = next, addr != end);
>  	return 0;
>  }
>  
>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pud_t *pud;
>  	unsigned long next;
> +	int err;
>  
>  	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
>  	if (!pud)
>  		return -ENOMEM;
>  	do {
>  		next = pud_addr_end(addr, end);
> -		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> -			return -ENOMEM;
> +		err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift);
> +		if (err)
> +			return err;
>  	} while (pud++, addr = next, addr != end);
>  	return 0;
>  }
>  
>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	p4d_t *p4d;
>  	unsigned long next;
> +	int err;
>  
>  	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
>  	if (!p4d)
>  		return -ENOMEM;
>  	do {
>  		next = p4d_addr_end(addr, end);
> -		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
> -			return -ENOMEM;
> +		err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift);
> +		if (err)
> +			return err;
>  	} while (p4d++, addr = next, addr != end);
>  	return 0;
>  }
>  
> -static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> -		pgprot_t prot, struct page **pages)
> +/*
> + * It can take an array of pages which are not all contiguous, but it
> + * may have contiguous chunks, as hinted by @shift.
> + */
> +static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages, unsigned int shift)
>  {
>  	unsigned long start = addr;
>  	pgd_t *pgd;
> @@ -670,7 +701,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_bad(*pgd))
>  			mask |= PGTBL_PGD_MODIFIED;
> -		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
> +		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
> @@ -693,27 +724,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
> -	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> -
>  	WARN_ON(page_shift < PAGE_SHIFT);
>
This is not about this patch but probably on that WARN_ON we should bail out
early.

--
Uladzislau Rezki

