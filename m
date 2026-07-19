Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC96C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 18:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412A86B0093; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34EDD6B009B; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1518E6B0099; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79BCC6B008A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:55:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF9C81405D8
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:25 +0000 (UTC)
X-FDA: 85006429410.30.3D7F405
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8426020008
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=wu2EFQEi;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf31.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784487324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzuHmVh+q9OHnLUm7h9D4LXtKeaYnS+MienvvkAwdTQ=;
	b=3EmILF67+n2lvGnZ6DEEDBZvx41kvGB6x1ePIh/kBTfqaq+G2oGdbQcFMlpYDtTt8uESZU
	xmSj/4aJbVyCAwJ4ZkdZw3gawqJp1K1Ax3Uy0J3OHE0w0tsyZYeYa0MgTlOFZgh8lbPT91
	+miLd9d5Q06PuqXYnDSP4Zb12BcLCC0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=wu2EFQEi;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf31.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784487324;
	b=8OpIiwnNQ0FYplcZOnLmRQco+WfaaIWfPyQ7Nya71eMLpwCPKJKt++IZtfKBFpejDUjXTC
	Lg/EAvLYrDudnm+d/XZeyfI0rbiPus3NHFhFmWGyVO7NMZwPkXzaCn/6V/jP6ni3nt1OCn
	NmINxNvE65J83xfs/BJGF5b1YwGuUY0=
ARC-Seal: i=1; a=rsa-sha256; t=1784487282; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=dLhc3+CEGqis5T4rqStjmYcL0cArClyv4uSj5dmJskdIDaS2dkoOkbI5gnFiAaPqppOKOGqybHO6sWjHZchibtxWosF6Siu60p3ZpRkEwteIe9BSQsiJyxpZ/5v9WKPW9VYmdgw0Y62QB/wlXHoOW6YxALeAcU0hIL4sMZbd4JM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784487282; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xzuHmVh+q9OHnLUm7h9D4LXtKeaYnS+MienvvkAwdTQ=; 
	b=WvfxIsfbFLFFfwp8Ho0Bg96cN63/PAHN/OsqkROcPTKeEL3ujIsYv/gt9Z1PPA5OnyPUbKHdYWLVK5cukKG9kY7HSOLLm1k1dRFe8WRtGMiFpab+Evceij4BJ6ZhWDCHswk3N28rgqKON34CIKlZdsoXVyg0lUOxOa+v8niJUo8=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784487282;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=xzuHmVh+q9OHnLUm7h9D4LXtKeaYnS+MienvvkAwdTQ=;
	b=wu2EFQEihaI2ze8F242df+yReXM4jf25ryHY4KKKanZgjoR/bZpD3mWFA8kfKM0f
	xR3+l3h/x55psY5nD93Hy8+QyEfe7mO4ZGfhk6o+TWuGgYFXpn8G0krpgYdiq7qy00E
	UTwVTpV6p2zbO/LCM5UiqzVh8xk6KepwdUX3yG3k=
Received: by mx.zoho.in with SMTPS id 1784487280644201.2764833788417;
	Mon, 20 Jul 2026 00:24:40 +0530 (IST)
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
Subject: [RFC PATCH 2/7] mm: dispatch __mmput() to an mm_reaper kthread via llist
Date: Mon, 20 Jul 2026 00:24:04 +0530
Message-Id: <20260719185409.409685-3-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8426020008
X-Stat-Signature: 55e4uzc8au7b5iaxe43g1r4pwemugyeg
X-HE-Tag: 1784487323-704712
X-HE-Meta: U2FsdGVkX18ai6j2Nb9FuIiCbBHMGpjDG/UZMARSFf1jhvv7snJfJMZxk/DrWfjdcPpwn/MeilOCKPby+smJW6OSuLG0aZmTgHERIq1IDJ9pexnDCdBmFN3Oz9rxVId8KOdnCuvR3OYGhHJrwIlxb7xAIBdcbXZ5ufdaYC3GdTiwnGFQUIV0ehWMkiqv1EO+sGksqi2VZ7Nr4mJr9qazr9eOyFziR4JC9uV72LrZ2JSp08UL3O+AO+1wBcsfNol0MPxQmFuLmA9FoqxhQ/wDhdRdvS+Djddl1jl2n79FX658YaDv89rm8DrAZJSa39InRKKO6mFKLTovw2+qhZiCVNw2YbNPYEmEkHyU6Qjdlk96hTaTB/6XqQA3n2BBwCOVxq11vUy/W3ZaGfiSr/g/cRqJZ64B/3GBb2R49KjXTidzQSbW24kQ1+5rLhh76yh5qZGaysmtkn+z5STPg7CF++QW7bOd8S5gUqf+vHdL0xioS4sIZjghrQ8qyLX9HFEu72e7IG92wNUKkLUSJHnz08/bu/khKGmuV+8nkRH1xz/CEekdafpP0piBHCww++Am/x3BRDxOknSraytsRXNGMwTqOWDbi3IpTdXHbGcg3vtj0PFujDbbVbUwwiOtZj9O8u5WCic4yASyp/4MQVtK3qd7zgSFf0zNW9hD9r+LfO8c0pYDHsAzlnpzz+w/oW+aw3cQABm+OO18l7vQCUGi7uGrwM75CWPZj/+4e5b/gmuN8Kb88p2CKPax324vAKjYJvi+6fRF9XC37KIkcm8xz8XgOHRIzeJjhCRee2QDD800bJT7XO9AmcWJwPNc7EX5efZrPwHYVjnS0XTbD2UuEa9/NwsxdOSFror5mW+W5rQqKyf8kvR7icQA2hroFY0C+lvl++sEl8E1eQCMXdMii+/fFnEq8qkBU7AWKBNj4QYHwUwKNO9VA1Ux+FkWulqcqYFZVL7KDylbGrRcpkN
 ZTiDesLb
 jNAPZ0rATGxRPWOgp+tLY8YSLq+n1KEozJ01kn0EJLtHEg3qrEaqGPmm5Ayk6iqFDsE+xw0qzYuwFsc7bGgKU7EqofrIMF71SW9JWPCAUiLthktB3GfP5g7X15gBCrIxKIMrbvo7k5Dp0PgAtVpdGYTXlpgVSoZYSWgOHNbAwfQjCzikBdKcW7juNibavB6JBAcw/HOyEM23D6vYfYDewWijJEfnN/p4oX+h8HLePzH3RXWK6QLrzMdFvd54ud6w8lsuLCaiG1+z5hmGZQxgQf10x11g17j5aCnuP8sCPIbYvZWneEGWh+1I/n+vYSapQ3n3TrzLJBV7JTilMCOE7lHfWgSR7iLz3j5i139WSKzO4CPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a single dedicated, freezable, sleepable kthread (mm_reaper)
modeled on oom_reaper, and the machinery to route the deferrable unit of
teardown -- __mmput() -- to it through a lock-free llist plus waitqueue.
mmput_exit() does llist_add() and wakes the kthread, which drains with
llist_del_all() and runs __mmput() per entry with cond_resched(). The
drain loop also calls try_to_freeze() after each entry, so a freeze
request is honoured mid-batch rather than only at the wait point.

Nothing calls mmput_exit() yet: exit_mm() is not routed to it, and there
is no eligibility check or gate, so it would queue every final-drop mm
unconditionally if invoked. This changes no behavior -- the function is
built but unreferenced, the kthread receives no work, and __mmput() runs
inline on the exiting CPU exactly as today. The exit_mm() hook and the
eligibility/gating policy follow in later patches.

llist (rather than oom_reaper's spinlock+list) avoids a global lock on
the exit path under many-core parallel exits. llist_for_each_entry_safe()
caches the next pointer before __mmput(), so iteration is safe even when
the final mmdrop() inside __mmput() frees mm.

Lifetime: the mm_count reference that mm_users>0 stands for is released
only by that final mmdrop() inside __mmput(). Deferring __mmput() keeps
the reference held, so the mm_struct and its embedded async_reap_node
stay alive until the kthread runs. No extra mmgrab() is needed, for the
same reason mmput_async() needs none.

The kthread is started at subsys_initcall and set to nice 19 to minimize
competition with other EEVDF tasks. Its affinity is expressed as a
preference via kthread_affine_preferred() over the HK_TYPE_KTHREAD
housekeeping mask, so it keeps off isolcpus= and cpuset-isolated CPUs
without the hard binding kthread_bind_mask() would impose --
PF_NO_SETAFFINITY would otherwise leave admins unable to re-affine it.

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
 kernel/fork.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a..884e4e767 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -112,6 +112,7 @@
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/sched/isolation.h>
 
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
@@ -3407,3 +3408,56 @@ static int __init init_fork_sysctl(void)
 }
 
 subsys_initcall(init_fork_sysctl);
+
+#ifdef CONFIG_ASYNC_MM_TEARDOWN
+static LLIST_HEAD(mm_reaper_list);
+static DECLARE_WAIT_QUEUE_HEAD(mm_reaper_wait);
+
+static void async_mm_teardown_queue(struct mm_struct *mm)
+{
+	if (llist_add(&mm->async_reap_node, &mm_reaper_list))
+		wake_up(&mm_reaper_wait);
+}
+
+static int mm_reaper(void *unused)
+{
+	set_freezable();
+	while (true) {
+		struct llist_node *batch;
+		struct mm_struct *mm, *n;
+
+		wait_event_freezable(mm_reaper_wait, !llist_empty(&mm_reaper_list));
+		batch = llist_del_all(&mm_reaper_list);
+		llist_for_each_entry_safe(mm, n, batch, async_reap_node) {
+			__mmput(mm); /* may free mm via mmdrop */
+			cond_resched();
+			try_to_freeze();
+		}
+	}
+	return 0;
+}
+
+void mmput_exit(struct mm_struct *mm)
+{
+	might_sleep();
+	if (!atomic_dec_and_test(&mm->mm_users))
+		return;
+	async_mm_teardown_queue(mm);
+}
+
+static int __init mm_reaper_init(void)
+{
+	struct task_struct *th;
+
+	th = kthread_create(mm_reaper, NULL, "mm_reaper");
+	if (IS_ERR(th)) {
+		pr_err("mm_reaper: failed to start kthread: %ld\n", PTR_ERR(th));
+		return PTR_ERR(th);
+	}
+	set_user_nice(th, 19); /* minimize competition with other fair class tasks */
+	kthread_affine_preferred(th, housekeeping_cpumask(HK_TYPE_KTHREAD));
+	wake_up_process(th);
+	return 0;
+}
+subsys_initcall(mm_reaper_init);
+#endif
-- 
2.34.1


