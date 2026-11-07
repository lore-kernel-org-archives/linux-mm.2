Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1191D606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 04:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=RQVcY91H
Received: by kanga.kvack.org (Postfix)
	id EC6AE6B05B7; Fri,  6 Nov 2026 23:32:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77966B05B9; Fri,  6 Nov 2026 23:32:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D448B6B05B7; Fri,  6 Nov 2026 23:32:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94EA36B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:32:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FA621C2DB4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:42 +0000 (UTC)
X-FDA: 85407052164.04.7B6BF16
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 405A8160003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RQVcY91H;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794025960;
	b=qFe8SF7wMtYQqIf7mwFc/RQQVAniUQBHNv94+LKgj6LWkZp50LX5GqOkQoqx/bbuVMM7UD
	OAnGFaO9REgQNKgTloDuFGg65PpSK2GQHgiupmj43sBMRpzqIy0uXEcwOWyCbBjSZzVTHZ
	pBpCCeoRgnkmm/3C43GwJQ7fZR6o66k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794025960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Uk8SfBKjPwwPmEXtec6BXU6Fwk6+Fw2T2stfCAovGY=;
	b=vF42E/kRjmGKj75Qj6Y1Ziu1n5YcIPhcxeAgBS1nzJO3A/JnOGMCICMd6Er3ACVBrg9fUc
	VzejojwgA2+5mi8MJbQ/Q98wJYJknaIqP04Xe3oJWDqDc0/M67a26wnnofUp6jSAa1/Xsd
	BHRP98xRhgdez0KoiR/3XReWkkJ+nbs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RQVcY91H;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3acdcfa2bd3so1075086a91.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 20:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794025959; x=1794630759; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Uk8SfBKjPwwPmEXtec6BXU6Fwk6+Fw2T2stfCAovGY=;
        b=RQVcY91H21FyHHj7D6+4l8EHrDqdRbSUtd12MeGxPbiyAqP528ltua300b38EiyhcV
         4mntfpjGSspx1JAYfJXDAX3KlbOTymwGAVB4vI7n9TTecFgCIYZqROwpP+dlW6Cm3d8w
         jVevAoRYXF50zn/MPns4zAzPYDxMON+wQzJr2yJPXfEph9fC5PFnn/23BdaxPRXeV70e
         31CycrbKHwdB3stoj1decECZvF1fT6EzFHu/higBrsFBjeeZVOnPvdoTqWTFFvQXqMWL
         O5/juiRJr0GBdewjpsqQHT9mnCuFnZq2yQTPo6o+NTeJXAkaAuyJm5Q7XBAc5dx74WjR
         onog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794025959; x=1794630759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Uk8SfBKjPwwPmEXtec6BXU6Fwk6+Fw2T2stfCAovGY=;
        b=EhLQM0oVt8m0UT/8ZVzOhYd+l4XvDLNTEzBiKNgSKTX1VRUDrkiq/eOByqflTA5zdT
         MBcRrrllreKoXK5055+joLtoAkemfvCNkIIUNyMISp/9DeBzZBl4xqOW7D7yqXScXkwO
         CFS7PNXehCedwB8DkIwtUnAOyumel12ecMB/RQY5W3++EYXXMIH8GdxesWUmAQFpZ2ou
         G6QTM8sp3PbJTUGSYqt/TQMxZwXucfwpDgpUi99FFynzCyQp2JrB4SmKofBm3st4TGom
         Vm9s/dNUBK39aX7RmNCShvPRsY2TM7+va4LTwhzJOGAE+ZrflRygp2AtlVgEGNKHsxHY
         hLdw==
X-Forwarded-Encrypted: i=1; AL+hErGABDzZpUKXX609gdcKyxf+o2AtiBSQQLSMybVBoRzVh8/cgY5ampzHSHDqY35VbxHzEGASP580mw==@kvack.org
X-Gm-Message-State: APuU4Z+pjYMROP+RaovjV5fyvLXOa2mkp3CnEWnWm7zNX+60bMWoDrLc
	w1oSV7iVzy+VbXXrTID5EgVYavtdW2WiYTgjURpGbMYzssLvfCcQbqdoysjHJGNnnC0=
X-Gm-Gg: AYBFou3hnMiZzeHtBIdqSyMeNl8lGd0zqFOR8GbWxUYBo84iv1NIg+tiRH19TM8rvvC
	B8JOwXgDn1bmguaG5VS0pqT+87Yyue9HUjeru2E4QZhtpucB0b6rRtFGzgbOzU6QDYUf+MYFKqw
	5JrQ2JrlwQsuPRnQZKjVj2zEafMa9jxqO0zUb5IKYo/cm6GdOyk9iiByGAsafZgkXoXibqSffdZ
	ka1C6j5y9JDLC8ACfun+nBLFBdEr4ppWwlLnkYF5D7Mi0OROMFXwD+7kpOSOORgCKiC8Ywk1xiX
	p+Q+xW5DtgK0QVzvgZrpxitZtxO5+7DKVHRIvHRjFkF+2ZQQbPd4LlMIZ0j1lYrAzqwP1lD3QK5
	zcHIxR40VtkQV7W2DFxPueeXQw4hD6dvad86HDaclwxkK0yFeb1pREQQzRDnL/1j0ior7cNRILi
	xEoGVPiyog1YkZCnWS8Ww3CnTx/rwLR0HTie6glw/o2KHgZF6r/1MZKCyS9E5pa7NvBwBKLZeUo
	rUg7AnhmvIL3rqlHiPsvnJV3U8naGI5mwlZryuKDxAd1TDNReEWrHyfimDyDeiRWVH6ZaVA4R4Z
	b3OZJOmli86ifwOP6gvpTueFRubytNsZjgBIHQPK2+mCgIfxI7IpXukNeEk+
X-Received: by 2002:a17:90b:4a89:b0:3ac:9c37:9426 with SMTP id 98e67ed59e1d1-3b0db6cdd17mr4665173a91.31.1794025959015;
        Fri, 06 Nov 2026 20:32:39 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10584b66bsm1578451a91.14.2026.11.06.20.32.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 20:32:38 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 5/5] mm/sparse-vmemmap: drop @pgmap from vmemmap population APIs
Date: Sat,  7 Nov 2026 12:31:22 +0800
Message-ID: <20261107043122.25650-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107043122.25650-1-songmuchun@bytedance.com>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 405A8160003
X-Rspamd-Server: rspam12
X-Stat-Signature: yk13exiwetpqd7refqpkcx75uxgacxbk
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794025960-507389
X-HE-Meta: U2FsdGVkX18OqjNkXeY7pgLUzVamLufJG8VTbLVIqikzWsZB2Q5xUDowc4dihOOpT7pvpho3w+tbUeZGCA/aQYkhUfzAnh10cBy4YYJWeN4TpTAqIyAjMvPxJtTgY6sTGLzrGALcaknluBtoY5dKy5r1kh26gcpBw4r+gZNovTHWM3xjXLK9L1L7h3s0YX5Q1Ue+hFqlcVadvt+kzIMEADdLUnKPN086uG7EZhZrIwTTyBLA3V2nD9aQwumqIPnXVspyiVtgLsYnpXUwsmdI/2g6Xub2KiUjqtVMfF0o2sV3TRopG9Piyg3Sqq5kqrH50Tgdd9LnO95YR5m9+8WujcfzuBUTYjih6wblVFzXnMoJ03XasE/VZadfHcuC2f0O8zEmOQTQCzHH3HD8W8hxnOm/hQlGUCnUN1SiPUaBM9tioR5cUyS/+aQKvIW9A7X+wRfciLQnflQxPueRyGv1Yo8CrvJ3BGZ9jeavgiLNnboIjs85n22Bc7gjwdvzS2uVFioz0eovVLanrDWAJmQ3UKYqEe1i/SaBuoVHW2FywPDd2EP3iNhtkLw8eHMhWVxY6F0BIOSK4Ad8dIV88k1NLly5OfTpkfwl05IfUuTA3QXweBcfM5fHZ0Ln9wOyoflQ/vfrlZMShP0ZThE374vWVnSOlcDBkJTJ0BqtvUjja+NIlhbIX3ingF2LKk6/Wm1wXcyCGT4fYdtbXFcmRE9Gj2NQuStg1d11mejbSL3msAIpVmopeZUILi2Lun8u+mVW2XNT/1lVU9+0QBlaFaF4hKNuDK0PCxQ0l5HbTMOxFwpvJT2SuJKASwbWr1VlYUll0mju3sheQgxYJZvU8mxh1UPJlGfmvYrZfDm6kx8zM6TyPHlrkihWxvjeBMqKnvrFzPa4e/WfX5gqSI/1xHON1vXywd1uY7xYcYY/X3mir0ctRHXrBDRa+WdMKnMAaGq6jAWCepwBver8Ot4bK3+
 lUBD35yM
 PbOYYTx54ihl0HqLsNkJY6PIMKcKC3NVMQTt8DceLNOkJWRy3tGhTQ40N7qGGWXekXKoiVwUfroaH97wbQ7KpV9kDbxQdetSwle572SD4esIJLFbT8UqHXq1iYyn0Hc+l2SZj55QLbGRf7aiqoDWnVRFlK0k2yO5c2AMs5jaiSP3nUf8fsDLA+ewSYg5nFypNQEODXgNxAH4lbNQjlZbdMd/OUBhDh8kSlfl6ao8HUmKhTj5WRh9E09tePBJk6J6XkHfJ4zQnH2s1wbaav4yh0MJdDy5Kuid5BH62mWWawcHgzmGRKm9auTs7SSuAcHeaymyJ4li3z5iPGOXPqmCJU4fOCeBv4LDeU26IbVKV6Z0bMksPuAccNgQDr0QEjXyuMAuul5vFpciocl9+BF2czgBOmhJOH8bIrsSjkhrS4lyYHS0oJV/L7VWp96t+801G0TUZfPcdbuGJ0dR4l9piChtck39yCv+oYEKCneD8jIgzggz9H94e20B5dpFya8yXXXjh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The vmemmap population and memory hotplug paths no longer need @pgmap
to decide whether a mapping can be optimized. That state is now carried
in mem_section, and the architecture-specific population code can make
the remaining decisions internally.

Drop the @pgmap parameter from the vmemmap population helpers and the
related memory hotplug interfaces, and remove the remaining
dev_pagemap-specific coupling from those call chains.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/arm64/mm/mmu.c                        |  5 ++---
 arch/loongarch/mm/init.c                   |  5 ++---
 arch/powerpc/include/asm/book3s/64/radix.h |  1 -
 arch/powerpc/mm/mem.c                      |  5 ++---
 arch/riscv/mm/init.c                       |  5 ++---
 arch/s390/mm/init.c                        |  5 ++---
 arch/x86/mm/init_64.c                      |  5 ++---
 include/linux/memory_hotplug.h             |  8 +++-----
 include/linux/mm.h                         |  3 +--
 mm/memory_hotplug.c                        | 16 +++++++--------
 mm/memremap.c                              |  4 ++--
 mm/sparse-vmemmap.c                        | 23 ++++++++++------------
 mm/sparse.c                                |  6 ++----
 13 files changed, 37 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 19459a4a870a..a6b5774005b6 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2038,13 +2038,12 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index ea769e479241..c91afce46136 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -120,13 +120,12 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
 
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index df67209b0c5b..0c9195dd50c9 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -316,7 +316,6 @@ static inline int radix__has_transparent_pud_hugepage(void)
 #endif
 
 struct vmem_altmap;
-struct dev_pagemap;
 extern int __meminit radix__vmemmap_create_mapping(unsigned long start,
 					     unsigned long page_size,
 					     unsigned long phys);
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index b617b69452cd..2432ff888c03 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -158,13 +158,12 @@ int __ref arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e822fce0af4b..6f064875ce8d 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1749,10 +1749,9 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, pgmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index be7e009e7b59..91c0edccbb12 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -293,13 +293,12 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8b6d86fb5a42..2a635b7f78ea 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1273,13 +1273,12 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index b39605d30896..ec71debc0673 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -136,10 +136,9 @@ static inline bool movable_node_is_enabled(void)
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			       struct dev_pagemap *pgmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+			   struct vmem_altmap *altmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -320,8 +319,7 @@ extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap,
-				  struct dev_pagemap *pgmap);
+				  struct vmem_altmap *altmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 43eb19474d26..77b5d450fe45 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5335,8 +5335,7 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 #endif
 
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1bfd1f4daeb2..f04a248d8ada 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -416,8 +416,7 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
 					 params->pgmap);
 		if (err) {
-			__remove_pages(start_pfn, pfn - start_pfn, altmap,
-				       params->pgmap);
+			__remove_pages(start_pfn, pfn - start_pfn, altmap);
 			break;
 		}
 		cond_resched();
@@ -565,7 +564,6 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
- * @pgmap: device page map or %NULL if not ZONE_DEVICE
  *
  * Generic helper function to remove section mappings and sysfs entries
  * for the section of the memory we are removing. Caller needs to make
@@ -573,7 +571,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		    struct vmem_altmap *altmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -588,7 +586,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap);
 	}
 }
 
@@ -1421,7 +1419,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 		memory_block_put(mem);
 
 		remove_memory_block_devices(cur_start, memblock_size);
-		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
+		arch_remove_memory(cur_start, memblock_size, altmap);
 		altmap_free(altmap);
 	}
 }
@@ -1461,7 +1459,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			altmap_free(params.altmap);
 			goto out;
 		}
@@ -1548,7 +1546,7 @@ static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap, NULL);
+			arch_remove_memory(start, size, params.altmap);
 			goto error;
 		}
 	}
@@ -2309,7 +2307,7 @@ static int try_remove_memory(u64 start, u64 size)
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL, NULL);
+		arch_remove_memory(start, size, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
diff --git a/mm/memremap.c b/mm/memremap.c
index accba23aef28..683a77dd679d 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -97,10 +97,10 @@ static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL, pgmap);
+			       PHYS_PFN(range_len(range)), NULL);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap), pgmap);
+				pgmap_altmap(pgmap));
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f6a8b8e51b6c..9b80dd7326f7 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -479,8 +479,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -572,11 +571,9 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 }
 
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
-	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
-						      pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap);
 
 	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
@@ -584,7 +581,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -665,7 +662,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -703,7 +700,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -752,9 +749,9 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		return pfn_to_page(pfn);
 
 	section_set_compound_order_range(pfn, nr_pages, order);
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap, pgmap);
+		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -818,13 +815,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap, pgmap);
+	section_deactivate(pfn, nr_pages, altmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/mm/sparse.c b/mm/sparse.c
index 6acb628c8a73..0b9a6c23a227 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -204,8 +204,7 @@ void __init sparse_sections_init(void)
 }
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
@@ -236,8 +235,7 @@ static void __init sparse_metadata_init_nid(int nid,
 		if (section_nr >= end_section_nr)
 			break;
 
-		mem_map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid,
-						    NULL, NULL);
+		mem_map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid, NULL);
 		if (!mem_map)
 			panic("Failed to allocate memmap for section %lu\n",
 			      section_nr);
-- 
2.54.0


