Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22444CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6108E000E; Mon,  8 Sep 2025 03:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7972C8E0001; Mon,  8 Sep 2025 03:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4538E000E; Mon,  8 Sep 2025 03:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 58D128E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:51:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F403311B1AE
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:51:17 +0000 (UTC)
X-FDA: 83865312594.03.BAF793C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C05AA000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:51:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317876; a=rsa-sha256;
	cv=none;
	b=TDgsFPArxqeis9METF3T+HVZx64EjkjZklgL86Ytgvg6Qq8HrQLT2H9r7gKqPbbctDYsHf
	QwC5uZVWdQ2ZzIVwYOmahA6uxBQd1k9skQTa3Fsc1kjcWeTHT+38mpqLMeNlPqkbRASdrm
	fUbJ4o0WG2dSivsUQ9BibPsAL39vyzo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C9jIjBFcc7Huts7AxxCJhUqCPCbvoR5OBOUZEecIpsA=;
	b=gpyvPnEWP8EuSkHd8qYl4vuBMYHsgKUM7yqH7ShhgJfaNmkkpaW5o+QqxctaBegr0TYv+2
	WOVo74+QC+boRhvW9rFtbI5GU1Ic+DxNhR/X/nD8VRNxGM0IP+QtmBtCjeXkm2Hnh5URqq
	7VKvdHZK1d8RvLcbm2bBdmHvrqD/Mak=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DC7E169C;
	Mon,  8 Sep 2025 00:51:07 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 759E33F63F;
	Mon,  8 Sep 2025 00:51:11 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	kas@kernel.org,
	willy@infradead.org,
	hughd@google.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 1/2] mm: Enable khugepaged anonymous collapse on non-writable regions
Date: Mon,  8 Sep 2025 13:20:27 +0530
Message-Id: <20250908075028.38431-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250908075028.38431-1-dev.jain@arm.com>
References: <20250908075028.38431-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C05AA000C
X-Stat-Signature: 3kd8dmnpegg6ywsbwmqrq9rk5uk9hori
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757317876-878974
X-HE-Meta: U2FsdGVkX190XKP9xpuQA5e2X2EvHUgRuN88ll//hw/F45QX+C48sAhxyljiUzv8BeQJmhef0mC16PbEPowSm1FtH/26+ofG841LVoMAV+fonTuAu+FuOFgfCvsQnTs9spu7alYvwGg9NeX0ojI6lIgxy0pyndL+L3XZOr1IbcVZeBBscjJrKC+YC7DguwfWVquB7LC5AuAD/JdkcRC94wkxe8Zk28vf2Po9CAsQnQTgRmo4cX4JvfU2WVwY6dBNyJYSmd07ar6FwSbfIMGeddJXTBnWjJ18EMmJ1IrWQ70lANRYnXUbJyYLkf9ut/cpkPYXte4DBUp3GloTcYma9TwLEKKMezYge/TslFC0RjCFbZEOjE/Drx0bXhaS+EgfjqqH14Lu4SS9/AXgOr+E/IXwUsiE9rY6AaY/w3StOiU/muAubBs+2ilFFsby46ZUdcTwE4kJsPhFqXyqdxjE270/OkU6Ry9hnUT4QlBXTQy3NFQRLhioodgOE9KYxnbZlwXnIn0NaiebGbvNteiFMNt2C/KmYu9c1R7pnsMtTuiS5GN8H5RsEzpB4v8VNTkn35KV1RWxus85uvRi50MGI0s70JFy6ghFstfDL2ir8YAAcVCuOzi2b4d8qyw8qd34tzCi9dkto4hIYAQ1M07y3GmbXfyWoJYmUIaV7OWL8egMAeZxYe7HR9MX8STV2q42CgpdOoD88PJsvmp/aCsu8zEYH1B7/wPhgsnpgh+B0O/TTgXA4s0IWous79jJpdoD5eygP2rTOZ7c0QWnynSD2O5MS9H2WwqnyEmlcIB97GxJ/DB+wsi5zBt6nwULnlrV4SSZe0d7nLpNmz3cpPFfPekBMPP1ft4GYF9bplro2+8tYz/zP8guzAEPDLEjuNoIloLNvKKWloG1apFDkaucCZWiaUuq1wYF64WxzW+l2hzy8GE4wyhca2RsWN6HQ3SEijsZ5rRDLgE3sO15hyZ
 Fg6Sv+ft
 9PgzVie8S7nvNQU5ahTGFZkYBzLqhtsd0C6wPUWU1B8RHQmAtdH4zFlBdhynCCJyoWkr40oOCCl0fVIvc8casxsIKCAkERihTd/K/0qhg2TGry7Er0ARbHRxiggMqxs/0cQjY2AznhJhSnHnG7NkMlZJcahwX0wHkfA/jp0GS6VJG3E/2sJi8wzW7oFn1lCuBsrFfkL7atD+TuOXzv7cI3B2DrJFcqh9Brqcb7eh7WKrHqrLW5mYiyYFCFaY9Fmodt5hmW07RTaSUnxEWnpdOWHl/JtUe2NEp5DL2l7yVPgXfnqOUJt110KSsNdY7RKG0hY3B9UojbaFNFHO8kjic45BcZPpnhLK5megAQQj1Dn0Gy4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently khugepaged does not collapse an anonymous region which does not
have a single writable pte. This is wasteful since a region mapped with
non-writable ptes, for example, non-writable VMAs mapped by the
application, won't benefit from THP collapse.

An additional consequence of this constraint is that MADV_COLLAPSE does not
perform a collapse on a non-writable VMA, and this restriction is nowhere
to be found on the manpage - the restriction itself sounds wrong to me
since the user knows the protection of the memory it has mapped, so
collapsing read-only memory via madvise() should be a choice of the
user which shouldn't be overridden by the kernel.

Therefore, remove this restriction by not honouring SCAN_PAGE_RO.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com> 
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/khugepaged.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4ec324a4c1fe..a0f1df2a7ae6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			writable = true;
 	}
 
-	if (unlikely(!writable)) {
-		result = SCAN_PAGE_RO;
-	} else if (unlikely(cc->is_khugepaged && !referenced)) {
+	if (unlikely(cc->is_khugepaged && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		     mmu_notifier_test_young(vma->vm_mm, _address)))
 			referenced++;
 	}
-	if (!writable) {
-		result = SCAN_PAGE_RO;
-	} else if (cc->is_khugepaged &&
+	if (cc->is_khugepaged &&
 		   (!referenced ||
 		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
@@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		case SCAN_PMD_NULL:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
-		case SCAN_PAGE_RO:
 		case SCAN_LACK_REFERENCED_PAGE:
 		case SCAN_PAGE_NULL:
 		case SCAN_PAGE_COUNT:
-- 
2.30.2


