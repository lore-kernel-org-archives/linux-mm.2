Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27123CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7EB6B00C3; Tue,  2 Jun 2026 06:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868526B00C5; Tue,  2 Jun 2026 06:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758C56B00C6; Tue,  2 Jun 2026 06:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA5B6B00C3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23A411C2085
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:31 +0000 (UTC)
X-FDA: 84834555582.10.F0E4BE9
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0F71440010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="kPGzuc2/";
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DnGxO1Udfe58Wuis4xgFsB98Q+Og1N+BThJGTGl24kM=;
	b=0yFttufHVyhCAaD1T+FTH21Nj2QJHnAEjsgVzHJoa9TZigrCaa2XtaAqym22eFF3BxalGC
	5IEvdaKB6T7GngmcvaxUcVEyaHQxaxOf7A+zwnNO7DuNsaheQGiT/Pa/OHzqFn6Uy9wlvI
	ORcD9+z8pdZDdO/0N+0UPzgnYL5mQqg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="kPGzuc2/";
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395089;
	b=tWDqkw20XBIKsRakzv64CGQ2tzqVtIz0SGmSfjBLcY5MCCIJafr80ooxE2+PE1pa+H5ydc
	rgTPRe+Ms8Hs81B2W0upKabOEed3ky/Gia5yYMahblBl+1DfUyKiY/0f2gFOQfx8daSRf6
	FuRcx3dOl8S1cfmWJTeE6ei8JbbJZIk=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8422871b42dso1600636b3a.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395088; x=1780999888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnGxO1Udfe58Wuis4xgFsB98Q+Og1N+BThJGTGl24kM=;
        b=kPGzuc2/bJSOQWBpRWOxdPJPzcFArp5bnY9G7zS3+laLzSWgyR9jU3jV53l46HXjCo
         5klV8+xf6FLsggVH4my7x6M9gUWsALtPn6hXDAMYJxJ2LH4QzxJ8HAayGvasmmkEY6IH
         aY/HQzk7d1kp5Qgjvudp1LF6Do5ll5Iv9fmKwBQToXZNirtWUl8gpjHGKijVQKLsniqX
         H+seRBDbdnIaH2/9TAe5iPNIomrCch43vaRkFF0dMeoefsIrU2WwqteFohggtUIE8FXz
         kt8TZPf7AS0QyxSGSpUwymhPFsZDYDkoBizOe4yzVW863rHa0xUut4acI+y2LEO2NUCn
         vs+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395088; x=1780999888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DnGxO1Udfe58Wuis4xgFsB98Q+Og1N+BThJGTGl24kM=;
        b=EFt8/+50T2DzE0pLEXA96pquKAV1OarkvLaOQ9bYmbNdN72Au0EWgicwGBOQL16o/J
         tBY3b4Oo5gSMSykExylxbM2rgXd7MZ2I6jbEzTpyaWO81gGQZ9Vf+mrpFRJ4I+ia/ite
         UIIZAMRNlKIkBVjazjmZOnPJJRAbE/XbtV+yDZO/PLQPNawHT5lF8nm10hc78tvZCPS+
         qKokv7BX0sNgSs8DGmSPhpkjbpT+Z3o10gPXBvlsdg8iR2us8/WUXsd9rEKT+i47t4Tx
         2zrLa4ugpyYx/UUofLDHX/UsAn71Kzys4+Sm1w0uT4nQ9zkMpGNcoYpmE+dMg91oDfyu
         diPQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Q7kUWwyDDc2v8w7ibU0oVrheaKfg+tLZ6yJ2XuZJEleD5aBqk/Gb6zeHRcTxM+xkS2RViZOBg3A==@kvack.org
X-Gm-Message-State: AOJu0Yx/lqtj5BSoVM5GLJ1VIbJMd1QgbrPzF02Z2NLzRCSItxoKfpiv
	bJsk+M9nIaICgdujBoICvBbRBFQoQRkFdgdzmna52SNftZu73DcBVovQXPqtwrLIM28=
X-Gm-Gg: Acq92OF6qgtSHE7rIMKJxRYFNF9VXjOfl98SHRfulquQUuTK4mb+dI+V5AaOqw6Wyi6
	DrA4m2khiCpZzC8VJCxglqAg8ug77qI63J+B8vMpxCLR0viQpVtGSbMkKNxhz8l1hPPNpOmtxwV
	azFRc4dAC4aZBeBMSEmIZ2rAAXD3T98RN6tBEA2Esq/6HR/nYThHlX2OjhJTa3cxI+WD4gRkivq
	uDw4sbL96FHl4fPOzBIdQwakKxUKL7mOItZK1a+kpKgKl/pJmJW8zcRLjx6jCvzlfLcVONKBLnZ
	zGdzGQvKxTOS1ZIKLLvct7YlVLVWZvQR9fcDw0CbFzCcMNFUBbrsm8ZqIgghE/lUrUTLhoW3I6V
	nnl6WId9yT9QcMjOzs9oy2+Vsh8WeEyaA/cxTHNGmAvhm+IXzh75I8uqNwmNzBuBCZPksalRqpa
	bJ/4vJ1hg9mUPZSskqawiWZBmYMylMg+h203azSC71IASLFJwOkQ35SmuuATOakO2cIA==
X-Received: by 2002:a05:6a00:348c:b0:842:5c60:513 with SMTP id d2e1a72fcca58-8425c600b94mr6788288b3a.30.1780395087753;
        Tue, 02 Jun 2026 03:11:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:27 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 07/19] mm/sparse: Move subsection_map_init() into sparse_init()
Date: Tue,  2 Jun 2026 18:10:27 +0800
Message-ID: <20260602101039.1867613-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0F71440010
X-Stat-Signature: 9wtmx1737iq6wt6gy3m3eo8fsii5h73f
X-Rspam-User: 
X-HE-Tag: 1780395088-765001
X-HE-Meta: U2FsdGVkX18xaP8GLmaw1Xo14+SsM+cvqSWZJ6C6CZyjCx4ND5VOosTFVVKH+7B4Fg/q6wfTX3d9VvpmpnwGuAqkP5ES7XAhC6ysFt2UoM3Gr7S8fcUHddxJAMjJ9C075fC19vNsqUn+kCgp/ayEBNAA1DEOU+unSUhDR6UVFosVg6b/0BI3/WAZIVkkd75x0qMTTMUa3BrtPCVUKrxg3Q06MNmWSmb/rjMMkNidNkyuq2E9rvTM7kQLk2SYnna2paZD3PDfENBh+nqSQk8kz4R1qLCWU1EkYS77nEYXhT7eyphfoEX74CyzMI6iT7kBBPleAOGyy2SeYnAUY+lZDopxmNedxWSJXeUAforc+xs+JoCwalVdeGtTyF6fYmzjy9KdJTr4RShc9vm4qcnMBSLzzkFtxYTyDviuFYRbDZFYYyW9AN4HmEU4AgY7/MyotSmxnvir/rHtw3uVY4D1pGmJUtI1firwX6+ooFyug1n58beH8JXOUccdmSYPpR7kZZtXFx4fYu5uCXuPKiwaJAggSBpGGZybOWgdyuVS13OdKqXYK1c5AdRDUp7QWcP/5AKSuwXAmltlsGbuZ4VyoIDL/XoFWWOvFUfqnLakCgcAimVwHIU7rFpUwZ1EajDyEyrNZkd6szDwYZ41Jpez6r5iZ790v4C8Q9AYxRJJC+LUS9Y+w4KAJX3vg2+v7gJyF3glULTjdfutav96kgWVkwGginMTNQa/XBWAiJtAk3a4FSFOR12f0XlN4JhdQiSuV8r35RZincSpIec3MCqFHIMMUkRUbetG4MQk+POVnpg+5WWvpFU26yCDrAd4etqZz+8G8D9CjF9ZbeiSY9o96XOnC8mJTBkS4dKh1+wwQVTLw9wCbm0BIKIsYtrGbrXG+fGe26U9hmUnn0ETNgFMPyEkkohw58dgJzNBxdsHW4+OxVMdu14Dmf3VE9UcmkefVPUlFI1NNKm2ncQ0RkX
 v7NzwvLg
 V1Drnz8aOCyxRuK3c1wZZcpFZdotUDyHYW2r1s6YFOzOaUrexkd5xN/Jj2GKAF9Lt0yO9TGxnn7RvRMXtHR3zGm2APpJigp8MWB26BNUjA4V63J6rjnYxwkdkGY2p5A6aOKUKU1W7cHTXK5PnotXRT9Uvs3pDxBHjI0ufCPaVywdF6Lb8+Hl+BIjTBvqcibM1DZfGky/cv3vylRICSXLBXu+kUrA51u+1cC7oUwWnj7HplktEL925OWsEsKncInGV9Woioj+SJonyTzoqIXTha+ZNQpg8s+VNIt3rj4W76ZW0sZo0VtkzV7e/8mBcNytM1ncXmt7DF26UW/y6BmJWHV4N/tXvDD2EWvTZArQGUSGMxxUsWWTu9U18gbyz+IA8epeOmz3P1hC/e+TpTmwFauR2rhtM7GRT/TeLctyaHx2XHr9Dr1beiYCFtjDKqUUj0BwlppPA8NYX7AQQreXCVuGjKKEuDpLnJe5h94j5soxklKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

subsection_map_init() is part of sparse memory initialization, but it is
currently called from free_area_init().

Move it into sparse_init() so the sparse-specific setup stays together
instead of being split across the generic free_area_init() path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v2->v3:
- collect Acked-by from Oscar Salvador
---
 mm/internal.h       |  5 ++---
 mm/mm_init.c        | 10 ++--------
 mm/sparse-vmemmap.c | 11 ++++++++++-
 mm/sparse.c         |  1 +
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5602393054f3..e71ba519f7f2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -994,10 +994,9 @@ static inline void sparse_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
+void sparse_init_subsection_map(void);
 #else
-static inline void sparse_init_subsection_map(unsigned long pfn,
-		unsigned long nr_pages)
+static inline void sparse_init_subsection_map(void)
 {
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index be652b6990a2..3a57bf5a9b46 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1879,18 +1879,12 @@ static void __init free_area_init(void)
 			       (u64)zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
-	/*
-	 * Print out the early node map, and initialize the
-	 * subsection-map relative to active online memory ranges to
-	 * enable future "sub-section" extensions of the memory map.
-	 */
+	/* Print out the early node map. */
 	pr_info("Early memory node ranges\n");
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			((u64)end_pfn << PAGE_SHIFT) - 1);
-		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
-	}
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index db9cfe57e827..3b036251a2f4 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -596,7 +596,7 @@ static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 	bitmap_set(map, idx, end - idx + 1);
 }
 
-void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
+static void __init sparse_init_subsection_map_range(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
@@ -619,6 +619,15 @@ void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages
 	}
 }
 
+void __init sparse_init_subsection_map(void)
+{
+	int i, nid;
+	unsigned long start, end;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
+		sparse_init_subsection_map_range(start, end - start);
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 /* Mark all memory sections within the pfn range as online */
diff --git a/mm/sparse.c b/mm/sparse.c
index c92bbc3f3aa3..85557ef387c7 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -361,5 +361,6 @@ void __init sparse_init(void)
 	}
 	/* cover the last node */
 	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
 }
-- 
2.54.0


