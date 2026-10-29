Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D77606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FXCbw/KG
Received: by kanga.kvack.org (Postfix)
	id 9F3036B05F2; Thu, 29 Oct 2026 16:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA796B05F3; Thu, 29 Oct 2026 16:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0C96B05F4; Thu, 29 Oct 2026 16:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4A06B05F2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:43:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E700916047C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:43:51 +0000 (UTC)
X-FDA: 85376840262.02.E637DBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3509C180004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:43:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FXCbw/KG";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IH8xaAe45mU8M57+EDLlFo4PLFfCZN3Im2S0WKlnK0=;
	b=2m4rF6arlc6QhG0hXgNvS7geNqAZ60pPpOr7mI+/DxIM5oZBas8wpjT7atsWZ1FR9B7JBY
	Qma95kfH+NEJzClhK3U/hog5SnMP9xMJF/Vo9Q+T20igpybUjy2V/2Sy7F/EpVnBA7BAmn
	545Ex9X8xjGBduVn+JFBRsQH1DE4+l0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306630;
	b=Lr62KCACG1kUrqqRTzjftrE4Cz/2pyrTv/PkJUvFcDptSxqS57dAW+soDD/HuhhAwqa61q
	N7jOEW/ie17QnjQLAoVwzvFtpYSjaFrmuISDruvHWl4pdt3XeNzc3EVbbDn8JMw5OL+sEZ
	TNO43VaZnVNkSQQYkRQgKuGK9xTzJGE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FXCbw/KG";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D140C600DA;
	Thu, 29 Oct 2026 20:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C171F031E0;
	Thu, 29 Oct 2026 20:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306629;
	bh=6IH8xaAe45mU8M57+EDLlFo4PLFfCZN3Im2S0WKlnK0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FXCbw/KGkeADan6zqMALNi5auqZppW+OBphX7usMQRLTkZScs5lZeOWTnOPkT3HYE
	 FzwNqfCPCPRcxwfG9bVzxOcBVT66ZZY64f9snScoYDQ+pTvG1hSXDrKXonFSpK1Kqd
	 6RBiwVQEpzPNpdM1PJYbB62704hVmMK6mNHCb/41sfYaaO5a0ObT75Zh0vxnKGmQS7
	 v34PbNeOF4vKtysFkjrqMd/EhUWkUkYBCwoHZTJXRjJ+RdzUVlIymGKA4ttHbOgOHE
	 3FcaANIDpL3t758KDwXRBEHA/EW2zThvb+Mb/YVaXxc5R5eN8n/MZoXYev776ycpcL
	 EgPBtGftyGEaQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:37 +0100
Subject: [PATCH v2 42/47] mm/vma: call ->may_split() before a partial merge
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-42-a64ce7f83abb@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4060; i=david@kernel.org;
 h=from:subject:message-id; bh=oeEtIdns6TUl03fxOY3qVv1IgcZMbIMX+UxPpI52qI4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+3cf3Dnh6bQe9PUGDJndafMPDuR68SD7zccnhg2f
 z8UOCtYvaOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJhNky/GbpEZrLHKi79fvz
 x1n2EQIuIksqPn7dYFvL/lRNPLc4PZKRYf2M6d3Gjv7FYV5/RXwcegTcRJ3l4veccNLkSGP7fF+
 NBQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3509C180004
X-Stat-Signature: arat94f1t15jrf1zyzh8ddijju3g3e1n
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306630-475226
X-HE-Meta: U2FsdGVkX18nQcC39gRn35ieBz9H6KOSOZobI4APPS0qB1gNqGwd74EnhS9t6IefP+KQuw3zRM+pmGhS6N4X9K8hl25itn8fdrZTVosKV9CU+3XLWyDJtRQA8nvbeZjScvDL1NprZI0g/PVEFjbBva/rPbnJXj9oOwrI+/7upeKjYjx5yja8WbARFvxMaT/qpu+5nfkAW/s2iqsJavXXS9+jX8vrI5nYFYyshfUK0mhsnuijjuuy4B9k/mE2SCo+nzScB08bCD/j0szLKYiEKP4jH8TcEmAGCWC6RVFQXnr3p0tglmA2duN8jze9oGBV9Zjqn7vLASNJJvnN13Y7FABnIYBkLKfrNS+E7pqM9LLAdl7DtSEejx49IcPsM2s/EYmPhRV5vjacuYMJRCji8yNgGDBtiN2TyS2eaz5bgE1r64RJrc7jUeoPtp/0mbka1aY/j/qMhyqdqA1BA2KMB/u2MehvDcDMoo3U7wvC/K/pcdOVHdIH47S0Dx5933lKyZQYFeR3rseGQPsCbPfzc1ToAha7w61pe+WyZrj2coGJRP4FhC9PaOuHkoebnfPt1S31/5v7GqPQ9P0PSkSygaO3tyy5meTyYT6gDoKg/zgPdAbuE/3h/oPZfo4DPpBuBn+Gc6YXSTYkk1IgGis/8yz+uqzxKwbAdP9bM07rRI2HvFa3F+0dGFPMPfhpeuponpRuHJh1GfDslwD15Pw3tZZY2BP/qTvkjRjyEr0BYLjn9d+9IwyzxAc2+ZvM6pEYi711w2dC9H3cO8ly2ctGGtGfI8aHyRu06XfbvhJdYoLwXilsNlHFFbTM8OS6+yCc9eBvmk04EivmURNPlwj6YBiLp0bnOmOoDryUiDDtNG2EdcGazV6B3Xi+c7T0yB4XcCl5BElPgsIIA6GrvyL4xnlyoJLhI6YUTFv0E9IbeTjJe4GFCf5EcSL4mVe84+ew1uYaT28GFqZebkwncOw
 Orvlnup5
 2MPT1Qpgc8wtCpNS4O2yRQ8iUl0CWO5d3HO7XV9EOienFkyr+K+fUASBj0syqKM4rI5cVSMhIAcP5Xs3TESX6YpoBJberrmxaThrzpsxpJ281xMGv8Y1IkNdk2aVrG7wi2uxFg/7wUZMrNbcycG9qsdEv9haovywMNg3l69fEtjTzVG7H7DitvSr1Vlghgkk9ayMDrWylNLdvRmgbJUcgGm6IWCz8k9maJsZXdUb5Q6tJU40FYnsXOsoDsexKpuV6TzQeZDYx6hWfqsosf4U83jJbHxBrZhI335zoH9FcRiK4HQlI9cZB3JN41sdj3WFsHZe09RWVClsWO+st55ZH3yuM4b0hwA1Y5uMhpC/VfIXRS8T8e/mwSP7ZEb/v5XWTCLTUtHvfcqgF7yg4/+W2XIGAlOvmPXTah/antK5ziT3zmLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A driver can use the ->may_split() hook to forbid a VMA boundary at
certain addresses.

A device-dax device is a character device that gives raw access to a
range of memory through mmap(). device-dax refuses any address that is not
a multiple of the device's alignment through vm_ops->may_split.

vma_merge_existing_range() can move boundaries, but does not call
vm_ops->may_split.

If a range at the edge of a VMA gets the attributes of the adjacent VMA,
the function moves only that range over to the neighbour: one VMA shrinks
and the other grows. This is a partial merge, and vma_modify() tries it
before any split.

Take a device-dax VMA that lies next to another VMA of the same file.
The user calls mprotect() on the one page of the first VMA that touches
the second VMA, and asks for the protection that the second VMA already
has. The result is a partial merge. It puts the boundary inside a 1 GiB
mapping, which is a single leaf entry at the PUD level.

As part of the merge, the kernel looks for a huge PMD to split at the
new boundary. That code does not expect a PUD leaf:

    vma_merge_existing_range()
      commit_merge()
        vma_adjust_trans_huge()
          split_huge_pmd_address()
            mm_find_pmd()
              treats the PUD leaf as a pointer to a PMD table,
              so the "table" is the device memory that the leaf maps
            __split_huge_pmd()
              reads a PMD that the user wrote to the device memory
              folio_put() on the folio that this PMD names

Bad. While the code must at some point be taught to split PUD entries as
well, the issue here is that we move VMA boundaries such that they are
incompatible with the driver.

Fix this by calling ->may_split() on the address that a partial merge
would move the boundary to, and by abandoning the merge if the driver
refuses. vma_modify() then tries the split, which fails with -EINVAL.

Factor out existing split handling into check_split() and reuse it.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: improve description; cleanup the code ]
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vma.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 1be613044b4a..acdf00346cda 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -516,6 +516,15 @@ void unmap_region(struct unmap_desc *unmap)
 	tlb_finish_mmu(&tlb);
 }
 
+static int check_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	if (!vma->vm_ops)
+		return 0;
+	if (!vma->vm_ops->may_split)
+		return 0;
+	return vma->vm_ops->may_split(vma, addr);
+}
+
 /*
  * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
  * has already been checked or doesn't make sense to fail.
@@ -532,11 +541,9 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	WARN_ON(vma->vm_start >= addr);
 	WARN_ON(vma->vm_end <= addr);
 
-	if (vma->vm_ops && vma->vm_ops->may_split) {
-		err = vma->vm_ops->may_split(vma, addr);
-		if (err)
-			return err;
-	}
+	err = check_split(vma, addr);
+	if (err)
+		return err;
 
 	new = vm_area_dup(vma);
 	if (!new)
@@ -948,6 +955,10 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (vmg->__remove_middle && !can_merge_remove_vma(middle))
 		return NULL;
 
+	/* If middle isn't removed then it's resized, i.e. splits. */
+	if (!vmg->__remove_middle && check_split(middle, left_side ? end : start))
+		return NULL;
+
 	/*
 	 * If we merge both VMAs, then next is also deleted. This implies
 	 * merge_will_delete_vma also.

-- 
2.43.0


