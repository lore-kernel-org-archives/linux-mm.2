Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236A2606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CIXU7+VK
Received: by kanga.kvack.org (Postfix)
	id E17EF6B05C2; Sat, 21 Nov 2026 20:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF686B05C3; Sat, 21 Nov 2026 20:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6FB6B05C4; Sat, 21 Nov 2026 20:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9CA6B05C2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3790CA8281
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:08 +0000 (UTC)
X-FDA: 85460996376.04.18228DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A376A20008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIXU7+VK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310346;
	b=ss7uJ3/2VoqKrPp/gqNQSqLsqRWpdkgPRivNcXk6tmkmA8hK+yFB3Wkb1jUEuLetEwZpeQ
	uXWJtrNbMqX9dOq+x+5T8PlwUi2KwE8iaVTMvpO9M/UmuaOb0kO9KQLARzVEp3TE/9OjVp
	fF35mcs2NwQJ41sEBagB4a0fSIjirQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV/3lRQtOQxqgRWopxhp5rjcN498ncYUt5HOtng0GIw=;
	b=T8+SQFMIoTPrFyrmxn43/MeHOETz3g2QpLN5dZLFOkghreqZaopbi8Flj3cWukxnR3jk9e
	N0z6dDGobHlze73nxbPoBzY42prFAnpUFmhFG3HkuGysm0622ga83Z8IbVRRuFKbwKZXbI
	eg6mIVOeYkUeXOXgKkrDdQMY0oAfXW8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIXU7+VK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 1E3B36124F;
	Sun, 22 Nov 2026 01:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 24FF01F000D1;
	Sun, 22 Nov 2026 01:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310345;
	bh=yV/3lRQtOQxqgRWopxhp5rjcN498ncYUt5HOtng0GIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIXU7+VKFKJaP3nZlOBxh6leoLCIsRnbhWL84dTMd9gmRsmMZLObOTmFvSNXR1N+j
	 mPfbPHZLK8jrhmfKQGmfSupHrgitIRSqvOuyn2KDx5r69Osi1AVy2z1rprDC4Ywt1b
	 hw/tZ3RtNtRtosxt6m3ylXZZGNzPLOxI83gaVyOyCc8yABdPEFPo9udr8erHP1wT6f
	 BH8lLBW+gA+v/mjxA70JBjv3OnD7ZUcAuUqGgHPrBab+WFCkhbR28qRf9HZyMI4KnD
	 KH0aHNS5Ll/iIssvHEynMIopUZ2n5epcJSE3sMX1CYnLP7qU5d7ZGG3bVo/rcFsobK
	 W553ZabSFTrAg==
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
Subject: [RFC PATCH v6 12/26] userland: Add userland_open() system call
Date: Sun, 22 Nov 2026 03:17:55 +0200
Message-ID: <20261122011809.2667684-13-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s47wbqzkdcf1fkq8xmedxn4urou5sthm
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A376A20008
X-HE-Tag: 1795310346-571222
X-HE-Meta: U2FsdGVkX18oik93A6hPSEgracdCm0z7fcg0KgtsVI1EVxhUF37alA86NrJ1GyucAown5E6rlJqSPvfKBMIaC7hTfV/jZjsexrSzjtaMqsDgFR1Tm91drB7jlS/QFueUOWI/YEh1itmAQWlxkd+DoWt6qFwajAulTcas1FxdH5ixH1VHMPMyHEnDbXH3bb+b/WpjAfXG8s9NFRTWHilFWGUmOooEkyxM950DzKkTeR4k4RROCxtcQKBiYkvCzfGSpASWqP2DLNpaj8YoT7yfDwdxKlAdI55LKu89ZuFbA+8gEI/XWasoc3l8ytKMbN4dycv105MEFaFYp/cXAnMhvTB4sK5IkLQw4d/f8JpPnJQZYs6lYJbpIOS7Z/7cnxPezBvv+Y37MRc6enDamIhKp0lF94sHi4ThiOalodDE2pERzFNjeNGvL+S/VXOu4lBA8fKb01sQTqyk4EWZJKysJx+1xjrwxS2JmxfafS83cHnd8veKvX3DDq5k9gvMjq2QYqihPy8vAzkSYTXLZZiu2V1U/E4s2EMJWs1LNs2rM3BkNyAczmEZw/XlHTczFw07+ftbjg8lXOmP8+SGQ4QCC3riIt5DDYyYq0Xeuzp9vX4Z4QZH1j2VpJ03poCQLZivA68Po3qo81Zmcx1q1sJZ+f/pXiiZp7J8DnALG3eX0RQXHjcfCy1kHK/Tk98kmDD53BYIDg7EjWBe60gn89i54hWLXSNx9gdaqcodxHtWIa+iTlUPyecsSIJh7Xs8wcG1285tH9Rs/TPXovmiSDE2JBoE/YDYTTWuYNyXDDgRwzZxHB1mSvBc0xdghqjsUlWZWrmh8fgyOsQyIGyE4gLodA0xtUbukKBthLwVovgirgB2HVmXNV8qgVH024Ehy6ukPsRznw00s7rdyImHtTeNnDBpJW7C/GlGCA6iqc1DYvRgx/Xh7VSAq8w/roypTA8z6CEmY7TdA66Wn4zEW1I
 TJ8nThhT
 KA2Z5hHL91HzS0CHp48Sbf8csT1G2HmgL/4NhuTSOUajwT3GdtaDy/0AuhzRbVzeRRHTBbl9Iw4fNnvOSr1hIMhPwFvOhum0Utdz1XBdMfcaC83LRon5eEPgxQb+NhdZ+yxJBJfhRudunz/iywIANJBtDGw+FV9hrSYDKnAMISXTRTB9ZzNNqu0/vplkk5vuKj6yihecb3uRPGMloTE6wiLCJxZU3uoOzFO9I5j4La8AK76B8xnSWP/S0LiA6plw4kr2QOXBwjs63izEgfqYlL+wlFDEekQrwdBwZ85fuauUxRhrKHIZ+I0Ga+H/iUKuh+urXxF5Ec3sk8aJa6o21ExoVI7WWnTnrmzL6P7CdEPsbOSW077SIiAJcEEbTS71vdg9UiRdwQQnVXrvsllwiG43PBLgqU6GHtU40OmvtfHhFaAusJW2fWHHnNvrs88RBVVlRszaV+jbDFmrzB0OyyhUaG9vtZv5nnfIU3+JLBCjdN2Y=
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
 kernel/userland.c        | 107 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)

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
index e117b00cb8a2..d99b5d99fcc4 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -128,3 +128,110 @@ void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk)
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
+ * Allocate a userland owning a fresh user namespace and dedicated
+ * empty mount, PID, UTS, IPC, network, cgroup, and time namespaces.
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
+	if (unlikely(!current->nsproxy))
+		return -EOPNOTSUPP;
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


