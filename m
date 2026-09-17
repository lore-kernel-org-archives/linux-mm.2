Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1537BC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E4E6B00A1; Thu, 17 Sep 2026 01:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076E36B00A2; Thu, 17 Sep 2026 01:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8576B00A3; Thu, 17 Sep 2026 01:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDE8F6B00A1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F931A0249
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:30 +0000 (UTC)
X-FDA: 85222129020.27.7AED864
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf16.hostedemail.com (Postfix) with ESMTP id 451FA180009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GfQQulJB;
	spf=pass (imf16.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623028;
	b=QZtbDGa8j/Fel4CzH/2MxyQvKgKca9NeXdvZwAcjy/ubxdKNCy1Av9AxAWh2r+u1fkgLvD
	MILG6liP1EWoIQxg529wOeC6sh+sP24KsrzgHo4JpFKAu33osG7kThmNRbr4t+XSMUJeq7
	QqzFJaJB2UxdXSSZgIc7wPQk0NWq+Xo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GfQQulJB;
	spf=pass (imf16.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8iXtJFaILHaNQYB7TRtsKAUY5yHxckNGkamGztIiuQ=;
	b=dPxcxWCrM2mYitm9jeX6Nih0IEURkgXrrZ6IJuGkRagJ/0+5yr8jWxHnsC2FKzupU8vhQj
	mcjY70Ve2h0ygm65ArJGGoJvPmO4ikw9odwWWJ4vsMbChzpxWD1owwMDE4H06YRn0v24tY
	FXlxhiCxqgZTF0FbaggpORDY4n3jUTM=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db1ca069c8so4070765ad.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789623027; x=1790227827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G8iXtJFaILHaNQYB7TRtsKAUY5yHxckNGkamGztIiuQ=;
        b=GfQQulJB1ub9NWIWIkegk9ZolhfWq/rQ7P0IRqfj71q7/dxy+ffJURrvMILxSb4rJy
         rd9EYqCjQozNWPN+zVn0rWMN48nTGIvV/WYt4ABhv4rhfx3JY4wFrsdNLZ7B4ROH1Jm7
         8AxqRhoh9v5nVz1eOer5dQ0gdksDt5/Rt1EIfYatT2yyuqZIYUAzDThQBTYUBu58VknQ
         hhjfz4vByA2+JWaegnebNVi6iVm8s0nSAqflfP72sjjP0/z6cS+DnzpoFhJa2Ft4mlKw
         4o7NJlPx1O0FxL1zvMge/uL/6IPY5Zxv+M6sG1wGP1ihG7YGdzfgc8RBOl5ROfm+zp77
         UgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789623027; x=1790227827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G8iXtJFaILHaNQYB7TRtsKAUY5yHxckNGkamGztIiuQ=;
        b=ZpLjRBBUTTAcZRZEGuuukybKfadHIMBRq9J5p421wSsVf+1up92HzGcK0hQtMZTDXd
         U0KxqXjqxR9jjfqVjcCAVcG+H6zPpCFIymdcaTBchoJiuHy1ou6LfvnDlmHe1eOJCMZ+
         E1kBMG/u6SL06UqhL+2b+PGYpFpEKlZKZXlaebyhBtebCjoO/52DN73gfeoGIhy5AAvg
         8V6UjY6WV5tlFfxNt3Koo3RN14pHEnVdzjLctlb1hX69FogFtl4VhKkKurXQJvdoNInu
         E0T7JFNlio/UQirs7OD2TriFA/bYjqVfw9ZgkBFZxMlXz2xTxnq+bqOiKaR/nWN1MNzb
         oHyg==
X-Forwarded-Encrypted: i=1; AKwUvBzR34br9fi4sMk9b10HNIA0JNeN4DtaRN9pmWOSV10aq0Q8xGcqKNIDAVpNJlxwKWMc/CLocN3c0Q==@kvack.org
X-Gm-Message-State: AFuF++l1rjORMJxX7AIhryiU3WPOv2D6I9AtoI2dkoOwtzxT4bpF2qOZ
	MlhCLESs1/XQzag5TClzqPggu75woXoR7FQx9Bq6p7L3VNSQg1TimMZr
X-Gm-Gg: AYBFou1LXXxjMtxN154c6bGC9zcMrI0Y4Y+RfPhKw2gyFy9MqcdqXZUIyYHfPimZ5xo
	NtuJ3u4xfjoqRoQbZpqX26YrQwFyZbnATHcWxR848jpuhqcJm+fPxgovYAX2Whtoj4xYOzUXfkr
	x+MeNjWq4UaNTcTn49sdyRiLU8z7V3nI/bkxsYd0HtItZFp78Vxes414kOumE/guSiHF59a5wGa
	Nt8Kg7zdTbayhoebTOfezsCOREnywjHqVjA5CqT7RpPCxv5xuqs6ZXNnT4A01x3zWTqzlg092WY
	KZKQB0fpsViT9C/550ZbwvEim6BPTSWyc835vxc2pF08+E3FcJUqrbRYzBQZzlbkMfaTp8fana5
	cD0pO7Zi4pnCp4u/f+s8IS+iQtUnQWjYOjK7Fm3p+yDMD6n8rHglLF13Vo1JX1fIDPszxPFPDRc
	p97v0dNXpd8Unw8dsEtD1wcI8aHHgXa2jZDQA/uHgbJ6vGl6c3r1B8ibiDb4ORjyeEaJutsGe2N
	9nMcraR6KRfqzGq91uSeVvkog8=
X-Received: by 2002:a17:90b:4e88:b0:398:cb56:e92 with SMTP id 98e67ed59e1d1-39e1e30ba45mr13210240a91.11.1789623025225;
        Wed, 16 Sep 2026 22:30:25 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:30:24 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v8 06/10] mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Thu, 17 Sep 2026 13:29:29 +0800
Message-Id: <20260917052933.188679-7-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 451FA180009
X-Stat-Signature: spxee6ekmgq56j6tdoem9uy4m36rb585
X-Rspam-User: 
X-HE-Tag: 1789623028-425323
X-HE-Meta: U2FsdGVkX18C0/7TftegQRJgGXNyVEDR0k4yefaZhA/FN/V7zPKJ64KV2rxffglzwOy3o4gjT9yO1U8GgkffIDfq+vErlzyzPecXrkF1Oh3qBMfCYFFP5dFLliQ8gOzO9uksXc6KzQNssMGj8zHrg/+g7GrQE0AUvkDAB/4HxBLSoj4xMP3dXt9ghyzC4L0VYMKVeeR2ThB2BP23keh9m+OCymIF4gwZ41W7mHjo63EZBTgqAMvNumLsTW4PQ60+XTZh6IXMfkfDpQ2m0q/d5leRWB/5r19cWI/OYhzwVpjjWqc8KOOl/Bv9BPmuowYTpiz2ITzMpNmzagozHSnrM9oCt9F1HCX/XdPE2saDc3PE0Q33PvLTFaDd94f+g3TMoNqX9hua4pFbIJpfI6xPi6Wl9e5tDf2QUBRcOja9gA6UDEOb/lPYhdhp1s2YhpFow5GzpKz2JaA5clPQh3jID7eB/Ckt43nbIvl5R92rMGygNrYeg4ww+AsHwq/4oR7m6SvJdbdQFiJ32WdIMspqSpwjir7PI5TdfF4Red9byGwRF9mez5SsqSI2sx7HG0buywcYsr7NzZGOGhpDFgqrEkkiybuheVZCtn6QLa7ADDhczyjucD/oz36Ie0V3EUmnWh/3aEH9qO0j1fk1oGX5pebidzJaivsRUC3E3hGscdUvuKeWr+kFs4fmdjvYfggrs4qYAeIQCIHqCvO1K405l59NPaQqdveNc2kE5JV7FQTDrVlihN77a9foV+6oM90N+rnXamj4Gwj4n3ZBJDxkg+Gmj9/fmy4A3WwkXQg3kxOauT1qLHoNfzp+oaLsbXt9Fbnkyo2Gf+wEKNYkF3S7haF9mQSDqvz7y33Tv+JvZqEvw9Mec2qqBZ9hQqn9S5DxF7qo2XesvHvW2RR44zVzoO2QY+LH4NOzJVjZaMhBhYnFuYsaYA07c3Fu/vk4oBevbAB2eD7AxuHeGrBq9t9
 aU9EoKqv
 Fw8oPqQDNpinoTM+OHoVU+RO7qRktlyPdg3XyvZmRaHDqHzuq+x7UdJoZI/ONWYUyWS+8nbEC5HMRpE9ldUJQgxg1vXN+JqK+VVgfqYLwbvEI5Oz84pUjUcU50nylmJ5xKrCzoGe/bci+9dWF60xutkkTeZKnNsqeN7U/e4PHTN7bDnhRoHkbrtyBXAjdGI+kdvJMmGHwaR77PE/vNpCiM1v+4ClW3HYb0WIeLWc/1kuQiFFpywehvWex0rAlHNRRfot+ABtOuDtWTDXqhLOoExdkIQNnTdl28W1TIgBZRtEboJ+LjCHDsJAuctCUKZUOeGsmkuLWI1nGRLiBACFQn+u+b+g3UY/lr4/R5NGhVL3pdnsHCiJ4OyKwx+orQGbb/fgpD49kZ3cuCqi6jW2PxCWMJ0Oe3/dzHEvr16i84BHyBOucRnVDNElY5vi/n3oZK/ZLHJR5+6ZMQhcDLKElSCfnEGDxX7UP3fKoTeOpbIAw33F69chM5mCIsRaJVZGkIB6Zrd5xnrIzXrInXhPcG7SrnS2uIAm3J0bvozF5gJ3JYjb5VU87v/culQIaUuVAg8C6HlVEZmkwtlaDd8Gop+6CnUtCCJKoEJolLG4HLGMuTIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wen Jiang <jiangwen6@xiaomi.com>

Extract the common PTE mapping logic from vmap_pte_range() into a
shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
PTE mappings in a single function, preparing for the next patch which
will extend vmap_pages_pte_range() to also use this helper.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 025b3a848d564..a0508bdb7d36f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -90,6 +90,29 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Try contiguous mappings at the PTE level for arches which support them, and if
+ * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+	unsigned long size;
+
+	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+	if (size != PAGE_SIZE) {
+		pte_set_huge(ptep, addr, PFN_PHYS(pfn), prot, size);
+		return size;
+	}
+
+	set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -98,6 +121,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	u64 pfn;
 	struct page *page;
 	unsigned long size;
+	unsigned int steps;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -118,15 +142,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, pfn += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
-- 
2.34.1


