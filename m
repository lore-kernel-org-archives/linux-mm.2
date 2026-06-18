Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7224DCD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DEC06B00BC; Thu, 18 Jun 2026 05:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446FE6B00BE; Thu, 18 Jun 2026 05:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271CE6B00BF; Thu, 18 Jun 2026 05:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC06D6B00BD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77E6B1406AE
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:29:01 +0000 (UTC)
X-FDA: 84892509282.16.90042E8
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf27.hostedemail.com (Postfix) with ESMTP id 349514000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:28:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WlYsvwW9;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhkI94GdMkIpy/yX3N7+ASRrvqM8cqb3UTp9VhnDa8g=;
	b=bjxNyMwETPPLBkrDy0w+qxWlXptvA+ePn1ryW93wSRDPnI+tJBRBL5LXM8Tg8nN8zbgxzh
	TN1IOPIuVV5iv8dAVNC/6keyLWi/Yaduyj0ILI6B9htvQv2tjR6WkL5sNA0htkV65yF0J7
	a0LBALoihphS9QcQ3hF5+ea4evjELzQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774939;
	b=OtJq9Ix/VrNEzbR035HBr8x9tIa8Nqy6SnD4kRpPIE1dB3WuxbGANKbCD7qixh/Zlh/n0m
	g0Pl6j8Ow+kFDR52PwAQ+VdwM0Q4G/0sGwF1hJj66PTRohaNw7r/6aPIU/AE2/hO03D3Us
	KSY9pwJchBzR+oPsoaLY6azds0f1V0U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WlYsvwW9;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OhkI94GdMkIpy/yX3N7+ASRrvqM8cqb3UTp9VhnDa8g=;
	b=WlYsvwW9HSddf7HN+cC3ScZX1DfbzE620zUpNJxzBbMO37JUXSWkQjcN4hkMa1Wy5P/H5TcfZ
	j+4qzi0/8zpqxS7GHZsqGcL381niIQgN5eGtchrU01Mn/E98qhQBrMFedon6qKwlrfdTee7flNC
	cSINqk1F4nCtbof4MHd16ag=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4ggwDM3l7Lz12LF9;
	Thu, 18 Jun 2026 17:20:03 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 04E6840561;
	Thu, 18 Jun 2026 17:28:54 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 17:28:53 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in do_mincore()
Date: Thu, 18 Jun 2026 17:28:42 +0800
Message-ID: <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 349514000B
X-Rspam-User: 
X-Stat-Signature: y4j759ruopgtoexpqnsafdydd8697zhr
X-Rspamd-Server: rspam08
X-HE-Tag: 1781774939-979897
X-HE-Meta: U2FsdGVkX18A9tPWAv795VWp+cIY4eKnyGrSfUPlcUumkU9Lt4JDlq6dphzchHrQp1YISrhqMdOXwB26EdAvhVlYMSd7siCJqz0WH4ErQ8nZeXDtsTyq1rv1YcFqe4SUA/VnY6hZNozl8x4rO+whDpAlGSgSmenbNflPaAsUE2WsM4WKSkty1tqA1OSWDDLo5xDHNAcZRJ7nEY18YQIWaHu7TQv3dpMCFs0vNr2mptIsXTqc4TOU2uVbSgvPKfIB4KwndG6ZktY/UDhZQm6JoPuPVcd8FMlCMYkq2w0uAPlu5VY2sVdcQZwEhrjyf2BmN/PqesFdnCrAoSGtXL8f4GtLJ8GSv6bnj0W29KT7bSbxnEpxVtAC82NULv5l7NOC+B4Z3V9QTPS12SlbpjFrMFt++LFMIFJNIQEBwKD6ssmRaI9rv4r+G+F5Coy7r4YXhQbjCsgy9lorT29PLmRGHM0ErOkusElonGV2eRGk9sZZUM1scl/tdEwqFgIj89M/OaRyAs827WY5gN0N6jVoS1CyRyUtidPEvSFnUrrnGDPxL55nksrmv6wsk4mcHNP8NDFba5NGCA9Y4COiwl8NAiWVkPfJiHQ40oh63LxQa8UBZ+6sULMkf9pFg/xrnx5Nj1rJP6uU3zKvxk7bzSObpPG/r023AA8GKY5HY9BYhhs+v95c657U1zqsQdGsMGUGwG/pkqQqBBZxdLaUGiDt5e6zF4JYYe0XQiUUKQ28seWblqj9lOrIPJshuz9GYZB8RT+eqcHowFkFcEKvYX0vJjG6Pt81uelObdSwv+u8g/m75Z4paGjoHIEKDLvvkopHfxq+VlnbjgqJU2nyKc/W3LKXam/0HDJhhUpw1CD8zKG9SdRmRoNH//IJMiGjZUaVLuZ1ayANVyayJOwPMhf7xxl3WqYvzwWS4f9sylSlbsIGIbVj7B6AKGmozSKpE6ylzVy4xW87FjSOilroM54
 SQYF+Bbd
 4l67Div381UUHsbOd+K9Dook2koJigU08LFs3tsBcN9HK+LM6HZGDIyDe3wXd80TzJaeWnXjE1cDyNsDBYwt9XQX+GTbGgk33BEuexap0MCmJ4yRHWPRVrrTyyB0CxgP4Ja3WknyyJEZTyL0QnWDHdSyOtGWJkNh/bFZIMhnimacLJKAvTge4yq1HTO3YpI1HKDVj8FBfc0/ZxChgu2a/GcfZ7EVuj5XuVycFpzAF8i6OwdjB9BoL0Egcvw0cTOI1V2JJS+XLwyIx31xjHQLtk9hLHJXhrqO5pcs8yCDUBKJpu3/QHykUDbpAgPn61XJn1Vty7Wvsy62d0BbrsSIe9gpZRWfDrjgiRwl88rJWVRxw9oQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The do_mincore() uses walk_page_range() to walk the page table.
Fortunately, the caller always passes start/end that falls within
a single VMA, so it's safe to use the walk_page_range_vma() in
do_mincore() to eliminate an unnecessary find_vma() lookup.

Unlike walk_page_range(), walk_page_range_vma() does not call
walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
to skip the page table walk. Without this check, PFNMAP PTEs
would be treated as present by mincore_pte_range(), changing
the returned residency status. Handle VM_PFNMAP explicitly in
do_mincore() to preserve the original behavior.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 296f2e3922b5..0c6731ae6c4d 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -259,7 +259,21 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
 		memset(vec, 1, pages);
 		return pages;
 	}
-	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
+
+	/*
+	 * walk_page_range_vma() does not call walk_page_test(), which
+	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
+	 * page table walk. Without this check, PFNMAP PTEs would be
+	 * treated as present by mincore_pte_range(), changing the returned
+	 * residency status from the historical "not resident" to "resident".
+	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
+	 */
+	if (vma->vm_flags & VM_PFNMAP) {
+		__mincore_unmapped_range(addr, end, vma, vec);
+		return (end - addr) >> PAGE_SHIFT;
+	}
+
+	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
 	if (err < 0)
 		return err;
 	return (end - addr) >> PAGE_SHIFT;
-- 
2.27.0


