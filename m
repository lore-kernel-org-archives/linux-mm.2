Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A802C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749FB6B00E5; Mon, 21 Sep 2026 06:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC936B00E6; Mon, 21 Sep 2026 06:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B356B00E7; Mon, 21 Sep 2026 06:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33EC56B00E5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:56:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B975A160144
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:46 +0000 (UTC)
X-FDA: 85237466412.11.9FD2B6B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id DDAE4140004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jmExSGw2;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPgeco6QWHwjQByiNB9RkhOOleyP2xs/e2xCzbuUZiE=;
	b=cSqb7tKFedMvko9v2rzdOMGpd3voSXkAQr+pIfhYZGnvneN+BPRj6YVYd1Z9q7MDUo/BmI
	RdxlthO6MVay3+IDZlRVHyoMRJj6VVB+3oeyRsffo8z5RMqAieBnHS6HX2s3n0SBOnbqDU
	dFRZORmLbS1XERMhZkl58f9Pgc41ves=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988205;
	b=FgQwJdQWw6dzSJ7mDxkjQLpf1KA9ch6vCr0+Id0GAdJScb1FcRC9jDaUhlrTjHDUaGiZ0Q
	bEstUrVYTKyUfLna2ZZqLxnhHhrPGSljW7JpwkQMVI5rjB3IMwIzJqcY1Yhyi29rnS8crJ
	wdxBxuG8CbBzUnB/3NbD2UBQMwuzD5U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jmExSGw2;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EC071D70;
	Mon, 21 Sep 2026 03:56:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC3F63F86C;
	Mon, 21 Sep 2026 03:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988204; bh=MWIk55sq3Xl5IhFPSCZgQqnLya5ldzX0H6ZlzYM7l/s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jmExSGw2LCoPoWhLv7wl3mcvZhvvMu/EFGtYz/YIjBdIYLmZ8xYhg+Bt8Lk13zyPM
	 uN6j9Bi3PcRRphGGPrmscaNUQ1hMTG6ePRq5Ad874ubG9TqkzhXg+MtwYO6s/uX21/
	 w+FObAyJbBmnpGp1xy4Af27ePeH4jFFQJWayxXdA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:24 +0100
Subject: [PATCH 02/21] ARM: mm: make 2-level pgd_t a scalar
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-2-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2019; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=4Z0osGAP3S0civxPu6dKKFX1qsd70Ol0fauRungSauY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1LPMd3bY5l97IcQgb37uybVOO0YHrmaWze2
 pZkKGx8ILSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENSwAKCRBt1cPRWsUx
 Mwi2C/95zvtyR94wqriOwlZeIlIVdVW5IF05ARsQWsZciGmadMujO3xVKbNNHmP7n4X6txHc9Bt
 1yPnW09kbOfe7xYWAPC4nw7e/Hz3E9vAZKgyIA+coj/w3E4SPS7GTyJ73zHuaoDvwAQEISXVRPW
 Pc2D0qopExouM3mWXINlfYnSOrYBHF4n6Li9Svio9m9EvcuV7NFR6d7+63k62CpNiUtK+tbIl0T
 RjaODkF1exxt6WziJl3rlm/T5QqRmjtA7pQyQ0EsNsVW91e7QgyT12RizaKDjYq/R7+ybfAinCt
 vRf66DRuwomc5tDPxoUIYUjiLa+sJLJr8TY0hv+mQ1Q4/4hMCPHnlYAGZShYe9PiTNmx6Mebzaw
 Uf8pO5f6ifwoPDZYfnwsLX3DPUMkDWnDejDdUiskVvMfbwCSuyIZeeDy3cP8ZxoJbVzyOdfp5Ok
 0ZzHyHaELLDw/lpY50IvDiCohQ0OsFlKpDv5F9Z6evbkrsXVyMpScSsKxaQVtexaZTtl0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDAE4140004
X-Stat-Signature: c3jsj5f3st5hbjiqpxcifn4xr38brd8w
X-Rspam-User: 
X-HE-Tag: 1789988204-596534
X-HE-Meta: U2FsdGVkX1/8chRfQQ5JNWNLw1nXbny+PjT+Jc1wj62xseHsjSv+vZ6Bv6pI6PfUMNA3a/GKLtPkPllbfGLZz70GSyGzMFloaENHMsXxnU/Kxyu9JCB2psQRbbjnrjF8i8GSKdm3QRdYQyHmQ22EeZ5AHqnCRQk3n9HFMITxr1XfJpzduPSQ/LYpuT3i4/gXchHCmngTyOrC5uR1OoaNafR0TNZtu6kWptbmYOU+4ll6ec4Q0BYIJTMtinpLnz0NyNqjwb3oeKfnmVAACEhW4sqjhEQH1t/uEXfzgv/corR0H5B2AC/RhLqMIYuhx8vPrAVGOslnQ+tSsDugvwrRdYx//x/ywoSYdFetylc0xCLnEdCKp/4y+jj9xBuzxn+VCEm68+rlj6P6YXUKXoBKs/cRn2H1JEfuFpxRPIIkp2O1rUYsVtHxQ70ymxSTVShBe7PD1RjWjc2UOqpOuRzm5Lh2VTMsfbc1zsCBkmwAEwZczmNk02GiGnf8Rc72CNEOo7E2F+zbiMYwM0fAo81OYadNgCbccACqQ4scJ13AzEpZQYBSYIQi1ls5A8QgsQV5Kp2S/Sf29a4jFvGb8Ekr8TlV0tKcS+es16kdmjAFRFCiR2XaKcHz95+7S7tSKe8dBJKJz1woeZnmZwll0xyQvbb5U1ZoXDI0n6INSpYSaI8m6i/DjtrX43VSoMjlMieuXu+RGVGYZnJD2zH41p429cp2eTeARPrlQ0rG90C06zpWUHjc4GvBj3wE+uj3TlEWZ5JeifM6AgwwDVd4HFs34bHFxW1KCrgHSid9nme0PcJqbuV6KnzW9PuFqXx+qB/2UDWov2+yM69UO86xxIsp+Uv96/LX3itpUcgUOm29G+4lFe31SPpWuLxNeDph7AIYqv5pIZ2Lrr5zmdCQo7dK5PwRwRvstsWS9Up2swgpkbvtyTw3n8ZkQVaeZdH2LsY3ZWSJmOuwsyg6vMTygdr
 E3sv7/XO
 aD74bYoOif4FKYQiKVu5s8zoM4ye+gkWQVq0sa7Wi1drh6IxpWTs2AZ3GZ/rqMenhLT0ijF05DvdWL758Cj2/6wmdT68i+7IUQT/KRbihMbw+wHeWTG/Zlr2V1P7UEMjVIaF3rz8uIudefpx6vwCqGyKUpqo2BeJqgm8DEr1sdTjFvhapiopvDvgEu2/jSabwK2RJJf97+n6SDehnWzQA5ZuswZmCtMOmaUL8csPjxe3pvlZuN9ETAli5HTo7bcIAQD3vFR6T3sj7yZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

As pgd_t is returned from a function like pgdp_get(), pgd_t shouldn't
be an array.

So, just use an u64, and extract the right 32bit value in pgd_val().

Leave the STRICT_MM_TYPECHECKS case alone for now.

As an alternative, the STRICT_MM_TYPECHECKS approach could be used here
as well, but using an u64 looks conceptually cleaner, even though
pgd_val() gets a bit more involved.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/pgtable-2level-types.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
index 650e793f41429..805044ea315b7 100644
--- a/arch/arm/include/asm/pgtable-2level-types.h
+++ b/arch/arm/include/asm/pgtable-2level-types.h
@@ -25,7 +25,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 
 #define pte_val(x)      ((x).pte)
 #define pmd_val(x)      ((x).pmd)
-#define pgd_val(x)	((x).pgd[0])
+#define pgd_val(x)      ((x).pgd[0])
 #define pgprot_val(x)   ((x).pgprot)
 
 #define __pte(x)        ((pte_t) { (x) } )
@@ -36,14 +36,28 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 /*
  * .. while these make it easier on the compiler
  */
+typedef u64 pgdval_t;
+
 typedef pteval_t pte_t;
 typedef pmdval_t pmd_t;
-typedef pmdval_t pgd_t[2];
+typedef pgdval_t pgd_t;
 typedef pteval_t pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)
-#define pgd_val(x)	((x)[0])
+
+static inline pmdval_t pgd_val(pgd_t pgd)
+{
+	/*
+	 * A PGD entry actually corresponds to two PMD entries in the PMD table.
+	 * Both PMD entries point to PTE tables residing in the same physical page,
+	 * but at different offsets. See include/asm/pgtable-2level.h for details.
+	 *
+	 * Historically, pgd_val() has returned the lower of the two PMD entries.
+	 */
+	return (*(pmdval_t (*)[2])&pgd)[0];
+}
+
 #define pgprot_val(x)   (x)
 
 #define __pte(x)        (x)

-- 
2.43.0


