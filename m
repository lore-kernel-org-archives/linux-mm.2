Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D0FC43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856226B00CF; Mon, 29 Jun 2026 08:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E706B00D1; Mon, 29 Jun 2026 08:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DB56B00D2; Mon, 29 Jun 2026 08:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3745E6B00CF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F9A8120651
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:06 +0000 (UTC)
X-FDA: 84932869812.05.C96DDB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1225E14000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPSzgbYB;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735905;
	b=lER1tX5mg/1RXCwiEAe8QqtFZNPvnzPzA8hgWRRzs1ZgSFMvx9VzMPlZZs/gmrP+Ui49kv
	RhNq1HAAGZHECmLcXanwNLdkHUbgxva9+UHbYedvlLfbfEoxjCvYqjK8Sl6ypww1u9mvC7
	9K/xZdupTZYJmJJR4m65kk3u8S5if2o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCNlejeASmhB4AgyuEzIBYYbjpZ4n/egy8owgCzIJlY=;
	b=eKlvY/LliaKsN53pVhSB9X0I/AuXyAk4Ellxt1ERWqI7vW574un8r9f3mi4W9dZduu+qm3
	gLRr3vlCxVnyq7fhror/jIwImikaaEQcoAX+gt/aRrpyWDHayZ91/t1uaznjaWq6ok1WOI
	TnfPsxW0m2Py8803PPYqfpoVmj+SXfQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPSzgbYB;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8947A60008;
	Mon, 29 Jun 2026 12:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701AB1F00A3A;
	Mon, 29 Jun 2026 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735904;
	bh=jCNlejeASmhB4AgyuEzIBYYbjpZ4n/egy8owgCzIJlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPSzgbYBaZMkgFXpVO4lcjIhSYifNVCkFnCoukwkUexEpxFU1zMgEeJ1WzF0iQe8G
	 nflqvEp2qQsUkNArN92n8VHhtGfhHn+6iUhiMxzzJJJ7SZXcRgEr1nCbY+/elRw+Ah
	 zSnB7Azkiovus8+WkUKAjckexf8zlkyqxvryRskDyfAIp1bnaSD5ki+zg2uUN1KNn+
	 7TTD7jzbKN7+khnHRVfJs1NOkm+rEq/0bN1OjRt/R8ER/L0u7tEvPT97eyxEJtymI1
	 nWpqxrYVQsa8IYABDoMNC/4V+mXkdTfDEZ3SxdJqtpi4OpAP/MPlU26nLVy9Japjwe
	 PNuQvpANXUgjw==
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
Subject: [PATCH 23/30] mm/vma: make vma_set_range() static, drop insert_vm_struct() decl
Date: Mon, 29 Jun 2026 13:23:34 +0100
Message-ID: <62efd70f9f39570724c9552cc7f2aeb5c322b2ff.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1225E14000B
X-Rspam-User: 
X-Stat-Signature: nto3ga8x1ynbyym5anp19dwktfnmax7o
X-HE-Tag: 1782735904-745288
X-HE-Meta: U2FsdGVkX1+AMDsFrGH1+FngECDFODVO/clPaF3xWACCyqRSAzKFY67McrZblTz8ND09AxHLMF35E6qpyZuBWM6nvIY3nnr3HvgtcmCu4aoKelWa14a1TMFG4XcScorUMLQnrh7ARbucaqO40QWTzbLE3fGuRq5afdZbsQ+HoZOvelETq6wE2GakYfPh0ww0C+QIUuixXmGxkg3kuM3glq/KOOdque6ycncvUeaOlZz74kIHzeW1nsFK5ndh44dJqeMFt4yDek35KqAaXOr31zgJbGboIJa9xVMFuuNutje/Ly9uR9KAaj2fAjmpgY+MxO1huTjdVQe3bR2L0oqZp/NIX6I+osXAx9ytZXiiaDh9BB4fodSE2XTyS6TbmJ9hSsJScrNIPoofK5H0jGGGWHd5FO60vPxYOZDkya8FJZZIwN6D8Mxils9J8WvhRpkIfNTW1BUCXYQVsw+XISFqS8jdkj0W0SIPxmickL1VP+5DDXMt1XRxU0CMkGeS0SWSg5gcdI8Ho/Oib51PhWgC0rL+aOek//LzSRUe8lSpOBGwraHNhhuv7pha8weoK4jmslpQHBEpk6evQfFLKpHExjsUbkUlcy1kR2vvCGy7KME/0CeoGVADdKNyz77dG6BCW7gp6C4NMpr5GD6g7YRudyYQQa7JHH/3VXl32SG2wQfFXtSWxbYhK8+1SDIraUWuoXfxCYlet1uBtbWAdauMMkuC9qu/0dTRR2uJ2UZqhSLOVNqiB9O6Tzr5/fI1i5dAHmFYiLBK3BueOc5N+ZkPDHEg5ZYZA8tw744lS036YhcB2UhpJRRP/srWpzygxdi0WCzcugx90Vx7HonT66U9EaihVixzqmYh6YukGfqLL+ZFhU4EoeNHjmCDivK2tfv7sWRMQyO43SbbV8LEu8FQiVBY+XSrBax57cTY10d0KWI6FqkXPKklP46UpCKm6pYDAilaoxD7k630yIVO/OC
 DnP+Rt4x
 zzjXFNiX7vlUOlENDNGxpDNBVBz5JfY+BHX7x9SfuudJdEICrtBuNSK9QiWik1BftCWbCQmomvVosK949o7akCo2zNnRgTiGPU5rfKaJghuyETUGSM2gaUkN1mjcYLs5zYa0ty1jYDyrAmKgIXmCorCnbf8K/uu7sNf7UfaHwaqlVXjpRiYcvWpH24BMyf7JCfDAuxFtTA6bhXT7vqWIm80YdkJAA0Ej50IxwbAelkP0bu8sDPPTn1euoRbJmfR8LVXxPuD/FXS2zLbmmxOmPa/poPe86SZb3E5+WlOK0b0CCHg4LxSfITznqj5XmBOhivYbXAr7JWLCWxeoCoHaJ/PPrhxgw800IEbBivBNXUrgCsyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With __install_special_mapping() moved to vma.c, vma_set_range() can be
made into a static function there and is now completely isolated from the
rest of mm.

While we're here, we can also remove the insert_vm_struct() declaration
from mm.h - the function is implemented in vma.c and already declared in
vma.h, and has no users outside of mm.

Also update the VMA userland tests to reflect this change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h         | 1 -
 mm/internal.h              | 9 ---------
 mm/vma.c                   | 8 ++++++++
 tools/testing/vma/shared.c | 9 ---------
 tools/testing/vma/shared.h | 5 -----
 5 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cf2d42747064..868b2334bff3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4103,7 +4103,6 @@ void anon_vma_interval_tree_verify(struct anon_vma_chain *avc);
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
 				 unsigned long addr, bool write);
diff --git a/mm/internal.h b/mm/internal.h
index 89e5b7efe256..e127dfea9c0f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1720,15 +1720,6 @@ extern bool mirrored_kernelcore;
 bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
-static __always_inline void vma_set_range(struct vm_area_struct *vma,
-					  unsigned long start, unsigned long end,
-					  pgoff_t pgoff)
-{
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-}
-
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index f4de706a2728..b16c5b20862f 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -70,6 +70,14 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+}
+
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
 static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
diff --git a/tools/testing/vma/shared.c b/tools/testing/vma/shared.c
index 2565a5aecb80..bea9ea6db02a 100644
--- a/tools/testing/vma/shared.c
+++ b/tools/testing/vma/shared.c
@@ -120,12 +120,3 @@ unsigned long rlimit(unsigned int limit)
 {
 	return (unsigned long)-1;
 }
-
-void vma_set_range(struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   pgoff_t pgoff)
-{
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-}
diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
index 8b9e3b11c3cb..ca4f1238f1c7 100644
--- a/tools/testing/vma/shared.h
+++ b/tools/testing/vma/shared.h
@@ -125,8 +125,3 @@ void __vma_set_dummy_anon_vma(struct vm_area_struct *vma,
 /* Provide a simple dummy VMA/anon_vma dummy setup for testing. */
 void vma_set_dummy_anon_vma(struct vm_area_struct *vma,
 			    struct anon_vma_chain *avc);
-
-/* Helper function to specify a VMA's range. */
-void vma_set_range(struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   pgoff_t pgoff);
-- 
2.54.0


