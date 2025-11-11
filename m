Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E285DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD8C8E002B; Tue, 11 Nov 2025 01:55:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF538E0028; Tue, 11 Nov 2025 01:55:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E548E002B; Tue, 11 Nov 2025 01:55:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 932FB8E0028
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60F484BE47
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:37 +0000 (UTC)
X-FDA: 84097415514.06.93152C6
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF47B1C0007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=JGLwt4bF;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844135;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NN/33ifYl1WumRWtJ01j5wECnyYUZIw+8lYgHF3pdkY=;
	b=eDvWnb3oBLFPs5r3J4SugValIxGe+9tHa3/0kAsAWPDkvGGiVL1+Jq/Px45CLOSjFTVW0j
	NhXFjpIi5Uz9ZwPUGnYu8MqZyB/zztyhiGgJWqbuPnpXd61caWEl7X04ncy1HJJovhusSm
	gwbobI+Qy4fpqlFE+E3P6cpmM4ZISsQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844135; a=rsa-sha256;
	cv=none;
	b=ZSo8zwGXr1J02XtzqqLy/YjCu91fqyKQq1p0aKkRdN7hgCDnLlZC4w1An4j3KGNlXQRXkq
	saVZ1qrX1RNRPWageU+LCi6HjU42hjh13/BA+X2ni+hdpZU+LpHk5Yr3HJRPA4e+/mDQKb
	TcHFaX9Z8h5hKw1pvii4OcfOm/L74q8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=JGLwt4bF;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NN/33ifYl1WumRWtJ01j5wECnyYUZIw+8lYgHF3pdkY=; b=JGLwt4bFKt+weKOGEAuRY1BkUH
	jksDpCk4IvkmGCryA1CxedqSvu5B/BXGdNI+IcDKJ1r5rfWS7ErXAhGX7Xy1lFVsR6CGDPeZnJ7aj
	fjjrD0fAmbmuUruhPrlaA4Z4zen9Wd9GNwhJ/h8iDP8LGA6/f7zAzcKx9zM88wQ4CoRvHbQZcjzeH
	4+PJKk1uZXrwvPREkXYtY1eMcCUsOaLhg/A76+4nBnjgM1P/PHvtfm2uzHpD4UjilTjncT9UuqJME
	+gN4ieWneLEyDsQxGtkOS73PsH08RsYC976nln8RWc6oujYZOuPeXIvbre7uIuvb4MXmKirSZBcQ4
	EyY9JreA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHr-0000000BxHh-3DCA;
	Tue, 11 Nov 2025 06:55:31 +0000
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
Subject: [PATCH v3 45/50] convert nfsctl
Date: Tue, 11 Nov 2025 06:55:14 +0000
Message-ID: <20251111065520.2847791-46-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BF47B1C0007
X-Stat-Signature: hqcjyxtt9sg8y3r5zygfu7wtupq31u4y
X-Rspam-User: 
X-HE-Tag: 1762844135-768235
X-HE-Meta: U2FsdGVkX1+dqUtvtyXt6BLsqQxzpaCe0cy3TsOz2NHp5QzoaTOpqW5Vfg0Gfivdc/wg6ab3ApBp+JO2xxyGo9dP406iO9noPY95NaJYKf2xAcbVerJyo7kpF7DHpfr6fLjtZVzbJ69yaV9b5bPBt4VQ0jI9v9CXtHychr38chUXpBuhuCxlIznwYowcAyzfDM0IdJxbwjyrdo3zlLoj7Xeq2W8/KjC0szJNsHwqZz2WRZMiKIxPH1CjVxN3MsF0/rs07r91AbFeoBJoIzCY17a9kCldUAeZL6eEW80i5KcSk4Dv9qmd9E1D/VO73TyEHRUV5J4kvxGaMTOe7KB/shHhvhTrNfjQU/DQdFbPFKM9ZN0x4ST3Qt4laY1VSxEOxqXEqkyVKX7dbApbt5nI/9Nw6+i5ML+MpDTgv5Za9bAdcsF7ViW504vtdV0GmmScvIGu9NkodCqfB7845sAet6X8gpvKKWgYxmPReWP1VuQ3N6o69tLlEINpeGT4Cz8wq7jphhMZj4c2xZDUabKQLojsLZMtToTbbhWJfifRJc5kUXtH0ZDLEyN+z4e2+RHfMWgZxESlmcctWNNhbOEHnUUE8pbkPe+dvdzIe4LjSfKnYbNGgsZwWykmbfm7S7/H8BIp7MYY8J5DVCUoUbAe8MwAEcAdLe94MRwDPPdThCTZL/SEY5xKrJca/E/2S/S64Ad9QrhXEwij6Ud8WI9LP7eICC2R3nlYeddQgMkJTIs4boC1p1GTpkRih0O1+ksqEQz6/rB1/NoZ0Ocue176rat84SGJ3e4vpYB4oljt0s3+aPdoqlQqSTcZ5CHmlEdDc3lyJ7DSZvCNBkJ8DSKoBTHRoUe5+g3uv6VTTllYAHnJ9JwMtC24HPnoCoV3uqLLM+TmnAZsDzJ7lW2CRM6GT8pF8tMdflsc/yU72dOKlHyU/+2D+4Vm6C36NNDIWS2At+mCGA+ETI2rLKBgbT3
 +xCUjtYF
 aQyeHOSphaH4OqwNZ1XGMcPmBlcTa4MPlorGOAjHQplpUyZgPwgTXWfWWSngE7xMEPVbYbNw/07UX5agpECEO7JRxNl8AF7XsS+nzP8TYG3CQIIR/7rPGWN/ADI366SCgKTGNNDaq2m+OMeGURnAk7L37I/92YjVzGwytoDtTOECAvmiNoW18JqgdmlKhoqoKoTgwyrfyP/cu4LbrYbQP2o4S5GES3cntibSza/OTr/Ouj8EYA1O+EYYqKTjS6Jn262meERaGnPzA3P8/iXN++Z7Y+RW3dBDaUK3VhaWmmAxJCtL1SrL3f+9tDjv7tiTnWuJflpdxNCLZfvSr+uorkDfZd6atSPjpx/x7Mx/sFMpPb7kQePBYvr179ninY0UIgBBrN+suHy+Xu55oFo6JBnBZ4SPw+JYWScUu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One instance per net-ns.  There's a fixed subset (several files in root,
an optional symlink in root + initially empty /clients/) + per-client
subdirectory in /clients/.  Clients can appear only after the filesystem
is there and they are all gone before it gets through ->kill_sb().

Fixed subset created in fill_super(), regular files by simple_fill_super(),
then a subdirectory and a symlink - manually.  It is removed by
kill_litter_super().

Per-client subdirectories are created by nfsd_client_mkdir() (populated
with client-supplied list of files in them).  Removed by nfsd_client_rmdir(),
which is simple_recursive_removal().

All dentries except for the ones from simple_fill_super() come from
	* nfsd_mkdir() (subdirectory, dentry from simple_start_creating()).
	  Called from fill_super() (creates initially empty /clients)
	  and from nfsd_client_mkdir (creates a per-client subdirectory
	  in /clients).
	* _nfsd_symlink() (symlink, dentry from simple_start_creating()), called
	  from fill_super().
	* nfsdfs_create_files() (regulars, dentry from simple_start_creating()),
	  called only from nfsd_client_mkdir().

Turn d_instatiate() + inode_unlock() into d_make_persistent() + simple_done_creating()
in nfsd_mkdir(), _nfsd_symlink() and nfsdfs_create_files() and we are done.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nfsd/nfsctl.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 2b79129703d5..5ce9a49e76ba 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1137,11 +1137,11 @@ static struct dentry *nfsd_mkdir(struct dentry *parent, struct nfsdfs_client *nc
 		inode->i_private = ncl;
 		kref_get(&ncl->cl_ref);
 	}
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(dir);
 	fsnotify_mkdir(dir, dentry);
-	inode_unlock(dir);
-	return dentry;
+	simple_done_creating(dentry);
+	return dentry;	// borrowed
 }
 
 #if IS_ENABLED(CONFIG_SUNRPC_GSS)
@@ -1170,9 +1170,9 @@ static void _nfsd_symlink(struct dentry *parent, const char *name,
 	inode->i_link = (char *)content;
 	inode->i_size = strlen(content);
 
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(dir, dentry);
-	inode_unlock(dir);
+	simple_done_creating(dentry);
 }
 #else
 static inline void _nfsd_symlink(struct dentry *parent, const char *name,
@@ -1228,11 +1228,11 @@ static int nfsdfs_create_files(struct dentry *root,
 		kref_get(&ncl->cl_ref);
 		inode->i_fop = files->ops;
 		inode->i_private = ncl;
-		d_instantiate(dentry, inode);
+		d_make_persistent(dentry, inode);
 		fsnotify_create(dir, dentry);
 		if (fdentries)
-			fdentries[i] = dentry;
-		inode_unlock(dir);
+			fdentries[i] = dentry; // borrowed
+		simple_done_creating(dentry);
 	}
 	return 0;
 }
@@ -1346,7 +1346,7 @@ static void nfsd_umount(struct super_block *sb)
 
 	nfsd_shutdown_threads(net);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	put_net(net);
 }
 
-- 
2.47.3


