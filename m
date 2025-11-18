Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47CBCED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA528E001E; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5DF8E0030; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D998E0030; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33C5C8E0021
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7EAF16038B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.29.B909770
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0344A180009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZKo+9Obd;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=v2OL3RTTdg4/LBOU8XrPScroBfEKjQdjvzqqFki6zJ+2pcFJ1XqEUImuVtQ1dGHe+ITRYw
	Ks7hDdHVS7JQ4YA6x2h4l5nTmi3oejnHUtTjbYy+0AXSxRf42M4dsfXoE5YoqlssWKlD+q
	kRsbcrkhHULTD6JW+tsH8mh8WYPq0yw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZKo+9Obd;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiG9nHcsxcwZpHb/L0Tx41DaV7imD29tLb/ai1sU578=;
	b=GWYcuX667i82dEA/pVZQYcei+BEhQRnre5CbWgY/ruPLsMQ9fgjWCNl0oypRl2JOtTHas6
	/onlr0zNqFud+CNKjyLqoK167m0Twc0RwAhCUYtEeWtV1hTRYv4Dpmh6GOM+a5TiGRWM/I
	2Tb1pstbkW23lvoVI964h6zKrNHJJ2A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JiG9nHcsxcwZpHb/L0Tx41DaV7imD29tLb/ai1sU578=; b=ZKo+9ObdivkDNkysiYahzyuuss
	V9yrjHh7tmjMIizFvtgrzU1ew9DKv2ijMXyq/m+VY6kJr1ok4yabwOPGzxZgNPqo1qdCwZH+GGCA9
	Xtf/YL51cWReDV2QQXM8zEYytJDNiC9btkCVTAfz/42rcVTuGMFe7UWcDLIpuix5YDrac++QHzoXz
	6v2zGdAVaUgb36aZ1KMpkw4J2jiHmlaq73tuwK2Le9V93bz2apa3mx7aNKqaPIoaPriRmBF0oazpX
	A4BKfQIDaZjshqkFVaASv2u9+Euguf7X+3JH3/CMgPPVV+/JuZY+mNYWB3ETE4qgxS7s+2dJxIEyv
	jDie91pw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GER4-2rTm;
	Tue, 18 Nov 2025 05:16:06 +0000
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
Subject: [PATCH v4 14/54] convert mqueue
Date: Tue, 18 Nov 2025 05:15:23 +0000
Message-ID: <20251118051604.3868588-15-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0344A180009
X-Stat-Signature: 8einm4pmm8k5cmg3osk53nm7p15jytno
X-Rspam-User: 
X-HE-Tag: 1763442973-925014
X-HE-Meta: U2FsdGVkX19XZHRklINggYOjXLTeoH0vpRFjUmRT8ENeyfJe1/HLg2aHbuTSNX55nPWtzgQzhaLRkeVfXPUL5EMFONrXhtHrGOaKosU3WR2nB3rnXLAFp8oGqZ3C7ELqjjAKspxU5lIJWna8d07bGsh06DIJ5p0ojSvThONbKPkYlO5KCCo3Cx4N3LY7T3+GdPE07YwWi4pfuivZ3Z75DlcPNLx65NjpJvORjvOp9lPyw5vpKrUUXMircYRSYQrhRgxvnJbnDOl4W1BlVtTZtrw4mDVZfWXvn5IAwvre6PfkcfHTofDL/x+vKiS/47QvkcmMv2Y1Qa3Ia+4cNfIIUOk+E49bNgKrRjjHqHr0mxIX4muLY5sGxWraimgulwXz3iGDPWIkkA4N3eLfdqATS5l2rRp2lnIetrpYBNXQUEXIeTgQB310hk+MnsMHsMOcq0AT0FeMUCj+xpaU8JTKJBpyhozsJn3WpNXw1q8SyWZoyeb0SYzoZWd5Epe9b2A23uwRo6adJiwaaqm/3iw2FHl+6+PzSCH4tEXnFuzVtpW0D8gTEE/Yn2vbb7SCbDxqIMRsPpl0N653LgBSOwF+X+C6aPHelh2FgDMgI8hwhkQ+4krvnbheHbuH6Xoh0UMMgaoxw/64Cbj9Wo0aQlIAJX2VYJFMgMSfVAUmiLT0FpiZTEGlLmQB2H4u2aeC7rh1GGujCrZ32YMyIWXGc/XNnkRbA1ir0DVKb0dGyG4tFHNrA5vCM/p4dHKIedeB4Pp1mOpAElELRlPJ6hRP54L9AR+F0CHJuVqobLGrZsVUariyD7aOjw/DFBF2Ydz0xM5MYrEg5zL7Athz8WcklQeUQ7eOSt07Ble2Zb0gZnuSZqw/7YZ8wYHL2ywvARq7hTBjsk5FNZal8wAH3hUeQVB+Znot9fDAJeWUAsUclXxPP8IU6A8RZtV9zcLhAfj+vTs5Ehm1w8f5tJcF6ZOBDgS
 7Vv3Wkb2
 7zruTFoMTUlb7Gf4mbsY4IVvhr7+TNb/TDW/AR4FxU+u3eFzL4meJYs5l1rZuTb4Bi1k/p5idzDdgv6loNq0rqHnGpy+YnQv3H4mlN4Sl4hOwm7Gqjx8EyQqIyNICNcGnoJgy6gZFx1f3BHF7wmsWtYArDz71MvpEiDWNgsFRIXjGYyFRoKH5VvqmkIuhy6z4B5DebLvj51SkEJKRz7AcE3liU8aRggfYCkq+siITTUm1lrf/znSbTNqjunAVqxgL0vV4RzGygF+pjfi5biBrbnud7YjI7iUNVcZ1w4QD9x25Xv97eVl40HRWp6n82k74fl6roT6jCWGfgw13UB+2Q9sN0+C6yE586UhiDL7EmfpHNp2U7JaZK7CLFCGLTdzRpkFUa8jE+P2ZIRemqOXZ8HX5FcNlfz1n1w+a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All modifications via normal VFS codepaths; just take care of making
persistent in in mqueue_create_attr() and discardable in mqueue_unlink()
and it doesn't need kill_litter_super() at all.

mqueue_unlink() side is best handled by having it call simple_unlink()
rather than duplicating its guts...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 ipc/mqueue.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 093551fe66a7..5737130137bf 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -599,8 +599,7 @@ static int mqueue_create_attr(struct dentry *dentry, umode_t mode, void *arg)
 	dir->i_size += DIRENT_SIZE;
 	simple_inode_init_ts(dir);
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	return 0;
 out_unlock:
 	spin_unlock(&mq_lock);
@@ -617,13 +616,8 @@ static int mqueue_create(struct mnt_idmap *idmap, struct inode *dir,
 
 static int mqueue_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct inode *inode = d_inode(dentry);
-
-	simple_inode_init_ts(dir);
 	dir->i_size -= DIRENT_SIZE;
-	drop_nlink(inode);
-	dput(dentry);
-	return 0;
+	return simple_unlink(dir, dentry);
 }
 
 /*
@@ -1638,7 +1632,7 @@ static const struct fs_context_operations mqueue_fs_context_ops = {
 static struct file_system_type mqueue_fs_type = {
 	.name			= "mqueue",
 	.init_fs_context	= mqueue_init_fs_context,
-	.kill_sb		= kill_litter_super,
+	.kill_sb		= kill_anon_super,
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
-- 
2.47.3


