Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6881AC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4C28E01A5; Tue, 12 Aug 2025 23:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D508E01A4; Tue, 12 Aug 2025 23:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA19F8E01A5; Tue, 12 Aug 2025 23:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 943F48E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E812E1DA7D0
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:35 +0000 (UTC)
X-FDA: 83770362270.19.99474B7
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5B6F18000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057154; a=rsa-sha256;
	cv=none;
	b=XTPzbCN+p8MWLFJBZW4lC8/YhOxq0PcceELvgrb3SX9PhKx1c4FmCZQ2ePkwxFTYgGq9ZU
	3EahFamJRO7qe4Ugg+ZzKKyoy/vAoJpbXwavZUczmdNuejtGE2tfUle1POzTNbBptHKPLP
	jy8pAvoV/lCJ1rqGV59Mk9iwmvvzePo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=sGsJn4+n/H6Bk++oEiX7n+wXtfeBQ37DkeuL/L5Anz4=;
	b=j5URVbDOW3SlIXSHUwP1883D3a4t9GUBmNJsNy4tQFtmo29knutdDTGgT2DsUTkwjvzGof
	RLMR3SOsbYebr2fRt4SqkHr31566b53dEN4wdqV5hTDAheWi8jdeZDy5YiQbEOXMIWL25t
	3QFJugags6sZ9eDJoHWPayB+ABB9+0o=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c1vV13byRz2Cg6F;
	Wed, 13 Aug 2025 11:48:09 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 071BA1A0188;
	Wed, 13 Aug 2025 11:52:29 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:28 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 00/16] mm/damon: support ARM32 with LPAE
Date: Wed, 13 Aug 2025 13:06:50 +0800
Message-ID: <20250813050706.1564229-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: 9ix1jrqffzq81fd1ha3o9s1wk1y58cp5
X-Rspam-User: 
X-Rspamd-Queue-Id: A5B6F18000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1755057153-987091
X-HE-Meta: U2FsdGVkX18n32FJwVvpdgsBKcvE3OBa+YkdWTI1Mfk4xXrMQ8suMaL3z25DB9N/yTltncHi77DtzT8F8xy3QAvSFsLQi+3X3KD+2CvI+RWh2qXzDoP8eV/KU/LzDMPcZ1jhpAj1u2yUUVVZKBPuhPwJpV1hvblp6nbWJCoNUIVtF+pi8cU2wiCKtjSbQqiDc9+e5i685I/6UfcEMpp+VYwdfhJktyugxUNd7CYk87AUKAdooVfvhu9V4Me8ceL6a7SYS6OePYoJ49Nd+lN8P5RAnQmzcNyJI9Wcipm+fIN7mJm1wmHK0RVHGizH0WqtWx3qq01sM0UVf4ximZebatKbcclA3jcKzRt5ZCwHN57KMiOwstaDUNglo0jxwncA2biMzFi8g6OxjGSNI0vW6oB9eG9OvEraa3ov9Cub5fAVz7jGRE5CtznZLbG1aY54Nc5vXvipD8mysG8KljcnQHpxC7Nxk884EZ6Kbc/vrXSCYwT6/eArJLcqCVoqY3d29LEZlvXBYWJA5mspKyKLZBxR2dOkm4IUKiWxZDgTQBWDNyiKSfRQQ/8mNL7geQqYNnwA0OWZz0QzwLh3r1PFg7RCi19vPE2T5GDW7hE+bcJC+/23fQKGcBi0sN/A7XqxfM7mjKtUeFNGnmai1+wkuzC2JrGUpQyWYW+Ip48aOlRcGogOqYtvsk8foAGKo00oCspQPnLXotR+qh+L+dARlq7W/G0RI1IsLCYz6VweSthcCN8lTfSon74RjrGjEfPEKGAG5ZYbNN274Cp9eMJFqZUsUh025NzYcEk3BPsmdcIKr8h9DLHWoAnVlopcPFIkgT2t1WIWF4pcmLqJkxRa/qvAQW0la2Y1azsCI1j2dFcZ7cz01PcbwReMqBNXcbv5DWC3MvsaxcpTSKdwpJxXF1BICDa5E8cSACzmXt9E/XqAL9pU/8uhzwcc90REqsjZxXYwBGH2+j6QU3HBxEs
 t3i2/0eH
 bS1+0RKcu6F2LZ9u/f84BF+WZxWE2oGQxfrKJ7f7MOsGTsOPhl5vdkD9D1lDwE6o7hPlJPH8k5dF46rB+7HJGs5vne3/oFGJ/itjcNfqWe4XCv9fK7lmXhTlVUaZgFRjavqfJRPD9ynamLA7Mayp3oBw+MdBYivXrdoVwoiIswxr6eOiUbAXkRqe6GD+Z7Uoc4Lb9
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
32-bit on ARM32 even with LPAE enabled.

Implements DAMON compatibility for ARM32 with LPAE enabled.

Patches 01/16 through 10/16 are from the mailing list[1], add a new core
layer parameter called 'addr_unit'. Operations set layer can translate a
core layer address to the real address by multiplying the parameter value
to the core layer address.

Patches 11/16 through 14/16 extend and complement patches 01~10, addressing
various issues introduced by the addr_unit implementation.

Patches 15/16 and 16/16 complete native DAMON support for 32-bit systems.

[1] https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/

Quanmin Yan (6):
  mm/damon: add addr_unit for DAMON_RECLAIM and LRU_SORT
  mm/damon: add damon_ctx->min_region and damon_target->min_region
  mm/damon/sysfs: ensure valid addr_unit setting in
    damon_sysfs_apply_inputs()
  mm/damon/core: convert sz to byte units when updating state
  mm/damon: the byte statistics data type in damos_stat uses unsigned
    long long
  mm/damon/core: handle quota->esz overflow issues

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

 .../ABI/testing/sysfs-kernel-mm-damon         |  7 ++
 Documentation/admin-guide/mm/damon/usage.rst  | 11 ++-
 Documentation/mm/damon/design.rst             | 16 +++-
 include/linux/damon.h                         | 24 +++--
 mm/damon/core.c                               | 80 +++++++++++-----
 mm/damon/lru_sort.c                           | 16 +++-
 mm/damon/modules-common.c                     |  5 +-
 mm/damon/modules-common.h                     |  6 +-
 mm/damon/paddr.c                              | 95 ++++++++++++-------
 mm/damon/reclaim.c                            | 16 +++-
 mm/damon/stat.c                               |  2 +-
 mm/damon/sysfs-schemes.c                      | 12 +--
 mm/damon/sysfs.c                              | 27 ++++++
 13 files changed, 226 insertions(+), 91 deletions(-)

-- 
2.34.1


