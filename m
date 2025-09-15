Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA97DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0F68E0001; Mon, 15 Sep 2025 15:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5BD8E0010; Mon, 15 Sep 2025 15:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB798E0001; Mon, 15 Sep 2025 15:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8D888E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8874F5ABFC
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:23 +0000 (UTC)
X-FDA: 83892531366.03.E6BFC78
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id C724B12000E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V3r8hV3i;
	spf=pass (imf29.hostedemail.com: domain of 3dG7IaAQKCL8k0iqlttlqj.htrqnsz2-rrp0fhp.twl@flex--fvdl.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3dG7IaAQKCL8k0iqlttlqj.htrqnsz2-rrp0fhp.twl@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cc6GKOWoQL6x3lNuALuf8+hLk7kZZixPtZ6cf9+vrNU=;
	b=CM+3rHl5ZEyGc8c0RABtUZmeK/+QRci+Mvux9amdb8sUY/V9Hvr2xokwXw80gGlETwn0jb
	gamJw316qb8XC+kg1i9hXi9ft9iNK7EVhZtp5f87nCAzFg421XLoX9q6Ofza807A2ZOXHL
	Z1j7w6QseCzEV7LBIwZvd/I76aqib6w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V3r8hV3i;
	spf=pass (imf29.hostedemail.com: domain of 3dG7IaAQKCL8k0iqlttlqj.htrqnsz2-rrp0fhp.twl@flex--fvdl.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3dG7IaAQKCL8k0iqlttlqj.htrqnsz2-rrp0fhp.twl@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965941; a=rsa-sha256;
	cv=none;
	b=V/slN2sp0SVUlubl6piX1hWurdQmMgoIgCefxVSjpAqByGFKuhs+SBrXu2QxZkejD2ziaV
	fi9g0t9CvrOcG+B2+MLZ1qKNZTH5r4IAXweygRmsIEWeBUIx3HiQzL3ELxuLWQFqBZQ+sU
	R0haymGuT1L1YejS31YfTLddyMn1hLM=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32e5652d4b4so1008403a91.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965941; x=1758570741; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cc6GKOWoQL6x3lNuALuf8+hLk7kZZixPtZ6cf9+vrNU=;
        b=V3r8hV3iaqBkB5bOOXUsN/6J7rpi1IpsvddVTEG8hUL1psnx8Pcf88djsgrQWj/6fG
         m+Z0t9CYGftk60NqEI92F/+d53RpcXbeThvuvrCz+bDOyrUXteeABf6SidrWp4+s+0DR
         Ci+1nM9DfdDkgsmgW9PnqZOi5eP2emdn0r6VMnku8ix/qYq1hRmQ6bu2S7sxyKbdrIi+
         SmIt12eFXV4TwF04Nxg6kCGmfy3RQ5tc4fGTSr2s64Tw19cjIa5kC6eiJE7CmgWMUvpd
         wVZ25XG4PVz5H/asisIGMMV0TXKE2HrQjcUTqI374pb/zsuCaPQrYKdcqkyZrLNL9w8M
         wjuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965941; x=1758570741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cc6GKOWoQL6x3lNuALuf8+hLk7kZZixPtZ6cf9+vrNU=;
        b=MkF+SaO1W9z7lOFHXRBzCOKohkLHV8gmjvQ9avumXj0kLiurybCouMJBigaMY2flA+
         OYSIlMX1HqW0oCidGC8UnrXK3b9t/sJAUM2lWYIQkspc6HPvxLnqfrirfdy1sqi1bGu5
         7+UwmWkI178+hE9BFZ8HxoSbiVHrLFmanfwfr9RZsyjDVKGSjA6gRtx7vpvSDNaXzi4s
         okv9Mxx5QEZ1JdEEebXhfxOiXh6vvO6NFGBqPvDGnDjct+/dJq6tsuXdxH/jI4cthadh
         PkxU6yWvKRsigh+tYQFVIMWL2C76bylAp6V1el3ZhP7ByBZal2z0/G0SZoXfYJWMJRru
         sLwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTOAt3oosAmo8omykpIE2YhGbddazyXS3w4oggxt5Fw+E7yBn34LuOVXDWfg9DTdIYqntIB8NN5A==@kvack.org
X-Gm-Message-State: AOJu0Yy3Kw6eI93iWDitxG248Tf2DUp8qpBSeLVA6TeiGwJoT5B+UaKF
	YJX75B/ocJnsTF4GLa6EXShuPd4etiYJatcUHKArost7j7wooTKuKD946/2agDiAdEfuXhz46g=
	=
X-Google-Smtp-Source: AGHT+IEWXitsQ7F/mFPysA89lJUOW5nGMTirfNQGq+Ms7D0jQCKeShp6e1b1+4LCWTQ/gzoNFF4WxIpN
X-Received: from pjcl16.prod.google.com ([2002:a17:90a:3f10:b0:32e:1604:8630])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d92:b0:32e:72bd:6d5a
 with SMTP id 98e67ed59e1d1-32e72bd7001mr4041613a91.1.1757965940695; Mon, 15
 Sep 2025 12:52:20 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:43 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-3-fvdl@google.com>
Subject: [RFC PATCH 02/12] mm/cma: clean up flag handling a bit
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C724B12000E
X-Stat-Signature: nfahcrgi19746trujkd3wmtf75chq5hc
X-HE-Tag: 1757965941-701454
X-HE-Meta: U2FsdGVkX18MxMWDJXYCA5irNRnz+V+yf/De0XSSQHXhbCCcWngPRn/cf7CvSNkzO1VCvMMxkxx9tPLT9qeJOw4hpryNhcuSKxcd9IE6AgzcX9/DOwSlI7K+4joHEmjZbatwMH0hABHkZm8J8qn+A+rr99H/v+xiqcZxaDtBoov1a1lqMWFqgFgrQFlfCLmQ8y9RerBw8I4jSp1gs9MHj2JTS+8wTxYEJ5kTQNqxDo4ZEpk8uLK4KcK9dkqlrCxVA4wSBaNaGQAFVHdNEt10VphU5WaitxsIiwQ8VUSyOY8IUczqjcFyKQ2Duh8PNaxfa6WIC4fcBbCGoKypD0jhqBcuu1UbwyeUipiFtLz7tVASMKmQsSA/84r41jH78f5TxXvO11GPKtmriHb9FY5I5ksa7+IpeEZed7CO2QjzisI9Njf82HGUBYEcvdE+aKOxLugBz7CtOgPbLwiRaIP1Og5z1hOZd0kVJsbdUgbec52WtRPkf1OfCpbr/xbci3ieaJCj1g7YXjPnMSGQeW7UZLVBOCiAWPz/Hbrxr5d6b0HFBqsPfqWTACdkty2xZDHtptKmbDr00iTgIdV8KS4vcVkwMd3xeE5vz1I3hhbjxOgCIgUWSdXAUohLzZkiIFSMpHrPa9NcD6JoxEOpL7w/z1vMcltGKR3nDVeMvk3hbYA84jdpZVblhk9vRIfYl/GLmrLnaXzafX/Go0ljGxZUm7Fa1hgtfc3vgAvdPzzxe3GKAYOi4E1L5fsn9RVlTumiU4pKLA3ucKkuXCV1uxWvaWo3Jv2eD9eZNZlIlBQf2S+RLIWjW2OmYa+xW9u7LzOtWJFeunVD0pAQXx417zUGKMBHu9IAvkRjzUzv9GwCQ0iLzLslGWgFP+htz6l0R18C/PbDBTvF8vIwZ1AX9yr1x89EbiJT5JkQBr14b9LEAvEmKKXWJP5WV38xjcToI/+5d8bhWGET5jtm3ocq40X
 LO66RoiS
 GKu2Z2I31QH4+eHrMrShO4gmDFbmcnkJ73faLeDkycpaKO0Jt6DLeyV2Ih/hCY/2bVZokklQ+9FwfhLxwFb7TBdpKj3Zfuqiy6CR+hY18Au6XEklkXZeb9Ex6lBljgs5Vueiozd32jo4a3gOGsW8r03CwcdSJ0zxMGDTdvqGKabpXEMkiCNzafqxjVwpKMVW1bwuHG32zRMaXMai0fHBCoVPcYLRHlrb8YrWhvCwBLXrbrRJv7gau3SrLX7KJwoA7AtM4AyuRiIYaxb80ILaEuyvPn9hiFhHwJC/3sq08q6DAc+2i1+gQIekEBccG2TJ4/3Sas2W7k3ScHdooUUT+6P8iLlTPfdEc7og2AfdABmjA3ruSRzQjeNqee/DB+zH5GXcyujbmUEmBn8ZEMT4miLqw2WFfHt9VNOPwkXWFIUzPq1kt2dqhrJWZjiQ1Qc3ekHHXQb+GSQm5Kue+F3WJ8bAz/4YYqRhcQCYQgELx7XVhZDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic bit operations aren't needed for the cma flags
field, so switch their manipulation over to normal
AND/OR operations.

Also export the bit values in linux/cma.h, as we will
be adding publicly used values later.

No functional change.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 include/linux/cma.h | 12 ++++++++++++
 mm/cma.c            | 16 ++++++++--------
 mm/cma.h            |  7 -------
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf6326..5c3fdc5da908 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -20,6 +20,18 @@
 #define CMA_MIN_ALIGNMENT_PAGES pageblock_nr_pages
 #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
 
+enum cma_flags {
+	__CMA_RESERVE_PAGES_ON_ERROR,
+	__CMA_ZONES_VALID,
+	__CMA_ZONES_INVALID,
+	__CMA_ACTIVATED,
+};
+
+#define CMA_RESERVE_PAGES_ON_ERROR	BIT(__CMA_RESERVE_PAGES_ON_ERROR)
+#define CMA_ZONES_VALID			BIT(__CMA_ZONES_VALID)
+#define CMA_ZONES_INVALID		BIT(__CMA_ZONES_INVALID)
+#define CMA_ACTIVATED			BIT(__CMA_ACTIVATED)
+
 struct cma;
 
 extern unsigned long totalcma_pages;
diff --git a/mm/cma.c b/mm/cma.c
index 2ffa4befb99a..549d85b2e3a3 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -111,8 +111,8 @@ bool cma_validate_zones(struct cma *cma)
 	 * check has already been done. If neither is set, the
 	 * check has not been performed yet.
 	 */
-	valid_bit_set = test_bit(CMA_ZONES_VALID, &cma->flags);
-	if (valid_bit_set || test_bit(CMA_ZONES_INVALID, &cma->flags))
+	valid_bit_set = (cma->flags & CMA_ZONES_VALID);
+	if (valid_bit_set || (cma->flags & CMA_ZONES_INVALID))
 		return valid_bit_set;
 
 	for (r = 0; r < cma->nranges; r++) {
@@ -126,12 +126,12 @@ bool cma_validate_zones(struct cma *cma)
 		 */
 		WARN_ON_ONCE(!pfn_valid(base_pfn));
 		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
-			set_bit(CMA_ZONES_INVALID, &cma->flags);
+			cma->flags |= CMA_ZONES_INVALID;
 			return false;
 		}
 	}
 
-	set_bit(CMA_ZONES_VALID, &cma->flags);
+	cma->flags |= CMA_ZONES_VALID;
 
 	return true;
 }
@@ -176,7 +176,7 @@ static void __init cma_activate_area(struct cma *cma)
 	INIT_HLIST_HEAD(&cma->mem_head);
 	spin_lock_init(&cma->mem_head_lock);
 #endif
-	set_bit(CMA_ACTIVATED, &cma->flags);
+	cma->flags |= CMA_ACTIVATED;
 
 	return;
 
@@ -185,7 +185,7 @@ static void __init cma_activate_area(struct cma *cma)
 		bitmap_free(cma->ranges[r].bitmap);
 
 	/* Expose all pages to the buddy, they are useless for CMA. */
-	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
+	if (!(cma->flags & CMA_RESERVE_PAGES_ON_ERROR)) {
 		for (r = 0; r < allocrange; r++) {
 			cmr = &cma->ranges[r];
 			end_pfn = cmr->base_pfn + cmr->count;
@@ -211,7 +211,7 @@ core_initcall(cma_init_reserved_areas);
 
 void __init cma_reserve_pages_on_error(struct cma *cma)
 {
-	set_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags);
+	cma->flags |= CMA_RESERVE_PAGES_ON_ERROR;
 }
 
 static int __init cma_new_area(const char *name, phys_addr_t size,
@@ -1085,7 +1085,7 @@ void __init *cma_reserve_early(struct cma *cma, unsigned long size)
 	/*
 	 * Can only be called early in init.
 	 */
-	if (test_bit(CMA_ACTIVATED, &cma->flags))
+	if (cma->flags & CMA_ACTIVATED)
 		return NULL;
 
 	if (!IS_ALIGNED(size, CMA_MIN_ALIGNMENT_BYTES))
diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559..25b696774c6a 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -64,13 +64,6 @@ struct cma {
 	int nid;
 };
 
-enum cma_flags {
-	CMA_RESERVE_PAGES_ON_ERROR,
-	CMA_ZONES_VALID,
-	CMA_ZONES_INVALID,
-	CMA_ACTIVATED,
-};
-
 extern struct cma cma_areas[MAX_CMA_AREAS];
 extern unsigned int cma_area_count;
 
-- 
2.51.0.384.g4c02a37b29-goog


