Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D864BFD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4676A6B0005; Sat, 28 Feb 2026 20:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F736B0089; Sat, 28 Feb 2026 20:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352086B008A; Sat, 28 Feb 2026 20:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2478F6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:47:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6E241A0327
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:47:31 +0000 (UTC)
X-FDA: 84495807102.01.C3FB561
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32F20140007
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:47:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bn95q+Vg;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YKPYFaW0XPAJcOQZl6MEdUsf/+mtr3qOA4R4m/l1cj0=;
	b=jA8ceYFX6a9gI7R+z1YHC05fw/3FKkiMgiGM6gpCq7Apw7E12xv0iOnCM0cf57SBAmUqBs
	6DYSt9vLTtUv8EsS8tsreOeJQXJzv00iyizwT/XMeXSJBHZLsI+3PBAP6tHyUeq09pMU+T
	2cSmen1dT2xVHjMvrKiVD7+sz6GlPR0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bn95q+Vg;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329650; a=rsa-sha256;
	cv=none;
	b=sBXqGDQ2TJQIOktl+KitlZBiB/QA/Kzdm4TqidQOzK36GWCYQFaWyifsN4a4rGdUSOx71K
	JulUP3N/wF3WRsc1ZfWmRdY3OE4pYicrDgUhQmAYwvRewNody4AQ2PCcdxmT5iqPXdKP5e
	j3XO/WExCViHFj69qUDEYYe9svayUZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 95F4760145;
	Sun,  1 Mar 2026 01:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6E4C19421;
	Sun,  1 Mar 2026 01:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329649;
	bh=piQ65YnUVlIt0z8UkIL3CX8AtUqGsXDg+GbwtyZgHbo=;
	h=From:To:Cc:Subject:Date:From;
	b=Bn95q+Vg9CgWaqEDtUpSUDOLFNPVgsap2gW1+otZmyLkmTPHq51T1UkmiyqpcgVzF
	 CBuHs2vYVsnXQ+xQFF8Fv4Yd79IT/5Qd7QFtb90T6AG+0P/Eh8CoXBNgcq+XOd5vE6
	 L8htsIJf2qsE1wui/o6rlhwIo9g+bkstR/xA/QpdJeW20QFtNG9W4pUTVv0XnmiYJ6
	 Cp1USCGfr8Yw+3XcTztRw8/xgPwva+oH++t2dqYtiBbDzmvfWZKCVyIYS7C1fX+hiG
	 YSmj/gSHEKGyDLEANPQ/p2Qb1iQVDarYJondtH2jnfdA6u6+oEjANVvgxOV9UcDTTZ
	 rNoybNzy8UrcQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	mikhail.v.gavrilov@gmail.com
Cc: Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Chris Li <chrisl@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <ryncsn@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/page_alloc: clear page->private in free_pages_prepare()" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:47:26 -0500
Message-ID: <20260301014726.1711397-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s4aegtq1m5hhrujyx3po8mt6pbm74yyp
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 32F20140007
X-HE-Tag: 1772329650-460933
X-HE-Meta: U2FsdGVkX1/r0kAciUDFZDUsO7ZFmQaJ4tRa9e0hKwZIO2f9yQM2f+a/9CRw3QxAmqFRiRuNY7SsYn0ejFyuoRJCqjqWM+bSSY5sNviDhL1eyNhA1elihrrlAfOJxGKGMsLu+9Z2b0ACUJcPp02+3mODRrMx3x+ViDc3coHUvm08ryv2s3Y57s3/JDLDWw/b6uqqiblSj0GqhDGMxPS+xpboKdrc7lJ2ndoKGH0iaVfWdYPd7hHSizrNo4r1hX1ZNoM5g0v+ALdQeImp6Q+CdaGNsBg7VAVdi/LSppnzfOOhyvTCSC+4mxfAJel72HkOWna9fwBRlZbP11jednnWAJ0PsQXiwe2XmF1uqzs4IjMZE11wrVN5cCT2G0VZBUBd9unjQ6VwuWSUnvTjMyW/Q8rVLWnt8UDmG7lcI7rqh7KCKVowhuq+E335vB+SFEGKldEiCYttEWmXO6mWQMKPX+nevhBmpwBo/4X77/nn4QAnxRkH4Uoz6T3nusu7mcdROyo2EiviXbA9Fcsm4OafLV5EFtpM7W5Q3JZ/eQQA6Akgzjl7NfwYOZmgg8vvs+5oxtbenQdkOy9CuaBQz2r6Fzy1sLZIpDLuqUlPwjxFa+X7N2MgzjVTStEYkF1fwpYEz5FrA1HIS/QI0RRQf0l1aDdlHi50w1aMi5I8kIAxWduUPqSMNc9nCOFdbWEIdkQNvkj8bJ7kzH+PGUJT3XNBDF0mif6FIo2LDWDAtonC3/TsxqY8BF0TwQlyZP7OIXmFJDD6vMzgKUZxR57A/dRFJVaL2smyeGgNF4fp3IZfXueh8UF4mSQr06C+RS5bvUEk7euVsTnbuHLR9zIma0bhQWemb7NQwKTIeASVMnINJI0P2BL18UrfQS/elGQf2nan+3kPCgggpICzs6LJc+imJX521jjW0epfccYRoL6zBKhDK2J+FzxM1MSPRkY2JzaGL3sE7GqMB1KPQaFb+Lx
 J0VOQSsC
 JezaNGs0E4wrc+5/wmaBAtMU/3LWN0A7YUzvui5fMRYxdOs4iVD8lVr1tqYoMiSNIAX8/pWWhz9FcTLa34WpQ+hXTaH2n91G9IlMXAKq9M4Jlh2PEm5nIzUkTI3Aj9z9RWYJzPoaeHz6CMPwtaYH5s+U05LrPHwHzLb/OiCpWWVqs3YFHow2FlrszaFXGGgf/Xrwe3uqtta8tql2mLMg0amVoAL6PkZgVRK90BlTf2Lhi8lfZcIVbAwqMuiTsmvC1HwLrA5Zma4ZxAYHglwl6/ConjGll1KS5NqPvkhW8wXiYUl7VgPZbEAU1Ez1DOcBN8aKCs87NJ0FcJeUPfqvMpuX4lk/h6I6psbNAlzbTuqNGeWJqJqKZAL860TjYAl/jf9lex86zSqfYbUKZQMCA8qnrXTu1Og9qS0ITx1vp7B3t001+VHgewhtSCXGEKTtMI1XnsEgaQpzE6/PyRGi076IqH21WWxW7ntIeaXIGriChW8AAXgJWWE3F5Wtr8JE8hyDptV1VJkTopxooO4+oEwnQWOYoNdHd57pmw7nAD38vLqAdSt+Isn8WdsE8haG0AUQpRL6W44DSkctLzfuqhPwVpmqtWdZz78poHhhtaraTZwuthSsumqMuGFiRnJgk9US2SZQ5jx9MWhRaDoZUdImV2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From ac1ea219590c09572ed5992dc233bbf7bb70fef9 Mon Sep 17 00:00:00 2001
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Sat, 7 Feb 2026 22:36:14 +0500
Subject: [PATCH] mm/page_alloc: clear page->private in free_pages_prepare()

Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
clear it before freeing pages.  When these pages are later allocated as
high-order pages and split via split_page(), tail pages retain stale
page->private values.

This causes a use-after-free in the swap subsystem.  The swap code uses
page->private to track swap count continuations, assuming freshly
allocated pages have page->private == 0.  When stale values are present,
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru containing LIST_POISON values,
causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private in free_pages_prepare(), ensuring all
freed pages have clean state regardless of previous use.

Link: https://lkml.kernel.org/r/20260207173615.146159-1-mikhail.v.gavrilov@gmail.com
Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4104973e22fd..77dcec36946f0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1429,6 +1429,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 
 	page_cpupid_reset_last(page);
 	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
-- 
2.51.0





