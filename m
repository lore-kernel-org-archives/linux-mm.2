Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B94F588DC
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AC96B008A; Mon, 20 Apr 2026 10:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8136A6B008C; Mon, 20 Apr 2026 10:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D066B0092; Mon, 20 Apr 2026 10:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58B956B008A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:17:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DC9E8C6C2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:52 +0000 (UTC)
X-FDA: 84679137984.09.4D85FC4
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B06440010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bik90NTO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1sjF4LQS9btS3anaMkMUdTrbJ6r/ruqhuae7ESZnko=;
	b=PEAalrl2iTBWr/3IbIhDJ2LoYnZL+5GmE7LRgrqyWkVeHkjB7AtJCpFjNnhorrnvler2Ze
	y2CySJ5hSUL62Z1XSp/n/QdWTDlJj3v39iknmsRJwiTeZsXaW4OPLO4g8F1blION8944tE
	rmaKkaIoReCsv5MWoeI4WLlADDKWj3U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bik90NTO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694670; a=rsa-sha256;
	cv=none;
	b=fUd2jqBYcUzEaOnJMIglZwBPusiLjIC0vlQcmqh7mlGQsfb1ADJtVO/sP217tiAJDCzZC+
	6QCWMc2wy2+RI+10bZjoTPIaWkEtRqoR8yWDnlufzpSTM2MWMRiEK8ol+PhcHEunK5UhdE
	W1p2zF29dE9pyEMKHkrG20HZBFb6taQ=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d73352cf2so2690521f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776694669; x=1777299469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1sjF4LQS9btS3anaMkMUdTrbJ6r/ruqhuae7ESZnko=;
        b=Bik90NTOqATfcZh/DQQftJ6LOgh6HMn+7kBtkhulu+iDhifRhSwuw/WBnJLgJWIbLk
         RVFnPj7h6xo1HsY2j6FzYLfWmrZ/1Pkj5WxV2zNmA2yiqXAVwLKyGoj6B6O862GhYH+6
         MvgABQE/ImH6rNVo+/7Ty+377jJ46f2tZVvoeuzMi6Yakvj9Jsi99TDDLHfoG+yvDBfo
         Af88OtxbY6nuUL/WWs6C5Kj/LvUL867f35LQEsqGx/gIlsguy+96DJZJde7cc2rJEw87
         ceiaBdMgYYfSLFVdYAhq3EY03JVHbNVtkQom0w9aDMjD4/+TMM0Zg+0s2jfHKvfVMzl4
         gsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694669; x=1777299469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M1sjF4LQS9btS3anaMkMUdTrbJ6r/ruqhuae7ESZnko=;
        b=oplh7MrAsPlMWlbONqNJzU3YORR0lA/+Zy5kX/dv1xHKN92jdFXvjf1cMAgOYmbJm7
         dkWUjrxrdijFg1xiiH1SWHm+XbDmQSn2i8BI96dvaXQ0xguAS+xh9h7/FMj+avgr00iK
         yLNWVdh7CP/SVV1e4AMige1MNOJA8cG2q7/uUQVXnsqcIIitMkWLFBCula9ZHwmnvhr6
         vvGDEWaa4AP8bLvi0ImQAXfYJ+Zf/InZAMbZmDw2/mNwcHTbJY79Zxk4XMvpB8lHtCCI
         BZRTxxCKA3zjjgiiF+VnUZqUfeUeOPijRdERcUgr4woGsw4ZbprMeE8ZqVzKk5/rezAL
         k60g==
X-Gm-Message-State: AOJu0YySFPp+4qaJq7GniDbZMzloW27AJxooSSpq1xdEEcE7yGaPGgf0
	ZXpGCK0KFkZl07sO8ymS8sI4x8Oqqvi1j83EWTAg67X11DR0YgAjaLa0
X-Gm-Gg: AeBDieu8N+9PVz7zyS5htIlAYS8FoXTbu3PM0uCRlPyQ6Ba7F9tni13T/qsePYZYCBH
	IgUOYi62P5PC/Os65Vu//dGb3pKOh32x4/RQqG5k6X1ssZGr7DvbL+M5ujun8QBcrUvqK8UlO3w
	+yscrPYz61ZMkfcr6fmzGm7xfhWyDdnRp9egaiLZy7N5rkYhPu2LjWMqQsdUmDapP1lMstVFl1j
	N0w2Bp1oZMfre1uCml8mj3eEENEEQItsOjg45/B0TBAqzEcmrUqMyLdd2/MCggQ0YJHUSjMSJ0W
	votWuflePOF6h3YcNbKxreysN67XwviAxZquEb0ygquWirkbpsji+6ygU3VrMLrHEH52/wGZK5j
	i7M86fLpBNr4u/PWJ21k+k5YPXZ7Hx3l9IGXe5jpzM26stkXbmpGGNgpJ8XW00aiMDYqoIFhtfh
	BP0usgguQ1x8GC3qEFOvvuHqHIoRdYOpZR/8FpVzc=
X-Received: by 2002:a5d:5f43:0:b0:43c:fde6:212d with SMTP id ffacd0b85a97d-43fe3e13d46mr21731613f8f.33.1776694668709;
        Mon, 20 Apr 2026 07:17:48 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:355d:3be4:308b:c943])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4cb1405sm28641928f8f.4.2026.04.20.07.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:17:48 -0700 (PDT)
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
Subject: [PATCH v9 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Mon, 20 Apr 2026 15:15:11 +0100
Message-ID: <20260420141741.2688371-4-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420141741.2688371-1-luca.boccassi@gmail.com>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B06440010
X-Stat-Signature: 6tigioa1btisyt4wojiyjbdkc7jin3wc
X-HE-Tag: 1776694670-616977
X-HE-Meta: U2FsdGVkX1+2i6imkM2xOXp2LF/PbCbEp4FSSziMFlEy5wcJruWVZQh6Hg+5wcsGS4WejAVpm9w0wBKtTNNK6CaRj9X19xZ8xYMJZfhYrwenCYRldC3ZjNu/xpYZ60PygKgH6fqhPGD6sXrUviVrp8Kmmp275skHJO/oMhVtg4NxpULnXcIV0TLvpDur3YqGmyJbMkCM0eVszRDO8GhypaqKeH26jqCRMviTx0T1WXOYv53LuMFw3pc7iQ+mZrauqv8ZfNHg5+kCtdF3HNe5RciGl7Coh5kHrrb+G+2BY3oRcVvYHyAl3vPiedemaT0Zbywa3xdP4FEfQPsFaaQVyXcU+25LfF12eijn6WFNZ5Rn+j4ut1xvTe+L4zif3gQU6XbRhOwfUNW4SEHpYknQYSFUpVY683XgRqvm2izclPKd1tKY6M97DbW4SHwjOTuHEbTCESDyUsTag8qrSghQdEITfA9thi673kli/3Ig9MesvieqsQhS314eEl+BJO04pVUMYwy1kN82kohLaCwipVKjJ/y/qruR9wUNSIrspJkRVmvR8S9ko4DBsSCpVmRsH8nqAyPFtTaycuPQPOz9AgKSw01ZgOloUAOcL1t9BwTzzAzhbgUgQZN/LloiF5WTVZ40jtP/MQ7fyGtuzoYp0K1wdLwUZ1Z8w8PejOyZFJItxBI+nt/St/aqdm3qAxRkz+WwYi+3H6D3Ud1Kp9kv3TiKFzi+qsETRWBpUrVyN/aug/aLngdyyZXFmita9FmyVeQc2zYkS7OIbyrcpzKDD63fczbSJt10KeQwDRkgix8M1YMgW24vvXgleq1y+6dwN8Pak1e5PZfqXBk3KFQgiB4ivl0p73PWHmjrlkBy5mcyNx8WiyjwbnXLmoq8C0jFPoR3Ig5SEiEINwOOZ3Xsf0pfIXUKI0k3f4+1kprJdWIYTPignGqWjX9ldlnI1Eq/EHaxJPY/nAdIX7Oj6Gl
 RxDLWqNH
 0IO9QmdJNeZLFTTU0PXzF0HHBhoY8CfYMg5uw36tBxkAHICtZ+KLHqcHtzbVCFnacoCxMk0Sr183wOZy5ONyIpm+FRYF0NyPtpvmooMJSVjyigrpARDl5qgpo8/ePC3qV5QibKgDRSCpKomGOnjL6dO7GDdTyXsSwogqpBkX6uKlUgIfneS4lGRgKUHJaHos9NHPLyzJmr0uqAg779r72HmGnNL0yxEkB7EeNazgUUPh3c/uWSDZa1vRi5XPVY8jbB1pSHJlgzheIyKGhkOjYT3vF/dH6ABFgCovoRKFRyCQJP0ReD+h6O4cu2cR9exZ59Pz6tJ8WAge6oFYtgEEt9LaPVEtElEHi4zDxuiQ+hRchrO0Lmy3NQLFBcD07tJe5WwTk9J0wTUKYqPlxa1WtJGyG3eMWb9HuJGDdyOyYPhPNDto7SxngEYe0+1vTmJDX34Lmjq/XYk5sspbJWRS6Jevf4vWZHpQekXidqxs+uGR9mnSQtWxAnH+s6867Hp2ALYubUSwoRQOUDRhZiqzmqzp1HSQi/kGByQyZclq6eUHTUHQjzKqW1xznLD9rccG2fnO/hjlt5OBUEAN6D9o0+TpzAA==
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
 kernel/liveupdate/luo_session.c  | 91 ++++++++++++++++++++++++++++++--
 4 files changed, 98 insertions(+), 6 deletions(-)

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
index 5e316a4c5d71..9e343b6ce513 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -50,7 +50,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/anon_inodes.h>
 #include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -62,11 +61,15 @@
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
 #include <uapi/linux/liveupdate.h>
+#include "../fs/internal.h"
 #include "luo_internal.h"
 
 /* 16 4K pages, give space for 744 sessions */
@@ -363,18 +366,74 @@ static const struct file_operations luo_session_fops = {
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
+static const struct inode_operations luo_session_inode_operations = {
+	.setattr	= anon_inode_setattr,
+};
+
+static char *luo_session_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(buffer, buflen, "luo_session:[%s]",
+			     dentry->d_name.name);
+}
+
+static const struct dentry_operations luo_session_dentry_operations = {
+	.d_dname	= luo_session_dname,
+};
+
+static const struct super_operations luo_session_sops = {
+	.drop_inode	= inode_just_drop,
+	.statfs		= simple_statfs,
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
+	ctx->s_d_flags |= DCACHE_DONTCACHE;
+	ctx->dops = &luo_session_dentry_operations;
+	ctx->ops = &luo_session_sops;
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
@@ -653,3 +712,25 @@ void luo_session_resume(void)
 	up_write(&luo_session_global.outgoing.rwsem);
 	up_write(&luo_session_global.incoming.rwsem);
 }
+
+int __init luo_session_fs_init(void)
+{
+	luo_session_mnt = kern_mount(&luo_session_fs_type);
+	if (IS_ERR(luo_session_mnt))
+		panic("Cannot create LUO Session pseudo-fs");
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


