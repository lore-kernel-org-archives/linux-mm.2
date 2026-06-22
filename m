Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B40DCCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963126B008C; Mon, 22 Jun 2026 06:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A336B0092; Mon, 22 Jun 2026 06:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876F86B0093; Mon, 22 Jun 2026 06:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43C6A6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A719A8FE5C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:47 +0000 (UTC)
X-FDA: 84907107054.20.EF81FDC
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB662C000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=niz64DAL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3Bwg5aggKCFQ5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3Bwg5aggKCFQ5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1/cP6vHwWuZGO/mgc7SKKRNMY8A0RgkRxhrS8s00BQ=;
	b=VIoSlFU6PCOQzdZWW8TPRbTtL6XPIdUWgzk4aw0Bf5RmW8oBfH98TuBI3vQF9zMRKCznev
	1U18e6wcn1Ly5wwj78RXIM1bN3BuMLQXiGI9xhXY5FowZwYFPBbwF4cJwmjYODXDd19Ouo
	v7py6w51l+epH/UFEI6xvCRef4iLH+8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=niz64DAL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3Bwg5aggKCFQ5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3Bwg5aggKCFQ5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122505;
	b=Ah53/L1K6cikCZ4bOCPqMADSatSLaY7TXmbCtXUc0iTEwH8Ykg5alxn86iiigiM3WrNWG8
	4fIl7BHkBYmleLo+9kOhqwZc6PMy8nW8Qp74ZjDuw2yGlZH0LuSkisDoFQ/xQYpTqRd5bD
	wcvAEjY+NPKsGYJXvRlpnucqHRDIvmA=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bf2dfdc0582so384949666b.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122504; x=1782727304; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1/cP6vHwWuZGO/mgc7SKKRNMY8A0RgkRxhrS8s00BQ=;
        b=niz64DAL1ycFhH/fW5EUoauLF4XdLabMw+FmdrW7kw9DK/s0NLduGcQV3+IG/X8snu
         fB22E5GNANwrMKeDBFgrzoddXBNRpmun2uI0DxS7y6H/Wxw9TgfShkWbjj0kNvINzzq0
         4Yi38PvMIwQgNGwG1PZxhGD1ZZJuux5VHegKK1V9qNVLgy51wqK8WLQxyNBDK3Rad00m
         c/moxjwZf1HTujwbgn1y8UvJyBsxNleEEZuBU7XpumuRTHA0a1qm5m0tx0Exp42e9jN8
         BTeouTsvWZdDd95zRkEY+eUNrRn85PNJgntrID6D0BNJvsQB1zMcRFTYiAYc7IbEI8xl
         mxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122504; x=1782727304;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u1/cP6vHwWuZGO/mgc7SKKRNMY8A0RgkRxhrS8s00BQ=;
        b=Scv8At5X/OkABVzjFJJ9hXrB20YwTL+Qoi3suNqv6eWmX9t/Po+0KuwHsCf95vqKSk
         1BD+bt12BqGxxpj0fYt7z5R4hscYtth2OsSTuUluzKLw9hIZc4ac6PIRjAF7uiholoUV
         /XzoLkQk0B4falHdXpEasVRJDANEwEJA2P9fwznz84nYEtLwpIgvKBU+SdkVNKAuUHuN
         V7CXNqxLViUhAveV1O2KmTJeLTc0ujgrbwbxGdTEwyqIRJ+GaXG3LVJPK/HDWn1bADUA
         QyzPUk8hRSO0jPRPAp7iiy23s0iW0NgN5lsUDQhf5a1j2iTf734f7p+KiSpGv99pNItv
         xQWw==
X-Forwarded-Encrypted: i=1; AFNElJ/LaozMX4AnjRDGtjJN+eGLqd+WFuKxySDORZa7+6DPkbHUMSdJmI2wazXKxT6XN5nccSqXa9+rRQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5xCr794ANNc9tLGtbfB07PNzS7NNlDxkH0z8UmYDXeBqbGeB5
	TAcOCTENgrBsT1NnkDr38tS3zfcihj+pphghOyWdUQSg3xAYJstp+YapkdFnEyry2Yb+J9vVib9
	v9DI0bzCFalpHXg==
X-Received: from ejbyz10.prod.google.com ([2002:a17:906:dc4a:b0:c07:7108:ccd2])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c01c:b0:bee:bbaa:f19d with SMTP id a640c23a62f3a-c0b61132b41mr553875566b.14.1782122503188;
 Mon, 22 Jun 2026 03:01:43 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:29 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-2-31f31367d420@google.com>
Subject: [PATCH v2 02/13] mm/page_alloc: some renames to clarify alloc_flags scopes
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
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: CB662C000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: tzn7proxg1yjye8su6jnyw635c4wpyjc
X-HE-Tag: 1782122505-485356
X-HE-Meta: U2FsdGVkX18lGegpxcM8aNglOTwKUBpBwmiPD7OO7YZmuiZdZApYkNjADj2AOIqxtI96X2eteLIuPZ5YWxW6Gj+x3FfRuVLJJS1THRrR8dbWJOEayjF9VrX12D8bxPeBEfXc4KyMYfCTKkkFIQg1K+VFDXxcUiisVKYT94g0aCnIXOGGVSltuCMr9sInw9RuWdMSMHekbcz9tdyMFoBAs6UoLgqUPIJyICgaNVSQ4VcVqc2t3QUKQQvoxOv+Mdl0KKpq+VZ43LooYqLL4muo+SC2etC8Q30Lf76QUI0rEknrn+mCRyVgIhpDieF1V75dHBWKeY29/gpXXXmIJAzXDcsVVer9ZFJdz/yvbBNLAa2oSheBeChno9BRIUKOsWxQxg4bM0eHT92nLRFk5ut2JH92AeTL/VPqtWDQnGwN4h1LKL8uxcD2G2QeaNqXSzsjDaFnEZceiq24f9Pf8/5aN1lCa+X9wIeONIkg1ZXhqMTABfxcgjzlorx2JUktfhbA11u+Hb/bK4IWG9267q8ZtcszLHQcwFl1GcYWQuzko5uCxAqWMVW2mX/s0D9APYYgdNDqzcDHeUnmXKlSwtNsHH4ExF/5G/c14XhLcXXkW3AOGR7OfyX+wieBWlu09X6/Fy/kQQagZ/sfz+ThpWWg7k12/eKUKxyU17KcBjW3rDnMIP62BNrz8zopsD33mjGUAZzfTKeT39FqCqEJMVcj+Upgdo8wERoXYmUMVmYR/7asNB/9rlvZ54bFU/r4ZZsmya7cEtwGpYK1I5XPd9x6Rj3TzJM99UZsX35ydHoH3DqdGEop6D3vfFm8wDZ2eI83V+5nzl3gwzOIOYt6ImdFKdCaJybslwCBjKIv+Ij6WMFuBg1dJs5kx0dWj01yUb9F+m43aNx4OUKxkJY3cwkziVYypIdJJMY/fSNfz8NtBUIzoEcqf0Hv1JEgHHBkzTTS6ftM4CRKZJbBmdbADah
 i4AKhfOH
 ULtFL7Q1bjGIU+glmA9Bvq23nG0hH9fdexjHfdNy5YYEp/CENmf07Nl6Bc6uoK/ReX9LphoHR81cO7XGjR1+fuPjwVcRvAeVGFLfY3qOgzBsO+rRCVRhmfYcu3B5h9SeEbqjLvsvK/gQz9jqb+xPevdLDquSqdYzj52P2O03Lvv1+cbN+2jtMwJJQ3p6KqbidcdXXNaixAFkLs93JFHbL/gu3ua8SIqIa1mpn4vwZD9xEdp/scGfxeX+0Oc+SlavBm1FcqWfgOBCbPkoqEYPfY7+DKR+nOuWqTujaEpeD6uJtLvku+/UEZMDfQGhk92cYRuVsguXegFhmmbwc/lf0RLGXaCanUOJNhLIpL8oxkKxIYCtE6kLijQ/E8wcIN8/gKrK8wG7+eyW23kaT7BZ9XKy9vu3aqzMMwnjlwoP/SRzM7OYtJ2REh0tTyGgBIrQ6tstlD5hCpq4UeV53stQtGRe0gVrZLnGw+Ys/Jn+xkepdgUnoTWj+ZfAUQ0Kdigcfssx6VKQl61S4J/RADH+qj/R+SBGcQrAOaNOnQJ+prgCJ2w9yiE2RiAZB5+oNe/YM0lnZA3IyXdewcEhpR03+7Hk1kTdOVL1r6GbXab84pcuFZ95ZceqL64kC2eU9/I3kSUKAFrGwjTdSBhPmbmJj2bT+1T4Va6vDLjvCQccrcFDJqzShurju46KczA==
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

- prepare_alloc_pages() is generic in that it sets up the
  alloc_context, but the alloc_flags it generates are only used for the
  fastpath.

Rename some variables to highlight which alloc_flags are
fastpath-specific. Rename gfp_to_alloc_flags() to highlight that it's
slowpath-specific.

gfp_to_alloc_flags_cma()'s current name is actually fine, but rename it
anyway, just for consistency.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6c4eb6908bd95..bc05d75a41627 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3771,8 +3771,8 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 }
 
 /* Must be called after current_gfp_context() which can change gfp_mask */
-static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
-						  unsigned int alloc_flags)
+static inline unsigned int cma_alloc_flags(gfp_t gfp_mask,
+					   unsigned int alloc_flags)
 {
 #ifdef CONFIG_CMA
 	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
@@ -4471,7 +4471,7 @@ static void wake_all_kswapds(unsigned int order, gfp_t gfp_mask,
 }
 
 static inline unsigned int
-gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
+slowpath_alloc_flags(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
@@ -4508,7 +4508,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	} else if (unlikely(rt_or_dl_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
-	alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, alloc_flags);
+	alloc_flags = cma_alloc_flags(gfp_mask, alloc_flags);
 
 	if (defrag_mode)
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -4774,7 +4774,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
 	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
+	alloc_flags = slowpath_alloc_flags(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
@@ -4815,7 +4815,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags) |
+		alloc_flags = cma_alloc_flags(gfp_mask, reserve_flags) |
 					  (alloc_flags & ALLOC_KSWAPD);
 
 	/*
@@ -5017,7 +5017,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_gfp,
-		unsigned int *alloc_flags)
+		unsigned int *fastpath_alloc_flags)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
 	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
@@ -5033,7 +5033,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		if (in_task() && !ac->nodemask)
 			ac->nodemask = &cpuset_current_mems_allowed;
 		else
-			*alloc_flags |= ALLOC_CPUSET;
+			*fastpath_alloc_flags |= ALLOC_CPUSET;
 	}
 
 	might_alloc(gfp_mask);
@@ -5042,11 +5042,11 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	 * Don't invoke should_fail logic, since it may call
 	 * get_random_u32() and printk() which need to spin_lock.
 	 */
-	if (!(*alloc_flags & ALLOC_NOLOCK) &&
+	if (!(*fastpath_alloc_flags & ALLOC_NOLOCK) &&
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	*alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, *alloc_flags);
+	*fastpath_alloc_flags = cma_alloc_flags(gfp_mask, *fastpath_alloc_flags);
 
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
@@ -5260,7 +5260,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask)
 {
 	struct page *page;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int fastpath_alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
@@ -5282,17 +5282,17 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
+	fastpath_alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
 
 	/* First allocation attempt */
-	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
+	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
 	if (likely(page))
 		goto out;
 

-- 
2.54.0


