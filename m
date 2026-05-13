Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D64FCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F11A6B0119; Wed, 13 May 2026 09:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1EE6B011B; Wed, 13 May 2026 09:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790876B011C; Wed, 13 May 2026 09:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 672AC6B0119
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:23:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E400C02A5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:23:07 +0000 (UTC)
X-FDA: 84762462414.06.AC96204
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 12C4F1C000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:23:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jid5UHWJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmWs7Z/HY7dnLOeYCdnqk/zbv31syyn+Ltp9gTVRyME=;
	b=WzaECBPjH/uKAXSyUdNaeT5Vqr1L8+38gOVuGudnsjc6TFZI+hGNn8PXUqwZbtBpGZaOQ4
	JhVQ2J3k53tT7lWcHHox92+IhwFyz2WYOZEdDZYAZ7gcsQxDNXocvTP2CV9oYDiE0HbBqm
	63MvSDp6wMo6zXCSp0L89/UNz9TEO5E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678585; a=rsa-sha256;
	cv=none;
	b=M5UQ1wvLA/Sa6VO0/oAj/2R6/qkB9JS4d6khL9phcshmqPC6DiTjtdvy7VPMWPIum/ale+
	6c0VitWaiHueCBbyWYrAoJ9gD4ZwbR5sjbK/BApcpUr+m8/upYKWaiQr6MX9uFMwb7po/t
	Q2KgkMfNsCtUAOr22ZnNg3Lke4QGtyo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jid5UHWJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-369002b26f4so353400a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678584; x=1779283384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmWs7Z/HY7dnLOeYCdnqk/zbv31syyn+Ltp9gTVRyME=;
        b=jid5UHWJCwlh9oAK71DpDBTqBtfuRTMBR68cPzbwPLCcWu5QkhG4C66jZeTA1xb2mC
         662CH+qZE9s2dG984K7cX2OX88Ig+Mctga8RG2I6oeKk+C6MArKaKY2AFwKOMvqWSJ7+
         iKzt/tZwnCdnLGZsHl6Q1Zbu4tkzs4/mMuGw1Ie/Xt9F4+cxOjnnIuVfj3WFsk5T5BJG
         6y6uLuLj1MGnaBV3J7oL8f0UGPfQgmewfT9oR4b6vSH9IBiXO7vOqVfeKJ/wY41lJguB
         cG8dJbpwDim3qfIG934qcB7UTOo4cjOTyfzS3r3xswUDmVfKs4oum3lV0UUerpungPhq
         J1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678584; x=1779283384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KmWs7Z/HY7dnLOeYCdnqk/zbv31syyn+Ltp9gTVRyME=;
        b=JvI7F61YhAccU8GzxSQuM/Pn0VB+UnC8A9QBrZaB4A8iA8zZsE9d3wTfvnMGGTgUUv
         mlWxCREfFCM7BU1/IUBLazV62gKDwvGzdrlZCrEpchXAk9obbC/3EPFJTrDXa+uxxGx6
         Xh/zXndj1sv5HnybkqSi2NE9ZKT26qN9wUQbICARTpLrqzrfOf8ljfn04YlD8/ae4Bf3
         FjMJ0weB1l5migMFwLB9P3a28kovx9lJ9XIIx+pvDa5H2uzbahRo08ezI8rKAclCmaWv
         QEHIyjYX3dRw0pF7dRYUcPhAph3J9KT7PGDaQHYoryyJ9GH/P9MmXnC2b1qbdiYbjdlZ
         4cSw==
X-Forwarded-Encrypted: i=1; AFNElJ9gVhwMCj+7Gkqum34fSdbUneoWrqGGfzbO430q84eaaAzADzYMXnqTIhv7BBkLuNJt5XhWnAhWFw==@kvack.org
X-Gm-Message-State: AOJu0YyDBvuQkdhKAi44g7Q+xytGI5YoMZiJpS9Dcboqi+LCe2XKFA0L
	RTE31D3pNclG8zeMMMFTI6n2LYBT8I8uAppUTJpUs+NlXF5hXK7PXh+vlMsR3jYtoDs=
X-Gm-Gg: Acq92OHmJFptSV8E8zA1fWyJhdOhB0Bmc2ELmctARW4QwcTAJLY9abQu2sORwdzrx/H
	kdErO7ASmHwXcW/XPmfpp/osW4ToD1AGzVzCAkYwHBSEXDvX2GmQZcSMfxvfaMWcW6DfxB8NX5r
	KhAyjb6z98wZ1l8+EWeJSCVtP9d/omQFWnq224TiTokJ2V6xwYGyC2+FetxudW7RRjKsjr5S1O7
	gnx0MdlSXGu+mlXatsFhTCY305DY40dh5FPFAM8UzFzsy+lDBSYBflZSPLGyTz3iO1rA3GUM6/o
	bRUd3KvoTAVwWKRQ8Xqfv8sTOtDpafMJb0qwt3Pm71OMtbSXIDsSfU9mhgzA546IS6Azjqff5UX
	VaBplONa9qXyJrbmKOZiHbRxA0ft7N10bn9XICOhIgVLgMts/ETbQydva1fJSoJrSOXMhvfQ7jh
	RHA5yHE1scKIWAHbhhTfKBFNsBujTsWRmIjN7hA+grOkuKpFMpKca18yIrEyJH
X-Received: by 2002:a17:90b:38cb:b0:368:ed92:6f6 with SMTP id 98e67ed59e1d1-368f77c8a81mr2774547a91.1.1778678583622;
        Wed, 13 May 2026 06:23:03 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:23:03 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 67/69] mm/cma: Move init_cma_pageblock() into cma.c
Date: Wed, 13 May 2026 21:20:32 +0800
Message-ID: <20260513132044.41690-21-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 12C4F1C000F
X-Stat-Signature: yfi8w6wfzoy5kyfnfj7ia8ubkg5dy3ip
X-Rspam-User: 
X-HE-Tag: 1778678584-972882
X-HE-Meta: U2FsdGVkX1/HQfdGPcSzYqsybLT8ddpgUd/MhITGBCPNsPPVzFRTz6qpTeLxo1wj6w/0QgdR5HI/wpezBxUCEpHYZIaRRmfQnPhXjHV02etIhUl6XC50zDh9O3kfys66OTxVkme0/QICYvhOiH3OhgZhZ3a+RX8FJYGHnIPGyk4CaCOXFXg7d+MTH7zWvd2xhoE3o8KPPTZAaeAuo0RrESbN8L2rRxwomKW8sVlqpAvdO3jd90riC5Kf4Ja4DM9epzPhL5M4mD0zl2QTO3g63tjOkeV4pASvT+3kC/vsdl7WAPHETBzDNhY2nafLycg6qWiDZr1P3YAYjCy9KcVuonxuTdlFCNF/ECnTQOYneXI5PWNarQAosmUL33UcGOyn1Lc4N1YdfYAZfxyW0Q/8w4mVktmTraR9Qbmbip7b/G9hzaTGj4biIEXXWE2IZMTyAhvW6hKUL3NHGwjk7/bJPGeYKalwDFHwUwvtVNcgH1RvVGdmiPnbCrpjmh0etsrd/YtKR9C58zqqkECP9BRBLgPkj9Kwm816hmFcZ/rQY8a9nXCvL9s2xhbOvBwnjtumil7A0++6FoEVNI+/8/IAwy4bNlnLSloBwcqoBopm1/ted1y8gIQ7uVR2m4sS5LUDejIX0NfY16aQLngzfNwK1yW0c+RW49iLi34Z+EkBKFYy1narLzmwvpx9/pY9bv1Zo96FIPKyeobKfgeGy64BBi9uifPHy2HKymlRYLvYzOWcRMCWEiHIbsHP1GYiuYINfdTwiKeioONWVgck7gDKZg5hcTa/ZxSJqW69QeUX05EeHQvOCsR69U6iYlLbpK0JmqS3/MkGBcKuwuC24StkUBdVS347D5xtl1uuApdqNwpbMh7jEO1L1qjFWy1oHzQP3Z22j5ta1hgPPREKdNQJnXdeeIABE/YhAw3BdWiOwCoXzFSIXFasNCFBeDiSGJFzkmxuzj7M+qjtzmpTu2O
 OV7ZJ/Ap
 r/a/2URCfYWph7YHYOVKzBOKGuz0Z55KNXbp1Nm4/YTdMglg/2KD1aUQhDQ+r5NljXM4z5H4Kx4w2U418nVQpPmf28o0kaa+s1YOd66vFL7uog8+a2ngf6qhm6POWIvRwJKhwnIpaVAwapH/ljRdQUsPzyqt9ah4+QEmBt9G9iron+1NXQv3xV4vuLXQjltRJZ8OwU398x1xOHiV6NSKw+yiCgu0y2QckMLEfPPgp/M+cH3DkawqlCHD2eSlxCo8gUX5CY/s1+FDos8IkIY2kblCkbaVcQUPjbALUrawLDqQWkVa1pkF+I/EOhwRS7tB5bXf0KqZr0WZcK+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move init_cma_pageblock() from mm_init.c into cma.c so it lives
alongside the CMA code that uses it.

No functional change intended.
---
 mm/cma.c      | 8 ++++++++
 mm/internal.h | 4 ----
 mm/mm_init.c  | 9 ---------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index c1896c0db63d..2843c4f59c4e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -30,6 +30,7 @@
 #include <linux/io.h>
 #include <linux/kmemleak.h>
 #include <trace/events/cma.h>
+#include <linux/page-isolation.h>
 
 #include "internal.h"
 #include "cma.h"
@@ -137,6 +138,13 @@ bool cma_validate_zones(struct cma *cma)
 	return true;
 }
 
+static void __init init_cma_pageblock(struct page *page)
+{
+	init_pageblock_migratetype(page, MIGRATE_CMA, false);
+	adjust_managed_page_count(page, pageblock_nr_pages);
+	page_zone(page)->cma_pages += pageblock_nr_pages;
+}
+
 static void __init cma_activate_area(struct cma *cma)
 {
 	unsigned long pfn, end_pfn, early_pfn[CMA_MAX_RANGES];
diff --git a/mm/internal.h b/mm/internal.h
index 80b9ab594dc5..25b6e767cea0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1126,7 +1126,6 @@ struct cma;
 #ifdef CONFIG_CMA
 bool cma_validate_zones(struct cma *cma);
 void *cma_reserve_early(struct cma *cma, unsigned long size);
-void init_cma_pageblock(struct page *page);
 #else
 static inline bool cma_validate_zones(struct cma *cma)
 {
@@ -1136,9 +1135,6 @@ static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 {
 	return NULL;
 }
-static inline void init_cma_pageblock(struct page *page)
-{
-}
 #endif
 
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1e11fd683292..ff6e9fb468bd 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2200,15 +2200,6 @@ void __init init_cma_reserved_pageblock(struct page *page)
 	adjust_managed_page_count(page, pageblock_nr_pages);
 	page_zone(page)->cma_pages += pageblock_nr_pages;
 }
-/*
- * Similar to above, but only set the migrate type and stats.
- */
-void __init init_cma_pageblock(struct page *page)
-{
-	init_pageblock_migratetype(page, MIGRATE_CMA, false);
-	adjust_managed_page_count(page, pageblock_nr_pages);
-	page_zone(page)->cma_pages += pageblock_nr_pages;
-}
 #endif
 
 void set_zone_contiguous(struct zone *zone)
-- 
2.54.0


