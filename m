Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E95F53D6E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073E76B02FC; Mon, 16 Mar 2026 12:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018646B02FD; Mon, 16 Mar 2026 12:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46486B02FE; Mon, 16 Mar 2026 12:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4CFB6B02FC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:09:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 575A41C297
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:09:25 +0000 (UTC)
X-FDA: 84552411090.28.FE88241
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7163B140014
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:09:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=YMlaIPac;
	spf=pass (imf26.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ypitji6HvLgh1Bouw6IlwmBShM4FKdmCgCPJw+u+OU=;
	b=5qUKu9mTEXNoXuOef7kKKABgAqFIaA7zTQOP5bD1PsLnJQ8JKU4nFXAIXnBOqf5P8hckYx
	PNPcBVoK1Lp8WxrYSjvVBUg3eeFZ/LjUvgDZdn07kq1Wi/AjrpZfYjavyQmwiP3G1HwRuv
	VMM3LcDK4A2/DLL9LtDwh60mPWcSBgo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=YMlaIPac;
	spf=pass (imf26.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773677363; a=rsa-sha256;
	cv=none;
	b=6gtVO2v1GOc+BiYAT5K0kh9AH84YT00CP810V+RP52wvSgcZsfOUMunxh6H2z2TmZX3TwB
	qX1IshZYr8voWz5r6/ocFmGvPTcfMXkl6KesbW1cLpS/gKGNhw6UPXIXb0msHpDRECdiVJ
	9vrqS3/g1OrX+KLtjI4PcxA69VIcMXE=
Received: from LAPTOP-U3CCR7C6.lan (unknown [20.236.10.206])
	by linux.microsoft.com (Postfix) with ESMTPSA id 213CF20B6F08;
	Mon, 16 Mar 2026 09:09:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 213CF20B6F08
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773677362;
	bh=4Ypitji6HvLgh1Bouw6IlwmBShM4FKdmCgCPJw+u+OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMlaIPacVDH8XinFWvGfD+ZOrL+OK2JD0Bwcg+887X7/enfYsmn6E29cmvqijN1dw
	 4ZED13DS33lrW2YY92iRqpvOTB8wM1fiSQhFYod9561NR247VvAtYPbzdI5cVuFeSV
	 WmTHhqFTiWmXwwzHutNI9wipiqFqL8cj+HDIFCs0=
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
Subject: [PATCH v8 1/3] tracing: Add __event_in_*irq() helpers
Date: Mon, 16 Mar 2026 09:09:06 -0700
Message-Id: <20260316160908.42727-2-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260316160908.42727-1-tballasi@linux.microsoft.com>
References: <20260223171544.4750-1-tballasi@linux.microsoft.com>
 <20260316160908.42727-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7163B140014
X-Stat-Signature: xs686t19mtjsq1ib51jao5n6fd5ckf3z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773677363-866888
X-HE-Meta: U2FsdGVkX1+fDNTwgzQq2aawxe1L3f4qyJSXUnBFXVwQh/JEqsudilIcgLqLcJjCtUnA1P8TVGTvn/Y5/oAkH6xDt2Jh4CyGNC3wxhKSzxT27LaRJ/9ALSqyOOMiThru1KpFGszkrh5HP14ICzk0h+m9OWpXeXtGR7U3pDfMhC3TuSGrrr5/UYNryJDu2rX3qa/+cAcZC/mXR5qgBpgCrhMBNZlfSXAViX1Aav+LA7DTwJDOw7fdxSuLHXO1hoxy5BxnXq9iZ92ZOMlKP2LezGBtWhQiez/e3sib3OF9BawwSSLPAjdEkbn+KFyxFPMrVMjEO5kQ7OaWk+DWQk96VBipeOcUx1dGHVwQ6uW6ls2JhsfK+ol0TFg8YsQsByEwleQLf6Be7pgXgCWnecW+CWR7GZ+P0gqVN2YiI34HoLMhpJ0CowVIli7kVu4LoVcAs3qIcEfbsrcGwXPWFwzm93m6OehcDkqaKYJMqcZi4cHZ95eKdMe/Fq+wt67F5VNv3vOs1Y/GizCJBArLAWwDTn3sGJ8Sl9iYKXzMw/HGkivPtfr2Hndcq/t9Gb2g+HXeVgLdeYRs/KI4EQfQDJUt+XMo885ASRuzbdR5AjI6Mti+hL3jfziEhTyUJ5plRjH3jJY1P08kcuGhkvxjdNL56GxdJgaWwRVJ8SlLHC4RNyCYzZSPX+kt+hqsylWHmWty0FTru1g10pJkMCiki3K7FT4at6olcgsGCiQk519m4RgGrOOgwBBhjQecO4+pvIXsfYt1wOPEXIdYz72DxbGQ5XVJkC1jnUlAo7foDEzU6TIXZFf/Xy/7Y4/29MwJRxlp1HMgf+7QJToI78BoTaoxqaUnVASpv29g6kpkzBoMy8ID3ZWg2wKPoKnHHYB5WO9hj5SYUbPLQ5YoEXohPdenlpKbVgC2TOff7hyB1ZeT+hsmJf/dWUGM2afQ+2yhNoRO6cKzb89PIR3Jpgqe5L8
 6Kpu+Uhs
 YKeS77AN62YPS1IBUy3GvjCiN9F8iIDe9yk1FMkxvWUM/86HB6XX8YztwXPwZ+A/5AYZrVeeaDVM7w6tMMBAIScA3xlzdHNK0VG6jh5KeMcDOJSLch70SLQrstbIu1gRjUo3ecCJBxOZLmmGlLi99uUE1nppeT/mqg0T/tTw5YDK6wmcN9raPeKZWKZD9ijT7gxwh6bKCZsSFCIiVs5gqsp2amMLyw47Aj4J0NRHwIQFvksYkJBge8WnmaUkm1m4ZWCdS5KKjX0ADZmwC8Zog9hB+pTOB58+NOWswylubIZBxYqTQ8BzXd8usUqNoia6hjJd38rVzCeWGJFIIObmigZD7RKRE+z//7rokpv84rdPNp6KOoX1lhOzisPbjWK25BWNQZ7S9W/LQaJ59kLmDDQuL9wXRgnDRjN4O
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
2.45.3


