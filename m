Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F21C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E816B00C4; Wed, 22 Jul 2026 11:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05326B00C6; Wed, 22 Jul 2026 11:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BD16B00C7; Wed, 22 Jul 2026 11:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF5B6B00C4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8663A09EF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:25 +0000 (UTC)
X-FDA: 85016801730.20.558A07E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 09E5F120010
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lhoYvQT1;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cb+Q/UxqgmupzBTSDcJkSizaSHcBoeoJI19W4Dk4CB8=;
	b=KYqjPT53mf+HUfTtIbRdiExuzmecb4/8YFhRf6iapi75rQplz+YOOYk6j8yAsyBi9ijLa/
	3TPFm7zTIx/u2WiH15A8jGpLzKBjUyiFn/NsvrpWNJ5qOQ89tExtOtRQTtfFlOOXYSNxia
	zrzS9d5h+5F6l7DvGv2SpZ+PYIVlLq4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734284;
	b=o+2ZFs70Ty8XX3MqqMmW1k6VxpUv3G+OZ2JHzqZItBe71C9U1AEPARada3Yg7sw2vAYbo7
	le14hlUqeP+aGBkVmHGlaM6kZKyBqpC4ykoK4mz2bbLmDU4VP8FSFXU3Pifqw5j7FeWNqJ
	8k0P+9Y2g/rDnv1dN7iv4lVdArELfq8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lhoYvQT1;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F38231595;
	Wed, 22 Jul 2026 08:31:18 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B3493F66F;
	Wed, 22 Jul 2026 08:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734283; bh=E1LhS2d41pv7baaV3zaz0144dqW/PG1F+Ej5483Lbng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lhoYvQT1w/IrX0K4Mz20bVq5L/ka6VnXZofM/W5GYHE62WoUBEG5gc1856dbenu9h
	 tVSS3WTWbWEzALvuaSp6JOD8Q7fVujcuj9iL3UuqVm6ykvFbUPP/kKNKoNRMXSQQxJ
	 UMdqAjYwiKk84qvk257x6xz3Y6VBCAiksmdwCXwI=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:14 +0100
Subject: [PATCH RFC v2 06/20] mm/pgtable: define (pgd|p4d|pud)_leaf() for
 folded page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-6-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4436; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=DaldeU24DqLVpaLFh5jtkpxB6dgJTv3Nx5Huqygsqtk=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOISzCmr9D/oZBISBy2aPH6Y1owFEcVQbTYPE
 FQQHENr0nCJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiEgAKCRBt1cPRWsUx
 M7BuC/9DOmwNzErpw4yUvDpTOEudVtnYd/d86z6Yy9oST/ZFBBZ5AqzTOb0jaNKYiVD8Eh9tC4R
 cLuaipwND2meOmSwGJIAMr1UDpK1tzxMu9uOCCr/2v1689RWhx10vpLpS+ix07+j/bL+M8wPJce
 WqnmfEHSBYlYv7iK4SUB/71eP1qm+82qoTB50mG3cqkX7OEzogIJ7oGSmPzHZ42iNeXLSzGUFOK
 qQc20KG8ztyHSgEegHrB6ScTc+qDfAjIoy6skrSo5jcTYdFgcYixmHPKKpfDm8ETWq2/KUuxnC0
 3f/g5pYT/gBj9+bRvVuLVI94mC9MJajCdZbb5xUpVEMUI9wMnt+Lok3L6JkpXyhPBDGDzVTdWgr
 jNiXTd45Es+1xfvezTd7aDh4Bf+UZMQbQ0up4DM3it7nHvHfdoDdmyn3RsBtr+P7ckeuJHA+nEk
 KC1zwp9kX9NDF5dbuV3NvrKIz9KvhUxRqZUNqZGsjm44kk5cEgnPPU0i9/LfIDX/+9e6c=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 09E5F120010
X-Stat-Signature: o4jtumspkae4of9fuedxtknbtymh7nn7
X-Rspam-User: 
X-HE-Tag: 1784734283-729822
X-HE-Meta: U2FsdGVkX1/q9X2daKzwT6fN6F7I4b7blt4JlyTl8S/s8qxlV7inwpFOqXpfjkC5nQbNuMbwXkHaQ9xuVurWpjHLt4AW5dhN+n6nzc7b+THGEsenPbL6Y9IHF9EeeAOd9/U23nq81AB5PGelalqdyc/FWbJ4R5j96SiXbXCzE5MNQlzuQmu0ChcZ84UaWldQpbfs+vWwt//BpeTACuRjlcu+vSc5ccT/zw0Ttzrf8aJb2WP5dPsJ1v3oj/b5cRpNfTJTHvdCQMw7xS+g28dELyYRSyqkZ2irmkZRP9TyENUg3IuqC+n9BfTb+SktfPflEf7wP23Cz+Y/scAYAPbAlwDcXBvRao0hwmNXdY2buMqEAW8PwzyG12U/rRY7qCRfGqzfjFVLW9m4tBwwPeas045llbLaN0jClTQq/WD2V9DBFh/MyfqWVY4WUKinlSg3g7HYUkXxa5Sfi2m+zgMgwyZfYbIM82JWTnOJ60MtMfm3CGONyjmJzozLM6e61Eqze/cZWXuZn2ILg2RiZe3EbReOd6MadaIN+0c3ohWtpbEZnqS8kmmh2+2YHOwo/B74qbE3tu72S6bNVG/h7chtskx+Lp7MVQ7uEngzIe5YGxmJ3PApZby2w+dXwrruOLHzOpdlnl6uVH7ulKp344kS4l+NC9hT+G3xUB+Bzb3SU4YIW00KgNuqh40VUPTRLek84+KwWzhoDA3WSCQuvIpuIM0vGg3A6OKqiuR2MAHCAHtzNFSkW7gD9ZRQQOux/fjgmB72U/CpvAXR/L6bbj1Z+8l7KasA8K9eHRudL5kcy9ePdVXJO2m2QTwf+YHgrzjQ4B4h6BcgbOfqL8ryMeeVCfA0T4YeMtChCtbYu4Ol7i11Pb6lJCYxRqitzqI02dUuAVRB8S2PLaL9WZow4G4JQi1db3/Q3jPK215U3A9rPJ8FIFlntHEYBQILUPTZuIwHmbeWcHVvuidJvskyxF2
 4sU/yuF6
 7nScuA94RQ7L6az8eXzEFJ8/8P1RwC/G9llrC0F/GBedlw1UydZ49QFMFDXanVb+/Oc6UE2XTuSn3dO6UuGIflRs3H5dRAviYhU9HOMVrhDjRxizRazm5xVUM+KdFJv1TesT5gDnbdS5dT1LSEFu92/Po9jP6nErstEWP8C4qzc0yDQlM1XQbmou748Rt5An2qrJI11soXlfmu3eml+PlpGIxtmPZDIQorlGwEREKLM9PC3Xu63JQQWbE/SKc7GNwY5d8pYmcFT1/kZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Let's define (pgd|p4d|pud)_leaf(), hard-coding it to "false". Note
that we missed to define pud_leaf() before, allowing architectures to
unknowingly overwrite it.

Still use static inline functions (type checking), and while at it, just
use "bool" as a return value.

We can now drop the arm64 custom variant that did that. As it documents:

	Note: reusing the original pointer means that we may
	dereference the same (live) page-table entry multiple times.
	This is safe because it is still only loaded once in the
	context of each level and the CPU guarantees same-address
	read-after-read ordering.

We now have the same situation. Don't document that, as we will be
removing the double read next.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/include/asm/pgtable.h    | 23 -----------------------
 include/asm-generic/pgtable-nop4d.h |  2 ++
 include/asm-generic/pgtable-nopmd.h |  3 ++-
 include/asm-generic/pgtable-nopud.h |  2 ++
 4 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a2681d755358..6185fc291fd7 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1188,29 +1188,6 @@ static inline bool pgtable_l5_enabled(void) { return false; }
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
 
 #define pgd_ERROR(e)	\
diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 89c21f84cffb..c6a5a43899b5 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -22,6 +22,8 @@ static inline int pgd_none(pgd_t pgd)		{ return 0; }
 static inline int pgd_bad(pgd_t pgd)		{ return 0; }
 static inline int pgd_present(pgd_t pgd)	{ return 1; }
 static inline void pgd_clear(pgd_t *pgd)	{ }
+static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
+#define pgd_leaf pgd_leaf
 #define p4d_ERROR(p4d)				(pgd_ERROR((p4d).pgd))
 
 #define pgd_populate(mm, pgd, p4d)		do { } while (0)
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 36b6490ed180..dbd38b4c3a05 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -31,7 +31,8 @@ static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline int pud_user(pud_t pud)		{ return 0; }
-static inline int pud_leaf(pud_t pud)		{ return 0; }
+static inline bool pud_leaf(pud_t pud)		{ return false; }
+#define pud_leaf pud_leaf
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
 
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 356cbfbaab24..6c9bca78047c 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -29,6 +29,8 @@ static inline int p4d_none(p4d_t p4d)		{ return 0; }
 static inline int p4d_bad(p4d_t p4d)		{ return 0; }
 static inline int p4d_present(p4d_t p4d)	{ return 1; }
 static inline void p4d_clear(p4d_t *p4d)	{ }
+static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
+#define p4d_leaf p4d_leaf
 #define pud_ERROR(pud)				(p4d_ERROR((pud).p4d))
 
 #define p4d_populate(mm, p4d, pud)		do { } while (0)

-- 
2.43.0


