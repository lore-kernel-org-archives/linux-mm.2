Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E03CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8C26B0093; Thu, 21 May 2026 22:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FE66B0098; Thu, 21 May 2026 22:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A60A6B0099; Thu, 21 May 2026 22:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45D986B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:54:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0677391F73
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:54:35 +0000 (UTC)
X-FDA: 84793537710.07.4FD6876
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 503CB10000F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:54:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf14.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779418472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hiSPvchToXRI8zCyMe1yxvW8pfwyWM8/RZsUHLd5bCo=;
	b=p7Brp74LlNt34QQ4aZbXxoHxSNIYF6f4pLELjdFp3HxVbu2GrLZmIrpVJ6YkMdws/dVRTm
	mJAgb+3oRC0Uz7La43/B5jejUGQ3/8NrVPaorjsg4sfYCBJcE40xAy1wEdsSCMpBo6p8GL
	hdgWUockjelvu9c1aVCRlk0BtvEC3mc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf14.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779418472; a=rsa-sha256;
	cv=none;
	b=sRPAH1ce8zFS5y2ojLT11BfVJjHC0TsfN0TEnwbjXcLiKFYccSlDrFZxInvJUQLzw+1j8p
	5s2mJ/RblOd9tXdFEVYSlJFlJRWpN/YOWyPEcd3BraRqdR8SD7OSVxtgbWUdaa3ufl7rYW
	MB6P7kYCk+fOEpNKXTRpsyC7biS+v1M=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gM8xw5kSkz57DCf;
	Fri, 22 May 2026 10:54:28 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 64M2sMOA002602;
	Fri, 22 May 2026 10:54:22 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 10:54:23 +0800 (CST)
X-Zmail-TransId: 2afa6a0fc55f23f-2a797
X-Mailer: Zmail v1.0
Message-ID: <202605221054232385LsDu1aTeJ-0fwQCqR-ro@zte.com.cn>
In-Reply-To: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
References: 20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn
Date: Fri, 22 May 2026 10:54:23 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY2IDEvNl0gbW0vcm1hcDogYWRkIHRyYWNlcG9pbnQgZm9yIHJtYXBfd2Fsa8KgwqA=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64M2sMOA002602
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Fri, 22 May 2026 10:54:28 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FC564.001/4gM8xw5kSkz57DCf
X-Stat-Signature: 7gzh7y7wueyfjgeopu1nh3o9a9retnhn
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 503CB10000F
X-Rspam-User: 
X-HE-Tag: 1779418472-195296
X-HE-Meta: U2FsdGVkX1/yYjstn3jC26lDeH3W8z/n5/W5fzqMGeU4045gTKt019rEvkktYt+tZ2LE8a0Ry4TTuCHinlQxWVTm8sPFCA+GNIyoiL5am2mxwi7+ufmZziBRy5sM/MASDJsd1bIl89jU8UQNhpMNluELuQEqWYnXpIiYNz+Vx+ht/HAuldZ0xL1JX/Br4VV/SALjpn4l86M1FG7odctzL8U8lCBFLr13K8d5PAamZwXMOkKFqF8QlDiQ6w/pu3zLiK7hD90yppMGRNzgWO5wLBUzMiwKScSEGUz2SjMhISzz98wjZOrWT4pFrkvRb9FRZnATEc3ag4rxx+5E5w0hhUA1wN5jVZ+3VqVfxyLL1tuTk8ytCvUTs95L80iQDGbqo1foetfft9s465l1atUMXFrWPwvV3TmyOBQH1fhR3VE3zTx3Nr/K5cOjTlzgw0MsWnw2n9NPZDV8ZoQPE1HVKYYij6geOMsXwyLdmq09fjc+R+xwjv/9fBtqOiWKnBuLh9AqVfHLzApbBfxkEo+mTNzSLI8jbXNO7tEcmg8Ua0P3nsN1Cv5ttKQCe/lN+SETPwkDG0GmfL+3QBKpoyAdxaLxp8iTC3ofJ7SGrg9oVKH1dsBkY5JtiPWCpyQOnxwXEVds/2Zc9Z/Ht5hUbX5WPUW+6K0yq/C07TnR341FpPrfUo+JahajTd3bIkwfPcocxaVaictx5ZF1i8jeuzZDpAvZv4tVjszF3OZGNXMu1GdZX7+AS0fsuZwmakRq/PJoz0xMoh0zto6lbEGBE5EmGdU8xhzD0/joQEPs0cQHxUBcB1B/o/uEhZr6Ms/+SLFcG4UF3LwICcv5hQ6y/keFhCxiSkRXHETC4B0/g6m6Njxveez11t7Mg7qhq/PodB6vjxD5TiTRyfjMwJ43wWm++PVMskIhTPWYkAzNTmuqY4GK0Zu+CTdpato6btwIDFVCIf3trVeSsZ/VVU5ogqL
 H9xK5N3h
 17uhd02Xc5/yoI5Tmg2orLLAvlIT//AsAqG9c21oKnuZp1Vx5T7jQhNrbzwmBBmzSq53oJuJrnGgY2BUsVkuxad4npsiqPR70T0QPj2Ib6LcmYtl8dvWytqURAEWJk3DM9DqiHwoBUO5i5dY9P8aFYAjyQqvbucy62SHoL5sp0N9bOBAG4dcRH+7Mn1NcHmCmoFvmpMsrISv1UcF2PWhGvajJ3RNGI1QvSwA2
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

