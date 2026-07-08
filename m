Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A0AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8946B0088; Wed,  8 Jul 2026 00:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0FC6B008A; Wed,  8 Jul 2026 00:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6826B008C; Wed,  8 Jul 2026 00:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE4D86B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:13:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B329902BC
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:13:04 +0000 (UTC)
X-FDA: 84964289088.06.B60B6E2
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70C6440007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:13:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UCEZEhKb;
	spf=pass (imf07.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783483982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JgCF/d1GzpHoQKC1qhkhHRFZUTixiHjHsF4UG1qii78=;
	b=TebRz8J2SFAWfoGvfQyMn9NMEb01exVcegEXI5SkNByRtasZnGf65bJBRO+X5biRLo57HQ
	osEPBTB6IWinjyIewl3eX/vE/rYrGYFeJVvC0oMinj4zb2ll7oWODwqHP4jTeTq4URL4bg
	62FlEtKfmjXIFoWFRgDOmuAs/GPJxyc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UCEZEhKb;
	spf=pass (imf07.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783483982;
	b=mbPkQvUMLsdXQ3XtIwRWX44bmwKUFgJ+59DVuG2RCafg389IUNGr0HDeNnJBjI6/XT7U4G
	CeVqBk/gDpiguIjIHQhdarohpKqjySmrv31I3Ak7nSEjVSsUCy+w/U40GgLrBMX9nVS5Wi
	eBRh1m0o5uIcPjfjZbTQ6iGSs8Ow3+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783483980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JgCF/d1GzpHoQKC1qhkhHRFZUTixiHjHsF4UG1qii78=;
	b=UCEZEhKbX1dlK8CTrdLBo+EbszDWU9fQk1ecn+HXPsx6OtoBHPR+eExQ7BoZfUFlrQ65KK
	MMLe9Daz2f5ZX/BppB246vI1n8S9CcG6HjYg7nlKm4VopaL2mOFEN9hyOW4AczVNFUdC+T
	V3fd0oNUO6yYwI4YFXwkYVexyT6CvhM=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: stable@vger.kernel.org,
	linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	jiayuan.chen@linux.dev,
	yingfu.zhou@shopee.com,
	willy@infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y 6.1.y 6.6.y 0/1] mm/vmscan: flush deferred TLB before freeing large folios in reclaim
Date: Wed,  8 Jul 2026 12:12:35 +0800
Message-ID: <20260708041237.289026-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70C6440007
X-Stat-Signature: epcaezedidprx8q916xtkywd1wpkperi
X-HE-Tag: 1783483982-100625
X-HE-Meta: U2FsdGVkX18+SDRFh3Ip7G0MuYga0Wzrr0G/9f4Z8hnoOZdnmGGBahR0fdhleAFY0MF8n6VjBBVjUxwudYqSW/W0lUdE4o13/Di6/8jgmIx+KQUujAKmHrPX5J2ZX+h/24RcgWuM9YAVnjUGwZhXJQCu4pfymfD3hAjXD5ovPZUAasDCaRTfvAKwJ4yV4wiGunW9JwsDN7AP4q9i16tY9IBhqDXVYzqsArkicXGTLnaasa8ntmD024sMMKJpqcVyW8SfXkMQye7cK6/Uh6yMUl6++tgJPX04j7ZvXXB2zQQvAv73MYmgxGPrZJ2STzrPSHBZj8+dqCadaYUTYivAlb37g8HJpruyIDAnCXfqs6QB3OtanymnkejrVSz5v2IZL9LvqAVoMp6stUaEUsqSnu/Q1jlV4WXylM/FE6VWfYBVgFtpsYh1ic9+KQr5Rieew1ZjTLd3M1wpHtlXqmdT95hlB9pXM+kWG2iDDR4NuEfCfirrsJmGgo1WrgFc7fRUmxbpFxfYnIOb1JOfNsOEJH86yek5xLrN60Z4EK5ljwuGy8fB2iL6+dQSX3nglmsxw5t9CBSlOctC6wIzZzLXibYHmT4+y9FLAxJ357mN7wEHpb+tPpB3L1BGyduiHypjIPbwdi5KWYRoFxsEWhMPKjV8sgrdAP6OG2nUrGo+Y5ZphRli0NtrVuHl5UBr7pVkMMO/VQqVjQ3dHGQYc3855TjzZH0OtnWX+YKTtD8t8cXc8NrAyKrX9vy/C7ZZcCI+0Fz4PZShoyzPgBYd6ZxqK9BkdOTwT/pDq/p2IgQPQ6+sRqIJyEDko4wsxKcP2lE+s+CY1UCET+wvycWb8xQrz9x1H45TBgShahKeKl7tx5pnhdoK5yTCNy7LJP7H5pePZ/LB6GCkVqqpft6Lyjwk9uv+EjS3mI0tl+k13iD/1+3TEhe3r+UpQpc/H2WBX0bQYnA+kl1OZvmX3kLhEGh
 ozyoFpHU
 ucXkGiEMszZ4M8BzCUlUaNiFFC3lheZoAAb9rHm/jnoJ9DTy9anYyD1pfWi790vdyRw8cuRfv/4o9yd9BEvrpvJ0jpSzb1988eRd7JhCFx0SnP+Fck3hSCc+ZNoLh208/GMKZkq4h0Y+T7LLOz50jAIgfkUPTK1jY0vNidAN1Dp0dhUWoSE07tIInvonHqHHnvrel
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

We were chasing random user-space segfaults on our production kernels.
They were fully non-deterministic, and the fault address reported for each
SIGSEGV was itself random and had nothing to do with the code that was
actually running -- which smells like a stale TLB entry, not corrupted
data.

We managed to reproduce it with stress-ng: under memory pressure the
workers take random SIGSEGV/SIGILL too, again at random fault addresses.

It turns out we're missing a TLB flush. In reclaim, shrink_folio_list()
tears down the PTEs with a deferred, batched flush. Order-0 folios are
collected and only freed after that batch is flushed by
try_to_unmap_flush(). Large folios, though, are freed right away at the
free_it label via destroy_large_folio(), which runs *before* the flush. So
a large folio's pages can go back to the allocator and get reused while
some other CPU still has a stale TLB entry pointing at them -- and that CPU
then reads or executes through the old translation into a page that now
belongs to someone else. When it's executable text mapped as a large
folio, the CPU literally fetches instructions out of a reused page, which
is where the random crashes come from. (This is about file-backed large
folios, not anonymous THP, so transparent_hugepage=never doesn't help.)

How we reproduce it:
- Make a cgroup and set memory.high.
- Run ~45 stress-ng workers in it (e.g. --cpu N --cpu-method all).
- Alongside, run a tiny program that keeps allocating anonymous memory to
  push the cgroup over memory.high and keep reclaim busy.
Dropping caches first (echo 3 > /proc/sys/vm/drop_caches) makes the text
refault as large folios and reproduces it much faster.

To be 100% sure about the mechanism, we filled every reclaimed large folio
with 0xCC (INT3) and held onto it instead of freeing it. Under the repro,
stress-ng workers immediately hit INT3 at instruction pointers inside their
own text -- i.e. CPUs were fetching instructions through stale TLB entries
from freed, poisoned pages. stress-ng has no INT3 in its binary, so the
only way to execute one is through a stale translation into a freed page.
Several CPUs hit it within the same microsecond, which lines up nicely with
a single batched unmap whose flush was skipped on more than one CPU.

Upstream this got fixed as a side effect of
commit bc2ff4cbc329 ("mm: free folios in a batch in shrink_folio_list()")
which sends large folios down the same flush-before-free batch path.

The patch below is the minimal fix: just flush the deferred batch before
freeing a large folio inline.

Jiayuan Chen (1):
  mm/vmscan: flush deferred TLB before freeing large folios

 mm/vmscan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.43.0


