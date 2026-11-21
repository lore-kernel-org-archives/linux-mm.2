Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDC160A262C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l39vwha0
Received: by kanga.kvack.org (Postfix)
	id AC7486B05C5; Fri, 20 Nov 2026 19:09:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9256B05C6; Fri, 20 Nov 2026 19:09:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852C96B05C7; Fri, 20 Nov 2026 19:09:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D67A6B05C5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70E3B1A0262
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:53 +0000 (UTC)
X-FDA: 85457193066.21.092AE71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E223880005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l39vwha0;
	spf=pass (imf30.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219792;
	b=vAqJBzX3T2nI7TG/nweWM2mNTpb3wngaQXwwl8FLWTfHWG4nxT1axqJRybjaul7XD++XsE
	oP+WW8Qext7avtdZG6WCeO2rRxr4l8pLVrcsO66UiPLBdJq6U1BWjryaI5GiwZvuKYfQ2k
	hp6IT/n2QSRgWqX/t5tAqQY39R22tD8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CbJrr0fmJ/8/RjFMDqcVzL22igR5/O53T1kshtB1fI=;
	b=Ja8eKD9RuZdoVf6VatqY+yBTOrWzIM/crO6SiE341Ab9i0ZoewRomH5JkF+mEgUzYZGd3h
	cfPptiy6ikiZ2IXHZkt9dlB0owVGQiXxAs/62Jj9XiWAEnBvh3GqRSGbp29Fz9X4nwaAWm
	AxjM1NS+Vx1ANOmGSZCyr91jEfpfCb4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l39vwha0;
	spf=pass (imf30.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 7EB366220B;
	Sat, 21 Nov 2026 00:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9ECE31F000C0;
	Sat, 21 Nov 2026 00:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219791;
	bh=5CbJrr0fmJ/8/RjFMDqcVzL22igR5/O53T1kshtB1fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l39vwha0Zy301QmNnNGYORrwB0yc3QYfTpAkLcafc2HA1qNszWZtidcT6rdP0VP2i
	 bGEsvcTeq4WIzErXvPfrAvqG2H9PcQhoEcwK6pqrmAzfktH+KF/kmyf5lb5Fjvrc+Z
	 /5vGmA2siKwD3UKAs+JcXN4xzsLZmiAa2CHIG/X4IqqdA5qnAyrcrlhhADFwhBlmPT
	 2sirMV+EUB02gSCmMbZFHhcyPS+vgWUwuChyLYtJfVPfv9HsdEJmXepRHTFq5mmGe1
	 JIXJI1i0hrFp5gZjWNu86UaQ52x6S4q8DBGZ47AFWSw9RHO6Pw6jnLoZSQ2h7dFwOk
	 gZ8s/j19XfiMA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 13/25] rootns: Add rootns() system call
Date: Sat, 21 Nov 2026 02:08:32 +0200
Message-ID: <20261121000844.1863324-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E223880005
X-Stat-Signature: c4su4z6cusy6oehujfshzouz5m1fifwc
X-Rspam-User:
X-HE-Tag: 1795219791-235860
X-HE-Meta: U2FsdGVkX196Y3sOXwPysyx457szvQ507fI1Tex2LKuKfs2Xs9heyy8XZ9nR6AqYrz9Nbde0K72JmWsgOO6bHDNwt5XC1HE5XD0J485b6zI2NhIoGTXlOsE8bruxpK8lofOy5MJuv+McgdhUosz4Zjm5GCvVYwns8YUEBHPsFTjzE95FItvNhlpYUv1LgF/gsOS+pqLXPo4+a4DnBUTASK7gITHPXfqM4FiPm9WgUYQqxXTAotgt3wz2GWIvEsS30tbrT5v6xRHKTkwNZFM6mD7BYdL682oL4ndMFHyp6HxqQXIxFkXoU88U3txYG8EHKkIwluzNzVuk60/Ma766kW3Rlrk9WEIBN5R7/gwJC84NWqRylr4uJeU0C91HnimxuSImw3FdxezNndiWjmR5fBSk+6PmoSw+hpJ3OY5Y6LWr+d4d63S9l++IbspdQOFsjU6WJLvEPvDRU6EDa8g0KLQP1z3JVSc9K6hLLhGmCQSmclzn3esKWtyk/LGJnQeqE4fSlDGebK4rTEqnfBZ0WW7SHu4m/PFvj0T9MhBavZL0W+F5Lw810X+qJ3WVqeF5dv+QBuka9cM1WImmdFIGicEuhu9kBAoubJOhbn50GuGulTyE7FIG6ZvCUz6F9OaSNdzYIHbL3chLDNVATeKmRClwHdQNn/0ZHELg3yUxJl9yjjPAlX263CtJpjxsg8pYF3/psl63y//WfKsw0wXGTPuW0qj6v5vsc2/GPP+SGwm59R3MsmsjdjgWdXSGu0807dxNDi1al6nuHPJGBfgEdW2QkXYy1ntH90VwmhQP6lIUCSq20Nk2+QjqqdHzc8AlCxIIzRbiXJHpWzN/K4nyVnDAOCF/11MZ3cxdxTp0knzxe0U1yLb+QK97iUTt9rEulsBOe/ZgGLTIQiPYPfdpujIdAcBiFdbmdE2rwSQApG9utIZKRZbQM9NI6VXjuT6evsr1pHylA/HIxfexcfq
 j9FiI4NL
 A2Fc5m0EUulepk4sH6ELyv/rEHMfAPMk6wkqD0Tyww6HCUi1KOv3jCreD5SFg15HyJh2GQgNxEuf7tFmD3EEx3rFAwPK63xLf0yJdGXIERVmWTDzZ7rLp1SYZCUk3VjzDtafuk/3guWs+et29HhXk/sGyf6Pm2ZUlMDxAq5nFyQUBwhZnGqhwONE5o7KXt3qpxrTXU1RZ6RF3hvUdHGZQBu8terWEX7cV0OFDwU+4uL4zotEHj87bCvkBN2MDKNY9EEVj8J6k2VJb2zSy4guO6DdQ5Z/ze3VlUt3wv03T+s6DA4ErnE0ug9EqQi4ZBTddBRL6zcdykfSuCSecKyFw1S/9YB9iQdUI1Tr8D1JnBL2D4HbZew8ibdKz/G/mk4rU5zmzn4GP8b0Gdl/E4Gv+tOb+dIRqWTohGVdT3BWUqVTVez28BiMcRnqoWBwnmVG2g3GG
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

Add the rootns() system call to allocate a detached rootns instance
owning a fresh user namespace alongside dedicated empty mount
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
index 72308cc11908..8284bce1c31e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1010,6 +1010,7 @@ asmlinkage long sys_lsm_get_self_attr(unsigned int attr, struct lsm_ctx __user *
 asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *ctx,
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
+asmlinkage long sys_rootns(unsigned int flags);
 
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
index fd8ce59de61a..5d59fc9a591d 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -222,3 +222,109 @@ void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
 	__wake_up(&c->waitq, TASK_NORMAL, 0, poll_to_key(EPOLLHUP));
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
+ * sys_rootns - Create a detached root namespace
+ * @flags: Combination of &enum rootns_flags values
+ *
+ * Allocate a detached root namespace owning a fresh user namespace and
+ * dedicated empty mount, PID, UTS, IPC, network, cgroup, and time namespaces.
+ *
+ * Return: Control file descriptor on success, negative error code on failure.
+ */
+SYSCALL_DEFINE1(rootns, unsigned int, flags)
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
index e3202e7cc2a1..f095401bed24 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -399,3 +399,6 @@ COND_SYSCALL(rseq_slice_yield);
 
 COND_SYSCALL(uretprobe);
 COND_SYSCALL(uprobe);
+
+/* kernel/rootns.c */
+COND_SYSCALL(rootns);
-- 
2.47.3


