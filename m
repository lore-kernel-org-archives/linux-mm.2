Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D9CCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7918E002C; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343D18E0030; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD5D8E0028; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC98F8E0028
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B33831A0418
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:38 +0000 (UTC)
X-FDA: 84097415556.03.065D459
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20341120004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=CBs3HWKU;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844137; a=rsa-sha256;
	cv=none;
	b=wqH10rZR8L/gdq01WDX3Jum3YeiHjxYchJRptODXlboKvEsKBopz0Ej3cksPxbN/U/UUtI
	/Rc5k/h1UC7G0zR6U3VXfeFSXlrw10c0S0ljbFFDg0vDWTJAMx7LPOnTTqiM7QzZ/iJTSU
	Yn4eH6l2Oo6sLGsAfRpERuhhvvVidOg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=CBs3HWKU;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844137;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpD3/Bm7sGWpOU7mqGoqyLeTupfR9EfJ0JdO0qw2AEQ=;
	b=RRIUGAzvB0LOI1liWdq2hkvYLmYIeignnG5yS/k6RE07mH6COjbmP9+rqg2EJIH8d9o5Ox
	5nw3g30VG3Mm1kE112bA6ZDmX5pVscgxdZkvvx9CHK9mJRe60wEpXevRZ8DKimYuk4NfnI
	Opso6WVnQRbDHmDMzBm4tmh3sizlT6Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wpD3/Bm7sGWpOU7mqGoqyLeTupfR9EfJ0JdO0qw2AEQ=; b=CBs3HWKUVB7PxyhYsggH1moPwq
	TDMOfNPze804ERULgFgDbvViqdMWMVbicUAGNCIOpbaHIkoJFiaDAGeMsfnNskflhXgUo8EoYwEJW
	T5YOHPY81KDfieCaqV0Hw2Yqz2JkpwxpxeR1i28AkWI5bCiyPeEdLZgCMcrXi7kH4+J5AxIssOkVT
	4BKc4aZMopg/kpv5KGOTrnYn3suNjSba+qGG7vQHR+3Cepf+UuVmRpQgzlOxQjZl6Alcg+RaXA9tj
	A95YtZA/jKIFpV6XqOXxihLOhTS5mKOGci9TCc9W41oxzZI2mUE17rTlgH5I2VI13Wa47W+bz+v39
	V130mP1Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHs-0000000BxLe-47lP;
	Tue, 11 Nov 2025 06:55:33 +0000
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
Subject: [PATCH v3 47/50] get rid of kill_litter_super()
Date: Tue, 11 Nov 2025 06:55:16 +0000
Message-ID: <20251111065520.2847791-48-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 20341120004
X-Stat-Signature: t9frxmoxqycraz8wrbx9a1874up8jpoj
X-HE-Tag: 1762844136-887370
X-HE-Meta: U2FsdGVkX18ZsviqNtsGUyyL1BSHX4gDBv+v9fuVr/M6eSZYb/sMx8ORWS97Ty2W5akCTkdXunYsk5kSlpMfHe09q6GglWziqPC4RLzF15X5NMOx4kQOv0NvOjhXFayUguhccKOe2Zu9ucxLHIK0GrsJGtCPuUdnPlmgWtpm/4MkGs2IRDRVpCZvd2zSy6alhyiHcIeaLSoWvQveJ7e4yIdQ6suVEFyrIa3soPse+lzxiqlXmfAqH3Qahge6xA77yVc4SycM+MuCSmrnZeCv6MaF8KQ6i2PkAD+oTzVROE4P82JV3cRkam4WnXWUnZntYn5SQ2COQI9iYt2Wa2nuHyFwGAxRgg5VJwFNAwEm++RoZFiF9ffm8Kf/n11J87JDRfYNIZReUFqt/6IyQqklCAKgDxH/OFOAtFL+vJtFmvmqaZcgljnq0EO/83JCvdaR0ADRun4tY/xSHnmdFXxirW3tRcDRv7Bs8Qt4Uzdn3UY/ido4vec5KzpZm236++Kp7DmHsXzyhcxCRogGPsSOUug3tsi6Ne7O5s84T3U2fdILnntl9LJlwkeg0ARjlu9iEwznvVE5DMjLkh5QNLPLt+upbEG+idSfSzf7fn4OJuk+G/32FVpaxzcaGRedamlRpcC5Jw6DbqTZt/BPTBxf87b1BLSY5sdAoYwCZ+A5CciDPD+R7y0ggPPYFpqo1zzxL/mXwk8GVfIdvIQjyIAqPdBJN1nr7ozOEMcHUtPNaHdNWJ+dKuOtOcHRuQGaBmuO7ZEMceKfQTqIJWtsjZ/skQsh/pNDx1et14N/k0ApsGglETWjgHmTdeSo/CYrXVXc4pu3qjHOTgLbrU5FFFw7831+tCNjDURkvr/BzhKYsRLn1EHrfBjJWZfnraVqDzpoK0Ol0UlYzlKCUFFoUglt7vUCluMuBF127hd6ZUIv3/cnS7I5e4ULcfbnxbEzF8csYUEaBW7VfGiPmZ33nfi
 7I3nfqam
 oSRQsl7qoxoXXHtZJL0Jt47OwOZf/loOJEmuydM/qTZhb8DHzbA8+/UpRYuAyOrUvu1ODWtj8Jl+X2qZy9mCoW14R0E0rucmvSYsx9gW7mr1AWF0A1OR1toSju1TaTSV3qs8qLW054uEg0P5U2YgYK8Mug5TH/U7LffMjCWX6RI6Uc74qgsyBheSYTO9T2jVr0/NFidtIX+C8OhLkKAj/FjFx/vcid1lsYM27qeubJ8TUJq9fAD1LQd15KEqeFZ829Wnf4ORD2Dfq8SIl8VKIX5JFm85jYEwbk4abcQ/ftqb9jAIizE65stqm5IndSIR5r9i8/1P6EuTNteSnCzyXBFfUZAUIepLqmX9heKrP11olZQngZf2S9BIGuyv9s763Qr/zFCHoNdofdlLbEmjvKR/F22LlatPr/2XHkZtNSTsphIyM8QieNm+V36tpVahoIQ46J1FImabLC3AF4wixaX1xPNdhTfzHDhZrWrWYLxApuGTU0cLojTSyzg==
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
index 3cc6c3876177..5ee2e78a91b3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3167,27 +3167,6 @@ bool is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
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


