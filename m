Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01D6C5CFEB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED526B015F; Wed, 12 Aug 2026 07:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49CA56B0160; Wed, 12 Aug 2026 07:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364D66B0161; Wed, 12 Aug 2026 07:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E99DB6B015F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:28:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BE301202CB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:28:34 +0000 (UTC)
X-FDA: 85092394548.18.D50DE1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99C25140006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:28:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R770ZzSz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786534112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EG+9d2areJevimTNoL+CVRXPlsVq0h4r/7sK+coGE+g=;
	b=4N6BDQ8PxgAhnUGH1H8uiO38vLCIvHMmvaot12HwdsGCUMcglXwAPduKs9+Rj+/aU4Cw7G
	JNl+FehIRBLxNu0zhqbwEYSvUbt/lN8bC7337MeRricQO4Wf10ThbxNlN0HRTWcQkXbsi5
	xJ8Uje6BaPGqBlNUxWXX0TE5KxolZnQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R770ZzSz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786534112;
	b=lizqJKH6Fnfd4VKSbKmaUaqk/uvNSYPb6xWmpZY4iLP/sZxh5N49Hx17DUipEPKG3KgbW+
	Ioulm9SWICbw0BFj5BSipKqGVR/IoguXHEnEE3vj9fJVo1D29jIHzjiTeyqYPZMrN1b9v9
	AzrJWE+EHymSRnLcP5yh43tdYQS53dg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DFBD600E2;
	Wed, 12 Aug 2026 11:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022BA1F000E9;
	Wed, 12 Aug 2026 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786534111;
	bh=EG+9d2areJevimTNoL+CVRXPlsVq0h4r/7sK+coGE+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R770ZzSzgdG86/NXMage81wzUFeS0CV8TJN+FTy3GqkZs91oKKb+UMP3HprpsS0ll
	 0Wg7pTbwr86EN5F6uluXTEl+Pj1fSitU/XvpIx9ciPNyYlETh2LqI/+D2gDsppo6OD
	 yB0zB3DtxgJOAm/4vvR0MKlV6fDYEwT1SPtfC+hetiB9t/IGN6ZuTReZewi6NTenyE
	 vAMBpBqNVWCwPI0e2bxOG/EloArZkrD68ZAi1ERAwEkV3Qg0+K0lrcjS0HdYC6p9yB
	 G+Ls0Si3VJrq7ZaFnE4H1CBwSfg75sQl53X9g+96xUtYtDwT8TDmYw2qMhkU3o2aBj
	 CXwwy98HEtYrQ==
Message-ID: <28c24991-590f-4980-a92e-26c89288cae7@kernel.org>
Date: Wed, 12 Aug 2026 13:28:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 3/6] sh/mm: Stop using pte_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-4-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811042119.3652929-4-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: rsywo3txnkhy8xj4bg15ek35sb8u4drm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99C25140006
X-HE-Tag: 1786534112-177895
X-HE-Meta: U2FsdGVkX19wF/jEMFJ6M19X/M5HlfPSL0hHc08Dko2BCkUjLQYP7n1DJTwbFHC1ht/KPJS1VOaM4Cvy7q5zzdSNzHN2nzXhLPOwbcsIYAPujalCRrgBP/+Ier3aJnKWR9aqby8KPITox8WwE1ZSv24p+/hFzLukTUXEjGD8lIDP9nFgSe8Rc2sAHoo2aV/73SXMZ0YTTQafZGIgy7F5dQJW/vOh8KIIz1TPAJ52kFwAAqtq9e+G+ot29VX4KR4pwUjPwWaThKZPfBq+HfyGVYMW0pKcEAQAHaSPZQUuHfj8acu9sL7DZthE0D81gTSyX3hFkv8Bqx3qJmaprZWF5cHqtqpxlnWX5uNT29plbywOmY4NCznFYZkSmUHpoS4ZgzbYELeXz+PhjAOKXfKnCD666JIflm06i3XQRUlxeNK4P8IsWMCwVabKqGMg1gdxnN3+aoGBL9CcfBD/VZozFn450qVlGGfKjsQ1zJq6zI+sK+hDyPxk6OZXNAHQg/GamyPGzRGFq/BvC89+b4mnwrqu//scV70f82TaA7imFEn33ndEhzgaiYsv1tnXTrnJaBBrYp5+huJujJQSc8mpvKOYWL4Rv9Ctmmmw050UN1QJWmxCZdp5FXvUxlSwxhgZpzF0IK7pkdfh8Qoq3WdptFShpPJa74UmOqRZNQu+FwhPuFrCWUyrBHfXx444faoDVoV+3Drc4djBQVX1u7GBBsgAh2chjrgL1uQkJ6o2gyXoh7CsxJsZd8RDSRPLZR+zEiFZfFkWFshYwqKxl/qA0D+ESVWqeZOtYA48MXAcWs6e+febILLSSxqAs2gAguBMH9S0H85T39EEK6G8aVVH87LzVCFXkLAwQ5DDcUm4077DVrhWdEc3F+zLf8jWfx8tIjctFSNd/neOJujd2cQrxXabeWSTzS4AEmcSseX1nkWEAz453hpWc5/+T0Hvw2iPyDx29HG7hELZAUpYZw5
 emk/25qS
 DeH43/5WHpqhiQyTbBxx6RoqbzJVaOZc8NEDjN8JEjYdQ7oB0+ccMwlpl29Tfc8y6Dx40KY14BsDlIHvxJy0t68/YbpmevDZy+Td+2B4tirEDgbYih77Oz3m+UxCbCr2zGo/soqTwKkOlB6TqIZ6muxrheZ/2b2NgLsrHCRdsDZ2K2okjuZcAe4ZYPjwUVdZ8vSAomdpr70UZXajqIc9Pld5u6SXCmS/QjorIFQype3/XyNKvkX5Q+30l4ewJqDcz5IPMw63J06VYEjrPJalbpih5T7TESPeULDxJllonJnj9DywW8lgIZz9UaawQu+jO79PLWBLtrMF2HokB5v2wXUFZgaJFZ9rlSSgLr1dKPpZnPDIJMVRx7XjfIkcvmjZH2omOHukKBFsK4VNPjm8VlXG3/j3vW/5ls5rkCjBDnYaVfROgpRt2EwdrkCVY6Md5tDUKokOmhnWbPC0sKFGkvt28YNwbWKLBMSaSWVnBwAy1PBiI3PrBkaOeH/5S2SgbBm3FQCu0b1Ru4b8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 06:21, Anshuman Khandual wrote:
> Directly use pr_err() in set_pte_phys() and drop pte_ERROR() which helps in
> eventually dropping pte_ERROR() macro across the tree. In this new printing
> __FILE__ and __LINE__ has been dropped because they are always the same and
> don't really add any value.
> 
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/sh/include/asm/pgtable_32.h |  5 -----
>  arch/sh/mm/init.c                | 11 ++++++++++-
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/sh/include/asm/pgtable_32.h b/arch/sh/include/asm/pgtable_32.h
> index 5f51af18997b..c8eb9a7a4c4c 100644
> --- a/arch/sh/include/asm/pgtable_32.h
> +++ b/arch/sh/include/asm/pgtable_32.h
> @@ -401,14 +401,9 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
>  #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
>  
>  #ifdef CONFIG_X2TLB
> -#define pte_ERROR(e) \
> -	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
> -	       &(e), (e).pte_high, (e).pte_low)
>  #define pgd_ERROR(e) \
>  	printk("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
>  #else
> -#define pte_ERROR(e) \
> -	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
>  #define pgd_ERROR(e) \
>  	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
>  #endif
> diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
> index 110308bdef01..b3c7fd84ceb4 100644
> --- a/arch/sh/mm/init.c
> +++ b/arch/sh/mm/init.c
> @@ -78,13 +78,22 @@ static pte_t *__get_pte_phys(unsigned long addr)
>  	return pte_offset_kernel(pmd, addr);
>  }
>  
> +static void print_bad_pte(pte_t pte)
> +{
> +#ifdef CONFIG_X2TLB
> +	printk("bad pte %p(%08lx%08lx).\n", &pte, pte.pte_high, pte.pte_low);
> +#else
> +	printk("bad pte %08lx.\n", pte_val(pte));
> +#endif

I'd avoid that helper if possible, so we don't encourage new users.

Shouldn't we just switch to pr_err() right away?

> +}
> +
>  static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
>  {
>  	pte_t *pte;
>  
>  	pte = __get_pte_phys(addr);
>  	if (!pte_none(*pte)) {
> -		pte_ERROR(*pte);
> +		print_bad_pte(*pte);

Maybe similar to my reply to patch #1, actually print something more useful than
just "bad pte" ? And possibly also just use ptval_to_str().

-- 
Cheers,

David

