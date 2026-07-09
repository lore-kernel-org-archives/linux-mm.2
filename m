Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17515C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A8B6B0093; Thu,  9 Jul 2026 18:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632CE6B0095; Thu,  9 Jul 2026 18:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB226B0096; Thu,  9 Jul 2026 18:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12B226B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80683402F5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:26 +0000 (UTC)
X-FDA: 84970683252.22.4F71761
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C218780003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YV4V4NHU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pldXDPPLydih2vs5vP2jfMLMsZXXHWIISdyJZRPePC0=;
	b=uMk4C/OuN32ROXdAsgjJhDT/KBpNhY0PdtFrAtMApzczJ3FYuxvPFCb7rh5ykfL2WN8keG
	qaAqtWFSaNBavYMBcyn6G4h2Ds2C+9hb4Gp64NGk3hdF6uF72yR1JBPvMhAHpd4H3USm9E
	G66zX+DQm4+yfZ8hEpzNjW8kvpdA5VY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YV4V4NHU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636224;
	b=M6ddaNS2+ddnG/HZHZs5BXmn9/mDE/xH5LPC1EZJ3u0lCt2b5nyTcb4aJK0vnVwRZ5LeW+
	UPOUckRvEzv9XPT/fhbFSpV47QZA8ZlZoZVkEFwQVAXqs778a0lDd4k55w4dNR0D09PTt6
	R7LhbeQGHocS/M6ldUU1BwFDBdrZBIE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E32661836;
	Thu,  9 Jul 2026 22:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BAA1F00A3D;
	Thu,  9 Jul 2026 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636224;
	bh=pldXDPPLydih2vs5vP2jfMLMsZXXHWIISdyJZRPePC0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YV4V4NHUr7+EODbMN60ycetPuFLm6BecVcbL1Fk3wH15OATqSu8nbzMxmynKPHfnl
	 Dmp2D9Q8we0KbTL1aIojx+/k6yeau35zMzibriJqzkFXWQrazwbHUi8xGDS8BxXqoD
	 BhKr3TjNOiDxiQSshmBzfKrO4VEqHu3oGi3qsPCII+iy0ck61ivZb6jZPLFioIAr9U
	 bMib3Ct3pgIfFgBPGLsfxicBtWAh0YqRIaKH9PRL5jJeztIqhJ3xhFBCOaMmtRJkXO
	 lEmBX6mgdc/D1BKUm2B15KGrkB0BMbGK/uzzuR30oTA9iZHBNVC6X25+gjFNfMEOM4
	 VKmBeOfjqNw+w==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:29:59 +0200
Subject: [PATCH v2 04/23] binfmt_misc: use RCU for the handler lookup
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-4-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=9608; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/namHj7AAAPs1Rc/Lq8mW/GtxxQeDFBTlQUn0UHq3RU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHz9vXqKm+cu669p1dJeZrlTuL5+T4764Pumue7SE
 dfwj1zfOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyuZThf85yx9A5qQGfZfbu
 +b52KuNfjetdzLlHnh6W7cnK2/5bvYThn+a8429CfmQHnQpQ+1nU9PqE+bOkrVM0ywVsNkvwC8+
 dzwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C218780003
X-Stat-Signature: xpkh1iwi6wc7mt9f7ikj1iferhnsei75
X-Rspam-User: 
X-HE-Tag: 1783636224-484922
X-HE-Meta: U2FsdGVkX18ce5nhGq/VQFUtTOqXti1ZpgS4/7DdCp2DWHsx/ajEj692qLmL8Oij5dVhnMxMgXidF29/u14nV4Q/GaIiQTjT020WYaeMnwvk4/mgil+rMS0nMlvpE0zcC5ETosbUkeToRyH/z2JfeCja7bLbZw0s7J2lus8X4P0ZsJIx45sRx0vb0+I+OwDIu2u8iCDvUK+Bd93C/Imiccu68SHCB23g+yT+sGFN2kykG2jq+grONAJWRvNtBZvX0OWmyEveLS2vJh4odsP1fkxbYnEVLDKWHMhsLARtM28q5UhKvrIUCfpVqGZXzPpkJ34GL9rdHzGfEyfU3x5om5M/I37NBiVhlSo+Yf2WTEfdUEGFZth6VydVfJo6pe3QZduWdSgey05ebmwbKCKdgLT99IqJWUR1rmSVGzinAoCZ8LzJt0W9c8dmXRAXNdgGOcQrcor7GjzLvxIRk+0ju1ZQVk2PXWasa3zpLjoV62yE1Fdd76qqTI+hR0t80ZguLT4kMK0gRLLYe6q7nyps1q0EUpp1HxDwfHk9OalMDDm/GUlTIBMyweoHEtZcBqaQwnbJlz3BvC5nZlwdtv/lafjATgrPCJy5AJdJuBoNiF9ornAsog4p/VAH+ihnt8thMA5rTAt+geCTNaMx5jeTlusiJIz0QroZ8AXQi0QiIGfI7vYyEDoWoyMLFcktotqXsXIsCnw8aGG41YieKOxA9iQwlZG7+pmxmvkSPPzXsc+xGR6YhLIF7W5UEXY0H/WE9mVu7Ze5pTxyB7yzXt8+JZH85prnMUH5yIjY/H+tSgu8NJBUQvo6HFyPiUvlQR+wr5JgvZh2ubd8vXOdGH8TCvOOpz5e+nya+LY4f2OH9kyrWANbqJL/4j13rJw03Y8I1QiO5rb8gpcmctZdlPKIYcgkmvA4eFdFm6NEKZxKE6Br3uyT84U+264ysfGtW+VRYNuDia9576L5T6PG+9k
 em3gVZTm
 JgEPMN2wveeeJ3htniLfZBWx8vzJYeFMGshY5Tuvggcn63niV0YO+gFdyb4FLkm9mVnlwtBuU5EDksDWou8FIu83ReIBwOoL696HtwfMMTD9pXNvrHVB4DhPwDJrrMPk3Ik9PpOIVKjEqJ+7XrN9CId7pVREa0HuTLAi1b3+HCZSGOWAwJoSM2yPNQN+RP3QEfXgrZhDU8qPG96Bwv3TRbzSfZniaiYMErgO+J1QmtBDyweeKE0e4plGmoJxDouRJEUhM+4Y3w91OBgmn+iimZksKpk4MBl7CtmRr6T9KRqXHOR2bzt0JyQ31U298NZj+I4we3q54auyHfSjcebvxYFfpd8RZ6LHjsYSXJ1oCCcVbXjM=
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
index ab7dbd898977..08fd7991d4c8 100644
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
 
@@ -675,10 +682,10 @@ static void bm_evict_inode(struct inode *inode)
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
@@ -697,9 +704,9 @@ static void bm_evict_inode(struct inode *inode)
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
 
@@ -750,9 +757,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
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
@@ -797,9 +806,9 @@ static int add_entry(Node *e, struct super_block *sb)
 
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
@@ -895,9 +904,11 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
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
@@ -975,7 +986,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
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


