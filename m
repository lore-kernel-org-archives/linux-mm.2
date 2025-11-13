Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA7DCD4F3A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199288E002E; Wed, 12 Nov 2025 20:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5978E002F; Wed, 12 Nov 2025 20:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18AE8E002E; Wed, 12 Nov 2025 20:47:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B55E68E002E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BBCB140766
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:23 +0000 (UTC)
X-FDA: 84103896366.29.E8EEF1F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8872540008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="Z/jNBR5q";
	spf=pass (imf07.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZB9Jv5e+J/nnZHZhnhots3i8EjJxTeX7spRmBxkznRQ=;
	b=ILKddCEkCWqmmE1m0iBaGx0IspU3mOfevFkQh74lxtQWJ7QxjkzzRSovnK5eS9wCMoFEJL
	4vQLLTF4cnwjwpIXmW87Yw8daLiDqcImfTZwS6BUJr2OVF52uD2s0rrEM71jG99K8twEKH
	ZjM/GcEq6mr+aQDie7oeh7/U3mtf8nY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="Z/jNBR5q";
	spf=pass (imf07.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998441; a=rsa-sha256;
	cv=none;
	b=AvWkJl4fLdViijVp26Sdd7KtK8SIhbvhumoNRt/sJmallW6HEuHIbJQjWwyz2QOgU5k9S9
	Gh6B+SFT+KAWyoxNLh5VymxUqCdE2siBHNUOX9xrED0zvEeJwcd3YERkV8QkXttFOMBcbh
	9w/AeysAXLoX1Yx3cbh0SJBaDRYPdBc=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29853ec5b8cso2768525ad.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998440; x=1763603240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZB9Jv5e+J/nnZHZhnhots3i8EjJxTeX7spRmBxkznRQ=;
        b=Z/jNBR5qohnmGpOlV9gTzYO9lqFzNPYfO1RadqpSMvpPCQXT9GCWhydm1Ola7dJ4sU
         b2aHvTlGTrTKHsN7t9MNy2uEvaRDifU3Oc4l8uqMe+35EIWseb775f16I/k/ygfI5Wqz
         Sp0QWCXAjedNNL3Ik7ZY8Kv6UJNGl6DVcXR+nG8xJKx0T46ktGdJ57UT53qvoK0uV8oD
         SiS0X2uP8r/aP3cA1tyd8BAowYPlqWXZS6DrUDbjAmN+5auUdWVXloSrFEpN61KIK21l
         DA6mnG7OBCduhzeT00UAvVlCs7NUHo/jibanoAFOgjPInW3ycssBcYDumS3p3N07gTMP
         OySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998440; x=1763603240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZB9Jv5e+J/nnZHZhnhots3i8EjJxTeX7spRmBxkznRQ=;
        b=J9/hJGHzYvXpiCF7oq8XobMlo15eblsM1lrRXSKU0he6X1m0iF544N/kGdOXeWoTyL
         R3AfIYYHhn90wyBiqv6c2jYajN5WGnKv0N+k4DBCxZf2zFutNOalXNhJNA2/dtEpcqi4
         CJPaNYtAiLKE6DC4X1BJQpiMl6WBsMEpTd7MzOEHT62KMTNgIktY1e5Z4ZKcP/iSjsoq
         DbJiJDfwPgzzJBTqSkNOlLP8cvaj9tKordP8bg/g5OR3hWSpWoBMx7rldC0S12Gs324E
         57gzlniCBYhsDKL9erg41epb2L60g21gTUWF464Ip+7b7WZvlrDmIgVzwG1iJzPXScEl
         YRiA==
X-Forwarded-Encrypted: i=1; AJvYcCUe5jzslluHjBcb9Kmi3TnTps9zD42xg7AL/62SnT30ttuntZIo4MMW5oalRH3YJMBczW0kUPgMMA==@kvack.org
X-Gm-Message-State: AOJu0YzAOUrM8b7VQZuTMn8DApsssMoldy0jxpAFLGQnctcN9FL1/yWl
	m27YtvmsHTs7wZGgEJRZQanAGgU6adnlv6wFMuQ2E+/JdVzK2tk53SN1I4rs4vPvZXU=
X-Gm-Gg: ASbGncvOeBW/oYGbaLoxksYZ5xI8EueDKGHem5CYJCwtDn4DnMEENSmDVf2N+3Q0i+h
	yBUORHILG+EswpBiGNgWNOU0OjVv2lGK7VmdTqDsgZzgSvTyc/VQRCWtRiULjIk+evbj7+siy9s
	RoC4bNZfLN37sDDLoHxbAzyinKPNaYEwbotL1J2oy6AynU0VajzUYLorkgnOks+VqcaWghYbOhJ
	OaEcFT3L3QBhjoP1KyKpjufB8rVdiUe4fWn/vAUrLUHk6YihfwFvJeH/YkhutWkraz633bMuJM+
	U9xxosKn1bMJNuKMo9Jif4y3EANdhWR7XpIwX0nCaPJGRXh8ygLb7SIPa8mFIFhN/s8bUC6s4uj
	MbJ35UQ20JI504hWp4e8cVE37m0pRx6sQmatSoMdvR8jMDT7Y7sc9g9jvH5pfk+Ay7A+hYjTCoJ
	J4fPUGLQV8yKfsrBF1xJAX2g==
X-Google-Smtp-Source: AGHT+IF7iLJyShxHKC7U969MaIOXMFAFaPrs9T06x1cgDMhJWNaYEsQEWxTnOb0Z/OpUrPfiBHQTzQ==
X-Received: by 2002:a17:902:d588:b0:297:c889:ba37 with SMTP id d9443c01a7336-2984eddda58mr63974625ad.41.1762998440376;
        Wed, 12 Nov 2025 17:47:20 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:20 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 14/22] riscv: mm: Fix up memory types when writing page tables
Date: Wed, 12 Nov 2025 17:45:27 -0800
Message-ID: <20251113014656.2605447-15-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8872540008
X-Stat-Signature: rknzh6x851gmor54zh4ngao99pykgk3b
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762998441-680736
X-HE-Meta: U2FsdGVkX1/3CBhkFI4YUT6W9tzS2iWCCKi7RkVRdY6fGWRa7F8h+Qve+649qGlNNvRnlRw0Gp0ys7WPPGu+TNTGYrwxsZgaLzxUZItcid6XtXdjBy/tpmWoTX3CzjclCi0k1FltS4J+yLMkmmwLYdn4bCcgRsJW1RH6BB5JXoxD/Xrbu2F1YZlHKF7hjEvq99ITEQgopCWauU/TeZsMK86cwQrHiwQl72NoA7uRQxHGzHxI5mifnfHcoqJkyP3FTq9wiOcfIKxef2TNA5XsXKbXF1jGxqevXWxkQyZ6OCc2K7cAEPFTQDq8icBhfx7KM0oCPxBAtC0BolvjiTbiIIQYvkGWXdq+vsPHgdK2szkO2Z6NB5bqWDueJM3Bj4qW9Xn57aEfp3Ldkfcl1zGyOgGOtnRNdZDLAW9zinz2JY3/2ctC8gbbzs3/zDkvNj1B+K00TyNbjWjs7HXd9xXhvxMSd0h9a5JiiE7FiysNP1n1z2+oGz8zMgijKSTdIDxUkulB4OAP/tG15F7slUTGhJ436HJklBVmnbe40Ofb/yvFtD7VsffyPHw+MMYHSPfUlwzfoVboApp6BF9aTXxFN3M83GXO8nk8J4Dv7ecR42nEITuj3g+DGEYN6GUw6UbdQnlvd1+HrcsvODf2l2+Y+0hK/l0fRMnUWsPTw0K2qPW9t+iTdiH6W5NrBmo4GH32HUFOXB83YOvkhgSRR62Kr/AC8iGTUdDI3MZoNu2CGkSd3YVHu1tmYqi8mUXoJma/JLrLGzmF8fzU9v1Gc5nHZy8ymeBl14NY8vZApvomzmw3KGpQi5EmYRkgbYBqUHM1YPxYJ1x0oJRNRJD2YDBKPerAH3GTy825+HlKtfhBiA1K0ACUHxo9iNQVAEmeLjFdSusKnacyA6r3QXDZjmhKNG/WzRRc0OCkjbrmycyLTHzjg3MflPTIf926mvLG53KToS0bJbnT7DRyjdmgaML
 1Fst4LaB
 ROIr75lNVkZb63GddZ2H9xolwExLBNME2OH+go9GCwKdeJmREy0lnSSNCiMMNG/ofZIFFCuxhmRSc6GNNIJCVlrS+hQHArfszLld6SawXkQCuM1+yFmtB0J1HKReNcV9y+71kOiirzRXpvC2f3IJ2cRkHOHEssNeOG3Cn1MJJtROhjmLpRO/uXe488kIlupNRmD2NADXHFLQGy0u4H9lNvS6WNuDdv800lRRN3ka4YsZqY1kAnSlMQeCU+4ggBSEn39J53SX+Tz+G4y2RJJOgwxW0p6huoO1B13F6VKyb9bqvhyFR2w/MRHGtnhC7lDGlVk7PYv3jocrRWV0n8tzFY85w7FaiN6YipiF79rfK0jYDryajFCCJmsI/Vs5Vo0akeJXpJFWPzHTYEMjsTkcHzUaG/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, Linux on RISC-V has three ways to specify the cacheability
and ordering PMAs of a page:
 1) Do nothing; assume the system is entirely cache-coherent and rely on
    the hardware for any ordering requirements
 2) Use the page table bits specified by Svpbmt
 3) Use the page table bits specified by XTheadMae

To support all three methods, the kernel dynamically determines the
definitions of the _PAGE_NOCACHE and _PAGE_IO fields. However, this
alone is not sufficient, as XTheadMae uses a nonzero memory type value
for normal memory pages. So the kernel uses an additional alternative
sequence (ALT_THEAD_PMA) to insert the correct memory type when
generating page table entries.

Some RISC-V platforms use a fourth method to specify the cacheability of
a page of RAM: RAM is mapped to multiple physical address ranges, with
each alias having a different set of statically-determined PMAs.
Software selects the PMAs for a page by choosing the corresponding PFN
from one of the available physical address ranges. Like for XTheadMae,
this strategy also requires applying a transformation when writing page
table entries. Since these physical memory aliases should be invisible
to the rest of the kernel, the opposite transformation must be applied
when reading page table entries.

However, with this last method of specifying PMAs, there is no inherent
way to indicate the cacheability of a page in the pgprot_t value, since
the PFN itself determines cacheability. This implementation reuses the
PTE bits from Svpbmt, as Svpbmt is the standard RISC-V extension, and
thus ought to be the most common way to indicate per-page PMAs. Thus,
the Svpbmt variant of _PAGE_NOCACHE and _PAGE_IO is made available even
when the CPU does not support the extension.

It turns out that with some clever bit manipulation, it is just as
efficient to transform all three Svpbmt memory type values to the
corresponding XTheadMae values, as it is to check for and insert the
one XTheadMae memory type value for normal memory. Thus, we implement
XTheadMae as a variant on top of Svpbmt. This allows the _PAGE_NOCACHE
and _PAGE_IO definitions to be compile-time constants, and centralizes
all memory type handling to a single set of alternative macros.

However, there is a tradeoff for platforms relying on hardware for all
memory type handling: the memory type PTE bits must now be masked off
when writing page table entries, whereas previously no transformation
was needed.

As a side effect, since the inverse transformation is applied when
reading back page table entries, this change fixes the reporting of the
memory type bits from ptdump on platforms with XTheadMae.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v2)

Changes in v2:
 - Keep Kconfig options for each PBMT variant separate/non-overlapping
 - Move fixup code sequences to set_pXX() and pXXp_get()
 - Only define ALT_UNFIX_MT in configurations that need it
 - Improve inline documentation of ALT_FIXUP_MT/ALT_UNFIX_MT

 arch/riscv/include/asm/errata_list.h |  45 -------
 arch/riscv/include/asm/pgtable-32.h  |   3 +
 arch/riscv/include/asm/pgtable-64.h  | 171 ++++++++++++++++++++++-----
 arch/riscv/include/asm/pgtable.h     |  47 ++++----
 arch/riscv/mm/pgtable.c              |  14 +--
 arch/riscv/mm/ptdump.c               |  12 +-
 6 files changed, 174 insertions(+), 118 deletions(-)

diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/asm/errata_list.h
index 6694b5ccdcf8..fa03021b7074 100644
--- a/arch/riscv/include/asm/errata_list.h
+++ b/arch/riscv/include/asm/errata_list.h
@@ -53,51 +53,6 @@ asm(ALTERNATIVE(	\
 	: /* no inputs */	\
 	: "memory")
 
-/*
- * _val is marked as "will be overwritten", so need to set it to 0
- * in the default case.
- */
-#define ALT_SVPBMT_SHIFT 61
-#define ALT_THEAD_MAE_SHIFT 59
-#define ALT_SVPBMT(_val, prot)						\
-asm(ALTERNATIVE_2("li %0, 0\t\nnop",					\
-		  "li %0, %1\t\nslli %0,%0,%3", 0,			\
-			RISCV_ISA_EXT_SVPBMT, CONFIG_RISCV_ISA_SVPBMT,	\
-		  "li %0, %2\t\nslli %0,%0,%4", THEAD_VENDOR_ID,	\
-			ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)	\
-		: "=r"(_val)						\
-		: "I"(prot##_SVPBMT >> ALT_SVPBMT_SHIFT),		\
-		  "I"(prot##_THEAD >> ALT_THEAD_MAE_SHIFT),		\
-		  "I"(ALT_SVPBMT_SHIFT),				\
-		  "I"(ALT_THEAD_MAE_SHIFT))
-
-#ifdef CONFIG_ERRATA_THEAD_MAE
-/*
- * IO/NOCACHE memory types are handled together with svpbmt,
- * so on T-Head chips, check if no other memory type is set,
- * and set the non-0 PMA type if applicable.
- */
-#define ALT_THEAD_PMA(_val)						\
-asm volatile(ALTERNATIVE(						\
-	__nops(7),							\
-	"li      t3, %1\n\t"						\
-	"slli    t3, t3, %3\n\t"					\
-	"and     t3, %0, t3\n\t"					\
-	"bne     t3, zero, 2f\n\t"					\
-	"li      t3, %2\n\t"						\
-	"slli    t3, t3, %3\n\t"					\
-	"or      %0, %0, t3\n\t"					\
-	"2:",  THEAD_VENDOR_ID,						\
-		ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)		\
-	: "+r"(_val)							\
-	: "I"(_PAGE_MTMASK_THEAD >> ALT_THEAD_MAE_SHIFT),		\
-	  "I"(_PAGE_PMA_THEAD >> ALT_THEAD_MAE_SHIFT),			\
-	  "I"(ALT_THEAD_MAE_SHIFT)					\
-	: "t3")
-#else
-#define ALT_THEAD_PMA(_val)
-#endif
-
 #define ALT_CMO_OP(_op, _start, _size, _cachesize)			\
 asm volatile(ALTERNATIVE(						\
 	__nops(5),							\
diff --git a/arch/riscv/include/asm/pgtable-32.h b/arch/riscv/include/asm/pgtable-32.h
index fa6c87015c48..90ef35a7c1a5 100644
--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -28,6 +28,9 @@
 #define _PAGE_IO		0
 #define _PAGE_MTMASK		0
 
+#define ALT_FIXUP_MT(_val)
+#define ALT_UNFIX_MT(_val)
+
 static const __maybe_unused int pgtable_l4_enabled;
 static const __maybe_unused int pgtable_l5_enabled;
 
diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 093f0f41fd23..aad34c754325 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -8,7 +8,7 @@
 
 #include <linux/bits.h>
 #include <linux/const.h>
-#include <asm/errata_list.h>
+#include <asm/alternative-macros.h>
 
 extern bool pgtable_l4_enabled;
 extern bool pgtable_l5_enabled;
@@ -111,6 +111,8 @@ enum napot_cont_order {
 #define HUGE_MAX_HSTATE		2
 #endif
 
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+
 /*
  * [62:61] Svpbmt Memory Type definitions:
  *
@@ -119,53 +121,152 @@ enum napot_cont_order {
  *  10 - IO     Non-cacheable, non-idempotent, strongly-ordered I/O memory
  *  11 - Rsvd   Reserved for future standard use
  */
-#define _PAGE_NOCACHE_SVPBMT	(1UL << 61)
-#define _PAGE_IO_SVPBMT		(1UL << 62)
-#define _PAGE_MTMASK_SVPBMT	(_PAGE_NOCACHE_SVPBMT | _PAGE_IO_SVPBMT)
+#define _PAGE_NOCACHE		(1UL << 61)
+#define _PAGE_IO		(2UL << 61)
+#define _PAGE_MTMASK		(3UL << 61)
 
 /*
+ * ALT_FIXUP_MT
+ *
+ * On systems that do not support any form of page-based memory type
+ * configuration, this code sequence clears the memory type bits in the PTE.
+ *
+ * On systems that support Svpbmt, the memory type bits are left alone.
+ *
+ * On systems that support XTheadMae, a Svpbmt memory type is transformed
+ * into the corresponding XTheadMae memory type.
+ *
  * [63:59] T-Head Memory Type definitions:
  * bit[63] SO - Strong Order
  * bit[62] C - Cacheable
  * bit[61] B - Bufferable
  * bit[60] SH - Shareable
  * bit[59] Sec - Trustable
- * 00110 - NC   Weakly-ordered, Non-cacheable, Bufferable, Shareable, Non-trustable
  * 01110 - PMA  Weakly-ordered, Cacheable, Bufferable, Shareable, Non-trustable
+ * 00110 - NC   Weakly-ordered, Non-cacheable, Bufferable, Shareable, Non-trustable
  * 10010 - IO   Strongly-ordered, Non-cacheable, Non-bufferable, Shareable, Non-trustable
+ *
+ * Pseudocode operating on bits [63:60]:
+ *   t0 = mt << 1
+ *   if (t0 == 0)
+ *     t0 |= 2
+ *   t0 ^= 0x5
+ *   mt ^= t0
+ */
+
+#define ALT_FIXUP_MT(_val)								\
+	asm(ALTERNATIVE_2("addi	t0, zero, 0x3\n\t"					\
+			  "slli	t0, t0, 61\n\t"						\
+			  "not	t0, t0\n\t"						\
+			  "and	%0, %0, t0\n\t"						\
+			  "nop\n\t"							\
+			  "nop\n\t"							\
+			  "nop",							\
+			  __nops(7),							\
+			  0, RISCV_ISA_EXT_SVPBMT, CONFIG_RISCV_ISA_SVPBMT,		\
+			  "srli	t0, %0, 59\n\t"						\
+			  "seqz	t1, t0\n\t"						\
+			  "slli	t1, t1, 1\n\t"						\
+			  "or	t0, t0, t1\n\t"						\
+			  "xori	t0, t0, 0x5\n\t"					\
+			  "slli	t0, t0, 60\n\t"						\
+			  "xor	%0, %0, t0",						\
+			  THEAD_VENDOR_ID, ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)	\
+			  : "+r" (_val) :: "t0", "t1")
+
+#else
+
+#define _PAGE_NOCACHE		0
+#define _PAGE_IO		0
+#define _PAGE_MTMASK		0
+
+#define ALT_FIXUP_MT(_val)
+
+#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
+
+#if defined(CONFIG_ERRATA_THEAD_MAE)
+
+/*
+ * ALT_UNFIX_MT
+ *
+ * On systems that support Svpbmt, or do not support any form of page-based
+ * memory type configuration, the memory type bits are left alone.
+ *
+ * On systems that support XTheadMae, the XTheadMae memory type (or zero) is
+ * transformed back into the corresponding Svpbmt memory type.
+ *
+ * Pseudocode operating on bits [63:60]:
+ *   t0 = mt & 0xd
+ *   t0 ^= t0 >> 1
+ *   mt ^= t0
  */
-#define _PAGE_PMA_THEAD		((1UL << 62) | (1UL << 61) | (1UL << 60))
-#define _PAGE_NOCACHE_THEAD	((1UL << 61) | (1UL << 60))
-#define _PAGE_IO_THEAD		((1UL << 63) | (1UL << 60))
-#define _PAGE_MTMASK_THEAD	(_PAGE_PMA_THEAD | _PAGE_IO_THEAD | (1UL << 59))
 
-static inline u64 riscv_page_mtmask(void)
+#define ALT_UNFIX_MT(_val)								\
+	asm(ALTERNATIVE(__nops(6),							\
+			  "srli	t0, %0, 60\n\t"						\
+			  "andi	t0, t0, 0xd\n\t"					\
+			  "srli	t1, t0, 1\n\t"						\
+			  "xor	t0, t0, t1\n\t"						\
+			  "slli	t0, t0, 60\n\t"						\
+			  "xor	%0, %0, t0",						\
+			  THEAD_VENDOR_ID, ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)	\
+			  : "+r" (_val) :: "t0", "t1")
+
+#define ptep_get ptep_get
+static inline pte_t ptep_get(pte_t *ptep)
 {
-	u64 val;
+	pte_t pte = READ_ONCE(*ptep);
 
-	ALT_SVPBMT(val, _PAGE_MTMASK);
-	return val;
+	ALT_UNFIX_MT(pte);
+
+	return pte;
 }
 
-static inline u64 riscv_page_nocache(void)
+#define pmdp_get pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
 {
-	u64 val;
+	pmd_t pmd = READ_ONCE(*pmdp);
+
+	ALT_UNFIX_MT(pmd);
 
-	ALT_SVPBMT(val, _PAGE_NOCACHE);
-	return val;
+	return pmd;
 }
 
-static inline u64 riscv_page_io(void)
+#define pudp_get pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
 {
-	u64 val;
+	pud_t pud = READ_ONCE(*pudp);
+
+	ALT_UNFIX_MT(pud);
 
-	ALT_SVPBMT(val, _PAGE_IO);
-	return val;
+	return pud;
 }
 
-#define _PAGE_NOCACHE		riscv_page_nocache()
-#define _PAGE_IO		riscv_page_io()
-#define _PAGE_MTMASK		riscv_page_mtmask()
+#define p4dp_get p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	p4d_t p4d = READ_ONCE(*p4dp);
+
+	ALT_UNFIX_MT(p4d);
+
+	return p4d;
+}
+
+#define pgdp_get pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	pgd_t pgd = READ_ONCE(*pgdp);
+
+	ALT_UNFIX_MT(pgd);
+
+	return pgd;
+}
+
+#else
+
+#define ALT_UNFIX_MT(_val)
+
+#endif /* CONFIG_ERRATA_THEAD_MAE */
 
 static inline int pud_present(pud_t pud)
 {
@@ -195,6 +296,7 @@ static inline int pud_user(pud_t pud)
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
+	ALT_FIXUP_MT(pud);
 	WRITE_ONCE(*pudp, pud);
 }
 
@@ -245,11 +347,7 @@ static inline bool mm_pud_folded(struct mm_struct *mm)
 
 static inline pmd_t pfn_pmd(unsigned long pfn, pgprot_t prot)
 {
-	unsigned long prot_val = pgprot_val(prot);
-
-	ALT_THEAD_PMA(prot_val);
-
-	return __pmd((pfn << _PAGE_PFN_SHIFT) | prot_val);
+	return __pmd((pfn << _PAGE_PFN_SHIFT) | pgprot_val(prot));
 }
 
 static inline unsigned long _pmd_pfn(pmd_t pmd)
@@ -257,6 +355,9 @@ static inline unsigned long _pmd_pfn(pmd_t pmd)
 	return __page_val_to_pfn(pmd_val(pmd));
 }
 
+#define pmd_offset_lockless(pudp, pud, address) \
+	(pud_pgtable(pud) + pmd_index(address))
+
 #define pmd_ERROR(e) \
 	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
 
@@ -268,6 +369,7 @@ static inline unsigned long _pmd_pfn(pmd_t pmd)
 
 static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 {
+	ALT_FIXUP_MT(p4d);
 	WRITE_ONCE(*p4dp, p4d);
 }
 
@@ -327,11 +429,15 @@ static inline struct page *p4d_page(p4d_t p4d)
 
 #define pud_index(addr) (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
 
+#define pud_offset_lockless(p4dp, p4d, address) \
+	(pgtable_l4_enabled ? p4d_pgtable(p4d) + pud_index(address) : (pud_t *)(p4dp))
+
 #define pud_offset pud_offset
-pud_t *pud_offset(p4d_t *p4d, unsigned long address);
+pud_t *pud_offset(p4d_t *p4dp, unsigned long address);
 
 static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
+	ALT_FIXUP_MT(pgd);
 	WRITE_ONCE(*pgdp, pgd);
 }
 
@@ -382,8 +488,11 @@ static inline struct page *pgd_page(pgd_t pgd)
 
 #define p4d_index(addr) (((addr) >> P4D_SHIFT) & (PTRS_PER_P4D - 1))
 
+#define p4d_offset_lockless(pgdp, pgd, address) \
+	(pgtable_l5_enabled ? pgd_pgtable(pgd) + p4d_index(address) : (p4d_t *)(pgdp))
+
 #define p4d_offset p4d_offset
-p4d_t *p4d_offset(pgd_t *pgd, unsigned long address);
+p4d_t *p4d_offset(pgd_t *pgdp, unsigned long address);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline pte_t pmd_pte(pmd_t pmd);
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index ba2fb1d475a3..8b622f901707 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -253,6 +253,7 @@ static inline bool pmd_leaf(pmd_t pmd)
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
+	ALT_FIXUP_MT(pmd);
 	WRITE_ONCE(*pmdp, pmd);
 }
 
@@ -263,11 +264,7 @@ static inline void pmd_clear(pmd_t *pmdp)
 
 static inline pgd_t pfn_pgd(unsigned long pfn, pgprot_t prot)
 {
-	unsigned long prot_val = pgprot_val(prot);
-
-	ALT_THEAD_PMA(prot_val);
-
-	return __pgd((pfn << _PAGE_PFN_SHIFT) | prot_val);
+	return __pgd((pfn << _PAGE_PFN_SHIFT) | pgprot_val(prot));
 }
 
 static inline unsigned long _pgd_pfn(pgd_t pgd)
@@ -343,11 +340,7 @@ static inline unsigned long pte_pfn(pte_t pte)
 /* Constructs a page table entry */
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
 {
-	unsigned long prot_val = pgprot_val(prot);
-
-	ALT_THEAD_PMA(prot_val);
-
-	return __pte((pfn << _PAGE_PFN_SHIFT) | prot_val);
+	return __pte((pfn << _PAGE_PFN_SHIFT) | pgprot_val(prot));
 }
 
 #define pte_pgprot pte_pgprot
@@ -486,11 +479,7 @@ static inline int pmd_protnone(pmd_t pmd)
 /* Modify page protection bits */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	unsigned long newprot_val = pgprot_val(newprot);
-
-	ALT_THEAD_PMA(newprot_val);
-
-	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | newprot_val);
+	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot));
 }
 
 #define pgd_ERROR(e) \
@@ -547,9 +536,10 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
  * a page table are directly modified.  Thus, the following hook is
  * made available.
  */
-static inline void set_pte(pte_t *ptep, pte_t pteval)
+static inline void set_pte(pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pteval);
+	ALT_FIXUP_MT(pte);
+	WRITE_ONCE(*ptep, pte);
 }
 
 void flush_icache_pte(struct mm_struct *mm, pte_t pte);
@@ -598,6 +588,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
 
+	ALT_UNFIX_MT(pte);
 	page_table_check_pte_clear(mm, pte);
 
 	return pte;
@@ -869,6 +860,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 {
 	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
 
+	ALT_UNFIX_MT(pmd);
 	page_table_check_pmd_clear(mm, pmd);
 
 	return pmd;
@@ -886,7 +878,11 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
-	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
+	ALT_FIXUP_MT(pmd);
+	pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
+	ALT_UNFIX_MT(pmd);
+
+	return pmd;
 }
 
 #define pmdp_collapse_flush pmdp_collapse_flush
@@ -955,14 +951,9 @@ static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
 static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address,  pud_t *pudp)
 {
-#ifdef CONFIG_SMP
-	pud_t pud = __pud(xchg(&pudp->pud, 0));
-#else
-	pud_t pud = pudp_get(pudp);
-
-	pud_clear(pudp);
-#endif
+	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
 
+	ALT_UNFIX_MT(pud);
 	page_table_check_pud_clear(mm, pud);
 
 	return pud;
@@ -985,7 +976,11 @@ static inline pud_t pudp_establish(struct vm_area_struct *vma,
 				   unsigned long address, pud_t *pudp, pud_t pud)
 {
 	page_table_check_pud_set(vma->vm_mm, pudp, pud);
-	return __pud(atomic_long_xchg((atomic_long_t *)pudp, pud_val(pud)));
+	ALT_FIXUP_MT(pud);
+	pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, pud_val(pud)));
+	ALT_UNFIX_MT(pud);
+
+	return pud;
 }
 
 static inline pud_t pud_mkinvalid(pud_t pud)
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index c4b85a828797..604744d6924f 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -42,20 +42,14 @@ int ptep_test_and_clear_young(struct vm_area_struct *vma,
 EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
 
 #ifdef CONFIG_64BIT
-pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+pud_t *pud_offset(p4d_t *p4dp, unsigned long address)
 {
-	if (pgtable_l4_enabled)
-		return p4d_pgtable(p4dp_get(p4d)) + pud_index(address);
-
-	return (pud_t *)p4d;
+	return pud_offset_lockless(p4dp, p4dp_get(p4dp), address);
 }
 
-p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
+p4d_t *p4d_offset(pgd_t *pgdp, unsigned long address)
 {
-	if (pgtable_l5_enabled)
-		return pgd_pgtable(pgdp_get(pgd)) + p4d_index(address);
-
-	return (p4d_t *)pgd;
+	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), address);
 }
 #endif
 
diff --git a/arch/riscv/mm/ptdump.c b/arch/riscv/mm/ptdump.c
index 0dd6ee282953..763ffde8ab5e 100644
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -140,8 +140,8 @@ static const struct prot_bits pte_bits[] = {
 		.clear = ".",
 	}, {
 #endif
-#ifdef CONFIG_RISCV_ISA_SVPBMT
-		.mask = _PAGE_MTMASK_SVPBMT,
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+		.mask = _PAGE_MTMASK,
 		.set = "MT(%s)",
 		.clear = "  ..  ",
 	}, {
@@ -216,11 +216,11 @@ static void dump_prot(struct pg_state *st)
 		if (val) {
 			if (pte_bits[i].mask == _PAGE_SOFT)
 				sprintf(s, pte_bits[i].set, val >> 8);
-#ifdef CONFIG_RISCV_ISA_SVPBMT
-			else if (pte_bits[i].mask == _PAGE_MTMASK_SVPBMT) {
-				if (val == _PAGE_NOCACHE_SVPBMT)
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+			else if (pte_bits[i].mask == _PAGE_MTMASK) {
+				if (val == _PAGE_NOCACHE)
 					sprintf(s, pte_bits[i].set, "NC");
-				else if (val == _PAGE_IO_SVPBMT)
+				else if (val == _PAGE_IO)
 					sprintf(s, pte_bits[i].set, "IO");
 				else
 					sprintf(s, pte_bits[i].set, "??");
-- 
2.47.2


