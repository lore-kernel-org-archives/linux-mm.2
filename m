Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E8BCA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607CF8E000D; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B86E8E0001; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE228E000D; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 351288E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C03B81D8949
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:17 +0000 (UTC)
X-FDA: 83844290754.18.6176586
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E3458000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=pd0SG9z6SxX1Fs22mHSexVU9kUnNbF4bCLhn9FXe/lw=;
	b=hg9Of7PnPvqPasOFPuJaD3VZwZXDPlBiT6JuAroqVVFFcykhahdID9CQxDAovlpptBiuMW
	Ik6uT2+q2Pi2Gj+jtGlNEo5fs4I9SZPM2IsrnoIIchTixJ0Whb6kN7G9bzrfU0jy+JH3MZ
	ARprbX60JtyY/cBNTdPL1SYx/L0AhU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817356; a=rsa-sha256;
	cv=none;
	b=7/4x5RKu04dZAXR2YH1+Ef4vTkOw10TDAb6PEHLM4fGccGhKo3nxdhhHkdfOP3UZgcUtP4
	s7qo/rHpNbZPSj6NUdsdk+dQqwLfseWldxQaZyobQkrnqTeGmKQNDghl53aE2vGRQ+TK49
	LhdzBgBSmlCGJ3ns67Y/zlwDOaX1VDg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cGQXr61zmz14Mlm;
	Tue,  2 Sep 2025 20:49:00 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 881D8140258;
	Tue,  2 Sep 2025 20:49:10 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:09 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 0/9] mm: hugetlb: cleanup and allocate frozen hugetlb folio 
Date: Tue, 2 Sep 2025 20:48:11 +0800
Message-ID: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E3458000E
X-Stat-Signature: 4j84rtbka47cmuj8jpo9i3qiyjgmkotw
X-Rspam-User: 
X-HE-Tag: 1756817355-102127
X-HE-Meta: U2FsdGVkX1+awUjfXx3y/j+MHMATMitBRD1eSKNSqRlWxe34VbevnA14Gw1SGDM9bhs5gpYortokALvozmBWM/IQk1Sb3q7cXzPf2FpAc6OiFILGFs7dn4EPpPMF4LenEvvHE5sedqOZOPkFTIKO3cOT2JUZYnmfOP6/ynuTkORoe3NHHE+qsvucwKcE/eQF2wfBQetVjdG1L+nirCSfsoU41VSktFnnF5PXxc5TaMQJqYwB1Yq/c1G4QTQ+OqoS1r/fEbCjceTkKr5ljf8AYAAtEk1R3TdsGAqtd1M9WzEDv68/bqL2Hzz0ROEC80Kc3IBuwvDlB7mSth8P7pVj6oH6esADVBfpcnzUF6iUZf592YMznTeiBsOjGlFriVL/xv7Q0SDpPtrXQGa9N3T5wurx+aQDHprdeH+GjHEpe3XoIversklyJY6ghdCm58PcHhK03bHCmUitnD02ZzZkBjIcKx1Ql1eY1vmOqaEfVOD3P+sQR2C+p907e4KUIvjlvktN21qgCELqK0R18bMmgS/DER0/KOTCwjGq3u4Okug6RuzSw8J0YreFzDOxM7S59RoTm/Rviq1lA8o2xA3c1YvHGtEOPcBKajUH2aVq1gky1ZHYF/o/ldz2T6n28+pPPfCgGNOsN5celeOBKyLT0vyDD/efxMqSwqPoI4CjBdc/L4Cilc6kOxPuoAb3gzdcnZ/fa5tCgqu6F5twD3dY/j+SXPu0fooyxvlD68D8C+ZHU+jbYZi0mIRWSRYjZn44prUbGwc1+5vBXDgER8pbp9N0ugopPXXTNeKuU3LYcrGJfzAwwCQ0HzGaQ9EdcVw9/407s0G/e8VCT9w3k8q5pnTykBgYs8xuN8rHB4dgyeS0o8OEschuGcTGbZFO78J0FnZy36u7+IQ2xXTRzovwzwEtzmShGN/x/mkliCm/0gI1m7b8zzIwntp5wZRcVw/fD+0vCwZ7VohYNlwi4iI
 xeux7SBR
 w62FuqCRZARWkmX0kYvTOtMJEOyLWrEUv9yil0So9A1DRIEfa3JdivUOaxDGl3iEuLD2eJNiT9K4EATgFeyLsBnzuqdecOLR3QG0mPMcqtFgUCHmb8klWlgAH1hlbeZfKciiBZIRf6N+x0oJXHIY3TXDQ0EUkMGHR/cgWe4R8CijHKBQt+1MZVYZqPwoH3wQ/INVf9qhZiSpHAOMBAOiB774K2yMkNcbQ1OaehX84Dlq+hiive62mR7+qB/K7INSVGDdI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first part is to cleanup some hugetlb folio allocation and the
others convert to allocate frozen folio in gigantic folio, similar
to alloc_buddy_hugetlb_folio(), avoid atomic operation about folio
refcount.

v2:
- Add RB and address some comments(per Vishal / Jane)
- Naming is hard, so don't add hvo for alloc_fresh_hugetlb_folio()
  and only drop __prep prfix for account new hugetlb folio
- Add ACR_FLAGS_FROZEN for allocating frozen compound pages
- Refactoring the cma alloc/release to prepare for cma alloc/free
  frozen folio

v1: 
- https://lore.kernel.org/linux-mm/20250802073107.2787975-1-wangkefeng.wang@huawei.com/

Kefeng Wang (9):
  mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
  mm: hugetlb: convert to account_new_hugetlb_folio()
  mm: hugetlb: directly pass order when allocate a hugetlb folio
  mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
  mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
  mm: page_alloc: add alloc_contig_frozen_pages()
  mm: cma: add alloc flags for __cma_alloc()
  mm: cma: add __cma_release()
  mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()

 include/linux/cma.h |   9 ++-
 include/linux/gfp.h |  20 +++---
 mm/cma.c            |  84 +++++++++++---------------
 mm/hugetlb.c        | 144 +++++++++++++++-----------------------------
 mm/hugetlb_cma.c    |  14 ++---
 mm/hugetlb_cma.h    |  10 +--
 mm/page_alloc.c     |  85 ++++++++++++++------------
 7 files changed, 157 insertions(+), 209 deletions(-)

-- 
2.27.0


