Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00662C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD946B0098; Thu, 10 Sep 2026 08:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F286B0095; Thu, 10 Sep 2026 08:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89316B0096; Thu, 10 Sep 2026 08:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3C116B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:36:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 317C21604EB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:36:01 +0000 (UTC)
X-FDA: 85197799722.06.7132FEF
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf31.hostedemail.com (Postfix) with ESMTP id D5A5020005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:35:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=S2THb0gK;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789043759;
	b=DS9mc9j3yXbVklfk5isl/Kbh3Yrk8IDDKE5HfycdbDoLoNkQTtUvYX0xPE1IzC/7333ovk
	9o4nXKGWWYUx8dPsa0tzyK4kHy0Mzy9v99B23kzZ8sP3cKgGqOTfOpoCQd1dxHpmz9VQy5
	+dtiEWXmMcjX1mMy+rg9YGNZWZYTDFA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=S2THb0gK;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789043759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a196pSrWkeJTnDFClt8myTTQ1/mCsw6g+DgOYrKLVHg=;
	b=w4m9qZfZr+RPUCEMwF4LWYkw+Jz2cVczdA6xSRgJxI4dppTHuDBXdzTcvIePBcvOMqeQow
	axoY7TzQ+rfDZD/txQ2ovQDu5M9Oh5uTWxuIOwF4q+N9QgWfRHjfEUmu/MG/tp6Na7U0fu
	RXvVIb691Z2EJO5EcRpnampAc0oPRAg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=a196pSrWkeJTnDFClt8myTTQ1/mCsw6g+DgOYrKLVHg=;
	b=S2THb0gKiPSO4s0f1f+ZMWWHuq+7dHRZP0h0JVdjj/2SqBHzqgkbz6pN2vzLmpCdKqpjQRETq
	a1C8EtxruZiXgqzQpC9L2A/wvzdT4ScQ6TjWaApzOBcLFJ499WUCNePCuGcvvJgqE7nDu9pA6vR
	WHxbAXo+7n/8i6KaMqP6R7o=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hgcLF0Y8dz1T4Fq;
	Thu, 10 Sep 2026 20:24:21 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C7C840575;
	Thu, 10 Sep 2026 20:35:54 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 20:35:53 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v3 2/3] mm: zswap: skip xarray walk in zswap_invalidate() when zswap is unused
Date: Thu, 10 Sep 2026 20:35:43 +0800
Message-ID: <20260910123544.818146-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D5A5020005
X-Stat-Signature: k9anyt8j8shk9czg4bo9zgf7myuwrdut
X-HE-Tag: 1789043758-673776
X-HE-Meta: U2FsdGVkX18tAEPaDBQEO8viw5Xb0Ln3VHYnzKc1xk64TQ7Ih2+xxP3tWHJAG8xK0fFFS+wrYh5NHx9frR412iXDgzng6JuIBj9HOeFYNtjgHNtFbUqQi1s1kPI/FRnvW5Wf4ACX0kFaofB5nTDx1cmBju+MVasaPoC2QGH9wLX/gCU9dawzzLVxeeMqp37vXeglZH4KfjwMmz56PFzGtKIuTYlNwg5xQ/AkOED6ngiQqlSIT18NUqPLvXnMb81JBdC4onbPmZ3+0mZdf9Z4Gjv5iyYb16+2T0u/bGm80Gl0fp0TMEXjo/N7HXhU5mMBMqAZqNWLcA274ak4dah7onBTHZwDOf+/n5R34C5TbaVrh0zydcNm3NW/qoXXgRb64Q6KeyCmXPWUJQ89R5bUGfyerUc+m5GGpXEzu4fZPD8vxO/w/DO2VjuUNvbexzVM1I4MNFqkjEadqrLPmeh39gXPD+JQhFqSv3A1HliY0zysKEf/4TzEtD1GefA3luHvqWoEdyaNfUXUiS8/Uvdb/A/Ai33aKuhWFKbjnbaRdI3wZMYsdrZYVLh+EvekpQcoC6cagz9EeGxV6OyqkW2I5kR8aKlTHEPTHmOC4vwPAnwkieku/KxIqzsVlZEKP2oc1yApHXMCrnbOVsx0t2Si2MNdEqoCiB49+YCQq2T8nNQ0MaIbAIiy9ca2tW1bFH/u6AXgIr2OGhnwL0YCndQAbzRnbzGAi8eF5bqMCS0LCmITLzU5gSZttOsTqlUCLLq9R0FVEykwivHSI0gXKFB3SVgslLhhk3ZzfBSdJAfq9QqcZH0VDaHBi5m8DdQwyyZaTXMzPURWuZkO/YKahOlhTolKdv1gMNzVntK79znKOLUxb1QKeHbjs/AozPuj6XHKDwVshchnS7jZvDVglkZWKuH8xK6VkK+NuTHKDbyej4i3/i6L/74tyA7cW4S4AWV098VyHXWTUGrXhUSvtMb
 aRwSmGR6
 J6QYtp+9Juk2iNBIIduiQsIGO0wE3suSUGusqCImjBi3VIQC8wjKZ9AIy8JN5r74ZFHiO+GLWduD6WXhmJKi271r/Co48YFR3IkeGWNFX6CuOGgOrfu58zg8//f/ZuGJSdHXc7p2Okr7/VZcRJ1oQGh4HHzmvodiuWLK4rZefODaq6H8IKn0X+0BAxSDYTfo2sBBn8rZBlnOYey7IyIUQZdvVIyEDu2nw2hskefc3l67Wlwx9XFLxy0v0yiXSDE+YmgyJ4HlHGDr7ggomP70txCBpfnomLwkJLHJ6vcAAXGkupEKoQOL+ex5/VEgo5oM9JwvJNV76K9YfMbMqc1A6RgU9FA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_invalidate() still walks the per-area xarray even when zswap has
never been enabled. Add a zswap_never_enabled() to skip it.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/zswap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 79a66093d7ec..132e97748ed2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1670,6 +1670,9 @@ void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries)
 	struct xarray *tree;
 	unsigned long i;
 
+	if (zswap_never_enabled())
+		return;
+
 	for (i = 0; i < nr_entries; ++i) {
 		tree = zswap_tree(type, offset + i);
 
-- 
2.55.0


