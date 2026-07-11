Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E005C44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4FD6B00A5; Sat, 11 Jul 2026 14:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E806B00AA; Sat, 11 Jul 2026 14:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026436B00A7; Sat, 11 Jul 2026 14:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2CC66B00A5
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:48:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39F3F1A07C5
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:48:54 +0000 (UTC)
X-FDA: 84977382588.19.ADB677E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E786240008;
	Sat, 11 Jul 2026 18:48:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T2G/K9FQ";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUC24CQFaY5LbYrAu8Wt8s4S5Jfizo903DYj6Alr2hU=;
	b=6leZP/wtQjL2JOuRjqBC2kVLqCdfT18x5lG+e15wROPbrdJl2wdXKi5Jfg7UTHEX1uZpol
	4XUP+NBwRcW7XJbxsmTZaxdJAvV1fGdHzqKh4LCvTLYXfxXetArWrnkxdtbo9nH7Ol6K1y
	W55vgjCR3edLZbcfpNRdPEroYT37Ab0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T2G/K9FQ";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795732;
	b=JU/Y4GueM2EZStGvJG+Rat/3RlalIxFHJwRXmmET0pDl/4hXZPX7qoqJRrve2xm5PsJ6FU
	CkwdLOHbdMgq8hVUmODPKgmiTV/uM7DPaz5cawJc/uasz3x3GBScsSDL5n0tNNOFamui0Q
	MzwGHc5J+qBG3Cf3Ou+U/JQ3GLX2T4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AF7E418D3;
	Sat, 11 Jul 2026 18:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9008E1F00A3A;
	Sat, 11 Jul 2026 18:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795731;
	bh=xUC24CQFaY5LbYrAu8Wt8s4S5Jfizo903DYj6Alr2hU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T2G/K9FQZYBazUrgB2p6/rvfCKhk9yVPWpSxduMlumEpHCAb8GIbHDFOcJ29GZ34U
	 FXoVtM0TahqpG2/h+I35MFGUy4UrraSO9nANAAN+M49Y3tgJA4m0CYLj+ru8taIP0e
	 7EwnqOpFEKL4iXCg5QZZwK5koK5H5QEVreRGd5cREPAjXQl/m6ADMh2C7JiS0ReU18
	 sLcJRzfxdd1qFQvsCzgzdlU8pnCRI6OHlZ/0t0TJhZtZlO6HOaThVpZM8GMKxdOOxO
	 D08lfnlYbZAwAhOcCcewMb1kpDKqfnnPKEY1kl5rBn0b7BUgoqExRSpaXAvWTzltve
	 YRk/0mVL7ztfw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 19:45:06 +0100
Subject: [PATCH v2 09/13] mm/vma: update create_init_stack_vma() to use
 vma_flags_t
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-vma-flags-mm-v2-9-0fa2357d5431@kernel.org>
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
In-Reply-To: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Russell King <linux+etnaviv@armlinux.org.uk>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Sandy Huang <hjc@rock-chips.com>, 
 =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
 Andy Yan <andy.yan@rock-chips.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>, 
 Helge Deller <deller@gmx.de>, Kees Cook <kees@kernel.org>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org, 
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4313; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9FQuWO1YsUxULowpltE39pKMqBbYRFh58BoyoKhWb3A=;
 b=kA0DAAoWz53NioHifxQByyZiAGpSjzqg8y14Kh5MvFuw4iTsl7kJvl53Dij+JdajKdpzjYsNp
 oh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmpSjzoACgkQz53NioHifxQcIwD/VYCq
 8XVlwzBqdiLqx84JrVaGvSVASgylLrKcnFTCHu8BANPzzRn5WflkqRuMXJ46TwzQqPTztlhZtDp
 EX8lo8YsM
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E786240008
X-Stat-Signature: uapcbkkp8ozo4tfwtifets7fwiw7kpbo
X-HE-Tag: 1783795731-523793
X-HE-Meta: U2FsdGVkX1/sNBCsBJrzLACwg/ta2oH2rXC5zJ31SxAVKzS0wltYL8dj7mjsC7ZPmi/bH8ZPVwRtkA3n4xKiagaSae/IGbYITHM40uHJz5FNzpolYN8L9GMDlzixiNi7btKxxfMMHVpLLyM6jwdswZB+34xM+IliM3XF3C1gyCWm+AJY4c7wKAjKnxvX8VggLPjYpS82QaIdo4ZYF6m6qnBVCxdrOvIwIs+x8y1AXzZzFoCJgZsEdCfoI7XlCR8LilZlQ/DlcmEhjyXdUGBsVxDjV/Mo9EShk653QyYFvQk2+K8S+AqJ2baOXsVa/Wqzaglm3jnStMp7FdhyX7zqgJJ6gqU8C1nzVxGwtDsI6nFZPxPxP1qMgeduS5JyWJQ0EzIVrf7DLA+Git7qMRXlOEi0trHFHN9mCMgLqd8VzNuBPeXcrAZJ4I9jUTOPek87vgP4qZwqUgH0sRp2q5z+UpR/n3jVfbk3Tq3lj8RJwTT2qT+VqIqqUMfUsX121NhJPS2TrMh2gKFAKAPDWO/uRCQlXzJCdV6MLdBP4fSyv4YfhOf2GUHqL2f6pi7bIX6+971uvr/fBw8U4C3Y+oLABRqWz0VJjK29QS/dZ3EKbgGSqeZ/G2X+Yd2SRNmoJCODleIep0q8lJuEm7xG0w1jMSo8NyFUJASqk9VVS3lOi2rbLejMn/jea3SUTQY7FFWOn5pyXEI4EW9zQjnuvGERTcCxCmYwaf2FCavEdN4qMoGq36SCvmLDBQzvTrwL87a3Um22VJyBJLJNxuBMPpoqOnuK+MahzMjFO027gtA0RJVrhGRNVH4kvOWcRNP3AcOCrwEb5IMAeVSg0oajDtmLi26l5kZ6zOkSwBbTf53NAyyVDYXtv7HOQhk7ZXin2xfaX4uQgJ7MCLDaRuvk6kmA0Oe6g4N9B9jl1sOpInE1xVN/FnQsA8SbHU3geglTQOGi0eLaSqseEX4joGxSS9c
 cKY8p8Gn
 yQ5vcFaErc9wfiizlO+sP1d5ykkh90qUwWou93krFKKV50PviAEclXP+jXweeoiTiE8cYa8iOWO1B1Tma+YlJQ7EE5ZYeE0M2dCmLmaHFqeZwWITp5jkPwX5eJki6JjX9FmWEKtHYOT6AgeDEJlkAO9kgaYlKlYfMFki0lougwepEdX5Aaz4nFI+UKgm9UzYK4YtYoHA+XNgQBNLcb2pOhPUon0PsHt2suf7ZbjsFlh2YL21OLsNiNYl4Akoa2xMlNj/7rlullfam0jWHbplFuOHE83A9pXZ05HKnAxH0EGwgEUm9PBQmDl2N1oWlS+PT9+HZhGm3/n4Em2vOR90bUxQ67UxXeD2JMrPreOR6p788//uEhvvupI0znK/QVeeRduzvzqofzXrgCsX54zlqE9GV+IoPQGKdBXXUHL+FRsvnjM9/IjRWGBssqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace use of the legacy vm_flags_t flags with vma_flags_t values in
create_init_stack_vma().

As part of this change we add VMA_STACK_EARLY and VMA_STACK_INCOMPLETE
vma_flags_t defines, and slightly rework create_init_stack_vma() for
clarity.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h              |  4 ++++
 mm/vma_exec.c                   | 18 +++++++++++-------
 tools/testing/vma/include/dup.h |  4 ++++
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1209db1a4b92..550fb92957d1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -442,8 +442,10 @@ enum {
 #define VM_STACK	INIT_VM_FLAG(STACK)
 #ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
+#define VMA_STACK_EARLY mk_vma_flags(VMA_STACK_EARLY_BIT)
 #else
 #define VM_STACK_EARLY	VM_NONE
+#define VMA_STACK_EARLY EMPTY_VMA_FLAGS
 #endif
 #ifdef CONFIG_ARCH_HAS_PKEYS
 #define VM_PKEY_SHIFT ((__force int)VMA_HIGH_ARCH_0_BIT)
@@ -544,6 +546,8 @@ enum {
 
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
+#define VMA_STACK_INCOMPLETE_SETUP append_vma_flags(		\
+	VMA_STACK_EARLY, VMA_RAND_READ_BIT, VMA_SEQ_READ_BIT)
 
 #define TASK_EXEC_BIT ((current->personality & READ_IMPLIES_EXEC) ? \
 		       VMA_EXEC_BIT : VMA_READ_BIT)
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index a3c6b05c65fe..7af1260689b9 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -112,15 +112,17 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p)
 {
-	unsigned long flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
+	vma_flags_t flags = VMA_STACK_INCOMPLETE_SETUP;
+	struct vm_area_struct *vma;
 	int err;
-	struct vm_area_struct *vma = vm_area_alloc(mm);
 
+	/* VMA_STACK_FLAGS and VMA_STACK_INCOMPLETE_SETUP must not overlap. */
+	VM_WARN_ON_ONCE(vma_flags_test_any_mask(&flags, VMA_STACK_FLAGS));
+
+	vma = vm_area_alloc(mm);
 	if (!vma)
 		return -ENOMEM;
 
-	vma_set_anonymous(vma);
-
 	if (mmap_write_lock_killable(mm)) {
 		err = -EINTR;
 		goto err_free;
@@ -134,18 +136,20 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 	if (err)
 		goto err_ksm;
 
+	vma_flags_set_mask(&flags, VMA_STACK_FLAGS);
+	vma_set_anonymous(vma);
+
 	/*
 	 * Place the stack at the largest stack address the architecture
 	 * supports. Later, we'll move this to an appropriate place. We don't
 	 * use STACK_TOP because that can depend on attributes which aren't
 	 * configured yet.
 	 */
-	VM_WARN_ON_ONCE(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 	if (pgtable_supports_soft_dirty())
-		flags |= VM_SOFTDIRTY;
-	vm_flags_init(vma, flags);
+		vma_flags_set(&flags, VMA_SOFTDIRTY_BIT);
+	vma->flags = flags;
 	vma->vm_page_prot = vma_get_page_prot(vma);
 
 	err = insert_vm_struct(mm, vma);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 57c80924813d..64f38a83613e 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -245,8 +245,10 @@ enum {
 #define VM_STACK	INIT_VM_FLAG(STACK)
 #ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
+#define VMA_STACK_EARLY mk_vma_flags(VMA_STACK_EARLY_BIT)
 #else
 #define VM_STACK_EARLY	VM_NONE
+#define VMA_STACK_EARLY EMPTY_VMA_FLAGS
 #endif
 #ifdef CONFIG_ARCH_HAS_PKEYS
 #define VM_PKEY_SHIFT ((__force int)VMA_HIGH_ARCH_0_BIT)
@@ -315,6 +317,8 @@ enum {
 
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
+#define VMA_STACK_INCOMPLETE_SETUP append_vma_flags(		\
+	VMA_STACK_EARLY, VMA_RAND_READ_BIT, VMA_SEQ_READ_BIT)
 
 #define TASK_EXEC_BIT ((current->personality & READ_IMPLIES_EXEC) ? \
 		       VM_EXEC_BIT : VM_READ_BIT)

-- 
2.55.0


