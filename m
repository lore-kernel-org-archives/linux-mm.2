Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99ACACD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5A78E0030; Wed, 12 Nov 2025 20:47:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FB48E002F; Wed, 12 Nov 2025 20:47:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E818E0030; Wed, 12 Nov 2025 20:47:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05D878E002F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD5F81407A1
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:24 +0000 (UTC)
X-FDA: 84103896408.22.924F400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF0A1C0013
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=NOMPhMKB;
	spf=pass (imf28.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCfGLyHTlwnlWI3FvQiRrpmgPRI/lUHNtrwWz9sKS0g=;
	b=4XF59fMnh15MDV1pukki8XVk4LaI6Dq89TPhKcpmgbwl9ihmfuPZtm4ysjopArtV4Xqgry
	4QQ1t9WnXcgxkREfADb7+cx9BOFadM+aqoRZ6WyaHDDqd0Bo7FdjhVYVhZX2SQFLdNjywu
	R0VwIcf/0OHrgCWBYsZZ9dz7lMAdBBA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=NOMPhMKB;
	spf=pass (imf28.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998443; a=rsa-sha256;
	cv=none;
	b=NRM1TrXkRSIlFtfgPtC9t8dBg++PKZa+9+ymKhxPqMBfqDy9+jQYGRQWbQifLwsuRO9djO
	x9fjynKWwU4UHSCCD8AwHS9k/dH/Qdn0OpHoJFvB4tUgvq1rWVfkSal9o4VouP6p07AUwl
	U/lQKWeLfCClBJ+kP+pJx39omJHqRSs=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2953ad5517dso3384305ad.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998442; x=1763603242; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCfGLyHTlwnlWI3FvQiRrpmgPRI/lUHNtrwWz9sKS0g=;
        b=NOMPhMKBoZXGErBQPjXt9UxJyeQ2d99Zfs8pWzamI7jpEAZSEj9EN4Jho3RkadI0dO
         ZljHVbwRPwQdzz4P+qpfoJ00BnBUYiT0yLztnv50IA85GWXdNx0mKCb8beJusvcyr2DI
         lnO/Gl4sspN3fbuAxrahLGDTbCGn4a8uH+i84dlsgKUVbwIg9KjsuhMv6pZon6b9mXPa
         3msT9ydhUdU1dj196xLuAuraM53kR8+Z4+yDjRIH0Rz4rx7c6UBW5g491jWmHc558pT3
         y0502eXCZLKpOQhmOOiQdUeLfRWxcBL3IoyDrLCFC8r5DrifR0OA4JhoQBAmhnl/Hyul
         PxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998442; x=1763603242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LCfGLyHTlwnlWI3FvQiRrpmgPRI/lUHNtrwWz9sKS0g=;
        b=T+2iXUgym/2UNrkju4aSBoKdxHbcrMBmwof4BSefgSLW/LnCLKCrZlpqS/MLkJ32ji
         VdyliOU1upmIiPBXAdrCYZZg91BLh2/wZG6OMu9cqLYfGFIexuOd8SYQRk7VXfJq+nSI
         X3q2NHYDB4J90nMGoVqKRxJg5gBHWFIS3ZQ7IlNP7bmvcl1FNHaPmSZd+rJvCHRRSWN4
         dz3iV4yAtR1SW/HcvnV4qwqcuUUdlwDxPx6ZqNbypzly0WIkt+rGKI49NIGyAdYDnrAL
         +ydsk6UvrsDzZ35Md8qVeCG8vdQHSm1iFq2G3tqsN6s4PdOKlm1FdvkiClY4Xza/BF50
         3fLw==
X-Forwarded-Encrypted: i=1; AJvYcCXz8/r9ACUwPQFrxFK3r5qUyT7yK3oTgTRQk0QRJPnKRM9o5fdLtOs2Oxr56v+S0gG0+/OGErOsYA==@kvack.org
X-Gm-Message-State: AOJu0YwWC1mvv+pyKPhESwLP+Yijd/ozCkIWPq26pvinxNvHIa4/bkBg
	X83F+Us/BV2i3B69z2sSrrcF6rYu7y4Aua7mm4atR1pBasq5OoWjohXYjG6RzXf1jnA=
X-Gm-Gg: ASbGncv6KfWdwC/KTwQ5oQjEnwgYxBvae5jc79uWjkgyUXfQ38mIZgKAaWS8DS5hAXN
	vJOz+2xojwETfR0hzFsMV9CCXTVKozGXnCUsblI/ps0vGqER3nQHcTuFAasEmbvkk+wr+fCig7m
	pLwpKej1b/6MF2G0i9Gb+9D36K06wlDkhjnSHjimrUoHJSj7zfX4GaFouy5/r9fCiOB/lF4qCZM
	OcL8ZkuMHs6KtgFTPxOUm2TnD0/5JaNu7JyE4mlRH1sr4oh8gp2s9A4WSDydga5hPrAgQK8blaT
	6J19B89PiBMR0HDdeiUC+wnA5N2m6eu4I8sVaWo7NilkYLwMKhmxiAGg++OFspZhANvNqrq2f44
	r5U03YIqo5XxXmdAbcBLGaTtK63apumR9dDVq0kIn5a0sR6bvYyqySoi/w8CwHtDgrP6OYmJzjK
	jnAOfr/1vcRypZGJrR2vnG4g==
X-Google-Smtp-Source: AGHT+IFq0UAOun8d9XJx744M7CwKUVs4/xq+EwynwZ5LpaPcXyVk6iynKKn4ZFAafmUlsME9mB3yew==
X-Received: by 2002:a17:902:ef45:b0:295:738f:73fe with SMTP id d9443c01a7336-2984edec698mr65123165ad.30.1762998441862;
        Wed, 12 Nov 2025 17:47:21 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:21 -0800 (PST)
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
Subject: [PATCH v3 15/22] riscv: mm: Expose all page table bits to assembly code
Date: Wed, 12 Nov 2025 17:45:28 -0800
Message-ID: <20251113014656.2605447-16-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EF0A1C0013
X-Stat-Signature: ird63zj7gembg3i6bm1ro4m5iphnuizk
X-Rspam-User: 
X-HE-Tag: 1762998442-370730
X-HE-Meta: U2FsdGVkX19ghrJKfpbXY6k+9mo/+kEbTG8RabCUAwfiKnjq594jhg7qUVfHd4snAH+Dm9AesLJg7dZAQKqLC2I5B0q1wrOyN+AYA9zcf1wG36wDO54lyI8BSPbXGP00I/Hc1xhPXUWLhpshlYKc9wuQwqu4ljRxQQGZlaSkQlm+WNWsWDHhoAlvYR84vRjL4TIwXJRsSzP6d45GOoTMDBjkEmkmM2ASOzytKSQWEvr5Ox/WQuQdMKrDlxkOha4aelVw91+GvtXrdwV1PyINE9+r1EktV/w0CHgXItZb4wf1UAsPO9YsnkEVs8wd8I0p1b/B7HN6k11cI703MJu6LT8fsW5KIAO9zAfrUo0hYNfx+k7c5Z1dPV/iGkGJE6idg3cWc78OJpG+lJgxYTWDk1SVRY98enU2925GHW4V86uNzRbDhnOoLOoF1jPkpG29CP1BNM1K8w4L/OoXXYZtW7L9+nwPg6Tv5byH6g3II9iILnGbWCkK6EHpwA/ls3cdtKiZToYJG7BZ0AP7ZB13HIl/Mdc4ejjisEc3IoKVzNVn8vQd+MnkQtcEK3+dnzuMordrenXzpV+e8S0sBJoSFHn1waIvdJyq+ZC+L+cvhUeOp7nlPi2KuzSmJUHPRf2MILRZjbJ3B6OvCmCpTBjMMbX0P8fd0Jogf8eWXeqFJJG1hIrtA+llbof95ShmP70IF/tNCiqWVrWKqddNOFTlwYoClO+E8TXwbqIsQek9Hjgxeo7mRPJRPcYqqvDyc8BKDEBTE70PR0mb63oVqDprMa4hEqHXpv2PddA21HM918EBnkl+9a7TDCzt0z4FHeO2TIS7I3f3pp5bYiA/FMqBdotIQwLhOkVv36dg5o1DKZhDBVzYH4C5WnBVvRbm3kgHeRVyOw9obs0fwnMHAe5sQcTirg9n1ujG0BumiImq52Y68dqqz4OcJEHULjrWeesLZwclhZ9mbdAL1jfoZkY
 okHDsE6w
 zxDcQL9a6fNtOaODh87Ih08G6yDUsKQhEjZpq6128ykkmtWjoTdz/wlI+MqReqiG7hTGv91zjEZCTuI2syeAyi3ZQ6lg2cl4cq7Ry5d63DLOuVfZC+pdxroCmjxAM7OiYYuwqXKB+k4Xk/AHm6XdYDKtgcD6IyMTGesaK2aR9BXg0La3AYUUF5K7ieFriAJ2A1WWCl8Z8wfwsSLOINxSDWKxBcl+sIEvSqQiGnlJOXecHMPSJxXpeorPBu4dkMn8N/cHAJnag3qAnRU72Qujg/ktotbyTGX1xsFxHTn/mIMP421TLKuW/AFVDzS8AQGcQfJ8Ut3DbLM7BBkxW9wJtCsASyyywLb89djASFCMC/Z0czh43UPHLD9jUIZwqdbHOw6YFV1f1Th+En4IU3g7wwz2GBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pgtable-32.h and pgtable-64.h are not usable by assembly code files, so
move all page table field definitions to pgtable-bits.h. This allows
handling more complex PTE transformations in out-of-line assembly code.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v1)

 arch/riscv/include/asm/pgtable-32.h   | 11 -------
 arch/riscv/include/asm/pgtable-64.h   | 30 -------------------
 arch/riscv/include/asm/pgtable-bits.h | 42 +++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-32.h b/arch/riscv/include/asm/pgtable-32.h
index 90ef35a7c1a5..eb556ab95732 100644
--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -17,17 +17,6 @@
 
 #define MAX_POSSIBLE_PHYSMEM_BITS 34
 
-/*
- * rv32 PTE format:
- * | XLEN-1  10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
- *       PFN      reserved for SW   D   A   G   U   X   W   R   V
- */
-#define _PAGE_PFN_MASK  GENMASK(31, 10)
-
-#define _PAGE_NOCACHE		0
-#define _PAGE_IO		0
-#define _PAGE_MTMASK		0
-
 #define ALT_FIXUP_MT(_val)
 #define ALT_UNFIX_MT(_val)
 
diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index aad34c754325..fa2c1dcb6f72 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -70,20 +70,6 @@ typedef struct {
 
 #define MAX_POSSIBLE_PHYSMEM_BITS 56
 
-/*
- * rv64 PTE format:
- * | 63 | 62 61 | 60 54 | 53  10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
- *   N      MT     RSV    PFN      reserved for SW   D   A   G   U   X   W   R   V
- */
-#define _PAGE_PFN_MASK  GENMASK(53, 10)
-
-/*
- * [63] Svnapot definitions:
- * 0 Svnapot disabled
- * 1 Svnapot enabled
- */
-#define _PAGE_NAPOT_SHIFT	63
-#define _PAGE_NAPOT		BIT(_PAGE_NAPOT_SHIFT)
 /*
  * Only 64KB (order 4) napot ptes supported.
  */
@@ -113,18 +99,6 @@ enum napot_cont_order {
 
 #if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
 
-/*
- * [62:61] Svpbmt Memory Type definitions:
- *
- *  00 - PMA    Normal Cacheable, No change to implied PMA memory type
- *  01 - NC     Non-cacheable, idempotent, weakly-ordered Main Memory
- *  10 - IO     Non-cacheable, non-idempotent, strongly-ordered I/O memory
- *  11 - Rsvd   Reserved for future standard use
- */
-#define _PAGE_NOCACHE		(1UL << 61)
-#define _PAGE_IO		(2UL << 61)
-#define _PAGE_MTMASK		(3UL << 61)
-
 /*
  * ALT_FIXUP_MT
  *
@@ -176,10 +150,6 @@ enum napot_cont_order {
 
 #else
 
-#define _PAGE_NOCACHE		0
-#define _PAGE_IO		0
-#define _PAGE_MTMASK		0
-
 #define ALT_FIXUP_MT(_val)
 
 #endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index 179bd4afece4..18c50cbd78bf 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -6,6 +6,16 @@
 #ifndef _ASM_RISCV_PGTABLE_BITS_H
 #define _ASM_RISCV_PGTABLE_BITS_H
 
+/*
+ * rv32 PTE format:
+ * | XLEN-1  10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
+ *       PFN      reserved for SW   D   A   G   U   X   W   R   V
+ *
+ * rv64 PTE format:
+ * | 63 | 62 61 | 60 54 | 53 10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
+ *   N      MT     RSV     PFN    reserved for SW   D   A   G   U   X   W   R   V
+ */
+
 #define _PAGE_ACCESSED_OFFSET 6
 
 #define _PAGE_PRESENT   (1 << 0)
@@ -21,6 +31,36 @@
 #define _PAGE_SPECIAL   (1 << 8)    /* RSW: 0x1 */
 #define _PAGE_TABLE     _PAGE_PRESENT
 
+#define _PAGE_PFN_SHIFT		10
+#ifdef CONFIG_64BIT
+#define _PAGE_PFN_MASK		GENMASK(53, 10)
+#else
+#define _PAGE_PFN_MASK		GENMASK(31, 10)
+#endif /* CONFIG_64BIT */
+
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+/*
+ * [62:61] Svpbmt Memory Type definitions:
+ *
+ *  00 - PMA    Normal Cacheable, No change to implied PMA memory type
+ *  01 - NC     Non-cacheable, idempotent, weakly-ordered Main Memory
+ *  10 - IO     Non-cacheable, non-idempotent, strongly-ordered I/O memory
+ *  11 - Rsvd   Reserved for future standard use
+ */
+#define _PAGE_NOCACHE		(UL(1) << 61)
+#define _PAGE_IO		(UL(2) << 61)
+#define _PAGE_MTMASK		(UL(3) << 61)
+#else
+#define _PAGE_NOCACHE		0
+#define _PAGE_IO		0
+#define _PAGE_MTMASK		0
+#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
+
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+#define _PAGE_NAPOT_SHIFT	63
+#define _PAGE_NAPOT		BIT(_PAGE_NAPOT_SHIFT)
+#endif /* CONFIG_RISCV_ISA_SVNAPOT */
+
 /*
  * _PAGE_PROT_NONE is set on not-present pages (and ignored by the hardware) to
  * distinguish them from swapped out pages
@@ -30,8 +70,6 @@
 /* Used for swap PTEs only. */
 #define _PAGE_SWP_EXCLUSIVE _PAGE_ACCESSED
 
-#define _PAGE_PFN_SHIFT 10
-
 /*
  * when all of R/W/X are zero, the PTE is a pointer to the next level
  * of the page table; otherwise, it is a leaf PTE.
-- 
2.47.2


