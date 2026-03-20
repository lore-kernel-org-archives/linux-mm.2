Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DDEE1099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8416B00DA; Fri, 20 Mar 2026 14:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EBD6B00DB; Fri, 20 Mar 2026 14:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77EB46B00DC; Fri, 20 Mar 2026 14:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64E8D6B00DA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F87516033C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:08 +0000 (UTC)
X-FDA: 84567265776.22.DFDA5A3
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 578081C0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GTEThLmg;
	spf=pass (imf20.hostedemail.com: domain of 3xJC9aQgKCDEWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xJC9aQgKCDEWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIXd6RUsC2Lxd3qD7TF0ldS7pRck+5tE9VDE+BeCdGQ=;
	b=pA/VXTLpTImtuiYc6Gy0V8OGKlHDnX5I2WKAWucrlqv59uTBqaCFdbKiJ2vfwZNwkivGyZ
	6SAQhQht0OiyWbPpWJqHbSCyDNnjPYQoKo8B8OyFF+4uala+cT+xRAZylmlBfaoxQkW8Sq
	EAp8Z7zfFBrqEik9CunrmYFuuSWnZAo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GTEThLmg;
	spf=pass (imf20.hostedemail.com: domain of 3xJC9aQgKCDEWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xJC9aQgKCDEWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031046; a=rsa-sha256;
	cv=none;
	b=OTHbluXlUtrmMAbIQQx/GNhuQQl5rQdhpNm56j/FJvJXVugKiOqFyjMWn4SSaeGahhFB35
	XjDFHTD+4cQhtF4HN+/JKiRVnuLMROY68k9bKurop0iFPUTDTAXJgVMwkbL/8jui9X8W+Z
	O8YgMHNu/qT9A1Hy1fX9soUQ5ETdNH8=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439c112b1a4so509959f8f.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031045; x=1774635845; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KIXd6RUsC2Lxd3qD7TF0ldS7pRck+5tE9VDE+BeCdGQ=;
        b=GTEThLmgLGj85KbBrORhLuV0Re6JNozXQfQkEIzNJ5OcoGjaCJMbhqaZus4Bpcz8nL
         KlUkO4uDbo5qkwPO6NFpfalngomgT04SLKYPBlqw9xCArPLxELgJz3YI9P8IDPIlIddJ
         Ctqw3CS82LFQOxZE9hs8j5k+KT5iSAgOVIY13HyVYN9ObfmZXliPd3M0IyrD+ZP41FuL
         I6S7TCY8uGXIfr/u/eK7VEeaWWJ2WWu7LjrKhxW8kK2ju7FozmchGWPWX9uM2Sw79pD2
         kvPiBGYjA0m4jC5M5vzjYDDBpKo9Pd8zW8CI6kRAUfSjmJ7RXsPtjy11hNU2fz7dsfq2
         qcYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031045; x=1774635845;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KIXd6RUsC2Lxd3qD7TF0ldS7pRck+5tE9VDE+BeCdGQ=;
        b=S4Z2HmdIn46ful3TB1vBEk6zvH/y1KuDzFpxzsaEGQLKnRFa/hajwtUl6NnC1UFqQP
         YuQeIfUo96QQzD48QREXGpYLPiGC5d5tMv6OyMKGc4Ypmt89L41DQCbL6A2P6nvQ9m2G
         /Xw6CmqvMk/sl19xYzKN5AmOBTFzB19ZvYYPOsHtL4wBj+7SZHngxOwGvBi9PKMZOUyY
         /EKInpw+VFf3nL9npyBu9SbfHqCwLS1e+QAluuwgbfiGixjFjkcNwqm/62392EMVSh/7
         IgHk2SyLxZkvNT3epWcy5vnCGSaEE+Nq7zE642yXnsACfuQtCbtDiQar4UHQW06eChhT
         Xn2Q==
X-Gm-Message-State: AOJu0Yxtm9BQyLKWkiEJAayGuDL8jZFHOEjdzqgAWiA/ji0TXRhR7/kM
	+X5z0CDQWrqfZ2Qra3D9YjhZ/vR4MG6728r36BVPNhqI+BDrye6EnCNjvWzCdS9zI2j7ntxIo+S
	KJUq3SHjyqln3Kg==
X-Received: from wmma2.prod.google.com ([2002:a05:600c:2242:b0:486:fdc0:fa81])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4a13:b0:487:1e7:8e7 with SMTP id 5b1f17b1804b1-48701e70a2fmr20888135e9.33.1774031044829;
 Fri, 20 Mar 2026 11:24:04 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:41 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-17-28bf1bd54f41@google.com>
Subject: [PATCH v2 17/22] mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 578081C0002
X-Stat-Signature: 3w43tz8on4dy8itdjogadag3r57m9o1g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774031046-386445
X-HE-Meta: U2FsdGVkX1+lYMuv2cLLWLx0ZKN1rtSYapbgoNi+52GXSWrzpB7WlL9l3vVvXAg1mFjcIQsi8KStlI4tM/MPIp5dkZF3VSLP2Tw1cPZrgKADGeYciLsQvXLiNz4GQfvU5dAFbfcGX/A/mRgyvpZqGMbBvCnVzBKNl9zLWFD0PETdxJ9871Pc2aZYv9gB2jAhWZnGEHlQhFlsGo+aXznu0T9H8gq8pNDR/RGaf4gZ6fctow70V5Jsaqx9EGJEOaPB3xdFT39/lQyOxpsB+i1TVXVCtrFKrZNIUxpHSGVWmJDMWrDKcc0ZFT/EP9jAaqwW74hsvX1OSrIl5OUcCabwGy15GUkCL3MbeYbx036e6WFf3sP8r6ENXL35wsSCXbqDoSxH+XuFgbb4D2MZr6bLdScI818Tgso7w6fExiX73jE4J7P9YDl8aK+mjUMNT/r+gJxxaIe5hG0RsvuadkIl775nOqNC9ZiYZzKIn6KJL89jyIxai93QLThiFgsbEoVoZ2ZOQ1t+5UwUhtuM4enN+VqmKVy7QAXdDwnfYCDSl8MIpL/nvk7pueFq/+zEaIZsGk2sMjykrQVAKdL5avzUPvOicvrBCAzvRicirFSipf2FN6olc+MTuISdm6o1fu2UPZRwGAtFRhCRmXJmsQp9ckbF/Q8Ddun0R5d0gMr1kl1SpN71lb3quiLD5AXGnHNoUD3JtXu6Ws6nBAAbawNYuzjRbDObmfq1eORLfA06do5n08U8suJN+AE7pXFjYBjwCTWcpPUoYrVoRL3OC68aA5z4OkZFgTQMei8gUfhVod9m34blGlggUJiheI3p3Y1QLkaC3bHnK276fqiXXtrNtuoF3+l3iDV/QJxqfc7b4/Qo7x+ymMOnLOB8YpvVBJapOxDQpCBf6KhTCjk2eqfSUNaHAY1TNuQRsmm27C+AikNBAzpXh/85vS143Q87/SVmD53eFGn9MD8wBTw+Q6Q
 +DfBrgBe
 ahZok0ohnz5RTaqLfO6e0ABFuXT/vLB4ps5j+t4JvtKmRHWVKwSqRZrQplBuWPGhVxJMdtEu1sgtd1sXgHyKHS6luB6bqoTV/m+jN6bdkDdR3+sqTNoESLiloixlukVvRSUHU/iWP3ledVDuzKtEApFAwURulpB+MTALqKLbbPaS5O90bByYcpBdlrXRHGvfB2f2ESGhzJ8/b06W+n1+W/LZByksYUp802inDuD6/t1h0va387hEdJDK88YULIbLhKWMy3X2HjX/vFxx+kzjhNSDoQanPYm4wnxKvy9btcSxTdI6cLrcJaqJSpUAC5urppJLtJa8GC0mH9c8aKYoR8w3ZULAD4uHr83DWKBUReJPfEqZte3OGfcD4wadRU/tZxwKCMH4AYcyiYCwbXmVcEQ1CGuyeYnictGsnft2e5mRtpwmeWautjUjuOgOc3M9BqZl4paq9rREfc1HnZVoaTbUWaZrpI/rRBGKbfeZ600IeyyGOMUaWYc/EWjpneUpVOznE7Zw9F15B1dmQPuwblFuatFyAoDLl2+XprnMAMg/0NkOjBIY8CJt3ims0vePdgYO3k0YngDjIS8drsYfkuWOj9U/478PoSR1llXFi/KMt4GM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
ALLOC_NON_BLOCK because the former is "a vague description".

However, vagueness is accurate here, this is a vague flag. It is not set
for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blocking"
but rather "allow dipping into atomic reserves, _because_ of the need
not to block".

A later commit will need an alloc flag that really means "don't block
here", so go back to the flag's old name and update the commentary
to try and give it a slightly clearer meaning.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   | 9 +++++----
 mm/page_alloc.c | 8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index d929274d73b92..cc19a90a7933f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1413,9 +1413,10 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
+#define ALLOC_HARDER		 0x10 /* Because the caller cannot block,
+				       * allow access * to 25% of the min
+				       * watermark or 62.5% if __GFP_HIGH is
+				       * set.
 				       */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
 				       * of the min watermark.
@@ -1432,7 +1433,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 53848312a0c21..9a07c552a1f8a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3355,7 +3355,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
 				page = __rmqueue_smallest(zone, order, ft_high);
 
 			if (!page) {
@@ -3717,7 +3717,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 * or (GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) do not get
 			 * access to the min reserve.
 			 */
-			if (alloc_flags & ALLOC_NON_BLOCK)
+			if (alloc_flags & ALLOC_HARDER)
 				min -= min / 4;
 		}
 
@@ -4602,7 +4602,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
+	 * set both ALLOC_HARDER and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
@@ -4613,7 +4613,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 		 * if it can't schedule.
 		 */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			alloc_flags |= ALLOC_NON_BLOCK;
+			alloc_flags |= ALLOC_HARDER;
 
 			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
 				alloc_flags |= ALLOC_HIGHATOMIC;

-- 
2.51.2


