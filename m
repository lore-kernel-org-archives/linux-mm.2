Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C200EEE6B73
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 03:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66656B0005; Mon,  9 Feb 2026 22:51:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13F16B0088; Mon,  9 Feb 2026 22:51:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13D46B0089; Mon,  9 Feb 2026 22:51:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90DB96B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:51:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AF1B1A0343
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:51:43 +0000 (UTC)
X-FDA: 84427172886.09.DBC0D1B
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A92D180005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:51:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PDlu0e8L;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770695501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oWBrWovJfp5dTcCCQ+5p+inQe0fMxZzVyOmIoUXcNY4=;
	b=8fw9f4Q2Hso8u/RnLDjcQWzXH7GVmjV8+iMacT8rQkL+KKBhjP25xsPykjf6/w1xRlD0o8
	NURGZy+4LHO8bqkej+P8Wz1IdTUhtEFr1xqEDk9Koe3Dz3mSs8kFgfk81wR3bZy8C8CAUt
	vms5uAGNtRd4OlYTP0ilB9QcR7mcj7s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PDlu0e8L;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770695501; a=rsa-sha256;
	cv=none;
	b=qDFOeqT0F1IqXeA84BbcLV3HBaTGrh1TeAuU38eRnLk3xpZuPvqAzAulbQF1iRlCy63n7C
	R5dzM9fEEomLJFvRSKcKK4gM2hrI/plZwmVpT9wiqWFaTPB7cGBTTI43sLlyJ1bbwlh2I+
	+avpTIgpgMiWCGHvGLg3nf3p+joZ0Sg=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso2398924a12.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 19:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770695500; x=1771300300; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oWBrWovJfp5dTcCCQ+5p+inQe0fMxZzVyOmIoUXcNY4=;
        b=PDlu0e8LGogkuSwt7In0l3HI1gbol+OCTVj68rJDp/ZsQiRitl8Lof/o2y+A+2n3Lc
         SBh1XZCz04kMWah/4FW5GgzZtmO/mGGQ5OLxJFzRRrCJpkIs+ofiRYkyhk6mgUx6Uki2
         IsIJZSfTtnCRtRUYpDFMlmH3dRBCPZe7zY/EQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770695500; x=1771300300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWBrWovJfp5dTcCCQ+5p+inQe0fMxZzVyOmIoUXcNY4=;
        b=V+4NO8QmhaC+f70ho1re+fHKqvz/vN0uo+RbesDjgaWH/05pNbwN0G6xK34xjWNJFJ
         JKaiqCTTIEPikTajhkWF1CdnI9aM13Jwv3SdXF5NNRcI62aEBEOhMMKCOTlknfkQnYcO
         EKLY6mxnNcdhPRZy69c/mydZTP38Q6jj3FFKKgHD0XHeF1N/lz3OD+6Bd5RnJreFhqqM
         XZzpk58Umd8Jf5kjwfALA2MG2iS26mP7eKnPCcJlJ5hWeA8TpnIeIQtt2DCRzPOKOlte
         zkEErGScDfUd1O5/qtZDpPI9PRLQshWOy69nSpp6I63X1AY3fHTCqGWEeEM4BAK6k0ds
         y9Dw==
X-Forwarded-Encrypted: i=1; AJvYcCUnfsgMJ7VqIbGHFbVHtsafLD39yGjpZiuzprQ6EtDCR7Y4vM6keBPCTNmFqHOY7mLgvNCY81oapQ==@kvack.org
X-Gm-Message-State: AOJu0Yyf7fjAyugNo1KtOO7F5PCLww4XbZMSlJJiDpMRprVhYXWptYAM
	RuqcgSo++t8RHmDAov88xl/kJWAtynaTXHCBBVY/Ilpzf1HShjgKbpLjJpH5oFQ2Dw==
X-Gm-Gg: AZuq6aJGdM55FpxZlZ9OrB/4PFr4kmXcvdnh6xNnjvQrKnfA6rCG4P5bPEF+PgoCYr8
	QLZPg3sfuokNo4kM5NDcCy8agCYtLBJx/9ptV+AovtcOUsVKQudvQ6Qy030xWRu3f0aP/7lnaZa
	vzhS2/Ee+YAYPJd+SSaauiLF4U7h20+rVyL7WEQ5bJIpMLO0MfHt3J8EtUH+a0JBGvJkjsGklHh
	p63c5fFhusS2iKtqVMXSh4mDl7gvPhU2nbTaNQdZ5Zt338VKOc+NXROV3eGx0FJt3SKZXzM49/N
	T5Z1RtVCKYrZHRHRCIEU4sTjN+boV+Dzxwo2Y6bkasCpmKAzcUQJLoHW/ATE0aPLObFwGznLcf1
	/tGuyZymqS9fmuu+ZG+IvPFuxvDXLdZj6lEqQVYmLdz72su5g9YDU3Ot3eLKRBwLAEVKtyYAAB0
	G8M3OqAZ5SQueVg5hRol3ut+0EBWk3YgzjTZ+sG4dSaQgUGrMyAIfnOvo+5RM18hqYOoZTyUyBA
	V4eJhzKYDk=
X-Received: by 2002:a17:902:d48a:b0:2a7:51b3:859c with SMTP id d9443c01a7336-2a9519b5a9fmr127587185ad.57.1770695500190;
        Mon, 09 Feb 2026 19:51:40 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:3f6:92b2:887b:120])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aadeb4d345sm65979895ad.54.2026.02.09.19.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 19:51:39 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Richard Chang <richardycc@google.com>,
	David Stevens <stevensd@google.com>
Subject: [PATCH] zram: drop slot trylock and miss_free
Date: Tue, 10 Feb 2026 12:50:37 +0900
Message-ID: <20260210035045.3817297-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: or79ugpduutewjpga86f8e6f65rk1i5b
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A92D180005
X-HE-Tag: 1770695501-7846
X-HE-Meta: U2FsdGVkX198bJueSipq1bufvRcaQgMTKCMSjCg5A4QygQOPWJe375qk9OeFpdfFCO5Z773ExgjHAEIprAULdfue4KCI0z9G5aPC9iNr9lEsf2rvVzB8OFj4cCY6fZ7wu8l986PyK1OYW4DZCQRd6uiGxODdzBLamfy3f7TvZVr3UJ+byyX5d8J5qj1r0EFN7ulE40tA1LaXypTvpEp3c9qHzySHW7qCxrGtf+Bq6/YQZh0dCCv78VRGLv+j5ee1Ydg/kAdHqPF7w/CkFTiRCgtwO+t3RJpXUzWNrx3qtVLN8Aku1II1L4RodezErfQgmiflBMNkGAB/FjGW2fHKdu4q4kHQ01vzCU1yqHSdNfi9uyKEXXgrN/AJ+8X1Jm0E78t+7nlcNZXx8CRWZ8wCQkBSuFO49j1DrnUBc75ixFo+cWvNXE5a7+o36hQNrfpwajvTiAr9mo2Rv7fMlzS6w7pxY5qKOn4Dn1+yV+131+c30ElgUYy7g6iBaUOYEwA6LJfkaRR/yGpRHT3wLp1QFrPVy1/tvv3VFErfi3ZyZcv1nAeEulyRK0on85OSaZgSb0sOMlRSumhzPp6NVWpdHk72KE9ppZ4tUJHtRnZI2s1fog0xw2F/b6tGB17VyJW+g5uNG3KsamOgLJ81VN/WNtIurgb9Pt+IOAbqhVeF3SDS84/HMqHS7nNNztO2F9HevgHbHeOKT+F8JPYbVgs+30i3Kzv9spb3vBxYKJi6p3TAhsXnxbyW9us2PlISdAO+aPo8pWA2Qa9apMKItsFLlN9+oiyYWBAFoI6cP/HYkWChkYUqVNF7KynKoYKdrQcARpwQ3rFRQBIiNFFEi/5NBwjNBl9KojGcU/NGd/mmPmb10LjQDjv9MFTkOn2miUgX8FxGclU6QP6XweBB+2BC+nrk9t9xIMe1/WrbYaaKMO+i7JjHb536KHqJDcb5/L7m8Qxlbfzp9JziQQcRTxA
 2KjFO88D
 NriQORBWjNeqFN8msbeHDgdoreiTe4WXbf5RXHLBO5OMrMB8AIVhbLr5iWlsRkAWxlfyw6+b393EULv57mnzE2bbJ8C16Wz1jW2XvKiaZ71qTDBIocXixWQOqfLvvWoIHe58cvzCRy6wmYwF30+NbQFHM/4AgGEogZDccWLg82IF4HC9hAympSc4VsYGmY2rJW/wsgXB7JPuQSdGqGRoWPhSPz38pdQzIJErqfM/qGrmcTTgdGrm4IT/giMD7NsehONeNOT2yPeSFfw5linTTfrl/tix2pmyBcdY82fMsTDIN9jdTT43+AsvN5yK/NM0vB67mR0sDhvnlpoudM8Msgxbxxb682W3EDx1KxBlKLBcWJ1Qs9ZKyYgGEoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e914d8f00391 ("mm: fix unexpected zeroed page
mapping with zram swap") removed swap_slot_free_notify()
calls from end_io callbacks.  This means that there is
no more slot_free_notify() from IRQ context and hence
slot-free cannot deadlock on slot lock any more.  Drop
slot trylock.

Suggested-by: Richard Chang <richardycc@google.com>
Suggested-by: David Stevens <stevensd@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 34 +++-------------------------------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 61d3e2c74901..c2894023c0cd 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -74,23 +74,7 @@ static void slot_lock_init(struct zram *zram, u32 index)
  * 2) lock() function can sleep waiting for the lock
  *
  * 3) Lock owner can sleep
- *
- * 4) Use TRY lock variant when in atomic context
- *    - must check return value and handle locking failers
  */
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
@@ -1943,15 +1927,9 @@ static ssize_t debug_stat_show(struct device *dev,
 {
 	int version = 1;
 	struct zram *zram = dev_to_zram(dev);
-	ssize_t ret;
 
 	guard(rwsem_read)(&zram->dev_lock);
-	ret = sysfs_emit(buf,
-			"version: %d\n0 %8llu\n",
-			version,
-			(u64)atomic64_read(&zram->stats.miss_free));
-
-	return ret;
+	return sysfs_emit(buf, "version: %d\n0 0\n", version);
 }
 
 static void zram_meta_free(struct zram *zram, u64 disksize)
@@ -2814,16 +2792,10 @@ static void zram_submit_bio(struct bio *bio)
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
-	struct zram *zram;
-
-	zram = bdev->bd_disk->private_data;
+	struct zram *zram = bdev->bd_disk->private_data;
 
 	atomic64_inc(&zram->stats.notify_free);
-	if (!slot_trylock(zram, index)) {
-		atomic64_inc(&zram->stats.miss_free);
-		return;
-	}
-
+	slot_lock(zram, index);
 	slot_free(zram, index);
 	slot_unlock(zram, index);
 }
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 515a72d9c06f..d90d9b6c9575 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -87,7 +87,6 @@ struct zram_stats {
 	atomic64_t huge_pages_since;	/* no. of huge pages since zram set up */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
-	atomic64_t miss_free;		/* no. of missed free */
 #ifdef	CONFIG_ZRAM_WRITEBACK
 	atomic64_t bd_count;		/* no. of pages in backing device */
 	atomic64_t bd_reads;		/* no. of reads from backing device */
-- 
2.53.0.239.g8d8fc8a987-goog


