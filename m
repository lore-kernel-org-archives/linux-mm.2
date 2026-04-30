Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28598FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9273A6B008A; Thu, 30 Apr 2026 10:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE1E6B0092; Thu, 30 Apr 2026 10:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C1B6B0093; Thu, 30 Apr 2026 10:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 724BA6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:20:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F11789FE57
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:42:00 +0000 (UTC)
X-FDA: 84715335642.13.5743CEF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1383240008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:41:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777556519; a=rsa-sha256;
	cv=none;
	b=3oUOpyx+Eghx4+1tygDJiP9AyRbiuG6hIuFznNvWYHqg2054/XbRzc10bZstUeqCRzRfnF
	X56nzHKIQjp8AmAs1mPTaad2++pXkqXbVl3P1giaUT4SNoIhTj9jiiwjuPgFmlEgwkOAEu
	WAfsRoDvOmUyFbdXxYceIwZHjZjiyXA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777556519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=MCknWTYIiyhRvJ4JTyiprDJV+r3LqGM8mIhJ0xNJZEU=;
	b=IHSGrTAqIt7Jh9zaf+dje+yf2MykKlO6OCZfhCo/Miou6uX9Bo4jklj3bSQ9NzHlUhEUyS
	qnIz4zKMVPj0MrrP/dYrrrkhb294SKZgFLxz/Dhi3xJgWzXQz6pUyX6wJaJ/BzMlwQmIoH
	iatOJWDFzq/LvlO2cQ+/q31d4vOJtzg=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g5wLD6h7yzHnGhv;
	Thu, 30 Apr 2026 21:41:08 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id C484640569;
	Thu, 30 Apr 2026 21:41:54 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Apr 2026 16:41:54 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Thu, 30 Apr 2026 13:41:35 +0000
Message-ID: <20260430134139.2446417-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: kqoo8cixzajdk94yhiszxgkee541u15j
X-Rspam-User: 
X-Rspamd-Queue-Id: 1383240008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777556518-825463
X-HE-Meta: U2FsdGVkX1+TWYb2mO7enz3eI63JFetvVaWwc8/o+JmEbkl/4hECmx72PiZI3tvpWIs1i8pHtaIlKbaUWoiCyD4wy3Dcj70uofUbO/VdfYsSQjeW2RTfUnRxIdfZ1lA8hhMgQI4AF2oKHHZQ44gloVffCdl1mmqis5yvXMA4YR3oaT40lfktn76Nr1r4TjVfAcpdNJYKjXQKifQcbxpjscvoQE3ZDHs34V2KVYps3N4TrzZxP8q2YnV2fZiW9h3reDVxCyX+KLKl7lCJ2AJxFjyx2cbp/gjin1iKSAmplPjf08BHaVFa2+88Sf0vy+pR5+gk1dgU1BVGqSjdN2cwVQL/RYqT9r2pDbMsgzaexnY/VEzsEuweTOmi1UdES1XWQDSv82oATpY41mQeAKAdZH6rNBEopdeGXivA1FBrWc5RH70G4iPv2E5rcYYNCnxMjw2dm7gIBpLKVQizCF6FjBgktc+jCe5HdzLIybTZH8+MHUczW7/oufelniUJDn+55l32iXNtAGWPPJgOC03+X8jbbg4zLai2bHh9QWpMawNTbPOaziMjjLzBssp+anYj9dE8VdXbNtBuM0hkzlPDgDUnM0BGxzp2DXSXAgsQ2sSLFXcBTaQi+0l8W5miaGd+Pp85MvmC/FQ+u+ElO71pCCqgN64MxW9t9Vc6TP9Pxr4vpyz1TjLvyPlGalDq4szWASw6NaNTKOZUown3OhXXjdS9n6n3LkQf0ASYLiDSR+1zwDHFQOLx0ptk2XzHBwqotBKrjgc0vOU36weI8P4tTOPknf/zsMW9kd8vGYiT9uxk75LRbUljrMkeG4ivmnXb43FUsZhrI6ZlwU01M1/ECkwPeO5Kl8i9HAmxJuAponuniR04zyftqBadJGkt8EqaqPWts7CGBlTJlEpz/g/9R2IXCP96vyMwRJrvlk/qf6CsnopUvoz+1o3CBe/LR1Jv3bWbW4Mr6YmYvXRHYi9
 6hhgwkeh
 nD3Ls+jn7eWkI2JSxWgJ8XV4N02UBDDk7DJ2h6ZOk/3FTfUimY3GYFT0z0eGKHjI7FLnb2Q0IlUtyVR2+fflAWJ85s9yme+/9LAUQBJaMh8OzXavgQ2rhLKwBF5voz93xlb6GfZUlcB3Zl74ezk4q6ToRRiSaB3vzL78cxwablb7R6wf0yDxWieCX2J6c/pcdSMFNvomc7HSU5yucAa+ZdNo5RpscchG5Yf+wZkAycwL4wrn+xHkIVOixe89+u9PY+9LK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Overview
================

This patch set introduces a new autotuning which allows to collapse
hot regions into hugepages.

Motivation
================

Since TLB is a bottleneck for many systems, a way to optimize TLB
misses (or hits) is to use huge pages. Unfortunately, using "always"
in THP leads to memory fragmentation and memory waste. For this reason,
most application guides and system administrators suggest to disable THP.

Solution
================

A new autotuning quota goal[1], damos_get_used_hugepage_mem_bp, is
introduced, which checks the huge page consumption to total anonymous
memory consumption. This new quota mechanism reuses current autotuning
architecture.

A new module is introduced to demonstrate the use of huge pages
collapse autotuning. The module launches a kdamond thread for a 
certain task provided by the user through monitored_pid module argument.

This module also has a user autotuning knob which allows the user to
adjust the aggressiveness of page collapsing.

Benchmarks
================
In progress, will add them in the next RFC series.

TODO
================

- Since DAMOS_COLLAPSE is not in upstream and this is just a
  RFC, I have used DAMOS_HUGEPAGE instead. This will change
  to DAMOS_COLLAPSE in future series.

Patches Sequence
================
Patch 1 -> damon_modules_new_vaddr_ctx_target
Patch 2 -> Introduce DAMOS_QUOTA_HUGEPAGE and autotuning
Patch 3 -> Module that demonstrates how to use DAMOS_QUOTA_HUGEPAGE
           and the new VADDR ctx creation
Patch 4 -> Documentation

[1] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com

 .../admin-guide/mm/damon/hugepage.rst (new)   | 258 +++++++++++++
 Documentation/admin-guide/mm/damon/index.rst  |   1 +
 include/linux/damon.h                         |   1 +
 mm/damon/Kconfig                              |   7 +
 mm/damon/Makefile                             |   1 +
 mm/damon/core.c                               |  15 +
 mm/damon/hugepage.c (new)                     | 341 ++++++++++++++++++
 mm/damon/modules-common.c                     |  33 +-
 mm/damon/modules-common.h                     |   3 +
 9 files changed, 652 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/damon/hugepage.rst
 create mode 100644 mm/damon/hugepage.c

-- 
2.43.0


