Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74494606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qySz4Iss
Received: by kanga.kvack.org (Postfix)
	id 88B4E6B05BF; Tue, 10 Nov 2026 13:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B2C6B05C0; Tue, 10 Nov 2026 13:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703146B05C1; Tue, 10 Nov 2026 13:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47C5A6B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:00:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAA2C1A0A9A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:00:35 +0000 (UTC)
X-FDA: 85419974430.15.BD6FF9E
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id F11311C000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:00:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qySz4Iss;
	spf=pass (imf20.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3do4ymgkQu9W4+TcuI1rL2WbfZAofbuASAnuxyg2Dw=;
	b=jpD2QZGd5uCtX5S2O7KdykmVcX3iQRLRDPwBqerPlY4F2xOSNy1Juf999A6YTzu6dl6UpC
	LVEjzMON/R8fYyQY0+XACIo5kgMaib1PGU2O1EckjNai3r7PYb+GMqLlyCF+fBpfHP9Rgj
	ipioRxqU3LZTU7q5kltxM0Eoy4P+0ro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333634;
	b=fr3qmQsTgLFNe8rhalSI4e2vGbxaxSG2HKXXmGGBOfue8kvcq2hYp1Nfwk2bRwX2ZQ3YyK
	PZLZIaIzvWCwGL1d+znwylzADxlIAetfoDzXLhKUP9M09gfyTOia7d0kxFhV9G8fTcoY5D
	dN+jc/HFQRF6YEZLa3q577kpsdrML5k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qySz4Iss;
	spf=pass (imf20.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1a8cc11ac42so2250172c88.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333633; x=1794938433; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C3do4ymgkQu9W4+TcuI1rL2WbfZAofbuASAnuxyg2Dw=;
        b=qySz4Issb1UnMTzDs24Pvk4Cqoc6zy0vEi8bRUuitJ6z3sj9xkAgXSjpJ+m6jpS5RV
         NxKMDcY1n0Qnl4sS6peFyzzKtIYdnwUhOnDHr84cpPSpCaTTFS30EWprqpDzzghkfziP
         G69JM3v3M/705mtQ21lRWYMPp/z4+Edx+ms5B6TJnNzS198W6/ntcnzUImR7FMqg4lAw
         Q8n+sIFG1HNsBTFd9gdp2ARU7/Hqx/GKBNJ3/jqE5OZuzsKTJPOKIn8DoQY8YNB+K4db
         Zo2V5XzR07SlSUAWPTbk7pQ4GPexLGTrCK6im4iX191+aUYjPusXfz1pBGhCJGKuTeGD
         BlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333633; x=1794938433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C3do4ymgkQu9W4+TcuI1rL2WbfZAofbuASAnuxyg2Dw=;
        b=OMTfQrmHoixpnT20gon5yPNqSwRpZXGc4+RZhd216wIBMHG0nph0FMRl+brsUJv39S
         KmksK5l7HmThLB21jGZibt9/J+X6NIxJxQmRN7orUK7390RhpnZ+7tvb2f93AUB97G8w
         z4BCNn33Qta2G6heLL3idNKkfxdQ4a1Y8R76HZ/9R1OWGBXZgGdLEq231Rz/zWJKafPz
         J2CU7Ey1I5YA39r9ig5FAcEGQICqe3ZdnJi9t/3vrJmCN1ID2rkON8ENml2srjp/eHMN
         u/YokjhLMMF/dug8eWYATxhmkfYRj4pt3I3Ic0cqPcKXO5Fo8sNMCshHFNZsnwpNbwtM
         9GRA==
X-Forwarded-Encrypted: i=1; AL+hErHyxeiJKxsN6xCHvSnJnk2D1vjMGvuUXBpUc0cCHmfpBdBvT3hGxkGOV2zUrvDuzGunCuSllJcgbA==@kvack.org
X-Gm-Message-State: APuU4Z80dABLNg3Orkr21W/BAwfO4vmTKbx3gQlLlYz3Zp4nd0YdLqnS
	4pQV9S5HeT/gDxKCUok4WOR8vnsPN9r/5uUv68dZ/b3m2WY6Jd5YGl5o
X-Gm-Gg: AYBFou0cq+lDeAfE4/420IgUjQhsD+EmZ5MsoUphpo6C408ZIPOkMS2DjxSLbMESbVP
	kmctbINw/QTncnIgAGuD1B5/D1B1zg/8BVro20jZYeSH0UKYs5FnIG1vzlIiEiggEGKmoqtOV/f
	LPsFbXCNh2N2fUiJauS+3tbvkoi+jFuNPGBRdcV4Z4J3q0ULq4+VqJEvepJLcqcptHrN560Xb2P
	gnTrxkEdSi/eY8guyCQYuJa6JqUyTlP6XHXAJFlVRIEbGS/36rlOm8Nm/3Gxyu3IiUAl8XaUkL8
	QARgVwVaUQMpLUP60sDCHephB80r21XKE6tRfNaWL3FvhM20rujuzt8zyEkSurK8eDKP4ALwW9L
	Ng6w7qIGCI+VM3tqykXv2NIZ2V/ZW3ooWd7Yu0GB5MYVGkZOdWYQGj66s8QuJYRlx7zDVNKB7dG
	KCHZTLAbYwks2wYJc6nf8i8cdjEbkOvyj/ZtATnoWeHQomsdWf/AXcxJxpBKYvkJBdePeNMqWw3
	XYaNpZQmIGpd0zd9mcSi21UWGVARVOwwSSQnQ5fgxCZ3VNaH4hsfOBMOl6k1agFnevVM4bpO7A3
	KA5g5hFYIltc7YuHCYvfypH0BFGhN3giPXDCLxYTXDNjpwJ2GbOt5D9LlFM=
X-Received: by 2002:a05:701b:4585:20b0:1b2:cb38:5412 with SMTP id a92af1059eb24-1b3b61960f3mr4159856c88.42.1794333632388;
        Tue, 10 Nov 2026 10:00:32 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.10.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:00:31 -0800 (PST)
From: Yin Tirui <yintirui@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com
Cc: ljs@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	nico.pache@linux.dev,
	usama.arif@linux.dev,
	liam@infradead.org,
	kas@kernel.org,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	yintirui@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RFC v2 4/9] mm/huge_memory: use normal_or_softleaf_folio_pmd() in the PMD split path
Date: Wed, 11 Nov 2026 01:59:19 +0800
Message-Id: <20261110175924.2945538-5-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110175924.2945538-1-yintirui@gmail.com>
References: <20261110175924.2945538-1-yintirui@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: h35efhwpibzo1nuuhewop3cupku4yhtn
X-Rspamd-Queue-Id: F11311C000F
X-Rspam-User: 
X-HE-Tag: 1794333633-782707
X-HE-Meta: U2FsdGVkX1/7GicAD1gmYs8pqnjdxBbJv7KF1SO4Qd4N2w/sCRiILUH4pCEgAjjeQu3wOHliWISGgJEQpR9ohJXjuEzLeV2hZanLaDovMf5u2wKIK0npkkuG9AS+rwgV1lcSpXWJOUzTT/tIBAVczKlp4+2uh0Pi3Yr9AtCIxP4eyP8VRo5g0mlBpy9XAIB5PqKMFc6Tt9redU1qv1PyQEVkNjuEYAyyeRjZ3hpQUTlDiQ7+Xp35hk6xz8cOZ+AXb+1LUtUQOM1D1ZyahA72u9Ks/VuwPHk55oDVeZdIiCLrOG0EOkQgx2MjVsb9uCWYNAdN/h9gH2XHmtGtFStiuwSJsSATtv9buFV6YRp6xlweRBwaQSXNWQKtclXlXqOVdwxtsutmf8GxHjrEE7AuGLDoygmo9TTWD2p3EGCTiSgNsZXpJyJLx2Sew5AA4L0USDN5FdPJ3NpNIMENEelGH/vnGqq9zLZIYVlrYTkQzvUvEXbv/g6ibG8ee9cEY77qBJnHqi8BpHTyss1L/qBwJYySgDdOnH0bI2YGB635E1WzQxepGEK75+MXNyncbt49gP/+I50V+hqetk2W0mj/ceVbzW4BylXBvR31UOWx+usmr5+CRa+56CWud2hdwN/HgamUkE0kPX/XhLMROMo2ka/xRjMzR7fwgsCfpBKn+UuPAMmH6yDqs1cQllMYYOQ4QNt0ZNJ6mqv4s4IkMdXFojxWnr158XZm7i+QlEFHYfarf/jpD0QEs0fejHhTTOJhSGu80eGih7WWmx94Msd5HwOTxWcRsAk8h1uX+hJk/fYhtmzGTM4ntDNctkx3fswcyp6LJ0uwvuy9QHVl6E6vQOUvRv6kb5DNhG0uDSnxDWVsVfQLe5Y/IEiMNAmPqN52Kpo4YKF2xIQOOE2x1cdXIFGQMS/qO6MjXXqfFkCcw9WNH9SwMsW+ZIj7bT2047U7h5tipAJee8f4dtDYWHD
 HWVywbS4
 DsT/LJmqqkHun9wNpv/+nT8Eqyp1dKbu3v1GaqV0ivgYQMMLzKyxqK9yft+2tQV4IVkn34iZVLR92JWZLiry07qS1Duvzom051Msk5fF3VaR1MoYDlIPO1B5xEaMzDckvJaVxe9q7udkcjTcVDJhTrcS3Jq/3Qs82KHK4G8ohokuhS163Mn6KmtnT5RmtLZfeWzoYbcYWluMa0u/E4NZUFtEgfNTMDjrovvak29EdRQI5YaCWoMSIBtZzNaOYuYihB1fJr9cj6qK+zAsJaMaq6wCeOGIikLF4aLLbxfQ89yWjQUVS2BpizGIEgwJa8PEJdLZ/97F/8jArdMqMWw4Lk/eW3v6g+ZerqdtR/aIKLRKr0BAJbHl5jbGUrCbh9yapNUb1GXg/1SRTlgx4WMvqtYcFGq1OSRb7Gxs/qvB3lT8BqYSHVDotpcSrhmLzJR23EeO2BhDw/sm4HYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Get the folio once with normal_or_softleaf_folio_pmd() and decide the
deposit once with vma_has_deposited_pgtable(), as zap_huge_pmd() does. That
makes split and zap classify an entry the same way, and drops
vma_is_mm_managed() from this path.

Behaviour changes only where the entry and the VMA flags disagree, which no
in-tree path produces.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 85813114fde1..d0ff2957e47f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3217,7 +3217,7 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
 	 * We are going to unmap this huge page. So
 	 * just go ahead and zap it
 	 */
-	if (arch_needs_pgtable_deposit())
+	if (vma_has_deposited_pgtable(vma))
 		zap_deposited_table(mm, pmd);
 
 	if (!folio)
@@ -3244,6 +3244,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t old_pmd = *pmd;
+	const bool is_present = pmd_present(old_pmd);
 	struct folio *folio;
 	struct page *page;
 	pgtable_t pgtable;
@@ -3277,16 +3278,18 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (!vma_is_anonymous(vma)) {
-		const bool is_present = pmd_present(old_pmd);
+	folio = normal_or_softleaf_folio_pmd(vma, haddr, old_pmd, is_present);
 
-		if (!vma_is_mm_managed(vma) || is_huge_zero_pmd(old_pmd))
-			folio = NULL;
-		else if (is_present)
-			folio = page_folio(pmd_page(old_pmd));
-		else
-			folio = softleaf_to_folio(softleaf_from_pmd(old_pmd));
+	/*
+	 * A non-present entry which is neither a migration nor a device
+	 * private entry is corrupt, and pmd_to_softleaf_folio() has already
+	 * warned about it. Leave it alone rather than act on a PFN which
+	 * means nothing.
+	 */
+	if (unlikely(!is_present && !folio))
+		return;
 
+	if (!vma_is_anonymous(vma)) {
 		unmap_huge_pmd_entry(vma, haddr, pmd, folio, is_present);
 		return;
 	}
-- 
2.34.1


