Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3100BCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2BAB8E0017; Thu, 21 Aug 2025 07:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5898E0003; Thu, 21 Aug 2025 07:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB608E0017; Thu, 21 Aug 2025 07:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 876508E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:05:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F6011A039E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:05:54 +0000 (UTC)
X-FDA: 83800484628.11.8608C1F
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E85AA0019
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:05:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=sTLiLiZEEEAtWfxlgsbKPguJNBXVeLx26ch4OcP4+68=;
	b=29rGC94ZOjeWb18ZE/LuGvBMDh4j+LcjBBV4xu9Xu2SOMtRcXLNbN7T5NYCntBMuuxF8ZK
	GfmBCmyyaAZ0u9IR8LzZGTuxxvosp/ZVMqXTr2RN8s3JxeHBQAQBSIN8rpcQGTY30YPhQS
	LZtJ0L2vmL8O1ANipkfcYuXyEiyCV1g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774352; a=rsa-sha256;
	cv=none;
	b=R/92hip/9UfG51UtVv+IA+oKNuz7u/8a7Uf05cV3Q4Wpr+UXUCuoSyv7pnz8CPBitRE6cd
	Ccvnjbbi/YBovFVdNFPmSYyfu/n7kMULNEqEhyh6ywPdmsahhoUQ5DUj8A/e9mKCYzapf0
	bf422JJF978pTpltCsb8Zh2sOhns+20=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c70jt6QFJzPqd8;
	Thu, 21 Aug 2025 19:01:06 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id D13E218048D;
	Thu, 21 Aug 2025 19:05:42 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:42 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 00/11] mm/damon: support ARM32 with LPAE
Date: Thu, 21 Aug 2025 18:51:48 +0800
Message-ID: <20250821105159.2503894-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 2E85AA0019
X-Rspam-User: 
X-Stat-Signature: oxyxt6trnp3izp4mkjgec5xdb38e4qg8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755774350-531111
X-HE-Meta: U2FsdGVkX1+Vt1m7V0k+DvEnPrx6blQdo49+UH/p89b3eY/hyz/OALiku50CMB7CRSrgB1keySwCOF7AmuKjuo9sCiZxPgoCwmiRAM9V3psAkr//75MV9CRDfonJFXI+d/S24NhDRHVPedMqd6JiHoo2/JvfdHgxqq4eXTO/9M185JX61Alig+vyweznQ/gryuH0ZdN6OJn94onWvpjQHheFsfvJYrcdBIDyz1qUzPRJ/m/H0D0U/PqmWbjmPYJngVuzB67Ytvb2ymZiWXEi/gpen7sUY56+cAjjox01QEBdggXvAxvhKrslltXeLPpE8nAX0MEmNSfU0R7um6Wd8IBZrJ06rduYHD3+6nRK6TzwZnAe14amkX30xsmSoKCwE0EtL0NbzjyXsacLbMpQIu3lY8b1luVHNIRdLKs8jeS521we6UIJcK+41oS5P56YzKFznXFYprWIR5W+6VmZ/VObBqscPMTUW4WL7mB+zg9QD9TH1K9Yt+qWVpv46MbPoxF8mH0q9wXPqS7Ztdh4jCE/hr+O0JxN9ZTBGkhqox5er2xmNKk/S24pWYYViVDBNDtJR7+js5eAvC+IWC44SXJeKwmTX9BW7bVEx73pkZSg4eNvjAq+ylSMRX82PyxiMgPsIgeNE65tWg8tRS+NzeYD190D4SuUVZYChUvYYTHrVs2RPVbU/TaPt1TLgigMmYjzD00zcvuPk/g6ChYkyXdCkuc0+KhMFsdqBdY4EmaMgGNASbE9azaFMIdD7RdMIry0/ZcmOEjWwWTNAg1ZCJefLlx96oMuhA36myIDz1liibKb3tGk1sInkqlcY+KXeXUgoIBwYjj4rgXDQwmN3VxSfJJlelRfO8aWObPHQIW8izmEzmNLliNMcZLefA5X8guKwzG1V5YrwwHKYWXfTuPwj7uFD3cNe0twbvQ4yUv5YplOJvJ9qd4vuiJKvP2d/OvrUUoSmiAfPsto407
 zCvoGrXu
 MRhX9mvE/yaV2IjGYGZVaRL7y1jdMic1dNEvc77lZ9FS5rNohSMHrAp4GFtQa++GrMgP5LFtdf3rNByVtVhk75QRao3NFuGmPzNeGmXJXTCCaTukSxptd0BlHp3BYVi1Ha6JnwB0z+cxGJKs5Nvx5JDFryOlPmrCv/ce0kpVw33drDgwpzoEjzzRiHeqhn7/ItLQaNx5uSzBX4zc6+i2iM049TA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, DAMON's physical address space monitoring only supported
memory ranges below 4GB on LPAE-enabled systems. This was due to
the use of 'unsigned long' in 'struct damon_addr_range', which is
32-bit on ARM32 even with LPAE enabled[1].

To add DAMON support for ARM32 with LPAE enabled, a new core layer
parameter called 'addr_unit' was introduced[2]. Operations set layer
can translate a core layer address to the real address by multiplying
the parameter value to the core layer address. Support of the parameter
is up to each operations layer implementation, though. For example,
operations set implementations for virtual address space can simply
ignore the parameter. Add the support on paddr, which is the DAMON
operations set implementation for the physical address space, as we have
a clear use case for that.

[1]https://lore.kernel.org/all/20250408075553.959388-1-zuoze1@huawei.com/
[2]https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/

Changes from RFC v2
(https://lore.kernel.org/all/20250820080623.3799131-1-yanquanmin1@huawei.com/)
- Rename 'min_region' to 'min_sz_region'.
- Separate the overflow prevention in damos_set_effective_quota() from
  this series.
- Drop RFC tag.

Changes from RFC v1
(https://lore.kernel.org/all/20250813050706.1564229-1-yanquanmin1@huawei.com/)
- Set DAMOS_PAGEOUT, DAMOS_LRU_[DE]PRIO, DAMOS_MIGRATE_{HOT,COLD} and
  DAMOS_STAT stat in core address unit.
- Pass ctx->min_region value to replace the original synchronization.
- Drop the DAMOS stats type changes, keep them as 'unsigned long' type.
- Separate add addr_unit support for DAMON_RECLAIM and LRU_SORT from
  this patch series.

Quanmin Yan (1):
  mm/damon: add damon_ctx->min_region

SeongJae Park (10):
  mm/damon/core: add damon_ctx->addr_unit
  mm/damon/paddr: support addr_unit for access monitoring
  mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
  mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
  mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
  mm/damon/paddr: support addr_unit for DAMOS_STAT
  mm/damon/sysfs: implement addr_unit file under context dir
  Docs/mm/damon/design: document 'address unit' parameter
  Docs/admin-guide/mm/damon/usage: document addr_unit file
  Docs/ABI/damon: document addr_unit file

 .../ABI/testing/sysfs-kernel-mm-damon         |   7 ++
 Documentation/admin-guide/mm/damon/usage.rst  |  11 +-
 Documentation/mm/damon/design.rst             |  16 ++-
 include/linux/damon.h                         |   7 +-
 mm/damon/core.c                               |  70 +++++++-----
 mm/damon/paddr.c                              | 106 +++++++++++-------
 mm/damon/sysfs.c                              |  41 ++++++-
 mm/damon/tests/core-kunit.h                   |  21 ++--
 mm/damon/tests/vaddr-kunit.h                  |   2 +-
 mm/damon/vaddr.c                              |   2 +-
 10 files changed, 191 insertions(+), 92 deletions(-)

-- 
2.43.0


