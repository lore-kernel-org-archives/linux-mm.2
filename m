Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B64FC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2EA06B00E3; Tue,  4 Aug 2026 15:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7876B00E6; Tue,  4 Aug 2026 15:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3FB6B00EB; Tue,  4 Aug 2026 15:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB666B00E3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:25:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F17E240234
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:30 +0000 (UTC)
X-FDA: 85064566020.21.8E76B10
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 40767180008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rCWUb/f0";
	spf=pass (imf06.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVme6Lrk8eLALEVFcm4lB1EGIT/woVs12FA3T5p62Gk=;
	b=7P3I3SkGMF3WrDdNz+9SgbjVcaHlfJe4re1+GjK6ZjiLQ7YshvCpC0Kn19SvNON+GpxkoN
	L0FdExcdL4O5Ef0fa8Q3Qofhe0JHb/RnTt4HJaY6rv9k5+EuTkfjR6enBJLAVMHijb1KQa
	VKZhui9AiFLA/4YPWg+V3+hE6wSJimQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rCWUb/f0";
	spf=pass (imf06.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871529;
	b=U14RSGFc3sQFA+hWWag7OapaSerwTaivWd0WMm7o/D+NKI9taBtjPJkV/atYyAph08gE1L
	qY7ZGVCSGaAeG3JRkegDb9VJqUDihAOOFzzEIUJMg5UXM14e9qUvSc4ZXwCNzQ+kLOlNiw
	MoZLpybMXMzq6AvUclgSpMprmzP0n1A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785871527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dVme6Lrk8eLALEVFcm4lB1EGIT/woVs12FA3T5p62Gk=;
	b=rCWUb/f0kE/YDFFqxsBddT28dRPKcKcZqwxdVfULUqxAts5R4l83/1wdpxno73X/EOlDRK
	oSfjTrBWMELU/htvG4Y4VYUGu0G2B2GxotUs5qW9VbSlXmdCwyG1OA2Z2oc7HsIBlGnszN
	EBN+yVvT6QPBVYbjB3l3TP4f6wYEZhA=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 04 Aug 2026 13:25:00 -0600
Subject: [PATCH v3 2/7] mm/khugepaged: extract young page check into
 pte_is_referenced() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-khugepaged_pte_refactor-v3-2-0364cad642a0@linux.dev>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40767180008
X-Stat-Signature: wrn3gp7bgf44kefsxw6koxmbj5qmm4s8
X-HE-Tag: 1785871529-831551
X-HE-Meta: U2FsdGVkX186R4LfrmkVrAcBjsceUhgiqzVtI9JTyLxF3rRMunRxzxABmm6dQkIM0vHskkq3OAg0FXQ//GzctgoJ13l9uZbGzIRby4L3wYct5eSYNbGc9wkQ/GwCWmD/SRP4nA8N74uquFQ7kWD8UaySLRWxYfXjeaTaAw50879Iz4xGDlCBT2+z7HPcNFG0fqssQwAa7yeUJGGaa4huebrBgNNy4lFFXDjD7KEvPnG7tZxX3AxOXpSYmXnIzET9iQWSI6OLOKHLJwvc2Ko/vLLVC5QzLUzKthHvNod9zJkz/3gcwGo9jm3I/HZuXEvAU0T/X55SgNUA51D2kFIfpTdmmRlUWCTjJHLR0+SvDxrwAMR+vURQdzT/OG9P0U9WxqWFWQGopW2HphkWZ24/h51mp+AbeBsCV2Va5h+bciUHSpe2GLpXkNbRjI6C9BkwTRiWlr5NYIZ8BJ5kTVzsTnXQ+7p3oaIBxVmwh9Oj306ZaW5JVPy02XWYEG5m14uqOJ0/ZsvHV0w6FchBc/YkgwJh0M3qRZo/T3o6CXLMtqWF+IwjdDH7lRXOAdb4qeFSOOfwCfCF7Cbq9vL+eFVJihSodQJoVrcWivXPWpjHRc4zsHXrLGNynVJUA2ZnOQNF5NRofwWNmcY9ao9fKNz0QBIlFtMUpHp0DfFdt/w1eJiAFa1rdezvAK+2SeIuGcFDMRa5+/l96C1h4hNNiZiPi6vRZ1OUJD8ATJ3dcZJfM7pPgPYpBtsziJDO9zQA3tmY5yjvclvZmJs4Gv0+D1xYh3ltwBE1ccOjnZJ/2dddGpfLKhuX25KcURRUsk086/SCXGOei6UPR8LI06uzvRMiHgWr4zr6GvFAjS+yPFr3cMpa5+L2hgTohguZfcwRbn+R+Gy3NGFWQzpfX7e9HNhM6tk+fVglpZJ9ilmamCpRH3Bs3Duaga/vFDQ5g4hjG/luoM26sMhFsAQzoF08XMl
 lWKIJEFN
 D1rT4ImjZXBdxOd1cAstLuh32q9l68I6TWcxgS+Q1+rbXlyir/cC17JljsLgzSOow/GqTL0gRtCM6Ctzo8YqcKXVw7LyjmdldUg7HBA/e53B8sCEjJTPpwjcI+MLlaVySfEVc2J6YSBqhrQvuIgG8VIthY/a6z33rx6kKJ+OIBtkCC8PeSTMu/eJxstHvEntzrX2s+oSJm012MIVVeeYyALcqu9uD7hihGoG7kvu0hXbVSV5s/hqZpSrqA1V5bar4jL7B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change deduplicates the "is this PTE/folio referenced enough to be
considered for a collapse" condition that was repeated in both
__collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
a single inline helper function.

Also move the comment and use it as the function header. While we are at
it, updated the comment to clarify that a young pte is a recently accessed
one.

Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1e26ea97381a..9b15c1740943 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -672,6 +672,23 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
+/*
+ * pte_is_referenced() - Check for enough referenced PTEs to justify collapsing
+ *
+ * If collapse was initiated by khugepaged, check that the page has been
+ * recently accessed (young pte) to justify collapsing the page.
+ *
+ * Return: true if the page has been recently accessed.
+ */
+static inline bool pte_is_referenced(struct collapse_control *cc, pte_t pteval,
+	struct folio *folio, struct vm_area_struct *vma, unsigned long addr)
+{
+	return cc->is_khugepaged &&
+	       (pte_young(pteval) || folio_test_young(folio) ||
+		folio_test_referenced(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr));
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
@@ -810,14 +827,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
-		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		if (pte_is_referenced(cc, pteval, folio, vma, addr))
 			referenced++;
 	}
 
@@ -1766,14 +1776,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
-		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		if (pte_is_referenced(cc, pteval, folio, vma, addr))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&

-- 
2.55.0


