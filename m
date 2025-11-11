Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A6A4CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A5D8E000C; Tue, 11 Nov 2025 03:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421C58E0002; Tue, 11 Nov 2025 03:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EF68E000C; Tue, 11 Nov 2025 03:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 255048E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:01:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9514160492
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:01:32 +0000 (UTC)
X-FDA: 84097581624.07.5E1FEFC
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id E90A220005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:01:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Szj1eQpI;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762848091; a=rsa-sha256;
	cv=none;
	b=vJndI3zTAmQitXd+rxO7t8HeJ5AcLCYBHd+gKSPBqBEOFXZKSbAOEhaQL2SgMbWKqUA940
	YBXyUU4g3BnobXRDP7Fn/ZxlNYNoUK1+ZYKaXXqkAUJFY5Ktv25gs5ObxZ+Qt4nkZqBdS/
	2gI+BqgFHBmPUlnxvfh/ydxAyW0JsMs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Szj1eQpI;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762848091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCMcASxW4GQs4KES7qr2omvwcK385DadzCf/GiIFZ/s=;
	b=BZcbMjXeRnHKx1Ae4XNyncmlxcsKiYPkGoXgtvq+gODhs2KQfE3kU+DUhEJdwI0Wcqcjbz
	yLxOcBJu3RBiAbJAYyy/AEV0K2E+MMvvHwTUnl6/bIetItECcYG1nQJNUhoNdQg/d61XRM
	g1cJybNyBG34AjldGkYPKPMIa9/lqJg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bCMcASxW4GQs4KES7qr2omvwcK385DadzCf/GiIFZ/s=; b=Szj1eQpI+CpNio2fSHn7Rcubuy
	O90u0mX0bC+nvLtB/n8A+Hsu8sXDra0o47XTuYTPDtlbJmPr6+UDSbWTQZvBUnPXKMoK6haWU4gJp
	k3fl4MdfIBIDWE609M/HMU2vNrpNJI75hI9Q0jHmNaRq0jn6KKt+dt8jIOxUVQhcCF5/PjEortYMj
	LKGabpY4EW4575FtUxDU83xgOhm8FI+Jhdf3y56T9MUdJgqah0UYyj+VNQx0j4Sz3rHOKnAn6eMmx
	V/IansGF9MRt78Rb+QfUuYUuhboOC36fFkiaUwfqrKRxAnM2QB3PAY1uR6pvl3KHmCrk6nzB3ZYYU
	mheacS8g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHm-0000000Bx1w-2oy2;
	Tue, 11 Nov 2025 06:55:26 +0000
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
Subject: [PATCH v3 32/50] convert binfmt_misc
Date: Tue, 11 Nov 2025 06:55:01 +0000
Message-ID: <20251111065520.2847791-33-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E90A220005
X-Stat-Signature: rr5jr67q3pgdiwaq13tk4xcyu8sqeexk
X-HE-Tag: 1762848090-264394
X-HE-Meta: U2FsdGVkX1+pcWuebG4vWwyZGhDaTEEIG+WMH1bP6denT+U3LScOfkOM5oa2a/asnYDfVaVA4x3aw9Rj6KwHyhVjInxvDgZzWApixvYd8/DeZs5XEMUTzCRqrrsE2UW/mO30aDg27n7SppyqpSHyn6IVDb8hSYdT2q5c23ScGhxJvbiuyMHNsWJq44UVhZWG7vICyx6xZYg74BjJQYzXgRhPHTy+5srN4M1/IyJ7sE7yZijvGi7z3jd5+O4lsMEo+QIG59EIanxC0FrRitZByh4Wsz09/TakzVzKTT85sPu0mXPSTcMZhv8A0x6vdW3Okl6f/EOqqrNwwPpbd7AHTb3k4WPWYXq3DYNCcUIbbZCLmNQHG5PVZ7HblsEQFQda6h/dh5dt7II2dGIAm6IoV9S+LTU0Ms8moH8Wd3XR+VKlN/cIqN2DYEywdbfjbmehHYH0k9+vtuCaUxVnO4Uq9uXHhJYWcThAvJoIQ/ENPHP7HvcA2Q8eLA0WiJTWJCZv5l6ZTs8mHCl4mxegJ7awpgRRGDOpWUNmYtp61BAqWw7iQLuKoVoSOzon9/LA/bJ5NqwKA4tG9vtM3nP27be7ZO1c5dLj5cIYOPNuf8iz4J6BpmP8XRDMAsIZw0QpfJ2C8n9HVPSChM345lTNEGSFaqrXtd3kwMw4BHZawJOCpNOa8aEyCb8JZVAIX+4iuHSv6LAfbdROsiGgSUk6YqIW0bbGutQD7KRrQx28NuNp65A0MwI8lYa49yzLm8chKWYpeWRnv0AKPy9JWEefStBX9W1+8m6ZdbT+952VWDuDPCBfc4cM+f6q05xsQu2Cd8QVU4iwJVJWJgumXsgO9U3NgeYLqVHBUDhKBeUtnvrmlvSqYlOONLOieXQPjFBmv4ld66Vu1lMzMwkd7T2KelpD+RckYJb3vdvlz8clwpeWP0hY6PzK+4Vbw676YvkbW+e+x1c7pPPBW/gxSZ45X7R
 7ixusKk/
 f+lgdbbhmq/9Soe80teh5uU/grkSAbF79NvML0gqMAyv1zXZPg774VzFEnaZK/F3mU2YhaocHd5VNBxWgtPqyDOUycRJibvbJp+9xa7JuPoJg1NK5H9ny6/WfA1fqf/J0yanDJmR9Nuv5yMimsvaN3Yd6ItcPXZs5zQiZJVFl56AAyPbOgKqu9VH92ovjM96EXamK5a6r4NQKtdqP7GZHMIxqJAl+CLVM79CkBXaZE6M8zWQu0/tpqi6DQxvV0PtnU47UQnYVdc1t1xAXtSh1Ihlj5lJwO7fTwu+MhDwdQFa5tlkEFIZ9GBNrmFUYI5WyLgYfuUnGijQC8JTSxzIVgdMd6EYHBc0ltgoNZfdtAZxeitlw5MQ+Q/sZup0reXfkJsxMqxt5qS6eXaswgJQcCH5H1RIxxXo0FdpBsOg+2oEVsuOw1ERDO6YMw2BAGui74LqSwQHEDPdecCSoOtl7QknyqA==
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


