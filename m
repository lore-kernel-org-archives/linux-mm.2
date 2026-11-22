Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3C760A2608
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CG6CfgoO
Received: by kanga.kvack.org (Postfix)
	id 1BCA56B05BE; Sun, 22 Nov 2026 14:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193CE6B05BF; Sun, 22 Nov 2026 14:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9B16B05C0; Sun, 22 Nov 2026 14:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C85606B05BE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADA38140730
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:41 +0000 (UTC)
X-FDA: 85463762202.30.B5E5B1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 087FF40008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CG6CfgoO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376200;
	b=8IvzRkJbAz2uTHeAAV3gkKpREwahzNjtwLHRu1cLTyXt6ASePOTIKwUop0fpbQDNLLEmh3
	7RD89TLezllaTJBqZK7nLKDVuw5xSVlVli+Ddql0j7RRhVa37mqI2b5H18KkaGF6lxOPJj
	nweSNp7jO0BnAYk566b00OY5j0FKLg0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbRTDchIsz6xcCBmI8LhY6NC9NG/SzViBPWKNz/ygpo=;
	b=wvmaAJ5Cl3mGxvVPj7O/f9P8psvkYi8+tHMT/gSjzdwj9TQFye6wrRE3lZExUhzpnoWW34
	1qwd2UFoJG9n+2bKf3/YGUuIHZwyWVCtjSI8sKfJFtRQbK21JYlkt7ueP8Q7A48fARIEiw
	Nb7uNTG6KKSOKQ1VVekXw4F6cGQ/RSM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CG6CfgoO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 5A1544559F;
	Sun, 22 Nov 2026 19:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 790321F00A01;
	Sun, 22 Nov 2026 19:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376199;
	bh=YbRTDchIsz6xcCBmI8LhY6NC9NG/SzViBPWKNz/ygpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CG6CfgoOYB1ykMnFVIQA0eyNbZL7c4vTkkFjT9pExp0M3QXg7D4zdq3w1sclLPgVq
	 v6GwXd0nxYHutNTZB6HGmpV/+OX73AimUAxExG7MjtuOCGoUXB9N3zjmzMRwpdFDdx
	 dCdEROaBeimYhLAOA1YltC41CjAlimHm/dakNnZRdrEWBPFmtPW4AkIF+zJfIjIHGG
	 EGs++cNh42bvFH9IC59uuOPQ33drP6C5iAv5LMllE97DfQwhpVMbtaPngkZXJoHrkz
	 TdX6U7kwnoRm40yTMUhPbV1gJs6Kq3aLa/e1x5MQ8CAA+fj6p3lm5F9OnZf3ZRlYGE
	 l0cyVa5uM5glg==
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
Subject: [RFC PATCH v7 10/26] userland: Add core infrastructure
Date: Sun, 22 Nov 2026 21:35:23 +0200
Message-ID: <20261122193539.3334213-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 087FF40008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: besikh3nfxxci8gdzxis3cchpnb57otw
X-Rspam-User:
X-HE-Tag: 1795376199-348829
X-HE-Meta: U2FsdGVkX18Y1rn04RZRNfkme07UXloRDzRdPcllj201vI1+NPuuQ9yJ/tZn7ij3onnmcbisJm6Sfh+LUquqSGhchu4jMacXsNnDi1fZphP/5WUzKnTLshZpAaufEEOcHQ0QYi5RbrSP9k573MiYiFRlHj7L2ym/kqWMwOvTiTna050s0MoRcs48Z+m0I6oFnI2N+cl64ZPw+yjC1nVe5VY1hJmsMdcnIAN7AQ1KAt2BD75RnpnqdI28NOGQyuJZEG1m/4dBmy+f2wykrtRLNsWcAJTNwugzfyZWGgg9QkoGq7ea6Q+dQetS+YJgXwkL2htMbDltTm2kJ6T2WFd1G91m52Uq3ijvPNwf9ZsXhHMVowKfUqTO8S/htiPfOrMErDbQEjdSQHI7W6TCytbdxFE10RN5/cinhu4wKrqfInhakQPrWAxJCWd3cONaeJ/Jki7tyTv3EnXRzQ+PQlzpXoDfs6WHjBBs/kecnpQIXg4Nwm8S/yn5C6G+S7pCYlbPWjEmn6hNqFXBV/rmHjNsjIAMnOClN9h/GgTn6ocMtTL7WUA3/LlylTqX9kj0youXy4jeMVJ44ya74IIQ5EAMa+iTecMvUr78uXUua4S9r9upooMSSIiJZaOQBc31yMjVbmJFfBzyujpiy1qGuF6KaYAKVzMz6vm6wYCLLO0vekbYTNbaUBwf7ZXbfYLfCM5zMfkfhuOawu7i2VjhAbqtKad8kOraLshU6t6CbdSMF8e9RDjCASRXGpNE+FG2xvgFUxQ2kTjaVQjUtTivts9cx5DNaSVMnr008M6UiphAiYRqloRWZbFF/b7zRohnTRB+ecx0TVSirI8qtxjYa8Xi07I3zDhhIKvQfQsD37xhlu/P6CjyHJXklIsMTfl3RvUxqQq+ZuhnW+wyNTrT/sZ+PelvHAmcZcdCTVdxLfN2AzIy1Q0gE4q70JrpMZwf2peynGn3bbDoalGIsOEmgOn
 Mw9WCxfe
 5HRaSLzlqWfwYAzr46zsvrTGldAF8VY9b8pnaQas3ZXfNoiPhGTu2qCN2HoOCY5lx4hED+yYVO1E+MaTUAMOgdYeOBrO4gxkse2C0FASVvAzzmg2Yo9woNCkk2kkV6jIpq21UvJmJb4a8hi/1sVPkBfCdyappowRHE3dB1+up3B6MAaJnvVKNbnZbR7YsN9HqEK1qqLokuud3dAQHIM2u6XyRtgxdGjzbQCC9IT4eAVVLVqx5A96i6ELdCKcDYqN/kcsLF9rOP9EYwXVFihVphJNFF1yOLfOoKZS48M/Ws6aJ7tZl5HfXvOiu9tW2Bjfj3d/QjEbWHiE9kfUDY+OQmH8Jw/s+UELz7WC0jUHi2dTF5uh2hc6vjxWqoHb4IHAnnsHSKQl7fVL4LinfjpPwJNw45pAqO4AjgHe0BYkKimz0lxQ1PXDBwj7hLOag0USmWFaoF4DKALfPa5/INmoDXtLE5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Linux namespaces can be created and entered individually, but userspace
orchestrators lack a single control object that binds a full detached
namespace set and an init process lifecycle behind a pollable file
descriptor. Because this object manages process lifecycle, wait and
signal delivery, VFS mount delegation, and LSM state rather than
representing an nsfs namespace entity, model it as a distinct userland
abstraction.

Add struct userland, its lifecycle states, reference counting, uAPI
flags, and anonymous inode file operations under CONFIG_USERLAND. Drop
active and passive namespace references on final release, send SIGKILL
to the userland init thread group on close when USERLAND_KILL_ON_CLOSE
is set, and report EPOLLHUP from poll() once the userland reaches
USERLAND_DEAD.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h      | 80 +++++++++++++++++++++++++++++
 include/uapi/linux/userland.h | 25 ++++++++++
 init/Kconfig                  | 10 ++++
 kernel/Makefile               |  2 +
 kernel/userland.c             | 94 +++++++++++++++++++++++++++++++++++
 5 files changed, 211 insertions(+)
 create mode 100644 include/linux/userland.h
 create mode 100644 include/uapi/linux/userland.h
 create mode 100644 kernel/userland.c

diff --git a/include/linux/userland.h b/include/linux/userland.h
new file mode 100644
index 000000000000..9b9fefed63ac
--- /dev/null
+++ b/include/linux/userland.h
@@ -0,0 +1,80 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _LINUX_USERLAND_H
+#define _LINUX_USERLAND_H
+
+#include <linux/refcount.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+struct file;
+struct nsproxy;
+struct pid;
+struct user_namespace;
+
+/**
+ * enum userland_state - Userland lifecycle states
+ * @USERLAND_INIT:	Build phase after ``userland_open()`` before any
+ *			process has entered. ``USERLAND_SHARE_NSFD`` is
+ *			permitted, ID mappings may be configured on the owning
+ *			user namespace, and ``"/"`` must be mounted in the
+ *			mount namespace before entry.
+ * @USERLAND_FORKING:	Bootstrap phase while the first
+ *			``clone3(CLONE_INTO_USERLAND)`` call creates PID 1.
+ *			Concurrent callers wait killably; reverts to
+ *			%USERLAND_INIT if ``copy_process()`` fails, or advances
+ *			to %USERLAND_RUNNING once PID 1 is attached.
+ * @USERLAND_RUNNING:	Live phase while PID 1 is attached. Subsequent
+ *			``clone3(CLONE_INTO_USERLAND)`` calls join the PID
+ *			namespace until teardown begins,
+ *			``USERLAND_GET_NSFD(CLONE_NEWPID)`` and
+ *			``pidfd_send_signal()`` are enabled, and
+ *			``USERLAND_SHARE_NSFD`` returns ``-EBUSY``.
+ * @USERLAND_DEAD:	Terminal phase entered after PID 1 exits and the PID
+ *			namespace has killed and reaped all member processes.
+ *			``poll()`` reports ``EPOLLHUP`` and
+ *			``waitid(P_USERLAND, ...)`` reports PID 1's exit status
+ *			without consuming it.
+ *
+ * State transitions advance from %USERLAND_INIT through %USERLAND_FORKING and
+ * %USERLAND_RUNNING to %USERLAND_DEAD, reverting from %USERLAND_FORKING to
+ * %USERLAND_INIT only if the initial bootstrap fork fails.
+ */
+enum userland_state {
+	USERLAND_INIT		= 0,
+	USERLAND_FORKING	= 1,
+	USERLAND_RUNNING	= 2,
+	USERLAND_DEAD		= 3,
+};
+
+struct userland {
+	refcount_t		usage;
+	int			exit_code;
+	struct user_namespace	*user_ns;
+	struct nsproxy		*ns;
+	struct pid		*init_pid;
+	spinlock_t		lock;		/* Guards userland lifecycle state */
+	wait_queue_head_t	waitq;
+	unsigned int		flags;
+	enum userland_state	state;
+};
+
+#ifdef CONFIG_USERLAND
+void userland_put(struct userland *c);
+bool userland_is_file(struct file *file);
+#else
+static inline void userland_put(struct userland *c)
+{
+}
+
+static inline bool userland_is_file(struct file *file)
+{
+	return false;
+}
+#endif /* CONFIG_USERLAND */
+
+#endif /* _LINUX_USERLAND_H */
diff --git a/include/uapi/linux/userland.h b/include/uapi/linux/userland.h
new file mode 100644
index 000000000000..4a9031f81dda
--- /dev/null
+++ b/include/uapi/linux/userland.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _UAPI_LINUX_USERLAND_H
+#define _UAPI_LINUX_USERLAND_H
+
+/**
+ * enum userland_flags - Flags for userland_open()
+ * @USERLAND_KILL_ON_CLOSE: Send %SIGKILL to userland init on final fd release.
+ * @USERLAND_CLOSE_ON_EXEC: Set %O_CLOEXEC on the returned control fd.
+ * @USERLAND_ALL_FLAGS: Mask of all valid flags accepted by userland_open().
+ *
+ * Every userland created by userland_open() allocates a full set of
+ * detached namespaces owned by a fresh user namespace.
+ */
+enum userland_flags {
+	USERLAND_KILL_ON_CLOSE	= 0x00000001,
+	USERLAND_CLOSE_ON_EXEC	= 0x00000002,
+	USERLAND_ALL_FLAGS	= 0x00000003,
+};
+
+#endif /* _UAPI_LINUX_USERLAND_H */
diff --git a/init/Kconfig b/init/Kconfig
index c8a7cfa60a6e..0c5fada1ba88 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1283,6 +1283,16 @@ config NET_NS
 
 endif # NAMESPACES
 
+config USERLAND
+	bool "Userland support"
+	depends on NAMESPACES && USER_NS && PID_NS && UTS_NS && IPC_NS && NET_NS && CGROUPS
+	help
+	  Allow user space to open and manage isolated userlands and their init
+	  process lifecycle through an anonymous-inode control file descriptor
+	  via userland_open(), waitid(P_USERLAND), pidfd_send_signal(),
+	  USERLAND_GET_NSFD, USERLAND_SHARE_NSFD, FSCONFIG_SET_USERLAND, and
+	  clone3() with CLONE_INTO_USERLAND.
+
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support"
 	depends on PROC_FS
diff --git a/kernel/Makefile b/kernel/Makefile
index 4ff92e24680c..80eb26639776 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -152,6 +152,8 @@ KCOV_INSTRUMENT_kstack_erase.o := n
 
 obj-$(CONFIG_SCF_TORTURE_TEST) += scftorture.o
 
+obj-$(CONFIG_USERLAND) += userland.o
+
 $(obj)/configs.o: $(obj)/config_data.gz
 
 # .config is small, so it is compressed with gzip rather than the image compressor.
diff --git a/kernel/userland.c b/kernel/userland.c
new file mode 100644
index 000000000000..7be0c4b5385b
--- /dev/null
+++ b/kernel/userland.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+/**
+ * DOC: Overview
+ *
+ * A userland is an anonymous-inode control object opened by ``userland_open()``
+ * that binds a detached namespace set, an initially empty mount namespace, an
+ * owning user namespace, and an init process lifecycle.
+ */
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <uapi/linux/wait.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/anon_inodes.h>
+#include <linux/userland.h>
+#include <linux/sched/signal.h>
+#include <linux/sched/task.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/mnt_namespace.h>
+#include <linux/nsproxy.h>
+#include <linux/ns_common.h>
+#include <linux/nsfs.h>
+#include <linux/pid.h>
+#include <linux/pid_namespace.h>
+#include <linux/time_namespace.h>
+#include <linux/user_namespace.h>
+#include <linux/idr.h>
+#include <uapi/linux/userland.h>
+
+void userland_put(struct userland *c)
+{
+	if (!c || !refcount_dec_and_test(&c->usage))
+		return;
+
+	if (c->ns)
+		put_nsproxy(c->ns);
+	if (c->init_pid)
+		put_pid(c->init_pid);
+	if (c->user_ns) {
+		ns_ref_active_put(c->user_ns);
+		put_user_ns(c->user_ns);
+	}
+	kfree(c);
+}
+
+static __poll_t userland_poll(struct file *file, poll_table *wait)
+{
+	struct userland *userland = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &userland->waitq, wait);
+
+	if (READ_ONCE(userland->state) == USERLAND_DEAD)
+		mask |= EPOLLHUP;
+
+	return mask;
+}
+
+static int userland_release(struct inode *inode, struct file *file)
+{
+	struct userland *userland = file->private_data;
+
+	if (userland->flags & USERLAND_KILL_ON_CLOSE) {
+		struct pid *pid = NULL;
+
+		scoped_guard(spinlock, &userland->lock) {
+			if (userland->state == USERLAND_RUNNING)
+				pid = get_pid(userland->init_pid);
+		}
+		if (pid) {
+			kill_pid(pid, SIGKILL, true);
+			put_pid(pid);
+		}
+	}
+	userland_put(userland);
+	return 0;
+}
+
+static const struct file_operations userland_fops = {
+	.poll		= userland_poll,
+	.release	= userland_release,
+};
+
+bool userland_is_file(struct file *file)
+{
+	return file->f_op == &userland_fops;
+}
-- 
2.47.3


