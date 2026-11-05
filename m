Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F288F606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KySY8v2i
Received: by kanga.kvack.org (Postfix)
	id 07E7B6B05C0; Thu,  5 Nov 2026 16:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055516B05C1; Thu,  5 Nov 2026 16:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADAE6B05C2; Thu,  5 Nov 2026 16:33:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B96406B05C0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:33:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48AD7A0862
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:33:45 +0000 (UTC)
X-FDA: 85402367610.08.B7C1BF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E1E11A0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:33:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KySY8v2i;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyrnE3StgLLppWu/w1Zj17hP7uByeqDos0uxgrgtFTA=;
	b=jhuPLfCfRoy35ClDF3WuET0Ve7xt8O/Y2o/T9TRbOWj4ShPlVrCHX0rbfQwxpUidFTOs5H
	nSiJS5zJQZtUJdFBXTejV0NuyOoIy9BF4u/DrPexCqDW9bC2SH/3YlLwSe8Yn89PKwfvj8
	m78i3mzxtHG9bhFtyTpp4Ur67Iu17rs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914423;
	b=YiRMxJelvQVPpgjLlfj6E+G8/QfXrviM4ga6n1mvQMozG3gBvp8CZt8JcgxbgW6nZzat51
	CXUqeKOX2nKP1zzdvviq3zsCajhBVDRwp2YRNK1EB7fJq9hrDKWoZfy7A6MrF3NcirDBHA
	2V7jLgHPwG7A4pUthZBsH3FU7STCd3M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KySY8v2i;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF8FB605DE;
	Thu,  5 Nov 2026 21:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D671F008A1;
	Thu,  5 Nov 2026 21:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914422;
	bh=gyrnE3StgLLppWu/w1Zj17hP7uByeqDos0uxgrgtFTA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KySY8v2iVhfX9XmbTPAjoWpOOoStWED32L7geLQedlTOyfzMD821GXDji/aJCs91g
	 GE8VHZVMMVt/9EWB8gvZ5QAV6M4Z8iZR14JLegw1HBtpVJgLZ5Jpb4hMmqakv1Y8T2
	 J3W5SsZkG/h+7dKRemngAdJ3V/UP7xZB5c7W0tHxe0mFmCt2L1lY6n1FLqMlmr8fjb
	 dlwVMuAoXSETJY8PhQeJD3cLsp2RZPxziTCNm1xbZlA6IW74JIdogIzyyvk4cA3/EF
	 y86X8Znr4mh554QczMFTDr8quuZWaBCF6FnwzkKy6LGfdMFrUxD0Cgb4a06kpFL8tY
	 gDS0kcAmCGaJQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:30:58 +0000
Subject: [PATCH 07/13] mm/madvise: convert madvise_vma_behavior() to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-7-0d3cd15ab75f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12147; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Jdvn0Mgw7BMpf0cKP+Qll9Jkd0pYJBC/PPvElQfebXM=;
 b=kA0DAAoWz53NioHifxQByyZiAGrs9abIgvJwzGlQITkHdubFSSRXaihhRLrSArEFYrZS/HaXj
 oh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmrs9aYACgkQz53NioHifxRgHQEA6api
 67rJLIqE4CJNZkb1wCotipiVVf+Y7cQRsloF324BAJySN92AsF7wdvZU0Uz+sIXE9jnIvs3DoCC
 tXc+5oysF
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E1E11A0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: y1yc167brsz1ihqpor4uqoh47dmo8eei
X-Rspam-User: 
X-HE-Tag: 1793914423-254362
X-HE-Meta: U2FsdGVkX19XLKUxYFvSEvFdfiIs+r78l01tzbYgDTJr/gldid4WcmwCqfGxgeiw86b3VLDFK8eek44JXui391VMMpWCrWbViwV8odwl/0aH6IDaRs7qyuAnf3XqBoVjxlhagDoLZ/76UvumCnbAZzsAsDi3pyZw44PUIFKdcYtHlKUEW3Ej2JKCScF978hVYohoOYqerpHACurcz/31ENjOLwxtVbUaWcvXASiljdjIbEAUKSTzu9XzwrGagTqksCMmKb64hp/zVY7TwxfdEQ2ugX6wIoMw2pVPr3SNo66B/j9/f/9bEr58jFBDhQ47snYU4XJOvs5JgubpFBDveQB5E+YfCTwoJy6SPKb13ESB57C8E6EnQGAh4HV0QOP/hFD9GNxXrMNtGiqtrNwZ8JD5bm1cg4GJo7YLD6ghksSBeiNfu4xiZLyKGb/ouRbs3/zgiilv/IUIPW21fEBmY3D4jnTnQ8bA2zbFqpdzMWkkub2uvny8e+3eztwkGZVZJ7wZJlH5lBi59j55B7KyjRvwSDpJFGz8L6QOnpV4qXbJW4ttrpi929WAXrkyeSXbbfei1v7VMiNASBWXXIMesOh/tQj6ICRjyap0ZzI5C4S/AcUR93K2XDExIkNmdf0E5RYmGBZLNirNTRUO0MVr9pR76zBPZwOUOVMqcY7ww3IkdAGS5tIIeaWS+wQyeMfmC3uyVV72vl0+sL08JajmSHoohgzULA5z2zw9TAj/jl2wwFDyURBK7+HtjInZr7+B8SWs6982hArxh61n7wtSYhNTdCf7pM075Yx73JxACWH8PpyqIS7lw35HIgCgiThp84CbXsUGvZWNTME6A0Rk0MzzV6cbOEv6w9Q4vjoxvllBUBQaZ6xSuV/NGJMqlIJHHThvKQafX6qYBI/lHaMBCOQ50WhiDaiRD27wazjSJiiQ72Mv3bqQ3kl9JRoJAvPF2XodAWH1FvaV0OnF8yt
 DgTdh5TL
 knJEhs7KUjwCOEp5nFVnn312k+uSZm9zKP7lgeIthLQDuN7H+/w66CNVRJZeURUbUG7gnW4k3/SqaPFAWm63iuYs8EX9QW6Jp5RDNdkhPbee+752h3EFnfPIvpnmsWdPfM7Gnvuf/fc122at+PNCJu6fjy5b2TBaq+ATGG8p5oyiAtqQ30GHpuCj3Mbim5j28DmKy5/pyBYo7d4ospfFHXInrjlpunquw/PZBOLUsjqZhS7qrpwt3lOK5vw8wErtreOLak+36He6nAIvYyAO9ERsQbW1b6Qou50BprwmDCGSaqHwQ1X6NGOIM7v6Kn/C6YEgVy45ISzYetLNfqZBaPfQEpAZbAiWoCG1QW/vyO74jWUv0smGnDTLGgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values
throughout the madvise logic.

In order to do so, update ksm_madvise() and hugepage_madvise() to take a
vma_flags_t pointer, and update their other callers in mremap and the
powerpc KVM ultravisor code accordingly.

In the latter case we replace vm_flags_reset() with vma_overwrite_flags().
The VMA is write locked at this point, so the atomic flags preserved by
vma_overwrite_flags() cannot differ from those copied, and the behaviour
is unchanged.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 10 ++++----
 include/linux/huge_mm.h            |  4 ++--
 include/linux/ksm.h                |  4 ++--
 mm/khugepaged.c                    | 10 ++++----
 mm/ksm.c                           | 11 +++++----
 mm/madvise.c                       | 47 ++++++++++++++++++++------------------
 mm/mremap.c                        |  2 +-
 7 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 463aef870c4e..0fa50bee2ffc 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -393,7 +393,7 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
 {
 	unsigned long gfn = memslot->base_gfn;
 	unsigned long end, start = gfn_to_hva(kvm, gfn);
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	int ret = 0;
 	struct vm_area_struct *vma;
 	int merge_flag = (merge) ? MADV_MERGEABLE : MADV_UNMERGEABLE;
@@ -411,15 +411,15 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
 			break;
 		}
 		vma_start_write(vma);
-		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
-		vm_flags = vma->vm_flags;
+		/* Copy flags to avoid partial modifications in ksm_madvise */
+		vma_flags = vma->flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-			  merge_flag, &vm_flags);
+			  merge_flag, &vma_flags);
 		if (ret) {
 			ret = H_STATE;
 			break;
 		}
-		vm_flags_reset(vma, vm_flags);
+		vma_overwrite_flags(vma, vma_flags);
 		start = vma->vm_end;
 	} while (end > vma->vm_end);
 
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..8b6f4101eabf 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -508,7 +508,7 @@ change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			__split_huge_pud(__vma, __pud, __address);	\
 	}  while (0)
 
-int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
+int hugepage_madvise(struct vm_area_struct *vma, vma_flags_t *vma_flags,
 		     int advice);
 int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end, bool *lock_dropped);
@@ -710,7 +710,7 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 	do { } while (0)
 
 static inline int hugepage_madvise(struct vm_area_struct *vma,
-				   vm_flags_t *vm_flags, int advice)
+				   vma_flags_t *vma_flags, int advice)
 {
 	return -EINVAL;
 }
diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index d39d0d5483a2..1ffc69a72a1a 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, vm_flags_t *vm_flags);
+		unsigned long end, int advice, vma_flags_t *vma_flags);
 vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
 			  vma_flags_t vma_flags);
 int ksm_enable_merge_any(struct mm_struct *mm);
@@ -139,7 +139,7 @@ static inline void collect_procs_ksm(const struct folio *folio,
 
 #ifdef CONFIG_MMU
 static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, vm_flags_t *vm_flags)
+		unsigned long end, int advice, vma_flags_t *vma_flags)
 {
 	return 0;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a2c7c6a0768d..be1f779c8da5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -363,16 +363,16 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
-		     vm_flags_t *vm_flags, int advice)
+		     vma_flags_t *vma_flags, int advice)
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
-		*vm_flags &= ~VM_NOHUGEPAGE;
-		*vm_flags |= VM_HUGEPAGE;
+		vma_flags_clear(vma_flags, VMA_NOHUGEPAGE_BIT);
+		vma_flags_set(vma_flags, VMA_HUGEPAGE_BIT);
 		break;
 	case MADV_NOHUGEPAGE:
-		*vm_flags &= ~VM_HUGEPAGE;
-		*vm_flags |= VM_NOHUGEPAGE;
+		vma_flags_clear(vma_flags, VMA_HUGEPAGE_BIT);
+		vma_flags_set(vma_flags, VMA_NOHUGEPAGE_BIT);
 		/*
 		 * Setting VM_NOHUGEPAGE will prevent khugepaged from scanning
 		 * this vma even if we leave the mm registered in khugepaged if
diff --git a/mm/ksm.c b/mm/ksm.c
index 61b772bba229..3eb9c1ec2f87 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -779,7 +779,8 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	if (ksm_test_exit(mm))
 		return NULL;
 	vma = vma_lookup(mm, addr);
-	if (!vma || !vma_test(vma, VMA_MERGEABLE_BIT) || !vma_has_anon_rmap(vma))
+	if (!vma || !vma_test(vma, VMA_MERGEABLE_BIT) ||
+	    !vma_has_anon_rmap(vma))
 		return NULL;
 	return vma;
 }
@@ -3021,7 +3022,7 @@ int ksm_disable(struct mm_struct *mm)
 }
 
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, vm_flags_t *vm_flags)
+		unsigned long end, int advice, vma_flags_t *vma_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int err;
@@ -3039,11 +3040,11 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 				return err;
 		}
 
-		*vm_flags |= VM_MERGEABLE;
+		vma_flags_set(vma_flags, VMA_MERGEABLE_BIT);
 		break;
 
 	case MADV_UNMERGEABLE:
-		if (!(*vm_flags & VM_MERGEABLE))
+		if (!vma_flags_test(vma_flags, VMA_MERGEABLE_BIT))
 			return 0;		/* just ignore the advice */
 
 		if (vma_has_anon_rmap(vma)) {
@@ -3052,7 +3053,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 				return err;
 		}
 
-		*vm_flags &= ~VM_MERGEABLE;
+		vma_flags_clear(vma_flags, VMA_MERGEABLE_BIT);
 		break;
 	}
 
diff --git a/mm/madvise.c b/mm/madvise.c
index e9fa4f71efea..1b539e67b00d 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -148,11 +148,10 @@ static int replace_anon_vma_name(struct vm_area_struct *vma,
  * Update the vm_flags or anon_name on region of a vma, splitting it or merging
  * it as necessary. Must be called with mmap_lock held for writing.
  */
-static int madvise_update_vma(vm_flags_t new_flags,
+static int madvise_update_vma(vma_flags_t new_vma_flags,
 		struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
-	vma_flags_t new_vma_flags = legacy_to_vma_flags(new_flags);
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	struct anon_vma_name *anon_name = madv_behavior->anon_name;
 	bool set_new_anon_name = madv_behavior->behavior == __MADV_SET_ANON_VMA_NAME;
@@ -601,7 +600,8 @@ static void madvise_cold_page_range(struct mmu_gather *tlb,
 
 static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_LOCKED|VM_PFNMAP|VM_HUGETLB));
+	return !vma_test_any(vma, VMA_LOCKED_BIT, VMA_PFNMAP_BIT,
+			     VMA_HUGETLB_BIT);
 }
 
 static long madvise_cold(struct madvise_behavior *madv_behavior)
@@ -650,7 +650,7 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
 	 * further to pageout dirty anon pages.
 	 */
 	if (!vma_is_anonymous(vma) && (!can_do_file_pageout(vma) &&
-				(vma->vm_flags & VM_MAYSHARE)))
+				vma_test(vma, VMA_MAYSHARE_BIT)))
 		return 0;
 
 	lru_add_drain();
@@ -881,12 +881,12 @@ bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv_behavior)
 	struct madvise_behavior_range *range = &madv_behavior->range;
 
 	if (!vma_is_hugetlb(vma)) {
-		unsigned int forbidden = VM_PFNMAP;
+		vma_flags_t forbidden = mk_vma_flags(VMA_PFNMAP_BIT);
 
 		if (behavior != MADV_DONTNEED_LOCKED)
-			forbidden |= VM_LOCKED;
+			vma_flags_set(&forbidden, VMA_LOCKED_BIT);
 
-		return !(vma->vm_flags & forbidden);
+		return !vma_test_any_mask(vma, forbidden);
 	}
 
 	if (behavior != MADV_DONTNEED && behavior != MADV_DONTNEED_LOCKED)
@@ -1021,7 +1021,7 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 
 	mark_mmap_lock_dropped(madv_behavior);
 
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		return -EINVAL;
 
 	f = vma->vm_file;
@@ -1333,7 +1333,7 @@ static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
 		return true;
 
 	/* If the user could write to the mapping anyway, then this is fine. */
-	if ((vma->vm_flags & VM_WRITE) &&
+	if (vma_test(vma, VMA_WRITE_BIT) &&
 	    arch_vma_access_permitted(vma, /* write= */ true,
 			/* execute= */ false, /* foreign= */ false))
 		return true;
@@ -1357,7 +1357,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 {
 	int behavior = madv_behavior->behavior;
 	struct vm_area_struct *vma = madv_behavior->vma;
-	vm_flags_t new_flags = vma->vm_flags;
+	vma_flags_t new_flags = vma->flags;
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	int error;
 
@@ -1388,44 +1388,47 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	/* The below behaviours update VMAs via madvise_update_vma(). */
 
 	case MADV_NORMAL:
-		new_flags = new_flags & ~VM_RAND_READ & ~VM_SEQ_READ;
+		vma_flags_clear(&new_flags, VMA_RAND_READ_BIT,
+				VMA_SEQ_READ_BIT);
 		break;
 	case MADV_SEQUENTIAL:
-		new_flags = (new_flags & ~VM_RAND_READ) | VM_SEQ_READ;
+		vma_flags_clear(&new_flags, VMA_RAND_READ_BIT);
+		vma_flags_set(&new_flags, VMA_SEQ_READ_BIT);
 		break;
 	case MADV_RANDOM:
-		new_flags = (new_flags & ~VM_SEQ_READ) | VM_RAND_READ;
+		vma_flags_clear(&new_flags, VMA_SEQ_READ_BIT);
+		vma_flags_set(&new_flags, VMA_RAND_READ_BIT);
 		break;
 	case MADV_DONTFORK:
-		new_flags |= VM_DONTCOPY;
+		vma_flags_set(&new_flags, VMA_DONTCOPY_BIT);
 		break;
 	case MADV_DOFORK:
 		if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma))
 			return -EINVAL;
-		new_flags &= ~VM_DONTCOPY;
+		vma_flags_clear(&new_flags, VMA_DONTCOPY_BIT);
 		break;
 	case MADV_WIPEONFORK:
 		/* MADV_WIPEONFORK is only supported on anonymous memory. */
-		if (vma->vm_file || new_flags & VM_SHARED)
+		if (vma->vm_file || vma_flags_test(&new_flags, VMA_SHARED_BIT))
 			return -EINVAL;
-		new_flags |= VM_WIPEONFORK;
+		vma_flags_set(&new_flags, VMA_WIPEONFORK_BIT);
 		break;
 	case MADV_KEEPONFORK:
-		if (new_flags & VM_DROPPABLE)
+		if (vma_flags_test_single_mask(&new_flags, VMA_DROPPABLE))
 			return -EINVAL;
-		new_flags &= ~VM_WIPEONFORK;
+		vma_flags_clear(&new_flags, VMA_WIPEONFORK_BIT);
 		break;
 	case MADV_DONTDUMP:
-		new_flags |= VM_DONTDUMP;
+		vma_flags_set(&new_flags, VMA_DONTDUMP_BIT);
 		break;
 	case MADV_DODUMP:
 		/* Only mm-backed memory can be meaningfully dumped. */
 		if (!vma_is_mm_backed(vma))
 			return -EINVAL;
 		/* Core mm may discard droppable memory at any time. */
-		if (new_flags & VM_DROPPABLE)
+		if (vma_flags_test_single_mask(&new_flags, VMA_DROPPABLE))
 			return -EINVAL;
-		new_flags &= ~VM_DONTDUMP;
+		vma_flags_clear(&new_flags, VMA_DONTDUMP_BIT);
 		break;
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
diff --git a/mm/mremap.c b/mm/mremap.c
index 0d06d7f37f19..5f4e7d1ce3b7 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1133,7 +1133,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	struct vm_area_struct *vma = vrm->vma;
 	unsigned long old_addr = vrm->addr;
 	unsigned long old_len = vrm->old_len;
-	vm_flags_t dummy = vma->vm_flags;
+	vma_flags_t dummy = vma->flags;
 	const bool split_before = vma->vm_start != old_addr;
 	const bool split_after = vma->vm_end != old_addr + old_len;
 

-- 
2.56.0


