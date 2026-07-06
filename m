Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3792C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D5F6B0112; Mon,  6 Jul 2026 04:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E426B011F; Mon,  6 Jul 2026 04:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC536B0121; Mon,  6 Jul 2026 04:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 060D56B0112
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:56:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 701F48D479
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:56:05 +0000 (UTC)
X-FDA: 84957744690.19.3622B02
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf03.hostedemail.com (Postfix) with ESMTP id C3EA020007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:56:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="zRCTH/CS";
	spf=pass (imf03.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783328163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X2nPCRNNSh3ZipcyRGsxu95f/swOavphUSmg+jWuubo=;
	b=PbZTPjBajRZgV1ZmSm3oN6iiuR0xZTxlTj+cqXMvS/O6ySgEqMR/Q2Ab0Yap994PMPcz13
	GnDuewgGMfmCVjAEJ1t1BODRcCi/jYA89VJwsJThVYJdcEaOV6p/lsSg0wtBpAb9jHQK7q
	5XWYLwUiDJeNCM7N6UVdPVSyyzKnTy8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783328163;
	b=y41dTDwHuYU3UIN9YzqxWAHthZdIOFVkP89BA4gTet86zwnbajVoWbEZ0C3vxvmf7VOVAp
	d9+/MU/TGzqmNHTm8SGPTBjPujrDw9w37jhuwwJyZtbGyhJkvertHUoD/Cz3DsB58unAGH
	YzlX0le3bs5vPD5JCMwAB9w3FWyj7aA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="zRCTH/CS";
	spf=pass (imf03.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=X2nPCRNNSh3ZipcyRGsxu95f/swOavphUSmg+jWuubo=;
	b=zRCTH/CSXlHBfmFgAvtvsLLee1l1ShxSlAcjEdrJkwwD8/Pt3mBMotBI/GYL7uYhENJGKK87T
	xWuuR4Au+G4SqRJU9aTrPbVlzeSv+gS3cf4RoMD/RC7z8jliX67vP5GMnC6q+E+FfGz+ORr/J0Y
	hzbfFZi+PpMXKbbGCpRtZDM=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gtydq3tM8z1T4gY;
	Mon,  6 Jul 2026 16:46:55 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C1FD203B8;
	Mon,  6 Jul 2026 16:55:53 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 6 Jul
 2026 16:55:52 +0800
From: Qi Xi <xiqi2@huawei.com>
To: Naoya Horiguchi <naoya.horiguchi@nec.com>, Andrew Morton
	<akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Miaohe Lin <linmiaohe@huawei.com>, Jane Chu <jane.chu@oracle.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<sunnanyong@huawei.com>, <wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH stable/linux-6.6.y] mm/memory-failure: fix missing ->mf_stats count when hugetlb folio already poisoned
Date: Mon, 6 Jul 2026 16:41:18 +0800
Message-ID: <20260706084118.1284271-1-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C3EA020007
X-Stat-Signature: qfhakgqg3beaqk8bog8csm3ug9mk4hpu
X-HE-Tag: 1783328161-186539
X-HE-Meta: U2FsdGVkX19rE2WhgDxd0NN4U7IfFOlyz7WLmp0QujL5S+old+AHGQxZe9Uiyg8b4ypXk4Wd+IdHdJ9kSbkO6QgV8/6u8tslv8Dd8Y6RYrxs/L2zlGlqWAJpSVZx28ZccXGUTiIix1HNuRGgC3Hwurv26yuxXZ++PE1T6ZYVOmeWjglpUw+EF0Vfx8gmjC9oLUfm11AtFyNqMF3YYy1bfTEPBVumTS4QBPMhCYuJdntpSoCtHPhVWoq/x8lBxHq2W31mZUhB4GFzhAgk6Q4FmZMbC8TE+yj4g384s75uyeY2NbPlpkuaN8xc6DLi8X9RMbz8zB90Pdi6L1D5lBDgtkMOEwvWTRH3HtPzqgXaEcpqXN+v1EVmQKsZ/95uzgMqBHE34JahLSg4O+U+ApY0eu2jWrL5SORLPEW8EkCfMPzRydJj1u8IkguET2ryqm6jXUTLSdRb5pnNT1FdmfKjCYpjVCne5LIoLUgaMOPWzwuB8w9A5QSf4TCxkthegkCYuT/CP8LngWHWK6k8eecIVM0Q/paxyelvaQ9x25Bo1uZBSXnWgo+spIE0uvsjY5vHf6T64vnPXXFRP29LuEx30H9mmjn+ltwGKTRo0ptaMmWDUjXYTM1RAAPDIsR9jQHX/Ok+baX1sBy43vbyfZcKq3SGOn8hYReDCA13tfN7qpY+SyMslZVXBs2sXHvrGqCKdQns3DhpbwNAaBf4y/EuD11mATI26fOCrt4sPl68vzBymj79JxfYfA2AK2pPW62f1xyEydzkn9tFCIV3m6iPPSem3Q7pMQNoRkx9Q5n04FfAFfS8gaRB9Zs33D7f/FW2mqgKhPCEHlhQvnGWAPCH7A4pPqH0AqG3J6IvWE9bYModPKwWlV1EKB45qBkdgweu9n/c0rU4rJQYcG25y44Ymo8flo2uDsXmCkPXOlYND7uPjF5tSLVNxSCgfMUPZbZe2DN8zAnKO1BwOW4CsVZ
 VoqRR1wT
 5w8brP1lWX9qK3X+GM5Ys8KAndk6byMW3PT39+CbS7Af5avUD8vYDJCdzh7nJOt8nGeQ8iII2uL22qzwVkCquI8i92va5GzzFGRbqd5/cb0GQmMzqGb5Wq9AEyWyyRm0ZCCGxBnNfGrllwGAcZzpKqYTQP40M1zg+1lkIdqqmZh1spLsj5iCf2xtfEImUQYCJOAr2IMbR0leUnbeRmOMr3TOWbQ8g/GE+f7hqIILHoh7BT6cywkdaseeUULSudEsl3Owm2Wd7OvKcHNLVEqXSiuBm6vXnl6J0fIRnDdlQHYFRuar44mR4+aIZhRar7d7v2YK0BVBZOGNllNs+HrA3Wxul7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a new subpage is poisoned on a hugetlb folio that has already been
marked hwpoison (MF_HUGETLB_FOLIO_PRE_POISONED), hugetlb_update_hwpoison()
increments num_poisoned_pages directly, but the per-node ->mf_stats is
not updated because this path bypasses action_result(). This leaves the
two accounting counters inconsistent within the hardware memory-failure
path: a new poison event is counted in num_poisoned_pages but not reflected
in the per-node mf_stats.

In mainline, commit a148a2040191 ("mm/memory-failure: fix missing
->mf_stats count in hugetlb poison") fixed this by removing the direct
num_poisoned_pages_inc() from the helper and adding action_result() calls
in try_memory_failure_hugetlb() for the already-poisoned cases. The
backport to linux-6.6.y as commit 252bb328b36f ("mm/memory-failure: fix
missing ->mf_stats count in hugetlb poison") applied the refactoring
(naming, constants, switch-case) but omitted the core counting fix,
leaving the inconsistency in place.

Fix this by adding a matching update_per_node_mf_stats() call alongside
the existing num_poisoned_pages_inc() in the same block, so both counters
stay consistent without restructuring the error path.

Fixes: 252bb328b36f ("mm/memory-failure: fix missing ->mf_stats count in hugetlb poison")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 mm/memory-failure.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 86cdf36ee3bb..5f9203bf8ec1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1947,8 +1947,10 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 		raw_hwp->page = page;
 		llist_add(&raw_hwp->node, head);
 		/* the first error event will be counted in action_result(). */
-		if (ret)
+		if (ret) {
 			num_poisoned_pages_inc(page_to_pfn(page));
+			update_per_node_mf_stats(page_to_pfn(page), MF_FAILED);
+		}
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
-- 
2.33.0


