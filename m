Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42D1C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3BB6B00E5; Thu, 16 Jul 2026 10:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A9B6B00E7; Thu, 16 Jul 2026 10:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3696F6B00E8; Thu, 16 Jul 2026 10:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0284C6B00E5
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7BFE1A01EF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:37:41 +0000 (UTC)
X-FDA: 84994893522.11.A7DDFE8
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0A8A180003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:37:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=XS7JAmBc;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csZJqwFw/LF9jvJifU7Wr9Kub+l+N/C7ZLf6/P48CP4=;
	b=GsNGDS5aBEyAuUDPxSkiNeyHmF0NVTzPWZpqS5q0jBYkvVAjfjk5KX95uFPHYyzZr9uCty
	4dBGN5mjT7USajb6ZCNh2tXu3OenIvLbj60M1t+ePkpQymg0ZwLdaMAQrd7grAF7v6Sm1C
	uH+KDaX+akYOgDX7Jbp60m+wEnLdOAc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=XS7JAmBc;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212660;
	b=DPmUSTypT1WphlXG/+IP8rzA2BGeMbxl++n7aYAl8WvACbwts3Mgkl+YtqYVjgVGfzs6wS
	7bhXtF1bOh4kvcfxcSoC9H+B+2h+Esi6c9ALcWZdozxsZPiuBbN0yK3wmd7HAkJneeEOrK
	l5+ptwCvmv18ta6agZBYnCj7tzEiUQU=
ARC-Seal: i=1; a=rsa-sha256; t=1784212423; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mP5Bo8nEM9S+Mw6KA6uiFRlAqKu176gQr+zRP8YXoU73ULcPYeuNuHcwNoAkPaL3v6C/W89/4YaHhryK+wmtlgLBwLRpZGkPr4YTLbh9AYrLcJsOMmmn40Ix5DuBqJTtzLt0g2w37NQbPF7LZr9L7fe9y3r8pfLvvdsNtwQjvig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212423; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=csZJqwFw/LF9jvJifU7Wr9Kub+l+N/C7ZLf6/P48CP4=; 
	b=gYMXR3sey9S5i81vhtgYUlnAbvQH+FABm9cEuPB2FO2PiJZsTp7Ba8tiyMYE5VnuDYbLEXQNONua+D0WqevLpikCMyTn//L/gOnlKwYIS+5xckf+LJd8+/2xjs5v3i3ebFe51zGpxBLGarakg7agJNEDmrhzjuoUBEK/rR4COMs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212423;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=csZJqwFw/LF9jvJifU7Wr9Kub+l+N/C7ZLf6/P48CP4=;
	b=XS7JAmBc4/sJx8XPkI0/vBhiJxXrqgfyFb0OLS/umUzn0lGKtGl/JzEc4Padd895
	rMMYGbAPFVb1zgbPNCcvFj1nMZ0KKvfy8cyBeJYKr73sd6XcDRqTuUcRArmydCKGy7k
	V8LvQMeRsOiLcisUxN4RhP8fDYgkyiDJLUnsIdFs=
Received: by mx.zohomail.com with SMTPS id 17842124204621023.6986145207051;
	Thu, 16 Jul 2026 07:33:40 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 09/24] fork: let process builders supply preallocated pids
Date: Thu, 16 Jul 2026 22:31:35 +0800
Message-ID: <129eedc78affaf85e4d552daae1460a43057fb39.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A8A180003
X-Stat-Signature: oeh3iok7fuj8ng1z3iwpuzpzpgm74rtj
X-HE-Tag: 1784212659-149522
X-HE-Meta: U2FsdGVkX18DsvFWWU5BSAfHwnopcAmXLKaIZww+APqEG+br5QFuoghbaAWlktSE68W4QO9Gwc76UZM2ZyvxmLrwoJUmM8js4JmDxuv0fRoTScoBN6k+Vay1WwOx9PkWbSI7lv0RF6BFb6UPtCulvOb+0zvrdeBOKhYcydaxyUmCge/smusL752V0WL2gsgVwsMeriQkGvzq2Z4t3N2ipTe6N3LdJ0D+hCBEVKHitOUuPf+h3yHQXmXV8xKFSg2DnYBpIjUlFlw7qWvx6+zpsXcwT5nzhS7uJvCh+FdTrIuoolLDR65pdY8ADgyP2jk6UvPEPiio6XfsDH0aKfNW8E1DjePbgYsgrXw3C5J5IyW8QaTicG08CyJ35lTXeNwsGkO4/Aa+PE93G0Cqks2KN/ADS1IYwnPYBc3xP1ULDVojzmaIlzaLMS5CnJPoL1wLLWwqhv5nzoj2Yk5HQR1faZmQ2QSdXQTBbbdii42cmQ8U3uJ6AwaX0p0NONfP2asD4J/kAOmPCEexCiaHuxmECkVeYaLA2Mtg/PqRaMF2tYb47MmwlsgSgmGsXa2YImteERyOoJzkCAGe7qHhZHBVUu3dC0ioaS2dyrlgasI2o0cqPok+TyLoaJWn9Vx5hY5xfALU81FRPlz1o8Px732Y8l+0IH351KKAKgAqLogJ+k54vuCdTkDyvUVpzYaO/cshB7dpUMFENXBzSfe2MPOg1hSFsfiaLJyTQPTfLmLnuEd2hjcDzYOQAIzaG70VjFfm8nMG9hXfMcpAwgAKZFKjqcX0W1zlO1UJyaPBS2F3cnAHOcxpnmD8C6lOAO0fGTLg/RAvbHBY53hsd5m3kSRML+bVTWd+EFw55qrs9wJX1/uEDZeSPL5OsVRuHyjLb9+KyBzjx4WtByMHxz57GoLq05gYSXkmt+9uom48zeDv7ELrwCjCvvUXiN98Lgou0xN0rQzLfbCTk0MnZymOVRI
 aqB0G6MW
 v9INjZGnUkk3KZJeFvb4lGhC7VVvuXEzeIY/RKAdKxCCnL6p20MTCmBOYrdeSEVOSTqLDmg8MvJP0c0BJaKu3iCf2tYoXEAXNzz6SlJ2mp4QsMRtdz0uilBIs+vWab8wrNz9Tf9wsKMUCbUnsw7Qunn2lnM4tQ9X4htJTHqo67tN8hOLAQF+aMM2lM2mWuUbf2kOjRfbymWwcpHouWlI6cJd5/5DA3e9VpuKwLZdDMNfO1hoCslmveD7VUMvhQJn8xUaaCAeYVAY02+cd1JuBe1m27junm2WqqLrPJ0j1oY4eSLZMn9sxXvUjp2lE2U/q7DoLZbrSDgwIezwKpa+UJvi9SV5+GYe5EZASaI5o34FEi/I6dGecfI9VZzLF6JidWjPo9Vq4Dxx9SBm5/MCzhFyUzRxy8aSqG1SHlqBnq0LhcBdDjhW46QSZ3DFtmrgJqY1b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Process builders can reserve a pidfs identity before copy_process()
makes a task visible. Add an alloc_pid() variant for a reserved pidfs
inode, and let copy_process() consume a caller-provided struct pid on
success.

Keep caller ownership on failure. The legacy NULL-pid path continues to
allocate and free its own pid. Validate the target PID namespace before
using a preallocated identity.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/pid.h |  3 +++
 kernel/fork.c       | 16 ++++++++++++++--
 kernel/pid.c        | 22 ++++++++++++++++++++--
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index a29ffe2a5fa8e..fa8acae336f7c 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -142,6 +142,9 @@ extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 			     size_t set_tid_size);
+struct pid *alloc_pid_with_pidfs_ino(struct pid_namespace *ns,
+				     pid_t *set_tid, size_t set_tid_size,
+				     u64 pidfs_ino);
 extern void free_pid(struct pid *pid);
 void free_pids(struct pid **pids);
 extern void disable_pid_allocation(struct pid_namespace *ns);
diff --git a/kernel/fork.c b/kernel/fork.c
index 970810a01bbf6..d16405c037c2f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2006,6 +2006,9 @@ static bool need_futex_hash_allocate_default(u64 clone_flags)
  * It copies the registers, and all the appropriate
  * parts of the process environment (as per the clone
  * flags). The actual kick-off is left to the caller.
+ *
+ * Except for init_struct_pid, a caller-supplied pid reference remains owned
+ * by the caller on failure and is transferred to the new task on success.
  */
 __latent_entropy struct task_struct *copy_process(
 					struct pid *pid,
@@ -2017,6 +2020,7 @@ __latent_entropy struct task_struct *copy_process(
 	struct task_struct *p;
 	struct multiprocess_signals delayed;
 	struct file *pidfile = NULL;
+	bool allocated_pid = false;
 	const u64 clone_flags = args->flags;
 	struct nsproxy *nsp = current->nsproxy;
 
@@ -2317,13 +2321,21 @@ __latent_entropy struct task_struct *copy_process(
 
 	stackleak_task_init(p);
 
-	if (pid != &init_struct_pid) {
+	if (!pid) {
 		pid = alloc_pid(p->nsproxy->pid_ns_for_children, args->set_tid,
 				args->set_tid_size);
 		if (IS_ERR(pid)) {
 			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_thread;
 		}
+		allocated_pid = true;
+	} else if (pid != &init_struct_pid) {
+		if (args->set_tid_size ||
+		    ns_of_pid(pid) != p->nsproxy->pid_ns_for_children ||
+		    WARN_ON_ONCE(pid_has_task(pid, PIDTYPE_PID))) {
+			retval = -EINVAL;
+			goto bad_fork_cleanup_thread;
+		}
 	}
 
 	/*
@@ -2587,7 +2599,7 @@ __latent_entropy struct task_struct *copy_process(
 		put_unused_fd(pidfd);
 	}
 bad_fork_free_pid:
-	if (pid != &init_struct_pid)
+	if (allocated_pid)
 		free_pid(pid);
 bad_fork_cleanup_thread:
 	exit_thread(p);
diff --git a/kernel/pid.c b/kernel/pid.c
index f55189a3d07d4..010f80177cac8 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -156,8 +156,8 @@ void free_pids(struct pid **pids)
 			free_pid(pids[tmp]);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
-		      size_t arg_set_tid_size)
+static struct pid *__alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
+			       size_t arg_set_tid_size, u64 pidfs_ino)
 {
 	int set_tid[MAX_PID_NS_LEVEL + 1] = {};
 	int pid_max[MAX_PID_NS_LEVEL + 1] = {};
@@ -198,6 +198,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	init_waitqueue_head(&pid->wait_pidfd);
 	INIT_HLIST_HEAD(&pid->inodes);
 	pidfs_prepare_pid(pid);
+	pid->ino = pidfs_ino;
 
 	/*
 	 * 2. perm check checkpoint_restore_ns_capable()
@@ -358,6 +359,23 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	return ERR_PTR(retval);
 }
 
+struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
+		      size_t arg_set_tid_size)
+{
+	return __alloc_pid(ns, arg_set_tid, arg_set_tid_size, 0);
+}
+
+struct pid *alloc_pid_with_pidfs_ino(struct pid_namespace *ns,
+				     pid_t *arg_set_tid,
+				     size_t arg_set_tid_size,
+				     u64 pidfs_ino)
+{
+	if (!pidfs_ino)
+		return ERR_PTR(-EINVAL);
+
+	return __alloc_pid(ns, arg_set_tid, arg_set_tid_size, pidfs_ino);
+}
+
 void disable_pid_allocation(struct pid_namespace *ns)
 {
 	spin_lock(&pidmap_lock);
-- 
2.52.0


