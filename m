Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA27606A336
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TSbA+he0
Received: by kanga.kvack.org (Postfix)
	id 394F46B05BD; Tue, 17 Nov 2026 18:14:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345C96B05BE; Tue, 17 Nov 2026 18:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25AEC6B05BF; Tue, 17 Nov 2026 18:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F250B6B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B8E11A05F1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:32 +0000 (UTC)
X-FDA: 85446167184.17.30A9C27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D6BF44000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TSbA+he0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwDa1R5hTozvkPRWD0eMYwP+MniaC6Knzv1Xuv/zVws=;
	b=nKBiWGXTUOqZtY4GnYL2Xk7byXL5G3j/1GAcQuNwSFhPvdNittHchga1+laSZD19ETcxlx
	GnVt2W75m4z7y4tj0o00SmhNKaCA2/XJGD+ii2I0edo5bCnRPfXLDX2p6J6woc2vZwMaB7
	zCUmfJm4xwJcrrynzhlTi+9FmWKMnN0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TSbA+he0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957271;
	b=nhWJ1lfcx7QQBqJwDKD6F5gYl31K5cvNzbvyCPBEMQ6YXSuGzSDl6wRn4IaaDOjoyj1zi3
	sCo7Ni9FQVeORlLPYwdTE5a1zURbSGLKMZsuh5Qwe/JdOZuVxBnjpNcfLQto9/0IRwIxVq
	cNCzz5UivBrjPbNXZazMrFbCzoOND7Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 36DAF4145E;
	Tue, 17 Nov 2026 23:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 670F21F000C5;
	Tue, 17 Nov 2026 23:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957270;
	bh=zwDa1R5hTozvkPRWD0eMYwP+MniaC6Knzv1Xuv/zVws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSbA+he0G7OYrax9FVe2/eY1mXOMJeANzHnN6Hu84Hg8aXZThc50BP7+5n7RWJkCB
	 V+LglBYUl7bgg+neNkoktPveKlVpOsfwe/VLpFYM8mbeJP3Yt7K069EjsGbt5pSaj4
	 DUFWRsuKzuRxXfmWyFT6zPm4lY06RGQwTkx7ILROx51IKYI1v4UlLMkbLVAkns9S/0
	 4lpeBoMuf2EC5iT4ziqBwPyU7Rrkg8p+qwL+lWK9C2IgTJ/+CZjSz8OA5m4tIoNMxL
	 XEbkizXDiykvLs/tCoAHVE6hoMlh3xiiwHEtxN32p9Nk23EiknnUoNqQ4A5/LPp8Cf
	 4oA1UYAYAKidQ==
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
Subject: [RFC PATCH v2 05/13] rootns: Add rootns_wait() system call
Date: Wed, 18 Nov 2026 01:13:44 +0200
Message-ID: <20261117231352.3816603-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6BF44000A
X-Rspam-User: 
X-Stat-Signature: h5crzsnoi19jkbg5uzrzhzyq5saphyny
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794957270-303129
X-HE-Meta: U2FsdGVkX1/RMprWGR+k2miQVjqFKT3SVUN2DwPG8zKlY6GK1GUoiTMH+XAYAkDmf9wJiqOTqjLRISaZNiX1WzSgIg2sAdKAQpEriolgAsOlGllKWxLEcbZ+GMuEw8mE0I6FN2RPfysij6JG5EqHShJksJE/c0l7FyKuiCwkkk/7ApN5zJZ97iLUymC5wHM4IBogY79rOPq9TAwu7XQD8f5tN3VJ3ZGLb09X6XSLnIxXS8MD81w5tbnYZlYg7z/ZzkB9m9fuMDxzgdLgDmXU1miqcEcQ6wDVyHWPUfHGh1kVaUL8NhXDjNHmgdCD3p5JCz5lb/eon0Zr1ikPZCCfcMm7dXCswdvxIp/GB0PNbLcHBuSdEQT9BhqyONYjmSUS+huTwF6H7dwDTUaU04A/J8eBpIYpvcIJ87X3o/vaCS3jwaUdKvG4a4ofcSfJKKwOxTNCuKIIGP0ywoQd9vQhnIqK+cwLUnr7PsO+s78nJOd5WmaWSCBJlZIvbsAYD/r+Hb0EpYZ/VbNSFBHso9QlbaXfS6vR8svzmy7EScrmX7Au9RFSIl4ybzLAaR1nBEJf35pJ7fGYrKLbF1+nvIpWHufcg6empid7OD3acV3sK0K4mB32PtBuwv/CWx8epw0hWAKyrOHPwV2WocAHVi2G4dBFNJKYSeC0TqFsDSpIms8h3ojAG2tdw+VTNu2DfcyBIlkQgIl0c0hHFDqq2jYRax0Pbw+J5gnceiSMu8ozGwZB7oeAzJNiF3foBlMkj852yTAJKgAI0xfm47zAwF73Wm+uwKCQ+JNsMY/O6HYYWh2GEzP3lkWsyTbiSTmzU0aecbgQz6c5oEazyOIhLZEg5AHxBmuPFdp/bLzAiiat+kySRGAeRV/mf1+te0tFic+gk2fb2zFQDVE0zhvNyOUbCFHHT0G12v1Zh4awL0xzIVXwKhUSiDNTqcXs4ie175bOPV7Ht4BJR0lm+b4wQjA
 8T2Bcj8V
 OlycQLLbK+udvxTivXbI5/NHuHK3dSdM2FGbAJS5eBfUsiKvyqNbk3RPqMpnBWh3+8IA5Li0GERn1YlHpzWbeCi0O6Rx2pElvVZfrsln8GtF2VFxgAGDd1a+VAYc/zaKwmffMWN+sYKouxTzKsboEO1Yk7HbrCEZHMHYln1ZZ8LFdRgdjr0Ka3kK62+AjXXwm5DRfPOXWU4/O+6cwZij1b85Ko1qCHMArSzSPdnwGBLPXLxjYzLb/vCpguhslPuEse6AJO97NvI+/QCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wait4() and waitid() only allow a parent or subreaper to collect exit
status, so an external manager holding a rootns file descriptor cannot
wait on a rootns init process forked by another process or observe exit
status multiple times across observers.

Add the rootns_wait() system call and its compat entry point to wait on
a rootns file descriptor until its init thread group exits and report
the recorded wait status and rusage. Return the init TGID translated
into the caller's active PID namespace, 0 for WNOHANG while still
running, or -ECHILD when the PID is not visible to the caller.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/compat.h   |   4 ++
 include/linux/syscalls.h |   2 +
 kernel/rootns.c          | 105 +++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |   2 +
 4 files changed, 113 insertions(+)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index ad37ca617e65..3a9ac9dbb24c 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -779,6 +779,10 @@ asmlinkage long compat_sys_recvmmsg_time32(int fd, struct compat_mmsghdr __user
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
 				 compat_uint_t __user *stat_addr, int options,
 				 struct compat_rusage __user *ru);
+asmlinkage long compat_sys_rootns_wait(int rootnsfd,
+				       compat_int_t __user *status,
+				       unsigned int options,
+				       struct compat_rusage __user *ru);
 asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 					    int, const char __user *);
 asmlinkage long compat_sys_open_by_handle_at(int mountdirfd,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 272d54bddbe2..60e9c4ff71e7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1007,6 +1007,8 @@ asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
 asmlinkage long sys_rootns_create(unsigned int flags);
+asmlinkage long sys_rootns_wait(int rootnsfd, int __user *status,
+				unsigned int options, struct rusage __user *ru);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/rootns.c b/kernel/rootns.c
index caa810b65d0d..83ab759a31ec 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -5,6 +5,8 @@
 
 #include <linux/poll.h>
 #include <linux/wait.h>
+#include <uapi/linux/wait.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/rootns.h>
@@ -284,3 +286,106 @@ SYSCALL_DEFINE1(rootns_create, unsigned int, flags)
 
 	return fd;
 }
+
+/*
+ * Wait for rootns init to exit and report results for the caller.
+ *
+ * Returns caller-visible init TGID on success, 0 for WNOHANG when still
+ * running, and -ECHILD when init pid is not visible in caller pidns.
+ */
+static long rootns_wait_common(int rootnsfd, unsigned int options,
+			       int *status, struct rusage *ru)
+{
+	CLASS(fd, f)(rootnsfd);
+	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	struct rootns *rootns;
+	long ret;
+
+	if (fd_empty(f))
+		return -EBADF;
+	if (!is_rootns_file(fd_file(f)) || (options & ~WNOHANG))
+		return -EINVAL;
+
+	rootns = fd_file(f)->private_data;
+	if (!(options & WNOHANG)) {
+		ret = wait_event_killable(rootns->waitq,
+					  READ_ONCE(rootns->state) == ROOTNS_DEAD);
+		if (ret)
+			return ret;
+	}
+
+	scoped_guard(spinlock, &rootns->lock) {
+		if (rootns->state != ROOTNS_DEAD)
+			return 0;
+		if (!rootns->init_pid)
+			return -ECHILD;
+		ret = pid_nr_ns(rootns->init_pid, pid_ns);
+		if (ret <= 0)
+			return -ECHILD;
+		if (status)
+			*status = rootns->exit_code;
+		if (ru)
+			*ru = rootns->rusage;
+	}
+
+	return ret;
+}
+
+/**
+ * sys_rootns_wait - Wait for root namespace termination and collect init status
+ * @rootnsfd: Root namespace control file descriptor
+ * @status: Optional user pointer to receive wait status of init
+ * @options: Wait options (0 or %WNOHANG)
+ * @ru: Optional user pointer to receive resource usage of init
+ *
+ * Wait killably (unless %WNOHANG is set in @options) until @rootnsfd reaches
+ * %ROOTNS_DEAD, then copy out the recorded exit status and resource usage of
+ * the rootns init thread group.
+ *
+ * Return: Caller-visible init TGID on success, 0 if %WNOHANG is set and the
+ * rootns has not terminated, %-ECHILD if init was never started or is not
+ * visible in the caller's active PID namespace, or negative error code.
+ */
+SYSCALL_DEFINE4(rootns_wait, int, rootnsfd, int __user *, status,
+		unsigned int, options, struct rusage __user *, ru)
+{
+	int code;
+	long ret;
+	struct rusage rusage;
+
+	ret = rootns_wait_common(rootnsfd, options,
+				 status ? &code : NULL,
+				 ru ? &rusage : NULL);
+	if (ret <= 0)
+		return ret;
+
+	if (status && put_user(code, status))
+		return -EFAULT;
+	if (ru && copy_to_user(ru, &rusage, sizeof(rusage)))
+		return -EFAULT;
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
+		       compat_int_t __user *, status,
+		       unsigned int, options,
+		       struct compat_rusage __user *, ru)
+{
+	int code;
+	long ret;
+	struct rusage rusage;
+
+	ret = rootns_wait_common(rootnsfd, options,
+				 status ? &code : NULL,
+				 ru ? &rusage : NULL);
+	if (ret <= 0)
+		return ret;
+
+	if (status && put_user(code, status))
+		return -EFAULT;
+	if (ru && put_compat_rusage(&rusage, ru))
+		return -EFAULT;
+	return ret;
+}
+#endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 4a6c4337cc74..f9918d38107b 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -401,3 +401,5 @@ COND_SYSCALL(uprobe);
 
 /* kernel/rootns.c */
 COND_SYSCALL(rootns_create);
+COND_SYSCALL(rootns_wait);
+COND_SYSCALL_COMPAT(rootns_wait);
-- 
2.47.3


