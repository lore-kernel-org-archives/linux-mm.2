Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8CC6D277CE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3516B00AA; Fri,  9 Jan 2026 23:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550446B00AB; Fri,  9 Jan 2026 23:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479316B00AC; Fri,  9 Jan 2026 23:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 389586B00AA
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:21:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB78414010D
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:21:31 +0000 (UTC)
X-FDA: 84314755182.17.E922BB4
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C03518000B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:21:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UwAkuabA;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768018890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Xl2NVwVxTjeYs9cq3uLnSh4tlJv37DJDSIsT9y7UVpk=;
	b=n3aI7a1mXytDdpmNhX0nCIZRqfWzQ65SkwphFMgG309QR3ugG1bxQ2RUjd94ZcKvlWd8ik
	E9L9cgCri/bMJJ8LSVc3yXtnlzwCOIgwMMT/0GDPTIuOVdLDbTDX7tXkMwnVD0uljy72Fl
	EpMx6D0J+p0OJq305if+qYF+3cRar1c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UwAkuabA;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768018890; a=rsa-sha256;
	cv=none;
	b=zMpj5ExojldweNV2A4K759CbX1IUz5hEPE/CNY+XbYlw8khP2eAlYmHNa6s7eZhY3bFRBb
	5kTnzq+a3pG30/+WvggzXajq/TH05G2ARWDq7OAQYZ2WbfrMWhr6HzDkQmYUo0H2psV/wA
	UyTMhJofwVqgLo/YP63m0vyuQ4gyV/s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Xl2NVwVxTjeYs9cq3uLnSh4tlJv37DJDSIsT9y7UVpk=;
	b=UwAkuabAidMqMt/g5kIkmJnUBHTKP/fMajnY7IHDgfkX2Yrz4IBp5yykMt9IkAjuKAzJF6qsE
	AEMwW8luKqMFwFzq/18Dkam/YMgk8xKRYBo/dnv720trSzdDLEQ0cCIhxNVqhLqofvyxnX3LvyH
	cw/JiaAx+YqIZpJ4Utch6f4=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dp53P0szcz1K97d;
	Sat, 10 Jan 2026 12:18:09 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 20DF24056D;
	Sat, 10 Jan 2026 12:21:24 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 Jan 2026 12:21:23 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new 0/3] mm: accelerate gigantic folio allocation
Date: Sat, 10 Jan 2026 12:21:08 +0800
Message-ID: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: 7xteeffhjpo6w3ftfs838dx6eihp9eok
X-Rspamd-Queue-Id: 3C03518000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768018888-595940
X-HE-Meta: U2FsdGVkX1+12UulYgggog8apaJkNkoc4b3rcF9XokLBrMfcPFrh1rGq/zL8RAAn3gUgYHnog/uVOb6HwTwyqDnddhww4piwOyucZ22zsCWbUS501CBlsePYOzJHGHweAduU+bxtPJcGp1wPJcV+MFrk+2OWYBzhUD+/UigRPvdKJSAVeyHBKa62OBcVWhH6bm/8Gw9nQg/8g24C8nP86pyuY/aUy3dwdcQq4lQNsUw+yqI/FhR5jcJK34p+ReqL7waOGgqfyO9Wi096sfZHD4q2ELFXTAySucnouyqC2IXDovfY3E62BpknGvkp/2fHl9u5KOWpv+NdsP+BbXylMV/COqR1A36cJB/gt3wBieUwcSvnt1XwSQ43/Kvg1aZXg3aqpflWtFh9DFSoy5a0PHWPPjGZly54ng6lJXGbgGig4X2W7I3uLIinLOeawv1x8ZpfvEFKbcETqcJzvJNPxrN+xu1B5zH4zpmC4E22YpOR/14Oh+PXdIPX6F5+3g9OwxZMFaateMMtDqsN8WoEioJnVWxN7AGuO2BNaqhDGcDQNm+Q7rcc6XqXxn49nfDXYU1OgIgXJf6j4buBgNhYHjDUyIvbsdpv57tukNLhiL/Sh3wSrb6hbjtEruHQ47TiZEBX1hShftUpo07OQ2nIFFMlEwNaJYmKQz2yb0XLy+gfdTkT30zBNzqCRb4FF22vsU6XKmKA3vib00ilO7WzYhlKbA6lXS4osOFqzC72PJ0ge37lxmXjuZfrK+/GusWXzSoVfZ97fOF9kGyQ9owPbg+7JHjd5hQifIfFgnHKtZg+bshilFyx1Fomc5PI62vKYq1SyxPV9j6YRjqq6Rjx+xcpAaX4xBId/0rjvO2i8i4gfLJjOmoOji9LyhXhzt7DDHL2OgHh0hyXVNvJznTJWmxwA3vDULbtssycEBdAv2HUrAcYnNkJ3n7G9s6EXMRVVRhdMWw28hzRon0cemy
 UqgfarQA
 MRoJwKp3fcnaenVGZ2ZfyTUFLIvcZYFD8VKEZwem56BjbH3hiGMAqVRV5YykcYlt9FbJiRumpxv8jEZouYGYTyl7ackvotBlfWQeNjHTi5iDpvqyYM4ZEoyXJJ1TX8Gl1M6YPouMnalEW5TDo3QDndvr2z6j54+F1IgFovbGwNumcwcnx1lc5IhYt2SBMDh8jui3T8yc/18APHyLTVSQBOoyIGXT9hUW7vvhK3YhqLh0rbSUl1WW/05WU4pW0wQu2RqkS8uFDTDoeL/6eqSNeq9c0Le3j5ej65m3QiDhoXPaCd4pUd5syX7T/GS6rYWSV3sNKymSrk8jWZgIkhwutP45v6hYrjqEE+K0bJ5XcQnWrBs5KHJ9S92zTTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Optimize pfn_range_valid_contig() and replace_free_hugepage_folios() in
alloc_contig_frozen_pages() to speed up gigantic folio allocation. The
allocation time for 120×1G folios drops from 3.605s to 0.431s.

---
This is part of [patch v2 0/8] mm: hugetlb: allocate frozen gigantic folio[1],
and as suggested by David[2], reuses some logic from the has_unmovable_pages().

[1] https://lore.kernel.org/linux-mm/20250918132000.1951232-1-wangkefeng.wang@huawei.com/
[2] https://lore.kernel.org/linux-mm/17bd2977-6a04-402f-ae84-306167cd16d6@redhat.com/

Kefeng Wang (3):
  mm: page_alloc: optimize pfn_range_valid_contig()
  mm: hugetlb: optimize replace_free_hugepage_folios()
  mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()

 include/linux/page-isolation.h |   2 +
 mm/hugetlb.c                   |  53 +++++++---
 mm/hugetlb_cma.c               |   5 +-
 mm/page_alloc.c                |  25 ++---
 mm/page_isolation.c            | 187 +++++++++++++++++----------------
 5 files changed, 154 insertions(+), 118 deletions(-)

-- 
2.27.0


