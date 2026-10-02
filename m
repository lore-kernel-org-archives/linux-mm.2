Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F16CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38A26B00BC; Fri,  2 Oct 2026 05:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA2F6B00BD; Fri,  2 Oct 2026 05:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C64006B00BE; Fri,  2 Oct 2026 05:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DEF66B00BC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D5A81206E1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:14 +0000 (UTC)
X-FDA: 85277233188.26.0BD76C4
Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	by imf27.hostedemail.com (Postfix) with ESMTP id 50A9B40006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Yt3V/HcN";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.165 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIyJpw1Wh9dOciT+jL3z38Hzg3YRBSVm2MwjdHgkrQg=;
	b=o4Yze1hYYX25uFPgsm0UL5vcM2PxewzskjLMQ9E7GX2agKG1L2ekdrNviGSIr2hXodsgwm
	mmLEXbfgX5zlKWj1it9ezkRiKhy8PNGda0TkEeBtbbEFO8bViPmCyalPtecqRm9AFRjlKj
	EZ55+oFyHd53wl9rQ5LqsEDJRg5xVA8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Yt3V/HcN";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.165 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935032;
	b=FLayzG2Gwuw6MEV5jgyQdNUn/CcJL0rJJeN3Oaby+10UanlSxuKGYX6po7l9PD/6jVsIgk
	nzV1YnrprGaipgGxc3ocsz+3CiKKwjY1mljUthcxvtYxwXtQclxARTKsSvDE1vVTgMTy+m
	DkVnkECTD0QY1sBLRdxTkg0rtoVQtc0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=O3Mn4KnTxiYaTlhEiHGB+/12dl1tDr6TCxd6G0YbQtw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935031; v=1; x=1791539831;
 b=Yt3V/HcNbmcUwemCHOSvedDAbZZPykz2HBT8iGsDw6wpQkgc76n4u5oeY9f34TWwL6LIi4iy
 fTV5+hX1goo+Dp1QnOoM7lqLcccilIBDdA5zTR378xVaNZfh1qSdkVEV9XDG85Ky/IyvypGJPia
 dlZOHJ/w3+a/V50IANYe814g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 32c8d113bd9f3403;
	Fri, 02 Oct 2026 09:57:10 +0000
X-Mizu-Trace-ID: 32c8d113bd9f3403
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 21/30] mm/madvise: skip PMD swap entries for MADV_COLD and MADV_PAGEOUT
Date: Fri,  2 Oct 2026 02:52:35 -0700
Message-ID: <20261002095503.3585565-22-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: obgmeokm88ikaoukdqro4wdoq4orgw43
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 50A9B40006
X-HE-Tag: 1790935032-399687
X-HE-Meta: U2FsdGVkX19C6PWM0bbCOCm3d3dV4Ngj7TUhRzu2sNf0zCrJQjy80y6FsD7GOWE0RKVAifSYE5++PjB5yPPbKJ8HFetSUoTiTN2qa/pMI05bzxL5HLqs7feuzCeZm2dKDdQ6uqK6OGHXA7LWrBvQ94N5dI96Q3Pfq3NNRg6UzPnSLE4hnjBeZP4A+smz7IulGuCLmpwFTUWFjnQnP0JwsgpZcXQoFHW3qA3yBxKZANFuCKomg36bASgf3x/5ivmvmU7w8/lATQbP0Iws4bxPI9b2IyL59N6j1PFL/IEb/8256MEqP4JFyGjhc8nVmk8Blcw13m77JfVXTvr8s1C97QcqsBwaYBs4GLfWH5oehytEA9W+ROWOSHvpF6KPg+ab1PFAWkOjkNUFzfTN1Esgx0lWDc/Y7D+ZJ8UvtZRzH4ZaF64QuTesinYpgOEsZP8eONeDgKnyYpi5f4zdmSmme5SjYgx70cSSnxUjqJGMZRK94L07KUvQbHPYRwPkYWOnI6N+30wt8jJxfMoMdAk2zB/iHEj9xKbc0aC3gSqxJtkhg0HYWChh/FesYXSYyvHwgO848TEGAAyKXnb4OqrgD9I8P4q/EvMKYudW45Yo3Fj5LqnbaevkOq8dDC9mZAdkly0RIU5l+khVQj77DS8/jIw4qvbrNREfHH3wZO2z1uowDeZvE9wDsSJJFESUeLT93vYtglne4mDTFGF5+fVCguG5bNhZ475KG3fx/6g3dVxtc/e8bviPQNwBdJ8tNCbfagLU5x7H09cmnRKAoiIHjAqM4S7HlobfOZL0ZneP499/4rzPYIMxLJrL2XUkc4jvT8DhnMlvOp7nrazqePiEULS697NQjAAWaf6JLIuHysKMLmqq6bk994UH8z/LPo1bTMMAqsD/H2edR9E/mrAJpsnKYLl8mSOdX3a7FsW01Iufd3sE/VYAVtIZICcVxKWQub3qOHEgazxdNvsHk48
 suWfbhNF
 p+UiizqgLeAo4Z/KDuRsR7nYeyQGfuf8XfFBc7C1WGjNipONye30sGHzLnQIYpjC7B/Z4YIwM+xDhT483njNg9LC6wWhnHMd6HcJMfeaoqvapVdvIGrE50UJAmGEhE2X5yDJHRV7+lEK3Pd7S+tLSrBwDjslToLvwz27sO7vRjhRlOfjMTWofSFaOqsTqRzlxDTsa4EvwAAEYZIcIX0AXtbB3YEwwGjc/3OkZnHYSrAnqOlSfNRh6Mo8I4JS3QjicdG7Qk0zLgrLjAz/DEx7ObD5dxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A swapped-out THP has no resident folio to deactivate or reclaim, which is
also the conclusion the PTE path reaches when it walks the swap entries and
skips every one.

madvise_cold_or_pageout_pte_range() gets there the long way round:
pmd_trans_huge() is false for a PMD swap entry, so it falls out of the huge
branch and tries to map a PTE table that a non-present PMD does not have.

The entry can also appear after that first, lockless test, so re-check
under the PMD lock; otherwise a PMD that turned into a swap entry while
pmd_trans_huge_lock() was being taken trips the VM_WARN_ON_ONCE() that
expects a migration or device-private entry.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 70acb39b8b3dd..d3b5ed7e3cffb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -385,6 +385,15 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 					!can_do_file_pageout(vma);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * Swapped-out THPs have no resident folio to deactivate or reclaim.
+	 * Avoid descending into or splitting a PMD swap entry.
+	 */
+	if (pmd_is_swap_entry(*pmd)) {
+		walk->action = ACTION_CONTINUE;
+		return 0;
+	}
+
 	if (pmd_trans_huge(*pmd)) {
 		pmd_t orig_pmd;
 		unsigned long next = pmd_addr_end(addr, end);
@@ -395,6 +404,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			return 0;
 
 		orig_pmd = *pmd;
+		if (pmd_is_swap_entry(orig_pmd))
+			goto huge_unlock;
+
 		if (unlikely(!pmd_present(orig_pmd))) {
 			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 					!pmd_is_device_private_entry(orig_pmd));
-- 
2.53.0-Meta


