Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E492CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8B46B0096; Wed, 30 Sep 2026 10:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1586B0098; Wed, 30 Sep 2026 10:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F596B0099; Wed, 30 Sep 2026 10:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 389A66B0096
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:07:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C123CA075E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:36 +0000 (UTC)
X-FDA: 85270606512.26.DF9D23B
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id B0A7A100010
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OnCyMptV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYebeXJuBW0flbBBO8JM/NAxNtBzSIotmtzU/jzSaT0=;
	b=gwoxhsiTMlU/iYHpOk8ZOgM31sE/BjMHs+c9KxTw5UPIpMLrvUN1/muBwy/35kAwp/RBfH
	dTXqQVyJJIAxCNaM7mKU1r4snYbSSsdu7NMTa0OVTr4+9Ne7tSaYYSrRx5aK8OXmyyeoI1
	q1wJzWtzWyztAUg2/yI9ul4YN3Tfne8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OnCyMptV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777254;
	b=ShmTsy+sRJlsq7Iko8HGL8g4iDF5tH3csZ8ytZ3OTCBOE9ucAfqTAIZtvHe42Qu+teE5FL
	xJNpEL5uJo/2vTfIOpJ9PKQhnAn4P4eZGYx1zFuCMhHCp6+dcQuWP9xTU0eRuXRUzmIM4E
	QIGlSSZ79P3Ih8ovbSHt26ohbGd6TKI=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4aa0f1766so2939828a12.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777253; x=1791382053; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MYebeXJuBW0flbBBO8JM/NAxNtBzSIotmtzU/jzSaT0=;
        b=OnCyMptVWM7xQdc9uDF5PB6pYrzhkKwXItBFeR6CzgoIACIi2+kEBTmygu3v5uDXOT
         5EVq9/EjJD2N5EfhiGLteopUhzpCwxgv5Tfxd31PXGpWVVmZ/wrDXX1VAhQaYivAGVJj
         SHRYoKAIRAVzZrhdUKKSTwB683IKuJMJ+dMLBNirf3ZaOC17S5yPzN5S77c3agM6R0CU
         mshhxUie7Blo5QRr8zwMAWlH2N2JQG9LqH2xM5VQFPQLncdlYz8VM2R5skdQfXFXvdBc
         fZkr+fyPVV+GuOkZEFNzHZ+ubOpV1KJUf282ZyY/VjmVZelkDUMIcz9ollviY9y+9t+3
         yl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777253; x=1791382053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MYebeXJuBW0flbBBO8JM/NAxNtBzSIotmtzU/jzSaT0=;
        b=o3udFpRD9GjbQsaJm0Fus9N9/Alv34K+QeyraSC8ueVVtQBf7WruADNDAmrd0VnX+c
         wOoQmfri1keqz6XvK+Vsyrit/iULk8VmbxS52IHXAaO8qqHUvpYWoj97SrInFL3xc76U
         Cl4MJa6DiHRuZeWYDm3nx3fbxE5/nm8fOLX4Y7Oqcm7MBqz8v50ti/iT9i28/iGH2QnY
         duHMaP0S5igOZqGrBVjCyBRhz1kbloK8+BFOMNDEdHXvEOQ15n+/RkfKweh6zHjslkKI
         bd96Le0SdMezvfSS1Czf7exvMGE66Y0JdD+xhqhr3x+9zwEJ5QwKWh6Q3H8u/7HVM8Ze
         tilw==
X-Gm-Message-State: AFq9FYLIDLD+h5M6C+DdEOG0SUP7f2QZ17TVxX+tUQ3YLL4iAHAo9vu/
	RizEgt8FgZH2c/jGdF6Q08IwblE/OEXvFF4j2r+VgyMawQZjan+wWe18uWlgupNUivc=
X-Gm-Gg: AYBFou0MB9xqsAUjZZueyGJGydEhxYn97i2+bG4JIBrGHu335kqXZ4dcGOMpx0zkxGn
	MuA8JA14c24axRbd/9q49c2eDAFs4mqnDBfxM2riCP8zJ4orI6QnpoCcZJ89u+sSehU2dNOTsGO
	8/HYROR3COB6I4X7IcAu9VwDia+VaJKWOfoeeczI3DAsbIogNQJYmEn4McUJR9AA2Lg3GRJsT59
	nTM1UlLvlJJqjxirpXKL4L4tDkAmZ9Fwj7Hi7kKWWMO03mgXD9Nd4KdW2pgiqui1cb2m3GV8tBd
	4XJ00ry1/sbvKl43MSqDZXwTV32TxQeZ6SU832DSZsrWbq8zc8L0LLn2tPUcJ6uAI66NuzElOMN
	CqWf9EkqjDLGv91sEJj2dDi1wJfmfJYg60QxNF2oIfkFLIKfRVvEKa575vx00eVbGYlwDsUkLtT
	D/8zCH8wP4Dq8cdSgk9xukBneEe5M6S8/QcvkUGixCQhiIaTc7hDRArTBp3vfGMQYHoJz224TDt
	artANa8p8vB7A==
X-Received: by 2002:a17:90b:134c:b0:39e:6c6a:6580 with SMTP id 98e67ed59e1d1-3a4d199cbd8mr1390228a91.67.1790777253237;
        Wed, 30 Sep 2026 07:07:33 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.07.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:07:31 -0700 (PDT)
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
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 02/12] mm/sparse-vmemmap: allocate shared tail page array dynamically
Date: Wed, 30 Sep 2026 22:06:17 +0800
Message-ID: <20260930140627.57431-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ry99acdyhai1dochisfhdsh3tx88egxx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0A7A100010
X-HE-Tag: 1790777254-414047
X-HE-Meta: U2FsdGVkX1+s6Ub7vTNZCAU0CkfmVjyP+RSnfHX/bCPBNkq+5o0QJxY7Sq4znINAHoXay2nhhD1VFW0jgBjjYiBJ8WlP371uppCNXwtIA1nDHjvymUBSKiGI3kznFprIrs+thlYO8VBS8zFHJgq6PJYerey7pD6DrspbIXT8tAUBcV1ueSYD+YUVH6Q0TEQ94lf2Uzv4d3uGO+inkDxXLrOIBt7Ko7zM9ejZ2kax0mTynHvKR2lZ+uOo6EDbwh0PFzzvu8aM5/ySpkXgmYIiIqiMkLvoYxUc7ppAmQZRywYjv0y1gI8JxCPl8YWRZGFtLCmro6hAFNthPCXLLzL+PyGywpC8F+ETs5zOr+E7qOIGAwTz1BG2MkzfWAc6qWXeWR7PHD8RYDJlsWtLUJpgwvVaNTjn4gTt/AGFkEZP9uco/jYgGzs6wvaWzRH/j99nCS2CVnSDBF/FkZKvero9Rx0NXAucPY+QAiqQXMeL6IxoGr/GVnMv2ixBbgSvHED4b5B6YC9c4LwXdO+9f4zQ9FLvtGgFkjlnEvP4tTY+zMYjO/pP/eqvwP4GQTUwLVRfgNFIS8JZobdY7i3iDAWGv1V29DTOzzzOBiV37RAO8VUen34FXk/o0Qs1R5xyrwnZVwPXpkvrrE6u011bGuHfllxnqUso+hChpcOzReAt+vo1zvS8wCpgKDDXG2pD+n7RwNT2girTRZywvRVEQ7wcSlr7TY5wC7XmlKwTes+htpQOhkSSnafhL0slsGWIynhDazgbaQ7HZbB7lckE9zUknbJtA7CTTaUPjnEmIY9kVJ69Svk6pwd1P28YnMasCNUvQ1vHddqd19WryF4RnK/IvuvAPJr9FAihudMsQtbZ+epPxni5nMneZg78TupPihFQfAanjDhtqTHrcf53SOxPoP6Xqt90veghOyXTAbz9TR/rc3ongDCGp2sV4H00mDi8udUEQ6jvs8ZaNp0SpLg
 0V6lPeGm
 ZQbi/ADy/Q+BcBHET9NDB1CslWOi3m5kyKwGW+VVKl4i5+PaSRoOaOiuvxXpU3ucsFLJrpz1LdBRt6TxtkfPo23pQPpmfVwFcLJW7IdKqmvmoe7LjVC1pUGUtck1Gs6ae/E3Ss7gbHM9yyVlGc/+lrwzX+MCNrEUmdeY9i4WRe6VzQ2RdXksCGgFROqXuUjGSnqbGTmuYO+8zWjoKBAOz8Bj9gyd5u2PkfMAm9MzGoYed/8DOHMRACcNLPbHJgJv0t7BvDpyR08pG3zSkxIsykEH7oc+nNve/L7MUsTJhVlchmxt0tuiKnQdJTD24TEnkfDyGf18gdhSNG+DHjNDmtDXLrRqQfQygnPf7ZM+g0btXVFgbhEq5Jbzd8qClqM05GQCd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") added the
per-zone vmemmap_tails array. Its size depends on MAX_FOLIO_ORDER, which
had been moved to mmzone.h in preparation for the array.

PUD_ORDER is defined by linux/pgtable.h, which cannot be included from
mmzone.h without creating an include cycle. It was therefore open-coded
as PUD_SHIFT - PAGE_SHIFT.

This removed the dependency on PUD_ORDER, but not the underlying
dependency on architecture page-table definitions. PUD_SHIFT is
generally provided by architecture page-table headers, which are not
guaranteed to have been included when mmzone.h is parsed.

The dependency remained hidden because vmemmap_tails was originally
guarded by CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP. Under that condition,
MAX_FOLIO_ORDER resolves to either MAX_PAGE_ORDER or the fixed HugeTLB
limit, rather than the PUD_SHIFT-based definition.

Device DAX, however, does not require CONFIG_HUGETLB_PAGE. When it is
converted to use section-based vmemmap optimization, MAX_FOLIO_ORDER can
resolve to PUD_SHIFT - PAGE_SHIFT while it is being used to size
vmemmap_tails. This would make struct zone depend on architecture
page-table definitions being available when mmzone.h is parsed.

Replace the embedded array with a pointer and allocate it on first use.
This moves the order-count evaluation into sparse-vmemmap.c, after the
architecture page-table definitions are available, and removes the
dependency from mmzone.h.

Removing the compile-time array also removes the original reason for
keeping MAX_FOLIO_ORDER and the vmemmap optimization sizing definitions
in mmzone.h. Follow-up cleanups can place each definition in the header
owned by its respective subsystem.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v6:
- Move the shared tail array lookup into vmemmap_tails() (suggested by
  David Hildenbrand)

v5:
- Add this patch to fix the RISC-V build failure under the configuration
  reported by the kernel test robot
---
 include/linux/mmzone.h |  7 +------
 mm/sparse-vmemmap.c    | 39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index acd94cecc0d3..68807ff7f946 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -113,11 +113,6 @@
 	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
-#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
-	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
-#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
-	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
-
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
@@ -1156,7 +1151,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
+	struct page **vmemmap_tails;
 #endif
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 9af349581fbd..0ace48268095 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -170,16 +170,47 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#define VMEMMAP_OPTIMIZATION_NR_ORDERS	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
+
+static __ref struct page **vmemmap_tails(struct zone *zone)
+{
+	const size_t size = array_size(VMEMMAP_OPTIMIZATION_NR_ORDERS,
+				       sizeof(*zone->vmemmap_tails));
+	struct page **pages = READ_ONCE(zone->vmemmap_tails);
+
+	if (pages)
+		return pages;
+
+	pages = slab_is_available() ? kzalloc_objs(*pages, VMEMMAP_OPTIMIZATION_NR_ORDERS) :
+		memblock_alloc(size, __alignof__(*pages));
+	if (!pages)
+		return NULL;
+
+	if (cmpxchg(&zone->vmemmap_tails, NULL, pages) != NULL) {
+		if (slab_is_available())
+			kfree(pages);
+		else
+			memblock_free(pages, size);
+		pages = READ_ONCE(zone->vmemmap_tails);
+	}
+
+	return pages;
+}
+
 struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
 	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	struct page *page;
+	struct page *page, **pages;
 	void *addr;
 
 	if (WARN_ON_ONCE(idx >= VMEMMAP_OPTIMIZATION_NR_ORDERS))
 		return NULL;
 
-	page = READ_ONCE(zone->vmemmap_tails[idx]);
+	pages = vmemmap_tails(zone);
+	if (!pages)
+		return NULL;
+
+	page = READ_ONCE(pages[idx]);
 	if (page)
 		return page;
 
@@ -194,12 +225,12 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 	}
 
 	page = virt_to_page(addr);
-	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
+	if (cmpxchg(&pages[idx], NULL, page) != NULL) {
 		if (slab_is_available())
 			__free_page(page);
 		else
 			memblock_free(addr, PAGE_SIZE);
-		page = READ_ONCE(zone->vmemmap_tails[idx]);
+		page = READ_ONCE(pages[idx]);
 	}
 
 	return page;
-- 
2.54.0


