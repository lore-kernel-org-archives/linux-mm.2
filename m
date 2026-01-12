Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3CE8C9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CE16B008C; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFF26B0092; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC886B0093; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F03A6B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A863ED0CD3
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:29 +0000 (UTC)
X-FDA: 84323648178.21.A278908
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf21.hostedemail.com (Postfix) with ESMTP id 28CDD1C0002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=igBk7dSm;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lpIvZsUs7DKyG+CajjkKy+UkcoOOyu7dTVVMa1OFiHU=;
	b=RTHlAKy/+MAV9WOASIMX4MQxjMdlxNxEid0UL+ER+HF67ZSsSHRANTfvW9kkcVcvkqt/Pf
	L6/qtZn2NeO0YICw5Misc+aBgBpoTHH2qikIrfdqcRd7FYCFKyTF/74W0/8ZrNfvkAe+ew
	YwwJ3R6MvjQe6ThCNp17QXfhVIGzxMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230628; a=rsa-sha256;
	cv=none;
	b=oN07FeAODQZwoENR51b+8D1M57WKegzEV64THNzcD9RJy2by9ngmPAEPHIFrSRc8Z51cMV
	YR31UQAN+pu/Qpenz3ZUzAEHf7ehYwYDcGjEHs3iP38CvO4lXzYgFANgGW5xRk4h7c1ssS
	V6Qe/SmDIc9Jp7UNKe80JwEFvBAlTj0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=igBk7dSm;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lpIvZsUs7DKyG+CajjkKy+UkcoOOyu7dTVVMa1OFiHU=;
	b=igBk7dSmWJAL4EwsiQGwcWiQcpioB7Yc9EbFlJZg8+YTUsECbi9r6nNKDNJcY3UpmLzZEyheh
	P4IUYrKNGgAXKXch6oEufTIGC2bBFuZVzyCiMN7ig4fwLrn7IshUYBVsZ+qPf8kMxGwi4cxVbDY
	bhsiczCBvljfQxIxJ7fBbzE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dqbM86l1Xz1prKM;
	Mon, 12 Jan 2026 23:07:00 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 71A654036C;
	Mon, 12 Jan 2026 23:10:21 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 23:10:20 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new resend 0/5] mm: accelerate gigantic folio allocation
Date: Mon, 12 Jan 2026 23:09:49 +0800
Message-ID: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 28CDD1C0002
X-Rspam-User: 
X-Stat-Signature: r8ht1jeykri9d86hfsof64qi8qt76cew
X-HE-Tag: 1768230626-438164
X-HE-Meta: U2FsdGVkX1/fGZp6zTCEcnGg46EQKnbpHdk2vWQUvQz0AnhCOdWSrY/Qf6A8SPqcGu+mIlS+JdxO7CEnHSXhlPxkauTeDeeTo68KBnf7sTAI2cyLner3bye683e7AF+tCyykizpGGcBKNDrHnQeAl6339I6XQWL9roDGJqEFSH9/ruqsNw6r2eNCDvkaTttSoIsxIygVPQkzaLlzSmGUDa4NzpwlJr5NAH+wZTBh/w/nMXsGeIRV/wfCp+i+znxildeSTV7DWpgA7gqrnHrGCpeLhICVF1JX0l3LQimcwHrE5D7mooaJn9PoNCiouCrhBozn9r+CyZzEby089ZJyvBTxNoOk7okiCLxIIjAam6IqVFxNFhVRsyPmgwNqHoSvNq9kPLkH9Vv22+4zcFJF7OiT5JwVm0rDyYOwutg1Mh3vVAGO4O18nLTezufFZQ2AM0i4qCA/zPdIVAjR+hAkqh3Akiw9I4oTwiF8UggR+KWdNixVeAW7SPwMEt3EWfLjf147M/aZB1x+TVbFUyzCoiAc/RF0DqBSumhyRHJDyzeOVE7Th2i+PttPlDbtrKmcL4TSj1am6Qzt6FOS47rdypG9a0njaJGhIrug1iAVi5QscXVQHnwO0CMjQy5z+DKwsV8DcgyidPpHZgeQP+iekr2Y5Qe79Vo7Ekyf5g92x3Nj7K9gons5yfMs+A0E80ss5aSOPvGY0ktye4g70M8lKLrdtznMvMIm659N1hv198+73PSpI2HEZta5Ps+YJn7ktMwesmLqjC8bwaTTOelnJ5gJjNaHIbttHluUiamO4St4z+LtlYCAKT2FzNWf6TYiC6yf8W2CH2FcTU2lubd0KpIhe/5RmCLmPEO8CLZQ4OVigji1nxmmBbBlyf2r7ZlEU9eggRZxPfHN7oedrYs2tiJcuKrGQCp3uUOvzO9h6NSt1Kqlpuw8zKIL4inX93a50bGhYTY5wTscHVde4jv
 pNBHUCgi
 82o6bJYE/EwIXakcrBPSVWLOea9MkAKxkTh/GVg9GREvjkNXTIbv8XXpNU1vh6fdRZKFHRet96Wq11mLK/fISm2+JrBA1hK8CvxdebMMxDx8PP0mpBld9kGijMTHihAOkHHlKNj9dW3G2IuKhN/E/BO8dy/iAMlzaDiOps7FKbhmZIu9AYizbDKdkdUB6THduqajTiRfhZ0Ma7y2r8W+u21vMGzBfBL/d7tZs/XaR+d/wrwhboxeEacS80Cs5Z8fji0M7NEf0FpmlZEgIDC0t8TWNSvqnaTfYs5baqG8ZaMC0276sNiAe9+SYHfw1Oaezyfh3R8mcp+YIhQLQ/yrQ6wXGFmpadaY4i6KZPP17v2avB/yevlgqxhLE1n5uN8qYTCzoN0OmvMN1FaABUz7Ezjf+Rd9P4/ULgI3UJdwv9yQS938=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Optimize pfn_range_valid_contig() and replace_free_hugepage_folios() in
alloc_contig_frozen_pages() to speed up gigantic folio allocation. The
allocation time for 120*1G folios drops from 3.605s to 0.431s.

resend:
- no function changes,
  - split out the page_is_unmovable() into a separate patch, per Andrew 
  - mark two global values with __ro_after_init in patch5

---
This is part of [patch v2 0/8] mm: hugetlb: allocate frozen gigantic folio[1],
and as suggested by David[2], reuses some logic from the has_unmovable_pages().

[1] https://lore.kernel.org/linux-mm/20250918132000.1951232-1-wangkefeng.wang@huawei.com/
[2] https://lore.kernel.org/linux-mm/17bd2977-6a04-402f-ae84-306167cd16d6@redhat.com/

Kefeng Wang (5):
  mm: page_isolation: introduce page_is_unmovable()
  mm: page_alloc: optimize pfn_range_valid_contig()
  mm: hugetlb: optimize replace_free_hugepage_folios()
  mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()
  mm: hugetlb_cma: mark hugetlb_cma{_only} as __ro_after_init

 include/linux/page-isolation.h |   2 +
 mm/hugetlb.c                   |  54 +++++++---
 mm/hugetlb_cma.c               |   9 +-
 mm/page_alloc.c                |  25 ++---
 mm/page_isolation.c            | 187 +++++++++++++++++----------------
 5 files changed, 157 insertions(+), 120 deletions(-)

-- 
2.27.0


