Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19AFDCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB218E0022; Tue, 18 Nov 2025 03:21:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B328E0002; Tue, 18 Nov 2025 03:21:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A0D8E0022; Tue, 18 Nov 2025 03:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA918E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:21:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA17D12EB9B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:21:32 +0000 (UTC)
X-FDA: 84123033624.19.E1E3431
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 346D0180008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:21:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=lKIPhYfq;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763454091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHt/Ew+g7B0pNZwOTBE8VBfCIPUfQxC19aVy8itf040=;
	b=zd4VVtziCYP8ShwgCXqY0Lpq7gQZMKmtcEGWPZlLp9DI9nNOcu6riTcpyJbRquF9KErf1U
	TX1/6CR8yUW356co0dCNotJyekkYHzPPT0IeHKLQ3g/AFBVuwtvMewPmWwLQ5/nQ4UzvIp
	GJ20vNpBQrjqw35vMzINYkyI3919QOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763454091; a=rsa-sha256;
	cv=none;
	b=BMC57dTI3J1uOu/rKDlFFWuKVRuapLWYzpJmkg5pIA9ca7TYFI+cdXFXBJbIp8ZYosIC1Z
	dKAUZRVK9hG7nRI+sEsyeakDqfl88IjEL1dNYbwHldLvuTyL8ZRPR0THbxJM1VRBWZnKzF
	m4+ie7UZnDWnmLk2teWTmiFFkyHj7pE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=lKIPhYfq;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OHt/Ew+g7B0pNZwOTBE8VBfCIPUfQxC19aVy8itf040=; b=lKIPhYfqZU62n4f7/il6tbcs6D
	SG3aHWciVbkZNnlSfntQ6QZOwc/2cv1MRqgiAswxuOFG8M8xvlWwLBsRHeLbZ7P5Vrk5IFzZUKFjb
	95phEwxsqkzym/KzsRkm+riysXcvPQiKf6lJ9WaKb6VeYW1GFb+fokWgQWs0c2S7mDW2XRgcG9YzT
	m0TOnycmRvGWWQXrdAF2gXvUpNMJwHjlQJRmahYeJWW70Vwc2PC2lsRNqaFDOW4yyrsiJMBLHdhX8
	3XyyyKM5ZAZ0h5KYPg3h3fuFOu6BO8EhVWOIk3tYftHoPNZPxUfF7eu+rzziKMa5uPsKkotiePJ4P
	kwOdsB+w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GERd-12pt;
	Tue, 18 Nov 2025 05:16:07 +0000
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
Subject: [PATCH v4 20/54] convert debugfs
Date: Tue, 18 Nov 2025 05:15:29 +0000
Message-ID: <20251118051604.3868588-21-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wf3cr7hdtcwtukaoeacfq4j75wf33mh4
X-Rspam-User: 
X-Rspamd-Queue-Id: 346D0180008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763454090-530270
X-HE-Meta: U2FsdGVkX1+nZc1sTFG/J97tVRJaMlcvNvoXP6RBgcRfpKH9bnP4O5RRtqlQaGNWLwst8AV7YlwXUukl3JAX8SYcTCOutTMx9os9nNokuiX3nLhoQhsSi57IWOAdiCD5oyIXfPnDevcBAC8rgfmfiXfAPGNwvHV9OetegFHMIUSBG2rj6lyZA2h2KSexMzk7bOhkhCN0C5Moqg0Lmfv5n/Sjt6UGpdzHtgd0op0BT0T0bJIfvyTi82ouhBkmo5egqsEbVn70yO+rqav706IvDRIJGkaIXv+KKYmcetbB48PzXkxj3a3w0B2EV6bOBT/KlAGEEk551Fy4yAreWwiD74HU6knUK3X7iVE8sOZ2k0mmvPFu7rCXonjtH3jgnA8uKRDb0p4h+n9ZjggmsY3X7LBeMzDt5inwRC0MckBfLmhahm6zaRvCrHRo58GxddvS8KBJ1gFBNaorKq+WJJzRZTdkoDdMalO9MJM3fELy5qR+bChx73wTyBVB9ywzbyPr3xo61Dvc2NXVzdqXvEOHANAiM7a9qPzdkt4eJdTUKIkmZzuMxdnmSKP0rcxDz8vYeITzlRn43lBBIyhUwxECSB9t0gFAlihgezd1f1TbHk7vk7+9vHwkiJQEQ2uFgYVAmtIB1rdUGFoXVkecgWAoUYa6YlrwmIYNqFin7da+hwEscP1vWxsnW73XQA8kq6ymOLw5rqp3AkTXfBAuxeahjN63uhy1NFIrLlORluFjEYrVOBMPfPGczS0hAffPRkt1VP/KZIFPQR1qNfVVmWhpoj79Mr8OnHd2/rXWpzKHSfUFzMWi5nytYxyrb/nVequhXyj6BszWQb4bTxKUwiNY3lK1LYVTfUFZYxeDixXhuGcQsYzQ5OGhedrRKlxPVBfSD4UxqJUVu7eLPhlwWQI/hSyBksuf7HxiQk/Ex6KZ2llEJ7vLZOeAR2Boz0be7qThJbZamWMigf+Qz/9XQEY
 AR+9b449
 p4QFzA8XZUZMd1FUpqDM/ADBZb8ZAki/Tctt6m/T3luByvvamxLshyf3B5QBo0S75Lbn3fmVrXrN1q42ngwgFHykF6iXes8UmZe2oXxnuZHbTVtTJYVf1FwWfA5ZD94xmLa+SbD9tA6fy+q9fOI0ta3jjdzJ6hTu6Ufa7RZeeUoBJBtYzCjP/I5S5/HihPeJwssjL7dCh6aA5hvMT1yZlx+nwVlLaoUThN2uZmwITf2G3tkC8/xj9Tj7KbvtdKqqSvh2cCbelGeVBMmZV3ur0brZC3fSBsjCAKzJ2mEEXanpGTZmvJlDzWYoJb4aWhcaJku5nOKabxSjoLnNFanWTpAVUF6QTsdJePisszaNZ+l4q/GRM46A7SpAHeW9MPqb+K67Mct+RnOPWpcXTvqEZuwXBCCzvFglNLtyDee1dZQHIuHfEZ7m8yzkLQlMVu8ugjZibkuhcXJU7yTFCLeJ9ywAw9q81JiPYF7zj
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


