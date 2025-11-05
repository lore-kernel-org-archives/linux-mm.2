Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F342FCCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7178E0006; Wed,  5 Nov 2025 04:05:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE548E0002; Wed,  5 Nov 2025 04:05:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E51B8E0006; Wed,  5 Nov 2025 04:05:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAC88E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:05:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E069F8769B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:26 +0000 (UTC)
X-FDA: 84075969852.09.89CED6A
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 014231C0004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333525; a=rsa-sha256;
	cv=none;
	b=XVEyHFKWAgYy4uYS0uTXth3dJIBx3aoP+ZItA0MLxSZlyvJ5sDeZns9aRg4uzY4DelGAjK
	gINsQ1/+v6W8PeESCcb7arEnVyb+532dFa/+G2tsf0y9VboySTbXIgA5XfNF9VPjwPt2NX
	YqXaYXTpjXRAy21oM0St8TNQxLmi+aA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=q1pURz/rWrwwv5hjnEVYEolJ0ngWWUoUVzmw1aF70+s=;
	b=a2XGAk18a1HSCRgxm3pvp8PU3TIqZGgf7HT4aJyJXHSct/eyC554b7PZqD1170xAVbTgyr
	hDaGA9FkGszvM+pOP1u116upQwBkDaAI9uDrSO8QnQGMwdobdIkdaDH4TjuSCFa3I0bmeo
	aFZoODs9MGte4KZmaZVOol2M2XM9i5Y=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d1fXs0SswzYQvR8
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:05:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 7EA061A07BB
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:05:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBXrUVLEwtpFrQbCw--.12398S4;
	Wed, 05 Nov 2025 17:05:16 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	willy@infradead.org,
	shakeel.butt@linux.dev,
	jack@suse.cz,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	libaokun1@huawei.com,
	libaokun@huaweicloud.com
Subject: [PATCH v2] mm/page_alloc: don't warn about large allocations with __GFP_NOFAIL
Date: Wed,  5 Nov 2025 16:56:52 +0800
Message-Id: <20251105085652.4081123-1-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBXrUVLEwtpFrQbCw--.12398S4
X-Coremail-Antispam: 1UD129KBjvJXoWxXw17Gr45CF17ZFyxKw47XFb_yoW5Jw1kpF
	WxCrn7XFyjqF18uanrCa17AFy5Gw4rJFW7Wr9ag34rZF43Aa429r129r4YvF18AF95CFyk
	trs3ZrnFy3s8Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoeHqDUUUU
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgADBWkJ0jBqqAAAsE
X-Rspamd-Queue-Id: 014231C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: j95rpdcowa7o6xpwsodwj1ciizjuoq69
X-Rspam-User: 
X-HE-Tag: 1762333521-787525
X-HE-Meta: U2FsdGVkX1+NCQBTpXTCqEJ7rNSTtJ1h8DueenUT0w1m7eTJvY+BLea3yNHL4B3thZ6m5l04Y/UJLFoGDQusSagOjjp25w2Ed3/cIR75bd7I7vJ9A1fDFgbN1IHDhO2HS0KKVCt7KFig39i29nHcs8DtX1GmuUAWy5uiiT0wO8CqGXasJ4tPMA1hSI3h3dDx3icxij/8l08qi5FCkdgxvGyJ5d0uESyHAgS8mxu65xYTE8K2NMCYSnIIyjBbiEGjMvj/op+nbIyyVZQcA59fW1FI3EgyMlXLbUVU+Ur1d05ca3r0UHmUbWI8VHlE2RuhQz12nafcAWY/jO9Er7bM5B9mMvibzgo5yKt6t6rukHVG1XxX1mX5DW/Xgudw7wPtFCsYWzhT7EQrL25t6DTTnH2J7jMCrkWSdsoSs8ho3PTPDEYsIydkJm4jzf8gqDy1FQ744uuK1pWTHvhWj4+lBqJclCJ7OGMiUJ05SDO6Wt+6bK3sr4mPf+8D6z6LDdngXZ3qWyS4MA0zGt1HQGjUwDGxhiGDjYOixWtgHiv8tNr1D6fLxqB5bu3KOpcNw3RblRG9RqakJH5wONkYTaS1qqDvbohMcmwKdkrFEI5PJLBTdju+sOhy9JKVqjprWNW7KmufN6WSlHcqs91mo+bK3xBJ9QNTZ1OIBBneV8keJjlyyDoLQwJR+xIXby8XwtVCtJCHlZgPQk8XK/OW6qpHjkDo4X8F55ilAqIl+5z8gXNFAQ8OC0VdhQqRVi0a8nRlbtUmurUJhWKfp8FjdgG/hsS9UdMlJW67FIwndaUfoK3cDMuCmo//QdxOaKv899STcMMPuHFyzIuJF8qok0EBHK3ztAyi0YVcQqSyub0FN+tbqHdY/9xQSVTsGUFO/8GdlIQmWDdJy+Wn7WLqzja+rzEc7nSxSEAaVUS5bbMpAejnDUDX5sU1Jh0ixYLWj575GQ283nJIPkNZedttM28
 QJ+4+QfZ
 yv0m1iokiDQ7FT/REDiVTBuOZNKpHw5rCQCenDTp+1IwX/CDIAIVT9+NwXS0YsZ7j+ySTDfxypafLHkfWbEk62qLBg1WrBz/Aa0geIcIacWg5f6MRAGK87MNwFGbyCE84oXzC62vyYaIRC6QEOkbfEn+8kPrSS8TkZOYdiHSOAxp+i0Ng5lD7a/JGGsXabHyRJTpCsJId37vzEQcxBYlHLTQ4oGLownlayhQTqhLyAuarqzmM79Eh+JieIRS3T1P33xYDGlG+LBomlRsf5LY6lEjtzau8z7Won62w3rVwf4wQIJeARQ87xpq3/r3buON/0y+5N8XmxgpSNnMbNWSccdbHbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
reads at critical points, since they cannot afford to go read-only,
shut down, or enter an inconsistent state due to memory pressure.

Currently, attempting to allocate page units greater than order-1 with
the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
can easily require allocations larger than order-1.

As Matthew Wilcox noted in [1], if we have a filesystem with 64KiB sectors,
there will be many clean folios in the page cache that are 64KiB or larger.
He also explained in [2] why kvmalloc isn’t a valid approach here.

With gfp flags and order already included in the OOM report, both
Vlastimil Babka and Michal Hocko suggested that we can take the risk of
removing this warning first and then observe whether a large number of
related OOM reports appear.

If that happens, we can consider adding special handling in other places.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org [1]
Link: https://lore.kernel.org/all/aQTHMI3t5mNXp0M1@casper.infradead.org [2]
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/all/188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz
Suggested-by: Michal Hocko <mhocko@suse.com>
Link: https://lore.kernel.org/all/aQotQBjnDDeL_wHx@tiehlicka
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---

RFC: https://lore.kernel.org/all/20251031061350.2052509-1-libaokun@huaweicloud.com
v1: https://lore.kernel.org/all/20251105074106.3508870-1-libaokun@huaweicloud.com

 mm/page_alloc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb91c566327c..e4efda1158b2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4683,11 +4683,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 
 	if (unlikely(nofail)) {
-		/*
-		 * We most definitely don't want callers attempting to
-		 * allocate greater than order-1 page units with __GFP_NOFAIL.
-		 */
-		WARN_ON_ONCE(order > 1);
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
-- 
2.39.2


