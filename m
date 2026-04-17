Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5782BF43688
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C836B00CA; Fri, 17 Apr 2026 05:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0CD96B00CB; Fri, 17 Apr 2026 05:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A0D6B00CC; Fri, 17 Apr 2026 05:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 966056B00CA
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:44:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 339EC140AF3
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:44:32 +0000 (UTC)
X-FDA: 84667562784.03.58B0DAB
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60AA4180002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:44:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFQTLrOp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776419070; a=rsa-sha256;
	cv=none;
	b=66YAN1v9hARauCNWB4UErld98OKypbqVhYS2dHhA/qcLAD1JhU4nKpEMz0k+wURwRIdPnp
	enR3ZRm29TQZJUO1Axm/1PsJw3uT2Ne3ttI2u+YlNuEMnZ4UI6m3o9sOC9Fg2Irz+8Eai/
	0v0tv3z+wd/UTaDzeldvI2Kz6lwZfMQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFQTLrOp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776419070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xd92ZSF+vA4E4hE1DpIDZAUuBJ6aFxleeIBaxyrSMhM=;
	b=RyZ/pcz5aOKuwgDqUbcKQtmLxV4wbASAjavESsx6nqC6/Q7RZs2Ps3vYSgnS69kiuDdhHA
	G8Mn+DoyBzuA541SDOcX4HvmTJYelc2QHJhSzGZSJYBEA+2wkWJl8vHgO+fuUtJlKxwUYZ
	+DkfFHoVnJlizOUG5Ym68riyuoRcjz0=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b8efed61so5309195e9.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776419069; x=1777023869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xd92ZSF+vA4E4hE1DpIDZAUuBJ6aFxleeIBaxyrSMhM=;
        b=IFQTLrOpBRQWtHBECgXOsSOjgQhDeV/NQirN3ia/Q3UflmhLlH2GUMxAt76V/f2pZp
         xATu0cV9JA5EHr0HQPf5HIImVubrtyW8Rx3lIaiM+kFCE1+32ZTel/oXbrZjgpOF+ZFM
         AdjOmMGIlJHKWRWimMWahZGu8KnL8X1z385k3MdH376YXFZt7N8iXCm46BRo8iYRcqeN
         1gW52TCLg7q4dhoOh5FHpQ3ng2+K0pR8GYQ3dQm6trzDURaDkTMDxUEjWrtHFLE23k5C
         7tKi7Kv6FNGoJ7e1DKyWD74qUjvq2oZkavjWXpBeiH2DrKkmWaW6WBDFHyA7wXdbWgsU
         1mDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776419069; x=1777023869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xd92ZSF+vA4E4hE1DpIDZAUuBJ6aFxleeIBaxyrSMhM=;
        b=X/efNxxCUX4xSk4dicimpj76B1856qkG04hGAk3zz/m0R42n/vfykwwbJwEHYweJ//
         wAQszD67Cev5U17SFuTp3BqWp6fhuEucG/YjgEeH2o5a/72WcqB8DGolJWaPTbDHcMuQ
         Jn9aAH4IUWvyTP8XlbpcY2wVGNZmvcH99Mry+9x72AMySjMipjSpN4WUUijppDbBNDWY
         INZ0qneRnLcsPmjUuHcqVI5V/npKSfkRLy69/DWqRakbbRZ+XUOMIfR07BjpFli1etHJ
         z+QPtzACUmKEmOcr/n/R1NHr8ZyFuL8d11pFxYk+j7qsqi9/ONvas2spuJp+YvecA9ym
         MY+g==
X-Gm-Message-State: AOJu0YyfPNvY7GzkWiatBOP5If2FQ4F8bjpoSH17e3prk4FUcXtOKwjt
	pCJ+aXqRM6zx/XNpwIioWLkkw7iyzZ9vRDXvB/xmi/QYrLgdQwxJhgFG
X-Gm-Gg: AeBDiest+D7ZZ7NBBmoaDFF12EckwddfP0C1oNZ3cC2EViu1wflUxwi8QB19hqBd6Ps
	SBndIb1SzKkjfk3Ahj1ARQv+143ML2z+bYfmEw4UlrCA7bP3hIJSjlnkTQ1jLILbXGm/PXjzHa6
	wUuQBDnKWApM1FJ4RvaLbgHb2MeZfmr9c+CydqBpIVveDms/D27Ay+qWOF8cFoq57AxhCuOq7iZ
	2CeIuqP3hxPOvFO2/H5i9v/P5SyIvdD2leaI0wHtCIkUIQ+7eFN/Ao5QhurjcIhaAYxdFOb9Z64
	d1cVzZ4sVjbvFz54j5Gf7CyCEAVoRIZRAbGQpcFtWD5gGs+7kibPIiVUByMrYnlvYpuboVf4UR+
	cItEWaiBh/RCG2qhpNaFIx0JqygkZWFSPYQ2oBG0ZzG+8zWdJW3nCCAZpIgAHVoCjtN8Zljv/z0
	W/cJ+GQtKXDfIvwGR9Icr/SHHGpblfEo/9SaDyAbU=
X-Received: by 2002:a05:600c:c112:b0:486:fe83:861c with SMTP id 5b1f17b1804b1-488fb896910mr21169615e9.7.1776419068432;
        Fri, 17 Apr 2026 02:44:28 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:9586:30a1:a0a6:f076])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc14104dsm31037365e9.13.2026.04.17.02.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 02:44:27 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v2] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Fri, 17 Apr 2026 10:44:00 +0100
Message-ID: <20260417094426.1556849-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 9etxis85ctf6r15awso1sxss9a18dqit
X-Rspam-User: 
X-Rspamd-Queue-Id: 60AA4180002
X-HE-Tag: 1776419070-777957
X-HE-Meta: U2FsdGVkX1/NhtP7ZI2XqViHfZKnvhUW3H8jQEubmq8lsRhIoax8BSmdl+tDHsQvhan4Y9gr/EVVxIxKq9Mae0yv36gbBBasgdkVsbYIMlGJ4lCE1j30l9qhuofZrYRt/oV9TyPiSfFiXELzW3bYB3q3eIulbN/RRhwuXs+/QGrQXTAWqtaK1hjDi+LT+XT4XB/vp2OQr4rHCapu7HTBkGP67AjPdtcawYNJKDK3VLs5uQLppOC5Ar3FC1gUTo0yeQ2oktVPaReffyB5i7c2BEIB0ju0sZSAhUdSDP/McpQXg/gnfjnBUAwzHyavzjaLDFzI7NI1uPGfQ7P1BOHEfHPt9+/BJ6GXzg0NkPJ7gguQUu/FVQuZegpx+fD2PhsETObajkUyCFyae9eYvKNHnvwMyhqAFysUZFK+iBVkJgmcHl4l3kTBvWp4kFZatJ/yO53P7DePkRlhT6CJpYUksa83a2BoG1Zn72ZY41iJpYrTCzYuM2EECUBmx1ZeB1Dm+P5H1gCfasiwvNN0Nf3zOqagSsegkFjF6REPNHy7bMLQ4iyzFkwzsG7CE0U1qgjM+feog8DSqIdBlD4KM/nb/uAA/MSFKnkp7CBUmCRqqbACfqUBaZI5Pzq1IfmpMtPMwvizjuKFGQPPUDR6Cqwqm0XPGoduDdu56XHf1joD4hYdWm22m9h9fr4F7XYvFBswCmrTxXMmO2ptHrwIyfNYFidYZd6/cEELS9Ib/XnwU+qsyeBL2uyyxwx6NGwL1OLeVEkZHLyXSRkp++QDh3B4HHl4gSS5raCGePhZBqvNE3Qv5mTl+Ndf0wfnC8YsprDgS97zkFqUHJEiq3wnN0iCe9uXln0DbHAuP2YF7gkJnxLx7sYVxZYHDbaIjZ/kgRCE6Z4pH90mbcBE0670hylSCmlb6uk0wzKgW/mPTZmOn1aTPbH9gO9BzkxpmLTawrjCiPWt9MgIhVYSlJ3vSV6
 2ouR0e4z
 mlw7nqAKQ88syqak0UxeomiQUcbxjFjDI42JF+kKtxy0lYr6jkfmCdqd5sk8mlhPReStp7nr4WPfXToCSjx2mXAtNrz6XAChYlH1f0VeYM3lBwWXvuveFQP5WX/QaX0Q5IUqH2k39Ig9t3nvbRLBtsIi9z5CUeWrOeSUUHeSi0X0s2NFZR86dRuPl2jjZOHuj2ufyTMrnGRh93gMUFyAwkJcYGqloeol08M6psJ7JwUOwW21N47OXtAlC3ToS5ACDRLmF68nFigUPy03AW8m5AByCyHb0AX7Vl+IkhhZ105I/Ic0TYfJBsffQAaWUFIwRhbDe5cysLOVQ+DLVVtqtWT/+tupatKkXhWK6Vok4Pm/PGdUcMdTKJAtScRzvpjXyi6Wo2fLadqvkzSXCXA7BpKjYvgNxGvD1RD42MlNJJFaEi2i4HEp6Ecd7lsuQuAlXJ2BEsHKXk4wUnwdAD8v6y2235saabIWnnl9w5wtaYsBGuAXYUwX+cUBpa8D8XgQbAPj++RFbk7eNhroApZt5XUo/jnAjfKNBM4zRbwfqCh0GHd+9DSh6aPi9ZjQP7pJSin+uBuDSH5xK8CWB2bFIFlPC4lAtvrZTlQE3am24fcom7blD+e+xjk898DEStD1U+c2iEwj3o/l0pud/S2BOt6oeOVIgVXVtxKn5
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


