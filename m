Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15C0606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=LtHB22Bd
Received: by kanga.kvack.org (Postfix)
	id BE2C46B05BD; Tue, 17 Nov 2026 07:07:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BFF6B05BE; Tue, 17 Nov 2026 07:07:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D426B05BF; Tue, 17 Nov 2026 07:07:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6158B6B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E27CAA03FE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:33 +0000 (UTC)
X-FDA: 85444486386.03.5439A41
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 99D3C1A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LtHB22Bd;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917252;
	b=5kk61xVVDtmFs+aSDLCPfK5Ymut25B9lq3Ci4FohVIMfk3eOyGR9lq4X7H/p5X0Rnv+JVA
	I3ue15B4pmPiF5HMaOVXxGOEMmFlwX75j2e+tkfbS2ulSHbSupnOLKehYSQ85ilGiF0HWj
	XRpCZ2EF+R3sx+v0O0BBs8u2S/Le2Po=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LtHB22Bd;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdCytpgBEMMjWWjAaswQ3teC54EqiXNp/aCnfx0q/Uk=;
	b=CTOzgT/dukxHiedRxG0tgLpEaVdp46ch2zxPOMkMqBY6xb/77/a5/nWxO9uA2zGYTt+G6n
	xoCW4IO98V3yOMJZsOG6HdpDgwg03BYFlTquEFpFHHIzH6RG/xo/UMGJ8PIQfRigD9SZyH
	xhQpNP8VsgVrkbhDYoYxRJNcSQ1NZQs=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so5501031c88.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794917250; x=1795522050; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HdCytpgBEMMjWWjAaswQ3teC54EqiXNp/aCnfx0q/Uk=;
        b=LtHB22Bdcjr7jFfSKkRcyj9OxSl3gTf2hzNwnRDAO1YErwffv7LNvmt7wkn8LcjFhz
         uerH8DNUUlM7WU3AgHEQEbjNi66+Q+KsKkqGyeF9FZc4AnkvnI5dryVggJ34K5NzcsRn
         cscvz4bdnAwQQDnipc0ff2e5e2nMgk5its7+uKM9kE84O7DcS6i7G94ANtnm4xSkeIRR
         3Es52OFGm54xmJsDrmFTqhACm7MA8BKsryWCZUc9uN94elEslR6HI6P6TETHtqseX52x
         TNmNlJqhqG+LOtTz7obMp95H5m8eVc2Hc17vUBB+vA9MmUa7SwO3Rb57E4+cuW/Z7rhL
         j7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794917250; x=1795522050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HdCytpgBEMMjWWjAaswQ3teC54EqiXNp/aCnfx0q/Uk=;
        b=fEEtzqQkdN98hDypOHitMgC6BzCy37igzlr6/VCM62l7xC2qvDyYYj1FdjQitmOn25
         o63o1LETX8ll8lNComuFUugqn+2JPtfR9T52U/dwQ7N5EbNv+hxJ6/74Ol/mAOVg77Oj
         O6zuF835VmhXZ9QyAC4PpC9Nn9YdniROR9wkg3q9poZu+598kKZ/FkDVr9OEIelEQDkC
         MKWGltPHE0NqTsuqzHbOfuXgOz3xQmD4gDr6eiCwUyugy7qHx1n/Mm6gnPbHHenPHIay
         VV1YwPzGpe1bbHELVRQk8QqYYY9jo6GQNfZs0F8zOqBzv755G1MDqdx0jsupvLVF9XXu
         ATSQ==
X-Forwarded-Encrypted: i=1; AL+hErHN+WoWUPJHGstL8XGwGV9R6f3X4ZgC50ecTB4+7gtdwcj4eQTSSeWbEpo5FaUaczVMaO7d4L/HnA==@kvack.org
X-Gm-Message-State: APuU4Z8rUJxApFuiIaFxrjQhkdyNaMve1KVlD0xccJRBtVNYtAkIJdGy
	BjU59xNAeWLb479p4g2HnxJvBI3I3PCqTNVYeKCIFVN1+U/ummmVI5VuBYxVt1qMWvU=
X-Gm-Gg: AYBFou1sb3Kp4CeUYmSTy7KmS6lS2qP9LAHI03skgG9XcrYlpMAFEpGCBUg5AElnqRH
	k8vawo2L43l6pWpFnnCNYGmuqnPAkPutR4Pq1XbQTPecTcmIdzeKVgOSQDZMsfdLzSFbG/cSiGp
	3Ks5x2KKZVHT5TGLAQlEHQsWrrXgff5PSd/EMxpDstdpNjeV5fwCB20ekru1IyApg34I47QuujO
	b2MVX9snkk/WrawYjESL63cI5K+WvoQisBv3n6CWtGA3IKavUPSbSmfEVg9G7N5l20OtsNHg7EE
	ZVQCabVdurdHKGr3E+UZeA6AvUvC65ehpg92utnFQiSiDxbhNIcCzz7vkCJpU+KCISZF/KEY+v9
	AfQm3AQwCvKDhXVhN+PL7kO3M4tPbdfHzeJf5Jo5qAhHA+HPA0S9hLlZe+Jf2OGZn6DDGwvVi9J
	IouJEQswoQxPzoRmvSkep8QIZxKM2qbkD6sM5/PpEP1AyyGFnDFdyafLCgtCyqNrffxW1n16LCA
	aTD4q45jIXPzB6OClyw+d1iH/ejUwYwptX6CWbQmAFT+wkDrsXw2GSevhasXMN2KFYYMwWIVRg0
	lqxZqkkPMLmoVLx++MtpiM635wTrrLtJljWrTWaqOjoZ/xUNqV81GogIIgxgkXJeyg==
X-Received: by 2002:a05:701a:cc97:20b0:1b5:2dce:1b88 with SMTP id a92af1059eb24-1b52dce1e79mr5203228c88.45.1794917250013;
        Tue, 17 Nov 2026 04:07:30 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm47347116c88.5.2026.11.17.04.07.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 04:07:29 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 4/7] mm/page_ext: use common allocation and initialization entry points
Date: Tue, 17 Nov 2026 20:06:24 +0800
Message-ID: <20261117120627.50601-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261117120627.50601-1-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wziuiayk8b846m45s5mogpwnopwnqzki
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99D3C1A0004
X-HE-Tag: 1794917251-421971
X-HE-Meta: U2FsdGVkX1/uEhd1kIbJ5DAUwhZPMkEUpmQpld4zjHziGbQ1D6tdRlMA4XgSC/ap2+rM8NQtrOjrgqJI3w6d5PouOeMEA2dIGpwa17nBtV3NcbRaJ1BhuMD1CTLRXjGJepxMMl2mptp8J8enBV7vOdoTQNpvwYX1jH0Z48A3YQmDi1UYUdIS2jKOih96XkZ5sksSzbWszRfEG/CXdpLwSimodijFLmfuA1ErgvzzH0wEXstg7zdHfVkJ99/jFOuf9n0qNQFxvDbUX889txX3Gd74sTQJsp/8MTYBvb9dEMs3jfgrZeYsxR2p1DX17C+QOPdJfwOz2NqioV+kk6MtAS/b8ZVhrvBQ+v/cSFXXlWEN8VW48/gTdH45cg4lMdWWQiomoXJ94oliBbQfDRD9LBMqxhvaH/id5zJ36LuGACHnGukx1LfnKSDBCBGNPMclolJwYmfHz1SefBkfSi9HL0f8siubxSgg+QOcokxbMW2Mh1DUXJm10oIzjLdHw50H4jiHpIUjMPLrpbiohxDSElTZ9AQFfp0Zdw+NOXCK6WCW0gYdGZ3jgPlFpKw43X1BcASpPOWPBZfdJVi/hhr+qTSj8elIbPN5wrJDOh3qCoC0kaad0kPE6nHj8Y7VW4I4UzauVwMBNdWfFeJmyy9mVrdb7FoLG1ahdQaH98/mQxPd0f+KU1QM+d5LG9GCv8rT0zE6aCLdzudz1MGpqK7DFyMAXgp9KErbMw7oAB4SCYQnFRCNf0m2PpznIaQQKwgxFc1MsWd4e7liiyAOe4LPco6nM+F76qbMJ4xjgfFAf+d3QxH6kiIQ+VOH+OUI4pmC9mTfXvgBPDghSH7o4HdQcxeIM7U9bIOSR7flwQQ7KxbsOn/wdEcdtb1Mac02XhWVJaQa4oN6ByxINdkJVA8SWt7NNYwQLB6VMCzzcQ7hzKjJdbxKlJLTehZFTLyjIXyypyaPeYApYiN6Y15ljEl
 KUJi/41D
 67yIPY3MNwFOSd+ljXDCWBsnKqhQLXT01SjV4Retyt+CIGWdmE2xliiDTEluA14+k7xd0HI+aSzcBut0Df1aRXeHHh8iz7sj5jCToN2tLOpC3xQXIQP42l3Ou6DgXYUNbPsNJPgmjtSsv+fdJsjvbb4hhvXO/5r1cKjUpZ1zsPih1M0n0oySHGlSwh7JzuWZ9U6NOf8ebPgm3VWQ0xD2n2803YPc2tHjuFznY41ImPwKNUK/FQZJ1zfPvC0l2FMXg0qIVQZnxCSW4tzIHb2YYyq/h2RSeufeDSzP1ksYU88tzAbqcYjES1ioh/CfQ9uFQDAkDVGS7tBOoq0g498w85XX0MNu3TcYfofPAZ7eks/v7KR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

FLATMEM uses separate page_ext_init_flatmem() and
page_ext_init_flatmem_late() entry points, while SPARSEMEM performs its
work through page_ext_init().  This exposes the memory model in the
generic boot sequence and obscures the allocation and client
initialization phases.

Rename the early entry point to page_ext_alloc() and use
page_ext_init() for client callbacks in both memory models.  SPARSEMEM
keeps its existing late allocation behavior for now; its
page_ext_alloc() remains an empty configuration stub.

This also moves FLATMEM client callbacks from immediately after
kmem_cache_init() to after vmalloc_init().  The callbacks still run
after the buddy and slab allocators are available, as required by
page_owner.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Split the common allocation and initialization entry points into a
  preparatory patch
- Document the later FLATMEM client callback timing (noted by Chris
  Down)
---
 include/linux/page_ext.h | 20 +++++---------------
 mm/mm_init.c             |  7 +------
 mm/page_ext.c            |  5 ++---
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 79c53ec45dfa..911a84bbb3db 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -62,13 +62,10 @@ static inline bool early_page_ext_enabled(void)
 }
 
 #ifdef CONFIG_SPARSEMEM
-static inline void page_ext_init_flatmem(void)
-{
-}
-extern void page_ext_init(void);
-static inline void page_ext_init_flatmem_late(void)
+static inline void page_ext_alloc(void)
 {
 }
+void page_ext_init(void);
 
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
@@ -79,11 +76,8 @@ static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 	return next_pfn % PAGES_PER_SECTION;
 }
 #else
-extern void page_ext_init_flatmem(void);
-extern void page_ext_init_flatmem_late(void);
-static inline void page_ext_init(void)
-{
-}
+void page_ext_alloc(void);
+void page_ext_init(void);
 
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
@@ -205,11 +199,7 @@ static inline void page_ext_init(void)
 {
 }
 
-static inline void page_ext_init_flatmem_late(void)
-{
-}
-
-static inline void page_ext_init_flatmem(void)
+static inline void page_ext_alloc(void)
 {
 }
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2367af05570b..7344e7cb8196 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2711,7 +2711,7 @@ void __init mm_core_init(void)
 	 * page_ext requires contiguous pages,
 	 * bigger than MAX_PAGE_ORDER unless SPARSEMEM.
 	 */
-	page_ext_init_flatmem();
+	page_ext_alloc();
 	mem_debugging_and_hardening_init();
 	kfence_alloc_pool_and_metadata();
 	report_meminit();
@@ -2727,11 +2727,6 @@ void __init mm_core_init(void)
 	memblock_free_all();
 	mem_init();
 	kmem_cache_init();
-	/*
-	 * page_owner must be initialized after buddy is ready, and also after
-	 * slab is ready so that stack_depot_init() works properly
-	 */
-	page_ext_init_flatmem_late();
 	kmemleak_init();
 	ptlock_cache_init();
 	pgtable_cache_init();
diff --git a/mm/page_ext.c b/mm/page_ext.c
index 3b581242fd52..b41d4a957bc6 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -180,7 +180,7 @@ static inline struct page_ext *get_entry(void *base, unsigned long index)
 }
 
 #ifndef CONFIG_SPARSEMEM
-void __init page_ext_init_flatmem_late(void)
+void __init page_ext_init(void)
 {
 	invoke_init_callbacks();
 }
@@ -238,9 +238,8 @@ static int __init alloc_node_page_ext(int nid)
 	return 0;
 }
 
-void __init page_ext_init_flatmem(void)
+void __init page_ext_alloc(void)
 {
-
 	int nid, fail;
 
 	if (!invoke_need_callbacks())
-- 
2.54.0


