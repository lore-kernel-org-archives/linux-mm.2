Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E4C1CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCCAF8E0005; Mon, 20 Oct 2025 09:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA41F8E0002; Mon, 20 Oct 2025 09:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0F58E0005; Mon, 20 Oct 2025 09:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8CC8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:17:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F5C684DB7
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:17:09 +0000 (UTC)
X-FDA: 84018543378.20.3F528D7
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82EC2C000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:17:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sBoDEBcN;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760966227; a=rsa-sha256;
	cv=none;
	b=B608/7Vh63uN8vJIMUwfLURvCxAUZ+XztDMrvEcpLvblyihDzs2tqWH6hOr5agYEa+JIh1
	5x06NSFG8/ax3HcIz8AXB2h4Vq+SHq6wNJ576v+Gw39O+KIiB3KfDGrAUJn8Z7V+C6HNSC
	9nZHPZ9j/xd2AABPsyWiDI7OqE2WKwg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sBoDEBcN;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760966227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NqM/TU8fgmRhRSb4lgSilTbi4JKDDbvpivBHoO1W22c=;
	b=sjutTnAYrUVx0gleTMU9ZLuR32O1SQy7urHxDAp/YfWhleXfXLLG31qAEM7bq9CZ63FfII
	QaXJrdIRG/V4pUywS5OXVTm9qfi1oQvf+yujHwmiZXRufpf2QwH+BUiYwZRw/pz5MXstfs
	eeyRXdxPvtAEpm0slSnCen5Wf67hfb4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NqM/TU8fgmRhRSb4lgSilTbi4JKDDbvpivBHoO1W22c=;
	b=sBoDEBcNPEuwU+GcqRWnWLh2o2f72PRe9xkyN0FBAgrnB+6wFSXybovQ/lOUnWmf489crlSbA
	6ZdSnVTL7mJ4T38HOdYzgoR1+Og0dvNymYHtLQk1JPQeaXKrhDAlGasZa7y0A9tjOOJDtdcYv/1
	1gYFG52Qe/Vn/W/lC+CHm7o=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cqwsk2vMBzcZyT;
	Mon, 20 Oct 2025 21:15:54 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C521180488;
	Mon, 20 Oct 2025 21:17:02 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Oct
 2025 21:17:01 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 0/2] mm/damon: fixes for address alignment issues in DAMON_LRU_SORT and DAMON_RECLAIM
Date: Mon, 20 Oct 2025 21:01:23 +0800
Message-ID: <20251020130125.2875164-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Stat-Signature: kmcnth4jq3pa5dgtchjgjxnguq43nxtu
X-Rspamd-Queue-Id: 82EC2C000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1760966226-898629
X-HE-Meta: U2FsdGVkX18uLVTgmausXpgjAjectUcvJCvvycCg7ClCr2e4mnztjvR1abL85dN8IwBOwMBINifcB0yGeR7uIyk62no6IU0w1LZpXYjJPzl+pIZ0z/a+8EPRpdL5+b+zq1fzAWXF0zKpewyN7Dr3tlNp819Ni07KgF3+QXDVcwm0QsgKZfjFv+aZ/xv0YnfawwHQhjcRz+JPijvz5rZtmHqILfnCkscmWcgnc/SSQ+6QRLwydm7Gb7UEBEcyjDNvkSH/ChnFGagQWNz5HIe+bnICZNUtDRRB7FyyrmYHOTOqs8Pinuy69aTwn6NrQUSmdpr2Yr64A7zdqfXN3YzbJwQK2nG8EX6QKSPaBghXwas5ErhITGKPDcx6nL4K3DfRNpbh80xLzW9SKkUEFbdwSGR4TjPHeOzRsgWmEBQ+T1B+1LfrYxLqNG5kmTMLfXbWjzxSLd42Q+UFHrLmcSgc/kOSZclkahbAAJHFbzaGEw8tSL/Z+ZZ3Agd9KKEbBWxZZtcqvNW7J69benZOWVAQ9KIgUvyZKGl8Cl346qaUVZR8IYl+83ap1cGywGxdP2JY1v+HRn60RuEDWWzRhNYRXzqwq5WCV9aqAzt++tQ90p/7T3VgO0upJ0JkeVYZyCmiq86dTb5iEHtoOtGq8X+1dDJ5im7kVO7E3EVB48T0aP/T47ZFBp+O1ZtpKKUJRz/Zh8r36ohvhqdv4LAPx/YxnEmeENTjp6qcBokEkZiGaYX0KzsI9r1pkpcyOEDwACyWJ3tFFTDabWfzSToCRjYaYHXxtnUWlWSb1Aj8qGvN4zrXrrujU6HqKCjn7hI+j5qCjAiNWhzv4h6XxBlNqomtC/NPNmrgZj8ARD4MgrPk32cMJwFgKYPh6DOLpKtr6+xghjJ9WsL9arRDhxT7q9qQoaDuN6DWv4qa2EfQN0yK6CQL7ToZnEVzgAP8Axc6Oqll6HGfV2A2hCdKFnMpa1h
 zm9W0k1O
 HXz6jH9J9kqUoPghynTNROKox4+ZW9ZH7dB9HwxjV4017ExofcW6Ma5fhKzy9+CDwR2TtS9akO1J+MVuWcVFnyFEolNC24OCGYzYvcEhrpnOT7bdMBSsmtobzYrYp88Ug2Fvtm9Y4NN0MwKEFJwcH5j5GN6DkMG7Kqe72kt6oknauWw3hyrVzPqXb2OSXRnYCMf+E4k+ptSGMNc3rO0daft+qK+C0i7FikV6zZWVQlJSfdiM3UQir6Q6JhszpbCyG+vlHpzYS2gxJhJK80RHblsgY6KniP5a2VkzCjpjvaS/57nzi8IRfHNesriLsYmS3Z8SbC3YjCnykhJ2ix663OAh0oEV830c/qP0YgqgKzrK4MUY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In DAMON_LRU_SORT and DAMON_RECLAIM, damon_set_regions() will apply
DAMON_MIN_REGION as the core address alignment, and the monitoring
target address ranges would be aligned on DAMON_MIN_REGION * addr_unit.
When users 1) set addr_unit to a value larger than 1, and 2) set the
monitoring target address range as not aligned on DAMON_MIN_REGION *
addr_unit, it will cause DAMON_LRU_SORT and DAMON_RECLAIM to operate
on unexpectedly large physical address ranges.

For example, if the user sets the monitoring target address range to
[4, 8) and addr_unit as 1024, the aimed monitoring target address range
is [4 KiB, 8 KiB). Assuming DAMON_MIN_REGION is 4096, so resulting
target address range will be [0, 4096) in the DAMON core layer address
system, and [0, 4 MiB) in the physical address space, which is an
unexpected range.

To fix the issue, add a min_sz_region parameter to
damon_set_region_biggest_system_ram_default() and use it when calling
damon_set_regions(), replacing the direct use of DAMON_MIN_REGION.

Changes from v1
(https://lore.kernel.org/all/20251016104717.2194909-1-yanquanmin1@huawei.com/)
- Added more issue description in the commit message.
- Split the original fix patch into two separate patches.

Quanmin Yan (2):
  mm/damon: add a min_sz_region parameter to
    damon_set_region_biggest_system_ram_default()
  mm/damon/reclaim: use min_sz_region for core address alignment when
    setting regions

 include/linux/damon.h | 3 ++-
 mm/damon/core.c       | 6 ++++--
 mm/damon/lru_sort.c   | 3 ++-
 mm/damon/reclaim.c    | 3 ++-
 mm/damon/stat.c       | 3 ++-
 5 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.43.0


