Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95672606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c680gRXN
Received: by kanga.kvack.org (Postfix)
	id A16746B05E1; Sat, 31 Oct 2026 05:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6DF6B05E2; Sat, 31 Oct 2026 05:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88EF46B05E3; Sat, 31 Oct 2026 05:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54AAB6B05E1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:48:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E07C91608F7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:48:36 +0000 (UTC)
X-FDA: 85382446632.26.B023565
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2639B1C0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:48:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c680gRXN;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHe1ZtAJayVrktC+oIcIv9hMCqgNETJjHBAQ4hVj50U=;
	b=KCzBN+LrYGvTsrjnngJYJ39FYy8ypr60EOwo2RZ2zEHoZHnZYaPDpLEVlIHF/tsv7yvROG
	JxoN7tIRaEUm3qnj+wN+CsoW/CILmACplVfqCthzTJbhi2qAKM3Le+Hnz8Zd+mydswedES
	UzsEWuptMDzJizRqcMXpg5+GpNlGFxY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c680gRXN;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440115;
	b=16T/zGoqWN7tIgN+MNv3gnCZjRG5WnSyojwUHL1wJPgowELjIcEd5g2Z3ZxjymMio3n0D9
	B0+Hcldplsxaf0qxl86kiHueRylw/+GCSkD+9kdjJ80RqCIw6hCPB/M13d4MwQlqxgPeWF
	qdBZECL2wMT8InhB9pNcNjRvtNEn4lc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB26D605CF;
	Sat, 31 Oct 2026 09:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D8F1F000C1;
	Sat, 31 Oct 2026 09:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440114;
	bh=YHe1ZtAJayVrktC+oIcIv9hMCqgNETJjHBAQ4hVj50U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c680gRXN1S8i2NWT11+qqfJhCsH6sZm3Lgl8IeH2hJ2aV1qzLZQtIe8ZB/S0Y8M4u
	 fN/ZfkmGKaWRQLUfNH59CwiDPnl5tXhgo8CD2EYJIAEsLtjBm4rRe8GJm38fmOmjuL
	 FFXv6XLkluWIuC2aGtTKDBtJbzSA3zIsT4UjaArwgZp431mebT1HiG8P+W6A5AvJ1j
	 xyMsVE2U0KpbxJPGXkloi1TT6aBkxHFddiVm/NixvrDnNSFKwp2dWiy9scRGfSCgIf
	 5wyb9blmNExkoGtL0VUhhBQtgKS3NSi9uiCInnqcR5ifvCRN0AukPxZBsAGRbFB6tI
	 Ngi7/1neI9RLQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:01 +0100
Subject: [PATCH v3 32/47] mm/mremap: fix moving PUD leaves
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-32-d6437171ecc3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2279; i=david@kernel.org;
 h=from:subject:message-id; bh=yDC0RTefMrDLgTK9qV0M/e1RR0BKaMeuZ5BjV9QtmSQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs8MndYZbbZZdftFjSuZ9ms2y146fHvrmjOOU3Uzv
 mccUXBe0lHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEjn5m+KdRKHbDdvvW6CkH
 kuZtmpttl3HlxIzcUG8tAf0dp2/k94YyMpwP/WSvviF49lHx24JPNvidbp4Xsbt7e4hGjZWt9ek
 L75gA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2639B1C0002
X-Stat-Signature: 5x1qqyptci4jhw4ybgs1abjesh7phcro
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440115-26597
X-HE-Meta: U2FsdGVkX18lui/jrhuDLykoXibZ83/V9x9+UC2Achn3E3eZGYfEEORb8qEXDYhxM2GZRL19syrJStZ9P6z91BkgDsYbhwEFoMdRbI1UFO4Ae02qhaEBBhuA9+JKjTm1U5EF9p9r1qJokseXW+6gxFHPxjlyP0WLdFxxm2+1BGtW+v38k9OCo4k1BNOWBGfpEendYVDhEGh5XKJ1W2LOx4P01M2ru8MOxySmXtU6uJ0MIACTqt+kBSreFPD7V4k5lmPc1HHOsJyfbtyqYsn2ybtv5zxHc+E+ssknJGK/STF/3eXQRxknRY8+yqwcWDXch4YVpNzNtQEP1nhBfIyN4zP03CyjLEPk/ueaOXcQi0GF6ubiZLuNtgb/GtOWxdAXOOJtFwqy5Z7niyDibEnTRUNpcRjYEu7faGjcqE5XHYzZu/kgXxKr7dI0Zbt87JJflxLrZnFYcOBC/RhyIn2Y+NkAOziuPOS/lHVb2zpYqKSi06qIIrz/FDzSVOfU2KkFz9hDm2BSi0c1VmWvDQEyO9p4lAPauvvH+m6WVyLSVH7/1o3tD85WXoySDB+OF6Cz7v3kxmmBgN/2M3GPXgfHCKygU4odyol/8E5ENnU5IpZiP+2VmplKK/Jp2w4YZOQRFUpvAHzEUtX2rq69GTLypLHKivNoxVGUYE3M4s2keUd4ig0fcpikcDhx86M0OI6a/ex5EfTbE0+WdnWanBm9CHFiKCDCnxB7TyRxBFa5FJOHd+essDsZGpB/NiH89gPxJySy8OGuk1WbI8lchkg5gr4BDZ/nsTSBsklez+IEKEi3RfD6CnBO7/QaKsOW/NQJ3LDEmKv6fFGxnW42rW9KklxeI9MC1ZrTX21N0liRFKCYni3LMzn6sKZiMBqapbasUEwIHnmutZaS/MEP3K7Gg3hnahViS9BQQwph8ynrdzzLyFM7h37ND6XbqWpqDMWq+B1QFHrs7cYQIV+Q/A2
 2+YvU/x5
 JYxnCtjC/3YFcDtF8MfJXzqdRc2EgtwU9bBQEwx+P1EdlKuLweW5NWeyaKhlJV1+MXpV1KF2B2+9tKMhkpX/oLU+tdsLDdPfQMwmwQ9uk2OHsdn/NbujFcW7Jt2KMkKbIe5VX6c3tCPfZT6NsAHIoqmLCPzlhfa/QnYyWGP5dP1RZ7i5yymbNDH48BH6Y2dhAzBzUyfbJ2h+FrMTIqhuYzKMT1WZx6d8FFmRmTXqw2MLgcOARWPj2QayDYULBlNHQZYa2PMqF6lvqgxs7U55jlWDQ9+9hmL9fzUSMstz9jTH+94Gu8ry+cNwtgXK0sasLS3hFNwyBaiLeH7bUmpS6an4KRhkOBzclK1CyBd91bufn/sFEkyn7QDQ1SoMwD1PZvYL9haIV0VgYXzjOXtYeDUcVaiuvp2oAZxmvDO9t9ukQYdK062/qk/T2dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

pud_none_or_clear_bad() only really works on page tables. PUD leaves
confuse the check and make us clear the page table entry and print a
warning.

Since commit aed877c2b4257 ("device/dax: properly refcount device dax pages
when mapping"), this also leaks device-DAX folio references, mapcounts
and RSS accounting, resulting in "Bad rss-counter state" warnings on exit.

Allow PUD leaves in get_old_pud(). If a PUD leaf cannot be moved as a
whole or the move fails, split it. This unmaps it with proper accounting
instead of treating the leaf entry as a PMD table.

Keep using pud_trans_huge() for now, in the future this code should be
cleaned up to just check for PUD leaves.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: fallthrough after splitting ]
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 91f0865f6aeea..1237718848f5c 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -87,7 +87,7 @@ static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
 		return NULL;
 
 	pud = pud_offset(p4d, addr);
-	if (pud_none_or_clear_bad(pud))
+	if (!pud_trans_huge(*pud) && pud_none_or_clear_bad(pud))
 		return NULL;
 
 	return pud;
@@ -847,11 +847,10 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 		if (!new_pud)
 			break;
 		if (pud_trans_huge(*old_pud)) {
-			if (extent == HPAGE_PUD_SIZE) {
-				move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud);
-				/* We ignore and continue on error? */
+			if (extent == HPAGE_PUD_SIZE &&
+			    move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud))
 				continue;
-			}
+			split_huge_pud(pmc->old, old_pud, pmc->old_addr);
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
 			if (move_pgt_entry(pmc, NORMAL_PUD, old_pud, new_pud))
 				continue;

-- 
2.43.0


