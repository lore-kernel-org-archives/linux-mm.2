Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB55E60A263B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=K0HnhWUB
Received: by kanga.kvack.org (Postfix)
	id 6054C6B05C9; Tue, 20 Oct 2026 22:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC946B05CB; Tue, 20 Oct 2026 22:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB8B6B05CC; Tue, 20 Oct 2026 22:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A03D6B05C9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:43:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C368A040A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:09 +0000 (UTC)
X-FDA: 85345086498.26.657A376
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 67131160005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K0HnhWUB;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7YBuhT5Z1iUOeQz6f7j9faCl7gkobBSFAHTtt1TvOg=;
	b=vR/vrIWBeX/T/pvJYLNcVyDLUEmSYCCF2ZcfDiqHnZf/fVLleCKRx3Sxokeky3PfXU10Mt
	Us7/pOqiKpHGQ0PO52V5VXPB8gd+0i5KiZs1TgHRWfDM8HqT0/WkVfts760iiDk05cATU5
	XZb2BdenT6XhnPaUbKQVlMEBCdCuTIQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K0HnhWUB;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550587;
	b=yup7AFrdhqerxz4ywOtO1lKT4zYdsobwvFK0f1AmljsxtORzrreJ+Dt3nY+mxpmyvxkMG8
	hfn0bJ9Jx3yKVM1KYIcPDe5y0kzcnPR17PGqcJ9mDkZH7KjFpBme8lLl4oAlVPOx4dfLvW
	Q8xZ/1SbRVoCNOtttZykPE+Uu/MfwYs=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-15ea896ddc8so347017c88.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550586; x=1793155386; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a7YBuhT5Z1iUOeQz6f7j9faCl7gkobBSFAHTtt1TvOg=;
        b=K0HnhWUBTX040V3p1Q5HSMwfIZmjpo6gzpUdVvK+pJagEj0bLdWw6Awy+SSoe6W00b
         6J/S3vO8WBO4HOBFIu9ckhoZvLbm6GRS6fRJiPEzoHrEEOmoG8SXVGNPotVnjGj3e/oR
         vRU3bdzIHqApdFR76/lZqmhnqa2fQkjtu1xrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550586; x=1793155386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a7YBuhT5Z1iUOeQz6f7j9faCl7gkobBSFAHTtt1TvOg=;
        b=QbHA7jn8An5VyQ5rk+zJqWmxg+v24oEPH5jskBY3dyEYHvoM9Tyv7alInqIiOOqD3W
         1+rvNvBgjm+XQpO9zPcDShv8rN0MjEAZ1e03pdXMWjvBb+LysS8aPj023gX0A35OTaQA
         FSP1j7/yLCjU8/JP3yhKRHFxIdLKD5r9ZRBPuby6yGXGl6K+ZBgKoA7oTjYTSmyhswnF
         XGi9KvsuaKDqbCtmaRNDZ5tTQ/QMUxGl6c1KI993N8Nu6ntlHnfv1bO2e34+MujLvBfD
         6Uw+RU9652Ud3WwUTvr7tmg524geC5f/66OkyGvZl29GXGVz/NiYqGJ8o7ekK/bdYL+e
         4/mw==
X-Forwarded-Encrypted: i=1; AKwUvBwFmOjI93Lhwvw5mI9Y/L2BnvDcUHHUw+P9t96aWlP76zOo/6u0hZ4R5HO5zzxW9Qd0/YJD7z0o8A==@kvack.org
X-Gm-Message-State: AFq9FYLwOnUZl4VCy0WSuN3FKu2IGNIcsEiNlahKeIJP12N4Vxs2qsdt
	4PWspoxqkzWwqtsOVvZJ/yr1pG6KJaLwANHvpzOv20T5aMM/2FmbXwLFz+Wy7ikpeg==
X-Gm-Gg: AYBFou2bjl6uJlO5AbK2CmggtgKoLgnCHXuXV+JxsotqFrDgy0T6NU+LjK5HXIK2iq5
	E++UMxhHc2pOtqSxqOWv/b326AsGBop+EhnUDkAgcO/RB2F99XB8O3JXbOfj+2H1SbRG/gUSDdE
	oF0KyoXhvG48HcdbTTHyWi6kKl5CHLX7SVjjG1psGRad9qs7stqe8lZpx95oDQp2GkRe3nk79i8
	O73aQXGnxFM3FE9RiEy6+xrthkI9A22g2GWgrTyDxs0BGZjxL/vIQrhVEbUSTiTvzV4l1gPX8q1
	YSS1sMqATyGeXjZMHEAJTaCpYVZUMqJU6RwOi2hkwmxnAXrnoJQ+uXiPlt0vyoFU3F/kVLVSGg3
	GidUAfAbGjct0P6sQOaujkFhGVrH4PixJ3cArxrxj4GPlV9ZvBRJlsr+NpcpL9pJzGXUdH9+GWb
	tQ9t3bN6EQBwRDYkaJwBubyk0edCMHGsfp5Riutp391k9ryMHEI364Y/y0iQOyUWnFbwzo/ZZa0
	WDVtxTiCRtxOl7/M/V9Dnq8dqzJT1UnmN+k+KcO+hx+s20x7oSPaxetXTl6hh5X6agfQHWqFV+O
	/bpy8955mevpga+pmZltMpyslhb+HULL+BUvTkSH8iey
X-Received: by 2002:a05:701b:2915:b0:166:29a2:f83f with SMTP id a92af1059eb24-1909f5c7e8fmr908136c88.5.1792550586245;
        Tue, 20 Oct 2026 19:43:06 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:43:05 -0700 (PDT)
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
Subject: [PATCH v6 08/13] zram: zstd: do not use kvzalloc() for zstd allocations
Date: Wed, 21 Oct 2026 11:42:18 +0900
Message-ID: <20261021024236.1787884-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 67131160005
X-Stat-Signature: zgsp1533ih9xqezfrcre5fewsjsc8hx7
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792550587-925483
X-HE-Meta: U2FsdGVkX1+vYkLDRTZIJCnjp6Iyahwsk7Qs/AgYpBoPrJ7kY3EckOL92rDmZLi8TgyKWlbRZWNXOCFc7MUW9kXylxpbyezbd2rIE6vg9svtxDRO+K/ezejtJNdYpe9Fi45wRLw6Uqz4itqKbmcY5XFRnIPMS3PNj13T8l7dy9JsiFYqMIR2zVXWqSosZyExoMRfj1awgDeZ79lgCDJoXFg7pGVC6cmibty1rMxtiaM782I514q+ZEyU2V9CK/EH+bSxbGmv7/+YNSeU/K1FVulyj9puXqUmCU4UwwTPTYgbli6qscjFqaaoh00qrc0OaJE7qBnDiJcYFoshKq+j+xGQ4S2xqc3L6iAv7PjWyhdUh5Z18c4VKjpq6SfZGe4c1/yeSZftZn0aKVN4ZpNtWsbaBdNO/gAEV6EJ8fd0Yu/qRTrJy38TmAZuMLcW9EPn0PBzwxvevXEmgoPUAuosdA8Sq4sJ+igPpSAxHag/1Rrjs3Ii+0XkAbq6gTx43bB0Jte6o8hJKvEAMNjnZUYoworTRh6jZT6KgwuSZjhT/ZoHz32nTlY3Xif5qhFHXCW4pKuEyMGxDQ5CVSGb86IVdJnEoGCLqKDSgbmfA4fUzsOilXaqGLT38dQ7mLQvwtNOvuhAzmx5qCf4+BUQt6IkijAXuxKZLWiAQz86I/l/JT6idnN3Dq64hSnpoXBwUsBVCBtoDihnluKpizF3o57VrG8DVGk3cswGA/VjNLKPTF/tVSMpJuCBYKm8A4kFyUmyUvfOcTUWYNuwb9K5RMH0AWT7eJXrI1FQi5LNTjCGD/SucO4NuVitRkLqLUh7Y/0Bl/Uu/Ta00l+x+35FBqTTf1AMI0m+knLZn1Q9s01jK3xSR0D48WF9YvRCdYo33EafazBPKqnJRc8MSxRAwluFBAkGE6HHFkUODTvyegVUOoMwpTkfZ/Y2kUoR5YrbTUWwJNr5Obdpj2UTEwknUFB
 ssfgJAsz
 cMBdCQPf0C9EQWii4T1HDzfoWWfJPjBt7wJ9YlVhBdP41XAWmEMrsa7y3xoXs/lXAt88cN5bs+pTEjbtJCnOw/Fq0CeQAFpgGD82s+71yOY4Ima27nCVs8ZdeNhN8vYLG6jiMx3w09MOKgF7Zsxt4NEpcI5jDNcw/TA2q4v/RzKzTKDlmcLw+Og7iANudQGbh336qkhFGFKM6yi4kQNQhpbp5Nl4x5cuJw4sBtXWj1f27n+yYdiVEhfT3imIQs9iZVzj9v02d4tuJ7V5zeMr1d3un46HXlB+/WdVGx3swn5df8KbT1jP8aVI/G7lzcQQBPhFHLrJ4IzEsAzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
2.56.0.212.g129ede20d9-goog


