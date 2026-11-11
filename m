Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBCFA606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bPVn7yHS
Received: by kanga.kvack.org (Postfix)
	id E92EC6B05E9; Wed, 11 Nov 2026 18:27:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A2A6B05EA; Wed, 11 Nov 2026 18:27:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4A76B05EB; Wed, 11 Nov 2026 18:27:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A30A46B05E9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:27:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF1271601F7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:05 +0000 (UTC)
X-FDA: 85424426010.18.D195308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 50C2820006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bPVn7yHS;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=us1KUlLBFfnvhPfdhmbZmuJ5B8kI86ogiTrry9m5hwo=;
	b=zR5g4Kt3fp3YXs353CNN+TIK+lOJNGdqqd4906AYuxPkLSyNrx6IagfucybPCKY9xqlAr+
	flU3hzscP+N1BxxZ/udxTLo3V4ejYktEv1epG1JMWh0fUonbZv/tU4d3jYbGGGqYO23BN+
	4vvL8k8XimcGLRsu+6SVyo9bq9pt8yo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439624;
	b=JIJGDOxsMgmPEwR5a0XAmLfNK4UbA/TzNFF/4WS+3ssz292+HSykF1DwYcYpLslVRFDspe
	A7rasDeQ0d4JBi3e3i4FmG8zHGbrZ3WMOXHCDvGmJHgK914659MjITSLRxGJxj1XbndALm
	xJe8FmCI2psheD3Xb3d2arJfs5eithY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bPVn7yHS;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98FCE41A3A;
	Wed, 11 Nov 2026 23:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98731F00A07;
	Wed, 11 Nov 2026 23:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439623;
	bh=us1KUlLBFfnvhPfdhmbZmuJ5B8kI86ogiTrry9m5hwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPVn7yHSXV2r9bHDFbwmTou4LvhfPtRUTJDhSqOQ3g5pWqvY6tTuajMcr0UNcRXEF
	 IW7YHWNA6S0/LPOJOu/GaKU97ZLvdSlZvtBuOTxsQBpfovw5kRV3/iV8qDT9rM5LGM
	 r4WBh+D1rdPLK5dyLMkfwV5oUy8PUnjj5oI1z90ypFGcPsildFk1+SeK4cNhPaqvTn
	 6oHRWRKnYfMooPZ7/7x9MZx6X3dmXc4TqTcznQyrmG53aIr8MH/uOm2CODfz/5nYdy
	 NJADOlKfbyAsYsFFMWQOnzXzuyBrsXqBYGvoS0b7ubM3vep80K0jz8V9V7sjnVblv+
	 iCzgc3gwPkLYQ==
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
Subject: [PATCH v7 10/16] mm/mglru: Run aging when pages are rare outside the youngest gen
Date: Thu, 12 Nov 2026 07:25:57 +0800
Message-Id: <20261111232603.9934-11-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u1j9edo65635813cz33sgiitnk4iwmsk
X-Rspamd-Queue-Id: 50C2820006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439624-646702
X-HE-Meta: U2FsdGVkX19ufIew2QiJKg2KChTxE3rs56HdrqGs1U8P4ibAyh9XMe6FdeF4ljnukAIUTuQOAfqQ9uzfK7U/QCdNjN6K7q4Rf5MFUiW+srWsz+ocs66z0tGUK4iHgYOEuh9Ge76MuK0jth3f8J20k3475Op/Hk3VDvvl2CChoaTTvLtG5ItLXxCeuiPvq82SnKuV9B3zEXvf/mGSiv+l3KiLTzp0bllaogCnGgtU6+ycGDlH+XYXXtdKwSia/JsagoVwXsmTwKYW4BhSdCxXZ4NUj4PlEXzoAI4enLVKqrNIvz+qWi06B/dhJsVoSN5hRtGpEt2/Eyknpsjhp0+A/E9EuXE8vrJnhfm1Wo6FEfuliqbBAZ+SQDUBBuutgcEqSX4vnbkNLfzwr1q7Ohf0Ue4JFLSqAy+OW7nGloZOG4jgcAJk5xqLOt+vYd9z7yBr4ZuHBmwqlsEUWrYEm069ZDLGz8IeJgVHYZb6Y7Iv/N+O3RuSJKd4BpBJAWB0sgDHkmdtwQlS92mTlGnclHY2rZhJpR6jXG7kTjE3Z+jqCY/Bzmdh9JE5wXwuMyVdLCzmTnrwfRKPqaojVbbegAMUPplvTSeMBoWkUuRrIpFSFv1NU2wgK8JeirSuEhLr+p74E5YgP2QQHgz34BJhBYYivwLRP5HTo9YX2kGtnjDrCIv2o1+IVYgFAgB9JvaskmOazqcsHHSM0JKcOtE+9eji6xKu4e/Haz/ox0de13Wr5SC+8H2RuJSwG8SFmIUpNz2T1WVQ0ABQtW7m9NGLeRTIOxusL/kWNJNDRH66G2MdvSN1U67Rv85DIZjFGeyktz4+i9qSYdQVA4QszD4iY6B6Y8nLtbZDP6eNmhjVHu+9mCqRojkzDDa/L/luHE4U1Ek+Da4EQnJI1bguc9aoCPMDj2nuYsOp7nLzoFhoGn8741UarUVamxiKdbPStdxnGtuNBdqiGnR0Z/sjohepWwC
 iRYj/2Qx
 NtPIsdOYa+SNGUlkgktJjcFpAZEz4BqHIN6yCFeRhIU1sY8K17GasRnlreny1jPD+cx1vJjxXhOrUCOfst3v89R7ZAWyONOoBfVTXaycq4TN/qd13QSYcKniReW4rM3Fn1XniFbpcL9HjKSIfB81cg+PEArpGGSY9dwntz+A7PlUndDo2zDI9wZqIVDmlMGj1bURzXDoKMH2DnXswgxMMIPSXoxBddj2x/g8uq6agOApknqyGRfGfAa8W4Ii67F+ipMkZ8xDeoXPolLLSjMOArOp5nntKjHLl5PtuiQNC56lPaIf5i7Mp2lYrgQB/KXescoj4qJ12PnEZRV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: lyugaofei <lyugaofei@xiaomi.com>

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

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c5c4d6418d46..bf30c5b95478 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5068,6 +5068,41 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
+	if (sc->priority > DEF_PRIORITY / 2)
+		return false;
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
+	if (youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
+	    (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS)
+		return true;
+
+	/* Swappiness extremes: the corresponding type matters */
+	if (swappiness == MIN_SWAPPINESS + 1)
+		return youngest[LRU_GEN_FILE] > old[LRU_GEN_FILE] * MAX_NR_GENS;
+
+	if (swappiness == MAX_SWAPPINESS)
+		return youngest[LRU_GEN_ANON] > old[LRU_GEN_ANON] * MAX_NR_GENS;
+
+	return false;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
@@ -5082,7 +5117,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
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
2.34.1


