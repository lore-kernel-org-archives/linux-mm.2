Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC0ECD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16E26B00B5; Tue,  2 Jun 2026 06:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7D26B00B7; Tue,  2 Jun 2026 06:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1AB6B00B9; Tue,  2 Jun 2026 06:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 810ED6B00B5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:10:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AE751407BD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:10:59 +0000 (UTC)
X-FDA: 84834554238.02.37C9DB9
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7596F80008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:10:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fPULFKCn;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDasRSBzRzMBw4N3DGUFq9UV94c4KSJz0jxvz4ocu1Q=;
	b=s8whNPA02fXf8jRHntUR8MLOkFhPnY5G76zKESJKfiGVRrra9OAj6phEpveqJFHklTjH+s
	65Twn6Dn2MAVHecVt2L6LwY8FqYuAXKWGW0hXkAtnPkt/sKe0uwZTPkGmRtmfuCAKIwbfS
	TIzPT2I84E3jSQdPO0gHmomhTTOCbHA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fPULFKCn;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395057;
	b=zZgZtFrHNl0oZ55w+zHXIq86VHOo/OdwuHDUNTC+c4WIUFeDhwUpaguCxiAxI4W+k31ZRz
	U+zybePViVgH8WijVG/vKRfUGysw0lcR0c20MCA+lcsLolEo1CAOBTGV4Ya10v22pyKkyH
	JYwVsP2AdBmvhw2NkrngTLnwd8Ey5kk=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84229481d44so1079215b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395054; x=1780999854; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BDasRSBzRzMBw4N3DGUFq9UV94c4KSJz0jxvz4ocu1Q=;
        b=fPULFKCn+cBncBwwXjikH4ZRdS57ruh0y8mAhL7nAMn9r5eu+vZSaw3YCu379SWK2I
         GhYKxbRmhboQDp8Ig6PueIpdT9yKiHvMmpJYQ+VGrYBP5BSJmBaHOUotZXeskJQfM3Zm
         d5Or/jGmsUliEPi8oj6IZ5icfONPPJ16p/001yA6RcmNaDOf247ky9QipWkWLzBJ6UzH
         cSRDHor/JySrKZ8gHUBwBONHOj2lLfqRKhoW0b6OAo4FvFhxyU0evUw1i4Vk69uob+7F
         P7Ywgitj9gzU0sGB+aePtJC94QAPDfajhf7Xl+5vBfCxIqy56ctZ2GUdH+EhpJqqUKGE
         iZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395054; x=1780999854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BDasRSBzRzMBw4N3DGUFq9UV94c4KSJz0jxvz4ocu1Q=;
        b=a6b2BRfbgaAfR0cAaj/hTGL/RZD2A4p/RFkxN9rbcXZ4WVnmNeaOeKELjQ+K+zLaYT
         M4KjjGvlaXEKkFrAO+juIq8ubdYj0HDu+ArHxuUlKn7xwmuCepVEo7/Tgp25Cw0npn58
         tU+GzT17InrZToI3A0rHUwmuRxRywPPS2Bo3mHB8e9qzCLGtHGdnMWsGepbnEGXgFXXP
         H61aZuHipqHleJteSnwnF1VdQP55hSPoMH+FCzRyGOJHr/MqJByI8EnoRNlYC76uKDCS
         88oERkDrMEMME1t52jl9Qu/4SzBRZMo7JqqUC6SHMvONqGbNwGgSl+sBAiJlD30pIg5r
         3Jpw==
X-Forwarded-Encrypted: i=1; AFNElJ8RC8DyRLQqH7ER6xRK5Bu3S9yGhgZ+jGxALaQp8BfpA+13N6JWp72Gc3dZuyBjp6iE7j/SxAaY1A==@kvack.org
X-Gm-Message-State: AOJu0YwdnPiHHcsX828pssmTIUWI2fCgKeLeUYd6lrmY2YocguWla4b1
	c9M7brkVr3Ne7tU1wdEtsp+kHoES7/UjgXKLd0n1Ff5arxXEbB81/8HAinDxLFMwpY0=
X-Gm-Gg: Acq92OED+qJOJfVxdRvuOrO5mObeqjsouZy1P/EkUDZDKWPv+lRbGnUolaxFvfsbJOR
	R61Amj8lr6bWS0Bql4xqXHOvFDha4HXA/K8WYwFi9zbp7iD3nh+zDhHnguWwftTOWUhs8sH9G1a
	x/Hss1saSu+284cxie11EzfyGibeslZhQ48orsdgCFOCy+iIQBiNTXduUjW3FXyZU7InZLWquT7
	LpLbkXbZlI1rJ6VbJM7ZDoyMyUXwzHb8PpbNXoh8Q5SiNR3mt8ZdRbyVtIqkve0sgkVfkubWYdo
	oCllEbHo/86H/JkqUIul/rT+NKqq4PKt5v0nxi0Sf/2/VCp+5cPmWYmUtrJYHOkMheatySFjYOJ
	aCFOY98CVzshchPehrhExqNPvFr/7yTpYnhpvIS2JL+D63ifWAstpG1shoq9I3C7qloc1YqQjLz
	YxjV66R84IBhvbH2aA44FBeo3EjE6TrsaBvzZ4j5RrFIHbvy06Ci3rbaU=
X-Received: by 2002:a05:6a00:4406:b0:842:4327:6cfb with SMTP id d2e1a72fcca58-8424327755cmr10725987b3a.46.1780395054175;
        Tue, 02 Jun 2026 03:10:54 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:10:53 -0700 (PDT)
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
Subject: [PATCH v3 01/19] mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
Date: Tue,  2 Jun 2026 18:10:21 +0800
Message-ID: <20260602101039.1867613-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7596F80008
X-Stat-Signature: d1rjb5eftwcx3utthpe688fbkjn8p611
X-Rspam-User: 
X-HE-Tag: 1780395055-945120
X-HE-Meta: U2FsdGVkX1/mAQsY8mxDWrQy/hMs4as1Yi+3rC54UasE5MtZmWJR2vDZAy2J5CPcedRr05V0NvGakHdXpv1Vr8x6JP1jd+KVgYCNvNB+PMp9pNSoNPtvjEe2R1QPKKcl2I/yY3FB0g+2n9Cp+iTIRUFZ93FZkbqBN7/io1k7Jt2raJiYAjGMxklIaJmT32nllDz/9hiU2LkAR8pDVlmkzSEM+rPd7mg2+HOsfaJP5ZYsexzOtXj42wjJg58rQPLY3OmYK7DBVhEsPb1gZBFKSJnOz0Af3e2lvTOPgwVlrcnvkH+deP/zjy+uS++xV1i0iBlve1PBjm7bhlvjBKTxjKJH31YZUJ0XHpPFczImqvtNWMAGW7X0Mg/yi8kSPy2Ma++lzeLoN9Jm7SNtzuSX1uISomLAg85JNBxh0/guGWyvyk1sq/Dt8PpallmEu6Cfk605OHXzjqOI2Bx7fZMio6CBDboracDeZbieaJpGJklgXVm5DounRm8UJeie+GWtzi20zorxrI3IP3e9xrXtDFgAqsKvG3Ae3CQDjP7mSLbFtg9VRYQ/BcoOjMJCtidI+nRjMVjYiEsl//jRiql806YT+UWPRr+H31EPNcqKowZIZ4o5iZo2verni3R1s6R9yOnlDBwNa2CS8x/v4VuKZTo8/Xfx/GE7hebr6ZvlPNh2pXxlkK6YHK91r0/0I7SysHE3EddBmnASO132uDPRobyZv2WUexvFK7KsSBD4ucl2d8gHkRMw5EWeqMzjTsYOS23BpqfTOQtaWznUnakN2BCUg50RUrC29Fk2i3B3SnDp44rUg94gkqeXZX8a4z5VMNzH0/h2OWSb0kfhtALy2fRMBpZi39rkCs0yRUGUPFQ5jKhYrrjAT5wY2enMZn9ulJ4JUCGptS/59Eu1DcPRMMGXihAlbNtq/z0vvi5BMV3msMNcwJ7Hy/7715z0F0Ienmnt8UNJ9YRLjPyVIxJ
 CB7NK0yh
 Q8pHvfKlA4XlKaI4Iwt9qvd8zww2lO9lrxtIRpRutCQkTUADOiwJw4sPrhqIRD+s7Nl0MzdxtqJw9wnNRnWK//xqS/0O51Hf3NY7NwAKCF+21stspFaGtm4AQJ5Q268oP1sM/spKeQzTbzeM4CfI5aQnHnLighMV83kpajQQZ+FuuFIxo6eJQfjlvijzlrRqmFiAcFDuaQuLfez3g8FrbCqw/w/tigU9Wov5DShzxZsURfm5uSgVECqpUCPWXmfBvqGAFezWVXQsD2rqrqT4jvdQBm9c8YUcHZ/wim+VZ3aUNVS3H8RD+jjylcOakgXOT72SyJnJe+wmSuxCYJRhIwV8cO24KtSzWyW3otCaq0oFF5qlLU/4iI5nrHOILY1UHe9X+C7svOcKG13C9Um9pGcQOCZaithOZBJ3TakUDLqTlhpZt3n8cTHBf6ZMoXsXEV8tj5JLNO7kj5zJGVUkC7RznCho5QYNin1k2K5A+nYXhXiAUSSUeQbOz1rZTM80w4ZCkcvno/FcCvvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") switched
HVO to reuse per-zone shared tail pages from zone->vmemmap_tails[].

Those shared tail pages were initialized in hugetlb_vmemmap_init(), but
bootmem HugeTLB folios are prepared earlier from gather_bootmem_prealloc().
With hugetlb_free_vmemmap=on, prep_and_add_bootmem_folios() can access
pageblock flags on bootmem HugeTLB pages whose mirrored tail struct pages
already point to the shared tail page. On CONFIG_DEBUG_VM kernels,
get_pfnblock_bitmap_bitidx() then dereferences the still-uninitialized
shared tail page and can panic during boot.

Initialize zone->vmemmap_tails[] from gather_bootmem_prealloc(), before
bootmem HugeTLB folios are processed, and drop the later initialization
from hugetlb_vmemmap_init().

This bug only affects CONFIG_DEBUG_VM kernels, where the relevant
assertion is evaluated.

Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v2->v3:
- add a comment explaining why shared tail pages must be initialized from
  gather_bootmem_prealloc() before hugetlb_vmemmap_init() runs (per Oscar
  Salvador)
- update the stale sparse-vmemmap comment to point to gather_bootmem_prealloc()
  as the bootmem HugeTLB shared-tail initialization site (reported by Oscar
  Salvador)
---
 mm/hugetlb.c         | 25 +++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c | 17 -----------------
 mm/sparse-vmemmap.c  |  2 +-
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..cd55524c7e30 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3365,6 +3365,31 @@ static void __init gather_bootmem_prealloc(void)
 		.max_threads	= num_node_state(N_MEMORY),
 		.numa_aware	= true,
 	};
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	struct zone *zone;
+
+	for_each_zone(zone) {
+		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+			struct page *tail, *p;
+			unsigned int order;
+
+			tail = zone->vmemmap_tails[i];
+			if (!tail)
+				continue;
+
+			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			p = page_to_virt(tail);
+			/*
+			 * prep_and_add_bootmem_folios() can access pageblock
+			 * flags on bootmem HugeTLB pages, so initialize the
+			 * shared tail struct pages here before bootmem folios
+			 * start using them.
+			 */
+			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
+				init_compound_tail(p + j, NULL, order, zone);
+		}
+	}
+#endif
 
 	padata_do_multithreaded(&job);
 }
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 133b46dfb09f..c713c0d2593a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -870,27 +870,10 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
-	struct zone *zone;
 
 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
-	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
-			struct page *tail, *p;
-			unsigned int order;
-
-			tail = zone->vmemmap_tails[i];
-			if (!tail)
-				continue;
-
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
-			p = page_to_virt(tail);
-			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
-				init_compound_tail(p + j, NULL, order, zone);
-		}
-	}
-
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
 			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 112ccf9c71ca..8f41b73fb674 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -342,7 +342,7 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	 *
 	 * Any initialization done here will be overwritten by memmap_init().
 	 *
-	 * hugetlb_vmemmap_init() will take care of initialization after
+	 * gather_bootmem_prealloc() will take care of initialization after
 	 * memmap_init().
 	 */
 
-- 
2.54.0


