Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0538160A6F4F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RD5VsZN4
Received: by kanga.kvack.org (Postfix)
	id 14A016B05B7; Sat, 14 Nov 2026 08:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA2B6B05B8; Sat, 14 Nov 2026 08:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05566B05B9; Sat, 14 Nov 2026 08:06:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C71F56B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5516A1603D7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:07 +0000 (UTC)
X-FDA: 85433747574.15.7E53236
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85F6D1C000E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RD5VsZN4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBMFsDX8jPf40Ops7fmXNGVPlFkxVQgzGux0hDAKlKk=;
	b=SceGy9BExWGvMUa4Amkljm5TAmb/imE273/+CZ6LM5bLBM5knXAM34xUVa9xhuNlGl7o68
	6lQTIvYJ7DW/8FIPzpRaczi7z/0nqBtOtVXptptSGMKjMNOKSDND0vL5FMy7zBIH1MxVD4
	jsUd3QndfUmtQAoeBCzqPHvBN+VXaBM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RD5VsZN4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661565;
	b=p/+Ak+8+W8LPbCpGCVeWbhusiJ4v20wKI1hxLXkDcaRRUx+JqbIH+xKBuA8zrNkKowhJq2
	HrHPQhJluKgRgQegwobQl5LJOfXNLonWbmh7/tOcelG9Bo1hrxgqDrPwH7kQ05Bm48Yvgz
	vjVpOkanMAG3rndwMItxmzxxiyFULLk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC0DA45EC8;
	Sat, 14 Nov 2026 13:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFEC1F000C6;
	Sat, 14 Nov 2026 13:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661564;
	bh=XBMFsDX8jPf40Ops7fmXNGVPlFkxVQgzGux0hDAKlKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RD5VsZN4sq2RqmQsT5z5jrMvNyxT631psMzcncHkeuuOg4+buqvJIz9dkv3jYlcRR
	 V2pZL3WoNUnQEP51tR/BZ3mcEYArPXsdK2URRwWSRFhtvKx/JSyOxbx/SSxSZ03vHz
	 Lflt0K4kNkqkrNxJOQZaDKj0oL/iqRPc86/OPdzz5wXkK5HEebo/kdwARHBNP73YFr
	 tAG70yUnJ+/yOTbVOqVG01afbjhJSRs4hdUGrwmkNVaypvzLQCLkzUB2I7in22IT4R
	 nFR55mmB9LvTaJ1vKj64yR5+aC/v8xo6K6N+tsYNJVtxrK4ZLCG0N1UNDrdBjPf7bF
	 R7x3k02G1lVuA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:45 +0100
Subject: [PATCH RFC v2 04/42] fs: add SB_I_PSEUDO
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-4-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3572; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5JLKbJArUBEaIJcAIKA7+ivAi2N0PjM1HEiHb7NbADk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMlyW+O+wt51Bs/Rm+xntS/n7+nkLV168mrgXwOOm
 nPMrH2bO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby15qRYZ9AT0+/1KY3tab/
 N6s6/rWxyZ1wxuPSVJclEfO1Kp4YczEyXJBmutLyZ+8jg2D9Y+vLQtfqn2zhyZmgPuld0JlpJ8J
 lOAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 85F6D1C000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: uj9c3oa9hixzxmeiqnbnz8idgbkc4mte
X-HE-Tag: 1794661565-762283
X-HE-Meta: U2FsdGVkX19slOg2lC0f0a4s/hszThArQ7wKZKkS/1FGMnMAEp67JPbyziPVDWx8241A3JH7Tr396DAWxMJIcltv7hq3q5fffmdy6UdetiX/4aVz02KkUGcgH2GO9S5DDpky2dsf/O6m+ehImv8xTDChOx4kcGJ65rANp1PSvnpy3nzROBgQVb0W6QLsTqPXAqjwT9TqwWlSXqqOEZaNAIUyNS9Nfh/cIc6MAKLIbr5sI0djEwtFW9+z0kFce81X/gc3PTBUUzyCws1QSMIoDP+06aaeTxT46IWbyZahJbTAhW6h9YDsmcKSmjF+ocEBtkY+3anHQGJDjtGhHLqtEwHlrkl0dhZtDkW/UIngkCYZpauGAwxxfJqspbqnYPP7xnAjF756oYfoBXB/lqsztmuN7apwcbo52lTrr6+m1mOoO+NDGNxyXdC956V0kW8J+Kvx9NwZ7GZSp0uFqYVCBxaxR0ih3csEFsDoschlRPNTjCARYcszZ9PuTz0SFAxx6xJmnSVZDkaIr42zsGeofpYvWTb16JxTtGFhRi+6U7vVw/MWEBfs5qQBAYy3zlkgn3nJQZm6srbQr7IAhY1Tcj3SfDBgJfhkmTsoXHwhvXKaO2HODmu6Bho9ZLNP9e4JDW3wj3480eeDDiwM6KXBr+e1doDBULKalJKATczZubA19uN2a7CFmfLLwWJi6DprZ1FezslsPqP5xYahLTSxpcfxDPa9Od8XZE+D+afMj1HnflU8eYajkEUYRU46boInG04OWOvzz9AGNiRVv9IPRQCGYEYH8wqiQmm7efK7kIJgKqEOI4/mbNEZLUecrvjRXZBaHSDuKuW0yeaWNpEQQxeYOVOZ8BHjt/f9XDId59vldnfEvlNmaLYL5KCNIwYHWdYLp2Va76PqF481Dmz/FifcHwTGeS6DKXVLiWbYLBewnFfC4m/+35mDUl0gzMGgcFf/Y+Gh6XrfUpExn8O
 K9d0aDBH
 WgsjGS65GeYuZnMuy+lb17GhJkbDdXY8C/oLFIMhJOtuakBrp5L/XoYY8vSU/UKbnUFEBBXu6kvyuT2tBMIGppZ4xGtnc3X8QGrbD6iTXbrq2NqZi3aSFgtkcS/zMlXDkpSNYERSBsj9bUR+3tu9RxxTfjxFgWqMa5Opbv2bN1ZY4tNQCx9DmU6Pug8w+b5Han9kNh018xH63tRmCQo5Vq4NfCPktpdnph2Wvig83TPGJa6YBiG0NvjN1eFkQYUq8Q04u9KMbtC2tPK0E+WEfvSDgdoZt5tcFDtDCMOk+AKK4MvPnLPDmo5hH1uvT4HU7V2D79AoOdjRza50IPrznxr3escKatduj/h2G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, there's no way to tell whether the files of a filesystem
store data or whether they are kernel interfaces. Files on pseudo
filesystems such as procfs or sysfs generate their contents when they're
read and writes to them are commands to the kernel.

But a few places in the kernel take an arbitrary file and use it as
storage: loop, zloop, the nvme target's file backend, the scsi target's
fileio backend, fuse passthrough, the usb mass storage gadget and erofs
file-backed mounts. At most they check the file type and whether the
file implements ->read_iter() and ->write_iter(). That's not enough.
kernfs provides both for every sysfs attribute for example.

Add SB_I_PSEUDO so a filesystem can state that its regular files are
kernel interfaces and must not be used as storage.

Pseudo filesystems also never hold executables or device nodes. But
currently each of them decides on its own whether to raise SB_I_NOEXEC
and SB_I_NODEV. Some do, most don't. Add fc_init_pseudo() as the common
initialization point for all pseudo filesystems that raises all three
flags and switch init_pseudo() over to it. The following patches
convert the mountable pseudo filesystems.

Nothing checks SB_I_PSEUDO yet so no functional changes.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/libfs.c                     |  2 +-
 include/linux/fs/super_types.h |  1 +
 include/linux/pseudo_fs.h      | 11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 96a6e9b1535fb..8c8789489fdf9 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -735,7 +735,7 @@ struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
 		fc->fs_private = ctx;
 		fc->ops = &pseudo_fs_context_ops;
 		fc->sb_flags |= SB_NOUSER;
-		fc->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+		fc_init_pseudo(fc);
 		fc->global = true;
 	}
 	return ctx;
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 72f4288e16c52..472200bdf081a 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -359,5 +359,6 @@ struct super_block {
 #define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on this superblock */
 #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
 #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
+#define SB_I_PSEUDO	0x00010000	/* regular files are kernel interfaces, not storage */
 
 #endif /* _LINUX_FS_SUPER_TYPES_H */
diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
index a651e60d94107..0ca408aa60aff 100644
--- a/include/linux/pseudo_fs.h
+++ b/include/linux/pseudo_fs.h
@@ -2,6 +2,7 @@
 #define __LINUX_PSEUDO_FS__
 
 #include <linux/fs_context.h>
+#include <linux/fs/super_types.h>
 
 struct pseudo_fs_context {
 	const struct super_operations *ops;
@@ -15,4 +16,14 @@ struct pseudo_fs_context {
 struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
 				      unsigned long magic);
 
+/*
+ * Common initialization for all pseudo filesystems, mountable or not. Their
+ * regular files are kernel interfaces. They don't store data and pseudo
+ * filesystems never hold executables or device nodes.
+ */
+static inline void fc_init_pseudo(struct fs_context *fc)
+{
+	fc->s_iflags |= SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
+}
+
 #endif

-- 
2.53.0


