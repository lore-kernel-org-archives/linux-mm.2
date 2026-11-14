Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E69C606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VvAVL/1R
Received: by kanga.kvack.org (Postfix)
	id CA5F16B05E7; Sat, 14 Nov 2026 15:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C565D6B05E8; Sat, 14 Nov 2026 15:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EF66B05E9; Sat, 14 Nov 2026 15:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC556B05E7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0234A0197
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:06 +0000 (UTC)
X-FDA: 85434813492.05.0EC9FA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4BE08140003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VvAVL/1R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686945;
	b=PCcWMg1O0npYSwFjpwDPq/V5Q+iwJeH1UbiqUC/fuSSFeK88dN0z0B4AmN57AxC79wnd86
	4Wv3y6+YYJ51A1smgCRicYLWadlzE8JO9bpiWobiVY07uO7ZasTdxaTsI3/3KuPvlE9PPl
	XhJzC44NalRfWaWRwAaNwb10FUtiE8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/ndpLLRDbznk6v7ZrvYi9tlyPUMaUAwwpffbug2sIM=;
	b=HArUQU3c4peR45uNwssBCbaz8ZX7w5PJDQSjy2Hk3L/7I5DFPHp2fsnNpSzIE25Zg7JFok
	B9dzvkQCEY7l4oyPAt89C8VpwJYEAyItXxe1cD6ZMlzargRS9xBXAiuH8ar4kVUUFMgQ2H
	VpmIme8znaEUtqZl4UOprTaayOVgRa4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VvAVL/1R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CC2F45BED;
	Sat, 14 Nov 2026 20:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97B11F000C7;
	Sat, 14 Nov 2026 20:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686944;
	bh=c/ndpLLRDbznk6v7ZrvYi9tlyPUMaUAwwpffbug2sIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvAVL/1RkU+XlN1/eHqWsigVeg4ge3l7d/HGr98ip/dc2LOid9j/8OxZ/QK3brEHG
	 k7C8xOYk6qzhloys2wHqy5lwapCQOBVWxltKNw175pUjJXsRDykd/ISncuY1bGJw+g
	 Ypak8HohuM0qC0BbQJSsl8sokIM5lle2f4r080wRCaFU/ezXQY68GgcPz0DRHSj/PU
	 5/iRzzOiJiyKAMeVtorlkPoZRG7W7JK3ljtFLkrEWxDg850l+c5rq7i2lBB7w2mfLn
	 xinApyKZYFRjy9xWwky8e2Nivw3TzNc+Uqz1dpoZVWRXwInlqmgv6hKtK8vZJob6UK
	 PB1TfyvM3r1Ew==
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
	Barry Song <baohua@kernel.org>
Subject: [PATCH v9 10/16] mm/mglru: Run aging when pages are rare outside the youngest gen
Date: Sun, 15 Nov 2026 04:07:57 +0800
Message-Id: <20261114200803.23129-11-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4BE08140003
X-Rspamd-Server: rspam12
X-Stat-Signature: xyje18rrnwzrf3kih3dmd6dp63qe36jz
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686945-653729
X-HE-Meta: U2FsdGVkX18mhmYhPJyVMNqrJ+Vk5zPOuPkDtenm2189Akh1OVtBHSwGXMqpgrvPNIA7AcvkIA+6i5UHWUtpd3mTuCrObM6ddcmRRkHnxUh/TAzgVFR1bW23AHc7borfufPJAXdl76r6ltMnOJlrsUmhUkF/0DMo3xmbdsmvECGi8pvgTaQZD7oCkP1qHfGDbvcEk9Ty1MrOFyJ9988nKXx3tOainQ41tb6FZ8yK1qKJ0X/4T3SLbxx53wuLHUGFNMlZEk4jr4aRS/lfJHynNAVK1cIpIkyJ34MjBaA6MorlO7thk0WHsmbvj7kr8NBs++uR7uFcvSIbDm9ocD1eqYhZXYZPhdgPIRnUKR6Nx8awWJeq1cBH/F4aDb+AvoKPSEMNV0N6AvIBJusMRrA/QBNxCsWDmoOwDLHOIfbjqVPcbc4EMQC7/AtkKc9v8+tDviBzxZye2dCLAr8D2wanLB5j0pp4mIjwarc0YbIFE4sm3K585XgLBMEdTngPII1G61VmoLEdwmoa3PvUe19bupbOBpa7PNjvFO95UlXne20R7NkKYojZhZ99tvZNG7Ip4z1jDTWFad1I7Uv9OWyG1zN9sgbCdimlnrhaS5j/BVr/qZfDqvH5xoqPkWk27fq2zNBto35qCcrBZxLyOT5QpZxOqxQO74Q2syN5iYD0II9Q2Q5w5oNRx0TfNhChVOHueYy6N/s6Jy39LQLf0iX7C0sPrJocBwYRFrNrtMJxbsLdzfT+19QYwGWV1gEhmcUwuVFRbbgyoE6XB/Wa7+w6xUVAgF90vaxuiyDW7ciLzS3Ls0e1bdvOgnt0OlwQ6694moXTBjl6n7gD8UHw7bP2EK62HXmCEq7t6Nv1fF4UksD0XYKxZFZTJQ1o28un22zDp5i3z5Rgzmnxe1Sozwy18ufnaZZ9pp1mwSoCxK5ncFDgEJPd58XsiaEnVhb50ZwyOCrXKaFREtVgqUHT5Xy
 Vas5fB4l
 aKkTWjuhLy+B2D6J3K00JvrSy3UBIagKfKXvY84+JCDKrbQX62OGfd2WoDX4pmDPxRpRmLokoPDquCYaevLcKh6ByiMaR7iDyFkSmj2xiLjyh7M8MJXIYatY7lto5hPPJy8zKHLpKMm4MFpfOaUnNdMLbBjC7ogh7mGb/eornbsA1pCYpHuePCADhHiF2YwkFqUIXCKTrzOgBwsvREaMsah+ohpcI/eGfSY14N5bknNrc7YUPmebWjm6JRuXj++ZPH42CAX6zsTkN8tlpEZ/1BlCenooqjP3WnqOssEvT4nEZbIxZNICPCzToAG5ZIW45G73C4QOttKSJRF1oapvlvvsfY+AIwHZyzCxwDFiTtZhevAbLAsq/K5qbGGGPyFfP14IbRcKZTbRj8c8gYJXaUWIVZz28gAejZ85gJDhpzm0QqiGTQd7I6maCf9cNDhfxNvc4ggXG1ze0RX4ZXSwddpKQDU7VEfa6AKwH0tBhoubhRMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Gaofei Lyu <lyugaofei@xiaomi.com>

Run aging when the total number of pages outside the youngest
generation across both types falls below 1/MAX_NR_GENS of the number
of pages in the youngest generation. For extreme swappiness values
such as 1 and 200, also consider the balance of the corresponding
type.

This improves reclaim efficiency, especially at extreme swappiness
values, while reducing system time.

To avoid the overhead of aging, we only allow imbalance-based aging
when the reclaim priority is low enough that we might reclaim the
youngest generation.

Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fef966b0a14..1450542d709c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2743,6 +2743,8 @@ static bool should_clear_pmd_young(void)
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
 
+#define AGING_PRIORITY	(DEF_PRIORITY / 2)
+
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -4780,7 +4782,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 */
 	if (sc->priority == DEF_PRIORITY)
 		seq = lrugen->max_seq - MIN_NR_GENS;
-	else if (sc->priority > DEF_PRIORITY / 2)
+	else if (sc->priority > AGING_PRIORITY)
 		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
@@ -5073,6 +5075,40 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	return scanned;
 }
 
+static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness)
+{
+	unsigned long youngest[ANON_AND_FILE] = {0}, old[ANON_AND_FILE] = {0};
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	DEFINE_MAX_SEQ(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+	int type;
+
+	if (sc->priority > AGING_PRIORITY)
+		return false;
+
+	/*
+	 * Round up or down corner swappiness, to balance the heavy biased
+	 * type better
+	 */
+	if (swappiness == MIN_SWAPPINESS + 1)
+		swappiness = MIN_SWAPPINESS;
+	else if (swappiness == MAX_SWAPPINESS)
+		swappiness = MAX_SWAPPINESS + 1;
+
+	for_each_evictable_type(type, swappiness) {
+		unsigned long seq;
+
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		for (seq = min_seq[type]; seq < max_seq; seq++)
+			old[type] += lruvec_gen_size(lrugen, type, seq);
+	}
+
+	/* the vast majority of pages sit in the youngest gen */
+	return youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
+	       (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
@@ -5087,7 +5123,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* run aging when folios outside the youngest gen are rare */
+	return lru_gen_imbalanced(lruvec, sc, swappiness);
 }
 
 static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
-- 
2.39.3 (Apple Git-146)


