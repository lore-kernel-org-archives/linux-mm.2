Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C20C982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D848C6B009F; Thu, 17 Sep 2026 09:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D354B6B00A0; Thu, 17 Sep 2026 09:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFD56B00A1; Thu, 17 Sep 2026 09:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91C196B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:30:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 104A1160363
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:30:00 +0000 (UTC)
X-FDA: 85223337360.11.41E8BDB
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3506E40008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:29:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=cAl6gtHA;
	spf=pass (imf17.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.140 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKh+va21iR5NhJ1aJ3Y13UNlm+0FMnv30u4Z223eMLE=;
	b=ilzi8WQju6HFO4BMA5eea8s8Q/bWqqfxtXkHWmUHmfgWv1oSGZvbMaxrTMgGw4xzMRihuF
	YTTvbsCSjTBXREU7XimCTRWbv9DWifdqoCrDhyxqgWLItHfKvK9x49SWryPdo5JGFyFJ/2
	RjbGTUkf4LXLLV/GnQY/RsowRtlfd70=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=cAl6gtHA;
	spf=pass (imf17.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.140 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651798;
	b=DgxjaurKUnrPgZPtjRyZFbeW4A6htKtiW4ikBPJczI+V5XplEm6wfBjPFtdYUk18FGxJpn
	VfO/9Bxtzj7nfFxH68JrqEO37PdzTlWdwtVVNfJweiNSi6mabXZTq/jqvaOJbylkWWHS7k
	bs+kvMqQfFH4QBOBx5RH+c5VxlU5VZU=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso8009405e9.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-systems.20251104.gappssmtp.com; s=20251104; t=1789651797; x=1790256597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GKh+va21iR5NhJ1aJ3Y13UNlm+0FMnv30u4Z223eMLE=;
        b=cAl6gtHACYNo2fIIDYpqQu7yHqzdtBOtM98967i2jENF/fCj56a/sR4JerKrbKtzXh
         ABxqwekQpUbjXYDiHPYJlGOK1JZU+LfP5M60OAv9VTosQsY6dC7hbqI9Tig2DhmrL73I
         ANZZA88ITpl8t7YkZHp9rfZBOt53w3xueV1gCA0zVrms83JvglQeU4C75JwDmMav+M/Q
         Y8/2JxJArsZWoQeB7sQsstYXp8XUILVpDS4lDouTv1aQr9NlbFQXxI7VVNY1YyN6+sru
         4M9zIl+sDavwTG/Il95Fs0pyteP15RopCr45YGAvSeWFkm6K83Uncy03Lz8ACVetl9Jk
         5VVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651797; x=1790256597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GKh+va21iR5NhJ1aJ3Y13UNlm+0FMnv30u4Z223eMLE=;
        b=poWleN5p8Rj0fOiQ/yF/sr8GFTEbjAo9TpDbUO/nl9ucqZf36wyl/zs8q19mlY0mUV
         s9U6Xp2W6zXyJSckIXjCcXOohILRvCMx0x9RYcfDzhOTwEq9sGluNxsVKZwbF/EatoM1
         6S1khqGU0JEfFu0o6krw62zvFxnxQrCQsNTMZWw9/uHj/NatBEcKEGX2rTShDGqZcbi8
         D3MJMmwfEhN6VeOVoOrGnlTIMZsnAo5CBG+GfGCYG2B5QFqrtbbDqevcoytZDkhNf2Q9
         BIs/bbBtJ+zNU++84sUi0zZH9hz7rDKYaazoXr84uwPEETd2cXgC5HEazmQ9kYhHiDPK
         hYFw==
X-Forwarded-Encrypted: i=1; AKwUvBxfJBIBm0jyagCz/S4VOO376qnZkEppL38Xmdrp10zT2W+7RI7QoWt2PtHCpmu/loF1uUAFWe3EXg==@kvack.org
X-Gm-Message-State: AFuF++mimy8PBhYnIM6S4OO0dJEF+DZsJQbdTNzVzuFLBK7OfFRjMuBU
	mCUb97O46Ww3olm3Nj+0h1OzT5+mY672vCxz2fNyqQdAsMEB536Ls70c+z6LidNuAA==
X-Gm-Gg: AYBFou0OVfkThX48dYx2BerqvAD6s4gKRVLvKazdjw74sdpMasA/jFyGBwRaemPLlNv
	9NaOJehriDh+U9WvaJQuuV6MbNPiX1WrV6lr5OZrTPn2XNQRKavw4upKvjjYgHRewwzSV9wOWII
	ZHDEHgvDBoEvxzVI0X61mSsHw9clM1SYujEwjuSqrETeIBWgPb9koZ/lyF7Dgc0IF908yVL6ZOT
	evVLeBEqNEHKNoXM40rHR6HkOZxvLQrLDmAUYnUBvKu03lH6BA+c7XTLpXvMSumglNFVaAlKICD
	fvYGQo7Po2xfCIAMaOumw8xRQOKZ4LQ9RMQCfsFmSO2MsH0HGJ2vAnUvFXp+Lteyw31909pLPqe
	V7t7nDuPX6XbZ7/fqZCGjRt/6PCoyAziekpehIAYgHdRCL1gZFi4q5AlIstdmsRjwUouMGZM/qN
	YhJKG6o3doAdZ/MYz+pRjDVXmBzIG57dhMMqeDZ61fMTdoypJdshrw/87TeETPBpv8+KX2e6O7j
	6u5fIsOldAZvC6VyTZhsffn46awCZPpTsAJ/A==
X-Received: by 2002:a05:600c:314a:b0:49e:799e:c1c3 with SMTP id 5b1f17b1804b1-49eb73263c6mr82073545e9.17.1789651796582;
        Thu, 17 Sep 2026 06:29:56 -0700 (PDT)
Received: from fighter ([216.128.28.240])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd2356d1sm97548275e9.6.2026.09.17.06.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:29:55 -0700 (PDT)
From: Sean Rhodes <sean@starlabs.systems>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Evan Green <evgreen@chromium.org>,
	Sean Rhodes <sean@starlabs.systems>,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>
Subject: [PATCH v3 RESEND 2/4] PM: hibernate: confine encrypted snapshot writes
Date: Thu, 17 Sep 2026 14:29:48 +0100
Message-ID: <afbc2f0ca0cf680c3e47c931ed62a4d49065c72f.1789651778.git.sean@starlabs.systems>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789651778.git.sean@starlabs.systems>
References: <cover.1789651778.git.sean@starlabs.systems>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hyjnb8er1bh7fjuhj787445s5wmezq3r
X-Rspamd-Queue-Id: 3506E40008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789651798-647096
X-HE-Meta: U2FsdGVkX19BEN2T6R8DAR28/c6F8ai0kH5tTioDsyWKRL9fnl++g5z4WzOLGzWUBzNwXoMvQqqZ4RQS6VoVuISxA5rg7lvWMl0gZLM4pF44TzuexyOCFnW1sPv7LftAfClaf5JL00KybD8xqHXcsiLx6veBbHz2qFmnSAGCC3pV3RJQRA4qtXWq+Nw1xsuGB4ZZdQ/x/W43Hta7WcOYr4bm69xIaBuAwDJPGsTeU1LJfZd2ix7lp+FyS/QtYnzwbBIcz0H0F1UDpHCmddEJ/wA+IBQDAI0RchKtqHvYDCceWGoqI64vw0uB5m0P4zdkeqNKUn/hOG0iCBXuN08Rxn2mtYD3al3O849IqfT/pg0UmcUHvvmjWlAUWMkfLrBBT38jCoTNwvKqaa5bMusohJep1alf3+7LMOWztPhCa9XKJOm0oNB73qEsFIyvG/xBDduUEPhxjtPTffakhFFk1CLTTd2xLoORtEcSf4krnDDdEuSRGbDOEm9gA4Gqir5Ad24sRW+7O8Vv6P5TXRlhjqyha670BEAlJs+xBk1GSeocWGa97fMzq3v1wK1AvmaRGPhyF3nQOBoqeNJjFQkh6FOzlbf758O0aeHfpNzYa8VkhTkRGjzZfpR9uce460R/IxxOavP1fwHBunZw0O1aujRd5NC1rqrJE2EwvN2z75YzpQ6fH4ZKCG6eAubOzbvSqMLk9Ot7jZzTUGBZurt4CGCQ9az8RB6Zi7rcIr/GaY0T1rt9yRDSR3JQda+sQVweF0Guj0o1wdkqbjr5SHykMdwZkKYX7Viih4kow6+1LgMFSbtCQTbGmgUU+FB4F2w5mZsZWabqpIVX3eDNm7+C7dQEtfQ+GXggoV0oTna1B1lJdLPnq7wJDcb1pJirLv6QliYtPkgTDttsHruvvIIibKIyTaWKHxjsdm7a4NuZ/gEFFGQE5sJ4WLadoL84Q4VSIqThGCRro2PRbnn/uZm
 PidS0pMh
 bAYsqd9pZ9IzezsCTqeLMWhpRM1rxQQ4/z5dcua5XwuUUqoH/prybW6EwLv5M0znXoA6Dn3/ich4dxzpY80mL4MUfqKliyTBttOVIDeGDl73Lduw4kxg2e1hFwa7K1ClVTyFJ2g2lIUgrHxzcQjnM3dJNRUUxfRbkbVliuJyZf5O1FjiIJ3mzYncnsQ8SV1LeoJ+QdjAm6X5hg0GpzR9SsZ8MpCoDUoFKuoLD1GlyPkmD/WeeCtfG7/4gjvhxwIQok47NcuuHRU4Z8QnsexxKhmS5Tkk8A+VikHANlsJ17IOszdIGjXvywzsl+38SE++4IpvXLMMBVERu5T7RW293M8RTk7XnGBiMsKOzcAQf5+qIBXN8iBIf4AwGoEfgjv01TgNAhiS8hLtQsnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userspace writes a uswsusp image through the normal block path. Before
allowing encrypted hibernation under lockdown, restrict direct writes to
the process that owns the active snapshot, the swap extents allocated
through the snapshot API, the recorded swap-header page, and the total
number of pages allocated for the image.

Apply the checks to the active swap backend even when its block-device
inode is not itself marked as swap. Require synchronous buffered writes
so reservation accounting follows completed I/O, and release reservations
for partial writes.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
---
 block/fops.c            |  58 ++++++++---
 include/linux/suspend.h |  24 +++++
 include/linux/swap.h    |   9 ++
 kernel/power/power.h    |   1 +
 kernel/power/swap.c     |  87 +++++++++++++++++
 kernel/power/user.c     | 211 ++++++++++++++++++++++++++++++++++++++++
 kernel/power/user.h     |  11 +++
 mm/swapfile.c           |  25 +++++
 8 files changed, 413 insertions(+), 13 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 2ce7c6c4714e..bdc9f2cf7156 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -725,43 +725,68 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct file *file = iocb->ki_filp;
 	struct inode *bd_inode = bdev_file_inode(file);
 	struct block_device *bdev = I_BDEV(bd_inode);
+	dev_t dev = bd_inode->i_rdev;
 	bool atomic = iocb->ki_flags & IOCB_ATOMIC;
 	loff_t size = bdev_nr_bytes(bdev);
+	enum hibernate_snapshot_write hibernate_write;
+	bool hibernate_active;
+	size_t hibernate_len = 0;
 	size_t shorted = 0;
+	ssize_t hibernate_written = 0;
 	ssize_t ret;
 
 	if (bdev_read_only(bdev))
 		return -EPERM;
 
-	if (IS_SWAPFILE(bd_inode) && !is_hibernate_resume_dev(bd_inode->i_rdev))
-		return -ETXTBSY;
+	hibernate_active = hibernate_snapshot_write_active(dev);
+	if ((IS_SWAPFILE(bd_inode) && !is_hibernate_resume_dev(dev)) ||
+	    hibernate_active) {
+		if (!is_sync_kiocb(iocb) || !iocb_is_dsync(iocb) ||
+		    (iocb->ki_flags & IOCB_DIRECT))
+			return -ETXTBSY;
+
+		hibernate_len = iov_iter_count(from);
+		hibernate_write = hibernate_snapshot_write_begin(dev, iocb->ki_pos, hibernate_len);
+		if (hibernate_write == HIBERNATE_SNAPSHOT_WRITE_NONE)
+			return -ETXTBSY;
+	} else {
+		hibernate_write = HIBERNATE_SNAPSHOT_WRITE_NONE;
+	}
 
-	if (!iov_iter_count(from))
-		return 0;
+	if (!iov_iter_count(from)) {
+		ret = 0;
+		goto out_hibernate;
+	}
 
-	if (iocb->ki_pos >= size)
-		return -ENOSPC;
+	if (iocb->ki_pos >= size) {
+		ret = -ENOSPC;
+		goto out_hibernate;
+	}
 
-	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
-		return -EOPNOTSUPP;
+	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT) {
+		ret = -EOPNOTSUPP;
+		goto out_hibernate;
+	}
 
 	if (atomic) {
 		ret = generic_atomic_write_valid(iocb, from);
 		if (ret)
-			return ret;
+			goto out_hibernate;
 	}
 
 	size -= iocb->ki_pos;
 	if (iov_iter_count(from) > size) {
-		if (atomic)
-			return -EINVAL;
+		if (atomic) {
+			ret = -EINVAL;
+			goto out_hibernate;
+		}
 		shorted = iov_iter_count(from) - size;
 		iov_iter_truncate(from, size);
 	}
 
 	ret = file_update_time(file);
 	if (ret)
-		return ret;
+		goto out_hibernate;
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
@@ -779,9 +804,16 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		inode_unlock_shared(bd_inode);
 	}
 
-	if (ret > 0)
+	if (ret > 0) {
+		hibernate_written = ret;
 		ret = generic_write_sync(iocb, ret);
+	}
 	iov_iter_reexpand(from, iov_iter_count(from) + shorted);
+
+out_hibernate:
+	if (hibernate_len)
+		hibernate_snapshot_write_end(hibernate_write, hibernate_len,
+					     hibernate_written);
 	return ret;
 }
 
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index b02876f1ae38..a2a8863f89cf 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -426,10 +426,34 @@ static inline bool pm_hibernation_mode_is_suspend(void) { return false; }
 
 int arch_resume_nosmt(void);
 
+enum hibernate_snapshot_write {
+	HIBERNATE_SNAPSHOT_WRITE_NONE,
+	HIBERNATE_SNAPSHOT_WRITE_IMAGE,
+	HIBERNATE_SNAPSHOT_WRITE_HEADER,
+};
+
 #ifdef CONFIG_HIBERNATION_SNAPSHOT_DEV
 int is_hibernate_resume_dev(dev_t dev);
+bool hibernate_snapshot_write_active(dev_t dev);
+enum hibernate_snapshot_write
+hibernate_snapshot_write_begin(dev_t dev, loff_t pos, size_t count);
+void hibernate_snapshot_write_end(enum hibernate_snapshot_write type,
+				  size_t reserved, ssize_t written);
 #else
 static inline int is_hibernate_resume_dev(dev_t dev) { return 0; }
+static inline bool hibernate_snapshot_write_active(dev_t dev) { return false; }
+
+static inline enum hibernate_snapshot_write
+hibernate_snapshot_write_begin(dev_t dev, loff_t pos, size_t count)
+{
+	return HIBERNATE_SNAPSHOT_WRITE_NONE;
+}
+
+static inline void hibernate_snapshot_write_end(enum hibernate_snapshot_write type,
+						size_t reserved,
+						ssize_t written)
+{
+}
 #endif
 
 /* Hibernation and suspend events */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5658a1634b85..deab983ef3d6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -377,6 +377,8 @@ extern int find_hibernation_swap_type(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
+int swapdev_block_to_extent(int type, sector_t block, pgoff_t *offset,
+			    pgoff_t *nr_pages);
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
@@ -472,6 +474,13 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 {
 	return -EINVAL;
 }
+
+static inline int swapdev_block_to_extent(int type, sector_t block,
+					  pgoff_t *offset,
+					  pgoff_t *nr_pages)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_SWAP */
 #ifdef CONFIG_MEMCG
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index e080230f97fc..815c84c1e0dd 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -170,6 +170,7 @@ extern bool hibernate_acquire(void);
 extern void hibernate_release(void);
 
 extern sector_t alloc_swapdev_block(int swap);
+bool swsusp_swap_range_allocated(int swap, loff_t pos, size_t count);
 extern void free_all_swap_pages(int swap);
 extern int swsusp_swap_in_use(void);
 
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index c78f1593600b..ac736d2b59e3 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -166,6 +166,93 @@ static int swsusp_extents_insert(unsigned long swap_offset)
 	return 0;
 }
 
+static bool swsusp_extents_contain_range(unsigned long swap_offset,
+					 unsigned long nr_pages)
+{
+	struct rb_node *node = swsusp_extents.rb_node;
+	struct swsusp_extent *ext;
+	unsigned long end;
+
+	if (!nr_pages)
+		return false;
+
+	end = swap_offset + nr_pages - 1;
+	if (end < swap_offset)
+		return false;
+
+	while (node) {
+		ext = rb_entry(node, struct swsusp_extent, node);
+		if (swap_offset < ext->start)
+			node = node->rb_left;
+		else if (swap_offset > ext->end)
+			node = node->rb_right;
+		else
+			goto found;
+	}
+
+	return false;
+
+found:
+	for (;;) {
+		if (swap_offset < ext->start)
+			return false;
+		if (end <= ext->end)
+			return true;
+		if (ext->end == (unsigned long)-1)
+			return false;
+
+		swap_offset = ext->end + 1;
+		node = rb_next(&ext->node);
+		if (!node)
+			return false;
+
+		ext = rb_entry(node, struct swsusp_extent, node);
+	}
+}
+
+bool swsusp_swap_range_allocated(int swap, loff_t pos, size_t count)
+{
+	u64 block;
+	u64 end;
+	u64 end_block;
+
+	if (swap < 0 || pos < 0 || !count)
+		return false;
+
+	end = (u64)pos + count - 1;
+	if (end < (u64)pos)
+		return false;
+
+	block = (u64)pos >> PAGE_SHIFT;
+	end_block = end >> PAGE_SHIFT;
+
+	for (;;) {
+		u64 remaining_pages = end_block - block + 1;
+		pgoff_t swap_offset;
+		pgoff_t mapped_pages;
+		sector_t page_block = block;
+		u64 pages;
+
+		if (!remaining_pages)
+			return false;
+		if ((u64)page_block != block)
+			return false;
+		if (swapdev_block_to_extent(swap, page_block, &swap_offset,
+					    &mapped_pages))
+			return false;
+		if (!mapped_pages)
+			return false;
+		pages = min_t(u64, mapped_pages, remaining_pages);
+		if ((u64)(unsigned long)pages != pages)
+			return false;
+		if (!swsusp_extents_contain_range(swap_offset, pages))
+			return false;
+		if (pages == remaining_pages)
+			return true;
+		block += pages;
+	}
+}
+
 sector_t alloc_swapdev_block(int swap)
 {
 	unsigned long offset;
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 07dbb1e82847..de41f590c98d 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -21,6 +21,9 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/pid.h>
+#include <linux/sched/signal.h>
+#include <linux/security.h>
 
 #include <linux/uaccess.h>
 
@@ -35,6 +38,146 @@ int is_hibernate_resume_dev(dev_t dev)
 	return hibernation_available() && snapshot_state.dev == dev;
 }
 
+bool hibernate_snapshot_write_active(dev_t dev)
+{
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+	struct snapshot_data *data = &snapshot_state;
+
+	return data->encryption_required && data->mode == O_RDONLY &&
+		data->ready && data->dev == dev &&
+		snapshot_encryption_enabled(data);
+#else
+	return false;
+#endif
+}
+
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+static bool snapshot_encrypted_output_owned(struct snapshot_data *data, dev_t dev)
+{
+	return hibernate_snapshot_write_active(dev) &&
+		data->owner_tgid == task_tgid(current);
+}
+
+static bool snapshot_header_write_range(struct snapshot_data *data,
+					loff_t pos, size_t count)
+{
+	loff_t header_offset = data->swap_header_offset;
+	loff_t offset;
+
+	if (pos < header_offset)
+		return false;
+
+	offset = pos - header_offset;
+	return offset < PAGE_SIZE && count <= PAGE_SIZE - offset;
+}
+
+static u64 snapshot_swap_write_budget(struct snapshot_data *data)
+{
+	if (data->crypt_swap_allocated > U64_MAX >> PAGE_SHIFT)
+		return 0;
+
+	return data->crypt_swap_allocated << PAGE_SHIFT;
+}
+
+static void snapshot_reset_swap_write_state(struct snapshot_data *data,
+					    bool reset_allocation)
+{
+	spin_lock(&data->crypt_lock);
+	if (reset_allocation)
+		data->crypt_swap_allocated = 0;
+	data->crypt_swap_reserved = 0;
+	data->crypt_header_reserved = 0;
+	spin_unlock(&data->crypt_lock);
+}
+#endif
+
+enum hibernate_snapshot_write
+hibernate_snapshot_write_begin(dev_t dev, loff_t pos, size_t count)
+{
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+	struct snapshot_data *data = &snapshot_state;
+	enum hibernate_snapshot_write type = HIBERNATE_SNAPSHOT_WRITE_NONE;
+	bool image_range_allocated;
+	u64 swap_budget;
+
+	if (!count || !snapshot_encrypted_output_owned(data, dev))
+		return HIBERNATE_SNAPSHOT_WRITE_NONE;
+
+	mutex_lock(&system_transition_mutex);
+
+	if (!snapshot_encrypted_output_owned(data, dev))
+		goto unlock;
+
+	image_range_allocated = swsusp_swap_range_allocated(data->swap, pos, count);
+
+	spin_lock(&data->crypt_lock);
+	swap_budget = snapshot_swap_write_budget(data);
+	if (snapshot_header_write_range(data, pos, count) &&
+	    data->crypt_header_reserved <= PAGE_SIZE &&
+	    PAGE_SIZE - data->crypt_header_reserved >= count) {
+		data->crypt_header_reserved += count;
+		type = HIBERNATE_SNAPSHOT_WRITE_HEADER;
+	} else if (image_range_allocated &&
+		   swap_budget >= data->crypt_swap_reserved &&
+		   swap_budget - data->crypt_swap_reserved >= count) {
+		data->crypt_swap_reserved += count;
+		type = HIBERNATE_SNAPSHOT_WRITE_IMAGE;
+	}
+	spin_unlock(&data->crypt_lock);
+
+	if (type == HIBERNATE_SNAPSHOT_WRITE_NONE)
+		goto unlock;
+
+	return type;
+
+unlock:
+	mutex_unlock(&system_transition_mutex);
+	return HIBERNATE_SNAPSHOT_WRITE_NONE;
+#else
+	return HIBERNATE_SNAPSHOT_WRITE_NONE;
+#endif
+}
+
+void hibernate_snapshot_write_end(enum hibernate_snapshot_write type,
+				  size_t reserved, ssize_t written)
+{
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+	struct snapshot_data *data = &snapshot_state;
+	u64 *reserved_total;
+	size_t unused;
+
+	if (type == HIBERNATE_SNAPSHOT_WRITE_NONE)
+		return;
+	if (!reserved)
+		goto unlock;
+
+	if (type == HIBERNATE_SNAPSHOT_WRITE_HEADER)
+		unused = reserved;
+	else if (written <= 0)
+		unused = reserved;
+	else if (written < reserved)
+		unused = reserved - written;
+	else
+		goto unlock;
+
+	reserved_total = type == HIBERNATE_SNAPSHOT_WRITE_HEADER ?
+		&data->crypt_header_reserved : &data->crypt_swap_reserved;
+
+	spin_lock(&data->crypt_lock);
+	*reserved_total -= min_t(u64, *reserved_total, unused);
+	spin_unlock(&data->crypt_lock);
+
+unlock:
+	mutex_unlock(&system_transition_mutex);
+#endif
+}
+
+static bool snapshot_encryption_required(struct snapshot_data *data)
+{
+	data->encryption_required = security_locked_down(LOCKDOWN_HIBERNATION);
+	return data->encryption_required;
+}
+
 static int snapshot_open(struct inode *inode, struct file *filp)
 {
 	struct snapshot_data *data;
@@ -60,6 +203,14 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	data = &snapshot_state;
 	filp->private_data = data;
 	memset(&data->handle, 0, sizeof(struct snapshot_handle));
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+	spin_lock_init(&data->crypt_lock);
+	data->crypt_swap_allocated = 0;
+	data->crypt_swap_reserved = 0;
+	data->crypt_header_reserved = 0;
+	data->swap_header_offset = 0;
+	data->owner_tgid = NULL;
+#endif
 	if ((filp->f_flags & O_ACCMODE) == O_RDONLY) {
 		/* Hibernating.  The image device should be accessible. */
 		data->swap = pin_hibernation_swap_type(swsusp_resume_device, 0);
@@ -90,6 +241,11 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	data->ready = false;
 	data->platform_support = false;
 	data->dev = 0;
+	data->encryption_required = snapshot_encryption_required(data);
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+	if (!error)
+		data->owner_tgid = get_task_pid(current, PIDTYPE_TGID);
+#endif
 
  unlock:
 	unlock_system_sleep(sleep_flags);
@@ -107,6 +263,10 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	swsusp_free();
 	data = filp->private_data;
 	data->dev = 0;
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+	put_pid(data->owner_tgid);
+	data->owner_tgid = NULL;
+#endif
 	free_all_swap_pages(data->swap);
 	unpin_hibernation_swap_type(data->swap);
 	if (data->frozen) {
@@ -141,6 +301,11 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 		res = -ENODATA;
 		goto unlock;
 	}
+	if (snapshot_encryption_required(data) &&
+	    !snapshot_encryption_enabled(data)) {
+		res = -EPERM;
+		goto unlock;
+	}
 
 	if (snapshot_encryption_enabled(data)) {
 		res = snapshot_read_encrypted(data, buf, count, offp);
@@ -183,6 +348,12 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 
 	data = filp->private_data;
 
+	if (snapshot_encryption_required(data) &&
+	    !snapshot_encryption_enabled(data)) {
+		res = -EPERM;
+		goto unlock;
+	}
+
 	if (snapshot_encryption_enabled(data)) {
 		res = snapshot_write_encrypted(data, buf, count, offp);
 		goto unlock;
@@ -255,6 +426,9 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 	if (data->swap < 0)
 		return swdev ? -ENODEV : -EINVAL;
 	data->dev = swdev;
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+	data->swap_header_offset = (loff_t)offset << PAGE_SHIFT;
+#endif
 	return 0;
 }
 
@@ -321,6 +495,11 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+		if (snapshot_encryption_required(data) &&
+		    !snapshot_encryption_enabled(data)) {
+			error = -EPERM;
+			break;
+		}
 		pm_restore_gfp_mask();
 		error = hibernation_snapshot(data->platform_support);
 		if (!error) {
@@ -331,6 +510,11 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_ATOMIC_RESTORE:
+		if (snapshot_encryption_required(data) &&
+		    !snapshot_encryption_enabled(data)) {
+			error = -EPERM;
+			break;
+		}
 		if (snapshot_encryption_enabled(data)) {
 			error = snapshot_finalize_decrypted_image(data);
 			if (error)
@@ -356,6 +540,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		memset(&data->handle, 0, sizeof(struct snapshot_handle));
 		data->ready = false;
 		snapshot_teardown_encryption(data);
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+		snapshot_reset_swap_write_state(data, false);
+#endif
 		/*
 		 * It is necessary to thaw kernel threads here, because
 		 * SNAPSHOT_CREATE_IMAGE may be invoked directly after
@@ -398,6 +585,13 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		if (offset) {
 			offset <<= PAGE_SHIFT;
 			error = put_user(offset, (loff_t __user *)arg);
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+			if (!error) {
+				spin_lock(&data->crypt_lock);
+				data->crypt_swap_allocated++;
+				spin_unlock(&data->crypt_lock);
+			}
+#endif
 		} else {
 			error = -ENOSPC;
 		}
@@ -409,6 +603,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			break;
 		}
 		free_all_swap_pages(data->swap);
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+		snapshot_reset_swap_write_state(data, true);
+#endif
 		break;
 
 	case SNAPSHOT_S2RAM:
@@ -416,6 +613,11 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+		if (snapshot_encryption_required(data) &&
+		    !snapshot_encryption_enabled(data)) {
+			error = -EPERM;
+			break;
+		}
 		/*
 		 * Tasks are frozen and the notifiers have been called with
 		 * PM_HIBERNATION_PREPARE
@@ -429,6 +631,11 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_POWER_OFF:
+		if (snapshot_encryption_required(data) &&
+		    !snapshot_encryption_enabled(data)) {
+			error = -EPERM;
+			break;
+		}
 		if (data->platform_support)
 			error = hibernation_platform_enter();
 		break;
@@ -442,6 +649,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = snapshot_get_encryption_key(data, (void __user *)arg);
 		else
 			error = snapshot_set_encryption_key(data, (void __user *)arg);
+#if defined(CONFIG_ENCRYPTED_HIBERNATION)
+		if (!error)
+			snapshot_reset_swap_write_state(data, false);
+#endif
 		break;
 
 	case SNAPSHOT_SET_USER_KEY:
diff --git a/kernel/power/user.h b/kernel/power/user.h
index b0c20e5d5ee9..0e1e123e3230 100644
--- a/kernel/power/user.h
+++ b/kernel/power/user.h
@@ -5,10 +5,13 @@
 
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
+#include <linux/spinlock.h>
 #include <linux/suspend_ioctls.h>
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 
+struct pid;
+
 #define SNAPSHOT_ENCRYPTION_KEY_SIZE AES_KEYSIZE_128
 #define SNAPSHOT_AUTH_TAG_SIZE 16
 
@@ -23,6 +26,7 @@ struct snapshot_data {
 	bool ready;
 	bool platform_support;
 	bool free_bitmaps;
+	bool encryption_required;
 	dev_t dev;
 
 #if defined(CONFIG_ENCRYPTED_HIBERNATION)
@@ -42,6 +46,13 @@ struct snapshot_data {
 	bool user_key_valid;
 	u64 meta_size;
 	u64 crypt_meta_size;
+	/* Protect the swap allocation and block-write reservations. */
+	spinlock_t crypt_lock;
+	u64 crypt_swap_allocated;
+	u64 crypt_swap_reserved;
+	u64 crypt_header_reserved;
+	loff_t swap_header_offset;
+	struct pid *owner_tgid;
 #endif
 
 };
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 601979b97f95..ebddf954ad84 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2379,6 +2379,31 @@ sector_t swapdev_block(int type, pgoff_t offset)
 	return se->start_block + (offset - se->start_page);
 }
 
+int swapdev_block_to_extent(int type, sector_t block, pgoff_t *offset,
+			    pgoff_t *nr_pages)
+{
+	struct swap_info_struct *si = swap_type_to_info(type);
+	struct swap_extent *se;
+	struct rb_node *rb;
+
+	if (!si || !(si->flags & SWP_WRITEOK))
+		return -ENODEV;
+
+	for (rb = rb_first(&si->swap_extent_root); rb; rb = rb_next(rb)) {
+		se = rb_entry(rb, struct swap_extent, rb_node);
+		if (block >= se->start_block &&
+		    block - se->start_block < se->nr_pages) {
+			pgoff_t page = block - se->start_block;
+
+			*offset = se->start_page + page;
+			*nr_pages = se->nr_pages - page;
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
 /*
  * Return either the total number of swap pages of given type, or the number
  * of free pages of that type (depending on @free)

