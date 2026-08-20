Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E5BC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28EB66B009F; Thu, 20 Aug 2026 09:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265D96B00A0; Thu, 20 Aug 2026 09:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A37A6B00A1; Thu, 20 Aug 2026 09:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E377B6B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:37:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 836F814018B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:37:31 +0000 (UTC)
X-FDA: 85121749902.28.0721FA4
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CA4012000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:37:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b="sQ7/vEfs";
	dmarc=pass (policy=none) header.from=yandex-team.ru;
	spf=pass (imf29.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787233050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M33AQZULeMLglpMel8DACoCzUVp1sCxykav1O7jduSw=;
	b=lC0at40118VCZgxYEZMCXGp/Ajv+2QIgO99wEC562/jwcPffybWU2jj5DsM8DmiDi9wDCi
	+zu2ejjLHRHNR03hk9wITmYxC3deV7xmy4OSMsPpUpbx6z95Ti6Dzf+o5xgXbL75kIsVrR
	9vI8C0fbuEG8TFC+uhITUCpx3tMy+s0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b="sQ7/vEfs";
	dmarc=pass (policy=none) header.from=yandex-team.ru;
	spf=pass (imf29.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787233050;
	b=2DIfUSFtUrGXodWnfkoYwz2DRNwnMt6tw/nOJyBEoWn65FcStQQXRtpBJjJyR5+QBAX4QR
	EPhqPOM6MQSR3Bdkvomg4kxomrGMoAIaCaDrtiqbPVOdWV4PTeV2wv8FGo9c/QqngKcGtB
	SVzUrnu4ZxluhRmYbVXhY11KTL7rBE8=
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:118b:0:640:b49:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 12ECA80848;
	Thu, 20 Aug 2026 16:37:27 +0300 (MSK)
Received: from i101646577.yandex-team.ru (unknown [2a02:6bf:8080:a66::1:2b])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp) with ESMTPSA id NbXRRG1eQ0U0-VPv2Jkxg;
	Thu, 20 Aug 2026 16:37:26 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1787233046;
	bh=M33AQZULeMLglpMel8DACoCzUVp1sCxykav1O7jduSw=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=sQ7/vEfs9B82gh0TzyYSDISaVxSKQ/DEV1E057jYCdbEiPNLBqowBxdmkqPKHwcgx
	 aj+vpDUD1cjDcDZ7xptrkoiXWZ9o+k3COKVEVJCPd4BghOzNeIINfnW+RSlhOrItGi
	 fDR3nvicxW4oQMTVNtRIp7TJ0g+1vcyRGkJ9QllI=
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
Subject: [PATCH] mm/vmstat: add per-order allocation slow path statistics
Date: Thu, 20 Aug 2026 16:36:58 +0300
Message-ID: <20260820133659.712111-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8q4suts4cn4rjsaafm86pxwcojoereiz
X-Rspamd-Queue-Id: 4CA4012000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787233049-325119
X-HE-Meta: U2FsdGVkX1+i7EAFpY2a4NNNMwTKv0h+zfE3wLG+V6We8RzlLdOVHQBultR70szxSYaozp0okYzqGpdn6VyUGt05EJI7bFo0b2Q+neypFZHi1fXiuudlPW5BRQU8w77fWz7daY3VZDljomH4VKb2z3OdPpw51ADikIjeykgYqvXzmaTAO0a2vlYpifQ684tF10kgp1FbkF29JDpWOhyT5Qjfc9nkWb9WI71NEUqt9c3Ib74ceDQaxtNuB0/TsUjEjazpKUdnQ66iztm2/W5rVjbTO4n3XP4kJQ3BNV9zhLg1rXviOM3nl7Ij1kR77YqeVNQWdPzS1ripaGZs2bzTbrWzbTweUWC8oVkqi9LG2ita8BXi9DWdAx1U2RbNbhL/LvHpzwLuOHRuut8yku3wZtushE28TRanyxC10DXqnBuqBNIPNdV7OHyQtisk0Ft6Mq4cSfw+XOC3HjKiTU16GYCYe9DBwKQkiwCNdcF9Y3/xJPcMP6Fx6N22yckO6T96lYmcAh+IDps5Sw+wKk4s6/S1jxuWemM9ttwyumSMthahg4g00hySs+l/azjOyZDdAJzk5FUWkDKL6phiMhd3mdJAMyC8SZziN3LzYGwNozx/8aTij82jvcdK297Cw+VPJIw5kYpS2Of9+zF8CCiBhqqNq/yzDD1nih4IGw0Ggy7PJ9Nk2kbNdDOLUtd/TcBX91x1xZK4l2mjVUk0iXcrChtsuRjH+fQ4dQ+wZBRQtSecQYafufw35EtoiC5wkfTkdbxr0DY8ZXmRazb8Ww0ZuGHh/B3WM3sP6DEDAHfn4kBfX2cUwCsgdOmJLl1NtJUHFuofspZwUEf97+faC0AujWNq84tP7Uj3wadi+SkxFQjzIww0668//W/jjqX3V4pQjS2PvqdwgfsRdeh8XoXJeKrKfyr7LbqxRybMDD1VxGKFrpRgOb7dYtphoCQY97J+mKjd4Uf+hlJBPWGtUGK
 175HJpT5
 fyVNpBi9cNyU2qR9LRlJy6LvnNhDoyLFrEJ9T2fVr120WrV3BzkzgoQ1Pj00A2OGhCmUGP405JrZPCi/zgpClDif36RY4QYq9HgJ9OdpWp1CRXd03DR0y9btvju7E5S7e2bYNd02XjJR03GqrspKleECdaEOWIscs1L8v8n2U8IwptXLPsz9VYM19ANZwsNtswWVjmoe+8ckRUjLNzcgYjCmfYXFeQBDtswvokbOvMglOe5U1NCi5z0myxvGoi4+9a0Is+2QKRrI6iEpAgYI+FHo+3Gd2l4IVObi3oLIiFuk8A49wFi5i4Z09DV7IYNRD1dB3YC2v26gfrkhoOlxBPtoz5G+p89g8Zvd9yNJvGstm/Uxrgvy4U4U7/wvTbTG1vMZi0Ol5mf5kYXVovQb1w/XtZQ==
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

Counter names are generated for any MAX_PAGE_ORDER the arch Kconfig
ranges allow (10..13), a static_assert catches larger values.

A per-order split of PGALLOC itself was proposed in 2017 but stalled
over fast path overhead concerns, restricting the counters to the slow
path avoids that overhead entirely while still capturing the
allocations that cause latency.

Link: https://lore.kernel.org/all/1499346271-15653-1-git-send-email-guro@fb.com/

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 include/linux/vm_event_item.h | 19 +++++++++++++
 mm/page_alloc.c               |  7 +++++
 mm/vmstat.c                   | 52 +++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

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
index f534972f517d..08596edc53ca 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1184,6 +1184,50 @@ int fragmentation_index(struct zone *zone, unsigned int order)
 	[xx##_MOVABLE] = yy "_movable",		\
 	TEXT_FOR_DEVICE(xx, yy)
 
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
+static_assert(MAX_PAGE_ORDER <= 13,
+	      "extend TEXT_FOR_ORDER_* for this MAX_PAGE_ORDER");
+
+/*
+ * (xx) + n must resolve to the vm_event_item for order n, so ranges that
+ * start at order 1 pass their *_ORDER_FIRST item minus one.
+ */
+#define TEXTS_FOR_NONZERO_ORDERS(xx, yy)	\
+	[I((xx) + 1)] = yy "1",			\
+	[I((xx) + 2)] = yy "2",			\
+	[I((xx) + 3)] = yy "3",			\
+	[I((xx) + 4)] = yy "4",			\
+	[I((xx) + 5)] = yy "5",			\
+	[I((xx) + 6)] = yy "6",			\
+	[I((xx) + 7)] = yy "7",			\
+	[I((xx) + 8)] = yy "8",			\
+	[I((xx) + 9)] = yy "9",			\
+	[I((xx) + 10)] = yy "10",		\
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
@@ -1488,6 +1532,14 @@ const char * const vmstat_text[] = {
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

