Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6685C53200
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 12:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE966B0093; Sun, 26 Jul 2026 08:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696846B0095; Sun, 26 Jul 2026 08:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585646B0096; Sun, 26 Jul 2026 08:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 332D26B0093
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:21:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE9F7120439
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:46 +0000 (UTC)
X-FDA: 85030839012.19.7856774
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1501010000E
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWpoUqyC;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785068505;
	b=719QOTgv9wH+pffSV2NYHjqSXDME7Ns8nlb+nRVQfb1szqlnyoajJ17TP4m9DV7YnMX8E1
	gXMDtTZgxo0/XnrK35UIDhSsPS5n3YVSr1b49dCOtFUQ21mpX3hh9X+QWU0bRSrNO8S6j7
	22EHc06hJ3zx+adGAzu0NGS9mRixckI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWpoUqyC;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785068505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIggAH7nXXHD1h8IG5wZBwSQaz/UD4riocclvIOPnZA=;
	b=6sUIJzhJaHRntnIJxQvbD0cetRWgdDUIDU4UQjcPuuvYYpVdSOYL1G/tFKz3CkoM3WVU1w
	6aEWeF18QFlJY/Ke17lrejJTELrunjoa+MZV2vDVXsgGkA6YuzOjulKQDFtnWUljQ/AOP5
	kvfkOHAdJ3ZkXqfVNWFdkJtrhx+aQvo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DB61600AB;
	Sun, 26 Jul 2026 12:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EDF1F00A3A;
	Sun, 26 Jul 2026 12:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785068504;
	bh=rIggAH7nXXHD1h8IG5wZBwSQaz/UD4riocclvIOPnZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWpoUqyCz0QtgeAdidYH8EFE1xZlvqJVHdtveFhcFBur0Bi9dygKvH0bgpDk1HY6G
	 7uea+FeAP6UU9DOVb72sNAuzHj8UHLtyBGwqh5UmR67NiVM4JdQa4PfrirUIKQov7x
	 j6hXSn5WKHYva/GGAPLyceOK0+BzrVLLUzUwMW7MDInp8Ox6ZpHGOsQ7+zCjTlM+F0
	 IvV10HObUfelf82OlVzWVNA86jIAUHUbJlownxcpojBuWzyV0c1jOid2PV1yPliXFQ
	 naSnE9a4frToBhKvVVRKxkrBs4+kuGLbySWNypDg2GDTL/cO+aSffvJZ4a2i/CIgVr
	 cXXiyCd9h1yUw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	Barry Song <baohua@kernel.org>
Subject: [RFC PATCH v2 4/5] mm: mglru: run aging when pages are severely imbalanced across gens
Date: Sun, 26 Jul 2026 20:21:22 +0800
Message-Id: <20260726122123.7614-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726122123.7614-1-baohua@kernel.org>
References: <20260726122123.7614-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: obqao1i4kz1ssehar9qkgthyjhhbz6ek
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1501010000E
X-Rspam-User: 
X-HE-Tag: 1785068504-364376
X-HE-Meta: U2FsdGVkX1/KSh1nnxEmjDo4DLUlPDlBsqPjey50qn0ERY3W77+mawa5NOz6Nm03ZkvNy6APPrRor9+seW/IJkm8UacDed8tOXXF4rvOp7xUze6f4covci3GWsU1cF3ZYmiY7xVLUsNDoJlOWHVK9T+xgb0wAciTKvKJsWFfCk+zM4uNaJva96ZO4d9N+7Yp6RQW2xm8DuFxdknfyMmQYAshFt9Vt1hdtS66Kig1HM6yOPCQBOZQwwCBY2jg0SaDwkucgx8pzqCgOjKplTi+NgvsY25B5qpAkeazef2XsyZ4Pdjip/OCwOqDFNFMPMmVGhvU+H4bPEA+t168OCStNUkJ2upNPR+yNmHDCg4IitegbiKVeO8/lRhpCVKx64fP2be+Ln5v28rIegREr6gtbQWzCnI5CQKhtFtjrsh5VcFgWF4v6cChWQH+lrIRqhPP33N03bfRBRg5z9j6NtavrQvk9x6Rqpk1jaNYHmgDJneNRZf7ox0hKT8XfTEPHYI3NqBkuaJzOtLoN94ZrwsbE6lUa2YVnrF9sBAGfM2uNxMlUeEirYCNGgrZAIBM5/decuT4m5rLhoN/2b8ZEcJn8k7wcQeH1bROQkLEFTItNx2ADBkn0ep3ZHUGUdEN7QjCtGTeQpoEXJL8gi0mnHwTr1UZ0Z7NECZfw/SnSl+/+MjjgvNcQSJUfZ4gxn9HR+3Qg+F4BGS4w6ZtuJOukrX2zjUID4+9KhbXky1FerqTVRZDBzp/WP07aLt4e5Sb6OVx45AueLk6WNsICbuChwQ1mQjtkH5LM5QbSO2Iftx/GQ6weKdNXwy4owzFdEVBJSuC2RLiYgjnORfsonDxotQjqunrEYoafRcopPMKZ0if8z6YkiF86n4Xfm9exNTxjdG2kusw25REB7przI2ZLWVlAQTtg6Ujq2tDrFKQlQoWPzyQgJUaGWTocDmf7jxiblo5j3FFK1D1Wpvfo2OFJAl
 PbfxVjRA
 jUnO6Ax2lvmjJsN5Io31ejWqm9Ax00EJbX+NYfch8AUsyIoZMhceruddVscIM3aondOtP5RKNf3l6D48+/42bh8Gwapg4Ca05KyEyTbQHAn3aM/qbgvGdN4El2ikUjUNvaiF8Ix14ePW5FOHXkDEDauxkCZI5gEmG1PmVf0v3GtrEDvtpTh+3DZoxRh0c+H820huMUMb5tyuwAzf9myNHEn3mAHbsnR+6m/QsVVD6Ak43crCcHzr4BZTMokNrd3B4nF4f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: lyugaofei <lyugaofei@xiaomi.com>

This partially restores the reclaim behavior introduced in Yu
Zhao's initial MGLRU commit, ac35a4902370 ("mm: multi-gen LRU:
minimal implementation"):
	/*
	 * It's also ideal to spread pages out evenly, i.e., 1/(MIN_NR_GENS+1)
	 * of the total number of pages for each generation. A reasonable range
	 * for this average portion is [1/MIN_NR_GENS, 1/(MIN_NR_GENS+2)]. The
	 * aging cares about the upper bound of hot pages, while the eviction
	 * cares about the lower bound of cold pages.
	 */
	if (young * MIN_NR_GENS > total)
		return true;
	if (old * (MIN_NR_GENS + 2) < total)
		return true;

But with a stricter condition: the younger generations must contain
at least four times as many folios as the older generations. This
allows aging to keep folios of the preferred type spread across the
reclaimable generations.

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d6bd64b4dced..7c13dedb0b1f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4956,9 +4956,40 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	return scanned;
 }
 
+static bool lru_gen_imbalanced(struct lruvec *lruvec, int type,
+		unsigned long max_seq, unsigned long min_seq,
+		int swappiness)
+{
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	unsigned long young = 0, old = 0, seq;
+
+	/*
+	 * reclaim is forced to a single type in those cases, so there is
+	 * no need to consider the swappiness bias
+	 */
+	if (swappiness == MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
+		return false;
+
+	for (seq = min_seq; seq <= max_seq; seq++) {
+		int gen = lru_gen_from_seq(seq);
+		unsigned long size = 0;
+		int zone;
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++)
+			size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+		if (seq + MIN_NR_GENS > max_seq)
+			young += size;
+		else
+			old += size;
+	}
+	return young > old * 4;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
+	int type = get_type_to_scan(lruvec, swappiness);
 	DEFINE_MIN_SEQ(lruvec);
 
 	/* have to run aging, since eviction is not possible anymore */
@@ -4970,7 +5001,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* Run aging if the preferred type is severely imbalanced across gens */
+	return lru_gen_imbalanced(lruvec, type, max_seq, min_seq[type], swappiness);
 }
 
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
-- 
2.39.3 (Apple Git-146)


