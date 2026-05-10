Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA23CD37B5
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 07:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B586B008C; Sun, 10 May 2026 03:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C3D6B0092; Sun, 10 May 2026 03:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830756B0093; Sun, 10 May 2026 03:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC036B008C
	for <linux-mm@kvack.org>; Sun, 10 May 2026 03:22:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEBBC12033B
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:22:00 +0000 (UTC)
X-FDA: 84750666000.25.87921D8
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id E74C31A0004
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:21:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DLMqIZ9P;
	spf=pass (imf19.hostedemail.com: domain of 3FTIAagsKCNA5AA9IA96w922AA270.yA8749GJ-886Hwy6.AD2@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3FTIAagsKCNA5AA9IA96w922AA270.yA8749GJ-886Hwy6.AD2@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778397719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qr9BPj6NAAK506UnwVdKGmOaYaMxCjmXId+Qx3B+WyE=;
	b=cg8yHl8hfK9/13aRYpAOm4PjV4PcgNGg3wWQsH+IBt6phzA26hZCU/jgmE99Tu/bOO05GD
	wC8Syw4ppokVTnaiA3reQO/+oezaurcibb0UPpJgVRkPl5o3jAqhTVG11wJWc8s1i4h+Vt
	Xl0hV9H8oGt4dclZICG9gkS/CN5X8KY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DLMqIZ9P;
	spf=pass (imf19.hostedemail.com: domain of 3FTIAagsKCNA5AA9IA96w922AA270.yA8749GJ-886Hwy6.AD2@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3FTIAagsKCNA5AA9IA96w922AA270.yA8749GJ-886Hwy6.AD2@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778397719; a=rsa-sha256;
	cv=none;
	b=y+zZizYq/9SHWz3NXQKALSiZYg7LW2JQlB/do2wj+T0HIVIDtIRN51+jh45tUSoodJOCQD
	O8xLUK7FShd5kQFcZYAOsXDtAbrKAOCfL4vnkav4iDGMGlLrpsDMP/JRJP4AeW5lExJNq8
	SZNgOms0mwPGLV3z1Qp1T3344uZSVfM=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8024fc7032so1614524a12.1
        for <linux-mm@kvack.org>; Sun, 10 May 2026 00:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778397718; x=1779002518; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qr9BPj6NAAK506UnwVdKGmOaYaMxCjmXId+Qx3B+WyE=;
        b=DLMqIZ9PezeoXWRkuKAqa9o571NDwUTVQb0izJclAdLx6f9Ee4wUDIJyBVwhJF5X1W
         mih7iLIidZ7OxMDv5ZdkLlpKQdixu0VCHnATq4E+ZGtPf4NLKtyGxpvM/B2hvzPB9q+4
         Gm2ea9mYhF2KcfiByBOqkZ0A9+9bPsRKLktHKF2l5nk8LRPgechp2ngj7+T1pYv+kHj/
         masEa/Xk/NYn2b2xl2rrAdEnuNwjm7IEnGUYJM47wiBvQr7oCXrGVrvl82Ms/7TJWq0C
         oaW0IFIC8rOF5xr+87tVKd+HBidEyN+F/edLkgebP/cXxf+nokVOYLxb63SaUijtgKSk
         5VWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778397718; x=1779002518;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qr9BPj6NAAK506UnwVdKGmOaYaMxCjmXId+Qx3B+WyE=;
        b=qpkUgUf7fMsVVd4tYA8ocZGeuAdgcqTc/XbFPUVYNTIoLJXY9SgkqMBbYobyg9J982
         3i0KGIXOIWLUfzg+tLVTx3cZ3zj4RfvDPbb0fpocNeQqCrNzqTg15rUDTMZGwp9GZHG/
         dq/fpcNaIUblNDqC5vA+tH2kRqbgozrEjKzv1JPCv9x+JTZ0fa7W46WUOWFLIKyLs7Dp
         H/RRawiuUDJbvCMwi7wV2tP3Z5Hv3MIJrvcXI7ES9Jt08qbIkDdRDdKan3DIOpsBoFO0
         3mauFSM4pJ2rqN2pX/uhsv5VOh2bBinp2vsIWUrs4gyYHFBPMT1cwtzoW91HktYjzwy4
         w/Ow==
X-Forwarded-Encrypted: i=1; AFNElJ/Z4kdmfw9Tu/+4ZUd5gTjrKdQvkDsTBWx3ohRACkDFb4/ONWP49JGmaqSacO73GQC5nLM4HyRL2A==@kvack.org
X-Gm-Message-State: AOJu0YwNdG6CQB6YzEytYCYqUgmZ73PxDBSshhgOUSUr9Gu32nboZCbD
	kAe9btCW1chup1yo9/lS1mEgd+e66rrKOyEoTllG/2nWNVsIYDKscPSCY7hJhoi+avARLGuULe3
	nON+AlDyR5mRJJvLE3JbNkeNVoA==
X-Received: from pgvi28.prod.google.com ([2002:a65:61bc:0:b0:c79:8016:512d])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:218a:b0:3a0:d88:6d6b with SMTP id adf61e73a8af0-3aa5ac0ddf5mr23703335637.49.1778397717698;
 Sun, 10 May 2026 00:21:57 -0700 (PDT)
Date: Sun, 10 May 2026 07:21:48 +0000
In-Reply-To: <20260510072149.1279887-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260510072149.1279887-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260510072149.1279887-3-joonwonkang@google.com>
Subject: [PATCH v5 3/4] percpu: Introduce struct pcpu_region
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wjgkti8e98c4gcucjs76gutpg68b3c4w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E74C31A0004
X-Rspam-User: 
X-HE-Tag: 1778397718-133185
X-HE-Meta: U2FsdGVkX1+TqwBpfKTcYTJNEL0YwLd262/KhMuGDC8ouxzvdx/3IEbOp4R9kueK34G5hbOKnKuInTid9WwkXJaVNH+a9CgSE6cWNFyUiBUxe6SYhSUMPaeF5HKZEtVfgKS1piWF6eWs54xJdu2vpopmXo/eVX/XRpwa4iz0LChfqW168YgtbCLv/fy11kNACOJQzvZ66LQhVrtv7L2yU8KJlCWkD+rpxF75r6ryIDoAOfzNcoU1VbFlJqtWh1kg11siJwvAfEqpSJrwDbOvOSOFmJNafHAKyITitVo95Ckgwh8UWHS3K3JwcX9+ptQ+ztdc56GLjxuZlYpRwl93VlOdELBVNcp4wMcbJVHw1tGwhmQ6TB9cjeNItvJobvCn0HYV1XxGUj9Vx+tXgwQJW38gr4ufKRLAaz8yirEdg5UgULeVUXvKWtEmt0kZ6YIex8/wImG1XmKhBlvFeq01s6wVfHOWE0+95HE/D1/AwkvGkqvA4qiDFqDS6vjCabtDbEVmJ9tJWW18hLznkBQoS0gZtxg/3G1rAGx8kWwg/yh8lUm9x2rfF2s08Vq6wK/ZubkQoH0CaZc6+VU+FiJr96Bu9vRX6WVayhXczivcAu25VOQOlk5EjY5Vqpteoc6QtlK0L/qsN8M/umHtgItULOGuM1XxSEbDrao3DoqHaT90N2c8qXHiK6miDFLq8iyR+8fo/PZfQsddPaLU672TwSxVuuebRR3UVoy5gemrIyORYqKGz3csu++OOb9JFCyg3bTpIeOUrEakq5RAjJaMHLv3qMvj58SS+boEsIjwzF5FqQTCZAhh5Tz8skVHAa0qIzodj1EdoZbMj5mMJshkW2fXaUwKVxv1Yhdy8Uqhm8bsMJP2lDZ/TviKvEhbLa+EY7QtL7O+t+VEjJon5bLoDsMd7YAh7iSuhuRxdiY2qANptY2GGakBDrR+D4PaVuuNMmmuwMpCE/wsTDUa0x3
 viioxip+
 zwbBhx3LlRgeUZbPimBVbxrGCa497zQci+lq9rsVnrvBhq7F2r4WIz5O+XPB/ldwpOlQeYBCaKcjvHJUYMswApX1FL3u7ScMm9mB1qrxKB3eBNHZ8XmSip/0Vsrrw3CjLE3BlB8J5LiiPkDHiz4QrbiU3of7QFN6SoJFUnO/+3AfIDOZE0eirkhcC37nCx7TcyEBIqcnO0Ar6uX4FO4JMIBQeYgnSwcjCmPN3T/kEaVFMR2rIf5s3eImwsBNOp66OCdQ+twNAMrkcyWAtmqpgbpdqMlc/lSlaIxbLMrGGDqaqxZXrC0YXAOzhy+B1s4fC3w00I49R6Ns9CEOWllv3Nv+BrfNNggjLUZzALYp3tiI/Jnm8YXoFGokNIwfqwH9olO4sahc0jV3z3MotRn6f4NoECEzVogTNGzr7GpegzXEvx0aN0HJldnodSSLuYuZ0WHIVmmVU85c7SwQ/cdRr4c1D+Z7UZ6p+jUqRhTeiZ593iUDMDwVf0vWlCiJ/aJSwOe5EKUIVzntuj16aD1kwlSlg0em2uAUMSYZVablB2YN1QnLiZ4/Vhs5sN54aCcA0kJJAF+alRXz6hPcnnSkdga4GIexbIIe65KqkXnuzlEkHqvTC/0RC5mscqODFwJnhKKQEYuLJfBl15XdVu+cNSoPHfw==
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
v5: Add missing change for mm/percpu-stats.c.
v4: Initial version.

 mm/percpu-internal.h |  24 +++--
 mm/percpu-stats.c    |   2 +-
 mm/percpu.c          | 244 ++++++++++++++++++++-----------------------
 3 files changed, 131 insertions(+), 139 deletions(-)

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
diff --git a/mm/percpu-stats.c b/mm/percpu-stats.c
index 9b9d5d6accae..4a735d09adef 100644
--- a/mm/percpu-stats.c
+++ b/mm/percpu-stats.c
@@ -122,7 +122,7 @@ static void chunk_map_stats(struct seq_file *m, struct pcpu_chunk *chunk,
 	P("empty_pop_pages", chunk->nr_empty_pop_pages);
 	P("first_bit", chunk_md->first_free);
 	P("free_bytes", chunk->free_bytes);
-	P("contig_bytes", chunk_md->contig_hint * PCPU_MIN_ALLOC_SIZE);
+	P("contig_bytes", chunk_md->contig_hint.size * PCPU_MIN_ALLOC_SIZE);
 	P("sum_frag", sum_frag);
 	P("max_frag", max_frag);
 	P("cur_min_alloc", cur_min_alloc);
diff --git a/mm/percpu.c b/mm/percpu.c
index 0f6dd5260f56..89b7f33500cf 100644
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
+		block->contig_hint.start;
 
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
+		*bits = block->contig_hint.size;
+		if (*bits && block->contig_hint.start >= block_off &&
+		    *bits + block->contig_hint.start < PCPU_BITMAP_BLOCK_BITS) {
 			*bit_off = pcpu_block_off_to_off(i,
-					block->contig_hint_start);
+					block->contig_hint.start);
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
@@ -781,14 +776,13 @@ static void pcpu_block_refresh_hint(struct pcpu_chunk *chunk, int index)
 	unsigned int start, end;	/* region start, region end */
 
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
@@ -834,7 +828,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	/*
 	 * Update s_block.
 	 */
-	if (s_block->contig_hint == PCPU_BITMAP_BLOCK_BITS)
+	if (s_block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS)
 		nr_empty_pages++;
 
 	/*
@@ -848,18 +842,13 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 					PCPU_BITMAP_BLOCK_BITS,
 					s_off + bits);
 
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
@@ -878,7 +867,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	 * Update e_block.
 	 */
 	if (s_index != e_index) {
-		if (e_block->contig_hint == PCPU_BITMAP_BLOCK_BITS)
+		if (e_block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS)
 			nr_empty_pages++;
 
 		/*
@@ -893,12 +882,12 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
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
@@ -911,8 +900,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
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
@@ -927,24 +916,18 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
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
 
@@ -1000,8 +983,8 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
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
@@ -1015,8 +998,8 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 	}
 
 	end = e_off;
-	if (e_off == e_block->contig_hint_start)
-		end = e_block->contig_hint_start + e_block->contig_hint;
+	if (e_off == e_block->contig_hint.start)
+		end = e_block->contig_hint.start + e_block->contig_hint.size;
 	else
 		end = find_next_bit(pcpu_index_alloc_map(chunk, e_index),
 				    PCPU_BITMAP_BLOCK_BITS, end);
@@ -1038,9 +1021,11 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
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
@@ -1314,8 +1299,9 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 
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
@@ -2141,7 +2127,7 @@ static void pcpu_reclaim_populated(void)
 			 * (first) page in the chunk.
 			 */
 			block = chunk->md_blocks + i;
-			if (block->contig_hint == PCPU_BITMAP_BLOCK_BITS &&
+			if (block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS &&
 			    test_bit(i, chunk->populated)) {
 				if (end == -1)
 					end = i;
-- 
2.54.0.563.g4f69b47b94-goog


