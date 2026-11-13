Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7E6606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cf+yeFhO
Received: by kanga.kvack.org (Postfix)
	id 3B3226B0708; Fri, 13 Nov 2026 07:02:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363CA6B070B; Fri, 13 Nov 2026 07:02:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252A46B070C; Fri, 13 Nov 2026 07:02:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2C3D6B0708
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:02:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5599AA7C6E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:37 +0000 (UTC)
X-FDA: 85429958754.21.0251162
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 73FC7140009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cf+yeFhO;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqpl7OV39r2iQfy91FqwaHd5ZOtj6zGRSvahZGEYD+E=;
	b=6idXWzaIpNUWFSC7jCyposx0ghGA17aBip50w3q1p3tMKrVJIF/vKEKfOBo/b6OVXUyDvT
	LxhN6yn4ZgdGWcjxPQ78fOaFotW4E7EdZt4JYE87KBT3NhDNbsiZx2lIMiJ0j2zP7yQ8f6
	ZsyChGSDTDRZOUsU0/guRwQIK2taxN4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571355;
	b=5IyxlDfXNk+KmlXSMU16vxLR4fD78T7HRIw9LeqvV0spMx+XnYDgxAtJv07J4GxsPUggzt
	j5eKqHOCyuYfOEkMpywEitvIo382QjdKiiW5fsmeJ+l786vJzFVTCwy2sWfEsQlV7Nspnt
	4bZm4Jrh9fDg1Dtx209MAzPU8J3M1Ng=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cf+yeFhO;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13E0562236;
	Fri, 13 Nov 2026 12:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF12E1F000C4;
	Fri, 13 Nov 2026 12:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571354;
	bh=nqpl7OV39r2iQfy91FqwaHd5ZOtj6zGRSvahZGEYD+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cf+yeFhOxffbF4Gcf34O35WTxadG12WvPaCmfzpM4r32A0Zx6mgMDJc1sLO/YM6kO
	 AttOejPt8vjAVMDguouOKgG4chNWLadxzD+/+x0udw00EWdrBxZXjjyUGxXiNfr0KL
	 2Cy4hMfY6XBfQRpX+3tRTOLMyM9ycZzFnmbhGe4vQX/XMXAN8zxW+nTIQRZUDSPFN+
	 UA0HoX/cY+5dUrCcKOGhiq27KEj1oYfFrxgN2XYCRdQGCGFk9rXYAWmgfrTpRTXfVE
	 pkxsl//WEYBESVhL4XDuY4okx74G61h8X8gdb9K34VBxKOCwUYhd2LlsYSC6gjpuqG
	 xJXrsVuVLfs5g==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:29 +0100
Subject: [PATCH v3 33/33] xfs: allow remounting read-only after a shutdown
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-33-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2142; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Wv1rk/34mZRddPCwhZsrnHdy4Y6/8eX5Up6b2ymQePk=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGr2+8Ci+Z4+6tOwi97X6NaG06NaC9t14B0Ks88kXi6ffXLsd
 Yh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmr2+8AACgkQkcYbwGV43KJHWwD/VEUp
 qHV8TWkuKU4bX3KINk6z04cdivoCpFl2Vn3AuVEBANhCoTbo2sLJQwZevodePoMGYTNnOhgh2Gr
 V9nOa3SIE
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 73FC7140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pm81gf3pqdnpnk6rr83q1keb7y8p7f51
X-Rspam-User: 
X-HE-Tag: 1794571355-733848
X-HE-Meta: U2FsdGVkX19CujyRGdJDkvNnaZrmHX3QgKdt/mnOoDkqP2BTFPVWdI43vke59gDIpUyaqoF+wPjZdBi3XZ9RmC00Sv6R/c2oJsClvs+YPmVcOK00uMXRwrDRyaY/xIsoX6jImdwKJLXC+mM94r5xjv+mrv0UeTGH1JbRQFGXMYwSPPAiiuEwj7UzMnxdl8jON9gv90BQo6oBA+5akqqtMbXUxBGRVNjtaR9KzvaWxHRNHymAP3XjoCX2GyLOU/dtnS3F0YKfAAxQD/B00wDMyb1Oy672RNWLCeYmdD+rjL/yXXffGW5w2u+DQR0k938+b72CFglBC5nmudJnt351OEeDQnZsPgxnws7K/GLYAZx5wkeQk9bkqyLme5UevWICyxvY9fo77KmzUFtBiX0vB9qB495lJ0aUhdGTDb1Xw38MFwzJAhAFVo8UQGOYzgN2Lj/VcWMeN+YetORVz5N9CcuBEJbfJLFkFn3nksFe0jXcY7X69dE/0xE/JEUE8HoGJ9yyLvd2kKJdCSFp6AGaTGN6EfJ33+2BlxiW74OmZQnhuarP4DiMqY6M3hBcLUG6D6wiKn54krUM8ubVkLSzhjb4yoVZuONdZzsq+OA2lfHd+W6IFkgQc+gfkp2RcSthDmVwDxN3txemPbgVx1gWquiHskiifn0uKzj18V7ic4SsBQMMiFpAwF1Cfg4IMzS9s3vEGwbCeXKxy80K3VYzhzj6khm4DETOMOToVpc0tEWXHXfxa86O/nesbuCs0WGzTYs6/xAHYKnZKb1wffxD4EKkL/B3Td+3tafkTl7fgtAC9ZQ0Y6FmnMpYa28G9sJGJ1HLzRzNWV1UG/DoyXX58tbnIyEcq3HJblWfZisncEHFeZqUT6i72On8F7qunRfim6AoDO99V150xKMgjq3qE4tZuV+iBWk1OZM8W3vCucK9/vBW3z+PjLQTljrEWslSzjtHwjFSPQBdyotITIK
 ENDg0C0g
 jWoZsAssvsNqzVD1zXOXreqAc0d3gwV/kZ9nK4HTwEq+IXwn0PFcxdIgo0zkcfElDJFA5hYiq8hHxNAl5Q3evptiuh9lVgMx/0PFmZpxL2SKQf2r2fzyzwqLgt9ifnu/xBBLAl6ChaFAH7u6L8SVWmkCh1HA1MR8SR4xuQiewH7WEBUgv6VZZ+VNftMM31Honm1rHZXJXQfik9Gn9A48wNbU0DnW2sUkyQBwVKMCJTxDsW7bpgQmHiqKmpaXFxrULKE82TjbUtL6X9+S0Oh7YoTLC8HaMxUADm5e/
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
index 5a06132aa3846..59c83438d402b 100644
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


