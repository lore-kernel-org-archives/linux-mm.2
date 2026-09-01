Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2731AC624D5
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D916B00C7; Tue,  1 Sep 2026 09:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6FB6B017D; Tue,  1 Sep 2026 09:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84026B00CB; Tue,  1 Sep 2026 09:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B13A6B00C7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3CD71C2015
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:38 +0000 (UTC)
X-FDA: 85165235316.03.BE7EA63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50786180016
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ISTQmw/t";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268417;
	b=qQ+8OYsZCNdSPEW51WCO2rcRe6AlozoG+0Bd3nYwOQf/Mq76Iq0ddFCZRmjB1oGoyZY6SM
	bKyXQRxLEFcKoksVMtGksyLJkFkowvAent+zUtZNQcPqMEDvek9xvUFGmE+GTahnPdtao5
	mP3e/66JH0aziy5EGrXJ4mP7D755hgA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ISTQmw/t";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLM/iGuOERBTFxu8mql/4ATf4p59p9Me6R2GTZoj17M=;
	b=b0SoFixpMHgtNGKYLWKEn3fPjnrVOcF/QVTgSgFBV37Nhfzzzqj8pk9Icxzc7m00xP/kqR
	Db4l2N0bxM3kXfX94IdskkPIHgHyfqfQdPeAGc1aRzbAJZhpkBzPIWxdJJddcLOu2c0O7y
	hnrdG6dOhbW4W97CIs6KzqnjltaiT8o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B02241A17;
	Tue,  1 Sep 2026 13:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4214C1F00ACF;
	Tue,  1 Sep 2026 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268416;
	bh=SLM/iGuOERBTFxu8mql/4ATf4p59p9Me6R2GTZoj17M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISTQmw/tUeMfyZ3j7y/xmVcZvSz9sEmicVRl4nMGFsu7JgnYWmcRD3cjGplj+RFqY
	 SzwbDlUHp6D1uLMc83RycO9ukSm8WfNVpxN5ZR4g/Qj0jolcRgchArdIZgHo4Ya+CE
	 SGbm3kkrMr47kVdPwXvEB6ZOam9MjOYIFwzvnRuXmiiTMIkCTc7yVaTOkt9Z4E3/9w
	 VAqiW4+X1sgdJZpSX4JQlmQJpbZtKrRqJtnD1QwWnBIvlOjUdPWcg/R9AYdyB3xFZ8
	 Rz0q3MXNzD7+Eh/UKSoInw/8jEwCQAHMxf5cpOD+ppNaeoVW0YqbENlWi2gqdAXmja
	 E5TLxQo48RZtA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
Date: Tue,  1 Sep 2026 06:13:21 -0700
Message-ID: <20260901131326.97615-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131326.97615-1-sj@kernel.org>
References: <20260901131326.97615-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 63ep8fq9nin5gko4uheowuxhgagtyd86
X-Rspamd-Queue-Id: 50786180016
X-Rspamd-Server: rspam06
X-HE-Tag: 1788268417-674316
X-HE-Meta: U2FsdGVkX1+Q4YX9nBke+isS2TJr0x9kpC7VMOxtwcTmvxKQyf3neL6cnXXP2zzJp/ZIRRIBu2jQb0XXcRr8LODrYqZYfmf0EUnM1LzUhC6QOi71QvW57dtFKcONwYVaKBzG28ZHdw4RUKNNkOIrbCKasURRYPhv3hrLU1destBNXt3EuS40SCgr5llmUsZtInQW9b8N6UDjfn51undaSXs0zr5hOJvmS/izW1A37rzEJ1sT3tYL7jGoMW1jg1j3Cq1XiGsDvEsEZCQSvmlNlFt7PbfLyWIKmbrDQ4UETCSdERMc7Najq+qvNv+f3qt/LlXaLlm80inwig0qo2BtVJQhb1MVeahmkdgv5mTOpblDxyNMJNKY0tFGdGkK82Qx/aLuGFneNwDJLvdW0JQaJer7NXzkSw4S39M6G+J2XT8PhN8gBri3snUBvO6qUYTvH26wvLi+uQfbYtGeNUtNTbt4IlNvB9vvC5SntaaCJ3RbCZx6YPkIDRT3cQyXQNV5lKaFVm8Iv7e5Pl4eTc6SlYasKssnvBGAz2Vm4RKvOesQj0Y3KczLtZmobXw4XEEiLqdxkc/+4EeoHvkhhILnBgDJcf9PtnWHgDwI0WTdDQy8ztDY5MrBY5xuMRP5y5f8ilf2sOAHeriqC/mJWQqzK9UuppxjYkBWuAJWNVX5MZ53Ni0VVb6AsUQOOXsdA1U9g9qC5Eje2zlFWEUE9yJitOBIiF85XBxQ56dVxwRIePRJElXOXLVair3rgEwsiBn7bJyRqg4uyyZ9E9zyf49HlTMzWI9knI8L2Kwr2Bz7HmX+jVAw04hlvbaVDy9rUS62uSdMnX7d0dEWnS9YO+zsZ3ZD9NYPQ+njSYE8RVSgO4Cuot5qczuVGfALboLSTyAgCamJEfqfmO51GawWqo4CTljtz7Vub8TzML96mHkRM/ARMBZdmMuESnRo8c5iVdAXClmaUj5wXeDWA2Zn91Q
 9Ui6+WrX
 RslZfV6Oecv4yerY3a+drGe0847PLpZYp9Y90vEZgzbA6LCbQTSfz+8mkC/II8fV4E5elx6aVxeFA4KGFxJsS5klq1Ki5HL5tdoV+6Wciy1zAhhk8sREPq9L/PrwHUvUTW7AFfU3IwJuBa97zmuPBb43ohyLvdW61BBuh/5DQzdzo9eMNy72vgSKb+Rf0DZek0A2/he1OTR/SoffN8S6go7n4oWeRbEwQjnhxdceBlAmUkXjX2WkfamQ/BiKJBkuvpvsS+hqwWiWmorBaWGu1i+UQezwoaKJky+TdX9+u3mxn0nO+RDOMlWl296szZgwGu0tf
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

