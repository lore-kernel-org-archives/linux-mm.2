Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EE560A2617
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eKqQh+7z
Received: by kanga.kvack.org (Postfix)
	id 427486B06F7; Fri, 13 Nov 2026 07:01:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0126B06F9; Fri, 13 Nov 2026 07:01:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED856B06FA; Fri, 13 Nov 2026 07:01:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9E6E6B06F7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E19BA7BFE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:57 +0000 (UTC)
X-FDA: 85429957074.24.0CDEFF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A1BF180016
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKqQh+7z;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571315;
	b=Zg/w5+5yBHKoosfYqRTw26TmfXKfEGhmhBLKvoQTxYjHhJV76sNHH757fMr9wmxUg4FAQi
	cTRAgzeE/tSneFeFNSBdyv2Br9miIBj6ozLOcJ4RpWxLMcZg3EhrWXA9UKh8OFD+EpLG09
	/glrngkytPDeseGApmQ9e2t0KBo1fts=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKqQh+7z;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2/MUeVszLfB4RtsOn4WKnrIcUTtO30etZqZbBOXA4s=;
	b=46I25ZJ/rXY8EtNxkYRZFhk75PwI5B33Ebc8aZ3WDwkDduED8zsn2zB0NDA0EUn5fhb6MV
	knWobrAYHPPfYcqAyL9gE2Rxh1cnsG2ZhHFYoG9FZF/lZhVns4t7qXfd/aJGlOyrd0vhlR
	YAlJ0Rt6eJ2vEnLiURX0O4/k9OHStPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 390A162236;
	Fri, 13 Nov 2026 12:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4111F000CC;
	Fri, 13 Nov 2026 12:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571314;
	bh=O2/MUeVszLfB4RtsOn4WKnrIcUTtO30etZqZbBOXA4s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eKqQh+7z+yQn8SfRPcQiJrlyaLd+6GVVio057/v2gxV8N2tV8p2k93hVROT5zEjYS
	 pwSvyXLSrsY/MkoD1+ie0kIUz2xD5Gojqu3pg1/5fIIffIeNNjmu3BKigMWVc2uxVb
	 ov5BxBjxQjo1Bhd+lc2Jaw2iA+/IXQAxqRQnRNvUtV9w7AjzBZ7EQjC2tTYmL4EHbr
	 sxdS35mw+qqzalhZpUnEHFw/CUjcs/24PUefi1E5sPn/yTfnCJ4KP8F+lUVIbxKGTL
	 xUQgrDqIyQmwDKtjlkJbIcDA3dMhJjoqjDTJPrfYZnlFiohGMYUqhx3zZzsloxt8xM
	 aSyekIeH8IGyQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:20 +0100
Subject: [PATCH v3 24/33] zonefs: use the generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-24-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4502; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YjmE71/9/Uw3i5bx6DCMi7QXXafvEqrSsF85N/7XKgU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+70twtp+y6Tr14t0N93glXf9H3Fm6YLd7sduzr2xZ
 83k8g+3MzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAm4lvHyPD5F9OCH0HbZvqb
 MBl2XtZIjVlyQHtFVg6n4kXZSU+i7z9jZDi6eeX6lh6OZv7dJzV83IzDeOx5lXZpH378Mqi74UR
 0NgcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A1BF180016
X-Stat-Signature: ee5qq6hizh3jedsusywnzbtap17ksc3a
X-Rspam-User: 
X-HE-Tag: 1794571315-743248
X-HE-Meta: U2FsdGVkX18xfWLEfl+4iTfGiAPjZ9o1e070wkkEAt/cOVbv0NN0FlCHkQERJlvwrxTlKu6FoeTiaf/lHSkFH41gD3tTX1RFiO4XmIyzggwHjJfUPQzfS/XWs6aoYncNGaFVVNjjBVSnM5rgUOuU9oxCPm4DorWS7ryQIh4NVPnAAZSAOaVpKuNUrSp4MWsxLbkVPRwmKCCKmMn+elGXrVeqHiJYEyFekVIV8y9x+mt9oDD+XQpPDmPo4MIay/v29Dv4HXlpnRIVQ7QIfu9JBAB/APEAteZfvFnaToeWlXGBxtDG0SF+MIYxuKJwLxzCpUGk5dTcvr1hvrgSaA2SQ/nftAdKUqFiyQhcsKCj/HM4krUl15WCtQx5bPXgYSpWxh8hO6ysh6IpDWDJvn6+yoDQ6s9ALZpi8swIxEPpqj72uL9BA2m5tRgbpJuIKEyoy2bJb0qGdyQTL14HDOwNIZoVd92CtoNOEZTDP4Lryo7syN99RJ5buY9liidRvwb4jdfVEP7LWqOYe1FTufu0vY5hCs0cZemKJs+jfcDHfQoE9SwQZoQ7Nbgy+QmOC4OcedlBoLGSfjJM+iVz3MrzC5RdPwvjdNBSPCrfIP/Bi+A3jUBbSqkGfyUUYfd+gqMzQ1YmZ4CeXovzNuHYxzUam/NUa/3qc3eMjeH2SHrKgWyI4lPDCd48Ae6c4hRMKXghlo8OK7RFMZbCmRdb15nZOf71acp4XdFH7IisLiv++J7dIdyKJGktU253inlsWxpBOTz3+b6GMG7kf8S4+k3NYZpZLvGdBMvh4ft9f8wy9jE3IcYY0Do94vHEolX8e6Lmg1FKrMW38xB6XsKLaVrD6hTJVYSSbryBCjUtq9QO8tB0WVbRiMiBrYEZzXe8yZOgpNqLrxLkbc+s5gBvGgwdWXquuLqZ5oH1GhoiXRWFO3+hNe5CrFdZWrIj2ddPurMV/hv+c3P2owbs7por+u3
 dekA2W4H
 rEJZvReLEIl3QzI2IhmpeYvI7fQGSoUUp5RvQ1jfQFHndMRQ8upzeTHf69BRd+/Gg8FJQTzZGnx9TcIvTrXI1qOeZKT/DvJFMYQDe4jdhep7OJ9mZAsDZNYVRZSdKyvUw0JL4JXCIrs6LHcxLbCVMpaaQu+HXHVnLdcp1ELwlsWrznKeC/S8frE214aHsJHB7fkjDX9GqnZ/oPbZCo/FowPgcXRp+hp4s7v2JwXtHAJ/zJGAzURJ/TE2m34zWxlHT3PVxPHvLnoEK++Wf0IFK/G2vob8AqSKYmMQd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the checks
the VFS does now. /proc/mounts and statfs() report the filesystem as
read-only again. zonefs_set_emergency_ro() still prints the warning
once. The check in zonefs_seq_file_write_close() stays so a failed zone
close doesn't make the filesystem read-only a second time. And so does
the one in zonefs_file_write_iter() because the loop driver, nfs localio
and others call ->write_iter() without rw_verify_area().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/zonefs/file.c   | 10 ++++------
 fs/zonefs/super.c  | 11 +----------
 fs/zonefs/zonefs.h | 15 ---------------
 3 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 8959b6b36a83a..de1a06d53ec14 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -299,7 +299,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	vm_fault_t ret;
 
-	if (unlikely(IS_IMMUTABLE(inode) || zonefs_emergency_ro(inode->i_sb)))
+	if (unlikely(IS_IMMUTABLE(inode)))
 		return VM_FAULT_SIGBUS;
 
 	/*
@@ -601,7 +601,8 @@ static ssize_t zonefs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
-	if (sb_rdonly(inode->i_sb) || zonefs_emergency_ro(inode->i_sb))
+	/* loop and others call ->write_iter() without rw_verify_area() */
+	if (sb_rdonly_any(inode->i_sb))
 		return -EROFS;
 
 	/* Write operations beyond the zone capacity are not allowed */
@@ -788,9 +789,6 @@ static int zonefs_file_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	if ((file->f_mode & FMODE_WRITE) && zonefs_emergency_ro(inode->i_sb))
-		return -EROFS;
-
 	file->f_mode |= FMODE_CAN_ODIRECT;
 	ret = generic_file_open(inode, file);
 	if (ret)
@@ -832,7 +830,7 @@ static void zonefs_seq_file_write_close(struct inode *inode)
 			 * file system read-only.
 			 */
 			if (z->z_flags & ZONEFS_ZONE_OPEN &&
-			    !sb_rdonly(sb) && !zonefs_emergency_ro(sb)) {
+			    !sb_rdonly_any(sb)) {
 				zonefs_warn(sb,
 					"closing zone at %llu failed %d\n",
 					z->z_sector, ret);
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index e7c97b75c6013..342dcc2619065 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -253,8 +253,7 @@ static void zonefs_inode_update_mode(struct inode *inode)
  */
 void zonefs_set_emergency_ro(struct super_block *sb)
 {
-	if (sb_rdonly(sb) ||
-	    test_and_set_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state))
+	if (sb_rdonly(sb) || !sb_set_emergency_ro(sb))
 		return;
 
 	zonefs_warn(sb, "remounting filesystem read-only\n");
@@ -549,9 +548,6 @@ static int zonefs_inode_setattr(const struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(dentry);
 	int ret;
 
-	if (unlikely(zonefs_emergency_ro(inode->i_sb)))
-		return -EROFS;
-
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
@@ -1382,11 +1378,6 @@ static int zonefs_reconfigure(struct fs_context *fc)
 	struct super_block *sb = fc->root->d_sb;
 	struct zonefs_sb_info *sbi = sb->s_fs_info;
 
-	/* An error made the file system read-only until it is unmounted. */
-	if (sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY) &&
-	    zonefs_emergency_ro(sb))
-		return -EROFS;
-
 	sync_filesystem(fc->root->d_sb);
 	/* Copy new options from ctx into sbi. */
 	sbi->s_mount_opts = ctx->s_mount_opts;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index b14822cb9c02e..24029c0e23dbd 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -241,16 +241,6 @@ struct zonefs_sb_info {
 	bool			s_sysfs_registered;
 	struct kobject		s_kobj;
 	struct completion	s_kobj_unregister;
-
-	unsigned long		s_state;
-};
-
-/*
- * Super block state bits (s_state).
- */
-enum {
-	/* An error made the file system read-only until it is unmounted */
-	ZONEFS_SB_EMERGENCY_RO,
 };
 
 static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
@@ -258,11 +248,6 @@ static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-static inline bool zonefs_emergency_ro(struct super_block *sb)
-{
-	return test_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state);
-}
-
 #define zonefs_info(sb, format, args...)	\
 	pr_info("zonefs (%s): " format, sb->s_id, ## args)
 #define zonefs_err(sb, format, args...)		\

-- 
2.53.0


