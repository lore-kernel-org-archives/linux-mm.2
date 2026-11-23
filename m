Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C3D606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b8PR5mMo
Received: by kanga.kvack.org (Postfix)
	id E92D86B05B8; Mon, 23 Nov 2026 13:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43B26B05B9; Mon, 23 Nov 2026 13:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5BA26B05BA; Mon, 23 Nov 2026 13:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94E726B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 198F5160857
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:25 +0000 (UTC)
X-FDA: 85467281970.12.F4B1A46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CE0CE1A0011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8PR5mMo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460003;
	b=w2Zb8U1gGRWiTFJvxbnlUhNA1NFozmEI+GnJVirEgZ2mvchQcHwPBX47/gvxYzmbEXL5JS
	+IlxCRpNXvBNcUq8rltNWFWXof43ywQhphr4PUl2uVFqVPAJzvKXMNL+mvghjvbcgOppeS
	Zu7qcGk3OBYA0gp/EVRm96kB0HcHtWk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460003;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tn3ff8YYl9RnjGLJDIERe0STPUTUXTlN6iqTakkHSLE=;
	b=VS16p310mIldb8pBhvGEa4UdHlHTHdF3Jxllxcf3kZ9yjOvTdoez/tHWwFMnnnjCYAMM8b
	cpbm2qOF4casn0uuA/FsJedcdT4nXLwMxs9+bwbeLu/gcgJvVFVKoGvPO9M5wtCf8rE5xQ
	XeBPv+b9NfEVpSo4Pdmtmh7wrzyRouw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8PR5mMo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CAD340A80;
	Mon, 23 Nov 2026 18:53:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460002;
	b=DN2mgD77pvWqbIb1K1rWzfcvHmcxlwy1DmZZU4gUXUmL7Xq6MB5tXVANoDL0KEv05ql3
	 g7CNgkECRWHCsi6QCyN4sk4zajLLqhMuG7JVx/x33hybNt8AxWljC2a7o/jL+smqK+aGY
	 Z7AqxQQ5X8Yt/nefNjIcgskqiq90uaJIHCZBptUe1TuPjDWrB5leKATzqGhpgYDnkqC8C
	 xfu+uZJegUqiJoTckBYvdg8UkH6yCxiyh5MixwDjV7s++KjCe4X+EhZ9XfwIHobazzwna
	 C9Y823xxYx5aUGGxWppH5PzACOZFKG868Z0lKVXJuCNZtPPbMZNERF1A4S2+QEFStXQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460002;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=tn3ff8YYl9RnjGLJDIERe0STPUTUXTlN6iqTakkHSLE=;
	b=Dcm2NnyZacTvw2k7rEqiw27svgJEpeK4Vj3kpoju9stUyr9VfHD62muZXv6gLp0vIbwi
	 ORs4TpOENTeQw8WoUdDTM0CcGdnwgDf07Q6ITQ91CdbZlvGSrxH+XyfAo5GJxmKcugMUO
	 c22G6zItWgLP9vhiHTWy5vfrJoeOZ8b7CrlUTK/bDi6C3JSz5JiP8jXpNXf3DQ/IgNqDy
	 A5tf/gjtX3Ffb5xgjteBPYVAwujXstGXIPuPtFXTuxzwBkriECCSQnMDYzO86pFovM1Eh
	 ZgydnGZtXVmeadrM47hlaRO+bE4LgT8ez0OSYRk9Wckc/s9abKaRaIbVUXBweQQ+aRA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D6A501F000F0;
	Mon, 23 Nov 2026 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460001;
	bh=tn3ff8YYl9RnjGLJDIERe0STPUTUXTlN6iqTakkHSLE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=b8PR5mMoYI+X0/SjA8UMJJBWtBXi3wZZVxkZBt9zCYY9ME8Em1uUPKt1hd0gaJUnv
	 Ob1sSvzESQOmUx1VgoQ5jrzGVEBK5DrmCGt8LTuPIKg73g7/9QmLeCX/aTVZnYJ9B2
	 NYCtPONxetW2vWDIORuSTtdSYz32yRl+PIYO0Yfbcl4j+I+euKH1We+CiXO2M9tzia
	 HnHHI1fCxA3L4sMh+YAErS3axLDyLg2j+E6BFqMoEKpRTtRdo5jUF2Ciyc6NK+LcUz
	 1hWYOpujsDGpWPujgOQgXA6tTUxuAaAjM/ubstW89VO3uaHvmT5gk88MVGmI5PZi8L
	 KH5BqFwj5xutg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7B3194C639;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:56 +0800
Subject: [PATCH v6 04/18] mm/mglru: make generation page counters atomic
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=5768;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Vglaw21Vm4r80ayuV/+BBbtCvB3+vEXOhf7b40sCexI=;
 b=Ck9hVXdiDJT21PdrgJnuB2unk1HBDNmb2YyAjDOuLd2atdc8hN1vUvyXwNsOsOO7KJ3r1Cb1r
 ETM8FJPd4GWDmWtXv1L7n8ZosAWgDSifBU53dGsNoO+QuUZwuS3t+Kv
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: w3pibgmi4jdobzm7i8d3opt1xfs5h3ng
X-Rspamd-Queue-Id: CE0CE1A0011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795460002-387152
X-HE-Meta: U2FsdGVkX19Po3U5hY3FoNvYY20dRxJs64hIIImJOBxHaVKGsdL44dlIwKAFzyLkBRCkKDbWj/a/sajc4vPhSux7VUTGkR3N9HQTOOWuTk31VuyA4F5wXmmkEEJ0MLsQTHGkl9OTYACAuhmDE25DGCxj6phzOWULQ/0USsSCXAN1L8Qm6XtFKbuVgzIesXHgAie3Z+/2eDiAZhDZ18UirdwnddsnJJLKyXDWeuUyHyRNKaNYUdHnwfIJpUnLPRRB2hFZKxQVki9ziHlVtefzm9wflSh+kz60be0ptMtiJ5MoXl4n+4CIjG4vjXKzxFW5NtxzoLt+2Cq/Hj+hViB4UC6j+f1Si+zekR4Bto6kCNZXobxJN3EaKfDU2iuCwHSVzVoiOYibPrk8ZH+oITYtq5KqsrBZbDOabrDBWznFVqN9snrHxLEKUqCzanKm/hK9AU7Aismjqj+CGhpBeOkSVk3v+QVeSklzQT9EPuWH4i9f8PRrQ09IpGM/S6aCR+d5uVYGhgQSOtDuVpI2orN6z9vmlDkAv0LPk5BkgFs055P63NTK2ieSI01g4PxwhECNOnddi8YwB3DBICZxj6+8UakYf2A9xLksekoh6Ty6IUMUJBlZUNW6zGN5a8Lg07fxQOYjEaUan0AInYpZ30CqBXHfMujpwwF0z8VGuHTeJ11HWnzgMSElljcqpXV06fy+TC7IvrnDXOpUnhzJvUkHnqL/pL1Jx9OhV6Y3RjaWC1dQy794z/ovzFDQQCoYCO3t/6QB260rWS1ZcXnt86qwMcJ88moWssqOgLX4XY7/6SKNLuK7a1CsHLG5+3UJ/UJYwtbZtU5cVI/sVtvxC/GKdqaL4JNJJN6UZM7Ghe+2IAzxdB5F4+ti62anWdjX4up4DpRkBFNGMpFCd+cgKMH7bUdSQ+RXqQGG9cNp4IYJ6+5pezOs7F9bKZTIpcpDLA1+4JSy+nyZiSUnDREdL7m
 2pmv69mE
 cyWeWctecQ66dlEtNrrzfxqwIACaKjp7Iw32gNZoeDLl7tZP1WjiibxV9S3cDejo9BQxDASAPUGVB9FdYte8Ec09fWFw+hXPkK+h3gp0gKl8PevISx3FgihSGyvbLB0J5OBej6/NpEzcEpKeTvd8boDbNPhFzKQhQcRt+vZDRmfvGnYWXFvdil6R3bpzFsV3zDPbtZ5lufnVVNp/Ixg2zfAkGlWyWGzSMbn8w5yuECvFxs1cfnjFMna3v6t8/ARds1mb//zmnZos6EmOtDxADSfuPyGbU8DSaRsergaA4TwQaFpCwtLyqnyEevqi5xr7ZdQB9cZnEIlpOiR5mPtpGnXA33tsq36fAqV26zq45sQ20b1H8Ibi151lWzys+wM/QJr+27v1aaXfFB4WvEicqLVIUpJluuKXnQeyHC4wObnobxqz0Aovbe4DdZM7dx8tVk7q1IhJMbD+/TPMgTCqRTvcQD9zJH04o1g2ohtzylWZVRFXBjLabYrXG3U7InE+tOtIiPN6tfd+lxhqGYVDD6pbtasB7aDKmAN+shVAuagoHftvmdyku+xHAqgYVhLdYVjCxcSLxpWj+ew4d2B8HwxvstHYWkC0JkOzmxluFg2lzM0lxXK9ribqDW9duBGDq1Ksxcqc3a380kYpN7mk8H+wIDnDHT4bzncMpmlRTQa8JYWwOK879OmLHvLu4SNYdb7z27LNzQIAJunaOE7TkYGEIR2B/4CMFqqHb0qjR83itnzxG8TJyig3aoB8Z+KtpgHJ0ZCEkN8ve6eRamh27m7N8hFTRA2WgcpdulIdVydOrjd7I26a3xUZd+wGPz42GGEo6Buj9s23VfnRxaZ2djHI7BKJ0vhhDKC26gw0f+entzFMx4gWDowZ9wTbOawzzFMA9Dqq2GcSqArbUrSbcyEfsvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

No feature change, convert them to atomic so we can update them without
holding the LRU lock. A temporary underflow is fine: readers clamp a
negative value to zero, and the counters only need to be eventually
consistent.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h |  6 ++----
 include/linux/mmzone.h    |  2 +-
 mm/vmscan.c               | 26 +++++++++++++-------------
 mm/vmscan.h               |  2 +-
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 2edb9beef6d3..46beded51c7d 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -265,11 +265,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(old_gen == -1 && new_gen == -1);
 
 	if (old_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
 	if (new_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
-			   lrugen->nr_pages[new_gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
 	/* addition */
 	if (old_gen < 0) {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a2ad0cff795..4e85bb520f76 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -554,7 +554,7 @@ struct lru_gen_folio {
 	/* the multi-gen LRU lists, lazily sorted on eviction */
 	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the multi-gen LRU sizes, eventually consistent */
-	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the exponential moving average of refaulted */
 	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
 	/* the exponential moving average of evicted+protected */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc7579d47f9b..202e0f874b23 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3350,8 +3350,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			continue;
 
 		walk->nr_pages[gen][type][zone] = 0;
-		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
-			   lrugen->nr_pages[gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(lruvec, gen))
 			lru += LRU_ACTIVE;
@@ -3971,11 +3970,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 				break;
 		}
 		flush_lru_batch(head, &batch_end, target_list);
-
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
-		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
-			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
+		atomic_long_add(delta, &lrugen->nr_pages[target_gen][type][zone]);
 		if (!remaining)
 			return false;
 	}
@@ -4093,8 +4089,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			enum lru_list lru = type * LRU_INACTIVE_FILE;
-			long delta = lrugen->nr_pages[prev][type][zone] -
-				     lrugen->nr_pages[next][type][zone];
+			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
+				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
 
 			if (!delta)
 				continue;
@@ -4625,8 +4621,13 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
+	/*
+	 * The child is offline and the lockless updaters, which hold
+	 * rcu_read_lock() over the update, avoid racing with reparenting,
+	 * so the read/set/add operations below are safe.
+	 */
 	for (gen = 0; gen < MAX_NR_GENS; gen++) {
-		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
@@ -4634,9 +4635,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
 				      &parent_lrugen->folios[gen][type][zone]);
 
-		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
-		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
+		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
 			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
diff --git a/mm/vmscan.h b/mm/vmscan.h
index c2cea36289f3..6551f0a6691a 100644
--- a/mm/vmscan.h
+++ b/mm/vmscan.h
@@ -126,7 +126,7 @@ static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
 	unsigned long size = 0;
 
 	for (int zone = 0; zone < max_zone; zone++)
-		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+		size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]), 0L);
 
 	return size;
 }

-- 
2.56.1



