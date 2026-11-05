Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43069606D813
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=JzSODaNy
Received: by kanga.kvack.org (Postfix)
	id 9A8E76B05C0; Wed,  4 Nov 2026 23:48:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B586B05C1; Wed,  4 Nov 2026 23:48:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB976B05C2; Wed,  4 Nov 2026 23:48:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52C4A6B05C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:48:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D79A40948
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:14 +0000 (UTC)
X-FDA: 85399833708.01.6E915BC
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7A1DE140005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=JzSODaNy;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ig3cy4g2u7CXskVAimAX4bU14IYSOF358bPQNQDlMyc=;
	b=3Won0OGKc4TjE2xOv9qGi9rVGChCXuOfCjkKjq/YGzB9wZV41PXJ/W9jwPn1vukIC/yBYC
	eRDiW7nSesXytQwNoBV2kenPoZc0Z9sEq70c8JmNgcKgOPr/dT2w5WhglgBlT0XTJdA5gV
	PJsutowGlBEe87y2Q9e19pJxOimWea4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854092;
	b=XH/4AXBYpWdgewd+VI+kw7qO+6+7ESnIejp6EFjbdGULi+KS7xksQdHg695UOK4vnbvXSM
	IaHvXEcvktrv3Czb44yShm45phn3NcKBkteJabVwngzCV0Q1CKFEXHl2zJwTzYDOIzZACI
	c4nz1LmdP+fhFGngkz/0xXcIpTjo5v8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=JzSODaNy;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso3820051eec.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 20:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854091; x=1794458891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ig3cy4g2u7CXskVAimAX4bU14IYSOF358bPQNQDlMyc=;
        b=JzSODaNyD6qjamcPO4FK2dstbkLd7o01M4aut/Lh3FFMsnnKs7toDqwRW39sVnHDGM
         MW7NQ4DvSGq/+vBFOO1aV5DbmYIs/CIq1/YoGC6TISg8idVHauNbb35DQ+30WDzISN8O
         w+S/N30S0LA6WhWINm6Vb2+acqiJGmvHpP3tY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854091; x=1794458891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ig3cy4g2u7CXskVAimAX4bU14IYSOF358bPQNQDlMyc=;
        b=k7ASScJT2gpftATzBsNd+g0i+5kvgNEVASorHKQWI/aMl4aIjYZ9rzD8BwNIPR7EHH
         g6uLQc6p2WPF4zwoPw04i/0BDhObYtWbrfdzv6pufBMwJzxMxIHieq8Tuks6fDwljFJj
         d5euC2/SS5D3gHIpJ7woe5gRCcwqyOU7dqKIJfPqaho/N3Q2oJcBmoU3BYsxxWr1/LHq
         1T5PI3R3jhfQJkcYiRZ2gySQFN9ctOFc9L1K/XdI7RrOWp14pdHiJXUCv45pCeLgJYoi
         uU1IVeiSXwJTZKu6JfmHQNX/+8WuU4kqroYkKXTAU1tMEn2DpbysxU1lFjqbh3y1rJz7
         nEVA==
X-Forwarded-Encrypted: i=1; AKwUvBzFoXM7hbYbZW2oXFoBluPZfcciguweVWo3Q2JGmUBKEYQ/hqG7gN24+XkhScT/sURbItKrEOdkbg==@kvack.org
X-Gm-Message-State: APuU4Z8brV+1+l9518WKfsKQPHGIS98o3eUwjpVzBlJxyfQZCn/5t54y
	0goDsyqUzR1evY0XopUGsfBwSp68DP0Gr7uw/VPJfHoCu/CGOaWE5UeQ1OOBQoktmA==
X-Gm-Gg: AYBFou0R+komMSSUg5r1HEBOVKXJIX+pHnqTB78sryO3mBA/ygGPkrqo46/3QkwAUUb
	rPOLGwmUJHWi4/oZF+P6lCppUTOYQaaddeV9Rlq7XaPnjVh2xdqjOZexZvE9Ck5Qyds+jQNiCuP
	ldaOTYI1E+cgUmoCkz4WWDqZtEpsptsaFc7izDm/Tf9MWadc6ed8q0kJttQ4L5Y6DI1BbjYdKEp
	wbSLhn3OXSkJI2VoumXSNhcwGfO+ymzSc6Es5Ub9O6H9j2451x9KK/kObQK7SnFYaD+jxyIU5q0
	zZvd199WyQVsCwAvJDZtPnRV+5cwYLkdtz7cnDd7wNYPZp3Ws+eyQSzCrN92CJUHKsu9HQpRiXj
	hl6mQK1nKfd/rSq0HeerZa2SgMMyVVyzBC1dVzoGvzzHHOwIjOiOQ1vLyZKsXInD0CUUuUeau8z
	2ZLcjd/ASRZUH14rcAjfcR4ATy6cQ+mzwLU3IV8cOEfBxHOrowfLvY3rwZPntKWabS4IGfq2QWq
	cx/+vXQGte67DfLmXypqmK9tsG9LiyLGbZC4SYkGJ/nZ9A5U4YjWKfoFqgWHYgxn4yhwyvW4JW7
	KKvK2EOdGa73aamQR+5Dxb34XlPbwHYiV5d4Qu6hDNNx7/CPmshk+USwk5Vd1MbFoyxKLGQwL8h
	WvpAJUPzK7ClsE1edQDnzChOw8egpyoTK3VQ7NLE=
X-Received: by 2002:a05:7022:628a:b0:1ac:1343:fa54 with SMTP id a92af1059eb24-1ac5bbb4863mr35522622c88.14.1793854091285;
        Wed, 04 Nov 2026 20:48:11 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm17142927c88.21.2026.11.04.20.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:48:10 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 4/7] zram: allocate zsmalloc object under slot lock
Date: Thu,  5 Nov 2026 13:47:34 +0900
Message-ID: <20261105044752.1997895-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105044752.1997895-1-senozhatsky@chromium.org>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dw636jyczrocp4a4dobb9731xh55fehh
X-Rspamd-Queue-Id: 7A1DE140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793854092-428867
X-HE-Meta: U2FsdGVkX18Q4BAQEk1xZ7fE0z/S5VkK9+jmuflTV5wscRZlF8oH5XHL2HkZTfYMnaq/kh3qv3dXNyozgIBI39/0LB9y3UB6wBOw/HIEv1x76sM5A/r1KYiB14fQblnlpfM+pDo9FtvuSttgIlxh3kXaNOQpXEmVvqNy2NBwMSkmupG3LeZzqWvFB0wJrIj+E8zxNVn5F913TPGB6As39jyKL8cn+rmYau2VtvSEB4100wkH/zVFA1bxdaWVFhSKz4vrth10gWhjh5hGHlB5TL1Igp+sqVihYStPjnqzdLB70hYtMIEEeMrrHlYBawEUYjhr5l7mjdoXN/VykQ1p1II2kNYPsOCKqDB22ML+kRDUdOspoXVkYkggw8uS3oUZfnU5ysXijVHe445rG0lmCJP5XZWUwls4NGtVyucOQsTZ1TZVZXt/sumj5+OS4P2r/2oaJ9LtjglY8qyhSriHarJVzDAKYZlE+jNVQYTF5rd8/ojeqz88MQvvzclnDZ1MXQUwkLXs8QVpt4V4Ro6okoPupO1VGyMGKiaF4w2vGINVrS7KrQympH5aIU6VJiBkSOF6fnTH4E1PDtBvr3itiijDjU+PPEsXSZZK4gjaIYbvRCekr6hzIzP7VXughFSrUKR9jqqLlwOHFPhcUVLNQOxG51OTNRjrdA23ivCH5e5qf869xrpLirkThZ1iqGOLTexEjvN51XvEtsEFj3CClQDst40XhGqDVfBcJvgDae5OZM/LN5fD8WExV8Y1Nq+FBybIgqiiVA8Dhrwh1od1LsXYN7v4xXHfZbLJCJJw2+zgw7qeSiT4ne6aZa1YgDcLV07bNFF/NWfJX6uzw0MBLoCzxwu55iFetabsiKfqhj3czTtBCr6olPWn6OFPc6/fvzHrij74UmJrXKJX1H3i2HvvTOqNil+hKyRlC0NqkFdRMnA0TwFlOGLTWXJWS6z5EFUOPzzrvrNs5uBl1hP
 oaxGgcng
 1f2zTe/R4xUP2CHY7etY0u+pFcVA6efe/6g5/wk9hpFABYd9/4DI7mYQ84PtBXclQvVTqrIqMIbegU8LOEkYLpQSyBJC6W8Lp+fNIwndMpkzqEE6xI3cDu5OH9o19KgDHWnGlU0NY+q0kMFLMshREGjn7atLF9Veu+P1sQ7bZhw04JsIRLwLBtqiKxrRJODhuTHxHqICT3Nk5XLlshI6+bzB6/0NttfD0/H+XopEx5q+Z+uib4+GpZ8ypri7C0Y92N5wXk5VfJh2sthDwVvDwCFT4mtUtJ/CUXaCn6fQjTaaTO1w0qkQNsXXDBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_write_page() and write_incompressible_page() allocate and
write zsmalloc object first and take slot lock only to free the
old slot data and set the new handle.  The next patch makes
zsmalloc store object location directly in zram table entry, so
we need to free the slot before we allocate a new object for it.

Free the slot and allocate the object under slot lock.
recompress_slot() already allocates objects under it, and
GFP_NOIO reclaim cannot re-enter zram write path.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 2c2e11b2b663..e2710ce35b1f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2260,14 +2260,19 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	struct zs_handle *handle;
 	void *src;
 
+	slot_lock(zram, index);
+	slot_free(zram, index);
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		slot_unlock(zram, index);
 		return PTR_ERR(handle);
+	}
 
 	if (!zram_can_store_page(zram)) {
 		zs_free(zram->mem_pool, handle);
+		slot_unlock(zram, index);
 		return -ENOMEM;
 	}
 
@@ -2275,8 +2280,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
 	kunmap_local(src);
 
-	slot_lock(zram, index);
-	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	zram->table[index].handle = handle;
 	set_slot_size(zram, index, PAGE_SIZE);
@@ -2325,25 +2328,27 @@ static int zram_write_page(struct zram *zram, struct page *page,
 		return write_incompressible_page(zram, page, index);
 	}
 
+	slot_lock(zram, index);
+	slot_free(zram, index);
 	handle = zs_malloc(zram->mem_pool, comp_len,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
 	if (IS_ERR(handle)) {
 		zcomp_cstrm_put(zstrm);
+		slot_unlock(zram, index);
 		return PTR_ERR(handle);
 	}
 
 	if (!zram_can_store_page(zram)) {
 		zcomp_cstrm_put(zstrm);
 		zs_free(zram->mem_pool, handle);
+		slot_unlock(zram, index);
 		return -ENOMEM;
 	}
 
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_cstrm_put(zstrm);
 
-	slot_lock(zram, index);
-	slot_free(zram, index);
 	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
-- 
2.56.0.398.g882cbad275-goog


