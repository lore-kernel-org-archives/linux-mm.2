Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE802CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 11:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4FC66B00A5; Sun, 23 Nov 2025 06:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00236B00A6; Sun, 23 Nov 2025 06:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF3E6B00AE; Sun, 23 Nov 2025 06:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA0F66B00A5
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:53:17 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 491944F9F0
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:53:17 +0000 (UTC)
X-FDA: 84141711234.07.91A3AAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6A91180008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:53:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eZ4SJBw7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763898795; a=rsa-sha256;
	cv=none;
	b=MAr0xJFMnfG1YjURujI7fEkntcrkchHT34kKJdv1j1aT4tBNeq/0vR8bOktt3b5ZajkxPa
	UKbv8PVHAAyzDWPonjyXrr1BaLTu0hdixqTa4lW/35UoaRl+G7xzPnpB+4VnSEDUf8Tchb
	P9zhzKv6kC7L1CpcCGK32eS3phvrfW4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eZ4SJBw7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763898795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QI+cHJ0MssIqTGZpm6o17wTBePNVcEgK3IklBROqujA=;
	b=uoVUXr3UQo1Ox1mQgUlTjzFnNfg6LNXtxm4TWJuo8m50hLmD+tmyySZskIDsE0kPMPx7d6
	JX8sHokVtTiTt+Wcr1D2jjTpngJaX6+eO09ir1++BvcHiQcjEj0wEYOmPp22qeyeTg9RG2
	aISk6WjnJpwlNslC7yuscdSSc6/4+SY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EBC440625;
	Sun, 23 Nov 2025 11:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA784C113D0;
	Sun, 23 Nov 2025 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763898794;
	bh=wxpdkaDYxQIyo5t/dwdCFKbHIbIlcAaOrc4r4NjwJzA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eZ4SJBw7QvTeJNUqGNKocSCXulo0iDES6F3pYOF34DTDBILBSvEObkJySh33G9Aot
	 /rQ1WmD4/UvaJ4YEH2zsRH77JsmHmriB60Fh/5kLEHJv3AGIJ6Du25TSY6puZrwf4G
	 v+VMatk3ebQKaWXVAZ+MHFYP8gvTMF/xBhFpJvWOsbu7XzS9ZVpB6FvSkfB0SZtqJq
	 qpKljlMf84fLH3A6zTNIFI8hk4oksZNSfJ77pkXBS6pT4n4U60lKhRQcFnKvZy7ZcZ
	 QUM1REs+EdlaX/1HfKSTP6kTrENAXkgCKbWJn0E11vWZ+bexVtvboO+JZ2quaBOc6P
	 xcRcxPY3qnisw==
Message-ID: <189bc218-8f19-4686-b2ee-5ddc6a0b4684@kernel.org>
Date: Sun, 23 Nov 2025 12:53:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/7] treewide: provide a generic clear_user_page()
 variant
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-2-ankur.a.arora@oracle.com>
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <20251121202352.494700-2-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A6A91180008
X-Rspamd-Server: rspam07
X-Stat-Signature: ngaqri589srctn5mdguw7igdi3rw18e9
X-Rspam-User: 
X-HE-Tag: 1763898795-207861
X-HE-Meta: U2FsdGVkX1+T13C0y9Ni0jCJ3C2jmf9macnw3vzITcwdp0S+cXUQRYC4XluZIpBfasKygSjuCsAdwuupVUoaozvydwYRKK7VfHy6jbRKItLPr3nsjqIp3I3NxXWKyP2LqNwoFMf4AvOBtiGbG7PfXugdxVBb4DE/Nbrhg8TqRehE0XzuMTjshVQS/SZuucD+l4j/lsqOlshSu8Gnn+ZDlwOO9xm/eJC+hF3qSVKllBgqsfWT9f5d5+oLEdUmgRUnL14KNAgxMi+u+c0hGvP7bDqF+7cZQnnyb7qzW6Us/ZMaUNHFmo9NI00o9OekX8FsFAdRoY3Pz4ceKd68dwyGI+9UQu6O2NPm8c8qEPhERx8j0hBw4qZq+84Sg6qHagO1M/xDbpSiDjoVh24cfiOckFpb/va34+W2ZUFe261NFSezLz5aAgyJHcdK+N7fHNhsMmpyM2AsTeJnPl44pzZGK/WSQqdcQL521rJeqyQuOmOrvh2JOk5uh/QDdXG3zogx7OgnI2Hr7PHqtascftJ0leNqbwlAoB1z6ESrLO2xadfDB3gR3ibKr6Jip/mXA+uomPsWwWmUpajmaV8XzZqaF+vPeRNtJuoRQgpuJCJS6ZRm/D8z1yv5nrA2jv7u5/Nvzi+3g7UyyWquDlyxc1vHuY1qlAjLk2YxOMaQIUHLMzh1QwujeJ4Op3QkYJUJKOtBg7esUyU83b+a36cAu8WVzdkRxvH5Pog1FYEOuF08PX1HVlkhLVuq7Kv+qXcBZtpR/yoHywsYFDIBVqw0n3w6SmLKCwVu/IRtn5GBBNnwBOOwRQkNdJgP6S7PQfpCOkYEJ3v3IeQsPsFAenffDXuvfQKS54V3QopM0XeMYglEYz8y/1L3txsLkBW0pHsOFcbtVhfLx3d+hjozMD77GrjX3SdgmYA2LpUAfTmFA0Oq2zwHKmIuJn1lmBT/1QChhra+J4iru5RNhHrtckc352h
 IQWcgwRn
 XKNOW0f8QKthaUhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 21/11/2025 à 21:23, Ankur Arora a écrit :
> From: David Hildenbrand <david@redhat.com>
> 
> Let's drop all variants that effectively map to clear_page() and
> provide it in a generic variant instead.
> 
> We'll use the macro clear_user_page to indicate whether an architecture
> provides it's own variant.
> 
> We have to be a bit careful if an architecture provides a custom
> clear_user_highpage(), because then it's very likely that some special
> flushing magic is happening behind the scenes.
> 
> Maybe at some point these should be CONFIG_ options.
> 
> Note that for parisc, clear_page() and clear_user_page() map to
> clear_page_asm(), so we can just get rid of the custom clear_user_page()
> implementation. There is a clear_user_page_asm() function on parisc,
> that seems to be unused. Not sure what's up with that.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>

...

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7c79b3369b82..6fa6c188f99a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3879,6 +3879,28 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   				unsigned int order) {}
>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>   
> +#ifndef clear_user_page
> +/**
> + * clear_user_page() - clear a page to be mapped to user space
> + * @addr: the address of the page
> + * @vaddr: the address of the user mapping
> + * @page: the page
> + */
> +static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
> +{
> +#ifdef clear_user_highpage
> +	/*
> +	 * If an architecture defines its own clear_user_highpage() variant,
> +	 * then we have to be a bit more careful here and cannot simply
> +	 * rely on clear_page().
> +	 */
> +	clear_user_highpage(page, vaddr);
> +#else
> +	clear_page(addr);
> +#endif
> +}
> +#endif
> +
>   #ifdef __HAVE_ARCH_GATE_AREA
>   extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>   extern int in_gate_area_no_mm(unsigned long addr);


Isn't it chicken and egg with clear_user_highpage() in linux/highmem.h ? :

#ifndef clear_user_highpage
static inline void clear_user_highpage(struct page *page, unsigned long 
vaddr)
{
	void *addr = kmap_local_page(page);
	clear_user_page(addr, vaddr, page);
	kunmap_local(addr);
}
#endif

And at the end this function is the only caller of clear_user_page() so 
there is apparently no need for a generic clear_user_page(), at least 
not when clear_user_highpage() is defined.

I think is would be simpler and cleaner to instead add the following in 
linux/highmem.c:

#ifndef clear_user_page
/**
  * clear_user_page() - clear a page to be mapped to user space
  * @addr: the address of the page
  * @vaddr: the address of the user mapping
  * @page: the page
  */
static inline void clear_user_page(void *addr, unsigned long vaddr, 
struct page *page)
{
	clear_page(addr);
}
#endif

