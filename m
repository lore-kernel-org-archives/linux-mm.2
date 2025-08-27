Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A794ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06CB8E0105; Wed, 27 Aug 2025 07:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB77E8E0147; Wed, 27 Aug 2025 07:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5F4F8E0105; Wed, 27 Aug 2025 07:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A332D8E0147
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:58:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6297A84BE8
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:58:45 +0000 (UTC)
X-FDA: 83822390610.15.5489119
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2604B100009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:58:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756295923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1MbREizlFvDKJK+gtpUXVmMoWzJC9jN0yc0IXn3BsXM=;
	b=SdYVEvlhxpo2wE66cEtldl1IfrunTFSle7h+pn36EXpFDwuC/6z2cAAHZDWqcOivgKeMWZ
	2REMUaWt0cXgqmklT4m/cKEe8dyYc658pSO3/pSFavM0usMkB1vTlUL/3kLHWJo6qvF/ym
	Tg1BTrGUu+dnbwhyfB6gRvX1x6IG0jI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756295923; a=rsa-sha256;
	cv=none;
	b=mFRw1FN8ENCYt4yjuKis6z/UghKIztv5bdAgRA43OxaypWyf1tCy9rX9dXauJ9twy1K4LS
	k8E7AmRH2P6sGNz5GYgdt1GJ7xB7TDcKn5+G1JQ5o0q/gkQw7jxFE0rKJlcV2x/icX0VPC
	06+2qtvOsEWMK46tJTYBiBXV2heYmeY=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cBjf354Fyz2VRVq;
	Wed, 27 Aug 2025 19:55:39 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id D64011A016C;
	Wed, 27 Aug 2025 19:58:37 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 27 Aug
 2025 19:58:37 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 2/2] mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
Date: Wed, 27 Aug 2025 19:58:58 +0800
Message-ID: <20250827115858.1186261-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827115858.1186261-1-yanquanmin1@huawei.com>
References: <20250827115858.1186261-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2604B100009
X-Stat-Signature: bpycwjmbz68simfqhradqcujg6f8c7j6
X-Rspam-User: 
X-HE-Tag: 1756295922-897220
X-HE-Meta: U2FsdGVkX181TjOwpPUWEj4eUSwuq4ZiYY216LS0B0C8945mKvAh7WxgrNpaPdhyVyOcmsbP5cbMpezpAyfIk/LZ9oUi6yfQJKj4+It3iOWhIxZ+u4MAyU6Fj5hb1T2ZJAhs1VcUc/Pkda8oWPTrb0DYA9lQh27x2FeHUkmrXB0lil5KBmZiZHEiumeeEH9Rdp5EUGxn1ug25uWDL5luBPwCEZDRYdu6UGCGpZjRGnH7+ZY3+GFfSHdKlRnSyqVzNXqfR738znztp+PahiVm97tfOWXilCQeQA4v61OYAA/E4LU153P7ZFiVkLkwnEQ4kJYC3l6jmcqMzlZ38eYGCpK4jHcJBOAGwf+aJtfUOnPVRrTjQc2K9ec+mUg1RON2W87599GUl9VVb2IPyg4MBqSTsr5iWbww0aQFUecdjqv4Ign/ZDE0NVM+j3V32AFNXphIcUyMrSbcPFL+yo6G8OL58XSlLX8ohExepK/16ZebGMDiGlBuuxYLbXOqqXjKTzDZsOo/pX1eIyqdGdJZFO5pdERAM/4F9S29hmgEMR4Lr/G63iHyOS2rqigoVegDtNbBkSKyjsjR81jTE32E5MJDd9QcP7qeohf4dFc3uR4u+uatB1o0gXgyPlDfnx/rQkvZ+Lc8XYx3MTVCnz+/1Jpq3f/qSwCFiyZVDVAW54yj7R7tACM11J778f3lZO7fRq974YlBxAXKMQzQKQDq9vAXsdAneq/DZBMK5sQz6NIpk/en/uDVP5T1wLC5XeRYZCUr+NKsCc3UTW0VFOECXLxHdQTl6Kz8cbmBP10lpN+mrGW02Q68KJ4L1w/nM4AGfTr0uoQ+ew/sa2Q4QgNcbirs1dYwOyE+iYlSjA3JvopGGArJa515pEfvl6TeBsMRWJHB3uoqRP9r1LXj97IsU5RF5SjVdiCYRMqat8/pHXwmZpO8Bd8Lr8PIwfB5cHtAPYaemYXjgt/WEcZnOtw
 7eMgW7Xm
 FpKHC79oFOE7otlZJ/aGW1rABaCXKrJcg1B4ezlhCTWN4lZ/WOjFdebsefvAXYqQaudy7DYmu600EsWS9X7+5PoRbiqq73UodH1oWyiuuH60FIlCY648Y6OOYdWi+7O0E9+3eBf1xtJStdoY5FeuP9PaPJsowGZ7ylBWLpFF2L8aMVFCFQHYlMBWTSKzL+5QaTa/ypv/0XhhOB1b8BUsno67avVwUbSBxHXUL4XeN6jO984EGhg2m+rrBnSKrZtL9xrQIdYzwkHWUnx6H4qsHB9U2fCeveloyMdlpe5yYvftZGlI=
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
Cc: <stable@vger.kernel.org> # 6.1.x
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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


