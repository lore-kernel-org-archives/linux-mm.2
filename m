Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7063DCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C616B0092; Thu, 14 May 2026 05:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04456B0093; Thu, 14 May 2026 05:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41596B0095; Thu, 14 May 2026 05:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8DFE6B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:41:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80060140500
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:56 +0000 (UTC)
X-FDA: 84765533832.07.D20D817
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9BD2740005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q4Qz+rSR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F795Xv5J46ljVi2+6iHBT2O82gjybUH4psWzRnSB2TA=;
	b=5sMm8PmONrToNuGXU5tp/otp0ZG4zLfKNFXwN/61LCrc2r7MpDzwWH9HonUIiTJuAv3HWf
	ebQS5lpDMkm+Kp+NFBkmQJc/5BekuKxPIOE64ilTMuQ9X4xSIuBYkVrHczex0LjBPLATuy
	G8B4Z1OTPVU5IFpsdUkyvZ9T6j0bAxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751714; a=rsa-sha256;
	cv=none;
	b=mEf6TRTPXNRurEvT5tXSIajnEYfZOvDYUE73oJ37gRTilpNjB3Tc3lWXCE979rITEgtFsD
	shFw3neL3wJzE1TUaTTbmhn+z3o9bGdXPIyBW0Rsem58HRtf2TkTe13XLWM5kT59snCUfm
	yAnhfDHjUR3y8Tla6+sYs+p2SA1tmkA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q4Qz+rSR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82fbdd60b64so5797638b3a.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751713; x=1779356513; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F795Xv5J46ljVi2+6iHBT2O82gjybUH4psWzRnSB2TA=;
        b=q4Qz+rSRYcoLgzXn5d5VIhvied08k2kpkS5IkUIEvbrIdY5xw6BSai+tjCeQS5cmbb
         DcjApPXwtcrrHR4ejDfWH0YUqq02EkIlz+RyG6ntDNSPyn+R0QyU7rXNfwUTvGuE2lVj
         XkELc+6hd1RETYvLIJqg2lFzkbG4CzKTdmXHVW/lvk6aUgDdHwbNjtKavAu2dfqrhphp
         67GkcmgNbH3Sv2azgcGG+C4llru0shYLLE83GG9JrOFWlrqCraFGzI5OyUoJplQQWajh
         tZj0JJ+WibdmdeRrFxLV7/qH5nruCYgihlQ8ay4BleSzGPPYG0OYY97IkuudgRijP9Ck
         4vDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751713; x=1779356513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F795Xv5J46ljVi2+6iHBT2O82gjybUH4psWzRnSB2TA=;
        b=WqFY2W/F3yB3zNtoHqQJEqPLQV94HF2/4N5fqEu+P1sXXFs+6FaLsZaq89XMWkO8k/
         VtPiqZU4yeYJH9lrZ0Pgi/PQJsT3AHGb+IsbIPnOCufWe3j6yiD055KiVBamGycc4Px5
         XA+Wpc/kwsBcR2apoOuiSf1OvSRMYzoOHeUV1iWP2v4GW7V/i8ZNcRBsX6G9nDFIuoOZ
         cBfvPMeEHYLJXDKcTprLertHqonS97TkMVcgV4OsPaU70GH56vq3Odv3o4ezYGqPH8i9
         4RkYVG5pBX1Df3xRDr3+Y0HE6P9hHyyWPEBbAQ8UZeP0fYWkGrUuuJQkAzl5QEURtyOK
         SxXw==
X-Gm-Message-State: AOJu0YzNVebYuoq2BtuCyfEVLJwcDaeoqfFcAZvLmlHPvfsejtnVTu7+
	2wjdoriEv8VmWVaoYHkDqlT+DzEkbCnfdEIM2uC4i4l9sMNsghs3b3k1jWZVyRiCS6E=
X-Gm-Gg: Acq92OEAIuH8x5Mi1XJESAzpwaAzkKhWgcWDMAQaThzX++h8UbWmQHqHab1WzhygsaX
	JVKoxG0hoBfiLwKU4G7w3Y3G2LBOLcDoPoyWPhRcf2aC5XiB1XNaBCnQto/jeEBFHfbwSaKuDbL
	TrWZe99zayN7rDOpcwHljAmfeoNDA3GMs48VKy9HtltaQYGVlDUYCssxMSAf5IIlOuzYDg/pCgd
	iV/Q4LuxHMZ739YghgGeYFTCTNPuBvdTUld70RkoN/cl3SK5TiixmqcKG8VJVzE4YrtUuf/W9M3
	+NhZWuG+GBnltmeeMTDiXPeLwhLK9y38jBDCl8yXZu+RVglsZk62Ndvck+6Sw0hNsZMyCS09wNk
	ca2LyzefTKNviFxP8bIlm0cmLI5ZqLkWZOiV89SCbyurvkZcmlOVjxxukhnAuZ11j0Rj+r9Jekq
	3iNaoyyqeB1+bO+11JQmAdFXrOdsxj1bulUV+2KH8ZRHgjlvIvppDel7Zk
X-Received: by 2002:a05:6a20:2589:b0:39b:d937:8010 with SMTP id adf61e73a8af0-3af83289f88mr8096707637.45.1778751712910;
        Thu, 14 May 2026 02:41:52 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm2351244a12.22.2026.05.14.02.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:41:52 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 3/7] mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Thu, 14 May 2026 17:41:04 +0800
Message-Id: <20260514094108.2016201-4-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9BD2740005
X-Stat-Signature: 4ye7bd4djzch31gcu5pg6sq76z5qtm9d
X-Rspam-User: 
X-HE-Tag: 1778751714-996301
X-HE-Meta: U2FsdGVkX1/ZLtLzW9RicAF6PBQXt0Q0DVUJZDSl10IqG3FtLG3AFW0pPQihc3GvTLjZSrEuDgfVBVmkP9AieyrpiXRjAIjp3GOYLaQXVdELu70EUtHpSMi5Rjq4Qk+WmKUizzmZAmMrxvdhp8LF/vFPjqA1J6MGVEdbUp58KfniBIepsTAgaQb2btO2X1+nCvSu7rkjeG2LLmbDZZKTlMhvWt3V4qJ13SiKUwSLvJUUEQZieDhAyF/is8pstoFGLDxpoAHb8SPyQSkum4DoK7J+qDZlwKJdTzzeRmVvYj6nj1mEXu3BzMIT9Wi9DLKV4vJgOWgA+4S4Ghb9eT5i5AP67DmLe/KyTS/L0WqF3Aurm+6LclnTmS3+Qws4UzlmvWwdgY6Es4FjuzhJ83V0qjfpigg0L1iNVHEyBbUsVrNJaj3GFCCwOFjB/aqhZFcgUgVMvioUFH7SFvxRa97HsiN4V0X63k72YTM135Fb0iYyV+I/Xo2ojA0+fw7LY2D5kscXU5FLpiBHLqLCNlyViWVVDEwkgj4rgFl968FltHL+gd8gKMWZY9aCdoTG3xBVpI/9RBq7d+tbdgcoewuNgHgANUV2FLDKU8ckqY2yGyw/RvBpAeKmsMzaAAofiqV9HnFGMmlce0vg254qq1PzDrzYdfSL3rOczY2YjEHVDQnYjj9089g3f8wQE5MqxpLtiWofW/T/uEmO6SA2+bAlxEatsJnby1yUPnx0c/zYg1YCo3jxQdVHIv98EIX5f/cdxwyYyGGCpoM2skw4XeWg3kvuQmTJ7YEzR3EBr8m25iAFt/nMndiBJ9vQN0+JZMANIbgHEAQW58oJh9uTTRcMNsBDL4AgAMzSW9/xmdtPgcE2+hS2TuuG3M9eErHsD4CYZsp3m5DtfIXfw563y0yPqBy91YG4Ri1/FiDd5y5yfXMRwb48Jrv6idCFftOcPDJHgdCz+UlfOh0Wj1Y8crc
 ACHanLUP
 v/uhUMHYSlwHUWrG1J9Gp9wj5SOpqPADUVIAziE/CMmhKybK99JcTdUuNRPdhy97yqySsr0zHD+0yOj49vsoC3+hXH4KjEmv2/8wqIez4BfV0GhEZP1EqfnhzwVM8Gq5yflUwcHHfU6zIe5rAEIcDOuYsUglQcxhYlr7kqDD/PEs/LhyK8D35BmhoaNFOwCQ+XJhUn2GJbzb5Ut/t3UiHhXEQ86316o9a8ugCNWroyuefQaFyEmp78vGr5o63YbZV2DxrxoR+1/Q8q2QRh/AyxrMKHH6110cSdOydnnRAtnaHJHUY82gOGQeuEJuEcpSC0nFIIoFqTadGOmBLmRTY3hGRMEX1x9MD0ExyHjr7Nv8TtoKR9V08dJs5tyCSnHmXjHKatnwJeV4TAbfrWvvlgyni3H17jX55zrpBTbTQCdsTVOfxHH6h25GKN6F4rnnAh0wf6cIKbsoyl+LTeM3KjBzoWXuAJI/o4UgVeTyFkyEGjOS3kvaIfwIU0/ACkBzlt0KhUERal5ZXjndQTSid0kTUPtCHaH5UnGhvRn3wyy40GWx7Wk0pdMP/gO6m3Ib8g8/1cnWP7XQ+tRDhGgYlgpQKcBU6ISu35Cy0
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

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3e9e5156f..9bfd0aa34 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -91,6 +91,35 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Set PTE mappings for the given PFN. Try CONT_PTE mappings first when
+ * supported, otherwise fall back to PAGE_SIZE mappings.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	if (max_page_shift > PAGE_SHIFT) {
+		unsigned long size;
+
+		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+		if (size != PAGE_SIZE) {
+			pte_t entry = pfn_pte(pfn, prot);
+
+			entry = arch_make_huge_pte(entry, ilog2(size), 0);
+			set_huge_pte_at(&init_mm, addr, pte, entry, size);
+			return size;
+		}
+	}
+#endif
+	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -98,7 +127,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
+	unsigned int steps;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -119,20 +149,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
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


