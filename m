Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815F9CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301A68E01B4; Tue, 12 Aug 2025 23:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2098E01B3; Tue, 12 Aug 2025 23:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A28D8E01B4; Tue, 12 Aug 2025 23:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA0068E01B3
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF928B7449
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:47 +0000 (UTC)
X-FDA: 83770362774.25.D9B5EF6
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B89BC0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDQ878Yvcqahh/Av9BdfXepTrPWVlNsTB3/XKMQ7kRc=;
	b=PJKbg/2n2foSdY8NoZS253uuFwmCHjvIYfbUbtUzMzVYnS53Hh2AR+zGMkKaIuGDv3uJK0
	rDAKZ5pQN4fT0vTol1q80DEdPxRPHS5e6a5ZwuMZJLpljNfoVe297FryspnhFdbt1ctHy9
	hXH+55Dn3gj5zUhjSRlSPeHlJ6JOzS4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057166; a=rsa-sha256;
	cv=none;
	b=NA4Vj0r2cHvHdexLQsNA35F88EtsllpWvdHrgeKEx0V+MU6d3hcNFG8Ob4+vbfrGA5jw+e
	IjQhVkuYd4gxQnE9b9HDQDxcuOSnzPCWttWqRRTmHREAoq7lj3AmNocpT+QhIxCIO8syMd
	K6lyEKKak9m1vHSe6IgdSbfbMg7JyWM=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c1vVG0VLFz2Cg7V;
	Wed, 13 Aug 2025 11:48:22 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 92E2A14027A;
	Wed, 13 Aug 2025 11:52:41 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:40 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 16/16] mm/damon/core: handle quota->esz overflow issues
Date: Wed, 13 Aug 2025 13:07:06 +0800
Message-ID: <20250813050706.1564229-17-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 5B89BC0002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ye3yrmdhg71acdkp7aaoya4we7acj6w5
X-HE-Tag: 1755057164-402684
X-HE-Meta: U2FsdGVkX1+VeLSMWYqKWkQof661o8yryUPTm5Gt28y1HGL+hDT7ishLZc9MjKGzA5NvY0xB1wcCe4tzclGNIBBvRBOM5dErwcXxBfSB70FDtWMoUgEtCLdKhSNOIB4FWaFGuEEXtmN/yHbv6zaAjIZE3HBLivwMzU4RlAWlF9ih1xFmqQ5TLuapt7jCSNJyhcJSRTM3VZHH1N8FfZS2LPh8uvziTbHFw2kwXdJG+GcK4/Nb5+U6Ad6rSOVxqZDTAVQ+uBN4YTq3hrFYL0+ZlYOoqE5AxkMUs0WpXWPjCAiV0HM3/nmMH+f+C5JSWB8SaAtXBawa1ja2G8R9g4Pyv5MJO7fRUjJmrm9WSJKVzYa17yLOsQV1Bf0OmiOsd6BeBlkrZubrMSAtqcOgKyFVOETSbn0gAj7QVjzkTeeXfeGbknl3FxcutePx+xw0+4wNhE7MTQFwt4XzFt2JlOr2WVN8tbLLFUNUsGz+mK3YSlsJOMdTP6aGkeq/bebg9O3McmPh6z//80q0OeFMf5p59JkIUlL6uz4h4hi5L8N2vfGh+EHMnfmZalk1GLThsUK//ji51ja/2F1E8IC1kfD4ecje3Hodt815h695gYJizl5gr7/UIS3691Riv++CNa3rnD1gP9/VJqO1ZKVKkmfi4o1wWJ5LAdNOD8ngm59OMUcZLh9lzJrYVFodyDpBvCPxpJCL+G7iTaPpRs6+leWuLbpJ8bMQq9Nti5EYTAuHvLylNQxegCYssDi5ACAmfcWQ/I5t39Y4RcrR2EW4lUQo/RKZjsL9W8y3RLGt4TKd9q7m9ZFCa9ICYasuBW4KMPc37CLDSTR47glUixVaM4n3IW8IZiWdkIASU7DmxB+SfTvTM2E5h3gZSQzHUcpVgSOsYCLCUS+vDLgdkd2w73OKDF5t73jv8WRX14wq4FB2772VT+6GvZpLehP3lwDc5fHUHRdGrurVgn0htU/BmCX
 BaGK4l2x
 7XwrBCOQkY/hX9Om+PzyVpCEVbOh7W7xRquSVKC9sGZTT7aSaSXBx33jTJg4Squ5akyv+Ljfif+JOS1ECmZVLdDEwRHq2Vr/cwwRUycbp8bofZ5irmjOLtOhMR+Fnzg7B62NZ66ebZ/4YL4y6+j1kMNxDN6BUuwefoYgmqHkM9LGcernwYPzWc13w36bo7q0zuqslS6aQjteicP+FIqBCI5Haz37MZoQdBa/D8dGKdw1RMkcDklZTHvuvObKGWtrKqtOK+x/eB8Lvvf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the original quota enforcement implementation, the traffic
calculation multiplied A by 1000000 due to time unit conversion,
making it highly prone to overflow on 32-bit systems:

damos_set_effective_quota
  if (quota->total_charged_ns)
    throughput = quota->total_charged_sz * 1000000 /
		quota->total_charged_ns;

Requiring total_charged_sz to be less than 4GB/1000000 is unreasonable.
Additionally, when overflow occurs and causes quota->esz to become
extremely small, the subsequent damos_apply_scheme logic permanently
sets sz to 0, while quota stop updating, ultimately leading to complete
functional failure:

damos_apply_scheme
  if (quota->esz && quota->charged_sz + sz > quota->esz)
    sz = ALIGN_DOWN(quota->esz - quota->charged_sz, DAMON_MIN_REGION);

Total charged stats use the unsigned long long data type to reduce
overflow risk, with data reset capability after overflow occurs.

Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 include/linux/damon.h |  4 ++--
 mm/damon/core.c       | 18 ++++++++++++------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d85850cf06c5..45aab331dfb7 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -247,8 +247,8 @@ struct damos_quota {
 
 /* private: */
 	/* For throughput estimation */
-	unsigned long total_charged_sz;
-	unsigned long total_charged_ns;
+	unsigned long long total_charged_sz;
+	unsigned long long total_charged_ns;
 
 	/* For charging the quota */
 	unsigned long charged_sz;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index bc764f9dc5c5..5e05fdd91c12 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/string_choices.h>
+#include <linux/math64.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -2059,8 +2060,8 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
  */
 static void damos_set_effective_quota(struct damos_quota *quota)
 {
-	unsigned long throughput;
-	unsigned long esz = ULONG_MAX;
+	unsigned long long throughput;
+	unsigned long long esz = ULLONG_MAX;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
@@ -2077,11 +2078,16 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	}
 
 	if (quota->ms) {
-		if (quota->total_charged_ns)
-			throughput = quota->total_charged_sz * 1000000 /
-				quota->total_charged_ns;
-		else
+		if (quota->total_charged_ns &&
+			likely(quota->total_charged_sz < ULLONG_MAX / 1000000)) {
+			throughput = div64_u64(quota->total_charged_sz * 1000000,
+					quota->total_charged_ns);
+		} else {
 			throughput = PAGE_SIZE * 1024;
+			/* Reset the variable when an overflow occurs */
+			quota->total_charged_ns = 0;
+			quota->total_charged_sz = 0;
+		}
 		esz = min(throughput * quota->ms, esz);
 	}
 
-- 
2.34.1


