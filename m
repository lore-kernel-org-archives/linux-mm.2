Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF833C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D06B6B0092; Mon, 21 Sep 2026 06:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7DB6B00AD; Mon, 21 Sep 2026 06:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD986B0103; Mon, 21 Sep 2026 06:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D95396B0092
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:59:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72A7A1A0145
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:59:02 +0000 (UTC)
X-FDA: 85237472124.13.5D0BBBE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A834E4000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:59:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kmjhOZGe;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988340;
	b=OGAxSPfki3pg6OqL90zLeQR6FwUnml6hvjAg0WmXbdlozOZLu6adzL9/ypqRFZpdQZ9AfE
	c6wFYbHHm+UKbGQVj7/N3SYrJKCHtX7Mn8mVohTqnqi+fjC03oTgSCm/MnqWVQ6/fZabkr
	cTG7aPdZChtm2Zf2MQCwHUph2gOfKjo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kmjhOZGe;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5o7BRqvZemOy4I3F9webe1p/ouSg2QH1C9yt6t24z0o=;
	b=4LUSYtmQiN3OMFqQLwjTFoQXNz5thBTxNwAU99URp82FJruBWiv6l0Dpvysez2mSfXh9fO
	hWxAPRu3gUik0EApUjG48qIJQ2bVQk/27YfsfATCI5i+ayPHfmrr9UQrW4NDm6upiPv9J7
	zVTbADYavHUd5JfzuYqm1rckAd7xWls=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62E391CE0;
	Mon, 21 Sep 2026 03:58:56 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A293E3F86C;
	Mon, 21 Sep 2026 03:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988339; bh=Q9JupG6Ga9Yd5poWoXsf1ojyKybY/JhVHRMS9+yuENk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kmjhOZGe+rvAPdtHgOvZ8+JXt0CRvIYWoLtj8YaQaF0AkkC4mYVfO9EPYYfzbkXIl
	 6tQP27Sypv/SsUcb0h6O79QmKuhdb/AB7Dc1Az8zsHHG1G0Hek65AToTqhTykZhAWQ
	 g9rIbsE9klE6+jtdIrSRugu76i8wias9USMHeLT8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:42 +0100
Subject: [PATCH 20/21] mm/pgtable: disallow calling folded
 set_pgd/set_p4d/set_pud with dummy
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-20-cd40cf68242e@arm.com>
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
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3423; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=wn+xbNqkdezctD1uOfR77s9+bFTC1HhX6zz+en43LNA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1UuhWv4I3FDWdg/j+kldAjB8reMz42JzLq7
 0YDZbKbMleJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENVAAKCRBt1cPRWsUx
 M6vtDACSfqly9thwjD7kl8mtPM+GTHEk5P3hm5m3IcHM/yuady/yC8uUCYqEGqoqo0+xVZg5dgc
 DittGiSonPPEQke2O5H2aGKT7mRrcR7TcXtn312UQhs/CXyL6IytQkZSPwYBo+4XndAU67RxoqN
 Cbsb2z1qPHth4uMqDPK0ebT4y8OryhIDkXSGTvJPERdR6MDhQVkGseyybG2Mk2Ba9mBzPj+/EOe
 M61uV5vI5bCjaQGTix6ZM+pGrQfDWmTcNYaiK88gLoLnHbs2067hK4HrTuFOSYvs+elrKeXkg6X
 +eGlZclNAyJaHSTztQxSdmDlcYZMkFDaIbj3QcEmslWhN2UJGwcz23nYG4e4X4Z0TSSGKhoFWM4
 508raZYgajEUFud/R93/AmlmYmuBoZ2zSp+pZtkt7f2JgxqjyQ0/oDk7EsKaVz8Nf3HQCxEIu7A
 GuAMHSv7/yJ6SXa9h7ifoRm+G9lXvGUSHQEFgv689N84mIZhD8joOcXHWX0dJvUOyz0WU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A834E4000A
X-Stat-Signature: tknpnbhhtwuaydqfyghidhz711tbga5d
X-Rspam-User: 
X-HE-Tag: 1789988340-531144
X-HE-Meta: U2FsdGVkX18nXkVSyVIK2QJlWVrfN7Jw+7aROyD6/ck3W6e9Pnh5dV1/rl2lVnn2csUxsiK/bpoY7HN7q3CnzzOF5OitsdQem/JPuIwyUxFkK7Rb7RGi3MzW8B4PAOMiGniGTNXMoUp+scx97ik1v/jusB7gq8c5Ua88KW1PGVZSBg2ilcTOGW3/xlvXQufUWXOJc+ud+UKyDfQURSUrdDmSPCCvS2SZhPK3Hj/3w4VUuwitWLklqXFAE+CANnorLEUoDrxFwS9IzNOgHU5oy0DygrYLYQoTX+PZBpipvrK5089EZBCkH0hTEvCJpijrvV9e/L+vyu8D9FaqS8c6hUmcVJll5kGepWhVOl8dO6kVPD9GFxu/Y6BIK/KivJXpSon8ST39AbJn/JLxLaC0ZlyWMTLH6ElNa/wujWrlrwYECbuvtSECDqw/3lDgum7e565SpCeAf8l2RIUX7Ec9Nm5TbkSR0Y3GdZDm9XFThYfAuua+7qsRoSPZCFEewnwGVXtLN/wy/3UsN1ToVCQkHvtjckAFQl1r6uniPOdWhaSki0ntaxtFVC4tgSgt8v0rR4AYCyyCwG2Z5yMjdMwlZ9mnuE0/OOOsx/Knrg5Ft4vjDI5O8FmkQGaRV0iCsIKAGVRz1SW64EJqC1khYzhGdfD7Xq762uBmKIbV3PoNAh3t0fnmtIGi8UgpRR84oc+wfGy9sl9i/NZpmFpWFTB6Ar9zs1x7wW4L/y2yW9tDm1IackiioV727CE+MD+M9+miFMzmGnOWT+1bCtmgWfhPYsPflOoOey1wQYFco9wx3YjWbHQmPXUVu11VMn6xpl2xEjuZlfDnMo9H30l8U+GLPZE/wYO1Luq1K9T4amF9I9mNa1oO1A7GafDnC6gcevNGjUkEkT1gWnOOdLGSpnf6dJM0479et5dSlU/lIqXdYhoG1PXyDOtRO110R87vX1LyFUi1UWtd7rSASAkYDon
 Qg4UDil9
 MIKbTxSexD65f5wWntNw2uYc2OOxfIyGP4Cn7lHbcsks0lDxE+/UQCx8XZkfvlYBmQoqMWpXEuxJRCqii37iLh2JonlCenhNsj4PHI9S8Fko+vI5TUeL14o1pBIyughsELw1NQjg//kLnMIp8z6s0EqvVL0gHcnjonIDTTwrDUwyE3fdAAGPDev+nDpFN6xxDz4alC3gPoAWls6UVyJsttV31a1mnFi2b84BJc+XUvOBJ+cngbXxuMCe6ujPzXrDoXCFfMU6/JnDAe3V//PYwkCUnAmWelIWnEDSq1kPFaROJknQnWoZQcPE0S+8Um9qftDU5biyd263W0/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

pXdp_get() could return a dummy value for a page-table level folded at
compile time. Passing this value to set_pXd() could cause unexpected
behavior.

Prevent this at compile time by ensuring that all calls to
set_pgd()/set_p4d()/set_pud() are compiled out for folded page-table
levels. Make the compiler complain if these helpers are called with
dummy values.

Since there are places where set_pXd() is called even when
the corresponding page-table level is folded at compile time,
drop the incorrect comments for set_pXd().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 11 ++++++-----
 include/asm-generic/pgtable-nopmd.h | 10 +++++-----
 include/asm-generic/pgtable-nopud.h | 12 +++++++-----
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index d2dccf7542da5..12b01768134b5 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -28,11 +28,12 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
 
 #define pgd_populate(mm, pgd, p4d)		do { } while (0)
 #define pgd_populate_safe(mm, pgd, p4d)		do { } while (0)
-/*
- * (p4ds are folded into pgds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pgd(pgdptr, pgdval)	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })
+
+#define set_pgd(pgdptr, pgdval)						\
+({									\
+	pgd_check_dummy(pgdval);					\
+	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval });			\
+})
 
 static __always_inline pgd_t pgdp_get(pgd_t *pgdp)
 {
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 2afbf2d8659dc..11b04c1071295 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -37,11 +37,11 @@ static inline void pud_clear(pud_t *pud)	{ }
 
 #define pud_populate(mm, pmd, pte)		do { } while (0)
 
-/*
- * (pmds are folded into puds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
+#define set_pud(pudptr, pudval)						\
+({									\
+	pud_check_dummy(pudval);					\
+	set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval });			\
+})
 
 static __always_inline pud_t pudp_get(pud_t *pudp)
 {
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 3264673c0c386..5ee8f1852cd8c 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -35,11 +35,13 @@ static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
 
 #define p4d_populate(mm, p4d, pud)		do { } while (0)
 #define p4d_populate_safe(mm, p4d, pud)		do { } while (0)
-/*
- * (puds are folded into p4ds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_p4d(p4dptr, p4dval)	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval })
+
+#define set_p4d(p4dptr, p4dval)						\
+({									\
+	p4d_check_dummy(p4dval);					\
+	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval });			\
+})
+
 
 static __always_inline p4d_t p4dp_get(p4d_t *p4dp)
 {

-- 
2.43.0


