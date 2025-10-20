Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25D2CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE198E000D; Mon, 20 Oct 2025 11:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E7A8E0002; Mon, 20 Oct 2025 11:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D908E000D; Mon, 20 Oct 2025 11:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E41638E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:11:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98DE91A0190
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:11:36 +0000 (UTC)
X-FDA: 84018831792.13.1FBF255
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id C12F51A0017
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:11:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760973094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=xapFPBcIStZkytv/ETnNi3GDKQo+WlFQKnTNuCtXFIM=;
	b=DonhATeT9T3UEA+D2cRGJi2PXdyqzdBaoLC/8C8loTK/eU79O6tVoVh2jcG0S0A8aSTZwx
	ECAwlnlX15rvkI20qlQuENp9P54hy6DvPFrGwdcbrDA9XFDWAafXS6UkE2eqRAbwD08PYF
	wAK78i5MZB1TI73Cuqe7i3m1iUkhuiU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760973094; a=rsa-sha256;
	cv=none;
	b=L/kbnH27foXGdR2slH2f8PhyTMKbLenfT1DXe3Ixaio7jox0HTrxG45OTw1fi0dncYFbbK
	zDBOmbbBRe92s4uElAedrxyivVLVYZn3BfqIfriXc+2CHfzYiEjuIXUnqzZLnPeDKo7bsq
	eCx8bVfoCf6Mc0Wgkq+9r8PZ6BD/FDE=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so19698975e9.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760973093; x=1761577893;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xapFPBcIStZkytv/ETnNi3GDKQo+WlFQKnTNuCtXFIM=;
        b=TRp2fuwIi16sxsrDRM1kajHuUEMTK3bwQ+XXxizMn3jEGxyZGa5RRy5+/nuGt9KSTn
         ehYPC2DK978/CpCTfhEZaXjSJewo09L0OTOAvPzpTcHsqc7gq26QHnHEDwJwM8GvG0mD
         D/qWeC7M7lRKLYHWMyTog3grX3tKof1yXpKp2nuyqKo7VSpYTCSTcwXgDFATbeuRGBAE
         Om91Y7uDe0Ak5CsOpzFTAXrtRTL+SawI1DFJhl6tt6TIsNGcb0Mh0xNDWJ1GAouOkEGh
         i+pDRAp/jYeOnfwl2/uyC+AVN7yhCU2XY1uwWhGQ0uHNUlZwrjjOlEiHTCCVKCJgdySY
         rAZw==
X-Forwarded-Encrypted: i=1; AJvYcCXnKH81PxCcNwLNo4absvKZf4r1yARBBF/gc2M9XWbPltd7bhOzMwu7g4LRaoQraVisRYPt+IC7jA==@kvack.org
X-Gm-Message-State: AOJu0YzUhPC4UJ3kbW74UftH/M3JEIp/qsyhDCbWXknzHFu9yxCMctJE
	Ws7jQiITX8BDuRRdg8iY8bR7o5+NdhBNNdy2Ex9EY77y+R0gusECA+aT
X-Gm-Gg: ASbGncsCscPNamWQ7Z/Tfz1w6TuhilZR2tzLQlCnphB5kjWCpN5hmK+WJmfv9g42t4v
	zaruFkRDz9ntJHpCWau4sznAavbYX36PxCkmJqu/eO1fQYHIreKGEkiWHqAcnSBXCPLPTrOzDCr
	THi6JImNQdAY2/P6ZSwVoDoRrepDs7tif6jA5e4tkvpxS+ceWn8oHtAeve5qFrmI/DR/ErbK47K
	e/i4dXRuYoXWY6jW3ClAT3rkpaWjm1DwPm6rWoDrrHBkPucCEQjeF4qKTVVpuQ++k5lzwTdlLK4
	FswCT8DJsQH9zsYD8JvLROa7PtBB52/mL+zag8m41EjHng1ag3kR0fVXJzwY9xaJLukqqhEkOgF
	He8Y8+O7qmLCC9GIwKm6XT6xeFgsPqbOjMRN6OC2rn4Fdy7PLBJcEaFRqcODyrr/YwZtQpB9JcC
	XoBEg=
X-Google-Smtp-Source: AGHT+IFZ1aeQR12oUSXeiDRJrR3mCpaEJtTUm8uvDUK2YrM/Ongf5OfImsnLjKHn868bXD/fCM0uQQ==
X-Received: by 2002:a05:600c:548c:b0:468:9e79:bee0 with SMTP id 5b1f17b1804b1-471177bc126mr93837155e9.0.1760973093038;
        Mon, 20 Oct 2025 08:11:33 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::30b2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711442dbaesm236142095e9.8.2025.10.20.08.11.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 08:11:32 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v3 1/1] mm/khugepaged: guard is_zero_pfn() calls with pte_present()
Date: Mon, 20 Oct 2025 23:11:11 +0800
Message-ID: <20251020151111.53561-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C12F51A0017
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 51799bt9bi91o9mozo4yyqcdxfmbm749
X-HE-Tag: 1760973094-990072
X-HE-Meta: U2FsdGVkX1+7zWpKiIzB0FQPelf7xr6KLJbvfUM7YqJ0d8CYs/NSRZK07W/gppUEQlNpHeyvmSgVkadsRry2ZXNP0Gj7Qa8xjpAZMkJLzOkfUkjt40g/Zehk93B/fY5v38z0ax52XDFMPgKUKDney3ilaecrDFvzGXeD5mTaiPNY/Fh8fmqkPRWHdPAB3mjdfR0cJHAI8K12yuWMfIevP9JEG2csFkmA4XeNmw6bIJq4Obb6BlEFcOmYxAUg5vCEzZHWBDzEcU5vrYH5tJ/FdIAmCIQYhtqnGaGgnn3UrEAgIa5LDR+fTjlEJ4FWhm3mM5cUYqGmSxtO8yPIh4KCa66i6l0hy7vakW7pQEhhjcCVnDP1YnoicAeFWD7Eqrf82vJMlwxZ0YWnNSNxkxJtlY12OK4e4Q2qzjeAdIPx5HOtz4mDBb5/1KdtXZCA1IH8E4SuyvyNEOT5zwVOXxj5cePkmPS9sABytitiPR+Ucs6JGVmLrxiD62dlSTgNG0+412qfbOMfAxzXBhQ736MiZs+lrYvDgtAAtxX7uDrqaaXj8MNM1bq/2mlg85UHDEh8a8GVD9ohIPLOX3J+qOyz3SgDa7nL1zWbMUXeHXQfRE+9mtDvqY92nZw2Ff6lJhcBiQjcarqA+FLAr4aJW8/tKtsoiXaunYA9Q8B7c6kdjfNI3pduDduSvGbeqKVLsUcMxHgYlyOrMYr7VgRPy3GYQfkL21vfK7EA7UTIHPlO7xs6VAlZvNzC/4tOszu1sJKQPJ5EEPr0jS54Q+rQfv6Uf+0GxH/WXXI6EIoIq/q02NgXRbu0+M49dMCXg4U995YdNze1ZK8NoCazUyx5uLRnD19MhuRni2oYWacC4cxtqfF4V7yhC5yTOAY8/C3eIZgW+HQNuNSHvEIoU2zSAKKeHQ5jYSk6gH1zcD8+KGmWqktFjfZHiR/GhTvPkjteHVTG35JQpfAdi7oNl8j5j7I
 QS9GrMPj
 +nEb1/nOgY83MK6zMeUY8z3NZlAO85nHGWK+pCdsLajTXu+eubFZCfomiY1MmQU8St1Bo2ZekSLMbuJ8rF4DKIESvlSQz9G33cVdE4O427oDjFKTXpoRy76IyUkRTKRZhJ8m0QP3ejq3GZQdArDhSZJ7Op9/1UW9VPnTdLkuW8a4PanuTt2Trx51fiTk/gWKBqJhXJtlfqBzgau/jiz7R0IWYhLHiUz3DXQPgd6gJR5nCEUNqVWWtKiNcQIMJi3AbCltNDW4dUrgz4M+Usw8zGWwekJ4cjzvi04+Pyt0oqKJC9zfI0nCHTOzwf+MR5cL6xuYQWhqDkK/Yi8bn36G81to0uwNk2THIVicPzThGPGJXEg/0TMKzy4Q2LX8FLgk1PRU/AXMItvDD4NXJN0Mc5eKsxBNory3y+VFvFzfOD6jMPb6tCQKnBBPW1Bf+7n33SgPXuIuYhjS4vr0BuNP4hfD4uUfbR4UEAI2c5HFnTKG2Od27Xji+6CgrmuyChC7X8xG+rVsdSZuNSIr+3DsVTxQZDgQJ+GPSx3b5FOl0WMTuvC4s/nznFoWhSYa3n6qGH2UFi+M023UNYR5GReTFkgSPfmrP1z7MKLYBIGvIRL80PdW5WqEthttoGiFFDJ2NlLdXyaZBBDsiXKWQYydBWZCn1XZDArmXKsuY0KVINCVCOHKDFuXE56zxs4dSrTsbow0wJedCpeag4zBSRp7kNlMbXRQPVF9AJV7PFSSlVVsJOsc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

A non-present entry, like a swap PTE, contains completely different data
(swap type and offset). pte_pfn() doesn't know this, so if we feed it a
non-present entry, it will spit out a junk PFN.

What if that junk PFN happens to match the zeropage's PFN by sheer
chance? While really unlikely, this would be really bad if it did.

So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
in khugepaged.c are properly guarded by a pte_present() check.

Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
Applies against commit a61ca1246ad3 in mm-new.

v2 -> v3:
 - Collect Reviewed-by from Nico - thanks!
 - Add a VM_WARN_ON_ONCE() for unexpected PTEs (per David)
 - Introduce a pte_is_none_or_zero() helper to reduce duplication
   (per David and Lorenzo)
 - https://lore.kernel.org/linux-mm/20251017093847.36436-1-lance.yang@linux.dev/

v1 -> v2:
 - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
 - Reduce a level of indentation (per Dev)
 - https://lore.kernel.org/linux-mm/20251016033643.10848-1-lance.yang@linux.dev/

 mm/khugepaged.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d635d821f611..6f2ae2238b5b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -337,6 +337,13 @@ struct attribute_group khugepaged_attr_group = {
 };
 #endif /* CONFIG_SYSFS */
 
+static bool pte_none_or_zero(pte_t pte)
+{
+	if (pte_none(pte))
+		return true;
+	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
+}
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     vm_flags_t *vm_flags, int advice)
 {
@@ -518,6 +525,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 
 		if (pte_none(pteval))
 			continue;
+		VM_WARN_ON_ONCE(!pte_present(pteval));
 		pfn = pte_pfn(pteval);
 		if (is_zero_pfn(pfn))
 			continue;
@@ -548,8 +556,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || (pte_present(pteval) &&
-				is_zero_pfn(pte_pfn(pteval)))) {
+		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
@@ -690,17 +697,17 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none_or_zero(pteval)) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
-			if (is_zero_pfn(pte_pfn(pteval))) {
-				/*
-				 * ptl mostly unnecessary.
-				 */
-				spin_lock(ptl);
-				ptep_clear(vma->vm_mm, address, _pte);
-				spin_unlock(ptl);
-				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
-			}
+			if (pte_none(pteval))
+				continue;
+			/*
+			 * ptl mostly unnecessary.
+			 */
+			spin_lock(ptl);
+			ptep_clear(vma->vm_mm, address, _pte);
+			spin_unlock(ptl);
+			ksm_might_unmap_zero_page(vma->vm_mm, pteval);
 		} else {
 			struct page *src_page = pte_page(pteval);
 
@@ -794,7 +801,7 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		unsigned long src_addr = address + i * PAGE_SIZE;
 		struct page *src_page;
 
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none_or_zero(pteval)) {
 			clear_user_highpage(page, src_addr);
 			continue;
 		}
@@ -1294,7 +1301,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				goto out_unmap;
 			}
 		}
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
-- 
2.49.0


