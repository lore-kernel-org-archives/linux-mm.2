Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E2B606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jc6SEGgv
Received: by kanga.kvack.org (Postfix)
	id E94116B07D7; Tue, 24 Nov 2026 12:09:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A9F6B07D9; Tue, 24 Nov 2026 12:09:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D805A6B07DA; Tue, 24 Nov 2026 12:09:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A46496B07D7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:09:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32800160A7F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:09:05 +0000 (UTC)
X-FDA: 85470647850.10.4A06217
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D87040006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:09:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jc6SEGgv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540143;
	b=2plSElXHMGcj6TB/UZAu9XVHtDi+X4UHIG4u+DyKUM832bLvuXJ8bYtuyHp1VhXN/nfGAh
	9bWf/GPb0LoY/9XlzB4xido+qJ3UWQWyJ2yNTWODsS/laFZpW4YCF6GeWiSt5IxFJkgy/5
	nqibMJI3gfKCHfuFn4QWhZWL9ZptOlA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awaDXuBzmGDSezRjdws9LozrH8vCNa9+sX+9QL+l1sc=;
	b=RX4e6nVLAji/LLpavfJnM8agSnrFiNvLOFm9RIc3qg2dDrmpHRZKt9VG3OJM8edJMqu9jy
	+jxIsC5YwKtlFwdHE5zGTvCIfoJzYWrFKtxPK72DqoB+V+4mkZSOxHJG4I01252ojAhQ/K
	n05AHbmCyz1KX9/T2kyc2d6ehiqwApc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jc6SEGgv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7007945CB9;
	Tue, 24 Nov 2026 17:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4341F01567;
	Tue, 24 Nov 2026 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540142;
	bh=awaDXuBzmGDSezRjdws9LozrH8vCNa9+sX+9QL+l1sc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Jc6SEGgvsuDipcGuSayddzZb4psR229ZH47/ivMzHAzdX3rICK2YUz4k1v7XDxcAP
	 xWA9SECNeVeO3jhiQY6I2GSxagYTZbW4VIc8UIcpVyp30LS6wqIyC6XDnf3QJfWScL
	 2PcdwyYfTLmKhZoBKL9VeXvAo7nR91rgWZEEhGpDY6BpuhS/tbjfOgF7vUxO10S3Yi
	 mIW0Eep9DlDePF5tLDg3JyieGSaq8uG7Eb4oYfLuP4UWbgeBXq/d/Jy0eW3d3ud+YT
	 1XF5sLdUHS7+32TD8NoHi2qIsH+B6h2doURdw1mJ55bAg5uS9wUmI6fW2U2VKMkebp
	 bkrQQ1fh1/8pA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:07:54 +0000
Subject: [PATCH v2 02/11] mm/madvise: convert madvise_vma_behavior() to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-2-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12014; i=ljs@kernel.org;
 h=from:subject:message-id; bh=pPuDrF7ehTflhEXcIW3SMy+byj5D4VLwwe1LU1fEsvA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+RuSH4x8+DDom5BB6W1SxOvFda2Cu6br2SyWoqjs
 vAZq7dnRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbybDIjw50Jm6/cCFIrK9rd
 2rngs3OKX/j3D0rFnvFs2x0OruEMvcjIMM3WoXf+WsnW2d+iLVxrziW3vK2d17GhrzDdkPVV6vH
 dnAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: up93znto4bt3gyqgqtny9ykyf7mfy8ct
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D87040006
X-Rspam-User:
X-HE-Tag: 1795540143-267041
X-HE-Meta: U2FsdGVkX19JOxgnMonS2HZXBnMlaZhkMGJKDmWk4D6FCy4favVZ5For/X4wV87u5Ht19HT2Or5FM6MXbEXjoJU59N7KYqPvzIvWbe9du01eocviWCenxtN1XGugZdXcwUHwVum4U4I9iItHgyoBjQAXQPX1BgTZTDkMiQAnMWa/oub7Fo/6xGCA7wFh8BCyI59T4dQQN2rDljHZ32BqO1H2LLOLV9LQeSLVPSpr3KB1fN5lVy+So/R/4+6tEo0mxljHj5N6L7qWiRPSGWrA2i62ZHjcGnDLfkWDM6I7cs7lYRpDjhGzZVRiRbMK0QvHxD6MW6KLQy59kiqlwHdIpYxQ0HaXS9LS5YkczwrlgznH9Rm9EyuG/ccr/AKslJsGalb6zruuyxAbQtYoA+JbUkff3gjkxOtZN9PXmeLammBbM5uPHujvJuiAao6ZL8f6nSWkwXVi2jZhIxzkq5t4OwPiQ8NuU3gSr+BWtbeL5gGCBwcEiQGoQRKd8gJsJ9f49aDv14OWKQAyDEyb5T1HkW67xUeEb/i68H5njUCDu+Fxy4yGapvFJ7BD+kDzRxE7jViUqbddt/jWX2xVyy7MzEdGX07vFWOkOqyrr7OJ2JRML6XygkxCvwfi0Bh03nDrMb+E7dS9ArbScCHLuNsUxKWPZoYFsKT7JJalTH0xpKz9aQ5zYYTV1ISqkp7pXTB9il0JrEPcHCe8iqlYe69ic3Fv269cJC3+cC/U1e8TGi5ETUlJcdAC7/LxJ83N2Q7G4liyBU/0PHyixz+rSFrGp4ongIJ3JVzefh8J0VXSKX9rRwSJ1t/jE1W5MnmLDGxXUcqalgcHO7maFgH9UvCZyWXgCE8BvgU9qRA2hPHFNrByN8pBJDOi8pnrgBP9lMGGjRexLpRjHmNE0rPMbye853qCrY4OBfiQ7rcIYBAGcm10goyZmvtR/4r9V6oa/39cXbE0OvHYK1qk1hw17Pu
 WGq47sBH
 JMXK7If+HwyNjMw7jHhK7M2zx+ZhFwgSFdwp3qsOSvA81C9iJ2ZlF/rTRFb6ZolaFDPFiSK3GMdKvlWzlwWtENGKhzRj/kpsMJWMLLxPmkqf0gPs3BvcrEgB8SSC0wqubYFIvs5oQTwSgYpSkfPmZQImS0Ngfxl0febu+ZXQhbV4AClAEXJHJn7TCZ3b9s9tAo4lqc/A6pHaDZD6Mvz7YbzeMxc0E/wOgbJBZSgxHXBiFTnsGmkSPKF+MITDL9D1V2byE4kTT/N9U4+a5bY/tXptXrW49I/Q8YKgVvwN9I7fxkprQqtlwY1TNiizrA5x7Ji1sXTp/Ub0BJ/ONPCSncc32ivADp9ycQHXrUq1PgKtfh6coOYQz5/cMRLB9UtYSDdlmZI5jDAoZ3j332kfv7phfwzuZ+FJ5ILqbIWPAA8tWceIeOR64/zL98rxu4sgCpcUYGMOJ4CGXqGEaYPaIsUk0kC1Y6frbBBGZS2ipQ6AF+qi5FXx8Lon6wrfPV8psnypwHWQm6AbRaK1XZwv9EJpPkq+QHGbtt4FmmKiQcnVqvbmPqYv3Dk1ZoqZtNG5gEtaDqAq4H+HOu1u+ZBsc/1DfIQ==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 10 ++++----
 include/linux/huge_mm.h            |  4 ++--
 include/linux/ksm.h                |  4 ++--
 mm/khugepaged.c                    | 10 ++++----
 mm/ksm.c                           |  8 +++----
 mm/madvise.c                       | 49 ++++++++++++++++++++------------------
 mm/mremap.c                        |  2 +-
 7 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 463aef870c4e..824fe27cf34b 100644
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
+				merge_flag, &vma_flags);
 		if (ret) {
 			ret = H_STATE;
 			break;
 		}
-		vm_flags_reset(vma, vm_flags);
+		vma_overwrite_flags(vma, vma_flags);
 		start = vma->vm_end;
 	} while (end > vma->vm_end);
 
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index fac05120ab77..087920c38163 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -507,7 +507,7 @@ change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			__split_huge_pud(__vma, __pud, __address);	\
 	}  while (0)
 
-int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
+int hugepage_madvise(struct vm_area_struct *vma, vma_flags_t *vma_flags,
 		     int advice);
 int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end, bool *lock_dropped);
@@ -709,7 +709,7 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 	do { } while (0)
 
 static inline int hugepage_madvise(struct vm_area_struct *vma,
-				   vm_flags_t *vm_flags, int advice)
+		vma_flags_t *vma_flags, int advice)
 {
 	return -EINVAL;
 }
diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index a0d358a1feb6..805aea997102 100644
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
index 5e768481ac22..4e5b94b59461 100644
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
index 623a2cdb3924..c4556f6a81de 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3022,7 +3022,7 @@ int ksm_disable(struct mm_struct *mm)
 }
 
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, vm_flags_t *vm_flags)
+		unsigned long end, int advice, vma_flags_t *vma_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int err;
@@ -3040,11 +3040,11 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
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
@@ -3053,7 +3053,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 				return err;
 		}
 
-		*vm_flags &= ~VM_MERGEABLE;
+		vma_flags_clear(vma_flags, VMA_MERGEABLE_BIT);
 		break;
 	}
 
diff --git a/mm/madvise.c b/mm/madvise.c
index 34b524c5ffc0..726825aee8d6 100644
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
@@ -627,7 +626,8 @@ static void madvise_cold_page_range(struct mmu_gather *tlb,
 
 static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_LOCKED|VM_PFNMAP|VM_HUGETLB));
+	return !vma_test_any(vma, VMA_LOCKED_BIT, VMA_PFNMAP_BIT,
+			     VMA_HUGETLB_BIT);
 }
 
 static long madvise_cold(struct madvise_behavior *madv_behavior)
@@ -675,8 +675,8 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
 	 * owner nor write capable of the file. We allow private file mappings
 	 * further to pageout dirty anon pages.
 	 */
-	if (!vma_is_anonymous(vma) && (!can_do_file_pageout(vma) &&
-				(vma->vm_flags & VM_MAYSHARE)))
+	if (!vma_is_anonymous(vma) && !can_do_file_pageout(vma) &&
+	    vma_test(vma, VMA_MAYSHARE_BIT))
 		return 0;
 
 	lru_add_drain();
@@ -923,12 +923,12 @@ bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv_behavior)
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
@@ -1063,7 +1063,7 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 
 	mark_mmap_lock_dropped(madv_behavior);
 
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		return -EINVAL;
 
 	f = vma->vm_file;
@@ -1377,7 +1377,7 @@ static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
 		return true;
 
 	/* If the user could write to the mapping anyway, then this is fine. */
-	if ((vma->vm_flags & VM_WRITE) &&
+	if (vma_test(vma, VMA_WRITE_BIT) &&
 	    arch_vma_access_permitted(vma, /* write= */ true,
 			/* execute= */ false, /* foreign= */ false))
 		return true;
@@ -1401,7 +1401,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 {
 	int behavior = madv_behavior->behavior;
 	struct vm_area_struct *vma = madv_behavior->vma;
-	vm_flags_t new_flags = vma->vm_flags;
+	vma_flags_t new_flags = vma->flags;
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	int error;
 
@@ -1432,44 +1432,47 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
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
index 91af75cbbc60..a5fb94443b00 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1131,7 +1131,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	struct vm_area_struct *vma = vrm->vma;
 	unsigned long old_addr = vrm->addr;
 	unsigned long old_len = vrm->old_len;
-	vm_flags_t dummy = vma->vm_flags;
+	vma_flags_t dummy = vma->flags;
 	const bool split_before = vma->vm_start != old_addr;
 	const bool split_after = vma->vm_end != old_addr + old_len;
 

-- 
2.56.1


