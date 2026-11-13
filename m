Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E399606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mupl0aGo
Received: by kanga.kvack.org (Postfix)
	id E39616B06FF; Fri, 13 Nov 2026 07:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11266B0701; Fri, 13 Nov 2026 07:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E316B0702; Fri, 13 Nov 2026 07:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4C1D6B06FF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:02:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11F7C802CC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:15 +0000 (UTC)
X-FDA: 85429957830.03.AF8C800
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 39F411C000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mupl0aGo;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvxqV6rBMhuwjgNvbm4HdYkiAl72akCQocg4irtd5xY=;
	b=pYRH8ncxE1uSAJqG+lFNPYt5pqDGa2UUXZN24gNVyDw9iNW/MeodvSFUY2LRR6jKCFWzb1
	MitvAgm4Y+x/v5kcEjMsgAJ+xa14P0Jyd2sz2lO+GV+ZERAjiBHdr59U14fS6Zmpf4ISoa
	HRqmVpMQf2v8+/vHUWOaNU83lZmvLQc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571333;
	b=Fy1VpWmHjPGoju058s4lRhv4EInZUpuldespRS3YMgR3dX25bo8a5vcjlyOWtAj2ICwrfz
	bJdWiNfwZ1iYwMGBB3G0MNM9GvK3h+vKHmqDoNDVjBV1qkSFUERuEr93KE4HnP+0s5Bpem
	KRbHf+Qsda7RYoPf3/PfLzKL21rrpoc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mupl0aGo;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B25041137;
	Fri, 13 Nov 2026 12:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662D81F000C9;
	Fri, 13 Nov 2026 12:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571332;
	bh=wvxqV6rBMhuwjgNvbm4HdYkiAl72akCQocg4irtd5xY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mupl0aGoCEKRrJxTZLqZbVpXPKIl7wKiL4i08LuH57sJaIGeQDbF3qDkf4HWkWkmF
	 IWp95SsS9DvzX0/D+DJNCRmp684iI/OAxb0prndGs1l2/wQhCGekwGqqqi8CLN+ht1
	 cQVYnj7KFusuXb7D1t9qrN9UHUXmPENkLkAi7v5FXFuJI89xcfjGM1Fy8ylnoZrzMB
	 y1/BW3gEa1gE33/+iuoRZkywUx1tuTbvfVLUF5HbHJBDK+3N+D5zqWGInn5SlBcj51
	 fDy6xfIOHlZyeIfMjNqMgrKLjLXFiXxKPf7mwrLl8uFS+BGgTA2EtF6AEDranfWg+Q
	 vFEoVZu64l2eA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:24 +0100
Subject: [PATCH v3 28/33] gfs2: don't set SB_RDONLY on withdraw
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-28-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4737; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4Z6USPkDhlKo3OfSZLyvVwhHh60YY76o8yAB54W4804=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+727L16KRXrVgZCrfyQ/3px6cJFhQfWXVzs2T/3BE
 soxaVZVQEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEWGQZGa6db35d9Nbo46Ne
 d6vFc3O11wqfKFsl3+Dia9Trf8rblJGR4eM202nmndteVuQbCTPcclgS4pGZOCNdJOR2MZfLhN2
 3+QE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: e98a4is51rxrug6ig6ib37tza947rxxg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 39F411C000A
X-Rspam-User: 
X-HE-Tag: 1794571333-471165
X-HE-Meta: U2FsdGVkX1+WykzNKMk1ZZAIUtVrt9AzKWUxWSFQzp2lUF+X9GjN79TPLuczvTFcR9iEnPRppcUaMii0mTP13XpAlxQihKD96NmiluUz5qKYDwNEgvOem8uukfA6VqwEGfYf1t1SfG3vKG3lOI32+uDoUOSQBqQRDBMLlVa8zFSlfsKAFfJ4Lf81RkPLiPRytGmNn9JO58Cm/+C2BdT33JqIlzvROy8SbaTMmM1WgRIHTFwxLgmGJ6hI9ov+t2zSEeuatNbZQOJdXGvFytv2wJy5fszN6g9rZ4RW5sKQ0AiVkIExbYPkSOztccJIUpzCeJuTIxTYXCnWIp/PAugbJlzqrg1eg7tHY1hkjNRoqHOPGxnSwP3XnwJXZCOTfgr4Fc+gwHCC0IJm6JyhL7/r3bY6avQxqCqrHjUquF2qPeD4p2dcPlS2zWO2p6paBr/r/Mv3Qb7H8T0ph9dDaXR5EtpxtiDGROzC3bhYaTNXugNlIvrtshgIx1oQ6bKFmHrwCd9cp+4TyOr1kmZhnBjv25U26lBKj5ud+qeP+n2uUS4HONXqYINCv8Enogz//gFcZ/bTlTSYqvKk2NxUX/VtRbVFZEKbVO/lap/0LhREnUZshnc7qYedlTYEkBuo63S3ia/CZsUVEU5DCLmgpiyMYZKsaqxoAsaTi027EAeLNmL5twuaVS05uHs5FrWDMa7btKIVEsmSnZ27csob7jvJ/wg2RKK5Ppa9jKI420k2wvsDAU6aZssY5TugQ/azmgcdVXqGDjtH4HxLswPaWNaB6PbtT9mgulRFjTAnwUa6JkvAi9Dxxk2jEXIgiCmzMpcKiJvRE/+pnXr9yONL8ffoYkwdkJOAqIMF6JsuP4hXoLBQ+MheW8CoS/vIN1qRldg8zMdFjsmJ0tCxb7rxex2puldy+Jff8mdGI7l4OwGf47RxfZSUCA7IHqDc+Na6j8HPBDQqiH+B/dF7wYgIljK
 Dqtw26lQ
 PorlhDJ9rio//686rPgYuAwqUOkBi6lpe+PTuj2mSKjzDUEzFzTeq6xc7IWOG5bZrNecP2Z9byzoc4BfdAx0Y99dokwf3NBZEcs+A0tP/oySVR3zQVwZLs55j3If9GX/GfMzAwvY19ijuG3j1OR7jtURmbUlMyu6L4S3YthBEkmOr0xF6MjpLvQl5Rcw5g1S5npLl5lo3SxHxRh5vK5dOvOqYXhnkY6t3FeGWFJwuMGpNR1+1iXRQzRth5EvZWG56AL9SgtNvqgQb+PHM3tDXWmhKnug+QPRsjkbZGUXToNFSmi0B6ydtOLtUx0L+fbKocIlM9GzJRgQa4cM=
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
index b2984fb7b35c3..affe4c3451f5b 100644
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
index f61c309368ef1..82f9d90f35788 100644
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
index 888e0d6bf5122..e720f73b7b24e 100644
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


