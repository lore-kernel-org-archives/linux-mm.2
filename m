Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9D5F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3EDF6B02A5; Sat, 18 Apr 2026 07:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEFDE6B02A6; Sat, 18 Apr 2026 07:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF286B02A7; Sat, 18 Apr 2026 07:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE8F6B02A5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:40:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44A3C58E97
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:03 +0000 (UTC)
X-FDA: 84671482686.12.23B3EDE
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 73156A0002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EigzfqrC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776512401; a=rsa-sha256;
	cv=none;
	b=45HzG+qw52o8ZnyW+SD8RUn8VC8z0u4f3lCeJqKEpUn8gebnh+Gk6ym70ds6YCh7pGNeca
	u+bTN9AIiffWLDGzggAMRCKdeqZPKlf54xeHEde4hJ1GvFPNaKzunP7VWEgbOMuCF4aIkb
	+lW5Q5v2CWLKRcCHETk6Xa5cxhx/zRs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EigzfqrC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776512401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CwXFSSY9CL4wYMLHlpKxN2D5JLK22sZ4JptUsMLRIyg=;
	b=aPY9uXuLJG1W4T6mwuDd41ketVr+e4Kv4ZSsgq7DGIo93bHDZSSRvZnHiWcGv08d9WbPL8
	boiL9+wEbCP3cH/5wEnofiKfdaLlliMPN6ieMZYXAIIiDrPeKvaXqYNVVX3LbmRc2FFpvn
	DOTnKHsMe80RjRQYsIldFiVjzkxN/OY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488b8efed61so15416005e9.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776512400; x=1777117200; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CwXFSSY9CL4wYMLHlpKxN2D5JLK22sZ4JptUsMLRIyg=;
        b=EigzfqrClMEvXY6wSG8ESL4lLlM9M4YnlJLKvuydnxfbpYr9UXAfZXFeEuEtu8BbZe
         YtOv79+Hq3FQpfwGJRDzt/qJMPcFfPBCF8GlXcWrygFlPj3NimvBOSwr6E4W2VkGu5Lw
         0SwCjd9YE3ZyKp0MBm/B4NdKRcgVZue93PjABOwssTDEb+iFFwvKwFEJ5Q0B7byPa6BF
         AqlQEnlKtVwlC593djEDT4Nu5g04/GY1dU8qvBcLbRwpuS8e/d72a7W4UesjlW0y7X2k
         Zu+zXm1ZoW+17k2ce3+5+Hvp0n8en62fXogMAyGTP+uJm5VkgnfMOyJ1csv2SFuQFv6p
         Bymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776512400; x=1777117200;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwXFSSY9CL4wYMLHlpKxN2D5JLK22sZ4JptUsMLRIyg=;
        b=TwUe/6NrE4VmKSlb2GEv0sOc7C5Ltpge5lS7+Km8EvIKN/zPIWTJ/QXYE1z82cbkKr
         e1ryN3iFeQ+Rt1MgX7Cfjx7yVg6KUgx65lpyutwQBnaey+5UDGoQLDsWi9IueKmCcz75
         iqG5hjNGGmqUCpEh6rf8cUvem88pQag1FzfF34XvOJ29cYFfFcl/XORiDj2I4FEqU9HR
         IzdqqKR3An6ZknMSsniHekptHTdnMUP4S9kaXAw5nrdXd/9vwSlhtG2rpfM0/M0G39f1
         qG1GR1+SLnDUuknibKwmIhbNJohS1Msjhz4r5+7hT3UUfeLGMiTvFmYiOHUiJdnDNLwD
         rsyw==
X-Gm-Message-State: AOJu0YxeM+Ea+QsXHbQEruothWCGCI48q8DcbBJvBXgR5Mxs5n3+lWJL
	qA1Dz/xJNbM7DEqNIbe/6w3jL9ZjJLFBQ+5pnBRUo5z7nH8r05+U410P
X-Gm-Gg: AeBDievZ64mae6F0mI1X/KbgoN4Gp6dSe4HXoxDwGO+D23k6XdLr6GFyWY/4P5UHLAe
	qeDuLH+02SttzjiwHvm7Myko8G2HEeYsvjYAwogaKyh+VlDS9OVCOk0kYW4Hz0jkcPakJpfc1X6
	l16frHNSLBgglkbBpQhki4npf0SNIIWYtkfh3bU0gVNaH18SZXG7aLolcFq/ZLYwA7lrzP+PxFe
	tVnM2U8cNKfEFUKpfFSznSmdD3k7QoUv8mQ+bx9soOYmnZz6vir5nwbzIlxq04btg0kDhmd+Nld
	lrHkD0iHPQeSRdWQcUtCAh4MxHi0LSRSKd8pWsZOZdJin4X3FGEV1dXYwzwP+AaM0Ujc56NCUUT
	dqbYd13RF/Dj/PO4Uujv6glV4FgIzxuCGK52MbMoaJC732eWoGM5RDoB7gseCZQaAaaZj6wrdOu
	Kp2Pl9O8B7Q7c/cb+T/R49LZwPwwlYaD0MkvqbwJ6sqix0z5UT9Q==
X-Received: by 2002:a05:600c:4749:b0:488:c6e9:1e0c with SMTP id 5b1f17b1804b1-488fb889385mr82585635e9.5.1776512399669;
        Sat, 18 Apr 2026 04:39:59 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:3ab1:89ce:8d93:ae6c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc1070bfsm119872455e9.7.2026.04.18.04.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 04:39:58 -0700 (PDT)
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
Subject: [PATCH v6 1/4] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Sat, 18 Apr 2026 12:38:38 +0100
Message-ID: <20260418113956.2146648-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: dfhmeru7s74bo9qihxrtks6fib1g84a4
X-Rspam-User: 
X-Rspamd-Queue-Id: 73156A0002
X-HE-Tag: 1776512401-549783
X-HE-Meta: U2FsdGVkX1+ng1cXF6DTnXLuQaBdD/CRiJ9TTuBI4pQ93FIPUD3l+83i8qETNIf2Hdmt/DgrdvsSEmXRekIYBgvCt6MqjOsKCCeXCtEFxKKyMcFiXem1YLzVQqLhLRppoSkCLgCQ/fCpqYlqkTyNWLMSNL70vQ+kYXzcPkJXFFI66/HaTC8O8VyDQ71Ib/gOpSIYH1A3JN696LjvlacE4BPaHcsahzlSy/c6oy6kzNeUPWT+KSjjRIGYtQIA80B33iklsb8SZr2G++1lB5IggtZq0gHhBGS4CmL55CIt/mPb3fcb7OUoR8+CQWYB9JDYTc5BpbgzFiLcbIlW8nh36HNkdzqeiYINs7cSRx7dbI14vB77QEEMnTeRIRTb+lNUUh9Jh+/PXdL/SudiG/inigFyMCAXriJBCUpocVsybkx/6F0Kg52VCxMg2ERBTrrS2gh8xEtFNUC3YgXCL7BZLlfywNFwVLzDSgtedyJIsGFLW8i+qSzCzktnPlxtzosrcygGwpEVm9zHRpT4bNK3FXSezaqLKXGIaDIYKue3lDbEqKlqVuOB+I6jtEc9UIsUdOhCUSfNfc2dOlf8aADyldzsoPGwYX1tIIyrMP6m4oKn1svLJTPa/7scROcadYyORZAV76oN5OgHyL8MjTX1XgBPVbR3YvZ5v2ZeCj5Ye3C+KhGq9NCQcGhTHXf5MEDKiN7itWpu2baRvttIHmi8d5TMMLK6OnmTAhfvE3O7tRdjswacqMbilvv0AMcHBQt4agIuyOdKKGwO47aKNmGNLElOIbRVCcJcbuDFsEPVFeyd1hyFEYZSjXf3B4CLsy+CjvkXHgvAuHTKLoiEKwz86OzVLH/6XQjVY5rtCFiQrmSmP9QcpPKJOSwsC6W+VQf476UyzWOX+nNUKafCq6QSGrTC6N9FjMtNcMT0bCTIpdomb6nGlI8Py4GysjhqqqZe2fYdpjusr6Vld8C1jMn
 s9rLslB0
 0l7D7qJAsfYmAtNB4vVuzO1CLjeVvntn3E/5hBPVODlLnJW8MUPgZrv4mnNxMHca3lYgalCvE3BkAqE2W1rDBo1LZ/8ZT/VA3ZQ4xZkSVlFrR5MojRjNep/UEZ+q45Z+74hEpsx6etAG9iw39efrmhCWQ+VetsbSJwTRqmLqFGDK3Gs4I67aITYv0YMtS7JO3VP7bFLdH5YekIbqTUVAJ5fy85eohm72hgm773ALO4Rd5RzcPcFjXLjLJBHC5hhbnFUB64DihZjETQVSqdbBNakcKwKCc3DIN2WIf7tNeeIy8oD6TJe4q5ioYZvUZmCeJNnVM5xme/NbB2oH8qp0qJq5dd1JCWRCg8OnTKBmRs96yv/6WJznwZTO4dTQDRZ6Kr2GZtNCdedauCpw8at+vJt9L3pwBYAPsSzYPVrpHO/Qoeta6fOp6XVAVRqpGhT1rNa0pRKmpn57UNDwEgmCI0Frmau02EIU925/1PSDm3SUxSKkzroNbGMcSX1CRwg9CuGP3FFatqlxobw1ihgDs9qiS3CVhzbB5XSwT0hW+kk46EUjNothOu7rLuN6t1zsSXK4Xd9F80Ar9WSa6xK4WKe0R3uSS90ROq7GQbXBcopSauPdYTS+ZGvs5tl6ix0jBn8Kxeav7sToKBCFCdd9tqA7IjwB2TVjaKxXANdIVngBH9zPvWqjQQSRyzcd6tjgiKXG/B17dciZnl7c1CA9vuukaJ/tG/kF4DXS0
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
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
This was requested by Lennart and Christian when discussing integration
with systemd for LUO management.

v2: apply one fix from bot review about cleanup on error path:
    https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
    the other comments are invalid: luo is not a kmod, and the write hooks are not set up
v3: add test case to liveupdate selftest
v4: split test case in separate follow-up patch
v5: add r-b tag, merge series with LIVEUPDATE_SESSION_GET_NAME ioctl
    as they both change the same unit test source file, to avoid merge conflicts

 include/uapi/linux/magic.h       |  1 +
 kernel/liveupdate/luo_core.c     | 10 ++++-
 kernel/liveupdate/luo_internal.h |  2 +
 kernel/liveupdate/luo_session.c  | 73 +++++++++++++++++++++++++++++---
 4 files changed, 80 insertions(+), 6 deletions(-)

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
index 25ae704d7787..5e315cc0dfd5 100644
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
@@ -363,18 +365,58 @@ static const struct file_operations luo_session_fops = {
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
@@ -649,3 +691,24 @@ void luo_session_resume(void)
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
-- 
2.47.3


