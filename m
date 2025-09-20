Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C55DCAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1758E001F; Sat, 20 Sep 2025 03:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A498E001E; Sat, 20 Sep 2025 03:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5ECA8E0020; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C36FD8E001E
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 932E1140947
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:13 +0000 (UTC)
X-FDA: 83908850466.17.BF24263
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 034A6180003
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZUHKPj2l;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354492;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kt5xEHMx+oGXrg9a3wt3WFau1p2+Ow+pw2GQ7mKAvTs=;
	b=1Eia/VKFiuuhM0Mm7+vsPJ2i98HmPulQbGlyr6Jrc9uQYqK6qtsPxlkz3jehk7CZmvb9pJ
	OO2iWQIjGxWhGzmwOlC6udWVgKC+mka5HXm6KfcbnM4FLFUEx4+v7+HMfg69ZpOR/n3bX9
	TTOsapl85STgVVfz0Qy5ypAKV9/sFhE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354492; a=rsa-sha256;
	cv=none;
	b=MlM72gFQrCH4kDHCki5N5FAP2L2T0g+ar5CiDjPx+ypesAOr9G7UJJH35Z8AJMAuOdNBCP
	p8JMFpUB2ng5tJQYiVomzMaPVp8qIeBZsbVAIwHBQ6yH+WtQkP8zirT8KGIpqsdscwLoxf
	RLqwFT5/2XnayPyG/1G7KOGwiB10jWU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZUHKPj2l;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Kt5xEHMx+oGXrg9a3wt3WFau1p2+Ow+pw2GQ7mKAvTs=; b=ZUHKPj2lbGLNsYW8Syb9BRS8nI
	BqdgFmG5vH/cRfmJdLB8IEVySftrB7QN3XLbg1KTpOBqXEoSz2W50qPojXFUfxCDhEf4IlmIg7j33
	svCQMkaQTLbjB+8soDcP8DDIiqkKER4DPHbNciqLVaLJ/O17uQ8lJmjpHIjLzipsYarOcUg3FfEk4
	2dsEwfXY+EhFX04i88FrIw76g0YuF4HUvCNHSHphC5stRvSuy7PRJbR2+vfsFDkSQkzqVksiDaRoz
	tqvx6ILXHYuIyZltN2mTzpSNZgyZgnUOU2O8TEVzZeRLf+A1n2uizUFFrnwLcGw2EB406YgdVVTIQ
	qMXK/Jyg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKG-0000000ExLx-2Ynu;
	Sat, 20 Sep 2025 07:48:08 +0000
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
Subject: [PATCH 33/39] convert functionfs
Date: Sat, 20 Sep 2025 08:47:52 +0100
Message-ID: <20250920074759.3564072-33-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yxtb7wnokkhw7qw8kiqyowaewxcu8x77
X-Rspamd-Queue-Id: 034A6180003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758354491-320188
X-HE-Meta: U2FsdGVkX1+U+NSrTnEth8VjUtsRudgi/MMZbnYVyPLPR9iIRp5Zz0cYS0x+SiyvupDzr0TWfFhTklJW+AhjZy8D1dE1kkFKyxL3Br7Z5w9X46XH5pgDSpRYIQQ3IvuoZcmgRtg3qpc4r4bg0ttguhE4atiax98XhbELG5ekrU+b0NJWvAUM44Wqtdx7bBtrzkutWgFeR4LKFdYDuwXCWGvQz/ywROvzr/CDAAIqplfx9J1860/k+zmaMhrh70bPmpvJ8Q3r6labnDGRYrnkeKsKiAtfagQizeguA9Jk97ikfE91+bKTnSDhHvAAzNjpI5T8V5xr4FICKpmwKpwakaX3vAiPHQG+HVvX2BATo0g6XCMopmfWelt98blbIYhKuwspO800Cg3Z6olpBxKhxxujjDyhc81WJJtWCkO9cMEIPmKvgmZbH8leFzGp4eWKnR6iXIZs7S+j2AqMEh402JH0Ed305fkzdnWXGZiNiSanvoHJdKhz2gwkpzMT34B3T3HYnIZkXNw5dGi+3hZ/sftJGAfEhlPgA7obB960iR+i0eity3SWXQxCu+zLp0XJ1IFv1hFarvTxSxZKVgUggJlQQGacYnTttH+kfE5tQB+DMyAedIpP67uKVqKQkHSbNM8GW4V6BNYFwUYFs+hL9cuYqcEiP6QK8Yxo5eWoa8HKIHlSfdrn7jFicdJ4HWnwUJ8LEuX+d9Fkg0HuqyeyGZYQ3fRtmI1zuTy9HAA98Qkd7z+Wzqo0HOMJwbGnnbNSYSiUw6jdcV9nkSizbnb8F5Z1CVaGyOmLeTJvi3Yxr08a63gUwbwvAwx0k+aBh//lokerYidTFDZNissRTeShVE+7ewosUqmeZYt3BICdlDgyINo8eLHQAP4BtByFVjMB2/G3ResqRivbo8mctq7Ek7rYGD2/4YXiNSuAVTLNHIGJuSMGtcinFTUSKKFYcfFCTuv3uFr3E8IpkHHc9vR
 L2NrSzU3
 hgpQe2+KSu/eDGFpzTLmincYQjQHyzcNU4YUtCkdZHQgXxGAOznp/tbVtilRPmfuwmtfz5VYJSkLvHyJ5vwaU9zfiHmqXeN/yJlG4xE11WoV0xE0LITMuXtKQp485tid7VMhQai8QuZ8lUMYSklvVzK8OrrtauWoLrYMpx9YLcNeslXs5d3zHo8NFI9xzPm8Po0YSA0U/sFVFsGttZUSNHzvGh3HVuio56kULDy0xWqf8/beV2MpGa/lzsYg8TbVWeXwcV/CRbglZc65EqjYV7nskQuKs9OeS9fU1tUgEcKtMwLNqP7wpxmbMdgXMcmvv0Wog10lNzCp5fERGnvx9Oik0TIiVa/XY0RjneTcVovNfIPPLQNwPdbfo3y0+dSrRl1stXooN5X7DE/Y3ZMlkCVjaXuRNuApSCV59
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All files are regular; ep0 is there all along, other ep* may appear
and go away during the filesystem lifetime; all of those are guaranteed
to be gone by the time we umount it.

Object creation is in ffs_sb_create_file(), removals - at ->kill_sb()
time (for ep0) or by simple_remove_by_name() from ffs_epfiles_destroy()
(for the rest of them).

Switch ffs_sb_create_file() to simple_start_creating()/d_make_persistent()/
simple_done_creating() and that's it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 5c9a7bd4e41e..65d9109b4051 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1870,17 +1870,18 @@ static int ffs_sb_create_file(struct super_block *sb, const char *name,
 	struct dentry	*dentry;
 	struct inode	*inode;
 
-	dentry = d_alloc_name(sb->s_root, name);
-	if (!dentry)
-		return -ENOMEM;
-
 	inode = ffs_sb_make_inode(sb, data, fops, NULL, &ffs->file_perms);
-	if (!inode) {
-		dput(dentry);
+	if (!inode)
 		return -ENOMEM;
+	dentry = simple_start_creating(sb->s_root, name);
+	if (IS_ERR(dentry)) {
+		iput(inode);
+		return PTR_ERR(dentry);
 	}
 
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+
+	simple_done_creating(dentry);
 	return 0;
 }
 
@@ -2067,7 +2068,7 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 static void
 ffs_fs_kill_sb(struct super_block *sb)
 {
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	if (sb->s_fs_info)
 		ffs_data_closed(sb->s_fs_info);
 }
-- 
2.47.3


