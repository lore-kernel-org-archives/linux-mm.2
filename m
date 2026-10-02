Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB76CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C356C6B0093; Fri,  2 Oct 2026 05:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6206B0095; Fri,  2 Oct 2026 05:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F996B0096; Fri,  2 Oct 2026 05:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74FBD6B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD615406A2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:16 +0000 (UTC)
X-FDA: 85277114832.12.59A12A0
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf22.hostedemail.com (Postfix) with ESMTP id 165F1C0003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o5klu0Pk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACN8gkcsm61w/Jlh0ZvQ88AVu95ak6D5T7q+jQbcfkQ=;
	b=jE55MFiPN/Jb0SLIv+l/n7QpVjWCVZwAnglygNk/A4QckgQcAvtgrfrTSwsHp/Hpk2+vDP
	/lThi8JKKisDeNXXQaN70wqvA1nv6lquNUrdeNGrZ+9lDZt73yreri3gtABrT3ZiN+SBnC
	XyYKNskda6SsmjADF6AS+cuTpBXJTTY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o5klu0Pk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932215;
	b=Pxq9eEbg8UEmb0J4/ZfsY8tvT/O+X61Q3nNjhmIlKPu4GUXxEqDphg8FnHH+ZwekCSbduL
	1fyAqCepX9mvXuaJjNvxzdB1a0+ektRDxeBvWdxUF/0u+mOK2HNCT86sQ6SvrNJ4szcxUu
	W/fkI0m2Pbdc4Vnaf7SNrJqkmqnB3BY=
Received: by mail-pj2-f40.google.com with SMTP id d9443c01a7336-2e494adf48dso5937205ad.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932214; x=1791537014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ACN8gkcsm61w/Jlh0ZvQ88AVu95ak6D5T7q+jQbcfkQ=;
        b=o5klu0Pkjg0blQ89/J8LTOTkoL7brz2or3HgFQ2p6LwIfdvz3SfUlQ+Fa4EO86nwtt
         oqYY2q103lS6nB/vj5NZ1hGgnbhnnKxBDuJFF3WieziP9y9zPM1E+LFQtrL5JS0WZWdB
         Xp4Xvt/dmIl+ImWbF+a9QbNszH/cYwkZAKdhNWWBp5esFJHpbniHzjDgiYVto1Gx/7Gf
         /Oec5jgLcJAIVcQnQ6wgYABB0FXfj0HMJJVTyA3rjgezwN/pdMYnsrJ2mrIZcaZ/LbPv
         0IgNPRGeshQt3VYlWRzCQbqzzb3Xn7fmWDOT70tHMucEBRMWys7fA939jl2rCy6aT+Xo
         hU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932214; x=1791537014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ACN8gkcsm61w/Jlh0ZvQ88AVu95ak6D5T7q+jQbcfkQ=;
        b=QTSqU6D9cO4w5/XeT0TjQ5t2I8DAZG5BaSWJpyRb5rwFAk+pq2afnNEH5NJcdfwAF6
         Ugiyt2nTIwvh4iT2CtkHU4vUJyJdYFH+jHjLPliNKmrhowfsw6MFKmErTEggQcHpEima
         1/B+M4Er9k1Ihs+lcoRDuwkbdF5uCuM45Y2U00N/4TRlX+A3xBwWJPdYeMCtgd1nz9V3
         Nxc3FwJzbMi5y3SUBylldpe8B+UZ+Yxb+yGMU9rZIo3brRfSBASKq8WGnfox4lKSwIBU
         xKfKg7QV92CmzNE+NEWknQHt8zF/3QRCijjsFHbuW2IXQxgtwKCVZjqdFbJnQNMwOvCz
         OpQA==
X-Forwarded-Encrypted: i=1; AKwUvBxJ0dLDmA5mG8xjVKncOHm5Ss9B/uk43HbPsbVchjEU+5UGhrI7dss/V+vT7u3iQJOUb2MTY7mdTg==@kvack.org
X-Gm-Message-State: AFq9FYIdBumBS+DjgYyECg048m82Llvf2lNsznYwj2GnrmoXJnyL+P5N
	16SYx6yWDVm+TIZFM9nkDFQ89RQuCjae9XhEjvzroy7IaOOqbIGEihlr
X-Gm-Gg: AYBFou0Vk7r9ucZFuSbCiISp+4RPkY2drk6RraeioSzskqFypDc0Hpv6C2jk3pY8Gl6
	Ql03mGXpsOWv24sxqJCwxUZr00umzB8Y0x0kBK0SaUVdc6MSwxtS8eZsnY8WMASRGJKJPPSTjio
	nFKk/VmmK4Knij8llSxRvisbueETKSAFK7lqPjFMZkdvHcX24V9ew00q5nimb+HyA6WpBloFB0i
	0C0BWMGTL3G+fZLkqDDFvSnyGOspXCLI2xiqdNoZdl1xXBc64/4WhzfjiRjQ5bLQ3PZy+DeBafn
	VO+yYc9nhb8TVpyoMCZuO0Yc/4h1UJ+W+YDk5Ex+pt4EUvESbE7UrxHt/Rf51iX+Sg32BUEJFCy
	34Ow7bKYKsL5C5OIvoM92zVim2Jv+09u5tqMS4j4zJjOmTrktX5ZVXzNT8Cc4cRDP5kBNR/qV2y
	eACs1QIax7mN6Ga2IGMn+2YK+fbK1ivnwc0GiVOoxkR7yyDLJTMGjSfoRcEa8tf25bs6V16LeoJ
	RCj0coyqRVkgSM71gr4JA==
X-Received: by 2002:a17:902:d98c:b0:2dd:ad73:c987 with SMTP id d9443c01a7336-2e49b609901mr19907135ad.31.1790932213843;
        Fri, 02 Oct 2026 02:10:13 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:13 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v10 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge() for PTE-level block mappings
Date: Fri,  2 Oct 2026 17:09:40 +0800
Message-Id: <20261002090947.869220-4-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kaa7emk9t3zjf918pzg4tipc45h8awkf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 165F1C0003
X-HE-Tag: 1790932214-378609
X-HE-Meta: U2FsdGVkX1+EGssk1VpwP9COXQpvIh/jk1cwqPePjEDXGe1Qek2YzOoP3moBz4qCQKyN1P2SJqFhEBfsuU0VCxvALnCQL4FCEuw5OuePQG4f7rWFqbDKw4BJXue5viyPqpEG+BRMkTBE/k6DP14pr9AgNhpc3uHOo6Ym0vKwSVK820ZFdXdxXiZqQADCr3dolzSfJA0GZmkRKVlRmQdpoffeWjjq5polNY+tpp5HUzeT6KCmswkxxO5VgRrvjmqdJHvZ9Xe1ECjnFYWTAaeAI1pbAqsWW+eK7gZq4S35MX1FOM0zgjV83QtVOkvxaq4W7Oy7cD/aX7uWqeh4jG3l/LvYQgxqAbGevrMlvklpPZXzZcf8jV7waUnF60Jn6K9uvk8aAIFHloBFEGUPG9CgZghf/33RHEoiC7eacp9FXnYVThV8eccyQEbSjcY4g+5Jxsgdy9xRGTRVUdtYcEd1AlhmyRsl2a5EBr44fBAQPwuWRsqLGrPxo+GAPhqCuUmN6oLqHjginA866wgXtnvXR17CYE/BFjOIARvGARcotDn7adWfDCLjMEA6AsSFnsP5r7M4iLeX3b5hn0j84T6XW6r/nsxPLvltqyOIeBGv3lAGoFUVctHSpNTpzayJN53J21ksoY6UDZS8mK4H1I19falXS0FLUUBb/g30vm9dabx7vwdX83t3Pkr8s7NH+YExWSXz+TUBO6SqQFckqj3Lj7Pe6n5/chJGIpFcF3Lt3+xky0SRH21j41bABtfxLqJ6y1FHwaLCe3YBvZYa32R0D3snhe62Udv16+qOkz392DLh56isR3Fib7Bpja12wd4ihc4IBTjRYLPtiFJbvXjBStU+4LSDQK41Ypi/rXQUHgQ0Q/8drxtEGfVZDjD4OutzcQuJlXAfybkZRPFb1BTP5LVosNP44vrWWMmz4YWM924Xa0EcvUZt2BJj3zZzgxz3EcVrPhDBqJ6uqp23Tn1
 udi74QI+
 iLG9jyokRKuNC9hD4ZrbU41f5r1F6hJTAQW+YKg79RuDKdzwps0G6HqxM+bMmCHK44PDyFth0JR91hDIU84+BRbnZno9w2WCppThnuglZuNu+tSBAGfMY+xZHNmPoL8wpDZXRoRUvFe7a3xT+1FlQJRFsRdk6pSomC4vEgRg3YY6Cpa6E9nTpS7X+jzF475jfZ779jsVK3mr3IpdL3w5zvHpS0enh5gbsDqtg+KEyR7DGH/2BPESheej5l/bDmios84E/AjZ+/8Gqe3bJR/lAkt/Yp36nQZJ99x14/9ffgLEA20t0sRtdv3huTjZkRQz9PIoJ9pc41CozuCI6QOowWnAxR7hGgaAC9yxPGjYgKmXaUr5tUPtwFx3CP4Pgz8wdmpXjxpPa/fnGfsu219RiAXX8SlWdMq2YE6tkW7hSZPiUcIOBYWkbt3n4XeSFIsnQtU5B9RKHov5MtVoLJOGzirWCVMJq7cHS/EgdVqfNAd81Nk160okZd9KCykCCTm0Q/Myl0SFU3UGMCjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.

Now that arm64 and powerpc/8xx provide pte_set_huge() and
pte_clear_huge(), add the generic fallbacks next to the existing
pmd/pud_set_huge() family and convert vmap_pte_range() and
vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
around the block-mapping paths are dropped, so PTE-level block mappings
now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
longer includes <linux/hugetlb.h>.

The fallbacks exist only to keep the build working on architectures
without PTE-level block mapping support. They are unreachable there:
the callers only run when arch_vmap_pte_range_map_size() or
arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
which requires an arch implementation. BUILD_BUG() makes that
explicit rather than silently doing nothing.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
 mm/vmalloc.c            | 19 ++++++-------------
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a8..a7fd51fec8a17 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2204,6 +2204,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
+/*
+ * PTE-level block mappings for vmap.
+ *
+ * pte_set_huge() only has to be implemented by architectures whose
+ * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_PTE_SET_HUGE
+static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
+				phys_addr_t phys, pgprot_t prot,
+				unsigned long size)
+{
+	BUILD_BUG();
+}
+#endif
+
+/*
+ * Likewise, pte_clear_huge() only has to be implemented by architectures
+ * whose arch_vmap_pte_range_unmap_size() can return a size other than
+ * PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_PTE_CLEAR_HUGE
+static inline pte_t pte_clear_huge(pte_t *ptep, unsigned long addr,
+				   unsigned long size)
+{
+	BUILD_BUG();
+	return __pte(0);
+}
+#endif
+
 #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e74..fb757d95bde25 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -38,7 +38,6 @@
 #include <linux/rbtree_augmented.h>
 #include <linux/overflow.h>
 #include <linux/pgtable.h>
-#include <linux/hugetlb.h>
 #include <linux/sched/mm.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
@@ -100,7 +99,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -121,17 +120,12 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
 		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
+			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
 			pfn += PFN_DOWN(size);
 			continue;
 		}
-#endif
 		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
 		pfn++;
 	} while (pte += PFN_DOWN(size), addr += size, addr != end);
@@ -391,25 +385,24 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 {
 	pte_t *pte;
 	pte_t ptent;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
 
 	pte = pte_offset_kernel(pmd, addr);
 	lazy_mmu_mode_enable();
 
 	do {
-#ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_unmap_size(addr, pte);
 		if (size != PAGE_SIZE) {
 			if (WARN_ON(!IS_ALIGNED(addr, size))) {
 				addr = ALIGN_DOWN(addr, size);
 				pte = PTR_ALIGN_DOWN(pte, sizeof(*pte) * (size >> PAGE_SHIFT));
 			}
-			ptent = huge_ptep_get_and_clear(&init_mm, addr, pte, size);
+			ptent = pte_clear_huge(pte, addr, size);
 			if (WARN_ON(end - addr < size))
 				size = end - addr;
-		} else
-#endif
+		} else {
 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
+		}
 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
 
-- 
2.34.1


