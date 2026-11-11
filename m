Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C577606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hydp5Dqd
Received: by kanga.kvack.org (Postfix)
	id 740416B05C2; Tue, 10 Nov 2026 23:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F14D6B05C3; Tue, 10 Nov 2026 23:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA5C6B05C4; Tue, 10 Nov 2026 23:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27A616B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:37:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77B3BA76FD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:37:41 +0000 (UTC)
X-FDA: 85421579922.23.64C38AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C5922100008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:37:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hydp5Dqd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371859;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZPH+T2LpNrsQ8rakui1hikMGCApe7kA1pNrNGa7Lak=;
	b=T2XuEkP4aWANaqRDnqHAwYFTjRJWvdIyGwVOMN16CpCbCVdv6IaN4jPeKCsubAr1LCm7M5
	hEQucBwSCxg4k8WZqGWNYl8bHeYqP1saz69YNtsJajjsz4yDDCq/esbdP8QXDhTLaGXmuZ
	KwynH/rBzu95S5+RxhEf20zHvDlrJBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371860;
	b=8Ay6nwyGfM8iS6MpBbKZqGYQ7qZv7cm93zWjcK0VuIHC5aN6AmRdMib8BXDM7wZMlUiiZq
	bhzN6GWPLIBl/F557Lvm9rdxK9REW/L45Do9Uk3uP5ESKuuDBCWSrQH2NApiTDZv661LM7
	LBI87TU1tFn93JiJIkoywX2Tgv/vCQ0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hydp5Dqd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 067794464D;
	Wed, 11 Nov 2026 04:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B0C1F0089F;
	Wed, 11 Nov 2026 04:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794371858;
	bh=2ZPH+T2LpNrsQ8rakui1hikMGCApe7kA1pNrNGa7Lak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hydp5DqdGgIfbE9qp68xwyw9h7nxEj1ggevXshBbEvaTYvenegYL1vDcCk4kPbKv2
	 m7kflgvx1gw5Rl8i9nf5hO5vCeEqyvrVwJTzULc6E9AUrhFBWzfVQzfskMIIzYc884
	 UptaTtKQXuKxZdjgioTOBwxH2aT71sY+sP+4d/5UYXTzfYqTjLqt7UzHMPJrfARMFy
	 m1lfY3/pSyyr+FjQtJLlgMlGbp9Mf97Rnb7Pt9nB4YX8LlYalGHvcIxikYqvnQLe0m
	 7FA6mNKX6nTR0GyatC+DXfZCgDL7cDsvNQY0/wMVW0bCZeYqucS5HLIoX8jOVuIyTC
	 5rDVOL9jhJMyA==
Message-ID: <sashiko-outbox-208304@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 25/25] iommu/dma: Add PISA statistics and debugfs
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
In-Reply-To: <20261109182533.3594984-26-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-26-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 04:37:37 +0000
X-Stat-Signature: q13zjwy7w7er98gaa63dco51nrzqb8uw
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C5922100008
X-HE-Tag: 1794371859-407684
X-HE-Meta: U2FsdGVkX18BMf/uNpvdZrBQEkxTqBOJsFdEeg0atxpXAW5eMPH1wdkF9URVOq9VFa4f9zZVTZFBxPGV4brPs5eKs6djrHx34zCPd9S5MwwDm+Y+FsWrZc02nb0J2ord7kT7DNHMM6H4k8dhjuitG7BLR9vjORaLV/uGE8lxhAmvu3uTTD99YWSickNTdFl/IiGrHEfN1QDDP1yUXtlW8nJP7PoHN4dEPb+wBORNUnBjed7OgBL9tRjSdGUrj/ixYeLtkMANJqzHq8AkQN/25P7Hr/5+jveHsZDqIaNjtZMqyRefAuhxkbsiE3q/uMWnYdIHqG5QsKX3ortjgpXCO1rHDfc+b7/m/KjM5iPn2ayCy8/CUqDQ2SKobMNTS387Beocx36OigPn/R20PWeOcerMCkdXUQJ4v9ZgueOFrEavYXvl1XZOmNFFNSEznVD+F7EzHj9zo/BcvWT7cb+HBwPVi2CI+cZwHw188wKzF2+cnqQoDEVPj89nXQwEpLdWtOCq411rUgWg5KVlBIfYgWy+6PniPhq+j6O4JC7PQXPEjqEJN2YGWkYMvWGfOPyWlelt893Uav/6w+ZdtbaGMtyFMuhHF9O97eTFwqpBa/ZqM2fkZdBufWwAk6F9qk2X4jlTe9nYbF1vCAwQRqh/8/pvquzOiDPrVXN0pDoq3GZlc9kxEQ3RU6wxSISxHFTxBH3Hxq0lQaGRKrvTB/B0cP1j+UWEnycmHjaS/Ilo3K9bfaN37DmZcWbGz0OuIaqXWTZmL6C3u/oS3j1GqGILKtobu6SXDoa0iQdt2bqyqd1jXlJlZh+wW3eKnfWSbQV6/gJMo/nlFC5Xso+42Ld4DG3NVf9G7/kor5ivlirFmNHEF0eNLn43W3WDuZXgkJpecnI4zfYdTaB5kVz3wez0RbcRwyq2rRZqX1r5u7edVg0ufvfhcb1v7m6CpZ5iFg7XXgxCPStsWmGj0k6f4+f
 Jv9nYIqt
 lPj0QH9kpkHEmkoxQjdQYBDKZTBpVPV3qzGzyOEFfFaYyt1bzaxSS4qDk0B41eQpeV8vxV7BiV4SVwrb6PprNVr54baDt5ruOSD28zXn00kQk0cxtfsxFcKOBUgLgoqpIvbkLcWLoIMY3GvmmKv9/wdjSHIPJkCdjYXN5Wfz0s897h5A/qA3+FzgMmnLwqydtrI3FtfXy9VN7HNysq8ezIBq8wYDALR3HcvMkLoi2YiJCHX/f2gcP99hn0KRRWfXeUlL3COIYbXd+ovjSzm9TKAbGZPmvWgtEZYznFfRCPdrcPcWwBWMQAEk/CZwNxVAiBcSNgaV9aHmew4RG8ORi+o4P3GcnGu9mNHeChjNuoVV989m4+Hc2ja/8EBTrDCWxUvtW6O3oIJvpQIEirFOL/fxZTWMShiPYt6OOVgSLE67EjfAOD4X0/0bmP9WFCfWHWEmud/x8SFdzxH8KBpH2Wlj85LXkmJnsIqqGc2hmGJsrv05BVN0lQex75fshSgXgjX27DDZVVpSly/gecFOibQq3iCJp+YKH4L1LODE2bx/Hdb3BA2y/g/pHJWQonJmDYEvltAV15+X9sspC6txusiyfDqKnVvcwo8xHNV+rFBaoxhXvzGY/K6nrr+wc2aYWy3NLP17seIH7HazLasGonnodZys9MEuhL09L
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
- [Low] iommu/dma: missing failure and NUMA stats in
  pisa_alloc_coherent()
- [Low] iommu/dma: miscounted user page budget and skip stats in
  pisa-user.c
--

commit 56bd3064c75263649c376476a3726d7efc12bd48
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Add PISA statistics and debugfs

This commit adds per-allocator, per-node reservoir, user-page migration,
and global shrinker/reclaim statistics for PISA, exposes them in
/sys/kernel/debug/pisa/allocs, and logs a one-shot warning on the first
2MB buddy allocation failure.

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index cedb1a62d20e2..91b9f00d21985 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c

[ ... ]

> @@ -1310,15 +1369,31 @@ static unsigned long __pisa_alloc_bulk(struct pis=
a_alloc *pa, gfp_t gfp, unsigne
>  		spin_unlock_irqrestore(&pa->lock, flags);
>  		/* With @zero, fresh dirty blocks are zeroed below. */
>  		meta =3D pisa_alloc_split_page(pa->order, gfp, pa->nid);
> -		if (IS_ERR(meta))
> +		if (IS_ERR(meta)) {
> +			long err =3D PTR_ERR(meta);
> +
> +			if (err =3D=3D -EAGAIN) {
> +				pisa_stat_atomic_inc(pa->stats.fail_backoff);
> +			} else if (err =3D=3D -ENOSPC) {
> +				pisa_stat_atomic_inc(pa->stats.fail_budget);
> +			} else if (err =3D=3D -ENOMEM) {
> +				pisa_stat_atomic_inc(pa->stats.fail_nomem);
> +				pr_warn_once("pisa: order-%u allocation failed for allocator %p; fur=
ther failures are counted in debugfs only\n",
> +					     PISA_ORDER, pa);
> +			} else if (err =3D=3D -EBUSY) {
> +				pisa_stat_atomic_inc(pa->stats.fail_split);
> +			}
> +			if (!n)
> +				pisa_stat_atomic_inc(pa->stats.block_alloc_fail);
>  			goto out;
> +		}
>  		spin_lock_irqsave(&pa->lock, flags);
>  		meta->pa =3D pa;
>  		meta->prot =3D pa->prot;
>  		WRITE_ONCE(meta->alloc_jiffies, jiffies);
>  		/* Set PISA_ACTIVE after @meta is fully set up. */
>  		WRITE_ONCE(meta->flags, meta->flags | PISA_ACTIVE);
> -		pa->stats.page_alloc_cnt++;
> +		pisa_stat_inc(pa->stats.page_alloc_cnt);
>  	}

[ ... ]

> @@ -1500,6 +1593,9 @@ static struct page *pisa_take_contig(struct pisa_me=
ta *meta, unsigned int nblock
>  		page_ref_unfreeze(page + i, 1);
>  	}
>  	pa->blocks_in_use +=3D nblocks;
> +	pisa_stat_add(pa->stats.block_alloc_cnt, nblocks);
> +	pisa_stat_add(pa->stats.alloc_kc, nblocks - dirty);
> +	pisa_stat_add(pa->stats.alloc_ks, dirty);
>  	pa->scrub_demand =3D min(pa->scrub_demand + dirty, PISA_SCRUB_DEMAND_MA=
X);
>  	pisa_place_meta(meta);
>  	return page;
> @@ -1577,7 +1673,7 @@ void *pisa_alloc_coherent(struct page **pagep, stru=
ct device *dev,
>  		meta->prot =3D pa->prot;
>  		WRITE_ONCE(meta->alloc_jiffies, jiffies);
>  		WRITE_ONCE(meta->flags, meta->flags | PISA_ACTIVE);
> -		pa->stats.page_alloc_cnt++;
> +		pisa_stat_inc(pa->stats.page_alloc_cnt);
>  		page =3D pisa_take_contig(meta, nblocks, align_mask);
>  		if (unlikely(!page))
>  			should_release =3D pisa_place_meta(meta);

[Severity: Low]
Should pisa_alloc_coherent() and pisa_take_contig() also update the
allocator failure and NUMA mismatch counters?

Because the failure accounting and pr_warn_once() live in
__pisa_alloc_bulk() rather than pisa_alloc_split_page(), a
pisa_alloc_split_page() failure in pisa_alloc_coherent() returns NULL
without updating pa->stats.fail_*, pa->stats.block_alloc_fail, or
emitting the one-shot warning on -ENOMEM, and leaves an allocator with
no prior allocations hidden from /sys/kernel/debug/pisa/allocs:

drivers/iommu/pisa-alloc.c:pisa_alloc_coherent() {
	...
		meta =3D pisa_alloc_split_page(0, gfp, pa->nid);
		if (IS_ERR(meta)) {
			if (should_scrub)
				pisa_schedule_scrub(pa->nid);
			return NULL;
		}
}

In addition, unlike take_blocks(), pisa_take_contig() does not add
nblocks to pa->stats.numa_mismatch_cnt when page_to_nid(page) !=3D pa->nid.

> diff --git a/drivers/iommu/pisa-user.c b/drivers/iommu/pisa-user.c
> index 7dca3bf066f0d..5cf199943f82c 100644
> --- a/drivers/iommu/pisa-user.c
> +++ b/drivers/iommu/pisa-user.c

[ ... ]

> @@ -264,9 +288,17 @@ static unsigned int pisa_user_migrate_dir(struct lis=
t_head *list, bool to_pisa,
>  		if (!gfpflags_allow_blocking(gfp))
>  			mode =3D MIGRATE_ASYNC;
>  	}
> +	nr =3D list_count_nodes(list);	/* all order-0 */
>  	if (migrate_pages(list, to_pisa ? pisa_user_new_folio : pisa_user_old_f=
olio,
>  			  NULL, (unsigned long)&mtc, mode, MR_SYSCALL, &done))
>  		putback_movable_pages(list);
> +	if (to_pisa) {
> +		pisa_stat_atomic_add(pisa_user_stats.in, done);
> +		pisa_stat_atomic_add(pisa_user_stats.in_fail, nr - done);
> +	} else {
> +		pisa_stat_atomic_add(pisa_user_stats.out, done);
> +		pisa_stat_atomic_add(pisa_user_stats.out_fail, nr - done);
> +	}
>  	return done;
>  }

[ ... ]

> @@ -583,9 +623,14 @@ int pisa_madvise(struct vm_area_struct *vma, unsigne=
d long start, unsigned long
>  		struct folio *folio =3D folio_walk_start(&fw, vma, addr, 0);
> =20
>  		if (folio) {
> -			if (pisa_user_want_dir(folio, to_pisa, DMA_TO_DEVICE, false) &&
> -			    !pisa_user_busy(folio, 0) && isolate_folio_to_list(folio, &list))
> -				n++;
> +			if (to_pisa && folio_test_large(folio) && folio_test_anon(folio)) {
> +				pisa_stat_atomic_inc(pisa_user_stats.large);
> +			} else if (pisa_user_want_dir(folio, to_pisa, DMA_TO_DEVICE, false)) {
> +				if (pisa_user_busy(folio, 0))
> +					pisa_stat_atomic_inc(pisa_user_stats.busy);
> +				else if (isolate_folio_to_list(folio, &list))
> +					n++;
> +			}
>  			folio_walk_end(&fw, vma);
>  		}
>  		if (n =3D=3D PISA_USER_BATCH) {

[Severity: Low]
Does pisa_madvise() count budget exhaustion as pisa_user_stats.in_fail
instead of pisa_user_stats.no_budget?

Unlike pisa_upgrade_user_pages(), pisa_madvise() isolates folios without
checking pisa_user_budget().  When the user page budget is exhausted (or
runs out mid-batch in pisa_user_new_folio()), migrate_pages() aborts and
pisa_user_migrate_dir() charges the unmigrated folios (nr - done) to
pisa_user_stats.in_fail rather than pisa_user_stats.no_budget.

Similarly, pisa_folio_upgrade() returns early when pisa_user_budget() <=3D 0
or pisa_user_busy(folio, 1) is true without incrementing
pisa_user_stats.no_budget or pisa_user_stats.busy.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D25

