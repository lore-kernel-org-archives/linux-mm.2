Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A48606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NCEDbPcj
Received: by kanga.kvack.org (Postfix)
	id 329336B05BB; Sat,  7 Nov 2026 08:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D27C6B05BC; Sat,  7 Nov 2026 08:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2D56B05BD; Sat,  7 Nov 2026 08:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECF3E6B05BB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:50:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B60D12031E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:50 +0000 (UTC)
X-FDA: 85408458660.15.14EE115
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A1F220002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NCEDbPcj;
	spf=pass (imf13.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059448;
	b=N8HgtBE74a9BKoAbxmcXsUPLcce7dRoBd5MTjU/MJ+5Bh/n57UnusWBhPsLXNCSnK8NlNm
	DH9mqB1UfZgWEY/ZuV0R8mKx2qP9ZvvgWB1dXr5CNZu6PRPRtud6wNtukUgC2lXoNQBTio
	fE0LJOQMgT+V7nGupbtDHeug/ssIUj0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NCEDbPcj;
	spf=pass (imf13.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=felPx3uV3OszLiAgjC6qYiNB56VtKrw17gOMSvN5MlY=;
	b=EDIQnbgXuGeQmHwIVdpwXoHYKu1nbkYtxp7F1sZkEEp8FDtAznL4Zyaf0VxjpHRtoAfEv/
	9J8A7QVuTbnpJrH7ioNyLUW6jO4ZfWORgUt+wsYgdlBkEMFFej1OH9oUjmBPbfKL/UfYhs
	B8QeScveoUJFzo/GsHyO2Q88XdKtRuE=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3712b6d9843so125005eec.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059447; x=1794664247; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=felPx3uV3OszLiAgjC6qYiNB56VtKrw17gOMSvN5MlY=;
        b=NCEDbPcj+u74Pa6ULEWx3vtpegsuUWzbIN4+e2K/PkU5ASrKRTT8Deo7YGiqlLmE5b
         WmnN7f4H9hg0cYAH+1fZvHd3GjmX9pz6jStO4xBsKZKl835OuBgtFpSSWg6Cstc+Eb8x
         V3ISYrNaZunHLgabS/zXgjxfxtOeu2zH6nDM456XAw+1sOYrcvmO85GF/0t2l5/+O7Yr
         3dre0LX4yi67UHEMuU14dJ4+e8aUm6vz2J0tscPDWXXgsMnSbxR9b5keNqDbvseopomK
         nYp1hnLpvdiZGIlDQkrmVc+4AmH3FLExkWVTxwhehK3MfoR4UuLcrn79u4VfaekY3siz
         yKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059447; x=1794664247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=felPx3uV3OszLiAgjC6qYiNB56VtKrw17gOMSvN5MlY=;
        b=byzIy2T8ab3G7Dikh3+g2r2FyKwfrpx4AeXYpbTKcS9Z6iLcXx8PF+ntmOUCaf0NYw
         917vg7V68LgQVEtI8axoUBxEdNe+Bir5Gbf4GXjNQuV8wr7GQjgCI+ZFmJXi87TuvIDe
         o3vREcYzZ2YTxTRyImbtw7d9KLP0CuRaeswolzwzPe3vk7aK9e1iaEAUxHK+iWefe7/a
         C/5UCEc7YbfyzFW4cbfPcS24X/MO5kUnqF6njaOxgs1i8ah9Cn4gRALkRfPgNuXIgoJB
         aQXyZeuzv5ldnmG8AechSK4VyDuppNp0FiOL9zHaP6TU9qIa923Wyfa0bqcOFKZKnSTz
         zDfg==
X-Forwarded-Encrypted: i=1; AL+hErGsViJCAT3Cce+qu58rCCPqD3Qrn0kem6V26AulZqE2fVn1yvevoIkzvBP08TQXv9CHv8cZ8RPQtw==@kvack.org
X-Gm-Message-State: APuU4Z/EDmcPYw1P8hARoWLfwmT5bPy2YP+7lw2gnrj3oXTg3xLyXjyj
	ss6Kdrpov7Cfr0vQlYqEO5Ys1tLHK8WOjYWkIUIIoZSkdG/NK3ofXvi6
X-Gm-Gg: AYBFou2FTBICGuJ0JeFFtE8KRG3nRJNOEyZ/KWCittmHcOd+r3vC6ymbUkmWdUVKTQN
	OYkitpw+7L7IvU6IeMqTLr5tK6JhbonK8PPAqqW0f7fcEvyYDG0algEalqfIeL58M0He57RiOhv
	mAaFExL3b4ZZx4M0W4kDFSUQn12KHKQpRSLWvomQ8rWptIVQBpXtukW9MawkLYSexOBqe8uQq6C
	xRBKj712wvKTyBNVXyoWzlh3M15y/5LNuEeAFxdtkrlH5clatyVJSaRl0SLdI9GH7FB4oG+6NSz
	Q64PorZbHeql+QYL5PIWmPoRbgxJOoH+DJdf34fzEatHsZj33Ae8tZu7t6NAd/ASFofMenageeQ
	5V0sIgC89Nl1zswXXt1zmZzCh/rnitI0iWKha1G+RybQh3xW1ZuRHQwL/7cAntWwyAqiDUIYoDc
	Gs4xU9kexAmzvmROAdxh6HdUNbr0eP3GF3Ft/o5iro0bXJ3AhcrO/QDE07Evt4CynAlTbBQOoXj
	5nsUzpUhnrIKnqNb5GD7d/buSdCLDfn8z9wZfDsIPLcFJ4Ax4rrz4TKrZQKsSL7badNM64rFNuV
	94c8ZRVZviWeg2Ms7nBSIMv13lqOz958ILPyl7ijEjZsnvCBrSThPyQA3g==
X-Received: by 2002:a05:693c:88cd:20b0:370:1333:5e84 with SMTP id 5a478bee46e88-37013335ee3mr5769315eec.11.1794059447224;
        Sat, 07 Nov 2026 05:50:47 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:46 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 07/10] mm/vmalloc: extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Sat,  7 Nov 2026 21:49:50 +0800
Message-Id: <20261107134953.748622-8-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A1F220002
X-Stat-Signature: sf1rodaudy14m81q4thn719z8k759n9s
X-Rspam-User: 
X-HE-Tag: 1794059448-836218
X-HE-Meta: U2FsdGVkX1+ZCmTgMzn1lvu3rNw9bv/sCrNbBq0qLgpEqSRXil/dRLc3+pQFTOMQQbD8eycsO8k9vHUt7VXdwnT4J1Wct8ULrYeH9NE+CjEdJNqaZGYwp/cUFTyTpZUXiDhP4K6aP7AEkns2oEwSvNXqkOnrl+2oH4lDOirSJcy9a+fqeSq7RYmeq94fMxQHzKtUTzErATYRGxdW6SjQa7we+hEBA1nlQUTf8z48GJ2OrDphc9zzZ+8WyQW9FJ5YkSYhDlMBzcOh/2SR7meIcNblXzf2zHkdu2ic7qa/COp71YUlCF/dnt07HsB3aXaPdbKbvPxxyO1ie5iaeLUg6n82FEzq18mqE6AFsNW/+jvA//UKEcBi17NumTlXgr1llbR7bvi1QNYBaaWBglzxxaITMYJ/4QPv6PIEv55NXGopdGlOtooF1XzT0IwWf1uPUTctADxA3HbI8fVbfjXj57BmpkYhNfvsJXe45Ne1QGLq7d4m0UVfUrlWNzvK8HTYdssbIQSyhr+NUybVcGknI/F/++/2Aocvk7WOezFB7AZJWPuY1bhMNSrhLPaYBxv3BXrufHZ38x618PRgCQxooRzCWiGlCyfVcNOq8MhnlzULogbPpbx9ME5ZTLNjxXmJTl4Gr4bwCUiI6v43d2OZkBBH+78XSej+FH1Iex9O6GM9WF9pcd5OthdHNi7YuDvZY2lXma4nIx7xF4ycnU3BUqV7raV6NiNtD24f2HuAE0slyVYMHe//J4rR6WYA1LBVucgHdi0q2vrzYqvymH9ml+oPhogRvfC6hQ8xmMGmO0KxKQ5dHp/ukaSrnz2zW6QOP5/hO8YAN3WjYfh6XLpZ22IyX+bqFZq+7+vkWJkPcnx50DlzAPYfqxqlXsTttWLR0hBSKhW+Yfwjndp5gxOHFRNDosp5pxuNU4fKZwnLh3ENN3NjM1ItW+kUPaPyTDYI+UStJd4OhEOlqO4VQfg
 +xKf3QGy
 Jw8ryIwilNyUWbWFXxmnwYUmbq+JgQNDydDjgDL+usE4Y12Tr0S+/7CQfWmccRiAp/Pax78fCkYP/zpCj7BcQAEST1/nP16Rt6BbMjcVywU0z5djU6aEqS2iJzfoQqKswxlIFpp/J0pi3IMfw5VzGajMz0jSGFmXXFpVHpszQHWbznNgQD4zVFJWYokt729ajFu8zUdlKQXZzDK9sQg6AVMiZ0oa/geo25f695wUSpjkEMXNUWoigS13AfX+2R52YMivHmPEz4qBP0YUjt+fz/l2GUIe+Y1sidS6aImQL78PO3+8xHTjqexB9NnZJluu8MouYzf86EArUWatveNuz9po4i3a1Jgy6b71E7zySOs5PLfFejyCQCrz+htuWVQajtPnW9AnEOZl46st+lVsKaXuKXIqQyB975gz3+KG4KJWvYyasYtu8vR/49jCxsuXpOKyD2FlcFcLh32ni44ysxSSWNgNqXbeRPXqdrXHek2/vxsGbZaOwLzpWegLoiE97gz8Kfz9uYqTXCgOz4gRcONtjyZJ68eaLM6PiqiXwQIyx49+CIKghTuZ5TYE5KMxKfO7WhqO9h1Fekn0ZjFkzgwgHlG+0MfEvGZhb9IPgVnf3/9YVPOdF/bpRA6ZAUqwebGRzTHAo3LLs22I=
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

The pages array may hold several physically discontiguous chunks that
are mapped with the same @shift. If the virtual range is not aligned to
the chunk size, a PMD boundary can split a chunk, and the walk resumes
in the next PMD in the middle of it. arch_vmap_pte_range_map_size()
only checks CONT_PTE_SIZE alignment there and could map past the end of
the chunk, so clamp each PTE-level mapping to the remainder of the
current chunk.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 88 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 34 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e3ea9581e68d0..f2dd9bef4de0f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -558,8 +558,11 @@ void vunmap_range(unsigned long addr, unsigned long end)
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	const unsigned long chunk_pages = 1UL << (shift - PAGE_SHIFT);
+	unsigned long pfn, size, chunk_end;
+	unsigned int nr_pages;
 	int err = 0;
 	pte_t *pte;
 
@@ -590,9 +593,13 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			break;
 		}
 
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		pfn = page_to_pfn(page);
+
+		/* A PMD boundary may split a chunk; never map past its end. */
+		chunk_end = addr + ((ALIGN(pfn + 1, chunk_pages) - pfn) << PAGE_SHIFT);
+		size = vmap_set_ptes(pte, addr, min(end, chunk_end), pfn, prot, shift);
+		nr_pages = PFN_DOWN(size);
+	} while (pte += nr_pages, *nr += nr_pages, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -602,60 +609,88 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 
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
@@ -670,7 +705,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -693,28 +728,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
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


