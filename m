Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8A9CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CC48E001D; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457FB8E0027; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983EC8E0020; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7BEE8E001E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BFCF88BC1
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.15.840E065
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9DC25140004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="m9Y4x//p";
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCYFuUAfEyL0H++y1+uBZz/Bn18lJwb1nrzO1KgbXu4=;
	b=WvtzBiAhxaTrc1mlOWt02a2gyDvJF67Uf+SYPUtQg7M7QOOe6+SdqW3xUoaRBkT6ewX89Q
	aY1lKL1a39piNiszn35QqrrYCMaItdgUI80L52WGogEqCwcBrntjuiJSXVx/52GbInFqc9
	PnviYhsEnTDlZ1T63jMEdnEhNb6Dewc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="m9Y4x//p";
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=mrjTy84QCaMv5OxrHsqEe+sV4YGLoqC6zzEKdtDryU/tVE6y4QyYZbvnxz4uJ4b8oJGcen
	FPhVx6z0JarZ6R+zrbYK3ikX85n7JgPf1vj8xPUYbvRpfJw9Tynr62gNjObwvJ8KUGw3K1
	goyQY81OHIj4G5r4fwz6eo4khBNpOgw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PCYFuUAfEyL0H++y1+uBZz/Bn18lJwb1nrzO1KgbXu4=; b=m9Y4x//py7xqdv1gbgg73vHIzB
	TIauR2RQNAglnC4N2FuvUF/qTlvTHtjsddlvTQzK8F5SNllarb40iUd9EqDzUJkdi2v8BLLyOvcKb
	OOp8lMD5gPvpQVZNty1Af/HFW0oatF6jmPF+6ZXXGl5AAOtndls6Wb6d/XlCllHJkd/fOkOP5SNfc
	Ux6Di0PM1crmq++Qq9qMROUh743hDJweiBsX7xnf22a1q/nzsZUApiFf/R8ShQNdGhKTBIYn429+1
	Ef6tS+t+sdlRqRBQX6tWjcYq2Xcr1tmmDwsLtJSnNbrjYWuSGmCk09+keXKH9an0gNUPFIWuXdxlt
	YwbzxLBg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHl-0000000BwzD-0Mfd;
	Tue, 11 Nov 2025 06:55:25 +0000
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
Subject: [PATCH v3 22/50] convert efivarfs
Date: Tue, 11 Nov 2025 06:54:51 +0000
Message-ID: <20251111065520.2847791-23-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DC25140004
X-Stat-Signature: 9a53uofbg5dx8kxu6h3j6pb8p5jsh6u9
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762844130-216937
X-HE-Meta: U2FsdGVkX19GfAlFfXrLWhdEpVDHNAJeGZTssz7osabs8o/bUtzOJTyxCmOeqfR69Yjg0UypcGFdDk8HLAypXiaTfQIJPAZz1IXadx8Gg64do+OaKxVKWMxWpnDVQGQjHtkb7b7/4+D128atod6jGErN5wkUZlRkAA5bF4yKW2A6z3HNIdhVKbBhhASvojo9Ok1l+YPZ544G/0oODdvcZAPkHjMoNJAwEOGnztkvNTcv9uaYMzdY3iYfqNjqwAlOKogedN0gMGdCdKMBlO//v97y8iOIUvzJmuqtoIBubkKjTM13Gow4ZVrSimqjFuUDLpKjvCrE4BhNNpIH1EFmxazq1cAvGKncL5iwlUhlpGz1zMKLjh5PkH3/K880I8SXB5ygR+PcHqTqf5uYkqcyP9Ze4xYCfUf0e/eqjx4BbG5LicCksSGtOXWMrgKoW6rv1Vnnz22iXd2OQIRuzJlyr1T8le8lEVxmuQ00Tx9FH0TctVtmGAVt7QJQRh8jXYvXfsQ460FFOpQcNwDts9Dv4tCCJTWQJLrqlpj1NQjvartzH451EiQALu33Gl/J/5aVg+msA+dWvSv+64UFuhQDj71lrK+EE48ewsgKqRcf4BVT5OEtArL1LyoP52mi3ua77NPREEFzKBJjrJXuhCIdqy77QEt5bd4zKQLBpV2jwqANGE8+xNw+DT872HhpgNVyiNByPEHTTQqCiAZQN4YiyAZBs5vV0g7xC4SENPzPR1b3jUyEBgGgT7WGBsvPJRWMK4ezC972o9E6efIhJaGmk4Ajj5g+xUkhlOaLJsN0CPzdqUfqGeSPrzd7LGKIfs3QbGMI1Stbn8FNBT9HDHWJUEmIMTY7KfDteanG4CDNDgc74zoc/Le14QqEBNz9AJpN9e2AlG3HDH5ap0z4nqTtRQf6r6KStGLXQIsBScUe6NgGX6nNs6/KvYwtOkvFWBgKsmCCihMCjWsmlRuMPN4
 Z3pCnnlH
 lROtb5J6lwpoGAcQ1KHMfnYouqVd7gF38YKlZO3QkhaQehNq1ibpHpNe7IDeX3g9DlH3NdKI+MWR55ofiRnj2pmQzLBHPMNJS4nToZqxYXRr4fuU5JNJvRC+4iQl2UY2pQqfwY1EKdb1wYaV8RBVwgo8wxuphtoFEUnV4Okxfg9cGNlvn2uawbgKiUmQPu2QStysJP9Ju062zYlme6Q0gef9D87SxVa3gQyqfnEWSakPwOHazra9ZcO7afBHNqVMZMYUrgitoCkFGT2IeKkuCmu4u4mBTvgUi3d0SvnMefJ0LSedisyg+IX0R3cO1jXN5Qn+UTvNdZAAAiNYYMI59BdGnyXaPyKHTTmGtl3k63CTjeqzQX0xfmMWAcoFlQHtaU3GQlbSFV9YK7rZdHjmB9xZUDgLc0vfIv9CaTZ166tlRFvyoyS5GfjUs9zknvtQ0XqJtIKj2vI43D5o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initially filesystem is populated with d_alloc_name() + d_add().
That becomes d_alloc_name() + d_make_persistent() + dput().
Dynamic creation is switched to d_make_persistent();
removal - to simple_unlink() (no point open-coding it in
efivarfs_unlink(), better call it there)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/efivarfs/inode.c | 7 ++-----
 fs/efivarfs/super.c | 5 +++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 2891614abf8d..95dcad83da11 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -113,8 +113,7 @@ static int efivarfs_create(struct mnt_idmap *idmap, struct inode *dir,
 
 	inode->i_private = var;
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 
 	return 0;
 }
@@ -126,9 +125,7 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 	if (efivar_entry_delete(var))
 		return -EINVAL;
 
-	drop_nlink(d_inode(dentry));
-	dput(dentry);
-	return 0;
+	return simple_unlink(dir, dentry);
 };
 
 const struct inode_operations efivarfs_dir_inode_operations = {
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 1f4d8ce56667..298ab3c929eb 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -278,7 +278,8 @@ static int efivarfs_create_dentry(struct super_block *sb, efi_char16_t *name16,
 	inode->i_private = entry;
 	i_size_write(inode, size + sizeof(__u32)); /* attributes + data */
 	inode_unlock(inode);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 
 	return 0;
 
@@ -522,7 +523,7 @@ static void efivarfs_kill_sb(struct super_block *sb)
 	struct efivarfs_fs_info *sfi = sb->s_fs_info;
 
 	blocking_notifier_chain_unregister(&efivar_ops_nh, &sfi->nb);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 
 	kfree(sfi);
 }
-- 
2.47.3


