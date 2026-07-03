Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A4EC44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0006B00BB; Fri,  3 Jul 2026 08:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78AD6B00BC; Fri,  3 Jul 2026 08:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4426B00BD; Fri,  3 Jul 2026 08:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82AC86B00BB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E37071689E3
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:23 +0000 (UTC)
X-FDA: 84947403366.12.54A5EB2
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20001A000E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U8kGnqvm;
	spf=pass (imf15.hostedemail.com: domain of 31KtHaggKCKMMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=31KtHaggKCKMMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081942;
	b=dbl0n69/BNGnD4YHWFawEwt9rYQ5n4tOm2ha+NuQ991IIJXaepYgQm+VQ3QpJzp8nEkuvP
	e/j2qzYQuSpfLJRvDoCz7c3TgQJmqZa6J6PH4yIlDcC8tbbGVsdLSzn4dv7bFbRXnwQ7qs
	oLnCsb3wD9TuDZQzTqqbIB1SDMGnFIY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ni+aRw2R4ZEwrhwGe4xokmUGFRvRoyUT7XfJ1uWOieo=;
	b=FDUDD+TqC8Xt8zVDG51h4lGKJH5lRBtSfAci4IA652AWwwGPKq/GKFm+RZbMUN9vMPqJ4a
	dou/Fog8KpL/XN6RjZKoiIx6EBl9yRRP+DSVvIl9ixeLUFFhKS881vADQBUP+4ohKa0bJS
	etrltXbyI8pzdqn5sJ7ONpsnAYIB8m4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U8kGnqvm;
	spf=pass (imf15.hostedemail.com: domain of 31KtHaggKCKMMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=31KtHaggKCKMMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-474170b59dfso387004f8f.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081940; x=1783686740; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ni+aRw2R4ZEwrhwGe4xokmUGFRvRoyUT7XfJ1uWOieo=;
        b=U8kGnqvm9b30AZFSzInkTPQSgN+D0SLxdQrNkLPOKC3vQ9+LYBCYnyLiYX+5M82MEa
         GtnSrNR4HYlUZCI7O6qiqAbWKneoCFro26sDoG3Km3Ap5npG+IGIMTf8yoCSIqd+1OZl
         tFAkRREoSbH8v/ireEIH/vvolXQZQr9qCzAAzj1PAaHFR28Ibgfjx/UKEwhnOZOL7IDC
         Ag20Q1BNWjTbaggfA1Uf1QgXljZj2CpvQCMyRgptttm9HG541Rc0ngEJX2+h4MW+UpRF
         XuuG1AMAfJ+u2xLQ+l81gg9V6YxzYe0KuG+F7LFSKVohRoJ9OM8BD84d6RwPvM5efHwJ
         6I8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081940; x=1783686740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ni+aRw2R4ZEwrhwGe4xokmUGFRvRoyUT7XfJ1uWOieo=;
        b=I/R1lwiRPLeScuKPsOIax0r93vySK8+AW52+g3XQZdBUPoKpP5M1qixo8vomp16Or0
         Cm+/iVXMVuByAQ07HXk9J4tn5mvgwt/UK/ozGGSwg2bPbJ9oPfu2VXTJVDIIFfdaPdc/
         RiqAkylRD/lv+wAUWY6Rgh0olCMcKQ2l4/Rv9el9/R8oRDPFkR+jRmmyjDX7E0/w+4ct
         mT7pTl2612CtHPxnpoCBy4mdi6t2Y1YoVvc5csu/DNxYJhAWof/2lWhkOVwaB27KFEUi
         Q3MaTovbx2ts4z+ipTKtFBftzZnBySD+TNebTsSVinRfTeYAvl8DxHtlsRC3MLMlActY
         KUaA==
X-Forwarded-Encrypted: i=1; AFNElJ+6EI5E/r9oH/JgYwZni8anWF6TwbzM5XGIIO8grQWIgRxnXyFKLiwaWGxkZ0uJr7iKYxDooYyznQ==@kvack.org
X-Gm-Message-State: AOJu0YypHVPCt7PylfSr72AEXFkeUV6Wj15GXn4AtnBjMzaBpWb0OrE8
	F5L7bSb74JYGcj7i3Q/5y3a5sAGRUA0PO3AM0/ua3eHmUJkBq3I/UJOgDSORX0lu3I9kmVYN0gh
	V5RMoAtTv66W6uQ==
X-Received: from wmcn26.prod.google.com ([2002:a05:600c:c0da:b0:493:b60b:4681])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6a8e:b0:490:bd66:e523 with SMTP id 5b1f17b1804b1-493c2b7f3bbmr100883055e9.20.1783081940215;
 Fri, 03 Jul 2026 05:32:20 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:42 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-2-c87b714e19d3@google.com>
Subject: [PATCH v5 02/18] mm/page_alloc: some renames to clarify alloc_flags scopes
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
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 20001A000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qpuk9r5nuu1fm5ojf79e6mwwrywn94oj
X-HE-Tag: 1783081942-58761
X-HE-Meta: U2FsdGVkX1/K1P2juwp4jcYqkW41/JKxU2THrVcoci70vr93l4bLEKhVrPsv8h36WzJEZ+nfrjcEu+9ZCb/BcmwA1L9PA+OrbZKHHMssHI20AM4YNbjxXgWOqHEzxxRinGikHeDTxf8I4maGPzRecYAwwQHKJTLyJzPql97uNvtOuoiv7Gli5RdRrbKb2sDPeMULdeg7ovArhcUQP66oUl5vf1Y36/Vsb87xe3mJoZiRl7qNxtR8dznzxFp4HZVUiCiFB1MnhqkPIP+Pqvj5roW5CDwxDxarnDyiJDSDeStoR38iP8HfOnZgWETwY06+lZqiq3GCT4mt+Gx5aIz0b4zE7TiQRBLrca5YA/s9IF9tYPpQOcoyJ/OcWoKEqChJIzKgFSxyph8vDhyMbYMiotoLpRZuDMP1dgsOtFg2SK4o687FREyDDn59Tcskohc8kRcBKs8ERUeakXkZ2zh1T+LhM4KNmyYfPvQ0ZZS3lKwUZZ5EGjI7TESVecD9l4ZiUv79Y3m4nMWUaPJ7t0eyJncShZmPWWhA9bJYtFHOgIi/1EWk+aRKjf5OWyDyixJxzUismUn76Muoz688RiZUT2dtNfnTB7RV+LL7CLNuP0cv7aSJ/rRVGRaxQA7cmQRn1vHYlrr0VE/YVu7tmJUw9H2CGN9lfX22yIvzWiYEp6HXfEf5a9TQ8fxdOS+JxW6wQhfme6nExbo83A4S8ctgVRAOtPf+FnURVyehoDiFYSq+NQcAhAEorJerMMkhMQHACQflJVd+Hp2qrWOGd6oS6dxpib/Aj47Fyo8z5sJ/bzd5SVTRd6hKbGD96xuix7GhRhOt0tMW9ff8YF1YbhO7tujvxTQ8AJ282dUlhL4ES4o5auq9/ZzYzjeDX3zGYeAJUKApx6uxfh3yppRYDM4BOyo3e0uTWZ21a8xn8/2PquZ7uA6+qDzszQtu1GHwU1zIOFyMbZo2OwOuM2l80Pg
 lPO8dGeH
 W5ulomVUx9/a1CcWny+HilFIpAcgKWlCsEM++stZkxK/G9z50k+xqakoCUZtUw5APZPzqDFdaTUCtm5Xt8zdA8j+4V0GSJdxcK98hcpERxw/0iAV2Xc8kbc+k+ZGsURg5JE/GtCPbyPlA5mnfdxTN0XwMI80CX9UcI5cKdLVNzdfiTIF0dIqiFAd1zPIENp8C7vU6iBE/EvJF/QhKVtcod2vzE+h/rpps1FnyNDcPeVlXhJjVmo3JDkko9Gs0M+DBZ/LuRTqPVD+IC6WikNsyjwyfznjoBQ1hn5iKWDQpZaSS2GtsUhzqcRlmmj1hpAt4UZjPpO1E/YBytuut/uApe7tGlPPxphEChcg3/xNa2U21isVbVUsaFbnEKO/mlTBpn+epepqA7f1e0IQ6fN449SN5O7yHPFlZjokTD7ANrv2gEWrQWt3eBvAmXVUMvds7h+ltVwnZEUe4VJ1vd5w3VOLSWemN/A5/iJD9f0Uf2/V2SpA1xSp5S6bFI1canluB4ITDN15OtKpjVxLZ3EfgSxO6Py65ircNL1lWPoZj2346yT6FFoVOo3DX9IJs3xaefzB4oFOVCrBXXXz1TkGvfcGae4ohhfTmag8NxZgLatpDZX06Guf7ojEWHTehhkpevTqcns34Job0oJcj4x3+yWEbhOgy8bgPcsfENDHZafL2xEynGABdLwoohdaLEpIX4IT/VaHzL70oLHE=
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

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: JP Kobryn <jp.kobryn@linux.dev>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/skbuff.h |  2 +-
 mm/page_alloc.c        | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 22eda1d54a0e8..4431b026e429d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3573,7 +3573,7 @@ static inline struct page *__dev_alloc_pages_noprof(gfp_t gfp_mask,
 	 * 3.  If requesting a order 0 page it will not be compound
 	 *     due to the check to see if order has a value in prep_new_page
 	 * 4.  __GFP_MEMALLOC is ignored if __GFP_NOMEMALLOC is set due to
-	 *     code in gfp_to_alloc_flags that should be enforcing this.
+	 *     code in alloc_flags_slowpath() that should be enforcing this.
 	 */
 	gfp_mask |= __GFP_COMP | __GFP_MEMALLOC;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6004fe6583d47..df1345cde301f 100644
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


