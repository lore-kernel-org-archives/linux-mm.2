Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C582A606E7E0
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BI0Et5CR
Received: by kanga.kvack.org (Postfix)
	id C61CC6B05BD; Wed, 18 Nov 2026 14:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11D36B05BE; Wed, 18 Nov 2026 14:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD95D6B05BF; Wed, 18 Nov 2026 14:36:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 783116B05BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F422D4053B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:06 +0000 (UTC)
X-FDA: 85449245574.24.9F47588
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 660A24000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BI0Et5CR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UK2QSbO062LnQuz1tkI8icjaJvbyI6KvhAL90QcImW0=;
	b=5KvMsO5SKuG7MJebL9B/QZ16UEgQl0N66HVk29xO7PwdpoN6JtlTe4GKlUq/VjIVqmG88P
	DN5HkBbw8ogHHKQ8ZFFQKmLmhNzT40jn+vYQgTDMUooY/XGDM5KiubndUygP8L8OYkpYPj
	7ULcutNCpwPV/PFIX64X61SX2BJ49cc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BI0Et5CR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030565;
	b=yCPXUqLq+zC3VqJKiELA5zuQK1TD7VhAExlPR3GvtoVYsS1uP//rtJsz1ceh0MvNJmG1YT
	fVHkM5fzM/vJGU8EfLBUThC+KuwCoz0QDdUcuGQ6H0iXQXF9NutpP2GCCLZnXUlIatQjAl
	7+i/4fEuMqN0e8FCNoMX/GN6SQsai48=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 05D4763925;
	Wed, 18 Nov 2026 19:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0D8F51F000C6;
	Wed, 18 Nov 2026 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030564;
	bh=UK2QSbO062LnQuz1tkI8icjaJvbyI6KvhAL90QcImW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BI0Et5CRn4KX31VGAyFEpAwrtexdfaBkYXyvX+JLslxiBzy9/rLfhZNMS5RgFwSmf
	 +whQcNrZH7RstQCri8ubfUwkB90qAxVjKZTBi421+ngvuH8dlF+WcAtfk9JebLlwnA
	 22alUKX5rWKVMP3tzd9SLjbfYRzgnlMdU9yahje8W89y+kuWFUzZ39y4JbSAxkP8Xb
	 pAA5N1jel6fJdBloYpk71Eo87C2Tvt+ETEr1hvgg+oy0tRdk0GscJ7Bgxt2qs5V+2x
	 EGo6bX47yQUkKcBVAgX5vvuj0qpG06+uFZ1b8SX+g2lGHlWqrLAOkhDQeQXKGZdZmO
	 +0YfnPCWQi2/w==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 04/13] rootns: Add rootns_create() system call
Date: Wed, 18 Nov 2026 21:35:30 +0200
Message-ID: <20261118193539.240065-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 660A24000F
X-Stat-Signature: 9nkxup9it4est7n81fesdi9w8q5azh8j
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795030565-310982
X-HE-Meta: U2FsdGVkX193ju2PNVnnEzkFCsAanU+fE+UUmo9ZXTQy8lIrQVCATzk45FtkoZaCuTdMrwvJPKfbk+V+gjGmD2+lkBIkwSl31rrF17fMqE3yGijuje+j86IwB1hjn1NB+nlMQYIFTfNnn69BS5noCH/i4fMJyYpy9oRVZKPALU2pFbHffDQkwRaubAz7J0tL3aEcnqHfiWp9Z7Xwevu39A/1GKo81jxglynrBIETKP/qXmJ4FGsJRG9Np0Jqvut7JIHTctrsm0yqw4mzelbvhwYOkUe8IDQzCrA9JXWVZwj1A90vwVNYShkp2diSZSl5j8iMTBTUiB03PqlLnU0u9UlYiyRLG9zy80CD54MrT4fd6OFXTDO+DKdKuegh4BC2kfRs2BBFXAdi7LN/jjRT8LtA59XqnDDoe6ZsMSA9xrtobG6PfDm7aUUDx1/89LFiJXkKKLEgIUwyFnonRJshvPVFJQiO/Luf/SzgSit4yArdswPz0wxBZXrymKQuXJ/Syo83m3vgA3aWiUHdfXI2JSwOyZ0/dxw3bo68AEGR5bznpzKzNXx3ff/D3C2VNf62WvZ/cchpG7q0yazZqkn6fvrJExKNBXtJ8mVjiyt+dvnWFCtKBEhYeKgwsPfAy5Mu1Vjuc4qrDNjTpk6cbL6wDUX5Yz1e8bgayJrgAUJTPVBHgFlCkrFlcvFVcL2JE6GQsFuqfknihrPeA/+QYcqofey9R3PWY5t8UGyHwrce6U8ezwuQxe6Km3bvjAwPaYIQaTGzy9H2wQF3JZDjV2zteA2Ai35issdk9/+sI3vxUj4J3NOaRn5PdR4yGmecy1PXi6dqOhTqHR3WoLkQe6ZwTbG1TM6GifjeUe4O15ef15Gvdni4gFv2yIBBYHlSDA1Ea+PotXQTOPwVdWi0xflSncIWOWBZ/yv+8IiSxZMvFhiULhmWkyXdDuCe8KmkSXy5xC2ExQY8sD7rgVMjIrl
 pNl+rAHM
 VGeYuwHiKaKpsvp5r8PlSjedAHs4vqKvSZEfUZLPIYgPLSH7J/n83kvhItwcS/g8mUfd+FBnFZ17CD9E/eNMhVdVSEAqdNcElaOpFaaYl7nq85G6U4E8Tp7SoRJt7RS2aBBq5UJStNbfuKSEASw7wR6eRJUuy/cFCDaNjhzBuLlWvF1vg3IAuE3wkgr1WIb2KJwOfPTZ5XPFssV+TzA08LAg6m4W6Wisc7NZPjGTMcd2l4tAROlLgtAir7JyKlU83i56tUOAQsFo4bwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Setting up an isolated namespace environment from a multithreaded
manager process currently requires helper processes to call unshare()
and pass file descriptors back over sockets.

Add the rootns_create() system call to allocate a detached rootns
instance owning a fresh user namespace alongside dedicated empty mount
(CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
namespaces, and return its control file descriptor. Finalize the nsproxy
time namespace and pin active references for the lifetime of the rootns.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h       |   1 +
 include/linux/time_namespace.h |  13 ++++
 kernel/rootns.c                | 106 +++++++++++++++++++++++++++++++++
 kernel/sys_ni.c                |   3 +
 4 files changed, 123 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 552d9710a0d5..272d54bddbe2 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1006,6 +1006,7 @@ asmlinkage long sys_lsm_get_self_attr(unsigned int attr, struct lsm_ctx __user *
 asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *ctx,
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
+asmlinkage long sys_rootns_create(unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index 58bd9728df58..bdc185543893 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -60,6 +60,15 @@ static inline void put_time_ns(struct time_namespace *ns)
 		free_time_ns(ns);
 }
 
+static inline void timens_activate_nsproxy(struct nsproxy *nsproxy)
+{
+	if (nsproxy->time_ns != nsproxy->time_ns_for_children) {
+		get_time_ns(nsproxy->time_ns_for_children);
+		put_time_ns(nsproxy->time_ns);
+		nsproxy->time_ns = nsproxy->time_ns_for_children;
+	}
+}
+
 void proc_timens_show_offsets(struct task_struct *p, struct seq_file *m);
 
 struct proc_timens_offset {
@@ -125,6 +134,10 @@ static inline void put_time_ns(struct time_namespace *ns)
 {
 }
 
+static inline void timens_activate_nsproxy(struct nsproxy *nsproxy)
+{
+}
+
 static inline
 struct time_namespace *copy_time_ns(u64 flags,
 				    struct user_namespace *user_ns,
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 4f40dac4225f..c420e36af603 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -199,3 +199,109 @@ void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
 	wake_up_poll(&c->waitq, EPOLLHUP);
 	put_rootns(c);
 }
+
+static struct user_namespace *create_rootns_user_ns(void)
+{
+	struct user_namespace *user_ns;
+	struct cred *new;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	ret = create_user_ns(new);
+	if (ret < 0) {
+		abort_creds(new);
+		return ERR_PTR(ret);
+	}
+
+	user_ns = get_user_ns(new->user_ns);
+	abort_creds(new);
+	return user_ns;
+}
+
+/*
+ * Create a new rootns.
+ */
+static struct rootns *create_rootns(unsigned int flags)
+{
+	u64 clone_flags = CLONE_NEWNS | CLONE_EMPTY_MNTNS | CLONE_NEWPID |
+			  CLONE_NEWCGROUP | CLONE_NEWUTS | CLONE_NEWIPC |
+			  CLONE_NEWNET |
+			  (IS_ENABLED(CONFIG_TIME_NS) ? CLONE_NEWTIME : 0);
+	struct user_namespace *user_ns;
+	struct nsproxy *ns;
+	struct rootns *c;
+	int ret;
+
+	c = kzalloc_obj(*c, GFP_KERNEL);
+	if (!c)
+		return ERR_PTR(-ENOMEM);
+
+	init_waitqueue_head(&c->waitq);
+	spin_lock_init(&c->lock);
+	refcount_set(&c->usage, 1);
+	c->flags = flags;
+
+	user_ns = create_rootns_user_ns();
+	if (IS_ERR(user_ns)) {
+		ret = PTR_ERR(user_ns);
+		goto err_put;
+	}
+	c->user_ns = user_ns;
+	ns_ref_active_get(user_ns);
+
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto err_put;
+	}
+
+	ns = create_new_namespaces(clone_flags, current->nsproxy, user_ns,
+				   NULL);
+	if (IS_ERR(ns)) {
+		ret = PTR_ERR(ns);
+		goto err_put;
+	}
+
+	timens_activate_nsproxy(ns);
+	c->ns = ns;
+	nsproxy_ns_active_get(ns);
+
+	return c;
+
+err_put:
+	put_rootns(c);
+	return ERR_PTR(ret);
+}
+
+/**
+ * sys_rootns_create - Create a detached root namespace
+ * @flags: Combination of &enum rootns_flags values
+ *
+ * Allocate a detached root namespace owning a fresh user namespace and
+ * dedicated empty mount, PID, UTS, IPC, network, cgroup, and time namespaces.
+ *
+ * Return: Control file descriptor on success, negative error code on failure.
+ */
+SYSCALL_DEFINE1(rootns_create, unsigned int, flags)
+{
+	struct rootns *c;
+	int fd;
+
+	if (flags & ~ROOTNS_ALL_FLAGS)
+		return -EINVAL;
+	if (unlikely(!current->nsproxy))
+		return -EOPNOTSUPP;
+
+	c = create_rootns(flags);
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+
+	fd = anon_inode_getfd("rootns", &rootns_fops, c,
+			      O_RDWR | (flags & ROOTNS_CLOSE_ON_EXEC ? O_CLOEXEC : 0));
+	if (fd < 0)
+		put_rootns(c);
+
+	return fd;
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index c8be0abaa407..4a6c4337cc74 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -398,3 +398,6 @@ COND_SYSCALL(rseq_slice_yield);
 
 COND_SYSCALL(uretprobe);
 COND_SYSCALL(uprobe);
+
+/* kernel/rootns.c */
+COND_SYSCALL(rootns_create);
-- 
2.47.3


