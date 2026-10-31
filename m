Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621DA606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EX+rzLR3
Received: by kanga.kvack.org (Postfix)
	id 622A36B05DB; Sat, 31 Oct 2026 05:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB8E6B05DC; Sat, 31 Oct 2026 05:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB2E6B05DD; Sat, 31 Oct 2026 05:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 215676B05DB
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:46:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2FA71208E1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:46:47 +0000 (UTC)
X-FDA: 85382442054.06.F1D89A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id F2A5880003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:46:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EX+rzLR3;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440006;
	b=QGv+VdXznmzFhuAqI7wOoobKC+NGJQRpBPIbYJ5dbdrUdOZz0UGXS1ojLxZHNQpf+Eott8
	FeLkU73QZMCSbJyXROJT+wgKO6HJuFVEcNNXT7FMVm1BmrEGpDHppJz4XwbPaBOcFm5KmO
	pAxC8Jo/8tkuJudhkhtzjkcPukJHWPs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EX+rzLR3;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFAIeNXgFr1JMM5WH77Fc7EqldEyl6IknIX1LhJHwrw=;
	b=udOQSmmYPmteCrdFppVCHiGrpcJ2M9cKv5Cvm23bVhRm3f+nCGQz1LovqHeK09j8rOvSRM
	DtEr8QHYwXiAgesCEMnVUfkWyFtUj8mJD7QEKvd4b4hAztwp1f5MlxhSuuSzwGOA8JDhZz
	gjH9rY9I7C4H/oWRRN77O8Tj3ue+By0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 857656061B;
	Sat, 31 Oct 2026 09:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CA31F000C1;
	Sat, 31 Oct 2026 09:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440005;
	bh=aFAIeNXgFr1JMM5WH77Fc7EqldEyl6IknIX1LhJHwrw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EX+rzLR3sPZ/JAPmDxO6qvruP7KweCWYbPS+ljbCCp8ncesIMMjQFWL1CwA/7qSfO
	 MZc2qDD1LCXFUhxjV2Wh1MkDNJkf+rR7cRYaaywcEG/vgDTdJs73AERbIuvmnhE1S6
	 H+m+yHY/9r3a7AicVf4tzMRkrsrz4IKZTEYKWfu6Qu1s/KRba/wlS2kCTK/e6cNvcp
	 fG7t1VvwaN5GFTBzBdF7Y40XCg3q4K29QXyXbc4wZPl9siKtYXSZ/Kcf6Q58L4QyHS
	 YigSSln0JE5OvhEsT/dbdRmsbNjFGtOnAHU+HIrXMBQCDYGCScxOz39ya44Wul1aWT
	 iCtQ2jWApIcOA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:54 +0100
Subject: [PATCH v3 25/47] mm/userfaultfd: wake waiters when registration
 modes are removed
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-25-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3059; i=david@kernel.org;
 h=from:subject:message-id; bh=jIZ4aj6oO0T8O1iDgAYwxVUGJ5PVlOxvrE64yrDPOpw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+YcELBdt666LezdhU52py4HZm8/dli+Q03o4qWM
 xRWFxqs6ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAianqMDO/D2137GiO5DPhs
 zh344W9+yLuP8c+LXNmID1+Yjs5d08LI8PXN7dVm34SkfnwM6C++9qtg/ZrPP8T2TW/qe7h+anf
 SCx4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: faamezuxfy4c6m6etdi7po1zwoizu5wx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F2A5880003
X-Rspam-User: 
X-HE-Tag: 1793440005-9554
X-HE-Meta: U2FsdGVkX1/MGN9+YmfOMRCTP3Kj7rum4T7FwMY5XkV28hmPAE8+DCvH/LkyJ7GM16f3rLOFZ+ltQmAORWOHL2zfrqryKHpt3lqW+rlowBb9pfEGAto243WjVqL021ml09BC04+JCwSU3IPgkwkDCaDojfQPF6d22jih1dT4X5m/Zl0Bw3RPMynipbSZKFWswLcN4Ad2dxs76XELjCvW6GQX5H/Fc3QrXkKfr4oFpxe5Q5Lw9idC//G/Xnz2eX+ggY0sDLoimQkioYcPKnNddYKX/WOkyRBtPQJEt72P040AuR8AtGa3DUxsEAMcYS6kZbwuL9Vt8ZZ9j11OJamXZn9/GHvAPswMkyP8n5iusIvze3MjjwDj7c29rPS40n9Nacfin/cGg/cOZAkoUSAImxqkw3WTApkl2rEFGQAOdQtMQTS11S/IH8wJzo0KgMI25GHiETkSnVBAhDmOEPF9f8FsOk7RQ1d86N5gPz7YDC90O/lfXA2AQ2dosXgBfbO6X9QrwLYeoBrN3Rf1chZNEQpzYpmO03S8MLNe0ikwAcUT9pfs0z9oa4cIKJIYLIVlTEtMdrEpQTEaUbbDB9FKX/Xh+Ablts2sjwFDHYDBXqzsx2xV+QumTn09ZosvSg3d1gIZDOEL7sRHSsrbMQapcVMBqEnsRPls+6S1CT63HN/a64PcEedH7KJkV+lOeehDmLpsNHy5SVtbpAQUbhumWgLWQ2/dZMzD9gfuDkY2SwgRI/RRO9j+ZZEyVtsdpCCc4niYu2WWbwW87APnyc6cNkwZj3j4ofJIofi7h3LdcKkLbn8+i3TjQTB7JHieEuWgNqQ+d5mceZLV4jp0Pg4n1imNUV4b1X1e4IGi8Klsf1etSBkBNPZI0J9mk7fNZNLe/1xafEnsG5ZPteFqC8eDTwxMIVvnEg7XVicpKeqfth5OeTr6sAxqhHjyr9QUtY86qLFe1xI3SaELie5jaBh
 F0Lc45v+
 QOfO7rxUlIaDs7ltejBhjpMIHCcnnr+1D+mHKdFtSuRFTPU5q2MT9VDB0ELKvAcv7reoxH1g7LVUX2axGJE7iZlYnjrn7WAaUPeby49VO/9Q7TAk1wmaS2u+OLyMJ49Ds/4S4CgiTyHatagAyHwO4Opyh7q0/t1kw0XdBUxD2tQGewqbB8JAmGRvsV8/f4IN5NAwyovyWWMZqBaXr/tzmy63Yfkpbx2pSMwsYuSX6TPWmuP9mzgBkWFhXpmhykS9xcLzAZdjhgfqtrF+4XoC8LAm2DK9k2716BkWomQm9xbJszUFaSZ7oJVgo0b5AxDy4hPqiU0jzYExuJdLy9/LS2tQyq5HPelkMASykFF1tkNlC8156zfCZHMZLUt9rCctf6MjiVgd3NN7B2RkLoi9mAKa3OkSQOsU63IZZCq5dMAr7sIsSNnSqwjXwuUbVhytYTyXLAQbriiiuB/RqIR9w3piD7OIpU38qQmmyf7rn5bedo5M=
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index be630674fda9b..03f1b15bfe63e 100644
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


