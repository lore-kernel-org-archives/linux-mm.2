Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F6ACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 13:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71948E000A; Thu, 21 Aug 2025 09:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F88E8E0005; Thu, 21 Aug 2025 09:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C00A8E000A; Thu, 21 Aug 2025 09:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 798A68E0005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:09:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20F0FB920D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:09:47 +0000 (UTC)
X-FDA: 83800796814.11.8A56623
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf28.hostedemail.com (Postfix) with ESMTP id 62E10C000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:09:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755781785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Un+1KyDLKQZyInpFHFLPkNx4F8ENY+oiYHQEYy6p2F8=;
	b=WtUjKUakG5OYWTJmvrvEmoUPDZdXWV2MdWb2L8JYHJAHOdx4dI+nyNZ6Ue4/SOws6xpIDv
	qVXdKKbDIXm9tiLNmZ7Khhyd2fSj8BAn4HyxdBIyzX/FVgD5toKXxfUDu8zu2bJOKC9hzN
	GEsA5lqtokyxtlclJ79ilYG98bsYp6U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755781785; a=rsa-sha256;
	cv=none;
	b=jAQeRCsPnoCOjWfbvAQ7ygbLg573K5wLb9w5tHOKEUnCc5LUIvG9x8Xhk3jkmpVBi2djjP
	XGfTA6LvOLWEWET+m6lSUhWzQxaN1J+Y6fg3Lv3ADG7+mgyy2i1/+azCvYvb0brdx3VGNi
	BcCmSgeyo5B2i8ig8irX6GZEwUC25wU=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c73T74K8Yz2CgDF;
	Thu, 21 Aug 2025 21:05:15 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id DCE4C1A0188;
	Thu, 21 Aug 2025 21:09:38 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 21:09:38 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>,
	<apanyaki@amazon.com>
Subject: [PATCH] mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()
Date: Thu, 21 Aug 2025 20:55:55 +0800
Message-ID: <20250821125555.3020951-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 62E10C000D
X-Rspam-User: 
X-Stat-Signature: pmwskfczu97txx5km9psrzm3xsgqz6rm
X-Rspamd-Server: rspam09
X-HE-Tag: 1755781783-207495
X-HE-Meta: U2FsdGVkX1+Lu4kO7wVZLdQfS/dON+P5GsqzHKNdIFj++8gGYpeIPTTasxQssf5al3b+GLdw/uZz+SQeDXe8KzuXoQOUVEjwWqxEAE5CB59ItJLmCFc+0VTb2cYmyE30D68sHzlpS/zm4iiiqzBH1GGrYvAEeBWWm1lrISylSnpO0f7t13Zyeb6zHe8xuBPrV4ZDTI2BN2Ap/G5kW3x3dHwARWgmNoypoFzlpN2/p2Rz02tCd3t7Ec80VnKbR6uGLrgx8wYRnvyz/fz/8tUJXjwh19Crn7qcu1bmMavDBn3qp1kRosCYN3p0cLhAgmc/G1I/hrYVtytrkkm06yRzHZ0C3vMJJR9JDEXP+gcoFncFePSPAWdj9sDkrqXFlrcuZNI8SfT8gSJsoJ3XJhZ4/c1cSC3s4r+X0wj7qi+hMPjaJXPomlfHejPOD6Izl0Jtg/YsxzOPXcjU9r8lasjHs975UJz0D2jBXMebHUzewIypYcxe59qf6yXkrG7IQ4wfqRevKbu78RCVAN5jTw+8urJMbuaxtjBm5ZSiTa1QV6u76rtx2mEeZM59CxrwCQTrfQD2MUTjvS1r4mJhqKwHXhYLy4nKsU+jrF/SMxf0L95BNmG5ZWOrW6jK7+H+BtSo0a/hXfy7t8FkSyAL/RpcxCTBsILFW4D0ntu7asZnZm3I3Y1/8RfbOZakkRE0QMNYm3N+tSBQLvAe2MXD37JiwkbTfbr5KbdmpyogvLHFlZT6AlKf02EPzUXSOa9ENt9iNixrMEYA81k0F1z5TbL9OASCv6/++u8+twYtNwxsZC7fbWIQ4Enf6915HLD8g7hRs7Emdge9pCrM6kgEVsSfmZB58I8z6MpKuVU3wv4X49jn/3fLZ5PswFrMtti6k/NjWWqNHYrC43lKL+OiKwaqjAQNTaHgJGerwTUDXljNEkPy+xz4T785TptRVyLeHbCfwRdhznE7XpVRjw9qws7
 2sraByq5
 dH/I5fVN9BnXLEpWBQpsBhNVeLFcIUdXUoPExWeDUjZzT1SP8dgZ/eg2zSc9Kw/q+cyEtK3HuO7KcG1qoGNSrBETQKHaLqCM0lHhyq2WTkck+VUkg+fL0SuOzXliEDhpP/uoRLr+Rv29YVkbpKML0H61F3yPdXKu6zZS89GHezMyN2948zYJ/AR34BSOkcMEmPlELxRewkissCh9bDH5SL4+ptZtgDNj64J+TPlx4BJG+Nm+XD1xMqig8zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 32-bit systems, the throughput calculation in function
damos_set_effective_quota() is prone to unnecessary multiplication
overflow. Using mult_frac() to fix it.

Andrew Paniakin also recently found and privately reported this
issue, on 64 bit systems. This can also happen on 64-bit systems,
once the charged size exceeds ~17 TiB. On systems running for long
time in production, this issue can actually happen.

More specifically, when a DAMOS scheme having the time quota run
for longtime, throughput calculation can overflow and set esz too
small. As a result, speed of the scheme get unexpectedly slow.

Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reported-by: Andrew Paniakin <apanyaki@amazon.com>
Closes: N/A # privately reported
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 831a9afc6cf6..fe1c19307ddd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2103,8 +2103,8 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 
 	if (quota->ms) {
 		if (quota->total_charged_ns)
-			throughput = quota->total_charged_sz * 1000000 /
-				quota->total_charged_ns;
+			throughput = mult_frac(quota->total_charged_sz, 1000000,
+							quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
-- 
2.43.0


