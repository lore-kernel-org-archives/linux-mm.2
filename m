Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52365F94CDF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDA066B0093; Wed, 22 Apr 2026 04:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A1A6B0095; Wed, 22 Apr 2026 04:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F806B0096; Wed, 22 Apr 2026 04:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9703D6B0093
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:15:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4EF7216160F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:15:15 +0000 (UTC)
X-FDA: 84685481790.26.E4BE96D
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 690EDC0016
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:15:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FHOszmce;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845713; a=rsa-sha256;
	cv=none;
	b=SJMvOsxSCyYy+mpYVYsnTFBlaoaWDs4o+Z9eeV6aMUIC9vjW6uZzi5KeG/VQEsmwAhEjRb
	8QB+hJO/bicjwLkne9oEuQV4rAKBcs1us6GFyrhHlxs6YxwVGSJGW6CzW2OerS5KYZifTh
	ddE8BxXp/6MFzbB1+kayvMo67eIuSl0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FHOszmce;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoaHiX3AHT0NhATrQNxOKRmMP5bMIl291LjVzN6aqQg=;
	b=WNg77XSpBVI0AHfyTH2LhmP+UBghUBlWyocS7yrUpPzbCBvXOxFlFUOfOsbOlWEEiJgJh8
	bMflvxmQRczorAtdBLitzfsKER8Erhyh/d0Obk1aGFUPum3fU0D7C7T7bv5mRRcOCY6gor
	dEXD/9eo5mzPtvyIjqAtgamkuRIg9dU=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82fcd0aa2dbso803072b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776845712; x=1777450512; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zoaHiX3AHT0NhATrQNxOKRmMP5bMIl291LjVzN6aqQg=;
        b=FHOszmcevK/VVggW87GGhpjkv05zAThRqCe5sQrtI7bSeiehV9l8BTgv+8LxeJQm/o
         VmbvMAKHwhP2VWTLbH0rmF4dEsRLL3L3KAFJWGrwdJD8ivn4/qMrs8sxr+28mylylv+r
         x7HFwWx9yNzM+snPwroBwIIf1k3SVn3w6k8xRUZEEDWmFYEnqmQN3YwHGG1QBA/30M5R
         MBxe5KLsC2SDHnyApdEo533Qxj1NNkbhQ5Ja/EJf2fFwTFrJlox9cpvrSX6Ldu6NCXEu
         jUSPpimvnseWytFuW+P9T5lW5ThxHDGTEjbsjZ8cXdKfMFbKa8lfzXYW7X4CtHN1EPe/
         Fwbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845712; x=1777450512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zoaHiX3AHT0NhATrQNxOKRmMP5bMIl291LjVzN6aqQg=;
        b=LHiaLXB+8b8vNt+pVYVUmLmeGgRkztWh7GOSHzdEyPhdtTWxgQJKH7wQzevVWcW46m
         oPfe1a5yIqowLevB55imGS3IiXv7Nbu6UXVDIsr7KzvfBsCP2ysags9kgJi+CX56CCK5
         Q7sdib7bxqugabI5UEYabiQjUs8L0VArqC+o+l+bzVD7maDOh/bwm4cYUR0mlTFhpJTl
         Hag2qd3/aDnES4BUG5Nyt1fjMpNQbBZbJKjfzE+nJzVNPAc12DeC0haMrhYE/8KzZ7jh
         A7vUUettvyEAKN47IzTuwWOgpatkWPS4JbYbYgoCuEt4Vhmay0ktqlEis4PcB8M9/rRL
         N9Og==
X-Forwarded-Encrypted: i=1; AFNElJ8lZGUNYer9TvzywP8kLt99Q35Z0uyK2b5NU6dBLqtMXPDgApisyAPzojpiKFvwrP6fi35S249XPQ==@kvack.org
X-Gm-Message-State: AOJu0YyNzlc5lUdOsl/y0wnHMKL9ubzUzdTB10juD08iZOJtHQ/QKq7H
	TRf2vtGRsr+K6iDhi91Z90BN+cZfu3UcKcZRdJNjfR9R0U6IULopq7Jrl76ylLcd3qo=
X-Gm-Gg: AeBDiesoRNo8DOUaxxe/z8/6AXhJzSN6N9h5yDT3AEM0rkrK+FCsEdDnkWQmLTbTJXc
	lk4oKwHKLe+v3q2yGxpOe740HVlZPHoLX19rdVLIOhIAY2DNh9iU9djKFeUj2OVFBwkJFX3ddmB
	b1Cc5+1Rp/mTQbp3DuPoGjUIeuTDh5GJ4cghafgT17lS6oIHvqA0qMFyn+KCa5plMTzAZhotgQ0
	q/6MGzteFTVnCKSxtXFaHby7nZrAU0m1h5hKvXJh88FvWkZZuTkkjns7yR0ytLtc8VTtdizUt0b
	qS7YiLVf1NgYpFkWM7C6NwFQFTJt9hY9ktoIc72LfEzbZKlGnvH1AqIbKNoMoZ+Nk8jv4O2661N
	SSIiupmLuG6Yq0MhAosLfCnIDIzhLXN+rB9j65xmbw3wTRRs05pWo04mgVZ14+0g47ZqNBQpvxa
	CPeaKFwCJyDAs8l9BGOyKhJvkMBYwU
X-Received: by 2002:a05:6a00:2988:b0:82f:58d4:d348 with SMTP id d2e1a72fcca58-82f8b57510dmr17881058b3a.35.1776845712042;
        Wed, 22 Apr 2026 01:15:12 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec0307esm16522874b3a.53.2026.04.22.01.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:15:11 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE
Date: Wed, 22 Apr 2026 16:14:20 +0800
Message-Id: <20260422081420.4009847-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260422081420.4009847-1-songmuchun@bytedance.com>
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 690EDC0016
X-Stat-Signature: pjzzqgwoczbdnqgmzhg4gsobhh3yirm1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776845713-456279
X-HE-Meta: U2FsdGVkX1+N2MQTfusoQ1zfQkxgbrfh/v1XNsQ2ARETWIVIIaQNEB/zVSflg7N+vfamI8QyKsMeU6YOFrpdffj5ErxzL3z7Qt2frZPXQkXJW2vAnEHk5fKnZS7I1OYcjUCNXhbzcBp0zXA2HKFk8Wgg7ZwCNhV2qVfCOGZLq7bjz7OxS3b6AZF21DjzxMw/O9vrDl2SNEqQeD3toORUCq70yDLaIHDF6WdsTm4ySJvhEvU5JmLpS3OQq4tH5+olwgwLJry3682jRpuMGzkH4SqjrILQ5asbfvLiCgy+YVLxFUKjqKG5eavX2gCcQ8X7XAXl4dgaOia/XqMHVHUNL9GoZNX++mVRCgN+4jKTE2o0jSONgDrthsB87vcvwFcnNw43H0Fg3YUr/rcpAIMIVfDBj4/hw9lDCxuhUurGkTaz1XgUAkHOMFGsWKPnH0Z3wK8FItoPEZKZt/a+kqUr/3cvCxETWMQ5pjZDiOAl+aR5EkJrWxhZULZ8yf9t6Xi/SZ0zsZUY0A0tTnnRf5nfaNz0HHF5qoZ11AL94SwGn2QGKmWW2rT3KQvxLIkJWV+O4Y0JsZ+uR2Yj5sohs90KKf2TNMi8fy1oLN0CeaFpUd/zshGI/Igoe+TtjUgn6n2yvXXbGqwOBaO1ZoMTsUREo79H7Fgoa+LjvtLPkKv+tiSfSV+xR6tDzgAUvHbC5cgnq2NYCkYrct4AkG9w7IUzopedtES2qqpk0otoB9BlPFs5OTyt/g+1oh3kRhSDUWZAfUiSye/xLUvec262K5fPlu2wK+xB8ZRHeUCtGkQg9vVyAH3+GX5euiPhmyQBYn8dqiq8zmhOrBOHzT2DKqq2hV/pIUb2e9Zz1FxuJ4SLvAhGd7PQQV4cOTPfjtsRzfL5mtD7ZJNyH+gz/VDsX1C9Nc5XutUb556zu8Hz0MZoe1ygekTc9wIluIbneKS3Li0nNCKNoYtCDx80lb3fohL
 w3x7MMq4
 D8ORrCHrjlqD1I5LMWwU/lwPIhNY5Lnpv1zBn3QAAjnd0Dm/r3Kbyyw/xmuZIFzRLVMBU5xPbpy5dyUt09mH/Gf0DpFORaoqPRbSniCVaOUOd0UuTu7x24S59sbO2nzurWbGoxrrf99lbWIU4XPiDI/WjiORezai4wbWg0+FumUijf2YeGovBBE8ux0n+ijJ0IPF4cLbj3IvCC2nYhzrWLQ9iKd+lKWCSO8uxV+YAiHLmdPsATgpSbAtLgUUJ2bDmV6rCCLqu/U/qhkofBNxh9M8mIR7Q2yO6CPKpXI26Jei9BfKQCSS0c2qr/T2dHH83XyKQrrCAPCG7xV5oXXElm+rXVEYBhFfh9tQ6Fbtvtf+B1sUYJGV8I6VIJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.
However, compound_nr_pages() still assumes that vmemmap optimization is
in effect and initializes only the reduced number of struct pages. As a
result, the remaining tail struct pages are left uninitialized, which
can later lead to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9d0fe79a94de..3d5af40d0943 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1056,10 +1056,17 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * of how the sparse_vmemmap internals handle compound pages in the lack
  * of an altmap. See vmemmap_populate_compound_pages().
  */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+static inline unsigned long compound_nr_pages(unsigned long pfn,
+					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	/*
+	 * If DAX memory is hot-plugged into an unoccupied subsection
+	 * of an early section, the unoptimized boot memmap is reused.
+	 * See section_activate().
+	 */
+	if (early_section(__pfn_to_section(pfn)) ||
+	    !vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1129,7 +1136,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	/*
-- 
2.20.1


