Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C01360A5BE5
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGlmyx+d
Received: by kanga.kvack.org (Postfix)
	id 8C99B6B05C2; Fri, 20 Nov 2026 19:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8522D6B05C3; Fri, 20 Nov 2026 19:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A7B6B05C4; Fri, 20 Nov 2026 19:09:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 340836B05C2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A05FC027E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:44 +0000 (UTC)
X-FDA: 85457192688.13.E7437D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E59D1180007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGlmyx+d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219783;
	b=wrukmHqnnHqhkNbJKHhofiQ8RhETv5YQrjNLvhVxSgiVm5grQdbBQ4GLmQ5qTPJ58mUQkl
	vqkQA8mT/3wNv59VKCiP2kMQUW5Kc/JbIh4ZrHtxQm6Gvj3AH2812UOhN8P4NQvNBotKzn
	Z7ssvUx6H+ewuXVtMxkNcbFHawT6LoI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34NsR9qDEX93JLH24p1g9gWYVr+3rl2EHG0BTWzvYeg=;
	b=XwwKVIa7nmT/O0wsHvcaLS1J0kuY+ayCMgE/9bCohGRFDMDOidtOR8PTaF+io7g1zWTbBh
	YDRIOpmUgNAXJq7zDZ9jpNQ/TxE1XWJdHdpQ+HZM1nqzmEkaTNPtYvFd6WVaSRTyYaRGQu
	ZJDTD0iztmB0EUnG/gQg21wz7oza6Po=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGlmyx+d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 4D89646495;
	Sat, 21 Nov 2026 00:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F76C1F000F4;
	Sat, 21 Nov 2026 00:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219782;
	bh=34NsR9qDEX93JLH24p1g9gWYVr+3rl2EHG0BTWzvYeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGlmyx+d7vmJOddR//D0BQKTFrq1yc81uhne+TWWDPcCYO9+q4+AzbumXzYCZxoD1
	 hmx8PXMmdy8iUvftVOdsH24NsdjNh0NGY8yI3l8SiTMPQ4eNc4N2vuOEHoz6IXkVFf
	 M+e1ouhcniuLfTASpu79zi/Zgpo8z1ABB1yv1w2oKtugequ1kdY8jW32dty5yhIqoI
	 f89orpbcXNez5/wKCOykePOMBKvoRq9ZklUSbVttHAhqL2XMcyt9VzNb3QoB/lupus
	 5VKLd/zRKpwLpfRzWng73o025PfnKBtODWOVsbPKLRDcYgNBsysxzr/3zEuXSakpOr
	 ofXwcJI4Wnk1A==
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
Subject: [RFC PATCH v5 11/25] rootns: Add core infrastructure for root namespaces
Date: Sat, 21 Nov 2026 02:08:30 +0200
Message-ID: <20261121000844.1863324-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E59D1180007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: g7mdwzxyepj13dhrtoe3u4bmtwghd4rq
X-Rspam-User:
X-HE-Tag: 1795219782-603905
X-HE-Meta: U2FsdGVkX18NnrSCylmXB6Qxp4JYg3mjMJhxTf4n1K1uS55k69NeydB86cJYaj+AwBTH+Usi8lI9z+0Iwl+Dd7B9bKydbCSZmcjWAFVTM7HqR20OXRDefcvidOyJ42Vmm1rtfaBDCAqzUk3NXJi/yO8DAczZy3+opgZ3/YyEFBs7mctpBI5+oEMFnpq0QtbjNXznguZJ3xxCjv6UOjtLx5deJOGMjvGFg06dTAE87LikpbNSKIRYVcc5LvC8CSW2dRKYe7UgKeD1BKXz9UXKHVyrrIwA8wk6mwps+Plmieo6yWxoToEWZS8mwO8QfF3BxgXiU62WduUed6DAEUGRv0JFfFbFX6ilClbnBQEadW+vQJv3gub9iDUPMX8ILcXRUjFuUq0z6YVMGRCWHa9a0FgSGqkBYus+cT4NdC5byaiUeqHJ1aA01BAjNDhGq1YXfJWpNzN+9oTK1qH6SKHe5qT6THo8mTXBqugehUws+bPYks+gpI57ppxkT54yvjh80gCv63JFwV1JSTn4LrMGDXd1ueSiqjCnZEl6p2hkyEny5wtpwZcJS3hbqTAS+3z17L5+74OGDKTv/BWhHqn7fg3EY2xHqCm/UlDPdX8TD0VVd4zhJeeyF/NJhnwMR2KuYj9Pm+sYCVaVXsgmWE2QzxGLYa/VczRSGMOJFX/fKBEq0ekU+wT0JkHuhUfmxJ483IzIkMcgZlX2uNch5br8VuJJRfkt8C7NXbP9G/IbB8ZlOito3tAEkEA6o4LPCeFME4LExSfqfr+wiGT1fbaeDCjZXnbr2Z+5ODtrVVcfyZ03YKouo5u+dVrvqokiHRkZyYFuKkXmT6bBKIfGA0fZmvn9NiFcgKuUZR0xnbMvdwG2+nbhnwPHfWJuX2PS9enbmdYqiBdF8ON5LDAQiJLHh7a8EJgg6zYUudtFsfDMSAHD9G/iRDHWl3Q3qt48T7uLmyHXbHRL0C6gjJ4K5FS
 RbDF5er4
 pcQ/9rUabOdBFE5bf5kcy4OGpE34jl4xcm/HVsX3zVueBoBIJnxNrXwtV59fP/DVuPkz06vVQ9W2ezJKqqxunQlpgg/ays5M0PCr2IYxBUwRvolS5lLwoWH0EZDMmVL+c4SziXjmkptqtfTPCFvhjfn/XRdWYvzVVFErTIH/TOT8HnxjBLdL2HaWqFxvEimXr+WVNd29/kFZ3T1Lpl+rl/rhHRAh2ZxJPvpXn1jX3qSaGOSY+dUZ7aQSFcn1rpoTY8SRXVsenrauFBQ24RNxsLUFke07em3E27FGVQP1ZgQFnvnuKH2xe35TRTJCtuSnqCFGl46Iiczco/wjIPRaOixXMw18nl/t/UP4c9uYy/jNq4swqbOKHum7rJyqwhockNoCgjVtcoHKcMft0THqXBh4krBP293rhMikvTcY1Rfx3jYM6IYa/EdemWijvZeLWAy8488HwlgyMqbGZw0M0CpXKCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Linux namespaces can be created and entered individually, but userspace
orchestrators lack a single kernel object that binds a full detached
namespace set and an init process behind a pollable file descriptor.

Add struct rootns, its lifecycle states, reference counting, uAPI
creation flags, ROOTNS_GET_NSFD ioctl, and anonymous inode file
operations under CONFIG_ROOTNS. Drop active and passive namespace
references on final release, send SIGKILL to the rootns init thread
group on close when ROOTNS_KILL_ON_CLOSE is set, report EPOLLHUP from
poll() once the rootns reaches ROOTNS_DEAD, and allow holders with
CAP_SYS_ADMIN in the rootns user namespace to open member nsfs fds.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/rootns.h      |  61 ++++++++++++
 include/uapi/linux/rootns.h |  44 +++++++++
 init/Kconfig                |   9 ++
 kernel/Makefile             |   2 +
 kernel/rootns.c             | 187 ++++++++++++++++++++++++++++++++++++
 5 files changed, 303 insertions(+)
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c

diff --git a/include/linux/rootns.h b/include/linux/rootns.h
new file mode 100644
index 000000000000..dcdba08cfaeb
--- /dev/null
+++ b/include/linux/rootns.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _LINUX_ROOTNS_H
+#define _LINUX_ROOTNS_H
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
+enum rootns_state {
+	ROOTNS_INIT	= 0,
+	ROOTNS_FORKING	= 1,
+	ROOTNS_RUNNING	= 2,
+	ROOTNS_DEAD	= 3,
+};
+
+/*
+ * The rootns object.
+ */
+struct rootns {
+	refcount_t		usage;
+	int			exit_code;	/* The exit code of 'init' */
+	struct user_namespace	*user_ns;	/* Owning user namespace */
+	struct nsproxy		*ns;		/* This rootns's namespaces */
+	struct pid		*init_pid;	/* The 'init' task's TGID (pid ref) */
+	spinlock_t		lock;		/* Guards rootns lifecycle state */
+	wait_queue_head_t	waitq;		/* Someone waiting for init to exit waits here */
+	unsigned int		flags;		/* Validated rootns() flags */
+	enum rootns_state	state;		/* Root namespace lifecycle state */
+};
+
+#ifdef CONFIG_ROOTNS
+struct rootns *get_rootns(struct rootns *c);
+void put_rootns(struct rootns *c);
+bool is_rootns_file(struct file *file);
+#else
+static inline struct rootns *get_rootns(struct rootns *c)
+{
+	return NULL;
+}
+
+static inline void put_rootns(struct rootns *c)
+{
+}
+
+static inline bool is_rootns_file(struct file *file)
+{
+	return false;
+}
+#endif /* CONFIG_ROOTNS */
+
+#endif /* _LINUX_ROOTNS_H */
diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
new file mode 100644
index 000000000000..bd643bdfb43c
--- /dev/null
+++ b/include/uapi/linux/rootns.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _UAPI_LINUX_ROOTNS_H
+#define _UAPI_LINUX_ROOTNS_H
+
+#include <linux/ioctl.h>
+
+/**
+ * enum rootns_flags - Flags for rootns()
+ * @ROOTNS_KILL_ON_CLOSE: Send %SIGKILL to rootns init on final fd release.
+ * @ROOTNS_CLOSE_ON_EXEC: Set %O_CLOEXEC on the returned control fd.
+ * @ROOTNS_ALL_FLAGS: Mask of all valid flags accepted by rootns().
+ *
+ * Every root namespace allocates a full set of detached namespaces owned
+ * by a fresh user namespace.
+ */
+enum rootns_flags {
+	ROOTNS_KILL_ON_CLOSE	= 0x00000001,
+	ROOTNS_CLOSE_ON_EXEC	= 0x00000002,
+	ROOTNS_ALL_FLAGS	= 0x00000003,
+};
+
+#define ROOTNS_IOCTL_MAGIC	0xB9
+
+/**
+ * DOC: ROOTNS_GET_NSFD
+ *
+ * ``ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)`` opens an ``nsfs`` file
+ * descriptor (with ``O_CLOEXEC``) for the member namespace identified by
+ * ``nstype`` (one of ``CLONE_NEWNS``, ``CLONE_NEWCGROUP``,
+ * ``CLONE_NEWUTS``, ``CLONE_NEWIPC``, ``CLONE_NEWUSER``, ``CLONE_NEWPID``,
+ * ``CLONE_NEWNET``, or ``CLONE_NEWTIME``).
+ *
+ * Requires ``CAP_SYS_ADMIN`` in the ``rootns`` user namespace. Opening
+ * ``CLONE_NEWPID`` additionally requires running in an ancestor active PID
+ * namespace and that ``rootns`` init is running.
+ */
+#define ROOTNS_GET_NSFD		_IO(ROOTNS_IOCTL_MAGIC, 0x01)
+
+#endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/init/Kconfig b/init/Kconfig
index c8a7cfa60a6e..58eafca2f42a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1283,6 +1283,15 @@ config NET_NS
 
 endif # NAMESPACES
 
+config ROOTNS
+	bool "Root namespace descriptor support"
+	depends on NAMESPACES && USER_NS && PID_NS && UTS_NS && IPC_NS && NET_NS && CGROUPS
+	help
+	  Allow user space to create and manage isolated namespace sets and
+	  their init process lifecycle through an anonymous-inode control file
+	  descriptor via rootns(), rootns ioctls, FSCONFIG_SET_ROOTNS, and
+	  clone3() with CLONE_INTO_ROOTNS.
+
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support"
 	depends on PROC_FS
diff --git a/kernel/Makefile b/kernel/Makefile
index 4ff92e24680c..7074d2664ce7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -152,6 +152,8 @@ KCOV_INSTRUMENT_kstack_erase.o := n
 
 obj-$(CONFIG_SCF_TORTURE_TEST) += scftorture.o
 
+obj-$(CONFIG_ROOTNS) += rootns.o
+
 $(obj)/configs.o: $(obj)/config_data.gz
 
 # .config is small, so it is compressed with gzip rather than the image compressor.
diff --git a/kernel/rootns.c b/kernel/rootns.c
new file mode 100644
index 000000000000..033e0aae386f
--- /dev/null
+++ b/kernel/rootns.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+/**
+ * DOC: Overview
+ *
+ * A ``rootns`` is an anonymous-inode control file descriptor (not an ``nsfs``
+ * namespace) that binds a full set of detached namespaces, an initially empty
+ * mount namespace, an owning user namespace, and an init process lifecycle:
+ *
+ * 1. ``rootns()`` allocates a detached ``rootns`` with a fresh user namespace
+ *    and dedicated mount (``CLONE_EMPTY_MNTNS``), PID, UTS, IPC, network,
+ *    cgroup, and time namespaces, returning its control fd.
+ *
+ * 2. Userspace optionally maps UIDs/GIDs via ``userns_set_idmap()`` on the
+ *    ``CLONE_NEWUSER`` fd, configures superblocks via ``FSCONFIG_SET_ROOTNS``,
+ *    retrieves the mount namespace fd via ``ioctl(rootnsfd, ROOTNS_GET_NSFD,
+ *    CLONE_NEWNS)``, and installs ``"/"`` and relative or cloned
+ *    (``MOVE_MOUNT_CLONE``) submounts via ``MOVE_MOUNT_T_MNTNS``.
+ *
+ * 3. ``clone3()`` with ``CLONE_INTO_ROOTNS`` spawns processes into the
+ *    ``rootns``; the first call commits PID 1 while concurrent bootstrap
+ *    callers wait killably.
+ *
+ * 4. ``ioctl(rootnsfd, ROOTNS_KILL, sig)`` signals all member thread groups.
+ *    When PID 1 exits, the PID namespace zaps and reaps all remaining tasks,
+ *    ``poll()`` reports ``EPOLLHUP``, and ``ioctl(rootnsfd, ROOTNS_WAIT,
+ *    &args)`` returns init's exit status.
+ */
+
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <uapi/linux/wait.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/anon_inodes.h>
+#include <linux/rootns.h>
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
+#include <linux/compat.h>
+#include <linux/idr.h>
+#include <uapi/linux/rootns.h>
+
+/*
+ * Get a reference to a rootns.
+ */
+struct rootns *get_rootns(struct rootns *c)
+{
+	refcount_inc(&c->usage);
+	return c;
+}
+
+/*
+ * Drop a reference on a rootns and clear it if it is no longer in use.
+ */
+void put_rootns(struct rootns *c)
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
+/*
+ * Allow the user to poll for the rootns dying.
+ */
+static __poll_t rootns_poll(struct file *file, poll_table *wait)
+{
+	struct rootns *rootns = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &rootns->waitq, wait);
+
+	if (READ_ONCE(rootns->state) == ROOTNS_DEAD)
+		mask |= EPOLLHUP;
+
+	return mask;
+}
+
+static long rootns_get_nsfd(struct rootns *rootns, unsigned long nstype)
+{
+	if (nstype > UINT_MAX)
+		return -EINVAL;
+	if (!ns_capable(rootns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (nstype == CLONE_NEWPID) {
+		if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children,
+				       task_active_pid_ns(current)))
+			return -EXDEV;
+		if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+			return -ESRCH;
+	}
+
+	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, nstype);
+}
+
+static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct rootns *rootns = file->private_data;
+
+	switch (cmd) {
+	case ROOTNS_GET_NSFD:
+		return rootns_get_nsfd(rootns, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	switch (cmd) {
+	case ROOTNS_GET_NSFD:
+		return rootns_ioctl(file, cmd, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+#endif
+
+static int __rootns_kill(struct rootns *rootns, int sig, bool priv)
+{
+	struct pid *pid = NULL;
+	int ret;
+
+	scoped_guard(spinlock, &rootns->lock) {
+		if (rootns->state == ROOTNS_RUNNING)
+			pid = get_pid(rootns->init_pid);
+	}
+	if (!pid)
+		return -ESRCH;
+
+	ret = kill_pid(pid, sig, priv);
+	put_pid(pid);
+	return ret;
+}
+
+static int rootns_release(struct inode *inode, struct file *file)
+{
+	struct rootns *rootns = file->private_data;
+
+	if (rootns->flags & ROOTNS_KILL_ON_CLOSE)
+		__rootns_kill(rootns, SIGKILL, true);
+	put_rootns(rootns);
+	return 0;
+}
+
+static const struct file_operations rootns_fops = {
+	.poll		= rootns_poll,
+	.unlocked_ioctl	= rootns_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= rootns_compat_ioctl,
+#endif
+	.release	= rootns_release,
+};
+
+/*
+ * Returns true if the file is a rootns.
+ */
+bool is_rootns_file(struct file *file)
+{
+	return file->f_op == &rootns_fops;
+}
-- 
2.47.3


