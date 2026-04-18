Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A78EF99C8F
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636ED6B02CE; Sat, 18 Apr 2026 12:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F236B02D0; Sat, 18 Apr 2026 12:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE2C6B02D1; Sat, 18 Apr 2026 12:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35BCA6B02CE
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:34:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2C241A056F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:14 +0000 (UTC)
X-FDA: 84672224028.24.C93BD4E
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 247BD100006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WKosdqIF;
	spf=pass (imf14.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776530053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDd2UIv043iC7kIf40D4/RY2UYV+v4l+fWgRNClaM/s=;
	b=1oNN193YS2VFN4UHOsoID9UxCUeBBzoPCAFb46KFmOpc20o+5Qn63RnYZ9Uggfs3UvAk72
	Ef7B1fLBwSAfW/CI5pIHEbZLTvRIDM5Vpkb40Zb8zly7ZME/n9VQ01O7xLHmwOsYnoLrTO
	QiBgjhguMisRN83tHKp62UQXcPK3u9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776530053; a=rsa-sha256;
	cv=none;
	b=FQ+iF2OKHI+2kzfjG9FV02OjjCeLxiYAhiYS+VHZs6wG7pBudofdAZ9BGvxOS/I4EbH6XK
	QI00zohKVnSW9mWhQt4MFECVngMyvhRzCWpctgWhnV6Q3XFqJupPzdLzHiWOMjnEcWpotI
	0qdmM0oKOitSWP7GRQ1SMDz3cQ4O1tI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WKosdqIF;
	spf=pass (imf14.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so24455055e9.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776530052; x=1777134852; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iDd2UIv043iC7kIf40D4/RY2UYV+v4l+fWgRNClaM/s=;
        b=WKosdqIFGhljotdLOuqfmyXJ58MscYnDKmUVaDw77gaz/bYUAJbjgHarSh7T4orEhS
         pWIDxIExkjj/qFnExtp6ygAT2dQSsDt7pMy7A6JZyPIqdkIKyaCmj8MMAJP1jGpFJ4OP
         hfPkVBhielA3eGhWlbI0PSS8FP5PkUGWlh2xtT4PVH6MKXlt+EzPrnwZGjvNWCmw/UGq
         WIv5XADlXO3F5pmcbRrFbiJ68RimYqXtAP0Y50PomEXJ77hfH95ft6lZRXJcb9yydIFV
         MNOgy29zKR7vvKj5eYJzhh8HbkMdofGF57GaLL4yPEeVVdl2zWU2QeHhYRzztGSvfTHe
         jT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776530052; x=1777134852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iDd2UIv043iC7kIf40D4/RY2UYV+v4l+fWgRNClaM/s=;
        b=HjfznUmKk9ob6AHrXjKE+IeWVJ+LE34Yj/v8lOzrWb3ojFGarJMu20V7i3BnZ1gfMx
         2qZ+1nMMm4LZaSF2Aq7Qu0F9a8hmwZgCNWRXmKU0tJsjO0dC0gIUsBgZmbdR8LdO4tHQ
         a4fjAAwFP36MPZQVfCxs28dlh6ECpaowds6dJCETyH8d8k5+u0Y8g91uCx4HOtHNEl62
         W7yLFmWmq5j75dlWLF0TW4n1CJZj0qof7xnREVl3LEEpkV4Ameag8OJrgka24gVYrnES
         uCkxANEVtdSbbMMWxOcGfGtBXeEV41LOy1wsprl1RZBYAJec8KYf4paUMYCEbd8qT43x
         p6QQ==
X-Gm-Message-State: AOJu0Yw22w/4MITUltYW+11JcEJqMUHKiqo0hKuh4LVTPGCAirJpz12y
	WsfUX4MA/u0TBkuJG50STBptfDrBTYhpXdPhZ8WWGimskPJ5CiLbK2fM
X-Gm-Gg: AeBDieuyyfPQoWBjRsFvsfstpUFtMNl2XE7y4Fk8tRsWT3GOz7ta5XaxnSA16Jw1V7G
	LPc0gjfXs5gw8ZfU2tfqFYChpkV5hiyb2nMPXA5RqH0L8WVD+v+zQ3R1XuHt7GQu1r4ojZPuX8m
	Bm7F7xZu5WHqDDQGAtaXJsEPTFtAqGzEbDC4EUAM/EfTeNfBGL2xyEePUUXx4w17pRUBgiwKPHV
	Xy3+9Vio+3+wY3oy8z/8xOR+qq/gRZD1/jGlSvwDBBG7oUn3KaTI2C2XKeT3sxaWC4YbiQvtZRh
	khXYscwpMrgsuC77zdFwwNtNPTex5KrDdFKwFFOnfGqlVwwW1PMHVipxqOime79BSIwIcK6JN57
	hW6S/TiFJDv+BHnaZovt7CRtw/HnGu8It2zezs8Ezf1BP3ZjiAVgFORdlI41bOnF1OoCzRyjziL
	AG5/ww1RNatwssctMspN6qq8cclmD6PXV3SxGgAU6WbyW6I4s1Qg==
X-Received: by 2002:a05:600c:8183:b0:488:b187:3c with SMTP id 5b1f17b1804b1-488fb765ab5mr111343235e9.14.1776530051601;
        Sat, 18 Apr 2026 09:34:11 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e054:93f2:97bf:84c6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc1c96b4sm229038205e9.13.2026.04.18.09.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 09:34:11 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Sat, 18 Apr 2026 17:28:20 +0100
Message-ID: <20260418163358.2304490-4-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418163358.2304490-1-luca.boccassi@gmail.com>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 247BD100006
X-Rspamd-Server: rspam07
X-Stat-Signature: yty9isxryc8dob7attreas6rekryxac8
X-Rspam-User: 
X-HE-Tag: 1776530052-426099
X-HE-Meta: U2FsdGVkX18nJhjXOkdi8/GcLGbePpxiPCFTj8/rIBM2k6aU9YZzJC0uELeY51l1kowstLpqxH4OGcnrfCFx4kSKnJ9H6c4NmJhx83EsnYhprTa3z096kZ0Sh6vZehKFhlEwF2uZrMS4m3Oe5HfdgCrG2a3ZrWH84r2fjGUIG9CnAH0dYe0B2/MY6Jwq1BBxtNWxntUyYNAMJuhle1DoZL8T7VzZJ3QKYqNc0xo2926VpFCKTIu7+QXE4vHHMiAFgfDQ4shoXHCkNyQq3TUZ1M6f3E8+uqgitBPnHTJFefRn5Jrdl7uEGsLL9HiH4QQSilCWRJtESuT/BrG0Mq8fmLytIJV3u4rAzHKIXDZ0l1tS8L2BRdskheIyp7V2GOztgo5Tehn2YFLzwF1iTRsYB9Xb19bT4OmhRmcL4Oayod36YGN1LEE2nOq8o+TohcA62p7kvLVZSEeoVYZZytjEr2Be/DELm1iPJaq7JLm3B1R1uwiUF/TZ+buC6MOX4dhjgIAOfIkfMCWT3MkAmzUM1oyakH/UJ1Q0Em2gKAQig3XCW8ZnvhN97x7RTWCswe1tNf53vzMX4vIWCK2gCBj239kS37XWA10EWEZhrht2/Q1muQ5TpSy4j1VUwKgU29WZDwMxH9WQJOzxjQPxRVdrX6/s4c/Jed0b2o4ML83jBPkYwlZB8AkE+0sNziHuzaJNOOvwml13rPq0twWBs1WQTU6vZLnOaXHinVZrUBVY1QPw9fsWEvw9ZFOnngbIKBacc9dtwoZ6WpUnHMjO1QUhcA/AsHugVTA6lnkR52YWhjERwKlyOPmZOctk6H4Vmlj+X0NZuySk6XTzGXEMoNhV+6vNJEWEpQ6Var/xY7iqe/1N1EfK1alU6qolOQvmUlLHrpeDKCS81lKZMUzlmuW58BQjWHX0zFjRD+XvH6siRkTqw8NKp6QFkQtDAz3mHXodzCmxYx4fDGitn7lJ8HM
 au6GAn9g
 YZ6RMh/PhbJh97KLE43FI1S9veGpDWWqltv1aS1TxSjCKaJFph49ixavQ3+pXlSq43dQcRF/IAPIINH/ojudaEmhHMsmKfmumI3/3GpZLczJ1CYUQpjVara+TIibsqwOKrI/OkddJJglqWjtZ+lngwAHx3QfI1kEFDwoHFL8siHwdOr3S4jeLDIj86j3wDCXUUN3TXyWqBGgHrBonQVTp25lYfUHL1sLUGltbuFs/hDy6Xkfo7D0Zu76kU+POWGg9izdJxNxqgGrl6GHZ4k+Mls4+8unqUsCMktbF4Vq2MIQA5fFW8FM+2oRvTSsVJIuwm4Ay4m4TuYfO5UYMiMHlE9cQPnd5sARSlo1pCGqMCu/9nIMsFwLwpAyVvS355VvtQz4PNI37ZPrTjfbFw9rXG3a5JEVWF4WEmxbNyT/WUmbjwl4lnPRRuuAlQAfJERZVDl723TqPAdPapUt1JK1gUlqpeVIwcGoZJzkzW2GByJlyaxHQ6FgbpkCENP5cfvVM4byKT4AOqZbUXfoJHQwRnkqMWmvoeCNkjjzIE8A6z4skMs+52J4HlCI7iNAZkPFPCaKZsVad4TUTgYRH8PV8K4SOqDTpOBhteDDHUmbxdvQqiLOZ2EalBqdIYhwGpCuB4iMfEKl7nTp4rqLksIG6tO/uCwfNVz+psLi4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

In userspace when managing LUO sessions we want to be able to identify
a FD as a LUO session, in order to be able to do the special handling
that they require in order to function as intended on kexec.

Currently this requires scraping procfs and doing string matching on
the prefix of the dname, which is not an ideal interface.

Add a singleton inode type with a magic value, so that we can
programmatically identify a fd as a LUO session via fstatfs().

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/uapi/linux/magic.h       |  1 +
 kernel/liveupdate/luo_core.c     | 10 +++-
 kernel/liveupdate/luo_internal.h |  2 +
 kernel/liveupdate/luo_session.c  | 89 ++++++++++++++++++++++++++++++--
 4 files changed, 96 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 4f2da935a76c..4f51005522ff 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -105,5 +105,6 @@
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
 #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
 #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
+#define LUO_SESSION_MAGIC	0x4c554f53	/* "LUOS" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index dda7bb57d421..f1a63ebe4fa4 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -197,9 +197,17 @@ static int __init luo_late_startup(void)
 	if (!liveupdate_enabled())
 		return 0;
 
+	err = luo_session_fs_init();
+	if (err) {
+		luo_global.enabled = false;
+		return err;
+	}
+
 	err = luo_fdt_setup();
-	if (err)
+	if (err) {
+		luo_session_fs_cleanup();
 		luo_global.enabled = false;
+	}
 
 	return err;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8083d8739b09..d4ac7b4c5882 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -79,6 +79,8 @@ struct luo_session {
 
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
+int __init luo_session_fs_init(void);
+void __init luo_session_fs_cleanup(void);
 int __init luo_session_setup_outgoing(void *fdt);
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 5e316a4c5d71..21cbe99fc819 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -50,7 +50,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/anon_inodes.h>
 #include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -62,7 +61,10 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/liveupdate.h>
+#include <linux/magic.h>
+#include <linux/mount.h>
 #include <linux/mutex.h>
+#include <linux/pseudo_fs.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
@@ -363,18 +365,73 @@ static const struct file_operations luo_session_fops = {
 	.unlocked_ioctl = luo_session_ioctl,
 };
 
+static struct vfsmount *luo_session_mnt __ro_after_init;
+static struct inode *luo_session_inode __ro_after_init;
+
+/*
+ * Reject all attribute changes on the singleton session inode.
+ * Without this the VFS falls back to simple_setattr(), allowing
+ * fchmod()/fchown() to modify the shared inode.
+ */
+static int luo_session_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+			       struct iattr *attr)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct inode_operations luo_session_inode_operations = {
+	.setattr	= luo_session_setattr,
+};
+
+static char *luo_session_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(buffer, buflen, "luo_session:%s",
+			     dentry->d_name.name);
+}
+
+static const struct dentry_operations luo_session_dentry_operations = {
+	.d_dname	= luo_session_dname,
+};
+
+static int luo_session_init_fs_context(struct fs_context *fc)
+{
+	struct pseudo_fs_context *ctx;
+
+	ctx = init_pseudo(fc, LUO_SESSION_MAGIC);
+	if (!ctx)
+		return -ENOMEM;
+
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
+	ctx->dops = &luo_session_dentry_operations;
+	return 0;
+}
+
+static struct file_system_type luo_session_fs_type = {
+	.name = "luo_session",
+	.init_fs_context = luo_session_init_fs_context,
+	.kill_sb = kill_anon_super,
+};
+
 /* Create a "struct file" for session */
 static int luo_session_getfile(struct luo_session *session, struct file **filep)
 {
-	char name_buf[128];
+	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH + 1];
 	struct file *file;
 
 	lockdep_assert_held(&session->mutex);
-	snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
-	file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
-	if (IS_ERR(file))
+
+	ihold(luo_session_inode);
+
+	snprintf(name_buf, sizeof(name_buf), "%s", session->name);
+	file = alloc_file_pseudo(luo_session_inode, luo_session_mnt, name_buf,
+				 O_RDWR, &luo_session_fops);
+	if (IS_ERR(file)) {
+		iput(luo_session_inode);
 		return PTR_ERR(file);
+	}
 
+	file->private_data = session;
 	*filep = file;
 
 	return 0;
@@ -653,3 +710,25 @@ void luo_session_resume(void)
 	up_write(&luo_session_global.outgoing.rwsem);
 	up_write(&luo_session_global.incoming.rwsem);
 }
+
+int __init luo_session_fs_init(void)
+{
+	luo_session_mnt = kern_mount(&luo_session_fs_type);
+	if (IS_ERR(luo_session_mnt))
+		return PTR_ERR(luo_session_mnt);
+
+	luo_session_inode = alloc_anon_inode(luo_session_mnt->mnt_sb);
+	if (IS_ERR(luo_session_inode)) {
+		kern_unmount(luo_session_mnt);
+		return PTR_ERR(luo_session_inode);
+	}
+	luo_session_inode->i_op = &luo_session_inode_operations;
+
+	return 0;
+}
+
+void __init luo_session_fs_cleanup(void)
+{
+	iput(luo_session_inode);
+	kern_unmount(luo_session_mnt);
+}
-- 
2.47.3


