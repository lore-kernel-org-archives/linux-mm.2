Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6153CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DC036B00BB; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DF56B00B5; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469546B00B8; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF2D6B00B5
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7BE31601B2
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:09 +0000 (UTC)
X-FDA: 84716346498.21.0D7BB27
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id E46FF18000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=M14Pyf3P;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJYVXXV0Cd/4I6mWESvmrVOpZw+FD6CQA+n9e263Onc=;
	b=8dXZA38GF9GiO8p7ScshZYE2Jun0XfBF5Xg0o6I4RV+QLVYGfQktaUBqre+kfKdLiYrYNb
	F59YO3HmsCxVHcvp5WUmLz9oS5KzgF26JkNQeM7YyOzyr83BMkgZChOrQ/QyVo9RT1uh5Z
	LhpCKM2WkkZLAbBbxJhJNYGdBOmEExI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580588; a=rsa-sha256;
	cv=none;
	b=JZBNpXtHbmKz0dXMpwFoo00SIfk32YHvrcW+hI8E0V7jCW4mRHt/vBi4hOj9PSyFERd3rk
	5jmPW9noWFUgpqzn32634gxPynVCoYTJLxbdOjQqkKe9UpyYp/7uQsQaYXob3mYUoLp9Bt
	WT3Os5OtbV8mhPXTwp4hyXMQPFwVPO8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=M14Pyf3P;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CJYVXXV0Cd/4I6mWESvmrVOpZw+FD6CQA+n9e263Onc=; b=M14Pyf3PtfsklyOmDr0dqZW0Ni
	DCpg8tjzSzwgnZ6cyhlXd2PR8ZRHBzagJVThPYYXpYcVgX+UokSWz7QFY9zsuThQAokWrIxiOIdqj
	Lzfi3p5ffanvBx1cByCKNYQ+BiztuRmSqIwdzpU+Do9abjEILxx9m1xG5rWKtOKGnGeOiIRe9nGu0
	56cV4qMtcAncYPeORlSebYKmjN2pUTiIL9mJm6sBsV1B5kOibUWDEk9w+zt6Zz1Ab8UZd5cGwgx5w
	Ue2+AnZeC2AUt4DNNg0SUbH2rm2xDPUfVHGeb3fZ4bzEtoOpqR+rIRf6MVX1EtwZt/Mhu1gt/rHm6
	U02Q92ig==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-2IcI;
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
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 44/45] mm: page_alloc: SPB tracepoint instrumentation [DROP-FOR-UPSTREAM]
Date: Thu, 30 Apr 2026 16:21:13 -0400
Message-ID: <20260430202233.111010-45-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E46FF18000B
X-Stat-Signature: 8akrmpyuyzkn8gxth7f19of53ea7dpjk
X-Rspam-User: 
X-HE-Tag: 1777580587-92918
X-HE-Meta: U2FsdGVkX19SrrQM8jSXkJm/TA+NVGxz9WPx4xny5PAw0oClmilJfEEnKbIsQml/X1h6JO1I1I9Kzh6UMzzWTSi3sTI59Tl04Rr5tz+Jl5mNxjWaKp7Vb//hye1aiz4aXk9wpf2Eqf2GaBP7ofNVsx12tuuwjJ8AcL1rOwhM7EjdxN8befrg2TGEB9Gsw1UNVRz597yMebODfSoT+1jKLIIhrWsOsfVzzdPmb313zcCEZCb8YWWlPnxx03sDyL2J1leAMfOB0xqsQr36braSBZFSqe4SiNUNyy+1mtWAkDO4N3HugB3eJmsKnLTB7Gk27lHUCiOc1X852Mm9RuRm3CV8hpAv2g432+6aBRTVDgGr3V2NXnzYLEe0f8laKb5jEgaLAwi4paWdP1+7Y3sKveGZ9JQkO+dRd2Wz3kygpDq+LKFoe83WFjV3xj8ZrUuTF06UrB4T5PX1DeJT36fcfU8xps/5twYt+0nBGcdElw9Erdd+lo2XMFYNr0Lh5sbZLBzf3qVVkFCNNdfdb4ZBUrwvg1sFw1LyImzLKWHjBjgFnRlHl3JthynU5vP6M9ZHSFT0Kw5z2UkQrYl2plQqx+p6b1DmEYDSJjM5LC8DL5+8AlpWJpRhhn2BrT+jKb9WoGCHLGHoJbbjVq+8ZRl/qBdKC8cxYQCU7828cgSTmdFvenJhA488DPM+KBLtxRgCqcwLD0Iq414jH/PoGbqGx/wUaSnIdf8UdERIRdlTZ7ByySjET1QzTEQbgF5Zx6MOcgIlGR5QH4rVh5tyklEoaE2gpOh0ULNrn+cTmHpoonjM3sClD0I5qdZAKZ/e6MwRMKNvfAqoywpsQkLjXxYs9I6dbivEFJlxtyqcSrtnxzLxx2FouHkfjC19M/oURyAyc8jbg0fYTXBmCn8qdlmVhQZPwZgmTrhZoZQk0NoSClsb11FOvWXXAD8uLk0GeQUXS7QTXAhKYhdEf+WpVYc
 A5BGpWpa
 4Bv2iuYoDuz0IqgW8Bx47vYB1tKOIMBYoQwCgJQBGva9bxn3H1Nmt8kmMvM1Vt7+vEbzPRBCIXU6LkreaJBK7gMN0BUoIDmDAnwzAFDHsADkBIt/c6Yc00jckNRySBh5AE7axWomjqgkeNwchrBGaSsZMrvEv2kKlSsMAZZgPdzQ8Su+cac1cZEK0lobKgmXsoAlWvxRPYQtxnGMAI0FePC6UoBIfRc5ijGg53A24OXsgH05tBHEz0uSlqHf0zA4ANVkwc5xsKoSOjejWJs0Ld8LOu/BWclU390urOiGpb57Lz2QHnoW/qxbO+BbxuF93Fki1fTdIjPpfHW4PTBImI/IcQKOaIznd4+veeszF5pLC1mPpNaM8Ob91+Dd9u7A1IT5D6tOvCo1r+f+zm4pophzNyuA3UhUEQPHj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Bundle all SPB anti-fragmentation diagnostic tracepoints into a single
top-of-stack commit so the entire instrumentation can be dropped before
upstream submission.

Tracepoint definitions (include/trace/events/kmem.h):
  - spb_alloc_walk            — exit point of every __rmqueue_smallest
                                 call with outcome and SPB visit count
  - spb_alloc_fall_through    — fires when PASS 1/2/2b/2c all failed
                                 and the allocator is about to taint
                                 a fresh clean SPB (PASS 3 / steal)
  - spb_pb_taint              — every PB_has_<mt> bit transition
  - spb_claim_block_refused   — try_to_claim_block exits with reason
  - spb_evacuate_for_order_done — evac phase completion summary
  - spb_alloc_atomic_relax    — atomic NORETRY relaxation events

Plus the SPB_ALLOC_OUTCOME_PASS_2D = 8 enum value (extending the
spb_alloc_walk outcome set for the cross-MOV borrow path).

Tracepoint emission scaffolding and call sites (mm/page_alloc.c):
  - n_spbs_visited counter + SPB_WALK_DONE macro in __rmqueue_smallest
  - bool first/last in __spb_set_has_type / __spb_clear_has_type
  - if-stmt brace + trace_spb_claim_block_refused in try_to_claim_block
    early-return paths (isolate, CMA, zone-boundary, noncompat-cross)
  - struct zone *pref + trace_spb_alloc_atomic_relax in slowpath
    NORETRY/NOFRAG-tainted relaxation
  - phase1_attempts/phase2_attempts counters + trace_spb_evacuate_for_order_done
  - trace_printk("SB first unmovable/reclaimable") on first-of-type
    transitions per SPB

Designed for diagnostics only — for upstream submission, hide this
commit. The behavioral commits below provide the SPB anti-fragmentation
machinery; this commit is purely instrumentation.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/trace/events/kmem.h | 371 ++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             | 149 ++++++++++++++-
 2 files changed, 510 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index cd7920c81f85..67fda214edc9 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -266,6 +266,377 @@ TRACE_EVENT(mm_page_pcpu_drain,
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
+
+#define show_spb_atomic_relax_step(s)					\
+	__print_symbolic(s,						\
+		{ SPB_ATOMIC_RELAX_NORETRY_SKIP,    "NORETRY_SKIP"    }, \
+		{ SPB_ATOMIC_RELAX_ADD_TAINTED_OK,  "ADD_TAINTED_OK"  }, \
+		{ SPB_ATOMIC_RELAX_DROP_NOFRAGMENT, "DROP_NOFRAGMENT" })
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
index e15e71d5ac99..815cee325ec0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -566,18 +566,39 @@ static void __spb_set_has_type(struct page *page, int migratetype)
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
@@ -601,21 +622,28 @@ static void __spb_clear_has_type(struct page *page, int migratetype)
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
@@ -2953,6 +2981,17 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
@@ -2998,6 +3037,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				    migratetype,
 				    pcp_allowed_order(order) &&
 				    migratetype < MIGRATE_PCPTYPES);
+				SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_1);
 				return page;
 			}
 		}
@@ -3013,6 +3053,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				    migratetype,
 				    pcp_allowed_order(order) &&
 				    migratetype < MIGRATE_PCPTYPES);
+				SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_1);
 				return page;
 			}
 		}
@@ -3049,6 +3090,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
 		list_for_each_entry(sb,
 			&zone->spb_lists[cat][full], list) {
+			n_spbs_visited++;
 			/*
 			 * Snapshot tainted-SPB capacity before the
 			 * nr_free_pages skip: an SPB with a free pageblock
@@ -3083,6 +3125,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page, order, migratetype,
 					pcp_allowed_order(order) &&
 					migratetype < MIGRATE_PCPTYPES);
+				SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_1);
 				if (migratetype < MIGRATE_PCPTYPES) {
 					struct spb_warm_hint_slot *slot;
 
@@ -3113,6 +3156,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_1);
 					if (migratetype < MIGRATE_PCPTYPES) {
 						struct spb_warm_hint_slot *slot;
 
@@ -3144,6 +3188,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
 			list_for_each_entry(sb,
 				&zone->spb_lists[SB_TAINTED][full], list) {
+				n_spbs_visited++;
 				if (!sb->nr_free)
 					continue;
 				for (current_order = max_t(unsigned int,
@@ -3168,6 +3213,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_2);
 					return page;
 				}
 			}
@@ -3178,6 +3224,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				&zone->spb_lists[SB_TAINTED][full], list) {
 				int co;
 
+				n_spbs_visited++;
 				if (!sb->nr_free_pages)
 					continue;
 				for (co = min_t(int, pageblock_order - 1,
@@ -3206,6 +3253,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_2B);
 					return page;
 				}
 			}
@@ -3263,6 +3311,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					&zone->spb_lists[SB_TAINTED][full], list) {
 					int co;
 
+					n_spbs_visited++;
 					if (!sb->nr_free_pages)
 						continue;
 					for (co = min_t(int, pageblock_order - 1,
@@ -3290,6 +3339,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
 							migratetype < MIGRATE_PCPTYPES);
+						SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_2C);
 						return page;
 					}
 				}
@@ -3335,6 +3385,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					&zone->spb_lists[SB_TAINTED][full], list) {
 					int co;
 
+					n_spbs_visited++;
 					if (!sb->nr_free_pages)
 						continue;
 					for (co = min_t(int, pageblock_order - 1,
@@ -3362,6 +3413,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
 							migratetype < MIGRATE_PCPTYPES);
+						SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_2D);
 						return page;
 					}
 				}
@@ -3404,8 +3456,40 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		}
 	}
 
+	/*
+	 * Diagnostic: capture per-fall-through state so we can answer
+	 * "why didn't an existing tainted SPB absorb this allocation?".
+	 * The count loop walks the tainted-SPB lists looking for any SPB
+	 * with a free buddy at the requested (order, migratetype). >0
+	 * means buddies were available — Pass 1 missed them. 0 means
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
@@ -3421,6 +3505,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				migratetype,
 				pcp_allowed_order(order) &&
 				migratetype < MIGRATE_PCPTYPES);
+			SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_3);
 			return page;
 		}
 	}
@@ -3439,6 +3524,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
 			list_for_each_entry(sb,
 				&zone->spb_lists[cat][full], list) {
+				n_spbs_visited++;
 				if (!sb->nr_free_pages)
 					continue;
 				/*
@@ -3463,6 +3549,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
 						migratetype < MIGRATE_PCPTYPES);
+					SPB_WALK_DONE(SPB_ALLOC_OUTCOME_PASS_4);
 					return page;
 				}
 			}
@@ -3487,10 +3574,13 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
 
 
@@ -3909,8 +3999,11 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	 * Don't steal from pageblocks that are isolated for
 	 * evacuation — that would undo the work in progress.
 	 */
-	if (get_pageblock_isolate(page))
+	if (get_pageblock_isolate(page)) {
+		trace_spb_claim_block_refused(page, start_type, block_type,
+					      SPB_CLAIM_REFUSED_ISOLATE);
 		return NULL;
+	}
 
 	/*
 	 * Never steal from CMA pageblocks.  CMA pages freed through
@@ -3919,8 +4012,11 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
@@ -3929,8 +4025,11 @@ try_to_claim_block(struct zone *zone, struct page *page,
 
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
@@ -3969,11 +4068,17 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
 
@@ -6196,12 +6301,24 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	 */
 	if (no_fallback && !defrag_mode &&
 	    !(gfp_mask & __GFP_DIRECT_RECLAIM)) {
-		if (gfp_mask & __GFP_NORETRY)
+		struct zone *pref = zonelist_zone(ac->preferred_zoneref);
+
+		if (gfp_mask & __GFP_NORETRY) {
+			trace_spb_alloc_atomic_relax(pref, order,
+				ac->migratetype, gfp_mask,
+				SPB_ATOMIC_RELAX_NORETRY_SKIP);
 			return NULL;
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
@@ -10756,6 +10873,7 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 	unsigned long sb_pfns[SPB_CONTIG_MAX_CANDIDATES];
 	unsigned long flags;
 	int nr_sbs, i;
+	unsigned int phase1_attempts = 0, phase2_attempts = 0;
 	bool did_evacuate = false;
 
 	/* Phase 1: coalesce within existing non-movable pageblocks */
@@ -10767,14 +10885,20 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 
 	for (i = 0; i < nr_sbs; i++) {
 		unsigned long end_pfn = sb_pfns[i] + SUPERPAGEBLOCK_NR_PAGES;
+		int n;
 
-		if (evacuate_pb_range(zone, sb_pfns[i], end_pfn,
-				      migratetype, 3))
+		n = evacuate_pb_range(zone, sb_pfns[i], end_pfn,
+				      migratetype, 3);
+		phase1_attempts += n;
+		if (n)
 			did_evacuate = true;
 	}
 
-	if (did_evacuate)
+	if (did_evacuate) {
+		trace_spb_evacuate_for_order_done(zone, order, migratetype,
+				phase1_attempts, phase2_attempts, true);
 		return true;
+	}
 
 	/* Phase 2: evacuate MOVABLE pageblocks to create free whole pageblocks */
 	spin_lock_irqsave(&zone->lock, flags);
@@ -10785,9 +10909,12 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 
 	for (i = 0; i < nr_sbs; i++) {
 		unsigned long end_pfn = sb_pfns[i] + SUPERPAGEBLOCK_NR_PAGES;
+		int n;
 
-		if (evacuate_pb_range(zone, sb_pfns[i], end_pfn,
-				      MIGRATE_MOVABLE, 3))
+		n = evacuate_pb_range(zone, sb_pfns[i], end_pfn,
+				      MIGRATE_MOVABLE, 3);
+		phase2_attempts += n;
+		if (n)
 			did_evacuate = true;
 	}
 
@@ -10801,6 +10928,8 @@ static bool spb_evacuate_for_order(struct zone *zone, unsigned int order,
 	 */
 	queue_spb_slab_shrink(zone);
 
+	trace_spb_evacuate_for_order_done(zone, order, migratetype,
+			phase1_attempts, phase2_attempts, did_evacuate);
 	return did_evacuate;
 }
 #endif /* CONFIG_COMPACTION */
-- 
2.52.0


