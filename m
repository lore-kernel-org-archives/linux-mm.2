Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CA3C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEAC6B0093; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F2F6B0092; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43AD16B0098; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2320B6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FD8BA4D86
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:59 +0000 (UTC)
X-FDA: 85197393918.27.159F0FD
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B26640006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YYWHaFmm;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOaCqBD7Arbba0pL8GlDbZU8Y5xx34em/O7wohUgSJU=;
	b=IcNiDofbd+bUSXOYsKBkR5cIkSMiG1Dy/h3YxcRDB9vsD/2zxMbDw7Y3k0U2NnRMcF9jAL
	RV4dtdccIL06esAQMeWUbuUavx9kbKjD2YzcmiC5q/qGT4xDRFvAcy5jaH8ic46LjolWRb
	yEyIUAOCXLA6A99HNXPZ8OlOjKTlQ6M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034097;
	b=t8DJJ9sBkJUmzq5F3jHiuvudN6rpKe0FaJMDlIsQbCSX3dbVjur6ifwMCd0i+NG3GUjcAA
	BbG/1JGMc5VvKKAn61g6X3hYroaJA92dyVw+moz69hiYVNgyswJzSMpXsgHJb0RAw1iL+R
	5gBrD2CP7a+We4MLCBnMvLt9VwcWlDE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YYWHaFmm;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BOaCqBD7Arbba0pL8GlDbZU8Y5xx34em/O7wohUgSJU=;
	b=YYWHaFmm/UO0YVCZKyR4wsGGyN+W4Sm/UVbWsWXVwKKmMZG3GIOF6E7E15RBh2JBle5rZQTkO
	WNh4qxvvNr8BnnlMmLMHq3G/RlQmPSWQBlp+n1dF6fzOg3vF4Z7EIuH/zcOdkq8Z/0QM85U9hqz
	ivLMA1skX3EY0LY8Df6ry00=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hgXmv4STDznTx7;
	Thu, 10 Sep 2026 17:43:43 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 309BB40563;
	Thu, 10 Sep 2026 17:54:52 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 17:54:51 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 2/4] mm: zswap: reuse zswap_invalidate() in zswap_store() check_old path
Date: Thu, 10 Sep 2026 17:54:47 +0800
Message-ID: <20260910095449.715183-3-wangkefeng.wang@huawei.com>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B26640006
X-Stat-Signature: td8bx95tjgxdghjphc9hebh7z7utosqh
X-HE-Tag: 1789034097-120094
X-HE-Meta: U2FsdGVkX1/fFHQb18QK+CPyJUsopUO8WegwST49bZGKm3rXe5UeAOjwOE8LTHe+ExekA8JGN3hHD00oygUuVzb77zO78PKZ6kcM/pFt2FUuz7NsfLYc0HOlQSkwNUihGwL2QSBwrL8YmWobiJ2EPpurEy3jvMjLE0OmcGptzJnappHG3Y8xgcW6yTOJN5AVYY7MNnRu8tGO1fyuKFyYSb43s6aXFzQxsR1yFNyW4VmRVIE2s7/VaE/dOXy5yhzv7Rjq4lw46Yz9gAMzWxXMKskWBP1PS2era7hohowUJUyRQIxovK4DN4av2kTmgRWFl1d+mvZ4vIAWoy3G5/l5XFwi2ypXtudo1oIoH1oW7g64Os3/bp5KhoM6C0IYU6rrCWiUf2tO/ZmO863/Fi3r34bqzXIrkAgnK8k+c17hRTBZa2Uf9bi7TEbhqq3DIT46arRWt9u0djqqZV769TZXa0dXw6YWrKAgf2sqEcW5yLRsUN/MGdUP9NyOgXP2PvA7eldPNtrB/hP0kouY3fHPsIr5LBW0Lk4n5c5NQGr6oDvnrjRnoxy0mDAXGy4DcwRK9a2lRtYby+gsjRhezO//OB04XDjx8ovH8mHkMHemwmQfM/mI1Dos2N4bD/ZmOVDLtInmXOrFxW8dkwmZa83Cd7qAHCecbiD/N4PvdznxeCkv8+aS/uKjGlk9SbQPRJACK+6x9HwOQoBuK9EtM/Uah0Wa59x+u6YY1w+Vomzyu6GzLF+Bvo7h8WRIOzpWWLHIrRPyF9wztX0435CQbWDUBdGmjgXamDAAeEJCuHi3uYlddgxawZDuqUNWWq8bg3BUUFmKpmPLlDwe2O54cHSv7YFRhDo2dNMDNluSJOg0Wgig8MyamO/XS9IzeVb/yyHvfAPp4FTpnwxtmGnrrCdRzwTgKPyjwUTfryVeyPPxVt1GDmpyxguRNMic4L1ykAX/Sw6LRiTFN/+b9or+9/M
 e2w6Aoxt
 qphKETokT2YsMGFRaNxvvo1TopzUElvhcr3TcPDjOnU2zBjHQy5PtN2Y7KGcKj7lAsg7Ae0scKf73LOUt2i52WmZjvV0UrgnnDbHn9NVITI3QbMrAkadpGFElNgnElJ6nDlieJnQZVHIor2EaXerqZkO0O+CPS1nt+drVkM7HLzk4e6234e1OknApJeXVSLY4qh0/p8GGUT+8VKkDvItbumsciXe+vdO3FxrZQa3Kb+t5kTN/itqlvT9+0qWLbBN1HXrc/7z4SKn6ZGDUKKAC8kK0zdGPCzfEucQfLXpm9WFv/lYnJXlI5g+8FBzVMjYDxNCMbe4p3Cs6bFlOenXeHZKq6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The check_old path in zswap_store() open-codes the same per-slot
xarray lookup and entry free that zswap_invalidate() already does.
Reuse zswap_invalidate() whose xa_empty() check skips empty per-area
trees to avoid unnecessary xarray lookup and code duplication.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/zswap.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 420c405d0402..2c06e4e0e130 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1549,15 +1549,9 @@ bool zswap_store(struct folio *folio)
 	if (!ret) {
 		unsigned type = swp_type(swp);
 		pgoff_t offset = swp_offset(swp);
-		struct zswap_entry *entry;
-		struct xarray *tree;
-
-		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
-			if (entry)
-				zswap_entry_free(entry);
-		}
+
+		for (index = 0; index < nr_pages; ++index)
+			zswap_invalidate(type, offset + index);
 	}
 
 	return ret;
-- 
2.55.0


