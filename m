Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3B1CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC628E0087; Fri, 22 Aug 2025 05:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3745B8E0056; Fri, 22 Aug 2025 05:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1798B8E0087; Fri, 22 Aug 2025 05:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E65518E0086
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 418CB83BC6
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:13 +0000 (UTC)
X-FDA: 83803917666.07.81D6B99
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5315040003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=KG3N2Ga7z6gFpVEfJAlgFT1YDW0CzWY7mg9H+H502XQ=;
	b=RVnJSZBkG+Ip/WcGAk2255ZhJmmZ4qBkDsr0uJUC9AoOQJuqrRY2awGICLxS1V+WlEcHoG
	Khx8j9wTuIcuyqQrHdeNIRgxBRmpHVw+c8JmVrRdSSSsqYqBqhi4sVurq+iEbHoVjofANv
	0yTzkbeYvlLBuH9KSbfUDzyegpR6/8Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856091; a=rsa-sha256;
	cv=none;
	b=FZScoHjqkMzv2EDGyrGtMao771VDyxF2zwwe0+klphisQp/+wMKUICAEQ64VnNAJuRf4tw
	I5BfhmSMsYL4jV49DwTuXFAhDvuzMHukciAYM8RtB7W+0fH4DNYMDb4x3kM7ri+PIKpauU
	PwHpt42ppPzPyXx+H9xuLlRJ1UWV4mw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c7Zy60S4nzdcSB;
	Fri, 22 Aug 2025 17:43:42 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id EB2C31401E9;
	Fri, 22 Aug 2025 17:48:05 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:05 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 00/11] mm/damon: support ARM32 with LPAE
Date: Fri, 22 Aug 2025 17:34:08 +0800
Message-ID: <20250822093420.2103803-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5315040003
X-Stat-Signature: xhw8jefsnn8g55m11d9hcqoqwop858xd
X-HE-Tag: 1755856089-217753
X-HE-Meta: U2FsdGVkX1/iGQyNG0iNOq0HJgKV8MEHFhdzYH/wXLOTMWH35Jhg6LsqxUofJYPVk4QHB5toVv1kjvz3WZu0LfxgRtdc1n90iSqwTnU3yTECBS+c0ST4plrB6WOUQtKD0lGQ0bc/vAWYegxcjF5xUx8lH3asRpLIQ+k+FsiiQLVeIwHpFPFfJtiY/9a9nYJhpDvjyaEJrWw1CNMsQ02sCZBGbfcJeCawoaQAqI177jfcS6RqP/VXtYoCBsje9ZteIsDchMlxXl/sZkWFUtu+57ouvds9orYBW+ARVZPNcVksAKV9xnrzFydBeCiFrgSq4kC7PThlEwFwcLcGhN6Oq5m8tye31rJSXww+R59oa3v3qzgRM4DGW0SsW9mFhbYR8UuK20DHetRIpDqMujR/9ZoGRvGtxvuSwimFAPnQaVYBvmiCtLbfEAs6sxm5ckxkEh2G3Txe3vEMCKtBbK6fpszOkKmjK8E3bSvOeAD1ynzqWYMrYwVG+FfpNNW9oNvdKWGM283MOEnNR02eKE6NCklmZh6S7mFoZRo+tQe14iQfAAoE5HEJYe9bdpzMDvX2tSHD+IRNrZALjDc8AjuNBgRopTb2hnO6hTn8BZqOzFj2ksD2JaktzhbgZ2LaT08Y2cDMFEoLsUPcPpaNxNOgHN7AjnlqSmzEKPNIhdqA1Yfp3mtJYphHo8DVrBUavTPNiPyLER4gLU0Qr0NQaexTCUXRBZCxWameY8fqqEbupu8CInAoKV3uzxC02BKrAsT4FDC4HxkMOvOXGN4uamlV4/TVKrqsip2M+nWu8M6D7YV+lvDa7MbRKQTmyeJpN+yH6AE/R3v3h4uNJaYfDzgTTVracgKhJX9IHXnswCcyUhK0/kLBSs7/ekqikEkFBDq/x1EUrm1OTh9h4OY9QmPsb85DHinhkV55PXx4mN09Ov2O1w1nLUoCHNcuzrb3cL5SaVldgf+jBmxbleDQEIB
 aPjJCmfZ
 LXMAc79WjUX6XN0qlvT3Du/tOLC0efAk7aXsMy/KVcUdpFG4KPfIV6K1VgKPCEFV2l4aOLVdHHe364CaGuJqGtxvnLoH68CWbJEJf1jyuXPQKnGtG4CU07KBFOXnndh7wrKVNC69gqUse8f8viK69XV+m7B1T/slkmkwQkD5HYDx9pvO4nRjPYHa2ov1FxUSQSKPI7visT5rDnsGtyQij3aJOGg==
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

Changes from v1
(https://lore.kernel.org/all/20250821105159.2503894-1-yanquanmin1@huawei.com/)
- Set dst->min_sz_region as src->min_sz_region in damon_commit_ctx().
- Fixed the incorrect 'min_region' in the commit message.

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
  mm/damon: add damon_ctx->min_sz_region

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


