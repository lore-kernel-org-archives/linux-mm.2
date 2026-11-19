Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B819A606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=DdiADQzN
Received: by kanga.kvack.org (Postfix)
	id B77726B05BA; Thu, 19 Nov 2026 02:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B280E6B05BB; Thu, 19 Nov 2026 02:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFB66B05BC; Thu, 19 Nov 2026 02:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9B96B05BA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:00:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 091DA160983
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:00:48 +0000 (UTC)
X-FDA: 85450970976.03.52F6524
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD646160005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:00:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DdiADQzN;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071646;
	b=O8FitS2GiDTFRxnNCoHpWu8IDQ73tl0YlKCEYiR78pg29hP1iFqFMs3I89bO+pYyMyXMfZ
	lH3rAMA0yZ8jpGJlcc9ziFjzFmcnSDX0IGA+Bk8Vjh/l16eW/Z5oqArLU1py9e72veERWc
	kpa4sm8ZerZxPvoiArNK4JiaHmvQyfI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DdiADQzN;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3lWud7DQJXjUbfSMY4r4QoMTzIguNTYupF3jSPDUjo=;
	b=6FMbPXm6PifVPIxUpmUbaT0Oh/rHQgwZKmQP8v7gGiF1a6M7zudFwhpn6MNyzJCKK3dHhS
	VyHSsbCnFY7Wbb3I/YjFcMYQOnceRGLomVxdNnNTnUmpJph3GDYbU5kxEcwosD94hkMzKT
	SSINlX6DSHGUmnDQetBeG54YSGwk6zo=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cd8ba7c2694so1061794a12.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795071643; x=1795676443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+3lWud7DQJXjUbfSMY4r4QoMTzIguNTYupF3jSPDUjo=;
        b=DdiADQzN+AkvuG0wWYwIl/C5Zl5CNjWUbbK1XCoivaUfq2B6gP7NvzfhCqiSDqhiiB
         80/0BYi4BDn3EVrIp9Lrsp6jELZr9dEr44YajVWeedUuGjAywLvEqNVoDNkwyNGN6GJN
         ixLtkDjEYPUxEf3sy5O4vTGqgLIjOGH7Da1cGfp3lVXjY48zxoqEZ8iFDgShs04xMa6s
         pGXXnxiRj8S/qCViMKHPr8iFPEOJeavXtd+KCRDHg1IwF+p4LsUrVquDE3jVZHRTl/Yy
         DiVcqr/mSbEohQqz4duhi/QS7V5kxwoNApK7cF1M2UzucJEWI9MmQgaSRSB9Ra3VT896
         9vtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071643; x=1795676443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+3lWud7DQJXjUbfSMY4r4QoMTzIguNTYupF3jSPDUjo=;
        b=SZ99e08xUmILDD1LlEQpWVWGQK7xOYJn/fiIcpemPZ60Xue/2RLYjUlsZF620ky5LV
         uRR3/wqA4dbkOTL+IZ7nkaDsaUV8Y3Noa8m1lOxW7Wijf6biubdJrO1pJT+WoamVpBKg
         mH8qKQfz2Ze5B7cj16PtiW+wxP4oR/FDpYzK7OYHmdamN/Y0ifrfeAmKb764w5bXOqlL
         lIFaPZEPnCqjZnPg/6I5WVUMaQu7ufO52vnFfMcAbcb22sIU2+/DT+MIasqc7XlvyWx+
         FHxh86JCF8uQvdm4Z6Lcx75Zs5RZq40cjMzDBRpYgFwvg8hy+pcHCM+CYvc7Lb9gWvb/
         wRMw==
X-Forwarded-Encrypted: i=1; AL+hErHnhO4BJ0KpLZTd+dNWTWvyJvtOAKYdSj3VkV+CPkezHgZP3YKyGzMMCdVuQWq2LSwhg1KkRkwsnA==@kvack.org
X-Gm-Message-State: APuU4Z+ZVffUq56GMTRVX2mW9qYoVuaIVIT8rpOEceNvYu+DhYWQOhYu
	ns/h/IJ8Tl4eHZmbzqwnZHmy8K2yqtD7b6nW3IdYK1jhPWH/PuN4BUml5BuTqv3SE00=
X-Gm-Gg: AZFdTZfswszyTcuU5pqE4enpX5ld0s7wx6oP9n3YixCyeZT3h7cPG/kM65VlQ+XeMlt
	seVSvMLIZ8G2+t6aYhDk+MNc0Ku2VUaVMnhHxwQ2Mn7Rv/f4jBbp5G13nir6BmW8ZGyGuYI8CAf
	/yEOywtInM1EKRqgRgAzjIxxa42HzS9ZqiVbCLAFzHr2OBrvNUZP0JLLTxTPtv+nbZbTvUCM96E
	tsGI8cBgN1PGlpHgv3iL/Ih6QnDDWrQDFX0DUxt4az4wYZ0Edpu672nNhGmaWPHObcl7VLR8guD
	YI8LQ7aXn20dqVocm0Vc9DX0UpcY7xJ+dLVzDWKCBHo1ruAgOcw+pA0kqUs1LXTn4LdZLWloIRB
	WXYSbCvQoFUhlqfxpSG+eekp3NqvUu7SQ/DlIj9Qjvx7fhyyWC6maVpDP0e0YJwQDt18/8yRNd6
	dSWmjZut9W1FgViinTcogsGU08Rsmcw6W1/A2JeAV7ONBa/YzeiUq2eWaptlEqRsmH/TPYtMTkd
	YLAM1MlOgPhe8UhiGtQBt6Fv5ZqP6Xw0LuTvQYYZXvo/SusXh4BB5lgQTpt9JsTLTg7vqGW//GP
	LOehv8KJyUcUO1/bXlgiT9QiRCH+3mDfwAWoa3SIqg0WoRID5zJKnVuIboA=
X-Received: by 2002:a17:90b:3f85:b0:3b0:d551:ab2 with SMTP id 98e67ed59e1d1-3b3d07ca535mr5027632a91.51.1795071642703;
        Wed, 18 Nov 2026 23:00:42 -0800 (PST)
Received: from G6L4RL2QG9 ([2408:8440:c38:5ca5:3175:932a:757b:716a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402e75223sm597488a91.4.2026.11.18.23.00.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 23:00:42 -0800 (PST)
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
Subject: [PATCH v3 4/7] mm/page_ext: use common allocation and initialization entry points
Date: Thu, 19 Nov 2026 14:58:09 +0800
Message-ID: <20261119065812.89959-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119065812.89959-1-songmuchun@bytedance.com>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DD646160005
X-Stat-Signature: ffwoxqsxc9e8ggxbstw56kku3k79qasp
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795071645-109476
X-HE-Meta: U2FsdGVkX19A2tUbHL6ioDayI0BNnZbkVI12qcVzQe6VzToJizoQQkuIzmV8NOJYmvBGMx1W2NxtNB7wLSZkW2Uc9ZXg0Ki+k4mN7zRvY8HpAPPQX7Uzra4QGlDkxdYpmp79Jk8MDg8wSe7koKM+YM5dWmn2COeffoyIMyrlMS+EGYsXv+JBg8l0UQmdEMgr537JtXUTUh8mXtih+CNChZDejEe6vrsUQ4J1+9sem0L5c6vckiSr0ILsaGTghJhpm7dwsPUZeJm2FpvFmTBY91wn3r+SZKSf/teEHco2qvm75u8JZavyVsJq0+27pNq9VoBLhQgj+YZrxU0XTBBR+6nb1eBWoqICRSrvJFvRYCJzxbzcRomNRnF934D1sLmXQQwEsOh/+RDpJV/7DdzNbPl7xeSY3IJ/J0GehnR10elSMaQ2fVrmZAB+imv/dFvwq4fAxE7Qj2pcrPVhvml4EXYqUkJqQ1TTqLzUlKS3KJgwwqObAt9rU4mZtzM9PrNYBM8nxhTLzk5+Tp4gMwTrp7OJgKbcepe6pCy1Me9S6tRMcF1DCePexEvzEd9hWiZ9HzFSXUZqCeRIdpecO8auYlXMVzq8XGARdbsuSClF5UnNOCi2VpKqQOFa8vWoYnNJQAxC5MJP+VVcsVaEMVjerzGhK9s80SEKL4acx1xLrdbAXo2F2yXmXe8hoYQsvRybx+R/RqfVmpuYcRAD3XEVfrPWJlVx1/PVfhATqVgU2N95MsjdIDAR/DAZf8vgNyEDBjSBZpeYNidGYocfbWFZOmkzbyK4ZDsFjfcRhUCyEpUTTbQKY8/1dntsWTx+QLB68IFVMFJMM8RNmcj8g6Db8WrJAiZ2Ipq9m0g7D1kWm+S8cNPjfgFtpuGB00nKVSjDw4GdbVTHN/3h/tRde+j/CetsdBa5qfcnQWVdm5S9ySd0uBgWJdn1IzSwsEuOz7cMFkh6XxG3CrF+I4WGxj1
 7H8XnSWO
 HN71uWB19dHI7rxZqi9eRe/yEYmlPyXgVrzud4YHI2MXAPapX9sPExLqY0gPJyhs9MxjXfcs65+LZ0Wt7yhaz3vQZeGN/SgH+5XY4WuVFx6bScEiOeGYm7P8R6Sr2Mcd/wVwIzEMUM+2PkgrkffWpBhCTcF2oof3zgwlRgKZz3dl01j1dTwzkW82C845utTGeQf4rNMsz2VL8Nb5iwtMNBI4AvaJS/JZoqEWkpdxoQ1frsV5Np5IYxX1PtEpk4DGk5pjdOSaoeeUPlLfp1urmlcyGd1lB7I55avrEPvEKI/PxSdVDclwPOKqaj1eXm8rsqZ3Bq2kuXURIdC1ASdTkPZDaFaTP0PO5K8M3fVKJbpuDUGy4DeZ3YhExc23b+Y/mUFyPCdBnKDV1JQw=
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
---
v3:
- Collect Reviewed-by from Mike Rapoport and Chris Down
- Collect Tested-by from Chris Down

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
index a9d848c92678..bcc4e7e8cd1f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2709,7 +2709,7 @@ void __init mm_core_init(void)
 	 * page_ext requires contiguous pages,
 	 * bigger than MAX_PAGE_ORDER unless SPARSEMEM.
 	 */
-	page_ext_init_flatmem();
+	page_ext_alloc();
 	mem_debugging_and_hardening_init();
 	kfence_alloc_pool_and_metadata();
 	report_meminit();
@@ -2725,11 +2725,6 @@ void __init mm_core_init(void)
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
index 6196bab6868c..aff00f4e1bdd 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -185,7 +185,7 @@ static inline struct page_ext *get_entry(void *base, unsigned long index)
 }
 
 #ifndef CONFIG_SPARSEMEM
-void __init page_ext_init_flatmem_late(void)
+void __init page_ext_init(void)
 {
 	invoke_init_callbacks();
 }
@@ -243,9 +243,8 @@ static int __init alloc_node_page_ext(int nid)
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


