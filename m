Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DE2C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3296B008C; Wed,  2 Sep 2026 07:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6CA46B0092; Wed,  2 Sep 2026 07:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E626B0096; Wed,  2 Sep 2026 07:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A720F6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:56:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4352C1601C2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:56:54 +0000 (UTC)
X-FDA: 85168670748.08.211F02B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 014F440009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:56:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="JngvOrh/";
	spf=pass (imf01.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmJSRs9kZhlK/7cZ8ONyoA23988wKKHMM3sGINh8g2c=;
	b=KixTokDqlCq8FptvMTrXyWt8I2JrrgyvONBn96aegxB7tKJ4DIhb1akQrJF2p0smcGSNgp
	fPS5duaP4Bk2ya8JOaIB3dnkCbeQG0Rg/Q+bAMQt4VpGR8NOQ9g9JEOpACAxHKwbGPukbq
	jyaJZMENaSIN310XIAxMpzK8PhMkow4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350212;
	b=Qgc59q/otCeYX280jR3kp+XXpu/Pa7FYpyw1k2LtnIgn2VYy69ma+lh2ovhrAjqcB0FLUV
	pvJHw9cyi68rsVIuePHX/PZafwcRocfCrrJ3r7x+59WMfz0jD/7lZJj8YaqKulxI/g4l8K
	m3db8TrwAsWFN3EwgNPYnjdMAiBxdmI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="JngvOrh/";
	spf=pass (imf01.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25B9F1E4D;
	Wed,  2 Sep 2026 04:56:47 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C29DA3F85F;
	Wed,  2 Sep 2026 04:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350210; bh=gPlnE5UqZRk40YfWFz/1w9GlKcNlqtJOo/oAxLycbvE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JngvOrh/7RH2K28ggppoS4NPOaZa16P0lMCoxQdm8Y5sORQtjxmHS2nRWh7A+nD4U
	 lR6pGdNIo04IsFUKW5Iu2DeZy5RCXDzqAoufI7eiLPS9ULkCP3Objs0zsXamRb15xM
	 79g8rzGAvghuXLj6fzSyLmOEqrVRnC+EMjOuSpSI=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:04 +0100
Subject: [PATCH RFC v3 02/21] ARM: mm: make 2-level pgd_t a scalar
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-2-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2017; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=uhcO6NTPYBqTkI+U1pSNHYmMsIjTOQrElUAua45fg4s=;
 b=kA0DAAoBbdXD0VrFMTMByyZiAGqYDuKh4pUBsXDB1v/n9ZVHNsXgpbZHusYBh6IUK6klb7xYB
 YkBswQAAQoAHRYhBC2D4JLdBTO4WHWknW3Vw9FaxTEzBQJqmA7iAAoJEG3Vw9FaxTEz0BQL/2nk
 sf3h4xmh3cZtnS+lTvf+itMKAMxUvApGWmC4Wv39xE1jps4ZQyzWb/SJp98V66g00L30MWVLQgD
 tat6tOwX2/q+6qy17JKwUz/7i6TzD/TZzQ32xBFcvYhluUlq4Pz649NjIZ1uEl17UZziViJLQZo
 B644h4n9Wc3Fi0IzgaW+5KhHLWdt3ZRDR4WZpZi7IjFTFL9oWkZy+PhQQbx81hRv7nsS9YwgULP
 fPyvywMC5/BRNiJv4Bv2rw2drYfgLwbtkRYVXdzToW0jskEmlweWHUbj/LEfWkimMjxMWvghuAo
 Oeu5Ftb+6z/NoWkVWxtiZgTWcKlD6bqJRc4X95Ub5E3L9cgOVL/seXRA+oZwAczjdUHNqa91mAl
 pnh0MNHv3f/9NAQhLk8LtdSDcYIXBjJ6AbC+3whUFU8/q87D2oQ4K6sGHgvH6W2nYMjrBVc4by4
 tF8lhm2Doykt9IqmrtjwiMUDhbIJElBOahrbMYMCzbEgkFh+2nRz6QH8GanA==
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: 6ybmze6ya8oki3oxotu7jugg3o7o1uhd
X-Rspamd-Queue-Id: 014F440009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788350211-810004
X-HE-Meta: U2FsdGVkX1/EhTOQusbOVeS1fCRKp4JVDxSs9ouNJ4fEzUYn8L/CA01YTqXUUhBmgbJ9bCDaqnjqjYpt+tDl2fIzxN+6gvwE2UVZblfNDRH2ihJ83pzm8HJvMphCNYteWngl10CR3Zzah6pp/vb3xDGYzo4fTZluMugU+P95MNBdr0IpeageLVp36MxhGw0f5izp/O3ggmCjeBRbFhfnvIwrbmvroQsDkl9rZ/HwXIPZiMf/sjAniTT8bDOlBO/7hUkUitYhGtlX55y6+BXOjJ2F7/IOhayKMBH53VfQSHbWrDiXkadCpSDhsi+ja4G0BLjI4PKjaPv2oqLUjoUpekxih4arc9Yn4+DuoEJrk6Olh4CHdqDE6N4PrbRyg0JWO45r68TmNe/oEb1gOixaqYjYmtSAFbQAdoNq9BBD7Hvn9VNXGYqH/ylYylFPM72fEJGA5tJgo9CH23r48kVj9rfF3GmfWHAdsElnsvFPKxJNHqeTmjrHwr69o24IcahIxC9CxVmiztJ26XoYOG4gqJ8i0Ex7KGe82QeTqbMeBQDSUiR+qzJSRTY2naeHWREZRCkLAeMh1R1B0SuzVOWyvReTMGVyfsVu+aDf9t/khejAKWktHS/QlIGuCQ7b5q6hm4WSFeGSjJrqHVq9+anoZarJe8IssydV97ZSHhPx6RFvwUeYVcWUHdRpOJvsA2EO1FmdMSJleCc5zFdpzyaXzVswm+Tg0utLhzTM/QEhnSGbBxSKGro1G6Q8+yAMIIGxLw9fftbCtXQPYcDyqj+ntC0juTl+od2AexfO5825usSbwVmOexYzUg3lrBnWCJmeRSQ98DjrXjNmkDtsx5oXW/sI8Pot4t7apYq2dZspJbxlaAYHySE4466vX6VQYH28zeDaqCyEtLPSszvJXZ8eZ/Pr79l03qdGn0kdgZWsUjrBBzVjNqzxcKcVHR/c24xn1lcDTZ+zy7KNXcODiB4
 3P0a+koj
 YYs1LZMbQRIelSMiIXMXrCIcCsaxaBvg08AnLLYJyXeJY0oBPg7FP40ONh71R7UY+lzDpZyp5MPamN1e0bYd5/kc+ajF1WE6dBR87xwW7MaSvGgceKuDu+0ykCh/061y3uwrwRt1ZefdBR10U6eAKYvUW5bP/hvVJiewothoKb+A/cnFkb8tlI1J/WGKMGuTJhy8+u2uSW/i9wtjYLDBhfPRuaQy6CZu88Yy+VX11HQWT50DLH8Q32RE73XDpz2MsZs+BNppbg+9U46A=
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
index 650e793f4142..805044ea315b 100644
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


