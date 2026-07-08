Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A698C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92756B0096; Wed,  8 Jul 2026 12:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F41E6B0098; Wed,  8 Jul 2026 12:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E25F6B0099; Wed,  8 Jul 2026 12:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5506B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:51:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3428168713
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:51:25 +0000 (UTC)
X-FDA: 84966200130.16.C9D0D13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C673614000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:51:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/ZiWM1n";
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783529483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsdUs2oQHzftlWYJg+Bmq2Ixgz8LnH+wE6QNo+txWmo=;
	b=xLoi/UpHY4sn2+DBljibPTk2Fefoma9L2BLlI6hmDEO9HY1mmgUMN0+JZT6q1OVal46qyj
	3dZCAzJfB3dQE5C3RoamQJ0bhUnZL1/ssZ2sietJIUtpFD4AEZYPNJsNXffOJOghXL6uW8
	ggh83CQKr5x0gASd8eN5nc7J3NhIwzE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783529483;
	b=k7dHC6CxK/IX0wJJBIsZQ5Ydtj8NN5xweTXjHak0TNeaJxDkxM/ENUmo8RA5IfyMlUl+NY
	2nthoBriAXXAR8m8ptk/n+33CGDCZhheX+WMWaIuhasdGfBhnYixUN3ekkWyb5FMvXc4DE
	8FhoQ4PQN1phEjigzBWEkRatV/goa/E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/ZiWM1n";
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 291D541764;
	Wed,  8 Jul 2026 16:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFE81F000E9;
	Wed,  8 Jul 2026 16:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783529483;
	bh=HsdUs2oQHzftlWYJg+Bmq2Ixgz8LnH+wE6QNo+txWmo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i/ZiWM1nJAKt8SJ2wPnCnSqfljWd2jEfI71ZBHagXqsi+aDmlpKCZVMVVQVdjqffp
	 b7ILvV1iH+lJSynRiIU5/puuWx10YmqC+c3fA1fliaJsB4YDA0Ky4601gHYZSOQjK0
	 ch24lxr55mldMgun2ita/lpo9Fu+FEfyGXpuv8rAPu+ZP+7vCnEt9yAHu9iDh1eppH
	 58Sa4Llq8z2oRMnzRY6hCbOsKbxlU6rz3QJDI8hvO80tN3Aglscafm1kcrQFc63q5X
	 4bOzavImVl31TynuaxEiM5jIgGt2r5QMi3zizlQvG2bP4Ewy1BTSjqveejDsiDoFGT
	 e6BXIZoDy7kcw==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 08 Jul 2026 18:51:16 +0200
Subject: [PATCH 1/3] binfmt_misc: convert entry list to an hlist
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-work-binfmt_misc-locking-v1-1-a009dd5b56db@kernel.org>
References: <20260708-work-binfmt_misc-locking-v1-0-a009dd5b56db@kernel.org>
In-Reply-To: <20260708-work-binfmt_misc-locking-v1-0-a009dd5b56db@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5590; i=brauner@kernel.org;
 h=from:subject:message-id; bh=X0EU2UC5Y9DLFeHVUkJgmE4dCHVzlmnJvafWhW201lE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5NbDvPeNzkaX3kPgVviOp0ibSG6y57E3TuNctzlK5p
 /SSa+7PjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn0CDH8s/TSeRnx3/ZgrAez
 Avvj67wnP29IKJF2zmb3blcMzxVqYPgfKLXZ/8rP18u25M4XYJAKvZxQdeXpO/Wa6WuX21cq5Mk
 xAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C673614000A
X-Stat-Signature: q359ojgwgxt3jt4smupc91se7uas59r3
X-HE-Tag: 1783529483-30092
X-HE-Meta: U2FsdGVkX18Cxp6pfQIYloGxr/e+SY8llq3Hy7NZLRV8hi0FrAVRK0YAxB1vd6oJYN1rcLZwUksKAALH6ccSzeFJpt4L8uE1ksrlIfXtal24HUvIOw7+Z1JTt3wXf8YMAP1mRSRN8A5gbvsvcnq7xQYomnYcNGUrgkQlLXT17OARacxSg9BcTm+FV2YoZCpuEF1YSZgo/ZRbsvPUfsEPdPHRL5+xnnPqmyME3zEe0Od3h9lr13TM6LZfDgvBUoQz9dPGeiV9H5phhTVBnYv+2x5EDI8/PmRWmFmNcXgAP7QJy6cm664n9BClEH6lknOukzMNc3IyaDWAtYJ5LBlVShL2w/7OSQzp2G7VY1gJId8XgO0RlxJzySqGqmsuFh5o2bCzuMFvxZwu0z/DC54PDu8hsuuSZ1di15S91VXaUUq7/4kzttFzCkcf4m3uHw8C4qnbJL42gYb4sKfYzM7+psIOkxiRLpFRWTRGkqjUJPDfGIiBWOpb73Ay6CA5aBwgm/R2TY+/CZCh5hnUbAqUgDtWOvxGwKtpb/y3SOKMLXNf5Z7iXxTtYI5cECsxastyu281jF0kB/m9w5rFvBuUnOGrfEiEzjOrGVA6N1TIhH5nPLgljyNoDutmtJ7nFClogU9xUVW1HbugBSpIZVKys9hqDVFvSip8TrtnuJ1+5AIYde0lorBhe7RPTo7mTqvz+Gb5KpF3p+22FVB6+TAPxphrEusWF/cuuvwhTuhxsYCcQz3fK1pXGiw6/8YJyCbf7DZZZd4ImKR3dZkePRdcNFqANHEVnqGA67txLhUgYnyXyoOwiI4l9PukPCr5rwfXMTV8f3qVuZuKdHW79m3yo6eQqqhv5WfXcyxXzOEzrUUE3Pa6cxrENDwd17lxs9zs1aG1hqq8wGOki+Eqw0Aj0q4O45H5dD7OKoV+0eDziU02Pkl1vQsfmORUZXSdqrKBnpvf5sfNFedvdUYclAl
 7zVBZYh2
 yM+JpQYKeeZ5qyOGiLfo5hoea4P0imcBVMbfzuGdclpaustCaFSYZEdAV8btAqvYO3cVDeTn6KKJ5ZuflSE1g4etgI0CRtZWb44gJHVqlY7jlbKzxEUmAu764LIDZ6fJxlLFMyGHz/I2wDcVm9YA4n16rE0nlX9Mo/FNHzxx6cEN5J3ltQtmCLOy2l4UTKRUeQ6vUDBbCsgv8GMN/58EMKvJTn2HcD43iXZGiUvBZ5j8XDZJwBRjseVogVExO2AL3PaUZeP0KEAex0c5F8GUDHTuGCTdzPM80s/McK3lruZjJmY3YZMfyqziSUbu0X3EoEchbZrcJ/CB2TM+3qfbBe/UGOiajh7wk+C3/tvqnkFaBSf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming conversion of the handler lookup to RCU walks cannot use
list_del_init(): reinitializing the forward pointer of a removed entry
would make a concurrent lockless walker standing on that entry loop
back onto it indefinitely. The removal paths do rely on
reinitialization though because bm_{entry,status}_write() and
bm_evict_inode() need to detect whether an entry has already been
unlinked.

hlists support exactly this pattern: hlist_del_init_rcu() keeps the
forward pointer of the removed entry intact for concurrent walkers and
only zeroes ->pprev with hlist_unhashed() serving as the linked test.

Convert the entry list to an hlist now while keeping the rwlock so the
subsequent RCU conversion is a pure locking change. hlist_add_head()
inserts at the head just as list_add() did so lookup precedence
between registered handlers is unchanged.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c        | 25 +++++++++++++------------
 include/linux/binfmts.h |  2 +-
 kernel/user.c           |  2 +-
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 84349fcb93f1..34de1b01e9c2 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -48,7 +48,7 @@ enum {Enabled, Magic};
 #define MISC_FMT_OPEN_FILE (1UL << 28)
 
 typedef struct {
-	struct list_head list;
+	struct hlist_node node;
 	unsigned long flags;		/* type, status, etc. */
 	int offset;			/* offset of magic */
 	int size;			/* size of magic/mask */
@@ -95,7 +95,7 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
 	Node *e;
 
 	/* Walk all the registered handlers. */
-	list_for_each_entry(e, &misc->entries, list) {
+	hlist_for_each_entry(e, &misc->entries, node) {
 		char *s;
 		int j;
 
@@ -654,8 +654,8 @@ static struct binfmt_misc *i_binfmt_misc(struct inode *inode)
  *
  * If the ->evict call was not caused by a super block shutdown but by a write
  * to remove the entry or all entries via bm_{entry,status}_write() the entry
- * will have already been removed from the list. We keep the list_empty() check
- * to make that explicit.
+ * will have already been removed from the list. We keep the hlist_unhashed()
+ * check to make that explicit.
 */
 static void bm_evict_inode(struct inode *inode)
 {
@@ -668,8 +668,8 @@ static void bm_evict_inode(struct inode *inode)
 
 		misc = i_binfmt_misc(inode);
 		write_lock(&misc->entries_lock);
-		if (!list_empty(&e->list))
-			list_del_init(&e->list);
+		if (!hlist_unhashed(&e->node))
+			hlist_del_init(&e->node);
 		write_unlock(&misc->entries_lock);
 		put_binfmt_handler(e);
 	}
@@ -690,7 +690,7 @@ static void bm_evict_inode(struct inode *inode)
 static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
 {
 	write_lock(&misc->entries_lock);
-	list_del_init(&e->list);
+	hlist_del_init(&e->node);
 	write_unlock(&misc->entries_lock);
 	locked_recursive_removal(e->dentry, NULL);
 }
@@ -746,7 +746,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 		 * read-only. So we only need to take the write lock when we
 		 * actually remove the entry from the list.
 		 */
-		if (!list_empty(&e->list))
+		if (!hlist_unhashed(&e->node))
 			remove_binfmt_handler(i_binfmt_misc(inode), e);
 
 		inode_unlock(inode);
@@ -790,7 +790,7 @@ static int add_entry(Node *e, struct super_block *sb)
 	d_make_persistent(dentry, inode);
 	misc = i_binfmt_misc(inode);
 	write_lock(&misc->entries_lock);
-	list_add(&e->list, &misc->entries);
+	hlist_add_head(&e->node, &misc->entries);
 	write_unlock(&misc->entries_lock);
 	simple_done_creating(dentry);
 	return 0;
@@ -863,8 +863,9 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 {
 	struct binfmt_misc *misc;
 	int res = parse_command(buffer, count);
-	Node *e, *next;
+	struct hlist_node *next;
 	struct inode *inode;
+	Node *e;
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {
@@ -890,7 +891,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 		 * read-only. So we only need to take the write lock when we
 		 * actually remove the entry from the list.
 		 */
-		list_for_each_entry_safe(e, next, &misc->entries, list)
+		hlist_for_each_entry_safe(e, next, &misc->entries, node)
 			remove_binfmt_handler(misc, e);
 
 		inode_unlock(inode);
@@ -965,7 +966,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 		if (!misc)
 			return -ENOMEM;
 
-		INIT_LIST_HEAD(&misc->entries);
+		INIT_HLIST_HEAD(&misc->entries);
 		rwlock_init(&misc->entries_lock);
 
 		/* Pairs with smp_load_acquire() in load_binfmt_misc(). */
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 2c77e383e737..071da63f2b48 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -101,7 +101,7 @@ struct linux_binfmt {
 
 #if IS_ENABLED(CONFIG_BINFMT_MISC)
 struct binfmt_misc {
-	struct list_head entries;
+	struct hlist_head entries;
 	rwlock_t entries_lock;
 	bool enabled;
 } __randomize_layout;
diff --git a/kernel/user.c b/kernel/user.c
index 7aef4e679a6a..c6a2bfb4d918 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -23,7 +23,7 @@
 
 #if IS_ENABLED(CONFIG_BINFMT_MISC)
 struct binfmt_misc init_binfmt_misc = {
-	.entries = LIST_HEAD_INIT(init_binfmt_misc.entries),
+	.entries = HLIST_HEAD_INIT,
 	.enabled = true,
 	.entries_lock = __RW_LOCK_UNLOCKED(init_binfmt_misc.entries_lock),
 };

-- 
2.53.0


