Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FACE8784E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9306B00A4; Tue,  3 Feb 2026 12:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95CF66B00A5; Tue,  3 Feb 2026 12:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8574D6B00A8; Tue,  3 Feb 2026 12:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E83A6B00A4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:03:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C6FA1B1BE8
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:03:13 +0000 (UTC)
X-FDA: 84403765866.09.4B4338D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6FFBA180013
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:03:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pmq5xLiG;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770138191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xg78Zlzv6tCd6rDkroXjM8IGqczSTy9xWZCY17OaMxs=;
	b=YF+DogcPjHvwPnL66PnlX1Qy+b5Ltxc2mcYPurmCnAt/IVNsAc3OI3QVwaeS3CFcj3Bxzy
	tdcjUmRIQTtUmO9yWUk2cELJlbCP4KpQ+KxfHVQ0WTTA+LTws/54fXppfsrpewgFTtPR2c
	x0lZQyiVrITYN9KPtlyRWwY3G8dyCaU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pmq5xLiG;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770138191; a=rsa-sha256;
	cv=none;
	b=e7SMrhOOP+LASaoOyZpgYkhwYxXV8bAkIdiqVLW+KgslL15XhxYeGx00TGMH/bTMdXaUG3
	vKOoSTny3H7k0mfqjHIm9plS+Wvu2EehPNc7M0ET6s+MA+kCBY0Nw0IWcIbGogmcIj6pwI
	eFItl2fFcYZNsWh1613o/QKRzk38Rec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B3627601E9;
	Tue,  3 Feb 2026 17:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D29C116D0;
	Tue,  3 Feb 2026 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770138190;
	bh=lzqVUIL/GcxvLpsHi8mMj4ZXKGp+p6qejMHEKZTTs1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pmq5xLiGQ2Czpjx1R1Ehs1xzVOdvVr+bJrRlmjHMX6D59vEEdkhzAFDwvDZsyrNAB
	 j4xDnLid4B6JVHIaY6/hjh5ayHBKd5es08d/4fXgiN7CTbwAPkckG3IfO3zS5kejaY
	 xquLc2+M/lp65y2NQv/ybC5ysovD/bjmsziVormpZEIsPR53n8LFqDL3IpO8NTrA/I
	 XWbqy++n7VuJrjtsvH3Ry1uGFoByDNmWZA2v7kcW+aaQiGiCze5DpGVhRAZs1uzDrr
	 yf8KyYsAM/OV1IWhZj59uV3c35Q4s3L6braZT/iXPd0aQDHNhpn0YKGSXwkRpdLN3f
	 rCxNJxnapcP4Q==
Date: Tue, 3 Feb 2026 19:03:03 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 1/3] x86/mm/pat: Convert pte code to use ptdescs
Message-ID: <aYIqR4Nh3sHfIVko@kernel.org>
References: <20260202172005.683870-1-vishal.moola@gmail.com>
 <20260202172005.683870-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202172005.683870-2-vishal.moola@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6FFBA180013
X-Stat-Signature: 3xqmzywud75njpt86ggfmq7nmmnxzw5d
X-Rspam-User: 
X-HE-Tag: 1770138191-720233
X-HE-Meta: U2FsdGVkX1/4/1paaptzJSpfJEGi6Tb7mxX/JiANPoHpmn2aEnC13zGM8v6b7uPhv1lqeeD6pYTffF+YCeiD8H2qYI1231RPxH5Fxh0ksi3uFArrdG+t+ISnoHX/TO4Pg5d2qGZgeDYHKerqVH8MgjUNv953+SrrRrc/koETlQSkQWLFPoi5GSsADWnRDsrKQrzTDyA7IehMD4Z+E4J1kJU4Ga1qoaTRFjJGDYhEG/vKjWqkrxiOiM31N+HFKaa3jwuf+aJWHt8XsPJ6qApEtwhcALVOd5te6YmZ8eIuRFapdevr8qVB7/GYHS997NGAbD4114Zf31l7VtjgA/qQdy5SznhSzKxRwyJbLRdvGRoQFrDHJjNAGTmGvY87GapXzqodx9l/1WMu75oMvrdShIj/ZHSYoKh2wrLBUPMD4ihMkoipVF1l/KANtC2PSYUllfl3pTAJFfs705U4TJ9Vp1QphiqHCDLubEk8xwx8TZ0nfAzmsNKANeLDCed+Nm9ErVNUJq/vRnIxDtH/tQZSxe1rrgZnqwShQfVNmJfWM1ELUm1iNl+oMYkwb7zPkEk6K1y+lSrgr10nW/uptEoGCG6ncNIXcCL/ok4FK/UIIPn6OM/W0gKiKltSuo2rsxle+ELtvKf4e7L59jFt8J4fw0f8NlV2/0SNM+WDzVFStevtVC22kjmHgREVIAnsvHQO5NM1KikrkaEBlVhkKupaC7GONh3UgIlXeC0b2OUoRvYcTtkymT102tWQoGq1VpG4fs8m5f7MGXjNcKUF9gvkZzBJ7ptCNo400WHegyUZIEYm7ACG0pyHULWvX027zoxBZ0C4Y6uWUxvt8AEbXOGo74umQI6S+lJmTmnvfMaAs9dYG98EbVRmQKFtxjflyRQqJLMgOZvKbY46ZwUjJDs7P7gn1XztW6g/kbRNhN9DmryHMahBpOVZDw7qogO4BEi2PrQYufWxlvBBWCwYKUz
 D/iQjTVq
 LiigVl+jmp+cihThQuQTorWu+iPUB1ygTVexkC7Gxdnao6/j6Aam/W2F5GmiNOMvmK1raOoK5KLvTUStXy+xKY2VXENB5KMxU3rxxF8hySZZIAZWEac1gh5k5Tw5qslCrAUa+j5m6p1aWhvajKUPE77sIzgeBnIXXz5b0muANdxaGY9zDftIhi62mOViszxPv6o8GYCUrakpQslFVslI2ATuBZjIJ9lnn9UO3lckBUl7tlbo2LQ0NO+GW4eJdG15xnKm7+W3sTO8GHiGVTZVU72vF/mOr9sFvLRVW1rbw8xpnzPEsoc8JzIatqt8sUwuBbmuJz6n+fAVrKLIVgV1pwAAxQeeHP/YnY9qa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vishal,

On Mon, Feb 02, 2026 at 09:20:03AM -0800, Vishal Moola (Oracle) wrote:
> In order to separately allocate ptdescs from pages, we need all allocation
> and free sites to use the appropriate functions. Convert these pte
> allocation/free sites to use ptdescs.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  arch/x86/mm/pat/set_memory.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 6c6eb486f7a6..f9f9d4ca8e71 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
>  		if (!pte_none(pte[i]))
>  			return false;
>  
> -	free_page((unsigned long)pte);
> +	pagetable_free(virt_to_ptdesc((void *)pte));
>  	return true;
>  }
>  
> @@ -1537,12 +1537,15 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
>  	 */
>  }
>  
> -static int alloc_pte_page(pmd_t *pmd)
> +static int alloc_pte_ptdesc(pmd_t *pmd)
>  {
> -	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> -	if (!pte)
> +	pte_t *pte;
> +	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);

AFAIR, x86 folks like reverse xmas tree for variable declarations.

> +
> +	if (!ptdesc)
>  		return -1;
>  
> +	pte = (pte_t *) ptdesc_address(ptdesc);

No need to cast void * to another pointer type.

Same comments are relevant for two other patches as well.

>  	set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
>  	return 0;
>  }
> @@ -1600,7 +1603,7 @@ static long populate_pmd(struct cpa_data *cpa,
>  		 */
>  		pmd = pmd_offset(pud, start);
>  		if (pmd_none(*pmd))
> -			if (alloc_pte_page(pmd))
> +			if (alloc_pte_ptdesc(pmd))
>  				return -1;
>  
>  		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
> @@ -1641,7 +1644,7 @@ static long populate_pmd(struct cpa_data *cpa,
>  	if (start < end) {
>  		pmd = pmd_offset(pud, start);
>  		if (pmd_none(*pmd))
> -			if (alloc_pte_page(pmd))
> +			if (alloc_pte_ptdesc(pmd))
>  				return -1;
>  
>  		populate_pte(cpa, start, end, num_pages - cur_pages,
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

