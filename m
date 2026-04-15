Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9419DF428C2
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090866B0088; Wed, 15 Apr 2026 14:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068D96B0093; Wed, 15 Apr 2026 14:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC19D6B0095; Wed, 15 Apr 2026 14:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC1636B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:45:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89CAB1A05DB
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:45:55 +0000 (UTC)
X-FDA: 84661669470.12.73B2D95
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id C54B68000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:45:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sfPfexTB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776278753; a=rsa-sha256;
	cv=none;
	b=fx5MICsO+U5rif/xht4FJujiqYhnSIB3HPhAQMHmpPflywShF9hzVX9MZ8A+rymiGQgeXR
	EtCro0ke7MuTOPFfua5z64+IEh7TA2gCbx1VT55AAfXP4xQKDAATkqV2sKnh9WqVAxkL13
	3a3h+bf6k/m5ps6ml/htbxlMZWdCTfg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sfPfexTB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776278753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sOoG9NE6Osa5/oH7LSm8JFnpzmfcQ/eAf3R+ydFAr6c=;
	b=PwKpXcAXpHHITIi/sh/KqJWh95mAPy0olubmB5kY2u4zkMbSMecmQEt92SsIZ9eAIP6Iyk
	2s5Xn0osy8RejrOUb7Nqheg3vhVKCVwEVWtNUYi2CO5M7rxI7x70sfIlDNxDeeAtFL9w2v
	iF9maKM5cLogITfn7OkFDr6+xoh6dGE=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso57520965e9.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776278752; x=1776883552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sOoG9NE6Osa5/oH7LSm8JFnpzmfcQ/eAf3R+ydFAr6c=;
        b=sfPfexTBQo7kGXnpXjOnSIOzRzV34Sc5WKFOEOMPmEuqb732UfmHtFyAIdRZoNQgLT
         LWWDs2rEWQh+JOnNRtqBi7g34LcenWPagWZp6Y+EhIdb/k/Hk6G/aap1rA9xhlURfa18
         b7kB7tknii+U2pEg96ZjHqnFbiNJOkfVj27ZJq4Ae8a5AdW5vd2W1vAwrp1+8HRsatje
         BeNjx7L0RaNXPadxn0kxQZWiJGquodJaIOQF6Sscw/gwSDABwGFLHy+Vdchf84lzMjeQ
         tmDTF+JFxm4/u5BeHkWgVSgEVNYUwq1pA8xtAunBJwoutqLZ3lkb7aPUztxDTLgKwYy9
         ROWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776278752; x=1776883552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sOoG9NE6Osa5/oH7LSm8JFnpzmfcQ/eAf3R+ydFAr6c=;
        b=myz0CAwKeOCXjpuhhO8D0tsCI3QiukUZr57x1+sE/Dk7kVn2N7a64BFqNZaLQPv9m+
         rIDxQo6rKRnUd3T7rJ2QuTTgRzFlkbggBrjAt1iPkqL4EZIuO6elh9P0ZElmKNDYT+O4
         WJtmly4hnxTvLhcboxXcPa9dAXYfzj4jbgZRr3MjbygLa7jyPDgpNm9ODFtsxDhpArWD
         OfB2Qck2oGfndLCxVNOdm/1xISzCoKQcUvvbY9eJwbkSm0rD+CMvRWprjLaahHGy4sqH
         DPQ/8HUoHF8eLlNp+5h3hAh30Wcxw2NsOtPs4dDCPcWJHAPQJKxHUvNHm7ARJYR8mdZU
         Q8Eg==
X-Gm-Message-State: AOJu0Yxi4hHd4x5xeMKEo9JbmadaJCi7Bs/iUBZCRTCgrRBdEeBPVZ4U
	I6UbmhwTntbZOfWSYsyoJTIeTnQUrQCS4kDPuYyUohxRuOpgDQ0VDctD
X-Gm-Gg: AeBDievml/LqiQn4BWCfVjFwlyXipCJghU2xi5fQRZXJ2lUJH/EDTdV5vVnQjqkksQ6
	uYkY80A1MP0uTU0h2BGlcZSjIBykjI3SdcK4JNU9K7irTdOB1qQAz9b0LY3MXvLmbCyFWk0yfW3
	BZ7kefAsg3jvLgL+MYcQWgTp3pdnj61BQiAQ9zouST+qMlaz+vRLCFTN95JpYdpyJEXxXJPexS+
	By2eNvS9Lc7yTD6mBYbLn3eOPYWMmiBNRJ2fMxF7L8zqzCSauUV/PhR+bVwgeGJZuRycMmFU1vW
	SNSbeZrEVwi9vz7lwnGawe/1SLF2VV4A0q2waXJBxP3OTfwjVKow818K5goJOMgA9GGZ5cJgg9F
	yNYGOxdeKZcvSCyRFsdUR6Uj4X2grq1sn9epoGGxV2yQDIkPhych2zVF7aJfiLez2zcM5/yyTrF
	tY8XUutDraDCEoPCBZZ4Hvt+7ht1eGGsWfsqHPrlk=
X-Received: by 2002:a05:600c:8207:b0:488:7a24:9ddf with SMTP id 5b1f17b1804b1-488d688dd31mr309324205e9.28.1776278752017;
        Wed, 15 Apr 2026 11:45:52 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:1648:8c4d:e867:9ebb])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488f0ec6cc6sm26153255e9.29.2026.04.15.11.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 11:45:51 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Wed, 15 Apr 2026 19:44:57 +0100
Message-ID: <20260415184536.1155220-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C54B68000B
X-Rspamd-Server: rspam12
X-Stat-Signature: yfwy4qawg85fqc95ddstcjf4gdzq36po
X-Rspam-User: 
X-HE-Tag: 1776278753-436414
X-HE-Meta: U2FsdGVkX1/4GGKfBy0Uoa6VaZu5BSZ5JBifst95AhsjnDFpTjW8Jvdj6YWR1DO3e6j7tm+mtap8V1TphuZrS2/3cryAGZehchJYqguiGSqhMRYPIm3l9ELJC4uZ0g10Wl9iqWbzTeJMEkd8vx0ma2NAj2d6BiFTa/vgRi41d1FOurOq3HaCm8XOKFTdJD9wabEXn6e9GIgDLOvWVhycCLFh/PRPT/YXyrwK/RKDLgfcY5kIEHbZ1TxMszNblfJv5mXheXq9v9cbTin2tyiCYipRG0wePIqAljTXjyvFO42yBT8Df2l5LDnDENgqIChyOkjJxO9FIXikTDP0TcGgrMWknwJP6FlPX/CGjQvzl5chmc5zd5shB1iU2gHrCd3d3TaqS8xCGkBuAztvX2Jf+XdfODDC1kUnzeKP21pDABUGaeItbaV5clGVuyL/JeD6FA1RSVOp6BxtagOQNdRA5a4V6RzHLHpd0qlDB7rg0ujRFCjlinEUxWuCEZ8baTmIf0Yb/za0DLkaiR0K3ZbXauK7ivRfxUn06NpTDg98fyYPmgAMen2L0gSn9bdDZWVSZe9nasSC4EQP8M9L3+f0rU+iyPnzrwsksJ9fmgclEuqwUBHi6SI7C38IeyDk8lm1EEGwjdxS/PMe5I/6J5W9M4WI5nU6NA2Tg1yi0xCt9h/araqf1DJodjwkBbqPD4YG+aaBN/+DW/JABPFOyCLDV6xJVJWhuxlhy2JySl+5zsbfHxCKtRnjl0iE9APeYzrUWc1kqMY2XiUWzCrh2Fkq+Fjk5L6ALlsViyM68FaksA5Y8L4StAsgevM8bTF60m9TmuPzwBonsvcm1ZRnDqiYU+UWiclfFLvFObAkqITNyut7yB2o45UU74rALCsJrYU1UsyBNM3NAMsqbN8X0hxTBTul1oP3WfOL81f9n8hLkYwyYtbZE704cFMHTZblvMQ+SUEMlTcAwzJq1gT5sBr
 NFyYj7oi
 B5UF/lh77rxBM0N9laSeU61aOn5fOoHfzA8oRVOcybYJLy71DCrpMBaOQS7lSvPS5OKw1EUyLuy/TaPNcEiU7ihWVYUK1vgIvjo0uuITsQ6gBghCtTQ4LZKrYQQjXYufkqlXhmAYBD8UqLxjEIwr5mkfT6z/YbLG7a6Pz5YYGMJ0WD1m6uUrUsKvtdefy48Y4IeBk4//mZUEi1CY6Anyl+KZyXXzAI70mFbnalGOSzUel0h9eeMM2gpWoxUIpmZ56OxBvfZFYlPpGUwN9m84ClBuSwOHGamWYqrtJvCvRdOH4kX2TNFn1olMUpsyzLCgjeBcIkJ2fJHRRs+bjheL3lKMkVebXcUfwjnaE9DBZT93U8x29m7KytlculY1xtNdV2x54B87acEluJJeyMBO9kOuf77MUQxOjiqjtuy3ozF4267C9BsIww6XaeUZzWXp87XMP02SbWnouKGHl8TenhnnICij1zshp/ExtZduMFbnhGF6iJLUJrYzkMmf1qrUiy8FjlLC+VP3zQR2dJX9DFcP/+VZic1ZQcruJkgfrx9AMV3pBEXuwNC8gloQ0e7Jpl1XwlBjxVV5SbYJaEa9s8vcFomBDQiGa0CBVXRHPyUFXLWcQP9WuIxfJptoaHpuKGEkWo4SpKrUbhCyzdmf+XylABzVeb/MLx7Xl
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
programmatically identify a fd as a LUO session via fstat().

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
---
This was requested by Lennart and Christian when discussing integration
with systemd for LUO management.

 include/uapi/linux/magic.h       |  1 +
 kernel/liveupdate/luo_core.c     |  6 +++
 kernel/liveupdate/luo_internal.h |  1 +
 kernel/liveupdate/luo_session.c  | 67 +++++++++++++++++++++++++++++---
 4 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 4f2da935a76cc..4f51005522ffe 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -105,5 +105,6 @@
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
 #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
 #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
+#define LUO_SESSION_MAGIC	0x4c554f53	/* "LUOS" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index dda7bb57d421c..ec00c681a0f50 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -197,6 +197,12 @@ static int __init luo_late_startup(void)
 	if (!liveupdate_enabled())
 		return 0;
 
+	err = luo_session_fs_init();
+	if (err) {
+		luo_global.enabled = false;
+		return err;
+	}
+
 	err = luo_fdt_setup();
 	if (err)
 		luo_global.enabled = false;
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8083d8739b093..223a9dc1ca29b 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -79,6 +79,7 @@ struct luo_session {
 
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
+int __init luo_session_fs_init(void);
 int __init luo_session_setup_outgoing(void *fdt);
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index af9e498206d24..fbc4b32b39cb8 100644
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
@@ -376,18 +378,58 @@ static const struct file_operations luo_session_fops = {
 	.unlocked_ioctl = luo_session_ioctl,
 };
 
+static struct vfsmount *luo_session_mnt __ro_after_init;
+static struct inode *luo_session_inode __ro_after_init;
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
@@ -662,3 +704,18 @@ void luo_session_resume(void)
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
+
+	return 0;
+}
-- 
2.47.3


