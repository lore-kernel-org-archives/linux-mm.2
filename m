Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C08CD5BD5
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD7A6B00B2; Tue, 26 May 2026 13:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839276B00B4; Tue, 26 May 2026 13:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B21B6B00B5; Tue, 26 May 2026 13:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 504EE6B00B2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 038151A0455
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:36 +0000 (UTC)
X-FDA: 84810333594.11.D87F804
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 26D1B100005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JB+UeeA5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3hd8VaggKCPIUlXV+acnaiiafY.Wigfchor-ggepUWe.ila@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3hd8VaggKCPIUlXV+acnaiiafY.Wigfchor-ggepUWe.ila@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YEs+3ha0YZ0GL65qiPfv2bavm0rO2bwvFUt4jkd+Vg=;
	b=tHHUudA4EdKViPjVH9qX/5eBcducJm5rx+QOJDJbVXOkXqxfmUmFujXeTtZ8C9q3Y1tw/e
	duk+iHOXRKpgImtKBy2sUmhIvPRYr13rIO39pA9WR+tYkRSix+TR+Q8LIKitKGHF7s/hiD
	jmoYPcAKCCCaJ4ZgOAtWa+GDuBGtQVw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JB+UeeA5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3hd8VaggKCPIUlXV+acnaiiafY.Wigfchor-ggepUWe.ila@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3hd8VaggKCPIUlXV+acnaiiafY.Wigfchor-ggepUWe.ila@flex--ardb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818375; a=rsa-sha256;
	cv=none;
	b=ydtggeZHFMfln3YzA82XdcTYwHDtJEEzfi/fyshHBKMMdw3cVHt4vUl8UOiPOYC+bj2jx3
	hdT4EdVFhKgu21szwTjXULGcm4OrD8r85qjMpkk0SlxSflrSnGo8BbgiJcHHYhJGYXEcJl
	mbKfXrSi3thUt+27jWaBTyUCHf0eNWg=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49058e91639so23202195e9.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818374; x=1780423174; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/YEs+3ha0YZ0GL65qiPfv2bavm0rO2bwvFUt4jkd+Vg=;
        b=JB+UeeA5eap6xukYcOgqQjFseUdryPFZXVEQqF6RhwBHG2g2o892uJ2SyQotDOw48B
         PrAWY0DEIlnZaXXJjZgpyuFqzsXI9njdQLUT2kd4Y8Ek7B6lyrN7ZYADiUyVp7/XHNIl
         AYivT9XFAr1cay0rsksHoDJkcwg7h5kglqXBwZIrKBCXLBrS8eFkphN6NPEwfUgcDqdV
         gvVBUuR2b4s5lKHVlrDm+99kdm4dz3m2TOSC/8JfKdgNChxZ3JtxW1VlAg72BMhMfjjv
         Au5HFtLtxI4zVKX4neXcJVRdzdlDKnhz7k3iFTperSUY5VeDZN2x+FuGsuH81S3VZte5
         zvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818374; x=1780423174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/YEs+3ha0YZ0GL65qiPfv2bavm0rO2bwvFUt4jkd+Vg=;
        b=GF9km3/p3CFnkluzJkx3kdbEpTBzLzTYT6mDRXAoZV+2Ttqtinj0fvRYaFfpUoGwkU
         dOMzObxtCbbBXvYEUI51TWlikY6EgZA7YDgS5ZFS8b7PrbG2CaVJ7QzLh+Tb+2wjURFP
         yc5ZFvo0l2ayYcaUwmsJMhjZ0hgzMBVjGLzMwUZrIZ0orRZlSAvN51jZL4EUXBGjJ/+Y
         yGfjmwB2vmdsg1tltk8THDOogmAXs4LindYcKCChP4G9ApdE1WtFym7duTpQSA5powMA
         UCPQdhZuFDP3TTEuckZOV1pYziMtgkLR4zoy6sbLf7gSTemOk4PaRcydX78pwbTkry2h
         PUQA==
X-Forwarded-Encrypted: i=1; AFNElJ+jbKY83XzHZ2taY3HNqcu+xy8r8DnjR+y9UEo85rz+8GG1qmYDj8e3Jrs6FCBBjKl2/Jv0/nerYg==@kvack.org
X-Gm-Message-State: AOJu0YxoIlwf16IbgpOEas+zMKyCDugT79prt/rF8LuMkdcvwUJr2Tr6
	nkWXfa012ACB6JHHBZtfdRNLe5qiV7RcYYLQygwHeIl7EGlpCZRZsrE5lCCBrgXtNgyCupbybw=
	=
X-Received: from wmri26-n1.prod.google.com ([2002:a05:600c:8a1a:10b0:490:49db:2263])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5298:b0:48f:e230:1d12
 with SMTP id 5b1f17b1804b1-490428dd63emr346556585e9.31.1779818373602; Tue, 26
 May 2026 10:59:33 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:57 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2521; i=ardb@kernel.org;
 h=from:subject; bh=IVFHANRX1Y5B7sO2czLQgDyXUEkQiTSy8G1FQDCgg/E=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fsoLbrWLu7gSw7a4He9yccnfFaz2Zfnzl9euX9kmw
 5F4//u9jlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCR2HhGhum3KqfUzpnosfjs
 O4PZz65tu/Cten/afJ4dmhfPiNRN+BDP8D8myOOB5p+Lm9QF963bJLbl3IvwqSc/fj98Oa1ZZH3 U5m2sAA==
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-27-ardb+git@google.com>
Subject: [PATCH v6 10/15] arm64: mm: Don't abuse memblock NOMAP to check for overlaps
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qfnn81hhywmndid6khshq4g8de6gw6ht
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26D1B100005
X-Rspam-User: 
X-HE-Tag: 1779818374-414071
X-HE-Meta: U2FsdGVkX1/Ys6YqJmEl4fpZ3q141X6vLuVB7+eZ43C0FEJUIhMyBNj5HDVu2BJ05G97vLvDjqO+ri4SE9dA8QpPTu5qTaBn0/9bOBpKwO82faPud+mpl1BdPfqF+PV4PjTBbq0efYySMrRflymlwUJ7j5PhAh7+ZlKRTmt9lKuqE2Nx08FRZ/saS32fRXI3haRGKujhj6yNX1ulg4/4wod54GD3Jh0nkoRYsSns8hgV3qdnrk0AxKJ3zUNbdwi5yRZxSXed7P/Ev+jtx0DUcSK+F8IUt7pUL4iqucwGc1ErkuxWOG0TTaWElmEXcGvTCx+RWkzfmBkjgwisRvxr4VgcBp8HXLwUyP4zdhmHuDNBPUZPp2y2E5r0ltyvDGbiEzL3bUk9J0i9UOvuZCkMqGgAOOTdLEo6kA0QRrRG+UVB97rvuX/lO4IQWTH15fELBIT6cHgw9RZhJhuAlkr4EDjPxDdSiRxBYAtr2/qCDMRHlJjDj2ax5N2BXpAl4EsQ3/zCiH8OcsSha4hM4yxVIJihhiuDkYWMg3eYzWgyrorrU57FLJEJy9aWxSBdOyr7eI06iE61aoacu7926u7do3klwS4QXy75kZCis7BGo3z8QLh3F+bAxc7BnYNf0ixBTFVg9IqTlHOafcMsJXHwWMF92tD3u38kidl1VsnNH4OAmSZlQK1xogjr/A+xWAmG5CuGzsWNApJB2EpYKE40HpZFU5SGg0E0rpbzdLJyV0hzhbSRwoyJx556U6KwU7vBkIkb/aD8d4OmobtN85sBIwQhEsi6y8A7RwNU0vJDzXVRW8cAJXdLlOOLd408vUIkbufN4HFo9l0YnX4jKXjXyFkO3Oj4oQqwR9O192api5fNRLl5h5CFm7ou2EZqfT+NxK2+HRBsUqDTWY0EBkCazAbHvhvwaAZtNYhJeAFjwhLRzJYuNmp912iUqOWHcYGY9dTHzABLjwAvWZEpWHY
 D8bfk+hn
 MMzuIaoEkljNXLTips4AQ2/+DgM0sRqu46h4rDZO/FfYt+KGVT7eP5w5Ff/JJjhSdqK6jTRBMZCxqwU63PHT20k9XBmQqsZXIMhfzry6W+WHPnVtJhS8XLiw+5e+23rok0Gzm5gv48wbR7E0tzIhZRKU6sJCKDuRnPlW6SE3BqKgS++oZrh44adboWebh1GX/zMzvRTaPSgpwAYyKYSr9n3EUN0ellKtg4Apdjz0l8S+F8xLN9wE0OvZglNoRb2owyqHLRM+SligLYvm3kyIrhMa7bqR4S3s+XiHEuiVm5R81irFSXjOnzoGdnVQ4wrTRRDhof+K9SFDRnx5wvTHB/wJaJwK4gO7AG6g+i0CXYcZsbvFVevPV04WX+j0hM35L37sp8BWpCn2+0LXcMFg7Ip6W+DI/Eb1eZZisGnG0R/y3qWO1PM7PXvk9TWj8y+GMSENbCsFTNNxELfihe2rjakcQmkbLgQVtXQkJmQTgxmewhYbvjg2VS9r3xnihz519dmdUA7D1qvVeLeC/7Kq3D3Y0t7rYIguAUoPPx1OI8joDyRc0EiyQPUeJuHNLfTK79BYI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Now that the linear region mapping routines respect existing table
mappings and contiguous block and page mappings, it is no longer needed
to fiddle with the memblock tables to set and clear the NOMAP attribute
in order to omit text and rodata when creating the linear map.

Instead, map the kernel text and rodata alias first with the desired
initial attributes and granularity, so that the loop iterating over the
memblocks will not remap it in a manner that prevents it from being
remapped with updated attributes later.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 23 ++++++--------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 04cc579c7a15..b20c76b8381d 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1164,12 +1164,14 @@ static void __init map_mem(void)
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
-	 * Take care not to create a writable alias for the
-	 * read-only text and rodata sections of the kernel image.
-	 * So temporarily mark them as NOMAP to skip mappings in
-	 * the following for-loop
+	 * Map the linear alias of the [_text, __init_begin) interval
+	 * as non-executable now, and remove the write permission in
+	 * mark_linear_text_alias_ro() above (which will be called after
+	 * alternative patching has completed). This makes the contents
+	 * of the region accessible to subsystems such as hibernate,
+	 * but protects it from inadvertent modification or execution.
 	 */
-	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
+	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, flags);
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
@@ -1181,17 +1183,6 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
-
-	/*
-	 * Map the linear alias of the [_text, __init_begin) interval
-	 * as non-executable now, and remove the write permission in
-	 * mark_linear_text_alias_ro() below (which will be called after
-	 * alternative patching has completed). This makes the contents
-	 * of the region accessible to subsystems such as hibernate,
-	 * but protects it from inadvertent modification or execution.
-	 */
-	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, 0);
-	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.794.g4f17f83d09-goog


