Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1036CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481038E0002; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364768E0030; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43CD8E0036; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 379FA8E0029
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED40C1403A2
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.04.A9DB85E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE87E40011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uCkauw5A;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCMcASxW4GQs4KES7qr2omvwcK385DadzCf/GiIFZ/s=;
	b=UsxLrDtfMroP9Vcx7grfNvV0pwhJOn99P556L96+cTgNRU4PEPl2M002EpDEgWcW87h8Ch
	rZKgoB/u38VJxglMVFWpXASEEq9Gp0B7nw7APrAT8kWHz9G4eVxUEe9+q9h5rR6CcuPH0Q
	1Sp298rDZRbITINIZuKVFWDedCyJYyc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=UNdSNc+bZ5cvLgUzzbdFRHjftIomgECQyhtnvA3gdWTZCBxKK5E2MzwPMwbnaL+TLYpouw
	Cc/VZhAgQcn4FETYNP9NfjFUHSxq00s0/ITCSx5jOeMBItbxiBXHRQbkKZGEj0Ae/2Py3X
	z75cX+gw1y16jwaGKys+E/TIxfGV04M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uCkauw5A;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bCMcASxW4GQs4KES7qr2omvwcK385DadzCf/GiIFZ/s=; b=uCkauw5A+4Bvso9qLFeFj1Mhln
	PxTRA/cPduLEhyO+A2VVz2/EmqJwyA16rNQdGxiP6j+kPNy+gsrgkZNUNqHyzC6x0nS6YHbtD9vw9
	GeCR6Z18w559fcISOe9iiR+5UGzVaERHrk5wgc7yAvdG9YCHheDQoqq793vXQZ9U6i1fiG5HYpML+
	a2Zv2RyYeCcw5rP7zDcZT01KnDtkdlEG88JZgU2nBbJx61YREp7hq6qeviV+CcQ8oSLhpTz45g7ZE
	A1BT1I9G+IskMCZjWdKaWk1WkSbgmQ7adytHh4E7gmlhjnevuliK6qicSbvVuvMt46sjTt2WEBove
	UQS2RpLw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GESp-26HW;
	Tue, 18 Nov 2025 05:16:08 +0000
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
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 32/54] convert binfmt_misc
Date: Tue, 18 Nov 2025 05:15:41 +0000
Message-ID: <20251118051604.3868588-33-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: EE87E40011
X-Stat-Signature: ggxt35eadq7n3e76ywdy74dgypug8ccu
X-HE-Tag: 1763442973-805527
X-HE-Meta: U2FsdGVkX1/tWy8CSZYtXDKxoSWtesRbPBr4NsdgDPRrJhxnE0xLEZQcD/i58Bjox28Ov8or8tRNwDIvnw7eBO3uZb4LJgXUF2UkD58xVjZbmaiObDZGZXhRH/vqF4trN861ZH87EGOw41if01F/nNIto+rp4hb+IdtF2Gu+yZmsi5Mye+khD5qYMqYX89pqQMGckz/zjHHQc0IYwG51qOLxIs1joiXJks+czlKsQ5pgcCFaT4t1w4YSxnswQPnwN5wXxObxbQ5PZcFIEUodceNQ3R77hZwGVaVrEIU7FSCrCdVy0pY2Ro6q+vE7EgYU3kfw1bPTkJqVRkF1yv4k+PbvGewnfUjcLU6tTO/p+Yf2RxSxK4DfkXd/9YbkLeGShp1thnJr6XEdEmYWq1jAisktxamwylX5VqUedmlPqox4uhJj9t+/UlnHqwyFB7nY2cUHTOKLnWIqH5GjR60DfZ68NYIZBYVS1bNWxfr3G6Uds889tvtO53HTge+WwMNBhOg7aiOzgQFdZjb+7TEDk+4v8faRHJFA3j1YNlFhVklVVjkcsZOSq6A2i/7ivf1VJ8r13gWc2vxaiQt1ypdFiES5h/6WqDGU/lC8rYU3HxyiDERPeadzgh1mY1Ih4YUWItPCWscVDc7mb2aMBPdsYlkyoAEh30lRPfGtcIpyGw0JClnRvi0xtB1hC5TevlR00OceyiJ9BtO5+IGO3KZZvoyQgfEXI0R8GjfxzoKFIKsD3FcRczcBRDPYSjz5HEGwEjIFAxOPs75tzUs7VcztGKFIxY+GOeSq4M/+wr3E5+ZBFwugWa0LPlanoVB3gmfmajETmWtq6EqZczY12yUkOsej1gY/q5DfEO/W0/pn7cqCJ7vkiqA+ewmx88iao53/E1Grf6t7RZ/c5fnevvKaiZhP86W2ElXVQvY+TSQuERBRJLDpY+1GiIloIhMdLpdkqhzba8ISSW1lr6UGnFP
 A6gkWdr0
 Oy57T/c78GvkVa2QC8gfrT8v4w8CXhdizUwgR+GYusFiGf1Wkz6vyUEn7tH6N8+vu0KKxUBrRAU9ZuqSzqhP109HfCa03D3WYn6P1arZcHhcRjfdpqearCy9fmZFImbEv7FQ7zbIP7JRat/LZ64pSnjnRLd15HL3nt0CjswxxGDB2UFnRkBGhRMSyqEYb/ah4pDCG9uSvop2ys9ApXV4sf6EwY/4gqtHZHUBl8WkDWcf9KrFKqHPEF48uPmDs6EdYpuVmGvnrch6v1n7aECr0MPO3fyeK8WoxfHMGRw+25u0jcJb9+D4HRAMxllYY7GddJR2h5/YDKu02LMj2JsYCgAyhvu/yex5vr1t/qi9tQUWkLfEDfw1FgrqSTlzRnI0qpYJ8yVzaCnulg3okfZA8KHAEVTNqcfm1KNYmUnNBwoA4/H/5zwrLZFJ7t4rSA/EqgzCbFh19IooYnEcD8rDSSUEqJQ==
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


