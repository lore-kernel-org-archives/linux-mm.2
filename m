Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94163CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 10:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E0C6B0092; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2066B0098; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5F56B0096; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4D146B0092
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:21:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5992F140631
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:24 +0000 (UTC)
X-FDA: 85306324488.22.46A6E01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 51A211A0004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EgSG0nwN;
	spf=pass (imf19.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791627682;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSqWT1C3QlJdBqmN97E7cjlxf52GtPu9fzH6s5ofHVs=;
	b=dxm7FVXLpw1sZ1uQW3sp1q/QcKJ0U3qv4tlP+sn+UqrdsrtAqpRXqpG1YHNHfLUpKSMSHx
	W0oDyHkviKDMBTx192mCJVbBaeutn6YGiXWpqqZCR2pKzBC7jqgOpGg8HkxPnAKpTEs9nO
	aUCbf6jdg4TcAiactahQeiL5XZeLguA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EgSG0nwN;
	spf=pass (imf19.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791627682;
	b=BBmjirgP2FWwELj4M2/lL037xZldbk9JpmxrTARHzXKkvNPlNGgrhPJPvb3GE7khDtFR4D
	3+QE7/gWjgo9PV5RD3/LOkuKt00bJSPlHwYIS88wOeMdqzHj2XDLbf9CSHYu9uaWR/Fgc5
	zd1yeHLhvyq8sWoEKeE670Qb3UHs/38=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82FBE44500;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6201DC2BCFF;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791627681;
	bh=WLVrb/BQ0T8S1xyglKsRL7i+bbmq4PNshKGzivj1Emc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EgSG0nwNb0kZB3pRhp1UCe0bD4OPW2Hs48JJaNDGr5rN7RwLWZRolIeGPfcLIP3tK
	 g6shvoQDLWnfWgZdNZhTXBRXSNdjq0hCacRNi28iZEDrSh4FTfbo5XuvKozGNNZqvs
	 KtB1irsw0URVae8Ow5z2xmqlr0GvRXVIqhkL1BA7cshZ/chBe3kNO4A915knn0wpPG
	 OJ42Yet3GOKFQnYkzRU3sKbXVHXBOatRWdTiPRf491XgTpjORX2FGQ6lp0wQmidDQ5
	 lOKEnJgrAtnAlSwnRqbEVMZtkxdsBcsY6xx/kZc7lO7DJRspmQQKnUcA5QsgipCMEU
	 vOIuqOi5ZbeTQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430B3CA9EBE;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Sat, 10 Oct 2026 18:20:51 +0800
Subject: [PATCH v3 2/4] fs: Introduce task path helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261010-pidfd-get-paths-v3-2-f245440b2b30@black-desk.cn>
References: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
In-Reply-To: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
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
 "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
 Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6587; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=WS799wrFYiW1TzebRLsEpU08h/pkWDA+FwhU07a059c=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqyhGcM40+OratBIYiuevr1fLpl/JdNFVpv2ZAJ
 7sHJOcDf+aJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCasoRnAAKCRB2HuYUOZmu
 iyh0D/94+XLvx3tMlz65Qm1aQbCk6UwJlFdkfQoSMIbGpxXAYtp2FlqyxnLEwVnhlgEh8k+V3T+
 mtBgcimeyv7PJC/5qTeFbd4lWvbM1YF74Ug204XFTf9FVRZyGfednqil+nfEJRjxNa6j38OXSAC
 ZBqyZ75bnO2CtmBETrNx4F5EgqRltRS9va2I+qf7qft4MSI3zhFar/X2QOoNCRAGURYD7ppAWYe
 O25qq1U6EAKpW9scyQXEu1TpkIkJ5sZsjnEamZtkNLYCcjmh3vP0LD5CA3gfrKwL8bYhMVCegb2
 WcmDjlDDTVAdxBJi/nNYPlL97HBgSrOw55yqVHBgR+X83aaDPn3yCeUvGU+kf2+db2doKqOfu7v
 sBZNRXRQvAeQhrnfFYM092PQsvT6OL15TCZG5Jn5/XWAHtD1Ak+7EsNOn7YHs3JwsXGU9dtdvcc
 KHwl267ThgPh6BelcoTv14wYfTPntNDsdlXVJzHzppDRLOlFFZrp8M7/emz2VvknSR2/ZHAr0ds
 t9zBo3HtldYC+QNc5qb/BEvU2uD7FuTkL6/aMRuiJdkwY26rz76+UT+xrfmSB28RYL2JMBZElFo
 X7nR48kAHhfPo0nhQMarCcqkJMvgUKjPT1FibFT2WvulArRdcFrMHnpINq7pF3e0fqpnckGa67A
 dqvDHIeKgSP+Ziw==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51A211A0004
X-Rspam-User: 
X-Stat-Signature: cm3bn3ig9iaibifydewuijysd3jzr8i1
X-HE-Tag: 1791627682-105038
X-HE-Meta: U2FsdGVkX1+3Zmgt7Lc3c81IGavuezMLDI3+zwkfmpcfofTHmOUrl3TNMT6gr8LtGtN35XfVb7GWIIklcW94MIfnJu0QzVJKLPcTHBqVD0zc0Bw/bz4tRmGKJhpIL4rJGRW7hzXp4jtoxnC1l/uaGkPMqMOeFZSkpHB3FSpaP0TW0rTIxi65xie0k0kLTiGYNX/vktSNJVpSFGDKCZymgZlJbPlvltz2vdiiEucpgXRY6dhe63ne8N4YmdW5RV5imOSqWa+oKA4mqLN4ggQZwDjLOGHDdFMtrr0lTGOEiW94lR6843LyVZnHL9SzYcCVsDtpp4Z+R68ygHSEPMhm9+CIeUn/gaoxE/KFdFlyLi+ghNcls6K/FO145SwPwsRDxch7zSDBi+V9FrLUHqlSvv56pAXF+ujyGtHnNON+2llgHj1eXqg+jt4wlFeg7N5jFPdmT9mMZkEqUwqsKpHHQjNH4pI9aZnV8n1QDHkkLw1PcNcWZ0T+wn7Kglywg1g/0U2FMeuvp14OI/DELjzMSVf0jrWtm0xlwB3mbjBnNGDEqQbWEvVK3aHIv9yIHNoPrYPeJonqnZCrV0m8TPG0yzZGsFZFMXSSQzuYDhtqCUYl7fHCNeOljZkhwG46qIHZoScdj0TcQcun7OqvlBML8lJAofB7epikpt/2KTKZbz8KijoSCk0WOkzgWnXN3Bwi1P/DWqw3ZpA9FWnyTI1LpRgJg3Fhj8IQ7MocT3JJ1+1hxXc3noyOWmLKCjb/VLOOa4hxXf31D9AYlo7Or+E4rFM3mlJyvnw6a+DwkfwO5EZjND9n9APtVql+qh2+6O9QwhGrfLVuvFpuBNeJm9sVss37vVvUnNX+JeupfiUeEHeoyOO8bq0+zJU4F3pl4LZTtLgR3IWlFu0WCtjNtGNsHs6vJnfEiim8KgwCdH+Lc8u4QTDlIVJECWUsYcD5GgOH2NQd1gcEhGSQuSUY09g
 F8FLMJ4+
 NXNvib4z0f4p18AH1ywG/xU7jo7H0P22UHAeg0/Dw8FOKuyiPPcAyM24QXB7jxWOs3iQZuNPx3nKqTM3tFHhl/htEM/59pUW8eB5Z5MTWo7kiWF1B3e3JicqMA93feBlR1jrnxWyHyS3NmJRuOoSJOffLJ8FLzu3A4fL2wvMRh/+0EA5c9jGlN6PFhcoLpzp3NShwS/VrMdzZ6TmxVkhCvJyLJi9KXsRwgzhpzrRFVzYyqc3pIbZwYFJlcO4OBJObILe/K2nWCFMzA8dlEk8wocnLyePHwS0/FHdd1qmdaxOIO+OYkcutbQ0CBjpj4CnjlJRHb5EDIQVfUkYbfTAYCAbEBSzhssA2Gq3WSWqUTRlFP3x3RvMEvhp+51AM0Jul7huG
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

Assisted-by: LLM
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/fs_struct.c            | 44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/base.c            | 34 ++--------------------------------
 include/linux/fs_struct.h |  3 +++
 include/linux/mm.h        |  1 +
 kernel/fork.c             | 22 ++++++++++++++++++++++
 security/apparmor/task.c  | 12 +++---------
 6 files changed, 75 insertions(+), 41 deletions(-)

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
index dd09c438fa23..a65f24b2e65b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4239,6 +4239,7 @@ extern int set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern int replace_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 extern struct file *get_task_exe_file(struct task_struct *task);
+int get_task_exe_path(struct task_struct *task, struct path *exe_path);
 
 extern void vm_stat_account(struct mm_struct *, vm_flags_t, long npages);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 416758c8a3d4..06b3d1b24773 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1371,6 +1371,28 @@ struct file *get_task_exe_file(struct task_struct *task)
 	return exe_file;
 }
 
+/**
+ * get_task_exe_path - acquire a reference to the task's executable path
+ * @task: The task.
+ * @exe_path: The task's executable path.
+ *
+ * Returns 0 if the task has an executable path, or -ENOENT if it does not.
+ * On failure, @exe_path is left unchanged. The caller must release the path
+ * through path_put() on success.
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
index e16ff4130bc2..05cba261dd34 100644
--- a/security/apparmor/task.c
+++ b/security/apparmor/task.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/mm.h>
 #include <linux/ptrace.h>
 #include <linux/task_work.h>
 
@@ -330,22 +331,15 @@ int aa_may_ptrace(const struct cred *tracer_cred, struct aa_label *tracer,
 
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
2.55.0



