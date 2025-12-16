Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AD1D5E393
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463576B0005; Tue, 16 Dec 2025 09:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411966B0089; Tue, 16 Dec 2025 09:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309C56B008A; Tue, 16 Dec 2025 09:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AAFB6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:48:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8EA013B766
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:48:16 +0000 (UTC)
X-FDA: 84225614592.20.C2B5FA0
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 09F504000D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:48:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mrGLB7lp;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765896495; a=rsa-sha256;
	cv=none;
	b=NYewIvinq/77pecfE996woCdT9VpFzgj1849RvAra7cMWHzZd6RVp34G9SnFg2PLFMObqm
	6vSHy0kxPeu/2WzP8hSmN7ihSyw1GDz6Zvn+vVL7mIMSmXwfOeUUH8F9Ty4F6u2hc0m76g
	PL4TXrgpJ+WMAGP/TJbmSpvSKSMBvaw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mrGLB7lp;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765896495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9D800N3llW1Kz/jDDU7ypPKI470/5xuGDSE+ejd9MKQ=;
	b=WT7NZuuEcs7KUT1CuTuNWf912DOIEEeWVqH98YF+xKZLBsbkWUYMkVxVvkF5agKRGeNcaG
	5RlyBVU+lb4cqvTetLTNjBzPFXV3kWDBpe3+487raJw/cHo/MYptwNO4n+CoAwugbC/RAI
	PzhWFBmyjrnL1jY1p6cDzVxhq5CLO+U=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-786d1658793so43624177b3.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765896494; x=1766501294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9D800N3llW1Kz/jDDU7ypPKI470/5xuGDSE+ejd9MKQ=;
        b=mrGLB7lpOxiKC7UMPtuNNf0pKzcvyN4qDaPXaSZwbQEB0h0xdNyx/My62Lf1nA0tjQ
         +RiI9ahRfCkMcl2u+OeiefKIZDT/laaCOBG4Zuplpp/jX+uN5v1iHFhqdDJ+Xsei6DNM
         6t4TUq01Tp24Pvf18KCLyOdMcJe4Lpv/AnuDRgrl91WOzuzhK1YIbM6vSod9xsZXuxkD
         S/lUDuJHuja8MJqNE81O2wZJRs9VzMp/81WyodSTfikOxG/0cVhFc8ImamVSoaCf3k3k
         R9udD7AJAKiuSa2aoKkmtusGubd/zLXyazv63cLH+5WFyqxHkukP5zs+z2OelE8Npv3a
         Lf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765896494; x=1766501294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9D800N3llW1Kz/jDDU7ypPKI470/5xuGDSE+ejd9MKQ=;
        b=AgxaYe2dujDrqgnktq2IY5k8UE43HL3SDIsRqN5puyl61ghoHxtvFS+5D76asWR/ZY
         zu17UYS00xkSg4/wcql5sM/K5e3v0DCNqC5gE1bLSE8GXW49XYfeJcuDIPSc0LNoq2Wr
         TAlXllffwXVeN/v2dP5n7zuAIJJkxELJhFYIU3mFfdJZ44KxT6YWrc1sFmFB0bLCYBZ1
         5CF7F/dXKsHcURahud47MtJ37QuTWYIM5D9mdEBlPn/maHqoD9tbsyiBaIfvhJamJIGR
         qYJ9E2J1QiwQkdJ+Pc+6OM27nFtY7Pzdm265ZI+GPY1plrldGZtzAWGKSUq2dTMR/r1o
         I9dg==
X-Forwarded-Encrypted: i=1; AJvYcCWNMRVNy8/bWjpieAKwZ0ex3WAQVcO/lZEqUSaShfhk+6lik/pe1z2CpdDmFC5Ho5HecYxuIGUCTA==@kvack.org
X-Gm-Message-State: AOJu0YxBX2YnZDc/9qEhORbrmoWjfjvsde0xAjQhU9WqolOOmH4PygDX
	vp7XkTUfPNVhp0oKfW/30z9mu3LrtVGmzB9AkZEYRSJhydKMtFcqStt/
X-Gm-Gg: AY/fxX7Btej+w6VHHW9pMlXsQvbaCVN8vxJprDtIwAPlERUpuV7HskAAFDG4X2QwGdV
	LOb7kbI+jszqC+uxt54QrFXOEpledf+1bx9t45WSwNKjsm69BkrWVApj1wGZFubWICK4JoKT3w8
	zL4R0rjG2iiLDy0Zk4fOzN9b+IVPYl89+U1TTZAJj4bFdy+xM63mZeR0T5bjEvOQGSY1ezK/u2q
	jpbYlPnwBgEtH1Cko7/U01FNV21czx6+KnHS3nXQFtUxVD0IV8uFJ/jmrvcNHv5VQU91RtAq9FQ
	XnDGfQ0culBWp7CvGsyQ3I2GPcncalu7q1RYRV6j5CetL1MKxb0VA5bcYec/aIkSooRFdNghzZd
	uAuFs9PTFb/Z7vCfViKGaiEJKzbFjJbvP0YlrM11umt+wS/SA/PkWl943kbq9hMZ/ulli/ESZk7
	aVwAriAz+YtcPnTEGI8O7q
X-Google-Smtp-Source: AGHT+IHtppcQCCTw+R6UF6XppihsZXaZ6mX9Bz4khFIM5iZdR1k6bH3QC/ci6nE1FOQaT2+D2MQtkw==
X-Received: by 2002:a05:690c:4988:b0:787:ed2a:79df with SMTP id 00721157ae682-78e66caa9afmr252323927b3.10.1765896493956;
        Tue, 16 Dec 2025 06:48:13 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:6::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e749e550csm39513627b3.29.2025.12.16.06.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 06:48:13 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Palmer <daniel@0x0f.com>,
	Matthew Wilcox <willy@infradead.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v4] mm/page_alloc: prevent reporting pcp->batch = 0
Date: Tue, 16 Dec 2025 06:48:11 -0800
Message-ID: <20251216144813.3016985-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 09F504000D
X-Rspamd-Server: rspam04
X-Stat-Signature: h69nn3wjs7i8tgeyah3n8zy9uras7jh1
X-HE-Tag: 1765896494-23888
X-HE-Meta: U2FsdGVkX19Yz7vZZ5k1EiY7RPup9wxo+WkBK4Ycaz9IkIRIB3HtrAPpzMgx5MS7Y9b5Mv1Uwn4wPxB2Xi0E5rBc/I8mBazuMpifnjlGBhz4gcHHswM/ZItgqFdPB59WTH/GhEzHoP1wON38HzvOCL2mqn90dW4maoPTxby1Zk54qe5Aq89bjWpN2W75CVewy/lM71G1v1xxilRYayVtue62xzsBLmiw/TBBYLeXM9ttBFT7cviT0/ckjd5ZWKz6iqXZwkR44Q7H5xXxnqtnCoXdFpoG7beAFtpyM9RNKR1pEieMpz1dEDorDpPgEFbWASexW5s6u2PL6CCTVel3poBYhxx2XgWunRxUmZuGoSCPTs7G6G/li0YWl9Zta0aKlWmJUTgIvmqsI3pNtYRm9DGUYbPHCxv11j/kjIYWLjaAH49v+rV/W24iE0bNRf4EztOGQSEtcJj7dA1gBTtEYe7cAijWb4CnfrtmiudnNPrXJZOfMj6cQ36t0ZYAQn9mbGsU7dd9BdQFbbx283WWrgsiznGujoFEGJJnERsQw9avxRztTbBRoyHxUaTjFL8eavqHSovmmAWMEO9kkwLkUQaZkyyXULAfo78IUle7+uuy0thsMNN68s9XPs1XltAGNWCysO1tyjT0DX2z1ki/b6gLwi+yzLDisXbvf5DWQQQ3jZ+3xd3WSHV29Z/tUH5J5sZLxpPYDW1Y3959d5WgQuRpFuWDIdh6nY9FiWN2C4qUCUIvmGdtF9QoxDafJLejyMlRY1Pi6eJipJUtfMEVQV587GtWQcqDRAWO36ugypZJaaC3UYg+0l7a+U9jhzlXIcK/VKHIfdvNscvlrghaWBTWg9KHDd+5NUDH9n+MONgg/yKFH/ztl2Z/BnOP+dCpRttqZNxulbZKYDl1B3LF4KDUueWlS5uGMQyFfaRFtlRCg5nWdO8NX9NLgdyizF7EGNv0JbHxQCKPE9RcCKK
 Au1wGwMg
 pG+fOI0xshkCm7DTxQ9znSremLK8ZttEHhSpUoEczyvhWF8arzGLcwaf4DlHQnJ9AkxjINyt7+FSdeddBuAxqaBXfoO5szLtS+3hSVbAq349GLhPlCcHLz4FnsRSm3uvWFVMJ6VIyCpUP7zikuU9j9ibAzOy+rEx/77o1F6vtuglCvfnDKOwgvmPHhYLGW5r3/Qrxw4MbQVtWcvBc4PTzJ/2/W8CJvu1QcfYaljjhmb4Bl5z8f3BY9z/h0bj5ULazMop7Rez+TJOF49hY3/HbBZmZieZTUaVn836zOZr/IAkVQAxeU7EXN08v//QOdwDQWdnR/SldLrKY2xIDSL1GXGJYkUBj8EgO2evx8RZWobKTngE28llLYdsKivbpxLkf8f0AtHXxMsjcpxG1fpS8/2Iyt4gJ2Gr2CT6uLkss4vphNTKVSYBzDlwBSm6eoEWXDA7QtddtwQnstv2vrqXFW9JOEZhMEmgDnprdiJzvQZnCD/x9zuZQsWy4Vd3fk4Xnb+NWO9T1LmyFJqhBc1UBtzjLh9rVvQxBuOLp7SRJLniUWk/vlMSdzfooMtYfPATZxKGVvyBelEpzti2R9NwKIqFjWw==
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

 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f928d37eeb6a..a7448840c5fd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5888,8 +5888,8 @@ static int zone_batchsize(struct zone *zone)
 	 * and zone lock contention.
 	 */
 	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
-	if (batch < 1)
-		batch = 1;
+	if (batch <= 1)
+		return 1;
 
 	/*
 	 * Clamp the batch to a 2^n - 1 value. Having a power

base-commit: 65dbdbbd25f928b8a56d9a27d97a6c668ce1ef08
-- 
2.47.3

