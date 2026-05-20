Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1D5CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83C46B00BD; Wed, 20 May 2026 11:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5B86B00BE; Wed, 20 May 2026 11:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABFB6B00BF; Wed, 20 May 2026 11:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 848CF6B00BD
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41B3012035C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:04 +0000 (UTC)
X-FDA: 84788110848.20.DF53DAE
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8340740012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=fxwNmRbC;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajxze11Zz5IYegQgvseCccUEAj4dKmOcGzpk63x4DmE=;
	b=fmm7XiG+ZQgqRIZWO3zOErvePJyejjKCIZv5nTVD7H4ebdToIOCCMLRH3FFVGcA6AFBTan
	3GxF/81QlvwCJD5WVBNrp7j8j5c6cFz8LLWiNwhevJvom90/208oqjNBU1x18lu/BiORRO
	Utr9VWTq6EqrNucQrZiZ3VqMtOKKDuA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289262; a=rsa-sha256;
	cv=none;
	b=O4ZxKVTIrxcB+epQMe64xBVbEvkQY2dOYAQBKX0Prdd3SvXGJOR9tCfZ5jRCHONFvnyeq3
	P62eFnCeDvaddRTwV/r94BKPW9F991im7NgZzCi/U2FtQBI2jd9znGgCGn3iDtR555CsU6
	nHa5iZOCrvFP9lBMSm8oI4EMxEaPqLU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=fxwNmRbC;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ajxze11Zz5IYegQgvseCccUEAj4dKmOcGzpk63x4DmE=; b=fxwNmRbCWQjMvKt01NI6kuNNEr
	tfMKIS8Nw6jGac5gVnCT7SCNoFYDJtXHduKZ98tBxMMhfIxho5XwMbXzm/pbtg+xsuN1+48Xb7iEN
	K3ju23m4SZwCzSQCCDrNAGwT8GxUVgsrDdKeBsFHCgpykGPrqP+jouQhs8qklDBnzZX5w+a4FubmT
	cZve0qDrMd41FQKRGlwPVkVu1b5M13Ljx+8Uq/3F+EuSQKjaWHi8X0R4FTpQOp10fMjwUJid3ZkCs
	TZ/QmFpa1oNX9P2zFuHikZXPBeGgY0Di8jqUYRPDOHTSTB2MAyErPw0Dlgk4u2vDLFEWsf7sfrWzr
	J+SuuOpQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPN-0000000024Q-0sb6;
	Wed, 20 May 2026 11:00:29 -0400
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
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 40/40] mm: page_alloc: SPB tracepoint instrumentation [DO-NOT-MERGE]
Date: Wed, 20 May 2026 10:59:46 -0400
Message-ID: <20260520150018.2491267-41-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8340740012
X-Stat-Signature: 6nprjiqwxep9bx7dd144ode1ee715ncy
X-Rspam-User: 
X-HE-Tag: 1779289261-931774
X-HE-Meta: U2FsdGVkX19/fnp9WuBNnVRM4s20SPxlAsQ2zQVa8WJHKweifH/5glU0Nl3ZoPJBEqQLEx7/MR15dh0OpoO/X9GArCmSBj8SqJ18TOBVFIr8i+X0Z7vtIlmtDDVJpuiOTlZzLEEPzNHoR93FHqRNQ0FbSG4b1jrDMlFADLb/TSAGhWkOyFaliHN3nipbC7J2AlJprTqDdeBIMr9EhMwK7JKkAC8XoxgqRFSAw5G1ra3c3Fn3YUah+Fe9iCSCFkN+Wim0iGMIXzWKEPHlDfESyOexrchDihC9bY6Lzf5LoD7hHaV7vazTr/iCvmhLa+fohaGGrfyhc/4xwEHeiIeTMgpvOzSS/0Wu0Y78cBzxkIE6I+PcCZ4q7ROUkvNftNQDPI8M/dw7PJNfsA6U3C+BdALlNS1x4RVptmyiUJ/J9vevNrA738RABjpnaa4iMLydH8SX9Q/6CptQ15a4O5vCrZacxoufjkUgxicb1mXZTxrWxfOCZKGvuZW1Z7eu+j/OsVf1nPb77zK05cxphCoKMOMWdAPCnwBJHXmu7P/djhQRGZRvKJw0StfyEzYDk40e62ZFz08juZu5g8UW2hDVsfCy3GK6dQyxCjolL7VJTShWh6nkd9msY3LOh0SzaGpYXdHpee+tiFc5DlSmUh4knTYJKg8KRK06ZZtKmcoFAjg3SNlmVi26zexqekI2WV0aBa/cFBaRybFVrJG3afYv3quyVpFcH0USBPWlHqKgO69/P49N7CSxi0WpCXPw0TJj7G4A7rpAoYktrUXIcVpJyB0k+VSWUTxcwTfQQ+QVeYhYXbl2NsCdTER7EkTKnF4Vg8Gzqk380HR0rcWU5KmDy0zhYtD9WqNXJZvMMe0plCBFhTiGBfwOifKYVyUjsuLt8haC0KhPcSeEvFddcCiMKgD7T5wHs6jo8YZeKpH88do08kjcromovlrrqUOESF2dpwhSCrBzp4Y4Qp2q8Ah
 QfPx6509
 ALTpjv07d3d1lMIzabjO17nMbNkXMsrtxFgIoUmNWV8iG4qXFXLVjEA1+00XCdaPKWCxycz2+xvpuxB10jEA1qhQSqr2dir4qXqNHKR68Igtxe+dFH4udTwBlQ5XEZkweqldWGdazjiKu7pyYa7SDiw1VgCQIclcfTMeDGMIsWCExIp1aABG8Q3yWgoK/y96wZn7Pjn4CHstLZ3UerzkHeQmXBEUeor7R7TlJk/Mahpacm0sY9Neln5ZRnTf8ZCKduKF2BAudSo5FoD2b662tmxATifr9PFPKcmJ415hD1386Zwi45CyOZM+rhS4EOY34F82eYx+H2Sd163K9EIitlwatYyGDY1+jS8i+NgGmjXio3pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bundle all SPB anti-fragmentation diagnostic tracepoints into a single
commit so the entire instrumentation can be dropped before upstream
submission.

Tracepoint definitions (include/trace/events/kmem.h):
  - spb_alloc_walk            -- exit point of every __rmqueue_smallest
                                 call with outcome and SPB visit count
  - spb_alloc_fall_through    -- fires when PASS 1/2/2b/2c all failed
                                 and the allocator is about to taint
                                 a fresh clean SPB (PASS 3 / steal)
  - spb_pb_taint              -- every PB_has_<mt> bit transition
  - spb_claim_block_refused   -- try_to_claim_block exits with reason
  - spb_evacuate_for_order_done -- evac phase completion summary
  - spb_alloc_atomic_relax    -- atomic NORETRY relaxation events

Plus enum value extensions:
  - SPB_ALLOC_OUTCOME_PASS_2D = 8 extends the spb_alloc_walk outcome
    set for the cross-MOV borrow path.
  - SPB_ATOMIC_RELAX_NOWARN_LOWER_ORDER = 3 extends the
    spb_alloc_atomic_relax step set for the best-effort high-order
    refusal path.

Tracepoint emission scaffolding and call sites (mm/page_alloc.c):
  - alloc_flags parameter on __rmqueue_smallest (plumbed through all
    callers; passed as 0 by callers without an alloc_flags context),
    consumed by the trace_spb_alloc_walk emit
  - n_spbs_visited counter + SPB_WALK_DONE macro in __rmqueue_smallest
  - bool first/last in __spb_set_has_type / __spb_clear_has_type
  - if-stmt brace + trace_spb_claim_block_refused in try_to_claim_block
    early-return paths (isolate, CMA, zone-boundary, noncompat-cross)
  - struct zone *pref + trace_spb_alloc_atomic_relax in slowpath
    NORETRY/NOFRAG-tainted relaxation
  - phase1_attempts/phase2_attempts counters +
    trace_spb_evacuate_for_order_done
  - trace_printk("SB first unmovable/reclaimable") on first-of-type
    transitions per SPB

Designed for diagnostics only; the behavioral commits in this series
provide the SPB anti-fragmentation machinery, this commit is purely
instrumentation.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/trace/events/kmem.h | 373 ++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             | 154 +++++++++++++--
 2 files changed, 514 insertions(+), 13 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index cd7920c81f85..6ca63908a620 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -266,6 +266,379 @@ TRACE_EVENT(mm_page_pcpu_drain,
 		__entry->order, __entry->migratetype)
 );
 
+/*
+ * spb_pb_taint action encoding.
+ */
+#define SPB_PB_TAINT_ACTION_SET		0   /* set PB_has_<mt> */
+#define SPB_PB_TAINT_ACTION_CLEAR	1   /* clear PB_has_<mt> */
+
+#define show_spb_pb_taint_action(a)				\
+	__print_symbolic(a,					\
+		{ SPB_PB_TAINT_ACTION_SET,	"SET"   },	\
+		{ SPB_PB_TAINT_ACTION_CLEAR,	"CLEAR" })
+
+/*
+ * Per-call tracepoint at every PB_has_<migratetype> bit transition.
+ * Distinct from the existing trace_printk lines (which only fire on
+ * the FIRST 0->1 transition per (SPB, migratetype)) — this fires on
+ * EVERY successful set/clear, and includes a flag for whether this
+ * call also caused a 0<->1 transition at the SPB-level counter
+ * (i.e., is_first_or_last for this (SPB, mt) combination).
+ *
+ * Use to answer "who is painting/clearing PB_has bits and at what
+ * rate?" — most useful when investigating runaway tainting or when
+ * Stage 1 / sync evac should be clearing bits but isn't.
+ *
+ * High volume: bounded by the rate of PB_has_* bit changes, which
+ * is typically per-allocation. Static-key gated to zero overhead
+ * when detached.
+ */
+TRACE_EVENT(spb_pb_taint,
+
+	TP_PROTO(struct page *page, int migratetype, int action,
+		 bool is_first_or_last),
+
+	TP_ARGS(page, migratetype, action, is_first_or_last),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	pfn			)
+		__field(	int,		migratetype		)
+		__field(	int,		action			)
+		__field(	bool,		is_first_or_last	)
+	),
+
+	TP_fast_assign(
+		__entry->pfn			= page_to_pfn(page);
+		__entry->migratetype		= migratetype;
+		__entry->action			= action;
+		__entry->is_first_or_last	= is_first_or_last;
+	),
+
+	TP_printk("pfn=0x%lx mt=%d action=%s first_or_last=%d",
+		__entry->pfn,
+		__entry->migratetype,
+		show_spb_pb_taint_action(__entry->action),
+		__entry->is_first_or_last)
+);
+
+/*
+ * spb_claim_block_refused reason encoding.
+ */
+#define SPB_CLAIM_REFUSED_ISOLATE		0
+#define SPB_CLAIM_REFUSED_CMA			1
+#define SPB_CLAIM_REFUSED_ZONE_BOUNDARY		2
+#define SPB_CLAIM_REFUSED_CROSS_TYPE_NOT_FREE	3
+#define SPB_CLAIM_REFUSED_INSUFFICIENT_COMPAT	4
+
+#define show_spb_claim_refused_reason(r)				\
+	__print_symbolic(r,						\
+		{ SPB_CLAIM_REFUSED_ISOLATE,         "ISOLATE"        },	\
+		{ SPB_CLAIM_REFUSED_CMA,             "CMA"            },	\
+		{ SPB_CLAIM_REFUSED_ZONE_BOUNDARY,   "ZONE_BOUNDARY"  },	\
+		{ SPB_CLAIM_REFUSED_CROSS_TYPE_NOT_FREE, "CROSS_TYPE_NOT_FREE" }, \
+		{ SPB_CLAIM_REFUSED_INSUFFICIENT_COMPAT, "INSUFFICIENT_COMPAT" })
+
+/*
+ * Per-refusal tracepoint inside try_to_claim_block. The function can
+ * fail for several reasons: pageblock isolated for evacuation, CMA
+ * pageblock, zone boundary straddle, cross-type relabel that requires
+ * a fully-free PB, or the heuristic threshold that says too few pages
+ * in the block are compatible. Visibility into WHICH reason fires how
+ * often informs Stage 4 design (e.g., is the heuristic gate the
+ * dominant cause of allocations spilling to clean SPBs?).
+ *
+ * Volume: bounded by the rate of fallback attempts, which is rare
+ * compared to total allocations.
+ */
+TRACE_EVENT(spb_claim_block_refused,
+
+	TP_PROTO(struct page *page, int start_type, int block_type,
+		 int reason),
+
+	TP_ARGS(page, start_type, block_type, reason),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	pfn		)
+		__field(	int,		start_type	)
+		__field(	int,		block_type	)
+		__field(	int,		reason		)
+	),
+
+	TP_fast_assign(
+		__entry->pfn		= page_to_pfn(page);
+		__entry->start_type	= start_type;
+		__entry->block_type	= block_type;
+		__entry->reason		= reason;
+	),
+
+	TP_printk("pfn=0x%lx start_mt=%d block_mt=%d reason=%s",
+		__entry->pfn,
+		__entry->start_type,
+		__entry->block_type,
+		show_spb_claim_refused_reason(__entry->reason))
+);
+
+/*
+ * Per-call tracepoint at the exit of spb_evacuate_for_order, the
+ * synchronous slowpath evacuator called from
+ * __alloc_pages_direct_compact. Captures how many evacuate_pageblock
+ * calls were attempted in each phase:
+ *   - Phase 1: coalesce within existing same-mt pageblocks
+ *   - Phase 2: evacuate whole movable pageblocks to create free PBs
+ *
+ * Together with pgmigrate_success/pgmigrate_fail counter deltas, this
+ * lets us answer "is slowpath sync evacuation actually creating
+ * useful free pageblocks, or are the migrations EAGAINing on busy
+ * ebs?" — directly informs whether the per-call budget caps need
+ * tuning.
+ *
+ * Low volume: ~one event per direct-compact slowpath visit.
+ */
+TRACE_EVENT(spb_evacuate_for_order_done,
+
+	TP_PROTO(struct zone *zone, unsigned int order, int migratetype,
+		 unsigned int phase1_attempts, unsigned int phase2_attempts,
+		 bool did_evacuate),
+
+	TP_ARGS(zone, order, migratetype, phase1_attempts,
+		phase2_attempts, did_evacuate),
+
+	TP_STRUCT__entry(
+		__string(	name,			zone->name	)
+		__field(	unsigned int,		order		)
+		__field(	int,			migratetype	)
+		__field(	unsigned int,		phase1_attempts	)
+		__field(	unsigned int,		phase2_attempts	)
+		__field(	bool,			did_evacuate	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name);
+		__entry->order			= order;
+		__entry->migratetype		= migratetype;
+		__entry->phase1_attempts	= phase1_attempts;
+		__entry->phase2_attempts	= phase2_attempts;
+		__entry->did_evacuate		= did_evacuate;
+	),
+
+	TP_printk("zone=%s order=%u mt=%d p1=%u p2=%u did_evac=%d",
+		__get_str(name),
+		__entry->order,
+		__entry->migratetype,
+		__entry->phase1_attempts,
+		__entry->phase2_attempts,
+		__entry->did_evacuate)
+);
+
+/*
+ * spb_alloc_atomic_relax step encoding.
+ */
+#define SPB_ATOMIC_RELAX_NORETRY_SKIP	0   /* NORETRY caller — return NULL */
+#define SPB_ATOMIC_RELAX_ADD_TAINTED_OK	1   /* add ALLOC_NOFRAG_TAINTED_OK retry */
+#define SPB_ATOMIC_RELAX_DROP_NOFRAGMENT 2  /* drop ALLOC_NOFRAGMENT retry */
+#define SPB_ATOMIC_RELAX_NOWARN_LOWER_ORDER 3  /* NOWARN best-effort + tainted has lower order */
+
+#define show_spb_atomic_relax_step(s)					\
+	__print_symbolic(s,						\
+		{ SPB_ATOMIC_RELAX_NORETRY_SKIP,        "NORETRY_SKIP"    }, \
+		{ SPB_ATOMIC_RELAX_ADD_TAINTED_OK,      "ADD_TAINTED_OK"  }, \
+		{ SPB_ATOMIC_RELAX_DROP_NOFRAGMENT,     "DROP_NOFRAGMENT" }, \
+		{ SPB_ATOMIC_RELAX_NOWARN_LOWER_ORDER,  "NOWARN_LOWER_ORDER" })
+
+/*
+ * Per-event tracepoint at each atomic-allocation NOFRAGMENT-relaxation
+ * step in get_page_from_freelist. Captures NORETRY-skip exits (caller
+ * had a fallback so we returned NULL), and the two relaxation retries
+ * (add NOFRAG_TAINTED_OK; drop NOFRAGMENT entirely).
+ *
+ * Use to quantify how often each step fires under the workload.
+ * Validates the NORETRY-skip change is paying off.
+ *
+ * Volume: only on atomic allocs that exhaust the tainted pool —
+ * typically rare on a healthy system.
+ */
+TRACE_EVENT(spb_alloc_atomic_relax,
+
+	TP_PROTO(struct zone *zone, unsigned int order, int migratetype,
+		 gfp_t gfp_mask, int step),
+
+	TP_ARGS(zone, order, migratetype, gfp_mask, step),
+
+	TP_STRUCT__entry(
+		__string(	name,			zone->name	)
+		__field(	unsigned int,		order		)
+		__field(	int,			migratetype	)
+		__field(	unsigned long,		gfp_mask	)
+		__field(	int,			step		)
+	),
+
+	TP_fast_assign(
+		__assign_str(name);
+		__entry->order		= order;
+		__entry->migratetype	= migratetype;
+		__entry->gfp_mask	= (__force unsigned long)gfp_mask;
+		__entry->step		= step;
+	),
+
+	TP_printk("zone=%s order=%u mt=%d gfp=%s step=%s",
+		__get_str(name),
+		__entry->order,
+		__entry->migratetype,
+		show_gfp_flags(__entry->gfp_mask),
+		show_spb_atomic_relax_step(__entry->step))
+);
+
+/*
+ * spb_alloc_walk outcome encoding. SUCCESS_* values name which Pass
+ * inside __rmqueue_smallest produced the page. NO_PAGE means the
+ * function returned NULL (all passes failed).
+ */
+#define SPB_ALLOC_OUTCOME_NO_PAGE	0
+#define SPB_ALLOC_OUTCOME_PASS_1	1   /* preferred SPBs */
+#define SPB_ALLOC_OUTCOME_PASS_2	2   /* claim_whole_block from tainted */
+#define SPB_ALLOC_OUTCOME_PASS_2B	3   /* sub-PB claim from tainted */
+#define SPB_ALLOC_OUTCOME_PASS_2C	4   /* cross-non-movable borrow */
+#define SPB_ALLOC_OUTCOME_PASS_3	5   /* empty SPB (taints fresh SPB) */
+#define SPB_ALLOC_OUTCOME_PASS_4	6   /* movable falls back to tainted */
+#define SPB_ALLOC_OUTCOME_ZONE_FALLBACK	7  /* zone-level free_area (hotplug edge) */
+#define SPB_ALLOC_OUTCOME_PASS_2D	8   /* cross-MOV borrow within tainted */
+
+#define show_spb_alloc_outcome(o)				\
+	__print_symbolic(o,					\
+		{ SPB_ALLOC_OUTCOME_NO_PAGE,	"NO_PAGE"  },	\
+		{ SPB_ALLOC_OUTCOME_PASS_1,	"PASS_1"   },	\
+		{ SPB_ALLOC_OUTCOME_PASS_2,	"PASS_2"   },	\
+		{ SPB_ALLOC_OUTCOME_PASS_2B,	"PASS_2B"  },	\
+		{ SPB_ALLOC_OUTCOME_PASS_2C,	"PASS_2C"  },	\
+		{ SPB_ALLOC_OUTCOME_PASS_2D,	"PASS_2D"  },	\
+		{ SPB_ALLOC_OUTCOME_PASS_3,	"PASS_3"   },	\
+		{ SPB_ALLOC_OUTCOME_PASS_4,	"PASS_4"   },	\
+		{ SPB_ALLOC_OUTCOME_ZONE_FALLBACK, "ZONE_FB" })
+
+/*
+ * Per-allocation tracepoint at every exit of __rmqueue_smallest.
+ * Captures how many SPBs were walked before the allocation was
+ * satisfied (or determined unsatisfiable).
+ *
+ * Use this to characterize the cost of the linear spb_lists walk:
+ *   - typical walk depth per allocation
+ *   - per-(order, migratetype) walk-depth distribution
+ *   - whether some workloads see pathologically long walks
+ *
+ * High-volume tracepoint (~1 emission per allocation, ~hundreds of
+ * thousands per second on busy systems). The static-key gating in
+ * the caller keeps cost at ~1 ns when the tracepoint is detached.
+ * When attached, expect ~100 ns/event (~10% CPU on a saturated
+ * allocator). Filter by outcome to reduce volume:
+ *   tracepoint:kmem:spb_alloc_walk /args->n_spbs_visited > 5/ { ... }
+ */
+TRACE_EVENT(spb_alloc_walk,
+
+	TP_PROTO(struct zone *zone, unsigned int order, int migratetype,
+		 unsigned int alloc_flags, int outcome,
+		 unsigned int n_spbs_visited),
+
+	TP_ARGS(zone, order, migratetype, alloc_flags, outcome,
+		n_spbs_visited),
+
+	TP_STRUCT__entry(
+		__string(	name,			zone->name	)
+		__field(	unsigned int,		order		)
+		__field(	int,			migratetype	)
+		__field(	unsigned int,		alloc_flags	)
+		__field(	int,			outcome		)
+		__field(	unsigned int,		n_spbs_visited	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name);
+		__entry->order			= order;
+		__entry->migratetype		= migratetype;
+		__entry->alloc_flags		= alloc_flags;
+		__entry->outcome		= outcome;
+		__entry->n_spbs_visited		= n_spbs_visited;
+	),
+
+	TP_printk("zone=%s order=%u mt=%d alloc_flags=0x%x outcome=%s n_spbs_visited=%u",
+		__get_str(name),
+		__entry->order,
+		__entry->migratetype,
+		__entry->alloc_flags,
+		show_spb_alloc_outcome(__entry->outcome),
+		__entry->n_spbs_visited)
+);
+
+/*
+ * Diagnostic tracepoint fired when __rmqueue_smallest's tainted-SPB
+ * passes (Pass 1/2/2b/2c) all failed and the allocator is about to
+ * fall through to Pass 3 (which may taint a clean SPB) or to the
+ * fallback paths in __rmqueue_claim/__rmqueue_steal.
+ *
+ * Captures enough state to answer "why didn't an existing tainted SPB
+ * absorb this allocation?":
+ *   - n_tainted_with_buddy: count of tainted SPBs whose free_area at
+ *     the requested order has a non-empty free_list of the requested
+ *     migratetype. >0 means buddies WERE available — Pass 1 missed
+ *     them somehow. 0 means the tainted pool genuinely had nothing at
+ *     the right (order, mt).
+ *   - walk flags: snapshot of struct spb_tainted_walk gathered during
+ *     Pass 1's walk. saw_free_pages = any tainted SPB had any free
+ *     pages anywhere; saw_free_pb = any tainted SPB had a wholly-free
+ *     pageblock; saw_below_reserve = any tainted SPB was at or below
+ *     its reserve threshold.
+ *
+ * Fires once per fall-through event, so volume scales with the rate
+ * at which clean-SPB tainting becomes a possibility — typically rare
+ * once the workload reaches steady state.
+ */
+TRACE_EVENT(spb_alloc_fall_through,
+
+	TP_PROTO(struct zone *zone, unsigned int order, int migratetype,
+		 unsigned int alloc_flags,
+		 unsigned int n_tainted, unsigned int n_tainted_with_buddy,
+		 bool saw_free_pages, bool saw_free_pb,
+		 bool saw_below_reserve),
+
+	TP_ARGS(zone, order, migratetype, alloc_flags,
+		n_tainted, n_tainted_with_buddy,
+		saw_free_pages, saw_free_pb, saw_below_reserve),
+
+	TP_STRUCT__entry(
+		__string(	name,			zone->name		)
+		__field(	unsigned int,		order			)
+		__field(	int,			migratetype		)
+		__field(	unsigned int,		alloc_flags		)
+		__field(	unsigned int,		n_tainted		)
+		__field(	unsigned int,		n_tainted_with_buddy	)
+		__field(	bool,			saw_free_pages		)
+		__field(	bool,			saw_free_pb		)
+		__field(	bool,			saw_below_reserve	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name);
+		__entry->order			= order;
+		__entry->migratetype		= migratetype;
+		__entry->alloc_flags		= alloc_flags;
+		__entry->n_tainted		= n_tainted;
+		__entry->n_tainted_with_buddy	= n_tainted_with_buddy;
+		__entry->saw_free_pages		= saw_free_pages;
+		__entry->saw_free_pb		= saw_free_pb;
+		__entry->saw_below_reserve	= saw_below_reserve;
+	),
+
+	TP_printk("zone=%s order=%u mt=%d alloc_flags=0x%x n_tainted=%u n_tainted_with_buddy=%u walk=[fp=%d fpb=%d below=%d]",
+		__get_str(name),
+		__entry->order,
+		__entry->migratetype,
+		__entry->alloc_flags,
+		__entry->n_tainted,
+		__entry->n_tainted_with_buddy,
+		__entry->saw_free_pages,
+		__entry->saw_free_pb,
+		__entry->saw_below_reserve)
+);
+
 TRACE_EVENT(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 62edbdf0c3f3..a6cb09273347 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -522,18 +522,39 @@ static void __spb_set_has_type(struct page *page, int migratetype)
 		return;
 
 	if (!get_pfnblock_bit(page, pfn, bit)) {
+		bool first = false;
+
 		set_pfnblock_bit(page, pfn, bit);
 		switch (bit) {
 		case PB_has_unmovable:
 			sb->nr_unmovable++;
+			first = (sb->nr_unmovable == 1);
+			if (first)
+				trace_printk("SB first unmovable: zone=%s sb=%lu pfn=%lu mt=%d rsv=%u mov=%u recl=%u free=%u\n",
+					     sb->zone->name,
+					     (unsigned long)(sb - sb->zone->superpageblocks),
+					     pfn, migratetype,
+					     sb->nr_reserved, sb->nr_movable,
+					     sb->nr_reclaimable, sb->nr_free);
 			break;
 		case PB_has_reclaimable:
 			sb->nr_reclaimable++;
+			first = (sb->nr_reclaimable == 1);
+			if (first)
+				trace_printk("SB first reclaimable: zone=%s sb=%lu pfn=%lu mt=%d rsv=%u mov=%u unmov=%u free=%u\n",
+					     sb->zone->name,
+					     (unsigned long)(sb - sb->zone->superpageblocks),
+					     pfn, migratetype,
+					     sb->nr_reserved, sb->nr_movable,
+					     sb->nr_unmovable, sb->nr_free);
 			break;
 		case PB_has_movable:
 			sb->nr_movable++;
+			first = (sb->nr_movable == 1);
 			break;
 		}
+		trace_spb_pb_taint(page, migratetype,
+				   SPB_PB_TAINT_ACTION_SET, first);
 		spb_debug_check(sb, "__spb_set_has_type");
 	}
 }
@@ -557,21 +578,28 @@ static void __spb_clear_has_type(struct page *page, int migratetype)
 		return;
 
 	if (get_pfnblock_bit(page, pfn, bit)) {
+		bool last = false;
+
 		clear_pfnblock_bit(page, pfn, bit);
 		switch (bit) {
 		case PB_has_unmovable:
 			if (sb->nr_unmovable)
 				sb->nr_unmovable--;
+			last = (sb->nr_unmovable == 0);
 			break;
 		case PB_has_reclaimable:
 			if (sb->nr_reclaimable)
 				sb->nr_reclaimable--;
+			last = (sb->nr_reclaimable == 0);
 			break;
 		case PB_has_movable:
 			if (sb->nr_movable)
 				sb->nr_movable--;
+			last = (sb->nr_movable == 0);
 			break;
 		}
+		trace_spb_pb_taint(page, migratetype,
+				   SPB_PB_TAINT_ACTION_CLEAR, last);
 		spb_debug_check(sb, "__spb_clear_has_type");
 	}
 }
@@ -3037,7 +3065,8 @@ static struct page *try_alloc_from_sb_pass1(struct zone *zone,
 
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
-				int migratetype, struct spb_tainted_walk *walk)
+				int migratetype, unsigned int alloc_flags,
+				struct spb_tainted_walk *walk)
 {
 	unsigned int current_order;
 	struct free_area *area;
@@ -3045,6 +3074,17 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	int full;
 	struct superpageblock *sb;
 	int opposite_mt;
+	/*
+	 * Diagnostic counter for the spb_alloc_walk tracepoint. Counts how
+	 * many SPBs were visited (across all Passes) before this allocation
+	 * succeeded or fell through. Used to characterize the cost of the
+	 * linear spb_lists walk and identify pathological cases.
+	 */
+	unsigned int n_spbs_visited = 0;
+
+#define SPB_WALK_DONE(_outcome) \
+	trace_spb_alloc_walk(zone, order, migratetype, alloc_flags, \
+			     (_outcome), n_spbs_visited)
 	/*
 	 * Category search order: 2 passes.
 	 * Movable: clean first, then tainted (pack into clean SBs).
@@ -3088,6 +3128,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				    migratetype,
 				    pcp_allowed_order(order) &&
 				    migratetype < MIGRATE_PCPTYPES);
+				SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_1);
 				return page;
 			}
 		}
@@ -3103,6 +3144,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				    migratetype,
 				    pcp_allowed_order(order) &&
 				    migratetype < MIGRATE_PCPTYPES);
+				SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_1);
 				return page;
 			}
 		}
@@ -3139,6 +3181,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
 		list_for_each_entry(sb,
 			&zone->spb_lists[cat][full], list) {
+			n_spbs_visited++;
 			/*
 			 * Snapshot tainted-SPB capacity before the
 			 * nr_free_pages skip: an SPB with a free pageblock
@@ -3173,6 +3216,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page, order, migratetype,
 					pcp_allowed_order(order) &&
 					migratetype < MIGRATE_PCPTYPES);
+				SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_1);
 				if (migratetype < MIGRATE_PCPTYPES) {
 					struct spb_warm_hint_slot *slot;
 
@@ -3203,6 +3247,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_1);
 					if (migratetype < MIGRATE_PCPTYPES) {
 						struct spb_warm_hint_slot *slot;
 
@@ -3234,6 +3279,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
 			list_for_each_entry(sb,
 				&zone->spb_lists[SB_TAINTED][full], list) {
+				n_spbs_visited++;
 				if (!sb->nr_free)
 					continue;
 				for (current_order = max_t(unsigned int,
@@ -3258,6 +3304,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_2);
 					return page;
 				}
 			}
@@ -3268,6 +3315,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				&zone->spb_lists[SB_TAINTED][full], list) {
 				int co;
 
+				n_spbs_visited++;
 				if (!sb->nr_free_pages)
 					continue;
 				for (co = min_t(int, pageblock_order - 1,
@@ -3296,6 +3344,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_2B);
 					return page;
 				}
 			}
@@ -3353,6 +3402,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					&zone->spb_lists[SB_TAINTED][full], list) {
 					int co;
 
+					n_spbs_visited++;
 					if (!sb->nr_free_pages)
 						continue;
 					for (co = min_t(int, pageblock_order - 1,
@@ -3380,6 +3430,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
 							migratetype < MIGRATE_PCPTYPES);
+						SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_2C);
 						return page;
 					}
 				}
@@ -3425,6 +3476,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					&zone->spb_lists[SB_TAINTED][full], list) {
 					int co;
 
+					n_spbs_visited++;
 					if (!sb->nr_free_pages)
 						continue;
 					for (co = min_t(int, pageblock_order - 1,
@@ -3452,6 +3504,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
 							migratetype < MIGRATE_PCPTYPES);
+						SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_2D);
 						return page;
 					}
 				}
@@ -3494,8 +3547,40 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		}
 	}
 
+	/*
+	 * Diagnostic: capture per-fall-through state so we can answer
+	 * "why didn't an existing tainted SPB absorb this allocation?".
+	 * The count loop walks the tainted-SPB lists looking for any SPB
+	 * with a free buddy at the requested (order, migratetype). >0
+	 * means buddies were available -- Pass 1 missed them. 0 means
+	 * the tainted pool genuinely had nothing usable. Loop is bounded
+	 * by the number of tainted SPBs and runs only on the slow path
+	 * (this is the fall-through to Pass 3/Pass 4). Skipped if the
+	 * tracepoint is not active so there is zero cost in production.
+	 */
+	if (walk && trace_spb_alloc_fall_through_enabled()) {
+		unsigned int n_tainted = 0, n_with_buddy = 0;
+
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+				&zone->spb_lists[SB_TAINTED][full], list) {
+				n_tainted++;
+				if (!list_empty(
+				    &sb->free_area[order].free_list[migratetype]))
+					n_with_buddy++;
+			}
+		}
+		trace_spb_alloc_fall_through(zone, order, migratetype,
+					     alloc_flags,
+					     n_tainted, n_with_buddy,
+					     walk->saw_free_pages,
+					     walk->saw_free_pb,
+					     walk->saw_below_reserve);
+	}
+
 	/* Pass 3: whole pageblock from empty superpageblocks */
 	list_for_each_entry(sb, &zone->spb_empty, list) {
+		n_spbs_visited++;
 		if (!sb->nr_free_pages)
 			continue;
 		for (current_order = max(order, pageblock_order);
@@ -3511,6 +3596,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				migratetype,
 				pcp_allowed_order(order) &&
 				migratetype < MIGRATE_PCPTYPES);
+			SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_3);
 			return page;
 		}
 	}
@@ -3529,6 +3615,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
 			list_for_each_entry(sb,
 				&zone->spb_lists[cat][full], list) {
+				n_spbs_visited++;
 				if (!sb->nr_free_pages)
 					continue;
 				/*
@@ -3553,6 +3640,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_4);
 					return page;
 				}
 			}
@@ -3577,10 +3665,13 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		trace_mm_page_alloc_zone_locked(page, order, migratetype,
 				pcp_allowed_order(order) &&
 				migratetype < MIGRATE_PCPTYPES);
+		SPB_WALK_DONE(SPB_ALLOC_OUTCOME_ZONE_FALLBACK);
 		return page;
 	}
 
+	SPB_WALK_DONE(SPB_ALLOC_OUTCOME_NO_PAGE);
 	return NULL;
+#undef SPB_WALK_DONE
 }
 
 
@@ -3617,7 +3708,7 @@ static inline bool noncompatible_cross_type(int start_type, int fallback_type)
 static __always_inline struct page *__rmqueue_cma_fallback(struct zone *zone,
 					unsigned int order)
 {
-	return __rmqueue_smallest(zone, order, MIGRATE_CMA, NULL);
+	return __rmqueue_smallest(zone, order, MIGRATE_CMA, 0, NULL);
 }
 #else
 static inline struct page *__rmqueue_cma_fallback(struct zone *zone,
@@ -3999,8 +4090,11 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	 * Don't steal from pageblocks that are isolated for
 	 * evacuation -- that would undo the work in progress.
 	 */
-	if (get_pageblock_isolate(page))
+	if (get_pageblock_isolate(page)) {
+		trace_spb_claim_block_refused(page, start_type, block_type,
+					      SPB_CLAIM_REFUSED_ISOLATE);
 		return NULL;
+	}
 
 	/*
 	 * Never steal from CMA pageblocks.  CMA pages freed through
@@ -4009,8 +4103,11 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	 * fallback search.  Stealing would corrupt CMA by changing
 	 * the pageblock type away from MIGRATE_CMA.
 	 */
-	if (is_migrate_cma(get_pageblock_migratetype(page)))
+	if (is_migrate_cma(get_pageblock_migratetype(page))) {
+		trace_spb_claim_block_refused(page, start_type, block_type,
+					      SPB_CLAIM_REFUSED_CMA);
 		return NULL;
+	}
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order)
@@ -4019,8 +4116,11 @@ try_to_claim_block(struct zone *zone, struct page *page,
 
 	/* moving whole block can fail due to zone boundary conditions */
 	if (!prep_move_freepages_block(zone, page, &start_pfn, &free_pages,
-				       &movable_pages))
+				       &movable_pages)) {
+		trace_spb_claim_block_refused(page, start_type, block_type,
+					      SPB_CLAIM_REFUSED_ZONE_BOUNDARY);
 		return NULL;
+	}
 
 	/*
 	 * Determine how many pages are compatible with our allocation.
@@ -4059,11 +4159,17 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	 * the SPB is tainted.
 	 */
 	if (noncompatible_cross_type(start_type, block_type)) {
-		if (free_pages != pageblock_nr_pages)
+		if (free_pages != pageblock_nr_pages) {
+			trace_spb_claim_block_refused(page, start_type,
+				block_type,
+				SPB_CLAIM_REFUSED_CROSS_TYPE_NOT_FREE);
 			return NULL;
+		}
 	} else if (!from_tainted_spb &&
 		   free_pages + alike_pages < (1 << (pageblock_order-1)) &&
 		   !page_group_by_mobility_disabled) {
+		trace_spb_claim_block_refused(page, start_type, block_type,
+			SPB_CLAIM_REFUSED_INSUFFICIENT_COMPAT);
 		return NULL;
 	}
 
@@ -4092,7 +4198,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (sb)
 		spb_update_list(sb);
 #endif
-	return __rmqueue_smallest(zone, order, start_type, NULL);
+	return __rmqueue_smallest(zone, order, start_type, 0, NULL);
 }
 
 /*
@@ -4493,7 +4599,8 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	 */
 	switch (*mode) {
 	case RMQUEUE_NORMAL:
-		page = __rmqueue_smallest(zone, order, migratetype, walkp);
+		page = __rmqueue_smallest(zone, order, migratetype,
+					  alloc_flags, walkp);
 		if (page)
 			return page;
 		/*
@@ -5632,7 +5739,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 		}
 		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order,
-						  MIGRATE_HIGHATOMIC, NULL);
+						  MIGRATE_HIGHATOMIC,
+						  alloc_flags, NULL);
 		if (!page) {
 			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 
@@ -5647,7 +5755,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
 				page = __rmqueue_smallest(zone, order,
 							  MIGRATE_HIGHATOMIC,
-							  NULL);
+							  alloc_flags, NULL);
 
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
@@ -6383,8 +6491,12 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	    !(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		struct zone *pref = zonelist_zone(ac->preferred_zoneref);
 
-		if (gfp_mask & __GFP_NORETRY)
+		if (gfp_mask & __GFP_NORETRY) {
+			trace_spb_alloc_atomic_relax(pref, order,
+				ac->migratetype, gfp_mask,
+				SPB_ATOMIC_RELAX_NORETRY_SKIP);
 			return NULL;
+		}
 
 		/*
 		 * Best-effort high-order callers convention: stripping
@@ -6407,13 +6519,22 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (order > 0 && (gfp_mask & __GFP_NOWARN) &&
 		    !(gfp_mask & __GFP_NOFAIL) &&
 		    spb_tainted_can_serve_smaller(pref, order,
-						  ac->migratetype))
+						  ac->migratetype)) {
+			trace_spb_alloc_atomic_relax(pref, order,
+				ac->migratetype, gfp_mask,
+				SPB_ATOMIC_RELAX_NOWARN_LOWER_ORDER);
 			return NULL;
-
+		}
 		if (!(alloc_flags & ALLOC_NOFRAG_TAINTED_OK)) {
+			trace_spb_alloc_atomic_relax(pref, order,
+				ac->migratetype, gfp_mask,
+				SPB_ATOMIC_RELAX_ADD_TAINTED_OK);
 			alloc_flags |= ALLOC_NOFRAG_TAINTED_OK;
 			goto retry;
 		}
+		trace_spb_alloc_atomic_relax(pref, order,
+			ac->migratetype, gfp_mask,
+			SPB_ATOMIC_RELAX_DROP_NOFRAGMENT);
 		alloc_flags &= ~(ALLOC_NOFRAGMENT | ALLOC_NOFRAG_TAINTED_OK);
 		goto retry;
 	}
@@ -10317,6 +10438,13 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 	 */
 	queue_spb_slab_shrink(zone);
 
+	/*
+	 * The tracepoint signature retains phase1_attempts / phase2_attempts
+	 * for ABI continuity with existing observers; report the merged total
+	 * in phase1_attempts and 0 in phase2_attempts.
+	 */
+	trace_spb_evacuate_for_order_done(zone, order, migratetype,
+			attempts, 0, did_evacuate);
 	return did_evacuate;
 }
 #endif /* CONFIG_COMPACTION */
-- 
2.54.0


