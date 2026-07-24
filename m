Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C731EC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F3D6B009E; Thu, 23 Jul 2026 21:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277B86B009F; Thu, 23 Jul 2026 21:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D896B00A0; Thu, 23 Jul 2026 21:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D04206B009E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43297160226
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:24 +0000 (UTC)
X-FDA: 85021952568.14.CBB1AEE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5EFE64000D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZixEHE6;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOa/59JmCKeAYJ2ebD2ctA/PG5bDvtBZwPXhXKsPfUM=;
	b=SOghmCn3AJWNQVgTNbPf6iDeG8vbzRyV07urolOPUBQtrdxsHmxHyLpaUNk9lnAoqXDewn
	dhnT8TXAzzvUnJDhRF2Hel8uWI1cyuumYr31fV+ndUhjRpyE4SgtICKv3NLy5msEaG2W/4
	h+suFWw8kAqgK18+5zYl4rXk3V1N7GE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZixEHE6;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856922;
	b=AguteuTANtjDQzxfYvu9SeQNy/0V10C1xrwufw4FPtfuGk+B+wKV4M+Hwlgbw+B0O/DGaK
	RZl8CyO/yoyvVd8Hn4forUo/rQ40WwCcg7o09a7pAlVI8uPpzGOWRyo1MUvtawYLxcL4VS
	m4m79aykNrqGW6efIicJznMGYmRsm2Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cOa/59JmCKeAYJ2ebD2ctA/PG5bDvtBZwPXhXKsPfUM=;
	b=HZixEHE6bonf4SnQH4i7TqoeMZNo19240akI+fK0TLJ2XrdiBnPZJ66kNa5Qr/EdMsPpjx
	o2vgl7LFNcn45OpXOFvWblL15ve4mcTElTNXGn4CdNwRDxhUJtQdJORRc33p9HeXp0+0FT
	WjdQ/StBUqDvNZp6R57gii2U/R8dVNA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-Az6f25ZYPI-ycQsqqY49EQ-1; Thu,
 23 Jul 2026 21:35:18 -0400
X-MC-Unique: Az6f25ZYPI-ycQsqqY49EQ-1
X-Mimecast-MFC-AGG-ID: Az6f25ZYPI-ycQsqqY49EQ_1784856915
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EE1F180A997;
	Fri, 24 Jul 2026 01:35:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6BE68180059A;
	Fri, 24 Jul 2026 01:35:11 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 09/14] powerpc: move has_transparent_hugepage() out of THP guard
Date: Thu, 23 Jul 2026 21:34:13 -0400
Message-ID: <29b33d5aed6d788381f42cba9dcaeb8a83569790.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: FdMs1AoTyhMaKSGC5zJh5T_Vbim_dAYIeBS3shTjbpg_1784856915
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EFE64000D
X-Rspamd-Server: rspam01
X-Stat-Signature: w9bbhqm46hbkqcsb3jw94pre3j88nhpo
X-HE-Tag: 1784856922-247882
X-HE-Meta: U2FsdGVkX19hQSh8pAgM4pa030bpPBlETg+jA1IVF4igu4Qs/y6c3ra8CZARHhKsMqILnvIK0inFdyy37bgsY0h1eGsgfX0ILDZyi5fwQu8X8sfnA/pqhMiSUUZP04H/97eCrpw7JaNLBFFIsRYiebi4Mr3Zd9SlCQetS5mVpRS0tO+88gD4OsNla7xoYj1R7aR1xLMf+4qQybbnymlWnVYslB71UpeT+bKYzjRIHL9Lw/8iEQRld+pfpljru7gTBg64rpmOVjIgWuCIk1RUz5226VM+QZBs+cVbwYCwgiwQeZbgo/GXs1h3+UqxvbYRkeXvmkwb/MqGbV9vuDNes7O006fmTUgwNodm8SfsrkzsmQWKn2eZUgyGBpGPzHMDaLifXzdfv3bCMusMQIvxFkNnXtjlW+vLXh7gPlnO6/4SUvbfcU+Nf0U7I4kUb9WcD6XMIdfKExaYgS8EMNcKnsLlYrTB/9oxq/4oKfEp++Lg42ObhxXoNgHqd5brAfREbaoVdQGM6dbeCjRE7UoZtT2CVGJVsQC3AYuotKcb8Hcn3qPRPp6kz0EtB3lFFj5o0n5LnOdhgV6MrIFNqUmuQzsTK/+LfOxCq3Rljumv9nVVAqs9EuqhDaqkkC/ci1NdgBVM/D/v5quRvNuU8kMdz9ZAtMCKME7yJGl5j4RMwJPeN9PxTRbEySmYlfhE2wixj0O2tQEN2yBUjOSq/5b2ow66p7MvbrC3h8LCEvRXur9smlZthZYDYwNYSmFrzATezEKKm6qopgOGA3ZKJy/4NOjCu8RrSekn4pGgNakt6+AzXGBW8kTsgp+ey4AerfgY7uQUhh0okIXRpitNYsYFhyilDsLHupExgkXWjd6BmwbuLsEcFcqhvOiNBdf3fci63FfJZ5uOOrj7R2rRilyQUdbsEHXlHAfdT1Gm9S+/g4bho/lcO7yh+A/aXsLjxO2YJHKoH7vj1BpSDh4VTqE
 k2Mv8Cym
 czYG5uOs+dH5P4ZOxZR9WG/+J7xYQNM+PovAh+jcwiXMJQDamhj4nDE3+zwa6IHe5AM9BOpZs0gbghZNmA97CpORCy6ystHwat190Dckw3ZJgl2gkNyg7UzKKFEogvhTkhcfBbJ4+6DlSXTYts4JMf+MLARS6bZ/1PJUzoyNE/S4pFWO18ZvMkvNBD5HYm31JDdayX2RJrCUIDfaCm/Y9CCfnOKQvKI3sVc2ezUDHyhABMzzYl0LO42LpRm5jen4zkNQLP320MDRJ9d7yA9MUTvnK0Q/hvfKZtYA23x3Z2JPIU+I6R4z/SJX1PT1c8c3xyON1y4lc5aYR3dWHf8Zlg4yT4NMYT/fad++TMGzOtLk+axDNuUq4w5FFQ2Is3rrBdiF9rlsgc3oFp1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

has_transparent_hugepage() definition is guarded by
CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
CONFIG_TRANSPARENT_HUGEPAGE=n. Move the definition out of the THP guard.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
 arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 +++++++++---------
 arch/powerpc/include/asm/book3s/64/radix.h    | 14 +++++++-------
 arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
index 8e5bd9902bed..79511e6abfca 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -165,9 +165,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
-extern int hash__has_transparent_hugepage(void);
 #endif
 
+extern int hash__has_transparent_hugepage(void);
 #endif /* !__ASSEMBLER__ */
 
 #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
index 7deb3a66890b..a4a44a112ff9 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
@@ -278,9 +278,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
-extern int hash__has_transparent_hugepage(void);
 #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
 
+extern int hash__has_transparent_hugepage(void);
 #endif	/* __ASSEMBLER__ */
 
 #endif /* _ASM_POWERPC_BOOK3S_64_HASH_64K_H */
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index f4db7d7fbd5c..2a795f6d9263 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1121,15 +1121,6 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
 {
 }
 
-extern int hash__has_transparent_hugepage(void);
-static inline int has_transparent_hugepage(void)
-{
-	if (radix_enabled())
-		return radix__has_transparent_hugepage();
-	return hash__has_transparent_hugepage();
-}
-#define has_transparent_hugepage has_transparent_hugepage
-
 static inline int has_transparent_pud_hugepage(void)
 {
 	if (radix_enabled())
@@ -1441,6 +1432,15 @@ static inline bool arch_needs_pgtable_deposit(void)
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+extern int hash__has_transparent_hugepage(void);
+static inline int has_transparent_hugepage(void)
+{
+	if (radix_enabled())
+		return radix__has_transparent_hugepage();
+	return hash__has_transparent_hugepage();
+}
+#define has_transparent_hugepage has_transparent_hugepage
+
 #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
 pte_t ptep_modify_prot_start(struct vm_area_struct *, unsigned long, pte_t *);
 void ptep_modify_prot_commit(struct vm_area_struct *, unsigned long,
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..50545cf519bd 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -298,22 +298,22 @@ extern pmd_t radix__pmdp_huge_get_and_clear(struct mm_struct *mm,
 pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
 				     unsigned long addr, pud_t *pudp);
 
-static inline int radix__has_transparent_hugepage(void)
+static inline int radix__has_transparent_pud_hugepage(void)
 {
-	/* For radix 2M at PMD level means thp */
-	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
+	/* For radix 1G at PUD level means pud hugepage support */
+	if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
 		return 1;
 	return 0;
 }
+#endif
 
-static inline int radix__has_transparent_pud_hugepage(void)
+static inline int radix__has_transparent_hugepage(void)
 {
-	/* For radix 1G at PUD level means pud hugepage support */
-	if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
+	/* For radix 2M at PMD level means thp */
+	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
 		return 1;
 	return 0;
 }
-#endif
 
 struct vmem_altmap;
 struct dev_pagemap;
diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index d9b5b751d7b7..50316f3fc5d3 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -391,6 +391,8 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 	return old_pmd;
 }
 
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 int hash__has_transparent_hugepage(void)
 {
 
@@ -422,8 +424,6 @@ int hash__has_transparent_hugepage(void)
 }
 EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
 
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 #ifdef CONFIG_STRICT_KERNEL_RWX
 
 struct change_memory_parms {
-- 
2.55.0


