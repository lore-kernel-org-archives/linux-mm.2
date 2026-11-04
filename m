Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B9E606E83E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bJLqHHf5
Received: by kanga.kvack.org (Postfix)
	id D45266B05BA; Wed,  4 Nov 2026 14:24:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D516B05BE; Wed,  4 Nov 2026 14:24:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CAA6B05C9; Wed,  4 Nov 2026 14:24:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99A366B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:24:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2801912064E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:24:06 +0000 (UTC)
X-FDA: 85398412092.05.FB029D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7471BC0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:24:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJLqHHf5;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820244;
	b=4vmXSTGapHYk58Uet81db9ZuBDaWwkHl3XHB/HVIE1iq2y8mCkVH6JAvrMS/8crrcBUXJV
	BVeLrJc22N9cvkQaJSqgskU/cBPYGL/bMH49ufkq/wzPzcPeyMbCNBq0hbkuYFaew49W2V
	FKzMZecIVLTkE9WV/pfe0KjTQSJawzY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJLqHHf5;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7K5JcYwiEwa4eeL0B3OVYVYuE4eo7ZLheZ5n77rVhE=;
	b=mtfR13jrqzKzBKhy90/LNm6JJKqIXYMQfWd4cWaazOnDrI/cj2d+Y/DF+Fr+MxQzBOcaAu
	aF2kLoP0NvZCiD9M2i/IhhRPSFC2QmDh1HGO37MBC9cto2PHDmcScl9vCN61JxOxJG7A98
	Q/yUKDZ42MTYdZMf9bQ0Yd5oh2BZYqs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15BCD60D7F;
	Wed,  4 Nov 2026 19:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1CE1F00919;
	Wed,  4 Nov 2026 19:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820243;
	bh=H7K5JcYwiEwa4eeL0B3OVYVYuE4eo7ZLheZ5n77rVhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJLqHHf5qQ9r5k8j4lX0RizveOJ91Nhl7TYYnWVh4aogp5c4fTsQ8eax4sbt0OBxb
	 3LGXXxrD9ytPYwt1XoRKnERbxW2Tn+UK8zRCJKkRYsyQfi/PuWkuv31fYn9LUwZYjP
	 x1XP6KYsCrbos3zXmmN9K9ptP4sseCE+7dzR7OIE9G1wPs89kTqRfIMujdLyvnG/41
	 wd0+mMF+XHreqHHSN22Y76usuZZQiXKs5/dT12lrJaMLmtKCOmIwzbp6lxJW0ddkkF
	 tRH0k19+WCWkxOhMnoRLDydxLurlCjL+xTlICjmEBzFnzWlSjW6fSbK8/zIHPo72+P
	 4oFpVAHjceUQQ==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 32/51] proc: resume readdir after the last name it returned
Date: Wed,  4 Nov 2026 20:23:49 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-32-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7297; i=brauner@kernel.org; h=from:subject:message-id; bh=ZNOmyzOFl2t4htw30uUhDwZ021Jq9cqPFYbiLU1C/ng=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvw8+c29B390vF6dzdjab31XjS+zOW6D/PbUDb2Sk i6yQqw2HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNJ8mdk2B3EIP33wna7rsrz 6TXqjfUtfy9d/9TA4Ln55+Ly5KB4T4a/kt9jDDrU5dJMlBQe2Rw/ObH6fKvKZfvDy3SzZ+dwPDj DBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b1f4jdpqdhy5jspoinksz66nd88o1nat
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7471BC0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820244-463603
X-HE-Meta: U2FsdGVkX19RRxSTCzQGR1S0wxW4lpnU8XmweOipgfAPVsSVbY5fPvdDaftAUq9zqoeMHr6wbBsux1IHIR+TWot3wAKzasq1y+d6oGZwoVbgHQOKz224QNC1xrAY39gTaqMqD51CUoTxeUutp5f4v997Jo58+AnDvul41SKit8ZXjHb1EucfMCfTKoMlqzdq1h9CL6NsZWUtxf5uTGLo7ssM9tNdRakoUCL0Bw6H+EBMm5yk/wowLCLIjHlH4NAA5aSovUMa7c4anTkD3XtUWcwgoK6HXmXRb26uArGR09QIl8mxtvIxTkZn1IA50F0HEaGnHqwdD3x2vdGrQFrnV7D3HJ3qNOyy4CJ3yhV9FuuhuSqlvVy6Gie23G/9ZWb02F47D4l2yKfRpgTdELVPRhc15HtnJElveEfGXSA8xk4J9GI9d1YKqkl04HaBwK+sx9wutJBtQWVjzQBd9OFK8XKIxXC40e3dg3JnIC/QBxHVN+8oYe9javPy+P2kqlYeXUDOtRhGFAmPac9BA/g+EojXT8fwGJAfWGXFEXxAk6VEiKKP/EX+xAzNtUFGqnX0O6rAOUb8zCPgYDVi6Moic2tbP6nVxcfKAgoZOSV9C9YiHtbt09IDSATNv9t0dWibvkwbnREE555fZdORvg78xt6A06Nwrw6vOXBOn4LrdPIWjVWMUdocV7xY8seUmTg1wILveXuULWRqrFf2TEqtKljlgeWk1MbQiXbgbuwJMINIuh+xMNUW4b5dOqXrR73JQ7NQOIFLqfJcvITLqSUt91xSTMb2dRL0l4N2U6oQE5lsaBgxSCziska1BNTtmnTUxdpTLCQfa9J7ItMH7AEVzsvj9lZAoP2a/ZsFQdyyt8VvdGN1rvYzny0EH75Hxmkfz+puicuIuPuJ2dfJSagrKVCRLdN+RigG+SiUf9Zx6J2UQnZ8JLXEnKWBA9EqFqe5oUiN0YIadGA47Fru+Mw
 PcaXAgPW
 UBPDr8XW4dx1IJVAnkfLDyjcpEv9Tl1Bg9GdSBOMvKvQj/0Lsl5CWfgurG+fL8+m70BBvhZhfv4lKbR2GyQ23RaEHPAOPhUiV4lkQMbf/NZT5qWa5ZOr8PjsCfcMnxavOmcdpaWkMfOAnUwAlPzc8aXhMtxJOvdqcHj3emAC0wKVEp/YMI5IJlUEZkequMKL9KMraztz6UqWGhheadK2RNL8KYItjNKV9j/EnnHoZMDzp4H35MpfIbAOHnNtgwFN7HHvHmZIAq83gfJmgN9DAETqvfPyFMUYxyZ6fReE/MtAmaU6xvXZ12uUJIe/8MyzS/0r5vqKX9fq6tjcgz/IHb9xa6jVq6H5UOpzZZ0VvvJkz/nTB6c71NRhzAlN9baYq5LyidwJCMPgu03Zm14z1bmHuDFL/HheJEldI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_readdir_de() counts the entries of a directory and resumes a
listing at the number getdents64() stopped at. The entries are sorted
by name, so one that is added or removed in between shifts everything
behind it by one. Listing /proc/net/dev_snmp6 with a buffer that holds
".", ".." and "lo" and adding a device whose name sorts before "lo"
makes the next call return "lo" a second time. Removing one that sorted
before the position makes the next call skip an entry instead.

Since commit 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()") an
entry that is removed while it is being emitted also ends the listing
right there. pde_subdir_next() finds nothing after an erased entry, so
proc_readdir_de() reports the end of the directory and the next call
resumes by number, skipping another entry. For /proc itself
proc_root_readdir() takes that as the end of the static entries and
moves on to the pids, so the rest of the static entries is missing.
And if the position is behind the last entry when a call starts
proc_readdir_de() returns 0, so /proc then lists no pids at all.

So remember the name of the last entry a call emitted in the file and
resume at the first entry after it, like kernfs resumes after the node
it stopped at. An entry that was removed while it was emitted is
continued after by its name as well. If the position was moved by a
seek in between the listing counts from the start like before.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c  | 89 ++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/proc/internal.h |  1 +
 fs/proc/proc_net.c |  1 +
 fs/proc/root.c     |  1 +
 4 files changed, 80 insertions(+), 12 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 9e59796349e1..588999058e66 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -87,6 +87,28 @@ static struct proc_dir_entry *pde_subdir_find(struct proc_dir_entry *dir,
 	return NULL;
 }
 
+/* The first entry of @dir that sorts after @name. */
+static struct proc_dir_entry *pde_subdir_after(struct proc_dir_entry *dir,
+					       const char *name,
+					       unsigned int len)
+{
+	struct rb_node *node = dir->subdir.rb_node, *after = NULL;
+
+	while (node) {
+		struct proc_dir_entry *de = rb_entry(node,
+						     struct proc_dir_entry,
+						     subdir_node);
+
+		if (proc_match(name, de, len) < 0) {
+			after = node;
+			node = node->rb_left;
+		} else {
+			node = node->rb_right;
+		}
+	}
+	return rb_entry_safe(after, struct proc_dir_entry, subdir_node);
+}
+
 static bool pde_subdir_insert(struct proc_dir_entry *dir,
 			      struct proc_dir_entry *de)
 {
@@ -278,6 +300,40 @@ struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
 	return proc_lookup_de(dir, dentry, PDE(dir));
 }
 
+/*
+ * Where the next readdir resumes. The entries are counted, so one that is
+ * added or removed in front of the position would shift what the next call
+ * returns. The name of the last entry emitted doesn't move.
+ */
+struct proc_dir_cursor {
+	loff_t pos;			/* the position behind the entry */
+	unsigned int len;
+	char name[NAME_MAX + 1];
+};
+
+/* If this can't remember the entry the next call counts from the start. */
+static void proc_dir_cursor_set(struct file *file, struct proc_dir_entry *de,
+				loff_t pos)
+{
+	struct proc_dir_cursor *cursor = file->private_data;
+
+	if (!cursor) {
+		cursor = kmalloc(sizeof(*cursor), GFP_KERNEL);
+		if (!cursor)
+			return;
+		file->private_data = cursor;
+	}
+	cursor->pos = pos;
+	cursor->len = de->namelen;
+	memcpy(cursor->name, de->name, de->namelen);
+}
+
+int proc_dir_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
 /*
  * This returns non-zero if at EOF, so that the /proc
  * root directory can use this and check if it should
@@ -290,23 +346,26 @@ struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
 int proc_readdir_de(struct file *file, struct dir_context *ctx,
 		    struct proc_dir_entry *de)
 {
+	struct proc_dir_cursor *cursor = file->private_data;
+	struct proc_dir_entry *dir = de;
 	int i;
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	i = ctx->pos - 2;
 	read_lock(&proc_subdir_lock);
-	de = pde_subdir_first(de);
-	for (;;) {
-		if (!de) {
-			read_unlock(&proc_subdir_lock);
-			return 0;
-		}
-		if (!i)
-			break;
-		de = pde_subdir_next(de);
-		i--;
+	if (cursor && cursor->pos == ctx->pos) {
+		/* Resume after the last entry emitted, wherever it is now. */
+		de = pde_subdir_after(dir, cursor->name, cursor->len);
+	} else {
+		/* Moved by a seek, count from the start like always. */
+		de = pde_subdir_first(dir);
+		for (i = ctx->pos - 2; de && i; i--)
+			de = pde_subdir_next(de);
+	}
+	if (!de) {
+		read_unlock(&proc_subdir_lock);
+		return 1;
 	}
 
 	do {
@@ -319,8 +378,13 @@ int proc_readdir_de(struct file *file, struct dir_context *ctx,
 			return 0;
 		}
 		ctx->pos++;
+		proc_dir_cursor_set(file, de, ctx->pos);
 		read_lock(&proc_subdir_lock);
-		next = pde_subdir_next(de);
+		/* Removed in the meantime, go on after its name. */
+		if (RB_EMPTY_NODE(&de->subdir_node))
+			next = pde_subdir_after(dir, de->name, de->namelen);
+		else
+			next = pde_subdir_next(de);
 		pde_put(de);
 		de = next;
 	} while (de);
@@ -348,6 +412,7 @@ static const struct file_operations proc_dir_operations = {
 	.llseek			= generic_file_llseek,
 	.read			= generic_read_dir,
 	.iterate_shared		= proc_readdir,
+	.release		= proc_dir_release,
 };
 
 static int proc_net_d_revalidate(struct inode *dir, const struct qstr *name,
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index df873df9afc5..04f7ce2b24ed 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -287,6 +287,7 @@ extern struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int)
 struct dentry *proc_lookup_de(struct inode *, struct dentry *, struct proc_dir_entry *);
 extern int proc_readdir(struct file *, struct dir_context *);
 int proc_readdir_de(struct file *, struct dir_context *, struct proc_dir_entry *);
+int proc_dir_release(struct inode *, struct file *);
 
 static inline void pde_get(struct proc_dir_entry *pde)
 {
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index b1f5eafb069a..dbcf87a257e1 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -351,6 +351,7 @@ const struct file_operations proc_net_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_tgid_net_readdir,
+	.release	= proc_dir_release,
 };
 
 static __net_init int proc_net_ns_init(struct net *net)
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..dfee1caa26f7 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -441,6 +441,7 @@ static const struct file_operations proc_root_operations = {
 	.read		 = generic_read_dir,
 	.iterate_shared	 = proc_root_readdir,
 	.llseek		= generic_file_llseek,
+	.release	= proc_dir_release,
 };
 
 /*

-- 
2.53.0


