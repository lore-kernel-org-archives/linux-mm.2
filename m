Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEA44CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 15:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314A16B0093; Sun, 14 Jun 2026 11:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C53D6B0095; Sun, 14 Jun 2026 11:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DBD06B0096; Sun, 14 Jun 2026 11:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 061F66B0093
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 11:35:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C04A8140737
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 15:35:57 +0000 (UTC)
X-FDA: 84878918754.05.A11E998
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id C0AACC0009
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 15:35:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OBsutjTs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of wujianyue000@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781451355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/lxpqFHcXjSmMEFitPcCUnaBZzEe91eCd6YU/69bl8=;
	b=w0+aDv1LbpA07zE18TKPfRFc4yOqYjoIhVW7j6UHiGXRbqEsyh62dcOvKjXzktjX0dxjuG
	Wcypa3nBhLd+87MfnkLIKAL8vIFLHPLbSLky4jCMNRc6bJbeN2/fH2NmA+CZGFcEjM0Rr9
	6QzuTqIwjg/NERkLBEgFosNQnPOxdVo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OBsutjTs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of wujianyue000@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781451355;
	b=Gur/g+jw7kR1lR2rCiQURVrdUJ7DcTcPaI+6NLZwMg++ezhVMiMeARkITgMSqV+L255igL
	Sq8otNxQaWbegGPCPPwYwZoY/5g7bizbVBzzVLq+VQVm+mXlmfK/WZY1BBRyyelpMEkeMd
	tPU8CO/C2zMIi9J52qB8hCgOniH73Ns=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3075ce9c05aso6206708eec.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781451355; x=1782056155; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a/lxpqFHcXjSmMEFitPcCUnaBZzEe91eCd6YU/69bl8=;
        b=OBsutjTsyBE1aEWY+zhWEgFxI/ypMSGd9QlNha5dZZB992i/e+coOFSV1BdlzL88bi
         wrYzkZZWakNiTBofgGftUGI0uLMZRfEynkakDpmxr4PVmipIauAw697+Bu03NU8uGQMP
         e9jkS5L2RRAj1kTpBPpL2yFUJ1dgtvb96Eglq8k6hJwNe6cXbCgRopCmk9hVMz2vey3O
         F0pj8ayNBOyTM5fel7emlTgDmYOm6PthXKzJMqP4d81DhPmRlH+X+ClDfth8I0HprdaH
         FI2Fyucvib9VePlk6D9EDteilg0O05VZtOznPHZEjIb700BDlLhXAuW8jjmPlAkoro9k
         4svA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781451355; x=1782056155;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=a/lxpqFHcXjSmMEFitPcCUnaBZzEe91eCd6YU/69bl8=;
        b=Byi2vHHFVliVUc3Ut6j/24SbDBuqsZiNXknVvt/yu0j10heXXfGdw67/Bg2fhvGU7b
         +kPtJDvtcWUIJVXHTAh3c7xJ31N3sfDtZUuNRukYLGYo1JwKbzPfi7rgH5KVLpCHsVvH
         4aFgK4eAUdamagYR/3W+y2sU4wDmA+NoFMEFiNGmElbEcUR2MqW9sFMdhVKuWB1cpPGT
         iHBv4rOn3iZhbH0EH5rzSRKSHfKE2wYMcZhy6guC7HuigWsrj4+BvHl82FGrxM00ZPrC
         iDiGaKgpSAxLGclJIDnWUp1UlqcnL2UV9IfjX7JghU3vjtvMNZ4lGHPh4TPfxo3zIRED
         JWRQ==
X-Forwarded-Encrypted: i=1; AFNElJ+H8ChwM+L+hGb4n5U7lzUXD0YVKBW+TONwwSOetH3iuv6KLkxf2o7Pj1QzGujtW+nJu7QIMcw17g==@kvack.org
X-Gm-Message-State: AOJu0YyO8+kjGyLLG6KuNiILgxbXFAclvtMDzW3eVq+JOQaQ7I6EeFsX
	NRCarA+fB4ffQ2fn5FOtnga0oOymcL73uV/TJ50RZXkquEXJqLXQLkgT
X-Gm-Gg: Acq92OH0k0aZjTptj2Ai7h76i+5y3TzfjqEaTeeuxHDMKrigd4PSaebPhSgJUntr+WV
	+4Fb/QHmv6AjlwsGbCqlxHUCAA1dSPkpcniQdFmCjLOURCwRnA8Ev0YZ+STIH7eecYa0Ae6i99+
	G5L65emYchW7Rox4CkOH9T3uU2fMXpaSz5M5ZpQQ0VMK1h1w4BIjuR5HQ65Ouo2AiSGoGRrKhUF
	7wqrBMiA2cV+BRoeG1EIKD7sj6T6Vfi+5is/zLQOxftFu/HbqOpDgIm20CHofQjbCQSeNjDrPpu
	0zn0Y1tSc4j3U7sZ+ZHcIZoImClZV2ABE7Cw+meHKG8n1AWglUhKs1JvtAPtqRSGIR7iAu39pYe
	v4yw/6KnSRUAq+jqqy2m3Fdg2j+uzpPYX9uU0ZTT3TrYpWJLCWQgHvGr84KcdHhXa1Fu6RWXwY2
	T8+XSwMymgD/gfCjidcGoUE58fUrkNu1HtAN4kDXIIhMlaRXnRhhb9rYqoT6rVQB8kn1bqybUCp
	A==
X-Received: by 2002:a05:693c:42d1:b0:30b:5571:b412 with SMTP id 5a478bee46e88-30b5571ba3emr2033018eec.5.1781451354593;
        Sun, 14 Jun 2026 08:35:54 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e5d0849sm12580632eec.7.2026.06.14.08.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 08:35:54 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 14 Jun 2026 23:35:31 +0800
Subject: [PATCH 3/3] mm/swap: route slot free notifications through
 swap_ops
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260614-zram-swap-ops-block-register-v1-3-6c1a6639c222@gmail.com>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
In-Reply-To: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>, 
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1781451334; l=8570;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=US4ZiUEXSeqi1DqGlIK6guwPu2vW+Htiyg+pB7+1WIk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJxbc8ZmmOMj7C6hmGDwJCnn35hWaMfWfIUsCO6R2sn9DbHTHbqqbvfKYYh9aaFZPf8vr87ppKP
 2ptsA6pliaAw=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: a3a6bnuitxwe7uih84ps3cakccbrea4u
X-Rspamd-Queue-Id: C0AACC0009
X-HE-Tag: 1781451355-179720
X-HE-Meta: U2FsdGVkX1/4aHyICL36Q9g4Tvd0c54OXvWXdGFbbq0dGsQiRADwObQ7fIwzN1kgZbFvQUny2WWV+B6VgQx3ph1wKj3lqVtL0HQm2up6l1i4sO4umBVvwX89Txs9RrxS2AdxQZU/rg+egr+WADjrSLSAdN6tHy+Kwm+PML4SnGfxkdzKdGsMxwCOC5y9J+3MAAYMJ3CK9JWc+Da5aB30sy9o/vZQF+36/iUDaCQF/ei6+Cn91cZZcwjWUTq2cMvBItKCUIOzZyQ6VUctLOOvpEzuzpTNZ4sSoctO93cWGNmjixkjj1IJctO225MUZb+NR7GcU4IAIqmR1x5CWEH4m6g5M4xg4Iy78xmrh01rLbthcdkeTWRAoPLNCOkw/VA63hStn+KqcnHmGS+JtrRubz8f9LZxOoXq4K3dGe4Y6LHmaOTuN6sbavTMTpfrVHMzdNIHN8YDHdF5r0/lEu747yAWagFugFES8p7BHvxY5J7CIL4u7Ghw717zW1ckergcguFA2r01LiXJEsm4VFyw5e34HcL6MUOUVM/l+pcRMFPdqwgENQRjOiIgwrwqbSC6QbJoaYdwjuiVG1cusXWhppkw6UTNiSeU2BE5DoaQYMGmT7ubeGEd3M7iixNftCAlLwFbuVwEXcrHg90cck1n4F7hhvI9bHuV5AS3qw7QRgX9d8h631OA5sXzqh+TR+ihLQiOvMiySrivyvpO7DE4F6zr+hlRnFSXHxEH4KJjoRhwAu6twHXpMAGjCjtz4g+714rge06tUzH3x06H65vDJ9a8E/iewvpUPesENKWMEYzdhIW4pbSELKIhrQymgU9mmQyXcPh3H4Pck5ZeM/aeJPMoCKc7yDDCjHjo5PaQzbZ388NJzrry7QU56nMEDaADfv9mWeZz4TTwsWxqcJT+8VifjhWDHAfDZi3eOzxmRVS53QZI/S5qPuaaAaG5s0xyFG05HbOy+786jA02SUr
 4Xd3y4kA
 iSR8kSS6aH4DbQRZ/E47z81ARWHm12W5GSuFn9Wulh3W80ZTvkSAlJdO/vBIMR97+ffPI9TiE+qMZFaNUT+13barbppoHm2mooC7XzTUenhQHjruN1w8XTCrx1fw82H/bGdTbd1tyWRazvuULccI4/T59AgTTBdh+v5GNPGc28wwtzZQuXMkTlS7wD2Ds97dsepGGKibQfyxEHb8z55VWNsl7GhM6AB0hbCiJzZ3g3LuMFUNivrj3lqrmMdFIRo5+9Q6cd/fncofy3S4GIlZMsSsI0zBXmZr0MFcQipQsxQyOk6FMGCuAH8PnftdNY8EsE0Rx6k8jTvsLM/4fToXHgNBUdS+pwK+367McH3Wq6cW1t+AOJ55murhGMULD45Sl3qZ60QvxDb5ctvfJAOucmxDhklyy0HkQrG6wKm+tQBXoBhKavE/5/bgoKk3mQQCx5Y6QXietIR/qYzpJCI59mBAKRWqgHNarOUluoRQFdcUJcUcZtlPgsWG8bOrBhHIh3pzmDK8Fb65x4PBu6KoeEZmAEUwAGpAS81MSE/UOnkk1YC7fXgm0ZiUxzvAS21v3TsEK0r7XvUgsx1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dispatch slot_free_notify through swap_ops instead of
block_device_operations. Zram keeps slot-free handling alongside its
other swap_ops methods.

Move slot_trylock into the CONFIG_SWAP block. With CONFIG_SWAP=n it
has no callers and the build fails on -Werror=unused-function.

Document the callback locking rules in include/linux/swap.h. Remove
the outdated locking.rst note for swap_slot_free_notify.

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 Documentation/filesystems/locking.rst |  5 --
 drivers/block/zram/zram_drv.c         | 88 ++++++++++++++++++-----------------
 include/linux/blkdev.h                |  2 -
 include/linux/swap.h                  |  7 +++
 mm/swapfile.c                         | 13 ++----
 rust/kernel/block/mq/gen_disk.rs      |  1 -
 6 files changed, 57 insertions(+), 59 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 70481bdc031d..964c841bf917 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -443,7 +443,6 @@ prototypes::
 				unsigned long *);
 	void (*unlock_native_capacity) (struct gendisk *);
 	int (*getgeo)(struct gendisk *, struct hd_geometry *);
-	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 
 locking rules:
 
@@ -457,12 +456,8 @@ compat_ioctl:		no
 direct_access:		no
 unlock_native_capacity:	no
 getgeo:			no
-swap_slot_free_notify:	no	(see below)
 ======================= ===================
 
-swap_slot_free_notify is called with swap_lock and sometimes the page lock
-held.
-
 
 file_operations
 ===============
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9b2bd0287402..b78246dc1746 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -72,31 +72,6 @@ static void slot_lock_init(struct zram *zram, u32 index)
 			 &__key, 0);
 }
 
-/*
- * entry locking rules:
- *
- * 1) Lock is exclusive
- *
- * 2) lock() function can sleep waiting for the lock
- *
- * 3) Lock owner can sleep
- *
- * 4) Use TRY lock variant when in atomic context
- *    - must check return value and handle locking failers
- */
-static __must_check bool slot_trylock(struct zram *zram, u32 index)
-{
-	unsigned long *lock = &zram->table[index].__lock;
-
-	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
-		mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
-		lock_acquired(slot_dep_map(zram, index), _RET_IP_);
-		return true;
-	}
-
-	return false;
-}
-
 static void slot_lock(struct zram *zram, u32 index)
 {
 	unsigned long *lock = &zram->table[index].__lock;
@@ -2798,23 +2773,6 @@ static void zram_submit_bio(struct bio *bio)
 	}
 }
 
-static void zram_slot_free_notify(struct block_device *bdev,
-				unsigned long index)
-{
-	struct zram *zram;
-
-	zram = bdev->bd_disk->private_data;
-
-	atomic64_inc(&zram->stats.notify_free);
-	if (!slot_trylock(zram, index)) {
-		atomic64_inc(&zram->stats.miss_free);
-		return;
-	}
-
-	slot_free(zram, index);
-	slot_unlock(zram, index);
-}
-
 static void zram_comp_params_reset(struct zram *zram)
 {
 	u32 prio;
@@ -3058,6 +3016,50 @@ static void zram_swap_submit_write(struct swap_io_ctx *ctx)
 	swap_write_end(sio, failed);
 }
 
+/*
+ * entry locking rules:
+ *
+ * 1) Lock is exclusive
+ *
+ * 2) lock() function can sleep waiting for the lock
+ *
+ * 3) Lock owner can sleep
+ *
+ * 4) Use TRY lock variant when in atomic context
+ *    - must check return value and handle locking failers
+ */
+static __must_check bool slot_trylock(struct zram *zram, u32 index)
+{
+	unsigned long *lock = &zram->table[index].__lock;
+
+	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
+		mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
+		lock_acquired(slot_dep_map(zram, index), _RET_IP_);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * swap_range_free() holds the swap cluster lock. Use slot_trylock() so
+ * we never block on a slot that is already locked elsewhere.
+ */
+static void zram_swap_slot_free_notify(struct swap_info_struct *sis,
+				       unsigned long index)
+{
+	struct zram *zram = sis->bdev->bd_disk->private_data;
+
+	atomic64_inc(&zram->stats.notify_free);
+	if (!slot_trylock(zram, index)) {
+		atomic64_inc(&zram->stats.miss_free);
+		return;
+	}
+
+	slot_free(zram, index);
+	slot_unlock(zram, index);
+}
+
 /*
  * No ->can_merge: block rules exist to grow bios on contiguous sectors and
  * matching blkcg.  zram already batches through swap_iocb, and
@@ -3068,6 +3070,7 @@ static void zram_swap_submit_write(struct swap_io_ctx *ctx)
 static const struct swap_ops zram_swap_ops = {
 	.submit_read		= zram_swap_submit_read,
 	.submit_write		= zram_swap_submit_write,
+	.slot_free_notify	= zram_swap_slot_free_notify,
 };
 
 #endif /* CONFIG_SWAP */
@@ -3075,7 +3078,6 @@ static const struct swap_ops zram_swap_ops = {
 static const struct block_device_operations zram_devops = {
 	.open = zram_open,
 	.submit_bio = zram_submit_bio,
-	.swap_slot_free_notify = zram_slot_free_notify,
 	.owner = THIS_MODULE
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 890128cdea1c..f861ceed39eb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1669,8 +1669,6 @@ struct block_device_operations {
 	int (*getgeo)(struct gendisk *, struct hd_geometry *);
 	int (*set_read_only)(struct block_device *bdev, bool ro);
 	void (*free_disk)(struct gendisk *disk);
-	/* this callback is with swap_lock and sometimes page table lock held */
-	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	int (*report_zones)(struct gendisk *, sector_t sector,
 			    unsigned int nr_zones,
 			    struct blk_report_zones_args *args);
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 70bf6f3f04dc..09640eb5a45d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -40,6 +40,11 @@ struct swap_io_ctx {
  *             the iocb is full or the plug is flushed.
  * @submit_write: flush the accumulated write ctx to the backend.
  * @submit_read: flush the accumulated read ctx to the backend.
+ * @slot_free_notify: optional callback invoked when a swap slot
+ *                    becomes free. swap_range_free() calls it with the
+ *                    swap cluster lock held. The folio lock may also be
+ *                    held on swap-cache teardown paths. Must not sleep
+ *                    or block.
  */
 struct swap_ops {
 	unsigned int		flags;
@@ -49,6 +54,8 @@ struct swap_ops {
 					     size_t prev_folio_size, int rw);
 	void			(*submit_write)(struct swap_io_ctx *ctx);
 	void			(*submit_read)(struct swap_io_ctx *ctx);
+	void			(*slot_free_notify)(struct swap_info_struct *sis,
+						    unsigned long offset);
 };
 
 int swap_register_block_ops(const struct block_device_operations *fops,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ebdc96092961..79a4166fb9bf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1311,21 +1311,18 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
 	unsigned long end = offset + nr_entries - 1;
-	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
+	void (*slot_free_notify)(struct swap_info_struct *sis,
+				 unsigned long offset);
 	unsigned int i;
 
 	for (i = 0; i < nr_entries; i++)
 		zswap_invalidate(swp_entry(si->type, offset + i));
 
-	if (si->flags & SWP_BLKDEV)
-		swap_slot_free_notify =
-			si->bdev->bd_disk->fops->swap_slot_free_notify;
-	else
-		swap_slot_free_notify = NULL;
+	slot_free_notify = si->ops->slot_free_notify;
 	while (offset <= end) {
 		arch_swap_invalidate_page(si->type, offset);
-		if (swap_slot_free_notify)
-			swap_slot_free_notify(si->bdev, offset);
+		if (slot_free_notify)
+			slot_free_notify(si, offset);
 		offset++;
 	}
 
diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 912cb805caf5..25552d69f711 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -135,7 +135,6 @@ pub fn build<T: Operations>(
             unlock_native_capacity: None,
             getgeo: None,
             set_read_only: None,
-            swap_slot_free_notify: None,
             report_zones: None,
             devnode: None,
             alternative_gpt_sector: None,

-- 
2.43.0


