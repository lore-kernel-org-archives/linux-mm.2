Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF6DE7DEF0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417D56B00BB; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6346B00B7; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2766B00BE; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0129E6B00B7
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:57:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BCC5562D8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:57:37 +0000 (UTC)
X-FDA: 84399820554.10.B70C1D2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64FA9A0008
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:57:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770044254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=bA6mUp49rwYmlFTVf5mx91OTfmNoPy4Ce98wV3PVUUM=;
	b=2FOJGkvjvw6Lx27rGiQqQDag/RQcL5bmJngc9vWDs9vs9PFyqIQwenzUF7/sYKJ3oPqRBV
	5akUlEOgopwXLRkwjq5SbR11PRcrFY2l8IQYH5znDuUfI/CKiNHwiCfyYkJPaxaQdDaOSF
	bF2oaTTP5zbrWbyrsxIvT/C0uelCm2Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770044254; a=rsa-sha256;
	cv=none;
	b=wb8USEDRSB85nUK2gQFA9Kf9y8OpuLzm55O8QfCzJzFOiXzDbb3uXeA+nl3KOR7NUbFXS8
	tV6TyBQldiouFkV94MK+c8ENsrbHbKTalIDv3nSVq7fJ2jH70CVG5nSmneCEaqzOIAp91W
	E2ZeNVChlCTqLaKR0DCn5hJ5CEbjY4w=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4V7Q5vfLzHnH7y;
	Mon,  2 Feb 2026 22:56:34 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 58F4840571;
	Mon,  2 Feb 2026 22:57:32 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 2 Feb 2026 17:57:31 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <sj@kernel.org>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 0/4] mm/damon: Support hot application detections
Date: Mon, 2 Feb 2026 14:56:45 +0000
Message-ID: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Stat-Signature: c4py1nn441yk7qe7p5sr5so8e91bi11k
X-Rspamd-Queue-Id: 64FA9A0008
X-Rspam-User: 
X-HE-Tag: 1770044254-886285
X-HE-Meta: U2FsdGVkX1/v/pUb9WjBsxDcYDW4OSTiSGybp1UIQzd/f4noTgmJDQyh73UPWjqyJCkfgCQ0aDKHk9qdUD23BMkTHnBGHNkcc5epECaMrEeCEC65zSb8rAn4/yc+d0Q7nMNleZnFJ3Y8iMHZiCQmM+18pxg7vvynEN8VT0wqkucUMlW1grfAvH6gE5cfwop7whbzoLhuzSyUgz3+KKoxiiQrMPLN1l51xRr2XEjiHqjDWLUVvTOzJ1PqoFxkROq7B2NLoxDD3/S1oAM/Tm+T7W4xhSXfIfKccrj5/x5rjMRSjZJQyTCz+EuaJJtpqie7V/Zpw4XFCAd7yY0lMHRhMAoDEfme4yJkt2dMcp6PZxrbbalQBJFrBAk7pjgzYsio3zgKE/bv50WKIx1boEYcVXZ2T/tPI3MLNPgC8XdI+Cjfiu7vTDLXN4dGm6CZYtMjUu+dOndi1PIyyLPSLaefDidhOXwNY++OCeA3eFUcAaIiZNEMEwYg6uxcqPUVNzUVjLBuCSCnA9wkX+cch0e09UPD8Z8LPStjhONqdpOYJg0W5aZ3YV536WI4Eq1dqYrasdJxfrN+fLCR0FLS5ejrP5tdQJOWq7yU9bABjgUxl9k1aG9FrYT4bzF8Tb3hkvKYN0dX8QwbDZG5mRh3XiqIY8P+XCuA4u4P9e7NO7X5Fvop2zEL3/16Sl1bVRDzNUqAWke8mQ9Z2Ok0CemiXix2JCS9QR+Y7LwqV5Qm1bOautifpK+UX/Crn6eEsfVIIJfTYvy7wtQTiEcrGJc6U+StJx/Oz46qCHykmAOxnX8zUgKuKEGIuLy89Z8Ym3v/7XyOEv9yuY5oucr/8tKafsYwTlaAzqMTlVyTX4jlcEW7/J8T4b4kd3cFpVJnUKN8eNDye0NZdlC98daoU/5YUi+Mmiq/9aa056qThW66IXptTmrPiS2eEkneG03/wzq4H2l1MkxfKfpBqJxkvSLdpiR
 WE1i4t5p
 YM+1B5ggoTp1oulrKpr54qpchHUX1MG6WTVVDNv8CRKdljJr75ElejlEYx0D+Dv87kHCOw2cgRZ3oBJwSs3ZYui5wYcYnOnDfKT98ioF+8PQfptc/nJPNKb8XCJlUDSbohZd7vArXaSedxRSmaU/crLQyrAZCb7WOp2eJxxMLp5tX5LX4Fa5IVoj592cfowuuLxLqAa5twFiyts2Y4aoaJ7ux2ETPrtq2UhWa9JDod/5OKTHO/7ltxzTO73Xu4niWEmZlNZG3mv5ymmY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Overview
----------

This patch set introduces a new dynamic mechanism for detecting hot applications
and hot regions in those applications.

Motivation
-----------

Currently DAMON requires the system administrator to provide information about
which application needs to be monitored and all the parameters. Ideally this
should be done automatically, with minimal intervention from the system
administrator.


Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
fragmentation and memory waste. For this reason, most application guides and
system administrators suggest to disable THP.

We would like to detect: 1. which applications are hot in the system and 2.
which memory regions are hot in order to collapse those regions.


Solution
-----------

     ┌────────────┐           ┌────────────┐
     │Damon_module│           │Task_monitor│
     └──────┬─────┘           └──────┬─────┘
            │         start          │
            │───────────────────────>│
            │                        │
            │                        │────┐
            │                        │    │ calculate task load
            │                        │<───┘
            │                        │
            │                        │────┐
            │                        │    │ sort tasks
            │                        │<───┘
            │                        │
            │                        │────┐
            │                        │    │ start kdamond for top 3 tasks
            │                        │<───┘
     ┌──────┴─────┐           ┌──────┴─────┐
     │Damon_module│           │Task_monitor│
     └────────────┘           └────────────┘


We calculate the task load base on the sum of all the utime for all the threads
in a given task. Once we get total utime, we use the exponential load average
provided by calc_load. The tasks that become cold, the kdamond will be stopped
for them.

In each kdamond, we start with a high min_access value. Our goal is to find the
"maximum" min_access value at which point the DAMON action is applied. In each
cycle, if no action is applied, we lower the min_access.

Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
collapse synchronously and avoid polluting khugepaged and other parts of the MM
subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
which needs the correct vm_flags_t set.

Benchmark
-----------

Asier Gutierrez (4):
   mm/damon: Generic context creation for modules
   mm/damon: Support for synchrounous huge pages collapse
   mm/damon: New module with hot application detection
   documentation/mm/damon: Documentation for the dynamic_hugepages 
module

 .../mm/damon/dynamic_hugepages.rst (new)      | 173 ++++++
 include/linux/damon.h                         |   1 +
 mm/damon/Kconfig                              |   7 +
 mm/damon/Makefile                             |   1 +
 mm/damon/dynamic_hugepages.c (new)            | 579 ++++++++++++++++++
 mm/damon/lru_sort.c                           |   6 +-
 mm/damon/modules-common.c                     |   7 +-
 mm/damon/modules-common.h                     |   5 +-
 mm/damon/reclaim.c                            |   5 +-
 mm/damon/vaddr.c                              |   3 +
 10 files changed, 778 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/damon/dynamic_hugepages.rst
 create mode 100644 mm/damon/dynamic_hugepages.c

-- 
2.43.0


