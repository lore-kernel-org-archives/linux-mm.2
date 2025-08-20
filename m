Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB057CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4E88E002C; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C858E0007; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0934E8E002C; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB7508E0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBEA7B97FA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:10 +0000 (UTC)
X-FDA: 83796438180.05.3F40A4E
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf06.hostedemail.com (Postfix) with ESMTP id C9210180010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=4CySYQEnlCLZNwwJN+u33fZIeXZhWD5+G7+t52BRZmM=;
	b=IDI87gjyOEl+QJ+ICxj2aLXRNDBILx3RPikPaFMhwZQLz+aRvLf8P7qFlQfu1lpK0F3MWV
	vVbwUwsClIUsaKUrCE+w+UPpEI2Du3OB8imbvsAiE/F/6F0SyLgmlmbcH976P4mI3OehGX
	hEEkLCTzMv8IPePGXhF9tbMuUVWg7og=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678009; a=rsa-sha256;
	cv=none;
	b=5rlvyaP2X6/p1FfvOexLjEcyvyPUIQtudWC5uSPc0rRc+3Di7Nz3SyAW2lvHgabh7RVodK
	vw3Zl30pdnmXI3JValT1OQOW04oJ/ZaMAO3WC43TQRHmL/t3mH2b8j7yYcmYmYmUvQCC+z
	ZaDmkgjaThSfIq2hD1/yha1hspJO788=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c6K7B0ZWgz2gLG9;
	Wed, 20 Aug 2025 16:17:10 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C0FE1402CD;
	Wed, 20 Aug 2025 16:20:03 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:02 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 00/12] mm/damon: support ARM32 with LPAE
Date: Wed, 20 Aug 2025 16:06:10 +0800
Message-ID: <20250820080623.3799131-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9210180010
X-Stat-Signature: h9zxhbqx11saonis3zi1d74nporhuxid
X-Rspam-User: 
X-HE-Tag: 1755678007-216209
X-HE-Meta: U2FsdGVkX1+PNRUhcCgBY7epYl0fyaZcq3oiWYe7YQCmWCUO4Foo/6togYQTHc9K7AUUGevXjjPDjNxW8wavSPvmbKwoLqPtSLhmukT1FsG0HbOxkjcoUciMda9qan/ERdF17chWPfNwvtwZlkDsjel+zpmzjDPvJbyqYKtpJVkV7WOBuLafCChJ6lMeMniqBF2UFQtFAyUu4xaUfquaeWSWwYBfpEgqLA/rf5PiqH/876WMUcCc8TBRunlQXFrBTZeivmSalsnjkqvRYFlghRWz8aIbIHP7hg9USLlyPtoS2lEBt2v77oiSkvdG1i1roai6DlOHnPimr+8M1S6bupJg2xcIeByLspMqsLfazQURaqERxKlE0KkjvNyzUVI9bJ/BW8ULKILYvrrZQX5ToPybr5qmDnkOHAqJ2Q8fT3BC06rYyw6IPGMAp0Hw6Qjuy3mBW4h567+01Q7pSmvmA8o1gWVQoQlEbLrehaZAkIYaRjPDaee194a8c9vtaFMBcS/NIRO5qpEJ4OxsJ6+GDwVNkTwtHGJCxGmPRegLeH906PYicXvjN8YPXCIOlN739p4U6Nk4gnIT+64pbUal4+38AcvCneVQNoOIb/fx0i82s3RF9C2th/HdQUu6cibzLFf3PhI7vuuHlPsybBB8+MnRmmFD5vvXSc/jn7Osonh1UZ2ZVuEyBpJv+m1ZmCENN2AGwpYoNfNjcIwgv8RrAn2oPo0mzKCEPMR68mhzE/D92PeAg6sHtpYQ01CHH2ynfac+BJzXq+SLe5nKjjOknfkYV7hdtpq4C/Gm602FruYXv6SOAolIcYffQzBKdzl2gKuzhdHFCMiBrXOA2V7rN/S7ClLLzXYrz6qFkNwuS0yAXev+nJ1lRK/CxOZJf5Kt5qrSwK9Ygzc=
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

Changes in v2:
- set DAMOS_PAGEOUT, DAMOS_LRU_[DE]PRIO, DAMOS_MIGRATE_{HOT,COLD} and
  DAMOS_STAT stat in core address unit.
- pass ctx->min_region value to replace the original synchronization.
- drop the DAMOS stats type changes, keep them as 'unsigned long' type.
- separate add addr_unit support for DAMON_RECLAIM and LRU_SORT from
  this patch series.

Quanmin Yan (2):
  mm/damon: add damon_ctx->min_region
  mm/damon/core: prevent unnecessary overflow in
    damos_set_effective_quota()

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
 mm/damon/core.c                               |  75 +++++++------
 mm/damon/paddr.c                              | 106 +++++++++++-------
 mm/damon/sysfs.c                              |  41 ++++++-
 mm/damon/tests/core-kunit.h                   |  16 +--
 mm/damon/tests/vaddr-kunit.h                  |   2 +-
 mm/damon/vaddr.c                              |   2 +-
 10 files changed, 188 insertions(+), 95 deletions(-)

-- 
2.43.0


