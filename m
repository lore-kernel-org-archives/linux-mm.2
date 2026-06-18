Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 560B8CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3721F6B00BA; Thu, 18 Jun 2026 05:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C02D6B00BC; Thu, 18 Jun 2026 05:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF0A6B00BA; Thu, 18 Jun 2026 05:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0B486B00BC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65D421C4BE9
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:29:01 +0000 (UTC)
X-FDA: 84892509282.15.F4DF1BB
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3F3E12000A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:28:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gTOmBBDP;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObfAM6baGHz8e3nzgMPFx3gV1s/Yg1jEG94Y39RIIDQ=;
	b=R0uASc5pnx4MviAhpQBYNl7vCpHvCYcm2eLhCKg7zpGvFGEDdq4NEWZubU9GEOCnai9fRt
	hqixFwPQq2asE7X7jiMVaBf0GKiERfIfLXlT7AsJLFnmuRlu7f7bcB1Q4ZpUWdGFDAP+GW
	CpGWavzoo0U9MM+GgqCRCHPrQFvO2rI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774939;
	b=CuVjRA8/O18cOLukP9O/KiJrHfeG0K3SoaUsfwL6RvPSNf//DN8DGO4TjFZtVOzVVDBVAb
	0/B2ChCXaYtFdAALLifIuvXO35Xxti3ZTOz6N4hj9xEhp2YaIL6DBFufzGSV2KjFi/NSAC
	6+IKUt/PwRQjXUNszNnlh2H18HNxPIg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gTOmBBDP;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ObfAM6baGHz8e3nzgMPFx3gV1s/Yg1jEG94Y39RIIDQ=;
	b=gTOmBBDPbBt61WHYsqsqQLFpZ8EVfWJE6tmn5HE9O/mCgEGJrXfOh7DY1c3gnK7uhkGKOM6qi
	s8dDwm/Iz5e+9nGX4zzRGB8zX81+EisGIbS6S/wTSo8Mbz2SJ9JSxbbyPz0qK22aYoQupXKN5AT
	kpD3GgxscGJg2Zryfop/NvQ=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4ggwFP2ctNz1K96p;
	Thu, 18 Jun 2026 17:20:57 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 366F84055B;
	Thu, 18 Jun 2026 17:28:55 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 17:28:54 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 3/4] mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
Date: Thu, 18 Jun 2026 17:28:44 +0800
Message-ID: <20260618092845.3905740-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3F3E12000A
X-Stat-Signature: aynrwgieiemiung4mriiwehfy3kaj3pd
X-HE-Tag: 1781774938-208245
X-HE-Meta: U2FsdGVkX19Us/ELm65+T/C24rv6HKmJF+lhVO0IOb7dH0KBYwuTJ/dDQWnGZ0pSQ+09f7xuNrp+5KmpHg4AwgGN5yVNgnvLopVuPIyQULjiq/LKoRdhS1q2f03xJP4FCHbokFSW9BAzQ09vabynt0e9ZqVL6Wv1n8badhq7VvnPfdUnpxIuUKJExqmUTvomMCZnU9vyZdMBRfH9IvGVDYfRlsCecYe0lyxJALu5yN5UTrsUH9JIkyJIzMDZI9DkULA1xm+OTOT9pt4SAtB+rWgDqYsDMQ8eIj2QnxMMqUWufN88KJIvQVL6y+mXqwxIGf24Utxd10IgqJ5doXvSr/LI9UzEKedGDxGFXt4B0nOHj8NbiGqd5S9+ij3kpfN1YNqTP/asobe8xCK0N7txEh43CeK9um83AtuCS5o3gAFX17IEvNv6xL71Pm+PpfnscreeMXVjH7/VaY4oaVx4eMHGwPoBIIk4wooLCTrMWg3NGIwwFMv0roEEaEsXdFLe8X2HLIVlZjfQfR+RVYP5yJSQhs/vXW4Vu4JM/N13HWlxziOpDhEaxoIJDkEnxUEr+rQYjUHpqUd+zk9CqM8nX4NYyuEjkKEt1GADIiFqmx2cK2R4O44vcj5ym6/2T/5hjT2IE9bfuPXlwxboqzZ8N+bJXU25gFL7n8bPJuN+eJiWy1R92gbW7zm0IHXy9iDPgdnUSyD0W1IJv/hzJ3u10OqAQPfvXbOw/DrTXutwkr8LWm3BbkJFCTp09Nvbyy9URHk9FCVOXN8Z2qjPk9wFjMFpGpgIkonJShnsLxFb3vIF6T9MfKXdGA0bFC6FTrRqu+TloPQikyNMcz3Y26b7MNdBXqERnx7St951n0kO7cYo7ZjVYdES0z8F/GRQlHg81hjSJg6vDhg2HWwHYEA/1Xg82JMNLGx83NjtT8Zz7JYcdednOCP1HT6OdFg6OH+fkLNERlJ0NYsCQnnd7t4
 l9htjMaf
 FFmtxde8gfH/mvHfzGJZmWaMF8M5+fcx6mVj/hWfDf8tF4BZePz3FVFXsK0EUWUzlujuxUSdyfD3vb7lEzD7Tq13BL1n2IOybiiD5UTrccvzhQr+OSdq/tNVZwK5piRbxG0hV0GYgs24MUd2/PFMfh/xZtgMPRsa+p0HHAaGFkEB9vRmrz//ORftDUGPMUg2/5+Eo5Sm7FvA6IINM0K8Xbkn1QlSmfAmtvwgCRpWrWWiASdbOJ7p5r8JSke22yuVc5JAbuyV3aOhBFn0Q0MGB4xYikvwwmbldK9J4ttFTJwiDAsrec+le0N3xYe8MskrDV1nprKjwEWZc4bWzrUHRUrIzvkC4Z1rHC8C3ezcPBmefWvlCyQqgPjTDGXLTEHaq74Qz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mlock_vma_pages_range() uses walk_page_range() to walk the
page table. Fortunately, the caller always passes start/end that
falls within a single VMA, apply_vma_lock_flags() iterates per-VMA,
and apply_mlockall_flags() passes the whole VMA.

Since there is no .test_walk in mlock_walk_ops and VM_PFNMAP
was filtered by vma_supports_mlock(), it's safe to replace
walk_page_range() with walk_page_range_vma() to eliminate an
unnecessary find_vma() lookup.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 8c227fefa2df..97e49038d8d3 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -446,7 +446,7 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
-	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
 	lru_add_drain();
 
 	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-- 
2.27.0


