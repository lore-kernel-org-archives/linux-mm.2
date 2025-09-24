Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B35CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39EE58E0012; Wed, 24 Sep 2025 11:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377168E001E; Wed, 24 Sep 2025 11:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19FA98E0012; Wed, 24 Sep 2025 11:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 041038E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7F1111AF9E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:29 +0000 (UTC)
X-FDA: 83924454978.21.F19EF32
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id B27C0140019
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eY23S5zl;
	spf=pass (imf26.hostedemail.com: domain of 3igfUaAgKCDccTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3igfUaAgKCDccTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yt3Q1XTnbMGvlZgCdZ/CgJSleEFjvQwQBSgYepLM/TE=;
	b=aaZG4sKUpyhQU9IEbC8N/pbKYe1jSkC9oFxjdxf8gjR5SzjpVH43VutkdXAGm8chI4uGEp
	+ANPb0VZWT62s4BThSAhYVYqx5ASOCwEli4aOEUVYWoUJIqAvPA+IrUQ6jMkFIYjNoQHBF
	iXo1Acc1Q5NPAIXhAoB3MBo/WbbV+QE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eY23S5zl;
	spf=pass (imf26.hostedemail.com: domain of 3igfUaAgKCDccTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3igfUaAgKCDccTVdfTgUZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726027; a=rsa-sha256;
	cv=none;
	b=y6V1wv7GWle/Bqa9n1mu0erTTQ/vWUOkcDRz64cYDovDgXjaKO0k096dc631DXNPSPyOHK
	G9U9xfEfvXhwMC2ABhro8R+rDZmisAzr/Ij8oRAYSpaawUrLsmf1QXCv6bYXh9110BaYiO
	tXY4x5KCUuA9HwYis3HsMfE872Z6UTk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46d8ef3526dso21392285e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726026; x=1759330826; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yt3Q1XTnbMGvlZgCdZ/CgJSleEFjvQwQBSgYepLM/TE=;
        b=eY23S5zlrolIlwbEQt3Zr3FLR3w2PjWNgshKRIH8MpL4xgM6nPQtNDHllnBFQ4Mu2m
         0bKbaQJ7egkBKdGnHYUgUbzPsN7UM1VrKRzYh8i+/iww6UpFpG4vMUWuUTfBWgw00xjZ
         pG/xReDGDXsyB9w/YR6Jgh0y25A0DVMVv9HjXDXVvmmA54YVOVlf/qXB3kK26+7piKVh
         Wm6GGuzi5WexGVHptRiUsccmn9/V5fs8Xyl+h3gWgL8iW3BvgYJePct/U76SkVde7O/0
         xvnUC/eBc3jmoQc2Ic9QjVSrgA2rxqgrMNr7ydjbF01EtC2sivKfEl60GjSmoZNAmC+M
         xfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726026; x=1759330826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yt3Q1XTnbMGvlZgCdZ/CgJSleEFjvQwQBSgYepLM/TE=;
        b=jGFJEEkKCUAyaVH539t4hFEW/lpaVDxfOolqmqx+XCWB5hwtnwOushw0nHXcmcfmA7
         p9Uw/6C9NeRNUaCntzL9ggoEU1jJpWEmGUeCRg/wtPk8LkQo2L1mzfig7swlk5iNEfZ2
         2vtzNYujLQIDoaial5BnHR5hL21Si3CqvlhCakoZmnMNuCYab8nBfZYcShXLKBpUk0r8
         V4eTnl6zTWrHfgq1o7evDvVSmb2hL4ZojDFai1SQbvX8RNPtKYmgwlKCP7NVKgWqH5xr
         zwoHXzyeGElmlh9ajT1q/TcVzbSFsiqEOnurAFsJ692COZd8EqW//gQEg7M27waaQ/8Y
         xIhg==
X-Forwarded-Encrypted: i=1; AJvYcCXOVbaUo+00BtOWA8Ql2RHVbUunkFnZg8FWn+RUxUg2d+04iHqI4SB3vpBcBiO5DeZ6/LdA+iUiUQ==@kvack.org
X-Gm-Message-State: AOJu0YyGdLIyrwCuz6J2tJzGuR7ozHEWvRor2WU2A4dsR7ZFVMUaN0/a
	3XfnUl6ShO8w6A1RR1d+wHQmcZVwLKbjX2FHAirpU9yRguPCYsfhFQPvTbVZ0+sSIZ4rFBRj/PT
	eU8sQSCVbdTISXg==
X-Google-Smtp-Source: AGHT+IEOgWk7seh/trUQUGpJ6ZsEL7UmOVpxpeIq06m/4rtBPuJiGJmuPe07oAhOUg5xOwd6Wn79YD2LQK3VBw==
X-Received: from wmbhe13.prod.google.com ([2002:a05:600c:540d:b0:46d:2f48:35f9])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6306:b0:46d:9d28:fb5e with SMTP id 5b1f17b1804b1-46e329ab29cmr2315835e9.5.1758726026374;
 Wed, 24 Sep 2025 08:00:26 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:53 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-18-2d861768041f@google.com>
Subject: [PATCH 18/21] mm/asi: support changing pageblock sensitivity
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B27C0140019
X-Stat-Signature: mm7h9bhd6yu75y8cnep7z99py7g34k5b
X-HE-Tag: 1758726027-149752
X-HE-Meta: U2FsdGVkX18Ura1opSQzC6bFyU2L4Qf2YNk2+adahGEnMI24NcEgZHZbVarXrPjGD4lHx8UCUvV6H4fGR07P3VRVUQ/sEutzJvewk4Abm9Pk0UHLxUB516Lr9dOy+ITvEhHKgYRgoV0cJL6HROOoIWnmzljQ+/iTexyFN6mnXHFaynQQTcD9LauUiuuXRIBwB86/BtQVF8toD8cY+9Q0vgmMK6K881FUTd0rb1goVd68dM7bBOIgWoWQPQ1n1sr4E7OFY8dhWSsO59flrRMK5ss9WIj7nYlArIvgh3K19Voeul5nC4MK+LDTb4Ohiw3M9DaJmXaYc8Wh4mnCkU5aaOeFM+4105pm1sn4Cfk7yL6JI4sy/dzgi/xOyCBH3LeZSwIP83Pf1cNnOA5ZZsz6O45IVuB19Z1Aq2FMoPxaRbJTV1lmOgda2pAdn8x8nRiiyIP764Tt5fjeRNn1u0bflK8NmTCqk4C3vzwGm6qX8t04j8uLken0OTI8i5s5kefu5V7koH1Y/egV7beiqBLUxJhB5z2lyQUahTf+LjFNQb14fJAfuEzlJgqw/vc6gpQRsH33Z2tXe6VMNy816SLbYnnzpcYtDAwzKO7XzvI8P810GWmx8Cv20HM7cMfpAzESl9/eygdZheWS/i/UJnGoXJE8dZBKLZodTozCew2DUdUayQ5nGeHroyH+W2heL+mMu3/KC32u4EX0kUjoLv/VRoU2y9uLQfHS9mkM6kxDjUNeCvlTQuF6M+jNmTpnatljGZxOr87X+5p8jNScM22eJGnUvC1bvU7aXXJ6pJw8R6Luf8FN47lZd5psDXkCtwJ6e0OA2tcFA6MHFC6amNPDXmqsx2TDOwwvv9Uhepv7ZCiUBSCGFSbvJERbLkr8HuxxkfMdkVkIMB5YXK+FjjszoYMjyuym/5Egh06GabUczp7OnQASUJzkPrlAttST6d7/FRSPwVCb/wlV6BWg1CI
 z/cUHP6+
 kmJt2RAxsJqi83my1F7KoIyrShHDGuphpUxbSbL2sg6tLcVX3VlkqDk3O42jFeSQgTWJjG3jx/F+TeVjPWS4lN0QxDiJN/HRalw/ayUpfqn6SiY4hlGii1lIiO+LFc5EukPWmtoksMEikZBhWMGhkhcQRiBbUj2fdLnQLYmE+KzVs05lYYUtLvWLPnviSJ4xJktE0BfNhqThggNLRSU6fmH2mjWmBHaqKS/1dunL+b5xwFXqjOs+shTmz6FedeqhseDsi0rybZAqRbAw5jcrvov9OyTckXyJb7j2LU1AzKwgAqdBu2lG5pRDSS+2cd7xvKIIfOct+RdCKFUsdI5SbNxylLdYzw5OA9eWIjNnkdXA6pnAIgcYQ0GoQx+5lQjevFApvOP8ifEfyTiwfaj3f+VAF6nSYfGCopRk5f2hCVbAlB6MyEx/BvTldEdFDF+O1W1hgEc0EwiSp259dvpCB8honhutlbVKwI6jtO5GsHRWTrXl7qfC1WHSPN9QSmZcoAkB/aX+kD4ClSVvKH2yyck+MeZNS+wgUu+Sw+00u3ceiZgW65ChBkPU36A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently all pages are sensitive and there's no way to change that.
This patch introduces one. Changing sensitivity has some requirements:

- It can only be done at pageblock granularity. This means that
  there's never a need to allocate pagetables to do it (since the
  restricted direct map is always pre-allocated down to pageblock
  granularity).

- Flipping pages from nonsensitive to sensitive (unmapping) requires a
  TLB shootdown, meaning IRQs must be enabled.

- Flipping from sensitive to nonsensitive requires zeroing pages, which
  seems like an undesirable thing to do with a spinlock held.

This makes allocations that need to change sensitivity _somewhat_
similar to those that need to fallback to a different migratetype. But,
the locking requirements mean that this can't just be squashed into the
existing "fallback" allocator logic, instead a new allocator path just
for this purpose is needed.

The new path is assumed to be much cheaper than the really heavyweight
stuff like compaction and reclaim. But at present it is treated as less
desirable than the mobility-related "fallback" and "stealing" logic.
This might turn out to need revision (in particular, maybe it's a
problem that __rmqueue_steal(), which causes fragmentation, happens
before __rmqueue_asi()), but that should be treated as a subsequent
optimisation project.

Now that !__GFP_SENSITIVE allocations are no longer doomed to fail, stop
hard-coding it at the top of the allocator.

Note that this does loads of unnecessary TLB flushes and IPIs. The
design goal here is that the transitions are rare enough that this
doesn't matter a huge amount, but it should still be addressed in later
patches.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/set_memory.h |  10 ++++
 arch/x86/mm/pat/set_memory.c      |  28 ++++++++++
 include/linux/set_memory.h        |   6 +++
 mm/page_alloc.c                   | 106 +++++++++++++++++++++++++++++++++-----
 4 files changed, 138 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 61f56cdaccb5af18e36790677b635b4ab6f5e24d..396580693e7d1317537148c0c219296e2b7c13fd 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -92,6 +92,16 @@ int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+int set_direct_map_sensitive(struct page *page, int num_pageblocks, bool sensitive);
+#else /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+static inline
+int set_direct_map_sensitive(struct page *page, int num_pageblocks, bool sensitive)
+{
+	return 0;
+}
+#endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
 extern int kernel_set_to_readonly;
 
 #endif /* _ASM_X86_SET_MEMORY_H */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 2a50844515e81913fed32d5b6d1ec19e8e249533..88fb65574d4fa0089fa31a9a06fe096c408991e6 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -4,6 +4,7 @@
  * Thanks to Ben LaHaise for precious feedback.
  */
 #include <linux/asi.h>
+#include <linux/align.h>
 #include <linux/highmem.h>
 #include <linux/memblock.h>
 #include <linux/sched.h>
@@ -2695,6 +2696,33 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return __set_pages_np(page, nr);
 }
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+/*
+ * Map/unmap a set of contiguous pageblocks into all ASI restricted address
+ * spaces. All pagetables are pre-allocated so this can be called anywhere.
+ * This should not be called on pages that may be mapped elsewhere.
+ */
+int set_direct_map_sensitive(struct page *page, int num_pageblocks, bool sensitive)
+{
+	if (WARN_ON_ONCE(!IS_ALIGNED(page_to_pfn(page), 1 << pageblock_order)))
+		return -EINVAL;
+
+	unsigned long tempaddr = (unsigned long)page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
+				.pgd = asi_nonsensitive_pgd,
+				.numpages = num_pageblocks << pageblock_order,
+				.flags = CPA_NO_CHECK_ALIAS,
+				.on_fault = CPA_FAULT_ERROR, };
+
+	if (sensitive)
+		cpa.mask_clr = __pgprot(_PAGE_PRESENT);
+	else
+		cpa.mask_set = __pgprot(_PAGE_PRESENT);
+
+	return __change_page_attr_set_clr(&cpa, 1);
+}
+#endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5ac8a35b27e249c6d8b9539f148635..db4225c046c47c114293af8b504886b103dc94ce 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -44,6 +44,12 @@ static inline bool kernel_page_present(struct page *page)
 {
 	return true;
 }
+
+static inline int set_direct_map_sensitive(struct page *page,
+					   int num_pageblocks, bool sensitive) {
+	return 0;
+}
+
 #else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 /*
  * Some architectures, e.g. ARM64 can disable direct map modifications at
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b0aeb97baa13af038fff0edae33affbbf49e825c..a8e3556643b0ff2fe1d35a678937270356006d34 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -44,6 +44,7 @@
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
+#include <linux/set_memory.h>
 #include <linux/sched/mm.h>
 #include <linux/page_owner.h>
 #include <linux/page_table_check.h>
@@ -585,6 +586,13 @@ static void set_pageblock_migratetype(struct page *page,
 				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
+static inline void set_pageblock_sensitive(struct page *page, bool sensitive)
+{
+	__set_pfnblock_flags_mask(page, page_to_pfn(page),
+				  sensitive ? 0 : PAGEBLOCK_NONSENSITIVE_MASK,
+				  PAGEBLOCK_NONSENSITIVE_MASK);
+}
+
 void __meminit init_pageblock_migratetype(struct page *page,
 					  enum migratetype migratetype,
 					  bool isolate)
@@ -3264,6 +3272,85 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 #endif
 }
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+static inline struct page *__rmqueue_asi(struct zone *zone, unsigned int request_order,
+				unsigned int alloc_flags, freetype_t freetype)
+{
+	freetype_t freetype_other = migrate_to_freetype(
+		free_to_migratetype(freetype), !freetype_sensitive(freetype));
+	unsigned long flags;
+	struct page *page;
+	int alloc_order;
+	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
+	int nr_pageblocks;
+
+	if (!asi_enabled_static())
+		return NULL;
+
+	/*
+	 * Might need a TLB shootdown. Even if IRQs are on this isn't
+	 * safe if the caller holds a lock (in case the other CPUs need that
+	 * lock to handle the shootdown IPI).
+	 */
+	if (alloc_flags & ALLOC_NOBLOCK)
+		return NULL;
+	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled));
+
+	/*
+	 * Need to [un]map a whole pageblock (otherwise it might require
+	 * allocating pagetables). First allocate it.
+	 */
+	alloc_order = max(request_order, pageblock_order);
+	nr_pageblocks = 1 << (alloc_order - pageblock_order);
+	spin_lock_irqsave(&zone->lock, flags);
+	page = __rmqueue(zone, alloc_order, freetype_other, alloc_flags, &rmqm);
+	spin_unlock_irqrestore(&zone->lock, flags);
+	if (!page)
+		return NULL;
+
+	if (!freetype_sensitive(freetype)) {
+		/*
+		 * These pages were formerly sensitive so we need to clear them
+		 * out before exposing them to CPU attacks. Doing this with the
+		 * zone lock held would have been undesirable.
+		 */
+		kernel_init_pages(page, 1 << alloc_order);
+	}
+
+	/*
+	 * Now that IRQs are on it's safe to do a TLB shootdown, so change
+	 * mapping and update pageblock flags.
+	 */
+	set_direct_map_sensitive(page, nr_pageblocks, freetype_sensitive(freetype));
+	for (int i = 0; i < nr_pageblocks; i++) {
+		struct page *block_page = page + (pageblock_nr_pages * i);
+
+		set_pageblock_sensitive(block_page, freetype_sensitive(freetype));
+	}
+
+	if (request_order >= alloc_order)
+		return page;
+
+	/* Free any remaining pages in the block. */
+	spin_lock_irqsave(&zone->lock, flags);
+	for (unsigned int i = request_order; i < alloc_order; i++) {
+		struct page *page_to_free = page + (1 << i);
+
+		__free_one_page(page_to_free, page_to_pfn(page_to_free), zone,
+			i, freetype, FPI_SKIP_REPORT_NOTIFY);
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	return page;
+}
+#else /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+static inline struct page *__rmqueue_asi(struct zone *zone, unsigned int request_order,
+				 unsigned int alloc_flags, freetype_t freetype)
+{
+	return NULL;
+}
+#endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
@@ -3297,13 +3384,15 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
 				page = __rmqueue_smallest(zone, order, ft_high);
-
-			if (!page) {
-				spin_unlock_irqrestore(&zone->lock, flags);
-				return NULL;
-			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+
+		/* Try changing sensitivity, now we've released the zone lock */
+		if (!page)
+			page = __rmqueue_asi(zone, order, alloc_flags, freetype);
+		if (!page)
+			return NULL;
+
 	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -5285,13 +5374,6 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
-	/*
-	 * Temporary hack: Allocation of nonsensitive pages is not possible yet,
-	 * allocate everything sensitive. The restricted address space is never
-	 * actually entered yet so this is fine.
-	 */
-	gfp |= __GFP_SENSITIVE;
-
 	/*
 	 * There are several places where we assume that the order value is sane
 	 * so bail out early if the request is out of bound.

-- 
2.50.1


