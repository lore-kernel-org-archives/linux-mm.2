Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B1ECCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3D36B00B2; Thu, 15 Oct 2026 14:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A556B00B5; Thu, 15 Oct 2026 14:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA146B00B2; Thu, 15 Oct 2026 14:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7102C6B00B1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE2191A0113
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:03 +0000 (UTC)
X-FDA: 85325664606.16.1E666E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C1364100005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJzwFHOT;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088161;
	b=mfLZjYc+jjGJSsnhsidafgK+24E6H07ZIvkowLwUXFVF28RYEg7kBbEm3pZycVi0YJa/mi
	wN/E/PxREcjRQOqEhU0IhtRsp2cU+cSx962l+luhAvAw1R/tllBpL9yhzpcbcogJlB5gh5
	BOzfXab6kkZf6OEts3w8uMXc1vk1m0I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJzwFHOT;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088161;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zzlhzMiepZWEEnNgDBID/bwLj9aVWvkyR2UbBq2TRQ=;
	b=jcuQAKMwio/jtzTuA9+qCmkenZFoscLqHnsC4QZYOf4JA2hdZNOjnRBpX8PILAJHeAi6Ij
	THQkK7XO6Y4MAFzc16/KPNQD9DyPJoTY33alrkoatcUKhjOjmVz71GV1qyEVw6fSdcccI0
	YkEtV46oMdAET4zm4X7SQxBWzRZqJBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5988E4480E;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A1F9C2BCF5;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088156;
	bh=bRT9KZu8UqdKr2cNHa1Z0K3O61FAuTcx+Pq/huomZeM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tJzwFHOT8zBTg8zoFzjOk6Du5AKu/DQQxp4Xq+H0Z9puNGp3isAAG1RYSWsxSZ1Ka
	 /dzmlU8W6x0kQrq5VkrdB/5ZOzEJTPU8LrKOpLVDZ80ZQI+UeYvFDxtswRKxF3SuX6
	 0d0E8ljHQrZvSZPs+dvXnPDjpoEgm+c1x4R43Tb1ayi/6CDnEf2ZGRKRIJ+wXj0eAt
	 D5JvB38Epn6iRspp61XpShT8/Fh1DpOiMDD5+I0kHXi3t+wwuginwYrsGAW6sFOR8b
	 YrejTtStE6doR81Nln2DNTr5WRlqzO8kgl4I7+75inzfeg5/etYlvNlqfawOk6GUqg
	 MD6brIBrPFJqA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BB7CCA467;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:16:03 +0800
Subject: [PATCH v4 14/17] mm/mglru: reparent folios from all generations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-14-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=1313;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pdKvbjCwV47KGicri13lBUDrCkRk2q0xdMVXETA4zbM=;
 b=k/ubaRAqYgu0d5sqic7HAzaAbUulfQUwwP8R/2btRLVmVV9Nfb3namLyzH80c0wrc7heLL/QW
 ogSO2eylyVUAj7poqU5bzgEc3/spqODjrIxSkgSteeV3MFWumHGgPBC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C1364100005
X-Stat-Signature: hsd511qqybpwwz9zbpi783jpyybk6eum
X-HE-Tag: 1792088161-598268
X-HE-Meta: U2FsdGVkX195etdU2WEnwdxsOzhAhf8z2Xbh3q9vU+4l4pFF7Ry+hkJqPIzFkiDbsg2CWnvuAduq9qan5HxZg5D7Ya5ZLr0RzjLyCRl/YNShrmP8fnchpRm06qnPJQzNk4WkbedAGUK+tDG/uDTw4JNJnBWP0DfeTGWGQ3bl5hx0U48UAhuceG5ID65SoncMPY/2r4EClEZVrmGStjY8WYMWj8+qxrBsQCq5Iua5zT321F+BwHTPukTucIpcni1LBTk4eyol5miStnE4lMKu8IIvgKfzo/uVFhawsWfNNoLBnDkvc3AF5wJikg41rvm7A/whCE5j1vSmkqv1EpGQ8mEku4WGHE/51o6dPcfm10UWEiQWvHLOpsGqDJp9c3tH2QLXHE2+uFppPMH5jjegOiYsTnyk4YAIodIWBwKaG9aMJct0dS/4uSEwa5Iz0+PtgAscT4NtMn6BhM8oMSrJd7YoUacx4k0ipqFEkFRnU+Q2kxs6MZEZAqLiro0CwFc82FgLjDEqp8kaOlq49PPItXQHPHxJMl/cSg4xqCrHOYdoHtlpzEgBMgSphOE44hBENv7M4X6Cb6ISYr0V07JvX2MONdiRBzOp3O6lnC/Uue6H62Nuk5oQFa9bBYiZK/iJ/OeK8hnQzP5l+YSd8RoZWj1vYCjqB6ZEg1GfBZUHcl9NIr3ohLf6bl2X/PNGI5k2DkyGPk6RUlQhLXHvUuXSVTyAdyUTqUB6AQ9nLjKSneSskYbEWiFT3URRYLxnaBcYkEf6qgCeDuvvUG82tu//q/qlLlIUzaLjPusVfC730pSMj1IU1IC4SgFDtq1mcDB6CbiQ2n4Yu39Lvwka9SBjQp7LkCxKFcf9q4G6fdDiVWdHxKpXNJRbGhAUxb8oBT3rXUyQ97H6squ545Hzpkkir1B1uE7AI4Z0MB7ta05dTMKZy0hC4Qpy6SZMBN3lES3jNTG2eYWgR2RqT6Yt4at
 k8zhrJYF
 KV7bDWdGwa0X03iSDGcn2DR9FXiyK7Ucb3MNHCnraeZQV267uJ60qsmBZw2itrBpMa382XVeMjRa/vMAVC8uQyOZAp4QtFyRhHweKrRZWnjU6TGvCX9P8DQXR0aRkZwBrDcXnl4PKTGXNOxuXMohXSJrliUJ22flfOw9K616N5o02voVbFwUK7ef0yt1a7znkRcxULrY914tfPvVQJl97D1BfqiVgwu2m/07lNz8bqHw5idhd3U/90/65DgX1a9lKebjyh3k9rrjRlGEqI9TjPmEzejc4nJCh6iu1teBW3vAEqrT0PiHsQMx4fdEiP6LaU5FVidc6zqLclP0szXEjOhjHUqlCQO6fylrQ2Y3FPUXlWtVj7uGJFWiiyX70Xo3sS+nSCwonmy86FnOcycJUSD4NONvTm1SkmbafwztnqAeDmqN+IJAVxKBf7j+0F0dCGV1D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

A lockless promotion racing with aging can reuse a generation index,
see folio_inc_lru_refs().  The retry repairs the folio flags, but
sort_folio() may have already moved the folio to the list of a
generation outside the [min_seq, max_seq] window.

__lru_gen_reparent_memcg() only splices the lists inside the child's
window, so such a folio would be left on a list of the dying memcg.
Splice the lists and move the counters of all MAX_NR_GENS generations
instead.  Those outside the window are empty in the common case.

Assisted-by: LLM
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 617f69c1d9f9..a9c224377234 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4936,7 +4936,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
-	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
+	/* Lockless promotion may leave folios outside the child's window */
+	for (i = 0; i < MAX_NR_GENS; i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
 		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 

-- 
2.56.0



