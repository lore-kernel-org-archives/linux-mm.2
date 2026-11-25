Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4C4606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xd9AE7iW
Received: by kanga.kvack.org (Postfix)
	id 626176B0B0D; Wed, 25 Nov 2026 17:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD616B0B0F; Wed, 25 Nov 2026 17:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513D56B0B10; Wed, 25 Nov 2026 17:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26ED86B0B0D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:37:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE50780174
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:37:12 +0000 (UTC)
X-FDA: 85475103504.11.5124145
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 05450140009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:37:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xd9AE7iW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646231;
	b=C9P4PesCZ4Lrdt96Cpsuvd41UtSYj7X8Waf05qoiUMpZRmyFcN68h1opRVltYigQLDU/p2
	kGA4ip4C2IJZ3QiCyF9yS1zksCBIr6vCljBdPJwQHX+sQ0eipPnff5iBiJFo4mXmf5629J
	j8S2Wstgcjhyo9xZe98wssI7eo4Pz5A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPv00HXBHGcnrHwnYYcnQWrnezJpmZjmRwZVDwpJYZs=;
	b=g9zSnAK9e6D3W4QA9dYMC8+vE5YeVhd9u7fN453e9EBA5RYyqGxgMW0UT5yVdJNX5O6G+/
	FdPX+hhGYYTGvZoRo4wPqs1sPHDKQbVG507znLCami7GaeiPYpMtWgIZqMIkdH+Yfmmw6k
	9WsYgc61nf+JIgebyeV2gL06spsM8/Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xd9AE7iW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9387662F34;
	Wed, 25 Nov 2026 22:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D821F000E6;
	Wed, 25 Nov 2026 22:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646230;
	bh=LPv00HXBHGcnrHwnYYcnQWrnezJpmZjmRwZVDwpJYZs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Xd9AE7iWYslCbkrOtsacMp9S4QZka9TCU/PTNwIXNqVICw0J/mz8SeELZNUrsWsMT
	 i/3vqUZbMVdkv0i5UiOE913bfUaSAUQrzbUx7YHK3OM+bJdIdQ7pb8HRwU6UdI6bh6
	 6EUZDa6zh9fZYGiDDzM8RsVCOVrKdi5kK8sqsHLD8b9TE7IhDNAUKZsZS/jTCC+4AD
	 cplOKfhFhaAxb6ucOMt8Gj1rzz+Pkf3t1NXhNp4bsAuYXFez+3IQ24oLgM0J6pSfAr
	 i8fkUVtfgvdIjIjTpmhhU4RDqv3dLlNMkJmSN7ELsHi1pWuRZgWvuAWV0v0WYZvKNQ
	 LePKrkoEiP4sQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:12 +0100
Subject: [PATCH 14/21] mm/hugetlb: count migration entries at fork and
 unmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-14-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2527; i=david@kernel.org;
 h=from:subject:message-id; bh=irf5GUIfBQCl4azbFe2lzFg+Z8O8lLWnIpcOG+Ooqq0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1SvdCdnH1Dp2q7waYJMTTen2x+d5O1NyinbLpRf6
 W5U/vGto5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgInYpzMydFg8+TjFoIT7VpSU
 tBrv042ykYeL7ydm+z+7c6d9n+LzNkaGntqIqXvql15JSA76aLPu+95pOXMftDx2bRd4nGM2NX4
 qLwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: oxz9kwobqxab9chx9zqbcymaidrj8km3
X-Rspamd-Queue-Id: 05450140009
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646230-580121
X-HE-Meta: U2FsdGVkX19nd48SbBkdnPTqoeJPWVSg8vWovSEDw/0ewHh4ZsUnN0ZPAhb+45C0RTBgE4FxMmJL6Z5kJZa2fkp2eahI11qitv3eH6jGQLmAVXXElyFwRta74Fzdv3utJcYBmsoxucfbs+frmgjMbG0uXO1QGKOeEqcnN7QZLAgCX7hjSUpB705cQrgB6tL4hM3NC26839+UnxtPK4i9ANhv5p4Pf8872ETy0mqR5yWgFZKCEYz0bDXw7QX3TcdS1P2TarNaa6TJG65gTx/vGxn+ct5y2AHyF1NMRPoIauLKZ/KCDfFY0ywnGPkO68X4FxLOHcASe154f4xFp+J/Sef65jiGRW7aN7BGoBGODZgcHtsXwi7j/rC0cTwag1Ex0htmhyyOio2qIK4FA/Zz5hvxkKuvC4fERCIxcF7H5PudQoaWVAyq84enziWM9fO3OlMDUpPJqOR5A3d82gow8zZJBPxrDzktTrsu0/idUAtcNtge6Z0gZN0ZgYQgQM+FqESS3TfwG8bABKqYf2P4z7TMzfmmU+d14aW9KCL31UEx8EMXwhSWJ5I7syxY4ox0+4tTGHvQf1aTQYd386WBqiE79MpLSTXlTGP+xp1hhTl5czdoKyvRBWu/gEGU64v7de7l9cbbKN1wSq4BXUNdrd/qAoCg42Sh6/8hmxlu/vYAWZFluka6HCUpRuMA6TH4T5Ys3mRtIfYt8HQMoQ/1jGz/Vxi2vlkn2MzG2lVCczUgPEEqmLgjmTJXj4KBfniPBKAYv35/PJ4zLnZ12EZSDC2KemtAQU8+XhLY47nSitnR1zPc3Rsq9a189aaaIkP5yIY43AwqaXVY0N2oVlCAXBPn6D+0ZLG44buswyHMaBatn/dZsUiFDcyrjqZOHqnARCQ2OFiUHKzDnLexXOn+qahcrfdIVolGzhjVgp8nUuPq9ihU4yeSgXE4qMerrsrxD70xFaHBfBP+KBo5k4z
 Kk+u4H+P
 zDdNwjZE4Jr9PfQAYCkNJx6E8FASuv835LhmQ69dou+wVE37ESNAFlKFJ2S81Y9Z02ozwuepGOm7D5srV6fwUPFawgRnpq7AEDtBRLQQd+oZlvR3+GNn4fRPvCXMR2ntrhitQ4KhComo8kJxAooPfhPSukARreKy6has5C3GFAW8l/caiJyiC9xImgOtk82O6SZ94WD/HoXiVbwrMI8kqy4eWnjUCLS2OdFK12J2NzIdzEgCBnmCc6r+oLU6H6dKb/wvdLGmNhKgLO1GzfoVcPI+xVoSdntDRi1+m6qK9BrYq0JDljYsR/taMhs8JZxs0DROABPLIwFaPNy+x8qNQLVBafuBSfF0nQDpUP48n6jKWTYWfGNRsgabt6ExGpvmgwMHWphhg3F8rDVVy/rdtYA0RrwI0UXkLWouG0/KqZzqcQFG9JMcbiQzD/qzAasvi0njYwXCVp9VgafRNFYb5P9NkuNEybqjAfFTHiD/ld9ipSxUpT+KwsYBOz6kUZpW6CWfZ9hjzq4NWAciZjIj0IDdYA+1y2oFlvd6y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

HugetlbPages in /proc/<pid>/status can be wrong, and even drop below
zero, if we fork() or unmap while mapped hugetlb folios are being
migrated.

There is an inconsistency: when installing migration entries we don't
adjust the counter, treating them as if they were present. However, when
copying or unmapping a migration entry, we don't adjust the counter like
we would for a present entry.

Let's fix it by adjusting the counter also for migration entries in
these cases. Add pte_is_migration_entry() like we did for other softleaf
types already.

This has low urgency and given that this has been around forever and
likely nobody cares, let's not CC stable.

Fixes: 5d317b2b6536 ("mm: hugetlb: proc: add HugetlbPages field to /proc/PID/status")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/leafops.h | 11 +++++++++++
 mm/hugetlb.c            |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 4c1476ae32343..c315a3531485e 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -587,6 +587,17 @@ static inline bool pte_is_uffd_marker(pte_t pte)
 	return false;
 }
 
+/**
+ * pte_is_migration_entry() - Does this PTE entry encode a migration entry?
+ * @pte: PTE entry.
+ *
+ * Returns: true if the PTE encodes a migration entry, otherwise false.
+ */
+static inline bool pte_is_migration_entry(pte_t pte)
+{
+	return softleaf_is_migration(softleaf_from_pte(pte));
+}
+
 #if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_HAS_PMD_SOFTLEAVES)
 
 /**
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2bba0940a40d5..89d71e3dadd77 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5131,6 +5131,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			if (!userfaultfd_protected(dst_vma))
 				entry = pte_swp_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
+			hugetlb_count_add(npages, dst);
 		} else if (unlikely(pte_is_marker(entry))) {
 			const pte_marker marker = copy_pte_marker(softleaf, dst_vma);
 
@@ -5480,6 +5481,8 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
 				spin_unlock(ptl);
 				continue;
 			}
+			if (pte_is_migration_entry(pte))
+				hugetlb_count_sub(pages_per_huge_page(h), mm);
 			/*
 			 * If the pte was wr-protected by uffd-wp in any of the
 			 * swap forms, meanwhile the caller does not want to

-- 
2.56.1


