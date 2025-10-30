Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5275ACCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6921C8E01B3; Wed, 29 Oct 2025 22:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642A78E0106; Wed, 29 Oct 2025 22:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580028E01B2; Wed, 29 Oct 2025 22:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48A028E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:07:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F034012AF0C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:07:19 +0000 (UTC)
X-FDA: 84053143398.28.AEF544A
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf02.hostedemail.com (Postfix) with ESMTP id 50AF080006
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:07:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YU8+A9Fh;
	spf=pass (imf02.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761790038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lQbFuRe/0xuO7BK5YDklifoaPlkhacuORBMPC4fqSg=;
	b=JI8wGh+nRruvDK+4Z/I/IpAAddO93YXD9qMVhojjb8tDyCr/TdhvPGRge3oaPIlk3cjBIL
	AhkUGkistszbrGZtJdZvqj4lTd1bIoIxxi0H/ZTObE+XGDVlgV9dO1t0ShtUxkTjn+Hmg0
	w3VFr/q/hNTOocS/KB+LEjbbjM23bJI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YU8+A9Fh;
	spf=pass (imf02.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761790038; a=rsa-sha256;
	cv=none;
	b=NTVmqHNly3vk1fBaiqRvrm3opvweWp/hOjHASGcvaK4CMSrK3myTOAqASgzeg9MEQFHad0
	j+Fxf6klWnuPH/iAQdAWOysZ+LVFmoSlSKSO5je4RWOxU+rQVegT6A8X8+Xuyynxs+j+gt
	mS39pN4F0khUfhGKYFCbKcit2RjBepM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3lQbFuRe/0xuO7BK5YDklifoaPlkhacuORBMPC4fqSg=;
	b=YU8+A9Fh1PyjGZNM4lKgkU0lc73vXHuAqphJpw2tqmXf+puEYsHp62CbDSEExG7VGTh2SEIpj
	/VnDSz/9BtQG+PH3GEvbe1YV+yyB/Rb4JFQsXQneGlXVVu+/pvTTBM+ppQ+dzI+JwjO7dXSsSBg
	h+02tlQwpwDUFGk48zj2O2Y=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cxnX14ptSzpSv6;
	Thu, 30 Oct 2025 10:05:53 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 7FB9A1400CA;
	Thu, 30 Oct 2025 10:07:13 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Oct
 2025 10:07:12 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 2/2] mm/damon/sysfs: change next_update_jiffies to a global variable
Date: Thu, 30 Oct 2025 10:07:46 +0800
Message-ID: <20251030020746.967174-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251030020746.967174-1-yanquanmin1@huawei.com>
References: <20251030020746.967174-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50AF080006
X-Stat-Signature: s89c8a959us9rkdrqyesa3iwcmgjrf8k
X-Rspam-User: 
X-HE-Tag: 1761790036-139088
X-HE-Meta: U2FsdGVkX1/0qRe/FoW8q4X/abk0HX+IREns5c31OQagPnKd0cH0XF79K8/X3lBw2CJ79r5HNuyW63HY2j+D7Ra6X1rsG9VSq+0K1ajDQY5YpAx9FgWHVoqzbL3fUtm5rsMf0lS4g1qsyrjcBqlSJncwN/lYCZU+2YxfGRR63j8sPtoiaDHKkccomzC5VA6Gdu9ePsQgwVykDthDxkJ27wYDKRKRBOiifEV1xhTsDCZEZQeh63hup4oJNIgLruG/pfOl4uKkz29vZf4WCo6iov4Ak4Uwt+2XDe8aazWXvheHasld8H0uEVr6s/9+CoEaAn3DLgCxC4U8//3utKH2HJWnYajng3134sMO8UW7TpSP3k0V9CQV12TAC72pX2svifD/DvHL36jHlPyhzFmrBqvLnsOE8F02xvm6XMBDUOHcdNoCAA+f4GoW1zWNwiwkpiZJvCMPnXE8XkyGDwJ2mpLAVFufrJTaXcVX4B8tUafLXqP/Mm6yrw6Mpcm840st9lkpqr++P+6r+3/01/YtYPk6vT0o8oWsrBEwJE7PNdkDj0BRHvSsTWWrVLR4dclt6nMsUMof+EG5PrjIELucuVZGOxrISkQSD7bvfsIzozLGbtthil+pWliSeyFi6XmZcpUj+zAtiGeIsRaVlF1QC5wUmEdW9sERkf0LiGbfnCOP50NSNGaLwwMaCc9xKuhkBO/uRL5sYm5C0AaSbGes3MD8PUKWulH0PLRyva1RbCF1k5K+j93UbRAcUfH8KvWXQU0oDYYt01a6jocMs/mLbZNX79F0KilqC8lXAURh8k0wBkP8T8SA2A11V6OOgXYSdOGRb5K2uUdnazSFEh//jKVgKwGko3cEvgs2m3sesJ1pNRxPACjwx4idS4NhgoVioLLmF6WYmOWFnAwfVt3749gV73k1/PXcwEhGhWg2PvpPlg0f4MzyZE6xSXIoy1yRv3Vky1dBr5OYdlMs4Hq
 zZ8iWl9O
 2ncm0rOehiw1ire0OI2M3llb8OZRJY71yX+LaMRA3lZq3g9omS4s2oNiHClMLr66LnGx1o9vYbJy0IiXuSFookEH6+P1F8KDOaefJFuJadH407sE0CVVDxJMJ1lS1aLfqJzJPuiOkeDYF0C7QZuHsDX/pXPIlbxB+hgdzwhPVxyHRogZEBiWE1vyMfCQizRdt7dOQJRVPhQTRbl/X8QZ7myK59usJatmY0pAg9n64EAaO765KQfM4Mai/Ge+PIQEwYiSrUPZDOaC/uvuFQhyhJOLzNC1Ni/qFA7FKo73iR9r7WPMjnOki1O5unsdXHKNs/IrkGqKOgHDq/SiCaoEW5WELpVOX93htlw+JP3uZqX051SD/S05cvfW9KPURf4Z6/cleooXzrQ5pNPtpG3yPYOIbQDZmmM2ZSMcm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In DAMON’s damon_sysfs_repeat_call_fn(), time_before() is used to compare
the current jiffies with next_update_jiffies to determine whether to
update the sysfs files at this moment.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier. However, this causes time_before() in
damon_sysfs_repeat_call_fn() to unexpectedly return true during the first
5 minutes after boot on 32-bit systems (see [1] for more explanation,
which fixes another jiffies-related issue before). As a result, DAMON
does not update sysfs files during that period.

There is also an issue unrelated to the system’s word size[2]: if the
user stops DAMON just after next_update_jiffies is updated and restarts
it after 'refresh_ms' or a longer delay, next_update_jiffies will retain
an older value, causing time_before() to return false and the update to
happen earlier than expected.

Fix these issues by making next_update_jiffies a global variable and
initializing it each time DAMON is started.

[1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
[2] https://lore.kernel.org/all/20251029013038.66625-1-sj@kernel.org/

Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/sysfs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 43ee9ce4dd84..e2bd2d7becdd 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1601,16 +1601,17 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	return ctx;
 }
 
+static unsigned long damon_sysfs_next_update_jiffies;
+
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
-	static unsigned long next_update_jiffies;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, next_update_jiffies))
+	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
 		return 0;
-	next_update_jiffies = jiffies +
+	damon_sysfs_next_update_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -1656,6 +1657,9 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	}
 	kdamond->damon_ctx = ctx;
 
+	damon_sysfs_next_update_jiffies =
+		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
-- 
2.43.0


