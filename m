Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC68606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Qx0q9nL8
Received: by kanga.kvack.org (Postfix)
	id B2DF46B05B5; Fri, 30 Oct 2026 10:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05B06B05B6; Fri, 30 Oct 2026 10:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDBC6B05B7; Fri, 30 Oct 2026 10:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 779186B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:09:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E138A83EC
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:09:05 +0000 (UTC)
X-FDA: 85379474250.26.2C592DB
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC829100006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:09:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Qx0q9nL8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793369343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LJMYWoYmIHNoc3jkSVD82Cusuww5fSrsmAjGXum89E=;
	b=XENirv45dDthHXj1fIxZBpkkmiHAXkh7p5O3XqnJAo7ZdiffUkFfIFvh5AfUTS5+sWFKX5
	at98Nax5XBQn7i+WHvS9sQy7+9v+JUx7ooH9Kmtke2CU88BvYj/mmfMcDILyhdykkLUVdW
	QZPTHcU77VDjwIiQ150faPxN6vjjT4I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Qx0q9nL8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793369343;
	b=PssWVFUPQMhcDBQwtXkQgVbW07Mx1+m4WJynQSmKl/wXTWNxkWy3xnDDkKrAfpJXljrK9j
	bBjyD4RDU3lGPkBFXYcz1npSNG0JmUjk/QE4H8Goj5Oj2QyFo09KB7NrbuLp9gXabkV2CY
	2V9ImLBcIalteaH2EhLDDk7EoGRl0Pg=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e987b4a710so10268845ad.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793369341; x=1793974141; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7LJMYWoYmIHNoc3jkSVD82Cusuww5fSrsmAjGXum89E=;
        b=Qx0q9nL8SOUSjSwZodTB4r7Y4g3cW7EZSrNCZEGoMTbXRy/1lrgGdSx/2cq4xpbaCl
         vG9ZhdbvQj26uUKfOSsdtfz2xULta8mGL2MYDYpIsnbVUgtDtpHnLGph0KL6E5BZ/CvB
         Kqb3np9/elJiDuwTSOA1YijKY0C8veKAEVi/ThzlTf/5iwj/MmVqu3R6LR74MblpSfVP
         Rat+/R32yiYuoJ9BpT8Zejnd/Ip96lVYfgHtdErAxhkdhjzJjjYf6+TdXSAwCwrtPxJq
         44rTakZOvpkWItd8GQHE1DpvLlH4qFSZWdhywIdY8o/N3xBjTO2SxsL8JRXJ3jsfnO5f
         R+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369341; x=1793974141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7LJMYWoYmIHNoc3jkSVD82Cusuww5fSrsmAjGXum89E=;
        b=uIEz/Brp2wKSImF7yGF/sOnyQhMPEC/JjQkq3O8y3ycyK11NNk3qOae2qx+sBhUFKE
         BRaFp64R4xzKe0SGO++9MofVQ34rSUgDr0pE9jG70TtWnDEFxIyYBWaFHMH0vV/Dk0ij
         hB2q8gYw7cjb/XHLLRBhAOINsJdY+uBMfowuLZWml09BOV3TM2XUwV9hv5Y0QG4NmN63
         6iHFwuDSNNodPhNozoHB6dw8nedE0M+HD3s6s9BSVRcLSFAUuQi1yG6oGCYa2snRMlxD
         ZOsu94GkHjABnJW2tfYCZE2+E3z4MBNAy/9WV8BFXMhhEBNXc9RRpy0sSf9wvp2YTyk5
         4RCQ==
X-Forwarded-Encrypted: i=1; AKwUvBzIbBfYNmAm0UEaxlMwEX5+WMTGf5vSgZD6/VehJuSf9YDnljzkZyz2qXV6NLNJNsfAyuR/eRW23w==@kvack.org
X-Gm-Message-State: AFq9FYK9vDbtznNQ29yttiKelhQpd4bVK7QUFMf54UIkHoGjieZLtEOd
	gx/lSr1lP/NRDD5/IN5OTUURSIMRcRc47kWbKg8hYpaJ9mmVsZaSvYNFWf778j3WsJM=
X-Gm-Gg: AYBFou22SI6Ryfcs6QL/LBnZ8VBRfBjRX9Eub2rsnZxfXtbIAXTI7FtfQlRlTK6gSQe
	yPM9yc+qnGN5wslJQbV/Fh0IepUUTHfhJn8H86uQDlOStF5bho8EwerX8nc8+y4jgkh4dJUX/B5
	sFq/7MoExuU9RdC34MoOk+Zl4/ngvPtGwScxlZt+Ns0KWTn6cRnDmTu7x7zhC2AqPq9vLTX4g9y
	LnPKrLzicUBvs1cNprUWJ6KyqOomuZVXagbsBvIERMxmYXsASAzYszqyZXh8V0MQxdpXTBTzvUI
	NpNn36aZwg7d1fOtiiL2PMAkTCRWW9cl/ddIhFjtT//bjDy6lqajt/VdkWgfjLnzYTdNr1Deimy
	D7IyPUGvPM98NpAS2C7JOLQpOSZe1OnXO861k08jmGK8wL6QTI7o1M3PI5K2nDXwSSFXjyd6Wsx
	cwuqnlRIQK0QtDdRXJjv726PZ+JwQujRtu1yrLF8iS1t+eG5rMXeqTFjvZYjFjr6zehgrcU82Ou
	Acp0O81vKDWAwTuKtGi3LfliVzAsISuHb+s9i5nHMXb2TU6xfqD/BNtiZBBh7vq3U8KSHY/LuIk
	Dw/miDMzqyE92YOv1Td2yqUxn/hG4Q4qr/3dJuTT6Plk0ovhfORU
X-Received: by 2002:a17:903:190:b0:2df:b004:df28 with SMTP id d9443c01a7336-2eb365055admr19567355ad.35.1793369341336;
        Fri, 30 Oct 2026 07:09:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3929b27bsm7601795ad.62.2026.10.30.07.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:09:00 -0700 (PDT)
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
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 4/4] mm/sparse-vmemmap: drop @pgmap from vmemmap population APIs
Date: Fri, 30 Oct 2026 22:07:20 +0800
Message-ID: <20261030140720.1256062-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261030140720.1256062-1-songmuchun@bytedance.com>
References: <20261030140720.1256062-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC829100006
X-Rspam-User: 
X-Stat-Signature: 36588nfayko1apzxyubtin5xi81whx3p
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793369342-11729
X-HE-Meta: U2FsdGVkX1/Ym3ixB+W8t+vgdfevKwUwTjmTFKjx59kzXTOI8Sllr+aYTnfWdOHC6EHQoxNj6N83l0VLjBwgIDdR71EerHXQDh+CJzz9R1dzeWS/3WRJMWLTQ0TNXeLj2upM4y1aeH3g1vXNDkSxsMSsoEmNxerhob/FWj/SNeCgVtGMIkDsUVK42ss4L+8nkQw10nZKfYculcr+u/xLj+OWHkFeAqAKIdjeuc6l9LBQ6KO/NW101gc4HRmaTiLVFpHIwUQoysTOZKUdbs872OhUImoMKZYt8EwMJPRLzg+ku515tUylK7x1X0mRBz91HGXpgUSBX+dhdWd90bGajZpZUomgyCIbmWf4vIN216iDPle+ux/5QY1VkNPIM9wkdxE87Cq2YMccoOfnM2CszJMEaq7WvrtXWq1G2ed7YIIMHoIR6A2jJdlaGkHNupUm1d0NkV0TH+WfitSwBojlTImWYzbFz/juflldXT9Q6x9uq2xK0ILkkjMcX+3/dY70n6RWruMXsvdXUB2p6FbTVw4iD0OrQWdILNUbCXUiqdtruFAKC+dLlWO13zk6ltom8NW+D/VwsX94wp5fUq+QlI3ouUDN8wNLx3NpjikOBdjpgld1Z4T7zR+ab5VJoJLQXzWRiaIB3XPcvpkcIvBryJcIzm6cbbOS6FFAfGSdShhn5ZII97n0B/tL31hstAdyQZoU6PAf7vDbav+q8jhQE4v9OaeDYnhYvd4cZgHIksExJAKbqdCun3QbihFqKqyOx5M8tzvBcbeEkAHD6mGiBR1GGWWAnM2KN0MYV0v+NcsAc0qxVkqdCGKOk+xYdOist0hcNaClHEetKKpE1CpABKRt3XqlbwpMe5czv5dB1wNcz83Ow8TXgyodWI2/bkiXvnIVQxUk3gFBhvqKquHbXy+SRP7trcXGU5jNrzLA6G3uP9Z6t+cUP67xiMOhgvSvtgt9PI7DCapnJwboKOg
 KjaGHoEw
 x1RpLU1TYYgGWz2wV5AMC/fn4qvCSV8X1tE7kWqNfqV75qErV7RtGON2IQTyV+yFAOPZvVNVZMUT1O4zrkn3qs0HNJ3ZyX5UWbI0qosC9uLL/y0awZfp6QTg/OYB7Iq9LRsUNmP2h8Cz2+JWF0WdS3IIuJ4dXhHleUcHAXu9rvVnBddjQy1p0Yu9O6jJDl5r2L7WS7cSsTTDRdQh+qtxoG16GHeG4dvEMuSVhopV6meDQHBBHiVooXDjeW2vynliHKtogUG+s9ZGM5gG0IT+bk5OvAhc9nvyvO/MXSL0ErPBNaT3dhDSJuj9RdJcVZ9+S3Davdz11c2g3KIGdNBGuxvKvmi82R2JW+RMouAIX1IA9HGSgr6mpHNn1Tg4JUhxUwj8hWcnqvuGdPqw=
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
index f801f7097f03..22d35e98d871 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -119,13 +119,12 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
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
index 6f6b04795bb2..8bb48c270c2f 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1734,10 +1734,9 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
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
index 4fb48fbe712d..b4b63f89d188 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5345,8 +5345,7 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 #endif
 
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c9cc42e54f05..1e5fbc154123 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -415,8 +415,7 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
 					 params->pgmap);
 		if (err) {
-			__remove_pages(start_pfn, pfn - start_pfn, altmap,
-				       params->pgmap);
+			__remove_pages(start_pfn, pfn - start_pfn, altmap);
 			break;
 		}
 		cond_resched();
@@ -564,7 +563,6 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
- * @pgmap: device page map or %NULL if not ZONE_DEVICE
  *
  * Generic helper function to remove section mappings and sysfs entries
  * for the section of the memory we are removing. Caller needs to make
@@ -572,7 +570,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		    struct vmem_altmap *altmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -587,7 +585,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap);
 	}
 }
 
@@ -1420,7 +1418,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 		memory_block_put(mem);
 
 		remove_memory_block_devices(cur_start, memblock_size);
-		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
+		arch_remove_memory(cur_start, memblock_size, altmap);
 		altmap_free(altmap);
 	}
 }
@@ -1460,7 +1458,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			altmap_free(params.altmap);
 			goto out;
 		}
@@ -1547,7 +1545,7 @@ static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap, NULL);
+			arch_remove_memory(start, size, params.altmap);
 			goto error;
 		}
 	}
@@ -2308,7 +2306,7 @@ static int try_remove_memory(u64 start, u64 size)
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
index 43559593107c..df71125a6ee2 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -461,8 +461,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -559,11 +558,9 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
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
 
@@ -571,7 +568,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -652,7 +649,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -690,7 +687,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -739,9 +736,9 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		return pfn_to_page(pfn);
 
 	section_set_compound_order_range(pfn, nr_pages, order);
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap, pgmap);
+		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -805,13 +802,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
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


