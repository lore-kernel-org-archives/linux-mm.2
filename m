Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 140FECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9398010B; Mon, 27 Oct 2025 23:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A170800E4; Mon, 27 Oct 2025 23:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6858010B; Mon, 27 Oct 2025 23:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD36800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:51:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB5C514039F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:51:32 +0000 (UTC)
X-FDA: 84046148424.13.220778A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E0E440004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:51:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="SPeaTw/n";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761623491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PO4orcfvZ5bdsI3sMLWcxolNLwtTITE6PBUvAzByvrw=;
	b=hd6A4qfXHpbaeMYqGQMdH3yBfLPymW0/J+5EAnNwLsdmCGEvK73MDPT1fVf3AH5bBsMcXw
	p6/ouaUwV1wkXyt3srCahkeh9FxvbDZ5dUObDNESUSkanVb6VHsQ48zWzjne/nELRo2PYA
	PXJE50VRiSpI7WR4GjbWk1nys3Ya3BQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="SPeaTw/n";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761623491; a=rsa-sha256;
	cv=none;
	b=C1vLinDGbmQX4cn9S/UhYuMjhm3LlVNF3TG2ojUmN41ACQ7EtljhA2dKKzRGKihlqQa3Ts
	T+lWpYe6r0ielGUkgbWSuVT7oHZj+Rqj0/99hbTqcj5aRuI6rI3A0/sBfMTF9iQr+F9Lrs
	/gBU5qrDmX6O77DxZLrK0gLbvVjZSX8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PO4orcfvZ5bdsI3sMLWcxolNLwtTITE6PBUvAzByvrw=; b=SPeaTw/nyjy3X7eXKJP1Yo2DDc
	jxAU9ebxyJ3uqAioCRXsinsP4hdXnSK3EBdjRepJJQR+F0qsa9cA2+iyil7m/n/jWSTG+5EfoaFW6
	3W1BW+l4ukWVCnJ8XZNfX8T3/UynVZqDhn3SmVZ/PBeouHxFvuj1V5NHmO9KZdX3+9NwzvW5toQdh
	PPm0f7c5Ez/cGTPblxxIPh32lwIB2chNg/QWjqUsDl9iWHNtSsArJfPm463zB2zC4AGxCCPQunfJy
	RCt1ieimN4BBWxdLwb1cd4Ur3mANf8ET7t1DGQaj097pZoNIm9Nge12OX4v7vdzJAkmL849PqvYK7
	rZfs28jg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqv-00000001eo9-1VvL;
	Tue, 28 Oct 2025 00:46:21 +0000
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
Subject: [PATCH v2 47/50] get rid of kill_litter_super()
Date: Tue, 28 Oct 2025 00:46:06 +0000
Message-ID: <20251028004614.393374-48-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E0E440004
X-Rspamd-Server: rspam03
X-Stat-Signature: 8a5set64bhmoj5s3xxkt9gkp9u1dm6r1
X-HE-Tag: 1761623490-99545
X-HE-Meta: U2FsdGVkX18EA+Q4KR1EW5P4Z/y/IHIJ2i5zWZR9KYAuUFmJJRL1rYXlhxHvxu5Qfh3N6eXvjsAfaDyuqpN40dWh+Cw6X2Aezh6mNvES7v2q/9SekDEror7e70f2EWPYYZ2ISXah6UwS9ubWQn5/0QsHquInM1XkuZpqUNIYpr3SrMcrzavGUuC6po9XTA1EHz50aHsxQTPr7/giTdnGKVMJicZxcnE5V5Uqc83oU65AAXZ64q981lQ+4wkVQisjApX9CemHjrNLWuYpwFPWbIDESAcwJUvZVUWCRKh/sErle+DMlsQuoKCFCdJcII5Y36BE+YtV9fzv1JYZwQboWxEw+B6FTdFmjQ7msbDyRnRSFVWqkjyFvtZe/6Iiqhmctk5z1z84ycon7ObnzvyL1/ZwM5srIfwt/fo+taRJ1KktwpptZRTgzfUrmniTgwRTuBvvls0VQK8sD2Elt0W2krwS7IO3HJFjmitUMSyIRuJJKcW6QzGenpXLYOOHg2Bgmlmc2RNanppC0EWTd8Zyo9Jbc2lPSItDmVxy2Q/H2BLVKbK4xVrnAqxfMYz5xSlC4vY32JjyPMRsNUQHa5giltGcar1oaZKBguMcfpPkpEqFE0VCV0DoC/8rBk0RaHOdxWbysIcNNsr+vwyS0YmigCc3phlkqCuPjNR0eDaXw7C7+mN79GmZ2Rgg8QZngHsQo9YXNOb9WmUMjC9kem3LblOY2Dh8eds7m0uw8Qbo7kQkIgZHIcQK3YxKkfcbnJ++C3Wx86I7ELlTNCN2qtueQLH5yAIUa6Cnfp5kNEMVGS/7JbNfqjAADSf4WOaQSZAIrxxhojL9fzsuiO+vIyE5FUKvumO5AYIgW/tQJ47RIwPTMGcHoBW2MhdKZWGYSG+2hiY5x8ekVAt9qRxOa3jP26rk/dDmU3+qy+ZrXa/As9rYdUmJBTNIxaYO86qZr6ze+N2rTX049K2iCSVtdL8
 ZUbcdaof
 kyZeRekbgOwzH9EXNtKeHPiF3oHX6y3HvoOlVXF+Nyn20AU5+z6OaVZjoThKnchZ9ssUlcpMl3Y0yiiRpnRTXs3YHO5hyyavjfJzVdOxBixX3sbp+lSU8UF4ebA/7GpCG+6zWKquaRnUfUeuhHJg37TT8BT5vI+54uwtKaO7noU3GJzSk5g+9X7Kj0IVjYN0p7kfjYbq2iTwMa9tVqpp3h/Zc81BnkOqTecwLMN/QBYN8Y+REaM3fasWxn0nzCO/1G6VWx3BKnQXV3G/uBTzc8HUtdbKpkFHSSA88KU8df78Kc3iRPbPm0Zb6F/enm1qCYmYqlZsLL2Ii8e9Swe68rmSEPUuyWvyyWqbGpSged3BQ6lxAhrAXY4znarkeFYOC1kY29arbx6Kgw8/6mHvITKAXcW8vPJzq+AFecuLANljtDV21lCZEUZokyejPlL1eHX/olK3ar05zbGPVGYNta8QW77E0cR4RIQxUIo5fJS0Ciumdqpb2Pl2XDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not used anymore.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 Documentation/filesystems/porting.rst |  7 +++++++
 fs/dcache.c                           | 21 ---------------------
 fs/internal.h                         |  1 -
 fs/super.c                            |  8 --------
 include/linux/dcache.h                |  1 -
 include/linux/fs.h                    |  1 -
 6 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 7233b04668fc..4921b3b0662a 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1309,3 +1309,10 @@ a different length, use
 	vfs_parse_fs_qstr(fc, key, &QSTR_LEN(value, len))
 
 instead.
+
+---
+
+**mandatory**
+
+kill_litter_super() is gone; convert to DCACHE_PERSISTENT use (as all
+in-tree filesystems have done).
diff --git a/fs/dcache.c b/fs/dcache.c
index 3e26039ceca1..a7fab68fb4c9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3159,27 +3159,6 @@ bool is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 }
 EXPORT_SYMBOL(is_subdir);
 
-static enum d_walk_ret d_genocide_kill(void *data, struct dentry *dentry)
-{
-	struct dentry *root = data;
-	if (dentry != root) {
-		if (d_unhashed(dentry) || !dentry->d_inode ||
-		    dentry->d_flags & DCACHE_PERSISTENT)
-			return D_WALK_SKIP;
-
-		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
-			dentry->d_flags |= DCACHE_GENOCIDE;
-			dentry->d_lockref.count--;
-		}
-	}
-	return D_WALK_CONTINUE;
-}
-
-void d_genocide(struct dentry *parent)
-{
-	d_walk(parent, parent, d_genocide_kill);
-}
-
 void d_mark_tmpfile(struct file *file, struct inode *inode)
 {
 	struct dentry *dentry = file->f_path.dentry;
diff --git a/fs/internal.h b/fs/internal.h
index 9b2b4d116880..144686af6c36 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -227,7 +227,6 @@ extern void shrink_dcache_for_umount(struct super_block *);
 extern struct dentry *__d_lookup(const struct dentry *, const struct qstr *);
 extern struct dentry *__d_lookup_rcu(const struct dentry *parent,
 				const struct qstr *name, unsigned *seq);
-extern void d_genocide(struct dentry *);
 
 /*
  * pipe.c
diff --git a/fs/super.c b/fs/super.c
index 5bab94fb7e03..ee001f684d2a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1284,14 +1284,6 @@ void kill_anon_super(struct super_block *sb)
 }
 EXPORT_SYMBOL(kill_anon_super);
 
-void kill_litter_super(struct super_block *sb)
-{
-	if (sb->s_root)
-		d_genocide(sb->s_root);
-	kill_anon_super(sb);
-}
-EXPORT_SYMBOL(kill_litter_super);
-
 int set_anon_super_fc(struct super_block *sb, struct fs_context *fc)
 {
 	return set_anon_super(sb, NULL);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 6ec4066825e3..20a85144a00e 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -198,7 +198,6 @@ enum dentry_flags {
 	DCACHE_REFERENCED		= BIT(6),	/* Recently used, don't discard. */
 	DCACHE_DONTCACHE		= BIT(7),	/* Purge from memory on final dput() */
 	DCACHE_CANT_MOUNT		= BIT(8),
-	DCACHE_GENOCIDE			= BIT(9),
 	DCACHE_SHRINK_LIST		= BIT(10),
 	DCACHE_OP_WEAK_REVALIDATE	= BIT(11),
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5037c556f61..95933ceaae51 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2728,7 +2728,6 @@ void retire_super(struct super_block *sb);
 void generic_shutdown_super(struct super_block *sb);
 void kill_block_super(struct super_block *sb);
 void kill_anon_super(struct super_block *sb);
-void kill_litter_super(struct super_block *sb);
 void deactivate_super(struct super_block *sb);
 void deactivate_locked_super(struct super_block *sb);
 int set_anon_super(struct super_block *s, void *data);
-- 
2.47.3


