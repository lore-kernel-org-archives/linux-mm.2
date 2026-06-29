Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5B7C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548566B00CB; Mon, 29 Jun 2026 08:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FFF6B00CD; Mon, 29 Jun 2026 08:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A3D6B00CE; Mon, 29 Jun 2026 08:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4346B00CB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BC4F40666
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:00 +0000 (UTC)
X-FDA: 84932869560.26.4448F91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F41FFC000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LC8VtPYz;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735899;
	b=CZ92VSWDLSPeUvJe2EMp6X+/rp5k2C4XnI4QpCrbYzb4gvKiFdnJcvJndXMslG8i5bJ2xj
	0U2BQR78pjfcHkmze/07AiPHm4NgfK/fMkiVKsgiya7SsCHXR8EeU2syz4ZPy/Z2I0IbXP
	WJJA1T5I7xACJjw+7JBcEnE6UFm8bG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6T1iWSEXJtO4Ol/BA3gpFHV+/0gKCk1DbIlaaeu8VM=;
	b=I62kZVJbn2RQJKictin4e3YuCeZDtPLyqQ7GrpawwNK1THUtEkFDkyoaOJTSKlYyRyitIB
	ysPG1E8bCEA2Dzdyg3qvc6tRWMAaeZ3YLLTa1pFZGB4dzJ1iWKwsQD4jyFbK5nVtVTYq6J
	lSee23UFh6Kpyet/sBAmEKaS5OFw+Wo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LC8VtPYz;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B6886001D;
	Mon, 29 Jun 2026 12:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A521F000E9;
	Mon, 29 Jun 2026 12:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735898;
	bh=n6T1iWSEXJtO4Ol/BA3gpFHV+/0gKCk1DbIlaaeu8VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LC8VtPYzfBDn0IT72dDOkbWV0WRSLf9IMTrBsPoKyWemI+ySsQR91N3T+gF5VUjPk
	 vJ/A02mPxatWNByRseH/44QDY6V7GxURExlUMgpWc6Ak0sIqOgqIB89+Dhtiz3DdaG
	 0qDDEK3Kw5b+lPx1blaG9h4PjSQv6pYATJEXJn1gVoSDSzHVV2QcCkISf49YvzLmOs
	 bWKRZVJOCgN/LnWSTThp3BqEnLf6yht4HhcexHl5j948YFGHeGgOFuaos8+m9BA1RV
	 HjcHH1HvULwL911lM1Mca9m5XW5H0chyhZ42L4YjclZADCKQaoLUCEzOrF3dzZjn7A
	 Ytzbnh24BtJ6Q==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 21/30] mm/vma: add and use vma_[add/sub]_pgoff()
Date: Mon, 29 Jun 2026 13:23:32 +0100
Message-ID: <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zequ81wuwbxc6b6way7bu6cmp8jc9qyz
X-Rspamd-Queue-Id: F41FFC000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782735898-837962
X-HE-Meta: U2FsdGVkX1+PYKTEV90SmT7fCUG9Z9RUksaLa2xMtXjFJdZ1Z4DvSW3cepd9V9hxBjmzuRI0bbpkmif4PkvslTXGIRFtRb/h64Q5kmgf2Asf2pwa/bB5h6R6cTke9QgjlRg+iGFQPWNz9szHoJAzOPn6ZwhDTVGP2KIm3kwP6spFZPJx1o31suDOGM1PKnqaPMB5ODUoS5afj13omlCQ36ZMnzlbnYu+RWF9uyD7WCllHszmGvK1uLGuFDz1DwidSwjze4BqlHQ/HOk2PiPKMpt07q6manb7EtFAmBOxZf9XBBASp8N+KEqNZejZRR/j8rEoMtbWK13cxMBKUUKcIvGPIRfcQXPGUkcGvntf8LPppPQwZnYSISvZeTvwfleWW5Alkd0aKZQFEfn75oNd6APA6dqRXa8n/lq6wKx5hV5kKeDWjLW8ENZALz9pmJPp1i2EoFq72ArZzcMnKoaz4oc/by9NIRqDss98lYhekWpxVRzRNbiOWH/cyaLSu+H2Uv7oZkcPsEh5BrxCGhHfnjUNBiyEJRfjwPJeRHBu4sk9j1j7ilADQtBUWSOZpD9T4RGHBOSLYhwQT69EZ/KW4MwTXiGWzkH+cpmOe1nRpoO3+ElM0PwetKO7/jZ/q4Pf+ZOiSaSTFvpQhJfB039vXLWCqOyKrIcCQX40PddGMfJI7jwmgiMeq6HFLhG7hiL53ZUtkd7Rk6ZyBrpL2K0yjK8veoDQ+MM6nH/UjzylKlWEmG1szX4TgS8LarALfuBlKh/fl2NVEhDMOzeRmg23Q5zJ+N3OliJlXvOCca5gjisY5MKgjQ2CABpWiI72DjXqwmsUkCFOrobrsOT4J5b1hxnUSlt2rnkWuCxfzaeF9l0myjMpF89H0z9Nte2t6lmTg7lDiknrVHE6mxOK4dmNnJm20VjwnLT4+F7KR6ofFSYvVyRRVwSbhlVLR4H08eR+AYHdoqGzPx/fWXZaFOe
 hfH0B5PQ
 1YDzzuEcJilw8MoMU35UF/gcGYij+TsT0fsCS4m7vdPTCTVvVEfFrnXmucEyryhgUh3kwthdJ+vwawaKHdkGhEE/SQvQ5H/REfUxjsxFTrDAenM/U4XkWaKkxZbxoVWXWmW4aoI/yOHjpGO9PfaJuEdMdhx8e/8R2QD3VAkAnMbf+edZCGEEeF9IhWhnvTUzZnNgFGWIINBfgaH7o5gFGwoxEgXa8vRe6h7QrnrsV1rtlwPO4M05gAZZIAOY1IheLVrNgWVx+3DKp/CWbjEAKF1iGHdCT7kEG7c7XntAVAPrqlPMZ5dIXItw++bPCg8RYAJUdQMrHkKkxoIJR7xeAqBhCWtWex6pT44V+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helpers for adding or subtracting to a VMA's page offset, exposed
internally for VMA users within mm in mm/vma.h.

This is to lay the foundations for tracking anonymous page offset for
MAP_PRIVATE file-backed mappings, where adding and subtracting from this
value must be reflected in both the file and anonymous offsets.

These are used on VMA split and downward stack expansion.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/nommu.c                      |  6 ++++--
 mm/vma.c                        |  6 +++---
 mm/vma.h                        | 12 ++++++++++++
 tools/testing/vma/include/dup.h | 13 ++++++++++++-
 4 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 7333d855e974..c7fafcd87c14 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -41,6 +41,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include "internal.h"
+#include "vma.h"
 
 unsigned long highest_memmap_pfn;
 int heap_stack_gap = 0;
@@ -1338,7 +1339,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		region->vm_top = region->vm_end = new->vm_end = addr;
 	} else {
 		region->vm_start = new->vm_start = addr;
-		region->vm_pgoff = new->vm_pgoff += npages;
+		vma_add_pgoff(new, npages);
+		region->vm_pgoff = vma_start_pgoff(new);
 	}
 
 	vma_iter_config(vmi, new->vm_start, new->vm_end);
@@ -1355,7 +1357,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	delete_nommu_region(vma->vm_region);
 	if (new_below) {
 		vma->vm_region->vm_start = vma->vm_start = addr;
-		vma->vm_pgoff += npages;
+		vma_add_pgoff(vma, npages);
 		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
 	} else {
 		vma->vm_region->vm_end = vma->vm_end = addr;
diff --git a/mm/vma.c b/mm/vma.c
index 185d07397ca6..cb7222e20c93 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		new->vm_end = addr;
 	} else {
 		new->vm_start = addr;
-		new->vm_pgoff += linear_page_delta(vma, addr);
+		vma_add_pgoff(new, linear_page_delta(vma, addr));
 	}
 
 	err = -ENOMEM;
@@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	if (new_below) {
 		vma->vm_start = addr;
-		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
+		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
 	} else {
 		vma->vm_end = addr;
 	}
@@ -3305,7 +3305,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
-				vma->vm_pgoff -= grow;
+				vma_sub_pgoff(vma, grow);
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
diff --git a/mm/vma.h b/mm/vma.h
index 2342516ce00e..47fe35e5307e 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -247,6 +247,18 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
+static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
+{
+	vma_assert_can_modify(vma);
+	vma->vm_pgoff += delta;
+}
+
+static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
+{
+	vma_assert_can_modify(vma);
+	vma->vm_pgoff -= delta;
+}
+
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
 	struct vma_merge_struct name = {				\
 		.mm = mm_,						\
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 7ed165c8d9bc..41fea90a344d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1163,6 +1163,11 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -1170,7 +1175,13 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
+}
+
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
-- 
2.54.0


