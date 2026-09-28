Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C66CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04466B0092; Mon, 28 Sep 2026 17:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B44C6B0093; Mon, 28 Sep 2026 17:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B146B0095; Mon, 28 Sep 2026 17:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC566B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6130120335
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:18 +0000 (UTC)
X-FDA: 85264469556.03.9B5F384
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id ECA9A2000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790631137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QqWvSzAu/6FgKcInY8BQld96UyanENP4lkTJ+z/0pmQ=;
	b=sIn4UxN55ifC+CXcsNYDpsvgA9JhB1zrAaNelXBnIICN6KBYFhE2Y4os6Fvj9piLKMqSU2
	v4rGzUVWpH10e1z6OTQC7Xet4xzAL/m4BbdCjCB5LcqHb/KN7bj9v7qSoYAwh7gtZpiGTx
	KUNF2/cefBIo1ToUsHvAX0k0Cgui4cE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790631137;
	b=U95g2MYcWnKMCJYPwEWnhbMjlzkhu7eUBhxOagzkp0sRZAKxAs2pqRA96/idBnTzhCBNBf
	DkdOWFx9Fz0P6l2XaV7TS6kCtwbubwIM01TrcgSuWFsPrGA/yv97UwAQlcbq1Lyv1dJUcH
	sLUCDsgSpPJ6QM1j0ObEj25R/gB8pqg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0159B21BA7;
	Mon, 28 Sep 2026 21:32:16 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9328C133F1;
	Mon, 28 Sep 2026 21:32:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DB8SEt/cumqgMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:15 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Hugh Dickins <hughd@google.com>,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	linux-ext4@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] ovl: Add /sys/fs/overlay plumbing
Date: Mon, 28 Sep 2026 17:31:54 -0400
Message-ID: <20260928213155.2612039-4-krisman@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928213155.2612039-1-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECA9A2000B
X-Rspam-User: 
X-Stat-Signature: qgnut1ywxc1xn9azxcuzqxi6x1dq9obd
X-HE-Tag: 1790631136-677484
X-HE-Meta: U2FsdGVkX1+S7rJSz257mgZOEuyAeuNCM+a2FXSBn4IlD7D1NVHlw7YHBIGid6LCy8w1IYncgMKhyS3NESOp045OEA+UjrfnnEGmnDu2BY+dUzK6Z4lEYCv1Vb6PaeTxrr1AbwVL6F/Mwl/gHZOp82WNYBOTrCqqdTHWeLvLeGXR0p6kuIfccMBZ0HbcpD+llWmfyQh/9mConaT44xxyGmsy7YnnYaYQq+GE+Adr7CQLeehh074IgCSN5Qo4wjfD5pgRlNbUbVrIdFOw7Pi+NfQpjITnv0PWVTGC+a00tepNjBCYUajt7V0EH+htHuTBDChoVQwstObdXhW+gwlA3HX9//GGXqWrpoJhqzP/1Qr94fF2J8Ydt6OImo8sbymhN2eDIO+dTUtIlHcbjcWJLicb6fJRb2mMauxYTYgpdG7UihfgymSPU1KUta2d8Rmp+jCTz6P7xkkXS1D45AJrRN0HTG+astsHedeeSkhpqGrOZ0sg8KplLC6KaM6W7BteAzhzknWZjuZ4x8rkesG1k7kfkHa+UTo+wW6zEymC+w+CYrzHhTJS8aURP6Ya8xEo1onvrsuBJVZr7bmaGOLS1SWZnBOJwrz6BAhtmEj6GYtgiWypypSOFSG/J6b+MncpYW2AKKMWkwWDgebKM96QbhRcsZi+5Ptx/zMeX6JdMw+Zd0DCgNrXe7VQwh4iTAIoKQ1z2EroXTmJQTy5nqRGEyfNICe714NyKYz/Nbc6Kazfxu8dOhPJN70HB8Q802LG/1E2geJEva+ceoYJQmfiwziML7FNaZCSoI/imtQbCkZG2+PgjHjPoCWZc1wJn3lgYVHXESLdCArbzuR9KpMZClmEpLIF220SpxKB6chO3YtaZ+lvTBDL2bbV+UXuN+jUqRXcK3b5XE6nLQluDWQz9Q89QK5tV+YijrIVoxTr5+W+A641eU3fwIIoVjhN8t1lTk/ALxcz7UZITo0qedf
 LYfy/wLQ
 fCuCz1DLrmU/l46LnBVNIzOHRzPcrCx7B8WXBzbh8upZ32z/6CHt5urCEqIcHo0DBQZ3la6fyE348ycbIx7rXRLjBhOP3K/Z3OOr3qovAKjOoRKNUE6U3U+f4GG3djjv8GMrTyi0s0yX8edVoLjuIKQUG4vD7rG9khDjLDmh2TSqhdrNvi/mY+6MadFQbPneivQhifA+OSpFxOWjgrzb3CK6r5f+x0BywtC+FwyiWbEI17U3mXUSKwir5uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation to expose encoding settings in sysfs, add a subtree for
overlayfs under /sys/fs.  The only remarkable detail is how we reference
the volume.  Use major:minor, which is not very human-friendly but it is
at least discoverable.  I considered uuid, but that would be a problem
if mounted with uuid=off.

Assisted-by: LLM
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 Documentation/ABI/testing/sysfs-fs-overlay |   6 ++
 MAINTAINERS                                |   1 +
 fs/overlayfs/Makefile                      |   2 +-
 fs/overlayfs/overlayfs.h                   |   5 +
 fs/overlayfs/ovl_entry.h                   |   7 ++
 fs/overlayfs/super.c                       |  26 +++++-
 fs/overlayfs/sysfs.c                       | 101 +++++++++++++++++++++
 7 files changed, 144 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-overlay
 create mode 100644 fs/overlayfs/sysfs.c

diff --git a/Documentation/ABI/testing/sysfs-fs-overlay b/Documentation/ABI/testing/sysfs-fs-overlay
new file mode 100644
index 000000000000..9060c39679ae
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-fs-overlay
@@ -0,0 +1,6 @@
+What:		/sys/fs/overlay/<volume>/
+Date:		September 2026
+Contact:	linux-unionfs@vger.kernel.org
+Description:
+		A directory is created for every mounted overlayfs instance.
+		<volume> is set to the device major:minor.
diff --git a/MAINTAINERS b/MAINTAINERS
index c2414447892c..e49f84c4c691 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20586,6 +20586,7 @@ M:	Amir Goldstein <amir73il@gmail.com>
 L:	linux-unionfs@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git
+F:	Documentation/ABI/testing/sysfs-fs-overlay
 F:	Documentation/filesystems/overlayfs.rst
 F:	fs/overlayfs/
 
diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
index 5648954f8588..fd4e747820c2 100644
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
 overlay-objs := super.o namei.o util.o inode.o file.o dir.o readdir.o \
-		copy_up.o export.o params.o xattrs.o
+		copy_up.o export.o params.o xattrs.o sysfs.o
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e0d8c6152e9f..91d3894d9bd2 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -939,6 +939,11 @@ extern const struct export_operations ovl_export_fid_operations;
 /* super.c */
 int ovl_fill_super(struct super_block *sb, struct fs_context *fc);
 
+int __init ovl_sysfs_init(void);
+void ovl_sysfs_exit(void);
+int ovl_sysfs_register(struct ovl_fs *ofs);
+void ovl_sysfs_unregister(struct ovl_fs *ofs);
+
 /* Will this overlay be forced to mount/remount ro? */
 static inline bool ovl_force_readonly(struct ovl_fs *ofs)
 {
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 80cad4ea96a3..c14253e75826 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -5,6 +5,9 @@
  * Copyright (C) 2016 Red Hat, Inc.
  */
 
+#include <linux/completion.h>
+#include <linux/kobject.h>
+
 struct ovl_config {
 	char *upperdir;
 	char *workdir;
@@ -56,6 +59,7 @@ struct ovl_entry {
 
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
+	struct super_block *sb;
 	unsigned int numlayer;
 	/* Number of unique fs among layers including upper fs */
 	unsigned int numfs;
@@ -92,6 +96,9 @@ struct ovl_fs {
 	/* r/o snapshot of upperdir sb's only taken on volatile mounts */
 	errseq_t errseq;
 	bool casefold;
+	struct kobject kobj;
+	struct completion kobj_unregister;
+	bool kobj_registered;
 };
 
 /* Number of lower layers, not including data-only layers */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bd0a3f9039d2..d195dace135d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -226,8 +226,10 @@ static void ovl_put_super(struct super_block *sb)
 {
 	struct ovl_fs *ofs = OVL_FS(sb);
 
-	if (ofs)
+	if (ofs) {
+		ovl_sysfs_unregister(ofs);
 		ovl_free_fs(ofs);
+	}
 }
 
 /* Sync real dirty inodes in upper filesystem (if it exists) */
@@ -1548,6 +1550,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (fc->user_ns != current_user_ns())
 		goto out_err;
 
+	ofs->sb = sb;
 	ovl_set_d_op(sb);
 
 	if (!ofs->creator_cred) {
@@ -1559,6 +1562,13 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	with_ovl_creds(sb)
 		err = ovl_fill_super_creds(fc, sb);
+	if (err)
+		goto out_err;
+	/*
+	 * ->s_root is now set (by ovl_fill_super_creds), so if
+	 * ovl_sysfs_register fails it will be cleaned by ovl_put_super.
+	 */
+	return ovl_sysfs_register(ofs);
 
 out_err:
 	if (err) {
@@ -1598,10 +1608,19 @@ static int __init ovl_init(void)
 	if (ovl_inode_cachep == NULL)
 		return -ENOMEM;
 
+	err = ovl_sysfs_init();
+	if (err)
+		goto out_destroy_cache;
+
 	err = register_filesystem(&ovl_fs_type);
-	if (!err)
-		return 0;
+	if (err)
+		goto out_sysfs_exit;
+
+	return 0;
 
+out_sysfs_exit:
+	ovl_sysfs_exit();
+out_destroy_cache:
 	kmem_cache_destroy(ovl_inode_cachep);
 
 	return err;
@@ -1610,6 +1629,7 @@ static int __init ovl_init(void)
 static void __exit ovl_exit(void)
 {
 	unregister_filesystem(&ovl_fs_type);
+	ovl_sysfs_exit();
 
 	/*
 	 * Make sure all delayed rcu free inodes are flushed before we
diff --git a/fs/overlayfs/sysfs.c b/fs/overlayfs/sysfs.c
new file mode 100644
index 000000000000..be83b57f637c
--- /dev/null
+++ b/fs/overlayfs/sysfs.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Sysfs interface for overlayfs.
+ */
+#include <linux/fs.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/unicode.h>
+#include <linux/xattr.h>
+#include "overlayfs.h"
+
+static struct kset *ovl_kset;
+
+struct ovl_sysfs_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct ovl_fs *ofs, char *buf);
+};
+
+#define OVL_SYSFS_ATTR_RO(_name)					\
+	static struct ovl_sysfs_attr ovl_sysfs_attr_##_name = {		\
+		.attr	= { .name = __stringify(_name), .mode = 0444 },	\
+		.show	= ovl_##_name##_show,				\
+	}
+
+static struct attribute *ovl_sysfs_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(ovl_sysfs);
+
+static ssize_t ovl_sysfs_show(struct kobject *kobj, struct attribute *attr,
+			      char *buf)
+{
+	struct ovl_fs *ofs = container_of(kobj, struct ovl_fs, kobj);
+	struct ovl_sysfs_attr *a = container_of(attr, struct ovl_sysfs_attr,
+						attr);
+
+	return a->show(ofs, buf);
+}
+
+static const struct sysfs_ops ovl_sysfs_ops = {
+	.show	= ovl_sysfs_show,
+};
+
+static void ovl_sysfs_release(struct kobject *kobj)
+{
+	struct ovl_fs *ofs = container_of(kobj, struct ovl_fs, kobj);
+
+	complete(&ofs->kobj_unregister);
+}
+
+static const struct kobj_type ovl_sysfs_ktype = {
+	.default_groups	= ovl_sysfs_groups,
+	.sysfs_ops	= &ovl_sysfs_ops,
+	.release	= ovl_sysfs_release,
+};
+
+int ovl_sysfs_register(struct ovl_fs *ofs)
+{
+	struct super_block *sb = ofs->sb;
+	int err;
+
+	init_completion(&ofs->kobj_unregister);
+	ofs->kobj.kset = ovl_kset;
+	err = kobject_init_and_add(&ofs->kobj, &ovl_sysfs_ktype, NULL, "%u:%u",
+				   MAJOR(sb->s_dev), MINOR(sb->s_dev));
+	if (err) {
+		kobject_put(&ofs->kobj);
+		wait_for_completion(&ofs->kobj_unregister);
+		pr_warn("failed to create sysfs volume %u:%u (err=%d).\n",
+			MAJOR(sb->s_dev), MINOR(sb->s_dev), err);
+		return err;
+	}
+
+	ofs->kobj_registered = true;
+	kobject_uevent(&ofs->kobj, KOBJ_ADD);
+	return 0;
+}
+
+void ovl_sysfs_unregister(struct ovl_fs *ofs)
+{
+	if (!ofs->kobj_registered)
+		return;
+
+	ofs->kobj_registered = false;
+	kobject_del(&ofs->kobj);
+	kobject_put(&ofs->kobj);
+	wait_for_completion(&ofs->kobj_unregister);
+}
+
+int __init ovl_sysfs_init(void)
+{
+	ovl_kset = kset_create_and_add("overlay", NULL, fs_kobj);
+	if (!ovl_kset)
+		return -ENOMEM;
+	return 0;
+}
+
+void ovl_sysfs_exit(void)
+{
+	kset_unregister(ovl_kset);
+}
-- 
2.55.0


