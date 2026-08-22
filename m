Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F2CC5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 06:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711FE6B0095; Sat, 22 Aug 2026 02:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA016B009B; Sat, 22 Aug 2026 02:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627166B009D; Sat, 22 Aug 2026 02:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 432846B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 02:43:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B230F160322
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:43:09 +0000 (UTC)
X-FDA: 85127963298.05.24E1DB2
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf31.hostedemail.com (Postfix) with ESMTP id B2D5D20004
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:43:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hYIe8WPm;
	spf=pass (imf31.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787380988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6eacw4YePywUKJOL7QhFxdGGTcFFbEXg3nV8IglWfIA=;
	b=KRv2odDokNRdiz4sAHU3h3giYL0T/46X8cwo6RixDdITLaN4VzRnHCvYwFNAw6pse1lQCC
	YM6TipVS7n+o2rGjxhBmedpwONLAFz2BZgYq7dgpLoYNAtOAzcVgMPxxhoy8OrHAZw4izF
	ZqUTZ0vVlLUMLiUOnmTYCh9C0rB9Gpk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hYIe8WPm;
	spf=pass (imf31.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787380988;
	b=mp4hf1834cinKbpGn6detdQbf2Q8faREkIhNYpIHjE+YXA/sOygnVygQY5EoRb7mmUo5ZS
	XB6sJ6ZzbjzrLH406GOqswXO/i5PvWmgquWXV23VwM0BvERdXJIfkOqAffBn27bs9UNuvI
	w2WbLTT8YGX+H+HEVd0kMV2t19MQdQA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6eacw4YePywUKJOL7QhFxdGGTcFFbEXg3nV8IglWfIA=;
	b=hYIe8WPmsGe8PIEm71LjWkodGMOUa9oyyhcsN2syDBuzunzkpnpzzS1RQ5wtKAkMAvHjIn5hZ
	aq0RtlP42KEZaIT8VKHjTtKGiKiIodz/0p/Ih/T3zfKozgcP3YQTkmnmtmpVcmcBdOhFZGjl+Tj
	ToKFI5d/w5hz/K+yKW1qgFI=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hRnRG1LPmz12LDV;
	Sat, 22 Aug 2026 14:32:42 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 9EDD140561;
	Sat, 22 Aug 2026 14:43:01 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemo200009.china.huawei.com
 (7.202.195.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 22 Aug
 2026 14:43:00 +0800
From: LongWei27 <longwei27@huawei.com>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>
CC: Pratyush Yadav <pratyush@kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH] kho: Convert error handling to immediate return pattern
Date: Sat, 22 Aug 2026 14:41:27 +0800
Message-ID: <20260822064127.498411-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Stat-Signature: j6ha3g6qknk7e81infwspeofji8bn33c
X-Rspamd-Queue-Id: B2D5D20004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787380986-777592
X-HE-Meta: U2FsdGVkX18o1ZOcQJ5Cw91Mq9VU4sydX6fkRE0lnkBeiR/i92d/poRm1LKASG+qvy8SYcIST54WyFoFSwZ4m1FrVriBY94/2IlwPyze6yzoAhJhmbJp/dY3fFzMnRKDLnGVc17q7prkk1xX5b9Qejp10cfOAYcObt0PDlmH6aZopKt9a8PARf1kq4TzLRhC1GI8H7UfPiB7Uz5iS3T0CENydVZVAIrDvWYG8f3NLAe5ZnFvTLR9Y5yL9+boVOkBrFJb3bFnjaMZl6R2SBmEZ7S4k1OgounDZX+JtMPdIk3WDoiBsexYW0LozuwqVmayDS4UvzNNXbO9P4GWI/A+Yo7fGG1z8tRZd/kJclCu77YY99WVftsS2r3SWXaCCwQCirg5tJaoj8KoIRMZD/YNrB55uUhzj/DxSGVhrgFRmklCdpl7qPt9ogOe2Cr/fc+PMz5RMT4Pa87Y/A4tl184AwtwF4Ck/O6dR2/iKP3mYmz35XA59VYYb9sFUzIZtByrJtZ221Q5P9XvjZ8Fu/PY7O91m1cFv7CUeWlWzp+imDIGNB6sorxdufQhahra8TSGdZgcExoLGuuF3XyZsiMqa+HVDqE/ysqJDFzs9vlZgn/uCstcyrLhvPgBh/nzZESWHBD89hiFxp1ILSjz5xSUTafvvLYMrVnuC6AVEX7vz7ib8DqhfHI89X074ml3/NEL7kZtv65JnLn6Yg2CliNjADGHknT6KWStw8gdKDByO3eUHU6rU3b2QOw+QtuDwazVYy2aPr1H78I9NgNOte6BM2lZJ9Eh51mfgfDPXnB8g2LC4T+2106ZgMlcoRVRaiaEHZVS774Fo5x3yV6jPBETXeDw0eYMY7GEkPLq/xdnVni9p5qtUYeu4jd+8OFN4Nts+daPbve0yeyaT4Rqtm9RWF6WuBo2/AK6pMxZLrw3JmotbGas7RKeWO7STyj01CV3PHGODP16bIThg55qXjv
 09aySrC2
 fwMzdjqXqKFfgsbc4ZwakbL6Qp1MbvQWWnOaEOw5oBvIxAgkGFfgNng3tzqXdbYLB5T53lWOOU4IiW3u9AdcRbyr7Z12S05gw3h0bpyrd6mp6j0DeTVvUjiBe9NLqWUOe3e/N2zHzU/X3MSFgm0LX9PT9CTLf5wqJOflqRHWDNCSt+GrpznkGjof7VlYY+LU/PUm2B9luVI6g9tQ/ph5/Gu4ReS73Fsc3YRgM5yLixpIujsKIhezNEd61W9qiORYEkjv5tCc2/iwjIjTA6Rr9a4MErXiewydUtZX2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Long Wei <longwei27@huawei.com>

Replace the chained error accumulation (err |= func()) with immediate
per-step error checking and early return in kho_out_fdt_setup().

Signed-off-by: Long Wei <longwei27@huawei.com>
---
 kernel/liveupdate/kexec_handover.c | 32 +++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 175c08a6e..93443ad84 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1438,20 +1438,34 @@ static __init int kho_out_fdt_setup(void)
 	int err;
 
 	err = fdt_create(root, PAGE_SIZE);
-	err |= fdt_finish_reservemap(root);
-	err |= fdt_begin_node(root, "");
-	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
+	if (err)
+		return err;
+	err = fdt_finish_reservemap(root);
+	if (err)
+		return err;
+	err = fdt_begin_node(root, "");
+	if (err)
+		return err;
+	err = fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
+	if (err)
+		return err;
 
 	preserved_mem_tree_pa = virt_to_phys(tree->root);
 
-	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME,
-			    &preserved_mem_tree_pa,
-			    sizeof(preserved_mem_tree_pa));
+	err = fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME,
+			   &preserved_mem_tree_pa,
+			   sizeof(preserved_mem_tree_pa));
+	if (err)
+		return err;
 
-	err |= fdt_end_node(root);
-	err |= fdt_finish(root);
+	err = fdt_end_node(root);
+	if (err)
+		return err;
+	err = fdt_finish(root);
+	if (err)
+		return err;
 
-	return err;
+	return 0;
 }
 
 static void __init kho_in_kexec_metadata(void)
-- 
2.43.0


