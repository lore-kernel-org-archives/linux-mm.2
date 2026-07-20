Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A102FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2776B0096; Mon, 20 Jul 2026 15:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B3E6B0098; Mon, 20 Jul 2026 15:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4426B0099; Mon, 20 Jul 2026 15:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2AD46B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C8A0402B7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:54 +0000 (UTC)
X-FDA: 85010157708.11.C34F2B8
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9525280008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DwL1KPdD;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q409+JQ/uWnw6WpILbqdiAKa+RhnPorqknZtMcjhbGU=;
	b=Yq4MRV/xXRWSLS7xfwPoHqXxlI61RCicqkfc4lgKiQh68xWeGaGEfRMM2cWN6KUz28rA7M
	SgvSV2xSoDBYB+h3Jxk0EUKcVzCFOkFyR6u/fhtwC03T1bDM8BQrDniC8Aolo6uIRRQk0X
	KKTxj+CISlF1n3tu7EqdgMnKfDcZwuQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576092;
	b=IgxV0zvr6bm4fF77EzuVdkAJiCO5YipGBQUaOYcxAwt9QKdh2PZ6DM1kK/1mlHq71wBXqW
	Rr6aII3RD0aLR2pd/icN2G3SxpayRNVf59YydA4BLjl3FhiUUuY2hGkUsUQHbCdOiU7w6S
	k0mBj4dbyylSMH9xFs3GF+kYm+2Rc/4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DwL1KPdD;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92c7a0a701aso819383885a.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576092; x=1785180892; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q409+JQ/uWnw6WpILbqdiAKa+RhnPorqknZtMcjhbGU=;
        b=DwL1KPdDWhfYT3k1G4Hq7RInGrouoGiD3B3eCjooYeg/Hi0DJERhG/r3/PrmiqQjlt
         VgEFCVri8Sf0ER3NT2l2mfK+E4CckFs/59w7r+ZL5O8VWU7EOyVReQ4gu9DVUgqZm+b0
         XVieakQ9QRVlA7fW+kKKw7gAqc0WCTq28UbWrgJIR/O3p7q7AArWvEN299ht+mjV0t53
         KGpiizwQhMKmU3CxNxaKgMph6D7qA9g528C1q25d6k2DZ36ozne+ftZ0LEKQM3sY29Cy
         Mdr9S8BiBLtF8KeVU81lfTs8Dyt5psDDfJppjZ2C/2ciWa3kc5i/J4VGQpZcQJV16r7w
         8U9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576092; x=1785180892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q409+JQ/uWnw6WpILbqdiAKa+RhnPorqknZtMcjhbGU=;
        b=MI2LTvPAF6m8wEnrLEoa7a/umEGwIB4iFIiZMkRKCBwPZbISOA5tkz8KBjS4GEo0L/
         u0yuE42/lUmPg6wLSIXEY2/HK8RzB58/557SnvAcHFn0Kt8EXjUOJFBasA6gfGLd6SlQ
         nBV9o9CR9ZfkWVSZrYvsuM5OT7MTXwFJ+g5KhHIyXtGkmEq9rjbJrf6MKAmCNY1wInKb
         9SIOUq7nCYB962q7vPngQ0UtgU3RP5sCHblCAywM3pBMYLQR9ilh/+15p7UYHUFrLguL
         0aimSxV6RkfqIb9u5Y5J6bw82jT2fgNQzNPCO6Tah/iSr3IP6bSdz3I7GQCzlTzxiN8O
         UoSQ==
X-Gm-Message-State: AOJu0YwkMYcVyCde/un88ZFBQYWMr8/RG7IfOY+Oqt55yIkiWRYg3dro
	sBHBsNJKtqj1krKoBTF5ApPu5HHkcpzgx/FdkxijCxUKANqEi+C2hdJg3UFkcq0sfBAlIVOzzhp
	SjG1e
X-Gm-Gg: AfdE7cn0xd10PanETnzUiaFeI0+iIP0tUgFL+BErPoL7Zt8YecnB8MvNzBfptzN+eg4
	8lyb86TLPkROPimi6vOFXAKBThUdgBD3C+PkFD2VrvWU9fpL9qieZ594a8S4MJuF2nB8q/FYnp3
	OeZPMMaNHuKy1TFGyPPr7lkKB8ArQgWT7u6uNjD3/N0RlEDlgMLrh//R6m/Ryde73eluycfkQjM
	GaUQ5gNqxxiAN97IujklQJeYX4lh3pCqv+f6H7SnxFodYAOAeqNXIBxgjZslMCfKO65BmnCm/pv
	Mpx/C2zc60djwKKgBYf073w3Voez0D2/TjBmnPhhcZ2WPOneUbgYJcwbSmFS9PIxCYq2z4YbywA
	nllYCn45BQSIBGq7WNWEgSXJjKM4Mt0CMx3QoA0obx3LGFKKxggRl/RU5IpI2wv4q2+zftulyaf
	zi4TA1FOSk18v7x19JIYTAIJTeZO2wAuN6eLTtPWUdTwf2Ir1Vd4W67M39HurZsEIcwK0eOHaDN
	Q==
X-Received: by 2002:a05:620a:2711:b0:930:a6ac:3a8f with SMTP id af79cd13be357-930b41e067cmr1638750885a.57.1784576091600;
        Mon, 20 Jul 2026 12:34:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 05/36] mm: add ZONELIST_PRIVATE(_NOFALLBACK) for N_MEMORY_PRIVATE nodes.
Date: Mon, 20 Jul 2026 15:33:59 -0400
Message-ID: <20260720193431.3841992-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9525280008
X-Stat-Signature: q18zw5nbizb9qt4osjybdkfa16845ani
X-HE-Tag: 1784576092-800016
X-HE-Meta: U2FsdGVkX19/HXyV9T9x87oSUwcopXR0FOEzsXbmFUYJNY10diV9XD4HuQ33aD0WpuqsFXloju9uKC3Dt4JKcacOxiZOB7OrShoM/l6rJ99jGg8R3RxWAdUkqSgSmZFcxPtYOQRSK/y2L4IKeI/DT99lTok/hVxVL5FufF5VfVXi31alPVpCX50a4jPlOaQl3WsnoQMdi/YWHCGxk4X3lfLYS03kWQbpnRBp06oRhpXF3oosn6giOwaX0KB49iguK/aTCySUCfWUDer4SUqlxG9/SGfW/9Ir6yFnamKpqrwFMP3nsJtchMRjd4iC+hqieEbqoom/XZiNkqOz7gMMOQtgS12ZN6x9JVSPpeiJphyMtSfGBs7K6QUzkZTSHuAnva+Po/5Sa6mL4iuIcjCE2b3HVJTbi39p9AeylxNcZUupwGFu/lUOWstS7cX0rm2VeHeXj4GPg1tccCBg6TtxoEEWYFu+8g8wYf7lC90rAo9hQaEJWMQZ+wKTq/X3oSeNPJpLhPp+8Qoo2Tiym4Jhh0o2ag+tvAjUylBMB5Jq2/TzzHGfIWM47B+ebaBgpCIcAfeZP+hdtk5dcdHXPHmJxDkUjwH3DAnY7e3cmAitEpSqE62E0c/d/OKlHG0QevBXjxEa3Ut8KlVV5nAlM5KjUlIpbzNd3mQSFy/ZZYB708kLW4mKAxueNhqvhl2Hk4KAaEPxsaFD6W48rOjTdspRbTZSe4UfPl/BEhXx0Gcmdm4CHOCwLKKFtpRVlwm3tWX8UlsAl0KgN5oAGMKzsmVqhOpsiGi6/YqqYovrbMAAVnhD7tJLzkaDiNghsNdd8U2s7ypteBemylR2io96qooLBVWIiSXnQsI7B0Yxni7PuJODgaYAqPDeV/IB1VdUQn+w2lXBN/WjDo5+xmnI2APzKLZItn/8k6q0VAMGwGWoAlQGdlmTEhWTT0HoEAN2erQPi83YjkDk/YMob4o/ReD
 YsM9c4zS
 O0CRFEsxoPwaDIEkBYcKtyIFM1TiuoiILaLwvv2yD1QFsgcNxkELKbDnYS2toUUA4fld2WcE5bRH9MZFnFNZfDq/6lGG59HfF5vShOlRTNzdCcHi+m2Fj4n7ayrvI0yxMg203lkuBmkbnZRN/sNuDwjpInEE3wGCdgVWvsFk0HYqOzM9N20b3yx/CsqQhGsrDhQDAZfOi8UVlEV5K2WK9/k6TS5Ib3NzmO0kN5Q0UHbLYwAvf+izsiSERMdnPMbINC8NqEynobbukdOGpsf7NLGRA7Omq++lP4h7vtAJGm6v+oVkMlHkgVPFmWUogE7ZUQxQhEepFFSZ2kinj4U/KdwW0DXP/D4u4mYBcbK2rZDKe4NYh2id2zGIYifW9E2BSwYGNOTUrwDMs985/nLGR9rKUpd50eAajFaAtLSQRdq253d8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

N_MEMORY_PRIVATE nodes must be invisible to ordinary allocation,
no allocations may reach one unless explicitly called for.

Make this isolation structural in the zonelists: N_MEMORY_PRIVATE
nodes are excluded from FALLBACK and NOFALLBACK entirely, making
them effectively invisible to all normal callers of page_alloc.

Add ZONELIST_PRIVATE, which spans (N_MEMORY | N_MEMORY_PRIVATE).
When !CONFIG_NUMA, it aliases ZONELIST_FALLBACK and compiles out.

Add ZONELIST_PRIVATE_NOFALLBACK as the __GFP_THISNODE target for
private node allocations.

Zonelist selection rides the allocator's alloc_flags.  Add
ALLOC_ZONELIST_PRIVATE and resolve it in select_zonelist(), which
prepare_alloc_pages() applies from ac->alloc_flags; the default
(ALLOC_DEFAULT) keeps node_zonelist()'s gfp-based selection.

Add explicit private-node alloc() functions to prevent open-coding
(both ride ALLOC_ZONELIST_PRIVATE through the alloc_flags-carrying
entry points):
   - alloc_pages_node_private_noprof()
   - folio_alloc_node_private_noprof()

alloc_contig_range adds an explicit node_is_private() guard because
it dervices its target zones from PFNs rather than zonelists. All
in-tree callers use N_MEMORY ranges, but the check prevents future
callers from violating node isolation.

Important note:  By design this zonelist isolates N_MEMORY_PRIVATE
from unintentional allocations, but does NOT isolate private-node
allocations from falling back to non-private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp.h    | 11 ++++++++
 include/linux/mmzone.h | 11 +++++++-
 mm/mm_init.c           |  2 +-
 mm/page_alloc.c        | 64 ++++++++++++++++++++++++++++++++++++++++--
 mm/page_alloc.h        | 26 +++++++++++++++++
 5 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index a327e58c313f8..f3e867de744f6 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -204,6 +204,17 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
+/* Allocate from an N_MEMORY_PRIVATE node (selects the private zonelist). */
+struct page *alloc_pages_node_private_noprof(gfp_t gfp, unsigned int order,
+		int nid);
+#define alloc_pages_node_private(...)				\
+	alloc_hooks(alloc_pages_node_private_noprof(__VA_ARGS__))
+
+struct folio *folio_alloc_node_private_noprof(gfp_t gfp, unsigned int order,
+		int nid);
+#define folio_alloc_node_private(...)				\
+	alloc_hooks(folio_alloc_node_private_noprof(__VA_ARGS__))
+
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct page **page_array);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9815e48c03b97..654c5111f7cec 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1392,13 +1392,22 @@ enum {
 #ifdef CONFIG_NUMA
 	/*
 	 * The NUMA zonelists are doubled because we need zonelists that
-	 * restrict the allocations to a single node for __GFP_THISNODE.
+	 * restrict the allocations to a single node for __GFP_THISNODE
+	 * and N_MEMORY_PRIVATE nodes (isolated from default lists).
 	 */
 	ZONELIST_NOFALLBACK,	/* zonelist without fallback (__GFP_THISNODE) */
+	ZONELIST_PRIVATE,	/* N_MEMORY_PRIVATE access, falls back to DRAM */
+	ZONELIST_PRIVATE_NOFALLBACK, /* N_MEMORY_PRIVATE access, __GFP_THISNODE */
 #endif
 	MAX_ZONELISTS
 };
 
+#ifndef CONFIG_NUMA
+/* Without NUMA only ZONELIST_FALLBACK exists so everything collapses there */
+#define ZONELIST_PRIVATE		ZONELIST_FALLBACK
+#define ZONELIST_PRIVATE_NOFALLBACK	ZONELIST_FALLBACK
+#endif
+
 /*
  * This struct contains information about a zone in a zonelist. It is stored
  * here to avoid dereferences into large structures and lookups of tables
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 711f821f7b3c7..adb50647d29ca 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2701,7 +2701,7 @@ void __init mm_core_init(void)
 	init_zero_page_pfn();
 
 	/* Initializations relying on SMP setup */
-	BUILD_BUG_ON(MAX_ZONELISTS > 2);
+	BUILD_BUG_ON(MAX_ZONELISTS > 4);
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 	alloc_tag_sec_init();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aa35bbe5d4c3e..78755a55b1540 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5040,7 +5040,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int *alloc_flags)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
-	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
+	ac->zonelist = select_zonelist(preferred_nid, gfp_mask, ac->alloc_flags);
 	ac->nodemask = nodemask;
 	ac->migratetype = gfp_migratetype(gfp_mask);
 
@@ -5346,7 +5346,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	unsigned int fastpath_alloc_flags = alloc_flags;
 
 	/* Other flags could be supported later if needed. */
-	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
+	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG | ALLOC_ZONELIST_PRIVATE)))
 		return NULL;
 
 	if (!alloc_order_allowed(gfp, order, alloc_flags))
@@ -5457,6 +5457,22 @@ struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 }
 EXPORT_SYMBOL(__folio_alloc_node_noprof);
 
+struct page *alloc_pages_node_private_noprof(gfp_t gfp, unsigned int order,
+		int nid)
+{
+	return __alloc_pages_noprof(gfp, order, nid, NULL,
+				   ALLOC_ZONELIST_PRIVATE);
+}
+EXPORT_SYMBOL_GPL(alloc_pages_node_private_noprof);
+
+struct folio *folio_alloc_node_private_noprof(gfp_t gfp, unsigned int order,
+		int nid)
+{
+	return __folio_alloc_noprof(gfp, order, nid, NULL,
+				   ALLOC_ZONELIST_PRIVATE);
+}
+EXPORT_SYMBOL_GPL(folio_alloc_node_private_noprof);
+
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
  * address cannot represent highmem pages. Use alloc_pages and then kmap if
@@ -5854,9 +5870,21 @@ static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
 static void build_thisnode_zonelists(pg_data_t *pgdat)
 {
 	struct zoneref *zonerefs;
-	int nr_zones;
+	int nr_zones = 0;
 
+	/*
+	 * NOFALLBACK: the node's own zones. EMPTY for private nodes so a
+	 * stray __GFP_THISNODE allocation can't violate isolation.
+	 */
 	zonerefs = pgdat->node_zonelists[ZONELIST_NOFALLBACK]._zonerefs;
+	if (!node_is_private(pgdat->node_id))
+		nr_zones = build_zonerefs_node(pgdat, zonerefs);
+	zonerefs += nr_zones;
+	zonerefs->zone = NULL;
+	zonerefs->zone_idx = 0;
+
+	/* PRIVATE_NOFALLBACK: the node's own zones, private nodes included. */
+	zonerefs = pgdat->node_zonelists[ZONELIST_PRIVATE_NOFALLBACK]._zonerefs;
 	nr_zones = build_zonerefs_node(pgdat, zonerefs);
 	zonerefs += nr_zones;
 	zonerefs->zone = NULL;
@@ -5899,11 +5927,28 @@ static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
 static void build_zonelists(pg_data_t *pgdat)
 {
 	static int node_order[MAX_NUMNODES];
+	nodemask_t tier_nodes;
 	int local_node = pgdat->node_id;
 	int node, nr_nodes = 0;
 
 	memset(node_order, 0, sizeof(node_order));
 
+	/*
+	 * Zonelists: FALLBACK, NOFALLBACK, PRIVATE
+	 *
+	 * FALLBACK:   Allocation order for all nodes.  Private nodes have lists
+	 *             but never appear as an entry in any list. Allocations
+	 *             targeting a private node w/ FALLBACK land on N_MEMORY.
+	 *
+	 * NOFALLBACK: A list for each node containing only itself.
+	 *             Allocations targeting a private node w/ NOFALLBACK
+	 *             will always fail (their NOFALLBACK is empty)
+	 *
+	 * PRIVATE:    (N_MEMORY | N_MEMORY_PRIVATE) - allows access to
+	 *             private nodes, and falls back to normal memory unless
+	 *             __GFP_THISNODE otherwise constrains it.
+	 */
+
 	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
 			    true, node_order, &nr_nodes);
 	build_thisnode_zonelists(pgdat);
@@ -5912,6 +5957,10 @@ static void build_zonelists(pg_data_t *pgdat)
 	for (node = 0; node < nr_nodes; node++)
 		pr_cont("%d ", node_order[node]);
 	pr_cont("\n");
+
+	nodes_or(tier_nodes, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+	build_node_zonelist(pgdat, &tier_nodes, ZONELIST_PRIVATE, false,
+			    node_order, &nr_nodes);
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
@@ -7282,6 +7331,15 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
 
+	/*
+	 * Private nodes are kept unreachable via the zonelists, but
+	 * alloc_contig works directly on a zone derived from the caller's
+	 * pfn range, bypassing that.  Reject this operation explicitly
+	 * rather than silently carving memory out of an isolated node.
+	 */
+	if (unlikely(node_is_private(zone_to_nid(cc.zone))))
+		return -EBUSY;
+
 	/*
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 23fc79ce97b60..741448d83ce77 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -57,6 +57,9 @@
  */
 #define ALLOC_NO_CODETAG       0x1000
 
+/* Select the N_MEMORY_PRIVATE zonelist family (see select_zonelist()). */
+#define ALLOC_ZONELIST_PRIVATE 0x2000
+
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
@@ -95,6 +98,29 @@ struct alloc_context {
 	unsigned int alloc_flags;
 };
 
+#ifdef CONFIG_NUMA
+static_assert(ZONELIST_PRIVATE + 1 == ZONELIST_PRIVATE_NOFALLBACK);
+#endif
+
+/*
+ * select_zonelist - resolve the zonelist for an allocation
+ *
+ * The default matches node_zonelist(); ALLOC_ZONELIST_PRIVATE selects the
+ * private-node family so an allocation may reach an N_MEMORY_PRIVATE node.
+ */
+static inline struct zonelist *
+select_zonelist(int nid, gfp_t gfp, unsigned int alloc_flags)
+{
+#ifdef CONFIG_NUMA
+	if (alloc_flags & ALLOC_ZONELIST_PRIVATE) {
+		int idx = ZONELIST_PRIVATE + !!(gfp & __GFP_THISNODE);
+
+		return &NODE_DATA(nid)->node_zonelists[idx];
+	}
+#endif
+	return node_zonelist(nid, gfp);
+}
+
 /*
  * This function returns the order of a free page in the buddy system. In
  * general, page_zone(page)->lock must be held by the caller to prevent the
-- 
2.53.0-Meta


