Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51EB9C44510
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215616B00A9; Wed, 15 Jul 2026 09:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBF96B00A1; Wed, 15 Jul 2026 09:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CC46B00AC; Wed, 15 Jul 2026 09:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA1046B00A9
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:27:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D825D1C0063
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:42 +0000 (UTC)
X-FDA: 84990889284.02.DEC296F
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 02E7540007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hw8d4Ibp;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784117321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJXfNsewMtLeFnLJ7bmWocyu9UQcX6Ca0Z8isc9W34U=;
	b=Zs/vbuBjVCrVmIx48W5T+KOkUzA82b9Uun8sOaOir2q8z95AXr2cNRWEqLqh9B8H2HghPs
	uB7mitEIK8AwSBNIjBdO80IKUmdwhz8T0cHNjWg646Hi7Bb8Tz8sLQraZc9R/izYJLF4bO
	mfQstQUIvAPHPmNqVDnpWp/NgMk3K/k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hw8d4Ibp;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784117321;
	b=EmmOY8YIBlERh8ikCQ51zbtcqJYq/5QftNIFXb01oGNlECU8zOlioxXHJ4Ua+hTW629GpH
	44xRVFFROMaYOQ/QxgQ7B0kA9gN5d8/Ze5cbrM2Auwd9+zyMZiZCszYHlNWKc5CkSxe06z
	pbpt40KNt8Q2XW3o/PZuHK1Sbg/CedU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cab973140bso62230565ad.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784117320; x=1784722120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gJXfNsewMtLeFnLJ7bmWocyu9UQcX6Ca0Z8isc9W34U=;
        b=Hw8d4Ibpbq7Sj6L3HbkY7XHxnUSVmboPu9F734b287BYGMDjnrZpYe+1tZIb/O6ess
         3gtjr+HP+2fm44Uayd8RSslwZWMXXqO74LnAtuuLsvkQ+Rp5ljnVIhf2OLyyL7uL4w00
         crcZDjAhjCv1wSMq5eQzDnjOrUInA3GfqL7A/Ror9IftFWdePWBwEPLN8bQAA9hiCbuL
         oktoWtPrByatwFbIoBFBL2KRjryEWuPi4LGnSvnpPEh2+Zsk/924GPEFmg74H8WYCbeX
         M+W4Ud1cJiE/HGLCnse8CMM2rmOM8eWquhvJxeIdg8pLwBW0nDcHsXfYKi1ri8p+wT0X
         E37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117320; x=1784722120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gJXfNsewMtLeFnLJ7bmWocyu9UQcX6Ca0Z8isc9W34U=;
        b=XsXDvFnouwYpslaOfXFJPm5Y/zatH5W6b01nybfSsXVUzEYGeV4yiJnRGYom3PF+lJ
         vNYlfprdwksmRUO++5eu2LCrztgFAo8Pid0Db1GCL4XTW9dkbtgrhm6VikXalzAOhs/c
         Zn6DW34ZL2kOM+lkQtutRa6ev6QawwIzZnb65FSTg000nF9NnB4JtHJ2ecnthIAzlDjy
         spOZj44trl8IIo6uIj6viXn3KzANazr5F+7U4cA4Rufd2tueuBa+OCL+ZkTRQ4pcpRPk
         uWYwC9amRpN6uOUBhOKUweb869CZpk+ArX61wpS9R/k2jXi31SgX1DHYDDvtd6slvb55
         +9iQ==
X-Forwarded-Encrypted: i=1; AHgh+RoKuX8iR7VQGBVYV4sWGbDDWOz757RQWCWwpaXXGy7XNlAhEQ0v2V9Z/W7kcc8j8x+7bN+n1jJXBQ==@kvack.org
X-Gm-Message-State: AOJu0YxFLQpdELmzoEDbPYsxjuDraHfiYNdCmkKZ9e2z92lvUP/s2WfV
	ifv6FUUYakumKIS3qRmxNRFXB4I8usRQ/mXFpcBYSV21AUpP6LX+CLwR
X-Gm-Gg: AfdE7ckByvQTPDQcQQKpoCivBhxMWpStrznEIIKLqu5P+A2d7btuDQmqrGaw42JZTDx
	uwUE9TLNmvSSdF8AiilvoMAeJWvHKGkNSgJiv0g/kKExVQj2epKnSY/uf4B5DXzbgxEjbxB+SzF
	DW3uxuTTtRd4655a9LmCB6x4Ov1viD70VtpCz8AViuWIspSTsY1XRMaqIvMypgQswy9A8TeGCwe
	eMKFZypEec3qDfVlHI1WHiimyNvbpyGBiUwt4O1EgIGh8iciU+tCPaHK4vtRAsijtPN8inXKXb6
	3ccdB2mmcPNf5i5iYrgryK4VzgrfwW+q6PKJyy7oAygQ5MyDq56tvXfxEvzSeHQ/eQBCUbf4hQ/
	mv1OcXP7b4FOB+Zhe+XlRFLV0Rvn+C+7h9M8V64/wShVDQevgo2+uhp3PHB4ZKYhIDIwRLmEpo+
	AlyFaYTncnDg7uq1d/aedxyIMRj5Xd4tkOyIdgWd2sM+1DJw==
X-Received: by 2002:a17:903:468e:b0:2ca:d7a0:1312 with SMTP id d9443c01a7336-2cf03cef70emr23475045ad.25.1784117319865;
        Wed, 15 Jul 2026 05:08:39 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf105bc642sm1216325ad.63.2026.07.15.05.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:08:39 -0700 (PDT)
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
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v7 3/7] mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Wed, 15 Jul 2026 20:08:09 +0800
Message-Id: <20260715120813.3609949-4-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 02E7540007
X-Stat-Signature: fnqyoxhu6ynsf6i3qnqiw8trr1djg5sp
X-HE-Tag: 1784117320-575177
X-HE-Meta: U2FsdGVkX18WO0vN1bgxYtTJKGgTqFZlYQsv6eGLrcfkduRXiOcd31spreZKGED2uUPsf0I7ufZbjlGPUamYpeGQg5sk+6ysNrERe92w+4Mh+4psxPTSBOicAbPxmkCKteauaDQRdx3Nk3UetomFNj8yTzXRqS7gajTtbjia/wINJA5e0sWg1wu68//eUNP8i7pngCt3xe4QlFxbvRV8b+Ty//DSd3T/XLqHgZnGBTBIWKyiiOYFX5eeAXrCipGd1W8nF1ChyxS+GwDMTje5F16NifOrJQtV40d1TUkfMzBeaXC7hYY36QLuQtH1WQIQILQYrSBW4Cvwgz/EPIKlIEXbpcdqAyq9sHVrnfJul9OW6yY4DPYoBbOU85x1EQUgJNrxZRdNVqEV8kHznI6p9CjPRbWVKLZPvchzf665H1CzssbjVub3zlGzYWawPnQY7GR3dWzsCP96BJjS0jlBILzcW/XZp2M5suwL6QWCZMr+xHkorMUbryA+sXtjkShsCgiQcA8+qu+4T9okPKZpYe5bLdR6HrTKszPHPcPs0h9wsdBjbVIYOEkEAwcHbwbOEwPvhRCmCiNrktj5CTPUeDrTKp8W17UNebmvXQJxPJtpvGE1iBqgnjMJJcSM6CLPP4tF+R9/weWPo7tPCDFv6VSXpT9Dkju8G/iKgmvE789BRXTgwBr6TIj7fFBApAE6aHfZKOlMLy49JpGXCNuqd7F3uQp1aT7ZkwTM9z5Pj0CahUyCWDCZRQy8+gP36rLyVpWBfulTKlSSC1tfZrLURXrxQ254F70Cj6cbwyrEgcYjm7pnNDatEmtvmeClQq+wR1XmoP28lkNMMrq+Fp+jpNTx3zR7LngzZSsCwF0BMw967GSlutlxO0yY45E9SFV/7rNGXATgTWOVPd+t0dn4FrUxjpVgkfeHc1ClNvhDre5EmlC+QaFBdJLsefKzTf4oZhkv+sFmpE4mur6OieK
 WyXOVMaN
 sq0sfFP49ki8PLXGA0p9+Rqg6QG4O+obQ66eNzT8TxImwTut36l9zTNV8pqbUDOC5YuHODhHgT/g218b/GXjIDnCLjDdSSdu4i6nPtQWEGugYEYKomW3HMR/1wH6LF932h0/tWXe08uMustmZ1qJWTLQ82x7DqfjPSwOeXCeWgQ8b43f4OZNaS3qRkVl3SlC8tNAUC0UCQX/0RBuu6nAXJQyURWA9OZrbz9y3aTdcY0RT+N9oOxgu08xMjfDGfk3nlO5KEvEPljkV1KZCJ+Lrp5yeVXeDLRQii0jzLHIoaoQeSjV9qBAOF1Tjb/3WHRLrL5Q1fEr7bUKeh1uLR0A7VoqfwmRtnhKIZ72PPKK0MSA+WTI0VNs0wp/+oHzVkRItV1uvTOCrbgGts3TmntNXws0HRm4pkPBzr16T+wtG9Cl+UL0qBN5CTYBMUt5j/5QbJegjT0mOtyQHyoH1AFKxNuF9kQRjt8zyVsgs47/j9eXfvtiVNlDh9/5UhlLV9hCmQax+p/eL0ai9n52bFngkXeZQrtMD+yuIXA87T3iJ6S3u+aYYXykd99fmWYHuT4wd/cgc0pogalu04Kk=
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

The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(),
so callers no longer need to handle the conditional compilation.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2c2f74a07f396..b9b29f7857bb2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -91,6 +91,33 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);

 /*** Page table manipulation functions ***/
+
+/*
+ * Try contiguous mappings at the PTE level for arches which support them, and if
+ * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	unsigned long size;
+
+	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+	if (size != PAGE_SIZE) {
+		pte_t entry = pfn_pte(pfn, prot);
+
+		entry = arch_make_huge_pte(entry, ilog2(size), 0);
+		set_huge_pte_at(&init_mm, addr, pte, entry, size);
+		return size;
+	}
+#endif
+	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -98,7 +125,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
+	unsigned int steps;

 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -119,20 +147,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}

-#ifdef CONFIG_HUGETLB_PAGE
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-#endif
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


