Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C787FD4F07
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 16:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5872E6B009E; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CFC6B00A1; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DFFA6B009F; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09A9C6B009D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C894A5787D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:39 +0000 (UTC)
X-FDA: 84530679198.13.91F5AEB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 13E5B18000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773159938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=DWQl7kW8RKlDM3zNog+kcvwiTau0XjoieRNTv+ZadOk=;
	b=hROFkHKcxQVGR37etPxJZln5od8epyBd+RgKdWmTFhLbZxJrxue7NWtccLbuJxmSgiH6g0
	/UU9giZekI6MrwRcrmkaUc4O3izBKcnBrbKRj+OZxLN7+PhB8s9icrTiQZTg51JxdkKRWM
	YHyd4BNha8Fgd2INVn8vIap0vdO8o2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773159938; a=rsa-sha256;
	cv=none;
	b=Z+wtAJAJILWO225hbU+4/5p3zgQBFkbt7q/r1SUQ5Jrc84xcC9PwioUBYKGmoaH/6l5NxM
	oCLXjUs1TIk29TGOdD2rgeFFkD6O6fy81n6e+AI2PRSt4xA9rVT1rjff1NXNYWlE2r4YNo
	a5SQeOn8g63bb+ZGIhfCs4nwSEyiguw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fVfPM6plZzHnGgg;
	Wed, 11 Mar 2026 00:25:27 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id EE06D40086;
	Wed, 11 Mar 2026 00:25:33 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 19:25:33 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 0/4] mm/damon: Support hot application detections
Date: Tue, 10 Mar 2026 16:24:16 +0000
Message-ID: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Stat-Signature: oehpug65zrymwk5tay9rdfcqyukq8xek
X-Rspamd-Queue-Id: 13E5B18000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773159936-538101
X-HE-Meta: U2FsdGVkX1/zQOddvCa54vFh1vf6/293NgzcTY8iQ5TnrflxrmQJZIRWitpIyOQcJfSkdy88fMGz4e5tKw6ohjKuTUhqhGQdNMAbqXM6Uy7h24oHl1PGh9q9tuO9U/qemMJDTQDUrQpqdJHdgcs+vf64TNsLJ2hhoVWaHLfZjz5bdRJ1MwG0oRasjg5oIj7xVf1ddhdYXedeOMFU4UyXNY04SoZ7skpSYyMnfN95o2GovvR7SPo4ltY8RtTjHInqdx6b4R6O7vQ2WfM57UD8aq2vMDSWUElWE5Shog8oSIyQpsDb8N+uSInZisR72UC/pnHbtYJraAYnfvluUxxyi6R/YOAwIJr/IAt7Ja75Sd1YP1mpXsU1/9StljESy2h0Rsznl6rwzZ2WG/K4IWkgBcRHJ66RYgMrvM2/n61Z/bzZYlko4dqINtBm21WXfRyWTqkrff/8eo8i+/snrSvjoMkunUs/2V1xEw9EYg360D6DRBRTDAnDz8WHzKEd0ugPlIsjWRTXoFizhbhfadwb6beLvBkyjG2BI3JlemJZx55H4gLJc4M5bS1fnH2d5KAvAjQ/V5SdBmkIEbHTAspWfNvLvJ9hlOHPOkbMJ820bB6XiIeuwt2vlri2AewU0miod/vDw23ADRAFZoYWxH+q15zxZmVjk8FZ5s9VIAlNnUuQpIMTHCATOoTZxC1B9cCjQyRIRXZpmws56e+/D+vJozuvEIJMa+vH9FajyU3gXC7uaHy/QTj7LK+RAEwNUtXRRr5sBwiVCYr2KtuFPlNk+TIUcf9q6hCZWHQrk/6gpd9aERdxRyEF3o/ue4K9PAGtV0GvnMVZ8p/OGEBMYH+a0qCsHbf5qcay7AtgtY6xONfS6wpkZStdxmNpGxFTgK1HwX7PoyYAzDCxxwdcQClcIw==
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

Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
fragmentation and memory waste. For this reason, most application guides and
system administrators suggest to disable THP.


Solution
-----------

A new Linux kernel module that uses DAMON to detect hot regions and collapse
those regions into huge pages. The user supplies a set of PIDs using a module
parameter, and then, the module launches a new kdamond thread to monitor each
of the tasks.

In each kdamond, we start with a high min_access value. Our goal is to find the
"maximum" min_access value at which point the DAMON action is applied. In each
cycle, if no action is applied, we lower the min_access.

Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
collapse synchronously and avoid polluting khugepaged and other parts of the MM
subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
which needs the correct vm_flags_t set.


-----------
Changes in v2:
- Previously there was a mechanism to automatically detect hot applications.
  Based on SeongJae Park's feedback [1], this was removed from the module, leaving
  it entirely to the user space.
- All allocations now use kzalloc_obj.
- Since the user space provides now the list of pids to monitor, a commit_input
  parameter is added to allow changing the pids while the module runs.
- Renamed the module from dynamic_hugepages to hugepages

[1]: https://lore.kernel.org/all/20260211150902.70066-1-sj@kernel.org/

Asier Gutierrez (4):
  Damon_modules_new_paddr_ctx_target. This works  only for physical
    contexts. In case of virtual addresses, we should  duplicate the
    code.
  Support for huge pages collapse, which will be used by
    dynamic_hugepages module.
  This new module launches a new kdamond thread for each of them. The
    purpose is to detect hot regions in a given list of tasks and
    collapse them into huge pages.
  DAMON_HOT_HUGEPAGE documentation

 .../admin-guide/mm/damon/hugepage.rst (new)   | 186 ++++++++
 include/linux/damon.h                         |   1 +
 mm/damon/Kconfig                              |   7 +
 mm/damon/Makefile                             |   1 +
 mm/damon/hugepage.c (new)                     | 441 ++++++++++++++++++
 mm/damon/lru_sort.c                           |   5 +-
 mm/damon/modules-common.c                     |   6 +-
 mm/damon/modules-common.h                     |   4 +-
 mm/damon/reclaim.c                            |   5 +-
 mm/damon/vaddr.c                              |   3 +
 10 files changed, 650 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/damon/hugepage.rst
 create mode 100644 mm/damon/hugepage.c

-- 
2.43.0


