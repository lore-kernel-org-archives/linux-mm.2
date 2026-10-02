Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEF2CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336AF6B0098; Fri,  2 Oct 2026 05:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF0E6B0099; Fri,  2 Oct 2026 05:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F556B009B; Fri,  2 Oct 2026 05:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E11286B0098
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 631D21206BD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:34 +0000 (UTC)
X-FDA: 85277115588.26.41002A1
Received: from mail-pj2-f15.google.com (mail-pj2-f15.google.com [74.125.227.143])
	by imf28.hostedemail.com (Postfix) with ESMTP id 80C8BC0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Q/EqRjMj";
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.143 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChtYARSDq8iagNWO9IImP3K9FjWMJua7ZspoYb+TKU4=;
	b=zfRQUXP0CLyXNwsyKj0KkaT0sfkr2Sc4XwViEauHk2xz9zvL42xd/92OyOPbVMlyiSgrC6
	M8KvIGqEEhILtoIJNP8SMkSP1ZQdxvyTynpX9UV5Tpx3Xq57BNhhRw32vJeZlF9WimE/mU
	7phG7KdUWXMkzKKKX8sfHE72MjPAyA0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932232;
	b=WQALJZGD5qkfCG5nwmFpfbJpqMAvydYSaGs0qqI3F19O435n/EOPIfUoyjFn7mUjLbnIC7
	EaqA4RC9es8J0WxUyttjwtzrZztLXe2aY5owRc8ZaM7OHk2i0TA3xS6GOr1DaY3UOwdh48
	Y7vPoeyKbJmt73Nhl1mEGW8j3IfZGzU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Q/EqRjMj";
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.143 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f15.google.com with SMTP id d9443c01a7336-2d747f01363so46192595ad.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932231; x=1791537031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ChtYARSDq8iagNWO9IImP3K9FjWMJua7ZspoYb+TKU4=;
        b=Q/EqRjMj+k1IR9b4Y2UNg64n96oUDdLZ1f2t8y+a3F9IKZQgjZIMAXsKiojXuZn5VQ
         JLB27Lf1LWvbuCurlN7N9/Erxfgmb1Qc5sW4rOb3GV6MBhD83DCnZm90qdKquoMlqdnr
         BzI5P2SJyc9MDjhkUEoQ0M/C2bPqqWRscgIcz+JHOs286HtXqr8QUKGk8UUaM04eFBLW
         tHEw9IXl+JhM+z0tMZCy2lr2GlVzENHk90f91lAeaBb5ANzNpRypGCAzp/OeEFEAVJbv
         L1YDAkvS2JCtT6eXXDrA4+BG+O+DwjvqFMyIMKiJHxKNtJenivZ1JPqngapULzdRg7/c
         Iawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932231; x=1791537031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ChtYARSDq8iagNWO9IImP3K9FjWMJua7ZspoYb+TKU4=;
        b=UbCR1RDaLOUdqQ4SyU+4+WlLqtRJJHX0BrKnRKM7Y8yxRxNVkrdTMSy940b4VRxv1l
         f3WjVbV2bre4gid27e4wsXOMZs5WggQiCEWQpPmNvIgrgQnBpw2cyM+y4m9myVjqASlN
         wAX5/Byc1oBWcUf4gYBmMb3L67CpIlCgg4xTd2bJv8W8PT0Z5TZW5I6tUFvU6ypcbAJ0
         44vDED7m4y9J2H79hO5Cmz0TGD/y76sy6DHJvRnU0OFWngE221pk5DLznIBH6n+29huO
         D5US/5O1UhmwiEGUEQ7gRYqd8lDq3BA+94KUfXC79UGKl/0uCuWi52A7SqHdvjB6jTyx
         9sZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzxVr+SJeHJusv950d5OjV2vgwJEA39xhSaZw/GEG3G6/CsNKk43LjNX1UMATvoykXlC0gCRgvmFA==@kvack.org
X-Gm-Message-State: AFq9FYKtQTLv/eaLKLLUuzLoWv1QkGjxertqjg/nlfi/bv5T1+vyqzBF
	01JCA76q2JSZK8iOC2QgFhcfNie4SY4aG6dar+fzvJJ1fixjsYvFaX3K
X-Gm-Gg: AYBFou3TlYYAveDF8iWxMG/Cr4SlZ571vwWaJO838z4M5nq1uNlqu9t5VJTbAbH3U6Y
	2Rx8ye7U+ChDBavXLxdKNzVtbQjw4qrTmdg1bLGnpPvJIlQYnp/e9q2CycJpZkhlBMEHitpcHyv
	Fx17he0n3STeNTwezf5pmtZvXQeKo1q5bTU/Powrik825DpmxkXgCpf5w6S7aH341LyU6qCsMP/
	eqWAL68Gr7M6Xe91rgpD2x2u+XXq3kNO7SmeoM2bNX2Tq3qAXc475BXOaSmeDKmhKY/KMsPqdZz
	TjJsWeU2EJXdgHB+KoNYNjm29198e8zetRaBb95WYvbhLQAmTbJj+FSZJbDLj0zK4W46DuigPY0
	E/1zAW+IsHrGDZM1gWd/ORfWNLz6wbtXaGBchJzHOfJKb4Xo2nHRHmAMRlo/fnDHhdESPq5TAoX
	LENxRrHJOw5fu9BU0pNiPkOpS8xr165wgTcdPn1efMM2AnJX19VpkMXVMKegsAKpkTNyJFUAEa1
	W/JsAYN7jDZAixL3Hoh2Q==
X-Received: by 2002:a17:903:1cd:b0:2e2:e6f1:5e10 with SMTP id d9443c01a7336-2e49a10450emr17761045ad.4.1790932231246;
        Fri, 02 Oct 2026 02:10:31 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:30 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
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
	ryan.roberts@arm.com
Subject: [PATCH v10 06/10] mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Fri,  2 Oct 2026 17:09:43 +0800
Message-Id: <20261002090947.869220-7-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: om1zh9sqmx7rbo13cjzedggxeqe3ee3c
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80C8BC0006
X-HE-Tag: 1790932232-573823
X-HE-Meta: U2FsdGVkX199x4vxFeYkHpV4izdJH1wXH8duLuc3WaSoCq7dyqpv6x6saO9h+4KyC7tZP6bsy9hVdt6RYgmJpoWPRYgKNx0Oy8J6y3Z0NrO8j2ZzRNLdXraqVqcNvP/QWJrzS9WHf0RYkdtYofWp+CT2KPyyetY3HZetzkpuc5LKqbQCneEyLHy3Ils0x8EFJvlETNu1JuhJBUhgMnZw3CLcu3DPt5ftJufnk36BrZUMU+VQB59HJkIwF9x6hR9SXey2Y29hjyjjF5oIPqQbTaLoe9a+OAttD2Sk02z7Td0bW+aMfLUu02aXZVc93sus42Fe4SSiqFcSNuFKU2iKxfuerx6xXCni/8iVSjFOdILMzRrC668jHRxjrxnO6yP4BxlXq8tovPvQ45EeMSx4Hlb32o3NVGLB6WipTg0tw1r2WRliPkUXMEs/Hkr04Fd1m3l8e3giOAkNr0x8u8E9FLynWASJMPs+qW/MC/BOdpbBuKs2XORWE+DdElSpbb117oStedV1OOC19aDUT1X3KTS96xBPKXdcjKy8GOp65E5dduCbGQNw9Aev+XoQWDek1n/iK9VrDm0cEQZOFldf7f7UecSdOH9f916ScD3WBdJvmXN4Z1Ys2Xed4KcZV4F1PvUz6pcsmOqGlrUQqDmuIob/7x2V/r4/jQ8c4oeQd3TQOM9WTzXbt+smhg5fg4+yLzW4ooeCyr+WYHkujyEC0ZoHcnQlfnkE5UiqDtka8vXkcStLsZsKJdh3l583xbEmVfkSs4K9LabjiU5P6JcUq2AiJkbM+6xvs5a4z5E0P8/oASn9OEquovLm+Pz404yWGpEqz4vYI0HeHnNSCbvsOESQhgBi4ej0ppbw6pY1eGKZ6xGMpVVyxZ3aGwS7sjiGG70JeZ+1CH0RJF74EVNyoRWgK7uIN81NJDEq9tn1X4Q8oWnDvDbYlpIITnsEYmug9ToAbNV8Akdsi4Iletx
 ChnwNbVG
 WQzCqK9L7vq7/4UMKE3/Rqx3XHvBe5XDqx3ZMxyqdRngirBytMpolz48f4q1UHAx1c7ZlsodPJctZ3jOmvNCwa+LgdAQT6GIBDm8UVjAbyV1W+RpehTjEmJ5t6kZk6GBfBeDZs5NXBMGTUxOhe0QNgFs04YGzRvU8tR/sWgzmx7CaOie9kBx6Uu9lsiceasYcc3iXgOJPRo+vYm8pHvyRWKx9y+OF1H0Lfxsc88+7OlkPFRZczHI1ulx3t5Yy/FJEWFRZsy48Z7uT7JB0EnyvjpIZen1iFLLRo0qv9u9W7etT6moTi1H6FTNiyA0tVgRhcUCmAcurQhxMkZl+K/CIFNnQaewxzJLcHTFPSjq9W6mTiRjJym6xH2tL0ySPYxPCgXFrEqpgsEkkUWA7ByL7b3ZeZxOKGEMveevqxHuCGLfq+Wk7GbJ9a59Xj/ZBnozcfVDBC2/rU3vTh0zWlMqfpZB6XW6sYeaZ3TL8JLVZocHTQ9hve/nOLg/yU9yPUm2MGgUd+Zlci9Yxd4tsVz+QTKh1G/GweDM4W3e5A4Xno2SMfVMSDDAch412ZUsdBWuLQLpj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the common PTE mapping logic from vmap_pte_range() into a
shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
PTE mappings in a single function, preparing for the next patch which
will extend vmap_pages_pte_range() to also use this helper.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fb757d95bde25..72ec1b48a76de 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -92,6 +92,29 @@ struct vfree_deferred {
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
@@ -100,6 +123,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	u64 pfn;
 	struct page *page;
 	unsigned long size;
+	unsigned int nr_pages;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -120,15 +144,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
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
+		nr_pages = PFN_DOWN(size);
+	} while (pte += nr_pages, pfn += nr_pages, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
-- 
2.34.1


