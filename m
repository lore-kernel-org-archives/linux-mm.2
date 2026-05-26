Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E48CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE736B0093; Tue, 26 May 2026 13:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E006B0095; Tue, 26 May 2026 13:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2446B0096; Tue, 26 May 2026 13:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 130E16B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8D401C039B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:28 +0000 (UTC)
X-FDA: 84810333216.30.27299AB
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2873C000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t1Fd98w4;
	spf=pass (imf10.hostedemail.com: domain of 3fd8VaggKCOoMdPN+SUfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3fd8VaggKCOoMdPN+SUfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818367; a=rsa-sha256;
	cv=none;
	b=yHeXWVY34127g7FVAH7WqwdR++wnx2gtrYgkzVQIDRPKNVdq/lHh77XJ/VmTllCiM9WG8f
	wJjvlMYq5mfuyKoShhhW7jcI4i7YpIaXVDoGfW6Z+TPwhN25xDp9n+zGq1btrIui1xEfQw
	2B7bWHb6Tjyurur+I26v2mIx82PYxe8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t1Fd98w4;
	spf=pass (imf10.hostedemail.com: domain of 3fd8VaggKCOoMdPN+SUfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3fd8VaggKCOoMdPN+SUfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mHEuoeqgeJwwKsR5vVxh3j7NIc/RKdm0H7T5NxNZG0=;
	b=nBj3aGMB1RVYXiJHUwXcJmGKmiJpKgzmpIlADQF3AEBvwAin13mrqIkqSXOzC72RqRfJJ5
	QmqqXgJp1wZHCSK+Oi5xmt/SJ+ITy+Qn+sM5id7/obxdrWSPDsyXIDnzORLZ3U00oDIjFS
	yFPZvB/AsOwkBvsVJs6iNv44/F5tGW8=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-44d83e45febso7693173f8f.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818365; x=1780423165; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3mHEuoeqgeJwwKsR5vVxh3j7NIc/RKdm0H7T5NxNZG0=;
        b=t1Fd98w4NnYBBwuPhXBahG+8cVY0BaOq0uq0bJQyHGrKxXF/khH2OlfjQKbIdvt0TW
         mWFHSFs9kavkTFQQU/jT/KwGpsENyqutsOY1gFsi4+0Rc/3h5NM57al/JYkTS8w0LduF
         jDrLgwir5gEjFgFAwTuFLZxVDMFwVyAPEdhQhQsey1Uz1ww9OhDsyXImzB78X7VI6KoU
         DxNrE/QaqAPtgEU1LZE861PQue3kviyCTcbZeNxefJebrWwLwFlHQtIf23HpuVxqYGLR
         EqjefxpH9KQ5Xz87Wl7vvwa0xyJALkP2bp7S3H9zg2K+Xls8IdlJ6gAWMPkyIHRcKg72
         54Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818365; x=1780423165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3mHEuoeqgeJwwKsR5vVxh3j7NIc/RKdm0H7T5NxNZG0=;
        b=gj9PHmAHJ6+lKN8/kdjyvj0s0y4krrJSR7TUmiPvI81OXtZZQUgsBYSsQvRxGOBUw3
         ECz/zn7b3DFWtHukjTKlk1rPhCFMUCk86nTne/WJ8aeQHi7+cIcVED4O2NjPpXntqYEB
         NZLtKunyTIKo9NUTxE6q3ns9aJ97JDB7d7bTKesSpUWRaMnc6cRqSIiq893hnaWAOeHV
         wYdxHJIZdNkOmCDbABzF5iYHCt1WwppsUPsvvHgqCgOtVHsdjW9W9vEeKILaOdVHf6F4
         8nO50KWa1suYVxsGRL2akQwXLgmx3QsHt+mFMsRKZytrhkzT2H1DRqK+qez9bWpLA0c2
         VEvg==
X-Forwarded-Encrypted: i=1; AFNElJ+zFlqJmfFBZFPpZfry/1rqcmyCnIpaCrp1mhaY64hnYH52ifvH9IPeJPH/k1+f3NWAW0GObzzJuQ==@kvack.org
X-Gm-Message-State: AOJu0Yzo1odXL21My1/rMZTmY8DKAzwQOTSb0e1siVxdpNsoqzxXcSYE
	gnUrw6gJsn/cnJ80p+3ueFabZBfuzLwLM4iuJ2bqlfGTEuDTu+dRAR68K4iGrrma4K6j+FWsVA=
	=
X-Received: from wmbh6.prod.google.com ([2002:a05:600c:a106:b0:48f:de29:3f52])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a402:b0:48f:e230:29f5
 with SMTP id 5b1f17b1804b1-490426b0c92mr233953415e9.16.1779818365325; Tue, 26
 May 2026 10:59:25 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:51 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1360; i=ardb@kernel.org;
 h=from:subject; bh=HTVCAgvGTLScrJ2CZV4D8VSId3uhva+Scq8FVpoE17Y=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fgzPcSP+Z1uPSc089cXOMuHXyr/rHy2TE5mx/o6dx
 X9ece7OjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARxViG/1GnxVK2TMh4vX6H
 yFPbSV03ey81Ml2OaYnZZ/vlkGzNih2MDIuvZ3AHycz03hNo9ypyg7OB0C2/DLkSk46sXolZjBl hfAA=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-21-ardb+git@google.com>
Subject: [PATCH v6 04/15] arm64: mm: Preserve existing table mappings when
 mapping DRAM
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
X-Rspam-User: 
X-Rspamd-Queue-Id: F2873C000D
X-Rspamd-Server: rspam03
X-Stat-Signature: k88f4offcpcsp7hakabapsymwjpdho7i
X-HE-Tag: 1779818366-951385
X-HE-Meta: U2FsdGVkX18jR4LpMiehlYR06N5tS4+ZO7yWe7mvKwJ6Vgvl1/noQ6Pc9TAqx98I7+WgKsYEDQNHMRNrNim7p/EodAQAfBSwk3mU4UdeRwI5CiccoENV6DZ14uufkuN5bQ9Ffw1TLL/hOu34Gql80BpwTC6Hr8cHKtlKTNk1e5ieqxuupkMqi6RDRNIhtVK5Ihfw8+CCDGC0wE97cZhVW/LhxI+WdbSfp3chLZPDbF0TN4z6buqFhymYOkWbjZLwEcxTqMbp5GcKbbuunMNNUpJ2Zakz+I7Ds0DpclVkS2L80IzHjEt1L71P1pUdnTGHfcM9j+nTWeRBw2JFwnuoZK7emtQfdWYuuxT1he7YA8Ck/vOYqBqQf2/g8H61idXARYP0O72qTOWQZJMlwo2eDfO2WxC8TZVyID6ccAj8ZV6dtVgT2S8FYKM5UFTGVomwSJktx6LiIOG8ELzdfiZqBlES9ZqNVwv1ciafKpCbHjtVBrUZrKMsrj1QXpYR2WtnHoWxCn1hqYCLbfVK7pw1jVWl7iXwwHlvJB2Tl9BWHTJxuHh/aRlbUdHD7q5fXT4XKRm+WoYDVuJt+IJ3wNlPHeKKKvDcQHjHrV2byD7qE2k9bitPiay21qu/9NUBflNgWfqUG0BAD9frYfIV6m24ADROjGmR7GhuYKBLpnJ8VfzznUsQVbh+DgZZt7/CGnXbmiZebArELvlp2P6+s8HHjgDngfW/uVwyYK1Yuz00jGQBlz6TN4NJYSqf7MRbU5deg08cMHn6x8IEKo+QHaVp9+e51WMVCaXkzVQvE0FMM2955EDabOZ+q4/yzS7bmNFjddmf173VdG+FZ3R2YawNbcCwLG1xid6Xfs+iot3DK0ILmzQQM1gDP/8fVdOhOLRFFzzR9v3jLA2sKyHlkLOutGrGbXzwJn0ClFpn3q3AdVst9AhJ9oI7frzk7MfuS+ZqyIvrtAXnk+MWyYWnP1p
 J5MaTxDV
 nPpu8zS41KBgq9JX/6u8RfdeZCSuwQjIkyaLilZlQ3gj+BzDZiHMaMkCIuoWPAedJ17f2l+SLiuvFWV5ht58/uqCn42rLbjT1ox0+HkhTYOM1j7DEKyu2yztl7BwIwFKSmUNVR70wdeOqbHc9u2rG7o9LpWw5RqfWvCaXhONbE2ky5PAl1QDmzSLcsZJTymj9sXvGsX76FKpkc5q1cOgvuMm+t29e8/twW5EoLj5lbH23b0tqzATA7D/FWVLr1tirNodFbUNyiinH6LQYB8RmAHoCISv1NPtxUec9X6MiaAHUaOD+50u4NR+KHAYXPLQfwl0nQ1d78To+ZSCkVy9W3RMXIlWdL05xwS/ohGfrdbegTEGbt8d0D6zvfjPDyRh60xuQGc9fmvP43Y5vlrIuASZ0QZ3/20D31IxANeXiyY9psy70Ea/wvLzk5xkBR2A+ws1WTDEHSx4eZY1+jt8VxUFnG6K28iXXMu7vZokpoW6lDwK89r9fbFr1K8F3+fbjehKPfOIGMJJwzU0mQrCPIHs3PDKYK3HtSuIlopfNyK/qcztK4xNfg7gxnfHsuW7P9ZezHoXT80tYxT2YFMtzlCPETMMYXIOnyXoGSIQ1xReH/nLTqh5VbhFYOpwY7WIC0l6l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Instead of blindly overwriting an existing table entry when mapping DRAM
regions, take care not to replace a pre-existing table entry with a
block entry. This permits the logic of mapping the kernel's linear alias
to be simplified in a subsequent patch.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b2ba5b35c35f..5c827fa3cd38 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -256,7 +256,8 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 		/* try section mapping first */
 		if (((addr | next | phys) & ~PMD_MASK) == 0 &&
-		    (flags & NO_BLOCK_MAPPINGS) == 0) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
+		    !pmd_table(old_pmd)) {
 			WARN_ON(!pmd_set_huge(pmdp, phys, prot));
 
 			/*
@@ -379,7 +380,8 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		 */
 		if (pud_sect_supported() &&
 		   ((addr | next | phys) & ~PUD_MASK) == 0 &&
-		    (flags & NO_BLOCK_MAPPINGS) == 0) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
+		    !pud_table(old_pud)) {
 			WARN_ON(!pud_set_huge(pudp, phys, prot));
 
 			/*
-- 
2.54.0.794.g4f17f83d09-goog


