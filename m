Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B03DBC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584BA6B009B; Thu, 30 Jul 2026 09:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55CA16B009D; Thu, 30 Jul 2026 09:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472646B009E; Thu, 30 Jul 2026 09:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2529D6B009B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:35:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB3D11C00BD
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:35:02 +0000 (UTC)
X-FDA: 85045538844.14.04738DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D396CC0007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:35:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cu64TiMf;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glwkVERW7ziUEdmJ5pBGKBLfhupGXbebMY+STyIuEXg=;
	b=V5gSOJG++zV2AeAL1MqnGxLXQ0Bjsv1nx2WMebRUOnHcInrum5iTbwMW+DnpVZIIJa7vCO
	TTdwichlnmAwZTD6gqW1gn7MtkmRyi9xeyRdUTnAHZcOGl8EjOkgA/GJUjTdbSsRx64buH
	nhTdlUmQMSfz8cqb0/2wMB9qs8GEL4U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cu64TiMf;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418500;
	b=cq829wuz6hUmgvilfOIL+dMRdnXcKAfQiriG9TbgLwc66iL1qweiygLqwoaQ3ZrGJLjM1Y
	IXGphdgF/NZXLDz/k4Dtv/vNIE/Ih2IJjfIG9e7Lh6JK1is5dxT5MhJkQBGCm4nLxATRnH
	u1ZaY7QOrpRTLzR7vhd0c8CbLEfSRaw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C99C433F7;
	Thu, 30 Jul 2026 13:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2501F00A3A;
	Thu, 30 Jul 2026 13:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418500;
	bh=glwkVERW7ziUEdmJ5pBGKBLfhupGXbebMY+STyIuEXg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cu64TiMfuoZAOxhGBh6YH2GiTNw4VGXDyLDbET6iIlrXeda3LZOSjOvnsuW+nMiFi
	 d9Halxeg2rGDdV/xqHtCdCZDDtx7MVr7kTnEf0fYKRFZoIzgMHjroBhzE2e/aNdmqr
	 IaeIZkB0Ar0kw/ylD8TDFhVizOMh17RmuQ08pLJaiXkMvCAII3VjElmOAa973nCK7z
	 yYboVKOOGY6NWKhHJpeE0St0FYgYDdsplT9KCW3C1vRgy1RjNfP6HDXaXi6R8SmDns
	 L8P/I6egVHNouWeT60xNc9euJWxfjCNE0rFBx1AIE/ZKOLSk77/tbdkIxDnb7CH2Vs
	 kzN/Zx6vgAoUg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 30 Jul 2026 15:34:08 +0200
Subject: [PATCH 6/9] binfmt_misc: carry pre-opened interpreters in struct
 binfmt_misc_interp
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-work-binfmt_misc-preopen-v1-6-4a0b0da71f16@kernel.org>
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
In-Reply-To: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Jonathan Corbet <corbet@lwn.net>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=10142; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Gn0L9OCCHVtAN3s+6K4JE9GEN3K6+4FF0wdBr+LTonA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB72TSb5btnBpym+2m/dEfjZmbXFM+vxiiZBoyYnCX
 WK9EfFTOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayr5Xhf3W5bnGT5rIpTItL
 T629eKl1mouC8Fxv7YDOOQK3ymckzmBk+L7IduW9mbd/H7s97+VFrtVsfxdaTz24zDSu+frp+uf
 7ipgB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: D396CC0007
X-Rspam-User: 
X-Stat-Signature: jxun3k3fdh3t6mftgttrkk1u9zcptt9t
X-Rspamd-Server: rspam04
X-HE-Tag: 1785418500-851285
X-HE-Meta: U2FsdGVkX1/ou6a1Dg7NGY/gvnGQXNikYmm3pdVNXae+6z6BRxWart9FmF9Lljvs6i1kVMyTljt+GeCWRNeG5h7G6ATXKAxYEVzaGHZEsgGlKw72YYghv8DV2BhiQjLt/jn44d5v2F8xRpX/KCBqs0m34R2vbv6JgWwkPriAUlMmbtlcN9VxTcuZ7nCCzOAUs8mc3BKqlfoA/DTHtWeu9r4x9MAn8m/8rPl+AGB+yI2s+TIq4cb4UMhFR28BuUSkYo8acvPIZeur1SFd2kGlk5KGSm4cvc1FwqUPf6EhUfKmjBROf4eAaW8NgqrXmKb2NZhzXZHmR7ptCLEsN1h+sn6eVxz9k7GBNAcHhXSeZIiIneQMHoQ/BuGZIfBW5JJIs+q54hynBJHfhFXojN7h1Gesereup45hKvr3lRhYKSFdEdGdi3Fp5rG11J2owsMvwP2xaM6OsVbY2NG1uuinEfz+s7jb+zTSDryhP/0L85f5VR6h4gHLREgjjLFRjO7NrnrzZLZ9MmN7eL7KXw3fRMFGTzLLevrHkIcYcnDhz4sG1kK4N9pQmHK/6UlzyJDRrbQbyh1bvb2Il7Za4S7HZiXT2ItXSzZTpzQV+o0Ag/BnZk/jUqtooWQCfLq8gcwKKkUf5LPE3IEQK7FF1yzOxVnCdcP01mv01+el2Zar6u7rMgYWPoimqEhVBmMRchVVg3Dw6es5sP7YoYAokY4YtkhKO2hknl4gGau9qcLIgY23pA1lXeiWTpbWbngEIG3CR4iXfTahhZlYAlLTymStQcAASMcj79GYefnhPO+hqTOmtNcRLjIyMeDBT8l49INwcXGtdp9E/G0Ka1BC0iouzBH4yQoS/ixoz6V0xUYiyJauoG1TGGxEN8Z4qrtbiy9RTt+yrnIhsgijZMVbcZer3z86M8lp+35JUitpikoCbDc4KjJKpX9xZLJqu2lcRAfHP5P+m/tKE9Fjn+uHhcY
 fWvgC+TA
 qBHOqA0eD5zSgLnv5g+adHqOYzaUyi5jbsM29SSb9Ppqt88el+lzkqYFIszYmOkGXYSwkHhZcI84eXr07aX+D++Sn0vgCIpEPqRxVQNtFMdBlM46NAcog1CbZ+VzeyWmw44t0GCR3WjZ8Vc4GSJDmnQF51MSVhlQq0cLNXjgKnGYEofgWYQSAEzOGtqM5mr7CyV7ZQ7/YbFO1Q8cGJDcXUG3TEd6pCG6oWLyzDSkXvZvu972FivbIBAp5a79hOobLddkiAJN6qy5XuVAqELfI9M7/iJ5J2TwrnINt5y1en+O5o/6IPc9zRFMUxYSAf6XizGjxLwyIAzyrzRJFFTVBJ5ZpYSvtTfflyblzG2jiEoMvWrmly7DPV812n4U+O4YynvUzJ9Qy9kXvHAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An 'F' entry opens its interpreter at registration and every exec runs a
clone of that file. The file lives in a bare struct file pointer next to
the path it came from and put_binfmt_handler() closes it as a special
case.

Give the pre-opened interpreter a type of its own instead. struct
binfmt_misc_interp carries the file, the path it was opened from and a
selection name in a single allocation and is linked on a list that the
entry owns and tears down in put_binfmt_handler(). An 'F' entry binds a
single interpreter under the empty name and hands out clones of it as
before.

The open moves into open_interp_file() and works exactly as the
open-coded block in bm_register_write() did. It is opened for execution
at registration time, in the writer's context and with the credentials
the register file was opened with.

The entry can now own objects before it is published, so make
put_binfmt_handler() the single teardown. create_entry() returns the
entry with its reference held and every failure path in
bm_register_write() simply puts it. That also replaces the open-coded
bpf_ops release.

No functional changes. A later patch lets a 'B' entry bind multiple
interpreters selected by name per exec and reuses all of this.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 151 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 119 insertions(+), 32 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index ca7840b01a2b..afd8a737c95b 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -24,6 +24,7 @@
 #include <linux/fs_context.h>
 #include <linux/init.h>
 #include <linux/kstrtox.h>
+#include <linux/list.h>
 #include <linux/magic.h>
 #include <linux/module.h>
 #include <linux/printk.h>
@@ -98,6 +99,24 @@ static const struct binfmt_misc_flag *misc_flag_by_char(const char c)
 	return NULL;
 }
 
+/**
+ * struct binfmt_misc_interp - an interpreter an entry was registered with
+ * @list: link in the entry's list, in registration order
+ * @file: the file, opened at registration and never resolved again
+ * @path: the path it was registered under, used as the name the interpreter
+ *        runs under; stored after @name in the same allocation
+ * @name: the name a load program selects it by; empty for the fixed
+ *        interpreter of a static 'F' entry
+ *
+ * Owned by the entry and living exactly as long as it does.
+ */
+struct binfmt_misc_interp {
+	struct list_head	list;
+	struct file		*file;
+	const char		*path;
+	char			name[];
+};
+
 struct binfmt_misc_entry {
 	struct hlist_node node;
 	unsigned long flags;		/* type, status, etc. */
@@ -108,9 +127,9 @@ struct binfmt_misc_entry {
 	const char *interpreter;	/* filename of interpreter */
 	char *name;
 	struct dentry *dentry;
-	struct file *interp_file;
 	const struct binfmt_misc_ops *bpf_ops;	/* bpf-backed handler ('B') */
 	const char *bpf_ops_name;
+	struct list_head interps;	/* the interpreters it bound */
 	refcount_t users;		/* sync removal with load_misc_binary() */
 	struct rcu_head rcu;
 	char buf[];			/* register string, fields point in here */
@@ -233,6 +252,82 @@ static struct binfmt_misc_entry *get_binfmt_handler(struct binfmt_misc *misc,
 	return search_binfmt_handler(misc, bprm);
 }
 
+/* Undo the open_exec() a pre-opened interpreter file came from. */
+static void close_interp_file(struct file *f)
+{
+	if (IS_ERR_OR_NULL(f))
+		return;
+	exe_file_allow_write_access(f);
+	filp_close(f, NULL);
+}
+
+/*
+ * Open an interpreter @path for execution: now, in the writer's context,
+ * and - since binfmt_misc mounts can be unprivileged - with @cred, the
+ * credentials the control file being written was opened with, not the
+ * writer's own.
+ */
+static struct file *open_interp_file(const struct cred *cred, const char *path)
+{
+	struct file *f;
+
+	scoped_with_creds(cred)
+		f = open_exec(path);
+	if (IS_ERR(f))
+		pr_notice("register: failed to install interpreter %s\n", path);
+	return f;
+}
+
+/* Release the interpreters an entry was registered with. */
+static void entry_put_interpreters(struct binfmt_misc_entry *e)
+{
+	struct binfmt_misc_interp *interp, *tmp;
+
+	list_for_each_entry_safe(interp, tmp, &e->interps, list) {
+		list_del(&interp->list);
+		close_interp_file(interp->file);
+		kfree(interp);
+	}
+}
+
+/**
+ * entry_attach_interpreter - bind an opened interpreter to @e
+ * @e: entry being configured
+ * @name: name a load program can select it by; empty for the fixed
+ *        interpreter of a static entry
+ * @path: the path @f was opened from
+ * @f: the interpreter, opened for execution
+ *
+ * Every exec runs a clone of @f, so the path decided which file is bound
+ * and nothing else: it is not resolved again, in any namespace.
+ *
+ * The caller has to have established that @e cannot be matched yet, and
+ * owns @f until this succeeds.
+ *
+ * Return: 0 on success, a negative errno on failure
+ */
+static int entry_attach_interpreter(struct binfmt_misc_entry *e,
+				    const char *name, const char *path,
+				    struct file *f)
+{
+	size_t nlen = strlen(name), plen = strlen(path);
+	struct binfmt_misc_interp *interp;
+
+	/* One allocation, both strings in it, like the entry's own buffer. */
+	interp = kmalloc(struct_size(interp, name, nlen + plen + 2),
+			 GFP_KERNEL_ACCOUNT);
+	if (!interp)
+		return -ENOMEM;
+
+	interp->path = interp->name + nlen + 1;
+	strscpy(interp->name, name, nlen + 1);
+	strscpy(interp->name + nlen + 1, path, plen + 1);
+	interp->file = f;
+	list_add_tail(&interp->list, &e->interps);
+	pr_debug("register: interpreter: %s {%s}\n", name, path);
+	return 0;
+}
+
 static void bm_entry_free_rcu(struct rcu_head *rcu)
 {
 	struct binfmt_misc_entry *e = container_of(rcu, struct binfmt_misc_entry, rcu);
@@ -249,21 +344,22 @@ static void bm_entry_free_rcu(struct rcu_head *rcu)
  *
  * Free entry syncing with load_misc_binary() and defer final free to
  * load_misc_binary() in case it is using the binary type handler we were
- * requested to remove.
+ * requested to remove. Also the teardown for a registration that fails
+ * before add_entry() publishes the entry.
  */
 static void put_binfmt_handler(struct binfmt_misc_entry *e)
 {
+	if (IS_ERR_OR_NULL(e))
+		return;
+
 	if (refcount_dec_and_test(&e->users)) {
-		if (e->flags & MISC_FMT_OPEN_FILE) {
-			exe_file_allow_write_access(e->interp_file);
-			filp_close(e->interp_file, NULL);
-		}
+		entry_put_interpreters(e);
 		/* Walkers may still dereference this entry, even sleeping. */
 		call_srcu(&bm_entries_srcu, &e->rcu, bm_entry_free_rcu);
 	}
 }
 
-DEFINE_FREE(put_binfmt_handler, struct binfmt_misc_entry *, if (_T) put_binfmt_handler(_T))
+DEFINE_FREE(put_binfmt_handler, struct binfmt_misc_entry *, put_binfmt_handler(_T))
 
 /**
  * current_binfmt_misc - get the binfmt_misc instance of the caller's user namespace
@@ -392,12 +488,15 @@ static struct file *entry_open_interpreter(const struct binfmt_misc_entry *e,
 					   const char *interpreter)
 {
 	struct file *interp_file __free(fput) = NULL;
+	struct binfmt_misc_interp *interp;
 	int retval;
 
 	if (!(e->flags & MISC_FMT_OPEN_FILE))
 		return open_exec(interpreter);
 
-	interp_file = file_clone_open(e->interp_file);
+	/* An 'F' entry pre-opened exactly one interpreter. */
+	interp = list_first_entry(&e->interps, struct binfmt_misc_interp, list);
+	interp_file = file_clone_open(interp->file);
 	if (IS_ERR(interp_file))
 		return interp_file;
 
@@ -718,6 +817,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	p = buf = e->buf;
 
 	memset(e, 0, sizeof(*e));
+	INIT_LIST_HEAD(&e->interps);
 	if (copy_from_user(buf, buffer, count))
 		return ERR_PTR(-EFAULT);
 
@@ -842,6 +942,8 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	    e->interpreter[0] != '/')
 		return ERR_PTR(-EINVAL);
 
+	/* Born holding one reference; put_binfmt_handler() is the teardown. */
+	refcount_set(&e->users, 1);
 	return no_free_ptr(e);
 }
 
@@ -1167,7 +1269,6 @@ static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 		return -ENOMEM;
 	}
 
-	refcount_set(&e->users, 1);
 	e->dentry = dentry;
 	inode->i_private = e;
 	inode->i_fop = &bm_entry_operations;
@@ -1187,9 +1288,8 @@ static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *ppos)
 {
-	struct binfmt_misc_entry *e __free(kfree) = NULL;
+	struct binfmt_misc_entry *e __free(put_binfmt_handler) = NULL;
 	struct super_block *sb = file_inode(file)->i_sb;
-	struct file *f = NULL;
 	int err;
 
 	e = create_entry(buffer, count);
@@ -1206,33 +1306,20 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	}
 
 	if (e->flags & MISC_FMT_OPEN_FILE) {
-		/*
-		 * Now that we support unprivileged binfmt_misc mounts make
-		 * sure we use the credentials that the register @file was
-		 * opened with to also open the interpreter. Before that this
-		 * didn't matter much as only a privileged process could open
-		 * the register file.
-		 */
-		scoped_with_creds(file->f_cred)
-			f = open_exec(e->interpreter);
-		if (IS_ERR(f)) {
-			pr_notice("register: failed to install interpreter file %s\n",
-				 e->interpreter);
+		struct file *f = open_interp_file(file->f_cred, e->interpreter);
+
+		if (IS_ERR(f))
 			return PTR_ERR(f);
+		err = entry_attach_interpreter(e, "", e->interpreter, f);
+		if (err) {
+			close_interp_file(f);
+			return err;
 		}
-		e->interp_file = f;
 	}
 
 	err = add_entry(e, sb);
-	if (err) {
-		if (f) {
-			exe_file_allow_write_access(f);
-			filp_close(f, NULL);
-		}
-		if (e->bpf_ops)
-			binfmt_misc_put_ops(e->bpf_ops);
+	if (err)
 		return err;
-	}
 
 	/* The entry is owned by its inode now. */
 	retain_and_null_ptr(e);

-- 
2.53.0


