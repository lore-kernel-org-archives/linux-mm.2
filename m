Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E197606A33D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gZYWzltz
Received: by kanga.kvack.org (Postfix)
	id 7FBEC6B05B1; Fri,  6 Nov 2026 02:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE766B05B6; Fri,  6 Nov 2026 02:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654816B05B1; Fri,  6 Nov 2026 02:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 373A56B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:12:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE31C1C47BF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:12:51 +0000 (UTC)
X-FDA: 85403826942.27.33BCE16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9CBD5C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:12:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZYWzltz;
	spf=pass (imf28.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949169;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lPb4xjQbnZy4ZngMC59MHmraHFiUeUrY+PhLP+I563I=;
	b=z+Uspw2xvFd0rJWAFz9ab3kqklSKoWG9UAyBHquIVsBr/Z2aq2/83II8ShK7JZQCItv9b9
	AMO2DxfP0r/yHyhDjjP/LdwFx9Xo+X9o3Y/z+191rEQhjXrYWsnVwGRN2u6DO/W4kKawxp
	aI+q21lldYDycqFzw50/puzTSCZdApU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZYWzltz;
	spf=pass (imf28.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793949169;
	b=W/XZ0rC/+LN5BE9MDz2P2R2/uLXhlZ8FmB7Hrz9ttKpxd5NPIhpARWs0GCCw58v08pMQFG
	SCYy2TF9PFMCReyLextSnlMgc8Au+oClUlqjI4FFkJNCK7keC5JxWI65SEmKJctNSdMzlq
	1Bmu/0V471NFG5BXTwfWcv+9kilNu24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4960605E2;
	Fri,  6 Nov 2026 07:12:48 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793949168;
	b=R9vKaJiMzBSo3VckSKbq3ib/FKaDs/75l6qTTWmvYugnT4wb7X10dIp3XyvpKbSbxEYr
	 2jzXh17V8ssZFGtpObraoGGyOfSEMaGrg1qgyLdWbwUL6qB8aG4sUz0Uz/H+kJ0zArKet
	 OjkSWyd66ROKrkgZnEmsO3igbFe1t/S1BWqSYeKwI9fJSScePcnjlMZEVfji2sp2p6SVS
	 iDNvHiKe5KhLatnO0V0+9urpyDl6hhpDD5+2YZFXWCz0ypJS/wX9NUA+h4qa9k+755XEk
	 pdr5BoopJYH0e4vW0D/PXhiNsaxXB6qiP0dhIBRz8VTFyJ5dnPt1QY33rF1ExCVCg9Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793949168;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=lPb4xjQbnZy4ZngMC59MHmraHFiUeUrY+PhLP+I563I=;
	b=MZ9vx9qiTFmUteTBwa8RxwkO41cUWPDDn8oR1i0Rgz50MUjWQaqmNssxNOddl3FgZnP4
	 5gU+p/7MIXFuH/R1zTp7s/+zCW/1mz2cE8ng0+ThVn9lZinNMPCo9vxKCGSZDeSJDPE5E
	 Y6Ibmf19H49mrh3rTGMAurtPqHhCnY87GRYB6sM+jFFLuEmzZdrC+Yvjz5jRFdJHMqaRH
	 OTB0sICfmXxW7UIsGQOresMSrsvNv2kEBX4MfWyxip40iZlop9H6Rh8ACMuPIAVcPlNlz
	 EUsMCIihY/ng5brGrx9zDFqU/RzaIXRV8BndS0yyQMTHovnQrru/3b+owynPILQ0LWg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1CD951F0089F;
	Fri,  6 Nov 2026 07:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793949168;
	bh=lPb4xjQbnZy4ZngMC59MHmraHFiUeUrY+PhLP+I563I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gZYWzltz+mcM/ZztyaUZ00u4x+YgMqmJZ4YguYZooFS/LHWcEj6q8RyMIstSlmEKK
	 I1kUmQWKiiu/WDCFPisKq9XnOQyitSYF8fmbDYSaPL2qc9N6N06imkl52VJ0ZE8B/Z
	 iNcQZccLy1xkCDjs44vTPYjl8GoNbdTQg9ZaTHhPu0wKHVv4Wmgl0hSxwYGPvwaICv
	 EJP9kRAGvrWNHLUrhGSgyUpMClfjPVo4yHnj7qmIUlPMAfC4Z8Eym8rvVZZocwx+oq
	 paYYlSHfyIRey7K4v7+BU5U6W66/JoCk77RB8boagxuUzVpzBZ/P8W42GTMAArG8JT
	 2BzDfSq+lnr+w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7F87045C30;
	Fri,  6 Nov 2026 07:12:46 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Fri, 06 Nov 2026 15:12:21 +0800
Subject: [PATCH v5 1/3] fs: Introduce task path helpers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-pidfd-get-paths-v5-1-3147ce6571cb@black-desk.cn>
References: <20261106-pidfd-get-paths-v5-0-3147ce6571cb@black-desk.cn>
In-Reply-To: <20261106-pidfd-get-paths-v5-0-3147ce6571cb@black-desk.cn>
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
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6569; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=fejmaqYx+VSK8t0txnhVUB5ud+lNikVFyW/NI77QvBM=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBq7X3sxic4mYoTVINaqlB0ssKipbPxjb3zC+ppx
 yEy+h1PMk6JAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCau197AAKCRB2HuYUOZmu
 i/o6D/9FmrMv3vjOvnvwNZXk6TGreYJuhm3poKxBrm55pWBTwQ6b6mpi67U32UGoRC0wflc60gv
 2cnPMGYpHLz8fYpUTLwT44eabS7SJuT9m479Jdd8InloZiRU+ZF8HhH9vDO7ysynfJLRVSRv2jL
 aHnbdJXBE+RgwDS7M2oekdX5Kf1Iur9j8RzgPRZ5XqWenO3liGFOl0kAd+/PwIE5yLu/E/SgoFh
 TlGY9BoUWXScGBO4OSm3+BrNTJW6Rv+JgCP3+yegWm8k54iuExBpGNDkPpeeykUWL247d80QDhT
 so0Myy9a//ZOrFe61IfKENcAXQ9AQRqcVfYOjq5rDUieCvjj8DzYQtROcJvMiwrA/K9kVXtWaMf
 MkPXn+2RCj8i+WLoayIx7auaErqCDxyNda2GtBl+pjC/a4pWfSfgbSuVO5L8pWdRr6i2Dp2ztX8
 0lA0fJuZSU7+X8j5WmiD7nUAr5PiRJoYG8xpxISm8V8o3S583POdFVI1KhrZXEqPRvMLHAdkX6o
 Xd2plcXXM4psP2IbVU+KwWVGaW44dEdvAujq82rHUIZhd1PsAkhoySegrg+x+H8MGDW196iX1ve
 /nKxHv5hpZvH56HILAHWY8+BQSEmDmKqX61iieXRrmNB4ev0Q21mNQzxM6nsuVaZFhdaNiUeeQe
 C8Wf6oBy11gJoeQ==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
Content-Transfer-Encoding: 7bit
X-Stat-Signature: njhcf71uunojs58ke8w3gomifc8ti5o5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9CBD5C0006
X-HE-Tag: 1793949169-756870
X-HE-Meta: U2FsdGVkX1+wTBwCP/tBjK8ZL9ABVXuAgSBHhrd98V42KAbz3hUMuvxmHFFoTFolD26ZEU7YRdX+LSSAPmreiBi+W2yzMmLV3z5U3Zc6HgyCPJMA/0O+BRc7udro2kQ/M+QBvkgcg5uXTL4isKBhCXRcV9xrvFsawy2Mc9CCA3ImUWzvph+wjS/0oDFQxk0UWsTQtRMOJlfwad8zcHvtHdMHO/nPU6O2rdigydT2bQv1UNECJtCVcXQzG/8rHE37PmLg4O21BhRxGs3UTSxFq2BqWyhsE/Frl6Y0KgcoGIZL1OTUsj/0SFwXk1ggEKDvXkn0Oy2qlLrJr7rGBWcY0HnDhXDaVG+KHwiHOtYGInpgAnysoaaqVa6VXW4H2wVoHc/G7gb+QoUD4aDFUtJTSeVOm/V1xZeKuSKiN8eaYuJhHxL2f79IXNqz3GCFo5MfE5dXdksFIxEpEh/NU/G1sWOYtTdWXaleV22P3m0rrR1Jc29qxpo9IwFX0siNDxaMNyEtAwhkwkBjqSuwZt6QhfNpdGB5er/kbjWEGl2VMzXHLRYqNsIyx4bl/vLacXhmz26pec0t4DeuwA/Y5uv+7dPEqDFSi9AGpgryqjHGoLy+B3VrYU0QtK4iLxVZpxXnjPQbMQaOEYrfVDMUGD2vEhnQ33cWtZpDjLqM/7EmOeUablNhJqQIeN51PpDouRDHKFs2H8ZTDuhqs2RKCbIeixld56B+oxEHqInoWGkDRRZcKnsXB0oNPyhRz3mk8LXKPgY2Lc4OUR3DWCdSfJoMzEGg+EwdUd1JBBt9mj2ZIkgZeW0WueLOn43Er794jDpoJr/axycsY5xb7cgkCs9BdekQvvaox/mI46pMrfACEKMlfjvny50PIeahlCVmdB1lxfqUeBotYPu4WIQFGdQ8ai7QwSL1XBq4DH2ekAcUyP+DG8Kip3ioSVsWQSUM6nrBCW9f1X4cd3HFQe5hTmR
 m/ktLgyQ
 +YuKltDIHc946XuyVaf10IUDJDBGauWTV6mHtr0YpFKancdU2b8oZ/2a8uFAcvnhjF+JfyR81WdfT0w7poqZeOr0Q5JW+ivlkr69ZEW2z8DhwxLYyILA3hp+zpBeXg+krzgo7rCCyl6CLPtFSZjeDiHTj9uJhCokwGwL1OZ+ehkMB3S18N5IncxUq0EgucrlDTQLp6W001LMSFK48PPqmZtacdv7djH6a0nWtbwdtSOUswOkaDAYmhBffNHh9GyKLHfkVFK/5ac1A1fmP4R1EHlSAQyszIjDEVAjZiUbJJMBleBjrp/4Jml5qgAW/upJYpBYalKaVdFhuTtn7rE1sb1XUjJZJFDSdAzZPKrioeadTyPF606e/YS9z3/BgEDyO9CVvTNka6WX+FGLSecHOxgFexerWk+mgD8Q8Ji3sMUz9ry44MYXBp3mUuOaTlJ6ZhY3r
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



