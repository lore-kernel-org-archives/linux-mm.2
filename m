Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72380606A6AB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZV/lihAn
Received: by kanga.kvack.org (Postfix)
	id E437E6B05BF; Fri, 20 Nov 2026 20:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AB76B05C1; Fri, 20 Nov 2026 20:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54C46B05BF; Fri, 20 Nov 2026 20:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B00B76B05BF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44CFA16028E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:39 +0000 (UTC)
X-FDA: 85457343678.02.479B99C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A9DFBC0007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZV/lihAn";
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223377;
	b=8hA8aYm4gme8OsXLjWdoRyXY3g500w4zscZZKDKCzp40iH505tEQ68nN89s8n4yGgKRY7f
	v9EX3kuzbcjdIxK8VFsXx999iMP5kun+0apkVWK5VK1bI2aCrSNhgQJQss5UKl2J789F8v
	zMxLe6EmbtBtlNojlSQkLuAHdvvc29k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223377;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwouuZUpxbLLrowpuddDLWpdBddsShOx+ZScJGTwIGs=;
	b=lcnmFipTgOk+uR7UvpgeyQzuLwFOYnHsfgDgzCG1HvVRvZHV4o3pjJqrPfWEFM69258e/7
	oyFx63X+RHyqWSc7QApvBgftGEQNk952tp/pr0tCWIk0MSvCGilNkXEhiDBKsZpjBApXJK
	DmqHBlwZ9uspFMdbdEl3vYnY5384swU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZV/lihAn";
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0888742A92;
	Sat, 21 Nov 2026 01:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E8A1F000D0;
	Sat, 21 Nov 2026 01:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223376;
	bh=qwouuZUpxbLLrowpuddDLWpdBddsShOx+ZScJGTwIGs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZV/lihAnJhsQldJV7c0LbbWPKvENtq1RmS1kQ5e0U+wE+wGzQKpmt21NuYhr1XkDi
	 Zysr5oy63xT7/6KLXVC1HecQrVLZ0TJPGTx27xZnhsNF3qcSXaF9ecuS4yhC2Ilt16
	 tAVBYmkJ3gF/YWpz/eilkfyB5paWgpIg/vrYs03d8R2JuQ0EQZnGFzvlE8H0ORG2T8
	 ejOh0wikpz6kzWPpKuZBAMoAccISgrVDXIGSwPeSUUQNnuDpbyIJwuJJE7irgP6tRI
	 6V5s9mtn9sOBzE6Ln1+a7eKM1++6UMURBAc2juhIEzm81cmc4W7985XCjEzhSjhbzH
	 iL7BN97H7Mu0w==
Message-ID: <sashiko-outbox-226476@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 12/25] block, mm: Support PISA for disk I/O and
 scrub migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-13-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-13-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:34 +0000
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A9DFBC0007
X-Stat-Signature: os6sbs71mge6sfqnmujz8wedrwmg5ws3
X-Rspam-User:
X-HE-Tag: 1795223377-413387
X-HE-Meta: U2FsdGVkX18Ji/EZxwq6PK475pCCfJMEs3lEBXT65/QQ0uNRb4etqsTOdm5Teo7GSGm0RLk40YqMTtp8fvt6GusfJtvkPB2mIIotvCC6pmtGJBDlrR7wXMhCXkapZH6JBovexd1RcSGhGn3j+8Pb4nqRSlBAyoLGU5nBuhYb7sGkWz+ozSjNWBCR4i2rH/86mexb7GkWQ2+O2lEFN8Rb2dOdODoK5quqedHbg2sx+0HTqw7ebBl0/xuOoprrBrPnsJCv4aI/9BJP4hDbiP4Ej62dl1t1tcDia56e8gj3hVDpC/R9HUT5/Kfdg5FCoGoFkGRRNWtKGS/dF8C1mwVWXzcqu6vS4gadN5yQocZo7l52MZDxxWyfhSajLuRHQsMUjGCBUsczWhkupFSYkJwMYO0IecCjZOeTXk+LYuDiJl68T3hWdNPdnBRDmftBR8E0PfLcwp/yj+98uczsuV5vdtglHexrMM+UsGNMSJUE3YVVw5hUn8XyO7MF+McRzaDcJQEJqZRKqrQczTkOvF5PHJsmdTKLE7YJD6UoqMzgoIwovBxdprzU21uRnV2y7UPU5X8sxzf5YQETxKvvUt4uaE3wLtMnBX+he9lkhVDILCAE2/7tR+2d5fub8JTXOdNjqr4P3z+fsy/OCVRpn3d6HjKYvWrsC1BDOIG+3KAVcJgd+BCvS0iMlOuiSBYRj2+QTvd3QtV+0X2zD3JDpu8pOy9neLkCbN0n6mH/TwCKywO/nx/rF5NETErxsknx0dgDm9Cki5Yjmy7gf8gBBZ55vn8IXCkT7ygmx+Rx3TaLPzAX9PAJC9c5t/OMH4wByI+AY8TVfUVJtCZ8nbZbB3uafzuDkBFluT/6EYOROAmyjH9+aynigLvzuwEZ0eaz2UR2vF5FoLU/x7Fwb026CSKTxmxKeRm67zJxcW4P0AP1gFGBBN3LlQOfvRA0J5tUEBTDgKmfOYmT3qxhdTp7SYc
 /sdrrFEk
 /QHWkGOQOr+QloNLhN58LqxCT8oSIUkNMuio7FjvaEQyA6ce1dj/EQpGTBgm7RJ4ir96CDKd2fBekym+aT4J+4a5dVJcEsfVIUE2/ZEhRusBjhza3oMUKR99ykFYGFqebtRbDDl6CjDhwHEYm+qZlSBBNdODyNv8OnqSr9rTXrd/7siAd5dZRCPAu4aHINVa4m3BRHZrZvCWACrc6aRQI7ror4g8K0QLKXvl3mKCchd8tfvnNcsfmk+J8RrKfS1g06wsNYkkpp9azfAf3AroebwNjnTRoiEi5ruMq8Ye7HN0sre/P6l6pJr/jz4cNqFfI0OUOe3zYnlrcptY2ZeU6kdsA8kI9mBTU0WMc1WX9MkMivu4BP0yP0jOnnnZVEkESMDt8kDIRYaRRZTFum5TEnz+2cEAaaf/Znd/D64nhI5V7jP4bpHTOH39YcuxTrhggyhEuR/6+tIGf6KBlFBAemqj0NKK6Ud41w2E+nYWeqEtmN6tjQPw4FcgZMvc8i7cfIc7wNSfRPgzrXcQ3cMbk/GW4eoAXkiOARsbtX3yu7Ea9b71rkPey5dPH+Fv2LSsVBOw1ToPaKg207e3TmUGYcJffaxCh31y+Rd9GPa6oHqqzd/3LPdREq/vO324OAinMYQuCHzCXwFROa1DZt74PDVnTQxp5Kof6Dfu88EJbGjgF31vWkwmFlXbfT+b8OiABNgfoUcZmsqvLxxhdNvU0ouIcwHzh5hWslXcvQvUtnF4V6Fqbai5BxoxTQhuI85ESHxEZLLH5JpBz5VzsEPdnk09ru30MDEtPoqOxf9XYOzQb40Km4H3gt/s+ddQk3HuGkRPOhIypyezL+cWzWadWHO4vg6MB85MiBg2gMzbRCLJeDLNY1+XvRMLEAKQgBCGcuuQbQiCT1vLPVpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm: unlocked folio_mapping() dereference without RCU in
  pisa_user_old_folio()
- [Medium] mm: pisa_user_scrub_alloc() uses list_is_first() in reverse
  partial-list scan
- [Medium] mm: pisa_user_scrub_alloc() drops PISA_LIST_SPARSE when
  unparking target
--

commit 3b57a0418e67606042f9e55005bdffc210273bea
Author: Luigi Rizzo <lrizzo@google.com>

block, mm: Support PISA for disk I/O and scrub migration

This commit extends PISA user and page-cache allocators to support direct
and buffered disk I/O by splitting per-node user allocators by DMA
direction, adding page-cache and bio migration hooks, and adding
background scrub migration for sparse PISA pages.

> diff --git a/mm/pisa-user.c b/mm/pisa-user.c
> index 6c3efaee4ecda..5fb1ec7c45204 100644
> --- a/mm/pisa-user.c
> +++ b/mm/pisa-user.c
[ ... ]
> @@ -144,17 +248,31 @@ static void pisa_user_put_folio(struct folio *dst, =
unsigned long private)
>  /* new_folio_t for migration out of PISA memory: allocators never serve =
these. */
>  static struct folio *pisa_user_old_folio(struct folio *src, unsigned lon=
g private)
>  {
> -	return __folio_alloc_node(GFP_HIGHUSER_MOVABLE | __GFP_NOWARN, 0, folio=
_nid(src));
> +	struct address_space *mapping =3D folio_mapping(src);
> +	gfp_t gfp =3D GFP_HIGHUSER_MOVABLE;
> +
> +	/* A file folio goes back to memory that its mapping allows. */
> +	if (!folio_test_anon(src) && mapping)
> +		gfp =3D mapping_gfp_constraint(mapping, gfp);
> +	return __folio_alloc_node(gfp | __GFP_NOWARN, 0, folio_nid(src));
>  }

[Severity: Medium]
Can mapping_gfp_constraint() read a freed struct address_space here?

migrate_folio_unmap() invokes get_new_folio() before locking src, and the
scrub demotion path isolates file-backed folios without pinning their
inode:

CPU0 (scrub work)                 CPU1
pisa_user_scrub_alloc()
  ...
  migrate_folio_unmap()
    pisa_user_old_folio(src)
      mapping =3D folio_mapping(src)
                                  truncate / evict()
                                    filemap_remove_folio(src)
                                    /* RCU grace period frees inode */
      mapping_gfp_constraint(mapping, gfp)
                                  <-- use-after-free

Wrapping the folio_mapping(src) lookup and mapping_gfp_constraint() call
in rcu_read_lock() / rcu_read_unlock(), as pisa_user_want_dir() does,
would keep the inode alive across the read.

[ ... ]

> @@ -293,15 +432,307 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter=
, struct page **pages,
[ ... ]
> +	spin_lock_irqsave(&pa->lock, flags);
> +	for (unsigned int i =3D 0; i < ARRAY_SIZE(lists) && !target; i++) {
> +		list_for_each_entry_reverse(meta, lists[i], list) {
> +			if (pisa_meta_avail(meta) < (bpp >> 1))
> +				break;
> +			/* Compaction needs a sparse page and another partial page to fill. */
> +			if (mode =3D=3D 1 && (!(meta->on_list & PISA_LIST_SPARSE) ||
> +					  (list_is_first(&meta->list, lists[i]) &&
> +					   list_empty(lists[!i]))))
> +				break;
> +			if (time_after(jiffies, meta->alloc_jiffies + max_age)) {
> +				target =3D meta;
> +				break;
> +			}
> +		}
> +	}

[Severity: Medium]
Should this check list_is_singular(lists[i]) instead of
list_is_first(&meta->list, lists[i])?

When the reverse walk skips younger sparse entries near the tail of
lists[i] (or entries whose alloc_jiffies was refreshed after an unmovable
pass) and reaches the oldest entry at the head while lists[!i] is empty,
list_is_first() triggers and aborts the scan even though the skipped tail
entries in lists[i] are available to receive compacted folios.

> +	if (target) {
> +		/*
> +		 * Compaction: park @target on @pa->full, so that the blocks
> +		 * freed from it are neither cached nor handed out again while
> +		 * its folios move to other pages of @pa.
> +		 */
> +		if (mode =3D=3D 1) {
> +			WRITE_ONCE(target->on_list, PISA_LIST_FULL | PISA_LIST_HOLD);
> +			list_move(&target->list, &pa->full);
> +		}
[ ... ]
> +	if (mode =3D=3D 1) {
> +		bool should_release;
> +
> +		/* Put @target back on the list that its free blocks call for. */
> +		spin_lock_irqsave(&pa->lock, flags);
> +		WRITE_ONCE(target->on_list, PISA_LIST_FULL);
> +		should_release =3D pisa_place_meta(target);
> +		spin_unlock_irqrestore(&pa->lock, flags);
> +		if (should_release)
> +			pisa_schedule_reclaim();
> +	}

[Severity: Medium]
Does writing PISA_LIST_FULL to target->on_list drop PISA_LIST_SPARSE when
target remains in the 50%-75% free hysteresis band?

In pisa_place_meta(), pages with nfree between 50% and 75% of bpp retain
their sparse classification via meta->on_list & PISA_LIST_SPARSE.  Because
parking and unparking target overwrites target->on_list with
PISA_LIST_FULL, a sparse page that finishes a compaction pass with fewer
than 75% free blocks (for example, when some folios were busy or budget
capped the batch) loses PISA_LIST_SPARSE and target->drain, and is moved
to the dense head of the partial list where new allocations immediately
refill it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D12

