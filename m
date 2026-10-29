Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3439B606A326
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ABt2RYVA
Received: by kanga.kvack.org (Postfix)
	id 22E7E6B05F1; Thu, 29 Oct 2026 12:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B78B6B05F4; Thu, 29 Oct 2026 12:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF066B05F5; Thu, 29 Oct 2026 12:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D74AD6B05F1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56749A049E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:10 +0000 (UTC)
X-FDA: 85376148060.25.456BBE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97094180007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ABt2RYVA;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ADr5uxJPXuGSjmeSGOe/2HYqgziipL7CUE4bWIG/18=;
	b=FM5UHpKLrpEYO1n1yeyu99RMkLGrQ+eltHufyRKMAiKwqGvU6ntiBC5wDbfTZSIGWzBpJz
	scXiwRxF0y4NF4CADOY8U9F0UwJBu3laS7IkpVW1hjCxxp1ReQckckA9SE9Iu2RVsc8GHO
	K6zuPG7+AVvkJpnXBkulaiuepxSlfFE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ABt2RYVA;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290148;
	b=tX+1fjSTIVkNyhqeXmHyEHGMqlj1jKHoQWT4zQFwUDfOA4GzXq7JYUk9SSNWzhqTr2cYtO
	PHGPg0/11TW79GGoMWYgEl7Vg/Gc0X/tz8jiQ9fEbIz4ZUzVlwcIjh7YHZpOQomrJPOW4y
	Bwvyw3XWRfPBvRrQjZTqyeem9GtHbrU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 291BD60627;
	Thu, 29 Oct 2026 16:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F217E1F01816;
	Thu, 29 Oct 2026 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290147;
	bh=9ADr5uxJPXuGSjmeSGOe/2HYqgziipL7CUE4bWIG/18=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ABt2RYVA2KoxIjSG5vgRH3ki49HTifsqyx/g/KB/M0qNec6zvvg+0UnIB8Mwd9ns9
	 +BCcX2Bb7Vi4XfGkfOTHETD5v691H0hkfOoj/53iBnqgfLG5j5meEED3gUuR5+HzC1
	 9Nbe93wzU77lHWbxmi19/YgvmxTKHDY7q/z1PxSMql4a6jLJcyPI10OceZrVRjtxX8
	 rzVeodpu/5ORvMc6LNRhIWzcb/6Q1zeozVR3SqtFitE4PJaW5FAdh3yrBz/E92aIu1
	 IPVv/bplo0PbZvP3hHhYhbb/nL+bdgfvUD+gFW0cBSalx5WWcG9bzO2KG1myYgNHFu
	 yGXS1LRKG6QjA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:16 +0100
Subject: [PATCH v2 25/34] gfs2: wait for a pending withdraw before
 remounting read-only
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-25-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2796; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vPcA48zGmDM3VG6ECx06EweZE2j9qUmDjvB8EUFB68s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjco1fonfk/gZn31p9D/R6s+58c9Pn994u6dS/J2H
 2vv4n6xtKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiMq8ZGQ7IqfSquD3f8W6t
 /vTZ1exK2Zrsne6eWrLJ8487hrzfocHIsIuDi1O36d2MaQJqrSXOJfKzBSw+fSxeuurLgrK3csb
 23AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 97094180007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ozxpzt8rpw59hnafqairyd4qsmb8yo5c
X-HE-Tag: 1793290148-438432
X-HE-Meta: U2FsdGVkX1+3RhubDUMTB6JalxLNdtNJVnAl32iiswa0i7nX2FIUk70j7jvcaXOemMA2DUOWTuJ+rHnuQEGN9qhJywzb75l0fo+SjSRorKRNAMXoa8aEEJ6k8LtLV+EcrOk/QfBd7RYc+xgRrau/A1Zo2eQMbyCmXTA8sNPFC8TPqGKxAwurShIZq3Dxok2t3DMmgad5iBrb/Vvtx5P4RQqDuRpBJ5qtiHfLSUPum5vWDGTErGSAgnxBykIoG58lcC4maL1owuib183WpEUkKbTCuh/0hbWCbRM9StDk1JPpW7WbK3iFvT9uQ7hLYqsN+ZZz3pcQBVb6GauEQhAnT8Ub8n4taNf9a40ZXJSnbqfFXp2mIMHkI9Lgy7c+XWFbDt7kdV4Sr7/D9hIZ+MLek3oo6d1OOngYNqp1HW8x7eES7XTcA4PHFhXbdqO9s+au09EawXeJZDWmJBLmhVo3vpOo1Zg3+Kh3q39zg6dd95AaewZckhViJiYLZaQLmFcSUukQ6fkRaPVKhnPYNUJV9KrqlLkTZO+6s2T5kyGl/pwmKQGJEOAXCC67LZLSVzWzqh781E9E9Mw2F8HVDLqe2ryGbUJP3zdze42na8H/+DxjOElzi52zxNZmeA9b+rQhU+QPv3acKIVB/VkEcZm7EzPqb9+f7EuPxpeb+POylOxcm2YN6osA9z0o3gwQ87CWW8hbAZL05kgI5eDB4U+o2J8zLjA/NXHc1WzIiWzc13Bp8zCi9mGd2kN1NWgkuf2oFDbH5LRJV/q7wF78yNDgHimx83++/VuhdiDRINdGdKuyVCmEVFzO0EcCIFm03EKKhQH1sWRomT8L4NNG97VbMeYuI0ewx4h1KFu5n2So9CEksSq4Hb4PU93T7azSZoafgQaPp+jKERLsLZ6gFFBE9gYdX4xhXuzWuNFq93X94J9h8v4QzKmfYS3r+wUy9180R934ew0O7UMIHhPGWe9
 ZtGl8+YJ
 +ULP3Po9bldKs/Xq+gfB3Na71VEGkD9wwcjAEoJVwug5VDt1+9yZQ37rhrnrvJRGp/ax2+PFQv4EPwd0AZe/3VvyKfhfK7qWWGum4FRyOwl7FxdQ/G4gozNfMhKvCYpptNDN86nitFw2Yrtu8Qxr3I8khuSZS7Y1igkvkSC2BKT2ihAjkQwBZlOLh0ULbHRurhNrG333CtnxrDplb3s2uqJhci4wFuhRoiTuMg1EJd3EEMncET8Z4eCetSED4h8VBrgadAefyKEdRjCqXy4CfpnS1LyT2ZbS8Vhlh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 9c4a3de6cd5b ("gfs2: Asynchronous withdraw") most of a
withdraw happens in do_withdraw() from a work item and SDF_JOURNAL_LIVE
stays set until then. A remount to read-only in that window bails out of
its log flushes on the withdrawn filesystem and gfs2_quota_cleanup()
hits its BUG_ON(). Flushing the work isn't enough because
gfs2_withdraw() only queues it after setting SDF_WITHDRAWN and a
withdraw can also start in the middle of gfs2_make_fs_ro().

So let do_withdraw() wake up waiters when it clears SDF_JOURNAL_LIVE and
let gfs2_make_fs_ro() wait for that right before gfs2_quota_cleanup().
umount doesn't need to wait because it sets SDF_NORECOVERY first.

gfs2_make_fs_rw() could leave the bit set on a withdrawn filesystem too
if do_withdraw() ran between its withdraw check and setting the bit. So
do both under sd_log_flush_lock which do_withdraw() holds while it tests
the bit.

Fixes: 9c4a3de6cd5b ("gfs2: Asynchronous withdraw")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/gfs2/super.c | 20 ++++++++++++++++----
 fs/gfs2/util.c  |  2 +-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 04bb4cf787d4..f61c309368ef 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -146,12 +146,21 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	}
 
 	error = gfs2_quota_init(sdp);
-	if (!error && gfs2_withdrawn(sdp)) {
-		gfs2_quota_cleanup(sdp);
+	if (error)
+		return error;
+
+	/*
+	 * Check for a withdraw under the lock do_withdraw() holds while it
+	 * takes a live journal down, so one of them sees the other.
+	 */
+	down_write(&sdp->sd_log_flush_lock);
+	if (gfs2_withdrawn(sdp))
 		error = -EIO;
-	}
-	if (!error)
+	else
 		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
+	up_write(&sdp->sd_log_flush_lock);
+	if (error)
+		gfs2_quota_cleanup(sdp);
 	return error;
 }
 
@@ -567,6 +576,9 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 				   HZ * 5);
 		gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
 	}
+	/* A withdraw that do_withdraw() didn't finish yet leaves it live. */
+	if (!test_bit(SDF_NORECOVERY, &sdp->sd_flags))
+		wait_on_bit(&sdp->sd_flags, SDF_JOURNAL_LIVE, TASK_UNINTERRUPTIBLE);
 	gfs2_quota_cleanup(sdp);
 }
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 529c3ec37a18..888e0d6bf512 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -121,7 +121,7 @@ static void do_withdraw(struct gfs2_sbd *sdp)
 		up_write(&sdp->sd_log_flush_lock);
 		return;
 	}
-	clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
+	clear_and_wake_up_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	gfs2_ail_drain(sdp); /* frees all transactions */
 	up_write(&sdp->sd_log_flush_lock);
 

-- 
2.53.0


