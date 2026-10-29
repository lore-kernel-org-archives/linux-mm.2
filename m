Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E267606A334
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=edeLt9zS
Received: by kanga.kvack.org (Postfix)
	id 21DF26B05CC; Thu, 29 Oct 2026 16:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F54A6B05CD; Thu, 29 Oct 2026 16:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10BF36B05CE; Thu, 29 Oct 2026 16:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D08816B05CC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:37:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 534AA1A04C6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:37:29 +0000 (UTC)
X-FDA: 85376824218.09.1DFCB01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 764E8180005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:37:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edeLt9zS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=234gD00LbP/Qk5j9zzqqy4STm6BqPfRIm1wBmbH9iNI=;
	b=ncweEh1cdRksdAEQ5Z/GqAS/4GZLuywQheV4Q69ZJsVXttU2iJjjUfAKs9qoasHKJPJZ9B
	rH5Arn36iOIfsY5Nrgbc8RzLYid/iRKbtHZtW7HVY/OhQbdlFyrgek1+TFwRhrSB/PYIV/
	YuEDQM2hhTB1mM3pxbUgLD3nGYDt4W0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edeLt9zS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306247;
	b=nX6xbaZ1M6EPwJ9mV1ecOdWs7F1gdxIlbj2cseSFD/Dux2KI1rgQfKI2dtq+6yJyDdkyQ5
	WydlK3jT9bHhCuKD3ukNQxjYdncV6cb7SmOSxq5ocLDig2xwA0TOXuIKivLyFVpqde9phr
	gIJq6zPI35W8zcLAyddIAfGs6GhY/W0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1D5F40C19;
	Thu, 29 Oct 2026 20:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EB11F01816;
	Thu, 29 Oct 2026 20:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306246;
	bh=234gD00LbP/Qk5j9zzqqy4STm6BqPfRIm1wBmbH9iNI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=edeLt9zS7/wt/9hnNB2ETmthM71RS43pg/tv3+Z3wip3JVZEmnW2zTc7BWQycloNy
	 eiIxLdX2AHK+EIcGUho5VTaK6l3mGn1X0zTJHt1HL5v9rCLaz+t973Eeuf6OOZpwZq
	 tzpjQ6ahggUdoqQsqXxoW/WHIIkOV547zpUK6vVcyeinMHiK9ttzsEiW87eUaXbGYB
	 nnyFsqJECi9wQRjroEq+7Q5o/UeBBVUs5gLJ9jm2YeNOiFcd8EkUI59EM8WsoTFPNk
	 7toOVO78y+mRJVbYNeCeT6CcidBYrIzM+V4Q0SmKtYGNSa+6jYaaKFXHRob2/z8Y/b
	 AxJkCxCEB1CXw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:11 +0100
Subject: [PATCH v2 16/47] mm/khugepaged: fix PMD table lock leak in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-16-a64ce7f83abb@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2386; i=david@kernel.org;
 h=from:subject:message-id; bh=+GceeJLIEkYM45yBBgdZk6QP/zPFquzOdoh39+pg3EQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer23bNeP0wWvJS/X6pHY8L0u7YrDU4cqVVPcHeybd3
 /DS7Vcsd0cpC4MYB4OsmCJLUPB9g5cv19VWu/Exw8xhZQIZwsDFKQATuV/CyHAx7CXX1+3Hj39y
 +TlL3JavOKg2cNKBuSrRv73q1jxe/4yf4a/Uz9D1Sdue6uUISi9b0CaQFe5uEnz6z6rLxwJNO+Y
 3svEDAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 764E8180005
X-Stat-Signature: ngrxht14hkuhmyr7m3nzzr595omez45s
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306247-901932
X-HE-Meta: U2FsdGVkX19XFJqCYbf544/1MLgwYpJ23O58E5PvKpC4c+pZcJt0+9Q6FrqgfrpgZc9YQ1x4Kn9PP0zPkUv4A8QhooKvO6XDjmbxyTa5j1KjoJSpXtlWBfkqpy08Jh3lePXCIq24ywWDNXLP8FhLlpcpWSna2Kx3CMK+/DtKd6fy+0iY30iMPehBonima5peq1vndravsuo4D5mew5OPr4H6P8M2Ccov1GdvkTtE5bMvJpdj6MHLYpwMIR6tU0r7GvBSVXeXDxs3IraRnMj4u/meaN/s7OTN1lZh1mkb81+PXomPemn9UOPA5OUV7y0bbk5K06ECkf43wkDjUghIZWKpQ4C3u3ki7W99805PDVYp+9wDg5j33J5yHe9FAdN/InPIUi3Yz4PgLAb/kwiMZdOs5hc57RL53BNAdaa9c62DXTA1gsfqOhJYu3zrhSU9FbJjn66ROCiPaRgBmGqTR2qqiPK7aPUrpKr88EblbUrPBac1MY29bUABf8TQOhKr9DWmO02MfIKN6YIfDlq9udiicrKe+wIUsfSIeR7rP0hWsh+HwWtFkSb/rOvuF8cBWFV6XKBGavapxEHYmlxahnp9a0p3S9EbJUbxftviXzbu+ZXijzhDYSL8p05hn4sT04k9LhomrFr1Y7TjdK+VbUOMgJaLuPoltAZCI3YTQJxTFpjssmSoseTN8OK/o5kLfcDqyruG86Kn7P1WGebMjcjShwnwT23bc2gAmzarcZHTMZERBcl6KN8JoOjYJazxFYlHOrFEm6ipF03tm3Vw6HB/EFSI0coLvujJFu5KRPTspREIENp17nHpr1M0zs7fsh6TObHJqcTobal4/6QyvBtWMK9kxPMu+3uMyX8hh0Vyrj3FdgaZjhLAbgKT7yCWpA/G8rM5V25X+d4+Hpbk1X6x8j2Rvnc0FFvmJC4dhQPwSK28NmVTKhqjCgnJkih+TKGwvMFJm/rdqlqqssS
 eXiNN+ol
 4d6y8vhAV0EHmmrFgh8+S0IGOxQ+fbWKCoYTdoSwuUDiqQuFW4eZYVi9OwLlSaEZOdaKwdszTa7lDRFHKJHqNBTgRFf+QyR0IZFy3ZSdR/nFZGJUoqtPWL/R4+CxWaSJt2P2nV6o1085JO0oRFHZVcY9YLDBP0/AfpoDmkHp7utmRcWN98XsGuBdVeayslnpq5f02Ipgv5QMl6/CWv2fe4pgIFjDz/u3z33U4nDchakq8hOt9h/2yg9MSWqPQt6T7T8syUAbJeynATEi4bz2AMQO5Yh8PJeWp3IoV9bsLB8neKLV994dkyPKHIq64zqDQB6210oWJcFF1Om+iG/Xo+7SsxSMBshtB0o9yD5Cz7uU9dk7GLeusOQ+8O/Q9TSaJdp3BEQo2YkNBhJzmPzr2BBXAfr4aRoXAjykl3T9t+jed/K2OcqnnwZMbGvqCXExfLPL/AfyNdcBcwzJ+YM7AdzDUcB2AEGnRi+jIGI5R3Cd5Hpo=
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f53c50507c83..04d9bb21ff52 100644
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


