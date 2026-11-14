Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79967606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrKapMpP
Received: by kanga.kvack.org (Postfix)
	id ECBA46B05F3; Sat, 14 Nov 2026 15:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C986B05F4; Sat, 14 Nov 2026 15:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41376B05F5; Sat, 14 Nov 2026 15:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBCC6B05F3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 192F81A03A2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:38 +0000 (UTC)
X-FDA: 85434814836.09.13C16C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 803B08000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrKapMpP;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMsf6Mo2Oliqh2qahQUMTcuFw8dO50/oLEMB2urj64g=;
	b=xFWFiByv1GfT6YShQ9BC+eptG8Ied6vcbTY6UbVKiAkCm7XoUSbXKbi+KbaKIXeObF0iWk
	G3SCg0Ir82xbaSAj17FIyAtLcHqN5cPqoGYiiVDcVMcZNmW4q1UeUe/FtXDhS44Z6AkGp1
	f/gmOxA8vl7x1KH0E0QKAVil2YsHU4Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrKapMpP;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686976;
	b=ciEA7/0nEUsiooLK+I2/vexcYm+oqp1610MzGm/QQJ7QRfWajU84bhwwHKBGOcGibMeKHF
	2oF21TnBR4JrptUHbGtDZLxsb1sYHNu2gmOuQOtgJeXQCfy3uopKzoJ3wGBtnIMQf0c0+c
	LNJvVEmtcJ81MjyINxoaNVlowc6+4nM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26FBA620BA;
	Sat, 14 Nov 2026 20:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA4A1F000C4;
	Sat, 14 Nov 2026 20:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686975;
	bh=KMsf6Mo2Oliqh2qahQUMTcuFw8dO50/oLEMB2urj64g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrKapMpP6pkOi0Fuy4QrZNWpY7WBehVmVTM50FXTiI/Ke0bvtDiGixm7H2HeACL/V
	 WjFFrZMfegaoxr9692/qNEyP587PYjLyGjE7h4dkB3UU+BRFGC4u2z7DNGo5yf6pqx
	 IyLGT/WIoTfRJCpqhZkIaJmlwZcYXGMoUKrFk0Sx1WS30a3+9kAzfhwF74s86SV9LH
	 nugw5tT7mHnEvEQXf579/nxA5evaIyblcXqTWJInVbiLQSe7ovxbqjK+KfDO/BXSG+
	 yp7KB6IDCrTXMrKm94u/8T6wikGpATZdDSQUZtXqSf/prgIetlBhgFScZZJ+MqocSs
	 07Z/i9wlz+sWQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v9 16/16] mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation
Date: Sun, 15 Nov 2026 04:08:03 +0800
Message-Id: <20261114200803.23129-17-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w11nzy8skiyd49bkcu7asth7ns9rrxh3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 803B08000A
X-HE-Tag: 1794686976-202247
X-HE-Meta: U2FsdGVkX1/GWgxBqL/KDg7TkoTTBS4GaUe3t4CKPDeHCKcOlkAVT8Q215nUqHdREuy5cebCSAYOXpBeeR9h2tmeheoDBylEAnxn1ELAmOWuKC9192DHhL4oeYyBkXNCECy3wk8iwOg/ktmdcavry/5cfE9Si/TwEkcvnotpemZ8qFtShCWxaEtlYk6vpmNkhTJEfQystExAeFegpF46LGNHL/62TaiyjxWFTWMrSAErouKeRh1E8SDzBXWHl2Bix9ofa5LjA/s5KHyQdB7rHWSrGv/vTLiuUicvGZVaoqcjs2z1gs1k8K/BpGRs/KFHfFextmlDiEe68JHbLbri+aIPkNS+h6nlhMGxLy22quhMI8avhyPpbgSg9rrRgFQ+KMFcYVq8uYYo/U+f3tac7VnU38pZBtnrp1jD+pMumvlpddOzPH7za3iIvo3aJGk2Wg0GMDAfucB9k+jHJV81QOnG2v66nRWT3Wk8Nz9IVuAgHSoY6sN9frdLSsi5DcjE0CN2nbiYsAHpSr2MYsK2VlcRpQCXDBIgJWPVhJgwJTE2kzAUPsxqn72qdZyP5NLVK8rGbsPOpzOMsggknhxExjVOsufgFKoq6qQASquFBZEc6j/TzmGOAu1te0BAV+uYxaQXDYvrPrOKmFhdEblv3Eqphq8a50K1eulWkNu7YMUv70klboSr1cO1hTJHw/u7KdIaZzVkXEEzl7G+iRz+WEfLeEJhd57rwCPwyizpt0A7aB5ZEwDiv0pDuIbsx5Ay59tCORbwdR3ekFALXrQ2MfnUpgjSfLa/TrLuaRlgabPg4KG0Uhq6yHN/T9fDeoWb2yDkZ7Gw0TpY3c6DnnUVPqew/GLYK+UKbCez1f0uEZcWJ5FaWp43m65YaMydytGQ5g7mgWRHwssGgfzlFpiomBNGBCG9Way+wqAGk7cTGBO9wYVZI11nMTDreeot1vyEFt2jNOTVNTkDuEIBmv5
 O0iEUNEY
 P878eJTCatKA5zEf1x5vbXUOZ/C/mRNMtzCiQB4pl2HkAjQjZIXniBtY2DdWa1ApUazBXzh+YtKiwFXALmzgegvQqZziO+h7nrRxRiqr0Lp5JXNCRqLT4p993bcBWxbCowvQqGkj9yMUgU4T/7/WWNozdAin5kK3Tbet3UvHV2rGiGGuoKPHCprb9BTXGFAgF/XxuBN8PjTm9Yp45AXm8atvXr83J4aioZ0H5lBCRVwnX9BNZ0SkRL/zgh/VDKdcSLH29uuvg1HlWXIujJz0uvIvnaBUuUCmSIj0UWRjS6gg4KudFROVMnnaZ6rsca+CUZ9aplk7TA2XxWh82Rd6duMGAU9OELBLYGEO41dlcbamsYcF6vw2zMIzeu9dpPxkhuovATJyktVWOiTchVz0kGdMz8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Bo Zhang <zhangbo56@xiaomi.com>

With GFP_NOIO, we cannot reclaim anon folios unless they are in
the swap cache. CLRU skips anon reclaim when the swap cache is
very low by commit 74d9aa0d8e98 ("mm: vmscan: avoid anon scanning
for GFP_NOIO with low swapcache"). Apply the same logic to MGLRU.

The new scan-budget-based mechanism makes this straightforward to
implement. Thanks also to Xiang Liu, who previously attempted to fix
this before we had the scan-budget-based model [1].

One thing worth noting is that, for GFP_NOIO allocations, the
lruvec size accounted for by lruvec_evictable_size() may be
underestimated during lru_gen_age_node(), even though we count
all zones for the min_ttl check.

As explained in the commit message, the proper solution is to
decouple the size check from min_ttl handling. We leave that
improvement to a separate patch series.

[1] https://lore.kernel.org/linux-mm/179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com/

Cc: Xiang Liu <liuxiang.277@bytedance.com>
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
---
 mm/vmscan.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9b97d23838b..4960ac012392 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -272,13 +272,6 @@ static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
 	if (!sc || (sc->gfp_mask & __GFP_IO))
 		return false;
 
-	/*
-	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
-	 * scanning type, so only apply this to the traditional LRU for now.
-	 */
-	if (lru_gen_enabled())
-		return false;
-
 	if (memcg) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -4214,6 +4207,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc
 	int type;
 	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -4221,6 +4216,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc
 	nr[LRU_GEN_FILE] = 0;
 
 	for_each_evictable_type(type, swappiness) {
+		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
+			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
 			nr[type] += lruvec_gen_size(lrugen, type, seq, max_zone);
 	}
@@ -4903,23 +4900,19 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
-	u64 anon_scan, file_scan, total;
+	u64 anon_scan, file_scan;
 	u64 anon_weight, file_weight;
 	int size_bias;
 
-	total = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
-	if (!total)
-		return;
-
-	if (swappiness <= MIN_SWAPPINESS) {
+	if (swappiness <= MIN_SWAPPINESS)
 		nr[LRU_GEN_ANON] = 0;
-		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
-		return;
-	}
 
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
+	if (swappiness == SWAPPINESS_ANON_ONLY)
 		nr[LRU_GEN_FILE] = 0;
+
+	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE]) {
 		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
+		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
 		return;
 	}
 
-- 
2.39.3 (Apple Git-146)


