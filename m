Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA91C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DCD46B009D; Fri, 11 Sep 2026 07:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8959E6B00A0; Fri, 11 Sep 2026 07:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693F56B00A2; Fri, 11 Sep 2026 07:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 142AA6B00A0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E5E6160171
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:16 +0000 (UTC)
X-FDA: 85201300632.21.94065AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 812822000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vOeFyNE/";
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXsikQHFBNCGFDvJ7Vj/d6YOt7NaeTHVtPdaxATeyXE=;
	b=dSmdELSiOT7uiVpZ4Bj0J/toh+3HZzYUlb6VKFKulsO2PXUwP3+bCWJrnwdEHBEJDl2BUC
	31tUzo18IGI0l4YNeA8k07y2+vEft1VYtqM8E7OhwHJEAzMYATQaXzq4SsudruA7h4tumE
	ogqs/CICRWELJDS9BmZo5XiNb0msvjQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vOeFyNE/";
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127114;
	b=jshGs/XzGrx78kHhCXny8QLRZ29i1Ns2GTJMLiEUfAH3h9wnx+2xRwQTOwhIP45/MfCTae
	PMOSBnN0z7kTrghLEYpzdftBAoE+vtc4q8MTk04kP+zxnc5cLFY+SGtl7Tw6xKfOod2GeS
	hd8L1xAOtvCLOHVodgLr1PrsWekmti0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE76B4483B;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DFC5C2BCF5;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=DfCUe025uIKtclHTHshGr+EQA5lUG9lK0Ak1YmmZ3yI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=vOeFyNE/3umDOaMHwnBTe60c1eORoeQLfYq3cHxJ23YmqK8+9U0Muzn1hBttfepC8
	 GEH76gKvFKT8E5c400ONJ0hz6ts4cN5/4sId9CPz8aB3fyLesZEupyTuto1qkmr4a+
	 QhO3QgiJcgDmMarn04/hGOyq4FA0eru2AesyXQkk3juIfjC6KUypHc3HS387xSyta0
	 C964ATFvyLCcJ9zyAYK4WPOzrc7EqZNKubhZskLgXh3bI69+4/GzdIr8Vp4DJS8l/3
	 n27kh3pW2rOstGNo+V7b1icVPAUhjA6Fvxx6xPj5B/0ZXzVwOV2xIs+MjJ5bYrMibx
	 WcR3AGXjOdzsA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A10FC88E58;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:13 +0800
Subject: [PATCH RFC v2 10/15] mm/damon: convert to LRU refs based
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-10-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=1029;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bcXldTPRhQXaWP3mxZJ2ezjk1cc+Ox0W+LQc8aNOz8c=;
 b=do1F4divk/7w2Elskq/IjnlxGlD0GvPCpGcO1NxNx128hC5/j7AU69z6BO05EBV0r14XpdFLF
 hEo32isNyfKBA1akJ+lhRl/ob9TCe+kfwahhgsT2XTfHRCJu2kj/T8I
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: ga739g9c8hrwjdnuhozuwh9khjgw3wtx
X-Rspamd-Queue-Id: 812822000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789127114-503639
X-HE-Meta: U2FsdGVkX19LKFvLC90rQKCm9sbKCR+n44UWDe7eiFf4na0YmcBeDtxB15lanv+F7JhAj6yhR3FwoM8G2kzf5rjMeceRqsMKNutQDA6c1psSN164fEMLWIFE5efg1uHC5KylRI0eZshcid07X8kqBt7UnzHojNfC+y9bnnIuv71QHqVtZYbFB6yA081+WIG2MKumXz/fIIY4a3SDH6glvxlyxpR4VDrKOdcaPoOSJhGck76emJgy56IfPRY0kyCaAXxgqdl+ah79FcoShG4GwVftiE4alFyKcklrw4Ppg9zlEoucO9Zy0kuhqX7WxyDBvLHth/Kw9t2HOrPo8sEF9d3mLQJkZR18xpsJVtHlWHk0A4ypKjsv8ne7Ep6kZS1aB1AR1QmtLvd+Et3nhCePqbCukYVvDtbQdy+K8KH8qzrUfNm7uNT2nZ13K4uJld1W8jqSHGb9xYR2nBgFvHPD+qPaZbz35fTYZnT56u3aoRlMCWJfFNOc6qtaonhHojIdss8+oqr8icpy6+QhqAD6zWCKgS+RURoyywZDaNxHT2e3hHQy074NYI16qZwzXtWIon1PoSuv9tD2yUurUVfxy8qITivZnhBObau95lur31NsfGSQcd4qsUUTQYmuZu5Mmu4YSSyLzIXC+4Bvne3iIbSxM7fif2U9WBUwfog1XvuXBvMW92ej+XTJ4wb2EOOY/SaafHUtSK6wgWiLmyJWNbXffyIoKBjzrUGNwNrocZDlaZ6pvQnOr79Xj5cNBqC941OG9OK4USQ6q6fKhr5zWjMPvdDNpmQu2gWlwmV9Haoh4Zj4+TOkEOqzBPnVbGBYIVg6J6Z5hAQHZZUm0whQ5rfeW85UYUXEOXgsjr1svFmJnXB9/HaO4TPzavNZoJgC4Lh5Zcn+ITBVL0pYKzPp9otQkm6/z50j9vCtdhUqcTy7nSeVPY4i1P9T/E7L8uyqJzgLgbm510EDP8VfP24
 jKFi3jaY
 NCEplLNAR0JI/rlfOZQdWTxSSZE1umcStAGKM6TKX+IRkO2DPIvEJ5hYB8xqJO7n0RXqhOsLD3Kbu5fXqTtsI0F3lyFYVrnsnugK3vYJmZWn4sJRfk/4GNtPmh2naxcbVkpjeUYxproOKS6BLLJSRERKy3VMrbZu0PG4Zv1GStP2NV27SuOEZVMRv5svyrvdET1ombrNr6asSGM7I3ofmkpvqHKXF7pToWghNsdcL7ovxFPRAcN/89rs7Lq3+Ff8Mh8gxampqeJxNdtsCi9e20UpqZLwzj9fmDMMmWWTV+GgXjJ5RbrVco8OzPmnkOwQfDb8iK+GLlVkrIkZ7qAzgtsy8Obmf91eGByIcyjCaYWkacMhsYEchU6bEFpy4UTzdK0qDp3AAOyfVpwthbd2U4Tn/MfsXupt4Krfq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
may corrupts the folio's refs count in later commits. That flag is now
bit 0 of the count (LRU_REFS_FLAGS).

Reset the count instead under MGLRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/damon/paddr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 79195026b903..38d3ff7019e3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -280,7 +280,14 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		/*
+		 * DAMON only gets here for regions it measured as cold,
+		 * so the hotness can be, and better be dropped.
+		 */
+		if (lru_gen_enabled())
+			folio_set_lru_refs(folio, 0);
+		else
+			folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;

-- 
2.55.0



