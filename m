Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0E5606A88B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPzG1gDM
Received: by kanga.kvack.org (Postfix)
	id 7F7686B06F3; Fri, 13 Nov 2026 07:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDF36B06F5; Fri, 13 Nov 2026 07:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F546B06F6; Fri, 13 Nov 2026 07:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7856B06F3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBCF21402BE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:48 +0000 (UTC)
X-FDA: 85429956696.22.87B4AB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 088DD100006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPzG1gDM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2bkuHXOadcccS9KutaAwBh3c4yXeuMzQRsr1t2tZAQ=;
	b=0hb7IdyCoNvZWdDxDV1y10bgjPont+oL2mMEqTGDS92yRDIMK0ptkGbmSl4xFWGJCNl5dE
	YDoS/ZpcCogl5MB6qJPE+3IEu6BJD1Nvhja4+fbj6spQAFSMEa0qYKsDPaYxXKGKxKHm6J
	6/a4cvjPySoA9365p4IJS7jTIc/AIow=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPzG1gDM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571307;
	b=Sd4d0YMYAqpnogB2Ax5ietnhqw+JY/nyE1WJHVo2djPg3djo8Il1nmWocBuX12waqipGVk
	JpTi/4RtibzXfVsQ8rYGtjVdW7ZeuCbjVU7E0fzZh4queTC0y25lZJdV+YgIod/dt/NRSp
	jaGas+YF3S0alCiojTdGqjvLpcFgG7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F538625B5;
	Fri, 13 Nov 2026 12:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6069F1F000C7;
	Fri, 13 Nov 2026 12:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571306;
	bh=L2bkuHXOadcccS9KutaAwBh3c4yXeuMzQRsr1t2tZAQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HPzG1gDMq9oGUx6loVCOginIkO9mfxfe1FmcW2RIHVufW9ao3RA4+PrIpVdh2t5Mi
	 BrQttjOWSgGd40OOqWSyK+qrNGcIFzB+44ppeDm/sq5rL3k4WtCfyNhCq+MgHvV5/J
	 9eTva85uZ4YAdhHtKZJR9KR7kSOkALFiJZg0rUJFbkjpahjIMaQpPD2/b0YEl9Ueou
	 IsJjXlLSsfMXMkOvP+FV4pes4iOt4UcUmJnzxPNcTSmFLI0uMlYSHIv/xqWSy+vN6s
	 n3wA8eFiYQ2O+2i6uZAFJ3ugoc//CDl0q8fsRVzy9YxXfwEKj5NyZj0Fpe1/uBLhL0
	 tyHnVGbun1zTw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:18 +0100
Subject: [PATCH v3 22/33] ocfs2: don't set SB_RDONLY after filesystem
 errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-22-0be92bb73709@kernel.org>
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
 Joseph Qi <joseph.qi@linux.alibaba.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5018; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SsWag1VCpFeS2cP8mxSqB7YuUDxLRDPBLWrwZEnBivY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+735kMq5sLnXjml5ePq+Cf8SlmP6JUnhxbIrJqL/f
 ilurzh3sqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi3nMYGT4Xe95szNt4YbOx
 yKbj3Nc36pS2MW+bpnTi6c6OsugtG3QYGa7FLFt//u35U51nVzdEXYy+aC86I1QzcbkP14M3D7x
 33uYHAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 088DD100006
X-Stat-Signature: w1un4re3hbb5wzs5mqat67d37wd66y1i
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571306-763522
X-HE-Meta: U2FsdGVkX18UMTDwpRXwRZJzQPRXZ6WBw6XQNAU3ny2oaLsf0UFZl4Wy8Q4MS6PY6loCApGPV9oeCmXMFSTyvb1wJkKZLvk4L4TfcNpu84OYzrHMqSq1gnp7rS/p5aQAA2IoTeB4at2S7JoongF0Lw7cskjuAMXNlF2sb/shKNTJ87GyguAgpDoJ3OMFCUY228FF8eyIZzE3Tcpp4UgN+gfB5RpFWFdQQzMsQq6j/Tkn+e+MqEyIkRIRypbGXs2Z64birXTWVdhQM8beuRy8xaLUqyFKL2mjTh+x4k05xuiuvo109/UgygDqYLfSUiCwKIVITRZfCvH+HbmWU6PKzW2sZoULrryjf/R2iDjGRTlKV9r3IcoC42DGBEalMU3smkiZxq2UnVRfERWRVeyi7sbs0bTDc8VMhOrYVnBHr7SXocyqFtpBEy1ksr1BYBF3lGppfck8JIO4X36c9GOFhN2STZ5GKYk5OkK6o2dcPH3P//SRVjPVIIDtpFFqk8OJmR8ekgDikpDsLK1EEHOmXtDvjUnlyYlsKZVblTT3sKDrcdM8tUJ1u88tHS2N8w6/kGGJ6BlDNXlHFpsFPQQyK5wsfLk3nRVqoNK6NBe6Shx1A/Bwg12dBzoLNAzoDvQJl36SRr0Hhr7SaDWnv5pVYM0Ylb2ErXzn03K5MLebiFsu3swAbz6+GShvRbasot4StT4sEnW4OLW/ci1wdvngcZWCdz9vPWfVBZD8h2fhDznBKbEh3B0UrhnEUANIvzyfVJqYZoqHVUTnHsBRtPdWtepPLi5NM9w1JpuUnj5DT0OWuGLt3ZQpwXwSUgoBUpxgZwrWXXBpm2N7TlGcMtz5c7XxI76rjWwANcgXj3BALpPEg05Mls/eV+veCF3Sl7ys1jMcNEyGHv9NHCSczm0gKsjDHwEXIGBd4NMRldpoNMYiH/UueMXoczLxxPA5fKGad+O11XOyvPNrqgS/4sE
 x092z0u4
 /qbAYVp/iz1aWUFeLvpLJGfCiGeKAzKpdbG3DjFDKSnCRdAyxEnWR6kVQQ2TNeWpQxl648qX45TdBbbOX7L0thWTX9YibaYYi5irjiF+HZHPqJWB1jRy3ttOYuwhnH6txZ1/FAxkT4FFQq3vO1Nj0KjvHDYrl/cKml7ZtFzLQOOHiSHKZSTATFEM7XNPKXjUO8niJKfR0btKnWwcZJYOD261CPtFyh0MSjzt1UTydSu+nKkyY5l9Du5xpGNKtGqBPiY22sgeuebTd+Ew8oxAYrq45AFYzpJbRMf/jGfRKgnh4erqqT2/kwZFq6WaV1YkCuV4SvcsqeC5X2wd5OZOIT6DTYTCN2OFXPlch
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With errors=remount-ro, the default, ocfs2_handle_error() sets SB_RDONLY
without holding s_umount. If that happens while the filesystem is frozen
through bdev_freeze() thaw_super() leaves the s_writers rwsems locked.
Writers hang and so does umount because ocfs2_shutdown_local_alloc()
needs sb_start_intwrite().

The soft read-only state doesn't stop modifications on its own. Every
read-only mount sets it and those still need transactions for recovery,
the local alloc and the truncate log. Everything else was stopped by the
VFS because of SB_RDONLY. So call sb_set_emergency_ro() instead which
keeps it that way, and keep setting SOFT_RO for the existing
ocfs2_emergency_state() checks.

The xattr and ACL setters get a check of their own because ecryptfs
calls them without write access on the lower mount. It sits in the xattr
handlers and not in ocfs2_xattr_set() because chmod and setfacl store
the ACL through it after the new mode was already committed.

Quotas aren't enabled at mount in the error state because that writes
the quota files. The VFS doesn't call ocfs2_sync_fs() in that state and
a remount to read-only doesn't suspend quotas. Q_GETQUOTA and
Q_GETNEXTQUOTA can still start transactions. I've left that alone.

Writes through file descriptors opened before the error fail with EROFS
and umount completes instead of hanging.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/acl.c   |  3 +++
 fs/ocfs2/super.c | 14 +++++++++-----
 fs/ocfs2/xattr.c |  8 ++++++++
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 801a2f56ad08c..8fb151a550442 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -268,6 +268,9 @@ int ocfs2_iop_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct ocfs2_lock_holder oh;
 	struct inode *inode = d_inode(dentry);
 
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
 	if (had_lock < 0)
 		return had_lock;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 67283244426e0..7b0d9b29d9009 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -647,8 +647,8 @@ static int ocfs2_reconfigure(struct fs_context *fc)
 
 	/* We're going to/from readonly mode. */
 	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
-		/* Disable quota accounting before remounting RO */
-		if (fc->sb_flags & SB_RDONLY) {
+		/* Disable quota accounting before remounting RO, not after an error. */
+		if ((fc->sb_flags & SB_RDONLY) && !sb_emergency_ro(sb)) {
 			ret = ocfs2_susp_quotas(osb, 0);
 			if (ret < 0)
 				goto out;
@@ -1137,7 +1137,7 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	/* Now we can initialize quotas because we can afford to wait
 	 * for cluster locks recovery now. That also means that truncation
 	 * log recovery can happen but that waits for proper quota setup */
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		status = ocfs2_enable_quotas(osb);
 		if (status < 0) {
 			/* We have to err-out specially here because
@@ -2519,11 +2519,15 @@ static int ocfs2_handle_error(struct super_block *sb)
 		rv = -EIO;
 	} else { /* default option */
 		rv = -EROFS;
-		if (sb_rdonly(sb) && ocfs2_emergency_state(osb))
+		if (ocfs2_emergency_state(osb))
 			return rv;
 
 		pr_crit("OCFS2: File system is now read-only.\n");
-		sb->s_flags |= SB_RDONLY;
+		/*
+		 * SB_RDONLY needs s_umount, see sb_set_emergency_ro(). The
+		 * soft read-only flag makes ocfs2_emergency_state() refuse.
+		 */
+		sb_set_emergency_ro(sb);
 		ocfs2_set_ro_flag(osb, 0);
 	}
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b2bd06083a14d..a7d0ec8cdc202 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7781,6 +7781,9 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
 				    const char *name, const void *value,
 				    size_t size, int flags)
 {
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
 			       name, value, size, flags);
 }
@@ -7929,6 +7932,9 @@ static int ocfs2_xattr_trusted_set(const struct xattr_handler *handler,
 				   const char *name, const void *value,
 				   size_t size, int flags)
 {
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_TRUSTED,
 			       name, value, size, flags);
 }
@@ -7964,6 +7970,8 @@ static int ocfs2_xattr_user_set(const struct xattr_handler *handler,
 
 	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
 		return -EOPNOTSUPP;
+	if (unlikely(ocfs2_emergency_state(osb)))
+		return -EROFS;
 
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_USER,
 			       name, value, size, flags);

-- 
2.53.0


