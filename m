Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCDEFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5F26B0093; Tue, 28 Apr 2026 04:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986876B0095; Tue, 28 Apr 2026 04:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8751E6B0096; Tue, 28 Apr 2026 04:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 779F26B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2BF8316050B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:22 +0000 (UTC)
X-FDA: 84707264964.24.C761355
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3970840003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KhGQYW+o;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dF2JCDHRyvpz2fSA/d3/Si4g4v2SbytGBie1HIthSGA=;
	b=RfD5rZTYYv5fzsuBlxC/CRWk5YVBFeWNy4k/PSH7QHlmmJK7D2nCYg8UhFoafmNPolQEez
	xnlXAO43YL75K8wzLNDK3JgKAcGqgRI9EMBgsPD/MhrE3Y39REqrERaK3ASsVJo8a6yR67
	4PEtlR5CQgfvVqGMdIPbniQc6KlMbMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364360; a=rsa-sha256;
	cv=none;
	b=1+W0kApY6vwzSz1ZagsRl6OEm2TXcL3yfYAfXjLtdv7QykjaDai79n1MJi80d8xSACu8mF
	xARwy9fpfipBSRcqAHEzNjUlc7U+wYe2yUlaq3LtXI3D+bLk2uw0QkCiJyi9X6YHpnUNp6
	fhwk6duC1+eQZ/63LZScSSfOgWyhAsI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KhGQYW+o;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-358ed696623so4925768a91.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777364359; x=1777969159; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dF2JCDHRyvpz2fSA/d3/Si4g4v2SbytGBie1HIthSGA=;
        b=KhGQYW+of5/7gdlH1pAus9LqrYCK1e5vgjZXw7wtEKcmHnpV/O/U4k1/cL/kTtya/X
         XeN1a8P/JnkL6p4O8sEspLFwtsyAQSJhWnrJtoSK9t8oiaR4aH00zshn0t1wGMmr+kfb
         Cc7HY9hcsI/CK6mgnoghGdY6vm+5KNsxf4mVvw0iCqWWZCSdI8CW3fvBfioAjWz+x8RF
         MCZgHhY2M5RoPW+iDEQEiIqRD9YXzTNOMQdhlF32t4EfQtI2eGwQbF84aYRLPnB+rGHA
         pvGvcoxKOxr8c8ZN93ID5l+v3oYWrR/eLKNgV7nj3AFsGapFXFHBBQoSBLyffQzi1Tl+
         MAFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777364359; x=1777969159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dF2JCDHRyvpz2fSA/d3/Si4g4v2SbytGBie1HIthSGA=;
        b=VYNqu4lShRnbwP+Y81UeV3h8LpZoGkSxsk3H0BwAMU1RJ/OyXq+ZydG2G6oq0YsKA8
         1+r5aCuVos9FHXW/5G/Ro5/5LYKOWD8/f2he0e7jzGGS9z8e65CpL860HtjBfGZiNMJi
         x8AfCPrFEvqOUXM4Xz2dvXtW5iNx2Js4T4BOxhmanLQzUHVpYIzV9cmt3qUga2m7vzjZ
         m0qoPmkGrWCf0uEyXgYz0e54PrDAW3guSPV8q+O7p3Asm3InjfIJpEZDvOxo1s8Xxqu8
         Nez44ysiTc5oWbLxdU7Ab1xGPGjSemQDs5pjI1vdgPb1X70PRp+eeKzroWFSoNUgsY47
         SAbQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Uw+XHFrUPKVvEFKSPaBRfX4hvz3u5OElfLzMiOTT9+FAbnSZyQ5sbTr9nIQGvMPFom8/cV6v/Gg==@kvack.org
X-Gm-Message-State: AOJu0Yx+JHLldN4xdKt/aCiA5Q66e5CEXcGUdEnpVSCk3nDxbtsKewJ/
	slohy7mBB4FJ8CdI5TiQPLoA/c8B/+aJg7pfm8q4O2r7wBMVuAjWRRjMVkMO7CPVf7c=
X-Gm-Gg: AeBDiesxCh+PdaSKMhGJ0qg+VCeRuf9T+K/rnE7xfEKmFbmBro4tCtFt8thNpFIcuzF
	CvZPn00wJ6ILNbxpOHL8RfSaJgvSmBRAil+cxAbf5xSEJ6kROGsKd/6r0qvcrI9qHFWZpyRmlUH
	XHNWzx2b/UroFbHQsjwFrAZglFjeHrtJKtRA9vhYuI75Y+u45WC3Bf1MEO5ADWdExygrQa9oiKi
	5gp0fd6hflIxhs+HZf898y4O2kO7Ll8hRMidOgNKVMY+7zUKhKsr+/SDHIseAeRe6GAzVwPn02H
	l/sckwEwGBeYT3df16otMG5D/OcvdfigFKLf90R6w2F2EYxG2FLloeM18DVLxaAo5YMaegPd+TK
	TdRKp8C/4U4Amw2rBWmOQTG0/WtHVJHutuBciLFCDhFPvyzrwJUVPiQ8VzMvrmcjbET6zECB/Xe
	y5JyIyjQOnZ5r7NZj2WQx+pgGlI6TGXOEM4ni2Z4rAbJnEkTMWbYmJaW0=
X-Received: by 2002:a17:90b:1cc8:b0:362:e51c:fd9c with SMTP id 98e67ed59e1d1-3649200d617mr2345614a91.17.1777364358798;
        Tue, 28 Apr 2026 01:19:18 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3649003650esm2181356a91.8.2026.04.28.01.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:19:18 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v8 3/6] mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
Date: Tue, 28 Apr 2026 16:18:52 +0800
Message-Id: <20260428081855.1249045-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428081855.1249045-1-songmuchun@bytedance.com>
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3970840003
X-Stat-Signature: 6boogkeu165475hy5mjzubho8iz1mf17
X-Rspam-User: 
X-HE-Tag: 1777364360-682967
X-HE-Meta: U2FsdGVkX18iMAg9BHAF6r1Cy7LTAgS5ltr4GIiHCOF3BE8sidCBqWS6eH5PQD9Ot5VAHXT6opm2E7hM+5za38+03BQYbdgb0Fip4T3L/0f+8LpstX15VyCAZfEputTT3YnM1SpNadlLycPwSFt+og0n3GzKw/M/dcjVAXk1KUGuZLIEfPL5Mehfsd0FrU32jbNUnlOII3/hsyaqF26EKGHhnJxWkwEnhnQ4ytXexfbrfj/fb4I32x79IZI5h0SogTxTdsf6lFgs8CpxfRiUtYKJ6VXKMSY89c8IY4ttbNzRhEe7Z2Aked+19a3inIPQiKacIoSBtDuWPDAXlA967Uwtd8vH49WhbL6e/O8hFaJ81wtYKRlK6kQ99CmTzFpy9X+eghlKKrxDAXLr82ncYSjoI5fhrjBnY5YM1UIz/YeiWbhoL4t2LOgTqiJrfR9b4t+DOc4PLt10QEK5wdg/L8j8YUOOu+AjqnY1I+6Cs3XKYtoYM9DTnN8AOpE8E43yYeR4wJaRBovkERNKbCLksQjPo1Hs5a6ecI6LWqyZntW2k/3vs2itrMTJbKZ2iVHuGJx58URG9WOEfQQDJUxZQE+z/805wFImqL4z+VqwUZ1xMXETlymByccBXaJKnAkPly9oXS+ch0o8MpYo69OgeuNlDJ9ahVLFXMvSTuoC7fQBe/SGrSyNf+3dag13hAPfP6xs8oTr2tuJjT2DaQW5+YkwYFatxjFd+6cPhML1M14TXUmbxHqcfHNXXawoy00AdbMR0ReXzR4XntS5Kpo/8ICFViEwxievqFp6mKpg/ApewGrHbodftj4j3ky25wkI5jhxrqwEIl843Xvdqo4NSa3pi4mO7USSW7g0xQUnZIMGb3GJCw7EocWgX92q51fCnN7z7euAYVz79YBMyGBQ2zRWcfYcSuhSU+v0iHg2gEFGHbFpIjiP8lNZBo+mWXx8Bmy8Rxb8CwmRewC0Bn2
 uq/fTaPv
 uis70XcSNtEfZgzCM28m6knswLxiCkEQRfIKe3Hjf/FZe8J4TZOEWPZMsnujlxQNOz5Sw8AsPK6s0LYBM6YCkLjVAKcojaDYPKyVfb3QwDIkclKXIaVDDVOq/klScM0hJsLg/b79bLzpJqjg/Po+w9G/h5+29Y5UoNd5yWXodrXcCAvUodgHxJdTxQubsCkfqluIJ0wKu1Wt5a11V2Z/V44Vq0FZrIUzZm+efnCArcy6bnMiUaXxFqAIpTkRxYHWTwZT4/t3tDezxwu/e+Vk5Yl+B33Ux5CIBvW43Us4U+il/qFiA8EpHv7MgMtHCGewcK1MvxTwVjWOhZWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the memory hot-remove call chain -- arch_remove_memory(),
__remove_pages(), sparse_remove_section() and section_deactivate() --
does not carry the struct dev_pagemap pointer. This prevents the lower
levels from knowing whether the section was originally populated with
vmemmap optimizations (e.g., DAX with vmemmap optimization enabled).

Without this information, we cannot call vmemmap_can_optimize() to
determine if the vmemmap pages were optimized. As a result, the vmemmap
page accounting during teardown will mistakenly assume a non-optimized
allocation, leading to incorrect memmap statistics.

To lay the groundwork for fixing the vmemmap page accounting, we need
to pass the @pgmap pointer down to the deactivation location. Plumb the
@pgmap argument through the APIs of arch_remove_memory(), __remove_pages()
and sparse_remove_section(), mirroring the corresponding *_activate()
paths.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/mm/mmu.c            |  5 +++--
 arch/loongarch/mm/init.c       |  5 +++--
 arch/powerpc/mm/mem.c          |  5 +++--
 arch/riscv/mm/init.c           |  5 +++--
 arch/s390/mm/init.c            |  5 +++--
 arch/x86/mm/init_64.c          |  5 +++--
 include/linux/memory_hotplug.h |  8 +++++---
 mm/memory_hotplug.c            | 13 +++++++------
 mm/memremap.c                  |  4 ++--
 mm/sparse-vmemmap.c            | 12 ++++++------
 10 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..e5a42b7a0160 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2024,12 +2024,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 3f9ab54114c5..055ecd2c8fd9 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -119,7 +119,8 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -128,7 +129,7 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 }
 #endif
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 648d0c5602ec..4c1afab91996 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -158,12 +158,13 @@ int __ref arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index decd7df40fa4..b0092fb842a3 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1717,9 +1717,10 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, pgmap);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 1f72efc2a579..11a689423440 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -276,12 +276,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..77b889b71cf3 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1288,12 +1288,13 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 815e908c4135..7c9d66729c60 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -135,9 +135,10 @@ static inline bool movable_node_is_enabled(void)
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap);
+			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -307,7 +308,8 @@ extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap);
+				  struct vmem_altmap *altmap,
+				  struct dev_pagemap *pgmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e3352284f635..fbb9cae10a8a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -576,6 +576,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
+ * @pgmap: device page map or %NULL if not ZONE_DEVICE
  *
  * Generic helper function to remove section mappings and sysfs entries
  * for the section of the memory we are removing. Caller needs to make
@@ -583,7 +584,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap)
+		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -598,7 +599,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
 	}
 }
 
@@ -1426,7 +1427,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap);
+		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1469,7 +1470,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, params.altmap);
+			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1555,7 +1556,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap);
+			arch_remove_memory(start, size, params.altmap, NULL);
 			goto error;
 		}
 	}
@@ -2267,7 +2268,7 @@ static int try_remove_memory(u64 start, u64 size)
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, NULL, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
diff --git a/mm/memremap.c b/mm/memremap.c
index 053842d45cb1..81766d822400 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -97,10 +97,10 @@ static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL);
+			       PHYS_PFN(range_len(range)), NULL, pgmap);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap));
+				pgmap_altmap(pgmap), pgmap);
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index a7b11248b989..3340f6d30b01 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -665,7 +665,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -746,7 +746,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -784,7 +784,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -828,7 +828,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
+		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -889,13 +889,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap);
+	section_deactivate(pfn, nr_pages, altmap, pgmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
-- 
2.20.1


