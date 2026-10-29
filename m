Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA95E60A382C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=StoUJS5a
Received: by kanga.kvack.org (Postfix)
	id 90D1D6B05FB; Thu, 29 Oct 2026 12:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4706B05FD; Thu, 29 Oct 2026 12:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA816B05FE; Thu, 29 Oct 2026 12:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7256B05FB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0EBD404C6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:31 +0000 (UTC)
X-FDA: 85376148942.16.8C5B4A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E9FD40004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=StoUJS5a;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tghqoO8dgKkXNrANwBfbEQhOH6ptXpRkG83I7JeJUiM=;
	b=EUu9Xfe8V250GJ2mlZNsjWroevIR92D7fm0ndt5RF1YJz8jny/kYRdPK/k8tjo+A8pDNzx
	oDY0cG4sbQCAhn99z6BMaDNab7UFsNMPGcK2jeo7HLwPrbOUPelZjYK7RKiRjNN5aJeQIC
	GDup6iq8Vx+wzkc7UJ7/Lb453TJoy74=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=StoUJS5a;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290170;
	b=LfW5bITNlDZwrCUL40wmKNL+AEyP1EwITK0raz3ODhwtNxDyNLg7apRmKdea3firoZSGrT
	fZQwf8STOfXukbE3OzK3KlstNg9hm1F/XsxY3k3ISn4Bnhgw7QrhfdWv+rGNa8ffytJXoh
	Pb6UNlmTwewflwzDXfxcbhRScFP3PbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63C3443335;
	Thu, 29 Oct 2026 16:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3057E1F031E5;
	Thu, 29 Oct 2026 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290169;
	bh=tghqoO8dgKkXNrANwBfbEQhOH6ptXpRkG83I7JeJUiM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=StoUJS5aez/Dy/p0iLnpmzYRskJI6njG4RHriV4VKwHnEmSuoJpr7bf64RKmoL5kZ
	 LpYsoz5f1fhAS24bkRrkWLnYofAnj8P0THUafKWW7RafHWI2dCVm0A2NrfftU/4EJ4
	 W/a36jiBtQyLdmCJJlDckE5uFA4+djxGxtfNu5HW0DKMCMXrP35nweWjwITAu2twm8
	 Ar8Ozhlu/wg5Jvnl8D2aAP4Pdl8NzfwCxb/DsbUJOTYcGiyhF6CGbKIGj15TD3X0LQ
	 JCblZ8bW5R4fvo7BPU3E1I+l8B02IQOsLnwajPji0+DPvdymSCKmpGwsKnw6kjCi+2
	 J8bcUPJXeTwdA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:21 +0100
Subject: [PATCH v2 30/34] ext4: allow remounting read-only in the emergency
 state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-30-2f44f64f0b66@kernel.org>
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
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2356; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ti3vaFeq1wr2J3gmGLEbz9S2kgER+gU7DSPKbKEcJIw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjf41qx6p3hhZPmz/Xlf/a8WR073X8O4NyFMf+t+I
 fspOo5HO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbCa8vIcHxmS8CnWPEZp67N
 5q6/bvdVvq+uhv25WeeDk0V1PSeXvgeqyC7PmRFnnz+z9ejFH64Pv2xW9n99ZfOORsPiqZ2ThaV
 5AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E9FD40004
X-Stat-Signature: s84j589ckstw8bfgyzggao5ddaon7wgc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793290169-761961
X-HE-Meta: U2FsdGVkX18VbBBQqNZ4YUF5aBqlopz9csYaMkquyIjYl8LAghB7zt2wkJbOEhwTRVFFmHC0nljV1wM7IBNHVKoNHkia9W9HD6vGgjrct47W2NUgIN1AO29VQl5sDjeasrMrZwrOmMQ4b3ND9+hb9KOFRjt3ikqav8kmyvZmaXXhWUjCCLBkWc4cvRoIMJUPnquacfnr4ZjWJfRiF+eArilhq5gV+exlI9VMA+9lnZFRQQEvqC+8sP4WEgogf2KAs41YzSjyn2kU/cMgOf95AlDKrc6d2JXGNGbKbakaKBmBYfjAjAre2iqnsmlfzXY6HEbARCgjQhV5wxhgv9dWUqdjEdj322bRpQT+nZkJ7r6ftEa2TclhwkXfjk+NYYMG5hyCy+AjpbSZ38JocyWx+csDKqi0Q3criPaaUwfFJ1m8a6Ie2ETySVpMXE5sGxiimCvYdrw7bnW2ZxcnswIH4QOcmaPing5KBTTK2PBe51rinHSPlhWOcL/lrESfWgDrzuzb/ObUHzkiGLGEN0c2ZVAPiCmEEr/vvxuyVxajp8E/QKiPhb84qcW9BxP9dD7QDLApPz8GCvAlGwwtBre867u7teQEBRmZX9pSiaq7dCrGVIhIycZ7/t63FqPk81w9UQ6D5NldjlcwkfpGc6koPx1WF9umjBjhtsxJe6BMfEUycukkWom8o/D0FQ7R0sjY9GdJOKM2PVyoHGtpYYU33oxRAFNzhd+m71s19MRNGhbTAwbMLxHqvnik8bu+vWn7WWpCzz2OWqlKBZA6wUvfE8m2ZpgtMR8P/MVkGdpn+8eQyq8d0vUWcdqGTOqDJShDRnrjNA6rfyb/5EhDhCmqBFRa35fZr7r4vR9GpCs9C511ttco9qq8paKSRVmAD9sshqBXm0RTVQEL/enxwssB2rwbvjwslpuamPZONA5ffhfpboR3lx34uz8VmRcqmQ6mtjaeS/HUOxS5Zp8PsKN
 +7j9DomW
 vDdsyICcrqbvJhIH05QAb86rryElTaY93YglCXXaWtCqMs9die+vf/TxpYNaEdbpJAs/JriAxcvMMIMcgDByloqBtnsjHORv/t+WtwDpMgRIFAUoBKCTyFsDHW8quz3bH5RLFpXY73c3z81eQLX5bqLQ43nMqCteAA1s3qAOiMJPzVcYv3IzW+WPITHW7xTy3cNUltvuhcw8EaWRfk5ykCw7PpmzvIFzLjMCEqMjOVc2RHP5P5dZZG4a0/tNOqs/u+kDajWcL2Xie/OrZrqJgwGXLtZOk2AarXfvguLgx1hxMybMHSgozb+CIHWXG/Ok2h9KG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__ext4_remount() refuses any change of the read-only state with EROFS
while ext4_emergency_state() is set, i.e. after a shutdown or an error.
Neither sets SB_RDONLY anymore, so a remount to read-only fails and the
filesystem stays read-write. Emergency remount (sysrq u) asks with
SB_FORCE and reconfigure_super() WARNs, a panic with panic_on_warn:

  forced remount of a ext4 fs returned -30

Becoming read-only doesn't need to write anything. So allow it and skip
everything in that branch that would touch the disk: sync_filesystem(),
dquot_suspend(), the s_state update, ext4_mark_recovery_complete() and
the superblock commit without a journal. Going read-write is still
refused.

Note that ext4_emergency_state() only exists since v6.15. Older stable
trees need ext4_forced_shutdown() instead.

Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9cae52471dee..ae5ba6823c01 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6761,11 +6761,16 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 
 	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
 		if (ext4_emergency_state(sb)) {
-			err = -EROFS;
-			goto restore_opts;
-		}
-
-		if (fc->sb_flags & SB_RDONLY) {
+			/*
+			 * Going read-only must work for emergency remount
+			 * (sysrq u) but nothing may be written, just flip it.
+			 */
+			if (!(fc->sb_flags & SB_RDONLY)) {
+				err = -EROFS;
+				goto restore_opts;
+			}
+			sb->s_flags |= SB_RDONLY;
+		} else if (fc->sb_flags & SB_RDONLY) {
 			err = sync_filesystem(sb);
 			if (err < 0)
 				goto restore_opts;
@@ -6876,7 +6881,8 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 			goto restore_opts;
 	}
 
-	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
+	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY) &&
+	    !ext4_emergency_state(sb)) {
 		err = ext4_commit_super(sb);
 		if (err)
 			goto restore_opts;

-- 
2.53.0


