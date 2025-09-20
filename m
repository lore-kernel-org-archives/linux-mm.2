Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D62DCAC5AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A548E0015; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9501C8E0014; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC238E001A; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 107BF8E0010
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8EAB87282
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
X-FDA: 83908850256.14.DBC392A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 32B9F180005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=JayErOdQ;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354487;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdhevqsdWuF/cKTAc0dIZQiRUrUONHeuOHhbEA+hz9E=;
	b=RlUtfV7AY1WZca0c7q10bLZE10R5z6YTfhj/UvJ4FBEkqr6RlB1tvgAxCILk6P/D9D1+8G
	dt/vbDrbPj4OlJYzOLARi+OjmVUG4QPTQ+SpI1Jq4NKgljbWGgSrCQsB+AOf56MOQb3Mkk
	XiBrr9yyvIsZ7U/rkC0kV3+gX1V5eaM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354487; a=rsa-sha256;
	cv=none;
	b=EtsU0dlL9fBti87zXxzD9u/OEJs1fn2iTRM6QH9m+nAoFiy9rkfLsoe3jdH45KbwjHbJzX
	BFGm7w7EiUhH74g4gyc1RH5/fyqID91fwbevLnQu9h7tafE7qJ7Y+IKu9XsPMDUoN3tVZu
	EqRASrQ+neM3iOlLNuMJXc37gvylTDM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=JayErOdQ;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mdhevqsdWuF/cKTAc0dIZQiRUrUONHeuOHhbEA+hz9E=; b=JayErOdQO97E9P8HOT624tcwlV
	zR8JXRCLGJ/YGzM/Vh9C5VjfvI9cd7nCM4RnGAu6RjeKHfoCfXvj5oBQSOtDyLKTCtQjdynyimT8h
	L9/AyYpzJq/9KmPl1R1y28blWi1Zj+Vt1UiKPY/b6vnV9u+MsMHjatQ0eipe59pqyFMZ4ZfjjXa3g
	tclJ92LsYJjvNW9qDXplpZ9jPIFBYmzZXyKaPFZyhfayHKUMR6fQqtwzJmjMPjxA8Tqafvs+QxgfZ
	pB8Hd6CLqUbf0ATlajREcOgypejOhuBgOeXAh1nSHxfTE6iVKb/JYZBJaEqw1/BWTVOcRacla8XDK
	OnKcOctw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKA-0000000ExEm-3DMp;
	Sat, 20 Sep 2025 07:48:02 +0000
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
Subject: [PATCH 18/39] convert debugfs
Date: Sat, 20 Sep 2025 08:47:37 +0100
Message-ID: <20250920074759.3564072-18-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32B9F180005
X-Stat-Signature: 17sdc3kwk4okt34wieix11cw6nigjwga
X-Rspam-User: 
X-HE-Tag: 1758354486-891347
X-HE-Meta: U2FsdGVkX18PjSBU1vDBzybxn+WEpF+8GQoGYIiS7tiTGAo1UPSE2sppFR0CcSTcOWkt/+oKxz7dgjcIOl34AeWMiUZn1gnZwWn22bcP9N+IfC3IiPNcuZwi0g9Zbvx1zSdARQ9pmyqprppE3ic+D8rMdIF3Q5J8yYM9KA4hs/JbnZjruwH6x8itJaycCWIQ+2f+G8u3gYEsGGbFMOBCLXLvWjBfmpBG8VgFtmK/jWbRXQ2VnaySezaa5xQF6Y/79UhUDB1L0iOT+wxd7Vv9CmbcBmoNe+y2br2rrZlAGpmHrsfPDcGWE6z6jFAbKqR999J0wUDJnIPsJRl11fFOTKZ3j4xqP1hf/uxEvtfcNzgyiKQC33JikgZ9pOUZ65r7i/pR0Ag1tFGkEC89rvXwuEFr7AjeRLM11WCXYm7moPnsRIFvmI6TmLJ2eHUQ23OmXd0K3tVV5A86WX5QYxwCaZoK6iL5hQk3WR6oLW2n9Up9yatA7MS69rAR+4K1KXv5ZxhXP7WAW+d0KUzu8LO/h2piWREIbYV7k1NeMJ2FWNK87jhq530LxmYMZoMPl4hieyhN3guScMKXWQJfYW1cR7gzfnJ1PsVq7h3EiBqh8TyMbHc/NbpOHf0X3gisdfYbnrwh6xDB0nNg48Pmue+uzjhSSSAj+xfp0SN3dJO829E6lE4QaEccbUUu05b7LM/PsfWe4n15fcdLUPS9eWu0nHoLY7/mo+0sfcWS4HrdB06yjgcz4H4xyWHxLSxJI7RM80OqQvpNwMBBDtHaQpQNE6Gy4o2n9P1dkTna0LtPG8sitNgJlDXwBpuK/1RF33wxPFfhYDf2SoPUvldnkqP/IA1e6RQlwE1x/AJ8IqOkjLagBILbGp6HrSVTLwGAlwgGSbtU0aWtbjX/KBbsuzTuhGWswTz5DgMIrDnj1bRU9MG6JbLvkAUSY2rlEqUdLKpYgTrsRWucajfeOs75X7S
 qja0vuLS
 OvHT+XIgzK34RX47juhcIdz9KIZmKczXnlAb3wGnnTk7tEPNsmbnIGnJjTyOaF8xCWs3R1sm3Y9ihL/+oSPtVKBrSUlQ6lgw4s1qaJU8G6X5ObuPRMJ+BUSTd0ZpydFiQ6XMzGUxCknnQ6T0IQW71R9oDLHTpG12zTQUA+Y+nEq2eGuwQcq6U+M4qgxWHgVNvBPfrboXL69HXWRA1s+6+cI/PqhyNxhRK8Kt5Fw7ilb71+v2To1gMu8MfWi5mTi/3TtNmRFtnuvX2IRE3poMUYdJLArd2cIRX+ywQxysTPPF389spn1KimjNsrTmCDJQc0HNfOOUiRZdEJIu/YI9qoV3i/rpPRF20isxPKC63TSGnnUR4roWrU6KcaJgUPM4Amwa5x+yTUe8TKGllmff15MR+8nymg5VG5vDz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

similar to tracefs - simulation of normal codepath for creation,
simple_recursive_removal() for removal.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index c12d649df6a5..1302995d6816 100644
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
 
@@ -404,16 +404,15 @@ static struct dentry *start_creating(const char *name, struct dentry *parent)
 
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
@@ -455,7 +454,7 @@ static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 	DEBUGFS_I(inode)->raw = real_fops;
 	DEBUGFS_I(inode)->aux = (void *)aux;
 
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
 }
@@ -601,7 +600,7 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(d_inode(dentry->d_parent));
 	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
@@ -648,7 +647,7 @@ struct dentry *debugfs_create_automount(const char *name,
 	DEBUGFS_I(inode)->automount = f;
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(d_inode(dentry->d_parent));
 	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
@@ -703,7 +702,7 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
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


