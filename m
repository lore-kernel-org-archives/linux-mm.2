Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C1A1C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858256B00A7; Thu,  9 Jul 2026 18:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8300A6B00A9; Thu,  9 Jul 2026 18:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C426B00AA; Thu,  9 Jul 2026 18:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43F796B00A7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB8641692C5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:50 +0000 (UTC)
X-FDA: 84970684260.08.AB529FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0A74E1C0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SvLHDCTF;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o//3Wih6kSQ9SPV0MLA8r8h1Tfx37FGOuDRdL1ZjK3Q=;
	b=kQC8ZZDZx5euDCim1UXQbmxHFxD6eacEKcXvG1bPcW3nOW0p5l3TNHA5nOd2HVf1Suh54I
	/24UTQeIgsBKmp1mYvkrgR3NHx9HSx0pXEEomR0iTQvBABzcxjodDcCLhDXNOTCADOzbW3
	SoKJ7DcxvvflgjV7NDY+QcvWhFwvcpA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636249;
	b=k2sF7DEPZ7NfM8lEPXN+iWei0OXvGLBS1ab4d1mZASbfdvg/M6k1gGLGR8Um/j7vTnWkaS
	zZcRBQqiB2r6rozySFhoLD6qlrmud5r0+xZOiBhvpjERRclKgTEQCSKGy2m+WKqAUSwaFI
	ZztjfkJ5Dudr0RR/pQB+qPJww7+Ku9o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SvLHDCTF;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5418A401CE;
	Thu,  9 Jul 2026 22:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7B41F00A3D;
	Thu,  9 Jul 2026 22:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636248;
	bh=o//3Wih6kSQ9SPV0MLA8r8h1Tfx37FGOuDRdL1ZjK3Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SvLHDCTF++3dv2LSDQOuRo6G5cYBywHSVMKtjT/VYmM/luH3NY4oeFevsYUMN6WEt
	 +f3/Py91jcpK+2wdjxOBjzJymZMJ5289+woOYPXsMORHTybuHJvu82MDDEAEbYYeuJ
	 1pp7gOE8+C9/RNhJwKXUOjOpA9d0YPDF9hAUtdUfYjBOKvSlYJcjmOmN+3tCwdU1CR
	 zHQ64AfGxE+0mpI87PX0NgwW4AsmRxx16E0K14zIt25qwMK9ScQzUjS/HnHeYJ1Q4a
	 Ww1At403wkoaKjoVBztB3pxGuo5R1CVOQj6YaPxtezEPIzD3PwcrcrL6CUKczIzX8j
	 yTQyoWtnJvsaw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:11 +0200
Subject: [PATCH v2 16/23] binfmt_misc: factor out the entry removal
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-16-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5585; i=brauner@kernel.org;
 h=from:subject:message-id; bh=cyHkmmDfiEKgpVxkufJ06j5rYo5ZpvYalwvx7n/HkSE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHxbfXMZx3vxnhpjzQlPpJMEQ+tbL2ZEM8qeCz2TE
 RkgGb2xo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJr3jD84V60d95fqae516QZ
 r9XonTj52UVuR/aj5Wbvz0v6qn708mBkWPQ0IPBP+7FjXzvjee8bn7j8S+3NnXdiRT9+NL7+nSf
 XygAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A74E1C0005
X-Stat-Signature: 4xpsizix7fs43b1s751zwxfxen56y8wm
X-HE-Tag: 1783636248-903538
X-HE-Meta: U2FsdGVkX1/WjkOA9+mcgJ20mB1WWb0f+GN9MDoR6yh0KtJAdhofGDr+D0Idp5KsEIgvlIO2cHipJD70rKaNA+j/pJnDAWvPEPtr+dTIk266C50xYeoP+0HNW7f6rU1K+dcWgWtZMtY71ehJIEx3ky01/abq4Hu0evPnVzlpwE+jlcNTnNsnHWt3YIl409Vs2Lmoe6gaiBBznDUdlKNTjxh6K4RKG+NpJdZ0XsJADUGTJAFutfcI9o6X4bIcct6JTfDnAVK4775H+g+VEwLdw4vQJm/pga/HAx4wXRftpniS5SiHdFmHEyG69OIE6spI68egyOeU1IiFH6zgq4HnUOAA2Fdocekg7XRCyxz2SrBfkFs9SUwSqtVe0IV/sy5CSmg6A2Nwd5alV+3GTBtbQxAnsCjasinWDRmDl+oITvBVCqJ4pojTZTcQirqD1c/oi8HPWLWzP4g6DQOd0i5+K3PZ8GOePKAT7Di0ZfZC3vPHO8cYhHj2qaZkfDXAdXWcvOUHKMnrpfNPS99fXqEHPSI4hCFyLW8J+fj2+8QsO0vXnACWVnZOo5TVDCCYtGY4Qt33t1SlS6EFZGxpqjch8Lz0ioUEKbxwaD1TVLimT5c7vIEVhtHt7V20FSU9ix2JCwFyFvRG+Pk5a3TmQJVhaQb8VsUTbHtJxMEkioj1P2UXxUpjfDqqrjyfStUlyCacGyJq5nQNSjo+z9md7ljcTmHeiNbxM/A1s5LAnlhOGdxTF/gzrmA4nAXTmB16Dt33gDFo3igb5BCpj+s/eCZbhOJlO4rJPWhqnGKw19TRMCf+53+S6F6sXlV/EBxpl7S0pj909XLMIML3HbQhCR0ZWtaa08zXLfl2a/lOcsRyxk+I4XBWx05GjzciueXxO8/kqTLHIiJgcaTB7SlDM/0SrK17FbsTpP1XZRoRCmympXd7DjWZc3Av/a8PF25QawyetT354HLmHV0FuuWucP/
 nwBgC9R+
 4or6QDBQcP5UG6DYPRc7RIWGWI+YWG8IDPcUBCo79rORgNzxM7t2fVNrwqH95tgavCVNkDvlpwqTio5vOL57Jn1ikLi7pnZVXtyhQCMYzhQT6da+6P/FnMWlxu8tyuS7Bu7v6sbTwjMMlruKVa/V8QonhChxKV8bATkb1D0uU06uITfuuLFultpZk4WnGAS0AUadlM/q655nsifjDdlV1W8/8RsVkPaIqE/UZnYFNapxBOQztynn+fZ9KPjzrlDXv4Vc5+WTLlpOarCRcFstbLHooN899h+FUeBegZbQsT8Z5U/qNSclQVrLK4GXm6bUPxGY+x1f52P/XJlbhYO7xL1HqrfU6RwgI/z5MpReBk+UyrCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both write handlers open-code the same removal dance - grab the root
inode lock, unlink, unlock - each carrying a verbatim copy of the
same eleven-line locking comment, and bm_entry_write() reuses its
inode variable for the root inode halfway through to pull it off.
Move the dance into bm_remove_entry() and bm_remove_all_entries()
and the locking rules into the kernel-doc of remove_binfmt_handler()
which both helpers wrap.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 84 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 40 insertions(+), 44 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 83f84934d57c..4267f66128c4 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -682,11 +682,19 @@ static void bm_evict_inode(struct inode *inode)
  * @e: binary type handler to remove
  *
  * Remove a binary type handler from the list of binary type handlers and
- * remove its associated dentry. This is called from
- * binfmt_{entry,status}_write(). In the future, we might want to think about
- * adding a proper ->unlink() method to binfmt_misc instead of forcing caller's
- * to use writes to files in order to delete binary type handlers. But it has
- * worked for so long that it's not a pressing issue.
+ * remove its associated dentry.
+ *
+ * Adding and removing entries via bm_{entry,register,status}_write()
+ * happens under the exclusively held inode lock of the root dentry keeping
+ * the list stable for writers. load_misc_binary() walks it concurrently
+ * under RCU. The entries_lock is only held around the actual unlink to
+ * serialize against bm_evict_inode() which unlinks entries during umount
+ * without holding the root inode lock.
+ *
+ * In the future, we might want to think about adding a proper ->unlink()
+ * method to binfmt_misc instead of forcing callers to use writes to files
+ * in order to delete binary type handlers. But it has worked for so long
+ * that it's not a pressing issue.
  */
 static void remove_binfmt_handler(struct binfmt_misc *misc,
 				  struct binfmt_misc_entry *e)
@@ -697,6 +705,31 @@ static void remove_binfmt_handler(struct binfmt_misc *misc,
 	locked_recursive_removal(e->dentry, NULL);
 }
 
+/* Remove @e unless a concurrent write already unlinked it. */
+static void bm_remove_entry(struct binfmt_misc_entry *e, struct super_block *sb)
+{
+	struct inode *root = d_inode(sb->s_root);
+
+	inode_lock_nested(root, I_MUTEX_PARENT);
+	if (!hlist_unhashed(&e->node))
+		remove_binfmt_handler(i_binfmt_misc(root), e);
+	inode_unlock(root);
+}
+
+/* Remove all entries of the binfmt_misc instance @misc belonging to @sb. */
+static void bm_remove_all_entries(struct binfmt_misc *misc,
+				  struct super_block *sb)
+{
+	struct inode *root = d_inode(sb->s_root);
+	struct binfmt_misc_entry *e;
+	struct hlist_node *next;
+
+	inode_lock_nested(root, I_MUTEX_PARENT);
+	hlist_for_each_entry_safe(e, next, &misc->entries, node)
+		remove_binfmt_handler(misc, e);
+	inode_unlock(root);
+}
+
 /* /<entry> */
 
 static int bm_entry_open(struct inode *inode, struct file *file)
@@ -728,24 +761,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
 		break;
 	case BM_CMD_REMOVE:
-		inode = d_inode(inode->i_sb->s_root);
-		inode_lock_nested(inode, I_MUTEX_PARENT);
-
-		/*
-		 * In order to add new element or remove elements from the list
-		 * via bm_{entry,register,status}_write() inode_lock() on the
-		 * root inode must be held.
-		 * The lock is exclusive ensuring that the list can't be
-		 * modified. Only load_misc_binary() can access the list
-		 * concurrently and it does so under RCU. So entries_lock only
-		 * needs to be held when an entry is actually unlinked to
-		 * serialize against bm_evict_inode() during umount which
-		 * unlinks without holding inode_lock.
-		 */
-		if (!hlist_unhashed(&e->node))
-			remove_binfmt_handler(i_binfmt_misc(inode), e);
-
-		inode_unlock(inode);
+		bm_remove_entry(e, inode->i_sb);
 		break;
 	default:
 		return res;
@@ -861,9 +877,6 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 {
 	struct binfmt_misc *misc;
 	int res = parse_command(buffer, count);
-	struct hlist_node *next;
-	struct inode *inode;
-	struct binfmt_misc_entry *e;
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {
@@ -874,24 +887,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 		WRITE_ONCE(misc->enabled, true);
 		break;
 	case BM_CMD_REMOVE:
-		inode = d_inode(file_inode(file)->i_sb->s_root);
-		inode_lock_nested(inode, I_MUTEX_PARENT);
-
-		/*
-		 * In order to add new element or remove elements from the list
-		 * via bm_{entry,register,status}_write() inode_lock() on the
-		 * root inode must be held.
-		 * The lock is exclusive ensuring that the list can't be
-		 * modified. Only load_misc_binary() can access the list
-		 * concurrently and it does so under RCU. So entries_lock only
-		 * needs to be held when an entry is actually unlinked to
-		 * serialize against bm_evict_inode() during umount which
-		 * unlinks without holding inode_lock.
-		 */
-		hlist_for_each_entry_safe(e, next, &misc->entries, node)
-			remove_binfmt_handler(misc, e);
-
-		inode_unlock(inode);
+		bm_remove_all_entries(misc, file_inode(file)->i_sb);
 		break;
 	default:
 		return res;

-- 
2.53.0


