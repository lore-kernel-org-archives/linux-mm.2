Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6272DC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64DD76B00A9; Mon,  7 Sep 2026 06:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625AE6B00AA; Mon,  7 Sep 2026 06:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562766B00AB; Mon,  7 Sep 2026 06:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319516B00A9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:58:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC304A139E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:58:17 +0000 (UTC)
X-FDA: 85186667034.07.F7403FF
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F0E8140005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:58:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iiE7gyBZ;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1AN/04P+M2MfSUIh9oyME08cOW6o5tz/4VT3PS1ydI=;
	b=41yK6ZLPXewLP0o/VJC49S2KnSUDAG3LCHs64RXcBSfKKhpet62e1krIk/EGlCK0yCmU85
	LWmET6WJGfzZzNR/OKWSsYd8LvmTQeHiC9bslunsZpg8NNM0zLWMQBDaACmvXgYpQDiMvc
	CVQvpKaL/uxOveAknSG+AdpQK2JUwzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778696;
	b=aCUKfVxPKClHqVyKVxIduG7K6ACOXiNuY7vrUg0FpG1l/M8+/EzqVvQ8rrocduh1eXpKIv
	TlUaZD2fErs1LQB1GwDGCbu9SuCf6KoV9H1BNOCAw/LC6LOAMMTIpqvELYYM4QLUr7EQNb
	SFB//abWuTn+7WdON0QoXJhPYvq9mYs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iiE7gyBZ;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso1866062a12.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 03:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1788778695; x=1789383495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y1AN/04P+M2MfSUIh9oyME08cOW6o5tz/4VT3PS1ydI=;
        b=iiE7gyBZuPC20/8ztfQPRB+IWiFuI9C/M/0oQe4rQ9T9FVATBfzSKN2BJkhrZGGwep
         LjAFdZJ77pev/lsw2sVCvIp0xA7tlSAdwxQDMjinP3ZHEw8kDm66SxjXbwidPj3VlO4v
         B0crbU7FEH37uhXogycv+a84AURlydC5O/Qg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788778695; x=1789383495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y1AN/04P+M2MfSUIh9oyME08cOW6o5tz/4VT3PS1ydI=;
        b=VPno+gljk7ezFse1LyJS/lnNhZ8wnhArzcb0UutNooFLFo3ivzhOFiBlpOIQkEgesz
         ovrGUeHt2DnYCOxsqL3PPRtN5F3/upoev5x73HsK5XyeskQc6t8WSlu8pPe0zs7Fd4zp
         z3CmZ5BUoPQZtDKAubFrDO8nb5Qu1FVtM3HhnA3cUJEvm5ZbSK1cvGe5r5HxGUSOJIAF
         xyqch/XkOlZlZCbj78TmQdmh+HUDSpeBYp5RwE06dWgVR3ViCB7dcYIoHLQK+lbD/oiK
         WKQJBsms/PJ95nOXYeGC3FGJ+/d7ow/g7vJ5sK3Hu/BUSDOu7jRvDGgc8VjyQ5n4jMr4
         0IVA==
X-Forwarded-Encrypted: i=1; AKwUvBzhKl0h07OidXc/5eoJb4jZ3uA8ybqOIl0b9tmMVAL09Bn+tpWEX7Abr/JiUNEUvUjFYbYs9Ps4Sg==@kvack.org
X-Gm-Message-State: AFuF++mXPjszZJoMSaciKhlXPnvDKrF4SNzigB0/fo2gOyu4u6UBkRZb
	0VNEZnaZdmShMgZqPqaG03LM9Z1U/HtfMu1rUhSao1ErlWJ5BorDg+qnceGwjTOtgQ==
X-Gm-Gg: AYBFou2W/eeGTpB9KXuzlaZbKgrVj46jXXv/RDapyzfzN1iKaMdrvYYJbk8mAR/Rr2s
	OlEXT4rcy/VN5tlGlQd5RPtVc6LoJxkq7c3t/aBJLcnc6yla4XhopVV0AYk8oHYCOJi6KbNWuJF
	j4F+/5p5NTbzAh9eYIPrJeg/1hCglV7wZy1uhd2qI7c298dDjN0WbtNETXHm1jHPodXRe+8MISf
	RNEbOoIagflU6hnVR4o10I7geItL36buSopQUSwtlDpcwD/2eyPWXwkpB2GGnwq5kZWzccZ3NQW
	aQda+tRSvm7ZU/OfLlRzDFsCX6gttaCUlZ9dLXALyt9stnZZR428hJmF70+iqU4LsR+/P4XKmVz
	b98xPQlpB41lodjjwvv16hvqn4H4jBX9SrvmrU4q4X1iktfJaDC+tyUUIKQixb+VWtmQm7lcT4p
	1OsrLWMpsGqSgHW7qoYVQ4aozsPss5YtNJqLgIcv8IOrPNkcJzAgFUilFrrnjf4KtcHQ3zg7wSL
	OvwhWG13TjBozHGs9cVEKTPgy8mqQJzZcrO2Q2zq58VCBr+zXjE1UYNDkettCc=
X-Received: by 2002:a17:90b:4fca:b0:38e:5b59:c2ff with SMTP id 98e67ed59e1d1-39b260dd278mr33380803a91.3.1788778694774;
        Mon, 07 Sep 2026 03:58:14 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:7fc7:d8d5:4877:bc3f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b51eb40e6sm10343714a91.16.2026.09.07.03.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 03:58:14 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/2] zsmalloc: remove old object read API
Date: Mon,  7 Sep 2026 19:57:29 +0900
Message-ID: <20260907105739.1793316-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
In-Reply-To: <20260907105739.1793316-1-senozhatsky@chromium.org>
References: <20260907105739.1793316-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ze97kpx34h8f6k9e9jjk5zqwrteaq55c
X-Rspamd-Queue-Id: 0F0E8140005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788778695-296184
X-HE-Meta: U2FsdGVkX1/huUVothx9ENMagSRgIFkz/Wq1tL8WcpEYj/fGr1sSNlrcdFIxw3qG4H2gp4ebdEttwSbd+G4SyL+lLGkzDpWN5mvZSdp5J93QwFa8X++R0ZBMO+lI4/wt+o8PztdJ8hZReuPO4BAKVNdpPHN1g5KLOqNj0MqByXk2vJ9XryGSxuXHFd+7q50RJlrX0jryqtTfphahh7fNO4dBlpRPSjiGJQiriOW/aCLWvN9HXhLISqB22A59V1GCnPIj3xqAw4Wy25c+0+1TIzvOzSrM4ECO/A8Vz0wTtvXrwKSetUfk+hgHWODkWCYr3DGSoj8D1r68n6ejgDY8ZCXwfgDhopjuDXwwEj43U8kVetfPml3+j57AhqrUmf/VVy8Q0mmtAejdt/QFm9hM9fT9/rvlSgw7zP8DKVEf2muHvIF5kBmilGfUXZ2gLl86RWPCSBmkYubksO/TsBuBDoIGVhYXyO6hhx1M2D0A8GxEpmyZ4Itq1rt1glu32AOY25MCwsFGFZJSVEnjt4CJ1HlvDumQVqXXbwwXDk9QBs5IqxfJQj9THL+YnDiVA/w6hKiy2efGvi3IrQ9IQkeQsSmSNSwqWWRuswsUiKpbUqx2yo40E17lA1pHm8hnQ59JDXMBIAy5I2pLGDMZ9uU1zGqkTZxuPaCPtZ9dRLxrx4CRSSw7vgbf7p1TQXYWE34uuuzAHY6TCMm5ieqwaj2LIFT1ltm+acbd5sX9sxKQPdtelNRILRjprLeGA4+9+dPHvkYqyfOdjizRJPnAvc5fsTtpgPHeISYXXsMGxmlAP9WgwEvYgcaQDxcVP1oyFC3qaCHcgZAEeGyARiD3TJQQ21nIeISuKZ2ymA09L2not3uVDNC4OAzn79rFs/Wp6oZ5fYQvoaN4XB261Yf/ZlnIFVxU9zQQ/AQexlKBYeRccP7eN5PgBa4dHdzb66R1PFsvoUMnWfRuYFj5ZH0LbZi
 pSELI8GV
 Wyj6DcJA3yXg8w9XbXY1kW4DscYJKnPPOafAZpFUaRei/0OsAiiaSHxdww2cLWr1IIKJa3LFnryojCfvlPBSLFGjfDmu0rtdpak7+s2i/ogIc6nyL2djU02Wsei38Rftwou36B0GwVTzPivBAVYiLLTwygman1/8+tr9B2GsBwUlpBANYioElLBYPBKgUrTgxBq/mI7h/+HKXni6njA/UUtgQi49KgiaVcgxIabY3r8E06QrjPcuoPpgQQVCWmayMjnU57Oib3B/6USgtiJB3kERTTrajvLmOe7T5UkfUVLUWTTJm87ofPPKT2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no users left of the old API, all have switched to
SG-list object read API.  Remove it.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 include/linux/zsmalloc.h |  4 ---
 mm/zsmalloc.c            | 77 ----------------------------------------
 2 files changed, 81 deletions(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 478410c880b1..5b7298a5026b 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -40,10 +40,6 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
-void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			size_t mem_len, void *local_copy);
-void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     size_t mem_len, void *handle_mem);
 void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 825022a7a328..11be37c43171 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1134,83 +1134,6 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
 }
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
-void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			size_t mem_len, void *local_copy)
-{
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-	struct size_class *class;
-	void *addr;
-
-	/* Guarantee we can get zspage from handle safely */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-
-	/* Make sure migration doesn't move any pages in this zspage */
-	zspage_read_lock(zspage);
-	read_unlock(&pool->lock);
-
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	if (!ZsHugePage(zspage))
-		off += ZS_HANDLE_SIZE;
-
-	if (off + mem_len <= PAGE_SIZE) {
-		/* this object is contained entirely within a page */
-		addr = kmap_local_zpdesc(zpdesc);
-		addr += off;
-	} else {
-		size_t sizes[2];
-
-		/* this object spans two pages */
-		sizes[0] = PAGE_SIZE - off;
-		sizes[1] = mem_len - sizes[0];
-		addr = local_copy;
-
-		memcpy_from_page(addr, zpdesc_page(zpdesc),
-				 off, sizes[0]);
-		zpdesc = get_next_zpdesc(zpdesc);
-		memcpy_from_page(addr + sizes[0],
-				 zpdesc_page(zpdesc),
-				 0, sizes[1]);
-	}
-
-	return addr;
-}
-EXPORT_SYMBOL_GPL(zs_obj_read_begin);
-
-void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     size_t mem_len, void *handle_mem)
-{
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-	struct size_class *class;
-
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	if (!ZsHugePage(zspage))
-		off += ZS_HANDLE_SIZE;
-
-	if (off + mem_len <= PAGE_SIZE) {
-		handle_mem -= off;
-		kunmap_local(handle_mem);
-	}
-
-	zspage_read_unlock(zspage);
-}
-EXPORT_SYMBOL_GPL(zs_obj_read_end);
-
 void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 			  struct scatterlist *sg, size_t mem_len)
 {
-- 
2.55.0.979.g7e5102b832-goog


