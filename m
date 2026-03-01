Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97F3FD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC586B0005; Sat, 28 Feb 2026 20:28:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FD56B0089; Sat, 28 Feb 2026 20:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB966B008C; Sat, 28 Feb 2026 20:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D97AA6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:28:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 789B01B750B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:28:29 +0000 (UTC)
X-FDA: 84495759138.22.4F8E930
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD322140008
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:28:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K3uSM8T3;
	spf=pass (imf09.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OOfrKl+Um5EtMBdfonGSWUzDatad1HVwuDrC88O344A=;
	b=nVD9CAdcoCOyVp0BIwHzJQ4Vp6RCfwixnToPOWg4ieZ5gpaJd/eKcJH88Yz4OOVvg1a1uY
	B0JK8anqLCbpqQ7MvVIcchEofORtE130N+tnjHI9hNHg+2AO2TbhFdlLEZFOCvrHDui2N/
	aOOgtMWX5d1goj9fUyQ7baFF6zTi5w8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K3uSM8T3;
	spf=pass (imf09.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328507; a=rsa-sha256;
	cv=none;
	b=Fo4+74pM02Nmro/lm/vLFSRPPu44LhtFMg0Bx7mStsJ2WFbIbTANWJTT5Uerhtul7BItgl
	adOnl/xxI+P0znKB6v02TWelez9Aisx5X2186UaIr/0Ewe0n2Temgfgkv5pvuMC5OWF/Z4
	bSmk4q2oHcc68a8gkuHBNnWs7ecmkS0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8877341743;
	Sun,  1 Mar 2026 01:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA864C19424;
	Sun,  1 Mar 2026 01:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328506;
	bh=+O76RfsTh16i6VAVyeQr5CmkQXtbbU5Iq6n/A3Vz5/g=;
	h=From:To:Cc:Subject:Date:From;
	b=K3uSM8T3owkqgbaEfkbzjp+eeY+Z7L09OoYYWBDkLJHnWuzfrH8CG/MQYf4zlfd6s
	 XFDWy5IT5s018NUV8AoOjMx0EkZTKh/1vTvkGYZ3oxsqAKpg41tWH1Nh12uDx3U+mL
	 UPDJRBeTHlesWSTKScS0uXuDJi04TSvY2Y/1r/i/Drbf2H9hXaguYXLSHa+w0aD9Q7
	 9XHZj6TYP1H/39JCf7C0VHaWMZ8a797+es7UtEKxVeFxmt7fq2XciICBfJ2+nicwKm
	 tD81GNWv5jV+S/b7j3nZmK7aLzUVUkblch34NPYjSF6xPA6R6aUCxDGsgithh2yKQF
	 u1dC+wTo1nNOg==
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
Subject: FAILED: Patch "mm/page_alloc: clear page->private in free_pages_prepare()" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:28:23 -0500
Message-ID: <20260301012823.1686138-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 86fmyficiicmpb1ugdhzaj5qcddcp188
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: AD322140008
X-HE-Tag: 1772328507-202064
X-HE-Meta: U2FsdGVkX182DWUz91eKUwYGGa6CkpC60vOv4g5QbGLO3Eoq+2gZqDC714DAu2wjqdYzXTSry66psvwowdOgVk5nAhr5vr5xl2lOIfjpCxIJaxXdcz+iYyr6+j0oOp5l2O7wL0duQLmgR5vDmpP4m1dSd2QzszERY3ugYikL5xpPR/VIk1C1kg3luAj0bQCDxEZIrm12r07oIsjRhPKUgv+w7YUt2BAa+7alwnMgpnoB3ZkI7A0i/HuOiQeffBwNhqeEl9Izx1WaKCPIXKC2sKaIuxK2R9rICCA3KlQnEFMXCcF36n8IKiW6f931kPR8noWR817HuQAUz5sZEVStyptwmgk+gMo7ILS6a+ECsDzSAg2rDBatRcTFsKEAlRBhfz+KpFsoNM8agR3cY1QS50AdnX/r6pQ6FMTd8KJDn9j+xln2uaPUQ0dCF0jKtKIqKV8pI8AcpG8XjJxquiQcDawcpOB0mX4y6JvbRo0N1xl8DyngPLf78VhdQSX8A9EFTI1l8F5awvZnctgvWYROhFpULlSZ+gzQWaW4lJvAk5dN/9vfE95XziSAgg2vI+QPJ12p95HGcHBZVInrEkOgG+zhJhArw77EBxJqN6pu2VaA/4WSwguvyvssa1iCeinEvPLYa5ilQnMXkEzTlx2jiiSvyZN336EkNKjYPDWOOlyXC47JejLN6Af9CDl1Pj77T43TvFzVFJHffjEfYNgI1yLUMiSVQaRg7I5RYKbKmXBnbPNOP5Oc4eQP1HEqaDGgIKbcbeyGW4dLRRIkp//OC4kcEjXDfhfrEim2V75x8gt83myHgFBRB224wNBINP2+hbfHSbzcgKr2iJ8X4PU2H2A8pRDkvE2/8zUGwS57X4N87esQDy9J+aASBoK/eXYWge39J/CvSIMlSA4c37/RKs4KQcAuHfU4Mg+zWNkTmfV2asH61SGkJOb1o/l2zRuxs5FF9jhrivwZ4E36Upc
 PJlJ4MQW
 t4EEZvovMpuQBhWdj5Bl2TqWnDbQ6XsrLY5o58Opmo5Msjffq5TyVuCbGeIQ2jHFa/V3JJIB+tGYhPFZnsYHXgM+A6M3VEd36hwLXhJgDjUp28SrGonxrk3YcfiGM5tu1P51Sj5HHn096hfzE+t970SyQRIglE+0iW8HDhDoQFQeCh1uThqgkxhCjawsvLFxsG3fbK6a+z747D3umdBglByafcTeB7j9F9EGE8m8Xd5/rMcQS+DKTXBt9Jcs8tZKuGnEGKR+U/6W1wOJgAUiDToiPv6cFdEraiLiV40SG3SusbBx7JWv2Y9GGU1vMiLScxLKsSHk3DcLlR1IR165cSVZUsDsoSrdCJMEaBJZ5PLq/Wum20pk37C1yh2khvCslvs9IHVqbT5HZm2G6PBuc9fxV9SKSmpweTMdt+VVSiOBMVfRgG+3twpDw/ZiG6JJWpQ+YCYFYJ76qIxkMWQgXTSPTdGJ9L9OVMd9Jct0+qyAyQNLq8kbYebxi070kYynsMzCYlF+rH0z2ETFyQhsIeF5RGUulOuQXFpnuIFsF0S8/Gs+ExobeD4vWXBuEJhrH3VVDA/WyRhopqcqmZN+6mhRs12kP7T4r5kLYP+CJU1dng30aBIUUalfIxPKE5L4R6qLT89CHIRxzszjcZgIAWpTj8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.12-stable tree.
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





