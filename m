Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3489EC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAFC6B0092; Mon, 31 Aug 2026 05:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3CB6B0099; Mon, 31 Aug 2026 05:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFB16B009B; Mon, 31 Aug 2026 05:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3D66B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:46:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFD831C1F65
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:42 +0000 (UTC)
X-FDA: 85161085044.11.16462EA
Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	by imf24.hostedemail.com (Postfix) with ESMTP id AEFBE180005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NW4vXXiz;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788169601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXnELxIKf8pN9mK7H9Vs6VuJcv6bJ05vjHjiX65vBn4=;
	b=ZBahhi5nwR6M2sDDbEsCVxnWYJsFiJ3E897nUFrxSlO3Mz835hi3oGyFIf6tfcjzr31cl3
	3sWb9ZPa0xGEMRf2pe62RJC5k6LTz8UsuLtEqEiISxNlMrlwlxrbXDN8TTGuA0oIOOQH9t
	EDfSwq4jkz0ntju8nJvNUR6GQsgqnhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788169601;
	b=yRnEajmDERZQxr+SPZobx18xaYN444YyFC2LkSAOy3kh9i+K6I6EqQquEpLoVrTYRQbjnH
	MYmpMrvOki7IjeACnKTin4SNvGMiM75PuwAbsOSslR7JNDAZSXBdhH1HQ1yifK6yekVLpu
	WVc7jpUBoM/2kiu2ZlI7d0PONjYXQmo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NW4vXXiz;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gLq6dTRueazhtZMb/V4BL5tx3YydnlrYd+x5AgErLV0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788169599; v=1; x=1788774399;
 b=NW4vXXizt6meWPAXDM+eYSu6b9F/w+WIaLtKLgX5XWAk0osIeecEezgLzw/39BdRZZZFZTNx
 bQHuWAFtFc2OCiE21LyYQwgvDA1lYW6dzWsA9RsdyLCqK3XK6YjG1GPgfmVr0Eee4vvNNdzBydQ
 QvAZ5/RU8nvxso7X8LPOgBtQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 151bee8d5fdfa34c;
	Mon, 31 Aug 2026 09:46:39 +0000
X-Mizu-Trace-ID: 151bee8d5fdfa34c
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
Subject: [PATCH v2 1/3] mm: workingset: use lruvec_page_state_local() to count lru pages
Date: Mon, 31 Aug 2026 17:46:09 +0800
Message-ID: <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788169145.git.zhuhui@kylinos.cn>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AEFBE180005
X-Stat-Signature: e7hnjbozp4b8f5sebenmy6u6zzcctmo4
X-HE-Tag: 1788169600-535420
X-HE-Meta: U2FsdGVkX1+yx9bAAI8CDIwh7HgEpthC4mkoquQw3fUxK/886MaOfC2p46PUgAFVlTsUoSK2ucUj+OnDsjLj6+7SBGyBYCEqKic5eLyAfS0fY6775N9E3m+RHYSL6EHtd/qhI0uKMhLemmlBqHu4c6TfnDNqhbGvD4gvNlcT95TxPEvIq0CKkZ2KPZDQd03GyXqcFFUjTwM+aGu+LQeX/zaz0hSvG/LYUABh/7kBDI81m9+3DlzdtjAHK1AQ2ObyoAaXqBoSbY7jb0aPZttZvQi0wNgwXkFjEhx/AtAqU/QJf0d4C9fxflF6DUvddXS5WPQzhGjLyfi9fqTH0c50wcRwZwoek9rv70smQmMErhaQtrd3XfNaTcAlQ2YfsTPRIrv1PB51r3HX6bE26uwWbqEtcS1RmHXyfkzX8eAiqAoE4/WjyxdeMwK7SM7PU3ekPyx/PxhKEwtZOgZeOclp29PDcDxtNDmjnfgoHUenQT7969relINO4EAgVDANMv5ilW7dKPAlAMziXspmdKibXHXxNS8PPqFWeLYL7chDuoDoIPY7kK2qzTp5RAzUkTVneBDYr2609Ixv6PSuqiH3h0e/ECopl0yE4lSXSbQHxAPt4WgGrNbtiWQlUHblQ5GenaJJdMbVIyFzXzlNE3S1ER7gykEFZdIMcVEpfR+nYEO/fQmjSrOG+rQ+KB81lgizNnestqlEFPb2Zi8FAOHZLNmArSJwClvZw0RK6HnUuNlhZk4/JzLLxWXSRnUvs5FkHdhQ3RFdXmr8SS2nwJbAgQ5HQMsE1RpZdTqgVTbj55hbX9La31qfyYoD0Pqv6XxkS8LqglHV3IzoyIutKXN9fFIf/JBsCx+h0515w5lfq0KbkhAYeAC+nqGtA5GT6q9CriReEoRxGqjo2A6tlW+SHTt4NYY0u8nIesBnCKCUUU0klP/fcgoGhDvKsvqhaKmZwBxC/vIthWazcoui5Kv
 0c+aW7gB
 U8qI8AZt6UCAFkYiPV5/7bXvvWlwcnad2HMm0/EGKIATNHU7vjbD0XFoaeEaaZFn3AFv54mHXT9s/CNz6YrXzANuOo+e1Otd5exjX5Ttci6RVxttTlNacLAyM3CL+UUbccervgndPMSOAp0uWyUkcXd+jvgfBCKanaBvMUAHDTByq/BW2od6UP51nYYop37uFvHvx2VzpBiZmrhIL8/XZK9+8jmPtLmARBczZbUV2Kb3iqTlm62YjIQR3vcSTR2Uu5hR6ZTinE3jfx+FlrJsWx985gdsC0lOvCgx7eyG12hflHLw=
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


