Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABAFA6076CED
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=erxYLb1X
Received: by kanga.kvack.org (Postfix)
	id C8D7D6B05B8; Wed,  4 Nov 2026 14:30:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65A66B05B9; Wed,  4 Nov 2026 14:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BA26B05BC; Wed,  4 Nov 2026 14:30:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89D356B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:30:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 178E8140673
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:30:18 +0000 (UTC)
X-FDA: 85398427716.02.A38CC71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5310218000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:30:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erxYLb1X;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820616;
	b=brHDRB1y6xC0xSFEST3WZxKniRzWukroiXyu+4avvPX5eX3kuKiGc7w1Os5YlX5+qZSm94
	CdJPxFQND0bMXDGv9cSty1Yv87d7v4woD1KqqMBxJ0f/v90FOR8SabBGoe2WM2dIntl0yU
	V8Wj/q3AV/Dp0MBOTT9CYgp7j0u5GsM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erxYLb1X;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXVlMWiDTu+69WMCdmpXWiSSm+c28yN85IUhl+IubT8=;
	b=CBBnQVvXB4qtzSGBrx9UuxR+cis3+JDL82cKL7xkbNA31X93PIpWxTuvUbHxREaO++lqGt
	TOrEQm5OjE2ym9jV1xFumNffzRx/uMMQ8Q+JGFj2KJDoxS0L+pi+QK5l+gJguUU5IzGuoN
	K+YoRjkD+OMLAdCt9tDJoGYF55jvsig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD42C60DB4;
	Wed,  4 Nov 2026 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DD31F00919;
	Wed,  4 Nov 2026 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820615;
	bh=wXVlMWiDTu+69WMCdmpXWiSSm+c28yN85IUhl+IubT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erxYLb1X2DHiu8zWp8v0jRYZ5UGBGh+M5ta+MA4icX/zIpChkASF4X68Jon0h6gUC
	 8nuq0rsoqvadx2nDVRRlBP2aj3ufS3vatM8TDiMeFwvrDbjUNZAnA9ofhKM5FJ6XdR
	 sKm5V0II55oa6/vNBFqcvr+LbWPRO0kbZer+mED55WXozLJTUJG12joB4mMb5qG9J7
	 VpqXXHbX8Uyy3Hnr9YOzD5moscAo3/2JptEeVKryH7YO1wOoswN1+5wJ5ax5tGm2mR
	 +F9oKHdKLr81Lnpvjj/9p5jcmbN338nH1sT0ofHVHFecyj5pPtazwCt2Ap7nkxjs5Q
	 Nyh8bzuW3jflg==
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
Subject: [PATCH RESEND v2 03/23] proc: share the readdir cursor with sysctl
Date: Wed,  4 Nov 2026 20:30:01 +0100
Message-ID: <20261104-work-procfs-core-v2-3-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7727; i=brauner@kernel.org; h=from:subject:message-id; bh=T1jO1APZ3j3BQHDjVCpmuxMpr8V+h+I2OmQhvzCN9EY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bi+58GPL4mlqj67P2u71ltNkzqaV66omL9vzZbrTm 6qaruBg345SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJLKxl+GfMdq5+mWH0iYYW pjurF5RIvVivMn2Ztpzp+jttleeahF4x/C9dvn1KMM+3u+sn3VvOYpmaw5XlpZepdd7umWXjkTf LRFkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: afrotwuxq73cowy3udogo8eaq1bycf6g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5310218000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820616-753606
X-HE-Meta: U2FsdGVkX19IgJpXXhYF8XvWghGSKp69V5Ep71f+s5/WHZZa9eiAR/hZAGn8ZE2AXLtYueaqVFFn77/v8ZdSUTlx3yB8HmM1Ib0NfrNukU3qLuZcD082CaKeC+eTyDxw/vm9Kiuuz+SA/ZLH4yHJcO+rJGLCe4GImOs4fgEEGC25Ym8y1EaaZZ3zzvRsTIVie+wuD0+v+IkrIoFCBXa74J1z/hmbBBP604hJIgL/kvygIu9lcOe3byKsOlSyCqYXjfh+ss87dGsXU4KDvQpLF5GBm24WCKKRYtEHjNmDqxPBmzcDgFrp7qDD36cH/GnMiamGSYAxY0oHvr0TNUfKGRgvaKFACt8YfmIEn2LlASyDGOoN+h1hmomCVaaQiZeKWKBU2ZvQDQcX9CH4SAMcFrsYF66UBk+Z7iO73XV7d9TpwHnysSj0VYIFYooi2/kxbERQHohlGmkq/9ZhEIh2aHW704sDq6wseHLBWpebzQEEYLECCHn6KxGt6kI1RH7G8HqgK15DVaP/vMcD2MubA8YCM0AEtrMdntOgl0rplw5WZqe8U3H6zqKfRXxEFcFZLQo4qIntXDso5wRDp4OZ86xR1wa+326BT9vb9cNWGFKwcO+FuE+rPVV46t+D0LSP2XMUVLluCE2upxTTGT2yvl4Rs1oyf4ES/f+Ze/rF3GttyNDy67L4hAy1kEN27Z6QPSqRNUSzhWor9BQfcDgu0SmYG11li7hRSfE7mUDLIrYFXTRwQm3lTyLY04GM3vrvQ72BCo5s/PVlkBpGPThRqC1FIAMw88J7ZNhudbzoaBfJQzB5HxK4M8lgxBshHUkAt++6BrqoIPYN9M6AuHm8e5jnn5djbOU8+ZQ4CI0vR2z/mwTtFv5GvCzzNJ/4C+0kBWXsVRewuJp+iw+KpXzmsBKKZXHVuLAFQTUoc7Xp+v50aBuz4OLe5yBMWMNs2Da8DYvhXute3GffXmoQ0xd
 +LGz//Em
 oI/7GZhe2nEcjCgxK+HF+Ki9u1iThwwbWviOKmdv78iPIWpt7Rx4BSxNfE6kGBk/QJmuxcFXWVYcVFvlP70ktEYRntpM/HmXskLhFk/UjhtFHqSvFuIWIidYos56s3gUYrBeHoqFg19zkYtFow/ZeEw1niYBQNkxChLoZhSLBjuf0Vps3NNV6o0V2UoTyMV27C4eOWdQsOXhzh4LdxM8pv07NGQVrQf9BRN5dYvoimRjxEe4DovefkdZisHgOCGRjGE/R7E5460OaDn6v4f/bbAkj+FkiHrkjR8/5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_readdir_de() and proc_sys_readdir() both resume a listing after
the last entry it emitted and each remembers that entry in the open
file with a cursor of its own: the same struct, the same way of
setting it, the same release. Keep one in generic.c and let sysctl
use it.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c     | 29 ++++++++++++-----------------
 fs/proc/internal.h    | 25 +++++++++++++++++++++++++
 fs/proc/proc_sysctl.c | 45 +++++----------------------------------------
 3 files changed, 42 insertions(+), 57 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index e7264f0cf5ab..f6d620a5c3d2 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -301,22 +301,16 @@ struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
 }
 
 /*
- * Where the next readdir resumes. The entries are counted, so one that is
- * added or removed in front of the position would shift what the next call
- * returns. The name of the last entry emitted doesn't move.
+ * Remember @name as the entry the listing is behind at @pos. If this can't
+ * the next call counts from the start.
  */
-struct proc_dir_cursor {
-	loff_t pos;			/* the position behind the entry */
-	unsigned int len;
-	char name[NAME_MAX + 1];
-};
-
-/* If this can't remember the entry the next call counts from the start. */
-static void proc_dir_cursor_set(struct file *file, struct proc_dir_entry *de,
-				loff_t pos)
+void proc_dir_cursor_set(struct file *file, const char *name, unsigned int len,
+			 loff_t pos)
 {
 	struct proc_dir_cursor *cursor = file->private_data;
 
+	if (len > NAME_MAX)
+		return;
 	if (!cursor) {
 		cursor = kmalloc(sizeof(*cursor), GFP_KERNEL);
 		if (!cursor)
@@ -324,8 +318,8 @@ static void proc_dir_cursor_set(struct file *file, struct proc_dir_entry *de,
 		file->private_data = cursor;
 	}
 	cursor->pos = pos;
-	cursor->len = de->namelen;
-	memcpy(cursor->name, de->name, de->namelen);
+	cursor->len = len;
+	memcpy(cursor->name, name, len);
 }
 
 int proc_dir_release(struct inode *inode, struct file *file)
@@ -346,7 +340,7 @@ int proc_dir_release(struct inode *inode, struct file *file)
 int proc_readdir_de(struct file *file, struct dir_context *ctx,
 		    struct proc_dir_entry *de)
 {
-	struct proc_dir_cursor *cursor = file->private_data;
+	const struct proc_dir_cursor *cursor;
 	struct proc_dir_entry *dir = de;
 	int i;
 
@@ -354,7 +348,8 @@ int proc_readdir_de(struct file *file, struct dir_context *ctx,
 		return 0;
 
 	read_lock(&proc_subdir_lock);
-	if (cursor && cursor->pos == ctx->pos) {
+	cursor = proc_dir_cursor_at(file, ctx->pos);
+	if (cursor) {
 		/* Resume after the last entry emitted, wherever it is now. */
 		de = pde_subdir_after(dir, cursor->name, cursor->len);
 	} else {
@@ -378,7 +373,7 @@ int proc_readdir_de(struct file *file, struct dir_context *ctx,
 			return 0;
 		}
 		ctx->pos++;
-		proc_dir_cursor_set(file, de, ctx->pos);
+		proc_dir_cursor_set(file, de->name, de->namelen, ctx->pos);
 		read_lock(&proc_subdir_lock);
 		/* Removed in the meantime, go on after its name. */
 		if (RB_EMPTY_NODE(&de->subdir_node))
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 268a0523be12..6b61d09ac5e5 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -278,6 +278,31 @@ extern struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int)
 struct dentry *proc_lookup_de(struct inode *, struct dentry *, struct proc_dir_entry *);
 extern int proc_readdir(struct file *, struct dir_context *);
 int proc_readdir_de(struct file *, struct dir_context *, struct proc_dir_entry *);
+
+/*
+ * Where the next readdir resumes. The entries are counted, so one that is
+ * added or removed in front of the position would shift what the next call
+ * returns. The name of the last entry emitted doesn't move. The directory's
+ * file keeps it, see proc_dir_release().
+ */
+struct proc_dir_cursor {
+	loff_t pos;			/* the position behind the entry */
+	unsigned int len;
+	char name[NAME_MAX + 1];
+};
+
+/* The entry to resume after, if the position is still the one behind it. */
+static inline const struct proc_dir_cursor *
+proc_dir_cursor_at(struct file *file, loff_t pos)
+{
+	const struct proc_dir_cursor *cursor = file->private_data;
+
+	if (cursor && cursor->pos == pos)
+		return cursor;
+	return NULL;
+}
+void proc_dir_cursor_set(struct file *file, const char *name, unsigned int len,
+			 loff_t pos);
 int proc_dir_release(struct inode *, struct file *);
 
 static inline void pde_get(struct proc_dir_entry *pde)
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 6a92c33db9b5..c1e41a3f8f6b 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -787,36 +787,6 @@ out:
 	return ret;
 }
 
-/*
- * Where the next readdir resumes. The entries are counted, so one that is
- * registered or unregistered in front of the position would shift what
- * the next call returns. The name of the last entry emitted doesn't move.
- */
-struct sysctl_cursor {
-	loff_t pos;			/* the position behind the entry */
-	int len;
-	char name[NAME_MAX + 1];
-};
-
-/* If this can't remember the entry the next call counts from the start. */
-static void sysctl_cursor_set(struct file *file, const char *name, int len,
-			      loff_t pos)
-{
-	struct sysctl_cursor *cursor = file->private_data;
-
-	if (len > NAME_MAX)
-		return;
-	if (!cursor) {
-		cursor = kmalloc(sizeof(*cursor), GFP_KERNEL);
-		if (!cursor)
-			return;
-		file->private_data = cursor;
-	}
-	cursor->pos = pos;
-	cursor->len = len;
-	memcpy(cursor->name, name, len);
-}
-
 /*
  * The inode number and type of the entry @d holds, instantiating its dentry
  * if there is none. Needs the header pinned, proc_sys_make_inode() checks
@@ -871,7 +841,7 @@ static int proc_sys_fill_dirent(struct file *file, struct sysctl_dirent *d)
 static int proc_sys_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct ctl_table_header *head = PROC_I(file_inode(file))->sysctl;
-	struct sysctl_cursor *cursor = file->private_data;
+	const struct proc_dir_cursor *cursor;
 	struct sysctl_dirent d = {};
 	struct ctl_dir *ctl_dir;
 	int err;
@@ -888,7 +858,8 @@ static int proc_sys_readdir(struct file *file, struct dir_context *ctx)
 	 * that moved the position away from it counts from the start, like
 	 * seeking to an arbitrary position always did.
 	 */
-	if (cursor && cursor->pos == ctx->pos) {
+	cursor = proc_dir_cursor_at(file, ctx->pos);
+	if (cursor) {
 		err = sysctl_dir_next(ctl_dir, &d, cursor->name, cursor->len);
 	} else {
 		loff_t pos = 2;
@@ -910,19 +881,13 @@ static int proc_sys_readdir(struct file *file, struct dir_context *ctx)
 				break;
 		}
 		ctx->pos++;
-		sysctl_cursor_set(file, d.name, d.len, ctx->pos);
+		proc_dir_cursor_set(file, d.name, d.len, ctx->pos);
 		err = sysctl_dir_next(ctl_dir, &d, d.name, d.len);
 	}
 	sysctl_dir_done(&d);
 	return err;
 }
 
-static int proc_sys_dir_release(struct inode *inode, struct file *file)
-{
-	kfree(file->private_data);
-	return 0;
-}
-
 static int proc_sys_permission(const struct mnt_idmap *idmap,
 			       struct inode *inode, int mask)
 {
@@ -1002,7 +967,7 @@ static const struct file_operations proc_sys_dir_file_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_sys_readdir,
 	.llseek		= generic_file_llseek,
-	.release	= proc_sys_dir_release,
+	.release	= proc_dir_release,
 };
 
 static const struct inode_operations proc_sys_inode_operations = {

-- 
2.53.0


