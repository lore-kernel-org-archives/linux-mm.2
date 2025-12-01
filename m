Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 372FDD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB2E6B0099; Mon,  1 Dec 2025 04:48:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D6B6B009D; Mon,  1 Dec 2025 04:48:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776176B009E; Mon,  1 Dec 2025 04:48:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60F606B0099
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:48:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AA1BC0B41
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:22 +0000 (UTC)
X-FDA: 84170426844.14.F1F620E
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3302B4000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=T0qYCHzc;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=906KZFo6t+2ci7ZTeYqhBL02BUrFYEeLcrZCiOSXlDQ=;
	b=jopaY45971PIGtXVvIbqfuAJPsz9WluG2blN/m1pkaqBdoCaFJe9isxVuOyH2SLa0LAG7p
	yFLylAUqYcwPEpRmM28DV4UqjfJvs8riDk5DVxuom7bxTQgX+i6LUWed9In2sQjPb6pAWi
	XVf0jqTvF5J5yC2neAMd0QFsl++ZW5E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=T0qYCHzc;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582500; a=rsa-sha256;
	cv=none;
	b=PR9Gm6dvJetDyvTGPhiVi4zZphQxajBMZxah2Wvqj18eMjhlvo/+c5AOaffUHgXRZHK7zz
	cGNV+kZUxJSzTBVjhS+m+SzjeuCbR4cJT9ovutueJeRUNlVcSyW33t9gb0ND97DTgK89eu
	yXZVlVjqTL/8pXY0dy4tm8Vgn7pN08U=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7a9cdf62d31so5029687b3a.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764582499; x=1765187299; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=906KZFo6t+2ci7ZTeYqhBL02BUrFYEeLcrZCiOSXlDQ=;
        b=T0qYCHzcaAJWqKSX6+M3fcj8KvLvUiYJWauGSavjO8usQO2SRNS9Fj+kKR7ZwjImy4
         /76KTJpVVWd4H8OgQpAKsZWCoV6puh8GMhZPf56ZeOuYAEEVP/pZ6PUgTB8FVVg/XReE
         2C8ldYvGU5GDc0lJFuYdEFNS13xpiUypTBGwE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764582499; x=1765187299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=906KZFo6t+2ci7ZTeYqhBL02BUrFYEeLcrZCiOSXlDQ=;
        b=W0JUZ2B5Sm2cUwVVrhpf+p/w/ytUACVP9hiEoJl7UbzRR79fsUKK1UORpLysh52sKD
         m7knT8ZXBQW6IC65TxfD8zrDOln67X5u0zgHiAXviRaqTo47Zf9PnZ6gxW/MPYTYVIVq
         I3V5jzq+cQ2hbrODvfuDp9Rx/+5cPEarD6oooAoAnnbSOAaLLUivquOkoXi5Exn0Y0O5
         beZ21sfaCtQhLQl+opGW9C6OqEA0+Nj3XHFaiJQQ81MU3nt4nOVnGX9hjUnyfWIoIytz
         xjCPylOZ7h44WVjOaQ2QbQmKlmxom7QPwv7SbJ2MNfBV/0KzQ6up9d6sROf56J4OP6OK
         87iw==
X-Forwarded-Encrypted: i=1; AJvYcCVolJ+BY5vH/FgsR4Els3nxq9fqpqE266GiOx36LW/41RfzC9peq3xqlXD0US3PG42arnD4o/y6DA==@kvack.org
X-Gm-Message-State: AOJu0YxPXSRdZuGm0aDT0YPc6SyRjPqKxAk8BsSZXcZz4kZNmFskGayj
	OGUi1Eryn0dAGnYMhU+yg5F7X3Bf+o5GsZFLne/ezsbVBvf5SR9utdlgKlRNpwxe1A==
X-Gm-Gg: ASbGncsmg1LXsi8zwJmSIrKqbLtzms0IvKcUJcPeR2I9SxKFpR7rk6x3+c5CGMjDxyd
	TtXl7NpeixzKcHQDGMn85LkvGDr98FMLzTICjo1udToD/dXI+J7yG6hXdLoSZ8+CI5gfOgoZKqJ
	hcvZwQLuEDm+FTtWsz/LuaslwE6yhdrddnOqQ+pYyXEcACCpiv2W9sNFDO23UwRBXo1mVFDzdlX
	Zo3tz8py3ZSF6lbSLDaoEhVEkyS/XgOazp9nkn/pZiQyau3UdC/JuNx55iv3HNa9+tQ9Ag1z6aK
	m009Jiic/J9JBW2nkh2sDdvwzJyJt3QCSI+UVFqDSbR6GM00cAzLq2wtuo6isHvbgxzG05OW0gA
	ADX3TbfbHQiHLRoJ/nZrndVTNcr2TZ4a3Q3KWJJViedW8KIs5LVhTlO6j294i/WKJqXo1t2PZB0
	y5D8OAgFczSzzManMaNuYyW9ad77x8dFzEf7IKMq1BILIx8yiIb4K9rF7fSVAIa50vKGIsd1+zI
	Q==
X-Google-Smtp-Source: AGHT+IG5hlJsokfKmtpNDiN4BN25b26b4ht4eT8qU8v1pYMGVVntb+93khKGuBzf5xFszcfk+RGLmg==
X-Received: by 2002:a05:6a00:9508:b0:7aa:9ca5:da9c with SMTP id d2e1a72fcca58-7c58e50cc8dmr37751171b3a.22.1764582499116;
        Mon, 01 Dec 2025 01:48:19 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db577sm12882074b3a.31.2025.12.01.01.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:48:18 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>,
	Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 5/7] zram: rename zram_free_page()
Date: Mon,  1 Dec 2025 18:47:52 +0900
Message-ID: <20251201094754.4149975-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251201094754.4149975-1-senozhatsky@chromium.org>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3302B4000B
X-Stat-Signature: dy7petkzmukrhwxxx1ngqu7dwnosrbkd
X-Rspam-User: 
X-HE-Tag: 1764582500-72802
X-HE-Meta: U2FsdGVkX18o+Y6PKRku6ot2YUmsy++dG+TLKlfxfl2Np97K/gQyAEPiOihFcryfOGCKrp7P1hX9PTPQe0IaJYyslP2/p0Xgwq0W7NgWedSC+NA3YJTvEYT0R4y86N5HhN0NwcOqqODvpT38nDPd7/nycgVw2oLCUE+MgEqjUMIu+F1CDzu0BptwoElexVfBbA1satvMUVDbHD7B7fMgjZYIqJDVB6NAnTPkXA0Hw8+oyLyIB00ldVo9FvF/VHbeRgBpwxfZZOYS2w0Pa2ajGcRBJZD9zX5SklefZ2byBrJGfIWp9mPPjXbjRu3jOOUv/4tv7WrHI6J9uVV15SjFZtsJUUwRg3gqRhUiaW6MqPsZ1Q+NaIcOAKqptp7Bpx+h8HcM2a/FU/oYv6NGQNuddELo07rHjCzXlOb/6y+6L8GTMseh6HS7w785b21sjLGF9wTPVioknN4ZH1Wd5HMt5wo8MYKQgO1OdSYOuqlVPrv8fCBqX38ZCpibzH+ZuLJGm2ctNFn6dyI8rgPDoA5tkDykkAsbJrtZ/je0zvv76Q283uDEFjMGo0jVpS3Pj5zWHztc+1GLNbnCe9xDrx5zBhpC5Z8HS6nvpma182gyDAFzKy76eFcnBReZBaa8Vbs96LRqN1GfbIx4OyNNQf7jzOg/Dnwma7mHwTPU8G6rJjaVGNsSg7/5Vt3OZDPbZhqDLaq71eJyKneijC/FEVvATccKXpzrgHm07Jp0p3uzo8LhSK+Elfo7VsXCDwmh2vGmLIVliYwzuzLRuhCvPERLWUCCtl82e70TK1B/jydUKCnN/dlJugJ0b1JKcPFM/PQSIhpJveKRHw7sooRWjDc0FAaW4hxeo1FJE7hbxe7K4KDq3yd18aJ6svKI4N7Iu0i6RGNgtpt3kpVioRpZLkWuvUM1JW5atMAfklm1aCuriZSUMwM4BIVThxhTff27+rwBnQdgnpLC9FeU3nzyuBj
 jDobMlif
 TLwj5ElJ1YJIyVVqSZ9U56E/H27JjXfMKlFEPR1F/i5oDvPHeC20hVpfwaRhrSYhPLNMHRzt6Ab6DkxSCPXQ5MB2SUGFJ63dKA+YTVV/8XeN2XS2/kwwhSWT85tNwNjeDtwOkkMubg/yqoFi0j7iohCimE9B8EMWck67ZBnWM2jm0SgY/59S4dUDT4wZfR1IFleoLgQap7HYP7WIbaCvsTiUzR8lLYv1jmKtLs65ZsPAnKjwaZZrkT2nhMB5Daw75QJvgfnpTkgRRj41jRPHAP3Ej5BoHKDYfz2Z6EHBFQQHEGW0KkOF15H9kCjOc9vQACxlp3+rcLWuGBIfuF9Uwl4HChHklNzlqfeXhDa94MNqfmQJobQnqIJVbCdEm+6HK1ig4LD39ogTTQCUZKLPSI7Huy6gLTs8QlGcuZ7sRQLHo7agXrwsVYsKDtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't free page in zram_free_page(), not all slots even
have any memory associated with them (e.g. ZRAM_SAME).  We
free the slot (or reset it), rename the function accordingly.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 1a0f550219b1..615756d5d05d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -56,7 +56,7 @@ static size_t huge_class_size;
 
 static const struct block_device_operations zram_devops;
 
-static void zram_free_page(struct zram *zram, size_t index);
+static void zram_slot_free(struct zram *zram, u32 index);
 #define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
 static void zram_slot_lock_init(struct zram *zram, u32 index)
@@ -984,7 +984,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		huge = zram_test_flag(zram, index, ZRAM_HUGE);
 	}
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_WB);
 	zram_set_handle(zram, index, req->blk_idx);
 
@@ -2025,7 +2025,7 @@ static void zram_meta_free(struct zram *zram, u64 disksize)
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
-		zram_free_page(zram, index);
+		zram_slot_free(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
@@ -2057,7 +2057,7 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 	return true;
 }
 
-static void zram_free_page(struct zram *zram, size_t index)
+static void zram_slot_free(struct zram *zram, u32 index)
 {
 	unsigned long handle;
 
@@ -2256,7 +2256,7 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 				  u32 index)
 {
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_SAME);
 	zram_set_handle(zram, index, fill);
 	zram_slot_unlock(zram, index);
@@ -2294,7 +2294,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	kunmap_local(src);
 
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_HUGE);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, PAGE_SIZE);
@@ -2359,7 +2359,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	zcomp_stream_put(zstrm);
 
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
@@ -2581,7 +2581,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
 	zcomp_stream_put(zstrm);
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_handle(zram, index, handle_new);
 	zram_set_obj_size(zram, index, comp_len_new);
 	zram_set_priority(zram, index, prio);
@@ -2784,7 +2784,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 
 	while (n >= PAGE_SIZE) {
 		zram_slot_lock(zram, index);
-		zram_free_page(zram, index);
+		zram_slot_free(zram, index);
 		zram_slot_unlock(zram, index);
 		atomic64_inc(&zram->stats.notify_free);
 		index++;
@@ -2892,7 +2892,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 		return;
 	}
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_slot_unlock(zram, index);
 }
 
-- 
2.52.0.487.g5c8c507ade-goog


