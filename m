Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BA5CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 19:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BEDE8E005A; Mon, 13 Oct 2025 15:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130648E0058; Mon, 13 Oct 2025 15:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64348E005A; Mon, 13 Oct 2025 15:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B80408E0058
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:08:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 627C7881E6
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:18 +0000 (UTC)
X-FDA: 83994026676.06.C6DD3B7
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 853264000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F2iSMDjf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760382496; a=rsa-sha256;
	cv=none;
	b=WCT2GOTeUp7bUvRS6ecHjGMW9s92CgBIn3Yjjc7OZvAyjlTu/dYEghXXVFzfU8HA+u01pB
	aD0MCzOU1LHlkCKfW9gZYXtEUTGvb5fgHrjkeho5TeHeZEjFmKKD6z4rythdSzxMBYGd9q
	hpiw6QgyC0GesLUCEaS9taHtPV/DFvg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F2iSMDjf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760382496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4PWcq4M+uwGRj6srPkRX14QChgWCsKUHbcguMBrius=;
	b=2lneSzr7lCshZeI7AKSLL6rTTu2Lesf5PWsd8ybK9s4HSs9bkrm/IR7RpAM9bcFz3pMo+J
	Unv/u/JoO3XisykCsOsssFULv3ufm7ZUBvgKB9Po1JuLNRNSggDz+OteQwfe2Vh1x/3dbb
	STRe3GYhL98fHyGWrQVoftKUwWzX2XA=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7501c24a731so53444747b3.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760382496; x=1760987296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4PWcq4M+uwGRj6srPkRX14QChgWCsKUHbcguMBrius=;
        b=F2iSMDjf2Dz6fzux2SRY/OzaNhPTHBwhuKodQmsu1we9PhUAdIOqntIH1ZreoNQX22
         CBXPVh4XtALwNi3LjaPIjKM+Uqx3wYM1mBiDDWCejp01tnjsvBMAFuFu4qKhyWfwxqT2
         8JBAkep2UtfRIeSSYjIT1aPfkiQ4JiRNBDF0slb5sPZ1GTmsoDpRFCriudf040NGyJyP
         aFkN8bNj7fgEqveoHI2nAQIdumPMoVmlwnS2mm/DiiaEb4ehp3Q1sB1D72oEeyprQno5
         cnmsW8m5thbwqfDxOShtenHNHAwe033fUXsRp+bmD9XPRDApSqbqEhfyJaupXZwJvvMe
         mL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760382496; x=1760987296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4PWcq4M+uwGRj6srPkRX14QChgWCsKUHbcguMBrius=;
        b=OpXXQO7rByemYDSG6jFNbB3x7zGvZpchxdkeQ79HuCp/54AlRcUYthMNfLLBci35+T
         RNGtTHQGydvEX0QcKyGexbvWOpdB9MnC0JHN8jwh4bOxlggj8cpG8vTQpds06SIiY3AD
         7+3HisSGXO/IUAzG2c3s14Fqpi1adpSbSxioYUOsHG9kbldP1876id4/+AMkyMW3eZwy
         WXjtFc2rLA5avFtPB5y+8cZbZdVfhQw8OAnNuvFQ3sA0wIDVzKyBw4SkwyVwACc71BKP
         0WZgCRLJeAv7NRya3E6gpy0jMUV8L2zNiIWEmstFK/lVSEaXWdH5GCA3rWZaEfXYil7M
         J9hg==
X-Forwarded-Encrypted: i=1; AJvYcCURbjJfyTHPP+zMz3AWciT786T82/CtVcf39omLpa4aug6ulEynitaGSD15T17iZC+5iI8awsIl6w==@kvack.org
X-Gm-Message-State: AOJu0Yxdu06FWc/KblkVrjrQy3Sjzf7nxZUJF5GGtnHs3Ul81cSE2cKp
	dfwWrxjIcULJBOYLMn9EJGyrHuo+sQ4lCp5qP62P6zAVvdNmjCKhrIWi
X-Gm-Gg: ASbGncsUenj/IIhqvaPBftDLJb99U+ROdhi1vpQ9ASXlHZmrtvOvt+SA4kaoV32DPQU
	xxs9e3oYna6+a/hZHptsn/h5LZ9jnu29NP3VkEHzyFhGb+u+chCXMxReLU4wYdF3+3rIIIDyMgo
	m/mvkoRPiAlnZaMca2yZLbSdAw+5avTiDJHxrAu479GHpMWDZeS9L5PXt2UaBHqpgCupoPe6bdw
	77rHw350qsdsR7EPxJAY8ySnElgNVJmr8i3rnhB35mlZUvh3mNGKpe5lZ0TUfUJnceDGjGqmsvG
	NJzOJ6ZC91swWMTrrPXNtEi0y8lRbqeCAowPloZ0gg91FsmDn/MqEBrbD3809B+aZRgThfj7uXb
	Hx/+QMpSg+/PXUsIECvLPP/aZyZMdpqbQjlkpQtVIwTBYv3uCPfVtt+kzoIjz8MkzMIf3MRZMoU
	Auj5zTXY2n/aaLO0B5yg==
X-Google-Smtp-Source: AGHT+IEwc6kNppGrUkzHR7CUmSJb11RqLXjiocSwItNawnwmXymiBVgb+9hi7J3cnFP0Eq2Igk3xkA==
X-Received: by 2002:a05:690e:18e:b0:635:4ed0:572b with SMTP id 956f58d0204a3-63ccb92c021mr16046558d50.47.1760382495682;
        Mon, 13 Oct 2025 12:08:15 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:1::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63cdec375bcsm3853594d50.17.2025.10.13.12.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 12:08:15 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v4 2/3] mm/page_alloc: Batch page freeing in decay_pcp_high
Date: Mon, 13 Oct 2025 12:08:10 -0700
Message-ID: <20251013190812.787205-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013190812.787205-1-joshua.hahnjy@gmail.com>
References: <20251013190812.787205-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jxhsiemcg654ns7rfsgy6pm883k513ad
X-Rspamd-Queue-Id: 853264000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760382496-107259
X-HE-Meta: U2FsdGVkX19AmilyW6+ObodYc4ngRHrH+7NSl8vlpzF6zmaXxqvv3+hJ/d95kSXcQs5sbfLWRBOhkAn+Gg9gh1jCOOhmhySqPGPGmAhfuqVUA2fqEUR6s6nvCcMvNcvy9OFuCKctqn9ebIlR9zOaXjM0p3BqeKEx19EQ0UOb4GjjQWN9BCQRkByvsurhzhijAAK/hPJMy6G+73zrYj6bWCc+Kld5RYsd4MthsCG3qTRT3QCeGw9Gd/hiCunPq5nrS0T70x/Q9Fjm7ngzfp639phNVygh222R/4pRtcgTiBdNJ284ju5D6Gu2SamIb2oZJ7shKKkli3m5sEW8hoZ7foNYc3BocBQarK9m4dhQGEc0nTlhDB8UHo6q9MwHqiTtl70MBFyPJkzrubjRXEbuRzNRV8V+6hNbns85AXZvRN3FWQfCOrdVAkFDF/0GhMg4iAm1L32+oggulmYWSqdctdQh8lFdQ1J2JD2Q8SOOS3J6KKgBnLBN4bjiLbD5ipr1RO3appampIy6edq9/VvUZDMKZfYLbLS3Al0rEAJgr1G7Z5B6Q++R/S0SvFihqpDyUceVxoNLSjsFYWp/jENalR/yCWl8S3+/8BQ66W9XcOqW3yhFIMRuht8hiD+n01XpqiVVtVFNJIvSEVsGUMMZXcncl8enxY33OT5yc6tczV/rmCnQrfzGCSe1fK4oYNwl69A1gyeRj4kTrEHZV5EqgtJVBy4jTdngUn89RnqrspF5he3wTFMJ/0kHMwc5s39iTjk4G6FvN7RiFWNhpR6HkSzovoq1rtHvfV3s1nPIz3AGA6YOoUCxyf6/Q4rQOdmQHDy/nmVVKcxmNZMJ2bta/+sbyHCGTyYywcgc0YHBdQk8cEIRamUFOk+eMH8PXKg7OGG52vRDdDO+ZbJ4TctYIFl0sdiJg4oKqSvUC0rtVsGKegMp9tbiN4xd9rVlzzKw/J2892B2rG/lhb8ZBYP
 Zjw4+Zgg
 4yCOnO2eVLgWotDULh4TEvYNMC1dMwz61OmFDcwVLu53UbVddSXeMo/1N4AjMlbd7t1/xIXXjwuwPj7qdoewoud5xLegvVzvBwgcMi8rm4ctCE5Or5akqMhqhjPc9t+0qs5Jt7kzcFzsONS5oCH1tJMlrZlFYGxGwZMdzDQ9iL/xyns2EUZOEDc0hRsrPFsNZTHsslz5ccwVliWOuQZUpbw7rqdUemqszLAvcwkltYfX+yMRsM9HVjZQ0pbS1v5dkoTIrUCNIYKaNmmoqls5HSHvNvYdyGokR8LQxQs4ePpTAjQoaHJpDVIYUP0vM73+ZjNHwGDeREL1nhHMvHCVGWx8sjjfRs9uC+2m9vbZbzE3tMknwz7X8kAztWTNZSjMLus+q05UCmHVMwJDEQb6fa87EW8EA3dQnc0bcrQZ0Je6Tq+a3leKoKAT+E2DKvgx+iZxhNiikYAZhRloUvSm66pRNNUaGWoF+Kmny/SD6K6W7+D9twovJDYIBZOUYHLohPnGGY2dPHkBYsdivEmrbjj2pahiYaZ3Edo7dvwMTPtHujzkX+yGChcby59qiYIqfi7+XWqUAAV1oXXJRPzp0vcwKfmm1kI71XS1nNxe4LRyzPVhQ7lXpFqqzIPAj4uyTYsoaQi2xrOxpzgnYwOwuWTkgPn/5aR5NEykQZnRXGCRnLGZJ0Yc6N0z1pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible for pcp->count - pcp->high to exceed pcp->batch by a lot.
When this happens, we should perform batching to ensure that
free_pcppages_bulk isn't called with too many pages to free at once and
starve out other threads that need the pcp or zone lock.

Since we are still only freeing the difference between the initial
pcp->count and pcp->high values, there should be no change to how many
pages are freed.

Suggested-by: Chris Mason <clm@fb.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bbc3282fdffc..8ecd48be8bdd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2559,7 +2559,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
  */
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, to_drain, to_drain_batched, batch;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2577,11 +2577,14 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	}
 
 	to_drain = pcp->count - pcp->high;
-	if (to_drain > 0) {
+	while (to_drain > 0) {
+		to_drain_batched = min(to_drain, batch);
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
 		spin_unlock(&pcp->lock);
 		todo = true;
+
+		to_drain -= to_drain_batched;
 	}
 
 	return todo;
-- 
2.47.3

