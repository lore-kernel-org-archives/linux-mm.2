Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12817CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F663800FC; Mon, 27 Oct 2025 21:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A76E800E4; Mon, 27 Oct 2025 21:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C230800FC; Mon, 27 Oct 2025 21:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46C56800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:51:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC4581402FE
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:51:32 +0000 (UTC)
X-FDA: 84045846024.21.73561A7
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 29AB98000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:51:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=wJOqMQYn;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761616291; a=rsa-sha256;
	cv=none;
	b=lROR/Un068+pgy+rB0942ZhNiyo8Y3sixTpKwHbg4frbpnMcwODL8BUgWSO20VCHZluREy
	Fpai9tc2BvdshLui0K35t8NLApwiPPwtLt2tEk20OLBU38O4XDDFuWGUgUvj8QVnhBPZLa
	4LbXX2YZfv1ceuHZHyUch17Y1dj/qM4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=wJOqMQYn;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761616291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxXF+ZX7o2qevQIhaj7GgHO9nhvHZfJFLXJ69dxgaxo=;
	b=gKfRP5K1WsIsVIWfQTDtHJD9zrhR7pWig1Sugfcv8VlCRa7bp2RGPwe44Y9ZGlY7YbcMJ7
	DS9GurI7o7UjSJ6P+V78WM23hstnkG1t/s/X8Fkh/FogeFR3vmapUPBAXbw6ud4DfIjT8U
	PFbWaTv1ny9/WHdCGW5geWzM+CkFCEk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AxXF+ZX7o2qevQIhaj7GgHO9nhvHZfJFLXJ69dxgaxo=; b=wJOqMQYn/agdM5HgN30InThuM4
	YKX3asL/ZDg1YZerfVxwnR4IjS5+rIKsb5lOPquQKQnSwBD/KyhzjMLiNBwCyBJ1Hi+CIdrD4bTbT
	glwIkIKVjh6Fq4GLIkfs9mbfYjUWCB6Z4HYkPZ/6c32QmE9hMHwLVbXg1CG82vHQjgzoPkY9QDnB6
	p5w+gUbz3/gwdNOUPxTUgj5isWLCB7q3uR+Q/aB3dZj8GdGTChUwLYH0g8lvzKudw9f5tjGazaCl6
	pyd+GtjpJwkVpLOqbpTgpR5D7gU1+EEel79+MPwja27D5aFjvJAZVFiWQDk229jSbYl2karclhEWS
	3qZbyJoA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001ecD-3iKp;
	Tue, 28 Oct 2025 00:46:18 +0000
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
Subject: [PATCH v2 40/50] hypfs: don't pin dentries twice
Date: Tue, 28 Oct 2025 00:45:59 +0000
Message-ID: <20251028004614.393374-41-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p17qusr5u1wrr531qsf6znxs4rgggwjz
X-Rspamd-Queue-Id: 29AB98000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761616290-4161
X-HE-Meta: U2FsdGVkX18sJZ+4diOM3B/HgAap1/DqM7aGdOb2iBP6HVUQX7OcxqBGpaeF9lOfgnzeJoXrhDR8npx5emQLSeNGX3CNIeM4ehuBCMnNCeFoHBqZ436G6Xy2HxAX8aJukSi4miZuKObvj9Ajdoa9PKcmjonyJAoiSsHqJaLQcWUtJGPg109mgPLKdAM8Vg1T7loyU9sFTfgXc5emGTo9eKg1M1xGlnQoFRQSmHPgRFmc/mkifC/+Nn7EFP1Q1Dt6lrDckNLkbolYyuy5fWPny5T8E1MD3gL0jghAlvo1XC+oleUFFmy4agLCuKIC4x3sx4274EMUxpwE7jNcGKUh0LzZaRZYAHzINWsewwI+IG+B1ySzukulVzL6LKcjlRSptQt5Ryn0NBuW+2TFGcoxnzq5oLa70kbeKeBEzu25pQKManaGpYdleg6LiS9IDRKAlw/iLaf9NU+K9u+jHSz1unfUfNOmAgyCMwWViOaYlhzUxf90tOEQW94c2MXBBx2IHbMeFa648D5M3DzkKsMdb+Hs/poGxKQk18LCGag2gsHI/uHUarXqH55AsvLBBm40NsCsN+a3OpjhePjJ0XDuPS7hk5o/5zd25AZcpyWCqxAR/CTz/xNU6KOmU1lzF9U5BxXNV+yMtXIbBdkqHK9nlhA4JA5naic4TEDH5pdUmN4d5yVNcjkqJc4jaSwhZdVt2Pzv/64tYuq9hJ6j5xSJrQ8BfiJh0iNnHLfNGf0aWN3w6VMkim+m39DMyKm4St/7faBVeoveZ2Z3Q3gAONEiRTohiU/7RprzuXL3sgt19SPL1bNGZewAk0K0LJkqS3tKYuN5JlSps66RFSK3NWriYJuUbbNL0smPlwty3PFWLivOcjq5LR0qlSW7tab40+c603dp0CX/2FskuErB/W6nfmf4sBNBBnPmPphV7kcVsr3T9aq1Y6u9t4LkhXrXu20fbvWSTAoXLEzRy0u2vtp
 c38y6AQy
 uaX0LCYsBth0h/PPEPdW4V5ILCA+mZXtPteki/p6Xv4c5XKeKC0fH4Zp76VrQbau4QcuuggO4L/Lzs89ou5BzA2Gk1L3Y4hGM+dI+hh8a9bqO6w8=
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


