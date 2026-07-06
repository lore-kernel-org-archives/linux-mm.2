Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438E1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057736B00C8; Mon,  6 Jul 2026 07:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006CB6B00C9; Mon,  6 Jul 2026 07:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5EAD6B00CA; Mon,  6 Jul 2026 07:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD3296B00C8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:20:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E555A0381
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:20:11 +0000 (UTC)
X-FDA: 84958107822.28.2ED1113
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68447140004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:20:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KL1SYCqO;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783336809;
	b=rI8g/Who2Mt0qZZ5iqB4KyPTGuiqs42Za4Vsx2TDuayvC6Q9snAPytec2XppuNhdal7gP8
	rlE14j8q5FNnMe/VuADdQmSvooPmrvdT6PRfDVkmo5QQx7k+7JqMUQ6h/mbRPyov1Xnhi7
	M/FobPu5U8FKDNjVksY/BOawpuETGUU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KL1SYCqO;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783336809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EAxKDEsUYxlHwffEzchzY2VoONZ9w3p1pymkmYcICmQ=;
	b=2FOBraw7FqsPdZh8v4y6Q9xjdrHMdSeXWyGxWzoHcCzjn39x2OybyK+1oTWpmJiep2la/0
	aqq3yMVKridMlNC/auMugSOVQsDZgVfPQFXOyScXPhrpQFCQaINdqAHetStNI7fGTjuVop
	8jnhDtgRczFlJwZAHpy4A0wysbOxIXM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EAxKDEsUYxlHwffEzchzY2VoONZ9w3p1pymkmYcICmQ=;
	b=KL1SYCqOYa9/sckRtoBi6B1ccWhG5oV5VGkXgVufbgDPHSWxfAgLpGn6Z5WiZRr04XsbWxXPI
	t0qzleQReEwKeonc10QqVECCF6dFxylv+vy41XIkcER5xrFe/YFFI5w722uhf//QEcE/7H4nEqJ
	qpMqdHBK3V3AOeYfDBJD7RU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gv1rY4h0vzpSwT;
	Mon,  6 Jul 2026 19:11:25 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7688C40579;
	Mon,  6 Jul 2026 19:20:02 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 19:20:01 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>
CC: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua
 Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE
Date: Mon, 6 Jul 2026 19:19:58 +0800
Message-ID: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68447140004
X-Stat-Signature: oko6pqjsben8p5pjspe9chsdct8kq61p
X-HE-Tag: 1783336808-625779
X-HE-Meta: U2FsdGVkX1/ohbLhptY9uQr7ryTBiYBsxsC+eo7+DzVOO3RZvainllCtIaQAfvpQlS+lev0tttaVVZFBT5oDerKCCcSZMXeVjr4P20veApQPEe7yq3U5Ce2cM9v1R0Jf15obSMza2NRER+3rzlgFkztUmq4/ozk6UWxv2CP1m5DrQrscPVfwmPrE4OJqzJlyHFkRIOErPcpC7kysM4IBgfadXxFhSmyYxYNTnQDJ4Eo/jRraegv5bJ5mKJgkPYlAk9LK35gxeXqEVyhS1xTV9c5rHXZIh5LaFcISAqY19Faz8shbCciNmnq5HB/FQU/o9mVK/2kDdVysn9oD3yCOJNNAoR3pZV4GXZXondOMqxHQKQ4WTz/S8ZfFYWlh3f/gR0D/16lChLiUF4b3Y99abrUsV9Zvd0onuTtTDJdbm1AQwgaRvp3VJ9VoxXlnGEnAcvpL1ve9FbeQVG4KqKnJidC9yvxhGeJlxw1zgTY9zOBWco059TdToucnCcy6QyKHCXyMQ2rQWsYVYXxc6GynQP/LyMb++XTCn5waopcIJ6pN/A1q++617Hy24NCyhu2i9cQ2U66sKbuVFKK/bqvEzUlqmfiRDl+1DOLCcVD0BAu67SbcyUKGshjhO0zl1rynjqv7C3g7F7dQe9L0Gre7Z5h+aP+712H5AT745PrFjmve/kFaZbv/J7NvWMoUr8pcJ+rYVi6s2HpEtpOaLXebFHfoMgSBvqi/XNZ6Hnnr3I0F7cvn06sfPRGqys2d8sDtd5/240uH4I+08oLctqyIiTz4deglvB6j041cX/5e3lNkK5WsQ6InIV1CJMGt5utRNHQn2duimpJTo2iXVNWhnAj0wr0tjWzCgzEHcYECpXvDrHyvJCVUcZjNgIY5dvYSDsSnH2YfReGuifAhvEWDuHWGIj1xzbi1yT8iDliePrIcPVnoNBGz6A0whLohoWbjs0WIlm4Ti09LjoFTbPd
 U5xwnCnY
 vlrFtD0EJIXh8Jm9YPZrbXu+2aMN1d/BUZcxSLNnwoNkYHfRK224gITTGxiRaS5LT2dK9+hPWyPUcoaOt/PQsbupAK0j696QPOv0/iZj3vx7KcbQTiFbUVEVfsxYog5tnu+b4v5zjquUBl1OUroEo7fTQyG8jM7nXs+9Ks2o2J2puYIysY4D9wdYbuM1spxJY7/WCyb9kU6ehHdKq2kNU8qrUNnQB3QXKvhC9zc0vELDuMNczH6LMi2xILTZqRaJyLAuRgAYPqzosPHlCLYM7sM5bVprrNnOtWvRhXcNXO49C5ZDo8kOOKbjCmN8WQUDAlXEc7a8BaPqwJCASXCbCbXOuyzVZWE54xPpUEVFev+ZrhMNw+aOgR2NOdLo39FLpmP0GLPYwPooijWNAq4WNCB3H2LJ3vI/4ZIxh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_pfn() and pte_dirty() have undefined behaviour when called on a
non-present PTE. In migrate_vma_collect_pmd(), these functions may be
invoked on non-present entries (e.g., swap PTEs), leading to potential
crashes from pte_pfn() or incorrect dirty folio accounting from
pte_dirty(). Fix both by guarding with pte_present() checks.

Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/migrate_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 052167f9ad54..6e711381f092 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -411,7 +411,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			bool anon_exclusive;
 			pte_t swp_pte;
 
-			flush_cache_page(vma, addr, pte_pfn(pte));
+			if (pte_present(pte))
+				flush_cache_page(vma, addr, pte_pfn(pte));
 			anon_exclusive = folio_test_anon(folio) &&
 					  PageAnonExclusive(page);
 			if (anon_exclusive) {
@@ -432,7 +433,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			migrate->cpages++;
 
 			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_dirty(pte))
+			if (pte_present(pte) && pte_dirty(pte))
 				folio_mark_dirty(folio);
 
 			/* Setup special migration page table entry */
-- 
2.27.0


