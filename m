Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48FBD116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86CD66B0030; Fri, 28 Nov 2025 12:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844926B0031; Fri, 28 Nov 2025 12:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A6A6B0062; Fri, 28 Nov 2025 12:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EABA6B0030
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:05:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F39D131FEE
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:05:21 +0000 (UTC)
X-FDA: 84160641642.02.CE419D3
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4554040018
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:05:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M0ovdjZ+;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764349519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4R9Zx2dBq+xNldpFByBb2oFsVP5vQZDFMwFExGQQ4E=;
	b=8cwGX3wu92jRKx7uVuqFJXHNgEKqx7ZLr3nVHwmIzCgsxK8Rv1bTHsjuSp7mEvy5pKoQzN
	UvnfiRSL9K6B24gqWbNu4jFLCnTtiAWahexW/q+s5GiggAtY2DEUtXid9DSPZrT7aEUP/C
	TF9x9gtmozSmqV+flVRikWXPt4OAIPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764349519; a=rsa-sha256;
	cv=none;
	b=fk6Zd6L9cuvp3XJYjgEDZhRXYrBzXZVhrwTBbarLh5mfeCAi8DYzdoMjOdCQlwGzhyin2u
	Pu7ttsakiY96lT23KxapiNdYtwkndbzcMcvi0aqG0H3FTQPQ87AFC1JeziRZ1FVJR76G95
	FVAjtxZZ+8GIRcZxvoBJqm9xG8a4oxw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M0ovdjZ+;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so1897105b3a.3
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764349518; x=1764954318; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4R9Zx2dBq+xNldpFByBb2oFsVP5vQZDFMwFExGQQ4E=;
        b=M0ovdjZ+SsP1/NjOfyRxLparwyX8pUd1Otb4SnKktozDWPOc+4KWbRvHKzw4AJierF
         R3P/rEqcxAaJ+h0Yw6mjsxm2cVKltJ1UdaHaZEOC4fLht3RcKAlIRbpo7+yQIWkweiF0
         EnnpCm0/S2/pYVr5HagPhjq93NujA6OeNHdGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764349518; x=1764954318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v4R9Zx2dBq+xNldpFByBb2oFsVP5vQZDFMwFExGQQ4E=;
        b=CY02XuqyY3bU2fuVXCray/+QlWAOeqocMiz/S4eoqBZ8SZQwHTHNGr5ROhIFFzySe7
         JHxF8pLkrOrBznQ9Xi17Z2TmtRoeymDqlgE/2lvDWSBJPa8rx1PdY33dL9W1fJ+4U8Sl
         RGypbSzk2L3KRVaHCRZ8002+7O/aS2QqzbdxRjLDjXIKWClWZ5Uhvhtvmh+BJzRQSFgp
         VUWD1mqJw2MOLsPZzR1ihRtJ3wP9RVCGxtHyktzXq5+axGNj3i5g3qUI0YBuc/9ucUJF
         q+0MGDSrQWDZdAsJ+rDqjKkDMfdcBHqngLHlossHwoyROc+MqfSFwYcZIAZEkJhPvGYg
         AtWw==
X-Forwarded-Encrypted: i=1; AJvYcCVY/+BE5RWISurAj11pTWWSJVHlg5Lmn/KjzrDoqcNYyAHJw8SBgio9VuQz7edN/Kz2TGA7jddCFQ==@kvack.org
X-Gm-Message-State: AOJu0YyeD3R7v2yWWnBOkjw1byfl+f94eQ3RIi5szUI9D9aPWt0M6t9z
	wkw+NCDJswEn20FROncHwwgU9Q2zP434LWzfeERMaa7lyzB9HlIzMBcZznoC+/+orw==
X-Gm-Gg: ASbGnctaD+56QI+/C8fRJE44L4IV69N8FGjjPPukp2x4AsSvp+W8xdBGlJxuumaCmK2
	/mOg0WYqf96+C4hNhnqCQyYb72BZVsZIk7CCvs/f7E38xzOfbcYiArxq6j62TP0iZDXz3R5/9tf
	fgxZsNpwVRkcX5eqTreq13ndb+j4aMF42M/IiHm0FWSwIQI1kcErKlkJPFk4bffkMDDkqG3sJov
	rWdJnQ30nuODHDRUaqgvg9liux/6IivVGuuHNx6TDAPaJw/cMv7yJOx1a7yDy6LEQ7pvGOP4rC5
	L7xtLz2vwYTWRmZghHivhn3G2V0tR8vimk39aCGR2LJBfjib3EhiD/c8K7RqtEDZ+zDdHMbJl4P
	Savj4VuaeDw12HTz/Gtxrb4y3sim3qlY/ecfVujLNy6SYPr3b8q1x/n9YUV44hOvNJVK8CPnL4r
	teZpHl/Gn0Hay0ha4bJiKi9nGcSRZ8ZnEzZPKXJ8bPyhfVps8bpyG1zCwp2vvV1Mv3rqTqmsRsl
	gqy8XRDJDac
X-Google-Smtp-Source: AGHT+IGdVsnWm7yn6FnlL/WMYyZNJHjQgbCSuAYTrw9LhC4iG3CiNM48M8ucj2AnGiKhtxjrJAli3g==
X-Received: by 2002:a05:6a00:2d9b:b0:7a9:e786:bdaf with SMTP id d2e1a72fcca58-7ca879f2d5emr17491122b3a.14.1764349517859;
        Fri, 28 Nov 2025 09:05:17 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:5b9f:6c7b:4d09:6126])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d150c5e611sm5568242b3a.6.2025.11.28.09.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:05:17 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/2] zram: rename zram_free_page()
Date: Sat, 29 Nov 2025 02:04:42 +0900
Message-ID: <20251128170442.2988502-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251128170442.2988502-1-senozhatsky@chromium.org>
References: <20251128170442.2988502-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4554040018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: nk9nz97jrzxqz1estzwatcgbjda9n3b4
X-HE-Tag: 1764349519-711367
X-HE-Meta: U2FsdGVkX1/t+SheaQgps6hGLtolCgW8W32Bx4wjVhod5LZyF18ROjAqUXKQesorSZx6x4zPJ7Au9paCZSiokkPj6WqTsGC7ELDPfgc6Jx7YEgAtso/0jXaaI3KfM/J+wYFNlKCU1WqVlAQB2JLlaeJz/Jao+WR9Kqf4btStVPSQ0ZyatmJHsfvPoWqfp/9oYkg0N6m+CYT6PgjVP7Joqx1qZXJGRI0kSie0jLxrgibnO0KVgD5QDqD7nPTe9yCNMKUAKJBIzqVu3EcLPNWsGYFCwbUFWZazEKfRgvJRGXumSH3OJ0bTw7bAYLNUGdX8WM0+ipcJYtmkeLzSXx+PpYKQsTTM+4ESie7VLUddAj3F3QIZILro+o5Oz/CaEXzPm/GubuJomDM6NSVYXxT8SOaLwlVjRV1W8ktmhq8d6uLbuRY5fl36lWYWMgvkTiWTJOVVGU+BwUm6SnD1VOWNinyNeTSQElKYYjmZuURM3F89+CSBmV1VBvyCkqBH9oqqPOb51JHsUe0a0MazDGc7HmsPe9R2s3W2qiPW+NfWb6mHuFfPlCGho4Tesb/y/2OhiGXhOexkCD82UKRNm0gZjfLqxCLp74IOHnrd3PYXJkxkpKt/srBk+LNzUyRneKTCMJV7h/Y6YCOU7wdpGiuY5sGo5sSbkVgTi8u0qaFS9Zw80ngISRuKT6noShjlStRW/WVWM5tO8iZNhwcf2r/+zZVGPqKD2/d15vfWcqLvtlwyiMKIJPoJk+gAxjiz+PkVIrf+XxKNCQdSGunMYsAjpbBzcC9twuAofKqeQpPHMt9IaBvOsfO35JTulLb98V0UGTyded0bsf8RFBcbsqTA9EzusVJL2msz8/1IwrRRKdvX8yASivE8aMw5j0MoUt7a1x6RTfwCYUFBFLAY2i+Pnh3b9mFrZdT7EGO97f2B2Y3m/hWG7h2UWiEWKb/khqLDi7vR4s+w1jUk/6d3Mzu
 2CDdzoI0
 q4PNMyXGw2ELp/LTm8SM4bgnxRvsIARs2R/s6M9gd9Dc/9sXjbp0cmJXha1muSVJUvGhYA1Twqk+KuPyC4CvPo6E4LsJ2EGfOxsNyMAIuIkjkd5Vio5u2kqXuV12qg/Eq5jwyCtOyHCH5vv2ZA0OnArzlTwNkC3sC9TH7PKfEAkJaR3dUCdLfKPI54LhKwagZrZjK6uqRPMw2jOZbI055wLVojMXKx6k5kj450bJBtU+uL0UWGqflNhis0T3xcn+RbZCd5HjTQlesGqaqAR3bA+sMD65znfxSLDKtlPWPGpVSivKc8y/oSDaep6yCWoKr7L7e5lJRtMwWDF5Ggc+dU07v5CVca7NX36sWKN0x3sYgD7igtqxWfwYub7zfzd2QF5nH
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
index eef6c0a675b5..d8054b3cafaa 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -56,7 +56,7 @@ static size_t huge_class_size;
 
 static const struct block_device_operations zram_devops;
 
-static void zram_free_page(struct zram *zram, size_t index);
+static void zram_slot_free(struct zram *zram, u32 index);
 static int zram_read_from_zspool_raw(struct zram *zram, struct page *page,
 				     u32 index);
 
@@ -927,7 +927,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	prio = zram_get_priority(zram, index);
 	huge = zram_test_flag(zram, index, ZRAM_HUGE);
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_WB);
 	if (huge)
 		zram_set_flag(zram, index, ZRAM_HUGE);
@@ -1966,7 +1966,7 @@ static void zram_meta_free(struct zram *zram, u64 disksize)
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
-		zram_free_page(zram, index);
+		zram_slot_free(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
@@ -1998,7 +1998,7 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 	return true;
 }
 
-static void zram_free_page(struct zram *zram, size_t index)
+static void zram_slot_free(struct zram *zram, u32 index)
 {
 	unsigned long handle;
 
@@ -2197,7 +2197,7 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 				  u32 index)
 {
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_SAME);
 	zram_set_handle(zram, index, fill);
 	zram_slot_unlock(zram, index);
@@ -2235,7 +2235,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	kunmap_local(src);
 
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_HUGE);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, PAGE_SIZE);
@@ -2300,7 +2300,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	zcomp_stream_put(zstrm);
 
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
@@ -2522,7 +2522,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
 	zcomp_stream_put(zstrm);
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_handle(zram, index, handle_new);
 	zram_set_obj_size(zram, index, comp_len_new);
 	zram_set_priority(zram, index, prio);
@@ -2725,7 +2725,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 
 	while (n >= PAGE_SIZE) {
 		zram_slot_lock(zram, index);
-		zram_free_page(zram, index);
+		zram_slot_free(zram, index);
 		zram_slot_unlock(zram, index);
 		atomic64_inc(&zram->stats.notify_free);
 		index++;
@@ -2833,7 +2833,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 		return;
 	}
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_slot_unlock(zram, index);
 }
 
-- 
2.52.0.487.g5c8c507ade-goog


