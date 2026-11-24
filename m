Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E74606A692
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fgRqWS/R
Received: by kanga.kvack.org (Postfix)
	id 962D96B0889; Tue, 24 Nov 2026 18:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89DFB6B088B; Tue, 24 Nov 2026 18:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E7A6B088C; Tue, 24 Nov 2026 18:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 408256B0889
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B89E5A0DB5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:07 +0000 (UTC)
X-FDA: 85471532454.08.4882A1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E392714000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fgRqWS/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561206;
	b=yXKZfPL/kVm/q0Oo6TR7cO8xH3GRIIicW2LhKXdpKY6c9htITerolV0FeXAnaiAbRrxHY8
	2zQRkJF9pBSqkx0Nv2yhUopPGFJRK9kHKIUkGwAGxWmTBTbABaSpDa4F1cvfEpV37t1VOM
	/ZKMQvx9dEsj84sHJn0QYkIsZvA1B9w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5doYQdvM7x6zP0318TAtNMatVTO+WEyVEwtQ807FWs=;
	b=bRjkfodrGO3EabvVdUcst/7ZTb2MQvwSoyEyS2G7HALnhXyO9OFtUDtHXJFiF+G3lnfjiV
	StNiqVu5PO16+JXxaVl+wU7NOC1dOrWD3K/1qtwKTr+eZ/nXlxl75esMbAyQA8TDdY0cR0
	EirNkm8zwCMPLp+6f1p1u10yCfVQ7PQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fgRqWS/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4458940A30;
	Tue, 24 Nov 2026 23:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAAF1F000D1;
	Tue, 24 Nov 2026 23:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561204;
	bh=F5doYQdvM7x6zP0318TAtNMatVTO+WEyVEwtQ807FWs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fgRqWS/RyLrns3jN+wA/5OmKRdxgLSO3trncjc81KZ5ov18DCGO98Gs9axvycn2XS
	 4Y0ol1aKXkDKgt3J/KhdMPy31sSwTsXcl33oag/r/+GdA8f5Jix+7JIupGapnlv4Ce
	 cAYkQJ73iqp+0kXuQTnM27EDLHd6zSoM+touSDWMc/UE3zmt/baERD5l6gqdET8/ur
	 ZsccUsFE81VBgHVfU7ohhhVHne4JCKo4jxS4gp/n0pQBf6ew3qbf1sg2M/EmK4WhS2
	 ZJ82d9RVuRfe51EeazEm6ep9EubANzsp4a43lSQJvVushzvGFleTUvRRyvCQOyP5DX
	 VfvKGq2XH6mdw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:32 +0100
Subject: [PATCH RFC 09/19] lsm: add security_bprm_revalidate_files()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-9-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=6414; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WEDmOf8hqdpHNRkJ7SSWpynxC2G5RY7nFMnrQtHIpLs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziR249U4yTquddcPpvToOl4PWfgg9WeSbt7to5T2rf
 W+izM6s7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjINX5Gho6qqM/Xz/XM7lJZ
 03p/ZbXLnNe+/Px8hk/PbLOROTPBToGRYUFB6aMn0vt49zC0aqSf+MVkJbJy98dmrfXPLq2rM3X
 2YwcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: E392714000D
X-Stat-Signature: renadnqhxd5up8wkhmgzotpqz3ja5bo9
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795561205-948300
X-HE-Meta: U2FsdGVkX19q2s7DWpwvQ2l9HuKVLQj14CFgOCqufVz99VKLHHYHQ/w3bh1f0/ig29OT6cGDImnvVK2MgKCxB2D6+ivXynzccug7uJvW/Vc84iS27dfOjWxaRjAjHdE2AhJN4d/mDBF63r22WqwS9WUBLbbLGa15RQ9Q8NRllDq6iUtjXN+otb7sKQ8XaYFaACtT/+4CjFVhDdY1tWjOG3y3RSMLR2DnjGDhNu1JF7hJ0/9VoqCWDJA2dbbJiOKeqie7Y1pD+Jx1uPC9kg7dqQ6RI2u97nuPf5eHWgE0rgJ3VUOZNdga67rFnaax74HMLHHsFrE45lJLqbP9OarJfZV9TNFA1SOFmaqL3b44Fpj3TAIkj6t+kCq9zzWREVsHhBxQMMlge7O61xwJUs4JVz/OBaQrZ1IpobU9qFk9JFMIjEBYC6j/lxFk/Fzs+on65Xna9DdIwRkH0lZ8SArJ1JNBOWcxvQBmKBuQMesHBfAQbmfhWO8Ub7fwhsSUjQxpQsKsXiK+dkBqN7CHPM8iJIehHqpohXxQbBg028srd3lAZdPuw3RTLW3OerOd4XYTN2N5gVIO5mAmQ+mDBjbYbFoEgqjJ09+NJL0pF06t07RmBMo59LcAO24Wa80mzB/Fq2sE3Pan7XGPo/zOz3tAuWmUFIe9MBJsN4SYnCj6j48yuywf2MmBz3YKvUUftl9WuEUQU8CAcZltr+dnoKIfZJGIhhFNMNQKDqQWlGJFNnmbnpYyMbLdtqXZCsNICdky4HuBLh+R552KZI+aFSzGgm6vQGra424rddm6gXeKRFExBAvC2dboYzL5oMUNCFDdcuw2JbCuuRectDDrQ39P6abFN+Aa58zAUf5KaQCYp3QboAkN65wy3NJXJhZYw8MqAajutdJQJstBZbB3+4SsoWVzdwCFPgA8/ecaRH4hIrvfZILvaLzHyy0lbf4Xz52equzxYP9mrxnm9DgWOBq
 GQVLroIe
 rPqDeVxRyDNA9t1WIbk70h1aWUngNp+/F1ihmz1EWESFKth11IFZpOF1eOw8X9OFihxhM7alBtryuIIB4CQPcqwBarE9pjuoIrw6j6nxe5PavIlYNOHrve0twVrzQeFgdHcS7ygN9X321UhVlwOknpY0wkVKSnq0Ak1u3BsNo2wbwlKCvYfHfxXkA26MKDMGGIgVVycxbt4OyaqpRpNehvDob+Y+V2RY0KU3IV3MS0pq95DoEyhOEVa+8SV+fyYf0zEXde+EQ4NuMh4Xd5Ngw9IJNAw8Mcf2EeRfEu4rRZa/PsNf8b0ypYXU7nDcG0rFc453eVFDZvCYsBhnN5PvDNJ2WyZMgzKfYhZZuSyB1xzBKgvcQSuuIh8oQpdCEN3s2CV7WhXBswnM03ncjhuVmxEr+N6j+Utyylde4m2RvBOQCxnplTCnMZWQo6TfQLkInBai5P0YzZbpMurTXGxuCVzPL0MkgviB9dX3pZoH80QzNOs5nL7rF5Vx6KQxbLeCCdbWPRZuor//qTHO4ca/LcRbsWLuOpzxySH7jYjaJgfepads=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SELinux and AppArmor revalidate the controlling terminal and the
inherited files during exec when the security context changes. Files
the new credentials aren't allowed to use are replaced with the null
device or closed and a controlling terminal they aren't allowed to use
is dropped. Currently, they do this from the bprm_committing_creds hook
which begin_new_exec() calls with exec_update_lock held.

Closing a file calls into the filesystem's ->flush() method and that may
block for a long time. For the same reason commit e780259b54e6 ("exec:
do_close_on_exec() before taking exec_update_lock") moved the closing of
close-on-exec files in front of exec_update_lock.

Add a new hook that is called right after the close-on-exec files have
been closed. At that point we're past the point of no return, all other
threads are gone and the file descriptor table isn't shared anymore. So
nobody but the task itself can install new files or acquire a new
controlling terminal until the new credentials are committed. And
nothing between the new hook and the bprm_committing_creds hook touches
the file descriptor table.

The hook has no users yet. SELinux and AppArmor are switched over
separately. Note that bpf lsm programs can attach to it like to any
other LSM hook.

Fixes: 6650527444da ("proc: protect ptrace_may_access() with exec_update_lock (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c                     |  3 +++
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  5 +++++
 security/security.c           | 27 ++++++++++++++++++++++++---
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 87b78fce609de..855437c352137 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1203,6 +1203,9 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 */
 	close_cloexec_files(me->files);
 
+	/* Let LSMs revoke inherited files the new creds may not use. */
+	security_bprm_revalidate_files(bprm);
+
 	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
 	 * not visible until then. Doing it here also ensures
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 87d9d06710cb2..c1bb7501d530d 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -52,6 +52,7 @@ LSM_HOOK(int, 0, vm_enough_memory, struct mm_struct *mm, long pages)
 LSM_HOOK(int, 0, bprm_creds_for_exec, struct linux_binprm *bprm)
 LSM_HOOK(int, 0, bprm_creds_from_file, struct linux_binprm *bprm, const struct file *file)
 LSM_HOOK(int, 0, bprm_check_security, struct linux_binprm *bprm)
+LSM_HOOK(void, LSM_RET_VOID, bprm_revalidate_files, const struct linux_binprm *bprm)
 LSM_HOOK(void, LSM_RET_VOID, bprm_committing_creds, const struct linux_binprm *bprm)
 LSM_HOOK(void, LSM_RET_VOID, bprm_committed_creds, const struct linux_binprm *bprm)
 LSM_HOOK(int, 0, fs_context_submount, struct fs_context *fc, struct super_block *reference)
diff --git a/include/linux/security.h b/include/linux/security.h
index 40831fab54709..e1a85b2f7005e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -360,6 +360,7 @@ int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
 int security_bprm_creds_for_exec(struct linux_binprm *bprm);
 int security_bprm_creds_from_file(struct linux_binprm *bprm, const struct file *file);
 int security_bprm_check(struct linux_binprm *bprm);
+void security_bprm_revalidate_files(const struct linux_binprm *bprm);
 void security_bprm_committing_creds(const struct linux_binprm *bprm);
 void security_bprm_committed_creds(const struct linux_binprm *bprm);
 int security_fs_context_submount(struct fs_context *fc, struct super_block *reference);
@@ -753,6 +754,10 @@ static inline int security_bprm_check(struct linux_binprm *bprm)
 	return 0;
 }
 
+static inline void security_bprm_revalidate_files(const struct linux_binprm *bprm)
+{
+}
+
 static inline void security_bprm_committing_creds(const struct linux_binprm *bprm)
 {
 }
diff --git a/security/security.c b/security/security.c
index 4727b8347fc4e..f340880ce77ff 100644
--- a/security/security.c
+++ b/security/security.c
@@ -834,6 +834,25 @@ int security_bprm_check(struct linux_binprm *bprm)
 	return call_int_hook(bprm_check_security, bprm);
 }
 
+/**
+ * security_bprm_revalidate_files() - Revalidate open files during exec()
+ * @bprm: binary program information
+ *
+ * Revalidate access to the controlling tty and the open file descriptors of a
+ * process being transformed by an execve operation, based on the old
+ * credentials pointed to by @current->cred and the information set in
+ * @bprm->cred by the bprm_creds_for_exec hook.  Files to which access will no
+ * longer be granted may be closed or replaced.  @bprm points to the
+ * linux_binprm structure.  This is called after the point of no return, once
+ * the file descriptor table has been unshared and close-on-exec files have been
+ * closed, but before exec_update_lock is taken, as closing a file may block in
+ * the filesystem.
+ */
+void security_bprm_revalidate_files(const struct linux_binprm *bprm)
+{
+	call_void_hook(bprm_revalidate_files, bprm);
+}
+
 /**
  * security_bprm_committing_creds() - Install creds for a process during exec()
  * @bprm: binary program information
@@ -842,9 +861,11 @@ int security_bprm_check(struct linux_binprm *bprm)
  * transformed by an execve operation, based on the old credentials pointed to
  * by @current->cred and the information set in @bprm->cred by the
  * bprm_creds_for_exec hook.  @bprm points to the linux_binprm structure.  This
- * hook is a good place to perform state changes on the process such as closing
- * open file descriptors to which access will no longer be granted when the
- * attributes are changed.  This is called immediately before commit_creds().
+ * hook is a good place to perform state changes on the process such as
+ * resetting resource limits.  It is called with exec_update_lock held so it
+ * should not block on a filesystem.  In particular, it must not close files.
+ * Use the bprm_revalidate_files hook for that.  This is called immediately
+ * before commit_creds().
  */
 void security_bprm_committing_creds(const struct linux_binprm *bprm)
 {

-- 
2.53.0


