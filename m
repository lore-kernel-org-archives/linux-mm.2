Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F768C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9746B009B; Mon,  3 Aug 2026 15:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91866B009D; Mon,  3 Aug 2026 15:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31D46B009E; Mon,  3 Aug 2026 15:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A70C66B009B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 455741C0F6D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:28 +0000 (UTC)
X-FDA: 85060992576.28.C72A580
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A8091C0003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DR6NlXu1;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786446;
	b=pCajWXhGZ6smPOPxiT0wDYoJv2KEv/iMAOgW4B4PT2HR+19dCI9LMRjBhFxyBz469PH+vk
	CkZO/iLIy1nBfGAcM9Mko+IFJ/Vt1YZ24NWIeDGu+r3QpPFyOIfIr/wjm1JJqvm3bB4A6F
	aFE9DwbejRPaFGQ2xbPcVH4B9Llu4w8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DR6NlXu1;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786446;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thnldr0/Gbto0mdkDBuQHq8jA49n+XZslISWD3XgMUE=;
	b=fz8lojV8iA6+xYeoEnbwq8EjcciQZxzHXD/I5WNU1uORWYWapv91zPNBTndKPt/su8bg/c
	xzaCRncUk4Hd9MaHxzN1Wyuvwzxlcpu0ZN4Owbg+qyV4Dyr6V+e5tESfEmeJzUoPoOydkt
	yhJBG3T5GJotBKYBneObBCOjG9mW56Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0742644FB0;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBDDAC32782;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=cYbOLfejrKyQ9BPd8CMH99ZNpXZ1w9drr+TtG7Ncs1I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DR6NlXu1rq5Z+SXhDN9ulerai7GEJwrzpL9Q56W/L9ph2wNEmAl6eYzYKPIeLnBsn
	 NgZAi1VRVCaYS0vFiXM+6nfNaChvZoDUTxS7se3JaKl7wkHXinNHVOBblqePpDMDKF
	 9iz/D1V3MZJeehVkPHTeffNs+iRIP/Zur2ckBO+qxQhZCDHgnXolj2iJ1VES1sIrAp
	 EHRKdgFz1n993debHt7uHf1+Cb/4LSsNfpSSLksax6/8KgV8/mMg3pw+BirsymwJqY
	 qii9NSRFISffUDeKF6BuX/lzEKGvUyejypMd/sxebeJSJXVh4949yokP/lf4MG1NLW
	 PUWum8Y5zcOJg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A426DC55184;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:03 +0800
Subject: [PATCH RFC 07/15] mm/mglru: move refault workingset activation
 into lru_gen_refault
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-7-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
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
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2070;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1vC+xi9jNiCocZFLKmWvRW3U2STkCUDTFpNlV8n9RbA=;
 b=52vn6IfvHhVTl+P2eITAdJpvk846TJfwLfY88yxmTc88qbpfSMc32svILrESnyC2fHKo7ZD0j
 ZaK57q/2igSCfTqDJ7iXTgDStAVyQJT+CccWDakvux35J5eCy4eOMqP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: a6d8fkgxoh514x8zfxz8oofj4jgqtzor
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A8091C0003
X-Rspam-User: 
X-HE-Tag: 1785786446-432531
X-HE-Meta: U2FsdGVkX19naal67iybUCoHN957JXphBhJQjVX5A9Qv74m478rCP5up+w+NLYM0oXbNHR6UFe4yfDNDKdy0GHqogh7Tx9OEiRXKLgFSIp4OF0wjvj0FqKQo9PHIXh7+j/0DuclzQ5QozcjY6sAB2QCFPvXwqfRZUrllj9EzVw7HZ83cSnVKQ/L/+b5YnWCE1q1Q+37l+i+uV3jtjgHvpaJ+FscZgWMbJ25tV8f2NJbc/Bc6vRpVVVTPJl4aZvo0PDzxMSL6qh4HEEpk2x/oVN0+dHRXz/0qznEjtufylSCmSJ14TYlUmG52CwlrZm0468vcPqRT+zaTrXIjBdcHLzKz/aKJIkjzVNpFoapuariv4O+LG9CmS0qqTc1iciopTpIt/F1h0XC4keDbhVoO+7HQaB+9Ye+pnSfEmC0k7eLqQXEsRcvkBOhq65uEoZ/FCPzdZhdVLgNBxqVU/ZiVgmkyuVhGDyJzkmdFKRZy2xx0owj6Az5Ev1XyI4uKCeJVeJBeiZwhwao6BKlw9S7ml46fEUWHX5Cxhid6/pWX//d2FzLbZWNjfLyJhMHRL2eXZQ+C71sdNL6hd/eyWwesTJ5EG0dR+DBRVrBfy9A0wtmj/REc+rAPTR13w6CIb8I6hec1V1udTiv96LyET0jcDEYJMORJn9rU9zgSBABvL2oXawlACRo9SIQIFfP2tV1slg7htfVEbkJgla6x1viLB4I7V0tw0evkDc8b053FT83m2ZkdzdgSN8jxaNWXTtK0GNKrqq9y/cYX/kC51yQo9tK9MEArFX+hqCTwHH9w63A+MtaHA4HftLlwGfxJtQxRuTwSnHRJFd7FmAiO44i7F4AKcpe7eBDlS/IBp9BtakG1NmIyMrgAUzaL/jk43Cu8Sapl//9PrDi6odtnxNhfYxi2rtf9fuctrx0TC67srBWejNd+Lr/W+iqa+kjGfZeBAHjOtIgMTgB2u5/Jhbe
 eDkbcCNt
 tBuzUm1PCqgslWVYcH7Srze5XOy4xjH2H9xmUvxhK8NvWzjL2fyBPuvx1casGRtvYUy0vk37shTGSDaSauFxh2l1haOX/U86oZsN30eIVejXexFtgFIDsXzflHDA0VynzMc41TBP5UF3JEtc+O7v6x8Gm2SryY19on0q459S7KLnxKOaK7YXwNzBRofScO+M2wblSqF5VVddPEX6C0PbSIDEUl6an/o+xGL1x7LG1QM7WXvUbWVr6mEpIg/FObsNk5dcI1TKvaF4PKWCFQtzf5SuvEojHn0Vjytp6GhsIFJa+LGhqMS1OdzFqtOkWi5Rasu3k+gD9232A+VyfFIEcopuTNJT41v77sKWfUprpUPpQYATDez+LdcHRvycgMIkz55Zg2zLx0+t7HPNmD40DuM1YFQuNtdxUIOCaaUod/qSthuPpax6RWcXn3Z+aXNvjVh5uxmlPp9/E088=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Move the folio_set_active() for refaulted workingset folios from
folio_add_lru() into lru_gen_refault(), where the refault detection
already happens.  No functional change: the ordering and logic are
preserved in all cases, and no other paths reach the removed branch.

This is a preparatory cleanup for MGLRU-FG.
---
 mm/folio.c      | 6 +-----
 mm/workingset.c | 9 ++++-----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index f90b7f86dbe3..fab00cb02970 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -474,17 +474,13 @@ void folio_add_lru(struct folio *folio)
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	/*
-	 * For refaulted workingset folios, set PG_active so they
-	 * can be added to active generations.
 	 * For prefaulted file folios, folio_mark_accessed() sets
 	 * PG_referenced so lru_gen_folio_seq() places them into
 	 * the second oldest generation.
 	 */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
-		if (folio_test_workingset(folio))
-			folio_set_active(folio);
-		else if (!folio_test_referenced(folio))
+		if (!folio_test_referenced(folio) && !folio_test_workingset(folio))
 			folio_mark_accessed(folio);
 	}
 
diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae..5438e9390011 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -320,12 +320,11 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
 	if (workingset) {
-		/*
-		 * see folio_add_lru(), where folio_set_active() is
-		 * called for workingset folios
-		 */
-		if (lru_gen_in_fault())
+		/* Send refaulted workingset folios to active generations. */
+		if (lru_gen_in_fault()) {
+			folio_set_active(folio);
 			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+		}
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else

-- 
2.55.0



