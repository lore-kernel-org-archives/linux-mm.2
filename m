Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC84CCD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76356B009D; Thu, 18 Jun 2026 04:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFFD56B009E; Thu, 18 Jun 2026 04:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16516B009F; Thu, 18 Jun 2026 04:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 785E06B009D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:19:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48CBB1406B7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:04:27 +0000 (UTC)
X-FDA: 84892296174.06.B96F12D
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6876F14000A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:04:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XzwVjjxv;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781769865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Oqe7CBCb4Ikmvh/siKVm6fDHcOfUAf8M4rR3KB55Zy4=;
	b=m5JMc+/+7uK/GFQq+QS7OogHNDaZ7IIf4veD92QswwHxy3y0aVm7yHtUXSy0TRfT1+gaJk
	zhnjPSX/dvZLgL6qwIkAszz57VmesAufZGhHhjjPy+cG7JxdFI1vAevQvNJZc2ICrdGn8G
	2VmpOMUiZRo/h37oj19HP4Flc9GAPPs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XzwVjjxv;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781769865;
	b=yq0ToZmUsOaBhxSdNeJyIGoYTqSWjheb11bSSozygYUICr4VYKTvUX8gHDxW8xDiANXgF/
	L2YTbwisH+nK0mid0NBIUpcejHJ42XYmlyjr2JBUEc8h4wq/cNpgv5UjAoRJI/6b6OikW8
	6ChpTxesVernzTpoqoVzu/vLjKMAtIs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Oqe7CBCb4Ikmvh/siKVm6fDHcOfUAf8M4rR3KB55Zy4=;
	b=XzwVjjxvSbRBnHrXAzmUSa0wlEFrCPDZFkdK0ImGch4fpMPjL6KhTJN89BnE4ORSko1SEXTCF
	CYcleyvg0moPihWxcuyAc+xX/p6fX0Qn/efMn0I0qw75Lupn2m0fiZx/adZD7Q77IiIeYjw+va3
	qxHAJlnC4MrdnBUw1Ubb9p0=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4ggtMj4G3DzmVC8;
	Thu, 18 Jun 2026 15:56:17 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E8A964055B;
	Thu, 18 Jun 2026 16:04:17 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 16:04:17 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, Xu Xin
	<xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH] mm: remove PageTransCompound()
Date: Thu, 18 Jun 2026 16:04:11 +0800
Message-ID: <20260618080411.3902214-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 6876F14000A
X-Rspam-User: 
X-Stat-Signature: ro7uzeds5dhbnmx3bztpccsrco91y817
X-Rspamd-Server: rspam09
X-HE-Tag: 1781769864-810213
X-HE-Meta: U2FsdGVkX19Ysdh9poSmZiYHgJfAOE4KZaLH7VJ/OV7Gk+NZYUy4/4uWXL5Dq6j4AJaeYYg808b/2EX9X791CzqBx/E88mpKb07AQzIU2zNEYaa7d/187fdruulb7Igu/poJ4SnhKPOEPVuwqhkwPDfmQC19Kzd0RX8aKEo2o7fCW71jzT6MjS1Bs8kzvgcsm2/aIdET+yjJzWhnMBlFbLEoSWFNtkoyTsG4ZAsTyDC8hPPl2mZmG8PWbZDaOrNpUs+8/S+IoKeUFM6z8LN8iMPxhjBP+Pu6eT7gK4/yPvbNFTwU1Q5maRoBDA1J9zO3P10xG0pUr9KDUFekcbRoxhMqX/2B/e6M/FZvNgqgq5MGds7WGExOFzD1qbM1dBGqudKFp5nvpHAliHNdY9Plrb6iOk8F975ccOv2+rES9JuVQVofni+g6ak3WM++Nfj/Ohf/CJLtmbzcaMNWq4UeiSmNlcvMsFwvuB6nH6P+SdEBQi7c3CjGezToe5eGB6iHLvW4RkDSuDCAK3qtkaE8iPITvsW5D9hJ7p68qPi/HrOkxuyZWdm7/QWuvlv81uYXJRD4aGOJX8yKOFGJcHJKT7cVq1en/YLBCYiN3gbkcCO9YVaiT1sTuX10v6mjMwHI/EGabf98ZbmEwxetsXuiJDXMW5piFZ8UWhODP/ehSzCjRf8yhwUsDZ4EMtq3Yg0K1KgJ0dNn0jPSDU7MKkGqTgjoS4qCrnWbPO8vgWKtMBUcz6fTC/9hP65xFvf6sLKAa8M6bwOLZfNwM7k6NMkUxrgcHzAvpbqgTOQ0L9W0cxdgC+GsqpmdN0luf+rxj95mcB5YcNVCm09JtXXo/RguQ+ZqzvW20veX321v5xhVIAwUKzI5+W19PEhubmZyCdqVYtfxTKmSWQZXvkY98oOxT7Nm584AaNNhQs31MmIXEC9t0HS59L5/BxocrC7cZCO0SStxBkGIQfbAHgbENrJ
 YQbT2tGA
 vUZnJz2esu+xoVc8RFf/vRfMAXsEFUTxI460QkqsrFfz+ryOWyJxXxRGwFNoQ62e/GdRy07+KNR1wNsdGHZbaWI8R43KygPxYKSfmoil6BTf7mR2YJNSiNmA5MbRP2gxbph28C43W5KdNl2c3zqktfmJJJWFexEO0ItPd2wigOoHbkQHficHD4Ecsfv/cD8UxOadtUat+xB/Aun9tdLs8klXosO70aDSw/KaKbNlO9Hm6VjOL/XNciQm86UUSqJSauE6rzqEV7yOvIOUTqdmogVGAxY0sLSlMfyPLrhJaiYowp8wTR8X04eKz867H105PjDDrRuWME/Xkvpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the last user of PageTransCompound() by PageCompound in ksm,
and get rid of PageTransCompound().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/page-flags.h | 14 --------------
 mm/ksm.c                   |  2 +-
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..7a863572adce 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -879,20 +879,6 @@ FOLIO_FLAG_FALSE(partially_mapped)
 
 #define PG_head_mask ((1UL << PG_head))
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/*
- * PageTransCompound returns true for both transparent huge pages
- * and hugetlbfs pages, so it should only be called when it's known
- * that hugetlbfs pages aren't involved.
- */
-static inline int PageTransCompound(const struct page *page)
-{
-	return PageCompound(page);
-}
-#else
-TESTPAGEFLAG_FALSE(TransCompound, transcompound)
-#endif
-
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..75db9ecebdc9 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2341,7 +2341,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 		 * afterwards, the reference count will be correct and
 		 * split_huge_page should succeed.
 		 */
-		split = PageTransCompound(page)
+		split = PageCompound(page)
 			&& compound_head(page) == compound_head(tree_page);
 		put_page(tree_page);
 		if (kfolio) {
-- 
2.27.0


