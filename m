Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD548CDC167
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF506B00AB; Tue,  6 Jan 2026 06:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD026B00AD; Tue,  6 Jan 2026 06:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2A46B00AE; Tue,  6 Jan 2026 06:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 191726B00AB
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:53:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6F17C1D3E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:53:02 +0000 (UTC)
X-FDA: 84301377804.24.B4687B2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id C97DC80007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:53:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nMhFzuqT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="XWt8Tip/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nMhFzuqT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="XWt8Tip/";
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PD2nK4yyRFKk9zNZMhwG4gs4iSjrSsb1YK98rOdGu6s=;
	b=Vb7oEsdYcbvzBpVXJ9bkxzj+8sLM4v4nkXytkeh1kJyebsayXozf6emYbA8rt2HJA5xsv/
	/fEdWRsJl0mEKbkjWTICoJ5mVTLCqRpdsDePXQByuiw12A3lSG/4rfsS15ViZ2IDaUMcgd
	qzwSVNFYnrF0R8Lt+OYENa2wvRv9bgE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nMhFzuqT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="XWt8Tip/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nMhFzuqT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="XWt8Tip/";
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700381; a=rsa-sha256;
	cv=none;
	b=zw7NAkRE7+lr1wOe5DtE8yEDT6Xg1JANjcI38N0ZEeS69pKR+0gknrwtrfwx0+8ahQWpN7
	xtH2PcC6Gjl5OeiE4QvN7UTL334oA/bD3HVBE3hIMXF7ESmrSwZnSvLoVFdJ393WvyBRAC
	FEJlO83ubZD54HASAKsQSWkJEsK71aU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 28A30339E7;
	Tue,  6 Jan 2026 11:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD2nK4yyRFKk9zNZMhwG4gs4iSjrSsb1YK98rOdGu6s=;
	b=nMhFzuqTslp4J5jcA3ZLOG+GGmUsgs1jGA+zYK4+TSAOwF5ntks1N+hGU3BvxNcW+LZ25r
	tlOoCsFhH1vNyPvTi5ilKK5jX/o87VcQo78ePh351hXFijZEz9VP2jhHyTihak5YFG6mKN
	l+IiRcfhSFQR08CHvM2Yx0BI3nCsOzg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD2nK4yyRFKk9zNZMhwG4gs4iSjrSsb1YK98rOdGu6s=;
	b=XWt8Tip/hbFvcJoIxcUhHXpTEhFWX0UAEKxoZtbQ/AWhT/GPwamjGvfWxHByhnboLG3V2e
	Ipa9UTESEBs7OqCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD2nK4yyRFKk9zNZMhwG4gs4iSjrSsb1YK98rOdGu6s=;
	b=nMhFzuqTslp4J5jcA3ZLOG+GGmUsgs1jGA+zYK4+TSAOwF5ntks1N+hGU3BvxNcW+LZ25r
	tlOoCsFhH1vNyPvTi5ilKK5jX/o87VcQo78ePh351hXFijZEz9VP2jhHyTihak5YFG6mKN
	l+IiRcfhSFQR08CHvM2Yx0BI3nCsOzg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD2nK4yyRFKk9zNZMhwG4gs4iSjrSsb1YK98rOdGu6s=;
	b=XWt8Tip/hbFvcJoIxcUhHXpTEhFWX0UAEKxoZtbQ/AWhT/GPwamjGvfWxHByhnboLG3V2e
	Ipa9UTESEBs7OqCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A5DC3EA66;
	Tue,  6 Jan 2026 11:52:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iCFFAon3XGnsZwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 06 Jan 2026 11:52:41 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 06 Jan 2026 12:52:37 +0100
Subject: [PATCH mm-unstable v3 2/3] mm/page_alloc: refactor the initial
 compaction handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260106-thp-thisnode-tweak-v3-2-f5d67c21a193@suse.cz>
References: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
In-Reply-To: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, David Rientjes <rientjes@google.com>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam02
X-Stat-Signature: 9ycxaiudhn8xrks9qyia7d6dqmzoik8a
X-Rspam-User: 
X-Rspamd-Queue-Id: C97DC80007
X-HE-Tag: 1767700380-72707
X-HE-Meta: U2FsdGVkX18xkeetwjyuOoHSvQmsevMxy+hEtnuwgVhzCu6YSFZNl92poOBA/cT1SjjXap8pNdDQasFebp6tbvVCk4Br9mCe+cc6pm4qG4Cczy9j2GuSiu/GRTQK9rmGAJzJt+pwMDMdDdqLJXZ+jrsLX1Rp7Pczxk0qZR9cyuREmNp+QgJcNhjRwQoi6Y7tdP41JaVAvbgGJVzyfG6FA0x/O+W748A7CXXInSeyPWbBEZzXuMg0YqbAk3Ni/b/MuWOnsWu8CzTFAjMNBP97NwFuvlHgZ52lM3AwH2TbVH7wejStp5nuDNckEO01hPZn9MDqRGWaCxZGtekTkOXCiZUYy9P9vDYH0nQ2f5ypp8FDwQDmYAkgPH27KglG4iVXF23jiRDV06kGke5QhbhiShzP45Uk8XjpiQDq7leZ3u833kJ8/m616xRKDbxtst2rDsf70E9XqT2GEkG7Iem/Z+tuMTXvtB+J3qK6gKg+TwCJzkqFQI1Yau+niURbwG6IAVbZ5+A/otu6FyuHuWC32tkH//5AvfyGKs25DwfDQgTWuyTpOgMzYUdA6EUfEK4RQzTE0/4ePmhAgxjKApeJcnQwRnyxii9KIDI42wE3FeFZ8IkOI4UbIBrapRmu89/uK4XRnhWoPVIM9Me0V/B1C8c1bpoMlu43ri4bqAzxq6ep3sNB7MRPZJHBGxGbmASGnpYSDCZpR8g//7da9aJCHUkcQHi1eTKZULeG1KouoMYlLsX9VwNsoB/D6MZ+A89Dprv10G2nzUCf2CUNjhEUoeuKjQy3pnNXgaJxSlRqKDbXMIlwF7MVgZZnBQgaQWd4+n2GZoQsY1kzd5GQyI/OY64fqPvDteIxqOsZy5bcqMnSPUmYiiPiTn6CdeZ8r5uVm10w5T03rNotL97DK75Pi9pNJOnZ2EDhLda3syUnwFbruTaOKyk6Ox4fGPzf3JDzWE+oJxC/IcsbShH2NW4
 CqYMQ101
 QxtzW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The initial direct compaction done in some cases in
__alloc_pages_slowpath() stands out from the main retry loop of
reclaim + compaction.

We can simplify this by instead skipping the initial reclaim attempt via
a new local variable compact_first, and handle the compact_prority as
necessary to match the original behavior. No functional change intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/gfp.h |   8 ++++-
 mm/page_alloc.c     | 100 +++++++++++++++++++++++++---------------------------
 2 files changed, 55 insertions(+), 53 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index aa45989f410d..6ecf6dda93e0 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -407,9 +407,15 @@ extern gfp_t gfp_allowed_mask;
 /* Returns true if the gfp_mask allows use of ALLOC_NO_WATERMARK */
 bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);
 
+/* A helper for checking if gfp includes all the specified flags */
+static inline bool gfp_has_flags(gfp_t gfp, gfp_t flags)
+{
+	return (gfp & flags) == flags;
+}
+
 static inline bool gfp_has_io_fs(gfp_t gfp)
 {
-	return (gfp & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS);
+	return gfp_has_flags(gfp, __GFP_IO | __GFP_FS);
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b06b1cb01e0e..3b2579c5716f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4702,7 +4702,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = gfp_compaction_allowed(gfp_mask);
+	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
@@ -4715,6 +4715,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int cpuset_mems_cookie;
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
+	bool compact_first = false;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4738,6 +4739,19 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist_iter_cookie = zonelist_iter_begin();
 
+	/*
+	 * For costly allocations, try direct compaction first, as it's likely
+	 * that we have enough base pages and don't need to reclaim. For non-
+	 * movable high-order allocations, do that as well, as compaction will
+	 * try prevent permanent fragmentation by migrating from blocks of the
+	 * same migratetype.
+	 */
+	if (can_compact && (costly_order || (order > 0 &&
+					ac->migratetype != MIGRATE_MOVABLE))) {
+		compact_first = true;
+		compact_priority = INIT_COMPACT_PRIORITY;
+	}
+
 	/*
 	 * The fast path uses conservative alloc_flags to succeed only until
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
@@ -4780,53 +4794,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
-	/*
-	 * For costly allocations, try direct compaction first, as it's likely
-	 * that we have enough base pages and don't need to reclaim. For non-
-	 * movable high-order allocations, do that as well, as compaction will
-	 * try prevent permanent fragmentation by migrating from blocks of the
-	 * same migratetype.
-	 * Don't try this for allocations that are allowed to ignore
-	 * watermarks, as the ALLOC_NO_WATERMARKS attempt didn't yet happen.
-	 */
-	if (can_direct_reclaim && can_compact &&
-			(costly_order ||
-			   (order > 0 && ac->migratetype != MIGRATE_MOVABLE))
-			&& !gfp_pfmemalloc_allowed(gfp_mask)) {
-		page = __alloc_pages_direct_compact(gfp_mask, order,
-						alloc_flags, ac,
-						INIT_COMPACT_PRIORITY,
-						&compact_result);
-		if (page)
-			goto got_pg;
-
-		/*
-		 * Checks for costly allocations with __GFP_NORETRY, which
-		 * includes some THP page fault allocations
-		 */
-		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
-			/*
-			 * THP page faults may attempt local node only first,
-			 * but are then allowed to only compact, not reclaim,
-			 * see alloc_pages_mpol().
-			 *
-			 * Compaction has failed above and we don't want such
-			 * THP allocations to put reclaim pressure on a single
-			 * node in a situation where other nodes might have
-			 * plenty of available memory.
-			 */
-			if (gfp_mask & __GFP_THISNODE)
-				goto nopage;
-
-			/*
-			 * Proceed with single round of reclaim/compaction, but
-			 * since sync compaction could be very expensive, keep
-			 * using async compaction.
-			 */
-			compact_priority = INIT_COMPACT_PRIORITY;
-		}
-	}
-
 retry:
 	/*
 	 * Deal with possible cpuset update races or zonelist updates to avoid
@@ -4870,10 +4837,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */
-	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
-							&did_some_progress);
-	if (page)
-		goto got_pg;
+	if (!compact_first) {
+		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
+							ac, &did_some_progress);
+		if (page)
+			goto got_pg;
+	}
 
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
@@ -4881,6 +4850,33 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	if (compact_first) {
+		/*
+		 * THP page faults may attempt local node only first, but are
+		 * then allowed to only compact, not reclaim, see
+		 * alloc_pages_mpol().
+		 *
+		 * Compaction has failed above and we don't want such THP
+		 * allocations to put reclaim pressure on a single node in a
+		 * situation where other nodes might have plenty of available
+		 * memory.
+		 */
+		if (gfp_has_flags(gfp_mask, __GFP_NORETRY | __GFP_THISNODE))
+			goto nopage;
+
+		/*
+		 * For the initial compaction attempt we have lowered its
+		 * priority. Restore it for further retries, if those are
+		 * allowed. With __GFP_NORETRY there will be a single round of
+		 * reclaim and compaction with the lowered priority.
+		 */
+		if (!(gfp_mask & __GFP_NORETRY))
+			compact_priority = DEF_COMPACT_PRIORITY;
+
+		compact_first = false;
+		goto retry;
+	}
+
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
 		goto nopage;

-- 
2.52.0


