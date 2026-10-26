Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122E2606A329
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bLRVc5gR
Received: by kanga.kvack.org (Postfix)
	id F0FA66B05FD; Mon, 26 Oct 2026 19:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE76E6B05FE; Mon, 26 Oct 2026 19:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD936B05FF; Mon, 26 Oct 2026 19:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B80D56B05FD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:31:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4517D408EB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:31:11 +0000 (UTC)
X-FDA: 85366375542.06.F673D6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 731BE140005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:31:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLRVc5gR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057469;
	b=rpIPwOe4ta+1v6wF40ilQa6Mq6WXQ7LEp3bj1/wg5awokKUhDPxEvVcQkj3T4Y1EyjlizO
	vi3TaDg7N6IUjgHfQs6DcvAxv6gnwFw1yk1vVgpumBbkWF3nw6pqGV/AOMjwIg2zy6m8pu
	jrPWj/oArjQcMnnZGiP/fY2jqWlfzwE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLRVc5gR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpny6E1BVObd7dsWihweCIM0hF7qSfx3wRUjDYjrVHc=;
	b=Yjex2X+Ud2qpp7ZdGA73c42u5mtNdAh9t03rYuVM+k3YPtMVrUc3jI3TPP4ATnsF9IjPoU
	NonKMHtafXJWklc5KijqeYiCYKnADV9EfM0uILki4I5bhkwFUlxrJs5HqHzTLictG7aKx3
	ikpsG8dcXtdpFdhWgl4IZJuoWFvziNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1A2541B73;
	Mon, 26 Oct 2026 23:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EFE1F01828;
	Mon, 26 Oct 2026 23:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057468;
	bh=qpny6E1BVObd7dsWihweCIM0hF7qSfx3wRUjDYjrVHc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bLRVc5gR+7gHpNcNYDK106P/bzwRPJM3i42hhIFUMNc+gg/w3xZ/vrMnATKC8Q4bD
	 3EljQv1NvcALI2EKTkF2JeDml8GRiigQ7HVxWgAO4jp/SYKo4o69zhuI2VK83+al30
	 pY3LlCvpT2VWTKcVHrKKrnqnEoLVOO8GGg8j+OujCuqvB1gyzgV6RXDtX27xyL9bC9
	 nsCCpNBsysLNV2525AxrTSFsPKjIO3rBbI1EUqkEmbkAWGEPayKgY96GY3ZbzmsPLY
	 EHxlraYONS4v9x846qg+8rmXNG6lly1wiIIYYkpUk1COlm0Rokvkbc5M5Vv8Fo9Wof
	 5Ng2XDxmXi3YA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:18:02 +0100
Subject: [PATCH 42/46] mm/huge_memory: split huge PUDs when adjusting VMA
 boundaries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-42-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3948; i=david@kernel.org;
 h=from:subject:message-id; bh=vNNMWHmNm9srS8jxwzTDXKi766cdoioLtWNbwtZUzeY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/Beey19ZkHk3itqxv3LT93mDE+fOI2VdEVCz8tt
 ur+edVZu6OUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICb/JKRYc4un5UTEvctn3R+
 BYtNyJ+Fxmf8xOcdtQ6W6FcXL9K1E2Zk6DnGLJ51vObHvuYPM3gO9J70/yXtb5I60T3o8c26/mN
 3OAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 731BE140005
X-Stat-Signature: jgpbufr8dayb6rexoojgpfskogogcxb6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057469-715647
X-HE-Meta: U2FsdGVkX19QtZtoFyrPVWstJJgrptERkU8YEgyc8ThRe87TDgciSMY12ugU83sox3h3bsGsVC8UlAn3UGkkWXvV+hU/sR9plFlSZ+tGJrVPPs6d1//9ajMKcZ22HQxYZ8FlavjujM6Dc/uPrqqKpBxjpn1Zp5tuBo7inn3C6N885WkXAfUV8ZbqWejkcFLm2584R85dyMOk/6YiuZM6rhVhUBIB4csY7snkRQjAfOP5qzbvx8j6IZKXgyy6qTNKg54uPjC/ir5SBIl2VVq84dXLZo+fi4N1g4lOMKi36KfI2AXYc3e6bDznF7enIUeEIBunTE+RKjVMKRFW5MZ1nNqaN+xxJ5qUqAwRxhyCToUuDIZF/w/9zGWiAkKmnUw50lYCyvdN6AM392ZWVsgo8v8DxP3lSTtrGVcfoZA8XN4r4O17tIGL+ixsbfILjQ9Cgai53ADyMc7X4WgM1RjfQwz6xplTSOAN6lLPwIjWl2ZoW1nAzpX5GGxD+Pu5HEvdG64+fmiJ3P6n87iCclgs3D8JNRwuwOLglgPD8bMXF+soE1rj+G9LKW5r/YuxofXXfvuPxQJbs/ZOskVifOoLnfcLVJMRatQ1OzaeOx++InXtEKfR/SwdbpG3DMzhQByOWcndHnsa92PxXYoqmP0rFxvEl0IbM7Cdx9H/UmdViQXbDoj/HuLlhyPlAXV3s6MRlP7HRX4q4oZ/+CDUDGBu8W1X9KNbiM10fbnumvlp4IQl3Ay8a8tahqSew4J6co3GAQJM5n5yarMCT6/vOMpEEulK0zrpeQf1ma+M3qjNV+8pfWuK0dEOoVPABNQlUZ6u4hzFJbeAl6119yi/UmwPepfPx4veeKQXqlG7o+2DWBu7Xri+G8OrepvHJ0+yhwmAJIHARhGhTICTWjL7Q00NDxj7pB/dI/zR0IvmFdNYrmJSLo/Jv/K4YISHUcxSdTFjq4fIn7Y5RZ6APNbjztu
 XpTpdDdl
 z88TrRfDyAmhdkZZMSB+PZozIgPGSBl6BDlSmN/E2YmzlVCH+OSQzYBPtqr1IphvrCEkRXrhJfMahpXHz0liPpQS3jP+bxNJDLlBtUmci+y19KMZyjZmVpaDeLnafvPzubuC9TD/4vkFUYyuTR55wesPcGMvwXBKSNoOGQJMGPOBjkVVRn6/4CUasEDLI+tQUucI7p569+lKkNR3HjnhSBzM+KVUY2UniM3vNtvN/jHDZ3gH5feD92Dm/nPAlcd6fnHmQlS42B6bCLbkEnav5Fx7cWx68qci4XPjZo7AB9YIMv/LpuUFWyGbPgXFyyIxebHkqKzUpm73gYZG5S6a+ps7eAM4tb+XIJqTrHudZEk/10+tVDh0BpFk1GQ==
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
index 08e58cda7d37d..d090642ac8c2b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3503,16 +3503,66 @@ void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
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
+	if (split_pud && pud_leaf(*pud))
+		__split_huge_pud(vma, pud, address);
+	if (!split_pmd || !pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	__split_huge_pmd(vma, pmd, address, false);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
@@ -3521,14 +3571,14 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
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


