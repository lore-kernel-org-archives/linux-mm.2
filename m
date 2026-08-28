Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3DBC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA136B00A5; Fri, 28 Aug 2026 14:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABAA6B00A7; Fri, 28 Aug 2026 14:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999AB6B00A9; Fri, 28 Aug 2026 14:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7266F6B00A5
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F4B61A053B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:34 +0000 (UTC)
X-FDA: 85151536428.22.A3694EC
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A23F2000E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EPq3tmDH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYGUS2yq4w52aMYmHXMMhpQA8K1oYL7onWQGdlT1JgM=;
	b=ebH2oCdnWqcMrCvu2ZkRUh9pmEEU4NG42mNnljIZmK11O/W9pcdEPmt+7y5x/nj66gJLhJ
	l0Yx13VwYhTp3mA5bcQJg4qjCBJ3pkvMhzR1C2ztpBJkyhK6vXRZVbpAyMsb/BXxRRn8GS
	x3k6dPw7xdgvHn93DpwS5N/9N7nW+kY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EPq3tmDH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942252;
	b=69MvinGElF6c/ydWe6xEzQI13RNcpwZvENWSvDrdVn7/0OOqDIfTFoxTkqwSIiBrS91LGA
	iaQsSRsVoUDpKVfGyib5w9dQ2yi/FzxKDnsi+SPKVDVltYDS8VCPECB+8pYhmRliP4PTbZ
	axw4i7DJJEWRfY+U2WnulKLBRnYsz8Q=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8568e3ecfc3so675562b3a.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942251; x=1788547051; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qYGUS2yq4w52aMYmHXMMhpQA8K1oYL7onWQGdlT1JgM=;
        b=EPq3tmDHMSNtmtteSGH9YczDQjUga1KZbkFlC91jtt1NKvCPMT5wfZWehURp5xDh40
         w8aiwRG0YDbzGg634EkCwzB9HHoTfZAU508q22IDyPc7YRfQhNBZU8nl6xwKx31IBpQn
         P03t5c01r98gegwhkqFWgJlmzitp3EIjmhTaZJE55QqUoj2j3CxIRLTAayZKmWGBArrG
         PniykJVvIVbHy5zbPk2G0ozTq3ayqAFloWD3sUnrPQNyM0lm35VODWKR2MH51iKPGfUl
         ksLBQ9KXSnPAFRfstWBhnZ9OYBswskGDOu6whQb+rA9af0PEYEqTgmWnCBRrIts9syQN
         zOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942251; x=1788547051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qYGUS2yq4w52aMYmHXMMhpQA8K1oYL7onWQGdlT1JgM=;
        b=iZo81sl5CpFLDM+k6vINsqUDHnijCdN+RsnVvxmFRjOmLiliB+bTYUo8Ap88jMgwmM
         CniuB8iUM8sc8I3SQ6fTDvU6yXenTkn+76PlGxoVVgqzBlmcbAcbQbDr6WxbJ6jDl0PP
         8hCqx4QrNu3a4UQT2nTtjOVsAgZZM/xudrQGJbJEuoZKj24f2LAJfT0T/RUblVKxMt0u
         jwvhLzoJfq9YVAzqvT5Ke5XUQh+m2I3i7oS2nIf4ERcBa5xtPj7AboWPRmsyUneqGJzJ
         vX8kANk8ZIxB/iqydELayyG3VtQzGtkCccNHapmD3XdYYKeurM+uMP+8to7aT6rTC4/V
         J5Yg==
X-Forwarded-Encrypted: i=1; AHgh+RojfPSX58Hd0hCSi+XWSv3jlYcd8Hq4wxdvNcTP7HozDTOXZiGK8WqjWhqMSjVS2SOkPdMSSxySLg==@kvack.org
X-Gm-Message-State: AFuF++lDzddjas2+uJ6M8ZDEWmWhZBaDn6cgiT6NMirD3xL9qpCJxzWy
	IhXYD87kIBo2EP7zdiwf59yV+/IJH+mA+GauM97E5Owg4Xh/WEkDFsD2
X-Gm-Gg: AR+sD11siqG2A0yRU43Zg4Ms3dyO2WLBRBmXMDVXiua8YVLZkoU957yxfd10C/tUKYA
	Uh+3xjwBNuBR/BejlcOnh9prj10cuyidpTqF6XzlHYJAUDwEZ6WER51UUzt5dbyIy7a1ZhPJ4KB
	yOFsorxQr/bX6oRF4Vm7xslZe7c7CP/ns77bRAwyGMxiWW/OnKiAnZOwkQ8ceEtBk4vlpZJHAMc
	n6PFW1/IT+J7SfoQjDSoymHHOYZzYqGaUTckokucOY/Ot2P1a3gIiTPFSIV9YiB0NO9DxeakZpK
	jr0w7yhpUCsU7Z280J0X9in7m9/I+WUvemY4bkO3hOJ7YryAAIQbE4eVvIhVNBuyJHWq2++LbEN
	tGs9Zm9ce46XH2hPiPRIiFYy1b5s22ZKTb/DwFgsuo/o9y6xqL2HhQa1k8+nNRZQbHWfhVl5ab1
	75LYM17vDeRHMweksnrap47U0fM4GXPcGwolEEyxPKIZqGRUX2nmw6Blnu5JwPEL2VTJaQErqfn
	hmOABPnN7z6RBMcjQ==
X-Received: by 2002:a05:6a00:368b:b0:851:8baf:5b29 with SMTP id d2e1a72fcca58-8562a6deb93mr17519619b3a.10.1787942250996;
        Fri, 28 Aug 2026 11:37:30 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:37:30 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 4/9] mm/huge_memory: use normal_or_softleaf_folio_pmd() in the PMD split path
Date: Sat, 29 Aug 2026 02:33:14 +0800
Message-Id: <efae5222ad43f749c40aaca9b759b41844fdded8.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A23F2000E
X-Stat-Signature: rcw6tq4odb6bc1sey7mhnjd3yhi6pr5q
X-Rspam-User: 
X-HE-Tag: 1787942252-237206
X-HE-Meta: U2FsdGVkX19NybT7C2BEpt3D4lPXJnaXnXtD0SjsBgUMfbAPQu9Uit+oMVKgHHLfXEjA6IpW+Bl7b9NeRfziNCWKWC/JM9JS73+K04jK7H9gcfSd8O1NRDp9R9x1a4IwkMVZaPkWNuWSjWyRcyGt756Zumx6+qYXWoJPOcD/XCxY6I7IKlha7X4MFNunyvxk1/w1fnzP2ku6AhmZl52+XFnvUog+bsMmoQ5+wKtR1bqaEvolnm9lhiJIm6k6l0CYUcYyQByvaJxrw6eZw8vsgRrRliEZJB7tRX4Nqxk+XXHXC603nSjd7gGg1IQXyf3W6nb6ywk0RomfcPNVCYrBtdqzz4j2Wd4dObq3KIFKSiVsGO1oNau9bmES4AsAuKxTd7GIO4CAbmMHvmvJyYIZwn3/hLbF5lj8aSlTaxEfl8zQt4BKGiF0ofwJhzuPxl6KVFTe0pLiWrA+XdNcvcgcufkW04vYegmByVZB1NOpFXsFjWb800srN6xtr4ATjYVrEAfV42vm9ZTbSUQGZruMbDmibTEgUwTHrOHlnRnKZsi1/XPXlDcX3RAIikdmMNnSBJ+aKtuNWwTxWmZaTcmuRe0onaELCmUTXB1yDJsNWO2mW8+6FZpyiZhxKS/1KasUFZATEfrLN0AuIoYc80hYX4Q6le72pnFatC5OAPmsALVCj04RTTHKstnjFvVtGAJlnjMbhGvgEXOVKc6BCoE34oJir/ii7A85jz6wwHjqhwm/agpSHBI5KfpJckmcu5dLCK4J8FVux+AZl9MY4e8cra9J5NS8FTNMFhE1V9bzDkl9rivPNIieT0M7BVBPB3M+kRKmkunxjAYXmPMh5A+w0EME1aIK/UqSysFRhV09/ASo7akDF9xGcty/Ej/R4Glb+2dt+tnmpsZo2S7FqXqb57+VEnH6pdT2POqDQ51QjLag3QHg02Cj1Nc0AcvrcPbVeVXhFj5pNMDSfxyFcXB
 fo3NHGuM
 xWsd319e5xlH5mnDNWdIY0EcPPGU/9c4Q0+mb7wxCRTF3W0PUyxi8p/Odjk/vkuQa9Gb3q/zZd46kT6rkCu/OUxBtHYnP6h6Dq5wwJfdRXuQcyj/ubezH6bzNSRxwrZM2/P8SftVi874Px1mNwQZ1iY/6M2qUCZEJp5avWDbopVo2dsIULAS0a1sGzAmFpFE5JDQ80sl8GsAdFbVbaZlYwvKLMkBXQRT2WHQQV4vG9EH6s8Q7QTf4rofEYvsBBiOIIYFaEYdgH2CC3/sIG/sl3JHguxf1ooSxgqNpni0R9nwaky/DC2eJcwGyOSVZW70lU2ES2BC1obT6/mma0g3npxbiByQpXmz/csFxeUtSiAimyVQGl4dnXkVmI1fNGICZg8AvZAVtD+Mw1q3IEjzZaelrP0bY/Vh414e0JHw/Z1mXoyxJb3Qu1rkHis8dMGrVZfRosvXUszDrcmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Get the folio once with normal_or_softleaf_folio_pmd() and decide the
deposit once with has_deposited_pgtable(), as zap_huge_pmd() does. That
makes split and zap classify an entry the same way, and drops
vma_is_special_huge() from this path.

Behaviour changes only where the entry and the VMA flags disagree, which no
in-tree path produces.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index aefd62827139..b2ede9a6ae5d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3172,7 +3172,7 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
 	 * We are going to unmap this huge page. So
 	 * just go ahead and zap it
 	 */
-	if (arch_needs_pgtable_deposit())
+	if (has_deposited_pgtable(vma, old_pmd, folio))
 		zap_deposited_table(mm, pmd);
 
 	if (!folio)
@@ -3199,6 +3199,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t old_pmd = *pmd;
+	const bool is_present = pmd_present(old_pmd);
 	struct folio *folio;
 	struct page *page;
 	pgtable_t pgtable;
@@ -3232,16 +3233,18 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (!vma_is_anonymous(vma)) {
-		const bool is_present = pmd_present(old_pmd);
+	folio = normal_or_softleaf_folio_pmd(vma, haddr, old_pmd, is_present);
 
-		if (vma_is_special_huge(vma) || is_huge_zero_pmd(old_pmd))
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


