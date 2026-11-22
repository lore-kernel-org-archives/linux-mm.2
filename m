Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062FA606A336
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZICPCjjt
Received: by kanga.kvack.org (Postfix)
	id B801A6B05C3; Sat, 21 Nov 2026 20:19:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30356B05C4; Sat, 21 Nov 2026 20:19:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8856B05C5; Sat, 21 Nov 2026 20:19:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5C46B05C3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18C5EA067B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:12 +0000 (UTC)
X-FDA: 85460996544.19.8FF3D10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 74E1740003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZICPCjjt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310350;
	b=GsEpL4auu9aJNWYE8kMPGmxNswpxBN9xpX8IJcNo7h0sKiHd9TTJ1vK1E0AP7vOGWJOI8l
	fYXpJpHNSrtFl0zWnS7tEfhLjsAD4LXLsXy83LOTvFyXgsClfCqUbHgbhbaW05+ikYNUin
	oDnoVE6/s1tRicFAfzE/leHdvo1OjIA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6b5T+T94stNFNvyCUcSUzMMjJryI8LUZHJBCrPXRP0=;
	b=KUYePCOIDhmTIntKLggb3yvwfW8afFCV+3y0ZU6TuUNaR8IWqtkUUhHVl+NxzcjZBb+kW4
	mei15wwEVNXWcd765lOrRXu8Bptm9Ace78vnsSGZlHe4RNRAajIFIZgu3QIY4Ehe/UwQxd
	sNFVgKvzmKXoz3T2F6guV5hPe0wQyLw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZICPCjjt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 1988A60D62;
	Sun, 22 Nov 2026 01:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F11F01F000C6;
	Sun, 22 Nov 2026 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310349;
	bh=p6b5T+T94stNFNvyCUcSUzMMjJryI8LUZHJBCrPXRP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZICPCjjtDIhyuST6MAGp0a28Xpc4OsFm4twyQqAAYCvdTwSK48Dy5BsQWivGRhXBQ
	 ADJpif3D7CA+HGImQXbdmdGoL15s3nbxJL3mtCxKZQpJ4OL8+U2eMMi7xjVLg72ysw
	 A3qUKxXLhRFSsbVpnv6mrFiir2vNmyrvhewNHug1XB1dJ6lI8H8PEPveLhilQ+OPHF
	 29symbd2cWCahQLAqu2fa+F0qAA00SwAvU069eeWiTDfyhtZ7udBCeS4OBYROoRk8N
	 DWXPJ8pw1nz2m06RBi9jX/uaC4n2Kn3Ufsu9fhHAzDydKkNFG6KLCBlMAsSQJrwt6v
	 38idYYno96dOA==
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
Subject: [RFC PATCH v6 13/26] userland: Add USERLAND_GET_NSFD ioctl
Date: Sun, 22 Nov 2026 03:17:56 +0200
Message-ID: <20261122011809.2667684-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74E1740003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: mo5bhxx3hoduzfiazf1qu58479nfohjo
X-HE-Tag: 1795310350-467005
X-HE-Meta: U2FsdGVkX1/62rwmHkI6FApkZD0yOHb+Jve8uXptNr6LsniMTeNnR29xM52WgMYZQ4GJJwTKXjPnJMY7inPksQUvS1H0dTBqfGEXN5bARXiqCB6qxiH1deZK8yazUjF0vIbCJdK4S3iMzhZPzc0ACh89Y4/qL7N4S3Tw8KG7AW5JIPenKgYxk9D+xAbVAA+L6DSq8FInF8cCQ1OcQtkoeWXuLk1Sit6cNP7wzYvLc6iboYCpcexDzvK2ub5+wXwE1rRRPQlAdTQRSKKeq5dGojeJ4M5Y/MlL4w//lcRh88ISyqtjPCrafoQfQ5p9LrdDfw3c0oFxnXaALdqDhogoMctj4zDOkVCFBoM2pkDwlwhE8svNdy4Q9keYIHDn0+8G4Z9Oeh/RWJ5SkcHeC+eJMImbNklM4J7d17CIIDueHja06LZNfW4wGPLWvLQkOf3dCf0ODyrTrvg/0GrBUr4Z4KGLP6KVj+lEJe4WUPBi1w+wzIGmAEbMRO9qy+z/F5GiCHBtiH7G1bKB/pZoAgK07Rn3ON6iWMvIuRHudh7SwCbB1ai2zFS488/VWCjenV9wrmNFgNy9tHzGjGenpoylacuzI+/eiVhRoO2ampgk29/qNj9lbD3NkPu6d6/0iStVVAd/qDU9iktHZgMEgsN9Qn5O+Thd1VrjweecQaFtC9G7OQGzwTmeSSOZcjfQ1OUvFUDCSehphnE7vSbfd2TeR/Tx3J4nc4BENzE3578I+Kec9kBGrXiQtQBQQhW8xOY5HbqtXQYsv/nDQdgp2jXr/rbRNaZeN8CGC7fMND5H2lEhqwM8aWlXrk4hwi4hdigdLlWP8y4MXW3jdanZLFKKDrWBJrW7sE3YXrJpRss/sSRUNExkouHcHQ9KwNDJCYofpwC3CUqtPt+0XMvyBSx9iJD/jjLulwgBDomhWVdz5lcRS/U2e0+81og0Wou+E5gfYMq8ePcgnrqfj0XqIxK
 Iql27igk
 M+GRTcjuIsc63nojW1IzLzGkQW1PKjgRhAbRhXvBmQ233Cje3dFo0RSZfR6bsE9GE93sVfFHaAb+TdTMjczAF59+rCqKrBNb2mQ9oTkj+sNUb/E3k2mMYOCNHWensCHPAXwn8XijAjvCA+zAtKofaQAkgm1UszJRnuZk0V3ybCw6s3sOSUj7Bracl0UN1iZ+IcUjA4v5qtnddRae1O9NckOySCY9iBij+bUvrJRxNNQAp5r+ByXsxbsBED/eSQMQ5sxZGfwatOAbFZb2B9YeFK64dtsje5sF8zHfWUl9yUU/logenYfSF2yPOS3c3+tRKEP2YJ7dghGbteecFQGMEDoJvF+VGCcqaC5xykF2LXYm9pmmwU303ZgYdsCXZtUKx5mNyndF4p8k6XJ41bw5hUW8QxMUZiSsa1z/Jd8IbU/Aa3qHjOH2m/GKDFHUAoslImJK5y2ePo4FMbVCOwEUZltmlcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Standalone namespace operations such as userns_set_idmap() and
move_mount(..., MOVE_MOUNT_T_MNTNS) operate on nsfs file descriptors,
requiring a way to obtain member namespace fds from a userland file
descriptor before any process has entered it.

Add the USERLAND_GET_NSFD ioctl to open an O_CLOEXEC nsfs file
descriptor for a requested member namespace when the caller holds
CAP_SYS_ADMIN in the userland's user namespace, additionally requiring
an ancestor active PID namespace and a running init process for
CLONE_NEWPID.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/internal.h                 |  1 -
 include/linux/nsfs.h          |  1 +
 include/uapi/linux/userland.h | 19 +++++++++
 kernel/userland.c             | 76 +++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 3f2fbac40f8e..ee3f796241ac 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -250,7 +250,6 @@ extern void mnt_pin_kill(struct mount *m);
  * fs/nsfs.c
  */
 extern const struct dentry_operations ns_dentry_operations;
-int open_namespace(struct ns_common *ns);
 struct file *open_namespace_file(struct ns_common *ns);
 
 /*
diff --git a/include/linux/nsfs.h b/include/linux/nsfs.h
index 731b67fc2fec..40912c1eb5ff 100644
--- a/include/linux/nsfs.h
+++ b/include/linux/nsfs.h
@@ -23,6 +23,7 @@ bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino);
 int ns_get_name(char *buf, size_t size, struct task_struct *task,
 			const struct proc_ns_operations *ns_ops);
 void nsfs_init(void);
+int open_namespace(struct ns_common *ns);
 
 #define __current_namespace_from_type(__ns)				\
 	_Generic((__ns),						\
diff --git a/include/uapi/linux/userland.h b/include/uapi/linux/userland.h
index 4a9031f81dda..e81a06d6e9eb 100644
--- a/include/uapi/linux/userland.h
+++ b/include/uapi/linux/userland.h
@@ -7,6 +7,8 @@
 #ifndef _UAPI_LINUX_USERLAND_H
 #define _UAPI_LINUX_USERLAND_H
 
+#include <linux/ioctl.h>
+
 /**
  * enum userland_flags - Flags for userland_open()
  * @USERLAND_KILL_ON_CLOSE: Send %SIGKILL to userland init on final fd release.
@@ -22,4 +24,21 @@ enum userland_flags {
 	USERLAND_ALL_FLAGS	= 0x00000003,
 };
 
+#define USERLAND_IOCTL_MAGIC	0xB9
+
+/**
+ * DOC: USERLAND_GET_NSFD
+ *
+ * ``ioctl(userland_fd, USERLAND_GET_NSFD, nstype)`` opens an ``nsfs`` file
+ * descriptor (with ``O_CLOEXEC``) for the member namespace identified by
+ * ``nstype`` (one of ``CLONE_NEWNS``, ``CLONE_NEWCGROUP``,
+ * ``CLONE_NEWUTS``, ``CLONE_NEWIPC``, ``CLONE_NEWUSER``, ``CLONE_NEWPID``,
+ * ``CLONE_NEWNET``, or ``CLONE_NEWTIME``).
+ *
+ * Requires ``CAP_SYS_ADMIN`` in the userland's user namespace.
+ * Opening ``CLONE_NEWPID`` additionally requires running in an ancestor
+ * active PID namespace and that userland init is running.
+ */
+#define USERLAND_GET_NSFD	_IO(USERLAND_IOCTL_MAGIC, 0x01)
+
 #endif /* _UAPI_LINUX_USERLAND_H */
diff --git a/kernel/userland.c b/kernel/userland.c
index d99b5d99fcc4..7b44f400dc23 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/cgroup_namespace.h>
+#include <linux/ipc_namespace.h>
 #include <linux/mnt_namespace.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
@@ -24,6 +26,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/time_namespace.h>
 #include <linux/user_namespace.h>
+#include <linux/uts_namespace.h>
+#include <net/net_namespace.h>
 #include <linux/idr.h>
 #include <uapi/linux/userland.h>
 
@@ -56,6 +60,76 @@ static __poll_t userland_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
+static long userland_get_nsfd(struct userland *userland, unsigned long nstype)
+{
+	struct ns_common *ns = NULL;
+
+	if (nstype > UINT_MAX)
+		return -EINVAL;
+	if (!ns_capable(userland->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (nstype == CLONE_NEWPID) {
+		if (!pidns_is_ancestor(userland->ns->pid_ns_for_children,
+				       task_active_pid_ns(current)))
+			return -EXDEV;
+		if (READ_ONCE(userland->state) != USERLAND_RUNNING)
+			return -ESRCH;
+	}
+
+	scoped_guard(spinlock, &userland->lock) {
+		switch (nstype) {
+		case CLONE_NEWNS:
+			ns = from_mnt_ns(userland->ns->mnt_ns);
+			break;
+		case CLONE_NEWCGROUP:
+			ns = to_ns_common(userland->ns->cgroup_ns);
+			break;
+		case CLONE_NEWUTS:
+			ns = to_ns_common(userland->ns->uts_ns);
+			break;
+		case CLONE_NEWIPC:
+			ns = to_ns_common(userland->ns->ipc_ns);
+			break;
+		case CLONE_NEWUSER:
+			ns = to_ns_common(userland->user_ns);
+			break;
+		case CLONE_NEWPID:
+			ns = to_ns_common(userland->ns->pid_ns_for_children);
+			break;
+		case CLONE_NEWNET:
+			ns = to_ns_common(userland->ns->net_ns);
+			break;
+		case CLONE_NEWTIME:
+#ifdef CONFIG_TIME_NS
+			ns = to_ns_common(userland->ns->time_ns);
+			break;
+#else
+			return -EOPNOTSUPP;
+#endif
+		default:
+			return -EINVAL;
+		}
+
+		if (!__ns_ref_get(ns))
+			return -ESRCH;
+	}
+
+	return open_namespace(ns);
+}
+
+static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct userland *userland = file->private_data;
+
+	switch (cmd) {
+	case USERLAND_GET_NSFD:
+		return userland_get_nsfd(userland, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
 static int userland_release(struct inode *inode, struct file *file)
 {
 	struct userland *userland = file->private_data;
@@ -78,6 +152,8 @@ static int userland_release(struct inode *inode, struct file *file)
 
 static const struct file_operations userland_fops = {
 	.poll		= userland_poll,
+	.unlocked_ioctl	= userland_ioctl,
+	.compat_ioctl	= userland_ioctl,
 	.release	= userland_release,
 };
 
-- 
2.47.3


