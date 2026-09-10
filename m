Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6493AC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F756B0095; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24B86B0098; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7476B009B; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 679546B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14DE14047E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:59 +0000 (UTC)
X-FDA: 85197393918.08.DFB3DA0
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf15.hostedemail.com (Postfix) with ESMTP id 231D4A0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PasgboiQ;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034097;
	b=tjnqRShfIGcurFyoegH4ueqblR0rIk+NI1CvN5xzm12bMb3BESbCRSkcZouGtnMfx5NrPn
	6+H03VsGbfcL+RqTzffhFn7Ve1kC/UNuQ8Kshy13EGk5RPNt3NhArF8O0BS32Y/429iMwd
	dWuWuIEVFVtGpG8xfN1H/hK5yBC+Peg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PasgboiQ;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovbFxwCNHbB8G0hURmEkvpDbAzDv+nonn9A+bOJYp5c=;
	b=07l9LYAE0jl7s2vlggaOUDAa+PRkzPVgmpkaFp91b6BH45ARqQcoTJbgd3UM6PGHGGcpc+
	K8RrpcHcnr/0uW0l2LDn06expgkbr1ot6WqzDoXr4qyW2K6UwHgw+rEN/HZNjTjx/IXgW7
	GrmSuxoayCYiD4D+xZLPb/0CmOwshs8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ovbFxwCNHbB8G0hURmEkvpDbAzDv+nonn9A+bOJYp5c=;
	b=PasgboiQ4hx+/+NdzfQVWaVhFj07liWp4O8dvxZrG02Cr59972JAo6h5SXffZMLLCtKiRKsLw
	ZIQUZ98NvwyXHYVQlgKwQp83/7QyygnpkzhblJGtMvKQ/tiSRTMSU4lnmky9T0ovR7hNJ8KDkgg
	jLg9uG7GY1x6x/zCaInAYQg=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hgXms1Ymhz12LHk;
	Thu, 10 Sep 2026 17:43:41 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id DEC2B40537;
	Thu, 10 Sep 2026 17:54:52 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 17:54:52 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 4/4] mm: zswap: skip zswap_invalidate() in swap_range_free() when zswap is unused
Date: Thu, 10 Sep 2026 17:54:49 +0800
Message-ID: <20260910095449.715183-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 231D4A0004
X-Stat-Signature: i6j855xn8hgekdwnc6ph7ahw3cocwijs
X-HE-Tag: 1789034095-561638
X-HE-Meta: U2FsdGVkX19FiP32/B+y0RS0IqQm3Re36bmptueepU3jLsveuQpR8PI1RlElLmx7GZggu6/SmkAYLxuL+W+istiDKQFEx9HWjpKd7+iN5BfWJQYB4/LpBVT2w/VjsAHvEWpwPdidSWc0+tSZUxkIPV7TfydiH+KKeA9rVRCfclD2yDWVRL286qwcTAMRZFXs2gwPxPid4LddPop0JclJU5zPa5flLUADn313Kl+M0M5BS7M9PxbtySq6TrBmy3QQJVAhi2n/277FaI5naKJ9j5DDkZhIdv8hhMcpO2hQVF2kIEnFhd0fGOsKlnYJk7u4pY/t0ZyqQqe3YJqZcebXnYnsTky0Cku3idcl8wwzW8xpoaHg6N3USVI9pJfcEjL9Fak8COZLy8jYQCOKMY8yl/2LWgbQjHUVwWqsWGMGRK5MTE1gUUOvwljc9xPyS2wPtKFUl0R+Y7neIZKEAdRjkj6O2w/DbgJsVi/oorGefYQnL+PMVDmfyazQR1fX734fLdhekk+4ujHgCTg5B9vXuNMw1Z8zLB6kYtU4ZPJCkadkzROECk5rbi2bbCXouvSn7Qt520z3iFgAe9uVDiRKCi3xJj7wuY/0ZbSOD+iyhUUGUhA3/daxn3oQ+vtR0hhX6MeaQ/mtwwwyvdjBbG7GLvF9FObmIHyjzXrhNxUQzoVMU8cMO5eeloLoeEhBEPEkv67UXBmKF3vfFaBGgSx76azIquxp2kvPkt6pvBWL2nWMv/3zpyI7KPa2/9o59udQlQdGO+ROJvEqLREveVFTdzWuLZ/UtuytNJeDMKsL5Gsn5jHlBcCH5AQFPqFwPECz2qxrrUz++5Kry+2QfrKtaJt0Vo22iXb9QqfeGOE2axKfhscArcr5VFavBbxMOmwygy31eR3uPHaWwDMMIzzdmG503SVipXEVFdIGkfDnYoXq6rhYY5ciKq+ADxDWAexpNkUAxJjvLSLD1fAyNpS
 EbyT5zji
 LGNt6Tp+Y0xktTi2LWZi3u+6Lu2DOsG+99r2o/7Wo6BOU0FVq64jgtubgjuGocGQkGsDijkKRfJswYG5K+Ylsp93JyrZgGgmePioeUG/iT9iNtHAoHYPRGL/0QYHfSgAPJxsMYUrR/Yrlq40oEI9KISnHtI8j6uUUDBRDFQwNbhOCyhrzkkdXDYibmKh0TSLMzHVb1bT031dq/czwGkrF508K562FlAZdINWvItPcAu2SjBaYc+aZrBqQffdw3XrOBI43BfneKVIpTDu+SC9gKd3uLcRiXqMiMQ76RXavjXl7hDqEVtbTsKBFyB/6t31mXeSfmWLanwX6c+uwrk7V8+uweFUx+7gVB+epj0alvjgQWa+nMu3SgWA7yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_range_free() calls zswap_invalidate() for every slot being
freed, even when zswap has never been enabled. Guard the loop with
zswap_never_enabled() to skip it.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/swapfile.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ba71905e4d46..505592051924 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1318,8 +1318,10 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
 
-	for (i = 0; i < nr_entries; i++)
-		zswap_invalidate(si->type, offset + i);
+	if (!zswap_never_enabled()) {
+		for (i = 0; i < nr_entries; i++)
+			zswap_invalidate(si->type, offset + i);
+	}
 
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
-- 
2.55.0


