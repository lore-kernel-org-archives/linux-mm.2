Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38535C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBEA56B00AD; Tue, 14 Jul 2026 23:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95DC6B00AF; Tue, 14 Jul 2026 23:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85686B00B0; Tue, 14 Jul 2026 23:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9A96B00AD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:19:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E1B88054F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:38 +0000 (UTC)
X-FDA: 84989508156.24.E43A9A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1638B1C0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wb4eVQhF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784084436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGUz7PpR4WMeHkdZ7b/XP0zPTbF8uLKzTNlgGjEbA7o=;
	b=rCysbdHaWQW2yltvUBb6OCXOB57vTjuzHDymrQ/KojyOmA5uYkBM/a2fUyVI/ZG2A7kFZ6
	aDciN0lw/94uw2o2hWy2azqEaQb9IsWsSzYBib/0XVQcS2gZziFYJJFnfiOAF9OhDSQzs6
	SBmo6zZGC06VtAmEOyHDaW864IeuFDk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wb4eVQhF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784084436;
	b=1/pr8so3FUO5aw9S8YmIGKDppy7qTNtnXHHYnr9DPV5nRjSYwCYN0CSIsVh5LBvxDj4IwH
	BSRAO4jxJHjvZdqaFIxvkWMNTuXaamUmvx6wA37tyo9T4/Eqc+df5Y/eViIh2DxLm2j8cC
	NA2DDYycTciHYwPuyoIlCijebPDSq+Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784084435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DGUz7PpR4WMeHkdZ7b/XP0zPTbF8uLKzTNlgGjEbA7o=;
	b=Wb4eVQhFJqX8gheH92zaNgUwA7OQ3odpJ2vGRsxiD0gaEMNcuJUybN4Ka027grF13v8OVx
	SPPCzn3NypvzzujsO9PASN5s3Wz7TK50eTdC7obP1zA5/fiuc+ENfXedpEalyEaL072KW7
	7LEinDfleK+pAL5JJgWckfkaRCP9y+Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-9urISJdoNiCa7PnOmp61Aw-1; Tue,
 14 Jul 2026 23:00:27 -0400
X-MC-Unique: 9urISJdoNiCa7PnOmp61Aw-1
X-Mimecast-MFC-AGG-ID: 9urISJdoNiCa7PnOmp61Aw_1784084425
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E73771800473;
	Wed, 15 Jul 2026 03:00:24 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99A04180028B;
	Wed, 15 Jul 2026 03:00:13 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2 2/7] mm/khugepaged: extract young page check into collapse_is_referenced() helper
Date: Tue, 14 Jul 2026 20:59:31 -0600
Message-ID: <20260715025941.1571316-3-npache@redhat.com>
In-Reply-To: <20260715025941.1571316-1-npache@redhat.com>
References: <20260715025941.1571316-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: uarWO2CNuHKvqevj9ZSZ5ceA8KsrNSqKgk-xe95UumA_1784084425
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: sxwg4unt9htarc8oyct7w5cs67wcck7a
X-Rspamd-Queue-Id: 1638B1C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784084435-226516
X-HE-Meta: U2FsdGVkX1+fqU7CPNnM/zrUZs3pekc9029v4fnsuqQha2wa5DjVDdry/gdsY8UGD8T4pZyXPbFO2KV2ydjYGcUHJTm3jb4nw5XxCJRprAfmlH3fbRqAvs5upouHb93t2UNYmP8xtKs4+x+Pqwb9hVlT804rvs95JXXdFxeIXLiu2xcKqJPzl2uDfTLE2+pw6sOisl0eJzX9ZGXk9yQpN+DXEASPs+8EYuHFC25DG0Tulhaa2t9UvjAPf5ho6pMlEndcfCCf45LbRpaYqemg0547kJ+vWQ8l/yn4OQaQlrMp5Rfk6JvUByZUweGY7CXjz9QirClqrcU9lEt7iCxX2pHfFYo9pm/wWx7I6zeBQiAZMM3pbcPCUJwQHrYtAf7PnOfNY/GBOkKz/ARaieG4kZbDjFhjOCuUog+wTP8S9bV5meYCq/xytRNHJCDcSzWV0KwF8nl3dVqYsaejnvO5DUit1JlTe7GnM62SzM2tSQxrDYcbah1oZr/7JbeRuNRgK7y6Fl6VZICAKmSIfxhPojqxS4Pvqb92pdJB3DKIHcOMnuiweVNMdO40Eaol9qGwBrByA44ho8DX52rhqdmhYjegpVwFb9QusHzh7HndDyBd9nAfMhFo7+DVlXJ1+PyYOnncWfclIeIPwPqg2vTERid0bEGtJrGOaHl9Cx3HRpCtqirnj6D4tYBfqUbT/S+u+E8uCkXjZbz2P5AvTsHVEPLIxbc02sXmISF10gfKVxBHABCaT8OltzcSREoeMBm1hgw7nmcU9iGdkc86jlJuIeTUtZgFIk42BiG+lUIGZg7ZWw6Tx49qyjdfcZBddUTbedjt3PVfIugJFo+W5smL7VL1JFDWJeMiaRmYrJ4Js1gKte+A9sol023PZBXeg8zu6Oy46IoEI+NKFEHwggtKCHx/Kyl2eR0Sp+GbPJoIHBqKfN2d4+o++7dbj+CuM47mVALjrC1Vmc6VGVyEp81
 48cOmsrg
 VX58iTu7PpkYkTfY3NVanNSdzaxsNKAIzej7rKdDkBb89R6bcAVGaRPH9xPtpQh1/6sxXOQ9u65qk/v8TKbxTHA+MfF2LrD5d+I/pRCUmjWmP6KPcfFbJxW3OZfjIumMJsttS+zXuBpv8AzS2pgA3I0bBa/4NcpjhU5Q7gC08aPMwndhR+SzkXjRzHNfXInpllAaz7PFf1uf3Lekk8b0qxpIwzzI0wtvB/bnhrMkGRAVItkcE4TPN/22oFW1+SL/GzSA+smznUtNlUSJelWwx7Wd/e5p+XFRn9lhxKRJQNlKpNBLqDPaO3UC621a/3AvLlpGfQULy0Qhg8rAV6F5KHDJtZYsj1rP/rkN9qErcxOM/DT4kH7aYviy8d+2Ja+Ol8KQSRja7IfmGDLo=
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
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6ec0812210b6..e92e2b928f17 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -672,6 +672,23 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
+/*
+ * collapse_is_referenced() - Check for enough referenced PTEs to justify collapsing
+ *
+ * If collapse was initiated by khugepaged, check that the page has been
+ * recently accessed (young pte) to justify collapsing the page.
+ *
+ * Return: true if the page has been recently accessed.
+ */
+static inline bool collapse_is_referenced(struct collapse_control *cc, pte_t pteval,
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
+		if (collapse_is_referenced(cc, pteval, folio, vma, addr))
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
+		if (collapse_is_referenced(cc, pteval, folio, vma, addr))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&
-- 
2.54.0


