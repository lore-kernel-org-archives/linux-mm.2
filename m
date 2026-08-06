Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A16C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414396B0099; Thu,  6 Aug 2026 06:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4A76B009D; Thu,  6 Aug 2026 06:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DABC6B009E; Thu,  6 Aug 2026 06:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDDE56B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:30:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C87BB160707
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:24 +0000 (UTC)
X-FDA: 85070475168.19.D96802F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A1B1C0009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SVglRwCR;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786012223;
	b=7BzuqdYoRba1XivOmgX0QNFXcE3tRncAki3VF4IEkgX+Q7oMHtTzP8052u4DWyXkcpzDd9
	VGogXBrKcjceE4SRzI89l4J5h87tbMKpB/JD+Efbc0iVdX7u7PSwMftQVETQ+BZBYxN7bt
	3tKUMuGbtXMzvgcboFEZfg0sk1uXHl8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SVglRwCR;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786012223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jwxjFxmZn7hbQi6ACkUgmUGgkIM7gDcAY2HFFzALdnI=;
	b=8rSv7oJhwmhz+S1iLIDhRQTURlIVl27u8bpe5e1YgEYyN+Sjpp3nE9R9qUEj6bpH9Ypek5
	M11ZdG5yZp5wwBUhMIG/hZdgncmielFUaolv1M0t1++skHM4jIr+AB/uxAf08nEU5N5O3b
	PTtSv4MDbfGTEGVC59bGkVcGIviG8XY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jwxjFxmZn7hbQi6ACkUgmUGgkIM7gDcAY2HFFzALdnI=;
	b=SVglRwCRYdffqbTrjt6VWNF77gXrT21ZWX2VhpcT0FIOhSw68qcOqEU4KSkkpvFHTQlaP6
	vuPVdPbzOE8SNkY9W1NZP/dVaiD6xZwolOisCZasE3AUbdOoISPkwi02XWLuLFc+AnlRhT
	raxinZCr9n93U4NiQLKOG0xt7mr5Zn8=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 0/6] mm/mglru: skip empty PUD subtrees during aging with PUD-level Bloom filter
Date: Thu,  6 Aug 2026 18:29:54 +0800
Message-ID: <20260806103003.3924438-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8A1B1C0009
X-Stat-Signature: ioc8od7z1mifh49w57pfd4df9e6kaqri
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786012221-167615
X-HE-Meta: U2FsdGVkX180sUFLHGcxlwN7yURxrD8VClKcy+emtlZxqL6TO7uPeUoJ5zXFM8Jhw1itOAJrKcG6yxsdqal95dPWVlIKx7hf/7ZGFBLV6HlabCvRYsxHOoa+9o35fF8xArvb2dWQ3+8ueDfDAdT6Lo+suOAfFTgt/W8/uq7s78s/UekfIPUY1x2jXXdkDS8UEfAIWMx+IsylxnR/q6DxjRRzQu69Pr1v01XjagszeRjy/wc7UoQr6D+OkCh5CXfSQ3r47PLwMpWi6pfTuLzcAAsG08TIvJorK0oy4Dw9iNSCG/RjgFlR1AyUqbrAwm6eQPBj6nan4y6YwX81rI8+eMEofQ2HnGldLyNJO7GJa4c9HA8M22j0keXd1NumX0/WI8aXPo58F7IMurPzTiA8iSQhC+EUvBN0dEQVTdGZhCP2uJCNBEO1EeWaxx99RLsFBLecNOvs5BhgCR8CTeZyXXdTLbrZd1ApW8Wj19dvUwG/pfqjx5WZFv+1VyvK7axS5vu69KqXdFF++ygNjkNRv76SgsZTSjJpQUtb9Mr0rR7/SEtQIC07fzWIFhBNt0PNIedip/HJbDe9EGNMamP7AJBCrOJiKd+Iewr2LUUTKxhBW8oPx76duBe1rQ92lbGnlcLqisRSkZI0Kr0vqWU88lpowOn7Ityi7ddvYPpKc7eLmCxIPd01CvX4rleMK7p0QRUTnXXtWkqib20n1+xo1NoJHES04H1h6lGymp4iB5xno3rObA6euarpsihXfpuAuZtM1RFQWefVg2+5pLZ/ALc/xGvrrC8P8xrlqgy6FbxyebHe8P4OjZHSN95DSjaYloup1oc5dXenO7+ipJaBG3mgUKVh8B3gTuIQlByEnkkQARb3hG8MCASp/q9gp4P2NxxF1KHNxxygVGJWPWOAcwv88kVKk2N477B2aFQlsBaEqOVZqWcTdyeEcIfM3l8zC0HQ4k0h/nLUv8TzLq1
 OlK9sB5b
 X9KwlQYmZRk1OCVI4VBnNJh96HzaxaVxglTQJh2m1gUoBX3o6Ol9FJiOLejlNh+q3l70um8PYuiZdYzgJyx4PvHRonONXKdYJus/L5jr2RYj3HFDRmJ6HuofiBnV1AOq62mnBp/f5ehjuPV6DqfBSi8cbrmcahm8mDLwlu+8sjecH3mnsVZIIujwvc/Rsv3esV4nF1CLxNK1yVFx/vWZh84ae58Q3tKIibFtvbdHbEzWdEDy5BB5+1Tn3MvHXWnK1X6iyl2yTyHHdvtogT92xMYiOOkBaQFAB6EXXbah1YuUn/A8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======

MGLRU's aging walks every present PUD of every mm in the mm_list.  When
an mm has no pages on a given NUMA node, all 512 PMDs in each PUD fail
the existing PMD-level Bloom filter test, yet the walker still descends
every PUD and iterates every PMD — pure waste.

These cross-node empty walks are structural: lru_gen_use_mm() sets
mm->lru_gen.bitmap to -1 (all nodes) at each context switch, so every
node's kswapd independently walks the same mm.  On a 2-node KVM guest,
~80% of all aging walks are empty; the worst-case leaf-traversal waste
with a fully resident remote mm is ~73%.

Approach
========

Add a PUD-level Bloom filter (one level above the existing PMD filter).
The walker now:

  1. Checks the PUD filter before descending into a PUD subtree.
  2. If the filter says the PUD had no young entries last generation,
     skips the entire 1GB region — avoiding 512 PMD lookups.
  3. walk_pmd_range() reports upward whether it found any young leaf
     entries; walk_pud_range() records that in the double-buffered
     PUD filter.
  4. The rmap feedback path (lru_gen_look_around()) marks hot PUDs in
     the filter, so newly hot or migrated-in regions are re-examined
     promptly rather than suppressed indefinitely.
  5. force_scan walks bypass the PUD test, so manual aging and newly
     added mm's always populate the filter.

The double-buffered filter flips each aging generation, and the eviction
feedback keeps hot regions marked, so correctness holds naturally without
tracking per-page residency or requiring changes to page fault / rmap
hot paths.

The testing results are from a 2-node KVM guest.  Real-hardware results on
a  ≥4-socket system, would be valuable. I will update the statistics
here if have.

Baoquan He (6):
  mm/mglru: add PUD-level Bloom filter state
  mm/mglru: refactor Bloom filter helpers for two filter levels
  mm/mglru: skip empty PUD subtrees during aging
  mm/mglru: report hot PUDs from the rmap feedback path
  mm/mglru: add MM_WALK_EMPTY stats and tracepoint for cross-node
    measurement
  mm/mglru: count PUD subtrees skipped by the PUD-level filter

 include/linux/mmzone.h        |  15 +++-
 include/trace/events/vmscan.h |  30 ++++++++
 mm/vmscan.c                   | 126 +++++++++++++++++++++++++++++-----
 3 files changed, 153 insertions(+), 18 deletions(-)

--
2.54.0

