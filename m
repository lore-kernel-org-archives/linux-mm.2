Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A3E6CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370E78E0012; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E1C8E001B; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C8F8E0015; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF3548E001A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73120160448
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.11.ACD1DF3
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F5374000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=R4NIhkG0;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHt/Ew+g7B0pNZwOTBE8VBfCIPUfQxC19aVy8itf040=;
	b=jbUD8ANYAHNZopcOQgj17KDiV2ygQxel43Boc/qwk8T4pp8YwB4fb0NaaCfNaQt9SRBE4r
	XdzUuWM/j1tqb6isJ9Nw58F8GI7k46kWEe8qrp3DGlblzCNWTPvKFxMjxvvMczuqiXsf8D
	j9mg9CtkkfqXu+PWukYulO9OhIZydXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=iObny/it4h8b4/Fmz9ZERyidY632gb15GJcSAqF3Y4H4O1SQ1g/CPc4M9TVBQINm0ERMmz
	IRGqu8viWTFuE1H+Ws+ZYaVwMgvEQRzUQjcH3MEreHkEh8W8DMUWsv7G+/2TlKCEKQqGQY
	luLy7ldLwEtb/ycwbUo7tfLmUH/HqLg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=R4NIhkG0;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OHt/Ew+g7B0pNZwOTBE8VBfCIPUfQxC19aVy8itf040=; b=R4NIhkG0/V2mLVIyhcwusQ9nft
	8PZeZikDf6DfjU8btWRu2gDdgdWAWufZgJAle4MZacBlTpu2VZUM/bXqtHmYL2zuE8JBljJcITK5A
	ugGpjTf5V8wyuS4R3+1VZc7ZTTmixykTU3IcImNAEiuz6ATWp7kqFS1iITWbp8J6MWXKVKfkbf40O
	UgnGSBuhf3W3cUjZllApd4FxBfdfgJhXFyUxxC21kqutXFs51ZBuYxbsOaTS+L7EJy5FRp6bVMD3n
	0k/LUFpYm857/BMdvbI7VmNwc4MB+zYeIIM04sRhDT2NxMSMLKzbaSSQ5BeV4XHeiUn2/fcWdnrkX
	a3YFAoGg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHk-0000000Bwyp-1RVQ;
	Tue, 11 Nov 2025 06:55:24 +0000
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
Subject: [PATCH v3 20/50] convert debugfs
Date: Tue, 11 Nov 2025 06:54:49 +0000
Message-ID: <20251111065520.2847791-21-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: souzux9u7xzpu1p63h5xkc67xqn1ahqy
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F5374000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1762844130-524525
X-HE-Meta: U2FsdGVkX18pCO0MMr/Ma0LgDVDbDj1oYSP6TKppnzDrG7uYCeXqBFCQrd9CjbpdTSIsDL+Lv0EVeopot7I+kyGjPQGbU0R6tv3Jn4eRjRy5akE7Q1lIfZbYdKf/EkeO+ZB7Lx1iGo+QGuyrt6L8b/uYijNGan0uUGzJgzXD4FKDRK2fi616dKYBeFsMhRpTE9pkqks4BdwwwuAfSJoAo3tbNywE4Yv6AruIStjO/R217ijnnXCszNaZd2RcjnWAxXAPAmenOyRlTgM93N23Kf8p/FFBAqZrSinHG8EuJpS+50hSz8LAgLmTyHnmuHhMgHeoEcD46a5afSX0pJm3DnpxENio6RMnuwKaxA/l93vvO0NI/BbMg8UFwweCrei+0vJC6DKKT1R4wFDxH+8jmEgBkDhSG5y+AzVXdmq270kNSznOuMnGJEHDSt88J2w/fgYWpZlHhFuRjlJN45AfuyPwzN4QqIl1j6jthndwAApbjGG/7MCgMBwXJPZAt1355HoX1yr+JIDmhnoQM01JA811mygW/Ab2DzpVoDXqgeCQaPGHUdW8pIcOX2000jeMkwM9GzJ/7M+2cguXsHTieQey3vQ4JPLASZsflo5ZnGOypQKtGc8sEkWvEtiExRI7IbAx9grxwwPBUv34BYQdwr+W5Q4Pf08m7XVDZzDdxvqwch+TsRHPH0YD17x9uNEDA9rkU3VPwttwaq+mXPUqs74x3Gu/Lun3fHe5qOYNOSLd84/5Qdnmj5AC8rPpC+wLJo+J6t7phw92eTG9dyGXD5OIbTRINeYcxyC06pnrTAN99X+6fkUwj/lz8NyX1LTv+SgdEjW1405bc1o8m1POKceWWy9uSUBc7mpDIrlqiUweMSooasRb/QZu05P6UIhFy2zljz308iamT42ha3t10sPsg+QiE1zNcACDGN+GsOt9dTX0KktjyyOhuhvGkzbxTgAipRb2QIhD/uG3HW4
 P3dWEEOY
 Of7wj49T8rqyqZzqzeRfU1IEx+Q4yCOLx704h2ruNnZxk0c1KkxFNC7QU7uFUaUDbvlfU1sH89VXRwZB86x/p3ShgUaexYWd70jNVnC8Ij6p/XAWEQmdekTRovKjCtkY7vmA9ZXhYSVaifCHhvcLdZZICJDJe85S8a9SnNhnXIgrIIWh3NurZEU9FRxMjgz0T2j6NiKgfqnuuU1TARTRGN7/9upro5SluECwtDk47yuMdezR1+bB1vPD2iN3RzDmEeQp+AMIxmZ9Q5d7xSsS+XTDITIEVojEhRcIlZK/BVAei6mungiGZoPzWRPR2XzsQdnFkhmhl/LAHAAapn44gEXyE0xNkSWjAMovmkC/Piw2sDoMuofOIg+8x61wwWf0wyASt+PTCVNd3RZX64heM9CShrI0S4V0Z8ISVKbg9FEvLC7ZfjUZSzAoJhbmvGo88gi58GyjQyjhze8LEK+spcFpGwJhNVgd8IqK/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

similar to tracefs - simulation of normal codepath for creation,
simple_recursive_removal() for removal.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 661a99a7dfbe..682120fdbb17 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -329,7 +329,7 @@ static struct file_system_type debug_fs_type = {
 	.name =		"debugfs",
 	.init_fs_context = debugfs_init_fs_context,
 	.parameters =	debugfs_param_specs,
-	.kill_sb =	kill_litter_super,
+	.kill_sb =	kill_anon_super,
 };
 MODULE_ALIAS_FS("debugfs");
 
@@ -405,16 +405,15 @@ static struct dentry *debugfs_start_creating(const char *name,
 
 static struct dentry *failed_creating(struct dentry *dentry)
 {
-	inode_unlock(d_inode(dentry->d_parent));
-	dput(dentry);
+	simple_done_creating(dentry);
 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	return ERR_PTR(-ENOMEM);
 }
 
 static struct dentry *end_creating(struct dentry *dentry)
 {
-	inode_unlock(d_inode(dentry->d_parent));
-	return dentry;
+	simple_done_creating(dentry);
+	return dentry; // borrowed
 }
 
 static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
@@ -456,7 +455,7 @@ static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 	DEBUGFS_I(inode)->raw = real_fops;
 	DEBUGFS_I(inode)->aux = (void *)aux;
 
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
 }
@@ -602,7 +601,7 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(d_inode(dentry->d_parent));
 	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
@@ -649,7 +648,7 @@ struct dentry *debugfs_create_automount(const char *name,
 	DEBUGFS_I(inode)->automount = f;
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(d_inode(dentry->d_parent));
 	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
@@ -704,7 +703,7 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 	inode->i_mode = S_IFLNK | S_IRWXUGO;
 	inode->i_op = &debugfs_symlink_inode_operations;
 	inode->i_link = link;
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	return end_creating(dentry);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
-- 
2.47.3


