Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B1FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D616B00A2; Tue,  7 Jul 2026 15:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706076B00A3; Tue,  7 Jul 2026 15:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C166B00A4; Tue,  7 Jul 2026 15:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFC96B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:47:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B64B51C8268
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:46:59 +0000 (UTC)
X-FDA: 84963013758.01.E6E66DC
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id E28C2C000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:46:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=luYZY3a1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453617;
	b=5UnY//7lOVAB4X0ow2isaV+LKHBZY+PpdI28HWBhGU6WI/XslCJ1QDIGl41ugA7Jz0whAe
	viq66AKCL8CONg5e68cPEAfb5OCWcB89bleDZtRxLX7BwD0aZRzo0cXkZXgsR2DY62V1r+
	hcHr0qIFJKvYYHMRQtFYgDkOB0IxSLA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=luYZY3a1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
	b=l8PPZkUTdngYOZO69b/reJgE/BKdskQRVHSmVEdTzsXJK8LLPCwd/9yN77ZaakXUn/Ixs/
	iI0GCcP0C/DohMEZkve954xphA1vAU7bdtujd5zEwCjjnpD5+CpagTQIhWl7FJBXEHlw5Y
	UaO+R2U5y5wcsMYCKD5W0bTUbAcrRPc=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c7cfa17fedso54022895ad.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453617; x=1784058417; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
        b=luYZY3a1GhmhGQTEiRSpasCRIb1tyyiaWeigSIwobbxqRIcwpN8sMZgSxQT9nkJ4vo
         gjEndkMSPS6IGYy3Jo8C+hUKvGpRcbjhk0nlg6eztUXNH48l5C5Ya+pPMRv2SJnl0VZR
         LFO4cUXXS8sKkVaatK0LpDdCn1i/wlXY7O4PUQjsP7b6KSdVY/Cb7Y5txFUiuXRfTN/U
         WbEWKcQ97EvdK+mokfKUcICpp5XnapT9jji1vE56NX9f6j7EzufQjgQcaFQ5+GBOqNAT
         WqSzYZojTx86Z0VEmHG+5j1PufhhYWnCxL1mv2igtRtBg4MYuuyKqTjFzidkqkkv9jnN
         BxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453617; x=1784058417;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
        b=BQzebBU0esHWaQ767HkJKmuTtLXsle/sc+y2j+txhoUPRzZIcIqrz0+S4zaKE99Ax2
         vgXUypcPcWqJkVHLpsmwu0bmS6iDFPT352hyaJzCBLzfa+XuZQb9AnRt1BdvLjOnrD/a
         +a6qcViedUvOQWcVMh8DmJ6Ag64fXdSJf10i7Q2GvEIaCZRl7eU6yUCUXKxk/6ovz4mZ
         k+uYoF/PPOqIxmGUH4XLcUUiu81gtEFrPcgAXedoqZ7ZLl/r9UzpSRzGOyXBFE35cLpl
         0vgH/DfHvwn9DXdY6JXDMHlKJab/EaHLNuXfr+96E46aq9s/gjb5kSJP3Xk0vG4q0s/P
         h2AA==
X-Forwarded-Encrypted: i=1; AHgh+RrG5xL7DV9wINjoGSYFZjH9NDCbfGbWObzWo8YF1w4Iw7pM3IYnDOTNbZOqHaNkyATG0PPY/ilEYQ==@kvack.org
X-Gm-Message-State: AOJu0YwhvvhBLc7Cjfyv2AuAj9fF7Kn+JXp4hubIeWmKod8KNphTb03A
	FMGQUD/d3/mVT51gPzuRI/mo7QWMG/aTt9Pt2p/oOubHyJdG5qkU81dU
X-Gm-Gg: AfdE7ckRs+qeB59g3IETdlP7dGfJ7s6BlofJ1iTyQ3t0HXxXEXTV/mu1pFK3vop8tTw
	WdX8gpr3OysJkodOWHkWmpqNsCRthbktCo9ZX6SCTu54U7YZUXj6eOQimURDsg8hOxpUQlLVDKe
	NdWDl66pUbGvOSnJc3CR/xkU39aEk9YFLaOfRUTunTZAagS4mlGIX7cst+2XDxP7Rw/uWvhJKqf
	p3paBwyRGhWsN8a7Y7Axu7cZ3LqXXa4MBzAI6zI0RqHZ/geh2mm2kQm76dWcg/qeR1/WrbLWM5q
	xoM/D9PLfSTppT5BTaMpL6S+w1HSoNw7f65mYOYJF6hLOXlPgiCu4biYf95uN1xP1hkWYGC0/QU
	tNgEqBWlsMZA1itt/WHHdD4xgzALmPqOTjHUQ4e5+jxHVuHKgTWvD/hiVfWbNsVmQ7v/4nqlEpN
	/9vfoqNj4ZybCPzpyEkGeoqeifADI8IeVwXlTOxBearXKNBEsnHRiD6UkAirg=
X-Received: by 2002:a17:903:3248:b0:2c9:9a19:df with SMTP id d9443c01a7336-2ccbe6289ccmr62105295ad.18.1783453616667;
        Tue, 07 Jul 2026 12:46:56 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1eea1sm17280345ad.46.2026.07.07.12.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:46:56 -0700 (PDT)
Subject: [PATCH v7 1/8] mm/hmm: move page fault handling out of walk callbacks
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Tue, 07 Jul 2026 12:46:54 -0700
Message-ID: <178345361483.660027.16455119612963295072.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E28C2C000B
X-Rspam-User: 
X-Stat-Signature: uahhkmueerby7gtjur3aez6rakt8d7qw
X-Rspamd-Server: rspam03
X-HE-Tag: 1783453617-639042
X-HE-Meta: U2FsdGVkX18S3FizrFTu74ZhUFJLV1Fi+NDy+OotFb/rTgEWMMrHbMeIHDerWO5fwVIERul+PQGzvMPeK/CgQq8CMemeEME+/GztN4P+fEw60FPdoboj1yOzrGoXpaEtQ71f7lxVt1bdcGgsyIZWsiUovB5Z6h4kWWdHy7+BnnAiZ2OHKjiuK+YwTBIjUAlG9Wp+Fw/5NVdr6otlTROQz9rgQzwstgso2qSpcx40JpbLuXwQNLOw4m5eY6NTtDGIRHGBJKsx/11SY0i7PeAueZqVvyVMyshjuBpKAAFGIMHYHYf5xWjhIhAVUxthlc3wdmEWDQh3Rb3d3kRyaA90+1FQW9dbfwW6IzLzTp6D5PYhRt25HU4hXBXNFA8XNLr4f+RNkk+opqPEaCHvbgAqQCpjPFxM/HAtI+nMWro0VTzAWq7rr3GXOJHg9B3VR8wvkk6dwooH5OTKyuFMThJyGqE4UpMtZ9/V2VbYKE1kuKNR72bGRvUgrs+HFS1vg7FXZdjRejmlIt7NkJuzIR+S46VmuIjA5rJoqjVQyH5QRr+tUQMgNsB3UHp7s5nnpwsR730CXCIZBfoopWffy2uR5XZoFd5asiYIcJoPlB9C9uO+DRnFaIpzshuRuaiwldhZzYmtrrHyQFqb7w3COYiRhPZFNwnYggQePvby16KreimNuPDxcIe6OVMKYoMAytAMcBHy9HUOeF+O1ef9gNcx23FxSPtjPxANmJEwkIQfYuLfzT7wwidPk4i7EF1B03e1+oEGJfjikrM9LPm2ljAltsl4Lx1tt85mwuZU3hcoXINSf7TEbCOaiRYTgAQfDbMpdJlvViMNlGh3S/uHiv8MYJ6AgIrreURyMY5xpEJJLd5hhmDbthOz8xDfap9B3oyhO6IFj0xC7gT1ymxoNWBMgL3GlQ9y78EbJv3+E7gUkB2OEzD9UF8CtVvLP86KIC3M1GES2ypLXJ3IcBUK89b
 riolo4rz
 UgzUq4Hd+cMmYvSdJuwV4kD/xfQMKDs6QY86CYh5QFN/1wu1a6Qn7Fjv7DW0MrxgVxl9OI/6hJHIhXVft9HVQbwzFyPgkFW7Gug1bAz8GuXEwQQcJa/3/D8NTLVOwWIrz+FDxO6mq1HbhTIp7TuunGw3C9GAmiHtkoSr9MhtmrUdvcBYrCi0p4z7j5ltOmhKIW/ax7tdxknshPWcM/GRUySwDvOEXFJPU3QJ3ul8qP7MqgOxKVwb02o13PUbVaDepfrGb9SFgix5Gx0NVuRCBpvEIwuxBkEbKLgMwrJLxATGEvUbUjhaxLtWgzmmbF5gKXHQYAFYG+QRpTpiuU+KEQnIkZZzdSSP2oTGzLGo2KkgwTHX1kiNmXAosTCXE2wJNTuncMSOSY5f4BlxzBA3JGlygsth7ZcA9buJSKvETVpxOqIO/vA9YUspxWPI3pccju8wvL50m2+bRXZdbpE/zWlhM32u+cOWGqrF/kA6rTRswha3b05xyo+XGjNeEOw3oB3EB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hmm_range_fault() currently triggers page faults from inside the page-table
walk callbacks: hmm_vma_walk_pmd(), hmm_vma_walk_pud(),
hmm_vma_walk_hugetlb_entry() and the pte-level helper all call
hmm_vma_fault(), which in turn calls handle_mm_fault() while the walker
still holds nested locks.  The pte spinlock is dropped explicitly by each
caller, and the hugetlb path manually drops and retakes
hugetlb_vma_lock_read around the fault to dodge a deadlock against the walk
framework's unconditional unlock.

This layering does not extend cleanly to fault handlers that may release
mmap_lock (VM_FAULT_RETRY, VM_FAULT_COMPLETED). If the lock is dropped
while walk_page_range() is mid-traversal, the VMA can be freed before the
walk framework's matching hugetlb_vma_unlock_read(), turning that unlock
into a use-after-free.

Split the responsibilities the way get_user_pages() does. Walk callbacks
become inspect-only: when they detect a range that needs to be faulted in,
they record it in struct hmm_vma_walk and return a private sentinel
(HMM_FAULT_PENDING). The outer loop in hmm_range_fault() then drops out of
walk_page_range(), invokes a new helper hmm_do_fault() that calls
handle_mm_fault() with only mmap_lock held, and restarts the walk so the
now-present entries are collected into hmm_pfns.

No functional change for existing callers. As a side effect the hugetlb
callback no longer needs the hugetlb_vma_{un}lock_read dance, and every
fault-path exit from the callbacks now releases the pte spinlock on a
single, common path. This refactor is also a precursor for adding an
unlockable variant of hmm_range_fault() in a follow-up patch.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 mm/hmm.c |  118 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 43 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 4f3f627d2b47..2129b1ee4c35 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -33,8 +33,17 @@
 struct hmm_vma_walk {
 	struct hmm_range	*range;
 	unsigned long		last;
+	unsigned long		end;
+	unsigned int		required_fault;
 };
 
+/*
+ * Internal sentinel returned by walk callbacks when they need a page fault.
+ * The callback stores end/required_fault in hmm_vma_walk; the outer loop
+ * consumes the sentinel and never propagates it to the caller.
+ */
+#define HMM_FAULT_PENDING	-EAGAIN
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -60,37 +69,25 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 }
 
 /*
- * hmm_vma_fault() - fault in a range lacking valid pmd or pte(s)
- * @addr: range virtual start address (inclusive)
- * @end: range virtual end address (exclusive)
- * @required_fault: HMM_NEED_* flags
- * @walk: mm_walk structure
- * Return: -EBUSY after page fault, or page fault error
+ * hmm_record_fault() - record a range that needs to be faulted in
  *
- * This function will be called whenever pmd_none() or pte_none() returns true,
- * or whenever there is no page directory covering the virtual address range.
+ * Called by the walk callbacks when they discover that part of the range
+ * needs a page fault.  The callback records what to fault and returns
+ * HMM_FAULT_PENDING; the outer loop in hmm_range_fault() drops back out of
+ * walk_page_range() and invokes handle_mm_fault() from a context where no
+ * page-table or hugetlb_vma_lock is held.
  */
-static int hmm_vma_fault(unsigned long addr, unsigned long end,
-			 unsigned int required_fault, struct mm_walk *walk)
+static int hmm_record_fault(unsigned long addr, unsigned long end,
+			    unsigned int required_fault,
+			    struct mm_walk *walk)
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 
 	WARN_ON_ONCE(!required_fault);
 	hmm_vma_walk->last = addr;
-
-	if (required_fault & HMM_NEED_WRITE_FAULT) {
-		if (!(vma->vm_flags & VM_WRITE))
-			return -EPERM;
-		fault_flags |= FAULT_FLAG_WRITE;
-	}
-
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
-			return -EFAULT;
-	return -EBUSY;
+	hmm_vma_walk->end = end;
+	hmm_vma_walk->required_fault = required_fault;
+	return HMM_FAULT_PENDING;
 }
 
 static unsigned int hmm_pte_need_fault(const struct hmm_vma_walk *hmm_vma_walk,
@@ -174,7 +171,7 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
 	}
 	if (required_fault)
-		return hmm_vma_fault(addr, end, required_fault, walk);
+		return hmm_record_fault(addr, end, required_fault, walk);
 	return hmm_pfns_fill(addr, end, range, 0);
 }
 
@@ -209,7 +206,7 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 	required_fault =
 		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
 	if (required_fault)
-		return hmm_vma_fault(addr, end, required_fault, walk);
+		return hmm_record_fault(addr, end, required_fault, walk);
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
@@ -328,7 +325,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 fault:
 	pte_unmap(ptep);
 	/* Fault any virtual address we were asked to fault */
-	return hmm_vma_fault(addr, end, required_fault, walk);
+	return hmm_record_fault(addr, end, required_fault, walk);
 }
 
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
@@ -371,7 +368,7 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 					      npages, 0);
 	if (required_fault) {
 		if (softleaf_is_device_private(entry))
-			return hmm_vma_fault(addr, end, required_fault, walk);
+			return hmm_record_fault(addr, end, required_fault, walk);
 		else
 			return -EFAULT;
 	}
@@ -517,7 +514,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 						      npages, cpu_flags);
 		if (required_fault) {
 			spin_unlock(ptl);
-			return hmm_vma_fault(addr, end, required_fault, walk);
+			return hmm_record_fault(addr, end, required_fault, walk);
 		}
 
 		pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
@@ -564,21 +561,8 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	required_fault =
 		hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, cpu_flags);
 	if (required_fault) {
-		int ret;
-
 		spin_unlock(ptl);
-		hugetlb_vma_unlock_read(vma);
-		/*
-		 * Avoid deadlock: drop the vma lock before calling
-		 * hmm_vma_fault(), which will itself potentially take and
-		 * drop the vma lock. This is also correct from a
-		 * protection point of view, because there is no further
-		 * use here of either pte or ptl after dropping the vma
-		 * lock.
-		 */
-		ret = hmm_vma_fault(addr, end, required_fault, walk);
-		hugetlb_vma_lock_read(vma);
-		return ret;
+		return hmm_record_fault(addr, end, required_fault, walk);
 	}
 
 	pfn = pte_pfn(entry) + ((start & ~hmask) >> PAGE_SHIFT);
@@ -637,6 +621,44 @@ static const struct mm_walk_ops hmm_walk_ops = {
 	.walk_lock	= PGWALK_RDLOCK,
 };
 
+/*
+ * hmm_do_fault - fault in a range recorded by a walk callback
+ *
+ * Called from the outer loop in hmm_range_fault() after a callback
+ * returned HMM_FAULT_PENDING.  At this point we hold only mmap_lock;
+ * the page-table spinlock and any hugetlb_vma_lock acquired by the walk
+ * framework have already been released by the unwind.
+ *
+ * Returns -EBUSY on success (all pages faulted, caller should re-walk).
+ * Returns a negative errno on failure.
+ */
+static int hmm_do_fault(struct mm_struct *mm,
+			struct hmm_vma_walk *hmm_vma_walk)
+{
+	unsigned long addr = hmm_vma_walk->last;
+	unsigned long end = hmm_vma_walk->end;
+	unsigned int required_fault = hmm_vma_walk->required_fault;
+	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+	struct vm_area_struct *vma;
+
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		return -EFAULT;
+
+	if (required_fault & HMM_NEED_WRITE_FAULT) {
+		if (!(vma->vm_flags & VM_WRITE))
+			return -EPERM;
+		fault_flags |= FAULT_FLAG_WRITE;
+	}
+
+	for (; addr < end; addr += PAGE_SIZE)
+		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
+		    VM_FAULT_ERROR)
+			return -EFAULT;
+
+	return -EBUSY;
+}
+
 /**
  * hmm_range_fault - try to fault some address in a virtual address range
  * @range:	argument structure
@@ -674,6 +696,16 @@ int hmm_range_fault(struct hmm_range *range)
 			return -EBUSY;
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
+		/*
+		 * When HMM_FAULT_PENDING is returned a walk callback
+		 * recorded a range that needs handle_mm_fault();
+		 * hmm_do_fault() runs the fault outside walk_page_range()
+		 * (so no page-table or hugetlb_vma_lock is held) and
+		 * returns -EBUSY so the loop re-walks and picks up the
+		 * now-present entries.
+		 */
+		if (ret == HMM_FAULT_PENDING)
+			ret = hmm_do_fault(mm, &hmm_vma_walk);
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored



