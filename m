Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D502606A91D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JDSV52m4
Received: by kanga.kvack.org (Postfix)
	id 72A686B05B9; Tue, 10 Nov 2026 04:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4206B05BA; Tue, 10 Nov 2026 04:16:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2C66B05BB; Tue, 10 Nov 2026 04:16:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5D56B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B87741A0117
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:27 +0000 (UTC)
X-FDA: 85418653614.12.89A0210
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D690F40006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDSV52m4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302186;
	b=eToC1MM2BK1ZOzjwPEs7EiKEAh8nc/D8CXkmi91oY/g4f3zv4U1t6zfw3ZTSrh/Uu0CmPt
	5/931GOrzFLZSNaMmlgdXr2CUyaC2GBPDl/M5ELnEox7uUuVJw3Cp5X+soCTJEW03Vz3yd
	UDMmN5CfzMb/5lBOI3BsvnZBAZYs7j0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PlyOtqsg4uvOLuXQ3/FL9HLYIT+WYfLjjBDzOseC4E=;
	b=ry1QjwpKC99MRsQgJv22vRu/egDdB3kFW7pwNw5RFwyjlWpM/rECqlcLgm8RSgjp958e/g
	8ClEA5257om0dTcj6iu+PBuxBnr+erSD2BqRwXp+ACf8OCkc0L2lgjk5KOBKpyE1BAQLdR
	8rcBEnS20egYQQUpMpIoqdrksi327cU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDSV52m4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C96146A26;
	Tue, 10 Nov 2026 09:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C370A1F008BE;
	Tue, 10 Nov 2026 09:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302185;
	bh=+PlyOtqsg4uvOLuXQ3/FL9HLYIT+WYfLjjBDzOseC4E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JDSV52m4OfCcyst3hFku2YCPCNxNeOvikciB89hDYJCR1LbwEEt/lYeTuQQD7/iUW
	 H5tRIQ9v6jXMgiZgkJiF4GqOivkKtZZw7NCQaQ+f1NR7twZvTqcjqI+/c/IH9v/Jxy
	 EoKQxUfmWpqjCJS9oAmdJNyKK7FKdWto+bebjhA+fYE+FkEqbaHlH+Oa9uQsiCi9GB
	 3VXoXUr7iZu5zDIGq4U4YgT3MCBnLcxw8LrsjsTPugWIr6zcD/ibPJDTK7P1rf/Nm/
	 FeXmWLksNQuP1ST2JEb6k4O48XmygmJ7cLGcrIfDn6Eu2LG0Vr4DLcJUZZqj6ewXS2
	 2mhb3DLeE7TVQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:20 +0100
Subject: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3427; i=brauner@kernel.org;
 h=from:subject:message-id; bh=k3b1S5Aks24kDoWnRvLqsdiiPcKIlG2bf4Gt1cYJbvU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejDjkUK2x5tSpSe3sln+v7tvX2kk8yFWmKv/wMXyl
 fsivk7i6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIgXSGn4zTcuXEC9Zcm34h
 e6vptpmiC3asPh6Q0BteemFfbSaHeDDDP+uZ7aUJ00OdGBbc/56893hNWHZRbjDHr99CTduPlCV
 M4wIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: D690F40006
X-Rspamd-Server: rspam12
X-Stat-Signature: y8epxh4ex3cpjtsdz1cfg5boou6g34te
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302185-676692
X-HE-Meta: U2FsdGVkX191G2uZ1yJEfpO+uOwLnsDmn28+0q5PKo2eRbTwnR5nDialtd5n5txdMrvg8AFiHpoLy2+X8FQSQ9SZ+n/1Dn5A3eFQzPLNApJZ79Y7VKIhpQz18uJDRHC3M/qhkXHEJ/sDXSM/XrwYJpZX91E746hx+lfUpIHkZ0EpynLFSwH7tE5VosUDv+PJzpJOsVze3KPrO8WxBNNIiPEThx2XiLjd+kuKwv1f6yUAdHdgVfYMsA6q4BTwCF2VztvQ/K6nk+jYklG2GeHB6/l+KluWUtxtTN09jOkr8VvHFFMbW1J5BjDIaXM8Bt6ot3dToHuM7JXCNXts0o59Q5AFQww/wBrpgIlsnbAkn8J8dhaefMUHI3pEl5FuT6cBAczxFJC3MmrZeC5kUmbMtgb14WEPCmhsFfj+UqO75d8z2a+plwNAojk3Mn7V71Rs6vZtZSkeywyMCmviTyghUE3Ir1H1Ci0YjKRyp5gqCEi8f0z3v6l89dli3n+jcIrt388Z7o2LMYQoxu1lrl0l0hxBskPNf/CfIbJx3lcvGjXl8cSPhotGURPIUxrodQoBs6LZsbDbMJzlWjoFzc1xZKnSCkbJuqMFovPklm4xToi+Y914QByyEw0q932twJ5oqoibUk2v9TzZFJUIS4TzwzNu2/6Jqr0H3PI+pKVQLyzLkIvEaag6QSNHPM4zuXmMW4DMJbggKgznNJMGU6B/gumFeOu1Th7B8WLWf0+QbTq49ND4EoGZ5YlNPzhZIWgdaxc8FVnBfGWV4uAm5R53Y/0B1EJaVgK+0kr9fYk5K2/04bEFCfjfLIAN8IFtTyFUVMz4VaZ1ofm8DSG6SZRPVSdFOrEuVz6ISa0XAdg1nGL4VbrueiVzU9OXNzTf9j6iw6ZWbtiZSr8d0C1n0+kS/Pz1KnjeuJlBSdepRaX2InAbk2tD+4e5gO1M1QNB3pfnHg6DAKZCz/6OJSZdQ8P
 q42h2dot
 ovVyCBl5IOc7vV1aQNXrrdfW19w5kCD6KGDImabRFjrx9iQ0K6cKK9yx1W8GXvKzaIPyo43vkzvwrT3zdk6sT6FlaIbudcGvoGRr2f4mPQwsvbQXaZYrYSbIIIMyXmhwRhE9C8X4BkMrslJcoWLo2uRR0BccTHIYM477zdbx0yu6MVpQA3gOLHqN4Ft+POoxuv0VFix/KuPOe12YmWrbXLS0ZiIuzqHy93Z4NdxrryCgy+YeCExqsQcBymqN5m6Pzo3HiEc8VYNaJqDOXLr+wPY69Q6iLA7opc7BmSeUyucIvMS9zP5bfxUMLOuVS8OYlGaaHMJ8Wfrcs3ZasYiC6XqeGuTcFW940MpdzYj+AU+YHnRT21xMO/n/gX8AXTP04xX1HHNVI0TD0Do/AyutRJL014X/3Jo2sHi8vUzRCezZFCzyMuHag+wWS8vbyX8Hs+ZWi
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/libfs.c                     |  2 +-
 include/linux/fs/super_types.h |  1 +
 include/linux/pseudo_fs.h      | 11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 96a6e9b1535f..8c8789489fdf 100644
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
index 72f4288e16c5..472200bdf081 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -359,5 +359,6 @@ struct super_block {
 #define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on this superblock */
 #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
 #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
+#define SB_I_PSEUDO	0x00010000	/* regular files are kernel interfaces, not storage */
 
 #endif /* _LINUX_FS_SUPER_TYPES_H */
diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
index a651e60d9410..0ca408aa60af 100644
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


