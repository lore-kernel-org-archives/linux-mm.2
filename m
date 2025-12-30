Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D47E9411C
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 07:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB206B0093; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250826B008A; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0893A6B0093; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B629E6B008A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13F9713CB6A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:54 +0000 (UTC)
X-FDA: 84275300508.19.D8BDF73
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58A45140006
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=E2ea9+LE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767079492; a=rsa-sha256;
	cv=none;
	b=iNMLHV1TuWsJ80vdo+vtVfS8WGOC4ckAwOa/X0dS4HQVPAxQivQKWmXXS3kyX6rA9ib4Hf
	TyY2pW0gkK3aD8pvw32GdnOENUCD/Bd4WoqEyaWD4rERI8JM/TUtIoCK+Z9rpB+5zeV/zT
	SkC9DGFGtCmRgtPIcISFm6MEa2kEc3s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=E2ea9+LE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767079492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qt17zJqMIYF4ND4byHpahoXQQop3mtjipYg/HgqWZ5w=;
	b=BCWDeUYMVaJ6CXvAXZkUAfcscY2Vxs8ZS58NKcCT60VpBe43SDNMD/DJF3Y0mnC5q7i9k+
	LV8ZFhKdvh6fTn1LA6v5F5kNC0jLcn5wFPffg5MF5M93DBpTk5n0cU6p4vfxbPD3U5TjZC
	iZ86KAX1t5eAvUSaDfuiJvD5GvOkoQE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Qt17zJqMIYF4ND4byHpahoXQQop3mtjipYg/HgqWZ5w=;
	b=E2ea9+LEZaKWSVM7+WDg25kQ85tfXOxNnctHfODWgvnalnG3sF3/sG4D9UyTd1HC51/8+5D88
	RGbp5imQVcMkDXi1ou36JFjUh/E1AWDYukIqGcGEMuKFHUN8veMbCE2bHv57OXeXWV5LUDBeuWu
	UM17QhZhv3RWhWk+heliepc=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dgPft63xpz1T4Gb;
	Tue, 30 Dec 2025 15:22:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F9B640539;
	Tue, 30 Dec 2025 15:24:45 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Dec 2025 15:24:44 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
Date: Tue, 30 Dec 2025 15:24:16 +0800
Message-ID: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 58A45140006
X-Rspamd-Server: rspam10
X-Stat-Signature: 5nj9ngw6fw8c8fb6o87a61unkqajgi1z
X-HE-Tag: 1767079490-734456
X-HE-Meta: U2FsdGVkX1+nvXZCRCZND9TG/C/H3fvSn3pY1jkC3Xn2Rxw7Z5ZddfCnrfeEG2oMIxupTPDJb6tT/nw/P7oNphwSZYCpjQK4sL5OzGn9aKWJ6b3nzzhb8nanVQBQqXRKRjyUGhKAWaq5e4f0CktBLy4PwV02e5Ctg/QmvyHhG9CHKFKi/kTEHW1pi0J4hKUp7IVWOeflAFs+RdkPPgZq4VdbdkbkSk13Jr+VoiBbE2z6FgJAvgWWCzd5ktHmqnd25Wnu+xc4+epPXdoKUuKa4bORsK8Odfj0BuEDPXd1c+lUpvRt4bN1jdsfkPVoX0suNFwEOg7ErgfbcYWlm00QSqOZU/vfOF90soAVAitjaEcKtIaULDw+rivjuq/1UiVk9s+FJ7W038Mby6mjx6rbG++EmgHPMW4SoAizp/1n1MTcfv6PrrjN1UofRvl8ASG/AtWkAkgi3AT9DUXiOWozmWPdmxQtcQ15SjW0QyQYhX3lczRH5giMIOcG/erudMBXTu6T6HQoInM7izMudw49NhANXMWuIm9oEmwRij6UWWm0mcvc52vGQzDOXuacLRwK/dx4Z368DcBqFSfLXsCIF13eijsQMNZrPm1fhozIbF7GDR4dYl0c0Blu10wJUkmXZ3XTcg6BsO8DR6s/52rHmcBZqVIEQeG+8DCQzcZx7oISLX4dTH8Rl5+RvH/WbLpB2CJStPG9shxDQbud9YM45E+dTAxLNSsxEZUO1Og0Ii377Hgd8xmc67eriVq3sFKPY0trl4mbhNkpuYSDJBzp/9C5xj9VHr0taH8//+qApggJPWmX+7lBHJDiWGVz0ACdSY/EQ5ibhDpGUJWYBDNg/qf/2PTwoUiM6Svx7n81DeWOHYby6LISkTGBQZPvk/fhTLVKuXcdc8HyHlUrhBp/1282eIqCK7aiCocmaptArdeFZj60619DDbVR5O3Al4gsN+jRO2JINchcqmQbGdv
 7wRPwSkV
 MvxydtPJrJZhQ9kIrLEkkfhhuBURpkerIqdzAQQakcxijUjRnyatlbhB9C7DIPADTHyH1Qcj1UfAtLA6E0nMOoSSX7fLFvJDeQ2uhl6HydoSteIPlI57CMWvkfqbEv83Ka7KRJrulXHVpw5mHP0ap8EVwqttPdIXCW3sExrr7TwIuH2ZQdSIi2nu9wWhuSfcwPb6QqWUxLSRyfh3F1kgxR2Calo53Gzi+9lmaiI3jOIH2nld7L9j9uT/s8CUDofm3mz0qO+2JZ8bGdOgmLezeso9V8I7TnJ4Nc7u7AdBsDpiimDI=
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


