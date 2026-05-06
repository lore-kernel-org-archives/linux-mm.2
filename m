Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BED3CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9EEF6B008C; Wed,  6 May 2026 10:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C283B6B0092; Wed,  6 May 2026 10:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA21D6B0093; Wed,  6 May 2026 10:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 983876B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:21:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54CA716028B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:21:09 +0000 (UTC)
X-FDA: 84737207058.13.2686299
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8E54E20015
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:21:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="K3NW1c/L";
	spf=pass (imf03.hostedemail.com: domain of 3Uk77aQsKCDMYddcldcZPcVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--joonwonkang.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Uk77aQsKCDMYddcldcZPcVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778077267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9H9L9M+JOU3eNnCYVuR6T/rOOaeJDpAoAd4t4ID0R20=;
	b=xl9aSaToGIkhJJ56XuczPLvZAR9lYr+0Etem736tON6BHDjC6EPuUS1qCnwICo04upmA8X
	rxGP/L5+HzwH2Q5kEoR31PkB0G002QERekhW5qaFXLiKaA+7DVz2Zh/xNkIflnI00luFsS
	HMTi7rh2JZ9wxwkTuFUVe3K5Jkpj9TE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778077267; a=rsa-sha256;
	cv=none;
	b=bNIT3Bu3/pcXZKXf/c9uCwg0BCMkFFxv7yBoPsY943rGkONGqw7llhgohHq6NtKhsb6UXT
	lvf1t/E71UlSH5UE3ffpmNfmGVy6pCM8XwaBlwGdMBT6B7ClIoi+esRsnBeJ20pGRotyZK
	/4gbQkj040VvWKM/YbtdKo8GKva+Zto=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="K3NW1c/L";
	spf=pass (imf03.hostedemail.com: domain of 3Uk77aQsKCDMYddcldcZPcVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--joonwonkang.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Uk77aQsKCDMYddcldcZPcVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa5ecd760so2702202b3a.0
        for <linux-mm@kvack.org>; Wed, 06 May 2026 07:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778077266; x=1778682066; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9H9L9M+JOU3eNnCYVuR6T/rOOaeJDpAoAd4t4ID0R20=;
        b=K3NW1c/LIaFrxfj6KNBasS+j9ziJMRQ19NS19tptamhvMEpfB7VYaP8zLUQYCX8978
         gHrY9T0eq4iEVq5ZEZFz2sWyzSq1RimuGPWrw6nDNoZ1t/F0iHx+StcX5zaqIyT/rXka
         rKAdmerym4k11x+M3NSSaOFAgR+MPtBM5XHH2WAHD7GXfVRAsSuv3oOf86VT3cnCRE9T
         y2KIhCfTGbVIT5vx7rhiFbFo1rXwkaXGLyJ7b6LSA26nvCOmy730CC55tVVG5JOAYwzF
         2BUNriADsBPDtqGFyCOBHJywGcB8W8D7bHwapABTdCrXr8Iq49v/VMc7RU5v6akShowI
         cO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778077266; x=1778682066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9H9L9M+JOU3eNnCYVuR6T/rOOaeJDpAoAd4t4ID0R20=;
        b=miSYl2mpjoSm5AAtERRoFCC9iROFUHhEKrKNHZnrUquNcBk1Fz0O+1mIfpF34b9E3T
         cJk6GrdxxgxZlC1NFa1wcYkM+pMXzQ9LAFDzl7dXnnhzFpyhtJVSa2TSEd5dUKOWUNTt
         2oTUDQAtmtd8PBDUsWpf1fO58AvbHhmOfV2hDK7n9jVxlvNlI9IhpZhnIdOnnP6N77OU
         Hh/XqVpP9S85UPRu3hepZOQXhfg2jWFNWWHT/WMwH1mImDftPuWkLZfdgF/RVkhccJsj
         qkxH4oC4P/pDuMDPkfrkrFr8HJIuj6hozDCxfH8dR8pJzSnveK7e5N+dMX1VP8zC/k8M
         To2g==
X-Forwarded-Encrypted: i=1; AFNElJ9IdrcRwQJ21SAG+m4uUYdPVCOpooh5dt7/NWbRltH5DEnDZB9VPE0FmL6BBPaQ2gK6zabikUuDpQ==@kvack.org
X-Gm-Message-State: AOJu0YwNzbxlkWuCZF/1pCAWHxoN0OJASXhiRx0kfL44OoPZUaibr/EG
	f03Zfgv4epwXEvl8kA3fZCK3Vzsx5FCBjVvKDCNHX+lhgydBz3Wd1+RY1FmFIMk6sE9sq0hAVYO
	hNqIpG9AFqC8/BlzCqIvvUoOx6g==
X-Received: from pfoh13.prod.google.com ([2002:aa7:86cd:0:b0:82f:c34b:9799])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4191:b0:82f:85c8:fc19 with SMTP id d2e1a72fcca58-83a5b9de7c7mr3359443b3a.11.1778077266093;
 Wed, 06 May 2026 07:21:06 -0700 (PDT)
Date: Wed,  6 May 2026 14:20:57 +0000
In-Reply-To: <20260506142100.1289509-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260506142100.1289509-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260506142100.1289509-2-joonwonkang@google.com>
Subject: [PATCH v4 2/4] percpu: Do not trust hint starts when they are not set
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8E54E20015
X-Rspam-User: 
X-Stat-Signature: tokcsr46wnec9ew8a31t6qc4ks3d76t4
X-HE-Tag: 1778077267-385194
X-HE-Meta: U2FsdGVkX1/s9+PuorhTBqZ54x9+/7UOaXuIoJIdPN3yU4dJfYSG26kNjbBr2pzhrpu0MtLDIgTwbsDkcr9mCDj2hrs1g0XiEXKCSJ8gVjG0FvPc2WiR61fPzis7jEn0LJ+UD+FKuYBsT6gg+vEa+wpCH9rUGs632k1EOl0YEzmemDwDqSZCq5chttWogM5wLrfwyZExtexWYGZvirRE+6KNCqAmgY2sE1rkEfOLmVpbLtn/Zo++f5vue9LlnvqtDK2524rv0DPhHG1gsFoHE64GV7t6i7fb68R5ybe1CwrT4FJxAleGlbqg6glvuL3BvmrhwsrxJod22JliHzObiqwLQ5ybOO1lwMihXrJPxZLwXhOJ2/TL39yn1HGOJYv/2rzpVPWJtlsSb7lCO735YDVRnH5TyNBaDAlbUwL8pb4tHbpUR/tJ9OmA3yxXZZAWpXx/6/8wF9zW5ivo/YS3ZjfjZA0oNWQYVhYrEZdpsJi8PtFmXUjjclaWShHZ7Djq5r+UIiDsSWxiffYaqkY4sjxwTdw/qLTsxrjarruS7t+qBPckdzyeHg1dTreoQSSRjyQrAH0QppJ5JamXweedcyyPyYBKOxxEZ6Sh1FULSZYI7jVxxjv/2yBrbhDsb9vMPxizhnr9RDPNlLC2l0Iad2PeEtH+K1EhDY071aLYHQM26gcncUuAlnjSiLaETHiHyA78qLilcfLsiqeOEz9H/rem5XQ/7hAdi8+OTvE8dUIo2tl4bz5wKhMF/L8nOoHQOQm1d2lsXJiqA5nv6xOVf6w0vu8OGRgkr+UyuvPHdbCQm+Zopme+O1LGHdn9DKpl3iyI8qvRo+dTmuYD5rHJDw1ZSQlnup4PKa9CkJV1zBmM8jl2OaowgYcj8JlYBkLzatw8hFSAQAQVVizKqR83FbPDSDJbLs7fEmqzCG6BgDOWIMkBv0z7QgO2x3OEzZhFS7wOR6zDfRN9TjDZTHQ
 MPxOp3K1
 Kwe1Q8M6iKGLMB+sGUfYjzQUJ18ikKv9/wU64yCZaNaTjTCWtSA8lcaAP+3U+F/4UD5H82VTCFwsr6YarUCaPyVyACysr1Ua9EGrgAxtH5QZ2GSkiEnQpA3oN/I9xLROtKG0xs8LMMIT5oAXLZ3ZmfNH6w+ZL+Thab9Q9k1lcGEY+sJQVcZmozIqgXX9taTqut/ff5suZhiiMx0H3O+UBlN+zCmZ1gerApOQE8kbI+uyl+xsEzlpDupDNVYzRsJzlCYVdKT7wIUm71edTjOQ6AV0soaHXbGaqGZzgrmI87vz8JPgVuQD3TKbUPP2N5vfdEIHWZ9CFAVPqIf/Bh29P+9/jvbSasCOK7jR8g22nwZghXdw+lARwwBkwaI1Y0vvqg+A9+9zkO4sH9xTvYv4gPuQyeBpctCYInoVUFekEZsHk2awi9yMMbztBmkoApEKMpY4DDgKiUo8TM6LSCzmer8EJmYznhrByu7/H0oU8jVrd/wviVOvN4VAWj0h+nkMQS5YU4oRZPxsFDExEBMpQvErksydaq+F0e+NeFbvyj1/xYK2dFlkbHg0Ep1wGy5vMILG0xVC7reVdvYmOQtejnPNUiER72rzNpT233qgVMjwwsMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

contig_hint_start can be trusted outside the hint update function since
it will be updated everytime contig_hint is broken. On the other hand,
scan_hint_start might still be invalid anywhere in the code due to the
broken scan_hint not being updated promptly. If those starts are trusted
when they are not set, it could lead to false invalidation or update of
the hints.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
---
v4: Remove the separate contig_hint == 0 case and handle the case in the
    following code. Add more checks for scan_hint.
v3: Initial version.

 mm/percpu.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3ecd86096641..0f6dd5260f56 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -640,12 +640,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 
 	if (contig > block->contig_hint) {
 		/* promote the old contig_hint to be the new scan_hint */
-		if (start > block->contig_hint_start) {
+		if (block->contig_hint && start > block->contig_hint_start) {
 			if (block->contig_hint > block->scan_hint) {
 				block->scan_hint_start =
 					block->contig_hint_start;
 				block->scan_hint = block->contig_hint;
-			} else if (start < block->scan_hint_start) {
+			} else if (block->scan_hint &&
+				   start < block->scan_hint_start) {
 				/*
 				 * The old contig_hint == scan_hint.  But, the
 				 * new contig is larger so hold the invariant
@@ -664,10 +665,12 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 		     __ffs(start) > __ffs(block->contig_hint_start))) {
 			/* start has a better alignment so use it */
 			block->contig_hint_start = start;
-			if (start < block->scan_hint_start &&
+			if (block->scan_hint &&
+			    start < block->scan_hint_start &&
 			    block->contig_hint > block->scan_hint)
 				block->scan_hint = 0;
-		} else if (start > block->scan_hint_start ||
+		} else if ((block->scan_hint &&
+			    start > block->scan_hint_start) ||
 			   block->contig_hint > block->scan_hint) {
 			/*
 			 * Knowing contig == contig_hint, update the scan_hint
@@ -845,7 +848,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 					PCPU_BITMAP_BLOCK_BITS,
 					s_off + bits);
 
-	if (pcpu_region_overlap(s_block->scan_hint_start,
+	if (s_block->scan_hint &&
+	    pcpu_region_overlap(s_block->scan_hint_start,
 				s_block->scan_hint_start + s_block->scan_hint,
 				s_off,
 				s_off + bits))
@@ -889,7 +893,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 			/* reset the block */
 			e_block++;
 		} else {
-			if (e_off > e_block->scan_hint_start)
+			if (e_block->scan_hint &&
+			    e_off > e_block->scan_hint_start)
 				e_block->scan_hint = 0;
 
 			e_block->left_free = 0;
@@ -922,7 +927,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	if (nr_empty_pages)
 		pcpu_update_empty_pages(chunk, -nr_empty_pages);
 
-	if (pcpu_region_overlap(chunk_md->scan_hint_start,
+	if (chunk_md->scan_hint &&
+	    pcpu_region_overlap(chunk_md->scan_hint_start,
 				chunk_md->scan_hint_start +
 				chunk_md->scan_hint,
 				bit_off,
-- 
2.54.0.545.g6539524ca2-goog


