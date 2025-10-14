Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFCECCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5FD8E0140; Tue, 14 Oct 2025 11:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD3E8E010A; Tue, 14 Oct 2025 11:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3BD8E0140; Tue, 14 Oct 2025 11:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E7FED8E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:30:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B41DA1A083E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:30:00 +0000 (UTC)
X-FDA: 83997105360.22.99FDD5D
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 00D3D40011
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:29:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQDeI29R;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760455799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vR+iQzDDtN6M7VRFpvNrFUkeHoDZ4oVbeGYumjrias=;
	b=LEMBoIyQdMpMf5PwyamacV+ueKozDVVQ2WQ6TqSJEwtrFQL2ZBwMEqbNiubKFkG/7iUUpw
	wswmp3U5dJlbTKEm2n+f7BlOtFirYHSo9o3/NA4o+gOxpEXiy1WzYFD2SLkwGMXEAnQiTT
	BnrrEkPmrRuNbWTYsNLQMx5qAEFXeK4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQDeI29R;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760455799; a=rsa-sha256;
	cv=none;
	b=2M68Ln5EBm6jYn2+m0KFsSrKsfiSqoQ1ZCfdJJqpZnhndz4aDfBbN0ch1YIL1UFnRa1yg1
	wEjEENU+0EiGW7kaxM+saeAo1hJFbTNEYmjRH006WgoV1MjAkhDMfQmaUhAsouZ0VBKHUx
	Qefroq6jyNC7fbT2jIysmfhCkzUKSgo=
Date: Tue, 14 Oct 2025 15:29:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760455797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8vR+iQzDDtN6M7VRFpvNrFUkeHoDZ4oVbeGYumjrias=;
	b=nQDeI29RZax/5DJTAfcx+0NEaydLFpQR2DmXX8FMsYZe/VXunSXZL6JgBlqWTWuDhQkFPw
	izZScTJxg54czvoeqdhW0cWTqzo24ABE9WzsM9ChOUfoflmwJJ4BN6RcoK41qRmaU+2Jgf
	K8+JZ3m9O2ymEDrD4WnIknLokpre8n4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Message-ID: <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dm4kjtsy3p58zkgm9e5xqbz1ezz8b4o1
X-Rspamd-Queue-Id: 00D3D40011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760455798-454251
X-HE-Meta: U2FsdGVkX1/N+H6Gmo2BleBfVetMaRsPLftE0b8aQ1iCEHqwjyX4zZP7N14bw0VZrRPJzqeRsT1VOrQtXOf3LP+SVKyom8VfnYqVQNxkWvpRF3IunUYFElzNI6Yr5s/fI828wivbx1FAog6/h7HDGAFjvLuk5YGFQcwR+k80mlunsUVJF5oSOg946MayK1ZpAVFx1GUfkh2XXG+YB4yQ0RzRhWj5TJQg0kRzP7lHt+qRgzbAuPbkdhF9iaOnBY64L2U6J3dcx3TgALyxP9urmEWiLIOfR1av30BN+c8TCIBBHVtfgEho1wM1ncWmEx5fJ7End8R52lK6a/gRVSejzcjvVPXeLUe8yhAiPpPD1lEiN/Jr39da6D+3hV6XOnB/efPqRt4uAm1bJMnwRP0cafscWfaf/hxs4OOOerzA/9sOP7dKLZIPp7zUJS+TXCqYKVn9x0s0sgMOHiwWxjpS3xwwzHKlqOhiDwKmY6P5SDaNv5XIzflG41n6o7jmk7/WaxzJoTOnQiEYcD5A4EVawySvqACZ5+GbY8kPcMoalCeSgxzS9Fxg3Y0pGthcI6fWF1GrcocvUDFfBSyoNyRwgZOjAdnTOoXuprT9QkqVDnCm8TxEyqa0ty2feNRhi/41GzyRD32GtJ2SqTqQgztsnDOpU4zkcdQ0/iwNNm1HMhNwUwfbCARpzcxeVayFPyewtHDuoPXmvLttETxONWsxeQE6X9IWxHP6H0j2nveV3F3hIkFseToJC2Ni0Cwvot1gyIv3zLSXj3G3NszS19MlzAKJCPLKFbpV8CU5ujDHopNXAGU65BSKBtLHdSJIBbgPyohvFZxHRVAAPHjxwGLYgmxQtnCTawiVfoudOslHvCrqyz+jMXTbvC/CuNSRPOIRw1qDz9aKCw16wmOKlmbGCAt5JuKJRfeZ3YlWs8HfHvbHaC28ZLfponvZ8e9DJV62MEsEwWWZDz96zYzn6yF
 H0H/didV
 K1bYY3rOqragx+viT+FONJ8u7F3QNaj7qNCOEgWzWjOyQaS6IsBEAym2FBKHxhBJK4bwcnm03A2uLRBJ1YdtbF0EFbucq8eJjV2Dn+nU5oWSQbk3y12B95Qafjij7F1cnANQi1UMo02rvL/SjjcC6OITgq90QEWkvAYMDpMB0HvR9e0IGknUDSI2y0wM2i9AtMk1DSpvSf2bHHySjOXJyT8KmojiRAz1mVgx/3eT7szLIlpha8seQ41oubBK5xtZVn8Kwf+tkOJV/j2loLBiPY3HPEQ80/xlQI9rphPjnHOqj9UEbsVIIHLWmfY+ehL2JXD9r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..]
> > > @@ -158,6 +161,8 @@ struct zswap_pool {
> > >  	struct work_struct release_work;
> > >  	struct hlist_node node;
> > >  	char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > +	u8 compr_batch_size;
> > > +	u8 store_batch_size;
> > 
> > I don't think we need to store store_batch_size, seems trivial to
> > calculate at store time (perhaps in a helper).
> > 
> > Taking a step back, is there any benefit to limiting store_batch_size to
> > compr_batch_size? Is there a disadvantage to using
> > ZSWAP_MAX_BATCH_SIZE
> > even if it's higher than the HW compression batch size?
> 
> Thanks Yosry, for the code review comments. I had a discussion with
> Barry earlier on these very same topics as follow up to his review comments
> for v11, starting with [1]. Can you please go through the rationale for
> these design choices, and let me know if you have any questions:
> 
> [1]: https://patchwork.kernel.org/comment/26530319/

I am surprised that calculating the value in zswap_store() causes a
regression, but I am fine with keeping the precalculation in this case.

I think there's a bigger problem here tho, more below.

> > > + */
> > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > **entries,
> > > +							   unsigned int
> > nr_entries,
> > > +							   gfp_t gfp)
> > > +{
> > > +	return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries,
> > entries);
> > 
> > We currently use kmem_cache_alloc_node() in zswap_entry_cache_alloc() to
> > allocate the entry on the same node as the compressed page. We use
> > entry_to_nid() to get the node for LRU operations.
> > 
> > This breaks that assumption.
> 
> You bring up a good point. I was looking at the code in slub.c and my
> understanding thus far is that both, bulk allocations and kmem_cache_alloc_node()
> allocations are made from a per-CPU "cpu_slab" that is allocated by SLUB.
> 
> IIUC, the concern you are raising is in the mainline, the entry is allocated on
> the same node as the compressed page, and gets added to the LRU list of that
> node. IOW, the node to which the compressed page belongs is the one to whose
> LRU the entry will be added.
> 
> With this patch, with kmem_cache_alloc_bulk(), the entry will be created on
> the per-CPU slab of the CPU on which zswap_store() is called and will be
> added to the LRU of that per-CPU slab's NUMA node. Hence, the end result
> could potentially be that the zswap_entry for a page could potentially be
> on a different NUMA node/memcg than the page's NUMA node.
> 
> This is my thinking as to how this will impact the zswap shrinker:
> 
> 1) memcg shrinker: if the memcg the entry ends up in is on the zswap_list_lru,
>     the entry will be written back.
> 2) Global shrinker: will cycle through all memcg's that have pages in the
>     zswap_list_lru, and the entry will be written back.
> 
> Based on this, it is not clear to me if there is a problem, and would like to
> request you, Nhat and others to provide insights as well.
> 
> Interestingly, most of the code in slub.c has unlikely(!node_match(slab, node)).
> Does this imply some higher level mm slab allocation requirements?
> 
> I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" if we
> think this would be more correct.

I saw your other response as well, but I think one thing is not clear
here. The zswap entry will get written back "eventually", sure, but
that's not the problem.

If the zswap entry is on the wrong node lru, two things happen:
(a) When the "right" node is under memory pressure, we cannot free this
    entry by writing it back since it's not available in the lru.
(b) When the "wrong" node is under memory pressure, it will potentially
    writeback entries from other nodes AND report them as being freed
    from this node.

Both (a) and (b) cause less effective reclaim from the zswap shrinker.
Additionally (b) causes the shrinker to report the wrong amount of freed
memory from the node. While this may not be significant today, it's very
possible that more heuristics start relying on this number in the
future.

I don't believe we should put zswap entries on the wrong LRU, but I will
defer to Nhat for the final verdict if he has a different opinion.

> > 
> > Does it actually matter if we do the initializations here vs. right
> > before inserting to the LRU (current behavior)?
> 
> Yes, it impacts batching performance with software quite a bit.

Taking a step back, based on discussions in this thread and others, it
seems like the performance of zswap_store() is very sensitive to minor
changes like this one, calculating the store size, etc.

I don't recall this being the case before this patch series. It seems
like an artifact of batching affecting performance negatively and
a collection of micro-optimizations and "correct" placement of code/data
to fix it. This seems to be very fragile.

It is very possible that an incoming change will move the
initializations or make other changes to the code, that will seemingly
cause regressions when they really shouldn't.

Additionally, what may seem optimal on the CPU you are testing on maybe
be suboptimal for other CPUs. I think the big problem here is not where
to initialize the entry or whether to precompute the store batch size,
it's why the code has become extremely sensitive to these changes when
it shouldn't be. zswap_store() is not a fast path by any means, and
people will not expect such changes to cause meaningful regressions.

> 
> > 
> > > +	for (i = 0; i < nr_pages; ++i) {
> > > +		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
> > > +		entries[i]->pool = pool;
> > > +		entries[i]->swpentry = page_swap_entry(folio_page(folio,
> > start + i));
> > > +		entries[i]->objcg = objcg;
> > > +		entries[i]->referenced = true;
> > > +		INIT_LIST_HEAD(&entries[i]->lru);
> > > +	}
> > >
> > > -	old = xa_store(swap_zswap_tree(page_swpentry),
> > > -		       swp_offset(page_swpentry),
> > > -		       entry, GFP_KERNEL);
> > > -	if (xa_is_err(old)) {
> > > -		int err = xa_err(old);
> > > +	for (i = 0; i < nr_pages; ++i) {
> > > +		struct page *page = folio_page(folio, start + i);
> > >
> > > -		WARN_ONCE(err != -ENOMEM, "unexpected xarray error:
> > %d\n", err);
> > > -		zswap_reject_alloc_fail++;
> > > -		goto store_failed;
> > > +		if (!zswap_compress(page, entries[i], pool, folio_wb))
> > > +			goto store_pages_failed;
> > >  	}
> > >
> > > -	/*
> > > -	 * We may have had an existing entry that became stale when
> > > -	 * the folio was redirtied and now the new version is being
> > > -	 * swapped out. Get rid of the old.
> > > -	 */
> > > -	if (old)
> > > -		zswap_entry_free(old);
> > > +	for (i = 0; i < nr_pages; ++i) {
> > > +		struct zswap_entry *old, *entry = entries[i];
> > >
> > > -	/*
> > > -	 * The entry is successfully compressed and stored in the tree, there is
> > > -	 * no further possibility of failure. Grab refs to the pool and objcg,
> > > -	 * charge zswap memory, and increment zswap_stored_pages.
> > > -	 * The opposite actions will be performed by zswap_entry_free()
> > > -	 * when the entry is removed from the tree.
> > > -	 */
> > > -	zswap_pool_get(pool);
> > > -	if (objcg) {
> > > -		obj_cgroup_get(objcg);
> > > -		obj_cgroup_charge_zswap(objcg, entry->length);
> > > -	}
> > > -	atomic_long_inc(&zswap_stored_pages);
> > > -	if (entry->length == PAGE_SIZE)
> > > -		atomic_long_inc(&zswap_stored_incompressible_pages);
> > > +		old = xa_store(swap_zswap_tree(entry->swpentry),
> > > +			       swp_offset(entry->swpentry),
> > > +			       entry, GFP_KERNEL);
> > > +		if (unlikely(xa_is_err(old))) {
> > > +			int err = xa_err(old);
> > >
> > > -	/*
> > > -	 * We finish initializing the entry while it's already in xarray.
> > > -	 * This is safe because:
> > > -	 *
> > > -	 * 1. Concurrent stores and invalidations are excluded by folio lock.
> > > -	 *
> > > -	 * 2. Writeback is excluded by the entry not being on the LRU yet.
> > > -	 *    The publishing order matters to prevent writeback from seeing
> > > -	 *    an incoherent entry.
> > > -	 */
> > > -	entry->pool = pool;
> > > -	entry->swpentry = page_swpentry;
> > > -	entry->objcg = objcg;
> > > -	entry->referenced = true;
> > > -	if (entry->length) {
> > > -		INIT_LIST_HEAD(&entry->lru);
> > > -		zswap_lru_add(&zswap_list_lru, entry);
> > > +			WARN_ONCE(err != -ENOMEM, "unexpected xarray
> > error: %d\n", err);
> > > +			zswap_reject_alloc_fail++;
> > > +			/*
> > > +			 * Entries up to this point have been stored in the
> > > +			 * xarray. zswap_store() will erase them from the
> > xarray
> > > +			 * and call zswap_entry_free(). Local cleanup in
> > > +			 * 'store_pages_failed' only needs to happen for
> > > +			 * entries from [@i to @nr_pages).
> > > +			 */
> > > +			store_fail_idx = i;
> > > +			goto store_pages_failed;
> > > +		}
> > > +
> > > +		/*
> > > +		 * We may have had an existing entry that became stale when
> > > +		 * the folio was redirtied and now the new version is being
> > > +		 * swapped out. Get rid of the old.
> > > +		 */
> > > +		if (unlikely(old))
> > > +			zswap_entry_free(old);
> > > +
> > > +		/*
> > > +		 * The entry is successfully compressed and stored in the tree,
> > there is
> > > +		 * no further possibility of failure. Grab refs to the pool and
> > objcg,
> > > +		 * charge zswap memory, and increment
> > zswap_stored_pages.
> > > +		 * The opposite actions will be performed by
> > zswap_entry_free()
> > > +		 * when the entry is removed from the tree.
> > > +		 */
> > 
> > But there *is* further possibility of failure if a subsequent entry
> > xa_store() fails, right?
> 
> This comment is referring to this specific entry.

I think it's currently misleading in its current form. Perhaps:

The entry is successfully compressed and stored in the tree, and further
failures will be cleaned up in zswap_store().

> 
> > 
> > Seems like if xa_store() fails we do not cleanup previously charged
> > objects, pool references, zswap_stored_pages, etc. Instead of rolling
> > all this back on failure, can we do all the xarray stores first and only
> > do the rest when we're at a point where no failure can happen? Would
> > that cause a performance regression?
> 
> It would make the code more complicated and thus cause a performance
> regression. I have tried to balance code simplicity (which impacts performance)
> with correctness here. The "store_failed_idx" ensures that all partial work done
> in zswap_store_pages() for this batch, is cleaned up.
> 
> The rest is handled in zswap_store() when it sees an error returned by
> zswap_store_pages().

Right, I missed the part about zswap_store() handling this, the comment
above confused me.

