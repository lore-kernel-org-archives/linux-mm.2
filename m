Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5163CC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497626B00D3; Tue, 14 Jul 2026 15:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421A16B00D5; Tue, 14 Jul 2026 15:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9CB6B00D6; Tue, 14 Jul 2026 15:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D97386B00D3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:58:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58C6B403C7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:31 +0000 (UTC)
X-FDA: 84988444422.05.5AD71C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89D69A000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFgVVwEZ;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059109;
	b=eCH4bC9rLFtOzF7Ir6TxaF8BPDFgMy6SujrD7kH3cyw9GkeJIPFMxC4wnKvHjcysweN3Ka
	MFcDetstgwzUnTj5/dzWFtG5P7xabyFqVqKQAfIE8uh9SLvyNH4gRzSI31De9sSAXn7cET
	mgy8TiHtv+s6YtQHoLOlelBjfj0SuCk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFgVVwEZ;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLO2+bR5jpeBd9Q81ERdDULFJfaWtBYXEBO8mki7g0k=;
	b=3CtPtnQcgKckdmj9o4ezbrPY3tUtVBktICgPibF2NQUvD1ceMlQX9DUGKKDzPtNVRov3mf
	wuqAsEr29Q5S5J1nqy8Vu/tMNGde3/iMpTTo24qTLc/ReUbt7zW1LJbrIiha/XgUEVpoRT
	AgfinSsfBdvDv9ElHa3o2bXtM/BIDt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A7AF43A0E;
	Tue, 14 Jul 2026 19:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A3F1F00A3D;
	Tue, 14 Jul 2026 19:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784059108;
	bh=DLO2+bR5jpeBd9Q81ERdDULFJfaWtBYXEBO8mki7g0k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lFgVVwEZ4V2Fk4dPUjN0VKUr1e8ThXb5jUoiBIi/MfL2SVjXomX3Z9wq1WfbcH/kB
	 05VxCqX83dmmkO1okZJdoqDQUQ/6A5V6HO1gPmg7bwpsXHnpe0sVBQ665htOGPqWng
	 2Fs2pu81eZmVntvNKltbBmpplK87yTNkBjgl9tpDDs5usIXlj2M2BhkWLLjCv1lzgh
	 ZYwlFECOli9Zd31mFc4OjJC3+IHo9KozvvTpN8cddOblsmGwWg5X7k4uS+J6PwCL91
	 wWMgW+ffC69e/Mm3515yw2jye14Nr1TNt9yyXVuZBqjvDpkIq2Kcfeku8szsEcFvCp
	 qHcaCwJv+60Yw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 14 Jul 2026 21:58:08 +0200
Subject: [PATCH v2 3/9] binfmt_misc: let the entry lookup walk sleep
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-work-bpf-binfmt_misc-v2-3-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=6836; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jHDwZtWmHJgiqk7RDu4TezAft2BEp7do55HYb8pCEDs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFTbnc5aQcJrZoqbex2mtm72Y/OY4Alv/fZx6fey3ln
 fTsLeWJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABM54MfI8KZKVyU0OPxY1tQ5
 VUq8zaXNxmEKkfLyHS2WZeIT3qsZMTL0rD49bdastzs2qGueWhZ5UZHjwfy97nxOPgsCFaKeHJ3
 MBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 89D69A000C
X-Stat-Signature: of1wwingkj6hp1uijcoho3y1m3csy99k
X-HE-Tag: 1784059109-957503
X-HE-Meta: U2FsdGVkX1/KQByGbST3zEekp5bkAj1B55TLtGlGeltkLBKTDQd1Ykia/AvQB2SFXAlIgTw2EGzwVr1aZMuOFF1i4ijt48mDfv2MmG3+lV+FQSxcfJpuV7/BK1qeZK2zYh2C7le3JhIh8YG/bcqMtQ0evJsLPFSMXEijMcAExUC782mIitc0UzdGL018AR/c84BLZ/ZMQDM0EM4gh4JBsDV/m5L8RwWOSo5Zwxomt2gRorLtVKTNqGBXQaaKjNDC2Vtxq4p3/adZTFoontAI8nFMfRivpBl78cTp4+xzlNZqNie51PfHux+YfflwOsiA12+IFTwY9p2p9VkU9crsM9dG/FEdC/sRvDPLHu5VoZtPH6yQ9UhFkLDGDJqVCHMlTTWMFMqb1B00MpWXaG4KT+mZl4XuLuxluCneGt7Q2JeFOKtKeKBTOx7CWoeM3OgQCPSbUCFTTXD6hdXnamihPJQBhhdziMXUmDnmSqJ9cd5aNU7JTInw+Dm+Iz1u9S4vrmj1HzrQ75PlT6K7Av6iFoeQg+DZVtv/VcL7widWY/9B87XtPjYFbhoIcCB9hdyc3/WGRZBsOXl6enjl/G1oV7aHFvQSTHH1z4qV5CVCiDzTTB7RztErpSa6bZz3IGyUtBCm9Isjf5FDrfcCud319Plh7SWUlIcP3tEwlriQX09FZ/r2TN5+Rm1i8KsrMHPbop6sRFjRaaIywX6sCjjkqk07/pdsOMAvDrL3DYjDwhEI1FRmx/+5MN11DywXhBjyWQoxdJlH99MS7UnGTkvwUxXaQvHnvq6/L02rqpWTWLPzuJqfwREOz/tyivCGN+xs3PUzS6wUbVSclT2uHqpletkQAtp8f31F97oxSqCcFYGr8lZV6COy36DbmxPHuDoUcE0wMzaMRwIdgYCg4I5PPyKkQu/VbT+vvJ5MoAxepCSSfTrnoTmLPVL4i7fO6rExI8KQUEGptFyKid935Mh
 D4koJTGT
 VKwdFOVVV8PM/NSRex4QlHP9dFp/xN5TYRvCQYRMZA8KWAsbGzCFn0FFr0C0js8zP02Iwy70cpOSlkFIK0sk6RheTYXyA7RsXVejqXcAhZsBi3nnFhFyj1ctHxR4idg09nkYHNnE4xy4dWbkBvGzR6odWSx6mQkzLKGrIhazqIwYWGlvz9F3llq700CWsPEObOy2cJasBC8kb9UURckyj5F1SGY4FUTPNguC9E7s2VFbE3z40S36eRWUKE0Hxxr5C5PQ7zSqREEF+KGEH9W/Lc9M4z7MUZjWPt2hfmaSVdD+AVpghQZklDXyYGjTB3jHINlfuWUS1g09VBoq0JN8jWOv90lxer7Vl/YwMAujsYe043awL9xxa5Ib9uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming bpf-backed binary type handlers run a match program from
the entry lookup walk in load_misc_binary(). Deciding whether a handler
applies means reading the binary - parsing ELF program headers sitting
at arbitrary file offsets, say - and reliable file reads at exec time
fault in the file's pages, so the walk must tolerate an entry's
evaluation sleeping.

Switch the walk from RCU to SRCU in its fast flavor: srcu-fast read
sections may block while the read side stays practically as cheap as
the RCU read lock it replaces, so the common static-entry lookup does
not pay for the new capability. Entry freeing moves from kfree_rcu()
to call_srcu(). Removal still unlinks the entry immediately and never
blocks: a walker sleeping inside an entry's evaluation just keeps the
entry alive until it leaves the read section. The module exit path
flushes pending callbacks with srcu_barrier().

Take the reference on a matched entry at the match point inside the
walk instead of retrying the whole search when the refcount raise
fails. A restarted search was harmless when an entry's evaluation was
a memcmp() on bprm->buf, but re-running match programs that may sleep
on entries that were already consulted is not. An entry whose refcount
hit zero is unlinked and dying, so treating it as absent and walking
on is exactly what the bounded retry loop converged to, without ever
evaluating an entry twice.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 56 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index fcaad14f81a3..f7264b13645d 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -29,6 +29,7 @@
 #include <linux/refcount.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/srcu.h>
 #include <linux/string.h>
 #include <linux/string_helpers.h>
 #include <linux/uaccess.h>
@@ -82,6 +83,9 @@ struct binfmt_misc_entry {
 /* Trailing delimiter pad so field parsing always terminates at a delimiter. */
 #define MISC_DELIM_PAD 8
 
+/* Protects the entry walk in load_misc_binary(), which may sleep in it. */
+DEFINE_STATIC_SRCU_FAST(bm_entries_srcu);
+
 /* Check if @e's magic matches @bprm's buffer, applying the mask if set. */
 static bool entry_matches_magic(const struct binfmt_misc_entry *e,
 				const struct linux_binprm *bprm)
@@ -111,11 +115,14 @@ static bool entry_matches_extension(const struct binfmt_misc_entry *e,
  * @bprm: binary for which we are looking for a handler
  *
  * Search for a binary type handler for @bprm in the list of registered binary
- * type handlers.
+ * type handlers. The matched entry is returned with a reference taken while
+ * the walk still held it; a dying entry - unlinked with its last reference
+ * gone - cannot be matched and the walk moves on.
  *
- * The caller must hold the RCU read lock.
+ * The caller must hold the bm_entries_srcu read lock, which allows an
+ * entry's evaluation to sleep.
  *
- * Return: binary type list entry on success, NULL on failure
+ * Return: referenced binary type list entry on success, NULL on failure
  */
 static struct binfmt_misc_entry *
 search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
@@ -125,18 +132,23 @@ search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
 	struct binfmt_misc_entry *e;
 
 	/* Walk all the registered handlers. */
-	hlist_for_each_entry_rcu(e, &misc->entries, node) {
+	hlist_for_each_entry_rcu(e, &misc->entries, node,
+				 srcu_read_lock_held(&bm_entries_srcu)) {
 		/* Make sure this one is currently enabled. */
 		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 			continue;
 
 		if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
-			if (entry_matches_magic(e, bprm))
-				return e;
+			if (!entry_matches_magic(e, bprm))
+				continue;
 		} else {
-			if (entry_matches_extension(e, ext))
-				return e;
+			if (!entry_matches_extension(e, ext))
+				continue;
 		}
+
+		/* A dying entry cannot be matched, walk on. */
+		if (refcount_inc_not_zero(&e->users))
+			return e;
 	}
 
 	return NULL;
@@ -147,24 +159,22 @@ search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
  * @misc: handle to binfmt_misc instance
  * @bprm: binary for which we are looking for a handler
  *
- * Try to find a binfmt handler for the binary type. If one is found take a
- * reference to protect against removal via bm_{entry,status}_write(). The
- * refcount of an entry can only drop to zero once it has been unlinked and
- * a restarted search cannot find an unlinked entry again so the retry loop
- * is bounded.
+ * Try to find a binfmt handler for the binary type. If one is found it is
+ * returned with a reference protecting it against removal via
+ * bm_{entry,status}_write().
  *
  * Return: binary type list entry on success, NULL on failure
  */
 static struct binfmt_misc_entry *get_binfmt_handler(struct binfmt_misc *misc,
 						    struct linux_binprm *bprm)
 {
-	struct binfmt_misc_entry *e;
+	guard(srcu_fast)(&bm_entries_srcu);
+	return search_binfmt_handler(misc, bprm);
+}
 
-	guard(rcu)();
-	do {
-		e = search_binfmt_handler(misc, bprm);
-	} while (e && !refcount_inc_not_zero(&e->users));
-	return e;
+static void bm_entry_free_rcu(struct rcu_head *rcu)
+{
+	kfree(container_of(rcu, struct binfmt_misc_entry, rcu));
 }
 
 /**
@@ -182,8 +192,8 @@ static void put_binfmt_handler(struct binfmt_misc_entry *e)
 			exe_file_allow_write_access(e->interp_file);
 			filp_close(e->interp_file, NULL);
 		}
-		/* Lockless walkers may still dereference this entry. */
-		kfree_rcu(e, rcu);
+		/* Walkers may still dereference this entry, even sleeping. */
+		call_srcu(&bm_entries_srcu, &e->rcu, bm_entry_free_rcu);
 	}
 }
 
@@ -670,7 +680,7 @@ static void bm_evict_inode(struct inode *inode)
  * Adding and removing entries via bm_{entry,register,status}_write() and
  * unlink(2) happens under the exclusively held inode lock of the root
  * dentry keeping the list stable for writers. load_misc_binary() walks it
- * concurrently under RCU. The entries_lock is only held around the actual
+ * concurrently under SRCU. The entries_lock is only held around the actual
  * unlink to serialize against bm_evict_inode() which unlinks entries
  * during umount without holding the root inode lock.
  */
@@ -1054,6 +1064,8 @@ static void __exit exit_misc_binfmt(void)
 {
 	unregister_binfmt(&misc_format);
 	unregister_filesystem(&bm_fs_type);
+	/* Flush pending bm_entry_free_rcu() callbacks before the text goes. */
+	srcu_barrier(&bm_entries_srcu);
 }
 
 core_initcall(init_misc_binfmt);

-- 
2.53.0


