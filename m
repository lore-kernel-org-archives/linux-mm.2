Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B68AF94CBE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 11:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647A86B0088; Wed, 22 Apr 2026 07:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F81A6B008A; Wed, 22 Apr 2026 07:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E166B008C; Wed, 22 Apr 2026 07:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41FE16B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:58:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9E61136601
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:58:16 +0000 (UTC)
X-FDA: 84686043792.01.96CBC33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4C06140009
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:58:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jnBPIVd7;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776859095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2tueksW6B63AlVLAgmeWvyMXWYiyJaskMo9TSOBXBQ=;
	b=YBCi2KGiK1l5WIP4qhjHNkswUA5qVK2Q+E7eQJDvuKTD4iLB58IIgtzNfdRr0drbpMSi4s
	TnpJ4LnOjCBPFz7FeYXxaBhW2U/uPZtPfZDVjvjKoLXkPsT0o475K0Z2Vjd225LnPLJCJZ
	8w5Eq67bCsLf5i32FOUvJZjTzq5KrX8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jnBPIVd7;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776859095; a=rsa-sha256;
	cv=none;
	b=qxhI/jvn7s1z3H2hLa11dfNhJEEsFmtHI6/OPQsburBUoMA0O7n6i2YMgBkS7QiuZIm8rX
	WrZhv1qPGljAw6skzhxhVKkB5bHYqSB8agqUguuHnxNnQaLmhoRKOe4Y6UktgNo9InbhVr
	qoVeCk+MhyDdhwScrqrne2aKM8n/Ctw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9031F60133;
	Wed, 22 Apr 2026 11:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB228C19425;
	Wed, 22 Apr 2026 11:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776859094;
	bh=cM9cPH2DCZmZdCi7xoLbSQL3YQeciVQoXm80O1Nkuss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jnBPIVd74nEAAmwRfET7plTicvo1oNKW6RrJ7sBHUUmwy1XfZgZxWisb1h9FPUdPE
	 GoLAagWxTMww5QS8DCGNwWI9kW7G8V0sY4+Jrqnox8VMPSrCwrTAJ0FaBAdrEY/NAu
	 LLPqCuU5IzlBWeRwbSrxO4loMQu4C+x7qFMrml7jNf3ZFYRvRQlwncLAFPBobNwGx7
	 T/VFb1epO3lsbwd5C196Fn03S75Tn0Iw6IxLMkondmUoPwZzd7Qzp3BhOANg7jH/cG
	 /TEpqL0pL/xXJxaqWWqY/gPkQeI4sZQmd+c3kVbQYuH0NRnGf7nL0Abdm/mjbKkt6W
	 rAwEAvy6yBTJw==
Date: Wed, 22 Apr 2026 13:58:08 +0200
From: Christian Brauner <brauner@kernel.org>
To: pasha.tatashin@soleen.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org, linux-kernel@vger.kernel.org, 
	luca.boccassi@gmail.com
Subject: Re: [PATCH v9 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <20260422-liege-klotz-cfd84db12d91@brauner>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
 <20260420141741.2688371-4-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260420141741.2688371-4-luca.boccassi@gmail.com>
X-Stat-Signature: xftogog4ozgtzhitaqmk394yk8s58977
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C06140009
X-HE-Tag: 1776859095-378956
X-HE-Meta: U2FsdGVkX1/jJtziKCvcZGZXembnNPhzGftmKpPB4umq54EWCze18HVATVMr8WAMjG48dICymLZLpupxbFBTvFm2GLeVeJXfoD0CbN+Z5W2s9PcNE3qwADu/daDpwZWLfl3S3ALjn3sluq9x7jiPz4VTa7GS/X/kCwO9xDNIxnhrzZEjnJlTjgyjAXy55vNyfZvHsEB5piEr878Oew0VoIoO0nPrzi/GeW6Kl6lfObmScREWFAohTKo7Bj5uW45HMPb+Hq7TP05Z0+5Bg/XQpb5QDLm7BmglXr7TBICjDq3bjEwBpMWbshU+xIWc4AXZX7vyuMnsOM7UaGnX3Ep/7RwVcm8L1Birlg88we4xm+6T1LCcLSGILkhFfS2zxSkW6uf7xyfH4GSCwVU7rc/ra6CgcQgqXA6YUnO/BFhYUApJN5NOKUVmGj19ei8ZI/4qr+c+RB31d6A9H66Rr8izqHpwoAxHF0Gr9dAXoVJwmScV+SqchzQS0qXfRxBWz5/VjYUtG1rmrva9+B3o76xQNTrU4VaS/D3FGWqnGo9a/sjXVdIsxBiAVZjCPuANWiYah/Nv0IARxoEt9pTJQqhFAZpD/WbLpagQMbbigfmNJyceYInh9qTtNxNQ+x17C54ieB5k3C2qynzPFADW3uTcXw+ZdSzPIm3j5XJ427Q0sLpwLkCYxOe8uy4XjrE93kHY8d2Ne+uCRuPn6u19qpU9J7xxgXlywBrPhICTaL5w2CJPBm0ZdSwphhzwHs+9fgDyX4J5LvM9n3RfCxS26U1rO4/A71NU9mrKBVP/MftIe4A1NbYtqKMptGuSinkLfFNs8xYTBLaiYathnu5d0CKa8vgumV+ge14y91CuEmE0vKku6Tjk4GLPgc2CDSsM2pBYhgAUdIqEO/JkU2CWv1ujsbY11CF9z1uAKUz/DatJAANoDdW+n2g3dMeOwp8DGyswW4WcxzpvGpKV2CDDX1u
 citddeXF
 YnCBM8nw9B3dGyFElrgAw1kn8jrNAPdNfc3sRxktaHELVYXaVCeX9qG9+gQANAE1Cq1Oq7mwm2N4qsYgFsXhDY//3OC/ZkI1GcNPb64WjrEyhFboWnaK57hJ0o2RGuwTAOvGnNPnlQIp42XUdusUKcR3RIAmt6/FxQhLW9KJdIGy77eefkvtT6DdwyTQZ7ROgYnZLjjAeFIYIq9REomMasclnXzBwTZ0LHNQV9PuWSeGIqsQm5rrd5gOjDHFsaMYACO91825qpLidgn1VSMWJ2bU4EdX24Uw+1njLXKnZyO3hcHETjOBKSNxDdewio72dX0T/Xq39HwfIVpX2zayXN/Hb6utIyZebH78M9xdHyMfHcpHP+1aXWvX1PwH+dB37HLfaOVCr44XDRJMMlUBN8GtVbD0MI2INDHVCOGpgiDFoIikAoVOZDkIMk/dqVsDOMJ2eXALEcoRKQ4jx23RWuXGU0chIw/PF2JZ49RdzBO3mbwXlQKw4qw55JEAQvVIytmrvvWtZTcMYgmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:15:11PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> In userspace when managing LUO sessions we want to be able to identify
> a FD as a LUO session, in order to be able to do the special handling
> that they require in order to function as intended on kexec.
> 
> Currently this requires scraping procfs and doing string matching on
> the prefix of the dname, which is not an ideal interface.
> 
> Add a singleton inode type with a magic value, so that we can
> programmatically identify a fd as a LUO session via fstatfs().
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---

Fold the following diff [1] into this commit (and the test), please.

Btw, I see that currently you only allow to retrieve one file per
session. If you ever want to allow multiple files for a session
but single shared inode amongst the same session so that different files
for the same session still compare as identical I added a mechanism
called path_from_stashed() which would easily allow for this. The luo
session just needs to stash a dentry pointer to achieve this. Just a
heads-up.

[1]:
From 7a11a931eaf4766e70c81d32093668ecd60f4952 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 22 Apr 2026 12:41:25 +0200
Subject: [PATCH] liveupdate: allocate per-session inodes

The luo_session pseudo-fs handed every session the same singleton inode,
so fstat() on two session fds could not tell them apart. Give each
session its own inode via new_inode_pseudo(), with a unique cookie for
i_ino (and the upper bits in i_generation so 32-bit configs still get
distinct inode numbers).

Leave inode->i_fop unset. Session file descriptors must only come from
the LIVEUPDATE_IOCTL_{CREATE,RETRIEVE}_SESSION ioctls, so an unset i_fop
makes open() on /proc/<pid>/fd/N fail.

Lifetime continues to hang off file->private_data and the .release
callback; this patch only changes where the inode comes from.

Rename LUO_SESSION_MAGIC to LUO_FS_MAGIC and flip the session_fstat
selftest to assert distinct inode numbers.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/uapi/linux/magic.h                    |  2 +-
 kernel/liveupdate/luo_session.c               | 59 +++++++++++++------
 .../testing/selftests/liveupdate/liveupdate.c | 13 ++--
 3 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 4f51005522ff..afc3f935d00d 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -105,6 +105,6 @@
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
 #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
 #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
-#define LUO_SESSION_MAGIC	0x4c554f53	/* "LUOS" */
+#define LUO_FS_MAGIC		0x4c554f53	/* "LUOS" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 885e1f346caa..2484feaf102a 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -51,6 +51,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cleanup.h>
+#include <linux/cookie.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/file.h>
@@ -380,17 +381,43 @@ static const struct file_operations luo_session_fops = {
 };
 
 static struct vfsmount *luo_session_mnt __ro_after_init;
-static struct inode *luo_session_inode __ro_after_init;
 
-/*
- * Reject all attribute changes on the singleton session inode.
- * Without this the VFS falls back to simple_setattr(), allowing
- * fchmod()/fchown() to modify the shared inode.
- */
+DEFINE_COOKIE(luo_session_cookie);
+
+static u64 luo_session_alloc_ino(void)
+{
+	guard(preempt)();
+	return gen_cookie_next(&luo_session_cookie);
+}
+
+/* .setattr rejects attribute changes to prevent fchmod()/fchown(). */
 static const struct inode_operations luo_session_inode_operations = {
 	.setattr	= anon_inode_setattr,
 };
 
+static struct inode *luo_new_inode(struct super_block *sb)
+{
+	struct inode *inode;
+	u64 ino;
+
+	inode = new_inode_pseudo(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	ino = luo_session_alloc_ino();
+	inode->i_ino		= ino;
+	inode->i_generation	= ino >> 32;
+	inode->i_flags		|= S_IMMUTABLE | S_PRIVATE | S_ANON_INODE;
+	inode->i_mode		|= S_IRUSR | S_IWUSR;
+	inode->i_uid		= current_fsuid();
+	inode->i_gid		= current_fsgid();
+	inode->i_op		= &luo_session_inode_operations;
+	/* i_fop left unset: session fds must not be reopenable via procfs. */
+	simple_inode_init_ts(inode);
+
+	return inode;
+}
+
 static char *luo_session_dname(struct dentry *dentry, char *buffer, int buflen)
 {
 	return dynamic_dname(buffer, buflen, "luo_session:[%s]",
@@ -410,7 +437,7 @@ static int luo_session_init_fs_context(struct fs_context *fc)
 {
 	struct pseudo_fs_context *ctx;
 
-	ctx = init_pseudo(fc, LUO_SESSION_MAGIC);
+	ctx = init_pseudo(fc, LUO_FS_MAGIC);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -432,17 +459,20 @@ static struct file_system_type luo_session_fs_type = {
 static int luo_session_getfile(struct luo_session *session, struct file **filep)
 {
 	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH + 1];
+	struct inode *inode;
 	struct file *file;
 
 	lockdep_assert_held(&session->mutex);
 
-	ihold(luo_session_inode);
+	inode = luo_new_inode(luo_session_mnt->mnt_sb);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
 
 	snprintf(name_buf, sizeof(name_buf), "%s", session->name);
-	file = alloc_file_pseudo(luo_session_inode, luo_session_mnt, name_buf,
+	file = alloc_file_pseudo(inode, luo_session_mnt, name_buf,
 				 O_RDWR, &luo_session_fops);
 	if (IS_ERR(file)) {
-		iput(luo_session_inode);
+		iput(inode);
 		return PTR_ERR(file);
 	}
 
@@ -731,19 +761,10 @@ int __init luo_session_fs_init(void)
 	luo_session_mnt = kern_mount(&luo_session_fs_type);
 	if (IS_ERR(luo_session_mnt))
 		panic("Cannot create LUO Session pseudo-fs");
-
-	luo_session_inode = alloc_anon_inode(luo_session_mnt->mnt_sb);
-	if (IS_ERR(luo_session_inode)) {
-		kern_unmount(luo_session_mnt);
-		return PTR_ERR(luo_session_inode);
-	}
-	luo_session_inode->i_op = &luo_session_inode_operations;
-
 	return 0;
 }
 
 void __init luo_session_fs_cleanup(void)
 {
-	iput(luo_session_inode);
 	kern_unmount(luo_session_mnt);
 }
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c21354dc9b93..34f3ecb21396 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -410,8 +410,9 @@ TEST_F(liveupdate_device, create_session_empty_name)
  * Test Case: Session fstat
  *
  * Verifies that fstatfs() on a session file descriptor reports the
- * LUO_SESSION_MAGIC filesystem type, and that fstat() returns consistent
- * inode numbers across different sessions (shared singleton inode).
+ * LUO_FS_MAGIC filesystem type, and that fstat() returns distinct inode
+ * numbers across different sessions so userspace can compare two session
+ * file descriptors for equality using stat().
  */
 TEST_F(liveupdate_device, session_fstat)
 {
@@ -430,14 +431,14 @@ TEST_F(liveupdate_device, session_fstat)
 	session_fd2 = create_session(self->fd1, "fstat-session-2");
 	ASSERT_GE(session_fd2, 0);
 
-	/* Verify the filesystem type is LUO_SESSION_MAGIC */
+	/* Verify the filesystem type is LUO_FS_MAGIC */
 	ASSERT_EQ(fstatfs(session_fd1, &sfs), 0);
-	EXPECT_EQ(sfs.f_type, LUO_SESSION_MAGIC);
+	EXPECT_EQ(sfs.f_type, LUO_FS_MAGIC);
 
-	/* Verify both sessions share the same inode number */
+	/* Each session has its own inode, so inode numbers must differ. */
 	ASSERT_EQ(fstat(session_fd1, &st1), 0);
 	ASSERT_EQ(fstat(session_fd2, &st2), 0);
-	EXPECT_EQ(st1.st_ino, st2.st_ino);
+	EXPECT_NE(st1.st_ino, st2.st_ino);
 
 	ASSERT_EQ(close(session_fd1), 0);
 	ASSERT_EQ(close(session_fd2), 0);
-- 
2.47.3


