Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 542091073C8A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80DCA6B00A2; Wed,  8 Apr 2026 06:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF066B00A3; Wed,  8 Apr 2026 06:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4F06B00A4; Wed,  8 Apr 2026 06:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD4D6B00A2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:06:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F21C51405F7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:06:48 +0000 (UTC)
X-FDA: 84634959696.01.1AB6901
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id 41332A000D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:06:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lvnQB2cG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3tSjWaQsKCLQdiihqiheUhaaiiafY.Wigfchor-ggepUWe.ila@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3tSjWaQsKCLQdiihqiheUhaaiiafY.Wigfchor-ggepUWe.ila@flex--joonwonkang.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775642807; a=rsa-sha256;
	cv=none;
	b=urqJfMXrrSpvEJXAr1miK4F9R1S2a4VDNT2k35XxsOQT+7xQqGkX5XsFBUAGHq95VWxaRS
	aHeS11fKt3s3ddJlugwMM4SO1sAHOIYNzeRFx6muedfqAPSwe0aJFY/NM0HWW88nkPwKJP
	Gnau7Xx3sJmOq4BxKtI1/waIATCVVNk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lvnQB2cG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3tSjWaQsKCLQdiihqiheUhaaiiafY.Wigfchor-ggepUWe.ila@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3tSjWaQsKCLQdiihqiheUhaaiiafY.Wigfchor-ggepUWe.ila@flex--joonwonkang.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775642807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2qPBZiQ6FrhRd8WblhKjUR/UPSv9+M4JMXeTTgxKUw8=;
	b=hIs9pmHiN89P8gjF2lD20id36uuld286SiEveoBmZ8vscPCPZYMLl3er/9yA0m5ci7fmms
	E3hgfng0h+onSrWutrlefgGcgb8ybbe3uOT5vTp/xPSCeWWj5UqIWUmKRX18UpZ/cX43oR
	uxuLeAPAGBxG0lmbpjq3BXpz4IoL448=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b0bf2b3879so158988165ad.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 03:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775642806; x=1776247606; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2qPBZiQ6FrhRd8WblhKjUR/UPSv9+M4JMXeTTgxKUw8=;
        b=lvnQB2cG65mwKhR/S/E5ivNrf8WSqTLRf7iD54t1RkkROo8UfDuBQjXpgj4vtb44OJ
         KXPIzpUseRF44zIVxboggQGOIOsTek3GPpeWNStx8WwtXLZCH1CSz/O4uOeZnZnotjfQ
         RPs3uLo+0DcO/kym1RnQ3nPN81ZUm65704uY+MG86mQlZgI1nqr0zbg/Ml3QLN7r2wJl
         dfhAVDcV7sK1ZXcTx/ymJu0Ey8vVxjLVmJmTG0JuE9rXmb4pjWnxtJe/cos6nYUpeI8r
         zTJmWJ4aYyEmorMCctgeJroild/4xuS7CaiF5Wl6qND2ZsUFoIevRALkAgR9r0PC1l1Y
         PtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775642806; x=1776247606;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2qPBZiQ6FrhRd8WblhKjUR/UPSv9+M4JMXeTTgxKUw8=;
        b=FbEDcpvSgpqE9YrGmXrUjvPdITE5gnKnTccHUpSkcH5EZRRD6kn04TgMdCZ1jVmjfJ
         k45pQLm6UJ3r4qypyuVuqDZKOa1IdJCxwirHQO910zZY/sN1rqFhjAZGrD+t3NngSUYs
         IU2TK00++nHOXXW/qOGB8pr/jKazrbafYRj+nIYMJx2WwDvNhgQWxqTYkgNQyqAqWjfZ
         PimsnwXVNlfSxwO+XsuVd9WPTftGIbwEMZAhwGAEIstYS/jZmexOD5V0anU6X5GTGUek
         zv36dlc3elTiZMnZAcMuymZ/0rQsItVNTtHI+YdrWLrqLAYyCwkBY+IGmhw6DKzi9bO1
         90Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWb9fpYBtzORiCe5DBakfGYAoLDHn6bUIOziuHMBvLu2KnMQIssGEkWl7M0OmQFGvb8otXKYDLyNg==@kvack.org
X-Gm-Message-State: AOJu0Yz8ePt1SV57Epwpf9t0TyI0vHiECJs7si9FLq0E9EHV0+q6HCBW
	kR+GnM3njAHawF0DVlfJy3g+i+CBSf2RmC2l5m/DN7qnQqQjwwkm8zjRq9+bHSh6qOSbFrIKjeC
	KnYt/R1X7ThKv0bbhVW3ThbebFQ==
X-Received: from plsp8.prod.google.com ([2002:a17:902:bd08:b0:2b0:af76:bcc2])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:17cb:b0:2b2:58c7:2cd6 with SMTP id d9443c01a7336-2b28167569cmr243068675ad.5.1775642805735;
 Wed, 08 Apr 2026 03:06:45 -0700 (PDT)
Date: Wed,  8 Apr 2026 10:06:42 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260408100642.83919-1-joonwonkang@google.com>
Subject: [PATCH v2] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, 
	Joonwon Kang <joonwonkang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3xdaxfedf44yjmmfm9fmiqxnhc4nni18
X-Rspamd-Queue-Id: 41332A000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775642807-646074
X-HE-Meta: U2FsdGVkX194VJl1zl2ZGqkdPRBK89Dc0eq8Hp0KUtofXBZ/70R+eKUbgj8nRp1ABBj9AFOSLBTv501xvSIRaKyWmfk/AfpHDcbUIDwZAxvnu5WorEvOj00YadKA0kfaZv8TaYGfn6JXfH+uF/tjFalN4xJuMqHyrXVVhnuYob2xYJpXSGqXH926o7ne9Og7E/x5GKQB48Yd1UST86tsh29W0HhjQJoua5y55lNwuw88a8AejnM2Zi46IY/nvPVg2H54DckOyc85JbXs9jDUyUsBwLJ3Py+vHHW1xRjQblE4F+v/GJuyRHjiFA/2TWBSqEkSMmuTPHs7ZffqEc6+MSbNJuiBGOYQRU6plf598uVN5pFiZLJbGzZzDt0seOa5ulOBQwAfy7Te+MQSTc2uyWED51pRKzBcwdrnd73SMRj8vY9tjTQ0Fqq9hWg3jmSBfFM4U+D5ymgb7dJundTO0icKEZcbuPRzijYsYgW+GIL38TPXYPjP2yS7MwP5L5UiYd81hIU3PUa89cV3/PhSWCc8F7Dq+iUFVIYqKgqRrFCpI5KmnO8qGA25wslY4bpQfbL7ZJHGY1GIc7LqMWAAcwO0kCityGuyy4OvVwPKZFVn+kepxJdUIVnV9DL+OyIPBKNv3uTzcBt3TbYCOXVUrGz3DftkBsDRyN03EFFbsCdF3s6oOIZcRPP/GIc9UER77IIuvr4i1pXCGkce1Wx7e8MgCZ0w1qwZJtNPKdyw1r9rBYlL/ntCfZLWCygQZrzj3WOPq/xQaD23cr/PWwlxt/Hf9gBfxrkY0UlbrQhJ66ly7OlPeCN3HhJxduqzbYnT5hB1gUbaDIiBcwk+6YgZzXJHgUfQ/vpGbHokM/EkNr6zlTk0wMKEAA7KHgN82ESpLm96Jnvnw1Iuu9hwoIxePYOEOVv6f2Ozm3Cx2YCxwC0xaW8aS1LOjaiZgjMm6vFsvk33JCbGTEuaGb//hc1
 PWRkaoNU
 xjFfcwjihaDv2UIXpk7JfM7quPfZuKscsDSmbiSKjqBorWfeZBk4ys7Pi5D05MHkTZ/OZfCXIFh48gvWRkXsTkRBNKqTN/RKN+4UVj/X3p56g9BHDFJrJh0QFEL94dlI7KT3gFehUUgB167KoGkpnUB+bKzgdQaH8aCbkZcUNSkOxofH+GuWOSTBP/1PqzVaCmPGl1L4BSrbke1vzShOQI6Dx76IrCCCPZxqO//N4UQCKVE/geKmzAkupNt0zDXNJrpki0OwXgmtlUeye5AkIFIjYD838OC1e2GASZpaP2pOkqhoW4pVWu+wd6XuoYjRwvZNmIvz+aEPXCf1nLpasgQHiF9CbM2xpmVqsEOmaEP4ZJF+GO6Mr+ARAr2GtEwfauJHe8SQG/3V5znV+xmWs0Z4QsMYVn+3xCBTYWLLv0ic0tfFqK0iNICY2Sz/K3s7HQ6kYdlx+LxUCABY8Y5Pea1MPJCVlAK6/PdWOb0ewyJsenkro8KXLvQv4mLWUMZos8/kHVCPGI4aEx1tIXrvrwgqmq2po+DioXmocGgGWy9tQiBldj3maD1ph/6NxsRRhmPp9VvBub3yk5MGszkLUksAeYtx67CMWvlqIxYOAbbpWVdwPzjobeU/O9DGwm9LSckic3ULOFv04bgy06cTCf/6Z3iHbxNYHwgik
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

This commit refactors the percpu block update code to make it more
visible on what to consider, e.g. when the new contig overlaps with the
old contig_hint or scan_hint, fixes the invariant breakage and also
optimizes scan_hint further. Some of the optimization cases when no
overlap occurs are:

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
v1 -> v2: Consider cases where the new contig overlaps with the existing
  contig_hint or scan_hint.

 mm/percpu.c | 124 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 85 insertions(+), 39 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..57fa67f3726d 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -630,6 +630,11 @@ static inline bool pcpu_region_overlap(int a, int b, int x, int y)
 static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 {
 	int contig = end - start;
+	int scan_hint_cand_1 = 0;
+	int scan_hint_cand_1_start = 0;
+	int scan_hint_cand_2 = 0;
+	int scan_hint_cand_2_start = 0;
+	bool overlap_with_contig_hint;
 
 	block->first_free = min(block->first_free, start);
 	if (start == 0)
@@ -638,57 +643,98 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 	if (end == block->nr_bits)
 		block->right_free = contig;
 
+	if (block->contig_hint == 0) {
+		block->contig_hint = contig;
+		block->contig_hint_start = start;
+		block->scan_hint = 0;
+		return;
+	}
+
+	overlap_with_contig_hint = pcpu_region_overlap(
+		start, end, block->contig_hint_start,
+		block->contig_hint_start + block->contig_hint);
+
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


