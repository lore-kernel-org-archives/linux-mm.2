Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13C95F99C64
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 20:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CB96B013C; Fri, 17 Apr 2026 16:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413BC6B013D; Fri, 17 Apr 2026 16:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302CC6B013E; Fri, 17 Apr 2026 16:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 177DA6B013C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 16:40:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87384584F1
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:40:47 +0000 (UTC)
X-FDA: 84669216534.06.AFA73C9
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9A7E120009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:40:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MA8SmgJA;
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776458445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4EPT7zWcCinytY3BaO+Twey5rBa32BGFjr6gRfkUHZo=;
	b=ad+fhfjSUDxfp0SZRA8UIaDahxISIbiFPbe6X+wfY/m3Mor4ppnwz7YbjM2y06BIi5QuL1
	JyO5VaIrMO8TfJsgaJduk+Z61Ih89mJtC9gDBXK7IvZJI1zHhI1Yg0WeVID8DHpQY+toiu
	4NxXJ+q61LmwcGBEtYeGJdqEHedqqLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776458445; a=rsa-sha256;
	cv=none;
	b=XCO39o35Cn2x16xgBzLc4Y2JR5QDnPFagBYUVSsfnTmnk2WP6MioPoGBb7tdaUPMjifsqN
	RjkclkeReCATAr72uKc2Qs22TOgVLvGNiAXC8hzszThhXr4eN+EpxFVzKZIuuZEp1TJjSX
	L8JzfBJes74BoHjKj2B+JPfufkFitEU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MA8SmgJA;
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488ba840146so11269645e9.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776458444; x=1777063244; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4EPT7zWcCinytY3BaO+Twey5rBa32BGFjr6gRfkUHZo=;
        b=MA8SmgJASxZxcuQ1FT/CUI0fIBfRJDE+8et+zrrMrqJVq1dqZcOMw1C2gutI8gKE14
         5jKblkLjR7EwRtJAPb6lAglMPLDQljiQRSPXrKJt0dhIcKY76FTeRwkhf7kZO+WBuSdY
         5/WYoZNdAxKLz71v2eGAztFr+n02RADcKBkxJPKoukgU1INNVm/p5LZWTz4hsfMyzrXk
         urM7Y7tOzYtlJPLbkWyrDOJpjz77ccH0dA0JsdCHG4yJ9JOmCN+MZdlWuqdjruM8Lo+T
         W9HSHl6razk3uWppiZcH5q9jaXrsplVW2a8vN56RdwMhIOGw4Su4brGcmo/S/WVcp9iS
         4ruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776458444; x=1777063244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4EPT7zWcCinytY3BaO+Twey5rBa32BGFjr6gRfkUHZo=;
        b=R4ythSqhuSTYhoa4MNz+mATEphc/j183ls+4sIhKTwdyDAaBL41WGgsTUWsnwtHrhe
         4Bi4VxOHeFUVxRMsB6nBaAWLppiaxc4NAvVtjMrphgR94uQYI/edPYnSBu6itQjnGVZ+
         rh3/JBcU7eCy3mtX5RMtZtaDo0rTLyDBO7PB0tHu8NUCwzQ3xhFAP2bvZ0Urb4ZO3vCp
         JpEehVhrSsrni0U+Sn06xz+vn9ZMmWb2Q9/O8xLL7Wms7gZ3qlTuVkae2GAtR3VSZBw7
         swXsauKhFhEaqlKnOxodGxg7p5jy1hgF8Qy5SmP+sMpAJfmbpd5dfq/u6OPPI9F3ZmrZ
         b+Pg==
X-Gm-Message-State: AOJu0Yz1DOs6ok+tepr3SOOPLeOMQLxVYe+5VroNGAi2gwQeCaD4VmdA
	OMFtRpYym9gMapM2lRzqfXEWXLpXEel7IjScSb+G1ztIRfKhYNo0+1cI
X-Gm-Gg: AeBDieuPL1hTYvBMqIFcijHHW+T5awtL97yzcBvdkIbEfZ0DUZIg+c7uSIRcU2bdxDL
	phkasRDTkmuvQvap3OFrY+t+SCFDZcZaoXgiMGuVPwpjJYS07WDSxCbocvTFevo4gytCap/CCAf
	WuKe1IoB8yUaMZHEJ4wB1AE4x6aP7YYTrnXPk0CvVBnocuEP9UMkNCTA3D5p81uA1RY22AvDN4V
	16ZHs1sAsmlxd2zNmMEfFmNc+x7N5yMf0OJQD6Thu0n3wyE5/d4/w/Y5D9JUK6TOYVcg7PgB0z1
	DNWs1YFQMv/2YpHfzVKAa7eQPD+XRRYduzq6piExHm9+cfgBlhoQGKIv2N4Sg0r2l5wqKB90LaH
	scMaqvvNMG6OK2DFUWJI2tZIZ5CFOAKr4nWtgQ7d6UUPKPTDPjIBjYzS34GUQD1h0G9TfhrnlBd
	Sslx+p4r5zXY0rwpM7xUYx1Oy+loqEwwZfGn01PRg=
X-Received: by 2002:a05:600c:4e0e:b0:485:557d:9fe with SMTP id 5b1f17b1804b1-488fb74d67dmr62314255e9.12.1776458443859;
        Fri, 17 Apr 2026 13:40:43 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:9586:30a1:a0a6:f076])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc100162sm76043665e9.5.2026.04.17.13.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 13:40:43 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v3] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Fri, 17 Apr 2026 21:40:00 +0100
Message-ID: <20260417204039.1827319-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9A7E120009
X-Rspamd-Server: rspam07
X-Stat-Signature: m8i569cdbh43i3k1gqnmqx1py4jd9mwn
X-Rspam-User: 
X-HE-Tag: 1776458445-228742
X-HE-Meta: U2FsdGVkX1/1ZO5RibdirsE/V7ulq6BR9CnT7zhpTjSA0d8gGeJj9c/HqSKXEZKgBTrkW3rsl0USUY6j7dCzsDz1tbf+0xBKwuvIPI4qyiQAdTVhs2tgNTYQHfw2CtGipvHLLR8QddozzN0zOHLoHnsyE6QIt94EbLNFwoSBs3yCr0Rleh0e9Ottr+LagoF+J1oksMeaN+0U0s42AA1gCpGGCStMMTpxjjpwWF6qOorduhz2mx7eKpz797/Il4Th3VoSg7BYzpdajt/mByD2jNVA0HZGWTV3z5W2NT17G7V3Ejtx7SfYV6r+sw0bHxbzTIHnHHjsmZY26LRD9WNI//vyI8TLZiarizpA2IwBc3x8oeMsobJCUpaN1zlkK7ydfI0N0bmj2OpI6jE66X4WnsduKtrLol2g5+/rcQTr4JiP1q+Y9F53jpP/Duc469X9HU0InwRq89iGmt4C/1rDO0C0L6q9phl5QrkFdq6pLr4o3M4gA3SDMfOo1+r2UlqqyHHNkU0Qhlbl07iDZJpy25w13qkTH09n4dA1djKeMKOZmJqPOdw7SDJ1xxR2UNHgPwcQ4HAhz/ZxduvcF1It2pjYvzePSJ5DMApZ6BSvxnNZmG2RhRd4hgaGa10VJR/30htSFn7Qisum2T73xMBNrksKKkIkVu58oapHfAX/JY7Fh1iM5CUsFdnHRFi9pMnSgARaPn17q/j664Sglfs1hOyekFwhqBe41GFozmB/p5xLYHLJQqyUSe+YKGwkaEK8Si/Ocy/abicFqZJ/GaIFWxzxw9zd4Zy4MH+9KqNDp1YhYRoL4m2yVeVckdM9ljHZ3w0tKpGdcuzbgPRNFHy1He6h/bCGlbAAA6GC2P0YPDPMOggJClbSX0a7vd3SaC2FdxU2kptPxeTxvVbBdHPOBc7OvTanJN352z8bQufsSEuRwwaoLSOUBqE6iH1q7QNA+AnIMZNY+lQxM+Qx92f
 jfdlvs1+
 wGgKEm1WHp36E2Y3DC5jFJ8tu1I9T3a1rS6I3zc4D+v+3IUlmDXI/aPKnFiJ4OMR0k9XWQDWUkFBoLJjgeo6NG5Ol4K4TIASA+jMZ+tczGqP1+nEudJcXi7BuALGzPdRStKljg9jVWVjpdtO1XABRibTylCesdaNtUzz7LoW6FOY23aceITbAkWyFU4IDiWE+F5cqpTw39r8YR60ICkPfuXKcfBVBD0rAYyC9afkgqySadFpBjgN7mozfHxUbDu5gKTCvo+dVqRXZkiZ66QlEBNaUu5xumZxEjBoK/HnAn6DCnlV4y5PHfkVpsNq209pEWVOyt5l9dT4xvl9NH66hYVqyEU/kBDhfNHOQA43sq5TGVMng+aUFP5/nJXKT8uqrcStbMyOz9qa5yJepqqB/dYq/4cvwr0bRlmMgwpRnonwGptxGS32lL0/fGMSGfIQLIvdCuKdFEyRbQBc8CC8U9b3YDY6q+Y9wAj83gSXcEcLvgnxYClSi1fLFGk9jrS5vDQ4dLqQKDIKqnVibyW0u1TwaIOD/eD8LgYUp2LQpO0bWY5XW3kwllUIEQEaplrxuEpH3JCV7v8qO9im0lMGe7n/37rGwmpebJXHt5iviswMSzEw/4AhkpIARjO4EUlK8fa7mzv4hEcUkLyI2mobinz+YRIEIMjP24Etzz7RmDOED1HV++SCWDFQgNQ==
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

v2: apply one fix from bot review about cleanup on error path:
    https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
    the other comments are invalid: luo is not a kmod, and the write hooks are not set up
v3: add test case to liveupdate selftest

 include/uapi/linux/magic.h                    |  1 +
 kernel/liveupdate/luo_core.c                  | 10 ++-
 kernel/liveupdate/luo_internal.h              |  2 +
 kernel/liveupdate/luo_session.c               | 73 +++++++++++++++++--
 .../testing/selftests/liveupdate/liveupdate.c | 40 ++++++++++
 5 files changed, 120 insertions(+), 6 deletions(-)

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
index dda7bb57d421c..f1a63ebe4fa44 100644
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
index 8083d8739b093..d4ac7b4c58829 100644
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
index af9e498206d24..f30151c37bd43 100644
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
@@ -662,3 +704,24 @@ void luo_session_resume(void)
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
+
+void __init luo_session_fs_cleanup(void)
+{
+	iput(luo_session_inode);
+	kern_unmount(luo_session_mnt);
+}
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index bdc1cedc4f944..27b3cbff6c739 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -22,9 +22,12 @@
 #include <fcntl.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
 #include <unistd.h>
 
 #include <linux/liveupdate.h>
+#include <linux/magic.h>
 
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
@@ -416,4 +419,41 @@ TEST_F(liveupdate_device, get_session_name_max_length)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Session fstat
+ *
+ * Verifies that fstatfs() on a session file descriptor reports the
+ * LUO_SESSION_MAGIC filesystem type, and that fstat() returns consistent
+ * inode numbers across different sessions (shared singleton inode).
+ */
+TEST_F(liveupdate_device, session_fstat)
+{
+	int session_fd1, session_fd2;
+	struct statfs sfs;
+	struct stat st1, st2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "fstat-session-1");
+	ASSERT_GE(session_fd1, 0);
+
+	session_fd2 = create_session(self->fd1, "fstat-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	/* Verify the filesystem type is LUO_SESSION_MAGIC */
+	ASSERT_EQ(fstatfs(session_fd1, &sfs), 0);
+	EXPECT_EQ(sfs.f_type, LUO_SESSION_MAGIC);
+
+	/* Verify both sessions share the same inode number */
+	ASSERT_EQ(fstat(session_fd1, &st1), 0);
+	ASSERT_EQ(fstat(session_fd2, &st2), 0);
+	EXPECT_EQ(st1.st_ino, st2.st_ino);
+
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


