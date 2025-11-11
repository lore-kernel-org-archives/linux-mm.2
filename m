Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDB8CD1297
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CC78E0028; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CBC8E002F; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F548E002F; Tue, 11 Nov 2025 01:55:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0D6F8E002C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFCE5B9730
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:38 +0000 (UTC)
X-FDA: 84097415556.01.869AC07
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A80CC0011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="hgd1T/hR";
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844137;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QE5WDCT/6E4/9SENMzbAx4/TtK/VNDZoQCVo0AmPFA=;
	b=pA+O73ktb3pi3sOSduDYpDQGiAj85AsjtjWenveFvbSTqzCR3QshZ7YUNDNMRJfeR81Zvi
	Yw01vYBKvO5+apD/rl4oe5z95iS0zYh7I8e3sQJAFh8K07oHnggqsTh2yFace0iX2DN6Nt
	fv2BvT6ivYcf8m3ck7/VZtJPbaiFoHA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844137; a=rsa-sha256;
	cv=none;
	b=JeeNhObF0YY1SJPjcztRe1csBQ3srvbInsJgIPN0ej3ZAnSovfTSJ42YBpg1fJv5sE5z1b
	PricTRiOPZtnJ4HVt3kEbivitV1vpmHgCndyhmXd0QxuSXkL6XoSkbZ/AO3h2eXeWSk4/+
	7XOvgN3vBk895pFiGc1SfHzp+XBCFSU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="hgd1T/hR";
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/QE5WDCT/6E4/9SENMzbAx4/TtK/VNDZoQCVo0AmPFA=; b=hgd1T/hR7hFzvqa4/FhQi64LUF
	DpGBGzt8FSozWK1vHT1CSAIxtkOUMD9lfA+Yg5jssmzeqp36q2yrCN1/ha/2TSHNgQG0WInh76BP3
	S+rZAUnPIolPPEO6FsPoyNn3RAH6ashTBW/05hTa2+Gf9ltR3CmC8s3eEAvGIOLEzKZj8ctY0MWWd
	QcP46qJ8955VSBOzIya9NtrbLAAv7jtnZPWHr1LfNQ6KwEohpuZdrws6OkrXvoNH5ypk/dY4ZvEtL
	t26DMKkl5jl6E+GclnSqGx58FWqgLhyI4nW3pOThpZWg0niou86/LHLxzvZcrzqxg9WNlmOEQl9PK
	HXAt9dmA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHt-0000000BxNT-1JUi;
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
Subject: [PATCH v3 48/50] convert securityfs
Date: Tue, 11 Nov 2025 06:55:17 +0000
Message-ID: <20251111065520.2847791-49-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A80CC0011
X-Stat-Signature: rigoxiw3kuk8a57hoy1uiuadu5ysc9sc
X-Rspam-User: 
X-HE-Tag: 1762844137-918294
X-HE-Meta: U2FsdGVkX19RUADnrbLVluEY4H/ky7fQaPkE/BHaEBuO315X3dfglGJtpi22vyqHie2kj7welmRmN0MubdvwsSbtMYEEIYy4whG20+DnsUBmH09hl1BFdubs2R/F/16Oi82MXNKGd0XRHBaHuFQbMK9cc+fdYeB5yRfNrSKcq7NgBIMGshpyuLxjZDvo5mXHe87ZNaVIKRgL0cWU4o2WBlBVx/XQ0IHvtfAKtcNVyn+CngCknhxTRupUS7aRMQ5HfqqKgMGJe/9eEEVmc4gmzITH0sVc9DMLn2Bq+gOWMjICQR4zpfJxPMA+d3ozgpdAsJ2AIlyXqH1R5aAuarOag4edeTSVWw9J3w0ZEGckAhoxm/RQUCnoks8tMdgQeLpVoXaxuz2veX8tAqz+QUKArtQhzR8Zf+niFTUVD2/8YgrDkEzpwTae3QzjKnI98406ta93zpWclXy4mTQHVXLSJ/I8Y+Fu/X5o4r2oIwdKgJFug/beozJsvsfhCXaas+1FxcNsQP/pzCpFa/4ZZ+5M97Ja9lBjFaTk9/B2sVW2XLs68en6gO/PtnAbkiIyE3zJLqmXp3OZBrBQcMO4R/8SUTn9RUWPblyb+YNJ4zY9sKPmY8hT/Tr3Q3/NiqCsgd+iykEY+AhzjKbK6ccV/buVf53Dq/fQqGkPB3mHcM0csHZNEsD1WVzQkxznzxWskubKLBCMYMqhBEP/mFQG4G3//0AbpKzsK84Zl7XEOSOQLaX4uHHYJKhuVVNJoEysLgV3i0vpreOcPQ19pcs0XKgzw9Ci/tx4K+f+6C4nj/wB1xoWVslNJlxcDrW94/0QugZsusl8ch71OiUIPbtEpemWOrjEP18NLNmZA2chf9DSZDV3ZnnOFHbnh8oV4RXe/VbxgvEZ2PtNMNedsCXvx/2J5tcqPxigFPT0shJhrL0crG4j3ODuH6v1CBAo/NRxVN1Dd+1BdDqUdfMGHa2fckm
 HLnkHeai
 v4a210c+ja3cNzImjzB/r4F1WGgUz/812TAT3xJpwQ7w1pMXQ+I0SUAartCnQKG5HzqDKLB0JMx9EC4drhVEsXK5TWXRXeAZ92ndsbP7twFxS0/4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

securityfs uses simple_recursive_removal(), but does not bother to mark
dentries persistent.  This is the only place where it still happens; get
rid of that irregularity.

* use simple_{start,done}_creating() and d_make_persitent(); kill_litter_super()
use was already gone, since we empty the filesystem instance before it gets
shut down.

Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/inode.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index bf7b5e2e6955..73df5db7f831 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -127,24 +127,19 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 		parent = mount->mnt_root;
 	}
 
-	dir = d_inode(parent);
-
-	inode_lock(dir);
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry))
+	inode = new_inode(parent->d_sb);
+	if (unlikely(!inode)) {
+		dentry = ERR_PTR(-ENOMEM);
 		goto out;
-
-	if (d_really_is_positive(dentry)) {
-		error = -EEXIST;
-		goto out1;
 	}
 
-	inode = new_inode(dir->i_sb);
-	if (!inode) {
-		error = -ENOMEM;
-		goto out1;
-	}
+	dir = d_inode(parent);
 
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry)) {
+		iput(inode);
+		goto out;
+	}
 	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	simple_inode_init_ts(inode);
@@ -160,15 +155,11 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 	} else {
 		inode->i_fop = fops;
 	}
-	d_instantiate(dentry, inode);
-	inode_unlock(dir);
-	return dentry;
+	d_make_persistent(dentry, inode);
+	simple_done_creating(dentry);
+	return dentry; // borrowed
 
-out1:
-	dput(dentry);
-	dentry = ERR_PTR(error);
 out:
-	inode_unlock(dir);
 	if (pinned)
 		simple_release_fs(&mount, &mount_count);
 	return dentry;
-- 
2.47.3


