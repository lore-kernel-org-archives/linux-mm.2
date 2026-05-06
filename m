Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8CBCD3440
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E6E6B0095; Wed,  6 May 2026 10:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE176B0096; Wed,  6 May 2026 10:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDEF6B0098; Wed,  6 May 2026 10:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32CAA6B0095
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:21:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B052BA0292
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:21:11 +0000 (UTC)
X-FDA: 84737207142.12.76FDAF1
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id 89C38140010
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:21:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HHOjKVew;
	spf=pass (imf26.hostedemail.com: domain of 3VE77aQsKCDUaffenfebReXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--joonwonkang.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3VE77aQsKCDUaffenfebReXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778077269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHxAk6foOwWMJsosGIydiTLnBWfyQbJGisbPdt2LIqI=;
	b=rit9ZlfOWuqUxZ3D0gFKt31CcoYurH9FRCOklGYTPjSnoefkpSRgDXwaak1uLa7oQ0hCy6
	AZtp/RGYNx02kCgGWANkoiwuos69RiJhpSBiiBb77S+99DorlOxhsgo9FVw0crdfRLQqRE
	OIw4WJ7IDM/OA8co6qh7zg4uYmfVCZY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HHOjKVew;
	spf=pass (imf26.hostedemail.com: domain of 3VE77aQsKCDUaffenfebReXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--joonwonkang.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3VE77aQsKCDUaffenfebReXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778077269; a=rsa-sha256;
	cv=none;
	b=lVOYHPnv/S5TrctnHYI4MYnLJHZuITpEK4V+vrbUiasU/l1GkOcx1XCuCHKPM5baK+0hPB
	U6/GqvvJ4AKYOPqXhV2mqL7mtAmoD9f2f3kmOARJQrz1XqbwwnyUCGHY+7Me7AkzCiNhzL
	Up9nvyWpDYNqSYuCrdf7L4iYhrVF2+g=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c82353e8c63so927385a12.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 07:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778077268; x=1778682068; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NHxAk6foOwWMJsosGIydiTLnBWfyQbJGisbPdt2LIqI=;
        b=HHOjKVewapKLIrg44sVLv36U59NegQdcTDVzNCVTAyhT4EhHnXiWiMZvAqDqibV6OZ
         CJGaGAo9HDZpzdcZBWDG/WbompYFi1/+foVQ6IQPEGaqebcO1xTzgmppb1H/LJg9v3oX
         B3pCafs/uQ/AC73VLSUp5d3d26u+6N0B8Fw5Y5f4tbA+2hLNqPGMW/hAv8VBC3CVLJiN
         HDsFX/ZjRIz5JkoLFCQl4BVqBet83ASQbfLRLw5+Y/o91W9OcX/5eTgIo9zoD/F+3I8n
         SnrOXDgsH1aKMhzv3DiBebFa5c+ZgHEtTFmWTOVyoFkCZUezKwR6BkPB0ytoUI0oLJmA
         o0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778077268; x=1778682068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NHxAk6foOwWMJsosGIydiTLnBWfyQbJGisbPdt2LIqI=;
        b=ETUrTyjFAfo2IopYBl7yv3UJCP0EHvMQnn3P1lUQ0lXyi9rPcw5urG0V7LPS77ySLw
         kGHOavwBoU0iSW1Oh+bMletoEplIerLptGtMjVllS9V8EvI9WZ4rwDiRzBZxts0v9rf8
         o2h+5oS+MPG9KTEbGJiEXHRthjpHgsPOb1Im7dI8mQ7+qBT5pQ2OGiFERYlp2L6OzLFn
         jxWUno/eIj6tV3mW1uHActEplV3dLlEWhbJ1V/lbm6tQvel32ysSEYMQL4rhZ9LQTYyq
         1La0Ig2waP/XJBEa0P/cfYnDs0ciFR/Lgz0ieIHu9NCWhfs+fKUQSv04+UgEQ398DIum
         iWyQ==
X-Forwarded-Encrypted: i=1; AFNElJ8clB2zw1utFS7T5vr9ARy3xuFVwkqfD8R62snwoZXVyAhAQcK3gQq2P3u7rn8uEk7wJxNZgDzfeg==@kvack.org
X-Gm-Message-State: AOJu0YwI01o2edpPKTaXgfqoNahHraI6zfEwsgE1Rx/WLPoolAZn+fmZ
	CU47E9e4ixd0OtdN23oqZIrTqojQnQcADyrOvdajD/PzlGXqzvBDX9BZtagYyr+d9YtOOB2l+59
	HuNMQ1IkK85CriCv5nR4NeThEyw==
X-Received: from pgc13.prod.google.com ([2002:a05:6a02:2f8d:b0:c82:295e:3b44])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a05:b0:3a2:f05a:7952 with SMTP id adf61e73a8af0-3aa5ac439c2mr3923379637.39.1778077268107;
 Wed, 06 May 2026 07:21:08 -0700 (PDT)
Date: Wed,  6 May 2026 14:20:58 +0000
In-Reply-To: <20260506142100.1289509-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260506142100.1289509-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260506142100.1289509-3-joonwonkang@google.com>
Subject: [PATCH v4 3/4] percpu: Introduce struct pcpu_region
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 89C38140010
X-Rspam-User: 
X-Stat-Signature: 8gaqsefwa3185nywdxfkfru44635ohir
X-HE-Tag: 1778077269-769290
X-HE-Meta: U2FsdGVkX1/s8kcViARtYLQcIZHsK3X6nDZfsAyQgk338MYGtpfU4J/KwlMhlPS2WGXxDnyxHCL+m5lZQmDB+90MWiJisuUsA6UUwe0gPd4zipb3EAuFZcbCprsdX82n8cAsHbF7GvHUxtz9kGXKTgx6Uv+8YYtuSygBgqF+BtL/zNbraqxH/MhFpuqcmjXrpHD7DQJZjyh1F5ztYEh7t55yHLs56FwxOUW9jbyimRiSIwY6tgLCY8NusD3pnxaTxQUWQ5AfeXPo/nxAbsbimMPTMTKwXTGBKRS5BU7cBvjWG4Rbbg8Zy5SF8r3epbEisbpgI4iKfqW0IUrxhZr8wWLaNpe2zYAknOJKPUH/oaihgaSTRsFshgSKCedaWOHGWhKXoFOKpVztfQVggc6R/oOJWhKyN1Tavu8i6PY1bOpWoRc1gAueRFQ8KGwhx4kMVLz+rjuN1UDJSBsjsMaZrzAzUXPPQ8t0DorPOSG4xbNJ95ADCMe6mmALb3NKGzbtXsb4icFAsT3KizpFn/nNsbqpfd0OiIMSVme9MkgkpKnpbuHDgFQ765MdfvwbUyFTsAaAsYB2XQxBjuM+GCQyl89ohNucAcn+TneyMV+hp4XA7bzXJ6bFBXdIqfeozptXyfwDJwNUeSqixkYDEDboVLfmCqg3wsdl/7aroSLr2C1yTCzwsiDGNVZHOirZPPxmNC0BzeHRJw2NG4pjrqE1RHbgR4CPLrdXfL9ZKspFEK5PEwJ7Bp9uvAutMoc7ZQAWKh+5NEKF/LZCFXVuIpvrZQ/lOlnpfFJ5+JyT7B0PkaYrPzYeek2TyfH+Qb4tNDqIGhFQJF4r3y2/St+3cSWJPD+dT6Ay8kPKErfzYB7gWHcHBepkxZgUrbI32mc9aeHylx3sGwJ8Z1l4wAXu9WgBhNCH+sjd8rbTNWo5zf/Iqgky2i+iTGx0hmTGQVUeyEUxkVhdPXeUdD9UhUZzURC
 usbDd7cy
 K4ZKjlosS6lkoC0gSODcK7WJryVD+ioAcJ/jMcFtqoRsPF9LjfpDWPDTPnCZKe4VMJZ68y3uOPIvhegu/5xf9HSPzqnrfW+vwLxRAowRzvrnBZgwqdP4VhlzyGhGSqfoxBDnf8BHJbVsSeXJBQdfGELus10DIJjGLW8YpXpioz4SCAflOtu054mVrn5VZ7Cf4qTOCd+dCHaEXCla9yW7QQB+hryi6M5/M+LQcb3DUFCNfO5bdfmX88Eii0ivxzPjkXFKUakQ9qTSG2vT6U5fHTvvr9QXfFEg3wnkR+p9TFbQYyyM98Rgm+70uTV9wXTSN+HnMsY4WLMg05yVbWVo+gvTMwiJdLfmkidZcMGhuJ+INYi8YvO0ZcMFhp2mNXIYSamrPjKub3p4q6zFf+ItQUBOBslreJ4x/t7QAyfh5x3cUr26bRXriZghg2MO1cAu0BhONf5kEMYu2lUAWlYOgZq8rdtImTEZkvcBY0SyK5LrGqDIPqZgZV6IK75CQnw27p/cDqSaAjMztRIittgiQOgt++wmSp84AOF2fY+P6oA0GdLJKv18mRrYoEeB5/RP0Vl9pYDLZOmcCinfmgouXMPNGCpoxL8dl1sHM/s2BIa6fu2/FjEEEE7iOM2YJ5ff1TFrIFXf0UbqMQS1hxToj/QhoKsezrR1VNF6b5GM6iISV3TAmrX4fMiVU7sOMtrMk/+/gE9iZGIOYeGC4U0nyKQ3053wjTfq3sc2UlwqlvMKOi8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new struct is introduced to prevent mis-use of hint start and size
and improve readability.

Link: https://lore.kernel.org/all/aegQgyf3KuIZMK9x@palisades.local/
Suggested-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
---
v4: Initial version.

 mm/percpu-internal.h |  24 ++--
 mm/percpu.c          | 279 +++++++++++++++++++++----------------------
 2 files changed, 148 insertions(+), 155 deletions(-)

diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 4b3d6ec43703..dd95ec2c243a 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -6,6 +6,15 @@
 #include <linux/percpu.h>
 #include <linux/memcontrol.h>
 
+/*
+ * pcpu region represents a hint region.
+ * A region is only valid when @size is greater than 0.
+ */
+struct pcpu_region {
+	int start;
+	int size;
+};
+
 /*
  * pcpu_block_md is the metadata block struct.
  * Each chunk's bitmap is split into a number of full blocks.
@@ -13,17 +22,14 @@
  *
  * The scan hint is the largest known contiguous area before the contig hint.
  * It is not necessarily the actual largest contig hint though.  There is an
- * invariant that the scan_hint_start > contig_hint_start iff
- * scan_hint == contig_hint.  This is necessary because when scanning forward,
- * we don't know if a new contig hint would be better than the current one.
+ * invariant that the scan_hint.start > contig_hint.start iff
+ * scan_hint.size == contig_hint.size.  This is necessary because when scanning
+ * forward, we don't know if a new contig hint would be better than the current
+ * one.
  */
 struct pcpu_block_md {
-	int			scan_hint;	/* scan hint for block */
-	int			scan_hint_start; /* block relative starting
-						    position of the scan hint */
-	int                     contig_hint;    /* contig hint for block */
-	int                     contig_hint_start; /* block relative starting
-						      position of the contig hint */
+	struct pcpu_region	scan_hint;	/* scan hint for block */
+	struct pcpu_region	contig_hint;	/* contig hint for block */
 	int                     left_free;      /* size of free space along
 						   the left side of the block */
 	int                     right_free;     /* size of free space along
diff --git a/mm/percpu.c b/mm/percpu.c
index 0f6dd5260f56..0f5648669cac 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -244,10 +244,11 @@ static int pcpu_chunk_slot(const struct pcpu_chunk *chunk)
 	const struct pcpu_block_md *chunk_md = &chunk->chunk_md;
 
 	if (chunk->free_bytes < PCPU_MIN_ALLOC_SIZE ||
-	    chunk_md->contig_hint == 0)
+	    chunk_md->contig_hint.size == 0)
 		return 0;
 
-	return pcpu_size_to_slot(chunk_md->contig_hint * PCPU_MIN_ALLOC_SIZE);
+	return pcpu_size_to_slot(chunk_md->contig_hint.size *
+				 PCPU_MIN_ALLOC_SIZE);
 }
 
 /* set the pointer to a chunk in a page struct */
@@ -317,10 +318,10 @@ static unsigned long pcpu_block_off_to_off(int index, int off)
 static bool pcpu_check_block_hint(struct pcpu_block_md *block, int bits,
 				  size_t align)
 {
-	int bit_off = ALIGN(block->contig_hint_start, align) -
-		block->contig_hint_start;
+	int bit_off = ALIGN(block->contig_hint.start, align) -
+		      block->contig_hint.start;
 
-	return bit_off + bits <= block->contig_hint;
+	return bit_off + bits <= block->contig_hint.size;
 }
 
 /*
@@ -330,7 +331,7 @@ static bool pcpu_check_block_hint(struct pcpu_block_md *block, int bits,
  *
  * This determines if we should scan based on the scan_hint or first_free.
  * In general, we want to scan from first_free to fulfill allocations by
- * first fit.  However, if we know a scan_hint at position scan_hint_start
+ * first fit.  However, if we know a scan_hint at position scan_hint.start
  * cannot fulfill an allocation, we can begin scanning from there knowing
  * the contig_hint will be our fallback.
  */
@@ -340,13 +341,13 @@ static int pcpu_next_hint(struct pcpu_block_md *block, int alloc_bits)
 	 * The three conditions below determine if we can skip past the
 	 * scan_hint.  First, does the scan hint exist.  Second, is the
 	 * contig_hint after the scan_hint (possibly not true iff
-	 * contig_hint == scan_hint).  Third, is the allocation request
-	 * larger than the scan_hint.
+	 * contig_hint.size == scan_hint.size).  Third, is the allocation
+	 * request larger than the scan_hint.
 	 */
-	if (block->scan_hint &&
-	    block->contig_hint_start > block->scan_hint_start &&
-	    alloc_bits > block->scan_hint)
-		return block->scan_hint_start + block->scan_hint;
+	if (block->scan_hint.size &&
+	    block->contig_hint.start > block->scan_hint.start &&
+	    alloc_bits > block->scan_hint.size)
+		return block->scan_hint.start + block->scan_hint.size;
 
 	return block->first_free;
 }
@@ -388,11 +389,11 @@ static void pcpu_next_md_free_region(struct pcpu_chunk *chunk, int *bit_off,
 		 * the next block and should be handled by the contig area
 		 * across blocks code.
 		 */
-		*bits = block->contig_hint;
-		if (*bits && block->contig_hint_start >= block_off &&
-		    *bits + block->contig_hint_start < PCPU_BITMAP_BLOCK_BITS) {
-			*bit_off = pcpu_block_off_to_off(i,
-					block->contig_hint_start);
+		*bits = block->contig_hint.size;
+		if (*bits && block->contig_hint.start >= block_off &&
+		    *bits + block->contig_hint.start < PCPU_BITMAP_BLOCK_BITS) {
+			*bit_off = pcpu_block_off_to_off(
+				i, block->contig_hint.start);
 			return;
 		}
 		/* reset to satisfy the second predicate above */
@@ -437,19 +438,18 @@ static void pcpu_next_fit_region(struct pcpu_chunk *chunk, int alloc_bits,
 		}
 
 		/* check block->contig_hint */
-		*bits = ALIGN(block->contig_hint_start, align) -
-			block->contig_hint_start;
+		*bits = ALIGN(block->contig_hint.start, align) -
+			block->contig_hint.start;
 		/*
 		 * This uses the block offset to determine if this has been
 		 * checked in the prior iteration.
 		 */
-		if (block->contig_hint &&
-		    block->contig_hint_start >= block_off &&
-		    block->contig_hint >= *bits + alloc_bits) {
+		if (block->contig_hint.size &&
+		    block->contig_hint.start >= block_off &&
+		    block->contig_hint.size >= *bits + alloc_bits) {
 			int start = pcpu_next_hint(block, alloc_bits);
 
-			*bits += alloc_bits + block->contig_hint_start -
-				 start;
+			*bits += alloc_bits + block->contig_hint.start - start;
 			*bit_off = pcpu_block_off_to_off(i, start);
 			return;
 		}
@@ -604,17 +604,16 @@ static inline void pcpu_update_empty_pages(struct pcpu_chunk *chunk, int nr)
 
 /*
  * pcpu_region_overlap - determines if two regions overlap
- * @a: start of first region, inclusive
- * @b: end of first region, exclusive
- * @x: start of second region, inclusive
- * @y: end of second region, exclusive
+ * @a: first region
+ * @b: second region
  *
- * This is used to determine if the hint region [a, b) overlaps with the
- * allocated region [x, y).
+ * This is used to determine if the hint region [a.start, a.start + a.size)
+ * overlaps with the allocated region [b.start, b.start + b.size).
  */
-static inline bool pcpu_region_overlap(int a, int b, int x, int y)
+static inline bool pcpu_region_overlap(struct pcpu_region a,
+				       struct pcpu_region b)
 {
-	return (a < y) && (x < b);
+	return (a.start < b.start + b.size) && (b.start < a.start + a.size);
 }
 
 /**
@@ -629,56 +628,54 @@ static inline bool pcpu_region_overlap(int a, int b, int x, int y)
  */
 static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 {
-	int contig = end - start;
+	struct pcpu_region free = { .start = start, .size = end - start };
 
-	block->first_free = min(block->first_free, start);
-	if (start == 0)
-		block->left_free = contig;
+	block->first_free = min(block->first_free, free.start);
+	if (free.start == 0)
+		block->left_free = free.size;
 
-	if (end == block->nr_bits)
-		block->right_free = contig;
+	if (free.start + free.size == block->nr_bits)
+		block->right_free = free.size;
 
-	if (contig > block->contig_hint) {
+	if (free.size > block->contig_hint.size) {
 		/* promote the old contig_hint to be the new scan_hint */
-		if (block->contig_hint && start > block->contig_hint_start) {
-			if (block->contig_hint > block->scan_hint) {
-				block->scan_hint_start =
-					block->contig_hint_start;
+		if (block->contig_hint.size &&
+		    free.start > block->contig_hint.start) {
+			if (block->contig_hint.size > block->scan_hint.size) {
 				block->scan_hint = block->contig_hint;
-			} else if (block->scan_hint &&
-				   start < block->scan_hint_start) {
+			} else if (block->scan_hint.size &&
+				   free.start < block->scan_hint.start) {
 				/*
-				 * The old contig_hint == scan_hint.  But, the
-				 * new contig is larger so hold the invariant
-				 * scan_hint_start < contig_hint_start.
+				 * The old contig_hint.size == scan_hint.size.
+				 * But, the new contig is larger so hold the
+				 * invariant scan_hint.start <
+				 * contig_hint.start.
 				 */
-				block->scan_hint = 0;
+				block->scan_hint.size = 0;
 			}
 		} else {
-			block->scan_hint = 0;
+			block->scan_hint.size = 0;
 		}
-		block->contig_hint_start = start;
-		block->contig_hint = contig;
-	} else if (contig == block->contig_hint) {
-		if (block->contig_hint_start &&
-		    (!start ||
-		     __ffs(start) > __ffs(block->contig_hint_start))) {
-			/* start has a better alignment so use it */
-			block->contig_hint_start = start;
-			if (block->scan_hint &&
-			    start < block->scan_hint_start &&
-			    block->contig_hint > block->scan_hint)
-				block->scan_hint = 0;
-		} else if ((block->scan_hint &&
-			    start > block->scan_hint_start) ||
-			   block->contig_hint > block->scan_hint) {
+		block->contig_hint = free;
+	} else if (free.size == block->contig_hint.size) {
+		if (block->contig_hint.start &&
+		    (!free.start ||
+		     __ffs(free.start) > __ffs(block->contig_hint.start))) {
+			/* new start has a better alignment so use it */
+			block->contig_hint.start = free.start;
+			if (block->scan_hint.size &&
+			    free.start < block->scan_hint.start &&
+			    block->contig_hint.size > block->scan_hint.size)
+				block->scan_hint.size = 0;
+		} else if ((block->scan_hint.size &&
+			    free.start > block->scan_hint.start) ||
+			   block->contig_hint.size > block->scan_hint.size) {
 			/*
-			 * Knowing contig == contig_hint, update the scan_hint
-			 * if it is farther than or larger than the current
-			 * scan_hint.
+			 * Knowing new contig size == contig_hint.size, update
+			 * the scan_hint if it is farther than or larger than
+			 * the current scan_hint.
 			 */
-			block->scan_hint_start = start;
-			block->scan_hint = contig;
+			block->scan_hint = free;
 		}
 	} else {
 		/*
@@ -686,12 +683,11 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 		 * the scan_hint if it is larger than or equal and farther than
 		 * the current scan_hint.
 		 */
-		if ((start < block->contig_hint_start &&
-		     (contig > block->scan_hint ||
-		      (contig == block->scan_hint &&
-		       start > block->scan_hint_start)))) {
-			block->scan_hint_start = start;
-			block->scan_hint = contig;
+		if ((free.start < block->contig_hint.start &&
+		     (free.size > block->scan_hint.size ||
+		      (free.size == block->scan_hint.size &&
+		       free.start > block->scan_hint.start)))) {
+			block->scan_hint = free;
 		}
 	}
 }
@@ -741,8 +737,8 @@ static void pcpu_block_update_scan(struct pcpu_chunk *chunk, int bit_off,
  * Iterates over the metadata blocks to find the largest contig area.
  * A full scan can be avoided on the allocation path as this is triggered
  * if we broke the contig_hint.  In doing so, the scan_hint will be before
- * the contig_hint or after if the scan_hint == contig_hint.  This cannot
- * be prevented on freeing as we want to find the largest area possibly
+ * the contig_hint or after if the scan_hint.size == contig_hint.size.  This
+ * cannot be prevented on freeing as we want to find the largest area possibly
  * spanning blocks.
  */
 static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk, bool full_scan)
@@ -751,14 +747,13 @@ static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk, bool full_scan)
 	int bit_off, bits;
 
 	/* promote scan_hint to contig_hint */
-	if (!full_scan && chunk_md->scan_hint) {
-		bit_off = chunk_md->scan_hint_start + chunk_md->scan_hint;
-		chunk_md->contig_hint_start = chunk_md->scan_hint_start;
+	if (!full_scan && chunk_md->scan_hint.size) {
+		bit_off = chunk_md->scan_hint.start + chunk_md->scan_hint.size;
 		chunk_md->contig_hint = chunk_md->scan_hint;
-		chunk_md->scan_hint = 0;
+		chunk_md->scan_hint.size = 0;
 	} else {
 		bit_off = chunk_md->first_free;
-		chunk_md->contig_hint = 0;
+		chunk_md->contig_hint.size = 0;
 	}
 
 	bits = 0;
@@ -778,23 +773,23 @@ static void pcpu_block_refresh_hint(struct pcpu_chunk *chunk, int index)
 {
 	struct pcpu_block_md *block = chunk->md_blocks + index;
 	unsigned long *alloc_map = pcpu_index_alloc_map(chunk, index);
-	unsigned int start, end;	/* region start, region end */
+	unsigned int start, end; /* region start, region end */
 
 	/* promote scan_hint to contig_hint */
-	if (block->scan_hint) {
-		start = block->scan_hint_start + block->scan_hint;
-		block->contig_hint_start = block->scan_hint_start;
+	if (block->scan_hint.size) {
+		start = block->scan_hint.start + block->scan_hint.size;
 		block->contig_hint = block->scan_hint;
-		block->scan_hint = 0;
+		block->scan_hint.size = 0;
 	} else {
 		start = block->first_free;
-		block->contig_hint = 0;
+		block->contig_hint.size = 0;
 	}
 
 	block->right_free = 0;
 
 	/* iterate over free areas and update the contig hints */
-	for_each_clear_bitrange_from(start, end, alloc_map, PCPU_BITMAP_BLOCK_BITS)
+	for_each_clear_bitrange_from(start, end, alloc_map,
+				     PCPU_BITMAP_BLOCK_BITS)
 		pcpu_block_update(block, start, end);
 }
 
@@ -814,8 +809,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
 	int nr_empty_pages = 0;
 	struct pcpu_block_md *s_block, *e_block, *block;
-	int s_index, e_index;	/* block indexes of the freed allocation */
-	int s_off, e_off;	/* block offsets of the freed allocation */
+	int s_index, e_index; /* block indexes of the freed allocation */
+	int s_off, e_off; /* block offsets of the freed allocation */
 
 	/*
 	 * Calculate per block offsets.
@@ -834,7 +829,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	/*
 	 * Update s_block.
 	 */
-	if (s_block->contig_hint == PCPU_BITMAP_BLOCK_BITS)
+	if (s_block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS)
 		nr_empty_pages++;
 
 	/*
@@ -844,22 +839,16 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	 */
 	if (s_off == s_block->first_free)
 		s_block->first_free = find_next_zero_bit(
-					pcpu_index_alloc_map(chunk, s_index),
-					PCPU_BITMAP_BLOCK_BITS,
-					s_off + bits);
-
-	if (s_block->scan_hint &&
-	    pcpu_region_overlap(s_block->scan_hint_start,
-				s_block->scan_hint_start + s_block->scan_hint,
-				s_off,
-				s_off + bits))
-		s_block->scan_hint = 0;
-
-	if (pcpu_region_overlap(s_block->contig_hint_start,
-				s_block->contig_hint_start +
-				s_block->contig_hint,
-				s_off,
-				s_off + bits)) {
+			pcpu_index_alloc_map(chunk, s_index),
+			PCPU_BITMAP_BLOCK_BITS, s_off + bits);
+
+	struct pcpu_region s_region = { .start = s_off, .size = bits };
+
+	if (s_block->scan_hint.size &&
+	    pcpu_region_overlap(s_block->scan_hint, s_region))
+		s_block->scan_hint.size = 0;
+
+	if (pcpu_region_overlap(s_block->contig_hint, s_region)) {
 		/* block contig hint is broken - scan to fix it */
 		if (!s_off)
 			s_block->left_free = 0;
@@ -868,8 +857,9 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 		/* update left and right contig manually */
 		s_block->left_free = min(s_block->left_free, s_off);
 		if (s_index == e_index)
-			s_block->right_free = min_t(int, s_block->right_free,
-					PCPU_BITMAP_BLOCK_BITS - e_off);
+			s_block->right_free =
+				min_t(int, s_block->right_free,
+				      PCPU_BITMAP_BLOCK_BITS - e_off);
 		else
 			s_block->right_free = 0;
 	}
@@ -878,27 +868,27 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	 * Update e_block.
 	 */
 	if (s_index != e_index) {
-		if (e_block->contig_hint == PCPU_BITMAP_BLOCK_BITS)
+		if (e_block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS)
 			nr_empty_pages++;
 
 		/*
 		 * When the allocation is across blocks, the end is along
 		 * the left part of the e_block.
 		 */
-		e_block->first_free = find_next_zero_bit(
-				pcpu_index_alloc_map(chunk, e_index),
-				PCPU_BITMAP_BLOCK_BITS, e_off);
+		e_block->first_free =
+			find_next_zero_bit(pcpu_index_alloc_map(chunk, e_index),
+					   PCPU_BITMAP_BLOCK_BITS, e_off);
 
 		if (e_off == PCPU_BITMAP_BLOCK_BITS) {
 			/* reset the block */
 			e_block++;
 		} else {
-			if (e_block->scan_hint &&
-			    e_off > e_block->scan_hint_start)
-				e_block->scan_hint = 0;
+			if (e_block->scan_hint.size &&
+			    e_off > e_block->scan_hint.start)
+				e_block->scan_hint.size = 0;
 
 			e_block->left_free = 0;
-			if (e_off > e_block->contig_hint_start) {
+			if (e_off > e_block->contig_hint.start) {
 				/* contig hint is broken - scan to fix it */
 				pcpu_block_refresh_hint(chunk, e_index);
 			} else {
@@ -911,8 +901,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 		/* update in-between md_blocks */
 		nr_empty_pages += (e_index - s_index - 1);
 		for (block = s_block + 1; block < e_block; block++) {
-			block->scan_hint = 0;
-			block->contig_hint = 0;
+			block->scan_hint.size = 0;
+			block->contig_hint.size = 0;
 			block->left_free = 0;
 			block->right_free = 0;
 		}
@@ -927,24 +917,18 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	if (nr_empty_pages)
 		pcpu_update_empty_pages(chunk, -nr_empty_pages);
 
-	if (chunk_md->scan_hint &&
-	    pcpu_region_overlap(chunk_md->scan_hint_start,
-				chunk_md->scan_hint_start +
-				chunk_md->scan_hint,
-				bit_off,
-				bit_off + bits))
-		chunk_md->scan_hint = 0;
+	struct pcpu_region req_region = { .start = bit_off, .size = bits };
+
+	if (chunk_md->scan_hint.size &&
+	    pcpu_region_overlap(chunk_md->scan_hint, req_region))
+		chunk_md->scan_hint.size = 0;
 
 	/*
 	 * The only time a full chunk scan is required is if the chunk
 	 * contig hint is broken.  Otherwise, it means a smaller space
 	 * was used and therefore the chunk contig hint is still correct.
 	 */
-	if (pcpu_region_overlap(chunk_md->contig_hint_start,
-				chunk_md->contig_hint_start +
-				chunk_md->contig_hint,
-				bit_off,
-				bit_off + bits))
+	if (pcpu_region_overlap(chunk_md->contig_hint, req_region))
 		pcpu_chunk_refresh_hint(chunk, false);
 }
 
@@ -971,9 +955,9 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 {
 	int nr_empty_pages = 0;
 	struct pcpu_block_md *s_block, *e_block, *block;
-	int s_index, e_index;	/* block indexes of the freed allocation */
-	int s_off, e_off;	/* block offsets of the freed allocation */
-	int start, end;		/* start and end of the whole free area */
+	int s_index, e_index; /* block indexes of the freed allocation */
+	int s_off, e_off; /* block offsets of the freed allocation */
+	int start, end; /* start and end of the whole free area */
 
 	/*
 	 * Calculate per block offsets.
@@ -1000,8 +984,8 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 	 * or end of the block.
 	 */
 	start = s_off;
-	if (s_off == s_block->contig_hint + s_block->contig_hint_start) {
-		start = s_block->contig_hint_start;
+	if (s_off == s_block->contig_hint.size + s_block->contig_hint.start) {
+		start = s_block->contig_hint.start;
 	} else {
 		/*
 		 * Scan backwards to find the extent of the free area.
@@ -1015,8 +999,8 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 	}
 
 	end = e_off;
-	if (e_off == e_block->contig_hint_start)
-		end = e_block->contig_hint_start + e_block->contig_hint;
+	if (e_off == e_block->contig_hint.start)
+		end = e_block->contig_hint.start + e_block->contig_hint.size;
 	else
 		end = find_next_bit(pcpu_index_alloc_map(chunk, e_index),
 				    PCPU_BITMAP_BLOCK_BITS, end);
@@ -1038,9 +1022,11 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 		nr_empty_pages += (e_index - s_index - 1);
 		for (block = s_block + 1; block < e_block; block++) {
 			block->first_free = 0;
-			block->scan_hint = 0;
-			block->contig_hint_start = 0;
-			block->contig_hint = PCPU_BITMAP_BLOCK_BITS;
+			block->scan_hint.size = 0;
+			block->contig_hint = (struct pcpu_region){
+				.start = 0,
+				.size = PCPU_BITMAP_BLOCK_BITS,
+			};
 			block->left_free = PCPU_BITMAP_BLOCK_BITS;
 			block->right_free = PCPU_BITMAP_BLOCK_BITS;
 		}
@@ -1314,8 +1300,9 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 
 static void pcpu_init_md_block(struct pcpu_block_md *block, int nr_bits)
 {
-	block->scan_hint = 0;
-	block->contig_hint = nr_bits;
+	block->scan_hint = (struct pcpu_region){ .start = 0, .size = 0 };
+	block->contig_hint =
+		(struct pcpu_region){ .start = 0, .size = nr_bits };
 	block->left_free = nr_bits;
 	block->right_free = nr_bits;
 	block->first_free = 0;
@@ -2141,7 +2128,7 @@ static void pcpu_reclaim_populated(void)
 			 * (first) page in the chunk.
 			 */
 			block = chunk->md_blocks + i;
-			if (block->contig_hint == PCPU_BITMAP_BLOCK_BITS &&
+			if (block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS &&
 			    test_bit(i, chunk->populated)) {
 				if (end == -1)
 					end = i;
-- 
2.54.0.545.g6539524ca2-goog


