Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9129ACD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BFB66B00A0; Wed, 10 Jun 2026 06:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670A36B00A1; Wed, 10 Jun 2026 06:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426326B00A2; Wed, 10 Jun 2026 06:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33BF66B00A0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CFE71C2AFC
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:47 +0000 (UTC)
X-FDA: 84863632014.13.375C737
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E04714000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=spSEVkFJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdfnlijOCrbir+VZ2n7kQKRLZHQg8II97GPm1C9tmhA=;
	b=FkwIGYWATPmTsjNuU//l1IF5GFk8LQCT4ZeoCDnz13481DvOtCbHS0ilRi0BxpfS45Wh3X
	1GkITLaZzQA7JKK+D5RaB6dFgh1rRV1jlhSpGobLBEsO77KQy4x9iT1A+JgSmR3sRspRix
	nYZ9IUtGOpnJPDU48FvFMpPUweYdAIc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=spSEVkFJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087385;
	b=wLZ6P9DJC51CR0mafzsvI9RKbsLdAhk7/KmCkLYt0Fz+r9DHSai7A1DiAEZu4iVE06ejc8
	MU1FlrDWxG6lSWmSfmtFR9P9Hr7EnZK6pToVXvp7K+gQ/c2DtSV4y1DphoG08UzccoIqQI
	UC0V+TO7tOw4gF5ihLfFvntzNzoFqV8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087376; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zdfnlijOCrbir+VZ2n7kQKRLZHQg8II97GPm1C9tmhA=;
	b=spSEVkFJNbbSA0wXxQWDGpgZYN8zo1W2nNG+hiSbNvKSj3qmuz1t6pwb33/TW0Uq6qANO3sKj0cCHuZK6XcIffzZ8ck3bEhAJLaBguX9V4g5u+EgZ5biCChI1Guxuc+O3bQaezr1TdXJID/skf2+5WPvBPY1C7hHiaR01aL/4y8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aHmiG_1781087374;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aHmiG_1781087374 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:34 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 06/11] mm: khugepaged: allow khugepaged to check all shmem mTHP-sized orders
Date: Wed, 10 Jun 2026 18:29:14 +0800
Message-ID: <b4d0c1a5a49284b1f0afb0810e056f6d88b17d30.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6E04714000C
X-Stat-Signature: 7yurtwtjbts8n4iodtm7p5zftdjaqzbo
X-HE-Tag: 1781087381-833201
X-HE-Meta: U2FsdGVkX18YL8KNzaUokarjABQiql4BVpoifqhheXx8mJXQf6E8wP4mgecE7jEihPZLAn6uPGuZ5atXZPGL3ayWLngaaCv65b+dtWAduGPd8H5rY0Vwo/NXuzM6LOQbuCzZs1RYsu4F59PZVbzgi9zglSd1zdhNTQ7rmLzvHlJSfXm2snuWOG3B1fvpMfGZcy9lLv6WkxfLv5+ygRHEysbt9otJtF9ViRQGjeCbwgubpjzjcahGrikytGySJoY1o/VM51iUYBF6eo6Fx0D+m7L3ErASgbJJcHBJyGoJaWceZupJp0kztosZzC8HnjU7sMM5h2HuQSDs372qMCwXvMRANaE1C1DCsuXidIRTPZAlXa8tWp+JroyWgBAA0EwfmJQp2+LCTjhGIx2ElhQ08wHQQhvUs4zaA65bxjqhwmb+6+ih1f3QuuWmY0yzs3txAfe3MNT91kfSjrTH9OCFyDy1XR2WSky3f4622USzLKpBw6W1rUPx6uwiIWSWIyHee8Ux2PFyB/s6TO0xX++7UCnU+lHv4PPcCPgS2IL2Hv4UUUmGytx8uQohTTqu6uoq3KakHcHSiHHu5WtxIcOcJYpGrGBhDqnDewhVN1khZYJN2jf1rc4wzvyYBwnJZzi9fa/QR/Mz8DD6n2RLDFm8UPJZQBx6IvMstEaTabAJHye5xoIwjw8vqvb0iXrTPFHo+pPtdwlqpNnCDzQ1rXET9JqygesT9JUcIbXONlhFIIEO3hurplvoZy8kROhCj5f8x2/8hJk0Dm+UKK8OAOA2g2ZeTXUN6zWyj9/yngNEaeEjSPVSIfnT2K6cMUjcGVOIwjANUnnkBiFxEa6a0kzPgijr/Z2QVGvAB3n3rV0nJjR2ne7pJw4QKcZDLyGHEi8wenSZZQkF3xy/48m91WWML+WshbP1kPApwhazVa+cskVjOiRLhBWrtTd18sbKlhpGXsLAvN9UwQ2jA2NlTdr
 alNoxFbY
 PMbCtqwBgVQ1UcE5deN+JfsB2xEdwHoH/iMBDK1cuAvX+hj40exq9VT5YgTPb3lyYE2v7VJ/Aw4iJM5tZlheg4g3OHO2PxZmI/5Y/01hF0DW7KSc3C8TnjK3aWtCfbwpS8N81lX5CmAF4VlgLvPCnNBaqrYCB0R7EfOLGZ5cJoMIv/hBnOdiPBozG8STT/di+JnwPPxVpqmS+5RwhXfAwDL+RKNYL1rBsTRd/xt8urvv4XYYKEJ9odaSHQiFMf9h9JQdM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are now ready to enable shmem mTHP collapse, allowing
thp_vma_allowable_orders() to check all permissible shmem large orders.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75b18ec4a6c3..a87918b7e18c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -578,9 +578,14 @@ static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 {
 	unsigned long orders;
 
-	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
+	/*
+	 * If khugepaged is scanning an anonymous or shmem vma,
+	 * allow mTHP collapse.
+	 */
 	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
 		orders = THP_ORDERS_ALL_ANON;
+	else if ((tva_flags == TVA_KHUGEPAGED) && vma_is_shmem(vma))
+		orders = THP_ORDERS_ALL_FILE_DEFAULT;
 	else
 		orders = BIT(HPAGE_PMD_ORDER);
 
-- 
2.47.3


