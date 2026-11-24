Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598DF606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 10:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWN1l1qA
Received: by kanga.kvack.org (Postfix)
	id 707B16B0674; Tue, 24 Nov 2026 05:42:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6916A6B0675; Tue, 24 Nov 2026 05:42:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5591A6B0676; Tue, 24 Nov 2026 05:42:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31BA06B0674
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:42:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2BEA1160AA0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:42:01 +0000 (UTC)
X-FDA: 85469672442.12.16EB189
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 897EC40006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:41:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWN1l1qA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795516919;
	b=LLVO2vNj98DbWr/6IAOJsVk+TUkjnw6tiQUPspy7VV9LaQLdw2p7cDHYmcLkkK0ZQqnq/H
	Z7rjqQpgbamRT8ZMxoLGe/hgBpSppiP325QrprJL5X9nl03ssg4KZcWZDxn8026UIEY9Dv
	6WxmeDr72i4KOoA4MZ+Y9RKH86uaZfo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795516919;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AE0vJk79CKTdMFw59CFTsMKuZIheJA+GV8fGWrg4mNY=;
	b=QmkyAEaRvXjPnbUFLzbhVrEIZwLP+uZJNw3Z9isc9SpWWnuxUgaj0XFeQJUvphRVdw8JNI
	+pcc3HwUzFGb28LJuSy8HgmJUzxnTXNyFfupFVs9gbcfSUy08gB0pYijpIr6dqR27o+kl4
	lvthUwVMmibsLSlEujFVfRgIJQ7CeQo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWN1l1qA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95E87625E0;
	Tue, 24 Nov 2026 10:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DBE1F000C4;
	Tue, 24 Nov 2026 10:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795516918;
	bh=AE0vJk79CKTdMFw59CFTsMKuZIheJA+GV8fGWrg4mNY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gWN1l1qAlUPy5kx9vhm4ibgqUyn7ct+n9w4cKw5PMHL9MzHUiVwYdfD8Cv/odv3lv
	 LBw93svZxkQdO9x+aL5w1wCO23lRoxWGdd3wI682vlF3BifTjPwMyWMom8S32ZZ+Pr
	 fo1KvsswECXHcrzluqwhqKW1pU+VY/sVXB2TlFdXb97DB10j79mMLc9ZYXJ2udwRX+
	 XulQybbDYLxa0szYEdiN94mip5xlUCNv7MwZ9qo/wdif+72F6COeq0IGSL2kc4aE+s
	 3oKmyOd/pDJOlCKjPPJxuwsCIEG5LBe6X9rqws4F992+XlXmCyI+rnhOpdQVqMqtVE
	 HuX2ocJU1SZYA==
Message-ID: <sashiko-outbox-230973@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/rmap: flush the TLB once per mapping in
 page_vma_mkclean_one()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Rik van Riel" <riel@surriel.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Jann Horn" <jannh@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Matthew Wilcox" <willy@infradead.org>, "Kiryl Shutsemau" <kas@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261123-feat-mm-mkclean-batch-flush-v1-1-7e998ad13251@linux.dev>
References: <20261123-feat-mm-mkclean-batch-flush-v1-1-7e998ad13251@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 10:41:57 +0000
X-Rspamd-Queue-Id: 897EC40006
X-Stat-Signature: mhtta18r5qxqzjd4f14g6x4omesfzmxc
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795516919-378646
X-HE-Meta: U2FsdGVkX1/SeXzHZAxO4g2ayheyW+aXXRVSZ4J6oDKs3nSWW1aPYI20MlZm63+UoPSsP9akmwIEDDFqER7yfa/xyEXcLFpxBpDkEf71LGd151pZbHYHSqWappf2WwVbEItAplwQKhrLpogqbMjKnhu2eYxLajA1TDc7eAlvLCJqHUgnbgqTc0uUhPFOKmQxG+SE+5NcPC1yLVgUGdEbcczLfwZwXUhyfEoG9Llzb7OJ5GAFNwkW5pLmcxe34WDqhgWFLJ7DNy7rxpVN88FLtkfUxRZnud6YovgY5kivNVhDWiUjhHeiAnApXRc0/Zgldfg2UuOGcIhbB7rB0c39Hmb/907jhxAywacYZ2X/+//GpZpVvfkwXu1KRKcS7k3srkf8ix+BRqN5nDNKLokmEq5J18ZMt0ylBSJIB+ypxncwIZmBU/Oaqur46I75htWQWdh6C2f71FT7cWvDeSB3X8sKhbDO3eYwQ0MLvZ7OehkbJV+Ns5T9yWM/19L+DgUd003cFzA224SbXJfuy/1OM6c9FIKW4jdH4RIT0fUXZMQiLnP3e7KlHtISUNMg87JrFuPJZ46KM4wbzdQHesJEK74FXuP5aBD1jev4+R6RkdIulyNcqEOjWEQpi78oMzzi9qGL1Md3t8icT8FxRlooFvMS4tvvBVTGB9YOglKUn3g5668tst0UbN93a8CwUrdIah+H3tZWZCteY0H3b9O1UlVu3437cP560xfDP4XjTNkhbt3+8DXpXzV4Nh+leBSdJd3mRvFdo5H94/o6lC4rOvRa/vOG5IxgRJZgApteYclz1Rr3HW9qNs60BpnzcofgCWJvInr0VOHVHtbMAbITx6bFCzGkwBC2MIskDrwqOHLHd8u9BG73WkCIL1zXJYgT/pVVSbYmxfKMv4tbzptQA8XosodtHnFt/IiSEc5iZGEORa1kBUdfX/itNvzMtdbRpISswgjrZdYQsXqRDWS
 iusLKxXG
 jTfN7GdWyxih6GkPVz88gWZRZky3en2GVVp+lETIrV2MoylC90y4IhHzqgkew8KnyZ9v3Qsu/DA1C/e+tVA3w09cYhtODoaUu7h339BdhOy5MykBk1rFs0TXt7HL8RRrjMdA8QijGUCk9zfEBm8to07Yl6iujBq4hESVPBBuEo3CN1JwmhxTSnV+k6UMEnMHFveKf2GkS9n78WDu89BgRtEFRXV32RjOXCMmqzBrRBy8wsF3eLLVjqeozn+J352Lo8UrBhedOcyR93mA9HyRWS0gEOhpwaBEstC9SLw3WxB4AnedRbxYH1ZCHNScbGcR0d/QMZH3Aq12NRQsx1VCgkC8zhqFmJeGuvNRRx1uJkEMnq41E9gvGxyUBTOzrDICMNEqW1QlmN0IrgC634KQ3397iaqtcIeIvcdvHR5XgUreiNgHrgm2yhSG0v75mnhbJS7TxeyaJXxypUwNx+tQLKIgFbLeH9rDLCoVLsNirWvTbzc8Ie+hZY0HjFLiR92nF4roct8eYQQY/7TMvC7VsRnuKtaWW3Q84I3/qaRiWlFqAQxQNhYu0R2HubN1autarNWvu1Wyy0HJEWfQChZ0jJZHaFtWGVb6w0DmnnuFFdSgB24no1Ytk2KRzTp041N+505UKoq5ijPO+mEAjkWg5Dym4zlpUBYy0WhlLYb8NGJoB65sOrW19VD/JhCdWpK88D5rv1QTVyFNBUiWwWtj7VJ4BMfnbg6HgWThwKCcodWTgQBog1xI27qiDGWtjIqeevnzOHmcJIlkoEoSB5GG8qxoFHyLpp7mdQ3YpEHwgMQXteTHqtntmkQKGgJWpqy1fOzlnIJzjODixfwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm/rmap: ptep_modify_prot_commit() fails to clear PTE dirty bit
  on Xen PV
- [High] mm/rmap: missing tlb_flush_pending tracking in
  page_vma_mkclean_one()
--

commit 5d94fc7a1fe6fb48da4ff29187b2f51e4ede88a8
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

mm/rmap: flush the TLB once per mapping in page_vma_mkclean_one()

This commit replaces per-PTE ptep_clear_flush() calls in
page_vma_mkclean_one() with ptep_modify_prot_start() and
ptep_modify_prot_commit(), batching the TLB invalidation into a single
flush_tlb_range() call after walking the mapping.

> diff --git a/mm/rmap.c b/mm/rmap.c
> index 65646ed6fc453..4c3d9cb47e550 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1127,6 +1127,7 @@ static int page_vma_mkclean_one(struct page_vma_map=
ped_walk *pvmw)
>  	struct vm_area_struct *vma =3D pvmw->vma;
>  	struct mmu_notifier_range range;
>  	unsigned long address =3D pvmw->address;
> +	unsigned long flush_start =3D ULONG_MAX, flush_end =3D 0;
> =20
>  	/*
>  	 * We have to assume the worse case ie pmd for invalidation. Note that
> @@ -1156,10 +1157,11 @@ static int page_vma_mkclean_one(struct page_vma_m=
apped_walk *pvmw)
>  				continue;
> =20
>  			flush_cache_page(vma, address, pte_pfn(entry));
> -			entry =3D ptep_clear_flush(vma, address, pte);
> -			entry =3D pte_wrprotect(entry);
> -			entry =3D pte_mkclean(entry);
> -			set_pte_at(vma->vm_mm, address, pte, entry);
> +			entry =3D ptep_modify_prot_start(vma, address, pte);
> +			ptep_modify_prot_commit(vma, address, pte, entry,
> +						pte_mkclean(pte_wrprotect(entry)));
> +			flush_start =3D min(flush_start, address);
> +			flush_end =3D max(flush_end, address + PAGE_SIZE);
>  			ret =3D 1;
>  		} else {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE

[Severity: High]
Does ptep_modify_prot_commit() clear the PTE dirty bit on Xen PV guests?

Per include/linux/pgtable.h, ptep_modify_prot_commit() updates a PTE while
leaving hardware-controlled bits unmodified.  On x86 Xen PV,
xen_ptep_modify_prot_start() returns *ptep without clearing it in the page
table, and xen_ptep_modify_prot_commit() updates the entry with
MMU_PT_UPDATE_PRESERVE_AD:

arch/x86/xen/mmu_pv.c:xen_ptep_modify_prot_commit() {
    ...
	u.ptr =3D virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
	u.val =3D pte_val_ma(pte);
	xen_extend_mmu_update(&u);
    ...
}

MMU_PT_UPDATE_PRESERVE_AD sets *ptr =3D val | (*ptr & (A | D)), which ORs t=
he
existing _PAGE_DIRTY bit in *ptep back into the committed PTE and undoes
pte_mkclean().  Leaving _PAGE_DIRTY set on a read-only shared PTE allows
can_change_shared_pte_writable() during mprotect() or NUMA balancing faults
to make the PTE writable again without a write fault or ->page_mkwrite()
notification, and on x86 clearing _PAGE_RW while preserving _PAGE_DIRTY
produces a shadow-stack PTE encoding (pte_shstk()).

Clearing the PTE first with ptep_get_and_clear() (or
clear_young_dirty_ptes()) before installing the clean, write-protected
entry would avoid preserving the dirty bit.

> @@ -1193,6 +1195,12 @@ static int page_vma_mkclean_one(struct page_vma_ma=
pped_walk *pvmw)
>  			cleaned++;
>  	}
> =20
> +	/*
> +	 * Flush the write-protected PTEs once rather than one by one, before
> +	 * the caller writes the folio back, as change_protection() does.
> +	 */
> +	if (flush_end)
> +		flush_tlb_range(vma, flush_start, flush_end);
>  	mmu_notifier_invalidate_range_end(&range);
> =20
>  	return cleaned;

[Severity: High]
Can deferring flush_tlb_range() past pvmw->ptl unlock without
inc_tlb_flush_pending() allow concurrent page-table walks to skip their TLB
flush?

page_vma_mapped_walk() unlocks pvmw->ptl when crossing a PMD boundary and
when finishing the walk, before flush_tlb_range() runs.  Because
folio_mkclean() only holds i_mmap_lock_read(), a concurrent mprotect() or
folio_mkclean() on the same VMA can acquire the PTL in that window:

CPU0                                  CPU1
page_vma_mkclean_one()
  page_vma_mapped_walk()
    spin_lock(pvmw->ptl)
  ptep_modify_prot_start()
  ptep_modify_prot_commit()
    /* PTE is now clean & read-only */
  page_vma_mapped_walk()
    spin_unlock(pvmw->ptl)
                                      change_protection()
                                        tlb_gather_mmu()
                                          inc_tlb_flush_pending(mm)
                                        spin_lock(ptl)
                                        /* sees PTE already RO/clean;
                                         * pte_needs_flush() is false */
                                        spin_unlock(ptl)
                                        tlb_finish_mmu()
                                          mm_tlb_flush_nested(mm) =3D=3D fa=
lse
                                          /* skips TLB flush */
                                      /* returns to userspace with
                                       * stale writable TLB entry */
  flush_tlb_range()

Conversely, if another thread has already marked the PTE clean and
read-only under PTL and released PTL with its deferred TLB flush still in
flight, page_vma_mkclean_one() sees !pte_dirty(entry) && !pte_write(entry),
leaves flush_end at 0, and returns to writeback without waiting for or
performing a TLB flush.

Bracketing the walk with inc_tlb_flush_pending(vma->vm_mm) and
dec_tlb_flush_pending(vma->vm_mm), and flushing the full walk range when
mm_tlb_flush_nested(vma->vm_mm) is true (as wp_clean_pre_vma() and
wp_clean_post_vma() do), would close both races.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-feat-mm-mk=
clean-batch-flush-v1-1-7e998ad13251@linux.dev?part=3D1

