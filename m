Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47899C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598AC6B00A6; Wed, 22 Jul 2026 11:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571546B00AB; Wed, 22 Jul 2026 11:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413416B00AC; Wed, 22 Jul 2026 11:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA2C6B00A6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:30:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7F47A022E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:30:57 +0000 (UTC)
X-FDA: 85016800554.09.080D892
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 912AB1A000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:30:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CMfDyJKB;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdV2FIFlTakMis/qpvguP7xNCQuFeuY9fg1uBxacOps=;
	b=unjIy1QgivJu0pcuodbSeKFAvS3qNu9cZUfX/mZ5azlAFAbZ/xBJmRshA2peIeH2PaZz2s
	btBkQe56hQCVR3F2S36EcfrFEEkSNOJMjAca4VXoXvoOFFM8lD1GtMkI5U8gfYxgsA6p4a
	ayEQ2ZISflhR0Ug9ztMp/iMlVgDY7Uo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734256;
	b=e1oDO/9FUAg3dxOr8Pcxwznu5f2lYsm3wUvCe3EIUgLWEYOmEuLxt2ZyCEBzMaabpQ9QkD
	UBSaF3ODapSfBrt8e1wr0vIPzGO2HYHDjOO/aXS43Yacvd2a1TPEB8BsmQE1EdzHaZ2FeL
	psEE0HQlSAue6zvgbsmD/GWaY/Px5zs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CMfDyJKB;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 914D81595;
	Wed, 22 Jul 2026 08:30:50 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEB983F66F;
	Wed, 22 Jul 2026 08:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734254; bh=NwLzJE9YUYcwQouyyHhdNDainQ0wboh6oH5R8Qr5IHk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CMfDyJKBKmK50YTcejppNKTrTWiJP57IF6DHVLjdYdB2gqyRXO1180hCz77V7dhiw
	 /Rhc6XGpzTsM9UJ2o8cGBXNsPlK7hInWAm0H7N+W5Ya7RehIy81zPyYAERNZ20t24L
	 nfvmJqhMmxi974lDKs5uoKjcVHSlsRqupqgSxxk0=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:10 +0100
Subject: [PATCH RFC v2 02/20] ARM: mm: make 2-level pgd_t a scalar
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-2-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2168; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=3A02R9gJAFlGYYgA2zmEeHAxV0ZhWViB/KSchyi5T/4=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIQeAF4NvX+ghiLdlZcQA9dzdnJsUpGO89IJ
 Z0P4tNZzvGJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiEAAKCRBt1cPRWsUx
 M9cgDACmrJH7vGtwlt1q+G75J+q2g7DLACRd8qQ65REy5KW9VbVYXXmBfsv7k2aacinnF+IUr1m
 w3DvIXTMScFAlv6aZMEIqzXU9KuPuo24JNo8rMNKxi9T1m+acBCRHvLvSO2xL29IrbZAcioI4Wx
 p65yuAc9KS13mOJr3OIKeTM2uPBpc+Dm5DZte59tUdL88pUcKmgr5jOzWyXYdMRsz3hDwLYMW+2
 xxjo5fmXJlXgap750FaoM8rT0iXoAT6YJTKSXBHneNtHjfELNOmnfR3FouecTJpQYreibBoY4Go
 wTzx/VMNWooLYFE7j0Suwe4IRqREcwTjIE7Sy0K+4hH8myO5maXRxcC6QsnckrWLVBUFmQB4lFH
 /yAaiETHizvEjofTsL+JjwiTrmaQq2gXigwhquNdb6UYzqGvR7neA73xa7ugREzMT8ojGHpTpOr
 l75oD4xe0+GWpdz7MWMp3Wqtq2t9VjFSsaVZperSbQsuUsnnV9f1oO35vpoX6HoDyNfd4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: 912AB1A000C
X-Stat-Signature: yhdhiegb3bm9sbj5wwbr6eez3cgk3xnj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784734255-454570
X-HE-Meta: U2FsdGVkX19geBr2rpxbp2/hWo3T313zXCMQRKwaxuu3+PagK1AJ0vWrRugpAargGxZO94YFfGHL/tNEc04jJ5GbQnaVOSkRahqEHV+WzKwzfAxEvP5CFy4iHcVov2ogDsYLfsDE1FObovP4/ITOomWc0QOUT036Hud074rG4GQuf7UtA5dCauSJ91pMA5gM6XY/l8PZofxjHgwiG8zMVSWjPHmzCVbpeI4bWKLFxEUlkW9cL6ZKfEV/7A2UoGyTTQwAsqlhFf5+jRC4znORZn7jDxCBfIynrDtvktOzgjUycme6jdC3Fhsap94kEKSU6SrVF+t+J2x1kUuJ9jkc6v2FQc79e55wlgozSB2ZkqYg/RCnXnECQvIAk7Fn8oKn/EmC1jp2iXPoood9Ypm+RiWjdNAYtYN8ZBuI7YK/LOUiavQNtx2i0PH3fLHuURZtad6HbkYATpIm8ZB5hNU61kDAqvgVaNJtBBggedDGu4LIlrzDlCVdmkLLoaKYP/PweSaURKyUTtxyOGw+5xVHFsTFBP5Ul+PDb1iSl8eUIVZ8nMMbZ9VLirEvS9iSXACn9Fb7g7gDx3joNfyiJL5ckcxXu92gQQd4o7rsoeGqUi3oc/KCst24mZTLPdiaF4jctTxYJwuTqrgle6JxLnK/tRnsCXD6AHzBCZevdn6wb3F1EfryOhl/b/QmAGoVeNJrXASOUKJA8BoF0R9xzqY6nfhlvQvT/ZZmLnkJf8qL1aIHn7vi0NYXDCkBr6DLt0XjoF4ZxxyfSV+0wb2Np8w/U4Sa/BiLh1C0BMltph3Mu/f6COE53ZjhpIdGH4jmXDuwOQyRpUQDsQzzgi7ExTgya6xBrhWreAshhuIDfeOzbFmm1BV1BXzsIQFCR/vit+fKMyhqZ18ET3QGw6MHFteW+EQjCo0GJwxdEPbfdjXT8NP+SKKBLLBL6xdNSTpfd+d9Od3xULIvsprnlS3r0eB
 EEUMX6Ge
 IasSbPQ0LnbGg4ttKOxNIB4HAksRGLk9I9zBsGizGQ8nP8/mV6Zw7fZHltl/JCae/c8nbmtfzRtwjKO4MfkfMCyl7+E6pdP62Y/TPmiYaF5x72ruSpPYipi8vZJSbvhyFLU0auhxpPAQxc6PWXHO0lNW3ao4Y2G2QpMeBwJy82dljEZ4uSfBSWJMxwzulz4cwL2sSOohSz+M4pDhTcE6FdRHBExnbgqgUTwroZ1JVWlduopd0UTxiUYN/7U98YQmsjEwyX5Jvo3KhDHY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

We don't want pgd_t to be an array, as it prohibits returning it from a
function, like pgdp_get().

So let's just use an u64, and extract the right 32bit value in
pgd_val().

Leave the STRICT_MM_TYPECHECKS case alone for now.

As an alternative, we could use the STRICT_MM_TYPECHECKS approach here
as well, but using an u64 looks conceptually cleaner, even though
pgd_val() gets a bit more involved.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/pgtable-2level-types.h | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
index 650e793f4142..7f85384ac386 100644
--- a/arch/arm/include/asm/pgtable-2level-types.h
+++ b/arch/arm/include/asm/pgtable-2level-types.h
@@ -25,7 +25,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 
 #define pte_val(x)      ((x).pte)
 #define pmd_val(x)      ((x).pmd)
-#define pgd_val(x)	((x).pgd[0])
+#define pgd_val(x)      ((x).pgd[0])
 #define pgprot_val(x)   ((x).pgprot)
 
 #define __pte(x)        ((pte_t) { (x) } )
@@ -36,14 +36,32 @@ typedef struct { pteval_t pgprot; } pgprot_t;
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
+	 * The lower and higher pmdval_t values point to the same page.
+	 * the only difference is their offset within that page.
+	 * Therefore, whichever value is returned, the behavior of pmd_pfn(),
+	 * pmd_page(), and other users of pgd_val() remains unchanged.
+	 *
+	 * However, pgd_val() has historically returned the lower pmdval_t, so
+	 * keep returning the lower one.
+	 *
+	 * See the comments in include/asm/pgtable-2level.
+	 */
+	return (*(pmdval_t (*)[2])&pgd)[0];
+}
+
 #define pgprot_val(x)   (x)
 
 #define __pte(x)        (x)

-- 
2.43.0


