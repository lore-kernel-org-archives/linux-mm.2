Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1653CEF99C4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 18:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E27F6B0095; Fri, 13 Feb 2026 13:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FEC96B008A; Fri, 13 Feb 2026 13:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A816B0093; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E35C26B008A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 704768C0A4
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:15:54 +0000 (UTC)
X-FDA: 84440237028.01.7220B48
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8CE361C0011
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:15:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="s/uoTY8O";
	spf=pass (imf21.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771006552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBhGcVGQzLcxEriw4aHy/JmXaaUeJbL6slcdLo5NTL8=;
	b=7jn2DGIi3Hrm6MaqErAoB0Nt515fXd59Uan4DUBmwUPnmcnTFDpAmeZk1hVFRcS5dC7t5v
	fuRwS7tSote8SSCIWJHFmh+l+p9Jk00yWzh+ee5OukluCG2fo0lNZDHSptDMRVvRJ8wglI
	cHZH/aZ++/U6MItuADAPW/HNxywDghU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="s/uoTY8O";
	spf=pass (imf21.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771006552; a=rsa-sha256;
	cv=none;
	b=F0Nd/RbLvS67mKd/Tgfw39w6nJE96/WK+eYaMCA20oKMEoEpWoz+1SArJQA9/2EYF1x6lk
	v4OKwDNW/Zg3dgyoY8A1trQhIRWOqPwCbK8PLFrqb8gHc65TWGy6qGyA9kIhHHuFSu24ic
	sUSpr7nHOPF4cXFVfXe3DarK4TeR8XE=
Received: from LAPTOP-U3CCR7C6.lan (unknown [40.65.108.177])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6AA8620B7167;
	Fri, 13 Feb 2026 10:15:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6AA8620B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1771006549;
	bh=DBhGcVGQzLcxEriw4aHy/JmXaaUeJbL6slcdLo5NTL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/uoTY8O6ns5NYo/IJygvGFba86qVNVtaqYmw7iDfs0K0V89KJ9sxaIKCcbcBJ//Y
	 KdQ+dlt2dOVNvguirw2i2utKh6Iv8g+5ft1opF748qXA92sNyvTqs4uXtlJiwo7ukS
	 kLsEn6dgaisexFyAPcqj6ftB4p35m/l6sPF0n+7U=
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
Subject: [PATCH v6 1/3] tracing: Add __event_in_*irq() helpers
Date: Fri, 13 Feb 2026 10:15:35 -0800
Message-Id: <20260213181537.54350-2-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260213181537.54350-1-tballasi@linux.microsoft.com>
References: <20260122182510.2126-1-tballasi@linux.microsoft.com>
 <20260213181537.54350-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8CE361C0011
X-Stat-Signature: 63zfibqmyz4osd39uxei3q66eyfajpw5
X-Rspam-User: 
X-HE-Tag: 1771006552-665835
X-HE-Meta: U2FsdGVkX19md2NQmUqqM/ulv2VdBhHM7ZYgAAwMLjWSo9jq7UDQ2R44jrYVghKkZ9Q0rZX+2JLpcZM2FDlO/N/4Xc63/SDm8E4N6VG/7Vdj98iyGErSf6Q//Cyk+nHSNbj/DmawRjq9i8PSftdRzE3QKf3rByLjwGICaYx7yy33zOfiEnSNEibKF6cwoOA7c3SMhe72qWzr3ynfQb9TwRIFifu8rtQ0CzT3ML+HvSfh+0mjMChq++K3myH6SA6BGHy5PXaMS2LF2gPq/Z5us0AyP0UE7tqieM/uwFgPJV86ede/JTx643/cuu2+3NdDlde9kUJoe32mVhHFR2TOGNjJPeRxeYDDJjlfKdNzElQDf0cR2d/JMdWaktd45IVhDVsCLj5Z6bHhc0qYJZgNsaXrahhKECoRfg3gSxMuAn29uRF/YoQySQFF7OX8M9TcuuZ8DKsJbx3pnoC1m0LmdmI9pUnE5Op3XtjUcJPdYr8OE0s3Zx4xQW1bryVZUkpy2wO6ei1Dii6eidOm/2yU1KECHO5BNWLPJ8O8v5A9JufruHwHTxU8AYfyyd015SUmu4sUFLHN9KhpNfXCFlQ9IQInBpvnlU0lwBngFEnWY4lL+O+6RoMpApWVra5HE56dB4N8UCnlYa0ba6Swm1s5y4JStwEN0OkJJkxnft89doRn4FE7RPm/7/IoEKFdO5W48rt0kITkHVaAPdEYWzqI4InEmmnwJDDaqOaOESdAYv26ajEXpK/NN6r4l3jTZ8/8FiEocL8wEsw83tMlMqkaSdLQOAcN+kxKIXKANpMV2y8sMlbF2NQb6v67ME50yTvuMU86KKicy6JDaYQ1UatTQgQYZ4irBDhYW6yVUvWwj1h6Y/+LC+7cKbR513hYC3syvAsYjQa84T+w+Yvo1CNRTSC2dLTH9t8nXteP0REXk3zBnvoE2CifTRFXo2Zn4aOz/Ab1EcCfTLEBea+2T3G
 /yyAJ9kJ
 Y1O4xGrJLt1P186GKqEXySYu4hWwHd5q95IlQ8f2X2UrGreoIFD1ztgC4uPqiwEf1jNJdLzmRBi7dTHOiZBG5+dGjUpZStPfLLKzXf7KxlWO2kfRcnO5j3kOzk6UaZs/9EhWbugsmtm+lCbswm4jXgaNUNX9wx5lS/F7SO8UghE+l0qHuACSXF8kV1Hj0eZpdF4gjey+xgMeS7SNMIHYIKFKGliBKR+9Qi00QbyBgszc8+oDiLrTn67SeNw6t2aVz/FuDUadYMSeGd5TPITO9NMwP9U8izVpQVYW7606wEz9airrw5Rp/4XajsDzJJCf+bO5mCgjhTaZ/4u+4ulHfe2g5mAeJMR0I2/71OVCHEpbupbhT+AVylssDXSI7fRLZt1CsmBODMT+S9GeyPXj2x+PMt1lypaAcZy4b
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

  TP_printk("val=%d %s", __entry->val, __entry_in_irq() ? "(in-irq)" : "")

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


