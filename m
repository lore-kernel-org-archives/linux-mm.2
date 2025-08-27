Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327E4C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3016B00C5; Wed, 27 Aug 2025 03:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886DF6B00C6; Wed, 27 Aug 2025 03:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7722C6B00C7; Wed, 27 Aug 2025 03:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5830F6B00C5
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:01:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07419139A96
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:01:29 +0000 (UTC)
X-FDA: 83821641498.09.714D1A2
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3DA4E10000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:01:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mq8W9FMQ;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756278087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=taSzyI5siF68QPNshwGF71KTVjq9HZ3hznPcWh1RZcU=;
	b=byGb9S/16jvarh+iwDIUiF5zwv9z1XT+lNcPtUieVATk9ts39sXyhYItNa4q0UvjA7KhaF
	NpIlbopez1Cqo8zHHqoVzUFgRuLzxR5veiLjnaQ429dW0QjVCuYXzJqntiCGlkMXQocNMn
	nqeyxrFFnvabR68MmfjoODjivzFMyo8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mq8W9FMQ;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756278087; a=rsa-sha256;
	cv=none;
	b=lXn0raxxY9XqLq7CtfiCCD2G6NldtbicNxKc2B+keutMDN9RXfyQih0LNoaCGbFGJnkYn/
	Jtf841IL/OiMjHlpAAnKWAuRnQrKXSVG9tUy92hvitf8u/SO4HiWLwhOSW9gN7HOTN/Vy9
	GexYgsfY42yLsInOqRkN87UeF1e/nrA=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afcb7a2befdso970607566b.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756278086; x=1756882886; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=taSzyI5siF68QPNshwGF71KTVjq9HZ3hznPcWh1RZcU=;
        b=Mq8W9FMQ7poc0kch3jC83nDROn1dJACJUvk75Y4bDz5DHGH2PI/hGupIiiEZ0Vh8gc
         BwQyjpUyH+jp+RuZIg2/h6ey7bM02LLnEjLY/2PK9UzX8gPB/4O260LX5eYWPJr7Pj0s
         9BhLdhXUIkntFL/Nj5lcytah0PNg1jO2TOd4XJMhfqaQ+bN3YojaIJMJDZINHcxw2iiQ
         JtUTiLXAyCv6+rkUVpboEPvlbx5omxtKPMlK2AdkQl6XEWn2Tn5pdUVu1+0EUHrUW/FG
         i+qnHQ7OCET/+NYbOefZQxeqLozlQnNHq6Hd1Cc0ms7FwOAZGeGLAU0mU26KMdzck0Fy
         pl1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756278086; x=1756882886;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=taSzyI5siF68QPNshwGF71KTVjq9HZ3hznPcWh1RZcU=;
        b=j7QbAScG7+ZgZXaoJUNuyip4PT6YOblEuGzIwoX0CXxVx4RrwcxtiwLhCKOgvLSNHf
         8pVLAh/LHfy+NdquBe+gyV9HZg9GqwNd83Mf30Rz7ubNuAqgaTvlY439CLgvD2TRuD25
         41VOAFVYvGeVJOIv5fAU2r1hjOiBSTB5AdmetohuyHftzr8+aOj3lIIOXl4edxc2pNqv
         AbAnYEtSBMg0L4IPOXcS56YqhyVDEJHozx9zG8GCSA9b6ylIqKiZGBsxmjYeAx04Mw+q
         EMur7o2SE6LQpltrPWhnTBI86kwiO3ov8EAeFpNOvnuuZXg7/2hN0AWd1zgtujk2+KOH
         ziCQ==
X-Gm-Message-State: AOJu0Yyo6Yahf0u+MXVarDt7Bv2oXQIu1iLF/Oy3ck9JQfvoBTm0br/v
	8mvJwfEDxuWN7+5NB7bV8I/klY/KwGMR+iVRYDi5y44xy4oaw8R35ZcS
X-Gm-Gg: ASbGncuvgJeJPkFyumkQ9pjuXic5DdINhKzml2fagqmei9jwRgCckgzprt28SRp8LBA
	B78G3Da7db0yghIo+XC0A65gydv9l1oSvR32BUY3htDLnJKKSrPmyVF3jTwopUBZBhs2mHv5qDB
	U9UUV4WlmlsaWGOD9wuaknqSl31e5StezkNn02nXqgS/hp+IMu/8WFUA2nu5tB5y3hbfSQu0dK2
	a4EyC7riuws0Z0wzuBYVt6nudLOMlPnPizYy8FhhkxePjgRdO06Iv4+sz98UFKrnYjRyv2ND9RG
	x2y1VBKfWy5fZpAGjtlx3VZl1A6ABW9s35dAnBsxTvd1Dc1uAwej+mU8dkWDNk2Q+8vOQly10np
	GvPCwU9shVHYDGY4oD0Xb07gYoEd0AFvxq4nr
X-Google-Smtp-Source: AGHT+IHQPgf/uOHiArouC8bhaUZXLjZjO25FW9FUeWVvPSXS0WLe88GmgktrcblLtrsDLDs57U30aA==
X-Received: by 2002:a17:906:c10d:b0:afe:c2e7:36f1 with SMTP id a640c23a62f3a-afec2e7424emr100306466b.0.1756278085695;
        Wed, 27 Aug 2025 00:01:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe9f7a1b2fsm359040866b.38.2025.08.27.00.01.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Aug 2025 00:01:25 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [Patch v3 2/2] mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end
Date: Wed, 27 Aug 2025 07:01:05 +0000
Message-Id: <20250827070105.16864-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250827070105.16864-1-richard.weiyang@gmail.com>
References: <20250827070105.16864-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 3DA4E10000F
X-Rspam-User: 
X-Stat-Signature: afi9x4nwdce1sge43zojjotn4gt6pcgn
X-Rspamd-Server: rspam09
X-HE-Tag: 1756278087-444250
X-HE-Meta: U2FsdGVkX18TJtr5EHEvCRo7ZxjMCPObTkQ1KwVV4aruoBBjssJ+dYz/cbzQW4/Az/0YYAfOUdpby+eMqAuncvpN0cM8G90JRgFI+KiDRmGPkWOm4RBZCD/WNExS/pMmKNCaI1aUuyEiZx/dikJHJJ3+8Se7RZMm5dChcePVXJKHom86lgqy74EQMu2TWm68+42YvuzK4k/MtpU4p/WiNu6IFgJp0pVSsdzqSiN2FS2IJLPEKaULMxyOUllDsDcOxlhP4KG/5H29KRketQTgd4N8sxnwU4tkCZMICAgCmNdkz/zJxTR1eMJz5dbxrbUEMkNJITW+ECVnh4ob022C+uvoSsoV1pEW4HeUPutR4OeuIH8zkyuTP8jH6xznrseJe2CPqcUibSlpuZrFRLuOuV6nctJOxKfHjjmETx8b2G2tRMX7IWVP+CUch+xvVjta4aRFQSbItwud+ydyWW1t72XitG/KLeNQ1oSIfqLwv/q4g/tBvjM2cWoCQW5mNILuznaO1Gfu+5L4ebJ1Eq0KaCGKLpyvBfKGPvkW8H4KpLN5Ky0/5NlJfHu8favJZui8359+xfUHgehvhk27N1Hb6xfMeUUruIcyN7IzTB/p0RTHpJuU7qM3StKOGRCjxj5UR+ykPSUKSWmbx/BTBV8XRUyz2+rr/767gZ8N+srrVqHoesD8GpMSdBscd8BCdj6n4SMiKKqb8QfUJtN6N71rj0+nwt05NV8tEtwRbmnWkItF9ypgyfL5S6Ox3ptqMRPWUKbFuhcugCwx79GAWUC61EbRdPecfBiUJFp1a3AIZEHParW+YRHOo4nAdvVKlk0SmZZXoeUaB+SVZ3CY79a2grWnC8HQGXIjuFPJCPyoYalvphDMggJ/3q5288m0I0gEHCducKMokXfTH/oOCw2snt/YzwvE3Ij9xz8t1vT7hDxAt6YwXfmtwhcR4n5wXP7xPL43b8RIWQ5rs6tBUSv
 x/lN0i/5
 s5QDjdPQoxtohYgOF1xI6Uk1NntoNE9yDKwWPE9H6m9tz/hlFUAZ1tsz1VdDMaslZhTsLHVMwDyuUHx06cWD0FqZEHt3zU6a5wUqVqn7hO0dcbSuxgJ/t4/y/nd0ZQPhaTyItD6N5oV18iIdjFZL1vzIY16qUTKAMK/eCcb4Yk0K8jATW+FXqr6AlKYAtg2oZPcd+M1ZoEQ81eRu+8z0H/CJ76xGQIMrKJBnXcYUiR8FcdhITGYDAzmV7NdD+/81wgZfMNAVX8WNnY3hb9aGktLYz7m4jx2ilMPpW6A3V/eXwE0yESBrjRMc0S08hVU0RNX90mMsdGRfseDnxKXSRBWkVYKylERaOdoEkMhI1XYS+LJcgQjdKjPyw+bc0w2k5IBS35ynsdX94SY8ERtwhg2488Pm6fjR4P3jhc78aScfxBtEgOXzEjNQoDYkKp1d8ZBep6D4fGwMS5l6GkWjyuc8oN/Vyks/vOW2EjQCHT7OQYOIMTGmdwaNNB8OFi2gJkAHpOZIkn4YBz65V+qYEUQm0zx+xnQcx6Ea45/GDNYwiD640zkol4veP9ldM4M8F+IYK7sAcXijZhPVFmbK4rgDiBxtJ7q9AwAGf03Qw2X+tr+0FYWMffOhUq2lUaLmbymoHuiT9IJblEOesTvokJVRIsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

enum pageblock_bits defines the meaning of pageblock bits. Currently
PB_migratetype_bits says the lowest 3 bits represents migratetype and
PB_migrate_end/MIGRATETYPE_MASK's definition rely on it with magical
computation.

Remove the definition of PB_migratetype_bits/PB_migrate_end. Use
PB_migrate_[0|1|2] to represent lowest bits for migratetype. Then we can
simplify related definition.

Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
cleaner.

No functional change intended.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>

---
v3: fix MIGRATETYPE_MASK defition, thanks ziy
v2: remove PB_migratetype_bits and PB_migrate_end
---
 include/linux/pageblock-flags.h | 12 +++++-------
 mm/page_alloc.c                 |  4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 6a44be0f39f4..e046278a01fa 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -13,12 +13,11 @@
 
 #include <linux/types.h>
 
-#define PB_migratetype_bits 3
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
-	PB_migrate,
-	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
-			/* 3 bits required for migrate types */
+	PB_migrate_0,
+	PB_migrate_1,
+	PB_migrate_2,
 	PB_compact_skip,/* If set the block is skipped by compaction */
 
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -37,11 +36,10 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
+#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK \
-	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
+#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
 #else
 #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e534f31a6b39..c1a18aaf8b41 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -355,7 +355,7 @@ static inline int pfn_to_bitidx(const struct page *page, unsigned long pfn)
 
 static __always_inline bool is_standalone_pb_bit(enum pageblock_bits pb_bit)
 {
-	return pb_bit > PB_migrate_end && pb_bit < __NR_PAGEBLOCK_BITS;
+	return pb_bit >= PB_compact_skip && pb_bit < __NR_PAGEBLOCK_BITS;
 }
 
 static __always_inline void
@@ -370,7 +370,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 #else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
-	BUILD_BUG_ON(__MIGRATE_TYPE_END >= (1 << PB_migratetype_bits));
+	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
-- 
2.34.1


