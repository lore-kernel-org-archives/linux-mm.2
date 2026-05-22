Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119BFCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ED556B0093; Fri, 22 May 2026 10:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4A06B009B; Fri, 22 May 2026 10:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353876B0093; Fri, 22 May 2026 10:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7546B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:56:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98D2E919E3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:55:59 +0000 (UTC)
X-FDA: 84795355638.11.C7FBA9F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id A6FAD8000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:55:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779461758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=igOPQlxNdMlxpCgjW5sNCeQce5BfZIx61NXn4CN1JFA=;
	b=mqPD3pd0wwjRqLTuJmupLQ4HA9YwEHYjpDpVPTx/L7s1MGRrCEzpFKZxtfb+rpkREM1oue
	ESqlJnHCHsIzGuWEeGUf9zBs8FP33kKEFnUWImUAQauvXA/YIEzGjmGzlf6qzYjAsLrtr3
	HDIpbZa6Wj9DK12z6zYJiKqfFQNieT4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779461758; a=rsa-sha256;
	cv=none;
	b=ALKaQbeo5z3/Woqc9MN4d9P7yHOsKkPSbk70Za0u9zZpyUbnNRc2homw5HUUSKdlDCAszE
	zurbmng0yPAxtppjW1FwdMCyLzEdBGG7rrgK8fh7dSAAKoJGWWam+McCVHXhMzdaqy1Sne
	PPo53YYqyLfczAP9tXgo8YWRQyys6Q4=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gMSxV6DGCzJ46DT;
	Fri, 22 May 2026 22:55:10 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 78FDB40575;
	Fri, 22 May 2026 22:55:54 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 May 2026 17:55:53 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Fri, 22 May 2026 14:55:14 +0000
Message-ID: <20260522145518.158910-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: ax1qwzrsp5oe3jwgcgmaw1qrr46ni113
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6FAD8000D
X-HE-Tag: 1779461757-218867
X-HE-Meta: U2FsdGVkX1+Dcso3T6uQthYlN9iqhHTTnXqFwBuCWMQ1P+3A47KpktkKBJBQczm6ZvYTojS8iYEWkbOcxtOBtQgYvGmJ5RJcQtZmBaJoQbDc1UBYC6lyip7/dIwF2CoWUM9975DNHRa0O+C0u3fAgFropMhNMQmijO1YVKu/hQHMMUW8lrQ2V3sFqoZH1Am1qE9l16bhp4voZ7cFsPMTYlyLr+YS+0JdtZbNUmSpJ1dlIKx7ZDX67TZfjt/xv19ZppswC1luTc3pxZNnihlFFZdvp3PFXcNTrDQRlbYipeD4ORl6zL3GvN3jeif133sBOXaUk2dXKd6+UeMIyFFR76Y/myqTRUb7kx6pVmwq4Lp1zI20PBkM5EU2zSICunJGF2sPs4jAuElaHTr3JduULqNGqetCMkjpq7pR6/1gOzxPIR4UK2XFO/G67PA+zz6hOL4wxw5uk4MCIazfy8J1az2XRjEI08hWQC2/HGL2Zs6oo5HibQ3YduYl76+jDEra/sJ1cnzt9AKcBPIlaGjyPqoCSJ2Umcbj/GOl8sCIGKpui3o/WVvaTvNUQVZCVrdc1Ulb0Pgi6V+R1pFLilKNwEaxXqLnJ6Q+k22mxI1f3vyZLNRgk+K5QtH3Xs3XQPxo4KpyND45c2PrCUxBrgHc9g1/brrMX/dQY7HrUUm4CO3OOIgTGeogC46846VVk3Q98/P89siXzoluAmgsbdjddt3Haeo/w5DPPitl2i17Wv8jvyhni9Tc/1R89sT0mdK51buvMejv+p++3BJs19/PRjdtX28uhDNQPHfdMdxujkXn+9Sd4h4Fp+cDqXfg8sibkljbl9LubQfNWpf3Ro7tiT/Eq3ejtm+3THmR9BBxutR6WcjHhSIZKXz+pXcSmDbyaURUPlVlzbjn+5ec5TXygbD6KWLd5PXKCC+6zzFKZ26JHy25ggpm6VmczzGxoEHQfK/kMJIAV3OIoKyXj8s
 +AxZjqub
 JapFRolCgfu7Lhy6/OLE0H8DRIkZv06O0G0kI+b9eZAWZIyUc5O+881wkV51H9PCLfTuWr8YAtZH3bUKPSclKTT56vjG43gywPtNzoCq1fMeSWMpt0Nqb8+SmnkRyTHY0UpInlNRuJq+hEd/u9C3qpvdDYb/NtlAqJAk94SOw2cUTQbyKIqu/B9UHgEOaZkRqO8qOX4HCMAVsGJ/VqxsbpJN2o8Pjdq8nZdjq3RFyfOW5AWl6Lmoyj4ll0RgR47KliGJSPoJZjukA26aq/+aUFGRt3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Overview
========

This patch set introduces a new autotuning which allows to collapse
hot regions into hugepages.

Motivation
==========

Since TLB is a bottleneck for many systems[1], a way to optimize TLB
misses (or hits) is to use huge pages. Unfortunately, using "always"
in THP leads to memory fragmentation and memory waste. For this reason,
most application guides and system administrators suggest to disable THP.

Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
However, there is no way to tune the settings. It will collapse all the
hot regions that meet the access pattern. If the server is a bare metal
database or big data server, this will also lead to eventual fragmentation.

Additionally, currently THP is set globally. Ideally, there should be a
way to control which tasks can use huge pages.

Solution
========

DAMON has now a way to autotune some of the variables and adjust quotas
automatically, so that DAMON is fired only under the right circumstances.
It would be nice to have something similar, but for huge pages.

A new autotuning quota goal[2], damos_get_used_hugepage_mem_bp, is
introduced, which checks the huge page consumption to total anonymous
memory consumption. This new quota mechanism reuses current autotuning
architecture.

A new module is introduced to demonstrate the use of huge pages
collapse autotuning. The goal is to collapse hot regions of a given
process into huge pages. The module launches a kdamond thread for a 
certain task provided by the user through monitored_pid module argument.
Hugepage goal autotuning will automatically adjust the aggressiveness
of hot region collapses.

This module also has a user autotuning knob which allows the user to
adjust the aggressiveness of page collapsing.

Benchmarks
==========

Huge page collapse autotuning was tested in a physicial machine with
MariaDB 10.5.29 and sysbench as the benchmark framework.

The hugepage module was set up in the following way:

# echo 1000 > min_age
# echo 1000 > quota_percentage_hugepage
# echo $(pidof mariadbd) > monitored_pid
# echo on > enabled

The goal was to achieve 10% of the total memory used as hugepage.

The table below shows the memory consumption over time. Gaps in the
timestamp means that no changes in the hugepage consumption happened
over that period of time.

+-----------+----------------+---------------+----------------------+
| timestamp | anon_memory_mb | huge_pages_mb | percentage hugepage  |
+-----------+----------------+---------------+----------------------+
| 0         | 2159.761719    | 0             | 0%                   |
| 28        | 2177.574219    | 4             | 0%                   |
| 38        | 2184.046875    | 130           | 6%                   |
| 39        | 2181.785156    | 182           | 8%                   |
| 210       | 2204.007813    | 188           | 9%                   |
| 211       | 2203.972656    | 190           | 9%                   |
| 212       | 2204.511719    | 192           | 9%                   |
| 213       | 2205.15625     | 192           | 9%                   |
| 214       | 2205.429688    | 194           | 9%                   |
| 215       | 2209.175781    | 196           | 9%                   |
| 216       | 2209.382813    | 198           | 9%                   |
| 217       | 2209.34375     | 200           | 9%                   |
| 218       | 2207.683594    | 202           | 9%                   |
| 219       | 2207.753906    | 204           | 9%                   |
| 220       | 2208.433594    | 206           | 9%                   |
| 221       | 2208.28125     | 208           | 9%                   |
| 222       | 2208.40625     | 210           | 10%                  |
| 223       | 2208.257813    | 212           | 10%                  |
| 224       | 2208.808594    | 214           | 10%                  |
| 225       | 2211.695313    | 216           | 10%                  |
| 226       | 2212.4375      | 218           | 10%                  |
| 227       | 2211.683594    | 220           | 10%                  |
| 228       | 2211.3125      | 222           | 10%                  |
| 229       | 2211.066406    | 224           | 10%                  |
| 230       | 2211.980469    | 226           | 10%                  |
| 231       | 2212.019531    | 228           | 10%                  |
| 232       | 2211.972656    | 230           | 10%                  |
| 233       | 2212.417969    | 232           | 10%                  |
| 234       | 2212.359375    | 234           | 11%                  |
| 235       | 2213.921875    | 236           | 11%                  |
| 236       | 2213.945313    | 238           | 11%                  |
| 237       | 2213.917969    | 240           | 11%                  |
| 238       | 2213.941406    | 242           | 11%                  |
| 239       | 2214.105469    | 244           | 11%                  |
| 240       | 2213.507813    | 246           | 11%                  |
| 241       | 2213.542969    | 248           | 11%                  |
| 242       | 2213.847656    | 250           | 11%                  |
| 243       | 2213.007813    | 252           | 11%                  |
| 244       | 2212.761719    | 254           | 11%                  |
| 245       | 2217.003906    | 254           | 11%                  |
| 246       | 2217.042969    | 256           | 12%                  |
| 247       | 2215.722656    | 258           | 12%                  |
| 248       | 2214.359375    | 260           | 12%                  |
| 249       | 2214.621094    | 262           | 12%                  |
| 250       | 2215.058594    | 264           | 12%                  |
| 251       | 2214.902344    | 266           | 12%                  |
| 252       | 2215.0625      | 268           | 12%                  |
| 253       | 2215.070313    | 270           | 12%                  |
| 254       | 2215           | 272           | 12%                  |
| 255       | 2214.851563    | 274           | 12%                  |
| 256       | 2214.019531    | 276           | 12%                  |
| 257       | 2214.085938    | 278           | 13%                  |
| 258       | 2214.046875    | 280           | 13%                  |
| 259       | 2214.257813    | 282           | 13%                  |
| 260       | 2215.644531    | 284           | 13%                  |
| 261       | 2215.511719    | 286           | 13%                  |
| 262       | 2217.160156    | 288           | 13%                  |
| 263       | 2217.640625    | 290           | 13%                  |
| 264       | 2217.648438    | 292           | 13%                  |
| 265       | 2221.660156    | 294           | 13%                  |
| 266       | 2219.136719    | 296           | 13%                  |
| 267       | 2218.738281    | 298           | 13%                  |
| 268       | 2219.222656    | 300           | 14%                  |
| 269       | 2219.066406    | 302           | 14%                  |
| 270       | 2219.175781    | 304           | 14%                  |
| 271       | 2219.121094    | 306           | 14%                  |
| 272       | 2218.484375    | 308           | 14%                  |
| 273       | 2218.082031    | 310           | 14%                  |
| 274       | 2218.894531    | 312           | 14%                  |
| 275       | 2219.574219    | 314           | 14%                  |
| 276       | 2219.886719    | 314           | 14%                  |
| 277       | 2221.523438    | 316           | 14%                  |
| 278       | 2221.546875    | 318           | 14%                  |
| 279       | 2221.597656    | 320           | 14%                  |
| 280       | 2224.21875     | 322           | 14%                  |
| 281       | 2224.222656    | 324           | 15%                  |
| 282       | 2224.585938    | 358           | 16%                  |
| 283       | 2224.601563    | 434           | 20%                  |
| 284       | 2224.632813    | 450           | 20%                  |
+-----------+----------------+---------------+----------------------+

Eventually, the amount of huge pages reached 20%. This is consistent
with how quota goals autotuning work. We are more aggresive when the
quota is less than 10%, and less aggresive when the quota is higher.
At some point, the aggressiveness just fades and no more collapses
occur.

TODO
====
- Support page splitting for cold hugepages.

Patches Sequence
================
Patch 1 -> damon_modules_new_vaddr_ctx_target
Patch 2 -> Introduce DAMOS_QUOTA_HUGEPAGE and autotuning
Patch 3 -> Module that demonstrates how to use DAMOS_QUOTA_HUGEPAGE
           and the new VADDR ctx creation
Patch 4 -> Documentation

Changes from previous versions
==============================
RFC 1[3] -> RFC 2
  - Rebased into mm-new
  - Use DAMOS_COLLAPSE instead of DAMOS_HUGEPAGE
  - Fixed an issue that returned silently an error when the PID 
    didn't exist in the system.[4]


[1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
[2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
[3] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
[4] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/

Asier Gutierrez (4):
  mm/damon: Generalize ctx_target creation for damon_ops_id and add vaddr support
  mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
  mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
  Documentation/admin-guide/mm/damon: add DAMON-based Hugepage Management documentation

 .../admin-guide/mm/damon/hugepage.rst (new)   | 258 +++++++++++++
 include/linux/damon.h                         |   1 +
 mm/damon/Kconfig                              |   7 +
 mm/damon/Makefile                             |   1 +
 mm/damon/core.c                               |  15 +
 mm/damon/hugepage.c (new)                     | 343 ++++++++++++++++++
 mm/damon/modules-common.c                     |  33 +-
 mm/damon/modules-common.h                     |   3 +
 8 files changed, 653 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/damon/hugepage.rst
 create mode 100644 mm/damon/hugepage.c

-- 
2.43.0


