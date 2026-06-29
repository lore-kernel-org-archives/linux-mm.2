Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DEEC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116816B00D3; Mon, 29 Jun 2026 17:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED676B00DB; Mon, 29 Jun 2026 17:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20516B00DC; Mon, 29 Jun 2026 17:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC16C6B00D3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:47:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43FFB167882
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:47:19 +0000 (UTC)
X-FDA: 84934286598.26.F628434
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 757EE16000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:47:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b="VQtqbM/H";
	spf=pass (imf08.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.180 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782769637;
	b=NSc1eImD5TpEflR2s+Y6ICO3CZ7t5wcOjs4a9UaZEhMUo4FNoHvkr7Az/ObTwvwcXIGSm2
	WJAF2I8v7GqtMBnxGBStYhGIuJBFNgLAjwK1Dv6GZoLOtllh6RBLnMX+PeX1wo7GJX1744
	K3MAEFzvRTSqyzWkNvQ3psNzV9Ihd84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782769637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BdIjkiFaOfGY07XYoiVOjCOSv8Q05CUjEKu6WlWNo1A=;
	b=XaZPHYp/fgvaBeTB8ivGRVjpKIBzkGVQBFapor0b2PbCvqHdvFbS4Id2EQwoEinEhN9VzK
	toWqqyNWDaJi5Rfdtm/G5CyE63Mz5hI+W8U1tbE36ViqGeadCBxG2Wjfq2e2Ru2RQYBW5j
	TcxF+wunPliyKWpjV0JhN9DCnZGrwhA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b="VQtqbM/H";
	spf=pass (imf08.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.180 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8478fe07f0fso991555b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782769636; x=1783374436; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BdIjkiFaOfGY07XYoiVOjCOSv8Q05CUjEKu6WlWNo1A=;
        b=VQtqbM/HAqKQI64ageoIKqVz+AN7xZWvfz9oO8DEDU2nAK8OJpdbcFrQDJrGDi9XYj
         n51x32pgs/I3iqsFIfif3zuZZkKslKLAy1Azq1HRl+oKgQnNzbcTeBHoPo7nbYD30iH9
         LED9KWYV7MhvLHoaUbNO3SG5g5TYA/NuuLeIfQgW8TFTozP/TUpj0X14NW/aUQxMfCL9
         2CtYl/SS12yKA24Law+MtVOVaNZJaoKtT3E2MZAIzF9Q34CR4WQyckqxR0JXbFQ/vVX/
         fgxs61jAd75fRURlZ9UyWQCjQsOqeDCKtlUVxXJVhAxvWXby8WtcG7RSPub/A0VvFMOb
         M9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782769636; x=1783374436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdIjkiFaOfGY07XYoiVOjCOSv8Q05CUjEKu6WlWNo1A=;
        b=HedhoNcdlxVf93PvN4GVxkjU8rHh/L1bl5RCFRK3PFVD0prUiI4pYS/7d0i96Tpoy9
         zlwpmS/Es3WBu+X2ovI1TubvEmYl/7/jJSqk7e+uG7DNxMtPKXCs9WqEJMs/9xxD2wQB
         LXgjnQyBVRl7bLGSu1zmOWDrPkmLI+/vWoT2tpZga761iJaBUY6znE50ECpQEFYp8oVq
         xpuDGwgZbRRkyRuecNcg7jVBZlXEJ7Z0Iiv7ZOxTvbxEsm0gnqBbjrvbAI+VV90D6uab
         zWTg1oKSrDwwjvEpJ8qah9WqzW4mPKMTWCMMDQ76QrOfgXw6b6GqVw+FLk0iOP0zzRlT
         Rqkw==
X-Forwarded-Encrypted: i=1; AHgh+RqrCa1evtIV9RaVHq4U4vKUjB4InkBMHTK4UrNUOzxYCZwWp7sYqaCXP06uMdE2hghNq1cbHSPR8A==@kvack.org
X-Gm-Message-State: AOJu0YxnNod+Sq3VuRzvDHRA+chXdcqunrYTWNLXATwV6fPn5I37A+Bl
	SgLE+Gy9Koi3Qsl4rfH+sHhJNkCoYk43fUJboF+9rSIpjBYMk/eh+SJLNcWCr7YDEA==
X-Gm-Gg: AfdE7cnlDOFIVYPk2SFF5dfRG9hBpIcnpDWvJFyMuJGcmq8E2k2Rk3STSqDZYifxMU7
	aj9p+dbSrHy8cwAjW/OzIzrblHrH7Kd/NJVmYGPjaEbnc00iiJjGR+YkmLQ7dT8B252uFfiAn6G
	73WVWsfHBM6fqX0x3QLR8xJZDZsXEBy2JKdE9SWqEuWVrzej5giOVG/G0EOKu9unNtZyqdUqwSY
	M1mrocL91kdySBsoWN4pcz+68/99zVSGmm/dBMdvN0A4hYYDTBAFQN9EabFEdlIMzwynthSp3Jx
	U/RZXsEE5RKHcXOd6F0zg7CGkb0OXRceogXJpxNIib6yLXpIOc7euFLPl51OBQOOHMHTtK9X1xp
	WT1f2OdE3rtKgvfpq0nBXZDgu/4s6XKtrYN9bVW4Qoy/kNXHlNlYafBLIOJQUm/t4tD5zuBFYhA
	==
X-Received: by 2002:aa7:9a83:0:b0:847:82db:9046 with SMTP id d2e1a72fcca58-8479f1698a3mr736747b3a.26.1782769636217;
        Mon, 29 Jun 2026 14:47:16 -0700 (PDT)
Received: from p1.. ([2607:fb91:151e:4b96:1640:8d7c:ffc5:b8d9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8479ff8c781sm436430b3a.9.2026.06.29.14.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 14:47:15 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-hardening@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jennifer Miller <jmill@asu.edu>,
	Tiffany Bao <tbao@asu.edu>,
	Ruoyu Wang <fishw@asu.edu>,
	Adam Doupe <doupe@asu.edu>,
	Kyle Zeng <zengyhkyle@asu.edu>,
	Yan Shoshitaishvili <yans@asu.edu>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based stack pivot
Date: Mon, 29 Jun 2026 14:47:12 -0700
Message-ID: <20260629214712.1198680-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z13hr76n65mtzsqp77mwcrkhr5f8r17p
X-Rspamd-Queue-Id: 757EE16000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782769637-579822
X-HE-Meta: U2FsdGVkX18U8lQH3Fw3UmVZSBvweAhYcw+2OhIyO4zmjrzpxDKCeoVVP63CZ0KCCNskoVHROaTCDYk8BrWUxTZyV9heCP0/XOXTiSWy6v7hmpqVoaAt+nM46x+7DaBOsHzgSX0JEsaLIFHdKl6LXWZeRXZew2c8oVajXf+0IqtGqWcecl0MxktKaisJYl61POieH5i9CV2jN0FJLAryeS0xEDDjyBSrk+Pjkpp0GmOG01ez0GZYb+H3FGOq9oZA3rwpDNoxIkuLn0LHotDjXWeTWU0uoj/nkLWSkN8PUUTWP67TEEujRi6nHWgvLq7gRRs55tyOp9gH5bmGxzjkSA3PJrQlA0ZtndYHFQJWt61NH9PozOPUdnFveAsEKIExKr5xncNNt5jjjQ7bGTlF73NMV1vuQLznwRGo6ctFLrLS98qnjg/z63MmENg3AJ0hnnZY60QZtqp5EVUAQ9YB7xZegpkk8Jbodi62WjP7Nx6j2pqA8pqP5XCxTRp1pl1Xm91XOFyuRy2Q0EEFn/cMumQCijEv3aBaUXOExt+G0x2qRmmfhKkFXdN9dD7VVBR+eGiLS4ClV4t7fnOTdggs/yymASV0mpwXXaUZbdMeoQwQs/4wdAhLD7AiSNuzKHJVLopUSntKn5T/4yTopFcUDPpc02dq59+60oQl5SFJOg5sLScXa/A24xSr6F639gTjG0fQNN56HopJ1nmg999TY7nlD5UlqzTGoq0sthUm155JkQt4wEY0HZHC9tgiDWbW0jfKxQSn4VOdgjz3AnvKtGtLdDq9IKzh813a04EQViz8gJHBkPtXMf3RsktFSAXHU+0+9CXzqSfiLJasKPNumcvQUtqP0gqt97PAKdET/nZu7nh2Q0Q6RonfwLo7YKNrpNuXdAPNNGqh4pi4mFxWUnmDoLhunu9wfp9Q7PsjyXnGkvtSIV7ECx3/5jk3K1cbgwu6uqdd969B1nCbSxq
 0/WZ3Qii
 1r8tGTxEsUD4zJFAn9FIXn+yrLXssYKOrzOqDXnKll6FlkwzNzKMfMmh7CUtO6VFeGjX+w171yVD7GXZWfEz45iurtU+9mHbV+MunTiASqdz5JMW9uBp2q1/FsdA3mA94fbycEuI5p1Z+HvgVKXkeZt0za2jaSg47UNP3Fpcxomzz03rqLgphrCtrfY1te15SPSf5yCfPUSqW/3EBuwm9saVnn9hNmpXQ36YvoGRq3PLfUGtUojtsEyM5eBRtKrWgUlml+aZg8T2162E+AjOeXQ3IAiGkiMw0nGZBYYveCF/Dd7UoeQWB9IfHVewtuoks1QfiqHdKUK6JY1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With CONFIG_VMAP_STACK, kernel stacks are allocated in the vmalloc area,
which an unprivileged user can surround with attacker-controlled data by
spraying vmap allocations adjacent to a target stack (for example via
XDP_UMEM_REG, though other vmalloc spray paths work too). Today each
guarded vmalloc allocation is followed by a single unmapped guard page.

A single guard page is not enough to contain the x86_64 ENTER
instruction used as a one-instruction stack pivot. ENTER imm16, imm8
builds a stack frame and lowers RSP by:

	imm16 + 8 * (L + 1),  L = imm8 & 0x1f

imm16 is an unsigned 16-bit operand (ENTER never raises RSP), and L is
in [0, 31], so the maximum displacement of a single ENTER is:

	0xffff + 8 * 0x20 = 0x100ff bytes

That is more than enough to step off the current stack, across the
one-page guard, and into the adjacent sprayed pages. When those pages
contain a return sled feeding a ROP chain, reaching any ENTER gadget
(opcode 0xc8, abundant as both intended and unintended gadgets) turns a
control-flow hijack into full ROP execution without any register control
at the hijack site, making it a one-gadget-style primitive that
significantly eases exploitation. The pivot happens after the control
transfer, so it is not constrained by CFI (kCFI/FineIBT).

Widen the guard region from one page to VMAP_GUARD_PAGES (0x11 pages,
0x11000 bytes), which is the smallest whole-page span exceeding the
0x100ff-byte maximum single-ENTER pivot. A pivot off the top of the
stack now lands in the unmapped guard and faults, instead of in mapped,
attacker-controlled memory. RANDOMIZE_KSTACK_OFFSET only perturbs RSP by
a sub-page amount, so it does not change the required width.

Introduce a VMAP_GUARD_PAGES knob that defaults to a single page (no
change for current architectures) and can be overridden per arch via
asm/vmalloc.h, and set it to 0x11 on x86_64. This is deliberately scoped
to x86_64: the 0x100ff bound is a property of the ENTER opcode, and ENTER
is also a one-byte opcode (0xc8) that appears as abundant unintended
gadgets. Other architectures (e.g. arm64) have no equivalent
single-instruction, immediate-controlled pivot reachable as an unaligned
unintended gadget, so they keep the one-page guard and pay no cost.

The override is gated on CONFIG_X86_64 rather than applying to all of x86:
VMAP_STACK is selected only on x86_64, so 32-bit kernel stacks are not in
the vmalloc area and the technique does not apply there. 32-bit x86 also
has a far smaller vmalloc window, where widening every guarded area by 16
pages would needlessly pressure the address space.

The guard pages are never populated, so there is no extra physical
memory and no additional page-table population beyond the larger virtual
span; the cost is virtual address space and vmap_area bookkeeping, which
is negligible against the 64-bit vmalloc window. get_vm_area_size() is
adjusted by the same VMAP_GUARD_SIZE so the usable size reported to
callers is unchanged.

On x86 this widens the guard for all guarded vmap areas, not only thread
stacks. ret2enter targets the stack specifically, so a narrower
alternative is to apply the wider guard only on the thread-stack
allocation path via a dedicated VM_ flag; we kept the change in the
common path as defense in depth for any vmalloc-adjacent pivot target,
but are happy to scope it to stacks if maintainers prefer.

While widening the guard, also mark percpu vmap areas VM_NO_GUARD.
pcpu_get_vm_areas() and pcpu_page_first_chunk() size each area exactly and
reserve no guard, so get_vm_area_size() would subtract a guard that was
never added and underflow if an area were smaller than the guard. This is
a latent correctness fix only: on x86_64 percpu areas are megabyte-scale,
far larger than the guard.

Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Jennifer Miller <jmill@asu.edu>
---
v2: VM_NO_GUARD for percpu vmap areas

 arch/x86/include/asm/vmalloc.h | 21 +++++++++++++++++++++
 include/linux/vmalloc.h        | 16 ++++++++++++++--
 mm/percpu.c                    |  2 +-
 mm/vmalloc.c                   |  4 ++--
 4 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/vmalloc.h b/arch/x86/include/asm/vmalloc.h
index 49ce331f3ac6..2c341f398227 100644
--- a/arch/x86/include/asm/vmalloc.h
+++ b/arch/x86/include/asm/vmalloc.h
@@ -5,6 +5,27 @@
 #include <asm/page.h>
 #include <asm/pgtable_areas.h>
 
+/*
+ * The x86 ENTER instruction can be used as a one-instruction stack pivot:
+ * ENTER imm16, imm8 lowers RSP by imm16 + 8 * (L + 1), L = imm8 & 0x1f.
+ * imm16 is an unsigned 16-bit operand (ENTER never raises RSP) and L is in
+ * [0, 31], so a single ENTER can lower RSP by at most
+ * 0xffff + 8 * 0x20 = 0x100ff bytes. With CONFIG_VMAP_STACK the kernel
+ * stack lives in the vmalloc area, where an unprivileged user can spray
+ * adjacent allocations; a single-page guard is too small to contain such a
+ * pivot. Use 0x11 guard pages (0x11000 bytes), the smallest whole-page
+ * span exceeding 0x100ff, so the pivot faults in the guard instead of
+ * landing in attacker-controlled memory.
+ *
+ * Restrict this to 64-bit: VMAP_STACK is selected only on x86_64, so 32-bit
+ * kernel stacks are not in the vmalloc area and the technique does not apply.
+ * 32-bit also has a far smaller vmalloc window, where a 16-page-per-area
+ * widening would needlessly pressure the address space.
+ */
+#ifdef CONFIG_X86_64
+#define VMAP_GUARD_PAGES	0x11
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 
 #ifdef CONFIG_X86_64
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3b02c0c6b371..b8546e519deb 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -49,6 +49,18 @@ struct iov_iter;		/* in uio.h */
 #define IOREMAP_MAX_ORDER	(7 + PAGE_SHIFT)	/* 128 pages */
 #endif
 
+/*
+ * Number of unmapped guard pages appended to each guarded vmalloc
+ * allocation. The default is a single page; an architecture may override
+ * VMAP_GUARD_PAGES (via asm/vmalloc.h) when a wider guard is needed to
+ * contain a worst-case single-instruction stack pivot into an adjacent,
+ * attacker-controlled vmap allocation (see arch/x86 for the ENTER case).
+ */
+#ifndef VMAP_GUARD_PAGES
+#define VMAP_GUARD_PAGES	1
+#endif
+#define VMAP_GUARD_SIZE		(VMAP_GUARD_PAGES * PAGE_SIZE)
+
 struct vm_struct {
 	union {
 		struct vm_struct *next;	  /* Early registration of vm_areas. */
@@ -236,8 +248,8 @@ int vmap_pages_range(unsigned long addr, unsigned long end, pgprot_t prot,
 static inline size_t get_vm_area_size(const struct vm_struct *area)
 {
 	if (!(area->flags & VM_NO_GUARD))
-		/* return actual size without guard page */
-		return area->size - PAGE_SIZE;
+		/* return actual size without guard region */
+		return area->size - VMAP_GUARD_SIZE;
 	else
 		return area->size;
 
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..9f7262228be1 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3243,7 +3243,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 	}
 
 	/* allocate vm area, map the pages and copy static data */
-	vm.flags = VM_ALLOC;
+	vm.flags = VM_ALLOC | VM_NO_GUARD;
 	vm.size = num_possible_cpus() * ai->unit_size;
 	vm_area_register_early(&vm, PAGE_SIZE);
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bb6ae08d18f5..fc435054f640 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3217,7 +3217,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
 		return NULL;
 
 	if (!(flags & VM_NO_GUARD))
-		size += PAGE_SIZE;
+		size += VMAP_GUARD_SIZE;
 
 	area->flags = flags;
 	area->caller = caller;
@@ -5027,7 +5027,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 
 		spin_lock(&vn->busy.lock);
 		insert_vmap_area(vas[area], &vn->busy.root, &vn->busy.head);
-		setup_vmalloc_vm(vms[area], vas[area], VM_ALLOC,
+		setup_vmalloc_vm(vms[area], vas[area], VM_ALLOC | VM_NO_GUARD,
 				 pcpu_get_vm_areas);
 		spin_unlock(&vn->busy.lock);
 	}
-- 
2.43.0


