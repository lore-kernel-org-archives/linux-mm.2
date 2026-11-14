Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92060606A333
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=APvIUpf9
Received: by kanga.kvack.org (Postfix)
	id 37E816B05F1; Sat, 14 Nov 2026 15:09:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356046B05F2; Sat, 14 Nov 2026 15:09:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E006B05F3; Sat, 14 Nov 2026 15:09:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E557E6B05F1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0515A030A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:27 +0000 (UTC)
X-FDA: 85434814374.14.B0BD6C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2938A20008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APvIUpf9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRcpUSkaTGFusb8WYfKLGOCKCHkeuMV1gCxvZ8tkSNI=;
	b=Sf5jex7omBTuQLig1FR7YFl/Wa66sdLg66jDu60vXN7R2YWrEi8y237C9CuzJdewTEvBNY
	CuP+HRoYVgNteb8jF69u03YY/eqFFgvKp6ALUmKRJuJZ07Np/M7FS+OJ7WSLnLoEBt2k08
	Lktc6ttlX/+C4+ViAV2cJJH1kJ6lO2M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APvIUpf9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686966;
	b=6WWx6uPsEn0PuvVu0hn7s/aym0FYPNL+NBxqZwliZ4uutTkyE/DSyH+jk16wKhdqDt7WEh
	TkNgGuZvCMWAy9y3SmKNDJb2VGk4xRfx3dhjqha0wiKDbDdlAfz3dHg4NUGaiPpj8mcVvr
	xnPfWyDXtj2XsSeY4XuXMOKuVofd9fE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B92F36148C;
	Sat, 14 Nov 2026 20:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B565D1F000CD;
	Sat, 14 Nov 2026 20:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686965;
	bh=HRcpUSkaTGFusb8WYfKLGOCKCHkeuMV1gCxvZ8tkSNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APvIUpf97hLW+cfZUgdzZ7skBUDgnzIm8VzCxMvgD7kcmjnUXN/smOJRfjlRGnkmA
	 G/JU1vC8vD/8u4ZTV4JQ92vLqhBBe3HissKpK9tLrJsPPoWeRLh0oMzsqP7N7uPqyd
	 h0aE0CCB+op1kgwibUfuroGo/Ze85w/8u3WyS6VsY0WVfelcJmb+2TzX+63lnkV0fK
	 ipQwbBuljZWpI3wuWhuICxsdWs4G2/a44mak9leZaGgMGfKKXxjcKKih1gQU3CNv40
	 /2vj0w3gqjTB0TNnwd/FdMMb4gQS0usIQY1SBBKt105rAb8ck0DtTftxKXIDJGKcYP
	 5HSZYQP/YiMMA==
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
Subject: [PATCH v9 14/16] mm/mglru: Avoid prolonged anon reclaim with swappiness=200
Date: Sun, 15 Nov 2026 04:08:01 +0800
Message-Id: <20261114200803.23129-15-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2938A20008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hfm6r86usefrusegppssxxak967b5t7k
X-HE-Tag: 1794686965-876604
X-HE-Meta: U2FsdGVkX1/Xrh1vF1M0r3V78R6j9k09FRALO8SMMpdsQPOUJPAu6/cb7NPtt2udhoHkDFYXhUvkIPfjZOInCUZ2hGAnnnoWxjJQHpnViBLUWzUWRWxmWo3XQtu19/TROoFMbN3IbuZ/1p4SKvwxsrHQdRiC11lYKYZcPL97DcrB9aXzLpWDPMBNrdHmD+ZhTkKGlZ8wEqjzVX/RmphYMHZcTxfmGw+nvvH3KSVNBHmqlqr/KakkgyyXlla45LhbVGQ+FGP1vrrmqBAQY6HK6FEWGH5YOdGS4xZMPq9HgW8rKuTIIMhixAk8+Vx7MchTnwd3nSLzvRQFGESac0B4b7QDXNvmf1Kqe1iZenGVk5KVVdMes6vxlXlo6yMYHgqyURTtbSgV+5HSghuEoTKev8bvlkOESJ0+R6Bh/TVV9GsIKqwRpvI21dwq3DLcBF4jmKSS4+yc9maoov8GXEqstDSDPOGVGie8+vsBLbMUDeyRc9jltSDalL0qLXzwpYTTWrWSTHrh7N4BK9W4DHQna6JRV2VzXN91dNhv4eyj+1kbRDcUK/uFnwjsOil5Tbep75QVgkfeGZzieSoroVG0HzoiX2zWrUtUWfSIpv4RQhoAoUFOqGPYd9u4PN19gbrBpztyEvVltxcaxNDLc2wMw0213KvMyhHZRW6z4/0kB/ksu4yd3Iz9qVILN843HINLc/gNF1FGBqRRPqbKauUbvVIO8QUdOblJH4DAdXEIOJZpm33P20ZRxHa8/oCdJdq/zADHdAFZnLVujO1AmIuE4Mr3p7Rvbfl6LlU1dmrk9+onN0OlVxY+PkWC+2ny98l9Jqz/hWrHaCL/EiXDrS7wIP/K+NPi5cDBpw3unqaoJ3l1+A25TuRQRbC2sv9K/0E4INJRIVnsGYaXF9eZZSkeBygohwBc+8dICgboqJKctfAp4fyHEdErh+9fMmXP7CsZSXI3jJerPM5n6U2SvyM
 9IJoPCb7
 nbXE5c8drU/SG1wrUgdC6xhLm54FmD/Cs+5RpeR7PJUD3nHytZy85JazW8deckZbtkWdopuojKWd3hPCF2blI2GAhZOx50Usxi2shgtPHjQdo2qgJnCsScIcbYScYUoD9F4BXlLi+c6zMoSgDuH8S+PB9OlJtbg7umtJxi73DKogUvCVcwhBIMH4ouCegOeVlJlUpsV+R+ro3kdbJapwgmMM9Qfb89oRI8r5A6x/6n3aQPtSs0Lq2FjuJ6Bd7SYq2tmcsHRJrqt+/qc4XTRfAcpGGQc2zXFTIgocYS9kH03aBFzRuQOVFK/VkgYag7av/9/L2XLXWNJupJLlhAbeRsUn56Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Gaofei Lyu <lyugaofei@xiaomi.com>

It has been observed that swappiness=200 can significantly slow down
reclaim on some machines, with some workloads running 3x slower
under MGLRU than under CLRU.

This is because swappiness=200 currently results in file_factor=0.
Give file reclaim a small factor at lower priorities, for example,
when sc->priority < DEF_PRIORITY / 2.

Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6cb905162cba..abefd91f5b95 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4898,8 +4898,8 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
  * We don't calculate the scan cost. MGLRU uses lazy promotion, which will
  * cancel the scan budget naturally.
  */
-static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
-		unsigned long total_scan, unsigned long nr[])
+static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness, unsigned long total_scan, unsigned long nr[])
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
@@ -4956,7 +4956,12 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
 	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
-	file_factor = (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_GEN_ANON] * file_weight;
+	if (swappiness == MAX_SWAPPINESS)
+		file_factor = sc->priority < AGING_PRIORITY ?
+			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
+	else
+		file_factor = (u64)(MAX_SWAPPINESS - swappiness) *
+			      refault_rate[LRU_GEN_ANON] * file_weight;
 
 	/* Cross-multiply the ratio above. */
 	anon_scan = mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + file_factor);
@@ -5144,7 +5149,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 
 	total = apply_proportional_protection(memcg, sc, total);
 	total >>= sc->priority;
-	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
+	lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5910,7 +5915,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 			return 0;
 
 		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
-		lru_gen_balance_scan(lruvec, swappiness,
+		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
 		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH, NULL))
-- 
2.39.3 (Apple Git-146)


