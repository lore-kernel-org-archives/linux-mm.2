Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D59CD5E374
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36356B0099; Tue, 16 Dec 2025 09:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E356B009B; Tue, 16 Dec 2025 09:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20CC6B009D; Tue, 16 Dec 2025 09:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF65E6B0099
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:27:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DD811A040E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:27:59 +0000 (UTC)
X-FDA: 84225563478.28.4406B58
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id BEDE8A001A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:27:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Io9WpD5T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765895277; a=rsa-sha256;
	cv=none;
	b=hENGM+dVlExoguzTItcV9QCVrtzN75ma46nq4EulxpLc3/VyYQCjezydvsmubrKyJ8QCHR
	KBGe1s+CxAmlFYNrs7bc5qdvgGoSAG/a/ftavkf5uSXpOisAbliFXtJA2i0OL6fX7/6kQY
	FBSNpK/xVJXZQP6YeO2Qis3hmuRbYX4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Io9WpD5T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765895277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dfdC9zwoly3se4fqy2xxy3vdEF9ng9Mfmwel5Y1hgAA=;
	b=uzgFb2IaHhr+7774gtoxZ3kri9qgz26Hf8RiMHoPPWjzULWBQ2b3EpF+s3aDKODCUX5tCL
	zQ+VouAuWo6cUZT/NK8MyH01LT0ZTtO1sAnax1ayqvvihcDm6G2cv41SLkMm117gD7Cs02
	aQhJzurJzcMS5f1O0e49DyHkiYbzW6o=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78d60c6cc17so35480687b3.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765895277; x=1766500077; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dfdC9zwoly3se4fqy2xxy3vdEF9ng9Mfmwel5Y1hgAA=;
        b=Io9WpD5To72lhCuiWk95+MKhlEEUA0axB1iPWNkjdrX5SUeqCj273NAVosVho02ocm
         fjaFNgoNFVS0KrEhEd7alE2kmaZPRzDk5x1CMuGWAodAJ16qEpF3vYBJgm/48pMmU6zW
         td5PKl0GFqhETWDJvpg19oFMX/12ztVgwR4590TF+KD17u3Iq6TA17awSjtkIqDJyDzW
         HJifTgn2si16wz+BY/wUKMxtQYE+OHiVoUgDkEU0yD5cm77T5GK4SIjpWS2xtaQwLX48
         F6SZa5NIsWgEFKnyPVuAsgju+bULmluBTKhBtfx0Nj3DUfrAf00UFV6alCG6SMVB23UI
         DfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765895277; x=1766500077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfdC9zwoly3se4fqy2xxy3vdEF9ng9Mfmwel5Y1hgAA=;
        b=Tmd/x9ejzUpcDX91JkydtPKEiPtLTDDc60/HKOG/KT6rXT9avu5ZrxAIo02ZWeNA0/
         EC69TYlFNY+Qw9cyin/ZnDbUU8+lqtfT/VE2vNdQGppDXBFWMwjysXMhvXlrE1DCHKPd
         NS5ohPDwtILPipa8htMQES9rO4Ey9VF8VA5/KhH0ioPjLWQEQM4stegoVbUKBPSJzotf
         HBVAMZQiHLcUkyIsafntkvIZFFADPHMFKJcJszdd4bmzLg76rGU8vkMSjGjcMWNF21I0
         2ydnMoTx/XLk+wUZVwsjz4BozkJmOmUFFOjJHYBcgNYAVUFFCMNU3ZkV+AS7Se9tvxTQ
         YeJg==
X-Forwarded-Encrypted: i=1; AJvYcCVWokwvXUE2u6/QAenrdDggeytKKzB2W+lFWfV5JbQBHyjsEWL5sTb93JBkTv9yA1h5NONiD16TKw==@kvack.org
X-Gm-Message-State: AOJu0YybEC5SCqP2Xe5J41C/+8TYHMJWjZsMLvEalUCo3wiTbOWZ347h
	9Kiz/alXycfxqontb1YWu6ZTAu977W6xBdcr202ZJpd+YCJlF+uNckiA
X-Gm-Gg: AY/fxX72p4xvDl1N+O26sTTPLZwZrnXgjcRFKWuiAo2kjVOdCo0Vz5iaQqU7EWn8b+E
	TkbAXtvdXIeImpKtvZeilwOMLmYFc5EIZXx5UWW/PfYfA4I+3MnhrRSMBiq3wYCExSJ+RjIFWq8
	JRgz1ztWOhKHoWcmCr7zJXBmTJ+J73E+38LywmRHPsN7YeEdq7amh1arWa+nyfEtEpNOMpAH5Up
	2bq2S0YRl5SHKEsJON6kMZyhCpBEZednIAbcyJeCmgcZNvPo8bQ3sP8A/lgz6/+DLpe+T9w4O3p
	kLcg6X1oVBLa/a0e7m4xTMcVWLzukjzctSXVoFub6BnwcpLMZBF1xnwjjUyP6V+gWkGu2e1ugPx
	GF2YmFnOYTAP9bQQOWJIMbGVZ1KR8u92LmIV2eYZYOLKwDtImxrCMS6+o4fYmXHfFn11lHs1wNb
	EL7P8s/UXPKF9wIqlKW0gq
X-Google-Smtp-Source: AGHT+IFg02Hi0WbPNj8mzUVcXOn/4YdaH1RRdSY/tPIv17mjHuSRtc0P1tlO9ub9ILAZR6ig88y/cQ==
X-Received: by 2002:a05:690e:1206:b0:63f:9979:2f9e with SMTP id 956f58d0204a3-645555cdb95mr12262586d50.17.1765895276401;
        Tue, 16 Dec 2025 06:27:56 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:6::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64477dc673asm7751945d50.25.2025.12.16.06.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 06:27:55 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Palmer <daniel@0x0f.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3] mm/page_alloc: prevent reporting pcp->batch = 0
Date: Tue, 16 Dec 2025 06:27:53 -0800
Message-ID: <20251216142755.2857688-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BEDE8A001A
X-Stat-Signature: j8no11sc1pkabjr17iec484fxji8xyat
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765895277-136154
X-HE-Meta: U2FsdGVkX1++rQW/jr6Unw1f4UJAMSco5icOF2LJYXC7pNIG6nTfQcjQqrdZGVienx1y6JrmnlO/HX260lkGlq1B2VEex1nQ6I672xEtRO7Y0LepzU1qlRWaZ8l3g9WGAp/BDk7K49+pC4Tkehig3MOfM3Tuc4YxGo5ueD0UB4w/Or/9NLSe8lAily505SN1LWnvemvOhFJ3phTHuxhvlipiYBegBbHMnE3McxXYKq44R9Rskp51Oc/VHqAubp+YxQDqIV1bK1wRyZaKzGCaen+dGBJkv5mup/+uU/bUmMgRLWOC88PJTj5z2V3DIDNiD1SREUU9w70q/yZsG3qWEZgV7oV3tllPMz7SL3pujoZorYny1GH7RUQU9asrS3EJLCLBDdc+LvYHu3E3DRk4E438hEQZK14OiZazQG+V53Yj8Ri5PsOkbqJgUcQf+2i/lryKMk8dpXQcLtXqokoCQsK3pe0Xmo/o7xkQ5Ja8nkV7PSDcsbHu3yzE5Y/8uqafVJNxclUIO1CTAb+iV74psEIpPIdJ/a+Ms0YlJWY6GWsWSeQuRAjokkXelhen5rDOwjxhcZ6M4gAvP+SvohEwE6h5R1auQvYlhoI/qQqk+rdiqSnx/DqQJET/9yUNxL6Ia3ovsW4MRv5rMPd3hsgWXEVDoAlocpcI6SqacoIDWBgZvplqJH+fWBzqtjQwvWeTnkJLt7uoSJae9GHtg5QNs6ouAbMZYgOhVoh96sNIiNwkxE3XLLoYjSbbUTJRyqJkIgM0EoAoRfrs15nheTtxbdjxbf5o8N/OZyvinuN/2VViqkd76TsmpDaEZjoZofx73oUkns9zUMrH9ftg1EPZL4xUGxabr0fwLTfEveVslKtLCpq62lPS+dfsGtIsd3blPhphJl+UGyyd1w6QUvqjGaprlNycxKbWdArUuqMKsKyy0CDuh0nSDATKVvYa0Erev0zHNKiFe3a8YjCaRcg
 j1Qo9vhq
 g2Q1CQ5RyD/+JsOO1Jmwr4AEV6RMf7QBFjsXei7usqtrPpb9t6fYj3rUwQcqqDS6ykrw51Z4QsNsxtcwZjvvh87mqYQf911CxR15rKrEfgkDqabIsN4Nmszc22qGLlpJxIicaFBNhX2Sfjy1dI7vZeLFPUMbSMSbOY5Acmybm3m/HBCHRT6rzer1uuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zone_batchsize returns the appropriate value that should be used for
pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
1M, however, it leads to some incorrect math.

In the case above, we will get an intermediary value of 1, which is then
rounded down to the nearest power of two, and 1 is subtracted from it.
Since 1 is already a power of two, we will get batch = 1-1 = 0:

        batch = rounddown_pow_of_two(batch + batch/2) - 1;

A pcp->batch value of 0 is nonsensical, for MMU systems. If this were
actually set, then functions like drain_zone_pages would become no-ops,
since they would free 0 pages at a time.

Of the two callers of zone_batchsize, the one that is actually used to
set pcp->batch works around this by setting pcp->batch to the maximum
of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
incorrectly prints out the batch size of the zone to be 0.

This is probably rare in a typical zone, but the DMA zone can often have
less than 4096 pages, which means it will print out "LIFO batch:0".

Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1

With all of this said, NOMMU differs in two ways. Semantically, it
should report that pcp->batch is 0. At the same time, it can never
really have a pcp->batch size of 0 since it will reach a deadlock in
pcp freeing functions. For this reason, zone_batchsize should still
report 0 for NOMMU, but zone_set_pageset_high_and_batch should still
interpret it as 1, meaning we cannot get rid of max(1, zone_batchsize())
in zone_set_pageset_high_and_batch.

Suggested-by: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
Reviewers' note:

This patch was originally a part of the 6.19-rc1 pr, but Daniel Palmer
kindly reported that this patch causes an issue on NOMMU systems [1].
Thank you, Daniel! I wasn't sure how to credit here since it was a
report on an unmerged commit so I went with suggested-by. If this is
problematic please let me know and I will change the tag. 

[1] https://lore.kernel.org/all/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/

Reviewer's note (to Andrew):

This replaces commit 2/2 of the series titled "mm/page_alloc: pcp->batch
cleanups" [2]. I thought it might be best to just send out this patch and not
the first since the other one is already in the pull request (and seemingly
without any issues). If you would like me to resubmit the series, please
let me know and I will do that!

[2] https://lore.kernel.org/all/20251009192933.3756712-3-joshua.hahnjy@gmail.com/

 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f928d37eeb6a..95172f4610ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5888,7 +5888,7 @@ static int zone_batchsize(struct zone *zone)
 	 * and zone lock contention.
 	 */
 	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
-	if (batch < 1)
+	if (batch <= 1)
 		batch = 1;
 
 	/*

base-commit: e0669bdbba170f6c1a7bf5763f72df3f58a4945c
-- 
2.47.3

