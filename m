Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EEDD167EA
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108986B0089; Fri,  9 Jan 2026 04:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A77A6B0095; Fri,  9 Jan 2026 04:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F0B6B008C; Fri,  9 Jan 2026 04:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDBFD6B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:32:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 697DB1403AD
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:32:00 +0000 (UTC)
X-FDA: 84311908800.19.7DD06EC
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf01.hostedemail.com (Postfix) with ESMTP id C18094000D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:31:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="zP/0GRwZ";
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767951118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lkNDHLiP6cFwi6jAkoaTwV369nkoEi9jsL/b3FDfgr4=;
	b=dFBX79k+d5n84kgV/FeSPUgjuznRnjrpGd/41+Ca3y1XS86YDfHMVTsqdIbuGAVn2h/dQd
	MUSsrCpguLqh0QthLnT492BDbg82W6UcSZqUNe1uPp5523A4oR+l1OkBlh4/rGxYKkKW4x
	Q04Ygmxnr69W4roz/Yb83zmwWjt64eo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="zP/0GRwZ";
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767951118; a=rsa-sha256;
	cv=none;
	b=olIbVygY8PTra0JGLARFscRxL/W10ZdOBJaquRHEz56//MsKwr6eyimdLEvK14zJqJhwoB
	1qe14GET53aTLs5gyOxgCIFiQM/kpTuRHQSbQMPlXeOOFOcDsfex2TQBhuBujkkzBW6MSQ
	AV2iIf+EM1XPx2Kqjp8TOGCPC6irldY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lkNDHLiP6cFwi6jAkoaTwV369nkoEi9jsL/b3FDfgr4=;
	b=zP/0GRwZ/rUxAZQHZ/XIkw89rcBmApgl3khACIM6V3m0RFRz7bxC7bGgBars0HATsDMRuYi8l
	ak7qcxYx4+fNT91C529U6MUOV8CiQpJ636DqwNdiC+pPqs2pHhnz/U2GZhoA/qZU49t07ICNFJE
	iTgW4vyK/q4SOxMMSt8TPsQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dnc05284rz1K96q;
	Fri,  9 Jan 2026 17:28:37 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D42A640565;
	Fri,  9 Jan 2026 17:31:51 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Jan 2026 17:31:50 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, <broonie@kernel.org>, Claudiu Beznea
	<claudiu.beznea.uj@bp.renesas.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v6 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
Date: Fri, 9 Jan 2026 17:31:30 +0800
Message-ID: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: k7cpcqx541t46ij1iya7nqfpawek39q6
X-Rspam-User: 
X-Rspamd-Queue-Id: C18094000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1767951117-772727
X-HE-Meta: U2FsdGVkX1/cMDuN687QvDVkL9Vxp6Dwv/I1OsjmYNJPX4+ka6hXcRa1VDTnG6q1Zv2UfCPIuiVAlhE5BaHuYY3a8OmgQzkEA4mUSc9pZKhaMBlR83m01ZYCj6Ec+BAldxceOy75EVS5eG6t/1XveXL+uYgf14/KX63jfe6SJglxicZZUo+MkvZTBFhq9Pe9AXc2225DAeWsGk51Ibougw+UQnzl59B2ky6bs86Sa0wFITFaVllGAPSJ6fWl9Q9rVzocHUMOsgUQBFbr0wrkpFi0Xkkzg6tJ/zlC8GU2yWXy5ditatIYQJZLqpFrd9nMv1PiW8kFsDGffa6qh1wVSTNiHloThcUwcG1tM+4o8Yy5R4nyrFKX8PIPC/DgIQQGyzB0cRISfBbg0nUhrMeNSy7+IGaFwCskDBSNjsdqh6xmXWWOnCLNa5X4Iygi2Gdtx9GAjr4ll2ZbV5L8AxH2JPZIfYnEbK+GoiZx8s0hSbhcMElsVk2eiOHeDYzVSG7u3heeyPsrct0P7ytPMB/eph/6alc04wKN+29wYeCzEa2SZJjBm9ag96ge6iwm/DIzcTVtk69uk7mWxaVp84blaF6PIBKm6KmL3iQQ95Ndipxe5Hj+mzxJpBB3QJO2QLBegruHwn9plvtiMuxW22dQc6OUn132Om9qORfRUv2WWTVu/9ISPJ6iJi4KMkTFEXFpfMKwNrhVy2w1bh5SyZVmac9AoeVKvh7fUJ3C0g2QOwFebvsuTM7bbnX3ytLFdPyyYJE77m+5/EUtll3SsHcwQd3oHHY/N0tAyY455C4ZKyFbhfHYHAwG/iJkJQmxmAcWelyjaEmWS68moBtci6zIzzQYv0Z8hfnrX+5dLnQtFJsPW2e3PmHhuCMBHMvtVO3Yu7QAq2mA3YxXcJuSvEIr1SLb+QZwiFbWwaPBLbvTSImGJQWglQAk8Dc2zLw4kek1cYva9ktgcrF9BNwja1L
 mkEviRbv
 M1X1x4iiTlbcpmdvWnMumGfkooSrkJNLMCJ4D9OleJCva8xb1hg13toBjOHJqYAAVsyo13poQlEbyIyQG27WPvHou1F0T07A9vyFwTnkEZYhK744+9WHHVw0L55HKZ33Zo68cyeEd7b1I5jbj3HrBmXAU1Gh4gZ1FZY36/lH5UDnDn3+ZQOZaM7M4kXNTkz9fYCvR3Y4sONf5viK1ic1iirCUxnwIgom5mNVyxl66yvUy5YwZPNwGsw1eMXE1/D3Ibj1iwMOaq7Qy3o1f2AdZTI7t7kKiwZxW84TDScRfqxb89yM=
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

v6:
- fix crash due to wrong count passed to __cma_release_frozen() in
  patch5
  - thanks for the report from Mark/Claudiu/Dmitry and Zi's quickly fix
- besides hugetlb/hugetlb_cma tests, do more testing with cma_debug interface
- rebased on mm-new and collect RB

v5:
- address Zi Yan's comments 
  - convert one more VM_BUG_ON_PAGE to VM_WARN_ON_PAGE in split_page()
  - add a check to catch a tail page in free_contig_frozen_range()
  - remove __cma_release() and update patch3's changelog
  - put each page’s refcount in cma_release() and add find_cma_memrange()/
    __cma_release_frozen() to unify release path, which make the release
    pattern matches allocation patter
  - rename alloc_buddy_hugetlb_folio() and alloc_gigantic_folio() with frozen
- fix wrong node id passed to cma_alloc_frozen_compound() in
  hugetlb_cma_alloc_folio(), found by lkp
- collect ACK/RB from Zi Yan/Muchun
- rebased on mm-new

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
  mm: cma: kill cma_pages_valid()
  mm: page_alloc: add alloc_contig_frozen_{range,pages}()
  mm: cma: add cma_alloc_frozen{_compound}()
  mm: hugetlb: allocate frozen pages for gigantic allocation

 include/linux/cma.h     |  27 ++----
 include/linux/gfp.h     |  52 ++++------
 include/linux/mmdebug.h |  10 ++
 mm/cma.c                | 122 +++++++++++++----------
 mm/debug_vm_pgtable.c   |  38 ++++----
 mm/hugetlb.c            |  70 ++++----------
 mm/hugetlb_cma.c        |  29 +++---
 mm/hugetlb_cma.h        |  10 +-
 mm/internal.h           |  13 +++
 mm/page_alloc.c         | 209 ++++++++++++++++++++++++++++------------
 10 files changed, 326 insertions(+), 254 deletions(-)

-- 
2.27.0


