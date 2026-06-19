Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB90DCD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DCDF6B0088; Fri, 19 Jun 2026 10:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5306B008A; Fri, 19 Jun 2026 10:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2E76B0093; Fri, 19 Jun 2026 10:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 688F06B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:59:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7A031A04A8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:59:28 +0000 (UTC)
X-FDA: 84896970816.02.59F1D87
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id C277C20007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:59:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781881167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bY0zsgQNRGdot1/GBvs74WqAm7W6VQas7soUq+EVbIg=;
	b=V9VGuB56E8U5/2AdMBLJY0J5pUDC517CnhD2zMMlDI7PpKCBi3Malu8pxhDscwypE0E232
	9rSNB54jALQSrowltKchxS+MqmUqvfP3NULPavEYhrE74flY0Dmajv9reId/1eY5K/fAWC
	pCd0jzfK8IX34PN1y3WVsVT3ICD0ejU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781881167;
	b=1vkSXfPq4l24B/NfDZbnzhxK/CbtO591ZY8/sB/838EgVw2znOur+t6fO9Tb0x6qPoGdd6
	z/0JML4lOkePhccbyYv5Qd8gJ1LQEo/6JcWyck8dP/h8WArJl5aWlksaboqcoPZPF4KqqN
	uVbmCgmylLpkuwYeCIU2+pyHQKuIIpg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ghghs6bbdzJ46Bd;
	Fri, 19 Jun 2026 22:58:53 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F85840571;
	Fri, 19 Jun 2026 22:59:22 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Jun 2026 17:59:22 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Fri, 19 Jun 2026 14:58:20 +0000
Message-ID: <20260619145821.2109933-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260619145821.2109933-1-gutierrez.asier@huawei-partners.com>
References: <20260619145821.2109933-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C277C20007
X-Stat-Signature: 6mhawssb8pgjbi5zdp63cife5wzgz47n
X-HE-Tag: 1781881166-614303
X-HE-Meta: U2FsdGVkX1/64RJ7LFSY5ee46fH0PIcZmidlk5cKu7xkFv+gXWxyjXg9kQg1iqEr5CkruwEmJvsAUq+EQDEaaQwVZ4q64EaIsYsq8C+NXA2DmiR6/I9um6zN/KQTihQJYyjfWNZTZ0ofNqgZ+1DgcW2Oj8o2yO2592qcDKXP6Crzrh8ZQzwKO8BjCK1Ca5bGre2OX74w5KjUMJErrg5CAyeVxaOHbPIZrhuhF0qtby2UmjL4n5FjF3PoAL8l6BBkf8N4RNzI8DMI/k+qILM0k4hUIlDOplNLudlCeWNnKUfW7YRYIePaByUJ5O7Azjy2CgcNwjUrGYXGnjp1XHNTO78GJo542uZ04+/PbmUw8kKEwxnzAGSFO4mTUx3Ope271mtm0pmeIkWxG++aKbswHOFdrKqJHCxOHCXSmAfUXVPhUC9CNcPjcqHc8xMbxMJNpIf+asXUhA2sb4qSx4AwXMGre4CDYZQVZHoPh+8up79A9ROsCCS0G/2UyatTNq9TuejtGYzPjqZYo1NavWt3Z7n6CAlTWtRS28T3iOthemcH7uwCB8nBlLzz5gSo7JXBq+q4Fr9AKbjl2vCCenN/pQmSqudO8DrArmUpw1TVcIzMYwW2vWBQHfm0AQ0mzgsx0AkSYlsKKYGBef45g7709p96VUGlOasU4DnVZvXCVQFx2j5egzL/RU9QoN+0/sKrXK/b89HyxjNmqK2/7vy7Y5DJLM8X6FltG8wQGKfEf3X16OLI3vXN40CsOgz/2Bee2xXfjeTXSQwRahGCTv1hbAzb7OIT8pQvTSsv4kGpZQ6YrcodrdjNhS0RiaDhpQXKFDuXmGGyo3xt0TVdX3++Kp7BeLICGcaIaGbVCDGSHyOR9eIjJq8cZg5E9Sb/Sw/aTKfRZXgk60d8Jrc5OBiDjRM0z4yn2xr2788IPI0/cRLjLz4DiW+SBOZpP3AI9G6ZcVjoKT3wYxgvKlyWDn1
 sU7aoLsm
 pwj6Qf+c/SnhhPym7CocW4hqiOAMJHXYR8ZmP/Fju2QGlTtEQHZHgSEIgCZLyXyiV7w1gEF+YvdqPiv3m1vLXVSVL4jVT79i7oGnYm13x3j7meYhOm3sfw0GQvpEggRlhfgAqAQ1p1LxFAN11/B5cIH/oooy5ZJvukSNCIpBBMll6XSfdRAjL6B9DIdDCmOp+nl0HwS6yvf4tXEbK+3NQONVDbYRlCiI0ekpWy+zMcsYDRoBh9LKj64uZNFzw4Mwga6Tzy00NzZh9x3XqNvQABE0ZyoqgFjRV3uRJi8RWVDb+pkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

DAMOS has a new autotune policy metric: DAMOS_QUOTA_HUGEPAGE_MEM_BP.
This patch exposes DAMOS_QUOTA_HUGEPAGE_MEM_BP through sysfs.

Add the "hugepage_mem_bp" to the sysfs-schemes interface.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f..4b5429a5b415 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1267,6 +1267,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 		.name = "node_eligible_mem_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_HUGEPAGE_MEM_BP,
+		.name = "hugepage_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
-- 
2.43.0


