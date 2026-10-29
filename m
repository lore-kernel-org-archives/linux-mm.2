Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41D560A3815
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1VrcVdR
Received: by kanga.kvack.org (Postfix)
	id 821E16B05F3; Thu, 29 Oct 2026 12:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC026B05F4; Thu, 29 Oct 2026 12:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA046B05F6; Thu, 29 Oct 2026 12:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36CE76B05F3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9F1914037E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:14 +0000 (UTC)
X-FDA: 85376148228.23.AAFB38E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D44CC2000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1VrcVdR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16Wgozw7LT1A5dnMoJk9SHvNZZAzQHZiP5/cR8RnnG0=;
	b=Uqv0MLzSAUqYixv0X/eotGMPDlZ/lsdnmwYPwNRw6Tte7Gsz3KeEuXfH9DgJzrmiJLMSP0
	USiw3C9x3LTQj/Wz1oOn8DJwcn6EM07Dp0mWoES91ZdslzNMPtWvQNKeYPZF4IwjXo8EhY
	4Gq+wxx3PrdCmp50Z5wmhM5mphBDwFE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1VrcVdR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290152;
	b=WnGOHnC61kiHUYJznk4AQaczrR4gwxzV3CJ092uz0I3xGtOjEJER3NHoDfRej2isDJ6vF/
	OPyAI6FPIvDh93I1L793SU8L5RLgcA9xbZJWYQdKhHxMn91eEuxVhXWD76ue2nDhLvBc/x
	+yIQ7F5KNuZJ66dx+HmwuyZ4wes/SfA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B3CE41408;
	Thu, 29 Oct 2026 16:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DD91F031E1;
	Thu, 29 Oct 2026 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290152;
	bh=16Wgozw7LT1A5dnMoJk9SHvNZZAzQHZiP5/cR8RnnG0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S1VrcVdRnOvjP4guVATOUYSh2lSw7KvpmtRZJkenH5WiiCzWXOMSugsIQ6KKG9ruY
	 zQp8jE3B0+Uq23U/Ke7WU85HbFvw+Zb4NvrwlZnKgVYSwJ44OALdo0VacN9o6XWAyY
	 rODHyJbrdd7wMxHesIuwViARaA8X3D0GGo0NsDvwe53p+vre+zuUNphRHyenQrHCJT
	 mZJvMH77+58E/EqBVgo3e/Le0z7pZqJYjfvT/7NXGOZ9aVpjuppQvc2tvW7HdnijBR
	 xJVQk2g5Z12Jn6bLsmqmSM0vFsTSdC4FrxF6im6ITyi8u1ViGKwnEjkfEUhnpJrPkF
	 +1u4PBKBdrdtw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:17 +0100
Subject: [PATCH v2 26/34] gfs2: don't set SB_RDONLY on withdraw
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-26-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4731; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KWX2HXFYLWOE6OyGqLY2drCdSkcUPo4c9Q5+N17QpVI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjcQu27C9P4ik4DW6xNqGsUX+Lx2fJEUnPPhla/hF
 jYNfcUHHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPpfsPIsETt1cbFfxv2XNc9
 2r3/akT6ueTH5/Kd1LV0RLKarokkfmb47yJw4KrX53/3BaZMyXzMK9aiOiPL3/CVPpv5d7OY5md
 SjAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: D44CC2000E
X-Stat-Signature: r9gk4qf49sa9nfq1eah6yo4kgtu9wcof
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793290152-570067
X-HE-Meta: U2FsdGVkX1/CWtNntOJhLUu7E4o9tB6oNBq/u2FjVUYf01+nOJH26An7rbszZAWCj+Z+h+NbX6yWqVXfN0fEIKb54EmRbpdOOayfoomnYrcLBYiq0WFdJeRidba0/lRugIhu93zWePgnckaZ4xR5MP+/PBR+i6on3/q4LLY/NH+3Vgk8lZP4DP7n5JNDNkxVEY/LevrMHtlqM6zMn8cp6I8x4bv78ZDvR7/1HjHqPkqE0FJhB6NrjB36M36qmJ2ofxx3Rurj7mhHVsxz7p/9S9J7pffgoTN34OGvW8ScYBO1/fBpM7GpOaR3/utSeLhh0i3vyf+P65Lfj7R9mw94pe1FWROhWdf4Q3TgDNpsikZQV+poiEnmN5Yat84+NcgZZRkbuymgW20rF+/x+Wvwe5tXkcPB6PWZfR4wHxOinWNl3E8ayE3sIoJM1T4rZYYISQmUEMnojSceibDr5/KDJSrF0mv9JLXe5hxPCFhxrZuzZ61eHqdBWZr4PdmHXQu3gwYvFVgun7zW4duQdMxlNxY2t0CMoERQTNHfAT/ZsJVlu+BMxgb2J3eCh43NAvrn/Vt123+j5m6volW1aa4l62vqzUnOkjAaPx2cevXbdO6Jk3V4AAz6uJf2fMZX0Ake6RB/Ah21Lh5v3pvRegiEjfjQaMV5+oV4MPVaK8NbGqc+cco/1JusKUGVFDByJuc7VE9AJAurvuvJdpFSR2tvSCxUaMZkPLgeB4SHCBDvapf2LDmfUbb2hdLMrwd+E9Jtzl4NQlEeSVdgixIJtI+hdBYj8/WPQ5CjExWeMstQ8M2VrldjaZs1dxib0tjDTyI1NMO0AiFhp/ojr0DwrU7Ks+AuX6fQ3PTJWgye89BNgWdqv98+g0Wt2DjRPZZGlsJqLtUXguuuy0Q6YNYmDDEs0t0v0L5/fuboFPBys+SA8XpfUmfH5BTfU/hila2+p6Ax9cApvD7iCPOi45uISqY
 WftZu7Gb
 ZLgfvyu0YzNT5sPZS83Mqfifeb7VdTJZ+vRvhuXIk3XMTgtKdhfG9RwgoR+slt9P5qYTponsDW37tktHQ4R9ZsMhMXHw3VxetUzbmTsOXyOvnJ4aoxzuhk5kntUEIL2/DAcgOsCGncW1NS2pSZI/lgieCBu87IMbvyhYcq26mGhq7tvs9yFWMia6GDkD9QbVxcIZbMwRSDF6JMlhwYt/fGOYXB+4TCAKKHunN+S9dVzeS8w8Ta48hdDIhXg79BKe12wmEX7MoqGhuvWp3ik/PQdxVmMqBgnqCO1knIe6CwATnPzqEPtMhjYLgJRuIsGxJ+ufiMfO6tMz1SBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_withdraw() sets SB_RDONLY from the withdraw work without holding
s_umount, also on a frozen filesystem. FITHAW then fails because a
withdrawn filesystem can't take the freeze glock. Emergency thaw and the
gfs2 "freeze" sysfs file see SB_RDONLY and leave the s_writers rwsems
locked. Writers hang and umount warns. And freezing after a withdraw
fails and leaves the superblock frozen.

SDF_WITHDRAWN already stops all modifications, so stop setting
SB_RDONLY. A few things have to come with that:

(1) gfs2_evict_inode() and gfs2_quota_sync() check gfs2_withdrawn()
    next to sb_rdonly().
(2) gfs2_write_inode() returns EIO once withdrawn because sync and
    umount don't skip writeback for a read-only superblock anymore.
(3) gfs2_do_thaw() thaws even if the freeze glock can't be taken again.
(4) gfs2_freeze_super() refuses a withdrawn filesystem with EIO and
    thaws the superblock itself if the withdraw happens while it tries
    to freeze.

This can't be split up. With only (3) FITHAW leaks the rwsems of the
read-only superblock. With only the SB_RDONLY change FITHAW can't
release the rwsems a freeze took after a withdraw.

A remount to read-only writes nothing once do_withdraw() ran and waits
for it since the previous patch, so sysrq u works on a withdrawn gfs2.
Going read-write still fails with EIO. A withdrawn filesystem stays "rw"
in /proc/mounts and statfs() doesn't report ST_RDONLY anymore. The
withdraw file in sysfs still shows it.

Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait for it to finish")
Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/gfs2/quota.c |  2 +-
 fs/gfs2/super.c | 20 ++++++++++++++++++--
 fs/gfs2/util.c  |  5 +++--
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index b2984fb7b35c..affe4c3451f5 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1335,7 +1335,7 @@ int gfs2_quota_sync(struct super_block *sb, int type)
 	u64 sync_gen;
 	int error = 0;
 
-	if (sb_rdonly(sdp->sd_vfs))
+	if (sb_rdonly(sdp->sd_vfs) || gfs2_withdrawn(sdp))
 		return 0;
 
 	qda = kzalloc_objs(struct gfs2_quota_data *, max_qd);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f61c309368ef..82f9d90f3578 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -455,6 +455,9 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int ret = 0;
 	bool flush_all = (wbc->sync_mode == WB_SYNC_ALL || gfs2_is_jdata(ip));
 
+	if (gfs2_withdrawn(sdp))
+		return -EIO;
+
 	if (flush_all)
 		gfs2_log_flush(GFS2_SB(inode), gl,
 			       GFS2_LOG_HEAD_FLUSH_NORMAL |
@@ -686,7 +689,8 @@ static int gfs2_do_thaw(struct gfs2_sbd *sdp, enum freeze_holder who, const void
 	int error;
 
 	error = gfs2_freeze_lock_shared(sdp);
-	if (error)
+	/* A withdrawn filesystem can't get the freeze glock back, thaw anyway. */
+	if (error && !gfs2_withdrawn(sdp))
 		goto fail;
 	error = thaw_super(sb, who, freeze_owner);
 	if (!error)
@@ -751,6 +755,11 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who,
 		mutex_unlock(&sdp->sd_freeze_mutex);
 		return -EBUSY;
 	}
+	/* A withdrawn filesystem can't take the freeze glock anymore. */
+	if (gfs2_withdrawn(sdp)) {
+		mutex_unlock(&sdp->sd_freeze_mutex);
+		return -EIO;
+	}
 
 	for (;;) {
 		error = freeze_super(sb, who, freeze_owner);
@@ -767,6 +776,13 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who,
 			break;
 		}
 
+		/* Withdrawn meanwhile, don't take the freeze glock again. */
+		if (gfs2_withdrawn(sdp)) {
+			(void)thaw_super(sb, who, freeze_owner);
+			error = -EIO;
+			goto out;
+		}
+
 		(void)gfs2_do_thaw(sdp, who, freeze_owner);
 
 		if (error == -EBUSY)
@@ -1488,7 +1504,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	int ret;
 
 	gfs2_holder_mark_uninitialized(&gh);
-	if (sb_rdonly(sb) || !ip->i_no_addr || !gl)
+	if (sb_rdonly(sb) || gfs2_withdrawn(sdp) || !ip->i_no_addr || !gl)
 		goto out;
 
 	/*
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 888e0d6bf512..e720f73b7b24 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -132,9 +132,10 @@ static void do_withdraw(struct gfs2_sbd *sdp)
 			   gfs2_log_is_empty(sdp),
 			   HZ * 5);
 
-	sdp->sd_vfs->s_flags |= SB_RDONLY;
-
 	/*
+	 * No SB_RDONLY, that needs s_umount. SDF_WITHDRAWN already stops all
+	 * modifications.
+	 *
 	 * Dequeue any pending non-system glock holders that can no
 	 * longer be granted because the file system is withdrawn.
 	 */

-- 
2.53.0


