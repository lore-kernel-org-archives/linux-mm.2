Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182B0606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E13Saay9
Received: by kanga.kvack.org (Postfix)
	id 82E9A6B05BE; Tue, 17 Nov 2026 00:09:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DEF56B05BF; Tue, 17 Nov 2026 00:09:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658D66B05C0; Tue, 17 Nov 2026 00:09:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD2E6B05BE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C59DC0325
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:11 +0000 (UTC)
X-FDA: 85443432102.23.34854FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C0055140002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E13Saay9;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892149;
	b=hdb9BY+Fz+iSIJdWYff3ThRC7FQ1MdMsuau1/3g0GiMVtLTfp2PQHZo6VlZlPlIa4KcrV5
	xoj6ofnEZXPeJ8VVdJGpM9CZb6o81t6pOvRHBdpZHApwRpo1NB35SYaTpd6/X65MP8pA93
	qfivaF7RrjpZIbrL2BZJS1bpYuq4Gyg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E13Saay9;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/j07RVXchf3zhK6LorIENxE4Qf7U0RuxmVpxnAnY7Mw=;
	b=WJCbE0+kE7h1UVTS03wFcphufHB41xPC1tesJtPSkZwZLS+7FGlnOTjCT7/2KxlIMCJSbh
	uu1pAeqzm97iwc68oMtZGWxqWhSKWoou5CFKMW9nywE0mfnmRrbDcutxKampSQsIbQzP0P
	/L7X5eVMPdTejwq6PQbUea6yHmYRhto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 11BEC4133E;
	Tue, 17 Nov 2026 05:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 42F4B1F000C8;
	Tue, 17 Nov 2026 05:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892148;
	bh=/j07RVXchf3zhK6LorIENxE4Qf7U0RuxmVpxnAnY7Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E13Saay9ThoYFiymvEwJcCX5YkI+DCERwN9bZxoLWB5HdazaYM2s1VJ6hh4V+oxB7
	 IO0dRERPUmvs0kVHCzcJZnv4D7kC9DDwhLtQTTdrvB7t/gBVXECUn5UGQLlWwRrJk6
	 n+Fcmfoh4KpoTJ5AxaPB5ElljV9E4QjuZVprztgFSzVxSaLjn/ooZTgY0D/kos3fPf
	 HeBlYNLGNGEfRdDchqh+7FIfU66cdF3f9bPRdYBLRNPHcfOM+4QQicDkHQVTCh2REK
	 3a75eoa976apspQ1C+yWfRjr65k58xrR2n1PjYAXCK0M6tiK+dSaSiIPkU51ZgLzQ+
	 7rU2wT6wuMP7g==
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
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 05/13] rootns: Add rootns_wait() system call
Date: Tue, 17 Nov 2026 07:08:33 +0200
Message-ID: <20261117050841.3289652-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0055140002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: s4fntourqw6guc6h4jrry1xqze3tn94i
X-Rspam-User: 
X-HE-Tag: 1794892149-765270
X-HE-Meta: U2FsdGVkX1/6LvZ6HAy9VVqlnq2Z9hxCmU+/EnNZYvZsopyah9Nhfu1Pw7FQ7VHTpZpMbCmcDpLJAO6VBdt9L8BltHnFQ49gwLnN3qrxyXngaanBt+xPqy4JKACJ5P/C/jhbnAOkaohk5YqCXgFL3laAVIopEz3Wr0do3saDt11TbycMJzDjBmpC/kTWipLYok54Z6UOeTwcSPrDaseUzTsXQROICmlRtAJqcqpRJ/ktsrlU6OZbLA510GzmCweEEy4UqyWqBbaKr0PVyqL52vfYW+ujH2wmOd0xGd8l49WNpeZbPg77Oe9DYCLCdVAELbtrxWNkeNNm9q64XWP4f5gj/+WFbIXfrIXqdscM80h7jc6QBp4sEo+L0XtmfNEG/kKgpGNpZITkvHrFuBBwrkvRAzq6snE1/PWncMnsnF65a/bci3qQDaIjDpEGeZ7ivxYHNtj5i3kOhBQ3PYN9UNJ9rMqHEp1JlLrZ/jjoIQLFYRy8hsMFRW7vE6TFzCmU7UNDcvG8ewwf0LAn9a+kfoC5RQE+1cOdhfyRAuVhmn3stkxZke7ivfmrQXsue5pBr9fWLGlEBXlWizr0cTN4+B2qxRl/H3HemVL+QN3tKbU7UCKRlreOL50bRkq9F3ros3C2xy5AEiY/wXNjSnF4LbLDnStECvbHmdh2WVsrzBJQYfxiayRDbMMSYAEWh/ifXKYTu0EKF2GZNLKKf+gVuEfD7pSZ/oOETcgfnNhfh97gRgMDrk+t9RIGmMdmsP5B9FUKLCIBR5K3+2IZgjuVUTz81BA4sVaJMSN0NMKMfYaabOzLFSSz82qTVeHJAMRxJxV36r6UAGpRcifNs3v4vxA0sGilWtXYmM6iMMc9kMOioIgV+qThOlbiw85sn+z3E3BeK21B/dLcMtcXN7fB/i9QvRkuSJVqK5le3FjtkxhHpjK0pNLfWab3UgkpJDQJA/e4mXyyWTFr0EgAWNH
 WdDXW4Og
 YFZd8ZllJ3zY2xKZ5VLQspLUJIt2A6BPDvIJCpnuc1uKOcvO4V1GIYewXc5OSn8DErS+9ARpBC2uhiBOH/a96WRR0zramArxOR5VRLQcBN69MA46ulRMkdPL8UFBpXVn1pYKTys+pPN3fcUjdyv9GnmoN8LNhPjYFNVGHuXaAk6wDGRhwqO28QvLXAB3+9Lr6DO2FsTFKbaankZYokD1RgHbJaNdPiW05zoONGgr/OYd4+7OHY10wFe7uEnyALHjTAK82b82c9InPHTA=
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
index 904d75ce9d90..8a1254db69df 100644
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
@@ -285,3 +287,106 @@ SYSCALL_DEFINE1(rootns_create, unsigned int, flags)
 
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


