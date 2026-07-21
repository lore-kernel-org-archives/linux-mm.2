Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79ABC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96036B0095; Tue, 21 Jul 2026 08:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D936B0096; Tue, 21 Jul 2026 08:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABBB6B0098; Tue, 21 Jul 2026 08:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA9C6B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:34:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C5AB140135
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:34:57 +0000 (UTC)
X-FDA: 85012728234.27.79DBAFB
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf23.hostedemail.com (Postfix) with ESMTP id 02B4F140013
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:34:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=n1X+slWl;
	spf=pass (imf23.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784637295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9KtnsxyRZEF01/CsKv9VL4GH6V2rNoA4quHnbHU4djg=;
	b=wYLlioyTtom46F8qhGTAtKMiIwGMYp/d+zvD1nFm2FeCVgN10ts/MQ40upcfoLf0Oiq+EI
	Rd341PPpQWLYGH4w+MC1vrV3aqF2ZWoFk1K/sfyVv1+ZmcWBN59pGqkWl83jB7b/5YB/sP
	uq1/S4gOmEoY5SaI3uE5sI9ZcOTD+6k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=n1X+slWl;
	spf=pass (imf23.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784637295;
	b=MSQNZ+WsLqTzsYlBd30SLlvvG3DJaYLIJob8fn3hssqft8Hi/CdceUR1VGW29R75hyM7Gg
	uUHJFCd/auosHtM+J+gKOHpnBCoBZkFUZd5gm8RJiL+WJtKiD83fe914Gw3uRXYkWo8FFU
	6SFSWQtKb9Ibro1NBgLQIA1xwnB4Ecs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9KtnsxyRZEF01/CsKv9VL4GH6V2rNoA4quHnbHU4djg=;
	b=n1X+slWlhhk0evH11mpxM4aZ/9CGHMh4mT0sZD1ksMsDzo8Lk9G9xsQrAyW1oR/Eikwdd62rY
	YyJ7eVY+UQ83gHM7Xw6EHWJibAsivs69M2fXYJ2OEnivjKoCGC9rkWUBLoXQGlKQVz27LZrWBMp
	oUxdyX7L9VKHrk7g9qkDmGY=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h4Gmq0WMYz12LDV;
	Tue, 21 Jul 2026 20:25:15 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 621A740579;
	Tue, 21 Jul 2026 20:34:49 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 21 Jul
 2026 20:34:48 +0800
From: Qi Xi <xiqi2@huawei.com>
To: <stable@vger.kernel.org>
CC: Naoya Horiguchi <naoya.horiguchi@nec.com>, Andrew Morton
	<akpm@linux-foundation.org>, Miaohe Lin <linmiaohe@huawei.com>, Sasha Levin
	<sashal@kernel.org>, Jane Chu <jane.chu@oracle.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH 6.6.y] mm/memory-failure: fix missing ->mf_stats count when hugetlb folio already poisoned
Date: Tue, 21 Jul 2026 20:19:56 +0800
Message-ID: <20260721121956.124887-1-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Queue-Id: 02B4F140013
X-Rspamd-Server: rspam01
X-Stat-Signature: 8mtzkz5p8czcx4ztis9b375g1bt56ggd
X-HE-Tag: 1784637293-24452
X-HE-Meta: U2FsdGVkX19BxH5Zj+g02GSQyjpAoYN4A0POoLaEAOAigUUYEzC6N+6rRlYqgyIkBPGzwX8gcqcg0Dly/QY9o6v5DT47oAeJSHnZivkDVe+EjdABwUlHk+6zZ4R6mRN0PAln9hZbeE/Q56ACSqvS8xDEKvQdC2B8lC0OCjBEIKxUff8xGadleGmzI3/00X0et2pTKaSSYn1DnayqPNkd6qZu4wrujP/K9+0IyVrsCnHNjpcip22cqUqK5ckBrdGXF6Db3wT/VMfiQEzy/5ZKnQBm+/o59rtiIjgF8bqe4Ux6YqBJHWc7qT7LTX/Iixvr+kasLR0N8tdLJLiLt23t+h6fvBL09J1WJ4kE6kDsnks+OrIyXI9kqguaKQURzFsE7uRh9Wjk87bDlb+LLWDQGPBr0yVFREdBy9i45iI6QZi3c9W5oe9zQPAy6gCsMNCgehGZJV6EcCb8QZT1VkOu1555K/4vN0iu1ggF6SVp6T9ZzoWSaSfzuoRDOy6dCaG7l+mnNPz+0GKfEQFDSIYX5/lkyEw4dopHD3sIwNs2S0PdLjLj5c85b8S1WzWpqrQrtukEpDFpmEdO3exgh4qnI72J94Tw9qD19I5AaP84s+9vlHcaBWR52xqRm9f6LaNaRt9Zbpmff73JjyGtxgtc0PfLeih84K+SRH0Z7xOFn7XFYWq+S1mRONQ+vh0KKbVg9gXX16Su4x4LEejIyTdAAWKAHcRnBxwxooRBCxQSiFn6SGDFyL29Ik/s5NhUUEUWfxIU6rxvS+3gJq1Hmm7GZVMaVFLuxFwkKLD0GJxUaE1uHh0U+HJsjvye9MuciE0vTdEr/sXiMdy9FmeI6kssHRzcnwMhBgHB3+XquD8VjZ8EMpHj+rccSVkvp/zM47GzF623MajNWrtq9oqdMsZB2ioESzaL2b1RkP/ADxauc/jUR5nnQedAloBPalI28dzUCiyOTeXzXLRQEBk20du
 ORJVfMAv
 /yrlBZygMA1v9SfdKat+XVfh1RNNKuanciBrvDGBY3L6gAtbWJ1pHJaniXtFnpZaQKV9LXUBVwlBbW3tUrGPqIYNDRw0zBJ0n35hqpYJGAK83nP+EhjsRfBQNKOaHrBdA7+S2TUWhhEU3oTMMnV+EwzTV6dGfGedLzIue2YWGi405H+YAB2RmAfPFiDet4wk22cG4O1GjnFk7eeKyHlfn3kVWdNfP0Rv7auFKvg1DenNxesDaEdvOsyipTtkn/b2IKL+pZ682Ivs181J9jvkkE+J7VeRXzH4drsxLjT1S2Y/fcmFt43xqM/wxRhQEmupFMJWZjDVohitxhSgSc3vFqKlo1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ Upstream commit a148a2040191b12b45b82cb29c281cb3036baf90 ]

When a new subpage is poisoned on a hugetlb folio that has already been
marked hwpoison (MF_HUGETLB_FOLIO_PRE_POISONED), hugetlb_update_hwpoison()
increments num_poisoned_pages directly, but the per-node ->mf_stats is
not updated because this path bypasses action_result().

The upstream commit fixed this by routing all counting through
action_result(), but the backport to 6.6 as commit 252bb328b36f applied
only the refactoring without the core counting fix. This patch adds the
missing update_per_node_mf_stats() call to fix the inconsistency.

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


