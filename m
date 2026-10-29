Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A635606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3wM2Fp2
Received: by kanga.kvack.org (Postfix)
	id 7A9546B05F4; Thu, 29 Oct 2026 16:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759976B05F5; Thu, 29 Oct 2026 16:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FD06B05F6; Thu, 29 Oct 2026 16:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4546B05F4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:44:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3184804E1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:44:07 +0000 (UTC)
X-FDA: 85376840934.07.D59C015
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0E06B80005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:44:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3wM2Fp2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PI8EmdBn37j7qc/hvMAGTDVDDo5VBf2eU5QEycECV2k=;
	b=XzoNt3CIpZRrUsd/aTQ0EuwXj+FI9PEccSVM/3ebI21B5MA5qiAj6iYrv93xuHL/4QYQsW
	zc9sTdDKOIoVI2U3AfEE8ye7I2EbinlgkvN37RZbHqvo0DL8dhnWV6vxTbHx8QWjvNWwi8
	K2d1nKftwuFEuyC1Vyo+lM/S2I9UbpU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3wM2Fp2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306646;
	b=oGR8UHYkj5onO5aRpMasgJ2/J9/6xRrLq3oldy1PsnijFxDvvq7MDx4gPF/9LPWazUwEdM
	6O151XWJcaLd/7Npexww9jC5qS3rQTgCCnnvC2v2vdMVB7sHosvLnz7JYCT/5C7cnHDimB
	tYlQxU629kxYgJcj8mK3ISt9hwT3d3Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97A3A6062C;
	Thu, 29 Oct 2026 20:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABD81F01826;
	Thu, 29 Oct 2026 20:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306645;
	bh=PI8EmdBn37j7qc/hvMAGTDVDDo5VBf2eU5QEycECV2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I3wM2Fp2M/mnFZOoLQjrOOGcJn2Tv+0zUzVbgWBHluank6O6Jj1/hRTD8bqfwKQr4
	 zHGg1evLbpkE+EIITtj8IU/8h5sV5/cwswPhYhl58K+pNMq7yafhM/3QJ/6tSZvjtc
	 EIkF69eSqkz5J1NC2rlbPl+flcQ/bjkq88b6bJXNhOBiP8sgZRILnp8rnBww98GwHz
	 WXdmRGcnvgjlqG7d/lH2c1NXRCKkWqDCNw2Js2U532SmcF2gBH4YHMWqG1WEOaK84E
	 XQRunhZ8gsVpvKbm8t04i7F4xsicZijv9ybjklw+5K7P0vn1r3nGM9fxxNtquFNu1P
	 xH52ZIz0oh+VA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:38 +0100
Subject: [PATCH v2 43/47] mm/huge_memory: split huge PUDs when adjusting
 VMA boundaries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-43-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3933; i=david@kernel.org;
 h=from:subject:message-id; bh=QffgpAOB3agwHlZzTMqGo5KOI/hFG36iruKivYKWL2Q=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+303vND6POzBp0C/l2WzFfevlivUbNg/4TeZ/vCm
 T3+ZP1b0FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEZnozMkwLOl5Wk5Bj1Thd
 SFvk4Twt9r1svrlLZnWGliUJ23L9vMbwV86BzahUqf7TnN3Gc6RW/hTcvvzy1FTBp8v2vL6/5VD
 ZYz4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 0E06B80005
X-Stat-Signature: xzfanbp68765bo3bckcx5kno8uig1snd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793306645-957370
X-HE-Meta: U2FsdGVkX1/EyQN4j+jg2tYnh5XP3VUmMsSJpT9301ZVx84aMKVYJ+NQmaAxOgSZpZU4C03tzzUxbi1lsCcmjZcsV4acYVi6Nk8nM/j5PMKk31CuLCS2xeKW10km/r6bWDMgw2ccmhPnpbD4M8Xd6xqGGKVRKHWt6a2LjED1eaD15vBltesEVmysUa2yt/3sq3AI64xNVOh2LmvxflygnLILsdDM+5I9Kb7aR8jqsWqTuBHyBd3g9YU4gswYLJZsKIqKK6d4afykpCyhtQ8xdUO7hIEvqz7jGJwVH7wJ51lOAVmiEzyYrvrn2RqzK+UIcycvXQID6S3ofr7Bk/pDLk8eh+Q6CBv62S8DXJA8CN4Mm8Y3rvhoQYzaTqn9bpc0SsXV5osA87z8wF7tu46F6QUqwE4s6HH+RRjlAsGNfjsox3gBwG2pePLalXhnSXYUW/gcF8+9ZpjdayXpTvEiMVREunGT4cZuF6waKm6d9x/RwLAo0nFXKul8JG1ksBwMvgOiUJaJ67hHmGT0SRXzzBjjpl1hRmjotgedHmEx/3s7e8M1dxRAiltaZOsyuBk878IWzkD5uspC6cwG7wb65SCey9DhRHR/mm7Q5mYmBSa3ldZF0GO2FH6/K4f0JwdN9yglfvq5HT6lEo8RDwjEIkboayJeRqkLcdyKlT4PL4KAYTM2uUaLMA6zSuV3x4SxM8eYQCcGrCXnsYBtq/d/foiz4e0D6FVMUZZHG31tY1v93Fuq5ijbIZ5Lzbc4K/Us8oMofpryho2CisIUsJpZ/GPZNZbzbtGcx6mfup/ivGaQEKgt3h6onHXrRAhaAM1JAd8v6A85cBzY48OrUaeXEwMflyXjRQEZbfwRchg7nZyXWIDImQJbmme2tneTitXvLXm2gKdtP0MyR2mpTgVMS1+WOG7adZpf1J2U3Y5ee6+RjjHiNaWiHt9VoD5iu6JVTkD/t2K6m8UDPjg6Y/D
 ErMsbBMn
 eFq5R+bWh/paRQNnFuHhO5dHZiifxSQAiw4qep3CIuSGUEr3oyqiwFiHnoYoMoaX1XmNKoT7EqsTXhkJrO6DPZ7y22DN0kKRxdtYQsjalfeeWTPxcWEt7AY9f12si+uPZkdjpoFBxIqWwNlihgCdlQ4Dny+oM9/sXqDIt0nxWXEJ46fW+zT/AUMgBzTnqL9eDSQJoGyYJmQqjtJILPfi2bSFeLK47huA+Y0eJbgqXHCtEJ/R1JOsb1k6Z8nrfsbmscam9aTGa0IxNTkeDjoW19SwTg1U9kK12KJ0dsDbKOlZbag0tAvtkSPQKAOt8NCoB0dZ/PxerUSiwn6IAyqM6/pR9iojHPzB11YNU+ZXTt9sZN+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PFN mappings such as VFIO PCI BAR mappings can use PUD leaves while
allowing VMA splits at page granularity. However, vma_adjust_trans_huge()
only handles PMDs.

After faulting a writable PUD-sized VFIO BAR mapping, changing its first
page to read-only with mprotect() makes the PMD walk treat the PUD leaf
as a PMD table. Applying MADV_DONTFORK to the first PMD-sized chunk leaves
the PUD spanning two VMAs: the PMD-aligned boundary skips splitting.

Walk the page tables once at each adjusted boundary and split a huge
PUD or PMD leaf as needed. Handle PUD leaves even when the boundary is
PMD-aligned.

Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f1b3f744c630..6ff3faa200f9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3504,16 +3504,66 @@ void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
 	__split_huge_pmd(vma, pmd, address, freeze);
 }
 
-static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
+static bool pud_split_required(const struct vm_area_struct *vma,
+		unsigned long address)
 {
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
+		return false;
+	if (IS_ALIGNED(address, HPAGE_PUD_SIZE))
+		return false;
 	/*
-	 * If the new address isn't hpage aligned and it could previously
-	 * contain an hugepage: check if we need to split an huge pmd.
+	 * Only selected VMAs support mapping PUDs for now. Lift the
+	 * restriction once this changes.
 	 */
-	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
-	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
-			 ALIGN(address, HPAGE_PMD_SIZE)))
-		split_huge_pmd_address(vma, address, false);
+	if (!vma_is_dax(vma) && !vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT))
+		return false;
+	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PUD_SIZE),
+			    ALIGN(address, HPAGE_PUD_SIZE));
+}
+
+static bool pmd_split_required(const struct vm_area_struct *vma,
+		unsigned long address)
+{
+	if (IS_ALIGNED(address, HPAGE_PMD_SIZE))
+		return false;
+
+	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
+			    ALIGN(address, HPAGE_PMD_SIZE));
+}
+
+static void split_huge_leaf(struct vm_area_struct *vma,
+		unsigned long address)
+{
+	const bool split_pud = pud_split_required(vma, address);
+	const bool split_pmd = pmd_split_required(vma, address);
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	/*
+	 * mmap, VMA and rmap write locks protect the walk; the split helpers
+	 * take the page table locks.
+	 */
+	if (!split_pud && !split_pmd)
+		return;
+
+	pgd = pgd_offset(vma->vm_mm, address);
+	if (!pgd_present(*pgd))
+		return;
+
+	p4d = p4d_offset(pgd, address);
+	if (!p4d_present(*p4d))
+		return;
+
+	pud = pud_offset(p4d, address);
+	if (pud_leaf(*pud))
+		__split_huge_pud(vma, pud, address);
+	if (!split_pmd || !pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	__split_huge_pmd(vma, pmd, address, false);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
@@ -3522,14 +3572,14 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			   struct vm_area_struct *next)
 {
 	/* Check if we need to split start first. */
-	split_huge_pmd_if_needed(vma, start);
+	split_huge_leaf(vma, start);
 
 	/* Check if we need to split end next. */
-	split_huge_pmd_if_needed(vma, end);
+	split_huge_leaf(vma, end);
 
 	/* If we're incrementing next->vm_start, we might need to split it. */
 	if (next)
-		split_huge_pmd_if_needed(next, end);
+		split_huge_leaf(next, end);
 }
 
 /*

-- 
2.43.0


