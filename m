Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F370CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC8E8E000D; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D658E0016; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8675B8E0016; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA3B8E000D
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDF6E140957
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.08.3856600
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 54D764000C
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=VPFh5Puu;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9BTpDV5VmWnukcbyFgJ+P2WXRi71atTyZvcwK8Zv7c=;
	b=AX5RxGKq7l9/VxuIPqlI7utyFO8GBeUTFUwem36MD1aD6XvOEiJ9mklJT6GWHNZx2Utsxf
	vZLuuLwVenqK/nraC636BHAERI9W3fbFNaVm+H2STTRf/Ge/RHqJiXO3mLdIio1ImMKgn2
	FiQunTfuJ7M22C/6Mhf6bRXQ64MsRMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=FqqIMfjMaVPj0fIhgUU+51r5SRxfbVQKo38ZWorHmCMGICKUKfujZhrs85o61oOUXoHICb
	WllqBIw+B4olbA1KwdHkKcOlbY3o6fCzlwrd0VsAYQ03sd12zUCwYBNS0MHQzGpWIkF6jx
	c01tAXVMy/3/uv1qcnTIu9aJ5y0R7+M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=VPFh5Puu;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=o9BTpDV5VmWnukcbyFgJ+P2WXRi71atTyZvcwK8Zv7c=; b=VPFh5PuuaMKxBR9c/9xK9PyU+I
	l76/TxnbuYUnnilAzgMGQ1YnsTfp8GJp7DbrlcsfjcAZtgnC9SUxWBJthCRDQYqaEB71fGBBz+nF5
	ELSGR3cuXetxT9KKlNjspGjtTVs45vUd6RrKquZcSizGH2ATXf/KrsLPHyfGy6hW6nu04mF7veP5u
	27RpfqzNmMLl7ODNZL166avZaqKsSZXVXsOv1/bUThsnYcUulH+9WX502lHTqdFzXMFICa1MMciLi
	DeJmUu6nOjRqzGMVLQG61vb7SIzEr55IEyW5E5z3GVO3hB0SzU4jr9bfFd9ZxPvqR30yEBe3f/Ych
	myzgouKg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK7-0000000ExBd-3kjG;
	Sat, 20 Sep 2025 07:48:00 +0000
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
Subject: [PATCH 01/39] new helper: simple_remove_by_name()
Date: Sat, 20 Sep 2025 08:47:20 +0100
Message-ID: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074156.GK39973@ZenIV>
References: <20250920074156.GK39973@ZenIV>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ibssb1teaojktpon5mgeefihpkwzyzsc
X-Rspam-User: 
X-Rspamd-Queue-Id: 54D764000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758354486-744605
X-HE-Meta: U2FsdGVkX1+rl4DcumJK1vDpVn0JcYsJYzkvguU6VEWy6X8bQBukMfripJ7NflvBB6TYrWCm4Y9vosLKJl4Onnbtm7L5DPWle35DjlFztVq/1wLH7NfRT4ffo1HwKzqoFYje/+S0d7O/0Tfo2oTB6HuuviUzCDv2BY+XZnHoQ5sWyx8SgPdUQkt7dZXx5wYSoSZfqtQyRCpt+hVmu1xp3dkIiN7jGIAJ1GiECbNIlp+MbYmngxhDLo7oxHDCFao95tvRiEISGvdyzNNPNGdSNqFcCpxtuRxrGKNlJd2PbtvgNMo2wvJl34Z7b9ZKdMxmnApDpGqxob+0DBtgRsLGsHPQ3E7ETs/G5o9SnfOPuLvtGQPxMFeKyCK2YiG2Rks4sEz1+zGnSkKV7g+/xTLbXhc1dWmHiss/VU+v+iB66eN3D33RNqRMYT5GW16t/b9r6Sm7v8PFF1MPoBsNzBlLNj5Ibva17LCUeXqXs4Au9bsV5IlLXT6gj4wyK1TlHJmNxTzb159HoglzGkqkdez68kqoJDTBOnh7d+TUIOcnyUjBRwOhD+cbVH6qGQSHs8eSPRS8bnzDKGn6reULeP08kgKTzY6KeRzEExZCoKcHZReY9abr7+SUfX2I+W2or9/s5FrI5IG6DRzv2vc2dribREbkEjCLpN98KGHEViuuyNZEypZMYxQhltkdqAsrzmM5RAud/iyanXoFvQj2vQbKdbFqmb99sj33+31VpUFYfFDvCPpdKgDor6dCxQVTU69hKzjm57UTQlRLZ8nuEPFbkfG63aRfqNB6uMFxGD1Ft77SK2vzEP8D+SGztNlxSa+dCe2a/1vOSWf5hNSzqweBoRLQC6t9Rb1r2UT+jInGqlbCxwZFb0BI2wgDeRgF8pPdWcA/Jd86otw6Y4631hs5q5diZPFsKaLSg+Z+pfkKGEn65DHTEMdMqX4exbpxiIPcp5o+/SeLs6t7gZHKFqf
 cwN0vWtF
 tHphs2kVtVyo2ISP7NACUFDUOxXWJmmQq2Rl3vZTTrpPoTt3PYrio6pGcaN7VcR+caoqd5Qh/KqzHIT4X3108Ii3ssD6epvdlV1441U1dAWc2n1E4sXIRYeQwzPBwjgplAvxnUPue/N6x92Z8PnqWd6LvWJ9P6Xmj8yobimbKqwnVHBLv7Cefcfmxxk7gy7iBcxSbJbf/2nBUv/cFeGmj5H74nkD9TpJcB5Y9SfZ2C338PDvJlTLdxMqm325Zvu0auGu98xAkA51mO21RyyQKvLvpp6Qf0FKToivKXWHL+iNQqqg/4eJ5JxDP0T3/qdXWKdIw8lBW4dM5nKEdZipp9FW2FfomK0vcJZUrStekuIgvTkRPIEkzuzN/2K7L58ikswnv53N4MFD8q2xX6pUCe3Qyqq1EPi5hPC2yxyDr4UIhqNZHnA8K4p6xWsYf0NpGD+i7AClMsJ4quzNFm7GPyQVvN9hTqm0evhSeiVPmjEJLwZnNMCWck8IBmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

simple_recursive_removal(), but instead of victim dentry it takes
parent + name.

Used to be open-coded in fs/fuse/control.c, but there's no need to expose
the guts of that thing there and there are other potential users, so
let's lift it into libfs...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/control.c  |  7 +------
 fs/libfs.c         | 13 +++++++++++++
 include/linux/fs.h |  2 ++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index bb407705603c..31fa816d0189 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -289,18 +289,13 @@ static void remove_one(struct dentry *dentry)
  */
 void fuse_ctl_remove_conn(struct fuse_conn *fc)
 {
-	struct dentry *dentry;
 	char name[32];
 
 	if (!fuse_control_sb || fc->no_control)
 		return;
 
 	sprintf(name, "%u", fc->dev);
-	dentry = lookup_noperm_positive_unlocked(&QSTR(name), fuse_control_sb->s_root);
-	if (!IS_ERR(dentry)) {
-		simple_recursive_removal(dentry, remove_one);
-		dput(dentry);	// paired with lookup_noperm_positive_unlocked()
-	}
+	simple_remove_by_name(fuse_control_sb->s_root, name, remove_one);
 }
 
 static int fuse_ctl_fill_super(struct super_block *sb, struct fs_context *fsc)
diff --git a/fs/libfs.c b/fs/libfs.c
index ce8c496a6940..d029aff41f66 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -655,6 +655,19 @@ void simple_recursive_removal(struct dentry *dentry,
 }
 EXPORT_SYMBOL(simple_recursive_removal);
 
+void simple_remove_by_name(struct dentry *parent, const char *name,
+                           void (*callback)(struct dentry *))
+{
+	struct dentry *dentry;
+
+	dentry = lookup_noperm_positive_unlocked(&QSTR(name), parent);
+	if (!IS_ERR(dentry)) {
+		simple_recursive_removal(dentry, callback);
+		dput(dentry);	// paired with lookup_noperm_positive_unlocked()
+	}
+}
+EXPORT_SYMBOL(simple_remove_by_name);
+
 /* caller holds parent directory with I_MUTEX_PARENT */
 void locked_recursive_removal(struct dentry *dentry,
                               void (*callback)(struct dentry *))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d7ab4f96d705..3a33c68249e2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3628,6 +3628,8 @@ extern int simple_rename(struct mnt_idmap *, struct inode *,
 			 unsigned int);
 extern void simple_recursive_removal(struct dentry *,
                               void (*callback)(struct dentry *));
+extern void simple_remove_by_name(struct dentry *, const char *,
+                              void (*callback)(struct dentry *));
 extern void locked_recursive_removal(struct dentry *,
                               void (*callback)(struct dentry *));
 extern int noop_fsync(struct file *, loff_t, loff_t, int);
-- 
2.47.3


