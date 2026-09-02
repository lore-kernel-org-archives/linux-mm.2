Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7009C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784936B008A; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D9C6B0095; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587356B0092; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28E7C6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2A0C1C0DAF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:04 +0000 (UTC)
X-FDA: 85168872768.18.1A83C25
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11EC3A0009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2RG9sDFc;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsItdggoL/pH70R61fsubbblLKE8u/0wryCQVrxs0VM=;
	b=D61mBQvJYoIVN1MUD290GS8d6jVzFm4hJ17cIt6gcRdAe03EKPKjwqV2JtkUaXVEO/nQo0
	r3fr7s/t8Fpc2AWVUPFyYtJ2qDpNMJQvDrzkpl8/7T7wFY8Zck35eXt0mrSe0SEs10d64A
	S6zzFzLakgzQ6zGAQjeP6SS3RaDAfkA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2RG9sDFc;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355022;
	b=GLktDe9sqDCXyMVY5R6vfud/tHKDwlUXpuk74bGtxZT1xn9yuIfCS5mmahJm/KHEirdP4V
	Ftvgem5oD2+VI2ShUUBj/yuevonq638jcuZ523grFt+LXFqXe7bWVGa7XsznWMeAzXhn18
	CvBiKbtq8ySmHb7vd4e8zNIauniPiUA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nsItdggoL/pH70R61fsubbblLKE8u/0wryCQVrxs0VM=;
	b=2RG9sDFcgMpmLnKYwyCd+Aat75j5gFfE2K+rc2lyv6wU3o2Lnnetiw/ZC4yS+kihU5WUmZbe4
	o5KIP8sxOK31IxMMaFG84XSa9pv4RE0SRfYSAymq2wlfboEwxY20a5x/dyYI8mR17lIslcRVKvJ
	MQYc1jht7/h6/RE7RTFEF1A=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hZjfB3RfCzcb0T;
	Wed,  2 Sep 2026 21:06:10 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 71F94202E6;
	Wed,  2 Sep 2026 21:16:56 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 2 Sep
 2026 21:16:55 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 2/4] iomap: simplify writepages reclaim guard
Date: Wed, 2 Sep 2026 21:16:51 +0800
Message-ID: <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: zwfep9nwsufw5rt4ss33zm9hthsgwrrw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11EC3A0009
X-Rspam-User: 
X-HE-Tag: 1788355021-630764
X-HE-Meta: U2FsdGVkX1/9lQQLzZuSRwYLXtXxxotZO8ldUntV6u40uMHNsLfftaxvigR8X5uKXY6V8K8Z9lFEDCidkf5I20guGYLoJzmf1zc3VabNm06GeIZu0G6qcJUVY0XqU/gv1nPmgf8uZbAVcfHkbVotFMZtIydW710nADNfBSjDZ9AWCSTTStasvTXhrRW+KOPswAY5Ixh3jd32rV77q3eNkqkhzQDbTrfPzcXo3v5axHzQTUuJ+BqFRQR9xI+fyJcAQG/V9J9AkT2czYZambtLm9maen34gJkJ+nTsueol/Vw0vZetRsTO1vP9mTkxynLlhiPlZjvdOV/xuE+qe2NsqnGP7KG290lOSlDq7dO7vgj8Z2qV5+Xp7eNEdk75fxYTYnGD70t2MRuiznGu1IZQt38FWLN9Lf6t5j9NchNPWmmLxOoFY88xbqKwSC0d7i6RdGgw6eDFAHTXLK4rAMvgpE9QL8pQmHuPMSp+py11nGEaxXif2wwQyuAde6jqRXFwHKbFEnGnEl2JTTJHz/gHTMDt1VR6O5xIxsG5kzN9vUaTFvTowfYUSJaqIpFV2OM8sRgC66P/EFT52O8P5R/+HlRAyEoLVAby0QEmCxavisG8uF8KnuVAjdEk0VDjnZ8l645RgNGI8nWiKndwcSSUispPaWtc7YZ15dwZnQppDH8HhEbM+/HACyzPzM2XNmmo5TEXE83S5UqgBqCojAsgNqAWeGv6RkZ3zetvw3LvNAK9kBQj7gJ3GycOzX1svapvto1Lsb68fsU9RWH+fjb0/hsQNdUjtfIswXs7TzXDclbPbxMwlZjvTtKyfn8z8CtLCrGYDvmIyUHluseRFPXjRdm7OpRp6jstlj4/PLYQcBqhJH3/HmHb+MyPxswdBUCWaCglxc74bm47SxDis36RtTGJ8eWzh02CsG6hTQGRtTIk89XHwDsF78uSPgce8ERfJmNgx6+pZNF8LYfkdp2
 PDR5HW/J
 dylXifWsIAw3dEf55pFfFe1+MIzlwWdl3ZKibO5o0SZYBpWl/qU1AALEDNsaMmFFZ1de9f7v6eDJk1jFom9OmsZ8caf29scw2uzdiU4g+9bHLK+k5HjGLjfjTUCjhWiLnqQpdF7FT00IW26skW3Dw2WXOvKzKVbWpoBJ3r7JYvq+PgDtvlDdIpr5Pi8tgXndTIp+RYPx0A16OIu0HFVAG/2uYKeBMeqQUlSOCHWMUd+tYefZ5YcifDemLw+rxnqzoPQGs4I1WoMzL9ijX7Fu+kxGaxpJZL7W6PvZW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that kswapd can no longer reach filesystem writeback (pageout()
returns PAGE_ACTIVATE for non-shmem, non-anon folios), any PF_MEMALLOC
context in iomap_writepages() indicates a VM regression, simplify
the check by removing PF_KSWAPD.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 fs/iomap/buffered-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..6306ca747f3b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -2077,8 +2077,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
 	 * Writeback from reclaim context should never happen except in the case
 	 * of a VM regression so warn about it and refuse to write the data.
 	 */
-	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
-			PF_MEMALLOC))
+	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
 		return -EIO;
 
 	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
-- 
2.55.0


