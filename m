Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DED4CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39B506B009D; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211F36B009E; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DAB6B009F; Fri,  1 May 2026 17:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E27DD6B009E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B65DAC1412
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:18 +0000 (UTC)
X-FDA: 84720078996.11.2164FC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F55C16000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WQLswZ3B;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669456;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIMr1qjbO3bq0xjXLM0oNEpXVBIYWDgKxGaiAtPmSRY=;
	b=RFHgTzAR7xlrQD+g2r8DKCiSQKOEGCEFoFwBtcFMr3bNPTi/aSXcEpLS2VrZhKbJDpgQ+v
	/2p/P6HrImWmpWVbnylVX3WQ18hU3nQYENM3X719j7Iqz/MuUMXVO8Q/2QF9SR/UrbLCd8
	azpr/d6NWhCl0T61cdQunZk+lF9pDDg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669456; a=rsa-sha256;
	cv=none;
	b=xQEt/UjnjKEJlL+oTR5nFyGkSHJUNQJKcS7l5iJAoSRr4hfEGHU7XKkEaPn1m3X5FC37n0
	WoefWdcCbJHrwt2hO2tj+48vA2DJ4jNm6NakGAC4xffMwqXEwb1+zkdmwTN56n2Qczyh/3
	wY+Mt/kQfJwY5CmikllfFMTF2K/njAE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WQLswZ3B;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB460445AB;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A47D3C2BCFB;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=Y7iBY7mlSN/lByjcSiiA8Q2HY0ocRA1rqhdeQIY8wfw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WQLswZ3BHqk8QsMCosDxCOyRah8sCK9mM8d+kHVbj1/sjNFSDMizqlbEYh8eV8gFp
	 5FzCmv4T0CDYQY0u1qBcMKsUpx1gmp/W4M7g1J2uHn3BAdLpAL0ka/DWs4NZaGEePU
	 QfG1p2cUQeuVlGXb5s/XIg0drUrMsUeqOVhulkrNGOfPbGxIoCXzjMYi7SsAfe2JWc
	 8YR8iLvEQ4qppwkqAIaN5Pm+ypzhMsVL6ldFZwc0dujcVdEgvps6uHGYxlJS7LBLWE
	 rlGjqrRnbYzi/NRf1fO9LSkprAqu8RTZfPU+lUG2XB6VxwGAS9jxPc9yUYbi0BBaKv
	 g5BVNKX2krNQw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFF5CD3428;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:55 +0800
Subject: [PATCH RFC 09/32] mm: replace folio_set_workingset with
 folio_mark_workingset
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-9-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=1960;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=R9UYu0s/pryes2odZArBSEeX7+UjdOfURrA6S5mawmM=;
 b=oHo47lWbXKavCucKWmMfLLUs3lCZ0hcCiiwYPQV6fBHKDp5kb11/cGdfRYKUhtz89xvWpZvna
 Pa8zYdBQ5fTCdPmmbqpdrq8R5vX0i4CocHaRDxIN0oGIoBXjqpah5tm
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F55C16000B
X-Stat-Signature: 9ormphf4o7m1ep3xihahqux4hsp6ihrn
X-Rspam-User: 
X-HE-Tag: 1777669456-255141
X-HE-Meta: U2FsdGVkX18GC1mGYHuvlUNbsKS1pHFgxjn2VkzyKrMmgopf8geeCVDPkBkqappHHZBAZ1x15CyBhSS1389CIjkDEKdKV91oKpZ2dQf5agxl5y3aqzkc+gI6A6zrmCwlMwEf6jNEW6+ipy/DZfeX8qRvG1ZK/BIUVkvDuIdsrmhSQr7RZqzcphZcNmwyTs/Pp9Meeh5YZ/5caMQxPHsix4YaPKf0oWO0JbGFbzyuWNrUUXDwL26vsMCsRQJs+sId4XEqWDnitmUpqomhIxUUDJ2nAwUFGSlQ+6dPmZ8pxjl4bwZPIWlWDO5gDCvwMQhI8cB5IP/ZzP78ecaUd7dk+kd+JdCu0BSKM7tL8BmQwr4/vS68gHxv9z53eFhTjNvnPqPQIiFB/+DD9g9/XvNHI8aAqZH/psXNMSxjH0zkEs/FSypOLpY+YQCOp4T2PiFMR7ZWT2wFI6Rm6WkOkbdpKVPcsxWEhJSZnxKxRmqWppBI3+/RH5eeICqpGp00TmUKhwhoFZE3xoePdHHZVogHf0l9TTgEj2UlvJviaXT1Ar9Xyz41d9uF8N73q7pmvzR+lUIcOGzrnMicyZYizq3wtGTxw0IACqa6yP6xLuuay2znjgeNAcKxdf71rKoMRhWwFg29mSFoOThY6xmcx9jhnuiVrrV/T9WmxZEXmHvDZeNrng8teyklwJ2IFtKaKYDeM4/D1H/KzhQh0oyvi43CSC7JQZbaJAIWVAiZ9lYf3L6wy6dLwbm+Bsfdkry3Z7od5uDvb1iGdIIVc81DPzjWEcKkPe+0NvyPiUy5c9L0GEGvxwtDytoZ4j76Wr49jHlTY2YeklcEqBGdFTIV8ydRi0T70yQ8z3ZaL9SpXXRDy6yQ7tlP2DMUe4CBvuUMCVf/gtDlFacE9nEO8PTgmbb5OTzzmQCXuIcwSbt8cjX1G4rriMAc0FHxF6tArhCZuSAAaOye3y2t3E/bYLkLuZP
 xTrbM6hC
 vSH34tOqyP7pT6Bd44h5+pJLMRhyQhiewCQ0tTlzKFg13/TOhuwElD4gutbK8VM6XzUrnWz2i6eD+bHvrW7kL/md6S+/WfBJZcy7GS25PdGk4OIMqRPNJ8ZslGHu4kHzn0q8Z8RcV/KV0xyCe4q1ddbHXMqWnjuZ2wS5Y7FKNVcurOJvc2TMt+CYUQWuBO+07vba77yhXjpRBAz8jlJ1N70cfnVKU9V7DOqbpFl2gZ6cTUT3mHudXo8i8ZzS6vF/E0Et8X24O/GiB3QVdKj0Xj+gKaeofZNpV/xP8rsfUdLaDGw9lEZWh8955JviB01SN9y1ZbrXBc2mU+CiGQUfHiLsUOZXPVe6Zk/5fUnJAaLbuvtVC/P12I8pbcYugEsQghzntMiueIhr70NuS5dB4ZoBjujPvSj5TnQSzmtASC+cVlnaa+tcj9K7GNRbhhRMC8ta2YOhnYiQ36Ps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, new help is bit-wise identical, just to prepare for
removal of PG_workingset.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c    | 4 ++--
 mm/vmscan.c     | 2 +-
 mm/workingset.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..930939c55cd5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -428,7 +428,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+			folio_mark_workingset_by_bit(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
@@ -543,7 +543,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+			folio_mark_workingset_by_bit(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c6857a933ebf..2fd62d02a83a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2141,7 +2141,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		}
 
 		folio_clear_active(folio);	/* we are de-activating */
-		folio_set_workingset(folio);
+		folio_mark_workingset_by_bit(folio);
 		list_add(&folio->lru, &l_inactive);
 	}
 
diff --git a/mm/workingset.c b/mm/workingset.c
index bdb8df6009af..bdee91f54e61 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -586,7 +586,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 
 	/* Folio was active prior to eviction */
 	if (workingset) {
-		folio_set_workingset(folio);
+		folio_mark_workingset_by_bit(folio);
 		/*
 		 * XXX: Move to folio_add_lru() when it supports new vs
 		 * putback

-- 
2.54.0



