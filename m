Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34FB8CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 13:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3176B00A3; Sun, 23 Nov 2025 08:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B776B00A4; Sun, 23 Nov 2025 08:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A0A6B00AA; Sun, 23 Nov 2025 08:17:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC9116B00A3
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 08:17:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 747365BEDC
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:17:47 +0000 (UTC)
X-FDA: 84141924174.21.68B6372
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id CAAEB120004
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:17:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O2K+aOH8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763903865; a=rsa-sha256;
	cv=none;
	b=gsLZJQBEZ9ttEeu0FoAOibMtifw3JZB+3IeWvAreAmRqlYVrfVxwikba6SPlodL+UV3Ztb
	ZX21IMSRf/5Jgt4/Ijrw+Cq5mp0sTJFqIZ95QOcvX4dn7XV+bE0pqHaHY1T1pEZF10Axvy
	3RBKLeAoayv9Ylbzueow2RyDRs80Fkg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O2K+aOH8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763903865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAXRkB2xS6mb56eSq0W4PuVYF2h+LzFqM165H/0m9hM=;
	b=S4DfzWvzpZWe5x4TgO8glDk7fGimh0pRAzDfQohMDzIbj7ulRmbC7ATsjwmD6N8OVgGs3o
	T7W23TfUWgN8/uY3xNqpv/X9rpUsSpRqCK5E2bx0qyRVSscTYAM0Q0Jcotd1EEJ2G6Gwdy
	FbVNyJn3MzZvaJGHKNotAx/3xUP4c1g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D59A5601AA;
	Sun, 23 Nov 2025 13:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D44EC113D0;
	Sun, 23 Nov 2025 13:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763903864;
	bh=3UH0sUpcsTOMjRwBlMwUCGFDDjKFaDmhv/y2Ls/sfXU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O2K+aOH8CH0SgIG5qkAKVKBBGA5eKkh3RnxoxnzDXEB39VO7sKffUoMENpcavfnps
	 +3G108dSrTGGkK6l+sHK5SKGat8idVDagp0VLT5RFHAN4fx8SD9xp6nsE9kHmJ1m7a
	 yB60iAQX+2i7FuKGFtIOYh3O3TuWeYaowik+X8dTX6bahRATEELN1OSWldkowv3z3X
	 xvsInynJh9iB6iwgTkJ1D2RULkuryOUftJ45zxbHXQ2h9lZVlqbuh1By4UjoIbMSve
	 nvzKjQAeLIBGnEpTyAZg6rfoxw92k+s1mS3FdNTPNYWCvWa/3LuqDctZy3TbpWYmUP
	 o0a4RG7zYDYQw==
Message-ID: <10a90b15-3e26-451a-bebf-f7ad8ba67d1b@kernel.org>
Date: Sun, 23 Nov 2025 14:17:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/7] mm: introduce clear_pages() and clear_user_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-3-ankur.a.arora@oracle.com>
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <20251121202352.494700-3-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CAAEB120004
X-Stat-Signature: cpu7hhnmop8xedx5cuh9zif9f6j3y1ga
X-HE-Tag: 1763903865-689902
X-HE-Meta: U2FsdGVkX18gGNDtRY6pd+22erAhIci5ZmG1kBN/YOZyKl0P72BTgHDhutxKDujsVcLBcke6UDj4MHew2paNTghw+P34OmW8gKU5Xoa1mI4y/1qmT7tiAxDllYHRaCX/9fFjjlupwqtgIi7OPEe7i8N+y8IVHDrrepja1ZCAsf3buhuGAYWgEz8gPp2488w68bf8hlTB9WcNdh8FmDx3Q32QwuFZ0enE8FcMN+0Ibs7apEi9AUCzmTmSB44UGC6nKdzz3FW+dK/azFtkxaho0ba6mp2JhtViY6ZN6WtoqMp/xaw/5u6XE3nzWhrikTWIDk6xLkoqC7zQXq1j2rxnEAQaiMRcAf7t/J9ltBOJgty1+CNdNArLgHOPiZtoTItDpk30r2GSFCGX/+ongZb7PhWfdSErg94lxZJ5DziZWsR8CRsu/7CHW6xhrOSYBs7T84jwdd5b7TcBUBPYYomEzwEsMpldBFjuzYwWl9tLqeA2D09EhbeIcsd00YfEmr1d06U3bAK/fOhCeFfFQuAc/H6HS1A9wzLXAIJltU92qDxnzmZK1DaP3ErE9ml0pmkkAkWKL4+WPE03C7lZ1/cTaLKOWP6gd1JRgBzid4VeLlGgSbvIkrbilAK5AmuqgOO5XsIra2Q3tiihvYMCr4Ri6U+FLobyAvcfknJWX/FD4fdmV84QU/SQ/tvQlmi8hQqnwi8nsWNInCSKB7iWV/VAfa8z8oV6+fQ4EcYhP9qU/a6PEFHmw2vbINs9cM9ciV8yT5VL/XyOEXRa5Yul2j0AjKa2ZhfBsqgseW6ClTs/FiGtCo0GJ7hPVbcowJmBf6Vd3lnmWcgXEcxAf8GaaLWOKk23IWKslLKeBDaOcbv8y5P2ePmYKXAFOKqtZtzuSeAcDPir1dZHx3VbSklO3RRsssuoL5nOyT89RlklTamNJgnrnRgZAtSHWC8YQ2u3HVTUyiRzETftpV8cWSS6NWm
 crSXkA42
 MVqTNqoVsMhN14CEIzUZMIc5fsojfxdMqK/8l1T0jZsd/i0drCgwllaoz06Q+Rn0w/YzY7cU3+j3OdS44WSGKP1Yr2zfyzvSaN0FREThvWNhc1EsKMIcpKVV0vbaA+XyJnBf3JAuV055XT0DVao7zi5NHMehLmHYt9jTPU5CNN4MCnEJ24J/NVvjyBOD8oWW9Hd/occTPlKypekgTZ6k+sobPpZHvo8a8075MRTD/P7NewD3foVQYzf4uNL64wlI9KA1DdOhjQ8Qi8Yd9Ao82+6ogkfoB3CKMRCdd9X18fiROCair/jAtFoOQUERq+4J0rpCQwIcFqxP45+vACG2EJQwATi93dwsWU3deN7KtFasUc0agN8DOdpq9+uKAPpS0x/eRrzhRws0/kMmJ4OG8RZLKtP8pVYCACTVt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 21/11/2025 à 21:23, Ankur Arora a écrit :
> Introduce clear_pages(), to be overridden by architectures that
> support more efficient clearing of consecutive pages.
> 
> Also introduce clear_user_pages(), however, we will not expect
> this function to be overridden anytime soon.
> 
> We have to place the clear_user_pages() variant that uses
> clear_user_page() into mm/util.c for now to work around
> macro magic on sparc and m68k.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
> 
> Notes:
>     - Use macros clear_pages, clear_user_page, instead of __HAVE_ARCH_CLEAR_PAGES,
>       __HAVE_ARCH_CLEAR_USER_PAGE.
> 
>   include/linux/mm.h | 41 +++++++++++++++++++++++++++++++++++++++++
>   mm/util.c          | 13 +++++++++++++
>   2 files changed, 54 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6fa6c188f99a..c397ee2f6dd5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3879,6 +3879,26 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   				unsigned int order) {}
>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>   
> +#ifndef clear_pages
> +/**
> + * clear_pages() - clear a page range for kernel-internal use.
> + * @addr: start address
> + * @npages: number of pages
> + *
> + * Use clear_user_pages() instead when clearing a page range to be
> + * mapped to user space.
> + *
> + * Does absolutely no exception handling.
> + */
> +static inline void clear_pages(void *addr, unsigned int npages)
> +{
> +	do {
> +		clear_page(addr);
> +		addr += PAGE_SIZE;
> +	} while (--npages);

Why a 'do while' instead of a 'while' ?

Are you certain that this function will never ever be called with a nul 
npages ?

> +}
> +#endif
> +
>   #ifndef clear_user_page
>   /**
>    * clear_user_page() - clear a page to be mapped to user space
> @@ -3901,6 +3921,27 @@ static inline void clear_user_page(void *addr, unsigned long vaddr, struct page
>   }
>   #endif
>   
> +/**
> + * clear_user_pages() - clear a page range to be mapped to user space
> + * @addr: start address
> + * @vaddr: start address of the user mapping
> + * @page: start page
> + * @npages: number of pages
> + *
> + * Assumes that the region (@addr, +@npages) has been validated
> + * already so this does no exception handling.
> + */
> +#ifdef clear_user_pages
> +void clear_user_pages(void *addr, unsigned long vaddr,
> +		struct page *page, unsigned int npages);

By doing this you forbid architectures to define it as a static inline, 
is that wanted ?

> +#else
> +static inline void clear_user_pages(void *addr, unsigned long vaddr,
> +		struct page *page, unsigned int npages)
> +{
> +	clear_pages(addr, npages);
> +}
> +#endif
> +
>   #ifdef __HAVE_ARCH_GATE_AREA
>   extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>   extern int in_gate_area_no_mm(unsigned long addr);
> diff --git a/mm/util.c b/mm/util.c
> index 8989d5767528..3c6cd44db1bd 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1344,3 +1344,16 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
>   }
>   EXPORT_SYMBOL(page_range_contiguous);
>   #endif
> +
> +#ifdef clear_user_page
> +void clear_user_pages(void *addr, 

What happens if clear_user_page is defined but not clear_user_pages ? In 
that case it seems like the definition in linux/mm.h will conflict.

unsigned long vaddr,
> +		struct page *page, unsigned int npages)
> +{
> +	do {
> +		clear_user_page(addr, vaddr, page);
> +		addr += PAGE_SIZE;
> +		vaddr += PAGE_SIZE;
> +		page++;
> +	} while (--npages);

Same, are you sure npages will never be nul ?

> +}
> +#endif


