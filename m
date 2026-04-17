Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB3DF99C6B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 22:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0794F6B0150; Fri, 17 Apr 2026 18:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029B16B0151; Fri, 17 Apr 2026 18:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60CF6B0152; Fri, 17 Apr 2026 18:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D07A36B0150
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 18:08:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F9091A0343
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:08:41 +0000 (UTC)
X-FDA: 84669438042.19.815CE4D
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 92A5640010
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:08:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="DNqFIK3/";
	spf=pass (imf07.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776463719; a=rsa-sha256;
	cv=none;
	b=pOmDBMxfb4e7zGmujbDXIqtZKS0FAjURe21+a/IBzXtOzRYJkebtCN5btpGSUwROorjepa
	roErjZ012UzkWYjKjDKrF3tfe5yBRQDemir6zpO7vEXV0OBP9K+BR906Qo2Gpwnet5rIJ8
	twtL0rZwD01ocvZ9HAx4HiQ1hCWyArs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="DNqFIK3/";
	spf=pass (imf07.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776463719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DQ9xlAPY+R/A3MFjqRDZTVfO9MTzDxB8518v8MGn3iM=;
	b=QLRgjMzUHFX/QVj93RIp5M8da/6bslO1pmW6dG1KT3TNPzb/ToimfNmxLVnOC1H9/15jWF
	vxtZ8yy1KGXUPBOm4pjt3gkJM8bbcDH2brkCzIaSs/LwwKLgCzvWpa1BCdj2kpro0rMZ/l
	Qrrqf4tZUEss1znmNMkA8O8wBLFj6dg=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso10981475e9.3
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776463718; x=1777068518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DQ9xlAPY+R/A3MFjqRDZTVfO9MTzDxB8518v8MGn3iM=;
        b=DNqFIK3/pNNhuEQkqdhmK4gjgf2cwJ/beb2SB8c744rbmhomgG5zRTv4voqnJ8bhYh
         xR/FozyCnXlLdV4SLKm0oYRxziqsxKsUQmhPooGkz1UVNcYPtpSYM9aHXUcJ6QYDc5bY
         EAyQ5R2mIgaDqLCskQ10cZtUIT3+T+ZNTLTs434//qF/HE/ei4wG/Cd5z5lHZkmbgbiw
         hQtBA/lDf+igMGUX+VyukP0Xk8LUnS4zQubgD+OcJ5soCF/SbhPUZlsoSleaks43g7dz
         oz6jkAoGALYlw/xLimZNUBRz1KbW8XEhW+FTcqVAWlqphmNzjtTjrtC8//5i4+aHf/WB
         3ODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776463718; x=1777068518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQ9xlAPY+R/A3MFjqRDZTVfO9MTzDxB8518v8MGn3iM=;
        b=cEZj8Q5vMxQbdhmWFK8x7QPj9Ev1qPC3/QniI55fS1o4UgqZvLrwmL1ErVn9tYTwji
         pYJFMESuBpptPRGOtvRI/A0gyBJbKqsqtJMjvbAbmzrOefKK2XKYF1E2yTrzc/dcb5B1
         +myZ0eSC85bkCJEpYRRLR/1kv3xVbLPbPQlqNBd3+gW/prqLx6Io0oH8r5DWH+8Fv+G1
         CADMuAs6vRGstY0pi96wb5OaevsZa3uIpYxAcFQMFm53bTz8jzqXlzauSy3yfKlOeB4l
         xAEzma55SqDzpplP7rww07mLRS91oduGFkzOf5Jh1hBaIGa/BodLJgg+H+kL2DV9/5+i
         qBfw==
X-Gm-Message-State: AOJu0YyIK5Pv6xcpGxZ7V5VCsgRIS8JAIV89sJmiCEqLMKDBPOM50uTa
	+/WSKemJ6L7iAMmmMYTqaiduqy8856c9rg5lnOCeov1Tt8l/GSZlLQgL
X-Gm-Gg: AeBDieu1tG9aph5mOHi5yU4gCYjY10R7W9Vx59DeFQYJ8Su13QJ9QGj8bRQEmvATaNS
	L1q89wx/U5HKA1A+FNcL85Wkp3bWpZIuEtQ0sn3NOYpfO1mthi7E1HpnEj1k1sIMGB4qcQPcGax
	FMuDJ610PEUm3HpHYPpm3nvVhNZqjxrRvvpQiSRq+RzQzwxTb5Abwtn7EMiwKrXLVYNjfMZqVlG
	FwrvL/bk1/LdI25frtjZ9mouxH2HXrARadw/lpvnoEMBbbZLvyyVLRYnpbZRB4GJXgtDyLdbapx
	uot4qNHqu7Yw+cMtPJSyFNlAwpNIOuUzmAtTjXWAMk0d75R8xeMsIqd8UAO/NHrgnnxcjkOYga4
	Rm5xn1xsCDXV5Xze0cgTKRqe/WoNdjBUcl0yk4IbzJWpnl5Wp6LAx02OjxOx6cbhIdaYCarcJ8v
	cnGXiejuhOkZlED7iOFTkMeqlmmpam6CHOIJ0EIF0=
X-Received: by 2002:a05:600c:1c11:b0:488:9ed3:148f with SMTP id 5b1f17b1804b1-488fb782a93mr68816885e9.21.1776463717808;
        Fri, 17 Apr 2026 15:08:37 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:9586:30a1:a0a6:f076])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4890009e759sm17946355e9.6.2026.04.17.15.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 15:08:37 -0700 (PDT)
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
Subject: [PATCH v5 1/4] liveupdate: add LUO_SESSION_MAGIC magic inode type
Date: Fri, 17 Apr 2026 23:05:42 +0100
Message-ID: <20260417220831.1934945-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92A5640010
X-Stat-Signature: e8u78afdmnahysd4ijxnqkspp3xusnxb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776463719-150247
X-HE-Meta: U2FsdGVkX1/OvRujWNOz8D4Q0v/Cn8N/j/gKzQ0m8XCdkF/rJK+RVjZ4rmZiECy/f019sUCi55J1hVbSn+r3NpuM9qjOQzS7hlC+ny8KtYtH3e/9E/nP4iUZqNkRf3KeX++Vk+VvYLcQ5yVYqhSYAb44AQA/Z0zbqaGM1WnndSl48qtPWirMHfmy2wsB1Sv7m5oLc0XwJUmZHs+HvCL2xy4Z9VYwYYwGNhhHCR66/8W/PikNCo+vwLmhOHZRLhLehmtyCPW7vwqXpeHda2Z9yb5v5POlXrer+CliFZzQNJGLdlKSRdWrr5wmFOdBeakKRsyLPhGxfeD8fSsZQTV0tXS3KCx/5lbwxsuuB/HiEPw7jns/gv07yA6X9NCbt725JNb7IEvQb5WsgyUyfZUDNMgYJlrOc4+fW0VrOeEMEai5g86dSmoxEWj3oO20EY2SHyaYDFtD2fdyf3CxxDT7HjpkW15OudU1qiD+jYX3Mz+hOQq3QABztL5ifm49gmxnNxjHXRer//0HkxRNIW7+sXQ26N/5cOOEMoP/BY3qhT0BG2ZjyncgUB3hsVWsphDxOBSSdKxS0tEwv7JDXfT6ug51px7n8Iuyqh/0W3hHmALvX5vt6nWKOns35y/nFzgc8dWrAjfBm0gd4JFaroRR4T1JIF7oL4qh54SgWdUbzk8B9i8hRT4FJsnFaE7E06YaiggGJDFGOQsNBMFquRfQ3sELvaE6I8ZyUyqfczHohd6tAiRfzWmYZmWkPuroyGy/Sn2in6on9ZVLmZ304nj4Qu8x3A5TuLwz2oUJW5OVQINUpcEKv7aq1agn7vnsitIjUJ20Yz8gM5fDkfSBd08Yp1ybJIs0lYaqB2aBMKWiBSLJsl67CDvQ0JqiBhvwer3ooDzYlc2wVQiUxpMBPUFGgt7HuRvk0LggqHwNJUsiO/2av8bqmlQEAKlte1mon0mP4yQdFCnTxG+vPCV3I6W
 6pdRo00E
 LPMRIvXV1eMpYtg+QbLkLadgbcP2oY4yXnAjxCQX+j5b8bkUhWhuVg9O3ELLFHizEbhnMPHv18zVvkmIZw+DXkjit1e+W9CD51r+sJK/4kPv/Hy+1BSq3WP0AZn8KEZDlprUGHPMuar3foJWx/Nx26xClfq4q+FGNkOs0KDoIDQYnYBc/Alim40TmYJsai36rn6YKducpdOqzA7zaNt9rUtgL1lPkh3lE96+cc81apV8vcvk46xPdiqlECM56qCiWHRYL4RF6XYT+WHlnLhjYsMTxItPiYy3hfLylmnaVW8ZlcY4orS9faqPHopMh6MJLR2zTdYn0VCdE+FVj+41xR8SWqEjGh0j28SCnLP8uVwhi59K6GCiVTYhM7PNs1SP6If7BdWD6aPmTCa6mwb3ngXUdn2TK934BFhlFPi46rMFYBdq84+2N9d6vpVLsEGcohJ+s8QBSZosxXbGrszPs9oRLxHELSX5mNv8M51SdYhXDRbyUCwNj8xCIxA025xPhrkzyRW2nUpqx3jh9hYug/FeoTIm97xi4BODpdaUKDNw00uTbGCxxSCPMmXySiD3BrxW45CIeaEERQn5m5onZ8XltcIx2M8W6O1nJBGMQOFKShWJ5olfSaU9IOa+lHa9DnA9CNl/AmpOxqW2QLSnz7rTBvcNLrgA3XhDO346w4Juk3nPebTHIwNtElJwssKxcmfD9a4cSyKwTl16YCPRi33an2fdNv8okSMDbbqga3Ppbal9IPeHbpMog8cXHxInM48AoNJGZEDG6SKY/XXXEU5L3DQ==
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
index 25ae704d77873..5e315cc0dfd52 100644
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


