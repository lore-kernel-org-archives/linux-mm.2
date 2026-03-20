Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0CDE1099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9C06B00BE; Fri, 20 Mar 2026 14:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A666B00C0; Fri, 20 Mar 2026 14:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A456B00C7; Fri, 20 Mar 2026 14:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C550B6B00BE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AEAA1D9B8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:45 +0000 (UTC)
X-FDA: 84567264810.07.07FF30F
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id BAEF340010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=caNDPKmP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3rpC9aQgKCBsA13BD1E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3rpC9aQgKCBsA13BD1E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cwrx/w1VbhrLaNu5EmwvIE0sq6jjLjiDS144+1LBu5A=;
	b=QnxshI/B6d/eW6aIfwuIulQM12Y43qh8P5WoWsAGWdya2hY6VoLEtAy4hgN/4QxbOyciRV
	hTVJDoETE1fY+qhXs2l+jb6+O+kww5w/z8XREzzsl0N0dPlSzmIxuCuMy768AqdJEvDS0X
	+q5j3PGpbfp4+qXAwDOiLp1NpKp8nfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031023; a=rsa-sha256;
	cv=none;
	b=JccExcYyjhDXiinp+RIcqYtk0g3yIsfe//sPZgqdj4yhHwrA53o7FDi52VaeyAG7zjTc0s
	UFjwA9nT5UusiW4SaqBS7BgY+Z/mIKG55yZXIImj7Z7jqa+R+ihO1OcbpF+B8xQjbCZ7e+
	S9Ng9jUaNVQo8T7dxkrN1YNrvBu/nmI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=caNDPKmP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3rpC9aQgKCBsA13BD1E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3rpC9aQgKCBsA13BD1E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fcc05b20so7469145e9.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031022; x=1774635822; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cwrx/w1VbhrLaNu5EmwvIE0sq6jjLjiDS144+1LBu5A=;
        b=caNDPKmPs5zvxAATtmJeTorYl4HmxEYJwc+VtuNeSNCrzvNZ+yv3T3/w29+yL9oEGj
         jXlICVpfTDLirzguDAncJfrHNjW8odZU+P5w90vTgTmwKT9RXCACJrMCxP7U8C/v+oNI
         AsElBQsDXI3Jb70o/T7k+5P6dlNuGBNgH1NLQOjMuyCAbzzF7jEhpTdIO9HoUXQG1OVs
         FMyHeJh9GeNk7QMd6FQePPf01E8eFxiUnSPRo5q2xkod7e0TiSeFjgugEMkeC3n64M+t
         DI5m4jD9jlayRocO30BXerMASmTFaTiMZ3+dx3HszRh9kNPuv5eV/PfWHMfQk2/4IJrX
         0kGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031022; x=1774635822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cwrx/w1VbhrLaNu5EmwvIE0sq6jjLjiDS144+1LBu5A=;
        b=JEovoEV9faWFXUNDWHYXuICyp9AfzPXw6hmMF3NizSSKDk6J9L88XRHSom2SRBZ9/8
         ppZuIQAKYOvUnrHG+oKd9NRcwlhgNTIKhu3kcyuQB0NdoLsMvSFoMFWtQe88BP4UfTC+
         7KxL/BEE9XYCNHhu+kZoGJqI25y4iCjKy52gjyT4NHu1eDlobUZ7hNjT4MfDqFePl4bd
         rsGUH/BkqOcbFmXDJzmJ7J1oq4NMnec+dlZDnqSCJkZ5dsloTMQIiEV/8BFy5RxgJJkL
         HKgbQarcGBEJcu4aeKaQvptYc4G9+/tfaOuKrcJvSWpXDJ3bcnO9lfuergFZq/qOGtXz
         4YQQ==
X-Gm-Message-State: AOJu0Ywda0KkD+mNbfHe4xrbqvW8uYEFoxY7UCVl8l+PYSdqSQHqu43D
	P/LNVCMyevCJYXWx4OxOmvFmCjlsVEcWBzhhnS+SjhKyc6kcjkVnKn8l7xzehvbfeEKYvBwnx1B
	TkHlV0gdv8r71KQ==
X-Received: from wmht22.prod.google.com ([2002:a05:600c:41d6:b0:485:3947:fd76])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b46:b0:485:3baa:af14 with SMTP id 5b1f17b1804b1-486fee0fc11mr60139015e9.18.1774031022187;
 Fri, 20 Mar 2026 11:23:42 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:27 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-3-28bf1bd54f41@google.com>
Subject: [PATCH v2 03/22] x86/tlb: Expose some flush function declarations to modules
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BAEF340010
X-Stat-Signature: oze8psa1gocyi14c84b6o8jyoocwtdog
X-Rspam-User: 
X-HE-Tag: 1774031023-143684
X-HE-Meta: U2FsdGVkX1/8zGEAlNWFydNFVlvj+BkdrWzDqzFZPSAJE2i9NzBjfihRFzN+0zGiaQ7Y6fgDolAuNY5mFVM/v4BP+j8rBjmXyw7ApvnlMGJJS3n6BLuTn2olvj/vx75ZB4o+o8iyJYdEXrFDZFWzVGlLs5/fYX5UuYuaoW1dRYYpivDAYMD7HO5SpwhFGyCrZv34V8HQDmYfoh7pUycrTNkYopZJPCX+cyAzxk+3gmdhDY1XQ+SfslugDAdWiDm0ZXLoHcwnvA0fyLctR+wMd4SrQs6AWFcH2SMb8YSrHy55T4vLlZtNEZyGw7XR6KzTTx2JTvmfYwCTFncNv+u9KrhK2BjtWy86dZ7VL1atsBQeZjzYZjdXbhV8UzuJFi9p7lQkvItotFs9lB9x1E2E9VyhKXv96vuYDbiaEECKcEPXeK3+LoQ1RrODCVMOtUYiCCYqrf/0f2LId6jXgcs26gOVBRrr87B/kuFuJiNxvr2PBYpJIpzPkYB/KUdFMr5mkg2Pwag9pgGWHzDzC1/NGJmxa6XIdM65KoYWcq0lhmlkSL1kSwu/XoFAy04XyXiHM6T6Lz+Wt/0rjb242qmg/AQGE01N27A3bZlPyy3rwqzJjSIs3/PGZE4W5pM5m0b6ZnBmTEy6JCS5hYqX/FsRlyJNg8p5l3pnWPDzp3xZOlq5vFjHouR9ZnRwUrfNmt2LERxJr9pcPTXY4V1zY0tjmGkNG6SE5LQtP0R37+iIuTWLwQrgCyS1iuc+B8Dh0Q0UtIu1CJcCt22YT6FY1HRLuzOjEARXTwA7sdAj2I/33Qq3d5KIZ8N0Ha7fWoiBILb6F9zFuiLq+V+gBd3tClfif4NIHHYW7R6D5mdm8aIlq/K2znWVojWiN6kIVh7M4I30vRNRs/FJdTEjXDilWkVPYeaUtq7eYwJsdHVsZ6+E2lJ/nNpe9as8Lm6KXxqbrsOzIO2l91EPY6Qy4V7YNTQ
 WIcVbtcK
 Spd4VUjGSZt1So6rny+ON8TxxmEfiYgO6NKtUJxySGTDek/Hfvnv1b877/kqCExlq/y2wcLq8FzUQhTUmIwVH7+khem/qh0M5dMGJ8Xnmi1KkgZZ8KHW8G59jWmqXDB9Qtg07VetZcLtoxnpCdWDuRQmguKi5BlIJ8CKySeTRnSwvteENjATFVGJXY6KlO8PsQwLd7kwqexGB0ZJMR4PPNgws81XEb7F7JT1VNYnjt27iwxGaMS9dlB3f2R1gdXtXjCE8rgbyjKeWHhgKttCB8R7EVlGzU0ZtFebpcTCWPxvplTd9AB8D5w4CKVNHWv6DZ4Zry3Y+IL5/1PMVBnEzwkhldzcVYkKwOpExuRtaLJ2cgeqyNPawifwPVsHq4oydxbfpAAU06Pkord0nVSw1KPpctMhXtSCI7wD+EYd0GT1DSdOxKcYbhTUG3pr0oVlPsxc7PJe9n8hS7RZKXnZp9DbkkwaEy3sRTFzqtT6beCTHedbvnx1kr/DlFsfStdpJkz4p/ZkaDdUdeUNcHqRNRAUG2mDwSbzAq9CQhZF7C6wPlvuMJNE75PGgGQrvauhap8MkxYLB0Ivu5pm06mnaUK6ucnunXVCo0a2n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In commit bfe3d8f6313d ("x86/tlb: Restrict access to tlbstate") some
low-level logic (the important detail here is flush_tlb_info) was hidden
from modules, along with functions associated with that data.

Later, the set of functions defined here changed and there are now a
bunch of flush_tlb_*() functions that do not depend on x86 internals
like flush_tlb_info.

This leads to some build fragility: KVM (which can be a module) cares
about TLB flushing and includes {linux->asm}/mmu_context.h which
includes asm/tlb.h and asm/tlbflush.h. This x86 TLB code expects these
helpers to be defined (e.g. tlb_flush() calls flush_tlb_mm_range()).

Modules probably shouldn't call these helpers - luckily this is already
enforced by the lack of EXPORT_SYMBOL(). Therefore keep things simple
and just expose the declarations anyway to prevent build failures.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/tlbflush.h | 43 +++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0545fe75c3fa1..56cff03b65aa2 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -251,7 +251,6 @@ struct flush_tlb_info {
 	u8			trim_cpumask;
 };
 
-void flush_tlb_local(void);
 void flush_tlb_one_user(unsigned long addr);
 void flush_tlb_one_kernel(unsigned long addr);
 void flush_tlb_multi(const struct cpumask *cpumask,
@@ -325,26 +324,6 @@ static inline void mm_clear_asid_transition(struct mm_struct *mm) { }
 static inline bool mm_in_asid_transition(struct mm_struct *mm) { return false; }
 #endif /* CONFIG_BROADCAST_TLB_FLUSH */
 
-#define flush_tlb_mm(mm)						\
-		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true)
-
-#define flush_tlb_range(vma, start, end)				\
-	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
-			   ((vma)->vm_flags & VM_HUGETLB)		\
-				? huge_page_shift(hstate_vma(vma))	\
-				: PAGE_SHIFT, true)
-
-extern void flush_tlb_all(void);
-extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
-				unsigned long end, unsigned int stride_shift,
-				bool freed_tables);
-extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
-
-static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
-{
-	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
-}
-
 static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
 {
 	bool should_defer = false;
@@ -513,4 +492,26 @@ static inline void __native_tlb_flush_global(unsigned long cr4)
 	native_write_cr4(cr4 ^ X86_CR4_PGE);
 	native_write_cr4(cr4);
 }
+
+#define flush_tlb_mm(mm)						\
+		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true)
+
+#define flush_tlb_range(vma, start, end)				\
+	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
+			   ((vma)->vm_flags & VM_HUGETLB)		\
+				? huge_page_shift(hstate_vma(vma))	\
+				: PAGE_SHIFT, true)
+
+void flush_tlb_local(void);
+extern void flush_tlb_all(void);
+extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned int stride_shift,
+				bool freed_tables);
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+
+static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
+{
+	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
+}
+
 #endif /* _ASM_X86_TLBFLUSH_H */

-- 
2.51.2


