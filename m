Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8AA606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Z28sGHfW
Received: by kanga.kvack.org (Postfix)
	id E38976B05BE; Fri, 20 Nov 2026 05:10:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F5D6B05BF; Fri, 20 Nov 2026 05:10:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25846B05C0; Fri, 20 Nov 2026 05:10:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE3E6B05BE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:10:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3470AA0E8A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:02 +0000 (UTC)
X-FDA: 85455076644.27.0EB65C1
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6BD340007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z28sGHfW;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169400;
	b=A71QhIklVR46sCLCwGiTqz8t9XjomrAJm4V7HFXqzu5s6IAPEwNa0ygKlXRZ77jytQzMow
	Hyr9geocnbZiyPwu5jfs04Qy7iknnaltbPszqAcfavXQzKTWPNyvfzWhpMGxfIHRGYjkhI
	6JNTsjFVYA31Bx+OaSWU4Gyeby3xOFk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GPsM8bktQd8MlThnrS64jbcTKdAdxXsvnC3sXwF88w=;
	b=qbZKcdlq33I2PHR4cqa2G/yAwLLCK4KlVbk1MhV5PnyX1myG586LnLbu9GbZPaAS1djlnT
	Jf9As2aasDhpaV3ttMciBvOJqxxtJUp3eZLs+1X4d+OMajwVlflqMDIYfZ8D0w5UuYRytv
	V08CdMinbcNwRpfqXdQpxdu71942x+4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z28sGHfW;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so433746a91.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169399; x=1795774199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4GPsM8bktQd8MlThnrS64jbcTKdAdxXsvnC3sXwF88w=;
        b=Z28sGHfW230FCnO/BCKDRnas1Jni9QcxYyhm7e3pX5FRropXwidpxMaljO7S+OPKYN
         afMrG4JPy6OFPfeCjE4oWhSsN2x8CzTQrjurYlh6mycpLvLibBShTIca5OgrF5SJGiuR
         x51RVfSqiIh6taSO7dKiBvBtqo/0+VLOxUWpBqoAZybsIi3cIwPMdPRp57xARbRj8RGI
         m1ORqjCRVfp0DgEe3QUB8WEgW1+H7Z+ZUJWtYvK9rwGYpcQDO721d3heYbuPdw4ydCkJ
         gmW6/oA5yoytQK4v0eEVdRHHhDN5r4VNsvNL78/PiUUKGKHbTMTxbcGr26YMMtoc/WV6
         h+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169399; x=1795774199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4GPsM8bktQd8MlThnrS64jbcTKdAdxXsvnC3sXwF88w=;
        b=W+azwuctSaFEL3W/U8VFYXPyPrwu3M2TQPVkPaCAtNXg41JeEmkiFAKE2m9HGxm0ea
         BCdT2jMri4acn2f+h2EPvYGluwXEAPNcQiDpJ0ABgNwI0ePI75gfE9BbKfrjLFyU/6t1
         SRlvK74uUgjgnTsC3OWzHs4e//IlodDaqoA+nZBmvgu6a/cyxBnJjg9oVYZR97Xz3glY
         Rc/Q9TGimzYjs/8yZkiSvcwOe7+uziE7Y0p+CGDLQdnmrhyxZUNNQdbgoszgtoMrGjZP
         QoxAw6Ic9Q2Q71YHahgZBrDcdC3UhMIDv6UUzyJLTPP8fUIczPqteGoAlnwVyMAiynHB
         +0gg==
X-Forwarded-Encrypted: i=1; AL+hErHe15nVMSiffbzVivoYxdzHVMFqwrBsoGMU7WbEajOr7FQCxHs+smcER45PCq+VYnqG7Q2f4i1pfw==@kvack.org
X-Gm-Message-State: APuU4Z8sjKI6FnSlEvO2NITrMaUof1ltGzUklJyNC7fwqDsW0A+PYuzm
	eRQ+4gg4EzkOd0MYrqisp/kyaFB9rE0eMMzkQ4QTd+P89nS6VS31UzBPRwJnq0VCKPk=
X-Gm-Gg: AZFdTZeiOMf3YVUU/X4JKbqK3J+NWosS6mIMeY/7WhJl6p0Sb/IfQx9YokOoIwKRudO
	dQA9K4HZwNJn1t+mh3H9gVCD6rZOYO1SQSGCWsGbs0ZaalnRJZA5C5lqg+3rq9QkSOaSiaduv7O
	7kVx0uAMyccyVkHbjtfF8HxefbMu2J6nHEi0Gj5nER4SiLzFjiLzhcQheu1ywabx7T/FQ+vEVod
	THgbKjXc207XUmrN/K3yBZeVXLWLNF1NUBuN7ogndVJMqQ+pqhZAIpHNUfsT34Z1YEfhdWDPDOE
	eJ7/18M7tzVogMwnThBbHinmNZrU+v5byjzN2Gs0Vbzu503LEwVE+nz1wAUsh5GfC+vEgGTCY/9
	MqY6Anzf/gYi5Y+VNfnIOzrPGRxwKrusAz69Kcn3RTTJtUK2nfzvNqrb6KB5V+VB3OMYMHLY/c+
	LvMkyVetBPJWpEhsTt6Ky3xtbzm4crTjvLGV3Z6pSJeZu0ZcZS4Z5tldLLTbSFd/Aveh+sr5/AE
	f4Y2NympGACSDiKKhB7sETNdNKcvBsSl7JMyy/rhXKLj+YSwRVI+Jm0gPelAD9RHjFLFPRWHF8I
	Bf+Yrulru0ljLaNShvMj/tqUehemHWeUb1L+q99X3hHTbEsSrnDeQcmwdUVjwbmq2/Jlxg==
X-Received: by 2002:a17:90a:c10e:b0:3a8:13d6:f740 with SMTP id 98e67ed59e1d1-3b41c911c91mr2319623a91.22.1795169398552;
        Fri, 20 Nov 2026 02:09:58 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.09.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:09:58 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 06/11] mm/hugetlb: initialize all struct pages for bootmem hugepages
Date: Fri, 20 Nov 2026 18:08:51 +0800
Message-ID: <20261120100856.16929-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6BD340007
X-Stat-Signature: 7nbospfnby4nqkmydbjxjojm5jqdx6tt
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795169399-957446
X-HE-Meta: U2FsdGVkX1/qSWkSpfEMpX7JcwUi+Wix4C6qMi8ggUZnQhhxrm9/GcVh6HsINOaZ5XLWAFCKQM7jZIg0cmdFw+aU/zTMICEGl/Vux8zBAnlh/1fijxXJFYg9cRJ7wcoQHW9UzOZZa6IMNsS2I3lDRPRXp2iy/NqeH9zbbNMZN06AOYgn8ZHNC9x5NanyNXnedLQGbFGW1eIQnn4ngBPYK0EN4ccUwR1pJnetF98N33hcnxBl4bZw4362S+/dTSjCXhlDtkGK/UMYQHnC72Ud82LKUXNeo8EC2VAZm2M5NKiZ+2jw+oTpErsIOvwY49r7fkpTwi1n2ix8pi109IjPy/cYAJVCSjbqH4K9hWdmihMv3jALGJTOFO6jNuxRzXVueZTKv4dbO7S9+EYWMXOruMfZesIe0PkR3gY19NE1B8UBcWqIyx31T0kMEYTxwz/x2A4ADtt8aDpKgzsRTcQiaL1hdpYXZW4KmhW+2+nump7cprTFxenE7FRE3QiTcUWNDx/1Kv8ZeQTBiF5kZDAjusgwYWkwAt1TSflXybCr5wUWf0DoxnanpCM2NPTbT5QZWwbcdEy21MZ5n3e5/E7U8gEkxfqmORBybeefYsxRZKiLQUby4JVSeC3pcqSZIbpGNv6PoPiBM2YlruVpEUr3xutkulZOts9SjaOP9PmhC2sXaqmJTKVHpY4NQsDGnCVsx/3aTWqk785ciRy4kwgktTBHeuSLlj6r2NX+LPAaxL8j74zBIr6n9aci1kFv51qlTlx5PtOYwk5+w4cc1qsI2hfQbICmN2V217meoNVW7MYR7OyhbjEoCfkIEckW3PeE5BEJFoybKlEz7eNsuE99UNroISFSQGGSWQ0p3eQomIfakzaKAsDAUjbfxruubrCxP2Xu9jvJFzfTmlLiDbfynavOK7wUuBXii1FSC9br9sR7IRlv7G1MmxbaPPa0mAgNWjDDFz45GWOveqOENJ4
 MwCtY3Uu
 UF8L9Q3tx6DEmpbr5bEJK7d9iCxSnJHnzPZkYJuidjuEdfTReZqBGT+1EWgHhbXHHbcMPddK5wAAzhwNvGb2i6H9QmScIlzTlmEp9R+FmlLLUxKpuJzQvojznkOfecp4+XXcjqF/0lQqKoNPaHb7755CZrqmKpYw9wp2fAT32zTSIXlWyYQzz7qvBq39QyqIPqvHX8Cb8VSOgcNFeZhJGW0FSRwVhbiFgYnNxoxuyVOjuriqMkwZ2tt+tDCs2vjlNRgYTwOtkhAYJOFZ6teNPj2iGqDYkvs8lA5Gy89yqFjBXM1eitsrOPuk7scE1vUcio8s5zyhCG1XBd5f3X87QRCa/w9uGiOZy8p86tAa9rI8uXPVQ+KxLG/Tvcl5QA0tl/vqVmiZ8NRzlgDTe2AkPnSXrVVV/E1wrjyGALNS7DBcX6Bfw8tALAGF9ILgpnkOBPfJwm0vzhfsGTwukliWYyW4Z/hwyVeB7buXNKBofZns4lYUT6YRxtxkSuCumzIPjF9ixOJ+Ybky6hud5f+pOyhRIHaObnaNlqDhM
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
v3:
- Defer the HugeTLB template-copy optimization to the common helper
  switch after integrating the series (suggested by Mike Rapoport)
---
 mm/hugetlb.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8b2bf571e781..2a94f8f60870 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3313,15 +3313,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
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
@@ -3352,22 +3344,23 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
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
@@ -3425,8 +3418,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
-		const unsigned long pfn = folio_pfn(folio);
+		const unsigned long pfn = PHYS_PFN(__pa(m));
 		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		const enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
 		unsigned long nr_struct_pages = nr_pages;
 
 		h = m->hstate;
@@ -3439,11 +3433,10 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
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


