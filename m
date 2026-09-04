Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B5DC79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740596B0098; Fri,  4 Sep 2026 05:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717B96B0099; Fri,  4 Sep 2026 05:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DCC6B009B; Fri,  4 Sep 2026 05:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 453346B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:46:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C76DB1201DC
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:46:30 +0000 (UTC)
X-FDA: 85175599740.23.F0BCAC8
Received: from mta0.migadu.com (out-169.mta0.migadu.com [91.218.175.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id D5B8320009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:46:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dDcqYoSi;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.169 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788515189;
	b=IaJAI5dhy2R4Y1n+AynMEhQ9n1tOx+9ihsX/136o6pMplEpeVySwuLnunGqapq0vQbDdyv
	OrUIl1n9kvBMsMwvuNLbKMJ4nFOiDRY4W+Nyxbjwr3rQMf0oJmiUgExrI14e+x5DG1Tuvd
	vqdzBZkHxZpq83DMZ5O+PYgICYKM3mw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dDcqYoSi;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.169 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788515189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHL+6DOoBsjQH120RbAo+/EFI8QT+ZZYHZYPdEm7AS4=;
	b=Oa+wtZqWpLzDPyUKQNcmAzAar16h+CqZnQEyosEWr7KrzB5mv8brEbSTi0E7NsEhe4IErm
	I4IrFoOynyjs4Uvsb+RvZT9AgiO8kWnG9GejRg6GZxBK+9JLOQrRYHTTLF5Rv49vYpD5OS
	8DQ95vinu5m/Xnufpw4dGu4u4cz9bnw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oWXn58rPBwvnPsDKjYWUwvvP2+3EylLcllR8rhtC+xQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788515187; v=1; x=1789119987;
 b=dDcqYoSi1RteUgPJPCBFyZOuwP5ogGsrAXXNvEAhbKiquyCWaRfgRxD5O1pP4dE0FG2xcNFX
 jUe8on/tbg+iHuRz+Nl3YS/AtLF8+/s4lgk/k9KhxnvEmM9/az56bC65da64WthuN2CIUCItehY
 ZWr5GEw/NZtOy5PF1Kd+h2mo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9ecf6e52d081f39c;
	Fri, 04 Sep 2026 09:46:27 +0000
X-Mizu-Trace-ID: 9ecf6e52d081f39c
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/3] mm: workingset: use lruvec_page_state_local() to count lru pages
Date: Fri,  4 Sep 2026 17:45:55 +0800
Message-ID: <2ec3a7f73e85ee5f5739c9dc2e58e9a0e2091925.1788514750.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788514750.git.zhuhui@kylinos.cn>
References: <cover.1788514750.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5B8320009
X-Stat-Signature: fegg1srnan5nugb337x4seckw8dk5g7p
X-Rspam-User: 
X-HE-Tag: 1788515188-456562
X-HE-Meta: U2FsdGVkX18OXGW3Iq1S5dShhRCnX42KYaKPFdCVYL6g+MlmN5LWRwyfhrK7PbDd3ZDSmeMoTfitw/60vgxj537UHBaRqAF80ssWy04kK9NeXsog9ZN2vFcimYKFncbBoN0Tw3xG3x2KCt1Y0mP6NZBmYSMIpntKqbKY5vbW0NqjD9gdLX+W5SSmGBq8WHGEPXT69CmpjtjRbFaeVyK/4mSl3qkaQ0OU6PyKOgqjBmRdo8L9BdQ1eKrGWgkX/KRP0SIRMKkvoC+HsamCt4MowCGk8nrQD5PrWNyFaPn00afisE7+dyFy56jn7txXHhv5Pa0YErF7291ILbiHjTtj+TdpZVYhqYOjxhAp8EWg3OFniskMngdFM5BQz8t3zw5utpaFDYq/fyvTfYEe/1ZbUBIxZoFG+cUUTiD1gG+zunknxqyRJMIptWmnvJ/p0gVNy5yDtmp49d3+AtSHuATbPX73sS/r873jORczwJYUXlOQ5y75infRgpZAypNhJkCkL+2zSgdz8L58ZQ03V/yshMo3k9DWsK/JOf8c1MCJg8W8Gmy1BiObMwaXiTLVp2aCvon9zEEQU/fXyghuFxREmriHtZr5wHt9lYzddUVpKam3/xqNFCnRFlbQPzkR63TTPLK9/G16+OWWEPrYJEmkyMMXgrOYl+E0ZHK0NmyUIM75O8wwo2LIExu82UShqh6UsnsC6a2O48s8dzkD6ENwGGYXGlnlUo3NG6nesdoCAWA2CT+7ZUJIsywYUK+X7vjm2TaAV5kmEpzbFJ3sMutyD+A2le0/oNLqq8TKJ2TDo7aHfDCbvxOd1LNI/AYByny6gzXv6TDJ6DeQ5KHZDXBbmM4XUwJh2yDfIA3t65Uv9uLmXJJ9NozVzojRaYNH1SeQtNvKuFvmbrqd4+3dHwDeKd5T/G0hrQ6KOtreh4LbKK9dueYJ7bFh0oAKfsgS7iTwsONZKX1Ao+qyVWKcvNz
 GZL9A5SB
 6g28KF3cVe8zBz1sx1pJaifZ+Epm3W8IxnOeLHjlDadTcTGNwzW6jmPoozSchmhHY8j4QrcjAryzfhBF8MEXJfBi/htZeFD+JfFFbhEWwV6z7IErhg3xA639Ffp/xRg4XSHHbsvLedaVcF1KH/mw+Q6SxoaLC8E+JQiT2t2RD2WBMByswV6vwVMHdWzCbm/rbtwPrM9dSAyUSRMCoW0yCh8Ag7EYutUVTFUwl16u2jnyRgjLMjxP5b1LYO8lFSofbr8nXDc8QDCSNap7feWnTdymk23kLk7VTRYrbL8JLGnY4vV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
which only the classic LRU paths maintain.  MGLRU accounts its pages
through __update_lru_size(), which skips that array, so with MGLRU on the
four evictable LRU lists are always seen as empty.  The shadow node budget
(pages >> 3) then collapses to slab plus unevictable pages, and the
workingset shadow shrinker reclaims eviction tokens almost as fast as they
are created, losing thrashing protection.

lruvec_page_state_local() reads lruvec_stats->state_local instead, which
both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
race this re-exposes on cgroup v2 is closed by the follow-up patch that
redirects dying-memcg stat updates for all hierarchies.

Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index f351798e723a..85a4e14e95d5 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -693,10 +693,9 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 
 		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
-
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
-
+			pages += lruvec_page_state_local(lruvec,
+							 NR_LRU_BASE + i);
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
-- 
2.53.0


