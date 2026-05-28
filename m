Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C9DCD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BCE06B009D; Wed, 27 May 2026 20:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9466F6B009E; Wed, 27 May 2026 20:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835466B009F; Wed, 27 May 2026 20:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6CE6B009D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F2FF1C0574
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:30 +0000 (UTC)
X-FDA: 84814977660.19.9E4D285
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D416C0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=aVvvYYwH;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBsrZvFZCaB+Y/+qvoDfxB0s8ldAO6L08kiidL6oEeI=;
	b=qz0IgTNlNMqndoMhyR0U3Y4uvhREeizLyCMN/ctGvNPyVvyRLuoImxxqmMTgenkAxaeFLF
	qPdxxzRVktPEjySJKlAS6rmW7HJrghxSQvwoeNFKsNGxZguJTbY/UdFNts+CWazLrzRVvh
	aR/yUx8CyuhiTv5QpVe/U8k9deiE4uA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=aVvvYYwH;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928948; a=rsa-sha256;
	cv=none;
	b=66b2KkG7WGZwnww1GboMNjZQY9S6p18oomD9FhAyOOwcZ8aa+kFa+UgMe1IL3v7wRJckCh
	lYJU5elY6+F+FF1AOCPcv6lbhs1L1xvJN+CaGaiEJvwnPBpUEFwIVjJJNLp3zX/c+XIvee
	BMTxh+7bDqCXiGtc4wHIoLVFl9wP08A=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id BFE2E20B7178; Wed, 27 May 2026 17:42:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BFE2E20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928937;
	bh=NBsrZvFZCaB+Y/+qvoDfxB0s8ldAO6L08kiidL6oEeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVvvYYwHjeNot3eIR3oUp6o7Upqmt3WV5LdKAduXaKrJZexICOXvtNvgktsWgX+ZJ
	 utUu36E7dKfzILCi+VELYR8r9Y7mkHMJnwV6BpykT51jf7MOoVXaWiKQy5lyD6ieUx
	 VPZSQEMPfAb90pLP1EyYWFvDqYR2cqaK/TPWiS+I=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 09/20] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
Date: Wed, 27 May 2026 17:41:51 -0700
Message-ID: <20260528004204.1484584-10-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jshzibdniqd75yd45jdcrfwc54hzkrp4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D416C0002
X-HE-Tag: 1779928948-941511
X-HE-Meta: U2FsdGVkX1+QXaAue6dd273BgCKOcHl5UsrJCGYAPTkOoW4hDCnk2Vai/gk821EJv+kUMA2BDIZTZT96o0ffeinUSnv0fqMLdpbMhZLogHprVPEQQ1CYnml+dv+kJYOS5dN+ZzmhIFk2tWtRX+kIe3iqSJvcWqYQJ9GjndEr1Z8wA/rVEuGDJGF36DmzolCAXUsTQtM6by0mn0B3Z3EPsMbKanPF6Bb0cuq7/bsKTwNdzXU0LjjtGv3ZHRJw/HnqVFxXaR0WMLELpm8hLDdbg5agHzi8CiEDMsX5PhnSdg37cEQI15GoVtErM8DgrMS7+yr3JVn0g/omyQZb0PawBcxT1KGmAtnpzODg+1ohKljiNE16jq/LMEb+J7aa3lsb3GZTf4j8yhliPZnLhNtQEWLyuktOY3Kgd+6Jz6QtezXX7JnEixmovC2orVLyxWIClwc602lM+UcAOXmh3DxDK0dLzv/0trHkI0UPNgfrCqkBhjmlEiEFrl/1abXB+jdT+1VsChWdX20iB7iv9T8F6J2IUtnKaKrTCe2DGqi10HSIGtmHTc20ALZW7MiR/mdj0Fh4RcItEPJB1hdEz1CTjQ3CVyTfTMLbLhKXWZMjJaYPoLm3FTOzZkfaBpNMYeeiOBllH13bLJeQ5xKg67XObzBnoW50sPPgPc67eVf+0hxBwV2H36yvxvb4deCegvL0eqH2uDTjWjtZPZzCvxwfYyNJ1S9pjwxY1SfUDqcGPfaSPFljl5ESvr4bp2QAIU33co0KMgcY42sQK74mES8E8KH9hVwcfPrZD86tl1QAIfWJf/HA4HPrlxNCPp+9MtG3EzJNgf+9bHj3lH8IL5SawE02Muwwctfb7ZeBG4D/+cVJ7pf0YMghNJ8ujbyX5puwcQmhAjejvIpSwtGLkd7EVRUQN3k6ruo+wpgBlBJVQdaMAl/4Y/3bKyYASgsABHbNh70cPLsYQw/56cXBQVT
 5wEgJ9wd
 4yT4CRLDRvqaKmeMYuuE3aiMb7BY2nSKX94yrPyhQ68w1gLoKFGZLfZZiuHHEya2ijEb4UBCswdEyxGmynC0+faYcJLSvHjgNaNsGLDh1yUThvXwcjdBbwJ0zn60ZGD9+qRIqaENuwWRYpRIqwp0a8sDdOwQ4OkVIZsf/YTDi2RUbbkvRYGfqIeYSLJ09ah5yP1CWiIn22jNWzgIakixYymtk6gPn+USCYbKi4D5WcIeS7C8wLUIyYSJ5MWWppLeHJs+sKCCQ4HIBSYzlSCWSF7No20p+wc3P83TWHfCOw3961TQcG+5RI0Y+s4GNtmCZ12hk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

In the upcoming commits, the KHO will learn how to discover free blocks
of memory by walking the KHO radix tree. It will then mark those regions
as scratch to allow memory allocation in case scratch runs low.

To differentiate the extended scratch areas from the main scratch areas,
introduce MEMBLOCK_KHO_SCRATCH_EXT. Use it when choosing memblock flags
for allocations during scratch-only. Teach should_skip_region() to check
for both flags before deciding if the region should be skipped.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 include/linux/memblock.h | 10 ++++++++++
 mm/memblock.c            | 41 ++++++++++++++++++++++++++++++++++------
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5afcd99aa8c1..4f535ca4947a 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -51,6 +51,9 @@ extern unsigned long long max_possible_pfn;
  * memory reservations yet, so we get scratch memory from the previous
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
+ * @MEMBLOCK_KHO_SCRATCH_EXT: same as MEMBLOCK_KHO_SCRATCH but was discovered at
+ * boot time by finding gaps in preserved memory instead of being passed from
+ * previous kernel. Does not get passed to the next kernel.
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -61,6 +64,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
+	MEMBLOCK_KHO_SCRATCH_EXT= 0x80, /* extended scratch memory for KHO */
 };
 
 /**
@@ -157,6 +161,7 @@ int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_mark_kho_scratch_ext(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
@@ -304,6 +309,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_SCRATCH;
 }
 
+static inline bool memblock_is_kho_scratch_ext(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_KHO_SCRATCH_EXT;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index 6349c48154f4..6f76a6bb96d6 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -182,7 +182,7 @@ static enum memblock_flags __init_memblock choose_memblock_flags(void)
 {
 	/* skip non-scratch memory for kho early boot allocations */
 	if (kho_scratch_only)
-		return MEMBLOCK_KHO_SCRATCH;
+		return MEMBLOCK_KHO_SCRATCH | MEMBLOCK_KHO_SCRATCH_EXT;
 
 	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
 }
@@ -1180,8 +1180,9 @@ int __init_memblock memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t si
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
- * for allocations during early boot with kexec handover.
+ * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH or
+ * %MEMBLOCK_KHO_SCRATCH_EXT will be considered for allocations during early
+ * boot with kexec handover.
  *
  * Return: 0 on success, -errno on failure.
  */
@@ -1205,6 +1206,23 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_SCRATCH);
 }
 
+/**
+ * memblock_mark_kho_scratch_ext - Mark a memory region as MEMBLOCK_KHO_SCRATCH_EXT.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH or
+ * %MEMBLOCK_KHO_SCRATCH_EXT will be considered for allocations during early
+ * boot with kexec handover.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+__init int memblock_mark_kho_scratch_ext(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_KHO_SCRATCH_EXT);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -1238,10 +1256,20 @@ static bool should_skip_region(struct memblock_type *type,
 
 	/*
 	 * In early alloc during kexec handover, we can only consider
-	 * MEMBLOCK_KHO_SCRATCH regions for the allocations
+	 * MEMBLOCK_KHO_SCRATCH or MEMBLOCK_KHO_SCRATCH_EXT regions for the
+	 * allocations.
 	 */
-	if ((flags & MEMBLOCK_KHO_SCRATCH) && !memblock_is_kho_scratch(m))
-		return true;
+	if (flags & (MEMBLOCK_KHO_SCRATCH | MEMBLOCK_KHO_SCRATCH_EXT)) {
+		bool skip = true;
+
+		if ((flags & MEMBLOCK_KHO_SCRATCH) && memblock_is_kho_scratch(m))
+			skip = false;
+
+		if ((flags & MEMBLOCK_KHO_SCRATCH_EXT) && memblock_is_kho_scratch_ext(m))
+			skip = false;
+
+		return skip;
+	}
 
 	return false;
 }
@@ -2801,6 +2829,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_KHO_SCRATCH_EXT)] = "KHO_SCRATCH_EXT",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


