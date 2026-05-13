Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96651CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A356B0100; Wed, 13 May 2026 09:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061316B0101; Wed, 13 May 2026 09:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92966B0102; Wed, 13 May 2026 09:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5A5A6B0100
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9ECE040125
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:45 +0000 (UTC)
X-FDA: 84762458970.07.7CC6726
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6B42B1C0004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lDuxgEnD;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFdfq+cF3LQdgAm48Y9XRloCk1IGuh3dGA8j2DIRoK4=;
	b=NsEsavLGQUBD+tL5jXPPjYrS+mt0Z07qDqtat7Qd+cSljiW0eOyvUo0JINcZ6ddbmONi3s
	Nq0Tzog/VJU/YXXfS3/r+evrCsPheAZeJ5vqiOamNS4QRZAp7WmnxZWBhPptzVlgyAsXMX
	Mpb/CmfiNTW22dA8wkRHG4MPJjIjE5w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lDuxgEnD;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678503; a=rsa-sha256;
	cv=none;
	b=UXn1DG74Xj2jK4WDmraRqNW0Jw80zUy+EPLEUkkHvT/oVSTnPSASmRX/KBmFaufFp01aYg
	TDj348R/bvNfa8rqdXSh9YwTk1vIOKGj1d88BqNxHLYSs/AKyI4yYWOTVDxwkxtdHyfCbR
	bK7scU1qL0s7+MmjjRWGYdg2v10P1Fs=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-367d88b9940so3258355a91.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678502; x=1779283302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFdfq+cF3LQdgAm48Y9XRloCk1IGuh3dGA8j2DIRoK4=;
        b=lDuxgEnDE12XAoxc7p1XxlT6jB1tM9T83Wu3G3mUxXm10Z1Bla6ZTNdGSVrOHKjYEo
         2ShgzXfzcxdNP8SjEvajdQwuaPAHSbQS+xksOAqW8cmdIjZwdtUWCsSjeqoD3FumbtSP
         o5tEXaLCdL7PGSfu3T/sqIvCj4+omLXHaJQ42HEaV7zwKd0aC7VI2sTmdaxaCzNqugzA
         9lOk7fKn/RKai1QyWCvauZ4FVWVC1ooeiFW4pKaJLPPUCkTEiXDCmImCyxpDRnpqH4qm
         TSGDPEIvPpApcMrhRsIOeKTaJ0yN6/l7/us04S132/el00fwGqH7nK1OaPqMkdHj3H7y
         0wFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678502; x=1779283302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oFdfq+cF3LQdgAm48Y9XRloCk1IGuh3dGA8j2DIRoK4=;
        b=quAzP4CK0jf7LcuUuLvZzCDLk8TAiojRMBXtVpt1ifkMslv/aAqQh/gl1CR2asqtPe
         QTzxYzw+y2OfZ5O2BAWukrfYrJzBhPdxZzpqUS9ii0yb7SZyDCV/bwmiAiUgeL+bTUGA
         axtxx56IVe/MrYHbHMsBvSwoXk8veLSe6ugjXCZYN3BhOlmhWr5ji1hbbg3TgOLVqVja
         jjJDD0XGNavoOyv/slmV/nxuixFGgtJA+O0KkpSFlImAbKILRTsdn8+4Mdu4nGBdjyEn
         I0pCgoU5cmFabfrx0+1tYtXpnCcILU+JDjGHt0jBYN0VcDSL9jkuEDZ0CC4+hvet86xN
         uPIw==
X-Forwarded-Encrypted: i=1; AFNElJ/sGnE6eJaRkq95RxJ72t3MDqnaMiz1aZq7ImMBslacfhaa/Odira63CRQ7BhaUsMFAvfBbkuinHw==@kvack.org
X-Gm-Message-State: AOJu0Yz/PC7r8ScduibacTjjnEnfKF6Ixo+BUttWhcF7xxu82j5tgrCu
	75dXwmBpu/KLTc10c/DNYiyYwAZrG6lwuCDvXvXlduS5MJcUjSghoIFbJAeKHaCOKxg=
X-Gm-Gg: Acq92OGDCwtXL+8VL+pTvEcGejzBWHCni6VzSb+HBuiaCY5KUX5kft4XnBELzsO4atG
	FV6G7RhfqxjGib7KVF3/vu34wrJ8699+VZOS8eqUsSUy7iS/80wu2JtIwLGjZmrEmhU/hzfX+B+
	izudn7UfFf7kQgL3XHLY4m2h/RNXoaUZV6RDG54eN2UugJ6HFQUait2y/5GpbUGRDDHRGSYcilI
	j7y8f85N827ZuhsslMVbqyLsk9POUQo498f2wlPy4O9QNlhxM/hodAUAe/N3RhKmwLNeCXgqgiz
	GvdSRZSgtmVfgRf7XdrQko7KB1ry8JUywM0+yNBwdKKsC2kuzrI13ab5S4dT7aZHDGr5OAgsazV
	J9AVHoUwOoULkxiznkUyWY+NJwOdKXvZbi3LcrsdLVQPPaDAFgOX7VU2NGEiwwXARgmZynQj2XP
	7zHjthatIShug4TmwrJcnvv/4bNeQcgiGkS5by332xPZ6OWayWozGqFGjrtyM3B7xt8R+KN0g=
X-Received: by 2002:a17:90a:d647:b0:35f:c729:de9f with SMTP id 98e67ed59e1d1-368f40ac9dbmr4195481a91.27.1778678501698;
        Wed, 13 May 2026 06:21:41 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:41 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 54/69] mm/sparse-vmemmap: Drop @pgmap from vmemmap population APIs
Date: Wed, 13 May 2026 21:20:19 +0800
Message-ID: <20260513132044.41690-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r7jywif7qi4kscdcmgasg8ykqteq4s3n
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B42B1C0004
X-Rspam-User: 
X-HE-Tag: 1778678503-977278
X-HE-Meta: U2FsdGVkX19EePTPLj12LHxycBjfmzVKT+GoDFLzirQf557V5nthlGxeA12PTv1tsF0S5yljGQdPs0/tChUKr74vZ5BRTAN36jDaQf5lpAwOFTX+Gb8erAY2+vBUhzKcz34U8gQQZIqTltdQ/9a7TEDjlCu9U5qxomBFqK4vsWGkp+ND1TnR9JZqy7pPB/qxs8VVDvUDNyczzWuT3YxrKd08tyZCxHz7wFGRlulGhmMXiPpnZs2oZ0ochNg7+XNr/+DUlyqjuK7bm6zWT3/zqDe7xN/FG67ic5jHEWxEioW6SIGa/DG4a8jVdweVPJJYi+dvw7eewX3Uwfwpy+FXkRqG6F2A1OiuMhRj9D+3DCczfyQJbA2EmvqpwOBYigXizmooz/laLPc2wD7KRBq+aqU/tIP3C9jvxrEp5djOb5T9FL4VDimlpXcNdwVdOFNHblgT9fT6XVs9+pJqfmY/MnRUxfNVNSZw/gAlA3UKxk1ai3+w0pS3/jqcJ8ODe+HkM8RWhYYVE/U44crKq+EGz26ITAt0RT8KhYHRXQ0we8uphtUrcg/MjCj0Y8SetfkYAMjqDmumnmYxPfEEDbCiquaEGvRw9JROEiV1grvQ87JBKUD/bXm5XSiuKKtni8ndbAPbldrooIwOo39NJM+2Pm4Avgdw2XpRRXwTi8P3lihhUdyMJOQ+sq8ciRPUcgePKit5lJF/teRF4BksHTcIpDmh4dvEgiBTpR0kpGPkeL+kJWIwhw+YmlHIvdpaXD61/uRh/NU3cN5UsOQNPzF5f7Mn/m3zLuKScsDDCRIK7vS97I1iSNnPaUyIb90J5q0yrHoe4XuiWd0Ac8boCGAlHO9RIemJDVNzkuDhu5G8Xkqvij3HM2fo2+tBAgLyTZK5D7teTLM2wSnWOgkyIlqvonhMBnSFjqUtj/cu+9gQo9ikAYjDnnr3QXTAwBLafof2O7DZHJ1EkyiYACeItvE
 wNgObqBC
 0eqOFRRMQ7aounUz58QIAidel7qEG8smLObgeCkB7SrL+QhqLPXD62g6Oz6Ta7aRXDGkgPtQU6zPBKLpdBDnSaBAGyDxSrAVJWoDPJkKGmUl5ApcMA0Tr+7Yk3RvYNi8l/TaO1QdwHukehqWX+jvQaTYY2egeGESsJtOTWul1Eg2kIrfb9mx+P/P3SozNVQUOj56KIA6kBC4BcvMX7/9mkOX+Kc79F58I5upmZ4o5VY2s1WO9B4IdSvvpXr4UAMKrMKQCnOLhvfM4qJZjeczv/AEi/B4p8ZJss3azIF8OqlFiGO6y1c+6vgIDAM2tdR0BclUK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 mm/memory_hotplug.c                        | 13 ++++++------
 mm/memremap.c                              |  4 ++--
 mm/sparse-vmemmap.c                        | 23 ++++++++++------------
 mm/sparse.c                                |  6 ++----
 13 files changed, 36 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e5a42b7a0160..dd85e093ffdb 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2024,13 +2024,12 @@ int arch_add_memory(int nid, u64 start, u64 size,
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
index 055ecd2c8fd9..3f9ab54114c5 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -119,8 +119,7 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -129,7 +128,7 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
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
index 4c1afab91996..648d0c5602ec 100644
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
index 885f1db4e9bf..fa8d2f6f554b 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1742,10 +1742,9 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
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
index 11a689423440..1f72efc2a579 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -276,13 +276,12 @@ int arch_add_memory(int nid, u64 start, u64 size,
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
index 77b889b71cf3..df2261fa4f98 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1288,13 +1288,12 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
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
index 7c9d66729c60..815e908c4135 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -135,10 +135,9 @@ static inline bool movable_node_is_enabled(void)
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
@@ -308,8 +307,7 @@ extern int sparse_add_section(int nid, unsigned long pfn,
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
index 5f45de90972d..87e98bdb0417 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4846,8 +4846,7 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 #endif
 
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c9c69f827efa..5c60533677a1 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -577,7 +577,6 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
- * @pgmap: device page map or %NULL if not ZONE_DEVICE
  *
  * Generic helper function to remove section mappings and sysfs entries
  * for the section of the memory we are removing. Caller needs to make
@@ -585,7 +584,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		    struct vmem_altmap *altmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -600,7 +599,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap);
 	}
 }
 
@@ -1429,7 +1428,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
+		arch_remove_memory(cur_start, memblock_size, altmap);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1472,7 +1471,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1558,7 +1557,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap, NULL);
+			arch_remove_memory(start, size, params.altmap);
 			goto error;
 		}
 	}
@@ -2270,7 +2269,7 @@ static int try_remove_memory(u64 start, u64 size)
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL, NULL);
+		arch_remove_memory(start, size, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
diff --git a/mm/memremap.c b/mm/memremap.c
index 81766d822400..053842d45cb1 100644
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
index 549be01d90f8..a807210fe9e1 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -379,8 +379,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -474,11 +473,9 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
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
 
@@ -486,7 +483,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -567,7 +564,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -605,7 +602,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -656,9 +653,9 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		return pfn_to_page(pfn);
 
 	section_set_order_range(pfn, nr_pages, order);
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap, pgmap);
+		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -720,13 +717,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
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
index f314b9babc4a..bdf23709a1c7 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -224,8 +224,7 @@ size_t mem_section_usage_size(void)
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
@@ -283,8 +282,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		if (pnum >= pnum_end)
 			break;
 
-		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-						nid, NULL, NULL);
+		map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
-- 
2.54.0


