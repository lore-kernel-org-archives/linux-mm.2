Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13B4FCAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 849DB8E0018; Sat, 20 Sep 2025 03:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734C68E001D; Sat, 20 Sep 2025 03:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496EC8E0018; Sat, 20 Sep 2025 03:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34F8B8E001B
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1443711B0F9
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:12 +0000 (UTC)
X-FDA: 83908850424.27.60A84D7
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7CFB82000E
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=MG7Bv5tC;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354490;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCMcASxW4GQs4KES7qr2omvwcK385DadzCf/GiIFZ/s=;
	b=af+WZ1tuzwrJMmVUxPXsrUPkXee+kHOiVf7kSVGoihy4O9YMaQR0azNq+He1DYMB3vebJz
	FWSfZZ3hZZsMWOATBNgAWjJc9UDURv5k66nS3QpUPWWD79VuQ0Ft9xMn6RMGhoQFuuhzuQ
	7hBLzEQJFpLWUolMUYrmY5RQDKZ97nY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=MG7Bv5tC;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354490; a=rsa-sha256;
	cv=none;
	b=Ciu4XeiTtiscWy2h6gqr91wolPpqN1mmPnSlOHIB+ce9ozvjnLJ76qeJ/5sqkupUX9UdRc
	SD0JrTliP5T2l8PYdaU98B6fcd1lN3A/ePSz1nIk8wag4dSbB8WDzcIZHHKNquQ0Cbe3Iy
	rXNrU6YSP76AAs/S1w0o+3uc095dP2I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bCMcASxW4GQs4KES7qr2omvwcK385DadzCf/GiIFZ/s=; b=MG7Bv5tCc5JjcXbdVB4FgIde8s
	wiWz8ZMv1NXl+Wx2Cg5KWBbS7izDHox9UvF0lLjOwFX08IisRXYQak3oWk2t9kUQ19B2O69T5h3+n
	YGxqlf5/9iN9Uyxp7x18fZKoOoxMcSoxgwmqEV4HgxK0TXwEgu8yhXThS3tTQqrSrIze0U8yRolNJ
	TgtQ1SxkLLsBzIGPDJ6ogmtp1wKv90GO1/uqUyEuk0DBKlFQ/zjO/WTTb9peGoVRdcQ/RCzhYob1E
	5mFVNF4jSQbul96CSJc3lk8ruVcnKoDW+ttnH7fw7HEiN/6b1BAMNJbR0A7lpBSfCWH7xdPsHI18B
	oJavhMpw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKE-0000000ExJ2-1pX7;
	Sat, 20 Sep 2025 07:48:06 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 30/39] convert binfmt_misc
Date: Sat, 20 Sep 2025 08:47:49 +0100
Message-ID: <20250920074759.3564072-30-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CFB82000E
X-Stat-Signature: cu54re7fm5emkc54yed4wwhwnz1z413s
X-HE-Tag: 1758354490-676264
X-HE-Meta: U2FsdGVkX1+NXPmwf+Xk7OirJJTGn4qc6khBARn2hSm4I6yVc2jLvlBh7gUiUqOBIzgV3IfYjr2kU/NBTqoa3BzOp3FIAuXaE2OrxLKJrGkFH9LqKh9nE3G8DcCzD2E1/0QFFVo342Rs6z2tmH8wNJ9sHOXYjIsYtfXRnoovr5I2a/T5s7uhSXydqYp+sIgH4WJ0+r+r47xeFObTQULtdobPWuF3e/ALHVrETPKtxb27ykcMusxw/kevu7EYkQzG/HeIBSKKTX+ygCkKs5BHQ58Vd3IG8M8JauwGfoKcJnLe/CWRb1ZF+NFcMvpqgTA7ip8lgfhDE7NliX+Wfty6pHjs13QtyfOZ7kyGIDKaCU5UzVwb3t0TmuBRGwUI8gDSfaTzE6zNLBf18oaSL/BLiyssjvwYkPaJhFmZhBUyXvt9Oz1tOG/A+WKa+s5IwYT5Q/d4gbjeV40E6zAeaA649aqEdt08grGKUs0/eKVoejHniprENj8s8l+HzTS/Ni8wyUvujQYCHcp7xXJVO5n3TUC4yAttMifkkJC5tQN+NQLWdZqqQiP539my6Z9sIqmu1ZxCA/468JgSu+H6IiKbF0c3m/GfF/Fylc7f9J37JHQkVSTJVNoJL571htCCoFEDPBky9n+QGCd0PxwfnkZDxCU8Z4W8pximh1MANCY/UPA2B90wlGY4y2NUcpKdhLny/tqCBsrKJyNSvun1cW4K2gpNXpkevPQXB6cT6tjrSk0QIWfNpZkmEgYu82iZGqV9AHROJfW3DZXnYoNmVkENW+qkGoQNC65+pGL40gtWHNVQNHjr7DsvWKE3zEWQpT5w3c/Zo2qjsTPThc9fbDY+a58PvqzlPMAKakcVp/v/K3Y4/bx4YGHK3r4dTHJQSSFF+fj5u3GKIYiAhEyv3QIz1MMSeRbQiK64EREpl3S326wl7OBKM/WkYMuTrF1zwJNuibl9c6HGTgrF9BeH5qw
 2Mk2TFN6
 qp3m7taZtln2/f5/jZEuhnGP0DwZNrASPNXnyzNOuW0bZ8DnsLFLQ3IX2xLmZ8s0WxdXBEEeiLFYfoKtsWt2/lpRaV9xpqVyF/aY9u4wXhkT5ndnArNW1F9FN+KK3GL+qnpaU74yiTvvtFNieovJoF8NnWTzFtY1hbHzsKyIt9AwIj2v8Fe1D6UYZRi4+RtkGYYhhJSH+4Kf+qgS2+ghm+utFdSdbfU967vWmVOT+rqvZElkAOk+fGPmeK0PJ/AJQXRGdMqjXldUgoGHVCdA0tcpkE5ythcRUXySP53EIK6BIPWaWYF9rVAdwRPlBz9uc0smpGQ6dgWWjh+WTQAh105P+Sg5yddI/16DT2CKjKnT/9N4E/2CA/iC6G5YXTLb8Rnp++WUQtvDeD4NoD/zkauezsgJfrqvgm66Ljk1iuM1fNKBZn49tVXaKR2gn81uTo/JsWsoBVgkQqFGbo4F0Vpo7zg==
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


