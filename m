Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8C0CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526AE800DE; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD97800DC; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1F3800ED; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09D01800D7
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA18EB7DE0
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.25.4AF42E6
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id DC063A000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="VuZb/hUP";
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcrjn9Hoyal2qTn93te4BLRuOf8fYSOuLLeBgOIrdbo=;
	b=ewDLOGqMyejJh3FM8U4fLF+v9LUUmiVvn2ydep7C0OXosFIeW7VjOLn+cPkPmu5xfQoMwy
	F0Jvakh5C2YbS+WEt4bXpO8jiLw5Y5jFitNiR8mz5oupZVN3cbRYhYn6zuQLfd0lcZsIWH
	VlI0u6QlKzQCAN9xFhlU95lJOkKpt2A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="VuZb/hUP";
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=FjGg3/ARSirA290xhYm77sDIad9FiGdCoHnhA/KF0YqkChUf9bX54W4gCUFSqBJMABSX9M
	cX0cXc+5d28LhBjAagRdblroVs2ou03CG2Y6XjAhxwp5XucX2YX9Xu8wM7B1KDULMXCE7/
	wy5/YgPWRsEDoVfrUz7XDhA3Vf0nE2Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Zcrjn9Hoyal2qTn93te4BLRuOf8fYSOuLLeBgOIrdbo=; b=VuZb/hUPW3etL9Ezxwtroukx2s
	F2yZQhwQuBBh5gdwGS9aLze5TiYIDGGVxbFpmv6phk0cgczbSHhTI2WwYfR1slhPVM/+UCCnej/6y
	o2N78gCF0b0OmzHmg7ORzPAk00oVrgImOfC16t0+Zk//6tXsqO+xCj3zG8qfoCnkOHmtaVNDMRg+6
	0267IbZYJ28HpY0twT3Ibdi/IJXNsNLAm6Ownx6Ct6xzRyc0kg/TPuWiXpuY28F5vwgdhbbb9iRaD
	zSR1mPZltN0195QnymEW6v1O0s1YmGFS4dwiPVVztpPbgDLE4DgdIWdJ1XQ9aHO1kFSOJw9Ne0p8a
	5P5KpltA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eXg-1WsE;
	Tue, 28 Oct 2025 00:46:16 +0000
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
Subject: [PATCH v2 16/50] convert dlmfs
Date: Tue, 28 Oct 2025 00:45:35 +0000
Message-ID: <20251028004614.393374-17-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cfbtme3fpsozi9cmhuq18t9cibwqjfce
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC063A000D
X-HE-Tag: 1761612383-832269
X-HE-Meta: U2FsdGVkX1+a2mtIeLsOFDOhQjXXmSOQcNQ4FCk9PqmTJu2kmBmKVCxXVgDuj9KQvTpnPQjEhnnbRo8eYZjHPA/4585FEJdQ3HlPsSX3rDhA0cD89sn1jVltqzxW/5rZZZTzkihH05GlCsUavYC41gHnzp/3Syih9kwwbR91H2Z4yJ7L/9z4k8Iwr8Eeq+2oaXP50YoMyyNznoPFZzPXaB/+yXoq+z0AValtVupkSiMsLgHQpQS74wHIHpDXn+Q05UXbMbgziF9mBmoPet0Wi2SXmYRpgg6GNDdpy5Kcrqnpd1o6RHekHvBT84vuZzW41/cQeJJ8WW53ge8VUoULKfYpHlXdCrHX9EM1q3UK4g34ZcJ4nkHoLSFyMuJBzIQbPHRLJHCkic2sF8fcb7/BSMM5Es8FSb7tCGDuh6rCwru+eTc8cnBaxdCuOJuU3NCf1VE55DelAqyr856r9kiOoBCIPy3Np3jga3uTAikWO2hvefBbadPS98Hkc4OGR78VMUONYX2FTFnftScP66EvkWz2S6ZlqvAHP6I2UwR+oRcX8QCEumely4Aaaa/oFSfnLLzpqyKbrDae5H6vueVKkbB7mHOOY+jeVZufnEz7umtXhght8/Hby7c2Ip6oXN2fP6ctkhA3OhV35Zuc0azF/jqt2CpmcOiW6e0ekk2QmYtvXGGodp34sarsyI/JQfTD7lSCI+N00ITIKTXDlsacXqLgJXTDGZmHHITlclzWr45GLgArmUfKl1Fywv8R630t9jJWWQfGpBo76bWNKwb/mCGV9USkfTIjqG1T3cuFM7AQONpw+R+UkqA7Gibe+iA8joWq6mlyxXUtpebs92ZyHBGZfgrWQJzsS3OgePi+yU11NDSC8RF8crgpXKZAUmISxGqO2Bb9rq5qtkeHLBCVPkYuCRh85PD5REK51yh/om++bByps4UfFhlZc91jVImyeQLYjsiBr9qoKPGKBnn
 1zPP7tmr
 YVSN9rxBM9UsHevC2aeuHABQGXXiYyeBhkILPphRgOgCTxmlOYjCFsXeAR+Jq/aryVZU2rO4cqFAD2orxJx/ZEeMQLXTYBpZXCxAZfk2d4/jb6bZ1ItGuhjhPa4wBr4Q3hydLLbj/Bk7MXa95dvUhSTqgOY+jcM8x+ZDDtJV4eXr3uW4ySBOzGxjGZXqzgjc5l2OtbBgZEFeNw4ZgXJMGMFSEpsjEnKFIUJ5mDI6j+EJMcCHs/8DLnC+rlXxiia+DUdzZlOdNk1B3PYLyLL2Cdiqx2//ONTPZnBKOWhEPbJ04t2kpA8k85wCZxIZ6g6b/xNXLREeN+y+HSOU0J/67KfXJ9LWDEQpRzEq2LAwS6uFSZQ3UZPDjX/A84nArsN7d76uc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All modifications via normal VFS codepaths; just take care of making
persistent in ->create() and ->mkdir() and that's it (removal side
doesn't need any changes, since it uses simple_rmdir() for ->rmdir()
and calls simple_unlink() from ->unlink()).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ocfs2/dlmfs/dlmfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index cccaa1d6fbba..339f0b11cdc8 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -441,8 +441,7 @@ static struct dentry *dlmfs_mkdir(struct mnt_idmap * idmap,
 	ip->ip_conn = conn;
 
 	inc_nlink(dir);
-	d_instantiate(dentry, inode);
-	dget(dentry);	/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 
 	status = 0;
 bail:
@@ -480,8 +479,7 @@ static int dlmfs_create(struct mnt_idmap *idmap,
 		goto bail;
 	}
 
-	d_instantiate(dentry, inode);
-	dget(dentry);	/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 bail:
 	return status;
 }
@@ -574,7 +572,7 @@ static int dlmfs_init_fs_context(struct fs_context *fc)
 static struct file_system_type dlmfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ocfs2_dlmfs",
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 	.init_fs_context = dlmfs_init_fs_context,
 };
 MODULE_ALIAS_FS("ocfs2_dlmfs");
-- 
2.47.3


