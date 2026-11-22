Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7F5606A68B
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O0q/ePxI
Received: by kanga.kvack.org (Postfix)
	id BA5D76B05BE; Sat, 21 Nov 2026 20:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E436B05BF; Sat, 21 Nov 2026 20:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46226B05C0; Sat, 21 Nov 2026 20:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75A666B05BE
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD71B1A0493
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:00 +0000 (UTC)
X-FDA: 85460996040.02.6CEA7B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EAE36140004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O0q/ePxI";
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310339;
	b=q7jVGdoxl6l45D0ZsrdYNnfK++EJgEw0VUCxpxD7VUY7RRpIfGC/Gbsr05SPbw01nvBdKW
	dW4JNtTQ9sdeamWIhiug3UM+OV9qtWNEGqDrVPeYCJUG4axcizxsJODTVcfC/v+QFZGa2w
	7HF2LGeTBJWvJZFP5raqxvFFNq94LAk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKprgmkjSYGWcH+Y3MB3bIUsbQoCDkhJSH7Kfm9Ki7I=;
	b=Mk4bPSSMEIt0t1gqMl0LVytC4mrjKBJyzgGe4q+2Npf/OrDPX63AIminvdAjCz5121Ov/u
	UbIQjPnAUNTQ8NysBvOssHrqVWCeC7O8H7IHMnYWBWtJ1euFzUjb4O6cv5NS/rE3aRvGBv
	qVqp/DCTmTe5tA3A1QjhgF9zCqkzNyI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O0q/ePxI";
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 4B82145968;
	Sun, 22 Nov 2026 01:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7C9571F000E6;
	Sun, 22 Nov 2026 01:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310338;
	bh=HKprgmkjSYGWcH+Y3MB3bIUsbQoCDkhJSH7Kfm9Ki7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0q/ePxI+fYhjqjtfIYdA+w5/cm60BXmN0XB+eHr4C3tpnH705pFmKIVbP3zO+PW8
	 Rvqqfcf+fBo90Oi4MKO+9FnzHpyqYVIbeJ/Gu3mjitsTAoahzIvuV4e/6L5CA9lhCh
	 /55Rr3fewsAEHbkRRNWsAh/SgQLYrR+juURkrNwYtGXHZ6H7GKFQx3EFiuR95F4QRP
	 FlEks8ZGj3MB6PdvUncnQQT7B/CWUYPEfzXDFqW8+2UQDNgWkyTSU8FU9XSrkupN7b
	 GCAehQJj4KXuZw03OpSi8o3N6GU96qQvLP77XD8c48cqHCrteFmc3zc6j5pE0Bhcmp
	 vFNxlxAFHdNHw==
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
Subject: [RFC PATCH v6 10/26] userland: Add core infrastructure
Date: Sun, 22 Nov 2026 03:17:53 +0200
Message-ID: <20261122011809.2667684-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: EAE36140004
X-Stat-Signature: y68pfpdzeyccmcwitr6oqgn7ies6pz1b
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795310338-20405
X-HE-Meta: U2FsdGVkX1+plMYkIksv47OZwOIKrxKNf2k3AXMLLATwf0m1tea0r045ijsvoMLACUhNBKqHskOQLQ4sCJXb0cic9MezN2+JfHSndMxFJTaARzBoNT20G/rX0nrVJ5prTVVuP14gLpZlzz8vwtruobkmopuJgiE7nsmhofW6tGYqSHZwra+F+5H/UL9EIxNyO1PWiSlFSz61yUrntVLDfzv/pyQ38rwGsx1JvUz70K9dMPy4jEw8EbLcSW4rnywQrN/+xmzFJAakh4HCpqpTygZ5LeYDQUdedCDhIrk5PU2VbO8zAesN9BTOlcErFfjFx9e5eQGPRx41zyqB2bkKJrMefNbGYRwzT6PwmGqIqdVxzSt9+U9f/rjOdgt+yIcMalZMIwHV3YS3zIhDqS4yYTaeHeLhWhuWaSE4kG06O9De2ZIaOWiPI0tT00j7WwzZShih8vC4PruiZHWMw+sbLimv/2+DPomlMHNWFnwBaKQPqqwag4Te1s3OCiU0ksQHwECFJe41GErJJz2YXZV+i0YVrd3lvaNtcH/ByOey6RJKxv6I2Evugsq38xoHY/TiMIZvYNnBU+ulOLZ4loi/nSxhcVrsYfNko5/bXmqGrKP/ewsmaxf2mKF42iDUgeaxCk5I6Cr1rSVMJG+VswVdfinBQgPtt7iDQBUrDjGoh0WWrlquI3vy0ijtHahzDLQSDLEonzrTKyDuqVhDSoIZAcMuRZfrryX+/R+p8uF7zHIw4oM5Veii9sKLd/C0y+W5jKJcdAWlSa6NtrNZ3XdzfoQFFMIsHn+2wZDm5gHjXyw6M3/UU+HtMqRalZYqFhEmxAK7apnkhVBLnXNByICT5AmvFisqeB4E0oT/g+i7/IScY9wrrGKsCxPk3GfiiSORjTUw8LaOVwqpRQsO9Kbzr7OaoPSQlaFlxf9aUL4lOHhWY4NYfumkAxDHZYyblzmZMuM+SdI1Mt+UhITiyvT
 KbzUHT9o
 TnPlCu51B+kNWyeB+b4OkH3HQJVmxgRJDaO6UIMveL4wUShmQ59OBpIdzEz5RYi8BzHUadngY6EdRCUiSganF6wm2ONlPffcJ+/WzLBGygfpI5bMMIniGH1tQgGedzJEcykf78JDimTRo66oLajir8Y/QH0YMv+uPsZSsLMaonzLaJm71QWvji0wdjgDmMEsLnCpnsdlmmw9T2HE0XCJrJQUQgBCTgLHXduGNTDys+5EDI00QW2XaTvecsmQwTBvlQG1re0GeT75DTI7PBcHCzVq+ZzWMgZMWqEuq86e5+nBJ2jbJxbnLceh30Nr5sG3sxs1d96S1052VFisLhLR76xRl9vNA3XX087NSG/VDSXkDTz5gYoziGkAiu+yoXdh7w3SsfydsgQpkSXiWAAlTWY3CkV1b27F1NWfkxYUkLfgELPGg/KkSIWyLekYcVNEOeat+WrFdJ94xDTw69Cu6vCZpeQ==
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
 include/linux/userland.h      | 52 +++++++++++++++++++++
 include/uapi/linux/userland.h | 25 ++++++++++
 init/Kconfig                  | 10 ++++
 kernel/Makefile               |  2 +
 kernel/userland.c             | 87 +++++++++++++++++++++++++++++++++++
 5 files changed, 176 insertions(+)
 create mode 100644 include/linux/userland.h
 create mode 100644 include/uapi/linux/userland.h
 create mode 100644 kernel/userland.c

diff --git a/include/linux/userland.h b/include/linux/userland.h
new file mode 100644
index 000000000000..fa8628e1b89c
--- /dev/null
+++ b/include/linux/userland.h
@@ -0,0 +1,52 @@
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
index 000000000000..b339aa2103e1
--- /dev/null
+++ b/kernel/userland.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
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


