Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E558BC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7CD6B00F8; Mon, 29 Jun 2026 09:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CB86B00F7; Mon, 29 Jun 2026 09:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F606B00F7; Mon, 29 Jun 2026 09:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF5456B00F7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 259761C6D3A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:36 +0000 (UTC)
X-FDA: 84932989512.02.28DE9CC
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6DB6740014
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KjBQchi3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3QG9CaggKCIEofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3QG9CaggKCIEofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738754;
	b=vu4U9qUjWqYyZbcP089MIXcAiPMF1idMjVfzi9FbkSD3RHRYgYZXCFvq1VV/wnLFqqzhOe
	oKlHJy4N531bN2hzwvqUBPYLIC0gpYCox+o2AsANFfkCj3ZoaP4CP3IVVEGjVg1Mm1HEub
	rSv/9gm5gIQ6XK6pAI2CmFYs5AvGsSg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQupKTDZjED0JSNU6dTXI/Jh97qQEoEP5PP1fd9rJgc=;
	b=u12n2vEuAmSiDGE/sO5EFmb/CquvZ2v6TeCREXv20Vo+BAqRrn2FyBQCdRw2F9LWTrTKBm
	ffLaphw/BAJSauYE+8VbyNh4iUgu04kSgk3Vo6/Zxlms3tk1ZXQfPkt5lZP3MvrrX97ZPg
	MvzKx8Sdd8+WbHNXcK5XGfJu3Mx0Y9I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KjBQchi3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3QG9CaggKCIEofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3QG9CaggKCIEofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493a8c883a9so10628135e9.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738753; x=1783343553; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LQupKTDZjED0JSNU6dTXI/Jh97qQEoEP5PP1fd9rJgc=;
        b=KjBQchi3jMD1lPxWE00AZeL6gumQzQo0hMY+TYK0Zm8JI15IF/iMJeXAOFvIeDCWfe
         aFBcGq5Wmtz+F7+SfILiMrEROFNBWTh83iHjQVZuA4f/xLD1P41rsfNGeNxvgzYPPbCu
         VoGRF1q3qia0cpjlxp1am23fqkAWRDVYbfjStKpgWTmkP8yFc8CThlKx19DwWQWanUbA
         6s4B+gsrIJq6v2z4TC9tzNvF6p3ZNeWxezUUJNk65RpMr/yjEWDYm0DSMQlZKlO9g8/k
         JZ4gj6D5jbxGqcXM2rzwXZ/8u2JgQs/s3pguofkINWi2ncq/IQZVumZwewAN164xWV41
         X3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738753; x=1783343553;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQupKTDZjED0JSNU6dTXI/Jh97qQEoEP5PP1fd9rJgc=;
        b=b/H3QyWImAiu3QxH+oaRiAS0HlfoKYbVl6tzUSxucpKbV5L/uokRTc1qTOcrprYxyU
         mzltyq5YipZ28vWwY0H3xNglHW1B7e3OM/1TES8q52TeFdNB8Q+1xioQdnBFpTVPgUj3
         66k1vHvYAiYd7bqU+DPDNikXtNA1Kf3PM5c1AG0zx+JqZjZ2+/K7soWiVGl8k1eHtee+
         Shq0udaA+mq5rpjam2wtrKmNvitpg7RRYCkqAkmzCVTsK7xKe9Y5mpi9463wzVediUWe
         BcCjsK5jFEbnfgp44WdRRR48vUQKMNADHlZwry0Zt8wEVa0s7oa0+Wvzb2Fn/VJZ0JTJ
         NO3w==
X-Forwarded-Encrypted: i=1; AFNElJ+srz7LLafLZbtXvg/95pBVvGeiMuGA2K7OLrcO0PDnGASU7vwX0iGpPutVg5hqu4fX9GVDUBl1YA==@kvack.org
X-Gm-Message-State: AOJu0YzzIaKgT/q16gpVgFAOBaT+7DNcZqNuPvxM9OTCmTnrNyMhJf67
	qLIuJQBe/MI+yxR6cYwrnvgJ0OapYbFXpg0qVnyIxQsdkl+A9CPI2HCKoaCTpaxzeqcPI3KxGPB
	8r1AQT4ltYHERQg==
X-Received: from wmdv20.prod.google.com ([2002:a05:600c:12d4:b0:493:b21f:6ccc])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b03:b0:490:be78:1861 with SMTP id 5b1f17b1804b1-493b718f985mr10806475e9.4.1782738752633;
 Mon, 29 Jun 2026 06:12:32 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:12:02 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-13-57bef0eadbc2@google.com>
Subject: [PATCH v3 13/16] mm: Remove __alloc_pages_node()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DB6740014
X-Stat-Signature: 9efsq6bdmf3doofic6xxuarhtoadk9zr
X-HE-Tag: 1782738754-745140
X-HE-Meta: U2FsdGVkX1+Kp7pK9ZP/BOVwveJatYul4vqf0sSJAu7s8bn5eQvwc8hNpm963IR/yCt2znnEl1GV5u4a7sbEwrwpKN+1i6ullt4XMLaBMbnlBHFdvkqX6EmS3WeKhZhsuMw9XQHArjm8kYoo5GJE5aosGx3aF8DH4am5r6pO5vnci5C51alQEnIIEHymgE3FwoG/24e/EqKmEgkkDRwwF2thR9QPDpUsG/xnnA9sBWC2eKVBR1wqkG89JVgaCAC85rH7GMaM7Y+eNM2/iAIjaeWZQ9gBW6wl8Arbcg4OMz99KHmSM8HvcKyv0TqipWeDzlmrA/cznBtglsWSr7XXCAKRPkWnX2nz78zT4Yb2YB0a0oWr1DDa/DyD9EGCUCIUTHqa/f9oa89cArcXg9SbZt3dV+TZY41rh33ylwUu3AsyCWa4mOGMe4DsJVp48+b0ZWBqe5bzDKiDJcRlDi09BUJOl9t8GzOHsrJQ3ODz1g+db3qp6ORgKymXGbufTyrLvKz1krBVsoMIOFQ2Vc1cATKwJ8DgaWDV1BCc+FU/bmxa9uyQer/VQencUkdt1nXuj2eIlEIVaFCztZrRdvop4QGmPyMkyalbmkcgT4q66F+0b3OR3fzCtIOLCU7a5JrIagPUa6WYsophhDF4oebMJ6uvuWJXlPLpb51VHwH1KW9xm6ifjt+vLPSuNmd4AJi4VKFxRKR3LKzGB8gJjxT6lFsDOSfG1F8qrXx7l3vV5eJYzsPk5sKdM6rTyvdbdDv7xPkU4PLrGN3sOXnkpkTcUPuGitjgzoCCc8xoZIz5j3qeMF5S0fX/3QmY07FO56cdGDaz5rF9Y05jvKB3dLwyjuZ+brUD26Z10bjyJEPHD5cw5rBleq20TyDgnL293NyK2m3I0M7x9DW0vASvIDdF5KyZzW7qRVuHjfGMZTgxbS4HxSakNn5+CREYp33Ifk/fFt90ElbBsG01VnMpT5p
 T4zQNYTA
 kSJHk8HNLoLEBXxVJEOJw3J+ijHGmn/wFmUlNuKMA7FRHSaXBH0OjlEoQtAVcvCOb5Bjko6+MKEj6drZCj0Cu2qASBa8mxgEktvENojseH/wM+563zP498dMWnQm6EDUNfnh37EH0yk+bidhTvnqHAAx9ihpeWXgwaIzMeZq3HJD06YJWM6aT4QZ7arzsOGICehByH1DJccRbOcv11eLBbx4UOd+ISSmNx0CB0zoDhYX6Bo0ZVJbQAXferb/Ic98bsOIQWjG6QOWTB87SURsLhTwtIZKzxXYs1EV5QOV7NDE2ty9OHToWcs8a9msLFuBouBp2DYVT2SaW96EdjK+bzmU72Qn6B7AhiBkmTGa9trQTLv5xpZxhgJHoHyDhYt9e5+WJobRyoL0GIkKLrzqRR/+GU1eXnyqUpiNBJ6Q5Aeri5EfGURwHrwVjYn1rCbtjeETRA6k+OYqHGmWAn83Ibxkg4dNK47ecJnghXkI6+oxBo59jAll+CkGWQSHQ0vr3GJqyXSEqRxlD+ZXjPUXu5XRfX3Ctdl6vtd3q3XmXQhfxOHtb3Dl7C+VT2X6UrgZChGYgMf6dYyg53XoUA3zk7nX4lCJkKULv0L3nTQScyGNKD+MGLJhmMhEAxfWMOPkG5C0sTzUOw2KCgVTI6OJ1xCsISt/ZnLuNHsYPiTfmOWP5myPV9csQF61H+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There were only a few users, which have been removed. The only advantage
of this API over alloc_pages_node() is avoiding a single conditional
branch. The disadvantages are:

1. More API surface, more sources of confusion, more maintenance.

2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
   were using the result of cpu_to_node(); if the CPU gets hotplugged
   out this will return NUMA_NO_NODE. If one of these paths fails to
   protect against a concurrent hotplug then page_alloc.c will use
   NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
   memory corruption or other. With alloc_pages_node(), the code might
   just work fine.

Ulterior motive: this frees up the __* variants of the allocator APIs to
serve specifically for use as mm-internal API.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 01d6d2591f49e..3bf55a5f9143e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -256,21 +256,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 	dump_stack();
 }
 
-/*
- * Allocate pages, preferring the node given as nid. The node must be valid and
- * online. For more general interface, see alloc_pages_node().
- */
-static inline struct page *
-__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
-{
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	warn_if_node_offline(nid, gfp_mask);
-
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
-}
-
-#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
-
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
@@ -293,7 +278,10 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	return __alloc_pages_node_noprof(nid, gfp_mask, order);
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	warn_if_node_offline(nid, gfp_mask);
+
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
 }
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))

-- 
2.54.0


