Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A6A606AE99
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kF4AFKYZ
Received: by kanga.kvack.org (Postfix)
	id EAC5A6B06DD; Fri, 13 Nov 2026 07:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E833B6B06DF; Fri, 13 Nov 2026 07:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D735D6B06E0; Fri, 13 Nov 2026 07:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B54606B06DD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B41F16029E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:05 +0000 (UTC)
X-FDA: 85429954890.09.B779E32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7F78520007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kF4AFKYZ;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyeMtFRiFUm1GgKqiaueiDO/IS6fCBvaYPtU/LMu/xo=;
	b=Es90pKAKyiw0h2+aC+K76tQ2bYeTt1JX2bs71w9YjPzckOIfLl85I1KhSlB+wm0yd9ofSL
	NJtOm3j+/x5dgsHy1ex3vB+tTaAjEGvikzAVExysOz67uZrCGuvTBWtzfOC/+lXZ3Szwm7
	H9/Cyfz9CSn8EsZXQrttAmyFx8NePJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571263;
	b=s0/MxcTbNrZuObU96KiZOPuUO2EdeQymsbxwgkvgvvrM0oZ2PoCnxddWh3IeBapSYKbHMM
	HbNWlWZ5pXgU6yZUdhNVsZu6xwHCSR3UrJ2TTTKOdcjPQ4CwakSS4Ww1/mo94BA4vmptEG
	Yq5E1yp5jBqrWssZPnumA6N2tAA7rAo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kF4AFKYZ;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE43C432FC;
	Fri, 13 Nov 2026 12:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E831F000C9;
	Fri, 13 Nov 2026 12:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571262;
	bh=yyeMtFRiFUm1GgKqiaueiDO/IS6fCBvaYPtU/LMu/xo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kF4AFKYZ6LTt4D1pyInaN9B6u0OE4jPZDqqgqRlu5SSxnCxqtEaOUJ+9FGVs79LN5
	 LWwJvImEvXw1/hVRnIhQVs1XAl5oyAi3sjHQ7m8vSgf4vYHiAE49qa+Nbo40Uj0vJE
	 c78CtHjAIAiUZeQG+LB5Ults4fwbM5XtpnTiSDELaN3V3HHjcJk82wrBi3krguYfik
	 z4bJ7/0CyTVnxO8T12tpwrsl5fKdKGqCSpLZW5fFVOUPeGb8NokGmStMRW9vLj/Rm9
	 8NKMUYABnEbHP8iXKEEYMPGAgFZTpyLPomrT9t3P93S0KMDFLQGtBq91Z0lJWC7HzM
	 W/YQ2P1zAnNjA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:08 +0100
Subject: [PATCH v3 12/33] exfat: use the generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-12-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4142; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ZSlUpRfgik1TuXvBBVvkw3QqcpPSPBH3FavShZHmWoU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71iovftKZ2+13Pn17z7+Zx1wqsG5o2hLvcmBz1cE
 LI1qXm3Q0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEIpwYGS5VN1rdk4s1mHHD
 MPH6rux/+n18sxXNQg3KDSfbV2k98mX4724wyXxD8okWRkeenetC72+76+Ps+jDH+si3g273dZh
 vMAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: difadys16w1zicfxzop3nwduw48bhwq3
X-Rspamd-Queue-Id: 7F78520007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571263-236786
X-HE-Meta: U2FsdGVkX18zEEjs5AzHZj5WkiOc+imKeARA5kkLkfHsc6GcFR9AW6+5/VD7fxs1Wa2VCB63Pal4sdtvo5z6M4X8FC+jlZ3pHQUbAT6QN7rEek2065/Q0jlqidssdFKoprl1N90NkfclccwWCNtjjg6v3/XDnh6F5HgsiL4oNuKzJdF4+uSgHMtRcTqkjWC0ekDeU8H+DV9wZROiOvyeqvzh5+waPioKHs5COqkK0BdtO6RHvMauDOpbT23xomG173A7WcJIXFTFtabWGHdK90+b2RmEYVr1d+lB696CHS64AsP6klcT1LdWJzFiGHwtNfxfLhgxm7H7JJzWkRD1KvKolEaklSkcTKiv4s2laVV9hpr30KEGm0ICLT1N7edYSqj54Ilr5dYJ2Q0d2tatFlBOXZ0MPpC8zkyV4MhZAtbamsv0P8MJLP+kaq6KVZulWnNseU7hHTefhRFNmMURzvBsbMvhcMzszLj0KPs1Rnw1363H/SBAS2f54o4SJyZ8u4pif3jrRkegXTsXL1NGKlKjBf1LvPC1V+r6Gae61H+2jEAfm9GH0XGTeDWi3PFRwbLncJ4lkvL8LOhaty0g3RgZRwGw1WV13ftwIDj2rD01jgUa/UlINQLeI0+TFl4/4D4dsJiUDHhlbuE68LS9E6OllYnU2sjKGwI+oRKeDRIPDFEgSluKCGipCowh87ow+q8fcVEWYNy1vaMkXEM41vH8TKCjxY/SAedEGCT4upjE/gN8jtV2fw4ijEeeo3XwjLN0mU+6w2wZPyF2xYl7HhRVwBE0uhGvXaVrePBPZDMXJaOSvUIFDXjtp20UtrMejYsIP4etgOSwToTvSB/Ps/6O0rNf3c05Pgq2hbjhwlf93yxP15hkkdBLQvnxYNs8uUHohMih6rrrEvziiV1o29q+qYC7nPx6G/TzVGhQcxq6ZTF8ABQSTwMHvDTO1jaLA3Dn71JQb9kUF9mJtlK
 7h6X0gGd
 y4HRBZ54HcjlnMAM3PcwrmbW+0/37ngOWkmB8FFtelGeCJQqWlovMgU5SU5FspvlbifOLAVL+2AEz+olU8KqYDKOTSbrW+6u1R5/5kuxgUgkHZsKYKuNMgHCeqd2Qg+uvTpHwRkk8ON6o3r4mqF2kOlbXWZcHS+oANQo/FF4scDa4rX0Xu/4qPY58WGeamTUR4/P8WdfOuyu+g2hG6uLtjiychkFkbxvdDkGLxHB/FxGLXeWXtHN9vEuRYtGLQrNgeGauax2JinlQIxeAkFLFeyg02bw98kvETYCu
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

The VFS also refuses to freeze the superblock in that state. So
FS_IOC_SHUTDOWN with EXFAT_GOING_DOWN_DEFAULT or _FULLSYNC shuts down
without the freeze after an error, there's nothing left to sync anyway.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/exfat_fs.h | 13 ++-----------
 fs/exfat/misc.c     |  6 ++----
 fs/exfat/super.c    | 12 ++++++------
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index c0e712d9083a0..ac138f1119886 100644
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
index 56dcb93ce69e0..03c5c2b9a65ec 100644
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
index feeda41a80741..e3587ed270245 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -100,7 +100,7 @@ static int exfat_set_vol_flags(struct super_block *sb, unsigned short new_flags)
 	 * if this volume has been mounted with read-only,
 	 * or an error left it read-only (it stays dirty then)
 	 */
-	if (sb_rdonly(sb) || exfat_emergency_ro(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	p_boot->vol_flags = cpu_to_le16(new_flags);
@@ -176,6 +176,11 @@ int exfat_force_shutdown(struct super_block *sb, u32 flags)
 	if (exfat_forced_shutdown(sb))
 		return 0;
 
+	/* After an error there is nothing to sync and freezing fails. */
+	if ((flags == EXFAT_GOING_DOWN_DEFAULT ||
+	     flags == EXFAT_GOING_DOWN_FULLSYNC) && sb_emergency_ro(sb))
+		flags = EXFAT_GOING_DOWN_NOSYNC;
+
 	switch (flags) {
 	case EXFAT_GOING_DOWN_DEFAULT:
 	case EXFAT_GOING_DOWN_FULLSYNC:
@@ -789,11 +794,6 @@ static int exfat_reconfigure(struct fs_context *fc)
 
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


