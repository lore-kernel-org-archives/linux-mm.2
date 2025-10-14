Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E741FCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B2A8E013B; Tue, 14 Oct 2025 10:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB478E010A; Tue, 14 Oct 2025 10:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5840B8E013B; Tue, 14 Oct 2025 10:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D48A8E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:50:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFDB1C0987
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:18 +0000 (UTC)
X-FDA: 83997005316.30.A47C4FF
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 12A3E2000B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=icjWcoUW;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760453417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClhLNJaftDP05NzJp1lkBa4h24q4WP2h3MIN5SIwT/I=;
	b=byMBEeC3uyEH6XVATgXzlx9bNJ9G1ixud5sgxugk0G7PO8BOHbZw662dX/Pl/pn6Cw57in
	C4RzbRjwUMJQ2a8KW4fSfBb3waGohaQZmX+8hwL/DcyRH+MLMdoV/Iss0IiG3+10jcRdTE
	EgUPt6xnAZqexSIpG2fIHdkuuTSRZwk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=icjWcoUW;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760453417; a=rsa-sha256;
	cv=none;
	b=aenE08IElDxxpjb81S7eIJN8ks6GPvYJGjjS8kp+0LaJBDvb2aZVtFgp8EjA+oZ+N8vFev
	flaYQpSXGAfMvNgHu95Y3ZA9JllmUalBgOozUYqWQkPSH63O5/HwIS/3f15MdukD+b3RUZ
	Fb1bn5hKyfem0h5GWhSi8EpXroh/7HE=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7815092cd22so7797147b3.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760453416; x=1761058216; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClhLNJaftDP05NzJp1lkBa4h24q4WP2h3MIN5SIwT/I=;
        b=icjWcoUWctpb1UlSicEhdeJhY4ebin4eb2IgfKtLU0nBXOhiwoGTz1TXwnvsW26k85
         48BZX9GhT2I0tj03jNlEQOKRqFhVUPGMSZWol1grtF8RmNNXnWYfjOfJt+UG9ejjqA1M
         gRtNRi8kXHin2MMmG7crNUV2RGUJB3KLUDXM0HZz+OC+XJ8HwaRJhHwRzHYHdU0QsA/L
         qWf8y+YoPe0+M2Ee+H+NpqSvS9p12dDmAMWR77dcBi/z9Z034PE75wU/mxs5nTOy5xML
         gdADcY7yTzU4RzHO23UuRlXfOWZdpp10iU6ioRijg1sGYtRK4oWKyeikHJ48kgD8C6NM
         rDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760453416; x=1761058216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ClhLNJaftDP05NzJp1lkBa4h24q4WP2h3MIN5SIwT/I=;
        b=FXR4Q7sHfMIHfWIdYc2y0PvoELmZPJKIDPd83PUCQB9VoJD4nDE5hIBnHxPS6Z3l/9
         V+myneWijsHAj2HIbUFgOaQLJEmaD68fE3olseJgUlP/hmq+ZB1p+yEHXL7u1jeOgokH
         2gRMmEwjsiBBUaeAKeAS6M1GJRnyEC2srdEGO/oO86F0Us55CkUQABqLN4CVLzJ+BXLj
         +IL3JcIo5oCg8nNv+XuNdDYAGIE5HcW9PNuVY3i1BB3vu8xlfDRxIpnM/sQ9L0vX+cwJ
         n/umJQkyaepj8M13LqvFBMH2pKwiRO700bkFZHE8kkpUzlXGJzjbtVsIkD1S4SCY90ku
         0lkg==
X-Forwarded-Encrypted: i=1; AJvYcCXrfJt45/W+XbDsx5lKNS2rkDRfQYGm8OXbLr3lEHJELZOB13nQ5lhklYxMmfLVYBZkR6jCyhxYhQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3pIl/6JDjUyjzuzE5PmnjtWBReKXPHCWSrcBFpFtvYlA3Q2pp
	gyKBviperDv5fNZdUWtPfciDFn/f2NatcgjNMDSsIUL1ee/plfghNUSu
X-Gm-Gg: ASbGncvw92VNs/5scgKBZxbssBajH/XQuf4z1lKAaVa47QZv9aRSLRXbrhyJy+eGfgA
	IKj02TS/drpqk/YdBTSzhEZrfOS6GJFtbNIngCtzSeT5Bpt2Qn5Ei/S4o0Dck/6uJNooSxql1xO
	uEKOOCL7x87jI/rlw2RTQ7zzSEUNpLmLMkcIBdY6quj4/4DQN0Jip+0/p0m8HC8C7IYElccjhZJ
	f8spFcPkeVYkObVMYi+8MXhr7IKwwusKRi4OBE9DWwTss6ez+mrYIN5EiGDa5eRleAJu+6L94CG
	otfMuO0bruDq0hJQDEsHFGczBAQi4HLysy01uKN0FVc2nw2yr6sibeEd7Lm12iHSn4ZozBe4Zoc
	gTK/w9/4MWy5XKpi+GgUfgt1m7VIvz9Kivd8VYXQNBauK5ClrupXjiGuusnMtSdLufnoYaF/pyG
	CiOJLFlnZ8coXKuqtRiDg=
X-Google-Smtp-Source: AGHT+IFLwCmMuwzIce9/aUOI7BcbPoJAhUZpDPqSafzbEBP4ORZ6NkkDdl2noKzyFimA8Zx/Uj77vw==
X-Received: by 2002:a05:690c:d06:b0:735:7cbc:a935 with SMTP id 00721157ae682-780e13f5099mr272944127b3.11.1760453415821;
        Tue, 14 Oct 2025 07:50:15 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:53::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78107205820sm34229117b3.31.2025.10.14.07.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 07:50:15 -0700 (PDT)
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
Subject: [PATCH v5 3/3] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Tue, 14 Oct 2025 07:50:10 -0700
Message-ID: <20251014145011.3427205-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
References: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 12A3E2000B
X-Stat-Signature: ck93um86hqgty7irfkdmhu6ggrwzy6ay
X-Rspam-User: 
X-HE-Tag: 1760453416-739491
X-HE-Meta: U2FsdGVkX19s3smdcefu79jQfUeuZNNNLib1oyswQwAnJelH0PhJ/GWfzM1cCa0dflM5fUSsBTcjUFBwaVkE9RqP9KL2WFEdFmqYU+BGtMrwl1ao1My+Kj4zWE+WPpYYJPeojifQWmcAr28e5w7vVxIEQd44aKXGkreuj6HXG/+PsXZA3LYsNwVLobSBUDA6zyG81LosObdUoXtWEXfSd9OAsjhIB1jPBkxLCow9tzfRHkhgDmhi0VfwdEGDheYaIV2lKHVZHOHJ1oVUpopX39gaGB+mB8ZoM+JG8ZXSOSUAsu+53aoEPs6YweItW5bvjYJdrqtYktU5OWFK4LPjND8/8vLH2Xb6K9+sQp36O+hC1vS285sB4RdAdDYKxYS/SLPMIhdYsa0rt/ADs6PXt5UEOR+5sKnCyvo8icqSobZMaYKpInWn4F0osmAkLSxP+ws2lk232/Pd0YBs/v6fo+OY0RodfQHM+5ATOyL5qwzMm3rnEvufxr69SO2w7Wtw4Yaz3NVqdh9r3ZFvJplR2nLgmGvunEXt6rGj9a6r9t4FeKfsfFn2/N+kgTcU1xF3N0GiIlRHkYoS12HuKBkps/gZyC2OsK2VFmbZSG0UfuSGrVegaJb3jaWpMMG3kkX+JdX7KPunsw0P/feFkA/V2xHkzxqmlAco/19JYo5OIJe4zlvAA4YqCr4NkRd3kqMbhaYjzBWmVANIXGsSg8rfQxocC/pQEhl2TS27s0Noak4cp/QIqTXtV3kxS1SbYBae06vV2sFbnQHAesfdRmgOsn9y9v8yt6Po0npvYfB5ICOZsnOC0NFg9pLqP39AqBHVEqI+JRTd0hfUSrE/hWJDddtfNa4Ut0aMcy0GTjjGekzqXrqGg/WMZZotsd0f0MJ0947E73JxkJwYBQZtUsHyDfryXjLNEsjBOXpBY1Ql316PSPCsXIyXlMqrIi88tArYqomF7+vjIDaVq+3sG3K
 Yw5GTWcu
 A6ChJHuSUq40UurtAdsHIcSPlh0bjwiTAFdVU4uIthRLxG0uI/3MzdE7aR8uxv7wrzQsvWCQMVuWxLhlKnyCRBM7yjjQb+gHJTzxKMxoPIQpOTasKFqn/ltgPJVQsyYtuL59xshdbrLEN6pM6DEka43107WAxzxx7ynDgIs9Ga104yNKjx4nn2Bsw0yg5hRD0fd+lHaTgkvPtgjwlXTNXiOyDLYIrwRb66EU/H6i/EC3NQ7hzWPvgggvfHNussgLFxW+JxdDTPNptYRRxxBF865L8dfzBiJ0lTsoVsWEJ1oodxU6AIszrIcB1jndcL75yTdn4byislbwlaQKeAt7KdCt9leUuavjDq7knpK223DzWRheU5P4GaZHm0hFWA74SIHr+ejexL4kHDX/lQLM43ueYfkY7kQzjfyenPTILmTubW94ZOvpA0XymFoCotLkD5zkIv8S7XqJqsit2I+3hWbOH4lwm/nJsldaU2PMRqkr12AZqqKB+Hj3E3dvk5sDppX4TJgGcsONhazjJKJJ8A4e++XyuP4mBYDAPbPI7M3mma08+yHl5Sa5NGaxc9r1r7GnfGG9IYa3eEqbaXUHY4Sfbt52CvgYZHyzZDpLo2YxUrfSUVBeZUplZ07dPkQC1G9Sm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before returning, free_frozen_page_commit calls free_pcppages_bulk using
nr_pcp_free to determine how many pages can appropritately be freed,
based on the tunable parameters stored in pcp. While this number is an
accurate representation of how many pages should be freed in total, it
is not an appropriate number of pages to free at once using
free_pcppages_bulk, since we have seen the value consistently go above
2000 in the Meta fleet on larger machines.

As such, perform batched page freeing in free_pcppages_bulk by using
pcp->batch. In order to ensure that other processes are not starved of the
zone lock, free both the zone lock and pcp lock to yield to other threads.

Note that because free_frozen_page_commit now performs a spinlock inside the
function (and can fail), the function may now return with a freed pcp.
To handle this, return true if the pcp is locked on exit and false otherwise.

In addition, since free_frozen_page_commit must now be aware of what UP
flags were stored at the time of the spin lock, and because we must be
able to report new UP flags to the callers, add a new unsigned long*
parameter UP_flags to keep track of this.

The following are a few synthetic benchmarks, made on three machines. The
first is a large machine with 754GiB memory and 316 processors.
The second is a relatively smaller machine with 251GiB memory and 176
processors. The third and final is the smallest of the three, which has 62GiB
memory and 36 processors.

On all machines, I kick off a kernel build with -j$(nproc).
Negative delta is better (faster compilation)

Large machine (754GiB memory, 316 processors)
make -j$(nproc)
+------------+---------------+-----------+
| Metric (s) | Variation (%) | Delta(%)  |
+------------+---------------+-----------+
| real       |        0.8070 |  - 1.4865 |
| user       |        0.2823 |  + 0.4081 |
| sys        |        5.0267 |  -11.8737 |
+------------+---------------+-----------+

Medium machine (251GiB memory, 176 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.2806 |  +0.0351 |
| user       |        0.0994 |  +0.3170 |
| sys        |        0.6229 |  -0.6277 |
+------------+---------------+----------+

Small machine (62GiB memory, 36 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.1503 |  -2.6585 |
| user       |        0.0431 |  -2.2984 |
| sys        |        0.1870 |  -3.2013 |
+------------+---------------+----------+

Here, variation is the coefficient of variation, i.e. standard deviation / mean.

Suggested-by: Chris Mason <clm@fb.com>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 65 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8ecd48be8bdd..6d544521e49c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2818,12 +2818,22 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
 	return high;
 }
 
-static void free_frozen_page_commit(struct zone *zone,
+/*
+ * Tune pcp alloc factor and adjust count & free_count. Free pages to bring the
+ * pcp's watermarks below high.
+ *
+ * May return a freed pcp, if during page freeing the pcp spinlock cannot be
+ * reacquired. Return true if pcp is locked, false otherwise.
+ */
+static bool free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
-		unsigned int order, fpi_t fpi_flags)
+		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
 {
 	int high, batch;
+	int to_free, to_free_batched;
 	int pindex;
+	int cpu = smp_processor_id();
+	int ret = true;
 	bool free_high = false;
 
 	/*
@@ -2861,15 +2871,46 @@ static void free_frozen_page_commit(struct zone *zone,
 		 * Do not attempt to take a zone lock. Let pcp->count get
 		 * over high mark temporarily.
 		 */
-		return;
+		return true;
 	}
 
 	high = nr_pcp_high(pcp, zone, batch, free_high);
 	if (pcp->count < high)
-		return;
+		return true;
+
+	to_free = nr_pcp_free(pcp, batch, high, free_high);
+	while (to_free > 0 && pcp->count > 0) {
+		to_free_batched = min(to_free, batch);
+		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
+		to_free -= to_free_batched;
+
+		if (to_free <= 0 || pcp->count <= 0)
+			break;
+
+		pcp_spin_unlock(pcp);
+		pcp_trylock_finish(*UP_flags);
+
+		pcp_trylock_prepare(*UP_flags);
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+		if (!pcp) {
+			pcp_trylock_finish(*UP_flags);
+			ret = false;
+			break;
+		}
+
+		/*
+		 * Check if this thread has been migrated to a different CPU.
+		 * If that is the case, give up and indicate that the pcp is
+		 * returned in an unlocked state.
+		 */
+		if (smp_processor_id() != cpu) {
+			pcp_spin_unlock(pcp);
+			pcp_trylock_finish(*UP_flags);
+			ret = false;
+			break;
+		}
+	}
 
-	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-			   pcp, pindex);
 	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
 	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
 			      ZONE_MOVABLE, 0)) {
@@ -2887,6 +2928,7 @@ static void free_frozen_page_commit(struct zone *zone,
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
 			atomic_set(&pgdat->kswapd_failures, 0);
 	}
+	return ret;
 }
 
 /*
@@ -2934,7 +2976,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_frozen_page_commit(zone, pcp, page, migratetype, order, fpi_flags);
+		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
+						order, fpi_flags, &UP_flags))
+			return;
 		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
@@ -3034,8 +3078,11 @@ void free_unref_folios(struct folio_batch *folios)
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(&folio->page);
-		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
-					order, FPI_NONE);
+		if (!free_frozen_page_commit(zone, pcp, &folio->page,
+				migratetype, order, FPI_NONE, &UP_flags)) {
+			pcp = NULL;
+			locked_zone = NULL;
+		}
 	}
 
 	if (pcp) {
-- 
2.47.3

