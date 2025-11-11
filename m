Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D71DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8FB8E0015; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08858E001A; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7130F8E0012; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE5A78E0017
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66EAE4BE39
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.26.38A9359
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id A84394000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="I/pjxcaH";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=VB5xxDAYdHdgcrO4NgRDAdtkPD/MiusJYK3xD7FdpMkBAImg+DUDsj3aJTTblDJJazGL4B
	RoqNLVq+YWG4c13e0Wb3uGxpxk5KmPgpMCT78nTVRWbf12wSKNnjlLEN707wRDrc1kwhWJ
	QEPz/AhaehM9PjOet/onmaZQH8/8dRc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="I/pjxcaH";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKINhvrphJyrNwMIsOfgnLwqrkhKPlvlu+weyrXrIrI=;
	b=l/TTvuKQESAzgqxnv0xj3Uwd9Z8zwC/QwRAmUjBfbQ7b03qsWt3O1cLq22tczw09UPf59f
	QWZCZNlH12u2wVJS0u7yo7V3s8oVqP/OsBOOKH4qUK1pyRVP29f++S7WR2m+4fgbbHTnPe
	D9+Zpmx2cuvuV5JA7fyNknH7FF3BSwU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WKINhvrphJyrNwMIsOfgnLwqrkhKPlvlu+weyrXrIrI=; b=I/pjxcaHFuWqmzpdIenmacuMOH
	aq3cr35oehDoPW359bMKvb6c6KWUoxbBSQ2G3ldspISxYPF9RuYak10Xx3e+eHgt8lcYwIUx8PWd5
	n48wI6Ja4l0zXmFmcSKvD2hIWlFyiZWHI3NYWs1S0q6MSqY/21Kbj266yiuuIGjs4yJnjtYj7YWjG
	AaiKqhUTtdf+hIgM8y6q22/U7TuKt23LIqH3zhKzwQU5kpjFf0+Ct2RifQPBTm0EKmQA0DIcvY0TE
	okXU1h7E09WAXuaXA+cIsui7rVE9YFszhKtGLHIn6iCmbbQfwCWZgGLgwFjWLAl/8FkdRugPY7cBH
	I6FbTrPQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000Bwxo-025Z;
	Tue, 11 Nov 2025 06:55:23 +0000
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
Subject: [PATCH v3 10/50] configfs, securityfs: kill_litter_super() not needed
Date: Tue, 11 Nov 2025 06:54:39 +0000
Message-ID: <20251111065520.2847791-11-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A84394000A
X-Rspamd-Server: rspam07
X-Stat-Signature: m7d9p93izcrocjrawdj7xusxcf1oajxz
X-Rspam-User: 
X-HE-Tag: 1762844130-630208
X-HE-Meta: U2FsdGVkX185KQEv2/q+BBJj916JJl8/jPXs8JpIKMeJ4aoAEsuDoSbIwax+MBKcBSGG22EuFVfvdNgswKefgprR5/ZqjdRbU7MzgoHOuxm90drjD091ioSQidkh+ZXvJWSG9iQ5sj4jIUYXBHhF2YXeloCf79nfINYKwavq1qsArjdDGwgRGTxhZDtP8h2QZcGEFuhgGGIb0s1ptcpe1rp+93XJMVV6a4lG+LX0/Fz+kNL0siYVOJqlzJW3v4FddBdGRk8PeIdhS8dQgjx5YzNaKdCdc0f/yiVPRVLz/Rg+ckL6dyN/qCzYJICsixf7si4QFjPiCkBfvu0lWRMGKbRRbq1LtAvhHmwCFM0cy+sHs8/rsZTqWUA5gxTm0CkVEx7cKd391MaIabt8qJElCAphV70AE8T1ERcFgK+Dpw+PAAkXXrtfMd7u5tmSbRws/DhB23AM2CPiy9Eo7heQOjL1zwgHopjb+Pq5mHt5R19xny+fsslpZwTWYnyc5CdPwiqm+nCYPQv5kGciLp57rAZ8J3pmmNnll46L+Fo+/QqrLIOQjCqom2xwj+kcmgiiTBVfYe0iaHm0puFpX8pz+zpdkV3sHCSfPvSoqxWsxMtDZS/qqHpMLNL6yWePhl9VYhGxgaafTqDAl6lloS5mJ1LCLypIvHGnJ3gT8mMqwOm4A5ouXWkiofR2gzo1D506MxswcT3ldfHUuUemt40kEApVgkzKoErQ69BW1Mulii0YiJv+0K2MFuYO0tN11ObY9ioz4Ys85rgeX8sUjQiPgwociEovxje3vsVHLrOQSZpJfX97UXF0A71Solb4jmgkZVaBt3vzCnNKGDOCWnbV8ZLPP0SAWLPdLEqLvkfdW0F5Gy5LcnmzTBWciDQo383RrOTnDV2WGBJdyFbhTlwmYKnpXU00zkGgOSj4HemhVkJkyKU3K4AL5WqDtFpl85vCseY7fa+x3v7wgXQWp6a
 Ho2Y2AIh
 iQDijlEpvGwgcO4KRbfXmnU/2A1zYJ7KwCM2fcwHCJtOdOwgHkbjfRm8xMCfhwl0fyMffOg5CfpGjpSJrMSC8Ab48PlTaDh8BgOYPTlgRQWun7nKhHVcQxnNKR+Us+FwOTOr1huoyp5qzxdQ7BaREzDl2o8LH8W11zR661yiAs+o9rzvdjvkzacq+kvb/+HfgwpujbfrAmfKtVDuf5CryL0BPXHDHE3M6L81aKjyExSdc/1BVTdTMSwOBJ3ARP20mMp71ixk09167W/Z793QeInV4F8dP8iaiexqEmOsuOFQck3CeK6ErGQ22QoLVgbYzktpi28UxzR8EItUgJllW7yq7lnzb7wVqYEs6beaE0M6XorNy8O6lc28rNVYWwUIsfW8hKOVngOT3FP0JR+hgBtDYGlHj9rovQTiygT5EnuzyH8AObcrmyqzTm3lB+QmO/ATLtl34gr7TuyX1DGg5rQvAJWs272P2v7pUKt7/Te4Asaq3lPwLm7sp4l90pU7pOkw/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are guaranteed to be empty by the time they are shut down;
both are single-instance and there is an internal mount maintained
for as long as there is any contents.

Both have that internal mount pinned by every object in root.

In other words, kill_litter_super() boils down to kill_anon_super()
for those.

Reviewed-by: Joel Becker <jlbec@evilplan.org>
Acked-by: Paul Moore <paul@paul-moore> (LSM)
Acked-by: Andreas Hindborg <a.hindborg@kernel.org> (configfs)
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/configfs/mount.c | 2 +-
 security/inode.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 456c4a2efb53..4929f3431189 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -116,7 +116,7 @@ static struct file_system_type configfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "configfs",
 	.init_fs_context = configfs_init_fs_context,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 };
 MODULE_ALIAS_FS("configfs");
 
diff --git a/security/inode.c b/security/inode.c
index 43382ef8896e..bf7b5e2e6955 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -70,7 +70,7 @@ static struct file_system_type fs_type = {
 	.owner =	THIS_MODULE,
 	.name =		"securityfs",
 	.init_fs_context = securityfs_init_fs_context,
-	.kill_sb =	kill_litter_super,
+	.kill_sb =	kill_anon_super,
 };
 
 /**
-- 
2.47.3


