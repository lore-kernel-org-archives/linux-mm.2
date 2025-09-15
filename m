Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC830CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6954D8E001B; Mon, 15 Sep 2025 15:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646368E0010; Mon, 15 Sep 2025 15:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF8E8E001B; Mon, 15 Sep 2025 15:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35C548E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D97E7140586
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:38 +0000 (UTC)
X-FDA: 83892531996.01.3F9EF2B
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id CA35240008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TZc+ROys;
	spf=pass (imf17.hostedemail.com: domain of 3g27IaAQKCM4zFx508805y.w86527EH-664Fuw4.8B0@flex--fvdl.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3g27IaAQKCM4zFx508805y.w86527EH-664Fuw4.8B0@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+/YCFUq0Yen9BegMvuM42I97kIDxgCZBi/LyO4DIQY=;
	b=1FhMWb3DBXGDX/lOzCc9CnCYrm2CY7cH7eZ8xgdP3kQ1W7TfGyjG3GsTLPf9yFfz8qEAE3
	w8iyMmGPLqdlwWAZGfeobBOIyhATIlQMBUo1amKZ6Gq5O2zAQBoUaCeHWfLjsILf447mbK
	l/yM6xvXZ8JSg5zPkJCo141aGBEQFPE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965956; a=rsa-sha256;
	cv=none;
	b=c/mJqTsDCQBV1TmJq0ORDMv1wy1GSDYV6qxA264qN+VK18TrGKwhc+JdbYO+nbLdicejcv
	qk6/LDEzm2Lc4sJ+K/zC9gTKbCzQKc5ths1aQZhZUDHGr1b8ZyH93w2ufIbtp2qGHrNcxN
	p1Fx3oDFpGPb+vUAPoh+3p6/g2XLodU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TZc+ROys;
	spf=pass (imf17.hostedemail.com: domain of 3g27IaAQKCM4zFx508805y.w86527EH-664Fuw4.8B0@flex--fvdl.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3g27IaAQKCM4zFx508805y.w86527EH-664Fuw4.8B0@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77429fb6ce4so4278929b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965956; x=1758570756; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W+/YCFUq0Yen9BegMvuM42I97kIDxgCZBi/LyO4DIQY=;
        b=TZc+ROyslgQBaZojFhxT1gq5Sn6H3IjRFRXId5e+773x+3qKPII3+YbxtWZUSN+amX
         jNscTjpcIZnvWSsDWsuKz3vShNv30QqFM1kM++A3ftWQzYUIaK3qbdZpBlnvJZC6BChi
         hvrb2J1qu/cTkDDwwCM3ZQFM6Xh4MoOM5IUruAPFSxAtw0N5R/M9D7JPkAqcS+ucaeEf
         /XpzkqIkYmUuiAged/MxOLKsuxvXFES01M7buOI0QKS6a5DqCFPRNN26HsupqQltuPen
         Y1Cdp0ERQTRtQb7ZdLqAlIRpzdG/Chp9j04osYipqVx5wAS5esvyv7sSx3tG3SH7R+p0
         gfMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965956; x=1758570756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+/YCFUq0Yen9BegMvuM42I97kIDxgCZBi/LyO4DIQY=;
        b=EiuEeLOyzRXFAriQHTDJmqNJMvcJ7V2WjQnGTk+djRsJGh+9g67ywPeXdwqUbXauAy
         G+QMZZQNTKKeK4eNMQbunPW1fKcKAV/gl2tUIC/wrNk8+WyksxU4oYRHKc9cGeniERh0
         nfeQ21khkVzDQw5QuVWbs4JfVzV1OjfoPl51+85qybNsyfI1QZPdulPF5jqsuUehX6Q8
         3QuwibZzb7A9SLRN5InaXh8wo/p2h2P1CSDt7R58oDBof4LOZjxRJuToiurC4YG592S1
         eNHL4loIgzIiABLF3SrKHlMIk+iCBhRWUUHcTpyzL0rZjGL/Dw/1vxa2f7XNGMdr4TS4
         oVOA==
X-Forwarded-Encrypted: i=1; AJvYcCXMnGCr+Bo7KntRoeHdsSodekUvS/1Yo+wv8WqlYwjxSOa3T5boO/mYQb2PJgJUUiFdaUPPoCIZQw==@kvack.org
X-Gm-Message-State: AOJu0YzKrFdpn6rF6KYx2DaDPFmNl5GLHXOSyayTXM9tyAKWZqPnu6PL
	ifyIqIDIoXXDYRRKFmp0dR0M2o4IdlsmkisGV+tKcxMgYG3kUKA7duqCFqWDIbiWeQjb/BG4Rw=
	=
X-Google-Smtp-Source: AGHT+IELU+Ic0v9pK24z6KtPtYVZqHgqvjb+y/T+z6SpzU6YQC5S9+eHZfr6wIXl6+CEbQ7nMg5OLJCk
X-Received: from pjab9.prod.google.com ([2002:a17:90a:1009:b0:32e:d02:d541])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6da9:b0:262:6310:3fb9
 with SMTP id adf61e73a8af0-26263104373mr10578957637.34.1757965955716; Mon, 15
 Sep 2025 12:52:35 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:52 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-12-fvdl@google.com>
Subject: [RFC PATCH 11/12] mm/cma: rebalance CMA when changing cma_first_limit
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CA35240008
X-Stat-Signature: fgow8gyfwyf7cx4hpn4qntfmo5z9z9do
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757965956-181207
X-HE-Meta: U2FsdGVkX1/GxexlYc+FPwCpNWHp3ylclp2n72cXFjowcQJDh+pNzzhySNv4kweCut5ND4PnMud5vk13b9Do06n46mWsbyhgv8KOiZ8F7E6yGAYe+E8FuJEDmmgvq3Hd/c6JeKYNfRY9iI+C8kNaNPhCnTrwayYZ47lweiGruBh/mLjkrVh9SsebikoKsfeoxmFm10R4X9ccvONAgZBE130LeUY4p0dhA9IjSIdK2Yrp1S4c6yyfW6Bhf+SvbJpr5zyrAHagJWSdzmUqtxO48OstJcdDxVfmWoV2q5yA23P9iQpJM46Pi7B7Eqc2TOFQmLaT1CWLtLUCIlbkhPqP6VFSGRaNKlrbptBxJkRTOj1l57HbzTPwfC3F6batHmDQcWG+xCi7tFEjJR7zCJ/OWQ96PUSsS1BY7SRSlEhprA0iENwCyqxwFT4ceV9AR0tanpqp/Mgn8e4HIJHke9AHmKNRdeKEdpxu4NhYH3Vc0VEpOnpZHLYRyWOwYVN5lrr38/xUuLYwhEv/Xk77QEC1jOR+WQqf6VWKJmBaJxAPaX88n86HJbLJ0RDxCOPam+9QnALaXoIxf1L1PQ8R8LYo5VH8cHOcRRQJA/QuyiJ13lTKrtPr+sGUFff18Xi1P5YKiMEVKRI0EOEpcOlrTe5EnU80jCEaJkqMH8fmq1J/jrrd03j1pIrZuxxP/8IWH4m9ZbkT/4svaG/AC8ww5lUY2wjHvMJWUC8dyYwBd6/pdAPymiAkw0hz+gQzbMhqjhOpjqMFWhl1A2wkdNVXsgG6s3282VVVGamfbLzaq8QOEk5C6VhmZUs2rTGJiJQWY1D77w4sNkYq+7zUkEEAn/BgyckVdgO59oTmA4QaIYPOlbAqc6jKSzaJzD57FbujnsE+1yLBpFZPDtiXDQZLffBhsCzJDqKwNQZ1lYJpMjShaukyACYRJU8Ote/SuBkGsNtXznZvk4xC3E7JXMM0yJi
 swe8CX8f
 tR9GBptSzG9j/gHR9f0IPmQ7Ru0ERtLRIuiGPJqXgw4kta/5azPmH/NiHwpvSXhZeqZCJ8jgYCnauuvbedLTYoi+RtoiwSE5km+cT0roDlg9NQ/xIR+o02i7ZsgzKwFezUD6hgkIFZXZdm20VAs5tq99ScBrnGjszUO1ZlwGDYXpz5kNblv432x/x82AtcKjCP2P5qJf6rYfit7wTpYRkc74l/YNqLfTS9lp5kUKpPIeLJlOmZ9CaCDdjYGeAgJVN3P6D4u5LcowyEQ7/d/2u9Xx/GdVA64350h+xn3Kl+EhHy4ygFYW5u2XnynWZZeTOtww8prgGql8GkUbrBmxx/Cr3FbtvEbUi8iu/N/TrUvkL33c3DjSqpym1K3YCT8z2hqXX+jQmJRltCl71NMbT+H79sbdgzqEk718qMnTpxuTTljPiT7I5OK3flwq0OHzr20dgXNm1KREdb+iiVTXxkuIR3eBJfe3fN+aFNJBpOkGMLpLEUvmn1TsOFcDUHIRZ6I4U82TAGToyKgSayZYPKNRLJfxL63bHqariC8uQWJyyRoRHeAK7Ws/NQIhFCbur6T85
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To keep things consistent, rebalance CMA when changing the
cma_first_limit sysctl.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 mm/page_alloc.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dc59aaa63ae6..da1cab63995c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6640,6 +6640,24 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
 	return ret;
 }
 
+#ifdef CONFIG_CMA
+static int cma_first_limit_sysctl_handler(const struct ctl_table *table,
+				int write, void *buffer, size_t *length,
+				loff_t *ppos)
+{
+	int ret, nid;
+
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (ret || !write)
+		return ret;
+
+	for_each_node_state(nid, N_MEMORY)
+		balance_node_cma(nid, NULL);
+
+	return 0;
+}
+#endif
+
 static const struct ctl_table page_alloc_sysctl_table[] = {
 	{
 		.procname	= "min_free_kbytes",
@@ -6723,7 +6741,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.data		= &cma_first_limit,
 		.maxlen		= sizeof(cma_first_limit),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= cma_first_limit_sysctl_handler,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
-- 
2.51.0.384.g4c02a37b29-goog


