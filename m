Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C3E606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAFwik9V
Received: by kanga.kvack.org (Postfix)
	id B7BCE6B05E3; Thu, 29 Oct 2026 12:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CF26B05E5; Thu, 29 Oct 2026 12:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AD86B05E6; Thu, 29 Oct 2026 12:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73F8C6B05E3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:08:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F316E16047C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:40 +0000 (UTC)
X-FDA: 85376146800.29.28662FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2A4B8180002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAFwik9V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XvTTpFZt9IMT9USt02re6nPlZ9qEzjzsuBpluPCOxY=;
	b=jocsp6eI91b1rjVjZNM9ZImH0YRgsnRCAeisj/VWaoZ4mYUJEkj9pcQXP+euM0S+vEd1Oj
	O1tDY6oYLItG8UXWQkh0LOz9eqU+5JZoWe6/YffxkrC3YPQQtRtVuXdmtk7wI8Yhfgw0FQ
	tsdVekDZSnqkAc72fZd/k0oTJdoJuZs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAFwik9V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290119;
	b=LJQvHAFQ1CX0v8HSZ9SAEBDVZvJfw9iPiz+v586dqnWIdw0T26RK29ks09cPbBvuBhP/e/
	48tfoziQ5mIwfao+y+EosuUKK1aKq+yzDHhqv9g5GYTtDxbkTSXfYtA90KUGcu3u0ZrBUC
	6iKsek7xKtrbtM71WrQ+oK+fA0V/5Bo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD5DF60627;
	Thu, 29 Oct 2026 16:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB041F01826;
	Thu, 29 Oct 2026 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290118;
	bh=7XvTTpFZt9IMT9USt02re6nPlZ9qEzjzsuBpluPCOxY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aAFwik9VuZcv9cOuQB4WvplLb4N45Sj4rB+A1RcNnCrrDjONPmoHeIedf2y9yT9VG
	 qtkLBpQkdIZiHj769OXRC+QI8Zo321gIRuC49FWxR/zIhXP3DiU4x2g+eEK146bVch
	 La8YEglPN3VDHQig6NnKb6xlma2X5owpJHCuHT6s8O5XUySyuU/QCfQ6YGuVcznmS3
	 xhfHjA2RQnC+IvfZVwg5elkUrToD05Fn6mKCt0hLQYpSkhNDuDkuRMGMIMgvBLfiNk
	 fiPH6BCXg3Xi99c30lR4xSqy5U+L14ODlDD8U8w2sujvCBBs07HjXY7vTGhQgBnDAN
	 jN0amNk4ORZKg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:09 +0100
Subject: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2864; i=brauner@kernel.org;
 h=from:subject:message-id; bh=g4LPA35YUVZ1l1HsNIGt3EKaYIEnRcvZG0SSYdvGjoM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztdni+Vr7ZvmNvdw4acNl8V2Mom6yQr5OerFf9skx
 xAeEaLSUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBElHkaGp9bdU5b9f5/NZpkT
 I2foGrOWY1aqnJfxVtYFfUzZ0d++MTKc9rHcp3Vmh5gE58zm86fezptUI1Vr80H56/nznibOmca
 8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 2A4B8180002
X-Stat-Signature: 1prasdyhori7ksq5zk69b1bhtngof8yb
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793290119-108905
X-HE-Meta: U2FsdGVkX1+ngS6Q2YYSgqHFHr0n84QtHBIyAe6d3dlR/JlhCkMhAOphmOaeXoOhbL8yfB7+14bIar3Eg9H+T9cq0gt4+f7WErwpwS/goFENvMu21M3tc5/Aq2cWT7rlxQd6EVsEVPrAYekrVX7AmyU6Xu8wj7UyV9EXabmaFyJeWPgcOEKD334C+6V5mQLPqBaE/u9xVu3gXTNhQulZ7/1uAEpRNHC2i+0may4kAcR0tBJZ2hmaeuUznoAc3NYAMJ5WQVSksk4cJLfokrU3QQLawln2MaHK2eXf9nvuLQHE723CeA+PaJMFThicjBkp0CexnpQgvrd+Wopo1oywz37CmMv/octFIWC5ma4GfrSz5SGG6cDSq8Qg73Y0SizmUDvrY4Bwa33vcrizlqEg26sqSUYLHCHovKjXAvrQjZdOMXjNiGXoF7U8FB3JfMAwdWq/6RlXrrdkBh0U8j7KMc8IbHZ++LE2fFoy9QAuMDItRRYS2DCGJf4CCAEMPPwDm0KzzZjgD51abumydM31y1aXtMxMUS/N6pjkm6IISWbyE4mAeu9KHk/2KdpdfsIzzUM2Xk8+5nHciIo6rpv1QATqC0sdJnilg2KgOice/iYIwH93lkAu7BkPamo+vK1ZMS/SXsW3564+ZI8HeDyfoC4s2T8QWlBe4erPY9aVnTH3XYF8DoXsyUBPLKtTQY1ugnSrSstDJqU0pS8mXEeySJ09m/sZ2Lv2GPzZR3BRFXoIArlp8e866ea9tCX8XYne42hRh1AF99zUNILG0prVTvg70+wpVq3/b5ZujmPQuqdg8bczX7vSiBbg4MDi6yMAiPflVQqag4DDUZ4MDqxv6v4R4+T+QrloN9CsAxyO5NeiAOB+w6W3EPfaOU0KLkdoUWTwXGAs4s7Me16siGFqQY+Os8ngPB2h3YjuqYazKYTF0Qz6rfD5Fkulx8iZzGneC9iDxXBiuN/vahVIGJq
 6AOj5Fat
 O4RZ94PU8HkyHWXNubxpHojrKLMCs25aOcoPhQ+k4+z077JqRpKPtYVoUGrknqHj9BMduvH5KkAu+VWDO0ZgvE4b/YWJM9hqbx8uo666QftdiB6GK/IgW1glweLX5OStRQVFgMAdtryLKCajcoM+mrczLOoTh0c6a839Ao8E+L7VW558zDYS6uzpHkJTmsKiNEJTRmPklPeXA853gltEBM8WKAacu6fUakEEStNgsbmC5B66jBBwk+2pTeZLQd3TJy6vh2WIgmVEzoPJJ6IwHl4Fpz9nr4R3IfqusYV4kgA2U20WW4xTJ2ZPKQbtom/rLtFgw
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs/super.c  | 12 ++++--------
 fs/ntfs/volume.h |  7 ++-----
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 7e3a291f4758..7bc79b776639 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -441,16 +441,12 @@ void ntfs_handle_error(struct super_block *sb)
 			sb->s_flags |= SB_RDONLY;
 		} else {
 			/*
-			 * Don't set SB_RDONLY: that needs sb->s_umount and a
-			 * proper remount, and setting it while the volume is
-			 * frozen makes thaw_super() leave the s_writers rwsems
-			 * locked. NV_EmergencyRO makes the volume refuse
-			 * modifications instead and NV_Errors keeps it from
-			 * being remounted read-write. The error work marks
-			 * the volume dirty on disk.
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
diff --git a/fs/ntfs/volume.h b/fs/ntfs/volume.h
index 1ce81b260b15..911a27983e13 100644
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


