Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24FB606A321
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=NEXlUMbD
Received: by kanga.kvack.org (Postfix)
	id CF65D6B0498; Tue, 20 Oct 2026 07:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6E66B0499; Tue, 20 Oct 2026 07:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96B76B049A; Tue, 20 Oct 2026 07:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 593B06B0498
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:53:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB24D40138
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:53:23 +0000 (UTC)
X-FDA: 85342844286.11.D501AB1
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5998180007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:53:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NEXlUMbD;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2KwJzViUvKuGBjyFaY5+OxoYxM34LxjvjTuxIXNaiI=;
	b=srFLGs4r735YkpECrB9zWdjINvlKT4pTNsIJDoonv62h/i3fzHqjuFRE86tpbHB60+dF90
	mtENq2kAKu3BixQEozVjI/FSJ0Onk0fyDg5vxHtOvzFcsdSnE3GuN+3r4JzUDDycQwaYtK
	mfpWBzOPEaVQMe9YzXv41b5Bev7HAxs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NEXlUMbD;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497202;
	b=2S+LONUPKJuIzzMKi8tpHddsNZ4uvUMvq8LcCy4y+1BUcH10tiJksr9ueVOGkIgH3QIBBc
	9uZao0ijk0L6xaKaDXJCI+TGKp/4nnoCynTTz2gcZyzCdrwUkHeFJPFav9xz37cKzfywy3
	AWTfkiXtrZART1RkdAuJMtjRqMrVi9k=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ac7c7b3a90so1459024a91.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497198; x=1793101998; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G2KwJzViUvKuGBjyFaY5+OxoYxM34LxjvjTuxIXNaiI=;
        b=NEXlUMbDGVwoU7w97bZEAjgCzIsCyu7HAIluULOezNMHy5H65dJL+x/uX6ZYXa2sCO
         w65zNQ8HnhiiZZpkpyXZHgDngSjldXLCwLKByfpDgnqg6OivO2im+6PppmMdu+zb4pNH
         N2kg0PTy77LAJrzrUPX9gnwiJkPmXHlCmnUyHAFSC9RgDYCf0otSL6fp7D4g3CF+Qs0r
         N6XPd6lIYxJPL08k2qsykmo+ZANJKHrhPM5/mG48Y1tkCx/l73umti2SPxxVuIw/DL3L
         /Ofdysa9Y8159nuFkgumgl1aJjojl+iJJPl3qcieyhvYGPrTl21qJR7UmtHAvepmQ9Mu
         2Lfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497198; x=1793101998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G2KwJzViUvKuGBjyFaY5+OxoYxM34LxjvjTuxIXNaiI=;
        b=Ts4N6CUiiLY7U7IiCmTF0Jm6iavd3e/su07pYv396NmgkSr3YB9RFz5ZOJbAa+dhPt
         hBC/LjyYw7mn+d4hmWjBPbABNofDTAmdCiw1t41Z8AXk3eVEgunbc8bovJN3I0Ml0CWc
         p01MfReFf+yG6pXCcrs3xnxY0UNzkH/4Fpo+h8lAL4WDu3MjFaRXqgEwStzud1qsor8d
         OA88fYxiYDDSl/dhL7VdYEp0RAB9mtHGD4HHHM1wu3hYfZHwU37sBIgs7/qm2zfdK+bJ
         1sxaam0u0FG4sXZLTm9qAqnsHrk5lI9fB4/swnbuVXMdaM1xjoG79hoVADYiDFjExEWG
         2eZw==
X-Forwarded-Encrypted: i=1; AKwUvBwAcx9i5bif4P9sTKrB7Do1qKTaKEN9A086iJYQgnqXLAv+cpL5rLC6ISgDtEaH+wDY7kgJTqiCZQ==@kvack.org
X-Gm-Message-State: AFq9FYJTzQ5aiT/Yl6ABDjWJMhJ6+huV3OLzWkvha5VBLtZAZGlHqvrK
	5zBty7HeczYqj1xsPB4GCb2zWGSlMpggkGlJTM4gnYwfaeMCSqivr928GB87i73vSwk=
X-Gm-Gg: AYBFou0s6kwrDIJJVinv5619A45oOJe23+WjKn/aDq0Bx4DFGFGNxt5XQ3aSP8ctvem
	AXE9GxyoWeBTUqLepMF5pwc7Ni8z5bA8eEuPSPxGhDRsIHnlzolYeEA9jyPval+DNZUJX900hiv
	I/k8fnSo9pC/h4DGEoDM3ArjEsg8ZE78mQPd2rYazGsfokROc1MRV5yhQxuX7v7Hk8MRMgDeipk
	T4OjZEN+hELGHoCkkAt2/7BP152AYrqJuHnZuY4JubJvUAgSIyM5xgW4th8zB+K/DmQztrqYC97
	e8XrivqrYught1ZqWD/ryZ9SU916rHsNaqKMaWt3cO9UPGBf+880m52K4a80SWpJPPMpbQzBXG9
	ws9rDbIEWVwRmiIVrfZlXMD6kosdxCqbXc0ddki+7VHp2vJFkCG229hD/sRl2Ioes7SdEK6/LU1
	Dx1DJjGuwBXJiwUIR7gzXfWN2dgJrPaVTEKGkk7jZgu335S/1e3IiEfUHEmOff7Ergq6RtnOCFl
	Tqg5alW66yWLsZdCIMJ
X-Received: by 2002:a17:90b:1d05:b0:3ac:9ed8:f319 with SMTP id 98e67ed59e1d1-3acee98e7f4mr8335409a91.2.1792497197896;
        Tue, 20 Oct 2026 04:53:17 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60f34bb6sm3742401a91.10.2026.10.20.04.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:53:17 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 01/12] mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
Date: Tue, 20 Oct 2026 19:52:55 +0800
Message-ID: <20261020115306.813483-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115306.813483-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5998180007
X-Stat-Signature: r1xkqs1bo6ek548oxy6e1osq7ayqe746
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792497199-52999
X-HE-Meta: U2FsdGVkX1+sCmhFXX7X0Dmx4REXz0xuA4FtYoKHfYvOEru6EbNLkyh/AIbgskn7AUbzOgWq9/p5m2RVPuMEsGxJcp8v95i47p1UiiGjJseFK9hSaB5r1pEJcaat7xYfvcZI8C6uVZi1o6bk1EoVx/ziWebC49e+CSnbb7wgGZLz/vx6NI2ceFiWwom4JaSRMNvKs0K3I+nGVSK5k10a+Eh+L3BbxUQ7XjFBMfjA94vC/jXcNXyYpH6pzGTxwydKwltnNQW4sZQLdsTjk1IYdj0522zuznQjOCTSclZgViZHHSzeg9sD9b+542uGG53JDFoxzBhzHG3A7wqGvs0JuPElTDstl1Bu+UatIteyCFYTScSQz1H0uUDUBZ4JIQKvwoapL8CDCaN4/cp2+ZArHlG73cN0uUwhFc2KTGMaeuJtLDkZ1FFrSWMEqa1E8OI8f05jYrYCidlkSFngQ15IWlAlApsdj1Okdx8W8aDbTag/av+gKg2pu9qSPKztn4pqWJHPk/Geetfq8d1Fwx4GpnkHH8vfj4KH458yJOnR8/E8p6ht4T4RChWSc5ashzOeLrrQd2N9GcyI7ClapDtQJ5YCNVUqfiMA9UgxaM3ohCoXTwSM2J9MpPzIUWaJG/mK2BeGXDs88+k3oAgISttq2XBStffMBjHuBWk/qmKHR/T8jVe6Y3SMVkbqgSj35fVTyU9zOaGbAucGbsGjefTXHkG9m4cSIKH4+gEig/KdXLC7lvpbM0LoJI2LKBVebSb779cSkStcmg/yjgv022eUZ3OD7PXePwfP9yiUlb/+3oBjggoAARAeHnn5cmViftzQEJ+hYLuxNVtrOg25STFhTjRk6RjQ7Z1v9S9b8XKzRcqoCJBlTPd2q14xRaxuQasoWfNvvBWczPhl5Q7xfBTuQicySrskHxVEDrhilMuB2DNtCAiK3LOweATlpoRRdnkcvBWkrZeEaPM5qxYp5jC
 6G6Pwbmh
 4+zMfZ8nuaKekmpS172ibLmWsHdJ2qg/l6j4UXp7pybJSixY1wI0xi/UfdmMon3ILxXBCLdZqRa+jF0jBcPYqxvyyRgH33yfrKQOkYHmReABdLF6HLQLKQg44VmfdDakpsp/1T8J7ob53T4uQycLIJ/qbxWQ6OF/Zqv4yYReJ6x+uTJxGI9pxFOk+jjsL/tO/A656I/RbFZwGZwgiLqVkv5pBmER9uaU99mLfqhnPoMr1IGp4cWT8wlnQzMR/JNt2aan7VzlgLgeRzws4QpPzqBlvD6fASBRanw3xIj+6H4RJDWe+TsNZhsExKQ2rilz0sVGlqTfQBCDZFZWss+g717LM2fgI89RuQ4ma69GbzznFatY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap optimization is no longer HugeTLB-specific, so the remaining
HugeTLB-local reserve macros are redundant.

Replace them with the generic definitions to remove duplication and keep
the HugeTLB vmemmap code aligned with the common optimization macros.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/vmemmap-optimization.h |  4 ++--
 mm/hugetlb.c                         |  4 ++--
 mm/hugetlb_vmemmap.c                 |  8 ++++----
 mm/hugetlb_vmemmap.h                 | 10 ++--------
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index fa9e9abd6656..065840f3c241 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -27,8 +27,8 @@
 
 /* The number of retained vmemmap pages with HVO enabled. */
 #define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_SIZE		(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE)
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b37d7d0db7fc..6a011b627986 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3308,7 +3308,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * be no contention.
 			 */
 			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
 					pages_per_huge_page(h));
 		}
 		hugetlb_bootmem_init_migratetype(folio, h);
@@ -3348,7 +3348,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0057fa2a16a8..1105aa925acc 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -406,7 +406,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -613,7 +613,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			spfn = (unsigned long)&folio->page;
 			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+					VMEMMAP_OPTIMIZATION_SIZE);
 			continue;
 		}
 
@@ -701,8 +701,8 @@ static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
+	/* VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 464192e32dec..749c7371ceec 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,13 +9,7 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-
-/*
- * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/mm/vmemmap_dedup.rst.
- */
-#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
-#define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
+#include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
@@ -38,7 +32,7 @@ static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+	int size = hugetlb_vmemmap_size(h) - VMEMMAP_OPTIMIZATION_SIZE;
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
-- 
2.54.0


