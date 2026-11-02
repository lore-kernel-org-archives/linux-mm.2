Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8873960771D5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5WhCI6A
Received: by kanga.kvack.org (Postfix)
	id AEAD46B05D1; Mon,  2 Nov 2026 09:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2AC6B05D2; Mon,  2 Nov 2026 09:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1CC6B05D3; Mon,  2 Nov 2026 09:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7615D6B05D1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:26:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B3BA1C0BA9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:17 +0000 (UTC)
X-FDA: 85390403994.20.0CD18E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4C1FC40006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5WhCI6A;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uamuXcUsXcKXZuaRlkz0YhJ28OVmOkK6UsWfY7fTPbk=;
	b=Jlk9c4ziKvHURkDY3uICsV0Jtg/7PdalBUT2GGUcZD7PvBOTT3B2M3csfHCtmH9i9vEGe2
	4krV+dyT+/X+MZ1ZMMndSnuohmCfb6N7z9IZIqcK/1RL7YYajNF0YpjGlMldjM+41b1zFX
	4ywilCn4+PWp1fSQOemBg0XpvymkeP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629575;
	b=8AaOxiLLTurEzXTa1QAO9UXSN0ti20S3RSiR7kRk98MI84HJzRD/rVIIbfbacSsS8yVVnz
	hU18wFu2+0LVPkDcQ8WEsFw3+10dChCYCGz929hIAlxJmTOzldGvPDUg6Kph2YOqCN7WBs
	wiC2BIscw5faNgXAk4UPUIOLn4J5zKU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5WhCI6A;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA47E60619;
	Mon,  2 Nov 2026 14:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB871F00A16;
	Mon,  2 Nov 2026 14:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629574;
	bh=uamuXcUsXcKXZuaRlkz0YhJ28OVmOkK6UsWfY7fTPbk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i5WhCI6ADDNe0HKJ5NzcfawjVqUbryc4wNhSFPtww0vwQtB/EhujGlgJ3yFN2wuQ3
	 ELkvngc+3q9Bm/kdTVyzOOZrj/2UcmfBa8lINbsLb6xyGiYyRj9J8eMQXru5BVwQ5j
	 MJLqma0W8RCDIemvmnl+JUXsPugT1fmlbHOnf6UoN5acVZarxMRbxGTftc4jPXdKWn
	 UI5tdwsEVvdET14X+gOKrGA4ie2mBhWMK956CF24hZ3FEDHJCM4leCMxm/bLrsWCYU
	 AOe95i8Hd+XH8PXXMBCzbV5jAUFh9vCYjgIXjWbD6dLajbUfhiJVabMIXLp+a5ZLA8
	 qVF2ns5tgUqRg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:34 +0100
Subject: [PATCH RFC 19/38] proc: resume readdir after the last name it
 returned
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-19-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7297; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hHAY+oLncj11ebCsOV+U4+kuEOtQwhGolI+cXd3wPh0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJN988y6uj1BC/zUSpgvF01snCO7cs2Fevn0TZNnb
 N3M+2LC745SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJXClh+B+z8I3WoXXN2uFb
 pkxXmSHHXLVl54S2mm1v2AX2FJuXB35kZNh8lcUw5kSj3NFnJtcWaDhMKDEOm+Izq8p+8epVUf4
 iqvwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C1FC40006
X-Stat-Signature: m81xe5f6nefuugnkk8wwz4pure7e3w68
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629575-245611
X-HE-Meta: U2FsdGVkX18OXlp8v3/ZUtI6JqCjpSGeBfbBoWR4+S80mcJnr9LFblJ35H2EPL68WoSvpl4qM3HRz1/O1DRfPV16QcHJR1iHRToeYdEsAJMjBLOmLeJ8a/8odGBYxWN0j6g6Wg3OzJaU7EkotElbWN1ftniE62gSC2bWYcrngwWCTSCiAN+sD7efxtPEIeW5p2kiwSKwTCiYX0sed6TTj7VEUzu4fkD3rbclAvFtSBHFjIpQrkKCRapCXmEhhAddNw9PnvrQ5Q2QldFcjr/MNNx/bKGNbUHlNJ0cpfJa1KbmOonEM8tyxgtmdr30RgkCFRPlNTBhkvV3T/zU8rGwgIC3jMeqiAZuw8l1pEWgkZf3c4fqtKik4h9noGO5OPbN7R69fIcbQ0FFFOt4fQuG0mRtnbmovUuQ+wx5BQLZoPMZ4LMGF3vRRHzCcI15C2hSO3G/HjJxJlymswFw4o4EsmSAIkYoj2nlH3tL/7c8SIMJD1GTaQADIpcjxXCutQV1PQialiWRPQPXaIv1BQb0VXRqU08anWj3R84Sd2SA6wWXMWsVS6WObYKndtJ92LNbS3z8UXpJWEQI0xI4cfnwdMDU/+9ZDgO2n7VToOMblS/3iFsU2n8QGJLmHSwM4fKXBg+0oFwExz+75aLMmgvwAtTtAKFjrk5oyLUbKJvPvufqzqFdcjoFxjeX/kT8/5ogPvqESS88jmyDHJOMeWrqs5l4LR1DaoIQaVNDUt5cxIUlvNCf5wGlHaXXJ/4JUvC564Zk8UqJzrfXNDjvSiw70CrEXMzFrP998epUpefbYU3pCWHEyds2/eh/4Le3S9+i4ss2TAFsekoc3UxSWLQYMdL22KOJ14ivWLq11Xbu7pKd+Mq1hVbC3g0yF+9GzZnHy3DVsEHD6YUPchQO6uR88qxRHo9t5T/uQ2s7UDVmQ9ucl4/qIMW/72Brru1pE6AU+qewSFP8qYByOa/LxWk
 xf+b98r9
 tzsdfUtBSNhv9fKKSzcEQsTGIoHnIWK6Ym8epwhoAdv0JEp8Xp2aelYMgkudXQt6hp0yvMIp1EyUSbNKxLqlIN639jTTYt2zI92qsBb7/5hblwZyd5ApGVm2bm5NjrsSozW4wyyPg7xcmP93RAp1J02L8xV7mg9KE548A8gAjs2gqlXCFb9vYB6qlvbkW3BRrGwJLR7Er95kjt2t3Ok4PycMWgYFbJnD7IQSrLsM88ish+ZsrlTB1cuCu6ovGIr99LiauTafqvmO9Z+f+5iPKfpCZbK3cn3DN7LIF
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
index ef804cd3ec45..47830d6af255 100644
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
@@ -277,6 +299,40 @@ struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
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
@@ -289,23 +345,26 @@ struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
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
@@ -318,8 +377,13 @@ int proc_readdir_de(struct file *file, struct dir_context *ctx,
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
@@ -347,6 +411,7 @@ static const struct file_operations proc_dir_operations = {
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


