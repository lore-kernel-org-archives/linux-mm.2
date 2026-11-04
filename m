Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9E16078140
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U9PU/zDz
Received: by kanga.kvack.org (Postfix)
	id F27F56B05C6; Wed,  4 Nov 2026 14:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF7E6B05C9; Wed,  4 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDD76B05CF; Wed,  4 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1EB66B05C6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:31:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56E4C140837
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:31:15 +0000 (UTC)
X-FDA: 85398430110.18.581F2BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9311AC0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:31:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U9PU/zDz";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsYU3gTP7wRg/qADM041CPCqWdlsrAZN9M0Rb8ATmeI=;
	b=RA60wOXPMGyyYRU+AlTS4rjB43/von3xAa7dcEBWcp5798WcwbFkvOmyC3w7zh5hwYzb+t
	M1ls3gRJSAXEkt7E+fCC+0PuNME9uMQ8nfdSxSLa1qxyri/4pkVhb8sO0zrQExquUI5m7+
	m/FNiVwGvrzQbQuYGsP7iSM21/9cre4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820673;
	b=SQuH4QV4Uh1rJ4+t4Abu8RTnZHWx3LGNyWn1ydxGVSqLjvvHEznfEpX3CyztjR5ek8IHWw
	n7DmAys8OsKGHFBS4I70Dgmh1b7xbWhNbwRc3ZzMZ3+fNFT/UNhUe0MOMuA1fPFuKaXYHy
	nX+68vZVzJjz4dO2DtVBW8I/t69NkuE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U9PU/zDz";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21D3660DC2;
	Wed,  4 Nov 2026 19:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BEB1F00A1A;
	Wed,  4 Nov 2026 19:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820672;
	bh=PsYU3gTP7wRg/qADM041CPCqWdlsrAZN9M0Rb8ATmeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9PU/zDzaVAltxYxStqwW8rHvP0jU6OdIi9RBg1wn/JWlBqPV6BYlBzlMWrwMpcJG
	 3eU+qxUPU0LrZr9SXclOLmfymuCTpBaGHMUvrT5A1+NBX3prA1ghZ3FKndVwGcpNps
	 KN1G8MNaJ/W/DN5CsbgTFaIRvKcadOCkNRMwaZGsRchdPUi7hYz7whizdtZ5L0z/6w
	 HHkGlyWCzWRBgJvKrQXQ85V+EgFF3NosOiNXzT2GpDpkYEaE2RDMVF41oo977U2+yQ
	 3w2KDBa0RmzyTMDJmENPI+Czyfs7FkGe2oaV77JLAINAlrOWELaQ79hR1EMtMGhf9U
	 F1UghcZpaf7Pg==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 07/23] proc: let procfs own the seq_file of seq_file entries
Date: Wed,  4 Nov 2026 20:30:58 +0100
Message-ID: <20261104-work-procfs-core-v2-7-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=16105; i=brauner@kernel.org; h=from:subject:message-id; bh=NknAwwkK4L9ER+HlZOPx363jfWosvwxugcFhrl9okcM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bq9kjT1hrpD/5WLWx3bW3utVx21MbjYe2n+ry9bk0 It9M1k+d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExETZnhn97P+FShOdXaZ/Y/ qVlvFXBfZsHPBPZdE7fvejeHacKEOwGMDC3dcqlfe8755Ox78fjpdsH/gldmL1dtm/L357mLC9c nzmYAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dgc41czx3gxwf8eyexre1tidjc763gio
X-Rspamd-Queue-Id: 9311AC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820673-448275
X-HE-Meta: U2FsdGVkX1+EBXw/woFRuUnD8r3zriWwVUGehJa0he7GHGqI7PGAMvnmLoco5ROrLgV4P4XnPH2VRzHlYo353F4pT+5VB/KOvqDCAX22P81P+3EC3LCyv26s0yH/oPk/JG2UjHg70o3aHU4CBVKKYgWS1ADsCXrQdKOXKhHUn8p2qR9uloIe16V2u37Yr1i35L+jMCqCshCpmjjbMQDYzLD3WHM4scBI40wewpx1sUBdKZDGoqRqNxzMGhn5vHnaSn+z5DJ6s7SZ/hlU6vr8YoZy86FNG+DuWe9QI+2lNdanbRv56pf0bMRE5xE3VCFf/kVNOTBGKHYolmP/2wEULieoRTyn4NQe4acM6s24Cc6q6RiKCQj4neNWB0v6oleZYGlKtqIJzcNOzmHp96oBfd6RheGzPi4zphtQ1iW+gCDzQ5sMV0QpYvyz8HNv1/hN4vYBjhv3YN1pLCS6aSwqgMA++jNJKRnstmPz2QWhNXwsSHX+HjVPEodsSjd2aMosi5KbKzbq/vaJ49wAh1UNSlN5JryjB+aEzSkcURCIAVWoX8wVf0VA5pfE90XazMMJC3Qd3htT0huKVYM1E8XRwwFo01hNjczzF5XHJwvzIujK6w/z3HNkdxrBRSl5US4Oair7E6JkUOVL8Y9aGK2DzIbjtMaXwOChy9B36k0BV+MV3NRI5U/9nlqL3JhIsKIl+ICIYJ+Lvtq6k/pjPNJp2Cwi3+8vaS2n1J4wqPO3lhbCEtNiP0uiRYEVXV0EDoVqIdJaM0nzpgIUGx+DjeMOxN8WFtLPSKQ3DKSpJPonHXTsrLhjgTeClYTYLYnpQwolJNj0qG4r7691k4RPl90fmlvBvRLL+E6tDrWha5RYLBM4KgxyUv4LP3DGJveHTDei/r4WobgTfWmc7qabwl8iSOJqiTtFpxtzHsPUVeiNJN0oe9ZXJ3eZDxK7V7t2b4dHdKlIDqaZRvu72MJ48NH
 7Ej9UvUD
 8Ohr+Sh/+VmB011MMJg2FUpthsqVqZ83xVC7oFc53YRMqGjZvmTmWm3PiOtGtBuV7qRrCNlk9kzhsTguwSl5J3fSYVsH322qnYrgxK8jT83qtyhhMOuDDUlWsZvjx2m+XaXPzmXSRZS24rmSd2nakri+SW39L/lywXFBLeJDMj2im2OwZFDQt7MvfO0F9sS33zEwqywMQq6ZWnPsFW2mF/35LinLC2B5HAmYyMRJpn5fozs599ifFQKvgHFk0WpjfTfMeEqIDPoFKbVdLjBnlmheN8P7+SrDvogZ34mFObRrLGP6CjPMMo4p4m8SM5/KRQSGdvo0zEy906UmJ3UoyoRwSNFub+5rRCWMZ
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
proc_ops. procfs then opens the seq_file with seq_operations it builds
for the entry when it is registered: the entry's own ->next() and
->show() with a ->start() and ->stop() of procfs around them that pin
the entry and unpin it again. Nothing of procfs runs between the
records that way. procfs reads and seeks through seq_file directly. The
copies to userspace happen with the entry unpinned.

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

For an entry that only has a show function the seq_operations do what
single_open() does, like kernfs_seq_start(). If the entry can't be
pinned ->start() fails with -EIO and switches the seq_file to
seq_operations whose ->stop() doesn't unpin, so the entry's own
->start() and ->next() can return any error they like. An entry that
declares a seq_file and also a read or seek method of its own, or one
that releases the seq_file with seq_release() itself, doesn't make
sense, procfs reads, seeks and releases the seq_file itself, so
registering it fails.

No users yet.

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  65 ++++++++++++++++++---
 fs/proc/inode.c         | 146 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/proc/internal.h      |  21 +++++++
 include/linux/proc_fs.h |  22 +++++++-
 4 files changed, 231 insertions(+), 23 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 84f064a651e4..59b89e251ba3 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -41,6 +41,7 @@ void pde_free(struct proc_dir_entry *pde)
 	if (pde->name != pde->inline_name)
 		kfree(pde->name);
 	kfree(pde->open);
+	kfree(pde->seq_direct);
 	kmem_cache_free(proc_dir_entry_cache, pde);
 }
 
@@ -431,19 +432,41 @@ static const struct inode_operations proc_dir_inode_operations = {
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
 
 /*
@@ -458,6 +481,32 @@ static bool pde_needs_open_node(const struct proc_dir_entry *pde)
 	return pde->proc_ops->proc_release;
 }
 
+/*
+ * The seq_operations of a seq_file entry: procfs's start and stop around the
+ * entry's own next and show, see pde_seq_start().
+ */
+static int pde_init_seq_direct(struct proc_dir_entry *pde)
+{
+	struct seq_operations *ops;
+
+	if (!pde_is_seq_file(pde))
+		return 0;
+	ops = kmalloc(sizeof(*ops), GFP_KERNEL);
+	if (!ops)
+		return -ENOMEM;
+	ops->start = pde_seq_start;
+	ops->stop = pde_seq_stop;
+	if (pde_has_proc_seq_ops(pde)) {
+		ops->next = pde->seq_ops->next;
+		ops->show = pde->seq_ops->show;
+	} else {
+		ops->next = pde_single_next;
+		ops->show = pde->single_show;
+	}
+	pde->seq_direct = ops;
+	return 0;
+}
+
 /* returns the registered entry, or frees dp and returns NULL on failure */
 struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 		struct proc_dir_entry *dp)
@@ -465,14 +514,16 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 	if (proc_alloc_inum(&dp->low_ino))
 		goto out_free_entry;
 
-	if (!S_ISDIR(dp->mode))
-		pde_set_flags(dp);
+	if (!S_ISDIR(dp->mode) && pde_set_flags(dp))
+		goto out_free_inum;
 	if (pde_needs_open_node(dp)) {
 		dp->open = kzalloc(sizeof(*dp->open), GFP_KERNEL);
 		if (!dp->open)
 			goto out_free_inum;
 		INIT_LIST_HEAD(&dp->open->files);
 	}
+	if (pde_init_seq_direct(dp))
+		goto out_free_inum;
 
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 56eab69e1dcc..d51ab7548b11 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -219,6 +219,87 @@ static void pde_unpin(struct proc_dir_entry *pde)
 		unuse_pde(pde);
 }
 
+/*
+ * procfs owns the seq_file of a seq_file entry and only calls into the entry
+ * with it pinned. A read copies to userspace without the pin, so a reader
+ * that faults on its buffer doesn't hold up remove_proc_entry().
+ *
+ * The seq_operations the seq_file runs are the entry's own next and show
+ * with procfs's start and stop around them, see pde_init_seq_direct(): the
+ * pin is taken in start and dropped in stop, and nothing sits between the
+ * seq_file and the entry's per record code. An entry that only has a show
+ * function is iterated like single_open() does it.
+ *
+ * If the pin fails start switches the seq_file to seq_operations whose stop
+ * doesn't unpin, so that the entry's own start or next can return any error
+ * they like, ERR_PTR(-EIO) included.
+ */
+static struct proc_dir_entry *seq_pde(struct seq_file *m)
+{
+	return PDE(file_inode(m->file));
+}
+
+static void pde_seq_stop_unpinned(struct seq_file *m, void *v)
+{
+	m->op = seq_pde(m)->seq_direct;
+}
+
+static const struct seq_operations pde_seq_ops_unpinned = {
+	.start	= pde_seq_start,
+	.stop	= pde_seq_stop_unpinned,
+};
+
+void *pde_seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_dir_entry *pde = seq_pde(m);
+
+	if (!pde_pin(pde)) {
+		m->op = &pde_seq_ops_unpinned;
+		return ERR_PTR(-EIO);
+	}
+	m->op = pde->seq_direct;
+	if (!pde_has_proc_seq_ops(pde))
+		return single_start(m, pos);
+	return pde->seq_ops->start(m, pos);
+}
+
+void pde_seq_stop(struct seq_file *m, void *v)
+{
+	struct proc_dir_entry *pde = seq_pde(m);
+
+	if (pde_has_proc_seq_ops(pde))
+		pde->seq_ops->stop(m, v);
+	pde_unpin(pde);
+}
+
+/* what single_open() iterates with, seq_file keeps its own private */
+void *pde_single_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+
+static int pde_seq_open(struct proc_dir_entry *pde, struct file *file)
+{
+	int err;
+
+	if (pde->state_size)
+		return seq_open_private(file, pde->seq_direct, pde->state_size);
+	err = seq_open(file, pde->seq_direct);
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
@@ -474,22 +555,35 @@ static unsigned int proc_reg_mmap_capabilities(struct file *file)
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
@@ -514,9 +608,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 		}
 	}
 
-	open = pde->proc_ops->proc_open;
-	if (open)
-		rv = open(inode, file);
+	rv = pde_open(pde, inode, file);
 
 	if (pde->open) {
 		if (rv == 0) {
@@ -544,23 +636,45 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	if (pde_is_permanent(pde)) {
 		const auto release = pde->proc_ops->proc_release;
 		if (release)
-			return release(inode, file);
-		return 0;
+			release(inode, file);
+		goto out;
 	}
 
 	if (!pde->open)
-		return 0;
+		goto out;
 	spin_lock(&pde->pde_unload_lock);
 	list_for_each_entry(pdeo, &pde->open->files, lh) {
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
@@ -644,7 +758,9 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 
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
index 7dea0237f08b..674e6b4ed21e 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -46,6 +46,8 @@ struct proc_dir_entry {
 	};
 	/* the open files procfs has to know, see struct pde_open_node */
 	struct pde_open_node *open;
+	/* the seq_operations of the seq_file, see pde_init_seq_direct() */
+	struct seq_operations *seq_direct;
 	proc_write_t write;
 	void *data;
 	unsigned int state_size;
@@ -97,6 +99,22 @@ static inline bool pde_has_proc_lseek(const struct proc_dir_entry *pde)
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
+/* procfs owns the seq_file, see pde_seq_start() */
+static inline bool pde_is_seq_file(const struct proc_dir_entry *pde)
+{
+	return pde_has_proc_seq_ops(pde) || pde_has_proc_show(pde);
+}
+
 extern struct kmem_cache *proc_dir_entry_cache;
 void pde_free(struct proc_dir_entry *pde);
 
@@ -343,6 +361,9 @@ void proc_init_kmemcache(void);
 void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
 void set_proc_pid_nlink(void);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
+void *pde_seq_start(struct seq_file *m, loff_t *pos);
+void pde_seq_stop(struct seq_file *m, void *v);
+void *pde_single_next(struct seq_file *m, void *v, loff_t *pos);
 extern void proc_entry_rundown(struct proc_dir_entry *);
 
 /*
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


