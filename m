Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540C2C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 02:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503656B00A1; Thu, 20 Aug 2026 22:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2776B00A2; Thu, 20 Aug 2026 22:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37AA26B00A3; Thu, 20 Aug 2026 22:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 019936B00A1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:09:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5DE74035B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:09:39 +0000 (UTC)
X-FDA: 85123645278.12.A5026D0
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id E476F1C000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:09:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pCeq3x8t;
	spf=pass (imf21.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787278177;
	b=FImxoLRGXE3PPhsUjA505JbIdcyo0l5KIgLWBKiTc/l+Sbbw1Q705WjjqKAUe5zWWJ2iQ3
	8/VGeY+RBe8gzJox/Ofjchx80B+E/qbYttnK9q967cTxCWj4hnXxCmQQdtVwBkBjaj9UKV
	IQTYH/akc1nJ7sZ3c15lGdsmLl2UHy8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pCeq3x8t;
	spf=pass (imf21.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787278177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qoMRmye3VgHCmakzlO9WaDdH2lAKFjn5TtFxKRDccN4=;
	b=4cP6fusFPcI51bwdtyVeS9i6UXbhcaMnW8ldKW7U/UKtyfw9H7QriTu+EfLaQxlz2w+wAI
	yYrI2YWopA2h7MWkBBwQZibYfzYam9tjhsZmehxBJWJ8GmS0IiLN85tsFBDTKR5EaGh2Y6
	drisT9XSgeLZj6a0gyRgUWYFQU9TCDw=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2caea3f742bso9134635ad.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787278177; x=1787882977; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qoMRmye3VgHCmakzlO9WaDdH2lAKFjn5TtFxKRDccN4=;
        b=pCeq3x8towkV3GlfPAb+ivWrvhj4+sgG9TZgSC1QTSOhnzTMjP+I37SnEtUxMYVtQ1
         lWp0iZl/rGJwRRRmUq6WtSMXKzfDKY7wiDZWDMYeKnrPHFYjQjRzxBxW5GJUYdzJCSg2
         3RfaWjap65+grZ8afkotcpTFnx93S8wo9TKSH2++No7jTU/xJ0+OTfqvfuZ3mnCx8P6p
         +/QwV9P2oNWW+ET63OUT4o73sHy2ci+cq/UbunAzxilixpiypM92JxUmgeHTE0OSnymQ
         widQiMr2Vq6cc9vx/KxxiHiKwJB7cIlCr1WjMY/C6lTCbARIIuKnn0fHd2nXmYXwoemq
         GKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787278177; x=1787882977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qoMRmye3VgHCmakzlO9WaDdH2lAKFjn5TtFxKRDccN4=;
        b=kCmIhKaf1hby7yjrp+pGAtXbsz+0ITcwFA+xlt2EN3NRTwTTikYF3O4rVB2dcoCoKe
         et2KSGriGseQTtPLgm+BLrey5M17YxGkGCAHOa84OKfC7Jk/meOYDQyw3RA/s8n7FNWB
         3Jm/1jI3jORx/jbxjNWGaLinjsBPN9a9rl+Aij4uCdexLmCeNnvXGhCT1AeoWCk5qZsz
         jx+dqQ8JGgdEbvXvwLXwV+8R1rfRON+oPipg/ZmEyu882NS9GhuYbB273m9nykz1wQMD
         aGQibQB0Fbm5dplUDBS9jkusPA8oz4G0hE6vkDOXWmt1zQCZ4WgHq4by7M72r9c4ErNf
         /DSA==
X-Gm-Message-State: AFuF++nYitvP4csjynMSagEjtQ25MAdKcinryQnLK/XrxSvouhRt9BHa
	z9aZw5TfO1l/FgET6LmbKEZgMWiwEHARbOdNWjzOQdfYgi83coF8IQ3T
X-Gm-Gg: AR+sD11DBnxVDQ5hXZvMoOEVvS+SSMvHr6lS1uYyZf51yg3gnI/S7OT09RF671ilgzs
	s6PMzwukrXPNEcPaVa72+h+H3yJzUuaz/maQ9Hr8cIPNSo5B2uzmOplTi3juSVbB/fGNV5D1xy0
	4begNPf3ILbT5/oHW/G08scXmCUsZaDnpg3yYzWJ1TXepbpiuQFuYmNtpLQICKt4TXQfetMNpU5
	pn7FOr/jcHA2ixXEjx/JG1Ajl5B1WmKkmu4kABoGvG4cKPmrcNRgb+2weFNVPGD5+olvWFDQf6u
	5lU0PqYPWlWT01vcG+YOJsEjcA0A7y2a5vtRwQJuXMNdwSfcpGXKNpPOrqVKVN7MdNWUm0N+eXg
	zhLT4Ty1YcU6VuY//tqEs8yzl+wXsE4encv/WhaYnBgSLI+BKexgMSKGfAx5HEYIJfQm55NChr6
	kFMRkt9RBgXsuB0e3wK1IS8oNUokFoB039HqL6v6tzHlKERyEL94uJuncP6L6qwm/nlSfZs6vyE
	dvHMkOCG1LPj0XW0WDMd3o7Oco=
X-Received: by 2002:a17:903:2407:b0:2d1:1d3d:97b2 with SMTP id d9443c01a7336-2d64b1464dbmr58803515ad.11.1787278176696;
        Thu, 20 Aug 2026 19:09:36 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3cced8sm12851045ad.75.2026.08.20.19.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 19:09:26 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH v2 RESEND 2/3] mm: memblock: show all region flags in debugfs
Date: Fri, 21 Aug 2026 10:09:09 +0800
Message-Id: <20260821020910.3428585-3-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
References: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E476F1C000C
X-Rspam-User: 
X-Stat-Signature: j5zuia3hkdt78do9g11kextdxkf617er
X-Rspamd-Server: rspam06
X-HE-Tag: 1787278177-437795
X-HE-Meta: U2FsdGVkX1/GxERpA80pSCxZntA1a9/YcDUzTRMtRvgwXZ+Pw/lU4RNaRicW+oXR9fxxOYXXkHXldIY+KLseQF7AwFyqbWYLmbCrL3qQT3UjG+xPHCO4O6Qpvc2ubV0eQhY5ZjE3aJnqy6tToHy5Ifyi7Qh7pmQkEkVtbpXvGMmhH/d48mL8Tdg0qsE02ruehHRY/g00kQJSdN3d4UTPMAZaJJ3g9ktOdyiy99niChO4/1SrynLja3f19ivwwnVW713r3CZlBfYdpHNlYFwfIYP7HAw/+PUCCJwrPW870C7Egxrz2pHeYaDXg9eWbwT4P4yVMe3agDpZ02VnQUeqeqDw41a8azz5qItiFnNq5OqDDz4Lyq9dkLBmhqzvBnKXDJJPrmUKp1hXCY7zJ7cZYVDyVuxJkJhF61IDe1f+wALby0myLtpuej+zmaJzLqTovHmd15+nKK+c9tJnGscFyjWbVqbXTuH8xxt5lTctUiR7OCjIiB4crnB65JJfAM563SHIuTdc+4PvZLQIBuJsxrpIEHVcxOVjoH83DkiOjiHnvrdgxTHABNjF7s6HcCo1JTpolHAI5m/8WOUIC/wzij0zIDKuG1ck/3POFB1CcTa80JJtfgCFuq0hdkpC7m76pua6R/SBElc9S81b3FYS0aU1ScUrbD31MeQRIYsHgU2ZQPCBL6pWDoBxG3f1xhugVQyuM6+kAX9Rt7v99ALKFPd4vCdk5R6F+4bvh8w7P3+9q655elFYnpJRifGDfQilsfp0bxoUpuoAvQXA/IZXdbiaxyyNpNjgAB8EfWEtuaWtbJwJ2WMaTVczx0inI5wVao9vFrbSL0mW7HfqezMUKw2hWZCRl+PYBTbHUvw1ndz/Kw53DGfCPAZYR9dNsP+OpEZd6zIWQorBeWtY/+oDMevQkPWjXxPLtM6pVDxlgRrClsJekIMhRxwwvFrYQLMQY0yafou+M8JaeNJrCMa
 hxThXW7c
 ug2Zpn5d/Mq1kahecX2F1NAD26dkHjJ/VkmqYPutZKZex8l0thOQPZcU+aeYn83Em84NFLnNm0Ao3m0Ao1lQQjErBvb5yVhvpplA1+hvu8PP4rzdHNmvAL/xW/Q49IpBBcsZldcO9xgvbVteZjW4FkUeTb0cMjq90AIp86RfyeMZJf0wDGEf630yktH1ZZVx1UBK3ql+phqyptmGgI2I/8W8/vKZYf9uUsPKbjy+ok3AcBS6sTKb+GYz0vQj/80Jm+KekADLVGjOjkyUxIdEELOhAXxnMXYkQkEBsQJQEJeTJTUfWAW8TPU8c5aT0J5cQ7/TOGum8dzBzhI0PHV10Lvkqmsz32Ywf5eJhhkLuUChtuqZWMX8FkUFl2s3mkOtUpruYgy6eXZdyAJ9vR/Sm6RE8x4Khfsn6b4J8B/Ueu+WRIc7zvKLMKVfrJmUd3YewC6km09DXAK/16XXJu37ahKozvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Commit 493f349e38d0 ("memblock: Add flags and nid info in memblock
debugfs") made memblock_debug_show() stop after finding the first set
flag. A memblock region can carry multiple flags, so the remaining flags
are hidden from debugfs.

In particular, memory allocated for HugeTLB pages is reserved with both
MEMBLOCK_RSRV_KERN and MEMBLOCK_RSRV_HUGETLB, but debugfs only reports
RSV_KERN.

Walk all bits in the region flags and print every set flag separated by
"|". Keep walking beyond flagname[] so that a set flag without a known
name is reported as UNKNOWN rather than silently ignored.

A HugeTLB reservation is now shown as:

  RSV_KERN|RSV_HUGETLB

instead of:

  RSV_KERN

Fixes: 493f349e38d0 ("memblock: Add flags and nid info in memblock debugfs")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 mm/memblock.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index f2952d725c10..36a8d2a9378d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2895,7 +2895,9 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 	struct memblock_region *reg;
 	int i, j, nid;
 	unsigned int count = ARRAY_SIZE(flagname);
+	unsigned int flags;
 	phys_addr_t end;
+	bool first;
 
 	for (i = 0; i < type->cnt; i++) {
 		reg = &type->regions[i];
@@ -2909,16 +2911,20 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 		else
 			seq_printf(m, "%4c ", 'x');
 		if (reg->flags) {
-			for (j = 0; j < count; j++) {
-				if (reg->flags & (1U << j)) {
-					seq_printf(m, "%s\n", flagname[j]);
-					break;
-				}
+			flags = reg->flags;
+			first = true;
+			for (j = 0; flags; j++, flags >>= 1) {
+				if (!(flags & 1))
+					continue;
+				if (!first)
+					seq_putc(m, '|');
+				seq_puts(m, j < count && flagname[j] ?
+					 flagname[j] : "UNKNOWN");
+				first = false;
 			}
-			if (j == count)
-				seq_printf(m, "%s\n", "UNKNOWN");
+			seq_putc(m, '\n');
 		} else {
-			seq_printf(m, "%s\n", "NONE");
+			seq_puts(m, "NONE\n");
 		}
 	}
 	return 0;
-- 
2.25.1


