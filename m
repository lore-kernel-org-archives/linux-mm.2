Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4349E92FCB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 18:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815266B0088; Mon, 29 Dec 2025 13:29:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7988F6B0089; Mon, 29 Dec 2025 13:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1FD6B008A; Mon, 29 Dec 2025 13:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57DE76B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:29:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C98D2C20F1
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 18:29:40 +0000 (UTC)
X-FDA: 84273346920.27.8D0EAE9
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18F23C000D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 18:29:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767032979; a=rsa-sha256;
	cv=none;
	b=DDU4OI+SgxT05LGgiMhuKW2OteIzvDwy0o5qN48m1ZvFHVnO7PWjX+rdwQGSzHgfjzWcFj
	0Wc6FWFdh1rw0BOGa9lEntiZzKpvuspY3umrajqDgXEIgpdH8ZwEs5iti7qHIZ0Z++NiKv
	DxVFqNTT6oV9KuCiax6h/ter7Wv9Ft4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767032979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PrXXPGTpWnxmPp0AsZ60fslGBCDmDlkCFxqGz2l1IXU=;
	b=bC9wVZuGTrtGXMfqvmHVWc1R8yrZ9AQLYAEKGFz9ac2hfl6/zSAYGGEot0LFmpZoTMXBwV
	O/iOU43//k74wNWhTi54wLS63B783dgz+VPvLFzgGi2bc+xbm/nHpwJ54+7mDj6GJPhZVs
	XdvPKScBx03zHDuLBRszPe/m2aCbv/g=
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 303EE59A0C;
	Mon, 29 Dec 2025 18:29:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 7A3832F;
	Mon, 29 Dec 2025 18:29:36 +0000 (UTC)
Date: Mon, 29 Dec 2025 13:29:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org
Subject: Re: [PATCH v2 2/2] mm: vmscan: add PIDs to vmscan tracepoints
Message-ID: <20251229132942.31a2b583@gandalf.local.home>
In-Reply-To: <20251229105427.14720-1-tballasi@linux.microsoft.com>
References: <20251216130302.5202ca81@gandalf.local.home>
	<20251229105427.14720-1-tballasi@linux.microsoft.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18X0yaxY/nuYiParjAbf7uR2X56SJVmoqE=
X-HE-Meta: U2FsdGVkX19+vMrYqJreb8g9AH/d7iocmx6izFefRJgUMGcZ6pRpl0T0gATfc3vgSaHQvZuwrgZFi81dwYrPPgkXujotpa/+Y7OlN37CpG2XlT/ADsBhOFP6CpKwmdPn8m1w4XqD7hRovBP0Ymnk3DkGm07XLbBCg7JgqGPExuZJz1kZcjROtwAoSjFaq5b5AlejqUZkh92hSnppLxVlfvGZShcGBCKkk0CQ7+//J4ii0hhHwEVVI6bs/LgqSGibLQbbzGygz82kueaURx05JpKBpPdO6XjRXfPha2SXldO7XlZCJYFJ6z86LJOmF1p7cgHjLNyv2BooB4U5UtftN8642ywAPV79
X-Rspamd-Server: rspam08
X-Stat-Signature: 67i4cwq3smkgtxebiitjw3tg5d747mm9
X-Rspamd-Queue-Id: 18F23C000D
X-Rspam-User: 
X-HE-Tag-Orig: 1767032976-144404
X-HE-Tag: 1767032978-750333
X-HE-Meta: U2FsdGVkX191Q86DHtAFs3BilHji+VMq5XCqzl67i3kCzCYrBIU9dY/ODe5Jgs+X99GVrIZ7QA50yeOXuRt0s2FtVkr5wr6LVO+M4pN7WHr4SEFDWFIxXeWShVcF5qC9+LdOBq3un3sYUOrpGHzxV+cK8gMbtZkrecCx9cX83b5WkiPVhrAzzyRWf6H/BoBTRO3DXwG+8w6dJwDeBoc7NVoiPjfwvKOIsf7gB201MzRo9VjXWsn8C6uKhpyix3cSWSeT8X8ja0Dv6c3heJy9pd0dIxOJ27fFw9RvOTuCEDvIdH9GtH7tNhuxsH9GHerTw0C9p+RFBqiG41jAcSb/tQTRbXxxZzWgnrSeyFAn5pGTc3qe/G/9Lw8BWwA30Wb6CqO1N1QJzC6PFnQsCpawAuvgGS06m77WhC2aAqe0QyxnrfdsibsFh5LTmwNrkr0eDAUdEWHPzR9ciftiJ2Iw37MNfzwQrBTV91HeT5LK+OjAGYGFY0M/7OpzbXm7Af2H2lvM+OQM8pUunFA1EpjTqb68NwWBl/4RGfomiDYqb6izJZQ7I9Y+y0/1nKgdjTboS45DsVyOgPZyiSDfRyIjIyCuyhcNN7AjacfoLfSlC/W0L2YS1A9fVuSCzaoKT8DrOkeMlkAepP9/+LlkDrpdBAeLbYQiY9UrrrDsh2DdcRN+eaI3QS0QP+0NzZNRxUpZXVh9BnyItooQ1KKA7cHM5vwhsMRlRG6KkSubZIBZCfoeElwUwY3QtdF5FSG7/sLgVM3v3dokPOPZdzjKR5jKtQMCOpYwW62PQ9kUDP3fvDp30Jtoajha0Karv+DiG93o4BaM2+PkxJyThHxByF9ZdgwzjmImguXQeDHT/rFEHFcdOIln5b+MtiGt9swHwmCZpuz2HGJxoq7cu6LxoV30JscwdeaKLpvR5LZZuUFhGcy7vbDOHFeGLll0KPRX9cI3KCJKIf9iomg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 02:54:27 -0800
Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> It indeed shows whether or not we're in an IRQ, but I believe the
> kernel shouldn't show erronous debugging values. Even though it can be
> obvious that we're in an interrupt, some people might look directly at
> the garbage PID value without having second thoughts and taking it for
> granted. On the other hand, it takes just a small check to mark the
> debugging information as clearly invalid, which complements the IRQ
> context flag.
> 
> If we shouldn't put that check there, I'd happily remove it, but I'd
> tend to think it's a trivial addition that can only be for the best.

I just don't like wasting valuable ring buffer space for something that can
be easily determined without it.

How about this. I just wrote up this patch, and it could be something you
use. I tested it against the sched waking events, by adding:

 		__entry->target_cpu	= task_cpu(p);
 	),
 
-	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d",
+	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d %s",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->target_cpu)
+		  __entry->target_cpu,
+		  __event_in_irq() ? "(in-irq)" : "")
 );
 
Which produces:

          <idle>-0     [003] d.h4.    44.832126: sched_waking:         comm=in:imklog pid=619 prio=120 target_cpu=006 (in-irq)
          <idle>-0     [003] d.s3.    44.832180: sched_waking:         comm=rcu_preempt pid=15 prio=120 target_cpu=001 (in-irq)
       in:imklog-619   [006] d..2.    44.832393: sched_waking:         comm=rs:main Q:Reg pid=620 prio=120 target_cpu=003 

You can see it adds "(in-irq)" when the even is executed from IRQ context
(soft or hard irq). But I also added __event_in_hardirq() and
__event_in_softirq() if you wanted to distinguish them.

Now you don't need to update what goes into the ring buffer (and waste its
space), but only update the output format that makes it obvious that the
task was in interrupt context or not.

I also used trace-cmd to record the events, and it still parses properly
with no updates to libtraceevent needed.

Would this work for you?

Below is the patch that allows for this:

-- Steve


diff --git a/include/trace/stages/stage3_trace_output.h b/include/trace/stages/stage3_trace_output.h
index 1e7b0bef95f5..53a23988a3b8 100644
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
index fcd564a590f4..47008897a795 100644
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

