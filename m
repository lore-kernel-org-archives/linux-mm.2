Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F134F606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KGJhzxYl
Received: by kanga.kvack.org (Postfix)
	id 1ADA96B05D6; Thu, 29 Oct 2026 16:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185B56B05D7; Thu, 29 Oct 2026 16:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077D96B05D8; Thu, 29 Oct 2026 16:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C882C6B05D6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:39:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5AC91401EE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:39:42 +0000 (UTC)
X-FDA: 85376829804.08.430CD1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8F20C1C0009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:39:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGJhzxYl;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAhC4MbhnDJXKKCQ+5YFJHRaqlB0ve7BM+PvgIjSMcY=;
	b=LXc0IkJNub3glDNTBMwkiA6nGRFieskmio2c5o8eVE+ixcyDRpL3S8y10c0gw/5L4Rzjc5
	LglU0OgzIqZ4TVRPFzKZ2D9bdAolXQxFEl/Mmn3KN1PZJOWxGR0poO0v4cz1KElGhkUzuE
	qmrcYLXiZhxFocVTW2CghYzgId2J/dY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306380;
	b=J5jx+Kb7floF+ZyNP0TSEoq8voLgcp3NRF21raV4AB7+xyfVDRY/b9zNAY8eRS5+bVV/6x
	QHjoWJq9hjPyyhsZM7Vyhf9WM2Sen1VxQAbZNgXDzNk9b/9K3gGP1ygWpmdXsSxksP6P1c
	R4thHrXf4DewP3vcpAk8bGAQdhYzNOE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGJhzxYl;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B67E041AB7;
	Thu, 29 Oct 2026 20:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BA91F01824;
	Thu, 29 Oct 2026 20:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306379;
	bh=CAhC4MbhnDJXKKCQ+5YFJHRaqlB0ve7BM+PvgIjSMcY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KGJhzxYl+9r92Bj9W2YAR+wgi/sM5nkmr2lgTbQ30j8ZUhL38hxRUC4bC5dp1p0E3
	 JHssW2r5kV05NN1RN0oNO86QRqKkSxnFUPWqVRO/1w8jPj0xBXyUFR1kMY+59f7FTY
	 9hZ0Drs+/V7tulyIr4vt7QO2GHInOb6FbOYl8Gq3QTUkufyiJLpdmPX7lLx8CWCV91
	 h9tesZc4td3L9agPTyeb8/iri3/sTsBiTHeu31Zd9M30RSZId3o/7i2lTFUMgD+EW0
	 5AxwI0RNtgE2rzG27RTB7FGyMtVkUfNrCk23sMzr/ddhNnQk/JNJAy8M0Bz7sROrk9
	 q2m2I+ZepkH5g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:20 +0100
Subject: [PATCH v2 25/47] mm/userfaultfd: wake waiters when registration
 modes are removed
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-25-a64ce7f83abb@kernel.org>
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
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3002; i=david@kernel.org;
 h=from:subject:message-id; bh=p4m2oymzzbSLDXhAc0Cf9hknbaIjiA7t2PJNdiOyskg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer21/bClg2vOzuLmVceYDuUKBTqGtbMq1QSm+LduOv
 F3V3JDUUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwES2vmH4H3T+ZnsN28rm2Pt+
 3GWvjafpfElmyHwp0Fm41MjI86z5eob/lfGbmP428sZp9c5n652hqvnusTvPzKqadww7fm1e/+U
 ECwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F20C1C0009
X-Stat-Signature: j4gjjafmiiwyeyb9qo7zf88a77sf6ejh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306380-623200
X-HE-Meta: U2FsdGVkX19vef3PRmubewm5KijQ9fkVS2DSkIEJGHlNrMew/LiLw+uRzL0LZ2NDXP7vxGgEmqObR8ShY3nxfq/C5AqsVihlD/kAMNx4bNuqsNq94ULlRT5isdec5C7NvGdYge2b4koM87/6nSUBL91CLBQ+jwnj5V25Sf+Q0JDPeA7/W9iJuuzm+Wr3If57JZvpYCOp8jpmmdOXoFhRTFM9W84E8XEoIu1Br31dycnaVgEjl+gabosxR5cCR1OW94IZYgQkGB1qDc0ad/GyHJSX4e3U0xF3ipfbPAeAKAFO9QVMT2SGDS8n/ANBhTRtEtC6SqjQHvgI0wLmSiCv/rLj2+hznweapJ3cb5f30goOuvPgpAGw5pB//s2Z0o9nMZWvweZ/SWvj2OCuf/mgugwcYVcCzXsvtP/+8OtcsM4T1RmJWb+9gNNtVtkV5lajWZD6b0WkQqVDaQZHPcSo8gn4eoA5pwyNYqCclz3iAW6g5AFlQj+Mhezb63YYpUIQN72xoZu4xMgGY9XA9yxJERoBeG4V+H9bKxfNTxFP3mFu0Iu2cueMmKTSqLcfvQZGAd5n/fqx56e63jX9DufL/j9dA0Leg7WNgHWKsGy5r7UoCWg3j6/H5C880Ff/DelvNUjOaSbrP5EHjkSohNBnQizgl5Cbu5UMb0h5lCTDADeOv/R2JzUT1QEr6Taywt+Aai1bbM5MLIKTHcQv/OmQyWb1X5fkY9mDPyfAB8g0FC1yMkjRw+dDZk+BujePLEoUxvNLRIQr+M7fRqT/kEtvUxBjETzy3oQCgKYMVqzuSqLGQxsz7QBu9AVqF/nEigFPyyUtMdI0FnfLN7RjV2EwtGLxfwKo7VCYtTJpALnfTS9LLygG/WQR9SObQEWqWaZ+AYwou+RSeFjR2AHNw9xyQndI+rJp6+RQp4NAZG0dN/2ZUCXuokOJqwiRO378kfl8tB842aZkBIVAweIWR5u
 BmBDcnGk
 FfpNx74L5kZCB4fAnMsY/HDRquj8dN6OpdHMS9qsawAQ8Aa3p3aRKhG3ARP9R1JWHv2aRegxjRxH1w+OH2UOFnMxm9kVT6qSfpkK/Wk19UeQd9KT3xIeCjtGvJfNwIei9GBZXVqwYFawFya/3J2WqQ30gd9ZZidZ9lSSqt6pY7P2JxWKcHttDFRTvk7b8Jqrf5oMAptR3BmPMHt3ihwFDaRpJKu1XJRXHtrYVHoWQGriRzkNhrkTaNFhY+ajF3Txvsq07NZiZYM1mdC8tgyVv01nK1LxGCH0aFiY7sM3THEDLreCFQK5Dzp8sgtWKzFv5g4qb9qvnbl04NjRwW0bRBFpD7nFrgozDqlyn6ADkuvyV0kP47pM/zU7kv7Z0zXQ2sshUz7mluqEOUQtBJdriRoOs+2k2al0gokki1/JcZmZblT4=
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
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index be630674fda9..03f1b15bfe63 100644
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


