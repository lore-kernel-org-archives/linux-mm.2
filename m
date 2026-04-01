Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0898D35171
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3B36B0092; Wed,  1 Apr 2026 06:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7548E6B0093; Wed,  1 Apr 2026 06:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6431A6B0095; Wed,  1 Apr 2026 06:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6866B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:16:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 102545ABB0
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:55 +0000 (UTC)
X-FDA: 84609583590.29.AB55C7B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 56A128000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cjkIcEY8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775038613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1N1EDAwW078TTwyC0jBNvcnmAoNhkJLYv10OE8ywTA=;
	b=bJlaSIRIgoNLwR3wybNgKkRc8h6aLD6wFbR5olZyu3yngGg8VZ5sOUbMyUNGf3Vas0kwSm
	Zr34MfLK0TLPGacdi/qwLotcCoBzG5uJ4ZZSp/jnLE8ow64XpTwdTi/rdekupDlHZIlU54
	ygo78JasNTXYh7yNrSpMIGJv7FbA5nU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775038613; a=rsa-sha256;
	cv=none;
	b=pU9WmZMltTLW7GYJh/pQbZvPQVvImEbCt4ynvfRFYbccDxRz79wHKw40nfyjWZO+EQR2Jn
	HeS1PBpw9gOw2t40YaWmGsBj3xnklBxlj1uSpfAeqCvc6w30VSNlbS4Q1B7apXCZJJKqJ/
	aG5s5SmazwJyf38cIkys2StCzU7bJtU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cjkIcEY8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 717A1288E;
	Wed,  1 Apr 2026 03:16:46 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C58B53F915;
	Wed,  1 Apr 2026 03:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775038612; bh=JcWyvthdavWgIpUnVyB9xCucQ0sGFiNAMiRuaQriu5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjkIcEY80aU0nc9DrAtDlvemrJtisTQdhIxgWMFO1i/GPAqlMUVVF7+CKMUF6t6TW
	 v99mrEtPzOzw1dH45iLxm/mLfjCJ4BX5IMVlQ9xHGpkyVSThL1T9NToQP08WzmdhV9
	 0l61JB0mohQn7lUlkZYLNkyrCjRsyn9bQ430Y2sU=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v6 3/3] mm/page_alloc: Optimize __free_contig_frozen_range()
Date: Wed,  1 Apr 2026 11:16:21 +0100
Message-ID: <20260401101634.2868165-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401101634.2868165-1-usama.anjum@arm.com>
References: <20260401101634.2868165-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 56A128000B
X-Stat-Signature: ikhc5hoisempm7zrbdxudcsrru5mtsb3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775038613-788998
X-HE-Meta: U2FsdGVkX1/bRAdQsRi0y42pLDppd86LhDfTRg2eRiG00WLvNZ+Ci2XA9YrUNEe9rmDPDbe5/e6JgI/SLo2m7lsoHTzpk4c8169DuMbg4/iHIq7q38l0n/tl3A1QQ83IXKyNt3JSOY3zTZ4OZOU3y3gJrYkyk7tLgwD00RnXubF1VskDBTcBbkuC5uwCCnxp19gC5oGaCAbJVkSRnIgIAh+fGUy+6hOHQ+1jCFUcvrAYvPgU6hUHarKa6g6GtsZ5l1PiLUImo0dANjDQVLxb1MhySUS5QZtUqybQYMkKkMzzsrgdmYHgmXDWpOL+1NFUR3w0e5FcMAkoHLamD32kEAI9RhHdu/Ija9u7bbFUqmu3VTmFzLEtAeD6Hqp+aLJboLyjrJWQC5QdYfE0eYU7ehgz3btCuS4z3foGQPf0Js0WfEWE0XgoQIAHpSqXF+wPSBNlD59IRJMqXrMi7kwwqg+GIroFbyKiNsiOyEoLsj1bDnQS8Zm8UARk2cpt3c5bA7ugMI1dH79ZzSmiS6HNw6xrnr67r29auZIN3brcYolkbx3FYkXo/mAENCv8P3pPqbzeTGX2aUV1+y9Rhyrfq/aZG6791HWOaXF+DnTcj75FWRBcWxgrd+pFJTA2FvPzSi+7/2dXmDoMJJEhvOnOj7od8hNB1GnJ72Da2V5HfKrN+kMaaGkH4EqI+aku9jQP8grgUh87mRjRXMJ28Zd+NGhhtOZ/W199+iBmYDR6sAhlU3axjvRjJtNPyeFEqT7TXFMesF5Nj+AxNf2op0eCFRiaUfH8y2U4xBgzv0br8CD2QTl8LgpGmvA6HRiZBXbUc5Kp2s64V5PTAJKQvEAai87WjjE4/b55EnMQ79Wu/oIkwXCTcy/UpGvbh52HvxVQWqmnbfdLDkp59q9GflCsCuHbe4C/Wj2v5CQDCGAmBE9C7EYPKIlQLVswoQxPZOttSbfiCsRxbc0Vm9zRQCl
 /DN5bBSe
 tvXT0me74lhNdMzB0fpvwjjAtly8mb3HZ6VdjXSwhYOWCor9dTsmlVz1e0J8jMj2HxmDpinSom93E2wRQKtj0Dt9emsVjj6PqB8+38enFF7opczPsKXLlLs1yY0JEkfMo9sIWUx5WYcs5U/ytSmjG3CJ3clSurbPaKHYA+zjKslNyAAEi2YRcMAMk2PKhex/e5oRwrt4eXJq6G9MLX5LOzTvV6UZzpVZW1wUetCg7HJ5ofEkFDzpPfThe13XhINeeV9doMglUdbcKmxZqKDqywA2UwCviRUbDQrinxzyzrB+6vCA3+wj10wcYhqy5b5mhSd4GAvFhGSGEULqm7GsSGXui7hyGE1kAjVa/9c3hyDHqvjleKJ2G5ul/hP1rfRwajAfNnwtIyWCMQJQQUISG2aOMRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply the same batch-freeing optimization from free_contig_range() to the
frozen page path. The previous __free_contig_frozen_range() freed each
order-0 page individually via free_frozen_pages(), which is slow for the
same reason the old free_contig_range() was: each page goes to the
order-0 pcp list rather than being coalesced into higher-order blocks.

Rewrite __free_contig_frozen_range() to call free_pages_prepare() for
each order-0 page, then batch the prepared pages into the largest
possible power-of-2 aligned chunks via free_prepared_contig_range().
If free_pages_prepare() fails (e.g. HWPoison, bad page) the page is
deliberately not freed; it should not be returned to the allocator.

I've tested CMA through debugfs. The test allocates 16384 pages per
allocation for several iterations. There is 3.5x improvement.

Before: 1406 usec per iteration
After:   402 usec per iteration

Before:

    70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
            |
            |--70.20%--free_contig_frozen_range
            |          |
            |          |--46.41%--__free_frozen_pages
            |          |          |
            |          |           --36.18%--free_frozen_page_commit
            |          |                     |
            |          |                      --29.63%--_raw_spin_unlock_irqrestore
            |          |
            |          |--8.76%--_raw_spin_trylock
            |          |
            |          |--7.03%--__preempt_count_dec_and_test
            |          |
            |          |--4.57%--_raw_spin_unlock
            |          |
            |          |--1.96%--__get_pfnblock_flags_mask.isra.0
            |          |
            |           --1.15%--free_frozen_page_commit
            |
             --0.69%--el0t_64_sync

After:

    23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
            |
            ---free_contig_frozen_range
               |
               |--20.45%--__free_contig_frozen_range
               |          |
               |          |--17.77%--free_pages_prepare
               |          |
               |           --0.72%--free_prepared_contig_range
               |                     |
               |                      --0.55%--__free_frozen_pages
               |
                --3.12%--free_pages_prepare

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v4:
- Use /* */ style comment with boolean variable

Changes since v3:
- Use newly introduced __free_contig_range_common() as the pattern was
  very similar to __free_contig_range()

Changes since v2:
- Rework the loop to check for memory sections just like __free_contig_range()
- Didn't add reviewed-by tags because of rework
---
 mm/page_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6568af69b5cdb..dec72cedcf674 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7054,8 +7054,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 
 static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 {
-	for (; nr_pages--; pfn++)
-		free_frozen_pages(pfn_to_page(pfn), 0);
+	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ true);
 }
 
 /**
-- 
2.47.3


