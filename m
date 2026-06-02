Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCD1CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C356B03D1; Tue,  2 Jun 2026 05:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F47D6B03D8; Tue,  2 Jun 2026 05:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530466B03DA; Tue,  2 Jun 2026 05:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 446316B03D1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:17:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 019C1C2AD4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:17:17 +0000 (UTC)
X-FDA: 84834418914.02.A8B4D12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 69FDA40016
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:17:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SKshbpqw;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780391836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QH54k1d650+63eP2vmNE9H6+JFBBePyx28YNtQ18PQ=;
	b=5umIJJeEGVUIKNOojXym5LqGM66uxisO28lJip0iSIAo/iaPq2IrHKg2EiV0X4vfbzYmV/
	X3Mmtc8x0ofbPejauX5R1BL1s64emdfzo0lbeMuEcnGJCMEfq+C241uFB132hbrURY8zBt
	H+jzNeNvVYTHWMhC9ud46O3hM7++baw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SKshbpqw;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780391836;
	b=aKvfz5yyKXhuF7bwiM/dS8d5ZVwcI4gocy3+B3c4UTcksMjCrpdi7M0/WRw287IuEqi1+L
	thwy9LkmSv64TnnQQYKYdDrOyi/Ue/tOjdpIMdOQ+d5NcJuRe7uyfueCH+t+wZYH6Xspay
	w9upZqqXP7V/1t3IoR+zKTu+mtjfyJU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F12B160098;
	Tue,  2 Jun 2026 09:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8E41F00893;
	Tue,  2 Jun 2026 09:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780391835;
	bh=4QH54k1d650+63eP2vmNE9H6+JFBBePyx28YNtQ18PQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SKshbpqwgnjS5QDvf7JE8XZif6Z1IeZJt+RLmWjW4UuA+vXqZhFzJzr72SlMRXhR1
	 cn3YpG6xsh9kwJClWAFemdQRY/WdMpC5/cTqyyxH0to4SL9yQ5ueI7QBmF01WCVpBO
	 lk3P09jR5thrhK8wdOMceEfpc4EIuyNUgvSiR0v3e39O4PTXcPR81phnDMMLZ9Z2qX
	 mFxq4YyFz8707wmAWm0G54EJ1XYkrZO95d0m1RGA/kWcoj+RZAqWjNOHgoKrevJ8Jz
	 KakUwBEp2EvNr8tT8qZFpquUdtc4ZlaMUPwv5W8chMG3YPImTIx6nV7ziItp5FFnRC
	 6zhptznO7UUGg==
Date: Tue, 2 Jun 2026 10:17:09 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Message-ID: <ah6byrDr-DPECvdf@lucifer>
References: <20260601083044.57132-1-ljs@kernel.org>
 <8f7744e0-5729-4862-b5b0-401c2bca4d50@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f7744e0-5729-4862-b5b0-401c2bca4d50@nvidia.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 69FDA40016
X-Stat-Signature: act4dprawfosaw7ycf7874nehpynk3f8
X-Rspam-User: 
X-HE-Tag: 1780391836-722025
X-HE-Meta: U2FsdGVkX18gCKc6DaEexg1Oa2VUlDJKfs258m+JndTwapkYl/2iv/tPJIOeLQBdlZx3pk1pHhRhr3KD+3uLLHd2Qss31jiCCraPsHc3F/vlFbkMmXHbSVwpUgGR34U3k6t4IT60Pmm5mFRRCfHRoRuDxgiZXuJprgCYAGQ8DeYGyGBzBhyVYX9B22Cg0632n+ATpHNtNJbWgnScBplHn8zkg4xFpDkrAZcHT1qXYwsGzQ9O7X+vmCBAfI6OwYbXE7qW3YupuvcZQJUaN6mkhTvRovuN5vL77/F01hVeFv185Y++8lerZyuAo38fea3kifhzbQipPsIOl9p8K5s0XAdzdhbY6rzZDpD6Kin25npBSC4m4M7UXEYzbze7P8PXnBrnR9Axj990d0C39L5C6b/iHoYpjunEa/2O9ry8w/RUu9IpjzHgEybAwfx24m5Rc6pv/eOU1R0fj8+YPEBzOAcc7oG882b3oT5p/dN20CVJYN2oCechDalEKA70PrkjjKn8ugWJTrffyedQQXk5NVT0yVJWlSPRldqfFBCVC+il0EP7GHhx4wvwz6a4Ln/+rmVKt6rr2DDJ2tKQWZ4grhBNxnvjOYbvzKEAGkO7WmF/W4hyEI0xAnx0IqJdRbDtC3V0LYyXAuJ+rt6oqLHo+EOz3jUiXY1Drey4aSsUIGxYVzf/ZbBhTH9llgRdLdyRuj6RkuU0yxdR8rLvwc+0ZSXtIeQIrtMIZ61Ls8LWYVIuucMM3WEtt0Vhx1cneAvJZqVeD6iR0/R4EpSOdYLIxHoHnk8ijbMFj11SRhcHBgDzfNx7qOegIA/G0QtUhAS5sW17uiESH7E65UEB9jU+oFCkEHvXa5WuqdEauvu+Sq9pdgWKxIjL2guF4DWfd1Ctlr5pHpvz9mcTAhlGnZq6hR+0wZcbwTAjYK64IkhawQKOles6GbUl6HLcsilTbY6XtQYUCm4fhq+jn0qwU8f
 ONhIqiNF
 mPK5qLuGvyr+ocKLya0pWf8lytr4+h3uWNOIaPasQ7QyN8IsxVvNGYTfEib8KuvsD0rF40DFRK2P/C+3CDnnCOmhCZpy3ArGV42TejghFwfnDJASnUEVVDjz2VKur3ZXYBY9UIR8sqqh26DB5mtpJ4sXTwruhAzDiqiT4LBzBT9RPNktQQHzAzgmk/4rgMyNp3xr1npUiJJwtMm3mc/R+76kauuCnBmqG4agv0RjKUvbkGL9bEz4SNKQhIxMh2p+11dBCX/EDYw+jmbTUSeptMxvPKhp86EKJLEOfLZitOh9K1sQStadkbTCDrLweWyCYDx8Kd2aTNS7pQrgV5EP58AOS4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 06:30:45AM +1000, Balbir Singh wrote:
> On 6/1/26 18:30, Lorenzo Stoakes wrote:
> > Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> > device-private entries") updated set_pmd_migration_entry() to use
> > pmdp_huge_get_and_clear() in the softleaf case, but made no further
> > adjustments to the function itself.
> >
> > Therefore this function continues to incorrectly use pmd_write(),
> > pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
> > migration entry should be marked writable, softdirty or uffd-wp
> > respectively.
> >
> > Whilst all are incorrect, the most problematic of these is pmd_write(), as
> > this can lead to corrupted rmap state.
> >
> > On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
> > pmd_write() on a softleaf will return the softdirty state encoded in the
> > entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
> >
> > This was observed when running the hmm.hmm_device_private.anon_write_child
> > selftest:
> >
> > 1. The test faults in a range then migrates it such that a device-private
> >    THP range is established.
> >
> > 2. The parent then migrates it to a device-private writable PMD entry whose
> >    folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
> >    (accidentally correct write state).
> >
> > 3. The parent forks and the PMD entries are set to device-private read only
> >    entries, entire_mapcount=2, softdirty still set.
> >
> > 4. [BUG] The child writes to the range then migrates to RAM - intending to
> >    install non-writable migration entries - but replacing parent and child
> >    PMD mappings with WRITABLE entries due to misinterpreting the softdirty
> >    bit.
> >
> > 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
> >    set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
> >    both parent and child, which are therefore AnonExclusive.
> >
> > 6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
> >    entire_mapcount=2 and we end up with an AnonExclusive folio with
> >    entire_mapcount=2! Assert fires in __folio_add_anon_rmap():
> >
> > 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
> > 				 folio_entire_mapcount(folio) > 1 &&
> > 				 PageAnonExclusive(cur_page), folio)
> >
>
> Thanks for the explanation, I wonder why I've not run into this during
> my testing, I do have DEBUG_VM enabled in my config. I wonder if I've
> never had soft dirty set

No worries! I happened to hit it when reviewing a patch and testing
locally.

Yeah I did wonder why others didn't hit it - I guess the HMM tests are is
easily skipped if the module wasn't built for one, and perhaps either
CONFIG_DEBUG_VM not set or CONFIG_MEM_SOFT_DIRTY?

There also might be some other factor that my config happens to trigger
that others do not?

>
> > This patch fixes the issue by correctly referencing the softleaf entry
> > fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().
> >
> > It also only updates A/D flags if the entry is present as these are
> > otherwise not meaningful for a softleaf entry.
> >
> > This patch also flips the if (!present) { ... } else { ... } logic in
> > set_pmd_migration_entry() so it is easier to understand, and adds some
> > comments to make things clearer.
> >
> > I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
> > device private THP test infrastructure") which first exposes this bug as it
> > was the commit that permitted test_hmm to generate the test.
> >
> > However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> > device-private entries") is the commit that actually enabled this
> > behaviour.
> >
> > Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++------------
> >  1 file changed, 33 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index bf9b480bb3b0..79463c709c98 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4982,7 +4982,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
> >  	struct vm_area_struct *vma = pvmw->vma;
> >  	struct mm_struct *mm = vma->vm_mm;
> >  	unsigned long address = pvmw->address;
> > -	bool anon_exclusive;
> > +	bool anon_exclusive, present, writable, softdirty, uffd_wp;
> >  	pmd_t pmdval;
> >  	swp_entry_t entry;
> >  	pmd_t pmdswp;
> > @@ -4990,12 +4990,26 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
> >  	if (!(pvmw->pmd && !pvmw->pte))
> >  		return 0;
> >
> > -	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> > -	if (unlikely(!pmd_present(*pvmw->pmd)))
> > -		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> > -	else
> > +	present = pmd_present(*pvmw->pmd);
> > +	if (likely(present)) {
> > +		flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> > +
> >  		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
> >
> > +		writable = pmd_write(pmdval);
> > +		softdirty = pmd_soft_dirty(pmdval);
> > +		uffd_wp = pmd_uffd_wp(pmdval);
> > +	} else {
> > +		softleaf_t old_entry;
> > +
> > +		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> > +		old_entry = softleaf_from_pmd(pmdval);
> > +
> > +		writable = softleaf_is_device_private_write(old_entry);
> > +		softdirty = pmd_swp_soft_dirty(pmdval);
> > +		uffd_wp = pmd_swp_uffd_wp(pmdval);
> > +	}
> > +
> >  	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
> >  	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
> >  	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
> > @@ -5003,24 +5017,31 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
> >  		return -EBUSY;
> >  	}
> >
> > -	if (pmd_dirty(pmdval))
> > -		folio_mark_dirty(folio);
> > -	if (pmd_write(pmdval))
> > +	/* Determine type of migration entry. */
> > +	if (writable)
> >  		entry = make_writable_migration_entry(page_to_pfn(page));
> >  	else if (anon_exclusive)
> >  		entry = make_readable_exclusive_migration_entry(page_to_pfn(page));
> >  	else
> >  		entry = make_readable_migration_entry(page_to_pfn(page));
> > -	if (pmd_young(pmdval))
> > +
> > +	/* Set A/D bits as necessary. */
> > +	if (present && pmd_young(pmdval))
> >  		entry = make_migration_entry_young(entry);
> > -	if (pmd_dirty(pmdval))
> > +	if (present && pmd_dirty(pmdval)) {
> > +		folio_mark_dirty(folio);
> >  		entry = make_migration_entry_dirty(entry);
> > +	}
> > +
> > +	/* Set PMD. */
> >  	pmdswp = swp_entry_to_pmd(entry);
> > -	if (pmd_soft_dirty(pmdval))
> > +	if (softdirty)
> >  		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
> > -	if (pmd_uffd_wp(pmdval))
> > +	if (uffd_wp)
> >  		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
> >  	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
> > +
> > +	/* Migration entry installed: cleanup rmap, folio. */
> >  	folio_remove_rmap_pmd(folio, page, vma);
> >  	folio_put(folio);
> >  	trace_set_migration_pmd(address, pmd_val(pmdswp));
> > --
>
>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>

Thanks!

>
>

Cheers, Lorenzo

