Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A4FCC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FFE6B008A; Wed, 14 Oct 2026 11:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058996B008C; Wed, 14 Oct 2026 11:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB11A6B0098; Wed, 14 Oct 2026 11:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD6836B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:46:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62B59C0451
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:46:37 +0000 (UTC)
X-FDA: 85321659234.04.31F01EA
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf20.hostedemail.com (Postfix) with ESMTP id AA2CC1C000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:46:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=pyMcdMZQ;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf20.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vC0C3sp4wt6zauR/zTBNv+UfY1Rq7XzZhYx35u+Pg0=;
	b=SQdFKhdpuyAZfFPM3da3IrxQZEq5QxYMcyS0G5ndMCi2QILYjeoPGJee5jL9RDHJIIi9Tk
	tlrgPsKrRxqH4fjVcTmy6K2VgH4eMf7ixSrGXmtrl6RZLG3nESq6u2RBfPaqm2t666yzUG
	FqjE2Ly/Csz3kGWibGJnMRdhdWHv0rc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=pyMcdMZQ;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf20.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992795;
	b=s61ocAIw4rMfslO3acjk1mtMSFD6Q1aeR/Ms5oZBHykZQyyvEZ0/bKxvRTm0fb3jFq4yRm
	LoonRxPn+5BwW8CtVYA24X8VwDvfq09iXmHc4qHERqVMpBr7C/C9yGOZtWA9fBdU5tcE6u
	IsswtHLMjNTKgh7OlQFlgVrriczYJfU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=7vC0C3sp4wt6zauR/zTBNv+UfY1Rq7XzZhYx35u+Pg0=; b=pyMcdMZQB5ZqvVLfY1c
	7rwJCGcTAyuR7AiTeZGd0MdA2aYDFZJzn58phDbodFcBKdGH7IN2YcOx3wdqcl5v26RPIOQRJk+9W
	wdmRJF/vyDaBrq3xJRM0EjzN0coRIHYANvzMBDssbnclJzBt4qh4LA9B8GdUKXYM6PFonfPMLYXdd
	wZZu00DxSxjZ9mCUYfoW3kg7GiCkivih1R3rIox90CkrPBOdH7kkAFvASow/eK1Jd0T76aGIHteb5
	XSnMa3S42jsDsfOC4EyCiu1su0r/rdLS4S/NgC22IbUqLTpbtr/ZPXCK5sTWpIdaEyU1lhmwn/6nK
	ETmdNvppmvsaPeQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xH17r-006OFq-1f;
	Wed, 14 Oct 2026 17:46:15 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 14 Oct 2026 17:46:10 +0200
Subject: [PATCH v3 2/2] mm/huge_memory: deposit a page table for a special
 PMD copied by fork
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-2-85eaec8417f6@virtuozzo.com>
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com>
In-Reply-To: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Sashiko <sashiko-bot@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=ccKR6pewzp3zZMmycW2Bk4rHSSS9C7rwMGxwqRO0ZTE=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqz6PFClTyKPLrnnz2A76nCcPaPtA7BJ8STorQS
 2LGmEvfjtGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas+jxQAKCRBRlgpH+WFc
 KiGVEACF48BxKLRtenct26B7UErEMP4cCXXKBBh2OQTdVQG/gTnTUQmsq/rRFofn4M3McyTNw82
 ySfEk1gWQrQAKYowENQdUkKwKyDbgkCZOtL5nnOp40ZO6LPu35KF7+CNCkxOzXX0ZK4KnCz1ZTl
 x8DcoUMCJPp2pneC9getMw4C6zGaSomDz7heiaT1Rjzl69SToQWP/YEjdBfkVqbepbWKDUkFdSf
 P3FiHQ+K9+uVwKO0rUM+RpUW4x6PoDxfAC9pYTYVGENU76vAHXbbQWjLLQ496MoINpTBeQ+icLy
 FodLaYFVmgD0y597BAwMwDAp/8OTUeMF46epEQ4Qg05XHsn1mWEm7qZEYY4u/vdLRdmwt6PiHRj
 TGZJnxg9ywOfkLjRQtnfTh7AQtXhed6tvMcaZ3dZqXIe9kWA3sy2puP1B/Gy8lmWRiXmYAVYY74
 9cmCRDVPu9RcTZZrkdjaDI6kLpuntZeN0JyPiFsJNTxVpkLjCj02cZLuQTGrFJMwQhF8DNCfL3H
 gxbA1Ha344ZOgRPMoKvyFErRvSqB59yIGmamAXa8eIVTo93ZTzYGEnj5fJs6FFsO/EdoTML9NuM
 hZSVV8SY3dYfeBR/monHq2Hq0CZszYYxdozeXI6Zr8RcwERZH/RGXyPJdHgD+df7ZHvxIcRlnD3
 9o96Qx7HyTFbI3g==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: wb6xuiskkgk48euuww13ngg4r3swjc38
X-Rspam-User: 
X-Rspamd-Queue-Id: AA2CC1C000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791992795-628143
X-HE-Meta: U2FsdGVkX19SKr0Pejud4rj+6zdk+mE7CP8l/9SH5QERLAM8EdER6csB6VkuRDYFF7E0rV3GmjAa6oy4930Rlv+sRXZ6MVzCTLGQNFABVhkwt41AgdxLKDYOGjuummuvt0Cv7zdWMNBRx5r6JL4YX0xJXaNug5b9nIXmvpmPVbiUthCGuWbolPBmMlJxvFLIuPzEGeRyjdekjLejadhIOocThsPVDW40S02LJMvK2YQuBuZjC4rl5ARnAEYchZJ0mGbfLWdxvUawIEiDvRpRlbJigPRvtdDYd1aUEOBl4QnA1nMBh5yDNL4LdzLyZV/HX3tKLk4uWVLJlJsKJbL72zCfSbN+paUQoLDGnEDCDiFGSWhytBMVib1SJWC/5u3wCJJurfLk+WH1VSgcFf1w0XjEz3NExj93eeYYm3EYXBMnGKHs0+WooVw8zj22NOux2kHsGn6B9KGtkHJeOhobah0IwgQvofzZ6sNKfo9GymsVQN/C1cxqEd1MbBY9ZjPDzEZyj12SasqEfW2RdlWS/klfxGR/bBoNF85p8l0dOsm98ilfcWGpjTnXvCW+oySRZdfnRy0w5I0lUv5RK23I/hPMW9RZUohIHWdvQ0LuKKkVjUnyIhPIhcbCYl/JGws8gQf3gJKbI+hRXfL26kbTIuvzafcz/pH9ek4pIWpmY5VZ3Rjc5RaUGopxqVdUJH4T+LPUJ/FxswpWgQbYvmxnnVGmfAMVPWkzbK2BHd5Jwfjk6VqJilehU5NMlSj9XjeIyPd7baKFWesGuQQFSpEBN1JwHuK3u9aXGPCUM9/PqVEwaXmEqponaX5VTfixE9IzFxvXE5KyJRNJeQIgQSyevGPGqUP1FBJn9qpGzroQePC2cQ5/ejOWE8NNj8bvh6X2UdSPeFBgI0wJxx4xb6QQUXcJa+TzBBzgXhXNDNiS6ekHhZj5O9PRFzcO092TUbPn4NzbTfYKRR1pzwafHWO
 SSIF+ZTv
 Dv07rdjKi3EUFeiEI0kMYCaMgIncX0Z6WADOGVpHKcbc42WIOnc8dkVImHnO6SywIOgZUnEey0JtUL/uganSeB3Zw0O2+3YwkegTL0fQbC7PAP4ODhgFn1COvWUm276FnLc1p7cFIdIg2rIj1X3zsJJGEh3J/yxhxT4AqPpDI1auKxSYjSzd5oU9L5pwXWHkxyidfWNXGA2H599PGHEISsoW1257GqyMS3tjIo4DLWNf1lcK0Sq+NbWlaYpbnIkqHTxRWn5HRPqxSwIPiry7JmFH1Q5/oUOFIdhMiaiqfDxTYg3g4nhl1i2ZodVuY2LSSYAsazuxBK8C6uqGqKqj5CmJK5IP3+7DHZUAe03/wGmnhv/0FbUTaVGLtKXaM/xG4hF33V+40WM+PdKIPOYicIF1b28ancSjd+sdWiuXcnBm8B8p6k1XQGplvjesq9QflJu46Dw1gqXSr9zDvKbHtherd4UzCImg9zmb5P2KA/z2Eb6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Where arch_needs_pgtable_deposit() is true, every huge PMD needs a
deposited page table. ppc64 in hash mode keeps the hash slot array of
the huge page in it, so vmf_insert_pfn_pmd() deposits one for each
special PMD it maps.

copy_huge_pmd() copies a special PMD into the child without a table.
The child then dereferences a NULL table:

- on the first hash fault on the PMD, in __hash_page_thp();
- on the zap at munmap() or exit, in hash__pmdp_huge_get_and_clear().

Allocate a table before taking the page table locks and deposit it
with the copy, as insert_pmd() does.

Fixes: d1503aa9ab805 ("powerpc/64s: Add support for huge pfnmaps")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bf788bb231691..2380e4e877f82 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1961,6 +1961,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmd = pmdp_get_lockless(src_pmd);
 	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
 		     !is_huge_zero_pmd(pmd))) {
+		if (arch_needs_pgtable_deposit()) {
+			pgtable = pte_alloc_one(dst_mm);
+			if (unlikely(!pgtable))
+				goto out;
+		}
 		dst_ptl = pmd_lock(dst_mm, dst_pmd);
 		src_ptl = pmd_lockptr(src_mm, src_pmd);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
@@ -1974,6 +1979,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		if (unlikely(pmd_none(pmd))) {
 			spin_unlock(src_ptl);
 			spin_unlock(dst_ptl);
+			if (pgtable)
+				pte_free(dst_mm, pgtable);
 			return -EAGAIN;
 		}
 		/*
@@ -1983,6 +1990,10 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 * wrongly write to the backend MMIO.
 		 */
 		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
+		if (pgtable) {
+			mm_inc_nr_ptes(dst_mm);
+			pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+		}
 		goto set_pmd;
 	}
 

-- 
2.43.0


