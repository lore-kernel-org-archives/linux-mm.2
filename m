Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E18D606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUWrK6df
Received: by kanga.kvack.org (Postfix)
	id 9E0626B05B6; Tue, 10 Nov 2026 18:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991A46B05B7; Tue, 10 Nov 2026 18:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CF076B05B8; Tue, 10 Nov 2026 18:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ACBA6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:12:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3D481C233C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:13 +0000 (UTC)
X-FDA: 85420759746.20.65B8C96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 378B140008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AUWrK6df;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352332;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVx1yQsKvU5ZterbW3J1SqxcKgcswUapfB2Vj+hfm4Y=;
	b=1QlT4zR52VR+4CXYi18kh057y1o8iolmraS7Q02doXPT22Lw0ABxHPiFnSWStHmldXtWZS
	sCObgBdJ/NatstR4Ev8jtg1yCL9vJ0gno5CU3yiL0WcjfUQSA35l3ZpIu7MFQtd0KypQGh
	ggDkatPVKe+2SAaBCAB9RYbGjWepAYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794352332;
	b=aD40GTsKnjCCMqec9Ph9PHBvggtNwLOzu0VjeocvPvT0ryR50xNUedT/yRTTVHx50S++at
	TweqKevT4tugmXOdRBUrJFXHgfuGs5HO8wp3nqLSINpCLkUidP46kRKJyV7MnfSWdFl79c
	V5w57wFG+yT/kms3jIDd8Vh26vKnWT4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AUWrK6df;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C309B61DC2;
	Tue, 10 Nov 2026 23:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A4F1F0093C;
	Tue, 10 Nov 2026 23:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352331;
	bh=IVx1yQsKvU5ZterbW3J1SqxcKgcswUapfB2Vj+hfm4Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AUWrK6dfqIGN258S1zFF2yi9cHs5GJ9KROWwSFl0T/qWrFNYHpqX3kYvDoVR8O0m8
	 TRDRVJYwtwTkguCNQfaLyPISOcrlfhk/092PuK4qnmG89xAtjhkXCd0tjEXZJVUYUa
	 l0UpA9hPe00mY5qXO3nEmimIvFogkalQpreb5CgF1JZmiMVbFldzWY1gvJLYh007D8
	 L4WgfjsqaJuOxOPZMFWk7YX5PnE7FklbenXdxAq9DPRjMmXrJM9CGazpdfHnNIiy8y
	 zk7bR5lMGwfgX+CmutBIq7VtHAHskQyOERHlqfb+06C/v+1hpt6Y0uKkrbIiYb4T5k
	 wsI8CIxH2386g==
Message-ID: <sashiko-outbox-207862@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 07/25] iommu/dma: Release PISA domain mappings on
 domain teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Christoph
 Hellwig" <hch@lst.de>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "David S .
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Willem
 de Bruijn" <willemb@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Alexander
 Lobakin" <aleksander.lobakin@intel.com>, linux-mm@kvack.org
In-Reply-To: <20261109182533.3594984-8-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-8-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:12:09 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: mmiwhtxbss8438rx8eh7s46ajexyonjf
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 378B140008
X-Rspam-User: 
X-HE-Tag: 1794352332-776203
X-HE-Meta: U2FsdGVkX1+Y+iylsUy/6Z24hd4YvLP70YObN9QNhsujcxavSDbIaDo0DVynwgMRscxvQdcTq1ce10ztnl/ptQW1J9aKDIYOeC8jlk0t2do1E2VbpUU+PWc/1F9X5auta/J5OdYVvGvQ3JTGsfNiDV7Mb5baFjaBCxYKVmJ9xpYmAhuyD7Q3LPEUWvWeNl1VhDPPRAdcOwHUjF0sqGXmbaFwoE7nHZtreUxIP4uCYS8AWDL5gOQUfFYuusV/vfzhug3q+yba8Dg+lv6C5I7G7Qn663Yu1LS25iz2CnNMeZiXI5YgH1xTaehHnif2K+mZXT8Xal7dGueGaw2DKbYj6GEW9QWp1iakTBSXkytH7WpYhx2naR10TGDH6UFN7H6xNAySrMaX5t/cM81T4qFRzFzlqEWpSaCVFfVaqqo06VFXlfswgf4sklwMSDa7Sil4d8XH2x0/AJYOgs5NnG0KUrOLGt935xgtji+FPEwnFD7O8YJCvxuVd1UTbz8RODVs1XmGsFonCt/DeEiATPFv3+bm46iNjFxvJ5p7w28O254yqcb9XCwNaJ9AWh9SEaePabn9Zc97V8+dvdcU4zTEGZdQE2/po6yKn/yiXxhX/lVpcVWoYxpHaTfcqEDJSeiDi2BomRJEU83zE2nTYXNtMehTq6k2XUJc53b05IYaHd+eA67k4QaKwGTnfKP5mhOFT5bDdm2lX6KEJ5vzQoXf15KrA2Gw7duF0CiSfG0wzJnDpnq751YjZw2xGzVNMm89EQ3VXj0kNyCy4ysuqtEaReg8py2bDYHbG1khSE8rJcWGZotp/arg9eaFoVoZiGUCg9SDWuwbe2a4S5QnR99pDq7qH3KYzlDyaoaBK4rFf2+SeglQGyi57drhn8wDqdgkWRKr+z+pdnHUI+6vZkXmONtI6UxOK1rIHFwraBBkiMNMoDkPrEV5giqhzkMnlQ3s2OMe9ExERa+ttlzDNTk
 CKJZB6G0
 1eVw293xQH+xUbgPcNqfAGrYW4EFFesFtV91pBAL1AuwA3TJ3gYa7juNP34c7FYMak6zjZsAj6d9nUwRdQC5VSwtcLhIQROaWZg5DCcbnJHJBLQvMYQOpADXmivHa/SJFEiMAQ0llIsP3FWfw2m4RweOlhHfx4NDrZMTD98m0wC57ASu5WpncDQJi/ZYRmiUFMrwwl0QPRYQQJE/3kAS3qtHxmMtc+N+7UnxESMOY6ZqB+rszhXoC+tWu0WkjnbudcHUGkBh4sInPl9264hoaZP5wRzZ1DZaRH+gBwjOKDcFcKgtFp/mkze07z/RX8wkD9GzrUIYerWaF1FaBjm6GZ6QDDzeXOcZLhm/UBZ9WW74KABBQLNgwpv/A8dIecRqhjtdwN1j+4349GXOiI+iaqTLk7vTuZOEZTxqaSL6tF0FQ8qkijzoVwBGZUfERYXIg5jjstNaVp7DTGYXaUa1OMAmZ7hWBWL1ElDSd8gMXotksqlqdpx24X3A3eyeVZqEv7fTwhtOpxV0YLpeBEcx0w+LX0l0iagB3QW7lNdinF1qR01jWT/Yiy6XYtt8qtyoDST7o2KEcJd3PPMKXJtXr5QDa48SFKKpCrZ113n5UJd5HWqQ080o47etiVfbse418zolKkFKQ5aReMRvSLpjWlLYQjAFL/jM52zJw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] iommu/dma: list and RCU corruption in pisa_domain_quiesce()
  on quarantine
- [Medium] iommu/dma: data race on meta->flags in pisa_quarantine_meta()
  and release
- [Medium] iommu/dma: build failure in pisa_domain_quiesce() due to
  static symbols
- [Medium] iommu/dma: missing struct pisa_meta declaration in
  pisa-priv.h stubs
--

commit 72b9f4d8d1b40452a8315c8a6e6bdaec17fbdb98
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Release PISA domain mappings on domain teardown

This commit adds pisa_domain_release() and pisa_domain_quiesce() to unmap
active PISA pages and release or quiesce domain mappings when an IOMMU
domain is torn down or its last DMA API user detaches, quarantining and
leaking any 2MB page whose iommu_unmap() fails.

> diff --git a/drivers/iommu/pisa-map.c b/drivers/iommu/pisa-map.c
> index 2e8d635dec34c..2ba977bb68734 100644
> --- a/drivers/iommu/pisa-map.c
> +++ b/drivers/iommu/pisa-map.c

[ ... ]

> +/* Report a short IOMMU unmap and mark @meta quarantined so it is never =
reused. */
> +static void pisa_quarantine_meta(struct pisa_meta *meta, struct iommu_do=
main *domain,
> +				 int idx, dma_addr_t iova, size_t unmapped)
> +{
> +	pr_err_ratelimited("pisa: unmap of IOVA %pad in domain %p (index %d) re=
turned %zu, quarantining PISA page\n",
> +			   &iova, domain, idx, unmapped);
> +	WRITE_ONCE(meta->flags, meta->flags | PISA_QUARANTINED);
> +}

[ ... ]

> +static unsigned int pisa_unmap_domain_locked(struct pisa_meta *meta,
> +					     struct iommu_domain *domain,
> +					     int idx, dma_addr_t base,
> +					     struct iommu_iotlb_gather *gather)
> +{
> +	dma_addr_t iova =3D base + pisa_meta_win_offset(meta);
> +	size_t unmapped;
> +
> +	if (!test_and_clear_bit(idx, meta->domains_mapped))
> +		return 0;
> +
> +	unmapped =3D iommu_unmap_fast(domain, iova, PISA_SIZE, gather);
> +	if (unlikely(unmapped !=3D PISA_SIZE))
> +		pisa_quarantine_meta(meta, domain, idx, iova, unmapped);
> +	return 1;
> +}

[Severity: Medium]
Can concurrent updates to meta->flags in pisa_quarantine_meta() and
pisa_release_page() clobber each other?

pisa_unmap_domain_locked() clears idx in meta->domains_mapped before
calling iommu_unmap_fast() and pisa_quarantine_meta(), so a concurrent
pisa_release_page() -> pisa_unmap_all() can see bit idx already cleared
and proceed to update meta->flags without synchronization:

CPU0                                  CPU1
pisa_domain_quiesce()                 pisa_release_page()
  pisa_unmap_domain_locked()
    test_and_clear_bit(idx, ...)
                                        pisa_unmap_all()
                                        flags =3D meta->flags
    iommu_unmap_fast() [short unmap]
    pisa_quarantine_meta()
      meta->flags |=3D PISA_QUARANTINED
                                        meta->flags =3D flags & ~PISA_ACTIVE
                                          <-- drops PISA_QUARANTINED

When PISA_QUARANTINED is lost, pisa_release_page_rcu() frees the IOVA slot
and returns the still-mapped 2MB page to the buddy allocator.  With the
opposite interleaving, pisa_quarantine_meta() restores PISA_ACTIVE on the
retired page.

> +/*
> + * Unmap all PISA leaf PTEs from a domain whose last DMA API user detach=
ed,
> + * keeping its window and domain index so mappings are re-installed on d=
emand.
> + */
> +void pisa_domain_quiesce(struct iommu_domain *domain)
> +{
> +	struct iommu_iotlb_gather gather;
> +	struct pisa_window *win;
> +	unsigned int slot, done =3D 0;
> +	bool release =3D false;
> +	dma_addr_t base;
> +	int idx;
> +
> +	if (!static_branch_unlikely(&pisa_key))
> +		return;
> +	win =3D pisa_dma_window(domain);
> +	/* Pairs with smp_store_release() in pisa_window_assign(). */
> +	base =3D win ? smp_load_acquire(&win->base) : 0;
> +	if (!base)
> +		return;
> +	idx =3D win->domain_idx - PISA_IDX_FIRST;
> +
> +	iommu_iotlb_gather_init(&gather);
> +	/* Keep call_rcu()-freed pages from reaching the buddy allocator before=
 IOTLB sync. */
> +	rcu_read_lock();
> +	for_each_set_bit(slot, pisa_slot_bitmap, pisa_nr_slots) {
> +		struct pisa_meta *meta =3D READ_ONCE(pisa_slot2meta[slot]);
> +		struct pisa_alloc *pa;
> +		unsigned long flags;
> +
> +		if (!meta || !test_bit(idx, meta->domains_mapped))
> +			continue;
> +		done +=3D pisa_unmap_domain_locked(meta, domain, idx, base, &gather);
> +		if (likely(!(meta->flags & PISA_QUARANTINED)))
> +			continue;
> +		pa =3D READ_ONCE(meta->pa);
> +		if (!pa)
> +			continue;
> +		spin_lock_irqsave(&pa->lock, flags);
> +		if (meta->pa =3D=3D pa) {
> +			if (meta->on_list =3D=3D PISA_LIST_IDLE_CLEAN ||
> +			    meta->on_list =3D=3D PISA_LIST_IDLE_DIRTY)
> +				pa->num_idle_pages--;
> +			release |=3D pisa_place_meta(meta);
> +		}
> +		spin_unlock_irqrestore(&pa->lock, flags);
> +	}
> +
> +	if (done)
> +		iommu_iotlb_sync(domain, &gather);
> +	rcu_read_unlock();
> +	if (release)
> +		pisa_schedule_reclaim();

[Severity: Medium]
Does pisa-map.o fail to build at this commit because PISA_LIST_IDLE_CLEAN,
PISA_LIST_IDLE_DIRTY, pisa_place_meta(), and pisa_schedule_reclaim() are
still static or local to drivers/iommu/pisa-alloc.c?

Those declarations are only moved to drivers/iommu/pisa-priv.h in a later
patch in the series, commit "block, mm, iommu/dma: Support PISA for disk
I/O and scrub migration", which breaks bisection when CONFIG_PISA and
CONFIG_IOMMU_DMA are enabled.

[Severity: Medium]
Can pisa_domain_quiesce() call pisa_place_meta() on an idle page that has
already been detached from pa for release, corrupting pisa_free_list or
meta->rcu?

When an idle page (avail =3D=3D bpp) is detached onto pisa_free_list or
queued with call_rcu(), meta->pa remains non-NULL until
pisa_release_page_rcu() runs after the grace period, and its slot stays
set in pisa_slot_bitmap.  If pisa_domain_quiesce() sees PISA_QUARANTINED
on that page, meta->pa =3D=3D pa is still true and pisa_place_meta() runs
llist_add(&meta->llnode, &pisa_free_list) on it:

CPU0                                  CPU1
pisa_reclaim_work_fn()                pisa_domain_quiesce()
  ...                                   rcu_read_lock()
  pisa_release_page(meta)
    call_rcu(&meta->rcu, ...)
                                        pisa_unmap_domain_locked()
                                          pisa_quarantine_meta()
                                        spin_lock_irqsave(&pa->lock, ...)
                                        if (meta->pa =3D=3D pa)
                                          pisa_place_meta(meta)
                                            llist_add(&meta->llnode,
                                                      &pisa_free_list)
                                              <-- overwrites live meta->rcu

Because meta->llnode and meta->rcu share an anonymous union, adding
meta->llnode to pisa_free_list overwrites the active RCU head (or creates
a cycle in pisa_free_list if pisa_reclaim_work_fn() has not popped it
yet), and a second pisa_release_page() after meta->pa is cleared to NULL
hits the !meta->pa branch and frees the quarantined 2MB page to the buddy
allocator.

In addition, pisa_shrink_list() moves idle pages onto pisa_shrink_scan()'s
local release_list and decrements pa->num_idle_pages without setting
meta->on_list to PISA_LIST_NONE, so pisa_domain_quiesce() will also
decrement pa->num_idle_pages a second time and run list_del_init() on
meta->list while pisa_shrink_scan() walks release_list unlocked.

> diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
> index 3ef6e51402ceb..f97f69a13d1a9 100644
> --- a/drivers/iommu/pisa-priv.h
> +++ b/drivers/iommu/pisa-priv.h

[ ... ]

>  #define pisa_nr_slots 0U
>  static inline void pisa_slots_init(void) {}
>  static inline int pisa_slot_alloc(struct pisa_meta *meta) { return 0; }
>  static inline void pisa_slot_free(unsigned int slot) {}
> +static inline int pisa_unmap_all(struct pisa_meta *meta) { return 0; }

[Severity: Medium]
Does including pisa-priv.h in drivers/iommu/iommu.c trigger a
-Wvisibility warning on struct pisa_meta when CONFIG_PISA is disabled?

struct pisa_meta is only declared inside #ifdef CONFIG_PISA, so when
CONFIG_PISA=3Dn the parameter lists of pisa_slot_alloc() and
pisa_unmap_all() declare a local struct pisa_meta type, failing the build
under CONFIG_WERROR=3Dy.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D7

