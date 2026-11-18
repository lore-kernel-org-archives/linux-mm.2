Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6584607D6AB
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YRupV7wg
Received: by kanga.kvack.org (Postfix)
	id 8DE7A6B05BF; Wed, 18 Nov 2026 14:36:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88FB76B05C1; Wed, 18 Nov 2026 14:36:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757976B05C2; Wed, 18 Nov 2026 14:36:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 438F96B05BF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69CC2A03AD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:11 +0000 (UTC)
X-FDA: 85449245742.24.A19E4E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id ABAA814000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YRupV7wg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/iku2gUgDbopkmZntaMYkLDbnHr9sW3CFLA+QZG53U=;
	b=Eimil3KA+kVP945G+w/wQ/yGHfkS107DibITO7sO+eiQbZj1eq5PQoxid5iPwxWAx78uVR
	W5v25dEEZbAPYFlT8doHhJAgXD3sEBZWS4U5UvAPRaHQndDvD00oHmU6v4vJA8Ew4i6Kne
	9+X8I4+vfGhcHH33NkLytq1SsB/YzYA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YRupV7wg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030569;
	b=qpPUYqPi5m1Bd8pLWvXkphMalDQrDY/Wqqezmee8ycLc3/2xwJAuCBImdCX0EPWwfqse1H
	yf/09PjfVTGHQzO8tVc0wjyVdoeM8jO35QFc7ccuYD8Iur2ZvVrNSBRTxuVF+lXpBL5Xim
	MbSYKvhb3zEAtg6AZj2ytJhRTq05tBs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id D9485412A4;
	Wed, 18 Nov 2026 19:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EB7EE1F000CE;
	Wed, 18 Nov 2026 19:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030568;
	bh=9/iku2gUgDbopkmZntaMYkLDbnHr9sW3CFLA+QZG53U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRupV7wg/TbkMyMRuUVn5nh9LgIOAdC6pN3zR9rNOBCucnHbprR1RCYsgWNziqfXY
	 ZBQSqHbz0ljg+Xu5yC2/d07b3fgZBTHtNuYVbAorNzMFRxmUXUxloMf0G9sJ3ia06X
	 KdPw3WQGje7O2QlAYEcAiyB8tIPnGh+4Bs4naSrM4sE6Fh1qi68+2NokZnOK3awtCQ
	 wgGpgoxA0Q+FQvJkMvBv3owXzzBIO77+8ZZlyYw0zJGOAvOsZ1XraBcByUHm4ROV2h
	 yY/M6FQIwG4a6EA/zDSgY/pqy4y7dLb9jY1vJ7Bv1F24oQOhTtrhCZDUNol1X33TYl
	 XOH9GtLB0Oyhg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 05/13] rootns: Add rootns_wait() system call
Date: Wed, 18 Nov 2026 21:35:31 +0200
Message-ID: <20261118193539.240065-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ABAA814000A
X-Rspam-User: 
X-Stat-Signature: 79n79z1h9nzt135jykuicfxhzah6516z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795030569-3201
X-HE-Meta: U2FsdGVkX199NS1YaeIWXvsTbJDtSB9pxHkPDELso2U9gGI9mm5KyDmBd45h/ZpK9yfrLx0gxycU4NaNSbDTLWK/zrVrJzyqaXbw/IiVjHk65C8aXrDb2BZVPBev/7IU6gfcAa+bEZ2lu0rSlHFxDfEEzXwDmpm1NmL44DW1DcqBoH2PX96x08SrmvEJf/MVV29qVLnZzSBS+J/PU6hUunMiAlau4LbMyTnH8BXGjJH0ZihzT8FOczZOcyQruG189N8iGjoBmdezQNPYzG+iSkRAIlCdkmXvsdInx8oVobfm/0HHrDhXJPXgYTxRxtjq5LR67AaSmT8WWTBWACaZNacaF0zUsG6xWrNk0jHza41OiHN9kYdMI1nLsTeDPGWHCMao+VoH4ZUv5ogKLwmrIdXKv1IqVa2W3+ulgT6Jv1J3F1jT9kVksqW0n1nU/4p2Aamb1iz14nrqz/C7fwTQ9E7suDPwm8YF4ZUAsXbhLRwDXzWhHURt0mTAb78Q9ItwPX2146dwrCnkMT045JK3vIFlzKoQN8piqBbPHWCKjGLRwUb4k5kTLfxV9nKIu/UADGSl3WJu5tWLgn5XiChF8Edgr3SwNrNwAH/AuQFpFFpB+ZziRv73ikYQeoASEyJAH6/38T/tnJC3t4SVnCnHfZoSF2fTcrSG4kAH9lCiw4HgAvwJN0dehwqMpWkOSjD5dhQt9hqYmeviWdd55PpHfu7yrLpNm3zCHFBERcMMajLETNkiake9dK7ks2TABw8A+6QOnJ57OzzUJ/LIcF7gnqOTBnlP1GS4pO3BCTxPDljZtmaK1WAqak1R6rE5uOwAMSv8gL2avgmfZ9ez1rHx8uhoEXOv5JAGctdgr5ppQBoctz8Get/SB6zAo3PhtfPjv01UpKnrXxppud7eABbjGs4t3v4oOY9gj0LAGxg78kFkusCkXgQGYO48yH1d0Vfoa8rIZMB0V+LmvfZcwt3
 GmNG5qYc
 HM057RFeb0ZiE+Vu1OwJynfX90GWIwWzR/QLRnTv05RGq0DtTv+2QRGx/76m00WyYG8nn3q1hUpTE0ZBfVCY9VMnqtHDYQkSSmMHziR04F1AKLgiLu8fczZRPtTfaq95XoLbKiJEK3I9CJEFptHP1t1NB93igl7+mBv1w9LxExM6+xgndmgrgiU1u/lSZoRjTX9oWe7tcktZjtJsTyqWb4pL0ckMMS5oAu1KgYa68FnbtvF4uCsRbZ72UBDRPoBs/GJrOv8YhZ6bhmjQ=
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
 kernel/rootns.c          | 103 +++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |   2 +
 4 files changed, 111 insertions(+)

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
index c420e36af603..5582ff010ca5 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -305,3 +305,106 @@ SYSCALL_DEFINE1(rootns_create, unsigned int, flags)
 
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


