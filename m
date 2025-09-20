Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048C1CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9168E001E; Sat, 20 Sep 2025 03:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789628E0023; Sat, 20 Sep 2025 03:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF118E0022; Sat, 20 Sep 2025 03:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D13D8E001E
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E0B113BEE0
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:15 +0000 (UTC)
X-FDA: 83908850550.09.AF13EE7
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62BE7140007
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Ies4AD/s";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354493; a=rsa-sha256;
	cv=none;
	b=M+nQ7Nfb+QTT2WU5WnmfLbPnm6KeIZx46mlu0z2vwVlqTTxB4QYtrSdd815h8ryUKWH0GW
	TqEGTYMdbHyijBp68x36LUHTbGxoREYa8XTjzDHsrf+XeIaor2siGmJO7QVljbztTewO4U
	Eux/hIOFgfgpyiBsiUVkde0KeVhAYfM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Ies4AD/s";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354493;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxXF+ZX7o2qevQIhaj7GgHO9nhvHZfJFLXJ69dxgaxo=;
	b=3IeGUXWZgNagmqr6gNTmzQPNIaI0WB5/Adr1/kneX1r/q3CisahFBzClR3GeKH0NahOj4p
	elWzr19QmiHpe21JiPUhVxiqpdDUSrWxFicA0uApah4z6SmglUdZJVz0lCbQQoGla65/ai
	FH9/B/MbWR6DdZdI4ZWT23luWRq0Gvc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AxXF+ZX7o2qevQIhaj7GgHO9nhvHZfJFLXJ69dxgaxo=; b=Ies4AD/sXBzLiIMnl/ZdC7Ibm2
	W2zIpILtpZKpaSMaPC3m/lcGPJwcT/lgcaPI8Wq88cjONY+ioQ0RVXzan5eukyU+dz2VWKHsevmsq
	FQA8QbUwpVZOqZNx0f8J8g6ACDW7td+o+0um73FBSFXdqeDWCg/p4qAzvQMjgouuUVEqUNNvqg4jj
	EYLRbcSUgaVdmj293jx4PQqTvZH9+WYM7dJHG70LulPeirJnDb1I617r5HBvwF5GzgVKNjgxW3o5w
	U4HrwT9VGp9SZuzokv290LBLe83wLWCw5zltOGXTEzB0gLL96JYIRyaymqy+Q7s6ul5EsE3SYVNiB
	wDxN6HUw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKH-0000000ExN3-2cBU;
	Sat, 20 Sep 2025 07:48:09 +0000
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
Subject: [PATCH 36/39] hypfs: don't pin dentries twice
Date: Sat, 20 Sep 2025 08:47:55 +0100
Message-ID: <20250920074759.3564072-36-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 62BE7140007
X-Stat-Signature: jiu5qi5abwzff1b7n5igfx8ukckoyag8
X-Rspam-User: 
X-HE-Tag: 1758354493-929359
X-HE-Meta: U2FsdGVkX1+1A8M0FcTwvmP5fQqvp+HrCdGy5TVll27Zn0+lEB2kBkI3IA7EC5OvrgjR53ktRllgGZ7vwlkgodzJEeAfo1pGKs5vBKMiT7TI0+aoiNFutg6pK9EKScCZunO2fC6qUN3ZXARwwcXhsFIPmRj2FWyGR1JtQWdh+BN0ABmxn3HCVS6rXK+HZw0rOMeE1DIKa/bqyrKhW1yvtK3TqsacYOG0R9QhTp+u8LTQvMPYDXxsmTD4CzBmmsKOJaFVCym7iNDOf5ZnpMU9tw6rWbrNa4trY7/JBxDsFIbiUQXC2789o82N4e6Z7PthWAC1pIXZQL9tfJsFshmoA8elit3xN0xIFi7DnAdC0AoG3TCdGpYTJZkzQbdwLv7jJBd+gFZZwYSc7rm6iFBeSIOceTji3OEd12XKMubqvFJjcInaTfEuyur7n+PFHv4/c1kIMB6GIY8dmjhdqYDiXeNGu54Tn0Fv5yzmmLWlj+3hminHrFopZJEk9o/qzdkDw/qWR8ZcjzYnIZ7ijkKxpeusSrJFOzF7zwEl75n0KQvU+ZTJw33K2i887UKVA8CO4amXNclLw4PmOw5S3mIzaK8AhQ95BPK389mIv+2obR+QwHZCDHaT5hRNpL1dQyXhladU6SLQar9bJhUXUHxL6o6RGN5m0clhe8QrRHxXbpoZLCCTFOyOyI1WXSje6WdF+J71uwrSiU0VN/pVA7yeyfD67plNtgMxNuvUVhv4Mpk0UmoLM1ShtnO4QKZNaWkYWOEKrIjHW69N/4Vc8wtyJm04vSkPuPGXJb8ZLCdDvQQCsXpiHoULbe25+RcLftTjJZVstnCgRHpvTTBqve+Ct42xPbJocU518an2j/mrKqlKbevGOM2wBZXTmK5FrWrbMVPCxjU5IeWF2EBxfsfpVvbnzSlnB8OvuFB8W8m31YVfAkIV26mEp72OZSmd5FpGN+c+Rc0zxl1tPAkHLA0
 aGn0Ifk5
 ltAbJJf6OGKaQTsWVp0+t56ntJeYvH68G/XL4x7R+tMbKoA9I1R54DOUuH4tiD66MD2KXTCaPvwOIZrWWi9wtQh8KAJQo5iZ32kfdPv1Uj0HJssizFYTdii4QeZuV7lx4CilmZ8Y59nVVU7RPgdP9w2khwjqXktzr7203F1IQo1yULACK73zzVgK2IMn2SJKcXpnyKCKgt9YbuEX+8nkjZSxsqPVJ4vlN7hwCpzgfpSMeJgU5NGyLe2d9B4UmGMmdqMJSBSZwYK8xmE0ocoNzXTvk6DGez6vdyl4Act3pvmpejJv7HfvoJn/uJdVU3EI+IfkfyCJqq51HRKnng8Hs6kFBPio3luXEUGQfTU0E1N+NFR/mqc3J8/mrcuHGMgrM39qOucKtmD0EKbz2XNgWGFESTJF5uwRS4P5N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hypfs dentries end up with refcount 2 when they are not busy.
Refcount 1 is enough to keep them pinned, and going that way
allows to simplify things nicely:
	* don't need to drop an extra reference before the
call of kill_litter_super() in ->kill_sb(); all we need
there is to reset the cleanup list - everything on it will
be taken out automatically.
	* we can make use of simple_recursive_removal() on
tree rebuilds; just make sure that only children of root
end up in the cleanup list and hypfs_delete_tree() becomes
much simpler

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/hypfs/inode.c | 41 ++++++++++-------------------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 96409573c75d..a4dc8e13d999 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -61,33 +61,17 @@ static void hypfs_update_update(struct super_block *sb)
 
 static void hypfs_add_dentry(struct dentry *dentry)
 {
-	dentry->d_fsdata = hypfs_last_dentry;
-	hypfs_last_dentry = dentry;
-}
-
-static void hypfs_remove(struct dentry *dentry)
-{
-	struct dentry *parent;
-
-	parent = dentry->d_parent;
-	inode_lock(d_inode(parent));
-	if (simple_positive(dentry)) {
-		if (d_is_dir(dentry))
-			simple_rmdir(d_inode(parent), dentry);
-		else
-			simple_unlink(d_inode(parent), dentry);
+	if (IS_ROOT(dentry->d_parent)) {
+		dentry->d_fsdata = hypfs_last_dentry;
+		hypfs_last_dentry = dentry;
 	}
-	d_drop(dentry);
-	dput(dentry);
-	inode_unlock(d_inode(parent));
 }
 
-static void hypfs_delete_tree(struct dentry *root)
+static void hypfs_delete_tree(void)
 {
 	while (hypfs_last_dentry) {
-		struct dentry *next_dentry;
-		next_dentry = hypfs_last_dentry->d_fsdata;
-		hypfs_remove(hypfs_last_dentry);
+		struct dentry *next_dentry = hypfs_last_dentry->d_fsdata;
+		simple_recursive_removal(hypfs_last_dentry, NULL);
 		hypfs_last_dentry = next_dentry;
 	}
 }
@@ -184,14 +168,14 @@ static ssize_t hypfs_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		rc = -EBUSY;
 		goto out;
 	}
-	hypfs_delete_tree(sb->s_root);
+	hypfs_delete_tree();
 	if (machine_is_vm())
 		rc = hypfs_vm_create_files(sb->s_root);
 	else
 		rc = hypfs_diag_create_files(sb->s_root);
 	if (rc) {
 		pr_err("Updating the hypfs tree failed\n");
-		hypfs_delete_tree(sb->s_root);
+		hypfs_delete_tree();
 		goto out;
 	}
 	hypfs_update_update(sb);
@@ -326,13 +310,9 @@ static void hypfs_kill_super(struct super_block *sb)
 {
 	struct hypfs_sb_info *sb_info = sb->s_fs_info;
 
-	if (sb->s_root)
-		hypfs_delete_tree(sb->s_root);
-	if (sb_info && sb_info->update_file)
-		hypfs_remove(sb_info->update_file);
-	kfree(sb->s_fs_info);
-	sb->s_fs_info = NULL;
+	hypfs_last_dentry = NULL;
 	kill_litter_super(sb);
+	kfree(sb_info);
 }
 
 static struct dentry *hypfs_create_file(struct dentry *parent, const char *name,
@@ -367,7 +347,6 @@ static struct dentry *hypfs_create_file(struct dentry *parent, const char *name,
 		BUG();
 	inode->i_private = data;
 	d_instantiate(dentry, inode);
-	dget(dentry);
 fail:
 	inode_unlock(d_inode(parent));
 	return dentry;
-- 
2.47.3


