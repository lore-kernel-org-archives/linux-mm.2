Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6004606EEAF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Dpd5j/F3
Received: by kanga.kvack.org (Postfix)
	id 9227F6B05CE; Mon,  9 Nov 2026 04:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA036B05CF; Mon,  9 Nov 2026 04:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836DA6B05D0; Mon,  9 Nov 2026 04:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3256B05CE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDA40A8224
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:46 +0000 (UTC)
X-FDA: 85415131452.30.4964AB6
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 143A9C0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Dpd5j/F3";
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rgpk92s+uUA0iNQbnwRD1KF0Q5tk5w5GCL0hUC4RNk=;
	b=ZowPW0x0Ro557KdKBqKhpe2GTonX3ALCS0ynPs8DlGo6y3ZY1Zo4sp2eY+wubuFNA4DwkH
	DR54plP1pTFtyUwQivJZJSbnCU/YHF0A3yRW1+7dgkRDFotR2pQ29xpVySvLkkjWCEU0nA
	eo9a0WAtAvaPj9S037QLafG3pfXf9Ug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218325;
	b=i0RtIbIo+mdgrf2owmcPAxYgr6Td3ylFdIS22oRZkcJI/vBmiCXvc4rtM3SXKcNHq1vwuy
	RK3fLd4Co6kfLr/DeZjnnCO96ZcVEI+hlSESh3pCtln29TKJLa0ewViPbEJhjDko2v+4V0
	8aZVS40leCIENBysIqRyXiFw9cMlK90=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Dpd5j/F3";
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1a8cc11ac42so484133c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218324; x=1794823124; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4rgpk92s+uUA0iNQbnwRD1KF0Q5tk5w5GCL0hUC4RNk=;
        b=Dpd5j/F3xvpB6EGfpGJdvBzNyqWbeTAcmDoKD1Udy9JeDokV7j3uS5sYoOVKwyK3qk
         xHUoVB5jYrj5zfGnA8+rUTEtPwN1o3S9KVvpZJO/HXh0/Q1Hqt3xYOzNt236XzLvaavB
         KnQuq4j3NMs8Uc1XH8O599FUc4XZz6JaMBXhb+0nE49r5NQLtZU5i+lQGUXSKE0nwA8M
         z01UpuNUg9j4Jk2C9DsWQCh6QCh1hd6V7NWBhYUonZgF0mGo6203HPpigsyU3iXnXOcu
         MSTHVxLAZbRjAUqFB7qtjc2slkHOvh1iTkz/aX1JBXcstzmWn7eceKGthfSupnzoIVw4
         COmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218324; x=1794823124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4rgpk92s+uUA0iNQbnwRD1KF0Q5tk5w5GCL0hUC4RNk=;
        b=QYvgtdFwcwnuT9SZtc3wl4Qb/I0j+2vutWmKJYnOq0kar0HItILe/Ws6K/ftsmtipl
         QpRR+lne2uKpWQpcO6FQ2O9g3BJktWXqw2vxEU4DMtTzxP0J9YIqR22WlVgxB1tfCeK9
         wlXuUG/f1Zu4EE8lMwfxBZicrOs8BmFXriGGHusWkDp5L1auJedV/VKPg2SC6xiAF5P8
         D7TKiNKIcEXDg6m4KyeQ0xSEVoaWHabbgVKyWbCGJapExilCNukyzE+8myi7ZWtrKayc
         jgZKERdZCZFoMdwdwUiBOzIqrsqmgT8GM1LJXIQ+4pCQoSJolne5qDxgjWMzixw+IFto
         OsYA==
X-Forwarded-Encrypted: i=1; AL+hErE3orTPI9bMAy+aKAq7qefLgTjwL9cZoMYH0jcNEGiBwweJiNfTwSodgONt16wScVFom8AzXhdYjg==@kvack.org
X-Gm-Message-State: APuU4Z8Acu6q7aSpKa1oldnPd1WyrN3ez88Uqci7I24I663qR0YVwSd8
	doKYYUQ7lznX+91XHxNfPDioX8CNBrCQORrH0PfSxJRyHhO0dHcIlqZX22/BnTz44sI=
X-Gm-Gg: AYBFou2OL7auOJyMvUdOihQvhcs4ffbWBJ4UDH8zcrFsojORTRMehTpJNSd7GrfXXaK
	rJjnEBNtM/Y7TiFimSq68YQEDclgGl1OvTPdfSVVo62rTEQsSHUS4Dcb298E1mnUm+XrKMy0uSO
	HhQtsf7Ug5C8UWXeo9WERf0cedks0GrC2rsSm9kOTE8zeIExEF5FAJ/GYOC3jKdXQLXUS0sxpaH
	E67dbFqQ5bpd8nHRN/EQq1f8k8lqtUaZyot9dDuGsUPkQJDC7aYpjtBaeOxeyKveGKosM12nHmY
	mP4PUzIV4mEowUBezxS9RHlHT6vDv06GF7lVdXmKm9kvDv7eTQl15zNkDJIpkZGz6NcOxtfyFtR
	R8XI7ugYex3HdspDl4FzKmOqiXTfvFA/yFs4u7dBYCswkY9GuBJGwn8wKY4CVLWmg07sn+opXCO
	3K2iP0IEWBoPrTO/tW+5VVXfcZABIWQFfDm1RRkYnbdimo98a+GyNkRDYDCQOI1b96tJuHKVvJ/
	Ik7Y5xVj4ym8q+70tlvAfdX2Bsszt7TvMtM4J3EFkJe6vHDDg6K/Jih8l/ZAOcbU1UXljZc0+mq
	D925kqmu2ZYRjJdvmmvLLSRkob2Qoc8+mgiqOmGybaO4vLmB4SrtvIlfdbPBIKQ=
X-Received: by 2002:a05:701b:450c:10b0:192:fd91:c567 with SMTP id a92af1059eb24-1b39fe87361mr6354138c88.11.1794218323426;
        Mon, 09 Nov 2026 01:58:43 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:42 -0800 (PST)
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
Subject: [PATCH 06/11] mm/hugetlb: initialize all struct pages for bootmem hugepages
Date: Mon,  9 Nov 2026 17:58:01 +0800
Message-ID: <20261109095807.41547-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y4n5ejxhomijpxxdzd97iob18gs67p7f
X-Rspamd-Queue-Id: 143A9C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794218324-890011
X-HE-Meta: U2FsdGVkX194QIUq/vvcmERPAfRVkMIFXflmurXq4lEC+es4QBTPiD2IjpNU9P9OnZfrLtCjyzC7zJpKEBTFiPsfkF1UziTfTh+Vq2RHXr0SKOlpZJrlLJFuQXQ5G5ycquNrAeIT6ichssPA1Jb//7G1Ol3/h0aS9Wyup1XtLfx9Q3AdLM+FWkyUk+vjruOqKh+qICQCjH0iWQzEIibXIVm9v5BCd9Rxazc7QQsKeJOVVbOIvctIhGy7WmBSltrU6e1m28lw4dUdvKddr+ZV/IBBYnEGqNfPSIbUiWGz2p7rzIeHHlvVQ+E1tJo/ZJ8KrqpkWJR6LWpaCerYeIWLqrjnwAHY/8NMzb+XrybWQNfMACO+vsPbuKDyTp4ky0uUJOApasWq63ALbCeh8rIkNNZR27xIwM49liq1uqWFP2ni66G12a8mM8OAjXxZ7QtGZaguPmDF4VsvfXGr3CyBhHKwS/k3XSUUym1WsnTsVudVoco75FbS54Rq2aWecpYv3XbM8GJHdjFusWQ01/rrombnyZh0RWvidRe1AuSco9GKS9/FgPk9l93DPsEzimLZ68PTvU7HeY8IiEgryclatQRTQVB3guH2MM10gwkt9eJpqFGLaEc8Dfle6qCCGGwdlvn2f1Qlr8k5txS69qSuOKtkJ0TuqrxCpkmsTMJyuNhQoMlln1L7izUqJU/1Qkl0GdhLrb/V5yRZY6RwhOQbunY39PS4QjhP6CRnlHhMdk0iDQRMaW4SvQLHy6eUyqE2Twn05FxZAWDlTSXELebxv0Kq+pE9romQf5yGwCiQhwpMqgrjfh8zZjb7TMHr/qM+iP1tPd6WPEXCnk76QYhmrhrRTtAzYsW7Bn1dLfUovhNOp5kKgvoEkgF+hjDWOW0jR+gDBuxgegdDicLSckcqdBpXRjaHO/ijwsaNdPrGzAGKXilWKWPHpjC+nGYVt2Rlu7NSHW6W6+0vppFfY1a
 +OVIBh2w
 vvkCsaLXMhha/RQYYxB6eGrMG+CYWRFfXr58aCx4LOTPG7NeQHPgKRNJBd2N0ORkT0dY5fuBbDIiYYnkx0jndwllAZwVtb35Ki/YDpjnOfMHqd2DUcqbMGMDtPXtzonxb2XMrz2nxX/mZJ7X3J+EXQ1U8zyu5SVv8D+8ou29k0K7Kni28ZykQ1qRae65R6WqQb4pPc37XC7vRzxDJxXwyePFkBMlsGdkgyjLKEMJA/7L2kQUgKCM9YR3AA9cy63+ipmVDmF9+p97VvuXdpB4OTbY1J6UUVUmcFdMWt1h3/5DnOkbi68pEixfO7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time gigantic hugepages currently leave the head struct page to
the generic memmap initialization path while the HugeTLB code
initializes the remaining struct pages itself.

Mark the full hugepage noinit and initialize the head struct page in
hugetlb_folio_init_vmemmap() as well, so the whole compound-page setup
is handled in one place.

This can also reduce memblock metadata overhead when many boot-time
HugeTLB pages are reserved, because physically contiguous hugepages
can be covered by fewer noinit regions.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ff6f837b6df0..d2aaad235458 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3216,15 +3216,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
 		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
-		/*
-		 * Only initialize the head struct page in memmap_init_reserved_pages,
-		 * rest of the struct pages will be initialized by the HugeTLB
-		 * subsystem itself.
-		 * The head struct page is used to get folio information by the HugeTLB
-		 * subsystem like zone id and node id.
-		 */
-		memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
-				huge_page_size(h) - PAGE_SIZE);
+		memblock_reserved_mark_noinit(__pa(m), huge_page_size(h));
 	}
 
 	return true;
@@ -3255,22 +3247,23 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 }
 
 static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
+					      unsigned long pfn,
 					      struct hstate *h,
+					      enum zone_type zone, int nid,
 					      unsigned long nr_pages)
 {
-	int ret;
+	struct page *head = &folio->page;
 
 	/*
 	 * This is an open-coded prep_compound_page() whereby we avoid
 	 * walking pages twice by initializing/preparing+freezing them in the
 	 * same go.
 	 */
-	__folio_clear_reserved(folio);
+	__init_single_page(head, pfn, zone, nid);
 	__folio_set_head(folio);
-	ret = folio_ref_freeze(folio, 1);
-	VM_BUG_ON(!ret);
+	set_page_count(head, 0);
 	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(&folio->page, huge_page_order(h));
+	prep_compound_head(head, huge_page_order(h));
 }
 
 /*
@@ -3328,8 +3321,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
-		const unsigned long pfn = folio_pfn(folio);
+		const unsigned long pfn = PHYS_PFN(__pa(m));
 		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		const enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
 		unsigned long nr_struct_pages = nr_pages;
 
 		h = m->hstate;
@@ -3342,11 +3336,10 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-		WARN_ON(folio_ref_count(folio) != 1);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-		hugetlb_folio_init_vmemmap(folio, h, nr_struct_pages);
+		hugetlb_folio_init_vmemmap(folio, pfn, h, zone, nid, nr_struct_pages);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-- 
2.54.0


