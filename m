Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 446C9CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BD9800EA; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4394D800EC; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFD9800EA; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 137B4800E9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2AA1C02E6
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.04.0DD86E4
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E47C80009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Dt+Nd6iW;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCMcASxW4GQs4KES7qr2omvwcK385DadzCf/GiIFZ/s=;
	b=qetGHTFkryHsld3rAvVgW74NhTiiAWL3WmmDgpuqnP00kGYmp8B9AyJqwA8pYH1Vb7krad
	IzPcsJETHp5gyPn3CmYbE7FhD3Rt6ziPi6QTA53YR0AtwBxM5ys63nyxhHrttHn9vTCfao
	+spuwrVOn+/j41EKoNWBFh9N9cU9twM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Dt+Nd6iW;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=xA4quCIGHArH81/XypJE5OnOoFSvV8jf3gsCUmAajMHCiB6Ov7HDaa5mUUWlkBN4rm1HWX
	GhSzzxbDPR8JmCHM4BQBrlWWx0faAA9wgOP+MeFWFyNjvwkmaP9SAGUwioapZE50femE+u
	2Mkmm7n95NjZg/jl5UuO3c9xsGxFFi8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bCMcASxW4GQs4KES7qr2omvwcK385DadzCf/GiIFZ/s=; b=Dt+Nd6iW2PWT2BboUeHXj49Qkn
	Fjms7qsOsZELH0oc4wtwugPD6a8MqzEDL/kpUQIX3zjfUxV9mYiIFlFUAYUbuWKdarDqDFrp6TJAx
	uCoqjVXJBB1fuw2oijmLSN57dAE6UMl4qU8I/9eZyzeFLK4Q/4CEs7MFZMjXM+A8RC0wZUgZpOUb6
	BAEZB2v5CZRIw6+UdzV3t1ZgVXXdA7h45mEIKfA1noSQxEBC9IVm8V0x5VYLmxuTvEUS70HMAcq0D
	hhh+vZb6EzfsVHt1cVFbrbperlGVszCkTRm99S6pflACz5AVgvCPCKE4jG0HNCMo3+o+7dQVIga0R
	R1uO1oRA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eZb-3pWj;
	Tue, 28 Oct 2025 00:46:17 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v2 32/50] convert binfmt_misc
Date: Tue, 28 Oct 2025 00:45:51 +0000
Message-ID: <20251028004614.393374-33-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9n7nkn8g4kuz3o4q3pk79hn3h5gc13tp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2E47C80009
X-HE-Tag: 1761612383-995403
X-HE-Meta: U2FsdGVkX19hQIRD4iXSDO28ygt85xJAj8MQRxluX0Wz+KhxfjYtsvxME+VRNlUjk+RHM7vzNvwaK+YCvB8nVUnbjjunHQb3LxGPQ6yItgZD6QpK5nRLOTd3C/XtwxPS7PAQRl/f6E3kLf8qY8PEfZ+nDOmq4RbdADs4w1Zi3S5EykAnxkVWy3Puwl5pWzDnm278HsXupvpYydpeYK6CJeYUvjZDUZcLjateGON845wL8x5ZX1IxUEAKAgA0cltM62xGuU5tCEGYitbcDci0SbSCwH3LTqKfcL5sBUhxVySP7WrUP7K+O3Su//xKbjORIMMj0ctaMPtdFvvkVcdR4fDdnk0Y+/kZkzkvCczjKP28If/PPLCkYUWHlBpuSE8SD8dNx4bACFtYJXeAZSXMO2IPFYzcQcrEWRZj3RYoXRZxj6BotfZ8k3lbEj5fmBaKldlMf1bkmLb3ZJDE+owFKXDctQvBH2EQwbD8/mlOZVcvRp95RSNkybht6rYWA9P4dW5Q0aoJVcNi45/7R1pkOtEZ1gT+Cf7E03skXQOd/Wj7lRdGKHl2+KhsWMbmTqJKnerzVl+Jgcimth/NcdbYozmWLXx8xoxtZbM5+185Cm7X9kCS4bFYuAbbTUzndZBWYBq0e28N2ciQ0vPQNRAEvNlMosGgkSYtbmLik9EJ/lx0e/Y7OjMSg47g759F7ABlZWlE6j5j0IEsJHj9u5pAEhUXTO4MBytPGstT8oDurZciLZdANmIRPRBYnfUaAnrYR1ZbhsfhhFrFymlq+wc1JSh9YFQMEUVCjZxEFBUa4Zv+1rfGRqcEb4JBkqBoG7O4ooZtTOuxLBJ8AmHBL2XIF55war6CxJH5e+aBUjdx9pDqGXLCO9IRUEJC3awAS5NKmoU0LD3DjcfnJ3A7R4QKzR7NzL6ZKqNPBcymvWx/gvB4Oe0Wc6asxd7m9U7o5swjkSlZftAIV4Qmz40pSTk
 fPodBphB
 aN02MSfupoaRl2GXIb9uUd4GEeWmGZZEK1AneJ5QxlaFjh74Vi0LT4LsJo7UMb1x90ol9NrPf+V6qkyS6b+7eJrVatKkwRDtLp8LmJaJmWXgNa57/8yLr5lKgoSCDF1orVjLV9pr+v+Wz5J3aW5RnyXkFk2X1tR32RHNwAnBD28/E9p+c+xioyXEJeATcoo/qwq2FzNyoLLC8Xc5S3S7102uAUtyK3l1iMQYf6XRgvLkviKKuK3bLlK+78yZjqpzj2x26Uk/HdyD9WLp9XOmfaznZSYipb6e2pxreSF5mCqocFVTVowd/bxZISA8C0fYSaS/ot+y1RHNy7b9HDnciocn4unLtCSn+4QAmLrIonOoGo7GjoH/6xAlNZ/cSWVY6JN0HtQI7fxN8qsGzDgTUfEztIqzxMfJGwJbGNoOdL2oK+aj26Rq+b9C+lvolAx+dr+GYUTqvrE5Z6+g1XeU6tg6fng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

removals are done with locked_recursive_removal(); switch creations to
simple_start_creating()/d_make_persistent()/simple_done_creating() and
take them to a helper (add_entry()), while we are at it - simpler control
flow that way.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/binfmt_misc.c | 69 ++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a839f960cd4a..2093f9dcd321 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -765,14 +765,41 @@ static const struct file_operations bm_entry_operations = {
 
 /* /register */
 
+/* add to filesystem */
+static int add_entry(Node *e, struct super_block *sb)
+{
+	struct dentry *dentry = simple_start_creating(sb->s_root, e->name);
+	struct inode *inode;
+	struct binfmt_misc *misc;
+
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	inode = bm_get_inode(sb, S_IFREG | 0644);
+	if (unlikely(!inode)) {
+		simple_done_creating(dentry);
+		return -ENOMEM;
+	}
+
+	refcount_set(&e->users, 1);
+	e->dentry = dentry;
+	inode->i_private = e;
+	inode->i_fop = &bm_entry_operations;
+
+	d_make_persistent(dentry, inode);
+	misc = i_binfmt_misc(inode);
+	write_lock(&misc->entries_lock);
+	list_add(&e->list, &misc->entries);
+	write_unlock(&misc->entries_lock);
+	simple_done_creating(dentry);
+	return 0;
+}
+
 static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *ppos)
 {
 	Node *e;
-	struct inode *inode;
 	struct super_block *sb = file_inode(file)->i_sb;
-	struct dentry *root = sb->s_root, *dentry;
-	struct binfmt_misc *misc;
 	int err = 0;
 	struct file *f = NULL;
 
@@ -803,39 +830,7 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 		e->interp_file = f;
 	}
 
-	inode_lock(d_inode(root));
-	dentry = lookup_noperm(&QSTR(e->name), root);
-	err = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
-		goto out;
-
-	err = -EEXIST;
-	if (d_really_is_positive(dentry))
-		goto out2;
-
-	inode = bm_get_inode(sb, S_IFREG | 0644);
-
-	err = -ENOMEM;
-	if (!inode)
-		goto out2;
-
-	refcount_set(&e->users, 1);
-	e->dentry = dget(dentry);
-	inode->i_private = e;
-	inode->i_fop = &bm_entry_operations;
-
-	d_instantiate(dentry, inode);
-	misc = i_binfmt_misc(inode);
-	write_lock(&misc->entries_lock);
-	list_add(&e->list, &misc->entries);
-	write_unlock(&misc->entries_lock);
-
-	err = 0;
-out2:
-	dput(dentry);
-out:
-	inode_unlock(d_inode(root));
-
+	err = add_entry(e, sb);
 	if (err) {
 		if (f)
 			filp_close(f, NULL);
@@ -1028,7 +1023,7 @@ static struct file_system_type bm_fs_type = {
 	.name		= "binfmt_misc",
 	.init_fs_context = bm_init_fs_context,
 	.fs_flags	= FS_USERNS_MOUNT,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 };
 MODULE_ALIAS_FS("binfmt_misc");
 
-- 
2.47.3


