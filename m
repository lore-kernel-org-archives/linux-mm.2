Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F880CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F20C6B00C3; Thu, 25 Jun 2026 03:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA2E6B00C4; Thu, 25 Jun 2026 03:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24AA6B00C5; Thu, 25 Jun 2026 03:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C869E6B00C3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:00:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 669B6A04F4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:00:03 +0000 (UTC)
X-FDA: 84917535486.04.6AC2B98
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 77E3C180002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:00:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="XuxD/Ybc";
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782370801;
	b=U2+oOBZeV2oXJoAOqjT2DwLnXaZe0NBzSBjbqsdEUCMz/EJu1JIqwPVKP5ocXQGoZ2YFIv
	KVlMI7k1S+1j1g4k4HsXBs/xmx0CtpXlAg8z/3Rkb6rh8SJtqYRhNWTpDETHqrO3yEshzQ
	493HhgcodesgaJGoHsMSnUiqKufyhHI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782370801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFloAXVixjfN6FtTJzKT/rOsFs+KiVB9C3gndarmyb4=;
	b=KSD8rcSGMT6BSVOF3jcOICWbJFNUXDjab3bUproT8NjhGvSAR6lTU2NnR0gmYdMKtLRqJ9
	mHSKxAqPP4A733xUYlWD5tgyi47AnqzhQWTtvnRN6QY4QbTYsL41AZdXGkl6q2zJFqXGQt
	u5gy8t9QSmIICKofgVVWHmK+GDIw4/0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="XuxD/Ybc";
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9CFB2BCE;
	Wed, 24 Jun 2026 23:59:55 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31CDA3F836;
	Wed, 24 Jun 2026 23:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782370800; bh=u4jABPlZSzfgRRcXDTKbxucxNVmhlGdcQNnwT4HDB88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XuxD/YbcCBHLeD5/+EryCgdigQZJqPQxElywZZ0Ilifij5vaKJr4RZqj0Lvru/pd1
	 Rkf/Sw7ploOIVlaucD7ISq1Z3UyP+NgM0R3KKQw28OG8hEDpg3fzF5EaCiet5MFZJr
	 qzRT5ERDLz3i4MXs8olfw97jn7GefhMLUGYAieCg=
Message-ID: <2fd3688b-b4d0-4a2f-8d49-4d4b9c512c66@arm.com>
Date: Thu, 25 Jun 2026 12:29:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: kernel test robot <lkp@intel.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260625042853.2752898-1-dev.jain@arm.com>
 <202606251341.jfIr1D7m-lkp@intel.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <202606251341.jfIr1D7m-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: oiep5m467tzkpuzhbmcf7s661dtsansg
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77E3C180002
X-HE-Tag: 1782370801-942465
X-HE-Meta: U2FsdGVkX1/JgFjWqvlJiH9Lusw7vPfhtRCqcLuMS3HePf1FT87ui6GjQ8Hswpcv2xzAnjnXB5z2DVZYNWLToHK+FVWvbiQ/NFZvQF8VHKuRxbTePO+5ADiBffFw+eLXm2F2i7rBtlrI9UNYt6xwywYMfI/2nCzl77ijAx5Ymo+vGhFjX8irgfJQXBmEDGv69DZghyaGaRELF67kGmxn7KhzRym6GFiNtVN1ntI1unj0qPrRtHHJ1ddEbqQXew81bmt3UHGNikPJwuoEKJw/mmn0RJC7XBp8LDaDCRpoEXawmMvqsAoXWgjvtuwQ7+jZbVtnOrQ1ld6RMSK4f71DhNqVU7totHHZPTZiSmFYdxk6F91m+iD8qPxarnLHafA1mvVcAK+9PfGZ5rE5PDnbf3700Y54nQ3goSNFLUBcar5BS80lLfNF+tatyJGj2w1gzE0JwHW1MP41UlrTVDckFCp8xQU9eAqr/dwft+h9u/PcRBE2yd8ZJjst4TXtsCocY2qsvAbEXZe52HyADwhsrIam4z9u+tE0H4lcYWHOFDwirz3OftzxJNcuj9lPHJv4n5x3tKZUp136F8av4Oo5q2R307Xyy4akJVWzSdOBqzcwn+Wb83LqhFs5TyRCm45iyBStX9QZzcLRedRuRNKBD19fJkXrcjbQFw/YKuZ0iti4GWy9PEWb+zj7ZWbunkGw/PfHdDjAIOncy/bJXERDwyJ8HjqfChD/8U0WT/CYaHrTyLgZimqEdiQqVu2l48zFgTAuLWJW1SXNKBZes9wt1vCRxXjsk0CnOs3YVYRdjwzpVRBSjq2TUr59886OeQRSj/2WoRdeeJ+vSxquoKnBkO6nA3SPRdEu06ka3ZV/WGxSrhGbwg9et1WyEw1cb2lwkSn/+NMCV6jK+IM7QeYspNrcDAbAxuIVkx+g4g/zhS3cslwiYykR7d0ArI/5A3mueq7qFiXfeIjR+y2S7xe
 /QaTMgpp
 2zrQOezaLG4/Qf4cC1spBxo0ShuphKuvjNPgFef24R6j/XDtAqpF0mt5XL7kXzdwaAZ2Vd6ss1ohnC9rz8KMLOjEYkoK1WuaF82aNopeNTxVR2uafNxCs8Dj2AiZuSrMxnC39dF8YQTI4aYeOp0SQVmhe0pNZp88gWNJw239WND547CPlQkuoQyJDrXC43pORojPBbdINpbkxudJzKkzYZAAqIPu/gh4GCe8EYfWgALEJcDP2n6pfe0KnzAyyHMZ5ONFmDzv1Z2ban4HFgC9aKUn9DgBqRNR9+F18m9Tx/30gz8WSlPGRXhj02+sSYy3Q9OoOw2IGOYkjjjLL9kmj6x94WSmKPfvM+ZLlRrOhQvthG55dvFYe3PmoyfFvN4Fz0D+kcIkVb/q4OBU8Z3sFVzF8WDzC7mfYnQdDdurmq+U/8fMrek404Vyq1XW7DrHHaRLkngn3rEYEalsJMg1hOXyYe40c3oUMq+vy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/06/26 11:15 am, kernel test robot wrote:
> Hi Dev,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Dev-Jain/mm-rmap-use-huge_ptep_get-in-try_to_unmap_one/20260625-123050
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260625042853.2752898-1-dev.jain%40arm.com
> patch subject: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
> config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20260625/202606251341.jfIr1D7m-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 6cc609bb250b21b47fc7d394b4019101e9983597)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260625/202606251341.jfIr1D7m-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606251341.jfIr1D7m-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> mm/rmap.c:2100:13: error: call to undeclared function 'huge_ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     2100 |                         pteval = huge_ptep_get(mm, address, pvmw.pte);
>          |                                  ^
>>> mm/rmap.c:2100:11: error: assigning to 'pte_t' from incompatible type 'int'
>     2100 |                         pteval = huge_ptep_get(mm, address, pvmw.pte);
>          |                                ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    2 errors generated.

Weird that I need a stub. This should do:

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e90..4661f88eee55b 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1261,6 +1261,16 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }

+static inline pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
+				  pte_t *ptep)
+{
+#ifdef CONFIG_MMU
+	return ptep_get(ptep);
+#else
+	return *ptep;
+#endif
+}
+
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9f..aa8a254efaecc 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);

-		/*
-		 * Handle PFN swap PTEs, such as device-exclusive ones, that
-		 * actually map pages.
-		 */
-		pteval = ptep_get(pvmw.pte);
+		address = pvmw.address;
+		if (folio_test_hugetlb(folio)) {
+			pteval = huge_ptep_get(mm, address, pvmw.pte);
+		} else {
+			/*
+			 * Handle PFN swap PTEs, such as device-exclusive ones,
+			 * that actually map pages.
+			 */
+			pteval = ptep_get(pvmw.pte);
+		}
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
@@ -2110,7 +2115,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}

 		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);

