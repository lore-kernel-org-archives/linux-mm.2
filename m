Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C2FCCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A411F6B02C9; Mon,  1 Jun 2026 04:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2016B02CB; Mon,  1 Jun 2026 04:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9079A6B02CC; Mon,  1 Jun 2026 04:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8D36B02C9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:37:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D7E5C221D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:37:10 +0000 (UTC)
X-FDA: 84830689020.01.D166B78
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 825B01A000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:37:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mJvCT03g;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1cAnVe0vgR161tCTvMa190G3YVoUsIA3Fi5oEWLr4Q=;
	b=rAzu7TiJlWzFSXfQ8x+ceXFPgGOD2DlIDSC1dyf2zMFF5kMVDQpxEaVyZ+l36L+GNrnSYh
	IJpYjgu62QLS6HZR4NmSTMbt4sX86fj4BlJ5R7Lh/p7zYqWlV/Yq5LBGwuVLuszzRPRJzZ
	78+m5utqRSRg/oPPEo9/c1A/3TKdhmc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mJvCT03g;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303028; a=rsa-sha256;
	cv=none;
	b=nEDftlb4FVhblqyq1F6h/OUCVXy1lbX1kroRBeH/7EnZChpXdLNJV8Ilo3ucpYS8u/ORa0
	TlMA8hxaNMXuY97XOAYUCDnveEFDYuLkHPPzW0mJ3xsqtgVQ++gospAlC+G/XtAxL6CArZ
	XpVgIpVVpAx6TWr6SJlmQ1jwJEy7vn0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780303024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1cAnVe0vgR161tCTvMa190G3YVoUsIA3Fi5oEWLr4Q=;
	b=mJvCT03gZw/QyQXXfMaQSG0rfbdxV7lvTw8dOCiC8I2+Vc8xHutXhZ6lgQj40Am+N2vkpu
	d5p0utl7Wis48n4hwB0IfxxY0StkNOEwRg7hExKJh99TXsKpRhh3IcyeYGYWkZq58QedRG
	VlqnyqZSrPMfb0daeTXDM4LvlMqyxeE=
From: Lance Yang <lance.yang@linux.dev>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	yosry.ahmed@linux.dev,
	ziy@nvidia.com,
	liam@infradead.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	ryncsn@gmail.com,
	zaslonko@linux.ibm.com,
	gor@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	npache@redhat.com,
	ryan.roberts@arm.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/9] mm: switch THP shrinker to list_lru
Date: Mon,  1 Jun 2026 16:36:52 +0800
Message-Id: <20260601083652.59539-1-lance.yang@linux.dev>
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xpi8f1xnbxm9ufnmwf5nijwytq7cba7m
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 825B01A000B
X-Rspam-User: 
X-HE-Tag: 1780303026-69350
X-HE-Meta: U2FsdGVkX187yeE7C6uBV/g5eDycSs88EXnmE8oku6hU70bWWouuIeTTFDuMGttqCrtw4iy6PBX5QXrCJnDZAoVD3AHDnysTYvU+QoJRP1Wm6sydyapiXl2pCP2hs5sVLNNY/mVJI/IcV0GUryKJ4ynxosrZlSOzZGQ7YPcoyFdM4q4uGw5g5y0O/cSRltzous3qDr2sYQNGetZemYJc9KVwG/5fl2ytDY2LxNyDtCahODMltoWSds5qKWjSCifcn1yvHd7u9Hb4pf4GYkD5g8Z2b/od/HNZbgfloAQao5oFQdxJEVK2FwEVVaxqNuT2VjIa9Fem8MjPw4/9sZLvrM8xGyy5FESD/0HqwbiDeKIOxJE66gATZFTOnydXMDYDY/PR8tel3IMo6tRh3hAKHtVSHaVUcnws/CeLiLUANqiwDcTI8Qwd45cQM222pqAKU4EaOJ3F8nVwxrrpyuvHXlJtQifDpPArn3Sy7xQFl/EYPzOvAckTpS1dHa1WwJPuVcIODyk+o233LHlh4sqd4EeEmUw32iQ3qT3JoKz6SSjKZp5M5JyjsDNfwbTya0Jt5gpU0C7EVohiH2Oxwfanu5W4f3Hm6+DhHEEk5S7sjJ0JO0JZT2+sHpGLfhUI8QLE3JcD37S6TeSu/zq2xPCUMSyiMDTHT80MJLyCFE2BqKwz6XvpDTdKk7gGekUGbGns/uKad8siAssCG/wUlS6zuRaFp8hoq8hif7+vU9ZttI0lMjxOLcFtd9Zm0dG+ONWTRmyOTt+3wyShhaP9ghiEWKV9dpzYoDz+4JUNyzKfWudkqfypDpXOaKwVI9Li0Am/4DCwUV/EIfiystllKqKhUjzFIPGEvYmsTD6tt+9zmuE2xRFTlNOKi9VKAMmsJku1wchR1ZgA1Squ+F8h7XtoEmu7QKO+xrwUB6UcOXXHBXYuGtjmMpXC8KUTSDm56VS03i1eQWTXhKiD1ZsljBt
 wIBNGE63
 YgtcVWVhyzKeFGRb2GzkxmOu/ma6rChjOuSgcXBHUopCwUAU9LboXIg8NJQLubUsdi/ybF8FWG1K0pflRZPrNOqy+Ah4Hhe4vqKhkX+oMtnxD1XxxwuU3VvAUNss5aXtxbq6PPogPX9CacuiH8RovrVqxg4vf3fs8Z9oAPFt8oONaVBrmUgwT45Hegayit+B0jhUA75oalaedwurFsunyy17w4hbcitPi6q1Ox9VAcz/OhDF1rH11O/izpNoofrJRxYZx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On Wed, May 27, 2026 at 04:45:07PM -0400, Johannes Weiner wrote:
>This is version 5 of switching the THP shrinker to list_lru.
>
>Core of the new version is the list_lru/set_shrinker_bit fix up front,
>which minimally affects later patches; and a rebase onto the latest
>mm-unstable - replaced alloc_swap_folio() with __swap_cache_alloc().
>
>The changes seemed small enough that *I chose to keep the review tags
>from v4*. Please shout if you object to this!
>
>Changes in v5:
>- patch 1 is a new fix for a very old, pre-existing set_shrinker_bit()
>  problem in list_lru, where the bit can be set on a dying child memcg
>  instead of the ancestor that actually received the item. Pointed out
>  by Usama Arif and Sashiko; fix it first to make it minimally
>  backportable and so the conversion is safe.
>- patches 6 and 9 adapt to that fix's new memcg-by-reference
>  lock_list_lru_of_memcg() signature
>- collapse_huge_page(): propagate folio_memcg_alloc_deferred() failure
>  as SCAN_ALLOC_HUGE_PAGE_FAIL instead of leaking SCAN_SUCCEED and
>  falsely reporting a successful MADV_COLLAPSE (Usama Arif, Sashiko)
>- deferred_split_isolate(): fix a UAF by reading folio state before
>  list_lru_isolate(); once removed, a racing folio_put() frees the
>  folio via the lockless list_empty() check while we still touch its
>  flags and stats (Sashiko)
>- rebased to mm-unstable of 2026-05-27, which simplifies the flatten
>  prep patch (now anon-only, as alloc_swap_folio() was folded into the
>  new __swap_cache_alloc()) and moves the swap-side
>  folio_memcg_alloc_deferred() hook into __swap_cache_alloc(). Kairui,
>  I would appreciate an eyeball on that.
>
>Changes in v4:
>- guard folio_memcg_alloc_deferred() with mem_cgroup_disabled() to fix
>  NULL deref in __memcg_list_lru_alloc() when booting with
>  cgroup_disable=memory (e.g., kdump capture kernel) -- reported and
>  tested by Mikhail Zaslonko on s390 and x86
>- flatten if (folio) branches in alloc_swap_folio() and alloc_anon_folio()
>  in a prep patch so the list_lru allocation additions are a clean minimal
>  diff (Lorenzo)
>- folio_memcg_alloc_deferred() moved out of alloc_charge_folio() into the
>  anon-only collapse_huge_page() path; collapse_file() shares that helper
>  but its pages don't go on the THP shrinker queue (David)
>- guard folio_memcg_alloc_deferred() with order > 1; mTHPs below order-2
>  can't be queued on the deferred split list (David)
>- make deferred_split_lru static, hide behind folio_memcg_alloc_deferred()
>  wrapper with GFP_KERNEL (Lorenzo)
>- rename l -> lru throughout huge_memory.c (Lorenzo)
>- kdoc for folio_memcg_list_lru_alloc() (Lorenzo)
>- list_lru_lock_irq()/unlock_irq()/add_irq() irq-disabling variants;
>  use list_lru_add_irq() in deferred_split_scan() (Lorenzo)
>- reorder shrinker_free() before list_lru_destroy() (Lorenzo)
>
>Changes in v3:
>- dedicated lockdep_key for irqsafe deferred_split_lru.lock (syzbot)
>- conditional list_lru ops in __folio_freeze_and_split_unmapped() (syzbot)
>- annotate runs of inscrutable false, NULL, false function arguments (David)
>- rename to folio_memcg_list_lru_alloc() (David)
>
>Changes in v2:
>- explicit rcu_read_lock() in __folio_freeze_and_split_unmapped() (Usama)
>- split out list_lru prep bits (Dave)
>
>The open-coded deferred split queue has issues. It's not NUMA-aware
>(when cgroup is enabled), and it's more complicated in the callsites
>interacting with it. Switching to list_lru fixes the NUMA problem and
>streamlines things. It also simplifies planned shrinker work.
>
>Patch 1 fixes a pre-existing list_lru bug where the shrinker bit is
>set on the caller's memcg rather than the ancestor whose sublist the
>item actually lands on after a walk-up. Standalone, backportable; the
>rest of the series depends on it.
>
>Patches 2-5 are cleanups and small refactors in list_lru code. They're
>basically independent, but make the THP shrinker conversion easier.
>
>Patch 6 extends the list_lru API to allow the caller to control the
>locking scope. The THP shrinker has private state it needs to keep
>synchronized with the LRU state.
>
>Patch 7 extends the list_lru API with a convenience helper to do
>list_lru head allocation (memcg_list_lru_alloc) when coming from a
>folio. Anon THPs are instantiated in several places, and with the
>folio reparenting patches pending, folio_memcg() access is now a more
>delicate dance. This avoids having to replicate that dance everywhere.
>
>Patch 8 flattens the alloc_anon_folio() retry loop so the next patch's
>list_lru hook lands as a clean addition rather than nested deep inside
>an if (folio) block.
>
>Patch 9 finally switches the deferred_split_queue to list_lru.

As the changelog above says, the old queue is per-memcg only, rather
than per-memcg-per-node. So reclaim on one node can still walk the whole
memcg queue and split underused THPs from other nodes in the same memcg.

But I think the new one can lose reclaim in the cgroup.memory=nokmem
case ...

With nokmem, the deferred shrinker can still run from memcg reclaim,
because it is SHRINKER_NONSLAB. But the list_lru is no longer per-memcg:

__list_lru_init() clears memcg_aware,

	if (mem_cgroup_kmem_disabled())
		memcg_aware = false;

so list_lru_from_memcg_idx() falls back to the shared node list:

static inline struct list_lru_one *
list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
{
	if (list_lru_memcg_aware(lru) && idx >= 0) {
[...]
	}
	return &lru->node[nid].lru;
}

That makes the shrinker bit unreliable. __list_lru_add() still sets the
bit on the memcg passed in, but only when the list goes from empty to
non-empty:

bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
		    struct list_head *item, int nid,
		    struct mem_cgroup *memcg)
{
	if (list_empty(item)) {
[...]
		if (!l->nr_items++)
			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
[...]
		return true;
	}
	return false;
}

If memcg A adds the first folio, A gets the bit. If memcg B later adds a
folio to the same shared list, B does not get a bit, because the list
was already non-empty.

So in the A-first/B-later case, reclaim from B may not call the deferred
shrinker at all. The shared list is scanned from memcg reclaim only if
reclaim runs from the memcg that has the bit, such as A here, or from
global reclaim :)

Anyway, only after the shared list is emptied does the next memcg to add
a folio get to be the one with the bit, IIUC :)

Hopefully I didn't miss somthing important ...

Cheers, Lance

