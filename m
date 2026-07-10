Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B2DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0996B0099; Fri, 10 Jul 2026 05:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0AA6B009B; Fri, 10 Jul 2026 05:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356F36B009D; Fri, 10 Jul 2026 05:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14CFE6B0099
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE9E7A03B1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:33 +0000 (UTC)
X-FDA: 84972354306.17.4445A7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A10EA0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOyOOyCz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sp44KTW2xY5cnb3oWEQNPAWSe8roimC1ezkKPm0YOlM=;
	b=KjcRmY87a85zCLOEu689P7vPdjR5JIkOvs36w1hj75KtEMPlpvezmOAJsgb+ExCWS4bAKF
	GKeyY8GgdhKDu+XpO9+sUMiyXa99/72w5MaxzR9/42CGUDHY9YaH0qSbJ2VjjmbBJ/cgAr
	ORbZJjiyDa0SYRq2+6FvVA/WJVS5Go4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOyOOyCz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676012;
	b=jKQvm/7+lcxy55N4jo4UHdwLf3Tm49AXSNebmoBpHQCfodrBUQLXWdi2aX4TqHq2kcQxl5
	BRgXXnzbAgIu0I1ATxWtv1dqxHGaiPerhDkN7Mn3ZWApB2WB6WVawgqetnW0JKxF88qdn3
	aUvMF643rTzu9tLPpxKLjkHwVQlaWTE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C6DF601D9;
	Fri, 10 Jul 2026 09:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03E51F00A3A;
	Fri, 10 Jul 2026 09:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676011;
	bh=Sp44KTW2xY5cnb3oWEQNPAWSe8roimC1ezkKPm0YOlM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IOyOOyCzgWnjdVGlAvjW8nfhhvEwEKGohkKTrwiTsmKuVGI4woEivbm0ajojE9Q9W
	 e3iOxR1q6bo9wpXXPJkTBfLyyBq2n+PNZLtBAe+oceVXMaDt2e1oZ+W7InFvGvNiSw
	 nFasB7cB5+zLEBnIMDb2E2tV6eAM4h8TEYjpFvZfl6RC5fRBSF5pb30bZ+QF86FANv
	 5Rq477JjdcGUYnHRuwwvCtihaT2nH9zTCc/ZCnQWF8ZXfm6ID6pBs2/6b0dNSInjOG
	 qtiUMJ7oWw3RFkHTqtSo1ZHT2DAbS/XRdQIJTcBf4LgUMe4EbYL5t65B1f7GRsbhgM
	 vqzcFH7J0sucw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:06 +0200
Subject: [PATCH v3 05/24] binfmt_misc: use RCU for the handler lookup
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-5-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=9608; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TEEUTIIJoNSveJEFGAOJGCFzUCyJC8jT1qjqGXDnCsA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7ImbF+De8/lNvKblFL5zxzTCGYN53qtPNKsry1721
 X79mWr1jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkoMjP8T1gif9qnTsDiiubp
 r6dbfRd2bjfYF+8ncTmvYdFWkfxbBQx/+K/Xs1TKOcifUKjUDpi4qdfGfM6NS5J1n32e7X6tkKT
 GBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ij36r1h3w5xtksxu8p1fbrjk3xia8gg9
X-Rspamd-Queue-Id: 0A10EA0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783676011-819323
X-HE-Meta: U2FsdGVkX1/nQxzRPUVESHLK5uG6F8+P/4c6mOzq7zslLp07Vs5b3sPSm/G9lqPjeEpSUyPCjYa9FTHA8/uWcSjbTG45QZow3aj6LQdE6KUtYNH2dL7FKiGUoVeImSwHDGsnm3FL2pTFR1ElyR5QGdbls0gr0kJa+GDewKu1ibD+WbO5gLdGKIhg1GueUvLfPDRbmH4EqxAY1el/nKIC3Sfff2ZSAyvxamCeBud5IKMMSdHTg8/d107MCo2jA4hmG0tmL4gyTwXdfKkGPdvcdQzKFZbMptHLNJDCsH1aJ65R81VION2PQvtsq1y8Zjq+BZjDP9r8s5LcKhVV9QtMxaaDBsOlt7lXPXjoLNBbtq5i7p91qp+dsUBGg0tAsWe/ziP9MoiLrE4SikPlmuCrDdBa26OYz9RVUTwfoV6FfK3znU3IYf4qnRtAuDkPV7G4KZg5FGwFPNWZt+Bwck2ayZdKWszQEw5B5AvAeTHLy579PKDdr4S3LNkSNLUs9G9j6zKty/nU2R9vit3OvJz/vLiN3BSX9i8fu2t2+1ggaVKdjnPj5/qFVlzQhYVcELUn6V1RcTwLVyVDepKWmcPc/LBUB4s8ZdniyB4Pmp0mgFYpBhXNJqZuhxuolLvwOD5I62y3K8Ia0MDXlG5mGDEpOD3ixgViXqjDwsyHO2qWaKWUFfDawlq0m6N0Gw2d/BGtZHgqyr6uIlDsc3yfGSp+TwxnMxz9RU5TQQSYpc+PbMF6PeqI6Z+QZ1WhKAJFLb8wNqNgOxcw0N9hg88l5ASmPDiA1uofHwaVcSBSyg4cmRIwWFEifgd4URzwztZZp4SDVxPR11iY4UXLSR0mqkBrdzItQmRM4I9d9owFfFdhDkQzMX8FEO6nDW0AFen+Js5ngtVNRj/XxQ1KWfb9DoKUwGgPWA4aayVhKhQiQwhFGKrLqdrJkq3SPc4vNgNIcsB6vU3Y1GOnElzOingsrHD
 sQ1dpp6R
 pNFo2pFLteSrs7mWTvAgYQiOXU4sSuxJ80QUblflYfm4hR3ReQ8dnl+7CXlLyxFgXJSZ79kMJxiQzL6aXmax92vTMEgALzE6tQMFuuLYFZhdDd6QQpLpf5K2yKcaprKq4VY6quOjUCNFVskVdiBL/LA2OTLiqUY/YC0ckbYXHbhLy4751hPsT0oYa7P51bGsZfSb7Hlbx8e/su+z6sbh1MShZSef/lkfULQQcm+9T7Bf5EdXtM4Wntslslq5qkY7ojgamEsVqsJL1RhTYZP6RN9Lx5WeDar3sZjervGwEmcxvGUtpvInNTS09uzYjL0E8kmn/SNTbSMVm/n5YvPCNe2Ooft28aXAqUqx1hrtnS43KUG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once binfmt_misc is loaded load_misc_binary() runs for every execve()
on the system since binfmt_misc registers at the head of the formats
list. Every exec therefore performs read_lock() and read_unlock() on
the entries_lock of the relevant binfmt_misc instance, i.e., two
atomic read-modify-writes on a shared cacheline. User namespaces
without their own binfmt_misc mount fall back to an ancestor's
instance so on container-heavy systems every exec on the machine
typically ends up hammering the cacheline of init_binfmt_misc. On
PREEMPT_RT the rwlock additionally turns the handler lookup into a
sleeping lock on the exec fast path.

The lock protects very little. Entries are immutable after publication
except for the Enabled bit which is already toggled locklessly via
set_bit()/clear_bit() and entry lifetime is already handled by the
users refcount via get_binfmt_handler()/put_binfmt_handler(). The read
lock's only remaining job is to make "the entry is still linked" and
"take a reference" atomic with respect to the unlink sites.

Switch the lookup to an RCU walk:

* Lookup walks the entry list under rcu_read_lock() and acquires a
  reference via refcount_inc_not_zero(). The refcount can only drop to
  zero after an entry has been unlinked so a failed increment means
  the walk raced with an unlink. Restarting the search is bounded
  because an unlinked entry cannot be found again.

* The unlink sites use hlist_del_init_rcu() which keeps the forward
  pointer intact for concurrent walkers and preserves hlist_unhashed()
  as the protection against double removal.

* The final put frees the entry via kfree_rcu() as a concurrent walker
  may still dereference its flags, magic, mask, and inline strings.
  They all live in the entry allocation itself and thus stay valid
  until a grace period has elapsed. Closing the interpreter file stays
  synchronous. It is only used with a reference already held and all
  final puts run in process context.

* Writers remain serialized by the inode lock of the root dentry with
  one exception. bm_evict_inode() called from generic_shutdown_super()
  during umount unlinks entries without holding it. Keep a spinlock
  around the unlink sites instead of relying on superblock lifetime
  rules to make that exclusion implicit.

Handler removal semantics are unchanged. An exec that acquired a
reference just before its handler was unregistered already completes
with the removed handler today. The read lock never protected against
that, it only made the window smaller.

With this an exec that matches no binfmt_misc entry, the common case,
no longer writes to any shared cacheline at all.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c        | 59 +++++++++++++++++++++++++++++--------------------
 include/linux/binfmts.h |  2 +-
 kernel/user.c           |  2 +-
 3 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 89da2d4e7f91..bd7790a1317b 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -24,6 +24,7 @@
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/rculist.h>
 #include <linux/fs_context.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
@@ -59,6 +60,7 @@ typedef struct {
 	struct dentry *dentry;
 	struct file *interp_file;
 	refcount_t users;		/* sync removal with load_misc_binary() */
+	struct rcu_head rcu;
 } Node;
 
 static struct file_system_type bm_fs_type;
@@ -86,6 +88,8 @@ static struct file_system_type bm_fs_type;
  * Search for a binary type handler for @bprm in the list of registered binary
  * type handlers.
  *
+ * The caller must hold the RCU read lock.
+ *
  * Return: binary type list entry on success, NULL on failure
  */
 static Node *search_binfmt_handler(struct binfmt_misc *misc,
@@ -95,7 +99,7 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
 	Node *e;
 
 	/* Walk all the registered handlers. */
-	hlist_for_each_entry(e, &misc->entries, node) {
+	hlist_for_each_entry_rcu(e, &misc->entries, node) {
 		char *s;
 		int j;
 
@@ -134,7 +138,10 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
  * @bprm: binary for which we are looking for a handler
  *
  * Try to find a binfmt handler for the binary type. If one is found take a
- * reference to protect against removal via bm_{entry,status}_write().
+ * reference to protect against removal via bm_{entry,status}_write(). The
+ * refcount of an entry can only drop to zero once it has been unlinked and
+ * a restarted search cannot find an unlinked entry again so the retry loop
+ * is bounded.
  *
  * Return: binary type list entry on success, NULL on failure
  */
@@ -143,11 +150,10 @@ static Node *get_binfmt_handler(struct binfmt_misc *misc,
 {
 	Node *e;
 
-	read_lock(&misc->entries_lock);
-	e = search_binfmt_handler(misc, bprm);
-	if (e)
-		refcount_inc(&e->users);
-	read_unlock(&misc->entries_lock);
+	guard(rcu)();
+	do {
+		e = search_binfmt_handler(misc, bprm);
+	} while (e && !refcount_inc_not_zero(&e->users));
 	return e;
 }
 
@@ -166,7 +172,8 @@ static void put_binfmt_handler(Node *e)
 			exe_file_allow_write_access(e->interp_file);
 			filp_close(e->interp_file, NULL);
 		}
-		kfree(e);
+		/* Lockless walkers may still dereference this entry. */
+		kfree_rcu(e, rcu);
 	}
 }
 
@@ -679,10 +686,10 @@ static void bm_evict_inode(struct inode *inode)
 		struct binfmt_misc *misc;
 
 		misc = i_binfmt_misc(inode);
-		write_lock(&misc->entries_lock);
+		spin_lock(&misc->entries_lock);
 		if (!hlist_unhashed(&e->node))
-			hlist_del_init(&e->node);
-		write_unlock(&misc->entries_lock);
+			hlist_del_init_rcu(&e->node);
+		spin_unlock(&misc->entries_lock);
 		put_binfmt_handler(e);
 	}
 }
@@ -701,9 +708,9 @@ static void bm_evict_inode(struct inode *inode)
  */
 static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
 {
-	write_lock(&misc->entries_lock);
-	hlist_del_init(&e->node);
-	write_unlock(&misc->entries_lock);
+	spin_lock(&misc->entries_lock);
+	hlist_del_init_rcu(&e->node);
+	spin_unlock(&misc->entries_lock);
 	locked_recursive_removal(e->dentry, NULL);
 }
 
@@ -754,9 +761,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 		 * via bm_{entry,register,status}_write() inode_lock() on the
 		 * root inode must be held.
 		 * The lock is exclusive ensuring that the list can't be
-		 * modified. Only load_misc_binary() can access but does so
-		 * read-only. So we only need to take the write lock when we
-		 * actually remove the entry from the list.
+		 * modified. Only load_misc_binary() can access the list
+		 * concurrently and it does so under RCU. So entries_lock only
+		 * needs to be held when an entry is actually unlinked to
+		 * serialize against bm_evict_inode() during umount which
+		 * unlinks without holding inode_lock.
 		 */
 		if (!hlist_unhashed(&e->node))
 			remove_binfmt_handler(i_binfmt_misc(inode), e);
@@ -801,9 +810,9 @@ static int add_entry(Node *e, struct super_block *sb)
 
 	d_make_persistent(dentry, inode);
 	misc = i_binfmt_misc(inode);
-	write_lock(&misc->entries_lock);
-	hlist_add_head(&e->node, &misc->entries);
-	write_unlock(&misc->entries_lock);
+	spin_lock(&misc->entries_lock);
+	hlist_add_head_rcu(&e->node, &misc->entries);
+	spin_unlock(&misc->entries_lock);
 	simple_done_creating(dentry);
 	return 0;
 }
@@ -899,9 +908,11 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 		 * via bm_{entry,register,status}_write() inode_lock() on the
 		 * root inode must be held.
 		 * The lock is exclusive ensuring that the list can't be
-		 * modified. Only load_misc_binary() can access but does so
-		 * read-only. So we only need to take the write lock when we
-		 * actually remove the entry from the list.
+		 * modified. Only load_misc_binary() can access the list
+		 * concurrently and it does so under RCU. So entries_lock only
+		 * needs to be held when an entry is actually unlinked to
+		 * serialize against bm_evict_inode() during umount which
+		 * unlinks without holding inode_lock.
 		 */
 		hlist_for_each_entry_safe(e, next, &misc->entries, node)
 			remove_binfmt_handler(misc, e);
@@ -979,7 +990,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 			return -ENOMEM;
 
 		INIT_HLIST_HEAD(&misc->entries);
-		rwlock_init(&misc->entries_lock);
+		spin_lock_init(&misc->entries_lock);
 
 		/* Pairs with smp_load_acquire() in load_binfmt_misc(). */
 		smp_store_release(&user_ns->binfmt_misc, misc);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 071da63f2b48..7e7333b7bb0f 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -102,7 +102,7 @@ struct linux_binfmt {
 #if IS_ENABLED(CONFIG_BINFMT_MISC)
 struct binfmt_misc {
 	struct hlist_head entries;
-	rwlock_t entries_lock;
+	spinlock_t entries_lock;
 	bool enabled;
 } __randomize_layout;
 
diff --git a/kernel/user.c b/kernel/user.c
index c6a2bfb4d918..21bafdc11379 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -25,7 +25,7 @@
 struct binfmt_misc init_binfmt_misc = {
 	.entries = HLIST_HEAD_INIT,
 	.enabled = true,
-	.entries_lock = __RW_LOCK_UNLOCKED(init_binfmt_misc.entries_lock),
+	.entries_lock = __SPIN_LOCK_UNLOCKED(init_binfmt_misc.entries_lock),
 };
 EXPORT_SYMBOL_GPL(init_binfmt_misc);
 #endif

-- 
2.53.0


