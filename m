Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82FC8CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384F46B00BF; Thu, 18 Jun 2026 05:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336D96B00C3; Thu, 18 Jun 2026 05:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2729B6B00C5; Thu, 18 Jun 2026 05:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D653C6B00BF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63B011667BB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:29:02 +0000 (UTC)
X-FDA: 84892509324.26.1A1BBB5
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21E49C0008
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:28:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2whYae6G;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdHUd95f2tCLuLToKlGJnuJuwymn/ci/xOpoaumN+sw=;
	b=DEs1VP5Q6MyGy3TDsnRSLoUR7P2prH6bniIwuTrndvgwhaQAR1RS8faNAO+cEGXvjYQWPO
	5SEZgF7jMNmQkg1pVkSaWHLTtW6gJHMBpCCy4pK/HmRkW7by2ZUNqpO0ZhjrpWVsLwYrmc
	MwJXJG7XShTmJkiCBHdiAhpohD6YaH8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2whYae6G;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774940;
	b=kTL1Vqms9Fn4y/I9Kt+mlI0C5uO29dz2/qoodSSylOjLoVnebjsx0a3dCaHBGdaxQwot9b
	KVwOd42c0mJ73ruydmItaWffhNFux6O3sk6csaHhC+V3Crs4FIBtSHpZZPZ4qh+/xHSy5w
	n270/O1KED/Z94nNxSGKnhROvOG1eyQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mdHUd95f2tCLuLToKlGJnuJuwymn/ci/xOpoaumN+sw=;
	b=2whYae6GfYei1tQQsaMx9ecOz/PA8BsQyVX7OG9kRW+skzMDHYty+8YlldU1iijdHg/bXsA5+
	9IjD+BNmk4WfxQBuTpoaYORA88o2QKpRaKbxC6PH+5MoEaH9iWJ+UiJyskGwtieNRW0bHPY69M9
	TAKKERFEUvx3RgwrVkog+AQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4ggwFN61lPzRhQc;
	Thu, 18 Jun 2026 17:20:56 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CCB0E40363;
	Thu, 18 Jun 2026 17:28:55 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 17:28:55 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 4/4] mm: migrate_device: use walk_page_range_vma() in migrate_vma_collect()
Date: Thu, 18 Jun 2026 17:28:45 +0800
Message-ID: <20260618092845.3905740-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: dp7ei69k15p89t8z33fbyk7mzhrtq3po
X-Rspamd-Queue-Id: 21E49C0008
X-HE-Tag: 1781774938-85912
X-HE-Meta: U2FsdGVkX18nLegWxlXHkv4GglRAMeMD7VTqj+HGSXmv7PelowJ8an8VGdaVMEUBNhFQ8ve2KaNSxrPH/gGdPFJLKXfRxcAuCPKBKxQ4EkTcX6yYXtiuqeIy/ku5nPDPAHnBwwcCMgEBUfD88SyQicAViOgSai1WgvKbJqftu2L7yemZMXgm89ZlqwCd/R4CaNnOpGIYN407QrXMyFm1cfyZcgGby4VEywEBcwwdZeeXwb2/PKUFpZZZPz3H/fM7IJgIsiyG/diXEUeD13U1jseLGwHYFhzt4h0cZparzSaZ+prYc2drtE9WtaVXY9eMJW8LbjpVTLndEBbRKqMkqUzI7Ey9JK8nXT9/pj5ffwFq609TTdi1rFpCLPV9/wWnK5TL02hoFg/mh1Ymq6YCcyvmap7gNwJd5CVvpQwL7Ca+/9JbIY9GPdxWwOE5e7CkZ4ux84VKmxXa5zSe14OHdeaFx00X+vuvg513gBuQcsO2B5N+DF45yuxv1bXRAMSSy18wGhgjscWWuleHw6s53kQ/m162CiHqH4n2nU37B4ak2pNGbAxshdSNd+3W9ty322BJZMKwZc5JqY6oHltCPndDUrXqtSBWnSj2ZFJoHLKIRVT0JdgTeOzepTEvYt3DLC+tW4h9ofYpw/pGvVs+O3cxS6cKROc3d2MR7hgn+E9UW3EmysC9emIjB03xm8+tp8aw/pWcKXDudjOLVj3ij67yuBytXir5hpS2h5IsQot0PuW8uKFcnU1ZEIw1Pqpn67llGBAOGLNm56GpDlN9Xe3mefcE8dvko2MC2EcJC8V8WeDMMxBgrKyFhl3GnmnnYis9ZrzAGaprxROEOPQfKQ1uTW20UkHE2MmTcsO9e3vwSXmrPk2JRPfy8qbbkS0eFSn8txo7fgf/RcukkBJdL0xNZFLtYij717MkvAt7mza9BkpeIkLft+ndjmo+t5QoQWBF0wFOmqmvfJfEL2n
 1kSUxNrv
 1NeDqoVtVEF6hiteHm+bqg7kg7SFb7Y8mnwl2/ZwsM87/m1xFNqrdf2WOU6g2WjEmsEhKt3z6w6DEZ+vYOzIMgeJgSZpUatOBC53pbhtIwBq4Ugw/hSAT61w26Qbzqlhi+8/KLhid9AVcY9j9LqSjzsevNsA/8lWIxb+OKRzb/Vciak1I0itCVxSPwvRhgimDOeZ3VD5kRfDAGc2ImLXxLkXCA28enFcW9RFQjPBecaAV6wuhCJn7EnRlxO9tmUg/8r/1448qq7w68/Agr2VwLE5n4f2Ql9X+9vvvd4arYzinuUFppEc2mv3/jlnWz+Jh/3xDioA6pZcZQxe6jK2Jl1LS5hNwq98G2dyWRxcNyqWZSEHMryISHATE69ios6lk8agI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The migrate_vma_collect() uses walk_page_range() to walk the page
table. Fortunately, migrate_vma_setup() already validates that the
entire range falls within a single VMA.

Since there is no .test_walk in migrate_vma_walk_ops and VM_PFNMAP
was filtered by migrate_vma_setup(), it's safe to replace
walk_page_range() with walk_page_range_vma() to eliminate an
unnecessary find_vma() lookup.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/migrate_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 554754eb26ff..ae39173d6a0e 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -513,7 +513,7 @@ static void migrate_vma_collect(struct migrate_vma *migrate)
 		migrate->pgmap_owner);
 	mmu_notifier_invalidate_range_start(&range);
 
-	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
+	walk_page_range_vma(migrate->vma, migrate->start, migrate->end,
 			&migrate_vma_walk_ops, migrate);
 
 	mmu_notifier_invalidate_range_end(&range);
-- 
2.27.0


