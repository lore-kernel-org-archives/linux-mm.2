Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD674CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273DA8E0027; Mon, 13 Oct 2025 09:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C098E0024; Mon, 13 Oct 2025 09:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188B68E0027; Mon, 13 Oct 2025 09:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08BA78E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:40:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94EEF119F48
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:41 +0000 (UTC)
X-FDA: 83993201082.26.F7843CF
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id 844681A0006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="buC/ZxMK";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760362840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cxwz7L0SH5ZESGDk+uKVTv7/1z+i9//+4Er2SbWA3To=;
	b=oF0JGQt0dSd5ic/ZM7439rqG38XJyH3CJg+nMLS/ItwUuy0MIDurWLgN/+tVh0FHT69BVE
	qk+Tz6zL5zM9wjaMgtA5GA+69UuX6hxa0C89oaJNyFG2vZyaJXvTaV5pQFGMSldpxEg6jO
	oUoerjgMAyCFyCxyNDLmowA8EKS4RIk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760362840; a=rsa-sha256;
	cv=none;
	b=wvnejise8HhugOM207qaGnkZ1k1jetRsNRMSevKuKD57UDNz3RpJbNBUQHjDUZ4ENQ4vki
	T8WgmPXnZykBSiypiaAE/szs2tTBaVhQ6mQD3PuEdDsYaXs+ph+BZ02jn80rUvFH0OO2xP
	wRc5dsyiMbzFJOANOOLG6P7nsM/PF4U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="buC/ZxMK";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cxwz7L0SH5ZESGDk+uKVTv7/1z+i9//+4Er2SbWA3To=;
	b=buC/ZxMKrkXUsLjpa6ilkQxhyt71K8S6f7cjv8cjijpfYtWTPXtlsnQ+ds9X7uJw9mGPP5rvI
	7Zg4oqGtbffFU3qo9M3bBKXq7yTTI1mjLfL0DEeV8VVALfRGMEgxvevLcWZPqbf5KF33nb4XWqv
	VkWlNeH4S+4ApGwAQug0fXw=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4cldl33xYsz1K96c;
	Mon, 13 Oct 2025 21:40:15 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E9E3140279;
	Mon, 13 Oct 2025 21:40:34 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 21:40:33 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 0/6] mm: hugetlb: allocate frozen gigantic folio
Date: Mon, 13 Oct 2025 21:38:48 +0800
Message-ID: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Stat-Signature: oaqtikws5xegq5oqhchthaz5d3erbg3d
X-Rspam-User: 
X-Rspamd-Queue-Id: 844681A0006
X-HE-Tag: 1760362838-739152
X-HE-Meta: U2FsdGVkX1/r9TcxudFedrFrDiRowbaJeGVjTYfBuXnXkyPZVrIbUBxG5e9XV/ELeGllmZJZU/1SJh03Dw76oWsB8c1tIejDL3ztTKocEi7LZ0m8zpjsy1NVihuosZwi54DAAuT7PF4X+O1TKhhXov0DS9a8g36pNjuS4/2jElV/DVUgcNIC9aOAj5X/Ukp/5j/OoyhIu5d0ejSuTyW3hcd5iZsHCxf7eCWG/xdsgaHkz0BQZHQZF6+ppSN3DaBlD68XBgPSiNh3h3nEUh526tIsgo2+aKQ2+S1aiuHqB0WoVfMbZTY442KjIr+lA1UDla3Ug5DxlW3Bu+LJxDraTvs9eChAUaK8VpJhvcRutQraLVb31hh4WeyNN+unR1QzEWCgo2mwr5qt7DKQoAGqAqSEAIq0xKHi3yVs0OeFEJuU7taCNTWfW88gPXsTsJyVY1UeKKh+j0AHpzjvz8+DaQ6Bus3/fCc1ZCtMoXZXV6YvgPF1xrjMRw/quaIqbdqnGPbLfbejjeFQ0BKSkq55q5MQRHdeUgtrPEzKMURudopVQegHx+o4xCa5WXf92rZo5AzXJmxDRgBVjMA/zaITbyxMGVpOW/2e4uVk5/JzhF1LgdlDCMdm7eOdQAePtZrMNKvJ3aXRoOP+gNqtuIPalIENvgk9izTOe1YGZo4MnNr3/93bB8Khce+1QLCQX56cflYxJzNLNW453gSDvZC+3ybvohz19AoaT82DV7FQwdQyIOHMIKQ+WXpEsz1ij0V1wtOOHs2K7haZGhHBEVs94qHEQVBDT0CcwhyQ9kEn2x43dtrvtaZt+KLvcauJeYY01NeSup/XUqxeTbAUiBaGFglrQETsXzYmVjXTH4fTuNJUUaFgCvEDKxbxS56LNDNWJ3cuDKjODknBjdm2KbsFf6ujLIoW/olw/HE10GbziJOjIpYTzXP1jiieYCNNJhDa9LwfTBEWPjh/nn7jcxr
 /xg==
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
  mm: page_alloc: add alloc_contig_{range_frozen,frozen_pages}()
  mm: cma: add __cma_release()
  mm: cma: add cma_alloc_frozen{_compound}()
  mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()

 include/linux/cma.h   |  26 ++----
 include/linux/gfp.h   |  52 +++++------
 mm/cma.c              | 109 +++++++++++-----------
 mm/debug_vm_pgtable.c |  38 ++++----
 mm/hugetlb.c          |  58 +++---------
 mm/hugetlb_cma.c      |  27 +++---
 mm/hugetlb_cma.h      |  10 +--
 mm/internal.h         |   6 ++
 mm/page_alloc.c       | 204 ++++++++++++++++++++++++++++--------------
 9 files changed, 271 insertions(+), 259 deletions(-)

-- 
2.27.0


