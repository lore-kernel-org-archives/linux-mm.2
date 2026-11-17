Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71E3606A8B7
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UTjzZX97
Received: by kanga.kvack.org (Postfix)
	id 7D9DE6B05BC; Tue, 17 Nov 2026 18:14:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1EC6B05BD; Tue, 17 Nov 2026 18:14:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8086B05BE; Tue, 17 Nov 2026 18:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C77E6B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2FC880631
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:28 +0000 (UTC)
X-FDA: 85446167016.27.D8133EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3470540005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTjzZX97;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957267;
	b=6iOlohBVU86tJW7kU58ybqxY3iug/siVJUQdCvcqmunK4+lp6kha7QcnhoPZJhCn6g2wKn
	IWyDL7zLWT5cebM2RT7iR26R6LDyVq9tyMfMHZNQxas5BHuqedFp5VLeUFrn/Gs2cxw/ZJ
	M1zHg2LVI/Jrsfc5HCZdGQ64ia84ytY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLkPPSN4G9oNOjjtEMLGuFRN2z4NxY+gcMx+AxGI1Nc=;
	b=1V22/js7XPUKV6fGN/r768eUECLCV61jSbj47RG8I7d6SBTaoiPGeC4Kdt+S8mapNf+Qfy
	rg+t808eaan45xOuxwBJ8WW3HVLSQzlGLO66WGRnktQlV9LFVxZW8D37wpsodEipServVH
	NXLo6l/RGhlYbTE4Yl2ppJx90l8k8zU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTjzZX97;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 9099461D7A;
	Tue, 17 Nov 2026 23:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D9861F000CA;
	Tue, 17 Nov 2026 23:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957266;
	bh=GLkPPSN4G9oNOjjtEMLGuFRN2z4NxY+gcMx+AxGI1Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTjzZX978haoKvloakiOf/KX2pOVH23VzeaEl7eRyIb4kreNndJnZF/cVfok/wI0g
	 QnGijXlTQt3ElCMBf5TgDkgwphy02SDD07pnqFHHcot3ICRwxnin2U/7k1g3Mv8KZm
	 HIrMk+8l5mG0ZPuI7Zs9qn+U9ThXL0HM+86nOguUbfOTfLUuzxBa8M/4td5H7MgVlO
	 miR6YnE9iX3OrntxT9uhi36Zis6mXm0DM7GZwKVOVzmn+HqjnKqvagJ94rX4FKG+Dt
	 A+4ggjYR+UYWjHkAVzuxNS7rPqnAuV1wSrH/ZwytoxpRMLITOLoD6mA5qPMpFxN115
	 aW68+xI5+pTiQ==
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
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 04/13] rootns: Add rootns_create() system call
Date: Wed, 18 Nov 2026 01:13:43 +0200
Message-ID: <20261117231352.3816603-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3470540005
X-Rspam-User:
X-Stat-Signature: bmibbtuq6z9xw6tntq7ac6rtpeghx4g7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794957267-11956
X-HE-Meta: U2FsdGVkX19dCaUVz1sJi0G9snhF3g+aC92d32SvV27h/kdx6/c87Gb3ySjO5c4YJYsN69ASUT2uCWaelTM394vC8zleZHYEZLSVMrrLhwOsNS3wrs4+XUQd5mrMDaCznBto4P04yqI+NbP7LsYWVyl901y9hNvs7+mlRJcoBxuWKVbMrZ5Shez3Vi9biKut+TYZOk7PY1GCkAglxEX5sQV0WhOJGqxbcePLO8XR59y6AYHhhpALE/MP1swHlloRe3R0GvGpP/SD92zIG3EhcvuZTSxbYpIK9I6ykteGqeC6Kk7gfJc2zIHVGKM3FN7G+swCEfjQhZ91UaOcOYD2bJ5KMBcFcONv80feNZHfu027LlzRvrUU4J0HPm2i0+P2+CCfg5WiGHATLYF+w4nDcbgZQRVMZy9bc/Bvu2MU1RjFOAQaqSzLL0k9rC6Bckp485bvKBFIy0XVlBN+9qcjmSwZ6Ti7fTmiONUJO4yxSldlZs80TVB8YZ9D/r26j9ZAqZGev5uAhBKTJ5Zi72NVe4efAQdUDx99LKTs/0v73ZSZsR7ENwD5epfZlhhCE9sfcXec+jeovX6nXGWXzQ77uY+CKvTB5ZmZKU9GTfutTyWuxw23WiwORNaQBhcf8EInrP6SMmTZYSU6D13Xwy2WmsOtXgxFq0SLppiqgHzV6qKeiEoSP8zR7F9tE3Fdy2hy5AmYogS5rPZ4hPxP1j1B3lz+Qt01QrJ1Yza8RpE53ByE/TltU4RLSzcL+oj41VLxY05M70i+OIL4u0tpa3zoxNy+5DRxE4V3ToCnOcPEnnYBv58VdY4WwsdaxS6KpgeRgPBnYXPrOfpljGn/ivFX4Gw73GPBZoVCznVp8V0LzsfyGznqvvEFipJqM3LtijjmHjD+9xjORyCe7C1KEwLZ3Af9Uwm7M1ZbFzSvXcboEOwqeUe7gqQUQHTkhawnDyQoUZyjiI9DSNkvXXukCa7
 uA4oj6QT
 6wPpPn/qrSTPWAiZKXJOxt2c+1YBy+7ecXIRg4T8ZjyAnPwlwRp3dAr9rLssug8YeD2nUZaVuEn6ETRtv9NpqPGNUsNFWe+wH6cMnGITMCXUXg6MkIF0S2GMyQhDZsOi/65RSB6C6cem1yNTB7JeCz3hYhCA0huAg0jNwQy/OrBgihHGskEUJTwY37+D5NNdZI4LvkJfInmg1uTVfDTlD7HPTZeCRLlU60e2+P/cfev70hKkZ3a04OlJAbMCIT4dG8W8uE9MxQsSTlZD6inBZb0XMp+XrtVvMbL64+5Z5bQ+Gl6wZrpeFZmllzD5eMi1qlhUr03d1uaXOSY9iYFnZZEHECZUNSTPbEtOj5Mdhw5xijAr6DyCM6c+1hQ==
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
 kernel/rootns.c          | 139 +++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |   3 +
 3 files changed, 143 insertions(+)

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
index e3b203322ae2..caa810b65d0d 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -145,3 +145,142 @@ void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
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


