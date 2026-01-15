Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D0FD46627
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059326B00B0; Thu, 15 Jan 2026 17:42:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0065A6B00B2; Thu, 15 Jan 2026 17:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54CE6B00B3; Thu, 15 Jan 2026 17:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2A316B00B0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:42:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65B22C1F4D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:42:32 +0000 (UTC)
X-FDA: 84335673744.14.010A521
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E9ED140006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:42:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jvvlukGD;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768516950; a=rsa-sha256;
	cv=none;
	b=a2JbEk8nD3nO3Pwoc31HGQdpojpWZ9BYQu/KlsGKQUnzBi3yyxEcf9RauZeMp8BlT3cxMl
	Hs0NNXFuTcCyKIYmp/vO1r2yhwHpu4jKq1lDcr4Aammjm/M4c288H1NgmW5UduLgJkrT7P
	FUZAG/CjZKLhqXTprmurbRy7wibeZZ8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jvvlukGD;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768516950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FEm0x5aKssRxzaLAYqQl16pjOzP6Bdvh22Kxex3Wdo=;
	b=wYnJbdURQtRyhCnrwHNc85ozfeISn/x9v1CP0qLph7d8pwccvK7V82F0BQ5PJ2tD7UASEO
	aHKfRf7khe8YyXYcIPq9VdUBLKJ9Uy0hq0UkBAnxV2W/fU7tkNjUz8IO5FZyHQOLjz/rb8
	y83gmO5f6SUg1UbhgaT4v+XPEjyg9fo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A71B4359D;
	Thu, 15 Jan 2026 22:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADC5C116D0;
	Thu, 15 Jan 2026 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768516949;
	bh=oIPvoP22Dv13jvX/u25cqLAmHxRkYmNrQ5CvK4mPGM0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jvvlukGDfP2wrA9R2xVzYb/qm0EuQanCWY7Q51Pt3uLR5YtRd75hd5FgXM7KSw9wj
	 sTrEDdnJWlaI+M2OoaCpZldM7FJlhc/c/XRcz66XeCUrOI3wYCfqks0MCQe2TJy+1o
	 hVVVm3DAVTx2hvcMEYx9qEeoVuZijVWaA7oJPDWA=
Date: Thu, 15 Jan 2026 14:42:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
 Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH v2 3/5] mm: hugetlb: optimize
 replace_free_hugepage_folios()
Message-Id: <20260115144228.4b103d0b37b0f3fd017a4d9c@linux-foundation.org>
In-Reply-To: <20260114135512.2159799-1-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-4-wangkefeng.wang@huawei.com>
	<20260114135512.2159799-1-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E9ED140006
X-Stat-Signature: mjbxqcdyitmunig8pdybo1o4hhtjqipz
X-Rspam-User: 
X-HE-Tag: 1768516950-99458
X-HE-Meta: U2FsdGVkX18zZXaqfjgcwd6StRoKJ5KANtqpOyN1b5fxgFh2CecTq2c/r6MMttKwMI+RXe1ps9tcSeWJs9+TvAJ0Nt5e0Pnu30czaVNJV1BnIMpquYEByizIZ66XgfeoW16puTyLI16KqRUCVvz14ErxwpUYPdcdu5ircVIWjTSB0aqWozqhVPNwdwriVyJR0GozRwx2789gv4qA0PrhOMbY0lLilZYhA8OD2+ZcD3pdOsELeHc3IG6HJi6kLYkldmLPLkS9N84P0RTHQjE78q+a6WqqxfLBIkQG0eXmz55BWxW/7srR6MxylImxur/vZHTlJrji5xvibB2T8Sjd+vmSPtnKlb/Xlwek9pMzNYeUVQuKT+37wbnCgyDdwxxmy7hvluCKqwU5U6MrYb6kBPpJeprYjmlAutBxVZvJS/O50AXkwoTUc3QyL1Rqqab55lYh2b/N7zx3lJI9FsIi1iXnnEFDCwmLnFUbeOQ8UDqUM/TQGsvoWdzsqBLNDFOR4zlqtS4CFpMEKfyGRvA8iDHhKoloFyTh41LO4QmyXFp/JHGEn9i9hGPmF7Hf2Mz8leQ9R+T8pO7Txbr6ZLsk4E2TH7Z7xUGkOPGEyjIkh/Zd0nx8YhQP2nDfnyWTsy1TDpmdgOf7KD3LwW/uISBC8x/WEpn+WZS3WvWSirVofxLwhRaO6o9me9PQfAJyp2ZrsMFcGLRGjmjgxW+wgtgRHK77u1ucWrQPcUafrBjrPUP2AeLHMqG0knUDxxe1l+zwjypBZJeD6ect9+JImOyctZUliQ1+w/qXyDAIXBDTJM/RZZtDg9TP6OOhClkhEPxRNLQL3V6yU/0c+fun4CaxawaUxxgHkBA5n+rAkulZe1L2HUd+ECZTN7GofCvIR7Djw0r7HUcDePD1ia5XKmv5n30ZECiwcu6S4yRvXneLYbyZHFCLbkli1Dyx/RkufvT4vpDI+9lhU9yz7CP8rRe
 22DIXI7I
 mZgtE9b7YiYU9mzolZ58WHG3ojsD4CwYvYdmEQW+sFPMQf9P1W6OlDg+l2SenAKUImPc2b2Kw9XOPGMi4t0xX5gnj/1SU3BfaHXKb92lpAQeqmxQrhbGm19WirVJRuVsVoZPXrMImCaylW15qQLs8PPtdFl0wmqj3QKaAUF5z9L9L/2CEsOLd8DZYNZK4Lbe96YjzPYHIO9XcOHDcJW+00eiEFa89vDe1NSvJFHURtqa92bIlk9F1cIawY6Lt7/htZDCHeTtRyj+6RfVjqofS1hKlazSdDYxIdAwiNN6xJuVVGpk/U8T/3NY6jRgSh/dZ0/iHjOKURdE2Oh+O5hdZyWrxatCfsZGLkbZ1O0Z0PG9hoPJ1SD2m2II7buUKzEhW1swWLm0hrSj4KDg7PhAJwjJdwezdS5wQknF9K74DDsGSf25Q0i2N3Iv0GCpjuvcOcsrsFdiihOe7kenKt2Pgzb0os5myzjoJu0Xb9R580upUP84+soGyU5A1kmNau9vkVct0mUs5EVaKlvaRuzKqPyk6/A5U6xKL7I6ai3vFJuybEgLcnGjQPBoIu4ybA/i/pttUk2IPg6GjyNnx5IeWYML+Bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 21:55:12 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> If no free hugepage folios are available, there is no need to perform
> any replacement operations. Additionally, gigantic folios should not
> be replaced under any circumstances. Therefore, we only check for the
> presence of non-gigantic folios, also adding the gigantic folio check
> to avoid accidental replacement.
> 
> To optimize performance, we skip unnecessary iterations over pfn
> for compound pages and high-order buddy pages to save processing time.
> 
> A simple test on machine with 114G free memory, allocate 120 * 1G
> HugeTLB folios(104 successfully returned),
> 
>   time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 
> Before: 0m0.602s
> After:  0m0.431s
> 

Thanks, I'll queue this as a -fix, below.

nit: the function has become rather a jumble of bailout styles:

:				if (order_is_gigantic(folio_order(folio)))
: 					return -ENOMEM;

This could have done ret=-ENOMEM;break;

: 
: 				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
: 				if (ret)
: 					break;

While this could have done `return ret;'!

Single-return-point is preferred style, I think.  Mainly to help avoid
leakage of resources and locks as the code evolves.

How does this look on top?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
Date: Thu Jan 15 02:34:07 PM PST 2026

use single-return-point style, tweak comment

Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
+++ a/mm/hugetlb.c
@@ -2834,10 +2834,15 @@ int replace_free_hugepage_folios(unsigne
 
 			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
 
-			/* Not to disrupt normal path by vainly holding hugetlb_lock */
+			/*
+			 * Don't disrupt normal path by vainly holding
+			 * hugetlb_lock
+			 */
 			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-				if (order_is_gigantic(folio_order(folio)))
-					return -ENOMEM;
+				if (order_is_gigantic(folio_order(folio))) {
+					ret = -ENOMEM;
+					break;
+				}
 
 				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
 				if (ret)
_






From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Wed, 14 Jan 2026 21:55:12 +0800

Turn back to use alloc_and_dissolve_hugetlb_folio() since Oscar pointed
out that the return value is different.  Then adding gigantic folio check
independently, also update changelog.

Link: https://lkml.kernel.org/r/20260114135512.2159799-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios-v2
+++ a/mm/hugetlb.c
@@ -2810,6 +2810,7 @@ int replace_free_hugepage_folios(unsigne
 	struct page *page;
 	struct hstate *h;
 	LIST_HEAD(list);
+	int ret = 0;
 
 	/* Avoid pfn iterations if no free non-gigantic huge pages */
 	for_each_hstate(h) {
@@ -2835,9 +2836,13 @@ int replace_free_hugepage_folios(unsigne
 
 			/* Not to disrupt normal path by vainly holding hugetlb_lock */
 			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-				if (isolate_or_dissolve_huge_folio(folio, &list))
+				if (order_is_gigantic(folio_order(folio)))
 					return -ENOMEM;
 
+				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
+				if (ret)
+					break;
+
 				putback_movable_pages(&list);
 			}
 		} else if (PageBuddy(page)) {
@@ -2851,11 +2856,10 @@ int replace_free_hugepage_folios(unsigne
 			if (order <= MAX_PAGE_ORDER)
 				nr = 1UL << order;
 		}
-
 		start_pfn += nr;
 	}
 
-	return 0;
+	return ret;
 }
 
 void wait_for_freed_hugetlb_folios(void)
_


