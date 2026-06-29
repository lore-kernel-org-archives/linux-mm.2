Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F04C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87E96B011F; Mon, 29 Jun 2026 15:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC26A6B0118; Mon, 29 Jun 2026 15:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CAC6B011D; Mon, 29 Jun 2026 15:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76FD36B0117
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:26:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F753A0283
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:26:25 +0000 (UTC)
X-FDA: 84933931530.28.3B2B5AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EFCE1A000A;
	Mon, 29 Jun 2026 19:26:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOPttWfe;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782761183;
	b=tFEZF6JSVwWtmEkC9KBlKYD65ZFP7SQLgCDQqLHMO6CK/6IUzp/06gJFKl7mvI0XDSiyrR
	dTkbRhQogV1bcKRXpYgXJFNscfeST7iBIBDl95KaO+aXEO6KvloAQEfF+BbQAhNOOazAmG
	brRMeuB7nJ1GTwDvYBjEYS3Vfjmp1aM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782761183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wnm2Xg8fzgzgq2t9tP+R94oZiE2QRSqcJqSUSdbb+xI=;
	b=aUTFy27r2pVw8NT31hhBRXWr+nPLWkzfO+toW2iri5xMBo8E6pnbVh9DNL/nGTzy+ORRPy
	R+05DIjz8ZsqFH8nAjmZptR//Fjcx5EEqfwD1JhPMe99GrhC9uHcbYr7U8c93H/oXFOcSe
	VA9KCuhD482Qu0wGJ2uuKpXSoZDx7Do=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOPttWfe;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8623360129;
	Mon, 29 Jun 2026 19:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1DD1F00A3A;
	Mon, 29 Jun 2026 19:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782761182;
	bh=Wnm2Xg8fzgzgq2t9tP+R94oZiE2QRSqcJqSUSdbb+xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOPttWfeqx2WAAk+O86bRHV1xe9XjSiO7vWMcbguW/QG8cwhr9Ho+WujRZfoXIkNB
	 GAafXcLTt0A7107oO1/wfsRqbvh2NXnLmJEY5U2oNVlhqSlYA3t7vnfmg9ypcMiIQu
	 8h9CwqzwF/QmgcsSy6FddnicElSxEL4LUhf+meGHiuuHtZIY/zI5z4sASrd3sx6zbv
	 h+vKpCS3OgfNT1Vzh95SLJ33rPs0Xs2s5lFkRLuYrK0Dv+UhZIFDZTErNLJ48+783p
	 GrekfoEk+r6DJVzhZY0W/8o+WObqmyaivps6ZsvmcWguDnXNLCk/ULQ2n7338Yb/Eb
	 NW0mBvRR/aD3g==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Lucas Stach <l.stach@pengutronix.de>,
	Inki Dae <inki.dae@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sandy Huang <hjc@rock-chips.com>,
	=?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
	Andy Yan <andy.yan@rock-chips.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
	Helge Deller <deller@gmx.de>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Kees Cook <kees@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	etnaviv@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-rockchip@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	xen-devel@lists.xenproject.org,
	linux-fbdev@vger.kernel.org,
	linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sound@vger.kernel.org
Subject: [PATCH 09/13] mm/vma: update create_init_stack_vma() to use vma_flags_t
Date: Mon, 29 Jun 2026 20:25:32 +0100
Message-ID: <34689784ee6856f100c02ad4eabeaa4db643713a.1782760670.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782760670.git.ljs@kernel.org>
References: <cover.1782760670.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EFCE1A000A
X-Rspam-User: 
X-Stat-Signature: p93gerucondd6f94gcykztjixupoukjq
X-HE-Tag: 1782761182-767231
X-HE-Meta: U2FsdGVkX1+OlnDERLgm8RoAU1kPMtmwmmVuNT8kPlSSlamaDWyEOC/fN+XvcoRN0ew9wMyD0uykKZUHCXQLP8UY7FTc914L4xpzcj3Fug9ByXLXVSrgkQFtnVXtX/KV12dUhzFP9B5wnCqctphGDJx5Mw+xXgh5kL9Zb1gxG6ZMkRTt/IlkQLCMqkVdmioIPWjHWcsO7JR6ZoLfO8qDxOxJ8ZtsgOxXl7dY8yeV6fYLFSAAMVkl27eZ8yBpng+LYlLkw3+PUPiEBAtaonhx6odGJNipF2Dr0tMo2K1vOO+gSwaV78Q6GC1NDPNoQ+9F63j6AdwRVrR5Mrl1mgbql5NXGyyc/nnZp0JlLqzqUhMPDWYZAFWv3nktSL/hUdabitxRmsetK5nakUMqzmxfdFrUJaVyUWCHzrrX3AJqfxN0pxgCD9hSfHGzQGj5rxiDwMcq2qV+3aeHIYfRfPrHKxUztOppHThujX4lrp6inefc8TDi9Pi5GvayLrgGCj6AlYIMC1a3aCaHJLvn6mVy3cuQaN+H5R6CD6b4zDuw5luehpaMDL7bzeChxZ+vtMhvzC37XJpxBIg96wg1bxi0SL1EIo7C0rO2yosxhCqQ/cP/PfhTbkKtFGIN5gXNsuekWhCHOiUtWcxLCo0MukyqWmnUNJ+58r6p4oHaTrvk+fFU2lyfqBzSTZkG4DMNXRpo64C3Q8gRswBmY5Rf9jtnvlNUU8BeCSRb+NHvr6LATE2Pq9zJGdv1huaDS3jfUlk78kMzzwaWOkwjqiws5iccglmhXOPdblav1hbwk1SR9R1iBwY2g5+2aovdqufFIKfw2xYSA3BnJdOKVJtqzYOoUq8jGTDtvjQnbQ+9RXfICJzRggc9K/da0sFuNCzr0YPJRY/B1POjdAU2rVbNGPmke6AGOFCmgEeJmpY/LeYhMX23B4nrk5w1eBJZ99PjPRijfBqLCIg5Dr/OoR2bt5E
 xG0jRVYj
 nzdoWsztZivyHpxfU2PNPV4GemsbggNdNJs6NJ6m1Vn/ZTJT2Y/7AVKOOSEaf08LOYEWLHxTo9JXuSgevmual6GRVK9ZR/ynkU4WUxRY9nXCglfTVgeE+taNsxkoFzfLs0aI7BD6xdu7CG1B9Zm0hjJHnXllEseFT2JvH/CVCryDFYjsZ7+RboUpHjT2gBcjTUXV2LOfrqfqz+fchCLoEGYuU/xsf4dgvjS0/f0Z1bbfP3du9m9Apy8fhDyE0h8FyePAMDM6QOtXWDIG7mfqtB5c4CQ==
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

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h |  4 ++++
 mm/vma_exec.c      | 18 +++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b55790c75038..6e57d41677de 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -440,8 +440,10 @@ enum {
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
@@ -532,6 +534,8 @@ enum {
 
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
+#define VMA_STACK_INCOMPLETE_SETUP append_vma_flags(		\
+	VMA_STACK_EARLY, VMA_RAND_READ_BIT, VMA_SEQ_READ_BIT)
 
 #define TASK_EXEC_BIT ((current->personality & READ_IMPLIES_EXEC) ? \
 		       VMA_EXEC_BIT : VMA_READ_BIT)
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index b01c4964f2c9..48c783e73cf3 100644
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
-- 
2.54.0


