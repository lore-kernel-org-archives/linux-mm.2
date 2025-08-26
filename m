Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6845FC8303F
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C61E8E0038; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421518E0092; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE608E0038; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 014DD8E0090
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:36:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53627C0607
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:36:35 +0000 (UTC)
X-FDA: 83817496350.28.542C4B1
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf20.hostedemail.com (Postfix) with ESMTP id E99751C0006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:36:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756179393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=llOdzFhq+YfB28sGUHCnAG4Tf2jfXaYobV7Hdd8OEDg=;
	b=f8XT/vfDMyDXEn9OxfP3RgNHbFPAamsNN1wVbIurUktleMAxEpK9PPxd/8K8vEh5xNjqhP
	tkLkmcB2uuAyONc+hTzorlN9e+kQpVlQpfT39LfNAmbtS/jGEvT3quFqQJ/x4shGjTUKbD
	aM/okC/aQ7xKnosPBkaaFZ4WIrFmo64=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756179393; a=rsa-sha256;
	cv=none;
	b=BdRoOkS0RG9/RhzQzO/v4D8WAkli6q4ClF9EigKabd/x5F2guCC0jiUuWO0b8wT48NT6gD
	kbTET8FaJxwsqiU5Cg08jwdSUQVbYctwi9/sOkGkbR29l9i5xWceVOyQ8RErEqRr+3TpUN
	uGVwAzUrvNU5autDhdwiiUtG5W6Cjng=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c9tY76lHXz2VRMw;
	Tue, 26 Aug 2025 11:33:31 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 6029A1A016C;
	Tue, 26 Aug 2025 11:36:28 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 Aug
 2025 11:36:27 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH 1/2] mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
Date: Tue, 26 Aug 2025 11:36:52 +0800
Message-ID: <20250826033653.1208227-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250826033653.1208227-1-yanquanmin1@huawei.com>
References: <20250826033653.1208227-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E99751C0006
X-Stat-Signature: pjxaijajz4xwxxu3ateyihw7f5hfmmr8
X-Rspam-User: 
X-HE-Tag: 1756179392-272749
X-HE-Meta: U2FsdGVkX1/XU5P3zR4ViVDL/gVtrRX+3zmtytn9yGh2PkjsaxQ0TBftSz8dZR0ZL8eKkts+XlHn6rQZt+2wDe01G6Klff2zVGGHQGRoUjpnVDjmmAZmhOYvPwwzaOZXCkKMuAklW3IIZXLGUTui9hw7YV1z/59ynhGyCuPj7M59a8F9r4IxiAdREXrbCK9AWefr9ZGk9VLrbzJf/b0j/xqvef/m94wVYxseuMs0s3Z0PHmhVjNW89x5P0Sa5ObDKReh9DtojnAll+kFSE7N90lM9xRQ1DDBv3JvTk0wGurfI+5383rR+RzTbHPvqBkATr0Vthbp527aHS4PMe0nwCOxbtpxXQvMWiHBBjDuArxjedCYsEYjQyw5XSh8xIEPxdtw5+183a8QIzt//85GhD6CFq0aR61kG965c/hSqD8EQIsh35fiAEpMQVQTHHpZXtIMvWOK4XrYmZgTxz43Q/JMwoFj1336MwdRr4QYVWl/iNGmZmwXfF6WMjt+vBSA1ffEJ6efp5jz8Zsa9+wf1LRq66hhy/vqzFMRHdzOsdpnGsqIFswrb3mT+PEl5TbH1GfIRjALwlPoiuCdHLLZZz6+7bkt+x0MtduLaMeELi/wtvPJhU+wkqsfBRVbbh4Wf4azDJyFDXjNwvZTqKrwul/bjd2B1nVAMWGGwDhIaXXByJJyDajX7kofSApd6iQs2jDgeOffYyzGwT/ILQRcLY6GF9fyliRJ5gn441Spi08VrG4OZUzGB7QyJvbaNlS3tu20YxllWwlXlAjveqCI5nqUWp+EymgGrQBUpr1dcAtXxV6+XmOwwVZRIjKqyS7OkwB/tiaVhSmtpqigCQLP3ed52pD1O/3L0RUZOtQNMyUv5LuANNgn7Wdeup5BsyGNxuXeRmwzb2mEB3ghlBdQiLKBr+M9Vm1M09Os8V9CKrPJk3DAS0I44lSihyEsruI7fyVn7TxvAxFKxaS0K4L
 6nkcuV+J
 BOVp8+9cZGHFmyHfS/tiEZ2f0m9500YTqPNcvB7GqC42a8UCOcfOjBjXnmqbOUnibe1u7xM63o91CfRAB5OVYjbno3kJmA+24LgnN60TSr80VtVu0fX2a8GgbUbTODufo0hbRFReuzezW0FUrhSK+An4ZEAsLScgau7G/ms7jyEx3Y4U4NfCr0cstWyWowLRNFAJUkPtpesoCuKmKX6vUSpWc6HJzIol1mEIBbA1kV0Bq8DY=
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
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
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


