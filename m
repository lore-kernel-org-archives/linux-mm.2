Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFC4606A333
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GTn2UBg5
Received: by kanga.kvack.org (Postfix)
	id 3FCBE6B06C1; Fri, 13 Nov 2026 07:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D45D6B06C2; Fri, 13 Nov 2026 07:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311436B06C4; Fri, 13 Nov 2026 07:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09DD76B06C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89D86A7F2A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:21 +0000 (UTC)
X-FDA: 85429953042.25.2892C70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C7AE820008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GTn2UBg5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmd4fnAESC5s+S1auO0HRGz+bU+qihMAxFdeQVUo7iY=;
	b=SAjLdzb2MMPyAOfNewLxrYX6g17ZAndIXpjre5eTyYQ7bI7/Z7Ukvy+UswZvKQANLCb9z+
	bXPpN1HPARRZ+42iN9oM90Sc6YYFPPyqF1WCH9Ecf8n7EBe4oeFveDDIGpsLKcTkav7fRz
	HU/mxVv7HDK6OLGXfPPkiXGEg7m77ug=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GTn2UBg5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571219;
	b=nOnuALCkcqa/f9DjkCKoKWGnvKG2GdbhTE7tdftS6kRw2DNaN46G3ZoqHgzaCx2wTHj18h
	jwBNUqsnTkx+H0jagILVjblAapfCcYD7QzoWcOqOQ1tJ2+OPeXKgLPlppEsetkbHwvLLb7
	EqRtU8HXk2AZEB9Gc8353lppRcg74vY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F8436243B;
	Fri, 13 Nov 2026 12:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB001F000CD;
	Fri, 13 Nov 2026 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571219;
	bh=lmd4fnAESC5s+S1auO0HRGz+bU+qihMAxFdeQVUo7iY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GTn2UBg5bwmUVXQO/l/ba5bU7JvnblZR6f7K8Cc/4UDIpbisDGUOWJtOTtUWlomC8
	 VoTwfmsqGlb34fjZGac21NjFClu/qAObLKxD5tGb1irA1w34zaFbLToPCCtUHK/TyS
	 TxRlzsEuQRKg9jvXiNWkhwn9qAKto3lYrXe+vG9WKGRsF8/fh++J0dWAH++mER+ing
	 9y7YaesnZpirMMeMVnQqx/ombJZ6cDiQavuu2lAPxAc+Oohj5LPdGFrh9XeRPoKI0f
	 S1Crb5FaAt16rrSx0O4hcFnQuFCYfEdZ516JjptC1aONpuXVNsCwZVO2XZlOzYkkNX
	 2Rs9VM5LgosKQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:58:58 +0100
Subject: [PATCH v3 02/33] jfs: use jfs_symlink_inode_operations in
 jfs_iget()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-2-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1129; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JNfFHN04nudrc8oADaIN14/RzFJ3qnkM6OHZD27WnLA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z17w2YfgQm3c9fKKT85PU0/OsvvnNxsGdf+1J8r5
 K1zg3u8OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby5j7DX5HJ5yzcGOUSeE7m
 ltbNm+AulPvoyXS3Y+ElWj+my5yd/JXhn9ml3bZNU1x3LBTU8mWI3fJ2iuiWyx55DcvlxH7wc6V
 O5AEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C7AE820008
X-Stat-Signature: 57kums91pbnizgfbsncx7oeqcjox6edw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571219-383115
X-HE-Meta: U2FsdGVkX19ptpRLVUeKFoqcqkDiN1pUscsKGZB/+Qsm8xS3o1m4kLiPRRLAgJfbqCn3vRd+m0AjS4wh1WXoaQwq2kX8JuZaeVFswj5b1bscmS7/5a30xQl79o6mScErFshWYgvT9hYuRnK4uuyUoFR7J2k2y1FNHjnfTgO4WA7CESl6yJ91c7dfnuKURYzB8jg3tAky+T6aOSBO/9r0vha8N4zK4e6VLEULaMIWDnRa0k+ZWAy/Hvs/+Rfjta/N/a1PsY8sTDAzL28uujsKGHcgPv6LZ5KMshH9yefUM0pFbekl4XsyQ89RkQaTACkBW/m2jKtx4PV0FgnNofYbdrrPubPBhbsXp8eiOvbbHLfTatZfKQwXUCEVS489zoxrsd1fn7ZiQ4AY2CVrFMSdJ0PAcnGXBV6SLspcIpRM83zvxjZxZRCrjv/Gwzdi4sUhRqtNW912fLoRGVbKvhDVgGautadOyWQxtxOSaiq4yNbDA+YnOgSleeMn+M52iRB3BCFygGT8UMfu5KEwMfXw4FF6eMaZ6MI/2sryNVDPYpj9cgAFtoJx/kJOZFDIW2KSq00JttUi2Az289jVqug6rJaARKJokt4tUwY12JRp33XXW5MaxlG3TYJh8e8ABNoMi2s+PjZX6f0J0VzSXbFYJ/ymsG9J9yRCSVmoi7EfleVWIxnyi7zOhc1JYxNzmEwQpMsOpXODu3LQjhqpKFzBSvS92mNGOL1eL6tmPyXjCSj8XoGlnyf8ACn5gqw62xKkT5a2Cij0s2kNd8qfN+a3jj9uyoCoWiLUXv/dV0ySUY7BF4ipD4I4wukaC7iuXw6T8JJ0tKqDkK7G2Bj1cpOqPOZxixNZrpZ6Dp8wIwpw3M7hZ4dcqaBOFwpeVXU0Gbvf2fNUhFgmjAgu+4DuiQkmOLNy9S0TAAMOfwsfGvOvZ/BszuSXlgsbdvQtcDxHuufnoJAQcL99XRm1lq5WEDF
 OPhQVhAC
 YBOV8vl4bnr/Uq7lQldAdzIR3ITBwDDL5CE7LX+b1ctarIRuuRZPBTWFnji0PoEw3uTbyPvvmz6pCyLKar5cOL8lELwBG9gIDhENfVLk7BBEBDXnDnig3zK0Cs1/qtues/vRlw0pLaASdNYOTkY1xeyDBoGNpx7/0ihp7QK4X7mzbj9RhG0BF0UeUW3GtPUW6LpW7YYO36eXW8U/gZvcmTHRj3N9+qG9ss/5WHJ16KauySUFmJl82Qg0ME1vqN6slmpVPIrFLV9xRvtxKQJzDiwWp4IapyYCQrMWqNS/oMUruB3VUyvWY2AabBBrgvYTNjui9tmvWVxjFiqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

jfs_symlink() gives slow symlinks jfs_symlink_inode_operations but
jfs_iget() gives them page_symlink_inode_operations. So once the inode
has been evicted a chown doesn't go through jfs_setattr() anymore and
skips dquot_transfer(), and listxattr(2) doesn't see the symlink's
xattrs. Use jfs_symlink_inode_operations in jfs_iget() as well like it
already does for fast symlinks.

Fixes: c7f2e1f0ac14 ("jfs: add jfs specific ->setattr call")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 6390d915c7f11..24b51461aacc9 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -47,7 +47,7 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_fop = &jfs_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
 		if (inode->i_size >= IDATASIZE) {
-			inode->i_op = &page_symlink_inode_operations;
+			inode->i_op = &jfs_symlink_inode_operations;
 			inode_nohighmem(inode);
 			inode->i_mapping->a_ops = &jfs_aops;
 		} else {

-- 
2.53.0


