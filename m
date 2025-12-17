Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AC1D6554F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301246B0005; Wed, 17 Dec 2025 07:09:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE726B0089; Wed, 17 Dec 2025 07:09:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190B66B008A; Wed, 17 Dec 2025 07:09:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 07AFA6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:09:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEEC81A0A3B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:09:13 +0000 (UTC)
X-FDA: 84228842586.20.AE171B4
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A8C2180007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:09:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H9WYzkFJ;
	spf=pass (imf06.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765973352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5MO3Q5T5gWjRjMPEnUZXPC/z7hpENtdSyL6rsjX0H9U=;
	b=UZk1xtPYBo47EWalN7knnMuALTY3Ryng20xvwaZMiC2Xr2+bWASxM01mKoqW7D3FgUdisu
	6h6zOJqBBpjEblHUyiz0jKNBDdJrFDsVd5jd3iRJBHJReOIoleYXTr6UpfIdK7aGrEFK9o
	2NlMvMonC3GIPRKa8S9kDF5WFcwxdsA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H9WYzkFJ;
	spf=pass (imf06.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765973352; a=rsa-sha256;
	cv=none;
	b=AR8ThlHlObvjFJu6k4EToxY2nW16h0GX965sHrcroMvL0b7SVYNIbCeSenYDXaVnfRAf+J
	7hUABz0kvS6l8s9cUD9iIydK2yJSulW0z0jZd6m4m2KlRRf3Zz3KGJlaviYLFmZtkuaRcQ
	SXRudp4W4IpahXXjYPFHYYPbiYquUoc=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bcfd82f55ebso215214a12.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765973351; x=1766578151; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5MO3Q5T5gWjRjMPEnUZXPC/z7hpENtdSyL6rsjX0H9U=;
        b=H9WYzkFJw7RIsjJyOrI5o+9Kchn87zngWNZa1qbU7AAVh/IM3ck6bZ5rRYD72iUO2i
         WZF+Ecmt9OV6nEGYD5rJSWe5CN6HubpONUXGaXNwQWbGhBbj1T80We+ZevEOCV31pY+C
         DSdyRHGGzJAVKT8kEIZNUEVsqupkZvuR33js8oOGVX52yHXYcjTDgtk3NtO2B+0+EWTF
         EBCysz6OKYO2EkK7+vrbXW8KbD0MvCzvFFfN/ol/bCv0sVR7xH1EcsaV1oC35vhrFdWl
         Gh8YhsMgfb2ZFRKpKdnPE5K0KNSVxqrNdpfniI8Fe8az2/k76MWvfFxF/cUuPmjdoQiF
         fIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765973351; x=1766578151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MO3Q5T5gWjRjMPEnUZXPC/z7hpENtdSyL6rsjX0H9U=;
        b=klJWjVLjSisyvrkCpDmLfaBDN9l/2tQys2UQht/4wrtBigqzMecaRxsshCYRt3L6Jn
         bHkdYcMDVL3pVIWrfPEXrKHQLP3OBcKI0fy8gRdlmwX0gxs6WJahxvQDaqwG+k/Auwe+
         3Zy+yH+owK1GJs/yo8JypWl+FQKZmOeONMCLT79Bgs0TnhuEwiRE7r81aeZQRisMM8RJ
         ViYiWGNC4ULhGsQfNIv7haMHK9xWnvdqk/jZx5r0ltJPTZiy4/FPcjqdoAcnmt8N2y6e
         pnMmNySF1XAnfIIFDT/4r9AlawKurqvU7WaKXV3ko2bW1SO5RlQSg+sPxwBU9s8JiCgu
         QAXg==
X-Forwarded-Encrypted: i=1; AJvYcCVU2tGmVvJ0ETHVfgM+KvHT19aE+AzGMAMvmImgKUauGAT5lR2w0EMUO5Fco4mhR4tWY+LL0WznDg==@kvack.org
X-Gm-Message-State: AOJu0YwbOm/rdBq/AKZRGROqa5BH6MIeYXm9PI8zOhOQ5jVzTOcz/5ES
	mjKx1yPSdC/H26qYsUbQmsrM3W7YSI2lNaJ3eS3jHmiFB9lVL7z10kBg
X-Gm-Gg: AY/fxX5xDpMEAqUYAw08MezWWUJLGZfe6NxBpgtpq8uwkEgLiMkqcYTnrwOWIip69v/
	RJkaDL9k4Y+ziwFMu5O8RC5tK70oQqvqTys6FW+KhPNIQ9Iw0QZsR8sQh4SSeE+0Ka5aTczRXgw
	lqAGIG27YCJKYgUO/uiH6wGIFSE0aq3Jbtlu5zIqAYZkbg58Z79bgMlMaKLbJpv7oLlmNZwiTg/
	/ljgo9cx8T61fwnfTZaiz2dvO7is6u/m3+BXmdoi8X+r9IsxBlgJEt2BoWgIM3qS9EHwZyG2Lij
	o94vCWZxhFiaLdhu/zdBtFWd/dYIHrTeKN9TcNuVlEDzrTmwcboE6qfvhgTOl7KcfQ42E49H398
	kP1oediVGxNIoe8Ej2C09oXTVSCBfa27eHfwH2PM8QcbRtlDn/fVsWkltrh7Xmljyn5yjQVdBIw
	7Go1kFc/4wVCz2gHR5kGrRQlWUxL7bqKCUirxcuSKYVHA=
X-Google-Smtp-Source: AGHT+IH03HXWxu7yczO0LADVUezeFbBUy3RsqSFlgZLDhzDggYMtvvDz8ILuMy4Gs6BIFYfX1kB8kQ==
X-Received: by 2002:a17:90b:48c5:b0:32e:8ff9:d124 with SMTP id 98e67ed59e1d1-34abdf40c33mr17148583a91.15.1765973350612;
        Wed, 17 Dec 2025 04:09:10 -0800 (PST)
Received: from localhost.localdomain ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34cd9aaaf2csm1683105a91.5.2025.12.17.04.09.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Dec 2025 04:09:10 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
Date: Wed, 17 Dec 2025 20:08:58 +0800
Message-ID: <20251217120858.18713-1-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8wcbw89jg4t66orpjs7c9szrrbkams98
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A8C2180007
X-HE-Tag: 1765973351-79999
X-HE-Meta: U2FsdGVkX1/FaanPzjsdxKGGyKiW48UAESbndUMD7aGjdzeYALDOWBL5PJv1gdSdYdLb8uM7qYhs8EDPwKscc+JbxwZS+xihmeEmu3JzoX0jVneC3ocoyU3zoSF8jWmFIgS/QnsTZrvvR/XteSnDWmRrGd9gcWnqMqGAMMKK40b8S6y/tLHLdV1HsbHQ7wrxJ91gTzYJfFp8QhfnA5o/y2B1kh24bbFTUeqUgrv0zO6yranqwDA7A2pXpr+S9/MJpAlBP90JptvWJQTzIWxfCBJUK9HsnJpd9BEFk6nk+Dz23vPJfiOEuvKReDxrlvJbW//GSWlqQs4z8UapoRdRYfkGJIIJKo7Km0AsXAEE33OotgCizzaTF7cpb78Bb6WKiQ19+/DYUbAbze/nj7SSCZjP78UKpccei96YsC8L0SKeUCYntQUemBfVG9PMrgQFwzFxQxqiQ0Uz5bnFRh3bq9fdXh+g7vySVFQ8KCEf4unPZNwC5usTZDMamvTQ2aL6NFHzDhQw4R0hiPkDqtkGV8XrCN0mlUd07bmcG2Wq0anPepiqv09rS9Ge56SsUulWh1LrrRSEf5u6ysgPyb6sEhd5k7A1inWxuA+4Gq2Llgi26JOahUYdVwcHAD97Z7XDuZlmyox1roz8H0xm2YvGscoc1r60WfKH1aPFftOuAVfOvOFQ6Tu05sfHqQ716SZq6La2tFSWzQgANufeW5H/DjA6aEvHqmhlvsn1YvVfvFtkDpovAtw9p1v5WryVFgsqWnnBbsear/FZpjIUIE9I8b4pr2vrLxn01TeaXV2HzDQIDj4ZvUDInx9cZzgEsSyBFEpxtKwdZDXMo42kBY7d0303RaBTYyeblWD8qC9gyQ1pg+crtvwMa88bhCTg1WHO2MB8FHpVbC6KDI1zD/7Lj3pl9NiA24pQt8j+YTQ+lh8ddI+GSDEemzxvftAHzAaSQO3fdZl+jhqrydvi//e
 jMiKoXv4
 iU9rmPfboA29Epp5rxmUPi3ZzZ7AUd3d5UoPTriJkRWohnYQ5B9qDPOrQInwlT1VAEleeVJ+78iS1Aoc9Q9w7DXOq35Qn6WUOpnp3ZBGYS0N4UR99xQczvEFzHfJsZPV68lBEVKwQjB7K6ldPBjGwC1wBgVF8fSjosS8Y8TBXCFe/OuOFFuX3/iCt8cDh4pEl5OCy+xCeYHU6a1xrJv3y3uPDCS1Q/eeOl43b3vaByvH9X4vpbgEk/xN6ZnjaMP8+7F3OM/IsvIFsJ80cSgStbcu9X6z7lO/Y1ozmXMRhhEu7f7tNH2WiknGuh5EsxJ9kH8Y7N00uo2UPhDIQnuHkH0jwHABWRYLSxhqsy1HK0ot97HgdlF7VIVyE9M3DWZtEiCqr46iZ5LTEgLTlUdUL3iem82e1xj5l0c0jRNGGEStZHO413faDbBkZWqaF7oqmx5r/+41yeuT744njXtZMHzUZ2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

1. Added the vmemmap_false_pmd function to accommodate architectures
that do not support basepages.
2. In the SPARC architecture, reimplemented vmemmap_populate using
vmemmap_populate_hugepages.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
---
 arch/sparc/mm/init_64.c | 56 ++++++++++++++++-------------------------
 include/linux/mm.h      |  1 +
 mm/sparse-vmemmap.c     |  7 +++++-
 3 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index df9f7c444c39..a80cdfa6ba98 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -5,7 +5,7 @@
  *  Copyright (C) 1996-1999 David S. Miller (davem@caip.rutgers.edu)
  *  Copyright (C) 1997-1999 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
  */
- 
+
 #include <linux/extable.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -2397,11 +2397,11 @@ void __init paging_init(void)
 	 * work.
 	 */
 	init_mm.pgd += ((shift) / (sizeof(pgd_t)));
-	
+
 	memset(swapper_pg_dir, 0, sizeof(swapper_pg_dir));
 
 	inherit_prom_mappings();
-	
+
 	/* Ok, we can use our TLB miss and window trap handlers safely.  */
 	setup_tba();
 
@@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
 	unsigned long pte_base;
 
@@ -2595,39 +2595,25 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 
 	pte_base |= _PAGE_PMD_HUGE;
 
-	vstart = vstart & PMD_MASK;
-	vend = ALIGN(vend, PMD_SIZE);
-	for (; vstart < vend; vstart += PMD_SIZE) {
-		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
-		unsigned long pte;
-		p4d_t *p4d;
-		pud_t *pud;
-		pmd_t *pmd;
-
-		if (!pgd)
-			return -ENOMEM;
-
-		p4d = vmemmap_p4d_populate(pgd, vstart, node);
-		if (!p4d)
-			return -ENOMEM;
-
-		pud = vmemmap_pud_populate(p4d, vstart, node);
-		if (!pud)
-			return -ENOMEM;
-
-		pmd = pmd_offset(pud, vstart);
-		pte = pmd_val(*pmd);
-		if (!(pte & _PAGE_VALID)) {
-			void *block = vmemmap_alloc_block(PMD_SIZE, node);
+	pmd_val(*pmd) = pte_base | __pa(p);
+}
 
-			if (!block)
-				return -ENOMEM;
+bool __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
+{
+	return true;
+}
 
-			pmd_val(*pmd) = pte_base | __pa(block);
-		}
-	}
+int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
+				unsigned long addr, unsigned long next)
+{
+	vmemmap_verify((pte_t *)pmdp, node, addr, next);
+	return 1;
+}
 
-	return 0;
+int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
+			       int node, struct vmem_altmap *altmap)
+{
+	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..5e005b0f947d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4248,6 +4248,7 @@ void *vmemmap_alloc_block_buf(unsigned long size, int node,
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 		     unsigned long addr, unsigned long next);
+bool vmemmap_false_pmd(pmd_t *pmd, int node);
 int vmemmap_check_pmd(pmd_t *pmd, int node,
 		      unsigned long addr, unsigned long next);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 37522d6cb398..bd54b8c6f56e 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -407,6 +407,11 @@ void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 {
 }
 
+bool __weak __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
+{
+	return 0;
+}
+
 int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 				       unsigned long addr, unsigned long next)
 {
@@ -446,7 +451,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			if (p) {
 				vmemmap_set_pmd(pmd, p, node, addr, next);
 				continue;
-			} else if (altmap) {
+			} else if (altmap || vmemmap_false_pmd(pmd, node)) {
 				/*
 				 * No fallback: In any case we care about, the
 				 * altmap should be reasonably sized and aligned
-- 
2.50.1 (Apple Git-155)


