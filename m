Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E27FCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 19:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340358E006C; Mon, 13 Oct 2025 15:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFBD8E0058; Mon, 13 Oct 2025 15:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C4E8E006C; Mon, 13 Oct 2025 15:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D01F58E0058
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:08:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C3E81405CB
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:19 +0000 (UTC)
X-FDA: 83994026718.21.992271A
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id B54B8180009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eCN5Lyl2;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760382497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDzIWaOgwVfkqKsoR4FvITyGy2H0kRZNktinhlzDtIQ=;
	b=wrW9OGwc/tVj/D8SwtcuVPpRMlkyvv8R72FY77lx3H3e0dudNS6tyCQ6coqy8ZqwZcE3wE
	E+/xJkq8HGw5luEN2M2T+KTz6Q3dHIAowimuV+p3ACxt6AYmLELsNIwmVP5Y/V4amUJYRX
	Cgx+bFHObyQXgloX0saS9qfk8FlUJQU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eCN5Lyl2;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760382497; a=rsa-sha256;
	cv=none;
	b=Q3PXPYE63r0cJyngExCsMic661Xir6zXGAguTJ0GEqvMHniNn95spUoGipdf5ZqlEu8yO2
	d32/vHTxsqRhON9v+LVlG6xwfdwKBzoZBpFQqHjJe4xGQGS36KMozgPAOICprvVpgAjZko
	VnO05F0luiJUNjFwhXQnJwyRzbp1p04=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71d6051aeafso47255747b3.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760382497; x=1760987297; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDzIWaOgwVfkqKsoR4FvITyGy2H0kRZNktinhlzDtIQ=;
        b=eCN5Lyl2evBUwWvJCP3JL60DiaqF0tlno5KISQ42NoXtRsI6e4y/Xn7Dc5E1/pi16N
         fYtWMIeKwPKtPhItdhsrp7BGBhR3DDNAeP7VQrlChZRqEOdF2kdaWBdKYYXpEukPNnja
         CDD1BTZ+dc7O7zU3SMrURbc14j/37BI0cU4NYpxVAy/tdayWXxhiHsK6kuXC08vxtPSc
         KFgZxJ4+FWddTOCRPGbs7Neu6xuxVDxxNz6d87AQJ+aQPcV41ueFIhh/pWndR4U7WVzO
         egd89LDbRfJZyaTC8XkN32gmDjy9pElakVnmtzbyLy6hNpCB9tpxt0PnKdb24JlcN/5g
         9z+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760382497; x=1760987297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDzIWaOgwVfkqKsoR4FvITyGy2H0kRZNktinhlzDtIQ=;
        b=deyWmuhc5e5VVCMdXfLGuGAXCTKM7GUSY6hA0GdW+E6jkGAK/fVyVFRJc8rTiLV9hA
         YpvPIbIEuQvRtChxUuMuzjs2zrrRDRXxmjRs4ETmprPQEN1uumzJTxHBrKONDpYlhV7b
         AZoOW+sbjFI4o0gIhslVMuN/cFeYFMgfZzMNM373nGO05XFIN7ZpnPLocrdIxWKnNqHR
         /iA0OnpK4Eisj7c5Bhm+AXa4290XeCgm2EPSWI/TEqKs5fnVxgiJyrElUEdGhRFxQp9E
         IxGwwd04/j89hhALGoF4JCXEGkhUsCxOSKG1jjEaaWgG0FkPLjqw0WwPQmROtEPGdCKy
         fsJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzy48jdm81kR0au7840AtGWdQCwXidPbgf3hW8B0g6yEeS0VQkFFJFpdpNzzZe95n1gDAo6SN1Ew==@kvack.org
X-Gm-Message-State: AOJu0Yyo4HfFJQuLXSrqEidEkrJbfNejRNIqAOJPP9xsPr+D5V5AeztF
	olZpLmM2WK9L+TeGb038Zhh7Tbqlz1Z8ZbfSNj+qTg8cRcGgdxMcil0U
X-Gm-Gg: ASbGncsL1sa6IkAKcSi2cjECVW7BxWJ94lcNYmAMGpCPuxexCsH8RqKz/KIfASMlXVK
	XbKZYUhQZoUtInpyDyZXoYLnS0h4avmAw6rSoeSZ48f4yuoU6ee5kjHjog9MN+4iHigmCoqe6nV
	x4N+OQvdC3MV/uV4d7rHWkYiRbT561PdQo7ETEGiDQZh8oApvtz0AHvVkOXk7z5B0NbddiDmZZd
	QbL14yNdPLb0ODeWZwbtH9FaeIXX+WU+8+u48WBrcrielkCMJKoTNDCHZaW6F5j275yZzdRLQuw
	JZD6qiBedVhLOq/A4/M1xsNzJeQA634ZaXpMRqogLbbCwby3otWbCHkdc916qE/pH9SxaAyUgjg
	YpFYlVLYXFPSo+TZCwLZSDUhmKDfMBAC6kBmw76VWoNHungy3TFCYHz+ANj2xzDkz2FPgqaw+Pn
	nUm93Y1f9N
X-Google-Smtp-Source: AGHT+IE9xC3500baXqEHlI48re4/P275laxRB6z9xaFR7v78dK95X3SgDSsqDOD2QAARYLwFZ+0PNw==
X-Received: by 2002:a05:690c:a641:b0:781:64f:2b68 with SMTP id 00721157ae682-781064f3762mr101116847b3.68.1760382496767;
        Mon, 13 Oct 2025 12:08:16 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78106dbbef8sm28680687b3.1.2025.10.13.12.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 12:08:16 -0700 (PDT)
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
Subject: [PATCH v4 3/3] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Mon, 13 Oct 2025 12:08:11 -0700
Message-ID: <20251013190812.787205-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013190812.787205-1-joshua.hahnjy@gmail.com>
References: <20251013190812.787205-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B54B8180009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qyu4znmbueokmeyugz53fq4fpp6csefx
X-HE-Tag: 1760382497-576979
X-HE-Meta: U2FsdGVkX1+KqKLj5e1wZBMSZD8E/BkMvk9T1zlIoYWMS9klvXsU1ElHl5CPiw1AsLhoWYaYlzfQkXX+u9ecRctNriLimXFR5R/KnH11jsh5efl0X+66sVj2RMkA9VgDX74wVcwMHBHAsKgNaYv7IgC+cFok7EdJh4DT5zjG/1tLuIFbiU5U1LJ3U6u/LH21G5HP7d6Km6G6Tn6MAaMOiqRDnvVrENvrM3QD75p+8HGh8aFOytgJb1+GqNCx+tYfZSOEYtGwns3wdZ4CCzhh3X5vHoPM1g7UpZ3PasndD3uXlDfcfbyxrk9rcgX54zWlZTKPbxCM4URuoer8WQ4YGCDpizt3aloPw01xH2rxBLrDdMJeRDGSz6p3Da5GB1dgHKTj5BVye/6jjLZ+TbTPuQT7YkWp0hWjwFunXy4rIe+aWflqQIBU4Ax/qDssh1NB96XTFbWzUwLKUPgiBytDI7Dtv0qlHUffOGlIokKZlO1fSFG9G1UIt5N5moVtPWnlhjadiUTmHo1gbWL1/biSeZS4YBJZrY47wy5sQXv88COo2ZOtvDmSqCozsAxM3S5lvdTvYvXEQLDDyI0Hsn4SdYd1FumdHfYBbT+XWk/PNDPVv9oTz7uPqemuNiQDlT+eYKNsA1JLzGEONgSgiGVzFliXCN6GN3DAUTEdTtaQedRihw2p4yuIP1SZ+A/vP8Y7Sncs/Eiha0x4LdAQbnJeC91PGGZL2xU8Egtpyf06wQ+NEvkDF/4I1rDyf8q0AX7cmBrZsPD9wh8rCpnnI98jGQnMhx49vCdPoAjQoqIKygndAahEoeSV5nWI4dFl8ND6QxKDvSM3u3hyG8qnAsthVVyv22jWq5Ou1+3zKOE8/SekNmlvLoZPHPF/7Uz90Cb0qKlRlnNuAEpF230cZlOm1HyvLXVHxs09bsBVQz0HluqKc18aCc4oN8gi3AcrZadNM1BIEJAmyhun4CJ6ypO
 nN+xNh8h
 HZteOiN9URJ2pGOjtAEG5klA6plnuIin0330Wh9cQvEiyANp1yOsVU9hkCLDhmAo99KRQ+h7jCVK3YUHIrmE1fet5iY48dmyhGqBXWBLOTLBfq8NKsxpjL4BK/GF1TLphj3THsg6Ya2lLJfSmL+W1D34tWPsyXUME7XQjDx9IejJzSEK9c6DXx6Uh0XYdLX3ti98FQ/ZK9aslBIBdZLpu4dgOake4OwcsgOMxUsaF8eWr89q7C0Kebljd4rtWXvVswfhJUzH/or/WF8i8b0LyYKXTIH7/EP5a/vnqSP6Aa0xVAg+LP1LlHn5m6rHt+tK80wS7sZeC2fsSW0ZcfDb11wvHSuq3CYllxSGztKaxYwcdOo7NQIsjSgiO+FwhlISiFEj+1hQUe/WAa2aaWNnWZlEXicedzoDPUhNQ1UrcJFIJ6w6/Kk4o17D7UKhYPHrRBatdWNq27luA8iaA4DhLhRpOc2XMpNGM9l442EazhY5wm5wp2ffA09dgUYjnA3MP0wECEyW8zIXpRXBReGrNslkySsUbgyYkzSv8eTXqXzpLRSiAZQ6tdii1y34+DUnDZyZ+2cZdDOkp/JTFBbcIZ12Gk78n2SDtoKdjmXW9lP3bDth/5Ghg6uR/OnD7HFdbYirw
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
pcp->batch member. In order to ensure that other processes are not
starved of the zone lock, free both the zone lock and pcp lock to yield to
other threads.

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
 mm/page_alloc.c | 66 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8ecd48be8bdd..e85770dd54bd 100644
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
@@ -2861,15 +2871,47 @@ static void free_frozen_page_commit(struct zone *zone,
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
+	if (to_free == 0)
+		return true;
+
+	while (to_free > 0 && pcp->count >= high) {
+		to_free_batched = min(to_free, batch);
+		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
+		to_free -= to_free_batched;
+		if (pcp->count >= high) {
+			pcp_spin_unlock(pcp);
+			pcp_trylock_finish(*UP_flags);
+
+			pcp_trylock_prepare(*UP_flags);
+			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+			if (!pcp) {
+				pcp_trylock_finish(*UP_flags);
+				ret = false;
+				break;
+			}
+
+			/*
+			 * Check if this thread has been migrated to a different
+			 * CPU. If that is the case, give up and indicate that
+			 * the pcp is returned in an unlocked state.
+			 */
+			if (smp_processor_id() != cpu) {
+				pcp_spin_unlock(pcp);
+				pcp_trylock_finish(*UP_flags);
+				ret = false;
+				break;
+			}
+		}
+	}
 
-	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-			   pcp, pindex);
 	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
 	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
 			      ZONE_MOVABLE, 0)) {
@@ -2887,6 +2929,7 @@ static void free_frozen_page_commit(struct zone *zone,
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
 			atomic_set(&pgdat->kswapd_failures, 0);
 	}
+	return ret;
 }
 
 /*
@@ -2934,7 +2977,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
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
@@ -3034,8 +3079,11 @@ void free_unref_folios(struct folio_batch *folios)
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

