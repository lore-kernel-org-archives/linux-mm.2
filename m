Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E206CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF4D6B0099; Sat, 17 Oct 2026 23:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88A66B009B; Sat, 17 Oct 2026 23:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C504A6B009D; Sat, 17 Oct 2026 23:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBC46B0099
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3451A0413
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:03 +0000 (UTC)
X-FDA: 85334373726.26.08361D1
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B3E820005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gmrCgQXa;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJFVSgny9QpsatjBhIUNhY0HvYxuqclO1o6tI9EiK6E=;
	b=zI97cqPPSxLj0VCvkvw80Vg+fQZ9mnPIv1CU5FVJzj2olRKvhjaBGu87qPAHSMYVPGCwRf
	OaLN+B2d4l3OGH+uUN8zAi5OXgNJqN0BRSLYBtCX5imKacTv/HuMnNCnz+6gWgCHbkA3vE
	qFcJpFQdm01dn5rLGtlI8SIdUZFwl2E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gmrCgQXa;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295522;
	b=7rkc7EG2QoPpZwzBnw8x8o6IlfmBPnlWpaLGH6KwPE3KWJypD/y7iGSaq/njNPjOF3/c7F
	zXFP/SJPHQY0IzDuM22diQQLJbwZzVroGgdGkFNW+MKCRrSQbqKCgRHnHJ3dxxME5ZLtqt
	JT6dhwNy+uHJSuibJ94nCMWY3PR+8eM=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ab98332238so855397a91.3
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295521; x=1792900321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJFVSgny9QpsatjBhIUNhY0HvYxuqclO1o6tI9EiK6E=;
        b=gmrCgQXaPSVQWMV42mk8+6KBQDMwANV63gYUh5r2WoSOkVvWcCaeBwr54zIfu2htzc
         klkxHckDSMncFLgsQ3WluXdnd9Vuym8vySHeEQA3/U3nJfqrXoVQCp2vR4LTtSoBQDuy
         IIPGbe1bgjGC0cQ1U5nKjBFcYNiLcTD1R+w/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295521; x=1792900321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJFVSgny9QpsatjBhIUNhY0HvYxuqclO1o6tI9EiK6E=;
        b=HZQ2ST81DW5sXzAs1dcCnRHF6b55wSsZiHhSTi4rhTlvL5QtptR8rEPfLMDSte4MgK
         yb2s7q25NwHkSiu/66aVs7uegLdHOxUqy+PW7aK4Uk0HIWC7p/B4IzgVj5iQ8gReWmVW
         5moF/KXNziYrfxsGqZ53rTZm7VAVTR+B1zKsp7Zh2hztLXxBp6adCZZP/9Yf3t1ofVs0
         WFbPTULn0ctOIloEJa0ZDOAP/TRZ4SQn1J7HQUfyMhYb2li1rdS6h6ZuneQzW6lREUPr
         rUKv1fMlzwskbLKtjg5mxUUIE1j7BjWdQ5emVdRLyZ9PUnleLmo1fMJ2ohLj/R0PI+UL
         JDaA==
X-Forwarded-Encrypted: i=1; AKwUvBwmiuZqjv6YYz9ftxdlzG0B38GDdRb6LVB6ZQ6xaUlXq582at9LUUjQOr9Jdv3W3cGMnwPyTv6Nlg==@kvack.org
X-Gm-Message-State: AFq9FYIB1tsL1eogVJvo9tRhosy6yot6PqVUWh5e/mtFf/1HMapdMVyz
	dRLgLtRwTgFZbzOCNIl1H1BJ7yld4M3HMk6unRIjFFutmWWTlqFjHZm//ATHaSnG/Q==
X-Gm-Gg: AYBFou33+uG89WH2pIrY6+7p548jjEBbkzyYETNwVPsx52oyizvenfTLk+FRsCV1gjG
	Lo+SywccrskuMT1gre0qaImlzvFi0DxnKHhlb2yB6Tr4AGFGY38V6ffSfQst0BSDyqoBMnlyF22
	IgM7Nx9bNWjR3aztKy6Zn4TFuCuU1xtd4UbdcdlxlXV+TdwaOB2pqXFJB0rmxk6LeJNB8WA+qIY
	7uFRAis7RIUhSP0pJTXFmM5E5nG22cYTQp8a9utaOkoMQ683ny/U4KAHMUoGuApN5XUb5SfBODQ
	Kj0n1ZssqVeog3csVwBALFY8fIDDCeySaEByVLnm4B/pGHf7D52ONNDfPfG7CJhPT71YeXhsvv3
	HaMIsQZAQPL4l6p7zkdhwszb4Oq0mUtcq+x0lhG/yMMXenXVUn8w9KxsRzJ5NFKnGmI+Sl4Ja8C
	HPI/83PpG+vvENYqvFxXUPH8Ccqkjw7lbNm2oJ+deX+FIzxUw5Q3LanyR9RT29jW9+XE8C/D60X
	uVSRRsIc7nDwP8uswMp8zl3T6ztLvBZoSn8RT/Swl2i95p+Ki/RdIwEtdNOdWvmVEh99xWVYnt8
	qeUdCVlvWmf4Ase1argR1IC6rjuCBW7Ez1xz/aArNoT3eJfEYjnDrctIw6iWxNOOSA==
X-Received: by 2002:a17:90b:380b:b0:39e:59a0:46b5 with SMTP id 98e67ed59e1d1-3acef14451fmr3787204a91.24.1792295520991;
        Sat, 17 Oct 2026 20:52:00 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:51:59 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v5 07/13] zram: zstd: do not use kvzalloc() for zstd allocations
Date: Sun, 18 Oct 2026 12:51:09 +0900
Message-ID: <20261018035125.3120704-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1B3E820005
X-Stat-Signature: rjdkzcc1hdyfn3w8got6f9yf6gzfgfw4
X-Rspam-User: 
X-HE-Tag: 1792295521-439015
X-HE-Meta: U2FsdGVkX18+aW/0ZKXxqRAcq8MElkzWpiM8MYrKCjYTnYfFDd407ur4dMio/eJzy+HLKedJWnGrSgPDxCAFJcE3SriX+uMsjIkFlR0qECDmdOlQQ31R8lKWHmTVWePP3tNjD29/saxvnctA+C5ygcW5FkVcAN+YYOypz/smIBZ5L+ovltk39kf6zjMXWEzUUXHsXgoN67LMiRXSgZoTaOub0XUr6I89WXG6MR/CmzIE2JpBzhjeJjnZkcXQNGKYPCI3TzvvouwluG+Pzo8qJp6QVBpbF+rpxYMSdlBQPTj2BJad9WZdCbzfvEc9urmsJorhtt9uCP3r+yDAHmK+osTHzALV6c6pU/zr9eEfcY7rmV86oD2nloWDDz5oymr2ekZpKEtogiI1hxXD8EIlDS3WLVh1JHRni4MsL1B4qiK2kUNI+2UTrlcR3cYCvfMBfwi0U4NIFXzHPKTnjVUW0TAFAzV8/dhhqJ3qdjQ7zr0EArL/QYcGjhKugV6gRYQ+wT8wGNdfYExDWRxVqsDwoNhUwy58CuEblAyn9UEYsYgjqgVrBY01iAkuQbWZE9gfnq0lKvrUNDAqeoQ0/hQjhpqTu/EKawNcvcegescnhnF6dRH/ABCh48606UGmFu+FvNGnPNwl1i4QgQYS+7u8YTWKF4HATdzUY8V2XW/gHuX7GPQBlCgUHgjrbCVxgTAYQKq50Y0EdJJDjZGE9i68xoIyZu1kpvrJSRmPG5yKNLdt7Nbom2U+AK/JMt1yonP9McV0DJ9+KagrWAhYa0l5s4aCp9k1qqLvQD3j967pdfAaDOk5HAhLmIV/75zXRdYl6RBrlcT89nDDulgqp3rNEbSEX62Y5gcvPNW9fRoeCxLnZ9ZlI6Pra51SyQHS1bUv4NZ1rRr4Nz2flLVyZtt7/AoosmOy0loqO/zmnK+MhvjEpxwGPVb9ja9bG3dbK+Fr8Cubz6/BPDLbXdZLsfb
 QH7W0uYz
 0H0vuRUZCZ2ws5Yd3migrPxPrZbGJ6a9WHOhAzjHeoLr1RyunjQyPF8E8lxGaFfhQYIjQNSc1v2ekGTzBkma2RVnjUQKzOni/oZChiEcNdutVt6NbJSuBNW4xhyBP7cJ/65y8tRXOf2e8mb/0ZqNn3iVyut4FkE3f4PcGB3GEs7drOOO5Gw/E75dj36fx9DU1j060dgG95yfBNoMUjN5cTqRec/OvGT2gbTeTc5AADu2afSp1Ulb4I50jq3UkYaaJGOxW8eAD2KdqqcVe3SDy3kMPVrQzJJ2mqMXBHrz1Hz1IOldghzSKKUJjbvf0FZZhApRdeyAeCUGW4+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a dictionary is configured, zstd allocates all of its memory (C/D
dictionaries, compression and decompression contexts and compression
workspaces) via zstd_custom_alloc().  zstd_custom_alloc() uses
kvzalloc(), which falls back to vmalloc() only when kmalloc() fails,
and kmalloc() rounds such sizes up to a power-of-two number of pages.

For example, on x86_64 with a 110K dictionary, switching from
kvzalloc() to __vmalloc() reduces allocations from:
- CDict (level 3):            512 KB -> 400 KB
- CDict (levels 12+):        2048 KB -> 1552 KB
- DCtx (per-CPU):             128 KB -> 96 KB
- CCtx workspace (level 3):   128 KB -> 84 KB (per-CPU)
- CCtx workspace (level 14+): 1024 KB -> 764 KB (per-CPU)

Use __vmalloc() for allocations larger than PAGE_SIZE (and kzalloc()
for smaller ones), which is also how zram allocates zstd workspaces
when no dictionary is configured.  zstd_custom_free() already uses
kvfree(), which handles both.

Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index b367049f131d..7a8b5ff186f2 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -26,10 +26,17 @@ struct zstd_params {
 /*
  * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
  * which zstd uses internally to allocate/free memory when needed.
+ *
+ * zstd allocations (C/D dictionaries and contexts) are large and
+ * long-lived.  Don't use kvzalloc() for them: when enough physically
+ * contiguous memory is available it serves them from kmalloc(), which
+ * rounds them up to a power-of-two number of pages.
  */
 static void *zstd_custom_alloc(void *opaque, size_t size)
 {
-	return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	if (size <= PAGE_SIZE)
+		return kzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	return __vmalloc(size, GFP_NOIO | __GFP_NOWARN | __GFP_ZERO);
 }
 
 static void zstd_custom_free(void *opaque, void *address)
-- 
2.56.0.176.g3575e65682-goog


