Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBFD606D803
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=bTOiuxG6
Received: by kanga.kvack.org (Postfix)
	id 1F3FC6B05CA; Mon,  9 Nov 2026 04:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FF26B05CB; Mon,  9 Nov 2026 04:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096426B05CC; Mon,  9 Nov 2026 04:58:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFA706B05CA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6543516060B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:30 +0000 (UTC)
X-FDA: 85415130780.08.43E951F
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id ECCD61C0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bTOiuxG6;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByyGzij7OlfhxHWNMnja3/uYDDbPONWszNtjJ9JVHuk=;
	b=BtvDV+N7SBbpTmlvseFYxD9NJiD5pikJrPsCnl5p2yQsILH+C3/iIXcZAWDDXb2Tj+CH5K
	btnLLFQDtEy4U94/FymrRuFltFRJK5ztX9RwBwsiE7mXtzeSrK9WdVivq49Y0LG/ENYFNM
	mCUpxHY/JaQR6lYrZm6lbg8DkVO8w+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218308;
	b=EU1pxyTCQ3S7aIlBQakdtoFxY13F52gb/gYCjZ54EUprJRGnh/tmbdqhAfs9PJvnsC4KbJ
	6cWfKzLaBnSXTa4tErRGsBIDB942KCl1+ELPoH8L7MtXW83bZWOokPb9A0Upw3CMc0QwOJ
	wbBFreL8dDPsCNPc6vSmNNsx/30DN3E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bTOiuxG6;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-14394530ec6so786938c88.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218306; x=1794823106; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ByyGzij7OlfhxHWNMnja3/uYDDbPONWszNtjJ9JVHuk=;
        b=bTOiuxG6lbnqVaUmBi1nT9vI4ttClCudjHV5q4aGuz6WNqmkpw0MkRDTA8on7YuPpU
         RQe5ueSvBylvzbx/g/4/piLqQ9moMrJcT6TBl3WMT/DzzcIZyzq5MYF+NZzD0sHJ+wuu
         +hwXnpAjbpd3/zKnv89u07uIpmWlhYfzYkFrWhCAiZlO44l5SVLKUIVQh3BXTpG/tErF
         aGalkCO3LccootCaa+31K/n0Wl8Mda1yeWpcpvaMOuR6srU0RAFIoG6QgeSSwlfqfWp9
         Gihv0jy1FHG3V6QLtkahRM+rKvHZt66dkRB+PaeqMOhkBtiQmHiwVUEiWQqN01dGVPl+
         P4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218306; x=1794823106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ByyGzij7OlfhxHWNMnja3/uYDDbPONWszNtjJ9JVHuk=;
        b=jldEBz3JFp82B49VNouKR9S3cnZDNyEZM5NFWC6c+V+IUCqiCU5U051wxE2xJjBD4e
         PUZRFzFeph/XxixC5gfc/XHswP/TY/VQ/QzoJnHEK28z3LGyN8Dd1MvHc2Lo85t6OjFD
         3CwHDVXEsnVIRupRXUmXXkHqydTiuI9dPejKKfnbnM8Spfp+CXASxZ/ptgVvK56vu+0H
         EAjd1UJPDEa43oFYAfJ2mF2xgD4dXWYe6r0re22aywVpWUemDgr2fMnVhws/JVZbcDa+
         Wa8y9wesqF2ZnRSPqN5Li+ZaW4o8jgsBI06GzNUX9qy6x9VVzHqj8LtEzlF92N3ysoX5
         5Uxg==
X-Forwarded-Encrypted: i=1; AL+hErFEpFjRbkaemsGT27X4BjApBP4BFkbP9ob6ErL87w9huAIqo8UqYRT/WiwLxDI8tBXTCsH08wInuQ==@kvack.org
X-Gm-Message-State: APuU4Z+OnwKMKlXpjQNW1X8mkMGiPcRE0EG4jn9qVNhKlC1qTLftoqP4
	MuWXwbgeGOmVm/iH47+NYh8OAFOTLl6PHPkeh3EGJhem8CuRyO4av3R8VnRw7O3zT9k=
X-Gm-Gg: AYBFou1hEujyfV7TMPDVjenBizBVmIO1MzkAgfXA4LPHUJOUAL6UL/0iBd5aTSH85ie
	PxX2pfJjFJWdrkfjdn7ojK9CffgFmnOpqhejNVHEaj5ykDthSuc4U04ibmzWoVr+NltNjVfyVDR
	OGZGOkGVRs2C+EA3+vvfPhxkjTDXPIFbXDv0gyYYwJKQqU3D12WOOgSqwCtfWp9+HhcUx7yYs7I
	VOdQi9PoVtMu96oYLpBVNSKXsWfr2oDdbMifylyxMtvKbrcvGfq9jBzBlt7rAcsJmNDfF7K5eBu
	v5INO7oGOQC0ruY3sJU4Zi4pwDa7h3NuLXjm4GjGiuEWGHJ8MkYZthP/fdCZ766kxqd/VBHZBys
	Bk4t+PbC0BaxLT+jaXz4znxG7+1d6F91J0+Dd4Mp5AIfWxGETFo9jHePum6Fc2+J2cEgjDn6YU2
	gQphkbu057tJQ302sj5+X2irD2LHLsXXWRbiauqJipUVz8tVsLAfdFCUXX5MOQMdf6Ft9aJJNEH
	d1KhyYUdXWQ8vFN0LjbcutOgRyL56G5gjeG/xsqRzcZ+nZK4Ejrux7CPKFe5FN2UA4VCLSX4ai2
	HQdCJOFOpL5BgQzXpvXdl+35UWmB4jy5FOF2Z/l3XGVPHccqsQ9bQGcedU/xzMg=
X-Received: by 2002:a05:7023:a4c:b0:1b3:af3a:e793 with SMTP id a92af1059eb24-1b3af3aea3cmr969015c88.0.1794218305527;
        Mon, 09 Nov 2026 01:58:25 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:24 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 02/11] mm/mm_init: factor out common struct page initialization
Date: Mon,  9 Nov 2026 17:57:57 +0800
Message-ID: <20261109095807.41547-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: sdc5euhxw7sz8j6kmjp1okhrxb1a3agw
X-Rspamd-Queue-Id: ECCD61C0006
X-Rspam-User: 
X-HE-Tag: 1794218306-603344
X-HE-Meta: U2FsdGVkX1+TzsZLLSgq14W4vUpKH1Pjs5Sf1/3n7jk+ikwjJ8BzBQPSHK5i3dC1itWMKBJvnxn1PWTVGPm00x9kSmAS71p9gixFx5HSmckuWKBahj7+ZHNto9qIookW03gGgqRUT82tJJ7qNLjXIpaHrCAfro/7SNTx1dkDW+VaXfLRijgZBi0AuzaK3/5YyaW+CbALDgquelS+IDD3LijO1cQenOCDQ2Z6sBKfzxduFPZnXhQcf5xPu5FAL+4j3zRPzFycSccnZCVbU/dbyPdgagASN5ZcA0GJE1PcleXozv8PAkaDmRMKCZe0HV8r7Qqcgvkg06yjWEp8q3n9hlhzFzLd1juGaCF9XQstEz42Ru7So5trFs+8FFbzwmMOYdH5b6+p7phMGTImm4fKZ/EbQQEGxvuXZqjfsl1feDmDu5Cdv5HwETpjdYF+EIfmGTPq+n/vwsPH5UBAhTE07PdahtFm8DoAqoai6N2sM1GojIqTWvsijRrKaWR84WW2e/2vWpy4+NdUPnwBbdoWNql3eW+wkTxYyCXRcMLHE5Pr39lfj3lzHLn8b4m8BQaCyJENbH78XhAjYsqTot/RHaXY4pr9H08o0GIY6Q9YjgB1iZRL8aYfSiuP+wbvxrlf1fvEDbdXKfA+wJGJp74H5uczxW0QWtbz7P5Dz3Bf+nddMq6LlntMvhSQGkrH1rmfQGrXzEb7D+xrbFUCnUN4aKSiSvRZ3zEhs4SchRo1l9WhatzDIwZo5j4Q39HHtUm0m/j+bUrbumt8OpZsiKXfCkWwN5iiE4Wcb0bYCIE2zAJNV96XMiVaFxx7W98PxBiZfWIkYIVPVZ9zDbtKRrvA0zbzrpjEyHz41xaXBSV5QJyRct8N75ZD79V3HYaoph56jC9lkkxkIfV5d/yFBBNmCVv9fOu4bZTdWJro+0VoSm2/AdSkgipOGIHkYegwzf5wfur3McpzSA+6Fa7IDSR
 Xft0ctBy
 nwoLu46dKbcq0rRlMM2/deTD7I7aR5D3KTXiFhH4+P4GHYsFbhEvdWI2gdfJ8MWALmIv3PC11BWY7MwXSS74YwEoGetgYQkbX/yH0jNByc2lMpFDc2+sFewcf04IEj8Cnv2yPcfX1fL8KZLQ1FoWavTLbRQoSWJFbKhFmJBkON9KuZb6GovvYnBfGDP+83NTMKSQZMR6e/+I7898BencxbsMDOYGR9QRIT1O8SiVE0qnOr5bC5nxcj4I5MUWp5dKta8o2R7lxPNsCSTHgQj8uhB6055qz5Yte2NYmXiYdnx5Mf1LM3aUjNuFDcZs6tTG3J4gifoC6FbwbTR8TrXJWEv9ZqrFBwwv2dzeSQeoviUIjapc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several struct page fields have the same initial values for every page in
a zone. __init_single_page() initializes this state as part of its
per-page setup, while the shared vmemmap tail path open-codes only a
subset.

Factor the PFN-independent state into memmap_init_page_common() and use
it for both regular and shared tail struct pages. Keep section-, PFN-
and instance-specific initialization in __init_single_page().

This also initializes the last cpupid and KASAN tag for shared tail
struct pages consistently with regular struct pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h  |  8 --------
 mm/mm_init.c        | 23 ++++++++++++++++++-----
 mm/mm_init.h        |  2 ++
 mm/sparse-vmemmap.c |  7 +------
 4 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77b5d450fe45..2e182498898e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3022,14 +3022,6 @@ static inline void set_page_node(struct page *page, unsigned long node)
 	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
 }
 
-static inline void set_page_links(struct page *page, enum zone_type zone,
-	unsigned long node, unsigned long pfn)
-{
-	set_page_zone(page, zone);
-	set_page_node(page, node);
-	set_page_section_from_pfn(page, pfn);
-}
-
 /**
  * folio_nr_pages - The number of pages in the folio.
  * @folio: The folio.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0129152b74d8..9677698f30d3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -602,15 +602,28 @@ static inline void vmemmap_optimization_verify_zone(struct page *page)
 			page_zone_id(page));
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid)
+/* Initialize PFN-independent fields common to pages in the same zone. */
+void __meminit memmap_init_page_common(struct page *page,
+		enum zone_type zone, int nid)
 {
 	mm_zero_struct_page(page);
-	set_page_links(page, zone, nid, pfn);
-	init_page_count(page);
-	atomic_set(&page->_mapcount, -1);
+	set_page_zone(page, zone);
+	set_page_node(page, nid);
 	page_cpupid_reset_last(page);
 	page_kasan_tag_reset(page);
+	atomic_set(&page->_mapcount, -1);
+#ifdef CONFIG_ZONE_DEVICE
+	if (zone == ZONE_DEVICE)
+		__SetPageReserved(page);
+#endif
+}
+
+void __meminit __init_single_page(struct page *page, unsigned long pfn,
+		unsigned long zone, int nid)
+{
+	memmap_init_page_common(page, zone, nid);
+	set_page_section_from_pfn(page, pfn);
+	init_page_count(page);
 
 	INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 0034e37dbabd..0df0644c703c 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -109,6 +109,8 @@ extern bool mirrored_kernelcore;
 bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
+void __meminit memmap_init_page_common(struct page *page, enum zone_type zone,
+		int nid);
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 9b80dd7326f7..fd869617423a 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -212,12 +212,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
-		mm_zero_struct_page(page);
-		atomic_set(&page->_mapcount, -1);
-		set_page_node(page, zone_to_nid(zone));
-		set_page_zone(page, zone_idx(zone));
-		if (zone_is_zone_device(zone))
-			__SetPageReserved(page);
+		memmap_init_page_common(page, zone_idx(zone), zone_to_nid(zone));
 		prep_compound_tail(page, NULL, order);
 	}
 
-- 
2.54.0


