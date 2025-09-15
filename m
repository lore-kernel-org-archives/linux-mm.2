Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C30CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAABF8E0014; Mon, 15 Sep 2025 15:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81F18E0010; Mon, 15 Sep 2025 15:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98A58E0014; Mon, 15 Sep 2025 15:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAF768E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B6C786D60
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:28 +0000 (UTC)
X-FDA: 83892531576.04.49DEB2C
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id B31BD40003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f2d6zINu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3eW7IaAQKCMQp5nvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--fvdl.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3eW7IaAQKCMQp5nvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--fvdl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965946; a=rsa-sha256;
	cv=none;
	b=xeKOWowa/tFzROAmfo0b7XoPlcEPSjRVe7J3O/E1hGLr5RAoKEEBmUEswQFjEarRkrNbt7
	b3EhCbzhxi9U3vYw49Uc3KDxL/cCMUye9mU5fF3sz6pX+zArfvEnXs75zJtejvYzYarKLs
	9Q1RiH/wxDwDfaoPKQkG8s283SuyaDQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f2d6zINu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3eW7IaAQKCMQp5nvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--fvdl.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3eW7IaAQKCMQp5nvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--fvdl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HSCepCK3t1UxBnW9wh+oSKVJTG/pFFOaZ/Yho235Fc=;
	b=JrX4o6aSSGc3hrQvFMQcgNm465qoFyMwdgAY7DkGJ5tmwSDSSFHx6j/9QYVZyoBoVrzoQ2
	0SHpS49avW99albQKpGwo5NzgcH11OwiqHTiJIP9zc5dgtdOx6l4YWyJAJa+po9msu3p2M
	2pj3ONy5DivMJ+BBgEwsIG5asQ9d00o=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32dd9854282so7422922a91.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965946; x=1758570746; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HSCepCK3t1UxBnW9wh+oSKVJTG/pFFOaZ/Yho235Fc=;
        b=f2d6zINumrz213wR09x8M8ht8HkTWr3TiVIr4ggKJS2fhrpk6SbzcriYBToh6blISz
         VByQYaBdz8Atr4IPMQPlXIeT1QxhLaqOnnd1IszHGGguSXa2RV6qZW4FJd5noPpOKrU5
         QIOxRYcW2v/sLgDU2Qv9uhu0njn1eB0s/z4SsK0IXyvOI6EGk2c4S3wmeJ9GPC+mAhT0
         RgSkuCn6gcYrofaZ0p3udxiJNgNW+x3lC1KK0UQuhrGYNbvE5+m2wyMlz+c2Gjfxe6W8
         aQqT/QWKZUE7Tit/ivkHVwDjJA5a+6QI5c80U+JJhGbjGD6tsqbeXIohqiuj0QUA+xlq
         ZlFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965946; x=1758570746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/HSCepCK3t1UxBnW9wh+oSKVJTG/pFFOaZ/Yho235Fc=;
        b=LKVX0dRzYHOSxW7E3eHSS0ManCPcCA82ai8dpqUzkzWwqC14rBGHbqOnVILHIc39W5
         YUGOwYlF4cbvW5/3mZTnNcdrMK2FT2NNFzTpSSRHvODvthGTj9E+D7lGC+Z2BtA5w2Rl
         5DU9uwuHvPwoYuGPh5NOYg/phXYMjlk5cC5o3NoOol/LB8yfqXZ3Ukf2dVC/W1oaUrPE
         Mlsalj1nxG8mkl9GrE/wk7kZSyDGIEqjDoXOoKlHSCxeopS/ilPFchKN8skJd5+Bfb6t
         SL16TGxVCKkhWq/vc//pqewaqbwCOpJpMoMQ6fTSJb0oViJERtiUAe05h8zMmlsVaLsn
         ryGA==
X-Forwarded-Encrypted: i=1; AJvYcCVHAK811Cq3BcwQ2uvgEAyu6SJyESzQrGHb11ucPEvlYCK0DpH66a1G1Y6mJN1PsGtOTAg+YpFXMA==@kvack.org
X-Gm-Message-State: AOJu0YxXbC9VGEjY3uECb9G2PXc6gqSStOQxFApulZS6nsn2Skm0W2v4
	Y02qq4KlA6lTcV8cQhDA1IDplq3VYqZ2POGiU2yKLUjalaB5ARuOZguk+IEh5WaE43ZHMM42EA=
	=
X-Google-Smtp-Source: AGHT+IH/aG7LJ/XwS+oMxCdx7EksVfml5Du7v3Dy129jptRP6+MPmhejd017Z1fgvIWqbyZ0zd5FVA53
X-Received: from pjv14.prod.google.com ([2002:a17:90b:564e:b0:32d:69b3:b7b0])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c81:b0:32e:96b1:fb7f
 with SMTP id 98e67ed59e1d1-32e96b1ff96mr1957825a91.11.1757965945709; Mon, 15
 Sep 2025 12:52:25 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:46 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-6-fvdl@google.com>
Subject: [RFC PATCH 05/12] mm/cma: add helper functions for CMA balancing
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B31BD40003
X-Stat-Signature: b6nt7fbs9ynkt3xhebxhhcba4cbtjusg
X-Rspam-User: 
X-HE-Tag: 1757965946-165365
X-HE-Meta: U2FsdGVkX18Dy0LB6B79a5v0dAMIv8FBUu+G9Rf3vVsY0nrSIjdH3RluNYnAEB9OuZoPftdTf1Btm3I5PT4XQw77HVyVWXKOHeZxd94vUJoLi/QDYlj3OM/id4ZC75nwx1nw7CoicBTg6FdRI6aAnZyj3PJhpj7rORk3F7Mk+G4OFI09m3vXvSXrv38aKqU86nkmlVQJPpMuesYXlWxoV3qeLSFuklfWPUY/hHA4Rab+ni5AQxWv6WEY/Bi6RzYRd/aionJvh3CZ1zWfCQ6YK2Jno8dJ5hLCPiU8dIQtYXhFrJywmAI5OcvRjChbsM37UzYhprzUSe4u9dhl7OlvLtV+/gFqIGz5FNme6u1GKrd1yWsRRAGLwaFDcQqmbOEUBjaCLBxTzi2K7G4BhQvsm47q/m+FyB0fSdHG+L9+Ubgb0lHUugvvef/sRWTIm28uc1SsEUi5URjNenJpdFxMy0phLzk5yNqr9RjhjqmqbCHsMJEB5CMsZr2yxTA+24/sFxBp/LIowJEWnBiGQFqiu9zvFYq2yLyr/eXDOvnq22k+zNDwlS2sF6Vf80zVDRpNzSmbiummjz1Oh29nRL4BaLlBnz5qaEzPUqAWu1IXfKwiwaflahHjra++0vTHytU87hd1Pec/l6opl1JAaPFoOsFnMp8UZUIp4w7WLwk6yOMsetufA+yDkDu8K9mHX3S14YQ6osaGY3CgDVV2+NMO2CMgH0LOQ/T+4ESBgs1rCLWzG/qKV7BIlQlTvI48r1j+OKW3ahpN38zXTOlIltUW+A6m83lGQImFVwgrr0ZxiG4u2WPHbZkvB4cduWMHlqgpdw+oaDypCOHbEx+R215f/lKj+hIwaxTBP/NCH8rJ85gKbcE/BpMVvObaE7HmDtrADtghh50TlJl3dJDDrgstn2zmcqANZxOAT3PQY0BEzL477T45R+ux40tWdtATYHA0iZa2Ldk51peJbk3CHiC
 i2We6KWp
 IGNJm1aCJwpfxTD+exmXE9sFixGq6FRfSgcvFdl/7I5EOP64vSNfwBd3N4Oqn9KPccMETZmOi+58AwHpoY3KMIg+0puVKgFSSR4Jg4jsvd1cXP+68+CO8fm+rdDk9pnxHBMb9y/KIwdnRE2qNyrKmrBAOIx01T5QrEqhSNzAHwWIiRfF9zxoPU0x4eB/a0EoEVFRd1N1uc+83yZlI8idaiWHd4u+bl+wovYRUrHT+r5zII1TZczZcxgJ7IktEg01vD34I+F3oqt2aqsXaPgZ3z4NLRiVPzQz/J0HS86WKRcjWwZKOYuTTCPwABi05pVNoQnmv7atjvkv+unfVreutYvWxg21nSegxjlgc5Uol5Xw28uZYx7UljNNSEnA3mWUl98dXWHn+eIJmblDCXKrlxyvfCkhmju+iSsFexlDtmG14HHFwcUY9bLyBMKqzBm/Wklh3OF0mwbU74lf07g6/pqeS5NiokXmcbuOi/Jl8UOa64FY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add some CMA helper functions to assist CMA balancing. They
are:

cma_get_available.
    - Returns the number of available pages in a CMA area

cma_numranges
    - Returns the total number of CMA ranges.

cma_next_balance_pagerange
    - Get the next CMA page range in a zone that has is available
      as a target for CMA balancing. This means a range that
      consists of CMA pageblocks that are managed by the buddy
      allocator (not allocated through cma_alloc). The array of
      CMA ranges is walked top down.

cma_next_noncma_pagerange
    - Get the next non-CMA page range in a zone. The zone is
      traversed bottom up.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 include/linux/cma.h |  30 +++++++++
 mm/cma.c            | 161 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 191 insertions(+)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index ec48f2a11f1d..0504580d61d0 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -37,6 +37,7 @@ enum cma_flags {
 #define CMA_INIT_FLAGS (CMA_FIXED|CMA_RESERVE_PAGES_ON_ERROR)
 
 struct cma;
+struct zone;
 
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
@@ -79,6 +80,12 @@ extern void cma_reserve_pages_on_error(struct cma *cma);
 struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
 bool cma_free_folio(struct cma *cma, const struct folio *folio);
 bool cma_validate_zones(struct cma *cma);
+int cma_numranges(void);
+unsigned long cma_get_available(const struct cma *cma);
+bool cma_next_balance_pagerange(struct zone *zone, struct cma *cma, int *rindex,
+			    unsigned long *startpfn, unsigned long *endpfn);
+bool cma_next_noncma_pagerange(struct zone *zone, int *rindex,
+			       unsigned long *startpfn, unsigned long *endpfn);
 #else
 static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 {
@@ -93,6 +100,29 @@ static inline bool cma_validate_zones(struct cma *cma)
 {
 	return false;
 }
+
+static inline int cma_numranges(void)
+{
+	return 0;
+}
+
+static inline unsigned long cma_get_available(const struct cma *cma)
+{
+	return 0;
+}
+
+static inline bool cma_next_balance_pagerange(struct zone *zone,
+			struct cma *cma, int *rindex, unsigned long *start_pfn,
+			unsigned long *end_pfn)
+{
+	return false;
+}
+
+static inline bool cma_next_noncma_pagerange(struct zone *zone, int *rindex,
+			     unsigned long *start_pfn, unsigned long *end_pfn)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/mm/cma.c b/mm/cma.c
index 1f5a7bfc9152..53cb1833407b 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -54,6 +54,11 @@ const char *cma_get_name(const struct cma *cma)
 	return cma->name;
 }
 
+unsigned long cma_get_available(const struct cma *cma)
+{
+	return cma->available_count;
+}
+
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
@@ -202,6 +207,11 @@ static void __init cma_activate_area(struct cma *cma)
 static struct cma_memrange **cma_ranges;
 static int cma_nranges;
 
+int cma_numranges(void)
+{
+	return cma_nranges;
+}
+
 static int cmprange(const void *a, const void *b)
 {
 	struct cma_memrange *r1, *r2;
@@ -214,6 +224,157 @@ static int cmprange(const void *a, const void *b)
 	return r1->base_pfn - r2->base_pfn;
 }
 
+/*
+ * Provide the next free range in a cma memory range, as derived
+ * from the bitmap.
+ *
+ * @cmr: memory range to scan
+ * @start_pfn: the beginning of the previous range
+ * @end_pfn: the end of the previous range, zero for the first call
+ *
+ * The caller can adjust *end_pfn end use it as a starting point.
+ */
+static bool cma_next_free_range(struct cma_memrange *cmr,
+			unsigned long *start_pfn, unsigned long *end_pfn)
+{
+	unsigned long zerobit, onebit, start, nbits, offset, base;
+	struct cma *cma = cmr->cma;
+
+	nbits = cma_bitmap_maxno(cmr);
+
+	if (!*end_pfn)
+		offset = start = 0;
+	else {
+		start = ((*end_pfn - cmr->base_pfn) >> cma->order_per_bit);
+		if (start >= nbits)
+			return false;
+
+		offset = *end_pfn -
+			(cmr->base_pfn + (start << cma->order_per_bit));
+	}
+
+	spin_lock_irq(&cma->lock);
+	zerobit = find_next_zero_bit(cmr->bitmap, nbits, start);
+	if (zerobit >= nbits) {
+		spin_unlock_irq(&cma->lock);
+		return false;
+	}
+	onebit = find_next_bit(cmr->bitmap, nbits, zerobit);
+	spin_unlock_irq(&cma->lock);
+
+	base = (zerobit << cma->order_per_bit) + cmr->base_pfn;
+	*start_pfn = base + offset;
+	*end_pfn = base + ((onebit - zerobit) << cma->order_per_bit);
+
+	return true;
+}
+
+static inline bool cma_should_balance_range(struct zone *zone,
+				      struct cma_memrange *cmr)
+{
+	if (page_zone(pfn_to_page(cmr->base_pfn)) != zone)
+		return false;
+
+	return true;
+}
+
+/*
+ * Get the next CMA page range containing pages that have not been
+ * allocated through cma_alloc. This is just a snapshot, and the caller
+ * is expected to deal with the changing circumstances. Used to walk
+ * through CMA pageblocks in a zone in an optimized fashion during
+ * zone CMA balance compaction.
+ *
+ * If @cma is NULL, the global list of ranges is walked, else
+ * the ranges of the area pointed to by @cma are walked.
+ */
+bool cma_next_balance_pagerange(struct zone *zone, struct cma *cma,
+			    int *rindex, unsigned long *start_pfn,
+			    unsigned long *end_pfn)
+{
+	struct cma_memrange *cmr;
+	int i, nranges;
+
+	if (!cma_nranges)
+		return false;
+
+	nranges = cma ? cma->nranges : cma_nranges;
+
+	if (*rindex == -1) {
+		if (*end_pfn != 0) {
+			for (i = nranges - 1; i >= 0; i--) {
+				cmr = cma ? &cma->ranges[i] : cma_ranges[i];
+				if (!cma_should_balance_range(zone, cmr))
+					continue;
+				if (*end_pfn > cmr->base_pfn &&
+				    *end_pfn < (cmr->base_pfn + cmr->count))
+					break;
+			}
+		} else {
+			i = nranges - 1;
+		}
+	} else {
+		i = *rindex;
+	}
+
+	for (; i >= 0; i--) {
+		cmr = cma ? &cma->ranges[i] : cma_ranges[i];
+		if (!cma_should_balance_range(zone, cmr))
+			continue;
+		if (cma_next_free_range(cmr, start_pfn, end_pfn)) {
+			*rindex = i;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/*
+ * Get the next stretch of memory in a zone that is not MIGRATE_CMA
+ * pageblocks.
+ */
+bool cma_next_noncma_pagerange(struct zone *zone, int *rindex,
+						unsigned long *start_pfn,
+						unsigned long *end_pfn)
+{
+	struct cma_memrange *cmr;
+	unsigned long cma_start, cma_end;
+	int i;
+
+	if (*end_pfn >= zone_end_pfn(zone))
+		return false;
+
+	if (*rindex == -1) {
+		*rindex = 0;
+		if (*start_pfn == 0)
+			*start_pfn = zone->zone_start_pfn;
+	} else {
+		cmr = cma_ranges[*rindex];
+		*start_pfn = cmr->base_pfn + cmr->count;
+	}
+
+	for (i = *rindex; i < cma_nranges; i++) {
+		cmr = cma_ranges[i];
+		cma_start = cmr->base_pfn;
+		cma_end = cmr->base_pfn + cmr->count;
+		if (page_zone(pfn_to_page(cma_start)) != zone)
+			continue;
+		if (*start_pfn == cma_start) {
+			*start_pfn = cma_end;
+		} else if (*start_pfn < cma_start) {
+			*rindex = i;
+			*end_pfn = cma_start;
+			return true;
+		}
+	}
+
+	*rindex = cma_nranges;
+	*end_pfn = zone_end_pfn(zone);
+
+	return true;
+}
+
 static int __init cma_init_reserved_areas(void)
 {
 	int i, r, nranges;
-- 
2.51.0.384.g4c02a37b29-goog


