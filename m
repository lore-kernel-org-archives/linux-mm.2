Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7181FEC1112
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420786B0089; Mon, 23 Feb 2026 12:15:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E656B008A; Mon, 23 Feb 2026 12:15:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7F56B008C; Mon, 23 Feb 2026 12:15:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECA996B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:15:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 794921A0295
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:15:52 +0000 (UTC)
X-FDA: 84476373744.06.CD62A9B
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9F5AD120016
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:15:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=dlccHxcU;
	spf=pass (imf29.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771866950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tDG0Vqu0L2dWt0Ah3NuZCNTihscrZOnULxwzHOcg9I=;
	b=JWGGCaWwVwSI6Q9if3I+ekfKxTTX6/MeZJ0hj6uQPiSsxEajh8CtaZ+Iln9Gz3W/MgfqE8
	afS6MS6V56G899E732fG9eyCU6c0Qq0wwI/p4Q2CZBaH5u+W4BXG1Akwfk6mvTmQ1vTEze
	f+uVI9kxoVVDOFCv6Qw4+UB7NtThjns=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=dlccHxcU;
	spf=pass (imf29.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771866950; a=rsa-sha256;
	cv=none;
	b=S4XAGhDQFxrAAeGAdX/lU1p9MgJsNGegpcroPPHk1KO4p5YcPRxjxXIuuOulqzr3XdLomw
	AK9zrE1lvemtKj0pZHZufPsDf3FM12f6keEWi2hgp+T7lZ958iix+JZXBBZFz9glP3MPtV
	3oC7OAszmY1VPR5Fb/dpGRRZkUoAJZI=
Received: from LAPTOP-U3CCR7C6.lan (unknown [20.236.11.185])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5002120B6F02;
	Mon, 23 Feb 2026 09:15:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5002120B6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1771866949;
	bh=9tDG0Vqu0L2dWt0Ah3NuZCNTihscrZOnULxwzHOcg9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlccHxcUudJ52u0UKNF+Do4qyYCdpGUxzQFy66W9ztmYk39jEurfuQzYLBB0bxV35
	 r7d8yi4B8w6LgoTCXTsjtu7CnDSwagHRnDqWwOB0dYdmNiRhhQF6Rr2MUqf8xGiOjf
	 CdAF2Gs/lSBYozs+SJOV5M2fCjS/iOXKGbs7i6wk=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: [PATCH v7 1/3] tracing: Add __event_in_*irq() helpers
Date: Mon, 23 Feb 2026 09:15:42 -0800
Message-Id: <20260223171544.4750-2-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223171544.4750-1-tballasi@linux.microsoft.com>
References: <20260213181537.54350-1-tballasi@linux.microsoft.com>
 <20260223171544.4750-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F5AD120016
X-Rspamd-Server: rspam02
X-Stat-Signature: fk1e5y3dg6p6yh669zy43tpyifiq3kky
X-HE-Tag: 1771866950-193460
X-HE-Meta: U2FsdGVkX18lO+58qUMPJnQzO2q4AlFgyKb3w27LkT15quwL4kqdjFx9j+JltxhhUwhQnt/EQXGRgewIy28LKtWE8QBR3l9S83VEaeKQW8+k71kIQLjewZ0J2MB/VenvRBtqUuy5pMZbShL+O9fhrnVBTTe32ldJuIy84RnJl3/BlWcgckxv3eMBEItXQzFjOvMjCVfpZSCBPLJKcKG5Py+UXbkN3dcpe4N/NB8L73a8CzWBeN9V8JMbRyvQudJD0xlDpI06k7JhCspN0Tw9EBnHHEcc13KaPnnsDcgvrWQBGBkGYtOe6Gt3yX8DRD9sI6o5pRLBwiE3o/B7glxwrXp+gG7XVZHtXjWTmQ/bOPreY1iSKL8t3HHzJy51IlfCYDUZMtXOsQ7jgd8zDZhsMEqmQzYybOw8m6sQd6yj7MA5OAWczl2A0Qy9Mn4nTJWkOmpD6btACfCIbiAcCit3E3FL3y9FzpgZjKuoodzWPCBX7mzGWfCUyw6y4I1aLoiWSHZ5yQloVA9f+J85/kv47yu6DyIy0oYAngiapWN6cVGIo1vfp1YLUQNtruj6crVBDInzemm31LnfPJrnGjrzH93wUM9hkdfDd4je2+HIMcFX/I+6TVwsJvkAJDb2VvMR6a1xlaipKvlgBp/4CW55etB5B5doPV+Akd4AAtRoB2dioX+55lby/rPowS8GMJMnGKl8MspEn4F4bCgZkWFTx889gzmHfe2Xza+RQ5k3qCXnJRAnBRXcIwClKlvEnyags1PWwGoUOh/knFYOOfAhJ2oAnrsyV/gEJnIetD/DcmhWmMKP2lYfQZcUOwQrPKwupg9IvFKcDtofAHszo26mj4a3vewOXkW26gqt3HPe8+xjImN27Br/ApERnWvDoPmxxCxpxKOVeEVIgotDdq/aGVD9rtNYa1i+JYLy2ibr7zHGnKpQsJydl0Fj0wpMCRRtTv3RfE6qiSLvT3GCmx+
 k2hW9gmg
 pfplfXUvshV6+9rZwG4ZiXHKIJ8yJTTG80TWYmSqkHewfrDBxy7YelL0PMb7k3BAPQzo71pe2LQx1bPLqm9LflnEod8R5QqGrHcsqiycdrK7bHPfPWvgXa3AVbl6J8V1yeI9mwylffy7YFZ/cd4y/MZYvBidT1eUGMn8VEaYyHGRDh7fm0I08YGNWHpOPV2lUpIjN/z/3RF+mqtN5PcmKnY3aV+mT2PJ9bltwt4BtTnj9mjso/oB1TZ8NRROMHLm+yM5w/RzTSZjrZ1HeXriosk7yOHdP8xkkZKM4kz9hwaWXgxoZYak0W8wGyLiqxOjtqs91+sdkl0xh+9d/ppFEenk+88xOR4XwRrHBQXxZ0DzAmZledub3mBiKcG5EOjShP7AyIUaFda9e3trt3tlrutjLBglf55PXt0Zf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Steven Rostedt <rostedt@goodmis.org>

Some trace events want to expose in their output if they were triggered in
an interrupt or softirq context. Instead of recording this in the event
structure itself, as this information is stored in the flags portion of
the event header, add helper macros that can be used in the print format:

  TP_printk("val=%d %s", __entry->val, __event_in_irq() ? "(in-irq)" : "")

This will output "(in-irq)" for the event in the trace data if the event
was triggered in hard or soft interrupt context.

Link: https://lore.kernel.org/all/20251229132942.31a2b583@gandalf.local.home/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
---
 include/trace/stages/stage3_trace_output.h |  8 ++++++++
 include/trace/stages/stage7_class_define.h | 19 +++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/trace/stages/stage3_trace_output.h b/include/trace/stages/stage3_trace_output.h
index 1e7b0bef95f52..53a23988a3b8a 100644
--- a/include/trace/stages/stage3_trace_output.h
+++ b/include/trace/stages/stage3_trace_output.h
@@ -150,3 +150,11 @@
 
 #undef __get_buf
 #define __get_buf(len)		trace_seq_acquire(p, (len))
+
+#undef __event_in_hardirq
+#undef __event_in_softirq
+#undef __event_in_irq
+
+#define __event_in_hardirq()	(__entry->ent.flags & TRACE_FLAG_HARDIRQ)
+#define __event_in_softirq()	(__entry->ent.flags & TRACE_FLAG_SOFTIRQ)
+#define __event_in_irq()	(__entry->ent.flags & (TRACE_FLAG_HARDIRQ | TRACE_FLAG_SOFTIRQ))
diff --git a/include/trace/stages/stage7_class_define.h b/include/trace/stages/stage7_class_define.h
index fcd564a590f43..47008897a7956 100644
--- a/include/trace/stages/stage7_class_define.h
+++ b/include/trace/stages/stage7_class_define.h
@@ -26,6 +26,25 @@
 #undef __print_hex_dump
 #undef __get_buf
 
+#undef __event_in_hardirq
+#undef __event_in_softirq
+#undef __event_in_irq
+
+/*
+ * The TRACE_FLAG_* are enums. Instead of using TRACE_DEFINE_ENUM(),
+ * use their hardcoded values. These values are parsed by user space
+ * tooling elsewhere so they will never change.
+ *
+ * See "enum trace_flag_type" in linux/trace_events.h:
+ *   TRACE_FLAG_HARDIRQ
+ *   TRACE_FLAG_SOFTIRQ
+ */
+
+/* This is what is displayed in the format files */
+#define __event_in_hardirq()	(REC->common_flags & 0x8)
+#define __event_in_softirq()	(REC->common_flags & 0x10)
+#define __event_in_irq()	(REC->common_flags & 0x18)
+
 /*
  * The below is not executed in the kernel. It is only what is
  * displayed in the print format for userspace to parse.
-- 
2.33.8


