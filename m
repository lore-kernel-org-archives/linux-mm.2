Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1C6CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D578E001D; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D108E0021; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980FF8E0038; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3ADBE8E0030
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDE321603A9
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.10.3C3CE46
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1496240013
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=IjzD6SZN;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=aiU6dD1tTQVk8MmBR8oPaofIzRUr20bMnbH5PjEQjgv0CrtGqNdQDUftBYJL5JYqzMv4SJ
	P5/TgiJmgs4ljoLJ9evNJB2VKUXcqFfdohFQX8ODTb8NrCvScY6O/L4fhZXGWabmp9Tar/
	J5I5e4G3kgioETRefRVvyGjdTn8HAuo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=IjzD6SZN;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4Rux38+4wafzrtHIPx/pAtSqJiq0rCT3/CghgJ+qB0=;
	b=MnZq0Vg3eERqTXdS3HOUA1tFUVIqWuF00+G4Coa6Cq/yXNLi/Js8POetlRwVYfmjG/EzG7
	ixC0PzrDr4EWmVARpgihzG4nMocQ3zFSRcDOmEnv7bsfARJpU0OGSEqJVt8RmO4DWDvi16
	SsT2JgsbAUBXdKqSUSCPju8WMl8jaxo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W4Rux38+4wafzrtHIPx/pAtSqJiq0rCT3/CghgJ+qB0=; b=IjzD6SZNXZ75C/fjOmEaQfJprG
	st1rZe+yTGOATslq/EHEeNfCyI3fQTgrrCV/xwDy09PJSc20HZ9/ok0I0a6gCKmEXdF6E8xreFNhp
	OgidLo1jv4DB8vfCPjI7+oGZVX3/oxkW1jyzqdo2J6X/UdDJYlW2D3R3PLUowglk9et6/yxJjtxYZ
	KNTgNk9hRf7Szz3u6z00J01G2unFzLttC/ER2KnYlhR10MLCFBlSJTocJz2mk767MUGk7sNN/rxqv
	o/P8JiVlYvDsCT5f0UsCsVRKt74WvBpr3DKdGHm8BMKE9Iiy6gn6+QnxHbtC7Bfhkk0QlZ5G0yBJ+
	3ninlNHA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4T-0000000GEPt-1rsH;
	Tue, 18 Nov 2025 05:16:05 +0000
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
Subject: [PATCH v4 03/54] new helper: simple_remove_by_name()
Date: Tue, 18 Nov 2025 05:15:12 +0000
Message-ID: <20251118051604.3868588-4-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1496240013
X-Stat-Signature: bywqhaam83ijejszt43qxwt3i4wj7smg
X-HE-Tag: 1763442973-981594
X-HE-Meta: U2FsdGVkX18Hd9sD9drLYCzoWVRSXYJKN7leZEBgU6uivIURTAml6b+bUI5Afg5ZHSot5IowrCrFO0vGOeY2Jy3yKzCvfhWHH+2asN9mDMKwHRD1loRxhoCWpeNiYDOP1LF9VLKAq4iozjvAqefcb3wSY6YoThND9s4PBNBTPT6KC+KVSsDIDhNm4HQf7IQtnegupbw7IjLtnN3eb1HK9obMoObLq0g212/mn2dPyqSgsDuAQXLgcE51Iv3hQXhVfb5dVMVEYtpNVDNX7Ejxnnlmey32qZGJAyI0Hva2PtUJSVvQd95dcmidbzJdA0EuTqsclh+Sk1R/5VU72OknghrC5/Uk5ug4QH0JVviuK2UgG1kLYoKt28OGZcZZQw2tFpiP21/jBWoq0x//r0ivjCAWzjfvy/noraqFW8hThZXMX86UZW7D7MOnmTTAaBPuGzmd63s3P5NcPMTdya4ohXVZvSFUa+ptzJxu3D3saqnx66Ind+xGmAub4UNz0+YKxrKOlzOmPX+E3oqEPPVe5CZ1u2WeX6ZqTxF5mnINt591kVDbbrfGCS0EeiFkh951UVlu7aXBRzw7nhNj4pMuCg/WgzGHXFXNfq7E5VA5yYaOSO6XuHXfcK+byKZ9cf0oARAbag5QteF2+jWsyybcK12yD8n9aP39bAwZEjwQaAjrA4awyIDWyAQws1Plxb0sazmqhFdYTlqRWrP5KQg9/FQ1ibnyPFeqLd92hzzrnGQJb1h86jh29mbb40pwrRMvo/WqtRXu+EPY2vYerZQo7WTBwokSuHgdbxp3Xi/GoOmfAThgp9bkj18hp9T73pQcsmz4TTtR+tgQlOPwRWxu2xBSreBCpI3KFbIr0PbWu7V9JN91iUw3OPzQ8TKlviehTD0BlHqYmJKPqVVhtpSoaCfFJjyV0MHTQOdJewbcW8bmtbTr4doDXcvuVUFjYwdlNpVcZ90xG0p4aoteeaL
 870MgiN2
 t0AJtq2/P+gOT5XHCJCvK6KzlRxG7w5lcCIbERJ4KONyF1zh59T7cvStBZRQgYj3+3gaWGmZ4ne9X1tIu3Gp9Otn+22sr6Nr9gh/Z3wEQb85hp1iRtys2jE7Hm95GgpGbDfjNOAMgJkn+OEW/+HQb8JGEG3DKzM/vACzI9WB4Ar/PYosbLVGv5v63uLCB1phVUd3T8K49goli4OW7EnBY2QVJe1P6QhB4fG7XeIDZFPniZtxR5jDqc50kuTENHU508TgFvkdawEDgozT3jo+iGq7tkmlfSRKubljX6MavEnOuW+EOc8aRnZ0XZqFuUEPaNQ2tyTukA8Y7y59v5AgGgBA5GVdVAJPZ6fFa7+ZDguYH7Meo9dh4CRNxHNMWEdibEm/v+Lxbv6BMgDLl/6o6S/Qoa+cVeKTQHSGL0o219AZKO8FlV6Y8+A8mcT+671wx2Hdc
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

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/control.c  |  7 +------
 fs/libfs.c         | 13 +++++++++++++
 include/linux/fs.h |  2 ++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 5247df896c5d..3dca752127ff 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -290,18 +290,13 @@ static void remove_one(struct dentry *dentry)
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
index c895146c1444..28bd4e8d3892 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3631,6 +3631,8 @@ extern int simple_rename(struct mnt_idmap *, struct inode *,
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


