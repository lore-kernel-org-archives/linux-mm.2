Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1F8606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIuxTTI3
Received: by kanga.kvack.org (Postfix)
	id 1AA8F6B05CF; Thu, 29 Oct 2026 16:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182566B05D0; Thu, 29 Oct 2026 16:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B196B05D1; Thu, 29 Oct 2026 16:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0AE56B05CF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:38:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58981140519
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:38:13 +0000 (UTC)
X-FDA: 85376826066.25.41E6E28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B7E44000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:38:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIuxTTI3;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nj1Bf9db8TNcajGSKnb6DbuHi/phVwkCDM1cIZai6DI=;
	b=lB8lbiOcJ0jyjxEWwBema1U3AF1J/bsXKJZIy2nKt7oiLjtk34kzJla+8aLeuWz08dV2mf
	KJSIIyZT/XIhydVMulbhskNNP+uRHcCcEbrlUGeYGo2xKLY755ZuD9XMPuoAUyY2EPE/Dw
	B07ZTkb/nVC1zvS43y27hRon64SbAa8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIuxTTI3;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306291;
	b=w+gzFIarb6MfTFd8aQylBR+11Nsi/0CzDiSL6cYiYRK+rwSoPxf5bqZVmmcDSHy7JlPNNm
	Q0VMfoArg0FuY2/9HLceqqpv0MG9sD0T57gwJON2xOK8doujC+d1iGf6Q7nGKPONMwYThy
	bu2V8d6Es3N8N9wWWXt4zwV/LzCgXrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A96140F8B;
	Thu, 29 Oct 2026 20:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE841F01825;
	Thu, 29 Oct 2026 20:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306290;
	bh=nj1Bf9db8TNcajGSKnb6DbuHi/phVwkCDM1cIZai6DI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FIuxTTI3C9PGyWVFGo4s1b0dkDlzRfab9Rj6I74MTLycqi+2Em6LiHU/uAvrS9N2K
	 H1lysuB2CyMvu8AUoaV21WSVGPL5xMuFv701vHfyNuvbTOqOVl1Mb27qjgobqyD4Ih
	 w521JBB1DU2+1WGBmfWNyNI9L0QxayWIoR/35/8S6lbTgqbOOCRUYTrMQVyzhih2Uy
	 5YOZ+Uv9eZAqw/sFSkR0LDJjCsJd17NT85n8UbO6chx+PkSu1BaBgYlPYiLxlSRP0s
	 YNrqZmF/rZnmJY1dOZd/zKWR/IT1NfuAz2jIJEzyiNNCuLG/4f2hBHEDIvx0IURMf/
	 8vhdjMEwBOimg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:14 +0100
Subject: [PATCH v2 19/47] mm/gup: recheck the PUD under PTL in
 follow_pud_mask()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-19-a64ce7f83abb@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3795; i=david@kernel.org;
 h=from:subject:message-id; bh=PWJnBAFtWkzROraFyD6718GFghC4dRBvxtyaTiDuAbI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer23rib/wxOTO+QCt1Qe9WZRKlh48bPQzJd5VePoC4
 U+SnnmGHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzEjI2RYcKTwxteKM7pfsr5
 l+9Y52+mDR9eFry6cu7nmmdGkT3yTnmMDE90/nzPfmm/TfZaV3vaLZ02o7usjFJSH3c4GdrG75m
 0hBUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B7E44000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: wbda9c8uti1xz4jq9jpb1csoh44r11pc
X-HE-Tag: 1793306291-586254
X-HE-Meta: U2FsdGVkX18bFxb2xk7oRdEV1Arbtc7ALAGAIYmTulwDoiBSR0+3N5rCUEYsu9vtnj+RVPFsWkQn1LVK6xq7Otm0lIHNE7zQn+GjUT3sQAMkzXSQxeisjGzmYkzzfGf4CAd3d1Jne+ZCdKghJrd1Fds5V4IQXGwvom3oAt/+ibNl/ELKj9FMkSUpfYF/VBNGHxtJXfkyuLG5NtkvkwKL7rDIgexCx8DQINRzCJV0mYeohZWZyLaUwZdCNWTmVDFjx5yr9E3TnU0QXpBLKplrZ/WgBr/inJBMnk9g5tpjP6P1N8RexyHeWlBlUKIDcmvcV/muViKuJEhN0YYD1YdPUc3WW9z98CCzzzV9Rl3lUCdRh3vEaZSei6SzpGF3YNtQGkJRaY7y5lRym9KapFURB7Ckxg/dFOolDmcpHW7ZNLU0m1zAD59iKTp3D46eih+9EOMwofzbWFFG2HUuBikHmMEITy3niRD+Tpw3l+KNdiX4/zbdhWmFkdLJOtwcqT9Bx+katGWiC2wbfBhBuzE7TY97+r0vneJWTlaUWjWM9tiZrYvxPcWXtXI68sjPRL++qQeozHWluwLzAf1XGoLMmttJGuUI6ti8jSS67Xp7O1tKU1KFE+yFM/uLm4KMN6bFM3l75KGOUWpCv0LM37EFL0PQWhlRKUksCZQoRyTAYdDv+A/m/QJSAPDuwkheh+VgW9jMqRwMyNqocz/u7qNGhlq96rzePsLfv4sNRUD3MAygrthp5Hp1PBgTzcf3zGInhEqwptgQcuZFhMrm8MIR+OwsS/bgaQqzvWnxXMG69VgyPEXcppQ9M/9xOqIO84u1naNsmGG5ISqACEFd0qXHiu/Q8Eun6MDdnDnU5iyquYFKfnkFk1RfYbMqSaXPn04S9+NhQ/tgMatudySg5N112jbs7mECmmEWOCKUnMFnqnKmjO4FuRk6UKiIn2vfyuXopWy6HVQn+OXK/XdxoqR
 deUD7ySX
 nOGfEgriKSBU0Ce2gS3iiV4d34BSTl0eAYni0ccuGgr7CR6tRKaBI82q+1i7OFhY+jw31BfQ2iXK3b+aIB6tviZzmLWF3yNqJd9cVkiwz5zYrIvpxdjx2Amt2z8CKCdF5AfK4KS9ew76Vu+2ZdnQU6R/qTVvbe2UIvGlkb/Ldgbmhi1t/caNOQyAIfQ9xexLP9xntWDDzBHnsC6fMsjjUU4dlDQYUcVfVEu4467iCBrK2RKgCwJtvJ2Wz8SIwBJsdy4Cagm7YFAZJq6pPTgLeYDdXi9jCD3afEYZVSgdqIBtNQ51Ixzmw85+SWFHFsLTK2czg5ss0Bx9WFtEbuoVt7FM9p2shrBY84w6X66SrXSgo+R6p8jTDvwIPF3t26dNoVdkQL+PVPm+nHvjzDtvDmMuGm/bzDQ1K2y2bTFxz/kggCWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_pud_mask() reads the PUD without a lock. If it is a leaf, it takes
the lock and calls follow_huge_pud(), which reads the entry again, but
only tests whether it is present.

A leaf can be zapped concurrently and a page fault can fill the empty
entry with a page table.

This currently only applies when device-dax makes use of PUD entries,
and the fault after e.g., MADV_DONTNEED would find THPs to be disabled.

That requires a sequence like

1) Fault in the PUD
2) Disable THP
3) Have GUP race against concurrent MADV_DONTNEED + refault

Which is rather unlikely to happen in practice, which is why we never
received a report about such a problem.

Before commit 1b1676180246 ("mm/gup: handle huge pud for
follow_pud_mask()"), we performed that check in follow_devmap_pud() by
testing for pud_devmap().

Let's fix it by just structuring follow_pud_mask() similar to
follow_pmd_mask(), minus protnone stuff that does not apply and minus
FOLL_SPLIT_PMD handling. That makes it much easier to spot any such
inconsistencies.

Perform the pud_bad() check early in follow_pmd_mask() and just forward
the PUD value. We can drop the pud_present() check in follow_huge_pud(),
just like we have in follow_huge_pmd().

Even though we are performing more changes than strictly necessary, the
fix should be easy to backport.

Fixes: 1b1676180246 ("mm/gup: handle huge pud for follow_pud_mask()")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7d43ce717b24..f809361227e7 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -658,9 +658,6 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 
 	assert_spin_locked(pud_lockptr(mm, pudp));
 
-	if (!pud_present(pud))
-		return NULL;
-
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
 		return NULL;
@@ -896,15 +893,17 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 }
 
 static struct page *follow_pmd_mask(struct vm_area_struct *vma,
-				    unsigned long address, pud_t *pudp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+		unsigned long address, pud_t *pudp, pud_t pud,
+		unsigned int flags, unsigned long *page_mask)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 
+	if (unlikely(pud_bad(pud)))
+		return no_page_table(vma, flags, address);
+
 	pmd = pmd_offset(pudp, address);
 	pmdval = pmdp_get_lockless(pmd);
 	if (pmd_none(pmdval))
@@ -953,18 +952,23 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
-	if (pud_leaf(pud)) {
-		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+	if (!pud_leaf(pud))
+		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask);
+
+	ptl = pud_lock(mm, pudp);
+	pud = *pudp;
+	if (unlikely(!pud_present(pud))) {
 		spin_unlock(ptl);
-		if (page)
-			return page;
 		return no_page_table(vma, flags, address);
 	}
-	if (unlikely(pud_bad(pud)))
-		return no_page_table(vma, flags, address);
+	if (unlikely(!pud_leaf(pud))) {
+		spin_unlock(ptl);
+		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask);
+	}
 
-	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
+	page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+	spin_unlock(ptl);
+	return page;
 }
 
 static struct page *follow_p4d_mask(struct vm_area_struct *vma,

-- 
2.43.0


