Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1824CA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 13:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACC1E6B0095; Sat, 10 Oct 2026 09:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7CA36B0096; Sat, 10 Oct 2026 09:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944436B0098; Sat, 10 Oct 2026 09:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1FD6B0095
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:38:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0531712089E
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 13:38:06 +0000 (UTC)
X-FDA: 85306820214.13.F7830B4
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id C0504140004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 13:38:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="jr3UVi/G";
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791639485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UPtlzfN0S1oL1fXH4tml8et8bDzwWRFyvuUgyoI3xEE=;
	b=h/JwC1LjtJWptHrv+BOanLYf8anGZBy3mUTqjsQdXi97v3XYFjp6PkaPiJhix9v47dXgga
	+VeEAiLVJ+GkM2aZTzNvJyGfEu0FdR7alFalvCREKGA/ibjZHI+HEHQSN/BSiyT0u7FZ+/
	xHQZY1/QJVSt9pH+L8AMEeqwl+1is0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791639485;
	b=5aNA8aCI+Kz3wUuEx0zavq9pCNC6hr4nOGijq0Nprdu6OvpaBBCYsBsYYOGg4Mv/3PanoM
	v23Rvi3K3FrhqeoWGq5cRxkfWGJ/JWFLKP/CVPB6zkCdTEMHCYrJijVSD7M0qXFMfV31HS
	/PnTCBuH5M76Dx15bgb1ozNec1JauQ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="jr3UVi/G";
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so212276a91.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791639482; x=1792244282; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UPtlzfN0S1oL1fXH4tml8et8bDzwWRFyvuUgyoI3xEE=;
        b=jr3UVi/GAoTLJNDxcsS8GFde/odshVblIqMoab+M9VEiPL828FQED5miN2J2sc+GQi
         tT9Y66OsoLlphJ1/0j6T1veAnpomZewTLbx0JErynZ4IKS8jGhr4WC8Dp9X0n6a61ozj
         TbKWpMeC9F4o6PB9bUHPiI4DVhB6TpTkSZMAiNuK5RKLzwdstSY8Kpwe9RNswQeXQfw2
         pNgIZSBnZK/bP0XG8ldvTYnzf2DlEDgmYkk51qyWSHMFz3R/lAPzzl06ANWnQYrtKGR3
         KNqLPabBiVG2MSxVK/jrlEpmpCrQEbpHQcm2wZFCtIHdkxp+hb2KpVXMuPmzJYBTk+N0
         fIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791639482; x=1792244282;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UPtlzfN0S1oL1fXH4tml8et8bDzwWRFyvuUgyoI3xEE=;
        b=unLA1Jv5CMTRtpB9dGetDWSTxZ0GSvD4u7lIg9xqYlfOA28AwEyVbSNJ1Nr0FEddCD
         niCxXQyJaF6Jo3l+lTO6bLnfI84grAiYhv4dFUnlMm5VFP25XtmJooNwiB3ImFCwC75V
         o5yJQQPwrfWlhP5kjddYNj76aVp52KRXsX9DkjPgO5xWORTeHf7WyNGQZHTKBxf/YDRn
         WXynz77YFFSwKgaj8BCNPLhfvLEfwkU2AFCkiK/7zazc+NeoDiW/bn9O4HCdaJiLYSbN
         PGgOP0DVQJrUJJN/4LgnVxuxcN+Z/hGVAY2N0R6hUTeePUs+SIXSqbUOxZX2qPJ5X62n
         U/WQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDEbR3UegKDpDSpVAR+vZprVaYAJgJ6R5+B1hsbY5eBw3jk2542gzrsRbISsFLmXMY/Ysvb40+oA==@kvack.org
X-Gm-Message-State: AFq9FYL6yVMCzBioQCLKoiGfcvsxJSXb1whh0KWZkbCovKGCDnMS+Mlw
	frYjwQBamX0mcRcIepirYmjyK9OL6EomlViDL//9FOrg9/Gq6VPUIbagmp6fFSis2fA=
X-Gm-Gg: AYBFou3hTpAnDZQdDby1e7vbEZPXRiTtDmo9yT0gr6nRePJYs/+rSajWz0IdXPmAlNe
	pLt8PA8ltETnXiJI0qJT3Pa4ilZsvvfCivNRzw7VKfJ2ddRDhmw4u9hNhQvmNO9jA675TYwqSGF
	3p/KG7Iwut9Cc+7FyiJBnVb2PwjSJsEEkqVpGKi54qvuVzBAkL9UZgFBrQVmyPXGaRvvCIVZU/b
	Gk5SRq1Z+gVL5Y0oE4Lip7kySbe4W5I2j3S5ih76IVUvrMyUUJYWcGEvlKpPpmGcrUVHmK/V21z
	j/v8sRMsX/qpivDNG1vOSNGsJFzfPTIgK9+PNAYxhqDUAzu06kSIVyA82NeplOr/NEKubWPGHWV
	9DyFXUfdq2LhWL7VFABcTTnyuJI6APlVirtPIwFUQRLpQY7e3L/uGj+PIDR4f5tG+LFmCp6foQY
	nBY61YR127CGYcOUhyhTOaiMCTeCbMwZYz3nODZK+1u08G0imAtMvvbwKuWYD7YLAUY3ada+y3i
	uRLtlb6CP+K4fItPDHoqmrrTTXx2aE=
X-Received: by 2002:a17:90b:5346:b0:3ab:1a24:56e3 with SMTP id 98e67ed59e1d1-3ab3ac9dea0mr3733554a91.25.1791639479882;
        Sat, 10 Oct 2026 06:37:59 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36ed053csm8522697a91.4.2026.10.10.06.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 06:37:59 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Dan Williams <djbw@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH] kasan: fix runtime shadow page table synchronization
Date: Sat, 10 Oct 2026 21:37:50 +0800
Message-ID: <20261010133751.46807-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0504140004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: tdak5cwgh4w4z3jjhyus5353u3k5qehu
X-HE-Tag: 1791639484-491956
X-HE-Meta: U2FsdGVkX1/bYPmfiPos03Q6pWOzVbliLNSxqU7eJ32aZgvTifZR8NYneXQJClLGx/i7aJLFRXsYjEpAcMq8Y7YYqqdegDKN7fth+z7MxuK6DTYslSAcFpFT8EjcoZajMBTUIiMudmpWfVTi7cT7/wHJ329fZabzUHtT7qqCyO3wRmEvfvOnimI0x04riXyIJL0lD78ydkNeawpffIeftyWITrP0Vns823uBAXeO4V2namuaVKoOMEDD9zH+vy2uDxvpAEC0ebRvA5Df6vRVyNLdOt5A3K8tWhPFtUrKQYU7wCtG5VI8XpcdgDBNfyf40lBYZaN9wBcZ/HzM6Ot/+BBVU0iBp9pizpTd4DTG6otna+2gxF+qoCEfpZJ6sfvx36hk30TwuBF/HPOY9GFEryphZoGkBMq6JZHL9Xx+ddMDpGVRnslz/lBtI1qj7N68iSLfWag/Q8pOUlnJMNZ6Nk0wh/9ZKgAsdzPuKmy1kjWToYAuSUDqN+nmJV6VGoyoqJZRLvA5mHgNleyCKhMOasRrufyvbCacoXLPEvblvruVWX/I8iAqePzWzpu8UgUcmMQG5NgbHn8py9+2kaypDOMcbeolICoh4crwhePkf8sz4Z9H6CwSdbysw8qfzUyk3T4OzkPBRAnOxsEMjd1CRzfw3Ej54L/6vHfTKDkiNVdAlqQpSTnslaboFSvW9i24jIz0qbnQsAEWpelcbYSCl/twp+PhIFdPYYbd+jxq2GB3KhO3QcE5p69R3ZAI4y8768lju/ykJyjfWkTWPUbXTIyYaDwSUeqQ2O9T/klcr3VhBHK6tQkFPw7fZriaJvDhaBumikf5EoGtBwiqHnJZdSPnusOgkFFCiq7/KaD4S1ujGvpJaRAtLyiy/Ra68rf/7G6jGqj3SXO+3i7MJMysabfavDJ9FTiluJUqXSBX2H6YLtp7XVZOlJIO6dsvaMOWGcWSnZFlqJLNf+pROpv
 0VpV/H7q
 I7JD6pQUlsJwgkHVkeTTRzzjepGmFc3l69XvrZ2W1dVEja3JYbXngkHv1fyR7XlKukOjWuSR45/69ifUAh6jeoEONhSSmLQ/BBXc+6V9C2QV2hYA8cO6yEoksH44S4X+38R6chYj2Q34UmaUgfD6iLEbNKOfLSfne2NaVZ57QF76IoQhkjDSYkz1m+oK6ldk31xiAXbNrcE2HEw/1A1yks+5sgsN/4vhVWWi0R3RpvjRyqkHiN+KFZufCGMEa3gMFDQXxxS2KAwEkEzS+Q30ZQ6NCpGFFWmC17cLl+zc/Ks7PK+8o6Ckb2PkHbWdFQPuqFcxITRILraChljRcfM64HWbCjd2Bz1YGP0g8PU+4NfSaUlNY1n3HvTIGHUQIfphFdRib+6Pk7oxVGy0VjQPJjo81qkUtIGwT5XYu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_populate_early_shadow() is also used after slab becomes available
to install shadow mappings for hot-added memory. When this path
allocates a new P4D or PUD table, p4d_alloc() and pud_alloc() publish it
only in init_mm.

On x86-64, runtime kernel mappings that add a top-level entry must call
arch_sync_kernel_mappings() so existing process page tables can see it.
Without this synchronization, the KASAN shadow mapping can remain
unreachable and fault when the hot-added memory is accessed.

Add p4d_alloc_kernel() and pud_alloc_kernel() to perform the required
synchronization, and use them for runtime KASAN shadow population.

Once copied, a top-level entry remains in other process page tables.
Clearing only init_mm and freeing its target table during teardown would
leave stale pointers behind. Retain these shared levels instead. On x86,
this keeps PUD tables with four-level paging and P4D tables with
five-level paging, while lower-level tables can still be freed.

Fixes: 0207df4fa1a8 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h | 24 ++++++++++++++++++++++++
 mm/kasan/init.c    | 10 ++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5cca90fc1df6..5453d3e42780 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3855,6 +3855,18 @@ static inline p4d_t *p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
 		NULL : p4d_offset(pgd, address);
 }
 
+static inline p4d_t *p4d_alloc_kernel(pgd_t *pgd, unsigned long address)
+{
+	if (unlikely(pgd_none(*pgd))) {
+		if (__p4d_alloc(&init_mm, pgd, address))
+			return NULL;
+		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
+			arch_sync_kernel_mappings(address, address);
+	}
+
+	return p4d_offset(pgd, address);
+}
+
 static inline pud_t *pud_alloc(struct mm_struct *mm, p4d_t *p4d,
 		unsigned long address)
 {
@@ -3862,6 +3874,18 @@ static inline pud_t *pud_alloc(struct mm_struct *mm, p4d_t *p4d,
 		NULL : pud_offset(p4d, address);
 }
 
+static inline pud_t *pud_alloc_kernel(p4d_t *p4d, unsigned long address)
+{
+	if (unlikely(p4d_none(*p4d))) {
+		if (__pud_alloc(&init_mm, p4d, address))
+			return NULL;
+		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
+			arch_sync_kernel_mappings(address, address);
+	}
+
+	return pud_offset(p4d, address);
+}
+
 static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 {
 	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address))?
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index 66a883887987..93a74a1fcdec 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -206,7 +206,7 @@ static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
 			pud_t *p;
 
 			if (slab_is_available()) {
-				p = pud_alloc(&init_mm, p4d, addr);
+				p = pud_alloc_kernel(p4d, addr);
 				if (!p)
 					return -ENOMEM;
 			} else {
@@ -268,7 +268,7 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
 		if (pgd_none(*pgd)) {
 
 			if (slab_is_available()) {
-				if (!p4d_alloc(&init_mm, pgd, addr))
+				if (!p4d_alloc_kernel(pgd, addr))
 					return -ENOMEM;
 			} else {
 				pgd_populate_kernel(addr, pgd,
@@ -322,6 +322,9 @@ static void kasan_free_pud(pud_t *pud_start, p4d_t *p4d)
 			return;
 	}
 
+	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
+		return;
+
 	pud_free(&init_mm, pud_start);
 	p4d_clear(p4d);
 }
@@ -337,6 +340,9 @@ static void kasan_free_p4d(p4d_t *p4d_start, pgd_t *pgd)
 			return;
 	}
 
+	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
+		return;
+
 	p4d_free(&init_mm, p4d_start);
 	pgd_clear(pgd);
 }

base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
-- 
2.54.0


