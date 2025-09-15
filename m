Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACCBCAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A169B8E0013; Mon, 15 Sep 2025 15:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0468E0010; Mon, 15 Sep 2025 15:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0C78E0013; Mon, 15 Sep 2025 15:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 746FE8E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21044BAF0A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:27 +0000 (UTC)
X-FDA: 83892531534.07.A43C7B9
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4A447100014
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mRlwHGyl;
	spf=pass (imf05.hostedemail.com: domain of 3eG7IaAQKCMMo4mupxxpun.lxvurw36-vvt4jlt.x0p@flex--fvdl.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3eG7IaAQKCMMo4mupxxpun.lxvurw36-vvt4jlt.x0p@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vg42YXvjHFhdSPyd/4e9YIQchkUAG0NxSAV9DDvIrlA=;
	b=f5mZ/nlufNbWwNfSBJ4id0VqewGdWL9um0sJ+JnWKJNMDO+3trXkxIyBLW2z6jQivkLbr1
	+1ozq2vfXzj5di47O++Y4Cumj5SUT886YkwGncRGhuXi7YhJ1m8cryLiTQ2MKq0J6dRzan
	3a7m+X28xFVC7+ee5wQXIQIRtms4lLI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965945; a=rsa-sha256;
	cv=none;
	b=o4vvIZTH+TGIv5kqEpkJ0MA6TGg241DV8o7OPrPvqu/O87DTh7l1NZjk2HMg5UFaESH3Ah
	XQ6liYOEnfYpKJcMsCK7fPRsAymfQTz8FZouf8IDqWm7lankb5sAl+BrKr9/kr3IcgSpR4
	ICVb3OP4Nnga+d3Ep/pgoL5FgflbkoU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mRlwHGyl;
	spf=pass (imf05.hostedemail.com: domain of 3eG7IaAQKCMMo4mupxxpun.lxvurw36-vvt4jlt.x0p@flex--fvdl.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3eG7IaAQKCMMo4mupxxpun.lxvurw36-vvt4jlt.x0p@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458345f5dso54806615ad.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965944; x=1758570744; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vg42YXvjHFhdSPyd/4e9YIQchkUAG0NxSAV9DDvIrlA=;
        b=mRlwHGylRsgXGMzhX/OjX/rriE1PgtlnJhNxLirrvfPiR2n2s24/Wu2E/APMPv1NJf
         kbQeKpWB3J+Rp5OwrsFrzo+kVrlHB1QhFKjFM/z/VU4UX0pCjUmZRo7Brf8hu6pZa7Eg
         E+3+VrNK1PpnEbS0lckIvR+bXYT0icHbUohoHV6314WHP3NXxe6CXIa4i+GxQqeyV4ua
         /1XAVJM9QHDEUypjS12+Gjqw2FS0c8B3grqKsIj6A6Duz/G5czS9MsPVFmrJgLVKWj9R
         /awSa3Kyt8TvcV1DR0Ut/pld50BFSflDaHHP+HdB85Uu1CM6wGu3Ay6FgHdX7P++osUH
         2A/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965944; x=1758570744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vg42YXvjHFhdSPyd/4e9YIQchkUAG0NxSAV9DDvIrlA=;
        b=dM0dnO3VYzSSz8ipxS+geH3yAvNjADIEN6KNWg3OAu1mUfW0AG1WcSy1KBSQQNYp6v
         OdMUomWm6i+5AChBy7mzZ3AxptjUnbbNRPWzBQkl+SQix4enwuUjf9VeFVG8DSt1/dAZ
         cJijqsuc6Bc7px/XLGdWpc1JU2sOqkptb3Dj/BTFyuNVm7gk5NXqm2uQc8ZpAWyXt9bK
         33agCGcvFySNiDCgSWur1olI2Gz3Ib2Uu/qhrgxZP3OXcKRdwkSG1J6HbN58q6w7Nud0
         vFYIL/v+rNsBCn/Q86/eWTA3ZjbHA7MyztUFEi/cdQykfxEfFEt66xh3ufT3BuKbxZZm
         zsZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVId2OiTdDziuIKyNljgKd4ig116QWA374rdpIlwnqUdact4GsR31Yu6aDIeeTDz4IT0D4t2Cxn7w==@kvack.org
X-Gm-Message-State: AOJu0Yzb0xgcyI7hdWT4IKJPjiJ1drjiHNfCwPUGmgeVxp/cu5z/x8cM
	wbnDH639pnuSuu6F9ZnUev8xRE2h7qvvLVXIk8fkHqBnJ5J2FgUcnqWqm++4d5AejkCGKy9EFA=
	=
X-Google-Smtp-Source: AGHT+IFLZf3/R1udLdGzfNx7SuklFJxoiGyP5wz+2NArO8lgYrlOW7Rh8Rc5osSmdBqt/k2sJfzU7IDn
X-Received: from pjn16.prod.google.com ([2002:a17:90b:5710:b0:32d:d956:20fb])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:228f:b0:24c:be1f:c204
 with SMTP id d9443c01a7336-25d24da3763mr151368475ad.22.1757965944068; Mon, 15
 Sep 2025 12:52:24 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:45 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-5-fvdl@google.com>
Subject: [RFC PATCH 04/12] mm/cma: keep a global sorted list of CMA ranges
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A447100014
X-Stat-Signature: t3hbd5g8u9aeost4uzws9ideqfjecy51
X-Rspam-User: 
X-HE-Tag: 1757965945-490514
X-HE-Meta: U2FsdGVkX183Bq7NBtLE/idEFclU08BwvHFAZb6D1gEvfjQBRGeUpBD149GEVfTm2R8qUTHEmsenz6s5LPBDBilKWOSzMsTc+VDP+2gYjbCkZx8prxZ3yhvg1yUs/9vq+dVPNF9p1NLGqsS4gJSghN6VHMuQ9esrlEC8tGpWt6O7ayXrJhEv78xdhlH5JsSAN0JxnrB8bXpYJHVHgLS8OW/qy27BYTG0e84Djz6wU9KU2u/kezINKjgERIXLpLjSV32DTJcXSuhxGGHGA7NN5tHesb1QFyemFZZAl4OhIxyMGWUknhovGeteOmIPk8XZT0bX3oJ/b9W6bHmWLwtyM08mc0PWnKj9KNuhsK9nBk+Kw/LEKKAdnLu+V/uOpC0QNbMct2h6H+5mVYnBTFOdkiMpCnfJzEx79mP/m15+JxZLiQD1HDswdt/2xZHqR1qxywGbWq64ywrexUM0jq/pFRSs1mochZtmWTpWNsZAPXQJFHmE/E/L90+Ss7w48+BAJ2xb3g6KHz7Op8mBVGXv6A0tNk3VW8h6eHAzjRIffH52QcgWVMBYPTxXxnzei8u3PcglSN04fxTU77YR5mAglKZgIJaGFmHkPK/PVwsHmz4pYOR8ZBqp9y6oHgN4k++28AApUAUsbM47YoWCRE5OPNpvUMouT4qCAFngp96Hwu6yahW1LSsDy/vte7EqDCM+Ip+EEB+azOusmlgHwPQx8wv3ua327c7C7Ca7CzHMfpskjZWzAmEsv4fRYK/FQC/7x8OPOVjcBqF2EJ1/4twVMD0zHmClNMz/NuuekQy8a3Hg50OD+Bl4Es4MXla+XCPKiJc2gJwVannZLS2j4u0NlNvKoYp5HuyVsYLlpgD0jPzP+hotDcSGCYiARnjdvxQmp8eT2ME6eNZZkqpe/8noCt/u5YNDGooB2v//9jvFvJ4nxZK8K8Uh2o6DLwj8VEaKUYHLpTECcOxdsOxDQm3
 zI+h2thK
 jbFwI4ybiypGXOhaS+T0l18ezg55J6QOYDUOGnpAUsfqZ4UZaUlPvrynxzpX1XB9llqsEE7FrVoYfCv1Akm55MBtP+bHPdhuyVKePtHcQMAsvn8iOjWIrB7gw79QvGypChHHHZJFpu2QkBb5EUTyLsKnJWgXdSujbugXFwJ8+PENfd805qC665ga8u0ooxoTET4NwsqL6wov88eh+/urP8VGZteyV5X0GM9LTQtTmK9hJ2X6j0SyLZD5yrpGR+lBE+fcsBS7cTDA3SNJqlX15aw5vDOfkR5BKtArAEYKXGF7bRphW155oMKyJUWzwFulwUSfrwukMhCgnU6B7py7AV8TMsqfLyNmZSgsRtTJ72GeCrXrrvsBWY7PGOdw3QoggNXGrBvxXei5zEUbDDAIcI4WyL1BdJOiIXzc8ranWFo/mqx5koUePaIqcZ/LMrN9diOMd+qeMbfnZS+565hrVEDYCCUEIEXHb/vpzpxqvr7J2lS8AxYtrUWUUfR3iya6Rkf4aS69inlTA/Y51UWhcsBeaWOgewT9kQkfvDo5pF77yd2GcWP8BAr1eOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to walk through CMA areas efficiently, it is useful
to keep a global sorted list of ranges.

Create this list when activating the areas.

Since users of this list may want to reference the CMA area
the range came from, there needs to be a link from the range
to that area. So, store a pointer to the CMA structure in
the cma_memrange structure. This also reduces the number
of arguments to a few internal functions.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 mm/cma.c | 72 ++++++++++++++++++++++++++++++++++++++++++--------------
 mm/cma.h |  6 ++---
 2 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 00d8d365f0b5..1f5a7bfc9152 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -23,6 +23,7 @@
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/string_choices.h>
+#include <linux/sort.h>
 #include <linux/log2.h>
 #include <linux/cma.h>
 #include <linux/highmem.h>
@@ -65,12 +66,11 @@ static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
  * Find the offset of the base PFN from the specified align_order.
  * The value returned is represented in order_per_bits.
  */
-static unsigned long cma_bitmap_aligned_offset(const struct cma *cma,
-					       const struct cma_memrange *cmr,
+static unsigned long cma_bitmap_aligned_offset(const struct cma_memrange *cmr,
 					       unsigned int align_order)
 {
 	return (cmr->base_pfn & ((1UL << align_order) - 1))
-		>> cma->order_per_bit;
+		>> cmr->cma->order_per_bit;
 }
 
 static unsigned long cma_bitmap_pages_to_bits(const struct cma *cma,
@@ -79,11 +79,12 @@ static unsigned long cma_bitmap_pages_to_bits(const struct cma *cma,
 	return ALIGN(pages, 1UL << cma->order_per_bit) >> cma->order_per_bit;
 }
 
-static void cma_clear_bitmap(struct cma *cma, const struct cma_memrange *cmr,
+static void cma_clear_bitmap(const struct cma_memrange *cmr,
 			     unsigned long pfn, unsigned long count)
 {
 	unsigned long bitmap_no, bitmap_count;
 	unsigned long flags;
+	struct cma *cma = cmr->cma;
 
 	bitmap_no = (pfn - cmr->base_pfn) >> cma->order_per_bit;
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
@@ -147,8 +148,7 @@ static void __init cma_activate_area(struct cma *cma)
 	for (allocrange = 0; allocrange < cma->nranges; allocrange++) {
 		cmr = &cma->ranges[allocrange];
 		early_pfn[allocrange] = cmr->early_pfn;
-		cmr->bitmap = bitmap_zalloc(cma_bitmap_maxno(cma, cmr),
-					    GFP_KERNEL);
+		cmr->bitmap = bitmap_zalloc(cma_bitmap_maxno(cmr), GFP_KERNEL);
 		if (!cmr->bitmap)
 			goto cleanup;
 	}
@@ -199,12 +199,45 @@ static void __init cma_activate_area(struct cma *cma)
 	pr_err("CMA area %s could not be activated\n", cma->name);
 }
 
+static struct cma_memrange **cma_ranges;
+static int cma_nranges;
+
+static int cmprange(const void *a, const void *b)
+{
+	struct cma_memrange *r1, *r2;
+
+	r1 = *(struct cma_memrange **)a;
+	r2 = *(struct cma_memrange **)b;
+
+	if (r1->base_pfn < r2->base_pfn)
+		return -1;
+	return r1->base_pfn - r2->base_pfn;
+}
+
 static int __init cma_init_reserved_areas(void)
 {
-	int i;
+	int i, r, nranges;
+	struct cma *cma;
+	struct cma_memrange *cmr;
+
+	nranges = 0;
+	for (i = 0; i < cma_area_count; i++) {
+		cma = &cma_areas[i];
+		nranges += cma->nranges;
+		cma_activate_area(cma);
+	}
+
+	cma_ranges = kcalloc(nranges, sizeof(*cma_ranges), GFP_KERNEL);
+	cma_nranges = 0;
+	for (i = 0; i < cma_area_count; i++) {
+		cma = &cma_areas[i];
+		for (r = 0; r < cma->nranges; r++) {
+			cmr = &cma->ranges[r];
+			cma_ranges[cma_nranges++] = cmr;
+		}
+	}
 
-	for (i = 0; i < cma_area_count; i++)
-		cma_activate_area(&cma_areas[i]);
+	sort(cma_ranges, cma_nranges, sizeof(*cma_ranges), cmprange, NULL);
 
 	return 0;
 }
@@ -297,6 +330,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	cma->ranges[0].base_pfn = PFN_DOWN(base);
 	cma->ranges[0].early_pfn = PFN_DOWN(base);
 	cma->ranges[0].count = cma->count;
+	cma->ranges[0].cma = cma;
 	cma->nranges = 1;
 	cma->nid = NUMA_NO_NODE;
 
@@ -687,6 +721,7 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 		cmrp->base_pfn = PHYS_PFN(mlp->base);
 		cmrp->early_pfn = cmrp->base_pfn;
 		cmrp->count = size >> PAGE_SHIFT;
+		cmrp->cma = cma;
 
 		sizeleft -= size;
 		if (sizeleft == 0)
@@ -772,7 +807,7 @@ static void cma_debug_show_areas(struct cma *cma)
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 
-		nbits = cma_bitmap_maxno(cma, cmr);
+		nbits = cma_bitmap_maxno(cmr);
 
 		pr_info("range %d: ", r);
 		for_each_clear_bitrange(start, end, cmr->bitmap, nbits) {
@@ -786,9 +821,9 @@ static void cma_debug_show_areas(struct cma *cma)
 	spin_unlock_irq(&cma->lock);
 }
 
-static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
-				unsigned long count, unsigned int align,
-				struct page **pagep, gfp_t gfp)
+static int cma_range_alloc(struct cma_memrange *cmr,
+			   unsigned long count, unsigned int align,
+			   struct page **pagep, gfp_t gfp)
 {
 	unsigned long mask, offset;
 	unsigned long pfn = -1;
@@ -796,10 +831,11 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
 	int ret = -EBUSY;
 	struct page *page = NULL;
+	struct cma *cma = cmr->cma;
 
 	mask = cma_bitmap_aligned_mask(cma, align);
-	offset = cma_bitmap_aligned_offset(cma, cmr, align);
-	bitmap_maxno = cma_bitmap_maxno(cma, cmr);
+	offset = cma_bitmap_aligned_offset(cmr, align);
+	bitmap_maxno = cma_bitmap_maxno(cmr);
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 
 	if (bitmap_count > bitmap_maxno)
@@ -840,7 +876,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 			break;
 		}
 
-		cma_clear_bitmap(cma, cmr, pfn, count);
+		cma_clear_bitmap(cmr, pfn, count);
 		if (ret != -EBUSY)
 			break;
 
@@ -879,7 +915,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	for (r = 0; r < cma->nranges; r++) {
 		page = NULL;
 
-		ret = cma_range_alloc(cma, &cma->ranges[r], count, align,
+		ret = cma_range_alloc(&cma->ranges[r], count, align,
 				       &page, gfp);
 		if (ret != -EBUSY || page)
 			break;
@@ -1011,7 +1047,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		return false;
 
 	free_contig_range(pfn, count);
-	cma_clear_bitmap(cma, cmr, pfn, count);
+	cma_clear_bitmap(cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
 
diff --git a/mm/cma.h b/mm/cma.h
index 25b696774c6a..384d1109d438 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -30,6 +30,7 @@ struct cma_memrange {
 		unsigned long early_pfn;
 		unsigned long *bitmap;
 	};
+	struct cma *cma;
 #ifdef CONFIG_CMA_DEBUGFS
 	struct debugfs_u32_array dfs_bitmap;
 #endif
@@ -67,10 +68,9 @@ struct cma {
 extern struct cma cma_areas[MAX_CMA_AREAS];
 extern unsigned int cma_area_count;
 
-static inline unsigned long cma_bitmap_maxno(struct cma *cma,
-		struct cma_memrange *cmr)
+static inline unsigned long cma_bitmap_maxno(struct cma_memrange *cmr)
 {
-	return cmr->count >> cma->order_per_bit;
+	return cmr->count >> cmr->cma->order_per_bit;
 }
 
 #ifdef CONFIG_CMA_SYSFS
-- 
2.51.0.384.g4c02a37b29-goog


