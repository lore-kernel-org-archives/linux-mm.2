Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1743CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BB46B0095; Wed, 13 May 2026 04:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73A86B0096; Wed, 13 May 2026 04:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89866B0098; Wed, 13 May 2026 04:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9D726B0095
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:51:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67AB61207B7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:51:29 +0000 (UTC)
X-FDA: 84761777898.07.8D4366D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id A66FB80003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:51:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nzm7b8s9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3jjsEagsKCG0UZZYhZYVLYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3jjsEagsKCG0UZZYhZYVLYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--joonwonkang.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l59ozyFO40IXAoWeYrtUkk6Jpy5oWCUh7Ai4pCgGDq8=;
	b=ixDeqi2xCVDQfdK6psOLRdSFaOkI7DxEqY1HTnFiwNjt3gkUzZZOlaKoMvHOP9L1AukD1/
	J9BrBz8jRmy02/6GtvzVskfmslWyjcJKW5LR8nxZRW6TPP+JPvhtcCt7BNgvFKkPWoA2EE
	vGmHFjo0Bd9JlVnexBpmWX6RPgzNM7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778662287; a=rsa-sha256;
	cv=none;
	b=h36wTHDQqlwYkBHzTqPQzg9Zl+XhbWvRm4L56TVLHmwbXowOVUmWDxAGrUV7QfbZd4vF5L
	VaQli49aakIjrd83D0MHv+OAET96TeFPdaSwWZ6TpiLFZMRYo+MrTWwlUAqfoQvVRhkEV8
	ZjvWA+bXqJ9Dt1FwUkOxGIbpJVuAjeo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nzm7b8s9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3jjsEagsKCG0UZZYhZYVLYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3jjsEagsKCG0UZZYhZYVLYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--joonwonkang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2baf7748d0aso58014825ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 01:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778662286; x=1779267086; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l59ozyFO40IXAoWeYrtUkk6Jpy5oWCUh7Ai4pCgGDq8=;
        b=Nzm7b8s9OSEZEfwxnOAs0U2/DpOeT3dilmnANWS9aw6uC+UuBZv8tej8126OHK+IdQ
         FPLp1zvvuKJwDr90ueDMzuibZgNT/lsckVZu4XYpmsv7XbuJqnFB62b6XakoMPYA+6G3
         erTgnSl/QU1UXoUU1Y9OK8ltukygD6Vgiq7VW1moyx2ooHI8jOVZF3Mx1nEnruUZMJnX
         jelZOtZT6/Rj0o3PaR4YcHrd6xcZ7+QNG4vP5QPuFGwtKhPoLLiB2Dh6sbev9pobGOKa
         dicXHAeCS7JNgTT6t05pivxhmX/eVEW2qjQXv68qfVK6x4iiO6v5uRkPKbc+dqvW7s1E
         KNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778662286; x=1779267086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l59ozyFO40IXAoWeYrtUkk6Jpy5oWCUh7Ai4pCgGDq8=;
        b=Mwa0w/9YxeHVQB8zIoXaRvoVHhTYCzH0RyViC4O50yI5b9sBqUUZty/qg3UbA8laOR
         UGlmreje61ja1+z4DqOkYWw6kzSvLJ7cOPXekxZB0Qiech+ZWknmrpwyo0QxSPFGHzvI
         dAVzYztv2Z13tAajNhKni+ZvPMeM48yx3jRkk6/ZTttMrLoaqmKN8YESRacsU5XioIYD
         LMyd0agENP9YgrIMJp8JYMjPquV5ZQDNV2lIK5E1Mga6FsJ3R65scigXfzwhsNdrdPVu
         +gipmZ7lX4WKvV6z5sNtFF8lRYjZKNqqMR0mHRyoDG4A9KYsdEzN6T3ZIBFJVMHPtJHq
         oZGg==
X-Forwarded-Encrypted: i=1; AFNElJ/TE0VlykHuviEr2kyUnzLx67T4ld448TTvDG3EXzycrSdgagz80Bgd3eZPSFSg8xHI55vNeBY+nw==@kvack.org
X-Gm-Message-State: AOJu0YxXyFWERs1U8ajO/iuE9Pf8PKXocpn1/ZZr8jpMrPPIYHFzK/kC
	aX0O9TDdXbdkCdYX+vaMJMp3K3Tm4xyUVqMgeyxlBY0q6wC+17PmVcWvf34TrIEOpdsHu8uhiu1
	q7GZsyfL710wESB6iVVbJ5bMgsQ==
X-Received: from plgq11.prod.google.com ([2002:a17:902:eb8b:b0:2b0:6cdd:87e2])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:8d81:b0:2ba:6ca2:be0 with SMTP id d9443c01a7336-2bd270fbeefmr17510195ad.4.1778662286157;
 Wed, 13 May 2026 01:51:26 -0700 (PDT)
Date: Wed, 13 May 2026 08:51:16 +0000
In-Reply-To: <20260513085117.1024175-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260513085117.1024175-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260513085117.1024175-4-joonwonkang@google.com>
Subject: [PATCH v6 4/4] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: A66FB80003
X-Rspamd-Server: rspam04
X-Stat-Signature: x51n7i5msdkbb3egd7aexzzbk1u4pund
X-HE-Tag: 1778662287-247794
X-HE-Meta: U2FsdGVkX19rcnpP5hJq2v6v7slzWOtSLL6AMEapi+VAfw4GD4vKuDTZOo9SsNzPyYavkMsQzTPjkasNBRbRVFZutxcisMthxUEmu5khCzioYZjhpLIIJfDnN9H9xhlGikBe8KvLhKNeNj3qVFVfdJJ2cCxWJFqvxy+aVdDr/VnJmiGCAsskbPlmFgPYbOtbE8bgvP8hNSEzbRF1LIsft10U+Fid1CrvRVhnuoi37xgMbdA75eXX8nHUYv46F5zd11WFidlugMEeGcIhlZnzb+T55+wmCcMEjPOhnmXA5ytQ4nY25tZLQRnOWdzuDjxADCmjSFENZ5virADir6HhgggNp8FTFcxedzvw/PUlCg9iWZGy6jjTpMbYiGKeAKiZXJ1C7X+B/ya2C3/8or5dYicWK835U9yLzR06r+E+fWMd5Rjeo8weoXHH18oKaW9TbAkC00jCeQxn4ZnPjujacZ4MKyvuyAJ+qhBf94fs0ErVlwei+QHw6pCn1m8vcyMLiwq0ysZvYYdbh80r1NWqEtFvofSOmALMMMYajzt0vfH2lK4p4riDNcGuEi8N1SAV2u6Agn8HMi6gA8cL+UnGycJ+Ue/3eOPXyBE2NpoUJQjT3ZPiKvWjZj6ix5K6yFTgrBDiWiYmWnpTWA5NAsLd2EBZiCKiqQcMV2dmtfEVkdFzKHXmAdGzKrYh79Fexr8WxAk14R7xkQMlsNDpCfT2c0aGv8z2/NshktU0QVfFTz+EdvdvLxvy9f78jfABqSdHsT8E+DDX4/EOYAh64stDQ2ELqy3BaMiR1RPElDzRHiduaowFBrgXOGKtNfiuuChG7W2XUt9rD5f5nD9kwmEo53MXNOT8QdPTpwC+KvlXyu4SG9wV71xsywOLdheDD2Vd03ong0hrDK8x0pN12QmWOy0JrD9CxjYS2zrQRb9nycq7CN1lKD36/0hFpzgnLP+GseRCz0VAufBKh6REsle
 5UEDKXKk
 xY7WS5EYK4YYIyDwr+v9PrOJOggUI8OkyePRJ5kJ2zsdaWz/2Ak5UGo/NkkUMMmd1Q2R+E/fvlTSh8i468yKe0b4zfn2mDaJv2yjusMDwpPi8RvQbHsXcmsQB/JQW5iaUonqhr9zcyhdtofyMLafvaAuNAb3Ik2yZ8CjBszcdFGFtPhqD0fp5MFnrTRypV4aLlFLgRpNtRj4J3zB5qi6fiv8Y93BIJOqG0PBTHVmlzDKKi/x8cTBv0mZoQq11noUWfoQOLQmFWSyFqMiPFdoN/oqP8ntlpW73c5Xb45UscakrA2YVQLs8G2PCl7XlSS9sVi5V8YQrTKAp2fpDJ7wfjiT+EhzEKBW05mvBfxWjeKm624SVYNFqDE+290k421GeI4eDKFKipz9bZmdroDGJOoEEH5tLCpSDcXpr0h1eOKpcbOPaaN2RrS4PQffTPw15K1+q9pR8IMSHslGo4bZpUB29nnUuofScPNvyHemgQvADVBPFzPU++ze7OFfC3MSe581BmmwpQXf5KfjpB72vOLp6TItMXwxD2yW4Eyq6Sc0rRsGIPiBYygZzeTj9osX6fOoi+8di/eFEa68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The invariant "scan_hint_start > contig_hint_start if and only if
scan_hint == contig_hint" should be kept for hint management. However,
it could be broken in some cases:

  - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
    scan_hint_start < new contig start) && the new contig is to become a
    new contig_hint due to its better alignment, then scan_hint should
    be invalidated instead of keeping the old value.

  - if (new contig == contig_hint > scan_hint) && (new contig start <
    contig_hint_start) && the new contig is not to become a new
    contig_hint, then scan_hint should be not updated to the new contig.

This commit mainly fixes this invariant breakage and includes more:

  - Handle the cases where the new contig overlaps with the contig_hint
    or with scan_hint.

  - Merge the new contig with other hints when it overlaps with them and
    treat it as a whole free region instead of a separate small region.

  - Fix the invariant breakage and also optimizes scan_hint further.
    Some of the optimization cases when no overlap occurs are:

    - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
      contig start < contig_hint_start), then keep scan_hint instead of
      invalidating it.

    - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
      new contig start < scan_hint_start), then update scan_hint to the
      old contig_hint instead of invalidating it.

    - if (new contig == contig_hint > scan_hint) && (new contig start <
      contig_hint_start) && the new contig is to become a new contig_hint
      due to its better alignment, then update scan_hint to the old
      contig_hint instead of invalidating or keeping it.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
---
v6: Diverge more when the new contig size is the same as the old
    contig_hint size but greater than the old scan_hint, does not become a
    new contig_hint and is before the old contig_hint.
v5: No change.
v4: Refactor code by removing the scan_hint candidates and handle the
    overlapping cases where the new contig meets with the hints on the
    border.
v3: Merge the new contig with other hints when it overlaps with them and
    treat it as a whole free region instead of a separate small region.
v2: Consider the cases where the new contig overlaps with the existing
    contig_hint or scan_hint. Introduce the scan_hint candidates to
    calculate new scan_hint.
v1: Initial version.

 mm/percpu.c | 118 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 93 insertions(+), 25 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 89b7f33500cf..1a0e1e84d92a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -616,6 +616,20 @@ static inline bool pcpu_region_overlap(struct pcpu_region a,
 	return (a.start < b.start + b.size) && (b.start < a.start + a.size);
 }
 
+/*
+ * pcpu_region_concat - determines if two regions meet on the border
+ * @a: first region
+ * @b: second region
+ *
+ * This is used to determine if the hint region [a.start, a.start + a.size)
+ * meets with the allocated region [b.start, b.start + b.size) on the border.
+ */
+static inline bool pcpu_region_concat(struct pcpu_region a,
+				      struct pcpu_region b)
+{
+	return (a.start == b.start + b.size) || (b.start == a.start + a.size);
+}
+
 /**
  * pcpu_block_update - updates a block given a free area
  * @block: block of interest
@@ -629,6 +643,40 @@ static inline bool pcpu_region_overlap(struct pcpu_region a,
 static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 {
 	struct pcpu_region free = { .start = start, .size = end - start };
+	bool overlap_with_contig_hint =
+		block->contig_hint.size &&
+		(pcpu_region_overlap(block->contig_hint, free) ||
+		 pcpu_region_concat(block->contig_hint, free));
+
+	if (block->scan_hint.size &&
+	    (pcpu_region_overlap(block->scan_hint, free) ||
+	     pcpu_region_concat(block->scan_hint, free))) {
+		start = min(start, block->scan_hint.start);
+		end = max(end, block->scan_hint.start + block->scan_hint.size);
+		free = (struct pcpu_region){
+			.start = start,
+			.size = end - start,
+		};
+
+		block->scan_hint.size = 0;
+	}
+
+	if (overlap_with_contig_hint) {
+		start = min(start, block->contig_hint.start);
+		end = max(end,
+			  block->contig_hint.start + block->contig_hint.size);
+		free = (struct pcpu_region){
+			.start = start,
+			.size = end - start,
+		};
+
+		if (block->scan_hint.size &&
+		    free.size > block->scan_hint.size &&
+		    block->scan_hint.start > free.start)
+			block->scan_hint.size = 0;
+
+		block->contig_hint = free;
+	}
 
 	block->first_free = min(block->first_free, free.start);
 	if (free.start == 0)
@@ -637,23 +685,24 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 	if (free.start + free.size == block->nr_bits)
 		block->right_free = free.size;
 
+	if (overlap_with_contig_hint)
+		return;
+
+	/*
+	 * At this point, it is guaranteed that the new contig does neither
+	 * overlap with contig_hint nor with scan_hint.
+	 */
+
 	if (free.size > block->contig_hint.size) {
 		/* promote the old contig_hint to be the new scan_hint */
 		if (block->contig_hint.size &&
 		    free.start > block->contig_hint.start) {
-			if (block->contig_hint.size > block->scan_hint.size) {
+			if (block->contig_hint.size > block->scan_hint.size ||
+			    free.start < block->scan_hint.start)
 				block->scan_hint = block->contig_hint;
-			} else if (block->scan_hint.size &&
-				   free.start < block->scan_hint.start) {
-				/*
-				 * The old contig_hint.size == scan_hint.size.
-				 * But, the new contig is larger so hold the
-				 * invariant scan_hint.start <
-				 * contig_hint.start.
-				 */
-				block->scan_hint.size = 0;
-			}
-		} else {
+		} else if (!block->contig_hint.size ||
+			   (block->scan_hint.size &&
+			    free.start < block->scan_hint.start)) {
 			block->scan_hint.size = 0;
 		}
 		block->contig_hint = free;
@@ -661,21 +710,40 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 		if (block->contig_hint.start &&
 		    (!free.start ||
 		     __ffs(free.start) > __ffs(block->contig_hint.start))) {
+			if (block->contig_hint.size > block->scan_hint.size) {
+				if (free.start < block->contig_hint.start)
+					block->scan_hint = block->contig_hint;
+			} else if (free.start > block->scan_hint.start) {
+				/*
+				 * old contig_hint.size == old scan_hint.size
+				 * == new contig size. But, the new contig is
+				 * farther than the old scan_hint so hold the
+				 * invariant scan_hint.start > contig_hint.start
+				 * iff scan_hint.size == contig_hint.size.
+				 */
+				block->scan_hint.size = 0;
+			}
+
 			/* new start has a better alignment so use it */
 			block->contig_hint.start = free.start;
-			if (block->scan_hint.size &&
-			    free.start < block->scan_hint.start &&
-			    block->contig_hint.size > block->scan_hint.size)
-				block->scan_hint.size = 0;
-		} else if ((block->scan_hint.size &&
-			    free.start > block->scan_hint.start) ||
-			   block->contig_hint.size > block->scan_hint.size) {
-			/*
-			 * Knowing new contig size == contig_hint.size, update
-			 * the scan_hint if it is farther than or larger than
-			 * the current scan_hint.
-			 */
-			block->scan_hint = free;
+		} else {
+			if (block->contig_hint.size > block->scan_hint.size) {
+				if (free.start > block->contig_hint.start) {
+					block->scan_hint = free;
+				} else if (block->scan_hint.size &&
+					   free.start < block->scan_hint.start) {
+					/*
+					 * old scan_hint.size < new contig size
+					 * == old contig_hint.size. But, the new
+					 * contig is before the old scan_hint
+					 * so invalidate the scan_hint to
+					 * protect the contig_hint.
+					 */
+					block->scan_hint.size = 0;
+				}
+			} else if (free.start > block->scan_hint.start) {
+				block->scan_hint = free;
+			}
 		}
 	} else {
 		/*
-- 
2.54.0.563.g4f69b47b94-goog


