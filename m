Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8B4606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csHXg4wZ
Received: by kanga.kvack.org (Postfix)
	id ABF3B6B05DE; Mon, 26 Oct 2026 19:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70076B05DF; Mon, 26 Oct 2026 19:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986A46B05E0; Mon, 26 Oct 2026 19:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 671896B05DE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:25:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB0A6C08A9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:43 +0000 (UTC)
X-FDA: 85366361766.12.1B30719
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C1AE20003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csHXg4wZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4MV77Ak5yM3C1+7NxJwT8IeWvwmREROuL+a3NtDfRQ=;
	b=wC+pASoTQ9PtW43H6iv7Z25sqDaNrTkhsES5DNuuBrPwl8b01OrsXireP0QF8gGaLnM9mB
	Cc0X105TAy/2ypzQcAynLiheBdn7gn50ipYKcoWFy5NIJ/mDvrEGV7V8NUm/hfCY0ZHpYQ
	K/4yNihYqfhQFP1b9v69SUyWULR8W+M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csHXg4wZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057142;
	b=xq1l1G6rPRPvjA65294OLFcueiPo6lCKeLWpQ0mIm2U/IQgIYa5/taZcLIMC0Cmf2wkbeW
	SuJKbGjvQlb+aMBzS6qoGEdiRuVwsTYesdenqpojfxbSyKLORGlk3Ails8MahCLFbzhucT
	GC+8KwrrZpJnffasSnrs5laI/6nV5q8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FB5940349;
	Mon, 26 Oct 2026 23:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD50C1F01825;
	Mon, 26 Oct 2026 23:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057141;
	bh=d4MV77Ak5yM3C1+7NxJwT8IeWvwmREROuL+a3NtDfRQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=csHXg4wZ8V2CmRF41ciyNKcq+nBGY98nOFGquFQV1I4FOR2ZqNkkrBhldXkbQA73s
	 kqedJrXPlEw/GuLeiEQWDKrNumdYNi7vhd3rTRVxjzw/ieirH3dPmp6u/as6YmvrVJ
	 iZVtw5PMFX/jnw2wY7gllsWdINeETnRlf6f6Vsm9gTVUB/vzHDYRNW77UUNKHK5vf0
	 Bqeq21Tg4d6xJhLwKyTxEuaoXxDsLIbY0SrDQTLoSeu3UpGhMLhfsPmkHFvrYS/6oI
	 c2/1w6D8Hg0KPF7JckRXaIQGKRF2A3XeW1iG0jHdwzqpLBslT2ot9ceobK3MBvzzoe
	 qXYq7+4TRovEQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:45 +0100
Subject: [PATCH 25/46] mm/userfaultfd: wake waiters when registration modes
 are removed
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2728; i=david@kernel.org;
 h=from:subject:message-id; bh=E+83r7S624k5EPCZEmcEXyyfHzl5/kgAEPI++IJBHPI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+WIeW5rKpx0pvbIdt016lonXeLtHmhY9T1TzZjs
 2/d3hvsHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzkkyUjQ1votYCOD5eP6p1d
 wta/KW2Lx6N81v1HnfwbZF37HwhPCGD4p3Rb9PXpo3MvSN91cbu8pm+zTknZg8xeGZ60n/eON9n
 vZAIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 1C1AE20003
X-Stat-Signature: jhmjozkhw5pf11w4ocxhyxoxgotnmjh4
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793057141-911876
X-HE-Meta: U2FsdGVkX1/Rnt2vF5zkPHPNmXXP+lUoIBIjF/UWsvNAcU377dRv6KNkNhyx1033Z6PQjU0ta9eGZVxIQ1EoEBrL9bhAxeozLoyNEKzuKU+4CKjfU3PC08BIJfCXkJ5QWivQDjt06EeY3ExI7gReehod/PMqY3iY0VTT4wYfrcOYEjSdQLZhF40q5vYP2MoZLEjWSYv5tcH6CBtYzEhDiy39tEZNmuy1nFkoVy73mKMb0XY6TW/rtluHu6M0Zzpwk0LvG45igIQBueXcTHRDS2WwSmiWJmDsdl9V79mXYRgjdrzSEJi0eaAEeJwV8eYR4uShGoJxWYaI3bDV5z24Q31LjM4GfzObDAdXkMUw+mzGDy2DajxW3++dbVPbRQnc7P19l6S04q1jNgOZnPmVtAG+Dz/tw0v0y8FYkXORzDx0OUb1CIdyGhFmZYW+9wCSCZDGeRyD78MEAP+GQSwrHnZ8PQKoSdWYEznGvoFzu/WvQawAr0xNzcSamWgDvOs1VP5suLgaLBRDqqMSQK9nEgJtAqkFfjBzzU/d9eB7JpCCnDUVWXEwQPUmGRweUAGrAkSip63Mq2ODyaUSAMfU3PwSl14pjaZKIADjd2noCPudrDwuFq6STA6DtTI3KlLZq3LGTG5YOAECbAw7zSAJErfYIBNF/jjhcw91BBKqQz5FISVBZIJ7LhXydTQxs1oFaqCxIT1tbOvO9j8SJrkeovdtjPkI8gQ3IDzes01dJ3qQqpQ1JybpViyjVi2mM83FqpHjkpNVnwQf20+NyGgZpo3aCnbea5q4f10kwZQdDCTYinV70917CapwdVbwDlz6aFYguVa+OS1RmZ/yuUF3rfw4Fo7vJeKf2ZXO/m0Sz4Ci3KPBcUZlQI26YqYvBrflhUZ6chYczNRTZmKpTH+1BSW7peuQcqCED4pvQQDdhrD0Q+PgQfhEBQXKykPz8TLUH7Pq51pV4cHqIYogO75
 stl1cKEJ
 /7VWk4zwBjzf4VzD+aLdsK/EjFp6RTY1zpmva3WlNOD43DYYvcBADCGow97+yLSd6T4qfCqTXd8cud9IcebaGrz8WFYaxaR8L3vByxh/UQ8O7GLIAoWBrE9x5GkEIhKdnRXL+0H4pzlRrLej/onZMpVgETc8h/tdwL2DMJ0w3fcCNt5tmyfcvAazCVCp+OW5ayufdb5R0eg1DNXtJsgKF+FRBUs07NqoE/GPaeO2M+4CQrRnQYpTOfqasYi+fT0Y5b0lDLGKlmcLjZWvEcK74pZ4TVZ4kqugR4pz6WwxGQ0GwTNaV7sEBv8v9VwZOpdFzvlxlJA9HzcKkKq3CeSmMR61Wtsmy3mJQ7h7IQMNqebZflR+Cd4j4+/cCuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

UFFDIO_REGISTER can replace MISSING or MINOR tracking without waking
faults that are already queued. For example, switching an anonymous
range from MISSING to WP leaves a missing-fault waiter asleep until
userspace explicitly wakes it.

When a registration change removes a UFFD mode, wake waiters in the
affected interval after updating the VMA. The VMA is write-locked at
this point, so no new faults can queue under the old modes and woken
threads cannot retry until mmap_write_unlock(). Waiters for retained
modes in the same interval may also wake and refault.

The hang reproduces for MISSING-to-WP and MINOR-to-MISSING transitions,
with both read and unread fault events.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 2122676c4220f..710e913c73bfa 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2270,6 +2270,9 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 	return ret;
 }
 
+static void wake_userfault_range(struct userfaultfd_ctx *ctx,
+		unsigned long start, unsigned long end);
+
 /* Assumes mmap write lock taken, and mm_struct pinned. */
 static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 			       struct vm_area_struct *vma,
@@ -2287,6 +2290,8 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
+		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+
 		cond_resched();
 
 		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
@@ -2332,6 +2337,10 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 */
 		userfaultfd_set_ctx(vma, ctx, vm_flags);
 
+		/* Retry faults for removed modes while the VMA is write-locked. */
+		if (any_mode_removed)
+			wake_userfault_range(ctx, start, vma_end);
+
 		if (vma_is_hugetlb(vma) && uffd_disable_huge_pmd_share(vma))
 			hugetlb_unshare_all_pmds(vma);
 
@@ -3648,6 +3657,17 @@ static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
 		__wake_userfault(ctx, range);
 }
 
+static void wake_userfault_range(struct userfaultfd_ctx *ctx,
+		unsigned long start, unsigned long end)
+{
+	struct userfaultfd_wake_range range = {
+		.start = start,
+		.len = end - start,
+	};
+
+	wake_userfault(ctx, &range);
+}
+
 static __always_inline int validate_unaligned_range(
 	struct mm_struct *mm, __u64 start, __u64 len)
 {

-- 
2.43.0


