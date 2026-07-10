Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E321C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9F26B00A2; Fri, 10 Jul 2026 05:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B7D6B00A3; Fri, 10 Jul 2026 05:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7F96B00A4; Fri, 10 Jul 2026 05:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF27A6B00A2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34E841A03A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:41 +0000 (UTC)
X-FDA: 84972354642.19.7562737
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 663DE20006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CaRjv39g;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676019;
	b=TP1KFviDc0WN4Q9EvelkACPv8xHq3msHVAuBbzFAHKQV3WeISXBbK6sllPTL3dDpIaD/Q4
	rEknvxcypwKR4dHClToW+7xx2lwpiIulZ3wC+hMVHoP2s6USlnPoIMEOP1j2kaY/SluT76
	lh67lYbnmTockRWjzT2G1fL0bIZ2at8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CaRjv39g;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKwgfmIDGAu3LPXYRf5/vaqK+XDeZJU9XGY5Zak/ri4=;
	b=gRIvux45xvczXh4pQ+6Rs/9YvrI1+piprGOPAy5Wsy1Nai+Xk1lVAEyTjRVKtapbAjw4mX
	WUmDjc4n0hJJnceZqxP5jfbmj1VJ38y+vPCbB3Vn6NpGiqHq1UqUtT+gdFSD6GEyyQ6Qje
	tUXBfDZXQPNyB2Jhmv3eNWTgKqaodDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B643343A10;
	Fri, 10 Jul 2026 09:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6551F00A3A;
	Fri, 10 Jul 2026 09:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676018;
	bh=tKwgfmIDGAu3LPXYRf5/vaqK+XDeZJU9XGY5Zak/ri4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CaRjv39gPge3PvXwNYNzPn6aUSlkWhM6/vUQClRysHiVdBAULxMYn4V4pTei7yln1
	 y5DdKNS8qQ8grGrhShvBhcZINuWV82Mgc6Wv69umGI54JcjSClHNr0SLVMPrf2lHzk
	 3l6jTTACW/d+CkCpekkHYiPBF6vsyqbngmwEsghmFovINFQ7Hg8SiZdqDXILFrTQLV
	 loLXd95Lmh5AnLSNv2ye258JjaRlX31WNVMWrpXcbpOrFLBZUgDQL/kGa7DmvFCjeQ
	 XuTdG6hEa+UE4uMQGzNYnZmDXil8aE8oXTSSm4XkphaoR/DzrxlExDrAzJGDEakWSN
	 UnIscPflWf3iQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:10 +0200
Subject: [PATCH v3 09/24] binfmt_misc: rename Node to struct
 binfmt_misc_entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-9-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=7737; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gYvyyb9zgjjYOsPEkT2yCbA6U73OI+NDlS2Ck8Kt88I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Ik7++129fyMvttOwvI3Jcs4ztZWS64MO8vjd+5h2
 vtG6W3KHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5xsrI8OPVbonkxRsFmir3
 RO37LpGQVtG+33BtGGt9wbGwp9YTvzD8L42fHnH/0X6d7faGJbkHN1u8e3zWcvXKs3f3yi1Ivzj
 7Mx8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 663DE20006
X-Stat-Signature: apnc7xnr1876f3fzdwo3qubmwpyhsuh6
X-HE-Tag: 1783676019-798303
X-HE-Meta: U2FsdGVkX1+AnjvIzzBlQvv09GOCLCGo9S6XeFwnKm1D7b1/b06tAA1XG4Lt9vqqLHzLZ68pY0JAlpd+mbUs7UwTmVkb5jDVktpsIgKC4VFwQXedYXw3C9MYVUBXfoeOarRROJZy1pvWH6zqvN3Hmq6mVAz01ztXzkZszPbV/sX68nLnxwTzXsV2T1NQMc8M1hrZLuZmfSw8qCMtE1Gg81ZB7O6MDmdJFyVS+j4Tkm47vwriDKbRUCZrCL13Sh/slOK7B1b1mYngVHAomP+hb4ANWHgK1ZZGirHRY5wXMD4dAL7r5NALgCfvLrenisPpt9DF/yFE/r35NN3gwAllvc0+LL8gr9gZ0Q9KrbatcdkC4h+wJRGnwQUzo4shzY9gK/xIx1eurD0ZJ9QlxV/XEq77UaqWIxCEADgd5gBjBo4hE/5gjFAhdok4Cf41YA6dpDW9lx1K6LzyjcX1jYIJSQAQ5UZ1jR9+herrib7VFZn8vBKHHJhf4qh1jkUR09/wkYnBDcVF/0+bROU7qxy2+0vA1QIWgyPjbVhDqK2zo8YEljttHdcxK/UspKeWUKum2xyfgZZHh8zdWMjl9ZADhaWJ1RPJYOR7SkQDov50laVruBWTNrcR68CNfKRLLAhadCd0KnL6hbcOYwjTTXsyuSqvTYjVDtg+ljB3Sxq9/DakwaGUB5A5Wc5oKvTKy+v6cMcIG/ceJ700a5fl+beUEPHhg39kux0061KC9zmOZmBB0nZFKS/HNZmAOCUP2pSf8Gk6Hr816nHAMpbeSL/ojoVbeBm6JZ68XoiTiBgbbuMF833gByjLQE47N3RHFeZeJ7FYAvdFfdSdhaVe8Z1SCvvrGTjRsQ4ZmQabXyHwyAbY5TMkii6CVh8L0Slbc+MwkWfFEFIh0+RjGcCgX2gTtz3JsFoyJg0GlFqokeyd+DYq0NVXsim6KWLVOsJ4iMqkjkp3U9bdOp1YG7bX9gL
 AMnGyR3P
 Yg8rVoB/W6+MhnuxuggzAQR89qLzm6rMzSkbhWLQ5wkVnfSyF2d4gJtdHjldli1+mJPh2gb/CVu/diZVH/8rIfK892XAz8YfbBDOzF4MzcbegSOl7DnrZezn4U+xuRvEQNHDPDLyyOxE+Kz9lgOcllb3Sp8MHr+/5gms9Cv8wQE9NdvDfatbco7BGwWjW5qo5vtsqh5tFzGbMwqlzx4y/F0DkqAJw2zL/mn2T9VmzZPLo4SiErwiDE7kG4e6lN9DlDREV3LZbD9uJ2kM37P45SBW+qP2zV0C8VJ63DL5TPScHOs+6Ok7myTxUnPE/oMqiWi2dPnvyFhXO6GQEvaNVFVqHn4Va2b8+UKnt+w7S2we449s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CamelCase Node typedef is a 1997 leftover and hides that this is
a plain struct. Call it what it is: struct binfmt_misc_entry, matching
struct binfmt_misc that it hangs off of and the entry bit and flag
enums. Drop the typedef, switch the size computations in
create_entry() to sizeof(*e) and adjust the comments that still
referred to the old name.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 60 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 98ad1383ba6b..9be57f387524 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -56,7 +56,7 @@ enum binfmt_misc_entry_flags {
 	MISC_FMT_OPEN_FILE	= (1U << 28),
 };
 
-typedef struct {
+struct binfmt_misc_entry {
 	struct hlist_node node;
 	unsigned long flags;		/* type, status, etc. */
 	int offset;			/* offset of magic */
@@ -69,7 +69,7 @@ typedef struct {
 	struct file *interp_file;
 	refcount_t users;		/* sync removal with load_misc_binary() */
 	struct rcu_head rcu;
-} Node;
+};
 
 static struct file_system_type bm_fs_type;
 
@@ -84,7 +84,7 @@ static struct file_system_type bm_fs_type;
  *  - interp: ~50 bytes
  *  - flags:  5 bytes
  * Round that up a bit, and then back off to hold the internal data
- * (like struct Node).
+ * (like struct binfmt_misc_entry).
  */
 #define MAX_REGISTER_LENGTH 1920
 
@@ -100,11 +100,11 @@ static struct file_system_type bm_fs_type;
  *
  * Return: binary type list entry on success, NULL on failure
  */
-static Node *search_binfmt_handler(struct binfmt_misc *misc,
-				   struct linux_binprm *bprm)
+static struct binfmt_misc_entry *
+search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
 {
 	char *p = strrchr(bprm->interp, '.');
-	Node *e;
+	struct binfmt_misc_entry *e;
 
 	/* Walk all the registered handlers. */
 	hlist_for_each_entry_rcu(e, &misc->entries, node) {
@@ -153,10 +153,10 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
  *
  * Return: binary type list entry on success, NULL on failure
  */
-static Node *get_binfmt_handler(struct binfmt_misc *misc,
-				struct linux_binprm *bprm)
+static struct binfmt_misc_entry *get_binfmt_handler(struct binfmt_misc *misc,
+						    struct linux_binprm *bprm)
 {
-	Node *e;
+	struct binfmt_misc_entry *e;
 
 	guard(rcu)();
 	do {
@@ -166,14 +166,14 @@ static Node *get_binfmt_handler(struct binfmt_misc *misc,
 }
 
 /**
- * put_binfmt_handler - put binary handler node
- * @e: node to put
+ * put_binfmt_handler - put binary handler entry
+ * @e: entry to put
  *
- * Free node syncing with load_misc_binary() and defer final free to
+ * Free entry syncing with load_misc_binary() and defer final free to
  * load_misc_binary() in case it is using the binary type handler we were
  * requested to remove.
  */
-static void put_binfmt_handler(Node *e)
+static void put_binfmt_handler(struct binfmt_misc_entry *e)
 {
 	if (refcount_dec_and_test(&e->users)) {
 		if (e->flags & MISC_FMT_OPEN_FILE) {
@@ -219,7 +219,7 @@ static struct binfmt_misc *load_binfmt_misc(void)
  */
 static int load_misc_binary(struct linux_binprm *bprm)
 {
-	Node *fmt;
+	struct binfmt_misc_entry *fmt;
 	struct file *interp_file = NULL;
 	int retval = -ENOEXEC;
 	struct binfmt_misc *misc;
@@ -290,7 +290,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 ret:
 
 	/*
-	 * If we actually put the node here all concurrent calls to
+	 * If we actually put the entry here all concurrent calls to
 	 * load_misc_binary() will have finished. We also know
 	 * that for the refcount to be zero someone must have concurently
 	 * removed the binary type handler from the list and it's our job to
@@ -326,7 +326,7 @@ static char *scanarg(char *s, char del)
 	return s;
 }
 
-static char *check_special_flags(char *sfs, Node *e)
+static char *check_special_flags(char *sfs, struct binfmt_misc_entry *e)
 {
 	char *p = sfs;
 	int cont = 1;
@@ -370,9 +370,10 @@ static char *check_special_flags(char *sfs, Node *e)
  * ':name:type:offset:magic:mask:interpreter:flags'
  * where the ':' is the IFS, that can be chosen with the first char
  */
-static Node *create_entry(const char __user *buffer, size_t count)
+static struct binfmt_misc_entry *create_entry(const char __user *buffer,
+					      size_t count)
 {
-	Node *e;
+	struct binfmt_misc_entry *e;
 	int memsize, err;
 	char *buf, *p;
 	char del;
@@ -385,14 +386,14 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		goto out;
 
 	err = -ENOMEM;
-	memsize = sizeof(Node) + count + 8;
+	memsize = sizeof(*e) + count + 8;
 	e = kmalloc(memsize, GFP_KERNEL_ACCOUNT);
 	if (!e)
 		goto out;
 
-	p = buf = (char *)e + sizeof(Node);
+	p = buf = (char *)e + sizeof(*e);
 
-	memset(e, 0, sizeof(Node));
+	memset(e, 0, sizeof(*e));
 	if (copy_from_user(buf, buffer, count))
 		goto efault;
 
@@ -602,7 +603,7 @@ static int parse_command(const char __user *buffer, size_t count)
 
 /* generic stuff */
 
-static void entry_status(Node *e, char *page)
+static void entry_status(struct binfmt_misc_entry *e, char *page)
 {
 	char *dp = page;
 	const char *status = "disabled";
@@ -686,7 +687,7 @@ static struct binfmt_misc *i_binfmt_misc(struct inode *inode)
 */
 static void bm_evict_inode(struct inode *inode)
 {
-	Node *e = inode->i_private;
+	struct binfmt_misc_entry *e = inode->i_private;
 
 	clear_inode(inode);
 
@@ -714,7 +715,8 @@ static void bm_evict_inode(struct inode *inode)
  * to use writes to files in order to delete binary type handlers. But it has
  * worked for so long that it's not a pressing issue.
  */
-static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
+static void remove_binfmt_handler(struct binfmt_misc *misc,
+				  struct binfmt_misc_entry *e)
 {
 	spin_lock(&misc->entries_lock);
 	hlist_del_init_rcu(&e->node);
@@ -727,7 +729,7 @@ static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
 static ssize_t
 bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	Node *e = file_inode(file)->i_private;
+	struct binfmt_misc_entry *e = file_inode(file)->i_private;
 	ssize_t res;
 	char *page;
 
@@ -747,7 +749,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *ppos)
 {
 	struct inode *inode = file_inode(file);
-	Node *e = inode->i_private;
+	struct binfmt_misc_entry *e = inode->i_private;
 	int res = parse_command(buffer, count);
 
 	switch (res) {
@@ -796,7 +798,7 @@ static const struct file_operations bm_entry_operations = {
 /* /register */
 
 /* add to filesystem */
-static int add_entry(Node *e, struct super_block *sb)
+static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 {
 	struct dentry *dentry = simple_start_creating(sb->s_root, e->name);
 	struct inode *inode;
@@ -828,7 +830,7 @@ static int add_entry(Node *e, struct super_block *sb)
 static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *ppos)
 {
-	Node *e;
+	struct binfmt_misc_entry *e;
 	struct super_block *sb = file_inode(file)->i_sb;
 	int err = 0;
 	struct file *f = NULL;
@@ -894,7 +896,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 	int res = parse_command(buffer, count);
 	struct hlist_node *next;
 	struct inode *inode;
-	Node *e;
+	struct binfmt_misc_entry *e;
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {

-- 
2.53.0


