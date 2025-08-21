Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8988BCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279576B0010; Thu, 21 Aug 2025 07:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229AD6B0011; Thu, 21 Aug 2025 07:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119F86B0012; Thu, 21 Aug 2025 07:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE65A6B0010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFF0B16035E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:01 +0000 (UTC)
X-FDA: 83800484922.14.1B12B40
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D4981C000C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:05:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mX++GZdmc6UWUYIFpTUepiEZ7h0iUQtlSO7KiQSQJrs=;
	b=IEf0T4830KTV+Y4XxS6YcSZsAOrsOoQ45tdl7D2znsGDsMeOAp4rCc8xBwva8spZ3ev2Vb
	c4u3RfJ3FZaLVqpUOcydQtAHtE+8YXp1rrbjreK4ekJOC699x5e+POK7AZwRS3VfVo3S8o
	KL9pApqBTm7kxE9SNCL8fYnv/K6BSrI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774360; a=rsa-sha256;
	cv=none;
	b=ulAh/4WeYLxdejT8Xo8LT6NuAZMTrBeVzMguIR8K9srq8lJ7BRc2NeAcFlGgGn3i3jtDnN
	ASJCSBc2p8VgINKpHLrL0CdYHQ7VMmrD21aGcWsaADm0GwLxa1ISw54GjpOK8+Ej2wk47l
	Rjt29QlpcUaO1OxI2I8t7Brrfc82Uec=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c70p93RxnztTSd;
	Thu, 21 Aug 2025 19:04:49 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 3AD90180B57;
	Thu, 21 Aug 2025 19:05:48 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:47 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 08/11] Docs/mm/damon/design: document 'address unit' parameter
Date: Thu, 21 Aug 2025 18:51:56 +0800
Message-ID: <20250821105159.2503894-9-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: tkqxgzaeidfoods96gwp8bqot4mp6stn
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D4981C000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755774359-239701
X-HE-Meta: U2FsdGVkX1+UeKPowNaDWUHclZ350IYRMBcQ4x9BaWw6h9ah59Ir+b3dKFllExrkG5GjZu8xwKi2+1FT5kqco5ocSaDxPjbzcJ0N0MLdHuotXMhjXQ17b4yPTnhEJYPH1RA7P8wUGzI3xa+eQ7T983B8QWbAj8ilZlC8pGUhPlo/i4jjQOCECmVmVk4WNXCfhhWESDq2xu18TAbkzqcI020YaNUVLBzbYhY80ORpoynkVjgIWa/4QFodPaFxH5JAAS4guq0x7hXlgw4DzyuKSndlGe9FaZIN32P8+c4jdrp9vbdNl+LmybJZN+zIbQetQGy+bHTEIq+CKmJ2CM0ZVHaw8T898g6ZoLhD4RWUAVdjsxdg/DJqaEH6EKUDuBzsR3QrH0Y3f2LoIBR9hh3hnMVK6uBxlwpOnS+69UJObsIPP4ji576wp+6S9G/22Dm5adKqn7y8gpUTp3RwGGo/k2aWx7f9wxDku8ttW+jZjNn7N1yL7b1tyYbfE3fA1btbZXL8lybj/Y1gdRm8hMs0aRktpaMMYMrZ3mXocwCvxFuI4ubh7l+gYz8dacE+l7ntE2zg0736NyL/oq4TXqMyV28AwdA2BcIHNaQ3o8iX0ioAbMHYzWuRInSZyY0ECJfl95SXzXcxzgaTNd30N+3m5yGsJuTgTD6GpoFGpyRQWaYpfeiJH4YP737kozY8hyjIqmWn7rk/L6cM4Z132g26USdBzIE2B3QmIOMXRSOphk1sg12Kgmw+wUspa2QC31GD1xMEAIQyu/HXzudnMYcnE5ikFmLXOO/r9c+crH+BKUhSGKzxeuhuFCEcPdXtMY7BM9p6VtpgoZrpUaerwJ3XjsRJsg1dTdd1iaLz2f3NAL9jr7xD5Fix3XYDX/YQtaLP7bQOO08c8GhiWhAMSgGZS58vD34RBmM553/Qn2y2OZ34A2krnlFPiuvZ03aiOpoEc5/h5b8o9dl3ChThzZk
 8gQQe2/0
 wZ0oyEM29eQlsJFlps6u8OMPSQgfO7o1MtDP5Ldd2sT8W2hkYRyQgPwx25+J/WCPkmLQthiWJjHTAixg1sud8CxYO5GzSH67kFkFkwwJUhG+s5Y1kkiKw4NCJR9Lidq2jEVOFNX5UBdjfKQ0v6dC0fqapxEJDzQ3p7eQtpkc8XEnN/JRARx/+5+AOdF+Mb8R0ULZIk27OmIt9bqKxZAiaG1pTGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add 'addr_unit' parameter description on DAMON design document.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 Documentation/mm/damon/design.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2f6ba5c7f4c7..d9d5baa1ec87 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -67,7 +67,7 @@ processes, NUMA nodes, files, and backing memory devices would be supportable.
 Also, if some architectures or devices support special optimized access check
 features, those will be easily configurable.
 
-DAMON currently provides below three operation sets.  Below two subsections
+DAMON currently provides below three operation sets.  Below three subsections
 describe how those work.
 
  - vaddr: Monitor virtual address spaces of specific processes
@@ -135,6 +135,18 @@ the interference is the responsibility of sysadmins.  However, it solves the
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+Address Unit
+------------
+
+DAMON core layer uses ``unsinged long`` type for monitoring target address
+ranges.  In some cases, the address space for a given operations set could be
+too large to be handled with the type.  ARM (32-bit) with large physical
+address extension is an example.  For such cases, a per-operations set
+parameter called ``address unit`` is provided.  It represents the scale factor
+that need to be multiplied to the core layer's address for calculating real
+address on the given address space.  Support of ``address unit`` parameter is
+up to each operations set implementation.  ``paddr`` is the only operations set
+implementation that supports the parameter.
 
 .. _damon_core_logic:
 
-- 
2.43.0


