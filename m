Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E35E8FDBE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A386B0092; Mon, 29 Dec 2025 09:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A386B0093; Mon, 29 Dec 2025 09:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5360C6B0095; Mon, 29 Dec 2025 09:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9BA6B0092
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:31:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E592EBEF2D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:31:25 +0000 (UTC)
X-FDA: 84272746530.07.3902B1E
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0525AA0020
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:31:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf15.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767018684; a=rsa-sha256;
	cv=none;
	b=44J5fXKaezqRWE0E+RotQtDfalAs+0/Czor8eY05Tn2RzylJ1rSvFevnoGx1e+lx3web48
	OX0mTJwBkBV7IZLlnshQSrXjMFLqDi2+ahvHajrn+n3wBso4BIfjAJGWi6FIepK5YROyV8
	m9OOIKbNNYQzfkvC0hpi/Xlam9BDkos=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf15.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767018684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K2pBV4vyT2c4GBUcrUp/G3rP2JcNWZOiRH8LtGLdyis=;
	b=X4Cqu99MYd539VdOT10aterMNq+Qpc61DbpF4O2QDnKEO1ykq3wSIq6KjFnbBvxlOkcqnt
	DGEmrAa3f/9cuMKGA5xzrRpTAkmKW/7csjmzER1dodTy/7G2iby5L2VZtFfMHNPzpdJ+Jt
	yL7vr2tDqmaeHZ5iNUzIriKc91Fjs/s=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7f1243792f2so6051984b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:31:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767018683; x=1767623483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K2pBV4vyT2c4GBUcrUp/G3rP2JcNWZOiRH8LtGLdyis=;
        b=rwqGOXBpgDDgOd74kzqA7MWVd4nvFCvey7l4mht4V9Hm7gy9fmseIdm099ClGaB5w6
         Ykzh/pgv9BrKiUQTqP9P3YRzonRyw5LPsH8Sew8K01XhPLnavAGTbLCATfUr6sDK+9ic
         tqnsvMoLItF8wwfM+41LO7XzPOYdkM/gfvhs+LbBzlKy+hU5GbcNWwCYlEDmMN0Ou3it
         mR+Its4h6BDrSK6E8rhaorJ5/Rucbt9SR9glsquhJNeNUtswht/D+HWiHzJH2iSeA+4h
         YzvZhju8tb3YJEK2Lu9TT03qFx4nyLeZP8CVW28vJaFNGAVLrVehSkH2kNWFC0DLvdW/
         WnDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSgXo/XcfZLLyhIb4yb3rKVyBBgPWD9oBOZZvUvB6ihQWWj/7rfTU9jiPUUjiffFw6P9DnFZ+PPw==@kvack.org
X-Gm-Message-State: AOJu0Yz9sn08HSWjb/Ai/cxTEg+1oGrHIljYRbmDx1wuoaqaTJd7Eris
	c3zPU1JOlupUZjatRYn4mBqCB89nBlMSbfo7d76XrGiqHdKNJml6nbpl
X-Gm-Gg: AY/fxX5Q6aSEG8u5HmQvw9GJV/QLiCWv/eegnHOd0BLm+Gpdw4XvlbfWGXSIZmle/W6
	PuZseFoWeLMaIy0pZO+3hdaxpNZUuevlX2dXRNnO5RLrZtTdVVOVCTEGkywVK67tlHhY+DApwgr
	uMGNXvLH49bHLgVL3Z9tYSQ+Ofl7sdnY1Svc0Y/Lx1GbsRDGewMqWGkfW3IzF4ODaAU0Dzyrs9o
	ppB7taaGmhSVFBdaa4FcU1DAPTwx8mK60+/2duQBB63D9sBx37qJzMlbBLkVAPxryaFjytxgAeT
	UHU2mKf66vdlYRpI6hPyaVuoHF8Wc/1HvTxrAPQ0HYLaH9mCPMatiTWBdxGeAliwmpv4EaI4WJR
	9iiVxcp6ga3bbBWO46doLM0ANO8YnFPT7zD9tz09xZwUcfrU25OLADH07rHpmj5VLYRBF7qneOG
	CE7Ysv1TcTxUjqrWjkjkAB
X-Google-Smtp-Source: AGHT+IFiw887UMmrpccqqPDuA4Sml65dVXg15rA20Xbw/FfFGKW61CmBXpyhkJbsrlAp7EarY75hqQ==
X-Received: by 2002:a05:6a00:8c11:b0:7fb:c6ce:a873 with SMTP id d2e1a72fcca58-7ff64fc5fbdmr25731812b3a.5.1767018682758;
        Mon, 29 Dec 2025 06:31:22 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7dfac28fsm29705159b3a.32.2025.12.29.06.31.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:31:22 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RESEND v1 3/3] mm: embed TLB flush IPI check in tlb_remove_table_sync_one()
Date: Mon, 29 Dec 2025 22:30:33 +0800
Message-ID: <20251229143038.73315-4-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229143038.73315-1-lance.yang@linux.dev>
References: <20251229143038.73315-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0525AA0020
X-Stat-Signature: 3wdkxqsxfeqyznmtbu7eqq4qws536stc
X-Rspam-User: 
X-HE-Tag: 1767018683-445427
X-HE-Meta: U2FsdGVkX190uciRn/OfPGziXTbf5lmwDf1S3F3gfvKoceSMakSiWdTYHr38BnYhn8rQ5+4j1zK0aqFoYerATKkdDjdaIhKRBIN+q4hMM9UZoHeur2DLiv72g2hrWTynO9KwZagUjpVziz4ZT9r5rXRLrzIXTTAsMwVRBlIpSbhdGqDCsTQIgc/Y3MPvYkGFwJ3xuEbR7VLWdDtdoudLnMrae5pm8QO5vrWag5tCb/IAZGO3grVqPPLC18gRIskTNTTkC3grZh8VPNY8Ki8uT3J48XmBp6eKy3PBvD+nj+x2kXxBMPEQ0+5xBY6IUxNAw8GP1cEmNtex7r2JCF8ovvx8+UzSA6V2E0d60/JtephJ/aht0lxz5PvHMs6X5ex9gQqxjTwob6mzTW3o0YmzdoU1a1QkOzGH+EodwvpKabpWlz8vnZUsYBR6HOTjB31Da7PhPCOU1L2DLYlRVSe1F+oBQjHdgns6Dn4oAh2AwyT45C1k4wPBQT5gsk1e/TJmKR1PsfD9tSkHGPdkqJYwVKcy1QL02PxrsRJrJshpZ28Rb691+/RJn5j/9fahpTypMUgmMojHNbI4CfeE51vdc3U59DcFy1fgRuatGSfpzVYlZ088/iCnh0VpwnU+712dDbZvFccLKZ4eYqfz9sP1pueGpNY7zAhXFJJBhvNokrmndGQEaS/uS2sRynWS4KoclctPnOvM/i6iSmCZsjr7OeK6/EbJipwUEXAhDXwIA1KjFS/PWO6hElkOTdXRBZEsN+ItMHkfZmRsr9O0iAcMoVzsTfmxBz0N0ElsASnyTgm/i25q6CAUSOGlXLfJeFA6JEFG5BUgz30tSBKPZoyCyelW0HHzulO3b79GsxAH3eMyaiSuAPcDMpXhal7+b7CpI3gHvcaO2vYYEXUKszTWlZ3GV7v8HL77pK0V8znt67BiZt8oY8EuKsTosC5npRFdhnRepmCvshxxoGrFRQ2
 Nhs4BTDa
 eL0zw5T4390UtYGyrvL06f9NhcezzHwWI44lvsUYBetMYerRcHVC3i7lcmmj4JrSmJNWbX9lMcsrA842GiFhr4lQ10LUhwYvQ9RODOKdakJu2p2SUDJy0N412b4F8E2B4aPQdm4qhVILDW1CtWxU0hxmRN6GiPeXA2oJexlQGvEvjITcgItAyVoCos2ulwBJfQrLuW7RwK3qI+BLaXlhkFIJzdscmk68JobaKySs+T+qitku6LlMjLv68/gkeVNXM9Kvrn9gXbY5AqwjFusK0Fl8RyERFwri4UAnOwywZOBEUtp3H1y9cBP+z3B7XSrkY6YTEpfhhzHyPWpseXkrfnjySzOZXXy7biygXgSxvkQGHH5kbm+h6vsr7hWLx/Kn2K1/lUA9Hk7hJC+8wkTYnc+SYhxz/R4a1P6vgorJRpKH/TKcdbZRygEPEVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Embed the tlb_table_flush_implies_ipi_broadcast() check directly inside
tlb_remove_table_sync_one() instead of requiring every caller to check
it explicitly. This relies on callers to do the right thing: flush with
freed_tables=true or unshared_tables=true beforehand.

All existing callers satisfy this requirement:

1. mm/khugepaged.c:1188 (collapse_huge_page):

   pmdp_collapse_flush(vma, address, pmd)
   -> flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE)
      -> flush_tlb_mm_range(mm, ..., freed_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   So freed_tables=true before calling tlb_remove_table_sync_one().

2. include/asm-generic/tlb.h:861 (tlb_flush_unshared_tables):

   tlb_flush_mmu_tlbonly(tlb)
   -> tlb_flush(tlb)
      -> flush_tlb_mm_range(mm, ..., unshared_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   unshared_tables=true (equivalent to freed_tables for sending IPIs).

3. mm/mmu_gather.c:341 (__tlb_remove_table_one):

   When we can't allocate a batch page in tlb_remove_table(), we do:

   tlb_table_invalidate(tlb)
   -> tlb_flush_mmu_tlbonly(tlb)
      -> flush_tlb_mm_range(mm, ..., freed_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   Then:
   tlb_remove_table_one(table)
   -> __tlb_remove_table_one(table) // if !CONFIG_PT_RECLAIM
      -> tlb_remove_table_sync_one()

   freed_tables=true, and this should work too.

   Why is tlb->freed_tables guaranteed? Because callers like
   pte_free_tlb() (via free_pte_range) set freed_tables=true before
   calling __pte_free_tlb(), which then calls tlb_remove_table().
   We cannot free page tables without freed_tables=true.

   Note that tlb_remove_table_sync_one() was a NOP on bare metal x86
   (CONFIG_MMU_GATHER_RCU_TABLE_FREE=n) before commit a37259732a7d
   ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE unconditional").

4-5. mm/khugepaged.c:1683,1819 (pmdp_get_lockless_sync macro):

   Same as #1. These also use pmdp_collapse_flush() beforehand.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/mmu_gather.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7468ec388455..7b588643cbae 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -276,6 +276,10 @@ static void tlb_remove_table_smp_sync(void *arg)
 
 void tlb_remove_table_sync_one(void)
 {
+	/* Skip the IPI if the TLB flush already synchronized with other CPUs. */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
 	 * assumed to be actually RCU-freed.
-- 
2.49.0


