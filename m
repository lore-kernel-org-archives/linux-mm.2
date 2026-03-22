Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90814FC72AD
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 14:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973E16B00AE; Sun, 22 Mar 2026 10:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9246A6B00AF; Sun, 22 Mar 2026 10:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8139A6B00B0; Sun, 22 Mar 2026 10:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 69B266B00AE
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:31:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFC65160853
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:31:53 +0000 (UTC)
X-FDA: 84573938106.17.B67797B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5D6DA120014
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:31:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcPDyHkD;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774189912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V+dtYXmcH9D5ngMkahBxdSpPD48WPN/hf4nP6IhGVhM=;
	b=aWtOU17oL/mx1qmvrhl0DdUZTA3Ca2tk/xgSf++5kXvPKqxsFtzTwsWPV5HPzvkQ2WEpa1
	qYTgFrD199qHValiFHW3lEM1g86jzyjhBih6zOkogPyQ411hdp83VUSfnpGpVRr1x7JcCz
	y1kz3jrmQ6rQOg5KhPePSRy4h1npaYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774189912; a=rsa-sha256;
	cv=none;
	b=Q7KAr6TDz0dDvrklZP6s9PXfjGyBqk1ZUPp7e2Z9ivlkit8hy6139nwp211Vv+zFOLYby9
	cpaEM0Mka6COYcvkWN+hjjRt+2etmYWkQ3YinsKAGZ17PY8TbpvJv57DW/4QUnRx0PNt/+
	MkE3Yfy0u0pr0rSU0xEHEPt+OP/GJ+g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcPDyHkD;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3456B43BD5;
	Sun, 22 Mar 2026 14:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAE9C19424;
	Sun, 22 Mar 2026 14:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774189911;
	bh=+zLkfkhHTIURShydDGMQxTBPdh3Z1+edycqFZOyh5+k=;
	h=From:To:Cc:Subject:Date:From;
	b=dcPDyHkDbMPEvvt3kMwYrXryGs/NHlDHwTR82g6dyqo9GlBGP+EPByDifj1SzSpTZ
	 a/7R3JiYm/4sol4rEgEPSx7HvVNCvHal2xLQnvZzcgwsFnBMZVJMEcNUSTimXdl+sP
	 hHAhAQkggp3hWaM0cMB7BjABxaVPyj4tZhldHMY281apzcXUDW4HKWEI4U9SPbeQhJ
	 JMKJ9aLh6rMO3MxBA6XdcQ82N+ytlF9iNmO9DANlU/VPU+N9SN1F0TSfwDa+PX26g5
	 cDQKtroxMySBTinwV8JQO+wt5hyCrZPpgR+lFEGpB+aygylBz5N66POy2hu8QlA1W7
	 RXRKRKrDqLqgA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] memblock: move reserve_bootmem_range() to memblock.c and make it static
Date: Sun, 22 Mar 2026 16:31:44 +0200
Message-ID: <20260322143144.3540679-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D6DA120014
X-Stat-Signature: aujgdwmc45i3p3zdy47fci6tk9xypkpj
X-HE-Tag: 1774189912-932968
X-HE-Meta: U2FsdGVkX1+XH7g7LPJZ0jls8KkpU+pB+H8VrM3TritnGl51KFshgqqqF0Q2h7xp0e2sUb+JlUmup5OlFvEKgWI8Q50lz3DezTc9czAX1oBC/RnbtuRFxeV6U6UaXmVq3PHZcTETeaeSlat5DU+2F2wCh/Azc4NRA1O3ou0KWgqpXe7cj5XzBKneEHN/NYFjfc82QcmkL+8dqFuaP6EeyVQW09Of3f56edAO5gCROTLXoRg4spF26NPXobzXRhaDgQmwtAgsEdPETXNINimCHGbNYnmH9NYaIOiwZO0pBPcSBphKyGD2ixlRNBB8lWISSfR0XMcz+QPlj+ZiezznQIx5J71+a3DQ/QUfUYbC4DHSUv36umBEhPFNhArnWJ3pVZLY920drjJrm4me42PQm4lysWFdAQKtDTaemgtNNDJHBYgaWHQoVzm7DQ5Hn4p6d1wDgh3KBeNOsXiYhkq78pJno8fBP6TwRGzkMaCJcfdXDlaujUSjX/Cu8HwYtKtEyqK7bdO8pyt+2pB8ixM/c+vvN31eYjOpzNKvZ6gz5WegIRnJYlUQoZj+bPgb217Azuu/ZnnRyNVKYCROMxJK9qBjH7fMS07kI20mg37Gg/qgKvDTr8AZdh4Da8XdV+VNDO4ysJmUBOhcF9nrW7K1oURauyRahO88DiBHtGjpVUGNtbD0ajUf2WaYzpjry+l1KE1O8stjpR2TCtIemVKfH/WCkn3HCpi3kx0lgH8EE7g/NPHKjMUWnbBAckeaBVu5BFXgaiVvS9X5+nRi2Tsf1G0thASMVp9/mmCVykqUYay3lzecJoIaRKZX7VImc4pNv1vvZy7BhHhx/6yjFo8tOSgJ8/Idjb2NyULrdCEMxF0cuiWEBRqStUR77GLl7f6A6SqTmgBR3PJ2eRIRDnY+xyVxBRg3OKrFPjzjyyqCSzLrvFf2avKJHdi9KQI4/hVA49Y685F/IeyeF2MfACT
 62/M7pvC
 fND+NQDNJRkPdlKYfZij3Vq+QQ/PuWWJq/0eBfr1mRFMJz5T/mDaz9ipthafzLVIXjjIofarql3MIrrCeHC9B5An4PrbAwQNdeuSCZTKaFSuaYgbVFiqFbQbgZivF34Jnmh9i/kmT6GYXjvhGQpCNDacs2xp0ZvqPJ2FZ0xzDUiQ7pOuyUXZZNhJrZogc5x6CoZ+nSMMvr53reazQZZIv6YpI3UQpXyl15dS2v6ksNT418iOx0cWG1QLezLWTB/tVOiCJH76Pu1KFWofRgAc1EIguqokLN+sIrgU4iiEZy3CxmocD/XQNTXtN13E/L/dMjn6F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

reserve_bootmem_range() is only called from memmap_init_reserved_pages()
and it was in mm/mm_init.c because of its dependecies on static
init_deferred_pages().

Since init_deferred_pages() is not static anymore, move
reserve_bootmem_range(), rename it to memmap_init_reserved_range() and
make it static.

Update the comment describing it to better reflect what the function
does and drop bogus comment about reserved pages in free_bootmem_page().

Update memblock test stubs to reflect the core changes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/bootmem_info.h      |  4 ----
 include/linux/mm.h                |  3 ---
 mm/memblock.c                     | 29 +++++++++++++++++++++++++++--
 mm/mm_init.c                      | 25 -------------------------
 tools/include/linux/mm.h          |  2 --
 tools/testing/memblock/internal.h |  9 +++++++++
 tools/testing/memblock/mmzone.c   |  4 ----
 7 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
index 4c506e76a808..492ceeb1cdf8 100644
--- a/include/linux/bootmem_info.h
+++ b/include/linux/bootmem_info.h
@@ -44,10 +44,6 @@ static inline void free_bootmem_page(struct page *page)
 {
 	enum bootmem_type type = bootmem_type(page);
 
-	/*
-	 * The reserve_bootmem_region sets the reserved flag on bootmem
-	 * pages.
-	 */
 	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
 
 	if (type == SECTION_INFO || type == MIX_SECTION_INFO)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 70747b53c7da..51af53dfe884 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3737,9 +3737,6 @@ extern unsigned long free_reserved_area(void *start, void *end,
 
 extern void adjust_managed_page_count(struct page *page, long count);
 
-extern void reserve_bootmem_region(phys_addr_t start,
-				   phys_addr_t end, int nid);
-
 /* Free the reserved page into the buddy system, so it gets managed. */
 void free_reserved_page(struct page *page);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..17aa8661b84d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2240,6 +2240,31 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
 	return end_pfn - start_pfn;
 }
 
+/*
+ * Initialised pages do not have PageReserved set. This function is called
+ * for each reserved range and marks the pages PageReserved.
+ * When deferred initialization of struct pages is enabled it also ensures
+ * that struct pages are properly initialised.
+ */
+static void __init memmap_init_reserved_range(phys_addr_t start,
+					      phys_addr_t end, int nid)
+{
+	unsigned long pfn;
+
+	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
+		struct page *page = pfn_to_page(pfn);
+
+		init_deferred_page(pfn, nid);
+
+		/*
+		 * no need for atomic set_bit because the struct
+		 * page is not visible yet so nobody should
+		 * access it yet.
+		 */
+		__SetPageReserved(page);
+	}
+}
+
 static void __init memmap_init_reserved_pages(void)
 {
 	struct memblock_region *region;
@@ -2259,7 +2284,7 @@ static void __init memmap_init_reserved_pages(void)
 		end = start + region->size;
 
 		if (memblock_is_nomap(region))
-			reserve_bootmem_region(start, end, nid);
+			memmap_init_reserved_range(start, end, nid);
 
 		memblock_set_node(start, region->size, &memblock.reserved, nid);
 	}
@@ -2284,7 +2309,7 @@ static void __init memmap_init_reserved_pages(void)
 			if (!numa_valid_node(nid))
 				nid = early_pfn_to_nid(PFN_DOWN(start));
 
-			reserve_bootmem_region(start, end, nid);
+			memmap_init_reserved_range(start, end, nid);
 		}
 	}
 }
diff --git a/mm/mm_init.c b/mm/mm_init.c
index cec7bb758bdd..96ae6024a75f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -784,31 +784,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
 	__init_deferred_page(pfn, nid);
 }
 
-/*
- * Initialised pages do not have PageReserved set. This function is
- * called for each range allocated by the bootmem allocator and
- * marks the pages PageReserved. The remaining valid pages are later
- * sent to the buddy page allocator.
- */
-void __meminit reserve_bootmem_region(phys_addr_t start,
-				      phys_addr_t end, int nid)
-{
-	unsigned long pfn;
-
-	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
-		struct page *page = pfn_to_page(pfn);
-
-		__init_deferred_page(pfn, nid);
-
-		/*
-		 * no need for atomic set_bit because the struct
-		 * page is not visible yet so nobody should
-		 * access it yet.
-		 */
-		__SetPageReserved(page);
-	}
-}
-
 /* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
 static bool __meminit
 overlap_memmap_init(unsigned long zone, unsigned long *pfn)
diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 028f3faf46e7..74cbd51dbea2 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -32,8 +32,6 @@ static inline phys_addr_t virt_to_phys(volatile void *address)
 	return (phys_addr_t)address;
 }
 
-void reserve_bootmem_region(phys_addr_t start, phys_addr_t end, int nid);
-
 static inline void totalram_pages_inc(void)
 {
 }
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index 009b97bbdd22..eb02d5771f4c 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -29,4 +29,13 @@ static inline unsigned long free_reserved_area(void *start, void *end,
 	return 0;
 }
 
+#define for_each_valid_pfn(pfn, start_pfn, end_pfn)                     \
+       for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
+
+static inline void init_deferred_page(unsigned long pfn, int nid)
+{
+}
+
+#define __SetPageReserved(p)	((void)(p))
+
 #endif
diff --git a/tools/testing/memblock/mmzone.c b/tools/testing/memblock/mmzone.c
index d3d58851864e..e719450f81cb 100644
--- a/tools/testing/memblock/mmzone.c
+++ b/tools/testing/memblock/mmzone.c
@@ -11,10 +11,6 @@ struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
 	return NULL;
 }
 
-void reserve_bootmem_region(phys_addr_t start, phys_addr_t end, int nid)
-{
-}
-
 void atomic_long_set(atomic_long_t *v, long i)
 {
 }
-- 
2.53.0


