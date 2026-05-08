Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC5BCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB386B00FA; Fri,  8 May 2026 02:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2776B00FC; Fri,  8 May 2026 02:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7846B00FD; Fri,  8 May 2026 02:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97CB86B00FA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:08:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B9D640581
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:47 +0000 (UTC)
X-FDA: 84743223894.13.BCFC8EB
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CB1540008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SSkCIvA8;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778220525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yZbCZTgQWjeOZMMSiccr5Z+zvHQMRYXTy9f6X1ybwU=;
	b=HatUiDQRpx7+ZM5zLxqbcVipibIinGkJhZ4Y9t6LzLBGOr03cAQBCOlqxdtkvIZ0uiYYMu
	teE6cPRS+hytZhMDn8Es27RTTS1ny946XeCLaCKlRHaC3C9IgZIeZJMQdSVoDzTt9K4Jc5
	4Jamt3vx0IQhHSsBIIP2dvKpbY+qwFs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SSkCIvA8;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778220525; a=rsa-sha256;
	cv=none;
	b=H7LqKXc9S8ThxWw+nt3M/eQrDCUGdZ9OdUsl/7FApIXvUstGJhqll4k9QoZtZfmEApAn8U
	C5l94sjCR4+3aYccLl2nxEx7DPQSk8+cbUrfGw19UO6fwimTkjefjYTihOh4XKLSQPYWB4
	0WeYm7+TUTVlMg3HHN0oCmtVajKzt6g=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-365212191f6so1201522a91.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778220524; x=1778825324; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+yZbCZTgQWjeOZMMSiccr5Z+zvHQMRYXTy9f6X1ybwU=;
        b=SSkCIvA8LfBZ9MieYny+jOMI/hv6Q86uZ0pcpl+5DgjntbbVFjNuvIMdrQZpJNuF7K
         7W5iJ261tj0h/siOUPBfO8el2P2Pbg66+D0etwPjlNouaYvmAtjmkkEfuYh8TjkSJjka
         wvaeaPpnYkpb8N+/5YEsccVER4Rn/keeRM8FdWVETmTdfcobb/+XF8U+Ut7YAOu9UKjp
         7vCm+CnG5Zy/MLZp/p93vwPY5K9vEadegsDc+qyCM32Ogtt1ns5AnnPOhLo+40z02zMg
         akmqMXIo44n6Z/Ly8nNWZIJwD/xxWOzJqWz4eu3cXG18leQBnBA1Ucvu/eb9ZrX9koFf
         pMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778220524; x=1778825324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+yZbCZTgQWjeOZMMSiccr5Z+zvHQMRYXTy9f6X1ybwU=;
        b=Qg+ac57jkaFNb52Q2VEnsEJq7nffqwclEOFKIms5C3PlTkzuBECg3eFMzPeiToCt/S
         qDOyFZdRlholGwqWUrEHBff8vAmy8ZpClHqGzJcJSHoGl8xbi6UgMOIDEM6jw10a6/94
         Ra6RR37S+tZZVX9oncSQC44Fhxllr/sZ9gW9oZoZvDZwDQmr5i8o37XHPrUSSb3r04Gg
         iP1GoeaejqOj7+ZQ/oQqmdf2FupD0sw3p2PjL/eNbTj75uSWufWfOOEx0d7xugfsQxzu
         4nDzVa6WHdBhM8i5UbxXoeJzALvksxtPqEzVF++DnVd3PSh5Q6igkO85pHEv6NTGBQaK
         3oTg==
X-Forwarded-Encrypted: i=1; AFNElJ8yJkfyWItJgTxB86mdJbv0juK1lok8nX8YjO8COBlLv+mHuY2PFcPfQ+7wGlCWxOcCUS9RpTl1yg==@kvack.org
X-Gm-Message-State: AOJu0YzDEKaXAAX0oB6iPKCSPLVPLa2Mzcnezmd8K3xphfxtfkAGJ08s
	lARBC+uPdSPlwzQEEG/3hyiYp4ijXyEBpXHo+v5v/0cv9c2MBMPh9KmFp7G5yAVR
X-Gm-Gg: Acq92OEeGFu/5W41XRn63S+EyuZhekVzvDiya3Z0ZGShSFE7+cGsaJuIW3vvPWaiWUo
	Qp0BbZWEqOKagXUcqchdO7KEFwemB/ixpHI7rerHLPtGu4Z7UpWoUMvX9ZEHuKU79YARug1bdTO
	WgQb5UlVNol1QSw6pzrlS8N2PenwjJLXJT28yQtiqm+KQ9+7OisAso4+KBHMzxIusXMvoQPAt0l
	D7BWn2AwS6mWbWI+n9OeusUiViPlMToHvzgJbkdbHGxhmXK103k8J6LFIr2pBVTcvQAYOKLIKao
	7SPvB3NjUpj829nwoKEqheaMqDZSgjbOfvV5uAWjsUI1FjctPOReIRz8Kr/fXb9gGKxGElCbXR4
	FrZE5rQW3LOAoCz8Ax+ItbgbU9lsMcMgRRjSWkiyTJJeOUkW50x8zpkK7TnD7YaKU7l1goTc1CB
	XmxI8TKW6Y9uvPITkxdMdrveXj7cUlU1qZAIv8pJjPkezudTxX
X-Received: by 2002:a17:90b:3d0b:b0:35b:952c:43b9 with SMTP id 98e67ed59e1d1-365abcf0698mr11808706a91.10.1778220524197;
        Thu, 07 May 2026 23:08:44 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36645bb9c02sm673651a91.1.2026.05.07.23.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:08:43 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <21cnbao@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v3 3/4] zram: use zsmalloc deferred free callback for async slot free
Date: Fri,  8 May 2026 14:07:23 +0800
Message-Id: <20260508060724.3810904-4-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260508060724.3810904-1-haowenchao@xiaomi.com>
References: <20260508060724.3810904-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CB1540008
X-Stat-Signature: 66krzn3y1xangm4np3icfgp51ipon6b4
X-HE-Tag: 1778220525-223741
X-HE-Meta: U2FsdGVkX1/3jRtiRzz1olkbUzuK+dyKNZc/ozoIvMIN3lz6L2cqm9RgqnldTsOYRHKdCgED+mV1fKVMZdwojPY87dzjxs96djx//tdxLKNYZNB3IsDDy82Ia9H7d+4vX9JKHfJh6Lk5joDVD/5s8xpQECDyf1VypPoK5UHxQ7BjCZJgkNcsocAI97AItW5euPIKKfonAzijQvQRDDvgz7LGXSG8UPpi8BY1OmFBiQcxdsXHxfFpNvqjAZ8xLMDMfO/I3pWHqquXbdZyula4SS3OVVdC2ZUnJlmRLJggZJshuAnb5ChwuZNAUdhoW2egkzk2pHyjOVcsWFaTwQ2mPNaaQS6yn3m4HUzRZ5fkQw0lXo6ZRBxCIsbtpbnXh+D8FohjWE/+mxa+tC/BH/ulJXR4vMSu2U7OeEOvzhyLWzTA/3ZvjlKU2vCYpU3BBOotd63WJ9V4mpb86KuDdmrPbqisimroXWr0ZBmBRkJxN4doXSdh0wdqlv8EGNvloXyqL38tdJXa3rpWh2mj9SO0CCG91QEVeW68ypWXezYhCqJziy04Pm4t3GuZC4Wesq39b27n8ViwXDGL3ytjcRFB2HSXlVVlgwTAW7gL9ilTUhBK62RkRUdvXZS3bQsBSYhkE50tLZk8QSVz65ZY0SpFj6rHeBs5gKYxWOt2jTG2roLI0vVi/aJE0nY7QCDiMbSOF3lzFBOj+Y6Dp68iBdpVbZefIecSi93y/Kp3mjAcXz/qMKnA4pwAtGtpCFlPMz24GLPuiTf5ZxPWJsjF/HgdblrQEprksl3mXVjAqtt2471A5Xccm3nAIOrgdbHMpLHJifv5zTd3mH4Fe+ke18ICN+2IgyoXRRoV+oncQpXbnVj0wvkse1G1TdddpN5TvujfvIELCjxK8YNU9MKmuLuU163SSypGp6kvyi0JpF448B4xlH8ANmS+Ng2UcfUwwHwvrhTPWzR+EYCfWSADQ0c
 X20bjBzb
 Xe0ynGCordGh6MZXIFsSTxDx+VJ3uk5IWgc+qbKL5J8tcgY/tiacHtgaap5rqbPId5Tb5DpZ3cLLyFHkmAefoPGZncEB34ubo1IRO56qi/c5dyY+BldsggSzClNeA4dA1374p9+HkFRIyg/H/UbJLcJWH3aHp7Odc2gTNNYqNlh3sPyvW0hpkzq6cjecKbTWFxP3B4ShUcQeEkeJhX3n0HkNTILL3MIax004CCvJncT7TYmmaMLe7XsGogQRZDU8273zwtslMXTcFL010o262q3JC+7VA9/54IsenrsmKYR9frUV1ahacWZuKFTBqj8eWiGnE/a+0C1xf0Je6OxjnM739VfrXj695g1dkkmC4oSi65zPGfNE6mdzra4MSmwMtVD18ZTwsAltYyE+MMa7pJMo+vf9ORKn9uMv0qhooeh05Ywmyf9TFIoh2DbBerj3XqYcHeEATEack55p9kAbi6Qn4gxtdLYdVeHJGDsDb8cgIZfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <baohua@kernel.org>

Register zram_deferred_ops with zs_pool_enable_deferred_free() to
defer slot freeing to a WQ_UNBOUND worker. The notify hot path only
stores a u32 slot index into the per-cpu buffer (1024 entries/page).

The drain callback does slot_lock + slot_free + slot_unlock for each
index. On deferred failure (no free page), fallback to synchronous
slot_lock + slot_free + slot_unlock.

Signed-off-by: Barry Song <baohua@kernel.org>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 drivers/block/zram/zram_drv.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aebc710f0d6a..0d07f0901e55 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -56,6 +56,7 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void slot_free(struct zram *zram, u32 index);
+static const struct zs_deferred_ops zram_deferred_ops;
 #define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
 static void slot_lock_init(struct zram *zram, u32 index)
@@ -1994,6 +1995,8 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 	if (!huge_class_size)
 		huge_class_size = zs_huge_class_size(zram->mem_pool);
 
+	zs_pool_enable_deferred_free(zram->mem_pool, &zram_deferred_ops, zram);
+
 	for (index = 0; index < num_pages; index++)
 		slot_lock_init(zram, index);
 
@@ -2784,6 +2787,39 @@ static void zram_submit_bio(struct bio *bio)
 	}
 }
 
+static enum zs_push_ret zram_deferred_push(void *buf,
+		unsigned int count, unsigned long value)
+{
+	u32 *indices = buf;
+
+	if (count >= PAGE_SIZE / sizeof(u32))
+		return ZS_PUSH_FULL;
+	indices[count] = (u32)value;
+	if (count + 1 >= PAGE_SIZE / sizeof(u32))
+		return ZS_PUSH_FULL_QUEUED;
+	return ZS_PUSH_OK;
+}
+
+static void zram_deferred_drain(void *private, void *buf, unsigned int count)
+{
+	struct zram *zram = private;
+	u32 *indices = buf;
+	unsigned int i;
+
+	for (i = 0; i < count; i++) {
+		u32 index = indices[i];
+
+		slot_lock(zram, index);
+		slot_free(zram, index);
+		slot_unlock(zram, index);
+	}
+}
+
+static const struct zs_deferred_ops zram_deferred_ops = {
+	.push = zram_deferred_push,
+	.drain = zram_deferred_drain,
+};
+
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
@@ -2792,6 +2828,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	zram = bdev->bd_disk->private_data;
 
 	atomic64_inc(&zram->stats.notify_free);
+	if (zs_free_deferred(zram->mem_pool, (unsigned long)index))
+		return;
+
 	if (!slot_trylock(zram, index)) {
 		atomic64_inc(&zram->stats.miss_free);
 		return;
-- 
2.34.1


