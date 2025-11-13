Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 064F0CD4F38
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989438E0019; Wed, 12 Nov 2025 20:47:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E798E0014; Wed, 12 Nov 2025 20:47:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603978E0019; Wed, 12 Nov 2025 20:47:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CEB98E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F15A05A618
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:04 +0000 (UTC)
X-FDA: 84103895568.29.F162F03
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0077FA000D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="OA27J/Gx";
	spf=pass (imf15.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XK0WcjEaQwvPVjRkMLc2/R9gHzLJpbaLIGkWXKqwGcI=;
	b=YYzCtWYsEx7tMUA7TAs1tskDWUZzOa3sPWR/IuHuUlA95m4maHXAS5T9GhY0zYs5e3D4xl
	nf2Bf0uhE8+gwyX/TWjUGwv8bSBK5+ZIJejPzAuXShCsYZlc2Gk5Kuj5415365c61T01SD
	qR3I08IKi8oBAQeaE5KE1G04ESbUe+c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="OA27J/Gx";
	spf=pass (imf15.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998423; a=rsa-sha256;
	cv=none;
	b=L5L8g5FZBGZ7zjIp0Egu6HpMStyqaKdIMKmguai/pKGxbK033La3/Mnoi4oMUMotyQbgtt
	0AO8eJNoWoSu6kPYz6Btawlv3qgromYmBQl6UYT66L/YUzUqkgg9I13nmPI4s1Z8Rh2B/U
	wNtD2zuDhIRv8SJSbZx9BdjputDEVlI=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b553412a19bso180693a12.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998422; x=1763603222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XK0WcjEaQwvPVjRkMLc2/R9gHzLJpbaLIGkWXKqwGcI=;
        b=OA27J/GxNgzUT7lU/yzmu4sE2dMpaB64hXKqq517wlz0BVTZKGKbCjEEpxiPPSZ9JH
         vT8mUaCzUHM+unathtdJpAyswVlUDw3WEQheQ2duX8ABZZkwi49HT9qpvZp6Jv90c/SN
         PbBFCBwInBINr4JbroLBG6apLGLukRS/piYMhCtHps8SQgc7Da14KKkpVXhzKS7kmuyz
         Zg6wSjX0HCW4yNx7NZh7L6BV861SYS3zZZQzsLv9Tc8oMTVdYbaJt0csItESoeUCyLi5
         2M1aMhfvHFwV0EmOC12O7jtIdMDKgL6Iyi7d/m4qr7hGhFIOiI3QAp21Z8nz2Twe4EAc
         QDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998422; x=1763603222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XK0WcjEaQwvPVjRkMLc2/R9gHzLJpbaLIGkWXKqwGcI=;
        b=CAgzPlderDzSiwZhx7E7S/Z4MhwhP2KPgjYKpHPlIZy0jjvfV1uBu4zDRup7FhCccj
         HbrtH8Vc+4ueEMIQrJRbjFXUaMmUu8MZln91smduYQ0xoyNwNzhWgSz/v8Ya63mViwTe
         BnNzB/8xL0L27oBV2r5dEpgJO50w85Uapco+BEevzoBWQieGXpzg/kfan/grW2t+9JD6
         HyDS5IN3vk9JfBvcOSUE/cGNzO6ybMTxAyKif+6fk+Mg1Ozcg0yQCvaVLsQwh+AatZ7U
         f94Gs9uHVjXZqdB2NiaU/tdpwc9Qsj18N2siiJZTDL6or1scX6bHwS968ctWxGFdn7HK
         TLNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUu5vA1TknX3uXHxqbCCvq3qyHcFrwsUa0NoBHdOTHg9ldO+16vUAZgweqCMlMhnd1tBUu8k/0fA==@kvack.org
X-Gm-Message-State: AOJu0YyLaFr6cnLvub00tmLgxHWobnkJIS4CYNy7gcP05Uu9jYu4rdj/
	GayjrGK5/gBayA2OtnvkVvJTXKP5u9zyxKGZhGzOuCBRmtsFH9IlpAC+CKcU/0nctzU=
X-Gm-Gg: ASbGncveHwaghSq2UkRsNSr/Zeot5QUEE2T1W5mxWUFznyUfJxv2C4XHH64WVHHRyav
	KOyt1l4rJbyTRSNTz5iQ8w0gcvMtlr2tt1evP9H4scUZkX74YljL7hRoAKi7dW5Hynro6Ze7zDd
	4DJG4BSCgI/yo/dLdaWx/br3DurrGjBDo9SqX3EuOvHNFkw2EWy5swIhEkoFDlZMa4KiZJYabnA
	fuHGi5F9v0C+371qzBGhVL483CS1MfyRNpoKDB1FvwtYn89VHxDhgvJguTXVPYrWMQUbk1EPCMA
	78X+vAcRyuRe0iMuwwQGIE9hBd4x3KMgajwKMNGXJRoy+yuQbcdRmEXYgfWOAfBpts9eP/A0RcZ
	JqPf5fN8PnD8RnsMRO9gC1v9S+EqJ/A9vLEVUbKMxhLv+QpooFqIzD+/pFLfmyqB4Nhph+3DHYA
	EU3fOP1NBTtO2xeP62iz+uzw==
X-Google-Smtp-Source: AGHT+IGdLwQpJ+C02LpNGU1KZK8FopHeRZPwq9hf7+jq0mst5qCQq34alBPH74+bRQy7F+ajxgP+5A==
X-Received: by 2002:a17:902:dac3:b0:27e:ec72:f67 with SMTP id d9443c01a7336-2984ed27ec5mr64198655ad.6.1762998421878;
        Wed, 12 Nov 2025 17:47:01 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:01 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 02/22] mm: replace READ_ONCE() with standard page table accessors
Date: Wed, 12 Nov 2025 17:45:15 -0800
Message-ID: <20251113014656.2605447-3-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0077FA000D
X-Stat-Signature: pywnamszra5u7wnmrxo7ryedxj99gofz
X-Rspam-User: 
X-HE-Tag: 1762998422-610940
X-HE-Meta: U2FsdGVkX1+piaYnaL4RDgrQOeeg7h+1qNncfiRL6myvkIuJIFv78uS0FqcVd2xKptitR9ZGDNn5g+5KBhOYFCbsaHp8t6ApeboRv4n9wg8LAtp5KOThi8+T7ozM3Tz2WEsZYnZKrFNQkHl39JRWOrbhtTfrV1CPli9gb4voeKfoKEsh/eWlbaUIEaruYTHtme+T7KrLWd0mLRtDuuoqdDpaUXy/RGnGBp191B/UDn4LGTzfDRWCtWSAW3sP+1KOS3v3KqXIJWMZSTRH1o4hIlZU9jdgvz4wcwfuLUy2U+1hVocPTrC/OwwZlFAbZgvdjc1oS9Gpa4JEGQHRC9xcqOQcYUokhP7qfXBG6AF2MXPpB3dFtHSJqBEGQWRAvbXu2fKc+xfuT8/DAvx3YPz+R8UlJ52uJWHmXX2csCaQezjBZnoWS2MdNo/kwTK9k3mzTcKyNUfVmaZe1r+QkKov5rQFXOuFBzvSCAtfxo/U7xaxbf5rH49AfE/4NbVBhfzFIadr6ue+JBDl1Ld3fBxTy1YRIzTt/EOXYc1SNdGWnwe1JpipqslQm4DIHDOTvQHoTHFktONCSSwppnb3+L5L0I209NHOxyJzCycA9R0LuVeBJyPz2627mFjm0EW2822Sdj41s2VQnoXvYETcPbJPeXEks8iUeogbk850Lvf9om7vdV163y4tElcQ6XBCQfcFWXGnEzF8/atMAAqdNR+EG0fy1F0KuJpsL5z4wx6Tws6bn/vTsvBwOYSVavOf2yJbEKDtom8kh+tkkiRUAHsaX+A+N6nDFqC4FJ6BK+oYp5kI52dTgmcgySHsoo+CjLpK0tGWATQKD/jovyv7jYSlpsdGc7k5l0XD+xU+AM4xhsuupHFAa4KG1krMlS2u4pG+5sGtasqocnVjHi4h9jtZoLLXhHbJzXTIib7xm2PbBqS1zFXDEzmJI5ISipp376SrcHB4kOYenj0MeK7poo5
 XpThuX2D
 SDX56TxHwfL5n/uSK6vptnt313Cugty2YVG2L2hi1ckiv5XxZD5i4nBx817xzZBCNiVNQMqwHFV2o3TGWYAxTCLIMHD6lS6n+4iUqFB9zMGx+7yFfy8D3yFP0aEjwOcjmM0V3Mv7AOPXEeQ1DQ+Tull4wGdA7MgQjiq8qZGkrIDPLWO+b3H81i97jS3Z9rvuLM9hT8ObDVHsZnCBXvyjQLiGAR85Xze73sZ2NYafs+PEdJ4nU2o8UmsLXEUj3IYTYbWofpbIoaNIrU31S4DtpipCC2i8/zLr/ZkWDxVzL9YqjPSMIwlrJVZlvDoQ8wY5EvjvVfQEXn9YK300jNbpSKSgwCJq5qx3rMm1yMcPJWoHQVptW/t8/wDdwn9gXoURbd/aO0s1J1nefFVOQVBAR3j4l3Tw2MSS/Tyb57SaOG/ss34+dFbcUSABfx3qVO1zEshoRArLZh+cSVUljM3plvTUu/sVMNPi0TRA0BzRDs7b5Kwn40fIt8cM8+J8xOq6+bjm6VdfNByuKWzRgH5QCE9j+jMs2JXg5kj4GyBe/I4a1ffiBbZ3OXT0AB3PnIMXon5HyD5wIItYZBEQd+7zNlGXoqPG22TMxz2zVXvR605mH9zX++PAntw1dnOckYdCq/OX08Ofm6auE6O3XW9aiYyCIT3ueblzScGds
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Anshuman Khandual <anshuman.khandual@arm.com>

Replace all READ_ONCE() with a standard page table accessors i.e
pxdp_get() that defaults into READ_ONCE() in cases where platform does not
override.

Link: https://lkml.kernel.org/r/20251007063100.2396936-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v3:
 - New patch for v3 (cherry-picked from linux-next)

 mm/gup.c            | 10 +++++-----
 mm/hmm.c            |  2 +-
 mm/memory.c         |  4 ++--
 mm/mprotect.c       |  2 +-
 mm/sparse-vmemmap.c |  2 +-
 mm/vmscan.c         |  2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index a8ba5112e4d0..b46112d36f7e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -950,7 +950,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
@@ -975,7 +975,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	p4d_t *p4dp, p4d;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	BUILD_BUG_ON(p4d_leaf(p4d));
 
 	if (!p4d_present(p4d) || p4d_bad(p4d))
@@ -3060,7 +3060,7 @@ static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
 	do {
-		pud_t pud = READ_ONCE(*pudp);
+		pud_t pud = pudp_get(pudp);
 
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
@@ -3086,7 +3086,7 @@ static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 	do {
-		p4d_t p4d = READ_ONCE(*p4dp);
+		p4d_t p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 		if (!p4d_present(p4d))
@@ -3108,7 +3108,7 @@ static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
 
 	pgdp = pgd_offset(current->mm, addr);
 	do {
-		pgd_t pgd = READ_ONCE(*pgdp);
+		pgd_t pgd = pgdp_get(pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
diff --git a/mm/hmm.c b/mm/hmm.c
index 87562914670a..a56081d67ad6 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -491,7 +491,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 	/* Normally we don't want to split the huge page */
 	walk->action = ACTION_CONTINUE;
 
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud)) {
 		spin_unlock(ptl);
 		return hmm_vma_walk_hole(start, end, -1, walk);
diff --git a/mm/memory.c b/mm/memory.c
index b59ae7ce42eb..0c295e2fe8e8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6690,12 +6690,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 		goto out;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
 		goto out;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (pud_none(pud))
 		goto out;
 	if (pud_leaf(pud)) {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 113b48985834..988c366137d5 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -599,7 +599,7 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 			break;
 		}
 
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index dbd8daccade2..37522d6cb398 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -439,7 +439,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(READ_ONCE(*pmd))) {
+		if (pmd_none(pmdp_get(pmd))) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..2239de111fa6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3773,7 +3773,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	pud = pud_offset(p4d, start & P4D_MASK);
 restart:
 	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
-		pud_t val = READ_ONCE(pud[i]);
+		pud_t val = pudp_get(pud + i);
 
 		next = pud_addr_end(addr, end);
 
-- 
2.47.2


