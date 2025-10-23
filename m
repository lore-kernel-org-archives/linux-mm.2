Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 333B4CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28BC98E0010; Thu, 23 Oct 2025 07:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0924D8E001A; Thu, 23 Oct 2025 07:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E738E0011; Thu, 23 Oct 2025 07:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC7248E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:59:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 698861A0AF6
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:57 +0000 (UTC)
X-FDA: 84029235234.16.ADB787B
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3B2431C0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=F21wFu1fPx1E4rRMjVYKiKCqqm2QpXz7tSsmOb0YZGY=;
	b=GRCwYxuni1P8PYXk8PDINa44uSE0LZF+sjSNUO/zu7jgZWfxx5qM85/18eq2d6kwPxV6IR
	u1hVwK06UfqD00nimnlk3Ff0qdq0FW2xxXL8B1utFvvF/Srn5uxBFd31TSeJzv6GDE1oQw
	XVtawOifxdP7TVaXjQ7obClHtr8eAt8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220795; a=rsa-sha256;
	cv=none;
	b=t7IHpn/u4jm9ohb1K9u7yFL374p1RCgG2GNDaDbWIojDlpgGHaXbMrdU4LnWFArgZ0BYHW
	o14Pf2PnVI7yLNtiLHYBDlICLZ25b8yiQXvEFjIIHv1ZSopgVedBCbViQUlr8/yfwrhXj2
	ZEaZoWOWDbUpvXKkYv7GN8rS9yy87r0=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cskx54nW0zRkGr;
	Thu, 23 Oct 2025 19:55:05 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 90C6D140143;
	Thu, 23 Oct 2025 19:59:48 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:59:47 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 0/6] mm: hugetlb: allocate frozen gigantic folio
Date: Thu, 23 Oct 2025 19:59:34 +0800
Message-ID: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B2431C0002
X-Stat-Signature: ma7h1wbt5d8gx36wouenbqyn5jj4466a
X-Rspam-User: 
X-HE-Tag: 1761220794-338557
X-HE-Meta: U2FsdGVkX1+KeV9slIMNdxWy0HsODA7QGyz8spT7L7VRZveiWXgSDxRZT/cmHHY9WLLJ8KWw7gTvNwyKzuF7SC/Bgtr4bF1NwCIph9VzEnTny2EZCP3VEsNjmOpZYtFlSR5E/ip43mfd1sRcpccwM7boiYJsOKI03xCyMxSkhwSGp3Rb3Mr9QWdGmKlBBYO+Yc74TltlhvIw1fCHc3k5Vj8EdzPJmFgm3RvmY1Cr5TC6LwqjstArQJUVbh/FCLOfa2CGFFMObbsRPox1IUOlOoDlRKte8SBDQkVUK0PAk6jyI8SZHdI9S7UBfjtQPb6Ym5G2iFhip0MEKFfGRhTwj+644duYB18RuQhFYm4JMxBzOqLCfonMcRKVLL0EeH1nlF6vWif96XzNHHL0KQ08BvFh5tPjwlDYkLNvo03zMfm5HBnCzLdz7UB6G2AC228UXFcAMCM9qV+DiwYMv95djXBC4wjYweBSssi3Pnuyhl/Bf795FFFNrAOiw2D+5mcPouTn8rjjR13ymg7rYyx39Cl0lE1TzlD5sVCTMX79ovRcgPdoYCy8TO9xtCqTJgeqItSC9yGbiwGRzHRRtZFpxAVLA9uagdzPB7axGcK4hE2pAd2a5wlPgaLvw/W6R98mvjPKKvBCI6zCD58OPOTy3nBf1S1hDtq5ZzdNU3MEfqXEm8b64wQpgkyOlqBEmzQqgDEK8TSrFGF1iLdRitk6FLKEkqLBgYAYBWylh49nEoCJfLkdFaf7r6jtdJlIvF8DCcZyP/mH6J24Vl3m8ZeSL1u+HrYKxjaZJQ9L4uSEpL++6YDzOmCcetdQA56n15w0Zj+bL1y674gEoYOKo0ThLNsrjGBiBQgppU/ylfAOvBlUaSOyLuq6xIBZ1BzZIRXHmQkLrcid0MQ=
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

v4:
- add VM_WARN_ON_PAGE and instead of VM_BUG_ON_PAGE in __split_page() 
- add back debug infos in __cma_release()
- rename alloc_contig_range_frozen to alloc_contig_frozen_range, and
  make alloc_contig_{range,pages} to only allocate non-compound pages,
  the free_contig_range() adjusted accordingly
- add set_pages_refcounted helper to reduce code duplication
- collect ACK

v3:
- Fix built warn/err, found by lkp test
- Address some David's comments,
  - Force on frozen part and drop the optimization part
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
 include/linux/mmdebug.h |   9 ++
 mm/cma.c                | 107 ++++++++++-----------
 mm/debug_vm_pgtable.c   |  38 ++++----
 mm/hugetlb.c            |  58 +++---------
 mm/hugetlb_cma.c        |  29 +++---
 mm/hugetlb_cma.h        |  10 +-
 mm/internal.h           |  11 +++
 mm/page_alloc.c         | 204 ++++++++++++++++++++++++++++------------
 10 files changed, 293 insertions(+), 252 deletions(-)

-- 
2.27.0


