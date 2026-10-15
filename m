Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D29CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B306B00A4; Thu, 15 Oct 2026 14:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B6E6B00A5; Thu, 15 Oct 2026 14:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2706B00A6; Thu, 15 Oct 2026 14:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE656B00A4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:15:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF424A5327
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:58 +0000 (UTC)
X-FDA: 85325664396.26.40502F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B85FB4000D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RPK2LnRz;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088156;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73ackKXi50BeB3Raf5mt0Yfy5K8YjJOPDo2FQ8sxLEc=;
	b=UcOWmKotplRQaT2V/IdlskjPv0myLfOeq2Pbyv5oZJ5iBgwZiiy+cCQ9H1wXmYbJNcQMgL
	vaRYId90F2VS5WZd5/BAWrZ5lvKVtHCq7XVXUQ6DU2/gJBP4qWfiRjnpCkeOJ3pKoS580m
	oSJgiqPHOqz1uGaLEV4Mirv9oZtwNEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088156;
	b=knCvig3pxB3d8LCTR+k1Eby3qBdXRC5nED4/7jDSpn5gntyce4yXdfdxpl4v1qek/t7CwC
	HWRMMo+URJ6cCbHGfOcSdutocI+jwbEj8TCtrGsLgVgXEGNtX9giODEyy+P5oFwoW9NHyV
	AkM8cFBv5+3ByZSPyD5FZl06gRRFHOE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RPK2LnRz;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74CC344037;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33C02C2BCF4;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=s1/G/exW7I9C8J1Zs0aDe5W6D8qQyUMskv8ZL4vemXA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RPK2LnRzKNHqSDcsJs62+H7Q0GFWNOsx4JRA5AmCvcjFb9mCN1tkcbwxPRFKroi9p
	 KGY8XuB6hWGj5c9Xxt9uynobCYDCrZwJikOK70ttOznJ8vQXEmVYQunMSBcJP43lQA
	 F25p4YOqjIq1XnDiPGkfwSUeT74ET2WMa9QyClHBhoz+XkiVCynG2YdnncuugWxtSC
	 5RX0iJtwOKgRsF8YasB+pLKYj+pQ74Gdgs34vE7TKeJ+PmSiQiisIYIvi72pM/4JH1
	 /trL0f7DgVUYFNxKvAZ3rSYWh1M279PLNYXXyPmwJSYWB7dD1jrxwjFmf7xfmuCrJE
	 qnrHxXwpLaiZw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106D4CC6B38;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:50 +0800
Subject: [PATCH v4 01/17] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-1-2106750c0bfa@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=1134;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=WaY0YQ32toU3iWe0KThIrrS8OVU12NSfLZ8Lil6VesU=;
 b=V+guvWhaQbqmzqqbc8zI+LRwI/lXcAEz81sU0OsErjMX8doqUKgRBPVmBCb7/aGiM2I6H04mV
 ADgUv8gHB7QBgzvvNxLatOtSNL3y1wTHQ7nwuvaL7DBiAQGloBrYEdi
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: B85FB4000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9rnborw6d7aygjpqqciqkgm9i3crw88b
X-HE-Tag: 1792088156-201871
X-HE-Meta: U2FsdGVkX19H+TcDrCJXAipRx3y4QzWWP79g5N7JsqAwdh8PUVXKM1mA6pdvsZeOSpF5egRgjGcpt91goTblAxoBa3+KKoCv3sOKGEmvD9FH9D4JW4dPxVluNtqNrDj1wolkC/eySwMvcFk/tka7DkxuEsst/jcho/eiu3xF/0oHv8uoO15mjhqhSaaG37dLSKg/5Chzg/l8wE4FrQ8aoDso1EFNy0rvzHvKB9kP+G2ROl+Ykvg366GTQCEQnBPdIM8u5i4M7647hY7MiNGWsZCB5+PgQvljhP8QUiEYftt1hCgMV84OmBVPez4TuLc+8FJWiEPO9f0bHNZA55dqZ9iFR/x36kyxXO25qxg+isGxWF6KNs2S2MR8u5Nitu5E8BlDQd570cgU15MF+np0P2UPXa0mVB8ERtAHR7+8cUg9ZKI1S53J52lLYLWzlDy5qKmjkzVePM7HhHa/cNSPww5PbHVccsJ0vhf5+LlJzmtOiDfGBGeFbIz8WGZRDcKvlDK/Wk/QiFK5YFNUU+B//+1C5/MkNCggnrU9ARZOItXp6/C6JllBF/RJYtlewXuTjYNSrhf8L643S3Cd2I0bnOEpxXCAGm7L/IeXypn5vaULypEn1+kCajCWWlpGTAgktF+/nEyj+Tt/xr0/rUIP27tap7ePDxGN222OtIOBOf6KuTI61YqzaUZPXIobdyhhGTvf0YTWZ04kT3JT8QdBNh4RJURvvlGurpVStVbONaWRr3mRZrALssZPFGoNwXZs6CotRLqQc8/oZ2m2Wg/BwT/g4TA+Ck5QgOnFCRYoqeBbjE5uT7DVAjrooe7JcQcuP5NJvZIzbGb9eW5RLonEZa0WBrpUPynAt88rJdvYLtp9ZoD3kATY7Sqdhj1pKHxNLOtluNAgxPIc/Ymt4CER+swXt+5cvMUhWqyjTVqUpjb3FkDARqTSBR8Z5JAGIo5F1LIR4QKPxLT0m2ezDuu
 QR+3MCGP
 T5s4sqksOrgd5Pdc4LM4GgpTnA2rShebRuN3c79QosG4O2xcHIl9VK+SFRM2zfLYax72U4yR9KyHHtagtR1q/4DYWyCekkMtZaqitrBAjIjK2nHrEW2giyaaALb8imOzjn79OgiB2QvU1vvJzYissc+xnEAVAbMWCxQz12lNuUroAufUPzWCXTAbr9AaMZl+UuoL4NyZ/U5YgvFiXVWWSYPjG27b8jLDUXm4/npsTjngHfcJe5d3zDMrnghtBAgh/jUdct7jXoxnI2/hd8Kr0gxIX49v42m9r17sBdk7kNutjSbpu1ocerlQfKMxQYYxguevKS9Q/6StOMlN7YhCM/aM9Z3Xx0UsZ+nL/TO4Uz75Qk5HxF/5w7e+LXKZKd8J1H4UDK2RhR5Yne/O52wsgmOmu3hwNjtDA/M1y5u3MlBJXejzJh89KM/e2ZWOPAQ3mhsE6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To enable moving file pages in folio_mark_accessed directly and lazily
for MGLRU, allow updating the LRU statistic atomically without holding a
lock. It may cause temporary counter underflow, which should be fine as
we still follow final consistency of the counter, and it only serves as
a estimated metrics, a little inaccuracy has no visible effect.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..597f013c8e04 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -47,11 +47,10 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
 	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
-	__mod_zone_page_state(&pgdat->node_zones[zid],
+	mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 

-- 
2.56.0



