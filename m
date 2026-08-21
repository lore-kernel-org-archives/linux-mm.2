Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E858CC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 00:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15BB6B009D; Thu, 20 Aug 2026 20:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED756B009F; Thu, 20 Aug 2026 20:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29D56B00A0; Thu, 20 Aug 2026 20:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A95736B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:55:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29ABFA0323
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:55:59 +0000 (UTC)
X-FDA: 85123459638.10.77FD561
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id 19EAF180009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:55:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=lDi2na8M;
	spf=pass (imf24.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru;
	dmarc=pass (policy=none) header.from=yandex-team.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787273757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5D9uwJCpbHo7/4YRUJ9w57BQAP1rfW5YDjsxXh0cj1o=;
	b=uuj/2TjnDIfFh9iQeTCDgj+jdWwuX4IGtVONOeHOM+h9+L2EzkyoA70iIq+8+3b6KlRern
	L1UC796kgPaXjMxhFHuykFW5rFvDyELWEXMxTNkTZ+fT6kI2HifMDwtEwI09zieYK7EYqV
	7caqw49LZaRI7Wtl5uyir/6vYJHcB5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787273757;
	b=koW1r31Lqg9XlRi7JrkqS652dEL8Ed+yINjIcVqWCKwFaaTYTFOKxRjFyqPqtBtfJnavV8
	paxtfngSAskIOtY5AYpjQ9dmY7OaP0dmcoZmyVG+iofjK999V9WD0uWalcpYK/dtacLGxo
	WkkHjeeXBJRMariIXwwxNow0UiO6r0g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=lDi2na8M;
	spf=pass (imf24.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru;
	dmarc=pass (policy=none) header.from=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:43a8:0:640:574d:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 7555080794;
	Fri, 21 Aug 2026 03:55:53 +0300 (MSK)
Received: from i101646577.yandex-team.ru (unknown [2a02:6bf:8080:a74::1:2e])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id mtLKPEEY8Ko0-acuqyG6g;
	Fri, 21 Aug 2026 03:55:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1787273752;
	bh=5D9uwJCpbHo7/4YRUJ9w57BQAP1rfW5YDjsxXh0cj1o=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=lDi2na8M9DsNS+mF1ieqTD/PYo3yxcZWCISS1b/1wYdRvYM4Oh7wu+6UayOotywDg
	 43hiqx/DqhIMUiHg9hPd9YCfupnEORgabJkUsJBCMGsD54+fwlYJNANHPE6XeZXaAT
	 YJ2RD947cxpraaNqGJwu18Ez172WizDuBOvYP4kk=
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/vmstat: add per-order allocation slow path statistics
Date: Fri, 21 Aug 2026 03:55:40 +0300
Message-ID: <20260821005541.786308-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uamaxirbopjtn83m9njw6rwo5t9wao7m
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19EAF180009
X-HE-Tag: 1787273756-196785
X-HE-Meta: U2FsdGVkX1+MoV3LBaViz9GnkgnCFJk9kFNEUJk4/o1+nOWqxqycZELClUUIXUm07G2ACv3vp9XqX/1FAKCEvu9hocPzBI8cpnHYh+Gtr9aorzfSW9XhrLmfd9Fv1fw9Yqab5Dm2SaBUsQs0aucJAZezBkUQYO8ESM/3wdFdsxvB0Fb1yZjm6pZ3JOKb3+dC59dj75uEX+rifaptGJ4c4me+8WFqT1cfK+kgsi8x3rf2nvDue+ckt+7lisHI2ikxurKWXEyI44iVCW61c3Kp00pNlyUWVIqvsmFZdpnQQDXVi87hJWGJOgdMuGMmCyUXGctt+e1pUA3GpcUwarA42DkFOs2Ea40cs6k8dfH5ytloi8ONZ6VP81+UrnQweQnRgvwXMEVcXKxN6Pv9yRdkZqy2yEVUQYacAmH/PsM/J4yBjSKr0USwufNYzwA98wU5hEhVHP+YU8buourUVSRt35+Ja/vMldJCaqzcYR2eSW0NlLlOcT7tkf/AoYMvSm34DF6OOcJtAoD1gTju1vtAdiynlWX9TaW76x7Ujtw3zM4yTHBADJZHhmb50JRTUL/ZY6hRfkJuIC3F8fy841yaX101Qlx08QK0cghXfPQkK72Mxkj67R4xqhtHQqs1eylel4xlygD2Pppm3lFAC4CR3nYWko65DNwSs3X9n+/2wuYxlyW3XZUDBk8Z5IdkJiyg6YIj+ZZYbBjcUrgFLkMeKje4Nuknz85oBGhRzDD4EX6M9YnU8Gvsfe1dCsKHcht4J3fTZBSrVD97rM2uATVUqgdSUvpwBP5ItDZAO2qsrUBgaHakRkNhJ9r1wWArn+H/eGoOPBoOIX4Sci/72Q+qULrwt8jfzCH+SCmn1zq3ssRDKPIdwKU+HJA0VDA28wrQQ/2li+RQWuAIxeAbF7QXJ0pSjkWSHBeOteto9adlYlelF92UJ0m7cA5dj5s4LRcALDlzAnKWIg7et3XsP+0
 nEJ3PHeb
 Wo+1+q2d4353ttEwce922OXttd3UXCWYepDoLG3EMXT2CKIex1rk4G0PlrJYyvVYiKwjghveBfXgX171j7rNLOEuiTApDcvV/sDVQNVeFe7cEWI475JA7IvH97lPoNmJOP7xXRdyswtUPS9MaVBYlroxw/UBRMRAo1pcmAi1NDR7QVXsQ0L26pvqXPbuNFAJol3uc9NGt3AIvRZZFAjFKw1sW6XEeOrmGwrOsmoa90nv9H9aBhTr6Kai80+dO4+tD1kVzOeUN3RPzXrtYSyGde9dRnr7AE+XSRAJABt1tcTsynj1KngBNMFyGh4Un0f5ljIFvYkoreLjN1OHRIvXj3X4zzmz2Se6Vph3Rtykz+hw2gzVO5QTer7YiD9QCLCxMqRK6RQbNMwyM7rjh33fbjZEouw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Production incidents caused by bursts of high-order allocations all
entering direct compaction are currently hard to attribute from
/proc/vmstat: pgalloc_* has no order breakdown, and compact_stall does
not say which order stalled. Tracepoints can recover this on a single
machine, but they are impractical as an always-on fleet-wide monitoring
source, which is what is needed to correlate latency regressions with
allocation behavior after the fact.

Add per-order event counters to /proc/vmstat, covering only the
allocation slow path, so the page allocator fast path is not touched
at all:

 - pgalloc_slowpath_orderN: entries into __alloc_pages_slowpath(),
   counted once per allocation, before the restart loop
 - pgalloc_fail_orderN: allocations that returned NULL to the caller
   (including a successful allocation freed by memcg charge failure)
 - compact_stall_orderN / compact_success_orderN: per-order split of
   the existing direct compaction counters, order 0 is omitted since
   direct compaction is never entered for it

All new counters are purely additive: the existing keys are untouched
and compact_stall == sum of compact_stall_orderN.

alloc_pages_nolock() is deliberately not counted: it is opportunistic,
never enters the slow path, and its NULL returns are expected rather
than failures.

Counter names are generated for all MAX_PAGE_ORDER configurations that
are currently possible via ARCH_FORCE_MAX_ORDER. Orders 1..3 are
generated unconditionally, 4..13 are MAX_PAGE_ORDER dependent (e.g.
ppc32 with 256k pages forces 4 by default).

Sample output, taken on a small x86-64 test VM after a burst of THP
sized (order-9) allocations against deliberately fragmented physical
memory (only non-zero counters shown):

  $ grep -E "order[0-9]+" /proc/vmstat
  pgalloc_slowpath_order0 9104
  pgalloc_slowpath_order9 26
  pgalloc_slowpath_order10 5
  pgalloc_fail_order0 1
  pgalloc_fail_order9 25
  pgalloc_fail_order10 5
  compact_stall_order9 51

inspecting these we can see exactly what happened on the system in that
moment: the order-9 burst missed the fast path 26 times, stalled in
direct compaction 51 times and 25 of the requests failed outright,
against a background of ordinary order-0 slow path traffic (9104).

A per-order split of PGALLOC itself was proposed in 2017 but stalled
over fast path overhead concerns, restricting the counters to the slow
path avoids that overhead entirely while still capturing the
allocations that cause latency.

Link: https://lore.kernel.org/all/1499346271-15653-1-git-send-email-guro@fb.com/

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
v1 -> v2:
 - handle MAX_PAGE_ORDER below 10: orders 4..10 now track MAX_PAGE_ORDER
   like 11..13 already did, so configs such as arm pxa_defconfig
   (MAX_PAGE_ORDER = 8) or ppc32 with 256K pages (4, the smallest any
   arch Kconfig currently sets) no longer overrun the enum ranges and
   trip the vmstat_text size assertion
 - quote sample /proc/vmstat output in the changelog

 include/linux/vm_event_item.h | 19 +++++++
 mm/page_alloc.c               |  7 +++
 mm/vmstat.c                   | 96 +++++++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..724561b7e800 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -175,6 +175,25 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+		/*
+		 * Per-order allocation statistics: each *_FIRST..*_LAST range
+		 * is indexed by allocation order.
+		 */
+		PGALLOC_SLOWPATH_ORDER_FIRST,
+		PGALLOC_SLOWPATH_ORDER_LAST =
+			PGALLOC_SLOWPATH_ORDER_FIRST + MAX_PAGE_ORDER,
+		PGALLOC_FAIL_ORDER_FIRST,
+		PGALLOC_FAIL_ORDER_LAST =
+			PGALLOC_FAIL_ORDER_FIRST + MAX_PAGE_ORDER,
+#ifdef CONFIG_COMPACTION
+		/* Direct compaction is never entered for order 0 */
+		COMPACTSTALL_ORDER_FIRST,
+		COMPACTSTALL_ORDER_LAST =
+			COMPACTSTALL_ORDER_FIRST + MAX_PAGE_ORDER - 1,
+		COMPACTSUCCESS_ORDER_FIRST,
+		COMPACTSUCCESS_ORDER_LAST =
+			COMPACTSUCCESS_ORDER_FIRST + MAX_PAGE_ORDER - 1,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..2a2b14f3b516 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4169,6 +4169,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	 * count a compaction stall
 	 */
 	count_vm_event(COMPACTSTALL);
+	count_vm_event(COMPACTSTALL_ORDER_FIRST + order - 1);
 
 	/* Prep a captured page if available */
 	if (page)
@@ -4184,6 +4185,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		zone->compact_blockskip_flush = false;
 		compaction_defer_reset(zone, order, true);
 		count_vm_event(COMPACTSUCCESS);
+		count_vm_event(COMPACTSUCCESS_ORDER_FIRST + order - 1);
 		return page;
 	}
 
@@ -4757,6 +4759,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		WARN_ON_ONCE(current->flags & PF_MEMALLOC);
 	}
 
+	count_vm_event(PGALLOC_SLOWPATH_ORDER_FIRST + order);
+
 restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
@@ -5323,6 +5327,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		page = NULL;
 	}
 
+	if (unlikely(!page))
+		count_vm_event(PGALLOC_FAIL_ORDER_FIRST + order);
+
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 	kmsan_alloc_page(page, order, alloc_gfp);
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..08f0ebc7ff43 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1184,6 +1184,94 @@ int fragmentation_index(struct zone *zone, unsigned int order)
 	[xx##_MOVABLE] = yy "_movable",		\
 	TEXT_FOR_DEVICE(xx, yy)
 
+#if MAX_PAGE_ORDER >= 4
+#define TEXT_FOR_ORDER_4(xx, yy) [I((xx) + 4)] = yy "4",
+#else
+#define TEXT_FOR_ORDER_4(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 5
+#define TEXT_FOR_ORDER_5(xx, yy) [I((xx) + 5)] = yy "5",
+#else
+#define TEXT_FOR_ORDER_5(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 6
+#define TEXT_FOR_ORDER_6(xx, yy) [I((xx) + 6)] = yy "6",
+#else
+#define TEXT_FOR_ORDER_6(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 7
+#define TEXT_FOR_ORDER_7(xx, yy) [I((xx) + 7)] = yy "7",
+#else
+#define TEXT_FOR_ORDER_7(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 8
+#define TEXT_FOR_ORDER_8(xx, yy) [I((xx) + 8)] = yy "8",
+#else
+#define TEXT_FOR_ORDER_8(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 9
+#define TEXT_FOR_ORDER_9(xx, yy) [I((xx) + 9)] = yy "9",
+#else
+#define TEXT_FOR_ORDER_9(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 10
+#define TEXT_FOR_ORDER_10(xx, yy) [I((xx) + 10)] = yy "10",
+#else
+#define TEXT_FOR_ORDER_10(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 11
+#define TEXT_FOR_ORDER_11(xx, yy) [I((xx) + 11)] = yy "11",
+#else
+#define TEXT_FOR_ORDER_11(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 12
+#define TEXT_FOR_ORDER_12(xx, yy) [I((xx) + 12)] = yy "12",
+#else
+#define TEXT_FOR_ORDER_12(xx, yy)
+#endif
+
+#if MAX_PAGE_ORDER >= 13
+#define TEXT_FOR_ORDER_13(xx, yy) [I((xx) + 13)] = yy "13",
+#else
+#define TEXT_FOR_ORDER_13(xx, yy)
+#endif
+
+static_assert(MAX_PAGE_ORDER >= 4 && MAX_PAGE_ORDER <= 13,
+	      "the per-order counter names need updating for this MAX_PAGE_ORDER");
+
+/*
+ * (xx) + n must resolve to the vm_event_item for order n, so ranges that
+ * start at order 1 pass their *_ORDER_FIRST item minus one. Orders 1..3
+ * are generated unconditionally, 4..13 are MAX_PAGE_ORDER dependent (e.g.
+ * ppc32 with 256k pages forces 4 by default).
+ */
+#define TEXTS_FOR_NONZERO_ORDERS(xx, yy)	\
+	[I((xx) + 1)] = yy "1",			\
+	[I((xx) + 2)] = yy "2",			\
+	[I((xx) + 3)] = yy "3",			\
+	TEXT_FOR_ORDER_4(xx, yy)		\
+	TEXT_FOR_ORDER_5(xx, yy)		\
+	TEXT_FOR_ORDER_6(xx, yy)		\
+	TEXT_FOR_ORDER_7(xx, yy)		\
+	TEXT_FOR_ORDER_8(xx, yy)		\
+	TEXT_FOR_ORDER_9(xx, yy)		\
+	TEXT_FOR_ORDER_10(xx, yy)		\
+	TEXT_FOR_ORDER_11(xx, yy)		\
+	TEXT_FOR_ORDER_12(xx, yy)		\
+	TEXT_FOR_ORDER_13(xx, yy)
+
+#define TEXTS_FOR_ORDERS(xx, yy)		\
+	[I(xx)] = yy "0",			\
+	TEXTS_FOR_NONZERO_ORDERS(xx, yy)
+
 const char * const vmstat_text[] = {
 	/* enum zone_stat_item counters */
 #define I(x) (x)
@@ -1488,6 +1576,14 @@ const char * const vmstat_text[] = {
 #if THREAD_SIZE > 65536
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
+#endif
+	TEXTS_FOR_ORDERS(PGALLOC_SLOWPATH_ORDER_FIRST, "pgalloc_slowpath_order")
+	TEXTS_FOR_ORDERS(PGALLOC_FAIL_ORDER_FIRST, "pgalloc_fail_order")
+#ifdef CONFIG_COMPACTION
+	TEXTS_FOR_NONZERO_ORDERS(COMPACTSTALL_ORDER_FIRST - 1,
+				 "compact_stall_order")
+	TEXTS_FOR_NONZERO_ORDERS(COMPACTSUCCESS_ORDER_FIRST - 1,
+				 "compact_success_order")
 #endif
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */

