Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66922CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2988E0013; Tue, 18 Nov 2025 00:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73AD8E0005; Tue, 18 Nov 2025 00:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B828E0013; Tue, 18 Nov 2025 00:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9E18E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:42:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D326589C5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:42:43 +0000 (UTC)
X-FDA: 84122633406.22.1F9DF6F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6E0C418000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:42:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=JV5uJUt1;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763444561;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpD3/Bm7sGWpOU7mqGoqyLeTupfR9EfJ0JdO0qw2AEQ=;
	b=0HQlgl6wgXiP4vFAn5d/7qek6qM2PPXaoom01sYTab+d1XROG0GJ4npj1KcPPvUiGZ+6Ri
	fV4Pb4ObC8ZSHNAv8XtIkX3bXfUXqJYbRqUgW41ZK9TMCJHqOO6beYRXkoRV+2ADEBSE3j
	oXEqhveYCuL3gMixQa71XWn/Mvzldc4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=JV5uJUt1;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763444561; a=rsa-sha256;
	cv=none;
	b=X4Ciy8yQEs2lvg1Bf5sxewXoF2LCYybIwWj++bzwqKJ3UpTN1Pem9gNmuMhpNXI0PrA3VA
	+DZXgZ+a1V2d19+yIq7CfwuMbKm5ajLrZb0eskXt9eQSHAlQzMzbKaNLjnr7ASNqPpKso2
	C67yf/VQC9+pkB9urPqnOuMTbetrr18=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wpD3/Bm7sGWpOU7mqGoqyLeTupfR9EfJ0JdO0qw2AEQ=; b=JV5uJUt1ITFYYkAKYlbaasyk0N
	PW5LOmB0G7kEAnq97/Pz7SL51bNXf0DH11bVMNSSo4VwTsOpOeAHHK4hjh1p3gNPqgDjORQ4PbR8J
	KK7IVJelLsoIjwKAA7hEb/jarXycA6T50GWykdatgQp0BauELpU7gwCBfVEySxkZarZ3jA74FYqzk
	14zTBSbWYbuUP+E0SR2hyM5Imgnf1u0+rTSIuPM1/R7wCIuTMjeEEb6IZySpBQnw/dlJz2Ddi015D
	mo4bEEYz1oWEajNUCAw8mVLVUOHlcTH5qN9tMMRtFWAcpt6zvtZFD+/rj8NlfIFJO8X/JjIUZtHSM
	ubkRfpiQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4a-0000000GEfk-1u7R;
	Tue, 18 Nov 2025 05:16:12 +0000
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
Subject: [PATCH v4 51/54] get rid of kill_litter_super()
Date: Tue, 18 Nov 2025 05:16:00 +0000
Message-ID: <20251118051604.3868588-52-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E0C418000E
X-Stat-Signature: s6x9146sow7m33k8ofanc8ztsfyxmiif
X-Rspam-User: 
X-HE-Tag: 1763444561-297011
X-HE-Meta: U2FsdGVkX1+RhiFbZGTGuv9Bkqv1aZMJOPCjVZjS6Sr5b5UxBzkEUvmCGzKKy3DMOX4Ks0AJQI7ibLb2/LUmjQQol28QqIEkQFg4K7WEYjY10cePKWM5gdGQN6B8dZjXnXDBqxFg4p9CSCuglq5vx1ybN9xp2YkurESG1p63d19R/MlM0333087S+ptc4VvPhuzlMXEFhPBcWBgR1Kql17aZ4y3IUcWcsS1xsMXdzgpL5yGI5e9h40AgZMnsZux6IAUeIyaG1bH5iPMCX0x4IY+p8icVI2cbVTXsJ4dIFGlsCVJhRRtPHdWexe5G3eCloKhUhaL9zwdVKJCsuPBAhmwYEY0AOxJLYSfyoCpaIOmAlOeHrpDAHV+2WS/XUEJlj14hzU0ZicufQBEwhooacU+AW2Vrn8qEKMHHHIyi9+TOZMCodWDGthq13GMivwJeFj0szeowmIU97tYOb5MxzOfzA9iemHw8YC+Dm1k9+48d+iqHqKZP+7/gc/y8C1ZIVaxjZkCWfiIPKRROWEuR6eMfS2xyoTpQ2uUD/Msrz6ClqZhWffqQ8Tv4CVuSnltClCzXK5Ys13sVUhVhyTGKOaQZcLZyas0/AEEPzqxtn9DoxxoknXh4ETouicM1wFIEH3MaCOZpVWZMNya3Fa54kA92zGbuIdJR+8pchpF758qCKQxaGjPUPLnilqi3r/iCll6swvTcacI9Xp78Ea2+EcZDw8xEJ2kXLirb74aeZgLfpj9DE3oIaRhUhFiMQesDF5jAeU+Kv19bwRjEzNdHakB2o8R0HHQ3y6Dnh34hOc33UIq35d6PCzEhoKH+CWtVnleCpvpGBV3gxUhAt7BeTrynhAd9NuljiLO2HRGHr665MxEmgjKgCA90fp1UyGqwkiuqwU9mATtLdezeAO1ez0AroLIScvD8gkYahSWdB1JeXQwtHR88xZD6cHtChYL9Kcy69KPtGiUe6eWYFOn
 5sagV2Ey
 utJ5pLxMZIgM/KpeO+rXpx2qU+MahNSnlkIizCYg0rw9DwuJLlfkH6xRHMneJNHtvhvQ840i9UmSigDhan6GWsRyOO5fAteA5tAHBuAPARsu4RMTHAYRJGv8AWmyQgBP6ehGAXTqvnQGeKwgiMuLCsTGgDO+X9VIm/N/FX4agV4CsMzx/NLB11S7AGgYTvb5xZtqGrq3N/772/PcJ6i2ONxO0UNEebU/C1EztBjwUvMHkb0xo15Pe9Z2JJnb0YQuHi2kx1BNnC932ty+NSOahNXoYEaxMOlxDCxLEEHRmv4qETDDChWtGvBbbmhSwmgFOW9Z7JaVvvsA/ia1lCNTCgmoCKoS8BQTi0N1vCu/H59Ny3fxcj8fhdjC4mzAStCrfBg3ooPSTxKIKWwjUdar3yZAGdLQ5Tlg9Sg10MZM5PT6StisZMZ//ZFJ9225TsOyzOULz8XN87qbdWo4Px99JpOqKjZoi1glH8V/loDIZEjngyKicI50A6h02vw==
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


