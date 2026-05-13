Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9829BCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D6C6B00AF; Wed, 13 May 2026 09:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076336B00B1; Wed, 13 May 2026 09:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD146B00B2; Wed, 13 May 2026 09:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB24E6B00AF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 963078DBC8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:58 +0000 (UTC)
X-FDA: 84762426756.23.F6F9AC4
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id BC744C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aZlbq5QH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677736; a=rsa-sha256;
	cv=none;
	b=IzfwAk8J2/4NZBDojNVVHJzum/qbaml8Jphts2NvJC/StAqi1anBKUxbNKFUVZhexwsITy
	2ho+EoY8fD5WgbDOntUPliQTQFt7vMh/PJneot+3AqIRN+ZSHRrsNrAyVJIb202C3V+RwY
	+6ZBC9scrh0wcg8q9j3j/e2A//L4S2Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aZlbq5QH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFXyqH1Cou6po67hW+Tbj9/tmuAtnCuDUU0al6ZhZaU=;
	b=2MbnWcJ9soZzWkdewkUcSsM/EhUwxYhEdaS9EMkhd415G1TyuXLcQC8wxdYtpnSbySvXEb
	bpnjlTo1aVv24+s9uyKAKgmsxqZzW4/sngl3ngzbKTaGMgE9TiMzBgizyDiP1vmeoQbqbU
	Mh4bMlNBkBeoJwl8Bbjxxw8SqBo0Esc=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-366087480d8so6040146a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677736; x=1779282536; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NFXyqH1Cou6po67hW+Tbj9/tmuAtnCuDUU0al6ZhZaU=;
        b=aZlbq5QHVF3Sst2zvzWLgSywpOglUtnUGdAfvlRIBGtn8quBWmqoERhEYJm6IiOCuT
         hYj0+SUMHj0CixUzOpR4SCnAB2cWtWJiHakbHUxrADhYh6KAMu+R3yF3n4r0vG3w6cgr
         pQQrmhMAlE/jNS6azoVF7q1iqlwaHCyy/qYFp1kQaIDi9P2QYVGVDaL0+neJwmYH8i25
         EhT5LwB546XBselqDkVvWbUt9G5/l5r7S3SKGrrSl98TSWFRYbx5gR1FpHG0GiwgUiao
         Z9mTtovANUXuN+Kw28TZMzIkJG30aC8psWYseAIC5ZN4he75wEqihpIwLyDJZ7UfOqYa
         SdFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677736; x=1779282536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NFXyqH1Cou6po67hW+Tbj9/tmuAtnCuDUU0al6ZhZaU=;
        b=ZGKdOKrkWg+wiqjymgvFfqtFQ1UY+J2SrvaQkupQwLpdRJWLhZermCSDNfzMJDAL7P
         gBczGR3GG+it+NiDJY4kiaDQ26WKw4qShihpHBxAPrbOw67bQieU1FTd+w77SHGT7Jmu
         4iHjtDAGy6Qml+wzwXIxfdhFn9+j0ykfemD4jSwWY7lD3GQBONNS9WOPgCMpecVI/Sfu
         pngytazA4txOOjczp+Z4jCaPwsuwXmQXXAuzkXDIskq3xM0uItY2vSgwJjF5QzHrCwsM
         5sHNxeg2yoQ5goxrw2HfSbw80l24/R1U07N5VHGKEdE8hrDqAZY/sc24N5UcW8AXsnw8
         YqkA==
X-Forwarded-Encrypted: i=1; AFNElJ+n2W/+JWga4Ndo129veQNvT6IjV/iXTXiqKrOPQqoMdxas8r4Rt2F7S9sxwhMSzcsdSZXpy9yAlg==@kvack.org
X-Gm-Message-State: AOJu0YyyvpESaxHSJFDgyo60kYv2PscMgVCu0ea9eQy7rFvB8aZwlRu5
	3iVQu/bho5XWBYTvgvAVcNYV+enAp2c8tzd+McTmVZoBnTwqr1FE5JQYuByPk8uPix4=
X-Gm-Gg: Acq92OGEAdckvt05defGyqKPua/+VYAk24nETRINfoXTRGXEPdQlJD8OWaCMmbUygUR
	31wMV9qIQUNmSfVtDDDvHbz7O/ZkuOuCdd/Yv/AfSBAxR1GtncKef8LFGrKLV5MxSrh/yh6ccM0
	2fRzHwxnH7UK+klUYFEzJOpJpZzMGq7XnvbwKmLJkApKUIARvcY2vzG1iXo1H2uboe6wkObjBmv
	GVRDfjXTsnDtm2wbPiGVUebg9+f8Mc0ZBKZ/W7tpg+QB8XLcfUYZa8zSpXHTghDNTXZ/D659tGP
	T3SXJbGfk72FsDFcRnkCITj2XxURf7zhlJ9AgXfE83Xo+9tog0GTxJ2CpbgLWwiNXuVVxRVuAXC
	kNwp18qxyCAhdEJ4MSExA5rZK5lAmxEcjJu7KtRLIGIHZnQMZiIDOQ3dp4tG0W2yX/zhCsPmoy/
	BFzslumyQYKBifhbDiUjP02NgyC6p+qb/aUq+UEH9QVdO49OzTko4YbadHIgI=
X-Received: by 2002:a17:90a:d00e:b0:368:b724:6d53 with SMTP id 98e67ed59e1d1-368f398cc9dmr3518409a91.4.1778677735539;
        Wed, 13 May 2026 06:08:55 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:55 -0700 (PDT)
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
Subject: [PATCH v2 15/69] mm/hugetlb_vmemmap: Move bootmem HVO setup to early init
Date: Wed, 13 May 2026 21:04:43 +0800
Message-ID: <20260513130542.35604-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f494x7h51c5uxhyrnopyseqk686oybzy
X-Rspam-User: 
X-Rspamd-Queue-Id: BC744C0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778677736-627686
X-HE-Meta: U2FsdGVkX195kj+8ICNX3GJw2914SBxnOOCC91gVv1aENgLFPUGTclje8HU7n8FYanNtYLQe+l0P+JoiGdKcuXileJvjugg7EMb1eDmY2VAobgmBcUpLTq3mMPn5rEG+Ro01V+aziJ+tgjn7FpEA0FoLVtLFGCzcLjG1Haxt/oVaZOwJg0/og9FgBsQZEs56wGFsGI7b7jWB+qLdm+OdtsefVm6zECXNMPdu8lhCIYsqWArPp/IQnCUPJ6Goy9JJDKyG7sa1WjObMq2+vTVlaUvvfU4zkQCbhxgWOcZdAytKxTq5oSDKH6+HJqO1cr/koVCaVZ5OPqrqiBA79JNUztWuOXowWvfWCZdmEVXpqoHQ5lb4Dob/d0RGdJ9o7sKFK5SfUlstnhZHeESrtHRBdmRStskDxQolSKN+CdaIpJWGJIfd31xy6j8EnCxGe+kKuSvwuw9i3yOy8heSI6B0zqHfxv1l6Cc3XdCAmxQuZ/Q1ZL/twRpTcFHPDF+MNnlX6OVq2GwooHiSZeBeljvco/lx19ApktN8Cm/NXws1Yri6nXopqx+jY8vuzHZGeAGPaOygOT4XuI+DQW6gMyZ6RbpnE7yx3/CVyLvPjKOfWfKdUUgeinyq32kb1W2M6cG1hgFEkYpnfPUl1ZXJTYwVI24iN+VjdVbCNLUysnR9BbFq4zMBaPGqX66VRxHc4ZvqwLyKXpacc0U4v0Xj5DRf3Ddwb/jWvzFtJMJsKkcpcYiRUa0lgxGvd22uAjUnC0IbRMdfaJHmagXEslgIBv5PeCFKF2zhdtqGiANC5QhnmtLyKnx98uSfhw0MVNsORCve0L3XTvCKlU64zjp07ndh13QGICrCrEMannvY+uvmT2lIQKb2rCugICZOmzjN/Esa7QhNfy9QXm1d7qW8HbRxSgjIjdqoaxzyK9lLmYp71kh4Funxm9o1Z5kjXVOvJMo0p8dJFeaUBVGfbq+Waeu
 MdYkW9dZ
 G39mEz2Cbf72ykPGPYZOGd/fvaOJ0eCnv1m+/qCUl7/Fg0NgTGZmG4RO+SH8HLCtMKi+FBdaNBhDQRbQpXuVwEUx02PNKSMMOySxA6jennYyIYrzAu55oBZ9XSVjhWxU/JvEfjtKZRtMERw7m2IGz8P+QrkkTRADIXdp5u5k3rnZUE1GHtRmg6clW9HdGZOFyrBQwJ/8UTlVoB/stJVtLkNvrgTAP/lxbFh5p+gks2aMa8TboOUW6+wE3YskI6z5v5Bv6ie/lSlIDFSgEJb+BIi/gz8VLAQmvjOU10653/sXRqIXezouzZUSaQC478kh2JtCj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bootmem HugeTLB pages currently defer HVO setup to
hugetlb_vmemmap_init_late(), because the optimization needs zone
information.

Now that zone initialization is available earlier, the bootmem HVO setup
can be done directly from hugetlb_vmemmap_init_early(). This lets
gigantic HugeTLB pages apply HVO as soon as they are allocated.

Bootmem gigantic pages that span multiple zones are now filtered out
when they are allocated, so the remaining bootmem gigantic pages seen by
later hugetlb initialization are already zone-valid. As a result,
hugetlb_vmemmap_init_late() no longer needs to handle bootmem HVO setup.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 67 +++++++++-----------------------------------
 1 file changed, 13 insertions(+), 54 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4f58cd940f61..e2251bc47444 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -745,6 +745,8 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 	return true;
 }
 
+static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn);
+
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
@@ -752,6 +754,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
+	unsigned long start, end;
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
@@ -761,6 +764,8 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	section_size = (1UL << PA_SECTION_SHIFT);
 
 	list_for_each_entry(m, &huge_boot_pages[nid], list) {
+		struct zone *zone;
+
 		if (!vmemmap_should_optimize_bootmem_page(m))
 			continue;
 
@@ -769,6 +774,14 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		paddr = virt_to_phys(m);
 		pfn = PHYS_PFN(paddr);
 		map = pfn_to_page(pfn);
+		start = (unsigned long)map;
+		end = start + hugetlb_vmemmap_size(m->hstate);
+		zone = pfn_to_zone(nid, pfn);
+
+		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
+					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
+			panic("Failed to allocate memmap for HugeTLB page\n");
+		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -800,60 +813,6 @@ static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
 
 void __init hugetlb_vmemmap_init_late(int nid)
 {
-	struct huge_bootmem_page *m, *tm;
-	unsigned long phys, nr_pages, start, end;
-	unsigned long pfn, nr_mmap;
-	struct zone *zone = NULL;
-	struct hstate *h;
-	void *map;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return;
-
-	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
-		if (!(m->flags & HUGE_BOOTMEM_HVO))
-			continue;
-
-		phys = virt_to_phys(m);
-		h = m->hstate;
-		pfn = PHYS_PFN(phys);
-		nr_pages = pages_per_huge_page(h);
-		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + nr_pages * sizeof(struct page);
-
-		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
-			/*
-			 * Oops, the hugetlb page spans multiple zones.
-			 * Remove it from the list, and populate it normally.
-			 */
-			list_del(&m->list);
-
-			vmemmap_populate(start, end, nid, NULL);
-			nr_mmap = end - start;
-			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-
-			memblock_phys_free(phys, huge_page_size(h));
-			continue;
-		}
-
-		if (!zone || !zone_spans_pfn(zone, pfn))
-			zone = pfn_to_zone(nid, pfn);
-		if (WARN_ON_ONCE(!zone))
-			continue;
-
-		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
-					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
-			/* Fallback if HVO population fails */
-			vmemmap_populate(start, end, nid, NULL);
-			nr_mmap = end - start;
-		} else {
-			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
-		}
-
-		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-	}
 }
 #endif
 
-- 
2.54.0


