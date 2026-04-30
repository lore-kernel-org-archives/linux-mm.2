Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B227CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776806B0093; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E116B008A; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52CF36B0096; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3433C6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA3521C00AF
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:56 +0000 (UTC)
X-FDA: 84716345952.11.6B0309E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id 56A371A0006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=R3PSJKNl;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9ltfmiZTp0GPGYZbxlh1Or8A5M4ofkZ6SxQMQ/0K9k=;
	b=Asrm1iGUBrejpJGzTqKJ7BrEaP1suL13e6E34Bgu+S4nXCf8QUETC2L2V+z/43WhngUvwb
	pT+rB1XXFh9ue02itaN3n0X45dBylTaI1rUBAr1HDjdgKUbLB0zh/PKdUmVbyn1X14oYMW
	qBlSrEchhK6eMg2uXitomAfxf+ka/GM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=R3PSJKNl;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580575; a=rsa-sha256;
	cv=none;
	b=DANNNozD0vmHPcqSiQcb0S60GKfg0EIs0Fgpal3Xv7NJVp3/Y5TueMJd46iWtRMrU2ezwc
	4jZNGgZ8jVSPuq9mk5tRXN6xKQQsFVxWqZoCWwnUr3Wi+4FTMLoALrfFJcOQisLSfDxPvT
	k3pcGkNAJQ/h2rJ+K+3jGZk0o2LH6dE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z9ltfmiZTp0GPGYZbxlh1Or8A5M4ofkZ6SxQMQ/0K9k=; b=R3PSJKNli7HkMPRnoYcGlt+gMm
	jx1Yn2STfnT3xsRkmvPkgMlEm3JH1YMhtwGURaQaxbuFlFS9MhVPx8Tn3xhegDXOXxCEVnNZraZck
	8yZs6d4f3Dfre6qfegXDOHoYS0ZXBN+dsG3TH3EuZjTp60Lq6dTKhMD0uGn9AfBqhLh9ctOGnKpg+
	k/Ay2ssz8MBmAH8YWnEgjvOmxezjTFEXbWkGAb2w/1VwGrHATNTov+C5f0wunZ+EvQZrkRMGYe1Vi
	5CW1017HfJiBrNwxe7aeWIKd0AY9NN1hkWHE2P9/gm+4Ms+dkdOvDK074Bt1rx1Vjm5t1G+X84aof
	MQWSbCaw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-05G3;
	Thu, 30 Apr 2026 16:22:41 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@fb.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 25/45] mm: page_alloc: skip pageblock compatibility threshold in tainted SPBs
Date: Thu, 30 Apr 2026 16:20:54 -0400
Message-ID: <20260430202233.111010-26-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 56A371A0006
X-Rspam-User: 
X-Stat-Signature: 1emc4ozkc4kxmyn9hrm1rnu8gndpjira
X-HE-Tag: 1777580575-421787
X-HE-Meta: U2FsdGVkX19T4k6V1ICRD7oOpo0xHRYLYurgnbIr8G/sVyJs4/Pw4Td6L8U6BLmah7O6hFtPQaRqUcBWdQ52vi3qgkLgndSeFoZa7WqZd+1Kbh4S/kWRkwTzF/F3TUqTscNyNxu6xZN2q9IX2EI/qyrg/H7/HBQhEzAFqD0kDIxqKsiuUCba/Atlf5M80V/ExbkmzRbDO8UenfxKHWEmvMGnTUTbh0xHaE+TFrH6GmhYDPWQnJk/C7mH+Yt8fcKb0iZwwjnH+qy/V+6rC+GZIAvv9jGIFOTB7SdslHbbKNkOn5L6aEYQu+GiJVg+vwjfXK5BqWcSv+lE77nNKYBCkSmsXYD3Xg0ECNM/CS0TBL+MtGmwPnqB3KSnT0fSLJtreoiAVXgO9vuvtcwkYruoLj3dY9VdUMu5ZlfoClVEoqpx0XBU17twGAllsVW16TuB9THd7V+rbuZACjFCnVBsVMC4BiuYW2hev9xl4CKMRMxwVXkjke9Yb1/FkpzIZFXwGEBe/ml1qzUGlqF2lXOPM5GEFPXT5357ZPsSLwl8/JjG7qYlIlkB9qADVxDc8C9T5ocUhBzsxF75jVO2RgTfR6eU2RxJJBfYC0NxIVBiT38LjpKkK0uy4tRhbD7ZY6qhKjMvEStNr6zSdgro7bXHUYSeYVrD5EMhVxr5TOqrnvzIjHQpHY/edyKdOOnGQCnqUMRakJiB1smD+bW4LwPx1MlFaQ+vXIbjv46qs66zUp/duI6EefXuGSadXDE1cD4qEA4ZWK/lmVoSSfe//FFrZyfOK+wUa/SvIVKr6JtCLmYMXsRncmNLNJ2AqXnCHhAzuhzXIkiLbeI+ogtCyuB3U/Zhn6GASo03ZzZDSeOLY+CmSO3KFZqM/EII4Ja5//ANinZ4aXBjaQnQvzha1r3svxX7FNwK9wQ80xsMMC9flnibN+Zjpaz9oxo7o1HkwUoxvkfhDsZvXgOcHA5BYqX
 aSbTKzaI
 JCi41wN/uSsviO0Ggu+ZmerY2OX11rdNl7xw0z7OTZXXcIkuzXBZTmUl0bCzIYxkfOXhBYkYNJwRNWKUGucd3YNMzRIIY4B99b/0cjPBOm8V7aJ+jLz7N/bnjX4xoRnTZEMbrxSe9ZCRcuLSKPGkRGHwf4AetdG5Z+2YRbHqP63xlRX2SlfeFIFNbn4FBJUVumZnjZ1LnpEla+D2T7x/3lLpM4lCCj7KswmQrON551WaQVMg08e+F0JXu2n7pOsQ2cx2LOtrcoQU1Acuba4VsZHIr+F9bp6DcUiq4oPsvYQvWp94K8JFhi4HtvFV3jpDVwRXmnxCgWSotJSsk1yJqgCn2sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@fb.com>

Summary:
__rmqueue_smallest Pass 2b is the last resort before tainting a fresh
clean superpageblock: it walks MOVABLE sub-pageblock free chunks inside
already-tainted SPBs, calling try_to_claim_block() to relabel a movable
pageblock as the requested non-movable type. If Pass 2b fails, the
allocator falls through to Pass 3 and taints a clean SPB.

try_to_claim_block() guards the relabel with a 50% compatibility check:
free_pages + alike_pages must be at least pageblock_nr_pages/2. The
guard exists to protect a generic clean MOVABLE pageblock from being
relabeled when most of its pages are still in-use movable allocations.

Inside a tainted SPB the guard is harmful, not protective. The SPB has
already accepted fragmentation, and stranding a few in-use movable
pages inside a relabeled pageblock is dramatically cheaper than
tainting an entire clean SPB. bpftrace on a devvm under realistic load
caught the pathology directly: at the moment a clean SPB was tainted,
all 8 existing tainted SPBs had nr_free=0 (no whole free pageblocks),
collectively held ~21k movable free pages distributed across MOVABLE
pageblocks, and try_to_claim_block() had failed 29182 of 29228 calls
(99.84%) over the prior few minutes. Pass 2b was effectively unable
to absorb non-movable demand into the tainted pool.

Add a from_tainted_spb parameter to try_to_claim_block() and skip the
50% threshold when set. Pass 2b passes true (it walks SB_TAINTED lists
exclusively); __rmqueue_claim() passes false to preserve its existing
fragmentation-protection semantics.

Test Plan:
Devvm bpftrace setup at ~/spb-monitors/spb-taint-walk.bt watches
clean->tainted transitions in zone Normal and tracks
try_to_claim_block call/ok/fail counters. Before the change the fail
rate was 99.84% with periodic clean SPB taints under load. After the
change, expect the fail rate to drop sharply and the count of tainted
SPBs to plateau at the boot-recruited set.

Reviewers:

Subscribers:

Tasks:

Tags:

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 493db531b869..67cc8165ab1f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2776,7 +2776,8 @@ static struct page *claim_whole_block(struct zone *zone, struct page *page,
 		  int current_order, int order, int new_type, int old_type);
 static struct page *try_to_claim_block(struct zone *zone, struct page *page,
 		  int current_order, int order, int start_type,
-		  int block_type, unsigned int alloc_flags);
+		  int block_type, unsigned int alloc_flags,
+		  bool from_tainted_spb);
 
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
@@ -2941,7 +2942,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page = try_to_claim_block(zone, page,
 						current_order, order,
 						migratetype, MIGRATE_MOVABLE,
-						0);
+						0, true);
 					if (!page)
 						continue;
 					trace_mm_page_alloc_zone_locked(
@@ -3420,11 +3421,17 @@ claim_whole_block(struct zone *zone, struct page *page,
  * not, we check the pageblock for constituent pages; if at least half of the
  * pages are free or compatible, we can still claim the whole block, so pages
  * freed in the future will be put on the correct free list.
+ *
+ * @from_tainted_spb: caller has already verified the block lives in a tainted
+ * superpageblock, where SPB-level fragmentation has already been accepted.
+ * Skip the per-pageblock compatibility threshold so we can absorb non-movable
+ * demand into the existing tainted SPB instead of tainting a fresh clean one.
  */
 static struct page *
 try_to_claim_block(struct zone *zone, struct page *page,
 		   int current_order, int order, int start_type,
-		   int block_type, unsigned int alloc_flags)
+		   int block_type, unsigned int alloc_flags,
+		   bool from_tainted_spb)
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
@@ -3480,8 +3487,14 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/*
 	 * If a sufficient number of pages in the block are either free or of
 	 * compatible migratability as our allocation, claim the whole block.
-	 */
-	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
+	 * The compatibility threshold protects clean MOVABLE pageblocks from
+	 * being relabeled when most of their pages are still in-use movable
+	 * allocations. Inside a tainted SPB the protection is unnecessary:
+	 * fragmentation has already been accepted at the SPB level, and
+	 * relabeling is much cheaper than tainting a fresh clean SPB.
+	 */
+	if (from_tainted_spb ||
+	    free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
 		__move_freepages_block(zone, start_pfn, block_type, start_type);
 		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
@@ -3721,7 +3734,8 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 
 			page = try_to_claim_block(zone, page, current_order,
 						  order, start_migratetype,
-						  fallback_mt, alloc_flags);
+						  fallback_mt, alloc_flags,
+						  false);
 			if (page) {
 				trace_mm_page_alloc_extfrag(page, order,
 					current_order, start_migratetype,
-- 
2.52.0


