Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E99CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552906B00AC; Tue, 19 May 2026 11:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCBA6B00AE; Tue, 19 May 2026 11:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376A96B00AF; Tue, 19 May 2026 11:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C10F6B00AC
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1C3814052D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:41 +0000 (UTC)
X-FDA: 84784526442.28.8336F64
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id C39FD1C0004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sa0Y4Wk3;
	spf=pass (imf21.hostedemail.com: domain of 3Tn8MaggKCNU1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Tn8MaggKCNU1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeNX/sq3qAeE+0Jgb2gDcjXZ+vgfMIqyhOsW6MWEq5o=;
	b=laUsMfVFSce8RAfNgnU31J1WCGJMcGyxCxIHcmLza9OwOFx0JS2qXAr64xuhmkzewwmj1U
	vDtLEDsNaXAKsdhF/+AH5obqXz6Ke6xu8+RjSTVHmA3qnLDLaZlIujEVVIjId48sd6G3DX
	fdegdt5cw5UwsrG+7a76FKzCMClG5gE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sa0Y4Wk3;
	spf=pass (imf21.hostedemail.com: domain of 3Tn8MaggKCNU1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Tn8MaggKCNU1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203919; a=rsa-sha256;
	cv=none;
	b=f4ubXlpvOs4Glq5yoZr54Y494IvCrI33DY1XWKAt9dZPP/k2VyVIUJFaaQrEQbeo47zW7g
	XzKOVpEQn8syajX2awbt9Js/x32CF6Ih+ctxQdjK+/FX6H1/PvoMvhZgOctSVxVfn2rzLx
	QCBCs5L4ug8oJYTJLUPA8NXRlf/WcA0=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d7a5b9678so2470905f8f.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203918; x=1779808718; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PeNX/sq3qAeE+0Jgb2gDcjXZ+vgfMIqyhOsW6MWEq5o=;
        b=sa0Y4Wk3y7TFglwmb+8UXJV7NuIUOPsY4zYE2PRzBsXpeqUukV2kww59jE3LmZmLzx
         DJhzDTw+Nmw5jahXQHB5e4p0GvYT/TUIBe82sm00Z/WeHFj3Cx/6olR4Wbhr6YCaM+jk
         bvhEFjnKF4Lg+UTn1TfLuWJmKM/RF6Blc6FJAyuOLjCviyTFYkBFIpjwtHLMkbylQXB4
         gRDEn5VUYCCoKmwav2izrL/F6ZQdo4qr1iLF2+ETpEzKd4yMrn9QtIpEquEQUgrzJN6x
         gKHLS3lzbSPSeFEx7PyQ7q2Qi9Uh2ropADDHyGPWSfdLaPl5E/8OIaoq70g8WbDC1F6d
         CQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203918; x=1779808718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PeNX/sq3qAeE+0Jgb2gDcjXZ+vgfMIqyhOsW6MWEq5o=;
        b=VJz5V88ttC6Q7g8CB16dOKbL+MYnO2ajHPUUuwq//0KGo2McQKxTwZBWnz3dmaxtVU
         6waWqzFQNxAhcKCUdHaevFDwmwMr1xRJSlY1RKgkn5T7ReJZ5Ro2dQT5g8p7jM4nVpLu
         GaC6+sPCbKvquZTAy8AoleRYbX6QbLiv79IsJlbwF0QQiHnCxRkFTEZDEiTBX7qGOLsq
         Mqaacd/ixH/6EOfvGZUv/CbxgHwjVGmYx2WV1u1uuElmP3NeP2M3r7iDsfLe2ea1USXN
         Jf7nxF8s+LdOog89kwdDBtR5cExYQiRvrp4NcBn/HMXQDlUh02Ix3V1Tl/ttuqOEvmQ5
         7Kmg==
X-Forwarded-Encrypted: i=1; AFNElJ8mWri1Tg0ERUa+RZbz/KdjxB4DN0IsJgh/xC4g4rwzcXSDwlhaI+pNFUplH+qeAqsJecEWnMWilw==@kvack.org
X-Gm-Message-State: AOJu0YwCXt3ZY9Q3/da87AzH80G2r2YYG30dTIBV7zfYWhTOGwUfFEe1
	DdTwxWYZPCtRsXcUqiEAqoK1vqDOP0qXPDAnfvgN4k4h5ZJCzkdkAqCOxq/nrNjonESzDYXOXw=
	=
X-Received: from wrvg5.prod.google.com ([2002:a5d:5405:0:b0:45e:75ad:a480])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2dc2:b0:43d:1c4a:37c
 with SMTP id ffacd0b85a97d-45e5c5b39admr32448104f8f.4.1779203918084; Tue, 19
 May 2026 08:18:38 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:28 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2478; i=ardb@kernel.org;
 h=from:subject; bh=MII6/zkHQg51STWxgZiHeZfac7n0lgddhJ/OqCE9V7w=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7tKMjFO7jkszG8aGhd+QSjw303b/L077+SfKAjY8/
 6G1aQ5zRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIzniG/0F3vjE8XuemeP5j
 peqFf91N8ZO/FNi7BhXKyu7ySV6pZM7I0CP+aGHaheKW3W4s3w4K31V9s2v3jofeLfIF7f9+95p 8ZAMA
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-26-ardb+git@google.com>
Subject: [PATCH v5 11/13] arm64: mm: Don't abuse memblock NOMAP to check for overlaps
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bo9h84qmk8eq93yi8qzb6duiurb76jto
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C39FD1C0004
X-Rspam-User: 
X-HE-Tag: 1779203919-300661
X-HE-Meta: U2FsdGVkX19Hc6I+KpBOiUN8ns5QSjlp0K9IVFyVEVaBoRq+jC7dDgo24Ap/tkZHM6H/1yfAf3ACvJKo+WgakW2ota2rolZ8CZxKFCzsMbYZdrw/XshuaPjqJkIYoU1MHIRxjeMppvuKIoxCtoRgdrnPJnt+qHdNPWncpBnmILPA8FQ2PZZ81VHKfOzEtFVSQ9ljwvQ3qmgZlUoyuSHhGcmaWTyrHXyco6E4SuENbVbTKWqmLy2+1TvISA7hYWwB4UzrXeo4jnuJr8+bHqP5kmbwqO2ddzm6WUCTMozKE1/8GhHCXmf41MlFGRKZPcCvhD/xD+0B9BuwBPncr4ulTGobVecWhKErFLw8b8Q1ZS4tJ9JKb9Ww93ag69sNMy6dRMW0Oru+1gXYcaJfpJ+9AXHQyLxnG58I/RCkQxv8G/TM8KmKkfZlTx90Md0/BXPBGiQYiT/Y1J7MbUNCEKPynJEtL0dtRuAf4Vx3ZUkuKjihyKfTHX7I8hn+xDEdecv8irUHqAYdbIjbtaTkN3djSP2aPSsKZcZR8aqZt3wBtvDtxg6nk5NZv9FPWKPlt8EH3fZnI9dFljVZE90xbjnTOes/QN4lzQDlMxa6w8JTKcWeOZgchfX8jQpZoySf18kAOzlq9OENw9PCOoTbOO04C6JauligWAaG6tR0885mTS7D54Vl1yRVXxf1o9tNOwndrm6yuMF6Fe8mCkoGZtuacPXwv3hVfhZrwUgjTSnyvyN4o2+ctkq7CgzUa0iyQGDL+c+1QZUT45S0Sf+J2v07NEgTSYWo5TwXVWOd3FRnsYz7ZHa8K9T4ox76Uvaw2GKhH0DJYdIYySzKoxFhVvmShVZMjVPqzBDvN7wgfT2FtDqpV53dR/IGUvfsd9KSLMeNwupfIVEI6Q7TN3PLM5aI4shHsyze+6pZTL7poEzufTKDCHjc7/gIGdMYRhC3g+3S9rT0tBZ+6WGgpTeTGkT
 uM/63lKI
 0eHH09Ziz5N45DK69Sit++GtYSLwnZ9re49xvDY0g0WW8jp8iDp2v2mj4upPdUJws9F1m7DVBkuNNKclhShTT2Hm8ig1xWeStT+DdVdIe1eZpbC/CASyYgFx3LXndhMnLFOC2eqHypr1IgiIxNraC2S0eDL+KkmA4OAWlPB6uQCUkmuLfAecb3UGJrkpiECRf6saIDLJWUG9+BvBBrcbhM6DF1ao+VP8fqTY2MIBFXFAPmqaASIHKqNvaQrjRRv0/iNS9aVNkzjwGa4xed/SgsUOWZ1nF+yXrcVOpg91nbmpUuYyyTRVXNXBcELzfejYd2mcdJFqtqVHqe+YSVmn1nDWGVEKuOHhGW2QSn0N6cY8WlBZ4p5l/hNNas9nLdpusJPrbi9a3BKFZcKYeodl67oZ7fgok4xshS9ldcZL3kU1/rQIshAbEVzK0QJWoggMoW8xKwjqI7EVK1057MQ2AetA/rGA0ENXUJtI2S6JkXQrNJETu8NGmOi+xlUkXAO1iofdDko2SpDZfYe13aagL3J3vfR/xIVvhS6mZRlDkaDL4LN9h6rYEp+bpNNWXBlEHq30l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Now that the DRAM mapping routines respect existing table mappings and
contiguous block and page mappings, it is no longer needed to fiddle
with the memblock tables to set and clear the NOMAP attribute in order
to omit text and rodata when creating the linear map.

Instead, map the kernel text and rodata alias first with the desired
attributes, so that they will not be remapped later with different
attributes when mapping the memblocks.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 24 +++++++-------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d4ad9e4766a6..dcff1a538f20 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1148,12 +1148,15 @@ static void __init map_mem(void)
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
+	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
+		       flags);
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
@@ -1165,17 +1168,6 @@ static void __init map_mem(void)
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
-	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL), 0);
-	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.563.g4f69b47b94-goog


