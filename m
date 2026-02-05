Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F8AEA7950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 01:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C206B0096; Wed,  4 Feb 2026 20:35:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59B86B0098; Wed,  4 Feb 2026 20:35:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F906B0099; Wed,  4 Feb 2026 20:35:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 709066B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:35:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A4B7588B3
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:54 +0000 (UTC)
X-FDA: 84408686628.25.B5A03FC
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4470820003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I7409D5K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770255352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JS1rPHn8kZyPcvTQXgyDxncq77srAM3QsnsXxPBvNxs=;
	b=UlY0dLNPJE2fUx+TcZCu9ETr5Tc1xhDg6fOQ2QPP67DXKacVejC0j3GSqLzKoMouHLZwqY
	ycTrr7AYd/eglR7lyjJP9G9/5GB49T3rh2jIc8wFXtlfC5IrWCHc8DdgoOym8Yrq1uA+s2
	wKyTkilhoAcXe8swUnut+7oFoB7pCBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770255352; a=rsa-sha256;
	cv=none;
	b=3xxe43CHOCwOm9DQ0j9BVZdJLntdkXXDIawTNzo0OnnXKnt1jj6ubpEMxxMCjNKh4BJ6ng
	Hxt7CdBKWaN3d7SsShivjG02oStbs92dIO9YkuSlr4+HLfX8lHUdYoF6/9kq+eLOzGg/Q+
	HOrVaT5eWKnbOvG2Amw04jHIZArErE0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I7409D5K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-126ea4b77adso455310c88.1
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 17:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770255351; x=1770860151; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JS1rPHn8kZyPcvTQXgyDxncq77srAM3QsnsXxPBvNxs=;
        b=I7409D5KYCHFucGSu5nXUDUN9P+EIQBz/hLo0IB9EaG0L4MfFfZEuibbQELlxMLglb
         pzFr63W+NFW5uoibegj61eWza07MS6ZK9rTjCVKhGegYAoIbdgPnuvYcmxDMB0/BXaOW
         AndX083sT1PskkEJ2GKYw99Af8fdyAVaJ+CMr5HIIwiOujCp0lkNG9o4Hil/MVQlemih
         bOek8KMeucwOO9bUmkDWgThpnAMS0Xe1VRFwVoFfdfugxmOgo8I25V6KtvlyHJl9IcTI
         Aa6zkZaXgECILPUZnt81mQkQY+KI5fou+5+nOm1Lqsym2+5fXaoJ1vxQvBNsLYc9ZDFg
         eE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770255351; x=1770860151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JS1rPHn8kZyPcvTQXgyDxncq77srAM3QsnsXxPBvNxs=;
        b=gwXMCV3QVavVy+iY6BUNHwn5ozQ9ufxFhzSWnVPNYjeVrRfUZpAaXZnYWSbFAqaZIy
         YWxJOi5F06y8QPqgb9W9Gl5Mq0fej/iZQUN5BNFG06DpGESXesAO+stjpOsRwqh/Tsv3
         zDpU447JuxWJW0IUUWIZkDSdOhmuYjuBJtHqoH3uizoifrXZQnCoVW/pJeHRb16HpSfH
         vQJqJzbA4u7ZulOFaLf7WEWicCLl7ZdCD3Lqcy1ApwDdz1zoavrJXnIOYHEgJT/tVMvb
         RonhVsF+2u8WdLYpmkufYmzlIfluAnwZp2h02E6GkA9yabxwZmjxoed+vfIZDmh+f8DB
         8lgg==
X-Forwarded-Encrypted: i=1; AJvYcCV9Fpc90MBG5E9oz1KHOWut0VasTTo3Dhbrdip5iNHmN1e3JEEH3N5kruANnL/z13pm5e9TYKORvQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8T3KtcCZ3Gclxt6krDJBoLrOsaDrLw0RZQJgAbrku4kROhQg5
	Ue1DH3RqlPPTRHKew7ezgpJaFBH5YLbg5pqILADBuCb0QeLH+T13bFrw
X-Gm-Gg: AZuq6aI2z+isMEqqUCg3RRBf4i3WmfU5+qwIunuyVAVSAu0VoLcNGNZLy+RhAfS4AFI
	5s6kePAf+PwilzkLiBhmtGgYXeK7Ny5KB/12yVxf64689dtgt74kxVV7Ev13t2bbPoJvZDj2kXv
	piVq1yXpL2WuiTm2RyU3MQ6mgmUsGZBf/scbRFvQ7NKlHius4ANBQi+WMtb+xTmBtKPz/uVSZVc
	VJG9KJoSq98zumyS4MMj0wNEC/cxaemWQJZa1BK8loosP2/ArO3s8aA+LyFsf6R9LRiI4IImSdX
	PNzgrIQwjRJTXlK3X4ZfULmiBQ4+dy7SlSkU64ZuYOdoJsoXIsug20u5zn+cpyeZnt4YXIg65DU
	FXVb/2CueT11WlRxqU9c7iZm4BTmwmSIm7i2krF3NmNOy2G5uPDxG+cMTE1vb2Fu5GF+DAY6OXS
	gyPKIU5mtRnrOCOgxVInP/cjmxhIxqHkkJdU0kyYJL24H3M45xNdYX7Q==
X-Received: by 2002:a05:7022:207:b0:124:adfd:623d with SMTP id a92af1059eb24-126f47c3357mr2146966c88.31.1770255350963;
        Wed, 04 Feb 2026 17:35:50 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-126f4e0f98asm3424982c88.5.2026.02.04.17.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 17:35:50 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v4 3/4] x86/mm/pat: Convert pmd code to use ptdescs
Date: Wed,  4 Feb 2026 17:35:26 -0800
Message-ID: <20260205013527.322157-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205013527.322157-1-vishal.moola@gmail.com>
References: <20260205013527.322157-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4470820003
X-Stat-Signature: cyd9fmtkqoeyb78ooi4w1638prch57qm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770255352-404902
X-HE-Meta: U2FsdGVkX19Z2zSkOX5yY8gk41T4EGXVXjOFMu8ybYAdIM2aHgps3CCYoitDGF8+HstCkQYbzWpOt83f+Tz6OQo40S9pKlwbwOSWIN8p0PXMSBF73WeJEiqD23DQrDY8v4nykIj6+BxkLRvMcgtaygFAvnEHlKhtaf+1UKXE8eAsXoCkAOm9tS77d+bl9JD0Xzz5tqbeOZ/P44ZD6Nu1AFzr0Y65W/yLMbPsUtQqOJCH/GBVo9MukZuz3USHt3UdNOawaXb11kj6P42Tt8NsQzpAdFjQdwdLI5P9+GBfY5jd0EYj0r3QenbwXgig0F1UzEyj6yQo19Tf56jD/bSj+HhjPXv0lZsroWjGR/kohVeRKJBCwa2eveBHSySZcaFLUMxMrChX9Zwql/41AswsPGA4pdOhQmvYhDf25SnliuhvX4i1VwxRhV7NVYQukdOYt9xF+q6IxlPG7OcO/vI4LYW12Ts41NZSa5E2jAAXOU3mRCbwNc3080WnHGlHWyalYbHZ77Wqb+HduX5MtCQ0+CZVrkbfaZo5eyKoJKWRifN028/ZPywdN3WlxUKjaoIJhG2nu/J2CB6NF+SzGm3qKdV4z4pY+OixE07xgvas2eNRxXleSwVxoAMazl12CIB8dcYNJDkXCiNKXULG3+9efOm/snI/03VSRofNJMIv6K0nST7jiABhybMhPUr7UhSx1YOKS+R3J8xm04yeWPCoAv6/bqEmOcxO544hW1KDTszWAaVRa8tGBKMGSwA6jE98WhndkiNGwTIe2JwmWIcTbTKQ5/PXKzSLjwQv/P2eHLGR/+Nv69qBP9Oy7r1WTyj9kM4EWiV1WIjOUA/0fLcQkk0d3uAtKvuwWtwUUP0ztPZqmD6PX9d+v5lz65TR2RggrN8M10u+4CZ4FQCois+JSLf1kWvV7NKLoqj0JMWumsf9ROQ6U1NZWjG1w8qiF3DX0mA2TI86vRBC7o3i5yI
 xhKIWZnl
 BiNuC6TiH7DfDM90glyzb8oh1Sw85lD35W92wdL1s/ULeNvBPhJB5Drp9fl+Lj3/KnKslhiRL14iYhTWxJkW/0vjTVza/OXL7gFagSMw83dFLC6dmrYNN9ju04DPlXL4uKHIN2dyxpw9sp41VCkuHQYecoa07FO7U/Gch17KhIRr5FzbHgvcWb0v2/40aFxXCfU+3xsJh2M7lNPiXeLQWIhibgQzdGe2VPWG0CFE0nzjMyMSbUbmP1VIgZVPojGrMp+ccHanX4SVtbPNwp1Hdx5Rb1q7Dzt8Ox6vpwRgCQ9gyazoT0dhOzRIafivEiatzmTe9gmReTNoHHhuamsmLDUY7RC0eREpJYPVyUZ3gXZDOq/NDPrcg39iEhN69H0YwErEdZi0o4K7EBTC2qCF5xhsCIH8VY61VKK2PjfWsDHhWn55GUXwQID3eEuEgroHSEQpwxyZbfa2EX1tfwA15PhluzJW3WphKMksCIGa5h8nIj2bnXxzci1gndM6a/LrXeFD5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need all allocation and free sites to use the ptdesc APIs in order to
allocate them separately from regular pages. Convert these pmd
allocation/free sites to use ptdescs.

populate_pgd() also allocates pagetables that may later be freed by
try_to_free_pmd_page(), so allocate ptdescs there as well.

Also, rename *_pmd_page() functions to *_pmd(). Rename them now to avoid
any confusion later. Eventually these allocations will be backed by a
ptdesc not a page, but that's not important to callers either.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index c6c68fbbb046..dfe05cdf460c 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1412,7 +1412,7 @@ static bool try_to_free_pte(pte_t *pte)
 	return true;
 }
 
-static bool try_to_free_pmd_page(pmd_t *pmd)
+static bool try_to_free_pmd(pmd_t *pmd)
 {
 	int i;
 
@@ -1420,7 +1420,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	pgtable_free_addr(pmd);
 	return true;
 }
 
@@ -1446,7 +1446,7 @@ static void __unmap_pmd_range(pud_t *pud, pmd_t *pmd,
 			      unsigned long start, unsigned long end)
 {
 	if (unmap_pte_range(pmd, start, end))
-		if (try_to_free_pmd_page(pud_pgtable(*pud)))
+		if (try_to_free_pmd(pud_pgtable(*pud)))
 			pud_clear(pud);
 }
 
@@ -1490,7 +1490,7 @@ static void unmap_pmd_range(pud_t *pud, unsigned long start, unsigned long end)
 	 * Try again to free the PMD page if haven't succeeded above.
 	 */
 	if (!pud_none(*pud))
-		if (try_to_free_pmd_page(pud_pgtable(*pud)))
+		if (try_to_free_pmd(pud_pgtable(*pud)))
 			pud_clear(pud);
 }
 
@@ -1547,9 +1547,9 @@ static int alloc_pte(pmd_t *pmd)
 	return 0;
 }
 
-static int alloc_pmd_page(pud_t *pud)
+static int alloc_pmd(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	pmd_t *pmd = (pmd_t *) pgtable_alloc_addr(GFP_KERNEL, 0);
 	if (!pmd)
 		return -1;
 
@@ -1622,7 +1622,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 * We cannot use a 1G page so allocate a PMD page if needed.
 		 */
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd(pud))
 				return -1;
 
 		pmd = pmd_offset(pud, start);
@@ -1678,7 +1678,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 		 * Need a PMD page?
 		 */
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd(pud))
 				return -1;
 
 		cur_pages = populate_pmd(cpa, start, pre_end, cur_pages,
@@ -1715,7 +1715,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 
 		pud = pud_offset(p4d, start);
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd(pud))
 				return -1;
 
 		tmp = populate_pmd(cpa, start, end, cpa->numpages - cur_pages,
@@ -1743,7 +1743,7 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
 	if (pgd_none(*pgd_entry)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
+		p4d = (p4d_t *)pgtable_alloc_addr(GFP_KERNEL, 0);
 		if (!p4d)
 			return -1;
 
@@ -1755,7 +1755,7 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		pud = (pud_t *)pgtable_alloc_addr(GFP_KERNEL, 0);
 		if (!pud)
 			return -1;
 
-- 
2.52.0


