Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88303C61CE3
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E656B008C; Mon, 24 Aug 2026 09:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E826B0092; Mon, 24 Aug 2026 09:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD876B0095; Mon, 24 Aug 2026 09:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB306B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:12:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEABF1C00D8
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:12:37 +0000 (UTC)
X-FDA: 85136202354.17.5CC9B1D
Received: from mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32DE6C000F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:12:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BOoEAsLQ;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787577156;
	b=0JjnBhxx7XKSnuj7uUVvYNwGU55axHfUkJtLonTgn2La6+6L3dbtuI2Q3Fx9PF3xVZyoi/
	Q2jzU3J4wPh0B5oCkFrtLGfOFZyKE09vhqmRP5cEbVC1DukB7s2R1te53rlqv4VAn3upxH
	RReLVc4bN5cxECb6joEFRNcCKVOfo/A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BOoEAsLQ;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787577156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jy74hI6olsf+ojDiYLkj6HZW1r3SpS9Og/xmFBtznlc=;
	b=dOwo+zGDrmSARKBcwu7z6WVWj+OP8KpUMxZ3qw6azqcYJlm33SiJbGmzIupzpYaaVtzZs8
	gAxqGYFp6H8zKMsrMEwNddJoASnX+vJbhO9+Mo+5GliX18GuR0OibptOSWqZvUWRbfuRv7
	9duxfStNfVcDUYuPUZ5jINshaiEy9Zo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/b5A6pKJXdJDFq/apoa26JYD1JiLS7wRusBfDVE9t8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787577152; v=1; x=1788181952;
 b=BOoEAsLQzmYT5bu8nMEdHCRy4VSguhfQDyPBJVE08HYsAbcPlwtozpevsCGaw0BmAWqGImn7
 AU0stAAd9jWj1TN8fShNItWqm8sIy0sP8mZ5iVm7oU3ymin3EQBGctmsWLcDkGNhQmhJT5R2prP
 xdKZGsGtcsafYgphfDWmYcsU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id c9d12fd6d0b2f922;
	Mon, 24 Aug 2026 13:12:32 +0000
X-Mizu-Trace-ID: c9d12fd6d0b2f922
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kirill@shutemov.name
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 16/57] mm/collapse: freeze the sources behind migration entries
Date: Mon, 24 Aug 2026 21:12:24 +0800
Message-Id: <20260824131224.73344-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260816224609.308019-17-kirill@shutemov.name>
References: <20260816224609.308019-17-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32DE6C000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5uyxq81pfwo79nzyijtkcg5ic6wmst4b
X-HE-Tag: 1787577153-843135
X-HE-Meta: U2FsdGVkX18NEj9hM4+j3OD9kLpLs0BOt0DNkRr52u3Xl85celCKVqOjuvDyljfCWk0XqaT9T38MW7+6/VM7e6mG34/U5opSNJTzhkibcyPube0nGM8rYIGBSoeddcsOQPiBT9XrUGh38gFApGFzWKDLNe1cTpdiQ+0w3u8a0GMpOJxxnSD9/PrHBPr2QMGCjntxX1LVrMW4okk6Sqgodh390OZrVZgqaUimgcND5++zg9SC6ZRciuGYHs/fJxtY2+BCJp5FtLwpS6lViBvyEc9pfiMpCcNkABDkp+JJ4Coz40qFwMT89QCOi8qdREmRiUniSmMd+S+R0n1OD0eO1h+bednnoop2ch/0zauTi9hoS6yh0fvwKAVIxqJaVt7wtoJoOyHVjbvpzjhhZ/QAJ5l01d/Ew7I4veTxJL1XC7lKDPt5PXQdkFHTcV88EFnlEm5KMr3MUY6oW0HcNxWzeObBpcgVYVxw88ql6qj34KphlFui4+gJBx1i2u8amULLQnE5vC4mMeEb55fqqKxDJD+DOQiFP/ZGTlpRQ9SmCLmO/G640kcDpmILBMa52x0nyh0+SXP6lTy2FwNCsbKOP+qBdbgq6K70wFwPugJ7kuOjOq7TtfOSnTkSfFBAy+l9kIUy9QHNaDTVUxE/w4YDiY1ZbTPOzeEdW4S/wp9JK6RRY2nv4LfQ33EtDPx3Vg5e2ULi0CCIyhDvOh7mdjyi0BSkaqzdOxfADcioUKb7rOnWaqqYhbbuPg8y3IFkG2v3MKOpIgpotHsTYlyNeq1JdZ+tBn/YkSechDwH3yT9YhJtCPQw0rUf+JdZuSPUPQ2tN+gpjF+okiAcJdXxRuPcC266aNMGWYmbFdTrE9cAYlZEXcrbQw81RLIzYirzEHYTtWrVIUtEvnBTvGiPXg7pv1uYzd4yiBC36h70n4yyNuPtODm5WTV4YdfkS82gflA3n2Tq7SBHdDeHRU+6BSb
 iXBYqTgk
 OmJf018OiuDnY4ITViCMwOw96Ut6JkaAYwVDdNZmzutIz6DF9pxXyY4dVmF6S7XvehKd126yGhOcdIICioVZUR0zhYWORcXnrUPl6fLWYugkd0Z2g7QkI3zwEKtuwFtxwNX4KQOPCzpqiyEFFQBYBRARMFBml4Q6C2vi0kOhLZjo7txDby7Gc8tKyHR//FI579gndRhq8n2sBpbIDyf27s2WszqUAoZGI4s7OcDA7f5/59cE5+ABNE8eHqDKTvsMmWrp/CWcleJEiVDiN02q4Hpubkd5fi/j/WCIWqnyX4UNVQj81pnPRvvGkfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Aug 16, 2026 at 11:45:28PM +0100, Kiryl Shutsemau wrote:
>From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
[...]
>+static enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
>+		struct collapse_candidate *cand, pte_t *pte)
>+{
>+	const unsigned int nr_pages = candidate_nr_pages(cand);
>+	unsigned int nr_saved = 0, nr_frozen = 0;
>+	enum scan_result result;
>+	struct folio *folio;
>+	unsigned long addr;
>+	unsigned int i;
>+
>+	for (i = 0, addr = cand->addr; i < nr_pages;) {
>+		pte_t ptent = ptep_get(pte + i);
>+		unsigned int nr, nr_max, k;
>+		pte_t rep;
>+
>+		if (pte_none(ptent)) {
>+			/* Hole: nothing to freeze; install verifies it stayed one */
>+			cand->saved_ptes[i] = ptent;
>+			nr_saved = ++i;
>+			addr += PAGE_SIZE;
>+			continue;
>+		}
>+		if (is_zero_pfn(pte_pfn(ptent))) {
>+			/*
>+			 * Clear the zeropage mapping now, covered by the round's
>+			 * ranged flush: overwriting a live PTE at install would
>+			 * be a valid->valid transition, breaking arm64's
>+			 * break-before-make.  The zeropage has neither rmap nor
>+			 * per-map references -- the saved value alone undoes it.
>+			 */
>+			cand->saved_ptes[i] =
>+				ptep_get_and_clear(mm, addr, pte + i);
>+			nr_saved = ++i;
>+			addr += PAGE_SIZE;
>+			continue;
>+		}
>+
>+		folio = pte_folio(ptent);
>+
>+		/*
>+		 * A folio revisited by a second span of this round is already
>+		 * ours and frozen at its first span: folio_get() on a zero count
>+		 * is a bug, and try-get fails cleanly.  Scrambled layouts
>+		 * (mremap) construct this; nothing else can hold a folio frozen
>+		 * while its PTE is live under our ptl, so it is not transient.
>+		 */
>+		if (!folio_try_get(folio)) {
>+			result = SCAN_PAGE_COUNT;
>+			goto unfreeze;
>+		}
>+		if (!folio_trylock(folio)) {
>+			folio_put(folio);
>+			result = SCAN_PAGE_LOCK;
>+			goto unfreeze;
>+		}
>+
>+		/*
>+		 * Never freeze a folio under writeback.  PG_writeback holds no
>+		 * reference of its own -- the swapcache reference keeps the folio
>+		 * alive, and everything that would drop it waits for the flag --
>+		 * so folio_end_writeback() plain folio_get()s a folio it may
>+		 * assume is alive: a BUG on a frozen one, or with
>+		 * CONFIG_DEBUG_VM off, a free under our copy.
>+		 *
>+		 * Unlike every other hazard here, the freeze does not catch it.
>+		 * folio_expected_ref_count() counts the swapcache reference, so
>+		 * the count is exactly right and the freeze succeeds.  Nor can
>+		 * "is it in the swapcache" stand in for this test: that would
>+		 * refuse the pages the fault-in pass just swapped in.
>+		 *
>+		 * Reachable even though writeback starts on an unmapped folio: a
>+		 * re-fault from the swapcache maps it back before the bio
>+		 * completes, and folio_free_swap() will not drop the cache entry
>+		 * under writeback.  Testing once is enough -- writeback starts
>+		 * only under the folio lock, which we hold from here through
>+		 * putback.
>+		 */
>+		if (folio_test_writeback(folio)) {
>+			folio_unlock(folio);
>+			folio_put(folio);
>+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>+			goto unfreeze;
>+		}
>+
>+		/* Each slot's own value: a span agrees on the PFN, not the rest */
>+		cand->saved_ptes[i] = ptent;
>+		nr_max = collapse_span_max(ptent, nr_pages - i);
>+		for (nr = 1; nr < nr_max; nr++) {
>+			pte_t tail = ptep_get(pte + i + nr);
>+
>+			if (!pte_present(tail) ||
>+			    pte_pfn(tail) != pte_pfn(ptent) + nr)
>+				break;
>+			cand->saved_ptes[i + nr] = tail;
>+		}
>+
>+		/*
>+		 * The clear is the GUP-fast linearization point: a grab landing
>+		 * before it elevates the refcount and the freeze below fails
>+		 * (the candidate unfreezes); one landing after fails its PTE
>+		 * re-read and retries.  Clear and store sit adjacent under one
>+		 * uninterrupted ptl hold, batched per span
>+		 * (get_and_clear_full_ptes() unfolds contpte), so the transient
>+		 * none window is invisible to installers, which all take the ptl.
>+		 */
>+		rep = get_and_clear_full_ptes(mm, addr, pte + i, nr, 0);
>+
>+		/*
>+		 * Dirty from the clear -- including any the hardware set since
>+		 * the reads above -- goes to the folio, the way unmap does,
>+		 * rather than onto PTEs that never had it.  Young needs no such
>+		 * care: a migration entry drops it either way.
>+		 */
>+		if (pte_dirty(rep))
>+			folio_mark_dirty(folio);
>+
>+		for (k = 0; k < nr; k++) {
>+			pte_t saved = cand->saved_ptes[i + k];
>+			swp_entry_t entry;
>+			pte_t swp_pte;
>+
>+			entry = make_readable_migration_entry(pte_pfn(saved));
>+			swp_pte = swp_entry_to_pte(entry);
>+			if (pte_soft_dirty(saved))
>+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>+			set_pte_at(mm, addr + k * PAGE_SIZE, pte + i + k,
>+				   swp_pte);
>+		}
>+		nr_saved = i + nr;
>+
>+		if (!folio_ref_freeze(folio,
>+				      folio_expected_ref_count(folio) + 1)) {
>+			result = SCAN_PAGE_COUNT;
>+			goto unfreeze;
>+		}
>+		nr_frozen = nr_saved;

Just one thing I was wondering about ... can deferred_split_isolate()
remove a source folio from deferred_split_lru while its refcount is
frozen by collapse_freeze_candidate()?

Assume an earlier span belongs to an anonymous large folio on the
deferred split queue, then a later span fails folio_trylock().
collapse_freeze_candidate() continues after freezing each source folio
and calls collapse_unfreeze_candidate() on a later failure:

static noinline enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
		struct collapse_candidate *cand, pte_t *pte)
{
...
	for (i = 0, addr = cand->addr; i < nr_pages;) {
...
		if (!folio_trylock(folio)) {
			folio_put(folio);
			result = SCAN_PAGE_LOCK;
			goto unfreeze;
		}
...
		nr_saved = i + nr;

		if (!folio_ref_freeze(folio,
				      folio_expected_ref_count(folio) + 1)) {
			result = SCAN_PAGE_COUNT;
			goto unfreeze;
		}
		nr_frozen = nr_saved;

		i += nr;
		addr += nr * PAGE_SIZE;
	}

...
unfreeze:
	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
	return result;
}

folio_ref_freeze() takes the source folio's refcount to zero:

static inline int folio_ref_freeze(struct folio *folio, int count)
{
	return page_ref_freeze(&folio->page, count);
}

static inline int page_ref_freeze(struct page *page, int count)
{
	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);

...
	return ret;
}

While collapse_freeze_candidate() still holds the source folio lock,
deferred_split_scan() can call deferred_split_isolate():

static unsigned long deferred_split_scan(struct shrinker *shrink,
		struct shrink_control *sc)
{
	LIST_HEAD(dispose);
	struct folio *folio, *next;
	int split = 0;
	unsigned long isolated;

	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
					    deferred_split_isolate, &dispose);
}

static enum lru_status deferred_split_isolate(struct list_head *item,
					      struct list_lru_one *lru,
					      void *cb_arg)
{
	struct folio *folio = container_of(item, struct folio, _deferred_list);
	struct list_head *freeable = cb_arg;

	if (folio_try_get(folio)) {
		list_lru_isolate_move(lru, item, freeable);
		return LRU_REMOVED;
	}

	/*
	 * We lost race with folio_put(). Read folio state before the
	 * isolate: folio_unqueue_deferred_split() checks list_empty()
	 * locklessly, so once removed the folio can be freed any time.
	 */
	if (folio_test_partially_mapped(folio)) {
		folio_clear_partially_mapped(folio);
		mod_mthp_stat(folio_order(folio),
			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
	}
	list_lru_isolate(lru, item);
	return LRU_REMOVED;
}

And folio_try_get() fails because the source folio has a frozen refcount.
deferred_split_isolate() treats the failure as a race with folio_put(),
clears PG_partially_mapped and its MTHP_STAT_NR_ANON_PARTIALLY_MAPPED
accounting when set, then removes the folio from deferred_split_lru ...

>+
>+		i += nr;
>+		addr += nr * PAGE_SIZE;
>+	}
>+
>+	cand->state = CAND_FROZEN;
>+	return SCAN_SUCCEED;
>+
>+unfreeze:
>+	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
>+	return result;

And collapse_unfreeze_candidate() restores the source PTEs and refcount,
then unlocks and puts the source folio :)

The source folio is not added back to the deferred split queue, so an
underused or partially mapped folio can remain off the queue.

Should collapse unqueue the source folio after folio_ref_freeze()
succeeds, remember whether it was on the deferred split queue and whether
PG_partially_mapped was set, then requeue it if
collapse_unfreeze_candidate() restores the source folio?

[...]

Cheers, Lance

