Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE07C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12CE96B025E; Thu, 13 Aug 2026 09:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF9F6B0271; Thu, 13 Aug 2026 09:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36156B0278; Thu, 13 Aug 2026 09:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D08CF6B025E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:50:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BEAF40170
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:50:58 +0000 (UTC)
X-FDA: 85096382196.03.83F46E7
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4551080011
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:50:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=brjdsDmG;
	spf=pass (imf30.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786629056;
	b=D56DMh3bRjjGxbXuVwmzLHbzS7R1DxFCp+Xs8fnP4RITvJ/UlurrBy4OCIPSDXpGZ5yzyC
	hnFznwUiDUzYwgCB180vBvMivszdhbdyzGeGOWeNQCxJUegbYwxvltS5vCmUzoJ+AMVTd4
	WteWHzJMBbRKSdhXKnT2t+/ojtmz/ck=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=brjdsDmG;
	spf=pass (imf30.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JunOKLTGGpF5Im1GoXsL5Z4YAQAt4lQ2GPUbcnRIMB4=;
	b=DCOQs9aLqv06YOtmC1ewozmOqz+VvqaXiwCapasjUG/z50e4xcTinuYmr97YSOx5TQGEQH
	4ewe+As0BdugYfhBUtPSSI03C4xSFT0XiVotK9RHZ4j8TN1ssvBCVIQF2gh0nlxPoo8fB0
	HCY40h1uPo7FXKeiz3nj01MxLW/FGCc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JunOKLTGGpF5Im1GoXsL5Z4YAQAt4lQ2GPUbcnRIMB4=;
	b=brjdsDmGZXlIZ+NTMUBUJcaglg7XNQPk4ZbzbF/kJDGVbzCfje0pas7V1hPsFJbzjWF8E/qu9
	b02UuVdp76pw75CuOEK00psixuBSazZJDtxM99RhjkOlX7Af8pOe/tIb3+wMJp1D3NKbGxOjlHX
	fT5tLIqJhZs2QV/odJ0HqI0=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hLRLY2Swcz1prNF;
	Thu, 13 Aug 2026 21:40:05 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C3DF4057F;
	Thu, 13 Aug 2026 21:50:45 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 13 Aug 2026 21:50:44 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <linmiaohe@huawei.com>,
	<ziy@nvidia.com>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<rakie.kim@sk.com>, <byungchul@sk.com>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <nao.horiguchi@gmail.com>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <gourry@gourry.net>,
	<tony.luck@intel.com>, <bp@alien8.de>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, Xie Yuanbin
	<xieyuanbin1@huawei.com>
Subject: [PATCH v2] mm/Kconfig: make MEMORY_FAILURE select MIGRATION
Date: Thu, 13 Aug 2026 21:49:16 +0800
Message-ID: <20260813134916.292733-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4551080011
X-Stat-Signature: boj9gma1dkzbdn4nufukhweumsz1ex6c
X-HE-Tag: 1786629055-763806
X-HE-Meta: U2FsdGVkX1+1q1toZZkfuti9mJ3aHP1ShLUgEU+bkeQKjmNad6RR8BoVNn68TUpiWd8NgnzSrdnqXZIyUaFGX5YBNcTqNr7uo3/vrE97xpgmcgHCKGU0TBVDZXAv8uYhjdY5OOQo6aBxh33AxIc/d4PrQYcl1nPvya0fGXDXet5wEB2uioGjCwBANBOHWpngVYRMP1qSbTchRiCzWDXGsEythYUfnaqXWINTgjRz/Au0q9TuG1Nuqv9K/zg5gTfBzb5tWCgyQkfP4mCcnwO2QZp4568FjsTvtbsgffUO3+JCcnku35FdiYWRv5n/1TGGdACFHEJWNgxLBhwhQU5su+9RrqDPyA/ya6ye2L5yt9pVD5IJcpcTJwD0LATaUQeYYPozg3uVIxMDVtwfQk6ztYdVXKBnErMCEDRIO0bf56OlWJQXgwCGNUtMvVsA0EICvPdlEyltKL8TGyJasaX4D1XuAZF/wZX4nx5jrJu/BOe1VhftV1ruTxgIXWko+jR6MUAc/ge8V3ARsRZ0J99b1bul8ftVZ4qY8HqlhQPh8OjxNNS9IeMyq4n1lYNOaAw3pnGUcUUFgu9zJoQuStKYfRulD5I2bMYVX+txADm+LY4FrrmIM8iyCvnQCi6BbcwhFDfa0KHnl/8KeSpE7p4/HKHtP107I9Je9Dz/+AJ2Wh1iTv0p1M+mcS/CcKZNjaAFUihlacccRHEpmKE3GwsGyJiV96YUnaCqe/B4gAHLukmiFXFsSfuhjhaVUVU3AhMFWoDPmKmZuUqDPM5gTAukKk8txJdwWF+joO8WzlVD4VP7ZHeMAuLXabNTDQJxv+EaEtTJmX2OYXDPtPAtEo3Nps3HTavd+zTEEPQAp1xfJYT7e6Bfdm3Rxenu7/eLa8zCURANSqj4UwAcoH7B/SAdDsjJnQqmq2VMpnA9cMY5LKJUu8znF3DbugKKXySeY3sTBMYOVOxH2joyyqnnQxw
 DvWFJEXA
 4IyDmLfZ8nkR+p3sFV9OjF1hWnf/DzKNW2vViUMhDXECd4e4L6mypg1VDkoisvI7daAW+bSrfoah7Yzk6PHJdJiIhEE3sGqbDSvIygt3VDb21eVOXxmql/QTQD6hV/beXOP4lsqnavh9gtL+PaNBkLBgT8ZhAEGzaT5g3THGpZrUgcOJ2I8VBsqQTTMcWP7Ld7P9tO4t5OiAxV2p68bqc/STfqS29mNoTlrj7GSsGFSnvLZcnabwFuSBsYThZhtu3HhFXavYcmPJFLvigYP2gK4t4gHPgilI9lm0h3O/6ZES/sw9b4ddnsDRzxAy2/LCIAtCSxayAs7EFdUgaUtwEbWCXy2y3eVqqfr6qGk/U8E+Pt4nOpiTKCb0BR4YZeLlZT0ZE596QW1DQ7sk1U0uQjFeQXVZM42R8LA1r6ycNwErtIUvFXGNL0oP0hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For embedded devices, lacking support for NUMA, memory hotplug/hotremove,
CMA and huge pages is a quite common scenario. In this scenario, the
demand for contiguous physical memory allocation is very low. To reduce
the kernel image size, some devices disable the compaction. However,
their SoCs do support DDR ECC, meaning that memory-failure may be needed.

Migration is very useful for soft_offline_page() in memory-failure, which
may be triggered by correctable memory errors. Most anonymous and
file-mapped faulty pages can be migrated to other healthy pages.

Currently, MEMORY_FAILURE does not explicitly select MIGRATION. When
COMPACTION, MEMORY_HOTREMOVE, NUMA_MIGRATION and CMA are all disabled,
MEMORY_FAILURE can be enabled, but MIGRATION cannot be selected.

Make MEMORY_FAILURE select MIGRATION to handle this situation.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
By the way, as DRAM prices continue to rise, memory-failure becomes
more important, and we are trying to enable this feature on more devices.

V1->V2: https://lore.kernel.org/20260812091644.224299-1-xieyuanbin1@huawei.com
        Do not expose the MIGRATION config to users.

 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 8a24c130d008..604c58199acb 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -767,6 +767,7 @@ config MEMORY_FAILURE
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
 	select INTERVAL_TREE
+	select MIGRATION
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
-- 
2.55.0


