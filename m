Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7149ACCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 03:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69378E0008; Wed, 15 Oct 2025 23:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40D98E0002; Wed, 15 Oct 2025 23:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9572F8E0008; Wed, 15 Oct 2025 23:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 816398E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:37:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57843139581
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:37:01 +0000 (UTC)
X-FDA: 84002566242.12.6702257
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 96B4740013
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:36:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760585819; a=rsa-sha256;
	cv=none;
	b=ZwQFwFTzMbaV6A4dut9tAa3w9EdfJXUaevt3uJU+ZZorDf20EokHylhLzTskByZ1kagUUm
	Rir9H8v/z02cSRTXGftCO6yhPjqDq/iB78/SyKmJNUtx50plNs0WQzjZpsDWz+wxrbj6h9
	Dc4TMDatUskCRZAzkgYoVmvhOS9QaiM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760585819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=B5oFZDwaOYLTe1RAiDe6mUSFshh5BB1k1bsgtSytVrM=;
	b=Pz8jU5dz6t3fe0aEWP4/5C8dkS/IZH68hPK4mXNTzWYlkg46aqIhKuADjloVkfUNg/VOxI
	/TX/oQvmJl51Xz4kyWgs5n+3wDPzBKfu4nKNYasznb68nndi4TIF+T6AAQiOXmk+AIhDte
	Ep/iVz8xCdbCQpflBafwWpvqpWURFUw=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27d3540a43fso2746745ad.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760585818; x=1761190618;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B5oFZDwaOYLTe1RAiDe6mUSFshh5BB1k1bsgtSytVrM=;
        b=vUoaCWmbliCzreEEm86bfHCK5Nv8//5/BhoVXEIPX+aF5131H4KHK7Xd8rTL/wJ7kL
         u25nYUrRGm7MCe6rs+d81qxvRDx0sFzMr/ly3SbPMeFuTHnD0ic74ysQQDKvanFLP6e7
         3aHMIKSxlNAFSf1I1RjbOZhmITn9oWKUAnHDWf33Zw8Q4GXITH4yfxCRasR5CzX6kRIi
         5kVmRi9ImxMg+rOwQ/cfPjzwKeSCtBUVzGunG0/K9Xh4ZIe8ex4rN0QGtiZ94laXY2MI
         G1KC2lqd+bV4fhH41L9c90K+3slP1TTNznKy8fwBmSPiA5AMReeZIECqCL3MIhlOiSYZ
         gAGg==
X-Forwarded-Encrypted: i=1; AJvYcCU4Ukmj4dvDjMA/oh+D2PRlzKtCdsjy+Xo4wd83y0uo68HRof6lXr6giuvQcdNHD0aqDGibdxd6tQ==@kvack.org
X-Gm-Message-State: AOJu0YyFJTZi1FdvctQraGiv2wMXgHjyzqcv450ObfAyLe+twR/np8Qx
	IOeIJ7lyTt3R+kLPSVhvcwY+e4fyTYYzCBz5YlYN5P32BGjITi54W4up
X-Gm-Gg: ASbGnct6WBtVPoTGHSqG8WAxQycO4Yn3OJSrni7drvyEQVY9zfxXFmfVJn5NAlja87z
	4kHO4j1xiBOAxsAhco14D8fbvQWOhUvu4fwjZVjvQpXLIjBDs74FOsgPgfEvem46f4b4d0SRc9Z
	QEId/wFavGflLCdgdvNhKP6TvtbMmkE/tQqPMq1bTxSWplHymeIjg7cXosorhw0w5B4KSeknaFH
	JPwe6RQTm2bYPWGpxo3K5AkQXUzfpu3dO72jGrFa2GKkh3q9RAqu6ZqfdnlvHq3PH2Sc7zRYzlE
	uL421JZ6iECshL80O5QdW5pmdov7UH7TyG1C1OgHwDPkc2VMXkLmaKFG134Ajq3Ub9aTF8C+jLx
	mPvY6QYE6a6jSgNNFJkqv5YkeBWvG3c38bez6qwRNBZujISag1V3P0Xt+McpFu6wMSvxzw1/J+0
	Ln
X-Google-Smtp-Source: AGHT+IFZDX930KR2Gf7fpjticc9tlQwmiyKOIwcZqSUuInC2LLYLPXAKuT3KBNpFznqmqSEybdbRDA==
X-Received: by 2002:a17:903:11d1:b0:24a:a6c8:d6c4 with SMTP id d9443c01a7336-29027267a99mr413159445ad.26.1760585818466;
        Wed, 15 Oct 2025 20:36:58 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a11:3:200::1086])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930fd3csm12405415ad.12.2025.10.15.20.36.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 20:36:58 -0700 (PDT)
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
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with pte_present()
Date: Thu, 16 Oct 2025 11:36:43 +0800
Message-ID: <20251016033643.10848-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: faqeyuoeqwo4i36xfo1j1o4mosjb5srs
X-Rspamd-Queue-Id: 96B4740013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760585819-548334
X-HE-Meta: U2FsdGVkX18H/rtchzJUCRvL9ttwBT6KryaX9jjhYouruOWD0ripCysVmzLVmhI8O9lfc03FTNoRv4UGvQAPbh8Hr4Bjn46YD3rD4IND0NnceTScolnQS2tkGbqgiJGziAp8LQ5NkBT8Om2dscy3SrJz3IbbUDw5NGs3KWuiDvCa3ZC6mkZn+9sqS5ESgioEvVgYJrmkxZztjXZxZ15d5bSAKu6CDtaC+pvZgIHY8BqVQvB2OBHWtGv81CiiZ+/OSKtTIM/K7xjwPYYcDAeuNWnSnIDYgGGUesbb/HE/G7BmRzNNHh41G+cP4ETz84QYjzZoWVYXSnVzmAZ2l7Y8X/ksHldDsA9/5OeJxTOdPES4sysmjNDuQ8ApSed3i9MrL+BbTcLsepJw0AismrZ/0zThy6SdkWYHW860/G24ojqVvHGwaPRWkg+8JvGuj4nONoDP7ESDXi2cq/Llf7TUIofOel97GgtUFxjF+uEY9aoGX4L0qU4hHG4T3BISJ5CZKpOx0lRoWOGP2ovhCYEsj2tLq3cRje450It+O2pKrB0pL7nUhvyibr2AMd29I/T1Xk2ImSaJs6p/TQ6I/i4INC7tqqnDk7u52LC2Z8cbw2bmjHnyAL5pnITo9eREigpM5GNh4F9JCWEeCAZqlBsg0YHmM3yWdfv2MvIkWoK4uJqOIspez49hZdDoPgcTk2DrpkdR7up/Q7Anrz0X9TcZb6gIpYjzanrOtYZaq1cGkp+oik0a/BxGgdhYT2P37p4yT+IZiXXTyeYOHcajPbIbJzEoDR1qCsYTEfha5UHXyf4pCGZqqEMUdQcO2kLB0JuNqMrsrbdWO+eoX5mJJt9Gt5SRbLC0H2KksdXiqZ3Pq/TLcNaMY+e50LFcHkzh5GwjhPr2P3z+m5LxlOj4YLuDodp027YIbhGRiWhg8/+YAJqML4wr4wG9vwO+c7ExG9FJCpq81KWX/7KDSRgorA0
 p/NOVx/J
 doqBu0UZ/q4+Cm6AJ1G/CTNwTnjYrOyn4/jMjDmK2xVbsUroOf7pqsLtLs9+bNbmK9l1moRaFpBLs6wR9lf9M1r4p9I0x++EGY+vVNdmnNwQ399Hhxal/5nADdh2tUN6nJlDAliVYBWZ6axN/n16cL3GbfNKAAn4iaTDEoEBElhHFon0kVzbxkmN3EX5QwtWyODVyGcR9Rdp1jdmwBZSwNkXqPqFht99hynn8WxUbs1KUt/bBeG5IvOCRQQDVxVOsKZ+EikwDIIOTetiGSRB61pQ7hFSNVssixlljep4FMD2TP90NcKUz6Ms9l3L+vwUnk2qcmArhu7A9KA4XpWJumNMWrwlKieSJ2F+nVGgB+mGOzy66nyXlZD+RIuOxzwquf2PuA2fpWES4XcJf3Yz5FVq0fjq0S1WZqZ/JOfE8NquSwIf8OzNDJnUExgNgElCJr2hO3ckn5MGeQpu+SOPPcVJJxT0q39MRMVIAQ/ve4BgESkSjsPMCHQ5WiDPkuITvb4iOI89S3ba6fLY=
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
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d635d821f611..0341c3d13e9e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 		pte_t pteval = ptep_get(_pte);
 		unsigned long pfn;
 
-		if (pte_none(pteval))
+		if (!pte_present(pteval))
 			continue;
 		pfn = pte_pfn(pteval);
 		if (is_zero_pfn(pfn))
@@ -690,9 +690,10 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
-			if (is_zero_pfn(pte_pfn(pteval))) {
+			if (!pte_none(pteval)) {
 				/*
 				 * ptl mostly unnecessary.
 				 */
@@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		unsigned long src_addr = address + i * PAGE_SIZE;
 		struct page *src_page;
 
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			clear_user_highpage(page, src_addr);
 			continue;
 		}
@@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				goto out_unmap;
 			}
 		}
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
-- 
2.49.0


