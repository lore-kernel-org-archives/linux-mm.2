Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0D2C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065A48E0043; Thu, 24 Jul 2025 01:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C818E0002; Thu, 24 Jul 2025 01:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB758E0043; Thu, 24 Jul 2025 01:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D61E78E0002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:23:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78E2457D13
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:13 +0000 (UTC)
X-FDA: 83698014666.13.822392F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 92E0E140005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753334592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=N8agqGLKAUCI4WVTg3+5S7NNwjBCt6N0AQJoECkFMKc=;
	b=ysBxULoBygNycofYDNQg4ee5quH+VILmDj8bCLy5w7Hg9mYM3XJAiEJhu/HWkESccspW+o
	5LySqB6laVZ9tk3eLJBEvNimXx4uCZzfPYjFlhBPYR/g9z4uAcOwbu5Ax0CqVzLhKNZIdj
	g08Bg6fh7lw6jIHmddq2OZvJSjXJfq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753334592; a=rsa-sha256;
	cv=none;
	b=2lR9/Nax1gPWuu4+mwPO9936cUC3R5C3eAsRf2NUqMJU9BPAPjwHGcqH/yRGK/v+9roeuG
	Y2eYQii0OZbDoALBZt5pC/mLyvRrOQooStr7KpidgghBdX7P+Syjye5KwveuJMLQ1LbRo+
	G8pJX46QCcTYC9tIr/3tzLFKpdX43uM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E63C1A32;
	Wed, 23 Jul 2025 22:23:04 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E72D33F66E;
	Wed, 23 Jul 2025 22:23:06 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v4 0/3] Optimizations for khugepaged
Date: Thu, 24 Jul 2025 10:52:58 +0530
Message-Id: <20250724052301.23844-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pne5za41hzuhmykqffrtnay7f5jg63wg
X-Rspamd-Queue-Id: 92E0E140005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753334591-432802
X-HE-Meta: U2FsdGVkX1/JC/az+1WamYxWCs3jlsoeD3AlQzx5eoJmoOfxKJMvtjngFECbGs9xy/G1pMFQHiH8LUELVmI9szG5FEU0+z4DLK6hcv9e04pU/qdnoAiZBNNJ/OnHNUge5Lw/3oKUZTw6WDVMujkSTfgC27g08Nwt9xpzoAcaus2astRsl+0qLgIRWB2vRCOSHDY1O9b44wvGe1gq49xj7WoE8XuLw+DmxEoabJcwZVUCmDFPLUB/YbT+T6axv1D3K+zH8wxhd+yhuYfbyCXhlRHycPKavpdCZVszNso53AvMdmcALB5hCrZvBJFu97BFKxtw35V2WEy0WREp/r/bi4HZOFKoZUo2Tuj/TI+IBXzHR1nAyxwMpgQkp+N9CVj/+uC+hQqI1iK63tHvUi0m9H9qH1727qO7JpXDSvVvZ4R1GBozs331f5ScUryB+FGBj6VN6dBim1FRFfp5fVKFDsRZ5WSv0CTwITwJh+PNtT57Rp5KOHN2XwvgtUyiv6Vwonego9zPuO3SslWhd1bLhEcOGOfKuiT9UkQXLmr/nrSdhQF3MvkqQ181602yIx9CDaj3r/MzxZN8VPZ5VVtrk3kNzmDQfiGio7GXa3qeiy+1LR3zTZYgn4DxlkL7f0u5PjAxgvvF54Edh0f62oFt/r6hFTFBNhR7BPuiSfP7DTXTmLI8A2O4zQogJttqQe0TqhwlbT1ZzIe1nd/WHDyjiafM5KUJ2DdGH4wrTp0CUQtdRFtGoKymCqjKyKyOIdgDucwWCLr1HZBNcwEKHQA2pCFf4y/8D+uVGkI0ApfGeYeqCOSy1g2q6edX8ACnQLNBO6kzAR0eo0kKfyPwCDLyw02mkx2z2WLDItYKqJs0WPUHliVktY96vOnnuHx0iSHO5hPv7o9yTWpF2sf4ICPb+s0YDCiNJ+RorNQe9KQGFOJTWUuh5pMXRHpBbW8v5852he9y3BSV819Qi0tlJWX
 Ut58mrpl
 ZChMa3dRqL+UMDIsoTN/XiZrU7RVEM15HzX/ATas8BQv4VER5LmYV0Ar6b0QczmUggkfKVFYZX9jlUYhnQOgsJQEoi71URJU9T3XK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the underlying folio mapped by the ptes is large, we can process those
ptes in a batch using folio_pte_batch().

For arm64 specifically, this results in a 16x reduction in the number of
ptep_get() calls, since on a contig block, ptep_get() on arm64 will iterate
through all 16 entries to collect a/d bits. Next, ptep_clear() will cause
a TLBI for every contig block in the range via contpte_try_unfold().
Instead, use clear_ptes() to only do the TLBI at the first and last
contig block of the range.

For split folios, there will be no pte batching; the batch size returned
by folio_pte_batch() will be 1. For pagetable split folios, the ptes will
still point to the same large folio; for arm64, this results in the
optimization described above, and for other arches, a minor improvement
is expected due to a reduction in the number of function calls and
batching atomic operations.

---
Rebased on today's mm-new - the v3 of this patchset was already in, so
I reverted those commits and then rebased on top of that.
mm-selftests pass.

v3->v4:
 - Use unsigned int for nr_ptes and max_nr_ptes (David)
 - Define the functions in patch 1 as inline functions with kernel docs
   instead of macros (akpm)


v2->v3:
 - Drop patch 3 (was merged separately)
 - Add patch 1 (David)
 - Coding style change, drop mapped_folio (Lorenzo)

v1->v2:
 - Use for loop instead of do-while loop (Lorenzo)
 - Remove folio_test_large check since the subpage-check condition
   will imply that (Baolin)
 - Combine patch 1 and 2 into this series, add new patch 3

David Hildenbrand (1):
  mm: add get_and_clear_ptes() and clear_ptes()

Dev Jain (2):
  khugepaged: Optimize __collapse_huge_page_copy_succeeded() by PTE
    batching
  khugepaged: Optimize collapse_pte_mapped_thp() by PTE batching

 arch/arm64/mm/mmu.c     |  2 +-
 include/linux/pgtable.h | 45 ++++++++++++++++++++++++++++++++
 mm/khugepaged.c         | 58 +++++++++++++++++++++++++++--------------
 mm/mremap.c             |  2 +-
 mm/rmap.c               |  2 +-
 5 files changed, 87 insertions(+), 22 deletions(-)

-- 
2.30.2


