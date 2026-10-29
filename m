Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAB2606A9F0
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nMjZ/AQE
Received: by kanga.kvack.org (Postfix)
	id 53D3F6B0601; Thu, 29 Oct 2026 12:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDCD6B0603; Thu, 29 Oct 2026 12:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A0B6B0604; Thu, 29 Oct 2026 12:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3CC6B0601
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A593F8042F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:44 +0000 (UTC)
X-FDA: 85376149488.01.D13C083
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D1E55140003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nMjZ/AQE";
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290182;
	b=cJ2mzplAfbKN581z0LSyAXmPNbUPFeMhUQwC6WpYbhCnL4eoydsCrzsJzXRT/seUiP8tbT
	19o9HI7yABQPsJq4F8uQcFZyyNJkKkXzRarFbIRMtJebA74xZpStjSwajdYPopnsG4LcG3
	HrtKBvkNBD5oS8/u5X//zqczFwYZd8Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nMjZ/AQE";
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uu2WZyDd3RZlZWsibqonNb2mhu+3OgxLhhAg+SnBEig=;
	b=VVHuAuqjmNUk6TM+R9W/WqaatquT9odglwLMh0oNBkHzB22pV1oFzI3id/I2PZn3GtZ/hg
	tGPnJPqmn58iSlj8tHxmckjkgzQiH2rwSp0bbSOaYgg4ST4T3i/SoAxf5h/shLEASx21gi
	iiQb866vuRcQjVMQcRr1WuS/OsT9sbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D25D4400C;
	Thu, 29 Oct 2026 16:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0168F1F01825;
	Thu, 29 Oct 2026 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290182;
	bh=uu2WZyDd3RZlZWsibqonNb2mhu+3OgxLhhAg+SnBEig=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nMjZ/AQEmAxledocQ9n+3ExKHoDEzHnf0mT+qoruM99B/d+FhxzlfdtRVlmt3+iCx
	 IwzpcFh7kugD3gwuTS9UxbnfonMQCdfrr7oKzA5E2T6EDI4rTB2cqtcAhGMSbw02M8
	 Ln8vA1wzgrdhCfq0EYl+yLzfRhyU+o6Q5p4s7vDMU87X5a0cSuKZK5rMcwWp/RsBiv
	 zOYeZQh+1uCd9Epg2VMVj8Uq3/P68Qlf9ffbS13vOiEfBVGe4T2BFmNIWQv6L26HUN
	 km/Kayv7uhrohDU0JU7L+XvpBIeVqCAiK+BrnCuylApb6wPnkl3/BQXRf/EMaxfyXp
	 VDORzaitoD+bQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:24 +0100
Subject: [PATCH v2 33/34] xfs: allow remounting read-only after a shutdown
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2140; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3Kb6qOKbZ504nrKdu5KYQnNbjYN4iHgbKmRWzuk322Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjdInCYZ5rLtdpyYVoEzQ3Vh8D/eS8sNopf0/lyTd
 cnA+ndKRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQuqzD8L479erR1WmD8TYYZ
 bb8fbl/56OjM+fXX/jcfVVvPeGrejXCGv/JtQZsquVR7XNepyVmqvg1ufriNmz+MdVKf2vWSC6s
 YOQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: dgfb6tbwdqinq1miu6t34zk7jrxczrmp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D1E55140003
X-Rspam-User: 
X-HE-Tag: 1793290182-55649
X-HE-Meta: U2FsdGVkX1+MoCds66kUbC8DQIioGO21T+BdCwvZnzooMtZi/IQhRGhkAdUmSSO11NB2AV+T0LmGseeQBSO5yzHebf90eeSZzkVisKYtfrbNeXZuJa64X4NC2wmggXX4NMnosrR2EN+cC8eIl5MOL54RD0HFla6XFcjA34aXyerPZ3axV5XsodhC9bqlQGawb1/uWmyIUVuXghheFjBUxhV+52IS72++V+8HlyDbkgmCWTWEwKeHMzvi382SY+9QYUgVs6XCKtKf1Z6IxMKew+nBYvFcFKn3UT5BchHLjw0RSl9Jx7Cydf+/yiBgXxGNL74pyzvJ38rKLgZwGnzWb7yBge2vlcZTAhxnTzCqNFFWfK3HQV9HGGkZh4ZuekHfPlqC5FiwnBx5B75F06o5hIFfjOCVzJS3n5peU00fOvL3G37GDwFhSPuEBunlORy/Vzzy13mN83NmtdHPbAKO2DeIdGiFRM5yqnbOxbZTsiYS9gUI/fMACjAhX8oGS8qohRu9NBxwU0M8VzZodlsRuY5LdrKo34QsC2efIbUGxR3lxW1kwWfXaM4f7zACCd1ftPgO6iqIB2f6MHrDDxiCCa03gs4AyV0JvzuqrNHSWTGZq585NkZRO3ywfUtMQ94wJimlCzlDdUv8C78goJgkfvUsfKy8lh19WkoZ2I9yw6b6XpFiI2UKcRf06gZSh2aNaiqyfXFkoGxy7XmaNiZmVNX5T9L0mDMMKUFknH9dLTG02XmnD6AiKfexDxTJZnVzj6HHm8XuxkTmmd39NTVxs9xnzY5dSO4x8ZJzju7vw32DNehQMHYk2wdacMvbsWL461AHVyVKhWQfR5ppzklddz7ke1Os1VaPf3WLNJuTu2GHQaC+meS1c0QZmFjrSnnXzCTvArMtwS5zGMGqmjfvD0rXMq2Om517zr1ZPCMemWozSkoYsjKGLlE2Npm1jnN+kUbesxp3kXckz2RCL7H
 U5yziLMM
 bHEMLPrFmmHffmR0Uj97ZsaAjZEhPGKiny5K5y/80pF0/jgAirpJbqaHCrgfawTc/WDRdoHwxfn+x6jOlHCFN/lKNZ6ARA3rrNmVK4tWX9zvQ2MPQ0oMh2ozufS9dFQ7U6jWo6uF0FM/KG+YuKRRbrywPRO83DKk6tc3hN9FM6t3x1VHismrF82Ub7IBYfg0C3Hp58cff/sYdflve0KZ94yXM0DWChz1PyecgAIDEDTAAv9QaoXLRdWcNp1PD3J42nHxR156cbSuGGSHDlvkYMiEw9F/41j49HjDp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xfs_remount_ro() starts with sync_filesystem() which fails with EIO
after a shutdown. So a shut down xfs can't be remounted read-only and
emergency remount (sysrq u) WARNs in reconfigure_super(), a panic with
panic_on_warn:

  forced remount of a xfs fs returned -5

Going read-only doesn't need to write anything. So ignore the errors
from flushing and from freeing the COW and post-EOF blocks once xfs is
shut down, also if the flush shut it down itself. The rest of
xfs_remount_ro() copes with a shutdown like unmount does. And refuse
going back to read-write with EIO, xfs_remount_rw() didn't check for a
shutdown at all.

Fixes: b97cca3ba909 ("xfs: only bother with sync_filesystem during readonly remount")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/xfs/xfs_super.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..59c83438d402 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2041,6 +2041,10 @@ xfs_remount_rw(
 	struct xfs_sb		*sbp = &mp->m_sb;
 	int error;
 
+	/* Nothing can be written anymore after a shutdown. */
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp &&
 	    xfs_readonly_buftarg(mp->m_logdev_targp)) {
 		xfs_warn(mp,
@@ -2115,9 +2119,12 @@ xfs_remount_ro(
 	};
 	int			error;
 
-	/* Flush all the dirty data to disk. */
+	/*
+	 * Flush all the dirty data to disk. That fails after a shutdown, also
+	 * one the flush itself caused, but going read-only still has to work.
+	 */
 	error = sync_filesystem(mp->m_super);
-	if (error)
+	if (error && !xfs_is_shutdown(mp))
 		return error;
 
 	/*
@@ -2133,7 +2140,7 @@ xfs_remount_ro(
 	 * cached inode, so this requires a synchronous cache scan.
 	 */
 	error = xfs_blockgc_free_space(mp, &icw);
-	if (error) {
+	if (error && !xfs_is_shutdown(mp)) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
 	}

-- 
2.53.0


