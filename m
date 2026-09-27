Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB17DC9832A
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0CC6B009E; Sat, 26 Sep 2026 22:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C89B6B009F; Sat, 26 Sep 2026 22:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F214D6B00A0; Sat, 26 Sep 2026 22:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4AA46B009E
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36DE0A70C9
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:28 +0000 (UTC)
X-FDA: 85258026336.25.88B5454
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf08.hostedemail.com (Postfix) with ESMTP id 76B93160005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UPGPLLKn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDg0B4GTZoaBgeAm1Zuaxbe7/C+fLySFm30qNgbQ5Ns=;
	b=pyDZr5kh2D0g03mUYbTtK/wkXUm4sLCQbFa/krOcYQacVuflRxvwVcRUcNfvf/g3ZCmFXs
	JGbbB+tQMy9cNkfBU4B1CgWS11f5MOIm7eTn9e5G/5DbowgECmBaoYj/TqNLOTcilck9ja
	SKvzrGOi/ZXlkTthk61Cwk82knlRXP4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UPGPLLKn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477726;
	b=KkzgYe68DP8ofbrT09drPiSbkDTYBY+TT2PthYxpaO4NB7Es9oqLUvEPBht6jSDxn8wbqf
	qdZj7MdIYy/tDQ0GBpH6xFfFXEkrNbeleweX5GZKID9R5YSvdOFq/BWn3q6iEpfhEDgZSW
	/wvU0n8wk3oyk6ddZADNePzeY7nLsKw=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccc09d65so1253431a91.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477725; x=1791082525; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eDg0B4GTZoaBgeAm1Zuaxbe7/C+fLySFm30qNgbQ5Ns=;
        b=UPGPLLKnGOM0rhAg8EtGdPUXZF5t/0T3WKj/1vxwQbAt8Qrtgy9RVvLBecrZOzj3Tv
         y+TIDbFFYkxuaSZ9+1pUNYuuIM0fORZifQxL1jJdSFV9akWuwoCl80v9klsr7pGofWdN
         HwfMqTGeMRy6lWqV/uk77s/QKj3JWmAXzwg+wuB+5I5Ot2taMfVyWk63rLakIhe0855f
         UowyaeMTZ0o0Tj1eCQox6A8qKhqBy9vnAOlhusyeCoIShY5l1oXWlmCM3TqiXPt4bJuj
         uqL+dg89xM/ftnNg0naSCqyd8+PySEjJwbhfbfVnPH29nllzQa7CQydTwlZL+MvMR/Hj
         uMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477725; x=1791082525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eDg0B4GTZoaBgeAm1Zuaxbe7/C+fLySFm30qNgbQ5Ns=;
        b=zDNAp+kRMiFYmXz7n5Y3aquHXKe7RsKhvcVCZahpAJ1z1qV/DOugpFGrVy+kRwe4Oz
         SdgJwxOyaiO2enSmPeH1diUh8Y7hezkiMxtfNYCbYnB9yI+tGTkmU8DZqp3nAhp4vcc+
         Xon57ZEPwUtUtPMQUrhMoIFHWWLIiF8lvwCTC2IJzP2+/CVhEjgKIB6G0iaMUR3XYZ5M
         5K6NVnD690Z8e0nt7j4oRVXh3g+/yNDtH7CfiNgjmxllXXqZrGex9RtuoxHtZLivQHOa
         5OLU8969Ssizog7w6zuzzXsTdFaAcAwF82VVglJnGBdmQQy/nNUbeESoGJZj+1PF6a3L
         pS6g==
X-Gm-Message-State: AFq9FYIoWzBaQigsfnMYZokldp1X0BeR5EhJa20Rc/CNlx+v81tBKLsw
	fHO2pBGQcGR7eTtHcCZY5OFdGeGAutwZKbLB6BhvNMHxqUs/tl7pDi999yEUWW3jyHQ=
X-Gm-Gg: AYBFou281/ApRcnnHxL6A3KeVItNhiheI9JF/W+vy3chSwr5Mu+wupCCPS1JnN46YrZ
	XvN9xjscZWgU36pL7RH0ATENbJK+Kgvh3Dr5bolhq1TCBJXNGPyzbSGLqS3qaHsi98nnwDFJTHC
	dD9vG3LvqFgTCzr42xTJ29DDK7c9zKZlYnsjYywFJPuLj5P82D5xZCVdVkFBzT2ftaM2cC+xJ+V
	WBKk6UtoIPeJeW9AOVNy06IvuiedYgUaLsAUr8wPc3U6E9TsI5H3cijYUJZlyusDJ8JTE4VskT7
	EazXUR8C6ha/4A3Igg84qHh6JWEQm2xlCJi4SUjigNR5pXvoZ5tvwrxLAp85XBnGn98MTk11I4U
	6DK7UH7kTdipM6gpYfIPxu9wMdsYStUE11Kpzfsje0AiedKQwYqHH57IGkG3lkSI7bmIX0Yhmg7
	Eb+RZjUXUQ2APSzP63EqoTJDdcJqWtD/cXWelzZ2+i3/G975h2euuInlBxGda9eKqTcooSG8k2A
	LPlJPyQNnXv4nqaiRmc
X-Received: by 2002:a17:90b:4a45:b0:39e:6c68:c77c with SMTP id 98e67ed59e1d1-3a098e07a64mr8528965a91.50.1790477725206;
        Sat, 26 Sep 2026 19:55:25 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:24 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 07/12] mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Sun, 27 Sep 2026 10:54:36 +0800
Message-ID: <20260927025441.741633-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5h9g9fp545815m13gg5j8n145o5chaou
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76B93160005
X-HE-Tag: 1790477726-120489
X-HE-Meta: U2FsdGVkX1+o9wkmgf+2+MrjbqqNLCx2GskETyeHIzL1qO+UTGiIWk+vgben5J0Chtwx2JnPFUsuWBCl1Fq2Y+Zt9fQK/9iDgUL3NJuXgOscz9Ne3hb4hw7mj5SaPuXsdzbH5nw0qdD9aVaUlcLvlMgAlP7GPjMag1n0mdp4Qcy/iuk3og4nd+3Y7FqQU63Js5GhpBku0WOJXyQ3MJ1oNde5xxg2bsf5ZKanyfmV9ShmA4ebTyCT30IF4yY4KYGwNBgsn1U2Ut1F6gFIktNT79s/71uI3/ELqORRS/0MlbvsPxSA9YgciMdJdh3UPuR6JKhWw6r4p15uw65s4fqzAnnse+TeKOsQ2ZwjzgMRDxEoHVI/Wl9LFwDO2V2Cbp7oYusfXoXYsFtwM4MmU6k/jegaYzZk+/IUP3nLlzNjy+VKC9nuNxdBMGJzpvXResWKokRFJM+0MYk9K6eMYfsT4dk2wX38mVqBt8Razw2ijJw/TWxgpq3dEb8Z/IRoSHyf6vdwTeyYl47JLYSI8tjkzLNgaTWq/+mWHx7hGVQt84onOZ6v7+Zn0m3w7tSrvbhr1LNpO0vvtYy9z6Gbz+yHfLGboD/mCk6yYJdAtPhbcWn3JoSH1XYN4f8R0/OlOln1NcuEk1/DkvdXNl4KK3457RrL01ogQobSiQ4/0c1JPeLjz7qWS0G+9lYLeOrETKHw0BvwsIol0s+WcUk+Xcc3D+AhuYm+NtM+qi/LTRJifw7ulneq2X6oq10AsG9XKTzz2I4rx+6IFIK9e3/cKTLJKPJiGE47/85rD6w0QUbh7Ut3+JaLcCS8jVAk2iloCTMl4YDNa6b4CsPlsPV8iPLGds3D4pAumaSmgk2IP+67ajcNtz9gc9rr7MDNHv4KPHvTvyE/yItV1uWat5SiP8LZhYKiieObjhL7nhtNNIbcVyxs57APl4aBXmUSbHwhvrbCipM5MLezZZPDsFXNkiU
 uP2RC1db
 1cSAnQ9gsnE+KADe0iMPoutLJPOyLk9AAhmY6yu+KjhUcgOj6wNWXc7rsm9yXn8eElF05rUw8PlFECE1hZUiKphdQiLrh/dkLJTEdbYruPM8wLNIeyPHMNmFdaNTijzfZ93Yig1g31egvMK8sIsaqkyp6vwsQ5arg5zSCz9iFL9Rpc21fl8X7NcgZ/xd77g3dtLz6VZbzilsV995/iCroKXFj3S0Bn+DMLntUXQagSBLgCdXF1jl524cuCIDpe0DWF+4mORGyOi0X9sPbHPFQ+nvQHhFvq32OoZXu+KL1Vmm+W5lB3GXm3kBDvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap pages.
Device DAX has not been switched to that mechanism yet.

Switch device DAX to vmemmap_shared_tail_page() as well. This aligns DAX
with HugeTLB by using the common per-zone shared tail vmemmap page.

The optimization is enabled only for DEV-DAX through pgmap->vmemmap_shift,
which supplies the compound page order recorded in section metadata before
vmemmap population. Unlike FS-DAX, DEV-DAX does not modify tail struct
pages, so sharing them is safe.

Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
initialize its entries with PG_reserved for device zones. Also skip
poisoning vmemmap-optimizable sections while their struct pages may be
shared.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Move device_zone() after the definition of NODE_DATA() to fix
  non-NUMA builds.
- Update the commit message to describe the compound page order stored
  in section metadata
- Collect Acked-by from Qi Zheng

v2:
- Explain why sharing tail vmemmap pages is safe for DEV-DAX
  (suggested by Qi Zheng)
---
 include/linux/mmzone.h | 10 +++++++++
 mm/memory_hotplug.c    |  6 ++++--
 mm/sparse-vmemmap.c    | 47 ++++++++++++++----------------------------
 3 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ee9cbaaa63f4..cd68c1904c91 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2143,11 +2143,21 @@ static inline int online_device_section(const struct mem_section *section)
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
+}
 #else
 static inline int online_device_section(const struct mem_section *section)
 {
 	return 0;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return NULL;
+}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b428da66d279..d7a59167bec4 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -43,6 +43,7 @@
 #include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
+#include "sparse.h"
 
 enum {
 	MEMMAP_ON_MEMORY_DISABLE = 0,
@@ -554,8 +555,9 @@ void remove_pfn_range_from_zone(struct zone *zone,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages =
 			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
-		page_init_poison(pfn_to_page(pfn),
-				 sizeof(struct page) * cur_nr_pages);
+		if (!section_vmemmap_optimizable(__pfn_to_section(pfn)))
+			page_init_poison(pfn_to_page(pfn),
+					 sizeof(struct page) * cur_nr_pages);
 	}
 
 	/*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ca2470e96a74..2bc78aa053a1 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -221,6 +221,8 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 		set_page_node(page, zone_to_nid(zone));
 		set_page_zone(page, zone_idx(zone));
 		prep_compound_tail(page, NULL, order);
+		if (zone_is_zone_device(zone))
+			__SetPageReserved(page);
 	}
 
 	page = virt_to_page(addr);
@@ -525,23 +527,6 @@ static bool __meminit reuse_compound_section(unsigned long start_pfn,
 	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
 }
 
-static pte_t * __meminit compound_section_tail_page(unsigned long addr)
-{
-	pte_t *pte;
-
-	addr -= PAGE_SIZE;
-
-	/*
-	 * Assuming sections are populated sequentially, the previous section's
-	 * page data can be reused.
-	 */
-	pte = pte_offset_kernel(pmd_off_k(addr), addr);
-	if (!pte)
-		return NULL;
-
-	return pte;
-}
-
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long start,
 						     unsigned long end, int node,
@@ -551,21 +536,18 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pte_t *pte;
 	int rc;
 	unsigned long flags = VMEMMAP_POPULATE_DAX;
+	struct page *page;
+	unsigned int order = pfn_to_section_compound_order(start_pfn);
 
-	if (reuse_compound_section(start_pfn, pgmap)) {
-		pte = compound_section_tail_page(start);
-		if (!pte)
-			return -ENOMEM;
+	page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!page)
+		return -ENOMEM;
 
-		/*
-		 * Reuse the page that was populated in the prior iteration
-		 * with just tail struct pages.
-		 */
+	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)), flags);
-	}
+					      page_to_pfn(page), flags);
 
-	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	size = min(end - start, (1UL << order) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
 
@@ -581,12 +563,12 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			return -ENOMEM;
 
 		/*
-		 * Reuse the previous page for the rest of tail pages
+		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)), flags);
+					    page_to_pfn(page), flags);
 		if (rc)
 			return -ENOMEM;
 	}
@@ -918,13 +900,14 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
+	ms = __nr_to_section(section_nr);
 	/*
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!section_vmemmap_optimizable(ms))
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
-- 
2.54.0


