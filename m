Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3363DC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 05:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB866B008C; Thu, 20 Aug 2026 01:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479E96B0098; Thu, 20 Aug 2026 01:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D5E6B008C; Thu, 20 Aug 2026 01:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 046576B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:45:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73BB1C02EF
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:45:51 +0000 (UTC)
X-FDA: 85120561302.26.A762480
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7FD7340006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:45:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cAF8Nvkt;
	spf=pass (imf01.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787204749;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B36AvsOpIMPIOb/lofdCliS/8gkGmzvz6PlTUURVgNY=;
	b=IRxS05FMZ9ei51AisHxmZGfpXJ2KvIF9CRP90kvByPw4QrUwCvVi4IWbwSb+gGdVD1CUd4
	dp5MAVvyVluM+J6XfWLM5Q3SaN0LAhabfkAYqffwM0fG6pf0dONmDm+kndTETeNQF0btFM
	RWRXfm7wNmFIPk9BHjSptythk8e8/Vc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cAF8Nvkt;
	spf=pass (imf01.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787204749;
	b=U3r0YG3o1Ldmimgf8d2mC6ZVIQhp3JNG4z9WRD/aGxCpoTQNpNAGoL7UKlUuwF0wLlyjRl
	jZcKkFz84nNFS/XgnlXOHT9JRJJjstmkJm+NyNezMNhgHKkMutoMez/39KR6x8VvNuybTH
	bJxakcs33dHtgWshQ/swawnyQ51AzKc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2789343CC3;
	Thu, 20 Aug 2026 05:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDAD8C2BCF6;
	Thu, 20 Aug 2026 05:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787204748;
	bh=MeKTIcEK+ksehYYoBM9bZNSn1YPs8/DYlnYnDPyEhAk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cAF8Nvkt2q+6/NWkROpyJq0zni3LztVCDLI+8VezbgKofRB5hO62qZgOY5eGL/6Fl
	 pxGBFzwm6CH+X3gSSsap/lVrtV4a5ERqPCLJRAnjPcIAgwrZxLQI5vFAUSxfNOT7BH
	 KsugaP9tXahXLH1OmZyL/hPZ4ldxsJNXizXdPXY6VmulG+yD2VFbJa170m5v2qawrz
	 RzuHhHZp6LcnB3xPLzgQ1HxiHSL5L275t/LnPTntPf0HGT5KUCUmtj7FidZN8JTsi1
	 Au2CD8QPpyluBa8oZjuAvlLN4Sa39UDydtGjV+EYS0Qqi5AhKOeiLp/IN8+7LV6czY
	 VOOG1Nl/3iZQg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D43C5DF82;
	Thu, 20 Aug 2026 05:45:47 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Thu, 20 Aug 2026 13:45:39 +0800
Subject: [PATCH RFC 1/3] fs: Introduce task path helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-pidfd-get-paths-v1-1-ac3eee4003d5@black-desk.cn>
References: <20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn>
In-Reply-To: <20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6547; i=me@black-desk.cn;
 h=from:subject:message-id;
 bh=c5V62gW2k1W6OW+WRiIoK8g9+DecwyUCnGF7s06tD0U=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqhpSH8f8+uX0SS1/DOpI+3NWSk/SvBZZVhHzXT
 x9wG3WbbYCJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaoaUhwAKCRB2HuYUOZmu
 i61SD/0QHXuBv9olpKhk3LLGVwQYpXubomUExuYp8jK1z8M+Q0+0FM2p7a9NTwgOgghZk57TXHM
 mp1kBl3X3zbDHe1T/l/+5/2LJcRk0p769KZwnUAZINIXmxosrLsyHrgbhk7Mm5F5aaYHvjHE9Pp
 iDilotwYibrBs+Y3Y3aVa0AvsEZaddrThzszJqSyCYi2uh3beQLY6z/3vpRP0ViWn+jKRNa47NP
 V7XXC07qW7RHvyc7ffswlCbVaHFsODIi3rSHzkLcTs4YYQXiyR5ZBL1gOqdHOGNjHAnJcin0DXt
 JjGdQqg6/rjjEWnxD9jshT4iuYCGGMQ3YVNPPupxgLdqjaiVcjt+3+mAFdYzVTnAgMv2B8XPWTf
 CX2fPiyVc/hLy/FtTshr8tH2NzVJ6VImkPKfYtcPpMx70DM4B4cvLBNTNKmLUGGLT79z/1nUDhe
 fJfNb+bwR5THsxzbqFT2BPrkSPCkUPfHRoILL3aK1lArNYUaiC+d95QThhDD+Scr8nA3ByHkKVE
 HItc0AVSoact2u3Hre7DYKUhcILS6Fi77b4TefVBQ0G1ADoDjPLNJ+9EQ7suIZ+x+HVZ6hsW9sH
 Hg0Xq5p9TyNhDGAa8LQ0IH650y5GDYWrW6je2reIHHijA4yHpVYNVrKn4/ZuZeOdS6vBfTr681F
 ss/IOJP2guDu+eQ==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/default with
 auth_id=573
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7FD7340006
X-Stat-Signature: xyag1gb5hozgmnixce3tayc81dm9dw15
X-Rspam-User: 
X-HE-Tag: 1787204749-681620
X-HE-Meta: U2FsdGVkX18LHlnwTUlq7iLphigajwvAZ/7ZRpgj/bYDqE7lHqupmw4J1/X1YsNYsQxDkTWpGrArlye4y+Hx4YpM4xgGE+ynqdb4m7NeyBf6cj2BHy12SSKrgSh3pRe/s0AKKXJ7QV1H5cn4hj17QJM9k9dbC/lOp/iDAwIs2ydp1Fx9XxvICP5B938VEKTcT30DZMiuz47MvJ9rW6CeL6k4MIwmNRflUB9Pt6mh5p8BFZpxfRb9wAWVcqrlKd0cBLRdqFDFskW0TFC50urCAy9bcnj1WgKIG7D305zWKk1arO8RTxiVW8+9bc+H4J7DphAt4nBmbd/GZto9iyoVqImV7FLkzcjTCd0FW6EsqHRtG38CRpyWfpd7LwTsmdxgWO9iAjLJnMwfV5KMOJlkeIH5p0B/DBPwjD8NC1UPDjUeokCskP60sKhY2dDzxLfle8zx1YfMB7kwlDkGY/xllisPZJcTehPGnrqFRqYoruCtK16TTa1E9x3ZSwz5sjumNHkXDihZWuqcXGZnFI54n0cV53fgddcUy7JYvE0IQy3CqD+3PvqyqOl/gEDF648wGKoptXCAbmB+W9rNADeNhdeNkClREj9RCKjxhw2ibzRQiNz42y53pk9XYXvzvHhWd4GUixftSnHi64rYqgdqv6rk0RC+r1hlyow2ZSqvcuSQcp55+UpEj40EBWK0TRb/CUhwm4MBZdpAe88AEGiNtSqnS+PaJImQM/K5G96ctvJXtbymZdbYEjR4t0ymyzN3tnqT75WbRP2hkvG/SH1jPmUu3LfBGJ/FJHl2unxZMzS6EduuOv9ZhI+WCM+QyTDTu65I5+jq7gQNK1Wwjg5EC0JPaIBKM06moLj0OzVNRWPOehXrlILmbWcUAYUv5iKDamgQLjgr/M0iC8CHScJGHfXapKQKaB4KGeKlwlNF/bjyJsH56VlVfTz9P6ztv9ycaB6n1bO1km1wVMq+DMC
 GGGUJfuW
 4k3bQNL8ANLt5UGf3Z+ZytRWgCvqi3sksEaAveVhile0tlm6SU6DCfBmAk0irZCdfadNCE+cJ8O3LF4UK3UPC9wgO2bs3M6ZiHFIqDJoSofVJkDQ5hE8SzJlfUcDUNBgh4WrEEZwFD86DeNZn7Sc+DQZa86kVW7qG5OpGzriANGBA1F4O9FYdF15h8IMFSvvVbpgmnISW6kMPXmyQKz+v3NRlzeo3VCI512hZe7ni8Pxy1TqyQd97Kuij3RpWhIjyziDwzSW1eLsE2wZgyDTcGbfUd8M7JGQ0u+EC4CTPNkhNDQBQ82UViSsZDlv4oCo9eHBqhybOyWGGKHBynd0ebsdQz7RS8rpHQtYjjg/YE/28TTFXQOUggjtgsyu8/T2+5FH2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Linxuan <me@black-desk.cn>

Introduce helpers that acquire a referenced struct path for a task's
executable, root, and working directory. Reuse them for procfs task
links and AppArmor executable-path handling instead of duplicating file
and path reference handling at each call site.

Assisted-by: codex:glm-5.3
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/fs_struct.c            | 44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/base.c            | 34 ++--------------------------------
 include/linux/fs_struct.h |  3 +++
 include/linux/mm.h        |  1 +
 kernel/fork.c             | 21 +++++++++++++++++++++
 security/apparmor/task.c  | 12 +++---------
 6 files changed, 74 insertions(+), 41 deletions(-)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 34699f3b6f88..5c772896260a 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -10,6 +10,50 @@
 #include "internal.h"
 #include "mount.h"
 
+/**
+ * get_task_root - acquire a reference to the task's root path
+ * @task: The task.
+ * @root: The task's root path.
+ *
+ * Returns 0 if the task has a root path, or -ENOENT if it does not. The
+ * caller must release the path through path_put() on success.
+ */
+int get_task_root(struct task_struct *task, struct path *root)
+{
+	int ret = -ENOENT;
+
+	task_lock(task);
+	if (task->real_fs) {
+		get_fs_root(task->real_fs, root);
+		ret = 0;
+	}
+	task_unlock(task);
+
+	return ret;
+}
+
+/**
+ * get_task_pwd - acquire a reference to the task's working directory
+ * @task: The task.
+ * @pwd: The task's working directory.
+ *
+ * Returns 0 if the task has a working directory, or -ENOENT if it does not.
+ * The caller must release the path through path_put() on success.
+ */
+int get_task_pwd(struct task_struct *task, struct path *pwd)
+{
+	int ret = -ENOENT;
+
+	task_lock(task);
+	if (task->real_fs) {
+		get_fs_pwd(task->real_fs, pwd);
+		ret = 0;
+	}
+	task_unlock(task);
+
+	return ret;
+}
+
 /*
  * Replace the fs->{rootmnt,root} with {mnt,dentry}. Put the old values.
  * It can block.
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a39de424f62..7e2c0538323c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -206,31 +206,10 @@ static unsigned int __init pid_entry_nlink(const struct pid_entry *entries,
 	return count;
 }
 
-static int get_task_root(struct task_struct *task, struct path *root)
-{
-	int result = -ENOENT;
-
-	task_lock(task);
-	if (task->real_fs) {
-		get_fs_root(task->real_fs, root);
-		result = 0;
-	}
-	task_unlock(task);
-	return result;
-}
-
 static int proc_cwd_link(struct dentry *dentry, struct path *path,
 			 struct task_struct *task)
 {
-	int result = -ENOENT;
-
-	task_lock(task);
-	if (task->real_fs) {
-		get_fs_pwd(task->real_fs, path);
-		result = 0;
-	}
-	task_unlock(task);
-	return result;
+	return get_task_pwd(task, path);
 }
 
 static int proc_root_link(struct dentry *dentry, struct path *path,
@@ -1761,16 +1740,7 @@ static const struct file_operations proc_pid_set_comm_operations = {
 static int proc_exe_link(struct dentry *dentry, struct path *exe_path,
 			 struct task_struct *task)
 {
-	struct file *exe_file;
-
-	exe_file = get_task_exe_file(task);
-	if (exe_file) {
-		*exe_path = exe_file->f_path;
-		path_get(&exe_file->f_path);
-		fput(exe_file);
-		return 0;
-	} else
-		return -ENOENT;
+	return get_task_exe_path(task, exe_path);
 }
 
 static int call_proc_get_link(struct dentry *dentry, struct inode *inode, struct path *path_out)
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 97eef8d3863d..fb725707754d 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -42,6 +42,9 @@ static inline void get_fs_pwd(struct fs_struct *fs, struct path *pwd)
 	read_sequnlock_excl(&fs->seq);
 }
 
+int get_task_root(struct task_struct *task, struct path *root);
+int get_task_pwd(struct task_struct *task, struct path *pwd);
+
 struct fs_struct *switch_fs_struct(struct fs_struct *new_fs);
 
 extern bool current_chrooted(void);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..7610eb579b41 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4124,6 +4124,7 @@ extern int set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern int replace_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 extern struct file *get_task_exe_file(struct task_struct *task);
+int get_task_exe_path(struct task_struct *task, struct path *exe_path);
 
 extern void vm_stat_account(struct mm_struct *, vm_flags_t, long npages);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 1e68404bd773..16aa4c82b9c7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1371,6 +1371,27 @@ struct file *get_task_exe_file(struct task_struct *task)
 	return exe_file;
 }
 
+/**
+ * get_task_exe_path - acquire a reference to the task's executable path
+ * @task: The task.
+ * @exe_path: The task's executable path.
+ *
+ * Returns 0 if the task has an executable path, or -ENOENT if it does not.
+ * The caller must release the path through path_put() on success.
+ */
+int get_task_exe_path(struct task_struct *task, struct path *exe_path)
+{
+	struct file *exe_file = get_task_exe_file(task);
+
+	if (!exe_file)
+		return -ENOENT;
+
+	*exe_path = exe_file->f_path;
+	path_get(exe_path);
+	fput(exe_file);
+	return 0;
+}
+
 /**
  * get_task_mm - acquire a reference to the task's mm
  * @task: The task.
diff --git a/security/apparmor/task.c b/security/apparmor/task.c
index b9fb3738124e..b4a4019d77c7 100644
--- a/security/apparmor/task.c
+++ b/security/apparmor/task.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/mm.h>
 #include <linux/ptrace.h>
 
 #include "include/path.h"
@@ -303,22 +304,15 @@ int aa_may_ptrace(const struct cred *tracer_cred, struct aa_label *tracer,
 
 static const char *get_current_exe_path(char *buffer, int buffer_size)
 {
-	struct file *exe_file;
-	struct path p;
+	struct path p __free(path_put) = {};
 	const char *path_str;
 
-	exe_file = get_task_exe_file(current);
-	if (!exe_file)
+	if (get_task_exe_path(current, &p))
 		return ERR_PTR(-ENOENT);
-	p = exe_file->f_path;
-	path_get(&p);
 
 	if (aa_path_name(&p, FLAG_VIEW_SUBNS, buffer, &path_str, NULL, NULL))
 		path_str = ERR_PTR(-ENOMEM);
 
-	fput(exe_file);
-	path_put(&p);
-
 	return path_str;
 }
 

-- 
2.53.0



