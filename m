Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E385C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1996B00C1; Fri, 31 Jul 2026 04:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1931F6B00C2; Fri, 31 Jul 2026 04:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059DF6B00C3; Fri, 31 Jul 2026 04:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D98E96B00C1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:39:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F41BF1C07D3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:07 +0000 (UTC)
X-FDA: 85048421934.20.82F54F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 534DD4000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGKCawgR;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487146;
	b=ziSrBmxmENkc6qcwGb4z7Z3PCWjCFWjAAERP1VDkD5md5kSSJEzYoGUZX+YIqmCwtZ3eyV
	M28XaPWKKJSkImfLHJRDCWEYd2+IJC7qHAcRUpGV5fqh00oAdFGiVRpVdMgUsQJVOEid22
	hFSTjUAESWxWmv1nytrlFQCPlyiPr80=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGKCawgR;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1RvYFIQMTPrfL3d/VmiupnZ2Z7loXdewoH+NnJ+qiA=;
	b=grcq4X7bPq3qKSTnwnDzuiAXQkrpiTecYdL/uFhSdtsrI3rrnIa9MIBcl1B6R8Q/Yh9k/r
	4AZIc7l4Hrvr5zMytJUVLVdYVuRNXBoJuXkz8d+MoxrOaiqkvLWpfLOMX9Ic57Uk6dvwXc
	cdwVeYZdFUEgqsUDI83xWCDwGvtLGT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 606C14352E;
	Fri, 31 Jul 2026 08:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A621F00A3A;
	Fri, 31 Jul 2026 08:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487145;
	bh=l1RvYFIQMTPrfL3d/VmiupnZ2Z7loXdewoH+NnJ+qiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGKCawgRDVa9JVQhwQohtBa09MGFFkDREph4vYnF3B+JfGvStvZ0PIkk+2L+zYZI+
	 L9ZBTUCEKx9UEHkhSZrBXrg1Db0FY90P/1ohEhd/s50Q78YGgNQorq6K8oNKHZtPUI
	 E39RZeQAsP7nJ2WzIE63IzQDh6x/us8qAqKrraimS3yw84mTnyUR8sbAmhlx9XP92C
	 WHLpAAHxPod6IEYSXCYRSQu5WdcyqMGiEcwVtAzEtwLwZayVlaogdnYfuRkDdhyd/c
	 Lz38uMsMMSUUKZt4BesUUrdHvksZEKHjzo5pTCdjwmoSVKBvT0QsNHqpcVFI74pyRD
	 pkm+VKIALvOZw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	weixugc@google.com,
	yuanchu@google.com,
	chenridong@xiaomi.com,
	zhangbo56@xiaomi.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 1/6] mm: mglru: prevent min_seq[type] from pointing to an empty generation
Date: Fri, 31 Jul 2026 16:38:38 +0800
Message-Id: <20260731083843.37811-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260731083843.37811-1-baohua@kernel.org>
References: <20260731083843.37811-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 534DD4000A
X-Stat-Signature: c7i6cch3mwa8akqjpqjnf56qqmmiuhin
X-Rspam-User: 
X-HE-Tag: 1785487146-768767
X-HE-Meta: U2FsdGVkX194cBS/3F4iCfBwBCp0QjHILLeGZ1W73KSXO4aj6aDtOf6NfH6EtEBmcMC+geBu0+weuJO1HwtiNC4tNqYNKM/yFg/RpS6o5QBepF4PxQQQRAbHWii4xwCh0AWMo1odIrRa+pwXJwcHF7ZykB+DMY2MT4cOvBta2x5KPVBLC2T+NuvqN3fCsI9egX/eG3whfPw+LCBqPImwaulrrNTZdGC0REHsxGZ2dT0+WokSv7NRf5Wr0rZZCJFs87XvKjdskzFeI4XNkXI0F6jmuaF3UpB67G2UeiYjFEIjKrpGnrXeV6kYoKOFiCus/XphVVkziGYaXgr7KjlxKnXugpdsUhmKLo+kzw5yLycA/P+LsbtGx5PH55pm1vcrOCiKwV6Ut/3N/tYS+RaOyWAcu+Vp6bw8Xr0fdjoMSf3srOLZjfTKbRwAUPGCNimrQ434ws2zlfH0Z0bF7AGKI0VE+JLpdWbtZOxI9aELCVGxE5E4zup5pzxlIid1LZYB41I3iWINHEmV01f2kjHMqwU90fodXvnX6qG5ySlHuSiRX1xCDSsMGp1+wUxRzw3jb48/Ed77Lfz/YHuxriiEr19h6zN57F7y2y0F6eTI0IdWzjfIAiygtRYrWiJeqZS6gVmKJzLo5GYCxy1VvFNSPxY+GJ5/jdIR++C6s0rRNSNIGg+ixZdM9xw19XkFs0ekwXiLhYdd6hNFOhOGRj0wnjJFqhNnRlxqBPfvIll7XHqFsTsm6HStIBN2vEb6ujEk+xPMEhCP4VhQceHiA3R3tq1nNBzWiQ9D1GtpVpD0b3BifxqHkGRACDRhVu4vB/ruaPJ6TWJXmaacM2SRtIamPBqVzZrf+JBN1lmR5ars195b/fbDB0/WbTqwjqZjfKWkN71xH1Ea5N99SjtA+L0G1UWswlDBLNRyZmsBQ5oLho2jfPzR/S4F4Xw5DqGh4k//QrySC4yE/LFR4ujzTNk
 U0s+kh4H
 yAY4bMMA9Vze06TwsiI1zG75BzCrrAITXu7j4wIniCVlXraNxeHvrB0tB1x/o1tuV/YpsRA5mwR0dfw9u0H2W0LlqbETkdlFwdK7XB/zTRZ6/YiIEM1MTzS9iwaQdV4SYUfNq2fkTED2G1GlPySbxfHlL29oPLy9Fnj4qCpL6YxBv5b+RBK73b0iiywW9rG+Ado3Ns5WwX6WJzTl3ICB/NCFLWdAMOtoA5jqXOb6tdAkpG7RTbbKazq01Jxt+V/K5kOvS/Cp0oX6FU4PlFYq7qhzMBpHrsf3Z7N8Y1mTFZcGc0D0aiNZ/gJfgbC88EyfVplBkli6/TxzOE3h7wnqLyY7IXMXjw99yS7xSFUDNVOcVIjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In try_to_inc_min_seq(), min_seq[LRU_GEN_ANON] and
min_seq[LRU_GEN_FILE] can be adjusted to point to empty generations
to keep their gap within one. As a result, scan_folios() may
repeatedly scan empty generations because it assumes the min_seq
generation still contains folios. Likewise,
should_run_aging() has no way to tell that the min_seq generation
has already been drained.

This is quite confusing. I observed scan_folios() returning 0 even
though the following check in scan_folios() doesn't take effect:

        if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
                return 0;

There is no need to adjust min_seq[], since the reclaim logic already
triggers aging when the number of generations reaches
MIN_NR_GENS, and reclaim never reduces it below MIN_NR_GENS.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/mmzone.h |  6 ++----
 mm/vmscan.c            | 10 ----------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a26c8b855222..233d2006a541 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -552,10 +552,8 @@ enum {
  * The youngest generation number is stored in max_seq for both anon and file
  * types as they are aged on an equal footing. The oldest generation numbers are
  * stored in min_seq[] separately for anon and file types so that they can be
- * incremented independently. Ideally min_seq[] are kept in sync when both anon
- * and file types are evictable. However, to adapt to situations like extreme
- * swappiness, they are allowed to be out of sync by at most
- * MAX_NR_GENS-MIN_NR_GENS-1.
+ * incremented independently. For both file and anonymous memory, the minimum
+ * generation must be at least MIN_NR_GENS.
  *
  * The number of pages in each generation is eventually consistent and therefore
  * can be transiently negative when reset_batch_size() is pending.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 566c4e837c7d..ce027c271e9b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3972,16 +3972,6 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	if (!seq_inc_flag)
 		return;
 
-	/* see the comment on lru_gen_folio */
-	if (swappiness && swappiness <= MAX_SWAPPINESS) {
-		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
-
-		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
-			min_seq[LRU_GEN_ANON] = seq;
-		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)
-			min_seq[LRU_GEN_FILE] = seq;
-	}
-
 	for_each_evictable_type(type, swappiness) {
 		if (min_seq[type] <= lrugen->min_seq[type])
 			continue;
-- 
2.34.1


