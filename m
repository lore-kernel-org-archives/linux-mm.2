Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC33606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rwD7SgQf
Received: by kanga.kvack.org (Postfix)
	id 5F0196B05B3; Wed, 11 Nov 2026 21:42:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A346B05B4; Wed, 11 Nov 2026 21:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4422B6B05B5; Wed, 11 Nov 2026 21:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12EBE6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:42:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76C7D1404AC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:42:08 +0000 (UTC)
X-FDA: 85424917536.11.DBC881B
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf13.hostedemail.com (Postfix) with ESMTP id 69AA420002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:42:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rwD7SgQf;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794451326;
	b=4Jh0B+FXuTVXL+VK1EgQsVMWrRGv+4PJchgNSzPyEp8l7Eg8A8qAQXOKfkiNCkowDXvRF/
	ldt3bKXzMxzgrEIHe4u1+H2Q3pubJPutkW2vdsFPQpiE7aQozmrKM1gURNX94gkkktFHf4
	bMCMXMHApNnfw2mEhIKXwoc/5SX9r0Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rwD7SgQf;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794451326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/8c9L7Aa/+KfdpEEVA0L9SAbBuPuYRG32gKLgx+Xt9s=;
	b=k8jGuSiDLKO/eHlI+63jFi+CmWNV5m6QUiyE/acFfTdf/nJX/fS4lA7NZ8bEkVBlbkbzIB
	nW90/645JeIV1SLjDmUtudVl71KU/WM7HqRqVZFgkA6R8nhtn8DQnm4b574tswdUtj8ULE
	XoT8956nYesmuMMrhmSmdO0hkL64v28=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q4lNDug3J+65+63Wa+IbdOW7P2vunUh/rpySJhsCY98=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794451324; v=1; x=1795056124;
 b=rwD7SgQfEgC6rrV7WWPKH2gzBLQnBD/r6eSY4vKwzGhih90hbrvU1BAYLMJiPU7kZQMKXqQ7
 a0kwMSsPo96P6r5rbAtQStjQ/es2Hn4JQGftK2u7cLu2n59w//YJucpi4k0YpnABPVeHjSG9eJM
 mOS4vPP2kZiHUpWZRJ4wi9cY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cfce15ccbfb00ccc;
	Thu, 12 Nov 2026 02:42:04 +0000
X-Mizu-Trace-ID: cfce15ccbfb00ccc
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: [PATCH] mm: list_lru: fix NULL deref when a folio moves to the root memcg
Date: Wed, 11 Nov 2026 18:41:40 -0800
Message-ID: <20261112024140.648088-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 69AA420002
X-Stat-Signature: f3ij5ehbi4qjt553q9xnqrfx4wej7zfj
X-Rspam-User: 
X-HE-Tag: 1794451326-696194
X-HE-Meta: U2FsdGVkX1/F58UT6uMTkjoaOlnhHJ2r89Ri5DYZP9a7yD8cpUncSjvhfgeBl+WVX7u9k4P1hmeCVrL2Q8ypYxPHgnkQVms9OdMEbgiV+tCM7n+0rKfd2Skg3vAGsgyW0TSUwL9CpkWeCKEcFeEVZP6RMF7PYZpf4S1XnRT8NCVDjNwHLlVpAlTl2MBS+Umw19BVtFZ7+YdtkBZOENmJDmdl6HXy3U9Pe+J/aMpVJ0TqdbvfXsrPnF6mGpISiAO/hAZeB+tk/fRSnySonKcxvlzFPMCONfgVM7yBcHs51uncbEkbU1hPlQvJgBmzwqM8WPGtirrCCH4Rkx7dKkXXjupSObWbYZZCRwas63goswUBOPyry0cwh9vbgb734t3AAtYpi0pTZodz4vAwP1A6bAwVouTm1afJKSrzEs8YDrsc8pHZpnqGkzx5CTH2Axp0lTANk3ACZRVRXcqygVAmo0eGScXP3Rs6SyQKdcLppW6QjD6CtC8xQeKMnV3baaLssS6dp+g8O4hZ9W86uVCjjxT0uDz8kC4pXP3DX37N8XLCx1/4uCBdelRMkjKACMHJ7TZsLWT+jcPQbR2vPkQ7CfXt9PALHx+qyBb01TbhuIMPa73fQm90VAlol8YqX5jAPYU9isawpBUzsleIlG5Dv7aAp/W7Mt9uo6/8bWyohKS539nMFPcXIa10aPfuo1rp9txaul+BlqurdJ454SVZ+fcBEAw876nnnYatBMXcfmAX9cz77hKZI/vIJ3QOwvLv3h8nqKYzhCZVOprIIlIv93svNafhYLWixpxDcmoTcjKkZy+arVTKDYgRTSLAogRnkTsn8YOeRcbUNSGsUeYRusMpDphWukCc0FqmNS8eGXuItKmaBYG0Ju4zvWcE9WWaM6E02V90SUP2c+U2nMXzIZidVbpVLTw/J9IByLVhjbksJBMEYwAaKJeCASLC+BD1lGzdMaiVjvGLNLzDKTV
 7yEwMk3q
 vjMhac3CZx0t0JEh8AUYcBa0nP/iWzBt/Bn3GLvtUWbJzaQL/sU0fv3ogeOzhilmbfFIkDBn2wvGp/w2D6To9IV8+mNLleNiQxyWOxg+vVHZ7lblyJG/54/1B9h+lct6dtYHShjB5jCYSWQqns7M541+RXZj8yzToIAcodtigbJQSsreZQ5zNrcJu4vrnlksXEcMurdaQ3Q4CBFhysIG4tHCH9Sdi+Gvojs6axS9Zc1zYYwPPPKA1QXk/Ftt+gkxCJsjAQ9vpkwZWbhNv7R6hfnCvRl6aKSdQH5bTc6QgNqkyAUXgwYamusoeeSf+XEDaO3eP7j1mEYHXdo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_memcg_list_lru_alloc() makes sure that a folio's memcg has its
own lists in a list_lru, such as the THP deferred split queue. It looks
up the folio's memcg twice: a fast path under RCU checks if the lists
exist, and a slow path takes a reference and allocates them. The fast
path returns early for the root memcg, which uses the global lists.
The slow path does not check for the root.

The memcg can change between the two lookups: when a cgroup is
removed, its folios are moved to the parent memcg. If the folio is
moved up to the root in between, the slow path gets the root, and
__memcg_list_lru_alloc() dereferences the root's parent, which is NULL.

Users see a NULL pointer dereference oops while a THP is allocated,
such as in a page fault, in khugepaged or at swap-in. tmpfs huge pages
are affected too, and for them the oops can also happen in reclaim,
for example in kswapd. The task that hits the oops is killed, or the
machine panics if panic_on_oops is set.

The race is narrow: the folio has to be moved up to the root right
between the two lookups. For example, its cgroup is directly below the
root and is removed, or has its memory controller disabled, at that
moment.

Fix it by skipping the root memcg in the slow path too. The root needs
no lists of its own.

Fixes: ae64f07a6a40 ("mm: list_lru: introduce folio_memcg_list_lru_alloc()")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

---
 mm/list_lru.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index d1d256822ccc..566691ca3dd8 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -645,9 +645,15 @@ int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
 	if (likely(res))
 		return 0;
 
-	/* Allocation may block, pin the memcg */
+	/*
+	 * Allocation may block, so pin the memcg. If the folio's cgroup
+	 * was removed after the check above, the folio has moved up to a
+	 * parent memcg, which can be the root. The root uses the global
+	 * lists and has no parent, so skip it.
+	 */
 	memcg = get_mem_cgroup_from_folio(folio);
-	res = __memcg_list_lru_alloc(memcg, lru, gfp);
+	if (!mem_cgroup_is_root(memcg))
+		res = __memcg_list_lru_alloc(memcg, lru, gfp);
 	mem_cgroup_put(memcg);
 	return res;
 }
-- 
2.53.0-Meta


