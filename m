Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5785FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F486B009D; Tue,  7 Jul 2026 08:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446816B00A0; Tue,  7 Jul 2026 08:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360E56B00A1; Tue,  7 Jul 2026 08:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE0EA6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:24:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8509E168D58
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:24:59 +0000 (UTC)
X-FDA: 84961899918.07.243E62C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DB3DD40002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:24:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6tmb7Sh;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783427097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfZpOMpkaJDzLOKi3MjXRffgVPNSMGoyto8kV1jnWd8=;
	b=MyE+95SuN2zeEEd+CXIrNNwfQr4dV4yl5UHEpiUb9AdTBEX2crtHyPMsvDFP1nJarDiWMI
	Zm1IW8D7o5rRrGFnyV6g2c/YtJ1s4JJdd38RmpMATSZAIbeaj0khtpnYIYSxnz8vMgfC4f
	tjq8opLZj6L5fWnK0GacUrrmp6DmTEE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6tmb7Sh;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783427097;
	b=c33EgEv0mEd1KjCO7PmGW8nAtDrm6pbRxEsYXjnJkkWgjqGAbVIGAAvrlhpQfe4Zu2yISj
	IB45n7OxmXo2nElskexb7po2sC7w9HnTtCNiO/7UVoJAoIOrqTuBpJsYJCMqrwtsZ4z+1j
	yb5yOBuGcma+lNMe5WdF6Lx/XOSTGTs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E96C601DE;
	Tue,  7 Jul 2026 12:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F851F00A3A;
	Tue,  7 Jul 2026 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783427097;
	bh=NfZpOMpkaJDzLOKi3MjXRffgVPNSMGoyto8kV1jnWd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T6tmb7Shq5+cgN69zOoULFP7X9TcvzY8I59VD0foVDxtRg/4ABK52SR5rXSXTUvf7
	 FGrSaIYQIlGLYK0xisZkr/jQQY03bpN2KjD7h26E1qL67liUSyDBS6rm5Kz1OpFmHS
	 oHYcRiYa8g4bHcg/Mntj0elMmTu5xoCM37zMocd58szp3DuhvBZ1yCc8KvJDKDT5ZB
	 58+bCxAVhKgi8SgDfqL7VhfmHwLc4ZaPjuB9rEggMJQmv1n6IStRBi/9dbEIlKxgwg
	 YU7iY9LjUTyBRiJO7NrDLZ3AQQjQAlFjvQRSvhLmgl7n83NbYPJTVBFMGtQsjPKuZX
	 cOFxKkMJzD7Gw==
Date: Tue, 7 Jul 2026 13:24:46 +0100
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
Message-ID: <akzv9FWH1peGukyp@lucifer>
References: <20260625015053.2445008-1-riel@surriel.com>
 <20260625015053.2445008-3-riel@surriel.com>
 <ajzUCZSRU3h_UdjR@lucifer>
 <610d1c95a2f9131d5c018304f9a90afb33e8a032.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <610d1c95a2f9131d5c018304f9a90afb33e8a032.camel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB3DD40002
X-Stat-Signature: irisggm7stk6zj9h8fourq5sjsfp3ndk
X-HE-Tag: 1783427097-275945
X-HE-Meta: U2FsdGVkX18zSxkb2Gu8XX6yRsiUHlCRmJ/5ngv8tmNJxivl5eBuZba3+OQROjRlKKIyHhZ0USUqUd75yGnx7O9U21uC4/4kKWNWnH4ux6R4sVY2OYp8Gry7Aj0rGfwydPoPNLj9s8ds8dLYWbW6bfdKTceYd235D+0+7ykG2aeo3wA4EWyAO1dkOSLB9NTx9hE1xKK63S8M62nAl2UsRaqdNDz6jNsVFJ0Q0CYHcLqFPNL2kMVBauM371DRliW4XSPyYLuCDCCOkzQFB3DgzhD6UCQu8fWV4tl5y3cy95AC2R+Xiiuih3n21YSnqJP8HD6ofeCiLU1wBxr6scshrKIOmoY7kwzCuHnt0hICkbsCuViscxSsqhA8AXVvlFCJgy73BLEX4bCUOrg7oEaYbSbP8ghvzcDh8Ll77B2CqlUWJmsNiG74bFbGx/mX7fq3i3uq33aTXhX3AG+WyW4AZqzcNBZw7HJ5Png2kvVuFmlREerNW2t7vaJb3cDHCTHq54EugCz5rnnx++Nd6eIsACdnhGyZkqxzZhY4tA2DK+s6b3b8y70BMBZnCG0zakjrDksrLaiK9NhmTIP5Q1uLTCB/oNmV7qJyUE7yIhtnSL6zOZxmgDrBA3IL86RCm4CEvqXj/7RyZHK18vN/XCfjaoTKHrxI7Zc7eI1fbIijeWHHURD6fMpSN8yQ3tesoIu8r76+6x9m2AlkBEaGiIb5uOlgyL0e4+7QU2dY+QEQYNRR4MY669r88+vIJBdaHzBtNacv5+2OszawT48KD9gdiSG6kUxdCU3Vf5yfKfWfYnutQdni6pVp7UW3vziU6zcm+VJO3K9nEK4wYU9qakYkieyL/l7UK97KHwc68cpZvqHSHU3CvOnRzvwIzn919yEGrctXdGPqci5IyC3H6sMzgR4elH8S0qfsr0OfmhUJQuzhkMtwvxJnm6S94fmHDPJYZlHzJLwv/cRestRCsbe
 DwSP8r4x
 bmJOrFxyZZ0iXnubI05tKNWBClFxsCdPxPXdrSWRuKJrzeDhtfLRrmVucMNSaEyc+3tLnag3/avaEDTYUWsd1uzqfhNfjReLgFz3Ex+ddCxRPd5vCwFDGCpxtmbXvNBePzAJQW8oGtw5b8TyUm5hdDKNBETyYvUCZEq/2p+X2VN+2H2WzV49GsnIEb5jhbA5dkpbp6tL+erOQDeqKjpkaqeD3JxgntmBlnr4yFUPCGh+OxcmATwgEq3oselV1HI0SRr/JBNaiwi7X1auigCq45MreQ/mBa+tK3n+kUj9MW04RyFZwnKiPvadOrQ3eGPk359YoAV62Sk3gdPb9rPYaObcpGFmgAyxOGk0pzit72ShfJ92qyS/3H5F3f1asCM/8HW/vxJuGdlXL+M0rZ1mrH3syeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 07:20:22AM -0400, Rik van Riel wrote:
> On Thu, 2026-06-25 at 08:34 +0100, Lorenzo Stoakes wrote:
> > Rik, it really would have helped if you'd replied to review :)
> >
> > On Wed, Jun 24, 2026 at 09:50:52PM -0400, Rik van Riel wrote:
> > > folio_walk_start() asserts the mmap lock is held.  For callers that
> > > only
> > > need to read a single, already-present page, the mmap lock is a
> > > heavy and
> > > often badly contended hammer.  Such a caller can instead hold the
> > > per-VMA
> > > lock, which keeps the VMA itself stable.
> >
> > <newline>
> >
> > > The per-VMA lock does not, however, keep the page tables walked
> > > below that
> > > VMA from being freed.  A concurrent munmap() or THP collapse of an
> > > adjacent region in the same mm can free a shared upper-level table,
> > > and
> >
> > Yeah I need to update the documentation on this at
> > https://docs.kernel.org/mm/process_addrs.html it's more subtle than
> > written
> > there.

Actually not so sure I do now :) I mean maybe I need to be explicit about
the need for PTL's too. I guess 'other than the PTLs your page table walker
will take' is kinda implicit there.

> >
> > Firstly you're wrong about munmap() - it acquires the VMA lock of the
> > VMAs freed
> > in the range and will only remove an upper level table if the entire
> > range is
> > spanned.
> >
> > And that's the only way higher level tables can be removed.
> >
> > PTE page tables can be removed via MADV_DONTNEED, but that a.
> > acquires the VMA
> > lock and b. frees the PTE page table under RCU.
> >
> > A THP collapse can happen concurrently, but PTEs are freed under RCU
> > so you
> > don't need to do this GUP fast imitating stuff.
> >
> > > THP collapse (collapse_huge_page() -> retract_page_tables()) frees
> > > page
> > > tables of VMAs whose lock it does not hold.  Page table freeing
> >
> > retract_page_tables() -> pte_free_defer() -> RCU
> > try_collapse_pte_mapped_thp() -> pte_free_defer() -> RCU
>
> One issue here is that while we can safely read
> the old page table under the RCU read lock, in
> the middle of a THP collapse there is no guarantee
> that the old page table points at the process's
> current memory.

See below.

>
> Khugepaged could fix this in one of two ways:
> - zap all readers with an IPI, and use that as
>   synchronization
> - make sure the old page table's PTEs point at
>   the individual pages inside the new PMD
>
> Right now khugepaged does the first.

This is confusing too. Khugepaged _could_ fix this one of two ways, right now it
_does_ the first?

You mean pmdp_get_lockless_sync() calls tlb_remove_table_sync_one()?

But that's for GUP fast right, not folio_walk_start/end()?

>
> Relying only on the RCU read lock to read the
> page table could result in us seeing old page
> table contents, that no longer point at the
> current process memory.
>
> Unless I'm missing something...

I think so! Otherwise we'd already have very broken page table walkers
right?

So:

pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
			   unsigned long addr, spinlock_t **ptlp)
{
	spinlock_t *ptl;
	pmd_t pmdval;
	pte_t *pte;
again:
	pte = __pte_offset_map(pmd, addr, &pmdval);
	if (unlikely(!pte))
		return pte;
	ptl = pte_lockptr(mm, &pmdval);
	spin_lock(ptl);
	if (likely(pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
		*ptlp = ptl;
		return pte;
	}
	pte_unmap_unlock(pte, ptl);
	goto again;
}

__pte_offset_map() takes the RCU lock, then locklessly retrieves a pointer
to the PTE page table.

As mentioned above, khugepaged retraction causing PTE page table freeing is
also under RCU, so this is safe:

	retract_page_tables() -> pte_free_defer() -> RCU
	try_collapse_pte_mapped_thp() -> pte_free_defer() -> RCU

And on page table retraction, importantly, the PMD entry is cleared _with
the PTE PTL held_, e.g. in retract_page_tables():

		ptl = pte_lockptr(mm, pmd);
		if (ptl != pml)
			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
		...
		if (likely(file_backed_vma_is_retractable(vma))) {
			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
			...
		}

		if (ptl != pml)
			spin_unlock(ptl);

For anon, we take the mmap write lock/VMA write lock anyway.

And going back to pte_offset_map_lock() - we _recheck the PMD under the
PTL_.

So if the PMD was since cleared, we don't get anything stale. If it wasn't,
then we hold the PTE PTL and exclude khugepaged from changing things under
us.

Thus folio_walk_start(), which holds the PTE PTL, is perfectly fine, and
folio_walk_end() marks the point at which things are no longer safe (but
then we're done with the folio).

So again I don't think there's any problem here, actually.

Thanks, Lorenzo

