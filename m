Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D036CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 09:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BC96B0005; Sat, 30 May 2026 05:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3496B0088; Sat, 30 May 2026 05:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520686B008A; Sat, 30 May 2026 05:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 430C76B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:03:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E922114032F
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:03:21 +0000 (UTC)
X-FDA: 84823497402.02.148EEBC
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf04.hostedemail.com (Postfix) with ESMTP id 571D14000C
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:03:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf04.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780131800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hiSPvchToXRI8zCyMe1yxvW8pfwyWM8/RZsUHLd5bCo=;
	b=AaVo65LX4Wm/I702SLYS4p9gF3WiV3/1zKLr3DbBHNLQSGsnHdBWf8Eo3StPn0BSqY+4nv
	f/t2h5ZdxYdeHo01Vsp2+vxccWDAOxVpXOP6B0K0z5RVLG7tPEi38KcGjrmb38q59tam7m
	HOQbMt4aW97eDMxuSAsf/NkLL8Zcr5E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf04.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780131800; a=rsa-sha256;
	cv=none;
	b=Scxe1EqlTNv3JexTfUIiwUDm3yn1x5op3RUFCvfjhiI934kqwfd0okYKC0AasyuRXpGKFr
	Tut5gvMsFzOQWFEPftD3l14qpC3CBEoSxMc+//83c3W5wrusyGWHyLTbNJYCC0uetwhZix
	lqRnwa/bpw9T5qT4+nZjSQfpnUlJHY8=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gSDlm2pSlz8Xrnw;
	Sat, 30 May 2026 17:03:16 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 64U937c1049996;
	Sat, 30 May 2026 17:03:07 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 30 May 2026 17:03:09 +0800 (CST)
X-Zmail-TransId: 2af96a1aa7cdd7b-1a488
X-Mailer: Zmail v1.0
Message-ID: <202605301703094695zmVgcSC27BNR0rH0N8_x@zte.com.cn>
In-Reply-To: <20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn>
References: 20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn
Date: Sat, 30 May 2026 17:03:09 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>, <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY3IDEvNl0gbW0vcm1hcDogYWRkIHRyYWNlcG9pbnQgZm9yIHJtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64U937c1049996
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sat, 30 May 2026 17:03:16 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A1AA7D4.000/4gSDlm2pSlz8Xrnw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 571D14000C
X-Stat-Signature: fzhupd63cpcywc8og854wd1ygkqy7h5q
X-Rspam-User: 
X-HE-Tag: 1780131799-690725
X-HE-Meta: U2FsdGVkX1/LMD5dcqqSjT1bm0/u1MPCpWMvzDUca/KoBAIMvkbmaeXURAtJA0BQkZWedRS0Lhe5esUgTcAM6kRxRgarHLCYeu8PZXK7wq5zjx/hQRPx8d1xOr2NmnR6YIGOBuYb2+orXj82/bOHM9gEwhjPr3i9WPmhhw9Vty0UTtolIi9kA/XqEtKP4k1c3CM+87KA37SAt3q0KhqIUx7Zlj4ILgiwJALq1rztvR6bpk5bGAX3aRrcp3lcbMxYvPk5vzF2m2OdO80pxeXv1Bd+mVuT83dOmnjIksuIE2JOPQkeOlah/CcrxHDngPqaEkbsh/w5mJ3xLGb/Dt6aYpCp1Qt0S3KRM6yLBGD3cyzgWv05/PIAld52uWcK520igcIqZPjlrsxYrlieUSUpvs3Hvg54eyIAzQDhWR0Xm6ONHdZzX7d/osqeLuZ33ih/DFhb8vbIM/W4SJVQXrFlppNueih8FhT0pcDZGzFm7wTJh0fR4MDhgOiadMPNwSHex+8/lSwlPxS1HXT7Qx3sP6CvKb2+IbxOaBhfyKK5D8dAy5nvMWPkFRHP2DhLwCM/RJj0tXVPNZzpUpW2Ou0UPUqQ1x5mwj2vSF344vhUnpbxoBemh7/unDu4jnVLzWDmX4fTavkMryYUPIS4Ldueb/f1rlfGPze5Gw07IRhws8SzpVTICrwejcQvFaXkw92Ab/1rOLkFrvG4LK82cmsbKAV4eMVCNrAUJgrXxZlYAQ1qn/CySwGO63JG8Zbgys4QG2ntxff81N84A/0uknMKNpp4J7MEevX61eVyaQujyQjffaChkwb9bBBJe81X+I++3RGYyzbd2svqFqqxZd0Rd9WZwmL3WBdEF/j9Q00zrNgunjdrIwnfkS/C90FYLv+e3kUHHFAhcT1z8KaBRPN30yp2bOxgaNEiyRowkIlBoMKN1O+Vd5Rbq+4ZY0dc/5NGBz5H1kZc8GMGXbcNqdc
 NS83rQIa
 zlD5555FgJmFvZW88Zm7cog/M20PXX2SjiRwTFr5ivWGdLN8yVd/YA10VirwmumfXbRx1Hhk5ncgltEz/7/K56e75hw/LcXisKLVFCXWZMNGwJWc4LiQ86FayVixzrZyFXsNpoyNA1x3QFBQP6L055cllixOh80SKa3Nac2m5lxF6cN7htyrSMotXtLl/C1E0SYbMB6BS/CvIfphX2yt8c86gUfsR8sGAN9b+E5SaxYimcqosRh5MO7dXwHOOob7YMO28vtoxvujiFfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Add trace_rmap_walk_start() and trace_rmap_walk_end() to bracket
reverse mapping walks.  Unlike manual clock sampling, these
tracepoints record no timestamp; latency can be computed offline
by tools (e.g., perf, trace-cmd) using the event timestamps.

When tracepoints are disabled, the only cost is a static branch
check (no clock read, no duration calculation), making them
suitable for production use.

The information (folio type, locked state) helps diagnose
performance issues in KSM, anonymous, and file-backed rmap walks.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/trace/events/rmap.h | 67 +++++++++++++++++++++++++++++++++++++
 mm/rmap.c                   |  9 +++++
 2 files changed, 76 insertions(+)
 create mode 100644 include/trace/events/rmap.h

diff --git a/include/trace/events/rmap.h b/include/trace/events/rmap.h
new file mode 100644
index 000000000000..55a319ba6235
--- /dev/null
+++ b/include/trace/events/rmap.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rmap
+
+#if !defined(_TRACE_RMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RMAP_H
+
+#include <linux/tracepoint.h>
+#include <linux/rmap.h>
+
+#define GET_RMAP_PAGE_TYPE(folio) (folio_test_ksm(folio) ? "ksm" : \
+		(folio_test_anon(folio) ? "anon" : "file"))
+
+/**
+ * rmap_walk_template - called for start / stop of rmap_walk.
+ */
+DECLARE_EVENT_CLASS(rmap_walk_template,
+
+	TP_PROTO(struct folio *folio, struct rmap_walk_control *rwc, bool locked),
+
+	TP_ARGS(folio, rwc, locked),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, folio_addr)
+		__field(unsigned long, rwc_addr)
+		__string(page_type, GET_RMAP_PAGE_TYPE(folio))
+		__field(bool, locked)
+	),
+
+	TP_fast_assign(
+		__entry->folio_addr = (unsigned long)folio;
+		__entry->rwc_addr = (unsigned long)rwc;
+		__assign_str(page_type);
+		__entry->locked = locked;
+	),
+
+	TP_printk("folio=%p rwc=%p page_type=%s locked=%s",
+		(void *)(unsigned long)__entry->folio_addr,
+		(void *)(unsigned long)__entry->rwc_addr,
+		__get_str(page_type),
+		__entry->locked ? "true" : "false")
+
+);
+
+/**
+ * rmap_walk_start - called before a folio is rmapped.
+ */
+DEFINE_EVENT(rmap_walk_template, rmap_walk_start,
+
+	TP_PROTO(struct folio *folio, struct rmap_walk_control *rwc, bool locked),
+
+	TP_ARGS(folio, rwc, locked)
+);
+
+DEFINE_EVENT(rmap_walk_template, rmap_walk_end,
+
+	TP_PROTO(struct folio *folio, struct rmap_walk_control *rwc, bool locked),
+
+	TP_ARGS(folio, rwc, locked)
+);
+
+
+#endif /* _TRACE_RMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/mm/rmap.c b/mm/rmap.c
index 78b7fb5f367c..52f795f768e1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -80,6 +80,7 @@

 #define CREATE_TRACE_POINTS
 #include <trace/events/migrate.h>
+#include <trace/events/rmap.h>

 #include "internal.h"
 #include "swap.h"
@@ -3098,23 +3099,31 @@ static void rmap_walk_file(struct folio *folio,

 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc)
 {
+	trace_rmap_walk_start(folio, rwc, false);
+
 	if (unlikely(folio_test_ksm(folio)))
 		rmap_walk_ksm(folio, rwc);
 	else if (folio_test_anon(folio))
 		rmap_walk_anon(folio, rwc, false);
 	else
 		rmap_walk_file(folio, rwc, false);
+
+	trace_rmap_walk_end(folio, rwc, false);
 }

 /* Like rmap_walk, but caller holds relevant rmap lock */
 void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc)
 {
+	trace_rmap_walk_start(folio, rwc, true);
+
 	/* no ksm support for now */
 	VM_BUG_ON_FOLIO(folio_test_ksm(folio), folio);
 	if (folio_test_anon(folio))
 		rmap_walk_anon(folio, rwc, true);
 	else
 		rmap_walk_file(folio, rwc, true);
+
+	trace_rmap_walk_end(folio, rwc, true);
 }

 #ifdef CONFIG_HUGETLB_PAGE
-- 
2.25.1

