Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA830606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FlJul7Vs
Received: by kanga.kvack.org (Postfix)
	id 90A166B05C8; Thu, 29 Oct 2026 12:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2A06B05C9; Thu, 29 Oct 2026 12:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F76D6B05CA; Thu, 29 Oct 2026 12:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 588AE6B05C8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:08:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 019B91A0496
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:06 +0000 (UTC)
X-FDA: 85376145414.13.1C9ACEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 29347100010
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FlJul7Vs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ld8tK5M3ket5fFNNR85Z6vJpytIJnb6SUdsH7qSK2pc=;
	b=7jBwHy6HzbhHoZxUBIQDOakjTfX9FZzaVxA8uZ3e/sStczr4+bY5/Ir+xeNM2KZ1h3N1Wl
	WDCjaL5s2fHQZaneipvgtW7qaK4u7EB9v1Csc7qOiM+hsY/WUgqp9p00Tpcgztq19ERkNo
	0HFnmHYvktTAqKoHQBmOxBG0Zynr7t0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FlJul7Vs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290085;
	b=RzptMIUXLzv/VvEF751acfzvKzgDHgiv6NhNxTxAWHbYivyCrD0tMjMX46gP+b3VAxH+qS
	GkXnHiuMqOl30fvhBvvZwRuBQwdJVpiZ5Zb6jPeRaYrnr39qpzYyodKQF0dqJ527awHRHK
	xkv7E8fAJ7jx3rvtQTesmuE/pG1j+Ao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8264F41A96;
	Thu, 29 Oct 2026 16:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BEC1F01826;
	Thu, 29 Oct 2026 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290084;
	bh=Ld8tK5M3ket5fFNNR85Z6vJpytIJnb6SUdsH7qSK2pc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FlJul7Vsdpn3n5A2HEqFsf/yVzUNEuowhdfB/IkGNzGZzl9akfrpY/E1BY9MANWoC
	 6NTg+QQB7hEf317fcdHpECmonUmtIf/Kk/6tbiSridFhxUmx+ykizzqv843eY8TuCy
	 sfA/OHVqFal6LvPuk/flXur/QzCN8rAW7qyT/m5ruF2p1Rgaw/x4C0ADkhauzDccDS
	 UaSS9p8/N2zr27gWAz9/BurwyH6xuA9eyamYTNN+giQXuZWHs7A7p86RQYUsJY9kGG
	 wAgrrs6byWUpu73Yiqf659jW89OaTl9O2n3fdlLAc6Q+dSDPCHkD7ZRWlQwVoRUuhu
	 G59QTXC4RR7gQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:01 +0100
Subject: [PATCH v2 10/34] exfat: use the generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-10-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3494; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+iq+q4dT/MCyRISfgOR900E8oovb/RAJIKa4lXXMNr4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zteXPaXoqaoVKrP4YPZcRucr4T3c76ftE0485Kb+z
 fBoifKkjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlc3Mnwv5rhTJ3850P/t7a+
 Lnq0NK15yae5L6PLle12WXsHpjzXYWRkaAmuLxDMuysxn7XGalb80QfX38+02/h9zzLVMr/E1Sz
 GLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 29347100010
X-Stat-Signature: ch67zoe4z6uwuutua7ks597pje1418jg
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793290085-307130
X-HE-Meta: U2FsdGVkX1/K9KM8+hLsLfEsXeYDW7mYm+RSULK3HcRPTxXkZ6tf4WTf8IeSG0/Iq5dhSJvuQ03LF0WNbmT82zaa9ZB2lvj6N0g694WscZP+I9r3ogoHNLjurKrhfBs3xOUXMlyO1wf4MJlXpEci3Rpeyp67PITlxJubYmpub8GWk9By79x87yl+wdnDA+DJd8EgQ8JsuPxtj7OZXkwdZJxXjpxBc02wGrqhMS8ToA3JpFPSIvVLQqD/zs640OcknWIqMnTP//UyG592vrLlDmFqpMOHKjepJeretUp5Nen1vgp9cEu/zdqZfKf5eP8viEW4dYNcVkH4Ze5XqEoE53vX9M4gZN5V7Y7wpi+se/KHq5x4ch2fBl07HWXEkSuT+jcB/p8w/JY6nCC954mD8uvb/1IufpoGM+IfDKg/TMVoiNkYX8B6LYIVPkOLVOxaT2B1TGSHDcHopnCbuWTjhjjNYW6w1j7o9dR/MVrgbfdmWydJBpdtSh52ukME8taO1twsWL8MyhSfLrP1aazmnMFG3ymqbxy2yKK7591gPN/hvEBZZjxL/ljVXxfEgHOkya0LBJcQhlm/pqiIQUhjtf3aeiWgJ7swF2jnvBLEcK941kNPpechc/v72V4u+eNbGsIiWxRy09+AzjzU828xcA+O/LgIk2yZIMzHNBchhi/HA00SE6qI1s7sGIu1qNKrv6ftT8lGQrGgZcGGdaLyglPkyCd4WbDa5u4BeCi5qiCf+zjX946juGBdX5UWHzoXTUUZLg/YzEoU/bvb5o0VhDVZoHG/d4Piw1yAEvj0hVh3cIssclQefJv2uqxhS3uShG7DIvBddkVRJljPsAwtLN4IJ2D/BDVqjaxHD5i5D6uYGvWM1OvNleWTOGyJ+c3PFRVKs2OWPkuk9wSTx0yILczxtAI1bZb73lpN5M4JNQanMnfr4KCjG3+0RK3ZN8dWn5krlNcSN4C92F/yHAj
 lwRmsLMw
 zaTrStNeRz2r7w0fSCIeQXqe3wTEGAcB6poMHNQKslzBxJXRM3MotYkhY+AX1+g5noKFK46PNXaB0bPmXWZAsfZv2vjG8YsWorsR4C0uTmlpOM4lHYCfBAy8q8ezvNI04xBNGRYBo4eCigNfbVdx6lQlMQYVF9Hv1kVYiVJswpUkfTcNR1oYUr6kCES1BwVUUIUBzdWkhkVzbfgsTHD0vCWhXM4v3CgUngyD/BcCd+5Heft4tSzoR7pJAPZRXDg/hLVzBXewDg2MFZQJmOG7Vr9ls/tGOWpjVNdgY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Set SB_STATE_EMERGENCY_RO instead of a private bit when an error makes
the filesystem read-only. exfat_emergency_state() keeps telling a
shutdown (EIO) and the emergency state (EROFS) apart so none of its
callers change. The VFS refuses the remount to read-write now so exfat
doesn't have to, and /proc/mounts shows the filesystem read-only again.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/exfat_fs.h | 13 ++-----------
 fs/exfat/misc.c     |  6 ++----
 fs/exfat/super.c    |  7 +------
 3 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index c0e712d9083a..ac138f111988 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -123,7 +123,6 @@ enum {
 
 /* Superblock flags */
 #define EXFAT_FLAGS_SHUTDOWN	1
-#define EXFAT_FLAGS_EMERGENCY_RO	2	/* read-only after an error */
 
 struct exfat_dentry_namebuf {
 	char *lfn;
@@ -376,20 +375,12 @@ static inline int exfat_forced_shutdown(struct super_block *sb)
 	return test_bit(EXFAT_FLAGS_SHUTDOWN, &EXFAT_SB(sb)->s_exfat_flags);
 }
 
-static inline int exfat_emergency_ro(struct super_block *sb)
-{
-	return test_bit(EXFAT_FLAGS_EMERGENCY_RO, &EXFAT_SB(sb)->s_exfat_flags);
-}
-
-/*
- * Modifications are refused after a forced shutdown (-EIO) and after an error
- * with errors=remount-ro (-EROFS).
- */
+/* -EIO after a forced shutdown, -EROFS after an error with errors=remount-ro */
 static inline int exfat_emergency_state(struct super_block *sb)
 {
 	if (unlikely(exfat_forced_shutdown(sb)))
 		return -EIO;
-	if (unlikely(exfat_emergency_ro(sb)))
+	if (unlikely(sb_emergency_ro(sb)))
 		return -EROFS;
 	return 0;
 }
diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
index 56dcb93ce69e..03c5c2b9a65e 100644
--- a/fs/exfat/misc.c
+++ b/fs/exfat/misc.c
@@ -25,8 +25,7 @@
  */
 void __exfat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 {
-	struct exfat_sb_info *sbi = EXFAT_SB(sb);
-	struct exfat_mount_options *opts = &sbi->options;
+	struct exfat_mount_options *opts = &EXFAT_SB(sb)->options;
 	va_list args;
 	struct va_format vaf;
 
@@ -49,8 +48,7 @@ void __exfat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		 */
 		if (!(sb->s_flags & SB_BORN))
 			sb->s_flags |= SB_RDONLY;
-		else if (test_and_set_bit(EXFAT_FLAGS_EMERGENCY_RO,
-					  &sbi->s_exfat_flags))
+		else if (!sb_set_emergency_ro(sb))
 			return;
 		exfat_err(sb, "Filesystem has been set read-only");
 	}
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index feeda41a8074..67b34cfce247 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -100,7 +100,7 @@ static int exfat_set_vol_flags(struct super_block *sb, unsigned short new_flags)
 	 * if this volume has been mounted with read-only,
 	 * or an error left it read-only (it stays dirty then)
 	 */
-	if (sb_rdonly(sb) || exfat_emergency_ro(sb))
+	if (sb_rdonly(sb) || sb_emergency_ro(sb))
 		return 0;
 
 	p_boot->vol_flags = cpu_to_le16(new_flags);
@@ -789,11 +789,6 @@ static int exfat_reconfigure(struct fs_context *fc)
 
 	fc->sb_flags |= SB_NODIRATIME;
 
-	/* After an error the filesystem stays read-only until unmount. */
-	if ((fc->sb_flags_mask & SB_RDONLY) && !(fc->sb_flags & SB_RDONLY) &&
-	    sb_rdonly(sb) && exfat_emergency_ro(sb))
-		return -EROFS;
-
 	sync_filesystem(sb);
 
 	if ((fc->sb_flags & (SB_FORCE | SB_RDONLY)) == SB_RDONLY &&

-- 
2.53.0


