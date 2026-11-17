Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2152606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXVxRvh5
Received: by kanga.kvack.org (Postfix)
	id 60B726B05BC; Tue, 17 Nov 2026 00:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBFC6B05BD; Tue, 17 Nov 2026 00:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D5F6B05BE; Tue, 17 Nov 2026 00:09:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9F26B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D866120343
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:07 +0000 (UTC)
X-FDA: 85443431934.02.82AA6B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E39A2C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXVxRvh5;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892146;
	b=Ouqh34VMGMO1B1Z4xijWorTZoLMm7Zr93a8jQgDeVSg/Jjim+0r59p8HQegALPrWNadeKf
	nGTK+54PrpoxXEpIXKPKn2Jgeq4zrHOJZD9vvQ6tQyg3ZapwjDNnAnaX9Q3g9pxT8lGc5B
	7YqxTUVJAw0VQEingiUhNIJ/CyBDLNk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXVxRvh5;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CS+W/Sr3iq8tSqh2G3aDEjOmCeOgF+I/s/FCQs9Mcyo=;
	b=YFT/RzR4l2SEowPdTRPrxgrsOz//Ei5pmTqExl0yi8AxjIskjZWuQsMX2DpPSaaYGCEW5e
	AiuAjPDNEH4F8hY71wDey5L/tw8wtFGC5Nh5U7rXCbTJ+MirZdayIf8/bIttSyocjUfmwY
	sVCgyRCUoSx+TmvHGZ0IZ2S4ciEHI8s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 6019B61D0D;
	Tue, 17 Nov 2026 05:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D36D1F000C8;
	Tue, 17 Nov 2026 05:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892145;
	bh=CS+W/Sr3iq8tSqh2G3aDEjOmCeOgF+I/s/FCQs9Mcyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXVxRvh5/fiQop5nr2M8zWvioC2N9tW9u+UlSmlPu6c5FtuV19rqyyUABQtbAy9rd
	 JxPzVmZz1Nhxzw6AE/6Yx+i+c4hVipACpTZSGz9rr9vwXaPz242LAZ8RHQU4Xtv7Fb
	 n0UoBPbdv4yQRjAoum2DKxTzpnYn5AhB4NP7UkG41uyFtK48cxIAcj6LG2W4MIrHMf
	 og1HbN12g+TnlNsRUIi5aNGEHxECitxOMbV7L0yubwBNNBu6RFhmQnKzWuTGI4ikGY
	 Rpf3jdre8anNqWDp5hafEPQdb2oA0SzBDF9d7Jg+TFhywxgT9q5CcVx8bcHAQNFHSX
	 d/rSDkUFNyBOA==
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
Subject: [RFC PATCH 04/13] rootns: Add rootns_create() system call
Date: Tue, 17 Nov 2026 07:08:32 +0200
Message-ID: <20261117050841.3289652-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E39A2C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8jw3j5t6ahwxhg7jtrcpk6njtunno7t1
X-Rspam-User: 
X-HE-Tag: 1794892145-49896
X-HE-Meta: U2FsdGVkX18UWJVwOpGUN3ywGq57d/v7UuUULgn19AXIYgioYJapHk9ZwXE1pcL7BxBDNIkEEvBkEV3XGBxUglOZGEJ4WkaSpX8Qh5ZdpbvTx9h8bHdA45zQViTUqUkY4HJzyCXLZw4xlvOF6l+19jtCl2Kzd6ksO+/5XdIDujuZ6hCE/hUYrwoXJo6t5B2imorZlXncIXK/1VJ00o3Po7G64uy9mDq6HvegIzZrHziIjNBW+Ns8zDL+s6kF+rC5r0iXsDXUekIXCKL01aQcxLIGU+dIGVE2pOpT/9ONdDleN5xxuwuMHRvmVhBi+6pq+kJKSGLL06NOWbgRQKB+//yoBU72ebbnMKvHtsg8wEUBrM1lgirD9oRrtuSMxkdUkn2IZeOmmnMzfs0Dy1O7KkkkbBUKbn95TCBZT/zXHHtFGebiAubcSoROqtvAUhHiwAI6LklUfxdq0re0cStkvVtMswlMECrffTU90tMenCRR+PwrM3flXRN/y3/FD5RVE1j1LUEFwAkttY7k9uaxHEBDIRyRq8GBXe3/aeNKaTdQoMqXrzmzbryInSghZobXGsH6iaNr/Z4X3d8xJJbbTD/JWUTBbhBpECR5wF+6qUv1UnWE5reWYjKBQSIUTAieqEMxjI3usXnDZu9dnw5/ZbKRCNrjIBPi3GEGqODvA6NU0F2VcJghLqB0XX0orXRxunqi3pp3afIZF7WSb0/n6uLkiIbEPGTwHNKq18pOx4RgNhAJQdIrixGn7gl6WQ8iY4qXMh6eOwORVmfX6KhILWT/7ejcdhJL8FKo9NY6dwAnskFtWK2Lzy4guenlOLKduzLazW29LIKKxrqKZCdCufGSsNqs/aKDIO5ZwwtmBZPU0rjol+VshrmtygGVDDsvHhwwSiXY3c9uP51QLBjG9Lx7ndOxUIKOqkIvDSheVa+r3kh+iSwdDixXdfOfW6DGPrZ6KOvX9CqFW8Nf/ps
 QUC9a5Jn
 RCBDv4f7GKSVAWirJuKEq6fk80r2pylJpoJFHG3mTnccwZuS9N+xqziMNQpwuHXADRiOJtVwlL1Pl4mdBa05lZa4PkZd9ayJGZpGL+SxA2YDlpl7jTBZGsGC109kvbISGUma55mgpiku5cMTqDDOBW6WYgxEmW1j7cN5yAs6wA4rlgaXXS3CoewORGM5rL/s0grnAAKb2JBMFX5b28TbWOHujKDIfJ4JiTsrTZq5rwN3CEDsdCorsME9JZhfi1iIRvqMhZve9RRGXOZU=
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
instance with dedicated empty mount (CLONE_EMPTY_MNTNS) and PID
namespaces and return its control file descriptor. Create fresh optional
namespaces selected in flags while inheriting unset ones from the
caller, and pin active references for the lifetime of the rootns. Leave
the newly created rootns in ROOTNS_EMPTY until userspace installs a root
mount.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h |   1 +
 kernel/rootns.c          | 140 +++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |   3 +
 3 files changed, 144 insertions(+)

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
diff --git a/kernel/rootns.c b/kernel/rootns.c
index e3b203322ae2..904d75ce9d90 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -145,3 +145,143 @@ void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
 	wake_up_poll(&c->waitq, EPOLLHUP);
 	put_rootns(c);
 }
+
+/*
+ * Create credentials for a rootns. Drop keyrings from the new credential to
+ * avoid unnecessary pinning.
+ */
+static const struct cred *create_rootns_creds(unsigned int flags)
+{
+	struct cred *new;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+#ifdef CONFIG_KEYS
+	key_put(new->thread_keyring);
+	new->thread_keyring = NULL;
+	key_put(new->process_keyring);
+	new->process_keyring = NULL;
+	key_put(new->session_keyring);
+	new->session_keyring = NULL;
+	key_put(new->request_key_auth);
+	new->request_key_auth = NULL;
+#endif
+	if (!(flags & ROOTNS_USER))
+		return new;
+
+	ret = create_user_ns(new);
+	if (ret < 0)
+		goto err;
+	new->euid = new->user_ns->owner;
+	new->egid = new->user_ns->group;
+
+	new->uid = new->euid;
+	new->suid = new->euid;
+	new->fsuid = new->euid;
+	new->gid = new->egid;
+	new->sgid = new->egid;
+	new->fsgid = new->egid;
+	ret = set_cred_ucounts(new);
+	if (ret < 0)
+		goto err;
+	return new;
+
+err:
+	abort_creds(new);
+	return ERR_PTR(ret);
+}
+
+/*
+ * Create a new rootns.
+ */
+static struct rootns *create_rootns(unsigned int flags)
+{
+	u64 clone_flags = CLONE_NEWNS | CLONE_EMPTY_MNTNS | CLONE_NEWPID;
+	const struct cred *cred;
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
+	cred = create_rootns_creds(flags);
+	if (IS_ERR(cred)) {
+		ret = PTR_ERR(cred);
+		goto err_put;
+	}
+	c->cred = cred;
+	ns_ref_active_get(cred->user_ns);
+
+	if (!ns_capable(cred->user_ns, CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto err_put;
+	}
+
+	if (flags & ROOTNS_CGROUP)
+		clone_flags |= CLONE_NEWCGROUP;
+	if (flags & ROOTNS_UTS)
+		clone_flags |= CLONE_NEWUTS;
+	if (flags & ROOTNS_IPC)
+		clone_flags |= CLONE_NEWIPC;
+	if (flags & ROOTNS_NET)
+		clone_flags |= CLONE_NEWNET;
+
+	ns = create_new_namespaces(clone_flags, current->nsproxy, cred->user_ns,
+				   NULL);
+	if (IS_ERR(ns)) {
+		ret = PTR_ERR(ns);
+		goto err_put;
+	}
+
+	c->ns = ns;
+	ns->rootns = c;
+	ns->pid_ns_for_children->rootns = c;
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
+ * Allocate a detached root namespace with dedicated empty mount and PID
+ * namespaces plus any optional namespaces requested in @flags.
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


