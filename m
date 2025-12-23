Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59DB8E6FE30
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 20:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73416B0089; Tue, 23 Dec 2025 15:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54AD6B008A; Tue, 23 Dec 2025 15:51:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974006B008C; Tue, 23 Dec 2025 15:51:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86D266B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:51:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 320E560631
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:51:04 +0000 (UTC)
X-FDA: 84251930448.01.3AFADB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 969EF4000D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:51:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PjfvPDRI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766523062; a=rsa-sha256;
	cv=none;
	b=yjphIHwPtFXu89Yjt3hlGwP2pkKCtJ1YxAK3dlV2OK09Xv1p15TySkRIgO+7iySDQoeekw
	HAryAd5fgi3j62ekl1wqIa2n+TFDiZ182ZcwJvudSruCDMqqP4/qWvFTc85LTb5J81hV3Y
	kOHr8Bne94PuZAHa0Wer0ASfq9U87+E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PjfvPDRI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766523062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AcVn75gfO+YB2QS2FMEcO1WI3ZaIE7NZoPPieahIDI=;
	b=b0jh1QuyW/P7GOW2xFb0d0xiD1XHt1tKdnIMHPAgJXEW+klWkCiMWjWO+Zi352ozJABd6K
	a1XQ1aucHaJ8a6CSFPoAFmH8W53WdogN8lRJaOGMWW7BG0HtMt68klp9DdmC6+MJPuqKES
	F78jP91DpCh5Z+ZZt1CZHaAylJdnALY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 014EB60141;
	Tue, 23 Dec 2025 20:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42660C19421;
	Tue, 23 Dec 2025 20:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766523061;
	bh=33B1NjB8q+KbqoS4RdUZuJYWp5unOxxMAqt5/OJnfDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjfvPDRImiMgFeQe9p3bFipqiUqrAjW6sutXjuz2zNhrfPEpI5TLkODucQ88WaKE8
	 bHVuN6eJjC/SXxEz9tBF7sqU+wYeQ+RjtbUZu5Odu1D6EqO8FUjA2O4FSZmGLLLxWV
	 1B4/uEgFaY30VYa1rjS7BcMJY0JPDBpuGudUL9TlBOUvTTYGZlZ7LMlVzwgBVcbRC4
	 RAqk/7kaZLjdX6QsCOOKeyDb2e8osl185MxFCMAnbcteS9oX/8ZgUIxlam3VC7Qr6H
	 UHEFvyYOa3pgCAeeYtCvOiCE/xaL9QL1yImbm4wVkPNw+/m/FkW7g64RyUCTDqQnWR
	 5ylRmIKoqAXNA==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH v3 1/3] mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Tue, 23 Dec 2025 21:50:44 +0100
Message-ID: <20251223205046.565162-2-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223205046.565162-1-david@kernel.org>
References: <20251223205046.565162-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 969EF4000D
X-Rspamd-Server: rspam03
X-Stat-Signature: u8n3h5rikn5uygyykzgtbgdfb3st9z7y
X-Rspam-User: 
X-HE-Tag: 1766523062-879367
X-HE-Meta: U2FsdGVkX193/EKRHz3zd2K88W1uXGG6JmMQ0MHA0lRTfFkErSCUrxqVd5siWx3ORYD30JFbw8u7iHN9BtQpBiPv6x0PiZafxo91s/4hsc3KJJB0eeE+blzZJKTABH8AdLmB9tAxD+TrdhLgFXSsPbnv4Cj8VIc14EIYn8JElDXp92/6gFKZpuEmTtns5XxOaJYnTLWgOnj+dQSW+hYNXKfM5LpmUoMYLcoPuy+uSWF1TIKLiyE45kd0sKWJYzMg9E3rxYXXIpXW4xhgpbcDe8nFintmDnhl7rsoNvwLbqoX0lkrnGf4LK3iWqEcDKyHWx50bD9OzthsxicxNvTqtuxErIiZdWB7YX8So6UIu9sZQb3/u8jAa/qIf2eVkBrOKcxNwaQnJWEEPCz6ClfUIRsAlUjnhIebsPgMm6PoR8KYQEq7UgDFnrhanriTFezun7pLzYE9w+oaYffPgkQ0kbIMxIEOazoE8AXE1pKQ9ZMqCKFiFvGKXg1OEpA1ofY9mvy+jpi/tw2MQVbpHUBMUrz44D52slb5arBZ+GghktXBhyMUb5TVsFYVYC1kskqqK1q/1jI0XY7PA9SdGj5iqiA+R8KuuChm2CGkDC+G3a27L5DJR4Y5/AdsQtw5BUet///fltUlE2hTfiR8AuR36PRv+JniOKP7VQrrdfV2PjzvGRUIbrvB5HEVbjrjHanfNSthv9MXmfDhbF0CTYbP5N+ZyLeo/ACOVldK8SGqj2q+Of+5bcBIo+YZVE8J9rWazqVGi8hgYsI2K8xvJTLjWrspjx2Ippf68TiSfVHB4ovoGfRIaeFzx+M27hvi8ipncrLp61gt9zdLPXtUQ9wQZXCIcgMqmaPULhDZuMJ52V+0ykwfPtuGuKMZFwtrw6eVV2iqMIdVe9k7020uTcSy3P0TrkZCWQ8/OBzO+Q2KA4W9oMufB91aDYSpo+uTOZ+7AC3+CvsY1ysoSjwYE5P
 +2+KXTlm
 yFf7dzLJfa9Hkr/X7LBR3YPo19rFP9/jkJaHejT5Ny1UIjbhtocXZaVaD9xmCis6AIRw+QN72MyCiUq0uGcLIGGHL0x1X4Rsks/jkSYFX4UXhCwd2uF61D3sBrwO2rVwJTzEeyqdsUtvi5VDct3F7wOrKgUvEeHIWJ6Eu0sAm5NPbgpsyfQy76wdtDF1415eS46Ff4WXEP3+yeivUlqnUW8NlKVY4tgdqKYwDIgPY+QLAnqOSoX6kExRvXLXanxPw36hKcM9diVPFwzKkxPwLQuiy8TucO5DU8GDdJ4+rC1U7t2ZK9o/NzZTSpaTfqc3iIBsSTGUCr1ijqkjy0MM7GGT7wamnZTmz6Y1WecY4+hgtZxOBKnRXc/GZMETcbpY+J+Rt4d6bt3NsfAoo+YbPYUkujQdBz7NCCMgfewJdwjiwEPXAssXb4mxCjZErnjlC7TGsWuZqucxaexLRPkLtMlBXMq+6q7z86QrO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since we stopped using the page count to detect shared PMD
page tables, these comments are outdated.

The only reason we have to flush the TLB early is because once we drop
the i_mmap_rwsem, the previously shared page table could get freed (to
then get reallocated and used for other purpose). So we really have to
flush the TLB before that could happen.

So let's simplify the comments a bit.

The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
correctly after huge_pmd_unshare") was confusing: sure it is recorded
in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
anything. So let's drop that comment while at it as well.

We'll centralize these comments in a single helper as we rework the code
next.

Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/hugetlb.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5d..3c77cdef12a32 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	tlb_end_vma(tlb, vma);
 
 	/*
-	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
-	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last reference would not be dropped. But we must
-	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
-	 * dropped and the last reference to the shared PMDs page might be
-	 * dropped as well.
-	 *
-	 * In theory we could defer the freeing of the PMD pages as well, but
-	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
-	 * detect sharing, so we cannot defer the release of the page either.
-	 * Instead, do flush now.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (force_flush)
 		tlb_flush_mmu_tlbonly(tlb);
@@ -6536,11 +6529,10 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 		cond_resched();
 	}
 	/*
-	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
-	 * may have cleared our pud entry and done put_page on the page table:
-	 * once we release i_mmap_rwsem, another task can do the final put_page
-	 * and that page table be reused and filled with junk.  If we actually
-	 * did unshare a page of pmds, flush the range corresponding to the pud.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (shared_pmd)
 		flush_hugetlb_tlb_range(vma, range.start, range.end);
-- 
2.52.0


