Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50EA2C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3FB6B008C; Thu, 30 Jul 2026 09:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B636B0092; Thu, 30 Jul 2026 09:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0D36B0093; Thu, 30 Jul 2026 09:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D09646B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:34:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D4C9A0161
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:47 +0000 (UTC)
X-FDA: 85045538214.24.1E22580
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B4B174000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QbqEvvt/";
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOVAZcleFesftTESMiI+I5WLr6SsWO6dEuEGcLcphYk=;
	b=fWC3P4sKLmRtRZfKD2uRQjdttolb5C/egH55Zo94MZ6pGZT3mifSQAaoxOmCe+ahcZmLr9
	BDW+nltpZrxoX6WhZLfRHwMH/3zHaVhED1AqVLm1Op9PwEqF/gqvgWKa5CV1+UE+Mx+GVx
	glug2iBnt5Wob13q3qON0FBy8Vpf1pM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418485;
	b=gqIwxbsBoucNGiBC7Xi8s8VQPWj8Ifu5MnnWJT6OJyFy11nrnQ7UmmltbHbPPHt9qBzJ4U
	nFV/aaLMvPDoROv0MtmAmaWFOOWz4jtLbHw5eYEOeYN82D5AVyu2jvUE6L/Ts4KA4IUdLR
	SZNg4hr1rZSYFzQDqXEk2Xt37f2pzho=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QbqEvvt/";
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4508F600B1;
	Thu, 30 Jul 2026 13:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EFE1F00A3D;
	Thu, 30 Jul 2026 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418485;
	bh=ZOVAZcleFesftTESMiI+I5WLr6SsWO6dEuEGcLcphYk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QbqEvvt/WhuGlPOLcAdtMUTIWMeAnmAYVMgmkeZyg8u4r2tV2ydaYiNn10ZY9KWDY
	 wQlitPO//HGvF+M7Wjn1PNxqVpo9fJy9+x4Er6UeffOTS2mXpXFGq05HWWiA41Oa8S
	 8W4mg2bPb1NXlS8fPNs5JO5WnNwmWH2uapmGVIBstN/DEOEI5cPf3kcqflsaaTgxn4
	 4HLTW8DJ4ENRJhkByIb9LEiRL0w1EPdnAiwEHkn2iTDTbUnII6PyXbCXbyNIPozVrr
	 A/ANWbP56en6CLXikUEecNwosnprZw2ifyXHo+szFM5EGR5qFeCZFb3EeCB50P6+M4
	 pxaulqPTcSKLQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 30 Jul 2026 15:34:03 +0200
Subject: [PATCH 1/9] binfmt_misc: let a register string create an entry
 disabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-work-binfmt_misc-preopen-v1-1-4a0b0da71f16@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8977; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ffubVVduLLMfNxpTpX0sw0fYfFiETwOhHJHux38zrPw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB727fj3D7OUNp6ZJjoueLZPc+nGNm4r39++3ytIbj
 v5XXX1fpKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiDjUM/4v4N7dOuzHpZkls
 k+Ueq60LldQbGOV0taWXOpsZXxI7/57hf/3lCuGmtIont9p01JPt0s1Dn/y2++5WuMeWaefbTdI
 y3AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4B174000B
X-Stat-Signature: ismx1aapfrhp3r7o1z8dzehpbirojcjx
X-Rspam-User: 
X-HE-Tag: 1785418485-506520
X-HE-Meta: U2FsdGVkX18HQqVWLPSA4Us4fr3vo4CBefFmONIcmuA9+RhXfG6cE6cH/6hLHzZKrzQGRFIWaKyL9W/DOviZPZB7cBeINEhT7b60a7IicJFd2B7I0VEZ3PrPlf/B/xU8lSwH6u9ua44HzLwxExq2arPcLgUp49Wrp/pmZDu19EDNRJcdt/5JPX/WPee1wk2oFqsSFXR9mTTMz5u+opzpESr5eyZhWimp4Jfgfml4up+smCybtwhHMAnLWVs5N1/fiW8QMdYSTiluERG1//WPcqkRJCKJ8DWnOcYFLHVJxOlmrJ0NC8BRJ0x0m0nd4fot6voYEXbcMv8kLjQksI0cnEK0TQHFDDrZ5AqT7jwe9KPaj5AeOizmFTu3ttTvIG7FV5ovybqHELNxQ9L3cweu3Z/eKyCR0cHNcOFcXRCkDPBwr/zEgKAA/ItQt0CAacAsWvN6aVoOvDxBr8fY3e11lWXHWno+6MP7nu9vdbiD9wSqDx9QvIkPzRvfI7P7KDpb8FbqmAuU+NV/BkMSZL+wBO/d8R1XnvH93vnBuHpcnf0l6ud//gf8UOdFYqMDThZy6mHFBbvR/r2s5fGR5GV6T3/gigdlQAfzM/6YTzVhmXe1nDJz8JQWhqSstyGJnPzK44n/6Igdwnbxo3l/zrif7BNODxJkhaeEGWgToxwX6xeYpmnkFz/3d0lSGQxZiwBvc2M6YDdTiBIB6x2lSQgBP5aQxvwrhntGS10bJ8/31hevDvkzGMrwG/MnFxH5u7hS7xQHZAz7Lw7u7gLFuwjfsecCn3bLM6PUtQlkglZaRO6bBvoeM6N4em8I99LD8miMwg4hL8nDasaDWb5jcunBZIUt0EeKIxX36vILDaOJeJjBrmE8IX5bXgsSuRJBTt4miQtYxZeLxGLb3mMw1q42NNgNcgwiZsItMwObYOQt1dhnofkCpRLou661hg0fuRaOAQlljK1ByYFZXjkMDFw
 g/GItX8P
 gudasnYCOEC2j8ljh4yGsQJPIgtwN/0ZKfk21L2KmZml3a5jLCS5i8T7nDJAI1c2+yFme5q8iVTtdfwv2fSO3V3m+G3VSeNa7LHqD4VYH4BMB8RtNxKs4vvt7fh1bi2gWwKzJinGCkAutDDXJ8Uhb7zx51khccxdYwOPUU//DweXeu/azqaesUJ2TfbqQcvWN/jDaUjIPY9U/x43GJ5pWzdO9eR3J/EFeye+SH1tl4GXoqAovb3hihzxj414ut+e0BFfgE2HOqswJmHTMWT39g6NoGBC1Bz0Jhq7rnoiZRW4gCjU+1rCRpd32ByqRrP8aXFwxYuqQMpB6Lik24ntwT8hnrWtYqS7w/q80ppLtU4e9amDeld8cBDlSvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An entry is matchable as soon as it is registered. create_entry() sets
the enabled bit for every type and add_entry() links it straight into the
instance, so everything an entry needs has to fit in the write that
creates it.

Add a 'D' flag. The entry is created disabled and has to be enabled by
writing '1' to its entry file before it can match anything. That splits a
registration into create and activate, which a later patch uses to
configure an entry beyond what one register string can carry. It is
useful on its own too. Entries can be staged without dispatching the
moment they are written.

A staged entry stays out of the search list entirely. add_entry() only
hashes an entry that is born matchable, and the first '1' written to
the entry file hashes a staged one, which takes its place in the search
order at that point. The rcu insertion publishes the fully configured
entry, so the exec side keeps the plain enabled test it always had.

Removal cannot rely on the search list anymore. Whether an entry was
already removed is now decided by its dentry, '-1' to the status file
walks the directory instead of the list so staged entries do not
survive it, and a '1' through a file handle held across a removal
publishes nothing.

'D' is consumed at registration and not recorded. What matters afterwards
is whether the entry is enabled, and the entry file already reports that.

A 'B' entry's flags field had to be empty so far because every flag it
could name shaped the invocation, which a bpf handler picks per exec with
bpf_binprm_set_flags(). 'D' shapes the registration instead. So the rule
becomes what it always meant: a 'B' entry carries no invocation flags,
and 'D' composes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 81 insertions(+), 17 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 707f8a14f8a6..ca7840b01a2b 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -37,6 +37,8 @@
 #include <linux/uaccess.h>
 #include <linux/user_namespace.h>
 
+#include "internal.h"
+
 /* Entry status and match type bit numbers. */
 enum binfmt_misc_entry_bits {
 	MISC_FMT_ENABLED_BIT	= 0,
@@ -52,8 +54,17 @@ enum binfmt_misc_entry_flags {
 	MISC_FMT_OPEN_FILE	= (1U << 28),
 	MISC_FMT_TRANSPARENT	= (1U << 27),
 	MISC_FMT_LOADER		= (1U << 26),
+	MISC_FMT_DISABLED	= (1U << 25),
 };
 
+/* The flags that shape the invocation; a 'B' handler picks those per exec. */
+#define MISC_FMT_INVOCATION_FLAGS (MISC_FMT_PRESERVE_ARGV0 |	\
+				   MISC_FMT_OPEN_BINARY |	\
+				   MISC_FMT_CREDENTIALS |	\
+				   MISC_FMT_OPEN_FILE |		\
+				   MISC_FMT_TRANSPARENT |	\
+				   MISC_FMT_LOADER)
+
 /**
  * struct binfmt_misc_flag - a flag character of the register string
  * @c: the character userspace writes and reads back
@@ -75,6 +86,7 @@ static const struct binfmt_misc_flag misc_flags[] = {
 	{ 'F', MISC_FMT_OPEN_FILE,	0,			"open interpreter file now"	},
 	{ 'T', MISC_FMT_TRANSPARENT,	MISC_FMT_OPEN_BINARY,	"transparent"			},
 	{ 'L', MISC_FMT_LOADER,		0,			"loader substitution"		},
+	{ 'D', MISC_FMT_DISABLED,	0,			"register disabled"		},
 };
 
 /* Look up a flag character, NULL if @c is not one. */
@@ -175,7 +187,12 @@ search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
 	/* Walk all the registered handlers. */
 	hlist_for_each_entry_rcu(e, &misc->entries, node,
 				 srcu_read_lock_held(&bm_entries_srcu)) {
-		/* Make sure this one is currently enabled. */
+		/*
+		 * Make sure this one is currently enabled. An entry enters
+		 * the list at most once and only whole: its configuration is
+		 * ordered before the rcu insertion that makes it visible
+		 * here.
+		 */
 		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 			continue;
 
@@ -684,7 +701,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 					      size_t count)
 {
 	struct binfmt_misc_entry *e __free(kfree) = NULL;
-	char *buf, *p, *flags;
+	char *buf, *p;
 	char del;
 
 	pr_debug("register: received %zu bytes\n", count);
@@ -780,18 +797,29 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	}
 
 	/* Parse the 'flags' field. */
-	flags = p;
 	p = check_special_flags(p, e);
 
 	/*
 	 * A bpf handler decides the invocation flags per exec with
 	 * bpf_binprm_set_flags() rather than fixing them at registration, and
 	 * 'F' (pre-open a fixed interpreter) is meaningless for it, so a 'B'
-	 * entry's flags field has to be empty.
+	 * entry carries no invocation flags.
 	 */
-	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) && p != flags)
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) &&
+	    (e->flags & MISC_FMT_INVOCATION_FLAGS))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * 'D' is a directive for this registration rather than a lasting
+	 * property, so consume it: the entry is created disabled and stays
+	 * out of the search list until '1' is written to its entry file.
+	 * The first enable publishes it, for good.
+	 */
+	if (e->flags & MISC_FMT_DISABLED) {
+		e->flags &= ~MISC_FMT_DISABLED;
+		clear_bit(MISC_FMT_ENABLED_BIT, &e->flags);
+	}
+
 	/* Transparency preserves the whole argv, argv[0] included. */
 	if ((e->flags & MISC_FMT_TRANSPARENT) &&
 	    (e->flags & MISC_FMT_PRESERVE_ARGV0))
@@ -852,6 +880,12 @@ static int parse_command(const char __user *buffer, size_t count)
 
 /* generic stuff */
 
+/* The root directory's inode; its lock serializes configuring an instance. */
+static struct inode *bm_root_inode(struct super_block *sb)
+{
+	return d_inode(sb->s_root);
+}
+
 static void bm_seq_hex(struct seq_file *m, const u8 *data, int size)
 {
 	for (int i = 0; i < size; i++)
@@ -992,10 +1026,11 @@ static void remove_binfmt_handler(struct binfmt_misc *misc,
 /* Remove @e unless it was already removed. */
 static void bm_remove_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 {
-	struct inode *root = d_inode(sb->s_root);
+	struct inode *root = bm_root_inode(sb);
 
 	inode_lock_nested(root, I_MUTEX_PARENT);
-	if (!hlist_unhashed(&e->node))
+	/* A staged entry is not hashed; the dentry says if it was removed. */
+	if (!d_unhashed(e->dentry))
 		remove_binfmt_handler(i_binfmt_misc(root), e);
 	inode_unlock(root);
 }
@@ -1004,13 +1039,21 @@ static void bm_remove_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 static void bm_remove_all_entries(struct binfmt_misc *misc,
 				  struct super_block *sb)
 {
-	struct inode *root = d_inode(sb->s_root);
-	struct binfmt_misc_entry *e;
-	struct hlist_node *next;
+	struct inode *root = bm_root_inode(sb);
+	struct dentry *child = NULL;
 
 	inode_lock_nested(root, I_MUTEX_PARENT);
-	hlist_for_each_entry_safe(e, next, &misc->entries, node)
-		remove_binfmt_handler(misc, e);
+	/*
+	 * Walk the directory rather than the search list: a staged entry
+	 * is in the former but not yet in the latter. The control files
+	 * carry no entry and stay.
+	 */
+	while ((child = find_next_child(sb->s_root, child))) {
+		struct binfmt_misc_entry *e = d_inode(child)->i_private;
+
+		if (e)
+			remove_binfmt_handler(misc, e);
+	}
 	inode_unlock(root);
 }
 
@@ -1067,9 +1110,27 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 	case BM_CMD_DISABLE:
 		clear_bit(MISC_FMT_ENABLED_BIT, &e->flags);
 		break;
-	case BM_CMD_ENABLE:
+	case BM_CMD_ENABLE: {
+		struct inode *root = bm_root_inode(inode->i_sb);
+
+		/*
+		 * The first enable publishes a 'D' entry into the search
+		 * list, whole. The lock keeps that ordered against a second
+		 * enable and against removal; a removed entry has nothing
+		 * left to publish.
+		 */
+		inode_lock(root);
 		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
+		if (hlist_unhashed(&e->node) && !d_unhashed(e->dentry)) {
+			struct binfmt_misc *misc = i_binfmt_misc(inode);
+
+			spin_lock(&misc->entries_lock);
+			hlist_add_head_rcu(&e->node, &misc->entries);
+			spin_unlock(&misc->entries_lock);
+		}
+		inode_unlock(root);
 		break;
+	}
 	case BM_CMD_REMOVE:
 		bm_remove_entry(e, inode->i_sb);
 		break;
@@ -1112,10 +1173,13 @@ static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 	inode->i_fop = &bm_entry_operations;
 
 	d_make_persistent(dentry, inode);
-	misc = i_binfmt_misc(inode);
-	spin_lock(&misc->entries_lock);
-	hlist_add_head_rcu(&e->node, &misc->entries);
-	spin_unlock(&misc->entries_lock);
+	/* A 'D' entry stays out of the search list until its first enable. */
+	if (test_bit(MISC_FMT_ENABLED_BIT, &e->flags)) {
+		misc = i_binfmt_misc(inode);
+		spin_lock(&misc->entries_lock);
+		hlist_add_head_rcu(&e->node, &misc->entries);
+		spin_unlock(&misc->entries_lock);
+	}
 	simple_done_creating(dentry);
 	return 0;
 }

-- 
2.53.0


