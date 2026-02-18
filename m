Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76596E9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54126B008C; Wed, 18 Feb 2026 06:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4AF6B0093; Wed, 18 Feb 2026 06:01:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D7E6B008C; Wed, 18 Feb 2026 06:01:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE12E6B008C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:01:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CC4816051F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:48 +0000 (UTC)
X-FDA: 84457287096.09.9721A09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD49140009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QgSw5nHK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771412506; a=rsa-sha256;
	cv=none;
	b=24TyWjG3V69MtF6GWhpcua6xFZBFDG/6uMqtYDlSN/QrZKiRNQ2tfG1Jdzp8ddNijGNs/9
	wdjAg49ZF0CctdJR8YL+vTevgT7zOKi3M5jDkSE9nU8Gy8akUkF/pdLF+KQXnIh/zqqBO6
	yPL534/K+B6rN+310vDo9HDaRo1Vm+Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QgSw5nHK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771412506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZiRT7+8bFpvyeRysZvUlxbMBeUr2ouDNyfvvrPFn7I=;
	b=QD+XqxG00uqGMlpcS7RiQe0e+aGju56lW0zoIuxMl+kiXBNuHY9N/25HLJXJ0Vhj5/csuq
	LBED8Tw6IFFzgg5AZwL0/BedpkcdUjp5EKEFuxnaRA3yxE36pPRuvXd2ifa06UeS+tdsno
	0jKOsZowBoyCtICZJqn4Z4CwcxyP/10=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F8946185F;
	Wed, 18 Feb 2026 11:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FC0C19423;
	Wed, 18 Feb 2026 11:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771412506;
	bh=3wEvep8HuYOnF+jdDKnf9lRz1v8Yf/Hh+ICm3waaup0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgSw5nHKaxkwnoKwCn/aVrI+qzJmMvWbxLRmvY2sEDoM5fT6vxafkh4zx1sStkn/B
	 QWBeHqdSg496oR5Q6bblxNmqgzKEgAjcLLJDegjFibcBoJH/XA8O8KmJg9cr3DnEPl
	 +ru+nu6MF569JAQXdpwQOon/Is/Bq9ulwmBpkAp+aYHCTEVYiJX8dXeseWKV1vrJJB
	 /cJy6gi2tjCtL2A0s+mGbh125h7qLIHt7r1jxpqltJYdLLYeE94gmQSE/e03Wq3Qlg
	 Ng9ZerRxJuquBoOlLFwhpDGwD8xX3ieZsIXwkmyr+R0pi1bQze65053FTM0d3qy6ju
	 MiF14gGpOC9rg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Lance Yang <lance.yang@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Liu Shixin <liushixin2@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15.y 3/6] mm/hugetlb: fix hugetlb_pmd_shared()
Date: Wed, 18 Feb 2026 12:01:26 +0100
Message-ID: <20260218110129.41578-4-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218110129.41578-1-david@kernel.org>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uotznb5ynuj5bw88meskry7sxmhtxyww
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD49140009
X-HE-Tag: 1771412506-653960
X-HE-Meta: U2FsdGVkX18Bs/Mn8PSAaF+EeNXwNSX/xfWNlRLKGwktz7nCFbhbbv77fD27SbbOzFvIANcMiIJUPGVvnD4POWYa06NrFpFDpEBAvUDJVwwzCqYIFoCAShukXsMImhqCHJlnOvkiBKmw8cMOYCmxN7jZT6cZl2HRlbksb8OoArjQ3U1BXYue2zkxUAc4w0JPg279yIkb36ERuDCcspvZgoYbz8WR1cShsmfNh9VRLRU7kTYuQlBuK9mSSBjJk0tJTMo0LAq6z0JSch0WhE3rf9S1mfmfVLWS0sQeONfcrY9AFsPdUPzyDLJSoy8b0pCUn8cIWUcnIZaxiInVlt1Oqt0blUjUC6ixQIf4a7QnW1bFISgguxD3GkR/ak84mdHHlkfk6x/eUwo3kFAK99cI1/ogaqP9UBlLsepoDdVwIVLA/S6p0Z593aUwL9jNH00FWkwJzHIjRu93jnfVygasDF7+chUKZbBYMSNXk7U7qWDoVdGW9nzE0c3jvGvFm1KQcQd/qNiJZ7SUSPZggObwYLxTeQtk/bx6BF//eaYKZuZHHjKI9jv1kvF0rcaD00AjlHAZAg20fk8Uz6Ksh39MghBw+YHBM6cjvvIL764Q1ZuVzNHBqiOf87ahLde6RysxMqKAU+4N8Ui3jyK2dEzFV+EXRwQHrnoc+2XNnq/QR7Rzm97LxxwqkWr3GMZsjay+jJJtwJyKpvafWhvz15/J9N1p7JrLvC6jfIhovWjjCq6AbV1KNWTxi4V837b5BL3L1St6CyGKAXHrlXGYGRySv1KJSJSvAHLiRTHjgGa9/NLtFgOes/tcbX14dWLgBgxE+/jVxnwCWE6BDImh3TanVKcsmEoKCQvvZ+iifAru7GBX1P6JN20AXUtS1rASi8cqWk8kVqVklGRsrNpI6yvxvpb76rPaiwHgvNdcRWhFG64GZ8XVSZliqsn47SIaZSMcIWXDMR8M46SPkh0+dEm
 rc/VXEAr
 Kwz4FTYKupA2UMGiJy2tDcyKU69idxAee2Jlo9Wo4tdQaZde/Q+B1u2M37ZTOsYDXxL0udbiSXLfqKbWBfxKztB+P1mVI7B155AsNdoiUQAAolrNcluna6wvd8acYSaxmLUMR3jx3k5wNdXOP/V43wXHTul+pk5ZmipmHJIZMH+d2MsSmN9od5QpEXMyq9xQn56xUHtoGv6jIHBRfksGRkHr5H8l1D6a7NMM3T452urpZZKprLSQdrpUjzYpLkRvoWWibhtrrn8xQ7DIvKGv1BrhHNw9W+6rTN/ubmBK9hFSo+MsHnalZJq2pCW7E2z82OZRB37tXeBZwaBlNLCEROdQe84wII52I93Yai/rO3Y81exDyPwD5nH0KagzHzHgo+LtWhvoZhXOlea9Dy7SaPsqs3Gg42bBVRWEJ8eOGVn7+TVwPOOl1nnpkaSRBSllLIRrf4++WQnSOVV0RtL2ov7yBRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

Patch series "mm/hugetlb: fixes for PMD table sharing (incl.  using
mmu_gather)", v3.

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point.
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily. At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.
Read: complicated

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86. But that's all out of scope for this series.

Runtime tested, with a focus on fixing the performance regression using
the original reproducer [2] on x86.

This patch (of 4):

We switched from (wrongly) using the page count to an independent shared
count.  Now, shared page tables have a refcount of 1 (excluding
speculative references) and instead use ptdesc->pt_share_count to identify
sharing.

We didn't convert hugetlb_pmd_shared(), so right now, we would never
detect a shared PMD table as such, because sharing/unsharing no longer
touches the refcount of a PMD table.

Page migration, like mbind() or migrate_pages() would allow for migrating
folios mapped into such shared PMD tables, even though the folios are not
exclusive.  In smaps we would account them as "private" although they are
"shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
pagemap interface.

Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().

Link: https://lkml.kernel.org/r/20251223214037.580860-1-david@kernel.org
Link: https://lkml.kernel.org/r/20251223214037.580860-2-david@kernel.org
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [1]
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [2]
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit ca1a47cd3f5f4c46ca188b1c9a27af87d1ab2216)
[ David: We don't have ptdesc and the wrappers, so work directly on
  page->pt_share_count. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 60572d423586..76011d445adc 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1110,7 +1110,7 @@ static inline __init void hugetlb_cma_check(void)
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
-	return page_count(virt_to_page(pte)) > 1;
+	return atomic_read(&virt_to_page(pte)->pt_share_count);
 }
 #else
 static inline bool hugetlb_pmd_shared(pte_t *pte)
-- 
2.43.0


