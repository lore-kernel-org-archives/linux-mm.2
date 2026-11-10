Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A779606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eYd4pg+A
Received: by kanga.kvack.org (Postfix)
	id B8DF76B05B8; Tue, 10 Nov 2026 18:12:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FB86B05B9; Tue, 10 Nov 2026 18:12:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E536B05BA; Tue, 10 Nov 2026 18:12:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56C556B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:12:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6DA58017B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:15 +0000 (UTC)
X-FDA: 85420759830.30.E29F4AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2023A8000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eYd4pg+A;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352334;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7f8gUy51P1oYPfUkFzdQH1CtQ+AX8pksRuuJwjKGp5g=;
	b=YnuLm/yjjurxbTm8BXaVzvw0efe4zA+n7rPj2vHwGeTs8ctob1MimgANylfNl6kmHsIKrw
	pC6CSqoHa/KwRM16VMZTKPf91u4Bf5z27MCmF4ZVWvAHXkAUKH09gBOM14K6BhaGy1KeJg
	6b+doXEOwZlxy5pCL4BQIhfCALYQJrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794352334;
	b=wG8WxrnXTFp4WM8vysPhNfjDLEz9A7IxNrFAYI1qt7whFWm8Smk2/ttaMvfb9/ingb445X
	70bjvxsCfMN1k0RpnhI5QNEJARAySmv3jYhy0Of5T0FXGWo+AX+RKB3Z3ARc1KELOw53br
	7fOIiuoXRnVw1bfqhh+6MrTBLyIzxfI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eYd4pg+A;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7295635C8;
	Tue, 10 Nov 2026 23:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075F11F0093C;
	Tue, 10 Nov 2026 23:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352333;
	bh=7f8gUy51P1oYPfUkFzdQH1CtQ+AX8pksRuuJwjKGp5g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eYd4pg+AdiWJ8fLOi5pj0jOQmdPH/Lfxlc+N0dsZzpxjWZW2RhcXkheWwOCcQcT1o
	 A/0TG0Bj78loIx65SoYpxiQOBx0xWVxur0zDeHtDONdAHexxES6tYcGcC8enkGC1YJ
	 Ap5xqvFALmLSWzL36EoOIlez+boJwaIewz5B2EiGLRaru/B5/OJHRfg0ky/4JjUOlf
	 lTnGq9vizeImtxyWhwfgi6+jjBwV/jCYhwFG62270IcO3y/imnO/fmmjOYhVRRxNIE
	 iprBK1yfbCj9hcp50VSw+77qEyFOZ7W41tI+JkHxyMvgBhd98ClIEn4UkNyHfoZkm/
	 lY3LYzstHuJGw==
Message-ID: <sashiko-outbox-207863@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 08/25] iommu/dma: Use per-domain IOVA window to
 map PISA memory
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
In-Reply-To: <20261109182533.3594984-9-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-9-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:12:11 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2023A8000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: md7birizrmoweezamtugwe8h3ia6n59g
X-Rspam-User: 
X-HE-Tag: 1794352333-20972
X-HE-Meta: U2FsdGVkX1+9+z1wrlZTzhc4kQ+pFI1A3eBo3melJK/PtjwnNvhgw3Pl9CKD7y5ymbHBO8Z94M8s/TGrnZF/Q2Y18EHBQaJpXE7KANOTuZF4Z8OwYh9OYiPCYf9yvylzdZlA1CrQNyr1unvxG14EUdK6Cec0gBVMFoRdamtq68BGhJdHr4EmXTv3mTv/m/cCjlsCSktNcmIfCwIhs94+I/cYy5+HtqFt2E/Bnwu46XvXPasBU0pb9zE8RPC6q3QUGz3ja95TrABzZ154tRN8lyynZ0lhcaTwjxATX2uU6W/ZcpCsX4waZXOBUbZqGVT3zGLzTiC9MJaEgm5tgXYPmLhg7EOS28cfr83HrAZ2/a21Ofj6dMuGUbLKXzM1Y8GKMZDkHGStnNcYB5XwnythYs0tsv5kIByJxelgD7SngxOUEO583mnL48E64EQ0luYhe5yCU4osKnvKkIWJCXDXBW8S0MIe9GY5Oc2HnJE+/+NIn6ZzGB3rMLjubL1rC2p1iIzIb7fyNsr3xfxAYrP8OGUfLDQcVsALYLL6pnowDTmZGfLxmhhHs75M7W9oejA7YpvY6snoA3zLGUw685kbY49E7YY0+GNaIgTmmkP10mI5QP7NwmPqrQlQgd0+EvN9JEiCF7EWuZSEFodnRhwOBs8h6PCVq3JFhm2YgpQfG16j22iBgwb2qwprj2U7Bdwh/ja3DmMFls3L7z3vIgtMliejl38mwzFWUxd0siDis7lk8eOj7T8uwar1mOCSjp+uTmjeieXjfbpHnef2p4n6aLzdmoHxdIImTXixBQFRHj+sDqCXDg3FVTvtu1luI05/IdhMwD1/mKSwJ82ejZ1c3Ke0oRSoBkftSEbvkqjKMq64EqrUWM0plKE2+7MoFbDc9ALVaGAg4a2obhlgwYGMaU73+afZ1r1XM1KrOX3nKT1PS6b5SMSX8JkyizItUgcEMArTg2/SaGxgn0FRbXv
 21Wanapy
 /IqUMhkZBTK4ORLbeMWQC0ME/rIDSZEXg0V6EtnJ3xFZzEXcM6CnmaBoCmVzGX0yXodmj8cDaQ0oDxKCZ+dCc8wJ9dn5nEJslBQqboYUkno1KrPL4vpw7maTsT+HPq5LTDfdOWiOrLXVVNZNIDXEPZygPHgZUovAg/HJ1kmBZI9g6ASLZ27k4UD7c0s3y1P/L4xV/EC7D7dosFgQKYrBGwGjAnq93VWdTtopNpGWxonOrUHDBRy8DUVAxX6IM4uZzoGr9woBlG2yixRzQrld2rXfX4onQbBHk7/z5/7GUlWbcumUDVR8vJ2WWFrKVfdE5tIreaW9mj0rANf3fpZBeEKufqO62gkWT9Lx7LQ9tXaShalgTccixMNsXU9vLuubYSih6QIuEs/34KoB82s+1AFTT3UdNJkEZ7uStxByf3M/ER0Z0IHkbrKYXWXkN4Uj1lUDXyE7iMMymu6of0kE3v8hmxZPfe5Rc0ct+SLFmATnLUJpT9KXtizPRr56KXrdWlDiuRfQ1lPJelNZVJea6TsuoIEyCkZCThXBRB8a+HVDcJZPFxxW/YzJKQMPDm60ccFbwUAVZAJw8P8VG5Ig5lDj/7k+9VAce6h6qIW1wAJvoZ6HscJC5MppyWensebAs0rWTpzQWmWgtM5489lj2zFmDJ+gi9ZQQmPFu
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
- [High] iommu/dma: untrusted devices not excluded in __pisa_map_phys()
- [Medium] iommu/dma: pisa_domain_quiesce() races with PISA page
  retirement
--

commit 5ad49a194c307768ccdbdc801e7b8a723eed2bfc
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Use per-domain IOVA window to map PISA memory

This commit intercepts DMA map and unmap operations in dma-iommu to map
PISA pages using a dynamically assigned per-domain IOVA window and 2MB leaf
PTEs.

> diff --git a/drivers/iommu/pisa-map.c b/drivers/iommu/pisa-map.c
> index 2ba977bb68734..2c481e514575c 100644
> --- a/drivers/iommu/pisa-map.c
> +++ b/drivers/iommu/pisa-map.c
[ ... ]
> @@ -300,3 +303,184 @@ void pisa_domain_quiesce(struct iommu_domain *domai=
n)
>  		pr_debug("pisa: unmapped %u PISA pages from idle domain %p (index %d)\=
n",
>  			 done, domain, idx);
>  }
[ ... ]
> +int pisa_window_assign(struct device *dev, struct iommu_domain *domain, =
struct pisa_window *win)
> +{
> +	u64 limit =3D min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
> +	u64 size =3D pisa_window_size;
> +	unsigned long flags;
> +	dma_addr_t base =3D 0;
> +	int idx, ret;
> +
> +	limit =3D min_not_zero(limit, dev->coherent_dma_mask);
> +
> +	if (!dev_is_dma_coherent(dev))
> +		return -EOPNOTSUPP;

[Severity: High]
Should pisa_window_assign() and __pisa_map_phys() also reject untrusted
devices when dev_is_untrusted(dev) is true?

In iommu_dma_map_phys(), SWIOTLB bounce buffering for untrusted PCI devices
is only used when the buffer is not aligned to the IOMMU granule, so
granule-aligned buffers reach __iommu_dma_map() -> pisa_map_phys()
directly:

drivers/iommu/dma-iommu.c:iommu_dma_map_phys() {
    ...
	if (!(attrs & DMA_ATTR_MMIO) && dev_use_swiotlb(dev, size, dir) &&
	    iova_unaligned(iovad, phys, size)) {
    ...
	iova =3D __iommu_dma_map(dev, phys, size, prot, dma_mask);
}

When an untrusted external PCI device maps a 4KB-aligned PISA buffer,
__pisa_map_phys() maps the entire 2MB PISA superpage into the device's
domain with meta->prot (including IOMMU_WRITE on bidirectional allocators
even for DMA_TO_DEVICE mappings), and iommu_dma_unmap_phys() and
__iommu_dma_unmap() leave the 2MB mapping active across unmap, exposing all
sibling blocks in the same 2MB page to the untrusted device.

[ ... ]

> +	/* First use of this PISA page in this domain: install the leaf PTE. */
> +	ret =3D 0;
> +	spin_lock_irqsave(&pisa_domains[domain_idx].map_lock, flags);
> +	if (!test_bit(domain_idx, meta->domains_mapped)) {
> +		phys_addr_t pisa_phys =3D phys & PISA_MASK;
> +
> +		ret =3D iommu_map(domain, pisa_phys_to_iova(win, meta, pisa_phys),
> +				pisa_phys, PISA_SIZE, block_prot, GFP_ATOMIC);
> +		if (likely(!ret)) {
> +			/* Ensure leaf PTE is visible before setting the domain bit. */
> +			smp_mb__before_atomic();
> +			set_bit(domain_idx, meta->domains_mapped);
> +		}
> +	}
> +	spin_unlock_irqrestore(&pisa_domains[domain_idx].map_lock, flags);

[Severity: Medium]
Once __pisa_map_phys() sets domain_idx in meta->domains_mapped, can
pisa_domain_quiesce() corrupt meta->rcu or pisa_free_list if an idle PISA
page is retired concurrently while an IOMMU unmap fails?

When an idle page is detached for retirement by pisa_reclaim_work_fn(),
pisa_place_meta(), or pisa_shrink_list(), meta->pa and pisa_slot2meta[slot]
remain set until pisa_release_page_rcu() runs after the RCU grace period.
If pisa_domain_quiesce() sees PISA_QUARANTINED set after an unmap failure,
it only checks meta->pa =3D=3D pa under pa->lock before calling
pisa_place_meta(meta), which re-queues meta->llnode (unioned with
meta->rcu) onto pisa_free_list when all blocks are free:

CPU0 (pisa_reclaim_work_fn)       CPU1 (pisa_domain_quiesce)
spin_lock_irqsave(&pa->lock)
list_del_init(&meta->list)
meta->on_list =3D PISA_LIST_NONE
llist_add(&meta->llnode,
          &pisa_free_list)
spin_unlock_irqrestore(&pa->lock)
llist_del_all(&pisa_free_list)
pisa_release_page(meta)
  pisa_unmap_all(meta)
  call_rcu(&meta->rcu, ...)
                                  pisa_unmap_domain_locked(meta, ...)
                                    /* unmap fails, sets PISA_QUARANTINED */
                                  spin_lock_irqsave(&pa->lock)
                                  if (meta->pa =3D=3D pa)
                                    pisa_place_meta(meta)
                                      llist_add(&meta->llnode,
                                                &pisa_free_list)
                                                <-- overwrites meta->rcu

Similarly, if pisa_shrink_list() moved meta onto pisa_shrink_scan()'s local
release_list (which decrements pa->num_idle_pages without clearing
meta->on_list), pisa_domain_quiesce() decrements pa->num_idle_pages a
second time and calls list_del_init(&meta->list) while pisa_shrink_scan()
iterates release_list without pa->lock.  In addition,
pisa_quarantine_meta() updates meta->flags with an unlocked
WRITE_ONCE(meta->flags, meta->flags | PISA_QUARANTINED) that can race with
WRITE_ONCE(meta->flags, meta->flags & ~PISA_ACTIVE) in pisa_release_page(),
losing PISA_QUARANTINED and allowing pisa_release_page_rcu() to free the
quarantined page to the buddy allocator.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D8

