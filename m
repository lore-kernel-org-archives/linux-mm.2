Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5E1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B136B00D7; Mon, 29 Jun 2026 08:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B946B00D9; Mon, 29 Jun 2026 08:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4858F6B00DA; Mon, 29 Jun 2026 08:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1661C6B00D7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A114E1A06A0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:18 +0000 (UTC)
X-FDA: 84932870316.29.DF0D34C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E50DFA0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fy5hgPIF;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735917;
	b=2Q2Kq+Ki2GvOvZuOTThW20pWAGHQC4fLSHgoRDs7NsXcit8n++32Dhoe+fNtbuIqXs3Vdh
	aXoSvI5/vAaZwv439PzNxTJ1Fi0Xezl4dzHtGIZw5h2WfTnA4mgFbe+WOS0QtG+AsuXii6
	rN8Gv5Y+1aeRJiGTrLHDqYrT8CgyfmI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZLLn6w5tKaY1nW+KkITtgwyfLONnb8tW4SFWVp8Sgg=;
	b=LFVu7/7jjYnVLX6kCwB2MKKoRtbun/hn0ghzF3Godsj1iAbnu9ExsbgUf4F3zV72ooJr7P
	XdWT4WQqVUGBzJqkIkfEErNgUvwzmm/iRJEORmIIkMYywzC9LKS71bMcXE5/ASi5M9IlFL
	s9T6Eg4ZVvfAHRGfXc1gmkFVZP4vKTA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fy5hgPIF;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29A9E4094E;
	Mon, 29 Jun 2026 12:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE591F000E9;
	Mon, 29 Jun 2026 12:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735916;
	bh=wZLLn6w5tKaY1nW+KkITtgwyfLONnb8tW4SFWVp8Sgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy5hgPIFV0OpgIW/0nPU7jLTQ8rPiZ8dM8upySZALILoZhYgNzHuFDpmCfg6JWomN
	 G0HPTvmQAFebwcgjThqux4FlQ+/BO6XRgEJbIwamZ24hcP+1wgCRotnYnKflTBCJJR
	 bpGhjvShcYRZylRyaqINKKmzKch04WcHFUPyws35pHkGRTjBHPqVgAeat0g2pBE/j8
	 o1t2l+K+FKK1VISsw0FzfZNZrSQzaWBl/42hcRwpcZICvBxv/Xy4PrKx39z5FkfqVd
	 TvkRJba6GypFsA0LGOL+E2NStUyXgzGuaEDWg150uHCn9m0SJvxjVby4OswnV+cS8a
	 lxabVOtJQBhVA==
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
Subject: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Date: Mon, 29 Jun 2026 13:23:38 +0100
Message-ID: <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: er9bo9zbk3a3gkdp1xurn313ajhtakfb
X-Rspamd-Queue-Id: E50DFA0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782735916-891333
X-HE-Meta: U2FsdGVkX19n8TuXNo4lqrbsbCsgqSDbLI44AVtDOUhUiRH4si1lBcWXiD3Y3nmUEHZt/CXjc7kxCGwFJaN82Ictd8qXzcGvTzCzR6DQzHXaFMiBcbChiGM82sPlCva8xkQ4monQ+7ldZiNXIk6ZdgJlAfU87lBT4y1B2Djd8oQQ9GdNcowKq0wyZh9Yle16+lATZpLwt/y1daek5+SSNnF/x7mKhXjzBdPi7v9RDUOa9hSeJ7ZaOMeUg0Rju4u84owSjF5uTmasMPTliWqKvOwv14S9YMvWi3OgeTs1wu8RCqIIKJb5xAZsNjZWF6agxwh8lm3lkt5cIlLm7SsyrSN3B0kbUyYKRglhenQEmvTLp6MesqtDaspfnJa9RRpfYuE2g8di8QuKdWqKaDlioD3nxJyX8lusFxqhrruTCNrO47jzHTUggR9fztkb5q8v/f7twOSwUbbrjhc4escxItZZy96LbhsZmX12r8nibZ2LtIkFHY6ritU10WG2japfqPaSzZ/566DIHC+hbrBpV8rE6v2InAG2KgFErOwYy7hehTKf3NCatAR+hy8uTnbNSOSuMiPnELN/v3Ju7WZ1k9wQ5cyjkP2oKEPc6XcMys9GDTt2lsR6OhXuyQLgMpFfgBGZFaRCNBmbAkB2FusLGHLKf5G8aaSsYfoi0wlGsIvstAVh9evZeustmqJFHTzBGMzclck6QDbnoAVXRzZnU6d6ZHeq+zwZfTIjoEaDrM9VaCF7xOU0MpwO4Jpw/+d7Bkf84EHwbzBC5q2tV2L3PTK3A0kAjIc5ITAbpnA1g08ysE3oHgZ7VHsPsKHgEQhIxFJnqGoSlVhvJft8LgYi5zsUIFC8V5NIRwEhYDA0LYuW26msc/fe5fgD/3q+Jp+IXTL6Z7/m1M35xhyTag1TFlEVDoMlS1/qaUo94j5O9XuSUaaUmXVw1Yd51ao/PjOHtxTLEMO+DtjddpdutEA
 HWQmU5G3
 hJP2Qgw7LM2Zp7qbviA8j7vJcB2UhYCy6GPwAlHqzj/N02+0HuI47bzycUxha4fTBY+2cEC3hVHnHC6qEmY17hK7kvGzAd74awuUpESRN3vOw49DFxTOIcEdCuAE8ldVFazy5BfF157PJYDQR59cnkrA6jaW2+4fsjWqWfT4iUmowrKI3dxqFCUYEZk8MWP+raFHVHUbO9/FOR//W0LpSvyLpaau/fk+BjWO9P1EPP/6logamuraVreujr/iSlWYL4QdoT3bRT+jEJCuf47nPDaVEqQwNOhjmRg6N4iX/DG/FdvpxaXykcH2evsb7xoVOZ+7anvMb5oejwMU6PdpgE3f04Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only files which should be including vma.h are the implementation files
for the core VMA logic - vma.c, vma_init.c, and vma_exec.c.

This is in order to allow for userland testing of core VMA logic. In this
cases, vma_internal.h and vma.h are included, providing both the
dependencies upon which the core VMA logic requires and its declarations.

Userland testable VMA logic is achieved by having separate vma_internal.h
implementations for userland and kernel.

Callers other than the core VMA implementation should include internal.h
instead. This header does not need to include vma_internal.h as it only
contains the vma.h declarations, for which the includes already present
suffice.

Update code to reflect this, update comments to reflect the fact there are
3 VMA implementation files and document things more clearly.

While we're here, slightly improve the language of the comment describing
vma_exec.c.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmu_notifier.c | 2 +-
 mm/nommu.c        | 1 -
 mm/vma.c          | 4 ++++
 mm/vma.h          | 9 ++++++++-
 mm/vma_exec.c     | 8 ++++++--
 mm/vma_init.c     | 4 ++++
 mm/vma_internal.h | 4 ++--
 7 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 245b74f39f91..df69ba6e797f 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -19,7 +19,7 @@
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 
-#include "vma.h"
+#include "internal.h"
 
 /* global SRCU for all MMs */
 DEFINE_STATIC_SRCU(srcu);
diff --git a/mm/nommu.c b/mm/nommu.c
index ba1c923c0942..4fef6fbbd6e9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -41,7 +41,6 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include "internal.h"
-#include "vma.h"
 
 unsigned long highest_memmap_pfn;
 int heap_stack_gap = 0;
diff --git a/mm/vma.c b/mm/vma.c
index d727150e377a..5c3062e0e706 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -4,6 +4,10 @@
  * VMA-specific functions.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
diff --git a/mm/vma.h b/mm/vma.h
index 155eadda47aa..f4f885615a92 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -2,7 +2,14 @@
 /*
  * vma.h
  *
- * Core VMA manipulation API implemented in vma.c.
+ * Core VMA manipulation API implemented in vma.c, vma_init.c and vma_exec.c.
+ *
+ * Note that, in order for VMA logic to be userland testable, this header
+ * intentionally includes no dependencies.
+ *
+ * This is specifically scoped to mm-only. Users of this functionality (other
+ * than the core VMA implementation itself) should not include this header
+ * directly, but rather include internal.h.
  */
 #ifndef __MM_VMA_H
 #define __MM_VMA_H
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 0107a6e3918c..c0f7ba2cfb27 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -1,10 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 /*
- * Functions explicitly implemented for exec functionality which however are
- * explicitly VMA-only logic.
+ * Functions provided for exec functionality which however are
+ * specifically VMA-only logic.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
diff --git a/mm/vma_init.c b/mm/vma_init.c
index a459669a1654..715feee283f0 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -5,6 +5,10 @@
  * between CONFIG_MMU and non-CONFIG_MMU kernel configurations.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 2da6d224c1a8..4d300e7bbaf4 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -2,8 +2,8 @@
 /*
  * vma_internal.h
  *
- * Headers required by vma.c, which can be substituted accordingly when testing
- * VMA functionality.
+ * Headers required by vma.c, vma_init.c and vma_exec.c, which can be
+ * substituted accordingly when testing VMA functionality.
  */
 
 #ifndef __MM_VMA_INTERNAL_H
-- 
2.54.0


