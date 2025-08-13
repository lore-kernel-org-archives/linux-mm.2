Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3527CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25D18E01B2; Tue, 12 Aug 2025 23:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAEE18E01AD; Tue, 12 Aug 2025 23:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5AA8E01B2; Tue, 12 Aug 2025 23:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7AB28E01AD
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88BA7B756B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:45 +0000 (UTC)
X-FDA: 83770362690.04.48B8FA9
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2E6AA1A0003
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YToLv8DPNM4Tn0yZYtjNiGuhahmUvE+WyiAosm0+v+k=;
	b=qVUGZdgt31yEmZjsxAKd6/l3U4Q5VxgkmrxfywK46AflKsm5aGhGta9xySG+7YFaUMDQ4M
	ij8O1DBCjZCfIpeFRdhoDeAFM831XAKkTupIy0XXz0kUhNEai6mzCq8AmGn+LeUrENSVJ3
	j6clK++05t2wXMxFnBETWFokAgxGPeg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057163; a=rsa-sha256;
	cv=none;
	b=qhZ6AiyV2wZmP+oYnAwutdbEj8Cn0SAyr5G4+mPcYT73D/SDTziJL6FtFRDFZqPp6myRY9
	xZUdbG0yBDLY+rCKaOn55oJ+cq4u9mpuRZ34z3T7UwraXn349oeYrumIFx2izcdIKq40es
	YZh2zgvnEO8iqJXBDJf2ddpU+f8cjxM=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c1vVD3dxvz2Cg76;
	Wed, 13 Aug 2025 11:48:20 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 07C2F140109;
	Wed, 13 Aug 2025 11:52:40 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:39 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 14/16] mm/damon/core: convert sz to byte units when updating state
Date: Wed, 13 Aug 2025 13:07:04 +0800
Message-ID: <20250813050706.1564229-15-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 2E6AA1A0003
X-Rspam-User: 
X-Stat-Signature: o5guyty3bwk4d8nrifznhtgwjcmnbeek
X-Rspamd-Server: rspam09
X-HE-Tag: 1755057162-857818
X-HE-Meta: U2FsdGVkX19VanCDsr/dqvgHmMt+YlrvNAWXT5UAyNCth4BwalDDJlLlhw9ERnsSXM11I9bZgtEaulvgMwqjB8D+TtYR4c2+CBCqRsstZrapatrEzGXXYEs3its5RpbAuRa12QlNCMgTkzzWNCvolwCdPF1oVyUIyh7rd1ZERSFtGpZ8FWHvtUdQG6Hp7hETJmzrZDj9UoJV2yG+GtBWT+avMhFT3BQ0ueBDvvRDxtWFnL7Mtrf0a+N0wuKd36QF+G5sSBI3kVBSC/ReNohPEy0a6eq5Sng9CmXeem3XNAFVH6pbtlpmsMRqSkllhjidZJv3S4lUe6wQlI2az0WBh6ShqpJWuU3mZqjU8UIBgF+Ni25WDFw5KypFpFnTD7NA1J0tVVev+cI0SBNOSJC2xMZbMYZ5EJF4tfQsOZP94jYIFbBbX6C1tqKbmqW+s+r02P8Sm7zh8mUrf+TNQUcZRTssXVHkk89/WjaTVvvvGHxj57fzLxqFzYezU9+fu8cWjZ2AdxZ/nL2HdES1TvUTeM35yaIJnoAvXRrkgvIJZV/EGJquTOUUjQgIZ7fsIjkHnaLU0U5qiJGi8c+rnoO/2Q9ccXB74C0BQ5Zy0I6EcV6U87O2YgUgwrY3uExUQAnn1i4ZQOgacL3sDP8HoGLl/KzhwLmk4/OWDqQU2/Ii+NKvwEnhruqjPW7rVm41mcm9fSg7Cmv6jR/KWrvd8OxJMyvCdn5/MkVl4pkg1izAIg2fJtNDKF1W/+1sTb+7EEUTl6pTuze3+pXi7Op5xc7wPpJPwX3GiKihucE8Pd+nDqopwPB164u1YvTTtC/mexHJjmh+dPxxNojNWGJFdWSduKHgKOVUHs587vl2TOGFWWSLAD/nAV+8BUaLbuJFo8NLhm3LY6uGOEISVTqMx//LKhYl/zqxPTFDs0zM7cnwORco3/X+Bu1SgqAndQpajDMQoOU8FwTIazLN4hZ8W3o
 HXWXkqxi
 eYdZ0Ru15EQ9LXzkEDFt/GSjKOAMV/X8jWPJOK+Z58qJ5A4WKJuiwM/NQey845OmITm1xi1woRm3uOpNOKB6bJtFRR658eADK9IlYuNRK4WW1PT3HXeSJHdAtyeQc//DDhwc2iI6ZvJry2KGwenyy2ZiQbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After introducing ctx->addr_unit, the unit of sz might not
be in bytes. However, sz_applied is returned in bytes after
processing by paddr. To maintain external consistency, sz
is converted to byte units when updating the state.

Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b162aa1156fc..bc764f9dc5c5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1889,7 +1889,9 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		r->age = 0;
 
 update_stat:
-	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
+	damos_update_stat(s,
+			sz * (c->ops.id == DAMON_OPS_PADDR ? c->addr_unit : 1),
+			sz_applied, sz_ops_filter_passed);
 }
 
 static void damon_do_apply_schemes(struct damon_ctx *c,
-- 
2.34.1


