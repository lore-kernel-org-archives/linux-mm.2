Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD3CD4117A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506556B0089; Thu, 15 Jan 2026 07:38:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5C36B008A; Thu, 15 Jan 2026 07:38:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B85D6B008C; Thu, 15 Jan 2026 07:38:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CFB76B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:38:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7785B852A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:38:20 +0000 (UTC)
X-FDA: 84334151160.27.74EDEF5
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id E2960140003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:38:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Lpoy2OsI;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf09.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768480699; a=rsa-sha256;
	cv=none;
	b=11lszEjcOXWMuScNTwqwC+PofoeqmfGTpdMC8Ei0hozlCkXvOSWt1vCaGFOmJOwkpRLOW7
	kgckLljv3fEH4HBvKUMWaYs5BVgPfyEI1vY++29ewnwKxORUborVBh7lJZgpsYjjGmcsJu
	4tskynP5jNxVG1wt3b8Q4SgcnRCFAl4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Lpoy2OsI;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf09.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768480699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLuXLGuYqjOpfqifCcX9gqlKz9yHXRh2qxv6VaQbihU=;
	b=xSCzY2SDTlXeHcXu2ExlXKqYQ0cyaA+bpbGFfQdelGRbOl4/x6YLGdIX2uPJ4rj6PjKYm5
	WSqQScU1XrWxOnWXEK9otwKm+eyeN92M8MNbbhVYf3IeIBf3YeZUajQj180wB7Viw89si4
	2O3XRLhsFVn3pY9QPLHX1AdW//2Ejcg=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [20.107.46.209])
	by linux.microsoft.com (Postfix) with ESMTPSA id 49DF220B716D;
	Thu, 15 Jan 2026 04:38:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 49DF220B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768480697;
	bh=ZLuXLGuYqjOpfqifCcX9gqlKz9yHXRh2qxv6VaQbihU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lpoy2OsI7O+Q8sh0c5jL/Ecdn8WlwOj4K+3lBuh9CgRjXb6ROi144mwkEoVD7sWzh
	 pU7trF4xOJLiuI1NW4lYPbMFUzKiL+d/PcvcrTAxzxcHJeFsnHvtMsf7OoIpIK0bTA
	 Td2aIDfgdxqJkCqsGp6HFhTnERoKjSyrd0OUDJzI=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v4 1/3] tracing: Add __event_in_*irq() helpers
Date: Thu, 15 Jan 2026 04:38:07 -0800
Message-Id: <20260115123809.2257-2-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260115123809.2257-1-tballasi@linux.microsoft.com>
References: <20260105160423.23708-1-tballasi@linux.microsoft.com>
 <20260115123809.2257-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E2960140003
X-Rspamd-Server: rspam06
X-Stat-Signature: fyz1pjxnwm6sfqg6srm97syj43fks6x5
X-Rspam-User: 
X-HE-Tag: 1768480698-954773
X-HE-Meta: U2FsdGVkX1+q9MENms6kAF3U9Ey1i3UYnM2QHrq6B26x5aa4q4IFJNnJlEcBx3oo/U73cqWtpImoAGObcU2qSI2Kc8l2aWz+eQvUIzP5z4Amp7+ZLrc1HRw5zoP6RU5zkuaQ36hY9IMRQ/tBQgHFxn5DJsD4CO907dLeTcGelB2g4xN8+0CDfOfqCNFUS6VEAP6tLdz1IIsT2EFfTkP28q8MNLuq1TEQdlQmzFF9fitv0nTgDRK8J2raPv1KEyA8VH8Ee9v5GezX22CtJbB4ZCNE7WukUrG21zPnLxi/Ie+Z3RqlnqKmF1pUGsmfIcnHF8xEas944Yc/kfAgyJ1T0GwjmhGxGhCnu2qpEt4YkQxxcHhTGN3gLB5v7YXTYGtxuhrEHZvIxU1wMRzIBtj2pyM4GASu3PYS3PGQNxXarttgHe66oRstFeTB649yuFpvu5icEuItMlXaQN8w92rhlnw4g9Y4Q8Sbi/0K6ZINA51//kYutgjk0pgN+i2ncPF+SXWuuaGmKlD12QP+1zbzoxKsWnHDQsU/5yLfO0gxORTL31NQ4qYMYXFB898Z4rlZx4nuXH3rCn3gNKlPj1993vFMn/+kF2Y3+NA6bOZS8gYDa5m3tgDEnzFAFhqqYc5WZD355QBtLs3VcBQDDWCGMuZ6UMlqPl4vBUJMmo9mhmlsJi1vh4PHB6ch/U7UE5HbIY2PQHKSpladmbiLUt4PnbKhyToOKJSp/OLbRuJHuoXTLdUcvl5VeifJdGWMwVpTpyeAYzd/lJVG1Af9s9NW8Z9oF2B2jFbiMnxJZM2fnp/EOTMVKhnGryFFqcTkUyr3oUcVxb2Y9aeV2iu7tXQj86ORtIFT2RgNQlQPoOGzWCBYJeWl+/upD5phSNTERrzhdy88BBwTytedq6YwgGlCwfr2++3nv57vvz5FlM4RkUwDRoZtIrjWpKr8uSVxAxOjNa9veiIRRShrLOdZ2yn
 THZ9bbVb
 3XLJhxjDBiIbYSvltUukSBngrVf/d5X42Qiex7Yjd0Ip9d/eDDjgLdO9sEDLVsh2LQWskJticvBWOyTFH930Q8yHmHRbOAquzcFMEmuyfqNeLv52H7omb5Ywn5TyLhOHimhFy9o02z90Lf67lpOhvSMnU5iP3EO10xVQgFyICRMw+OfGMfHt/UBs/EDkIsAKmbKja11R9YiyUX94Ss896ID6CqsqcCL8n3M+xAggyQ7Yyh/ZH6yvCPwiCpF8+m1uWBOaJKAM04W+61SFi6gnmMonByvdoaNZYMNftmIlHeZiIV7k/kekLRCgSbPzLxYAbxtQYa8fLI3GNu0zVl/zWmaUyzHM5wszcZGx7mLv4M+iXUp2RISUKxpEHJOXjpG2v6oN+WSGHzhjzzi0=
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


