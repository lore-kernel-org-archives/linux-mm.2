Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F0EACD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7812B6B00D0; Tue,  2 Jun 2026 06:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731926B00D3; Tue,  2 Jun 2026 06:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620876B00D4; Tue,  2 Jun 2026 06:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB316B00D0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C20BC2B2A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:14 +0000 (UTC)
X-FDA: 84834557388.27.A7366BC
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3969918000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gEmvRfC5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/u6lKC7hQ/GhzoNdcnEA7gND1myfeYXkd1NgoaUr0Y=;
	b=r2ru+oNqjXpWsiMckgU2rZwj9mwiaps9imO7Buk7RFeVv7HDcMt9Jin/2Ju1yOaupt2Qty
	3HR582yPul96/gEZswkwBnWXG61R3yPN8vE8YuPRuYszKeTdvccK4JwIIijDyh/Cn516Ol
	BqJx9xCOjYV/jEoWOaCdobkGovZ/GdU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gEmvRfC5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395132;
	b=qwnGYMgiyl5BiqWpSx595clvg/h8BZeuDaO6lZ729Had4nYasUtc3A9R/ET9BOKfSI7m3p
	wFdEIp3hH/EV1xkEO4zM60ZGUmKiW4G+tf7B5zis0hlkDU8wN8672eSHDJw1wjy33PXCZA
	Wcni/wv1VGHMbpqAhp31aL/y6DwuWr8=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84237c55ef9so1009578b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395131; x=1780999931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/u6lKC7hQ/GhzoNdcnEA7gND1myfeYXkd1NgoaUr0Y=;
        b=gEmvRfC5TLcUXJvKtmCJg1hIvJqBUQgaDy70jak01hiIzMZriUmw4XfUxGaRM7aS1o
         4nfvrCw9I1PjvFxUnqlU/kcdSCf2jo6nMftdujhMdOz5F8JoIToTB4heSkg+F67wAnrB
         VXFm35CxSEil6VsaS34TqNrNTB/rngUyGU7wGTLXJdpBE1p3iMUX0ilsCem+kKoWMQUb
         oxKf9ffEWdZrX4rbGRf4M+EL9d+TB5P8GqJ2pljDv8wHDIpclH2QAkHZETt4SLE9EXWZ
         ThyIIZ964YAM/MKrmBvIwIMwGH9+y+hABx8XROBhNd37BoqirHelZGNNSe2wkdzwCCmV
         8w9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395131; x=1780999931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E/u6lKC7hQ/GhzoNdcnEA7gND1myfeYXkd1NgoaUr0Y=;
        b=Olxq0kyL14BrL2yV258sK8+79hl/mOYCUqos/9B7ECJD4DQUxMGEd8B6uJu7vRR0wU
         UzTRcOCiNq7tKLbUes2X0i11uWYEquPGSFza6V6tntRQwg0m8FxAR/5WNy4PmHqe08Au
         YN9K6JItCywkVnEHP4cKRLFpc1NEpERrMTO4IBTnwDbjmECpYiEAGNtgXGtqMVnF6NGx
         uVn79nISXhXSWlyuAWbUyjR8CxyfD8x8UYOGn4roHfKw9vL6gvnkKxViFWGdYooADiBj
         9sjP/A9AoownarCffCvOzGyo5XgZM03iAywijBRcWgRxmFono47A/f46nVOKCSDDDZM8
         N1XA==
X-Forwarded-Encrypted: i=1; AFNElJ9VJQEtCDDqwIwi1R6/dm92MK13I1iTyt28nTY+0x/dRcDzyfIXOTn+WuYgBKb8wpZgc8d0GgPKbQ==@kvack.org
X-Gm-Message-State: AOJu0YwxC43exsfopcTmncRJfP0vbKbPmoLEl47cdIo1trKQp0LDMDww
	6m0jgOX4fKOQlu1e+rnHvG8GHRonsUuURO840p9QEub+wB9Fgzs5WJcaEGRURmzm6go=
X-Gm-Gg: Acq92OFo3SwKcv+cyzLK6EohzAGd5PekVxUCRAu3BH/VPSdZNnEu65VdPfk3fA1KB7K
	frNipvVX/QjhVBrh27XwsI48fKsE+uLYmGawKHbA/WVwjVbszKMfMo/38AogVev7TGLEtYt1ciE
	Kl17RDOU0YEaWLiI1jYOqSnuAJqid3qlJL4INuRycm47MwISPSzB3WInj3mV0XP8pFO4ZZWK7wX
	N4a66JUwCy/izSAHuGm4wrJO5z5Hqgkxc4wtr9lJRW4vOlUueBpOf5msrDGiaEF9Ahhzn5LUc65
	texbixA3LXWAyNf+OGTRwXPD7So2/LFOagMgYYnsFVPTzZI/ctjM9LdptkLveogjCyatop7dIKr
	dJfP0HUizgJON9yQlyC2HqKdOS3jyZGtZE8AnQwFWl+6rDN4BnjhVQe/r1RPvEDvHjtWLdU5Lb4
	aZTOXo3JClkF6yjDbn521zl71AMBrznd2ESnKu/UXoA64dS2d668rX5j0=
X-Received: by 2002:a05:6a00:2da7:b0:842:7a78:8f14 with SMTP id d2e1a72fcca58-8427a789a5cmr998275b3a.6.1780395130964;
        Tue, 02 Jun 2026 03:12:10 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:12:10 -0700 (PDT)
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
Subject: [PATCH v3 14/19] mm/hugetlb: Free cross-zone bootmem gigantic pages after allocation
Date: Tue,  2 Jun 2026 18:10:34 +0800
Message-ID: <20260602101039.1867613-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: a8a5ajbmsahizq8ir4ix6f16hffhryzd
X-Rspamd-Queue-Id: 3969918000A
X-HE-Tag: 1780395132-985814
X-HE-Meta: U2FsdGVkX18Z9J5rXp3Kfse2yNkdCqiUX8rUecT9NQDRz9BypZZkAtFKYbbBX7xsDwQ1Z9/i7i4wbkMs63lNCPbfM7iXWgSIbERsJS8XF/Mu6UCd9VJEA/Jwlpjk/et7Nlq3ofYOMRSO4DCCGwRUVJMVNJZ/s46wGxoHYsE848lVzUc/J84gqQ2r417pIStPn1ULq+76CEVL9h6qNiT5XlKi/JVVBii04e+2UUcgLPlzRpKthf1HEZbxK4WIITsiDCF2IphYTCOweRwDATK7i8LYmuhcNGj1cjW/X0dnik/zILuzv6R8zJJEyBH01Jv8sNoV8ssnFydjscnaAhIgC/PCbU/QUmFFS9QjjmecJ5eTlAWJS719MHDtkRBVuta3WXBhrTj7lASS3h0ECDjvN0xsF+FIQBwrGopkI/WK6cmWosaf2YVYEyCh7ZJUAbXxLRxC5nRsdWiQAlALG2nfFoKFwGz2mhEGsL+/vB08OsysL40zCfy+aMdiHnGErEl9DoxC4VDDlmYgJKkgeEOj4XZ4ECxiZS8ae0XD1+S6EXZOPH7+FwRZYrcqzcejR7pSBC1HH+AS9XrQM/XqCHjLpxP/02CayOYW+Bly0A1ER58yMceKStAL/g4dkBTvILnn6dm06NTRfoQKEIjhWhsDTc6gcwl7ocinVfWVXUKnas0M+RR4mwDUdERzicSEfzMhdCr9Y3E7ab3SaaN67OXS4JKyPJfsfpmfblSZSfFkmE9I8smKrvblKwGM+l1L5T68rE5+btDLV3qo2A/xAY1X4umZdumI3VR80d8WHhXvno5M3fNLH9ue7Jiymy2AuMMjCXYStVGQz7IDThZWyMMnhnsTjscIOs4iNw1+Gr7Czfji5WZXE1k3GAw9DVyDhSitrHXGj5zYMHy8uHZfaJFyrOkEhA0xNCCNfVPqxwyzO4tegPrbRC+t8Li5XOzUF+C+1JAppp54L+bd36GdLrP
 Z4NbQbnX
 /qrgNuN63cixcV1G07aaHP42Npxd9jT8SFqLUgLMFzLfYjlhqBr+QlstAieRBbybKUFv7VsfQSba6rBhNB7+u94Lw/F5v3IDLdsQ6YZ/lyZYbY9HR7/DZSyMed25i19mdn8QzE6uNPHi8wTSD8TUw8xK69FOEU09jVbqmWrRnop5uGE4raZAjcOA1+LAX3dA/PSVK0pLbIasQZA5ZTR6O3tH3R/yqb+LMi2f6BYAbpHNELQGctIEcnk04+1neuI4/T4x10iEk1DxYbsiHGSV8MWjwbmrBNDSZrFE+s8kkOhhNUS4+QVCGvhAxLhrvR8tYcq4IFqapU4PSvMAY8Lk9HGAvrqBKvdu6ToNB2MP72SD3bDFK3F1pSjEEg56vRAShw3AywqUIwFX1GMEwwZ9+eMIQdLFNkJ+UkassRr8BoQYNkANUsY17gitCNH+HI2/uD+MMwOObFb7ZlaBtTiIhiN0Zc0k9ilACemMl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that hugetlb reservation runs after zone initialization, bootmem
gigantic page allocation can detect pages that span multiple zones.

Keep those cross-zone pages separate during allocation and free them
after allocation completes, so later hugetlb initialization only sees
zone-valid gigantic pages.

This chooses to free cross-zone gigantic pages directly instead of
retrying allocation. In practice, such cross-zone cases are expected to
be very rare, so adding retry logic does not seem justified at this
point. Keeping the handling simple also preserves the previous behavior.
If similar real-world reports show up later, retry support can be
reconsidered then.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 75 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5e557c05d80a..218fb1ca45f4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3060,12 +3060,15 @@ void *__init __alloc_bootmem_huge_page(struct hstate *h, int nid)
 
 static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
+	unsigned long pfn;
+	unsigned int nid_request = nid;
 	struct huge_bootmem_page *m = arch_alloc_bootmem_huge_page(h, nid);
 
 	if (!m)
 		return false;
 
-	nid = early_pfn_to_nid(PHYS_PFN(__pa(m)));
+	pfn = PHYS_PFN(__pa(m));
+	nid = early_pfn_to_nid(pfn);
 	/*
 	 * Use the beginning of the huge page to store the huge_bootmem_page
 	 * struct (until gather_bootmem puts them into the mem_map).
@@ -3073,22 +3076,38 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 * Put them into a private list first because mem_map is not up yet.
 	 */
 	INIT_LIST_HEAD(&m->list);
-	list_add(&m->list, &huge_boot_pages[nid]);
 	m->hstate = h;
 	if (!hugetlb_early_cma(h)) {
 		m->cma = NULL;
 		m->flags = 0;
 	}
 
-	/*
-	 * Only initialize the head struct page in memmap_init_reserved_pages,
-	 * rest of the struct pages will be initialized by the HugeTLB
-	 * subsystem itself.
-	 * The head struct page is used to get folio information by the HugeTLB
-	 * subsystem like zone id and node id.
-	 */
-	memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
-		huge_page_size(h) - PAGE_SIZE);
+	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
+	if (!hugetlb_early_cma(h) &&
+	    pfn_range_intersects_zones(nid, pfn, pages_per_huge_page(h))) {
+		/*
+		 * If the allocated page is on a different node than requested
+		 * (e.g., on PowerPC LPARs), put it on the requested node's list,
+		 * because hugetlb_free_cross_zone_pages() only frees cross-zone
+		 * pages belonging to the requested node.
+		 */
+		if (WARN_ON_ONCE(nid_request != NUMA_NO_NODE && nid != nid_request))
+			list_add(&m->list, &huge_boot_pages[nid_request]);
+		else
+			list_add(&m->list, &huge_boot_pages[nid]);
+	} else {
+		list_add_tail(&m->list, &huge_boot_pages[nid]);
+		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		/*
+		 * Only initialize the head struct page in memmap_init_reserved_pages,
+		 * rest of the struct pages will be initialized by the HugeTLB
+		 * subsystem itself.
+		 * The head struct page is used to get folio information by the HugeTLB
+		 * subsystem like zone id and node id.
+		 */
+		memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
+				huge_page_size(h) - PAGE_SIZE);
+	}
 
 	return true;
 }
@@ -3373,6 +3392,34 @@ void __init hugetlb_bootmem_struct_page_init(void)
 	padata_do_multithreaded(&job);
 }
 
+static unsigned long __init hugetlb_free_cross_zone_pages(struct hstate *h, int nid)
+{
+	unsigned long freed = 0;
+	struct huge_bootmem_page *m, *tmp;
+
+	if (!hstate_is_gigantic(h))
+		return freed;
+
+	list_for_each_entry_safe(m, tmp, &huge_boot_pages[nid], list) {
+		if (m->flags & HUGE_BOOTMEM_ZONES_VALID)
+			break;
+
+		list_del(&m->list);
+		memblock_free(m, huge_page_size(h));
+		freed++;
+	}
+
+	if (freed) {
+		char buf[32];
+
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
+		pr_warn("HugeTLB: freed %lu cross-zone hugepages of size %s on node %d.\n",
+			freed, buf, nid);
+	}
+
+	return freed;
+}
+
 static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 {
 	unsigned long i;
@@ -3403,6 +3450,8 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 		cond_resched();
 	}
 
+	i -= hugetlb_free_cross_zone_pages(h, nid);
+
 	if (!list_empty(&folio_list))
 		prep_and_add_allocated_folios(h, &folio_list);
 
@@ -3476,6 +3525,7 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
 
 static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 {
+	int nid;
 	unsigned long i;
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
@@ -3484,6 +3534,9 @@ static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 		cond_resched();
 	}
 
+	for_each_node(nid)
+		i -= hugetlb_free_cross_zone_pages(h, nid);
+
 	return i;
 }
 
-- 
2.54.0


