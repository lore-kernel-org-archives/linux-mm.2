Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6DB1099B47
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FF36B00EE; Fri, 20 Mar 2026 18:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0E06B00EF; Fri, 20 Mar 2026 18:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113826B00F3; Fri, 20 Mar 2026 18:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00B156B00EE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2B2E8B5AA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:28 +0000 (UTC)
X-FDA: 84567846216.12.229CC6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9956B8000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g5I2WfVK;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEjmYE+21W+SRdq632hEDb/I5TtGrud8uEWeUGvR3lk=;
	b=DH0vnPOv6zgFvQrf9PWJD7xvQnnhPZ91EKZ72An8H4WZKrnGTL9uI+KzJaOyRypFgEii+b
	oFs9cyMCKHpPYcH4eOJpf7R7MKwFCrfs0NnnRiqgkiPYEIIdslEAn3DhsdNsGdkirlWy3c
	U/HrmOPFN832NyxaMI+aWNWXvqdgshU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044866; a=rsa-sha256;
	cv=none;
	b=sZzqIuwUA9O+gwLrKy1ErmO/aAncmPW8U+dNxz+ijgnG0cNryR1CaEEWplgAF1QyQd0z8R
	p7HIyC8oE+wHRFl57//sDPXqJ/+HRWWz5vpmOqy6YjKPee5wCSPuE0Ut4ow6cJWQvli6i7
	/ldq4Y5Q0aTanqM6vG1TgF8CbbClWIY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g5I2WfVK;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24DF660142;
	Fri, 20 Mar 2026 22:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A917C2BC9E;
	Fri, 20 Mar 2026 22:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044865;
	bh=GbRJKi/UL19LjXb/zj2tspEF8IAz0ieC/2fklwT44sM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g5I2WfVK3kWIJW4Y7drVtMvENCcnoLxj1B0PMuN70dK6hIX0GLgNOQLITSZrmehJu
	 eKLUowungftOUVOX4vo8v+M+qb4q74EIXld1PkuprCqDmAoednhpf2FjVWqYA8Sec0
	 64rQUWNlzhXHAAPTdNOSjB4TlKctYxJ1WeIgEpcmZRwNC1Wu0MiEEwaMnUgaZyIw2y
	 X7vltLf2qCsp/TOD5FRvRm9LJ59Jqnyi5VLa6mP2STHCoAARya4QfoZjTaLjndiZCC
	 9Z/btgNOBl5E9pR6v53StvvyO5c9y9Vge+kRCJmVqoP6AQfAtr8PnMK80mlX42rC83
	 IC4qzcyUWrMvA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:42 +0100
Subject: [PATCH v2 10/15] mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific
 usemap allocation handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-10-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: 7tnni98ppin65kegwwmmmbgjag8zzfhh
X-Rspam-User: 
X-Rspamd-Queue-Id: 9956B8000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1774044866-131904
X-HE-Meta: U2FsdGVkX1/dXv/+I7++IBr+0SOdRCQ5dHWus92s0cuu/YWIqrvtauB4XQIXdg1jZfku0UUcNFWNPOTjpHxTFBESZ4cE9Ak94EEDMvSFsBUNeyxbGkV+VFQW5QaRwhPtPyGnOiMxGieXs9CZxBwveC3rCYGgZqOZFlAWMOIrha4hgKDeGiltoLePkGzQ5vsKAVIzKUYq3KUeyqSdp1H9ompVSGvxmWYZqMDZd0Objq6jno355+yot9eoj55VnRlkYDxQ45UASIRg8dEzgSZuV1YVbvGXGsHfxkyT/tqNd7Ko/Lw0FB2BXdI0K6gWPzR+M7JbuoY3jtNEjAL7b5Obm4xGCq28xk81ZYRWvmuzw1gKqTE3ZxMCrwYQ3q/kREzoxFUxVuUe9L4kI6k0Ddt9a1sudX9opsWOPzQjKQK/+LW0D9O3aTiiNsYTzc6x7ePkQK1FEnSM+H463Kg7DgRaxCkZESHCdIDQQOcLziDRaOt5T7Hq8euO2vafeRIoQm+hiPVT8/U9RwWx6zlAJrBynlrvAWCcmiuPifPVO0PUH0B1N7unsU55XRISAeKZk7Qoso1pjzt0S19fv3xD49wDfowhX1BLjOuQGT7QoR1nJhZzT6EA/1flrsQlyYdZvGEuYxQALtOBqeaiHsBV6ZP3vK+Z4ON1krlNIhknR8XoUE0tum/NeN7A7h6eT6TjT1AUh2MnvH9Z/IncPwikqa+RwX1Jq8zhYgNefWXv+mITWpZHDLBe7qeczNEXy6fnqmrBysH/qLBqiZHPUDafjmFkBODFMUXyCoTW8rfze8QTDpWpDSTAerxf2UAJ7YWp8xyU+YNrlBzfCH3UlXZkEBjBeHwPCWCM0TV4q/2JEjegwMGiAixIrnTm0uJ+V4tYOgIwXIHtovn4mIz15wsqpz4f/eS/ghbPuLqa8E2/Vjg7OlAs8C7obDM0IqcWgTipE/j6ykU1gYccD0dulpLtSbj
 qJA2I6sl
 wladrGZJc56lquqIqjV9OQzgdTgsF8qVJzSPdk/HQsT1kLaWU9BuB1/RCXKrLoDf7PJl7+fDyrjLAz416Y2zWDB4idy1h2w0sw0Kp4Uaj9d9ulU4DeuPXeMqWa0N+UKmFyfb69s/n+Qf7DrtXYOQxLGKpubR6S2bVNP7tOBHZFzuz2UUEefdfscHbtU0BDpAIdBfS0t3k/n97sfkuRHXK5QhSSuO0MA/v3NK7kp6lzpba6rJC6Y8olM8+yX9cGaRuCVeVh+O8CGIImtDDnn6Kn1sTSSIRuSJx7MZO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In 2008, we added through commit 48c906823f39 ("memory hotplug: allocate
usemap on the section with pgdat") quite some complexity to try
allocating memory for the "usemap" (storing pageblock information
per memory section) for a memory section close to the memory of the
"pgdat" of the node.

The goal was to make memory hotunplug of boot memory more likely to
succeed. That commit also added some checks for circular dependencies
between two memory sections, whereby two memory sections would contain
each others usemap, turning both boot memory sections un-removable.

However, in 2010, commit a4322e1bad91 ("sparsemem: Put usemap for one node
together") started allocating the usemap for multiple memory
sections on the same node in one chunk, effectively grouping all usemap
allocations of the same node in a single memblock allocation.

We don't really give guarantees about memory hotunplug of boot memory, and
with the change in 2010, it is impossible in practice to get any circular
dependencies.

So let's simply remove this complexity.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 100 +-----------------------------------------------------------
 1 file changed, 1 insertion(+), 99 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index b5825c9ee2f2..e2048b1fbf5f 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -294,102 +294,6 @@ size_t mem_section_usage_size(void)
 	return sizeof(struct mem_section_usage) + usemap_size();
 }
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
-static inline phys_addr_t pgdat_to_phys(struct pglist_data *pgdat)
-{
-#ifndef CONFIG_NUMA
-	VM_BUG_ON(pgdat != &contig_page_data);
-	return __pa_symbol(&contig_page_data);
-#else
-	return __pa(pgdat);
-#endif
-}
-
-static struct mem_section_usage * __init
-sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
-					 unsigned long size)
-{
-	struct mem_section_usage *usage;
-	unsigned long goal, limit;
-	int nid;
-	/*
-	 * A page may contain usemaps for other sections preventing the
-	 * page being freed and making a section unremovable while
-	 * other sections referencing the usemap remain active. Similarly,
-	 * a pgdat can prevent a section being removed. If section A
-	 * contains a pgdat and section B contains the usemap, both
-	 * sections become inter-dependent. This allocates usemaps
-	 * from the same section as the pgdat where possible to avoid
-	 * this problem.
-	 */
-	goal = pgdat_to_phys(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
-	limit = goal + (1UL << PA_SECTION_SHIFT);
-	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
-again:
-	usage = memblock_alloc_try_nid(size, SMP_CACHE_BYTES, goal, limit, nid);
-	if (!usage && limit) {
-		limit = MEMBLOCK_ALLOC_ACCESSIBLE;
-		goto again;
-	}
-	return usage;
-}
-
-static void __init check_usemap_section_nr(int nid,
-		struct mem_section_usage *usage)
-{
-	unsigned long usemap_snr, pgdat_snr;
-	static unsigned long old_usemap_snr;
-	static unsigned long old_pgdat_snr;
-	struct pglist_data *pgdat = NODE_DATA(nid);
-	int usemap_nid;
-
-	/* First call */
-	if (!old_usemap_snr) {
-		old_usemap_snr = NR_MEM_SECTIONS;
-		old_pgdat_snr = NR_MEM_SECTIONS;
-	}
-
-	usemap_snr = pfn_to_section_nr(__pa(usage) >> PAGE_SHIFT);
-	pgdat_snr = pfn_to_section_nr(pgdat_to_phys(pgdat) >> PAGE_SHIFT);
-	if (usemap_snr == pgdat_snr)
-		return;
-
-	if (old_usemap_snr == usemap_snr && old_pgdat_snr == pgdat_snr)
-		/* skip redundant message */
-		return;
-
-	old_usemap_snr = usemap_snr;
-	old_pgdat_snr = pgdat_snr;
-
-	usemap_nid = sparse_early_nid(__nr_to_section(usemap_snr));
-	if (usemap_nid != nid) {
-		pr_info("node %d must be removed before remove section %ld\n",
-			nid, usemap_snr);
-		return;
-	}
-	/*
-	 * There is a circular dependency.
-	 * Some platforms allow un-removable section because they will just
-	 * gather other removable sections for dynamic partitioning.
-	 * Just notify un-removable section's number here.
-	 */
-	pr_info("Section %ld and %ld (node %d) have a circular dependency on usemap and pgdat allocations\n",
-		usemap_snr, pgdat_snr, nid);
-}
-#else
-static struct mem_section_usage * __init
-sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
-					 unsigned long size)
-{
-	return memblock_alloc_node(size, SMP_CACHE_BYTES, pgdat->node_id);
-}
-
-static void __init check_usemap_section_nr(int nid,
-		struct mem_section_usage *usage)
-{
-}
-#endif /* CONFIG_MEMORY_HOTREMOVE */
-
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 unsigned long __init section_map_size(void)
 {
@@ -486,7 +390,6 @@ void __init sparse_init_early_section(int nid, struct page *map,
 				      unsigned long pnum, unsigned long flags)
 {
 	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	check_usemap_section_nr(nid, sparse_usagebuf);
 	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
 			sparse_usagebuf, SECTION_IS_EARLY | flags);
 	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
@@ -497,8 +400,7 @@ static int __init sparse_usage_init(int nid, unsigned long map_count)
 	unsigned long size;
 
 	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = sparse_early_usemaps_alloc_pgdat_section(
-				NODE_DATA(nid), size);
+	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
 	if (!sparse_usagebuf) {
 		sparse_usagebuf_end = NULL;
 		return -ENOMEM;

-- 
2.43.0


