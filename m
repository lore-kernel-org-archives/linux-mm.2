Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA96D4336B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 04:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DEDB6B0008; Thu, 11 Dec 2025 23:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6426B000A; Thu, 11 Dec 2025 23:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC106B000C; Thu, 11 Dec 2025 23:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCCD6B0008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:27:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB39CB8768
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:27:30 +0000 (UTC)
X-FDA: 84209535060.12.49066D5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18207C0003
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:27:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765513649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6U3t8kJga3SBs4c3UV1uCvapZVSDyhagjrrEPqd/kMk=;
	b=eDNZKIYmeRmXiZBgkIyIQc86i+jusR/gY7/9MJrHZ1UaRbmMwXAHKddQu1qdFARx3IlPVo
	JCg9+4yEYvUMqk8/n0RPB4B4To3fIGd2fw27FhAL+Tdi1JkMvUkvM3EZXTtmdfty/sMN3d
	mYZO+UFLm8N0X6bUr/rr7pJrTKmdjRg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765513649; a=rsa-sha256;
	cv=none;
	b=3N7EFIKGzodY3/1vwPc2katA4U+4tCgUWRsK27JfXKLCabdb/eX+uGDF0JxuiJVmSUE0sX
	WJB7ushlQEcnAlj8wIq/MAzHps0s29s8aYo0l0XhSdz5If17mU1v+hyoI6+3ounXeMlEFS
	DObgSrJG+pdoPph41Ogk7iIfeyORWO8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35A821063;
	Thu, 11 Dec 2025 20:27:21 -0800 (PST)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8F0913F762;
	Thu, 11 Dec 2025 20:27:22 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	akpm@linux-foundation.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	cem@kernel.org
Cc: ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	shijie@os.amperecomputing.com,
	yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	npiggin@gmail.com,
	willy@infradead.org,
	david@kernel.org,
	ziy@nvidia.com,
	Dev Jain <dev.jain@arm.com>
Subject: [RESEND RFC PATCH 2/2] arm64/mm: Enable huge-vmalloc by default
Date: Fri, 12 Dec 2025 09:57:01 +0530
Message-Id: <20251212042701.71993-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251212042701.71993-1-dev.jain@arm.com>
References: <20251212042701.71993-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 18207C0003
X-Stat-Signature: 98x3zgnf8rbs4rtrzdws3a4tb4ar5guj
X-Rspam-User: 
X-HE-Tag: 1765513648-401267
X-HE-Meta: U2FsdGVkX1+w2KezD3oOv66nex3jy6O4g8vlPbUk+HC7QiYflgv56UQUtIng15a5x4XQl/hF0nDrH8T+mtgHzVrjGg6fQWVFo9TxPElj/XwfJCowthIvw3OxLYvroyLyTPfOWdv7h/62oQTSJYjaZkYCwgDpJOGNLHx+31JSc2T/gmslQa7MJZUVS/2IgEQ0GpJ4NhZaoDCuXJg9UC+5bfsvoCKZf+Kw4TezXSLzrsWMzFq6vYDFaST3dqY99q5n3Kogak9JZpN6BEQ+MIGUkHTKG2s/fvTJFoq4pWb9GrwasmplgHOTMZb8xz3n7JK/RKHiGd87TMEA/L3dQKVrohUw+Env7TXvy6fzl2uqOapb5mn0lwr7Vtx8krEeTDMpN4Mcppcw+WOB5lnLt1OozADdQ84G/Afu1eHsJnitgDWsLKobTGXFWRqhoI6ENjJO4itQwkzfXRPledSwEYiz3WWwQqfmdGokIFLLBUk3ItBw2qxXfOMNPnTp8dn/sMrkeWqvlkmcbG5Wbp4LKyFj93jIHrFyhHNbg1sFjXTyZ1jv/jWbHXDSuAeWlwi6KJh39t0/Vw4PvKQnOaFGNUOhhLD2S2bN0/BNdA/sqM/+FLeMdSFuWxkRCeh/sY5pYYx2bCzG7TmOrjaxnepW/c+b99ovLZR7FsMMWiFRO0QNJ4xhcoEn/49sdL4fOsU7ww7De5dhV74/5ybshRhOXAZVmtuIwWIscNu0f64Sjx5l+ge11shpbzg0iMnQmEPRaYxQJZl/rkK1FzjMbGUAmloHSGXWldkomaqSqyTZrjslCWq0tIeZV0/M6oMK8bSBsasWdGl1BBuTx/5xUH3rde9565+//dP6e6Igr3VGa9tcn58IEIZeScnSQAScUU2EdIZSkH3oMBJ7RVfm9GTBWmzmFAfP/mW7CN6+8n97VIomXt9GIY4ADCNk0md+iUarFwCaAb+mUrLu5XDxdaOPhPD
 iTMCENw0
 EGreIhOGnQK/mhLpra9Vr5D5nEiL9NlH+M6qkwOsM4t/lb4ZDxpIGUMWApArGmi0KHkp01x8ZniUE5Jpotfju0rIHVvpTUKlgdEZ1rrVn4A6y3RXE5faag8Lx9IqW8R/uHKyy5mG2VD5qs+I719tXVbtVtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For BBML2-noabort arm64 systems, enable vmalloc cont mappings and PMD
mappings by default.

There is benefit to be gained in any code path which maps >= 16 pages using
vmalloc, since any usage of that mapping will now come with reduced TLB
pressure.

Currently, I am not being able to produce a reliable statistically
significant improvement for the benchmarks which we have. I am optimistic
that xfs benchmarks should give some benefit.

Upon running test_vmalloc.sh, this series produces an optimization and
some regressions. I conclude that we should ignore the results of this
testsuite. I explain the regression in the long_busy_list_alloc_test below:
upon running ./test_vmalloc.sh run_test_mask=4 nr_threads=1, a regression
of approx 17% is observed (which increases to 31% if we do *not* apply the
previous patch ("mm/vmalloc: Do not align size to huge size")).

The long_busy_list_alloc_test first maps a lot of single pages to fragment
the vmalloc space. Then, it does the following in a loop: map 100 pages,
map a single page, then vfree both of them. My investigation reveals that
the majority of time is *not* spent in finding a free space in the vmalloc
region (which is exactly the time which the setup of this particular
test wants to increase), but in the interaction with the physical memory
allocator.

It turns out that mapping 100 pages in a contiguous way is *faster* than
bulk mapping 100 single pages. The regression is actually carried by
vfree(). When we contpte map 100 pages, we get 6 * 16 = 96 pages from
the free lists of the buddy allocator, and not the pcp lists. Then, vmalloc
subsystem splits this page into individual pages because drivers can
operate on individual pages, messing up the refcounts. As a result, vfree
frees these pages as single 4k pages, freeing them into the pcp lists.
Thus, now we have got a behaviour of taking from the freelists of the
buddy, and freeing into the pcp lists, which forces pcp draining into the
freelists. By playing with the following code in mm/page_alloc.c:

	high = nr_pcp_high(pcp, zone, batch, free_high);
	if (pcp->count < high)
		return;
The time taken by the test is highly sensitive to the value returned by
nr_pcp_high (although, increasing the value of high does not reduce the
regression).

Summarizing, the regression is due to messing up the state of the buddy
system by rapidly stealing from the freelists and not giving back to them.

If we insert an msleep(1) just before we vfree() both the regions, the
regression reduces. If we reduce the number of iterations in the test, the
regression is gone. This proves that the regression is due to the unnatural
behaviour of the test - it allocates memory, does absolutely nothing with
that memory, and releases it. No workload is expected to map memory without
actually utilizing it for some time. The time between vmalloc() and vfree()
will give time for the buddy to stabilize, and the regression is
eliminated.

The optimization is observed in fix_size_alloc_test with nr_pages = 512,
because both vmalloc() and vfree() will now operate to and from the pcp.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/include/asm/vmalloc.h | 6 ++++++
 arch/arm64/mm/pageattr.c         | 4 +---
 include/linux/vmalloc.h          | 7 +++++++
 mm/vmalloc.c                     | 5 ++++-
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b3..c72ae9bd7360 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -6,6 +6,12 @@
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 
+#define arch_wants_vmalloc_huge_always arch_wants_vmalloc_huge_always
+static inline bool arch_wants_vmalloc_huge_always(void)
+{
+	return system_supports_bbml2_noabort();
+}
+
 #define arch_vmap_pud_supported arch_vmap_pud_supported
 static inline bool arch_vmap_pud_supported(pgprot_t prot)
 {
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index f0e784b963e6..eddbc202ffdd 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -163,8 +163,6 @@ static int change_memory_common(unsigned long addr, int numpages,
 	 * we are operating on does not result in such splitting.
 	 *
 	 * Let's restrict ourselves to mappings created by vmalloc (or vmap).
-	 * Disallow VM_ALLOW_HUGE_VMAP mappings to guarantee that only page
-	 * mappings are updated and splitting is never needed.
 	 *
 	 * So check whether the [addr, addr + size) interval is entirely
 	 * covered by precisely one VM area that has the VM_ALLOC flag set.
@@ -172,7 +170,7 @@ static int change_memory_common(unsigned long addr, int numpages,
 	area = find_vm_area((void *)addr);
 	if (!area ||
 	    end > (unsigned long)kasan_reset_tag(area->addr) + area->size ||
-	    ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) != VM_ALLOC))
+	    ((area->flags & VM_ALLOC) != VM_ALLOC))
 		return -EINVAL;
 
 	if (!numpages)
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index e8e94f90d686..59bd6ce96706 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -88,6 +88,13 @@ struct vmap_area {
 	unsigned long flags; /* mark type of vm_map_ram area */
 };
 
+#ifndef arch_wants_vmalloc_huge_always
+static inline bool arch_wants_vmalloc_huge_always(void)
+{
+	return false;
+}
+#endif
+
 /* archs that select HAVE_ARCH_HUGE_VMAP should override one or more of these */
 #ifndef arch_vmap_p4d_supported
 static inline bool arch_vmap_p4d_supported(pgprot_t prot)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 389225a6f7ef..88004e803adc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4011,7 +4011,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		return NULL;
 	}
 
-	if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
+	if (vmap_allow_huge && ((arch_wants_vmalloc_huge_always()) || (vm_flags & VM_ALLOW_HUGE_VMAP))) {
 		/*
 		 * Try huge pages. Only try for PAGE_KERNEL allocations,
 		 * others like modules don't yet expect huge pages in
@@ -4025,6 +4025,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 			shift = arch_vmap_pte_supported_shift(size);
 
 		align = max(original_align, 1UL << shift);
+
+		/* If arch wants huge by default, set flag unconditionally */
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
 	}
 
 again:
-- 
2.30.2


