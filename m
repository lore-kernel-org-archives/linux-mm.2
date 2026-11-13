Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96D3606A898
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZJfhb5IL
Received: by kanga.kvack.org (Postfix)
	id A8E646B06ED; Fri, 13 Nov 2026 07:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F5F6B06EF; Fri, 13 Nov 2026 07:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F146B06F0; Fri, 13 Nov 2026 07:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D23F6B06ED
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 024331A0189
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:39 +0000 (UTC)
X-FDA: 85429956360.27.378EDF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F7421C0012
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJfhb5IL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2Mek4ReTKOWqsv1h8QyMHMt7wP/aUz43Y3WUWGVO7k=;
	b=jYaQnTX9aqQosIM/C1ECPV+alRoztpmi+nAMLWp1I+cqAXNYTwIF1qEQlLLga2H/Sh85rC
	T0tVbEbuEZCcAiNaTw73o1kQRM580Y0k29ZZPyIR40ETiMyt4gK1458HZpwW4yj/mNdf1s
	OpbFuSMetBr5W1jaLyhGF/aBdt5DJ/c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJfhb5IL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571298;
	b=48fyRfx0eHzZ5o4XOHF8gqpgbR262ii9LoA53HNoKPhQoWZPJ0PjjU5ZSasarHFiOr6uSW
	Bl+s2BuljSDdUnIBPVQIPqxGlyfKGb05wakPGRju4PzkfV061sc8YV+Gei+WPCqSpurLMQ
	DCCQNVvJxFyX4F+SCRKHJ2IUhPVqkXA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 702CB43405;
	Fri, 13 Nov 2026 12:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7403E1F000C5;
	Fri, 13 Nov 2026 12:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571297;
	bh=A2Mek4ReTKOWqsv1h8QyMHMt7wP/aUz43Y3WUWGVO7k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZJfhb5ILCT5Ww7IzbAHXIEwx4QQEzEajk5W9+X/w+QICV0GrPzMrCmUeqvjm8RncE
	 t2LXoOfkyMgznf3QQC0LTw92cTzYpHI59hutKJvzDlUmMc/uAnohDPmronKnMZlhV6
	 XucWvVj5oBNQgGBewNMkF1AbuiynjfCQLWR1eWCkyt/gbgoS0APv2kHJYytn1+8ncI
	 skZbWnKF8h83KOdIu2pf+2f2SE9m/O6MGYQMSkgmnxaQ5HHwzQvR36irqGe4s0Dbwm
	 sPeffckKCCm33c51BC2QulHdT6cLH6hUhJRpLzQygCxjDi3tD2H2ZD3I37EdoB2MDa
	 guNYBXIh2oQ6Q==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:16 +0100
Subject: [PATCH v3 20/33] ntfs: use the generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-20-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Hyunchul Lee <hyc.lee@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3392; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rqltzwzmIzd1i0bsKbMRQ6pbej91F4Gd2d0Lwm7wM4w=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71xtdWe10ekrv0Wu79tut43lXtZJ/IMFkf93yNz2
 WNpMNP/ZR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQAT4TvEyLBIxL7lUqtigdi1
 TXNdpLm3WziKJ92cVH1oEuf8S9EGPMqMDOc/HBXbPG3mBM9jKjeUNkr9u/E4WqzcT0pB9Oyvm4m
 357MAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F7421C0012
X-Stat-Signature: 9636b1iiws3tj1x1kn4yfqeroapr3wdb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571297-338799
X-HE-Meta: U2FsdGVkX19Wh84D3u5aUnjxPULj0y3QarCoTRgleC6LN2M17StnK4IgEoU5jo3Fa2LtTX8Fk+3NvXto07GVFH7UdtkwZQ8ae0wz39QcwrGetNpfW3cXaqbN02Uhk/PB0E/HdTo5o0L/+4TL6mX69cU08eWYa3YUjOfUGwVT4ppoebI3JlcjG37ur92AHaAl/vkaXXr4763VDQwHS8uJioKgcE6g1xX3DU/CbO6hMks6lkdVeYHCY1lVaMDE1EUFNQ6Jm2WaBYIaToK+7b78w3+9yQldpzjIg6rv9vURkb7goonSgCmDUoyCgZY8U6bvaQiLwjjgxGu9A5ghvVEp+9DXvTd3658us23Ldq5TE5jBFLKQsJf5HT9PPaH9J24Ay1w7HaDNhKolbrurWIfe4QlzwlFZ0elw1keUmTxzmz7vFl0dpWeFF6GGj2HklCmb3ZUsFTepQiKo9NfaJi708MryfRRUXZyeJvy0pKo9d4ayb69oaREX0CYDvBCqIRslvpUx7IZ4v0y81vpCIU0FkVgwPrNeAPIZkdj5vivPI0HXdycEIFLM3UQHgC1fk+MrBx9HjtK+VjkROOWwmlfxkCgwPHcUMjrlaLOSOUN2a746Xkm9/YCklHKaNFdx/lqN9quSu2br/2bPimZncP0zrnBTq5w4M3Z0XtfkM+PCRQGLbdoNbQSeFCi2fh3b/sBP3+B1Pqp7O290Vsr0UIjpYGdMX5oyVuaNlmJ/186rlND/dU8LBuIKPjRPczo6MeMeomFfepTpqJfkDw7Ya0pPzTcuKM2hkbmsFtofCO9FSN5CXgktozyB7/nXQ2BzqK9y8J1jE9oyRKXcDy8AM8I661CnLgUl0MFxVAOkf2P3Cw4ZuxoCBoxOz+LsX2kCEY4BOqnVvR2FoU20xoUB6I2VuAvzqA7IJx4hlGa/iBbgT7PJISdmbB7/d7+tJiRrEbLs7ziUoDwnrFt+tmMu5mj
 3tFi5Obz
 Zc30PXMFrwLKRU+5uGajtykS4DEoyAfBhW0D3oOjfV2pg+TNVv7pqAhr+IEq7VxpEoHWhTy9iXxRwK4gTA14n6cWSEpX1yyvATw7XPI0BQFv6d/BzbofSVBKeWmpAhz9gEkl7pkgnN7viIxSHIImsanwe9eENQdl5yLli65XmYAzaSRD1wjbqxIoq6Y1vprsTFSXdrEe5fE3cMv24tWc7Jlpjd7QQD6y574xnlFAsj+JnNmCU67ABM35jbYSo7s8xbg37n1/RgNMzX5sygNzEhEDKC1DJ+paydC4gmLzlCeN/QuGl5VLl0OR6O+k7b9IW+PQgn2cxT5QYrhr4poAhEynE/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
an error makes the volume read-only. ntfs_emergency_state() keeps
telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
its callers stay as they are. /proc/mounts shows the volume read-only
again.

The VFS also refuses to freeze the superblock in that state. So
FS_IOC_SHUTDOWN with FS_SHUTDOWN_FLAGS_DEFAULT or _LOGFLUSH shuts down
without the freeze after an error, there's nothing left to flush
anyway.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs/super.c  | 14 +++++++++-----
 fs/ntfs/volume.h |  7 ++-----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 91290688d2898..660fd145731fd 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -441,13 +441,12 @@ void ntfs_handle_error(struct super_block *sb)
 			sb->s_flags |= SB_RDONLY;
 		} else {
 			/*
-			 * NV_EmergencyRO makes the volume refuse modifications
-			 * instead and NV_Errors keeps it from being remounted
-			 * read-write. The error work marks the volume dirty on
-			 * disk.
+			 * SB_RDONLY needs s_umount, see sb_set_emergency_ro().
+			 * NV_Errors keeps the volume from being remounted
+			 * read-write and the error work marks it dirty.
 			 */
 			NVolSetErrors(vol);
-			if (test_and_set_bit(NV_EmergencyRO, &vol->flags))
+			if (!sb_set_emergency_ro(sb))
 				return;
 			queue_work(ntfs_wq, &vol->error_work);
 		}
@@ -2272,6 +2271,11 @@ int ntfs_force_shutdown(struct super_block *sb, u32 flags)
 	if (NVolShutdown(vol))
 		return 0;
 
+	/* After an error there is nothing to flush and freezing fails. */
+	if ((flags == FS_SHUTDOWN_FLAGS_DEFAULT ||
+	     flags == FS_SHUTDOWN_FLAGS_LOGFLUSH) && sb_emergency_ro(sb))
+		flags = FS_SHUTDOWN_FLAGS_NOLOGFLUSH;
+
 	switch (flags) {
 	case FS_SHUTDOWN_FLAGS_DEFAULT:
 	case FS_SHUTDOWN_FLAGS_LOGFLUSH:
diff --git a/fs/ntfs/volume.h b/fs/ntfs/volume.h
index 1ce81b260b15c..911a27983e138 100644
--- a/fs/ntfs/volume.h
+++ b/fs/ntfs/volume.h
@@ -16,6 +16,7 @@
 #include <linux/uidgid.h>
 #include <linux/workqueue.h>
 #include <linux/errseq.h>
+#include <linux/fs.h>
 
 #include "layout.h"
 
@@ -200,8 +201,6 @@ struct ntfs_volume {
  * NV_NativeSymlinkRel		Translate absolute Windows reparse targets (native_symlink=rel).
  * NV_MftBootstrap		Mount is still assembling $MFT's own runlist.
  * NV_StreamsWindows		Interpret the final path component as file:stream.
- * NV_EmergencyRO		An error made the volume read-only until it is
- *				unmounted (errors=remount-ro).
  */
 enum {
 	NV_Errors,
@@ -224,7 +223,6 @@ enum {
 	NV_SymlinkNative,
 	NV_MftBootstrap,
 	NV_StreamsWindows,
-	NV_EmergencyRO,
 };
 
 /*
@@ -266,14 +264,13 @@ DEFINE_NVOL_BIT_OPS(NativeSymlinkRel)
 DEFINE_NVOL_BIT_OPS(SymlinkNative)
 DEFINE_NVOL_BIT_OPS(MftBootstrap)
 DEFINE_NVOL_BIT_OPS(StreamsWindows)
-DEFINE_NVOL_BIT_OPS(EmergencyRO)
 
 /* -EIO after a shutdown, -EROFS after an error with errors=remount-ro */
 static inline int ntfs_emergency_state(struct ntfs_volume *vol)
 {
 	if (unlikely(NVolShutdown(vol)))
 		return -EIO;
-	if (unlikely(NVolEmergencyRO(vol)))
+	if (unlikely(sb_emergency_ro(vol->sb)))
 		return -EROFS;
 	return 0;
 }

-- 
2.53.0


