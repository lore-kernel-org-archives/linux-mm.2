Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5322CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D84E6B008C; Wed, 20 May 2026 17:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384D26B0092; Wed, 20 May 2026 17:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1F66B0095; Wed, 20 May 2026 17:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C74A6B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:49:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 710EE8D13C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:49:14 +0000 (UTC)
X-FDA: 84789139428.25.BCEC66D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8AFC5180008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:49:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lX8TNBI2;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779313752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4kVy3EmZScWVSdTPVlqhHCsEE8ybxR9ho/nj0hzR65k=;
	b=eaFoRU5TRHGuPFtM8Gid/bqdUAhhmSj7AJez98Ol8C04XFfC8zNmAonH2JL0sOEc1kXffM
	KAlq9lOzY//HeyhVJP8cSNLaSdEiFdeFOldEI2CEGlT8zboyH220DpWwSMO5grxmOWb7+n
	B8zxlxzv1dLqM25qx1lRbL1wZ3ptNXw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lX8TNBI2;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779313752; a=rsa-sha256;
	cv=none;
	b=GcJp77AzlObPYn/iPmqqAixZ1dSs/TrXGa2xOIVV86izO65e2sKDz1hBtYNkp4FQkiGNWs
	kClhNGdB2ke86BTd4Vc54+bgxOeL9bGtNSTIXRraOysGlRpMe5hzwJNS/eRPNoEnh/fvfG
	BDFLLrqmx0uvamdLLLUbvsnxxxRqXSA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0808441A3;
	Wed, 20 May 2026 21:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB191F000E9;
	Wed, 20 May 2026 21:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779313751;
	bh=4kVy3EmZScWVSdTPVlqhHCsEE8ybxR9ho/nj0hzR65k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lX8TNBI2Khs6WX+Gq1HgCH9kab3tOIAxFrVu//VHsWLNPJa/EFwJZFhWVYAJlgj76
	 UFRpar+ns76wcghm2XjY0ZgQ+NMTBMrQnuB0bQbo5NL3aJoT1BYi+qhHmw5PFCNBYT
	 PiNn46IJ3NfJGI2FSXURsPxQaWl3DyUiVf/UW2Bgk9S9ogL93GbNjVYNU8GnzDYU8b
	 Nrl2OxHu/3+X/WrpDOebbcceQ4BNdK9M6gTmGe5Iu1YrPfrriHWIUmNsRUcYQl2j4p
	 yTOTU0Dl7f9uik/SI603jxqyqP8yOBKdv0GHDEqcFU/OJ9I0/+EVih3IAjtKxzrUEL
	 XIyYm8F+iuYfA==
From: "Christian Brauner (Amutable)" <brauner@kernel.org>
Date: Wed, 20 May 2026 23:48:53 +0200
Subject: [PATCH RFC v3 2/4] exec: introduce struct task_exec_state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-work-task_exec_state-v3-2-69f895bc1385@kernel.org>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
To: Jann Horn <jannh@google.com>, 
 Linus Torvalds <torvalds@linuxfoundation.org>, 
 Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, 
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=6720; i=brauner@kernel.org;
 h=from:subject:message-id; bh=O9wNUVSYL0lqYrtEczC/BBKVnESsPNmlDHr36yNZW68=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTx6Xj/birYLaarYFqkeu5m6PX3Vruv2/BHr5keG+e+/
 3mP7ivhjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInclWb4Z5eoN/enWNWEkAP8
 /DsaZik06rotMWBw2T1xwpIHOmpiRgz/LOb5Kvt38dx8qfaPwU5+2a7Iiecv2+890Fv2ceFb22m
 OLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8AFC5180008
X-Stat-Signature: xfcn7eid6ofqetyyhc9856cjx8hjfkrb
X-HE-Tag: 1779313752-119820
X-HE-Meta: U2FsdGVkX18ZPRusNWup15C97Spt0/VFJKx0I72smE6POERdWasl4je7O7lmv8+oqXhE0SLq2CC0oaZ5p964LrEN/AxEb0h05x5FlYVXHpENwGFGMfWxedieq7odxXnw8rnEob8P5yYwLG/q2FjPL3fav3UMNt+TJqCkf1jK6PnbDOeCXh9kzpkFyuZsW6IME3yxZ5NX5c89H0xLMxuQQZaP3F16xyN8qY3KoNM4fUDma89IUPSzLPBlsnX0RAXLyByNu3fjoTM5A7k0kW9j8LNNYoHsKlNcuQAP++aCIwVJxmWZwdgYg9sFaV30MUkpr+UuhfRFQ3yIDZo2HTCPpFcWN5j7HpHyQ5GtsVWsxY9fF6GOGAlSXRnTeqx/7mB4ANckR/7Ra3r7/F2RwOmqy6/imZ5lQNsrfRGBaWag6nmB44yXEJvx7A3nORZfaPQWJ63mHJ+lY5H8jt37tXByudYQjEqdzQc6y7X9XoPnhtW9gfqXqrRX6yOA9vrJKzsi8S+L7KsLmfl5YpqvTADLDw9WGz05CTbrRLahzAqHcWKWzCZ2t7lOnqkoGDq0HjFw9u9gVfk18Gnv3wZEYM8aadxEGzDnzfKu4W5g+auEk67DXcCAYELdUO9c5bBPD8kU9prhKJO6nNtPODeA9YFYvZAa+5lmTM+QZaWdprkYMo88oG86GeKQl+DA3xYJXmX+h688RncPmHwTepk7qpK7iS+Ck9sBFNJWNh6g6Lonj5FRLHz4V/TlSX/Ca4m7e0CY/LFzAY4zqahfg2xwd6P0Wb29neDbOv+zkfPVXBci8kXv4lvfHqYPfbBmlhfJbj6VL2d6OzoZFxyaEcOlsfq0CTGzRPDZKuPF56/nggTWs+0ilz8D9RSKJBo6aBQxxuLAgBbTxTVYDmymx6+dWHN5Vup1mDw27Umm5QWp11H367OKZxopEGpe58GwBNe+bFpyR11G60amGTPqDvQLooe
 HXcZSAXZ
 p1pjR+riSDs4FydKn5PJ+bqr3JcCGZqMclfNTPsQEGPrmP6ItKrARwtdE5s7t6FsOTcTSKFzW3sCzFmTVluOvw9/HAmRDgpgNYJvZIWgKNd+vL1NBB+JHqVyrUHtdkEaBALhIohmdeH6Nm9mhdSlHN0dm+Eq6iNc5H3VuRPqsZe2ye5ThVGDa8DTm7ceMcQ+a8EWAx9XFCyhKaqhuVs4pUAlBdf9ezQPYfEqhe14B2KvgK+hE9gRb/1S8kFNUbhxzCjOUGVnXDWL3NUfwJK+yXCWYEdp3qCQ9Rr1jUNXKekuqZ7651KFn8GWwXHYs21DvgQlTsKdBvg6RwuwdrRFtYccUpJeDmSXUu2s+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce struct task_exec_state, a per-task RCU-protected structure
that holds the dumpable mode and stays attached to the task for its
full lifetime.

task_exec_state_rcu() is the canonical reader: asserts RCU or
task_lock is held, WARNs on a NULL state, returns the
rcu_dereference()'d pointer.

Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/sched.h            |   2 +
 include/linux/sched/exec_state.h |  31 +++++++++++
 kernel/Makefile                  |   2 +-
 kernel/exec_state.c              | 116 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee06cba5c6f5..6674dbf960b5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -962,6 +962,8 @@ struct task_struct {
 	struct mm_struct		*mm;
 	struct mm_struct		*active_mm;
 
+	struct task_exec_state __rcu	*exec_state;
+
 	int				exit_state;
 	int				exit_code;
 	int				exit_signal;
diff --git a/include/linux/sched/exec_state.h b/include/linux/sched/exec_state.h
new file mode 100644
index 000000000000..dc5a795cbfe2
--- /dev/null
+++ b/include/linux/sched/exec_state.h
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
+#ifndef _LINUX_SCHED_EXEC_STATE_H
+#define _LINUX_SCHED_EXEC_STATE_H
+
+#include <linux/init.h>
+#include <linux/rcupdate.h>
+#include <linux/refcount.h>
+#include <linux/sched/coredump.h>
+#include <linux/user_namespace.h>
+
+struct task_exec_state {
+	refcount_t		count;
+	enum task_dumpable	dumpable;
+	struct user_namespace	*user_ns;
+	struct rcu_head		rcu;
+};
+
+struct task_exec_state *alloc_task_exec_state(struct user_namespace *user_ns);
+void put_task_exec_state(struct task_exec_state *exec_state);
+struct task_exec_state *task_exec_state_rcu(const struct task_struct *tsk);
+struct task_exec_state *task_exec_state_replace(struct task_struct *tsk,
+						struct task_exec_state *exec_state);
+void task_exec_state_set_dumpable(enum task_dumpable value);
+enum task_dumpable task_exec_state_get_dumpable(struct task_struct *task);
+int task_exec_state_copy(struct task_struct *tsk);
+void __init exec_state_init(void);
+
+DEFINE_FREE(put_task_exec_state, struct task_exec_state *, put_task_exec_state(_T))
+
+#endif /* _LINUX_SCHED_EXEC_STATE_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 6785982013dc..1e1a31673577 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y     = fork.o exec_domain.o panic.o \
+obj-y     = fork.o exec_domain.o exec_state.o panic.o \
 	    cpu.o exit.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o user.o \
 	    signal.o sys.o umh.o workqueue.o pid.o task_work.o \
diff --git a/kernel/exec_state.c b/kernel/exec_state.c
new file mode 100644
index 000000000000..a0ca5d913900
--- /dev/null
+++ b/kernel/exec_state.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
+#include <linux/init.h>
+#include <linux/rcupdate.h>
+#include <linux/refcount.h>
+#include <linux/sched.h>
+#include <linux/sched/coredump.h>
+#include <linux/sched/exec_state.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include <linux/user_namespace.h>
+
+static struct kmem_cache *task_exec_state_cachep;
+
+static void __free_task_exec_state(struct rcu_head *rcu)
+{
+	struct task_exec_state *exec_state = container_of(rcu, struct task_exec_state, rcu);
+
+	put_user_ns(exec_state->user_ns);
+	kmem_cache_free(task_exec_state_cachep, exec_state);
+}
+
+void put_task_exec_state(struct task_exec_state *exec_state)
+{
+	if (exec_state && refcount_dec_and_test(&exec_state->count))
+		call_rcu(&exec_state->rcu, __free_task_exec_state);
+}
+
+struct task_exec_state *alloc_task_exec_state(struct user_namespace *user_ns)
+{
+	struct task_exec_state *exec_state;
+
+	exec_state = kmem_cache_alloc(task_exec_state_cachep, GFP_KERNEL);
+	if (!exec_state)
+		return NULL;
+	refcount_set(&exec_state->count, 1);
+	exec_state->dumpable = TASK_DUMPABLE_OFF;
+	exec_state->user_ns = get_user_ns(user_ns);
+	return exec_state;
+}
+
+struct task_exec_state *task_exec_state_rcu(const struct task_struct *tsk)
+{
+	struct task_exec_state *exec_state;
+
+	exec_state = rcu_dereference_check(tsk->exec_state,
+					   lockdep_is_held(&tsk->alloc_lock));
+	WARN_ON_ONCE(!exec_state);
+	return exec_state;
+}
+
+struct task_exec_state *task_exec_state_replace(struct task_struct *tsk,
+						struct task_exec_state *exec_state)
+{
+	/*
+	 * Updates must hold both locks so callers needing a consistent
+	 * snapshot of mm + dumpability are covered.
+	 */
+	lockdep_assert_held(&tsk->alloc_lock);
+	lockdep_assert_held_write(&tsk->signal->exec_update_lock);
+
+	return rcu_replace_pointer(tsk->exec_state, exec_state, true);
+}
+
+/*
+ * The non-CLONE_VM clone path: allocate a fresh exec_state and
+ * inherit the parent's dumpable mode and user_ns reference.  CLONE_VM
+ * siblings refcount-share via copy_exec_state() in fork.c; only this
+ * path and execve() ever allocate.
+ */
+int task_exec_state_copy(struct task_struct *tsk)
+{
+	struct task_exec_state *src, *dst;
+
+	src = rcu_dereference_protected(current->exec_state, true);
+	dst = alloc_task_exec_state(src->user_ns);
+	if (!dst)
+		return -ENOMEM;
+	dst->dumpable = src->dumpable;
+	rcu_assign_pointer(tsk->exec_state, dst);
+	return 0;
+}
+
+/*
+ * Store TASK_DUMPABLE_* on current->exec_state.  All callers
+ * (commit_creds, begin_new_exec, prctl(PR_SET_DUMPABLE)) act on the
+ * running task, which guarantees ->exec_state is allocated and cannot
+ * be replaced under us.
+ */
+void task_exec_state_set_dumpable(enum task_dumpable value)
+{
+	struct task_exec_state *exec_state;
+
+	if (WARN_ON(value > TASK_DUMPABLE_ROOT))
+		value = TASK_DUMPABLE_OFF;
+
+	exec_state = rcu_dereference_protected(current->exec_state, true);
+	WRITE_ONCE(exec_state->dumpable, value);
+}
+
+enum task_dumpable task_exec_state_get_dumpable(struct task_struct *task)
+{
+	struct task_exec_state *exec_state;
+
+	guard(rcu)();
+	exec_state = rcu_dereference(task->exec_state);
+	return READ_ONCE(exec_state->dumpable);
+}
+
+void __init exec_state_init(void)
+{
+	task_exec_state_cachep = kmem_cache_create("task_exec_state",
+			sizeof(struct task_exec_state), 0,
+			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT,
+			NULL);
+}

-- 
2.47.3


