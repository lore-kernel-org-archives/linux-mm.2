Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452ED606A890
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lJjNi4q4
Received: by kanga.kvack.org (Postfix)
	id A24A66B05B6; Tue, 17 Nov 2026 18:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB676B05B7; Tue, 17 Nov 2026 18:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2EB6B05B8; Tue, 17 Nov 2026 18:14:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 571C16B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D02B6A0624
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:20 +0000 (UTC)
X-FDA: 85446166680.16.E7C8A35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 542D140008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lJjNi4q4;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957259;
	b=VOMkFLtQqewPeMLTSnnu4D5VSOOAhsdPvCrRDsM1ehg8CTFsfU53tqYCWWmkOOECcIFVtr
	M/JqIRgnBLjQxl1MCpnalsisapwwXH61XnJmU7wf3NOu3wRK3pM1vbdnNpYcfb6KpZNckG
	cLPyvC7nVVmmUQlJYFR8sU2U+IjQU2Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lJjNi4q4;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bBz9NFzTwB4gk5OkP+idn1ksFpESN+Xj8dQdU7cjCk=;
	b=5A+lsZ7IRYpZVLxNdHSw9uyDp/R6CRbQ05PfzA4wWUCi9m+i6SEE0M9HG6OIHPDrmz7Ed+
	PTFGr2nbVAMaQeoW/jU5XkdsJBus/TzonmqIBqITHiCqoElIg2IOygaR3EryEtEVY/AOMG
	uZ0cLBWuAtsbpRfuVwInbOOxPyUwsqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id D45D061DAC;
	Tue, 17 Nov 2026 23:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE7CA1F000CA;
	Tue, 17 Nov 2026 23:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957258;
	bh=0bBz9NFzTwB4gk5OkP+idn1ksFpESN+Xj8dQdU7cjCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJjNi4q4D0nA+9QKNBpfJf+7F80vYEvWgcKV86Bfizu/iwDbOUXW5u3xk3iUrT7aX
	 S3dLJjdnLZlj/F8SXKv71H2RzNgpbgCVk9vVN+B/MgkVkW1hp7CWCMaaOfhySj2Pqc
	 JH9s7GDXcsDJ1C8kP2OYyfRtOBWwvR8gmbQj9+bhhkDFiAQfkB4sg97lyOT/S2p2RR
	 oVAjudKJ0foItXlAlZbLBgI8vL6lWBRtRqWDrjLTjjs5QSLl3+D5t1L8hHC0pijUBU
	 aXk5QNC85uYmD1NREr+mbDnz8ff+N7TTF+khfJsWcB/M8Y5JIlJfKhZt8ORaErUah/
	 u8wqdPUFdlvrA==
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
Subject: [RFC PATCH v2 02/13] rootns: Add core infrastructure for root namespaces
Date: Wed, 18 Nov 2026 01:13:41 +0200
Message-ID: <20261117231352.3816603-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e8aimi4ks3b7tojk4dti9sx3xq8opzip
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 542D140008
X-HE-Tag: 1794957259-503430
X-HE-Meta: U2FsdGVkX1/QFTtWmW2Xgn4b7vER5Wr9adYLEUvuDWoHtu1YnnfnaNmK5osf23ssfNqCVO/st+/jgpjZyO8eVA08FnC/QhTvZswb1R2GZwb0ybUM1bd6njBwHKG6wVdA8rqfJo8IS4GlwXEov150xDQU56V2ZD53D+7lnE0e3HetmYRnOwO/X6B2aw7+KOIj3fPbZTapjWiAVtgSXe4lq5f/w0A/JxFc3TItPMjffscWBmuFwiO4JAw1TWGq5kVUz2YUiiK0pmhJtDGLFVc3iEgKBaarDa6grGB/Rigfo2TDnaGe7U388KZAvLz/8Ug6QBVR6H1D5zTKX5CEv6U8PsHVUkuFbF563Fw9t+hkN03NmtvTtwgH8Pbrmlw/Il+7J5NunoGFg4fEb2z6uKqZlYiNy8eNkULHDa/4KoxkNqBdplMVhvIEEv8ytp7dl/z3d5SdVTPPxjrRLOxxTytbk+4Slc+fHUAVvtcVVyBwKEyMkdsxuzx/oA7vky6zxU/jSkCxCy/ObhZarOdLtQF7LSDmH+zZhvl93HbPo6nIsEy3NjYYiEQH0eIgww7jeK3R1GTFQNVkuJDG1/VWRmg/LEvaGYx/pII4DlrlThWQQev4jSLjDnQrZ6hiLKyODMWdOyYsezmxCrIz/KdeY9WAYX5GW3iOoRyPQ8UeeoTYsyuEDH8WWKjSF4H5A5p+2r5IxRXEQJGESHkBR9TLQuYO5+Sh+P5xwScZI8fywGrwoi+hVgdXyoH6sZWqXekBHGa24FJiuxrLcjOpApr4KVqLEnDfTKXcBhqDKxEEBzUOnda/cT9C0Muv+eeb8Jtru6YFnkh9PiFKmaTrttDJGIcU2UqPYQLTI8yc87Zg1HUbaJ7cPxCadvNGBIamRHcAOoufdfB6rw4cYoqeinQBZkin21bl7vGzGI4J8WOnRlmrszl83v6lDe+XYrQf5l9wpiCnC0Z+w+3sVUoMmwxmfHG
 0/IaisdE
 H37TKDR86NfbLaxiG1G4vSKUOBRRbI7E7xczXLZNacHlRV/suWaS3nVi45ygPEqd+Pkh5v2vap03/9erfsGuMvmwqIC+xh2vYkTPnkLEQnvDKWQFTH57/FgQEKxbeT/xsz4HPPU4Odt2/c4fWUthTkN2eaPYjZD2HrcwakJwv6hBICQnNXLzjxeAWtu5HeWo6jvFmjtOk/L73h7R7D/Ew4JACf+8XtrZHpG6f9pynXGM2NmDcH/SQ2bYjqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Linux namespaces can be created and entered individually, but userspace
orchestrators lack a single kernel object that binds a namespace set, a
root mount, and an init process behind a pollable file descriptor.

Add struct rootns, its lifecycle states, reference counting, uAPI
creation flags, and anonymous inode file operations under CONFIG_ROOTNS.
Drop active and passive namespace references on final release, send
SIGKILL to the rootns init thread group on close when
ROOTNS_KILL_ON_CLOSE is set, and report EPOLLHUP from poll() once the
rootns reaches ROOTNS_DEAD.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/rootns.h      |  66 ++++++++++++++++++++++
 include/uapi/linux/rootns.h |  38 +++++++++++++
 init/Kconfig                |   9 +++
 kernel/Makefile             |   2 +
 kernel/rootns.c             | 107 ++++++++++++++++++++++++++++++++++++
 5 files changed, 222 insertions(+)
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c

diff --git a/include/linux/rootns.h b/include/linux/rootns.h
new file mode 100644
index 000000000000..8464c90863ac
--- /dev/null
+++ b/include/linux/rootns.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ */
+
+#ifndef _LINUX_ROOTNS_H
+#define _LINUX_ROOTNS_H
+
+#include <linux/refcount.h>
+#include <linux/resource.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/path.h>
+
+struct cred;
+struct file;
+struct nsproxy;
+struct pid;
+struct task_struct;
+
+enum rootns_state {
+	ROOTNS_EMPTY	= 0,
+	ROOTNS_READY	= 1,
+	ROOTNS_FORKING	= 2,
+	ROOTNS_RUNNING	= 3,
+	ROOTNS_DEAD	= 4,
+};
+
+/*
+ * The rootns object.
+ */
+struct rootns {
+	refcount_t		usage;
+	int			exit_code;	/* The exit code of 'init' */
+	struct rusage		rusage;		/* Resource usage of 'init' */
+	const struct cred	*cred;		/* Creds for this rootns, including userns */
+	struct nsproxy		*ns;		/* This rootns's namespaces */
+	struct path		root;		/* The root of the rootns's fs namespace */
+	struct pid		*init_pid;	/* The 'init' task's TGID (pid ref) */
+	spinlock_t		lock;		/* Guards rootns lifecycle state */
+	wait_queue_head_t	waitq;		/* Someone waiting for init to exit waits here */
+	unsigned int		flags;		/* Validated rootns_create() flags */
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
index 000000000000..bde89d183578
--- /dev/null
+++ b/include/uapi/linux/rootns.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _UAPI_LINUX_ROOTNS_H
+#define _UAPI_LINUX_ROOTNS_H
+
+/**
+ * enum rootns_flags - Flags for rootns_create()
+ * @ROOTNS_CGROUP: Create a fresh cgroup namespace instead of inheriting.
+ * @ROOTNS_UTS: Create a fresh UTS namespace instead of inheriting.
+ * @ROOTNS_IPC: Create a fresh IPC namespace instead of inheriting.
+ * @ROOTNS_USER: Create a fresh user namespace owned by the caller.
+ * @ROOTNS_NET: Create a fresh network namespace instead of inheriting.
+ * @ROOTNS_KILL_ON_CLOSE: Send %SIGKILL to rootns init on final fd release.
+ * @ROOTNS_CLOSE_ON_EXEC: Set %O_CLOEXEC on the returned control fd.
+ * @ROOTNS_ALL_NAMESPACES: Mask of all optional namespace selection flags.
+ * @ROOTNS_ALL_FLAGS: Mask of all valid flags accepted by rootns_create().
+ *
+ * Every root namespace unconditionally owns dedicated mount and PID
+ * namespaces. Optional namespace flags allocate fresh instances of the
+ * remaining namespaces instead of inheriting them from the caller.
+ */
+enum rootns_flags {
+	ROOTNS_CGROUP		= 0x00000001,
+	ROOTNS_UTS		= 0x00000002,
+	ROOTNS_IPC		= 0x00000004,
+	ROOTNS_USER		= 0x00000008,
+	ROOTNS_NET		= 0x00000010,
+	ROOTNS_KILL_ON_CLOSE	= 0x00000100,
+	ROOTNS_CLOSE_ON_EXEC	= 0x00000200,
+	ROOTNS_ALL_NAMESPACES	= 0x0000001f,
+	ROOTNS_ALL_FLAGS	= 0x0000031f,
+};
+
+#endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/init/Kconfig b/init/Kconfig
index c8a7cfa60a6e..4e9483d3b0a9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1281,6 +1281,15 @@ config NET_NS
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 
+config ROOTNS
+	bool "Root namespace"
+	depends on USER_NS && PID_NS && UTS_NS && IPC_NS && NET_NS && CGROUPS
+	help
+	  Allow user space to create and manage isolated root namespaces
+	  with their own mount tree, credentials, namespace set, and init
+	  process lifecycle via rootns_create(), rootns_wait(),
+	  rootns_kill(), and clone3() with CLONE_INTO_ROOTNS.
+
 endif # NAMESPACES
 
 config CHECKPOINT_RESTORE
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
index 000000000000..e75d918b93ec
--- /dev/null
+++ b/kernel/rootns.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ */
+
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <linux/fs.h>
+#include <linux/anon_inodes.h>
+#include <linux/rootns.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/nsproxy.h>
+#include <linux/ns_common.h>
+#include <linux/nsfs.h>
+#include <linux/pid.h>
+#include <linux/user_namespace.h>
+#include <linux/compat.h>
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
+	path_put(&c->root);
+
+	if (c->init_pid)
+		put_pid(c->init_pid);
+	if (c->cred) {
+		ns_ref_active_put(c->cred->user_ns);
+		put_cred(c->cred);
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


