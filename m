Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C54D3CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147EC6B008A; Tue, 29 Sep 2026 09:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F496B008C; Tue, 29 Sep 2026 09:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02386B0092; Tue, 29 Sep 2026 09:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF8816B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:02:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FBA41C329E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:02:11 +0000 (UTC)
X-FDA: 85266812862.28.A262D24
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6EAF080019
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:02:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nm9PVa8x;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790686929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XAn6zhR8TlnHteI0nnuYbqgMQj+LJ5WKgZIIVFlK7s=;
	b=Bmtjefq7j31lpDeYAMXQWLn6Acs2ns+q5QipteACcDmI24Mav/F/YWmCL5yD/nRGMwOXkk
	qKtd8cGmNpl+7xTQGqXhMVqcQHEx6nnja53Ll+XNtTnU0PAvj52JW/MlFxS3RJn6pASHA2
	6njwYw3otxA83xO/2IeoRFqGeT9JU7c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nm9PVa8x;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790686929;
	b=2Y6SsMBGBh0cNKy3ZICwA7aFDiTAsbRCTDVA5FmeEH4txcQAn5RQqwRzzPft9MgtvYFKNg
	LkI+SAh6Y6dRc2ptkQqtlbGFyvaV/5cmUg1O5HYnn4SU8qHkZ5nHFuKiyhfKOEBUWa7lum
	lLp/m/Ni4n3NEy8QJwUf9VPNAfVGdLA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5XAn6zhR8TlnHteI0nnuYbqgMQj+LJ5WKgZIIVFlK7s=;
	b=nm9PVa8xFIBgUvAqkBLN7U2om6/WJA5JNCCyDV+s5uzWQHz03DBdIBMFb0HAwGv9MnRPg1eEz
	gVd9nay2uVFictUymaPVaIUKvkWZmAvVDBfFKelpSTOJzglAbY1t3IU5jAjTHYQz71Fsr04ru4A
	JvPKxJRp6w8eG0sExmy57zk=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hvJ126fKHz12LHn;
	Tue, 29 Sep 2026 20:49:58 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 884D24057D;
	Tue, 29 Sep 2026 21:02:01 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 21:02:00 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <serge@hallyn.com>, <kees@kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <mingo@redhat.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<paul@paul-moore.com>, <jmorris@namei.org>, <shuah@kernel.org>,
	<oleg@redhat.com>, <brauner@kernel.org>, <alexjlzheng@tencent.com>,
	<jannh@google.com>, <jaime.saguillo@gmail.com>, <elver@google.com>,
	<blbllhy@gmail.com>, <bvanassche@acm.org>, <pjw@kernel.org>,
	<broonie@kernel.org>, <debug@rivosinc.com>, <tglx@kernel.org>,
	<aleksey.oladko@virtuozzo.com>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <morgan@kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for process-wide bounding-set drops
Date: Tue, 29 Sep 2026 21:01:59 +0800
Message-ID: <20260929130200.1638343-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260929130200.1638343-1-ruanjinjie@huawei.com>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: hsx5fp3s3o5wrcfr3ugchui6q8nhu6d6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6EAF080019
X-HE-Tag: 1790686928-937296
X-HE-Meta: U2FsdGVkX19yJlc51bcxc12GHqnuGj+zcDXLP6+XzRqHptup5U33s8msK3kO+cVvIGWof/qlsCUMqyUoIRfN0Qgq1eVxFYQFwMfwdHEBDUIk9ERjGku+kIGZ+sZBAlpfLs3ly07nCDiBgkOcfTqQoFLB0bhwJZFQm4M/U/CTOHjn407qt5bKssVn4mbUkBHiIyaDg88S1paMd0rCHxRcD0SpfJaC/iKKlKA/OEqNBPpeQSTzkuEEOGo9+hCYgn4nMo9YOBYKH1L9POFjzGtIIa1sEkBeX1Ju6fH8c9l+j2gcQahTXLhb5RiwqXSOcLTq+pqsF4URUwdPziQyvOR9siqz95Uaw7dkeveh+PNxMOZ7nqyMEVKqMhZK8qnCjHFFM7fNqikIhWRCDBownmiyhj2varRK/lpoGaXMu7PCwZOcr6+hiOOTvVUv/8d5y3eGfOxzOF9ef837a0+YBcm+l2BKwPTXTrag0vi3RmEkIHQuygdVywYJv8pvOLYdGHyqZrbmeEpdSvXyUasPgaC3S4fEyk1zi6cRpyTZZe09RJ+zgdwXKfycOHheIP2XiEg/0iiFRSZBKuftQdXkb/RkCCFxCf6TnpxJj+2nZLbWYabVlNZYZB7PiwpPSm9BQ+YtJhhNSW8CNGCU87WBZ1aY7Lrp8et7NRGoj+Oz6zIjPfj0pM9WAlfNYUjwHv8km4oGMethAFqjbVUktRlU9QVPR+T+HvRFrXO/aWPZWl72Zp5cmtTmlaXqAjV236rlTLvmH+BGg5WsuGwu5bW4ZydxlcnXN1qkHHC4/sQ5g8rMmuLFh1SDvBfrz9O7CYTjEBNGgD+Bycz84dGO4DRb6njKsktfgy6eR0LIposlRDzKBgrRfzR0ei+b8KOoC5sjV81A4JsN0iTbtEmxTr5ZEezodD1kAtUu+CEB8De87v3LxpUH73/9Q9AfO6xW09Zp8Xk9H3iGisjxlapW0+XPvRb
 wgsnlCq0
 WP9JPs4DZyCZkympkzybJHvicxCvsYowFt/zotsa0LcKh+22sbeNpX8At22knunrtQ/Fgf9Qs+oCkWMLA+knfGgtjUYHFngHeDS86L/kqYN15gqa3bzpMah5aCX9LcyfWjGKozHlhkHckOA5d17eO9VbxmauYYIQjufJlVMDXdg6XUXFAozio2RP2wRR4kyMjhgzHeyVd5GIB9n/HHhSq5UWbjfUXjMnA8rVd7zBsM5+wrSmjexFQMu6+3sgWz4RKnj5d/BxybUZz72g5UD+BhSVP8m6/VN/wOiuMuizmtdtjNmzPWrecAmzh+88zyDk3ajrOwR4CDn4P35tSCuRH9eehxZN174nB5+ESv8NNk+KzYNwXPDdvRKiuvL8Z6cInxXHqrR8A1Bk/J5MdcDVarz25dqw+58GjsS2M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PR_CAPBSET_DROP only affects the calling thread. Process-wide capability
dropping requires user space to loop over every thread and every
capability, which is highly expensive. For instance, long-lived
multi-threaded processes (like gVisor's sentry) spend milliseconds
trimming the bounding set because the runtime has to coordinate
and signal every thread.

Add PR_CAPBSET_DROP_MASK, an opt-in prctl that removes a set of
capabilities from the entire thread group's bounding set in a single call.
The capabilities are specified via a 64-bit mask across arg2 (low 32 bits)
and arg3 (high 32 bits).

The drop is recorded in a per-thread-group mask,
signal_struct::cap_bset_pending, under sighand->siglock. This pending drop
is dynamically folded into the bounding set in critical paths:
cap_capset(), PR_CAPBSET_READ(), and cap_bprm_creds_from_file().
Running, concurrently created, or future threads within the group will
all immediately observe the drop. A forked child inherits this mask
in cap_bset_drop_fork() under siglock to close the race window
against clone().

The operation is drop-only, so concurrent callers commute and a single
atomic OR is the linearization point.  It performs no per-thread allocation
and only the caller's replacement cred can fail, reported synchronously as
-ENOMEM before anything changes.

In an arm64 KVM guest, trimming 41 capabilities of a multi-threaded Go
process takes ~8.5-23.6ms with the per-thread PR_CAPBSET_DROP loop and
~11-14us with PR_CAPBSET_DROP_MASK, independent of the thread count.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 fs/proc/array.c              |  3 +-
 include/linux/capability.h   |  5 ++
 include/linux/sched/signal.h |  8 ++++
 include/uapi/linux/prctl.h   |  1 +
 kernel/fork.c                |  1 +
 security/commoncap.c         | 91 ++++++++++++++++++++++++++++++++++--
 6 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index f6f75d206762..f1cde26d079c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -63,6 +63,7 @@
 #include <linux/tty.h>
 #include <linux/string.h>
 #include <linux/mman.h>
+#include <linux/capability.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/numa_balancing.h>
 #include <linux/sched/task_stack.h>
@@ -318,7 +319,7 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 	cap_inheritable	= cred->cap_inheritable;
 	cap_permitted	= cred->cap_permitted;
 	cap_effective	= cred->cap_effective;
-	cap_bset	= cred->cap_bset;
+	cap_bset	= cap_bset_effective(p, cred);
 	cap_ambient	= cred->cap_ambient;
 	rcu_read_unlock();
 
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7921a0b3b04a..6413c7fedb69 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -38,6 +38,7 @@ struct file;
 struct inode;
 struct dentry;
 struct task_struct;
+struct cred;
 struct user_namespace;
 struct mnt_idmap;
 
@@ -197,6 +198,10 @@ bool capable_wrt_inode_uidgid(struct mnt_idmap *idmap,
 			      const struct inode *inode, int cap);
 extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
 extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
+extern kernel_cap_t cap_bset_effective(const struct task_struct *task,
+				       const struct cred *cred);
+extern void cap_bset_drop_fork(struct task_struct *p);
+
 static inline bool perfmon_capable(void)
 {
 	return capable(CAP_PERFMON) || capable(CAP_SYS_ADMIN);
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index d45a5476b97d..bda6f18b65b9 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -98,6 +98,14 @@ struct signal_struct {
 	int			quick_threads;
 	struct list_head	thread_head;
 
+	/*
+	 * Capabilities being removed from the bounding set of every thread in
+	 * this group by PR_CAPBSET_DROP_MASK.  Read on capability-transition
+	 * paths without sighand->siglock, hence atomic64 (a 64-bit value would
+	 * otherwise tear on 32-bit).
+	 */
+	atomic64_t		cap_bset_pending;
+
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
 
 	/* current thread group signal load-balancing target: */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index b6ec6f693719..85ac71897070 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -70,6 +70,7 @@
 /* Get/set the capability bounding set (as per security/commoncap.c) */
 #define PR_CAPBSET_READ 23
 #define PR_CAPBSET_DROP 24
+#define PR_CAPBSET_DROP_MASK 82
 
 /* Get/set the process' ability to use the timestamp counter instruction */
 #define PR_GET_TSC 25
diff --git a/kernel/fork.c b/kernel/fork.c
index 5ef413368912..bf671a85d39d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2504,6 +2504,7 @@ __latent_entropy struct task_struct *copy_process(
 	 * before holding sighand lock.
 	 */
 	copy_seccomp(p);
+	cap_bset_drop_fork(p);
 
 	if (clone_flags & CLONE_NNP)
 		task_set_no_new_privs(p);
diff --git a/security/commoncap.c b/security/commoncap.c
index 3399535808fe..3bec15d43731 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/audit.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -19,6 +20,7 @@
 #include <linux/hugetlb.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
+#include <linux/sched/signal.h>
 #include <linux/prctl.h>
 #include <linux/securebits.h>
 #include <linux/user_namespace.h>
@@ -30,6 +32,25 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/capability.h>
 
+/**
+ * Effective bounding set of @cred in @task's thread group
+ * @task: task whose thread group's pending drop applies
+ * @cred: credentials to read the bounding set from
+ *
+ * A drop recorded by PR_CAPBSET_DROP_MASK is authoritative on the thread group
+ * and may not have been materialized into every thread's cred yet, so the
+ * effective bounding set is the cred's own set minus the group's pending drop.
+ */
+kernel_cap_t cap_bset_effective(const struct task_struct *task,
+				const struct cred *cred)
+{
+	kernel_cap_t pending = {
+		.val = atomic64_read(&task->signal->cap_bset_pending),
+	};
+
+	return cap_drop(cred->cap_bset, pending);
+}
+
 /*
  * If a non-root user executes a setuid-root binary in
  * !secure(SECURE_NOROOT) mode, then we raise capabilities.
@@ -284,8 +305,8 @@ int cap_capset(struct cred *new,
 
 	if (!cap_issubset(*inheritable,
 			  cap_combine(old->cap_inheritable,
-				      old->cap_bset)))
 		/* no new pI capabilities outside bounding set */
+				      cap_bset_effective(current, old))))
 		return -EPERM;
 
 	/* verify restrictions on target's new Permitted set */
@@ -849,7 +870,7 @@ static void handle_privileged_root(struct linux_binprm *bprm, bool has_fcap,
 	 */
 	if (__is_eff(root_uid, new) || __is_real(root_uid, new)) {
 		/* pP' = (cap_bset & ~0) | (pI & ~0) */
-		new->cap_permitted = cap_combine(old->cap_bset,
+		new->cap_permitted = cap_combine(new->cap_bset,
 						 old->cap_inheritable);
 	}
 	/*
@@ -925,6 +946,8 @@ int cap_bprm_creds_from_file(struct linux_binprm *bprm, const struct file *file)
 	int ret;
 	kuid_t root_uid;
 
+	new->cap_bset = cap_bset_effective(current, new);
+
 	if (WARN_ON(!cap_ambient_invariant_ok(old)))
 		return -EPERM;
 
@@ -1283,6 +1306,63 @@ static int cap_prctl_drop(unsigned long cap)
 	return commit_creds(new);
 }
 
+static int cap_bset_drop_process(kernel_cap_t mask)
+{
+	kernel_cap_t pending;
+	struct cred *new;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	/*
+	 * Record the drop before committing the caller's cred, so that a
+	 * thread created from now on is guaranteed to observe it.  Apply the
+	 * current union, not just this call's mask, to the caller's cred.
+	 */
+	spin_lock_irq(&current->sighand->siglock);
+	atomic64_or(mask.val, &current->signal->cap_bset_pending);
+	pending.val = atomic64_read(&current->signal->cap_bset_pending);
+	spin_unlock_irq(&current->sighand->siglock);
+
+	new->cap_bset = cap_drop(new->cap_bset, pending);
+	commit_creds(new);
+
+	return 0;
+}
+
+/*
+ * Propagate a pending process-wide bounding-set drop to @p, a task being
+ * created by the current thread.  Threads sharing the group read
+ * current->signal->cap_bset_pending directly; a forked child gets its own
+ * signal_struct and must carry the mask itself.  Called under
+ * current->sighand->siglock, which serializes it with cap_bset_drop_process().
+ */
+void cap_bset_drop_fork(struct task_struct *p)
+{
+	kernel_cap_t mask = {
+		.val = atomic64_read(&current->signal->cap_bset_pending),
+	};
+
+	if (cap_isclear(mask) || p->signal == current->signal)
+		return;
+
+	atomic64_or(mask.val, &p->signal->cap_bset_pending);
+}
+
+static int cap_prctl_drop_mask(unsigned long low, unsigned long high)
+{
+	kernel_cap_t mask = mk_kernel_cap((u32)low, (u32)high);
+
+	if (cap_isclear(mask))
+		return 0;
+
+	if (!ns_capable(current_user_ns(), CAP_SETPCAP))
+		return -EPERM;
+
+	return cap_bset_drop_process(mask);
+}
+
 /**
  * cap_task_prctl - Implement process control functions for this security module
  * @option: The process control function requested
@@ -1308,11 +1388,16 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 	case PR_CAPBSET_READ:
 		if (!cap_valid(arg2))
 			return -EINVAL;
-		return !!cap_raised(old->cap_bset, arg2);
+		return !!cap_raised(cap_bset_effective(current, old), arg2);
 
 	case PR_CAPBSET_DROP:
 		return cap_prctl_drop(arg2);
 
+	case PR_CAPBSET_DROP_MASK:
+		if (arg4 || arg5)
+			return -EINVAL;
+		return cap_prctl_drop_mask(arg2, arg3);
+
 	/*
 	 * The next four prctl's remain to assist with transitioning a
 	 * system from legacy UID=0 based privilege (when filesystem
-- 
2.34.1


