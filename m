Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85BDCD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB026B0096; Wed,  6 May 2026 10:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F306B0098; Wed,  6 May 2026 10:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C0E6B0099; Wed,  6 May 2026 10:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0316B0096
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:21:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47EC0401B6
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:21:13 +0000 (UTC)
X-FDA: 84737207226.20.E05B6B9
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 603CF1C0004
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:21:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SQeypSf5;
	spf=pass (imf21.hostedemail.com: domain of 3VU77aQsKCDYbggfogfcSfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--joonwonkang.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3VU77aQsKCDYbggfogfcSfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778077271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYyTakcney2PvrBFUj5yhULPO2dy/QkUSR4wXxabzzE=;
	b=5Jih2xQwNFJlDC19JjQmg/WXJFBfTvlvihqayKGqKibMqg034CQdVi2FzJUa4bRJ3LV//4
	KSsTjSwPrVHcyAYHIIbFh2TXQxCAVGXfjJ+r3MBHzzPHkuhu/voiSj4dU0wv7IwufwjCRK
	woK8J2jmps3C2IvdaPQ2WayY/De+Ti0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SQeypSf5;
	spf=pass (imf21.hostedemail.com: domain of 3VU77aQsKCDYbggfogfcSfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--joonwonkang.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3VU77aQsKCDYbggfogfcSfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778077271; a=rsa-sha256;
	cv=none;
	b=tz5n1nO/5VIDW342woVk8S/IDDdZXvj5tjJ8aBUUSZDcRQm1mv7N5iGQqvy1WDRBLDhdbh
	qFa/c4pinnQ0ngoSQydr8mFENRQeJjqgYqzk6vePDqP2lwAx4Cv5XyDPpD+yUmp4L4XLvZ
	EjEZ1teDrXj03TqlPEr9qBmdCPA9V3M=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f74f0e3c6so4061601b3a.0
        for <linux-mm@kvack.org>; Wed, 06 May 2026 07:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778077270; x=1778682070; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tYyTakcney2PvrBFUj5yhULPO2dy/QkUSR4wXxabzzE=;
        b=SQeypSf5Y1jbkKWTtzpCzW1inivrdP4aBtBOrCRrDSyZmN+mpcg/0Dw+8/Bee0LIta
         hRqS1g/eXGgCQwnOBwXGPCrnTGt4vXvyVYn/8BiXRucORQASY3SFj91bEP9aqJjDU845
         Kg11IX9kvDmZIoj8LBgArFcNH1o4vZtss6h3q+XXmBMCU/LAHi3IPmJMaZRNMpxNtA0S
         FaqBTmQ6pzl98BmkC471S+N1fuW7GVee1K7Ws03uQr0SXi+QTfrBaIrwgmSC3Ji9TGPj
         FO7Jj00+CimofgFST9W9oSdwS7cPcdWqQrhv6Cq4JNna6TV/OWcqdEOzIY2YMmHEqOPO
         IELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778077270; x=1778682070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tYyTakcney2PvrBFUj5yhULPO2dy/QkUSR4wXxabzzE=;
        b=WmyXEwq1KvJfC22CWC3LBrrGrv1KgkE/kMZHms3VJzeCZSDjYEGVw5zz4/MCons7VL
         1/EtW1yyTmsAeDXcrvBwzCFKux8Vbyt4KYKJE/z6SAjbe6U5EojxfGtLIvT8vCzyNdre
         F6ii1B64/hIUiedafqcKuNoHD92IimkuY4HZcx3Do7Nk6FB0k6esQeEfcrA4TtDOOcYE
         q5rTTqo66ZrcS2wxvBB5wQUkTZxRmUgFCmVXj9QdvMrZt2qEPS77hW9cBfvtODizkcsU
         HI4ajuru03AuFhpjNh5IZFniFqGtVHoe8b9ZG+eGFMNoBAabow628kOuy31QuVkR/r7W
         PrlQ==
X-Forwarded-Encrypted: i=1; AFNElJ8JSK9jJD9EBONVTHsm0aUvvAhGfsWfEtr5437wq6xjCdl1o1CaUBW3S9QBw4cq47zbUT/Rdn/wxw==@kvack.org
X-Gm-Message-State: AOJu0YxQzEhTKIyzP1UVuDQlAE+zeYlGpUTOxPpD5qu4qRZEw/lX4064
	tAm7Ec0vgqmYIpIitUX3AGuwS6Rgdju5HG/dcpEEY7r9SUTLywVtQDDrhXXmxniEOHvrL9Cf+Jj
	nAN+p4ibcldDsaV+Oybk5HeICQQ==
X-Received: from pfbio7.prod.google.com ([2002:a05:6a00:8e07:b0:82f:7220:86e7])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:b483:b0:837:6bb9:acd5 with SMTP id d2e1a72fcca58-83a5825898bmr3530611b3a.0.1778077269986;
 Wed, 06 May 2026 07:21:09 -0700 (PDT)
Date: Wed,  6 May 2026 14:20:59 +0000
In-Reply-To: <20260506142100.1289509-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260506142100.1289509-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260506142100.1289509-4-joonwonkang@google.com>
Subject: [PATCH v4 4/4] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: f76war8wi3k74w6gb9bpcijaqfxrzfjm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 603CF1C0004
X-Rspam-User: 
X-HE-Tag: 1778077271-502810
X-HE-Meta: U2FsdGVkX19lNfNy/ixixDpCQhaWOek2C6E3adeC7f7sBBmbpCMGvsFq9/um2/lVWR8tmFdoEd3TpuDfLI5kLWFjBB/cZIanITFnbZriUhO9NK2x7ax1ufuLsO9LMm/xZ5zlR0OmVeVtrfn/kqUxwm+DPI861odvZbDCkK6u3w9kXOP4pwhX2G4vP3cevF0Z60CdNomq2o1H/dHNRZwt8WLHwSyN7uiEQCp3O5RsJAJNixzZ3TgIhVHW+buDShcgLaZek9crmZCWg6psSrg3KHZydFHLUmZXGJhx/4KbSwTnRougenQbPspXm4WF8m3B7xka/sFcOuFaegt8mog6+P+qjSKFbWRLlq0P1zkft88/h9gsm5Hhu5f+5MKAVucmC/ntCFHu1TVPtMBM5qmPp6myoZDKfJUgKNcZpPWdByxChGT1n14Zf2wmyLhdky4ZfLl9CAJPiWnZCumlfVKF5yuUIfETjWh+hWMicCvglL4D00CvJ2K6pGOG4wUrAqCE+jP8ZVhmXNg2CcTSVbFwRmIUej6PvPDgKl/E3zO5dCv6nAEnTLptT5sbWD8i6lSD/i+C2HDm+Ed6Z2jbbmK9dDzUYt8VqVnj+DEMLduf3iPDvgplWODA6tzB4vlw7xTNy/NhJ90JeKKtcstGTvE1eMcj91dXz+J3XgwxaXNheRytKMWomKzh9Ejz22iUyyBaNdG34D36xHEjFGYQZllDwrn6sy7uKdZvI+sqn+h+M+P/XQ/5e/ULzmQ5bn36joUXbGdNR8AKR4GuDK+ZCgIoiBDDyiXNUpCS1c3aLvkI2lOjYOz801KMHf0KuWKfp9EuR6/+C6cv+aQsb55kY+RucDjYGtNDeA3fha4mMKx44FxmPPRgWQtTJCIkCNGRS31OcOTcQLFhuQUUYgiPf8SeHjuMcY2QJP8ncOhTCRQxZAfp/wgsGx1c8LayeF8sdfvVsMPuKwpxYpKpNJIXhco
 /SX/4oLW
 XHkO4tBZhZ/9ekP9ozLoSL2VmhH49Mf9wX3eInSOBo6QQyFMkPeulAEaFCAon0dIcCHThuX+LLickZmVL1tJKj9/8jhJjcYDiMX82tjpakSx+GD2Nc1BMT2PHMe+4KWlAyQTRtAF2Yw0g0O+JNt6tW2hlO0fT3dNvou8ksxE1reI2YM0swpgRW2NGO5p5dvHzvfgMPD6QWRle78qaVz0e2sf38GD8ae1MmBZYENeH6dhT8C1KZGk79HB2pKLlNs9EUw8wbvGS2rdTriIk5+Yyi1B6S76HyLI38OXAJKV9SGo+trXTdCZPZHfJzI8L124OP8SX6p8ZTe1yBaGNytGxwFp0MUihIRrjLLrbeacwoSd/sANp7GGymhG2G8TpWfjW6NpRNkOyoC5fk92dADdZzop0Wy/IrnvJNXzS/BkoWeHQ3/fVgvMogJiRSGV+4BUcOB94Jf9N1m2Bk/5BIpU6rtA1BMlxvDy68YmU/lN1EgSvNekMZsWLtfqUzJ1DkT2T5iEru3UWZw0edJJbNekSZPxE6/s4kqp1azK2Ux3P2PaDP5DuKjyii/ONi5dtDk9v7HEZrUMVZ7EWogeiX5tSWlqyvXRQtW1A12Y6az7BGcNH4qsWyqdb7+KfTiMk5JGwHTuTKzSkoHx8hvY9ewxdSiOiOM8avzWYl6wH
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

  - Handle the cases where the new contig overlaps with contig_hint or
    with scan_hint. Merge the new contig with the hints in that case and
    treat it as a whole free region.

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
v4: Refactor code by removing the scan_hint candidates and handle the
    overlapping cases where the new contig meets with the hints on the
    border.
v3: Merge the new contig with other hints when it overlaps with them and
    treat it as a whole free region instead of a separate small region.
v2: Consider the cases where the new contig overlaps with the existing
    contig_hint or scan_hint. Introduce the scan_hint candidates to
    calculate new scan_hint.
v1: Initial version.

 mm/percpu.c | 119 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 94 insertions(+), 25 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 0f5648669cac..549448754afe 100644
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
@@ -661,21 +710,41 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
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
+				if (free.start < block->contig_hint.start) {
+					/*
+					 * old scan_hint.size < new contig size
+					 * == old contig_hint.size. But, the new
+					 * contig is before the old contig_hint
+					 * so hold the invariant
+					 * scan_hint.start > contig_hint.start
+					 * iff scan_hint.size ==
+					 * contig_hint.size.
+					 */
+					block->scan_hint.size = 0;
+				} else {
+					block->scan_hint = free;
+				}
+			} else if (free.start > block->scan_hint.start) {
+				block->scan_hint = free;
+			}
 		}
 	} else {
 		/*
-- 
2.54.0.545.g6539524ca2-goog


