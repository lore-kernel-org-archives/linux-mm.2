Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C34BDD29C40
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3486B0259; Mon, 19 Jan 2026 11:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0481A6B025D; Mon, 19 Jan 2026 11:11:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9236B025F; Mon, 19 Jan 2026 11:11:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC8206B0259
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:11:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57F10D1A2D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:11:32 +0000 (UTC)
X-FDA: 84349203624.25.CD987C0
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5E0BB2000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:11:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dBP8yrCh;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768839090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WjJfvLBGT103l6zGUDrj7QF6QyCPGm8jtIUaKkXRKrc=;
	b=AzrOrKP3Kp1Rcf6FLefy+bqXxHiXERTrolIdGBspV9Y04h3AV0ESbECMtcT8dueMSQ3plX
	WkqZLmHc9sx2hf/gOs7kfuFqQZfpqxdzQ9YuvHF80V+ywZzr4CjnxE2JZKT1CxtNRUIbry
	SbGkhL35PTruatAnJw01QVaQEHqpl8g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dBP8yrCh;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768839090; a=rsa-sha256;
	cv=none;
	b=hPS4RpAcaS7MF6PP/oXa5+YuwrG4vZ+sKX77KSMUFWG0FxG7RQc33+Seth3yrhWvBa63jM
	DcAMTPsfQ9twZchOl6/9QdIK/draGdyvX2DRz+c8KQp2UWGyPB1DEo7+EBa+vEnO4zgPWV
	yCZE5bYQu78xyQug5htuD3fAJo9pbq8=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c2c36c10dbso515485285a.2
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768839089; x=1769443889; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WjJfvLBGT103l6zGUDrj7QF6QyCPGm8jtIUaKkXRKrc=;
        b=dBP8yrChazOzEpmPD7h8y6Y3CYwCwkEvCBeRlauQqWH0DYej+/TXfbGLWeONNsfen6
         0Sv8DTe3upJOlONd6fNz5bAXdjXoCtPaBaAnYv1cS8nStg+JFI3382XUg6btKYS5jvvP
         IGyCQ1InzmFg1SZC83nC47eiOr2J30ulQeGPCAP6gEng7iWYIeFOCFB7XLhvIr4Wj01W
         3XjYBbuy/qXuSH4Bvv2jGWPKTAraqc7vyK4LwfSO0fV213vuHuo1FXEF61IeordIxfxi
         Giukg6qUvgG46ieVOU6OpRWmqR2QlTXFuitTL4pDpuJT2DimoZdQGdNNIrPMgb6/0rrV
         rkSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768839089; x=1769443889;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WjJfvLBGT103l6zGUDrj7QF6QyCPGm8jtIUaKkXRKrc=;
        b=LeX/JgTDDx+ghvGf/tCkEUGmozt+LjJ1KCSLLN/6IQJptm9867EL7dggx3Y4LvXywq
         VvT+b1HVj9asz8oIdJ9bjL1pcMMCmP5lLm00Rl8dImzPMyxas4t5paUnEsB0WmNKXo6U
         zG3ah2qnmTnvQEU1x5xQq1zPjp+Ypo+epghMmvYOWVTUTXHtPd454pS4AuqG0h/Am3gg
         igsdqzuypSfZwW62a+1e5jc5jc/NyAghg6Q5Cgwnf+6GKO0XlAwsEV3BsDunC+P3CavN
         GVvyhPd7pPo+1c04/dvZ+PSm1thiGqx/NIDqMsTU9Dl7f1ilIe+3k5PYX/cD80pand70
         TgyQ==
X-Gm-Message-State: AOJu0YxBMPAV0jE1C2MSQHXNPEmomRL4Oa5d6Fqr52L9obTUwwxoErWS
	smZ+Wg7qKCkXgVyyKQqxMBK0CvTCLWPkU2idjNMajtI5hJmZt/TEQSJR
X-Gm-Gg: AY/fxX6NMA9agCi19CWZI75+kiOe82jVoWF0x6VZqBOJ+9Heig2SsDhL3AELgvX6q5j
	OjHvdca5BhZJxpHhiPxZbg0RCTSC1cQQpU9t6YWLv+A6bcFl1qrlkwJwK5AZZmSjfb5JbjP+vR5
	TPVkhNMOMStBYBF84yDG5Oqki2YPccAKPSrBvC5Jo8lbqNp1/ckuCqKx6eNUJ+pxtLqjCi2d66Z
	tbsxqL1ydFHuZepfIxiQHVHvIy/SuFMqLYKD51X7LGncmk4CD6h9qfMMlhkiqcTUOmW00fheVn3
	DjbaSX7nUPKJSb0IuoVlQnFi7YnbIaiEqdEjycK4DRv7far3xpsNYj7FrZzvivS+AnfR4SKum6f
	4fXq05ZKI1+yqtc9Tq3ogUfKLtUF+k/yANFDQMMGVlluBqfbwi+7y9qbg1Vjsi6CIq/2cA69hk0
	kaNbzOz86VD1WY8qr73V2EERr+F/ZvbIQ7BnDPp2Njw9lWHcCV
X-Received: by 2002:a05:620a:284b:b0:8b2:dfb3:dc2a with SMTP id af79cd13be357-8c6a67a2256mr1560628385a.75.1768839089399;
        Mon, 19 Jan 2026 08:11:29 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6a72985a8sm815336085a.54.2026.01.19.08.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:11:28 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 20 Jan 2026 00:11:21 +0800
Subject: [PATCH v3] mm/shmem, swap: fix race of truncate and swap entry
 split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XMSw7CIBSF4a0Yxl7DBVrFkfswDipcLIPSBhrUN
 N27tImJj+F/kvNNLFH0lNhxM7FI2SffhxJyu2GmbcKNwNvSTHBRc0SE1HbUQbo3Azj/gIPlJHi
 D6lpZVk5DpDKv4PlSuvVp7ONz9TMu65sSv1RGQOBOqr1TrtaVOI0UDIVxZ/qOLVgWn4D+A8QCS
 GW0qp2VWn4D8zy/AKtrZZzvAAAA
X-Change-ID: 20260111-shmem-swap-fix-8d0e20a14b5d
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768839084; l=4919;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ysQSLUoYhwKPncamfXxkacphx1e+w1AheyJG0ahsEz8=;
 b=dpOk1lOYoQzKSE19Lc0fcCL6U4W81gszY7m55ZxxOMel9fsuqr7+PYmLX5KDsSrL9y1B9a+Wp
 osakKrgfLb1B/t56TuAvbwlAv2kxar3ZXjv9QbkK5p9baeoQUoDoXWA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Stat-Signature: u16fhygujtwb5i67o4gfkyudjyzkhz8t
X-Rspamd-Queue-Id: 5E0BB2000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768839090-701858
X-HE-Meta: U2FsdGVkX1+UtToxkWAPVKF+edgiiRjbdDDYKP1n6n6+EE9WX2b+kvs3QacDRAoY5bUHGgCSlf77syT5n7rbr5nSvq22jNrqO9JYwnT9HkqL5g0IhoE4m5smRJfHOdOSDmEfmiWZDnj9QYux/bBeU2odMtC2ZcKvH0vlN9XvyWTRW/Mnc9o/zF2tBysFud6mfKbM8uCYqI1VP/B2VDQ1S2bsXhHNayegwUYj5Kf5QqdKgh2PByswS8lSCd2dj5Vubp7YfmdsnmqVTiIYDGHmImV9wZ5yFZBudT4p0MTCPzyw3yWl1SVknkYWhd6b2HeNT8yZgW2bZRLnWUL7MsN7v6qSuxU1zg2lYINhed4i3cy1k86rc7kPUU+2ju8wyH5scKTAG/pIHcPS9uAzGOiyQz5DCfO5H2SGfYZ9zuqMy1aLkrTdzgX5nDHRCPgwsfYvuPAPUlBe2EGYmKznNykxWH8pLNaOXhF8pFVj6WVFLe80cBNWMKPtTtVfXuZRHsn3+6nCuUh5boIoZjhRPlbOctr07IW1MpG4a02+IR96elISdD/I1MDvf7DRf8Px9IpkUv1S69T8DKnSSoSS74k/dnanKEFALlwA7YApGSCNyczyOM1csQShbeW7kMilU/X2VFEXKb1Qa2F+bIlf7xkDOvQPP7uwc6SgKyRFz3PwWo86cCJ7BxhhKt+mglvCSwiqTnH+eCbQSdkYyzcbnZvoz54Mm2kWnT8eYO6WcOAHX2//vgMl1wpO3HtSMum5UyubqxHJOCp2Mlx5NeVPFYgwaxGXbmQthtC/dvcTLe1p6fepIuJfBL/74vy8+NXlwK4iVCzfgS1x25/IEyeZv/6bVH0BtFgFmKzx+C1fcsdjtoXo3QjFHU8mCOU6frP3tNyw5ooO3gdh9KqbObDwvzw044ghx98RVuY8G5Ej24s3rifa3Fn2jUTjvHPzAwl1vXBDJWw9aylk1ftcv6xZ28+
 XM68pxh0
 qfwsy+VpPOG/lUUVpnul6lHs+ps6ZIPF8nlYm+aSyWDzDyHU0tI8i/HOrAx0oLKUU23OhLm/ySOkyZWpP8+xC5n6Ci4s8WDdJpR/1hakjCKkd/expmS3yuATt8c2Q/U8XzGLNToktkmtQQ4qclpjQdselesNBvEm8YQ0RRHyzuVKsXaICeiQYD0ywJmhCduyJAOtwH94Wfmylwzrao+tSQ+wLVmBDgBE798hmAEQ8iZDdq6yIfkR/9u8rX0v5b52H8KPV7nDtDToraQVK+KQVqxVPpPp8vgdXU3m3GB67MkeToCuGu9XvMPybXZKmZlrx2PiAazz1ESzaxziLoa9s7X+IHu9LTOKb6XCCI2mFPmaCiUNRk4mF6cqAtW/NUvzPBbQ9OYb2D2cS86z7Rsw4ywKzZYZKUufooyNLglenjiu6FbHPL/WATJUwLgckRGJSDa/nawxvhPm6cw20it5pGsMvnrdP1RVB8Phf8rPQPDj1lCAz+DgM+H7+tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The helper for shmem swap freeing is not handling the order of swap
entries correctly. It uses xa_cmpxchg_irq to erase the swap entry, but
it gets the entry order before that using xa_get_order without lock
protection, and it may get an outdated order value if the entry is split
or changed in other ways after the xa_get_order and before the
xa_cmpxchg_irq.

And besides, the order could grow and be larger than expected, and cause
truncation to erase data beyond the end border. For example, if the
target entry and following entries are swapped in or freed, then a large
folio was added in place and swapped out, using the same entry, the
xa_cmpxchg_irq will still succeed, it's very unlikely to happen though.

To fix that, open code the Xarray cmpxchg and put the order retrieval
and value checking in the same critical section. Also, ensure the order
won't exceed the end border, skip it if the entry goes across the
border.

Skipping large swap entries crosses the end border is safe here.
Shmem truncate iterates the range twice, in the first iteration,
find_lock_entries already filtered such entries, and shmem will
swapin the entries that cross the end border and partially truncate the
folio (split the folio or at least zero part of it). So in the second
loop here, if we see a swap entry that crosses the end order, it must
at least have its content erased already.

I observed random swapoff hangs and kernel panics when stress testing
ZSWAP with shmem. After applying this patch, all problems are gone.

Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Cc: stable@vger.kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v3:
- Rebased on top of mainline.
- Fix nr_pages calculation [ Baolin Wang ]
- Link to v2: https://lore.kernel.org/r/20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com

Changes in v2:
- Fix a potential retry loop issue and improvement to code style thanks
  to Baoling Wang. I didn't split the change into two patches because a
  separate patch doesn't stand well as a fix.
- Link to v1: https://lore.kernel.org/r/20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com
---
 mm/shmem.c | 45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..6c3485d24d66 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -962,17 +962,29 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
  * being freed).
  */
 static long shmem_free_swap(struct address_space *mapping,
-			    pgoff_t index, void *radswap)
+			    pgoff_t index, pgoff_t end, void *radswap)
 {
-	int order = xa_get_order(&mapping->i_pages, index);
-	void *old;
+	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned int nr_pages = 0;
+	pgoff_t base;
+	void *entry;
 
-	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
-	if (old != radswap)
-		return 0;
-	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	if (entry == radswap) {
+		nr_pages = 1 << xas_get_order(&xas);
+		base = round_down(xas.xa_index, nr_pages);
+		if (base < index || base + nr_pages - 1 > end)
+			nr_pages = 0;
+		else
+			xas_store(&xas, NULL);
+	}
+	xas_unlock_irq(&xas);
+
+	if (nr_pages)
+		free_swap_and_cache_nr(radix_to_swp_entry(radswap), nr_pages);
 
-	return 1 << order;
+	return nr_pages;
 }
 
 /*
@@ -1124,8 +1136,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += shmem_free_swap(mapping,
-							indices[i], folio);
+				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
+								  end - 1, folio);
 				continue;
 			}
 
@@ -1191,12 +1203,23 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 			folio = fbatch.folios[i];
 
 			if (xa_is_value(folio)) {
+				int order;
 				long swaps_freed;
 
 				if (unfalloc)
 					continue;
-				swaps_freed = shmem_free_swap(mapping, indices[i], folio);
+				swaps_freed = shmem_free_swap(mapping, indices[i],
+							      end - 1, folio);
 				if (!swaps_freed) {
+					/*
+					 * If found a large swap entry cross the end border,
+					 * skip it as the truncate_inode_partial_folio above
+					 * should have at least zerod its content once.
+					 */
+					order = shmem_confirm_swap(mapping, indices[i],
+								   radix_to_swp_entry(folio));
+					if (order > 0 && indices[i] + (1 << order) > end)
+						continue;
 					/* Swap was replaced by page: retry */
 					index = indices[i];
 					break;

---
base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
change-id: 20260111-shmem-swap-fix-8d0e20a14b5d

Best regards,
-- 
Kairui Song <kasong@tencent.com>


