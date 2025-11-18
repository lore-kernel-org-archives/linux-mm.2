Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949EACED260
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E7E6B0024; Tue, 18 Nov 2025 05:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3A06B007B; Tue, 18 Nov 2025 05:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBCE6B0095; Tue, 18 Nov 2025 05:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 933D26B0024
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:01:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3963A4DB33
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:01:35 +0000 (UTC)
X-FDA: 84123285750.18.8EA1E96
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD23C1A000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:01:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=YJuOa56O;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763460093; a=rsa-sha256;
	cv=none;
	b=vTYpZIUDQbf0MeQzM0fNugm4ImKYJXSyCgRV6Oo16w0O61aYi60u2BdCJxz0BedzUDsPp1
	2d+KED37jCHQvBAv0ByaCUCI6RP+UA6r8Vst/xK/Tb0UA5yjwSiUhRTCjEjHvN88Z9B7fE
	lHlREH5wKfxPqoxOxLiqiDoxhI1ymtg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=YJuOa56O;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763460093;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZUuqKrs+nqWkpfLt5q4RrHggbnk1CWWQm+NX1Cw0DM=;
	b=WP0rb4E0FX6E+GrT+19cf3gNpp2b25mh4WXc0CXNlcfqU21PXqzzgKhNg+k5bYUWoajFEp
	m6gOwyVW+8fcYpOBFmAp6ezlo7CRfU86CBCeE366PL1nIdFBb3jrl4nIiWArbVrjP5SRUF
	kCar0q8aNT5ogU7D7zkzXOLiPk8gbEU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FZUuqKrs+nqWkpfLt5q4RrHggbnk1CWWQm+NX1Cw0DM=; b=YJuOa56O1MjxYGTgaENOoy61GE
	pW9BzUrfOK+4o3p4qm+AJO0GBRfVwfQIkuRSUxdY+22Q3QUMcnZIT7TV5oOi/iLqJgLHtYRjjp0Cz
	icaAAzCWMnLekniPfnn9IyaYt1f9ZUuMsv1I+L50s53kJJCvGsOd5aHDpW1EkZAH+UEd0J0GlZPjs
	pjfdjwxDOhzoiPPnLnBcovS5mXBMc2w/Pwa8nhiquqr7IPOWftRwjnGCeHNTQ76lgTpBvLJwnm24o
	GlJGTEgxKAwsZtFGDSsdzA5CdC9Wz+bO6RgwK3mR7wGYbekp/XVbxHmh7icarI9y/w9mr+YZhhyQL
	2EEZJN9g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GET9-3lku;
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
Subject: [PATCH v4 35/54] convert selinuxfs
Date: Tue, 18 Nov 2025 05:15:44 +0000
Message-ID: <20251118051604.3868588-36-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BD23C1A000D
X-Stat-Signature: 1d959f88e486p7oedb7t4qnirp4tmw16
X-Rspam-User: 
X-HE-Tag: 1763460093-643687
X-HE-Meta: U2FsdGVkX19kpdPtfO3A2zm1kLkOqcUaZYCq1upWTv2I4UG58SmTWuWvxSwHy+1S42UatnTHe7+JjTPHPNYE6y4ibDZTOCKEJ2QGx8O/t7EwjTkX0bph2wopMLgKBfFPCK/b4nwlQnXuWSipkHR0KoAzSE835i76IroBfQPjs/UqxeM6j74RL2gDn57d29CixMxLjA0QkfueUD8nlg4eTPKgf0yWLN3vStK7oyd7OaTHgkFvG+uJcNVQ073Imly5+PQHBt9Dpebe6DpkHtDzH3rTGsNDSST0IuzA1Ee1q0WJKFNDKwuScDo1EsZ1GUzyLFcH6AtjuPEXFBQ+FdhpEHNGpPT0reyXVcW65kQ2+erPPiSxBPXr9GsnH2+VPG161EXOKLmC+aV9GP26/W1kYyUPo5SlAqEQPjcO8FhuKcQ9QC5oOpkq/4XKeUMiD0J3JE47pCYPNRGTEgvy+9yptgFeMi+oa+lyOpmRsZtaK/Fx8cfKb6u/8m+0SgPrDVa201sIOqeh6yhLlI1i1j1w828NGkIk+kLyx4Vt4cS7KJTsBosxqmWx89GwgmxC7k+emIKsv6g70QeYbwrNedejsdq+a/foPverBCJdWIWhW9eQ93kyC1oRn3at1RlmJZ6U7EAxA58ABbTgQqQUpDfNZv/pbaNMyJAQqRC8DsvxDSisnx/eFetHPQx4fX6UyIFwa+ofqAFgGYX82S4ak3c7Erqd/D/hYE9Dyezr+/+SyNoSI1g4tCTu5G6yrIuObLmDb18Vq3wMN4lsiWme82zKGCvRsYIRanln+tll0kIqmCqtMIqONj7TgPs4fzqp0aUUZCMql4BKZYfb+OrVigxSaVrw+4E6yRfkJYW5zam7PIEDiRBpB2tecO86xUWeKWYEoKlUjRm6wi7bxttCzognsw7RE+1A3p5krxEjV/EOrPb3Ia0yUPMrfenzFwJOOxrfozNW2uq+7no6/+toHy0
 GTTAj2dE
 Hv/Nzn5C5sYBWq+2LV8D13DePEUB4gGo3PXjo8A5dN8X6RS0PDYkCsc7IRdPigGVstGAPXZfIV21ZLoez+a4jpdkTLhPweggaScja8XEM8pDFdZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tree has invariant part + two subtrees that get replaced upon each
policy load.  Invariant parts stay for the lifetime of filesystem,
these two subdirs - from policy load to policy load (serialized
on lock_rename(root, ...)).

All object creations are via d_alloc_name()+d_add() inside selinuxfs,
all removals are via simple_recursive_removal().

Turn those d_add() into d_make_persistent()+dput() and that's mostly it.

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/selinux/selinuxfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index f088776dbbd3..eae565358db4 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1205,7 +1205,8 @@ static struct dentry *sel_attach(struct dentry *parent, const char *name,
 		iput(inode);
 		return ERR_PTR(-ENOMEM);
 	}
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 	return dentry;
 }
 
@@ -1934,10 +1935,11 @@ static struct dentry *sel_make_swapover_dir(struct super_block *sb,
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	inode_lock(sb->s_root->d_inode);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(sb->s_root->d_inode);
 	inode_unlock(sb->s_root->d_inode);
-	return dentry;
+	dput(dentry);
+	return dentry;	// borrowed
 }
 
 #define NULL_FILE_NAME "null"
@@ -2080,7 +2082,7 @@ static int sel_init_fs_context(struct fs_context *fc)
 static void sel_kill_sb(struct super_block *sb)
 {
 	selinux_fs_info_free(sb);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type sel_fs_type = {
-- 
2.47.3


