Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EC7606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=b7CFKvP1
Received: by kanga.kvack.org (Postfix)
	id 41F616B05BC; Tue, 10 Nov 2026 00:49:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F65C6B05BD; Tue, 10 Nov 2026 00:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE666B05BE; Tue, 10 Nov 2026 00:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F105E6B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7ACD2408E5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:06 +0000 (UTC)
X-FDA: 85418131092.25.45E6217
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 88C2E40009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=b7CFKvP1;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7J8W8iGMlxVtygfltgHoQnyuGwmlkD+WN19PoJbqGw=;
	b=mUcQ/pYaGuTXqX8hJa0UHzTqBP0pke4fgmcY9RSVz87z7CqZdGVheJ9mBcbZCiKt9tCGjO
	Y0oY4CmRfz6sNbX/TI3CnCeRNViIPvFaA23Ubcp8WAP0oIZi5QMmRx7XTogq0tUFcelagN
	ghHMhPpA2jeUfxHQfpSnLtxp8rYFV3M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=b7CFKvP1;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289744;
	b=1C3Z50X/Xveg41FwzqPGi/hDvqVoZtrVMRTEk9cnBFVE9BjERp4iFoKECYfxTfrIxoDAKT
	iUv3yjjMamOHld44tfMImqGTZV86OdJVRC/PiFEQRmdRNHoEI31VQT93bJHj4Ng2+tCcPF
	ol439B5tNMXOvEPFe7RczWasUrmb1KA=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b5efadd183so746028b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289743; x=1794894543; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X7J8W8iGMlxVtygfltgHoQnyuGwmlkD+WN19PoJbqGw=;
        b=b7CFKvP1ICe7uWKIwHEw1a2xz/OnuUkWuRiDYn0hf3srMpxMde+pe9LZEmJUqOJQru
         LFyAWJ8gLHLerrkahOrOLB5fvjPouXp2bHIFdEdfyKgOqfp+AWDUuWxtBagcBJjBdhOL
         H4srpvXKQ8/a5eSilLS9Qnwb2eEbObiJTBlBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289743; x=1794894543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X7J8W8iGMlxVtygfltgHoQnyuGwmlkD+WN19PoJbqGw=;
        b=2MBb9miPkBTihsD8V0xAmsAVCsAeWiaHdq410sTpXF2KkLCEQ89gP3ATU+Debip7Rl
         m8gFUnTfiY1yUhu056E7/tCSkRplo3uBwHV/2QvP5I+iapOftlEkgmYeh6dftVo6fmaA
         ZlQmusvF6r62Crl8iRu10Zvi/eleGOWxxC9UPN1EugPv8fpXC5khvhEZSqblQ8MMNp8I
         dqk2KFrPYUBpUgJxs4Qyst9OzxkWo0fmHaRWorpVjBJY+IZbExs8iHXP0vZCOkufX8Ps
         rYr5ds8GxUvvnVUb54lWg65Vo0kg1MqgiWWPaT2ziEXU28vThZnBkUS+Ko1ZsFJSTkK4
         jw7g==
X-Forwarded-Encrypted: i=1; AL+hErEB6W7rCc+G8xG8uTiHZjXYxkorYQQkVz5gi1BjwKLVLkL6NuxenYJd1J67h4JXr3jgzJmuYoyjFQ==@kvack.org
X-Gm-Message-State: APuU4Z+9IJU799m3GJghy9wJ2NXxasvT/B2LTb+nk/JeNGR0wIrPzdhk
	VIC58nEHWnPWijRSb5iWPLILneiE3jiCbyX8clIhrgxXdIPOWhkirm3h7QI1IQt+RA==
X-Gm-Gg: AYBFou3Qc/u+glyCIZcWNpucenNaGPXxq/TZnsLptmTJX/Z2exBdWmdD8oZ1R7N1XEv
	os0E4uCw5gJdPHnoJfnChdEukVoIpB1ydRI4GwqjKfWW4rA0FDgsftuRKQzOXZAmJ/w/j8Aocu0
	MK1xcDWgvPjCsUuN0DcBMeBeVVDepvLagx1TDw6h29iPnUKIBem3OXmcezS6vkhqjQ53O3LPyZs
	r9o/xPy53UsZJS43oBrn9M4v0sYAJeUACb1avOciwfB/VubABWT5tS4bbdV6COqIUb3hEs5Nyvz
	nnL0KtFE5e6xayr3J0FW+KUEbnKBvNjxwHDAZIm08N1lWperNwclFg18HcPXEtnXcLYp4XHLZ+X
	0qCh+sxLjSMGBxBP9rTD2Itgnb2kJXGDCeIj2UusN5sDmdh5pdHQQ7BlINkpURM84ZYasz2sSxz
	66yOGu3Prjh/6aEY52Fv4QvhT1MRbQFH9W8/e7p/HxOR399FHaDj7KyP2YzjaFqFGYgJTCSE4pI
	vgdBppsvCRJU5hgRtvw2/C/imUWhbuyqwe4R4OeuTZpRh+2AM0jp8aPA/Y91CZSyzEw+Z8kz4Vw
	nzlWr7kIGDgFxL9TxVZPtstiSRqjJGFcSrHoNKjTRzPcUf5ROL9O+HodbEh8GvbvcESwOBalDz5
	CHJwBSc0s8NsR9A1EcQ==
X-Received: by 2002:a05:6a20:2447:b0:3e2:2a4b:1bfb with SMTP id adf61e73a8af0-3f173738e45mr1398876637.29.1794289743309;
        Mon, 09 Nov 2026 21:49:03 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:49:02 -0800 (PST)
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
Subject: [PATCH v2 06/11] zram: allocate zsmalloc object under slot lock
Date: Tue, 10 Nov 2026 14:48:11 +0900
Message-ID: <20261110054836.1515030-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ookumugm4y91rrpe8wgq9z8yuoht4uhb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 88C2E40009
X-HE-Tag: 1794289744-11338
X-HE-Meta: U2FsdGVkX1/+ZkT39XYqms32/SRwPBs50YvGqVPcrBy4kubYAXAQcJ06s/iZ3FB4AFrtbvVqLKtvSnDsa+3svLHL0vWeBfkceyAu8FCSP4Rk/sOjcWFGxcEO3p4GXY6GHxMDiFGTceAcP19eMx+/4cl5qoy+8KdoQ2+vRAWkAGdTHaSny1GYXIb0RLKPjW6QU04qpFOS4dIWSphLuX8+9ZOJ3maUjrdIMk7gsWFuTYuutOMcODfsFypCGw404tg8CYAdOP8bX6LBf5kDlxpM6Ch/E81PjrUqhOFe/5OhhPHc6585gMlmxZnXpdSG6NnLZAdAGunmWX3fAbvRKl8S7j5SJoGNK4ur14q4mhFCiRffLChvPbsQvdj3QWX4OAcJSXN3xic9R6tvguN8M0PSISLU4HVhPDASgWph+8vHkp5k01lYHRHY6Z1we01Trgi2KnyTgeN7C13LfKsRUh0TlaI67GBiG9bvd1mkJj9ZTLvIdLrvhPXL3GkmxuoxCoK8Ga4dVKxwR+qwjPX/P6dWv9tD22dYOibRud99+j2d8tFlshPeaCIagHjYv8buDFqIJ3bF73E6BjfnhTsaiYWOV0wq/D62SHm5W8TA3xiBcUeJ39AiUYErPKzCW53lg/svTkxYCgPy9PjnHHNS/MTFGmH8Va2gxlCLu9D/BCAG8yIVXvIJEZ6d9Meju7Fc5HvoBhJluveT8c+sSlk8ilghcFqJB5L/g0oj/MBnqCGrXFxLAjCQUhajuHE2PwpZT1zOIMP0b9Biju8VjurmrI9/fCZGDjqO3n2X+ZxpYwsrP/piSmRzbpUHPmVY5hkKVwrMj2uvX8bf9xARrbz3Mie1f+8ql2GaP9zFTTdaVVsrldg7DXvYKsi2eyVs0w1k/SZdno2XTQ+3UvF3XxDBH5yIu2pPOHY6cIyggT6Gt3s8uG1K5hkpNLL94Vhe8mw++SQCPxecv5bKJoWZmyBp28O
 SmAIX8ks
 XpMDsBLxTMjUzQpTAK0JZLPV7e3wIH+MaCcZ7dta3YT43Yqnh+EVUiK7cXC/l1sD+ORCqtBXAkxYuZrBGQFKSFwK5/i+wbOZHHWjCpsyr7Sc7QeFLC94eqNuCdd7FM9gldTc9vDZtzXr4ZMlPxR2ctR6m4KDO4b2lIEQfUNhSc07onbDF8dD63oC+r8W/QTg2+gqjlu+6a2Sp75V6xO82dnq3TWGio17XqPHv+EUtWpTJ7v5KwRZT67lQacmMw3FwUUsELvSb/eX34mL+F+UbQUjbiFr7qiNOWwYJh4UQCmXnF9FUDErma1EkcOr7l03awf+Wr72LFvCnfK77L3t0uYfwoh8X/BBs7/hr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_write_page() and write_incompressible_page() allocate and
write zsmalloc object first and take slot lock only to free the
old slot data and set the new handle.  A subsequent patch makes
zsmalloc store object location directly in zram table entry, so
we need to free the slot before we allocate a new object for it.

Free the slot and allocate the object under slot lock.
recompress_slot() already allocates objects under it, and
GFP_NOIO reclaim cannot re-enter zram write path.

mem_limit is checked before slot_free() (previous patch), so hitting
the limit keeps the old slot data.  zs_malloc() can still fail after
slot_free(), e.g. when we write from reclaim (PF_MEMALLOC), which is
swap-out, so the old slot data (if any) is stale anyway, or when the
writer is an OOM victim that has no reserves left.  The slot is left
empty then, matching standard block write-failure semantics.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d38b20a22595..aa3ab88f1259 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2259,11 +2259,15 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
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
 
 	update_used_max(zram);
 
@@ -2271,8 +2275,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
 	kunmap_local(src);
 
-	slot_lock(zram, index);
-	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	zram->table[index].handle = handle;
 	set_slot_size(zram, index, PAGE_SIZE);
@@ -2324,11 +2326,14 @@ static int zram_write_page(struct zram *zram, struct page *page,
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
 
@@ -2337,8 +2342,6 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_cstrm_put(zstrm);
 
-	slot_lock(zram, index);
-	slot_free(zram, index);
 	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
-- 
2.56.0.506.g506a7eabc5-goog


