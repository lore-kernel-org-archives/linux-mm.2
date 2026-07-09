Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D2AEC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744CC6B008C; Thu,  9 Jul 2026 18:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5A26B0092; Thu,  9 Jul 2026 18:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6328E6B0093; Thu,  9 Jul 2026 18:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37E626B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B837D1C32BD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:24 +0000 (UTC)
X-FDA: 84970683168.16.185885D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 07C5D160011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CK/MBKNR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636223;
	b=cvZSFkbl1T2hX60fnJPXzO5AFtqrMzbmZUon01aT5Ynbr43fwyG9d4SsawWgKQFQ1OSppu
	rffPUlAzW+A65GKC2bupK9WQ+wtCkNc2fIeTNP4lSK30EC0pfzUSjOB123kz73Ufkuc7cD
	qvjMaYnUqrcZaz9MsJf+7hBKn+UyV5M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CK/MBKNR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vMyuSi7gzb6O0VdBFMx0MJUBdwyDUatYS2gTmPOsA0U=;
	b=3dmEbXFkxxGZdR6gTk0VhE2+sw3fmqFSfoFnXufOGCADehMPB412jhDIl85C+85C5a0T/i
	ldySKgjVvk1YO+N+C2btjkC0P+LqauUD4do00htcOcE/x8Uq8/tdSmPea+unp+O/s1kCP6
	+cAezrSumXMdqnU3dECwLX/SWGftVF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63BAD43D6A;
	Thu,  9 Jul 2026 22:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A781F00A3A;
	Thu,  9 Jul 2026 22:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636222;
	bh=vMyuSi7gzb6O0VdBFMx0MJUBdwyDUatYS2gTmPOsA0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CK/MBKNR342u/WAxiwPW2N5vj3qLGW3awgYFm6hPJQgdoO2RvB5KcWtRImWSUKp+I
	 bHE80QB56ejWzaSiaIHOXB/4Jfq3t2zXkw3Wa7yFP6NMMa1DunONBJU+61ZukpSqCl
	 8BYdjT7mMLRwnQ9iw5DP9P16g3E0k8i885AtSW/3K6FbrzY7TTWbCrePwlSZD83cNO
	 qxSzotY/UZIV7jtwFcy2FaTwNo/MliFAkAV+29l1aaCxuEu6f61Zz2LrrCx5FbGZBr
	 4votkWlZ7JK1t3eyq5LkRe2lURhRhyXbAsGS2/nyo5Dg3nOZq64oRGtDDBhcl9jBew
	 aMSKOObBkE8fQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:29:58 +0200
Subject: [PATCH v2 03/23] binfmt_misc: convert entry list to an hlist
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-3-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5590; i=brauner@kernel.org;
 h=from:subject:message-id; bh=K7+oalDrHMTeNQ9AP6yNW0Cu9brM96qW++KI833Vybk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHxd4jg7q2+mqfP9AB6WQtG4GJOsjoleTY8cN10sD
 Q74q+bZUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJFrCxn+1x14E9dv1iR4pW3B
 Hw/1R3XxYfveL04w5PIKMi3fcrjPgZFh+VPZvwLLbRcVbZqjfqzOe86HHI3fdrkTvix8pHyQ7b0
 4PwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 07C5D160011
X-Rspam-User: 
X-Stat-Signature: 93hygxd3qb31k7jwjtet6wo91f7mye5x
X-Rspamd-Server: rspam03
X-HE-Tag: 1783636222-581326
X-HE-Meta: U2FsdGVkX1/iEmWNDF97OHSAmASXdcqKIeXJFqsElbcUqjsr1lIk1+LYsSMrhyRJ02lRLFULy01MdCeut2kCgexKmnajuP0+Jk3QHH1K5f2zUlrMbq25OkzwTuTACdCtJrn3s/g2LEQVQUtphJ+KWjWUIxOqaIL8Mf3JiWp5Mpac9hKnTWkr1DkeMyOkjUEOYBcEOjSJozPtrNnVH4EXXh+PQL27Zd2155plQPg8FblnSaXILj2Wh2wT8A3sac0HS+KG70rnnNU2jAcaukiTCjG8cMYeFqEC9OVngKUl3aewZ7hexQkxVK0FjKvw3mK+zQxfFaKY36XDZHNik9YSM5fLqRC7ghB/G1tHfHXdHn8R3ozbizN9ENM4obKzkw5cz/cTQaWCNfR6/K4C8W4B/XFnAhTNwKbc4h99YeIOoJDDgGUrSV+JLA0dx3NcqD4p+/e7OfNOKCz4ZBaCRgqDA9Izv1umuI0Sv8ebB9b7rlUGQp4STg7PM0NO4e5GCA7enIZe7+oE1RGUEwuNrf5FZ1XnFuVUQx9rIHVY+ZeaJxVjzEg51TjWYxJl5knw6TTQFt20Gmd2aj6KX3JUJ4RZ9Xt3nguCtBkaSZ9bx19v8RvoRamxnGpjqOfqtEHzUJ2mrS8QbH0kHVfExl5PQfMH2ZuvIIUHUtZMXw4oVT0i6UqtZwdrVsgYVIYSekWCSEpg/8hpNVLao8G11Rfkdh5G2xkIisaLCA6F6qjTLCnyBwowTRkBFXNrxN8h5irDmkKYQiS4maTucRBCVWEtoNFnJdBNPmKEXk+JRRB1lTgy/nPKxuyVBhdg5ap5NZ9Frhj4d0qiyvWbLrk8HrzaxkDEfP+z6XLT/Y0y7bhVX76W0U196UttvhMHZ7NfeLs2q9qa7DO0vf0HmyggHtmS/MjJVcsznJJgI3uYr6th3Db82CUrQt1jXSHP/A8E6NmrXwjaWkYE5h0yCo1xrZQZkun
 wuNhOHLA
 usGETtI6agAPwDssfNBnGL+Bz46lNMnnlnIsB0jwyfMdMdjhMzkcoRnAzh0NsABnwWtuox47BeIp1ddfpujtlx8W2ot9o2hl39xSG+ehD9Jrq/Q92il2D79RzsmgCZbhSxhKPEfruIRxh9HoPQV0OkqOBX8MrzY39e3TlgrB/lUNBfz059qJ45d8QK9s5JtPcrKpRZIQ7Qo74B8ATRlCbBBHG93BRxiVV7OUuO4olquuJUt/LczluS7AHlWMcXX5SCp8fZtHslRLeVvxMkHK9xvz0RgwvUrXWfCxIsuaEc0u6MublbNnPAUU+ofdoomdm09TdvyKDFx7h2lLuqTGorQ+Zv5nejT36tAh2Dv/ZluEebHM=
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
index 24142859658c..ab7dbd898977 100644
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
 
@@ -662,8 +662,8 @@ static struct binfmt_misc *i_binfmt_misc(struct inode *inode)
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
@@ -676,8 +676,8 @@ static void bm_evict_inode(struct inode *inode)
 
 		misc = i_binfmt_misc(inode);
 		write_lock(&misc->entries_lock);
-		if (!list_empty(&e->list))
-			list_del_init(&e->list);
+		if (!hlist_unhashed(&e->node))
+			hlist_del_init(&e->node);
 		write_unlock(&misc->entries_lock);
 		put_binfmt_handler(e);
 	}
@@ -698,7 +698,7 @@ static void bm_evict_inode(struct inode *inode)
 static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
 {
 	write_lock(&misc->entries_lock);
-	list_del_init(&e->list);
+	hlist_del_init(&e->node);
 	write_unlock(&misc->entries_lock);
 	locked_recursive_removal(e->dentry, NULL);
 }
@@ -754,7 +754,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 		 * read-only. So we only need to take the write lock when we
 		 * actually remove the entry from the list.
 		 */
-		if (!list_empty(&e->list))
+		if (!hlist_unhashed(&e->node))
 			remove_binfmt_handler(i_binfmt_misc(inode), e);
 
 		inode_unlock(inode);
@@ -798,7 +798,7 @@ static int add_entry(Node *e, struct super_block *sb)
 	d_make_persistent(dentry, inode);
 	misc = i_binfmt_misc(inode);
 	write_lock(&misc->entries_lock);
-	list_add(&e->list, &misc->entries);
+	hlist_add_head(&e->node, &misc->entries);
 	write_unlock(&misc->entries_lock);
 	simple_done_creating(dentry);
 	return 0;
@@ -871,8 +871,9 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 {
 	struct binfmt_misc *misc;
 	int res = parse_command(buffer, count);
-	Node *e, *next;
+	struct hlist_node *next;
 	struct inode *inode;
+	Node *e;
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {
@@ -898,7 +899,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 		 * read-only. So we only need to take the write lock when we
 		 * actually remove the entry from the list.
 		 */
-		list_for_each_entry_safe(e, next, &misc->entries, list)
+		hlist_for_each_entry_safe(e, next, &misc->entries, node)
 			remove_binfmt_handler(misc, e);
 
 		inode_unlock(inode);
@@ -973,7 +974,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
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


