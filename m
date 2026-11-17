Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F554606A336
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=kEw4Tcpi
Received: by kanga.kvack.org (Postfix)
	id 2E2866B05C0; Tue, 17 Nov 2026 07:07:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244396B05C1; Tue, 17 Nov 2026 07:07:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D666B05C2; Tue, 17 Nov 2026 07:07:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D00CC6B05C0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D1201A0400
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:40 +0000 (UTC)
X-FDA: 85444486680.05.680025A
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7268EA000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kEw4Tcpi;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917258;
	b=bbZlqHGLaKHiRjV/M5UE6v8102568BrKWeEi/pnZfl1Yovxz2erbzz+aKgTIb/KeKmn19E
	HjwJ6KcJZjZkyDqqr6Q+GoIZf+Z4Ke+Eh4o0kilpvRFGvL3zijCrHSfDGuBsVn7tIAEDEW
	BQ13hBKqmSES8SXzJUz5ciI7os7kSPM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kEw4Tcpi;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAIHywl1MwtQvs1NN9GS4hVFASUu/1jjvVICxYuSB7M=;
	b=ioc2XxXWyZ96knOSKtTEwhaiOCQVEdFql97mkta4iGGLAaeIBJA1KmVlDdDvu8niDH7jIP
	a8Wq0MK/ooaneKAile5i2kY4OOjz3bAMgjgvrEvqGDxi9Ynyp1w+N7EUriLdlls1qgOKWA
	LFN0BzzN/cgnpKyqfAtlLnJdbT0RueQ=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1b3b4bcbfc9so5385250c88.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794917257; x=1795522057; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gAIHywl1MwtQvs1NN9GS4hVFASUu/1jjvVICxYuSB7M=;
        b=kEw4TcpiTuaYlowWx5ghv074+AJiVCQyaAVTmNlo3mJk3rmZBnAy2mn6DTufx/glcH
         jNCnful52N0tvxHoMt2jBRD7F+k5Zx6EWM7++ujhLaqOCrmA6QonVS4WmKjRxyGiVtEF
         sWutpE6I+Y6YQWrxTOHoledl5j0/q4afeBqs8Tc6ykBC82FNphVkzxBSZ2sgb2q5US90
         UM2D4OrWJbWSEDnTlHqk+t/K+KPz1hxi54p15ZSMOeKZAGUfW5jbenXq0NbON/cQ65Bf
         /d+7DQslpY3wJzd2mcm2yeplnCsAWvclASPaQXt1TtGZGuKvWUgMhsAuY2VTkCqMA7YT
         FcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794917257; x=1795522057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gAIHywl1MwtQvs1NN9GS4hVFASUu/1jjvVICxYuSB7M=;
        b=gkIc4KNPrxjBBfuyuSAcZFchyPQ4DwRE2M3yQz76gJiewuFtwQO7UnzwT/y3aamosn
         BeTIxDYFvSjAakqvFhzz9BCTiaBaiHhnXqVfBAxE4OEHHK6vHt/RugwalCLr5MQnTwqO
         BoBs5gNPiMQ1i5D9LPBIyU/hKY7sdVPhQENKZ1db6e6FCkiPCGHJZ8bkx7UCEHsGKIz0
         MPfEi9bh8eF/p4PZNN6K0K37f5DOK7FIy8nhETGvdpSxKQ+rDewmO2+sq/EuTBcAFntm
         mHYorAHI1idkpL95OeTQ9CqpPE0ebP+rs3bwEVeK9i51dOq3XBLiHdlM9MuuEvL6VJo/
         QKfA==
X-Forwarded-Encrypted: i=1; AL+hErGSkIG5VHZrZSO7B8kiWvp/wq4HnuYMhj3GeSW6OxGigvKkaMqamIvIAgt9wkuTKEO1KY+QL+lEcg==@kvack.org
X-Gm-Message-State: APuU4Z9B5bOMM6gvPvZPxSfR4HeUPkaUkLa6I0l96srVMAjAexG9iQgI
	M1cBi2k/IFiHp83oUeOS36tVFGwm2O0+HgQ6aW3vqPmVwwA5Xw5FYf4HssJmmPPKuUo=
X-Gm-Gg: AYBFou1248iIkKK5SRvAMzgXMJlcKcNA4xEnXThTOP2/PNepmRsywR/CsaC3oK6yXIi
	4xvEPoTcNE3iT9HCQle8P58424RduByJpE3AO6wB3HcDD6bTqVJwojq2y2CeJNyWAA1hRhwLNeC
	YHZ68yl+skkqQ1NGCcAsR19Ry/K9KnhompTPbfX3o8ENGy5XPncR+B8kBD1PjLKrCswNLp03m/n
	2kCdbZOQJ6tzd3LpgwnVHrSWpzKb2Lg4nSRDs1SrSq2oU8/4Qmif9BFCnaMK/w5MyTc89wMZ/jX
	GD0/Bl0QmBzi9HeV8MLYxp8w/b9d8jWg+/rI4be3GyJWEfSDnuvE1co2/7Ucp0RaEN49ActgneL
	mKikWAPq74ifTpqOs2bJ0VJad6cNhmbOAB+K8AFlrb3+0wqBLC9Aby3Ue0/6ZVX8CVpjm15A1ay
	t+WHKVXPpSfvqKwg7lzAmHW05SukSn3M0+cMXc+FIZdmIJIGe9+Nz4/MXMww7L7G16Ihs17gBlE
	Wwl+g0LG2/+lFF2eP+VsxPRIOdnniLfsPLAMZ4WIJvDsYI3Oh9owXm+NxTkRJ46vKfCRQuWlBo3
	j/R2lAJ5hPh2V/Pus681bYOoQDUq9J3YHthEWTf1FIiJ7OpWCfMz+M+tFkYTqQ5ctQ==
X-Received: by 2002:a05:701b:4508:20b0:194:9e7a:3ba2 with SMTP id a92af1059eb24-1b50306c4d3mr13554786c88.2.1794917256945;
        Tue, 17 Nov 2026 04:07:36 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm47347116c88.5.2026.11.17.04.07.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 04:07:36 -0800 (PST)
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
Subject: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for SPARSEMEM
Date: Tue, 17 Nov 2026 20:06:25 +0800
Message-ID: <20261117120627.50601-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261117120627.50601-1-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7268EA000E
X-Stat-Signature: nzsijjffbmu4wjprsand34ec66hwj3i4
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794917258-903228
X-HE-Meta: U2FsdGVkX1/PbR02wXVedO4xLcfLkCsWyld9+LuuIfCJWeoCLkUsykI9dfvxXLViP4jSWpv0vp2aT8r1+u3zBcSVHiw2dpFDKY1eal1SNzRm7f/7Po2MG+h1ENQLDIu5EPiaAY3f34s0P4jzHURPGIXzDKWjia0P36GynI+NF2s849zWgpeVq4eiDzZo3SS4vp/HdvAbKCZYifyfW54fXz4rtpY0csYT91Ez4qVBObqm1YVl3/N/gMmjIgB38JmGpf11tPr7mA97kk/89ihh4Fx4jyNOfYI6gn7GY2lCRsZRckuCYYs8pUuZKD+lxklPk8JVJzd+ULXHQYnwx1nRK2/f1RqnC+SCEpiGGvjz/a2+LSNgNeo2q2TYUfEYJBk3q8ur11zgEoSINXMRr7GTBmW+OlVJBuZm0SoVtmGr3kmxG8UjYRiUiH/JtujpxicsVRFtE8UDb6ATXwPh3Rg/dNUVlwJ1alAJpyscF9dZH8oedK194sgjplDgZ/XiB1qsvnb+fK0RpTozkOn0sFCCY0qHyPain5E+PYlMsb5Q+930Q5wx/qxYiubs8FjNwD+aP9kFZSiHWPfNTkiqUHL58n8Vbx4VfeqgymjGOdmsX4ZNavehArEheD135AexOSGNFC84vv6wkvK4RL+H3BbRSJ9iSGBe0A99maD9fA+D76pp9vOm4VqA+U1nEzbUzzwZQ6FKVLDwNNIyxMoUjYic+Z/ND2GUBhzWVRXLMwYgaUBi5//SOc4xr4aHd9uejsIf+NPBHQlactmBYWY7qicf3gBfhelTawRVzdw5a5KpQHLk2GGix89oifI7n3AynQvsc97OY2t+TEjrlCK6HCm/CV98CxGCnsYCdhbw/BSYTHWXaLGm+v1EmieAok9NUdEH56M173YXLH5HjMDC52YjYfsZqZD/2xlsLlth1tBp94zY7xhvD+jPI6Vv4RTOGWvA3Igz5pFifcf9eqd+O00
 FCYN9tQn
 n7fN+clTCOlAtH4ycxzmE3ak5oYrcScKw+2wgFns15YK9ak+5+LgnemcVlzCaZWw/Et7Jt5foGSmK/F9bJyY+hpIy/YTSWGZ27DzFfMmSIOZPaPMFUfseDJq4+vZO7N9PjxIXj9pJnrHUARBGkETER2C5w/5OTbwkwDXuQ+ehLUc6y4Avm5baewKixbadrWYtoaDiiml8KQBUXSL7QNVPjQDPexFOVWcrVQqezs37WLqnLqeRvurpwqGhib1SmEGdu2x7nnVsVjyzIkC0ok81l0K8GGVBj6LQ0zVzGacjPbjAZJ3aYPreeXYyIZFbFNjnbEetSQF66lnl1WiNY7+Idz2F5Y/jKUIhh9RKPd22S0swU8A=
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
---
v2:
- Allocate all boot-time SPARSEMEM page extensions from memblock
  (suggested by Mike Rapoport)
- Keep memblock allocations above DMA and suppress per-section free
  messages (suggested by Chris Down)
---
 include/linux/page_ext.h |   9 +--
 mm/mm_init.c             |   4 --
 mm/page_ext.c            | 119 +++++++++++++++++++--------------------
 3 files changed, 60 insertions(+), 72 deletions(-)

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
index 7344e7cb8196..baa2681857eb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2707,10 +2707,6 @@ void __init mm_core_init(void)
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
index b41d4a957bc6..2910727e99e2 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -12,6 +12,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/slab.h>
 
 /*
  * struct page extension
@@ -180,11 +181,6 @@ static inline struct page_ext *get_entry(void *base, unsigned long index)
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
@@ -238,24 +234,16 @@ static int __init alloc_node_page_ext(int nid)
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
@@ -282,13 +270,21 @@ static struct page_ext *lookup_page_ext(const struct page *page)
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
+			memmap_boot_pages_add(size / PAGE_SIZE);
+		return addr;
+	}
+
 	addr = vzalloc_node(size, nid);
 	if (addr)
-		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
+		memmap_pages_add(size / PAGE_SIZE);
 
 	return addr;
 }
@@ -304,7 +300,7 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
 	if (section->page_ext)
 		return 0;
 
-	table_size = page_ext_size * PAGES_PER_SECTION;
+	table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
 	base = alloc_page_ext(table_size, nid);
 
 	/*
@@ -331,11 +327,19 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
 
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
@@ -449,52 +453,45 @@ static int __meminit page_ext_callback(struct notifier_block *self,
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


