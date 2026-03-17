Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55518FED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33806B009B; Tue, 17 Mar 2026 12:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4276B009D; Tue, 17 Mar 2026 12:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2E36B009E; Tue, 17 Mar 2026 12:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916686B009B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 410C113A3E8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:41 +0000 (UTC)
X-FDA: 84556161522.11.B4DB94B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 811E48000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s9R4skG5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bnFTkbUkJYITknDAl6GXVBVIwq+wseFZc2LcFPKtCM=;
	b=uzQQC1uwL5G9d9p5ECbN34Mrhh/EHo5sUB8PFdRjoTNAi/ts4mjTJZkLSIpNMxIWgzWZz4
	8aaoCfpOJnWKwJ0IOwA4MosZ4VAQ+p22jU8SBy+k6Thex074N8o0xK9tPQ9M/ofoHqh7jl
	Jv8H15jJVQHA23JxqTD2PUJS5y99Zvw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s9R4skG5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766659; a=rsa-sha256;
	cv=none;
	b=CABP7uO+/Hp983gjL4I6mFNchZEROhcRFrun6U4Likq98jH0r+XKO3sSIZLT9/NpjIoCOc
	EGDMBIRG7gxUfRr3HCwhZit6lCyvu1AAI23XMn0KSQBhBViTrXUNCgDSxEIU9pMgDuLFcL
	dYsRQPReRKdRCS0G8ujhpGx+U80mRSU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A221540AB4;
	Tue, 17 Mar 2026 16:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1887C4CEF7;
	Tue, 17 Mar 2026 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766658;
	bh=dWpP9RC2AOJFLEHW4kUCv0xfNWwbmf3vYnbU/fsvVFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9R4skG5T6KH5NvwzA4vYuRme6D0OB8ITfYauWXHRHyHHcMdZQZevLyzvso6LsSEk
	 wFjc0hW7YrUN2nIIhHWAZ2IBtJOxAiJNGgwICG1VZSPVF7UCBzEDMNYhcFROZo6jvQ
	 7xrRl+V3jFMzZ5RFtPYpI1LfYYBfoAZcbaAk6qIeyhCe7E6iS9ZuAaO8JPZDVQPgv1
	 rc6xVKrMNY8mvmIcxj6bypwbXi2S/ErknSi4akEiNdwrg3cPX1jHtTAYv0sTqy3Mqv
	 V6Lo20crQ5OTijobm3om86U5qN1Rn1t1ewH2VXK150Cf+VPPOvuXTM3FH8voCugRav
	 dq58rnDb12TDw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 09/14] mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific usemap allocation handling
Date: Tue, 17 Mar 2026 17:56:47 +0100
Message-ID: <20260317165652.99114-10-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 811E48000F
X-Stat-Signature: ww5pq83ieqte4eeon4m7nn5bdhbau4nu
X-Rspam-User: 
X-HE-Tag: 1773766659-55640
X-HE-Meta: U2FsdGVkX18ogseTTXhgElZwO+qtjwo7ZBUmJQ1VQ4qT97DMoan1AmmvLPOi49/A+ES9DCUa4qShY5pangxFBgo20ObsZo5pehVqf4K8Pzwx7IV8cEqZWuSM4y13AqzAN17SXTQ7jm61K/ggSW1qIIraOgJFs3aOJJRqOvF2OEqBN3pOprA1NSPuc6ogHlxlsiZhkM2+E9zHligUD65DQ3e7ZznpM7UHa/G0/3597Bndd/VY/7he/LHUEI280u/duPx8O9s09U4qmrkUAHCzy394dUnipjyiRTrHBkvesXuLnrAhG2meH6lRginWY4PbZ8ey4Mz4/bRPtxGXilSihkFlWplnJuaSkPJ9uRP2e0tZM6X2Mh83SLaOGbIn8G/hINAgbJqzipnfZNbaorj4YR76eUAeQmc0mVt+wyXYGHpKy4lbiyTgIj6H7fqFc1OAI3BnunUgoyBf7iZqleb3yeeyUe+twz1176g87XsqMsbgOVHeHBdvKSXWuQUpe9I64OQ3MlFVUIgELHMKdfG4ZR1Ph6u2ov/jH30/zpZyqR9vbKOfPOohmOGrbb4Vy86fCafX60cYLejzvEhpeZuSYosw0E1Y/iWvPNMawHsvHWCT3E0pYjdxKbN28o4Bv1I12GWo6N3CUrPHhcuJZ9gOKeySdfGfIDC/B4ryUFMnBe3X2udVg1daVNgTmwU2Sj6QSC0W3pkNwYjaLaFj2kXLXiSaPpNi8Kt/WoETPt85+tFYBKq2ik9UALsHcSU+auNiqFkFq+xE0wfqQtxrTknVxrCIhcYXCY8bIGCuP8xGL8eYHAl6HP3xBmUXQ7DvJSYRtvwdxVTuN8/3j6jEWcIdJYvpPIa+Uj4ax2GfjSs+lVCkD71A4WZEzEmIUofzaSj/Z/MgoFUCiPcQrfeLXE/2pzZ5PFaYfNldiPM2/7s3scZ9QDWMP4Jn7vVa+NumtFpsItTlC13f9gXkQ8k6nq2
 +cjJZ8X1
 76kBpETa2O8Og6Hr+crTftDKk5geXBxs3BTM3MSGxMkYJj7ky+9QYvU923RYIR/3YPchBNXJvc+9FlRhCijFEHTf8JORHVloKklj8XmWulbRQxqhQZg3m/8rgVxprcXuTUZd6Rrfmp3VEOH5Tg6rg+xw4xbUkGpEgyW03BKl2sMx7SkZMj38z1T7f+xN7Fvo134nnrmKwX8oGUb4fRqrbkc6E11DZ5uqE9RRHyoswjJ0Bvidib3TQWCAJ4lDQ1kfCUr+aStOkWAzAyr7qWWSm7IpRsLb7KgIoYe2s
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
each others usemap, turning bot memory sections un-removable.

However, in 2010, commit a4322e1bad91 ("sparsemem: Put usemap for one node
together") started allocating the usemap for multiple memory
sections on the same node in one chunk, effectively grouping all usemap
allocations of the same node in a single memblock allocation.

We don't really give guarantees about memory hotunplug of boot memory, and
with the change in 2010, it is pretty much impossible in practice to get
any circular dependencies.

commit 48c906823f39 ("memory hotplug: allocate usemap on the section with
pgdat") also added the comment:

	"Similarly, a pgdat can prevent a section being removed. If
	 section A contains a pgdat and section B
	 contains the usemap, both sections become inter-dependent."

Given that we don't free the pgdat anymore, that comment (and handling)
does not apply.

So let's simply remove this complexity.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 100 +---------------------------------------------------
 1 file changed, 1 insertion(+), 99 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 2a1f662245bc..b57c81e99340 100644
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


