Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E76CD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 07:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3764D6B0092; Sun, 10 May 2026 03:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327D46B0093; Sun, 10 May 2026 03:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B726B0095; Sun, 10 May 2026 03:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 029446B0092
	for <linux-mm@kvack.org>; Sun, 10 May 2026 03:22:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B131A1C0E1A
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:22:02 +0000 (UTC)
X-FDA: 84750666084.18.F235FF0
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF19C180007
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:22:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RI5VZjXT;
	spf=pass (imf06.hostedemail.com: domain of 3FzIAagsKCNI7CCBKCB8yB44CC492.0CA96BIL-AA8Jy08.CF4@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3FzIAagsKCNI7CCBKCB8yB44CC492.0CA96BIL-AA8Jy08.CF4@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778397721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2dqdJSqZ2YzUGjO9Q4/Pde2a4UxV3zxrYkCuhRqOOM=;
	b=sctHAkq06okC5V/fWAOeRYun/qLwAFoOztKtQUw39JOXGfFB14lZLzN3JOJVR1NWq4eS2Y
	xu5BTWoHwEIAQzN8EFBkqXzQTvvQx1njRTgh4JiIoq4xEEJlSPguyHnSOYXtwgzgLPEmuR
	nPjsNijQrYNPoepBdFdatA/HYRpS97E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RI5VZjXT;
	spf=pass (imf06.hostedemail.com: domain of 3FzIAagsKCNI7CCBKCB8yB44CC492.0CA96BIL-AA8Jy08.CF4@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3FzIAagsKCNI7CCBKCB8yB44CC492.0CA96BIL-AA8Jy08.CF4@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778397721; a=rsa-sha256;
	cv=none;
	b=fKnDL+yHXOVTfJ2cSQjkUSXYXKipY0hxzSX7BZqOAS0Z5CxG06ffA7pu+7HSkW8RdTnrd2
	QNkt17r5xYojuxwozVDBMzWIVcv6es0WQ0aY80OfSFMJ4tAb8GkrmpuQ5Hf1Xk4cFNamqO
	wmp43So9wfSMfRuUX9WfD1X3e7zilw8=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8271fb43d0so482450a12.1
        for <linux-mm@kvack.org>; Sun, 10 May 2026 00:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778397720; x=1779002520; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2dqdJSqZ2YzUGjO9Q4/Pde2a4UxV3zxrYkCuhRqOOM=;
        b=RI5VZjXTI7jZt3fEH6fGYzED+XMAsdj0chG+kaAJ7nPt62Cxvs/xbiHkbq+TAkLzGI
         ufUE0RU10EwDp1a0HgW9K8eedYIiseWmiHYslswzUH0dr7Ic0/n0s6okkyXDpYWPU+IC
         mz3ueGvp0A73jV1f33OH6TgAb6CwqzM7tsw6avGCALFJagm1bYm5T63LhoqSX2SZPejW
         hyVK1Y1+/3If4JNPi8ybp4NDOXWTix68XCfd70lX8q/KF08CtaUaEsZN78BDRGBNsoOs
         4gE+bw3n5cwbkj0XCqR4cvqAISh/vouFmtggjB+Ez1xLTehXAfRtWdMDZRoIURAHCiIa
         5qww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778397720; x=1779002520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2dqdJSqZ2YzUGjO9Q4/Pde2a4UxV3zxrYkCuhRqOOM=;
        b=BlectR9QZ2seWiWHfbylc/B1nBdiGAzyqRRoGtv89HRHmqHlBQncCyQ0Ai7khDFwXG
         Juui/CGTGph9T5VZFTWqxZVp+zQq+JPkzE3egZMh3CA5HyU6lIrd4vWuNLDGDoFMFRMJ
         n/Td7M8cN5LtGldTOrSlKLsQfcKBS9uEsfInnZLuCD4zu6kyLH44pyjoUwHEdbnY+PAR
         H39uGKbFuI0+o43sHIBdHa55e9rnd/cqmznniyYWqw38b330rKWBB/Vc3mWACNAuFqg4
         Q5fjOJAhr76GkSckcknRKSWdEPOymxFV1Wb1Sh5QliSwwMgQEPzd1eBWba/0oCpLUQ08
         K70Q==
X-Forwarded-Encrypted: i=1; AFNElJ9yUQOo+8IToLzsV8NijyuNl4PEDHciCmOADk6rDsRGG8jsMcIKd9wMPzORoQ4+OhgBg/3cb0RYsQ==@kvack.org
X-Gm-Message-State: AOJu0Yzzy4aLtpHUziOw+qBXkaauWXjzgqCNfGIXjNERKh0A5u9NvHYR
	XmfP0wSTi7P4IJFDnhH6qdSo88Ywc6N4suZbcNdm1Nz3Bz+FgCI/ZboPP0R3h7UuDjb8B7g3Z0D
	uxDoNKnHguwpTCGW1PSYNYOWj6g==
X-Received: from pgjw1.prod.google.com ([2002:a63:fb41:0:b0:c80:15fa:8bd5])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3c89:b0:38d:fad1:cf2a with SMTP id adf61e73a8af0-3aa5a95239dmr18835785637.13.1778397719609;
 Sun, 10 May 2026 00:21:59 -0700 (PDT)
Date: Sun, 10 May 2026 07:21:49 +0000
In-Reply-To: <20260510072149.1279887-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260510072149.1279887-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260510072149.1279887-4-joonwonkang@google.com>
Subject: [PATCH v5 4/4] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: omkdxa9bbtb5a9aq9apjew78y7qssjun
X-Rspamd-Queue-Id: EF19C180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778397720-532226
X-HE-Meta: U2FsdGVkX1+XGITprcyWYgEoo6RafKzNVY5oqt6mfsNAkmc0aQVoyzOLo1TvC9BjMoLkrj28BMAXnfD/v3fy7fTCmPD5wk0pdBzKksNpTVrIBGcNBIuh1L6pzXuv0PtZoDI0IVBKYMGZTEBXKKNN44PCSrPTHooVcm5Y2cGd+c1fzzL/IAgYJ0eJ/wjGx/MnypnhPhveGhqGFL7UWhiO2XOrs74lyCgeMMCEBdvynNy4W3NSAmXKyeTAkSen2tvPk3etEmU9tZhhr7qefb/OwKmS/aN6nb4Vfi2TjPMqsGatstmEUaTrChofhDo8p9LxcDj+y1zwfgJLN0pwwnfE7ILldYIyScFlGNEGc041fFyv04o0h4jAfQyCKJ3vJMABNI+ueuV75GWY7rgWPkeswd7rK7667PTx2wTvo8dpYldt464rPauqKRDtvB0SKNZw+7EMf9QaBsiRxX++vDUqnxErYkVshGVk+xR1p5dsqCZF2zTBwqAbZWFE8FBOOsLr+BXsIk70eEa/gNHkFpaxhVoy0b51CA5y4iiFycVlWy5H1pOGL5rYGoiRzb/XAOyYpQ4qxTL9oRYEBDkTJrdtyjx+hByJMe2FznfubURC6hci3/JFRpunMWMdIAW0VqkH2ywz1xXQlahw8Yobt6tuKPoMTu61hRUeSbw/pG8nqHQAk7DA04yW71tGoue/d7zfnNzh6rVFAbY5gypgrCjQ1Fj1E3GWqpTID2Jc5F+mVG3Rjyq5aswKp43jOoVAVznlISszn/0UBKlyfi/fvzH33vykyfu6+hiHpnZupi+tzPiO8MVl8njDcnPFob74f3GrsQNQAuBPsPJxU0RoGbc6QiHh1fl1lbCCVsrBmmIAPNF29HRzcYv1EuouU7xoOMCLbGNOHz6A193+qi+qqMIQjvj1ZtAIWREpFzk9m5E/xXWp3I8xq3NtqdN4SwQMiSEMKtqCrQL3ADyMAhdn7j/
 RoL/1F/3
 18/cyy/KV4PmstzrN4q1F/tMYfi087VARfS98ZUuYvOqtxfvpe+7lgrcBcjqnOsr4Th138busyK0c87jrMvZH753F0SaaOjaiAKRnf5GyVKLu68KKlkMsznIuz0g4ljP7JUhQEj6SuqXQHt8H0yaaYe7hD9wTSc93+qWuQ+RGktpnq4qOb280BmchBg3cBfgn6SuJBsztIlVPB7o4e6tKw6cJvrMV7sJUeRCkUTdASHDliIbL1csCK//gAG/ossabYYORqQh2iVmF7V7IO/tgfK/WbjUUaIu3XBfhXnHXtQRYJwQsgYNZidLZnUhU1f4kJsFmTp+EW5sCNNWe3PXnu10KeWUjIiC8K8EfGETKnlX/Tfva8f7ALsGTU8PP+asPANzHUHq8zjKKkgbYhbFoq1OyzCHGXF0NiIrq6ThA8Xz/XygOriYNn/UIwVNH4s2CxhBo31eFLJ3z6LJn/eIymhUe5k7WHvLRMBHAsHurQplUW+nkADkriAwxuaAJOoKY3iOY4WSrhoTW1+t2a8P2YNylS9srDT6Ji+QumbUs92/dUU8P5CdSYPNpmyUvvVymvubYTBz7gOAqmRI=
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

 mm/percpu.c | 119 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 94 insertions(+), 25 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 89b7f33500cf..abc36391e749 100644
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
2.54.0.563.g4f69b47b94-goog


