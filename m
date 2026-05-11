Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECD5CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188566B00AC; Mon, 11 May 2026 08:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1608E6B00B7; Mon, 11 May 2026 08:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CE66B00C8; Mon, 11 May 2026 08:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF44A6B00AC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:04:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A224140701
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:04:47 +0000 (UTC)
X-FDA: 84755007414.27.ABDED51
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1D7364000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:04:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="j8/2eDTN";
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778501085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ToJM9jyug/8AKNZiAVFhIvDs3CWZZ6jnHnWL+FSpjqE=;
	b=XdQsyOWdgJ3ngGaIvrWOKCa+X+lSOzXbz0oVjaKJdaFKlZl4ZG9fobrRHLJPkpwu48XqPJ
	Iz6WINmax6O1NWnMXIsIIsT7xW05EPAHDFvhHKnB4/rnb5EcVFEWIPyGdXS9NTh9a8ChZe
	7goTMvzz7qFw+echBf1RjusIg24tHZY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="j8/2eDTN";
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778501085; a=rsa-sha256;
	cv=none;
	b=vop6No0Ib1gDhhHu4BE7MZK+Z9wT4Gmti/WQIzDzz4pxHkkah7VYnEGt7QkyVTPQvzRp93
	lsF1emi30ogrrH0GZQBRiU3/HDJ4LE9KGz6xLStahmoZIhcFMQK/3X0+xoYo/4UNVnvOS0
	g7wjdg9e+egBoNK7TNZ2uS2iRAS+dho=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c822652f82aso2974844a12.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778501083; x=1779105883; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ToJM9jyug/8AKNZiAVFhIvDs3CWZZ6jnHnWL+FSpjqE=;
        b=j8/2eDTN6Hovsq7JSjvj1tPL/h1sft7lJnC09PRWHC/hIEYgRzf1mb/BHFpb4Lw1eo
         EsOaJ4GU3e6+FqXvcjv/6JYgzYFM4iq0sOpOG/IVM4DMqNcoRfnLe00lp0w4tsb7aWkZ
         ApbPKvjduOlLA7BtQEFHzSz7cTKOlEv6oE/b0bxla5ObCJKtZT783QLl99gNBCzVUV2/
         DIATrAH+J9WgWG9vp8+0GJd5kRf38Ydg71/6CrTG+adWjtrz9t/onjeo8s1BwC08Nzc9
         PxTXVfFiiQ+whjNdRj7dXboSoomZiLdUTdKCXsO8vxoY+SygjbRX+SxbAP7Y7w8eMVWL
         phdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778501083; x=1779105883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToJM9jyug/8AKNZiAVFhIvDs3CWZZ6jnHnWL+FSpjqE=;
        b=MTMNzcfxvqpt1LDt63iPjOQG6x8A0lLDP7vncRV0n9HdyKTscrs4QTGRSpFFWyLEh1
         tQULEoXJImDq3CeIfyhBT2kM3Z3n3npoGdLdDVoMzHo4XyYrfKgyBG4MNEU7d6OF7CpK
         UkuLQ29OvC1wTdUgKPual8SXQNi7r3/205jrB+Ah0am1xsZZC13A5seG+dDCFFJK3Ui6
         gvMnhpdR8WIQlQ7qaxVL0mhAgci8DjFGNeG84U9eFV43bBhmAgc+3kHRwP/zu07U8AAS
         oAQHwBxJ5IjaNVY21Xe/rfE+EF2z0zm7IEE6kZxQwMyNriQ8t7KHET7lscYqMQdRY7iK
         I+Pw==
X-Forwarded-Encrypted: i=1; AFNElJ+pMdEqwD3O9ESuKE99HB9LWKPGUy8THYqNCDf0EakFOVhMR+lOLhmbBVtWB2Z8oL51r6jRTTvMAA==@kvack.org
X-Gm-Message-State: AOJu0Yy/9Os8XL8pSb5iuJLpAit1BOL7a8/RTMdr7gI8NNGn2lRdswTx
	hBV7YgqEsC4WEV2UKVAMVMN2iAVaDBSfFuANWz4rb1jXmoC9tHtqm9/TEC4eWakE9ZY=
X-Gm-Gg: Acq92OFSGzElcMeqQCaMbsWcQ/GIuI5RNkNfy6+96FddFJZTT+l1Is06csECpzkNhe+
	Ox+8EzIRP1mO2/Ty3wmFd8CsDUGT4dqSWwbzwi54OLHwb8JCADFVZUxnhKJfSmwc7M1L9GZYDA6
	mqfPdUlymKIl1MzhnxcGR9kmsgePihkjLvIB6ZiK5m9IO8C0V1PoPbh4oUmsaIHIM4c3YWUyHPV
	aeDSx5tXFdHaqjj9qSbxhNqcg0dgf2VVv+Wbm3sfE1u1lG5oa3jpKLxEq/DOnhYNb6KAXY+pb5g
	h8xrbUys7iqb6iezzb0L+NeQIj0XwA5NIOjxVJjjKoISqQQrTdlUnnar7jMBW1O+KG7LbV94SGl
	REMVqv4FE4oeagEIkJ3x2rYVlCIPrWFbMLKLnVud4Mam+CEAEMX/sXqnFEVqGYU0fLNLuTNmgVA
	HqwBHqk8iA269R6p20nnx8n0aR5EigiSrY+T4ZCvEqU4IH
X-Received: by 2002:a05:6a20:3d22:b0:39b:e6af:2d8 with SMTP id adf61e73a8af0-3aad425fd8bmr9938498637.4.1778501083370;
        Mon, 11 May 2026 05:04:43 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83967dbd995sm18786013b3a.43.2026.05.11.05.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 05:04:42 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	zihan zhou <15645113830zzh@gmail.com>,
	yaowenchao <yaowenchao@jd.com>,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH] mm/page_alloc: Fix zone reserve update serialization
Date: Mon, 11 May 2026 20:04:09 +0800
Message-ID: <20260511120409.2264209-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D7364000E
X-Stat-Signature: r5uh69oi49rz9jrs9s973uwhgwnsky4c
X-HE-Tag: 1778501084-186058
X-HE-Meta: U2FsdGVkX19y3kVK3wJMIIJcCVmeuvmo3hJUE490QJfCIzhUI0cufHnCsdPcVLhR7GaXa4Mjn08woFsG3fxh1xhTzwwGF8sgrDTgOlhiUAx9SkbdGuXjyXZmXO87pM5SEiz4qOYXEoyGVFD6lf7IMyfipaxgNDIECHDSdfGEJvy7mHk0JyCwFST1tK3TNbUuqVCw1/2IGaCp6w/8U5wPelYgohZx3ig/E/spoHQT32RkbcyL6NPTCLWpFmOehXTewDXthyUVzeXxpt6qoiCuE8e+YJLaKDshW/SAhQS3sdN6K2FeEwI2ppGmovo4OCJYBrw6834Bxj7AI0slI+rAuITWrph9f+sC/lS3BgZ7BebDMTUELNJtNKxndZvD5sqrafL92/yvo2OsS8gStZrQatlQeGb9gku8m25e2Ayc8HUQ05Jh1nGbUVwUqQOsJuhzPSHnZLK1St2vbMkH04fL897qxxiBTpPBga1hDotdAt6zHjTXIG9Fn7NQGRBpT7mLOAArTSGnaawD4vZvzpv6oTbU4zOHnPXXlHwGLMpSFen+KnCzZyhqD4jfR5VFXbsKfz3E4diJPN4WszPaHuiHXGNrNOL1J8hHdRFYMvhMPiA+op7jhok2w36wlC8yodWOTqyfsDYsDaDbd/9eEgf3La/LRphbs8FkcyRLlcOaGkqr9J8OBn7um5dxriqJMcO3sDBqwKS67ePBD6IrYV3XMHM9PORskHaP96o+uEnUogm/5ikKzoeM+pqtLBOhLTbrW/xR0TcO8A/FIzxG2E7jw4p1F23cfQAgubgr95WxAfT3xTAGFN0y7c/lUqzgUG61Jt9Dou4AwcS4SHK5SRGB4HqYTKwDVfdNmnZEBQPgRvBkUvt5BhwLJmXx7HKYa86DLV2b1pHX0hx/u9avXzdgxFBRrk699++/ZbdZnechrC531ZdvR0n70mpOZrwdzZkBjVoSETmRQr4sbOFIRLE
 y/35WaRV
 BE+3L5qE8pdmd+v8b+x92roZumIBgh+h6YPcTaUY08dijR/NyWmBc0MXDavY6EZZ20LFB3D3nkmPIxJor2ltM9UOFfM/u4gxIQ1aVdp0JYRr073mYw7GbB3MKH0hrXkluy2cy95e+k4i9QLqyDvKAWB8OhNUbdAvD2FW7qCpfvWGEU6vrAfRNFnX8IUgjeck91HpfwX6/0hIwDw/6KYeglYAzV5heiEh4JhIKBkuS6U5yd7RBFNtPrnWIZXr8BEKBQ/Xt5aq8IpM8zUjXqY2tYEBvyFNrUi091L/UzelnbAslBdbDPk6Hr27R2w1c6K+T3OBorChRnvsYUVomBU7l09UKH4Tddx+UEGEUOe4rciJD0x5JNP0VBzMJT6fWns39wo9fkYOXP7iriU62Yl+k3gNy0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Serialize lowmem reserve and watermark updates with the same lock so
calculate_totalreserve_pages() cannot observe partially updated zone
reserve state.

Fixes: 9726891fe753 ("mm: page_alloc: fix missed updates of lowmem_reserve in adjust_managed_page_count")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_alloc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3a56825a7fc5..0989067da588 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6384,6 +6384,8 @@ static void calculate_totalreserve_pages(void)
 	trace_mm_calculate_totalreserve_pages(totalreserve_pages);
 }
 
+static DEFINE_SPINLOCK(zone_reserve_lock);
+
 /*
  * setup_per_zone_lowmem_reserve - called whenever
  *	sysctl_lowmem_reserve_ratio changes.  Ensures that each zone
@@ -6394,6 +6396,8 @@ static void setup_per_zone_lowmem_reserve(void)
 {
 	struct pglist_data *pgdat;
 	enum zone_type i, j;
+
+	guard(spinlock_irqsave)(&zone_reserve_lock);
 	/*
 	 * For a given zone node_zones[i], lowmem_reserve[j] (j > i)
 	 * represents how many pages in zone i must effectively be kept
@@ -6509,11 +6513,9 @@ static void __setup_per_zone_wmarks(void)
 void setup_per_zone_wmarks(void)
 {
 	struct zone *zone;
-	static DEFINE_SPINLOCK(lock);
 
-	spin_lock(&lock);
-	__setup_per_zone_wmarks();
-	spin_unlock(&lock);
+	scoped_guard(spinlock_irqsave, &zone_reserve_lock)
+		__setup_per_zone_wmarks();
 
 	/*
 	 * The watermark size have changed so update the pcpu batch

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.54.0


