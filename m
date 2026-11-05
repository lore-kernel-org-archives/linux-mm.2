Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA39D606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=O3hrPczN
Received: by kanga.kvack.org (Postfix)
	id EDC366B05B5; Thu,  5 Nov 2026 01:12:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB49C6B05B6; Thu,  5 Nov 2026 01:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB676B05B7; Thu,  5 Nov 2026 01:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA2F26B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:12:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F3D24096A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:50 +0000 (UTC)
X-FDA: 85400046900.23.C439F50
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id AFE32160006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=O3hrPczN;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793859168;
	b=NQpzsVqzC3OoDdbugLlcTtglmNSHHKCTmdsgeQ/rZDJBxSLR3A3ISnXSu3qN8fdo0W5CWb
	8zGLGhHI7UGjORFv6jkCc/5/UUCQRDK0+W59zySAJH+EZvrG/nvBulbat0qsX9HiLSbiVq
	sUbdfflrchEUWHheINyGXqqj4sOhBEk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=O3hrPczN;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793859168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Fm/jPwX8N/x42opaK4NB2WSpEb6W0SXK/qEq7+UeX8=;
	b=O1ZR3+AKWmmgsiDWSudYmzypCVsgJryI0gdgmM06uf0zrGuSD2ayuS9InoaOz3vbcER5CU
	OQaQji2hdVL59+KX3/OA1t8QAVyywp5OMR8pwjT7+hpg+fh3bor2ImobKKjdVSzQ0UHJ6A
	dGe4I4W9iBu/Lk3YlMhcT/ORjKiIM9k=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so1027726a91.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 22:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793859166; x=1794463966; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Fm/jPwX8N/x42opaK4NB2WSpEb6W0SXK/qEq7+UeX8=;
        b=O3hrPczN/9j9Vr79m6+ZUEmvQEXP5k912ksFvLRbklC31JghVT6mOMTHxswEGyNxaz
         0Wi449x0PgatTxMGpqfszw7x6slVg6fnos8qrJSEcHTh7Z/I1Jzz9o4Hb5YjIkSF7kH8
         wWe6GKUmDnEvt8ITmuijMJdIYM6rl3EhznrE2SC0kyI2YIesir2DUtcn3kmEkUdMu31P
         FC0QZSqGh2bzJfah8fPH/ZsDERFf4Wro7TLUuH4YoKg3Jue7HNOGacR5jJZ2x1+bq1SI
         +L16YvVCaqGdudiWGVYT9xyNXSOBZJc73hDF7GRWPySFBaLHnzk33XEqeeuva7pmlJEM
         ZkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793859166; x=1794463966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Fm/jPwX8N/x42opaK4NB2WSpEb6W0SXK/qEq7+UeX8=;
        b=Oc8c72V6g4t2OLUSrPCljEwYrDC2lm9gO+1KY0N2WTUDSB+s7E73ivtZrRhT0DrYgz
         TIeBlrtA5OcZ5Wyq8Jdt6Pjqu39vHLk8dpeubvhZCBpcQq1xeIlDu3uhSZ7/BPK+GywW
         hxKzCrWRcx7mpmh4xSx4b1sSRg01YplQ1DMF3H9yhNRCLWocb9rquIib96tWrlM0y8Q1
         87by45hAZdr5QLAPlX7K637ApX9XHQehkm7E6I4fMP8cJ8zTAuwFF8e4vzlY1UiU5AUn
         xKZIHakiD9Ozqu1xnyXpiZghj8o5nREbbvC0b5ksu/Jb9yEmqnvPusu8Cx1Ge1ZX1aIG
         KfHQ==
X-Forwarded-Encrypted: i=1; AKwUvBxUK/mJv1h/mbFPc22BcN2odU0vlEjkGfdhkiKUzgSrd7hrqrPn7AJn0G03Xc2zJMhpYyz8COmuDg==@kvack.org
X-Gm-Message-State: APuU4Z+/gsncWs2vkxgODxWXWi2SULcwBHMEQLebfJzazG+1KhE3e9vD
	NZ96QYQv7JqPNbbASyPEAayBp1pv3eAx/EYs4n7r17kHrzTGnyePOZ+1Dn9DQ6cv5Ws=
X-Gm-Gg: AYBFou1kVkR3Zw04U7PcLuXpVgiCsAWl59bl6b+TMBNQgV5roS6BpZu1I/fw1FKW9Al
	gldbb16s0r6Gvb65FY9/nWMYz//n07UhdDmHwJJ/Pd5S21MyjWsfG3+ZZmGK3FjJdId5MeQNq6s
	IBI+SXXEwkbX+jdEuLwaJ8em221yTdSWO1E2gWfOVh0OEXZ8b+f2tz5rFJvoxm7U7ooM6rRsRta
	8UlXOM9QdCvI5G9YGfKzqT7cr3wqU71MhFeI455AIMG9Xj4XrcuDkABl+2PjZE4uHGgTTQrBABx
	I2ElLgQ02JTm7T74Vh/Ms3fSHmoYFiQ4Khb1y9nzp1vm9/DE8jHvQl1k/nxIl5J3o+VgimsVLRZ
	1BWJHYHH4RMPkDqFtb6hBaSF0tbgzvIL2+lojqNO+b7+sjVb83MepLufkr0+HjkuvjGHOkQeFZ+
	PBHx/aD1QTzQLVoiRivR0jOHLpHRC0QBdX0hMo6hBtZ8OoTEmbtm4WTbLe/CEFmr2LXO5Ie9hYu
	vjuhS5QAAZcg6a9veqvyskoqMObGimPCMJgqhQlhsoxo6wyJFDbctooc5bzaMwd+yWrmN8rTud/
	raZTHw6VTc0/t9J3KIuu2ck6CIHMXBa7w8aI9Q3GAW3oiU0v2Zj5xKENceEIDBH/3w==
X-Received: by 2002:a17:90b:17cd:b0:3ac:b7b9:6471 with SMTP id 98e67ed59e1d1-3ae8987a7bfmr15528967a91.65.1793859166073;
        Wed, 04 Nov 2026 22:12:46 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323a1fdsm2107528a91.5.2026.11.04.22.12.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 22:12:45 -0800 (PST)
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
Subject: [PATCH v2 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
Date: Thu,  5 Nov 2026 14:12:14 +0800
Message-ID: <20261105061217.13302-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105061217.13302-1-songmuchun@bytedance.com>
References: <20261105061217.13302-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AFE32160006
X-Stat-Signature: uertenhuehzniaxk35e1impcfebomr1z
X-Rspam-User: 
X-HE-Tag: 1793859167-242355
X-HE-Meta: U2FsdGVkX1/7ksbUXMG/7txk8o95E9a5k9VrEO2yTUBShbcGMdu1+VW0yK1bQULJVoj7rl+SBmk1HzKugwsOJh5wuYDdE0U1JBQ9PY4Foj1l56Wq5vwISUO9AP3iH03xJU4cjKfB8ttYRxb42QCKUUzGzqX82eqIio673ORtc6zTtyaaG9vy8y47fZd7m4nsLEqVxveZ2xxyHAB6SmQ0JPezEBYKKOBwbvWOZ5+lRexWJ//4cUqu1gOPoJXOPDco3PFSdT0Y5M6QHbDJ+EusaYyiVZtmTeaRKI1bMc39mdUzdvYoeLntjbgLyN9IChJX8YV88ZOrsuqDglvndYtrVvX6TWrOBvdZuhLNnARROIXTlUkNwa/6kF3mHar2lt2hzIzUzbSB9d2jQeCyGEyife1WpHmUSFZpYcipxM2KMuB4EIZNF1cBWRgjKY50Sfw7ggGGsE7Ex65K3cUzrrpCgDpTbBs1ce1e2ZVDaLwH8oDolQ9RsHLwgpOYk/Mf/PcQbmlBXebY7jNQRMNdnxLhjV3x8jzyPhLPjNuGyqpkelRakqSgcWI6V+pyQnvO8joC15GqeJj4W6847syMoBGjLSd2TFbBU5zV6LJCd+PzPYKUVvSSLGwSU0DIvOLwxBzPqirD7h6Zg/KDSPJ6XMMUjFSK57N8EjMXn9vL2MkLNu/1C634rxnXEGJGyox/F3B3oOt1kLzym2IJRDcYUVm8gG3OVQNb++0r/zrB0VckPUBrEX//kg9bs9t1pR4RDI07C4qnUCkA3rg5HYdEiYt5PFbPsYGwuEYGsB43PLKa+PTxr21BmBCyNTd8pVbqM1eCCN/pbJvKZTcX4sQEO1V1gWZdK0djDywZfuPRaA4Hpo9U722xlh9rwmlP3Pi/1KjKQPymGL2uP0FfBDmRS/JTUYb6HicqXOZ6+FE1WMofHVui9qdP+aNONYzAc9QGSpoO89xkDPixkux3ouudtCh
 T4DhRTa2
 T1YHK8sjBgsbVMs01fDBs5tsvWno70NWx/7rntLWw/mnkFhUfIW12Y+vR+b078OAhtk/m7eqkov7bYlKFONnBHULjMdzALHDndUXMoDpT+J9mQRc+9lZWTaHIErJXT5tpxZRJazqa8pTZP3Yqav/vtsr4MVIOsXU++sKulE2YsCuvuHiFHW+wfq/wn9C11lsKMmr4Mhv0Gp7QxRb0aBsKL1hOKRfY8ZD66kupw06benQZDNPcQtt1I20SHoAGsr89cil8ZpWFMTjMEbvwVjJOEL5aQc73tHOoPdsqHCL8tkyzT+OfeTfqY/tbT5u5k3Y22qhsPLfb56qjLn5HHGwN8aqlaWomvvdiZHa4FPVssTLSP7Z1b1uFWmupghMvOcNAZNuhelfVUCCWcOt1ItMEvQ0MXQ1a23C/IvHTdpdNedI5WM35UFY7tWEHcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Whether the optimized mapping can be used is now decided in the
architecture-specific vmemmap_populate() path. When PowerPC has to fall
back, such as on Hash MMU, it can disable optimization for the populated
vmemmap range there.

Add section_vmemmap_optimization_disable() to centralize this fallback,
use it in the Hash MMU path, and drop the radix-specific
vmemmap_can_optimize() override.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Add section_vmemmap_optimization_disable() for architecture fallbacks
- Use the helper for the PowerPC Hash MMU path
- Include vmemmap-optimization.h directly (reported by Sashiko)
---
 arch/powerpc/include/asm/book3s/64/radix.h |  5 ----
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 10 -------
 arch/powerpc/mm/init_64.c                  |  2 ++
 include/linux/vmemmap-optimization.h       | 31 ++++++++++++++++++++++
 mm/sparse.h                                |  5 ----
 5 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index 8452a2714cb1..df67209b0c5b 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -351,10 +351,5 @@ int radix__create_section_mapping(unsigned long start, unsigned long end,
 				  int nid, pgprot_t prot);
 int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #endif /* CONFIG_MEMORY_HOTPLUG */
-
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-#define vmemmap_can_optimize vmemmap_can_optimize
-bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-#endif
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 2924604fbb38..63f369d296b4 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -978,16 +978,6 @@ int __meminit radix__vmemmap_create_mapping(unsigned long start,
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	if (radix_enabled())
-		return __vmemmap_can_optimize(altmap, pgmap);
-
-	return false;
-}
-#endif
-
 int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 				unsigned long addr, unsigned long next)
 {
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 0e777d7dc332..4d6928f717cf 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
+#include <linux/vmemmap-optimization.h>
 #include <linux/swap.h>
 #include <linux/stddef.h>
 #include <linux/vmalloc.h>
@@ -282,6 +283,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		return radix__vmemmap_populate(start, end, node, altmap);
 #endif
 
+	section_vmemmap_optimization_disable(start, end);
 	return __vmemmap_populate(start, end, node, altmap);
 }
 
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index 858311a71b0c..5c09da4df4d8 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -57,6 +57,27 @@ static inline void section_set_compound_order_range(unsigned long pfn,
 		section_set_compound_order(__nr_to_section(section_nr + i), order);
 }
 
+static inline bool section_vmemmap_optimizable(const struct mem_section *section)
+{
+	return vmemmap_optimizable_order(section_compound_order(section));
+}
+
+static inline void section_vmemmap_optimization_disable(unsigned long start,
+		unsigned long end)
+{
+	unsigned long pfn = page_to_pfn((struct page *)start);
+	unsigned long nr_pages = (end - start) / sizeof(struct page);
+	struct mem_section *section = __pfn_to_section(pfn);
+
+	if (nr_pages < PAGES_PER_SECTION) {
+		VM_WARN_ON_ONCE(section_vmemmap_optimizable(section));
+		return;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+	section_set_compound_order(section, 0);
+}
+
 static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 {
 	return section_compound_order(__pfn_to_section(pfn));
@@ -79,6 +100,16 @@ static inline void section_set_compound_order_range(unsigned long pfn,
 {
 }
 
+static inline bool section_vmemmap_optimizable(const struct mem_section *section)
+{
+	return false;
+}
+
+static inline void section_vmemmap_optimization_disable(unsigned long start,
+		unsigned long end)
+{
+}
+
 static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 {
 	return 0;
diff --git a/mm/sparse.h b/mm/sparse.h
index fdbc4cacf91d..9b81a549d928 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -46,11 +46,6 @@ static inline size_t mem_section_usage_size(void)
 	return struct_size_t(struct mem_section_usage, pageblock_flags,
 			     BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS));
 }
-
-static inline bool section_vmemmap_optimizable(const struct mem_section *ms)
-{
-	return vmemmap_optimizable_order(section_compound_order(ms));
-}
 #else
 static inline void sparse_init(void) {}
 static inline void sparse_sections_init(void) {}
-- 
2.54.0


