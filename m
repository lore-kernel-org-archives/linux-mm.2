Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDD4C8303F
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0098E0091; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D868E0090; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8C58E0091; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00E568E008F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:36:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FF118418A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:36:35 +0000 (UTC)
X-FDA: 83817496350.26.7039DF8
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4163DA0009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:36:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756179393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfuvQNIv+FjIhYHVCtXIFKZ5Zs9y3nFX01l1xqrSa18=;
	b=3PP9SYlXzjnJ/zCfNJI/xHPgO+zwTdLFUW2z3M1KBbkGCkB55BoW2VwAqSrPDhuo8K58O2
	l+VFc0dDH2aYX04yArIzj0ZvvFt15RuLaG1aR0UrFDRAQCKDo86QDQMEd38/28yMeQV1uB
	+C//EarjriO3UXbj63baPMfWYAwmW9M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756179393; a=rsa-sha256;
	cv=none;
	b=2p6d54WrC1PbOAVJhYLhLDr5nJz8UFPvolJFvnJFfh+23HhynXsYWb3yIC8GdcwMqpzazD
	E30drk1dogEwOrf9nBnmyg8AoNlwSJtlEU+L9N16wDD+YoKSge7+LGEs4GYouEhl2vS0FW
	uA4uFJ8g5Cd1Q1K6exb+tXaA1Cq03cI=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c9tWR53yPz2CgDN;
	Tue, 26 Aug 2025 11:32:03 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D7AA1A016C;
	Tue, 26 Aug 2025 11:36:29 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 Aug
 2025 11:36:28 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH 2/2] mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
Date: Tue, 26 Aug 2025 11:36:53 +0800
Message-ID: <20250826033653.1208227-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250826033653.1208227-1-yanquanmin1@huawei.com>
References: <20250826033653.1208227-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 4163DA0009
X-Rspam-User: 
X-Stat-Signature: xby1ji8t7fgdt8wp3isnypuffdm7jxkc
X-Rspamd-Server: rspam09
X-HE-Tag: 1756179392-263425
X-HE-Meta: U2FsdGVkX1+TCHbjF4dqbxL6UFxeunM4cCP1D1kOjb17fJnKFrFGByl9xhOHcKJdr6tkFYpYEuSaK9AgR2FRvXD/JGkeDGVjdnDqa+uLVtYQnI1BB4GDTaMmdM6A6O5HeR7UypINdahz8Lf4f41cEBzt6CLzPj6ec7j3rYwYBNSpV1nFTDfjf6ZbWmXsvMqGy8ptvIlHd6Tv2JH4kBIabfoZRPpbw8u4kJ+hECxuhEE2kxgCR8OL9Yk5/v0ZZNpZzKX5yjHm2uoh/+leO71++UvrxLNEkuIXJDdzRRx53wzKG/ujjY2MLizkDJskS77IJrhxj6498J9b5glQGZwZXSwwMQ4jIFhEnrLTY05+3wA5zMoD3M+qZpm+fS0QiqTXdqL8tR6hu/tetBlRauDyFFzABc6TF5ayJ0Rp4DCFgaPy+fRRag8w6128pA632tQ9RjlLZ1ca9t43+cAAsFLLgPCTOm0sNyGEFgiE8C5bT2lXFK4LA7OMyEW2xXriKd7AOG58H1PMfcJ6fqmdjxeHLWYegzUcZjDeDrwohcjQDp1FdLXv7iy6LjbVwsZbosuQyfY1lYYVc/puB0CsVHDHWvCrycp1O5vevYr/gyU4bjQ76A4J3Fqb5q8iNH3YrdxaTSgBmcj083WZGztFGz7M+TvN9elT4ZyEuWGtfr1h2QhD5RbmYK+B+rf1HapTWbXhOXH/8bnY7Z6XBmNVyclFJkdXd8JkvkQrsEeR0ObwUsW1NM+HqZLvg9iB4Y8jYeiYUxgO6ljvUzNxVMX1zKuCS+mZpLRA7+n/sd05itNk/CsKeBwisGpel1ZU60x9dLhguL+awRAm75HvU6xrbCAMBaVSqPYEjTVzFjDcFylkIYVZUA3djxHOXgCcpJVUCMmQOe/2+tjOtOe1V/vijwdccz8EfCzMxGW6ilOVzf6rGiO4hzwGipmaJ47KYvBLmFUKwMMFitwt6b+8R3oFZnl
 cGtx1eSp
 EvBz8Ct0wPLw0mMcbK6DgInjJx3ybleVCyY3hzIml0b6+UFlz5qtU+P4d852YSzFf++WSjGuUmECxpBLDkbSddVB6Jx33D370Th6Kvafn6nPOE9OZQHAlBWnjcwqxJU2EYSn1pYzvlh53cyqTTQ2DTx4DdCET4the6PNXTqsQb1oXjycpSX9D/oFz6zgbjtObMIR9a97yLjHQqNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When creating a new scheme of DAMON_RECLAIM, the calculation
of 'min_age_region' uses 'aggr_interval' as the divisor, which
may lead to division-by-zero errors. Fix it by directly returning
-EINVAL when such a case occurs.

Fixes: f5a79d7c0c87 ("mm/damon: introduce struct damos_access_pattern")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/reclaim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 3c71b4596676..fb7c982a0018 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -194,6 +194,11 @@ static int damon_reclaim_apply_parameters(void)
 	if (err)
 		return err;
 
+	if (!damon_reclaim_mon_attrs.aggr_interval) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		goto out;
-- 
2.43.0


