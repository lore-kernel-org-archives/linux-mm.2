Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4516FC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4647E6B008C; Wed, 22 Jul 2026 11:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B4B6B00A0; Wed, 22 Jul 2026 11:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32AD66B009B; Wed, 22 Jul 2026 11:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01B5A6B00D7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 764961C00C2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:30 +0000 (UTC)
X-FDA: 85016804460.09.C9EDEE8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E42D140010
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TluBfn6Y;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cQUbVT+O+EUHn7P9FVcA0+b4cKu7nSUoPbro21uj4E=;
	b=JIwpzoc+8UfMoDqlFQhiLKrq1qXtdZG8vI8djabW/2Z92Se3eXFPJHs+YwzEGSNZlF//F7
	JQz2DjraV4vkyFUR2mwhKVTN9L4C1eb7Fx6tQvJa94WebTTUvu9SBJfsC1OFQ8xGh3SacV
	/DUCKD+PQK5SNzE5n0F5v705dq+oulE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734348;
	b=szmDxB3D/dAW60DTRwh5QLG7SeeCCwmWJW6UI5FCzOFbhwIlBML5NEudZl/YtatsDay4xi
	lcKLNWv0a3JQHEwdz+OKyVnks6yaMRrlf6cn+Btq0e1QV0b+5bdng0lkSODXv9ptw+knmz
	1XhVVS0byrmT4dAj42o8r5tfVaqdQFw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TluBfn6Y;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC0C81595;
	Wed, 22 Jul 2026 08:32:23 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 239BA3F66F;
	Wed, 22 Jul 2026 08:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734347; bh=vWdfZfN+TiiZA9mxg4SsfZFErqbDJUiR9ggvZZQt5JA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TluBfn6YvynnLDcgkk/QGS/YqHzTC1qQOYuWvEjPBaQRfpNlFivei9Evm3MWLvruP
	 TPbqCkwMeV/455tcZTKmsYaC7xvULM9EWroPcZjh24N/EDwhLaY+XZhbJrM151ixS0
	 tRinqhTWhBgUWaY0/Q9D4pc2+OS/ow878qXHsExY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:23 +0100
Subject: [PATCH RFC v2 15/20] mm/pgtable: optimize pmdp_get() and friends
 for folded pagetable levels
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-15-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5184; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=cnUlm8DDOUq30iZM7WGkUZANPR8bNBvx+fV94KySXE8=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIWDgQIN2ellQ1u+0chCvrQkqScLp7v2R/RU
 36cXzhY1xOJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiFgAKCRBt1cPRWsUx
 MyDDDACQWZei5YO99pneN8Lyoq4PWeM8DMKhrvzlE+hATCDxZYZYqyuMtbdAqTyetpmWXGW5siE
 gts8DGY7bYaUgcRAMVhigeJd7bcz7LMDtHhi/u/GW3DDpWGMfA7psXQ6DFVqYMnVUy+wCSNENOc
 SanzIHDCdilyEwAYEfSV92vfl0r239d6VSMLGN2WKD8fSNNn9WtMRLitSyiFRlcVM7uTDQ1D+9m
 swQnX0kJjxZd7fbD1Y0sB3pbgfhBXOnu1b93CBRLKHNK97V0z1hHNLSpcqwI5zeE6vgRLHvCAZ+
 atJFh938hNaw2px8jQNgsNCNI5gFUuCju1bSSlHelm07/m4HUaE3TMUe7Qo9/+h6h5xuytxKnAG
 EFEv9pl5Dr/xsuErnxJQDYY/m3S3fQDIuHvAduxYEAuJC4tT25Q/fdA4f0IMJCBKYgFKHO4WE/C
 BxD1l8i7ha71s9NuT5l/0LKh+2twxhEwhIB1IE99Tv/Df7TZ0p/Yl9HWK5rgCAYq/Y6GI=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E42D140010
X-Stat-Signature: rdh16j9dumawqpd1iudaqdjfnizsr4j4
X-Rspam-User: 
X-HE-Tag: 1784734348-786253
X-HE-Meta: U2FsdGVkX1+Awo3nvExVPEBivx5zG32gf/oFyI7Bd0FxRNQz30qBEXyvd47twCaeExMOSNOuyVw7crhDrdiKGjcKCoX9/2crscdba7KWLmQ9GQlZi4QaVMIjYuS1vhVSXX2efBNHPnVuWwyz80i8/dJa/dz1hvbl96GRBtSxXeafZ3Y95WxNpOnl+EC/8F+9fvZWHu9AZWCy8kMKg28UqUCMxvOTuVECek/4AOOvaGeoUBzFKP7zGcj6c/lchDank0+Wv5P4MaWC9c9Vox2SvJsRSHYk1PPJWf0GK/MoiXEo+qY433cMjB+5zh5l1UGHnI8HxCu0IZw3LVp5s1YcdqEsDGWWbgkxbDBJoOYrRErFWHUi6++7Q0toXRUFvZNBOE3VGfuYDRVDL9LUE8a0F11gsSeM1Rxh/WOu/t7N5no7Xr0ZyDF1lAQTr3GYP7dswOSx/IjcYaX2NWxqBYO1Bj1GKniTZtWuTlTxdvC4JWdFxVCjzCWY0mmgT6vO8OXRV4hh+AYEgpCqc6YN2SLVfGrH3rjR9JxCzDGSC+FZiLC0w5FzAT2r+yG2J8to/Aw/HX3AWuyLt7bxGheXVO6Ey+hlOp5kZmQJwKAxbdow+tGLqn1WFanYyORgnVURYapPLzn97LHzkE7A5y5bhEZfF6Zif633KcAccva8zb6dPP8SHE+k2ole1W/poRrWMIJNxw9yvqep62eiwWG4xrUBgSWzLUkmoVCrCkSUpvAcnWyx8JDz3row1TxMWP/HKPZ0JZ8iG3yXtg8mi7edQqlDg9ap67IpsXEy83DJNVBemu6W0sARKax0iE/DJ2bl/cTBZTKsL26258paQbq50YpUrTZ41vH9ZCHGzfuGV1HxUXwMtkTNwzeHNM5Z1xhDPChU5TFvy2B2eBPE8ZKzPuHdR1VxaECZ38K9JJOxOJFLkbuQup/DbRiJByxZze2iR9uXHQPnypTONyLyk9KCETE
 EEy/D3Y8
 xP232FEOsLZROFfL3losOL9+a68HhuS4HiJMCmVR546h3nQyCGmT3yVBaKvWWSBQbEvpe2zbLZu1hOuu1eyaHCazkloEhOtYtx0pmmgGVrL6i+uQeEipSBU/fNAJ/6JVHuwui43sraMpzdfWgbjhFesM+MVCmiRNIo6dTKKY5VkzaWaCzvzJEgF5RtpfOP3zzNWu+sGob00OSmRBE3ZFZf+4f1pNuGz08SmZP9vhZ1bQjp0RcygD4jhVvvkfgeBQ9F6CqmE10V4LsQhNxmXaQQeR/NdDjhEDPZowKetSEVDEIgsY=
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
folded page tables entirely, as we hardcode:

        pgd_present()==1 && pgd_leaf()==false

Common code will just treat it as a "this is a page table" and call
p4d_offset() or p4d_offset_lockless() for the next lower level, where
we just ignore the obtained pgdp_get() result entirely.

So we can just return a dummy value and avoid any memory reads.

There is a catch, though:

1) If code calls pgd_val() and somehow relies on the data, it would now
   see dummy values. The code really must be aware of folded page table
   levels. Fortunately, code usually ignores pgd_val() completely for
   page tables (with ptdump being one exception when calculating
   effective permissions). We checked + fixed the x86 ptdump mechanism.

2) If code passes the pgd_t to a function that would work on the result,
   it would now see dummy values. The only concern is really passing
   the pgd_t on the stack as a pointer to p4d_offset(). Most code that
   would do that, should actually use p4d_offset_lockless(), which
   handles this properly. We checked + fixed problematic instances.

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
index 019c3f074b77..ab4a826b3404 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -34,6 +34,14 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
  */
 #define set_pgd(pgdptr, pgdval)	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })
 
+static inline pgd_t pgdp_get(pgd_t *p4dp)
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
index ae2eff44889a..711e12e5d180 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -44,6 +44,14 @@ static inline void pud_clear(pud_t *pud)	{ }
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


