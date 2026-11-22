Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F4A606A335
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J2p8Uw3t
Received: by kanga.kvack.org (Postfix)
	id 713796B05C0; Sun, 22 Nov 2026 14:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAED6B05C1; Sun, 22 Nov 2026 14:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DBD16B05C2; Sun, 22 Nov 2026 14:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16ABA6B05C0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3AEFAC0767
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:50 +0000 (UTC)
X-FDA: 85463762580.04.66A5C65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9B38E180007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2p8Uw3t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376208;
	b=dOyhpmdalorwmGn6GWTr52ubMq2jM4p5e4j/+qfdogdkkPmSSidkLgQEndvU932HPgdHhT
	N45GgO8b3Qg4kgzRWZEmXcpl9X5aMLzyndYFAZ4KI/ihnWzP2GtFa9rG++mm2IqzN6qpcs
	3AzHK535r7cZXqP7f/RiqOAYGuq9NV4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhStIPKcjxn5feiVQQthiDAsaf5QXO2X/we9bRZ2ovc=;
	b=JpCGMPWpqsSSuvsw1tEWhuSShtJuhw4yW/u4lgu/NPfIyIZE15VoNPdx0s5qfyIaXH3HDK
	x6DfinzbC2mlV/5BahgXXNxt2TKwgZffutpf28VBOPMY6gmXaqsArAyILp3mqe29Od7xUN
	0ReAFlAkBvLTjajedW9h9KgsIaozHbk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2p8Uw3t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 3AD5E61E0B;
	Sun, 22 Nov 2026 19:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 161B71F000E1;
	Sun, 22 Nov 2026 19:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376207;
	bh=HhStIPKcjxn5feiVQQthiDAsaf5QXO2X/we9bRZ2ovc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J2p8Uw3tToGSVpLPHI/ucHupSZdB5Yj8etAJN6ZvUe1N9Mfhwn7WkGmPNajjpa+m2
	 XmWcivurVwUJqhvH+l4bD3esY8AfbvSE1E62GLu3HGDZ1I4jLEhFRTN/vBymzmzbVO
	 NwmsSJ+oEMZUwBatE38HrA9XAAxW9Fo88Nv8oIpEvXGN9A1qOeTkInVESes6jCWnc1
	 zGU63Agrse/TuqwIUSvYPWXMrUY/Eq8E5aj9/XIhcJ6h5p+ck0XMAo28A/7h5huKGu
	 MzkQLSyxnzBgAlct+yDcHRcYYJoqBROIMPeSd2Yhjk29Dw/vwX3SCsM95T4U7PwTUp
	 BszEjcK2Fa9rQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 12/26] userland: Add userland_open() system call
Date: Sun, 22 Nov 2026 21:35:25 +0200
Message-ID: <20261122193539.3334213-13-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9B38E180007
X-Stat-Signature: ini675xafebj5gcksfp4icsazzwkpsh9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795376208-299595
X-HE-Meta: U2FsdGVkX18KiY0ncoWG36ic55gSmY/mJQs2pnmvV2wPkAlggEXJBamb24FD4rKRB0pG2j8cZaOm3x+djgiQuLqQpLD9uK5tjFANx23kKCCdVpbLiGsNTZjBixYz4hz28UrwFySJMdGfXLIDdsPYk337FB0KlluKbcA8FLoBL6/gssfVkOMborwV9Qz6Eu0Yr9pBQNB/NPEMgTQom/TrqLt3MpS63MKxUm4sF3PU2hE3oUWSyrSApdu39ggYRlitNYc6wZSVuCzD9iCUpDVywp8WzQOxDUduOhJe/VqQlhB3W2PghbD6sgM5c6HtDJnqObI5pCS6p+8xRLVWMphVJQbh2huRypLOGMkJJCexNQ64vAkZwc7309Bq/VwP2sJTv8KR4924LeK7nrL+1fkdBmuw7SZVODnpM9zwP/hQXTCL40Yh07NDx6n3Emw12jN4oIRDLkTqyqjt+47o6/ZqJrpX+RpPu0XUwtb9LQmJudysyQ4CbKMcO/GArj09nV8Kc8M411nivpJTSaH89MYAtaDEA7dgJtzC8XSQT+WXnig5xCkWdds+PRqZdD/wHJxpYVtG0C30dV7kHFDMUyC/SgvgG2c1/eLLF5dm56EYZTVqNBtUjV1RlHfvevPkQR68BC7YSZr9Vatdefcnf10mlRgcY3A8w3kox49h0SdalTowN0t+ovozVsOPLmaIPh/y4PY+Y8W0+JMisi6qj0ETstRCll0y2RDix5Pgf1qVO16PQtmsVxon3BKwsFUB4y/HRez9q23X8sXStZgz1s11+J4ANB1AjUdhdud5tre/o7cXssHZrYyb61DTb8dVQaJaczjuk3/1bp3zVMoppqSICqdT+LT2SldtZ6rWX6KIG6TH7J4zYgi8Eo4O9kDdjT0jLOg5rEFAc+MzWQN9k22Z8fIOSNF4tn0NHeQ3PtLHaKg+g3hYJgrd4ohr4nmNQ8X8u5AIg0hCBB1GQxrPr9k
 DJKaTnTx
 mduMpuGgyrAKm+MUN5vsRzEl2rTZQL1spvkLFNu2mwbq3iTSP9V5+b5Vv41CNKJkwzK3ulv5fdxpCgWpIayp+3dSu3Adys2qhoBZBckfm2ZT9S/LRls03Z400gAVI0kvSlf1V8Xm8jCAv1RJKj3u21g5GIF9jKIWooY9Xe1fFJNnlJph8lJryet9D4iTBks/yxd/h/TYmi1pNWeu+3gl5Npkf1fOQhLMDI+sxZJfdS2DWbMyCE9E3yaMb/WW1lUjW+yZdadBfdj+WDm38Y2iiiaw1l+55fEzPZ0/dHLUjyxT9dOKv7hyRFIodPPOMTLX5fzQSa7JS973M3ZKkzBlNjqy2unQqxDD/bUQ1+D4gt+Phd80aHpCUmlDQ4rly3uJY3visNsyUqHfF05YSBu01iEB1q7DCs6eiGy+hLOZ7ah7T5QWYhnEN5Jsff0NkzeD7rv3xaQB57VXcgU2zXOgyoeLI9yJN5X4Kgu0UFcdsHIqL6ts=
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

Add the userland_open() system call to allocate a userland owning a
fresh user namespace alongside dedicated empty mount
(CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
namespaces, and return its anonymous-inode file descriptor. Because a
userland encapsulates process lifecycle and mount delegation rather than
an nsfs namespace entity, keep it separate from namespace creation APIs.
Finalize the nsproxy time namespace and pin active references for the
lifetime of the userland.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h |   1 +
 kernel/sys_ni.c          |   3 ++
 kernel/userland.c        | 108 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 72308cc11908..2ea8ebd71743 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1010,6 +1010,7 @@ asmlinkage long sys_lsm_get_self_attr(unsigned int attr, struct lsm_ctx __user *
 asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *ctx,
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
+asmlinkage long sys_userland_open(unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index e3202e7cc2a1..fca9663d09b7 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -399,3 +399,6 @@ COND_SYSCALL(rseq_slice_yield);
 
 COND_SYSCALL(uretprobe);
 COND_SYSCALL(uprobe);
+
+/* kernel/userland.c */
+COND_SYSCALL(userland_open);
diff --git a/kernel/userland.c b/kernel/userland.c
index 44a1976f97c2..472d75423b95 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -135,3 +135,111 @@ void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk)
 	__wake_up(&c->waitq, TASK_NORMAL, 0, poll_to_key(EPOLLHUP));
 	userland_put(c);
 }
+
+static struct user_namespace *userland_create_user_ns(void)
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
+static struct userland *userland_create(unsigned int flags)
+{
+	u64 clone_flags = CLONE_NEWNS | CLONE_EMPTY_MNTNS | CLONE_NEWPID |
+			  CLONE_NEWCGROUP | CLONE_NEWUTS | CLONE_NEWIPC |
+			  CLONE_NEWNET |
+			  (IS_ENABLED(CONFIG_TIME_NS) ? CLONE_NEWTIME : 0);
+	struct user_namespace *user_ns;
+	struct nsproxy *ns;
+	struct userland *c;
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
+	user_ns = userland_create_user_ns();
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
+	ns = create_new_namespaces(clone_flags, current, user_ns, NULL);
+	if (IS_ERR(ns)) {
+		ret = PTR_ERR(ns);
+		goto err_put;
+	}
+
+	if (ns->time_ns != ns->time_ns_for_children) {
+		get_time_ns(ns->time_ns_for_children);
+		put_time_ns(ns->time_ns);
+		ns->time_ns = ns->time_ns_for_children;
+	}
+	c->ns = ns;
+	nsproxy_ns_active_get(ns);
+
+	return c;
+
+err_put:
+	userland_put(c);
+	return ERR_PTR(ret);
+}
+
+/**
+ * sys_userland_open - Open a new userland
+ * @flags: Combination of &enum userland_flags values
+ *
+ * Allocate a userland owning a fresh child user namespace (with the caller's
+ * effective UID and GID as owner and initially empty ID mappings) and dedicated
+ * empty mount, PID, UTS, IPC, network, cgroup, and time namespaces. Control
+ * operations authorize against capabilities in the userland's owning user
+ * namespace.
+ *
+ * Return: Userland file descriptor on success, negative error code on failure.
+ */
+SYSCALL_DEFINE1(userland_open, unsigned int, flags)
+{
+	struct userland *c;
+	int fd;
+
+	if (flags & ~USERLAND_ALL_FLAGS)
+		return -EINVAL;
+
+	c = userland_create(flags);
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+
+	fd = anon_inode_getfd("userland", &userland_fops, c,
+			      O_RDWR |
+			      (flags & USERLAND_CLOSE_ON_EXEC ? O_CLOEXEC : 0));
+	if (fd < 0)
+		userland_put(c);
+
+	return fd;
+}
-- 
2.47.3


