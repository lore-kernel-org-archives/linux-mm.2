Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57496CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171138E001A; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4D58E0013; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB5C8E0010; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE5918E0016
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FA95140438
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.25.25B2F79
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD4031C0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bfOYqpnw;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcFcmzxfGV+3rJDGgJ/eg0JcSdO3AKCKkQ7NxQ/vrvI=;
	b=sEjlpvSDX9iwB+EDVAng9d9IbFcR9Cc1IlU/mSQisIOenKbuoVAeDY/6Y40DC2ykB9pV8A
	OBykq3sbuI3vKcfNxRiLXEuHk1LtqT+EWSYHJ3X9F/S/ZF1iEm+TqeZ5lmhrualu6rYVAP
	/QnNeMzlfZy/KQDjcBsyCfO1SL76SMo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=5JbZNRYuAv4+SACyYmjmNirInPGDgsx2GvPJUliBS306aaMIaUocn+Y55JJsx6GDwgF88z
	f2TSVtwu93GsqYYKRHGWBo/QIDI32+93sR6lTZZcWi4p4nrCDtDuWKTRpQeeCvdD0UKYvS
	xwHZL8ObaCASIu6g67CfqOTHwoi5rjA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bfOYqpnw;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TcFcmzxfGV+3rJDGgJ/eg0JcSdO3AKCKkQ7NxQ/vrvI=; b=bfOYqpnwRITYWirzu325V+Vjft
	4P70PiidxpZzvKaDpbtGKJZ7Z7kz6ULfRHNrRj/WhL+Opb09PfOAkeMHjytlfhR5QIfbTxRuY/lkk
	/SP/qvo6ubJuLtRmW3riFd9ATus8rT+PHyY9X1HWRv2hv7DJJ2L7Ccaz4SET8eWwIQLJ+goThnlDi
	vkXMMPnDq1aZDyW1sUWNd7e6NenMqgpjtXspP5i7WkLuyOipur7dG97xmgp/Mmhh9IBeuSaH76i9V
	Rv8y20iWmbTDwzQuWzvArRCwYZiu969sFh4ctU9PLoErZxvGh/parpyMzgOk9czyg9AZyT20F80Sa
	ixjYrEeA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHl-0000000BwzW-1uyd;
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
Subject: [PATCH v3 24/50] convert ibmasmfs
Date: Tue, 11 Nov 2025 06:54:53 +0000
Message-ID: <20251111065520.2847791-25-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD4031C0003
X-Stat-Signature: on5nco9mahe6bp3aucpnopgkihuddmm9
X-Rspam-User: 
X-HE-Tag: 1762844130-9404
X-HE-Meta: U2FsdGVkX1+vcoQxeqjyyr+79bT7LWbdAaulXYeZYlcQsM+jzP2Klt0RYzCKeWTre1ja+o18TyA0r3O3KGw6LPubZgKN2ioJ7MQylCdb0EXgcTIbFQ2sAhZGiaD9cWUrtBoOUsJNAFrXycLYSOCvEafIYdTevL8aiEqrPor8NX6agm7USC5AnUbkqx0MUcUvIgEksYaVVqMYie//Tvco3Uudkp98UJdu2+M0tRWOzdrd5Dh8o+Xd4c5KhAiS0LAVnUzZYmq+9SmlTFVtvlemsqiUY11HymcFxRdCJ2wL0bTxFdkuKpB/un2isy12dpEcxdcayvh7XQhkeTJUCmBnUl07MK1qELzyAMB7nX6m50c788/dDyIsOETQnKlOS72MtGCJZpAY3CGm19bNlGWSGE6vaZ/+SM+iqnbZV4fnsVJCKXQH17m9bPC8EFpeu/4IMmbrej871CwqqgfitSoSAlVOyz7wbajZxPjZ3E7RXrwUQ+Bq6bgzhyYY/8haAdRvrJiLMkeedfBBpqqAW2jm8QWyngxNNa8uSP2mR8XCmT2mm4BXL7TOI9idNyP6f7Q1zLrCnjA3wouiTUYV8h0JyZmZnexKbsIm9wPOUKNaw5DjDoygDsenH1Ca+cC1wwX1y33/exOHn3HEtjH0r6/ZsnC+zybNYTC75EpBFMKYukt6vPcUDVnsOJuKuaUC2u4gBYHQ1uM04mqE90zLe1EB+OpTkeRygZ0VWJM5Ar8XCTuXuonZhjEARmOEJ/p10jESLvkV+oajVgtVmEQYEqP+mHN8qx50JGQDlDn/yVAqRFlKKKWAoxcr+UIXMiaqPSw4rGHTDJqBuVKYrkCGT77TgUTvAvjwkRHw5HrqM5wnfpo7motFDF4Oilj49bofkUa11e3tp2olkfeU5K7/IDJ2jzXSB9UNgumy0S6aEoUV9wW5TuaiRLDfpT0ud1Td45LhsZcA806fKC30KPz9ZvV
 PJYB6DoU
 SXSRzciwpoM3tHs/n84Bex2i7e3m7J0oOAm3/FCqrvkP8rgEgnnQ8HvJGF3cQrUFNWfLPJe8GOliab2rp1CLLoUWS8aF0JXCzCp8qD9JGp7962Uzr4xSc99SFCs3sd9nd315WuKAiFld7YEzamnxbh2NwL8xJWzk5oyRblO+9hfR7NjpDn5QBYFo1F66RfXCaVAia9cdLzW5UMygaAqZyDbT5ZKKgbYipNUt7eW4iyKP1O1I5A+y/2obT+v+XA4MtQzoEeLSCws4QfGXe1EhIffPwBcTiggVGXR0ZOQxZO8//YKCyE408H6uvvzj5wgHfEcet+DqA5b539zCMveol28hKtM4Ep4Sc8Bp6dMmKdhtLwNdG0tENcop3YhfuI6NVSZLdy0+oZLMFnYvb5WGDLiKFDe5cwHh6MX2N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

static contents for each "service processor", whatever the fuck it is.
Congruent subdirectories of root, created at mount time, taken out
by kill_litter_super().  All dentries created with d_alloc_name() and are
left pinned.  The odd part is that the list of service providers is
assumed to be unchanging - no locking, nothing to handle removals or
extra elements added later on.

... and it's a PCI device.  If you ever tell it to remove an instance,
you are fucked - it doesn't bother with removing its directory from filesystem,
it has a strange check that presumably wanted to be a check for removed
devices, but it had never been fleshed out.

Anyway, d_add() -> d_make_persistent()+dput() in ibmasmfs_create_dir() and
ibmasmfs_create_file(), and make the latter return int - no need to even
borrow that dentry, callers completely ignore it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/misc/ibmasm/ibmasmfs.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index b26c930e3edb..a6cde74efb68 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -103,7 +103,7 @@ static struct file_system_type ibmasmfs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "ibmasmfs",
 	.init_fs_context = ibmasmfs_init_fs_context,
-	.kill_sb        = kill_litter_super,
+	.kill_sb        = kill_anon_super,
 };
 MODULE_ALIAS_FS("ibmasmfs");
 
@@ -144,7 +144,7 @@ static struct inode *ibmasmfs_make_inode(struct super_block *sb, int mode)
 	return ret;
 }
 
-static struct dentry *ibmasmfs_create_file(struct dentry *parent,
+static int ibmasmfs_create_file(struct dentry *parent,
 			const char *name,
 			const struct file_operations *fops,
 			void *data,
@@ -155,19 +155,20 @@ static struct dentry *ibmasmfs_create_file(struct dentry *parent,
 
 	dentry = d_alloc_name(parent, name);
 	if (!dentry)
-		return NULL;
+		return -ENOMEM;
 
 	inode = ibmasmfs_make_inode(parent->d_sb, S_IFREG | mode);
 	if (!inode) {
 		dput(dentry);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	inode->i_fop = fops;
 	inode->i_private = data;
 
-	d_add(dentry, inode);
-	return dentry;
+	d_make_persistent(dentry, inode);
+	dput(dentry);
+	return 0;
 }
 
 static struct dentry *ibmasmfs_create_dir(struct dentry *parent,
@@ -189,8 +190,9 @@ static struct dentry *ibmasmfs_create_dir(struct dentry *parent,
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = ibmasmfs_dir_ops;
 
-	d_add(dentry, inode);
-	return dentry;
+	d_make_persistent(dentry, inode);
+	dput(dentry);
+	return dentry; // borrowed
 }
 
 int ibmasmfs_register(void)
-- 
2.47.3


