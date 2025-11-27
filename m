Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91856D116E4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9AF6B0012; Wed, 26 Nov 2025 21:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80ED6B0022; Wed, 26 Nov 2025 21:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBEC66B0023; Wed, 26 Nov 2025 21:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDACF6B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:24:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82597505C1
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:24:43 +0000 (UTC)
X-FDA: 84154793646.21.0646580
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id C043E18000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:24:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XiX6UpPx;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764210281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UH9cMey8uTinDekAOvafFdeDO40z05IAA3OJgPd+/CI=;
	b=YC5zOCfpa1QKdqrnEwSm+KEk6dEe+PKDN1FG8GFGcIcwHJGkN/mS8rbFb9u33DIn4kK2xR
	4CZxRz4JCJ1A7psdIvHFv9aj7RqLjvHe7ipziHu/4lDRsXcHr8yOhS/bAFbifbVwDR5FOw
	9Nj9nfK8RftDDWiSWq5wf7UAjRpA9Cw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XiX6UpPx;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764210281; a=rsa-sha256;
	cv=none;
	b=XZ4TGQHV0zMqmyxW1n8v0HXcRmkhswtwxjS7PIdRa7gV2t0Ez+OYE3+9/O5L8jHc034zzT
	QNJhZGwaJFAX13T6kEgWKwE1ATXy0nfxmSTUZKugjYDQGfXp6uUPKClC21SuWanFgc9bxp
	+HLBj748jTOHLMCE9PsveK6xMyF3djk=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47775fb6cb4so1772925e9.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764210280; x=1764815080; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UH9cMey8uTinDekAOvafFdeDO40z05IAA3OJgPd+/CI=;
        b=XiX6UpPxv3eHpsoZh1rOV4HQpjgUli2RzFPkCzew/5POPvBUj78IRLJcaQTSyuYFy0
         c3zPdBe0AJGJQw68uhTwdFb1rbvyJLsaOX4mT1QFIGfhCA/HbR2k7wATND3PGPOlQqEZ
         rUSu/R/iBg2S2tATdcfKpj5R0YKulq2rOuYN5YWCANNocJJZjsR60VuBRNXqfxqcp8vb
         DVlaBDKMZywXIV1wvLhj7IOExfutOCGx1WbgnUCTaZHs57ArzFhblASWI5f0q9KCFFW/
         UwTmpfVc6duDdZHR3+3MKBnLgDluISb4NtulH8xscrBsKVaMbooVZot8Os2NuWTA1ILN
         cLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764210280; x=1764815080;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UH9cMey8uTinDekAOvafFdeDO40z05IAA3OJgPd+/CI=;
        b=iuN/61Vusq3mhj2/IUjV52wFa5WTz8nl4KIepxcRNFOi3Nv9+Yt8mCjBH8RB9OhEoD
         JR0FN3UNV0pr4dASF0xkw8pfe/wT1IK0rsmaHqsM3J4iWZlaA6nuMK0NG3FW5zrsDe8I
         hj2qJXw12AQbYHEBnED/dEioJY9h7A8K7OU3IBDkydvU7kTTZImJKmHFOQrogx/2KZaI
         Kij62UcJI/p3S7t48PhLfhGpoXLxRkI6zIwLYqJFRRu4/B+cwwz/uSsizFTNBIRQ4LgU
         JHSV6wonJcgzFy3BWD62qv7M2PL7LApeBN02kp+8N1k77OezKrG7kXnp8qHQlM0/NOvG
         +Rig==
X-Gm-Message-State: AOJu0YzM0Zuj0aFj1PY/GBe5xrN9kIrOk2Lv9TQVKCXaofJpAiZ9ZKO1
	rccsWvWSo90bhmD9tPf9wq2jkkPu+BifCfDsXohOA1HJjO9yPF4YFRi+
X-Gm-Gg: ASbGncvPbWTAX/qQBFJBHdg+Cr0ZMTIuy605QhwKcZ9D7QAoD+B35vh3nM42ruX6Dhn
	9rene3mdOJRAs6ZIJZuvkVnJTYvmylMGLe1kV3q1IkYliwdWP+asIXdbqmF0AMLKWQUhiicVtt2
	9mZcNK0pDbn92Czeezy1Fx6TENGCUazLv1xlTFr/aYFJ+Z6pvbXcUhUB0Ro3S/ESXbcoL2pIfA7
	1ET4Eg2oGiQUPHPSJBRDFdiArUVEJ6AflkCXF/76TnGY/7PRK3T+dIxZTWq7n+OTDLw89bkr1os
	kCCo0hGbCfAxLGAUSce7bCMPzCQCu0rRZohSBrBsJSkTf7QR24KlPFyK4Ix1Q39nR4g37mJZZHy
	ud/3hAyiS4UlLIaEAg393igR8J5RlQD74P2ewi8VTpGbZv7uMO7KCEkmP7INjyTgksJFCRzLM9i
	80nkSGilRkeQ==
X-Google-Smtp-Source: AGHT+IFKoDEgd2rejhMd6Cr42o+gSFQ8jkGKIdhE/yPyqv00pw6YfBqhg8r0lDimKNF41860Y+bJ8g==
X-Received: by 2002:a05:6000:2281:b0:42b:2e1c:6341 with SMTP id ffacd0b85a97d-42cc1abe28bmr24669897f8f.9.1764210279771;
        Wed, 26 Nov 2025 18:24:39 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c3016sm702108f8f.1.2025.11.26.18.24.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Nov 2025 18:24:39 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/huge_memory: use end_folio to terminate anonymous folio remapping
Date: Thu, 27 Nov 2025 02:24:36 +0000
Message-Id: <20251127022436.20734-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C043E18000B
X-Stat-Signature: 8nuza1i99cjz6bbxadhikincj6niwg1q
X-Rspam-User: 
X-HE-Tag: 1764210281-566730
X-HE-Meta: U2FsdGVkX1+KV43Q3cCcayImS1W6tgw8+3Ss2EdASwrMghtqKmOA/007+kC86R6VJLgnUH5tUzokLaAuqGE1aRqn9uHGtY1yX4DtJid7gowJz+jtiyWfEbenk6dOE9TF0xqnkn5+FJDPEsCcq8iPxYSL2nq1c1Kt8QTmtNdwPvQfhR10KdNzT27ebm0j5eskEXOAYtjJ6jVmWENK8xtYKfQv1x6SGhjYpCZvOge2cIR/5f+EX7e5yanW6t7uNerA9VvADpFkICZhkLSBHMo+WstKTOwlW7e+Sy4ZB0BfUJMAicEcTkj41H3Bu1UrdHy3qsluIeLMGfxH+5C0+37JS/GLO46gQoc/cJznbAT56/kKpgRfv4IFTD60jNjq3F9zTDkN6Q0oKuWMKvsIVqDZHX+ildCrKhDcKm452/+znxlKTuIHkGW3s9MFGKJOG5AninPOp76MgPG1XhfxeFtt9ydLYYPvVQJRyaQMzhfvER6qnZfpZ6p4kCE7M0hr7C33TFUcsaeWli80zEw6uAXnSaUV1gUWLiDckxpsUiv7y0iNrbf0dZaXBNycjSucdmx5prIIJ69TmXz39upJweR0iKQWLaicTbqcV/uuC1PWxKGs5zlgN1skyQ5RlSM/Za/LkYdd3ZoXlixqHVVZ8Je7sfJDUeET54x4SQ3Wkd0LMwQxXuZ02bGttJbdmcaFYoHw/MvWPLx0Pfc4ZJdYTUjDMxDxkCV02qP60aBHL8dxmWrMlQlQj2LCNisJJB6UpfJrqhvdsBR5xzfsiiC7EVIlTzUuIlLhtBhNkBdiXN7pIodlbUz0ABSbo8gbUqKuoRoVO3hoSWRR8BZT5zJgE7+uJ201ruO5qTWsWvIOknNTsczds15YXvSdf1i+W8ujvQS+wRvRBxj3aakfmEDGAcqDPfH7irEfF2biu4XtE2Mj5xaS/tba9tpT/yk+dkcOMLoLhGSJmcm3OvE7sbuEvj/
 Gd5XCwVL
 msYQOoKnxs6PqjrbOyPcPwIFXEl0QW/x8/ZZenao3kRKLiwTStJc9SRbMoosSO/+Vh3/hI/QLSlPq9APkZNmLUji43OcRfgwr9L5Ar//eER9YQ6mV3tEdnLnhbm+Shqh5KvYa3NZ83E1fwv2RcKsI+WqKNOviYxN0UjRQ3uVQ8gy8JBt1V5hAjGm0mIIoRLZ0cJHFoDSwTNt9bldm0SMRqTeqgQvER0gfLSSVLgyAvm2h919H2fQ69PewQVYCo/+LfRhdz3ROjIeTHE6WllfX7YXA+6gxFT7FyAdy2AEvHA4BcuIGKVvifq7V3gCQ4Gu0F5xLjdmQEmI73wikSh2RjrdPLMSUBMbAn72EaP5s0qCCsYdrUUyN68dS6SAYwxxYWU9Axx+uK3wJZ72q6MUarW1gGissDQWIsSsO5sRzfnCiDD2RgpkcbGiXFBdmTKRTD4FAkjLg7+9Wj9gY6mPq82CRzYHO6DTp9th73/YWaHf3qQbbcf2cKezzJD0OGnawdnoUC/wOwe/xDrAuiaKbHmJKfVQjb28vNQ7yrEhDNs9mEEmfMgjN+xv4eVbqUEhi27eiPe+7VUBiPfry8b/ffxeZuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After splitting a large folio, it is necessary to remap the resulting
anonymous folios.

The current implementation determines the end of the remapping process
by counting the number of pages that have been processed.

Since the final folio in the sequence, end_folio, is already known and
tracked, this commit refactors the remapping loop to leverage end_folio
as the termination marker.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 553bfa961fce..afc7b2f91e99 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3414,20 +3414,14 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
 {
-	int i = 0;
-
 	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
 	if (!folio_test_anon(folio))
 		return;
-	for (;;) {
+	do {
 		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
-		i += folio_nr_pages(folio);
-		if (i >= nr)
-			break;
-		folio = folio_next(folio);
-	}
+	} while ((folio = folio_next(folio)) != end_folio);
 }
 
 static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
@@ -4066,7 +4060,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 
-	remap_page(folio, 1 << old_order, remap_flags);
+	remap_page(folio, end_folio, remap_flags);
 
 	/*
 	 * Unlock all after-split folios except the one containing
-- 
2.34.1


