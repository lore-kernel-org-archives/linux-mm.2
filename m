Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE8B606A326
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=CyyFnKgB
Received: by kanga.kvack.org (Postfix)
	id ADF536B05B3; Fri, 30 Oct 2026 10:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6966B05B4; Fri, 30 Oct 2026 10:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930596B05B5; Fri, 30 Oct 2026 10:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67CCD6B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:08:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1DCBA80FC
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:08:45 +0000 (UTC)
X-FDA: 85379473410.09.7150DB3
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id A8ABA180008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:08:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CyyFnKgB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793369324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwaJdDbl3ziEIlNq+4GJpu2/q8X3inKh6ZLd1kzHiJY=;
	b=x0EX7fo+h+LvbK4XA5gFbdLY4B/7wmRmbuYZ/yEny4y+FxlHWxu2uYf4qQU0errtCNTZgl
	XGLmw7d5PnlnJFTNbPwwpgjfspwNPZhYIUlnH/KMSDJ6CD4eZdyrqKxC4lRcVZggAfVhGl
	GQA+iWDnvc7sOIhi3/8dMOgePkRpBwk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CyyFnKgB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793369324;
	b=CLut3wT7+O6y6intnPFmZ6W8qcwQ7DhXhWQGAxmOGsiqHkWjUMN5n1uPEyHs5iCyizm6Qj
	lWyGNb7K+D5rH7ZqX054+Ni+hdJ+GDcbzyTT+yeagOyrp+kTtNn0sO7hyUGht3DUu5TV6j
	uV4/Xh2ktMyyBsxGoPoWahouaIb+9RU=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e9d7791b00so5432865ad.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793369322; x=1793974122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HwaJdDbl3ziEIlNq+4GJpu2/q8X3inKh6ZLd1kzHiJY=;
        b=CyyFnKgBCtAvLWr8vDYXKK4WlTkA8BoJbPOLh64JFhUaUyIcjBM+nDTPSMyaHWMnro
         ApPowOS6sniRowH11yLTAfkChIA+C/cURVIFJMa1D3SOzYRKBCt0qyGyMGtkMRmNns2w
         NTuA0u8xSmO/lY/g+ATZakWq4cPYubYkZcL+yPC7CeH4F/xj8aHUCwXFpwVExpy9oY4z
         sNTOoT9iWpgSk0/kS+8bQFUzoWIvcb3XxQakrsyOpfgZVqugWTJwSZj+BJ6XZZbnoWcD
         BJ0/6Uorii+ZIgRA2tr2RtuURQOhFnebXszG0flHLD2UxHm8iPvW4TDPEHATI6xtAq/7
         54uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369322; x=1793974122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HwaJdDbl3ziEIlNq+4GJpu2/q8X3inKh6ZLd1kzHiJY=;
        b=gXsV0bw5e5eRNgLRCYwoqJkl1KnNaDEDECg3O4whPT3PmK++sY8zlQ+3OGX16U5P8v
         c4S4cpYLCJEqQQCIZmTb3oJ1RAvuQvZnAFgDYgyBV+WRqJNQu46NqjMJ8xyIt5rSvF8y
         Zd/6/vlmvQYOmeLUWpRYCNj+WUDIMDBbGPaChRpnmeW2rpOOw4gk3V7H/BN2C2qpzdQ8
         QIP1FB9vGSVWQsLq4FvP+LW2SwSGCTOsljKL+ddaxOhbjozySIxbQS5yIu+N+fZxsbHk
         CABz963ievDKOl421Qihy+KhMOTOj86bZ+ajM4mFwY0LW5Co5wVx3142i5W6Y7Ul5FFc
         zMNg==
X-Forwarded-Encrypted: i=1; AKwUvBzuQ4we+KP4sHBb7JUIToBPGmKU5ymzOyGIFdbiZ6KO34vdS9OdQ/uOQmxA/awyYPkqt4/C3gTvag==@kvack.org
X-Gm-Message-State: AFq9FYILxkSV0hVsofx61jB9g77C3kSpNRXHoeo4eHlOcbwHjdJGyFS+
	WFKVe1cNlbMEUUPUahqZtjAuXCE8pNbZCJ/pTyo4bnjj0sntie/x0/uYAPl3cH7NvaY=
X-Gm-Gg: AYBFou0scNxTTRl/gNaq5/UOMblpKgDVl7MoSI+Z7SKeUG3Qrmz731+eGKB6syldXCd
	qUcnBxHj9OT73v5KfJIaJOYl06WaoQ/GR/V6ey8NpmQyyA5daUBbnSYxW7AjPJqfWhQzdb/ysEf
	yzvhGMFDuYghxwFeYmB1tHBszocmEt49tuUUW61mjK0ts92rvc4AdxriYyk3t+AjQ+31DZ3dm39
	NxfK6WaTKyo08hyCOlqmYskUJwnjyN01wHAZznB+RQ9POMge7TGhcM5qnknnERK3HtX9of3e758
	aE/vrk7XQI0JdiGWYjFxLz7hvHsl5uprPHPiwnVym9isNu0+IMzJn+B1LbRc821dQZ7TGOsAkVJ
	RIhzWxFZ2X5UPYzApDzLrq0sZLN3Fl8/GRyKxscO3G7uQluRx1Gzg2RLY51/tE7nYLDIhNigUAn
	EzREG7mrjoPoyT3PL6W+vk/TNwAAEJ3tA4uayVNjYjKuUUZ6MDe3xYOqCJnEZXYxdqqxFdNfo9v
	cvygYCPBv++R10KHe1WlZVUsd3zSvP9A+oV+zXXN0YE41JqfStlPHuA+4qix670F5mRhJgRYTzq
	3DDbRir06eOFrZwhiYQTR29QBnK3OU0nboCb/Nsxdd/bjbEL3IuU
X-Received: by 2002:a17:903:1a8b:b0:2e9:401f:f0f8 with SMTP id d9443c01a7336-2eb364e9f6amr24067465ad.53.1793369322301;
        Fri, 30 Oct 2026 07:08:42 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3929b27bsm7601795ad.62.2026.10.30.07.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:08:41 -0700 (PDT)
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
Subject: [PATCH 2/4] powerpc/mm: drop powerpc vmemmap_can_optimize()
Date: Fri, 30 Oct 2026 22:07:18 +0800
Message-ID: <20261030140720.1256062-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261030140720.1256062-1-songmuchun@bytedance.com>
References: <20261030140720.1256062-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8ABA180008
X-Stat-Signature: fa4oq1objsi1he1s6yg1c7s3f4s13rj8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793369323-232637
X-HE-Meta: U2FsdGVkX19N1KqkXlJSR8K4GFDMeFj4lkIFHfKNEvQr7OPWuEU3jEsNU3qcUcv3lrSXJ3xLbe4n/eVZyfIHUtZDLOxnZDkyk767xyhEvaVf987QBwKrN/0NWtnpwWMpQRXORO6MWsXLj343CYGBzqt1VSSQ/fjSbQzWSMctF0u/P/B7+xbfgmhZyyurEYI9/vQcU3ealwLiObl9PtvdQK1zxHctjSh8WGg0b4tUdeKyYFc//MBZoyFjniPp8p6rFjmIBGoVnoGhQzmon8WBaH+JoRqkl9G7e25O7lKH/tbH7eHLIBeC3Wk7BDiG8NwEBlwR7TEC4WAd0h7vrMZruNj+ctaLq38H5uMtqz9hCFed8OwzqLvHsZvDqsXgb9AesyvGwOp204ddFJO9e6qxaZgTmV/w7C3WMawWPPv2foCWAigtovIVOOmRo3CpuI4UvvjJJYbtUyKo8PWsqdBX52ZQLRYsmN3oGP7/mr57u/AsajnetdOinUIwIWw4IflFOo0onVrtC5tQ21uJmrtI+yCYK5n5CrENS8dihQFq85F7bD0YqW2XkO8YPcDyxWCReqGZTnUolLomuiSAjt199ND6EyFWMhd7YRfnPtoXWGb7sVWj1wDE1ATm/Z6cNtz/icW9i0enm6hw89f/suYRSwjAx0lPf6GuCK3GBUWvYTNg6EtKn4p8vqIWUsYLle0ln/HM8LSMsxsRCkgVSyyBsqqV2U8NycA7YSeT848OQInnfhLWIUBRDLRa8y94KBvFUrq5KAmvZxkF5Yb/Q0Cq1WTKT0SJ1wMcEjqe1AucL6/1h/IZ431oUdRcwPq5zSNjtpAfXyt10qJwXNg2xe4ZrQFuipk6AEbBOTha3NSTGr+9gK4nIzyDAo8A8KVpMpDcgVYWA+aqVGgNiEeiAAQVgB/H1CVco/lqitYaouTp+kUm14LgBSNu1XRrtR1MswxXjPd80MniXK8sFRkvWAh
 PPKiUK2v
 8wD+FGTxOAWMgEotD3OQC6kYXL64mN+EkxaDfl9ehX0UKd/2sFYdluYyA2K0gicFp72UPKD6H9hXukBWChR6J4Aho82h6vml5gKp7WJi7SlOxC5YXM7rqX5SiFDVJDCC93Xe4bDVKAYlGqS5PI5nOlR4KU9+dU8rJeXnXjX1ywDPzZUX9HmQJourwDjbNEYZaRYORFmSoeqJKmCukhs4Evv57RxDZdwWEDs56Em2q2mvrED+ewCqYiy+PFOWKMtxSQuQday3lUkAMMyUvjWEHgAPjbaH4PIApUMxYJvxUHTl/joAfsUNaddw0M/8mT7Wphgabow4AnLo+mIcVPgYAd2gput+Da6CdmudyQKpoLQrYAMPdmUZ8DiU+PLxyv3Yl0XQwinSLb4nek4JXxqmZ2y5AlQbTPGzm4FbZ3fecuHAdgEyG4djbxcFU/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PowerPC no longer needs an architecture-specific vmemmap_can_optimize()
override for DAX vmemmap optimization.

Whether the optimized mapping can be used is now decided in the
architecture-specific vmemmap_populate() path. When PowerPC has to fall
back, such as on Hash MMU, it can simply clear the section compound order
there and disable the optimization for that section.

Drop the radix-specific vmemmap_can_optimize() override and rely on the
generic checks instead.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  5 -----
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 10 ----------
 arch/powerpc/mm/init_64.c                  |  1 +
 3 files changed, 1 insertion(+), 15 deletions(-)

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
index 0e777d7dc332..509cc4190db7 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -282,6 +282,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		return radix__vmemmap_populate(start, end, node, altmap);
 #endif
 
+	section_set_compound_order(__pfn_to_section(page_to_pfn((struct page *)start)), 0);
 	return __vmemmap_populate(start, end, node, altmap);
 }
 
-- 
2.54.0


