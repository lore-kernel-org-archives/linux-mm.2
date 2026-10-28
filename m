Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6FA606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=jf1z28nh
Received: by kanga.kvack.org (Postfix)
	id 89FE16B05B7; Wed, 28 Oct 2026 13:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876136B05B9; Wed, 28 Oct 2026 13:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D7F6B05BA; Wed, 28 Oct 2026 13:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE736B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:17:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C9E1A01A4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:17:32 +0000 (UTC)
X-FDA: 85372691544.02.1D41E28
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D5174000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:17:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jf1z28nh;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793207850;
	b=BH+Uoz5SmJVKiPlbSGgazlaB5Ckq9dQmCMQN8VWmUcBXm8lfSezYD2zE9hNcONI+p0wRux
	PCjo57VkXxqirke4Nvx7BUKEurZ/mtNJph1/+LfOrnzNonFujNmRyxfg8Qqhj/fqZihOJ6
	6R5s4XHlKgKCyD2hEvuPL6A3djKPeiY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jf1z28nh;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJiZZYGUYOh8zA+NsUNeXjoG3ihKbYj9buhXSzinHms=;
	b=zrXJ3Gg4vCs0Ozmz4OH5SQ05jglptrMWnGP9bBunvLd0qPM868Uw7/U1GIRyyl31fby1W3
	GLpvkgc8W0wY5LxwUpL3Jn1pYoE3mr6KGeVOzp4If06qVRBw0xUmCpQbFhALgJPDLwDO9R
	Z75bQ2gTMM6KMsezMepxGmaA7QkVffo=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b0dba37a7fso11356647b3.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793207849; x=1793812649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YJiZZYGUYOh8zA+NsUNeXjoG3ihKbYj9buhXSzinHms=;
        b=jf1z28nhRIpiOZyED3GvNmpF4FYyDkkLCoBkzu5k95UA2BFcDa3tso+Y3/47jGm1oA
         Rxyx+OsvBVAfRDad2QLHPi2JLC16W8WLDhtuWZx8F/6wew6gJ9tQ5Dl3VClc3hCzghWX
         pB0uFAWlzaU/zrqwd6f/akHVs8Y8EiPWrnepnD0SQ1AnbLHtreDXk/4kJ6HP/xEWSrQx
         VyjH7BXzNcQ4RluqVbWq9hGeWYeEh7dTFNYAkjZK4HG4cXrgcpcg8KPDAWa1CMI+xsUU
         UJHfC6gV0A1Dpd/egzs3J0opOSi8UakBWwnxc0O6aYGZnVGqIC3GjnL0F2HGqnobN1y/
         o0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793207849; x=1793812649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YJiZZYGUYOh8zA+NsUNeXjoG3ihKbYj9buhXSzinHms=;
        b=JmRRYsHVW+vU7XkHA7+iRZpR6R0JpaM6b5jybv/DyTRr2FEl6AnDSiwRLyeGvA41a5
         i6ZVW4Q9soA+U9V1WFv/AvH5SkBhPn9COfuxtLl8/8O9UxE0d1HaFn51+ISWhWOIGg6N
         60C7zJJITMey8+Ok7xZNIFvCMgGWph4p7iIwCojJvNhqmZ1047BauuV71XPaDgjgD7MW
         tSZw4mjySwk8tvVqLngomxStGl4zMDbP9Qpthzq3Ed4RGp3hL/Oqv42wCvLfobLK+F7x
         VnzLnh8JJdrj+MW2ooI1SkSLsKNLxfGpUNGF0dcJ9NZQsz985NQD8fVGfyWtz6t5sFsu
         f9kA==
X-Forwarded-Encrypted: i=1; AKwUvBz2ipx9vWbYYsENEOogZ3BQZmEQOv/dDi3W5iraE85dwkIbpPJdhdu//HhfYLGj3H7lODwZosLIMQ==@kvack.org
X-Gm-Message-State: AFq9FYJaEAfbFR4df2gIXvrzywIRQ8+wyLNv9ujCvklCQR3UQ7/ql9VQ
	3lszsBnFV70G2y3vIYNkHB9pXJFMLlgjCnEhjoZa5DUKdi+nwing2pOM9y75wpF/Ebk=
X-Gm-Gg: AYBFou1JOcs3Eq05AESIMamRby7/DGHANuQlAu0adw9CxSDsHF7waGp3Eeaj3eNPH7U
	4sztUF3V272LdNbQxxv0IpWPmJoW82QqvYn6QVSfgpKawkDeb1OrGoi3U1wVBOLAF0OZWOJrPyn
	IHD/FvW4xeJFFx6jdaOmFXnGAFyy0KqdJ6Xuk/VtJpQ8mQ2LvLGHoA0AAaIDo9NKka3nO1JaTLc
	9tql0M5ubGEblSGRXPc4SiXCcppR7D2NTrlfZrusb1ALsyOLu9GHr16CpnOMY62jRETaAuZPipP
	UVHI4JDv8RS4AG0qqsqYrCWrYokYSXqoCM4oHYZNzPYB5CEQTpmJFd+zTOyzA4mpioJyDc+HIuU
	6i8yFXzqyBRY464I+zyk4ryLSHtmoSvnyAtwFy3H0OQgWHS8YrSXF0qF3KH1pIdFn7rsY/pJ4IT
	TIxzi/rZe61qELOldAwUnDJNfQ7tXn1oixdhjSHfPlPocyrI70gS6wXX8LnHpPc8rdQaI0yAKEx
	jqboGNuhVuE2yZMliIfcaZVhXi6LiAzX/GjIBGruaRjT3fXW+CDkipNQqG/MqWVCNTt59fyVu1S
	vMveoZC4SCAsyBzhzO5mctksgrzb
X-Received: by 2002:a05:690c:930c:20b0:881:a45f:9006 with SMTP id 00721157ae682-8b1b5bd657emr15463867b3.32.1793207849119;
        Wed, 28 Oct 2026 10:17:29 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e609932sm31617307b3.35.2026.10.28.10.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:17:28 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Salvatore Dipietro <dipiets@amazon.it>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dgc@kernel.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
Date: Wed, 28 Oct 2026 13:15:54 -0400
Message-ID: <20261028171719.2043421-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028171719.2043421-1-hannes@cmpxchg.org>
References: <20261028171719.2043421-1-hannes@cmpxchg.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D5174000B
X-Stat-Signature: k4bye8zigaaegwfeimz34syzmem9o5c3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793207849-798998
X-HE-Meta: U2FsdGVkX19Q1ymCvbIB42p8uJEujYLHjWxJrMWam/yXatSYNAOe1VII/LuPDXGTaAVCV8g6osb4p3U5bB7DnhtoydllU9CpeUSfxvTuEgdFuIcpIA8KPyREXYW7NkJrcRAg1ovCnKzZo0ENR6QQHJyMOoqjt9CaSI3aScWcZ1S6RSwsYboS/74Az1GsmSUpPrIjQ0Xxdm7m51nAbSGW1jIaXFfE53ddNhqm1P8esNJzh/v9uz1ee0y0IwFg0q9HuuuJa00J1NrJctx8cJkulU96SrHjfukS23DAZU2/BL7CeZikIHH61BRPRwlgbjanPvFBwd8C/rfMSVnwdQpACrt0TKkglWBW+ru+N1rwkm3g4d/MAQURRTS6jGjWL9DMrpe7ze6YoRPqbQIxqcrfKXPzld8OemxYjysSojUt65AtYEo7hvIGIl3Juj12xV3z+gVauN50Vh0EvzFfLJ6jBw5JP6zWVXFTA4BJHRY6RJFQhsSoZ1vaqwLELWIxX3VE8I/Ek5ToFwayZkkyPo0bgR7/Wkxd0hI2DE+TaY7W8zP6PhMDDAALglcW6o383N3kwWjqG0uitM447Z2zl2/4rkI6adnkkficGYx3o5/LI77ijnroRSJNBXYMmUKHoK14wMTzDoUuMQU1490yfVrxPFWE+StP8VTxkpbUQas3fvBVeNrLXEYEiV8xj7BYApe+2qlK5ihvT88AxS+XvjB/b0ILgK0V6dEUeHmvcPmLJffb1thy7d3bgBntjlGzdfxaB91IU4jz8gn5JpBx/zw0BiihgauJqomy3n9Eqc1epZkQemOd4XEVUGe/2lV90Gs9jp5korh22uxC1vBnElnamWZh54ZKYBXTFcr2qtdN2yKJ0Dup0lUTfhQ9bdoDq+o2TlUzm8hfK+yZu44G6W1v8DktezOkp5qF+IMkhg7PuXHfAcji0ZJsOJNkyNODrx0zxeHcaQFyjOT8Je10g9s
 uyfHbRD+
 CKA6dS4HSAGCNebiija60+Qh7SD06T2Iqvs+Ok94hUYC+GKsSIn+4v/GVJ1e5Zbt8Jta6JAiIrvTXm+QG+I/AIRHTsycxUZXB7VRewCwN1GLU03leGumAKnbom89JsgG+YBDDxLXkHpvbXRPMTY81rU9WgjPV/mfgIcgC/Dra2AGrgWoRkaVcQmkcU4gqE5uMk5w0Jg6Jq9flgwsV627xaMjK+S92B1cyPasvNX26TLPGLPlF6hFpi3+rHQ1z4TMBHrkzzuwYVOBLjFH1UKEb0Vctf8OkzDpPQyZCfJv6HvoKnRbrWQKjcJnhEzipXdXDoNggllbXH6UtxtCtVlOh94y0fksxv7jATuRlI8TD7/BJPepXZHExIuLykcAt6CCaeku2bYQKxMbqEIrI7WtQHWvQrl35mcoJRjIfnCYg1TPFgVuEgM7roIk+16uTujdxR5nOyJ4sUtOnYTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") stopped handing out
reserve access for ALLOC_NON_BLOCK on its own: the extra 25% below the
min watermark is now only granted on top of ALLOC_MIN_RESERVE. But the
flag was left in ALLOC_RESERVES, which produces something odd:

With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
subtract the free highatomic pages for them. So in the slowpath, they
get to consume regular blocks below the min watermark by the number of
free highatomic pages. The highatomic reserve is capped at 1% of the
zone, which on any decently sized machine is a multiple of the min
watermark: GFP_NOWAIT can drain regular memory to zero.

The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
allocations under memory pressure. This was found in review and
reproduced with a synthetic burst, not observed in production, but the
sequence of events is a realistic one: On a 32G box with an anonymous
working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
burst drove regular free memory in the 28G Normal zone (min=60M) to
28M, 0.8M and 0.6M in three runs. Swapout failed to allocate its swap
table, reclaim scanned 13M pages to reclaim 200k, page faults stalled
for tens to hundreds of milliseconds. The machine survives it, but not
by design: direct reclaimers eventually fail and start unreserving
highatomic blocks, until the allocation succeeds or the reserve is
gone and the OOM killer runs. That reserve exists for high-order
atomic allocations; here it is destroyed to bail out a GFP_NOWAIT
consumer that was never entitled to the memory.

Remove ALLOC_NON_BLOCK from ALLOC_RESERVES. With that, the GFP_NOWAIT
burst is stopped short at the min watermark. No direct reclaim, no
stalls, no failed allocations, and the highatomic reserve stays intact
for the requests it exists for.

__zone_watermark_ok() is unaffected, since everything it keys on
ALLOC_NON_BLOCK is already nested under ALLOC_MIN_RESERVE. Update the
flag comments accordingly: ALLOC_NON_BLOCK just means the caller can't
block; the reserve math belongs with ALLOC_MIN_RESERVE.

GFP_ATOMIC order-0 requests have a milder version of the same problem.
Through ALLOC_MIN_RESERVE they also count the free highatomic pages in
their watermark check, but rmqueue_buddy() serves them regular pages
first and only falls back to the reserve once those are gone. They can
still push regular free memory to 37.5% of min minus the free
highatomic pages before the reserve is touched. Unlike GFP_NOWAIT they
are entitled to the reserve, so this needs the watermark check and the
freelist order reworked together, and is left to a separate patch.

Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 9c3c2830acb0..7097ea1805f6 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -32,12 +32,11 @@
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
-				       */
+#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
-				       * of the min watermark.
+				       * of the min watermark, or 62.5% if
+				       * the caller cannot block either
+				       * (ALLOC_NON_BLOCK).
 				       */
 #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
 #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
@@ -58,7 +57,7 @@
 #define ALLOC_NO_CODETAG       0x1000
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 /* Flags that mean GFP_ATOMIC */
 #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
-- 
2.56.0


