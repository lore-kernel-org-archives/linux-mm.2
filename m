Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 195E9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215C36B009D; Thu,  9 Jul 2026 18:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6366B009E; Thu,  9 Jul 2026 18:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D446B009F; Thu,  9 Jul 2026 18:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C71C86B009D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4203C1A02E5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:35 +0000 (UTC)
X-FDA: 84970683630.05.522B649
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7208D1C0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UM3HI3Rl;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636233;
	b=8qjgK0isyKBDRrb/aze+vmwKGljuzNkplqHcMCw8LF4C+jrPJNaDbKs7ph9DMF0gsKlvcc
	rj2gH4OPvDN+gL2rYqlkBxbXbSRsdbX8rLZc9g4nxJfjU+p1qWb9pZl2RZoYM+vWlHl3NP
	IhdJq/mghkklnNH4CeM5idVUK04dD0I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UM3HI3Rl;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3No8WjfDQGgq37wK5N+NgPa5iMLCQIBOBqADG8yG6BY=;
	b=2o2d+ZReLggxoULX/2R1Tva0J+PzafwjNl8VYPJQWA6fi6KHqpR6f9ot7aNNodDXy2FeMW
	2nWhFldabASj4HybJl0JsHl8/6Wasj0Zw5JTXfUpeDANhtsozv4jaUeGdNhTAUSlNWNDpB
	UhrYhSB1whvyN7F65dbtnU33zxMzNv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF2D543DD8;
	Thu,  9 Jul 2026 22:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CF11F00A3A;
	Thu,  9 Jul 2026 22:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636232;
	bh=3No8WjfDQGgq37wK5N+NgPa5iMLCQIBOBqADG8yG6BY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UM3HI3RlAbp9JRWNnMXe3mBs/mMhrYVHWYBm4yO1/l8Ea83vS3EqjLqYVJixSpfQp
	 0wlwdZRWYkOzyPR+a/EICh7M127xD2/tvpZfISGPUEPZira8BZywXQ+gIq0qwjKN8n
	 O1A5OR9cEh8v3599euABJ1Xx0T0p9SXpLv0Wo/A0aHeYldakIymI8/R/fMFGc7ZvQs
	 QcHCEKPzSiFEt5iRoqv/MLmTgTmOhGzi1l+5mfONIQY+GBhnxKvqDMMx/frXHzt56f
	 F9pEz7CmpU5ze18HF/diWPWdGpf6w1Vla5wv3JLcNFr4SD0aTwDhYQqmZvGvDdd++G
	 CEj/S8q/A1ctw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:03 +0200
Subject: [PATCH v2 08/23] binfmt_misc: rename Node to struct
 binfmt_misc_entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-8-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=7737; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oM60R7Fk2SBbZZYJvetfg4IE4U9YjrUOt9F4gNDbVxg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHy12MIkPv9JVu6rD/eOhshqLrLtmuzP7TmFwXrXs
 87qqtCEjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIls+sLIMMk5ZuOxlzPSysUv
 rD70qsnn7s3pv7o2fzy/q67++o1jGesZ/lmfKdxYlxh3aL7Bj0e/k4OTvZzZmqyamadOmrdB9GJ
 RJRcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7208D1C0006
X-Stat-Signature: 4mhu45w7dfqqtaug5qr6h8ztoc5uz6z1
X-HE-Tag: 1783636233-482248
X-HE-Meta: U2FsdGVkX1+xwcxGRXZUo9NHs9KeOiZPbSAU/KOOXczKYypMkXROqx5ulWy5DIhpq4PCZ1pGLty+Tz0eqParTMAyG1wrN41CSNUqp9RtKgmJIrByItSkcsKDYxEzUpnGVd+l8dceC+a46K/UYeQZLLvf32zS1DgHROVE2/d9HZr2qp2Tdw5RMq99knKIPQHoSkYtwQ9j5AuHLERgcjS6qEjx/KSdMpGMqGhEkB98FTnBiqfBfjq6S21Z2LhiWG5Wo9VMQvxQgT7M294qBdkmHFl5iz41He8xLO9t09J8Ap2VZPoyPy0u3GC/D7B6KqhWS+rdtfZ64yZEvZHgiOmHLvr5NpRpEtVYjib9OLJYOim8yqbEGqptOdzaTdZiK4J0GfL/efMpvc4yFTqbMptyZL72KUAk8hn3G6Cch9Q1RLE4cieDd7Q/xCt0ydS6ROGc0hTYEiNg2Iuog6VULnfrsXh+8N6pAaaI8j4+qJHGECwJHCoDJRqTiq+V9TK46LMrrK/MYnkktDRnG3dyag7OcYCGKmbSFnK5F/KAozuobcz4LTJZ6wsK5k13dM3xjYAs8MasNijBqwjyymHMhy7TS/KO4NVQvDwYsk2/tUlw0/T7rIer9w5lTXPjhK/EWSAeXe/oakOtqHYt+wBMN1ID3ryrA9vZ0bCSKQgehFmdAjMeHumnZXRDzkhwdsegO3zGLtludVdKuYt7EeUy9oeb6QXfhmkYDUfwD7MuVFhEyQxLlV4xO/GHoKQp8NIt8y6ElK695UDJk9Eb+cjxq4F9k40AW/GezSeNWtnjFi9dHuTaNgWE2p9O/+yc7ocYGJogihcnykrn+xYidJtUHCO6NUBcKEqteCS+DUySAgnMK5e/uGunvEa1LrPc6MPnUDL6/K4z1mujzF6YXawcHKcn3FlWQxUQz7Q6dBuEoQlNrrstDk05DBYKXnFmL48RQ/I0TuaFJ6Af4CSlWCDmRT9
 ZHbDN1B9
 SYt3MwK8ly4gMoYsr5K5KsmKpxhaQtHMD7kSXZOlRm7+z0BYBKUPkfhEdkTFNqqnHZ1NNHvw66jmmrY294JrRwmFNsqN7eyN57ILwkvfO6spreseQ457oiYlR7+Sm0CdOqGwOxjdKYeyFAcuzmyA9Or0A+27c3lxSXqIyN3mXZS9hWMgjzgCH/+Ysh1NT89YI3E57h/FI3KLNrv1hPkj6rq9rlk7sgJBLdbPxCl14e6E/zpQJ7siB1zz9TEyy29VB8sIkm8zRa00WTnBFKjumUxePwJKcmAEum2X73X1Vv/Nv5i88lQT26WQIef2VdI3vS8yPLGCPJZpvhCuO+RWW38/foqQWHawjh7s3W5hOcNFyhmA=
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
index c722ee54c939..93d315758d53 100644
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
 
@@ -598,7 +599,7 @@ static int parse_command(const char __user *buffer, size_t count)
 
 /* generic stuff */
 
-static void entry_status(Node *e, char *page)
+static void entry_status(struct binfmt_misc_entry *e, char *page)
 {
 	char *dp = page;
 	const char *status = "disabled";
@@ -682,7 +683,7 @@ static struct binfmt_misc *i_binfmt_misc(struct inode *inode)
 */
 static void bm_evict_inode(struct inode *inode)
 {
-	Node *e = inode->i_private;
+	struct binfmt_misc_entry *e = inode->i_private;
 
 	clear_inode(inode);
 
@@ -710,7 +711,8 @@ static void bm_evict_inode(struct inode *inode)
  * to use writes to files in order to delete binary type handlers. But it has
  * worked for so long that it's not a pressing issue.
  */
-static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
+static void remove_binfmt_handler(struct binfmt_misc *misc,
+				  struct binfmt_misc_entry *e)
 {
 	spin_lock(&misc->entries_lock);
 	hlist_del_init_rcu(&e->node);
@@ -723,7 +725,7 @@ static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
 static ssize_t
 bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	Node *e = file_inode(file)->i_private;
+	struct binfmt_misc_entry *e = file_inode(file)->i_private;
 	ssize_t res;
 	char *page;
 
@@ -743,7 +745,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *ppos)
 {
 	struct inode *inode = file_inode(file);
-	Node *e = inode->i_private;
+	struct binfmt_misc_entry *e = inode->i_private;
 	int res = parse_command(buffer, count);
 
 	switch (res) {
@@ -792,7 +794,7 @@ static const struct file_operations bm_entry_operations = {
 /* /register */
 
 /* add to filesystem */
-static int add_entry(Node *e, struct super_block *sb)
+static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 {
 	struct dentry *dentry = simple_start_creating(sb->s_root, e->name);
 	struct inode *inode;
@@ -824,7 +826,7 @@ static int add_entry(Node *e, struct super_block *sb)
 static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *ppos)
 {
-	Node *e;
+	struct binfmt_misc_entry *e;
 	struct super_block *sb = file_inode(file)->i_sb;
 	int err = 0;
 	struct file *f = NULL;
@@ -890,7 +892,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 	int res = parse_command(buffer, count);
 	struct hlist_node *next;
 	struct inode *inode;
-	Node *e;
+	struct binfmt_misc_entry *e;
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {

-- 
2.53.0


