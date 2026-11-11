Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C72606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MgB914t7
Received: by kanga.kvack.org (Postfix)
	id E7C9A6B05B0; Tue, 10 Nov 2026 19:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E539D6B05B1; Tue, 10 Nov 2026 19:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90AB6B05B2; Tue, 10 Nov 2026 19:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD6476B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:37:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26EB3140165
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:37:54 +0000 (UTC)
X-FDA: 85420975668.13.BFE3B44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F01D120004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:37:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgB914t7;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794357472;
	b=P6QWskb1xMFY2ccuK7fmobrWmVHfJ/pf6RKwvVjCdEI6IRBWeF12Cd6v4A5IhxjhUX0xHh
	vizjNN+MM51BxCCfiyOx6lge4HrqyLMvkGDBMxlp30fVv0QXTKIFCscJao6W5pqper5s9c
	CZGpO+CIYiRkJ91e66F3GTkV1LjDON4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgB914t7;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794357472;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MW+BYa03x6O0BCaaNQi2IqCMMz8W8XvZxNxwWAD/O0=;
	b=G7hCkml19qVa2BwGKazXEGkboKUNfUuV/T0Sdv6mujZOzESzp62cvagDvD/JJJUCC4HloK
	GYW/U1GiFRJ5cZFKLER9TS+P9cVDJxfzNayDLAw7dQRqmMoJXa6DFo1+OeD9uB/Gl5LRn4
	xw2HfYsTqgLB6uBAdtMZxGLq4bNLtTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E2B64481B;
	Wed, 11 Nov 2026 00:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E071F0093D;
	Wed, 11 Nov 2026 00:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794357471;
	bh=2MW+BYa03x6O0BCaaNQi2IqCMMz8W8XvZxNxwWAD/O0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MgB914t7MhjCHdAOMgBSwMHRY+/2DiSjhLxSpUwJ4Yq/HPDB8wd3UQg+3jWIz11eP
	 Prm9ffDYI6vZMPPtMoWv6ZUvwNq21m9Db/hA2y3nPUXESa1Gkmp3Ab7dtm/Eoltb5Y
	 /TFuLl7s7CWGLJnZVS9LXtKs24LbS25HzzMFgppSui1shEFoqSYU2cR1ZeGkB0Yhs8
	 Olwcg+XMNJZ2uI9UknvDjJugVANaUaRMXuLy5dv+fgdobJW5Y6GdqFDV0uwetJoRfL
	 Yif87fL8O9Wa+LEZhgatZ3uclAmL9OWOsR9snZEzRSfQhkZ7l09eXPTYoGNjx9d8po
	 ++v/A+G56f+Pw==
Message-ID: <sashiko-outbox-208026@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 15/25] iommu/dma: Add background page scrubber
 for PISA allocators
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
In-Reply-To: <20261109182533.3594984-16-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-16-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 00:37:49 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F01D120004
X-Stat-Signature: jite14iu71w3sptqhzf8qayxbbdp1rqc
X-Rspam-User: 
X-HE-Tag: 1794357472-25462
X-HE-Meta: U2FsdGVkX1+2/DZzffRwQT4G+DjyPAUjqtLNazhcewJf5c6y01FVmIqpvZYbZ8/E1zRd4Hz9A7NeuDGjwvevn3VNJKKUKtYVaKFxhTR9FUq9TVuMw0gJtqXfhqGxYKYutaA/SGp+QOvdPGAdEXyqcPw9Qb/MGIYfH2n1s0R8IWRfP496NN4Eys4DVENMAG5uJbSknd9jlcaKQ8l2wqLqkK8QRZmwPbWklQc4s/kjVq4yOt+VbXJONTKIq8D5wzOdP6mfRe3Ksr8vSg887cMWLwAOeCeB2gw7lARmLpjYJfzcTC/TP04xGarNhnlV1pdirvzMCrp8iVU85ZGG9B0XbfHjaR2ySzFrpt53litKm2YnH0cFf/Wg/101MYXHqqCA5HfbZD5aV39+f8uW1/7C+SlfsFqgqxoaLNKqfXdMkAfjUaTONVsJ5mfgP5kB6IhCetbVri9+UgUXYYOcjZ34VxSPISvI22B7zSiDs6VtVoNLDhz+0XD1KoRRQ+Rjh858nJ8HFT/ORLGO3VhyhWT/G7jUB5GyCcM9vIE1465l7uS1uslSlABfXmXWHxivqX1b65K9UVXldUj+E3sryzn68bjw3a4EgBgoBSaoABMXka2CFOioT27SRLvAD6Tnq029/WLRydbCW1Tgdnn5QSEAd4im+SyLrfY8lNLIZoz5axZAUS/Ik0gNwEXqFg/Qbn5gfNlUD8SQOA6gpNykTFZyAS8Mwl0lqGsi/y4FXXkNnZXXOdueasAknZQHLCnXORLiCThlN/3kpYkijIi1rtTDXey4Z/UI8YoPDirIrWJKlTW0twkuv6Zi7igFJwq6RVoej9ijKvdJ5aENLhtki+hSjreV0Ssf82JjJEU0fjWmLaIS6ZKwtCJy8cwWjK1wlk1ufnibvlEO8QfAekl/xv6f+csMVyb5wDl9BjzZFPTiTbF9/Cmo7YCHwV8pPEba/0gbwWOGF6suCQZIvgl11pj
 ha/37HFv
 y8NCRotDPDBRKG9r/IvwosRbTkW+b1W2S00KjmqqIKbY2PXxt+KcOCl7h8tW/czdKfCke+mejkfH1NYdSLLKH2zZgh29ZmXZsTvxovd5YvuQ6TekoawUFHgyR9TQJGtnqZfAPYkjqtqAfR4U26cxQmdy0y7jii5kJQWFKGN1ht1JvIyhVxw8AEbAGy1T/f1n2/vNBpQN4uCPB68uOBHMmyjG3va1ve2CmclEllHJ7AfCLhRR72RDl93/Q0Y9TMRI7jgim5a7f6f1skt2VzE4upE8SWix1b+RP5dga5BAbRg0cnGUkzTpbSkU+YkKuBFyMJvjG5s6JsvVh8yhTpoBLjmA0FB/ErKWh+/19cykEJcZKXzAqNXKscG54UCGeNivTakqMi95lQWCrcj+NcdYTJxa+oV+RACZED9Pf5Kkq3GTQ9HOADP2keKZa+sqKfGnidE8X8TYkIfAuT1a7HWzhruluXg4M/04W9KVwuQxINtKDR3kkb5BkF9MxLv8w9mXXEDV4ahNjGJjRGkQEYy3rudD/3SY7WPUFATbXhOMSiStrbXDo/dD9hSvEISJZ3gqPTaXnTjv3ZthSEm1Mbz5HWop7yulkMhr8ZuleZawRSygpbC0ePQWli2F3ke46HIQd1256pgxweKNUtZlCDcoCNmv1zyMYRya2GVpH
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
- [Medium] iommu/dma: redundant memset() of scrubbed blocks in
  pisa_alloc_coherent()
- [Low] iommu/dma: race with async refill when trimming reservoir in
  KUnit test
--

commit aab269faff1eb0d2c96bc73f80823d9c0113582c
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Add background page scrubber for PISA allocators

This commit adds an optional demand-driven background page scrubber for
PISA allocators that zeroes dirty blocks on each NUMA node's work item and
moves them to clean_bitmap.

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index b4a25c65bf97e..4b61ec84ed6d1 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c

[ ... ]

> @@ -1166,11 +1339,13 @@ static struct page *pisa_take_contig(struct pisa_=
meta *meta, unsigned int nblock
>  		} else {
>  			__clear_bit(off + i, meta->dirty_bitmap);
>  			meta->nr_dirty--;
> +			dirty++;
>  		}
>  		pisa_block_prep(page + i);
>  		page_ref_unfreeze(page + i, 1);
>  	}
>  	pa->blocks_in_use +=3D nblocks;
> +	pa->scrub_demand =3D min(pa->scrub_demand + dirty, PISA_SCRUB_DEMAND_MA=
X);
>  	pisa_place_meta(meta);
>  	return page;
>  }
> @@ -1185,7 +1360,7 @@ void *pisa_alloc_coherent(struct page **pagep, stru=
ct device *dev,
>  			  struct iommu_domain *domain, size_t size,
>  			  gfp_t gfp, unsigned long attrs)
>  {
> -	bool should_release =3D false;
> +	bool should_scrub =3D false, should_release =3D false;
>  	struct list_head *lists[3];
>  	unsigned long align_mask, flags;
>  	unsigned int nblocks, i;
> @@ -1234,10 +1409,14 @@ void *pisa_alloc_coherent(struct page **pagep, st=
ruct device *dev,
>  		}
>  	}
>  	if (!page) {
> +		should_scrub |=3D pa->scrub_demand >=3D PISA_SCRUB_TRIGGER;
>  		spin_unlock_irqrestore(&pa->lock, flags);
>  		meta =3D pisa_alloc_split_page(0, gfp, pa->nid);
> -		if (IS_ERR(meta))
> +		if (IS_ERR(meta)) {
> +			if (should_scrub)
> +				pisa_schedule_scrub(pa->nid);
>  			return NULL;
> +		}
>  		spin_lock_irqsave(&pa->lock, flags);
>  		meta->pa =3D pa;
>  		meta->prot =3D pa->prot;
> @@ -1247,10 +1426,13 @@ void *pisa_alloc_coherent(struct page **pagep, st=
ruct device *dev,
>  		if (unlikely(!page))
>  			should_release =3D pisa_place_meta(meta);
>  	}
> +	should_scrub |=3D pa->scrub_demand >=3D PISA_SCRUB_TRIGGER;
>  	spin_unlock_irqrestore(&pa->lock, flags);
> =20
>  	if (should_release)
>  		pisa_schedule_reclaim();
> +	if (should_scrub)
> +		pisa_schedule_scrub(pa->nid);
>  	if (!page)
>  		return NULL;
>  	*pagep =3D page;

[Severity: Medium]
Does pisa_alloc_coherent() end up zeroing blocks twice when background
scrubbing is enabled?

pisa_take_contig() charges dirty blocks to pa->scrub_demand and
pisa_alloc_coherent() schedules the background scrubber on the per-node
order-0 RW allocator, which zeroes dirty blocks and moves them to
meta->clean_bitmap.  However, unlike __pisa_alloc_bulk(),
pisa_alloc_coherent() unconditionally calls memset(page_address(page), 0,
size) at the end of the function even when blocks were taken from
meta->clean_bitmap (and pisa_pcp_alloc() on the same allocator also refills
with zero =3D false and zeroes inline), so background-scrubbed blocks are
always zeroed again on allocation.

> diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
> index b63cd6585b673..40bf7801183da 100644
> --- a/drivers/iommu/pisa-kunit.c
> +++ b/drivers/iommu/pisa-kunit.c
> @@ -572,8 +572,53 @@ static void test_gfp_pisa(struct kunit *test)
> =20
>  static void test_reservoir_and_scrubber(struct kunit *test)
>  {
> -	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
> -	KUNIT_EXPECT_EQ(test, READ_ONCE(pisa_reservoir_max), 16U);
> +	unsigned int old_res =3D READ_ONCE(pisa_reservoir_max);
> +	unsigned int old_scrub =3D READ_ONCE(pisa_scrub_max);
> +	struct shrink_control sc =3D { .nr_to_scan =3D ULONG_MAX };
> +	struct pisa_meta *meta;
> +	struct pisa_alloc *pa;
> +	struct page *p;
> +	int nid;
> +
> +	pisa_shrink_scan(NULL, &sc);
> +
> +	/* Refill reservoir to 1 PISA page per memory node, then consume one. */
> +	WRITE_ONCE(pisa_reservoir_max, 1);
> +	pisa_schedule_reservoir();
> +	for_each_node_state(nid, N_MEMORY)
> +		flush_work(&pisa_nodes[nid].work);
> +	KUNIT_EXPECT_GE(test, pisa_reservoir_count(), 1UL);
> +
> +	pa =3D pisa_node_pa(first_memory_node, 2, true);
> +	KUNIT_ASSERT_NOT_NULL(test, pa);
> +	p =3D pisa_alloc(pa, GFP_KERNEL);
> +	if (p) {
> +		meta =3D pisa_meta_of_pfn(page_to_pfn(p));
> +		/* Reservoir pages come pre-zeroed (all remaining blocks clean). */
> +		KUNIT_EXPECT_EQ(test, meta->nr_dirty, 0U);
> +		__free_pages(p, 2);
> +		if (!want_init_on_free()) {
> +			KUNIT_EXPECT_EQ(test, meta->nr_dirty, 1U);
> +
> +			/* Scrub dirty block back into clean_bitmap. */
> +			pa->scrub_demand =3D 1;
> +			WRITE_ONCE(pisa_scrub_max, 512);
> +			pisa_scrub_node(pa->nid);
> +			KUNIT_EXPECT_EQ(test, meta->nr_dirty, 0U);
> +		}
> +	}
> +	pisa_shrink_scan(NULL, &sc);
> +
> +	/* Trim reservoirs back to 0. */
> +	WRITE_ONCE(pisa_reservoir_max, 0);
> +	pisa_schedule_reservoir();
> +	for_each_node_state(nid, N_MEMORY)
> +		flush_work(&pisa_nodes[nid].work);
> +	KUNIT_EXPECT_EQ(test, pisa_reservoir_count(), 0UL);

[Severity: Low]
Can an in-flight refill race with the trim step and cause
KUNIT_EXPECT_EQ(test, pisa_reservoir_count(), 0UL) to fail?

Popping a page from the reservoir in pisa_alloc() drops res->nr_pages from
1 to 0 while pisa_reservoir_max is still 1, which queues res->work to
refill the node:

CPU0 (kunit)                      CPU1 (kworker)
pisa_alloc(pa, GFP_KERNEL)
  pisa_reservoir_pop_node()
    res->nr_pages-- (0)
    pisa_schedule_reservoir_node()
      queue_work_node(..., &res->work)
                                  pisa_node_work_fn()
                                    pisa_reservoir_trim_node()
                                    pisa_reservoir_refill_node()
                                      /* reads pisa_reservoir_max =3D=3D 1 =
*/
                                      __pisa_page_alloc()
WRITE_ONCE(pisa_reservoir_max, 0)
pisa_schedule_reservoir()
  pisa_schedule_reservoir_node()
    /* nr_pages (0) =3D=3D max (0),
     * does not re-queue res->work
     */
                                      spin_lock_irqsave(&res->lock, ...)
                                      list_add(&meta->list, &res->pages)
                                      res->nr_pages++ (1)
                                      spin_unlock_irqrestore(&res->lock, ..=
.)
flush_work(&pisa_nodes[nid].work)
KUNIT_EXPECT_EQ(...,
  pisa_reservoir_count(), 0UL)  <-- fails (count is 1)

Flushing pisa_nodes[nid].work before setting pisa_reservoir_max to 0 (or
re-checking pisa_reservoir_max under res->lock in
pisa_reservoir_refill_node()) would avoid this race.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D15

