Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83944CCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7098E0106; Wed, 29 Oct 2025 22:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9774E8E01B2; Wed, 29 Oct 2025 22:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D588E0106; Wed, 29 Oct 2025 22:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65F5A8E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:07:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21DA34A303
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:07:20 +0000 (UTC)
X-FDA: 84053143440.23.B314C4C
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf03.hostedemail.com (Postfix) with ESMTP id 49DBF2000B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:07:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=O41fgqk8;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761790038; a=rsa-sha256;
	cv=none;
	b=10kWSwsolxVpD2m3zxCUG41SB5qrZHsNzQ6rXj9paqralgYWxIxYVkibNxP1MzhlRx3Guo
	FEyBnOdCTa7eHBmvUFSYjfvectmE7iPA1XW4qvD44iXZeuqTbbdA/+YkuPLQo9FVmMOFhI
	mjW9EYY7s0HSR0IPDnvhcZ5iKJ2BOng=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=O41fgqk8;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761790038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CF/pzoLZDqGYNJEmki4gmVAam6PfVGZJ9Q6V3dL36n8=;
	b=44bMyun2WiOqMdgcA7qWwW9SYdSVFKqccLsCsjKnrWzfxai0i8/2obLdIxRtb5Wky9PPn7
	++rDZ8v8K5TmWOFa98kwyHZ9eM8/rrRJe0cVNGsos9s9f+Ds3Gzk2+j2nAAB+3rTGOc/dI
	A0cd92RHfYeOjy6vSNNaEYrmQdRI4o8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CF/pzoLZDqGYNJEmki4gmVAam6PfVGZJ9Q6V3dL36n8=;
	b=O41fgqk84/0l1v2gXv3gyw/kKurEfhYPJyQaDFb2ozXRL7OEsXhnIcxw8tT3pxZWlE4aWkSCW
	XWuUMZrIKcRRArKU1SnY37G+KIEApS12ZLMR2bGE0s+A6QWrUNadmkkEHdhTR98POkC2xcE3s3J
	8/WMFcgtEOzj7zodrQanzRg=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cxnXq4fwRz12LFQ;
	Thu, 30 Oct 2025 10:06:35 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A8B1140279;
	Thu, 30 Oct 2025 10:07:12 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Oct
 2025 10:07:11 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 0/2] mm/damon: fixes for the jiffies-related issues
Date: Thu, 30 Oct 2025 10:07:44 +0800
Message-ID: <20251030020746.967174-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: uykujmhnrcndis1prg55exxkc1wo8rwn
X-Rspamd-Queue-Id: 49DBF2000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761790036-120411
X-HE-Meta: U2FsdGVkX18LxxPd1OtKpFlZLWxkiOsGRsLxXQjthshYlABH4wYRm7ivSbn8Rr4KGM8ylvp+eQiN/ux0DZ1xu0eLPBWoosO9pwUcHftkm3893IomUBUVtbZRcpEJmoCAq+Y/xDXGUkmWSISBsRnaJ5VAikaX+z5r0OUaC1kZm1PNfposM16TdNch3/klsnz+Vne6GkskMtQp3iFJGOSc/X2oWYd8RV7sCxkLZExtc6wuHzrB3Mseye2t/yCJi5BM9fx9HH7zAq3wLd2SotArx5N6jp5buHPoAeolIg8xKcmIq77ebFZ9zooyP0YUr3mjPIJ4TDaZzexYAeWpJ7frzkiwVCkoHiqHQ2km2e8LBSGswmoOeTWStBhVqN+wj2etStAwL88fLAM6iSb5VmETEuNUcsDV96k27ha2sU2iAzCB2w7jSPpWNjjzTVSZ5/193RigWlXXxYc2gTdmGQbhqQycT2mbBtlOS47fwTX+2bLyGGX5Dt1QSnjikLJODCZlwUvxt+eFSfjukdrFhdq3qSFAJg8FrCQ6G5Xnmf3bDLtiZM8tdkBmSyCswPPUW/xx74Jt1xHoDUCJXfmMd6kygW59yMssNUWTPHXFnEG27HRuKzVmFPVxfhBdpAkjT/hicex1jhye9BccVJjUzEwmf/yMC/7rtaMoAHnoGN8EBxhYY2dHolXBTySOw/MPNWrNphqSXMdwrcgC8RyL1498ftwoieRPMiX+j9AS2iOwVVra+0yOwlRCYEfJdJwmb8N9vLIa8SCFZimkxHwrbBfyxLadvs3IiHrtsSUB2JuscJS8WCo1ok0TFy1EIu2vzUJvyvxBJjrKJMIug3cX5JUQDsD2XJSH8cxsZ7+k2bFpHD3y5VivCK0aLDYUS8I4g/74j9N6hGbRxIpYYN8arn/k1534g3PoH0IZ8FECDvz2BgErqVgmj27DB92dWAa9ZcZC7E0WvvpZKgsfZnke9CE
 fXqFZcl6
 V19JQuJC/j/yyxXE8n3R+YGhdR2zGnaukC3iOZYV9pi912ahUhE1YFgGSDd2DaLdqbTWwhLUMoXvxKB1bswfowreA0pBpzJVLBk/E5l+fbu7hKsb+SFEJA2f13XiUnK6EBUKTikjbrmlOfkTa4+nHhMOWK5urXpdrMQT+CKyitgGq0erJCNrtdQcfv06AjbtGSI2u+Uznl9UsaKXhBxTCZM2uTOreRojNiF6p6wAn4dlh8bBN2JoBX4dzY4K01ehOn6hI4mCN6nonI7DvN9CFMi13MhxIq0HUtpkwpGJzIh6TmyikdQ527zzi4s/dUpMD7Oos
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to
make jiffies wrap bugs appear earlier. However, this may cause the
time_before() series of functions to return unexpected values, resulting
in DAMON not functioning as intended. Meanwhile, similar issues exist
in some specific user operation scenarios.

This patchset addresses these issues. The first patch is about the
DAMON_STAT module, and the second patch is about the core layer's sysfs.

Changes from v1
(https://lore.kernel.org/all/20251028061927.1378746-1-yanquanmin1@huawei.com/)
- Added commit information describing another similar issue. (found by SJ)
- Making last_refresh_jiffies a global variable and initialize it on
  damon_stat_start(). (suggested by SJ)
- Added a new patch that fixes the same root cause issue in the core
  layer's sysfs. (found and suggested by SJ)

Quanmin Yan (2):
  mm/damon/stat: change last_refresh_jiffies to a global variable
  mm/damon/sysfs: change next_update_jiffies to a global variable

 mm/damon/stat.c  |  9 ++++++---
 mm/damon/sysfs.c | 10 +++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

-- 
2.43.0


