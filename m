Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ABEFCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF866B00AF; Fri,  1 May 2026 17:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7915B6B00B3; Fri,  1 May 2026 17:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6098A6B00B5; Fri,  1 May 2026 17:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FFB46B00AF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 178451A02C8
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:23 +0000 (UTC)
X-FDA: 84720079206.26.AFCFABC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 18FE8C000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KlNZVWzB;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669461;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlrsrZPHGQItARUAxjdW5bnSzOlWWXsw5U+SaW2qBKs=;
	b=NDfzRU0l8Hi1ExFGK7ffK50wqrbCVYMgOZLpazFfy7TSr2ema5mQGTLqVxhk2l1ZYek+CL
	rY5/s8DOnUvQgFNo9xh1lK2h2Ry5uYfiB53dWlmtifvl73HtvuaizwGZAiFUizwzNwjJ4Z
	7V2A3wyonU1tWqQnfKz0tqXwsdXdg94=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KlNZVWzB;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669461; a=rsa-sha256;
	cv=none;
	b=jX3wdD/yuyEInnXsHTgNxnsLnzQDwhRvhQxouiJ9hfbyxOr1ASCU3d0fpQje7TGLbdDgsA
	ymx6pdZFlY6DYwkkfwifST7np76myTLb7+8oMwEcbJmnVU1vXPv2UcCknky81Q61N1ettb
	oU2jKlxWigc4zqRvVr6rDLFnF6W1RUU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70E7E4457C;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52A39C2BCF6;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=lVTNcFnFgfnB5g69KkGFxL7/LFAt8CkEJCpVqbo55Qg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KlNZVWzBaixt05Wnl+6RSDBZDXM6yR7Mz1zwDfJFWU405rbH/My0xpog0FIRyEa4G
	 iURkjKqVpkU9WjegsF4LwIpWO20ARiHqX5dhX2+nnC+TII019JXnzSCHLoukVHZsgF
	 paDxZtieL2WTTbb5nbVKN0dq7iupqQtkznvlTc5a1N9MYbEfHpCkYLxkjQpp2RTgZZ
	 e0ngp3ODlzrn0TQ2dtyjWw+J1AYq/Zpuk208cRjkhKaC0Mi9mQnKthwxeZsPN6XCKv
	 Sp8p7VFPfXr0QxQplDBCBEu0AkaglrzMgt+rmam/500glY/ANm4f0EMmUJxuxkt8X7
	 XmVBOJNl6XEbw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BECCD342C;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:15 +0800
Subject: [PATCH RFC 29/32] mm/mglru: convert avg_total and avg_refaulted to
 atomic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-29-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=3247;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=hmT6vqop0NqUJUmZIf0OMLsTgQI+2TaaPPU/LnVzSzc=;
 b=g+0w/grZtdu1EfjPTqryehzK0cTREjDFDKafsOtlliKbG3uXxYucXFymfVL6KoJwofcPFE2cs
 gfKrnc8/qUECWpRaVLAaJ6HpGiIuc964Lmc3JDsXDYQuw5ArvJXTStI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18FE8C000E
X-Rspam-User: 
X-Stat-Signature: k5d4nm7tq3umbkjafwqqiy1etaurkfng
X-HE-Tag: 1777669460-714631
X-HE-Meta: U2FsdGVkX19IDPKmJxVLH/1tMeVru2sLVS+AixM/bzjP/ILgpQCPCN/De4zxsmkUCFpe2gLZEGu8kGDcf9K3QXNCcBtgZ0xNrrMiPwpDc8XGlbqg4Vm4emrqiJBJtINu8Tfhm8hCS9BvFlvDJcvcSxWaNHzCmmHhuchMHUUy7YeFlv9njLN/vz3t09P1L4KbtZn9qeL7/AWMDjmobZArhj/gtEYT9+BvfN+x8BOqUIFjBMrwMq/Bi9ewjgGlbMQZsHyC+LibPWY7kCG+xrkhHHdjKyxFTH2ZmYv3j8snJd7XMUi3eJuIekKNlcLwcSZ9R6GttZ80OyV4rFjmI+1KcTNXk7J7coNQsKcsSuajwGD4TotqZBZLLe/6tum1Brg08Byh0SRuNDWkQlk+FznUm/v0ORAQI9Wa5H69JMMLKh17h+wLaWa9d5ICt8ukFarkFqhAj7n/GpdK/Qz8UKX0KEft+FzpFECP7JeHQMOQyRDtcGNPCArohlSwz2Eia/ZdKaEWXjex04maBihMKBHvKEe1vAHb+sgKrYTPazUmaBnZTepLRRaqChsf6ysAgf0ZewCqDeUxSUHD2UExZFPDJlWGbvQ3AyrzquCOvwemdvmiCCWKKFJTzZl/c1mzCw/6Fs8wGkqagkNxBwTHSJboBbVvX3wWvCZk6B6eLuTnLqcjqCKtKhLh3jVNuDOHqylL4ctT+sszJLZ9JwUVcv6fm9x2t2la6CzwuhoDnR/ZcbWk2ExLyrYVOAkfXdZ4pnWhwEvZ6MAM4EisLEBOuzHctwncQTXAOqkJHjTzLOGC5ShJBG4jYXwhMggCQjedur9l2G+KOmHWTjzZV7qOZ8k5O/Wn9Ze1k8fzh31TtsTutvTvIC1hunUom3w8oBPhL59UY+uQWLshSDd+Qdcn2yUTj/3edf5PKf3fjp1rWhLUWZMEZb0XHjrwxIAzDmaJsP3p+3K9Gz84lrCCgs2zdDG
 D/lfhFmK
 YGS+5GoQQBwPzYBkQgOgAyjC3oqL2TcuIm4m2iQtsAAUfdn4t7rGH6HiUegPxMRZV4sBj0BmyF/n3pwAcYMdZQuylmynZ3PWC2pIHBr23nmiPOFfllWv7H1pRmOZY2PNx9iMtEp9S0cU7RZVFZUalHeQ6iqGPTUODPE/bbMhnr9E5vXqPo3s9UH5ztEUTw/ylnYqNgnb8nEpQ91X2UQJOawVAZIp02fHN02AKmBTxbiKAPTDqfUOYEHUZ0jdZnVJkpommjz9DEJzHTg6M/NclwI6B6iIECc2jvt/ie9zxB30oMAA1xndkRcV4/FbKFC3lTfLF4UVNqTX13Mq/rn9Ze/ZtRBQCcABNkM1JFD/PiLthUWzKm30d+yEuZgcDU8PiLn3aZiQ57vPuOazKIb1GwYonoX8ZUwnsWOcmcUIsM9PsOGV6P58WmStU9FH0WGTNaRx0CoJtT1FnAKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, make it possible to update these value parallelly.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mmzone.h |  4 ++--
 mm/vmscan.c            | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6747e1c6079c..aa27627b0406 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -603,9 +603,9 @@ struct lru_gen_folio {
 	/* the multi-gen LRU sizes, eventually consistent */
 	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the exponential moving average of refaulted */
-	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
+	atomic_long_t avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
 	/* the exponential moving average of evicted+protected */
-	unsigned long avg_total[ANON_AND_FILE][MAX_NR_TIERS];
+	atomic_long_t avg_total[ANON_AND_FILE][MAX_NR_TIERS];
 	/* can only be modified under the LRU lock */
 	unsigned long protected[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	/* can be modified without holding the LRU lock */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e6631ad03caa..22e77450c1b4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3140,9 +3140,9 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->refaulted = pos->total = 0;
 
 	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
-		pos->refaulted += lrugen->avg_refaulted[type][i] +
+		pos->refaulted += atomic_long_read(&lrugen->avg_refaulted[type][i]) +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
-		pos->total += lrugen->avg_total[type][i] +
+		pos->total += atomic_long_read(&lrugen->avg_total[type][i]) +
 			      lrugen->protected[hist][type][i] +
 			      atomic_long_read(&lrugen->evicted[hist][type][i]);
 	}
@@ -3166,14 +3166,14 @@ static void reset_ctrl_pos(struct lruvec *lruvec, int type, bool carryover)
 		if (carryover) {
 			unsigned long sum;
 
-			sum = lrugen->avg_refaulted[type][tier] +
+			sum = atomic_long_read(&lrugen->avg_refaulted[type][tier]) +
 			      atomic_long_read(&lrugen->refaulted[hist][type][tier]);
-			WRITE_ONCE(lrugen->avg_refaulted[type][tier], sum / 2);
+			atomic_long_set(&lrugen->avg_refaulted[type][tier], sum / 2);
 
-			sum = lrugen->avg_total[type][tier] +
+			sum = atomic_long_read(&lrugen->avg_total[type][tier]) +
 			      lrugen->protected[hist][type][tier] +
 			      atomic_long_read(&lrugen->evicted[hist][type][tier]);
-			WRITE_ONCE(lrugen->avg_total[type][tier], sum / 2);
+			atomic_long_set(&lrugen->avg_total[type][tier], sum / 2);
 		}
 
 		if (clear) {
@@ -5466,8 +5466,8 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 			if (seq == max_seq) {
 				s = "RTx";
-				n[0] = READ_ONCE(lrugen->avg_refaulted[type][tier]);
-				n[1] = READ_ONCE(lrugen->avg_total[type][tier]);
+				n[0] = atomic_long_read(&lrugen->avg_refaulted[type][tier]);
+				n[1] = atomic_long_read(&lrugen->avg_total[type][tier]);
 			} else if (seq == min_seq[type] || NR_HIST_GENS > 1) {
 				s = "rep";
 				n[0] = atomic_long_read(&lrugen->refaulted[hist][type][tier]);

-- 
2.54.0



