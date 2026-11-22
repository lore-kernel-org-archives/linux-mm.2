Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783AC60A3823
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h++5CFR1
Received: by kanga.kvack.org (Postfix)
	id 0AAA96B05C1; Sun, 22 Nov 2026 14:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C286B05C2; Sun, 22 Nov 2026 14:36:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FCD6B05C3; Sun, 22 Nov 2026 14:36:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92F866B05C1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5DB01606A8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:54 +0000 (UTC)
X-FDA: 85463762748.22.D6A075C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 219601C0002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h++5CFR1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376213;
	b=ItZyORb3jqIMpWLWR3auH3+P6zbDOTqG7P0ewU6YZMggPFGRFXXz+t2NtX5y4XbXbBOPyy
	iXuB5rqUBccSoSRVBabhaczpoYYB3CS+y9aaHuOmJXSAVc/d4Sptqw9vqYeYe67vURSiNh
	fGIjCfEF3S22P/VP+MwxYWEqwmpiKjw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgUTYSoeBbicoM/Ctv8wuw6txQmYFirn0xuo3QUM9bE=;
	b=SJ8aevyh55pPNu1HJJaCe2FKL4W6dnFqnhhUPIF8ecJU4ymt+ALia8bygMPq0CxAKBjyrv
	z5CcAIyILSl5FLHek30JpdS2V5aWrsOe/jMl2pcrtHBGY26A7neDYLiYaIFqg3RMrfwJB+
	Bg8fFXj9eVnaB7ChSWinqb8iTZlLCrs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h++5CFR1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 75005455B6;
	Sun, 22 Nov 2026 19:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 96DEE1F000E6;
	Sun, 22 Nov 2026 19:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376212;
	bh=QgUTYSoeBbicoM/Ctv8wuw6txQmYFirn0xuo3QUM9bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h++5CFR1P60aN6bCiiNMePpNEGsSZ4HlKZo8lWB6f4wdhTNz6/tSkMTg8xEpHbRxI
	 GlwySIf772FfNejL8QOE7DS9Aizp0uVQ7OkmwxoH40uYofSQqCzfMJ58pVkImG6RIZ
	 K4AMH4F5lVhyQeJnnZn7QVG98lo9L40YECd9yjtIprIs1WGapBRgEZTAUwpA1D/vse
	 9AnVSn/pA6MDVVk9wdaaUy3HQ3N4ZDFectxotNoTvOE88ZsWBmeAVyX1TQJ6xY8ovy
	 Svslni2eYDTNSN8Tttx+qsHPiF94D8NrmsIIFhHGYdKRWN+DSQF0ejgfAakQavvOKS
	 d7uWpKN6e7POQ==
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
Subject: [RFC PATCH v7 13/26] userland: Add USERLAND_GET_NSFD ioctl
Date: Sun, 22 Nov 2026 21:35:26 +0200
Message-ID: <20261122193539.3334213-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 219601C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: pu7psde9rosrrdnkhp5w9gamwcqdepiu
X-HE-Tag: 1795376212-105670
X-HE-Meta: U2FsdGVkX1/7z9Rw3Vh3oDJf+0Z3WoZRMpe7sykAty69d6erWi2JU9+Wt6722pRmeUalQ61jc/90/ozABDzSzbAJix+GFwS0qLyxr+Ho86L7Wr5k35uXhFya60Zwt9hvk5tYae1WiGcFmgTvD3GCfdW3BbUlLXKh+gI9RkT1e3qc1galP1D8MrAZa7b1+nCt0K9bdKwSZRlbvbwhnRUE4uX/YpzuXehl74MYfAq48dW75JrFwglo0WBgefgb4HEpFLSbUWNyqMKFgHpISBm5efv+H+3n/UgF/3P9XNp0IC6euiZzW3O8cwwhjjKI/LvopIaUNqFdxbfIEcBhFNN7tsnxBf7zKCUjRZCG6QpZarpC+/a+dP3zT6VWecEaN9PlO7Sd16WMx72iFDFQ4udHjYS/4KpKeooRwKWziQzLNmIUVHKvziOUrhx7kFu1NmCkXzA38ps4zMedPEdn4QQ5+AjIxalgFg0syzClY28pCA2O75ix6pIE2bQAhYpIdi+6kQJlvv5xO7NRW54hGDfiZj4DoJq/ZoHTqvOb/ZVqJs6W8x0E0NY4EWpOjT6Laex25/RGevlTwrx/r2R2BTkYF8BIJGISFBYAmkLf+1sb8tAAVlL0O5FAnzCwBei5afyeUuFisLd4wTlk6YprB3POhvy98eu+LZWTlsUDT2quFLiKPhpupHR4mfutpRoDW6j7dy4c9HPO6W4z3afwcTc/rJ6AFLzelKV1cO6bIQ39fuHvbspgOYURvZMrt4F7DBKNF4mMpdLhPVdD7AqxeWxt9t4hl7pnMM1RXAs/vx7SZYF/uSjJ5EbJMcSC74//Snk43x4eQEdJsHLOyzXiAEedqvffHvTBG8JkLsA4eerPhWMdY1aAebRt/rpWLQ4a017Gp2D0nZs1psHXeeo4O1hrfulwX/CFC6gihFULCBgdXJneEX1XO4hknlJQ215XMV2iyfWjvDyJsNLsgT4TLzH
 5SeDpqka
 465SAJsb3OUxU8hjIe6mf13bqudTleMKglETkxCVfAxpSPJtDQS/uRSmbx62f1UP3OmY+QMI0k/1DEC433CWzZEQZbh9qIdbG0bR3zABnR3v0CDur7N2VoCkXLa3JJtNqrmdM21+Y369PFcSjipfi93y1Gd8pHfV154WdWsyqZG9qIJWCMHFzd5A+sEW5NYLzPn+66a0vEzZ9VwWWxOHFIAqLqw73FuZinYelBAp7wTqnVSpzaPBEgNdHaKX5NiXAk9BHqYK/7HlkeyHYa2gVJiUVlRKYD9ghR9MhKVA06pCp17aJLbGCSezG7sF7No1oZ1DBOjBhat1MSXR1ZEr6zyhVOBnMXTh3jLy3UNY4MmZ6mXf2mLtDS49XLJWh+CPv9CIWHI2oA8rAAT19Z0EaxWt6uSKQ3yAFSBy+ObJxBRk1PCUcLLGOjnkVc7+PIkpNKgFDRYAPTGBf/kROjYHIbMIQyQ==
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
index 472d75423b95..fd5f67c0245e 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -23,6 +23,8 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/cgroup_namespace.h>
+#include <linux/ipc_namespace.h>
 #include <linux/mnt_namespace.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
@@ -31,6 +33,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/time_namespace.h>
 #include <linux/user_namespace.h>
+#include <linux/uts_namespace.h>
+#include <net/net_namespace.h>
 #include <linux/idr.h>
 #include <uapi/linux/userland.h>
 
@@ -63,6 +67,76 @@ static __poll_t userland_poll(struct file *file, poll_table *wait)
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
@@ -85,6 +159,8 @@ static int userland_release(struct inode *inode, struct file *file)
 
 static const struct file_operations userland_fops = {
 	.poll		= userland_poll,
+	.unlocked_ioctl	= userland_ioctl,
+	.compat_ioctl	= userland_ioctl,
 	.release	= userland_release,
 };
 
-- 
2.47.3


