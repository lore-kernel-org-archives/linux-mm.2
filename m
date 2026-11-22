Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6678F606A69B
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=czFAln2I
Received: by kanga.kvack.org (Postfix)
	id 258D36B05BF; Sun, 22 Nov 2026 14:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209A96B05C0; Sun, 22 Nov 2026 14:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C4A6B05C1; Sun, 22 Nov 2026 14:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5E856B05BF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDB6FA0789
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:45 +0000 (UTC)
X-FDA: 85463762370.03.DCFEDDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1300A2000D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=czFAln2I;
	spf=pass (imf03.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376204;
	b=5UZ3VZBK5zRLICMKcsXoxGricN3rW8oexlgLB2Ii+9NGhmucz2tLpgMVXv2GttcZjbUiFh
	7U1PX0fXsZ8ZkI1TG3lqnM3SakgVW82HIrCQAiz6ds5d3GiNvXv3/xkGrAItSKuPmeYhkf
	YZPjlxnneAQ5KyBc3o6hl6HgXL9JE2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjAX6Mgusa/02dTL9k5B5iNWMUDytzyYEuLarDCWpNc=;
	b=Lrj5ALi0ZLBSJunPwp7zBUq8DLUlsJerOgc4C3hIMQS5fBrfOV1ftoaiE9LDO8ayGe/Wuw
	md0gW55decZQMNWRXSIIbGyymfysQyXd7KasdpyWC797yDhaynbz/L+uGyaYpg/Z7HWXxI
	nI2uamlNNz82lh8PlyoIbOvPJJCcBW8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=czFAln2I;
	spf=pass (imf03.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 602B740740;
	Sun, 22 Nov 2026 19:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8C2F81F000D4;
	Sun, 22 Nov 2026 19:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376203;
	bh=IjAX6Mgusa/02dTL9k5B5iNWMUDytzyYEuLarDCWpNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czFAln2I6+sZq5DeFOwio4VktCbvoePYK6YNR+jqX5L7t1kVE1E6i4UOoC/+6YODO
	 As9Q2tdND2gTuJbgeUqygX+MOX158TyJEEyEO9tX6+1iLSif2X8rebKCba0J2MRXkA
	 hyV2Lp/6hTGUgmVrRz6OhP36LXJKHLFLd33LCxox+NfXtTjjBI2BBq1JERLBLnFhE+
	 B0V0aS/b1TK8XaRsnTnugpynFGEewuW9jXjC3mCfE+JYajLi93UElxeRhmK7auNl44
	 AyWflxSKkh4/Fqv+9i1D17R6n0QfmX+jFtO+uNeGSvJnVNXeM+YBDHEFBtAFoB05G9
	 eRtvVy4l0DpeQ==
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
Subject: [RFC PATCH v7 11/26] userland: Track init lifecycle via copy_process() and pid_namespace
Date: Sun, 22 Nov 2026 21:35:24 +0200
Message-ID: <20261122193539.3334213-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 1300A2000D
X-Stat-Signature: csbf4g5urq7s7i5qbsz64qepjczsrpzo
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795376203-573393
X-HE-Meta: U2FsdGVkX1/LXT7+duE9S8iorSN50gTVVoBLpvWVYnuVVouY3QWZFd+eWI7//0Ce/gohU9KLNro8WsT2xdDWoA4RqAEbYhUXKKiYQKFhc8lwbN6+PORAqQqaYwkEU27cJdeEoM438SrCTHugWILbgBKaPV3cGQ/2SLcFRcGwHBlTlR1c5XiCUQoC0PPM8uM2nzAF2G52H8Jxszs3M318n0NM9yvUTC2xtHCOgdholo7byONSYV4axTW4rz4MkmEHO9r+AlkEZ6sUwxjlbZZec3lpfPKTlY65VhJI0fAtfYh7OoMfC986DVbMelmnAdGWm3c7q18eXtrBCMY7Sw4q3xhMMmjqZ2qmi2OGNQBkb92ZDuNRbbPeKFlkltwXQjsEKJtFoIqWFP4u4KFCQ3xlVwlPtNBmjIBG/L8tzlf9T/yxH88gmaZY5OAc4ThcO32D8npWWwREMZVTtKmjghjLlAzE9OTzehbQgeVdfhxXhiRbmK9rnuMahqcF0aRRFAod4Gboh1+jIvjhaCRryyY01BdcuTzvWW9+bPN4rXMLma0rHsQMWkEEN3JaqbOXCWb1zbMHW42sd9IgJUKYTZxFgZBiTqjJf3zw47LKnoVHmf6Fx+qDEyJjt/VFBOpWnxPFwod9cYZcgqtwfXVaR1H/AckBqQokeBVhkdKb3qeAQc0YEl3G9xwdZ51p+e3bRWADA0hhvQq+GjOFTc+rcuw7f5sTODel9VMzNb1hQfwkuAJTaJuTEtbUCcmQ3OWspXhTv5I0LpD5qUEAHJP4mDXx/+LK2CcGODLAcb+nOAiet4FuAOemHhSJGJIQNAk80U0uwtk6N3bDgr+T7v9IQnobx8Xj6jJ+pfzG5UQcbTb6IjPadfKYezsUqRZhSFTWj98J3lomwwFGPbkXlRPamtZ04Elh9T4IBsuH4Geeg/jvXMZA6n71pOx1S/nGqAZGFmY1n9fHlAzZxkLUj6PidvN
 DPCDZQ4R
 lf0Q0cOc9TeLz4Qg6rJFRfN+mkrSL6SwpMuvEi2mOJbcCGREvGuw/k9YnhULoh6Z8imD6aI3HmVt4z6+nQDq5gJ317w/Xinp0XWOxnC+ANNILG6Oe3IVsU3YA+XYE8L4ScwJLzh81zPr91VSaWctZmhqSDWFwR0b8sS1H9EiaxG82uvQ17zn8sIag7GBSC1CWdwjZ/Z7ohsUBzT0eY5nvJFHDNvHKhJdp0VYKC5FgmX5ghy0GVEIf785oNPwFUfK++oqwyiA7vG0ArwDPpuUgNQJaMQgR+5O1dCybmkfYYsDx3+pTugKgKPMc3IqJ75kXhBZ8HIVrvNjnFyu7SEMgtaXiXvrSpqNn477YQyZuMExGFRChVP2pNo28pRzGVUPcZJwmYUDSQvK4aGilaEjfQJtw0sDo891uZVR40d34QG5HPOBH/G/Lb+oyH3b03ENT2NsQbaLNmkaHfS46W8AIfY7YxUxpDisMNozcLUEdX0cmSVrv0gQNy6JNyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A userland needs to record its init thread group's PID when bootstrapped
and capture its exit status and UID once all processes in the userland
have terminated, without serializing normal fork() and exit() paths
inside the userland.

Commit the bootstrap child reaper and bind pid_ns->userland in
userland_copy() after copy_process() attaches PIDs and drops
tasklist_lock, and invoke userland_exit() from zap_pid_ns_processes()
after the userland's PID namespace has killed and reaped all member
tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/userland.h      | 17 ++++++++++++++
 kernel/fork.c                 |  4 ++++
 kernel/pid_namespace.c        |  2 ++
 kernel/userland.c             | 43 +++++++++++++++++++++++++++++++++++
 5 files changed, 70 insertions(+)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b20baaa7e62b..ef703a3b8ed5 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,6 +15,7 @@
 #define MAX_PID_NS_LEVEL 32
 
 struct fs_pin;
+struct userland;
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 /* modes for vm.memfd_noexec sysctl */
@@ -45,6 +46,9 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	int reboot;	/* group exit code if this pidns was rebooted */
+#ifdef CONFIG_USERLAND
+	struct userland *userland;
+#endif
 	struct ns_common ns;
 	struct work_struct	work;
 } __randomize_layout;
diff --git a/include/linux/userland.h b/include/linux/userland.h
index 9b9fefed63ac..a92709957529 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -9,11 +9,14 @@
 
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
+#include <linux/uidgid.h>
 #include <linux/wait.h>
 
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
+struct task_struct;
 struct user_namespace;
 
 /**
@@ -57,6 +60,7 @@ struct userland {
 	struct user_namespace	*user_ns;
 	struct nsproxy		*ns;
 	struct pid		*init_pid;
+	kuid_t			init_uid;
 	spinlock_t		lock;		/* Guards userland lifecycle state */
 	wait_queue_head_t	waitq;
 	unsigned int		flags;
@@ -66,6 +70,9 @@ struct userland {
 #ifdef CONFIG_USERLAND
 void userland_put(struct userland *c);
 bool userland_is_file(struct file *file);
+void userland_copy(struct task_struct *tsk, struct pid *pid,
+		   struct userland *userland);
+void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -75,6 +82,16 @@ static inline bool userland_is_file(struct file *file)
 {
 	return false;
 }
+
+static inline void userland_copy(struct task_struct *tsk, struct pid *pid,
+				 struct userland *userland)
+{
+}
+
+static inline void userland_exit(struct pid_namespace *pid_ns,
+				 struct task_struct *tsk)
+{
+}
 #endif /* CONFIG_USERLAND */
 
 #endif /* _LINUX_USERLAND_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..d87ab7cbad5e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -83,6 +83,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_event.h>
+#include <linux/userland.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
@@ -2584,6 +2585,9 @@ __latent_entropy struct task_struct *copy_process(
 	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
 
+	if (likely(p->pid) && thread_group_leader(p))
+		userland_copy(p, pid, NULL);
+
 	if (pidfile)
 		fd_install(pidfd, pidfile);
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 127a5fd23e70..70606d9c5b52 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/idr.h>
 #include <linux/nstree.h>
+#include <linux/userland.h>
 #include <uapi/linux/wait.h>
 #include "pid_sysctl.h"
 
@@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		current->signal->group_exit_code = pid_ns->reboot;
 
 	acct_exit_ns(pid_ns);
+	userland_exit(pid_ns, me);
 	return;
 }
 
diff --git a/kernel/userland.c b/kernel/userland.c
index 7be0c4b5385b..44a1976f97c2 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -92,3 +92,46 @@ bool userland_is_file(struct file *file)
 {
 	return file->f_op == &userland_fops;
 }
+
+void userland_copy(struct task_struct *tsk, struct pid *pid, struct userland *c)
+{
+	if (likely(!c || !is_child_reaper(pid)))
+		return;
+
+	scoped_guard(spinlock, &c->lock) {
+		if (c->state != USERLAND_FORKING)
+			return;
+		refcount_inc(&c->usage);
+		ns_of_pid(pid)->userland = c;
+		WRITE_ONCE(c->init_pid, get_pid(pid));
+		WRITE_ONCE(c->state, USERLAND_RUNNING);
+	}
+}
+
+void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk)
+{
+	struct userland *c = pid_ns->userland;
+	struct task_struct *leader;
+	kuid_t uid;
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	rcu_read_lock();
+	uid = task_uid(leader);
+	rcu_read_unlock();
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		c->init_uid = uid;
+		WRITE_ONCE(c->state, USERLAND_DEAD);
+	}
+
+	pid_ns->userland = NULL;
+	__wake_up(&c->waitq, TASK_NORMAL, 0, poll_to_key(EPOLLHUP));
+	userland_put(c);
+}
-- 
2.47.3


