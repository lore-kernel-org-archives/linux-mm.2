Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C527CCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8E38E010D; Thu, 18 Sep 2025 09:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279A68E0093; Thu, 18 Sep 2025 09:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6EC8E010D; Thu, 18 Sep 2025 09:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06D268E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0AA756947
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:38 +0000 (UTC)
X-FDA: 83902430556.10.36EF5C1
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id C5E7F80012
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=zk13ZU3mZ1X4HyAw07uf6o3aLbkyJIq1/32XdbIxBIE=;
	b=XYMNGhtXpKCJIq4PT/AuhQ811J0ahNucXKSeuRKbE3Xja+b7jTpKdROXza4USQUOLkf5BH
	yUM1L68Y/CmrWl50q/baDoKolNMYrZetVyBY0zlGvNCfdYjK+FgdgP/lRgeRB1jbBgATZ/
	HZh30D8C0vqDk0Foogx6Rlj9xGnPe/c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201636; a=rsa-sha256;
	cv=none;
	b=bvP2ceSz4LDvfbwPf03TQw7d8hFFPRrr61k7Oh1SHuMRKm8FWtyg9Njqv9Wu+iwxpLqTYJ
	iY9PdQHSUUFb/6NjaHexD94AYi+cp0/YRQVQ8kRXpg8vrVL0AMIUSrvdyTZtbIcHjgOWNn
	Ma3Aoue4aeyGq2mcG9Br6bQ1R59fEt8=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cSGNT3r5GzRkQ3;
	Thu, 18 Sep 2025 21:15:53 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 496891402EA;
	Thu, 18 Sep 2025 21:20:31 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:30 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 0/8] mm: hugetlb: allocate frozen gigantic folio
Date: Thu, 18 Sep 2025 21:19:52 +0800
Message-ID: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: C5E7F80012
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sxkxhxehdrn5z7fwhkzfd9amnjrman64
X-HE-Tag: 1758201635-728179
X-HE-Meta: U2FsdGVkX185yABDdJAI0lqKJAzfK0RVPeY9gXK45po7PNe02rpEhTYiqDw4dH8+3CQg7vl9k/gXUyiIEPlLieGJVGrEy+X/9yKY+vSJ4Ocut+2DkzBEUrald4pGtdiejTZgqEGmXkmfexnxw2zmgjbDbjO0j/CYzeYMbQmO6mpJq/ciG0CeFEFh5VFdM8ynu+S2LZayC27UA6Y1arZmQMq2i6O5h0vjeuZT1yfZRTAYFanz3bfpsM5mFJwkJhhQAqdx0Vvxpgf340tdPp+0uBkv1pQvLXDat8kzSysfb+8zVPhBrEngyv/78PAciqqmUBqE8fp2+Dv3SymWdeRgORAZCfR14yho9eWJRCzhn+DOkbCUVkPB9phsxe/uXis99B1HETohGoLyQQ7vbnOaWhaxnC20k1Y8iaMB86NtxR42gAOaghJuWR4DRBnfIjuN/xv6XijNSToCOnSCo9d6/kFsVWYBgltywl16nxy6z+u4dAdFPUU5TYFeUN3oUJuxH7k//rtjhs4DL5s/mdfcuuR7vWk+PJJx1yLWq2fK7qJqJif370BzTe9hxTvGiLytwOahT1NsC87OWYNtRTcnhsSTGPX1Bp0htDC7QN6f82oOKHQ6mWc4yDLKTtNiCltmNdMCYgvCDYBLKjKN+Iop3j89bNloZH48PIesbQoJNTEkZGOj74vnnl9wnxydexPGSSOWcGMqWXuhC27lxfHfb07tc8eIFonMCcL2aNkpSrGZgByKkaIQ6r6zMqEEFZuTdrOf2SnJI+SDhponSPyywZW0AaDz3xR+mRzF+Hy/SXXEbiBLWr7z2JSnl1cHuKyYtQz/EISZeB0kZ3CrVMVuI+3QTIVpHl59jSL/q5WA5AjpeCSg+lNvAy+OMhg11umEV9CQ/QA2Z79oe841zjWWqnmweoBufEWmfvfbOKzOxS30CcM+sIqskUAwjR/0iCGZY+1pp7XOfACqWX4Jo71
 FZcstAy9
 lXnakof0njICmyyI12I9dzBBSgvh9wsJ4t3js2cFbvyKj8T7VCIGyfXkZyK8rBH7vh6GpH9PyCPB/0OvNl4Iz1Rvl44/pCOBPrAjJOLVVESP3mkv6wvs/mDQE6CqRidb/CeB+j/2Lr1NZ8fOPFRzxp/9Yikj+/nrBDRTVXTqeYSARoDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Firstly, optimize pfn_range_valid_contig()/replace_free_hugepage_folios()
to accelerate the gigantic folio allocation, time reduced from 2.124s to
0.429s when allocate 200*1G.

Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
which avoid atomic operation about page refcount, and then convert to
allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
the alloc_gigantic_folio().

v2:
- Optimize gigantic folio allocation speed
- Using HPAGE_PUD_ORDER in debug_vm_pgtable
- Address some David's comments,
  - kill folio_alloc_gigantic()
  - add generic cma_alloc_frozen{_compound}() instead of
    cma_{alloc,free}_folio

Kefeng Wang (8):
  mm: page_alloc: optimize pfn_range_valid_contig()
  mm: hugetlb: optimize replace_free_hugepage_folios()
  mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
  mm: page_alloc: add split_non_compound_page()
  mm: page_alloc: add alloc_contig_{range_frozen,frozen_pages}()
  mm: cma: add __cma_release()
  mm: cma: add cma_alloc_frozen{_compound}()
  mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()

 include/linux/cma.h   |  26 +----
 include/linux/gfp.h   |  52 ++++------
 mm/cma.c              | 104 +++++++++-----------
 mm/debug_vm_pgtable.c |  38 ++++---
 mm/hugetlb.c          | 103 +++++++++----------
 mm/hugetlb_cma.c      |  27 ++---
 mm/hugetlb_cma.h      |  10 +-
 mm/internal.h         |   6 ++
 mm/page_alloc.c       | 224 +++++++++++++++++++++++++++++-------------
 9 files changed, 318 insertions(+), 272 deletions(-)

-- 
2.27.0


