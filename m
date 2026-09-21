Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D46D4C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3FF6B00C1; Mon, 21 Sep 2026 06:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64586B00C5; Mon, 21 Sep 2026 06:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C2A6B00EE; Mon, 21 Sep 2026 06:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 886746B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:57:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BC721A0142
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:24 +0000 (UTC)
X-FDA: 85237468008.06.7EA83B2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 49CDA1C0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UOyMy1XU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988242;
	b=mngBJQ/JA2X2nSmFFk/FTS2Qi15ZEKsWKsgOIYyDX+69qvmYXDfecPtRGTfoTpw9EBUGPp
	H+90spu4kbIj1v/YKFWx7Pqh16OGrkrI8ShDDuMV2fLHbas5V+vUbI69UpbeLK5Y6LHhvl
	lqIc/wt/JH6B6XrpSnZ9Gbb+SL0Ciek=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UOyMy1XU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGHgHI2gRZMmv40E0x3UEw1xl1bl0JwYei/S41lCha0=;
	b=WZwybY2J88UJQtH6IhcC9BuMCDH/OUekJms6rmhuV4BTwTLlWOD9PJ7TEkVqE3Nac0qIiH
	HLCVolQVVEJ75z3QWHK3JxeY5WmbOkhibyJ02mF7UIxhT/nqY8JxMg0Uv6/kFjvHgj7uxm
	Z85LqZlpTTK+5+dwXOgL7QJDfKv9BuE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D16551570;
	Mon, 21 Sep 2026 03:57:17 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40E833F86C;
	Mon, 21 Sep 2026 03:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988241; bh=eO/TuCYXsMbuYK8M0gFZvx7bvQHzfV5/hkWKu/RsUj4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UOyMy1XUl+FN5ZFNQorWnnKPtv/UkQZgHPGlzeaRpx0D75+94J6h4tByCGqfzlsOc
	 NmGVh/Uea3V+aklixbWlJ9Kz0A2C+SPMhys5dT/vscoe8tU3iR7tGcB5VXHs7zjr7o
	 1lw0ePXHwklUI/LIfoNOQPXsfuy4NgsrXncJg6FE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:29 +0100
Subject: [PATCH 07/21] mm/pgtable: define (pgd|p4d|pud)_offset_lockless()
 for folded page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-7-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4366; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=zbP/UAv5r1ecRg6w3p/1fVSqT9+jMUkB+linIaJOv8Q=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1Olg/kp2O12ZhBFsprJTLwJprUFHtBPBboc
 xsbot1EFYuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENTgAKCRBt1cPRWsUx
 M9M0C/4omPEQYtMsmhr5u98NEFHzremiNZ24+AVOBDXTL+rJoYL/1w6it+HEgBZjKKRb1YpvT5a
 xzVvByW0NmxLHkS1C/N1PMUe8Y4v1TxJUnTrrnnujUMcyWrEjMVbDul0gKHFZJsIXo+Y5jCHcE8
 o7nstAfRNVP0jsYT4A0swLzAVx82gz5mYQ9xbh1mvQIC8KGwW0HSzesy8GLGafXd4rTpmQhp6c8
 FIvu17DbNJG43dukNhzi2rTu0HGYqn2GG7Z6DQ5d3QCZZkjBTHhShsHvtYmvxdbOeKHOXh34xXq
 2paWtI/ipWGZ/zqFv/TF15VlryOyvMcF4ZNYvUKCQrvfZvgnZ/l2mgiF4a6HTWXFYeGFlewj6nz
 rgP6hVmN51A2FA5SEUKAcs21tcP99SeU25vHkI6TW3ad9swA9i/BHG5yftJwbr4dwszKeFahtQj
 qg9S4LKfbCjV8hC8w7FbIuTX6eIY1qUH6i70JIks3i9F1KNAtzfUAu+vIDSiAVc5xY52s=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49CDA1C0005
X-Stat-Signature: ste4gqmp7co771hbm4kcdfidaufbsexc
X-HE-Tag: 1789988242-243356
X-HE-Meta: U2FsdGVkX1+8Q6NzA/RZzZfouidLLcZI8+QEsigDxODkce0zKGzFB6xq5Z3pqX8LSaJC580rx2mJ92AME06YoZMgXBAituTD7yK7rTk0r2nZg1HB/G0BlLt2IZkNCZ5O9DSsI4vTuIei4YUpo0w5hG/nOYODfrI4h4LV6uDhfIRjnMOylJNWjcsE5AA930Bd4sNZh8dKKo508lH7xUW+G4SydJgaPHd/EZPBkPp9n2altm35IgSxnS1iWKEEMPAu0Qs1lXObhCfCqW+Zauz+GetR6oGMSsKgcBJlke9WaFR8frH2zw9R/yTzwr/oNNkVbh/w5JkTwpwbOnnMEyFhy8pngFlr5axPSbucyK6UIdRkEDPcIY8Yc/GZ8UJyzbrMzNt3lylvkdHjEajm9nQJEGd66vGFdu5VVEYB5cPg9C4nmCOPC4PdxbJBmkdf57iPkiC5RZYWAQ/MzF4wp2DLSF9XgyPsgvlP5drkAb9S1obq4o6UCCVfmOTqq7sgO+FwaM6Wpw+TM/N49Iut4wBb/c6ymneBtaRmLsiOVx3w1GWr78R+Y8CZFUIPna4zd1uV8aAHBjA2AZBnrk9GB2piOKixu3Lk5+uelO5XlBauTfftLS0tEIl3bPp+3G7y5Cj97IdKAbU5ruerhv4Iv3PBJKZuFg3XNPQNyBdk20mKrewUztRsumSIL7AD5yMXEM6FbA/Ey2R7REnBYP7TbhJRn4CqeYVHevvddlv0YSImaseBbFQ4uqDYufq8nKqp6HohBUUbybEfoThAPMm1huoIQZekxD/eEEwV51uf7u0Hguks+ZQEDT2LZW1sUlWEwhauH6GICWNE7Bg+dXoyFTqE7d2c7v7+x6nkm1xgV0wTrtYkpvuMhQS5hCkNBryoOp0bHRfvU5HgkFOL2CyFvZwaomm7wYOeCsgThq5BjyOSky1fIWSnxqdbyjrVQG2yovfVoOYB/E+f8PlWW88Kc+s
 hfxhYKMT
 wSSOkZLfJbp2IYlIKwWRwuTF4ppnrmbrIRGLsylHbXHYmUeqsChOJQUZDYTRwen3f36Z5RAv6I8iUKFfLGKbkzL4gq8xHOStm3Oh8aXrMIHoIhGCAMcgSJMeTpynZyMNeGSPLkkohqVg+mi0dy+d8Rg9PDBGTiEKv35stvZn6qZW0yuwtRoRBEognSn8YPDyYkF/1s6a4q7h28Df2iIOEzBlWcEXV9ROa9VT5Bi/PN1mtDNBH0rZh7sbuvT69CsiW+nERWqd42IVjbXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The default helpers fallback to pud_offset(), passing a pointer to the
stack value.

Let's provide variants that do exactly what (pgd|p4d|pud)_offset() do,
but ignore the passed pgd_t/p4d_t/pud_t, consequently not working on a
pointer to the stack value like the default handlers would.

With this patch, Drop the arm64 custom variant that did that. As it documents:

	Note: reusing the original pointer means that it may be
	dereferenced the same (live) page-table entry multiple times.
	This is safe because it is still only loaded once in the
	context of each level and the CPU guarantees same-address
	read-after-read ordering.

Do not document this, as the double read will be removed in the next patch.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/include/asm/pgtable.h    | 23 -----------------------
 include/asm-generic/pgtable-nop4d.h |  7 +++++++
 include/asm-generic/pgtable-nopmd.h |  7 +++++++
 include/asm-generic/pgtable-nopud.h |  7 +++++++
 4 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e89ec5f4787b4..a3c882e46777a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1180,29 +1180,6 @@ static inline bool pgtable_l5_enabled(void) { return false; }
 #define p4d_clear_fixmap()
 
 #define p4d_offset_kimg(dir,addr)	((p4d_t *)dir)
-
-static inline
-p4d_t *p4d_offset_lockless_folded(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
-{
-	/*
-	 * With runtime folding of the pud, pud_offset_lockless() passes
-	 * the 'pgd_t *' we return here to p4d_to_folded_pud(), which
-	 * will offset the pointer assuming that it points into
-	 * a page-table page. However, the fast GUP path passes us a
-	 * pgd_t allocated on the stack and so we must use the original
-	 * pointer in 'pgdp' to construct the p4d pointer instead of
-	 * using the generic p4d_offset_lockless() implementation.
-	 *
-	 * Note: reusing the original pointer means that we may
-	 * dereference the same (live) page-table entry multiple times.
-	 * This is safe because it is still only loaded once in the
-	 * context of each level and the CPU guarantees same-address
-	 * read-after-read ordering.
-	 */
-	return p4d_offset(pgdp, addr);
-}
-#define p4d_offset_lockless p4d_offset_lockless_folded
-
 #endif  /* CONFIG_PGTABLE_LEVELS > 4 */
 
 #define pgd_set_fixmap(addr)	((pgd_t *)set_fixmap_offset(FIX_PGD, addr))
diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index c6a5a43899b50..019c3f074b771 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -39,6 +39,13 @@ static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 	return (p4d_t *)pgd;
 }
 
+static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
+		unsigned long address)
+{
+	return (p4d_t *)pgdp;
+}
+#define p4d_offset_lockless p4d_offset_lockless
+
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 4e5aaf253b6a5..1dd5b165234be 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -49,6 +49,13 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
 }
 #define pmd_offset pmd_offset
 
+static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud,
+		unsigned long address)
+{
+	return (pmd_t *)pudp;
+}
+#define pmd_offset_lockless pmd_offset_lockless
+
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
 
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 6c9bca78047c4..5a2b0a81ae197 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -47,6 +47,13 @@ static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 }
 #define pud_offset pud_offset
 
+static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
+		unsigned long address)
+{
+	return (pud_t *)p4dp;
+}
+#define pud_offset_lockless pud_offset_lockless
+
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
 

-- 
2.43.0


