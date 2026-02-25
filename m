Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989AEFD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0D36B00CF; Wed, 25 Feb 2026 11:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A046B00D2; Wed, 25 Feb 2026 11:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9313D6B00CF; Wed, 25 Feb 2026 11:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 782596B00CF
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EF5D1B713B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:56 +0000 (UTC)
X-FDA: 84483528192.21.0559F38
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3B2DD40004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zz2bfsrw;
	spf=pass (imf12.hostedemail.com: domain of 3rCSfaQgKCMUulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3rCSfaQgKCMUulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LE2SwiqlFKC41gD5ncV0ztisIzW1QHpma9eQC/BfO8Y=;
	b=tjepX7cNXQjh8RIBaJcXyoxp/qgncGWZQ7cLByTjzTvb6ffNFlE0/DbQyjM3BoQ72jN0X8
	koGgXL4gwikLtnYz3o7BH6MUM1BwVxWZ/3DVXbETVMYictaNRnL9tg+XqBKgzysa3JqsIv
	nInaZl36Wn6psReip791op9vlVE41yc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zz2bfsrw;
	spf=pass (imf12.hostedemail.com: domain of 3rCSfaQgKCMUulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3rCSfaQgKCMUulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037294; a=rsa-sha256;
	cv=none;
	b=xZf41tI3rXUSU41QDdlbVBZjzcdd/U1uOFhCPdAepalDEg5seFgOHdWA1NRgJ/gNz4bOiJ
	nFQb5RUGnit22DZyUckrTQ083xh9h0riqKZj1H7FHlyrlkA/UAoX5WcxlCaXUY2/o//cwQ
	F4INYg2LqnAVwXGt5i3xYklwu58Qgus=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836ff58111so81998005e9.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037293; x=1772642093; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LE2SwiqlFKC41gD5ncV0ztisIzW1QHpma9eQC/BfO8Y=;
        b=Zz2bfsrwnq+/rZTEUnFn54NvExedzxFC+PNOlbrneBm/kOj9BeiO3kjO8cAEzzjBAI
         GSJrxfCSOWIBxxwZbjrx5L1Hsn/fAvIcYP2HaPosNcEOy3cIsQ2npc59QcaypoiLXoYe
         inCjWstgEDCSfLPLRxQTrMBueR1zqe2Ec11uoUYGlEvbCpEfLakg/HMXWzTsRHBQACLp
         AcsUihBH6RTngkF1lgEAMj9IpGx4WF1AOhGRevVhQikMHvnGz+oNZIhdVje442dmkW1C
         Nnl/MNgadG+cBOPd11wsC4VN85USzdJKcHM2tNoZlGR2Y3vxPqkPVB11G3vWDvTLu2qz
         fqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037293; x=1772642093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LE2SwiqlFKC41gD5ncV0ztisIzW1QHpma9eQC/BfO8Y=;
        b=Wmmkd16Ck5zbHwTpnABHYMXJ3y7Wzn+9uUzILmLsexpzs//yGvYTKcLwNnhBnm6uAC
         fVERVoFNRfbX86hxA0nkmfg2KSWngwL2knhtzcdRcAqJ5CCPpnfcEO0Q6oAYdyT94aSU
         yjrLlcLZudEHnlhqm21041YQf/Ng+ePvnMiYOJS3UXwwAC9hlXuKa438uqTJnA9eQQRz
         Iz9OiwgAsOgNjGpKkqL5hy0iR40DFlIqGPOjOb1/uMx1b+5yKhTfGsOOEIlAaeJhXqtk
         bnL6znQlds2smngEtVfP8ewERNGTAmT6yH+nTBUbb60Rmhd0V4/szq0ArPdxsL+f3GTp
         MB1g==
X-Gm-Message-State: AOJu0YyKeCB2UeL+TNzQo3kocgUUORCdbOhoJG7EVQczmh4Pj5tR5EDl
	/A0+qP7ojZg62BU6jazkDsmUZLVVpsblUu6Pdk6JlrSxOX6uRF1kgRacE1jXTtqqv2okBNAWeJj
	DP1O5/IlqFRRvxQ==
X-Received: from wmri10-n2.prod.google.com ([2002:a05:600c:8a0a:20b0:47e:e27f:e298])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8450:20b0:483:b505:9db4 with SMTP id 5b1f17b1804b1-483b5059e2dmr135408765e9.31.1772037292676;
 Wed, 25 Feb 2026 08:34:52 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:37 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-12-e8808a03cd66@google.com>
Subject: [PATCH RFC 12/19] mm: encode freetype flags in pageblock flags
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B2DD40004
X-Rspamd-Server: rspam02
X-Stat-Signature: tr935zngesycrjixhbibz1xt6jpm6fqw
X-HE-Tag: 1772037293-338138
X-HE-Meta: U2FsdGVkX1+COvSXLZpLFO1sQDSoIm1krwRJq9qqBxlkot0JgIpnObk6AWIiD4Yntr3MGO9qadn5E2OMtcIgiPzNA0GIKqdobKNMO9tfx1B3ca/Ba122syGF9pDNza/aFnCCADV+I+Nvmj4DV+/xn0IEarjbzugArQPTLVaCE2BlgXysWV90K6kcaHJ//vYIKBxsNuRfADRtVNiDqua27uMf6GCcGKX4guTx6Ex89y4CEJe5YyNb9knQ8mbd42KxWNVSKO2peKvgQfscVIKIBT0UaSRpMRqmT/nldFgjXCadnRulmu5ETYgYQ7FnuCTadxrxWHc8ytfmUYL4BSqdYfJ4ejpmVipEWuJDhrIWMuMaK2dztxjrqd988yNX8cJNZoPbeSfgJsT0XlppzUa+Oh4pcFbIYj0NyaaVHu+d3wA9WqjpqREqrh1S6WvNWzICUtXgmcKZ8OkiIYfI5D+zKy/qYosycS8dNhOXQWB/0YwrsadnPCl/ByVstsGWjuUKS9A/R58gqrk76kGJyJ0qn0w4a35bXV3aHzgSpR1imJPfmrDcbGVhKXiOd4eo89HECqOD6ZR3i11nGdeqkJZ8Sh+47hajxfrSJWE0RjgFhZ314Y+k0nFv3cup23FdWZG5rrrDuDKZBdkVtvus2GaDlS+XzbEoIM6KfpVjMaF20G5kLw/FxFO2OYV7iEdzS8ES3RUgv5Wf8hTFYHDrZEkt3v0/pBb5XXW0AYKaW/JSmxqHCc+1sBrruVWHnr4kGEl/8HdL+b1XjEtaaeFLeFV6leo4hvDx5vBAVV2Bw3MdSyjWWZ3bQyIc6q5N6bxTaIPEL6W6bOU0W62f/gdwIicHAuHMZYtohapOWoVWs8z9/Z7Fa8BWDe/3/v/0TidUXReKihSx4oFfIXVP/YxfXlhUWQ131mEqS7lwf9xU6oFGSVer0uw/QYQqDP7XIGES1IgNPML9kHGyPInb1FG8PWi
 rdTOPHTT
 gBIlnAy9hwQUA5X/2Eutjwn7nod0+Ss0Wj46Jp3A9irfvMxuejDFc6WVmSd1r0A9vcsiXaqx1FqdLpYImA9HIKBzrzk8IcrGZ72y7fUktgaNZaNYB7IRgvFK5YQtkNkLq3vvZ2ye6+BbeXmOvOe1yrxZDYQDWP/r/oj9n/pn8QikQHUGTSbs8n8lndimkUeBwEh38xoAc9nLLvYqPr9lkCfL5uN7qidBnctrWez+D3CEKvZpiyLo1OqEVchW8FaNx7IE8nowLi099qasHYDZd3Dh3Z52+xnaVhQNWIKLJ1d19JpNSDit0iYIqBk1XIShRx8OAeMILZk7REFFu6DaFhlK4DmM6HG31NHM5dFN36Hxin7RQHo9tZV2zYQWq8y0zIsrp7H8PUUlija3Jwl0Fn5PJq78F8h7W/ZmzbQbx5bgAHvHjCntR4h5Za4nH2mcQeOJbAw7hyQT81CXXb7p7zFFcgPt4qNG4ytOkFFH+kqA1j+xQPEfPWV/z/3LBWpdDHDJZGyDHnYSrA8IqniZp01hzR+7iS5SkU8jBboSz+PvZKGjPdyTOppukMuKynCAXe4DsOCJduoA9RsJXYpimsnAlZpudo4Wp1ZH8OAIAo+tnYeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for implementing allocation from FREETYPE_UNMAPPED lists.

Since it works nicely with the existing allocator logic, and also offers
a simple way to amortize TLB flushing costs, __GFP_UNMAPPED will be
implemented by changing mappings at pageblock granularity. Therefore,
encode the mapping state in the pageblock flags.

Also add the necessary logic to record this from a freetype, and
reconstruct a freetype from the pageblock flags.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/pageblock-flags.h | 10 ++++++++++
 mm/page_alloc.c                 | 33 +++++++++++++++++++++++++--------
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 9a6c3ea17684d..b634280050071 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -11,6 +11,8 @@
 #ifndef PAGEBLOCK_FLAGS_H
 #define PAGEBLOCK_FLAGS_H
 
+#include <linux/freetype.h>
+#include <linux/log2.h>
 #include <linux/types.h>
 
 /* Bit indices that affect a whole block of pages */
@@ -18,6 +20,9 @@ enum pageblock_bits {
 	PB_migrate_0,
 	PB_migrate_1,
 	PB_migrate_2,
+	PB_freetype_flags,
+	PB_freetype_flags_end = PB_freetype_flags + NUM_FREETYPE_FLAGS - 1,
+
 	PB_compact_skip,/* If set the block is skipped by compaction */
 
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -37,6 +42,7 @@ enum pageblock_bits {
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
 #define PAGEBLOCK_MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
+#define PAGEBLOCK_FREETYPE_FLAGS_MASK (((1 << NUM_FREETYPE_FLAGS) - 1) << PB_freetype_flags)
 
 #ifdef CONFIG_MEMORY_ISOLATION
 #define PAGEBLOCK_ISO_MASK	BIT(PB_migrate_isolate)
@@ -44,6 +50,10 @@ enum pageblock_bits {
 #define PAGEBLOCK_ISO_MASK	0
 #endif
 
+#define PAGEBLOCK_FREETYPE_MASK (PAGEBLOCK_MIGRATETYPE_MASK | \
+				 PAGEBLOCK_ISO_MASK | \
+				 PAGEBLOCK_FREETYPE_FLAGS_MASK)
+
 #if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9635433c7d711..b79f81b64d9d7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -392,11 +392,8 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 	unsigned long *bitmap;
 	unsigned long word_bitidx;
 
-#ifdef CONFIG_MEMORY_ISOLATION
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 8);
-#else
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
-#endif
+	/* NR_PAGEBLOCK_BITS must divide word size. */
+	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4 && NR_PAGEBLOCK_BITS != 8);
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
@@ -469,9 +466,20 @@ __always_inline freetype_t
 __get_pfnblock_freetype(const struct page *page, unsigned long pfn,
 			bool ignore_iso)
 {
-	int mt = get_pfnblock_migratetype(page, pfn);
+	unsigned long mask = PAGEBLOCK_FREETYPE_MASK;
+	enum migratetype migratetype;
+	unsigned int ft_flags;
+	unsigned long flags;
 
-	return migrate_to_freetype(mt, 0);
+	flags = __get_pfnblock_flags_mask(page, pfn, mask);
+	ft_flags = (flags & PAGEBLOCK_FREETYPE_FLAGS_MASK) >> PB_freetype_flags;
+
+	migratetype = flags & PAGEBLOCK_MIGRATETYPE_MASK;
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (!ignore_iso && flags & BIT(PB_migrate_isolate))
+		migratetype = MIGRATE_ISOLATE;
+#endif
+	return migrate_to_freetype(migratetype, ft_flags);
 }
 
 /**
@@ -605,6 +613,15 @@ static void set_pageblock_migratetype(struct page *page,
 				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
+static inline void set_pageblock_freetype_flags(struct page *page,
+						unsigned int ft_flags)
+{
+	unsigned int flags = ft_flags << PB_freetype_flags;
+
+	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
+				  PAGEBLOCK_FREETYPE_FLAGS_MASK);
+}
+
 void __meminit init_pageblock_migratetype(struct page *page,
 					  enum migratetype migratetype,
 					  bool isolate)
@@ -628,7 +645,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
+				  PAGEBLOCK_FREETYPE_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM

-- 
2.51.2


