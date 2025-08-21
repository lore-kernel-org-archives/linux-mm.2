Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F87CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D548E0003; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26EC8E002A; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04E08E0003; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0A48E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43A0683226
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:13 +0000 (UTC)
X-FDA: 83800485426.21.BFF0B21
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf27.hostedemail.com (Postfix) with ESMTP id A186440017
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774371; a=rsa-sha256;
	cv=none;
	b=0mAVBJd19AFObGCb3mg6BQ8rv1lsnCHhx2QfAKaC+4mj9IVfP4aj3sUZ7ZeGcDqwcfYQYU
	6+k8vbULQtgbLn+Y1+5SPmWfuHabrNvigfxL7USdGID/yRCQePP0x6q7pPAb8UkH6c+Cg8
	hLuE5F9gz9FX16kkW5m+U4doABhLZuE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pcD+b7p4u3DRSFNTL3ACdYMwcZmrsZMxSvj6yV57kS0=;
	b=IrRbVgH0u57S03kdXrlBQY2PCmE9eI642NC+uLCod3uRuQZgKC61r12ZkZorK+KWpbtPvi
	NMDJsNN1oUcrJQDM9KCEoNAymlXB2Fti3zWYP+nbNjAPsH3JHpUxzofO8EcYdgbz+S0hyY
	CgEoSSa4nvoBfJ0o+ZQCnTAP8qJ5PTw=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c70qF2264z14MlW;
	Thu, 21 Aug 2025 19:05:45 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E5D3140279;
	Thu, 21 Aug 2025 19:05:49 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:48 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 10/11] Docs/ABI/damon: document addr_unit file
Date: Thu, 21 Aug 2025 18:51:58 +0800
Message-ID: <20250821105159.2503894-11-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A186440017
X-Stat-Signature: ws9hmmfsk4mnuwkpkb1s66zd3sdtt4p4
X-HE-Tag: 1755774370-896136
X-HE-Meta: U2FsdGVkX1+9X333zjgGOQpGnwIg6s4oW2qyH+5HpNUp9oJN01ji6zOBg75rdY7Sc2itIb/Yn9f1cOVD9uyDMMj6tFZuFJcHxSVpd410ViIsa627YVgzpY0Bk4ku8ur/9z6IYr3J9MkunwurTpEi5zpdwKi7tGQBkHdl3jEjD6YoiQWqnim9b+T+bTb9SGqQqdXTmUC1j3PRPOj15RdWLhElR8ygUMGdHkpsXJpho5zO1P7WlQH4zsq03LnLPKI+P3bHuwBk5A0UWXIm9wUzwp/jf7D6kfEiMJxZyXFUdDEg9eYWSooSxJ2LDem3UUUOLeqmZLupBs/GJEYxvxrbl4teyh3J45nY7BscR0yg6BBBBLUchaRlpX5q8jowRiJwzYcr54nqytLz9hx6/CU913/g8Rw+/oMQ7ghGWOBThXoWsUp/O59PIdLyMw2BFGFd4eCzA7uEOoTtlbm8X1hGDtSKHi6O9PXyu7jCe/+yy4NCiLD5+ARltP7gdxl43QxmViz6yYR5sEyggLiqdESqJqtp2j9tC5NUQi7XufUNkaJiQ0/rI00P9YHqL7WdmTW5ZzcZyykfFOUiWRUH3V6iuIhUf4ljb3Hrb6mSu0maAwo7vPxYogoEs/xEKXRaes6N2BQwULrLx38bbMCQ6g07el94T4tcx66u+vF7VcLO43ohwBc5vzghu6C/D+p2T/2e6EESM6hW/xywA1IW3pauTGQYUFiLcWQ+j4KDGdh+65YPvkFyExofdHfdK+Zpij+B/9keTyeANignegrKbTRlJAMR+tzw4c19tqIj3VPUIczd6cvDkEhBojAtADhu6XMacojJc0XXOpOa58/RDoxofubrVmXyvUig8tX2hXXynaOxDb+X9bUGXqttfy1iDuEYDzrF85c9c7TrK9lFA7k9E53eskmvqBmXnq+2J0IK5RvabgjWj8x1eWsU7CfIczhB7Md8KsTlzCx9bshNzHI
 ZgHbD/6J
 Feoc1RqzuNDHG+2iZJaigMOrzvnpUwv7MRvd9CbqpkssQMr5kQrUUzO/0I6i/t/FRthmxu9gjMCVrPlDEOUKFvp2g75d6Uba9YiypS2TYh8wVV4JmCc/+212/x1s+mWy83I3oTWvaImQ9G8UPSR8uZSnsvzyqUjxxs9vQcoRtKZIVpPN4CfCGt+iQUrKQV36QCIKRtxdFrZ162KAc7CXAQ34t14mYnmt7G8Mo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Document addr_unit DAMON sysfs file on DAMON ABI document.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 6791d879759e..b6b71db36ca7 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -77,6 +77,13 @@ Description:	Writing a keyword for a monitoring operations set ('vaddr' for
 		Note that only the operations sets that listed in
 		'avail_operations' file are valid inputs.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/addr_unit
+Date:		Aug 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing an integer to this file sets the 'address unit'
+		parameter of the given operations set of the context.  Reading
+		the file returns the last-written 'address unit' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.43.0


