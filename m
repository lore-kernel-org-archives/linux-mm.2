Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488C2FD3775
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CC66B00CE; Wed, 25 Feb 2026 11:34:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A599E6B00D0; Wed, 25 Feb 2026 11:34:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962AF6B00CE; Wed, 25 Feb 2026 11:34:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 824296B00CE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4463FBA726
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:54 +0000 (UTC)
X-FDA: 84483528108.16.A442F38
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6EADC0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="f/EKjISQ";
	spf=pass (imf10.hostedemail.com: domain of 3qySfaQgKCMQtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3qySfaQgKCMQtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RlNf3cTp43SDl4VGdgu3czPaveOo7YCqos20vV6ESzs=;
	b=N0WJUAUVZugM/HPFTZojvqFCJG3wkycQ8VLwzLNqoZvrWIDHIz5rDG5Xw95ih3GvQuynBp
	SGtB9hwzqVEizsBtvpWTUNHpITItVjEZgEFnPt+CbRqdrvZ3i/rHIVrq41LaNOnNsJUXNp
	yvtj4DBsTMASo2gBC99zqnVmryYMIIE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="f/EKjISQ";
	spf=pass (imf10.hostedemail.com: domain of 3qySfaQgKCMQtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3qySfaQgKCMQtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037292; a=rsa-sha256;
	cv=none;
	b=Epd/qoj0vzt/+4h+fl4jkFg/Lw7aiosFQ3qvx4gKfcXgC+de0JpU2c8B5EndtKU38lEjvv
	8POP/V2XJFPgywI4NuELty5jwQuowSWCllDVRKOqmzsmdL6XQoeHAbtViNBZ0KRIx44/gJ
	skmJPCSqRCACtT0G1jHWI/xuvkkwmKs=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4398f665747so796735f8f.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037291; x=1772642091; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RlNf3cTp43SDl4VGdgu3czPaveOo7YCqos20vV6ESzs=;
        b=f/EKjISQ4Do7zA3cj+qiWcYklLNkC0cdHHxYB/FAkpc1HfIMK4fnZgKNX8WnPwY/gy
         XVOzZeYlEJDnnSZlN9zHzsf0eOxBZEoKPLYOtzCg4+2iTo9jkfU4yUytR8Ag1AhKrVCu
         EET3k+m0ppE5QT3YksU0ih9OMwwkjkxQxTwsQQnkah2V/kLEq5l6EdiarQRUZm+c6BEU
         gvY4EFzYfdKq0S3Fbc4/L5ZhGG+23YTfTQBYAAJ0p8hEqI29ncw+gBYFfov1m0pY00PZ
         txLpi1C3RabXdoWhmDLWzddOYZx8yUwTLQSO1Uc/gAu5MMeI2oG4701VKRl+vCc0FtNY
         rNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037291; x=1772642091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RlNf3cTp43SDl4VGdgu3czPaveOo7YCqos20vV6ESzs=;
        b=a1WFxpn91Rxe+PkDNolUcv/wa5eQXaY7D2mzUwJ7c97mviZ0XqoL4yD9LwIl92lxSr
         cOLtakDsxY86YDLoY10wdaOdGkQIVDXYbM+JKHOkER7OBqy3VEtg7C/ciMdZBNVLaWNg
         HEifj/cna6lXZzq5T1h3Zbuxcf7YYhHKFoz5TS4Z8F6YQEGs0gMvXac+Qkol5NwjlFmJ
         PblBap1DhNlMZPMZDjfHNVh9+Yx1rX2OOb12zVDxdtSDVXYNN8Cpyyc6XVUcpP6VNW1q
         lZqDUNHd2sUiVZ6Wzpn+WyKDUVpatFtDckkqZ6Y/4yS24KEpvpRF02FJMcCbTXFcxo1c
         /qTQ==
X-Gm-Message-State: AOJu0YxlhDUFODxB8dNzgn7rBs5uezwyeKHEUlH2RfnAioacOdRWkazS
	Snu7lfLc9OrKLNGVtsPQXy406fPVT2HZN53BqS7gEi1itWgGYm+RRxQ7q1ZDIOzQOAEXEQk2bsB
	0iGOk4ZvU5Qy5ng==
X-Received: from wrbfq13.prod.google.com ([2002:a05:6000:2a0d:b0:436:37dd:b500])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2211:b0:439:9572:52a9 with SMTP id ffacd0b85a97d-43995725453mr896827f8f.41.1772037291074;
 Wed, 25 Feb 2026 08:34:51 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:36 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-11-e8808a03cd66@google.com>
Subject: [PATCH RFC 11/19] mm: rejig pageblock mask definitions
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: bcurtwhj3rprmrbp5q8i1a41qtspkf8e
X-Rspam-User: 
X-Rspamd-Queue-Id: A6EADC0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1772037292-789372
X-HE-Meta: U2FsdGVkX1+FDa8PT2qP1yQdOQXUINAvJXImnDg+tdZk/6Cy5n/C6efGNxAS+PD52F8fY8MyJ1NKBvorAdQgOdv9pFPDXfBi+iZgBEcsbmiDxvE91ya+F1GuQN3DZUgM2tWLSw/5JtTal2vWVX9AqCxGklc9eX5ZA2T2jV76XRRElmpd4rKAAnTq72+kKKiG7N0tWGn9NvwGI6QzmWgFN14KrR4ZqWZugbPSLNES4Pt+dA+xhhqUJ3ci72caX3OySKr3PphTb87ItS1IjaO/ZO6t+RJ5zt8ajT5d9dLddQE7jxA9ol/OjOUQwVBBDUGyumI+fOP+CQhDOtMXC1vIgauI+7hntLAMFjVJO1fVfEkS5jtJN2pQbTuCeWqNNl+sPh7MfzZXusLWOHSWogy7+YTenktlX20HAWKkUEgc07JUTQxG/crUnTkxUv9+z9lMevKGif79kW4TEeXWWi4J66hRa8A6fOjW8CFkzrX/zPr2nVdUwHv3RWQrIfIbdXqHypUB17U687BNT2dWPXr8olW8dJ3CNkFU8wgVUlQ8vqC4QvC9AUkvnNpNTgfjdNQROfh527UDl3VOqffE2nXAIBdAd/Vaj0uShEVezxzqbKtsjp5VEtPTjDCS5MZy4g523ah1WY51kY8oFx1i+pD6ByhQwFddZEXSm4klvteWEJfOL+h5owpWQgMFHld773JR99MY496gIcL20Oqam1Am2C2gza9A1hC2Un5/wpoGbnlwgHEn5nJ7/wTRXSWBzMTrJEqWEWb87G7QkscTcY5liBfU8DV+ModQKcfSyPEgc0UaEZQ5Bmx4jfQshSAGUGPludPs9a5pa4V2emzVhtuvXrsHgJ9wkLIKq3X0fHPDp2TOrBbhgTDPCMYIRxsmqJ0MRBvbwJKyf8K/yjns6gIRK06MFOR/kIjRJTlmHzXA7Ia3VbEBBqLc+04q8zj6bpyyRp0MIzYTzNaL7na9AZd
 uHMc93PQ
 6OfidMiNpaGki5hmYOPT+leHeL8NmgPMeSSpTscvCcA44TBD1BrYuco49OwnADNe+POEgc7zxj2JeFEfnDG/yt+ziT5I28Ihj4G2h5qpqKu7ZifWlNcrnxiS2hIOR6yAGEXlQDAhii/kD1pF0TLv8sMs7dP5lWuSan09NrzdZjDOArbrQ3ljj9KSSS/YR+6jzL08lbYSS98v8pK6oco5akspQl6/4arsMUVSnhzdkXvZFdcYBi3IlubtOTh4e9DbYLadZNO6sr2XnrM5fKMwX5JEPMO0n1G0WdEaZqRiXX4aiDALqYmNqPmjplrBfU0K9rIrgvaoosC/MaO5g3n8jn+mhMNgp0xovvi+5GRFP2dDfZAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch will complicate the definition of these masks, this is a
preparatory patch to make that patch easier to review.

- More masks will be needed, so add a PAGEBLOCK_ prefix to the names
  to avoid polluting the "global namespace" too much.

- This makes MIGRATETYPE_AND_ISO_MASK start to look pretty long. Well,
  that global mask only exists for quite a specific purpose so just drop
  it and take advantage of the newly-defined PAGEBLOCK_ISO_MASK.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/pageblock-flags.h |  6 +++---
 mm/page_alloc.c                 | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index e046278a01fa8..9a6c3ea17684d 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -36,12 +36,12 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
+#define PAGEBLOCK_MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
+#define PAGEBLOCK_ISO_MASK	BIT(PB_migrate_isolate)
 #else
-#define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
+#define PAGEBLOCK_ISO_MASK	0
 #endif
 
 #if defined(CONFIG_HUGETLB_PAGE)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 66d4843da8512..9635433c7d711 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -397,7 +397,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 #else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
-	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
+	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
@@ -501,7 +501,7 @@ get_pfnblock_freetype(const struct page *page, unsigned long pfn)
 __always_inline enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
-	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;
+	unsigned long mask = PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK;
 	unsigned long flags;
 
 	flags = __get_pfnblock_flags_mask(page, pfn, mask);
@@ -510,7 +510,7 @@ get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 	if (flags & BIT(PB_migrate_isolate))
 		return MIGRATE_ISOLATE;
 #endif
-	return flags & MIGRATETYPE_MASK;
+	return flags & PAGEBLOCK_MIGRATETYPE_MASK;
 }
 
 /**
@@ -598,11 +598,11 @@ static void set_pageblock_migratetype(struct page *page,
 	}
 	VM_WARN_ONCE(get_pageblock_isolate(page),
 		     "Use clear_pageblock_isolate() to unisolate pageblock");
-	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
+	/* PAGEBLOCK_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page),
 				  (unsigned long)migratetype,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 void __meminit init_pageblock_migratetype(struct page *page,
@@ -628,7 +628,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM

-- 
2.51.2


