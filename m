Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 669D4CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2EE38E0016; Thu, 23 Oct 2025 07:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF1A8E0019; Thu, 23 Oct 2025 07:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA64A8E000D; Thu, 23 Oct 2025 07:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83BD08E0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:42:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23F1F140A85
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:36 +0000 (UTC)
X-FDA: 84029191512.28.28ED331
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94AF5140005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761219754; a=rsa-sha256;
	cv=none;
	b=AlNxJeS5bwLYmiKrAq1jLVfJucvwcSUu2i+5HJGPxkmTfLjUaYxAmAGnmIaoWcFvJFOdVm
	bmCAxdCkhg2Qb2ic53MUcqptynNqIX7Jyz3hqYEvyD++YW4FcaQeK/RWTeTvqs2huOwjN/
	bfRWEmmmv8Eei+F9qpJPWepZHWDAhX4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761219754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9A2nU4Q9CfFKJy1F+ZruVLZviyBvQeA/zb4zBF556iU=;
	b=YZY8FUKIO5sI+09aDiU5vT6wiYhksm96M/omyQZuasOzwKyWTu4v/ikV4Ch+SLUy7hXUsR
	FcwFi5OxUSzeTxWmzOrVLUHIp3IhdQkzRJIfvZxeDzMsFNknwNEpdHjycDjP6yfsT0uedD
	zBhVa4jQtK5a+s1FbF72p7Qj2M01fDo=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cskY65YtpzRkKc;
	Thu, 23 Oct 2025 19:37:46 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id AC327180B63;
	Thu, 23 Oct 2025 19:42:29 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:42:28 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v5 1/4] mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Thu, 23 Oct 2025 19:37:34 +0800
Message-ID: <20251023113737.3572790-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
References: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 94AF5140005
X-Stat-Signature: iiy6w3zqijn53wfqpgd7an9no9kkn48h
X-HE-Tag: 1761219753-630976
X-HE-Meta: U2FsdGVkX19PPwUVd80ZPJGG/oagb8R0Rd19TmME0f/AuYQ3mzPrvE+bz60RM9lgtJM1sa4CMxN3HJQNu9SaDW8qjvzKHx1PbnSXTq6wt1VJaSIEu4onGmn1CzXRbFptfl0NaoClnO/CTi1hptmnDCUlTc4FqBi3vexYSphYjsy+/aE9H8UXOrb8yE7lqFn0rOkI9RYL82WCE7hD3X9gC2w7C5FWGJkLMNGvxk+qAw416dVIjWX6YNvgX7n64WKFcUaGGQ/4Qd8H8h49XGWKvC3+5ar2b8gfbaueB2h0Ob2tYRQmCjqJNCG6Rk23977Z6DzLtuyM1kteTIF9Rnu67Jl25G204IoD/dWmv8sj0zCz6hy7PKgNyqgca0aH3kwVPYOTj25pRAb6U0DI21Xe9Ki+qKlZkZ1LrZxi7pgiWj5w9XbLIzTEY3VchdW0BmbXMoFMytsslOuLuDJKyYyPoVwYM5ol4D9ZL8OZXkqzilIrBGfJf/v6ZFYUXaXUECVa70Zi5qTHtHG2tX9yVYIh/aCSSwFMkhKLCHcVa37JMA9ZXManC2wdqFE2pHXXOMwZNbtGIyNtiNnzItIzGEbAteQzhxyHT+YefUOLd4unAVvvlc1qK4r20Y3Gju6BoWGcsHv1E4yv+yAX0q46RQa/qR173i3EzUYJH2Ij4pCogti0ZqCqW3aAQabpxrnRKXljHIj+WWRA5vcNXO87VEjs7led3xMw7BXVVK70wrO9jCeCb2EQvEszD3opZNNCPB90LGp38Y9BrOggZC0PTbFaSFgRunOsT5UWrshX7mPUNiWmDjbtd+gOjEd5TpM4WSrIxI7Bp2/HW0hs/OvnG9mUrKHUlmKZSWqFiKXENdw0B4EUlcMe/NMrBI73KyqsQcooC5SVpxrcX/+9QhAHdJtob2dXi8Ahvp519Nh54tDFSqVKogtychH03OPWYvvMT2m178/79tIsA94DotQYLNf
 UZ1eMZOH
 QkqogxiHHsBUnVUz/aSZhLv2XZXxzydRwayN7AEAMPwKE4x8JEhBb1fvdUY48VWF8ZufXM/GWxMpFlVTOQBj31dwx+tr2bRKFX76FrZoxBzxUTcUg+V+KrlvOypMHXfqcbraiGLINwDfPbwVYUCYXGnyA/UFlOoJ0DvTe2GQMdbPOaFhknG7m/f7bAVM+aHARBKMeBGw6vjpEIHvt/jHGBJzvBVTzxhAEwELWHCO9LL6XkIXYvgLiMYioDL+ksAFoAmK9uBn9txZtl4Vbfxq3WUodWjcWbIZ7AyH2UlKbJ216m63LlZ558lD1PZl1kp6SNJKQEBT5EZQtoysVzrx66quuDxDOG4WRicmy2q2Y7CKC0NqpS7Jyy/g/Z5fOZrGiobAE9tKkSCFZ/rI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the folio (even not CoW folio) is dma pinned, it can't be migrated
due to the elevated reference count. So always skip a pinned folio
to avoid wasting cycles when folios are migrated.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 988c366137d5..056986d9076a 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
 		goto skip;
 
-	/* Also skip shared copy-on-write pages */
-	if (is_cow_mapping(vma->vm_flags) &&
-	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		goto skip;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
 		goto skip;
 
 	/*
-- 
2.27.0


