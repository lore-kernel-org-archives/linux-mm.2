Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B56C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB4C6B00AE; Fri, 10 Jul 2026 05:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D016B00AF; Fri, 10 Jul 2026 05:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B966B00B0; Fri, 10 Jul 2026 05:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AAD76B00AE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E990140400
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:55 +0000 (UTC)
X-FDA: 84972355230.23.E5E86F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D176160006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q1vBN/Up";
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676034;
	b=UyHZrKKXUu2rmdXYpfjTl9J+DOhXuoey7or9njI6UGjLOI2EcwR4dvEtWJ0A4KDUfY1gOh
	AnfmxjuSneBPI7CktY0iaoio+Zdm+S0tIqXW1mYKUleeF6UG6AIG8dMJ/mdCARUHKriEly
	aq0Hq3ypw6rEeAhZvZzWNlGYzUPqHoY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q1vBN/Up";
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Tggns+9/qGMnyXLSiyftgENXmZkplKbZJHOAgcmZLs=;
	b=unyPOpnWvVxwy8/drGXyCblUyBal/OdFJrX31vRagAz+O/xq6cciOvXZZAiyvsMKAcY939
	FkzeqO3CeIfjSBIksuHbMs8w5dx8Jo+GHySjp92Uzp4aEZIdviR2KHYzq1v91Y8qx+s2CS
	zu0OaXE4FrtQZrH7cW/W7zZqYqeOXew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 841CE43D83;
	Fri, 10 Jul 2026 09:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8681F00A3A;
	Fri, 10 Jul 2026 09:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676033;
	bh=7Tggns+9/qGMnyXLSiyftgENXmZkplKbZJHOAgcmZLs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q1vBN/UpJ7L4tmzygO9MA0VnSBh9Q88+XnH6Q4F1FGtWXbtV9YxqXgvEsvgPLjfnS
	 928SeLirWQLzvedkvneSIGjypYa1bNOQDsEBP50ASyAXrYHl3hm0ps/mXmPFqZoYfC
	 Z1ilHOd0uYXc0Nq36MEzFNdyHJZAeeVBdwe2jHkAt+wa6iP9jApQQL6Wb/5WSeFivK
	 5UCU+XIsXwvimxsKUcUNTTteN5BbDx5bZPVmy/4pyahQMOh9MauhYlIkeAbJWZzQhI
	 PBpmeBZJIIrJv2Il8cYMNYCrAymJknO2omJjzeTzaL9Kfa7fzL3PACiBEO4gGyAZBD
	 ugt7GO7EU5TRg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:18 +0200
Subject: [PATCH v3 17/24] binfmt_misc: factor out the entry removal
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-17-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5585; i=brauner@kernel.org;
 h=from:subject:message-id; bh=s/vomeS/MbQXxph32te55T63SGt/GBU1Mp8VKWLPyDU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7IkPece/R6l3udbfdq2rMy6eLBNKmfL+m2fUvMrgC
 Y0rd87v6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI5HaG/5UrP2VzLFt07+P6
 DDenZ68ZdL6fOnXK0dJ/i/XjokOhjkIM/ywkyorNumeuOnz44nIW77Cc+3XM3IGH5rqe/bBymW2
 sCRsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D176160006
X-Stat-Signature: 8qbxzaduczizc7bxtauzo3799x4c7gjg
X-HE-Tag: 1783676034-96583
X-HE-Meta: U2FsdGVkX1/03Rhel529E42xIVLrP9NHB6UQLY1R/DMxZUlcxAD0L6sVGCEMg3xWOfD40/x0C06ZysV+0Cg99ajq/IyL8MfZs6u7bWyvz12tmUHe7rERIDyxqKeC0WZsp0KVwtqC+OKM9qVVDEW0djGlrd1aSP9e6HQB+mwQQTgDoSf1e6v9FIHaTqHDjPLIGTJ8/w3d7AfEac7zo9M26C2UPAfz4yjz6Cd/qB289sRTqkz6nGOyf46981D8bV2dZw4VNitk98Ku98lK5fplsrVTP47OLwprpsJNYd53N46XDO2n/KQCmqSkB43w85haYnagddSmvpzDs7IgXQlmwv4ETCsQvU8E7NZvYdPqcLkD1v/RPbfaLo66rBf4EbBZxT/NnIyJ7Phr/sk9uxOWGRDD6+WiqG7pMHRjV+8aCyZiNsciPk5ncZOi4vsPXGuZKESOr0zcLrHs23JTAojNhDUrqknhRKKr0plPzTeJ9suZdH0vbnefABSE432HZxey4ov9tg6voztf93y3H/zX1KpCtttct+F8Hno/7fclIv1cdB7/zo4hmegrABLYR0iHgcC0wLiIcuJ6MsIyr2HmpGCA6Vbtkk/Rk5oSJGrshAn4spj1UJ1v0Sl7R8YM60aAePFG+iZMKgIrG3f2u16IL8MBa5Bdkv1/8xcoOo2c4l4ffo8OVGbpDoDWx1AzXxMwlqY9ObScz4NZydbqRer3xkWZVaKT2KDErJvpC9hwUDJkIDuJ2cAOmIQN6X5m6DCealMUq1f0Rpj+7MUuSkNBXWwG49R9UDezM5WpOOTwphWyzY82qBwuunWVxqJAIgDQWGZAdaLKIzituWOxVU+w/dufvOcxoZruCf9g540ycuBN4VnFNqKUtK8zJYFgpZwVKhV64IC4EZM9BZAzuMvI5aBx8v+zT0Ef0/R5vLqZTa75y9Mn+msUHFCX7LJYaZwoSWgwgGjtoFeErrYx8uh
 bouBhAzo
 /d2VEl0Em8ICZleDbtv6eJVVcHgJCWSUl+XWCsuT8sTPiBAIxE1VYecw5db+q9H6SHdvjvD8RuFc5fbNB999CutdCDKHUKLCQ1badD+Nl81QvirkvMK8CQtqZEs/sW9vy6MVW+mVa53PzdQZeYLkmkKbiXiIXurrogc4MCRygLLw4uCi4xL269IwpbKiOSFbfROmUxmUlMsR/aBaN0rSrZBMLdSlTRMioAXETeiHuBlB97FQ8XOQsoF6Y5EBxTmP5Nzcp8lKAE1Z5A+FHJzBgsKtAapP4pNS0kn7p8Lsk+7a7AEP2yflODidhoVoqYoNfNyOwZKSCdRiQZkwyUb8XBP0sokwwQnTiAwEBjY9xaOS1ulg=
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
index 1f2b1d136819..d6bc2abc4a7f 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -686,11 +686,19 @@ static void bm_evict_inode(struct inode *inode)
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
@@ -701,6 +709,31 @@ static void remove_binfmt_handler(struct binfmt_misc *misc,
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
@@ -732,24 +765,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
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
@@ -865,9 +881,6 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 {
 	struct binfmt_misc *misc;
 	int res = parse_command(buffer, count);
-	struct hlist_node *next;
-	struct inode *inode;
-	struct binfmt_misc_entry *e;
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {
@@ -878,24 +891,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
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


