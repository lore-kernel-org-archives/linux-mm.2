Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A5AC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D10A6B047F; Mon, 17 Aug 2026 12:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782446B04C6; Mon, 17 Aug 2026 12:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6981E6B05DC; Mon, 17 Aug 2026 12:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45BC46B047F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:39:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C50461A07E8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:39:35 +0000 (UTC)
X-FDA: 85111322310.15.9B464F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2E5EE180004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:39:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B2decGWw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786984774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Za7oukzhm99HtwTAkWVccIddRXW9GKa/mcDPH0VteRk=;
	b=0Eeb8XyaE0fN57q34KppLbR8iE8LTt0PpRtEYESoAodmhFkntR2zk+ZkSHf9FncJga/Gum
	nf36wd7CdPkWke5jB6rvktKLiIMK5MLAdxCl81qbctK3POmiV4u8E28b1hT5VuMPkNwDYL
	0a2EwVOaR3NXHkPbuoMc6pg8ZSfxW0c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B2decGWw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786984774;
	b=FI7TX1ON9U4hgwSwKzoGTG/MDZGHoWcJOBgOFecfPEvQJ+3lLiMTEcNQVHNWqJph4rLut/
	fttXqt1wE+SJN6LUstpCA7Zv5gRvZac52lbIrBM3URb+0u4EJDzd5B57FL1L+w+v7zgkd2
	QBa7NY6C34X0N2jbfJJYtxiOhdpSCTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97AFA600AE;
	Mon, 17 Aug 2026 16:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEE51F000E9;
	Mon, 17 Aug 2026 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786984773;
	bh=Za7oukzhm99HtwTAkWVccIddRXW9GKa/mcDPH0VteRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B2decGWw0u8E7Av6H5ZFQnlYMzFfuJAbTInHOvgpu0D2kdZTJG0o3Zst6tb0ogmX2
	 LM8dUeQolCxKnhlSnplrBUfpPQUDqoA1zXGC5hKj2qKOzBsdNkgonr/zDWXueKKYtf
	 lBXXECedtgjcVqnpWWGwV4XFM+VTUBM1A5/YoQY1wjBfFERJpCYulqxvw0jSCuytQ8
	 aK2rJaaI1iR3RVBlYwsnArjbskXGWTf6AbD9uLyxHv8JeTnbQE0LM05iGu9gT1KFtQ
	 EbYbf1b4/090HVMcAjjg5YUSf8ymLDoVuYHPPJMbBpgO4Dgm08g/GPDheJWjuTG7Sn
	 5WHUjgW6JR4Iw==
Date: Mon, 17 Aug 2026 17:39:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
Message-ID: <aoM4hkwYBRgSt88n@lucifer>
References: <20260803031554.30421-1-hongfu.li@linux.dev>
 <3ae2f1e1-c784-44ed-9b2c-5edf5699d627@kernel.org>
 <e20678ed-3fa1-4677-a1d7-e2af481e8302@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e20678ed-3fa1-4677-a1d7-e2af481e8302@kernel.org>
X-Stat-Signature: 94u9yd1u36bnypektq775ysyg9wtgprd
X-Rspamd-Queue-Id: 2E5EE180004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786984774-85087
X-HE-Meta: U2FsdGVkX18ZY226/8SXaPT4c+sECdU5aP8DYDO1HhmFfwcJumaQU+cwjUQrPqNzuHwKdzLGgs6Mtzy29HWkc45wLJZ/jVE+af3idTO+FCrEK5Co+WJ5lQAFRBnTeYaJK/uCxflKG6pz1w3vI8drxQVT87M0nBXY9zwBq1uGeNQX3xo7f59vtSx1WazbjOJF+RDOs+7LWF3TOyBlVqGHiqHQ/Q/2XGkfYSeyRWolgXOMT7Gbqi51I3VQaX3SGWXVMu+Ri9H0/7Vb+8GQIkKhEOFIuTeBDz7Wq0vF65uJlBgJteYh+0bEOHCs1N/0ub/g/n5NsJDYpP0QzpfoKgjJpQ1uZIilhF6FOyWiZlrzB1FulvcP+uW1pPQGhTheGrxv5Ci0ol7ukxO6RB8bk2RR6YMFZAXVE0izwfOx2vR5fqe/k4A36FJcU4Verz9EdmEC5ztPXQwgKPCP/UaTj9m31K2hH3WPH0BkSYEi4v8qXkEgE6fFcREu577Z9ysCt63H1RIH8lS84WghOvT0x8wdvW7mpDLPKWOjnYYeMRlUl6vYeX5EObNmWSWdL7zQbrQ/Jk9CgmCfkBEpGSo/srGjK1cQ6FxwknuGe0jU1hk8fJKQxm23xB8M3UeDOZ9L//Ohdl7ZzLFur5GE1zVQ+iWIgY5ZW/k1DEhqXT1AcNGKIpkf/Mo9BltVfEHnJWbPe3ByFIHBHXyQV0D6k9L+XuCwPtGAq0h3GJhRQY4EO3K0J4n4lPQaj6MNiCCD3KHdTEVb+m+TP1OKjinl7ubKX/IhnifNlmLBwrzX/WpRZwQ4LLV4Y/VQSYRltnXJylpMRV2HEaekGlBpSMfVu8g2PPExau31qy3k38/CgTAUBZZ5rmyApbQFrIliJ4A3aC/t68NoeQNIpjr9bJh8NUPTpfDKhWhSfmi4TAJoWKxdim5f9c2eGgagFVpTguGnASp6vccPQhJGDwHtNb1unmniJNM
 FuTiQ9RB
 pjvzBMqHeuk1shtbghm74gagLk06/5mNlwXTF4ZivaIAAmuKbSIs4cCEiJCE5XL2kVtpk+KZYdRbCXwmErPEK2wMpMDXudrfSQoGhzc4eZzbtYRYyMlbo3m4/kie+TBaOcmRfqewRuQ8Qtko+hd1M37qdSoTG3VBNjFIODgvJqlxOARUrmC9PoaYzDMmRqqKvPyGFPcCblQWwUUwEnerpqruf3p/TMzgNtoke2mxNVkJrKK0nkN+o1Vg1YIG2VPyLMkchTDbjjlBM/zKUFFDVBgMXoCUTEl4XKP/Ws6ZM3MLtuonxZtqIf4/+4n0/vJR52hwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 05:57:57PM +0200, David Hildenbrand (Arm) wrote:
> On 8/17/26 17:52, David Hildenbrand (Arm) wrote:
> > On 8/3/26 05:15, Hongfu Li wrote:
> >> From: Hongfu Li <lihongfu@kylinos.cn>
> >>
> >> Use the folio APIs in the device_private migration path of do_swap_page(),
> >> replacing four calls to compound_head() with one.
> >>
> >> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> >> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >> ---
> >> v4:
> >> - Drop the do_non_swap_page() extraction (patch 2/2 from v2)
> >> - Added Reviewed-by: Lorenzo Stoakes
> >> - Link to v2: https://lore.kernel.org/all/20260723030752.16979-1-hongfu.li@linux.dev/
> >> v3:
> >> - Please ignore v3.
> >> v2:
> >> - Drop fault_folio, reuse the existing folio variable instead
> >> - Refresh commit messages
> >> - Update comment to use "folio" instead of "page" in the
> >>   device_private path
> >> - Add Acked-by: David Hildenbrand
> >> - Add patch 2/2 to extract do_non_swap_page() from do_swap_page()
> >> - Link to v1: https://lore.kernel.org/all/20260721013347.65698-1-hongfu.li@linux.dev/
> >> ---
> >>  mm/memory.c | 11 ++++++-----
> >>  1 file changed, 6 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/mm/memory.c b/mm/memory.c
> >> index 56b244552f13..bbb289ba09d3 100644
> >> --- a/mm/memory.c
> >> +++ b/mm/memory.c
> >> @@ -4873,18 +4873,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >>  				goto unlock;
> >>
> >>  			/*
> >> -			 * Get a page reference while we know the page can't be
> >> +			 * Get a folio reference while we know the folio can't be
> >>  			 * freed.
> >>  			 */
> >> -			if (trylock_page(vmf->page)) {
> >> +			folio = page_folio(vmf->page);
> >> +			if (folio_trylock(folio)) {
> >>  				struct dev_pagemap *pgmap;
> >>
> >> -				get_page(vmf->page);
> >> +				folio_get(folio);
> >>  				pte_unmap_unlock(vmf->pte, vmf->ptl);
> >>  				pgmap = page_pgmap(vmf->page);
> >>  				ret = pgmap->ops->migrate_to_ram(vmf);
> >> -				unlock_page(vmf->page);
> >> -				put_page(vmf->page);
> >> +				folio_unlock(folio);
> >> +				folio_put(folio);
> >>  			} else {
> >>  				pte_unmap(vmf->pte);
> >>  				softleaf_entry_wait_on_locked(entry, vmf->ptl);
> >
> > Okay, so this breaks the HMM selftests:
> >
> > # ok 30 hmm.hmm_device_private.migrate_anon_huge_fault
> > # #  RUN           hmm.hmm_device_private.migrate_partial_unmap_fault ...
> > [   14.589125] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> > [   14.589178] Modules linked in: test_hmm
> > [   14.589203] CPU: 25 UID: 0 PID: 653 Comm: hmm-tests Not tainted 7.2.0-rc5+ #14 PREEMPT
> > [   14.589243] Hardware name: linux,dummy-virt (DT)
> > [   14.589268] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> > [   14.589300] pc : folio_unlock+0x78/0x88
> > [   14.589326] lr : folio_unlock+0x78/0x88
> > [   14.589349] sp : ffff80008284bb90
> > [   14.589368] x29: ffff80008284bb90 x28: ffff0000cc8ce180 x27: 0000000000000000
> > [   14.589406] x26: 0000000000000000 x25: ffff0000ca395dc0 x24: 0000000000000000
> > [   14.589447] x23: 0000000020100073 x22: ffff0000c23d35c0 x21: ffffffffbfff8000
> > [   14.589485] x20: ffffffffbfff8000 x19: ffff80008284bca0 x18: 0000000000000010
> > [   14.589523] x17: 3030303030303030 x16: 2066666666666666 x15: 6630303030303030
> > [   14.589562] x14: 0000000000000000 x13: 29296f696c6f6628 x12: 64656b636f6c5f74
> > [   14.589603] x11: fffffffffffc7100 x10: fffffffffffc70b0 x9 : ffffb0504ff88f70
> > [   14.589640] x8 : 3fffffffffffdfff x7 : ffff000c79b24bc0 x6 : 00000000000001a7
> > [   14.589680] x5 : ffff000c79b24bc0 x4 : 0000000000000000 x3 : 0000000000000000
> > [   14.589718] x2 : 0000000000000000 x1 : ffff0000cc8ce180 x0 : 000000000000003f
> > [   14.589756] Call trace:
> > [   14.589769]  folio_unlock+0x78/0x88 (P)
> > [   14.589792]  do_swap_page+0xf40/0x1580
> > [   14.589815]  __handle_mm_fault+0x648/0xe68
> > [   14.589838]  handle_mm_fault+0x9c/0x330
> > [   14.589858]  do_page_fault+0x268/0x7e0
> > [   14.589882]  do_translation_fault+0x5c/0x80
> > [   14.589904]  do_mem_abort+0x48/0xa0
> > [   14.589927]  el0_da+0x38/0xd0
> > [   14.589948]  el0t_64_sync_handler+0xd0/0xe8
> > [   14.589970]  el0t_64_sync+0x198/0x1a0
> > [   14.589990] Code: d65f03c0 d000eec1 913c4021 94015993 (d4210000)
> >
> > I can only speculate that we need another
> >
> > 	folio = page_folio(vmf->page);
> >
> > after the migrate_to_ram() call.
> >
> > Let me try that real quick.
> >
>
> Yeah, that fixes it:
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 4134ac607ee0..83d1a2be957c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4937,6 +4937,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                                 pte_unmap_unlock(vmf->pte, vmf->ptl);
>                                 pgmap = page_pgmap(vmf->page);
>                                 ret = pgmap->ops->migrate_to_ram(vmf);
> +                               folio = page_folio(vmf->page);

So after migrate_to_ram() the folio might have been split or otherwise somehow
the page doesn't belong to the same locked, refcount-incremented folio it did
before?

That's kinda a footgun... but this documents it at least.

I think a comment explaining how this can happen would be helpful though as this
doesn't seem intuitive.


>                                 folio_unlock(folio);
>                                 folio_put(folio);
>                         } else {
>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

