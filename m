Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DF5CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7CA8E0024; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175218E0011; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDEB08E0024; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3AFB8E000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EDBC12D073
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.17.B6F82BE
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3886A0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=srH0KwSE;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB7wA0wn9kq4oYSSbdEKk+jzajBsWCKDcw62G4pXAEY=;
	b=xuwl0ftN+2n9Hee/dow1bLP2n9k9g1qsVEGN8IJxew69bDUeRcS8GEvWtXR9Nv16XBa3kj
	uulzSb5TNKLGratFoSK/tPPiDEa9g1S/2zCo2d0Sw0Wmp7c8FUUGmsmp4XxAonlGUdICh2
	RgDXdsvxpHiy+6YZpc1uJi97/H7fLhQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=gnGKSQO0el+qNMFjwoRaCdUwQhMAL8gmGJ20TLdYQwovaYRPAPtFvKq0ixgX7ZPDha0evX
	Y+DJD5+mBS5RyNXjN9QbpX//tTuUC5xxmYC+TDpxR0hblBmt3Fye6VHzQomipS/zDukx+Z
	ieU+WafaEkaqcYgFAOhRXaEXT/Q8b0Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=srH0KwSE;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IB7wA0wn9kq4oYSSbdEKk+jzajBsWCKDcw62G4pXAEY=; b=srH0KwSE2XsBNhJ6Pa1lnRKFR+
	AuxixTwC5eVEpKdlKzlXERKEphmWCTV5jwTiid5LIGq8WPQXx/nyCSgJvSuGK1kxcLDwXDC6gIwG9
	XSd596rNfpN2/yiXLm3uTaI5i7gaoUZfFFMcCzrzHsrkZZ7k7sdY5OyeRsQl5GJtsJ8yXp5iyieY6
	IfazwKAfVCOu5sMeIEKWfVm0Wc1O5Z130dot9wAtZrHqcV78om3ILEo+aW213DTBA0WagLtFQvJb5
	NKpNLXJHp2OvoCyCa/zzHIEMnUThF83cBP4/a5DpwKJafTjOVGYVeFg8Sr4JqcUMS77ow8q+VXDBX
	RauEKAtQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHm-0000000Bx06-17qr;
	Tue, 11 Nov 2025 06:55:26 +0000
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
Subject: [PATCH v3 31/50] convert autofs
Date: Tue, 11 Nov 2025 06:55:00 +0000
Message-ID: <20251111065520.2847791-32-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A3886A0003
X-Stat-Signature: e1o55pft73bjk71xworx9wtaxs49a4iz
X-HE-Tag: 1762844130-998388
X-HE-Meta: U2FsdGVkX19pALe516wWPZsDrbS+znC3cjw2+PlNLGaYXcM1WoHpui6CfIzpKbwyYh4QkZ/JdeEJfEt6dC2FXHbhXHWEy+Cxpa+4HSphrBPRdlqTn3ZQ23zEPEIEHinpS6aSq/tOTM/qz6EfUY504c84/59JopQLDMQCi//Gy07jHvxZsVyXfNDCzQyyB7n8e5WoTgSY/Jgu2uPL5Qjq+Oojz7DFTctVRw4VJSBkStE5itMNpbECEMOnY6ywfBnBWCuFUJkbyix/rIJZkXClnNcPwjJVtOVGGxP/CeOv7L6ZRW4tnkGHPbPVVSN0lv7vSMQ8isCY9OwZUSQfPupJV7DdU/ttJfdJ8N8mc+TtfeVBCkGHA9rbvyXST/FLbA632r8fuAomOZ7IGI/CgY8BmxmY9po+DbnxUDThOR9Q3tqsAfqxzY1Lf4EpZpRPo6x0D/773jztpGXB51qthSWdbQDsvLVYQqES4/vewwbkTxjMmPuUZTbxvVLug5EtmEoZtpnlWW0xnofQPTJoIU6E7flOzyhBRZ3KjHa8zfshzGhRtEyG/Co7+o2RHn65Bg4RV6pTJR6hKpRl9UmGbgfB5BE3FJbu8zst8mrOD1kh/G+3ABHbzh2uBF+O5sb7MYSm5tmNvosVE5dtaGEKUFX2d7enLFIXduWzzpXg2vKChRVaK+gOT5s7E6o2KU9s6J5fSX+s84GAhJGl+DtJOD4C+aaTzKR7ai9TcGdv+o83P+UEQv4kiVr6zqQ9wcs8COqcD+a+3bpSFLh80RLbJ59mzHz66V4ejCiUrD+GqSgp0P1foHqnsMr7z21emYBo5odxOQOodTurU0QDUfiYHKSXnDJ6jnzEXKA2tyu3T0R3lqHk35cYm0D1DVVDKf2sSsQ9av5thChAssUoUCCDieF4PqDK/x0m+F+ix96jmLnlIO8TrASGvSKijNCNaS+SG1WIh4spmMo2S3MKQD1bbyt
 EJwjKLAy
 qfg8ajeGCgebmaMzdVa0a5eaLUDbMnFA1gumHEmWKTKmCh/eUYN/u3og/G9USRZMbRf6/zMcgS69EaU9fHFWtDX7dsdQnC4XUMmsyqBv3jD+QMZaRcmF5a+afnu6jAmk7CDEjA3xWact4ZIAZeIfriVYEdv1UAfOPwGZkzvBUneweyVrTz9JthDFY2Y1N973YA1Pad/28nAOtyMKVLGMhcEzSBJkZl/x+UhCa/ikg0wy+i8lRwVlC8Np81Z3qUn+q1M0Pvl6sIaFtXqBaBTC+nwsk8joS1uxE4H0w0OLLL9ako/Vm15MGTJoF7iALYF4+sHG0T78jcWW/TY77pbMvMqXtZ6o0EtxqYZjIWgVK88sIT8VqT2swSFQnnNP0gpQ1H6Ug3sZO64r+dJ9MIXzdNMSvOsxWWfI8XoTm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

creation/removal is via normal VFS paths; make ->mkdir() and ->symlink()
use d_make_persistent(); ->rmdir() and ->unlink() - d_make_discardable()
instead of dput() and that's it.

d_make_persistent() works for unhashed just fine...

Note that only persistent dentries are ever hashed there; unusual absense
of ->d_delete() in dentry_operations is due to that - anything that has
refcount reach 0 will be unhashed there, so it won't get to checking
->d_delete anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/autofs/inode.c |  2 +-
 fs/autofs/root.c  | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index f5c16ffba013..eb86f893efbb 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -55,7 +55,7 @@ void autofs_kill_sb(struct super_block *sb)
 	}
 
 	pr_debug("shutting down\n");
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	if (sbi)
 		kfree_rcu(sbi, rcu);
 }
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 39794633d484..fb6c8215456c 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -594,9 +594,8 @@ static int autofs_dir_symlink(struct mnt_idmap *idmap,
 	}
 	inode->i_private = cp;
 	inode->i_size = size;
-	d_add(dentry, inode);
 
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count++;
 
@@ -627,7 +626,7 @@ static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(dentry);
+	d_make_discardable(dentry);
 
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
@@ -709,7 +708,7 @@ static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(dentry);
+	d_make_discardable(dentry);
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
 
@@ -739,12 +738,11 @@ static struct dentry *autofs_dir_mkdir(struct mnt_idmap *idmap,
 	inode = autofs_get_inode(dir->i_sb, S_IFDIR | mode);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
-	d_add(dentry, inode);
 
 	if (sbi->version < 5)
 		autofs_set_leaf_automount_flags(dentry);
 
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count++;
 	inc_nlink(dir);
-- 
2.47.3


