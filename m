Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86FB606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Q9j02PJW
Received: by kanga.kvack.org (Postfix)
	id 031736B05B4; Fri, 30 Oct 2026 10:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009196B05B5; Fri, 30 Oct 2026 10:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39E76B05B6; Fri, 30 Oct 2026 10:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3D496B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:08:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36C3CA7AEA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:08:58 +0000 (UTC)
X-FDA: 85379473956.28.A85F013
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id EBDBE1C000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:08:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q9j02PJW;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793369336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjoN4+6LqE6BOGR2vrR9uNSgacxzY3BRDUxvEZuPaiQ=;
	b=dvnOHYEdljS9RYva2Qor77ugG2SIF/OMjVtbO83RupPrATX3R5KK6hDOWII+eEx1tReZmd
	K25d/kLfaEhOfB5+WPp8wdcyavuaWFNoP7oEJyf+PpfGn/LPIjSesZdBC2GMqhs5nNNrX1
	CcWgrCssNJRv2AftnN/JxNc5QJ02+WU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793369336;
	b=TzGBqQoF3Fba9Il9vQAXzkJVOdaLZSPn75xkEi9AGoaUcpbjcDPLWp25ImzuyddgLJWHtl
	7DnEEXx0hzmwhCa3K4EKE+uQfsKEH1IaIR+tK3YmKUnKiGvpW3iNG6+Wjd7wdSbT2oGvGa
	kLSyunRkGaXILu2Imv/yqjQULcFro08=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q9j02PJW;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e985106c0cso7148735ad.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793369334; x=1793974134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QjoN4+6LqE6BOGR2vrR9uNSgacxzY3BRDUxvEZuPaiQ=;
        b=Q9j02PJWfNx6AcyvdYe5W3dkveqJnwpiUdj92nDimKDEK8w6DF6g16pQ4pA92pR6Qm
         xj1g7Qm0dBw1HaaihLDkZ2rrQoRKcsqcwmdhAvyF+MLQZk4H1sJhPN2l8oXDEYwJO17Q
         jjffT9LGITeJzj/xOZ7291nzZPaR32TdK/SfuIV4cBKyqbM0CpEWNwPVvbbd4K73SIj+
         v6itsvV88+Yg2c4W2H2b/xPhNYso3fMOIVGxD/MmtGZ/V9sk4/glib691N28TdhTpP3l
         7idirtZd290bcxkSruERlbFurcPZkF3jHmM5xbeUq1fpEhyoXQ3vf1iI6+vzMRyCL9tj
         iAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369334; x=1793974134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QjoN4+6LqE6BOGR2vrR9uNSgacxzY3BRDUxvEZuPaiQ=;
        b=PV/vuVogh6JUNJHgci0mG9f2pizpkWuaRUVcS4D+/AcHKUs14FT/GwNcsxry8UtARK
         F2NKADUOjMZZdULwW6FzBRrTRTkrQvS+YfklGm+ioUAPHSyG/Ca7mLUBT5o8dPKluqqm
         BHNP6tvx1Zej6CiS9USGyNkxcJTawUQCglxz4LE0YxuvxoxeRMI2RaWv3mo5XGhzvNaA
         PQantk9VyTg5Cl15B5PobfButv0g5VnBqAO6/1TV1rcIf7bnXhv9mFpCHwAroQTYTLY3
         zlHYPkw7m63kdLLcLnwG3uptaw3qArEAPjYDhUl8nGic2G8okWrY3+tgdV8idCXNled9
         VKmA==
X-Forwarded-Encrypted: i=1; AKwUvBwYGjjvXep3h+vyTe9osok1KV19H/P7UojE0ZXeVO5FjAGEEu6kGG3WLra4JexndJKn8RsSvcwdoA==@kvack.org
X-Gm-Message-State: AFq9FYI0gPW+8I4oG7reXxIBUJvCWX5tkRM4qGAEOitGbzqCboF/Nj79
	qVFTfJ38Pk1/YtUe0H9UwOgBjrydfi2omMX7jTdr+qBRm997N8ty5XAcRXuorqK5SRQ=
X-Gm-Gg: AYBFou3UWd824QLD4ToLnaMREokqPunpCQIoEzjrey5K21yEVbDf+gV6vOdQNk/9kEx
	gw4cgZ9P1neekeCfYRxo+cEW9s+swykuzrQbMgg0Sr4QYsFnrmqEzqUgrOTAVYx6o04ws6YuXAG
	vJGMX8II0/h9xszZOReiW5uwzCAqIWI2o9vUcDIzRqCjqMQPzt4ERM8GCdhQ7KcXvXBVRPQ6gQm
	cpZuizuXcl9HvbJISfBMsnB5t5P46UgIKLHnvSPrDcJ4N3ZAtu3L4vUk6rDxdFiw5S12C9wbCLl
	Xq/aJYTsg3tSj15b64MuFelSss44yI1qjAa7n6pylbDYhotvQR8YTOVIP1smwW8DOCA0LXAIi4F
	8IRL2Ux4GZ9qahFeWSOOenZECka1Z0BcswzpKglGoe2fbV2EVULMn+f6UvZLQHcRlWEFD1wVfBp
	3cw4MOx/CMI7QZfWyE02LbHK4dUIb/4XB4AuiZXLhadogVbbRgoyxszTYOg3VlD1gIWa5GbsZAY
	vQYgeyeOLdMRjYTLIYjZ4jY4VYLz7KAmKwbv7vCoCkQmMsxKRKm+/qDHe0r0rr6CF2ttzxQff3h
	n1e35xizpo/67q3EQH+znH/cRQig2HJ/UR4kKNBf39o0a/IOOyY/FuJ9FqMwNFY5UGejzuwx
X-Received: by 2002:a17:903:2f03:b0:2e9:4f7b:affd with SMTP id d9443c01a7336-2eb36415069mr25082595ad.6.1793369332072;
        Fri, 30 Oct 2026 07:08:52 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3929b27bsm7601795ad.62.2026.10.30.07.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:08:51 -0700 (PDT)
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
Subject: [PATCH 3/4] mm/sparse-vmemmap: drop vmemmap_can_optimize()
Date: Fri, 30 Oct 2026 22:07:19 +0800
Message-ID: <20261030140720.1256062-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261030140720.1256062-1-songmuchun@bytedance.com>
References: <20261030140720.1256062-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBDBE1C000C
X-Stat-Signature: bxz1qu7oozwxd8atxf9j5p58893uk4db
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793369335-834124
X-HE-Meta: U2FsdGVkX18rHdTzNTuCRP6WBettC1ZS5R13/zoekmSlchJFfC1CwJrLE8z1gSTl8ZYxiAK0ecz1rlvpCH3CFk6/P/zOC1+xCPjc/J/bVfd8PVkg7qjHGQrGMcmov+TGR983GC82JcKgnmI0chtzsekyzwMKkNzqTJfHZNFabuz0pNqbsKo0dEw/U1NW97h3bpQZ1i7vMOG7Uh0kcrOPFN4oTK7rmERmXu6mpFUaLAnKcpPfKITgv+mYs45tGmgRI5Kj9v0gial8jFOD2Hna+fH8lGfaVmqO5XRIXbUWpvhVWTbaFHRiEcUrKG5cdh7tERyvBywFH8egN+pXRW0nS4yNy20FAc1Ruf0FjRVvhV2RawB9ThfFusPvbUsf58g93zbVNmO2Sv3hIUqhLr4uxw/NbwDVCxhlkcxkZI2MFmhRgDK+G7v39HOECgd+Km84jZuO4Eojpb5++e3bmyntVokj1f0QTUyHQuY/aXuhPA0WGcHBvK080J/DyMt8wPIdkgn3F/9IKqw1WLjQZiGEFw3HAUtX/3n9SJYK2SD0KSavwXYf85Ap+SW3p8yuqJvV6YKy2g/iHr2m7PiNBPVJ6Xsvc8rBG0LxBo9tx9n6yQ8k2SzrosZFI5Hc0Jc/asA4dPDHyK1jwdnwmA/eUDLGsrtZon8HWA2Dwxr/0kRHY7eeX1q4gwnK9AwroaiJADLJidtT5HRH5y+G0FlmrR4gvj/OsnimMvdFWuQwg9eOu6HWlofJz5jf7BeGkQF0qNWc3rQN2/qhNKOU/xmkSf5Ask2cPCq3uc3gHxCnKKRBC6hx04twBnqDuK94koFg5EHDTsT3D2Upe81DyLa1KbBSbCYRdzrkMg/otLvLwLZTAp7yPB7Y9GsEomHmOtPhMIki2g4NaQ7NGUl25UN7Xsd106JyncMb9ghqfqvHI2OvLo7dQPLH5DeV86jaHk49Xk+Upa+VMauYojtH7NwB6gm
 XaX5uzGf
 mkH8n7AHxkV/wwQpl5mQnm3aldXVrobbfVdlhsScDeIonNJQ6HW69vZVEDfGX56us7CUyCHpYgJTir8ywJNg2bqL05ufDclP0Y2TZvPFi8SdAygMVCJfufNZsoywCO8YGT0QyULLgbv4+6t7+8qakLf+HT02I9zmxCf+sbqEZnNrbwB84fQS9wkW2ucoKlI28Jzlq+pVqzm98Bo+tbhFr8IyEH1s5UaRRzQyDDLNcwmvQxSMmOAS1LCNUY5QPHlRNvx2EM3JnRVc+k5/oxCLYLmkUWlE5czXVSTleAnafe58mEB8dD+pkGrJblEZUD584LYysOHJAMpWfWcWOM7n2QvVqhDT4z8ELDZQHeV6LfJRyGXmwBuxMHoIVt4msznXwib2DF5btg1xbmMgS/ujhc7qCNzQ9HdZPqsaXz4qvz2KK5rSdGEoyDkObsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

section_vmemmap_optimizable() can already decide whether a section uses
vmemmap optimization based on the section compound order. The DAX-specific
vmemmap_can_optimize() helper duplicates that policy, so remove it to
simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h  | 37 -------------------------------------
 mm/sparse-vmemmap.c | 11 +++++++++--
 2 files changed, 9 insertions(+), 39 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e875f73b0c6f..4fb48fbe712d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -38,7 +38,6 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
-#include <linux/vmemmap-optimization.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -5395,42 +5394,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
-					  struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages;
-	unsigned long nr_vmemmap_pages;
-
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!pgmap || !is_power_of_2(sizeof(struct page)))
-		return false;
-
-	nr_pages = pgmap_vmemmap_nr(pgmap);
-	nr_vmemmap_pages = ((nr_pages * sizeof(struct page)) >> PAGE_SHIFT);
-	/*
-	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
-	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
-	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
-}
-/*
- * If we don't have an architecture override, use the generic rule
- */
-#ifndef vmemmap_can_optimize
-#define vmemmap_can_optimize __vmemmap_can_optimize
-#endif
-
-#else
-static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
-					   struct dev_pagemap *pgmap)
-{
-	return false;
-}
-#endif
-
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3e9d6617c4bb..43559593107c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -466,12 +466,20 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	struct mem_section *ms = __pfn_to_section(pfn);
 	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
+	/*
+	 * Vmemmap optimization is not supported when vmemmap pages are backed
+	 * by an altmap.
+	 */
+	if (altmap && section_vmemmap_optimizable(ms))
+		section_set_compound_order(ms, 0);
+
 	r = vmemmap_populate(start, end, nid, altmap);
 	if (r < 0)
 		return NULL;
@@ -699,10 +707,9 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
-	unsigned int order;
+	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
 	int rc;
 
-	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
 	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
 		return ERR_PTR(-EOPNOTSUPP);
 
-- 
2.54.0


