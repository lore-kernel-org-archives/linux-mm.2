Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9571D31A02
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DABE6B0092; Tue, 13 Jan 2026 20:47:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584F26B0093; Tue, 13 Jan 2026 20:47:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4878D6B0095; Tue, 13 Jan 2026 20:47:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35E536B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:47:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F33C81AD85E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:47:24 +0000 (UTC)
X-FDA: 84328882008.02.09CC7CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4714B1C0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:47:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nMUZetUG;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768355243; a=rsa-sha256;
	cv=none;
	b=W6GEHwkk103ujuaB1a43S1qqciZ7FDYl4d9qmf8MStxspOW8UN2eZB9AvWweU9Rxpr0FFF
	WGSQ4RGmX/TZOo5Qo1Fcd0gJ0UkMoDL3tpIn1UOqZyrdn1Q8di90HM58GCtw4gfMVHhauB
	o+kCdAbpkPwS3Yn9aFn+A7FQ+CqldQI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nMUZetUG;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768355243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbQfZQIIOpzsrWPdxd8hqvH/53pZdu9JbkLMGzh3GNo=;
	b=ku3m2z6hmv2F0Ch9HWiT7Ba0RfALbqbc5q5tU6e0DPlPO7WYektNXnaFLK5BczxAP8A3Kd
	PqjZ12Ky+aQquJyxDrYCZhOQl+qyvyd0nK+TU7NJbfysISt2pK0djBayuWNHlESKFRgo9f
	rMaMlXlQkND8tEIRW5YVPtT6KMkxMas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 91CF36001D;
	Wed, 14 Jan 2026 01:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E385FC116C6;
	Wed, 14 Jan 2026 01:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768355242;
	bh=FRPsnoiRkODgwynUNMuiriUhpdUW/a1TX7VO4CmrSgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nMUZetUGq5t9FXORjBux3ic7ipCkK15b/0aIlPYXyzT3LjGiBNtw46yfVpPvq9gJW
	 cCcsSL08rzEc/0uqeXKvfLPRlGr3DySymdxhtN5GVD9kXM3SOmDrlteUDE7J6MYvsP
	 5auIGPRnxjviXOJtvEb89I0FxT8fX0ibQE2hDtAA=
Date: Tue, 13 Jan 2026 17:47:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, Oscar
 Salvador <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/5] mm: page_alloc: optimize pfn_range_valid_contig()
Message-Id: <20260113174721.1252583ed3b30c309dd91a4b@linux-foundation.org>
In-Reply-To: <500811d3-67e9-44d3-bb67-095b23728aaa@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
	<20260112150954.1802953-3-wangkefeng.wang@huawei.com>
	<926A149E-FE2F-4F88-92D6-FA607398605F@nvidia.com>
	<db7a38dd-77c5-4adc-b0b1-ceee45fb1f51@huawei.com>
	<9FC904C5-1C5A-45BE-BE0F-556AF573AD4A@nvidia.com>
	<500811d3-67e9-44d3-bb67-095b23728aaa@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nctt1pk67kwreujnqp1objdawyca7a8y
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4714B1C0008
X-HE-Tag: 1768355243-696592
X-HE-Meta: U2FsdGVkX1+oFQPJKzgqAA9cfsec6nCR9i3+pLhCM+iCzt++y+RuQuKlS0ybIoCqeQK2Lgmacwo6JwZmRKOs27VW6qNH/tCvlKbdI7GrViTIuS/iV0MnoJOlO1ebxDGj4jcNdZe5Wk3bHJq+L/2WZjyFBb7/7VP/VmH8Qzu8Ic4RsYaX5HeH81TwHlXIA2iQYoT/MDPEjk0WwUdwGNMu+P34J8X8MMTNQHf+IeAkUz/wVaTmRfc5+Wg8cNw236k6b1z2NOCnSXQcwKOQSUWgIpcrOtiS05Fj+p9fHNa67U3DxWIVOsyh+pjTuCbpriY+s/eouafu759VfoBP6DVDOxKwF/viDw3+xnorQca6/bkj7d5t4U7szO/Kx2UOF63UODCVOUNznaJ5wzh7QWu7xwDwz6m+eGKResAeRxXu9h+JRyYDN+tSuk4lPNl4c4SYLnjCYeKPMx/hubx5HhATCQpwRE81iBrQQlcs8O4BVKD+lK9HTgqNB8/ZJDsWw+pOZXjqlOpuj9vtQFROrL/lTA0NXahfW6z5XE+cxq1AKWnIyr+JE5E98teo+tVC+/YJuqertyspF4zoFiUROJwFxjMpxX/9DKfaFkqFVBFHnlfZ3hgtI7S7jhKr/OCPFqMqoK5dUQbhm2XfaARCjBlusiUUT6JTJIIKfWtgMOIAWkC4f8ab7wyTUFbLWPX/exfTTdyT/HO53YeHpZXuXo3zIsZA4K8jw0+hXFSlJW9iwbcdmDOJ/5rLFls/3WdyjIW7NJDJmUgNTEw2EVmjkX2X3iltHQ7/LAwmOLvukADL8tgZxQ16RKyX/fAMpD/A5qmacGE/pqsaaPnEp9sEs3l82U4nEz4dX/ZuoXALEHOMAc2/fj8u/iNTv5cw0e1++fUbdsMWRMZBZLRrhjrQzlSdVsxpB9rgsccbTH0Q3Ft87kJxeevXZ9JJZARS1p0nen16dNO6hTYkifILK0l8fJ2
 aE8KCvTX
 rtjQcaJ5a8VCYPY0Z0OwjPrA0NtTc9Fe+Y8f4VbdGDxYCE9kATlRu+nDQ0dviwQlnJv1A9Ivg78juA66Sg/WKzNj+LC7A8HMmkix+Ogz43S8R3F0rpq8B2izRgy4rDeEPwxamAHof/G/3t3UjEh3F9P1GIdRZEKe+1ZPlR+WlbiJRh2wgvS40cvVbUB1ZExGYka8BCoh+H4XEf3o4VQIzhJXBOAORIZLMSH6kk55KOKfwY+xv2/ZGeFDTmTVpuQbNWfMPyiqNnE7kYenO2moQqp79r7nnPz156Qewk3gKrzYgqPKKGNR+18oYFdwswAU0Cur/TydgIn5tDjzSH8Q/ZFGDUKZh4JQ+IJ8b/Ib04hJTgwNOmUJtouH+1Jr9COzOGVtdJT5/Pc77EuMdqU25NlqBmTxg90EoUsbNfoA9s2XdyfMP1S/HMz0rZGMpvFC1e54fOwSxUs6HTEMwmjhURCF3Wn9De2En+2i8GSx+j54EIMD1LawtfKRqz6IjzQ3gkekkfr9Ys66drDfYokNLiRp/h2d3QXzEQ8RP1yljETnj4eKslwI8YOluV7NecDNmlWXT5iCBqlyUZ9YzOX3HNtiutg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 17:55:43 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> 
> > 
> > With the changes to the commit message, feel free to add
> 
> OK, I will update it.

akpmbot already did that.

> > 
> > Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks both.



From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: optimize pfn_range_valid_contig()
Date: Mon, 12 Jan 2026 23:09:51 +0800

The alloc_contig_pages() spends a significant amount of time within
pfn_range_valid_contig().

- set_max_huge_pages
   - 99.98% alloc_pool_huge_folio
        only_alloc_fresh_hugetlb_folio.isra.0
      - alloc_contig_frozen_pages_noprof
         - 87.00% pfn_range_valid_contig
              pfn_to_online_page
         - 12.91% alloc_contig_frozen_range_noprof
              4.51% replace_free_hugepage_folios
            - 4.02% prep_new_page
                 prep_compound_page
            - 2.98% undo_isolate_page_range
               - 2.79% unset_migratetype_isolate
                  - 2.75% __move_freepages_block_isolate
                       2.71% __move_freepages_block
            - 0.98% start_isolate_page_range
                 0.66% set_migratetype_isolate

To optimize this process, use the new helper page_is_unmovable() to avoid
more unnecessary iterations for compound pages, such as THP not on LRU,
and high-order buddy pages, which significantly improving the efficiency
of contiguous memory allocation.

A simple test on machine with 114G free memory, allocate 120 * 1G
HugeTLB folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m3.605s
After:  0m0.602s

Link: https://lkml.kernel.org/r/20260112150954.1802953-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-optimize-pfn_range_valid_contig
+++ a/mm/page_alloc.c
@@ -7157,18 +7157,20 @@ static bool pfn_range_valid_contig(struc
 				   unsigned long nr_pages, bool skip_hugetlb,
 				   bool *skipped_hugetlb)
 {
-	unsigned long i, end_pfn = start_pfn + nr_pages;
+	unsigned long end_pfn = start_pfn + nr_pages;
 	struct page *page;
 
-	for (i = start_pfn; i < end_pfn; i++) {
-		page = pfn_to_online_page(i);
+	while (start_pfn < end_pfn) {
+		unsigned long step = 1;
+
+		page = pfn_to_online_page(start_pfn);
 		if (!page)
 			return false;
 
 		if (page_zone(page) != z)
 			return false;
 
-		if (PageReserved(page))
+		if (page_is_unmovable(z, page, PB_ISOLATE_MODE_OTHER, &step))
 			return false;
 
 		/*
@@ -7183,9 +7185,6 @@ static bool pfn_range_valid_contig(struc
 		if (PageHuge(page)) {
 			unsigned int order;
 
-			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
-				return false;
-
 			if (skip_hugetlb) {
 				*skipped_hugetlb = true;
 				return false;
@@ -7196,17 +7195,9 @@ static bool pfn_range_valid_contig(struc
 			if ((order >= MAX_FOLIO_ORDER) ||
 			    (nr_pages <= (1 << order)))
 				return false;
-
-			/*
-			 * Reaching this point means we've encounted a huge page
-			 * smaller than nr_pages, skip all pfn's for that page.
-			 *
-			 * We can't get here from a tail-PageHuge, as it implies
-			 * we started a scan in the middle of a hugepage larger
-			 * than nr_pages - which the prior check filters for.
-			 */
-			i += (1 << order) - 1;
 		}
+
+		start_pfn += step;
 	}
 	return true;
 }
_


