Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AAFCD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5326B008C; Tue,  2 Jun 2026 13:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555596B0092; Tue,  2 Jun 2026 13:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493016B0093; Tue,  2 Jun 2026 13:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3742E6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:26:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F07CD1C1C9F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:26:55 +0000 (UTC)
X-FDA: 84835652790.05.6ADBBBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 42B7D120008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:26:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQoZygeA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780421214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1xSzs0yfom2BvFAzfRHJ/gg+qIG4fJVebZ4d/4+CrI=;
	b=pppiQ3bJ4sS2UmQ4Rd7eqOpEn2okgmBkiy7kXGXg4uvIHghRrv7NheU0JTdp52SUQeP2Wr
	2oz9PqAXo5Ut4alBLFeMp6XyUJlMeLSQ5wAG/qMQJqIneE4svsDBdUvjkqvkPSAeSNsl2p
	2ERmAqCu2CbWGiWHhvAf6MGRmfjBmTk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQoZygeA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780421214;
	b=QmwTZwPeNP8B6PZh642bDiTX+shjhL2YRi00S+kXjhgGTAxNApXrZZPj5iDEzFABcJkjR4
	8rQFYccLjEe5TmfMHBagaH3NPEINzs6sPcK2Uk4D7CH/JuCBxgDIXiUUFRda1J3qDhwauN
	3yVrc05Tu4CsqpJVP6wyqS5ejwgWFRU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 588B3433A4;
	Tue,  2 Jun 2026 17:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089E51F00893;
	Tue,  2 Jun 2026 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780421213;
	bh=J1xSzs0yfom2BvFAzfRHJ/gg+qIG4fJVebZ4d/4+CrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LQoZygeAKaOcrmNpUPIdb41xUyr98Ikld1wVHD529rM41xxur/djs8xTQ7xY1XUuC
	 GQoZPkBrSUPk7NAd4oomb3DuYXyx4PCDU2bpfGckfNxm6MAk6m1bcP0FfJcgBe+yMN
	 5s8NbV8+7tJJnbUtZH5ATphrwIlIt7izN41ik+wDzllCh2b4tbG2C/v/c5HGZiclBV
	 R6CM/K2fpgJuhcy9ybFoL6LgGDRbXYLv89C461AbIhAPrqZ5KgRJ/IAYWCGXCeJ3ye
	 pUBsUZfN0q8i8Z9gUC+1d8gB9RXchbUfJAjukQpWQDpheIheinAEpkHou+zsJAc13k
	 Y47G/jqdjdcnA==
Date: Tue, 2 Jun 2026 18:26:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>, Balbir Singh <balbirs@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Message-ID: <ah8KjaYmAIqR8s5k@lucifer>
References: <20260601083044.57132-1-ljs@kernel.org>
 <263FB5F0-AA3C-4885-86E2-9EDB030A0CDF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <263FB5F0-AA3C-4885-86E2-9EDB030A0CDF@nvidia.com>
X-Rspamd-Queue-Id: 42B7D120008
X-Rspam-User: 
X-Stat-Signature: hsg1mtw584dwczf4ipsszp1ni75gbh1j
X-Rspamd-Server: rspam09
X-HE-Tag: 1780421214-496322
X-HE-Meta: U2FsdGVkX19nEmanvgb5gDI5VK6EKgxl1hOb1fgEvMwrsjYK9hCihUYyNPCK5W0WuCy3nfmtBkSCD+nTsKE5OdmW0l4/qJI1eBlL+8BRSwvgNRsv/vllTMdLHGLgUov0PIHihMRRFSOixVEdTDfl/CsvJN/GKgU7Xp/NgrJN4WVLrjFIa5bP7Rjl2d/kp+LRfm7gWd5J2WlGMzVEiV6IJnYzmRWUkSzO4gTnuGyhjJyLoFG6dKaNdgeOkNHSbFgyAmLSsTTfbpKsusmm5ilSGy8QfBnPM7M+s/bsfdxvOaZAooc0P3MjbkNUx0OTia4W7jI+d94R1ca+m7cmjdYnph9s3hkNz/JcZ46GtqM6Lh0cJjSPLJdKRWZ0YKDDePOoi6LAZ+1/xdDkiuTA3drR5BV+g7L7gCbX34r+EkYJwtgf1RPLS78+Sg29BTGdzXsEbHMOM4iatTKzM+scpp3msb/kjijirDEDJ0ruALVHNuXUP5XQwN8tAsrXo+u+ueZyljcqPRZG5Ly5azeX66RIrN0TDaLDq7hDvzff8KNGLvSK2DUYJA6VIfaU9+sqh+UleS8jynMN4S+K3EsMgK53eijvEUVzJPkDcCD1VdIECBLLZmnkDcWYFVFeUE4GHGQAJ0780BEfBP77a/QNceDa3WJflycMz2jiVmXhgVMega1ndFnw16fc0/vHQYBSwQt6IRflW+Dr+P9b8HuZWuSI1nHMZTPEWCU3AM4Boi4yVUxEYIE3d89rT9MpS8+4pvKPGrIU9wln/h0rud48akN6Y7OTj4PVUNHpeMweabIuMc1xVZ0qrtrLN+ik6c8DvRBSjtvZ7kCzaikPccUW1TqNwB693B/12uf7n46YQSDv0qyAVz3PjLCdE9dKdHgI7ckkacSu8cjIpY7dQ8a1DiW2hZ6a5zuUlxSipkaSjITk4Qk8fPtlsSeA2mQFga3rPQzSL5am5pr532So8jQGz7w
 P46k090d
 5H6AwrUZtLA8gs5FleljfKjxpyUaqrdDlb+D1mqg+kZ7R0dveAQO75wof79bPkq8iPJEpTst0jdrdPZz8ARRsqwXQSDVl7kR5csH0FnXbM0kEB77HlqsChAXj+qCLmYRGEgQOCT3XMxUCVzLTfc3yN0dmiLvH3B/oMgu/P8x/4l4Kwoe/4TRqKaVg7s5QbJXd0oJSWmBTXQAwCEFtM04dd4eLzQSkLV31/121BdK+n+72omjJu1v4cTYelZl6IhX4qA0V9TjN/xln9CorRelrcgCFQX7CnmBXaH38Vn8fBKbn+tsZNA/Wd5qulvkZSxcXX3+qYPGM+s03rvY8WS9hTe7ahZrFuNT6QKJa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 10:40:16AM -0400, Zi Yan wrote:
> On 1 Jun 2026, at 4:30, Lorenzo Stoakes wrote:
>
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
>
> Thanks for the detailed explanation.
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
>
> Just to make sure I get it. This means the only possible writable
> non present/softleaf entry is device private writable. There is
> writable migration entry, but since we are setting a migration entry
> here, that should not be possible.

Yes :)

This is doing the same as try_to_migrate_one(), e.g.:

		if (folio_test_hugetlb(folio)) {
			...
		} else if (likely(pte_present(pteval))) {
			...
		} else {
			const softleaf_t entry = softleaf_from_pte(pteval);

			pte_clear(mm, address, pvmw.pte);

			writable = softleaf_is_device_private_write(entry);
		}

>
> The patch LGTM. Thanks.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> Best Regards,
> Yan, Zi

Cheers, Lorenzo

