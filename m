Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754ECF99C82
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 14:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B54C6B02B8; Sat, 18 Apr 2026 10:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866216B02BA; Sat, 18 Apr 2026 10:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7551C6B02BB; Sat, 18 Apr 2026 10:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC916B02B8
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:11:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F35C7C1C40
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:11:29 +0000 (UTC)
X-FDA: 84671864298.17.DAF10AF
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 30B29C000E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:11:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iwLUwSoF;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776521488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8aNn7SeD8N8v13CLxmWBmteIS/DK7+pVMQT0YQ8OKsQ=;
	b=6InKeGdtyU5FVMxFxqf54ahTygA5y1wPK2V4hEaFFcpYVsNk9yFk8qNlEfpU5xZSImswOI
	pwdlWjXV2aDEw8y1bF7VefpSyKly5VcpZg8TA3a6knehHOtgIdIxL63vQ1w6jollyFSNbP
	cpEVloDICxDU8J6dN6guadfVD4kOtqo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iwLUwSoF;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776521488; a=rsa-sha256;
	cv=none;
	b=3d0tof/wMTDNgcpWGU4dEcJX0Wj/0CgPVVYjdpkWQTj4Inx9vNwUAFniFEmTJrWqvk3gG5
	j2gijOkXChv03CZp+xXvQuuNrYQwDQ1ZzXcEv+aX1OqLFP69ZD9yGWydzbKeUelCztldKh
	YmPrN1+Hz/yhGk5Fp1Y2oyuTJ6KxvsY=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso23100775e9.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776521487; x=1777126287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8aNn7SeD8N8v13CLxmWBmteIS/DK7+pVMQT0YQ8OKsQ=;
        b=iwLUwSoF0LK5ZbP5ElcF4bDSTisgNN3ySiNVR6ATiaUvWx4Que/MlckJuL22LColzK
         OyRdUxPbuguJKM1man6xdLagR8acvem2h/QMWzlniIpVLPw3YUkUKFL5xl2ZNJDFaMlE
         EG7wk8bDy97q5/OWjYKH8fccG9NkVnxRPV6VWiHk3GlhOTjul8c67wIoWBOQdJLoawm2
         T7Man209hMPEMIgetQ+BE8dln7/uYoGX6SeQ+4zJR87Z1zFOGEQutciiL+mcGm8uL+aU
         djnmsLRI1Ps92uEoprNHKwVr3RC07Lhk9eDzqmvxIBWlxLoIVKPlx7abdmkkd5bfYPEe
         ULMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776521487; x=1777126287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aNn7SeD8N8v13CLxmWBmteIS/DK7+pVMQT0YQ8OKsQ=;
        b=fbK24o4eM/MSwxlDY2X4EOkgLaHcc6uC4v8mufhKXX+wgZEPURISsfQdXm/EUrgGLb
         29wJL4HuBKhZovGmRiTE27yjEeYuo98kf0saqv0AAp4wSz36ZNJI62g3fR6lG+4JD6+o
         J07Aczpg1VTx63TX9sGwuCqtIPVECHLEQ4tokJqzjA8Xf1shfMjN6EpX0XoViT73T7MG
         FrVwoZ18gnEIfxQ6iOqLKb1dPElb2dk+lGD/nZX1C6eZkiwvj4FCzPu4VB4ge5huSH+d
         Qho7sCmye9OQbYGN+g88QY1MFdIOXceTyT3Aw/aV5soBxSvhJxjrCnHoJ/0xeReQt6xl
         GChA==
X-Gm-Message-State: AOJu0YyEZCwi/wyqTxwPgaJhbYeeCh9EjW4s6p4FLyozlzxAz+ZknH52
	1jrGK7rmi7vJ7IJ1dv3AuYVHMKnRYSmN7OR2eorarYUJgUoaqLoJ8q/X
X-Gm-Gg: AeBDieuOPM6Tx2HFzd3LtI8SJhoB1XZEHx7789KrHswtdKxxPEaAdKJRbQWvg61TUvb
	KE86RU0f42Xg6MwbjdSeYPWfuQHdmklEl5Xk+5y+186igLKz5IdNE8+93n+HPDiyk2aJAr+zvnZ
	mE1aYkpVV9JRt7uzcTZDxWYLTVukr8M+XlOA3VqgfqrqjStd005PeSXEjRCxKc1SVo0QwabDyZl
	osKBTxt2luojH7x/98OvTu4dkiCZWmnQAvmO+NO8FH2IA7wxYkI+7YE/V2qrwnn7jgMRVNF8rtl
	nqeCHif1Urm1E7b8jy9q2adyb7sXatxDK++SiqH1vBe9uxGtcFZnYS5VODMYqKV1gJNKWPmW55h
	rIMZ5QQLxy2SDLEvFQ5L26yCskcWO+SggWHqg0xCc0VQttvqI+VOUXs2530APnXpYjjwsA8WeiP
	Z9BLpRxojijasTjinS9ijEHbUWEM+igkI4tC2IfOU=
X-Received: by 2002:a05:600c:1e28:b0:488:8be1:ca3a with SMTP id 5b1f17b1804b1-488fb8b56bcmr99045135e9.15.1776521486419;
        Sat, 18 Apr 2026 07:11:26 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:4429:3762:47dc:91a3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4e46471sm12255364f8f.28.2026.04.18.07.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 07:11:25 -0700 (PDT)
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
Subject: [PATCH v7 1/4] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Sat, 18 Apr 2026 15:09:37 +0100
Message-ID: <20260418141123.2193917-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9u4jsmxxubykfihs1yobcu8kib4mukde
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 30B29C000E
X-HE-Tag: 1776521487-715772
X-HE-Meta: U2FsdGVkX1/yf7fKYWi0c2c2BRGOIsTO1WGa2fC+dnmrGV4qDGZ9MsmLWvn09bCR5ZY1uiRycWnxPpACZcd4NgZhqmmIjIiqFKHvI13yPFUavpGz6OBpP4t+xsisDWhS2f8E4Wa5Qiq4zEFpVi8p0k/i8LKkjy7433TIfSZVkmmNzn2D+H3xNvzwNqQZkOcov/nXmIYhkWiy+uPvkQq47Anncol+L+lefiZoJDNgsjo/T+vKrI9XH6hWvb3kYZ4caqHGPkNRgqP4g5l9a+4502T7bNz1oJ8JybQUFv1EujZs0PE6k6YfyQybfSJOgqF/pf7uxGI1n/GWCPHXrGG/5FLG1Zk9FW9wjTWn+zJymq4s8rbIkQDhrBKqlDKAU+LIeKhVDagNKNvutnwFtnGI7bSYFe/rIRedXbw6+x9cmwbdIh4V4+OEladSwH4ybtBpbdRZiZmPNiojta8cQRFk6RhNSjKKCYGc7wYVjjQcg3+iHF7QZFt347LVs392Ek3IfDgV4hJiZUzogMpKsfT1zhm9SMi0bLR3HB0QO6MPK5K0D0Umocg508tO/AMubU1+6YvPmARwiDJTXRh2AhbAsQ8YFOaMupBSMaP5OJhlyRHbMEWGaXOh5EVKOapDvChGCC7aqFOwJUaMwrhhaEgrxtiWhRoABR8ENV9CfReJXEQfkC2Bf0TLwONrZVwVQUBm5FzNuMU1h1IGERQypfFTGHT6kaqDJv89ebVNpT/IEFm/emR2iswrfnCb5AMNq88QTvRr52j5gdtXY06GwNyAsoUzzXBajJ9oKwLDh64bHj72eseTBonz5euoepWrJM5qmGOYCeQK+2wxf5n5YavLKFGjHzJ22L14/QPOSOu4gcgP9bj6uyDcDDLa9ISGBePnQfzYX76i4OgUzxlgxONivGRtgbdmc93U15xQednEGEq56jP6nBu9Q4CQkramjIfqfdiB6rLV/3nIFclaw0v
 siHaatHm
 Z9oRQfUT6e2yw/zinga9Fk2pFXEzGBR6ZR3v7JOdsq1Gj6kiv2ehwyW+RhlSLT9rVVB+GnZLpRfmhSCKvy5vu4wkJ5NUHWm1Nowitz9Gy11Qu0Dvlixi+z8pAeBJDDBFq1rgZVdmXQxKMpe58Aslye+HjlVEaCAl6d+LUVsgLoFyLQJs+vZlJanB4mvI+famuzI0j5OyNxnFKAZGFdrXWixrxq5WMS713emx2qJfCkSEYVjx454W3deuLoehRfrnfrDtlMINnveymW+rmogD/2j+cm1LW+Zc8s7K4pBS4pfLB8veEreaDRWuXmGOyUZab/QEMmJqaUjvmfaLTK53K9w5IK13E++3HbJpXUrTYbsoSgGapeTG/A5fFYK7g53uLB9krtOFrfUMBNsBrHtxowiwHFPbaIcbqocAbb0xD7PRArxZGuKJHhIvBSLgY72v2GMXAtwrYafNryLNn9axCFlnzptX2tE2ASItPXgR2EaJfWQOSWAZB7cYln9ZHZxQAi3Q4mR798j5pI4j9tO8UEoIVrr1P02RH6Cv6J4NHJHmhL8qXZOnAx55PIhy5gMNl7omASpyBOCstZT5hlL2nZT2iRr2EbA2EV6/Q+4UKX/a45r2tfIrS38qLpR50rCItYoOy/yPBLsxF4Y0uq5pbBi5Zvo5O9N4NT5XVkGIFUNGnCKiWCc40AGJ8xVrAQBTyYHOLLDgaz53dMoqUrSiQO8PKgIAsA5oSOs2U4ccL+n9i70MbUf8H0zMTiH9wm+G7lOLEycjiZVmkJqmm2m6kk8ecRw==
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
This was requested by Lennart and Christian when discussing integration
with systemd for LUO management.

v2: apply one fix from bot review about cleanup on error path:
    https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
    the other comments are invalid: luo is not a kmod, and the write hooks are not set up
v3: add test case to liveupdate selftest
v4: split test case in separate follow-up patch
v5: add r-b tag, merge series with LIVEUPDATE_SESSION_GET_NAME ioctl
    as they both change the same unit test source file, to avoid merge conflicts
v7: apply suggestion from review bot to stub out setattr ops,
    like it was done in 22bdf3d6581a

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
index 25ae704d7787..1d35379e4e52 100644
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
@@ -649,3 +706,25 @@ void luo_session_resume(void)
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


