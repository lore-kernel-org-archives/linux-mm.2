Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B678C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838046B00FF; Mon, 21 Sep 2026 06:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F0C6B0100; Mon, 21 Sep 2026 06:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725186B0101; Mon, 21 Sep 2026 06:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 464246B00FF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:58:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D996D1C02E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:39 +0000 (UTC)
X-FDA: 85237471158.16.CAE2CBF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 140B8180009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="hvuE/Wi4";
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzbkHlCXIOztNCUIQ2oe4PXisYyJ6l3zF3m0g0wGdqo=;
	b=tuQsOUd28F6pLADTjAVlhMieFrRKY6hJCkaaVeLrJLcy0IMNS31yxNbQt48uY1c/F3BtFx
	JWEpNSW+vsRGLsPPJdA93BowdDoA2hkS2Yf+6438gRa0ZQNllomQrK96fHH1/8/Jo/Dvl7
	gL2ihX4T0SETg5wU71MZZS+hfDv0jNU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988318;
	b=GBiWwX8kJ7zQEgC0cpf2RWB/cujXWLpSyeMuNyLWoz15AWYvlsHHnpz5k2D2fSXqsQpa+N
	pSdLhho14Jdg34uQbb2YtZxqMW8R3MQ3+62oUQp4myUllU0gyffsBwL98LYn4r6XDiFhFu
	yGnRJ9LcDNdWrMf9Rxn2yooNnR1CkU0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="hvuE/Wi4";
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC8271CE0;
	Mon, 21 Sep 2026 03:58:33 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2873B3F86C;
	Mon, 21 Sep 2026 03:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988317; bh=3qwcredkJP47Q0knCs8r2zQMj6PgEaC6pvNuESy4rVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hvuE/Wi4k3zHRTGvhHLv7qEZuHMY0xnCn6XOItTYrVn+OhipX/sBYMg25561UiIq3
	 RpT94PSQayXRgO948FTi0TvDbCYL9jwft2tj6/+iYiehoSFPT1g9OkC7kpfEpgFV89
	 zO5jMOW720AB5rQiJwGMMmHqgxDSFh7JsyEh20Bc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:39 +0100
Subject: [PATCH 17/21] mm/pgtable: optimize pmdp_get() and friends for
 folded pagetable levels
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-17-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5359; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=7UYhDG8FvnoAk5ImIUgRe9XhRYP6zIOaKvnUSG6ABJs=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1SDGUx6nLBP2PHlkqQ+8YQPh+FyMpTUJuzJ
 +fXJW3H6CuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUgAKCRBt1cPRWsUx
 M62wDADAwg1hY8opnURHDTbmR+179cx+II2vp1HY3eo35AaSKrx1jvffrnZWJqYFfnBzEUSV6OP
 5oz6pcOFi8UaycBOhl6+nbv7WYWEKFEMw2nws9PxMsG4TWkOo4vg8lFmAyJfvTcpJ6VpJX8/3bR
 qA4Bbw3fL6S8GvQCkbFEmlMEiUy7XMqR1Gof6YfRWaRe7MSmI6TC14tG6+tyRaWiv/rJFMQhi5s
 v9nAqgmlMUK3n3CEwzMBJbncThbAoPLw5JV1klO8AhpvIJELYXRS2lfZYRhIJJ0j4ZVl5j1I49I
 VGHRhtxgWsDapA6Uyk58HvSQp+OUHXBMA+E7uXiuVwxSbOCCVCs8PhJo4q/Z3XRhc+zurBuQAvF
 pJrlszQK4neSzr29XYPyO8+s2mYY2IhfI1niO+AYhrf/KNp1UEoD3bqem3YQ0E0ny+ZOuiT4cm6
 MMLCksddzOWDUnLePHxOO36Gtb/TZ4KqT0Iz0+W5+PEPoZdrCbcHpRzzYnOc+mNU0An18=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 140B8180009
X-Stat-Signature: nso3yrew583qwi5my4mpnfuoymdwy587
X-Rspam-User: 
X-HE-Tag: 1789988317-340082
X-HE-Meta: U2FsdGVkX1/UC5OEosxGDDzVkDAgvkLnDpHItwgSKtuUcxyrQ7qGGRA0nddR0AgmGMccdk0A5CdmBsWbwpPUXmtb75LPfBkeXYMrWSWnHXgouOdvX3vmp3SzioVRIxtJElpqUP4VcEjoxdhpXSO+f2oQ95VUrwPqEUxADF4T3uURbAigVSnL4u+XuVZGjSqro2Bmlj8VoBM8vxPgqGrhSxbjxJAw/8qmifnB1I9jNxHP1KiDAfNZymualtUPeTmORskYVR4chgI2zcfWttl9mbsWN9pSNLETei6ePdduE8pESFEpEgVpcgKYXDSRX6vp6MDBl2XMH8bk/IXGepINPmrdL4OjsZMJvJO4wc7xanlBEb9qfa4+OlbBKgSYGbQIy7pb2uBaJusTkEN1O06AoCP9BD0FznBaa3xpiBcDx18vfyFQH//nEy3jCiLTduxs4kc2YAbRemuRqQuOt4bE9i+IwfptV5ksvyRCPJ6dy5cVWOHx8nOyVKSH3duyQ+iRJ+elp0geHtzrWZirpWLhQccVIhTWJovh7Hik4zWr1n7UiVDKg6ZK409Cb4YTsL/X234RwQ8d6Oz+XhyNmMw9MS6wB7fQGxD5Y08tSx/zQLMG/3FX9KwgXrlNNB+9UtnxQBIbFgia9wWpO/4yaFGfN3VfZaTAwgVguM+NS7Q8fdAdG4EYi3WXCTEs/j8MDQDLQpkHzFoajBHDXIun2UNlJsEgM8sK3byskSZIC/15dv0UCJ7LT4Jvco7b3Xl2VcS5v62sXFVXbXvBml42l3SArw+rOftK7HDqA/kxl+12eHFK6FnYereA7HgrMk+ah/o0NXxSpDfgA1LVVwSn4XWJ1CF/AaobpbrxWhVQkRgI1ae6fpBh3JeQBozxMwjA6b77cN2GiEfc8UxzRz5wfmWiCqbONzprFg7CsCR2LxV0Jed0mIgIkBPKBXHqJEBbCJYg6DQpzmD7AO5Eu1wXgzv
 TItiP7pN
 FEJUkv4tok15ABKME3/48lYnnH1MAANsViL98xL2kMl7Rms5J+NFHvwfDlNE4wPMQKJkd1ofJ2CSNIGpl6AWvgaNphq7vT+divuqmCl3ZeVaayZyQ8vg6F6qQKGQwdSxJ+cZ/PMAx0lNNI9EM9uy+H3ggFz2Rq2FX0BGy0Hh6Omt78tHSc7awZcCKIcGqhLv020+6GohFbH9loedCERXjsfjjY+K5OLZkAFhr/uXiezV+3usYXpi1OYRK8NtUDh1zIQHPm7KLEU8z1a2CarJJSxjzfmpSb6G0OxHI5vQIlnrqe48=
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
index 019c3f074b771..acd62ee233536 100644
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
index 1dd5b165234be..9322f07ddf1ef 100644
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
index 5a2b0a81ae197..8f01abbb00503 100644
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


