Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E98606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c9gb14EP
Received: by kanga.kvack.org (Postfix)
	id 54D906B05B0; Mon, 16 Nov 2026 10:17:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5254B6B05B1; Mon, 16 Nov 2026 10:17:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461F06B05BA; Mon, 16 Nov 2026 10:17:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F38F6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:17:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D6648012F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:17:11 +0000 (UTC)
X-FDA: 85441335462.14.7E4FADA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E97EBC0012
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:17:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9gb14EP;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842230;
	b=5HDH4x9x+cp9RqHoSNt+pXsMlCvuv/6rc4GZbN1x5LAazWlIl2uiQKP3W/l51ZPHcVPvPF
	NCrxx13n6fr9C2qnn8ifwN0uWdV5FB8ARCqDDkrTiBsxi/gWUOghIf7k+dHCSZu5wJGtvy
	KiW/RUnFewFt8I94SqRmhPzVTTRITXQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9gb14EP;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ujqrk5GfnvZSQ47QPVWShAtgKW4tgnFTvG/p2sZDfiU=;
	b=L2GwmGPBMIGT3ilzSnZfSKG9c0VU14ypBTVmb6QRQkCj0iLIOtHfmldAMDdexUCqQaBBfv
	al0kA8cpPELoxygAFmWW5V5ZqVtku514J1ORjVNXjYp13jyaj0R23htTxx3/W0OZtM/jle
	9KJywpI6boAWf6j492+AAZE06T7p2Ig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DED462D4D;
	Mon, 16 Nov 2026 15:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696291F000C6;
	Mon, 16 Nov 2026 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794842229;
	bh=Ujqrk5GfnvZSQ47QPVWShAtgKW4tgnFTvG/p2sZDfiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c9gb14EPpkm2f4Xkve+woq2EcaqVAU6OWFg/jQQkk+LdeQMeL7wWdgnWrcehtDozj
	 hlOPWzyc3otoJDc1BnWmnfcGkELE5ne9YdbXb8bOeqQgo2ANcdeP4VSohetQKo+bu6
	 l5ph1oMq/97A/jF+1i6vYBlBI3MVXXqtcaOkV92iTMzuCIqe5tQ2pEfSD6ogMQ3HJh
	 bic2UvECRtuYisN6i/RkebN7RRB6ItCm2WazrTPfpAne4MbT05QwixHEpiEAMU0J5O
	 v3BC1siAMDf+wN5WhgY81rIR/ucUfVkxsvzUBcp2oLIQ5es2Gj6dI711oOZg0IHil4
	 KlLYgJkBMlr0w==
Date: Mon, 16 Nov 2026 15:16:59 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnd Bergmann <arnd@arndb.de>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Ross Zwisler <zwisler@kernel.org>, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/mmu_gather: delay rmap removal on UP as well
Message-ID: <avseFdmK8zN8JTNe@gremlin>
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
 <20261116-dirty_file_pmd-v2-1-571883053174@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-dirty_file_pmd-v2-1-571883053174@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: E97EBC0012
X-Stat-Signature: 5atpraxy5yz9ube5job67yxu6biscog7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794842229-865403
X-HE-Meta: U2FsdGVkX1/uwvjCFiJNEzJ/92CfmF1yFsw76PGMLbIEC/j74A1FMHqpkwxd2hac0I35WUnG06yMIAO1v6mV0TiWFYhvQcmWgDWutwo6/GC3wLQtIStyQPYQ4OrndZT5231wKEgTyiiqnZkcvYMrozbKaxFxTIfgD9vOlcG6umf5WMoF5WjgBPT+EWeuIBj+pB1Ur5dhCOkY2yjeplLTKDMdNxFK/nXBPVOpCY+yfY9gcAkBL9R/AyI2HhRTgt6kexRtqBaw5ofKp9AKRs5SIsedmu5uu+NyoMppQRL9ZOmZCy7R7MenhT3IuT+TTgjwwgWCj2OweSak30uhocc0W9Omjs1g2jDwy2LLRHxiBgGfEPCd3y7OHm8ld05oQ8z62+gOZiRFES7H8dY5F56c1GFEFbgN8jvb74apNa7mwG1jiJAMyZDJKhSHQUObGkXvLmX+5JU9nvqdZuBthPp1ArVt3+bnDgMUTpJlpqtkISso+J4LI34WJB/W++jScTSsV6zSiq3cs5ZGH4r0J8PTsdRexdXttkB//6RdWuu2/Ft/gfs32uNZkVIm2zRfO9qz9lXiOmrSllksST26ODyQ1ai7+oCHAspBC9nA8XV28OzDxaZo+xuFhkkcZquk0gXFf1FDzWIkBcMODOldJxpCSDM63xNWQ3X01zYdkgI9BXLLCDXk9sIY9fQIE0a1AeklzJev3swnay0WM+6DAOrwA3hxO8mlI72EOI7QoARY5mC/SsFqWSjcDWmzR3Frs0h9e5Qlua+RMUZCGdqKK0+4d9g5t0BDmDCuIT7SmC6JR6JawUGjHx0Jt4E2Xl827agXjD5nWWbnt4AjpSAqSkWIL6JckyOHBTAtnOygmN23WhmFSa0EnrhlU/ETM68gQvbAOxiVAXGQOzBju4MfRLnHD/iFUGhSzjFISThdvDL/XuMnYial+5B5nWZ3OPuZnxpb/8X64m8uWoKsh3gpgbi
 zblp8Ts0
 SNqZ9Q03AtkKup4MQvQtda1/Y6LkF2zlTxQRElPXorUZohyDyrG9MDfUQYveqH4wdX8gj7yttpA4inNwjbQnuX1u6XWB2od31KZjkJwnW7vp8bWZrPYY6AKTgDmaGcg8zWaSnbryluaBAMLuy9M2DrjGajmWZuJEoKmpqIpiYYO4NCCYMWO/61406JwqI1jgU6TBk/nMjY0ZOQwUWSPFcaM1xq8aHgQ4CpDOIEPfjHDs0JnR8qJvYEJv4YoEXcqw4f/Z6S8Bvubt4PtMDxQGJ7TZ+WDXgxZyyxADEQu/Ouu+BMKwCbrgBK2fRpKE04CpE+qPv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:06:58PM +0100, David Hildenbrand (Arm) wrote:
> Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
> has been flushed") introduced delayed rmap removal of dirty pages until
> after the TLB flush, so writeback cannot clean a page that is still
> writable through a stale TLB entry.
>
> It skips this on UP, because on UP there are no remote TLBs (single CPU)
> and because the PTL prevents preemption.
>
> The PTL prevents preemption while removing the rmap, but the local TLB
> flush is usually only performed after dropping the PTL.
>
> Consequently, after dropping the PTL we could reschedule to another
> thread of the same mm, which does not flush the TLB. A kworker could
> then run into the original race with writeback: it cleans the folio,
> but the other thread can still modify it through the stale TLB entries,
> and these writes get lost.
>
> Fix it by simply not special-casing UP. Now, only architectures that
> select MMU_GATHER_NO_GATHER (s390) will skip delay_rmap handling.
>
> Fixes: 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB has been flushed")
> Cc: stable@vger.kernel.org
> Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Link: https://lore.kernel.org/r/avrxOt_GyXLXNqtR@gremlin

Nitty, but I think better as Closes? :P

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/asm-generic/tlb.h | 6 +-----
>  mm/mmu_gather.c           | 2 --
>  2 files changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 4bba02fd5d543..cb087315b4e72 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -249,23 +249,19 @@ extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, in
>  bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
>  		unsigned int nr_pages, bool delay_rmap);
>
> -#ifdef CONFIG_SMP
>  /*
>   * This both sets 'delayed_rmap', and returns true. It would be an inline
>   * function, except we define it before the 'struct mmu_gather'.
>   */
>  #define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
>  extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
> -#endif
>
>  #endif
>
>  /*
>   * We have a no-op version of the rmap removal that doesn't
>   * delay anything. That is used on S390, which flushes remote
> - * TLBs synchronously, and on UP, which doesn't have any
> - * remote TLBs to flush and is not preemptible due to this
> - * all happening under the page table lock.
> + * TLBs synchronously.
>   */
>  #ifndef tlb_delay_rmap
>  #define tlb_delay_rmap(tlb) (false)
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index e98397ac577c4..c022aeb7c84d0 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -49,7 +49,6 @@ static bool tlb_next_batch(struct mmu_gather *tlb)
>  	return true;
>  }
>
> -#ifdef CONFIG_SMP
>  static void tlb_flush_rmap_batch(struct mmu_gather_batch *batch, struct vm_area_struct *vma)
>  {
>  	struct encoded_page **pages = batch->encoded_pages;
> @@ -91,7 +90,6 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
>  		tlb_flush_rmap_batch(tlb->active, vma);
>  	tlb->delayed_rmap = 0;
>  }
> -#endif
>
>  /*
>   * We might end up freeing a lot of pages. Reschedule on a regular
>
> --
> 2.56.1
>

--
Cheers, Lorenzo

