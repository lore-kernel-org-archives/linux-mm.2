Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5770DCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A596B008C; Wed, 20 May 2026 10:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF14D6B0092; Wed, 20 May 2026 10:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B94C6B0095; Wed, 20 May 2026 10:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA636B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:43:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 356DE1C1005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:29 +0000 (UTC)
X-FDA: 84788066538.11.AE61755
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7832EC000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XeTjNnlf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288207; a=rsa-sha256;
	cv=none;
	b=wylhpn9kPvNkwdjv/hcxk49PQE/8nxoCa55ThmuaIn2DZ4tIvHuou7dsKoGtGLkxP8Lr/J
	ZVa0e9As8iuXteI9yyhaxzkhCYeKwMtmeik/+EuTVxKOz9lxVrkHDd9nrXpMRxfhH1tCaU
	1L9zsfCICkB74R+SO9YQgAmN1OHU2a0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XeTjNnlf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o42PSVHRNhCCsv6qA8pBimIDLnOcrgu7l1Jz6xvhp94=;
	b=4FCWObKKqKKGCm35ONUrXuHvT3ppzZLR6j4CLYcxGT3c64AjW/sfUALU9/Ibpb5PAare44
	010noR6l7ZoZ74GFMrBjNaYOoUb/B+KUOpWiVXwvLQg8dlS5+5+7fEGN/6BnJakIwvm7Ju
	6jQGsgDsNYD11VrcFHAoe0Gj17J6q3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04DA360120;
	Wed, 20 May 2026 14:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654A21F000E9;
	Wed, 20 May 2026 14:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779288206;
	bh=o42PSVHRNhCCsv6qA8pBimIDLnOcrgu7l1Jz6xvhp94=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XeTjNnlf4auTC7n4kVq9DMSG6MIZ1RyGIm3ECdM7shzEQdr7QgT4EHu3BCaGvc/0d
	 VuyayIsgvg1MieXg/rtIE7p2NE0GbR4ZYIUhYvUmoyyei5JOHv6eSEyLXqDJRndrBM
	 tY1S70sa3VrMZYtaOHzicJp4OL2pkdSWYbzsJT6DVvw2bNRNjAmA6lKsnVQte7cFNM
	 1nvHXvRLGfD9qz5533i15scboSqTOHcz37tr9z355CWOcGWxhGWh0bM/9za8gd9Oke
	 A2BEGrSPm3mEZ6vcHiOp0NwzfqYFfjz3uAbtEm03UI+Q1fYrtgauyusoaLvsq2ySAu
	 /enysdTw7IO7A==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 20 May 2026 16:42:55 +0200
Subject: [PATCH RFC v2 2/5] exec: introduce struct task_exec_state and
 relocate dumpable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-work-task_exec_state-v2-2-9ea88ceb09e6@kernel.org>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6201; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dThgtvzDrZEUCezq6zPZNdoAyE4ONp+2UjZuyf0hWjA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTxnmi+Ou9O8+qk+k1Pds0MspnDdeLbFLWms8t2bNjuo
 PX0158f9R2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQAT2ePEyLBtbfn/N4W3RWw4
 Yyq33PohsPl8cIaldPoebdGI+lcMdk8YGZ7w8fw+lRnvfbhn3QvlsIa5Aafs9k2uNQ7xOqgyoVi
 3lgcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: k46cs1if7xau7jcocj1roaz3ur6uok9c
X-Rspam-User: 
X-Rspamd-Queue-Id: 7832EC000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1779288207-205676
X-HE-Meta: U2FsdGVkX19VMgd5wWpE4ZnQ+mh0ZZRo3i/HU9ohu3tOEOBE/VdmZ/bozx278efkXpOKNM1THhLMX/eroX6IPbrhDKxVcM8NJTP3XwyeJDZfQCB4lD7ZMwuLXK1PAIKr80Rj0FcVLLeFvfX30XilCt5vCcdSafcQtAS4F7M69JApwq4CJC718JkNHGuiJledFmi4npVBDZ1l3Te06xGtKBsgfTLTVaSk583q9QuAwxHY3mwr0rMQ7Is0+zlCBJwlWf5TLuB7m6+fRBRdezGM0T7FU6aU9Zrd0p4qAQ5ICmtRYqP4QMlErll+eGyuB0rZjMsttw/ykkLCo3Z1pVYdWAyjPm0QKSV/DOde2Lnf/E7BSNfCgHmMmEAgaZ7hZMZ3X5Upt158oY1KvMSBdwNl/mbegxIzMNo2nUdmL1FnfJFX7nQYfI9BoxJTLVyDtXWZT2kMuZ2/WUr5OJlYdB/tN8G/H8alSUW22YRXndoC7wPDTjToTGEM8BTN/sVbjZwdeKqZAKa8rDBGxGW8cfzvOOXnTR2IQ/9CopHasLfCCOHXhAk2D9Pqi8wy5nva6XgI1CSxtIgOoCwfMrYPiIWjkkSR5mnRSS+witJwHLE4F+2WY6FjDOOFk8y4HWcg34u6p5E6FvwDP2084S4MPYw3Z5IK2AkK3e7Nv36W8gSTHJnBcURSPF/zB70MuyMbYnxT07dbX/kP+7zRFTsyS6wmD+L4o0P25ofJuDOVG9G9EZEFKWU/vcMrmW6XuxVP3SfO+jgzSVZo6tlXfI9nm+7D2MqbiDEmOjfYIQSvpMsD4J2Tr0ILWZUsozWYPpEGu0MZdXAPnWUEWYdzZbZQS11N4fgoeDFYp7nqBLD6XCczAev+iyqeUnrQrSSrBx5dmjO5DZcHcx7oCl6jZ2jOyDKsA2vKt6+ZHafrR6Qd1B5RXUyPGWc9K13U3s3PSkQZhyMQ4CKDUGhRKYuFZdqyxkv
 haBjvvoU
 ITnDdz5iBiqUBgu1t0gLH/zZ07rJnQSSw4YU3EjZPAjGapLoPjzggRjGXjTYc45SYfyAZviBzKf7uiKFpWUn97f3XGbY3MthmHeJsZGdinZqdr2YdeHuDfN/++RqkTkexUMyAKUWMhlEJvFynVCsYXwEr4NXhz2kxNTj7iVdfFupkvdZ9Lz9LsZjjJW4drKphy/BUTPSy7ke0eKT1vvzeVJheFmN/rFusHlt6+uw1BFxZFCxDcoMRJtwpd2KGLQsdzvyl40pHnqQvaVnZ3l2tDaXmH8UPBQAej2YcDy82oD772+4+Iu5PS5p/ivJVYyBUbEyY
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/linux/sched.h            |   3 ++
 include/linux/sched/exec_state.h |  31 ++++++++++++
 kernel/Makefile                  |   2 +-
 kernel/exec_state.c              | 105 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee06cba5c6f5..d895c3ff2154 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -962,6 +962,9 @@ struct task_struct {
 	struct mm_struct		*mm;
 	struct mm_struct		*active_mm;
 
+	/* Exec-time state outliving exit_mm(); see <linux/sched/exec_state.h>. */
+	struct task_exec_state __rcu	*exec_state;
+
 	int				exit_state;
 	int				exit_code;
 	int				exit_signal;
diff --git a/include/linux/sched/exec_state.h b/include/linux/sched/exec_state.h
new file mode 100644
index 000000000000..7a267efc34d3
--- /dev/null
+++ b/include/linux/sched/exec_state.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+struct task_exec_state *alloc_task_exec_state(void);
+void put_task_exec_state(struct task_exec_state *es);
+struct task_exec_state *task_exec_state_rcu(const struct task_struct *tsk);
+struct task_exec_state *task_exec_state_replace(struct task_struct *tsk,
+						struct task_exec_state *exec_state);
+void task_exec_state_set_dumpable(enum task_dumpable value);
+enum task_dumpable task_exec_state_get_dumpable(struct task_struct *task);
+void copy_exec_state(struct task_struct *tsk);
+void __init exec_state_init(void);
+
+DEFINE_FREE(put_task_exec_state, struct task_exec_state *,
+	    if (_T) put_task_exec_state(_T))
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
index 000000000000..85178b1d2c57
--- /dev/null
+++ b/kernel/exec_state.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/init.h>
+#include <linux/rcupdate.h>
+#include <linux/refcount.h>
+#include <linux/sched.h>
+#include <linux/sched/coredump.h>
+#include <linux/sched/exec_state.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+
+static struct kmem_cache *task_exec_state_cachep;
+
+static void __free_task_exec_state(struct rcu_head *rcu)
+{
+	struct task_exec_state *es = container_of(rcu, struct task_exec_state, rcu);
+
+	kmem_cache_free(task_exec_state_cachep, es);
+}
+
+void put_task_exec_state(struct task_exec_state *es)
+{
+	if (es && refcount_dec_and_test(&es->count))
+		call_rcu(&es->rcu, __free_task_exec_state);
+}
+
+struct task_exec_state *alloc_task_exec_state(void)
+{
+	struct task_exec_state *es;
+
+	es = kmem_cache_alloc(task_exec_state_cachep, GFP_KERNEL);
+	if (!es)
+		return NULL;
+	refcount_set(&es->count, 1);
+	es->dumpable = TASK_DUMPABLE_OFF;
+	return es;
+}
+
+struct task_exec_state *task_exec_state_rcu(const struct task_struct *tsk)
+{
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held() && !lockdep_is_held(&tsk->alloc_lock),
+			 "task_exec_state_rcu() requires RCU or task_lock");
+	WARN_ON_ONCE(!tsk->exec_state);
+	return rcu_dereference(tsk->exec_state);
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
+ * exec_state is anchored to the execve() that established the current
+ * privilege domain.  All clone() variants refcount-share it; only a
+ * subsequent execve() in the child swaps in a fresh one.
+ */
+void copy_exec_state(struct task_struct *tsk)
+{
+	struct task_exec_state *es = current->exec_state;
+
+	refcount_inc(&es->count);
+	rcu_assign_pointer(tsk->exec_state, es);
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
+	struct task_exec_state *es;
+
+	if (WARN_ON(value > TASK_DUMPABLE_ROOT))
+		value = TASK_DUMPABLE_OFF;
+
+	es = rcu_dereference_protected(current->exec_state, true);
+	WRITE_ONCE(es->dumpable, value);
+}
+
+enum task_dumpable task_exec_state_get_dumpable(struct task_struct *task)
+{
+	struct task_exec_state *es;
+
+	guard(rcu)();
+	es = rcu_dereference(task->exec_state);
+	return READ_ONCE(es->dumpable);
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


