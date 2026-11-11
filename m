Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8556160A6F61
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KW5thWEE
Received: by kanga.kvack.org (Postfix)
	id A39F06B00EF; Tue, 10 Nov 2026 19:19:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99CEA6B05B0; Tue, 10 Nov 2026 19:19:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817046B05B1; Tue, 10 Nov 2026 19:19:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C38F6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:19:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2688A01DD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:19:15 +0000 (UTC)
X-FDA: 85420928670.18.DC748F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 078AAC000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:19:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KW5thWEE;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356354;
	b=vBG4IRlDL/I0IBH4z4qPD6v77O6inKM/g/SG0t41yeKdxUdaHJHGzToDyQ274A5WNtNwkZ
	TkqcGuJFsnNFqeqL7vwyp//rMXiq1gd/JNJ366Js82FpC0AmFCHG0U9HDrtzPGPWVAUqh4
	rUnCgmWcH9kJJtK2qggt3LuZhgseWzY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KW5thWEE;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXoT57NQaoa+w4v8dwfJJvnC7UZaUjOSqpLzFjzqxVU=;
	b=0C/bGsRpfPy5pZeFFY5lRJfkjdD6A3Pzb6Y9CGEYAxYKY4LVVsBtlhrAXrYtav3IhyRxJa
	XFKYpLoDKbMD+6ZNOylzZ1irKC7IGXMkBGdbhjuRxhrjTKCVpsSc3ixvZK2NCfz+h/71Wc
	//02NXwqMxVtwKNStdOOzo+Toey7xhU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F72E40466;
	Wed, 11 Nov 2026 00:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA421F0093D;
	Wed, 11 Nov 2026 00:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794356353;
	bh=HXoT57NQaoa+w4v8dwfJJvnC7UZaUjOSqpLzFjzqxVU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KW5thWEEpg8mr0Bk1aIcu2Ka3m8xe2O1vO0/Pp8gmWG00+3y/poNg7dAehAA0drxH
	 Ih0hPOXv/KfMKGRb4gmr07HLpWIIdKJ2/XtSKI96YszEMevcVWSTnej46yAcX9ZecX
	 90leroTiR9ETeSn/FFqPNgQdT3nCrtyyEUDjz/OIE8P5IRCYtY86qgZNArquAsTBdX
	 F23eglylXzelUbcVLxNjIUmw1Zs/r5YmKP+6Q82xbSqHL0w1CvR8McAAhHDNXVtoHy
	 WHiAeFVRjBG3Fdg7gOSImDsMHDuCPhbbEYlknJLUrawVsnk0pAmoA2iyDCCJzP5Mkj
	 BEjEK9JHFMoGQ==
Message-ID: <sashiko-outbox-208010@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 14/25] iommu/dma: Support decrypted PISA pages
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
In-Reply-To: <20261109182533.3594984-15-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-15-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 00:19:11 +0000
X-Stat-Signature: mmgixjz9igec3r4wwedrwsfnby35r79k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 078AAC000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794356353-923466
X-HE-Meta: U2FsdGVkX1917D4U++IP1itZQjSQuOcER900tzcv1Sf3LbaxED8w7bk4dk3FJch6YKudZ+DPPup6CDYJijZ/WWqPtizxlZRyceq8XQ7DCYykxo57dWOebFmSPAzC/kbsx/YGZNhH8qlhT4NfVycgAS/T9T7+LTLIh2cw3TwXrH0iK6kqKK2V3i9vLtSGQVuabViD1J3KXuQgtaDeW7R+ffZGQuLPXm6ISb1vJBYFwX9LLm2iqt3/+zpCObxdkFAg9baNLz2+NpRsibdvGh2DnEQjAre27+UfM+3NHk2XXdiEWMqzQ8vREyMyG+vVQnlhMk63RJHcdOhpaHZblYhVeQE0xTBX/7JpUsl88nmVN4mTMtl6AQKcEn5Rk6dco0dMeUZF/YCBtIHL/zVH+ypH/sEZp22Ba8rRWBbI8xnsOhv/aqeeugchCcjp79yHtTm38WLpN5N4+WkdRoi1K0l/sY9sq9iIkLGt2G8T9WMKCZCx1ueDec/P7ArFKjvz1hfgOdAzj3j8w8JOEZw/dg+2+ITdEZBoMRcjU3N+ncq7A90hbuIw8Qem18ymuWMctMm5bedb8dE0TGJQnOG79UbNaidQSLN4VUhxWN0duchwqf+tkQrNGuyXeY3PE8US81sHoohuyOiRYuwvvq41FA0hMS3+Upw+n9wX4E/ceK7eMEEobH5NpiJeyYo2po1TZgDIhILGBnwRnr8UN0XEEgmNou5J+KR+OqcKuOqUuFWFFygFYegNNBOBB45zMzYVmZsBFSmZtIfhICybgMSXVltV7ANAsPCsfsL8cNQZPQDrUUkSekhyEF63pGJb2LCUHZ44s/yPfhiv625dC9Lupl8NvdoLcsNZ41jQbj7sVFMNBVpj+9KumtUPilKzL+yGZe8ZLdWBWVg33/xj0BUW4Os2g8hI7az8TR8UsUtEwhQeuKwyP4IOvKZHW0Cnpfe5oRNXz42xzuOOG6bKjecqe7O
 sq3kBhxZ
 Hcib01kDTQiAzqMtI2ZhFjTbW9nIWs867x5sni6ZW9f8R3XcTsdZeV6Srv9Si/WCpYVwBXSI76qHPKZsM7X+s6VnKtKh93wRcCR0NNDe4tM6NTwloaSjcB0uPqppa19OPwKfl7WB2tmayjIhh9x94ggnVNQ3mylz10XJJtlCXaE0ZP6eHb3G3+/qDCbB8C7Qy3gjfZZzXGru2RubhEYwzGLIYY58+A4zLmjuCgedBfhabitrgL15srXTanHhPa11fL0XruLRPyQG/J/YVMbygSHgfC3qqlxde/yaN9fsSJsRWZR8yNEEyK3WaWyzeHYlvYyRXOX3RA6fXusiQoHmOmnRW033sSn/2Bt1si1RJTYB3uN4jHWTpquDTiyPHsl7xTF2L1DppAjtmIbCUhJ6x4Jd0rTck7RuQkkir/Mmz4ODwPLeNdM7PxepnHRFmbKe0anF7nvs1mwdCyAuU40S5VgvMAXToc5WJesdn8JK9+dF6walmgSH2paaNTF8qfyPeFRCpFcr071ewK7K1bRvnOpYQ/LXucTycdmVDhlWztd9bnlbTY8s+SjCne1hnraWOGjDzJcc48nUQc0Fo5kxZRNRqq+fZpI3AVP4wf/a+SKjuAyNeI3oNborJyD9XQ5ygpW44jnKw9wLYQ5QmSp1BvgLklTwbo817diQ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [High] dma-direct: broken CoCo PISA SWIOTLB bypass in
  dma_direct_map_phys()
- [Medium] iommu/dma: broken CoCo coherent allocation in
  pisa_alloc_coherent()
- [Medium] iommu/dma: race on meta->flags in pisa_release_page() loses
  quarantine
- [Medium] iommu/dma: stale meta->on_list when pisa_shrink_scan() defers
  pages
- [Medium] iommu/dma: unprotected set_memory_encrypted() in
  pisa_alloc_split_page()
- [Low] iommu/dma: undocumented pisa.decrypt boot parameter in
  kernel-parameters.txt
--

commit a76278fa4c67f9594be2d54e0f11085d9e07d5d3
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Support decrypted PISA pages

This commit adds support for decrypting 2MB PISA pages upfront via a
pisa.decrypt parameter and PISA_DECRYPTED flag so Confidential Computing
guests can map them without per-packet hypercalls or swiotlb bouncing.

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index 7b9d0a7acc101..b4a25c65bf97e 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c
[ ... ]
> @@ -49,6 +51,10 @@ static LLIST_HEAD(pisa_free_list);
>  /* Dedicated WQ_MEM_RECLAIM workqueue, can run without allocations. */
>  static struct workqueue_struct *pisa_wq __ro_after_init;
> =20
> +/* Mark active PISA pages decrypted for DMA (auto-enabled on CoCo guests=
). */
> +static bool pisa_decrypt __read_mostly;
> +module_param_named(decrypt, pisa_decrypt, bool, 0444);

[Severity: Low]
Since CONFIG_PISA is a bool Kconfig symbol, pisa.decrypt is a built-in
kernel command-line parameter and should be documented in
Documentation/admin-guide/kernel-parameters.txt.

[ ... ]

> @@ -128,9 +185,15 @@ void pisa_release_page(struct pisa_meta *meta)
> =20
>  	/* Quarantined on unmap failure and leaked in pisa_release_page_rcu(). =
*/
>  	pisa_unmap_all(meta);
> +	flags =3D meta->flags & ~PISA_ACTIVE;
> =20
>  	/* Clear PISA_ACTIVE before the RCU grace period so new readers stop en=
tering. */
> -	WRITE_ONCE(meta->flags, meta->flags & ~PISA_ACTIVE);
> +	WRITE_ONCE(meta->flags, flags);
> +	if ((flags & (PISA_DECRYPTED | PISA_QUARANTINED)) =3D=3D PISA_DECRYPTED=
) {
> +		synchronize_rcu();
> +		pisa_page_unprepare(meta);
> +	}
> =20
>  	call_rcu(&meta->rcu, pisa_release_page_rcu);
>  }

[Severity: Medium]
Can a concurrent pisa_domain_quiesce() race with pisa_release_page() on
meta->flags and lose PISA_QUARANTINED?

In pisa_unmap_domain_locked(), the domain bit in meta->domains_mapped is
cleared via test_and_clear_bit() before iommu_unmap_fast() runs:

CPU0                                  CPU1
pisa_domain_quiesce()                 pisa_release_page()
  rcu_read_lock()
  pisa_unmap_domain_locked()
    test_and_clear_bit(idx, ...)
                                        pisa_unmap_all() (sees bit 0)
                                        flags =3D meta->flags & ~PISA_ACTIVE
    iommu_unmap_fast() (fails)
    pisa_quarantine_meta()
      WRITE_ONCE(meta->flags,
                 ... | PISA_QUARANTINED)
                                        WRITE_ONCE(meta->flags, flags)
                                          <-- clobbers PISA_QUARANTINED
  rcu_read_unlock()
                                        synchronize_rcu()
                                        pisa_page_unprepare(meta)
                                        call_rcu(..., pisa_release_page_rcu)
                                          <-- frees slot and pages while
                                              IOMMU mapping is still live

Even if pisa_quarantine_meta() sets PISA_QUARANTINED after CPU1's
WRITE_ONCE(meta->flags, flags), CPU1 only checks the local pre-grace-period
flags variable and still calls pisa_page_unprepare(meta) after
synchronize_rcu(), re-encrypting a quarantined page that remains mapped in
the IOMMU.

[ ... ]

> @@ -773,6 +837,16 @@ static struct pisa_meta *pisa_alloc_split_page(unsig=
ned int order, gfp_t gfp, in
>  	}
> =20
>  	return meta;
> +
> +err_free:
> +	if (!can_block && (meta->flags & PISA_DECRYPTED)) {
> +		/* set_memory_encrypted() may sleep; defer to reclaim worker. */
> +		llist_add(&meta->llnode, &pisa_free_list);
> +		pisa_schedule_reclaim();
> +	} else {
> +		pisa_release_page(meta);
> +	}
> +	return ERR_PTR(ret);
>  }

[Severity: Medium]
When pisa_alloc_split_page() is called with GFP_NOFS or GFP_NOIO, can_block
is true, so can this err_free path call pisa_release_page() ->
pisa_page_unprepare() -> set_memory_encrypted() without memalloc_nofs/noio
protection?

Unlike __pisa_page_alloc(), which wraps pisa_page_prepare() in
pisa_memalloc_save(gfp), this unwind path runs outside any memalloc scope.
Because set_memory_encrypted() can perform internal GFP_KERNEL page-table or
hypercall buffer allocations, hitting -ENOSPC or -EBUSY here under GFP_NOFS
or GFP_NOIO can recurse into filesystem or block I/O reclaim and deadlock.
Deferring PISA_DECRYPTED pages to pisa_free_list whenever
(gfp & (__GFP_FS | __GFP_IO)) !=3D (__GFP_FS | __GFP_IO) (or unconditionall=
y)
would avoid this.

[ ... ]

> @@ -1135,7 +1209,7 @@ void *pisa_alloc_coherent(struct page **pagep, stru=
ct device *dev,
>  		if (!win || pisa_window_declined(win) || !(domain->pgsize_bitmap & PIS=
A_SIZE))
>  			return NULL;
>  	} else if (is_swiotlb_for_alloc(dev) ||
> -		   force_dma_unencrypted(dev) ||
> +		   (force_dma_unencrypted(dev) && !pisa_want_decrypt()) ||
>  		   !dma_coherent_ok(dev, PFN_PHYS(max_pfn) - 1, 1)) {
>  		return NULL;
>  	}

[Severity: Medium]
Is this new force_dma_unencrypted(dev) && !pisa_want_decrypt() path
reachable when allocating coherent DMA memory on a CoCo guest?

Both dma_alloc_attrs() and dma_direct_alloc() set __DMA_ATTR_ALLOC_CC_SHARED
in attrs when force_dma_unencrypted(dev) is true, but pisa_alloc_coherent()
rejects any attrs other than DMA_ATTR_NO_WARN just above:

drivers/iommu/pisa-alloc.c:pisa_alloc_coherent() {
    ...
	if ((current_gfp_context(gfp) & ~(__GFP_ZERO | __GFP_NOWARN)) !=3D GFP_KER=
NEL ||
	    (attrs & ~DMA_ATTR_NO_WARN))
		return NULL;
}

As a result, pisa_alloc_coherent() always returns NULL on CoCo guests before
reaching this check.

In addition, when pisa_alloc_coherent() succeeds in dma_direct_alloc() for a
decrypted PISA page, dma_direct_alloc() computes *dma_handle via
phys_to_dma_direct(dev, page_to_phys(page), false) with unencrypted
hardcoded to false, returning an encrypted DMA address for a page that was
decrypted via set_memory_decrypted().  And when pisa_alloc_coherent() scans
existing pages on pa->partial, pa->partial_dirty, and pa->idle, it does not
check that meta->flags has PISA_DECRYPTED set when force_dma_unencrypted(de=
v)
is true.

[ ... ]

> @@ -1294,10 +1368,15 @@ VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(s=
truct shrinker *shrink, struct
>  		read_unlock(&pisa_allocs_lock);
>  	}
> =20
> -	/* Retiring must not run under @pa->lock. */
> +	/* Unmap outside locks; defer decrypted pages to workqueue outside fs_r=
eclaim. */
>  	list_for_each_entry_safe(meta, tmp, &release_list, list) {
>  		list_del_init(&meta->list);
> -		pisa_release_page(meta);
> +		if (meta->flags & PISA_DECRYPTED) {
> +			llist_add(&meta->llnode, &pisa_free_list);
> +			pisa_schedule_reclaim();
> +		} else {
> +			pisa_release_page(meta);
> +		}
>  	}

[Severity: Medium]
When pisa_shrink_scan() defers a PISA_DECRYPTED allocator page to
pisa_free_list, can a concurrent pisa_domain_quiesce() see a stale
meta->on_list and corrupt pisa_free_list?

Unlike pisa_place_meta() and pisa_reclaim_work_fn(), pisa_shrink_list()
detaches idle pages from pa->idle without setting meta->on_list to
PISA_LIST_NONE.  While the deferred page sits on pisa_free_list waiting for
pisa_reclaim_work_fn(), meta->pa is still non-NULL and meta->on_list is
still PISA_LIST_IDLE_CLEAN or PISA_LIST_IDLE_DIRTY:

CPU0                                  CPU1
pisa_shrink_scan()                    pisa_domain_quiesce()
  pisa_shrink_list()
    list_move(..., &release_list)
    pa->num_idle_pages--
    (meta->on_list left as IDLE)
  list_del_init(&meta->list)
  llist_add(&meta->llnode,
            &pisa_free_list)
                                        pisa_unmap_domain_locked()
                                          (unmap fails -> quarantined)
                                        spin_lock(&pa->lock)
                                        if (meta->on_list =3D=3D IDLE_...)
                                          pa->num_idle_pages--
                                        pisa_place_meta(meta)
                                          llist_add(&meta->llnode,
                                                    &pisa_free_list)
                                            <-- duplicate llist_add

Resetting WRITE_ONCE(meta->on_list, PISA_LIST_NONE) inside
pisa_shrink_list() under lock would prevent both the pa->num_idle_pages
underflow and the double insertion onto pisa_free_list.

> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index 11052b65e573b..a7fa1efc0ba09 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -707,8 +707,9 @@ dma_addr_t dma_direct_map_phys(struct device *dev, ph=
ys_addr_t phys,
>  	if (is_swiotlb_force_bounce(dev)) {
>  		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
>  			return DMA_MAPPING_ERROR;
> -
> -		return swiotlb_map(dev, phys, size, dir, attrs);
> +		if (!is_pisa_direct(phys, size))
> +			return swiotlb_map(dev, phys, size, dir, attrs);
> +		attrs |=3D DMA_ATTR_CC_SHARED;
>  	}

[Severity: High]
Does gating is_pisa_direct(phys, size) on is_swiotlb_force_bounce(dev)
prevent decrypted PISA pages from bypassing swiotlb on CoCo guests?

Since commit 30c5e45ee2c5 ("dma-direct: make dma_direct_map_phys() honor
DMA_ATTR_CC_SHARED"), CoCo guests do not set SWIOTLB_FORCE, so
is_swiotlb_force_bounce(dev) is false during normal CoCo operation.
Instead, CoCo guests enforce bouncing via force_dma_unencrypted(dev) inside
dma_capable():

include/linux/dma-direct.h:dma_capable() {
    ...
	if (!(attrs & DMA_ATTR_CC_SHARED) && force_dma_unencrypted(dev))
		return false;
    ...
}

Because is_pisa_direct(phys, size) is only checked inside
if (is_swiotlb_force_bounce(dev)), CoCo guests skip it, leave
DMA_ATTR_CC_SHARED unset, fail dma_capable(), and bounce every decrypted
PISA page through swiotlb_map().

Conversely, is_swiotlb_force_bounce(dev) is true when swiotlb=3Dforce is
passed on the command line or when a device is bound to a
restricted-dma-pool via rmem_swiotlb_device_init(); bypassing swiotlb_map()
there hands the device a general RAM address outside its restricted pool.
Checking force_dma_unencrypted(dev) && is_pisa_direct(phys, size) outside
the is_swiotlb_force_bounce(dev) block to set DMA_ATTR_CC_SHARED would fix
both cases.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D14

