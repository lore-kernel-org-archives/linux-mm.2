Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 291A4CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98158E002A; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAC18E0021; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAA58E002B; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6FB8E0028
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FB2F58EDF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:36 +0000 (UTC)
X-FDA: 84097415472.02.3EF1DF3
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id B83D61C0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ELoJMPPp;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844134;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sU0Rwyb1f70hxWqGLaDrX9gfHmhzhxjXEuqfS3xyBnk=;
	b=bkTQ0q9+XkOjLntLMUBtPH1XrEy5Fy/tJEctA/y2gZVZ03O7sC9bg9HYkp8j0hoGMeSYIl
	9vxysCNoRObYIb02e39FQ2zW0Qzil4V+RMkgK+qx7MmphqxzZNpEogAEzZ/9gW6BvrcEsl
	4CT1PEDzPlDuHls4miCilss86bsDltk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844134; a=rsa-sha256;
	cv=none;
	b=NgN3nYEutvdSHEZhGrISQxN1FfycceaylIA3Oo1cejOQoicXrNGiBwU+FuYiUEgls7qNgM
	4j8lRLmRO/G8x5uXRIZHKNIXfZiX9U5NvVKu5FxmGeQzJRRUnj3TLoc8oPASz/dNWQlwZu
	nkuCIAw2N1SNyBRb3l55XtVR8SKwXoI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ELoJMPPp;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sU0Rwyb1f70hxWqGLaDrX9gfHmhzhxjXEuqfS3xyBnk=; b=ELoJMPPpp0RfTLnDX6xsMZs0A+
	kTdsC4LcVi2QtgIkzPaEUU262+vbuyredIqr924NLjnE3vbpYyu4H0UiNn1inw1q1h65TZcyPQWOC
	N6C4kHzsz00rAJNHx5NnqAknPASR8POOss9PAaaS6CsdKDaE0FNBiGfXEJerM7AfzqAAW+8dCs5rs
	c3bMG7dOe2GM6A5Jy+8FqyD42G/CdZ7KtCoH6yO6yEDngTSX6rWPvyYfuDLjGCnoWHHz1tMr8YMky
	LdiyFUtb4LuJjFmwmndVlzgqap6D2+T/ImMFwJ5qyfA0pOz2TL/GaMMh/Ivw6rkahhsmiEIZsfiRq
	Cw/0btZg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHq-0000000BxFT-2h81;
	Tue, 11 Nov 2025 06:55:30 +0000
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
Subject: [PATCH v3 43/50] convert hypfs
Date: Tue, 11 Nov 2025 06:55:12 +0000
Message-ID: <20251111065520.2847791-44-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B83D61C0005
X-Stat-Signature: c3fu81q3bdwenz6scuo36rpkzn8ypuke
X-Rspam-User: 
X-HE-Tag: 1762844134-957767
X-HE-Meta: U2FsdGVkX1/1wVqWxAEXB4jY5YPgfstqvOHSXlEb+elYKw1Rhmqw+/53shMLKli55tLLlzOzXs1d710CDv/bs5qcku9aA+Q8213A6wx1fLLshy6wWY2DdhqeIE35p8rQVQvE/mzPC9QEx4AymkEhA49umK3IXn3fGOi2OXvDDhIrA2OIfu4tR3MZrOWKCG4x4g45X2tiUYfzzoB+6rhoWvjs7ePy8T/w8Nn4cbAOVHNklY40N/seM/vfLvZMkDC1fUQUcX3aEtrJ+wmohorsyaJ5nANFeO6Mew7Fh+yJYPE/8yhT2WJmP/y2MONGcf/9il8OuEOEoG6w0z8fhKz/zaXAcQCr0liZg1MyaLSYIXTOK4efl4sA3h0725JSujudtEnKmPAgru6vZwziPtB6nqsSpReND4U5NSUew5T73I646d2vA2MUVYDyWRwkhaFkmp4pRRwMnbRIMtn7JDia+djDCuIYm8vetgB5jp/dyagz3YcoLpvsgt1HzfBaAliWO8IS/j78Vbn2dEfsf7VVXYVaQwPJjBLg2elOaaTFZgLLpBEfP89QSKMM8LvjZKwsTQ7Pj322mJV93Ifg/zzNRNzGr+PriLxDydVYCnpX/N75iFA7WIYzdBGlqJhRLGuMQl+uSAzgAHFL+BqgMgOsmo0r4jy0Rz5Qs4KKP097C1qBX81hDn8uOfaiITKZ1y9uDFYXsv6QwG6vIWap8tvAHY5xDOmfXhuBS5XNN/AoAPiQpLc9jkdT0Vf/QPdD9TIi249XlUfnNXlq+bsI/Vc5ZovodRIGARDD7hTDucehULXJFgAnFr3J6yZQhfdSAaeCpwWFwZF5eGGdedYkstMIjsMh1sZ4qETd2WtU1FyipTEx7K0OKKpJzPJLPT4tc4YVWnHFBkNXgUcRCumIOwgrejv+Z6lvEHH8Sqqf1dkjP/E58a98YyhxtCQB1Jhb0THqcBBdm4WV2kWWi/GWiKr
 gwFlkfZu
 M+AxDQdP2BUqaQ+GFpl+crltXWLUEyigGkB8PxUu/d7cMa/2LBbrAr3QhIFXc0h4DMAqJrJO9IyJTbWkxY6yFy/q9+5cECDodrdEMPr6UjxSqhdw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

just have hypfs_create_file() do the usual simple_start_creating()/
d_make_persistent()/simple_done_creating() and that's it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/hypfs/inode.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 6a80ab2692be..98952543d593 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -311,7 +311,7 @@ static void hypfs_kill_super(struct super_block *sb)
 	struct hypfs_sb_info *sb_info = sb->s_fs_info;
 
 	hypfs_last_dentry = NULL;
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	kfree(sb_info);
 }
 
@@ -321,17 +321,13 @@ static struct dentry *hypfs_create_file(struct dentry *parent, const char *name,
 	struct dentry *dentry;
 	struct inode *inode;
 
-	inode_lock(d_inode(parent));
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry)) {
-		dentry = ERR_PTR(-ENOMEM);
-		goto fail;
-	}
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry))
+		return ERR_PTR(-ENOMEM);
 	inode = hypfs_make_inode(parent->d_sb, mode);
 	if (!inode) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOMEM);
-		goto fail;
+		simple_done_creating(dentry);
+		return ERR_PTR(-ENOMEM);
 	}
 	if (S_ISREG(mode)) {
 		inode->i_fop = &hypfs_file_ops;
@@ -346,10 +342,9 @@ static struct dentry *hypfs_create_file(struct dentry *parent, const char *name,
 	} else
 		BUG();
 	inode->i_private = data;
-	d_instantiate(dentry, inode);
-fail:
-	inode_unlock(d_inode(parent));
-	return dentry;
+	d_make_persistent(dentry, inode);
+	simple_done_creating(dentry);
+	return dentry;	 // borrowed
 }
 
 struct dentry *hypfs_mkdir(struct dentry *parent, const char *name)
-- 
2.47.3


