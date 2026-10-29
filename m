Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17544606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h9IpVMZX
Received: by kanga.kvack.org (Postfix)
	id 3A4EA6B05CD; Thu, 29 Oct 2026 16:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EC16B05CE; Thu, 29 Oct 2026 16:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CBD6B05CF; Thu, 29 Oct 2026 16:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 031B46B05CD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:37:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88DE616042F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:37:43 +0000 (UTC)
X-FDA: 85376824806.22.AAF82F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCD8E40007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:37:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9IpVMZX;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkKpOpVy4nNTHYLS6i5ceIs+WZNAThsPIEqAOiy3hwo=;
	b=UMwxN90jPg0VakpuJbmxcnOT8dzm+1HfFUs0VcaDFR8IrEtOaa+wRw5qFh49ah4XJthXvv
	dHw74XF/BaP1VtZzaBQleGITh5r4FYW7Im8gCCjUWmPSO2qdFh3SErVXPKb3AGR/DWhwqD
	316hJWrEHEtGHepZf4nYJ/VMEQe+5C0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306261;
	b=3zph90sUtdUO3db09hrWaiCBr3+PmLd+vZgBjPUc18yOEhJigBtLx2TUDBV+4wqzKxuhid
	Vo+YI/6KR8t1JpAAUBLzt6OW1EBRpMH5MiL2b9ReAmR96lTW1uQ5Y0Qzn8sfWn2WtEc8+U
	16sPasymp8j27V+CpMVEx4PKXoxzCiU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9IpVMZX;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C806020F;
	Thu, 29 Oct 2026 20:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234EE1F01825;
	Thu, 29 Oct 2026 20:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306261;
	bh=JkKpOpVy4nNTHYLS6i5ceIs+WZNAThsPIEqAOiy3hwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h9IpVMZXhE9Hn2ObjyXapG1VQ5Spd0s63yzi81dMPuivmY4xxxMaIhVJalbhQK3l/
	 pPic2KzleKT4LwVF9PdrT5Vfz+/2baBkDRwIcP/Oc6mI+rZId/hxzlKNyi/dTsIW0k
	 4mKSwQ+v7UsXIjr4p2jofqTscsM+BlLhL4mhqUDnKfM+awKQy0TDW/2GkayYcoE1od
	 2Kr1F/zEK9k3bRpeABQdrlGXkzrF18Cmys1v5Ugm1MiHJ6dStoKQzKVMlfjIZLee8H
	 WXkxH2wVlVVoqDBPYUj9HIm+ZDRGRuy5E5n3ZOa1Ax+81CZKB2cvAF3QmuDHKdINHl
	 0wl3DQs6BOgnA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:12 +0100
Subject: [PATCH v2 17/47] mm/khugepaged: preserve dirty bits when
 collapsing PTE-mapped THPs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-17-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2189; i=david@kernel.org;
 h=from:subject:message-id; bh=te5lCngEDLVmEXnC8RjOJPUhL4oSTpvZoR4pTc9h1QU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer20z2uc41Uxnho7Oqu/K//7Mr3HR43XYu/PymyVfn
 1cf+F+yt6OUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJVO9g+Ctrv2H+tKAkAT7/
 q8x6Z+YmCZ3KKxV6c8G7YMJ/v0ut3esZ/hl3mvNIPGmK/3lux+cqZ9WrXDy1/822Srj+m/7+uZf
 PKj4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BCD8E40007
X-Stat-Signature: 8fbj9y1sbzey6hyahhryhb3tkdwsr5n7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306261-855191
X-HE-Meta: U2FsdGVkX1/EL5gM3TFLuckGmAiI2UrBIRNz2MJAmv1+SRcpMnwdqbVx7MuANmL1VtfEM1wp/iFwXncirDbTc4O55z0nNBgLASKAjyB91wgobzEzKKHUJeXLqrYFfWJYCq8I5mJW8a6jCEDrFLBQOvFnOxbCvlBwtZgoqaMoV8sK0/OsnA2Spm6ohVxXeO1EQUKQwcuVX3We+GyIXib0lEGRVy8NK3zy58Kg6JEVvprK4wZG091gqazMTlUIx9uya45V1t5v+c4jSghMWrG8tCMwyxB07YsVAG0Vr8gr7RcuLr7k1AcwgtqymjPUv+jni7EXF/Sf9X7nUr9XK1LaTcwVuXg4qfyZlTtYFwgKgWk9l7L4Z28mXs99hjyQSyhulDsg+0saUkfSeH5Uj0LDTeDrJkYf8LQWbcvuoYkeK0W0snph4tAj2zpd97Y9B63w3WSh8OGjG0mu74B9rVnnwmiq6knD2ZEVNWLPnHxmaL7rCfXUzPVPppZx2JcRrY/Zi/OoG2n2AxgWPoS4A1FqzCSkchs4JZ73GRs1m1DxmpwBm/LnYH1U/M09dNeCFl6fck6MC62QOJQIK7If2rJM6Q0BFG/nWhAKmYqMuTkx1F9ZJl+La6D28S82BWf58VjRahFEtOIKcaaG+a59Cc6y2rx5LUN5HXBNalwc++Y6mkTxj1FGmPamaD10Nz77Obq6I0kM0+7+Jb+zdboSZ/F0OSMOkdpm+RZDNJNm4W8FvsU5S07jwYJMkCnfCdYy0rDMdlqOSfq9sztRY4i+EeW5AZA974D+z3k41lxyyVuFPtSSASCgDTIUkcDAzQ9ASrq4Snjtp8SaMcCiRLETqrIV2jshH2l677ZMZ8cCcebeigPiRreNNAi341H1D0ANqTZdNztvd+1FTBqLTxHFrwarqbXO49FshdTq4vaAw8H33JseSW2cQBytit38cfofMeMRXp0F31Xh4rwf/GheDKj
 12s05iqK
 MSbfTi8qBOxWvwrjh0CW1rCSdSJ3SkGsusC0GkELM3AvmZ8AvYmhilzYxYAr/Yr0O5fHKolY1sDijACUjdO4QIZWIWZFRT+vYDrlx5lfG5ukXf/u6D8m5Uvx51ZzeDGF6OXyKGnCf94UV0Mbq9TQ1eRrdTjgyG/JQjdwVN0rWu/qSpPssgfLF1ndyYXdHP1n+HZFzPHoWbIBBSPd5snf3A0tFFapeQG0UkGJtEYGIHaU+gyKa7vECtIDxGF79KvLvsVjjlKTKdmCKEvXpCudw6GkmQlV3pKjkk8ibCxqUg7xudEYi7LvVeiYChFVenUaPNLQJRaExA7tH7pw/RamqELxV9b3Vzg/4ehLpcsBeGbwtxoFpP+z36udlekLWgClKudFv
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
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 04d9bb21ff52..dd17c3dae800 100644
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


