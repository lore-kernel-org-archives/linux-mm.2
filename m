Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F351CA0FF6
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B55A8E0146; Wed, 27 Aug 2025 07:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664928E0105; Wed, 27 Aug 2025 07:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554C08E0146; Wed, 27 Aug 2025 07:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37C0B8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:58:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFD02C059D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:58:44 +0000 (UTC)
X-FDA: 83822390568.18.2324388
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf08.hostedemail.com (Postfix) with ESMTP id AE748160008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:58:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756295923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UTyseOXI1PyBoiknkUYgYCPC1Sayg6tBm6UudzSUamA=;
	b=HEDwyLEJ4MNnHQsyR6r8lDu+8i3BVZcXXhNrfJ7ESNVtlITNwr9QjwfQiLB4oUp74QJwTU
	mVYwp75u0fmhI6u5ta6LY4+L3ZV3qi9lTvDLqyTqy9Qcl4Wl7MNtud0K20r754VyB9GqYE
	LX3s1VRjejYI33A4+qxWHtZwbqlnt/Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756295923; a=rsa-sha256;
	cv=none;
	b=dD0rGoTSESP+QiO+TwY8mx0fw0q7eQkF5CPnXBaQ3gUF1QyeMFCkIyyXcz2zialTlFWCWB
	178vwjrRKzgLlyzetCX8g3hyDPRZPFIXq2f6OxBduEMl99w5dpI4apwlpCFha6Ct3hZEaA
	isA889yNp51E1ZTdbFEzMe2HAVhimBA=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cBjdB5csMz13N0R;
	Wed, 27 Aug 2025 19:54:54 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 3852414011F;
	Wed, 27 Aug 2025 19:58:37 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 27 Aug
 2025 19:58:36 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 1/2] mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
Date: Wed, 27 Aug 2025 19:58:57 +0800
Message-ID: <20250827115858.1186261-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827115858.1186261-1-yanquanmin1@huawei.com>
References: <20250827115858.1186261-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: AE748160008
X-Rspam-User: 
X-Stat-Signature: x8n896rn4fcokui6mttmm7o8dheqccjt
X-Rspamd-Server: rspam09
X-HE-Tag: 1756295922-908637
X-HE-Meta: U2FsdGVkX1+apvw5pdMoEd1yW67wvUyNDLPYu7M9QVKGraVQs2+K6HtV6rBdYHYdwopvcJby21+MEjDBBgRA4WbWEw3mAMFwjoVSY1UvZdoF63h2Pw334DrHnODS9MozwdXjgxAEqaQTFlb0+VPUwKGFjIcxTmGDCYFL4krpCG3uHu9lPlh+DjFmxGh44ADA0UjSi5FWaBUZhX/dUz1TwRuNOoKiwQ7kWeSQoBMcBNuhPfouaysyafuqXKLIbkP4BF/jH3MEiiEdns4RtEGvunvdDdOoNz86BNaFyO3WrBJDPjhMosUCU7e5njQnzmGICW/sW+/Mbkontypd/Q1HArhfCdniRA5ku/vNjNumZD4z0wLpDw5oDi1d1jGx8Qo/g80ADqWOD19SSrFFl8EHYyeshV6AIB3lXHRYrn4TLkznEN4Qla2r6GHQAceqVXsjXpoc9637YECW9/P0c9Eld3K0+uYaAB19Ur1KBcU/CgHy9MZqYwB52EkmnpekUgxuOiSh9KBzghgz+KDOQ22wJgRVJykcMC/3hJ6eZsIXPlI7AxNQ+uYNnABSTVtjeQwekq8E76BaSghLEB3n+SIJhzOP3KsUmSFfaDEMs3vYLrmgYS2mPoThsMPAqX/Lp0cslf1WquZbGHEeyVG/a4VCr8NsCyRR3QpQByFElpBSO3JTZ5m8c3+HBgkQAoNkl9NE7ttMHgNzaH8Q/tZ8TyHCH5ehOukYHy9woaNzPNHdfL/pVCdMjU4gN3c5g1Rx8/tiSvy3MSDyx8bTr8O0T1rtlqQENmjdJ/AiANzSOMHgJj3inFFkNUbhY8JLvpWn8tEJXAoQ+82W7WaIvhw9nqrXlES93F80CWEmFzyeTLGQo8fmGUeimX1mmthQmp22xGQ0eNXNmki+agxqCqKK0pkUHBnmF6w7z9mo+kxts7EqqMsUyB5Q6giA3yGzc56bJYea+b2EpU6xPIr1Rnku6hz
 TpQarkcz
 Bg4tJinKc5WnIaNGrg4Qm2GTSRtGrwQw+6i0hR2CR8QTXQ8B9VOyl98D1+EaBMGEJzMPN6U038vGTyPHtHvQc4N040wk9WMOdD68qXSJ8fe+TX7msL+vEMwXTt18WHpLJa6N+ZQNibAdPQQTl1HBtDP4GdI7bJVZ1nz8wOR1cmQO62eJsArqXE/Miy+Ptss1mY/n2VsT1OTBEj9tUsqK5ICxzeetw+VrOrfO3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During the calculation of 'hot_thres' and 'cold_thres', either
'sample_interval' or 'aggr_interval' is used as the divisor,
which may lead to division-by-zero errors. Fix it by directly
returning -EINVAL when such a case occurs. Additionally, since
'aggr_interval' is already required to be set no smaller than
'sample_interval' in damon_set_attrs(), only the case where
'sample_interval' is zero needs to be checked.

Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 151a9de5ad8b..b5a5ed16a7a5 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -198,6 +198,11 @@ static int damon_lru_sort_apply_parameters(void)
 	if (err)
 		return err;
 
+	if (!damon_lru_sort_mon_attrs.sample_interval) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;
-- 
2.43.0


