Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0818606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n7/dh5mI
Received: by kanga.kvack.org (Postfix)
	id B21826B05CE; Sat, 31 Oct 2026 05:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5FA6B05CF; Sat, 31 Oct 2026 05:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998F16B05D0; Sat, 31 Oct 2026 05:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69F696B05CE
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:44:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0606F40939
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:44:27 +0000 (UTC)
X-FDA: 85382436174.04.5B60B0C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4BE271A0007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:44:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n7/dh5mI";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1+ekpwjupL9b9pcbG8pHLIAFF7Z8BWbgINSpSywcxE=;
	b=fssZ27RU0nbSOmotIaoEdnSVDqFlfEM8P3PgSv/OWFTyVNUWpXqoNXpv7EyurZewHOqRK2
	1eNWtxT5H3SRNI1LDeamMJw/9//7FTO3fxnRe8VRJFqpStwoEDoP8VWbdq0LwH6IXPNq7e
	rNEAgF5IwukvNta9XvWHyTLJX5uG01A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n7/dh5mI";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439865;
	b=z1M8H0k+HvPCh75VNhVOvq6++O+Y4XWZaaeNgBUk3BJHg8B6rafAgnEulcE8pP0VKRAphj
	QA3BmhInk5iHceEhgb7TnepFwEP+4FS7KiuiEiF5gSAXjvTqR0I1eIUd2+CRW4Jzt9JXXy
	UKsXbK9NKrxjR5gcTLtRLBMkTwYMdXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E864C600D4;
	Sat, 31 Oct 2026 09:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE60E1F000C1;
	Sat, 31 Oct 2026 09:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439864;
	bh=v1+ekpwjupL9b9pcbG8pHLIAFF7Z8BWbgINSpSywcxE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n7/dh5mINMOMUKO95+gONTx2Ve6Y6XcCPT+ZM+iwTwMTHVAeaRgrXb5ptLGRbx6IX
	 HzK5Jp3M/dpYJrf4RMfNYcWQgTq4WJkZ7HXkJS42/48ivty7LdE+IOxpHHeTr0z1i4
	 zWePStQ24ycM28VhK6H9XTW9nXaf6Lpb7uPvj5uNMIEsTMlzWR0sC5wgghJ4aOMSi8
	 Kna460upm7RSYrBeisDazpPPtMuYKG2Nf7FkLefEcjo/GjwUiOdmNwc66mNiD22Sfb
	 qFDkujgq7nV/wInZQwbFn6JzF+aKGFfRrTHfoOsRIxGN2kVPc/nK4gg/uujXWCSmEz
	 aLn6q3dxzkAhg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:45 +0100
Subject: [PATCH v3 16/47] mm/khugepaged: fix PMD table lock leak in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-16-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2443; i=david@kernel.org;
 h=from:subject:message-id; bh=zTm3MuB5zSsRWepSA3fPzqAd3nAG68NQj/5HuMoa9lA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk/fbs00i68oY9Iep743yuyx9rcWbHl6/l2C6Hfj2
 sv/HrJadZSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRZEmG/6XFYhPUGzgPZi+s
 62xe6Zsbd2BN9O57u295RvibSO1TPcLwV2DOwbcpy//vEVKP3pJ28u+ybzLuB7gsfe+ySn/tXB8
 0mRUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4BE271A0007
X-Stat-Signature: ou71jqigwxiii9gjxayr48hfmhmenae8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439865-907967
X-HE-Meta: U2FsdGVkX18gwH56dBZry5b/c/FnPlRhkiua+AK3KIFeYockoZjzE34uKpf/BnY8kJtBQtIJAN5JpjeUVbVfnGBVEqLDwfSIsJ5kxZBWBfI/oCGgdD4isR3Slche2qHUxojJi1Xi+w6gvvms49YqoPl7K6Wq8PP/OG28bdjkeXLBLfjhWu7FEWQzi5mS7NeAkgitmCyzD5DPJq+NvTDKYaBN7X+KwJQalIv5Oe2Lk76qqcxrUpIGcGgMxOZxObVwkvjvwiwxhj04seGGMZ1+tc6QIJRYhR34d7xXfUsgguu4sODOUdb39xLrGlteDDYz+95FGXdzbcSng4Yi9lF7Xo7d7mCKThBs5IlJ3bm/DOD77F4B99l4f6TLsJwvqm7k7M0c1jQmafoVozQ4z7Uq4fYj4qB3J/SknuDgIa4503l96kTlsx6DzqHE1D/PAmbymQ2IbFpsBGUCABhYU8KZBrOmWK7sOpSHRbI1f/tUsApnOWI/O7aWWaP+pze/WdLwlQHeSHmPj/SliqNMKDQ8XsMkp35DOEOideNnbNOF3NgbxTI1tIhZjy3Prba/KOgwPjGlmULQPcAojhxQOdm/CRNQJzXo3y9hpvjHoFdByJwOo9hTRJKoWwpHoHvV55HGMacjus29rJ0dEQWFptZCRGfpbVuD5jpcp2boQYpWbOwzIWuO1Or9zCvhCNyMaSJlIAZylY7BbuXWRMrSHHChrcFMcWBPs9bgtv7GuzaEtemmHuMtL+o0d0uyASrGM+f3oFY0NqNI/D0bXf3dVrD030nyxZ7ycBD4SEFjdhMhtZQTtbalH0hySiXmVebVLhNGzR+B81r//uB8C7/++Awu+Chk0QqloRjfc9ocSoES1nUvVYRTg8nxbNfUTnxJlPr3QHuwZczirdf31LhxC73l04wSciCYw55XZrg3LyVqGrD3jTuDZbDmYARrUL4U10R+HMmojc/ffllgrHpFOeM
 E9brdJy+
 IuCy0XEhOvr1fF8STmaYgWRoK721+hMrcpGcmBlm/+vCYSxrygyYt4AG/joDPMBd/1X1jDv4w3ewcZztaONPR5zSYVNu9FVsswA2pUm6iMppOejliID7pz8xdGRwWXo72f8uDnBwqCbuWLQsdng6jG6b1BJcZWcYqN0iqJ/LrXYfuMThd4VKO0cPnR27pGLM99P5N/+vuFc2NDrD0R/rITiCOsbP0B7C0YJ+SOiby2rUtk54KEobXNkUJFnhbAIeiLqqBuuWmPj4wbLv7x/HXCDKqjet0PoPUpScp2a2isxTZ9X/laOFz6v9il6UpmIYxSOOF7mWPCeXJBWuNWkITzoGBiTY0e0JgTPpm3/RQo/bcZf7px3Z2lqA5LvhwnSVn0RKceZ9jYOC5cf3ErYi/78NlOQV4ovtdIu5VUNvixg9o5CDKHXrghUW67h6CZ9GPF/NJNjYAeWjShTsuW5tohsqJYp0t1xjgRqZlKi6nRRZ3qGKz2avFY8kC7wVJx10B+bKgxDaQ/20prAbOBwXoAR6Vkcewus+pADDe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

For a private mapping with userfaultfd, try_collapse_pte_mapped_thp()
takes the PMD table lock before it maps the page table for the second time.
If that (pte_offset_map_rw_nolock) fails, because the page table vanished
in the meantime due to concurrent page table reclaim, it leaves through
the abort label, where the PMD table lock is unlocked if it differs from
PTE table lock.

In case the PMD table lock and the PTE table lock match, which is the
case without CONFIG_SPLIT_PTE_PTLOCKS after pte_offset_map_rw_nolock()
failed, we miss to unlock the PMD table.

To fix it, forget the PTE table lock when we unmap+unlock the PTE table.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: move the ptl = NULL handling; rewrite description, drop wrong comments ]
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 81496887d827e..34ebb37c862c0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1904,7 +1904,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 
 	result = SCAN_FAIL;
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
-	if (!start_pte)		/* mmap_lock + page lock should prevent this */
+	if (!start_pte)
 		goto drop_folio;
 
 	/* step 1: check all mapped PTEs are to the right huge page */
@@ -1935,6 +1935,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	}
 
 	pte_unmap_unlock(start_pte, ptl);
+	ptl = NULL;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				haddr, haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1952,7 +1953,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		pml = pmd_lock(mm, pmd);
 
 	start_pte = pte_offset_map_rw_nolock(mm, pmd, haddr, &pgt_pmd, &ptl);
-	if (!start_pte)		/* mmap_lock + page lock should prevent this */
+	if (!start_pte)
 		goto abort;
 	if (!pml)
 		spin_lock(ptl);

-- 
2.43.0


