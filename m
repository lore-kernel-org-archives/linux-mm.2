Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47FF60A2625
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JLi7dqh2
Received: by kanga.kvack.org (Postfix)
	id C49666B05F0; Wed, 11 Nov 2026 18:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA3B6B05F1; Wed, 11 Nov 2026 18:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10236B05F2; Wed, 11 Nov 2026 18:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91CE56B05F0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:27:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 353091A03B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:26 +0000 (UTC)
X-FDA: 85424426892.03.1E841AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98460100005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JLi7dqh2;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlKFVUc+Cq7/iu4xyn5/uvDHqyvVKC45Z+ABVWfXn4I=;
	b=Cy5WCS7G8b8xU65MDtoRgG3yXo0aHym/0aNZJKL+eAqFOO4b8hsQGBh0lWVTD/g8wlz62N
	+x7vBl/RrPkpFWDAMCUDRH90frIFwD7m2qhsh3uCDn+whBS4yJM2TSKIz5MluLwpJ9c/Q5
	ZVXAjaaTB6TrJx4SlfBYr6tnygjnWe0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439644;
	b=VzZT+BjQHE9R9O3/SGUQHzM6EtQbxB/Ar5Cns/H02pxt+FKkGnOD59cHpwnObywIGd/JX4
	1TDexHLIe1+vAS4uMEzqAEYDCA1+Z0D9mIsf1qVB+GFjoSnOtPvLzcc+0ZzJJK36Fks/T5
	dPK/CZb3ZCtGROVwKFMltl4ntLykzaM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JLi7dqh2;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AC6E63BD7;
	Wed, 11 Nov 2026 23:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3CD1F00A0B;
	Wed, 11 Nov 2026 23:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439643;
	bh=zlKFVUc+Cq7/iu4xyn5/uvDHqyvVKC45Z+ABVWfXn4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLi7dqh2JUvmWCHop4iEUWFNVgNnoLK6MUvtG2HxGhHLlK9eEjD2Ut/St51XS2ahX
	 nUwltJLf3OmxE4+hXOl8YdKOa1Q7kkG4/eTPiMgfIVgWXWXyMP3ZXU18CLMG2WDtiC
	 Sgl15FpuSMZfxH98ybz+j+yCYdsQeHjzGFOt473Q5nmHfDmKXAqLADmJ/SrzSX/INg
	 roUjPVMTyXTyuEiKDhHvuCw7ygoDiFrngZKKucD29PfF1sOy7B/6diQRoThndGm9TP
	 yXJ4gKmhkZ4kfNyXvoKeImIfNROgXEuKd1yarcBKRcRDKD16YQvGk7t56RIy6yYM2R
	 CCkUJYcX++T8w==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
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
	linux-mm@kvack.org,
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
	Barry Song <baohua@kernel.org>
Subject: [PATCH v7 14/16] mm/mglru: Avoid prolonged anon reclaim with swappiness=200
Date: Thu, 12 Nov 2026 07:26:01 +0800
Message-Id: <20261111232603.9934-15-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bbnmdbwbhjyw4hbjh91jzawdu5h859cb
X-Rspamd-Queue-Id: 98460100005
X-Rspam-User: 
X-HE-Tag: 1794439644-812802
X-HE-Meta: U2FsdGVkX18bSAWuP0Ra6+NJ9Sl8SX7wNaZPY1AgVr7emjZvQTB6/9nrzyE/Nlww09VcGUVl7a4OjPZXZbNn3C9gt5BHton+KWkKU+wCE1Wd1eMPmVIYEzkYBXfxMPJo6yNb28IXNxnX9NPot4xTNdh5qxj0LlwJQt1/0XKEpaKstB3Hk7T+JMa4MS1a/hjnZEVp0aC4sQY1L3I/tYZ1ZrSAKOeUMWH4iApnVSaJ4qno/Fq5IcpBdN0GEyQNiHYWlTR8GL8DHgxh2OHxtdKEcCsCjYMTaeYro3dbEej/XAstTMpBthgsW5HqYUggtF6ADI+LEG188crOAYwdSgxlI9TyisIWMvxhzve3hDUsjDATSqstELR+vgnj/EovjiABa6Hw8RagmOwjgBTnRhX0sYGfmAF5ZcXuZgsvWmU2UVpfxjrulBv+c2TH36rsaHdP0hxhi5D9gmw6kgc8xBFOzSTpOyKiBO11gs2znSbFDuEffIgFf3Og8yKa1LST/j6Ef9wICv1j52TUYO2B8fOt3m19deYfPYGJzOh2sB6rcC1s18MV644zornc06qr2v6EwsgOLNnXpxcpc+XV0a0qzQBlVhFoHdTa+1H9/wNCD8iyCabCPXY9lvtLV48NhAoKVbUcsKhntLXm9aBt42DI10y5dwsgjyR/94cpy5n6TrVg1qLfAFZMmmbKg5sAIlE+isO2Vy+chuJJsF5rypLIh7Bo45EzjIihWeWeIFi9IiqCG136RA9bWqUTU1mJJTrXe+L9y/WIgtuHvra36Rrm8yl9Mc5ap5URuJk7bUN9FiA4FrAGGc6lfa6Okwjg+gBz0c80r4Aucw6xR6AwsI1kTlw9Kl5q43N8u0p+eZvOGfzkJ9E49orj0b8kWnqA7urcyxL2NhP9PnU+YIZiDFSAHgkF3G3ggyaTDk/kFkVKdnhXb7yNTQTEXVD41nROXjI7av7u/ko0GqJ9YmN8Msb
 Dc8kneST
 Xoa87sWutH92emyHIvK/Obwdd4hpPjPMh7I0Z0UVIc4sg/GJ8E6RF1LlAm1N6vrR4BvfbV0zTH6G99TsERbKY249VevpyZ0vZr8KckyMqSU+dFpe+muECUQJ707mLUVHGWWNGbm+k29YGZbpUNEUEfIv84jE8rLPgnr1CyRWXsMDZo3Sn9ifExHHHBuzWGsqRPp15NG7WsFNztdXHIkCN0QnE0psH8kX+ICEHTIqGe9QEFbzE+Vcb4yMOqAsn9wZUJ2gCmnVFw08irWnUILZTIIB8ozREYxKVUC5/YBCavpmbO3M4iTrevHfbqlVpsMtvbRiJSwnki7QE0CM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: lyugaofei <lyugaofei@xiaomi.com>

It has been observed that swappiness=200 can significantly slow down
reclaim on some machines, with some workloads running 3x slower
under MGLRU than under CLRU.

This is because swappiness=200 currently results in file_factor=0.
Give file reclaim a small factor at lower priorities, for example,
when sc->priority < DEF_PRIORITY / 2.

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6315edf50376..3872305bac2a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4888,8 +4888,8 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
  * We don't calculate the scan cost, MGLRU uses lazy promotion, which will
  * cancel the scan budget natually.
  */
-static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
-		unsigned long total_scan, unsigned long nr[])
+static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness, unsigned long total_scan, unsigned long nr[])
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
@@ -4946,7 +4946,12 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
 	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
-	file_factor = (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_GEN_ANON] * file_weight;
+	if (swappiness == MAX_SWAPPINESS)
+		file_factor = sc->priority < DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
+	else
+		file_factor = (u64)(MAX_SWAPPINESS - swappiness) *
+			      refault_rate[LRU_GEN_ANON] * file_weight;
 
 	/* Cross-multiply the ratio above. */
 	anon_scan = mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + file_factor);
@@ -5143,7 +5148,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 
 	total = apply_proportional_protection(memcg, sc, total);
 	total >>= sc->priority;
-	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
+	lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5890,7 +5895,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 			return 0;
 
 		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
-		lru_gen_balance_scan(lruvec, swappiness,
+		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
 		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
-- 
2.34.1


