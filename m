Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC70CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 19:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862828E0008; Fri, 19 Sep 2025 15:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B048E0001; Fri, 19 Sep 2025 15:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBA98E0008; Fri, 19 Sep 2025 15:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 577968E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:52:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E69E71407A8
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:30 +0000 (UTC)
X-FDA: 83907046860.24.C5DE225
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 02FCDA000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1SxUHdQ;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758311549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeFP7YZ+0ipT42W2voI8x5bVWJQwIjHVnEimGCqA+fo=;
	b=dM/AFDwuBP2fbhm3ksdBh1jmRgYUUcmIVVyEmFZUFy0MWAxMOTrr3WrHIE4y2+PYlsDcPE
	3g0B5iyLi0/pZDp9sKyhW5x0MQEBm0y3O3H9Bv22wRCEwei51qJHygxK07Kpkh7f30tAbb
	lwaqTFUIX/VDY35L0W1+d3hIXFmuet4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1SxUHdQ;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758311549; a=rsa-sha256;
	cv=none;
	b=cx0EerptjZ39B8vPKu5DeKvVikIZ8acYtM319Qr1lpItvVRM/uGc4SKAoyJovz8VOD7g8i
	Oaw5sM8UEPaljSg0MqRSGawMpQvV8U18x4+yXgAsFqneYATZf8O7s3iS7on3Scf1RLaoC9
	4tUX0F/dMs+vwhKRhAmMhXwmZPmA3e4=
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-ea3dbcc5410so1856971276.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758311548; x=1758916348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QeFP7YZ+0ipT42W2voI8x5bVWJQwIjHVnEimGCqA+fo=;
        b=k1SxUHdQggJHTw4SlJBuXtcDorMR25PEo+mxNzi7BeXLqJpootKXjyBWhdg2M7xv+c
         hTFJpcoz0IrgIleQkabWTOqWjXCAjdsR9t+h1QRU78ROiHsaBFJApRvCmPi1dCNc1hcr
         0LYsQ2zrZx+ItEkLYh9zlh7WXdxFBVo/2uzNxy9CApgZ9cgzBuUjVRe08qkZvFOlFcC0
         dESmp9iTrmqJXc5fB86pKK82Rb/KjaJuXn+jLswj+ww/lUHhbsRypLz/EJDmHOOC0nrt
         48I7RJEIgQAv59umDVfnHYs8r4nroLqz9xHoyHiFKLC7mFcyHljNMRF7wvVGOaANMiO1
         oiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758311548; x=1758916348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QeFP7YZ+0ipT42W2voI8x5bVWJQwIjHVnEimGCqA+fo=;
        b=stbWOQZJd3MFOibulhDaA9dlcDQ5KbYrQ+fr1sjcG9r1JJgaR7iVWE9aFdQacx4FM7
         Ictsu3qh+4Z9p/6UxYh+REMe3d+XWi2Tj59YAvP5jXtVtewKl525FVcMPEHmRfek1Hqo
         ERN+pTA5WgtGpvDlz5PEoY7+rJN87cv+eIYo6RF8KWaT2qXOc8e9P7/pagfkPbt4aXZJ
         nqFhHgsZxrt7xug8UjnOglZrUaJK+vrlwB/djERURUb797bTuFd8nUTs+kxfsWeU4aBr
         Ut8TApz9Jj6cras+SnlB9Rmz9l+4mDfUvvXnJK+3siXXXMZ2OAqrCcor6tK2ui0+Eqj9
         Fd2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6C9paZqa6zRpo9FTMzbMbNyK3w5D7qgrUdmEv/je2FfRr+cyIZAntc1JHVvdDwV4mRYYs+wg1kg==@kvack.org
X-Gm-Message-State: AOJu0YxluHrFGXJ/9HWba97M0FZEaQQI8oHnrDvAqM3BHWccM0ncFyMq
	pAvW06r36pyHvB0kVcE1UoF+aXbIfHj3aR6jkESR1O61JG6/rDNrrHON
X-Gm-Gg: ASbGncuY5q7deweWgv+n0QERjm5rylSk8B+lbh4rSmOkSpSl+Pqtq2eSIvz8Ek/Wwvw
	Trh28tWaTSEkZwRPQnKp9gYmdJS+Pf4oNItO0zhZ7QlO8e5ccdkIF0kpE1IOOesiKsRFfn2/p0R
	+t4+lvlGGDzSsKofHAZ3WGmESHKLArTrXHggImxDM49+Cndq6qB4Nww/jpSB/1bEGj6mjT5V2i1
	z+LKjhvr92RWvZ/rnSsRarrb4odkQVBPoumggoIlznwCdLK9PXLrdJqsrBB2GM8Y2Hih2CSGD64
	0fbQwQObgFdfiKWgGyEyloItSro8G1uhCiStqyj0rHjNCDV7P9oIJgJlmp2YEGJ6hxfTCXQ4NVs
	ftKssmO3H5rUDKW8ROSLG5KY4wMK36wiWQ00r5HizhF/lo5FaWM9nDQ==
X-Google-Smtp-Source: AGHT+IEsrmhTSR/Ouh5RyIoB6jxstfFRsj47OaTQJsuUNGkSTK4pmk8eUUNqdr9I9Afg7H4rSVdbiQ==
X-Received: by 2002:a05:6902:70f:b0:ead:1e1c:2754 with SMTP id 3f1490d57ef6-ead1e2b7e0fmr137258276.42.1758311548027;
        Fri, 19 Sep 2025 12:52:28 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5c::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea5ce974386sm1950713276.28.2025.09.19.12.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 12:52:27 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 3/4] mm/page_alloc: Batch page freeing in decay_pcp_high
Date: Fri, 19 Sep 2025 12:52:21 -0700
Message-ID: <20250919195223.1560636-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
References: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 02FCDA000F
X-Stat-Signature: 6xsxzn37k6xutatjd39t9ukx37iakuxg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758311548-717837
X-HE-Meta: U2FsdGVkX19d6tgt9mzMVPcOPj+HTlRZCPtDCqAoQA7dKeFAjjPyTXSFD+hzWx3yC7WMU68E8Cp0wLOBY6f6BkUR+lZewBuURv4zVnDmf0EtAJWEi0H5FVvLdv76nwiy8hYzTV9Vjufd5JX0z/Hx4Y2adQ5pOxLT7n0vF4nN6Mu9gNmHORnXxrYxhrUTeKDCTXM4/kwAeHCXl0ZkKnGF+DWkHAuDX5RUcKNYNtMyMtL8K7eyA9/GJou0CbSUcF9ytHjlCcV2cxNbYQfwf6sewSwB+4R6p/Dk9h6lhuWQDRx6FA7yG+3CcCApDfse9tnGSFaql4PGqBGp72Rc8R+jzqmJRdT9Cthi8j09uGEAtcgfz+NRnYzvZ8M/NYpS8moxOWR//+EBcz9M40+UbmtXBu1aXLcNkGmEndIsQlV5gOcRBBPzXGOoNOJH6RrO1E8wmRdt/OwFLErBGYaq0wpD6Yluvq57dI5dNKtwLus8LFhK143E/3SYN3DO+8mPEXnJQ4zAAuyegL/XKJ1zOlX5y+tnVTl/VB68W9iV1ffMDVvdqQwopGzs4NpNYpDHnyKHmSCEak/WJia7F6KTJru4wdrd7ah3NghNM13XmBinE+QVSUm4qRgWf5qCnLjEH3KDZGK5To57pExzypQPQf6u8LknNz4Ki04oN8sbvmAyxzGUxQWEH1+Uha7zIWHROfPiEpGLKE0zF6lDZ7Jop/mEVzXQqIpt2vH4VGsHG4VIw5yiyjElokX9Ng1BDaC7rPfmdTVTNFQWmFPEQhfUn2l5R6EUM1cuo8c8qw5SzQhO+0WQRUqAZQhbhGycrMJLNEomGlJ4uCPcmDpg4G7rNAxBWgPj9LLHStjAGFfo1M5jD+QluHGYAmOkr9AzsdIox87Hx0ngoGmDj6PGt05Ew84D8xwu6Qz1uOuUGq26IlnJZ7kSYNn78RIPgLxu6dP4M8BALTmae2ntqMKeFjgn+E5
 TuiUXmxC
 e3yU4cKKNYK7FDOGO4usBy0U1E/EsQJYUIEQHF9dUrs018DZLz8kBL7sdbwAaLUeg3YlE2ugd6ssY32aOLGwCWn5dBCqhJW9kDe0rL563ESHdiqWg+rrJhD0fz8J5ICz7IvodCdvXjX7yz5sOY3tJWIYgJ1aTBx3LeLXctXrn/SuSjejakuvLOnQdlNY8kNxfHewoLPwmYagBRhd30Jn7sdqNl2hIgoaE4mkGogStQL+dN6hFT/K0r/5ZiKcww94SF5asJvnNFW3n/y7rc6ERVgPvFz407+jLU7ZGGO6yj28qozg7SxF8p2+CEq2UbZ0D5p7d7FQ06dE6p6p9Tykf5eTiOrF7/TfFMbhFbxeTbHkjA2XCvoad3hLUtewODV/zoGem0a/ZbI3RypErvIzbyb1ayiEI1s5rxlOTNIkiX5IaK5xGmI/JXJyRHiMGvdgjeKRAZWcjFuNJORpbJ+YMHOogesfj6SwqdXQ/08cKF9jUwEeOxCOknz2OQzCgdQ0fe53hQiv/Xz4G6G+R+Zx6+24LqWNh7v6JkwHdH9isvY/NYMm8JV5iwicHfSXe1PGZ8/ZD4aaftDmY0WQI/bFmJZf6ZlKgEuNY7Y5FFKdCljhuohwVw7YVnLZqSyCItyYx8t0R1fqokXSGIQ6Pr8sv0ftcpQ5kdXWOVscaudYLUR3pvwcoAflgEuqHZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible for pcp->count - pcp->high to be greatly over pcp->batch.
When this happens, we should perform batching to ensure that
free_pcppages_bulk isn't called with too many pages to free at once, and
starve out other threads that need the pcp lock.

Since we are still only freeing the difference between the initial
pcp->count and pcp->high values, there should be no change to how many
pages are freed.

Suggested-by: Chris Mason <clm@fb.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b861b647f184..467e524a99df 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2563,7 +2563,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
  */
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, to_drain, to_drain_batched, batch;
 	bool todo;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2581,11 +2581,14 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
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

