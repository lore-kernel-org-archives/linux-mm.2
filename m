Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6070C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8336B00C9; Mon, 21 Sep 2026 07:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0726C6B0106; Mon, 21 Sep 2026 07:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C346B0107; Mon, 21 Sep 2026 07:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B13386B00C9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25545C013D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:01 +0000 (UTC)
X-FDA: 85237477122.05.62AD6B7
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6421440006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:00:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V1ziUrnT;
	spf=pass (imf01.hostedemail.com: domain of 3aQ6xagoKCKYbJUTTKLUXZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3aQ6xagoKCKYbJUTTKLUXZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988459;
	b=61Jh23sgEVa76BMTydSy4XlHqmyXyhMf0TvE8cpWSQ+06hr/9Ak2Mo3+k/HNs/AvdFH47/
	mpWlUAAI5Hi5bbSfKfF4aMqMvBkMDAlzssa+YJj4V79QsmJf3rsjDTgFAMvjzazWGheL0x
	RuRdrZ5TW2dyS391IFSHSnRePVz319M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V1ziUrnT;
	spf=pass (imf01.hostedemail.com: domain of 3aQ6xagoKCKYbJUTTKLUXZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3aQ6xagoKCKYbJUTTKLUXZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IM/pFcIIS9AfJIvDjZJlWaiz8Fy5HD+1VXbC/YTcKBU=;
	b=OuzfnyIgf83SNB3I7QAcSqyegGVHORJognzlQ/dOyIHNzsr19Txx/7GmSbwVcLRzyWZElo
	b7U5plEVsqSsVWO2NGDZqwdZLQjuN/cf/RzEP6jgqXaa1y006kFOUgaMJleyPz5pWSDQ4O
	JIZUv86ftmTb1PFG7bEzU0wAuaBCCIc=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e661c6440so15470625e9.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988458; x=1790593258; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IM/pFcIIS9AfJIvDjZJlWaiz8Fy5HD+1VXbC/YTcKBU=;
        b=V1ziUrnT1IikPbHY32d5GxIqI43QaLKT6L2XOckBJIdrVBySE3RrQB3IgMwfpHTMtk
         eGx4zbDr28xbjFODHTj75owofSe/ai1zsEPR1usqDNPQrnypUO6t4+XubPwY/fSphm61
         +x1cZ+qzziLjZkToViAVvKN0qqLKmHRC5pT+6sOJysgirHMqt0WKvFkM71UWOQhRQDbV
         s7PHGlYUQYTrNQ4hGNXdgqk+8kJy4QZczjYH7wvP4Hvl8mGSGhETD0/gs8KNI4H5V2Ep
         IOpr9of9XB//VFEiq8q8H0CkoWLCZNRq5H1iHBHsf2hG7k7P40E9CwbQMDumd8I/qkES
         O9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988458; x=1790593258;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IM/pFcIIS9AfJIvDjZJlWaiz8Fy5HD+1VXbC/YTcKBU=;
        b=S8wEKW4MdqNMS9tznREG1sQqMAuatx/f7AlOqk5g6PLPXagjzwscIJQ3UNoodCyMeq
         BGFy786PpJ/ElE+fhkY6EuZNttO71WdeDuq18Qhwbszh++3pQ7dtcJ9usxcFDpb76wyr
         YWISyN83cGdBTz1aD/dm1lq2kIaoJl6yNu8psEymhXdn4ZSl45IVhuM6zuWaySde0/xq
         rwVti6Em9StjJ2R83jux2OfgHW5nr3BZuVi1qZsPCNejcn5W+WI9OrSbMvSrAb1H8iD6
         fuJ0TuQIJU8Q4eczsCwYYMrSQhC6k70a6xvm5E692kZTdJ6rx0aCukfwCwt87O3R7dvG
         Y5Zw==
X-Forwarded-Encrypted: i=1; AKwUvBxlwkUUDU3WkMtMexU3E0fvleALYJM7UrQQEA5ixxnYrXxHK3Ey6GwLUfVGbDUXLlMLkEt1VEZaXg==@kvack.org
X-Gm-Message-State: AFuF++lNJ8gmbfCKW4h/lbKbgiRbsQG0GTVdfQt34Lajo+OPOFYgbh22
	SBX6Bm9oLXTTS1mylzvafBAIvhK8N7TsSVSWGzK6jVcklYcIM3aVYFtGK+cAtEkUucteHHbNnH6
	6QWIL2BREyfUhu3wgLSseQw==
X-Received: from wmcn17-n2.prod.google.com ([2002:a05:600c:c0d1:20b0:49e:8399:b77d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b2a:b0:49e:6861:50f7 with SMTP id 5b1f17b1804b1-49fc5687df8mr141949475e9.5.1789988457579;
 Mon, 21 Sep 2026 04:00:57 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:43 +0100
In-Reply-To: <20260921110050.3977591-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260921110050.3977591-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-2-vdonnefort@google.com>
Subject: [PATCH v2 1/8] memblock: Introduce MEMBLOCK_PTEMAP
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6421440006
X-Stat-Signature: n5ecxk3u6srezr3dbfa8mwueu446s73g
X-HE-Tag: 1789988459-352396
X-HE-Meta: U2FsdGVkX1/u6+Po0BjeoumZmkt/1U9ZsvpgFge3B6NDM2JN/xwbj2JaYuDqw1rTlWuR0iyKvwop3vH6HzVBjJUzzzcQWofJz399iVX+TUomVnC2TdmxNUeh70W9stVmNU1QsrRJljUbj/+wEAvsLCxaKWdQaF60hsGTYI578Jh7tMh07DB5ATpj8fd2Ihd6faqsTey730+h+PWuZetbKb+biX+5gxoBxK9IuUloG1YNo/a3JynqqVcAbF5ezYeY5LGTZImIYS9pMcV4JUgIl6VqiDm4ce9rMRFU6DQnBvmbpUOCHXjq0lO55jU1nDdmT9O75UfrNgAyl+nI5xs+K4L9YrOI4y65IKHZOWLOht172OHMnuWkl9/RU9ZEGXG0PsITo7vy23uI6iFvucS8UAoy0Rgk9hEFdv+vcZIEbGo6KGWGAn2I1J4M2x9bk6GdZw2aFRhWGtnLjhh7kevz61eYQXZ2Rr3lbc1002k7lJChKWxHpeCUS+p2A2Oi3xtKOrg2fd4uU2P2w0MAjZc4vgsl2WDtGfHWYzY9IP/dEzp0zYqJ2nV4lzZdlf1Z0i+QTgTi82Nj5d2RMtwOJAGgAr1/Fe+oQFciPHE3JNw2aJBlCJ4oc0jPaWVHYrSttOq+nRa32XXuRfQ7TglOpDIOSqE4uQl8zALGQ0gfJIEtkUPrD1lqLylDFenBv7bU36G+7H2KkuAlmhzJJuiuub38+9F3OHVJxw0ZE3lm/uLecHLC4WFTIAkhu7f0x9lzwv4nrNfUcvc/v5Wby3Gi9ZWSzXUeK5PylfyRGw+f6yqZjvlPD3n5lt9R12zzSGY+pL4Ky5i6jEu2Q0BPA3557PEL0r6n8V00P9G96RdfuGf+IwLShbXAxAurgadzSL/03pRK/PdRrcJdNN5q6p6CpGuf3Qtl5EGJtdTtbWWGmy2jsJw7myT3L/fEhMW14Y99ylwkhNnQqAMwoSRT2DSJ+g+
 wLMaQ3F3
 ToU41LvU1N36PV1CcpJl3w/bI1MSbsCCcPN/qb8b+133d/LSWRtRkGbNpjVninFRH4Q5E+0gFVhMFj6O6yH9+2u1h4Klh2M3sesnAlE4JqMJl5x7YFXdw996ooQWElELi5Nf/x07wsMw1xAIVZfD8jyJYtKWwKONSuj7WManHZ4kGTI8akIFoFf/FrOJ4DiMd5Y3J1oxH13EQKwio6hj8OJ0W8p6fi2qVQ72OwmPEXjR7gkw28RREYqXmbmWMBVzayeEtardtZ5++BcH0i/BET8N4wUQtO9BFuMIMHVsvrekic8WGCNkwiWpQUu4sUAznfjQ0L+dLgNok1QzcVS2WNIjAhoHugHIbDY0ijqskuXoOaPkZ3OPzi2+8y8AsNuTrzt1D71UUeQNz0hu2iB4JrVlUFnH39/lBWfknZBq8zecAe0sfgAfHPRUydTgw5vfZP0MwfXny8AudsT+LR8sRZCWbqPa4x93m4GZ37M0jgiyZEOYw/nwWnXj5E+IgZT/nDak3x0X0YIHe2R3sDxjUIGghcwE1pdS27aHpY16PdH+MB7r3hgfOZNbv6c/QvNZ46rzgTyz1PfbEy6routeGLwIctIZQsIydGKJ8aoGLyAF9X9jOju9lBpMc/bxquqlcasQdnLk+f5oD6wFsJvcd0+HIRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Keeping PTE-level mappings is interesting on some architectures as it
allows mapping/unmapping pages from the kernel direct map without the
risk of splitting blocks which, under the break-before-make rule, may
trigger page-faults the kernel can't handle.

However, mapping the entire direct map at PTE-level is costly. So
instead, create a new memblock flag MEMBLOCK_PTEMAP to selectively apply
a PTE-level mapping.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 include/linux/memblock.h | 18 ++++++++++++++++++
 mm/memblock.c            | 30 ++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index aa845f488327..13263055996d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,7 @@ extern unsigned long long max_possible_pfn;
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_PTEMAP: memory region to be mapped using PTE-level mapping
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +64,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_PTEMAP		= 0x100,/* PTE-level mapping */
 };
 
 /**
@@ -160,6 +162,8 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_mark_ptemap(phys_addr_t base, phys_addr_t size);
+int memblock_clear_ptemap(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 
@@ -285,8 +289,16 @@ static inline bool memblock_is_mirror(struct memblock_region *m)
 	return m->flags & MEMBLOCK_MIRROR;
 }
 
+static inline void memblock_warn_invalid_map_flags(struct memblock_region *m)
+{
+	enum memblock_flags map_flags = MEMBLOCK_NOMAP | MEMBLOCK_PTEMAP;
+
+	WARN_ON_ONCE((m->flags & map_flags) == map_flags);
+}
+
 static inline bool memblock_is_nomap(struct memblock_region *m)
 {
+	memblock_warn_invalid_map_flags(m);
 	return m->flags & MEMBLOCK_NOMAP;
 }
 
@@ -305,6 +317,12 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_SCRATCH;
 }
 
+static inline bool memblock_is_ptemap(struct memblock_region *m)
+{
+	memblock_warn_invalid_map_flags(m);
+	return m->flags & MEMBLOCK_PTEMAP;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index ea0de4b5f356..8a87d4d2516d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1204,6 +1204,35 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_SCRATCH);
 }
 
+/**
+ * memblock_mark_ptemap - Mark a memory region with flag MEMBLOCK_PTEMAP.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * If supported by the architecture, such region is mapped using PTE-level
+ * mappings in the kernel direct map.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_ptemap(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_PTEMAP);
+}
+
+/**
+ * memblock_clear_ptemap - Clear flag MEMBLOCK_PTEMAP for a specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_clear_ptemap(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 0,
+				    MEMBLOCK_PTEMAP);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2880,6 +2909,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_PTEMAP)] = "PTEMAP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.55.0.1082.g2b9226bbc0-goog


