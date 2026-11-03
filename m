Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FBA606A801
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G3Arb80R
Received: by kanga.kvack.org (Postfix)
	id 005D36B05C2; Tue,  3 Nov 2026 05:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8FC6B05C3; Tue,  3 Nov 2026 05:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE81C6B05C4; Tue,  3 Nov 2026 05:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B85266B05C2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:18:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A776140351
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:02 +0000 (UTC)
X-FDA: 85393407204.30.3D3A52B
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6A697120006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=G3Arb80R;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ze3zkZKDchYqmhLj/EpeAe13TGzwVFVPgW/gvJcl0x0=;
	b=3dSBF0PQNoX73QbW+q81i8RVyqbbQKirF0PCwRKkRIF4g+bz0q6Pt82UaJVRlJdrgsAs5F
	pSBmWgzVJmcLmhrGQWhvd9PL2K9pk72fG0h/oqSBKafSwIVtvKCb3O/zrgiP/jyp+Aqtb9
	ZSI0clrOi2FB/wu/TLibCxxlUdgrBq4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=G3Arb80R;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701080;
	b=vcoSYIdQMS2Bz0i8Igs9Zcqe4uFtlOqqxp7vMGq7gfmT7R603C6Zy/YXFp4qySVx43jT/a
	sAWz7qAv1ozMIZD5bxrjNAhOfHJDSoziKXLjTPEB+mrsT0pNlhqjGWSDfMRRJQCCjELmbD
	VJ2r0EVgEIlvpMnIYsFc5EZ1944lyeI=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-35829219da8so613150eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701079; x=1794305879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ze3zkZKDchYqmhLj/EpeAe13TGzwVFVPgW/gvJcl0x0=;
        b=G3Arb80RcOEpxcOzr4LOMpkmVTLNveznDHevWGMaAF+6MNT9xNAIzYEkT5Ka/Y8YDJ
         +bPPJNw+EXPFhnqyI15I/64Zk2E4UFVi5sQgUzwF2MgbzIV1xDo3XResAyciCmdRSVde
         5nRktLFWImDkkImlJP4AF08bboOc9qs3uR+0AxxQEHy0057goA0HqTz3MyPE0V3S5flZ
         UZFDaiBxC5f7cgGRmEQmKN6SZPF9L4roDCKwLIP/Zp7NLXMUGcPQ59SaF7kSHGs4tDEP
         87IAV7SKbMhxi8rzNGl53OhVzeV9jTRyZFCDdXPNYGef/77tgKkxSGw63MaAUFDiWmat
         DUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701079; x=1794305879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ze3zkZKDchYqmhLj/EpeAe13TGzwVFVPgW/gvJcl0x0=;
        b=xOzDB3C30xjEV4dSHUJSgKhbFOnWAb1ljf+V4An1fjZ57jiZOT90iDmP+1HAMxxyzx
         02/emvPgfbtPXSEfSPpWNekpbXkdqB+rzk7yZOBVM7yOX5Zg81w45pomEN8f5OojxWsS
         eTGf1vnVpl4o1pGdUdlBlT3qgT9pgx/zRPB9GCKfO992IgOgecKZrwZopCnFHmnCWzzr
         D5exC4tZTzOrwOIcSv4FUqUEHxCFePIFthYcD4LVlGRIjkjEKI/MjxnIwqmbC1kXDKKR
         KMZnKtWDZMPOD13nh+bUVEuAtf6hEmy9suwNPmegJNOudLm4Njvo+QdrMgPLbe4sNR8x
         8rkw==
X-Forwarded-Encrypted: i=1; AKwUvBxaC3QtbhVGpc3gVt/k6xDRXOx52pkJyKRQgvvXwMD6nrNGveX42QYOtwGCFIolY16hOHV/r0Xwzg==@kvack.org
X-Gm-Message-State: APuU4Z9HHrIzIUGSMtZN7B372O+y6MrT6H3+OqPPFCwctldwPOL1YCBa
	CBSnK1aJ1sCtNb7EsugFRQOnhtZr/GY3J76izuIb7GtTEiWxdelAKoHM
X-Gm-Gg: AYBFou3qmXLSL2GogpK3c5iUZCSSM/v+df8mIt0ylb3QZfgYYAJ24PZbTe9GunD0RGI
	c19BFooMFg3iclsSyJxCnSgy012KNAIKJ3WXzMLuZm4mAQ2zAku9s4bjSbLiqcbL3XFMtcJ6sjz
	Mrnv6MOLsESc9qggLzKnVUQcDjl8+XCtBvclNfVtzVavOEMY961NLySggc0IlDZdgu40GGKc0Sd
	NsTylT4J3HFz4p0N8vVzgbNkZKYBBlzJGnP3oRGlwVyk19PEsnm5tgOpyqKpJGqHkT3G9r43RYC
	sJCwYGMluwOECwlXa69AZ4YaFLkUy+D5Yx/HKWu4FYjEaBo8wBA3CFmHWvraLe9mPeU+3YboJ9+
	nPm2B7fk2ysZufGhhsxPNwiCdj65qy8A7Vp8069L9F+gqF+UouHIEJV69rcQBcsvYZDxf71Djw3
	CnUXev0iRqwiB7F9O2GOXRavhGt81R/+cnBKsA67q5baOS81kILOjf3s9dBCKq+IPZmW0Glh3iE
	L49Y2a1bkRGHWIY73+OGVKwxXQDUe0vUpAB9oNWvWnmOaa3yrID2nWtSoj1wCBjMwYVlc8mROE3
	Nr6u9P3kLU19yqLJKUG34YhzHZh+CA==
X-Received: by 2002:a05:693c:41ce:20b0:359:27e6:b684 with SMTP id 5a478bee46e88-36a2fd486a2mr23067415eec.3.1793701078964;
        Tue, 03 Nov 2026 02:17:58 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:17:58 -0800 (PST)
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
Subject: [PATCH v11 07/10] mm/vmalloc: extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Tue,  3 Nov 2026 18:16:55 +0800
Message-Id: <20261103101658.766905-8-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5br1xg8rr1jto8fcf15nw7ap3ufm8ho3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6A697120006
X-HE-Tag: 1793701080-559598
X-HE-Meta: U2FsdGVkX196HYRwupYRrd4Ni4yIld+6WxX2JnK4uWV3RXKNsltY0PNM/saeo3HI8whfIgDcotUFz8IlHQi33lQPRItl2i1BejEG/CZeZzHH34VG/dW4ml50FGm3jmQXKpHmyto0w7V3Jc4vybyGDLPYDd1KT6ig1It8T0w3MF9SaFYHcu4YQZ5a6Qut2vmCDd8y9FCLrfALg3jCEaG7bF7tWoKZs4Fzh4Mw/xP51+VLBNWZ+pDPUw+F9ZbWyZjIiRgz57Iz2nrviWtrV0LaqMDsMXAzDg7W4WOERDRqJPBoKqENXQeVm1HARtV+8T5DZFqLDHCkF7OW3vOF89glM0EybBQsKA09BAREXuQ2xCV9lyvoz9J0/WwmIM7zBFKur8Bxf1WEuTXnHh/Ccmcv7MaqHuQ8XHidkZYpAnV2k5ksTJ8oGoGfZ47RdglCpGguiDxeKXTiJgn+hbqfLhnzrFU9eOVQ8w/TPAkAb3gOU22/ofPatMEnaqvTe05txcEutCbVtsIJxv4La8JN7wo1cpQAq8xMTyAsoAV48b1k8S7gx6PR2dHvAxIxvhRPMBDH2Q1dh/5gs/rFtz8irdmnLYjvd6LmFUsiZWgLGhe37ZBoRb77+a6mzgWwUMpbfNN9NtxoZsTubBrMqecOEVcOJWFTuAxL3VoiBPZ2B5aMeGnTlf+fnHvbLl3GN6gO91VOPyk9mjLWJPniFVEbBY7vJ0V0WoPp1Qg5ZG0f0jb6OU/ONx67vcCyGjaylQ81oKvCwMBe0U6Hz1vgs8+8XW5afL2mk0VKD2ygm4vQ9anXT7gaH+nJ1Ese7gSjtjQWyb1WiJN9rbmIv5aXSzS2jnWoPc+smqJtTU6GEe+/S11d8WkCn5jx0GlXXKC3e9K55hajfhFkDqu00ZC2B5WvhUNWOfbQEoYzhEsSw0INLQLZ83zSwYBe93bpT/VgxwJffFHCgbCPoYPB5gEYn2MdRe4
 kyOfNCFR
 RikNzgSMxmfQ/qSenwBUYOx17RlMVkvnM6haaCsIvqXI+t/ga52wx0wNzIVxaU5Qw9yrubXUJ/YU7wxCgiwbCfoP+glUctUUcOPBPSm8B5uQi99c3pMdqRD9jm9wZqNnulOo503rdd9W7O07DnOrpq0gCHnKYed4WDeLDCam92ii5DlT7Tktv+3EsV4MeTotS9zIRUQ/rNLQw603u1vgfO22Fc/tG6fm5J+kaX6Ko8o2k6N9ChumxtXF6lrutAIhB2vCr2G2s1JKGWkHcu8Va9Rhdg4aqcNzotaSU6oG4XrcOuOynw6Pj+itwcCXjfKUB/ov31KJdqZg9B93tyythHbbm8nCXCHuarbxH1wLWZhWU44oBO9UiNT025XqeNwpZvt7sSFDZplGwQA7syTc+KRowDWmM8/eZJjcrABm2sZ2c7m2lts0PuVOAYh/w3iuCSaWIhSy/fu9bQxBwiUPC2aZowzLNgixVEZcFRRHMhNJ4KiYSboH0UXLCohX/yAblbEx8xGBI7hrVSkRc+bNqdirxsxQgYo67zDgrCY1wabnvc4xiGhHCsDQjZT3AqIEGreLATh1r7xQu7aB1LpqRsXaTKXCUJ1mFu9nBfjlmpDrecdBVUawLi+5RgX09emejzQrsN+J5T/9rWHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
provides a clean interface by taking struct page **pages and mapping them
via direct PTE iteration. This avoids the page table rewalk seen when
using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.

Extend it to support larger page_shift values, and add PMD- and
contiguous-PTE mappings as well.

Rename it to vmap_pages_range_noflush_walk() since it now handles
more than just small pages.

For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
iterate over pages one by one via vmap_range_noflush(), which would
otherwise lead to page table rewalk. The code is now unified with the
PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 84 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 34 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e3ea9581e68d..61f2b6fbbcd9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -558,8 +558,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int nr_pages;
 	int err = 0;
 	pte_t *pte;
 
@@ -590,9 +592,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			break;
 		}
 
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		pfn = page_to_pfn(page);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
+		nr_pages = PFN_DOWN(size);
+	} while (pte += nr_pages, *nr += nr_pages, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -602,60 +605,88 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+
+		if (shift >= PMD_SHIFT) {
+			struct page *page = pages[*nr];
+			phys_addr_t phys_addr;
+
+			if (WARN_ON(!page))
+				return -ENOMEM;
+			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
+				return -EINVAL;
+
+			phys_addr = page_to_phys(page);
+
+			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot, shift)) {
+				*mask |= PGTBL_PMD_MODIFIED;
+				*nr += 1U << (PMD_SHIFT - PAGE_SHIFT);
+				continue;
+			}
+		}
+		err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
+	int err;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
+	int err;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (p4d++, addr = next, addr != end);
 	return 0;
 }
 
-static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages)
+/*
+ * It can take an array of pages which are not all contiguous, but it
+ * may have contiguous chunks, as hinted by @shift.
+ */
+static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int shift)
 {
 	unsigned long start = addr;
 	pgd_t *pgd;
@@ -670,7 +701,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -693,28 +724,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
-
 	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
 		return -EINVAL;
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
+		page_shift = PAGE_SHIFT;
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
-
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
-					page_to_phys(pages[i]), prot,
-					page_shift);
-		if (err)
-			return err;
-
-		addr += 1UL << page_shift;
-	}
-
-	return 0;
+	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-- 
2.34.1


