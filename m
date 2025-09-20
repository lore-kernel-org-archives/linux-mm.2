Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB1FCAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16F1A8E0014; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B786D8E0019; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41738E0010; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA5D8E0014
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 037C8878EC
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
X-FDA: 83908850298.02.06491EB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53BA4C0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=h1PYM7wF;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354487;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxn4MG/UuDcxk84tNsHI6sa3Q9kQYypoP2eBG9UjNw0=;
	b=YIBh+vgcBAyd8XCoaboroX9xTxZ3OfQnJvknzgO5z9a11iQbJP22miizDYNWuOImFMUdVG
	zBEhis1frkSGl/hRrdfBkZHOx/x7g61EwNv86M5Q4J4obXnYeOwKkb/48lenciTTIJ/yzC
	sLDdeww1Sw3MNf7ofMN1d20i6dKWJXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354487; a=rsa-sha256;
	cv=none;
	b=hGVuuXLEXVb9cSsNLvl4WGR2Qhk5XOTh9JeFmJgJqSD30yeDkrO8RxoC0cJ9I/b5cpnpml
	0XfsoSzBQt/ejBjpqG09jzj2/J6DHZscTC9BGGLFHPcJZ35qvp8Emc1kn7KVajouykWij1
	UznFmIeZiTqNCwoeatT3aFxMOkdOjbs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=h1PYM7wF;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wxn4MG/UuDcxk84tNsHI6sa3Q9kQYypoP2eBG9UjNw0=; b=h1PYM7wF8GAZQmFHnTVD3Eal5G
	3sfQyHpwrCnfb8nq8dYDmp7db1lsQsiW0zGzVQqf1H2/iK9U857ZYv0k6fJaskP3ZAh/lIXWQAQRm
	0Eqw7E+Y1UY+lxLUe8EHmLK3j1RaYCGVO4yoX4JPLStirWyDq8N85LAX/8T5rTBj5an57+vcyFlg0
	jhPbS9IcCglfgZAOoJAftuvBRe1W2kHTcTm36SQ6aSvBSUTow/nSc5uRWjdqUDbEvGwWlobmtwXN3
	YXuF5pGdUjk0SF4X9GcEAKh9hwMi1J0h77z7/c5seKNFmRikgDkUnShQND1x2e3QtbH6HF1a4IAhh
	UlLYEIwA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKB-0000000ExFi-2BZc;
	Sat, 20 Sep 2025 07:48:03 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 21/39] convert spufs
Date: Sat, 20 Sep 2025 08:47:40 +0100
Message-ID: <20250920074759.3564072-21-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ncj4izk9i9o11izi7c3bb7jqe5ctxyc
X-Rspamd-Queue-Id: 53BA4C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758354487-840050
X-HE-Meta: U2FsdGVkX19dx3u+JmtRHOxfD5zZSbonj9/kC/lmA73JEffg+R/mOVl2bXX4VnLtNrUH5YtXIbi2Le86Dm3TVg1MlzwYVzfQci6kVUJi5qpZo/9w51PAszZ38SHa4IMLv2w6UCx2xdw/alu1MjTi3NZ8BHPCdiXWNqs3OqshJ3KAXtr5H7Gmd5hsHgxaYm45S85Igg5b25+Uqhn5znGBe7cFk0vas6EZ76gwlk/6OmMC6ti/zb9Ygg1ezjA0f+ot79jKv/LapDlG0vTC7p4Nt+TAKeLZVa0H2xCfbV0xy/51airBaRfc5FizdwTuXTw8ueuUSt2Wb5AwXllMIzAf+GujZDqb9NeVAF0J7ZlKld8FY1GdklXwazj4ieZhtX7ydC+kJe22zp9dy+xuEXM8y/Jq3Y6y6tOySpAKtX3SXFHrF8vMTO6ietL4TJREBd6v1IUntCNmgW1ZcajO5DRFjcKIRW6/2kQthoCN+Wmih1HhIXW1rXQ8yY6k+25b+KlgIsjOAcgnEZYucUYoSibhHj2Ag2hEivyaReNZrocmB0w9nG2/8uFFtptDqGOilo7OwKHHeZdkp/SRQE210ahd+VJoHrTLNy/eY9WgkURMGXgzzAKSLhwWfxbRhLO4U8blHRT4FcGzEiipcX5thPfqFXz6DkLkRoogkF76rTme6490I1PaBTt23OC2Fb1hp2hM82cFwyLN/OLMPlNIlNvuJhlm4e3XzxjvdVpUzwgYfiS5ewGoBfAmTroQsa3g3wyNJkSn3sOsuto+rytQoBnBQc25VE+0yDdEVqxeNvhv4Hm1LML9fdL6hvh06ooYnBuUUWH+RHhjRwbAk5OSmh5VqIMijmdh56014gVcANqxJ9+Owr2oRUbdHkRs0YMxe8+MHRYbuEfLhp5g9uVc9JisYLjtDit6hf1By6AoG/Vp5IO4COr/DfaiEOcHD/0O/DxdjUFrFDFl2zr9cYLgBTX
 sPvhPP1m
 s3ZpNSUvrA/V6O6l4qy78Yv0zDUZPs1a0PJ47xWcw6wArE9z2iPk6ZD37Hi/BLCNcJvBx51FYFRpwvnGsFklKOyGLudnNBGOr8lKeP0uj/PyAuzV65B4hTdMNA2g4d8wLU1KM7oXdzhSmwENRiPkEY5hqsBIHrZU5GRX6wAhJlMlw4o06bQRlF4nNXedelfCe2XlRHpVSshnBUNyzO8dLnW1MFkECRdKr0ocBv2XdnveXrMdYOy1+4w+3rJy5URktSKhdgTN7xIXGEUWGUMXrpI++7s+3PAw7BfThtOlAfudZZrH2vwTTtzh6sr/r38OFSRqQg6o9Q+ds2GuIvzisXsz9ukKlVtkUzqPRqQUUNcldsS+GUOw7lgO0c7w5z3QrZvGiwbffqJl59fexJ/gmL0fVAGxJnKV/bWxx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

have spufs_new_file() use d_make_persistent() instead of d_add() and
do an uncondition dput() in the caller; the rest is completely
straightforward.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 7ec60290abe6..f21f7a76ef0b 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -127,7 +127,7 @@ spufs_new_file(struct super_block *sb, struct dentry *dentry,
 	inode->i_fop = fops;
 	inode->i_size = size;
 	inode->i_private = SPUFS_I(inode)->i_ctx = get_spu_context(ctx);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 out:
 	return ret;
 }
@@ -163,10 +163,9 @@ static int spufs_fill_dir(struct dentry *dir,
 			return -ENOMEM;
 		ret = spufs_new_file(dir->d_sb, dentry, files->ops,
 					files->mode & mode, files->size, ctx);
-		if (ret) {
-			dput(dentry);
+		dput(dentry);
+		if (ret)
 			return ret;
-		}
 		files++;
 	}
 	return 0;
@@ -241,11 +240,10 @@ spufs_mkdir(struct inode *dir, struct dentry *dentry, unsigned int flags,
 
 	inode_lock(inode);
 
-	dget(dentry);
 	inc_nlink(dir);
 	inc_nlink(inode);
 
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 
 	if (flags & SPU_CREATE_NOSCHED)
 		ret = spufs_fill_dir(dentry, spufs_dir_nosched_contents,
@@ -479,10 +477,9 @@ spufs_mkgang(struct inode *dir, struct dentry *dentry, umode_t mode)
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
 	inc_nlink(dir);
 	inc_nlink(d_inode(dentry));
+	d_make_persistent(dentry, inode);
 	return ret;
 
 out_iput:
@@ -780,7 +777,7 @@ static struct file_system_type spufs_type = {
 	.name = "spufs",
 	.init_fs_context = spufs_init_fs_context,
 	.parameters	= spufs_fs_parameters,
-	.kill_sb = kill_litter_super,
+	.kill_sb = kill_anon_super,
 };
 MODULE_ALIAS_FS("spufs");
 
-- 
2.47.3


