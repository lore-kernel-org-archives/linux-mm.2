Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811A2CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78FB98E0015; Mon, 20 Oct 2025 09:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F9C8E0002; Mon, 20 Oct 2025 09:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512E88E0015; Mon, 20 Oct 2025 09:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3610E8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:17:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8D25C0177
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:17:09 +0000 (UTC)
X-FDA: 84018543378.02.C7FD58E
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8B9802000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:17:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=g5VLyWi4;
	spf=pass (imf13.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760966228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hzZWxSIYi+JVfYnlDNwIrYbUMB0DxpyA9gkTSqNtlA=;
	b=Hw8CofkGC1NINbIb/XhRfEm9kPNbbRLmJz7aaVB06fAZbf2XQGDYoDdaCeXb61VEXkSX5l
	ycmJEvimT6pnmYPCWt6sjtlEhfKT/Xj12iT09/otJcN/dxqoxBRMfaO/0Kxer+nSUQvd0/
	TlnX7KZCbkVyrnw4+dRrvHFVvETJyLg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=g5VLyWi4;
	spf=pass (imf13.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760966228; a=rsa-sha256;
	cv=none;
	b=2pumNMKbygf/pKrXKb3+LVqYSRH8AThT6WtpcraHK3cxG9HtVs+u/aRckT46HaoR6vnOsp
	rFJwZCK4ZiKdgpUY0vul+i1OTrcmglexhtEc04ASmJ5gVxsGXmXF5wl9leW+lIKp2py32N
	X+alGuUJs3ac1F3ySGojWRKFYHMRgWM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+hzZWxSIYi+JVfYnlDNwIrYbUMB0DxpyA9gkTSqNtlA=;
	b=g5VLyWi4O3Y2K82/N8WkX2UDJiZzoqRrDR//Q0iFzgGbzZgbzTwvVJMK3qwqrUOoygL+6+O2v
	9urAr0RbXO4rpJavMpmvC+3IDBpAlVjfNd27zafHeGB+sy2nRUvpyeIaqRnVuV1pktTmbljmF4J
	oKKv/7Eug7rrK8tUO/gXiNk=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cqwtb2lHtz1prQ0;
	Mon, 20 Oct 2025 21:16:39 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 3DE621402DA;
	Mon, 20 Oct 2025 21:17:03 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Oct
 2025 21:17:02 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 2/2] mm/damon/reclaim: use min_sz_region for core address alignment when setting regions
Date: Mon, 20 Oct 2025 21:01:25 +0800
Message-ID: <20251020130125.2875164-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251020130125.2875164-1-yanquanmin1@huawei.com>
References: <20251020130125.2875164-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: dajhahxd5bezk9xwy6patg64xhzh1rqk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B9802000E
X-HE-Tag: 1760966227-112097
X-HE-Meta: U2FsdGVkX1979FAHQ8oHv+qXkqLGPDQuXKCPXIyctFK2keznMHdhxNwvd1VzH0Bz3w5b4JhfH1pfXE9hnRbMRXTEsYd1v0PM6R4dz3TQeVqMpEekbhq1AC0sS0E1UoXILov6282HT2nN8/2OIiLd3o9S8PgJNgXIAHLGCZSC1tA1ZIhBsvEuHJwbCJOXfexsg6EOiTX54UXqij+GtVkBtp8iTriny57VScgZe5nHtoLxzniI3CgCs+smZ85EbBMnEQaWeVqlC6Y3ivJpOjfJpyIgpeLRVnJIRPYQhTaXX4TAs01ZuhRMFqYVz1vaMvhWd4jAk6LuX1rboYqz9YI6wBMTNG+G5ZPIdtEXswhZkJJwJs6NxRCqCq2UhQrKJRGFoGQhazhevnbzLUQk9eGhyxxeqfpztiegFTeK2zTSldpC9FCogkp+b60R34ZjePLNjkE/j0I/JYlX+nuVdbZbE0kevKL3VRAUcRH4WDWjs5fPcGZZNUGl86CJQ9/FycmJ3c+yFRwI8nQzsavWRKliq3l1Kpa6nm95yBziLFFaJmvOJWTu4ka3g3kW2pMFJTcoV6bT9ulMRrNCezW2jSOn1lYGcCSbpzGEfIdXIY7DLJpg9dBD++YKE8A/tSHAxrXiyMkToln1ysRSEl0Q6RA31gBJ39tXyORZsLiSl96pkBVb5XUW/aS61AQkb7L872hI5rmch+KDUr06hNzkLxMbg1l/ZXXClNo1GNCc63r5RdIsbyY4eHF6YzHNaw/xeTO+P8ZMvvPPx9frDakeWpENp+ISQRA1XhD6DV4ckWnfTw3sVDPtY5c7TwxCT2aGbXX13oZC/W4qeFVBS4Qqk6iYteDgLoib7zHdnHhzusyqf6uPjjRDtY9Ql+W+PPaNzMbx26Z6+hSphQQHIm+MHm1R4taRgR5q0KTCR7RjwCoblKb09hA+c6jksL045kGFN+w1FIcFZA50K7PfIInC55/
 92s2ze/S
 h/VkNAhLygO/sjDI9eWMrIw8OsTgBLfPWMPGNvtpII4+ot2XQaKMK3MmOJFWDptGOqkVHpQKKs0Vw1UA+qzXoraeaCOPrJrf40/eIo+cdm/IRbnSVLqCrrX2OP1DGQ5i5hnkyMF9pYKzoBUAcxTGEU2Kn9b+XLxvwEKgRO2nbWW/61MCLpRSvM/3thEIhNMwRduYdmFlcI4S2GdXMwvTzrpOK3zowXyJYtErQZbjFruK4eJoFXgPHhM8k76HD/N4Fq0qBLjWaGWFFwNozrihqYDcn0+ZQrLpPYBBTuw30rKOc69Gs4qNWSaJxtOwHBzpge1vL/nVtO+7ksMb5zLjqrZLpGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When setting regions in DAMON_RECLAIM, DAMON_MIN_REGION will be applied
as the core address alignment, and the monitoring target address ranges
would be aligned on DAMON_MIN_REGION * addr_unit. When users 1) set
addr_unit to a value larger than 1, and 2) set the monitoring target
address range as not aligned on DAMON_MIN_REGION * addr_unit, it will
cause DAMON_RECLAIM to operate on unexpectedly large physical address
ranges.

For example, if the user sets the monitoring target address range to
[4, 8) and addr_unit as 1024, the aimed monitoring target address range
is [4 KiB, 8 KiB). Assuming DAMON_MIN_REGION is 4096, so resulting
target address range will be [0, 4096) in the DAMON core layer address
system, and [0, 4 MiB) in the physical address space, which is an
unexpected range.

To fix the issue, use min_sz_region for core address alignment when
setting regions.

Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/reclaim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index e30811cafe90..36a582e09eae 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -251,7 +251,7 @@ static int damon_reclaim_apply_parameters(void)
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
-					DAMON_MIN_REGION);
+					param_ctx->min_sz_region);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
-- 
2.43.0


