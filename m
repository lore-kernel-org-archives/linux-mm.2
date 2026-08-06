Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A78C5AC82
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BEB6B00A6; Thu,  6 Aug 2026 16:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD196B00A9; Thu,  6 Aug 2026 16:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5106B00AA; Thu,  6 Aug 2026 16:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4C06B00A6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:22:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86ADB4020D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:22:54 +0000 (UTC)
X-FDA: 85071968268.13.3D20F2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D058440002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:22:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XXE4sYAY;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786047772;
	b=RE0XLJpJpN0uI3nwJzSc+U4wLQB7+lwoWxdkLFI7USvaMczsYkv43QQVfnWQ5dBjBYVSjD
	PuhWYDzXQx5G6ed8sy77Qa0jyLEWZkCT5+IzNaNHCvCN8OPYBB3Fa5lb2th8elVvtW0WZp
	i2Azfdz/T7+kPj7ve6tw2pRse2WHDQ4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XXE4sYAY;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786047772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAWi93tteqsMNI4R2OumTdu2t8reun/HOO0+iBU7Y6U=;
	b=AH0RgW1Jw6BD2U5p2lGofuXeO0FCc5fnZNFsnfzb6xmeIjcFUmE92/Ou+nsYLRroI1znI9
	I6HV2CX0HtoTc+Nmuwrh8urq8fXTdFIQqdvqOcorvlldIOfruSN8Xd+QuqQvZ+fFa+Jh8q
	eNtJgbfo4avGWn3ERYwA13DmqwAayMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F67B6004E;
	Thu,  6 Aug 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DAF1F000E9;
	Thu,  6 Aug 2026 20:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786047772;
	bh=jAWi93tteqsMNI4R2OumTdu2t8reun/HOO0+iBU7Y6U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XXE4sYAYPvr+PEFQ0FdIwQunnJejWY9UR4PHl+cRyosAU/tYW/DtCgwPGPkEltz3t
	 h8w3sU3aH3KIqT8ImT3sBnVh6eEWw10m8rfiupgBAwsjZHWzT2yyJjTL0XSgPUXvSd
	 ML+DnnVIVc4Y3/peVZFDL+8/sDH+HNTEjXtRuINojPQKNJ4pnsmfw4lgTBzCaTTXzy
	 hN/x+Z4yhMCpoKtaJgxsgwUdYRu1dt5fsiPFcR/+Yt1QNtjVwyAFYHCWuq98paPPiE
	 XOanTifGQsUU5kZICN9fJ0OXjBH9tcx/7bT9mtztE7dGb5Kvw/RPpeOytQ/wWFm9JZ
	 BH02ZZG0aRNxA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:27 +0100
Subject: [PATCH v4 02/20] mm: provide vma_[flags_]is_cow_mapping() and
 remove is_cow_mapping()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-2-ab318a350404@kernel.org>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=16544; i=ljs@kernel.org;
 h=from:subject:message-id; bh=8xVRumSCjVSb6eGVXrjrRj8juxOTPyHD6yRzx20H9us=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3pxX8qyUnv9X7NdJV9HCNy2zj8tsaL23YuOtSfua6
 59UZMz17ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE1DMZ/gqF1K/MPrBa+vT0
 dRXLtmqxhxedKZ40eY5wYWBx0LEbebGMDMeuzwg5oti1R2Rv/DsmgX6JVznMslN8Kkvuzz2eLtY
 ayw0A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D058440002
X-Stat-Signature: gimspockef1twd9qnhp35edcskxahtrj
X-Rspam-User: 
X-HE-Tag: 1786047772-672956
X-HE-Meta: U2FsdGVkX1+thBgHSLo8kppsG8fVPpKuRBDfbrUOkIPfeFh/xkhDcXxH4IZCdusaG6k0HpEi66UjS+UT0WQqxGXU2gkWR8s+XlTxovEgPz/UbsVYexw7pVrry8dot7J/o0toOaAtnabo7yBD/oNlA1IHVoUrH5IhrjHd4V+CW2ar8UCovbFt70gIU5vYFF8sAnmAAz062FFQ/DKWomkWb316Zb2dvkVrzNWHj7DTHccr/93e5TPV2Qp+9yPL7wOQDbvyVDSRadzADtGFSXTvhcd9TH7HQ1KDkFWD/xNIgRutj+J9tlK7S/tiE4zjoq9wWB27G9WNov4m6ZHF41Lz8Yu59uDWXM5USag5OiL2WqdnKvG4wwgmk+5g9s2zzuSd4+VecJWn9e0HR0F5MZPdujD+wEAtOKaspthNwUxm/8DVjxCW43+0nuplIsv5r71kslk5+UHrH5OvvjO1cJ2GhzpSHm6s5VVx/I/2FeTFs3CEYYKgCiRTfIaXecyjGuZOv6l1qL/ovmuMEM7DtL3tfXt7LUeXi8jfFZ2RHCS+Gl6dBJp1H7oejdGmet08u58tA8ifR1OdWe/ZJ9DCk5H5gL4cyBqT79lVAeohJgZRyY0rWhhS2QZUEJRAMYw38GievhP7P5oB1L7GeGdWrDSKr84gAMR0PqKFi1vKumA8WXrbYhq++LYx2UmSE4H9lli5lIjNl8XxKsGPdEOZmu/L1PQTlDF37rvN0f05mtN0OTGxNDG50DYiAX5DGpcwJyWhvsKjxk/BmcFAqFD9GWIeRHKpaqNdzAK82RCdeOpos8c+DBjODUm2DmESqt25F4+zOi7DS+xtAFfv89tFLeTLM/5/GJPvZq1OvHJyQLOqd991AIqXRhwB0lnfUpbRsAuflsGwThSd99+UD1LlOYhqMkY4vHs//WSE/aMNMTLWj6K4KhjRC2Uf3sWb6hVM5bSdj4ekkc9z5HThiQFp7do
 JSp/YXG6
 wESUjEMl+rXLZScJtQRwcnoKq2n6KcpvBhwJEO/CeaxSbktWxZuWWjg8ZE1ExVEMjnHccS5eXCD4XqD3eq4H7Q9X7glfB+ujbf9cyt8dADXRavrwSZxwWxHbOCzQgx3KvLYX3U8VEalZmt7mX9PX80/xv+ZX64KAA/Ejce2elDg2SFF9fhSpmkYPHOPuyN3ilkak2aA8lELdC8HejTLzzwXuUMFSNSUGp1wo3dkOsiH7JyfrS1x0Z4wgKBtmogbXwztRfXGE0+do8uI5Z+/mCLr2iYDklBkrHjkrIwvL6J7rB7wdAKPJqMUU9goJnnihgBFKh2H8Rmb5nrz/Fs4sCkpS3EO1iKj56ve2YHG6BWAUEGKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All remaining callers of is_cow_mapping() are invoking it in the form of
is_cow_mapping(vma->vm_flags) or an indirected version of this.

Therefore, provide a helper - vma_is_cow_mapping() to directly test the
VMA.

Additionally provide a new helper vma_flags_is_cow_mapping() which performs
the check using the new vma_flags_t type, and share this logic between
vma_is_cow_mapping() and vma_desc_is_cow_mapping().

With these changes, no callers of is_cow_mapping() remain, so remove it.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/s390/mm/gmap_helpers.c             |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |  4 ++--
 drivers/gpu/drm/drm_gem_shmem_helper.c  |  2 +-
 drivers/gpu/drm/panthor/panthor_gem.c   |  2 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c         |  2 +-
 drivers/gpu/drm/xe/xe_device.c          |  2 +-
 fs/proc/task_mmu.c                      |  2 +-
 include/linux/mm.h                      | 15 +++++++++------
 kernel/events/uprobes.c                 |  2 +-
 mm/gup.c                                |  2 +-
 mm/huge_memory.c                        |  8 ++++----
 mm/hugetlb.c                            |  2 +-
 mm/internal.h                           |  2 +-
 mm/memory.c                             | 25 ++++++++++++-------------
 mm/mempolicy.c                          |  2 +-
 tools/testing/vma/include/dup.h         | 11 +++++++++++
 16 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index 4bf7c9012feb..cd5fded159c0 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -200,7 +200,7 @@ static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
 		 * currently only works in COW mappings, which is also where
 		 * mm_forbids_zeropage() is checked.
 		 */
-		if (!is_cow_mapping(walk->vma->vm_flags))
+		if (!vma_is_cow_mapping(walk->vma))
 			return -EFAULT;
 
 		*found_addr = addr;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 6a0699746fbc..0c7309080a7a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -377,9 +377,9 @@ static int amdgpu_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_str
 	/* Workaround for Thunk bug creating PROT_NONE,MAP_PRIVATE mappings
 	 * for debugger access to invisible VRAM. Should have used MAP_SHARED
 	 * instead. Clearing VM_MAYWRITE prevents the mapping from ever
-	 * becoming writable and makes is_cow_mapping(vm_flags) false.
+	 * becoming writable and makes vma_is_cow_mapping(vma) false.
 	 */
-	if (is_cow_mapping(vma->vm_flags) &&
+	if (vma_is_cow_mapping(vma) &&
 	    !(vma->vm_flags & VM_ACCESS_FLAGS))
 		vm_flags_clear(vma, VM_MAYWRITE);
 
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 06d019d51d3e..177d0e0b9334 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -753,7 +753,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 		return ret;
 	}
 
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return -EINVAL;
 
 	dma_resv_lock(shmem->base.resv, NULL);
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 770556353968..d2eec46f7abe 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -761,7 +761,7 @@ static int panthor_gem_mmap(struct drm_gem_object *obj, struct vm_area_struct *v
 		return ret;
 	}
 
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return -EINVAL;
 
 	if (!refcount_inc_not_zero(&bo->cmap.mmap_count)) {
diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index 88babf435ac2..872bf444b1f0 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -489,7 +489,7 @@ static const struct vm_operations_struct ttm_bo_vm_ops = {
 int ttm_bo_mmap_obj(struct vm_area_struct *vma, struct ttm_buffer_object *bo)
 {
 	/* Enforce no COW since would have really strange behavior with it. */
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return -EINVAL;
 
 	drm_gem_object_get(&bo->base);
diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 838797cc65d7..ab16937ebbe0 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -330,7 +330,7 @@ static int xe_pci_barrier_mmap(struct file *filp,
 	if (vma->vm_end - vma->vm_start > SZ_4K)
 		return -EINVAL;
 
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return -EINVAL;
 
 	if (vma->vm_flags & (VM_READ | VM_EXEC))
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 817e3e0f9194..5c54aebe2118 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1693,7 +1693,7 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
 
 	if (!pte_write(pte))
 		return false;
-	if (!is_cow_mapping(vma->vm_flags))
+	if (!vma_is_cow_mapping(vma))
 		return false;
 	if (likely(!mm_flags_test(MMF_HAS_PINNED, vma->vm_mm)))
 		return false;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index df78847f5f07..a3368c542947 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2271,17 +2271,20 @@ void unpin_user_pages(struct page **pages, unsigned long npages);
 void unpin_user_folio(struct folio *folio, unsigned long npages);
 void unpin_folios(struct folio **folios, unsigned long nfolios);
 
-static inline bool is_cow_mapping(vm_flags_t flags)
+static inline bool vma_flags_is_cow_mapping(const vma_flags_t *flags)
 {
-	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
+	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test(flags, VMA_SHARED_BIT);
 }
 
-static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
+static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
 {
-	const vma_flags_t *flags = &desc->vma_flags;
+	return vma_flags_is_cow_mapping(&vma->flags);
+}
 
-	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
-		!vma_flags_test(flags, VMA_SHARED_BIT);
+static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
+{
+	return vma_flags_is_cow_mapping(&desc->vma_flags);
 }
 
 #ifndef CONFIG_MMU
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ae2f3b9f8d50..eb0d11092fb3 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -513,7 +513,7 @@ int uprobe_write(struct arch_uprobe *auprobe, struct vm_area_struct *vma,
 
 	uprobe = container_of(auprobe, struct uprobe, arch);
 
-	if (WARN_ON_ONCE(!is_cow_mapping(vma->vm_flags)))
+	if (WARN_ON_ONCE(!vma_is_cow_mapping(vma)))
 		return -EINVAL;
 
 	/*
diff --git a/mm/gup.c b/mm/gup.c
index 1d32e9a3dc79..b534ef58c46a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1236,7 +1236,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 			 * Anon pages in shared mappings are surprising: now
 			 * just reject it.
 			 */
-			if (!is_cow_mapping(vm_flags))
+			if (!vma_is_cow_mapping(vma))
 				return -EFAULT;
 		}
 	} else if (!(vm_flags & VM_READ)) {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9b1f3b24f7e0..6b0cabd45b2d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1638,7 +1638,7 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
@@ -1746,7 +1746,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
 	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
@@ -1888,7 +1888,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 * applied special bit, or we made the PRIVATE mapping be
 		 * able to wrongly write to the backend MMIO.
 		 */
-		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
+		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
 		goto set_pmd;
 	}
 
@@ -2009,7 +2009,7 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
-	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
+	if (vma_is_cow_mapping(vma) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d86a27c8819c..560e85ca1d1c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4905,7 +4905,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	pte_t *src_pte, *dst_pte, entry;
 	struct folio *pte_folio;
 	unsigned long addr;
-	bool cow = is_cow_mapping(src_vma->vm_flags);
+	bool cow = vma_is_cow_mapping(src_vma);
 	struct hstate *h = hstate_vma(src_vma);
 	unsigned long sz = huge_page_size(h);
 	unsigned long npages = pages_per_huge_page(h);
diff --git a/mm/internal.h b/mm/internal.h
index f26423de4ca2..a75a1344e9ba 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1341,7 +1341,7 @@ static inline bool gup_must_unshare(struct vm_area_struct *vma,
 		 * ... because we only care about writable private ("COW")
 		 * mappings where we have to break COW early.
 		 */
-		return is_cow_mapping(vma->vm_flags);
+		return vma_is_cow_mapping(vma);
 	}
 
 	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f692..e1349e18f046 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -780,7 +780,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 				/* Only CoW'ed anon folios are "normal". */
 				if (pfn == index)
 					return NULL;
-				if (!is_cow_mapping(vma->vm_flags))
+				if (!vma_is_cow_mapping(vma))
 					return NULL;
 			}
 		}
@@ -1002,7 +1002,6 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, unsigned long addr, int *rss)
 {
-	vm_flags_t vm_flags = dst_vma->vm_flags;
 	pte_t orig_pte = ptep_get(src_pte);
 	softleaf_t entry = softleaf_from_pte(orig_pte);
 	pte_t pte = orig_pte;
@@ -1026,7 +1025,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		rss[mm_counter(folio)]++;
 
 		if (!softleaf_is_migration_read(entry) &&
-				is_cow_mapping(vm_flags)) {
+				vma_is_cow_mapping(dst_vma)) {
 			/*
 			 * COW mappings require pages in both parent and child
 			 * to be set to read. A previously exclusive entry is
@@ -1067,7 +1066,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 * save and restore device driver state).
 		 */
 		if (softleaf_is_device_private_write(entry) &&
-		    is_cow_mapping(vm_flags)) {
+		    vma_is_cow_mapping(dst_vma)) {
 			entry = make_readable_device_private_entry(
 							swp_offset(entry));
 			pte = swp_entry_to_pte(entry);
@@ -1082,7 +1081,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 * exclusive entries currently only support private writable
 		 * (ie. COW) mappings.
 		 */
-		VM_BUG_ON(!is_cow_mapping(src_vma->vm_flags));
+		VM_BUG_ON(!vma_is_cow_mapping(src_vma));
 		if (try_restore_exclusive_pte(src_vma, addr, src_pte, orig_pte))
 			return -EBUSY;
 		return -ENOENT;
@@ -1181,7 +1180,7 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 	}
 
 	/* If it's a COW mapping, write protect it both processes. */
-	if (is_cow_mapping(src_vma->vm_flags) && writable) {
+	if (vma_is_cow_mapping(src_vma) && writable) {
 		wrprotect_ptes(src_mm, addr, src_pte, nr);
 		pte = pte_wrprotect(pte);
 	}
@@ -1602,9 +1601,9 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	 * We need to invalidate the secondary MMU mappings only when
 	 * there could be a permission downgrade on the ptes of the
 	 * parent mm. And a permission downgrade will only happen if
-	 * is_cow_mapping() returns true.
+	 * vma_is_cow_mapping() returns true.
 	 */
-	is_cow = is_cow_mapping(src_vma->vm_flags);
+	is_cow = vma_is_cow_mapping(src_vma);
 
 	if (is_cow) {
 		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
@@ -2388,7 +2387,7 @@ static bool vm_mixed_zeropage_allowed(struct vm_area_struct *vma)
 	if (mm_forbids_zeropage(vma->vm_mm))
 		return false;
 	/* zeropages in COW mappings are common and unproblematic. */
-	if (is_cow_mapping(vma->vm_flags))
+	if (vma_is_cow_mapping(vma))
 		return true;
 	/* Mappings that do not allow for writable PTEs are unproblematic. */
 	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
@@ -2839,7 +2838,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -3251,7 +3250,7 @@ static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma,
 				       unsigned long size)
 {
 	const unsigned long end = addr + PAGE_ALIGN(size);
-	const bool is_cow = is_cow_mapping(vma->vm_flags);
+	const bool is_cow = vma_is_cow_mapping(vma);
 	int err;
 
 	err = get_remap_pgoff(is_cow, addr, end, vma->vm_start, vma->vm_end,
@@ -6751,7 +6750,7 @@ static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
 		 * FAULT_FLAG_UNSHARE only applies to COW mappings. Let's
 		 * just treat it like an ordinary read-fault otherwise.
 		 */
-		if (!is_cow_mapping(vma->vm_flags))
+		if (!vma_is_cow_mapping(vma))
 			*flags &= ~FAULT_FLAG_UNSHARE;
 	} else if (*flags & FAULT_FLAG_WRITE) {
 		/* Write faults on read-only mappings are impossible ... */
@@ -6759,7 +6758,7 @@ static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
 			return VM_FAULT_SIGSEGV;
 		/* ... and FOLL_FORCE only applies to COW mappings. */
 		if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE) &&
-				 !is_cow_mapping(vma->vm_flags)))
+				 !vma_is_cow_mapping(vma)))
 			return VM_FAULT_SIGSEGV;
 	}
 #ifdef CONFIG_PER_VMA_LOCK
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5720f7f54d94..3498a5651d50 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -844,7 +844,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 		return false;
 
 	/* Also skip shared copy-on-write folios */
-	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
 		return false;
 
 	/* Folios are pinned and can't be migrated */
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 26d9210b1e8b..40ad83936b28 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1162,6 +1162,17 @@ static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+static inline bool vma_flags_is_cow_mapping(const vma_flags_t *flags)
+{
+	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test(flags, VMA_SHARED_BIT);
+}
+
+static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_cow_mapping(&vma->flags);
+}
+
 static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 {
 	/*

-- 
2.55.0


