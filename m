Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC9FCD6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F786B02F7; Thu, 22 Jan 2026 13:25:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6F46B02F6; Thu, 22 Jan 2026 13:25:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6EE6B02F7; Thu, 22 Jan 2026 13:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C4AB26B02F4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:25:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 776D71AFD31
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:38 +0000 (UTC)
X-FDA: 84360427956.22.F456D26
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id A914940002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=evo7g+qm;
	spf=pass (imf11.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLuXLGuYqjOpfqifCcX9gqlKz9yHXRh2qxv6VaQbihU=;
	b=p0ic5xyR3oprQkdCqzD/bdjDg7M68p8oYP8WTyuE0d6eNwXn0neyAYYoMKrULIiV/0+XJt
	LWZxlgH2Pcl+xOFne7HhoE2rOhKHiEKaVztgahcwea6ssla9SSknhk4ousZkf7duGQLKzJ
	ltHqRfxHgeNQ/AdfvTXCNZlfp/FEqfA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=evo7g+qm;
	spf=pass (imf11.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769106336; a=rsa-sha256;
	cv=none;
	b=TbDyueM20I+tnmvbcT9lcDkye1FFzNFY7nnIcUhVS4RK4qxlyHiXxxoDMGRAzBq3YYfSB/
	Sazd+djl+W/rQNLvipSOL//ookZ+xPaEOec/5YNjt0pokaDuVsf8Z8X+Nzh8t+o9Z1AiZf
	QR8R5CwHM1zvu1FmJmMWL7j+qvLqLTA=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [4.255.188.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3D6CA20B716A;
	Thu, 22 Jan 2026 10:25:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3D6CA20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769106334;
	bh=ZLuXLGuYqjOpfqifCcX9gqlKz9yHXRh2qxv6VaQbihU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evo7g+qmB3X7dHYxjsirQj1/j4/hhcpk85GtEb8SV1ZJLSKal7dnV46Gga5tq1Thp
	 SnJkz7eAbwqhrT3z0ylZx0e8lvUufpKQt7SZLWa5uT3wfpIx0wM4hubdw6xYB9Rita
	 e6fj9SVes/fGafu6fWjCx3l65mMLZUItIdzojsyk=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v5 1/3] tracing: Add __event_in_*irq() helpers
Date: Thu, 22 Jan 2026 10:25:08 -0800
Message-Id: <20260122182510.2126-2-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260122182510.2126-1-tballasi@linux.microsoft.com>
References: <20260115123809.2257-1-tballasi@linux.microsoft.com>
 <20260122182510.2126-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9wnowpmi9t31ehpxoymy85ig771u66o3
X-Rspamd-Queue-Id: A914940002
X-Rspam-User: 
X-HE-Tag: 1769106336-696517
X-HE-Meta: U2FsdGVkX1/CWKArxcKRu2+JbETX8b8HWaTAVSFdaj3nHNLuqiPZqb4eHkZvA4k5DTd+yJs37GFOft5b3b8N3FMQD6pK2FMsxkYnNauJZwN4iYMbTSyzPS23fXjIKzBbAazhfQdSVoaUaxScMmePNgI+5eXZ+mjbXt0axb6XXkHjUgaSVLvmW+P5TurzWuaSHF8EnPKhXmCDuByOHV0dXFHVi/JDMWCJTucWEoCraBAAa9Btnn8+6OmB/cnawG98pVWMrWayldg9QHKCgMqjA0SnZWGsA32evMYg74U/tzmHeWxNGX3GOFHe1+XcICtFaw7zDKrBhTHxnqvm/84bR+OzcRzXvYWbc0mGwE+YQfoF1zMcxXNtCuVDXC+GRaqhKZAbH6MFlMJ6r2T0+NzuA99tg1l2m/rc5sJ3K4lc4J2DevooVt3fjz+rhLAhR/QPEGPfd9DBzHuCTXBCVjHiKxPTWk9w/Sza+DDWVC+I5E6mRUPkRwNK7UORcvv9vfHjc1QXkn+Ju47ithieGka2oh3T84AhPm/49eUjvWW/LEpoRUCMGNZr9vkmwu0nd7/j4mVjGJu7yXUAp9W9gfPagNp4tAVrQcyBACiqUpL6SSuyJISg+I6FlRHliZ6j1TtUhc+H5IxEYUUqZA3lzXauYokrAm1zXXmrpws51rTe8yYcImO9mWlJqObxzOf5mYAJCHsBJpWjIUbCykeuC1XF1KVpMAHNxcwo0kU6EEHIwjXRtzob2uzpqxnmJzryIBUX2sftsBVkCS7ZiQs02PGdcM+0CzDPEU8D2uBI0fldEa/iNleXhQJxtgFStPMLHHFUWC1mrEBQH/X3AhQrlIpdqNH8/FOK8mvCjAxVcu1zkSxs09j3XHIOC3ayvSJgZ5Q6vbRB6F6K6HrFodgHRA3gigULpiGyjkqLO4C6/EJkylUZR7uIPR3VK5NhRtzkM59bmv08Q2yhC48Fqefymap
 zzNcQdow
 eMxTEpSj/fwx/zoiV8aCIW89x7ALwKmTzsAduCoe6rwXxQdOYPnaK/KkMuUi2/XAnFSn5Sje9SzhG3X6KCnV8JY+imU52YWiQyCU8Afli4O3GIVFSQb10qItv9YgUG+BkCpQbeh1/NwvcISopOxEvJjygHP4Fc6xHEpAjpssrK/qFBL7TyE4Z8gtb73WH0g+VlSJ1de0626Mw7aUL7XEUSHRVn5QUANs9EqKUNTftc1O+H9b2YVPKp2W+U70gkX+LmQ6XHiaVuNY5QWrYp/13dyUFupb9Fvy92gqougXomQRuGeer+qMc7L1qBR0m6Dyub0CVHIc9onlM6BFQxixp2PAW6ezi66/p+QywDUJqJRuJLhbnZ5QWhzdSwmE6i1ecy33x+Taz9QMEwT0=
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


