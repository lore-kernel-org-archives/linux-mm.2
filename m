Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C540606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A1+WCPGh
Received: by kanga.kvack.org (Postfix)
	id C5F5B6B062F; Tue, 27 Oct 2026 04:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA0A6B0630; Tue, 27 Oct 2026 04:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989A76B0630; Tue, 27 Oct 2026 04:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69FFD6B062D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:46:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC9CE1209AF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:19 +0000 (UTC)
X-FDA: 85367774478.16.4F953A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE54720006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1+WCPGh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf03.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090777;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lPb4xjQbnZy4ZngMC59MHmraHFiUeUrY+PhLP+I563I=;
	b=RaBG9c/8TeUcooHykB/eDZMFi+48uFSu5/xEpT7vcyM32VrZyydA437Wy+ynTOwcU2m8Mr
	Q09oQHwWLHE83jzF1rvIeYylqqQcoLs9QroHj6AlhUrpEiZ9cxX3lulDabPGVd/sR1sgfV
	JbBwp3ekCsIk4QQV9NJh3nHuSotfNmQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1+WCPGh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf03.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793090777;
	b=y8Vb3wxp5PQEUa9VUQQmp8kyygcyGH7y2Es7O0q4bUuSR0xpchhmY7amY66Ek8fae5rxKL
	N/ioCRn2KUpcYFgt7HrH8sPOU65M10Bo4l6encvd+Wl+FVyY5z+XgFrRpUSs7cB8n8rgLt
	q3pgxiwjtR7tO/mS6AE3gKGjgS64fiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69247601FF;
	Tue, 27 Oct 2026 08:46:17 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793090777;
	b=r81aBnaxSvq7EzFTWWdpcnaMCvTNLNIvZ2Hg1KdApNZDG9LNZOjXk6Mu/bcZipicchqa
	 c9ITvKSNBsB6xOpP2SN44+0Y6nU32dOyadpy7BSYjYmbw88mqT+n8p4c79ByHTcQJAcVG
	 vhTeCnaj+Xw81f8P5274yf8pJr9BuBo/wKLtpa2VnmAhZPHUT/LbfyhIuyDbRpiNZpi1i
	 psmXwViFf8YZHn0MIdwPW9xCbR9TqqtIUSyhOaIUmL5O1gnkEDzhh9vXFukQv8vrWvt9l
	 O0bVWYy7G3gvJGk4VPwsTNhLBRtINFYpmY/UTx9PANZfdDpjLo0u/eHtLyclUJzVL6g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793090777;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=lPb4xjQbnZy4ZngMC59MHmraHFiUeUrY+PhLP+I563I=;
	b=DYipU5f3Emh6XJdtDV45f6bLXx6fsXR02Z/mF2DbhOc9zhRdJS/raQqR0XwsBcRgt8ZS
	 LvyLnqWtvxZ6+wq7kyZReJ0YgK7SSR6TIhoWD2T23Ti8lhDd+s8PXxgYqHz6WfEWdVijz
	 FjmrTLSWLqiPWLY5DNHoF1ZKHcCAeAvhrQATTM/LT15CFOMGUjHEbqnLUOrvxwL2Kc1Hc
	 ThdYOGQLavNmegxQcCxYCL4kpXKCrtJPrJgQIAk0PxOVvzTK7dtCOPb7zkw0KFI5fIz1N
	 EsEq/KvAu0vwRp9tv/EZJEj/scDLPNdMvDQrcp0p3jRhYWeOPilKY5uQnFZDQvksUjg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CE2391F031E0;
	Tue, 27 Oct 2026 08:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090777;
	bh=lPb4xjQbnZy4ZngMC59MHmraHFiUeUrY+PhLP+I563I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=A1+WCPGhGg2Fl/ZP4ljBQ0Ivaj2nMYBrojoVqwRQVuenUfrTXKqgU3jL711SH+vUU
	 +s7XQNOvQkT3SaKm2+wLcAvTNAb6H6bgoJwKOqRZJzsZsy5ev2d5ADAYZCileOQPXk
	 aZ/P4cY0dWNc6e/Y/+7gpUei/Y1wnQ5U8t/2Z1/D5T6AIbu+/CelDGb6ris3MnHFuo
	 ZVkoXo+zSf7oHBBjtPgWK+gLdNh3aDHUyDhBDi9QEsVEwZ5+6t+75NfNEmVVyvXjOt
	 vj7i8WvSk2aybe2sBIN+ewPIJxxLMWCH+Zl50jK5KX3ZBrtpa4ibSu2w81QnUS+VO1
	 coAoQT3qokZrQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 43FAC45049;
	Tue, 27 Oct 2026 08:46:15 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Tue, 27 Oct 2026 16:46:07 +0800
Subject: [PATCH v4 1/3] fs: Introduce task path helpers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261027-pidfd-get-paths-v4-1-e2a6a47e3c95@black-desk.cn>
References: <20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn>
In-Reply-To: <20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6569; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=fejmaqYx+VSK8t0txnhVUB5ud+lNikVFyW/NI77QvBM=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBq4GTSkRFUaqvLwCuMi4Io69Zee5xidvIn/rmlC
 RO7G40aFMOJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCauBk0gAKCRB2HuYUOZmu
 i26VEADOaJm+jLlORrBDBu90yPI4rQfV6l+T9tHmQlnZmGVty3p37Kd2gDFl2RAiGCYMZxZ5qhx
 Zh4Yyc9WehzRSYR+KB/RSvfleWppb9KEaYcZpuJIop1pg3xdYvLqmM4P3mo7uUTO/ldLEDRqq3g
 nchXJFhV83a+uZn+CnAyP1C9eVIWG6k9YjVFIOzGifF7bIXvhGC7HdD1yL0Aox71wAfvbBqUrGj
 gzKOKuHkUadQIKO2wEUqcj3Rqrm1hYgQI57oMdWYX4P/bJ+ab5yvRdwAW7vSxvLuFlasrF/j9bU
 6PpjYTIBTEBtmFw6Ttz0xGOam2PMja0tWwRjg3isfTYFiOnxeDyB/ezP96WF7p9H3URVY6477LB
 O6sC/Lzvze0xro6kK4hcBA0K/a18NGEUrqmtGthSece9uVhenwQW03N3KbRT/RA3i0587TvSfQr
 9i/aqkc+Wr8uxBbcsU8TWGTvUKL6KRWgjUgg5eZdiWmrG8aq3oCDsHqkHqls4BmFIf9GH8DvrAw
 12bDhc3PDHjUK/fnZof8d4/85WdlYpHc9F84d99NhUfPtpd8r+Twxnlhx/PHGA0y2qNto3nChC1
 J8uMPR/Ft6y1mATaIfRxS3pY/F3vUQLnuyzk/1WMdDMNi3Pdl/NcXH0iKc7q8cdfOk2woWSAPGx
 DXyoywBPe80rEeg==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE54720006
X-Stat-Signature: w5n93bgoibafjec8u3ze1hcp8zwikd4b
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793090777-430480
X-HE-Meta: U2FsdGVkX18VKyCJ6W20m+2P5mlA25ive79C8VG/OV8vWArl8SgV3G8DOCVtW3Z1U8kRpmqBBBlEAPK30QSQKjnrM5ox6S8Q56WWm0f/gHyNTCnIQ+rnZmNhFXqo9sTT7d9uOkqoXil3Ft5g8QBX5zxr0ZzyUNjdi16T01CfW701nu0bO/pWo8Bn3Aj9z9QiHIObIcXuzDT/FlXLi1YGVo3J3VF0VlQab3j/8tjyZoJlzHwBwQp3TpP3rAKyzjtKbIMw7AgrhVlN8E+gnSnMU3FG196PxXklosPwqkVqFSfcZGvWW70FrKq1n5u9cQ3Bpx83/n2NyaRAwP/CMM2hR5z3e85e3J1/ATZkJLFq5JAXRpwmYLqH2+r4EFVChoCw/pU3DFiJ31H00aj149bz/ap3+pkWfb2baC/0+92fEgTu5hteXlmlP9q/vqV41fDFKoGVhJSScC8MGTO/o3Nyx9kCjmZJEAyVmu8/2LS8bMUcyMeBJIvpICs05ay3CT5/CrYOm44RxsPonao6husp4CFD69QftsdmTZj+7PwwZVRbyq4WutsRyCCff5zExbCmnE3x87GZIHNp5iaGc84DMspQskwElpyEn4R/1IHIDf5naWQiCezAsikPx3D1a355Qu0lvddRM808bQCGbN3L0/4+Rx2PG0NIdLhX0T3iPFGnIjno4atdTZakCsuD9XTjybPEO2x0T7opJH0kdz66ZAwaxaLnRazGYOKssmMFW1uPz9qo8w8/bgDqsVXIi022iDIZUXxvoQNO3bMNuwH+JF4SRDVOWOQ6lWHNIC+Dt9ZucBDfaIsdeJlewYzaFNH1Ofkm4Gwx4M/IPTSpU6LAHZy4ABuzIiukM3qzh0yKNLAp9ergPYHlbBvI5BKH8DYeJnEkzcNu7MxlNTkTNOeSG2EGyVLU45CDUvUgM7b9IxchGCENWiw3tJlIe27qJJaNrqh2KHi3Um2wR/pmKY8
 Tmx8thDS
 VPs6UBmipGMCX3Cv628IkjfuSaxGSGjCzuvJz4qW/7IfN8b9q83EcWZaf3x3p8VKA59gQXhMsh5PfKiB0ZNj1DXhyRpk10Hyoj8L84uDC/4T0A1Lge0QTvDtgYwrOtJZp6WzIy1/tnOIz25Hmi3356xwW3okELC4a0/oG3N/u3FK3BaJo2/SlWbp5g9NsJGVul9zVPjkWGLeBWYIE6SirwECyUAm98wtv51HF+7xeAL5oBC80Pyk1PQhHmOfgHwScaCAUkhVin+SvdT4bFTiwzvdIwzr+RlxU9YVLixtA0wGJ5oN9Po5VdO4U+1jLnwTaV/CUrNt+pV7tif3RK4ymhCWQgm0bZ3TyGWVjCtdYD3/y6Z1myxKM0Ju/vzUMrulqqHQLu0ME6n/g0jYw2H9wllIOiMoh+06djTwzKOTDW52NZWEEVycnyBJ3pOjS1zXUtiWe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chen Linxuan <me@black-desk.cn>

Introduce helpers that acquire a referenced struct path for a task's
executable, root, and working directory. Reuse them for procfs task
links and AppArmor executable-path handling instead of duplicating file
and path reference handling at each call site.

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
index 3dff299bfe1b..1ddec096eb59 100644
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
@@ -1762,16 +1741,7 @@ static const struct file_operations proc_pid_set_comm_operations = {
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
index 691cef038d1e..dc125564f536 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4222,6 +4222,7 @@ extern int set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern int replace_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 extern struct file *get_task_exe_file(struct task_struct *task);
+int get_task_exe_path(struct task_struct *task, struct path *exe_path);
 
 extern void vm_stat_account(struct mm_struct *, vm_flags_t, long npages);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 2142c6f38119..3ceedde9c3e1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1369,6 +1369,28 @@ struct file *get_task_exe_file(struct task_struct *task)
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
2.56.0



