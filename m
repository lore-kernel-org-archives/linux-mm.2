Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDA5F34C64
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D974E6B0088; Mon, 13 Apr 2026 12:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47EA6B008A; Mon, 13 Apr 2026 12:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E716B0092; Mon, 13 Apr 2026 12:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B286D6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:08:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E55557356
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:08:35 +0000 (UTC)
X-FDA: 84654015390.04.EC67EDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6D335120010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:08:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sLgD6aLf;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776096513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvQ9j9MGoF9KJJFAzoRgrZyKdKTqB5LaNool0Iuh4YQ=;
	b=2bRQIAVAVIALtK/PF7Mt+8+u/rYNWxfXoFJ9uF1AwIymBLUjmDRQ6H4tZcqrjOqbCBhrbj
	l4cK5fEISvf1aAhG7yTnmKlryxPOCA6KXkMSW0W+cVgHgOD98bIf7ITjnn273KqUeMzd8Y
	Q7ljGIGxJOQayPWSjn8C3YCesqKuBJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776096513; a=rsa-sha256;
	cv=none;
	b=n6G9lFNgp7E466hpOkHtqeELCefPd+Kt0JRPLxpP3BFF0xXVI05TnZ8RbDBCrYMVd3MMXK
	yuvY7o0PxdIveP/dS74EaFGpyThiDUaehK0QQX9O5twwqDAadEq97RGnROu4K/RQsGrt29
	FGAYpOzQ1BwYSFdF1Q8odueb1254SXk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sLgD6aLf;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CC4861336;
	Mon, 13 Apr 2026 16:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA7DC2BCAF;
	Mon, 13 Apr 2026 16:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776096512;
	bh=d825AxCCibvEeW1TS9m6BI8YXTIqv9i5TOVSoBg9bsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sLgD6aLfOKT7I8UT9/pGuAtkMNU5pKGEL+PmzpXyknCX2JRD/MRLmW2OFA1NXCBV/
	 pdNzou3dwWx0Uip+kPcPhz6Ssaf065a5j+vm67Z9UbAeN3SMeG3pcalhKpRgi5xE4h
	 1/LYDpv7k8YMyKW+DJSNTmXqViWmyKOxRAw0fif2wbom7DHAAXR91i795M8Rg6OZfo
	 /y8nJZdclPaiVSHaBYwKR4PnasxsqZSOP1HAXlsxAmobUCVQjz7yEmlBOzItOprJed
	 lxWDMuCTHJcoMzIAvs8Mb1YriQKypH1b9btDAkpEUwwe+0zwS4eImaEcqa2TmbCJlT
	 ubo+kfd4RY8Cg==
Date: Mon, 13 Apr 2026 19:08:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com, ryan.roberts@arm.com, ajd@linux.ibm.com,
	david@kernel.org, Xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 3/8] mm/vmalloc: Extend
 vmap_small_pages_range_noflush() to support larger page_shift sizes
Message-ID: <ad0U-IEvZkFwpBsg@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-4-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408025115.27368-4-baohua@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: 98oaahu3x87aimcg6swzoq6sn5kpotkn
X-Rspamd-Queue-Id: 6D335120010
X-Rspam-User: 
X-HE-Tag: 1776096513-133702
X-HE-Meta: U2FsdGVkX1+8iE0AynnqZEEWiFD+kOfEunt8PvLVIyWbfUQgRe0a8EeOMtKed4hgvXwPwylmZzUbqaEt5ERSeC0XAUm7ktkiy6gukcvsUuvuoH0gP9lQu8+M3p6G2elgSJs34Q4nFFb3HyNZdFtTC882zWZ2ozwHE+xhYYx/N16TfhejkLvvWd6OzCDrFrw1Hs6GN/ovq3+Wlrm304gvBSwp7/wSfbEFab9AaIU2DFTyAhYjkRaeQgs8V67HKzj6OtfJS36ZU6VpQP0toIIFAs/k1H8xGx06XzBo/pkvQ6SfEAvkm8uoAE0/FfpvpkqnNuaXCXlrnysEmGfT7hW0LWqpSQ7lc/CROVovw2wiRwI1gwMV3HrIA3quzimh/1iVzFNGFNHXNIF7STMu9Izq576hUro/OkWXgC/9T40x42CHf8oNUrt9DS+ZNuGS4q7jm1+4dfv1vK3KWHfa1KgBDQQBa5QJemK7v8y+3+Yzg2uMSJTXvBMrKtFAJlJoJRf9C8CEIddVE1DFR1EdIKHHV87RlLUFnDpiPfN7MB/V3Sr8VgVWYJkkAXfCKUu1sY1XQQhoTMBjaVcPvVE4CXoksmwZZSAm6FsooSaFuqSlpSOWRPgpDZ5u+MRPu80lY3ErB2Z1pL6wiY/Ljh7lqpCOuxngoGCG9Ncb4DyGzlmqIw5bw0OBy+WfknodhrYckOBxbgkK/FCBu85g/kgxapohm4+1s4OJwgnY2TxJvY58tNazB64XiXMFFlW6IR6SKj2aBiq6PHG4jcX5RaxarI+1vEYXb3M33vDods65wPcRnFtVFWVcYCr9MAJvoc7fK0qHKZjHBA3n4xvm0x0VDUrz5NaGBqsS+yf0r1P/8fyj87RBshiGBVcBfNU2FRqzfbdeZRRJoG1D83r9LorGguuQCAIzROFpJ89Dy88ebvVCb1pJi+ALdOXF1H0b/0KGse+Gq1CxTgCX2SWtYk7MYLW
 lJXH6li8
 vzRJSe4P5UNSwhdCkEAjnIvDypvrUuGZGEeDjgVSHW8tAPBTGag2d0QKdaNv3Ujq2ev8Qws0/3ZB3yi1bl15Y4XA7Lyima/4U3nzlsSuoaNdd2T4WzPpxV/XHJjBUsC4wxND3FXQfOMbpxdRgVTKhs9Dvb9VoOuDT9j2C8n/yfDw1l6lBlbE4gQsZRiRpEyEt40S79Ynlm7BR7CbhPSPRkwr2gOs1UCIs9iVZ7pWBTGp6omUnGPkCE2uqC/kHs2duL+4PBI1ncv+e12AR1s+6LKkhf9RVco6x0gDDqJG2tPAAEXLD8yUUY6rHBHk+V2D+sgy6zrGvhYLjjhJ8CUUrhLnSuYBQPkpmo+svzPHaKS6N5oCxriyV6R0+2NswcUkx/GgVsN4sMLh53fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On Wed, Apr 08, 2026 at 10:51:10AM +0800, Barry Song (Xiaomi) wrote:
> vmap_small_pages_range_noflush() provides a clean interface by taking
> struct page **pages and mapping them via direct PTE iteration. This
> avoids the page table zigzag seen when using
> vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> 
> Extend it to support larger page_shift values, and add PMD- and
> contiguous-PTE mappings as well.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmalloc.c | 54 ++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 57eae99d9909..5bf072297536 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -524,8 +524,9 @@ void vunmap_range(unsigned long addr, unsigned long end)
>  
>  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
> +	unsigned int steps = 1;
>  	int err = 0;
>  	pte_t *pte;
>  
> @@ -543,6 +544,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  	do {
>  		struct page *page = pages[*nr];
>  
> +		steps = 1;
>  		if (WARN_ON(!pte_none(ptep_get(pte)))) {
>  			err = -EBUSY;
>  			break;
> @@ -556,9 +558,24 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  			break;
>  		}
>  
> +#ifdef CONFIG_HUGETLB_PAGE

Why is this related to HUGETLB_PAGE?

> +		if (shift != PAGE_SHIFT) {
> +			unsigned long pfn = page_to_pfn(page), size;
> +
> +			size = arch_vmap_pte_range_map_size(addr, end, pfn, shift);
> +			if (size != PAGE_SIZE) {
> +				steps = size >> PAGE_SHIFT;
> +				pte_t entry = pfn_pte(pfn, prot);
> +
> +				entry = arch_make_huge_pte(entry, ilog2(size), 0);
> +				set_huge_pte_at(&init_mm, addr, pte, entry, size);
> +				continue;
> +			}
> +		}
> +#endif
> +
>  		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> -		(*nr)++;
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +	} while (pte += steps, *nr += steps, addr += PAGE_SIZE * steps, addr != end);
>  
>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;
> @@ -568,7 +585,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  
>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> @@ -578,7 +595,20 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pmd_addr_end(addr, end);
> -		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> +
> +		if (shift == PMD_SHIFT) {
> +			struct page *page = pages[*nr];
> +			phys_addr_t phys_addr = page_to_phys(page);
> +
> +			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
> +						shift)) {
> +				*mask |= PGTBL_PMD_MODIFIED;
> +				*nr += 1 << (shift - PAGE_SHIFT);
> +				continue;
> +			}

With this vmap_pages_pmd_range() looks quite similar to vmap_pmd_range().
Any changes we can consolidate the two?

> +		}
> +
> +		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (pmd++, addr = next, addr != end);
>  	return 0;

-- 
Sincerely yours,
Mike.

