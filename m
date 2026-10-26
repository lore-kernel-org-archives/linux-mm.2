Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C633A606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eh+x/TWR
Received: by kanga.kvack.org (Postfix)
	id CB47A6B05C7; Mon, 26 Oct 2026 19:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BB16B05C8; Mon, 26 Oct 2026 19:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2BA6B05C9; Mon, 26 Oct 2026 19:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86EA16B05C7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:22:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 103FBC088C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:01 +0000 (UTC)
X-FDA: 85366352442.15.5EE9230
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 484A3A0008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:21:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eh+x/TWR";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056919;
	b=65im70bC4rtgTzlLMXKfKw9jipXcIdEWox0Og6TK+291nNYglgUUcEPoqgTDV//zG2V9Aq
	jkKjuHQE2HG4nT8xm+oL40T5hRQirfCntpD5WYTRBIDtqi9aICeVeh+yno556G5CasJbag
	3QunEX06jzKc2cJYIrllgaDtFMR19Q0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eh+x/TWR";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MnAvX+qI+mYQxA2fVfQg376k8J/xzQVFinnmk0GIyE=;
	b=F1PAzNjJzcQ08w4ud13xgrLLxqHd8vfKXm7o0vlr2Pik9+0WGdgi4gGYw+0KDgGvZW3OWR
	Kp5Y/XTdwkxz1DVTg2JCukQ5a4SNXpROe5a/HpGWamPMVQ+onG+cteB8gHFTRtoT2TWwxi
	yPA1gNxPlFQKR5iB7zEzoNFDQp5/JJE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C88DA601F9;
	Mon, 26 Oct 2026 23:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C2A1F031E0;
	Mon, 26 Oct 2026 23:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056918;
	bh=+MnAvX+qI+mYQxA2fVfQg376k8J/xzQVFinnmk0GIyE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eh+x/TWRFS/iJ1o5pPJTPgSPhjIqgQS3EpnhiXcdC9m89yLc/rPs+Ad+DvKTl1fG9
	 NRD+KHiMvg3Fzyf/Biyf6XapfStao2hkfGuVGecEOmPxP8jclyVfkwrKJruvRdUs+b
	 jgvMBNz+MQPmFzhlPEUeSLiIlV1kPYlpWFUelDXGXk0JoUAD6JwZqJlTU62Nccn1oR
	 Ish/vEaxWz1T3FoN8J0XkU0rKmk3p37d0dFOsvpnab3UoD9KeVrVEvHAMpSewlf2oV
	 k4+XinYlqn4Ci8QY+xQlfrqejBbu4gtWkoxgMIe7o06wca6Os8beRZYY8j96gLJLvQ
	 h/YnvNHUxuzcw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:33 +0100
Subject: [PATCH 13/46] mm/huge_memory: fix truncate racing with PMD zapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-13-6f74bec9a5bb@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2193; i=david@kernel.org;
 h=from:subject:message-id; bh=lNkOF7790rj6TmUsBd+4scX6XFv84q64jJb19qNwUOE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/yUmPX2heKb2tWBnBHR7/sl4lR76kT65hrKpod8
 jbVfk5yRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABNx8mb4H170dtHjpOPPY/IK
 t/y9WbzDQ3XOugP26i8L/Wec3XLw5QVGhgv5CutulWXVTX7GdSZnmW4UC+tXA8OLM+w6eS23l7s
 EsQAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: sreudg8wyczajudqfgobh1oo6c76ed8p
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 484A3A0008
X-Rspam-User: 
X-HE-Tag: 1793056919-735823
X-HE-Meta: U2FsdGVkX19Ahs8+NwLv1QQGJU6/gTgbdO64xY+qR4BgdteOcJpirYx7xsWusBPgj1e5jh9xwMVjXZAuUl182g23vjD2OOz2UZjRU0dfJgDhyS9bcOXUrJXSLnrrm1YyLF6vz++qBjq8WNUZYFe6xlwQjNi4iupW8h7d0gzXG68o2eWVUoU6XMm425LttCai5Zk7v9bwVVyyUhUfArZIOF4yx3AiPeXI4LieGTXVeHSV7gi94SeuPEOnmZ7//dOULCBg6RnTSdG3pNF8Zhw9XkdCMCgQOfGe2pAXP5SCx1l2qCnx54U2eiGNM+kLsCewKFONEC4xis3mf1V6cLXhSrvKcPPrffhjwYm4ODVMUczhK/hOJ4YkWGn9aSaiL+PIS0t7XBW7bjlM0QkzOYkdEhMb7WXzTbC4EjrMzhI9/QeN1F4mpH8t0afkaAloWFhewPLhlXrl5zHMFjtyBpc+Iyto2j4M6GRCrSpcZ4TReiKkNr+DV3xvGHN1QCpg5NJWm+kkud/KUaiUn6x+nxvKSINr3lkPMnKR2HNXEoLLATeTpEPEYyFqpUTJOK96KXQdNwax6Eg+nA60FbUFbh9XZUixDa9t3IKSOryY6kqmtp0aseO9Tw83TAHHwqdZf4pvx9Hd8QDIOit43Ad8REWQY8q0Ck6nS7K0CGereXn79uqfFS87xRIBE2chUFVIj+Zpf3e8MQGqXnHjsQ5zT14KjdrSsiKlHKhFBm5Anr9m4sKYdV1Q9Id5+DLUjSuJMOlwGAqDMTy3fpWGBW9bcnprs8XYgmrocFBC0zIh3qniSxc/gaDd7HCG1o7HxRlpHycFRHV767uXJTCKGSxBnZBZBTTtFn/5sPNEcaxqCMQVnZ4cdTiSA8iCvODbY+NyYoGkfBDs2LiOmBvNXxg+UIs2RWw0MaEQxpJ0R3ZDPuhg16PRc9gb4/VR0vGKrj0BqVfAqQ9kb434pwzYlyQITks
 I8gdDfyb
 ofY6scWjDP0HHOC3F7fnW09V6DunHOxoSzytOxyRpK1BBs9IIRPDNS7c2H64HSTEkLaF5V04hmm6+DjF7O7DQAR4EKazJ2zhDBslRKbd3saoSJuANcq1J270pcBoJ33p4PE8ChAPdCtRPk6T+m4CXj2iV1dfQnnZh5G8WiYvT/yvcKbqnNR48cMnVazB2lTVUGy1cMrYr+OyP0u3HB7OhDGp/AFCjMzn7pKBDhajcMA+lTlc30wOsF5kugo1AllrQNWvHf2oquKbKhkA32jephZ5B4HSGZlVMhwZkxLqJt5G5Z+Cu9iGdtmX8JDg/Mm0us+3pkso05BRKgejznTRvJEsPyMr4frFbeH652TiMp7NGesw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

zap_huge_pmd_folio() removes the rmap before calling folio_mark_dirty().
If this was the last mapping, truncation can skip unmapping the folio
and proceed without waiting for the PMD lock, racing with dirtying.

ifs_set_range_dirty() can oops if MADV_DONTNEED races with
ftruncate() on XFS, when we get the folio set dirty after it was found
to not be mapped anymore.

Move folio_mark_dirty() and folio_mark_accessed() before rmap removal,
matching the PTE zap path. This keeps the folio mapped while updating
its state, so truncation must wait for the page table lock.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: fe6cf984939d ("mm/huge_memory: transfer the pmd dirty bit to the folio on zap")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify comment and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b31a425c7a32..eda020dd6e33f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2495,6 +2495,14 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	const bool is_device_private = folio_is_device_private(folio);
 
+	/* Transfer young+dirty while the folio is still mapped. */
+	if (is_present && !folio_test_anon(folio)) {
+		if (pmd_dirty(pmdval))
+			folio_mark_dirty(folio);
+		if (pmd_young(pmdval) && likely(vma_has_recency(vma)))
+			folio_mark_accessed(folio);
+	}
+
 	/* Present and device private folios are rmappable. */
 	if (is_present || is_device_private)
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
@@ -2504,12 +2512,6 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 	} else {
 		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
-
-		if (is_present && pmd_dirty(pmdval))
-			folio_mark_dirty(folio);
-		if (is_present && pmd_young(pmdval) &&
-		    likely(vma_has_recency(vma)))
-			folio_mark_accessed(folio);
 	}
 
 	/* Device private folios are pinned. */

-- 
2.43.0


