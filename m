Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E8CECD6E3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD976B008C; Wed, 11 Feb 2026 14:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56C196B0093; Wed, 11 Feb 2026 14:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369486B008C; Wed, 11 Feb 2026 14:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2382D6B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:52:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D24038BFB4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:52 +0000 (UTC)
X-FDA: 84433223784.16.4C48D8E
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id EB170A0008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aS8/Wz+Y";
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770839571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/OVo450sy8C6bfsuVz6bqbboM9QbTUPBayqtGks/a0=;
	b=208IwsuMjmjENdshjAMlCoBWWZoDkSf7yIjqfaI81KxppctofGgeCYPVfvVym+tVHOJu7t
	MoG+mePV40jI+V7VTyuAbPmPbHz84CxkAjgt8AfBPiMSfBKCFlZo4NqZ2zWXAOw3m1RQtm
	45xSp67G2rOAVEGF5/ENPAh+/QwZMZU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aS8/Wz+Y";
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770839571; a=rsa-sha256;
	cv=none;
	b=lUMdE5F7BEPz43FP9BQLztXe0T0iB/+rvRLq7pt93wHCMxP16BakR4mdxbznUUukq1AmDb
	bZftambzXDBhh3B0CGCupwmIcuvI1RHB0APSumOl4HVYlNzAdJibgbcJwiggMbDiQve9Rd
	yRZkZN72o3z09LbILGyciBqE46QkfoU=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-126ea4b77adso8091528c88.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770839570; x=1771444370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/OVo450sy8C6bfsuVz6bqbboM9QbTUPBayqtGks/a0=;
        b=aS8/Wz+Y+0QEErQCLwoEFoMw+A2D9u9aQWD3x3ODCaLXXCc7WXTE00D4X+JOiuG3h5
         Y8YjmeJCXiYzeduzokTOv72ID9kcuWoXKsRM03kSu+egCuxPqJX5pU4saynJj5nEo8JS
         qZPSs/GJq5L6xCs/29hqjal9ezZMNR99UTnCcow9J2C0CKX8UPC7rAENvi4R7f/YGjM8
         PKqj/xJeMBzZoTgymFWB4fOk39OWM3AyDKddnGoSx9MNkBkxU9qMr/Fi/cld7enlOD1b
         kuMGqFeNJP5pK4K9gO/5J758P8/BcqSSY2GYma7AAD7CDSkNQvwnjjvA3bS3Zz2hm4Pv
         31bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770839570; x=1771444370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v/OVo450sy8C6bfsuVz6bqbboM9QbTUPBayqtGks/a0=;
        b=FbcK5DqIaGB9m04lQ5A7YdyEDBtRwNOjD7JqqevQnT1X4U86xfGoAzIiZudts1Qr0v
         WY4gFHbx9FYHEDDJhiim2ocC/bvRRJ6wRUIEDSFEaWt3KzuRafVlPZHqHOeqmkuxn84W
         9mKVdTr7SnSF7/EG7z3qjlAvlgyOvii07KhfAD4uH77KfvdEkICtQar3EqJOGVUFGg1L
         wZ1m1N2090jtiBUoDbAZVIgCD/W56NLWzEZ496Ypxe4R9gLDiBfTbJ83ImhRKU/wLn3J
         y9os8KPaHNYtFhW6a7JvL9akGVyIijCEOLXLruPkCgnwVNZEhTT+f7evTm/K553Tar0W
         gpdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlpq9bJADTG66pkMFwQupFlAh1FmGorEQWRoJPRjwT7E0dnpnU20b3BCB9XQoeDGGtixOpyL0bzg==@kvack.org
X-Gm-Message-State: AOJu0YzYernrtSBOejqjrqvHXHCjHSQs6Jcwup9EVqgjhbN+cuk2Yfi6
	C8q3wFWOc7pByQ9JPvIjCmGIVNYi8uCyvKz4jnd2xSkUBZzSmX8Dj0wJGH0OVA==
X-Gm-Gg: AZuq6aIhuSqxaAQDxEBlWj+LAM+QPMeLB6gtHf/fT6KnVluKluaGZWbgk5FegsUKAPV
	yByDvQnFqCW/Ues9wYUIqSpnvvTTFofHlDQ16MN2GXF3i+jhB0vapEF2fscsJ7BMvAgtGGoEQKP
	5ENNrcMyOFPLo1X5kPNPsI8JELlYnNNi7eot/twclAbVe70EcILny4Hbrt07Xz/5wnZ4uPlPK3h
	RdEy5ZhTmj4llbt09FxkLg8i4ke8RuEsZcuZybqZ2SN+kEUgeWSx32hcaiSL1PQ5vmOVJcRi0i/
	468PtIGesDA4IvP83QSZoO/RR68BdTJIcOae1b/V9eRq2SM9zm3u1ALs+x0TXx0fLzOQL3iAZJE
	ts2RC7Z4coN+nHSF9PwWwdnUu+wnKZs7QsKVSp+YHaZT0U+uzbcRPMFVv9AvAPWrRauki/p1uWm
	AXKptHx/JKUdnUzhPTEL/jgiNynZ5tD9lYPs9wKjksd939flYW6KPz4L8=
X-Received: by 2002:a05:693c:3106:b0:2ba:81b2:7811 with SMTP id 5a478bee46e88-2baa809928fmr185399eec.40.1770839569589;
        Wed, 11 Feb 2026 11:52:49 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2ba9dcfe6b7sm2426463eec.29.2026.02.11.11.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:52:49 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 3/4] x86/mm/pat: Convert pmd code to use ptdescs
Date: Wed, 11 Feb 2026 11:52:32 -0800
Message-ID: <20260211195233.368497-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260211195233.368497-1-vishal.moola@gmail.com>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3hk6gzk8iyj9ewkaxrnonuefjn31oj91
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB170A0008
X-HE-Tag: 1770839570-261640
X-HE-Meta: U2FsdGVkX1+7o8zMeaR8AVm76f5PZbfq3LT7IDiLKDcmO039FdTvRwAY3e2KWKj+NiC2DPCQ9DLzD8x82CUOPmeZQne4PJpY9ILeJs/qCxzQ3kQNBTdz5gpQJHZc5p+h47bBwkWdYw3Fh0tjv0pBtWFIw9npnxsKDdnfOJpuiGg2PN0QCFBpIw2L5dTVMtL1YUAx94E+WUW6TAtZNnQ/xCZf/fq1hXfsVwrZ61bMyQkArJZG7kaaIbg+hn+JyKhcsnLj2C83Nm1C24qdlc/MXoVW3turRMX21vmvkq+XYuj7+lu1sf3X0QdqslitDbqi4+cn6FKmw1cgpQOXSekyAGiD93Kp8vOyr9z18gCO5MYSWEPaU73ur6dKT7SYnv1/1VLNRIzoOLFqFpilLuJDKvn5RysRSGyOAUMv/NRAnxissZmbiStrxpfsdJUbRVh2yfUne63+PbOzSSHFsHW+BZrOaKM7gvrSB4W4tI5YqfaR6X4FyoC/1yN7kTw0wFVnyO+WdFI+cjR7n2+chNm9b78UTQYmcw9BsFeGEDX3CY6MUNFT+3nrzVsUMg9AIhhKvWk/b4UjmFMXVhm/R5fDr5sY1ztbTlNfjOulEwqlT2okKtZGWBMY6zCzQDCL+dDzeGCQAMbvWscd5a5ChAxoHgEr18IqaianjFWqM/yxW7e2Fdp9jxuz8B3O+X91TJCbMxGTy4G3GcFv6B+701QQyjTi1PQDhejUdug8Q7H2YePbhjWh2WjWJlpy4fQx+MUbgfYnhGueHBJHwEmto6RjfIVV5VS+kWxx+fekPU3IeAxgB3mFv2DU45haQieIVqqyMpvNCQtIAU0S/LpGeuqzb3TcOlDoAWTncjx0tqOrTu3FEDXiXLXHonSz8+OSVw2YzoKt1iBgGXzgEW+b3vMB6SZMq01p+267ClIUn2ECRGw+CTNgwdZdv8h3NUG0p7TegoVyLPOApOfmiZGyldE
 vSLDvDK4
 TAhH3C6oOVx1z4/dulJoX1NA9ZX/j0ezQsOWtWmZFIJvsPOIf7qUWKoLjJiduWEZLHQ5pXu3FwETdfN4VY0KTxqytMFCPXDjl4Mx+rnrkq/pmzKZLAEdhzpo7hq1K/d7HAA6+ngRdP/xz5Ro2EjPGr8C0wmKkz1HPkj8d8hkvjAKHb3iVfjqlNPOzQgPh2zue2oiVPMeDOCjqCvs02LjLYMqq8SHzxBnBLwa4dg31qoh0OWGWnPpLi8E40TBItSXPRQMO542IT3wvVQfCJ9A3S5LazTXl/ai1WXKGTiR34JyY69e9502zRT/gzsIRvrkrDOkMXQDZTAh1MsXyOXL/B0mktFEwSupztEfD9FNjFDpVHKNTVS34KLa2ExUC6xMwia9HfhC3XHdcyOt4vx7rMNuXoZeWJ+0+ZR0BNozHV8H2XJDMPi2fRq2jXqSMDwmsFoZNGWjQpKFDfD0VoaEvS0rB1PCTkVIx94H/spuzqjREmroUqklFTpy6iXZKN3IQdU0G5hJCHO4WAxcov1WjlmeuiGkQs6LE3WeJjHNn42V8hTz0tFTUiX3WrbY59Xgwo6W7cM4FUpJv0H0+XTe6fEr9wD2c3WrC1AEI
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

Allocate ptdescs in popoulate_pgd() as well since those allocations may
later be freed by try_to_free_pmd_page().

Also, rename *_pmd_page() functions to *_pmd(). Rename them now to avoid
any confusion later. Eventually these allocations will be backed by a
ptdesc not a page, but that's not important to callers either.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 04eae65aedfc..9d6681443e54 100644
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
+	pmd_t *pmd = pgtable_alloc_addr(GFP_KERNEL, 0);
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
+		p4d = pgtable_alloc_addr(GFP_KERNEL, 0);
 		if (!p4d)
 			return -1;
 
@@ -1755,7 +1755,7 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		pud = pgtable_alloc_addr(GFP_KERNEL, 0);
 		if (!pud)
 			return -1;
 
-- 
2.52.0


