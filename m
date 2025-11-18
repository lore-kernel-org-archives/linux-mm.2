Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87BC4CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925338E0010; Tue, 18 Nov 2025 01:21:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5B58E0005; Tue, 18 Nov 2025 01:21:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4558E0010; Tue, 18 Nov 2025 01:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 690618E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:21:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0988F1A0397
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:21:33 +0000 (UTC)
X-FDA: 84122731266.09.7934681
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A7551C0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:21:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UXYzzuo8;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763446891; a=rsa-sha256;
	cv=none;
	b=4QpnY+w8CrVPf08ldrFC6oB/DCqpl8SPi9E3KOO7FisB9crJworBCjlhlYTgNmXtkBrENO
	l7AWwjTywsy/U1C8UQ3+DofxRfo08WkeiYqt1NLCiqSQViAlNigpPQ8fG+m5RH9J0AZzuE
	gdOSq4Ig6gT7SJEYoUus9iNgai2xQdU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UXYzzuo8;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763446891;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxXF+ZX7o2qevQIhaj7GgHO9nhvHZfJFLXJ69dxgaxo=;
	b=HmL0nG8sUCYvt0+zx9L57JT6VMeQaqjD8UBt1irJR1kvVxrJjX+bd44jRdTv/LEF0XqNwj
	fAfx3607K4kd4/3usFTaBsh4YyGWCubQAlQOKRV20IlcrKLGb083SAURLhDBti4XmLl84l
	BRSfTDA3U9LgBkSFstYXNMzEiyGHX5M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AxXF+ZX7o2qevQIhaj7GgHO9nhvHZfJFLXJ69dxgaxo=; b=UXYzzuo8ARgZIVQ9rqDTjS+9Zu
	ZEkiGMbJe0UgoAUO6lLrWus+HkKP+ieyHiSPgU0hywf9IVvXoPfvupLVj0g4KkiOxFF12TyERIVK9
	g2AjuLnHf1N7gO5BI1TQwaEdmgw5AawNtvW41CyzucQfEnD0qkDwx9CRezrcc+VRkEh27ynExd5p9
	Jf2RkbOPN+pD5DZ6A1uiauFYey2/0hhhOaAZUH1+mP20R5tlGm7I3oOUACVQlZVsKXQCcKz15eyPH
	NjC/pYKRtsdv1ydnsmCfK/gRSitvMMiuHLa/25onUbAOzpO6aDdyaCtq6/kw3NpEN4UrM1RBJv860
	+9DceorA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4Y-0000000GEWz-0KHP;
	Tue, 18 Nov 2025 05:16:10 +0000
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
Subject: [PATCH v4 44/54] hypfs: don't pin dentries twice
Date: Tue, 18 Nov 2025 05:15:53 +0000
Message-ID: <20251118051604.3868588-45-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A7551C0005
X-Stat-Signature: tfybexnmbo8mnqemwpncjr41ruy5afem
X-HE-Tag: 1763446891-701391
X-HE-Meta: U2FsdGVkX1+/lTkczSbnWDop+D2ZNYn8+CzD92eH0b81HtKxGWyg0LBk1C02KSSxfqZqlLHsfGudF5jwk5vC8+GZ+kXsgu4HmRAQkcyKNKrLiXb9kYf0MfQpktoI8oM0a9i+ZUqinVG35F05dWs9VEGzVeBPzjJIn6L5VLK3cgNAiJAF3BzgaRc66pWBzLML6/xWyPOd2ZMS+vkRD7t3ttVQWl67+e8WN+jUpLiCNJ2DNOW3YWHF+YdbzhGzRrtoInnJfNgLmPLfb+wJx0qdR+1J0nTpIUaZPIU1OyBTyUB6cUStnqdiaFk5VkXdxr3b/nrgjnXiTkQRg9BzJdgaxfgJxipCqKmzVCiMQdUlrnWsJhichghb6Dg4MF+Jiw/NcAourouLGV4EpowKZnTb7KLon4wKHYjhYXGORLNmHp2sDYimja5jg4E6z8hxKVDXZZmhC3LDeOixyc+JBmsHZFa9kTTRF5Hnds6S7w1xwNcR6DnUQgXO4QjOL1dm/CBN8hyE6zUAtMJYcZ6HGufhS2Pl16JJ+0jyam5A4v3HTTfI2ypG4xWoAEaN94YvVcFrV47bWod/ocrmYuvbPEFvsjcCkkUwT3A9PF33KG1kdW09Jp2O8TIv0WjDrhIiSFibbsrlYDraG6amgKfPe+B14P6t8Pn5EauxRsx7+Vuw/72wOJGRU5uV1nHFTwUw8+S7SyN5UGgydHn2+uxPSZJ2XqkSH624vuNPORpMID6Pb8ETpn6/VTfqY57ABn9aQ+HVkOfNPAWNXBTaPft1ud3hwDLLtBHVz8spq2kgq65wCls+ZFkkqKCgAo0OZbgd7I4IVmZ34S+q/US+aVPdqfmUV5gN0pu+SSNyLz9iV0aJrV8upFrO2mJcZigZWuOcUn8lOITW4zxJwEDcl0Dskrggaea3vSvAAV2EKTXpsazRlnRPV8tQBap8M0SGy/RYp7KGXFpw2Tw5OmlI2Ln54K7
 XyPke6cf
 pgHKaxBhmFaIeUW5douXPuiWAJNL+Sf7udgKTVbikJ+5IDw1epGteJxjnthoJnVderbPi+UokzFN01StzDFbLr3r0qUMKtSHNW8RHRHNmKZ7K29hpNxqh86x6MdX/dQ9r8KUfxAPrHvqjLKWz5qmXot7h2oBRgT5wyJ+jv/7ONDxzLm1sYqJx641Adv+8JPLCSo1SzDr6kpWJrjUaE5a9EhZMYi4l4euzQikflLwZgtj1+bd+OYj1NDMfkMx5cK0iTEnyAmQjasJwcMWE6GZhvSymes38Lok3m3Wiagx7v4aFcU3kJwlt/zdPU91bhcpKLfpF3UnW4w/AP8Qiupn+gnyLB7tEqd+6B/vwPIx3/Q2SgFt/g4wZKyf0zfp1jsiLj+l+X/Rh4cLt2I2otCyhitL4PeM8uQbTC9KR
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


