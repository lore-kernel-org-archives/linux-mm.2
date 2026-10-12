Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F21CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C8C6B009B; Mon, 12 Oct 2026 09:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFF76B009D; Mon, 12 Oct 2026 09:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE266B009E; Mon, 12 Oct 2026 09:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC6B16B009B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:27:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CAC41C480C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:27:36 +0000 (UTC)
X-FDA: 85314051312.07.A855010
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7D0EC18000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:27:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+BEp3hE;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqbvsZSYJL1Y0+A59bOb/XHgebVZKcusk4yArMBC290=;
	b=R9avNJ8yBfxKT8MlmDn5iOwPB/w52s1ay5QfDnyqLrDg9RcnjaSg5LvPyMtGFyVzruzLA9
	E8TQesGL7DqTsA7zt1h5ol7gHtBVT55CIKRuJ663buwD39Q+9d7DuBDt+mMbhn1OKDR+Xe
	MfzgeoN7cFKA+g6N6NU1JuzVZc0mHmQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+BEp3hE;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791811654;
	b=Qp7HYBSrcK3NeuS2w46ckJRBbZ/8uz9KrPBMfqTmkP8bk26esNH8J1htE6fM9pr4N9N2gl
	C60ejFfKDF//cC3GQ2Exv+uX6PCeDQFB0RMLBvKKOdpy9vwTe2VtK0l4PvSXtqegq/BLpt
	GRLnKvT+UDMuehw+FLz5ZaaMzxNhw8E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E003060AA2;
	Mon, 12 Oct 2026 13:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5781F0089B;
	Mon, 12 Oct 2026 13:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811653;
	bh=mqbvsZSYJL1Y0+A59bOb/XHgebVZKcusk4yArMBC290=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h+BEp3hED2E0t7oun5QTzPFxYlzk8K02LAR1RNB0ToQTnQqjgYdWzs+nzz9W9b2bd
	 bT+OPcuZJRbU/r5Mrnxzo8YX4VZBGdQciwtrAxOhNdv65GQ8YC4HA/OCpBnoQ/akS6
	 +Hoh7vNe8fF/PjR749ofV44TdW7pkptiUn/9DK/Rfd1s2lBf01ZVCkySBvkRbW+Lnc
	 zD10e1pIDa41mD2jHiNZ4rpC58X5vL6L22whLxjDivnC0RUGm3Zf5umuF5BNUORxSk
	 0hbvromI8XB3qlj1JlndvU0++4iSr7HwXXiuyxSBr3HYudxNDWcTaVHXM6e5Td8gQO
	 NM9DIcNwTjbsQ==
Message-ID: <919fcaa9-5ebe-4940-b4fc-59ea0c655ec3@kernel.org>
Date: Mon, 12 Oct 2026 15:27:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>, Dave Hansen <dave.hansen@intel.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261010112457.49485-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D0EC18000A
X-Stat-Signature: 5w5zp9czqph4t3rrd6egtdpw6yyi7ssz
X-HE-Tag: 1791811654-52120
X-HE-Meta: U2FsdGVkX18IjjnA+5AxJ3sRXIjLRqOGxluFYcdnc7hiwjZQo/q9uEPIPimNPrTL3aKYqy7rKcBIBBS5cCqlFIEhJi/YvnMfKV5YuNaNGrzAPlnIygHDvz3SqczprWuRmi2CSdmfsT2xJCq/JCqdimmbUuRkDavuG/4+t5s7Et3hvrZLCq41S4G1Gv0PuSxkOFkRgVkcjcIUhTZAUAQT8s6C3emW+woua+T9uWqyyya8irzpw2Q0pTEkERmo9ojfnGtuD8oul2mq/3eOYqE2E/EXlabsWo7gXz92WUqpGWVPJB5rPTmOTkPl0yjOKLh7j9jQ2FWBPcldjfoUYDzZdIjA8MG0PoPSVbApKDNQCZr45u6C082PCHUmq+DpxKW64lh5fCcd5uFvQJBFrlpOo7dV9Lr2wsl48VPrcDJ5NKLdc8RB26WSfHnHaK15IfSbXfq5S4znNophsKhVp8CgBYnAO1+F3R5LANq2Hl/RTlraBLq4R5KHpjDiWfrZND6B/Ae3XWLqu2tw3ywjILCUjz+/obY6ZgU4dwoTTzFBDAokFOnmDhLSbDHMi8fqyYbph8hBsUnMj5rriruV3eRqakezs7roYlFt1U6wcm5vxYcoBlcGqcNoCOQBhQaMAlCvdLMrPYeiqVsmAilnKJg/EaPmVNoDLYe6P04VMqZaZmjuglfYY24x+M4plPdlyP3a7xUcUNNkG98poK+z+Lxt8OXw9YVNO+L5L0jvM94gbOjjDRrgWX02FlR5tY+oIBr7IukEr+sv/qTDLmiD3PKtZp/X8CfQbu4na1OTzIYNZSz1jJJW5RubxzJcJDYQEnvHRxANgI4a+I6tY0s24jy3tkoTnaQDlNmBpI2/7y5I9rPrqJ3wfWpirjV97Fedd8JTKHk6GFedbcJR4vtXhIN7iDV6uWNZgC7rE2ssuZXIhZO73n3oR+1NzhME13BkbG4fEQKMEde1cNyg6lGAylE
 kNQ4Z1n/
 b6/KrBDtRItMonwxJNPatEiQUA87+Cdg2AAdE7uiHjfRGRaquO4qbV4Mer2muHhTMsurLMM1enbiAd6o/9YzGGHtqCsa4/PRcg/oLahrm4KxV7LTRoVPwG5dFTKnDU/b+5cNALi25FDt/YpqvX5rNrUPsfuiCxNjpj0B3kqVNxd0TeY/bmgHL/JTEyKxbFkVHEe2dsvxLbAkWOnkdCtv6xZAIRY0XFoT6SzM5YwjjY/L7hGJ7YD4aOWkvcaSBjKwcitCNbGMbmhA9fArxTADtgri6B2JM6Cu+ncGiFoirKJcPRILoZVtj5p/yzG5kVqAzLC/6MaXp1vxrsnpcDnXhtNMl19jMM9kY0FLr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 13:24, Muchun Song wrote:
> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
> tables.
> 
> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
> splitting a PMD. Restoring the vmemmap backing pages does not collapse
> the PTE table, so a later memory hot-remove eventually frees it through
> pagetable_free() on x86-64. That releases the page without running the
> matching destructor and leaves NR_PAGETABLE elevated.
> 
> Make pagetable_free() detect constructor-backed pages and run the
> destructor before releasing their memory to fix the problem.
> 
> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Move destructor handling from x86 into pagetable_free() (suggested by
>   David Hildenbrand)
> - Trim and update the commit message (requested by Dave Hansen)
> ---
>  include/linux/mm.h | 37 ++++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5cca90fc1df6..771a7d60b0a5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3969,23 +3969,6 @@ static inline void pagetable_free_kernel(struct ptdesc *pt)
>  	__pagetable_free(pt);
>  }
>  #endif
> -/**
> - * pagetable_free - Free pagetables
> - * @pt:	The page table descriptor
> - *
> - * pagetable_free frees the memory of all page tables described by a page
> - * table descriptor and the memory for the descriptor itself.
> - */
> -static inline void pagetable_free(struct ptdesc *pt)
> -{
> -	if (ptdesc_test_kernel(pt)) {
> -		ptdesc_clear_kernel(pt);
> -		pagetable_free_kernel(pt);
> -	} else {
> -		__pagetable_free(pt);
> -	}
> -}
> -
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
>  #if ALLOC_SPLIT_PTLOCKS
>  void __init ptlock_cache_init(void);
> @@ -4078,6 +4061,26 @@ static inline void pagetable_dtor(struct ptdesc *ptdesc)
>  	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
>  }
>  
> +/**
> + * pagetable_free - Free pagetables
> + * @pt:	The page table descriptor
> + *
> + * pagetable_free frees the memory of all page tables described by a page
> + * table descriptor and the memory for the descriptor itself.
> + */
> +static inline void pagetable_free(struct ptdesc *pt)
> +{
> +	if (PageTable(ptdesc_page(pt)))
> +		pagetable_dtor(pt);


We do have

static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
{
	pagetable_dtor(ptdesc);
	pagetable_free(ptdesc);
}

... can we now get rid of pagetable_dtor_free() and simply use pagetable_free() ?

(separate cleanup)

> +
> +	if (ptdesc_test_kernel(pt)) {
> +		ptdesc_clear_kernel(pt);
> +		pagetable_free_kernel(pt);
> +	} else {
> +		__pagetable_free(pt);
> +	}


This goes into the right direction. I'm still confused, but the less freeing
functions we have the better.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

