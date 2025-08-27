Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 355AECA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 034408E0117; Tue, 26 Aug 2025 22:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26828E0105; Tue, 26 Aug 2025 22:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FD98E0117; Tue, 26 Aug 2025 22:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3DDB8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:15:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8493BC040E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:15:30 +0000 (UTC)
X-FDA: 83820920820.08.C61BFC7
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB731100006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:15:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OuzAJwJP;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756260928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=4U3e/+xyZb6ERPsH6QApfN6YyzzzDOLs7mAotq8BYHE=;
	b=b7lbxxDOirqTEXgZhXKRy8i6DUMAhW0ahSYWcY6AA4lzUx9K/2cNS/SwVgufbr9Bg2wtBk
	dLnuKW59t7FvxwzeO0HOe6MmF3+jIIyXH7eMBt89EJZytwFVBccw8++6cYxbX+pHn/vajr
	+OUyhNXbUs9aGqxmUJeDJoFKzOQtfDw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OuzAJwJP;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756260928; a=rsa-sha256;
	cv=none;
	b=vxbPalLVlRe/5Rynri7oYHDb0XuoIi9oOZqDQdNQfm4pqIwjlJHu6klSGqOmv6/L2fIm0A
	/i8UgDhCywUbf921v9vz6vJ2d8DC9yEajNirnbkoFi87ThStk3YyiPMi596D6Lg3E2aPwa
	RnIGq6PTU0+QSWDDii1EPUQA0yOu3jA=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61cb4370e7bso316638a12.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756260927; x=1756865727; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4U3e/+xyZb6ERPsH6QApfN6YyzzzDOLs7mAotq8BYHE=;
        b=OuzAJwJPEZxaDjyvYsPKvESFOEvw9zXJtTDB/vJsWwAYmbNpZhR0WiXT0cocfLlG5m
         tHu/QPcUJ4Sy69Copk1RkYtUn2ta3L6V5qHd5lmq884EIx6+M7mlezFuAJKDejtqrgJX
         /iQxreDB8l+WSs4ktD+qhbvh6evWcBBWVVa54Cl71q4mu12ZR1ktRI1zealnZM2YoGfs
         FwrToM+QxEAwzMMgoEEFzH+mLYSq+t7sujEiHUYFn5LRNjXAAHGOxwkZJ53/SpgPNrOI
         7btivV/K1Y4pGPcSYR/j0C+1S8DfPqOxMTfzmVnRxE/2OHMrlka3H/8JnmgRE76iKv9Z
         fPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756260927; x=1756865727;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4U3e/+xyZb6ERPsH6QApfN6YyzzzDOLs7mAotq8BYHE=;
        b=kCFYNm0cSwbwnFb7dht93lM1f6zVlo6i1x2eH0Dckmw/kGVhphNmhaGyWUTqxGfRM9
         QSYIm986geApvCCqGex9SH+xilpmdennJhllsPzU6wLx6g7xo7MnbL6j/EIA3MipRfmm
         TN9E2lhxRL/F0WUhr6BZuRFZ7xLJRHRcWtdxSWe96K2G+N04MbnJq+11K9HL1Nqlg7v7
         cEDDijUe3pMxkFKKXKBXjy0sjrQFqCUt5SlUeZdl89VagV2Obwutj/wG6KjGRZyRrDyj
         TIvXDB4DPv5TKCI2IRZKc2LkO5h5x8P6L0pd345rmqRJVZQjOA/LHCXgLVYYMBQYZVw4
         TMnw==
X-Gm-Message-State: AOJu0Yw9fQbCo4rYytAobEbCehf0OQoo8j6C7dwulo6GJjjV0zWmw9QN
	e7Ej7bI+j4hlT4z0lMforiz8OiVLAmTsU1pe+yELNP/J62x3ougJ/XgJ
X-Gm-Gg: ASbGnctmEIY7yfH5M6F5LieA9cgBg76v3adKr+7X81bp1vUosi3GDcIfBVjfvBzI/P7
	SBODJ55GlgiSLtz4uYz2JYm5m8yeshuPub62tRkr692uFUX2SRWafM8GlBuq7RhymhOiOlq+vhb
	XZ3yavdH9EDiRAupOD8c5HLzGPBV2ZkL4VpSNAKA6yn1bIVvFBcU9+UDMnhAUGbVDMwJ1jxIsc8
	EwPuweSR7MsObHi/1BseU3a3dPNZnMT9cB0OcU5bBPU/2u+/t7VSpLA3gv9tV/9dVGX04V8kUyl
	STzDXTvUZ6eCiuNX2e5UdMiTsBIRj/5YNe1IeEa8lGWWgueMkLMStGqNwEgN8sqkLgwPLoXwtT5
	5t5GktC46iWsRQxlXaTTzIADwE7Q9MMmOVuPy
X-Google-Smtp-Source: AGHT+IHNEeHx1gHaE1Di4Bi13stn3zu69YCDOM0TBCTeypctvnMy3UrkrvSIqk1wKhZCu5IhZOE3Vg==
X-Received: by 2002:a17:907:3f0f:b0:ae0:b3be:f214 with SMTP id a640c23a62f3a-afe28ec592dmr1566292466b.9.1756260927172;
        Tue, 26 Aug 2025 19:15:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe7f59b14bsm544898366b.104.2025.08.26.19.15.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 19:15:26 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [Patch v2 2/2] mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end
Date: Wed, 27 Aug 2025 02:11:21 +0000
Message-Id: <20250827021121.13645-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250827021121.13645-1-richard.weiyang@gmail.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: BB731100006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: s57qm7dnkkqqaq5neziffpkunjbtcqnn
X-HE-Tag: 1756260928-271817
X-HE-Meta: U2FsdGVkX18fZnCTfsHWFvR7tsVbbGRb0U1X4j7hxtUtF8rnSFbQQfBx0cpx/SFfh1miE4CBqK9RMxiJG3NiUm1ADeRd+1Fup+Sj810V9qZYCPaPM+eQD+HA8GvQ8pRoylvtCmIDrUCIGmivIDc7zkeu7sfBDnIXOiF8szoo9BYX610D8JgPp4vxk/0PimYsIuIQGhRfXmO4jz+3kbgY79YTE3SfFpyWTmFQoVH2qbcYObc7KN0w1nGmR1mpKZJLnFse5k9dSRjwGctCxTrbwSdknUfuO9E5drU01jAkd3yPHvga3g9gY+juhKQsZBMoxeC6kHNyK0NLFL1U/TAI6ghXlLRUW/6zzdOS+3u0Pj7kgOmv7rewXO+1926gGSXsjmjg4x5HlEeV474IzrTbXkK6sRklqOB3htkhNosYKnEH+BXezlo+t8mUaYDYdkIfzsIyvIoX32R4Wt1xbqy/kWyA8paPlO+5u24oiknVMh0M5tG+fwSZpGdIZduv4K3fy07/ssoqSePMlWq75e4MszN1JAjNagCfCbcSQTj62WmmI3fNDHtpq/rDJ+KTjO8m8G0buyRVoZxmLg4s7fvTM8AGszFdsCT5+I8U7vwvt6HDW/8rPkDO2ineEY7WVVDxFda5QOaaljuJb6AsgVIELbSJcfPTpmwLKASvRsvotNJOnqAi5D/GzeRbS8w41EJwA7fn/I0LV55JDuyu79cZMKy2mYEcmNRtDx7D0MEP2IK+wybeKfrhcX9e4QAfSjuUepPotW+T1CV5HKdgmJg8+5XX2+ozmJiSyiwr4NmGAWmI/kIx5+6eutWLVqv2U3Q4piYJsWDsJXFgdXnfLbobjyaayWChlXGEqpOD1dlzki7arYuRLySP/XpfWWV4+vh0BqZs3lOXIrwC9G5P9FdDPmQrbibB7/OpndZ2Fk75Kzi+rzRLsYyhvTINNmHHs973Fml2qZOPY92E6lyQH4U
 +cnDccs0
 /gd5yXnrDBs/5WxdIU7PAx5iuKmEYeUbvKwazPWxWp9rIQYDWrWFUBeFBcgTMozH88uCvIaCxr7FO5ALqvNU4+y3IbJwYFSae6GfcaDk/hoa1NgxLXuzYlJ7JaMeES79imMJZX87U8aU0J9NI4fNkuWYPAVSjeyP6mDGC/b1Akojb+a4g9wBaep+uefSqHPJMSC0M8OVHwoTO70ofDeSYsQYcAB0R6Fxrwi9B9Dl48U4bwC9DGafmAm1eWiyREvfnflnkHtQWlhf3Ot1Lk3LdqRgHwY2maRWb86ZSa5QW1KG1Tw6Wh7NbH5g3lEXC5EHK+kl69rzvylhY0oP6n5T8VldjaHf0sPpyX8ZYOuHxoZNUfXfTg3WQnGcMFNsoI3sDtng2V10Vc2lBRfLMB5qnPHrbEsEbwkOdCyXIC4J+xSXec4wVvf0x9GPr6Xz9/yFD1ZdVVKa4Hl2eeEoYdsF5rt7Sl3C2BGMqqslkCw1gldx9X9Bemf05hZ3Mok5ZKQ/bKBB14wc8cWGiHP8o/7ZN7ceCFoC+EPCd2VzfEE9Ge6GhEeWx6txcBqTKMiH6fK6vSwUHYRh1N+n4QUT9TzyxatXG9jKLp2ANdzmtsGFEe2oY2RU=
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

---
v2: remove PB_migratetype_bits and PB_migrate_end
---
 include/linux/pageblock-flags.h | 12 +++++-------
 mm/page_alloc.c                 |  4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 6a44be0f39f4..6e4c2da15706 100644
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
+#define MIGRATETYPE_MASK (PB_migrate_0|PB_migrate_1|PB_migrate_2)
 
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


