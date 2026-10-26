Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB56606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XfqLS+Hl
Received: by kanga.kvack.org (Postfix)
	id 193086B05B2; Mon, 26 Oct 2026 19:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B0A6B05CE; Mon, 26 Oct 2026 19:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0819A6B05CF; Mon, 26 Oct 2026 19:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D60316B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:23:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A66E1A0895
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:23:17 +0000 (UTC)
X-FDA: 85366355634.07.22DFE99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9B09E4000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:23:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XfqLS+Hl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1JYyOVK17L4M/YeGKfhk/Lxzr76gDTGDeCEv+yAeac=;
	b=Y6GRAHD3qJ9LogV50JV0WNWmd2NJGDJOfGg1BODvaadQif0qRWfHsvSWMotu8xsQPeSa5a
	q3bJracVwLmVzvPrOMbEKjcwS1z/AQAAvJW4PWywhRDZdzZkb11t2IMmxIgbLmAjeKNDDE
	QOfhnPhTBwmHu+uQbEqP5d6IWcHai3s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XfqLS+Hl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056995;
	b=HNDDrvXejp3HGFfSi4nNk0vOvDqwlK2JbNlsFXVyf1R9cNBuv1tKVaaME5GQAAeYiE2GeM
	Xs+QLg0Beev/kgZ01+3Ub5CLDMMiijt1bNwk7d6hqBmzs9HpN1D4d4NTgiZNbNWbJ0hrLy
	fDZ3cIqnbzOCSmBSfHpp9h3Ty7+Qui0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF9B9418A5;
	Mon, 26 Oct 2026 23:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4086B1F01829;
	Mon, 26 Oct 2026 23:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056994;
	bh=+1JYyOVK17L4M/YeGKfhk/Lxzr76gDTGDeCEv+yAeac=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XfqLS+HlbsjgMnNRoaz++2jtQC1Na277NB03VKlGtUyrHgM+UcBK81mvCEQXk6SEn
	 uoUWk/Y0LokQHfua8ALu7xo3TimdxKbFw+ync5x9x0414hpGK5euj90aDiThH/i2g6
	 gltMFd0YkJRSCGbzjhMIA1svIJg0OdjzS+VJrfdV55Ru5CcTX1Km3zOSH9bit+hmH0
	 nXtTvSU+BWI1pGaDlkzv7qX0PMn63J0KkAM5JF7EYYmHtIGdHKXb/weVqb341vnhNN
	 LtvoefAcxQzn7M5h/ljiIxS0k3AY0Dobha0DvHSvTN45tBuUaJN6bUn9HpN5iNYDaL
	 BChgtuF/TGxrw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:37 +0100
Subject: [PATCH 17/46] mm/khugepaged: preserve dirty bits when collapsing
 PTE-mapped THPs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-17-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2036; i=david@kernel.org;
 h=from:subject:message-id; bh=/nGuewYAfnIDGwfYFGkywdM27AcdGHIuhx2sh7J1pmM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/6OOtCmHDt6RCT9t8MvwO2SXtqiyk4FhS5aFTuX
 MPD2Pu4o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgInszmf4Z8e1UOzQzKxPdqpf
 L849defDtaQtSYFsyhXzPZYxX3zefZDhn2bE7/KyvsKAtbrnVr0+WPQz3O36FpVnmdnVGpfN+PP
 n8AMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 9B09E4000A
X-Stat-Signature: zty6yqdegaamsi3pb67hztq3tez1zdqe
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793056995-958569
X-HE-Meta: U2FsdGVkX1/VltNDVqsTp8PBLolwvDBOzkIpwcvb5SQGe00nm7nUfvblnQF0pWzfLG1nmCK8Cx1PFMOOTsQpCT5Q7cEG7TBTKoL/PsAA6JmSJGk+ikOCZAPhFSuYzlAHqr9Xivl8l1H8Ubc00RFnUuklqAs5NRw8V8xr0Pf6AA/K0TUpYp7J104iElWWa+YlVQd3Mp9lFNMobW7JyWYbCNUCrc2vtoyk4x8uoZBulhLSKpqCX3uLtTTLWNSe/fjm/R8w0axIwsNOlO9TUDTTogyKAHmGeAgylNcjXRxE0F78nm2SfxrU3sE6cDgkjL+Q2LLcOuA0Gtl4kKRC/mNX1GjBaFuFleu8H5nEM7VtQnWWeKyDgDnh2F08m/cSn9iemItFCLGDVveF5/3n4+qMGP2Z272iQtcB7BjpK6UPn4DxuaDJYH0rLufLHyHp/3mtLTMWXbUn9MZVO9HREEwCCDgO6WI+9QXk0BJ6dXIj15A5bJG1vatNKvhaA8Ml60nEVzz5VeTDO8QnOjl/vCdmE8Jfbj6F5ebLKczsi3rYCffOZCB4zmGv242pdmWHsHMNc8/KcajC+jkKPoLUw3UXaG09sXTsPgCTbQATGJ2Y0Mzu+gWtZSPEDCgnk+GnnAZX9tuXCwXKMDFKHV0IWxsoY2smbV+MWqtqsBzqZpdbMrz3H+KTYYU3cV6VZulafphrdH4XI1eD6K5UeUAPuRqWbpBOI3RvEdAMWwiiDA+O8tlOT2VcaWambRLVlttlDeEKiiNdvjMawhjRPhwgWrx5miAGLFEbbKDxTJryyBnkKEnIWXOktDjaELPbCVk906Fm++tLcIg8OiQdVRK6Vd7pt1LkxDxJshXoSXlz8Smr9yqr9S7B8hd/3uwI745YlaJPIVusQ+YLJG8o6Xl2x3T3Y5Sa6FHFMuTKdsami+DT5yaA5X7ABWNdD+T4sA4sLESbLWZnAcyuBH/lVCjgUM3
 C5z7b5W7
 i3eihLDwn9K1Bf+E9FiLxNeSyB9guKS3ic3A1dUZtoIGPpWjdHUlbKZkpbv6aAO7x6YLflPTkaCA9dCweuBGMiTHUyEK2qG4yrWa+2ha6ZnvBWHX6yo2YaNsjZC/270YL5MQLDOxpfow1NOLfvFYLtX50VZET2I7gU6lFSdY/2MWr3uoysQlo0pZ/aX7kxdZVkU+N/7eBw5H3JWrphZu+YMYfqbA7FoWwCWXaEop6rJPjo6kLwtbpcNDsmyI+KO0+4yZQ9d1ykPoOYpN+b5DpXXS2MigIstVHDl2W2Hed9XYYYTgk8Vh90WlgvQ/ZU6yvQYh6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

try_collapse_pte_mapped_thp() clears PTEs without transferring their dirty
bits to the folio. A shmem read fault can map a clean folio writable, so
a later store only dirties the PTE. Losing that dirty bit allows reclaim
to discard modified data.

The assumption that regular files are read-only is also obsolete since
commit 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse
for writable files"). In any case, transferring PTE dirty bits to the folio
when removing mappings (and while the folio is still mapped) is the right
thing to do.

Use get_and_clear_ptes() to collect the dirty bits and mark the folio
dirty before unmapping it. Update the comment.

This was reproduced with shmem using MADV_COLLAPSE followed by
MADV_PAGEOUT.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
Fixes: 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust comment; simplify description; cover file-thp as well ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 04d9bb21ff524..dd17c3dae8006 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1995,9 +1995,10 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		/*
 		 * Must clear entry, or a racing truncate may re-remove it.
 		 * TLB flush can be left until pmdp_collapse_flush() does it.
-		 * PTE dirty? Shmem page is already dirty; file is read-only.
 		 */
-		clear_ptes(mm, addr, pte, nr_batch_ptes);
+		ptent = get_and_clear_ptes(mm, addr, pte, nr_batch_ptes);
+		if (pte_dirty(ptent))
+			folio_mark_dirty(folio);
 		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
 		nr_mapped_ptes += nr_batch_ptes;
 	}

-- 
2.43.0


