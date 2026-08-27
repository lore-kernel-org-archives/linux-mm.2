Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F02AEC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F776B009E; Thu, 27 Aug 2026 19:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9732C6B009F; Thu, 27 Aug 2026 19:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887FC6B00A0; Thu, 27 Aug 2026 19:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9226B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3A0D40210
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:35 +0000 (UTC)
X-FDA: 85148648550.19.DBF92D2
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1AFE120003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ROWDcpHf;
	spf=pass (imf31.hostedemail.com: domain of 31MiQaggKCAUxyj0jsxilttlqj.htrqnsz2-rrp0fhp.twl@flex--stevensd.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=31MiQaggKCAUxyj0jsxilttlqj.htrqnsz2-rrp0fhp.twl@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873494;
	b=IE8b1bdBMNU4kd5ShgB09LlB/st74tR8tRUdmwVpQRuCXutA8F3LiELXizwjzB1l9AYnLa
	rlHQwBED5AXxzNSeoF8yjC+QQ3vR9fpLKuLccEtSXeMqKmx7aQ+TUexWZt+jnzQMaQrkRw
	aVFFKmqCjuYIsVm28eDX+Ud0hfi9hho=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgniuiCLGc5SclSuhaFn4pRhiopbh+4BL9/R1MdVpyI=;
	b=UgQKCDiKNpG0CPlFzqP5MchYw/vAfi6lTd7ZkcCkdfqCYS/Ref07r+CJzcI+TIOM/tpReO
	tbsZb5oNhtHHPsZSoRURiM1spmF0lAka31y0zLAaleegVSvSaPZslsQabPpQZ4ezN2y5s7
	qx5mqiVoNoZbr1Hncolkug605Yn7VC0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ROWDcpHf;
	spf=pass (imf31.hostedemail.com: domain of 31MiQaggKCAUxyj0jsxilttlqj.htrqnsz2-rrp0fhp.twl@flex--stevensd.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=31MiQaggKCAUxyj0jsxilttlqj.htrqnsz2-rrp0fhp.twl@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so408902a91.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873493; x=1788478293; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PgniuiCLGc5SclSuhaFn4pRhiopbh+4BL9/R1MdVpyI=;
        b=ROWDcpHf6oJOxitNqcP3+FdYbVUWCqMw4xHHk28A00bzfYLLe0/wZAxBER6431LAay
         XwXcAYbTpK6I3v0lbN/CUblqVBGbcFRnkotYoK/+kmM2ZH85dydJHm7CRdVeKEelss0T
         zNnXWc4KdBiZeyNI0waeoUOOkeQyvpkqOJ18xfmpiUONrlTCJsjp6UCM130QGFyAyKPw
         jTUKT5q3wf/shzcNjKLanXz7IIvjN96OrsXJKeXkcptnS/yYvl55BeJKfP0Zzlsawyn6
         8K3AM26Qj9oRczlR+K/XmexU+RAS/bPu3IxeNTNkdglOZwekaXGuz7d+ldz5d1NILY/5
         n0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873493; x=1788478293;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PgniuiCLGc5SclSuhaFn4pRhiopbh+4BL9/R1MdVpyI=;
        b=hf3puDCQ1GqcVbayaVoRF2uMI/yC1AFojrOti6wpnOy41B9I9Fnm1JLtusqI2K2i4p
         cAgifLaMQ4jy8TWUuGSVYCpEXR8A/FCmT0c8YirC9QFfld8Ha5/52inmMZHxF+jt++6H
         uXe6BjedmyTZRw5zlXeTwzpsr0UZefurNrV9E/od5EMCIqMDGtsmTBw698nVvLm66jl/
         qnL/Wb4MF68J676+McPLP/itzGgQzFEWXwefhjGqOvmWcdYlQd0O2ZXbDzFFmxAg1NMr
         amGSFSpewLEt2XO0e+vD6Cmw3xXhH1Tb6tV0WNgtLCT4t9aOuMva+BFgfzjTYZU6eZRN
         z1JQ==
X-Forwarded-Encrypted: i=1; AHgh+RoyRqnv0GXNWnkR+TASA0+dCFetsW/F9g0aNk5BGY7gt24jTP8Q1w1ADCljAQa9YjRpe7bEXYlR3w==@kvack.org
X-Gm-Message-State: AFuF++mEdevIuiFUOlR1AouyQ81GLM1jztOqQiiKpBk5sXv/VRlWNzyf
	8YVQlsKgVYfTMf4syvoKBdalKi1l4kWS4gyjKLfuFNVlIZaLRTInH2b0ESUDLtYWt32R1yk7CNi
	ZY8UiPTUXS9BlRA==
X-Received: from dlbdm24.prod.google.com ([2002:a05:7022:6b98:b0:141:4a59:5b22])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:380a:b0:38f:de97:b06 with SMTP id 98e67ed59e1d1-396d0daf810mr4980324a91.5.1787873492204;
 Thu, 27 Aug 2026 16:31:32 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:46 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-9-stevensd@google.com>
Subject: [RFC 08/10] Set PF_RECLAIMABLE_STACK in various places
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1AFE120003
X-Stat-Signature: cc5r19c6mxehiazykexid67bwotjgfzm
X-HE-Tag: 1787873493-129089
X-HE-Meta: U2FsdGVkX1/Jd71XOSWmuehhwRqlxwg+YfEps2jkJD3Z4KaUf+qO/hgbstywEvtELsuZIbFDBZYFFm/zkdFMaAvF3SU5L6tEYoRnfUHHj8nj2s9XdAOb90Bw+oihEkS9iwN/pU9o2jv+G3Z/zOBmznqxGIPsHnLZyw1JL7yDCA7W0sBE0JWa7IPqcWWLzDVs1wnOrtXZOzZduS9UNjhUbb8xUHAD/wWJNVKTPcR16t/IF3/RW/iUSJW8++Cdym+hqNiswFfmlyJ6R06tFS97KqIhdACVGXqLbW9WeBA+H94oBf6khFVmhCfnr5Pj/vqED4BM/B6nPI2DyebqTLII8QbqSsqz5qxwr6JbCjZUlZdHwCJ+F57Ro1yJC5NParia7NxNKza6WaYWxU+esIlkXmGImj2J3KPLfnQ9E3n+OqnvGrqLFL3W/wRU7hfutdbZDfyWofw1ut0lIg5OEFgu1F30i/QeYPnLY9/kFhROGc//qisTfSWXW0QXuADDlunNMGREidJBQTRJDKo7KS7pWXLGNlZXC37HoCODLT+L3ChR12dA+sabLVrBzngAtg2O0/IJUySFMoEHpTkVRdu+xvg8rnvLzi07Lm28E4vG58xzXauY9gCXNTW5eqWHJGsZJeX0QSWZYce1jMyEaBfcVdUNeNEKgfLl7bFnYsrUTiuKiiuRNiG5tjt9STC/OdWrCvN1KDIkYNPJdZE4CfsthWUd9KmcO4zNu7Gu/9ayaXMZbTOBn92eW/dTTCkIahFb0Tf19zrJE1z4L5OETVwSdC81A1jkXfrr0Q6PsajsJPPu6Dt11YzQL5cu9gR0WwCoSyesmFXREESAVD5gj/cm3IujevxSj3okVLZ4WURLV0kEs8c/bsvFoGcazTyqAmVUFig5Lt62sK/D4FWHV2roGxegnDZ6LzkXV1AAdEnFdfoW7wL9v4ncAHTgr75uwJoZvz8CIMHfQZ93b8DhyES
 GKzlXWr3
 7aFnbYsXJrg7Li0C2ahXtLWvHcb8kOiB/iVi43BmiiFGOt/n7fmoK5gVkMKD9EabW44qtCUnTcTYdN53Jf7mKfZzpUM9uobBbRo2zffnubAf9BOHQQdjckO1ipYauL1CJ53Zbt4Y4bIeJvNYdXFqrdkN2JUMMOkRu4792eczU72K4Sco3C/ME0zK4d4WuMb+R6N+TGtk1u4tr2n3h3T2azECgIEZq31NcuapLBFwxXsDoHuwYZ/FoobYDWkPv8XrtcWQwMo1Nh30moxQBFF0A4USs07JsZJHFIKbI0Thg7uJcRhMmWTZq9KowXh7ws+zgJSelfUpFZWntMKErvl5zeeX6Bf3DItDWBgB2o/ikwbcgeqZD04BE6rGCP/PAeY4jQ2gPhBi6B6BEZFPUxXBIBI0WKRHHQi/cJrJ/b/ASSO6zL4SNVIHDjkZd98YH3SZz7OKJnjsOoGye2J8dRT9bmsDX6t0Wj+OGZIaiyEN3ckuPAPS7t1PrACiM8kVs4P0ELDpq4Ucl7nVl/oMM4/+aBJOLCOJfB1JDzg0Iz91VErZRN6dQP7eRGmr6Kmqn4eHxvujIUUx5HvKJqQMIxqu4VgViEREP/4FbBwL7hjSEBlTmNhUTMx8NnBdFIdmHE2dLVMJUMeAG3VVZQgXXJPb3U+TRz6bJhluobYXO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate various blocking locations with the PF_RECLAIMABLE_STACK.

Signed-off-by: David Stevens <stevensd@google.com>
---
 drivers/android/binder/thread.rs | 14 +++++++++++++
 fs/eventpoll.c                   |  3 +++
 fs/pipe.c                        | 28 ++++++++++++++++---------
 fs/select.c                      |  3 +++
 kernel/futex/waitwake.c          |  3 +++
 kernel/signal.c                  | 36 +++++++++++++++++++-------------
 kernel/time/hrtimer.c            |  3 +++
 rust/kernel/task.rs              | 16 ++++++++++++++
 8 files changed, 82 insertions(+), 24 deletions(-)

diff --git a/drivers/android/binder/thread.rs b/drivers/android/binder/thread.rs
index bc0ef8927905..be62f7fd43ca 100644
--- a/drivers/android/binder/thread.rs
+++ b/drivers/android/binder/thread.rs
@@ -538,13 +538,21 @@ fn get_work_local(self: &Arc<Self>, wait: bool) -> Result<Option<DLArc<dyn Deliv
 
         // Loop waiting only on the local queue (i.e., not registering with the process queue).
         let mut inner = self.inner.lock();
+        // SAFETY: Only accessed locally in this function
+        let current = unsafe { Task::current() };
         loop {
             if let Some(work) = inner.pop_work() {
                 return Ok(Some(work));
             }
 
             inner.looper_flags |= LOOPER_WAITING;
+
+            current.set_flag_bits(bindings::PF_RECLAIMABLE_STACK);
+
             let signal_pending = self.work_condvar.wait_interruptible_freezable(&mut inner);
+
+            current.clear_flag_bits(bindings::PF_RECLAIMABLE_STACK);
+
             inner.looper_flags &= !LOOPER_WAITING;
 
             if signal_pending {
@@ -592,15 +600,21 @@ fn get_work(self: &Arc<Self>, wait: bool) -> Result<Option<DLArc<dyn DeliverToRe
         };
 
         let mut inner = self.inner.lock();
+        // SAFETY: Only accessed locally in this function
+        let current = unsafe { Task::current() };
         loop {
             if let Some(work) = inner.pop_work() {
                 return Ok(Some(work));
             }
 
+            current.set_flag_bits(bindings::PF_RECLAIMABLE_STACK);
+
             inner.looper_flags |= LOOPER_WAITING | LOOPER_WAITING_PROC;
             let signal_pending = self.work_condvar.wait_interruptible_freezable(&mut inner);
             inner.looper_flags &= !(LOOPER_WAITING | LOOPER_WAITING_PROC);
 
+            current.clear_flag_bits(bindings::PF_RECLAIMABLE_STACK);
+
             if signal_pending || inner.looper_need_return {
                 // We need to return now. We need to pull the thread off the list of ready threads
                 // (by dropping `reg`), then check the state again after it's off the list to
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index eed8cecd94e3..4e9c09446b48 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/task_stack.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/signal.h>
@@ -2302,6 +2303,8 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		if (signal_pending(current))
 			return -EINTR;
 
+		guard(allow_stack_reclaim)();
+
 		/*
 		 * Internally init_wait() uses autoremove_wake_function(),
 		 * thus wait entry is removed from the wait queue on each
diff --git a/fs/pipe.c b/fs/pipe.c
index 429b0714ec57..15503b12fe8f 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -27,6 +27,7 @@
 #include <linux/watch_queue.h>
 #include <linux/sysctl.h>
 #include <linux/sort.h>
+#include <linux/sched/task_stack.h>
 
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
@@ -469,16 +470,23 @@ anon_pipe_read(struct kiocb *iocb, struct iov_iter *to)
 			break;
 		}
 		mutex_unlock(&pipe->mutex);
-		/*
-		 * We only get here if we didn't actually read anything.
-		 *
-		 * But because we didn't read anything, at this point we can
-		 * just return directly with -ERESTARTSYS if we're interrupted,
-		 * since we've done any required wakeups and there's no need
-		 * to mark anything accessed. And we've dropped the lock.
-		 */
-		if (wait_event_interruptible_exclusive(pipe->rd_wait, pipe_readable(pipe)) < 0)
-			return -ERESTARTSYS;
+
+		{
+			guard(allow_stack_reclaim)();
+			/*
+			 * We only get here if we didn't actually read
+			 * anything.
+			 *
+			 * But because we didn't read anything, at this point
+			 * we can just return directly with -ERESTARTSYS if
+			 * we're interrupted, since we've done any required
+			 * wakeups and there's no need to mark anything
+			 * accessed. And we've dropped the lock.
+			 */
+			if (wait_event_interruptible_exclusive(pipe->rd_wait,
+							       pipe_readable(pipe)) < 0)
+				return -ERESTARTSYS;
+		}
 
 		wake_next_reader = true;
 		mutex_lock(&pipe->mutex);
diff --git a/fs/select.c b/fs/select.c
index 95d76531015a..3af1bf4d74a9 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/task_stack.h>
 #include <linux/syscalls.h>
 #include <linux/export.h>
 #include <linux/slab.h>
@@ -236,6 +237,8 @@ static int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
 {
 	int rc = -EINTR;
 
+	guard(allow_stack_reclaim)();
+
 	set_current_state(state);
 	if (!READ_ONCE(pwq->triggered))
 		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index d4483d15d30a..0fbf7bfcd904 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -2,6 +2,7 @@
 
 #include <linux/plist.h>
 #include <linux/sched/task.h>
+#include <linux/sched/task_stack.h>
 #include <linux/sched/signal.h>
 #include <linux/freezer.h>
 
@@ -378,6 +379,7 @@ void futex_do_wait(struct futex_q *q, struct hrtimer_sleeper *timeout)
 	 * has tried to wake us, and we can skip the call to schedule().
 	 */
 	if (likely(!plist_node_empty(&q->list))) {
+		guard(allow_stack_reclaim)();
 		/*
 		 * If the timer has already expired, current will already be
 		 * flagged for rescheduling. Only call schedule if there
@@ -547,6 +549,7 @@ static void futex_sleep_multiple(struct futex_vector *vs, unsigned int count,
 			return;
 	}
 
+	guard(allow_stack_reclaim)();
 	schedule();
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index bbc0fd4cc4d7..ca0d79ee013f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2718,17 +2718,21 @@ static void do_freezer_trap(void)
 		return;
 	}
 
-	/*
-	 * Now we're sure that there is no pending fatal signal and no
-	 * pending traps. Clear TIF_SIGPENDING to not get out of schedule()
-	 * immediately (if there is a non-fatal signal pending), and
-	 * put the task into sleep.
-	 */
-	__set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
-	clear_thread_flag(TIF_SIGPENDING);
-	spin_unlock_irq(&current->sighand->siglock);
-	cgroup_enter_frozen();
-	schedule();
+	{
+		guard(allow_stack_reclaim)();
+
+		/*
+		 * Now we're sure that there is no pending fatal signal and no
+		 * pending traps. Clear TIF_SIGPENDING to not get out of schedule()
+		 * immediately (if there is a non-fatal signal pending), and
+		 * put the task into sleep.
+		 */
+		__set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
+		clear_thread_flag(TIF_SIGPENDING);
+		spin_unlock_irq(&current->sighand->siglock);
+		cgroup_enter_frozen();
+		schedule();
+	}
 
 	/*
 	 * We could've been woken by task_work, run it to clear
@@ -3788,9 +3792,13 @@ static int do_sigtimedwait(const sigset_t *which, kernel_siginfo_t *info,
 		recalc_sigpending();
 		spin_unlock_irq(&tsk->sighand->siglock);
 
-		__set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
-		ret = schedule_hrtimeout_range(to, tsk->timer_slack_ns,
-					       HRTIMER_MODE_REL);
+		{
+			guard(allow_stack_reclaim)();
+			__set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
+			ret = schedule_hrtimeout_range(to, tsk->timer_slack_ns,
+						       HRTIMER_MODE_REL);
+		}
+
 		spin_lock_irq(&tsk->sighand->siglock);
 		__set_task_blocked(tsk, &tsk->real_blocked);
 		sigemptyset(&tsk->real_blocked);
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 313dcea127fe..30c85482dfd5 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -39,6 +39,7 @@
 #include <linux/sched/nohz.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/isolation.h>
+#include <linux/sched/task_stack.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
 #include <linux/compat.h>
@@ -2392,6 +2393,8 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 	struct restart_block *restart;
 
 	do {
+		guard(allow_stack_reclaim)();
+
 		set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
 		hrtimer_sleeper_start_expires(t, mode);
 
diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 38273f4eedb5..6168f058343a 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -344,6 +344,22 @@ pub fn group_leader(&self) -> &Task {
         // only be used while `current` is still valid, thus still running.
         unsafe { &*ptr.cast() }
     }
+
+    /// Sets the given task flag bits on the current task.
+    #[inline]
+    pub fn set_flag_bits(&self, set: u32) {
+            // SAFETY: The `flags` field of `current` is not modified from other threads, so
+	    // the non-atomic update isn't a race.
+	    unsafe { (*self.as_ptr()).flags |= set }
+    }
+
+    /// Clears the given task flag bits on the current task.
+    #[inline]
+    pub fn clear_flag_bits(&self, clear: u32) {
+            // SAFETY: The `flags` field of `current` is not modified from other threads, so
+	    // the non-atomic update isn't a race.
+	    unsafe { (*self.as_ptr()).flags &= !clear }
+    }
 }
 
 // SAFETY: The type invariants guarantee that `Task` is always refcounted.
-- 
2.55.0.897.gb25b4bd76c-goog


