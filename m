Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87F09CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3B36B008A; Wed, 13 May 2026 09:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1C16B008C; Wed, 13 May 2026 09:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBAD46B0092; Wed, 13 May 2026 09:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBA426B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:07:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C83D1C04EB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:42 +0000 (UTC)
X-FDA: 84762423564.26.F6CE3BB
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4A44DA000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aofFHClL;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glZCSgCcQPUR5mPOULt0p1weLkVndlFTk9nY8tD6isc=;
	b=WSdOFjaji3F2Evcx0sQu2OWOozwPKRZ3g5028j4aOFcY2BPDZ6gh3e5Orv6qpMpeEfqNge
	GKIZSm44yNcMXLYFA0VpWF7hmjPN1AmqckfW8fXf7jUzfHfly4gZguY2vYjBq7j/CxmB4t
	juS5zYNF2O+RNbmOS03AkzTUgvCrgXo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aofFHClL;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677660; a=rsa-sha256;
	cv=none;
	b=Pt5jX8eH6saIlTFoDiJ9hPAqu+jkM24uUUIWNyIPQTF0L2UlW2NMSyla4D/dOfI7xBlrgX
	0uypAPYPqMRvaEAIPiiUqD2TuVQIEw6FsPP5Y1WGyEkF4kO1PpTslfrRrOS4dHlJcGmmAF
	AAKHQwAycnNq2LriqIeEjKUxDrr2HJU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2adff872068so36256905ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677659; x=1779282459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glZCSgCcQPUR5mPOULt0p1weLkVndlFTk9nY8tD6isc=;
        b=aofFHClLz4ScufGfw1pYjw6yV4jdCRPIh0A3UdYZASrT11/y7baMPMMN7o+xRhjJJu
         LlTiZDDqrCB5yA3egfOrkB/MqsO0LzJ2v9UkVFlo/W+Hw7r5ZQ6VXKWVg4d2NFYyTYB5
         b1OC76nLfXuzGJcJuhD5frY0bWqYJcqfotm02lrAlYdYzxvxvWEsgPdNuS8hp95ODDO8
         jZdku4L0857TfyEu5di46vX7CRtusvjay+qtkBwQdJN3IAhl0TbHlEoKqhiUTVWgQAfr
         tqPDACmw7LkOdxsrPBnaC2ehd+nym+eDyKaB3yjBJramV65AxGJW3kS0F2O3vB3jN8nk
         ikyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677659; x=1779282459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=glZCSgCcQPUR5mPOULt0p1weLkVndlFTk9nY8tD6isc=;
        b=gkohM51o4GuQVdSWgnvkhmYyYW3ajvx2yxwgFRdHTlZE7P6fORrtCh8o32ImlW/WMs
         VLbPSriOHt90STh2t8JRJ1uGZasxnsXgFdtAQTKcsoWeUAJ1tQZm8CSG+rM3IN0kXacI
         8JDEqETCnJmf2RoKuU0+9XiABPq6rx2TG76epYbtPY07yE/d+IhJgctHZ1BqODocPpfG
         WP8tda7VsTbnOgWnfn5LS8tbaaLkvNAUqqVp8BNtrVlM/TfivSgR5RQMG2hlacA5/sC2
         fFyetTsE9i/zIqnESLpT8k2lg5eisbylDGU4xCY7pWwDZhsZc9bG1wGoIyEJkDNfa6Ln
         3BKw==
X-Forwarded-Encrypted: i=1; AFNElJ/SFhnGlTPD12ICIEzygus2cNVLSMSqB7JvmrS8gir/Xu0RG1fDXir2SPNNU4q42PYxUeNS8MiBxA==@kvack.org
X-Gm-Message-State: AOJu0YwA6E7n6sWYhdvrPCtSbqUyizkwqyx/4FjJstLap3vLxHHptte3
	3kpEl1hQAUgtdC/4630d/jMfYqwo7Vpy8tJOWZJfgxid9MOhLJt49miPGCr2mHzFZ3s=
X-Gm-Gg: Acq92OEn2iOa1zvRBWVuKgUjgQM+210QLOgFl5nOcNqIPB8f/4xV1u29EHZr6/Hx3yo
	nQUz/7fneSsqhM+s9nuHC8rOu62t3tQ9vN8OY5pk7Y/mLrfq/s8iSF4CxfaVxD+C1EsPARHF5M1
	00L2jVboLbJdRxki3mT0FebosbA57Z2C2rdau7e7dx8PENze4ckG2D8vL93O9pztDlvR4FLax2G
	ZAA7tJw+WSZ1a1WyMsPx+49GCKLYrxkdJNnDIniLBu9ocq3Kfk+a84WkTDPv+uooWnmXityt2WU
	lt0DS2znSmea0eR7hY8AtSfEjF5js2PMv44Rk4vi0Ge+68LraB8zyigHbFoCvlpv8bMo33wHG49
	PuF0NE3gLl4IDbEPNvaVDxlek9Yk2Z/FSo+2FSXl4dHArPCcoVGj/f4AtBifjA4Ss5cHDZ9ttiy
	xnNwuNpPxXKaPZYx+BBCb3M0hhH9KwLewQFNVN+ZYyHxW24UBd0y6trEDlgAs=
X-Received: by 2002:a17:903:907:b0:2bc:e216:db47 with SMTP id d9443c01a7336-2bd2713c36cmr35966965ad.8.1778677658559;
        Wed, 13 May 2026 06:07:38 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.07.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:07:38 -0700 (PDT)
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
Subject: [PATCH v2 01/69] mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
Date: Wed, 13 May 2026 21:04:29 +0800
Message-ID: <20260513130542.35604-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A44DA000F
X-Rspam-User: 
X-Stat-Signature: kw7iy1848ar78h7dzn1x8ehux9jojqfb
X-HE-Tag: 1778677660-753647
X-HE-Meta: U2FsdGVkX1/g0Xrso9zHBRAgIL+eCrZ//pyJ7YWOUtb22du3brIq5ABuFHIijx/nW9XoT+6tJ3dBw5UNaXoVG/xAKH4x/Tbcceo9XHdh2HCHMr12n/L28VSfoFaF01icJDTo5pI1oEZTRGemwE5vWy8VJA3Nbg5aSnnqk0L3a2ddu/IKkAb/0N8QpJbqe65f1uH7ndpdqrwV9y630wSqjqu2GbZVrdJLfxCKl6TQ/iQSSFiVhR/TCmf1Js3fvnvo4O7MMPf/uF6IThnrpxqO+rxjJMH7G1XE0QOblzIIohJMpKTIyK5ycAY9Hh9gscaW2igfIyZWx/Pe2zBLIVbhaMzjjI1ln3sZq0X1hW6pvhRQ67shUgWyDHP7TsZfM0qqVLzOlMn+cbZSeVWHzHGrfkHc4CRG6zlOPzWg5fUEthgteoFuuTYBkggnkrQn8wEhdDWb2fRj7lPRkT0riBsS0mR5Nsx/9eaMXFN9+793Xm2aDxbj0buAgWHKhkpLvqggqzsq1LJJ4Yqs7zHYzm49SfeaJyCQytUR0BsnDkDG7ttB2hFQZ+wuG8zdJPjBNscT8bAdFdF+rJolCUmgUAPcjXrmfFtlE91jlIzZT6qieREqBSEQ3yRk8Ke4jNsiHuj93lGJJHOyfanAEeU2tgVgyMS4lL8xj/Ii/b0Dmuqb+yhKODQLlnxHz8vtCIIsCCIRXkboEV3Vi1HNS3F3dYj3XVmNc0Ezv0pzuTKc2VmSyFpYul0j6D749YhHTeF3aS8TRidQniNXTCflCYlTaMHtM9xelgQDDcKtIutrdi2ibKMZDPaFHsiVz8XsdzLa3PowbXHLaNrkJiQF9wiTwT6IVrc+fhVjWIRdvSqsEg8+YdOxsOgg/PhVdNtJxyYR/xiiWqiK93iWYIodKID8g+TJDFODFlNM+1hLPzifmp9cEyMq62JTW639TP8FyIK6HW7IWwQzJhOMoPuqfRYpwSU
 ZXSpQwxn
 RN6ep8Prd07tMf/p7Hfxyko5Aj/j+pWOUGo260cjnnR2j35+iiYqePkfuZtrEi16u7XBFS3XlTZTc63xg1Cv4cCKqg7pQ1LDWrZm7lmhD/k73nQ5+E2x9xPWVEM1LKpZ3Mg766JhppHRxnSDovEmDIQi4UCbIzjwhzphY27QHoxpexD1jY80Qyil5LrGRCd8ySjwAGP5ky7kT58KJXjForA7yizVVmoIpVKONUy52VfasxzJ2eqCiXIlnAU5YoCbkh6oV2o3CnYGqs/BxmE2MaLdqw1XBSSEg1BM0QzPDyDEQqkL7vZ7OmQ1VoWP9DabsTzcrELlI6qZofO1WIFDEIQqzCaTDzssRvMtnPGtRE1W0BGU=
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
---
 mm/hugetlb.c         | 19 +++++++++++++++++++
 mm/hugetlb_vmemmap.c | 17 -----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 31b34ca0f402..d22683ab30a1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3382,6 +3382,25 @@ static void __init gather_bootmem_prealloc(void)
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
+			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
+				init_compound_tail(p + j, NULL, order, zone);
+		}
+	}
+#endif
 
 	padata_do_multithreaded(&job);
 }
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4a077d231d3a..62e61af18c9a 100644
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
-- 
2.54.0


