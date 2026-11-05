Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EA7606D803
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5vNiziv
Received: by kanga.kvack.org (Postfix)
	id 427206B05BE; Thu,  5 Nov 2026 16:33:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE036B05BF; Thu,  5 Nov 2026 16:33:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314D56B05C0; Thu,  5 Nov 2026 16:33:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F231C6B05BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:33:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F708160C33
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:33:27 +0000 (UTC)
X-FDA: 85402366854.18.A979D4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9C8304000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:33:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B5vNiziv;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0pYf4wz8leHRtACWiiE+5QjHFuiPzSaPBJ/BygPIB8=;
	b=nZ4pga2EvL/FFgdq5/ggz0QVM6MMzzp9QSZYMDKt05Ii63EEIvBywfja4qFzVFQ76Vq7Uk
	0lN7b2Pa69ioL6iD8afNS8tw6DDQ7F6qVngnrKbW9JlS+d/wuRNljv6lwOR3ST65tKCeIm
	IWdveSwz3PAj/hgWwgUyhRnfKb8LcSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914405;
	b=rZCNY75D7neXcGs/0XiMHrVG2ke8huU+SdelPlkgfne+43Ce2P6/Y3rnEfwjZCJ8QW3ke7
	T9d82LLME+iq7gEaAn+lf27dJFOVlSgTPuIQ8fAPZKPIsXNh3giCyclvDc8jWiXQfc6qqs
	DG/jF5AqDaDWz5k3oERh7pvfMLezCgM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B5vNiziv;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E136B43630;
	Thu,  5 Nov 2026 21:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308621F0089F;
	Thu,  5 Nov 2026 21:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914404;
	bh=M0pYf4wz8leHRtACWiiE+5QjHFuiPzSaPBJ/BygPIB8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B5vNizivHZEU1KoNI86QKGoZ078bEirUQPKmYN2ZC5I+UovaOMaR7kxE0je9fMD31
	 HaYi8+to8sOuLxjaZxifCqDxztBTi51kFe9a98XyXbRD7OtyoPxM0JS8X3xP1WR9GP
	 DTsGwu3IST4+RHoKgTvjk6pz1hf6DxiPyCgRkccebG1AFbChb4l83vlGjhM/clWVl8
	 RhZq/VTVtO9Df23SXK/dkkWy4uCF3qQAnYkttXvsPSoI/cqoIUuoj98/ILanad4VRj
	 NDdELiEC2TR27LnCIdX2sXR0YgorK/Nd1hWUOmKo1MF5O1lcbC/mKHbYP+rOVPk8li
	 2fYJIyFAm9KDA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:30:57 +0000
Subject: [PATCH 06/13] mm/ksm: convert VMA flag tests to use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-6-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2315; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xZlktZwJsOHuvEUJpFUKz3hiGmT/MeLFJ/LiKv6KqSo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF0WIiXRO6NsUtnEorKsaV4B8YsNutOPhpzRcjw46
 8z2Q9vZO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjAR4R5GhlO/r1jOXb2bl9X0
 /dHAF6kHI3p/3VSO9VAy1ryzcNKLZlOGfwpr7cIrqwPev3nt5SQX++zQYwdj5rQ3NdZbn1fZ/tw
 oyAgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C8304000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: uqmodgc3zhatm6as81yxn91dn4aer79o
X-Rspam-User: 
X-HE-Tag: 1793914405-228511
X-HE-Meta: U2FsdGVkX1/VHoKiDoiwjyc+F9+CJWOWBZJfuyHYy9Tz9z0VGK2HnmUDnI/Jyv+MMB7lF8akNKJBWUr8RUScGdkuW+StbDvTVO/Ee8SIkLV0u0RGg2cGFf+U8nJbczGTkQm0pgOMktWJA8pwedLd+f5TYf2vgKoiN+t5h6mvrLYAAcJaGTwmMBTLxjZNBgabxiUs9EteYPRye23IwMqPW3Ck+twg7KzSPqxP11vZBJNh1rdXvJq/1RkU0tr1puD2vcbCWZhEZr4DIuZrol+sweskYA+q8ipNIr8BSfQXkrmwEYsiP+BfFli9/U0sYKCrGM+7ixIhavteRTwIxTzM1OORpnrGz4aBGfF+GVjxyrFJaZZ1YF3M7YkhY9kmBYH0WaHJgxL1kgLdu/Uydh5qrYh4BY48emX/P+mWueQQpusnud7NuPa1ZbPBEWlVcmF1im9oKjlfYbatpzTVGfRXo7PbDvYEUehw2ysJR2/z3JNdRJ9oAiPb2zsoZEFlFJuh/T5EPkFPQmFlhivKWUOKvunYCJTDWDaVlt24FJ41JtEvL7hrjkxZpiELsZBPrCzT6L6o9l/JsKKUR1Ux+L+N1kZWLFNFsdSg1naYbPShsy6j10EXOqFIVcfF173UeO1W7MkKQtEI4wNfYIwdTNaSQudegc5M2yrf3vcb708eCdq1l7i0z6zNwVObiPhjIbM36p4c1wvz6zfPaOTzRG0Ol//3efzVIHq+Sx9n2a2+dN4UfshCx+Zr//slVpfnwY/+F6gN/Mnng99cPYaDr9RWfObSp6JdRZsoDC4dU8MUArqo85ygrzDy66vWjIgCNbDmi2IGtPBhgKyNuavckQHHdxRiJaS9OllWhdnNopeL9y1mcumfH6L14KPkHjvVQlQ96z+IKxoz5NibAOCFhZ7RAzjIHsL9GRACXvoQkjaCjzClDFfeNxJCQYZXDsjq0dtAKTGW2fcTVbyuM3aauOP
 Uc57K9op
 tUiehct3UJSM3dLC+ZRTp9V0I8j78ogtJU/yvWD2R7fON7AagH4TADbV/T4Lf8ClHP+7NVfoxHfBmp9YdqnlF7mnfrCUeZ1l2n4H4rCE3boXPimcVD+T6yGFPQzaOoLLyHj79wSMDvRY/76TjpNW2MHLs+kZQVbLZlbAkkqNAkwTl9FclvTwUx4k2qNFIPQtHBsNrfdyw6Ici4NvVFXHb5pAb4Ysroz8gIbV+dDX7b09jmc4LQiMvGz7lgkUi1/8vSHQG1B2Rs2FK2ZiaxvEAkgVxP9Z8wQ9XYtHGngn+a21P0Nkioji/gGdwoW005XeatJzV5tx3shAH7dMEXzUXOjHs0huP0v7PSyaW9iqw/F/2mKE2GvvTfa4GmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values where
KSM tests VMA flags directly.

The ksm_madvise() interface continues to take legacy flags for the time
being.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/ksm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index d6f736a1aa2f..61b772bba229 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -779,7 +779,7 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	if (ksm_test_exit(mm))
 		return NULL;
 	vma = vma_lookup(mm, addr);
-	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
+	if (!vma || !vma_test(vma, VMA_MERGEABLE_BIT) || !vma_has_anon_rmap(vma))
 		return NULL;
 	return vma;
 }
@@ -1243,7 +1243,8 @@ static int unmerge_and_remove_all_rmap_items(void)
 			goto mm_exiting;
 
 		for_each_vma(vmi, vma) {
-			if (!(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
+			if (!vma_test(vma, VMA_MERGEABLE_BIT) ||
+			    !vma_has_anon_rmap(vma))
 				continue;
 			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
@@ -2698,7 +2699,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		goto no_vmas;
 
 	for_each_vma(vmi, vma) {
-		if (!(vma->vm_flags & VM_MERGEABLE))
+		if (!vma_test(vma, VMA_MERGEABLE_BIT))
 			continue;
 		if (ksm_scan.address < vma->vm_start)
 			ksm_scan.address = vma->vm_start;
@@ -2890,7 +2891,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 {
 	int err;
 
-	if (!(vma->vm_flags & VM_MERGEABLE))
+	if (!vma_test(vma, VMA_MERGEABLE_BIT))
 		return 0;
 
 	if (vma_has_anon_rmap(vma)) {
@@ -3027,7 +3028,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 
 	switch (advice) {
 	case MADV_MERGEABLE:
-		if (vma->vm_flags & VM_MERGEABLE)
+		if (vma_test(vma, VMA_MERGEABLE_BIT))
 			return 0;
 		if (!vma_ksm_compatible(vma))
 			return 0;
@@ -3484,7 +3485,7 @@ bool ksm_process_mergeable(struct mm_struct *mm)
 	mmap_assert_locked(mm);
 	VMA_ITERATOR(vmi, mm, 0);
 	for_each_vma(vmi, vma)
-		if (vma->vm_flags & VM_MERGEABLE)
+		if (vma_test(vma, VMA_MERGEABLE_BIT))
 			return true;
 
 	return false;

-- 
2.56.0


