Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47215C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487B36B00D4; Wed,  2 Sep 2026 07:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45EAF6B00D6; Wed,  2 Sep 2026 07:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E166B00D8; Wed,  2 Sep 2026 07:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0EC6B00D4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:58:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9220812019E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:46 +0000 (UTC)
X-FDA: 85168675452.19.2BF28DD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id C7C8220002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KmR0bcAH;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350324;
	b=UeHoMc42qyA0mRF4zj3OfHFSWnonwISI+VD6HqVHiie6Mk17PeAETteW+qD2dlTTAidxDB
	hwO7A2Bbx/vUtRtzzyHWI/WazJDxP9udQaJBZeQX3HOnVuwuqwE2YoAZsp25cAvYn8WSiw
	KpBJrOoGbXkiy1ILUs/8jFfoEFrVbDo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KmR0bcAH;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfYLa7UQ67RLen0tVLq8u+MA+D9DxnTEs0q3bVO1W5M=;
	b=oQqdEA3UgNr7nngBiZ0y0JnVUnRYw+kNCEKkVGumdm9/7HeEP07Qm20hKotcT2FPLsF08l
	TLuEcUste6qnhNJlc3FuxNy/6d/nkKVA2xmvB4S+mxO6gOf/rKxPABdYqRfQpafM3LD+OJ
	abR+HNCkyUtMnz4F1FyHwSjvRkeUeRs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33EBE1D70;
	Wed,  2 Sep 2026 04:58:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D13C03F85F;
	Wed,  2 Sep 2026 04:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350324; bh=0+RGd1WUzwslPu+CdgBC9gX6GwYxt16ZdPDUpjU7PKA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KmR0bcAHILHjedlQjFxN3H0O2IL/HeCO1m5KAeW+TSw3E0WU1i8EPRjWwIE5ADH4w
	 tJ2R63dVf9VQDXCJo+VKDGslgzqRK+HlMCqNmzRfOtvvt9DXpOpbevWxiOb/LXm/v3
	 VD1Z/B1ulDvukFzXH4GAQ/CizeIzt8235ZjEHw+8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:19 +0100
Subject: [PATCH RFC v3 17/21] mm/pgtable: optimize pmdp_get() and friends
 for folded pagetable levels
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-17-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5353; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=fLSiexxG1byoWlowumv9uBq/Zg1ftsD/4XRX3kdR66I=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7p3aH31DaXcr/MYcmL2RFei83Cs5fJVqlMx
 D7SpE4yXeuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6QAKCRBt1cPRWsUx
 M+3tDAC2Fr3lGl6zBTwCTZOonnwySG9bnX2Yks07B0tgpjnaeVBShMK4BTIMWdK7+l24w44EuI6
 lNA8Dqv0OI1iUfpii59oOelJTbxGGsxnzX9GTqe/6wNyNgXwqWTbqG8PxmkLGesb5OG0swbbcM9
 bt0QNqrXKvPY4Mp9Gd0p1jHKaa2NjChd9nCJFXVM9DdvwMpr2LS3nIFkltTg+uYQEuh335HoFnH
 gCVW1YcRtgZ6ujtoNROVc/ICV/p9VbTDNC1QoVQrmGUhHFuCeUwLmRqdBp3D5Y1m1pqx8HxFAOO
 a5YTCPu75A1ETF33IIp6EtsLykwrpfS3NYM6Rf6ayUKhCuNaqQ4plPgE2d4j2bCyzK+WA1qYCBP
 xRCNOg88QEMrOoviLOa+lx4cVnbBUb//MQ7+hGcZDRW4vsp3f40yk9EbU1OHa8rS47KnkuRvgAw
 Dp+7p1+tVepwH69kufcwG0PBCJYH9Fivp5IiTt9jal+54G2HOGpA8YGE6/DBvailHKvT0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7C8220002
X-Stat-Signature: 9zurke1cy3xnfa93rhfh7a7qxbn9rqdy
X-HE-Tag: 1788350324-616358
X-HE-Meta: U2FsdGVkX1+uZ2wFivUWA3481seQ+9dPg+DwSr6OOwRYg1Q2viy6zoAvAo6PjbTIt5zInqvcvGx0XuILvxx6nUpgqYU8DM6683iNw2maUHKn5VbS5dX689IyO/oxylG/xaoUiPBgN27X7bzfwM62mP+o2Hr0GBZrFRKf5s3KpYhFnS/mdk4/tEHJ27jbMpGgOGJ2UP043f0r55iWVcE96LJlUpRLptcIbiITO8mNtMxog0JWWlPPz4muQdbnrLTA56OP8dCkutXoYBcqwGlSixR+TuGDBxSfkUqoQ2J7EhQqGdQ1AgeIYmXHQbzeEpIH0dYjj6nmKcqGODK88Zob3GEDu0xIzZkMfSSyLmuAfyRE4JT+gVfSsQPw2PTrmavHTXAhl71q80U6Y8RzbnAtskJzuFC1ZtODpvOZx+NqXUtCrl7yweiTU2A/D97xGeE86oPsEj4/WXWjSToyX6Cjncuc24aRZ5vimJoXslAnQ7Whr7D44apu6yDEaU9YkvoAOYSjbNBrWSXTA5em0NO98bl5aA3awd8lKwEMpp2byEh/K5gu1C+QNzcz35RxroRmSb824wj47HhikmFQzszloBlWjzDdZPPZ+TYpwPM7OKjJhsYtU8XKht6fZOteu5J2XsMvsQ6VPgHcDZc3Z64ahPNbyQeZxVH8NnpwLmw4GnEPQ30PlK7OFCfqk+f8wrRYFzB/fPeswUh/L1G/F98IF8N9/ANGA/5uPiK/Fh0WUjEAS23Gsp2GoBWgDB0n9nRLCRt6OV0aEELWZ6+xPW2esOHboB2qValPUDM+PPfepKvmSHsPidjE084+KQ3gZnBrBvyPsIV4NnrwgO0dOD/G39l9lHa2Rfay2a0mEUnO4s4gMXD5ZZfxoistyI4bgpmoVT8GKAnbg0wa7pO3oA3LLFzBN5PnODgrfsQUywg8+6+h1nM/UlplbSR85vYWz85m9P3a9VoGJ4aWpwMAjN3
 jlPIPNe6
 K1QIuaYKPToejEdKHWZuOE1OIw4/gG/vc/9MpIClaqWgKz5ezx49bAF8nUaB44kjhYOIY1QHeuleGHad356OASy1Q5qxwQUftEvG+W//P1PpXUn9wvHfGMGm9aeW5WIrq28XeIMV7PeqIokxnIEtgGt450iANa1SWhBmlpp0VANLxMEuRmL7LFtdt0hR6JOR3r+Q0xcadLOl1jhS4s21EUtpSpzB42H+kYhKvcGTFP7+D2uRA61NrP1nSZaY7lo2sQcPIijbA7wkNQywr4ld+uxFPaT1uHjcXikuX7LvCpoYe+ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Using pmdp_get() and friends in common code on a kernel config with
folded page tables is suboptimal: they default to a READ_ONCE(), forcing
the compiler to actually read that value even though it will not actually
be used afterwards.

This was recently reported by Christophe Leroy [1] and block conversion
of more common code to pmdp_get() and friends.

(using pgdp_get() as one example)

Most of the code ignores the result from pgdp_get() on configs with
folded page tables entirely, as it's hardcoded:

        pgd_present()==1 && pgd_leaf()==false

Common code will just treat it as a "this is a page table" and call
p4d_offset() or p4d_offset_lockless() for the next lower level, where
the obtained pgdp_get() result is ignored entirely.

So, return a dummy value and avoid any memory reads.

There is a catch, though:

1) If code calls pgd_val() and somehow relies on the data, it would now
   see dummy values. The code really must be aware of folded page table
   levels. Fortunately, code usually ignores pgd_val() completely for
   page tables (with ptdump being one exception when calculating
   effective permissions). it's checked + fixed the x86 ptdump mechanism.

2) If code passes the pgd_t to a function that would work on the result,
   it would now see dummy values. The only concern is really passing
   the pgd_t on the stack as a pointer to p4d_offset(). Most code that
   would do that, should actually use p4d_offset_lockless(), which
   handles this properly. it's checked + fixed problematic instances.

3) Calling set_pgd() / pgd_page() / pgd_page_vaddr() with a pgd_t obtained through
   pgdp_get(). There was once such case in riscv code with set_pgd(), which
   is fixed.

As an example, this is the generated code for perf_get_page_size() with
PGTABLE_LEVELS=3 on arm64:

Before:
00000000000052a0 <perf_get_page_size>:
    ...
    52dc: d53b4234      mrs     x20, DAIF
    52e0: d50343df      msr     DAIFSet, #0x3
    ...
    52fc: d35e9a69      ubfx    x9, x19, #30, #9        /* pud_offset_lockless() */
    5300: f9403508      ldr     x8, [x8, #0x68]
    5304: f869790a      ldr     x10, [x8, x9, lsl #3]   /* pudp_get() */
    5308: f90007ea      str     x10, [sp, #0x8]
    530c: f8697908      ldr     x8, [x8, x9, lsl #3]    /* pudp_get() */
    ...
    5360: 90000009      adrp    x9, 0x5000 <perf_prepare_sample+0x548>
    5364: 92746908      and     x8, x8, #0x7ffffff000
    5368: d3557675      ubfx    x21, x19, #21, #9       /* pmd_offset_lockless() */
    ...
    5394: f8757ac8      ldr     x8, [x22, x21, lsl #3]  /* pmdp_get() */

After:
0000000000052a0 <perf_get_page_size>:
    ...
    52dc: d53b4234      mrs     x20, DAIF
    52e0: d50343df      msr     DAIFSet, #0x3
    ...                                                 /* no pud_offset_lockless() and pudp_get() */
    5318: 90000009      adrp    x9, 0x5000 <perf_prepare_sample+0x548>
    531c: 92746908      and     x8, x8, #0x7ffffff000
    5320: d3557675      ubfx    x21, x19, #21, #9       /* pmd_offset_lockless() */
    ...
    5334: f8757ac8      ldr     x8, [x22, x21, lsl #3]  /* pmdp_get() */

[1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/pgtable-nop4d.h | 8 ++++++++
 include/asm-generic/pgtable-nopmd.h | 8 ++++++++
 include/asm-generic/pgtable-nopud.h | 8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 019c3f074b77..acd62ee23353 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -34,6 +34,14 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
  */
 #define set_pgd(pgdptr, pgdval)	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })
 
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	pgd_t dummy = { 0 };
+
+	return dummy;
+}
+#define pgdp_get pgdp_get
+
 static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 {
 	return (p4d_t *)pgd;
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 1dd5b165234b..9322f07ddf1e 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -43,6 +43,14 @@ static inline void pud_clear(pud_t *pud)	{ }
  */
 #define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
 
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	pud_t dummy = { 0 };
+
+	return dummy;
+}
+#define pudp_get pudp_get
+
 static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
 {
 	return (pmd_t *)pud;
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 5a2b0a81ae19..8f01abbb0050 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -41,6 +41,14 @@ static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
  */
 #define set_p4d(p4dptr, p4dval)	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval })
 
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	p4d_t dummy = { 0 };
+
+	return dummy;
+}
+#define p4dp_get p4dp_get
+
 static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 {
 	return (pud_t *)p4d;

-- 
2.43.0


