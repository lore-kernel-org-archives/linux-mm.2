Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901DC606BE3E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kwDqbPlI
Received: by kanga.kvack.org (Postfix)
	id 9DDB06B05D5; Mon, 16 Nov 2026 06:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E936B05D6; Mon, 16 Nov 2026 06:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CBA36B05D7; Mon, 16 Nov 2026 06:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0FF6B05D5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00957A08B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:37 +0000 (UTC)
X-FDA: 85440704076.03.7E52603
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4192F20004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwDqbPlI;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827196;
	b=iAj2SREBtLnTX1ggHw6fgv3jsXVyA85c2usPPeKpSxBt1t9ASarrE832I1R+dtJAAj+6jr
	7JUyfU72jn4SuMkGy94gFetrpi9O1Gy3KwbuE70qvozIF6ov31yxjtIDOi3Vc3meXVbAlp
	tuW9w/oaru3Zxp+1I+MZarzWzY8OkW4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwDqbPlI;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V82ztJBNlPhaz+Wx849jUF1Fth1Va6laWHBuR1fHMH0=;
	b=naFaiuRw8HujRgdS9NUWHnUOGxLdDv8SoooAbtiTuLh8LYyjHgMd3+RVxQc5OOrWWmNlBI
	jJ3e50zgWxPB+4mQCYqtPV7WW2pwrbbkDzCVuPEyaek/G40gGw68aIZrAuHHMWojjllRHN
	ntOAYiiR2XvkFq9b4DfeAYqAn9jEObs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF9C1628FE;
	Mon, 16 Nov 2026 11:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849FD1F000C7;
	Mon, 16 Nov 2026 11:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827195;
	bh=V82ztJBNlPhaz+Wx849jUF1Fth1Va6laWHBuR1fHMH0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kwDqbPlIEVin342bCV66mFc7w5TjDAG4QWgv0QPZ1iPybKt1uBx3pT88iGIZJjfxj
	 zXKtX4RwjRqJ1feSvaMW10OvKhkIbyo50QUFDvmHyOrEfSMH4I4ZB6qtqDGyn4lrKu
	 raphSXyqDO2TqDVRMJIz3uphpPuYJBCGYPN58KBOkNRA7wFcbm8ORc1aO05+VttQZO
	 CRCwtXmY1UhCDsMTy8/O3N0kW3QRUk+0ETDpA11tc+X/KUcXy3jKuDwqNRzTIxNSzv
	 t2YFmGchSCuI3EOQzBUg3DdY+vE7hPRWitKH5GBmz+8uIr8TqLiBn/YfGeAmNho9ae
	 96VtBlXWqQRPA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:37 +0100
Subject: [PATCH RFC v3 04/44] fs: add SB_I_PSEUDO
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-4-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3846; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KiwRkIO1lHh7OMwJFZf89sR/oYY0Mvh//bvL8i/DzWw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epx8W8b22xob5YkpkSfFQ9x32eSGl0ndW62pdumBt
 n5cffzkjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImIv2X4p3qnbDP/ubu7pL6y
 n/zaxdfx7Llzz4/KFw8nsVl3n9ynYs7wV9b9vP/cte8eZhW6Fns0bNgW98dW3zP+DKuS3oTs7uQ
 YDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: xu3wh9fb9tfy9f9tjynmgcabeziq3yun
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4192F20004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827196-537351
X-HE-Meta: U2FsdGVkX1/RT8a1c919X2noYRT0eEDyOSbQDpPypEQZsKghHgPdCKLzpcsiTLy+10fLDqfnKQ4+RTXR4jxiOlNAgCPF6gAYgppV+N+Xd84s+DCZol7cAi3B2bhqmLziO5ND87CdvzPwlpNG5v6NqgAG9vtT5Ixx84SuVo6lvfnObT0p5e2DDLvMml3f5NUEuXKxP9A7Ie7TRVDkSz5x8Lkv4/sZecUjHsUUTTKaASxztp4GD8zlKl7GUT2vC8prQdjef1x+1ft8chOxo1P4n55hSLc/LPhMWBVCDhSuyjJxIaHpxH8B/6EpX0zDVcoHyYwfWKnfIKm5wVMQW0ULq9AUrHFZnPV/cDha7gf41oyq+QdX2vZmsX92gD3i1Mavum9NVJhqJ2JFQ+nWy5eZJ8BEl1UTpT1u4pkzN2ph8ezM8fDI1o9SgZIf9s1YdOREqzQnMQj8Vrr25jfZYTFqOkXmPVMqBhnEfzyByRUBCX5vkhWVZpTflWBl/LGh8JSkJeRGd29n/yZEL2+8ufSPU+XxzlOeqcCva2KYsIXhH1xyvfqqrC9lky7eAGhhrAyhaueootJpANv7bJX2b21f9cysbS/jv6Nwwq4q3fngqqqyIyBgadyHBtnb19i9wSYZUBT9B4MmxFkBE56EQlTTxuQKdCVo9RbaYETzdqokxEvjjxUsoF4Ywh3NKirSr0/akMkIC/vjJ1KZoYbO0UxVEoIlhilu2CnbZnVdeEL1+dCXpMu9HBgD3vtFaxB/jBhJ98oCF0fABTCCdLfmvnZ6RXb93JFMs1BEQX6Yo+A53O97OM43aJWScw8aUKr42RQmcxb9rcK72roQ9d3TjEq2TnD7uTOPBD4YPtWJSN7R0hJlsyZb9kG0eeojAEnnx/KHYlWgbJWBOHBmo3M1Tmr0bLgpvA64/LuUrVNgEJb1cHi6bpOepSyLhiT0Gezv0eIypI3nOrZjIXMtqaP5EAM
 uBELSLTt
 gYrFBxBvz4kk3wcC8YfgVVMsQ330RFoQN5ANKt2c79oNK35Cjx/5EcYjyvFA4wW0SHDT9zkEzk/fz5w13PIJf989A9J0aZlo9aOpC8k9RBVYnFPtB40QXp9K3lxoxlU9QEWHV0B9Od9tZlgOizQdE3g3SWnA+cP8aObmqtx8SFlPrmN9mZd7aUNRkDy1dtgv35vqcWWmSub6rCsVkqwQWdkedp3uGI6gc2uOiGV7B1DtVZ50sFlMYwDAt8hZRAkmD+Ly1KkcZcCrJ8YI0hngQFE03BTcGPLeSe7WbZcPHkfiLPbZFeJy/HzrdGDUAiXU28jdp/fdlyAeLQcBJr6rIm0Kxa1FWZNSbOfOM
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

Pseudo filesystems also never hold executables and most of them don't
hold device nodes either. But currently each of them decides on its own
whether to raise SB_I_NOEXEC and SB_I_NODEV. Some do, most don't. Add
fc_init_pseudo() as the common initialization point for all pseudo
filesystems that raises all three flags and switch init_pseudo() over
to it. The few pseudo filesystems that do hold device nodes clear
SB_I_NODEV again when they fill in their superblock. The following
patches convert the mountable pseudo filesystems.

Nothing checks SB_I_PSEUDO yet so no functional changes.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/libfs.c                     |  2 +-
 include/linux/fs/super_types.h |  1 +
 include/linux/pseudo_fs.h      | 12 ++++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

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
index a651e60d94107..e8fb99600d564 100644
--- a/include/linux/pseudo_fs.h
+++ b/include/linux/pseudo_fs.h
@@ -2,6 +2,7 @@
 #define __LINUX_PSEUDO_FS__
 
 #include <linux/fs_context.h>
+#include <linux/fs/super_types.h>
 
 struct pseudo_fs_context {
 	const struct super_operations *ops;
@@ -15,4 +16,15 @@ struct pseudo_fs_context {
 struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
 				      unsigned long magic);
 
+/*
+ * Common initialization for all pseudo filesystems, mountable or not. Their
+ * regular files are kernel interfaces. They don't store data and pseudo
+ * filesystems never hold executables. The few that hold device nodes clear
+ * SB_I_NODEV again when they fill in their superblock.
+ */
+static inline void fc_init_pseudo(struct fs_context *fc)
+{
+	fc->s_iflags |= SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
+}
+
 #endif

-- 
2.53.0


