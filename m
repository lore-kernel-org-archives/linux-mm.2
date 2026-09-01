Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8019AC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A436B0195; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADCD46B0199; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19DB6B0195; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6676B0194
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04800140430
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:02 +0000 (UTC)
X-FDA: 85165248966.10.20A2BED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 485674000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkOGbXHt;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLM/iGuOERBTFxu8mql/4ATf4p59p9Me6R2GTZoj17M=;
	b=OJM5nA7ocspRKXt9j8wrWORpk3DapkqHDY9Y2PipDs1Qe/O2cLsZhFZGqvA6uA00dqWFNd
	OzQcU7zbtfV8KrkKUAB5TAbgKaa6jljkVdkshhXGDYKthbA8z5F/V3Kw4Qlx4Lg2ju0LMx
	v/8CUeLOBWV3JxnBSsvjeplz5Uc87hY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268741;
	b=qdw3dI8zCEgdem2gICnd2EWJAsCqcFVEpQSkBEKICh0ggK0l20lG+CgGJ8nE0tKuue1FCY
	ul+z6Os01wc3EeELL+MEQx6Yv28MlCAQI3qUZVw1KnWWZceneoVz9sCO2EpfH3/bG77A9o
	xUe53kEkr2RrN9VnwjBJyiJJFmTb54A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkOGbXHt;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FB1A42E92;
	Tue,  1 Sep 2026 13:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205671F000E9;
	Tue,  1 Sep 2026 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268740;
	bh=SLM/iGuOERBTFxu8mql/4ATf4p59p9Me6R2GTZoj17M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkOGbXHtNIV35nOD5BO38v1EVSPQbb31jM9e4LeI3O8uWXuBhWBo26gj2J8OGjLyA
	 bfkqbYKmd4jKEKq4DT5PjTxpucmJ3jX62oeonMNLCn2iuBLx7v/zkOn4cFcNx8bnXP
	 N3eM8+zvmHvTrM+Jr9oBoI+blmqUHzNMiDt2+/Nufo4giN+U0slj6n1VyeaakH/Ocx
	 R9pMr52UT7DuImtFuJq78RdTnmyazUlmpGAUH5tnRlIGl80T863jBTjmNoVhCay7sl
	 0bZNFQAD/fVDF3jQWDuVk5+X+n5bZp8Qvh5IyVv1ANMJZT+kW4VU6Vao7kENYxmTOZ
	 f++qIJtRLtwMA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
Date: Tue,  1 Sep 2026 06:18:46 -0700
Message-ID: <20260901131850.98037-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: <20260901131850.98037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 485674000B
X-Stat-Signature: u4pja543r6c7trf3qi5hurb7rqrwry1r
X-HE-Tag: 1788268741-950669
X-HE-Meta: U2FsdGVkX18jMFLsduGHDGBJnYRjwl725JB9RYnnZS9+xdo+mSTZB5VhgIJ4xlhc6GkfLRPe38fz8jvWPxuU9vCtJVe8naef836PMWevUP2b7tk8QWMCf8XoWesa8wAdDOaA+2hA/HDnKUyWBSrty8mjM9KR+dWUV1iTh/ppWcp0tCJ5CSKuneCSJ7G/YWRXhIcxYOOpbcv4NzKUgnxBMKBdaGCzt011MvKKPjj4qbUldobfg9lu0EBJ/ejPU02JJnD49hzgPhUWMz8TPNzVJcl6Y3eQDEqg+vIavqgm+2zz86h+NP9lDw0bC3rSBD758ge+5wVArJabGJ3AnBl5M9+46RwuXwfxDI5c54WwAo3ZupDGXmNs/jE8pvDWuLb6jawpVMG2KlPrVH/7LVFtuGU79qpj6v+5cqq2xlgIHefvcNNBkidl14cAjDENsVkaMXV/h8KXnJPi72WoHQv9Ua+m1daYY6T0o/Z6imc2Rxgd12t/HQMu4R1r+iKpxv2woi4RaCm3sCzc3VIZ/QjmMJzJpxskJLmmF2zz6tQAbKiRYXu/eKd5AiStZmhJ95q5iUmKxRVRNZ3lHK05UR4zw0rXk7vlh/CZA70CsXnjRtUpS/4ruwVicYEG1kLD+6r0osg+vs0PNbk9N46PlmJoVJUTF+qOEPcoAlP4TW2kLGxTpkt74nka09fXxAQzsF/uS1Rx2djYGcVGzBXUAgLoyyZFZ4/isIUmKBCcj4Gnx3TLyQ+3XL57Rq3O4epyajn+dIbgaVJEBIpJT5o9n59UaBYqVKEcC/E7C9WXFpf2Txx7s0gufExmOlFlgfRM9jBr8KDu0DLo0fwu/ZEcfPjzyqk+/IhB7TkJ51vFWbElVN2AGY7OzmVn3bI+j+Tc0wg1kUhpW3IjQ8GDgWK2PSyh0SN9tMBiwISqhFukbUD6zzN5N2TjzevVggpmM+KhgMhiNziKDu0uNb+P1oXA41U
 KR1c9xMQ
 F3hpq04696bcI4IFCYQ5XWWuu7igZ9iWfD/R3owYEMX9C/hS+xIeA5vNY5bA9FYdkQfQOWx/NjvTjj2NoqmrK3mIDHTYkA4SOtMo8AYwOJhTASX28gpGVqcYiYuV+prwqgQBmeBqpYbZUieeiW/4Vgi6M1h8iyG9MesmjYflM+Z2lKPZO9pX+lx4q+fnG6NPWRByaTZ53EOv8OUQ/HL61tsPkPAbVyp+I74ac5g7N0CzdmeQ4t3dluTg44r8s4KMqq6ivY4QatesBRXCOvEQ81lbJfsGJGV5tiZ141sbOCniR9z7jRRCPCW4owA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For applying DAMOS_MIGRATE_{HOT,COLD} actions to a region, DAMON virtual
address space operation set (vaddr) calls walk_page_range[_vma]() for
the region.  The pmd walk entry function, namely
damon_va_migrate_pmd_entry(), collects folios of addresses of the region
in the pmd.  It starts from the walking address and advances the address
by the size of the folio of the address until it goes out of the pmd or
the region.

Let's suppose it is for the first pmd of the region, and the region
start address is in the middle of a large folio.  Also, the next folios
are small.  Then, some of the next folios could be skipped.  Fix the
issue by advancing the address to exactly the start address of the next
folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org

Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4b0b5edf67952..c8c32b2ae0402 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -669,6 +669,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -681,7 +683,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
-- 
2.47.3

