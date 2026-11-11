Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB52A606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 02:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZC+zYvNm
Received: by kanga.kvack.org (Postfix)
	id AEE636B00EF; Tue, 10 Nov 2026 21:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FC96B05B0; Tue, 10 Nov 2026 21:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E036B05B1; Tue, 10 Nov 2026 21:57:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7266C6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:57:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5AE11201EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:57:17 +0000 (UTC)
X-FDA: 85421326914.22.93B19F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 48FE0A0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:57:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZC+zYvNm;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794365836;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RdVUj10YnT4FaQuI9t9rChWHse340dlLSjNSsSGxRUk=;
	b=EMpGutbsaUulPpedUOHbeIKo81Tmetph3kqHFuliUHYPqUlJ0EllQkshSa+IPxQT24wJZz
	hE7QPMTe7qomyyFbqWv/Ey5avxT2SGUYKc5NmJpj9Rd9ipf50zwYnxvYQw2+D9GkImKdwH
	Qu7FQz4ilftDGKeSgjAjmFq5bXYUwYg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZC+zYvNm;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794365836;
	b=2RynkEXeECoEalrU8QXfxtveWhDGbCrO3GnJjrC+oCxSuo9HSmuJtVbebq2CpwaHndkaMa
	aNQ3HanMa3F0LeDwG4uXPzsI75yg1zwT/UoYozyL1Wi304T5bHT/wCJIKwWC9R+Ue3QSbB
	cRYvPZeqAxytJFnrM8t/KOgGIYZoTV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78FB263407;
	Wed, 11 Nov 2026 02:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44B21F00A03;
	Wed, 11 Nov 2026 02:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794365835;
	bh=RdVUj10YnT4FaQuI9t9rChWHse340dlLSjNSsSGxRUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZC+zYvNmG73hg4Znh53HNuRZx0pudYCAMF3RHFFUQJf2tC2mlVUzaV32yGT4W7rmI
	 tqnmoyFkMTJND6yZkD+c4qgy2WOwzPw3st7psYg/o37kU46EeUxVkLoiCVlhh/YHOp
	 9nLEE2u2fOxIzPiC6rwgzYaK7aYCvcI5GhrpGDnUOyJE9urvBn6wlVoT5Y3oR0N0+s
	 FneoaSs7tfprVh1fGGKyaNuxzMEnZGHILvaLP6jHiWALzx+bhtERNH3cf4R+XGR8uW
	 z/50fYAs3yKr9p9Ci5qvB9RKLdbn43lf8A7BqpENnBYOuTJxDsCbraoKCBRvLr/WjS
	 6mb03DZQwL6NA==
Message-ID: <sashiko-outbox-208134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 19/25] iommu/dma: Stop recycling old PISA pages
 when allocator waste is high
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
In-Reply-To: <20261109182533.3594984-20-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-20-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 02:57:13 +0000
X-Stat-Signature: 9jeaunozmgy8az7fs4u5o47k46acnm79
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 48FE0A0003
X-HE-Tag: 1794365836-883291
X-HE-Meta: U2FsdGVkX1+cu2uTtTLZIdanerv4WtKl6i2IJYejRfvEUV51Omk1aqC1syEuXVcShJfYyKwMCkkktY5Bx9CVyCUGPiUTG+C3GRcilkEw98sVAVuElARY1bKc13xBu8e97NO9mAJiS/5WjPPBK8MjTGJP6QM9z5Ck2vyQxK8K5JXSigFs9DliLs5x+2iD/xsfsdJwRnn+uRr9oAXROQnQ0yXg18qq3s87wl335/Mgry3lazBom6WRL9qOUaPy7avKjHg5IJFZfo+pLE7cU0MZf/lgeA534xnkSe252yPteih0vC+Sqn4pvWa7CNnhCzHAcLJpAdDv/gjTokS4OAFut2nLjC5JeIx+q8DbKvqCbK5JBGRKgH5TXDqt51Vxw3AGXH38iJuQMjGB7Z7bxpKsFLNWf3sIE+UCL9SbNSi3lQobgqDyKuRCn6teFsBzC2lEFpjBAboPKECvTRh108iTI9eV83UZAXZPDV1J4FaCTTiIDCjIKnl/liKe0c/w4+jhWLcarxPjM/MHyGMnSYBmEizWlI7QXdywn5ysUh7hVPfz2FHPGlNqc+qdM+xEKkF5Nmm7At1rhXFL7J1FyAWx99lvUfLCY5HC4lJIK1WSR8tx5Rg8uZljcpHfnI1gR54Dj1tBJnHZS1LgRJWUDRG35E9+a0uE3YIazSjrWCLttFyZk5pBp1yehTl1iJn0HO+vLdk+BsuzVAaaVoVLTz5B44B42Ygsj5AU1ZLQWFpulFYXwcx9vZIOT5dhFfAHnqqTN4c2u+clsXejEMldXAicR1jIkuiScB8T66Amc6iJHox7G7ZdQRHd/sWsvWwMSyuh3ue6Enrwh/cker+vmpyPvVU7/icXxNu3YfsmqpX3u39DYEFXkFhQQx8rXhhc4v3w+KSnjc28fJRGp7+DvIYe2DlVyVCwuuC1fDTVb/MVc5lq+r5W1z6yr86qkpZ1F/V66+SlRvetCXDID4Tf/V6
 TITOP2S1
 E62O8KrMf4X++LESEZkt24S5whTE1UlzMYJOe7MkBXSrwXgoSl5zUBnx2qRsOr08SPA4EkUFtOaV3Qlsp5K+X3nX9b0ufmv7/eAZpF66oNRE3QNHQBk7yUn7Fj36xnSgl8riiaQ81ORjWyGXXvcYBXdalikFw2BykWoPrQi4i61AgTnIejiK13HRUufsR9DWL778TRl6cFRls2spoiqgZ1UniK8LCv7J+kiMqiuKxmcEYv9b/3GLTUfm6mNV5lfC1+VeSwG9rHVR09R4ZdU/+IXbe7n1+O5Vp50u7WUkjYGETwnG6ju1ZwCJEV9th//Z96tXRJ5yui3UFzrrGELaUyAltJWFtBFTwl0/ybCdncTwbNzuPBBO68hac9L3Q2ADEgZKi76WqPb0H5l7OLEk52Md2Zd/5qIi8o+fxVRC1HzN3IMX2Ei8XIVIwf0XFsfyzOpPOfaGml7PGY98Gb8ECProv2HVwq9jW0VxGtwRDV1Ae/rL5jPO+wqfl+TwPv4/RdYWXII/AOQiSYjNfcRW9IG5XOygQ6YxpMa5qGL8hoQzrHA9W9tPB+aoR8usIaTF4nYDdDBTlFgQOKbN4V/rMDLruGfS4QPKAa0GQzp7AktZAQhf4Cl5A0yMhPdFznlByy/1/wrWneIYm/0nOt/2ehYNFZwtW1b/YqUGm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [Medium] iommu/dma: unsafe list traversal in pisa_alloc_coherent() on
  list move
- [Low] iommu/dma: missing range check on wasted_pct in
  pisa_page_can_recycle()
- [Low] iommu/dma: unexplained EXPORT_SYMBOL change on
  pisa_page_can_recycle()
- [Low] iommu/dma: missing alloc_jiffies update in pisa_take_contig()
  error path
- [Low] iommu/dma: undocumented pisa.wasted_pct and pisa.old_ms boot
  parameters
--

commit b3ebe7c969492f612816f0a66cbeefb1c30a4e84
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Stop recycling old PISA pages when allocator waste is high

This commit records an allocation timestamp in struct pisa_meta and adds
the pisa.wasted_pct and pisa.old_ms parameters so pisa_page_can_recycle()
stops recycling blocks from old partially used 2MB pages when allocator
waste exceeds the threshold.

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index 1930135880d2b..5054a96f0f4e9 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c
> @@ -74,6 +74,14 @@ module_param_named(idle_ms, pisa_idle_ms, uint, 0644);
>  static unsigned int pisa_compact __read_mostly;
>  module_param_named(compact, pisa_compact, uint, 0644);
> =20
> +/* Stop recycling partial pages older than @pisa_old_ms when wasted bloc=
ks > @pisa_wasted_pct%. */
> +#define PISA_OLD_MS_MAX		100000U
> +static unsigned int pisa_wasted_pct __read_mostly;
> +module_param_named(wasted_pct, pisa_wasted_pct, uint, 0644);
> +
> +static unsigned int pisa_old_ms __read_mostly;
> +module_param_named(old_ms, pisa_old_ms, uint, 0644);
> +

[Severity: Low]
Since CONFIG_PISA is a bool Kconfig symbol, pisa.wasted_pct and
pisa.old_ms are built-in kernel command-line parameters.  Should they be
documented in Documentation/admin-guide/kernel-parameters.txt (with their
format, valid ranges, behavior, and architecture constraints)?  The later
commit "Documentation: Add PISA architecture documentation" in this series
lists their names under pisa.*=3D, but neither kernel-parameters.txt nor
Documentation/core-api/pisa.rst describes what they control or their
expected ranges.

[ ... ]

> @@ -603,7 +612,7 @@ static void pisa_return_block_locked(struct pisa_allo=
c *pa, struct page *block,
>   * pisa_page_can_recycle - Check if a block can stay cached in a caller =
pool
>   * @page: Block head page
>   *
> - * Called on the recycle fast path (per-CPU cache, TX page_frag, page_po=
ol).
> + * Called on the recycle fast path (per-CPU cache, TX page_frag).
>   * Fast-path cost is a static-key branch plus a READ_ONCE() of module pa=
rameters
>   * (~1-2 ns when compaction is off); when enabled, it does a lockless RC=
U +
>   * metadata array lookup (~5-10 ns).
> @@ -613,10 +622,11 @@ static void pisa_return_block_locked(struct pisa_al=
loc *pa, struct page *block,
>   */
>  bool pisa_page_can_recycle(const struct page *page)
>  {
> -	unsigned long bpp, in_use, free_blocks, pfn;
> +	unsigned int compact, wasted_pct, old_ms;
> +	unsigned long bpp, in_use, free_blocks;
>  	const struct pisa_meta *meta;
>  	const struct pisa_alloc *pa;
> -	unsigned int compact;
> +	unsigned long pfn;
>  	bool ret =3D true;
>  	u8 on_list;
>  	long held;
> @@ -625,7 +635,9 @@ bool pisa_page_can_recycle(const struct page *page)
>  		return true;
> =20
>  	compact =3D READ_ONCE(pisa_compact);
> -	if (!compact)
> +	wasted_pct =3D READ_ONCE(pisa_wasted_pct);
> +	old_ms =3D READ_ONCE(pisa_old_ms);
> +	if (!compact && (!wasted_pct || !old_ms))
>  		return true;
> =20
>  	pfn =3D page_to_pfn(page);
> @@ -638,6 +650,13 @@ bool pisa_page_can_recycle(const struct page *page)
>  	if (on_list =3D=3D PISA_LIST_FULL || on_list =3D=3D PISA_LIST_NONE)
>  		goto out;
> =20
> +	if (!compact) {
> +		unsigned long max_age =3D msecs_to_jiffies(min(old_ms, PISA_OLD_MS_MAX=
));
> +
> +		if (!time_after(jiffies, READ_ONCE(meta->alloc_jiffies) + max_age))
> +			goto out;
> +	}
> +
>  	pa =3D meta->pa;
>  	if (!pa)
>  		goto out;
> @@ -657,12 +676,21 @@ bool pisa_page_can_recycle(const struct page *page)
>  	free_blocks =3D held > 0 && (unsigned long)held * bpp > in_use ?
>  		      (unsigned long)held * bpp - in_use : 0;
> =20
> -	ret =3D free_blocks <=3D (unsigned long)compact * bpp;
> +	if (compact && free_blocks > (unsigned long)compact * bpp) {
> +		ret =3D false;
> +		goto out;
> +	}
> +	if (wasted_pct && old_ms && held > 0 &&
> +	    free_blocks * 100 > (unsigned long)held * bpp * wasted_pct) {
> +		unsigned long max_age =3D msecs_to_jiffies(min(old_ms, PISA_OLD_MS_MAX=
));
> +
> +		ret =3D !time_after(jiffies, READ_ONCE(meta->alloc_jiffies) + max_age);
> +	}

[Severity: Low]
What happens if pisa_wasted_pct is set to 100 or higher?

Unlike pisa_old_ms, which is clamped to PISA_OLD_MS_MAX, pisa_wasted_pct
is registered as an unconstrained uint and used unclamped.  Setting
wasted_pct >=3D 100 bypasses the early return in pisa_page_can_recycle() and
runs the RCU lookup and utilization calculation on every recycle check,
even though free_blocks * 100 > held * bpp * wasted_pct can never hold (or
can overflow unsigned long for large uint values when held * bpp is large,
spuriously forcing compaction).  Also, when compact =3D=3D 0, the earlier
!compact block has already verified time_after(jiffies, meta->alloc_jiffies
+ max_age), so recomputing max_age and time_after() here is redundant on
that path.

>  out:
>  	rcu_read_unlock();
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(pisa_page_can_recycle);
> +EXPORT_SYMBOL(pisa_page_can_recycle);

[Severity: Low]
Was changing EXPORT_SYMBOL_GPL() to EXPORT_SYMBOL() on
pisa_page_can_recycle() intentional?  The commit message does not mention
dropping the GPL restriction, and it still lists page_pool as a caller
governed by pisa_page_can_recycle() even though the kernel-doc update
above removes page_pool.

[ ... ]

> @@ -1454,8 +1485,10 @@ static struct page *pisa_take_contig(struct pisa_m=
eta *meta, unsigned int nblock
>  	}
> =20
>  	if (meta->on_list =3D=3D PISA_LIST_IDLE_CLEAN ||
> -	    meta->on_list =3D=3D PISA_LIST_IDLE_DIRTY)
> +	    meta->on_list =3D=3D PISA_LIST_IDLE_DIRTY) {
>  		pa->num_idle_pages--;
> +		WRITE_ONCE(meta->alloc_jiffies, jiffies);
> +	}

[Severity: Low]
Should the poisoned fallback path earlier in pisa_take_contig() also
update meta->alloc_jiffies when moving an idle page onto a partial list?

drivers/iommu/pisa-alloc.c:pisa_take_contig() {
    ...
		if (off >=3D bpp) {
			if (poisoned) {
				if (meta->on_list =3D=3D PISA_LIST_IDLE_CLEAN ||
				    meta->on_list =3D=3D PISA_LIST_IDLE_DIRTY)
					pa->num_idle_pages--;
				pisa_place_meta(meta);
			}
			return NULL;
		}
    ...
}

If pisa_take_contig() isolates a poisoned block on an idle page and then
fails to find nblocks contiguous blocks, pisa_place_meta() moves meta from
pa->idle onto pa->partial or pa->partial_dirty without setting
meta->alloc_jiffies.  Later allocations from that partial page will not
update meta->alloc_jiffies, leaving a stale timestamp from the page's
previous use and causing pisa_page_can_recycle() to treat blocks allocated
from it as already expired.

[ ... ]

> @@ -1544,6 +1577,7 @@ void *pisa_alloc_coherent(struct page **pagep, stru=
ct device *dev,
>  		spin_lock_irqsave(&pa->lock, flags);
>  		meta->pa =3D pa;
>  		meta->prot =3D pa->prot;
> +		WRITE_ONCE(meta->alloc_jiffies, jiffies);
>  		WRITE_ONCE(meta->flags, meta->flags | PISA_ACTIVE);
>  		pa->stats.page_alloc_cnt++;
>  		page =3D pisa_take_contig(meta, nblocks, align_mask);

[Severity: Medium]
Can the list_for_each_entry() loop just above this in
pisa_alloc_coherent() walk off into the wrong list if pisa_take_contig()
encounters a poisoned block and returns NULL?

drivers/iommu/pisa-alloc.c:pisa_alloc_coherent() {
    ...
	for (i =3D 0; i < ARRAY_SIZE(lists) && !page; i++) {
		list_for_each_entry(meta, lists[i], list) {
			page =3D pisa_take_contig(meta, nblocks, align_mask);
			if (page)
				break;
		}
	}
    ...
}

When pisa_take_contig() hits a poisoned block and fails to find nblocks
contiguous blocks (off >=3D bpp), it calls pisa_place_meta(meta) and returns
NULL.  pisa_place_meta() relinks &meta->list onto a different list head in
struct pisa_alloc (for example from pa->idle to pa->partial, or from
pa->partial to pa->partial_dirty).  Because list_for_each_entry() only
breaks when page is non-NULL, it then follows meta->list.next along the
new list while checking for termination against lists[i], walking past the
new list's head in struct pisa_alloc and dereferencing struct pisa_alloc
as a struct pisa_meta.  This was introduced earlier in this series in
commit "iommu/dma: Add PISA block allocation"; using
list_for_each_entry_safe() fixes the traversal.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D19

