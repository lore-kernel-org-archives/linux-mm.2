Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97EA9CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D6F6B00AD; Wed, 13 May 2026 09:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E026B00AF; Wed, 13 May 2026 09:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6C46B00B0; Wed, 13 May 2026 09:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D891F6B00AD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FED08EAC2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:53 +0000 (UTC)
X-FDA: 84762426546.08.57EEF64
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80C874001E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ciSL6ikH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hECduHIccySBzXm1iwDhAhigl+PnFtS+sgbTNemvQzE=;
	b=cJW2umjHtj24yZn7YCazwMi/TGNBEgcxIKFewYXZM2IooPab8uD9m8ZTbbuDB1jJshvAjL
	i3T8GCZcw64ZmaBpRJNV4YkJM1eQgEtRE4aGb+y1xkdudppOAt+17Hv9r6BafCzPd0REqh
	eJcY4UDKue70ljF78Kd7FIoyDJXMnFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677731; a=rsa-sha256;
	cv=none;
	b=fa93OulSamUB5bCf5SANIGeJhVfbMaRs4FxfnZFj2LAQY3dgmFcVEuPuNWtwXxUJPPUkha
	iZ4DvZ5JCfNlvXbRE/hScz6Am5ObaG0w5wgL9L4KPfPTTjDZNrZdDHEYHnEPwPGAZlQ6Th
	nFgLwCULJQGjHqQmEx4Qrusehlgiedw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ciSL6ikH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bd2c147abaso5477585ad.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677730; x=1779282530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hECduHIccySBzXm1iwDhAhigl+PnFtS+sgbTNemvQzE=;
        b=ciSL6ikHZnhtgypKNjct+s9Mz06Ird2DG184ege4BWy001+qmIz6xWBwtRQxrUSyYY
         SzMbbaWS0b535Jcoh1xCLUguj+3k9Fp0t5/DvGIGohN9FBzeidlm23HHICMHvXPVACAb
         +MTwkEv/Wv1/+Iz00QVTBWNXJkl7ipe4yM9kjd3apzXIQguSpiXODyTM2MiJOL7kzUm+
         MyilLCVXLGC/xJkbKE5NCM8QxfHk3vBVxi5g+FSFKgFqy6oeSSo4o0IvvVlUTgSVR4Us
         ZN+gxTMIyKmzkKVeJh19L/g665V2DH9r440/k5+fIp575Bqlh2yXtiHgZ8byPTIKse3O
         Mv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677730; x=1779282530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hECduHIccySBzXm1iwDhAhigl+PnFtS+sgbTNemvQzE=;
        b=c6MpkwwW27YNKnEBkZvmPRxKKgDAkLHOozFhCukCm63+EW5rzbylofpzfHeulToqHk
         smyRmqUDvFvnAjvFepFFximXf3OgCzNapoAtthybEVVX++tKlUpi3NniJXCEriMkUydX
         lyBywHktbwP7dt9nMFS2XzHfZ8kx/lWd843hpyz0hZvhNBcJDgmNTNX1KUw8bjI3bKsa
         rBP8kFtcdRMN+4A/8e6BrbaIjK1nbOA/K7+agTLxEcgHXcnQ6ZzsiWTtKL+JQFUhl7bF
         fQwIbjbOJ2BCBql3aJhDk6zBps3aVQys68JLlOs9rZYhnuDsO1a/3Hf9TafZqAzdi2Bc
         ZLKA==
X-Forwarded-Encrypted: i=1; AFNElJ+aal2QjIx6PN+WR4woVNSUbz62UpEbTbpjA28UiIbUJutjGDMQg5QL3++pwtAwfOkppY150OCorQ==@kvack.org
X-Gm-Message-State: AOJu0Yxh8nIeNsUKK1UABtWAUVZgm1gcdyJsczcXZusv+mta4TLO2886
	zICV5PYak6XWlp0gOF8ctUO2zy7jLYKPqiNGKcw6Jv2YBXld0cuHKLZutKFFrMWbbB0=
X-Gm-Gg: Acq92OGNLqubJzo2pLHIblb2gpKkV8OSXrhR600rsyGJwV0Q6aRGwyPC2DBlAHkGoVr
	f8OgyX6hxkBG+LxL8oP6Ly1cpFANaK/FdeQNMHuqV8UCVP3SqDcA/MUNKkT1q6Ge/8ClEpt/sys
	Po3aq79w+fymBZ2nMvtjuJr5A5lLKIkRQGvVCDv1jLLSHup4T7XLqHVKVlZcST5T/CAmNIukO+p
	n8bqwi/EvDK4rKQzoYRy84o5TMjTczelbyPzRWa1zCph1IJ8kTQgjrq26QKZeaDrd47056b6QBI
	CccuMwnlT/Nwt02yR0GJ7Yi9B3H1h0xXTZgGzoCRWeE/aTpHmWPwYOl2An3mW6bhRqTeFHeyCE6
	aYhX8ARW1s58AO98VC536PFn9Q/9JRLt1WBLOn/jMwNhhAeBymp8ZtXaXcAJCJz2Zt6R/6iOGno
	sIHXvRBVWz3L9R04RducqCTuPAHbOXhR378uTUXZxlRHX1qNxrnLWZgmhHsugEZEjzxCSjGA==
X-Received: by 2002:a17:903:3803:b0:2b9:e82f:bfef with SMTP id d9443c01a7336-2bd275b1d3bmr34581465ad.21.1778677730063;
        Wed, 13 May 2026 06:08:50 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:49 -0700 (PDT)
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
Subject: [PATCH v2 14/69] mm/hugetlb: Free cross-zone bootmem gigantic pages after allocation
Date: Wed, 13 May 2026 21:04:42 +0800
Message-ID: <20260513130542.35604-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80C874001E
X-Stat-Signature: ix7zg1uieewyf1hnysqhb9dfyd5up5w1
X-Rspam-User: 
X-HE-Tag: 1778677731-990347
X-HE-Meta: U2FsdGVkX194Dlq87pc+CpX1K5sg+W+cOVLIGBcUQTg9/Se5w2EU8cQi0Cv80EAPJEijw8xMniykdp4YM0W64/1GbUL17iN1qYmr6xq7iVNRsE3df6oCVU6yKvAw/RpLghMLYEANnNov1dqCorC5V8CgzRZZtV6Lpq9tHzVZFkeORVo4zpTbYfyWOHtmhY6Pwg10Fk67zyMp+ikF1c+agDiGYU3Zgg5ZqHUvV+Mm4KvW1B5Tm0+NJiVTY/TF4sTdILyoTt7xXWABc6VOpNWO35YwHRvYpTI8+XJqSdl4xKAnnurR6kopx6M5tSxMw0fnxhFxkr3fdWpzpst8uDoYYkcJv4GfqkD+hHxLMz6RNV3s2YqYM9pknweVENWALdYNKmWLw642WN7eiyV49ohUcBJzRzjW/BVMDd0biLiiZcEmOR2qxQVmZ59N2GAgse0ya8hZD8ilIj8A6M+ae9uu0tLWv65khXn5MWvrWLTJoSU7XweCY+m3nQepepREMhQh3vmZYkb/I1uycWAeO9yPz0aP4La22tqkQuWK07P4z9kzbTTWJlOqLWyl9gBWV4mw8G2cwhoHipP8xL2rydz/h9vufNprv2WNrgIadt382pR0k6MN+XiOHn+RGxVgIro2Y8cQbeLJdd8WeHg6sXe+0pkKutS/GvHpfIyUcR45m2AhRK3FCyWgAnKsTbazurupqwk0U9t4hHvXUDiMUChtHGJPVuNzZuczMvHoa7xeTxB/7ElaOK6TFUzc9zN2u6KS9PZEWV7LItVRYKZIU+qFmcxQBuKBEqZOqnI+Uq9Z40sArsOVL5CpCArdT0HJWQRmMF/nHdiQUlkfNSgTrkw7uCnDuoAK5QlAGUshkZFVLLgZeDwaBK7AzX+7AEPT70VdzVsdai8yAenTxPu1po0ugIsAQdvUcJX9b94jB6PYG7pypriXu86K7jR7tIrWIZK0kUoPBnt6dIWEVzInAbo
 LMwKMwQS
 g6X6m/5RepH1Cj8lRDt0+xxqZKLqfPqplFKVY3EZ5rFvNYtOYZKXeaBpBuXhccleGJpNT0k9p3zZKTcJ2MN1I+O3tzdGdi3tNHc4zV8wDSZIAIJAMhSD06te+u6I+Z+Ck33tDX1f2tb+IsZev1r8FZX07bhQwSLkrq26zjsNDtmyDWfREHGwQgsjL2Op6T9g4Z2UBf9sHaKVGrPOzvhKhI/0JC5NeiVxvpZY/wX9Ha3Wwno0kIy4ifhnE5qQ3jOM/DH6ywt/CfX5hwMrO5CUuO6b3rPKi5MJR24fKJNZB+xphOJfE1w39d8DhnbZqrQjS/HMSWsqZ1DqcfiMieTcifd4mfJFWpqTPeiM/9JDVRLQsKG5ve1BnMqh5i9sTcWoyvZzIw1o/WQcCNhakximqsWMZWw==
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
index e9ba0be2eb17..d5d324f69d7a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3077,12 +3077,15 @@ void *__init __alloc_bootmem_huge_page(struct hstate *h, int nid)
 
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
@@ -3090,22 +3093,38 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
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
+		 * (e.g. on PowerPC LPARs), put it on the requested node's list.
+		 * Otherwise, the cross-zone page will be stranded and never
+		 * freed, as the cleanup code only operates on the requested node.
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
@@ -3384,6 +3403,34 @@ void __init hugetlb_struct_page_init(void)
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
@@ -3414,6 +3461,8 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 		cond_resched();
 	}
 
+	i -= hugetlb_free_cross_zone_pages(h, nid);
+
 	if (!list_empty(&folio_list))
 		prep_and_add_allocated_folios(h, &folio_list);
 
@@ -3487,6 +3536,7 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
 
 static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 {
+	int nid;
 	unsigned long i;
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
@@ -3495,6 +3545,9 @@ static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 		cond_resched();
 	}
 
+	for_each_node(nid)
+		i -= hugetlb_free_cross_zone_pages(h, nid);
+
 	return i;
 }
 
-- 
2.54.0


