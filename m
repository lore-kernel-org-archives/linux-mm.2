Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF42CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 06:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468838E0001; Thu, 11 Sep 2025 02:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4386B8E0006; Thu, 11 Sep 2025 02:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215008E0001; Thu, 11 Sep 2025 02:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2648E0005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:57:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8324DC03BB
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:10 +0000 (UTC)
X-FDA: 83876062620.14.951EA61
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B21E40004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757573828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=tA8/InXQ9NrrYSa0z+M2aBYd0Azem/xBjvuQvRycY28=;
	b=Volh7gKiHbOs07ri/M56OGu8BySzh3oTCnzVVwu0dzPRF7FOBQHalhyzTxAXVBEt9RES72
	Q/LTYbJvF+1dcHjgdkl0a2BtxvIOeoBC0bFGrcXdzeJRAsm/dh1thDL5LVaExPF4LASAbT
	YmNMU9RgPzFjJbfc9z0mspU+xdFExfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757573828; a=rsa-sha256;
	cv=none;
	b=LYv/GWwSwVVFkVXgTJ5PZdz7veKDP4WrSixFb3lLE6No6cvdBTmrRL7dNRNQQ3TRTn02kv
	91dqHDpQgM3RpepNi/4+4k0L0N+7im+vq4NmYPajbtUKuP/LL1hf5zD6/OXHGfcCNAk5HN
	C8Uf3HLArYbtqdfYervLeiMadSLhoKI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cMpDn33j3z2VRcq;
	Thu, 11 Sep 2025 14:53:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7D06314010C;
	Thu, 11 Sep 2025 14:57:02 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Sep 2025 14:57:01 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH 0/4] mm: hugetlb: allocate frozen gigantic folio
Date: Thu, 11 Sep 2025 14:56:55 +0800
Message-ID: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: w9gzk7mqqspkggdacadxn5bz5ah5i3ay
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B21E40004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757573826-774557
X-HE-Meta: U2FsdGVkX1+fHUFf0LRbFHjwgP/vefIuaICEkcEy4y2WDsRHM0FShqDJ+/NaYv37soEd4xDg4RqRMgv3STWudcxU9I3UOd+sn3vArRlcKNdkVNRfxvobp5lhdFmWj1+8UNwk1oz+r5vSVi5aMvZNchrFqqJTNgFkxmxVxqzf9wCKDLZXHPAPfnI1W2FZqfN30zvDMUq+MbNAO2S3nQ/d9oceJQBA08epcj6XoajfQQxZqdsLbl7pZ6y7c+TjTGYQhrIAVDNRcu6VPnre0Z18ecV192wzf/sLob1QkxW9B3CrSsHG6g/GY7U722LMJl5ukEd7c0D3sDp51eTHpdFLACdplYc9wSwK9EJS9J5j2iAvoZMovcxCnHwly9Tb2qiUPtgQKl60ujYmhbipotWQ6qg4v/u+xhTe/9lhFCTX+Uxy+GbFjttr3gAJcD9+u/vQG+YCPM0xtEwXNCxNWW4Sv/EFF2td1tme2KLag/o5qReS0SSCwvlpTUoCQsePWvzlB7ptcCHpwjVaA50qnuCw+1Su1uEKxgALp0ynbmCO3bVS2juTymTBUtis5IMq1mS1kBN6ZU/vTuXrbQxd47H/PcwGI0n/4y8SlbS0nCx7LXtYppP5NFMtbVUzYdff/lKA0KVdwaq5GmY3AyQECj72eHgzhqzVDQZnBaPo/pwq9mLFXFwtTjbp1W6BRO7x7K2lJsgrQSdc2bx0EuaAR3XKCzcaag+NjPJ+YXBQ1mRh7WhcNfHHlnunCeKeHWAFW6v5LG7E10A6vJVvk27YbaagrmkHTzsmMNsmLQ47b9PulQjxudsspnOQUS0ZY5cTJ0gtBDeguvIIUpTI6R7fZcUywKCSwDRYNKyCFdu0Zq+MsIzKOtyt3kBdAhXSiPFb/tpl8EB/TUhbgLo/uQh3StGwY+sJEeb5wkjNWIm85n0jqAbueUutwgKHEBlAlPC0iwnwS3jbipXiJrG7Iz3ej9Y
 ccilHq+g
 W41c0bcSD3R/zZRD1GC4gMWDo11g4yEfUWWdHa5pVRaD7zDpdmpn7Uf0C5i84aT+2eWoQJZmZHHGQLOyhoyJ2e08/ULjlSSob4wXVBody0Zm1AQ2DjNr3K7xyLxnA5SWkmHSwGRZ3yO7Gqnu90IgwuwK/zZkRuYPCYoyzPjPqnKyDHK9iwjOWX1Xx6TcvOCetzYEKps0ZwkWUy8U8ijK/mHB4wTFicwa8tDybCdbtEKUsDQJojFx403wz1OQC2+QFt96oRyseOoc04ufuYvJuMPiII6PFFLPNpVM+gorUb6FTZXMPZ/dnO2NGommaiOpVcdH3qFGfcvs6iNpMSaOhsEbsjlrVzkrCTwCV28HE8TBFXezVkgvaAs6Fyymk3l7hdLWXyxILgaRvG9nFgiU21Mgifw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert to allocate frozen gigantic folio in hugetlb, similar to
alloc_buddy_hugetlb_folio(), which avoid atomic operation about
folio refcount.

---
This is the second part for hugetlb allocation changes, the mainly
different from previous version[1] is that we introduce 
alloc_contig_{range_frozen,frozen_pages}()  which don't calls
set_page_refcounted() for both compound or non-compound pages,
also and don't need ACR_FLAGS_FROZEN anymore, suggested by
Matthew and Zi.

Based on mm-unstable 20250910

[1] https://lore.kernel.org/linux-mm/20250902124820.3081488-1-wangkefeng.wang@huawei.com

Kefeng Wang (4):
  mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
  mm: page_alloc: add alloc_contig_{range_frozen,frozen_pages}()
  mm: cma: add __cma_release()
  mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()

 include/linux/cma.h   |   9 +-
 include/linux/gfp.h   |  46 +++++----
 mm/cma.c              |  83 +++++++---------
 mm/debug_vm_pgtable.c |  35 ++++---
 mm/hugetlb.c          |  50 ++--------
 mm/hugetlb_cma.c      |  13 ++-
 mm/hugetlb_cma.h      |  10 +-
 mm/page_alloc.c       | 213 ++++++++++++++++++++++++++++--------------
 8 files changed, 245 insertions(+), 214 deletions(-)

-- 
2.43.0


