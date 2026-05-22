Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 397B3CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4596B0093; Fri, 22 May 2026 05:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8545A6B0095; Fri, 22 May 2026 05:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748AA6B0096; Fri, 22 May 2026 05:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC4D6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:35:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6A4314081F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:35:58 +0000 (UTC)
X-FDA: 84794549196.03.51C3476
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A3CF20009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:35:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQ1Sn4Wc;
	spf=pass (imf03.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779442557; a=rsa-sha256;
	cv=none;
	b=7/fdmHk+jCFhwQrzqM2OHBD9DnZ4fdb+iGX8T4OyxvpCS7ALz/ysy/5piGAm5wDmIRqxyL
	qOV8YEKuU1omQ7WZJgTB+mozrM4unxeqi3uM9eIg1yFDQIr9G+Y4CvHinXsZS6vTdAp7vo
	IQIQPYAmrnjYghpFRABCzMe1TM88TDg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQ1Sn4Wc;
	spf=pass (imf03.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779442557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fFfkymitLlVPUZI42Fgss83DIkP0MeCyuDpYJPsqwA=;
	b=N9NrmqgyVXzKfujfpjQVL+eb8bpDTnf8ZJgt62+9f+v9YbSs3T5wHoaPKPN2uiD3IQPpm4
	+wuY9tvb+PcIE6fTmt5sSAvaamUUoC1Y6EA0dOghrk0JMnqLOQmEBSZoIscUGs9LwBsKzG
	cg7KlFSvoJjXUzxcg+8qmRnPJf9WGeU=
Message-ID: <bd3667a2-fd81-4761-a763-f6418d9c09f9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779442555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7fFfkymitLlVPUZI42Fgss83DIkP0MeCyuDpYJPsqwA=;
	b=nQ1Sn4Wcnu7UqMqH8rketLhQ6FzBpBJVRRPWzPmy6S57Hx7c42xGev43Mo8ER9w3bE36r8
	WM+Bcxonkou2FCHZVy3XXOmKBozrucYdsh+fgnq5MitUjXbgS8BP+i/0MSI/Z+FFZAwYWw
	ncyuWVT7JzdmZ1wO5K+lg7zeotPNewM=
Date: Fri, 22 May 2026 17:35:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: page_isolation: Avoid hugepage scan step underflow
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 liushixin2@huawei.com, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>,
 Muchun Song <muchun.song@linux.dev>
References: <20260519121646.40833-1-kaitao.cheng@linux.dev>
 <20260519105424.e422131a0ffb49e19ed1aebe@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260519105424.e422131a0ffb49e19ed1aebe@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A3CF20009
X-Rspamd-Server: rspam03
X-Stat-Signature: ubgehdo3t3q4snmj8gnkdot79jw4zoyw
X-HE-Tag: 1779442556-705679
X-HE-Meta: U2FsdGVkX1+SUDTJKt/31jNg3SJ4J/vQrfJMRzw4J0bNZ/J9k8ZzoaZQMTi2Gr+WqTnccPOL5mOGSqB7D0MCf+1f+Dao51jNhyTkrrvfOvgUMOlynjelsujaTa8s47f7s3phlfxUoJNt8JukC+oGPCGPm/2hF9HOopq+36S+Nb+W5unuOkGZU9H3mIq47m6c6M54cqPof6WBBHajPUHYE3xgyMw5BNaL9zOOfYcFEQbeCriUUaXDChVUTl88CnJGkF/xITjsk1+7Y9JMNubzbSs1VB2UpMMmXuQu4C50UWeB0GUk5JUFOxH4GO+lKa4jU2GW1/b74mv6Rf9pBxD6ARM5a4JPGsRY1KZNG9CdaCZ62N/1dGmc/8cu/Raa4katVmBRb/qXux17mVgzDcMKLywxlhLPSKkFYzDAR03mDvD14DKkgRxQ5BdQimiEBluHX/wM6uLx6VsPk/GfbZfs2QH+a9lmUPUJAMNPAFFubUfMI3+A4Pwn4miwpa9XerAe4YD8tmw1lKCVeUykbpSmStDuQGEJnStpABn8p1gFsqSW9zbT9iYNr1kRhN83/FGeqw7JR/EdtcNO26ApjI7FUDpz7+nyQE4bKJvImyAUZLg/893exfxkT72XPln+XQXiUmWQnCy2Xx0/5Korlfxk/7V2+qY6rRNpEMkBuVcFOqhF1ChnigY2FADfbjUs1C9EuvWIHQoPijcCq/yecZoZQhdEVslKxY/EKLyzyvbutmcxN1jBDBsG/5AzExGNy3kV4a7nCHl2CRbBSZm/ZyWcZ2TMkSQhzn2RvdiuspSVwkRiGSYrCA9+FrWKjf+0LFnQnmGuJxk5+J74t3GE+2nojS9MPJWs5ys4F6LIoi/jbT66ZTeauhp76Lu0/3uVOyWBc5thoDBmfwXvvOJ3+JmFHXKYXFyzIyoeZ1Z9PigNU6Pg3QNEtZaJqOV1/wL6nMoDR9K0HTPVabXRxR+2qlJ
 K4lntHhh
 ONkYH2rGSGz1yQC1XsQ1qrBA1dAQtXYxnFTbH9mhnB9C5dEpDCeDWbBy+deIVJDfG+SFuxSX1iQUTmKi+Hu2fgTRJTV2Pd/VVJal4zbegWKIc779X7E/qtmAaFUaD9QoN/ibGcfKvFIJOOY3SKU/6RDzUnyO1zfR6HmH3eh/JS3Sqlr4bplOK8AL6UXwLNeA84EetOVcWsbZ00XzuGKnJ+B7qsu8XLwAAAI0ecI82R2xR0LWoARM3z/1L09ipOB4x9HjhgjTKEYUijvg9dzsU6dTUCVVxHi/DknbSRe+LWBLbz5SJFYGwpJpY011J+vBFw0VJ58ARiQtLULGYeXsYsZIomA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/5/20 01:54, Andrew Morton 写道:
> On Tue, 19 May 2026 20:16:46 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
>> page_is_unmovable() checks HugeTLB pages without holding hugetlb_lock and
>> without pinning the folio. This is intentional for the pageblock scanning
>> paths, but it means the HugeTLB folio can be freed concurrently after
>> PageHuge() or folio_test_hugetlb() succeeds.
> 
> Thanks.  What are the userspace-visible runtime effects of this?

The direct user-visible effect is not memory corruption, but degraded forward
progress in the page isolation / contiguous allocation path.

If the race makes folio_nr_pages() return 1 while the current page is still
treated as a tail page of the old HugeTLB folio, the computed step can
underflow:

        step = folio_nr_pages(folio) - folio_page_idx(folio, page);

The caller then does:

        start_pfn += step;

With unsigned arithmetic this can wrap and move start_pfn backwards, typically
near the beginning of the old hugepage range rather than advancing past it. In
many cases this only means rescanning part of the same hugepage range, so the
effect may be limited to extra scanning work.

However, it still violates the scanner's forward-progress assumption: step
is expected to advance start_pfn. If the same transient state is observed
repeatedly, the scanner can keep revisiting the same PFNs, causing excessive
latency and, in the worst case, an apparent stall in operations that rely on
page isolation or contiguous allocation.


Here is another point raised by AI, the old code also used folio_test_lru()
on a folio pointer obtained without holding a reference. If the folio is
freed and the old head page is reused or observed as a tail page of another
compound page, folio_test_lru() can reach const_folio_flags(), which asserts
that the passed folio is not a tail page. On DEBUG_VM kernels, that can
trigger a VM_BUG_ON_PGFLAGS() crash.

>> The existing code avoids folio_hstate() and uses size_to_hstate() because
>> the HugeTLB flag may already have been cleared. However, if
>> size_to_hstate() returns NULL, the code still falls through and computes
>> the scan step from folio_nr_pages(). If the folio has been freed and the
>> head/large state has been cleared, folio_nr_pages() can return 1. When the
>> current page is a tail page, subtracting folio_page_idx() from 1 can
>> underflow and make the scanner skip too far.
>>
>> Treat a NULL hstate as unmovable so the scanner does not try to skip over
>> an unstable HugeTLB folio. Once a valid hstate is found, derive the number
>> of pages from the hstate instead of reading the folio size again. Also
>> validate the page index before computing the step to avoid underflow if the
>> page/folio relationship changed concurrently.
> 
> This code sounds rather sketchy, and it sounds like it will remain
> sketchy after the patch.  And AI review says "hey, this code is
> sketchy":
> https://sashiko.dev/#/patchset/20260519121646.40833-1-kaitao.cheng@linux.dev

Following David Hildenbrand's suggestion, I made some changes as shown below.
I'm not sure whether there are still any other issues.

--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
         * We need not scan over tail pages because we don't
         * handle each tail page individually in migration.
         */
-       if (PageHuge(page) || PageCompound(page)) {
+       if (PageCompound(page)) {
                struct folio *folio = page_folio(page);
+               unsigned long nr_pages, pfn;
+               unsigned int order;
+
+               order = compound_order(&folio->page);
+               if (order > MAX_FOLIO_ORDER)
+                       return true;

                if (folio_test_hugetlb(folio)) {
                        struct hstate *h;
@@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
                         * The huge page may be freed so can not
                         * use folio_hstate() directly.
                         */
-                       h = size_to_hstate(folio_size(folio));
-                       if (h && !hugepage_migration_supported(h))
+                       h = size_to_hstate(PAGE_SIZE << order);
+                       if (!h || !hugepage_migration_supported(h))
                                return true;
-
-               } else if (!folio_test_lru(folio)) {
+               } else if (!PageLRU(page)) {
                        return true;
                }

-               *step = folio_nr_pages(folio) - folio_page_idx(folio, page);
+               nr_pages = 1UL << order;
+               pfn = page_to_pfn(page);
+               *step = (pfn | (nr_pages - 1)) + 1 - pfn;
                return false;
        }

-- 
Thanks
Kaitao Cheng


