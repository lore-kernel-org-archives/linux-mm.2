Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58011F8FA6C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF70E6B0092; Tue, 21 Apr 2026 08:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE9F6B0093; Tue, 21 Apr 2026 08:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B606B0095; Tue, 21 Apr 2026 08:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3BAB6B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:16:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 503A013C265
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:48 +0000 (UTC)
X-FDA: 84682461696.09.D60C72F
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6C43740008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k4zyUb3y;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776773806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Eih9BBnnHT00t9rzMlOXMywyDxDk82fhUWxfKmMkyw=;
	b=qR/atwUC9iNxObGg4AdTbv2/epuVZHYp8KukeuTG4vL0qlxho/vmC/e/NyMifnN+L8JF5t
	7+7Bmd7LWr34mxKhR8peUlsMZ28pdUUgX+3LCpb0I2hX6KAs4bFvH2fkJ4y1s6HIwIH0oS
	8ODgiYCNRfxcoxDL82FyBtxo17RO33A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776773806; a=rsa-sha256;
	cv=none;
	b=TmMgUWTwWokg8Wbo3G5QeFb7QTGa1yipxkWaq+WFLc+KzmlVi1Ns5VOAbCvgvgjBHBXGbv
	mz/FUSURaJLFkok9qc1V7THBmf2/CMM5lS5zjiDNbCk7Ho1t9EuHVF3KMDiBbwDI+m9NDz
	/N+7LQ/92rX/bgYQJpRXXqiTiXcAr9M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k4zyUb3y;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8296dabef74so3674907b3a.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776773805; x=1777378605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Eih9BBnnHT00t9rzMlOXMywyDxDk82fhUWxfKmMkyw=;
        b=k4zyUb3yE/o9COvpOBzkn3j/l9heE3pH8o8mtsoyHtW7lmw/OlXbwd2Cf5mZVKvKgV
         6wZV5z8RAB86Zd/0JMIUTuqoYV+JVPV8jputW1x3osOz35vVCz5qnVc3jMaaJSu9bCwP
         hg4smHZJhEJVOY3WF7Ildifvfk+0uKzZj4Lq5R5rKxdii5l0zJHgeJPnoariPSSQo0/m
         DjMCLpzFVajB/GnvU8iA/pwhxfknaaDybw7DyGzy1Col0/uDNy7rjO+uLxNEQHOY/RWI
         vRaroX4aqo27MmU6H/G/aJIH2TD5bs7qqQy/f/lBsodAeofNI1QFYU5my3bpEHHEtvrm
         vUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776773805; x=1777378605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Eih9BBnnHT00t9rzMlOXMywyDxDk82fhUWxfKmMkyw=;
        b=dc01p3H+iFB+FZfeseAhes74ltNO97khaSSkqAfl+0mVfEC7sFkSseeKpGxvMYDBRI
         Zd+dqn5SXPT4uLVQfqxphZggId9iKrygvEAhQinZ2lAPjNQfMXYW95GIjbOfvdAefuHG
         hXq93u1gTf5P/yJIWWRIgiQjKKRiXCMGTPKY9fbFhIMhBPRin16pn3oZ8rU/TfAFQx8X
         3ncWqd3Dok8fcRp553Hg+X8KKDzmebpyss8H+lLLzAJ9Ri/QHjpbuImqnhifIPRzND7P
         iKN1FBeevZtFrNy6rZtR1W0QhERkyHstMXgyEB/uP7sbjkgqeBaLlMcP+Cpb3mYCOyEy
         W2vg==
X-Forwarded-Encrypted: i=1; AFNElJ9YzquJ0rROoGdeNr1FqkHUbIX636b6meN0qIcwbblOI2ypqBWIr2tmE9Lp3agoro/eVqa+KFSfpA==@kvack.org
X-Gm-Message-State: AOJu0YzOGoRatGBAG2TUgsuccC4a2H02T5r9sMlOaiGxXmhp5gOLaTlP
	7IDrg6yb2lNHRA2PI1au2ddlQITcyaYti+r949Zqzy1pX2HHTWBkmu04
X-Gm-Gg: AeBDietMD3qMIFVFsGND3X3pQe6uagKy9yv4B0rUaK3LHZoVHeR8nO5kR9KtdcL9qNI
	6bRLFVLyUqXFmTjLziBqA9FNmKN+gGkqRRSSldHKeUXxQoyDR18p3bw8hnp3AdskJq+bD2jOYbG
	UuxMd5CPLf55MDNn4s3JnhRN28g3evjwEYu/YYnKbtuRSG8OKabkM9VC09ufLGQPN5TJxQj3fjK
	tt9DcwxbXOSAQS//Ts/ZodxQsCeh4U9MunwEOJFkr4/JKUp2MF4oMUR2Ugi8tMHpR03QmDeOhuK
	+OOJT2bWpzRI7VABAnkjgCLpfXjrA2mBeUNzuOrpQGArzvYSr86vC/hBWa4glUlTj29EqhNA32s
	90flZLU8VCGMq/GnDI3INZX4Zy+42WEFxiF2hl7AoGxMs5BdBaZi9K8Z3DIK3TdVGSNSQxeeGHu
	IwO2SL9fjHh/MKzkGymsCCaZuahJgfqOZTl4upttsM6jfIU0U=
X-Received: by 2002:a05:6a00:2d19:b0:82d:5da9:adc9 with SMTP id d2e1a72fcca58-82f8c856e60mr19094536b3a.12.1776773805202;
        Tue, 21 Apr 2026 05:16:45 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec037e1sm16371071b3a.54.2026.04.21.05.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 05:16:44 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 3/4] zram: defer zs_free() in swap slot free notification path
Date: Tue, 21 Apr 2026 20:16:15 +0800
Message-Id: <20260421121616.3298845-4-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260421121616.3298845-1-haowenchao@xiaomi.com>
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C43740008
X-Rspamd-Server: rspam07
X-Stat-Signature: 361m5et5a699n4pkah8dzux3easm5hdw
X-Rspam-User: 
X-HE-Tag: 1776773806-730650
X-HE-Meta: U2FsdGVkX1+H+rydli1TZ9JZLKHAKBv5uiF0llkV1Yuq1Tw78sOgKRxl069xSe/dHxe5gwTZXFnxmMEbno85r4+KxEO+P9rh5VuMQomVfByLlSNyTDd2n7ML4cyiqRbeHlq/Kg3G/WF2hRcaF+M4LpL+N6NkhCMsXx+E3zFY7oMafYbTCijKnpkZ92Bp7g4e6OohnY8QigQQw6qTybK3rOw5XfEfEylVDdutiKzg3xoP4aRcD1w/dJdBeUWlRMksM6FDMosCn63aikI+pF6fVBg1+IjYqk6yUF5ptG9qks9/Zb5/37Hsc5Z6tNsxPxq/ozBAgSsQuddLugmJTb/UQkMkD59h3AEXnYoTvFp8dAT72ePAhmet2YKB4V/DVT96iwjFjMEPC49dtL0wr1IaC+OWEjq/KR5emCFA9OghUFQGfU2hqTpflxSVKXe1XkzXKY7C1lrM99XGAiJP3iePuidiskzIHTxq3cbQDv6710h4dtk5+wtpvS6qzpeG4fp69vs7eutAPvBeds2ZwocZugrKU7QDzdXI/nN1G6co2lEF9JEnWC5VY1rD6f2iPRE29sC0lEQkKkaN5bpqKwFCPL6E7d6xTwah1K2m0wFqoZ9DMC96ci5oth6vqiSTMwVVmPriqiNEBoVOCdyQ823aab+fk8M1MGKJTfSjQ9APih3pnyOTZbrMUo1fSKZtbWefXkheu3iM/9C/9mVUwl3x3Z6obzHfw3TOfccoub/ugJLuHM0CztPZLmqyB62RF38x1IGPFVfFxca2LEBOMf8ptS5+mp+fddIC2OKIQ9AdgoJp3Gc0+9QIBsyPO+uFAOiViIXyb1AycGG/hCybaOVJINgBiaVY7XGowiAH27VcurcNe561exHPcbg+KCXBSKudhEAycMagm9IeoSt1PasbGaSp0Y79uGhxJxTHtwjPgk4/eTz1sEue0ZgV5Th8G/PACTmDfm2bLc1i98tma2/
 nZ/BdLui
 CzF4m3cLMrNbSFiXunY7hTWF5atHL/DMhwOndqmL1+stWK+DfdHRP6cpM4oHtEw0AFL2seJIL8SrRd17p3TW77CXg6MJPNTGI+QYD2JlAt83XrKBFQqdeGHh15VDV1AtWqdIgImmLDySiN7ugzQJLntjo+H6wAzBmjPs8QXJDnecroE60ulJrEdaUSGdbTW400gCtnq+LUXVaCjNgDYeXm0Zgms8xZLrrq98/u3uSP6TGPX0rA0zQWZI1y6gn9t6abVAArZGopqCCg74ggDsyKrnP9MFdi2u2i+7mGDbSXLjRdax0DBAB/8TFcEmQ+SdI03mBvjlB1beOErercQvhH7D4q1wXQ7PNDKEwRQ6lJYNnHzVP3OFaDSyEP7SX7zAZU2jFplLRqWvHWI1PbNQMLZjyq+TvaOBiDVA9TMowxtd2WndfkZZmu0OT/egovxhxHMQb0J9x5J9Sr5bLOlDj0BilkMytuZ+AmFzXtTnc3QSpXRHzFFHeqsqXZrLrCuFkT0CFcltzjHINa9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

zram_slot_free_notify() is called on the process exit path when
unmapping swap entries. The slot_free() it calls internally invokes
zs_free(), which accounts for ~87% of slot_free() cost due to zsmalloc
internal locking (pool->lock, class->lock) and potential zspage freeing.
This blocks the process exit path, delaying overall memory release
during Android low-memory killing.

Split slot_free() into slot_free_extract() and the actual zs_free()
call. slot_free_extract() handles all slot metadata cleanup (clearing
flags, updating stats, zeroing handle/size) and returns the zsmalloc
handle that needs freeing. This separation has two benefits:

1. It makes the two responsibilities of slot_free() explicit: slot
   metadata management (must be done under slot lock) vs zsmalloc
   memory release (can be deferred).

2. It allows zram_slot_free_notify() to use zs_free_deferred() for
   the handle, deferring the expensive zs_free() to a workqueue so
   the exit path can release memory faster.

While at it, merge three separate clear_slot_flag() calls for
ZRAM_IDLE, ZRAM_INCOMPRESSIBLE, and ZRAM_PP_SLOT into a single
bitmask operation via clear_slot_flags_on_free(), reducing redundant
read-modify-write cycles on the same flags word.

All other slot_free() callers (write, discard, meta_free) continue
to use synchronous zs_free() through the unchanged slot_free()
wrapper.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 drivers/block/zram/zram_drv.c | 37 ++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c2afd1c34f4a..382c4dc57c8d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -165,6 +165,15 @@ static inline bool slot_allocated(struct zram *zram, u32 index)
 		test_slot_flag(zram, index, ZRAM_WB);
 }
 
+#define ZRAM_FLAGS_TO_CLEAR_ON_FREE	(BIT(ZRAM_IDLE) | \
+					 BIT(ZRAM_INCOMPRESSIBLE) | \
+					 BIT(ZRAM_PP_SLOT))
+
+static inline void clear_slot_flags_on_free(struct zram *zram, u32 index)
+{
+	zram->table[index].attr.flags &= ~ZRAM_FLAGS_TO_CLEAR_ON_FREE;
+}
+
 static inline void set_slot_comp_priority(struct zram *zram, u32 index,
 					  u32 prio)
 {
@@ -2000,17 +2009,20 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 	return true;
 }
 
-static void slot_free(struct zram *zram, u32 index)
+/*
+ * Clear slot metadata and extract the zsmalloc handle for freeing.
+ * Returns the handle that needs to be freed via zs_free(), or 0 if
+ * no zsmalloc freeing is needed (e.g. same-filled or writeback slots).
+ */
+static unsigned long slot_free_extract(struct zram *zram, u32 index)
 {
-	unsigned long handle;
+	unsigned long handle = 0;
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	zram->table[index].attr.ac_time = 0;
 #endif
 
-	clear_slot_flag(zram, index, ZRAM_IDLE);
-	clear_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
-	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
+	clear_slot_flags_on_free(zram, index);
 	set_slot_comp_priority(zram, index, 0);
 
 	if (test_slot_flag(zram, index, ZRAM_HUGE)) {
@@ -2041,9 +2053,7 @@ static void slot_free(struct zram *zram, u32 index)
 
 	handle = get_slot_handle(zram, index);
 	if (!handle)
-		return;
-
-	zs_free(zram->mem_pool, handle);
+		return 0;
 
 	atomic64_sub(get_slot_size(zram, index),
 		     &zram->stats.compr_data_size);
@@ -2051,6 +2061,15 @@ static void slot_free(struct zram *zram, u32 index)
 	atomic64_dec(&zram->stats.pages_stored);
 	set_slot_handle(zram, index, 0);
 	set_slot_size(zram, index, 0);
+
+	return handle;
+}
+
+static void slot_free(struct zram *zram, u32 index)
+{
+	unsigned long handle = slot_free_extract(zram, index);
+
+	zs_free(zram->mem_pool, handle);
 }
 
 static int read_same_filled_page(struct zram *zram, struct page *page,
@@ -2794,7 +2813,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 		return;
 	}
 
-	slot_free(zram, index);
+	zs_free_deferred(zram->mem_pool, slot_free_extract(zram, index));
 	slot_unlock(zram, index);
 }
 
-- 
2.34.1


