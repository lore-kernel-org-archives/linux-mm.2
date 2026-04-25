Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5925BFF885D
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 09:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BCA6B0005; Sat, 25 Apr 2026 05:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD336B008A; Sat, 25 Apr 2026 05:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A5B6B008C; Sat, 25 Apr 2026 05:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6095E6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:14:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10CDC8AEBE
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:14:11 +0000 (UTC)
X-FDA: 84696516702.17.E524950
Received: from smtp186.sjtu.edu.cn (smtp186.sjtu.edu.cn [202.120.2.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 11BA0180011
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:14:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=LGwCbYzK;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn;
	spf=pass (imf06.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777108449; a=rsa-sha256;
	cv=none;
	b=OFc+oj4KGyUl+IPIN8rzB+W/1ad9p698LkJGYJeZgPFP3j17/3XbrtOmXll0JRGvas+pWM
	oClF/Snz6YiEGb6eIdxnImpVsqWJNtOF3f1a35mHy792s0tatX6CI8Yrtd2OPIlks4G7ZC
	CCl8vgDK1uFF50sLOGH7qfrXVBfn6FM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=LGwCbYzK;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn;
	spf=pass (imf06.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777108449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9DWBvj13QrzFwFchK5aFi/VeKBwvZQieQPqOCUFK0FA=;
	b=bxQEL0FW7/cJ4mF1rxTmrlFCkS6i7oV2br3FyiwtDLG0kQJKhI1kXIzCggBzg5ebaGo2uC
	H8VvjNOUtSrwNbaxvSYzrp2mhebcBtTrJqSCtRnCu4PxprmP++F7TBAchwIXI/VY0R01FM
	AYXHdGmG6hR/fzuCSqmk53dIJFjTWYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sjtu.edu.cn;
	s=default; t=1777108440;
	bh=0o9y/jPA68LJvW1ebkXs+XPjp5lX/gb5yWnx4ETqriI=;
	h=From:To:Cc:Subject:Date;
	b=LGwCbYzKUoeAO2Dnv7Fkazn0dJBNNX1Ct6+9tB0o/cc9yIwkA2/hhtq59U2F+VQlX
	 WY/4vnC/OsB8VEwhpSlz1r/GZj/RZNKHbSGB7uyFFX8l9rI5ljHdi99g1XHIt5erCU
	 xurUgLjlRWB1xBqvzpNs2g0RDnS64wW8FflCYL/blvnlV65IuSPTE5Xii9ihNN3wEu
	 wroYn5F9NjSBXPrZLRgttFrmVlHK27i6Ru22ly7fhyg0TZGadbdUIKauDJmFakLLow
	 tz4XmndOKX2jcDvh27nir1SwuylJsQHDhc5Gk9xcPUcyzjSTF4PEYx6ap/zdfqGYuN
	 qBqvu08HtyCTw==
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp186.sjtu.edu.cn (Postfix) with ESMTPS id 84E2E2FF4E5;
	Sat, 25 Apr 2026 09:14:00 +0000 (UTC)
Received: from dynamic.ipv6.sjtu.edu.cn (unknown [10.180.122.86])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id EFE6337C921;
	Sat, 25 Apr 2026 17:13:59 +0800 (CST)
From: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	linux-mm@kvack.org
Cc: rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Subject: [PATCH] mm/page_alloc: add tracepoint for PCP refills
Date: Sat, 25 Apr 2026 17:13:35 +0800
Message-ID: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sjfzsz5pk4ouh6o6fer85w7e33dgiria
X-Rspam-User: 
X-Rspamd-Queue-Id: 11BA0180011
X-Rspamd-Server: rspam07
X-HE-Tag: 1777108447-542236
X-HE-Meta: U2FsdGVkX1+xWF8TYE20vkyZMT2ZrVhYYsxxVrkWsX5aO63R5tInc3bnm9m4sImGKNS38bHAfpxXGNC2cu2WLGS2fdRafIZ8zvQCeay+UEGZDWe4yrNzyoDWZYWJGAWpjgJ27sx4TbnTfM9djAIB36aP7aOTfMY0ZG3/N3KmWi/ErqlKvgq5dvueym0Dpg2fWFex2hgDv+QCKRnlTDea0UWrWpshUpZWae8PO5KDoTWL26xoRsAbwsTQWjR/oZaLZaewdcqADW1j62/UA6UpUO8egRX+Hd4IyQbNsa1eQNvlZlYy+8nYP4JbdjbYyok0CllqYVL7pCGIvpqpAXDzZAvrOuEHuNCt2YZTQ1ShUTC0fKeVpupROBeHp3L9Iy+bpsks/oVXCWgdy0XV+w9bGZxEccEiNLNHgNrjUqZj8Ys8aL1yNHsJcvTLZ9mJ6zow+MztnvudBaEjFM4TyEwqZ24TMY42immjG4fx+ZMlUFRksvnlLhk2hyv6kz1+uBYa0U6rkav+WDNxILggh9842K07KYRD/9wo/kG0jGRSLTJNjOBVsJhtHQ/MPjl0MtvtVsmHSkt/qHwwdWqeBRsGmzSaLpe12w+iU/mNUajmd5IfylL85jf04T15iMS7NQ20Av406BTTegjR3CSUVgXK5g7bcgBqMTUwLgzjtrlGO4z7ek3U/Q9xsp9LM3xdduYv+GexEpHzR7DcW5cm+tpC37oW9hzeIsUpB26ZW3gubH0K58eFm5maRqbmnq15IvSgZU7AfnlrVvmHqVetwRdOvCaCskUecH/lgZ1zbWwmlVhOEmVJSpdQDqyt/NXcMDpRshNn66sgSrRetLYd7GY8WhVq7w5hq0wfjToLatM9adJvngQgtvPiE+NX1jApIeofD0I+FXj6uNF32fF5KGKaK7ael/8lHgNd/ck0IVFih59TZScuWbke6gRDaqu7cA95XGnQbVpkYLen2gqREaa
 MDhXv8Hp
 Hm+pZF30C8/kuSJVFLfXU1Q633SXC2Hp+j6vr3Xd0nLIWdbPB8aOXPPMV3awSokCBQxVpsSB9q0l0Ieo6V8f/ghfOZnDBOAAqZlb009YlVh0G77u+UjTRy9wbWnAbO9W+mevUwtRDrtvP9uWQUvbMLz/ZBOodnThWtnIL5WEYgf50+K1lg8MRgyK5UPKGOXHGSrbkxskuD9Gl2Qy9P8Nq64/Q0fNooZodqsr0tKTKEEFEFnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page allocator already has mm_page_pcpu_drain to trace pages
drained from the per-cpu page lists back to the buddy allocator. There
is no matching tracepoint for the opposite direction, where
rmqueue_bulk() refills a PCP list from the buddy allocator.

mm_page_alloc_zone_locked is not a good substitute for this. It is
emitted from __rmqueue_smallest(), which is used both by rmqueue_bulk()
and by the direct buddy allocation path. Its percpu_refill field is
derived from the allocation order and migratetype, so it does not
reliably identify whether the allocation came from a PCP refill.

Add mm_page_pcpu_refill and emit it from rmqueue_bulk() for each page
added to the PCP list. The new tracepoint uses the same page, order and
migratetype fields as mm_page_pcpu_drain, making refill and drain
activity directly comparable.

Signed-off-by: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
---
 include/trace/events/kmem.h | 23 +++++++++++++++++++++++
 mm/page_alloc.c             |  1 +
 2 files changed, 24 insertions(+)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index cd7920c81f85..16985604fc51 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -243,6 +243,29 @@ DEFINE_EVENT(mm_page, mm_page_alloc_zone_locked,
 	TP_ARGS(page, order, migratetype, percpu_refill)
 );
 
+TRACE_EVENT(mm_page_pcpu_refill,
+
+	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	pfn		)
+		__field(	unsigned int,	order		)
+		__field(	int,		migratetype	)
+	),
+
+	TP_fast_assign(
+		__entry->pfn		= page ? page_to_pfn(page) : -1UL;
+		__entry->order		= order;
+		__entry->migratetype	= migratetype;
+	),
+
+	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d",
+		pfn_to_page(__entry->pfn), __entry->pfn,
+		__entry->order, __entry->migratetype)
+);
+
 TRACE_EVENT(mm_page_pcpu_drain,
 
 	TP_PROTO(struct page *page, unsigned int order, int migratetype),
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e205111553..a60b73ed39a4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2544,6 +2544,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 * pages are ordered properly.
 		 */
 		list_add_tail(&page->pcp_list, list);
+		trace_mm_page_pcpu_refill(page, order, migratetype);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-- 
2.53.0


