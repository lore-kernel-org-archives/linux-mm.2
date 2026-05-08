Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59515CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2C16B00F8; Fri,  8 May 2026 02:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84526B00FA; Fri,  8 May 2026 02:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A998C6B00FB; Fri,  8 May 2026 02:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 962A16B00F8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:08:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 274E7120737
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:43 +0000 (UTC)
X-FDA: 84743223726.12.537C3AE
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43988120009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="I/c9lfy3";
	spf=pass (imf29.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778220521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2lOcE/NP78qCrPw4J8Q2tX1lxKRSjJyhRJEj/5K+f4=;
	b=jJEQZXXKUl8PxKXdIiI8hKEjTLEXceSkBFMz6uBIRmRcQhWK6PXcJi8NqJMgYHbmlvj/4S
	PlVTWbhfqGgE1YlqnO3FUphE71AGj+aj+rzrHuinzGTAuohN0JTZ+6Fts106no4GdXGN26
	NFxRkS+rAZbA8hHHzdLm5TRZ3vulgYI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="I/c9lfy3";
	spf=pass (imf29.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778220521; a=rsa-sha256;
	cv=none;
	b=xJpAaXzzvRMGUHQTG18EOmmfMleFEOyA+O379lsecr6lOwvwmtuqzvanBksUz4EU2qreYx
	NYD467A7swM58EohaQZe69kcZP7cLIiqiWwIOJHGjYl3eGVA7PRm5AbVIE2w8TPWJPb8va
	2ViAJb7IxnIAUFJfMeusFV1/7x6AOj8=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3650453fb28so1007548a91.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778220520; x=1778825320; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2lOcE/NP78qCrPw4J8Q2tX1lxKRSjJyhRJEj/5K+f4=;
        b=I/c9lfy3CjHxu/Pve6oUOFsd/rGXimvh7NdVBpglPSd4TwNKWtJTAh/QRJ9KZQN52y
         XlsB9MX6He2uVjw8gJk0HMM9NPH3eIn1CbOk8JbtAxZq2KOjbmct9DMbHwky643nCiJb
         SmeUMjJ6/8OczeMEm4FWLxnxH9qeI7a9aakQv0vp7z8etfbu2c0IMKVXr3BDX15jKjVm
         KaooRfQHa/GO5m55D3WdCaF09pe2NSYi9rrG0TRDZmz7yBsbEDrv60ZCaED8oa0/yrbF
         e6gUYV2ya7s+SNkjLWxeGfj1JCQonaGh3igRElMZ+JAlueQ20swt2AWqFpnpQ009Vqab
         VGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778220520; x=1778825320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r2lOcE/NP78qCrPw4J8Q2tX1lxKRSjJyhRJEj/5K+f4=;
        b=RlF3eoYtYIsvM0WpxshkHR8uQjaUCjSIDWnuGkhCBLSMtRhG5MxviaNO84Q6cCZXPc
         CBR/D//Pnx7ahc/B/h3brJmiyADkugWBqTujYod4IOe/02a91yvKwHPcUUl9CmYZ4cfO
         AKQdWJuvhvyYon2X6R03tzULn+JACOuaa0pMiyKWlmcZuohDfKzH2euZ+vNejglDd9Py
         DWXD7/Y8oIvRhLbB7OaBjC2HU7XNio+3oMS/JJ5hZKNGk+iudb6A08L4t0y4L8VtWKRw
         oXF2BNGfSt8+Rhi0LU09htShpJaUfbzLV1s9uxbwBVsIE0Xwu0gylYNT9SCnS8njnqy+
         k3NA==
X-Forwarded-Encrypted: i=1; AFNElJ+6kdG5LS8etPHy6JJxMm3myPW95i506sScUZ+M7nXL9t5+kRc5DY5NWzr5HFQdWO9VDSvXJ/YpxQ==@kvack.org
X-Gm-Message-State: AOJu0YzXE3+Dm/+FuI0uqYwl9NJKwn7i+jykaAilvoGw8T985dVsZ6a7
	akYDoqEWcxDDGkZCtvwj2GJw03oPirhF3CumJxfqz6LfYEO7k9upPfWr
X-Gm-Gg: Acq92OF21g95RrwXCLEyQ0jSwKXChNSQXaQVSmeAfJcMAV0aCe8DQVo4JZXAPz0/WUl
	eYI4IPOvhOTSRwQITQjPqXzRB6mkFIR8M+mhtHuQPBj5jonoi+TUgJzhgVKwAvKZnHUsIRa7wfw
	xWdUT1VCc4f3TOuLxVqt2fEONkQL7bZ2ti8j0g6MdZCXPG9WvGAPSMIepsiv7kF7wLrMsAIsvUU
	nHonidYSV7pXvJOjjlqK67zaZYw8wAP2+oR52RZ5wS5MTXKWtZuiYwFKD7W6iSoHJ9nBUZgSxgW
	R9a4+d0iY9oUVsWunrKCoMlDuJmJyKGjTV+M+hRPNEtB11V6LmSLAZBBWxuCshGxSvdXT7cxS88
	ljA+fzREL9mZdtvJsAAImRiIIhtH1e3P9I9Fe9zyMwyibORyO+SdZ8YY6Z7/D76WfNmcckjbh8d
	5Qi8hdkY5BtyjZ1BpIXenPWZvT12vy7qWzNB4w0w==
X-Received: by 2002:a17:90b:1c8b:b0:364:534b:a898 with SMTP id 98e67ed59e1d1-365abad59c2mr10570996a91.8.1778220519914;
        Thu, 07 May 2026 23:08:39 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36645bb9c02sm673651a91.1.2026.05.07.23.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:08:39 -0700 (PDT)
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
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v3 2/4] mm/zswap: use zsmalloc deferred free callback for async invalidate
Date: Fri,  8 May 2026 14:07:22 +0800
Message-Id: <20260508060724.3810904-3-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260508060724.3810904-1-haowenchao@xiaomi.com>
References: <20260508060724.3810904-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43988120009
X-Stat-Signature: r618b5z4t4dunbau1bexowg737qyst6e
X-HE-Tag: 1778220521-298645
X-HE-Meta: U2FsdGVkX19IEafhyOyOTAPyTTya9mX2HgwYcB+R50gODwVnGFkuLU1keNSLItuZuE9P61iAukXy2+rrrDbl6KceTnrZYoFJBzlkejL5iwHmUY9PIm7KgU74Ma55gicxUeEx1Re2zorPOGWFeRnGCXvAHl/jJU6memR/kGBApJzSMHiBQRRe7lR74I2lFoVt922VKWBVHVnEN+jXex7HNbGlwnap4YLNja2aJuasAN6Urz/QSuuHTBvGpAxwV8+rCUsV1fB+6GQMr+joS2RvikoEM5rd1bd3VUoPvUVpKzivsrOGRFR44oHvw7m+sPvWErPNoy7Ubi8tFGH6N/2Xenm290Q6IkP+qYxk9VST8JAuxJ1ldcdpi+68jZrvcp4VPTeDVAr2ZwK1sOSeWH/ngg5C10GaI5yed3eUcTwGJK0aowLDdGRMHqacs68y02XSm5kBofGa4eqfIqo5FxaDVIlsTWO14qLNKVZIjgspMvRln95m8LrBpCJkCOrvYLja/NQMpPEDzguq/GczPqk+SIMgsyK0RrZvCdHvHK6WSMA1reUTeRSQLCs69uW1J1patYWb0/Aon3IrKiDHp6wdbu1RQL4JM7gP2dEtvplXbU1sy0bTbETZo3yjkRSAKCRus2FAUCX77/bmS35YOsHub14quocOf5S6PuycFqHXMFmLy4p5+CEjHcRpvpfT6jUPHOS6i08MWpKVhZh553YLATPhCrQ/fqeyJyLY+VdGR+WVO0jUKR300Jzm1xNVYX1Y+U4dFsVP9unWiw131kFMNz3MpamVGc90oi0OWHIPkqXjexIixgSPTQ6lMD/Ys4NjtggNObHAhK6OgpRky7j30vZQfEtsFHoPfK2QZCLi77BH2r/vxoD/XvRggfXM4AWIUYmG21hY4ggSKHCP3IhyNrhIEXBQ7X7trwQplKuCsHYMFp0LZX8ok/dpHSoXY3HhS+EistsFHJk8XhjTQit
 2WpcWvMM
 gBhpDdxMIHwTgh7Imd+xW7u4lg3pqj+6vBkgraF4TQmgU80uTTPZWCoRfiAQMmBo+jGxss8LIiYI9rJiprmqGlyaQDDcxTKzA7sFvUVIurPlZGno2N443AVxgatpB2y1nEinhg26chQDlQa9VfNpkyTyibvBHD4f15NHLKWKERpBf6JpJ0+//bnPQXOLSHPdWEMuQKU1a4vL6OXjDp3Bd/faiVvhcWOaCKx3HQWxt09uHbTYhYhKi6ZGzcx4kdNGYX/xpUs3phtbsjzlNdiTdmiTRxNuOAuxhzzHhceNkctdFKeN0xmhHRBgJeA0+Bh1QznWyrSV/BmJIpuSTQ3+UNZ7eINy/h9XozD03e3EMqJc58ri+8XbsgBZdNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register zswap_deferred_ops to defer the entire zswap_entry_free()
to the WQ_UNBOUND worker. The invalidate hot path only stores the
entry pointer into the per-cpu buffer (512 entries/page).

The drain callback performs the full entry teardown: lru_del, zs_free,
memcg uncharge, cache_free, and stats update. On deferred failure,
fallback to synchronous zswap_entry_free().

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zswap.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4b5149173b0e..3f23ddbe525c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -270,6 +270,8 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 	acomp_ctx->buffer = NULL;
 }
 
+static const struct zs_deferred_ops zswap_deferred_ops;
+
 static struct zswap_pool *zswap_pool_create(char *compressor)
 {
 	struct zswap_pool *pool;
@@ -289,6 +291,8 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	if (!pool->zs_pool)
 		goto error;
 
+	zs_pool_enable_deferred_free(pool->zs_pool, &zswap_deferred_ops, pool);
+
 	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
 	/* Many things rely on the zero-initialization. */
@@ -777,6 +781,36 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	atomic_long_dec(&zswap_stored_pages);
 }
 
+static enum zs_push_ret zswap_deferred_push(void *buf,
+		unsigned int count, unsigned long value)
+{
+	unsigned long *entries = buf;
+
+	if (count >= PAGE_SIZE / sizeof(unsigned long))
+		return ZS_PUSH_FULL;
+	entries[count] = value;
+	if (count + 1 >= PAGE_SIZE / sizeof(unsigned long))
+		return ZS_PUSH_FULL_QUEUED;
+	return ZS_PUSH_OK;
+}
+
+static void zswap_deferred_drain(void *private, void *buf, unsigned int count)
+{
+	unsigned long *entries = buf;
+	unsigned int i;
+
+	for (i = 0; i < count; i++) {
+		struct zswap_entry *entry = (struct zswap_entry *)entries[i];
+
+		zswap_entry_free(entry);
+	}
+}
+
+static const struct zs_deferred_ops zswap_deferred_ops = {
+	.push = zswap_deferred_push,
+	.drain = zswap_deferred_drain,
+};
+
 /*********************************
 * compressed storage functions
 **********************************/
@@ -1647,7 +1681,9 @@ void zswap_invalidate(swp_entry_t swp)
 		return;
 
 	entry = xa_erase(tree, offset);
-	if (entry)
+	if (!entry)
+		return;
+	if (!zs_free_deferred(entry->pool->zs_pool, (unsigned long)entry))
 		zswap_entry_free(entry);
 }
 
-- 
2.34.1


