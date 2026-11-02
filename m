Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C268E60A2603
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=O6Y5aTQJ
Received: by kanga.kvack.org (Postfix)
	id C78CF6B05CE; Mon,  2 Nov 2026 06:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29AE6B05CF; Mon,  2 Nov 2026 06:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B187A6B05D0; Mon,  2 Nov 2026 06:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78B0B6B05CE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:23:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E584D120CA3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:26 +0000 (UTC)
X-FDA: 85389943212.23.6BA525A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18AF9160003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O6Y5aTQJ;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618605;
	b=fwKcZIUh+cBlGmgOVvhrXq0Njp5MN+GQni6ETUgJ4/zftblVAjYz0KhImH9ncaS9iNXBNF
	18lHdXYzbYQaDIn4z+IrG8wflSD61xCyVN7SHsJp1tphVK+p09tuoGUrkDgasue4r+g+rZ
	rDM2WM6+VGdXl3fBabd06S5axwIHm/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzbkHlCXIOztNCUIQ2oe4PXisYyJ6l3zF3m0g0wGdqo=;
	b=yNmmWCYdEftvuuhDVaPo1kBuOHrlAOVlh9j7wCUCJXqrOAlZWy8eQ57h7QlUe2lMsxjIxi
	TRSX2tGkvUJDTnjegH1f1j3ZeRwg7w3umS7mAzrTL/2d7LEna1/Twd0w9pDWGrtoTGQzNk
	Nqcm41pYRAoPR4n3/iDXL9IdW4+Q6Vo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O6Y5aTQJ;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E0282A31;
	Mon,  2 Nov 2026 03:23:21 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 425403F632;
	Mon,  2 Nov 2026 03:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618604; bh=3qwcredkJP47Q0knCs8r2zQMj6PgEaC6pvNuESy4rVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=O6Y5aTQJGvriCytR9bYPhPc8teP7S38goXBCyi0FrXHhPcgUI/VK5QVSOYRjvKkWX
	 RN0/pAen7AAHAps9w7HSRdvtyoM9DYJ+IN2BHRbHL1MPPhiy2Rrxfh3JKryeMbngMC
	 35sXBD2JouQDrqVQDe9c4jQWSg46NUeELFmBDt2M=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:30 +0000
Subject: [PATCH RESEND v2 17/21] mm/pgtable: optimize pmdp_get() and
 friends for folded pagetable levels
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-17-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
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
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HI3ORBjhDgVhiG8NLXgz+05V/q3PbFarKyI1
 M1+TFxo5X6JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyNwAKCRBt1cPRWsUx
 M4K8C/9RIui2TsgD3POI6zjdB3SZC/Jq7bkgNK0EXZ7pxRiCpRWJ3s+y6XKZKi08pLUrW/0doeo
 f79FzUimsG5sWq8i7o3Qvs8iLUlOerz7iIeU8CLwgackXEZI8Yp1OtC3Pa3eIgti8dVW4HCVAc2
 45fyjV6RiSA/h0N2l5M2E5xAHzKdpGSyG4V1e1z2f/E+xvh4yJaK6PeTyVo7ITroN161YMVMyyH
 IqXfICPAav4K4QcS7SJFjxr11Dv9S5lhwprM4oAiu7UGSz0RWlaI9dA9WIlYHppYNQ9Ep7wcFKd
 PZUAI+/RIF5Jx2eFscXFI2ZijjsPo9Z79NpjqsD/oyBAZVh61V9A/nwySidlAV2yzU2RCgjuTIp
 A6YGZmNpCwkrO+3fkndiCg0vgX5Xw7Tt2Y1osCKh8GORdrTenvXH+Km7wCwjhvE1RI8DwmyU/rj
 fRQb3IcrX1TH+HW+cpEGyHwUcXlzYYKevuYTiKGU+ESHSEFQ6OAJMtmtmxsbgFsZ6yyW4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: m4asjqw4hgey4scrofsske3dmhbka3w9
X-Rspamd-Queue-Id: 18AF9160003
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618604-324167
X-HE-Meta: U2FsdGVkX1+oHqotBOryPoYvFxNKgQ6RFxHfN6XoIGkcF1IE1k+8oONKUGF/hqWZB/pOpuyy0mM9YdHd0sfZ/b61JPd9PTBu+PBFBqTeLXpE4JR24Lb3LFCRjlZBC/NhiGsfZpEuKeiYcrgaXJIs5JHmATDpj6VhzQYcnToxHO06RDOuBxC41ej7p3JIaqp0GNhXfwgi7EACqhoEIX+vcTFOQqKaY/m6zswIGdEjNkvA0b9rVgxG0kPWHdtpzADZkO3k+QyTPvjIMXjEqXyrJm5DotxhCD+5+mVilrc9Q4pe4xhCb9OlMVoWh/DeHafC29fLrUDebZx89WRX7VNM1SjllWzKjIVVfHl8hysM1L5tywNqeJVxwUccg7+Ljduku384rcpV5dPxOUUz0ez3u3hnARdy0rll54bcn20DHIyIeGBHKoLNMkb9CKbVwEcMQwWS61OzAbqYwGJXfRB2ZDtdXrAJWH2hOHpdnoW2GP4S1fEZ6aVskk9l3qK9imNADrW7i1THH1rdlE1cLopq2MAwQ4m7SLQnpaHgzqdBpcJcvBTMVY6xpOTbPgJbw/uhYUy58v7pRb6JLZSFBpTW6fBgaEiNORJDPfP4Oo2MEMw7NMc3hl2WLYM9HPVTv/cC21HcC8ql3yUR32tm8TZDYVYq8EHNc4wtM5p8ZnR1YVI6ZcnCroZWqqPN/JnlpafTIIf69CAOLsAaaN1MYb9zsrk3yqt4y8DAJmU4e9+zMXxc/GJNoFspg9KbCBDCCV6O0heXTEkIkyCd9gHQlcyulwejth/5HlxK/DLce8HvCky9aKkpG4AD932tz5gOekutQnK/UCfM+rYFeZf38u970tymV8aZV8Hh5qjXDbZ+aioxU7Qg6SZ97awgzEviVlPdq2D21919c5r2a7C3/v919INflVoiVHy1o7V5y7KM+bm+oyN/ES0duRNFndAv05b5gUbREp/fK9GEB9uk36X
 PVHkonDP
 0yqhE8LqcQ0QDqRfx6bhHySpqnCzLsu64GC9Aue8ICCVVLUFjpU/w+guyGTUwnBbgnxhTHKYQK1hq0f1gwKbTZCcsnk3hG0K1M4ip7xGqZbIlrBb3UrJCOmSJXV4M3XfRgDS0QeaHEzeC3okuReZypaHOz708mngXSect7ZvAydj48SXIFqFg8np+mprx8XLi1FgMNQGFhoH6GK3iPseWHCgPG+6Yxq08PYMnaCsC/nSLUMLg2aFR/LOG0Be0cRxaBBukD7skbplE4faGcYc6l4hI7A+gBc2FWq179/aRCev0XDBo+MY8HWaWy1qs5o1G4NU79kviC3RXGhp7MnOgkEvH3db+uFY8RiZk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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


