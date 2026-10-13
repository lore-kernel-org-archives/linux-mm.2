Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD8BCC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025A36B00A9; Tue, 13 Oct 2026 11:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3FAB6B00AA; Tue, 13 Oct 2026 11:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CD16B00AB; Tue, 13 Oct 2026 11:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4E7C6B00A9
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3875A1A0D8D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:20 +0000 (UTC)
X-FDA: 85318029720.27.59C8D41
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B3AB8000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZjFOOBmK;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791906378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65ylofHkpi24oDjTTGvcO1a3YWa0mq9OXaQLGT48cl0=;
	b=QFfOEFt5ZYjg9SyJEfRmZMiMZoZLjTIOHUr5aadaEpmWAkm1Rw5sxWiVOK6ftTguUh7uCH
	Ca4qAVD8Uaz6XMQbrBrJd1fc2IoLtC1phCxw/E2p4rHrG8TYTyhKsjql2R+J0bXZgI0Dcj
	AW3vae+EqpFoMUPmdrNHO30tvDkHm5I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZjFOOBmK;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791906378;
	b=xV8+YFgPNjjlziMtTEEFM5CbeoBWtTQjsCRTh8QWZUqN/S8QkNQo7M+Y6rE3xIKxQv+CCR
	xlqgJm1LwI/J74Nag5Tl6DJMfKJizn3h6vrTMTq334psBNkHXNpxMej3HB3B/e7BfWlMAn
	1gkR2KVTsgsiIJ17SaDp4icPvD3rZI8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3BEF1650;
	Tue, 13 Oct 2026 08:46:11 -0700 (PDT)
Received: from [10.57.13.106] (unknown [10.57.13.106])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B34B3F673;
	Tue, 13 Oct 2026 08:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791906375; bh=XuWA6CDAD0oKpnT54prmMz8xHDjG+uiR1e6XzEDjg3k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZjFOOBmKsahlAoLaaCP80butvn34rJwBxI/KlXTDwEbOHXbvc9w6p2iFn5xnwkUbY
	 8pX/C4RRzfAkFQXwAN03mQEp1RDWDe34NtNMndsb900iRhte6mST01qKnGH7YZpnF8
	 66UGXrxvp+Iivp9v6L5hUgLq6glrE6G5Ev0gmlEU=
Message-ID: <2552e0bd-0e50-4dd5-a3d9-00e9204eb2c2@arm.com>
Date: Tue, 13 Oct 2026 17:46:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Dave Hansen <dave.hansen@intel.com>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@rivosinc.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20261010112457.49485-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B3AB8000B
X-Stat-Signature: u6z7feoh1nfdmgci4kthtyetqg4fe184
X-HE-Tag: 1791906376-333411
X-HE-Meta: U2FsdGVkX18iUaFdV39FFN9BfSa3l7bECKG063Z4pjFI4mPdduyJECycZGt9jwhOFvB2zyrPLe/zcx2mcBUFb9ybmeKT7IKLieah8Dq9KOSIgr4doCZgcUf/v6CV9Zb7EbqR1lsPRh8ztkwwkIz4+4s7VXEcgiR3Nmq2qJelisTmbTFJMHDtD8Rdg9+kkc+vKptJmfaUtWgknkFVqR7sy89C/c3QtFyx9o2bLkuzqkcJm9xVgOJD996F7m4aoad5icruatpdzCCurI/alZE3+o7DQdT58wuH1ZUbxM3l8V2YPzOpVtG+/V5sv+xJPl3BanhWSoLRLjEjSMfke1BaYtqB2z6nAKjZxifUH87i1zcQ1a3tq6tP79HIf1sPF20+0RCSX0khe0lNaFZSXSBqLPHdOeC7EMEkR/D3kMZYaOVmH7SvqQ1/5WAXCjqknN+ju6hEdStpqWGGw4npcChs5dMLMW7qj33N2wbmNjOEfT/tiO5VKBWFC2TEjbz6/eK8ZZI8uQeuA+K88vvnWAzpLRYJlKOZnnbxvqDJLFc25+k3fueaktrkMk2tYhX7RKLOU0ev0RfAEaXlsCvtddwlv5yhBL7Stz/J4sMtjtIcYsKVsPUbvb7gbs4kwMrLbno3EJ6RkpogC5wRltHX5XRz66DoLZDLssj3DaPJKcmlXInEef5YDbu7yKw8mOpMgyxE784+ygn+FXioBtPj8eAzrmOCJW3Rt2O2H+8EnVpM/cAjpivu6gxQ6hVxV0fksmuXl+/oFzaRDC1U8nrbuh9tXQ3950wbcUil+/TDREcSZ5zlhhwSkd0XivRcuEfFoqjdhx0iAAtcxcVChKT3dMTDiZGlrr/xcUs3aN6htJii2vadLfLe/QMNqmbsmBTCITGDrtUuivCFw7NXydngoerwIoQ+MS6/AiME+V+lUOXEZaBy9lQhZmjxNj8ICyL9iUNUz48iDUYn9yZr189gjfq
 piW0WJ3b
 dOteSN0akHcsnVxbyUmMglJ6xZTlCL7qvtSTuUJTjqZPsmv7SdIQ3cfhFku+eqHzTAT7Jiqr6EaTIZkkLDxxxXptjcKeqQZsrxIQqH8DNpsQvldEDdLZ6ebVQo/sxDbOTCCrEl4yql80XhRHagkY9My0CVWt72onaaseN5C6kl3OZp8KHYYroWYt0Ph6sHb/66wCPghpKkuLkoaYfC5Wg3mAYFNli0clmkbFMuld3rIdkBoQba/9khada3SegV6ZvTgaIwjAVStwKCAMBmLj9aPErxIStMPPUw8yu7UXdSH+0Qb+3a1ZJiH7NGcWh0bpj+YpCkLOXw/QReqVae1iQDeYJ0dZ2OeI/14iYRuBgoMlcVeBblYdyEZSOm1scUJ7MoTsvMh0IldKoMlKeyfPZD4AsZYKmxGytW1EF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/2026 13:24, Muchun Song wrote:
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

Took me a while to understand why this is fine. Currently we have:

    ptdesc = pagetable_alloc();
    pagetable_*_ctor(mm, ptdesc);
    [...]
    pagetable_dtor(ptdesc);
    pagetable_free(ptdesc);

All good, nice and balanced.

Now we're saying that pagetable_free() should call the dtor. But of
course, in most cases, the dtor has already been called. Yes, this is
fine because in that case PageTable(page) returns false. Still, the
casual reader is likely to be confused (like I was).

The commit message should really explain this. I'm not a big fan of the
asymmetry we're creating between explicit alloc+ctor and free implicitly
calling dtor, but I suppose it's safer this way. (And looking at the
rest of the series, it does bring some nice cleanups.)

I understand this is a bugfix series so its scope is limited, but if
time allows please post a follow-up series removing all those explicit
dtor calls that are no longer required.

Now don't get me wrong, I am absolutely in favour of moving as much
handling as possible out of the ctor/dtor and into
pagetable_{alloc,free}; a series I posted earlier [1] was a step in that
direction. It unfortunately had many issues, including the unmatched
alloc/free calls [2]. The work you're doing in this series, and your
plan to use pagetable_alloc() for vmemmap, are exactly what I was
planning to do next, so thank you for taking care of that :)

With the commit message improved:

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

- Kevin

[1]
https://lore.kernel.org/linux-mm/20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com/
[2]
https://lore.kernel.org/linux-mm/6d167aaa-e9b0-4687-970c-1c67d0df6344@arm.com/

> +
> +	if (ptdesc_test_kernel(pt)) {
> +		ptdesc_clear_kernel(pt);
> +		pagetable_free_kernel(pt);
> +	} else {
> +		__pagetable_free(pt);
> +	}
> +}
> +
>  static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
>  {
>  	pagetable_dtor(ptdesc);

