Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D578CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4DE6B00AF; Fri, 12 Jun 2026 00:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CFE6B00B1; Fri, 12 Jun 2026 00:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B28E6B00B2; Fri, 12 Jun 2026 00:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57EF66B00AF
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D6E41C3AEC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:25 +0000 (UTC)
X-FDA: 84869908410.10.D8FEFCF
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 52B9F40008
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YuRnZQG1;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236823;
	b=j0hysp+Cz7IltULj4+8Qar5r/IvBm16LjPDRkLGJ6qWocR1xzUeu4cjERRpjSi6m2DHsDH
	Hn25w0bsbHHGE6B9lwBCpNLxjCzYBAZQgaX0UGQxhINsHoi42eCJNT26g+pTdKsUNLO87Z
	ktJ8xaeNsWZq8bZmfBlThUJSf5mY7dQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YuRnZQG1;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/u6lKC7hQ/GhzoNdcnEA7gND1myfeYXkd1NgoaUr0Y=;
	b=PwwVw2xV9Z0wWfE2lVGaYzA/tq7XH1zQjthZFxa2cKW2gSWLVruES0wGsPYEoSPC3scLUS
	E7Uk1GzqF/z4XM9YKkN1hxgo0jBcae+1larWZnWeUNEgLcYTIy/6KL8a/FVcb9WW3GE2H9
	Z36T81c1CkQniPLO8hnccy1NpCDWIUM=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-842319576d5so348409b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236822; x=1781841622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/u6lKC7hQ/GhzoNdcnEA7gND1myfeYXkd1NgoaUr0Y=;
        b=YuRnZQG1SERJCzZZ+ZCM6JF41Ya7MGwGT1MCAtblyHEgJXN6gf6brYRFgtBSdFtJEA
         RkoASfpIT7gmcNH+Qm1xfE7LFf8CqvY8HiXhjFFK5/YQj6qxksTWZCBrsKSRS7GfXZ58
         ZPb6i4RwgkoPFtZkwTXBQmsCwT6gs7Iqk6wVNBwKJfHWo1Vj8DAfmJ/E+ecGD/lPn4oO
         aKVCCk8U2C+csPE85E7J+rVc3yz7nZmMUlqXAQiXLqiu38by+SyDWw26U917npgzePfU
         R/fpvEdjquZKNpjo9ydt1PPnz7udvWiFT9i6X7x+6W7TCv66rOB/FSafMEHkYBg5ts2n
         WsOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236822; x=1781841622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E/u6lKC7hQ/GhzoNdcnEA7gND1myfeYXkd1NgoaUr0Y=;
        b=WruJ0xU4phb5eNnm+XHud4psL6sz7W7MpmLcGErI4EuT63Go31Ea6dOCE80Fn8xXf6
         /CqvS62aTMawspkBg667/FbPbx+v1X/YH6r5jwm3d6dHBYWif9LjGkKWy7c9685kbACB
         alwv10OENVKdGzx7DTiGJ06MGF3RYqHK8Kwd41r+tH39lxsQVb8E6vZ48pQey/tmiQfL
         St2tF0dKsFUiZ8IWZidgnW89CqQTiUfJMH9NAwOE7tHW9DnEi8FnEQ0Mahxopf//6Bzw
         wc8DRdczH0ym/ysRWdmG+XJnSgYmcuIYxhARn6M5L6Fe2kOzpUpGZeHub4EwMdbss8WG
         u40A==
X-Forwarded-Encrypted: i=1; AFNElJ8tY/52GCM6lqNDZxmWgaGWxG1dMDK9WdRQ2V0MZRKhTaclUltKzd3ldPYnOTAFuMtwkPUDa2wROg==@kvack.org
X-Gm-Message-State: AOJu0Yz+ypryWte9wnWtJfYw8kEOEt64OUgUmJeDj5HqKp5R5oVnCjtt
	3yKpbNk+7XaqmpCsYcQ/mD4tbAjuH+QgLUSaMsU1PsmLJzY+AAgAcTeXdwHFZZgXAu8=
X-Gm-Gg: Acq92OHYZvGf76umjAUyEdQoKlAaMFQ1Wr8KGvu8Y04zYV0C30rDwdLWP+jZDVfjalh
	M2zVon+iR2lr2Yz5VMOFqWoDpdUCRzBFu5ZoCSzXamEECSYlGOQPxl6AKy+9veMJz4bGyJ49P64
	3UH/xu/k2HoC5nYcXdXW5VPUavgC79RFNfH/+yJIqB/odIGpArK3Y8Wfyrx4m+xGwSwSXY9elLO
	kMKnKLUPHi2YaceSgZc+JBB29hmMGB+gveFTP0dHe4aeq2mUCQLvqUP9yBAXLWQ+gc+njWwupSw
	VnJB9wP+OMbRZBeZf+J6JY5B7VxIZFGsquq0u9wdbzVlWgbCQv5fO4V35tQSpOrm1+qI1HWV+pu
	/nCrbq/w92hntmHxijSqHeDp6J6NNK+G/qUh7SLt+L2lW33x9nMMMsH18dq005hHbsjT+sVonYp
	5wi7yBJCeKIqMO1ezHNJFJSVtU2arWQNE4HMRUAPZcTag=
X-Received: by 2002:a05:6a00:114c:b0:842:4b88:20ee with SMTP id d2e1a72fcca58-8434d103dbemr974121b3a.44.1781236821951;
        Thu, 11 Jun 2026 21:00:21 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:21 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 14/19] mm/hugetlb: Free cross-zone bootmem gigantic pages after allocation
Date: Fri, 12 Jun 2026 11:58:58 +0800
Message-ID: <20260612035903.2468601-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52B9F40008
X-Stat-Signature: r6y3hio6xr83zk9jrp64jcosbcye4o7i
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781236823-464158
X-HE-Meta: U2FsdGVkX1+SF2UqpDFp5xv0pzonXCLj1TOH+GPziRIcTsBWH7sc4TJJ6s+7m2kdaESOo8uMaguA+oDJnuHxsT088Hge04Ky6gmPch7pcrxDbqUefHrXAO1GMmfJU1CqMXdhLSlwiHCPi9TQ/tJ3A8Km3WmcHQI6wvJ/oPmGAk+wjfdiTEl0qeaQRKakoDU+gTGVfPaFUVlOC9juaTMdauSIm9zcnE9NnqZIZVtn4IGWkmKrVDz6Lym3yKh0mO5FiZPDGMgEYvedQAsRBw1xdZcJyl5yN7+QLWKplpHuvb9Wqd27GO/rNL5UhZXURWNnQHH2TPEm8e0nqPGBrjscyx7tlbMPQuM8tA/vlowY2wLSzlOLb+htNilszxW7ZpBp8SAo4DiSOR9tirPSeuTF+mmfC3jtqjbuzt9RZkpJE5PdIAgVTyPP2fFE+TRUEBr0vuzR6+qYP3fFjmEjpkDapwDf8qLtBGZxKMS8uHwMqMLwi71W0lssDSlKdhFWDTndQimz/yC+/w7zfIsAaM/yAj+b40tIuZK3/9tnG7C9ACK169xsLDEZ0FbIuB4y0bp9bWORECe6l3LcEKweByHUur88pdXRJSopyWZyiLExtLo1kHxlk3xfx0Uni3xWJ1Ki9aJpf9TXQkPpE1tObs8WN4ILPVwdXZwKoVe8MpZxjR7cjzxKuJp0cAHKuC/+HabQ9YbvXe/N0ND7F0Dnypo8oxN25sVmIieCrQAOUdfn6ArkoiIQHVJOZuI08BNNuHxu71BXX/4EieGiz62gycbHXk3sJEc0/t5cQX/C2Yyr6RY36LEQ/IAxBj/4MBabR23F6y3Jav/6X9FOY1EngNm1mLT5fcR6j4yzopiHeoyl60xAqON/vQTDd/4on0dtm9aGcENg/rANcDE5SHRMRKruAfoVY9PN7PaLeoEuApevHIrCOJQA3l7eo6eWsC7UgWPLAFp5T9+MiJo7NucUHoJ
 iOtXkD68
 2tvydjXU+omRZN/hMyc/9BElla7jO8BiaQJts83faG5Ie8Usk3ShRIM1rOSEUJRq/NVHkxHToYogHV/IcHg7EEj26j1UMECnjJArE002NFlUtiZfMpqYsE9R4P6zSQ5im2oY6UG9bjBRbokSltJvqXWr/b31cs6LWuMj368hLQgf/HJf0+MMjvJCVkIa32RbOz/tSFkP02E84JJ/6OA3irzrR6y43E1ADppA3fu5APaJeQUeJpp6YEoD7ts+ehBk28JwhMBtwMMvcEqga6YhSbndRXwQme9OnMSeC/JexYLSL1gCsdz77JeB/DtOUxYmHlCsnMV07JkK5Ro+Gz/PGFo1MylLcPaldMtFiDUWuJCwGdY6CDG3Wtelkh0XesAa7a/efbVknaV8uxjtlH6UZOvzLHN7YzaZVnZC7gFzkd/NvNjQsBn7v+YjWXfFYZaAHiS5UHHHS7gtf60keSAKN0HIDegBy33iKRHCe
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


