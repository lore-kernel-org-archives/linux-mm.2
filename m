Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9564606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=l1PoppIo
Received: by kanga.kvack.org (Postfix)
	id F21806B05BC; Thu, 19 Nov 2026 02:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2276B05BD; Thu, 19 Nov 2026 02:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A3C6B05BE; Thu, 19 Nov 2026 02:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AED506B05BC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:01:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36478A80DF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:01:08 +0000 (UTC)
X-FDA: 85450971816.09.DA753D8
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 003B01A000D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:01:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=l1PoppIo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071666;
	b=VQBH3uqFP4Mzy6MxmZp5iMk1XegatVXt3NfFzMzxzu6pcqT3TJEkKF9hcFJ20jGdRLYyW3
	khsYjFir/Gi9h3kqjQhsXeV9fjjKGKz1LU06P/bAZhZEU43vgsVtLVZqrBMl/0QJqTqP0I
	+XBOxDzRvmzw0Jr6WoZKpsQ/Nutgcys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+FnLhj7qRAFWKIuwGU/FM3UqUnlL/5I23zrp6FTFBI=;
	b=oKv60RgEQDDIEp0lMJCttGS04eJmeacqmw99By6mOx5iOr6WHPs8fUki3zsgu/eTXQJgQd
	tcUGKD0M+J6rFrVMEqwD6xOWmrG4e6VHG6+cTXKC0iMih4JlhPsEUxwAhv+NpygJ3Uy4V2
	ZWErWO5TneQvvFTyaPE+lB6S++L+i4k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=l1PoppIo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso510044a91.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795071665; x=1795676465; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D+FnLhj7qRAFWKIuwGU/FM3UqUnlL/5I23zrp6FTFBI=;
        b=l1PoppIoVEkviyNOMksLDRwBj6c3rnNTc4lt6l3eD81MtsUss8EwLf+KsPt3aOKLuc
         BlA5y76BIMGkQ63e/Tpsp/jEmc32ZDI6CH2J4fIGHLrbKchM03DoIRzYdQzUbpj0Cdml
         RSaUBWDnr+dj/Tooz9+0NIwDe7GQU9y3LZnxU5FxSAa9sS1ynxZAwmiijP56p71GjiFo
         sOQSvyKjVLPrivFlgiyhuTy7e50YOuDwwPZJu04RtgCF0KDDFdIDPufGyagk63reBBuS
         nZTRe2fFo2mX+giLLzjujvOqagjgbKeAmurmuJnxMD+SnYHWZvNyD0Cxvt9ONSxJ/we5
         XSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071665; x=1795676465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D+FnLhj7qRAFWKIuwGU/FM3UqUnlL/5I23zrp6FTFBI=;
        b=OCnJHE7ttu+kU+rHQ4rYx9S6E4t+LRIQI+BufEiXO82vQmQAdfi7RGAGPzaZycgp9s
         ou7O0FvEKGe9xmgh8PLHhW/IhdvO+H5Wj/hfMdt3n57E+CbqetYVSA7Fze/UCMBS+0fl
         AlGrV1GSUw7h3qtbU55aGmJhRZquF8Fv6yYNAP99DbWD4d9gdK7gIPHDNRAyQ+S+dGd9
         azB/vDJEy8WO6Eb8haOT0snq53s+YjDfDQFK1tQdPvA3rRB+/V3GRGhaOIqaw6ddHUmW
         dFx/QQX4YBkeHbmw0vipgPLSTAmNaOS77xUnXMdY4xgD9EkBX8DMLwbztv+FrK/DLHKf
         6vPg==
X-Forwarded-Encrypted: i=1; AL+hErHBR7NcgcvT1zUEfjGp3Dc/M68Gb7AYUAr8ISRMlLWzRLQLJCS2gRkU6OiVTEmHsJt1x0nJAAFl+g==@kvack.org
X-Gm-Message-State: APuU4Z+bAjnypZbt894sZp9qVXrw4AJhWlVQ1pmn5Oswq0hrI9AziyHv
	+wuTyvI1LjM0ujufJ6j3OxQJnkLqGqG/VJu6AF8f9YmmtxyVU0G90jAO502NBLk7L10=
X-Gm-Gg: AZFdTZepE+0dhtIoonvO3oZNXfV+Vw8Nf1VSg7v3HdBYCbNuoycaBTFIsFikFemiUWd
	hwcfXeb9oxEPKtsdXnh60LXR3AILgP9D78Orx3ZA40GlxpSPLbmkZWfmx9huvh1nbI5bERzQH9I
	mlKdXlR+XFbzn9+WvwC/oqd9T9aVBF+L/0OuqSSyWDIamlJpiKhDeRb8sDVBlXgZh+b4m601Fnv
	OI/RA2URAZGX6oTpzfqd/Ytfl0A/iP41TV5Nrp1/4lDD9khFM6WIsC8RuYAkxpqzOur1puP2QUM
	J7z7TC12+FjIHyDEW8sKXjVI3ZgUawUpIGHQwJwldbiEZhlDVoV+lEf+aaQ6AIKN5//aFKtd2RY
	cxLL1kvdqndn6yw/4n+FQBdbD7SNDNs75icE4KcN4lhglyrhKkJB4oug+DSKW0508oSVdudFh3O
	v68ftY9rJtOyecY5lAygIS84joIRpDw8gj06x9lHeglKEbtAMO6V7jRRTfEDofFLTn899MsZts/
	otaYjM6NOl2sU6vk+7IfuDt1g/o5oSFQBEUtMHP2b5fJfUZ+8CRqjdWsfJupvSJxlqiw2uIc/K5
	VtNvjUjbsRiaSd72f3clbNCIQKCJkx8udCvoFKrYvF1LMYwPHlO9pmuAgUQ=
X-Received: by 2002:a17:90b:35d0:b0:3a4:7195:ecba with SMTP id 98e67ed59e1d1-3b409fed4c9mr143623a91.20.1795071664611;
        Wed, 18 Nov 2026 23:01:04 -0800 (PST)
Received: from G6L4RL2QG9 ([2408:8440:c38:5ca5:3175:932a:757b:716a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402e75223sm597488a91.4.2026.11.18.23.00.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 23:01:04 -0800 (PST)
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
Subject: [PATCH v3 5/7] mm/page_ext: allocate page extensions early for SPARSEMEM
Date: Thu, 19 Nov 2026 14:58:10 +0800
Message-ID: <20261119065812.89959-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119065812.89959-1-songmuchun@bytedance.com>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uz43by1dbxf7eq8cyqw77x1h3xd8dywu
X-Rspam-User:
X-Rspamd-Queue-Id: 003B01A000D
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795071665-381282
X-HE-Meta: U2FsdGVkX1/DnconcPUB8Gfiaf5c+VXJ6t1cuviuONH8nsbRKOOIrl3JwV/LhLMX5BDXetzqzZIk9cirg/gOr7JELCOHX45UP9C1V+p+wwPG9c1ulOUAzUov7F6EzgtYFW9E55/R1J1J60EgQdSKRBeLYoje9QoqgvAYyYV97oh1TuSTTPjwQpdP5/o8mMkYHK9/bzOz2L2xZqs31TzV/1ZiZx7veti/V+TZERr2rUHCppD0ps0rvrGxuc5nj6PhIiQ7iIzVKj+Mnf7v44SsOfv+g4A8Up4F6nAmba5o8hMpijURlmh/PBHQbqiSlWsXYvuIJD7FgXdR3pvDzcqsGC/dr9toJlPah8A6Cbyxi7DDW0k/2b6rOpys51wMN9gmvSit+lBmqtOlfZzIHrtkIGVGcQb8fDynWUOcGFsBFmvctKFPUts/jzDHCW0cQRn0TE8+q9O5x4Mapu3ACTWvaT1rhejxf4bpe+b/pb6xL2AK94eCLdQgjBG9FLFR4YJx8lJMpf8mNwUJR5P8wU0ikM7ESweIuU4bTiG/mIAXtgPXL8IhHSaAFbVxJKjBr/+CB7QJBK6H3n9iAs13Ikp+ByIJHQc+Y1EbIyNU4hC9Jw2XeH2Tl8mkPsYKHA6JNXOg40ex3BSWQeCoRFDyYZBmHf2DSi8r8qgrgk1Ki0hokTbOePTs6SC1jBI1Cg65DmTbY1t+aAGcdFVdVXtyNZwfsNACnf7uZVPeEb6wuUxTQ8qMbO6iwus79be/sZFNdyJdBkVw0buWbxvxkFgorS4xfydXonkxPlFHPedqPF1Uex+U40E+kYYTQ8jiY/qSEseHR3atpTf7yGH9QkBFBQ3GR+LbD7D4HdvaIx3KzJpF62rQBx5vYSAvAbCXalHOslobI3MLhuDKOvSWpHatWZwnpaC0oRMhIwESbQyNzsfeCn9ymH/kBiRSVDh3hx1KL5JWLmhd1WKQQ4jbgU6VVVp
 xISxCmjR
 UQBrBAVzsSYpsg/DLZT0Ze7gDbNk4xz7rqmSPRUSmg1c20Y4PLbMCgSyGYZwtHZjT9BlPS+T8bV7vBYeA/w7/3mcCzDRMRuG1Y/HUB9UT/Q8+pBMkPA+meozy8YuqLFHZv9+QXkPgaWlCmAYon3/CbBiklf9J5pjVLpNuel4LY4cCpAQZMQIcJof/GqTJKX8B55PM8ciSKYrB37wdhJU8YkjcBp+Qhd+arslqqVyLFqX//RUPY0sEXdKzir8/xUvvN67s6AxJa1fflQsTMJ6f5Yo0HO8PovlCx1GYUpCRUhCkXas1TsPtxQQoR6yQD0xQes6aL/SGnzDK8lx4EA0SykQAlSMpfnVaZtSFG1Aue4hm2K6ld5O+F0UViBZswFQMjioTkRk1K2WO2QTjvBWP7H0ooLDpZ7rz7uW3I1evDDKv5auU+snGSwt8C+ef40e6zlFm9cuKSC9bTlL2rGMGhMcYpubHwcw7yv0jGpV4DTgVqmRX/3z4NzaFfSGwqgeT/Q9sHIUjbe01J6WIQehBc14uTVtyt/5xIORa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KMSAN needs page extensions when kmsan_init_shadow() installs per-page
metadata, before memblock_free_all() releases memory to the buddy
allocator.  FLATMEM makes page extensions available by this point,
whereas SPARSEMEM initializes them later in boot.

Allocate boot-time SPARSEMEM page extensions from memblock to match
FLATMEM's initialization timing.  This gives early clients the same
page_ext availability guarantee across both memory models, while runtime
memory hotplug continues to use vmalloc.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Use DIV_ROUND_UP() for page accounting instead of relying on the
  caller's size alignment (suggested by Mike Rapoport)
- Collect Reviewed-by from Chris Down and Mike Rapoport

v2:
- Allocate all boot-time SPARSEMEM page extensions from memblock
  (suggested by Mike Rapoport)
- Keep memblock allocations above DMA and suppress per-section free
  messages (suggested by Chris Down)
---
 include/linux/page_ext.h |   9 +--
 mm/mm_init.c             |   4 --
 mm/page_ext.c            | 117 +++++++++++++++++++--------------------
 3 files changed, 59 insertions(+), 71 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 911a84bbb3db..d00320106a58 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -61,12 +61,10 @@ static inline bool early_page_ext_enabled(void)
 	return early_page_ext;
 }
 
-#ifdef CONFIG_SPARSEMEM
-static inline void page_ext_alloc(void)
-{
-}
+void page_ext_alloc(void);
 void page_ext_init(void);
 
+#ifdef CONFIG_SPARSEMEM
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	/*
@@ -76,9 +74,6 @@ static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 	return next_pfn % PAGES_PER_SECTION;
 }
 #else
-void page_ext_alloc(void);
-void page_ext_init(void);
-
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	return true;
diff --git a/mm/mm_init.c b/mm/mm_init.c
index bcc4e7e8cd1f..ea763e299769 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2705,10 +2705,6 @@ void __init mm_core_init(void)
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 	alloc_tag_sec_init();
-	/*
-	 * page_ext requires contiguous pages,
-	 * bigger than MAX_PAGE_ORDER unless SPARSEMEM.
-	 */
 	page_ext_alloc();
 	mem_debugging_and_hardening_init();
 	kfence_alloc_pool_and_metadata();
diff --git a/mm/page_ext.c b/mm/page_ext.c
index aff00f4e1bdd..cfd20ed72884 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -12,6 +12,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/slab.h>
 
 /*
  * struct page extension
@@ -185,11 +186,6 @@ static inline struct page_ext *get_entry(void *base, unsigned long index)
 }
 
 #ifndef CONFIG_SPARSEMEM
-void __init page_ext_init(void)
-{
-	invoke_init_callbacks();
-}
-
 static struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -243,24 +239,16 @@ static int __init alloc_node_page_ext(int nid)
 	return 0;
 }
 
-void __init page_ext_alloc(void)
+static int __init __page_ext_alloc(void)
 {
-	int nid, fail;
-
-	if (!invoke_need_callbacks())
-		return;
+	int nid;
 
-	for_each_online_node(nid)  {
-		fail = alloc_node_page_ext(nid);
-		if (fail)
-			goto fail;
+	for_each_online_node(nid) {
+		if (alloc_node_page_ext(nid))
+			return -ENOMEM;
 	}
-	pr_info("allocated %ld bytes of page_ext\n", total_usage);
-	return;
 
-fail:
-	pr_crit("allocation of page_ext failed.\n");
-	panic("Out of memory");
+	return 0;
 }
 
 #else /* CONFIG_SPARSEMEM */
@@ -287,10 +275,18 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 	return get_entry(page_ext, pfn);
 }
 
-static void *__meminit alloc_page_ext(size_t size, int nid)
+static __ref void *alloc_page_ext(size_t size, int nid)
 {
 	void *addr;
 
+	if (!slab_is_available()) {
+		addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		if (addr)
+			memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
+		return addr;
+	}
+
 	addr = vzalloc_node(size, nid);
 	if (addr)
 		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
@@ -309,7 +305,7 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
 	if (section->page_ext)
 		return 0;
 
-	table_size = page_ext_size * PAGES_PER_SECTION;
+	table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
 	base = alloc_page_ext(table_size, nid);
 
 	/*
@@ -336,11 +332,19 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
 
 static void free_page_ext(void *addr)
 {
-	size_t table_size;
+	size_t table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
+	long nr_pages = table_size / PAGE_SIZE;
+
+	if (is_vmalloc_addr(addr)) {
+		memmap_pages_add(-nr_pages);
+		vfree(addr);
+		return;
+	}
 
-	table_size = page_ext_size * PAGES_PER_SECTION;
-	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-	vfree(addr);
+	VM_WARN_ON_ONCE(!PageReserved(virt_to_page(addr)));
+	memmap_boot_pages_add(-nr_pages);
+	kmemleak_free_part_phys(__pa(addr), table_size);
+	free_reserved_area(addr, addr + table_size, -1, NULL);
 }
 
 static void __free_page_ext(unsigned long pfn)
@@ -454,52 +458,45 @@ static int __meminit page_ext_callback(struct notifier_block *self,
 	return notifier_from_errno(ret);
 }
 
-void __init page_ext_init(void)
+static int __init __page_ext_alloc(void)
 {
-	unsigned long pfn;
-	int nid;
-
-	if (!invoke_need_callbacks())
-		return;
-
-	for_each_node_state(nid, N_MEMORY) {
-		unsigned long start_pfn, end_pfn;
-
-		start_pfn = node_start_pfn(nid);
-		end_pfn = node_end_pfn(nid);
-		/*
-		 * start_pfn and end_pfn may not be aligned to SECTION and the
-		 * page->flags of out of node pages are not initialized.  So we
-		 * scan [start_pfn, the biggest section's pfn < end_pfn) here.
-		 */
-		for (pfn = start_pfn; pfn < end_pfn;
-			pfn = ALIGN(pfn + 1, PAGES_PER_SECTION)) {
+	unsigned long start, end, pfn;
+	int i, nid;
 
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
+		for (pfn = start; pfn < end; pfn = SECTION_ALIGN_UP(pfn + 1)) {
 			if (!pfn_valid(pfn))
 				continue;
-			/*
-			 * Nodes's pfns can be overlapping.
-			 * We know some arch can have a nodes layout such as
-			 * -------------pfn-------------->
-			 * N0 | N1 | N2 | N0 | N1 | N2|....
-			 */
-			if (pfn_to_nid(pfn) != nid)
-				continue;
 			if (init_section_page_ext(pfn, nid))
-				goto oom;
-			cond_resched();
+				return -ENOMEM;
 		}
 	}
-	hotplug_memory_notifier(page_ext_callback, DEFAULT_CALLBACK_PRI);
-	pr_info("allocated %ld bytes of page_ext\n", total_usage);
-	invoke_init_callbacks();
-	return;
 
-oom:
-	panic("Out of memory");
+	return 0;
+}
+
+#endif
+
+void __init page_ext_alloc(void)
+{
+	if (!invoke_need_callbacks())
+		return;
+	if (__page_ext_alloc())
+		panic("Out of memory");
+
+	pr_info("allocated %ld bytes of page_ext\n", total_usage);
 }
 
+void __init page_ext_init(void)
+{
+	if (!page_ext_size)
+		return;
+
+#ifdef CONFIG_SPARSEMEM
+	hotplug_memory_notifier(page_ext_callback, DEFAULT_CALLBACK_PRI);
 #endif
+	invoke_init_callbacks();
+}
 
 /**
  * page_ext_lookup() - Lookup a page extension for a PFN.
-- 
2.54.0


