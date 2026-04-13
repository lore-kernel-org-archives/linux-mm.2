Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E4BF34C51
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B886B0092; Mon, 13 Apr 2026 09:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C356B0093; Mon, 13 Apr 2026 09:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BD56B0095; Mon, 13 Apr 2026 09:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC236B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:09:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04D7F138FC9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:09:40 +0000 (UTC)
X-FDA: 84653564562.19.3C4EDE5
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A08340012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:09:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lnA+3OeA;
	spf=pass (imf11.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776085779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nzm5Y59GccoLKoaxA20w0qhFW7WhAUyMbCaScju2noo=;
	b=NK23WRa0c1243WMDvxJ83x35Y59ayV0agsTdfZnLeqZXSsO0dV5UQgRXVnq+VC8/P1VRN1
	jfbVZE0gIZFvyOybhhqnKjDamaxjdXtMMTkM8OeYB69BqnnyG6qH7w2dM9rYJWCo/Wog+G
	AMKHTQgi9y5dcXkJWZI9X3L2pcuoN08=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lnA+3OeA;
	spf=pass (imf11.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776085779; a=rsa-sha256;
	cv=none;
	b=2rnfT9LsPUiiy9GWSPr4GOjqsc5vjbpFGBazo7tzSHEFnj/7uwyjyXK4GPxKJnYr4vwKMp
	SauuR8UYRlszaMxbUaoqYe1I/hd1IpAULEtVV1/lS7MynM20zi1cPleqE4ZPh1Qnz0AP7H
	YTjrcLP1L+wLluAdTshDcpWfFmBTn8I=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c76bde70ec9so1682083a12.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776085778; x=1776690578; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nzm5Y59GccoLKoaxA20w0qhFW7WhAUyMbCaScju2noo=;
        b=lnA+3OeApyeJWORYHPpl0+0RuBEIUHBbjz8fZc2h7qdUkxOvcgeTx+mDpR5Z3e8sCp
         pgzaRbM5Q2nSoAqmeiyelqYnKxnV1cwbN7EdBBIHNXtaXRVr9LJP8zNLBKD6j6kzE2Kn
         P0VXjYEHtKD1Vz7mZRGHWFsHHbsvek684SPxV6maLji5Sx6IT/mChU4yzKICxj+OGUJq
         KcpHFNVoUYXYYq392ji560CUIVC0KFI4qLxPrzbVLS7SpvsIcDx56HMJ4i2BiljkN3mY
         rzQaYFVYsImZJ0u659arDwys8AO0j41UYLUJnqFkU9uhbUNt19Y20ttNi7w+i8EeOP6f
         M0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776085778; x=1776690578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nzm5Y59GccoLKoaxA20w0qhFW7WhAUyMbCaScju2noo=;
        b=qkwE9bLmV77WPucYEkWRpcudGPE4BMB1kWOa8enyT9+Tmpo007CTIvDgXt3bnu9lVW
         sQniymTcVNVLdcvv52NA0JZhXfk87YC0/ED86uUyJkLOnQ5Xl9crWQ/MlYgqSmS8hwwM
         VwERUhgu6+3cIH4SNWf3kL3OlAcb9o4AmxSj+J8sA5utMRFhuHOatGZ+yu4R6qcnVk6Q
         NwljL6Gg/k9nSDKNl624dSmSiZYyyUro5SGxZO/9JKJBWz+tvCji5WfgCrpxxKqGd68n
         il7NtRoymkEeEP2G+SibFBGLvXu5n/+0Yc9EfKt7D8MM5NjAnDwFYTxR24ogw9l9N3w+
         HOHg==
X-Forwarded-Encrypted: i=1; AFNElJ8CuiwD1azCJYLigtlKpoEfAoToLtpjZTLHtYxoBNX/qlgG2TLYSA+uAL24goDcXCBls1VqdS33sg==@kvack.org
X-Gm-Message-State: AOJu0Ywa4czMFE06LonQhWj8xtnJI7d7iGvTT8AZVEz6GEquopEvb7LC
	TvOg1EK7epFOLbTRobURsqHNd/1nq69iVapb+qQjk79vCXBqoAuTic1w
X-Gm-Gg: AeBDies6YVg0IeMH5hPhwjO23Xfxpovy0bCGWR9ZRNj5QqTzRv8cD8wH4IWxRqLM4hm
	nmUQ4JvSCPaqa5SwgwKopwQNTSQgW68fCkI/vMOB0m1qUmeUL06M7WS4x6BaOcWtRy6aCLxHK2m
	atbfAe5nop0H6chaeqHVRY7MddEIJlBLMc5Uji2p/eJ8cEUGy8ZL5r6VO50tDV+ZoADuLzziV2l
	jxSKI2Xf6KLIQOZh4BzATnxPUAnelvNdvbuYmSIpeauoZT77Lh0efLepB2ozktTrcRe3fHPcMFZ
	MCffM1ai7dYbMulZy9QJVotrwzfpp0cXuuEYfUS1Bb2Toxeq9TG82vcXOGcZiEnt3mF9ugAFsEm
	jwNZ1m8IKtRFceWXGJGKjjwlLxjbhXpy1y7Kh3cYWEHjYnK9b008bdaXZLUVflVW1cXBPml7qXI
	IA06p2w6h/Xyj8Vb9QBXx6G+xL//SYX97h6l0JIKddX4+2
X-Received: by 2002:a17:902:6acb:b0:2b0:5520:f497 with SMTP id d9443c01a7336-2b2d591ddc8mr100858455ad.9.1776085777837;
        Mon, 13 Apr 2026 06:09:37 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.18.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4ddb742sm119475395ad.27.2026.04.13.06.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 06:09:37 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sunny Patel <nueralspacetech@gmail.com>
Subject: [PATCH] mm/migrate_device: fix double unlock and remove dead code
Date: Mon, 13 Apr 2026 18:39:23 +0530
Message-ID: <20260413130927.13263-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A08340012
X-Stat-Signature: j7o69163p459xqxig5wbq7zyftj965db
X-Rspam-User: 
X-HE-Tag: 1776085778-723498
X-HE-Meta: U2FsdGVkX18+IwmyL38UT/yio+I8j+Oud7PWdiJOy4pLewQt9eqVLZtcqULxSj6t67aSwPHLyWkwmeG3zhKm2z5EhIgyr9dPLbfJqMBqNmG/ETK1GfsKa7mvGM/izqWWgVXTj3VCzvfNFa0A7CCm6ftlfHxBlTUJFXMCLhchAMrCxfpwRFyyoFlCNGA46LyqZOMBmpMumadOAWU4dd85AEcEgchiiJZdrT00CIp+uXBdrtfzODWG3xhh9o2K+B2+2zxUq1yG1DikLSKKk6nrLmZuUpkN3B4pgFefLvPe27iXIzOobvcv+M3SAti13N8kErNr8efp9U1uZ53n0yLUIg6+3zUjJWWQFi+fkyHUj9SbzQ2kccc0ng8jfa/hr6U0657X1sOWqcHRSDkt7NA6cnueBif/BFwiz4E1GCcmdHH0aUyZtpv7PFJo2b02hhXO5Lh8IfVEDWK3FGVCWyzxh7BQ9mxwwpD8C5jnMAooUj47/5rzkf/P/R/qzBesML4MyoJtS3x/WEBRBPNlRadRchuAzWE27ucl08ObYwEHDB0Qidw5CRb0ztlKb4HP77elil6O2syoxjtr4esv3uKNDYJbZdd2d7Am5hAv3xkq4JGvwr0Cnc6Gpeac2uR06Z2BaqypD9GRWQCPpjxfthSm2QtMBKj6BjZPXnFNcgZcJgmC30DZuv1NmqLadQm9Egx+Vdo4g7CGr8OpW0QOAKhSQ+PZBL46T1k0ZgWzDXFxQqIJpP3VoDZts+DELMmgn05BwRFQRC0XHlXfi5VngcajaTokpEMSx3SN2yPe/3SAQMf/hAXi+OgofuFJwWMEIM6WwsN8a4RGXGeNgBJRwv59L4sL3ZaB62JAmOQh/rmropu+P1iCh7FKhmYgrqra/vT5NuQAsJnkFlv3QZyCxtdGMqZChzExpDk/+8slxG76DLRO9Jsp08gFMJwe4wh5r/n6Zapx3zZItfYSkI7FYhN
 BbLov+9A
 u77xGWB8Oshn70AP/FKW2C+q7BJH0ouGkrDf7vnNlsxcOMAq2ViE+/TR2Zl3ZdSWFGw8eWLxc/nt0wk6FJT0uErimwH3e6JlgtQSIX1eZNWEEQx54iEu6pOgXAAmBL1rrd9L29TEpJe6eHw56/+N2ThkiOWyTgVNocwlr/XlgTRl1jxDiv6A9RQ1hkW590vmr+jq3OMdv/+tJHZDwBu+4zoYQsun68uSlmpUCT4DrWcNhT2aBg6GU4veQOPh7mkmPs6UYLpUwR79hrHYm2mgtBrTuuNrSSTuGVxVtJaVcLYHxQi9I7RzKyuaf6UMSgMlOa0TbdD/UhYVUa1BzAWTjSZhCu81wOgvQz44DcZApmCefnncLnal6oPvyqivRY+JcoJ9A/CtUruQ4jnx8KQCnZbdwh/+UTcSwB4KhTPEJgeYds4mZ6GkPVh6FgpuJhIvPzgbPabYST0qjUkI1aW2bhukiCpnvPopDUfJibg1FpX20ry8ogMURNC3lQtrde7bBUjnSBhKQJGYOAS4MuX1K22gYQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two bugs in device migration paths:

1) migrate_vma_collect_huge_pmd() calls spin_unlock after
   softleaf_entry_wait_on_locked(), which already releases the ptl.

2) migrate_vma_insert_huge_pmd_page() has a dead else-if branch and this
   branch is always unreachable.

Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
---
 mm/migrate_device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 8079676c8f1f..0e005c26ee88 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 
 		if (softleaf_is_migration(entry)) {
 			softleaf_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
 			return -EAGAIN;
 		}
 
@@ -869,8 +868,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		if (!is_huge_zero_pmd(*pmdp))
 			goto unlock_abort;
 		flush = true;
-	} else if (!pmd_none(*pmdp))
-		goto unlock_abort;
+	}
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
-- 
2.43.0


