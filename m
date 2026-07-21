Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0655AC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFC36B009E; Tue, 21 Jul 2026 12:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FCC6B009F; Tue, 21 Jul 2026 12:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D7C6B00A0; Tue, 21 Jul 2026 12:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48A0D6B009E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B014E1601EA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:18 +0000 (UTC)
X-FDA: 85013306196.09.4449DAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3E88180003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBYXLOuB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dd8IzpXvfcf9omad/UCYPVVbU051g1TaDj1g9jolwTk=;
	b=q0uw032N6IAiL3xi6kYuocEL65lCpaNiCkYxlXdbYML+K7502Y5E3eHQFOuJj+Dtn3CunF
	PIW7lqiIHKDrsJeOAv/w+hKDsc7jUBPUgzb4lNbXd2bRvQ7H/MjaXR76AfcCvTH4u4QNO3
	DyoTw5aMohw8q4/rOvL7NIJUkBNgWJY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBYXLOuB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651057;
	b=7sATbBtc/7345dBZDudVWr2tfR/BXnoAoqQeWunAdSpzR6dZskIi1ylBazEM3jwzAcCg8S
	ZOrUaNATFHrjQwxKGyx/+An+//Pbf+d0D0LcJv9kFWis11xwjax0jQsFA2NoSqUDRqBKtb
	aLEcT6YXtCYTLFAW5qpD4v7dj74Nbdw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21A0E43A0E;
	Tue, 21 Jul 2026 16:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98ED1F00A3A;
	Tue, 21 Jul 2026 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651056;
	bh=dd8IzpXvfcf9omad/UCYPVVbU051g1TaDj1g9jolwTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NBYXLOuBqmaFwezx93ecw7m/nA5exRaxX00iO4FbrUlWQTR/no4KZ7zvJ0UebT+pH
	 KPe5t85aTvpwk9STpAYme+9I79Pc3UW9ruWYP1EPVqRbSjrGHh+VNyyuHOobxLLdbF
	 UNPQzXpyaVX+tJ+vaqyC4EMtkXQaUrEPWevROWx6Aj2/j/RWHw2lapMfhHp4NAuRgR
	 jzq+3jCaUaD/D0ofF88IEP/ndOsQxdCoy/3A2burc0pTIFvFtc6qIQcMlDgtf6SbH9
	 8DLavmBbCBy4XbRI/chv2p1Ia1EMEDGC0Acowle0lUQAF4b9kJP2yJqL/P69RTgGd9
	 N7nVeGpkBnGVw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:28 +0300
Subject: [PATCH RFC 05/18] x86/mm/pat: use a generic helper for the large
 page size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-5-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3E88180003
X-Rspam-User: 
X-Stat-Signature: f7utpoxmnhtbd1xbywfu4gapex8cz43d
X-HE-Tag: 1784651056-700029
X-HE-Meta: U2FsdGVkX1/iYHhxb03eY4v7QpxgvwS7DvacqqbpbXWTc+krIQMivmPvA9YoXsJDsFN918vt22CrArBkWs+V1R7krlwVU1wi7lUC+9RGanTLY6+rtJsEPbn1P1JEq8hLAWLwfnhm6u3mBvC6vH1Ze6NgCFNkj7Lwxx1XumG1V8pyheSThLwG8PdUs/puvm1xQIaWjMBud5UA6TaMHXkq8jmd290JuV/erQT/xptqHS6xudrA3v7KNtAyP2cNLUNxvbsj5Xbq21c2gb10s3Xvy8GANwPDdiNdIPQhQRGMhPSuyhR/zef4MNgs3fR4Ls2cIxP0AA01vmpmv713UlnzlIkgzKfBY/H7I3Ggkl+u8cEqK4b4Vbzt0pAGsFK4HYTmvywuHQQ3b1UQ404n1WOZKACHZT3cj86QBXHwHP2XMrYnVIguov3ptS+54/AANYY4htVe3GMv0y1QHd39gvtq4PnMFTEJ3N5IUyvt2jo2D05LYHRkl/VJkG2a0YXt5OFupWr2FEe/Q1OCGz6iltouiL0irL+TrY4ojeygzZK8d78I01nd6NEmW0H/F6h8eQyISHMvEep/lWUt6CGDEKYwQdUhgZQ4pnlNlyN4f6G08oi1YA80gWojqUPp0Eu9LLT9rGYDXNxINpUtssvwZjwSh6a4QP8wsasSTGAAmnwsgapRan7f1a7HDfvn2aDr9Z8HYOCs0cLBXWJs13JXpCQj7mHEQ85BG+VqGJeRyrTbWIaA8qv+U9viKej4PE6VdO+IOFrS6A9rELOk0ekSu89452HVDzvUJcp3VIPL0MbLe8zJs9TSI5Lut1bk/A/ccSgCD/Wkk9c3Pj64Gf2SxuK1DEcW6tTz+MDAhEDuk9ComsPkWXfaahOlknaDBBlgoVbZrUCflPaVOJItI2QTg0yGiEbN2odyfHiuqAGK9cO5ePlpl7rxGnXmzzb+yWH6z6lAnLgPzLvHJysOMGwM4qe
 31rFNJLb
 LspdwdfWkTsLJeG3zQyDQmST9TxtsVADIB0tQUniYSwNmcjtaUwwxPzd29DVM86ysdnqrBsDr5LsbcqL9QNrbH0g4ElCeb2OW7hpuX3EhbtC+UmHwyBgIcwgBrAGJhdz+RKYsjkfgH3L+kxQr4xIC0BYvVCkXQEjPIpIvpHdZvUoGWHEseV2DEVYR2sAzLkjc2rEOGOx5DV9kCE68jYI9YMUdMQwguklEph8wEA7NdtmQ5k5ljtTcjgu2Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__should_split_large_page() uses x86 specific page_level_size() to
calculate the size and mask of the large page.

In preparation to moving core parts of change_page_attr() to common
code, introduce generic pgtable_level_size() and pgtable_level_mask()
helpers and use them in __should_split_large_page().

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c |  4 ++--
 include/linux/pgtable.h      | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 8a1782f5de3e..ee40962d4ee9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -956,8 +956,8 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 		return -EINVAL;
 	}
 
-	psize = page_level_size(level);
-	pmask = page_level_mask(level);
+	psize = pgtable_level_size(level);
+	pmask = pgtable_level_mask(level);
 
 	/*
 	 * Calculate the number of pages, which fit into this large
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 4b42ac5c27d9..9eb00ad6d5d2 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2364,6 +2364,28 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+/* Size of the memory mapped by a single leaf entry at @level */
+static inline unsigned long pgtable_level_size(enum pgtable_level level)
+{
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		return PAGE_SIZE;
+	case PGTABLE_LEVEL_PMD:
+		return PMD_SIZE;
+	case PGTABLE_LEVEL_PUD:
+		return PUD_SIZE;
+	case PGTABLE_LEVEL_P4D:
+		return P4D_SIZE;
+	default:
+		return PGDIR_SIZE;
+	}
+}
+
+static inline unsigned long pgtable_level_mask(enum pgtable_level level)
+{
+	return ~(pgtable_level_size(level) - 1);
+}
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)

-- 
2.53.0


