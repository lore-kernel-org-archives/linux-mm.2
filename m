Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61877606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FgzGRfYK
Received: by kanga.kvack.org (Postfix)
	id 146876B05C0; Sat, 21 Nov 2026 20:19:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E8A6B05C1; Sat, 21 Nov 2026 20:19:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034C66B05C2; Sat, 21 Nov 2026 20:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29C16B05C0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BC7B405D9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:04 +0000 (UTC)
X-FDA: 85460996208.01.3F84183
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BF565A0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FgzGRfYK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310342;
	b=vihWz1b68H2FmBuSZu9Z1KKgJ9DRJRLPjKl4ijbVevGFpmmPmeGZmlHuKZSxv6G4kbWoov
	2XyOnI0a4ygC6jTCzldYKAKeYu+XLwK23PhtdkW0xG6bmfInzcMqP2dG0vj1zFOvyMa4vF
	ALt0lyhMtmN0dn9oShhhYPJsSq3K0qA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAN/hIhGbLif51uDHJWEreVc/FgOTWv2rNXCLUKagZ8=;
	b=FIZgrrn8pwN1ODjKNvZvaXe6vBVoL2dfkuf1sxndDoFPQmJ3QI8jXa7vEJXIl+mxy4ZhAZ
	7MvFZ/oaXeN0714Bn8BeELgCiC6W9AWiltyjyGQs2pSlphGFWbj6VPHeOEIigXGNaSBMrU
	oxk1kkryy3TP1C0I9SDIYSRfORe+mrg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FgzGRfYK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 151B6402F8;
	Sun, 22 Nov 2026 01:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 45E7A1F000D8;
	Sun, 22 Nov 2026 01:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310342;
	bh=YAN/hIhGbLif51uDHJWEreVc/FgOTWv2rNXCLUKagZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgzGRfYKw+DvTaxI/TJkS3XWpgcgNwC1efsrf0owiy14/cSZNn12put4iBUSIKCrs
	 zZhnP7PNqOXEbq04gIYPVPLQiwTJEmhJpNK+SdBh2Fj3seSPoVDt6Hr0ig+LrYauJI
	 L3XdKbIZGT2ApiLhefbVuRArglqkOp3aY2Tlp1hc7lxot7it4c2aJhUvdbW3yTWFIy
	 WgxivBKqGTBb3cz/uCx/mH3SkN5FYjrtvDK5ZFeuDVbYbJSXsdqkQTOJoobW0kaT00
	 h5pi07pfKUNoB6LMsYlgyYROiHMdkaxjiOKePjU3ad5pi3h9uqnpfP0cd6uJQChr/0
	 eeQLvrTw8x/tQ==
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
Subject: [RFC PATCH v6 11/26] userland: Track init lifecycle via copy_process() and pid_namespace
Date: Sun, 22 Nov 2026 03:17:54 +0200
Message-ID: <20261122011809.2667684-12-jarkko@kernel.org>
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
X-Rspamd-Queue-Id: BF565A0004
X-Stat-Signature: 93egqtg7fbss7ax443jdxy63d655tjew
X-HE-Tag: 1795310342-884622
X-HE-Meta: U2FsdGVkX1/UEYqRjeHYSmiTkq9Pbzv+ZMkEswZF8uODBArPvYl3uyR7ePOo1/lznAgT3Z5EMZIy9rMAU4lOlVW8iPeHSqZ35ci8Th9e2m5aOOEFTR5rk95uWbWHxucPJtCWzApq8MasfLUP1ymD2guOGHJ7D9WcZZH4jtmiUyUcfkQ5ZF1IKuXNaHqDHhVRm1Od8cTrly2hJgyt6g3wLkJEFtmVOL4yKWjuorfVIA3JPzdnghjabQRw+jc1wG/R+UtdXLmuv3JyY8gSAwPe3RN7pn8U5KDVLivmNsUEKnrTjLal9OZfKuxZMCbcB2lU1QZ5nKMaHq6Yhz92yhGf29B1tOqqUlm8s0ng0UtEUikTi5yeuXCEf9mBdpj11oseoKILwHZQ0/GtHYdPa26/Prwg9bFVa0mDXa9UeqaOgtK28sS0Y4MxV9Cw2FKWIk8y/y0is1WNGtpXj8YyQYqE+eik5v6qXnnCceJRAdvN+TXFS+b6xS1UqJ2s3vsyHg8wQajt1M3KXF8lA/l2g4sUJuXTXk7IAxhnLY+408G/rRDxFBeq3R7yCVbB2BRLR2HMomvhs0To0KZ6BzvJRYv8PdxaIetnJZ+fd7PFkwI/AY3S/cWXJnxCHOZm3WzEBQuKEnGnadRksUz0BUvimaMuRctCzBMfWKS4P/448fF/bVco5NIBpeFc5OfAYI5TgiByjkq+8nDesyOitxZtTaPP3e7PO8km5Aqs7lq+1NkhSd6orYXrfYZ0yU51Ccz4BV0bSkL7mgvFxFTAAGq9HFeQLH79ZIxWZx/GLMQhVdM+HD9vzUjlwqXckhJhn6UjJMCSBZA07rsL1zOucnj4VpxmGMwz6Ic2DwvA1R7fLpZ8wAH7rA9q1aqgwruuQ81F7HMFkdPJkisT2WbGIL80AxfHI8kR/tA9SPxVWZCXlMHgBcBopYU5m+P4C6Rfgko2SjtrXFyfyptIMVA9eoxcG07
 icsXO9+j
 S/t3V47o9wbx3GeFwnrLdDJ4fRqYQc4rrT6D07f9tTKPfIuZWQYgDH/MsLxNALgw0XVFPrm9ZP21jJbvIZk9WtOLdOa+fyhAxDCnOXXanJIMqKoClKcS9QO5HJqT2ZeuGl40P7ivEhalaJXMchkZFwNJkyPbxpfxoLTKJLAQfpwxdyAHaTSkFlWtpxp3iTME0QN4OoyHnsWvSOlBr9iBNB+6O9UCQPYWZON5Os/DC1GPqqLwIn9v2YU9N8yYY2ia76Y2PWn5IyRxgd37jJSKqam9ptZXPzpyplNUg/DUBw9iu0ZjxjupzlnDYG1988Xn+STGZuD1Cnk7vsH17keq7MrBmImIoYs/727noGI5Num0ewYu6+yXX8Jvffdk4zp5EN5j8z9GkX5z0hRLuQMzelIA0jtDS5Yvow2qnMY1ogP4mTE9nNX5Bw8mMiL8x+D7u3DiRsUAeHGKYTTjPyppf6kpqjd/pD4tieMPHS4UrS/b27ZQ=
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
userland_copy() after attach_pid(PIDTYPE_PID), and invoke
userland_exit() from zap_pid_ns_processes() after the userland's PID
namespace has killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/userland.h      | 17 ++++++++++++++
 kernel/fork.c                 |  3 +++
 kernel/pid_namespace.c        |  2 ++
 kernel/userland.c             | 43 +++++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+)

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
index fa8628e1b89c..ec74eed6de1d 100644
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
 
 enum userland_state {
@@ -29,6 +32,7 @@ struct userland {
 	struct user_namespace	*user_ns;
 	struct nsproxy		*ns;
 	struct pid		*init_pid;
+	kuid_t			init_uid;
 	spinlock_t		lock;		/* Guards userland lifecycle state */
 	wait_queue_head_t	waitq;
 	unsigned int		flags;
@@ -38,6 +42,9 @@ struct userland {
 #ifdef CONFIG_USERLAND
 void userland_put(struct userland *c);
 bool userland_is_file(struct file *file);
+void userland_copy(struct task_struct *tsk, struct pid *pid,
+		   struct userland *userland);
+void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -47,6 +54,16 @@ static inline bool userland_is_file(struct file *file)
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
index 5efceb8d58a7..2fceacc17e8a 100644
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
@@ -2576,6 +2577,8 @@ __latent_entropy struct task_struct *copy_process(
 					  &p->signal->thread_head);
 		}
 		attach_pid(p, PIDTYPE_PID);
+		if (thread_group_leader(p))
+			userland_copy(p, pid, NULL);
 		nr_threads++;
 	}
 	total_forks++;
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
index b339aa2103e1..e117b00cb8a2 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -85,3 +85,46 @@ bool userland_is_file(struct file *file)
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


