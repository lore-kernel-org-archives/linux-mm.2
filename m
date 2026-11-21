Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9EB460A2608
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=exg0p9Fu
Received: by kanga.kvack.org (Postfix)
	id E47E96B05C3; Fri, 20 Nov 2026 19:09:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9D26B05C4; Fri, 20 Nov 2026 19:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23806B05C5; Fri, 20 Nov 2026 19:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85D8A6B05C3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB19B1C2CEB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:48 +0000 (UTC)
X-FDA: 85457192856.12.A6D9912
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 611731A0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exg0p9Fu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219787;
	b=0+jyIfoR80jbWsSjGUv5PlCdBzS29qGDTuK3MWzkLg4BnVBoEAQczl6mxP9mU7xPF0BJkj
	2H5ys4EAZTv7RJsDLtvKdbBm7KEj1hrC5gnawAp9S+VPXopiCDhj1fD4IuJG+bbBKQ94cw
	1Ly7uS2rtNqqMNYuSM9RsFGNHw/Zi/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSFAa5q4pk8rKycfd2l1otknxN4x1Z6rfvdlMGDR0Hw=;
	b=yrfocJv+c6K/+2VW/R1d142vOtRoCpQo+2OVaGb1psLcGYKw8iKtWBNphzlEfh0IB9mcYc
	yiEv+ho9pQo2x5g9NiyHsCknW8rO8sIq3M6JRSwc+gdlJoUlwki5o5LW9b6uBsYWwdVVO5
	n8QPkyerBqD+HF1oRkM0euFdjfALCcc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exg0p9Fu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 0020962390;
	Sat, 21 Nov 2026 00:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2E03C1F000E6;
	Sat, 21 Nov 2026 00:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219786;
	bh=GSFAa5q4pk8rKycfd2l1otknxN4x1Z6rfvdlMGDR0Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exg0p9FuhSRg96Fa0UI64RNFn7ZEmCFC7qxHAngayMUiSbtTQnH76nPFzFtOAL7A7
	 zPAZ2vovIXviQ4eu51V97EakgNUc5vWOvMRXXDEkabUKRj58n+KVe4FA1AcoNBXtpW
	 HS5u7uspHEPetwIAqadQoDvIL8M1dqh7pieUdprMOYDKGWqpuAGTQ+PKcwXIoboaTJ
	 JnoorEnBPLvkPlx9FqqIKfeVf2Fsu9uxfM+eJmOLf+ZFT5kDPBg7tS+jOmAPShcwyl
	 oReAllMY36Tfc4KqCMgKO14KgoAkMK/zsyFQTBL9osh2Ksj4A4yQkOMnC97h5sz0p5
	 yzM8okWgI4SFA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 12/25] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Sat, 21 Nov 2026 02:08:31 +0200
Message-ID: <20261121000844.1863324-13-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 611731A0005
X-Rspam-User:
X-Stat-Signature: tmzexk1m7usn8613o7rfu9jko8qhssh8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795219787-567771
X-HE-Meta: U2FsdGVkX19ySBhOoNEsNzRkivTODThRDjD+IGgmCL9C1R1m1IdBz4TuNy/2aJ+eBJyMdIb4RTjk0g+C0IclJU0l5SXHVwtFdWaEZczxg5HuD6+D1kRCJwiqifnshn/6CxFs+Jwqsw2Gpi96DRJPp5933SlEWGVn7qI+dI/cmwPTFKSuYoBNdQxS7PGEXIRfwQu06VSLRQNdmt0371uLU+M4hQpWdUkA+2Rq3YmzaZzf1rQ4gdDe1d5KiJYdOzCSBrhpYQdCdrzC5zXYUFb3+6BeEwYqBVeY/w/y2tj79iV6CM/eZuNM/AT1CMWxleSWKtW9/7RWHCP5Hm7Ek8pCZgQ7jBexH7t2G/8CqLX6Bjuw9+rWqarkjRZJ63kXdRzMfzKbdgHgVCscM9iCIhArjrY7anQR/zV7AfBJp0pMsdM/ht1u38TFKEWqiGHH6jlsAHVRxN6FutIgQ3KcHSy5uNlz/D/2oYqiSofRPX/xvsVHvMB6sJPCq4NYQFyGYmTZcXwyHsihaMc+GA1PuZ/hFT1QWDgOeK7V7s+AT19uqTW+I/A+3zEDJdefb2v1QpHZqeePyGuP/EdbIVbJi9B6grC4UYhczFMRZVI9q5CUQRUeIuLb4JXj3Cts+XzRRsQpXcg7+8qaW7cmgYmCUonMuJTSvPrEUPesHCbG4nbwaDpEDjAR44oBhmkFzOWwSDIOHwzl/AO9bcItNhtiWDuDnrX/mcuZ6dca9QENGtqPOct/a5IiKfDuyEQx00PMvazFkIJF8F2ZLAzjYDUc3dJ3BhXslWnFzmdMXNDIuEmJ1caCOatTnA40IcJhzMmio4Z/3ZpvSary//2DlEj1u0Tkz9YtHrT32XegHy0EuO6Z7hQtqHK8cjdn8K6Q/bE2JUtyKNwUrvlHEOp+YtZDGU1sBSYtxer08EeuRMtwdxk8c77ixzFEahA1gFm9yD06wpVrJRbFvtHN833lG8GDs1f
 ACgOdewT
 RfrpUN3kzhVF5+Fx8JkwkbUU7cJODefnnRa2IN5cjAP6OmWped6RrWpxQX3AJ22A62vB5dh3dq93vgMmu+mTC5VGqLhtV8SbPqWpVzsLdzLAezZjmTMrmlOje3cT0lFtvTkmP9j5OCZwKzV2zlw5h3qILGk++WPOx5FoW3GNxudngi7WZwMH3LSf4Zp8JUPPYiVqO/4rn1ye1aObVW/8Jxj4a1kkSI3vwe2Tw5kOA/25a2Fulz1RXuAT9K6qVoCJ3XY9dbjhd3EoqFuKEDl0VXHHtz5mohChLjFAoZ72fpECCGC4TdOzfgENcBNgspKsNBsTkcuiV+gAPcZ7131bOd24c8MIQGWtd8krmgmKuPUySsnGPVMWSa1c3FOwNTn0FzLCRsySDRsNUygp0lafqUl0MR4vgsdqM/weceyUxUvl8ehCYsL01M13DmutdQi59Hx8cPelV4YP4MfMhvEvbXNPpTKKE0cqV0fYT+PS5TLhC8ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A root namespace needs to record its init thread group's PID when
bootstrapped and capture its exit status once all processes in the root
namespace have terminated, without serializing normal fork() and exit()
paths inside the container.

Commit the bootstrap child reaper and bind pid_ns->rootns in
copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
from zap_pid_ns_processes() after the root namespace's PID namespace has
killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 15 ++++++++++++++
 kernel/fork.c                 |  3 +++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 37 +++++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b20baaa7e62b..6fd959f4d0d4 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,6 +15,7 @@
 #define MAX_PID_NS_LEVEL 32
 
 struct fs_pin;
+struct rootns;
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 /* modes for vm.memfd_noexec sysctl */
@@ -45,6 +46,9 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	int reboot;	/* group exit code if this pidns was rebooted */
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns;
+#endif
 	struct ns_common ns;
 	struct work_struct	work;
 } __randomize_layout;
diff --git a/include/linux/rootns.h b/include/linux/rootns.h
index dcdba08cfaeb..6add4dd55550 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -14,6 +14,8 @@
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
+struct task_struct;
 struct user_namespace;
 
 enum rootns_state {
@@ -42,6 +44,9 @@ struct rootns {
 struct rootns *get_rootns(struct rootns *c);
 void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
+void copy_rootns(struct task_struct *tsk, struct pid *pid,
+		 struct rootns *rootns);
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -56,6 +61,16 @@ static inline bool is_rootns_file(struct file *file)
 {
 	return false;
 }
+
+static inline void copy_rootns(struct task_struct *tsk, struct pid *pid,
+			       struct rootns *rootns)
+{
+}
+
+static inline void exit_rootns(struct pid_namespace *pid_ns,
+			       struct task_struct *tsk)
+{
+}
 #endif /* CONFIG_ROOTNS */
 
 #endif /* _LINUX_ROOTNS_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..08fc28ad1eed 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -83,6 +83,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_event.h>
+#include <linux/rootns.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
@@ -2576,6 +2577,8 @@ __latent_entropy struct task_struct *copy_process(
 					  &p->signal->thread_head);
 		}
 		attach_pid(p, PIDTYPE_PID);
+		if (thread_group_leader(p))
+			copy_rootns(p, pid, NULL);
 		nr_threads++;
 	}
 	total_forks++;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 127a5fd23e70..081c27aa85bd 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/idr.h>
 #include <linux/nstree.h>
+#include <linux/rootns.h>
 #include <uapi/linux/wait.h>
 #include "pid_sysctl.h"
 
@@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		current->signal->group_exit_code = pid_ns->reboot;
 
 	acct_exit_ns(pid_ns);
+	exit_rootns(pid_ns, me);
 	return;
 }
 
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 033e0aae386f..fd8ce59de61a 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -185,3 +185,40 @@ bool is_rootns_file(struct file *file)
 {
 	return file->f_op == &rootns_fops;
 }
+
+void copy_rootns(struct task_struct *tsk, struct pid *pid, struct rootns *c)
+{
+	if (likely(!c || !is_child_reaper(pid)))
+		return;
+
+	scoped_guard(spinlock, &c->lock) {
+		if (c->state != ROOTNS_FORKING)
+			return;
+		ns_of_pid(pid)->rootns = get_rootns(c);
+		WRITE_ONCE(c->init_pid, get_pid(pid));
+		WRITE_ONCE(c->state, ROOTNS_RUNNING);
+	}
+}
+
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
+{
+	struct rootns *c = pid_ns->rootns;
+	struct task_struct *leader;
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		WRITE_ONCE(c->state, ROOTNS_DEAD);
+	}
+
+	pid_ns->rootns = NULL;
+	__wake_up(&c->waitq, TASK_NORMAL, 0, poll_to_key(EPOLLHUP));
+	put_rootns(c);
+}
-- 
2.47.3


