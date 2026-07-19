Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D1E7C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 18:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924BE6B008C; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8805A6B0098; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635266B0099; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 888CF6B0092
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:55:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCDF8C05F9
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:25 +0000 (UTC)
X-FDA: 85006429410.05.80F2A65
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id 82FD64000B
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=YnW8pALY;
	spf=pass (imf01.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784487324;
	b=Ge5zEKfPr6oR9pWiCR24pvJ6M3fiJsNrboVUJczzN5OZXTOUwClB1bJkIwZObMEjYF+Fn1
	WEqcPGaG+rAEa0tNv/eBD6Pb9eO/IDQdaeubdkAIBzHtCZ4gm5ipnA/P+R9dP2pYy9atL3
	RxzX9QG8TuSpilc2pXgT4MvZEQ42Bwk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=YnW8pALY;
	spf=pass (imf01.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784487324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oj9fDzX1wMrErAiwiqiXxnM4cGXgD5lIVRx7urULVtQ=;
	b=lmBIoVSdQenG8mQZjnaKHqOucSPl/DOo8/0OkiOtnTZcBlVb5htSN6UAv4cmHNGcHlzqNX
	JMBbe6cPQuJDYErFO818YB/yN1v6jPGX9zKBbU3D4gnqE6mnvkHilg/1pFMdQlm8KWs9ac
	NJpHRe6ve6j56eG7xrtC1cWc1UUH/YA=
ARC-Seal: i=1; a=rsa-sha256; t=1784487288; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Hg3KfhqrSbZ77reLafznqJhwV1LJSzO5mmcoXRp+JmqH1LlItiJruE8VW/W/1aDyRAoqh32F1e48HM1XC6ohw4TLFQjiziV78DYDC+bnMar0lNCcJK2p0MPrTBWUOPNklKb3SyVaCTNCvqhS7AxZdMjJFes5otKZ64i9Ee2gl2w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784487288; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=oj9fDzX1wMrErAiwiqiXxnM4cGXgD5lIVRx7urULVtQ=; 
	b=G/beN0jv6Q8FIOuAqbFFROOF1nkiv8xTb2iZishK3qidN0iSg/pHWKgLGCi2cSPRRcx/PoGu+D/Hc+EUabM3CYQA6LTskvx/cNIZAN2bvTTbmphlPzxx2NKKkjHZqVFiScJ0IqHidhneoVhmN3C2H+bfSgTH8Gm7dcMh+8nUiwo=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784487288;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=oj9fDzX1wMrErAiwiqiXxnM4cGXgD5lIVRx7urULVtQ=;
	b=YnW8pALYKS+7BrhWfZSMS4owuUZYNoMgUCQiPgBceYMAA9mcp7oH2vkTqn7Azxuq
	HATY+/+WkSG7WqveYQ/CJRAqclFelyYI+bNA/Ud7IurKaWNtDInCNL26LMPBf8xJEIN
	hKMVys2fVq4gSF0M638PiWT2OJ7rM3PdtgMuUWV8=
Received: by mx.zoho.in with SMTPS id 1784487286510813.0873877162367;
	Mon, 20 Jul 2026 00:24:46 +0530 (IST)
From: Aditya Sharma <adi.sharma@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imbrenda@linux.ibm.com,
	Aditya Sharma <adi.sharma@zohomail.in>
Subject: [RFC PATCH 6/7] mm: add tracepoints and vmstat counters for async teardown
Date: Mon, 20 Jul 2026 00:24:08 +0530
Message-Id: <20260719185409.409685-7-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82FD64000B
X-Stat-Signature: o83h45muw8ca15oh5u1uy8bdua77ihe8
X-HE-Tag: 1784487323-292063
X-HE-Meta: U2FsdGVkX183tiafs/72DQV7cbxW/LiaC/lpxfNZRZiaKKpuvVDn/LVnGm033OTE7U685fSPX6E+Hzw+fSgogeApIVN8Mk24g0qR1cD3KXK2s8XRl+zGLPjyibS6tPZz4T+2Kz4y/dHW+1XILNYz5r/24NzBWscqI3VTH69fWdh4ymX5lLmYZARLQLRL9QZejQomFZ7iOxFjMmIlCZLhgnX8XB2e6ljFxmK9yvxnHLwueUcvrqoJsNtzHnlYPaAikZwS1hvHttPUX7kFDIQiOx7+D5nucxh1vYc2lI71I+1Xb9Q+B0W7n7VWWR83QcuHcNb25hKT8RFY19GXVE3vTrR6e2N7bKj6Ios4tUae4nb8hF67LlmOuBnWSGb3EDOm2d7va9czjQ+OmWgsNwFItzH6WSoTQl0rdjXHGt5RXS+uEvlj29fy/0BMccalcYwhudgP0L92wQkDnAVO8j09PM9ee0gWgRaWceZKKt/x/jHbKxbQLetX4kPqYPt7zwAnUMdE4I5+Ak64d4svkm+RiRMnG+5qPSTtWAFMZyOA6v28tbzW7dL/9o52j0kPhNsN5iYvv/YByC5MWhY3aCWGj+3spOUk+XJt55y4xQ/UvCPkZcR+3P7b/ub2U7cmcJstA0yhw6OEDoPa0dyXN/m1XKcolGOdfDYw3UeMAPIgqHj58XhNJC6291ckwIEkWEvf0WKGbnbf/45OZK+VjT1v7dpz1s3LWj3Dv+SUfTc6ZHIdHjegpnMncmUuq0KTcUvV4EIvcqFE6uvQQLp2/NA0xMW8k4htOGyAQmmbYv3CRBpQeBUAgyZO857iQUwVbTF/wznoTaRyzQmBUUUTnxnhZ7tPJf8iRM4tH9bRNWKLIwBP337n+Zo1oLqkgRFKrC7RnjUl4yXhCTMsvYIJK/7zs3KxX09iBr+0i+ygmVVSjRTpjxuv+EdziSftDJAka50+n+kHVbSW1UZ4h3FRp1Y
 Ih5syilv
 aGmXa7OYUF7SG0w8uQ8rwswWbyf+R1s2LykiGHer8Md4ymC9qwWODpWrZbiN6ajWMnjnnfH2KtFKQF96Udl7OXu7Iys2Sv9WWClFEb+HwFnmm6VpJsJBjqvrRIdeuKbyDRGmLHqo2MJW5fRUFtLpV0Sh0Od1x1la+8mFbIVp1xUQxTvzZxOVJWIxOnj4qS494wzgxuzIcfHniw0+sjV7I4quO+GEQ5QWhKujiGru3wuot8dwyibXWyg+VDEUZdTWgcXwHb0LVpNMCGnrVxOUk0BTve+YoIk+Szc1I383G5UDwloEmYd9rk7tD+ENl8CGmehbJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add observability for the deferred teardown path:

  - vmstat (CONFIG_ASYNC_MM_TEARDOWN, in /proc/vmstat):
    async_mm_teardown_queued   - deferred to the mm_reaper kthread
    async_mm_teardown_sync     - torn down inline on the exit path:
                                 feature off, mm below the RSS
                                 threshold, MMF_OOM_SKIP or
                                 MMF_OOM_TARGETED set, or rejected by
                                 backpressure. Counts only teardowns
                                 reaching mmput_exit(); final drops via
                                 mmput()/mmput_async() elsewhere in the
                                 kernel are inline but not counted here.
    async_mm_teardown_rejected - subset of the above that was eligible
                                 but lost to async_mm_teardown_reserve()
                                 (counted for both this and sync, so
                                 sync stays the total for the exit path)
  - tracepoints in a new include/trace/events/mm_reaper.h:
    mm_async_teardown_queue  at enqueue, and
    mm_async_teardown_reap   when the reaper picks an mm up, just before
                             __mmput(). queue carries the mm, its RSS,
                             and the exiting task's pid/comm, captured
                             while current is still that task, plus the
                             node of the exiting task. reap carries the
                             mm, the charged RSS (mm->async_reap_rss, the
                             amount mmput_exit() reserved and what the
                             pending-pages accounting releases), a fresh
                             live RSS read taken just before __mmput(),
                             and the node of the reaper. The gap between
                             charged and live measures how much reclaim
                             ate out of the queue before the reaper got
                             to it.

reap is emitted before __mmput() because the final mmdrop() inside
__mmput() may free the mm.

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
 include/linux/vm_event_item.h    |  5 +++
 include/trace/events/mm_reaper.h | 73 ++++++++++++++++++++++++++++++++
 kernel/fork.c                    | 14 +++++-
 mm/vmstat.c                      |  5 +++
 4 files changed, 95 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/mm_reaper.h

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 2628ccda0..de4dc20b7 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -179,6 +179,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		NRSWPIN,
 		NRSWPOUT,
 #endif /* CONFIG_SWAP */
+#ifdef CONFIG_ASYNC_MM_TEARDOWN
+		ASYNC_MM_TEARDOWN_QUEUED,
+		ASYNC_MM_TEARDOWN_SYNC,
+		ASYNC_MM_TEARDOWN_REJECTED,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/include/trace/events/mm_reaper.h b/include/trace/events/mm_reaper.h
new file mode 100644
index 000000000..315bced7c
--- /dev/null
+++ b/include/trace/events/mm_reaper.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mm_reaper
+
+#if !defined(_TRACE_MM_REAPER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MM_REAPER_H
+
+#include <linux/tracepoint.h>
+#include <linux/sched.h>
+#include <linux/topology.h>
+
+TRACE_EVENT(mm_async_teardown_queue,
+
+	TP_PROTO(struct mm_struct *mm, unsigned long rss),
+
+	TP_ARGS(mm, rss),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(int, pid)
+		__array(char, comm, TASK_COMM_LEN)
+		__field(unsigned long, rss)
+		__field(int, node)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->pid = current->pid;
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		__entry->rss = rss;
+		__entry->node = numa_node_id();
+	),
+
+	TP_printk("mm=%p pid=%d comm=%s rss=%lukB node=%d",
+		__entry->mm,
+		__entry->pid,
+		__entry->comm,
+		__entry->rss << (PAGE_SHIFT - 10),
+		__entry->node
+	)
+);
+
+TRACE_EVENT(mm_async_teardown_reap,
+
+	TP_PROTO(struct mm_struct *mm, unsigned long charged_rss, unsigned long live_rss),
+
+	TP_ARGS(mm, charged_rss, live_rss),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, charged_rss)
+		__field(unsigned long, live_rss)
+		__field(int, node)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->charged_rss = charged_rss;
+		__entry->live_rss = live_rss;
+		__entry->node = numa_node_id();
+	),
+
+	TP_printk("mm=%p charged_rss=%lukB live_rss=%lukB node=%d",
+		__entry->mm,
+		__entry->charged_rss << (PAGE_SHIFT - 10),
+		__entry->live_rss << (PAGE_SHIFT - 10),
+		__entry->node
+	)
+);
+
+#endif /* _TRACE_MM_REAPER_H */
+
+#include <trace/define_trace.h>
diff --git a/kernel/fork.c b/kernel/fork.c
index 0976770db..4bdffa188 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -126,6 +126,9 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/task.h>
+#ifdef CONFIG_ASYNC_MM_TEARDOWN
+#include <trace/events/mm_reaper.h>
+#endif
 
 #include <kunit/visibility.h>
 
@@ -3461,8 +3464,10 @@ static bool async_mm_teardown_reserve(unsigned long rss)
 	return true;
 }
 
-static void async_mm_teardown_queue(struct mm_struct *mm)
+static void async_mm_teardown_queue(struct mm_struct *mm, unsigned long rss)
 {
+	count_vm_event(ASYNC_MM_TEARDOWN_QUEUED);
+	trace_mm_async_teardown_queue(mm, rss);
 	if (llist_add(&mm->async_reap_node, &mm_reaper_list))
 		wake_up(&mm_reaper_wait);
 }
@@ -3478,6 +3483,9 @@ static int mm_reaper(void *unused)
 		batch = llist_del_all(&mm_reaper_list);
 		llist_for_each_entry_safe(mm, n, batch, async_reap_node) {
 			unsigned long pages = mm->async_reap_rss;
+			unsigned long live = get_mm_rss(mm);
+
+			trace_mm_async_teardown_reap(mm, pages, live);
 
 			__mmput(mm); /* may free mm via mmdrop */
 			atomic_long_sub(pages, &mm_reaper_pending_pages);
@@ -3515,12 +3523,14 @@ void mmput_exit(struct mm_struct *mm)
 
 			if (async_mm_teardown_reserve(rss)) {
 				mm->async_reap_rss = rss;
-				async_mm_teardown_queue(mm);
+				async_mm_teardown_queue(mm, rss);
 				return;
 			}
+			count_vm_event(ASYNC_MM_TEARDOWN_REJECTED);
 		}
 	}
 
+	count_vm_event(ASYNC_MM_TEARDOWN_SYNC);
 	__mmput(mm);
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 4e26e5fd6..e3ff30027 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1494,6 +1494,11 @@ const char * const vmstat_text[] = {
 	[I(NRSWPIN)]				= "nrswpin",
 	[I(NRSWPOUT)]				= "nrswpout",
 #endif /* CONFIG_SWAP */
+#ifdef CONFIG_ASYNC_MM_TEARDOWN
+	[I(ASYNC_MM_TEARDOWN_QUEUED)]	= "async_mm_teardown_queued",
+	[I(ASYNC_MM_TEARDOWN_SYNC)]		= "async_mm_teardown_sync",
+	[I(ASYNC_MM_TEARDOWN_REJECTED)]	= "async_mm_teardown_rejected",
+#endif
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


