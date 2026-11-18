Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DBC60A6F74
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2q4Bdvq
Received: by kanga.kvack.org (Postfix)
	id 563566B05B9; Wed, 18 Nov 2026 16:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A406B05BA; Wed, 18 Nov 2026 16:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB306B05BB; Wed, 18 Nov 2026 16:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 004266B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:03:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F55C808D0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:51 +0000 (UTC)
X-FDA: 85449466662.30.356520D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 435D740006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y2q4Bdvq;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035829;
	b=SJLJPtnxJQJsHxRZ07G+4aNFiOcegSuLMnk4lg7OBCh91mXIMZYc5yhwF76kaZI2R3R+/4
	XqTSHgasVS3s2cjLwsuxtjA/RGQKBFqnV2VAYZOmGIW1tRKea99t9YDQLyuU7p3ARcBlRo
	bfx7KnEYHPBwLVvMC2lhRk9yuiDdpEc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035829;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrAIa7L3TPpYcGyoo7swmURvfjB++pEN9thqNCcvUe4=;
	b=2zIB4LDcX3rxrLZ7eYzKn0iZuG2RHhRy9klNRHaiDBcqi+1Mj4/oSfRBwROV6IaFZFC6cr
	nwZ+EmIlxI2DLju9ZsvEXXsU6JxDOAipLgek/NtTKQT7Pwya0d0yBRCbkhKPI4rHp8RW8h
	qctiegmX9oTByY+KRXt5NKLiQhjhIVI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y2q4Bdvq;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FFD5462C3;
	Wed, 18 Nov 2026 21:03:48 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035828;
	b=a2GHQnVJHxktDRTaWzvK+nVMt07Trp7ZArQGuiC7RQB5bjqcVYWZG5XQ1cdV9903TXOB
	 NZoi0GfsFk7+pCM7c2ZYio7iCO0SWH9+3z/1qpBc3Tr+J3pLqzdZKzbC+e71YhHuIpLYs
	 UlbUCHBdrIjrE1RNzCwTGIhwx9lQfW8E5EDNTz1a2Dk3iVGzUkV5xKNSvJG4R14oT/H0q
	 lQaqegZ96/LmkjYY/HM2/nRuz79Z4Jz+2vP32IyUFLyVzEv4bMc1K+F5zDlwlKBTA8W6o
	 AO5jOq8ErkOR+Dx9/qpHqwmRbA77+Svna/OwpH3kYtYpXm14fqi8Feizx0oxHBmeFag==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035828;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=nrAIa7L3TPpYcGyoo7swmURvfjB++pEN9thqNCcvUe4=;
	b=vbQLP3VZ73CDmitfwTruQbKStDbkVzLr/FHqWVV/SrEkZWFAJbuRDzAT/RHNF/hYgo7x
	 kNArejaR3FVNdfYF1jlX1+ydcVlalHxbzYljwba9YwMPWVA3fOtXcWW7c52B0+UoRU3MG
	 MEkZG5vSOj2XSfWsDyc7shg/nX1zwcVU+rN159kqtpntxJFaXhXAYkLZ3yXg997agSX7i
	 s6rsAJGW/4S3OU4Gh9hltbO9dqU6HdhyFtAr5LOPetIVQnemHdJnNau3WeZn+UrFaC6/v
	 wB+ZSXylDhOOeFZUZpAkHKLtHpXt+jHxCGwbWend+h79i0cG0NoKXcekyLevkeRoeTQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EB9441F000C8;
	Wed, 18 Nov 2026 21:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035828;
	bh=nrAIa7L3TPpYcGyoo7swmURvfjB++pEN9thqNCcvUe4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Y2q4BdvqW0QNbWCV2EHNKkUul0KaiGCIExyFxdiLyisbtcOS+WLgurUJqiyKHyQJF
	 pDB3kTasN+MkUZpaSviE3+Wm8F7n2YezLZw8EP9JGnMMQrDtxodIMsySL2mNECpVNU
	 b3g7EMYA+XGS2U2NGbURH4PwUzFASHw9A88MF644dQzI4nd63btmSlzPzcdOtxg9HG
	 5yzshWfel0y64mk9xroF4c74BNFGGxFd78W/KevBvJCbx9FZsU0aha8dKVDqdKMg4k
	 ySRhqTmqn1zP5OIaj0yr+qpEYAM+rxrWTascwvFgxvSH6TMdAKAmi9HN1fAJLstW/e
	 hyoyTLD1Hf6uw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 620D94AF90;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:35 +0800
Subject: [PATCH v5 03/17] mm/mglru: make generation page counters atomic
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=5575;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=TDKkyOXacD8p0+c9vn3qY/1PAeUMnDBoLa5Oc6386Uc=;
 b=2EC1zlwGCYfSgMrWDtAJD+ridlWBFeFPEfIDM+QyTWb7dxJ27oUdhpXn3CGJ+C62Q+3FBXqk/
 /V+JMlVJCScBSDhWsUGEkw0xOvvbdBjqBsifAC9k0VlXVFDzKYHMBpX
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 435D740006
X-Stat-Signature: 5tcter5t8u8su45865i9rhx39e6p4o4j
X-HE-Tag: 1795035829-580488
X-HE-Meta: U2FsdGVkX1/GKbVbDlAp65pSxJPUHxCWWeRrp+z+EQUsdHpcAiP9orboQKdlL6+aQXdQQXVifRgbgALnYVzPRz8djuy5cEJHlSOm1yY7K1cKlKV078Jz4fR9H8Gs6jHN+WN26m6Pnjmj1tW98X9iqhGxD88ha9jerQQluhBDk9wYaapkde0Ika6MrnV/lwA3KmBGCzbcLBxCBWEWGvwQ4NCTMKvWy4POsiWbM07+EqG33NPTlMeXOEvrAevNE6ML4nnveL2ZZCZUAUUwn1B9EZOx2tTa2wP3SOKJkdLyvEEZu1iw5sx3CxWud7KE7r9hgbo+VXt147Q0NM5ogm5ShfJzXCaIw8kZWv9b90VhF5HEzb1cdfUYfHGViC+RWFMU4KomjNjCkoV/4lBCbPYu5fyHLAMM+A/5jObjasZmMXt763vPnpWO25lxy9HYTKfvS8f60O7j7fa8EMn3cxI9PuONdC/btamUdTSAabef7SU/AUCmrWBd8ec9nFHmjJlOS/FxgjpBfjR3SMA3iJGpSLetRPVYZyvLhPsz0HGQwyIdIYaWmOT7vTKoNkhFyx04KD4WpmybdFG1qlkteIFPLVIaLkU9mZIESLbnPOrZdS1m7rle0VzOEuMAlzSdhWb9KLWsRP3+p4rNaadrug/1qytbQjFEGL58m0eWv3eBcm+l5K/rN8Bhv+IbZyVDM8dHPSyLNYlC1a63CXthdfKVu9a4sZE0hSaFat0JbQgJTmc66R4Z2bpCtJqZLQrwj7nctBPQtZbXIohK6zLp0wcx2JCMW2Q7eaGTrv1nuicOe54RTuNk6170n8pxnzY4on4tNJUdF4Ge/lUIQQj3HNNM2HD0NSh24J9UywFjm8XTbmxz5G6PVBuR0I/PYR+O+432bbGZ9oE0L0FbPoHCobbtUHyNbN26c8HEUxIPmJoYcllsnGSudLXbxxVqP7l4/AYAfVgnyaiOPCRvGKAbL3j
 sdlEJ7ot
 6GIaWr1JlIO8oyeYn0kfZuHxexRs3tYCellnmCMELNcAvqJ+Fhl9I/0PXOeXUfQnQRPoRuiykVLuGSfwFhxmFC3LbBN8E7p09NUwSnEIRNXxOP4JLvFlBmDlAODdddSi8BFlj/7no+cdZAgLAKooiF5Ab3WWe6dC+J34YU1D2gTMjU11pjn01kTDHyorXTu+BPp+buF8VVrQ6H9/IcsNQ+ckXO3Pwr0Gj0aMPI02+k9NmdWfMXuagwooU328Ixu4+HUnf41UiO+5yDj+5kYUEOWkhPCFHX6ijb14j2ODVIdpV66uKO9MKb2f2b/H1S3NToymtL60VGC3vKSytMaaOobV8wvyT5Q0Dp6Ho0dKShdkJKm7hGPOUPTIai4CVnIDnYUlpyQms9AJfWCwa18y4whtJCllZoylVHHxIQlkuZ561UtEVq8zmVsuIN3pSzQM+ATk5HxMFOyIv6h8/Nq8/TFl/efBTNfGCTxNBSGvVDaUdIAeYXdt4OkiTYHbRvQXwkxQlpxm9wF4adayEnDfP7lnW7OXr2gFDWF0nHjpKZV2BOyHuklvqHGNkGGCih6Gqjbz+2bPjRfyZ2XlVW+Yhk/kdMUIJAg2BHd8k2PoB54BoMjOLfkVrohsf0xlmj+hUJ3qR4afKMSDIyamhW5eeZGh9stBQBZyUHCUDpY8zm+Hck0iAn1+5S61xbdq0JRCcjtxzOkXVNnObwpqBpF9mWJtJtA==
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
index c161d563ce8f..4c4aad95b0b6 100644
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
index fe1fe1439c7c..8d14831cdf83 100644
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



