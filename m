Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DE7CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2F46B0092; Wed, 13 May 2026 04:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73E46B0093; Wed, 13 May 2026 04:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0A76B0095; Wed, 13 May 2026 04:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF3D46B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:51:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75FFA1C06A7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:51:25 +0000 (UTC)
X-FDA: 84761777730.14.54B3150
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id A635B180004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:51:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mQTCdMIU;
	spf=pass (imf06.hostedemail.com: domain of 3ijsEagsKCGkQVVUdVURHUNNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ijsEagsKCGkQVVUdVURHUNNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/ysDW4vpFGuyFwOzyTH39ntXv4ZsW/SAVTNkmI/e2Q=;
	b=MImGInbwZU0MUytsR598HM7GMoKExj4sFDAw7ECcdNeX8emKWes7ViLiPS/DRAYMHsYdG8
	ICKKoRi219Tt0Q2w3ELWYUBeSBF6d29iKWDsG48+jmUEmWTrB8llOzkJBm//php9J/dw+r
	s5IUEz68rSxUeiuh5DUq2j3Oi2QoznI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mQTCdMIU;
	spf=pass (imf06.hostedemail.com: domain of 3ijsEagsKCGkQVVUdVURHUNNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ijsEagsKCGkQVVUdVURHUNNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778662283; a=rsa-sha256;
	cv=none;
	b=jim8KlEfrokCBKT7g2JabEEWO0meTTMrzBsrUGwfmE5mO1FzGhjZ+Wi6OXmCiydgRU7Niz
	bWvgMxnvJcDtQ69lc3yEIAsdvKMwpzpNCJh3zaFSTglSHCDiHDNf9HcfePHWyuyAq4Vs0O
	fczAk7OUTxCt2kV7Hqfi5+LWi3pNnh0=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b9b8137828so69567645ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 01:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778662282; x=1779267082; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D/ysDW4vpFGuyFwOzyTH39ntXv4ZsW/SAVTNkmI/e2Q=;
        b=mQTCdMIUHRCZ6byU5ide8sA1XUhyX8GhfyQU5oZGWhGTXKLgiMvJ8c+TCstgO7Hlnh
         iR/AtJ3LcJcW8sv3XGp8WC8TIZfSI3adhjAJeS7SULEt+wNu8+V8H2AWBrdmFeHJd8DA
         gQ5GgkepDSKJ4dy7DTbDyhLxDMF/10m3EAQ21GUWmSY6qVQEROhVn4q5jvRIMQ1LkLVR
         gpaRWXLaMGqp9rLsy7zq9Sa7TCT4tB19BiszvsJ5CUM/m/QIuVsbu00AB/nw3zimLLrK
         zS5+wrwLbzTZ5yjRGGAvobzJAE99FhqMrzatVsPvVf8MgWmKB5SffjLPnhyNLjSg4erb
         SEEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778662282; x=1779267082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/ysDW4vpFGuyFwOzyTH39ntXv4ZsW/SAVTNkmI/e2Q=;
        b=FbemAOFgVO3NjUvvEniQdEEGjC4Nk/PpOM8f6okehrtf4tGnFmKkWL1w/AmLqSNxZD
         JzMvHTVXeA2nKYkVL/uHbHiD/kFwQrW5f/J2yZzPGI0okAC92uQPZpsPeH4qWDgNonwp
         w+/AHoahY2bht7sX0rmLXJPJqHcgyEZJ/EpGest4wTKy0RorEUeRz/nX0p0cxxgsU19W
         KtYyD9a+KW/yH0H8p9j4BqMT6M35+Nmw7WyXTBkbNZy5/HSHlfekdHSbi0Xn6Cg6FYSN
         HYYUizseOvfrGHFxxatcc2XgcBWE+Sn4q8KohR8yk9U0/vQIY84jzKjGPCvpS5BvW78/
         hKBA==
X-Forwarded-Encrypted: i=1; AFNElJ8JBn1wi+xGIxObrjF14mxlTAuoE8ErGjF5dV8uPpV1fzBXHyZIIcTwqqBDJ7Mr7/68Chpz4sIJXg==@kvack.org
X-Gm-Message-State: AOJu0Yy48t1Sdb9Ah4259vJUi314rQgIN5Ij6XYbz6AT37AbAENpNIoC
	mwi/acGw0KntnaTBoQ7KkbarUPtbwfvlWSocuRgoCBZXlZYTgiE60KSP3nc0MS2eDTJyFNYUe97
	853RkNbCIUccr1eT0myBMM7RScA==
X-Received: from plblv14.prod.google.com ([2002:a17:903:2a8e:b0:2b4:5d58:bb86])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:758c:b0:2ba:22db:e1e0 with SMTP id d9443c01a7336-2bd2f4f5c6dmr14392825ad.10.1778662282217;
 Wed, 13 May 2026 01:51:22 -0700 (PDT)
Date: Wed, 13 May 2026 08:51:14 +0000
In-Reply-To: <20260513085117.1024175-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260513085117.1024175-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260513085117.1024175-2-joonwonkang@google.com>
Subject: [PATCH v6 2/4] percpu: Do not trust hint starts when they are not set
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A635B180004
X-Stat-Signature: 31j83f1df349ddtefpjkb8be3g5nngx7
X-HE-Tag: 1778662283-442352
X-HE-Meta: U2FsdGVkX1+0Uoh+3i8FcR1YwFkkPKfadFem5vNf3EtWxfisL8AdJeLjkcAF8txCMocOIqDB18zwjstul3cyiqJr3xahXaRu3MdrX0Pg+wInB/hUAF5xzSGv3myU2RzZv3FS7D4N1jAJz7mU/0YVEJE4uU+Ya3sov/fHXL2B8SL444DPY882FVgOoIA+LBrRek+VdqAmm1wiZeCHXldURNf2LHdKC7fVOFMrLqdp7/KAwUFxHLofWk5e6BDpyZ9NSvYZsWPG23TPY4i0cdiPJHEc/AZSGfgw9Rci8HN2IgXV9ayQ8PtTEsLlfQqsCz/uy0HH00Ge7lh1eyhyXvftyuZUxhgpnieR163WtFJwl4mqysGw2jk+GmCuJwPMpnzil3QGi1dWqkqlCOTLPfpD6albXhHRe+j/jEKrSRaqDbobBXI7QDz3zhP6OuLe9ef8kK/uzU8sr00wkVldQqklM2zj/aroCSxurnsyT0MTNpyAdc4lcJibi3I5//qwLF5m3rjJX7bgBMGNGFF7X2rQX18QBttwtaTXUVD5oOy8sWqFKf/AT1+QthqfdE5EyrLp6ZZOx+XV7vY4/mOFP7fMHKTaX6sya3OwaDBaZwOhXhMc/CLAL5nAbDznigVLMUPLQ5pWKz06lcRiIUFI6yc0eVVrKK8vJHWVGAnfFkpeefOHN+T8TKNj1ZVQBfmAucsq18STvGN3ouPfqVyr57bVaITlHfsKQF3Y8HQ9CH85jvikLMZSEXqg+yH84Cvc+GMPJd1rwYd6vQ59jtCeaXwoP8EBAW4zZCjm44N9TMHnQtf2UJccYRpZ5lOYdWBSl3V/OQwHsqKUzNlz6GSek2O5xyQWcKiYWcgO3NEUr+lcxV3gMJ7lF4bHlyKqZNHV8y4OV2TkXOW4GpP+2M+G0fDJUhPOwr6o440QOaYavxVDRYbHgxCtXWUnUpj/+g7Og9NRRPANpIqpmgakl9k374t
 hfiCJhgc
 MNgPCwoZMQ+GetCVLat36wzg7kh0O6WwtpD28nqfKJpS7aVeLQNtx/xycHLAYbrLn1u97C5V8+vVu00o3Okntny7VYTJgLhyKEfcN3Qo20XH4a2VmyUB9zkCKXzn8yHc/kF8c81U7OC5CYpSi2TfayEcI8zA8V6K39rp+3KCvYihx0Q2GgD7XUnNm+sZxH2IZXAy+K+ZQZpsgR2Af7xzM9i6FAgw+c/6IADVHU9FQmc08TbY1x7U9LgEKHluH0TFd4TChC8zIg3nejIdsvRoqLe42YqVEphMZ81gXNmb3vd4grIDsNc/v/v+7L655kEAXkomfdG4oy0oXpBqJ4k0bKTQB5yQFdyeGLldHypy+KWdn1Lfk4lVXUvaXYT4W49QZERq1+C9dCTv2Rfuw5k2nUJJJfU2rkxk2Sm3w53h3+soIBnCRA3fXNgtSTi030cxqrk5UsLAbGHhu+xSrdz1UECBCPa/ZeyMByXMQTvYlBDXCWoRsnPDXJiuQ+fiBt9Md3vzUDH0zalhadaVq4Hkuo+nX/kiE8bJ6uOifTwzZtslUgIw3OUT8O62PDL+4f4sn3gfoQ4nc/DEq4EhVeVLz/ssFNP25GnCrEyfAZTFRcr5HwdA=
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
v5-v6: No change.
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
2.54.0.563.g4f69b47b94-goog


