Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BB0606A696
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2GoX14N
Received: by kanga.kvack.org (Postfix)
	id 0D1CF6B05C6; Sat, 21 Nov 2026 20:19:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B706B05C7; Sat, 21 Nov 2026 20:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E8F6B05C8; Sat, 21 Nov 2026 20:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B36CF6B05C6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F0F8C063E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:20 +0000 (UTC)
X-FDA: 85460996880.21.F46BE37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73C48180006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2GoX14N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310358;
	b=aPkmZnQo4A2gkhrONEYVJUiXW5yZK3LkVbviYItuuL2kuM5Qy5/hnQ7TQvZ8ml0xNRACtK
	GWSu83OZ1z0u8Yr9eCL5qHfa4jPRA7qXqx2f2097QbbTwTbxoy4dQr61osxqYO8tFTLE7G
	ES/rcAJuvUuMamXlgO/ycPqvUQywU6g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bc4KCqTCCvqKRhvZx+lV6nXL57V09zR0YOdKWGFcYhA=;
	b=iNUmR4/GBqpeYVjdQGvXnw9TN6WnAM9QEv8uBzSLFVnsY4o3AezxMfdOGcFcUyHFWv/cfG
	EMuyJKdriVGJ1YK5ezR2QIUhgkfhs4c/OCDAfwTjXIS6hR9a2ou6yCfjHzSHLxUvEmqEKa
	uqp1o+dJ2NuILAiyoi68EKVLCjsYUi0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2GoX14N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id BCB8E43C55;
	Sun, 22 Nov 2026 01:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F09711F000CA;
	Sun, 22 Nov 2026 01:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310357;
	bh=Bc4KCqTCCvqKRhvZx+lV6nXL57V09zR0YOdKWGFcYhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2GoX14NlATm1xCe8kfL8b13V3o4ev026JjDpzRUVhQrAW4ge8mPmgOt0siXlM53b
	 GOCBuE3fvx+EN1DyFout1BBt4pYYKtUBG/u7HDwO8xEx9AwajQcgXyYHooNTFr+894
	 nh5vlspqdYtceJfowBfHcHkr0qq6ytTqL+4PE9Aj0RiQ7h4qJU3JsEMiSPGJ4kFbOy
	 7EpswnvEAO+OhQ/TYe2KgiIU8Mf/OdD3IAdY/5WNty+4i9MqtSdCp0VHRlq+mKuT5v
	 XVkYiSbeufsxkHrL9yM/gJYkBEPaL+cMURtT5/HuKJuvB4QsYmeoxn5CPKYBxCKVUo
	 5KDKoRMg8HVvw==
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
Subject: [RFC PATCH v6 15/26] exit: Support P_USERLAND in waitid()
Date: Sun, 22 Nov 2026 03:17:58 +0200
Message-ID: <20261122011809.2667684-16-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 73C48180006
X-Stat-Signature: yf1mufobjfhn5wuj9xt93xmeemchhdad
X-HE-Tag: 1795310358-137875
X-HE-Meta: U2FsdGVkX18tKhb8OVMtZ2urEyJPkZZrmEpr0DEwHLWOrIsPVH8TRg8ImrjyfWrtgBptGQZAYF8NZ0U+s5C8WAnRQ9DbYrI2lbGz3ymSjekge1ICzCPUo+Hn/9uJIDKes4I0S8O0q/L/nxopPYheyl8xMqbVMexREJWcxeiNl+V/Gh6dWZwZDRU3Ds4lSaUL9Eokp0YKWlQbek06LpVN3U4Iu1pLqiymNreReQ+aWHQKTHwjxd8KMSXX4OZNtrr4D/xnJCQRc/53zKsw2Muy0N3DwWkOsdpQYtJRM0COcRZ3o4HXr7cfcJji+8SxTL/ehbktynF04OSHkdjbnOjexeKgwTJIPwMaH3Wi11gi/GZY985dbrv9hoZGC5z6rjapTJ1gFqcmNUBs5bXag+FP0BnWTCIMThchOMw9sFwMXocyeJD07PU1LabN0EI7krlodz0i2UuEy8ZvaPt+gjSlu/+WoES6Ev/EOgNscybmd+10YCMXw4tVtczjWwqWA5BtXvs9yn6swFRIEJ6uahVsFZkPP6GbzhfACav0e/BuCUdCWdrJ2u+BE3054fYAm1EGXR+vLPY1ftC5eab02FHIgDoFXv45GPHlq7FnP/yV83EO3FkEb+JMWkRQl5HLPPEDlJcA6ObWvcepmHNtrPDA4CDBBMYryDafqxXKlWwMxXXeRouX73SKCgOHZHXfkOT4dBJeNftc4SbmE5FlFqqQCYd+BCGJ9iJ/7/LA+ObPMTKLU1j5Jl/qgOduWpsCbf+2Mn0cFE+li0Pd0FngUMCauXI+LVVHwYDoq8og87u9s9wHavoJOfyE7vlUhmnDOqJ/RQWvaB/xGYgb6YMEC/k1PZoZeBmo2kvdkUNhPe1l2UTN0YWNl6Nxgw6DMDVrcr6OJUODpHadM9TYwjxBZ6r/EqG+mynGMEGECKhMEnA+4QBQc6xRWAgN5d3pqbfDNui31EpheVzUNKOLL2ydyjl
 M8yeZYI+
 E9UdOSCFbhVgjE0jpfcUy00v57qdsV1FXaF1QoGKNCqpLPTFDLJ48pWc1rVgQkGBNaG9kxpuiSMuA3spqd+L6MBgUxtA0LCMjaEHF3hqaFtfREgOrEy5yDfzerKkz7YcQrXnX3snv1D50TrzK5k89XWEeaqyti3qUPZ2sbHRYlvh77SebIoUDUm1e2eEoCt5r5nRCNIVNL/7WT9mgn30JjPyOAw0S29doO9v59R461KNaHOq9a0lSab/yU/Fq2Ler1xFnRcwR84S4+Xvs1MU8bv3mObhcjde3BXntCKgCvqysPQYG6wly3bXWkz5CHsVWpNpGB4rNJSmhI3d+KNWiPX+a5CKfOQDEivp75Xb5u5CjjZzPsnSP0j6znoHswAMxRyNEhrkb4Svf9TVUGgAdSEE04olRnojULEh70XLG3/VH09tMhz6+B1dbwNFCIeyOl/qFB/buWk7NRotk80qIhKX7PF6By/mKFcsxPtH5V6UkjAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wait4() and waitid() only allow a parent or subreaper to collect exit
status, so an external manager holding a userland file descriptor cannot
wait on a userland init process forked by another process or observe
exit status multiple times across observers.

Add P_USERLAND to waitid() and wire kernel_waitid() to userland_waitid()
to wait freezably and interruptibly on a userland file descriptor until
the userland reaches USERLAND_DEAD and populate siginfo_t with init's
caller-visible TGID, munged UID, and exit status without consuming it.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h  | 10 +++++
 include/uapi/linux/wait.h |  1 +
 kernel/exit.c             |  4 ++
 kernel/userland.c         | 79 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+)

diff --git a/include/linux/userland.h b/include/linux/userland.h
index ec74eed6de1d..1bab10d931b5 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -16,8 +16,10 @@ struct file;
 struct nsproxy;
 struct pid;
 struct pid_namespace;
+struct rusage;
 struct task_struct;
 struct user_namespace;
+struct waitid_info;
 
 enum userland_state {
 	USERLAND_INIT		= 0,
@@ -45,6 +47,8 @@ bool userland_is_file(struct file *file);
 void userland_copy(struct task_struct *tsk, struct pid *pid,
 		   struct userland *userland);
 void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
+long userland_waitid(int upid, struct waitid_info *infop, int options,
+		     struct rusage *ru);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -64,6 +68,12 @@ static inline void userland_exit(struct pid_namespace *pid_ns,
 				 struct task_struct *tsk)
 {
 }
+
+static inline long userland_waitid(int upid, struct waitid_info *infop,
+				   int options, struct rusage *ru)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_USERLAND */
 
 #endif /* _LINUX_USERLAND_H */
diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
index 85b809fc9f11..edd39c2cab96 100644
--- a/include/uapi/linux/wait.h
+++ b/include/uapi/linux/wait.h
@@ -18,6 +18,7 @@
 #define P_PID		1
 #define P_PGID		2
 #define P_PIDFD		3
+#define P_USERLAND	4
 
 
 #endif /* _UAPI_LINUX_WAIT_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804..5b0bd3a9187c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -71,6 +71,7 @@
 #include <linux/unwind_deferred.h>
 #include <linux/uaccess.h>
 #include <linux/pidfs.h>
+#include <linux/userland.h>
 
 #include <uapi/linux/wait.h>
 
@@ -1803,6 +1804,9 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 	struct wait_opts wo;
 	long ret;
 
+	if (which == P_USERLAND)
+		return userland_waitid(upid, infop, options, ru);
+
 	ret = kernel_waitid_prepare(&wo, which, upid, infop, options, ru);
 	if (ret)
 		return ret;
diff --git a/kernel/userland.c b/kernel/userland.c
index efac9e4f2fa5..c118defcff01 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -8,6 +8,7 @@
 #include <linux/wait.h>
 #include <uapi/linux/wait.h>
 #include <linux/file.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/userland.h>
@@ -33,6 +34,8 @@
 #include <linux/idr.h>
 #include <uapi/linux/userland.h>
 
+#include "exit.h"
+
 void userland_put(struct userland *c)
 {
 	if (!c || !refcount_dec_and_test(&c->usage))
@@ -208,6 +211,82 @@ static long userland_share_nsfd(struct userland *c, unsigned long arg)
 	return 0;
 }
 
+/**
+ * DOC: P_USERLAND
+ *
+ * ``waitid(P_USERLAND, userland_fd, &infop, options, NULL)`` waits freezably until
+ * ``userland_fd`` reaches ``USERLAND_DEAD`` (unless ``WNOHANG`` or ``O_NONBLOCK`` is
+ * set) and writes init's exit information into ``infop`` without consuming it.
+ * ``options`` must include ``WEXITED`` and may include ``WNOHANG`` and
+ * ``WNOWAIT``; ``rusage`` must be ``NULL``, and the caller must run in an
+ * ancestor active PID namespace.
+ */
+long userland_waitid(int upid, struct waitid_info *infop, int options,
+		     struct rusage *ru)
+{
+	struct pid_namespace *pid_ns;
+	unsigned int f_flags;
+	struct userland *userland;
+	bool nonblock;
+	int status;
+	kuid_t uid;
+	long ret;
+
+	if (upid < 0 || ru)
+		return -EINVAL;
+	if (options & ~(WEXITED | WNOHANG | WNOWAIT))
+		return -EINVAL;
+	if (!(options & WEXITED))
+		return -EINVAL;
+
+	CLASS(fd, f)(upid);
+	if (fd_empty(f) || !userland_is_file(fd_file(f)))
+		return -EBADF;
+
+	f_flags = READ_ONCE(fd_file(f)->f_flags);
+	nonblock = (options & WNOHANG) || (f_flags & O_NONBLOCK);
+	userland = fd_file(f)->private_data;
+	pid_ns = task_active_pid_ns(current);
+
+	if (!pidns_is_ancestor(userland->ns->pid_ns_for_children, pid_ns))
+		return -ECHILD;
+	if (READ_ONCE(userland->state) == USERLAND_INIT)
+		return -ECHILD;
+
+	if (!nonblock) {
+		ret = wait_event_freezable(userland->waitq,
+					   READ_ONCE(userland->state) ==
+					   USERLAND_DEAD ||
+					   READ_ONCE(userland->state) ==
+					   USERLAND_INIT);
+		if (ret)
+			return ret;
+	}
+
+	scoped_guard(spinlock, &userland->lock) {
+		if (userland->state == USERLAND_INIT)
+			return -ECHILD;
+		if (userland->state != USERLAND_DEAD)
+			return (options & WNOHANG) ? 0 : -EAGAIN;
+		ret = pid_nr_ns(userland->init_pid, pid_ns);
+		if (ret <= 0)
+			return -ECHILD;
+		status = userland->exit_code;
+		uid = userland->init_uid;
+	}
+
+	if ((status & 0x7f) == 0) {
+		infop->cause = CLD_EXITED;
+		infop->status = status >> 8;
+	} else {
+		infop->cause = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+		infop->status = status & 0x7f;
+	}
+	infop->pid = ret;
+	infop->uid = from_kuid_munged(current_user_ns(), uid);
+	return ret;
+}
+
 static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct userland *userland = file->private_data;
-- 
2.47.3


