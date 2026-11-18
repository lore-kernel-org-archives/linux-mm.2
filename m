Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1A560A3803
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a2mNj0hN
Received: by kanga.kvack.org (Postfix)
	id DE80F6B05C1; Wed, 18 Nov 2026 14:36:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC04F6B05C2; Wed, 18 Nov 2026 14:36:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5FF16B05C3; Wed, 18 Nov 2026 14:36:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE436B05C1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9F2440692
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:15 +0000 (UTC)
X-FDA: 85449245910.13.35DB8D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2F36A100008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2mNj0hN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yaA3ERKl4qIEc5biEQv6iu7eXMjtpeIqoYNmqvuQLqw=;
	b=S0Q2FT96Jlbdi02YVo3LS8lqWGcy8BItYcSfZPKYZPhxPfJ4rVmD0NPY85BTVj8oyLZ6TZ
	WLmjhmY4X5s0wH8AECX04qfU6/BbQYHFrQwkZwS0x3XyQf1uGI1u1fjZcVvd1FjnV00YKs
	ALA1KGUwLpFs+0mYgwYFJ+XnQ5krUbY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2mNj0hN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030574;
	b=mcBbRuut69SHrFih77rYkPbgUyRsFuO5a9pY38GyTxTdhExnXyAUR3cEGNe69YzJJRbtmC
	/hbd0s3Oh6SnnVNHfjqWQ+2H7+I82rzXCAULpmU6ik9lIjR5OtbK4195EIHTz2xg4/ng/2
	iA1W6iDov41MieqCUq2JhID5pZXK5gA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id E1A3563973;
	Wed, 18 Nov 2026 19:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E82401F000C4;
	Wed, 18 Nov 2026 19:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030572;
	bh=yaA3ERKl4qIEc5biEQv6iu7eXMjtpeIqoYNmqvuQLqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2mNj0hNjg6sky+s8cpxmwPfl8llMXFT9DIOdQC0BES4dK4PITy4ph4FlC/J/qWgo
	 JBIN1np7dCzY1ashyhWLAiHNc8KP6eJaKabfMC3ItFJGWL5b67ChpvMKmdrtvfjQ+5
	 N+Gedj72owic4tpf+51aUCpzsfq5LqCqQT3QUez0LDshPO9tH3mszG1FHWj0dz1O1b
	 VH11s6YXVwECM3Jw1xKXnK5uZZK3juehV4PqfcSxvIRBM9fNdFjD8pyBl50J8wWSwC
	 i6coJCwGDh6wVMFqsH4OGw3M/r6f7Jr65737mZjv/8G2gslCGV0KE3c43dCJCfzcAa
	 Rr42I3tbibb6Q==
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
Subject: [RFC PATCH v3 06/13] rootns: Add rootns_kill() system call
Date: Wed, 18 Nov 2026 21:35:32 +0200
Message-ID: <20261118193539.240065-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2F36A100008
X-Stat-Signature: an76uq5qswiteqzi85bxkb7iodnqyyps
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795030573-311954
X-HE-Meta: U2FsdGVkX18mvZV2OezUQu1gtOe43A23VwKYVZ0EBqsHj9Kx+x3WFBfEatVTVa626grNGGZ+4B+afxKkhR6xRmryet5KaCdfSiRV054Uxiaif/tua3TgmZLHBvEGf971D4FiSKr8YPnkFIpg5EcJ6ncye0fCqdQsIpNn42/CUvPQAk38MywqxiwdxMocVx+z+4IPZ8wTK8fqf5BwuYf8dbfhz7yPYx55ATdrKyQuigZfg671PQTjLpTkPapG3aihda1HEMpS+5IztpIwsLEL0aaS7lTlIxAnXqFvCDylNUIWTw905iVUgxaKLgfVdpVP3OZklumMLh9lPVJDxJ3UpK5vRtC7dTc7UP//ysBN3HVYzCFtqJBMBWvT3zWwHlwTJreROOgI5uKKP5OWE2xx1Vq2L8AJlTNsbM/aBGMLdEcnMjIhy8CjsU+5SIX1Yr/Yss0gwU0rL7JK+OIfFkExwsl3bZ5EaAieZ4fMN+nKex3sDMINRVHx/tQN5DZijkKruiA5w+qiBg+TfPUMslhng00fpqTVsEdWDPjh+TmQfY8zyKvDtu8egEPQwM3yJ2OwqFrmeLysGu2GtW4KGpsVJjGBwlZ8FY6nUVgzNweNT40JxOoe7vfqtzZ83AJkXFqesHIc7rzxWAkYoV4dmmEmHY4p6ai4FiMM4TxRzVAukYIGAnLrmJR+8Ukmn0MyXuV+JiufatR5dNIcWhtCJ4szOPzF4VBq9C743QBh2sR5kJr4DbxLvd3t4Kltw5sANCBo95ICvbqvyXJ0jyQ4T71Iem7AxcAbfcf2ZXfYJ58KTvQYBC1ybuUndUxCd93UI3lz+QcE12JCzl0ArKNrELSaIrO0P8eT+g0VVnBRTnx5x6g/VTh3BM8mppLp6R5dLhMan5OAlun+KbhQljNyE2NRK9QU+6sqpl6SyYAH0D0nlyTwtawhrs1zwhw7eAxt4qk48KlEP7sl/J8HmVVB0Ac
 CSqoM3J4
 Frxdfm2T8KokJDHT4cgBeJ15DZ7hPrzglGE4iqbJH94q9M/zB3XtCasA/y4AoSJKUI7P4p2Oyxj6JjPAk3K3IU5ztBcWLxxsN9kg4BTUkz5OOxFjkiGQDoXa2e5JuerxuWOArRpF5N0KahTkskvvL/RUSwf20eCec0zbcuyDeD7xSQqrcp+NahYHJgOsTqQ2nksm+umm4tFfgrJRTyuwJBjdzF8My82eFe+1U7DaFdwvMii0YGmDxtTgD/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signaling every process inside a container from userspace via /proc is
racy against concurrent fork() calls.

Add the rootns_kill() system call to require an ancestor active PID
namespace, walk the root namespace's PID namespace IDR under
tasklist_lock, and deliver a validated signal once to each thread group
including in-flight forks, aggregating per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h |  1 +
 kernel/rootns.c          | 71 ++++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |  1 +
 3 files changed, 73 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 60e9c4ff71e7..a854d248c8a3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1009,6 +1009,7 @@ asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flag
 asmlinkage long sys_rootns_create(unsigned int flags);
 asmlinkage long sys_rootns_wait(int rootnsfd, int __user *status,
 				unsigned int options, struct rusage __user *ru);
+asmlinkage long sys_rootns_kill(int rootnsfd, int sig);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 5582ff010ca5..32bb8ef5ed58 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -408,3 +408,74 @@ COMPAT_SYSCALL_DEFINE4(rootns_wait, int, rootnsfd,
 	return ret;
 }
 #endif
+
+static int rootns_kill_members(struct rootns *rootns, int sig)
+{
+	struct pid_namespace *pid_ns = rootns->ns->pid_ns_for_children;
+	bool any_success = false;
+	bool any_other = false;
+	bool any_perm = false;
+	int other_err = 0;
+	struct pid *pid;
+	int nr;
+
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
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
+/**
+ * sys_rootns_kill - Send a signal to all thread groups in a root namespace
+ * @rootnsfd: Root namespace control file descriptor
+ * @sig: Signal number to deliver (or 0 for permission check)
+ *
+ * Walk the target root namespace's PID namespace IDR under ``tasklist_lock``
+ * and deliver @sig once to each member thread group.
+ *
+ * Return: 0 if at least one thread group was signaled, %-EXDEV if the caller's
+ * active PID namespace is not an ancestor, %-ESRCH if the rootns is not
+ * running or has no members, or negative error code on failure.
+ */
+SYSCALL_DEFINE2(rootns_kill, int, rootnsfd, int, sig)
+{
+	CLASS(fd, f)(rootnsfd);
+
+	if (fd_empty(f))
+		return -EBADF;
+	if (!is_rootns_file(fd_file(f)) || !valid_signal(sig))
+		return -EINVAL;
+
+	return rootns_kill_members(fd_file(f)->private_data, sig);
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index f9918d38107b..fba44c49ddbb 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -403,3 +403,4 @@ COND_SYSCALL(uprobe);
 COND_SYSCALL(rootns_create);
 COND_SYSCALL(rootns_wait);
 COND_SYSCALL_COMPAT(rootns_wait);
+COND_SYSCALL(rootns_kill);
-- 
2.47.3


