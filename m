Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7F2608B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Leh4lFWc
Received: by kanga.kvack.org (Postfix)
	id 1A25D6B05C7; Mon,  2 Nov 2026 09:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1528D6B05C8; Mon,  2 Nov 2026 09:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36696B05C9; Mon,  2 Nov 2026 09:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C65B86B05C7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:50:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 510218011A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:50:24 +0000 (UTC)
X-FDA: 85390464768.22.2D64FBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 866A3140003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:50:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Leh4lFWc;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebvEQnb0XjU4/bR75aoGaJ+PY8AtQSuZHOmX6V9BBlw=;
	b=PiavoWLj5PZVdQhgOwfJMaMaR0ENjOataGoOBQKxe9ZjFJTH3SjkjOALEK09E6Myxdtrop
	3y295U35BH15K8JJWWK3WITXA57JnchC5nGJeEUBAfp8Gsf9g5f9xkkxqfqv5wCXVnTeoA
	ejCAhD8wQx7Co7xWSo0BrRwrJFgQiqM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Leh4lFWc;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631022;
	b=pa6rK81UAThHM7Kp44EfDISv4OZ7cn+mkNpHj9nzaij+Pvgoxz3wTOfGgsty8svz06U6k7
	3nbUbLaeYNT/GYP9hr3ydiJOc1vWWA6xEyZWaMefcSlRQNO1t2xjn55LYburA9Y24gM/GS
	vRBncDXDS7uo1kBfeNxbsTs0F+dkdZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDF8D42AB9;
	Mon,  2 Nov 2026 14:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621161F00A18;
	Mon,  2 Nov 2026 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631021;
	bh=ebvEQnb0XjU4/bR75aoGaJ+PY8AtQSuZHOmX6V9BBlw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Leh4lFWcaDkudB8K0W1+tAAVX2Tx4WaUFMFl8/EGYGDrBcItphcFGeQE9d3NgM4Nd
	 kCST2YcKLcDOPSUeMLX4z+IEm6ptFwYOHs+ICCWiXPtW/AZddjqL22nIrviPEBeNWo
	 D2ogC2xZzEoRQzukmerirab5JFuFqnZE1d6JS8dhkDZKDv+ALNIfxQT8cuinUQBFV4
	 9WKCTemb9Oe/3tnpl9DND7JZROuLOCyOmc5SMOq0mgfEiD8AdprvgwQr3pzCplERqS
	 WwsUraHZceu0sYfLdWRfJRtIXVdaT+vf2JDr+xExneMNcIPlD9qKN/zm2I9dePyLvR
	 Zn0/J4qqK/xBQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:44 +0100
Subject: [PATCH RFC 04/16] proc: let procfs own the seq_file of seq_file
 entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-4-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
In-Reply-To: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 866A3140003
X-Stat-Signature: njnw9qsdakwyesjifyqjfdp6g77y7rd5
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631022-642121
X-HE-Meta: U2FsdGVkX1/rL+oaUt+d+2GHhiu3Rq0Ks4q5HAFITuyNlXejUP0rFh3wiw6AcsOJw1/uvOHwYBoySid907T6XSnYhWPhY+P3BOMkGJE/HkvMMetD7Dxw62N+BNhbfM/SkmXrC4ztFGLjpcY0tcLCxlXd/bsxuTh02txOW+uhLo7rDyd6Ix97nwhrr384qIFr2zKISnzADdwO/w3p0z7scIVm/0Je/iwo6tEpfBFc/g9YcjXDlsOaMBCHBuxkjemW+AiR4Dq+q3THVth3twIz+U7YOd14mFBencmvIufY9zi7pDhSqhvmveKfMZAlFWgLcEporfEcKhVbmQKxOkONXfJ4/lB9N851QMLLsrqrf2LHKu8RVLELKbgJBUSMrJ0WRhZmGKa/XBFCpIAUxAjylMVbrH7B8v6ya2NHLNyrfMLIo6rjusgbFt9BwQs7FPNvyVNesRFGblzmmEBUV/g89yEJUSPm5i47g97lrDaX9io7/Ht6webhVwxXe9xu90ndH7RPanVuOu78sHn2BkUY8ePAO2JlyDsPi5R0bpClDCFc5lZ30Dx9Vc0v4RkFomaJ4oKuyli7UJ5QC0k6yIGGNhRj43pILh6fDttTFHKFTt2cjXI+RSzkUCfteEx6u++hlovXC0E8Hv1IrmPupZudRWPASRyRXNeduJ8LUzAknE198YUvzbOMpEXt3awtNW3SWjFLSE6QF1CBN7lXWnV0WBazXSt8KX85D4iWI99SzfuWh7ZmVV/5ebO+pf7OWF7d2xPbmzWO2hF4V1566iJpOPQ0RHwCPnzGnS3dHAcia5ZWXS+tpqZMFQNiwdwsmvqUPybZPlDH6Abh0erN0GyXvb4zYtYVoTCoWP0rPr+xRKSaahlh1GTN6pQBMi+g/vDGxZdpYl4hSNyPtK+I7NiuZosWCTOFasvFFGEWpl4o5UkoqSJE451z7m941iL4Pkb9aeFiHkhp2E1luZBr89B
 tkUST7Mb
 R8TtZQnvW9XggzJve3GZS4KchXRheimpvBjbsorUnDtwiOt+3wYNhimaihpLKbjX7ZNrM/nOhzvR5VyZ+dTYLaEPNifL20mUwj1dx1Pxwr/TymYsSMNB8+QcwQXuK2wyk+HpOy3nttEwxGBG82dyuUp/m/7iOillyuZPrrNE6QBczUiEpRI4EkCwPLd6NojrL/55FARJvoA5slBmNIu7YJWUTuk0/TDgvlE1sL2WPlGM177fS/c8HeLE0m7czH5s+bsZkD0kox1Uet/v4RU2zCsgGTufZ6dwbbu3zxm4D1PkdyVzPOSQzZbdwaP1dL/p5jmsYAyHXu2x5kKITplfMwLNAA9261nvZXETN3TNFMCJU+ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

remove_proc_entry() waits until every call into the entry has returned.
For a seq_file entry that's all of seq_read_iter(), including the copy
to userspace. A page fault in that copy can be made to take as long as
the reader wants, e.g. with userfaultfd or by punching holes into a
memfd over and over. And callers of remove_proc_entry() like to hold
locks while they wait. xt_hashlimit holds hashlimit_mutex, which all
network namespaces share, and addrconf holds RTNL.

But the entry's code only runs between ->start() and ->stop() and the
copies to userspace happen outside of that. So let procfs own the
seq_file the way kernfs does. An entry declares its seq_operations, or
just a show function, and the size of its private state in struct
proc_ops. procfs then opens the seq_file with seq_operations of its own
that pin the entry around every call into the entry, and reads and
seeks through seq_file directly. The copies to userspace happen with
the entry unpinned.

That changes who owns the seq_file. remove_proc_entry() can now finish
while a reader is still copying out of the buffer, so the seq_file
can't go away with the entry. procfs frees it once the file is
released. ->proc_open() finds the seq_file in ->private_data and sets
up whatever the entry needs and ->proc_release() releases just that. It
still runs when the entry is removed, or when the file is closed before
that.

Since procfs reads these entries through seq_read_iter() itself they
all have ->splice_read() now, so sendfile(), splice(), aio, the RWF
flags and kernel_read() work on them, and readv() is one read instead
of one per segment. Note that a removed entry still hands out what it
had already formatted and then answers -EIO to reads, and to seeks that
have to walk the records. Seeking it failed with -EINVAL right away
before.

The seq_operations of procfs serve both kinds of entries. For an entry
that only has a show function they do what single_open() does, like
kernfs_seq_start(). seq_file's complaint about a ->next() that doesn't
move the position would name procfs' wrapper, so the wrapper checks
that itself and names the entry's. An entry that declares a seq_file
and also a read or seek method of its own, or one that releases the
seq_file with seq_release() itself, doesn't make sense, procfs reads,
seeks and releases the seq_file itself, so registering it fails.

No users yet.

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  36 +++++++++--
 fs/proc/inode.c         | 167 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/proc/internal.h      |  16 +++++
 include/linux/proc_fs.h |  22 ++++++-
 4 files changed, 219 insertions(+), 22 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 761f9958558f..eff5c38e2219 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -434,19 +434,41 @@ static const struct inode_operations proc_dir_inode_operations = {
 	.setattr	= proc_setattr,
 };
 
-static void pde_set_flags(struct proc_dir_entry *pde)
+static int pde_set_flags(struct proc_dir_entry *pde)
 {
 	const struct proc_ops *proc_ops = pde->proc_ops;
 
 	if (!proc_ops)
-		return;
+		return 0;
 
 	if (proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
 		pde->flags |= PROC_ENTRY_PERMANENT;
-	if (proc_ops->proc_read_iter)
-		pde->flags |= PROC_ENTRY_proc_read_iter;
-	if (proc_ops->proc_lseek)
+	if (proc_ops->proc_seq_ops) {
+		pde->seq_ops = proc_ops->proc_seq_ops;
+		pde->state_size = proc_ops->proc_state_size;
+		pde->flags |= PROC_ENTRY_proc_seq_ops;
+	} else if (proc_ops->proc_show) {
+		pde->single_show = proc_ops->proc_show;
+		pde->flags |= PROC_ENTRY_proc_show;
+	}
+	if (pde_is_seq_file(pde)) {
+		/* procfs reads and seeks through the seq_file itself */
+		if (WARN_ON_ONCE(proc_ops->proc_read || proc_ops->proc_read_iter ||
+				 proc_ops->proc_lseek))
+			return -EINVAL;
+		/* and frees it, see pde_seq_release() */
+		if (WARN_ON_ONCE(proc_ops->proc_release == seq_release ||
+				 proc_ops->proc_release == seq_release_private ||
+				 proc_ops->proc_release == single_release))
+			return -EINVAL;
 		pde->flags |= PROC_ENTRY_proc_lseek;
+	} else {
+		if (proc_ops->proc_read_iter)
+			pde->flags |= PROC_ENTRY_proc_read_iter;
+		if (proc_ops->proc_lseek)
+			pde->flags |= PROC_ENTRY_proc_lseek;
+	}
+	return 0;
 }
 
 /* returns the registered entry, or frees dp and returns NULL on failure */
@@ -456,8 +478,8 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 	if (proc_alloc_inum(&dp->low_ino))
 		goto out_free_entry;
 
-	if (!S_ISDIR(dp->mode))
-		pde_set_flags(dp);
+	if (!S_ISDIR(dp->mode) && pde_set_flags(dp))
+		goto out_free_inum;
 
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 66a3688757dd..8425465aae5d 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -218,6 +218,110 @@ static void pde_unpin(struct proc_dir_entry *pde)
 		unuse_pde(pde);
 }
 
+/*
+ * procfs owns the seq_file of a seq_file entry and only calls into the entry
+ * with it pinned. A read copies to userspace without the pin, so a reader
+ * that faults on its buffer doesn't hold up remove_proc_entry().
+ *
+ * An entry that only has a show function is iterated like single_open() does
+ * it, see kernfs_seq_start().
+ *
+ * Like ERR_PTR(-ENODEV) in kernfs_seq_start(), ERR_PTR(-EIO) means the entry
+ * isn't pinned. If the entry returns it itself, it is unpinned right away.
+ */
+static struct proc_dir_entry *seq_pde(struct seq_file *m)
+{
+	return PDE(file_inode(m->file));
+}
+
+static void pde_seq_stop_pinned(struct seq_file *m, void *v)
+{
+	struct proc_dir_entry *pde = seq_pde(m);
+
+	if (pde_has_proc_seq_ops(pde))
+		pde->seq_ops->stop(m, v);
+	pde_unpin(pde);
+}
+
+static void *pde_seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_dir_entry *pde = seq_pde(m);
+	void *v;
+
+	if (!pde_pin(pde))
+		return ERR_PTR(-EIO);
+	if (!pde_has_proc_seq_ops(pde))
+		return single_start(m, pos);
+	v = pde->seq_ops->start(m, pos);
+	if (v == ERR_PTR(-EIO))
+		pde_seq_stop_pinned(m, v);
+	return v;
+}
+
+static void *pde_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct proc_dir_entry *pde = seq_pde(m);
+	loff_t old = *pos;
+
+	if (!pde_has_proc_seq_ops(pde)) {
+		++*pos;
+		return NULL;
+	}
+	v = pde->seq_ops->next(m, v, pos);
+	if (v == ERR_PTR(-EIO))
+		pde_seq_stop_pinned(m, v);
+	/* seq_file would blame these seq_operations, blame the entry's */
+	if (*pos == old) {
+		pr_info_ratelimited("buggy .next function %ps did not update position index\n",
+				    pde->seq_ops->next);
+		++*pos;
+	}
+	return v;
+}
+
+static void pde_seq_stop(struct seq_file *m, void *v)
+{
+	if (v != ERR_PTR(-EIO))
+		pde_seq_stop_pinned(m, v);
+}
+
+static int pde_seq_show(struct seq_file *m, void *v)
+{
+	struct proc_dir_entry *pde = seq_pde(m);
+
+	if (pde_has_proc_seq_ops(pde))
+		return pde->seq_ops->show(m, v);
+	return pde->single_show(m, v);
+}
+
+static const struct seq_operations pde_seq_ops = {
+	.start	= pde_seq_start,
+	.next	= pde_seq_next,
+	.stop	= pde_seq_stop,
+	.show	= pde_seq_show,
+};
+
+static int pde_seq_open(struct proc_dir_entry *pde, struct file *file)
+{
+	int err;
+
+	if (pde->state_size)
+		return seq_open_private(file, &pde_seq_ops, pde->state_size);
+	err = seq_open(file, &pde_seq_ops);
+	if (!err && pde_has_proc_show(pde))
+		((struct seq_file *)file->private_data)->private = pde->data;
+	return err;
+}
+
+static void pde_seq_release(struct proc_dir_entry *pde, struct inode *inode,
+			    struct file *file)
+{
+	if (pde->state_size)
+		seq_release_private(inode, file);
+	else
+		seq_release(inode, file);
+}
+
 /*
  * At most 2 contexts can enter this function: the one doing the last
  * close on the descriptor and whoever is deleting PDE itself.
@@ -474,22 +578,35 @@ static unsigned int proc_reg_mmap_capabilities(struct file *file)
 }
 #endif
 
+static int pde_open(struct proc_dir_entry *pde, struct inode *inode,
+		    struct file *file)
+{
+	const auto open = pde->proc_ops->proc_open;
+	int rv;
+
+	if (!pde_is_seq_file(pde))
+		return open ? open(inode, file) : 0;
+
+	rv = pde_seq_open(pde, file);
+	if (rv || !open)
+		return rv;
+	rv = open(inode, file);
+	if (rv)
+		pde_seq_release(pde, inode, file);
+	return rv;
+}
+
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
-	typeof_member(struct proc_ops, proc_open) open;
 	struct pde_opener *pdeo;
 
 	if (!pde_has_proc_lseek(pde))
 		file->f_mode &= ~FMODE_LSEEK;
 
-	if (pde_is_permanent(pde)) {
-		open = pde->proc_ops->proc_open;
-		if (open)
-			rv = open(inode, file);
-		return rv;
-	}
+	if (pde_is_permanent(pde))
+		return pde_open(pde, inode, file);
 
 	/*
 	 * Ensure that
@@ -514,9 +631,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 		}
 	}
 
-	open = pde->proc_ops->proc_open;
-	if (open)
-		rv = open(inode, file);
+	rv = pde_open(pde, inode, file);
 
 	if (release) {
 		if (rv == 0) {
@@ -544,21 +659,43 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	if (pde_is_permanent(pde)) {
 		const auto release = pde->proc_ops->proc_release;
 		if (release)
-			return release(inode, file);
-		return 0;
+			release(inode, file);
+		goto out;
 	}
 
 	spin_lock(&pde->pde_unload_lock);
 	list_for_each_entry(pdeo, &pde->pde_openers, lh) {
 		if (pdeo->file == file) {
 			close_pdeo(pde, pdeo);
-			return 0;
+			goto out;
 		}
 	}
 	spin_unlock(&pde->pde_unload_lock);
+out:
+	/* ->proc_release() has run, here or in remove_proc_entry() */
+	if (pde_is_seq_file(pde))
+		pde_seq_release(pde, inode, file);
 	return 0;
 }
 
+/* For seq_file entries, see pde_seq_ops. */
+static const struct file_operations proc_seq_file_ops = {
+	.llseek		= seq_lseek,
+	.read_iter	= seq_read_iter,
+	.splice_read	= copy_splice_read,
+	.write		= proc_reg_write,
+	.poll		= proc_reg_poll,
+	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
+	.compat_ioctl	= proc_reg_compat_ioctl,
+	.mmap		= proc_reg_mmap,
+	.get_unmapped_area = proc_reg_get_unmapped_area,
+#ifndef CONFIG_MMU
+	.mmap_capabilities = proc_reg_mmap_capabilities,
+#endif
+	.open		= proc_reg_open,
+	.release	= proc_reg_release,
+};
+
 static const struct file_operations proc_reg_file_ops = {
 	.llseek		= proc_reg_llseek,
 	.read		= proc_reg_read,
@@ -642,7 +779,9 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = de->proc_iops;
-		if (pde_has_proc_read_iter(de))
+		if (pde_is_seq_file(de))
+			inode->i_fop = &proc_seq_file_ops;
+		else if (pde_has_proc_read_iter(de))
 			inode->i_fop = &proc_iter_file_ops;
 		else
 			inode->i_fop = &proc_reg_file_ops;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 41e00c978ddd..d8093451524a 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -97,6 +97,22 @@ static inline bool pde_has_proc_lseek(const struct proc_dir_entry *pde)
 	return pde->flags & PROC_ENTRY_proc_lseek;
 }
 
+static inline bool pde_has_proc_seq_ops(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_seq_ops;
+}
+
+static inline bool pde_has_proc_show(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_show;
+}
+
+/* procfs owns the seq_file, see pde_seq_ops */
+static inline bool pde_is_seq_file(const struct proc_dir_entry *pde)
+{
+	return pde_has_proc_seq_ops(pde) || pde_has_proc_show(pde);
+}
+
 extern struct kmem_cache *proc_dir_entry_cache;
 void pde_free(struct proc_dir_entry *pde);
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 6ad5150020bf..ea55ed85a2d6 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -27,6 +27,8 @@ enum {
 
 	PROC_ENTRY_proc_read_iter	= 1U << 1,
 	PROC_ENTRY_proc_lseek		= 1U << 3,
+	PROC_ENTRY_proc_seq_ops		= 1U << 4,
+	PROC_ENTRY_proc_show		= 1U << 5,
 
 	PROC_ENTRY_FORCE_LOOKUP		= 1U << 7,
 };
@@ -37,7 +39,10 @@ struct proc_ops {
 	ssize_t	(*proc_read)(struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*proc_read_iter)(struct kiocb *, struct iov_iter *);
 	ssize_t	(*proc_write)(struct file *, const char __user *, size_t, loff_t *);
-	/* mandatory unless nonseekable_open() or equivalent is used */
+	/*
+	 * mandatory unless nonseekable_open() or equivalent is used, procfs
+	 * seeks seq_file entries itself
+	 */
 	loff_t	(*proc_lseek)(struct file *, loff_t, int);
 	int	(*proc_release)(struct inode *, struct file *);
 	__poll_t (*proc_poll)(struct file *, struct poll_table_struct *);
@@ -47,6 +52,21 @@ struct proc_ops {
 #endif
 	int	(*proc_mmap)(struct file *, struct vm_area_struct *);
 	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	/*
+	 * For seq_file entries procfs opens the seq_file, reads and seeks
+	 * through it and frees it once the file is released. ->proc_open()
+	 * finds the seq_file in ->private_data and ->proc_release() only
+	 * releases what ->proc_open() set up. It can run while a reader still
+	 * copies out of the seq_file, so it must leave that alone. procfs
+	 * allocates ->proc_state_size bytes of ->private state for
+	 * ->proc_seq_ops and points ->private at the entry's data for
+	 * ->proc_show(). Nothing that runs with the entry pinned may wait for
+	 * something a copy to or from userspace can hold, like the seq_file's
+	 * lock.
+	 */
+	const struct seq_operations *proc_seq_ops;
+	int	(*proc_show)(struct seq_file *, void *);
+	unsigned int proc_state_size;
 } __randomize_layout;
 
 /* definitions for hide_pid field */

-- 
2.53.0


