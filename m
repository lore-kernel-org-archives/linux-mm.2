Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C994CCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104148E0007; Mon, 18 Aug 2025 14:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4ED8E0001; Mon, 18 Aug 2025 14:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33FA8E0007; Mon, 18 Aug 2025 14:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC2888E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:58:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84F0B1409F0
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:58:08 +0000 (UTC)
X-FDA: 83790788256.23.1B828CB
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2E6916000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:58:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Suu9W8Ls;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755543486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BvQtJJDThEoJCIOiCG6XcyoU/U45M25uQ1iDko4lnIQ=;
	b=kL0nzAHMP0Ly75ZzeJH1wiMmJCHNc6ZRz7q0iRi9+CfvBDw91CqkjqML5G15IsOGex/1gZ
	Upxosvm7foZ275TQhkmT9P3cTJlWmAYz0tseSfn+TxpX6L0B/WZtAZuegZKlZ4fWVclZAx
	c2/xrStgByNiC/W18fJDToKZlxC4JoY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Suu9W8Ls;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755543486; a=rsa-sha256;
	cv=none;
	b=4hx2e8bxASUQQv9I+aZ6ad7uJlGTuioUMmLMyUr39+W/eR9Sha0szHMrAHtr7fc/Oz5Gxg
	P9JKKIcS5Mc0r3zVZVccqP+8yrxPOLBvH3/AoW7We17+b746RsxYIHf5g5w4ePiK4nfh/s
	Lz1bSTINU3cLI/BV3C9s7eHBAGaoEC8=
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e933f00bc9bso2155140276.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755543486; x=1756148286; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BvQtJJDThEoJCIOiCG6XcyoU/U45M25uQ1iDko4lnIQ=;
        b=Suu9W8LsLn9gtc8c3tgV6Zt0iZ6UvHI0cRy9tywmZwJKi31tkNfBbjxjmgztiNtbT6
         dHRRuJ1atpV8wRcVGggsOA6Ux5VOzaV2HSY4lFtVQTmSVY01rtOvEwkB06x4vtvqbeas
         Bu0H5L3naGvBqe0onZJb37wCATOktQj3J3qut4USfqmnXEW+BQkkMBjEI90M133qrM7i
         6lFkQ+RYcALsLO0gNRfrR+yvGkW5w8Ur8d9uiJGOBQz7pe7cXmM96C2Nh6Y4rZEXZJ3s
         j2DvBEy7XyruSZ5fVqcy17mtm5wWJnIXk8UG4A1zTye7OLohxvjfAMLdd4SFTJQEl14G
         s7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755543486; x=1756148286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BvQtJJDThEoJCIOiCG6XcyoU/U45M25uQ1iDko4lnIQ=;
        b=FzMMOMqs4EqcZITy7yEpRHrt2PN5Z9Z4pdSGhYsw5sR8FiBdXB6FoOe5mcQGaZhlN2
         knyqNPQaH3sa+B+7nzRpCelNYbZhwU0ll4TzACHIEkWhlPFWby+vl7+5Tn7rzcokV7Np
         4hCQf3JNAHlj0LO4es3JH2xOr1ezRbWTH28MYzw4Nb4R4oVPcTvwU8VRISwAQdjVHEDV
         xCUzGeP/fC4Ov9BJl6kPGk1P6w54E/uKSYRuKFd+lqlwtoggcI67DUNzwkB3KaBW3t5D
         CnEapvfvDbT7Yae5IM6cY9Hx9ocf1brAYTQXK/VM6MMEByU1KvegCdJOUYGY1+qPPkdS
         75SA==
X-Forwarded-Encrypted: i=1; AJvYcCX7dAjCPm5ZIs/WKYzxTWYRXOT/MvqhiZYtoChLdQhgaBXkbN+QkSfXPTJAm3/Qucm9ug3s99fmaA==@kvack.org
X-Gm-Message-State: AOJu0YxemkDZanXg+KYICuy5MiZSjsPn1+2HGsd6QR1oFdvJl/lCBxNR
	LEnoVKNHCARY/FfqvyBxhPUK2uhxodOlpH+qO5uFQhsPGNisHY9yihVW
X-Gm-Gg: ASbGncvYchkrPifkdFx7g4XxNcSRwAXUS0yuFX+CBDfC9OWIugAgODsuBUbXKVZJQw6
	cjdDHNpQ98lTTBjJxtRK+76ed84yyFE68Miso5HicGmgwVlP8uDwOGGq0tVb5wIwNemZQb5xyDs
	2dCdbbwbVD/T/VnpiXhZTikFo4FsaSLckrZ5A2Mv+vx6Usg8CaM5NobLeVU0SpgBr6wEzyV5Ixw
	U+KADXQMMTAfz4yJ1CIqC+ZrliPZKBwykEdsG5JlHg9Zqdj0gF4OAhFQ7V/eh3oceneN6+bQYcb
	7j0FKgKqSL2wT6bfVBoiou1F2k0grloYuwQJxBrCOkCIumaVUe3SJVncpDIaeaVMyIt1fzNvMfw
	B4aQ7YL8zKW4A1D6zXs/A7Q==
X-Google-Smtp-Source: AGHT+IGeElcrBG+Q22ismY7SZkhqWNI446WP+j5RDDU5N5dGnffzuAGQbvpuUEtBc87q6DwPwKECjQ==
X-Received: by 2002:a05:6902:6b05:b0:e93:4bbe:e0ab with SMTP id 3f1490d57ef6-e94e41f494amr607417276.30.1755543485596;
        Mon, 18 Aug 2025 11:58:05 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:50::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9348d570besm1922177276.29.2025.08.18.11.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 11:58:05 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@gogle.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Mon, 18 Aug 2025 11:58:03 -0700
Message-ID: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C2E6916000D
X-Stat-Signature: wn4fc1sgm5f5boreoss3uiuj8hysqtag
X-Rspam-User: 
X-HE-Tag: 1755543486-614972
X-HE-Meta: U2FsdGVkX18GjhlI1WJnXRuOwjZ+iPoRkRgwwdO/3FuqZur0258DJWI8imJ1TEXJoIBb7R+V5/IY20cyG0RdU06lL3201hl9FLHfV9zBpAn7bmDpYxKVLUAFiSjoc9nVQj8G3JV+kd3qPIgU3GPO3hhE75wRyAtrt9T8hz3La64h3n5FUAFWZRLuuteXAh1bCN7fwbl5lxhlyaLAiq5lfVnSiYGAUn1dxB+bCwUcPENIFQ9jTJiCl2uExRQMGmyboZwkoEIdMWrhsajE6lLxTF82RFzKWdch47NOuZuhmGvYPtarAyq2ZqRaKJHw5K9rVk3Yc4Knq0L0J7uhIOXSRCR4v6LCOZU0ED8GNpruqT+Kk/G5SJgdtuV0+wbnBiAZxNGW/JYeDllJKYpAONgfLLqURGBbRo4rxEz1oY9fjOOq35P1vSSkhlNfz9unfLjEZYpuBBqv7i6LKq/3AJXsI9BD5a1jsrnf3KHgh5Kzks5nPE3I2M8vHjVNYNAQCjrU8IBjd038X05XCg7kGbhgcclDkwTFv4NSCtrQ0mAIs/g2tr6fDO3ouwIoWT4m5e2dcUhlCGLa49X5BqJ3p+XvAQvmrf563uZPFn1QTzGp43Vt4xfKrk9g6Uai+9KJVecciNc3zS8nci+pbvEuuSVWAPkg4jLBB0wZXX4MtqQer3frhaJzv+7fikrDR34AlI7ccR6cl5h3A0ZpB2+7P9XLuohS8xqCbSBIXvvgCeF9dIsu4mRcfKjK/22P99Fwa8oMDmFZ6HDN1H0wmpaFdyOZ0feFoKSva0TyW0AtCYHte+VYSY7tlHYOzuL0Z1TLtvbieT2XFillyXOsd3nC/iFlNc2MpBkO6NwbUr0T4A/GUkCm+80HCb5Zfhrd30aP8cUd4t2H23V4XMqrOsWQ8A+rBrt3hEsnsJsNbHLryY8vVehojmg/LZhdMrzZGZfFF9U246f529rN9Fj1GlCYoSi
 pzFwllAl
 WFTrnfPVZgJwyCf/kTm++CFczRdpByxVbT7LDjY3TOLqsdRko7IveAgKOpuDXW16eAzt+3KnpWI3X4yzj0hVnzwEba4Sfequsy0RWqO5jpN2MVTkQxe0Ek6vPUZ+0uevc2GU1SaynW+fpPFZkfO/jy1hNQllVjKriI3u2RAf0JyHB3BCp/WPaE8btbsUsvrWvgISQmneDD4jvPPib9o2tsHgh4+47QA1VEpfq04xXLQNnrIW/ZT2LIaFkHu2o+HvwGXqaKnNIwLsHi9Lenqie1TVp0niSWJkKkbWFUTIq9H35yFNqAz3mOWJDDJ+HI2UdUV2C9B8/OfSbv0pok6Q3wy6N650ePss3gGYnLOFvbsWjKlNqN7A9w39C0aYscbKvVe3loEmlcfbwOBMqtUINxEpgWdu7vOuTT95cE4a4V4wCiDb2tGSmWbCuEqyY5Pea+lA71YuVBiEKlOTDkF8VYJNcV+LqL0m50szOClcVL93NUT42iHnPrzFjrDE3smY3TrpAtW4ZKhNiswh0qaBbbTWlvaJ93LihV2IAltYr5Uqpq5orQGgcTJIPz/51M+RBC0j8O0aoD5PZ5u6oFeOJ8CP/V1wzbjGrfmo8G+EbQTEoewJfUBDuyM+MsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While testing workloads with high sustained memory pressure on large machines
(1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
Further investigation showed that the lock in free_pcppages_bulk was being held
for a long time, even being held while 2k+ pages were being freed.

Instead of holding the lock for the entirety of the freeing, check to see if
the zone lock is contended every pcp->batch pages. If there is contention,
relinquish the lock so that other processors have a change to grab the lock
and perform critical work.

In our fleet, we have seen that performing batched lock freeing has led to
significantly lower rates of softlockups, while incurring relatively small
regressions (relative to the workload and relative to the variation).

The following are a few synthetic benchmarks:

Test 1: Small machine (30G RAM, 36 CPUs)

stress-ng --vm 30 --vm-bytes 1G -M -t 100
+----------------------+---------------+-----------+
|        Metric        | Variation (%) | Delta (%) |
+----------------------+---------------+-----------+
| bogo ops             |        0.0076 |   -0.0183 |
| bogo ops/s (real)    |        0.0064 |   -0.0207 |
| bogo ops/s (usr+sys) |        0.3151 |   +0.4141 |
+----------------------+---------------+-----------+

stress-ng --vm 20 --vm-bytes 3G -M -t 100
+----------------------+---------------+-----------+
|        Metric        | Variation (%) | Delta (%) |
+----------------------+---------------+-----------+
| bogo ops             |        0.0295 |   -0.0078 |
| bogo ops/s (real)    |        0.0267 |   -0.0177 |
| bogo ops/s (usr+sys) |        1.7079 |   -0.0096 |
+----------------------+---------------+-----------+

Test 2: Big machine (250G RAM, 176 CPUs)

stress-ng --vm 50 --vm-bytes 5G -M -t 100
+----------------------+---------------+-----------+
|        Metric        | Variation (%) | Delta (%) |
+----------------------+---------------+-----------+
| bogo ops             |        0.0362 |   -0.0187 |
| bogo ops/s (real)    |        0.0391 |   -0.0220 |
| bogo ops/s (usr+sys) |        2.9603 |   +1.3758 |
+----------------------+---------------+-----------+

stress-ng --vm 10 --vm-bytes 30G -M -t 100
+----------------------+---------------+-----------+
|        Metric        | Variation (%) | Delta (%) |
+----------------------+---------------+-----------+
| bogo ops             |        2.3130 |   -0.0754 |
| bogo ops/s (real)    |        3.3069 |   -0.8579 |
| bogo ops/s (usr+sys) |        4.0369 |   -1.1985 |
+----------------------+---------------+-----------+

Suggested-by: Chris Mason <clm@fb.com>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

---
 mm/page_alloc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8a84c3b5fe5..bd7a8da3e159 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1238,6 +1238,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	 * below while (list_empty(list)) loop.
 	 */
 	count = min(pcp->count, count);
+	if (!count)
+		return;
 
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
@@ -1247,6 +1249,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	while (count > 0) {
 		struct list_head *list;
 		int nr_pages;
+		int batch = min(count, pcp->batch);
 
 		/* Remove pages from lists in a round-robin fashion. */
 		do {
@@ -1267,12 +1270,22 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 
 			/* must delete to avoid corrupting pcp list */
 			list_del(&page->pcp_list);
+			batch -= nr_pages;
 			count -= nr_pages;
 			pcp->count -= nr_pages;
 
 			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
 			trace_mm_page_pcpu_drain(page, order, mt);
-		} while (count > 0 && !list_empty(list));
+		} while (batch > 0 && !list_empty(list));
+
+		/*
+		 * Prevent starving the lock for other users; every pcp->batch
+		 * pages freed, relinquish the zone lock if it is contended.
+		 */
+		if (count && spin_is_contended(&zone->lock)) {
+			spin_unlock_irqrestore(&zone->lock, flags);
+			spin_lock_irqsave(&zone->lock, flags);
+		}
 	}
 
 	spin_unlock_irqrestore(&zone->lock, flags);

base-commit: 137a6423b60fe0785aada403679d3b086bb83062
-- 
2.47.3

