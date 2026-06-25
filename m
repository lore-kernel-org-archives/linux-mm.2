Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC62DCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB26F6B00A7; Thu, 25 Jun 2026 03:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8AE16B00E3; Thu, 25 Jun 2026 03:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A07D6B00E4; Thu, 25 Jun 2026 03:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6897A6B00A7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:34:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE7E41205C8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:34:52 +0000 (UTC)
X-FDA: 84917623224.10.3D8387A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 474A340003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:34:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4423O0F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782372891;
	b=LU+kY0M46GTJU5xK4gHE8Ibap2eZ1NqYINgMjAwqdYSYaPt8YWgH1kLjKkmvYfI7dke6hq
	OQIKi776Ma8LtvzUpiO+PTomuU/t1XgjYjRZ19Sg2WDdCeeSMCdrE+YUfL/dVlOr0kynzQ
	4avc2n71xoYatLhj40ga+WbKMx8VhOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782372891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qRb3MnUN3VjO7bBEhywHSCzijVBfvOMnSiPoJgkTs+c=;
	b=RUSbOFbegpVlu6C2iyfaEm/K3W0Ne0XQiPp6jntsl34+1UJJFFvNBMVxTJnYpogNfgOZhk
	5OiT3x2b4SdLlFRPBrg4aIIKdgFLEXqww1r1M+misuKnAibZVnquSKXFKoOItVcmGeXmvo
	EA9iaNGWM3kx7aDtJqByAEDykDDNM34=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4423O0F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7EFD60217;
	Thu, 25 Jun 2026 07:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6091A1F000E9;
	Thu, 25 Jun 2026 07:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782372890;
	bh=qRb3MnUN3VjO7bBEhywHSCzijVBfvOMnSiPoJgkTs+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I4423O0FLhecJlTbI9wKC/+pcMVgisapgapg2UsxIzaOUAa4Qz511qWJ6BjGeXtat
	 YCiEwbySNK1Q6EaVCYPKJ3ihJg5NpvUSepWJcfG5FQ0Yu0VjrmHmaOL7zfdeR3BzoV
	 VIYZWAjNCNGGffmW/SxZIqBaNSWLtF7c6WOV5jKBW5PWRz/dJtzi0WcSgGp9oVxKQp
	 UEdeDOJWnpmtWLudaSLDtAIYinLS0s1WJ+sWVNtbBBFSG7FeAsIT1fpPHgvh3rC67F
	 6z+TOExSo7rBLZsDcSZf9RfqSIOm/lb8tZ5fp5JABOWO3lw0GZoAaFdXa/r/WdZOpy
	 sIJ6pDZAWBrgg==
Date: Thu, 25 Jun 2026 08:34:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, kernel-team@meta.com
Subject: Re: [PATCH 2/3] mm/pagewalk: let folio_walk_start() run under the
 per-VMA lock
Message-ID: <ajzUCZSRU3h_UdjR@lucifer>
References: <20260625015053.2445008-1-riel@surriel.com>
 <20260625015053.2445008-3-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625015053.2445008-3-riel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 474A340003
X-Stat-Signature: sm5mt8k4q55sjcmnqdambtdb7hpmpfsg
X-HE-Tag: 1782372891-320365
X-HE-Meta: U2FsdGVkX1+CbsyUDs4o+yqKjmoYkl8QWg47Q1l4ML3jhSRsBWY2ETbzo6a9RD7r5PGFjFy3nDmnp9Rm9BNCy+kzbEhpuypt8viDDIe2CgGzfA4inFLtcaXefqF46GT2Tj+8EL0oakI4rwS9Q623hVONm1klxYSghVmj6jtAnRSUYfwAPJkEXrozF6dxPO/e9BQNqD9k+rW20yVKxX1qA3tEsKK2qqNWVgYltpPoQPTty4Zx9AD0vrB2/rjyxH8EJsAKGrFPzYAYhJKAbEy61v+n3zufv+UZ+gFfFVwJ/+Aj9wYgcY/r97PJGNLAWphJUlXvAsWyJrVy07xKnYPTbgM+r7ACLNY1al6YmiyDtMQrGAinJIQnx8715T7Ti6gkhLVkCmmzyOnZMAPJhBp8OwamL6D6PK/TZeJjWAve9EbTkcaLlPsagVJarOYOlcy631az5jcpL9lx8BrknUi35DGNADDrcqLkmzotRPRRhYiHBIPRPJcZ1YCPNCQ6qcBDFwamvm2LZzh6uv/sYTGZomvVIKxUh0h8fKMFc1hMjjIzE2X6tNqMdy8DcICKzQ4l5Htn9gX7IydDjx2L4MbGeV1CZ1eXK1DFH+7q8DMQS45eSnNkt8MFcKJRAKap/EMD+KoZAETGHRjcSVTSltGq5I9LZYZPc2Ko1gsm5A7ekaz3xawhWgPbaHtISthD3XIWI4hEYY41IOiAEwCF7ZO+meNJ0jVRJX93S71qg2fXnGR4SLPHMa2dPOLk4+Q8j/fIzMlsPFj1MbJ2YdK9c7V5++/hrJ91OhCDkS2OGaYVr18ON7+l8Lil7MmYGzIykc+j/LlIpmegVpb27FuKbBxco/Zn2cOYt/SAQd43CE9luXVS3lyz4hHD0s/UBK468G4i7e1RD/oao5D32Tw/kmVlockeMY9WjnNV0t8n44JM0nUFW0OKfbLzmB+pToignKOUhyNoR3tK3YKhcXjyBu0
 6Oroixqy
 Ylz88eNE6r/HIhhsz4qtBn6x5mlJfkuMwHjodflkyL7uQmTK1RMI1pvbs0T33vVBwJo1INb8UfE+E4HDE4pQwIVEZ1SLTg0oUQeLC98ntBS1Hyj0NrA2S19uL2SMper7XkMWr+VCVnom2ODnTy57fCiZoolfcado2Xn0NfPqNy+9BmyiJqySZCpZ9154wLS62EdCiEDsWAQfoYiIhVJm7lVL4aLWH7m5AHHkzf0q0kfBpbyAkY+uReMC7VeJZCtnv9Eq/wJCzvl7F81rQtUWW3iEFiVGJ1rnyyesJapeLpeHVgpBRQkPo0mQt1M23RQzI/8HKibEv456IqWeTDReA/5dI1StOxJZoAQFodN3ZLA/cU2e22xwoahiZ9K81FVs3+/4Fv3EBBKgLsW+i9Tj6VLj10w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rik, it really would have helped if you'd replied to review :)

On Wed, Jun 24, 2026 at 09:50:52PM -0400, Rik van Riel wrote:
> folio_walk_start() asserts the mmap lock is held.  For callers that only
> need to read a single, already-present page, the mmap lock is a heavy and
> often badly contended hammer.  Such a caller can instead hold the per-VMA
> lock, which keeps the VMA itself stable.

<newline>

> The per-VMA lock does not, however, keep the page tables walked below that
> VMA from being freed.  A concurrent munmap() or THP collapse of an
> adjacent region in the same mm can free a shared upper-level table, and

Yeah I need to update the documentation on this at
https://docs.kernel.org/mm/process_addrs.html it's more subtle than written
there.

Firstly you're wrong about munmap() - it acquires the VMA lock of the VMAs freed
in the range and will only remove an upper level table if the entire range is
spanned.

And that's the only way higher level tables can be removed.

PTE page tables can be removed via MADV_DONTNEED, but that a. acquires the VMA
lock and b. frees the PTE page table under RCU.

A THP collapse can happen concurrently, but PTEs are freed under RCU so you
don't need to do this GUP fast imitating stuff.

> THP collapse (collapse_huge_page() -> retract_page_tables()) frees page
> tables of VMAs whose lock it does not hold.  Page table freeing

retract_page_tables() -> pte_free_defer() -> RCU
try_collapse_pte_mapped_thp() -> pte_free_defer() -> RCU

> synchronizes against lockless walkers the way gup_fast relies on:
> tlb_remove_table_sync_one() sends an IPI and waits for every CPU to enable
> interrupts, so a walker that keeps interrupts disabled across the walk
> cannot be observing a table that is about to be freed.  rcu_read_lock() is
> not sufficient -- it does not block that IPI -- so the caller must keep

Yes it is?

I mean unless I'm missing something here.

> interrupts disabled, not merely hold an RCU read-side critical section.
>
> Add an FW_VMA_LOCKED flag.  When passed, folio_walk_start() asserts the
> per-VMA lock and that interrupts are disabled, instead of asserting the
> mmap lock; it requires CONFIG_MMU_GATHER_RCU_TABLE_FREE and refuses
> hugetlb VMAs (PMD sharing maps page tables this VMA's lock does not
> cover).  The caller must keep interrupts disabled until folio_walk_end().
>
> No existing caller passes FW_VMA_LOCKED, so behaviour is unchanged.
>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  include/linux/pagewalk.h |  7 +++++++
>  mm/pagewalk.c            | 29 +++++++++++++++++++++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index b41d7265c01b..d0387470d732 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -150,6 +150,13 @@ typedef int __bitwise folio_walk_flags_t;
>
>  /* Walk shared zeropages (small + huge) as well. */
>  #define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(0))
> +/*
> + * The caller holds the per-VMA lock instead of the mmap lock, with interrupts
> + * disabled across the walk (until folio_walk_end()) to serialize against page
> + * table freeing, the same way gup_fast does. Only valid with RCU-freed page
> + * tables (CONFIG_MMU_GATHER_RCU_TABLE_FREE) and not for hugetlb.
> + */
> +#define FW_VMA_LOCKED			((__force folio_walk_flags_t)BIT(1))
>
>  enum folio_walk_level {
>  	FW_LEVEL_PTE,
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 3ae2586ff45b..ab1e81983cb8 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -890,7 +890,10 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
>   * huge_ptep_set_*, ...). Note that the page table entry stored in @fw might
>   * not correspond to the first physical entry of a logical hugetlb entry.
>   *
> - * The mmap lock must be held in read mode.
> + * The mmap lock must be held in read mode. Alternatively, if @FW_VMA_LOCKED is
> + * passed, the VMA's per-VMA lock must be held and interrupts must be disabled
> + * across the walk and until folio_walk_end() (only supported with RCU-freed page
> + * tables, i.e. CONFIG_MMU_GATHER_RCU_TABLE_FREE, and not for hugetlb).
>   *
>   * Return: folio pointer on success, otherwise NULL.
>   */
> @@ -908,7 +911,29 @@ struct folio *folio_walk_start(struct folio_walk *fw,
>  	pgd_t *pgdp;
>  	p4d_t *p4dp;
>
> -	mmap_assert_locked(vma->vm_mm);
> +	if (flags & FW_VMA_LOCKED) {
> +		/*
> +		 * Lockless walk under the per-VMA lock instead of the mmap
> +		 * lock. The VMA lock keeps the VMA stable, but the page tables
> +		 * walked below it can still be freed concurrently: a munmap() or
> +		 * THP collapse of an adjacent region in the same mm can free a
> +		 * shared upper-level table, and collapse_huge_page() ->
> +		 * retract_page_tables() frees page tables of VMAs whose lock it
> +		 * does not hold. Page table freeing serializes against lockless
> +		 * walkers via tlb_remove_table_sync_one(), which IPIs and waits
> +		 * for every CPU to enable interrupts; an RCU read-side critical
> +		 * section does not block that IPI, so the caller must keep
> +		 * interrupts disabled across the whole walk, like gup_fast.
> +		 * Hugetlb (PMD sharing) maps page tables not covered by this
> +		 * VMA's lock and is not supported.
> +		 */

This is an unreadable wall of text, if it's AI generated please edit before
sending.

> +		VM_WARN_ON_ONCE(!IS_ENABLED(CONFIG_MMU_GATHER_RCU_TABLE_FREE));
> +		VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
> +		lockdep_assert_irqs_disabled();
> +		vma_assert_locked(vma);
> +	} else {
> +		mmap_assert_locked(vma->vm_mm);
> +	}
>  	vma_pgtable_walk_begin(vma);
>
>  	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
> --
> 2.53.0-Meta
>

Thanks, Lorenzo

