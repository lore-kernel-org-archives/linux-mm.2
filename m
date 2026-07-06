Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C53C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C83A6B00A6; Mon,  6 Jul 2026 04:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779FA6B00A7; Mon,  6 Jul 2026 04:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619FF6B00AA; Mon,  6 Jul 2026 04:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3111E6B00A6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:44:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B00351C7BF1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:13 +0000 (UTC)
X-FDA: 84957714786.18.D076CC0
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3987120002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UpegB8qh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPgjdWe7n++lrje64ynUl06z7HSj5sqZ62BWf0c+AT8=;
	b=rTmN9D6dT+6IL2aYDQ3fbeLyClmMGhbv1E81nFMZUY3iFft3S23W+ZcOOTNm8FPexgFNZC
	Wc/Mr+KVeMyXArzwFTPJsr27G17aXhRhZ21kuoLIzZjweEshrog2qooujEdmUdLtYw6gr+
	6+k6jewOsLlStWn5LPwA2cOSh02phtA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UpegB8qh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327451;
	b=GaCssB26xukcfhz1v2gzR0T96u1flE5Lz5v0mWPVUfnpwWLxm7VfVXlG3JgBj7ABhMCI4D
	36plTteJ/W90KbJ1qhE3Ty9OOW3NtHvhCJrdmdrlDARiTnfE4KPvqSo8WrSTPi9TlxOZ8n
	hfvPfBIFYmJ2KWdG35/h5DQhy2oQda4=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso1967622a91.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783327451; x=1783932251; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPgjdWe7n++lrje64ynUl06z7HSj5sqZ62BWf0c+AT8=;
        b=UpegB8qhQqX/MGC6zFTtNvXKd6CDh4gMHcIn+UhRznm6fKONYbebwy//SvflB8/OGh
         TSdZREplfecen5hCrg4tUT74T4ehAMSXTEXBywUugeWRztv7r3h2u91UH0eDP0F9rJ6t
         eC74wX3YAhOn+VaGaXN2X7yIc6nVdSVmoV+Wxs+G51cGGgkl6eoUml+eMNVEwokzWMhN
         Is4OVrs4ptL1Ofa5ZlFq/oX+NnuTo/HzLVEXLOclG9mL50V6M9VEe72SMGTSvXBIlA09
         zVfJu5IavOFAfbHDADF2uE7o7DidH6oE4hLH8LAk/VYeh3b0mlzUQGEOsaz0lRwwj3Un
         9fJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783327451; x=1783932251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PPgjdWe7n++lrje64ynUl06z7HSj5sqZ62BWf0c+AT8=;
        b=IAcL0g7cvoCwD/iGEs9Nd4ITSLjSpMNROqrc7xF7RHXZvKZq+k7dHHb4rMqf7hRO6A
         rR9v0WdXOPFfaXHR3yoF9hnq5BM7d8WLJXpRLcMYUtw23VkRf/uslsbTHQo0pL+1Mso6
         txDv/arMFWjLmi1U61EEYZRnBYnTly/LO94GOV01Pey4vLU9pRQgxCwt2NuywXDNBcNt
         3sGy5wxqkP0YUuFhbxO6nR8T3gXc8HcXQAaWdRILS9yJdLweYqz1Le2dUTLZA23kgmYL
         IkCxliyp0eyqEgC5VuXUQgdp+Y+af3A57hz7Q4o/hDnNboaYbz8W6V5I8kv4vANCDtks
         og+g==
X-Forwarded-Encrypted: i=1; AHgh+RrkZXMsUUqASx6NPWtBlqrRm5uEzhP/5bvah6GmCSIOpDFnxs8ZtcBFjdGdd5s8biOPUtAp9ZC3+w==@kvack.org
X-Gm-Message-State: AOJu0YwIJTBtrUpjbA2rk0vLrqcldaC7fSVczjPiLWvjGuwjwVqJJM7x
	BX8avOD2715mPP3XzbpuuIm/7qBQ4U7lR+6mPiVqmS4KXIe0ELL9GfWg
X-Gm-Gg: AfdE7cnC7VHLlTuJRIkym9uP9dMbwN5JY41yBSaWVaueoI90nfCb7AWffIuwdM+HRWk
	PeOdo56Zta2jYP9FoqNpwszRom+JS0m231+S0QSZyBRfpvipA7JC/VseIWiJX7896bSjy3nBnSy
	WwH02VpHrkEGnRW+0pYtJxg7C13Ymp4+rbu5U4yxoP3DxWjhF1Lg6LIbylcGx4YhbDYVZ0bR+S9
	SYvxYNZFl0W4W76JGf9by7/fWhI6mkJi1RwxPrQNQ/Uc4uriDRaV6Z/zk/BUJO0uuB8Io5z810i
	aOQd6Of9CZPmFaO0uQKl/kXHb9AoN00FdYsshI7FfyuPEd665mlx0Axu8sDzbbdFVFxeV0mf7HF
	kX7vlpr9mJp718VGHNDLnEVAOF1+HUzK6dbv5PRGsQr6IWOoGD1havTrryG8X/zhdvslrRgQnP1
	AVXMofBg3IMaTUB80ylCVOhslvxmXzPtpjOWk=
X-Received: by 2002:a17:90b:48cf:b0:37f:caeb:69df with SMTP id 98e67ed59e1d1-3829eb213a1mr9254148a91.22.1783327450781;
        Mon, 06 Jul 2026 01:44:10 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812815c10fsm4524635a91.13.2026.07.06.01.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:44:10 -0700 (PDT)
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
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shanghaoqiang@xiaomi.com,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v5 4/6] mm/vmalloc: Extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Mon,  6 Jul 2026 16:42:30 +0800
Message-Id: <20260706084232.177786-5-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706084232.177786-1-jiangwen6@xiaomi.com>
References: <20260706084232.177786-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3987120002
X-Stat-Signature: umpudyds5914bki356kkqi1nhpziqg96
X-HE-Tag: 1783327451-490075
X-HE-Meta: U2FsdGVkX1/j1JHtIe0yfpE9omI6ip8UE0XFGYVDBIxCL0s73boixxg8aHugxUTz7Jj8nOecxbN4QGs0yl4S8/Es2IomXTaZJocMnHI+4gInTFJjgt+5wdJisPLDZgkiThknzBJcvagn9/6zUmkrGeZ/G/8iKWr1xXq0b8o55NHEZRI+2c80BUEH9Gwe/6uBUZzHrjHMGhGxXREWcZhdId7XPyXzJEFwQYOWVbd9ZURxhpzw//G3NLlaKe9XYum8tPNTQeTSauHQBnOV/cCs/sptn/q3BIkuiwn66P4x5qqnaAJijJ366MEa310QMrSC/39Q7rQmewv/WVhVKKGmZsHHnm73mAgADEG1j9qBml/xrB7xo1t3MWrhe9/qHmbM7j9fyp7om035CvfyPQIK94L8ZBv70EMGzF5Jp2pt1xhNTod1Cb6cJ01n5Zv62VsLMDweJ3CW4FNZ4kM7cNuEblkowZWVseC94qYr6uGKxTVfXp1D8vbfrhaay5cyRfL7OUgZpcUwcuPHNd/9+y3zFgYx9Gxa7tNaltTPYhG9vVwsZkzDuqXKdK+SNjkF7qTxX43dD8g+ckrZnk4y96/j84+5PFaGvRTnIUZGFdF0yYRSwFcoZuOahj/H85VaLgfjj7DkLfbwTUH7j1Ep8Kzpt88nD6RtHKriIeIZpPbHoPp+MlHmwS8UiUbo4M/vOu4iZrIZVmIPKv9pyARrWmK73xGxRr8r/L3LPkyMn4KWDCpS9Qzyp0YbQ4bh2MUPmlFO9gCGwfzxrzF2MIs3Cn1VuJTrSeWwEs/FPRNJ53HEp6xTtz/bfoEJEEuHL+sm7oZhRRhQuGOoDJL3WNuc0pWWN/mJfeH3Szu79YukmwhjqISVYjVkioLRJER7+P4t6pBZbwxb4dVTCySXw7O8o8kIrRehEt/zj2Wsn6diBfunnbQUTgKvK+81z5vXa/2K6173GbK53VlBgzh+u4X4PWy
 y0YoS/ix
 VkhG4A+KZ/haEH3M0mq3wPXRuJ1amuCDB9PRgGooENtw4Yp/MvNOyfRvXkN46v5ckavz/WkwgmvapcM73rOmi5h2xmr1UfGGcjf9W5/0GQxoORO7rfeHSU7Jtr+ljr5B5eUWd+EAzEd33PBOrNRvEYDCmCEiTVHf6ZvMg8xcxN+1ZaRC9SvsZAkK4fe1s6pcNvhFY9XzBZEjKkCPO1wzKmzXKWiRaP/QjdQ5c9ihfmbRJv4dy5tdUVIYoXf4eSpFSaKk0hR22G1+XzSWp/M/CVQDmdX6KwFVLFek0Ji8iPS4A4sg9nQ5BDd23PsP84yixZaB+s2JA3Zmb8IWgXtKBW+axkpKWtCyNijEzE/Tvw/gLC/SIiXSQatEQM/oW9zL8KzfgS1ldsIKAt+PPidPS/TawwsX03w7Pm8gxZvQTs9JcPJJ8xCcnnJDoRzYJCHxu2niEkOKyuMQuqSO9PcxciwX+HYz9cYDH7IzKDXYJVPgpTePoCpjZ6Nmcgn3EtUrkQfhCe+iY5rqlNy5Gp64hVbBFz+4hVRsJS56r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
provides a clean interface by taking struct page **pages and mapping them
via direct PTE iteration. This avoids the page table rewalk seen when
using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.

Extend it to support larger page_shift values, and add PMD- and
contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
since it now handles more than just small pages.

For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
iterate over pages one by one via vmap_range_noflush(), which would
otherwise lead to page table rewalk. The code is now unified with the
PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 81 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d7fef85b241c4..d2a4d649af549 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -125,7 +125,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
+	unsigned int steps;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -147,8 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		}
 
 		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
-		pfn += PFN_DOWN(size);
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, pfn += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -540,8 +541,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int steps;
 	int err = 0;
 	pte_t *pte;
 
@@ -572,9 +575,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			break;
 		}
 
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		pfn = page_to_pfn(page);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, *nr += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -584,7 +588,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -594,7 +598,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
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
+			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
+						shift)) {
+				*mask |= PGTBL_PMD_MODIFIED;
+				*nr += 1 << (PMD_SHIFT - PAGE_SHIFT);
+				continue;
+			}
+		}
+
+		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
@@ -602,7 +626,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -612,7 +636,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
 	return 0;
@@ -620,7 +644,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -630,14 +654,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
+		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
 			return -ENOMEM;
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
@@ -652,7 +680,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -675,27 +703,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
-
 	WARN_ON(page_shift < PAGE_SHIFT);
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
-
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
+		page_shift = PAGE_SHIFT;
 
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


