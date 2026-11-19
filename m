Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05361606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SCQp41wV
Received: by kanga.kvack.org (Postfix)
	id DA8A26B0626; Thu, 19 Nov 2026 07:02:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59AA6B0627; Thu, 19 Nov 2026 07:02:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C484F6B0628; Thu, 19 Nov 2026 07:02:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 936C26B0626
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:02:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20611120A79
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:45 +0000 (UTC)
X-FDA: 85451731890.19.45A65A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id ABFE8180013
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SCQp41wV;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJpa1vQKPwsA3exeR0zFQL8OS++YNOFFgxas0w1fwx0=;
	b=mMGNnTtdkUiD9CqepQ441315eIlasajQMahJVDwhKrRUVJ5/pK/As8TkJMmaxn/7leHc00
	051yBxMvWOwb0jc8KQ2QwQXrEhJZ8LuvhAkDScA+iljfLnq4g+a6TA71IcT07zXjLmcebl
	5Ja/uzVn2pi0zBTObVpmz5MyZdU6gxM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SCQp41wV;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089762;
	b=Fk1yZBWXBiXcI3OXgSABLe7Y/Pse8UWHI0/ndK6oVFfd027wB/Z7eAA55M0AX8jZdhBelo
	9n47505Zd93lgPzHmlcyd4D/04fI/aQcwTN2Wnl2m3eMT52sX2ZU9GJqiScJXWA5RzFxXI
	brjm29Lr9xHPolVT9i4mndCID+7cEoQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795089762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AJpa1vQKPwsA3exeR0zFQL8OS++YNOFFgxas0w1fwx0=;
	b=SCQp41wVTh+Um3yMA8Uy8WUrzAHtoXHPfbiEK0c+blOuNsiF83AaVmYMapInVfeYHEKUsv
	VzsuyiCpjLCN/rPPRUWqnAwMTSRDpF5y0MNxckOZZ/RUJicnwkahLYXuDu/ORgPmboWgaE
	GVZzRhkCrAgfJJTr0RTsPvmHRF7rhIk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212--UdaCcn3OWuBCUI4qya6Ag-1; Thu, 19 Nov 2026 07:02:38 -0500
X-MC-Unique: -UdaCcn3OWuBCUI4qya6Ag-1
X-Mimecast-MFC-AGG-ID: -UdaCcn3OWuBCUI4qya6Ag_1795089757
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-49034831bb3so1459463f8f.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:02:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089757; x=1795694557;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AJpa1vQKPwsA3exeR0zFQL8OS++YNOFFgxas0w1fwx0=;
        b=dYKUQb7Ne/530tb0hijCWM/2eK1RRYnhpktHLVkm4Gtk0lOuOM24UHyXp/8XGKnYm0
         QHfMoIsJ0GAhvPiEpzmuWgt4OQpQJ2JcQM2qcaApCGnIScRZmw9r6OynfcZkwIidNtxU
         uUYaO5EYVzLhsjI2jgxI9MKdtIbzhHhNeYnPSRTKqyfJkARW9j+hd+KKLJzplziiNza4
         7JpZw4gV9or7D5xrRoTtYI/DSSDflSLXkx1XOJcXkwuUCp63gmhQ02jLQcFlgsAVw/3+
         VcDe89cfvTQnzrwjGfBcmylIVJ7Z5nPt4EYzktR6H7ZyDj2sMJuAfRp5Fji49y8wOwhk
         ZQWA==
X-Forwarded-Encrypted: i=1; AL+hErEzepFeLLx4h4TpAZ4uTHAkw2vdHBqldaqmjnTFc/+n54vN1VC3HbRZxY9epa86VqgkWF+Ew0IOAw==@kvack.org
X-Gm-Message-State: APuU4Z86K7V3AwI/H9VJOFePUSBOzlgahVAbv5pTCzFF96Rgp/9GXTw/
	0b7Yv70fHffUuQOHEHBzp+UNEdYMCq1UPpEz4Xbx9SwdldXdmyEvouKFPRtmCJQMt90AZbIlC5C
	mOzQC/8wQ1FLXsPNsBIxUxwMlfJW5ILPOJhwnWdkHrF0dK0Op5hJx
X-Gm-Gg: AZFdTZdHc0XuOX47lWvedQvVgNkFR+zsCyEDXAUgBJPAsuq+TWBVo8vxAJp8mcIsKyo
	pXh4cDmuKrMrezkY8bsQJtnw6oMTWQKM5XBZ1DCMipKRznVKHsUnc0sUJDctcYKDVKrMiqf3RwV
	CpUOXsK5iTVhTF60O0iT1/PZ1Y/CZ/zvi/PSBVpOz6yQbXTIUSGmmBrJDa83YPT+EfS9nUagKAK
	imqm+Ru4ZPucubxuVLtqcLMj5RmFUfgQrSi2NDMvYvcQYXrBrb2CgTd8mYWslb0T/yHdZoRuBQq
	lZFooY9FY8dgYrbxu/+HtqZcreUNIna2W041/yjHnRx+h8pGo2qzLryH3hxKXgldS2fn2rli4Dm
	6wekLKKeRoSn1DpnoqGc7uP8yVfgtjcC8H2Lqz1ehR+Y=
X-Received: by 2002:a05:6000:2602:b0:48d:f470:6b3e with SMTP id ffacd0b85a97d-4a63ae56784mr10952379f8f.13.1795089756708;
        Thu, 19 Nov 2026 04:02:36 -0800 (PST)
X-Received: by 2002:a05:6000:2602:b0:48d:f470:6b3e with SMTP id ffacd0b85a97d-4a63ae56784mr10952307f8f.13.1795089755989;
        Thu, 19 Nov 2026 04:02:35 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a650d2f682sm9896560f8f.6.2026.11.19.04.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:02:35 -0800 (PST)
Date: Thu, 19 Nov 2026 07:02:32 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, virtualization@lists.linux.dev,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: [PATCH v11 1/7] mm: add PG_zeroed page flag and buddy merge tracking
Message-ID: <a98c8a49744d30a5e603228d9cb17509261add90.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1795089715.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5zc_yigUmrD_WXOzDIcJXI_1TfwLbr7ykQB9XcFB8MU_1795089757
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ubwytro561z7spbnrsefpiaifptdp4m9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ABFE8180013
X-HE-Tag: 1795089762-493624
X-HE-Meta: U2FsdGVkX1+c8KoSn/YuqL3Y9KBBOOasDFeF/9mQUsEUnmXLqXofr13VFAL0h3WJmBjYLKIeyxtr0Mu/0Rtuffe+aVPyGzUk218iUYVTRcb4KlpsBx935uKY/RfpNaN/LOeb5nuVy2O6XlpfpAAOmSH4VC3syOQWcBdoSDpus9AsnK6Q86x8/VSWQphQdVunJL/0EPvLDkGnyyDWcaRpca+J+FwWT4Ff+LXXBIq5pyVZhwow/IuXzvZR177h26fYqynnKADutzXnMgLQV7PTMnmnK7HtcCYYoamKbWUh1qGgSAj21WJTo8InGRIqMlbJuXqlFrG+74G66BIPP6hxKhyAZTF/dwWof8LH5imj6ux8EdySkuCzeFDNReEQilMKHKGh2OkizM42ZKhzS7TuwP9h2pxOmbewKniBf9TC2M0+zpvmibsrkpl27c29Ve/JytQjQomLXKLsTRUAQSdfb0G0AqMdRCUVQUrGB/TvRLTRITZq/AwuRvFoNxFsGu+l+PVDAjtKKKjybq8QFI2KMt4qMDGFVTDYVuDPME8uTgLFCmQeR5l8+4aYM2858R6Gfz7uLubt74CoK994q/n5e3D/W4T+T5PAsox1GBJ/7AvUX+RXpimZuBOC0kdVGCn1MpDKkSA6zXT8oJG8+IgUUWqoh5FSocpHwZ8xtRkloQfFTuZnguOuvtTUWPcGH0e8wXD+NJhkzj0VHA1ma/GFF/dWxZpsn5nKq8Zriu6afbublv6+7LXDsutOXgjZMGxEKyXpuR2ZTNM8pBHsfG2QNT98YOkEDPPwGiWpcyH9bWOzMf0yRD9xxGTdx9lqGsO58XS5CAEzzQSiq3MPMApwLzJZQliSPkqvPahAuzHfaQ7sW+yTkhOl5tcCbhXrflr20vWq5w3Xls4Nd91htssJwlx4QxUlVzmnFhKPQWl3e8FqENurLHLXrih26oHK+vhbtkL5xBi0SblWJkqhuIM
 /w3G7SNZ
 Q3qdA0uppc82Wss9tR+MplFq8e6WdS4/jmi5ysruU77Mm8WN5ZnmWSe+6Lv5dFySfEDb+zOVoY4zSOxKX7JP33aDxIq3bfxYxW3QWwZWsjR7+RGMG3pl3ZzlYkHNhJTVIzC0xWV/v/NkNoyFJfb26G0TgeJD3JscOolDEmSb5BCHjt8tETCdYbxTAI/V41xSlFym6xizPHNw8fiEVkY98xCVV6dGsUb8acPwCVyVJrH94kqheDsXkHTvyfF8hoxNzyfyyfVuYH33B8j7mtYrQYhWEuFK+TjjySuXU7nR3Y89ZPEY6VGcrQowxXTrIHBhiTDCRKTGcN0EVO/H1ho4+caqZ/F13bdJJ/SNOh9eNwyz6wkzOdcSO9N7ebGT5d0oD2DDv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add PG_zeroed (aliased to PG_private_2) to track pages whose contents
are known to be zero.  Propagate it through buddy merges and splits.
Upon folio allocation, PG_zeroed is cleared and its value is transferred
to BIT(2) in lru.next.

This bit, in turn, is tested by the new folio_init_user(). If clear, the
helper zero-initializes the folio. If set, it skips clearing the
contents.

Clear the aliased flag on free so filesystem state cannot be mistaken
for zeroed contents.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
---
 include/linux/highmem.h    | 21 +++++++++++++++++++++
 include/linux/mm.h         | 32 +++++++++++++++++++++++++++-----
 include/linux/page-flags.h | 15 ++++++++++++++-
 mm/page_alloc.c            | 38 ++++++++++++++++++++++++++++++++------
 4 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index d7aac9de1c8a4..70bbe93b8d669 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -303,6 +303,27 @@ static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
 #endif
 }
 
+/**
+ * folio_init_user - Initialize a freshly allocated folio for userspace.
+ * @folio: The folio freshly allocated from the buddy allocator.
+ * @addr_hint: The address accessed by the user or the base address.
+ *
+ * The caller must not have written to the folio or repurposed folio->lru
+ * since allocation: the pre-zeroed marker is only valid until then.
+ * Preserve known-zero contents, but initialize KMSAN metadata that the
+ * allocator may have poisoned. Otherwise, clear the folio if required.
+ */
+static inline void folio_init_user(struct folio *folio, unsigned long addr_hint)
+{
+	if (folio_is_zeroed(folio)) {
+		kmsan_unpoison_memory(folio_address(folio), folio_size(folio));
+		return;
+	}
+
+	if (user_alloc_needs_zeroing())
+		folio_zero_user(folio, addr_hint);
+}
+
 #ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6af3b7008f1ad..7c9ada8273815 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3325,6 +3325,26 @@ static inline void clear_page_pfmemalloc(struct page *page)
 	page->lru.next = NULL;
 }
 
+static inline bool page_is_zeroed(const struct page *page)
+{
+	return (uintptr_t)page->lru.next & BIT(2);
+}
+
+static inline bool folio_is_zeroed(const struct folio *folio)
+{
+	return (uintptr_t)folio->lru.next & BIT(2);
+}
+
+static inline void set_page_zeroed(struct page *page)
+{
+	page->lru.next = (void *)((uintptr_t)page->lru.next | BIT(2));
+}
+
+static inline void clear_page_zeroed(struct page *page)
+{
+	page->lru.next = (void *)((uintptr_t)page->lru.next & ~BIT(2));
+}
+
 /*
  * Can be called by the pagefault handler when it gets a VM_FAULT_OOM.
  */
@@ -5544,8 +5564,9 @@ enum mf_action_page_type {
 	MF_MSG_UNKNOWN,
 };
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 void folio_zero_user(struct folio *folio, unsigned long addr_hint);
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 int copy_user_large_folio(struct folio *dst, struct folio *src,
 			  unsigned long addr_hint,
 			  struct vm_area_struct *vma);
@@ -5693,11 +5714,12 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
 
 /* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
  * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
- * the head page of compound page and bit 1 for pfmemalloc page, as well as the
- * bits used for the DMA index. page_is_pfmemalloc() is checked in
- * __page_pool_put_page() to avoid recycling the pfmemalloc page.
+ * the head page of compound page, bit 1 for pfmemalloc page, and bit 2 for
+ * zeroed page, as well as the bits used for the DMA index.
+ * page_is_pfmemalloc() is checked in __page_pool_put_page() to avoid
+ * recycling the pfmemalloc page.
  */
-#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
+#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x7UL)
 
 #ifdef CONFIG_PAGE_POOL
 static inline bool page_pool_page_is_pp(const struct page *page)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b0ddc652e76cc..39cd5911a2188 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -153,6 +153,9 @@ enum pageflags {
 	 */
 	PG_fscache = PG_private_2,	/* page backed by cache */
 
+	/* Page contents are known to be zero (host-zeroed or balloon) */
+	PG_zeroed = PG_private_2,
+
 	/* XEN */
 	/* Pinned in Xen as a read-only pagetable page. */
 	PG_pinned = PG_owner_priv_1,
@@ -686,6 +689,16 @@ FOLIO_FLAG_FALSE(idle)
  */
 __PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
 
+/*
+ * PageZeroed() tracks pages whose contents are known to be zero.
+ * Set on free-list pages by the balloon driver or page reporting.
+ * The allocator uses this to skip redundant zeroing.
+ */
+__PAGEFLAG(Zeroed, zeroed, PF_HEAD)
+SETPAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+CLEARPAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+#define __PG_ZEROED (1UL << PG_zeroed)
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 PAGEFLAG(VmemmapSelfHosted, vmemmap_self_hosted, PF_ANY)
 #else
@@ -1189,7 +1202,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  * alloc-free cycle to prevent from reusing the page.
  */
 #define PAGE_FLAGS_CHECK_AT_PREP	\
-	((PAGEFLAGS_MASK & ~__PG_HWPOISON) | LRU_GEN_MASK | LRU_REFS_MASK)
+	((PAGEFLAGS_MASK & ~(__PG_HWPOISON | __PG_ZEROED)) | LRU_GEN_MASK | LRU_REFS_MASK)
 
 /*
  * Flags stored in the second page of a compound page.  They may overlap
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6624293e4d787..927a288eb419b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -986,10 +986,21 @@ static inline void __free_one_page(struct page *page,
 			change_pageblock_range(buddy, order, migratetype);
 		}
 
-		combined_pfn = buddy_pfn & pfn;
-		page = page + (combined_pfn - pfn);
-		pfn = combined_pfn;
-		order++;
+		{
+			bool page_zeroed = PageZeroed(page);
+			bool buddy_zeroed = PageZeroed(buddy);
+
+			__ClearPageZeroed(page);
+			__ClearPageZeroed(buddy);
+
+			combined_pfn = buddy_pfn & pfn;
+			page = page + (combined_pfn - pfn);
+			pfn = combined_pfn;
+			order++;
+
+			if (page_zeroed && buddy_zeroed)
+				__SetPageZeroed(page);
+		}
 	}
 
 done_merging:
@@ -1378,7 +1389,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 					continue;
 				}
 			}
-			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			tail_page->flags.f &= ~(PAGE_FLAGS_CHECK_AT_PREP | __PG_ZEROED);
 		}
 	}
 	if (folio_test_anon(folio)) {
@@ -1397,7 +1408,8 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 	}
 
 	page_cpupid_reset_last(page);
-	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	/* Clear the aliased PG_private_2 bit when freeing allocated pages. */
+	page->flags.f &= ~(PAGE_FLAGS_CHECK_AT_PREP | __PG_ZEROED);
 	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
@@ -1507,6 +1519,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 			      unsigned long pfn, int order, fpi_t fpi)
 {
 	unsigned long end = pfn + (1 << order);
+	bool zeroed = PageZeroed(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1518,6 +1531,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
+		if (zeroed)
+			__SetPageZeroed(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
@@ -1705,6 +1720,7 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
+	bool zeroed = PageZeroed(page);
 
 	while (high > low) {
 		high--;
@@ -1722,6 +1738,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
+		if (zeroed)
+			__SetPageZeroed(&page[size]);
 		nr_added += size;
 	}
 
@@ -1880,6 +1898,13 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 		set_page_pfmemalloc(page);
 	else
 		clear_page_pfmemalloc(page);
+
+	if (PageZeroed(page)) {
+		__ClearPageZeroed(page);
+		set_page_zeroed(page);
+	} else {
+		clear_page_zeroed(page);
+	}
 }
 
 /*
@@ -3144,6 +3169,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	}
 
 	del_page_from_free_list(page, zone, order, mt);
+	__ClearPageZeroed(page);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
-- 
MST


