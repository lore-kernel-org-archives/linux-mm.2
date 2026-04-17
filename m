Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E9FF99C67
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 20:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037CF6B0142; Fri, 17 Apr 2026 16:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F266B0143; Fri, 17 Apr 2026 16:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FE86B0144; Fri, 17 Apr 2026 16:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE1D26B0142
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 16:58:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E92F1402D5
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:58:29 +0000 (UTC)
X-FDA: 84669261138.15.DD3FDDF
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8A1C240009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:58:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bfD5jbs8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776459507; a=rsa-sha256;
	cv=none;
	b=sE3SgI7oYPvgyTIbTndQeQhGoFMfIiQVqhommFpGpSeL4VA6kMZEf9Lz1taYv9u4Hc50C7
	Ua6aaNCxDu1DVXaMnHde+d3cT3jW8i9qpbm6pzQ+38n0NABXSliY7jmfaTWdfDtk9lVM9j
	ifnCs/U0cb8A5u8oOCTzd4+RqZbmVy0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bfD5jbs8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776459507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0MVSGddwfS+lqouJU82lm1dW9XBz7QLMAf3/kqUhZhs=;
	b=eMmxUkb+20TMz40F5h8tIPrUYAYzRjl+glf1TpggkJs6bXFeGJqb/ifEdp25gjWCfS38zH
	o9hDd75f2P3pjB5d8WF0+3UwoNJjordRrRNKix7Fxl8iNfEocs7dZRvYb/71p8EiDjKdQr
	we2dj9gu2noKivtCNOiTAiDF7w5izvE=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488ab2db91aso13598195e9.3
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776459506; x=1777064306; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0MVSGddwfS+lqouJU82lm1dW9XBz7QLMAf3/kqUhZhs=;
        b=bfD5jbs8320g6d9bNAJGKyBU/7NGscFqTKJy7pZBB6SMhoc+EXLM7iQzedWOTluHu8
         MrNhbKq+u1OShEbveXRndSuQCyuHUDNX4nb5E/DGB7dVZ1dLWKAjSu9JGNEbtoE8k46b
         1EMbx5hS61zMXRsc5X2mLPnIXT9fPvhK1xXpbk7j93KFE1I1hAVURltqVqh7m8qb+eys
         fNyjnKs2nF4mlvoxVYXrdlfBCcq9oiiYPlPv3yeaw2Rj9CioUWB8B5rp55pyH17kHQ4G
         gcmGzz3QoEUL7Mwm8uPglnDxP+R9I8grdKKlyAzg1Qxv30FSMgMUh7H0Hpr+iHvl8kjQ
         Kgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776459506; x=1777064306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0MVSGddwfS+lqouJU82lm1dW9XBz7QLMAf3/kqUhZhs=;
        b=lFO2kMosX92CpihSMUc1AsKqF5OE675/9th+UYNLKoQDjU+NlIBxqnnSzc2o6VHKHK
         9qwuWXVX07+Ndny47ds3Fw52aFIR7+J4qbAm/WHtLCkj1vdX0V5r2MgugIJiLcvijLSA
         BAgbyJnJmuBIEw+fNmlxfG0l3Qq3ladl9ew+36NqKfMr8kma0qU4JqBMSEylyn0ZGy2k
         itAPQAAxXHeTUdyqV15mVvDlnKNBIncyWzlQVVgVv6us/2+jullNu9bDHBcg71+AmAqc
         BfEvYYlsQdeROg7AgR6FB+8EEIcM9v3RS2AI5uNT5Zxy1xbDAmoceyhW2nqFcZD5z29C
         0Wsw==
X-Gm-Message-State: AOJu0Yxwi8EYeNH5r7a54VSlikDJX93u/9qLJ1P0yxK1qe9zg+v9c/6r
	/M/AHwu5d9iqeHSGj4Pw/ys4cDzrjhEqjmGiOLak3I1qmtnxPBWncEKH
X-Gm-Gg: AeBDiesNIF54GpZjKPPfHAoDrLE2M8PbwE5WjoJfhZmdY3vduGZNWvjzjVplLk30quo
	XInEsPBtfxfdzutNELWEk2XGqpi4Oz91eqL2CICG8b6ZIYPccLzek4o8eZSiARnXRwsu9f0PetU
	fww1NPySviSt9T2W+GJb4SSrufYJF1pDoTEhkgCyIcet21Fw0cXl0ULwTBd0c91i20xiooyEN8S
	BGjTD5FX66iecibh0sB34Wqbw18Fagi8Fue9NKqhvajEpKFSdaFyRxYmMGXg+gV6xV2z+2AVjkF
	SMydlT7zWTF9kQgepax8Gxwn65G64imv5oo0VZmC1zyEu/CbPQdbt2i+KZLcGLrf1tHtebmywhg
	P7UWIPyUNagrV/AcBjUNSqWFa2rwQY8UbPoRckewdSmv9tw6XaQE7/wSVLitbeg+bvvoX9y4Rdw
	a5y8LfHdS8DAXFvF3+4tANvRrDYY9J14ZYzX8goYM=
X-Received: by 2002:a05:600c:64c7:b0:488:a2ac:a334 with SMTP id 5b1f17b1804b1-488fb73aa3bmr65028415e9.3.1776459505901;
        Fri, 17 Apr 2026 13:58:25 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:9586:30a1:a0a6:f076])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb7b2634sm25446085e9.28.2026.04.17.13.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 13:58:25 -0700 (PDT)
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
Subject: [PATCH v4 1/2] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Fri, 17 Apr 2026 21:57:20 +0100
Message-ID: <20260417205810.1831923-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A1C240009
X-Rspamd-Server: rspam12
X-Stat-Signature: ikb7rn3b6mog8t4ir187j8pn85k8dwq3
X-Rspam-User: 
X-HE-Tag: 1776459507-675536
X-HE-Meta: U2FsdGVkX1981jZypLafS7en64dZaW5e8Pzf0IGn/SDPIRjnljfRO0oMY95FC5h409Src5hvAOc3D5LKsN/EvYHM+SbWllPRNepex6VfswF+jjNLv0h36ulM6Msnw1e6tvbVSq4lMGoMtouw5mUsnjEEBp8Z7MlRav4ZjOSOj0+rWuCdgL65sMX+5sVIoFd9C2ZykHx9i8CkSqAMEW2E+/w1QDxzON/edeDEbHbvyUO2qIUZvuT+AxQAWQg8aZ7S2U4T37wojtFq7a3bIgwNABk4rQSqG+3obCR+oWFMEqPY0zZZRGnui5DLU8G4FpTWeefec8l3bLr1CC9mhnJy5jKQuiDsm+XirfY9u7x0ta+KNTn7slh6WC+ZtY0CX1eBuY8CipeBM2vNETWQHHeVqmJQK8D/nMpdxfbvHmfytGkf03l+5JbICWu0JucNCidOk1eO6y93sUAfxsH5luBeVi57x5bu3Dlr8kE+7FaNNzTbYlBbKrPevVHFYKG2oWD2mvJcOkB6o44V4DQGulyx4JpDS3356Rw0NrSueHsJhSTrcv8PV+Fo1Wrx77GZMo8gaEmCUolYcn7YTmDuA5vjlGbBJeHaJgM+G6CFxmwS+0utTJg12WBNLBJtF+HaXUdv2TqYPSshTe2JVlAFY00WGYbd1HCIXoSvYpqTl+EMIwnoW44/CCNBTWlw6Jb5jmO4nF9/xlYpQG3GiFIXoxPyF65Xp15H+cqaQSZd7lSvPIZQmBBtjW+2Yj2vXlqdFOY/aBxEBoCsE3t1z3nVeeSsuGo1VOGE+rcst82wOToeblK3XGDa4BohLki9eEFkhEwn3AR8Z7m8+HemqKFgoIxrIZyr/dbZyd7SeScbF7p5DVtkh78Lazosa9dVLB15KL2pS1tm/s0XrOXTKiByhznixOJ5kzNbmkBNpoH0p8H0wTVG+REhJH7IVPQFM+6AzqlJya1P4/CG2SZGogtFbIV
 RU3QfoFD
 srYYMVsodbdlBDaAvqogjcN3f4F8HqVEfHcPBX4gWP3uoY62KyTK7Gseuu4/ivcmDnf5N/wIgodscWQBF7BCYF21utfH0vdlBDuOBSncMAMJlctN8zpOiwNVa9wgcx/wbR2hy0nzANcLprCpBLCMhN7bzM14QQwu4QXBTbOHXHCj41NAHroqcXRjbbG+piyUxHf9Tz/rwn8L8QJPi00G/iAw6mBBqzQKh7DdOitXrtrTXWClQn5TEnGE2gdz5dCYeyN6MEhHZgYFsW2RqMRGYItcTbbjnFNl/Z/ZsxUthuM3cgfbOONl9HXGXGvCnfyrdX+kcbe7014pr0+tgrBepMvJtoXpO8akAYIN+lCzo49xOyecZaxSI31y4SWDtA+EXQD1p0dsbw3acgZLxhqY95NhXfOMTvHrpq+te0PWtslfoOFMYxdoqKlHH8QMikXVNAQxmpQ7JADPlBTn9GdttL218zNumqHtZAwS4PouUyC1xBAeWW1XRys4mxcr1/vPCZJgdcDLlWGlc8Zu2nXaaXC3K/1t+vq5L+bWX/Z/mhPXX8PgC6vERPWhCD/fw00S7QvyVp18dzdEo0711oBblg4gQTJ9UfWoQQuiPkIVG/Qj6FWhU41PdzdFBQLUylLtyYxJjYhSBDPpm/BScmZpCNWgPkSX1Meqh1+isYgF8WMeB8D0lxheW0xv1uJ3+/B/UpZdK/H9nxfU1QhzTAnKIOR5IWg==
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
v4: split test case in separate follow-up patch

 include/uapi/linux/magic.h       |  1 +
 kernel/liveupdate/luo_core.c     | 10 ++++-
 kernel/liveupdate/luo_internal.h |  2 +
 kernel/liveupdate/luo_session.c  | 73 +++++++++++++++++++++++++++++---
 4 files changed, 80 insertions(+), 6 deletions(-)

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
-- 
2.47.3


