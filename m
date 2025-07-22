Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0748C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31BF08E0007; Tue, 22 Jul 2025 11:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3D58E0001; Tue, 22 Jul 2025 11:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209E08E0007; Tue, 22 Jul 2025 11:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF688E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:06:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBAA111279A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:06:18 +0000 (UTC)
X-FDA: 83692226436.02.61E9B37
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE941C0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:06:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196777; a=rsa-sha256;
	cv=none;
	b=DiaFHCLRuIeJLlqlbyrOZQEjm4t5OZiYJfaM0No1WAxIXOzEbvAmbgXG35Ud2KBdoInKwx
	T4SP8nCInodybcGUvmfZPQ8xTP7a99Uk1BrD69bg0nygYfJyazAFIRt4AjyDzFIi/K2tMb
	BpHlCKDpkwEJiXcWpX64Eyc9yqi+4ww=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=RmHiMfN+pDKDi6HO5IEejdcIM5lmTqaSOxa5wAcwQjk=;
	b=UP+oN0n7DPlr/TGfeXJDUUMHmho8WU+sdbrBNUeSa8tn9gQpigGfvB+sqfBVDmBrPsfZL7
	GPxLH6YqUfwU845ZT6PKc6FvqnYWyDBZfS5LarIUHI9TmLgurq6UZvF6v2YM6Z5xq57Ale
	nhcNi5oef8soTaM0FfAEsd5debrajOk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1046E152B;
	Tue, 22 Jul 2025 08:06:10 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.163.92.223])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7B79E3F6A8;
	Tue, 22 Jul 2025 08:06:11 -0700 (PDT)
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
Subject: [PATCH v3 0/3] Optimizations for khugepaged
Date: Tue, 22 Jul 2025 20:35:56 +0530
Message-Id: <20250722150559.96465-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CE941C0006
X-Stat-Signature: 1h7sfo3taba1u1jxrhye691pe7idskci
X-HE-Tag: 1753196776-760996
X-HE-Meta: U2FsdGVkX1/21kPBP5fxAc92xyWjmE37i2uWlXKZwae32zGNSd9QSTSQxSkaLFoRdAJZRTf0+sdZdNtdDTDcgV6R4D/HFSdG7KU+35rLmRN9WbGGhSmWMVCcTrsEupsHV8EvFZTinpYvN1+eJ7bVRB2QSgznLG5H7Ql5TwkmnoJrJ1IT9+ClYdSmlSct97/gHxGikUsrackVB1XPWZY3XXIhf2nTVKhieNx1KpJFz6dYBnNZ2zMghdFYSBmY0QM88wT9KckffPzmyKXIBMvs7YL8x8IEgjxQpS7TeEWhsNPtCHbcrjzzjj8aDxUbC3cozr3CzWV869G9k7ijXqrkhQV0YWOJDJszJWtcbHeUB4P0PIoPGFM7mgQ9dE5WxVmoUdJVQswn4AgFfTHZZV6q09EgcKVwlxmORRFhFkxO83WCjfC3xHr6ygDqIGpy7VxWpzqSijlDauRin0oigKdzNoNX+y3yhTVIe0KDBfPtNGz8vsSMhMxfzEXjKYjOuR4KbSdo0fGmEGGFQYPkr0cFwb8E5Dv4GFSDS3ePD0ruaCjFScsTnEj/dQXbow0cwLI/lxk3O5sStVJqJH+/OHb5Jydr6koDsbNvyz89ffhY9M5t3kFLEvAUZKQk5G1/4MKDBIGBnEj1HcjovG0nmcTPNrl7MTCIExLnN2KJCtgam/e/wYHoLxolzYMYSjLtq4w0DrdyZqAXHdqVe0hXs7AT8vRri5/5iwCNM4jU7lB/Zt8a8v+8OnzeZv2SS80DPquTxWp12rd+eUA7xefxQmdlB7MERX6oExflYi4SUZEKdP/VMqiaxmFk+EnRER4QuPXujQxw1IiuEWywc6yqy1gms8gjS/2IFY7pRKTj/qPpn+wttm6zIo9/VyNfBJ/OXRSboVfhL12OASyXGKMgxckNd9w5v88fmqmIXRBXdd2XyeziQBBImB0cM2DLoklb8KpJhs7Y2fKgT5P5rqWJzaf
 mhHKLTGv
 JThCkNBM+YU+b6BsHctXRD3GHqf+Zyq4t+6RXLatMV6DDH0+6yuHTvpdiK3hfmtDmn4Ba+q1SqRzWk78uGjGsTcKLigQkTKTWUYJP
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
Rebased on today's mm-new.

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
 include/linux/pgtable.h |  6 +++++
 mm/khugepaged.c         | 57 +++++++++++++++++++++++++++--------------
 mm/mremap.c             |  2 +-
 mm/rmap.c               |  2 +-
 5 files changed, 47 insertions(+), 22 deletions(-)

-- 
2.30.2


