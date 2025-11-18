Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76CACCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E39D8E002B; Tue, 18 Nov 2025 03:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0947E8E0002; Tue, 18 Nov 2025 03:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4B88E002B; Tue, 18 Nov 2025 03:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D91198E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:41:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70185C040C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:41:45 +0000 (UTC)
X-FDA: 84123084570.21.F762CA8
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id C54E8A0003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:41:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=YMQMfC95;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763455303;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0EOMkT/UFsYLOkQCFILn7xjwHlMa0Zq2h7YoVPTnFkU=;
	b=noycjL/vbrBdnWknNNC8DSlipRFP2nUncCJvsI8sScKQgc/j0U6GUipJOCz11BOPEWnTT4
	Qss+NAdd2Z94QBMT0yil/eu9/VkfXjj1IcbRuO8a4NBlekqJdr0FuwDqKqPPKOS50pp7MH
	BxYs6S+Dr6SUIyOcNf2rvS8iocQZQ4E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=YMQMfC95;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763455303; a=rsa-sha256;
	cv=none;
	b=Oay1eSzQ4FHLS7JQpJ4RiF6CCz4FfY3FYoMXQVPcS/iWCdcIOlzdlOQ2wn2Ha/g9gim6it
	k5rF6upge0uZRlUResN5pdkd7m4L0cozKsTOKIf1lVsrhBy3CnMnvi2NXH4HQPYMo+ZvUf
	KcHTuADN8391z11ZSH9ASx/s3I95bR0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0EOMkT/UFsYLOkQCFILn7xjwHlMa0Zq2h7YoVPTnFkU=; b=YMQMfC95UzXpLnsV+MX99bUiC4
	cvz/Aak/sdeVYYm1wdUV2YNlDYiycXWNQYdo5idTX2iZSBMODEOrqf4iSHEKVdt1TzvhXFOF8RzX8
	IjdaoaRvSduE7wcMeRcl64wQ4BFqwO5ZwHxbzRIzCFv5e1kXQa14bytNI9mbxuasJ7R1jVElyQutN
	mFeKClenuE+KOJAHjbE9U4qouT6EwdCy+N1wlVRFH4D4GHTd4vxsByBID2Z4RPzSpkigpAVv5ENuw
	BCETuW6vudii5uC+ts1uwJiaMtJT2YzEASyX1/UfwsObbbvb55Z/pqkAsIEdy3RZhKajBuUQDb7Yg
	G/fThDHw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GESc-0zv6;
	Tue, 18 Nov 2025 05:16:08 +0000
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
Subject: [PATCH v4 30/54] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry == dentry there
Date: Tue, 18 Nov 2025 05:15:39 +0000
Message-ID: <20251118051604.3868588-31-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C54E8A0003
X-Stat-Signature: usjzxh8598xjipd881f7xb5o8ftbs6hp
X-Rspam-User: 
X-HE-Tag: 1763455303-115589
X-HE-Meta: U2FsdGVkX1/2x5pY2D3KG8WCBFGuAtO6p3S88mIiphzJfBVE/RzsSk6EFpsKLLK2hLI3Vbait1c0jbZ7tp/XUt+bpjpDz55OSF3WtSrX8PPXksGUm2noAo5GQBE5LPUVPIWCGSJRPp/TCS1cmUXRjLJ6ra/dCGU9jVvlL/I9gT3zICh7aWrb7UEDtwhe+OozYK2if4Q8CiofQylv3OGrA+pcV75VPbS9TeK9EjLPn+eZLLumArbfSVM/jBdr0qOpFO/f1RNN016U31ohNgksyxD1EoBT4FurEDXgWIA9lUL+GyvGaByvXAPFAwk0U3+JfZD6w+T3ehEuSppsYaIwQlmps1OfgJOqmqqYPSnyHCSe0xX/QgtA1QbICXAYmHbkwyoRwCp6XRxTTFHEydxWLUMY5qGXNCTL1AC5MRaDR3djiksXpkqXiBjGNlbvZpfUNT96IK+tINF55M9HUTWPYEghXlO/2hQxyMm56ELGaU0mlSEau2o4RK5JFxm1c848pcYqS5CQ5hO8HigMPFw+Fc/JHQqHoWOpP/H5S6dA5wrBYospPD5LcFTicCEDhYYFGsJ0G93xOYQPcmpzuDN1929wKwTjhdEAWoW8z9LB2ss8KP7qYQWqM5uDCAHHTgIarD2XrMRizqd1DPb8JaM3d4mH9U3o4JkS9gRNBiQVAa4V0I/Rd44WJ/eJqe47zMhS6Cl/RSXGaoMWiul0dE0UmYEoZTVlzDMSvBJlRAiWZJP2n+pKJ//TPzH8rQr3kPKnJ3/2Q4n/tShFIjNVQN2fMRHK7uQTnnKXli+KKpNvpaX3awnDUNqzzvHoQujsnQ5v7FMpKHEEONp4tM6OX27A5iFNNY0XyK1GRZPFTMUL6guSbbIArlrunwgEFO//HWFgkIBG1hKCb1hL17nuSIOpJ7JF9lGcdFrdBxUdxRxki0JC6/J/4E+S1LlER7qJ7fQSB7aZgX9+fM2cAJh1HBh
 3DXvpbRh
 sjlKsJuDJKnRC1LX4hEVBHa++ld5GimzsuOwqU2eTa1IBkt/Vuu9CVjwCLG/VwqgQZxQGB7zZ610+aHn3ipe3rLH9+t5Jx5ZEBNmvyrHZA/BY/1nOY8UrGypD/Fdovc6HOGuoCFij4hf4rm6/oJNISlKLjxres/EOjUrYrEQXxbNYOxYf4rJRphVhpp+tm7izg1jnEo51nqwdaJ6SA7Rv7N9pAS/Pwb1YmHT9IOU4yuwkYw3aZB1lJHLPMBev+H9qtSL6kuPcj7LnzcPYqnApbT5i9ezFlZBWRyQJomcotoGQWao73XnY8thdQz9StwsfVa7REViI2O6RfXgoyBKcjDhO3iOFZ/NkJ5xXWqiCc9ScQ2h0j/znlNGTU1Y9uiigXoU/8ZVFJJdrbCCc3QOZVPVxF9nV4C7km8iuefBu65mNyoUK1gNsL0WFIhmRyrwijSaPTBK6CEM/lq3ypTPEg6SpTNHY2IT4BYzcD2BIJz0VpK9U3mtGl4mphQ==
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


