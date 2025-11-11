Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3556ECCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85C658E0007; Tue, 11 Nov 2025 02:41:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834508E0002; Tue, 11 Nov 2025 02:41:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7714F8E0007; Tue, 11 Nov 2025 02:41:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 678E68E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:41:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BFB914046D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:41:37 +0000 (UTC)
X-FDA: 84097531434.05.B62A5CA
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78D9E120004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:41:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="tc0/LaWO";
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762846895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0EOMkT/UFsYLOkQCFILn7xjwHlMa0Zq2h7YoVPTnFkU=;
	b=fcP1wtfkfXEXYisOUAkKu8/raYjZA9P8I2JlkBXBg6oKv+qMz7u7AstuxF9y+OQRzhS6gm
	GFBY/O7nhYHKoUuvTmZRelHNSZilXebBg6zMR7GzU93X9WHjknjp/DqWIDMA56HBPGJYWC
	MTQFOap41fpa/mUXtP42I4ImxyWIgRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762846895; a=rsa-sha256;
	cv=none;
	b=GrtzvbaYfrSCvc5bEBg1oQSZp17YJr0q6D6MZJ/2ZUvL6tfSH5MzPWQcM6/BgETLncePTe
	ERTNZ7aENrtUW3uCUIt8jz1YM1GSFtDS/JO4tsdjcHJanqOA1nQHzqedT8oOw+Z2tJyBCS
	XuqG7WfZ/w087KJC1GeTN7SlxphBW8w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="tc0/LaWO";
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0EOMkT/UFsYLOkQCFILn7xjwHlMa0Zq2h7YoVPTnFkU=; b=tc0/LaWOOgbMQ111+igu49CS2g
	phQ+Ub498iuMr20TnISzkpSlI5Rh9m3XDKIHm7ttVNJWMNodhJrqScO1UChifsgTI0vp9a+TC0zQ6
	wgIoJMLc1ZxBeW43ROXp06EFElt8QvwpbW5Lm+4FTnxcW0IJWyS8W4g9QDdJpt4Ef4wpnI+3bZwTD
	/FrUz0/B80hWcmSL60mE+RJDBRevzP6gYz6fARP+/akZPB5L0nOP9JBP0eptP6MQFkY9iVmWnn0uy
	48PTVG93EJ3fivCiWdovYzsAT+/N8eSgVEHVRP0vkxJajSkYrBjMF90xFvWKrIH4uI8kq34s1Uk3/
	2di164SQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHm-0000000Bx00-0jJ1;
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
Subject: [PATCH v3 30/50] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry == dentry there
Date: Tue, 11 Nov 2025 06:54:59 +0000
Message-ID: <20251111065520.2847791-31-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 78D9E120004
X-Stat-Signature: xsznxrfwb85oykdywogracf8oqwjhudp
X-Rspam-User: 
X-HE-Tag: 1762846895-927583
X-HE-Meta: U2FsdGVkX19M1x3Du8X3LNqi5qpuSgWicWrBotwQHgRZbGtBNePMy94f/ZCCJdAuQrov7qOHIuhUUu0EosB0COzAszqUsbZhf2TGMCIaEynU5AXrB7KHC40AlFEDp+qSqDahopKyjd8iamqKsCQ21rUbaXX0zFSPlRAGB+P/n4RL91R4Xi47gy/KTR/Hbo5/XIuiixTi+QrSgRAXfKEJE6lPW3WvPW7kIT7gaOuyVhFZjjI22vsRHh0pQDa2fUvH4essDkYwn0r7rUPsRGvpb7060w/qo0Q2I25FwBBRxGp4wPZNLGlT4qchGz3Wx793E0OKlKloHabux3yNLs1ttlAwUlEwSKKR6gElXGjRg2zsYXtlLoNYi3oJ6OphYQw5O/if2FEl10VAVKlURcuZXZM7ZhAFrVdswQiDFoRs+mVgePuqw5s0mIo6ZqdFylIBvHcCZNPaMwQ5H4Gj+PhmQOWT5ADpxJYl7e9QEyDsXNxPubkByg4Wvfgf0Mwsp+Vfcw0U1ALwGE6BXc/P8694adcobnpXA/B0iaMK5QhA9+p2t+/zV0thA3GRJ7HdLug3jG38Mjtv6W/++BEmr0zcKLCkqXLmbPLzm8+IUY8XRMKviW5g0F6twDuefKk0d3/zsX+Pep61yweqzXOBjBiAot9nQJrstWWOMQjTpwry+kOPZq9YJr6aQfKtIFuwqkQtn/a1/OttDBH7AOuKmDpX3IwLR0g5YZQPJ7qInQLYtlFfPT7eEWeNiaMR5/wSvEXZ6Fwf2mRtA8pdYATQlFT+GpXh/yUszcVqs8sxlrCbtJOmK7Ya5XvvDjqDxZgBQ6N1Ta/BaCZc2Ia4QvahPPEv21+E1ou8YxZfTTaP1dFGeAUGElJxqGOwwUegQsigYcrsYQj78YOCIEzGPuW/G9JRStIE+ewOckNePk2vJ9cCWUPuYvM83uOJdiGLn3LjhlCDirAc12DINlaIkI04C1W
 rjSz8nM8
 iSUBfqaTjs5EWPiUdunruDntHmE33l04H+BfR9Oy9Ne2peys3Fcw01xwbJbhtweOaJJJi25Bn+8PzP5jMRhJzI8v3xgMuqvf1bOAm0MANm1a0mw4rnlUEZQeOGAfnpVkGXnNmBo3jhqaPV2cxufcMJyypxCc/frSXE5yprpcfhOVd3aAhWkwVMDR7pQD3SpyH4XmInV8V+dFwKP2YtnAPEmRK5vJLQzx43lo0R+xaKzz39yMfik2xPwDTLoFCUmXjlzgtWCUe5tNRvD4h6TEEpOvBVp/Tjc1xUf4rNOLYl/sIFOk8Iz+Ze4wEVwOxQaxFtnsLSvUj1nv8AG6/ape6n5aD7ptw9wPgid3FXwfkanoVrq7vTHxA7TGMxmo+gtzelhvkNmBul0OaJhZreL5QU5BGQoJ0aJf4MIY5NR+bdQn/o4DmJ+6ybpMcgwm02lfwnq10N/h3kuD+7LGeRiyPVjfgz8lEgFSkC/1SwyyM/J8r5wwm+T4gct0brg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/autofs/root.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 174c7205fee4..39794633d484 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -623,12 +623,11 @@ static int autofs_dir_symlink(struct mnt_idmap *idmap,
 static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(ino->dentry);
+	dput(dentry);
 
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
@@ -710,7 +709,7 @@ static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(ino->dentry);
+	dput(dentry);
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
 
-- 
2.47.3


