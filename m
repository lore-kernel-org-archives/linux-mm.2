Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99DEECED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A13D8E000A; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8A98E003B; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208808E0025; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B61F8E0031
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DED4988BBB
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.14.D5B9BD5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1E96240012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=U4N6FHfz;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ6yrPf10XyjUbpb0uoz9zDvZV76d0sxqTJxoq2o+VY=;
	b=iydRq97MHBJIlKQeQrxgwR/6a75wHV3bCf5thy8TZeggP1nkOufFcovendBu6A3ofosM+y
	ktfo54CixyClT18tVgKC7yThe2g+bQFFw+2l0oE/Bx60YkH0fLlYI9L2wdiYiUTjnaGTrJ
	v75DKYgaDrGJAcLncq5+iNrWsk1P7bY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=U4N6FHfz;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=bzzepNdWyNkC67zgI6092owp51S+n+IrB6G9kATtllqbClsliuN8Zf5VukM9kYcGw26bKw
	fyFOjo3eSBzUTHqo+kBH3VyOxzW9XONH5ANGmkvZ89b0nC33FaMPIK6Kf/iz2KJR9Ce5X+
	YL8fJoC92mNbjd2L8WHal5LOV1VX/ZI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LZ6yrPf10XyjUbpb0uoz9zDvZV76d0sxqTJxoq2o+VY=; b=U4N6FHfzCrbb4azFmBn86hOncH
	so26EVVboKgDcIHc4NlNjYEgmAeLAcFqHHn/t/vo56xyfRQsxhg1YHRnMAAWaVNY2xD35h5jYh8k5
	yCfUGsKDh/bPgSRBJXsOPWFNagA+bppgRLXsGQ/yTJUOkhKA9V2WvyOxQRt+60nOdr3l//WnP1r3k
	6JXxdBHmyFKBis+FJb/2i7FGpynpeU4Gb/PvvgXdXoPlGD37K66yHbbJ8CLTqK63mNFUqFZZh24mm
	M+JqNVYMtGvdE7EL+ByCK96+52rNllm1LMZUcqbTbJMLt12x0is3C4q7BhBXF4em/I4Ucp3/jxwyy
	Pl/2JT3g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GERh-1RuG;
	Tue, 18 Nov 2025 05:16:07 +0000
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
Subject: [PATCH v4 21/54] debugfs: remove duplicate checks in callers of start_creating()
Date: Tue, 18 Nov 2025 05:15:30 +0000
Message-ID: <20251118051604.3868588-22-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E96240012
X-Stat-Signature: d1mdonqgpr9gtoujkmxz5uhyu1z8i9s9
X-Rspam-User: 
X-HE-Tag: 1763442973-100503
X-HE-Meta: U2FsdGVkX1/Kvg2ZkjmLMUnvNKogmMRMh93uMX1+/8v0dZ3KxPJQYt7+NeocXPrKMFHxo6Ea1+lphGABGjdZfaE6KLRWZ5yd8ewkgIpqtQMT0r17bSf5bH/oXZQX8J3eNbniJqB3DzKXspAj69KN+deLoKmH0tkX9YRQxEl4wc3N7pKKfFcQ7BN7MO1JxxdADshs4StzqUUtPohBjh2oxV5qifWHgmHKGvIBAdsFTiBUp3S4etScrt4vTEyilJwPB/LZozVxo07P9Q7Dsmm1V8omRZ+H51ZDlRWWN5nXt0uNbT8KZAQH4Q5+29I3Ue3VxHmza8JG4Ft7mxB4uELSUG9wrWTWde2b1vMAe2tpaqw83pBecIEqJuKlw2Q341SVXdb7rpv8KLzgDWAoAaRTNOojT0+jSwqz+yg3yfU4Kv8X+B3XsHVOA5eWtQIfMuBS8HJ844v3qmDUQPJ2Ihxb4fTAtSI2cz+dJDGI2gneTng863ySAihiUiGBscstt8IRZIomFus85BPmuBQtk/Vls5gVcvecKxLjszV5Uel/o+Fczd+AWIqwVFqsOy1AVSpmgB9Q5VFesGx4BeOR4QY0iO3BnhmDrVoYVbAcpdF9pv/3VZRJtnyjoavhrOIuq8FPG4mEuRpgE92od+4cgUwW02TIwEHH9yyYNcpeQ4AGHUQlXgf411ynIeFRas1n1L6W8OnIlxS9yPMnj1KvAjUypji7CNmzOzE7dyDEZCpj2TwzhVGNsuTwkHFc/RmsyTfE3OIg1KcW24HXlNSUnZSmslkM/64zQGhGltIc8EhQ2kdlbkAsBoKSC1CZLNBoc+OF9gucXG97Dbmgp/SF4V+aMxu+KzLjgpaGF/5rYZfPDH770o9mrtVvls25Gh+EdYNQIIASmWTf3TGx7ZO1WHaCTMHBkLl+vF0G5qHxw/+PTWhqDp1NMvdpbruTmgaVtEe0bVOxX7s3/VpeCaMUtIA
 AA4Adpzm
 cR/ss933o9LR/VizIYHBXd0i648fLl8gAsAMG9WwSgl7nda0UuSrk+TmTiWjyfaG1vc7VflQ3XyAEQjPCz6WOo2X201RnmBd1DgQ6zSPGMpaxpVUpnxPAqTGrpMZki7k5aUK8IxJD3LUcZixo2+kRG7NqvflcM/6jH4CM7q0tA2OrfuORmfMKyiqPDYXqBPfOOZ0xeS51iJWucVUBqcYeZ+6kDvLJO9fULmEj1Wi6iKJBNRrYrJfZ2lWm8PcEDlAj5yVg/ahpMjvRt5UlWK9NdMeGRMuYwYzhJ5iY2gMxXNumC0oes9PPCCzfICf5Rdo7MnIlqJf9QF2tePtSBpa/YdzeWoVTU3itJ2PLXy0UVUGXUBQPvnJl8Oa+mFC1Fgj+4BrIddVhnuehKJbxINBrdVJRH0TXpg1m/DsmpCaYL0pPsH+RgZDoy1HmQrdxu9n60AyEUT/5OI3XaN6/ajqsDOdp4OnvSI4muaci3Dy3ksKivihgNhsEwJKys2ej8B4Hr3UQAEzckg7rWYdFSpW33QrAdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

we'd already verified that DEBUGFS_ALLOW_API was there in
start_creating() - it would've failed otherwise

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 682120fdbb17..25a554331ac4 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -433,11 +433,6 @@ static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create file '%s'\n",
@@ -583,11 +578,6 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create directory '%s'\n",
@@ -630,11 +620,6 @@ struct dentry *debugfs_create_automount(const char *name,
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create automount '%s'\n",
-- 
2.47.3


