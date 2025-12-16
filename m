Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38C37D5E13E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000C16B008A; Tue, 16 Dec 2025 06:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC6E6B0092; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B0B6B0095; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A25CE6B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5EB0213B4F9
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:40 +0000 (UTC)
X-FDA: 84225164520.22.43DDA5A
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2CE6C0012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=doEpYVFE;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3XsPi38JsylLfOufGkUCzs+wNjb94Cd+MzQkDx8S1TM=;
	b=x7iQh/FSbVPwqmE9U3bGPYfGe8KjnbZ/rRX382UnhXXcW7/j46XwzBGiwSHnC/rUsDNUkd
	LlW7EPVp2ty/H7zsPSY/BlrVqdRt8Q8pXn2qCQH43ftYOMnadoH3RMK79y3vocIMqKon7m
	gTi6VNy1DGYJEE/P8ldKLv8AT8ZvGvU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=doEpYVFE;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885778; a=rsa-sha256;
	cv=none;
	b=RjWivHbngK3qaSnkXnRy7Jd8N1Ra0TTY0sw/ldPJHlxcOE4S5CP2wvLcy4YrEXCwAnNz+3
	CzO0FCiXN4JeiQsAddi70QIrUDN9naC6SRwck9cJcL3dVV5DPBGC+GjsWtI8PCogsqSnjF
	DffKpv0smATJ9UCz6InxvseVQtR0vP4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3XsPi38JsylLfOufGkUCzs+wNjb94Cd+MzQkDx8S1TM=;
	b=doEpYVFEvjf7Mjfw2OZWl3uWH9cDQGJky5/fTQEM0aCMI1qLU+NjokJg3kCYVB40gLLFoturI
	4VQuYyUQGNGXk+p2PGyMhkhLtn87gekBtSL79Uacg5YMnBBMgBAKD+0BeN/31FHZz42Mx2i+CDK
	ekmV0F7PiD03RnQGmMO5SmQ=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dVwCR1kpRzmVC8;
	Tue, 16 Dec 2025 19:47:31 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7DC3F1A0188;
	Tue, 16 Dec 2025 19:49:31 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 19:49:30 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v4 RESEND 0/6] mm: hugetlb: allocate frozen gigantic folio
Date: Tue, 16 Dec 2025 19:48:38 +0800
Message-ID: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: u69c5jrr6pzp65eeh9jamz9ow6gwheax
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F2CE6C0012
X-HE-Tag: 1765885777-543644
X-HE-Meta: U2FsdGVkX18JJOSf5QwzOc5qsPjon45vr2sD4Ylbpx4VvIhq6GTTm8SsCF6GsjUouet1zcReuwJd1XIcBK+N+m+C985k+4qqJksug7ge3reMHEkXu4sj8QMBjacyMcVhrDyEDIrJkTU99EWJbPLujzFKMBH5Nk1GYZxi7xWesvNN0pWywIsoTlpDaNR13/tKgRcaCaXUPlbzUpQXtCyNP6IUpRpF19Fxg7Ff838dqt3YWp8CJUIWtS+ZRmx6mkfsOGMA/TMsawpt0qbO00UUP4cJUBNfXNs3suA6tl/bbE6eyePW1v9z3Px33yKgRjYiFfoMbxyrrW+Ghp9y8Om2gUh80s5EiyQpTip+IBYTNLenmsUapHZkaCkGfpmr02Q5KKWsYAofiO7RxGvRR2rYfVS10yYt+Pl6LPUoGL1Nhzx9kmVn7gIBflEo/NH9gpsiobnYpU2WwashnTLgBKmvmnAurVEe/GJPAVfjXLRzSxVkc9NN1vsRMZBlIYPkvicG7A5FzrglZljO69H5oSDtQK5fwMbjUavzIBpQyNC3N1VAZqUdvY92RYyBUK7ZJQJ6rFfjWvxqpSZijoZkNql6hN7qSC8yqO0EqYI6xtlF9gbp0YQeotPM1bSNxf2KMEHDcibL6s7lom4zqyELATwoGK6yFkldLsYUkHrlBMOMDUXxT69GREq3ecEAxo68xtyPFCHJPdXitJJo5qCA4Mx5YROgtN4jQ78UB9IcWjeaBOgT/7unxsekt0giLeNO0WwcupSdbSfRK74urNNyDC0SDQAV80qaCkrh/RSd9cI0/KC67MD1aFDDYfJzYYQ3snrmMc+/Y9jXr8C41Cv3GjVBaWzFUuoH7uR3DjFgADaZ8jUk1+JG+YTXgP+gWT01+BqlhWCQXa+ACSV9RAYoNVwg/rz94lRHhp24ksmt0d210uNCdsusAfIRWkJyCzlusAlLsXWKGYxnDtuy16E19pk
 vDx3qZSb
 9F43MD+BF1eJRvc8uLdmUGPkexLgA/d/HXZuX4mLoyehCSpRRqKNWbXRZYwva24C4iNf2JlPSRHR0jPl+rPTTwSb9LY5mYLVlQV6KWOPbUUMsREyteACIlRiS6/EmdFkcMAqxLfQlrczvBcHjdwhFh+nWIHCvEbdx1y5ljJQuehIEahxL3Phm3ZudL2l6xyJ+suKokmsCxyT8Hn6SISEA4BzoAfwMJWlU4HZKOnIxZu2nk7aJjLyNfzInmXj8ljlYG05zAbLAN6mf+hM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
which avoid atomic operation about page refcount, and then convert to
allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
the alloc_gigantic_folio().

v4 RESEND:
- fix set_pages_refcounted() due to bad git-rebase
- rebased on next1215, also could be apply to mm-new.

v4:
- add VM_WARN_ON_PAGE and instead of VM_BUG_ON_PAGE in __split_page() 
- add back pr_debug part in __cma_release()
- rename alloc_contig_range_frozen to alloc_contig_frozen_range, and
  make alloc_contig_{range,pages} to only allocate non-compound pages,
  the free_contig_range() adjusted accordingly
- add set_pages_refcounted helper to reduce code duplication
- collect ACK

v3:
- Fix built warn/err, found by lkp test
- Address some David's comments,
  - Focus on frozen part and drop the optimization part
  - Rename split_non_compound_pages() to __split_pages()
  - Adding back debug print/WARN_ON if no cma range found or the
    pfn range of page is not full match the cma range.

v2:
- Optimize gigantic folio allocation speed
- Using HPAGE_PUD_ORDER in debug_vm_pgtable
- Address some David's comments,
  - kill folio_alloc_gigantic()
  - add generic cma_alloc_frozen{_compound}() instead of
    cma_{alloc,free}_folio

Kefeng Wang (6):
  mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
  mm: page_alloc: add __split_page()
  mm: cma: add __cma_release()
  mm: page_alloc: add alloc_contig_frozen_{range,pages}()
  mm: cma: add cma_alloc_frozen{_compound}()
  mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()

 include/linux/cma.h     |  27 ++----
 include/linux/gfp.h     |  52 +++++-----
 include/linux/mmdebug.h |  10 ++
 mm/cma.c                | 107 ++++++++++-----------
 mm/debug_vm_pgtable.c   |  38 ++++----
 mm/hugetlb.c            |  58 +++---------
 mm/hugetlb_cma.c        |  29 +++---
 mm/hugetlb_cma.h        |  10 +-
 mm/internal.h           |  13 +++
 mm/page_alloc.c         | 204 ++++++++++++++++++++++++++++------------
 10 files changed, 296 insertions(+), 252 deletions(-)

-- 
2.27.0


