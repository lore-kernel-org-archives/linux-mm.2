Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76EDAEEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE97E6B00BE; Sun,  5 Apr 2026 08:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0176B00C0; Sun,  5 Apr 2026 08:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6B76B00C1; Sun,  5 Apr 2026 08:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BECB56B00BE
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39B491A0B04
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:56 +0000 (UTC)
X-FDA: 84624499512.19.742D16D
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5E3DD40004
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PW2SOaEA;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqgbPUicXY/csWEcQb9KuYcgGnVxfQn/0ErN/EA6ZY8=;
	b=ODhYmjge2OOuyfpq24Lgx3VUJcQEjYYiqaIZPBQtHDpr/aemp09kArF4j5IHv7l0N0Xv0q
	GbxQinzPPVTJpDEvsSD5h7yUdhyqfOyOkKta6v8vq45ImWGA9vx+uHu4HnAmUi/pYvEzCG
	zA0Q+bXHFc+hIlAs1kpyO/SewwFSRwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393754; a=rsa-sha256;
	cv=none;
	b=Au8XBnoXfSviTogZAVueB2DOZkJp5ir7fEqHQXlGj1YR86Yx54tK7g8f1QllWybkBTCjdD
	l0KGNg6Bh4VpJI6/Un8QKNPtm3kJ7dcET72KHx/UprnOh5w+2YeIjOzFg1dAR3C58HEdtU
	uMt0r9PqJKBqtxl8Rm6Z2JST6bGxWkc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PW2SOaEA;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35d99bae2ebso2818951a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393753; x=1775998553; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bqgbPUicXY/csWEcQb9KuYcgGnVxfQn/0ErN/EA6ZY8=;
        b=PW2SOaEA3WT4M8gdMSQTN2135R8twaNo0qQAW6pSl0bXY11S/MHRZpX8jd4J6TBpdq
         v855xeKQkyFzrxdsTrms6ILB31s7MhU24gk0MjLFZN7762+rXT5QBkxI4pJm3GFE1ASi
         2K6oN5KYSw8lwon9qacUSsCgdLIOQPAqKq39KMf3++V1FurmYJBm8+lb+/CMDwIAlNN0
         q7FqWkVHjl/4RfW2TG0i/bvNxkI2s9v07Uf4Mpfcd5NiOMBx4131FsvlQTKZE9L7yKJf
         6nkeQeHd3fU0hNMrRz0PxboySZWdZYx3ICwlaOhFh7AeCE6yQilE9rHInXpF8Jo1QFDz
         uhZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393753; x=1775998553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bqgbPUicXY/csWEcQb9KuYcgGnVxfQn/0ErN/EA6ZY8=;
        b=Y8NvvXxDKlQ616oT9IqMnIOila90p6s1uBPZtMtIdUpTkdZA29ZIZeyB66iyM0ZNOz
         H1W7JPusi26YVb11v/6ziyloSjyMzFtZHAEStc90Kves44YBt5AOKe35Dk2BnCQ+0Fw+
         9nQi0xZnPNx9PIw0A6fPmvVz02BmdL3hTFjrCqYA8xRG64er7dVfFcLritqMsy4bCDRF
         YCPNwaifgPNX0yeHP2/RmSww51VbUINiIVpiJpVlTF0u96aciNeiHzpHFLBvrtFJ6FrM
         b9vW2oig3nACzrQGdotVV6F0R5R02pYekI9NySCArsb26B6xpqb6n2P4NGp35g3/eKlV
         L2Lw==
X-Forwarded-Encrypted: i=1; AJvYcCUpYe+qoqhKjTbAlqm7XXF5k2vwaSGO+AF9aVLXH/0c7M2q4u3/r4CA1E5JAYeY934fN1plZ8WnUA==@kvack.org
X-Gm-Message-State: AOJu0Yz4duNCyl8saIeRIFLIIqFka7dYfWpBEYLKbyTybEV55DuUdoRZ
	AEn0mV4hxz0PtgbWQ1uW9bM9Cxg0HLW8vCK3eo69CF3rwYPTPcyy6AiQubXzFMe/MW0=
X-Gm-Gg: AeBDietqq3JePNEvPCx1CFQHsWu4+HZVp9ASSTXxny+ONteAJlzQt+U3sx3ikwwQSxt
	xIe9RNI1jMChZAhd9K6pw+ddCj5Vf8LJhGnd3PJlxZVRT3YdTYOxxEfjx8e3ijFQlk6a6jwe77I
	RM7xMvYX8aapx2jOavpycts0NMYfdu0JMfUtmT5hmP8GnRNrM9CqzTeV8TPbvhpThc/q5RSvJrx
	u5+NWn7AFGZq9C+S+MnbZ07cW36nkNDuttrLRH3DObVffLtkFRLiZYie79T6Rqi4oHuozDmjQf5
	tsqDBvX8iogrOjzGnYF2oWdnl9VQhuJLaJ0BvoFyKdbmCTiUxtV67haH1uPEY5miADz3hEc4wCO
	P5WPqAmf2Vu+PQs9pta6vTi0eqUzW5Y+qwvPhN3rwumAWy0IrglNsfW8cOVH4mLbSG7EfWZXt9U
	iL+Tr7BvyA2kcMVQiFKXpyb7MOQ3mOdTCC2hdUF3/NTwQ=
X-Received: by 2002:a17:90b:3a8a:b0:35c:30a8:319 with SMTP id 98e67ed59e1d1-35de660e4d6mr9096576a91.0.1775393753200;
        Sun, 05 Apr 2026 05:55:53 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:52 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 23/49] mm/mm_init: skip initializing shared tail pages for compound pages
Date: Sun,  5 Apr 2026 20:52:14 +0800
Message-Id: <20260405125240.2558577-24-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E3DD40004
X-Stat-Signature: fe5whawadzbagoxmdrnpauh6afki4hkt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775393754-835137
X-HE-Meta: U2FsdGVkX1+xVmdeJOtCo+hrEqpijKb2TEhpYX+pqMVEAI4uLAfgZDXb0YHC07iKeEpAsmuz4kgQDZ7dWI4fJ/wUGdA51uLaC9lBM5ERTxjhKDvEAQvgg7yAsV1XsZom5cluYcHg+l4rqb1A+qs6A0psjV8hGAYAgnLPWAMmdYbzuz7zsaalcwxYFkoi+fVRvhwZn3V/AB7+nrDHoUu/hDH7DxiiDpoVUFTT3iPe6XU+v3BEEvWqmRuI/HTFgSpCsBKVpRN31dphdCNkpKJgeb0fRAoSYJxW1LYXQ8iqPEaYzrONAzGsG8BK/La8jEIj3jWOqPkAb8Ugie4XdvWvuRmRp8bg2CP+Truah2vSox7bS8yyAIxJOm395ARLFy05ndAiNaqskaX/M+qYfDwzK9RCjLpDW25UzrYLKaNgJJ84jJmFqaLpXG9l4YcZdxa6dMzB/jOJaCkZ87YZyJ9pO+FWSsDIQNSexczFovi5OU7xD2qvN1VTXKFoJcyjorb/BNSK481H2HPKZqaXzwv/Cgh/bbvoeWCMWQ7Z8OtuTfOqwLaAfrmu+hfpDmbGfQyZcdUDIzOi6FQbgAse3T7r1WHMYGZqmZqN+bxmxZ2daWe2E7xF8ILM7JLGwEIpjYad192SxbIqnu9PVbvcTTA2hxfa82KBiKNrzhRMZeWpIFKXPUUGkw+9JZNXYUw8umuhauoEmlS8JTt4ii6u8O23kYs3odXimzS53fskVJA84CbOadZz0TDPr5q7vqWmgcmkqObf/qij4IBFDY4hhnSAfZYZAfy+RCKZJafUKd9wS1JGYgMsLryPLtJ6eeyJIkt0wGO5i8Vg41XVWPpxszziLVl1RZ4TQLRKpuSGHyhlCsRDqHS2TJCkZXqUSbzqL/uHvkEPCuJ/KnISlNn8pkbrq5iP8+t7EReTQYsQYC63t60EZRPKjwJv197thiqQ/SY6rD0TdwBUO+wQqxDoAaK
 hE0W9XL/
 S/LUnnUFJihl8qZPLPLounVEvECeDbUcTKJq2GYrtgmg9NQIbSa/kz6W8bSOuAV8KgMKLuMqz+Cnlsu1rLSEYq6uO5gqgeIG35ugzWAvue+it8G4eNEwGBgSO1RkCpLMNDPTeWUYI41oRyE230TJiBGq2kavFsHRpu9EhZ/svD+vsET2ZjPcal/+cFwv0ykM5XN53XrozuknOURKucgC/AZ/GkM16ENUYqjIzj0HgNhaMP2mjyGaC5XznzdnIsObj6Y4DRw0xcZF9ptdIS0G6UKHTNu3tyeBFdjdEFCNt7hz7NdZ49KSGUIsQxPuC7NuY0i9sv/DV26SJekgobTlBHjxom0rGuPxoxtes56CbKgtLXEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, memmap_init_range() unconditionally initializes all struct pages
within a section. However, when HugeTLB Vmemmap Optimization (HVO) is enabled,
shared vmemmap tail pages are allocated during the vmemmap population phase
(e.g., via vmemmap_get_tail()). These shared tail pages are left intentionally
uninitialized at that time because the subsequent memmap_init() would simply
overwrite them.

If memmap_init_range() continues to initialize these shared tail pages, it
will overwrite the carefully constructed HVO mappings and metadata. This forces
subsystems like HugeTLB to implement workarounds (like re-initializing or
compensating for the overwritten data in their own init routines, as seen
in hugetlb_vmemmap_init()).

Therefore, the primary motivation of this patch is to prevent memmap_init_range()
from incorrectly overwriting the shared vmemmap tail pages. By detecting if a
page is an optimizable compound vmemmap page (using the newly introduced section
order), we can safely skip its redundant initialization.

As a significant side-effect, skipping the initialization of these shared tail
pages also saves substantial CPU cycles during the early boot stage.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h | 11 +++++++++++
 mm/mm_init.c  | 19 +++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a8acabcd1d93..1060d7c07f5b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1011,6 +1011,17 @@ static inline void sparse_init_subsection_map(void)
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
+static inline bool vmemmap_page_optimizable(const struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned int order = section_order(__pfn_to_section(pfn));
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return (pfn & ((1L << order) - 1)) >= OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS;
+}
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 977a837b7ef6..7f5b326e9298 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -676,12 +676,13 @@ static inline void fixup_hashdist(void) {}
 
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 						       unsigned long nr_pages,
-						       int migratetype)
+						       int migratetype,
+						       bool isolate)
 {
 	unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
-		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
+		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, isolate);
 		cond_resched();
 	}
 }
@@ -912,6 +913,16 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		}
 
 		page = pfn_to_page(pfn);
+		if (vmemmap_page_optimizable(page)) {
+			struct mem_section *ms = __pfn_to_section(pfn);
+			unsigned long start = pfn;
+
+			pfn = min(ALIGN(start, 1L << section_order(ms)), end_pfn);
+			pageblock_migratetype_init_range(start, pfn - start, migratetype,
+							 isolate_pageblock);
+			continue;
+		}
+
 		__init_single_page(page, pfn, zone, nid);
 		if (context == MEMINIT_HOTPLUG) {
 #ifdef CONFIG_ZONE_DEVICE
@@ -1138,7 +1149,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 	 * because this is done early in section_activate()
 	 */
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1963,7 +1974,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
-	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE);
+	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE, false);
 
 	page = pfn_to_page(pfn);
 
-- 
2.20.1


