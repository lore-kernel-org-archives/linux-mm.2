Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BB6CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826E36B0095; Sat, 10 Oct 2026 03:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE326B0096; Sat, 10 Oct 2026 03:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D346B0098; Sat, 10 Oct 2026 03:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39A916B0095
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:58:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B96978064D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:58:44 +0000 (UTC)
X-FDA: 85305964968.04.2EF644A
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 51EF6120004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:58:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DmmlKwGx;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791619123;
	b=qU+69EmkEpmPLQjkU44cGmXHNiTqgHWPUXB7NWNcXu6c72AKE86VaCJZiR8yZw+qKGelro
	Lh/dnzPC6CZfPkvfyurFncYQnsXniRaZTapGrqA2j+i2ab2ysR9KBaqdW2N9SFbzU/DUR+
	Vzb1iLVySQaD2sH8kTfHtW+j8cavJuY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DmmlKwGx;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791619123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ma837HBXIsXlkZZedCno7jR/Be5/TxFOjn4ZcgPZXQ8=;
	b=MKVQy/OpkDD8mRth61Ul5TDChdlbmfzrg1aI1Aa+NIOciKRzZcLPUfCFzSB7y4GrOC7CtM
	e3CZFaacjhcqNdekk4AHL+jsCMoHoTIcuzTT8tfzULC+PomPxgShjTnw067F/MKY4mNOdp
	9F+OGbPifI1jR95tl632HOz6t5drocw=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ab066bef7dso179475a91.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791619121; x=1792223921; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ma837HBXIsXlkZZedCno7jR/Be5/TxFOjn4ZcgPZXQ8=;
        b=DmmlKwGxePQc11qs/uXsm3WF/VxRzyL1J3UtfzM1o/a9xPL1dq4itxg0CiAUarQkw2
         VWSkL6ONoHhbIT5h+7/8jipDjw5KL5UdVeP39D8WkDYopJSGDtULGYj97+v1ut2SNkjL
         +ELdr9LCIycg1W+lXVhZd5+XYqWIG+s2kUgZoDNliuCBCjUbRgflltvHrHhzuMbc1lds
         MojQPxA7ytxtXsVG+cb6mtszZ3B09JHRyP4IRTUSprd62grZOWneQYuXB+xB2u3KjlV7
         pK+W90WtuEFtQIqkZvuBPzB2NbPgLjaCOSr5JmcOITv27uPwszOzVT0ebycKBJ7YJums
         0Dsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791619121; x=1792223921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ma837HBXIsXlkZZedCno7jR/Be5/TxFOjn4ZcgPZXQ8=;
        b=tyt1ljQcDb+wV2M+LfALO5YbUTWpUHmcQt5PJ81i33BmiUqN2OFRHrCBQaf90rPNmb
         y8ulDehdLRBBSdu+UFopgYD3peqKayxTK4t0QYVGawOt1ARCkK1w0k22AJEuDBvcgKqO
         HAPMgy86UBtNXKNKOEBba6XW1zdDylYa2ZJaImu5+9wfzIcYLnYtMrTthyHNd0Zy115O
         wgyPLXq7LKdudQfVS67p7zZY3mG4oOJ4niCdYkIHtcBBPuZ+YbaTczKFUaka1CPvRGZs
         upiXHIHm3eEtekW9OIPQTrYOFLsoyXj8Byhm+AS0R3LbFe3M6O9AnB7pm/jbSY//3hwL
         SCrw==
X-Forwarded-Encrypted: i=1; AKwUvByNNL5cXmiCPUpR/QYk/UI+KhMVHQW3EtsSA8xLo4tuvArT//n82UfeAFCz7WG3HWczaSYjsr/CnA==@kvack.org
X-Gm-Message-State: AFq9FYIExDwQluPQjFGI7WAyWsP70kn+oMF59XDJnZxd0udLhULuaq91
	Fmp86uTsfrAFdpdhVr0asCMEVXsM9cruptGZowd44CHOEH4EJauylB9XGfCSOZKo7TA=
X-Gm-Gg: AYBFou0eDSQvmVSIEOVWjcAGsXBI6nsJaEwsqcELkjFZ7qGDciB0pku/iEeRnIh0GUY
	sSTd+lvLYGt6v4+xuTEbT50sRGwCz/v2KSMWqkLUN3NWtcOgaDlJeWel6u0IEF2NQv810jdfPFy
	v0Wj9+VGKa/0HiiNS3ELRf/XScQ0xHorASNZf7zw3SCl1tBp49em56ttzdBa3bKwAt2v556sw6B
	ElDTkgobucmZPTxJqvkfs9zvOqvzyW0Kb66lEGQpXR1xyDo8iN/3lXA8/Nm5+R6iFya/p8DASpH
	hlSlUsKmNG3jMIvow84KsH3vuDr9nia8HbS9O/FICwKiWaf31uj6faS5u00EiB8GVsddbVqJMYa
	X8NlboPs0NjIugnwfy7AJ9jSdYT6aTVJtJuF+lfTjSrZf7k5OoGscCpa/8+eZCu55hNeWXOfpZ1
	qmuJtPRLcBtz7j3Cxb8OH34927TEPvFi1E9NyWzenrmg4302QFT2YTuv6pNDs0I5BL40hL2kaoq
	wESB0YJEYe2cCC87d8fRff4rmKEedy7eqyWO3mFRtdEks6/HA==
X-Received: by 2002:a17:90b:1d4f:b0:3a4:fe48:d410 with SMTP id 98e67ed59e1d1-3ab3a954001mr3617692a91.30.1791619121000;
        Sat, 10 Oct 2026 00:58:41 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab57c05724sm3473569a91.4.2026.10.10.00.58.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:58:40 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v4 2/6] mm/sparse-vmemmap: support device DAX in common vmemmap path
Date: Sat, 10 Oct 2026 15:57:51 +0800
Message-ID: <20261010075755.83339-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010075755.83339-1-songmuchun@bytedance.com>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 51EF6120004
X-Stat-Signature: 4excz3t5s7kdea46djxfaojhrjqf97fc
X-HE-Tag: 1791619122-954818
X-HE-Meta: U2FsdGVkX1+wRVZXybnbHbfvm3m2JuA7dQBPF3GFDxVGojW+XapSWW4lNvcwuvOnJ+zxMd3opD3nLk5Fgn5EczDLmH/NRr8QMTa2uOFd22xdv/ymfs8fMQ3bqRhQDMV7XT7G7ggri24xfXUNnJnYCcK+ariaPIGHzh3GZQtHs1BFOgmWYX9weMkKlJC1kkA8tgXAGh+cBWUzkFoV3A3b4o2nZhK7LPvoWmSgkpD2CdjZGhc94IKNkdeYSmuu8Az1/0pFDmr2WjUgUI18J6h1/9R5GMWnlBtR2VK2oWIVqFm9zyIMt9nNvshIdMMMaFdM6E7rgMxhbx7vVOdSWBB1Nq+Zmi11rNdRjWrTHrhD/lYQ9MyQk5f0mi8SMQPqAzfEIvVPtyJOHHJQNf5FHpWqA9/P8TIzic9r6wB1H+V0KndJ7qY1dKdror78Oaf0mwMj4Tz53dZAcW4u1u5zfRGWVuCh/si4K+KqNe/vMPAqDafQNoNUoVpGYc/i1HfKrX7ZNBHvszdNh3DmK05hwQ5g6YCU0kgED6Ga0dUHiUhUggj3OwogsFN7bCph1Md/gkMcZ/T4qmQ/qbtaDXQkXLlzVYN/vE1gJDTt56h/e+UyFpPgkbIRYPoOYbGAowGp12EzbskOnUY8czaAaD7RA6ksnSoG/zx1jG4h3GQNMHA98xnR2FS2uZnBXuWXPt+H6LZLW8TynePoxyJBj4s8MgZkoJpqHEOo/M3qTWj8OmCmASMVzGA1S0IgXINOoiHFfVVhmwXldIa1JA4x5+3pFiDfx+AAP2g+tOxydX3/JhoXqyfxggMoEsgVPaqC8ifliKXnoXEz9djvvXeMZer5m0tSVjPNwAxGp0R3PJ4cigv5cWbHIbtW1KZsNNb/KEb3dqWUYt3HbO+8p59HtdOVjRDqiaQrE5ONKfVWe6g0/8mZISpBv4rXe8ddXsXab3tI7CvB0vXVAD5XOpMb+fyEB2z
 3cIKx++Q
 kMpUN0N3q17++YzE4BpGMtX95ZhNO8+OhOC4djok/0qfD9Fg8LunCQ5R4hXmERU1zk2uQ/VSlX2O3y9yHTdDCgLqSttY7IEmF7eJgYeH1KpV5zqdyvP/nWf0XIJLyYzYc8vATtrsTjeLfDA8f+OSHO4WnMjFCv/aX364FOgRwVni26U+hNhXhyOm8VyLlswbzuQyLYQ/O8xH/7bFW90jbnbulLK2z9M3eFycOfHf+75gohbzO6dZLGaB5pJtXOANOrO+W5JFFMmUEWVerpdDG1GZ95WqAFByCDrwU1lhJTzXb8lAzSjtXbr4MiTC+LtJOmVpEvuwEpzY8br6F2HeXWF28QikZQKwhYnBRk1+RMRpcQPI8ptZYDkkLtDGQy0fTp1Is6oj+I8/0X8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common vmemmap population path cannot yet handle optimized Device DAX
mappings on its own. It uses pfn_to_zone() to find the shared tail page,
but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE span
is initialized.

Teach the common path to use device_zone() for runtime optimized vmemmap
population while retaining pfn_to_zone() for early boot. This allows the
same path to support both early boot mappings and Device DAX.

The backing PFN supplied by the Device DAX-specific population path is no
longer used, allowing the redundant lookup and population code to be
removed later.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v4:
- Collect Reviewed-by from Lance Yang

v3:
- Collect Acked-by from Qi Zheng

v2:
- Expand comments around slab initialization to explain zone lookup and
  page refcounting (suggested by Qi Zheng)
---
 mm/sparse-vmemmap.c | 64 +++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b23efff80137..62327ac15206 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -241,18 +241,43 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	/*
-	 * Device DAX still relies on vmemmap_populate_compound_pages() for
-	 * head/first-tail allocation and tail-page reuse.
-	 */
 	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
-	zone = pfn_to_zone(pfn, node);
+	/*
+	 * Before slab is available, vmemmap optimization is used for early
+	 * system RAM, whose zone can be determined from the PFN.
+	 *
+	 * Once slab is available, only ZONE_DEVICE memory reaches this
+	 * optimized population path. Its zone span has not been initialized
+	 * while its vmemmap is being populated, so pfn_to_zone() cannot be
+	 * used. Obtain ZONE_DEVICE directly from the node instead.
+	 */
+	zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
 	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
+	/*
+	 * During early vmemmap population, the shared tail vmemmap backing
+	 * page is allocated from memblock before its struct page can safely
+	 * participate in page refcounting. Therefore, no reference can be
+	 * held for each shared PTE mapping, and the mappings must be unshared
+	 * before the vmemmap is depopulated.
+	 *
+	 * Once slab is available, the shared backing page is allocated from
+	 * the buddy allocator and can be refcounted. Hold one reference for
+	 * each shared PTE mapping. The architecture vmemmap teardown drops
+	 * the reference through __free_pages() when removing the mapping,
+	 * preventing the backing page from being freed while it is shared.
+	 *
+	 * The backing page may be shared by enough PTE mappings to exhaust
+	 * the positive range of its reference count. Stop populating the
+	 * vmemmap if another reference cannot be acquired.
+	 */
+	if (slab_is_available() && !try_get_page(page))
+		return NULL;
+
 	return page_address(page);
 }
 
@@ -264,31 +289,12 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
+		void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
-		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
-
-			if (!p)
-				return NULL;
-			ptpfn = PHYS_PFN(__pa(p));
-		} else {
-			/*
-			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a free_pages() call to this page allocated
-			 * above. Thus this try_get_page() is paired with the
-			 * put_page_testzero() on the freeing path.
-			 * This can only called by certain ZONE_DEVICE path,
-			 * and through vmemmap_populate_compound_pages() when
-			 * slab is available.
-			 *
-			 * Use try_get_page() to prevent the shared page refcount
-			 * from overflowing.
-			 */
-			if (slab_is_available() &&
-			    !try_get_page(pfn_to_page(ptpfn)))
-				return NULL;
-		}
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
+		if (!p)
+			return NULL;
+
+		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
-- 
2.54.0


