Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC68B606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LRTVeJOZ
Received: by kanga.kvack.org (Postfix)
	id 6CF7F6B05BB; Tue, 17 Nov 2026 00:09:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FFF6B05BC; Tue, 17 Nov 2026 00:09:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548F26B05BD; Tue, 17 Nov 2026 00:09:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB99D6B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4910E1602A7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:03 +0000 (UTC)
X-FDA: 85443431766.26.21CCBD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96FDC40006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRTVeJOZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNG+HKNgYzQ2OTreil5lKozs9Q2/l93uy/4zE3pXacs=;
	b=UW4qyK+YwXEsICkXzchtRPwVIG4xNOq4O0pB4F8lSGJ+YUsu3VgMfkXE0lmWz6aMapVqdt
	m+Wm43msPB6nr+xLl0g+9a4ZcMxYJwzODGQltB0YJBzKQecu7th1YeVcET3g31qKgqv9sX
	888kUqiYMg2USAG6FVqPVdOuCYl2ick=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892141;
	b=qCT7xYtCu1Jp27xG3G6iHgFin+9Miv3tk3UAfY0nnvz7mVgelo9UiG5rqIu3nnJ20H2CLV
	3Xw1mQ9mE+MmtuhIT5ljXaFG3U9AwdSG6J9QAPbg3S7QuUBNpuSknLsKq0XVgJPMidLVCT
	Q6k0DSA4OxoQ6OE8iPqIEPSwqOg13bw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRTVeJOZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E3817465D6;
	Tue, 17 Nov 2026 05:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 255701F000CA;
	Tue, 17 Nov 2026 05:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892140;
	bh=vNG+HKNgYzQ2OTreil5lKozs9Q2/l93uy/4zE3pXacs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRTVeJOZubBlni17eDMR11FhIM6qThAN6ldsJPvhAPnsP21yiOmtyaYZfJKpEVTjS
	 A+VWbIFgxKM1SPwRlzA33iUP5Wdyn8PbdUv2d18N+OrK8SlWdipqzTpVltTaVSXFbH
	 1JMZPM84gMrxrZAn1pBlFrTVplMfSdJgEbR/OwqlFNcnARvxCvk+dWeZ/nh+lamD2h
	 2srb7B25NohMO9+sesXQbcQYD7dA9SE9HI0gRTRYtmh4NuBC9Qsw/4rRxt0LcUeQ5U
	 n+UgwyXn8boc1E0l9M91uzPmKhvbDIN0MQNEC/MNO7s4is+16K5sNGuqrP8gJz4fim
	 KNbf2rOpg00xA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 03/13] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Tue, 17 Nov 2026 07:08:31 +0200
Message-ID: <20261117050841.3289652-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 96FDC40006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dg5a3cmj89kcid16xpbc6zryqxhp4k5k
X-Rspam-User: 
X-HE-Tag: 1794892141-120183
X-HE-Meta: U2FsdGVkX1+nBIcDHEzEKe4CiYI/sKq5IR7HLm2tZSvvm//+ddg+WwNvtsFJ79BUnbpuwV0HZbIVA7B4vB73HVV0BrD3QSZfJo44xOhbcuho/XGTzEIEfPJnyCOWqH47pPuwFQiOIoyzW4FsAzit+EP1u4+xv+gD78+ImJjGZoFOV1oQ6cLGfFnAlHefEC63ROxfYHKOKYVMbjUhEKKOk2QvSqdIDRzyQlv0Xsx5FfQpD5xVGavO1MYhnFkSEc/8SyIHBBxdAdmkcFknHab7PUvEKXgiqxV/OiAp4exUCvMteY6fDZyzhaq0GHE4tCdQPtDJrf4+1Ai6voHzbFId2mSST11BVFyAiZNAbMCevI81lWXjXpiIHWJeTCHtlm7Ou33p175ya1DULd9qCYp2z1/YhkGQcJFkteIAu3oxpvzOikS5miRBXmGB8k2mAzxl1yA++69vB7XuhGXugO0MscEmYKBANkn/RYe7ngCr79rU10+4Ds/vqJJYfGN4KVP/2fT8bNDk/nrxTyuUYHSjxzuWewCvFU8QbOWIKYmVePeu6HHzsKZBamtVHopm1sv/5jEWXOiqoAaVOjcVhBVO9ojdSzLRCyv3JBPzExtmcNoIpWRqeLL6vNVYkuRR6hnJTv9DoNmQghPT1+63fguKOcLhzKeN3euLdzhOpZF9PgGhGKSGJHbmzGmgYYJRE7V/v5VGX4fEFyjUc3ZpvJNgcmD3Gt+WZiw8ZDqNSdOBFBtT17VjaujwZhMrVvUV5fU2vl2Ga38PjtFixWR8KSWW80a4qEcb6P/MPPosPpWvKqwNI0qNW9psBKr2MgBNOMEJtpCAcEX7+81kdiBP4ca4chx4HOIUzuYK71LFzSetXINWXyaJsYs2F0J5f1KUQhbyGBQ9Lb/whHRqe5dd9ZUlf0jvN99s3uW03HDeD+42H1HT1kWhkqR4dhSVIns/2+0oZsccRKlIXUfw+cu8IIB
 SgMF/gU/
 8WdyKev1ht7QyG6Rwyxn6MlxNzg7F7/rXRatnXhSNrywovFUSeiCEjVQ+pXhevJOfoLuwgNC7O+4vs8D/yqK2T6Q+OfRcLSDvx3Ta3Vmvk2Y3qrkc43edV1o0sG8HBuMHv5Uod0KSmSwjqXVA1+P4EpTAovjxOqUjdZoo5LfkdQsZ1n3t3C+Q4xW9DLOX7uei9ISMtdCk8C+YNl+XeW05Bwr6kBi0NkBGFTss49/H8c3uoCMq3tMIrTLxc2fyl9NEhZCtRxv/pZ8+DVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A root namespace needs to record its init thread group's PID when
bootstrapped and capture its exit status and resource usage once all
processes in the root namespace have terminated, without serializing
normal fork() and exit() paths inside the container.

Represent the initial host context with a NULL nsproxy->rootns pointer,
commit the bootstrap init PID and wake waiters in copy_rootns(), and
invoke exit_rootns() from zap_pid_ns_processes() after the root
namespace's PID namespace has killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/nsproxy.h       | 16 ++++++++++++++
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 12 +++++++++++
 kernel/fork.c                 |  2 ++
 kernel/nsproxy.c              |  4 ++++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 40 +++++++++++++++++++++++++++++++++++
 7 files changed, 80 insertions(+)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 23cbeee6b1e4..7d0b636387c6 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -12,6 +12,7 @@ struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
 struct fs_struct;
+struct rootns;
 struct user_namespace;
 
 /*
@@ -40,9 +41,24 @@ struct nsproxy {
 	struct time_namespace *time_ns;
 	struct time_namespace *time_ns_for_children;
 	struct cgroup_namespace *cgroup_ns;
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns;
+#endif
 };
 extern struct nsproxy init_nsproxy;
 
+#ifdef CONFIG_ROOTNS
+static inline struct rootns *task_rootns(const struct task_struct *tsk)
+{
+	return tsk->nsproxy ? tsk->nsproxy->rootns : NULL;
+}
+#else
+static inline struct rootns *task_rootns(const struct task_struct *tsk)
+{
+	return NULL;
+}
+#endif
+
 /*
  * A structure to encompass all bits needed to install
  * a partial or complete new set of namespaces.
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b20baaa7e62b..6fd959f4d0d4 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,6 +15,7 @@
 #define MAX_PID_NS_LEVEL 32
 
 struct fs_pin;
+struct rootns;
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 /* modes for vm.memfd_noexec sysctl */
@@ -45,6 +46,9 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	int reboot;	/* group exit code if this pidns was rebooted */
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns;
+#endif
 	struct ns_common ns;
 	struct work_struct	work;
 } __randomize_layout;
diff --git a/include/linux/rootns.h b/include/linux/rootns.h
index 8464c90863ac..b8437bf21830 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -16,6 +16,7 @@ struct cred;
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
 struct task_struct;
 
 enum rootns_state {
@@ -47,6 +48,8 @@ struct rootns {
 struct rootns *get_rootns(struct rootns *c);
 void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
+void copy_rootns(struct task_struct *tsk, struct rootns *rootns);
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -61,6 +64,15 @@ static inline bool is_rootns_file(struct file *file)
 {
 	return false;
 }
+
+static inline void copy_rootns(struct task_struct *tsk, struct rootns *rootns)
+{
+}
+
+static inline void exit_rootns(struct pid_namespace *pid_ns,
+			       struct task_struct *tsk)
+{
+}
 #endif /* CONFIG_ROOTNS */
 
 #endif /* _LINUX_ROOTNS_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..99e22b3cd213 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -83,6 +83,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_event.h>
+#include <linux/rootns.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
@@ -2565,6 +2566,7 @@ __latent_entropy struct task_struct *copy_process(
 			attach_pid(p, PIDTYPE_TGID);
 			attach_pid(p, PIDTYPE_PGID);
 			attach_pid(p, PIDTYPE_SID);
+			copy_rootns(p, NULL);
 			__this_cpu_inc(process_counts);
 		} else {
 			current->signal->nr_threads++;
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8a3c6d4e94e2..a76837b3ee33 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/nsproxy.h>
 #include <linux/ns/ns_common_types.h>
+#include <linux/rootns.h>
 #include <linux/init_task.h>
 #include <linux/mnt_namespace.h>
 #include <linux/utsname.h>
@@ -142,6 +143,9 @@ struct nsproxy *create_new_namespaces(u64 flags,
 		goto out_time;
 	}
 	new_nsp->time_ns = get_time_ns(ns->time_ns);
+#ifdef CONFIG_ROOTNS
+	new_nsp->rootns = ns->rootns;
+#endif
 
 	return new_nsp;
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 127a5fd23e70..081c27aa85bd 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/idr.h>
 #include <linux/nstree.h>
+#include <linux/rootns.h>
 #include <uapi/linux/wait.h>
 #include "pid_sysctl.h"
 
@@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		current->signal->group_exit_code = pid_ns->reboot;
 
 	acct_exit_ns(pid_ns);
+	exit_rootns(pid_ns, me);
 	return;
 }
 
diff --git a/kernel/rootns.c b/kernel/rootns.c
index e75d918b93ec..e3b203322ae2 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -16,6 +16,7 @@
 #include <linux/ns_common.h>
 #include <linux/nsfs.h>
 #include <linux/pid.h>
+#include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
 #include <uapi/linux/rootns.h>
@@ -105,3 +106,42 @@ bool is_rootns_file(struct file *file)
 {
 	return file->f_op == &rootns_fops;
 }
+
+void copy_rootns(struct task_struct *tsk, struct rootns *c)
+{
+	if (likely(!c || READ_ONCE(c->state) != ROOTNS_FORKING))
+		return;
+
+	scoped_guard(spinlock, &c->lock) {
+		get_rootns(c);
+		WRITE_ONCE(c->init_pid, get_task_pid(tsk, PIDTYPE_TGID));
+		WRITE_ONCE(c->state, ROOTNS_RUNNING);
+	}
+	wake_up_all(&c->waitq);
+}
+
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
+{
+	struct rootns *c = pid_ns->rootns;
+	struct task_struct *leader;
+	struct rusage rusage;
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+	getrusage(leader, RUSAGE_BOTH, &rusage);
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		c->rusage = rusage;
+		WRITE_ONCE(c->state, ROOTNS_DEAD);
+	}
+
+	pid_ns->rootns = NULL;
+	wake_up_poll(&c->waitq, EPOLLHUP);
+	put_rootns(c);
+}
-- 
2.47.3


