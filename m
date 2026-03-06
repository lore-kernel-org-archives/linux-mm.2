Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52701F01825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2E46B0089; Fri,  6 Mar 2026 05:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35DF6B008A; Fri,  6 Mar 2026 05:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42276B008C; Fri,  6 Mar 2026 05:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 929B06B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:44:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DD651B80A7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:44:33 +0000 (UTC)
X-FDA: 84515304426.06.F33A353
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 934681C0004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:44:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c+UJ2XDd;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772793871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OPkOlmZaIM4hn1GJiU7CIu0V9mRULm8+LVW3w/1ow4U=;
	b=GMb6MjVPu8kX0olMn5v0DTujXc6HPTv5x+yvlmG5yOcLWo6GzmXa7URSmYSiKCszO5H3JV
	yeroI0+iinMbomCFh7mI5UTqIOGY1OU3DkO8Cr1y6Za8h9F34h2TfSlg7wQtfDV/u3GGLq
	gc8pm0hsaZbwXu5F4tPUkCow37Yr86w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772793871; a=rsa-sha256;
	cv=none;
	b=oFEBLcWpY69UXz/uFmFqp8qKpT+iQeBuHyrx88JVP6vUijvIf737OzmA/M+N+KTxPCnI5g
	2MAvJUFjkI2WUGfoe6owGM8GEhNp3x4qoYtRgGCLyil0pKLvGatJr4fgmgqfhF2ekjc5t4
	ctYtgnOb9gvRrjn9ZM0R1aAMC+UMNeY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c+UJ2XDd;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772793867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OPkOlmZaIM4hn1GJiU7CIu0V9mRULm8+LVW3w/1ow4U=;
	b=c+UJ2XDdi4k+VS0R8giqACqN1oD/vn6D1u0lCqF7odDR/jh8q8v2m75CwemTGM4Uzqb7p9
	n0kRFzf38ovvKPs3/XByos86icCRt1D5t4pumXN8u5r9A568CEEjXOYutLEDg//TsUH9dL
	ntHmSX5D5o9PuLDqwUMFm4zuPvaDm6I=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	mpenttil@redhat.com,
	balbirs@nvidia.com
Cc: matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] mm/migrate_device: document folio_get requirement before frozen PMD split
Date: Fri,  6 Mar 2026 02:44:09 -0800
Message-ID: <20260306104409.3915811-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 934681C0004
X-Stat-Signature: j7176cru384jigxd3hsft6xfqcj53idh
X-HE-Tag: 1772793869-249348
X-HE-Meta: U2FsdGVkX19jkgxd2AVjb67Gt2m0pQWAHfiPvIKYos9QQ4vAhvi+kmrEZeYTm93h26jA9ren2eQyiT6AmyRa9bg2HSZXu/GvBSHAMDlegW6f+P3+XYJ37fLNkm3AsSUU54V3UP2E9K2l6Kra8K+eFb0RQYXmQVRtzTtqDy84w4d7IshIdeMTpKb/tR9bFQiaHOudUPChzi2b59VJmuzkohkA7OcCo756kV8eOGCsZEC/H79B5weavrH1j5PqOkeDvCnuAM8LvkYRFH7sWHrkPzIbBVyxBeVAeKeXwkNDk8yjMvISHi2PNS7QFyb/Hxm5DSN6JU6Waqgum66wj+DiHfi1+qO4ny+YmX6Ja73CIatmgjTiyr6Dar7QPiVuIbREAiDxoDIyc8rb4jWwOdb1HLMUOW34uDvKNsSdlMS2XwA74/6g3E6oThWV++JBSAPjxDr5dn6kFbDaX6vUMonHyo0h541BsGwenYP2gdRJ4dcJ3lx3/QTa1czT7ydNlC8q7RKgQCyS49Hpr59yykBOvhzhZEo89AQH+lWnIioMhKiVyNCNO3IlifoYEGJaugkhxobX4X4qO1mBtSE38bT61/aVVHbV2Xsiculn8SaBnHCPzdQ+z0VDn/Wd3pZvvPM4z4WXtc8pcUrwQOKxj+K4UzSd4BV3gltWystkH4GUGhs1Rzpvl26XQZjRn3M3OshzavF3kwmzo8UGuhaKPRVOeKawcWz1wgu1duy3SYEik+bF3aaO/4lUj48+QfDlnAZw9inqeKgdA/noyqvCLAqsP9+afN+msQ2w6w2Sjy0NjhWs0HINCvI/HptMrEqWZdMYOZQ5Mv7UU0VDoQYrhB/L9Z7WlcVwRWpBU3JTJgBZ/nD4whLXJCzCjIddrY8zl8RQlpy7DT65yBQepGQMwttDd8Z20YwCF4U1gUMN3Qm1t7fWeJd3wkg139yX/V7XkoupJZqJHIHqkx4F7e32YUU
 UeVno6Qa
 1CxXWykjltZEhFYD7KQli11eV1IzSi6B6RCqjt4vBJimEYAxVKXGRpjcr6Noa1l31dEw2BoAbe6Ek7rAa2d8IWdm7sQbdhqRXY1ALiOSvHlsgx00ARs8qYpzzL0DRvG1eadJ3vBL3Y9erQSaXnctsvgTweWT1enaKUpu3cyEuHhLlrIAqetzDYaywrVVBEEZvSG/x+4tqoPGoeCjOEUUCqzlywpkiEjDr4qXFBvs+cqfoKyOkd7TuZQiAV0nwhtZsl7dCsuDYRt2IYnaqHAoqxf8ffKxqHuFAcDStc0i2NwASyXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

split_huge_pmd_address() with freeze=true splits a PMD migration entry
into PTE migration entries, consuming one folio reference in the
process.  The folio_get() before it provides this reference.

Add a comment explaining this relationship and a VM_WARN_ON_ONCE to
catch an unexpected refcount != 1 entry state.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 78c7acf024615..6fa2878848a7e 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -908,6 +908,11 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	unsigned long flags;
 	int ret = 0;
 
+	VM_WARN_ON_ONCE(folio_ref_count(folio) != 1);
+	/*
+	 * take a reference, since split_huge_pmd_address() with freeze = true
+	 * drops a reference at the end.
+	 */
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
 	ret = folio_split_unmapped(folio, 0);
-- 
2.47.3


