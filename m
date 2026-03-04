Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C80CEF9011
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C982D6B009B; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9416B009D; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BC56B0099; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC646B0096
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52E371403F5
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:56:47 +0000 (UTC)
X-FDA: 84508984854.24.1B26863
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A4B014000E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:56:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kqfwZ2GO;
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772643405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0qelRv5zWXN2gjQ6HBma/MzWG4qFrNJfcUswY7e3Y4=;
	b=7lhZ/utqbF+xM7v4h4YfoQCaSCyX/GYPtWtWA3DLWS4Pq0pByOYGr5vCzec8YZv2LlU31q
	z2dZ8cpQ953uRJ4iziaH4cJHiC6Xsfbp14i7Jp4U1gwwa32lZ8GBPEaRopigapNcWuIxug
	IHXLJr/Fqj2Gnl3fUTyKuQMf/qn0xBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772643405; a=rsa-sha256;
	cv=none;
	b=3mcPacxok3wYTxJrTN4lf3ucKX7pOBu8Y/u8FR0v4x6+oazOa838njRkW9ZNzfH7Zmg7ZC
	e7c3f+RkVFGKGpuGI7mHYwrSGEhLlAGAGFOvvQ+fvOSlbWuInIsjwYUVFC6LjXem6Eq4Pa
	wtkFMCxlhqS8C8FnFHT5EjupUHV33RY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kqfwZ2GO;
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 95683B31B5;
	Wed, 04 Mar 2026 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772643403;
	bh=p0qelRv5zWXN2gjQ6HBma/MzWG4qFrNJfcUswY7e3Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqfwZ2GOvHUwq/M+8X7nE6R0fTDZdiiKsHbzqYjxSvL2unY282zlkYx+aQMbunTwU
	 tA/AeImoXoVTxOeMxrb1rIaUpWCrsv2VaVLFktjjNp/lqNEuBP2cbdoVypxbWsZ0aJ
	 uHkSATeP07Do4ZvIorXsgw9xuixyQ2nRUX0SRqD0=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH RFC 1/3] locking: Add contended_release tracepoint
Date: Wed,  4 Mar 2026 16:56:15 +0000
Message-ID: <f8605471fd84ebff963c011aa98f79ed17f493c7.1772642407.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772642407.git.d@ilvokhin.com>
References: <cover.1772642407.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: awgifcgf933xn46pp5cmasqkkizx164g
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A4B014000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1772643405-669840
X-HE-Meta: U2FsdGVkX1+9M5gU4VEYfg/hYLNUjouZsIK7B1u8hCGeZbiWRtsLwq51XmPUEGNV6AavPCB9TlS0gCNQ2MtQu7LEhDz3u9v814w0C+789BLfQkxKqs2TSm4F86s9YBSM5NSjaU3iNxz5cguTgkPwXLVX06R8OevH9y2dHBFahOcJH+hwydOsBpMGXxS++6dzo3jq3ioVbG/zph6VXbMHNlwVzWp/hdRyxo7FsjumGfaGXqFBTm1OwZDn1PpqUqFXoxgKSzElkuWB54qjaIA4WjpH/6b6XaoTonyYAVEsgm4FoqLOlV/kCnuTFl5xrpzZEwjKGV0fEg4+UpPaH1AZCh2PedU/ndOmFon/b2fuoKQLEUlukYjdr0cjxsod1SVQudripBQOyWvwmV1y4P2eKgXQ9EETva1VqdrQGdC00rC3PMmoaY/uxzzxMi9ZeXICJI/OEWihwmeh1cZoN1LybfQZsPyZ1+rG0swEOJRFGuJQGJcnSTqS7YOFG5LT6aigj2DUpRbR82rNC8011IMdBsXOxi7bsTG4bgJbfxTuUzPjVvvucFkWKSI8pD5VoylvcAvX+ENBsACN7ppwxqiZAxrT1HF7zMZ3o04p+8m4dzwzpx0/qiQwb1W6l3OsR2zrgG3VXVSjdULybZ8VCCBkMrRINwHLXK5//C+xNa/D0mR7Y5rAXWzogSGofGF5VB29+HlmRnkHa4a39x/vFaJhaCk1UERopHkqjPRWwS0CbDeuEkfjdBivcEuOLBmAaVUiACXRv+0T1a0L70ADS1TP73Qj3FBD/qPkXKI5ui7aaF21vGBvnXp8sgJCZilD3Xtr60ZUfCPNzQh4Ng/To4G7RLU61YyCLSKydJA6t8mOM1aelNj+SIkFf0Gr+kSAxofHCiUcKtWbmdTk8cf0U5iEWx6Gs9MnB3vtyadl59Tx7rYKKaoKDJINWVXNAjyx8e+8iW7+NPW1AdCM1t+eUk4
 ShpAwbNl
 6Do4w/GCsBrX0M5P1TqRdtHazC7hSepbhtegpTksyyYt+NCZ2/VscPrWZo8iYrmwDiDPMa+iADDCbxaztf+ulQn06DOxKplsPoJj5z1mNsx31nBeFakGlXcaIFTV3TUu2acRKPoJefhiDK7f5f5qs9/f1fS+hsGo9th5YUHRUrL1Whmb3JAPe9GZT3aVrDuwCaRoTHvL/ZHl5gl3h0rG9Vgk5A017ZUhknbbIpsa+e0ZOs013FxoPn0CMvAM7IO4TWuLn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the contended_release trace event. This tracepoint fires on the
holder side when a contended lock is released, complementing the
existing contention_begin/contention_end tracepoints which fire on the
waiter side.

This enables correlating lock hold time under contention with waiter
events by lock address. Subsequent patches wire this tracepoint into
the individual lock implementations.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/trace/events/lock.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 8e89baa3775f..4f28e41977ec 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -138,6 +138,23 @@ TRACE_EVENT(contention_end,
 	TP_printk("%p (ret=%d)", __entry->lock_addr, __entry->ret)
 );
 
+TRACE_EVENT(contended_release,
+
+	TP_PROTO(void *lock),
+
+	TP_ARGS(lock),
+
+	TP_STRUCT__entry(
+		__field(void *, lock_addr)
+	),
+
+	TP_fast_assign(
+		__entry->lock_addr = lock;
+	),
+
+	TP_printk("%p", __entry->lock_addr)
+);
+
 #endif /* _TRACE_LOCK_H */
 
 /* This part must be outside protection */
-- 
2.47.3


