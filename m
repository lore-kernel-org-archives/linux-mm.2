Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C9D0606A690
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dz/4YhIh
Received: by kanga.kvack.org (Postfix)
	id C91B56B05C8; Sat, 21 Nov 2026 20:19:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69136B05C9; Sat, 21 Nov 2026 20:19:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E726B05CA; Sat, 21 Nov 2026 20:19:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 843A96B05C8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13EA11A04D6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:24 +0000 (UTC)
X-FDA: 85460997048.30.7BF5DEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6711E180009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dz/4YhIh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310362;
	b=zILqxdDF8Gx/qRg7RhZ/e0PxLlZdVWVhfetnr9qc1C3KLzVIxKVA3XzkXAG9UCOlk8AAfv
	SI9JKLlNY9MzDn7pz0sTIRydTrfuTs0CUedqX55/wF51+jfzdDEOuzshAsU+uTj1Pg/uF6
	ste6+JewpfglcT2axCS3ba9g0Eczm+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAXPLGk4ldTVweRjtypyvQWpm01HWBNWEtkTkkZV0Ks=;
	b=aCQSBAQWIQRv4SF8JI99GUxhTObz+ADJd6UNoPlqusdp/OvF3M/Yn10AxhitBhwbAOQq1r
	nywyE30xZkrGsqaexfckn2UkYUY4uLuX7mwz87rO51B0wW13qHB9K2UdJVac2GD2myojNK
	/j2rLYGigql01ByfkbldmTxlJrYMR1g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dz/4YhIh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 9B2C940723;
	Sun, 22 Nov 2026 01:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C9AE81F000C4;
	Sun, 22 Nov 2026 01:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310361;
	bh=RAXPLGk4ldTVweRjtypyvQWpm01HWBNWEtkTkkZV0Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dz/4YhIhwbfL7TBgpLOYcylHoSeC+EfOHizQxdnsHkkOkMt8dmQPqoFCuUqkozR/D
	 Ms9eeSCO9jU09brnBXTvHR8rTFC+YaPSbPtaS0Fp3UD0xZpDqjlYwLFsZVvI7cJogJ
	 zP54NVWr2/eJab+dPmKx2QKMmua8/q3GNiHGjOqHHETgHjx1gJ03D5+3Rg/37LSUgH
	 o3rzBgmcblZ5FaJs8T+Kku3WVSB/72I7DwwvZ2jaqT9n2mrLElXIG9YzMMrl/GsZnY
	 0k0iaQ7jc3K4+WNUvL9r/kw2Fh4CYRr8g9YB+JqSIj9hG3B2SzE1tkWIt9FNRIQ8XB
	 QgSw7hVxu2wQw==
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
Subject: [RFC PATCH v6 16/26] signal: Support userland fds in pidfd_send_signal()
Date: Sun, 22 Nov 2026 03:17:59 +0200
Message-ID: <20261122011809.2667684-17-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6711E180009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sxzr3fr3kff4hsyuwkdobgcnd6faetpr
X-HE-Tag: 1795310362-560323
X-HE-Meta: U2FsdGVkX1/+47+f+mcdsRRp+SWdZaxX37SHgumnQHA26YHLBnGmkUPeyl1GRrtE3uvc5NuCEGkHtsXw6JfcOrep5TreS+4SpongoLh2tdyyTrr0HvD56klgivylMiiPWqBlsxz7U+iu7wmgLP/2sST9wRHX3EtxXzVf8qEj/WnufFcQdyIlan+37k7TzVqpQnr+cOI4yHNgnEu8+R06NzyGciH5h5VHsd9s/eDbJQKxNr3VSfqyDqUsnfNIC7d0g9EvZH/jwUu6QkcEGajQQTZbuh8xyusQ7O6UCp1xqJVQCxd9yoWwPq5E723tckcARKKXz78abjREiSp5A9ufSUBJh6YqwCa7aZedXOt2rRqc1gyPkYDeOT3ibV1qVf2IFGJ6NbqTa3t9McXFtRopClC/YWAw6ucFj5x8RXrRc1C1Qu5N0iDu/cnUUavJjJZlG0WIymktiF9CVMg/uRR9HJD5A+bwHIbC3iM5U2ndO2wZRLuQx1vlCLmnzCfKsHekwKnrwBNIdYJVcNt+Qta839nF6cK9iOjvWPqoEhgsnrf12X8mLRIxSKTvS1nAPRf4e3EouXeV4OyHw01XViMOXvdYZRvVT3XdA/RJAZC08VOtLvRRL0A3NezRQ0obr0eHrEoIxyzFxGyO1PYmhPghOqYQauK6pq4tP+FKDNCdRhXph5A9Eek2AzSFy6VluGQPpyncLs5/Ntt0k8Ps/pvP8AnsLzVacF1my8amuGtfJqrsv8ZA9GfzELHHZ3pFY+1kU7Z4UAep1aVs79x2VSLrJE/J5FP1P6cjaLRzPDFSPgb8ikwUhzVjJQkrOrFls6F3IHNL0J2BBK8ta7zaHeJQbBmhzVxfyOtOm54jsYRSuP94Abhg9KGXlN+kfOC6xpNaqWYVUekkLk1zT5NS+UT7slllEai6p9TcfsY76TZ/teFUCmVPm9uQCDPkomQiN9zD6Gp8CFYWfHy6t5/qf18
 Di4v3qa4
 5g/IAxOhFW//m05FLTAaLpRdLks4/+GrfE1oexeLKvDf9EinKRZX01gr0ERi1i+8nzSnpJ1h4xLuInRE5sKPSoBQz2JtPSjZMQWGkslvmBnlH4AQL2VyiLpuqL3dTDcAXKCR8JKWbOXcGNHcWLWUuBM3CzTNqCUdgiGaGo9Vthpa4So9CvdPOMvEiVJJzJBVxyvFSUVXq9Y76VkMTT+xP4EnqfOo1hzMStcnlYlLzbJGNXfbrzsiOFb0gmOAt4AWoB+zGpO7lf9U/9CGKeD0WUZcBsq+ZOu6w0Cqa5mj+K7UfQ858RUQP033feISCj67wRjQaMIQRnangjnc+dfbGVK3rfG07f47RK31rsCNfn+2uw/I7/Pg/yvFOufi7+zKNTbQz+TKP0qjlKozXtPDoIuvw53HaOFFhxniMS6jUPKHaPuWit3dWmqCWD+tCXF7W5Ole6YFZybo0crNgtJ59DBIi8w==
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
group including in-flight forks, aggregating per-process delivery
results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h | 10 +++++++
 kernel/signal.c          |  4 +++
 kernel/userland.c        | 59 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/include/linux/userland.h b/include/linux/userland.h
index 1bab10d931b5..173c22c27ae9 100644
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
@@ -49,6 +50,8 @@ void userland_copy(struct task_struct *tsk, struct pid *pid,
 void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
 long userland_waitid(int upid, struct waitid_info *infop, int options,
 		     struct rusage *ru);
+int userland_send_signal(struct file *file, int sig,
+			 struct siginfo __user *info, unsigned int flags);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -74,6 +77,13 @@ static inline long userland_waitid(int upid, struct waitid_info *infop,
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
index c118defcff01..739f6b98c103 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -287,6 +287,65 @@ long userland_waitid(int upid, struct waitid_info *infop, int options,
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


