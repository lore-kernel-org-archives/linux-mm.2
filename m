Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD41F45A08
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 17:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A0E6B0092; Fri, 10 Apr 2026 13:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D9E6B0093; Fri, 10 Apr 2026 13:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BFC6B0095; Fri, 10 Apr 2026 13:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE8276B0092
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:44:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7094D1B6E37
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:44:29 +0000 (UTC)
X-FDA: 84643370658.19.F057749
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id A1B0940002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:44:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qEHlLnp8;
	spf=pass (imf11.hostedemail.com: domain of 3-jbZaQsKCCMINNMVNMJ9MFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3-jbZaQsKCCMINNMVNMJ9MFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qEHlLnp8;
	spf=pass (imf11.hostedemail.com: domain of 3-jbZaQsKCCMINNMVNMJ9MFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3-jbZaQsKCCMINNMVNMJ9MFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775843067; a=rsa-sha256;
	cv=none;
	b=BYzhQqcSm5awMiYZ0RyZIID5NZ6NVO3Rsde5yKeEkVqv39shc3TShKCcRjrwIDLZeZg8fc
	F8HiC1iAJwf3sjv025G/4Tfi4YILN0G/PrMHRf+fRQHqihDLsehfoLwGeYLhVQG6aB2xOZ
	yTQPFfNC66RbJ3byMHXQWUCvc+TF2Ac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775843067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4YJKMdf753ocKFMD0oJg0o1FvBOynPDIQ/Gg8qrwH4=;
	b=cdMg4F3u62rZHgZMTkex9n4cU3DQOmN/n+bdqOBX+9tAnQ32QrmPKK7tNExYVWZtNrcfC1
	OX9UyLLhl2eiEKGsYFeZd3ukdEl4a9l3cU/naY4AX704j+g6X4upyHkCu7O9PSSjzp+FuS
	za4ypbOKMAoMUtO2BHxu7J9CMI2hGYU=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b0c92ff4ebso27694795ad.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775843066; x=1776447866; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k4YJKMdf753ocKFMD0oJg0o1FvBOynPDIQ/Gg8qrwH4=;
        b=qEHlLnp8oNoTrYjc1JITveC2+JHfdV/IdOSeiNv+aTswxZ4yvWs/vRAcF2LXpuAAkY
         2N9tVTNeUASvDfD/w13Q+CA0MGRXMu+qP/uTjsRqnp4MyJrzB7+7Xg0PjqRVP/PngFf9
         AdpkLzc9ijF8cOav08KlYPKEwBI3E0CUYG18kPmglT5YJcmCj2oRM3qKG/6KPlC7uD05
         uyE62ubO3D9zM4Ve3OJuvcKHnA0pHyCESxVZVq/QRhWxmsv+q6TpruMem35S0XBMv/bf
         x7OhaRFNluOwEILIZsI36YsllYyHC/7wt5FYUGukZhJR4RyVSJ3YviqQ56MaOMC/GbLq
         tVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775843066; x=1776447866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k4YJKMdf753ocKFMD0oJg0o1FvBOynPDIQ/Gg8qrwH4=;
        b=ohzApE0mwBgPSyFIXD/VMfnUC/H0WFUP1Tk7o6OOGcy7gaEjqxe//+INUMmudc8Npj
         KSd1zrpRqmDHH6ZUxunEbQURUj5+CEfZhamie8u12HM1br5wUvP+xUirK2plsVQjpRQl
         UaF/9nfkvccwevDkGbktlZHaq/IF0MEr3eNVv9HP6kwP5Hqo46DA+jyDZrEU5llfrr1R
         Ihq+dNgdvUiqPnha52IQQQ8VC7WujKos9DYXVXa+CXJDDRExhSKyTzJ/icf8FzMFgxzM
         LtSH9c8/gTbjeNaOyTnzUf/FEu5oTlcEnQnahv/YH5StU1Ku43dEOdszuuB5CymGY1R9
         79WQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuEyvWWNLvAg2mYS1WEBYf1AF0hMjW5mbjCyuoHhyLVEGRpfpI1GowQ64o8HNyK+bEBYcVeq3F6w==@kvack.org
X-Gm-Message-State: AOJu0Yz4KX7IRqcagB/aOZOaUeV6k+HVXaxM8u69HXHwBkXlMsFLCyXp
	tNWCTAC4HVrJ/OtS7NiqI2EgR7AAulSm4iXoHGdXU7gb694gWTwgaYoO7Li5UgWaDiZygkxQvyh
	JGJ4jRMKV0E+zH6BNNHj29GmeJg==
X-Received: from plbbj6.prod.google.com ([2002:a17:902:8506:b0:2a8:a03b:32c7])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:b689:b0:2b0:41bf:ca83 with SMTP id d9443c01a7336-2b2d5a37051mr31240295ad.23.1775843066286;
 Fri, 10 Apr 2026 10:44:26 -0700 (PDT)
Date: Fri, 10 Apr 2026 17:44:17 +0000
In-Reply-To: <20260410174417.1450834-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260410174417.1450834-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410174417.1450834-3-joonwonkang@google.com>
Subject: [PATCH v3 3/3] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, 
	Joonwon Kang <joonwonkang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1B0940002
X-Stat-Signature: mpufs77p8bmyucq36cqj9oukwrrynra5
X-Rspam-User: 
X-HE-Tag: 1775843067-967598
X-HE-Meta: U2FsdGVkX1+7ShvqRu/aV7nh2VUneSwgNNXQp658p9gEW3CVhV+pRWaWLUq9jD2js5XvCKfs1cuMiVOLot7rdyqo4Vuoqh+UqRNay2/lzRNEFAlzI7ZZFuIxTdyYL8p1/B8hiRHZdWjR/mEPV/y7hQAExje6E4cwQ+5rT76tMZLZ59G1nDa/3wgaWPZ6E2BEq/zZTu231BWs5T4IqbqsGY8qYBl25e3vnj4qcV4CLS5BFf0ygeJVW3znM8LdIrfra9lbEdK8YKKyLLkaMYhzewXbJ+AuNRx+7peSIjQD2uqJID1fzhmGxcobDIcmfTcati6Nn0s7Kn0TByJ0FS+LdX5Lbc5Cb6C5GQfPJqbHQGu6qeApU9eMSnPEYrLw0HM+VKJx5dxFdqloc33E6fcDT3m6Yu2Jte/YHuGnCaojWqFA9kUec8fIlBGulDdWRVrR1ClB9ZaV/v2UxQ3HtIsnmztU1IoFZ7kYukp0bmnlyIXuc0YRX5YSt7K2Q4F+hGKXV3zo5mMDIpxQg5KQSQaOLDV4/weQoOCSzsdnOqnrqaEafK6p2OHj7WkxtH724LZyBfE2ZedFCeoS7RpUd7r5I3znlUkASS5/M3mfv7vv5UVqHovq7jJn6SDGbk0XCK/aok3PVfrO9Qsrb2q2RxIzQxx3v6KbchtdqMunBgsYVLgM5s5c048TD56aQIooVtDJ5m8TYHwm91JVDp6Z9hGhBFOlWLre3OZHBYSvxOXW5vS77O0t2suSJ5ULBkxjFQ0jJ3Wf8IoqwVeLDvmbkx+xzFynM7UYAyTlBLJMCFMWxS/DM648Gtu129mnaHB943jIdCC2ef83zfi+RrQ4Eb4NChwRcgso2D5ZAvExHYMKLxk8E0yWw6/+NxqcvWpx3kTtsE7fsdBibkkaID/EPEq3Wap+jEVprjqsT5n2EEw1QZDcR56QydXP9qepEjrDcJFEteo7vqbpiAJIhh5FKNI
 p168XDoo
 CIUfUPeEjNXDLdrMn2FWSGfMgIyrQa9fRsVF5PbjJEoJz8AMIVDrtawHqk2qV6TjPGDbQWpZHlPzgGFH3yRVOiCacnhtzdJAyhWPaSQeXr8PSKVVtBX1ctbmNpSf9bj25HUOf15adgT3NmIbPCZoRR4HGpOReaa5n3eknpd6N0NwZbeDbvVqMTqUAuuGBjI4fzJyAv0Cwn3MsqSvZNtKFOgWh6OfiU+aRX3+Lnb9Dj9JtmJi/lyyP0jfPbWOf0nybzqYbYHCsjJxNUdvsSIOhblMEC4zE6bckoEBXWhsrn3MEKWLlnKEOsKAW6Z85k2wh72FWimzsnPppnJbjZFLZVH8Wo00IK7AS8/ol7xXd6C/ZYjn79a/pO/ECnAdTDXigR5nkF8iYZfPGqtPWXpnBQjucWyqg//M9rml01+GqqfnSSucfIzwC2f1ibj80wgmM6gTrIhO4Z7FRhcxzLC73wNs4a2I+bXXo1RLaMQgUAdLfSvLIjbAM8dFTSPtcjXgU19KvURHMC70gvVZLx/vIHhSEg7Ys3oN8V7JwPxaMqh6dyTFZhXKNl+koiYPWurBQedGAMUWe++ZzWqG9AdLyL5O2paVwxyhvxniYW4Fh6iiabF7tBHVFOqP0lQ2UPA+lOvLu8O8PaH+OdGBliB9VwSwMN+tzbClODpuK
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

  - Refactor the percpu block update code to make it more visible on
    what to consider, e.g. when the new contig overlaps with the old
    contig_hint or scan_hint.

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
v2 -> v3: Merge the new contig with other hints when it overlaps with
  them and treat it as a whole free region instead of a separate small
  region.

v1 -> v2: Consider cases where the new contig overlaps with the existing
  contig_hint or scan_hint.

 mm/percpu.c | 130 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 90 insertions(+), 40 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f16533ed4a49..d5b0b4863ffe 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -629,7 +629,27 @@ static inline bool pcpu_region_overlap(int a, int b, int x, int y)
  */
 static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 {
-	int contig = end - start;
+	int contig;
+	int scan_hint_cand_1 = 0;
+	int scan_hint_cand_1_start = 0;
+	int scan_hint_cand_2 = 0;
+	int scan_hint_cand_2_start = 0;
+	bool overlap_with_contig_hint = pcpu_region_overlap(start, end,
+		block->contig_hint_start,
+		block->contig_hint_start + block->contig_hint);
+	bool overlap_with_scan_hint = pcpu_region_overlap(start, end,
+		block->scan_hint_start,
+		block->scan_hint_start + block->scan_hint);
+
+	if (block->contig_hint && overlap_with_contig_hint) {
+		start = min(start, block->contig_hint_start);
+		end = max(end, block->contig_hint_start + block->contig_hint);
+	}
+	if (block->scan_hint && overlap_with_scan_hint) {
+		start = min(start, block->scan_hint_start);
+		end = max(end, block->scan_hint_start + block->scan_hint);
+	}
+	contig = end - start;
 
 	block->first_free = min(block->first_free, start);
 	if (start == 0)
@@ -646,56 +666,86 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 	}
 
 	if (contig > block->contig_hint) {
-		/* promote the old contig_hint to be the new scan_hint */
-		if (start > block->contig_hint_start) {
-			if (block->contig_hint > block->scan_hint) {
-				block->scan_hint_start =
-					block->contig_hint_start;
-				block->scan_hint = block->contig_hint;
-			} else if (start < block->scan_hint_start) {
-				/*
-				 * The old contig_hint == scan_hint.  But, the
-				 * new contig is larger so hold the invariant
-				 * scan_hint_start < contig_hint_start.
-				 */
-				block->scan_hint = 0;
-			}
-		} else {
-			block->scan_hint = 0;
+		if (!overlap_with_contig_hint) {
+			scan_hint_cand_1 = block->contig_hint;
+			scan_hint_cand_1_start = block->contig_hint_start;
 		}
-		block->contig_hint_start = start;
+
 		block->contig_hint = contig;
+		block->contig_hint_start = start;
 	} else if (contig == block->contig_hint) {
 		if (block->contig_hint_start &&
 		    (!start ||
 		     __ffs(start) > __ffs(block->contig_hint_start))) {
-			/* start has a better alignment so use it */
+			scan_hint_cand_1 = block->contig_hint;
+			scan_hint_cand_1_start = block->contig_hint_start;
+
+			/* Start has a better alignment so use it. */
 			block->contig_hint_start = start;
-			if (start < block->scan_hint_start &&
-			    block->contig_hint > block->scan_hint)
-				block->scan_hint = 0;
-		} else if (start > block->scan_hint_start ||
-			   block->contig_hint > block->scan_hint) {
-			/*
-			 * Knowing contig == contig_hint, update the scan_hint
-			 * if it is farther than or larger than the current
-			 * scan_hint.
-			 */
-			block->scan_hint_start = start;
-			block->scan_hint = contig;
+		} else {
+			if (!overlap_with_contig_hint) {
+				scan_hint_cand_1 = contig;
+				scan_hint_cand_1_start = start;
+			}
 		}
 	} else {
 		/*
-		 * The region is smaller than the contig_hint.  So only update
-		 * the scan_hint if it is larger than or equal and farther than
-		 * the current scan_hint.
+		 * Consider only when the new contig is larger than or equal to
+		 * the old scan hint.
 		 */
-		if ((start < block->contig_hint_start &&
-		     (contig > block->scan_hint ||
-		      (contig == block->scan_hint &&
-		       start > block->scan_hint_start)))) {
-			block->scan_hint_start = start;
-			block->scan_hint = contig;
+		if (contig >= block->scan_hint) {
+			scan_hint_cand_1 = contig;
+			scan_hint_cand_1_start = start;
+		}
+	}
+
+	if (block->scan_hint &&
+	    !pcpu_region_overlap(start, end, block->scan_hint_start,
+				 block->scan_hint_start + block->scan_hint)) {
+		scan_hint_cand_2 = block->scan_hint;
+		scan_hint_cand_2_start = block->scan_hint_start;
+	}
+
+	/* Make scan_hint_cand_1 be the best candidate for the new scan hint. */
+	if ((scan_hint_cand_2 > scan_hint_cand_1) ||
+	    (scan_hint_cand_2 == scan_hint_cand_1 &&
+	     scan_hint_cand_2_start > scan_hint_cand_1_start)) {
+		int tmp_hint = scan_hint_cand_1;
+		int tmp_hint_start = scan_hint_cand_1_start;
+
+		scan_hint_cand_1 = scan_hint_cand_2;
+		scan_hint_cand_1_start = scan_hint_cand_2_start;
+		scan_hint_cand_2 = tmp_hint;
+		scan_hint_cand_2_start = tmp_hint_start;
+	}
+
+	/*
+	 * At this point, it is guaranteed that none of the scan hint
+	 * candidates overlaps with the new contig hint while they may overlap
+	 * with the old scan hint, and that the first candidate is larger in
+	 * size or, it equal, farther than the second one.
+	 */
+
+	if (block->contig_hint > scan_hint_cand_1) {
+		if (scan_hint_cand_1_start < block->contig_hint_start) {
+			block->scan_hint = scan_hint_cand_1;
+			block->scan_hint_start = scan_hint_cand_1_start;
+		} else if (scan_hint_cand_2_start < block->contig_hint_start) {
+			block->scan_hint = scan_hint_cand_2;
+			block->scan_hint_start = scan_hint_cand_2_start;
+		} else {
+			block->scan_hint = 0;
+		}
+	} else if (block->contig_hint == scan_hint_cand_1) {
+		if (scan_hint_cand_1_start > block->contig_hint_start) {
+			block->scan_hint = scan_hint_cand_1;
+			block->scan_hint_start = scan_hint_cand_1_start;
+		} else if (scan_hint_cand_2 < block->contig_hint &&
+			   scan_hint_cand_2_start < scan_hint_cand_1_start) {
+			block->scan_hint = scan_hint_cand_2;
+			block->scan_hint_start = scan_hint_cand_2_start;
+		} else {
+			block->scan_hint = 0;
 		}
 	}
 }
-- 
2.53.0.1213.gd9a14994de-goog


