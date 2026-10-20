Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6229606A333
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lqmVzDMN
Received: by kanga.kvack.org (Postfix)
	id E8E476B04F4; Tue, 20 Oct 2026 11:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38F46B04F6; Tue, 20 Oct 2026 11:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27146B04F7; Tue, 20 Oct 2026 11:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A73086B04F4
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DCA180221
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:08:32 +0000 (UTC)
X-FDA: 85343336064.22.2EF293F
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4222740008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:08:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lqmVzDMN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792508910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upgNzdzMhaDzhZp7tv2TOFefTojD7y9vaRyKOnJQ9T4=;
	b=RTblljf2du1nKDzjVi342b07t5NP4cwj/UkWu4J2rHT9sxOM+oICwItSLq2DPdkNICjUH2
	2sY5EcY9UhPempDEio6o58sP601UwWbfh8Y6TnuqGGc+OX8FXHOlVg7VI0TWhMPEnxpXzj
	8BhRsT2IWnPafm9mzYVpKurP14ZPSJg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lqmVzDMN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792508910;
	b=kLYzyL/W77YviZFPdnAdj/EZmEGf6E2uw97X6FNuEUZsBQJYtsA6ce43pVmzNGERAw7/E1
	FUQZzSuFIrSY4Oz7XNeHZps5xiQ2IfvFI3rvlOwAUMxH+2TUG5qnUNlmFyQOxnfHiXTsiq
	ihKYKa5/2icRHCfZavPavYxzHfSHQSk=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2e8c710847so435563766b.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792508909; x=1793113709; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=upgNzdzMhaDzhZp7tv2TOFefTojD7y9vaRyKOnJQ9T4=;
        b=lqmVzDMNjNv0x7mKhjam0fC8hjUK79kykdFgT6lpKU95uIrV+mLiXPlsn7HQbJAVGg
         Mh+dCma+WlyDL62uVOLx527r9+Fnzk+Ns3M1SrLM2oJlTEeaHZrKFTPcvl0kEfuwcwKN
         IVBAcY89FuzgX781jTUOzmehlinp8gNrIe8uivjrIQu1usqgZAswT8qccp6AZTI9FfZ+
         Xnbndy/5ClFQo6vrKG8B0rD1XejD5e9pIb6+iARURz3sbdRkphnM56TIibvFZxu9Nh00
         3MnLO6mt/W2/xT0OoU3vcDBpLdsAwRGKm42JY5WSayStyWqMbiIMwhGPb5oV+Rc17QY5
         4pTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792508909; x=1793113709;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=upgNzdzMhaDzhZp7tv2TOFefTojD7y9vaRyKOnJQ9T4=;
        b=KbyOkrpWpP7C5xD9MnvUAvlyK2YHHn/UCZ0nDquq9b2cYaQzxYJixHmmqNdDEBS3tQ
         gn1bnuqyqsLPbgsKZTSBzktMA5CF8MVh+zSZhEEhwdesbzLDF/CCaI0GcnM9Xcm1tf2S
         8PMzQ1wqKs9H2Nd05AoU7b7gBehsdRlfbhbAd7WkBOoVcUvbo4SFdMZp1q9BSvoZtB4z
         bzGd375sJ8ei+J1gkE6BbsXLETfL5P8Z0YGaggnS+rwc+6nKhWMFaz0jbGTrKH+GOFFW
         TpjYMjhb/iJMUbPeb84zCa8qk7UKRb3U5huMFAyA2z53fVSiry9YjvE4KImI5EpN+YUn
         NieA==
X-Forwarded-Encrypted: i=1; AKwUvBxscm5+zJaFR9jj+Jp7WgqAE4HjktVF08RdX1C4ju4bpfJXVOEGchvuAmP4WBQJqtabwjXpxZU61A==@kvack.org
X-Gm-Message-State: AFq9FYKrorBPFknnGBrb30dcXbEulXCPajoZHSN4lJQs/wEiqY0dyaaX
	e92+2YnNRiatuJc5KGI9T6gd6ulpWNE63y0kJTRQ2PxPHviKAaf6aSoF
X-Gm-Gg: AYBFou3uPL54CJ/CXKuuyrUUZ/+8deoWPP6CKlOwLVb9+C9deF203gjISJhSS+i51Pb
	jHTnzwGofMg2H/SURZJGzEeBuIsDkTgPQ+exO3hST48RjGOffFSOMybj9vdRx8ofF8GZ0fz/Czh
	s1RCJq6LSftTnO8R5f7BZ8EYTfEdEt2zRacB8EGMVSTtAZbjNOjSKHHuYCrXcSDQyWkeBvv/Vwt
	FGHHelJvdTCMHZf35cXpnSE+/Z/2fu6UXDfLzNZfahybh0t6S/Do0mRYIk6U/JuPfZkogozn2Vy
	lQJfI6j5n6zhkLL+4mWRSC0HsTKUPKOSKxQY6Y79nCx+zriqSVU/eLZRX1+id65FiyQnxzn6Ld2
	FtRlsRlJH3YcgBbBViIySmuwOJEdkW1w2gukVslGtL5mCxBfICLQL95fYNi94l00nuyV+l/NAcO
	cibzjWmMz0mqSq0fC9c6yz
X-Received: by 2002:a17:907:d006:b0:c31:8c7c:391b with SMTP id a640c23a62f3a-c419df3e670mr791034266b.13.1792508908559;
        Tue, 20 Oct 2026 08:08:28 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40912ceffesm491058166b.47.2026.10.20.08.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 08:08:28 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 20 Oct 2026 17:08:25 +0200
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, sashiko-reviews@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Subject: Re: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the
 mapping functions
Message-ID: <ateD6VVhyiUAtsER@milan>
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-4-hao.ge@linux.dev>
 <sashiko-outbox-178439@kernel.org>
 <2b83dfaa-424b-4464-830e-a7714a816d5c@linux.dev>
 <d1ed2d7f-3999-4e8a-a290-1f812a0439af@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1ed2d7f-3999-4e8a-a290-1f812a0439af@linux.dev>
X-Rspamd-Queue-Id: 4222740008
X-Stat-Signature: hxu3ee3tbggmk3h853idembuwodumnro
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792508910-77251
X-HE-Meta: U2FsdGVkX1/+/qibLMtlQMYqDQy1yYp2ltUnwrcUFsrGXjvmRgGDa8EyGNDkYF3P/EcyyHDRRsK4HRegWtsSK24oPDp6midbUJLPx1FROPMs9y/j1t0tEj5gd2dxjn5oBzpqzPwY11fFtBUDz7qbwvT/fKFSSsHrQ2R5D/UrX49v+7Ny3V33N5vZMnuG9s+CHUaQNMNvBWve6sNSC47pjOWIBtK7iqnRHcHHA1gnjjmZk3cVhCo/J/3fR4nuisdyFaQJvDAPB5pUFS/h9yccYib3ueQpynebxgQyHHlFOi3DkQ2pIPVG9wZwz1r3iackHdfUNGNNmsjjTzXLV50+gsacS7OpbO28SjmurdyIkpycIff0bgz8fFrqYDztQt5goYznImDdtanaSRqn2IN1WDLR7wS8JSXw56LPt76sCsFk6RM5gBk598n3XQJ5BYqdwpXZlLQhP3uHXke/mlIxQK5mI1tckUJ444Z6JbipB3v+wL+674hOEPB6Y/kB8x9fOOdzcNMIsrghKHAbSHAY65ao8fOiy5cdf/CR5N+LAday3GvkZOqBL1DUa5ZYKszBPIc2GQAkQhi7U5rMKLEry4oJexfOxgMP5t1eAaqULBNMpX89ta7vgLqjU2EdStDe9cmClBP5TvrK+EMuZCJkP3/PaVNKeNl8jOYmw5WmbNYcldvpbISpgaSBfB9KjM5118u0bpJzq2gNuJrRMMD4trAKfvuHNp6K2nV+IEzPGB04DLEPsSUv4um85OO8nc7KdB3Js8v6aZlwX/7yAJcmO8463sY/JUWlTjurow7sYKGRl9sjKez5p6BsUtqLBWNfxaFYK0KQ3tTzaGqIZyLupbLIoM8BJygP7DCMpXwG4Y/+Dt7jwWCS/IWUUO8j62VJkAtpsCsac4nVFaAWGusBLCdKmgbLX/kuCuh5C/jSh76/EW6a4CKB1BtWTN52dT4v5l4OzvJRRromoRk/159
 MQJc6P4/
 9q1qmUgou3Q9smYH1dogCeC6bfqVgqDl1LaZPSp93URynU+1Ess0l4n7khUQs64bA099pER2mIh6NXmH8uGM/mLbVfPzadZh2XQOgaz4Y6jXWt1SaVC8hyWpU6B4Z3wxn7dBGAv89CA0GX7hEt21TKfDtab8B46L2EbPRHue58Y24Lq/qQLyPyx26nXFl09mhbcN81uKcH/ieLQ1OeQLj/VZGpxiPXPkMG4ePWo7xMCuVg1CAi0hw+YslI+GXMHrxWJ7XeEzO2GlVrHd2agR/ZXyFzFNcayRnrbY++wcgIdKcknve6QZV5gV88/weN8dNQZQDNtuMz+UG+ZDXDWNRUpMeQf7rTrby2QhjvuVWlaDfBTJSwGjxqhRNivnAkFZggExEmhNTkMsRvO/6yxmAH/aAk04Bh5zh5TQTqFlRc15tJiUcZXlDVWvwxb+GsXb0CchOgoIkoSK3lA0tRfZnhnscFORkGBQWcVil00GOsUNwrZP6hcpVSPJ+ZD7MDds96SRNTcrR0HoecFvu/QvX3gtM5WeQ3I38XUZBTO9JAnQ6JwA/WXKvjaCB9TTXEsyfiNudFmfm8EKGVtZVzLXzSyF/hbJi139Fzb4L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 09:27:14PM +0800, Hao Ge wrote:
> 
> On 10/20/26 18:03, Hao Ge wrote:
> > Hi Suren and Ulad
> > 
> > Sashiko reported several issues, and they all look real.
> > I have some ideas for fixing the first few;
> > of course, please correct me if I get anything wrong.
> > 
> > I'd like to discuss the last issue with you all.
> > 
> > 
> > On 2026/10/20 13:45, sashiko-bot@kernel.org wrote:
> > > Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> > > - [High] mm/vmalloc: infinite loop in vunmap_pte_range() on unaligned error rollback
> > > - [High] mm/vmalloc: __vmap_pages_range_noflush() calls cond_resched() in atomic context
> > > - [Medium] mm/vmalloc: vmap_page_range() calls flush_cache_vmap() before error rollback
> > > --
> > > 
> > > commit 043026437ba63b051df5d14470fe69ce8fa8825c
> > > Author: Hao Ge <hao.ge@linux.dev>
> > > 
> > > mm/vmalloc: undo partial mappings inside the mapping functions
> > > 
> > > This commit adds rollback logic using __vunmap_range_noflush() and
> > > kmsan_vunmap_range_noflush() into vmap_page_range(),
> > > __vmap_pages_range_noflush(), and vmap_pages_range_noflush() when page
> > > table installation or KMSAN metadata setup fails. It also adds range and
> > > page_shift validation in __vmap_pages_range_noflush().
> > > 
> > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > index 44e0eb32708f1..75aa5acf55660 100644
> > > > --- a/mm/vmalloc.c
> > > > +++ b/mm/vmalloc.c
> > > > @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
> > > >   	if (!err)
> > > >   		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> > > >   					       ioremap_max_page_shift);
> > > > +	if (err)
> > > > +		__vunmap_range_noflush(addr, end);
> > > > +
> > > >   	return err;
> > > >   }
> > > [Severity: High]
> > > What happens here when vmap_range_noflush() returns -EINVAL for a range
> > > where end - addr is not PAGE_SIZE-aligned?
> > > 
> > > In vmap_pte_range(), commit a739e6b557af09 added a check to bail out on
> > > unaligned ranges specifically to avoid an infinite loop:
> > > 
> > > mm/vmalloc.c:vmap_pte_range() {
> > > 	...
> > > 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> > > 		return -EINVAL;
> > > }
> > > 
> > > This can be reached on 64KB page kernels via pci_remap_iospace() ->
> > > vmap_page_range() with 16KB/32KB/48KB PCI I/O ranges (for example via
> > > loongson_pci_probe() or acpi_pci_root_remap_iospace()).
> > > 
> > > When vmap_pte_range() returns -EINVAL, vmap_page_range() now calls
> > > __vunmap_range_noflush(addr, end) with the unaligned range. Whenever a PMD
> > > in [addr, end) is already populated with a PTE table (such as the
> > > PCI_IOBASE PMD populated during early boot by reserve_pio_range(), or an
> > > earlier PMD mapped in the same call), __vunmap_range_noflush() descends
> > > into vunmap_pte_range(), which has no alignment check:
> > > 
> > > mm/vmalloc.c:vunmap_pte_range() {
> > > 	...
> > > 	do {
> > > 		...
> > > 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
> > > 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
> > > 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
> > > }
> > > 
> > > Because end - addr is not a multiple of PAGE_SIZE, won't addr step past end
> > > and loop infinitely, clearing unrelated kernel PTEs and corrupting memory
> > > past the PTE table?
> > > 
> > That sounds reasonable. I will add a separate patch in the next version to fix
> > this problem.
> > 
> > > [Severity: Medium]
> > > Also in vmap_page_range(), flush_cache_vmap(addr, end) is called
> > > unconditionally before checking err and before rolling back with
> > > __vunmap_range_noflush(addr, end):
> > > 
> > > mm/vmalloc.c:vmap_page_range() {
> > > 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
> > > 				 ioremap_max_page_shift);
> > > 	flush_cache_vmap(addr, end);
> > > 	if (!err)
> > > 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> > > 					       ioremap_max_page_shift);
> > > 	if (err)
> > > 		__vunmap_range_noflush(addr, end);
> > > 
> > > 	return err;
> > > }
> > > 
> > > On UML, flush_cache_vmap is defined as flush_tlb_kernel_range:
> > > 
> > > arch/um/include/asm/cacheflush.h:
> > > #define flush_cache_vmap flush_tlb_kernel_range
> > > 
> > > When vmap_range_noflush() fails partway through or
> > > kmsan_ioremap_page_range() fails, flush_cache_vmap() runs while the
> > > partially installed PTEs are still pte_present(), causing
> > > update_pte_range() in arch/um/kernel/tlb.c to map them into the host OS via
> > > ops->mmap() and clear _PAGE_NEEDSYNC:
> > > 
> > > arch/um/kernel/tlb.c:update_pte_range() {
> > > 	...
> > > 		if (pte_present(*pte)) {
> > > 			...
> > > 			ret = ops->mmap(ops->mm_idp, addr, PAGE_SIZE,
> > > 					prot, fd, offset);
> > > 		} else
> > > 			ret = ops->unmap(ops->mm_idp, addr, PAGE_SIZE);
> > > 
> > > 		*pte = pte_mkuptodate(*pte);
> > > }
> > > 
> > > When __vunmap_range_noflush(addr, end) then clears the software PTEs
> > > without a subsequent TLB flush or unmap notification, won't those host OS
> > > mmap mappings be left behind? Should flush_cache_vmap(addr, end) only be
> > > called after both vmap_range_noflush() and kmsan_ioremap_page_range()
> > > succeed?
> > > 
> > That sounds reasonable. I will add this logic in the next version.
> > 
> > > > @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> > > >   		pgprot_t prot, struct page **pages, unsigned int page_shift)
> > > >   {
> > > >   	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> > > > +	unsigned long start = addr;
> > > > +	int err = 0;
> > > > +
> > > > +	if (WARN_ON_ONCE(addr >= end))
> > > > +		return -EINVAL;
> > > >   	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
> > > >   		return -EINVAL;
> > > >   	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > > > -			page_shift == PAGE_SHIFT)
> > > > -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> > > > -
> > > > -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> > > > -		int err;
> > > > -
> > > > -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> > > > +			page_shift == PAGE_SHIFT) {
> > > > +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
> > > > +	} else {
> > > > +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> > > > +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> > > >   					page_to_phys(pages[i]), prot,
> > > >   					page_shift);
> > > > -		if (err)
> > > > -			return err;
> > > > +			if (err)
> > > > +				break;
> > > > -		addr += 1UL << page_shift;
> > > > +			addr += 1UL << page_shift;
> > > > +		}
> > > >   	}
> > > > -	return 0;
> > > > +	/* Undo the PTEs installed before the failure. */
> > > > +	if (err)
> > > > +		__vunmap_range_noflush(start, end);
> > > > +
> > > > +	return err;
> > > >   }
> > > [Severity: High]
> > > Similarly here, __vmap_pages_range_noflush() checks addr >= end, but does
> > > not check PAGE_ALIGNED(addr) or PAGE_ALIGNED(end).
> > > 
> > > If a caller passes a sub-page or unaligned range (for example, 0 < end -
> > > addr < PAGE_SIZE), nr = (end - addr) >> PAGE_SHIFT evaluates to 0, so the
> > > huge-page path still maps nothing and returns 0, while the small-page path
> > > loops infinitely in vmap_pages_pte_range(). And if the huge-page path fails
> > > on an unaligned range, __vunmap_range_noflush(start, end) will hit the same
> > > infinite loop in vunmap_pte_range().
> > > 
> > > Should both vmap_page_range() and __vmap_pages_range_noflush() validate
> > > PAGE_ALIGNED(addr) && PAGE_ALIGNED(end) upfront before attempting to map or
> > > unmap?
> > > 
> > I think We need to check both PAGE_ALIGNED(addr) and PAGE_ALIGNED(end).
> > As an example: if addr is PAGE-aligned, end is not, and end - addr < PAGE_SIZE,
> > then nr becomes zero. On the huge page path, we simply return 0 with no work performed.
> > 
> > At the same time, vmap_pages_pte_range() needs the same guard as commit
> > a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned"),
> > to protect against unaligned ranges.
> > 
> > So will do next version.
> > 
> > > >   int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> > > > @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> > > >   	if (ret)
> > > >   		return ret;
> > > > -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> > > > +
> > > > +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> > > > +	/*
> > > > +	 * The page tables undo themselves on failure. Tear down the
> > > > +	 * metadata that was fully set up before the mapping failed.
> > > > +	 */
> > > > +	if (ret)
> > > > +		kmsan_vunmap_range_noflush(addr, end);
> > > > +
> > > > +	return ret;
> > > >   }
> > > [Severity: High]
> > > Can calling __vunmap_range_noflush() and kmsan_vunmap_range_noflush() here
> > > trigger a sleeping-in-atomic-context bug when __vmalloc() or kvmalloc() is
> > > called with GFP_ATOMIC or GFP_NOWAIT?
> > > 
> > > __vmalloc_area_node() supports non-blocking allocations by wrapping
> > > __vmap_pages_range() in memalloc_apply_gfp_scope(gfp_mask):
> > > 
> > > mm/vmalloc.c:__vmalloc_area_node() {
> > > 	...
> > > 	flags = memalloc_apply_gfp_scope(gfp_mask);
> > > 	do {
> > > 		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
> > > 				page_shift, nested_gfp);
> > > 	} while ((gfp_mask & __GFP_NOFAIL) && (ret < 0));
> > > 	memalloc_restore_gfp_scope(flags);
> > > }
> > > 
> > > When a GFP_ATOMIC or GFP_NOWAIT allocation runs in atomic context (such as
> > > under a spinlock, preempt_disable(), or rcu_read_lock()) and page table
> > > allocation fails in vmap_small_pages_range_noflush() after at least one PMD
> > > in [start, end) is populated (or after kmsan_vmap_pages_range_noflush()
> > > populated the KMSAN shadow/origin ranges), __vmap_pages_range_noflush() and
> > > kmsan_vunmap_range_noflush() synchronously call __vunmap_range_noflush().
> > > 
> > > __vunmap_range_noflush() walks the populated PMDs via vunmap_pmd_range(),
> > > which unconditionally calls cond_resched():
> > > 
> > > mm/vmalloc.c:vunmap_pmd_range() {
> > > 	...
> > > 	do {
> > > 		next = pmd_addr_end(addr, end);
> > > 		if (pmd_none_or_clear_bad(pmd))
> > > 			continue;
> > > 		vunmap_pte_range(pmd, addr, next, mask);
> > > 
> > > 		cond_resched();
> > > 	} while (pmd++, addr = next, addr != end);
> > > }
> > > 
> > > Commit 9c47753167a6 ("mm/vmalloc: defer freeing partly initialized
> > > vm_struct") deferred error-path cleanup in __vmalloc_area_node() to a
> > > workqueue specifically because unmapping on failure can sleep. Doesn't
> > > calling __vunmap_range_noflush() synchronously inside
> > > __vmap_pages_range_noflush() and vmap_pages_range_noflush() reintroduce
> > > cond_resched() in atomic context?
> > > 
> > This issue also appears real. One possible approach is to plumb the caller's gfp_mask into vunmap_pmd_range()
> > to conditionally skip cond_resched().
> > Suren, Ulad, do you have any preferred or cleaner way to handle this?
> 
> 
> Alternatively, we can follow the approach from commit 9c47753167a6
> ("mm/vmalloc: defer freeing partly initialized vm_struct"):
> 
> defer the cleanup to a workqueue when |gfp_mask| has GFP_ATOMIC or
> GFP_NOWAIT，and perform cleanup synchronously
> 
> if we are already in process context. Anyway, I will look into this further
> tomorrow.
> 
I will check the AI concern.

--
Uladzislau Rezki

