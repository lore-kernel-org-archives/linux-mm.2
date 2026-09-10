Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4618AC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806B56B0092; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3236B0095; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590CA6B0093; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DFA46B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:55:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3AF880458
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:58 +0000 (UTC)
X-FDA: 85197393876.27.3AB5B8B
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf20.hostedemail.com (Postfix) with ESMTP id E7BCB1C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OQ91Ciw6;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034096;
	b=szRyASKjn/1kPeNUW+kvOdiK9WAKKpyMPgrl+xfKbLN4IKBgMHKFjSr6Yflz/vEblVW6/D
	d7+SLaN6YcBLeZNzIcdmeYza/A24DYgjkN55jIKqJz00dusipcDTr+Lg868FexMy3DRl3N
	AvbNdrk3Dsd24d/6J8PXgQd9g2QLyH8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OQ91Ciw6;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpwvl9PI/MY5HXXx2Gd1gMFGkrcLuXqxSZNt/120jhU=;
	b=4j/QL6et9cFyZxThtmIj7w7Hhpyc4QHAwz4jnbHC3JKGc6fVZDJGHM/tImdOJtOyIYsZ2V
	IaEx0vfxHSpEllWJ+QrQrCtLQ39HvLiYdFeHnWYqc3nq0eB3j2XZ4/ipdlClZjz+3eoXov
	HPVvY0BANYE6dIZWJ5RSkAIp09QAht0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rpwvl9PI/MY5HXXx2Gd1gMFGkrcLuXqxSZNt/120jhU=;
	b=OQ91Ciw60mNyUWwdx6VnoNgPC+gnDlfAKx40NG3WoQLcmwzUe5EJJDcZuy/Azz1tmG8b5wIhX
	YaWzSQylq/IS81cruVbBPsxjad4uRd+FjbuhOp5C+2P9g+NPgvH+AgkPKVmzGcQ5y0T5G0Rx9XW
	Rp5BGs+wIxGoFnsmLUoCj7s=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hgXnC6MFpzRhQs;
	Thu, 10 Sep 2026 17:43:59 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B71B202E6;
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
Subject: [PATCH v2 3/4] mm: zswap: avoid unnecessary xarray lookup in zswap_store()
Date: Thu, 10 Sep 2026 17:54:48 +0800
Message-ID: <20260910095449.715183-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7BCB1C0002
X-Stat-Signature: tqr3sskn3prpee3xr34dpb59jmgfjjds
X-Rspam-User: 
X-HE-Tag: 1789034095-674307
X-HE-Meta: U2FsdGVkX19e+LSd+UUWUCrDCxfa7g9iHaDNxu37mrFcBPHvAGl6VVdfhpe/KiXAvpb0fu3jH4kGM1sJIt8/3vH+kwgW3Urse3XkIMlPYemPVnOTREKFUtN/FGHOK0lGdiftXwj2ydFbF+W90GNXygZUTTSsHxsyRCsAJTG2ITaOoYZ3WLQzbnS5yV54ak4sbrL8/J/Hw+6n8f81PNoQxpZcdNFZakQPQn7t0IHbebcM1CgCfjYxoBk/6Q+pVS8CdWg087lbVuBs2DArntq5dJD0HvJGb1oLkGz3alqOqbH0wCbm+OaiBqiYucsiB31vcbTn+EFv+Oh0fAoX1Qvo3KJ6u8ip7ULOutJHT1T5tkLheLEbTTvIZvS6fWx+YIQOpV2aUrLiEmv3TOxVbhL61/kIcpEXilL9anCxnTfGfpy1Nmvs6rbTZKaSvj8M0VdBM00ZBUSPddn72SlI7SFrAMjFv8+zN1gFU+CSQWVjNM5FZJSeoFS2p9CQ84aq5Bq3YAVLNEQR2WHQJYgXoCRmiJIluS3duXp1YXccfZASgpAIsiueadQuwWr4YoHPwDC3BnVEx8i1m98jMEncvmDNN3aksaDfPCvNvmU9Jw5nwYSy1YalrSsuZFFoK3UBMHkDJHo9TpKAQfl2ZNpRUVMzavDdfQz5tuifr7qAY6hw7PQxoAuvuZyT4I//iicEAwmAYUXKJLGBfGDMRt/vXFF0X6+vO2Gz2oII9k6FO5I0R0Gx0jFz7H35pDKolKHtjd2o+PMYNR22Sr0HhpEz74agcGLAkFv9GukqfLobPszxCzwAWS1iLA0AlvtVPXpUIWglTbVk2y0zX9FY0b2jSaEfOZZ/CaA33Vy+EZBti7yKl9deRI7Fkt6Z4h6QTKVmU05bwM/3qAq4lOgtyEiGEuE8EpKAwWCxFvFGRY7xdvhcyGjNyH2/cNrrhBdq7Lx1y1SPz2S5nZHmCtPDI5t8jkD
 K2vxxPtZ
 lRh7uOMK/Va15Isf2rnihjOdKq8i9aYmXM1JpjHCSPVFpbUiit+m35sIMJ0kcAOLzo4vHzurh/t3kOYkOlBEwkIklwb1m1cePQR9nuDhC3tsgbZ2/rSkykfMUEwP+syQSYtb96B0uRNYsBBcT+Mk66sbkbaRqBsp/reXSXCT5Qs3QdreOVNIGbA155WgxJdZVtOQK6Oy72mLB+8CWv8Zlm1NXR3TrFQscsewpXb1rzIWM9KTk81YZWyLypGvsRQlqos+ipun182Lh4i7OJG3H62su4c2HlFb6BrfhT2j2jYj8tlxIOiINzPpJHU1lN2izz/ZR9V6FyVaSIwSS/RS3RHpfLrEosdo9eKxL6/fTb0va9SCsGPjbzMVOp9RipUG4DfhqzP0H/8wt5m++MAFA37YTRoYc/4D8WIIpIb3oiRPLq0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_store() falls through to check_old and walks the swap xarray
even when zswap is disabled. Add a zswap_never_enabled() early return
matching zswap_load() to avoid unnecessary xarray lookup.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/zswap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 2c06e4e0e130..6197aa71e33c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1492,6 +1492,9 @@ bool zswap_store(struct folio *folio)
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
+	if (zswap_never_enabled())
+		return false;
+
 	if (!zswap_enabled)
 		goto check_old;
 
-- 
2.55.0


