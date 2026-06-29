Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6411AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA496B00BC; Mon, 29 Jun 2026 09:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85896B00E4; Mon, 29 Jun 2026 09:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE556B00E5; Mon, 29 Jun 2026 09:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E53B6B00BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15E3A120680
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:20 +0000 (UTC)
X-FDA: 84932988840.07.58FCAC6
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 542DDC0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mJi81LLn;
	spf=pass (imf10.hostedemail.com: domain of 3MG9CaggKCHEYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3MG9CaggKCHEYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738738;
	b=PG8RJxn0SBidOxZ6CVEfF4eQ80nK4T4UxFuPIAJZNO1pKQ35I7KMpzAryZRA5UtWoVLrIW
	AMZo8GCyCKO/EDuPejqYQAyi2DfN4ZqyDdlj5S1c8fxgOyZWUWG5xy9pX0kmP9Kf2bZehV
	X1FG/+JcKsMmI2Crwzjwa2vNfkZEMvo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXmwXBBDrQxZmyWMThtaoSC2dpVKxqRifyMJMMj9Lxs=;
	b=yRzfRE6nSLtSW8y31tb2lqW1JgNGXly15zF3CdFIaz8U9Nnc8nATWbW+oELLLxaHWX3cMH
	lL6MfXfA0RxY+23acZessbOdpwWpWzTbjV6jhxcLKqnhvzfHoxWMXHAk75zlqQGn3k/vAa
	htuvUILKEW9BGIL4uU18qES1kWt+vro=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mJi81LLn;
	spf=pass (imf10.hostedemail.com: domain of 3MG9CaggKCHEYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3MG9CaggKCHEYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4629f312a67so2854600f8f.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738737; x=1783343537; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kXmwXBBDrQxZmyWMThtaoSC2dpVKxqRifyMJMMj9Lxs=;
        b=mJi81LLnbAC7hca7AyHsB8q76kUMO0drMhfk25u5xeN9JYmIoJNLesnvr0B34+ITsA
         +9ll0slZs57xpTLhAl3JQND7mo2aiAhtSQTcbX/33nRJCLoIEQSGL97R/zBsxU7z1c4n
         GsHoamaBoc2OdynvD2ugcKsfhOlBv796VApMl1AJ5gvKJhyaXxy3O1DfCMedTNALmiS3
         iDgQqcE2JjTRgnBZqZO1SBhzA1J12PtcNkSr00CcNrg43kwgTJp5NXZd43+IGQl8gBLG
         8ydpwcOGX+mQvfyjLkLc16asSeTbqw71pBL/nb4fbCsEvpV0t/I1nHuEhb3gSYZYIr2n
         ljQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738737; x=1783343537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kXmwXBBDrQxZmyWMThtaoSC2dpVKxqRifyMJMMj9Lxs=;
        b=dwqHKJsY0+Gminhc30kbmz+eiU5fMPbGGnTYudOojnpVKoPGFuheJW4E5SPKPsYJqh
         GbwuQ3V2bUgFe2WAKcjHYiPs7yUvjkSRvjAvtIBUovLzfhg9fSEdhEFDWuh9xqTVQ4W0
         9TpNZNQFcXapwBzh3RbW6r5zEXrOT6qi5nkQdwHmJF5OCBD4VZeOOsc6Nibd5il80VE5
         W7gcUvtpAO6sBLqI8r3yuI+cgH1wUErjhHXM0q3XhniKEFLdKUSNyaKy0xOzqLbps39Q
         VFVAy3Yg4WrKcotAlqpjxcTJj6i6ZpswfBf+BgCeEa2ysvBwRwf+AHbLRLEJuk4K92Wi
         NZlw==
X-Forwarded-Encrypted: i=1; AHgh+RryT/sT0at9ELM9V+t69Xs+n+b2chX2+3FiPx6aIoz3J/uU9OHWuYG7f1/IYygBKT6opuTaIVfJdw==@kvack.org
X-Gm-Message-State: AOJu0YyMCQ8RMGBGaS9+HUo0QWoZMG5Y/FyLyG2ZYRMkGbkGVp1YOJsR
	oiu6cqllxN0jYGnTTR3lQB5ZnuYjavjIHVOy0xpIo5+UyTcndbkzWs0Pg6K+yH/Xizr9j0PlLgi
	u/vQQppNvMANFIw==
X-Received: from wrqa1.prod.google.com ([2002:adf:f7c1:0:b0:462:5eaf:a858])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4383:b0:43d:dd:8ca4 with SMTP id ffacd0b85a97d-46dbf9bf20emr28190928f8f.14.1782738736093;
 Mon, 29 Jun 2026 06:12:16 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:51 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-2-57bef0eadbc2@google.com>
Subject: [PATCH v3 02/16] mm/page_alloc: some renames to clarify alloc_flags scopes
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 542DDC0002
X-Rspam-User: 
X-Stat-Signature: 83uobf6jyje9rso18dfu83sstn6ktat5
X-HE-Tag: 1782738738-504553
X-HE-Meta: U2FsdGVkX1+89ut/HdW5lpmS+ZAYlreoaoZHMJVffK8khy/744v09edi11aWEK2u5dnahybD1jh/bl8lE8fyad85DvVaG2SMr2EOJMX4xuo6ISpA3ghOOm5N3NUr99Rzme2UsuT5FbViF0CYqY+iPii/OklyjIkeXKbJBSF9X7d1x3hdUcGX/nWGmAeM+X23bK01NqioWb5m/h98xmtCWIlE8T5/jW4u8pSqNSv/Jue0x5LQzBkEbdh2tzUVED72ttd0qzxdoWp+cHzPWdPY/YP6XEy83KS/aTdkeHqqSsiJv7sPSlDOckXfqu5U76BtBmu2WAgG9nCTo+jFppnn9bFhHv+wflBQVXzUjj5RVgDPC1BNont/lJcFcTq4V5zE7V/V/nhBsz89dDPy9UyLMU1ajjcBnSIjrmWeIPqAg1P0ysMkdScYCmr9QvsMZ2K6uV0RO+bIiqyXkQuux5H4HaAdVnj3zPxnzZWpOnhqQvzKaL46oso5J0F4fqJTM7tm+WtsMWKMcvcLxWPHXlS04jOW78+3lioI3ggGEyAloSTspg/NaNaHn/966vv1kDq6B8PcbAgjofwROzbzRUxsME/D3EhFDMOzG+O6/428YW7ZshKPaK8X9EmCFAVhEQaULCg9kBvbDz2D7EQ6r+Z1o7NSCkRjtWIqFxsO0ulpr3CUvk5M/2vxstFjpruXD6pA/1y/NDUDV/0Yut1jVNUOmPfTkwH3mF6Q6ios9XJ4cLgwFzohWQ122V+HqtkrdyBIsXDnlm5HjeBxE+3UNE5xafJu66HP96BhKFsMDOKEZ69MsLNQODaZVAZIl7qMCuyj2TWnFUmXhTq+J2n1/DUhtgX5+xyk+Z0/m9SGvtXUZbK3qF2DFsLrsj3UDlEQl/fz0WZa7+QR4MxcbdYXVm74jjktWYsHVqk9ZzGXrD15a3y9PbPee5KX+WUS9M18DmzAC71J7rTlRia1VW6fiz5
 XpoJlsL8
 HgcWWufiJMHXvqRDePjo974FOUsUpgJKpQ/DuylcGZXNsMYYthuZnMd19NoexrLZeAG/+oJrB2kxuyW6apfy5mlcIm+64FDMpZiVKYJkv5IUlzTIEfGJ421Xw7YBqeTQoRwXx/CyzFhEYrP29I2FBWDvD8zBPZLk4dB9GJQ0hg3ZXjmlau+VgThZrEPR01LmVh3dQZxsRCo5r25DOdrgpFVWbX2MQo8j5yzKjt1p7XcyPryRG7LY9N2ChiyaajLXMI8Ki1qpPiYVOIc+c0dVStdth6zDasWamk18Xpr9zqsU/VOUvOc2/BZ3atW1nLMq52RkS30aLK9is+MOWS8BDZnalCZ7WEq58LLb9p+g9QZsKvSRB+cot844MW+EAOoLiZ+9BnnaI2t1hTkWlYY8DTqHsQydkfErDPOXr6dwGcHHWFPXB93rF5XdwgRgzaHtk164c7f3elARzN2yXUw7rVJFCnMrw5Av8HpWv52qbPbPDGvLi45Pul9TdSf+26sDrlplzE+Z3P8WjfXbneHpucvvaM17/NxEb6YiThtKCrJMEUGwK0kdoyuFX5NA0ADVUUKPaUJYYhga8dnoUoq4ucGkNIOm7rMDu1r3W8yItOCbWLK20zupvm9zk9Rs41NdNvozbJoVB0Ncqr34rJ8ixhfZ5qsb+b998d3gQtQI90nK5uYDVFFAK2dUMzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's pretty confusing that:

- The slowpath and fastpath have a totally distinct set of alloc_flags.

- gfp_to_alloc_flags() sounds generic but it only influences the
  slowpath.

Rename some variables to highlight which alloc_flags are
fastpath-specific. Rename gfp_to_alloc_flags() to highlight that it's
slowpath-specific.

gfp_to_alloc_flags_cma() and gfp_to_alloc_flags_nonblocking() currently
have perfectly harmless names, but to keep the naming consistent also
rename those to the alloc_flags_*() pattern (which already exists for
alloc_flags_nofragment()).

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 421271849f291..6010693861ec2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3774,8 +3774,8 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 }
 
 /* Must be called after current_gfp_context() which can change gfp_mask */
-static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
-						  unsigned int alloc_flags)
+static inline unsigned int alloc_flags_cma(gfp_t gfp_mask,
+					   unsigned int alloc_flags)
 {
 #ifdef CONFIG_CMA
 	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
@@ -4474,7 +4474,7 @@ static void wake_all_kswapds(unsigned int order, gfp_t gfp_mask,
 }
 
 static inline unsigned int
-gfp_to_alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
+alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = 0;
 
@@ -4497,7 +4497,7 @@ gfp_to_alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
 }
 
 static inline unsigned int
-gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
+alloc_flags_slowpath(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
@@ -4512,7 +4512,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
 		alloc_flags |= ALLOC_KSWAPD;
 
-	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp_mask, order);
+	alloc_flags |= alloc_flags_nonblocking(gfp_mask, order);
 
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		/*
@@ -4525,7 +4525,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	} else if (unlikely(rt_or_dl_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
-	alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, alloc_flags);
+	alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags);
 
 	if (defrag_mode)
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -4791,7 +4791,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
 	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
+	alloc_flags = alloc_flags_slowpath(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
@@ -4832,7 +4832,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags) |
+		alloc_flags = alloc_flags_cma(gfp_mask, reserve_flags) |
 					  (alloc_flags & ALLOC_KSWAPD);
 
 	/*
@@ -5063,7 +5063,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	*alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, *alloc_flags);
+	*alloc_flags = alloc_flags_cma(gfp_mask, *alloc_flags);
 
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
@@ -5277,7 +5277,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask)
 {
 	struct page *page;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int fastpath_alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
@@ -5299,18 +5299,18 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
-			&alloc_gfp, &alloc_flags))
+			&alloc_gfp, &fastpath_alloc_flags))
 		return NULL;
 
 	/*
 	 * Forbid the first pass from falling back to types that fragment
 	 * memory until all local zones are considered.
 	 */
-	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
-	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
+	fastpath_alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+	fastpath_alloc_flags |= alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
 
 	/* First allocation attempt */
-	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
+	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
 	if (likely(page))
 		goto out;
 

-- 
2.54.0


