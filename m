Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7412C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90526B00A0; Mon, 21 Sep 2026 06:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66C16B0103; Mon, 21 Sep 2026 06:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C575C6B0104; Mon, 21 Sep 2026 06:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 954A46B00A0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:59:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE7DC1C0184
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:59:09 +0000 (UTC)
X-FDA: 85237472418.18.696993F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B52820006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:59:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OTPGWQ3V;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4toMdtYioi8w9HGmKDf8lwn05tg3yomRqh2JzLPKJU=;
	b=NphZTTF2EUuLlNM84b9mj6v4J5/Kv00mKEaXUWy8XbKnrcJxQV2xz3NefeoYitKHoMhJr5
	DyEVt60QbFV2llg2b02Yvjb6MVmgVB8hHv6MBgXauqCK5Vz8sIzL7HAnqwgDwxabFnAzTV
	gVUI86eoNmhIuK4ZtmwliC5ND1xRNU0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988348;
	b=G6WzKUubS/EdlDRenYDiuK2umezT6iFB3k0nsYbD8b8muB0WJRv61EPx1zEVbGKEgqVPmC
	WVhyDEJuNEPrX4wK/xPW/5be12ga4GHN9CdH+byrjqIMh4dGbLq3IPeBs8vdZtqz8rHzMX
	5I2pVhjWcE814b1hq3mp5jR0/AbAI2k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OTPGWQ3V;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0D821CE0;
	Mon, 21 Sep 2026 03:59:03 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E11E3F86C;
	Mon, 21 Sep 2026 03:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988347; bh=Or+pfL3PXEcPJdOW4W+xPfx8ylyd8tpn0CA0i+cQDx8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OTPGWQ3V/YIEMLtO7u2Mynqz++o5RPwLMFLlzIT4rgUlbfJz02BoKMgw4RXvRuSNj
	 deUYqvEpMQchecaubbKtyAiqcrqDJ3rG98HSWlUBFWHIGiqs9ocWbZVbfPkkrmm/D7
	 ncRtII6dpeDQJvydmvJhhhL2Snuaf1u6HEPcx7TY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:43 +0100
Subject: [PATCH 21/21] Documentation: mm: clarify behaviour of compile-time
 folded page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-21-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5249; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=WkUI9iV+4tWIf8gUL0eT1d3WqVW3xHozxqWVF9c3f4k=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1UvQaI/DbnQhSon1cfVb2lmVIAgB8pZa9xc
 x4itcv3wn+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENVAAKCRBt1cPRWsUx
 M3wVC/9HHxJ8te9GEbS6FYmVPJFsAKbIOicXI24Ln9gqlvTZxuy4kNJc4ab1vnjPxk64m8Rg+x2
 Mge3H0r3HnaL+quWGc5hhXjVijIFzCG8gpQvS3TAos58QC0AOllXSljJJW+I6bPGRHEfZbrplmH
 MSpeBY8ZsvhMVxoa7rzCNDxLL9FQI0Cc3PXqn84Rx9aaobgkmEtYiN7CNHsRZU3ng64fu67dco/
 9XO55oYTMY5NC0dEQSGNn31KsfpblVBRsW5um+k73FHlpD7vrNWPHSDKjsItM4o3qlBwTsCwCl1
 Z7zy/Eg/ZygXnmH8QOhMc7fglKOXMvcG/maDLM9eOF/8KD3LCcwyTzCpuv5EoxT7vOhxogj2kut
 s/VQGR4ui3uesYjCw/PuXgA7Ampck2ZMBsmMmPI1k93NpLLOG4Y529M4WW6uqqGb5xddwPmnW5l
 apVpiy9rUjEUxGjRGHepEQpg+BUzcWhj6iVaP8sd5tNs9WaHGtTaNtG9oqCr4rfrjLXkY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B52820006
X-Stat-Signature: zd3j5a1xp8arawwftt5xntmadxy4st8t
X-Rspam-User: 
X-HE-Tag: 1789988347-174721
X-HE-Meta: U2FsdGVkX1/AtotseQuEMKamGlNVKxBY/4KXDtVNETYFsKOthQc2eHVBFSWrcyWm4rCEMmQGDtR28ALWtvG6Dw7ZB/o6xXL0PPjrxqd0hiMXO0FRiR/2TXIJLakELxJWA2AnjXw5Zdi4UfMUo5D/FHwHyow+gBGYsas+BJ7XoL/sEA96n+cWza3ES0kbjRAAqV+E3SU/HhO523mYer671Ll99A68/eNC3Paaz5AZqUNLnJFVZJazskrKNfXsCxpSJozyeh7O/wbn0YknjwUvfONdZQXyyhf0DebePuYMn2TTI5yxRGhgkSAXQfvwKJ2MhIw9pcJW2s6hhZGPBE4NeAT/g2pRhHLiHFr/buTCoht0AjEJ5xkZSee3ENLYNJuN5lyTzmz2AxjFGLQD3O2tfj9KRh9mO2dAKjMSeC5WzHF6wSa+rmVf8MoagpiQZyRDnFyYRbnrliIaSv2FQGCkVSucYGLObrH2abvp/ZZa2hGgavL3PctfM1qo20NPIKyuGQ9UOtF+BIf5/ikFCCnexoVRYEFI3/lLA2y4y8h03OMnUJTm4q81l9Ruxc/iweAxEQiJ0VW8Fg6r/Vmd+cYzrLUZJvC/nJuSKCXqXY/n+SMt89rN8aClqhcoX1pGCcf05iAA1/VxD4i99gja9WSAO4NGYCszUtitTZpJT6uzduPl3fFn+8DNK3hlasN9uq6ni1xZglpJHHsJJnbQTkAoDOr8tAq0KX5KdbKYnMLDcJpjlIWtzAvg0Bu8xsT+8UHAodNDt1VnLjHf+d66FArZNHFsRT4myQPQpDQkiwOW6y78udYV9hvldJh8hD60k2OEDsPzGpYr25LpGWkEEEyEAFSzOnv9JVfzLGCMWwfw4lZuJzQgfMnaeC4oXZ886iwn8lTFklsOEy+xrF2Q3UZFxStzFOlujowQa/90e6JSRTUWVfr8Jvoja6gRMEdaPqHyWHs5WKBDcdsPycCjQlK
 rwu86ud0
 CT9sSJ8YDDDmVIRvZjDIDKEdnNeMzPH2uuvwsg6kOaqp43aE5vJISr/P0Hl+RsYnE0/uqDOuf5EC6SSylDaqU0N9hIbMEPFvg5EhHDTlxs+JV4k0GiBPKRVw/JY9ML03h0l1pYxTJOjGE6/pZfX9ofBCv7Th21Yca7v3lEim+3wrmVsxBHAB2ap4JhEQb3H/d8bEZk+tAZ98DDLD+ZaHkCEnSEII91PDmB7GyeaKE/LUjl149eNMRAIrCHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Compile-time folded page tables are not necessarily easy to understand, and even
people the were once familiar with the concept might need to refresh their memory.

Add proper documentation, including a nice diagram, for the current design.
Mention details about dummy functions, including the recently changed pXdp_get()
helpers.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/page_tables.rst | 84 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 75 insertions(+), 9 deletions(-)

diff --git a/Documentation/mm/page_tables.rst b/Documentation/mm/page_tables.rst
index 126c876282509..84f2715c7de0a 100644
--- a/Documentation/mm/page_tables.rst
+++ b/Documentation/mm/page_tables.rst
@@ -143,15 +143,81 @@ pointers on each level is architecture-defined.::
 Page Table Folding
 ==================
 
-If the architecture does not use all the page table levels, they can be *folded*
-which means skipped, and all operations performed on page tables will be
-compile-time augmented to just skip a level when accessing the next lower
-level.
-
-Page table handling code that wishes to be architecture-neutral, such as the
-virtual memory manager, will need to be written so that it traverses all of the
-currently five levels. This style should also be preferred for
-architecture-specific code, so as to be robust to future changes.
+Not all architectures support 5-level page tables; while for some of them
+the exact number of supported page table levels is known at compile time,
+others can determine the number of page table levels at runtime based on
+hardware support and address space sizes.
+
+Generic page table walking code always assumes that 5 levels of page table
+exist. To make page table walking code not have to worry about that,
+`compile-time folding` and `runtime folding` of page tables are used.
+Compile-time folding is mostly handled in common code, whereas runtime folding
+is exclusively handled in architecture code.
+
+This description focuses on generic compile-time folded page tables; for
+architecture-specific variants, some details can vary, however, without
+affecting common page table walkers.
+
+When walking folded page tables, all upper page table levels up to the supported
+level are skipped in page table walkers: this is achieved by (a) treating
+entries in upper page table levels as present and pointing at a page table; and
+(b) having page table walkers cast the entry pointer to the next-level entry
+instead of dereferencing that table. From the perspective of a page table
+walker, the entry points at itself.
+
+Assuming compile-time folded 4-level page tables, to achieve (a), pgd_present()
+and pgd_leaf() are hard-coded to indicate a present page table entry that
+points at a page table, and to achieve (b) p4d_offset() and
+p4d_offset_lockless() simply cast the page table entry pointer to the next
+lower level.
+
+In the current design, this is further modeled by having the P4D have a
+single page table entry::
+
+        PGD
+  --> +------+          NOP4D
+      | ptr0 |-------> +------+           PUD
+      | ptr1 |-        | ptr0 |-------> +-----+
+      | ptr2 | \       +------+         | ptr |-------> ...
+      | ptr3 |  \                       | ptr |
+        ...      \                        ..
+                  \        NOP4D
+                   +----> +------+           PUD
+                          | ptr1 |-------> +-----+
+                          +------+         | ptr |-------> ...
+                                           | ptr |
+                                             ...
+
+Note that the arrows from PGD to NOP4D represent page-table-walker
+transitions, not pointers stored in the pgd entries.
+
+Using p4d as an example, `nop4d`/`p4d folded` translates to the following:
+
+- p4d is considered folded into pgd; both are operating on the same page
+ table.
+
+- Most pgd_* helpers are hard-coded dummy functions that ignore the passed
+  pgd_t values entirely. Exceptions are pgd_val() and low-level helpers
+  set_pgd() + pgd_page_vaddr(), which effectively translate to set_p4d()/
+  p4d_pgtable() to keep existing arch code working.
+
+  Architectures must provide p4d_* helpers (unless further common
+  compile-time folding applies).
+
+- PTRS_PER_P4D is hard-coded to 1. Architectures must define PTRS_PER_PGD.
+
+To avoid reading a value that will never be used but cannot be entirely
+optimized out, compile-time folded page table code also makes pXdp_get()
+return a constant dummy value.
+
+In common code, this only affects pXd_val() when used for printing page
+table entries for debugging purposes. As we don't want architecture code
+that uses set_pXd(), pgd_page_vaddr() or pXd_pgtable() to accidentally
+operate on dummy values, the compiler will error out if it detects that the
+helpers are used with dummy values. For a folded level, pXd_page() must not
+be used and unconditionally triggers a compiler error. Architecture code must
+instead call the helpers on the proper first page table level: e.g., set_p4d()
+instead of set_pgd().
 
 
 MMU, TLB, and Page Faults

-- 
2.43.0


