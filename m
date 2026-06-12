Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEAD6CD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15BC56B009D; Thu, 11 Jun 2026 23:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133846B009F; Thu, 11 Jun 2026 23:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E446B009D; Thu, 11 Jun 2026 23:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E66D26B009D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A880C1403E5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:49 +0000 (UTC)
X-FDA: 84869906898.17.DBCF285
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id CAB5AA0003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PPhuEBXF;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okNQn7jBY8GYg30w4rV+l+0LtWk7klxQgPQSIxA5238=;
	b=Rv/q0lBA3QaysiijlgJvz5LCzMLq/EgEPUEGdelbGlGnkwLaoNIL2B/Sy+lSIf+vNdA+Fv
	wVEidEXk+3PM5fq4dIzXe7NKBT033t4oO8EqI6z52PT5I67IDwGD/wqmBYc6l1FmKOdTqg
	gzJjIFXvzd+hwbugZTFVPzKqtRUL9+U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236787;
	b=kA9kc/Af69xDxxa37jChOXo5oJoqrfKDWhnM3FF3p2btxIovkocE5JkQBaxNHFUlzlHOMh
	D/VuFplkiCBfRllPWke5O7IUgSD4/BdIMRywsyPaE6U5+OQcb6POZ4jPMK6CftfO5QBmM/
	iKz4xdTz4M6Jf5Hbwkge5m2RP6+IzP8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PPhuEBXF;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84234c83142so280972b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236787; x=1781841587; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okNQn7jBY8GYg30w4rV+l+0LtWk7klxQgPQSIxA5238=;
        b=PPhuEBXFOAOcIjp3Al18MCGpcdT0qRoS9LkQFjuSbYaALkRutXRwlJpGmnSYVSgcRu
         CSKpM3Kc286BQmCkMBd66WOLSX49+ueKaQHnV2IAcu8KSXceHjLksn91jLujkiLz4zTx
         1RUTEbUHmviD3Wy18mmocOPFqY74zrDjfBrAOx+MBcGm9eksXcdbfBlu/wCRNYJ6ElI0
         SirXPd/D5rIB+MyzC/nTk1LqIBoX+QLhn3Hz//tsoPx89/qfqSClfhuF7+8n/SojY577
         s1a8S5SkvwIn6V5mvdgw8qc0xTyIw5FXIJF6WWjtiied2kExaZN71QHt05OwP35DiIpU
         e9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236787; x=1781841587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=okNQn7jBY8GYg30w4rV+l+0LtWk7klxQgPQSIxA5238=;
        b=Shd1/NJPcaHxN7cRyqihYv6YjOIkKqHkCs4xOa5b9ObTygJ60JN+UM2wNPgO97JBdq
         R1jSDdaRFlxRs9V50e2pQtPV49muKWFdDMtsJkB/i7DZoM+Xtyl7t82mSlzKTvXod5XB
         kEGrK4CtWBnTSXLhJ2pe+8ZrFD4qI5vv3zgNHyNMSu1Lf/nD8zkftEHTDZj5RDOD40ZF
         TFvRIaBCJ2rc1C6ISGwXlNc10qfvA8vV2W9697Qz5lIQn8cwzl6ysNE9sMGp8xKFcb2i
         0Fnm0PitZDW22I/Nhfxr15Unyq7ZqasCqNrodF+t5G0FjFn8XpG5kiSHn/SBZ+5Mfg4q
         nBNA==
X-Forwarded-Encrypted: i=1; AFNElJ9R9+CsFLZbAmWXsgL5TPLVxlkqAhFbQYwLZBB5akcYngsrg1f9BMKvjkH3la07sYi+QdKaurkXWA==@kvack.org
X-Gm-Message-State: AOJu0YwJn8bl6QubNIsj1AYxTW8csrE02lwDMCqv84wSXsfmljEW0tYd
	Txk71ngJm9Yw9/cesO8ltLXFxXBAdisGhKt8sWxYIfE46l/ukuRogFxR/eBNnU21Jnw=
X-Gm-Gg: Acq92OGJIrLu1T7y1bUvDVMo/em9Ya/5CCbkMpP8cUqsUqCcrygomiTLmrfKljZXVNq
	lANdKU3dtvH7jWOg0mX18n5zR+n6BzMa468gPB/u3mMNNrDL4L3cFyLzZeakf42fF679mBC01PU
	/t9z5Pf4EJ3r8Tg+9fwCh4OY9xQX4gmOvhHki5zV3oEO7HGVjb8EwCNunI8wl3S5Szi/9uQA+nI
	QQdgsG+lqTvLLjINTfR0U1fYAQSEpZxn/r5dJKBGXDCR0VIclnLUsOIp/cArHO17/DSuHf5zU71
	aszKQMNf/JOWrp3tLiuFCxGs3FZmGowDE/JYxF4NxyKC1AHtF0vM5hARXyyRQTLjudvdQ5bLSlR
	6ipfNHSWhXsyLJvKZjJhnj+ztg+paQoJTZ17YanDoiZmE9vHJPcy1fagtq0AStWFT9MmlsC6dSS
	mnaMm7Gw3xiXVV4rnt+XuqzlrpfJQdwdP6OIIv2hd1//+81JIp/HvILw==
X-Received: by 2002:a05:6a00:4207:b0:842:5a8d:3036 with SMTP id d2e1a72fcca58-8434ced1de3mr1125462b3a.35.1781236786557;
        Thu, 11 Jun 2026 20:59:46 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:46 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 07/19] mm/sparse: Move subsection_map_init() into sparse_init()
Date: Fri, 12 Jun 2026 11:58:51 +0800
Message-ID: <20260612035903.2468601-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CAB5AA0003
X-Rspam-User: 
X-Stat-Signature: 3jdwy8txb8sxjwktzmiorwkt6fz6fai1
X-Rspamd-Server: rspam08
X-HE-Tag: 1781236787-206276
X-HE-Meta: U2FsdGVkX19l7q+HJqYb6IkfN6GzfdcRM/JI3wdTiXOWhPN4eMJZf0r27l2GjZvvYc7feSfAVSAMrzF/qJgx41mROz6i6Auh0AXIz1KyBatkSmf9gFeN3oLLG24tTdW0ma9dZmSzIAiszTfAJhYlOB2zXQtuSKXTwSTQx8Z6J5JqMp5sGws+9trs539rEf2gjNxZyJsj14FoDuQ5G0brQb9rOO6AS+mVkY7rpqlyDqSn6hD8zraxLrdebsniPz5vkrZ5yPWE6VjN2pZSWXHUVTw8voHGqdOiUjAX/pK9zPiskOzTvcboI0oM2ouojSqUrYhigXZ535/KgzK4Ozc+2L8eBLJBU46N6roSvr9AS0L2ofzjfWAU/ZO+v1X2pRa9Oo57SgPqUswDGPhD3B4OkJwNSB3s0kNP073lSlEJl7WmKINpPQsuqYI9FtYnqe+qLRUFGXi6DCmUcMeIHiDlUo2tyTtLMliQNZyWErOhlJwxTSyXzTze2Q96q7U5FwpOasS8ccBC8uvN3blT6qVsfyo1pAzVhwPhJ/796sC7U4idBGy0TWIz8Bh6INij15UW1VnNX0wOz+M5cTpOALbjXTDgmXbgj69tCd748U1mFozCe9uLCNHDzJmIH/WIEwSa79w39nYQb5nTVQTIiwGXSce4uowRe7wRTJjZ4I6ebLMA50YOYc8bKAzoFCrDvhbu9n3jKSQgpN42hdUZaCnD98xQGCkshSTSJh6eW4wvH7rwSizg2npI3neFpZlesBRvGUpgeGjNpIvMnviNoFKc+7IOPQI5cuX7wpvYpOPPRgS4zc7R9hYLUZnQKlaj0xRasdf9flAT1tmxU0tfiajISBo3bGOydrLbFPIeDHtjrJOb8nAmlylW21v4gJz2KGOIAr+2XDQktxi/pBerPFpIOkaudpPdNw3oIZSY9aFkQpHUXZ4FChOAtAXzXv0lu3D3t/rBQgwbFylW3EKvB+K
 dwP01dvN
 S4vdNN2azCPI4uwlKYQ5MsiDT+RNHwPlswvZyypJ0SoU4/J/uWovCne21BFbB5rrLD2VWtO1UCE8z7UXc5+IzxUvpYeGhVonvVEbfcxOe6Q8z5U2iyNt+PXX+oxTqMUi/vtDfctrtLvOnXE/2IJVSIZDCGqJsRZEiK8C05jhXL5adlB7o2OL6H8MT/kSIWfym7NsOVTMshVSxmmGQkBLTYvK+ALzz6hS20STQ+Narp1jKaokg6wOx/OZ0/LuL1XDmdpbAuS5+vkBYAetvuIW1Rv/8VOJlAbZ4w7Be0YEeUCUv2G0xF+x8M3KuMJa6nm3CQCc7EUeglqvHoaa2ToOsIRknYBZb3fNYcN+GExYScul3dEGXW7DbPnTkIDPJfuz6Jar75vxZLhvTUOHcDYEY7Uh4D2llY5CA86DeNuHG8efqOi+M4LiSQ0yxopfQmQ5s1v+C7cVBZUu/Iwiqqc3peSntOLNsFMfPO6iROb4SJDQLleQHB3gOLk7JRquoLAu+ytObLS6SAuovB3Zz/axSMkDAHGQDBiuUrucc
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
 mm/internal.h       |  5 ++---
 mm/mm_init.c        | 10 ++--------
 mm/sparse-vmemmap.c | 11 ++++++++++-
 mm/sparse.c         |  1 +
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..dccd4727de46 100644
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
index 5c7359693ba2..dbcd60a38c49 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1864,18 +1864,12 @@ static void __init free_area_init(void)
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
index 6e09000ed3e1..0b4019a93188 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -601,7 +601,7 @@ static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 	bitmap_set(map, idx, end - idx + 1);
 }
 
-void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
+static void __init sparse_init_subsection_map_range(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
@@ -624,6 +624,15 @@ void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages
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


