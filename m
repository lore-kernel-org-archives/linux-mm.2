Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C95606A686
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TxeiH5mi
Received: by kanga.kvack.org (Postfix)
	id C92356B05C7; Sun, 22 Nov 2026 14:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42F06B05C8; Sun, 22 Nov 2026 14:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95A16B05C9; Sun, 22 Nov 2026 14:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF476B05C7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:37:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4BA016070E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:07 +0000 (UTC)
X-FDA: 85463763294.18.EFBD0DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3F2382000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TxeiH5mi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376226;
	b=E40CI1EuExlVIolHoixAY8pMjCtfV5XiWkonJ+4a/TewJO1Z8uVMdp2ntfNRrC8AwMWo2y
	ncFrYYDvvbv1NX8pfu5SeTi30v4dR/WNrkPnBHW/ccen+KMf3mmuewbcdxpVaYmmdP0hu8
	2ioz9GxDCap0dYgLc+perFG8eQGEBAA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVGgI7D53IZyEOdiIQgJZT0cYrc34vgpwt54f5ogQLw=;
	b=riUKWAyXMzYhqAnpesc8eSR0SxAaCL9Z5bl8ppFhAxe3o9UGvb/zFb++l5eAtydf4IjVSN
	Qoe+P4ohsdSJNdHp898nOZSCWYP61lqd6fmbJc7kmkLmiwajmXDl/k3EgLlDjnMza1EB78
	92QFYJ8R8HHTvcO64TSEkS9tn1MWgzM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TxeiH5mi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 9058A4393B;
	Sun, 22 Nov 2026 19:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A5F861F000E0;
	Sun, 22 Nov 2026 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376225;
	bh=aVGgI7D53IZyEOdiIQgJZT0cYrc34vgpwt54f5ogQLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxeiH5migMxtxLZVPutyjQ6/J7QKqoSFH/e1HcOJIJSoDF1AA8CxhtTITwMigbaeb
	 I9yS9g21CpCn5IIvX186gax7JrXaTQBSO3ytBizEP9b1mmNiOvd6LF7PXsEu+Pc1b8
	 HUjIkMPk0nbBRdDYSnLBo07GsUKETFbxFuQLsLkf9MvtM04bWUSk8OXqQVBjxoBPds
	 ncy7NCV3vxBxbV21mOz7yth9bNwCBbMdoXiISOaGDkM/Dj+IxpDGfzNucXbWlBzCHT
	 jJAjknZhWjnuCc2ZXFoM2hJr9/b8Jpm0XKBGdFCBO9W5/nM4ALcdEReyW3sCbliMy6
	 L0ZYYKufVT4QA==
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
Subject: [RFC PATCH v7 16/26] signal: Support userland fds in pidfd_send_signal()
Date: Sun, 22 Nov 2026 21:35:29 +0200
Message-ID: <20261122193539.3334213-17-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F2382000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 87dnh469otf4e6dwbjijgj7mo6gu3oi5
X-HE-Tag: 1795376226-955666
X-HE-Meta: U2FsdGVkX18vkQTs6niZFtC1r6+BgfuG8K6Z3QUneZaUyS8wZJaJezeqPtAdhrz2kix5fsqA54hM8WOmPu5Ci2VppSzJRPSYGevObtbi0m2oy5Gq/gEJjq8ltPVIKRBcEsj+9oosTDI9gWwHPveaBIxGFus8w1s2S6zYwUAVo5PobPGYHrPl152tXw4AI7Vn+QtZEVCPWUSpb/lqQS3NwMraakoR1DW9OIBuJZPbbyTBYXDvhAjOmBZhDE4YMy1WVAZxYWvjXBkULc/d+8LVs/dhNo1hUp/7TB8eZ2euPmsBvjfmEx0M6NEGyqs4FlqxlW4qTdgf7kjBtAlot92vTI84paL0gmRdlmH1N5QofmfqQhgrFTioL+zK8pSdOLeMPQfIyHBGNqucw6eFSgtp2Km6oyXVqFlJDC48+nx8rF5z0v7uGECstoTVOoYhaeJ47y0wCgsoDJ5s1FxHckZNbGOo3/4vHUeFt3yTf8O1QKHxHgU1aYCXMn0WpVtaEs+KsrSNDevKhy56WQGDKqkz8y4IHZ/E6s8wyYmdYD6r4GAuQ8OoKHoaNB3PTbY34JPxknCGDj+Av3R9j+ENL7pPCkRhp57Nm73zrB9np67teCLkRI3MXyhRx1MGx8shokvDn7mDQ1v34yuPiQSdT9Ye/8vpmzaynwD2kLkPljw23q5vFOOQc08X/GMgVTHeKN5V7X7iu6x0ySKDKT3SLeAUdohMPHjB3SjqhUGjvpOeAQaso2ekyK0RV8dgqIi/tax3YWzaANf3xh/7dSYkr1sLaMG+GLnLdCk7XL0RN9Ta74rXTLkio+pmQuXHudUDN65DX+zMfqTcwdGYzJnvl2g/nUEwsYcsIc09JjTMbKXQenMhIvyyc3kr9cjF0LlCdlTseH10XYJvb2yZihzxXJ5bngeL6K34DU43EeGDbpDOgC3xsuttvSC8HPMAZBWBVKszUMwlNeNEsGunIyVwqmm
 WF0Dp4Vh
 dsvisRuqgi1ArQcpBmp2CYoHKuBtqJuFDbMoCXfFM/qthfgXMd3VBeifOcC6NvCcXROl5UAIVZJFzGiSiX/ppQPD5nyhtdMPr/zu3w6NMI+yAR3TAMVniLW9ksDUJsAnTM229eIcds73+oFmcID4ODKiud5bJjHnH2GaNPS/A5uRVMpHLelDv1HQi0+ytdqK4GO7LEJEmOEoJRpesdxx/lcsXddGxFYfL4NOmTj8RcaOS5SVsaS5nvASgZ7sUV071l2hGs+ZvtssGSGKsfQcvVsAohnCmhN5H6G4FlqIyuAPuiEnQINOXRCVLpmMrsbOLy+mAmhfSLOnrVD8KSIokHUkJuLXb5fKRklEEZc+OBpDEvffJh0G31V22Mu0kbJ8h7dk7vYPtUZVbpt3oglO7K+GBo5m0H/Tl+ZUhTqF9edYUk2Ljgnh66nWjmjFdbcGuvq4VQhv4VcniIO+pp8PAh13Cwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signaling every process inside a userland from userspace via /proc is
racy against concurrent fork() calls.

Teach pidfd_send_signal() to dispatch userland file descriptors to
userland_send_signal() when info is NULL and flags is 0. Require an
ancestor active PID namespace, walk the userland's PID namespace IDR
under tasklist_lock, and deliver a validated signal once to each thread
group including in-flight forks by member processes, aggregating
per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h | 10 +++++++
 kernel/signal.c          |  4 +++
 kernel/userland.c        | 59 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/include/linux/userland.h b/include/linux/userland.h
index 16988e10f623..da0978db54dd 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -17,6 +17,7 @@ struct nsproxy;
 struct pid;
 struct pid_namespace;
 struct rusage;
+struct siginfo;
 struct task_struct;
 struct user_namespace;
 struct waitid_info;
@@ -77,6 +78,8 @@ void userland_copy(struct task_struct *tsk, struct pid *pid,
 void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
 long userland_waitid(int upid, struct waitid_info *infop, int options,
 		     struct rusage *ru);
+int userland_send_signal(struct file *file, int sig,
+			 struct siginfo __user *info, unsigned int flags);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -102,6 +105,13 @@ static inline long userland_waitid(int upid, struct waitid_info *infop,
 {
 	return -EINVAL;
 }
+
+static inline int userland_send_signal(struct file *file, int sig,
+				       struct siginfo __user *info,
+				       unsigned int flags)
+{
+	return -EBADF;
+}
 #endif /* CONFIG_USERLAND */
 
 #endif /* _LINUX_USERLAND_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index dd770e68faee..5b11e67dc98a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -37,6 +37,7 @@
 #include <linux/capability.h>
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
+#include <linux/userland.h>
 #include <linux/nsproxy.h>
 #include <linux/user_namespace.h>
 #include <linux/uprobes.h>
@@ -4181,6 +4182,9 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 		if (fd_empty(f))
 			return -EBADF;
 
+		if (userland_is_file(fd_file(f)))
+			return userland_send_signal(fd_file(f), sig, info, flags);
+
 		/* Is this a pidfd? */
 		pid = pidfd_to_pid(fd_file(f));
 		if (IS_ERR(pid))
diff --git a/kernel/userland.c b/kernel/userland.c
index 3ded663b71af..f449e2ff9152 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -296,6 +296,65 @@ long userland_waitid(int upid, struct waitid_info *infop, int options,
 	return ret;
 }
 
+/**
+ * DOC: pidfd_send_signal
+ *
+ * ``pidfd_send_signal(userland_fd, sig, NULL, 0)`` delivers ``sig`` (or ``0`` for
+ * a permission and existence probe) once to each member thread group in a
+ * running userland. ``info`` must be ``NULL``, ``flags`` must be ``0``, and the
+ * caller must run in an ancestor active PID namespace.
+ */
+int userland_send_signal(struct file *file, int sig,
+			 struct siginfo __user *info, unsigned int flags)
+{
+	struct userland *userland = file->private_data;
+	struct pid_namespace *pid_ns = userland->ns->pid_ns_for_children;
+	bool any_success = false;
+	bool any_other = false;
+	bool any_perm = false;
+	int other_err = 0;
+	struct pid *pid;
+	int nr;
+
+	if (info || flags || sig < 0 || !valid_signal(sig))
+		return -EINVAL;
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+	if (READ_ONCE(userland->state) != USERLAND_RUNNING)
+		return -ESRCH;
+
+	scoped_guard(rcu) {
+		read_lock(&tasklist_lock);
+		idr_for_each_entry(&pid_ns->idr, pid, nr) {
+			struct task_struct *task = pid_task(pid, PIDTYPE_TGID);
+			int err;
+
+			if (!task)
+				continue;
+
+			err = group_send_sig_info(sig, SEND_SIG_NOINFO, task,
+						  PIDTYPE_MAX);
+			if (!err) {
+				any_success = true;
+			} else if (err == -EPERM) {
+				any_perm = true;
+			} else if (err != -ESRCH && !any_other) {
+				any_other = true;
+				other_err = err;
+			}
+		}
+		read_unlock(&tasklist_lock);
+	}
+
+	if (any_success)
+		return 0;
+	if (any_other)
+		return other_err;
+	if (any_perm)
+		return -EPERM;
+	return -ESRCH;
+}
+
 static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct userland *userland = file->private_data;
-- 
2.47.3


