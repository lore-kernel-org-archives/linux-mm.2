Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1377CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2016B0088; Tue, 19 May 2026 08:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2836B0092; Tue, 19 May 2026 08:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B89A6B00A0; Tue, 19 May 2026 08:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 165316B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:17:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B64DC1A02FF
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:17:42 +0000 (UTC)
X-FDA: 84784070364.07.D7A63C2
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf25.hostedemail.com (Postfix) with ESMTP id F01ABA0004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:17:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T57vD/Jb";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779193061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XEMPGbEHhCu5DMoe1MyIoAfJdd0UluJOXNzfWSjHHX4=;
	b=3sqQ6SkFVo3scZOKh4j577Kn1fipvSLNYXGnsN/ZUffIT1wthLU59p7NRO0+UEpsCLdrms
	YfGwLrWTaKG6XizNKrUgcOCZT5XdLHZyH2QUIAYuc5LNzv19JSLvCqYWsCHxPDl+16/8Fm
	LOTJUyGU/ywb46b39RxhOiEev4hYijo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779193061; a=rsa-sha256;
	cv=none;
	b=38rtBjpw5fSihf1ZLqKZSNghN618+OOZLGQhh8DCRKaqskZYCk8lpiOYsaPLbDG/ZyyVYm
	oQhLLtEk/B9udAawucDWNAWgY/kaxBdQpqmFQ4nFqUIo/Yhum09sc4aUfyaZXHjHXYBbJ/
	dxdyD7xVhU02IQGMVRG6Sc8csJlew5c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T57vD/Jb";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779193057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XEMPGbEHhCu5DMoe1MyIoAfJdd0UluJOXNzfWSjHHX4=;
	b=T57vD/JbaVffczEmaAEIFywhqXaJx2llXP9Bf9TNayRRWYQiMTnlkp5gG2zx39v1nKrq/f
	MQxwymDzYCPoZ/vY1j+s5v7EPgfsNKEgiksr71KFDpZWoCBxEQW85gvb/+/XQ+q4m+u4ln
	9m3LW3JBRL1bQBuQnppcl2vG4ta2FO0=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: liushixin2@huawei.com,
	david@kernel.org,
	osalvador@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm: page_isolation: Avoid hugepage scan step underflow
Date: Tue, 19 May 2026 20:16:46 +0800
Message-ID: <20260519121646.40833-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: F01ABA0004
X-Rspamd-Server: rspam04
X-Stat-Signature: 8znz91qqb34e4og7t1gh6p16hwtxe8nz
X-HE-Tag: 1779193060-553111
X-HE-Meta: U2FsdGVkX1/YqJG+HI0kzy5Lxrx/Kph4EJPSS4ULdLOXq97L+riI4Hhqzaw38uqy49+vMJymPEjwZENT2ep6XJBReX5BXB+vKT0dKtTy5KwQTEMylT/CHqUny2bmILBhLfyM78vE+lGM1VunCyfNUuVPSeminUNRaRtS9vV/WKzwgnk8sFt+k4sloIqo1GZRTrv4CddbPwIR5uZJo6bhv1pWGIViGkUEOIe8fynPlSIEUbPohc370o/40YNKUSlTMx7thBADpx5oOeN5bUKf3Zi1CjlDJQmouPWT+qyf06sWBrnh2sp7tHLDbQKh+glH8iS/+fiiJIYb14pPLaP7VnJWkYuIYO2pz/vHumv8SSrMP4Ltl0FrAI9MiI3fHwWbDBpk5DBTfOht8E4Q6/gbij7vI0n3TPbXMYahoN6XHRwMC7l9J34xoPa09RDLcVXn31WsDVYdGEKQST1p4375Rlan0Zz57Efm4LaeG6MI8D7aLxh9PioJrU6q/s0h8U3IT3E3Pil4IIj4Cas2n9TgF0ho2tjcXoVppat2jxM+uDGQ13LEjsUn0tjbA8NfN6AREAxYAGaNz6DtP71lBRpMQcRq3s5aGhsaIRTI+3dkpLUiQFUkDq8mB1y924Ykw+CKbV+84A1PrQJcrQQOpnkSCDRQ7KsegIghyWhfkcDEpKg7bvuNbcsN8NFFrM65ViBtU5frGAcNPuXxcEgejoX3yH5SdJpAz06TYMY3mBkQ7416FkomkFr9sIdP67WajCDCoDseh4hhQpHRDtlgCNoWjluUMgoDp1UYSB7VBJG+licUaKl+NlnRtHcPIjOWzbSR52jdYLSgQRUUcjziL6e7Ujk7/iza+saVsv8cAcicIIoXJ7fZsXtdsf0RWbAogdTP2VXpf/IF0XuIqZwMLeis+RHPH9mOZcSi2VGevHCrUtkcUVE5Paesi+nLVlVaV0Q28GwanHV+PVA4mHYXYZd
 9cTJ8slZ
 OwiEAolb8OiUyRjd1IzHwhFnTaq7XdV4nWcDXgtuR/Y0CuRRPChKcYH5ZV0uiKMX73tzjPQ1i5fxp2A8XEgyRroDkOcJo158M/FlbPN40dHj+rYzRtAGsjBB6niQKCCIWFb8AXhK9b+Hyw7ucxbH4ykN9ScQBRY+P3mOJi9skKcTFA0kbhVOB7ikLO7f0v16BdU2Wzl0pic4WqwLWV/DM9ChRXPLXVL13L5tWdl+zxcgJj8PIptQviPs+qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

page_is_unmovable() checks HugeTLB pages without holding hugetlb_lock and
without pinning the folio. This is intentional for the pageblock scanning
paths, but it means the HugeTLB folio can be freed concurrently after
PageHuge() or folio_test_hugetlb() succeeds.

The existing code avoids folio_hstate() and uses size_to_hstate() because
the HugeTLB flag may already have been cleared. However, if
size_to_hstate() returns NULL, the code still falls through and computes
the scan step from folio_nr_pages(). If the folio has been freed and the
head/large state has been cleared, folio_nr_pages() can return 1. When the
current page is a tail page, subtracting folio_page_idx() from 1 can
underflow and make the scanner skip too far.

Treat a NULL hstate as unmovable so the scanner does not try to skip over
an unstable HugeTLB folio. Once a valid hstate is found, derive the number
of pages from the hstate instead of reading the folio size again. Also
validate the page index before computing the step to avoid underflow if the
page/folio relationship changed concurrently.

Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/page_isolation.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c48ff5c00244..99f0b06efaf6 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -43,6 +43,7 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
 	 */
 	if (PageHuge(page) || PageCompound(page)) {
 		struct folio *folio = page_folio(page);
+		unsigned long idx, nr_pages;
 
 		if (folio_test_hugetlb(folio)) {
 			struct hstate *h;
@@ -55,14 +56,21 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
 			 * use folio_hstate() directly.
 			 */
 			h = size_to_hstate(folio_size(folio));
-			if (h && !hugepage_migration_supported(h))
+			if (!h || !hugepage_migration_supported(h))
 				return true;
 
+			nr_pages = pages_per_huge_page(h);
 		} else if (!folio_test_lru(folio)) {
 			return true;
+		} else {
+			nr_pages = folio_nr_pages(folio);
 		}
 
-		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
+		idx = folio_page_idx(folio, page);
+		if (idx >= nr_pages)
+			return true;
+
+		*step = nr_pages - idx;
 		return false;
 	}
 
-- 
2.50.1 (Apple Git-155)


