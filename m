Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4626C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10736B0093; Sun, 13 Sep 2026 22:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8236B0095; Sun, 13 Sep 2026 22:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B267D6B0096; Sun, 13 Sep 2026 22:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928AF6B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:12:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A301140EA0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:12:55 +0000 (UTC)
X-FDA: 85210744710.05.06FFFC0
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf29.hostedemail.com (Postfix) with ESMTP id 45B8D120006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:12:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QjQww+gx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QjQww+gx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789351973;
	b=Gl/rzJOoENHjY6TDDW+QbM0FAOeUArjGCy4veTVkmv22velRMU4dAVocHAkIbrRa1QT5pe
	3wOup++dxpzQbB0solFQDVZAzyN7NmmvyTuv2t8Que/VssQyygiRJ0h5pdxcna/ygVynHz
	gZums3/Jb8sxEK+w8QMg3rCC26MJKLM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789351973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AapbX71K+AOCTga7+D27TAlEiW7241CrDMio+nr39S0=;
	b=eJCTlJ3dG1IXdF/8W9RdUqpZYV1+S5sb0WCvfdKa8kUNt7vhwzlqWUewu7oWkM4uxKnOkd
	mfemY0v/AOmcFvhs9NFs396M6Yqe/wdLTTRMgIZfIeNYc2oMMtt9SKbYyWHBn84hAmHwxK
	MsbayxkBUmBAYu5y25cIAFYm2YDMagw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789351969; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=AapbX71K+AOCTga7+D27TAlEiW7241CrDMio+nr39S0=;
	b=QjQww+gxD2MuKINETfD3syMfOWfqUuIi1SgYFWNdxC1TK1dzrEvDyNuI9YT81xtKorwuM1gnLu8qAoXByaR29c00p66z1wALrqgDxTkNNypa2/msXn0y0zjsonnzpJKXSW2o57Q5oVNU94jkTtydZ2DbtxB4xehBMYiwTHYh7GQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XAq.rRE_1789351968;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAq.rRE_1789351968 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 10:12:49 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: shmem: ignore sysfs configs for shmem forced collapse
Date: Mon, 14 Sep 2026 10:12:41 +0800
Message-ID: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 45B8D120006
X-Stat-Signature: wchzu4f1sriioeo4tgzri56xg9xd6xdh
X-Rspamd-Server: rspam01
X-HE-Tag: 1789351971-203675
X-HE-Meta: U2FsdGVkX19ZUv1axtfEK3ZK/c7Xy7MJKFZiWosxbelkBiCxhJQj5MP1UUmqfrN5zRFokVRRVhWbTgb45w46L6rDTo6TUehTlMnhB4bcR9eEKFJNsuG/LUm76BbYlqDmLEc7zSBQ5a3o3HtJmD0LWypGgNjW1Y1zDv1V1f+TzszgX8Gvm5W33CesU2RSzptLpwy82otIe88B54qXI1y2qaJBSMl1LskNLu1D/qg9o4AUH3tgYgth4QpG2SN69Q3NBDqN8c2P0CwAfcYU3DWUqCWUXU4i/LmCX7huNX0kHn3Uo1to09mGRkm2te2Rgbpxc3bdbGfzWjv99Pgeib5HPC8+XpEBZJ8BhUAuiLLH2fCUlI+lHBCnWaa8ZVOsdngiaE8tXJsjmwpMOX1JxmN0PijJHVqMAO6J8DRsYdUkYfT3mIlnhip7HrxBO/PJKoXvzx5CF397O5HqDfEmYqq66Wp7hM0Lua3mAf0fOM1mTLTWMXCnkNj5h6wXyigNNMNXz5eIJLpwVoN+HkC7HfNzFMg224Kx9lMqLrrNjOEZ60Hyz+8NzSqQd4y54Vp4//0Oxz+UWrHU71NSlR0JtSO/OuooYg9pNXg3j8gF4IBr2C0055sByg1ysVvWUJfm0vn6UDhyxXG1Doso+1xEMYd5TTz63my0+WnPkgUccLFV5xHRe1c+FgygOOkLRyK0bDq6OdENQmJblfhkRx1zRGqsqKNwGB9GPR+WYsMDxu1Qwf1Diws3Qq+jWYgPX0oDeevSiaKb/nnXsRGy/ppv8aZZP5KZIEYKTQ0W9oK/Bd28MYL1aUDFg16M88Ic2+xdIwHjqtKh+bHGShzYeJcs0zf88npYKq/stucZLdkX4WCcB0TO4ETeYB/wvsT1agHY393bryIFyKBrRYMEFDgK3CETUhJ/hyLFPOpumcSdsm4ORuEC/df5DajSR6JncWRnmuyhMu8e6tPvmU3tkbJ+de1
 BR84eozH
 N4j3ziNFfbDnzwltTaRJc8Og/FXJfHwlCjGskWba/LU8/Rke1hJTNbWUQzvTehft5YlLUVasAoF+2ANx8B7Ekf3cHLwLvhd1pdbRp1LpepiCnaRIYE7+9zqFm7tJhYWR8MNOKq/WfTHMksQFIb7Q4zWHNLsdRWQz2HdWOAiEWKHtJqJGcou3RSXOXt7vV8UA4XFbcUeVlBk3I+TeVPhowZWAsQFf2mwJonrXg1L705NVe/FkkY6XRVaQxutd/x4TGd4yaO10sNDlmpD9DGIeh6Jot9PfdRQ6jXhxZVo4mpUr69X8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
ignore any THP or mTHP interface settings.

However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible" semantics
for mTHP with anonymous shmem"), performing MADV_COLLAPSE on shmem will
depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
(although that is the default), which can cause MADV_COLLAPSE to fail
unexpectedly.

Fix this by returning the result of shmem_huge_global_enabled() directly
when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
shmem THP/mTHP settings.

Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v1:
 - Use the correct fixes tag (per Kiryl).
 - Collect reviewed tags from Kiryl, Zi and Lance. Thanks.
---
 mm/shmem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c92ed17dbc4a..b572c60f2af8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2049,8 +2049,11 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vma, vm_flags);
-	/* Tmpfs huge pages allocation */
-	if (!vma || !vma_is_anon_shmem(vma))
+	/*
+	 * Tmpfs huge pages allocation or forced collapse ignores
+	 * sysfs configs.
+	 */
+	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
 		return global_orders;
 
 	/*
-- 
2.47.3


