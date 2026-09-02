Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A807C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91BAF6B00DD; Wed,  2 Sep 2026 07:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD9D6B00E0; Wed,  2 Sep 2026 07:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2696B00E1; Wed,  2 Sep 2026 07:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4390C6B00DD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:59:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5C94A2853
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:59:16 +0000 (UTC)
X-FDA: 85168676712.08.DF1EA72
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3163C0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:59:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YNIufYY9;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrBct1ISMak5bjABJ9a0QZ572O4KmXxSTLwo8amtM1I=;
	b=yCILR7pYmBiJevrRwb6weMnkIeXBO+4IYFqPDkXjvm1ZIlbByrgoj0n/oKThi1UvNZTgfw
	O4PvscX7pcjQqsFRvLvhdIkWQTd0De4KgHxDFBbw9qJc6BV5SrCHBNPZspFoT9e59VtBHy
	1XI/Ot3mlf8cliV4LiuQi27+8Zko740=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YNIufYY9;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350355;
	b=mJpjxP21gzCAuTkNZbxb+VbzkF/1KyNFvpNL/0XH1U4d0BZlY56nfTZul23nRt2X+tyAfe
	uk3uY+Ih4Mx65OQOgL5EHwPvF0gqdA68pSE9Z86x+TjXtFxfgsEe80qCz9KuJcvjiD1mym
	ts76PoPv4PB+qRwdNJeLAAhS0BNI/Wc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CC611E32;
	Wed,  2 Sep 2026 04:59:10 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6C6E3F85F;
	Wed,  2 Sep 2026 04:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350354; bh=Br/cs+FpftnQOol6BErs3frU8GfYo1jZb/nBuxpBEq8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YNIufYY97B6qUu57kfR8nwRxcLtpS+O6ostRIi/nQOuKLD58rztHwSAiT1AAYOntl
	 fxPaSMddAYwDW8STJc6MsE8WWxYq2NPYdK+F0yYS0HcTTtt1ra7YEAriOl0DmEf2lo
	 zM0F0pNqICHzqI3Xh+hnQZNMeBEPTobb3bXedcbs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:23 +0100
Subject: [PATCH RFC v3 21/21] Documentation: mm: clarify behaviour of
 compile-time folded page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-21-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5247; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=QkuS96DAgeRV++qcxLUFqnS2tbZYgjub9eHsvrXmSd4=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7r6ZZHyXCpThNLcIh389noXapBmN0QtJRA/
 0G6xN7Ry3uJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6wAKCRBt1cPRWsUx
 M58/C/9U9B6FfYQ/fupAFaXvIw1Mnt9yYqNpnlfNtC6NDeZsWkfEpD8g8rzw/ZmT9NJlS4YfPs1
 Qx6kcjhDR9PAeBJBPGh8BxQwaeLNn1ssBbAQxNDfX7yrRLWPxHK9wZ7XBK+0+Y5Lk3lgdRQJ6qI
 p4F+YbpHGfi22XGen2K3KAJo4nzOC2nru7i6LL5wr8wAlWshB+2+4MqDHojeNHwLITRml9jgLu1
 /5lqRtOqA/q+Qf0MpV0tPwdATl3vJk5GSkq2yFyzkMR4LYpE4C4fuh5kWjMReGy62Non6aPXFa8
 +6UdHtXQ4V3qp9smbO5LbcLD7qQUPFqBTFktH5C1HQXXAvjDBzouhN5N4kjlLCeCrRwIwAVEVZR
 TNUIXv8PMlOojSv+isqEwSGFr+0lJ0ySAkyPAXIRh55obtZ2bBmU/KQx8c+65rZmmgDb4nJ57+G
 Vajqff8eVIyX0IvBrlsknDMl32bDAWeQx3n/WwlNzdx1iu6CzzjQqt5l1s9+zYKYR23pU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: qt5kzh6uxo6cc7148njtccmg5gjjmf5r
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3163C0007
X-Rspam-User: 
X-HE-Tag: 1788350354-715484
X-HE-Meta: U2FsdGVkX18HvA2mqs/EC2Z6H/YW2ps1hFk/ne7b77zUz3FclwsU+OC2nwU0/IKicl6q4mIfOz/bz6smuySpRitV4CDREMyW9qiv8mVEOT/Upoptpw4Melr9UftekKvqwLh4a+0iEND28CoL0JwVH644H2aRWOjfCSy9IJZFS/l/R94JNHZYS6pd9/27JpTkwPfBxxSNR36oJQXzOkgTMQOJc4A5sLPLGnunTs44urHzbX16x4gvt8nlEYLWvC22c89BkWAZCEZE908/qJ9+SfIADDEj3q0mLIOdyW8E5rQDqL2rDPX/3uT0JTehTdd27h+yFf2WKrXSP6bmpUh8XMI02cANQeNTh3Z9JXok354aLWGNARxoEkKcHXOHvKJvhWcnOCSliM3yp5B4nqJnU4KGPWdZQbjrTEHx1On8Hg9NHJxJ0e9bBqi4YRw8MMzftMiNgHrg5HpTI9jXibaOzNOJoPStpSnUKVlsegz6GtgmH+mfX2Psdzfx6TUNZEZlwhs8C73HqjWSGm1Smqp7UmH57T9fZX2OaX0iG2yqGjUTxpm+6NaSfc5tRNqEm4jGjAqOJq1XBy19JtxVhDfgCRasE8oDjjL2CVltYliLA1UnWkbOxdzG7hW4Fl47tXzYOLsZLdOyQl+gpQsrjttspbqvR77dVsBYWkIlf5d3BWqxNGdJtyRlM1ddli0qddFSDZ0rEpBCO0PLIMZLesCW0J8BwnsUYOmFV5WUNlPNVMBJwy/WB9tWZrUHCDUk/9hcCfrzXDVTyqlM11HstQ/YmsyLqNz9g7BvVZFBnwOuLeQR0Ajq6lGXzTfCBBGMEzGm9z5jE/5bGp/AMfdyZ8HiCzZie8RguVewFzuucuFARgjXuPkdN2Y4QUvex/TuX45Ltp+KEERjFirqVX4SQ+Tpkq+6bQ1NBHTVYz8BCPuIcLwV+Jxl1ZuteIRCEG9f5g8WTJ9+Tu5pscMoCfb3Hlb
 k8I6bLM3
 Ici7WPZew8gE29NMugNXRg1hZ6hO8TYw/UmkJRtbJa4xmrGA3lOyeXMLQvBr7iW/JsfH0OEBJ1cqq6vga0ACr30kOvvvzq03vLXMmCWdHR8ls1ONRgUYSwjy62ZCarRiR6wjtvnHxJoonZYZPCCoi2Zj1pTzprcXdXUCsyZAGcSK/MHrnejaJUM5avqVdB+nA0tC9Iz1xKeYl0j3snJzAoqkGPPvRYtVbr/v5omyAqahKM6rM2hL7vq2lOg==
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
index 126c87628250..84f2715c7de0 100644
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


