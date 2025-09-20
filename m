Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2312BCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 08:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E048E0003; Sat, 20 Sep 2025 04:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEFC8E0002; Sat, 20 Sep 2025 04:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16A78E0003; Sat, 20 Sep 2025 04:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E05A48E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:51:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 518C11A0918
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:51:33 +0000 (UTC)
X-FDA: 83909010066.21.38C07D9
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 841E020009
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:51:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=IZeE7J9d;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758358291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sU0Rwyb1f70hxWqGLaDrX9gfHmhzhxjXEuqfS3xyBnk=;
	b=R3xjbPmN/yIWxMS10ouiCCubBCb4pBcKoWeAle4vW2kHbLTVJ3MQQs9+5osx5pV6Dw7JT8
	XjPFXU+usrRt6XtOG7OE9kPqjoDLBdf5qhfO5VKvccEU3UdPPj1vVMhky1gGY5d/ZkRQjb
	GxVXuKfIIzKo2rJc2BlsevQk+HMFpuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758358291; a=rsa-sha256;
	cv=none;
	b=3n3oWeicaNzZyq4uurzxcxFnkRWgmAssuW4xFn92+mY+Qd2VRiwBKS4gHSsC1xrF6hE4iz
	c8Iu+hdoJQqi6ybyuWuw7yELW4Accg/OSpSEOM5OIQqBa6oh8eqb/I38O1Kx02sb3laMr5
	fiOVPVJSCnFi6LVuu14VCbmP8QuRHVw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=IZeE7J9d;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sU0Rwyb1f70hxWqGLaDrX9gfHmhzhxjXEuqfS3xyBnk=; b=IZeE7J9dxm0UIt3ZnyfuObVDeK
	3JazmOLAU9OCPA74rcy0/qZe/amIJIXMYI3vowai3fBRIW6WPXusEJqIol2DXRDONpRN0ziWNrKds
	UJaTjYLCpnGBl8X5aqtC4UpNzQNgyicnQj1UmSk3byfQILVQJ8ptSZPmLXEB/PvzR5H/NHPdlc0Lm
	YX+AfSxoVuXNixjhQhCVMPn5Fi+7eKHA4giy5VAscZluoYRq/mf6No+R0gYK5dczC7u4e7/uZ5Wrd
	2F5Jfsv7VkSyW3rnhayFqA3BGkuexNvYbvxQOP2TsbscxWeHve2Cw44CJcNoezTZ8MURaejoCTOpc
	Jf4rvcGw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKI-0000000ExO0-2YpW;
	Sat, 20 Sep 2025 07:48:10 +0000
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
Subject: [PATCH 39/39] convert hypfs
Date: Sat, 20 Sep 2025 08:47:58 +0100
Message-ID: <20250920074759.3564072-39-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7utokzgsdrnb1fxopj9k6fd1hbcfgot9
X-Rspamd-Queue-Id: 841E020009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758358291-880140
X-HE-Meta: U2FsdGVkX18bAsr06WFopb+0Tke1+vZl6lQRGG1hWojXuI6TIVn5x3t3krHuIrrzPc1OxbaHdaSRQNwMISpSrrCQeFsRcugsYtrY4FSHNmcIVw8D+j/SoODqSR6JVwvvVgeCsvZ/msTP1M4W+KjLLRaBcrdS7YnzwRKrK9mRSe+F5Eo58UjmEBLNiQAxkaHrfZ/HhnFmRc9PLW1dXo/bhsZNwUdyL2UWrH661flRDEsdMBpCm2ZZvtyQjWhk1O7mRIYp6kcf4qtBGj3hf2B3quamK4l/xAgUlo0oirXmUpEmsh7OKYU8i9M3Pm4YTBV7sId85p1o5996GbYZV6CVN/F0zZNrRAknOGKBInjSkeutD4ermiUJDXANfZLQlPd1K2dBwFkyv9ggZYIqjbgJkhNLZqEWQ/Ffdcb2sNxgf3ez/WYB/3lu4GarAcFlBtgqIMzb7iCikK/kabqVCrRDY/laOoaoCyOgpIFmNCf81HJhmP+lU7zKhjRTBIiQKo7fJxhzzJyxL26330Sfz5L9LEJX7gTaHwSyHdHhz9khWKsa3TkHRHKL0fxp7bU+ZvVn0JXFj/MydUj+ZE0+VQbH5EnIqsCENJeczdW/zEncXCN5ZWndQgWXkrZhlkXo1SihZYPNlxtO4IQCcHI/yuIciKy3qGK4GOpQ4royh6SDW2f8corkue2lv0oPUjRD2sWtKxGDuJysov5eyQaluy8Z15zCnK1UOGW8hBgKkQ36cScj/ow2aTKrPFocM13iKmf8w1pB7j41gGsqaHGg+Ug3Huh+wTmSTcOl5BpHctmoYiJFyOw1uXDKjhznqLy+7B1BK9LXPtMjlb3KgmEsAaIsq9d8Az/VYZnziKzbLscXYHX6vruN1RKxAnjp0n9UqFJYrFqG5zbz5WNOnPoH6pLm/2TenO9aII8cn5foBJb50/kS7mbfGqPO1oz+Axusa/Pr8n6Hjrs49a7anAG5Ssh
 FG9lQrmn
 tUn1BOlLaZbh5ikj8P6CU6YepWDlwCpArq8UHfkBWAciZlvQGVvVCRGf7aFTMTi+D+szVotB6sqHMSftYrSJUzZ9slQ6Of9ef9G0I5ppWozS4VL1WCKF3Zvju3ujOI5siheLBs05tuHEO/YBaUNtnC4Fat4drYZLSS87mSqisFbGuPb1O7yvo0lNMurROFAhcRGupR03y7SyoFdLAu7UDjoTrMxoiadsoWriD6RFMYUHpXMBCrgcCOudkqW4QmnGWWDC10dvV8hMRU8M5mUl5ilgysVF7wobrNiDxXYXOh1YcAxZ5NrqnZ2f3DEOefxHfC5feOKzXIo5+XynrwUOEyJQHeq/DJDEmV0pNYmcGj7/243fHlyovXUFG3WDvO4dIXJT34mQGpFwUp5P1MGfvVhw2wJcK06/HggvP
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


