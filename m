Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EE2CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7006B00AC; Fri, 29 May 2026 10:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E6E6B00AD; Fri, 29 May 2026 10:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DB46B00AE; Fri, 29 May 2026 10:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E58516B00AC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB86F4014E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:51 +0000 (UTC)
X-FDA: 84820759422.29.211EC2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8295100010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gU3VlNxq;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUaj48E0A/aVd8R5qnK6hQllfKeI6Qwq9hQgK6eouro=;
	b=m/VcM3T/L4E9Ky6BOuhhGhqulhdz+QS+5R5qAWTxJRtXc4o8i9K40XZhoxTFgBTeCdoP6A
	cP2E9EQYsyOE4gIsJzzL+AH7kWdlCYGfD1vkoPxkUo+GbrVKYNYxl4BOOBYbtVJ+LsTHlS
	Db5KhFsgKHuJ7yB8dA3X/+s+c34pI30=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066609; a=rsa-sha256;
	cv=none;
	b=WG6JfwfUQLRa/w55LlMJ5ULMiyYmuEexZCYB+5x1cFX0zTQAYd/wcEiC7Zz8n2eY87hglU
	315krimlmbIZinWFHdYTQfscawjjGosYLG5uinxVC+SmyrdtJotoXYvIiZwSWzdjzM2Oge
	4YDIXjMt7ipxukKf84H3xl1e+C+00+Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gU3VlNxq;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUaj48E0A/aVd8R5qnK6hQllfKeI6Qwq9hQgK6eouro=;
	b=gU3VlNxqt1d64PzOQC9/+i9bbqwygytozTEVAWQnS5Ih5uHNV1myDpWbHvPKVeROKO+rsa
	rMLg7m+oTvTulEsIsVZDgGibEmrllmMfULjqyD7XUYPeIcajy9dNqQz202aKaOB8h1Z3F6
	zl1sTwfcQMjj1o7Xv4MrSXb4TWs/NjU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-9-iuv5VyrqPHKYLjiuwdhwtw-1; Fri,
 29 May 2026 10:56:43 -0400
X-MC-Unique: iuv5VyrqPHKYLjiuwdhwtw-1
X-Mimecast-MFC-AGG-ID: iuv5VyrqPHKYLjiuwdhwtw_1780066600
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C0E11800603;
	Fri, 29 May 2026 14:56:40 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 599CC3002D2D;
	Fri, 29 May 2026 14:56:36 +0000 (UTC)
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
	ljs@kernel.org
Subject: [PATCH v5 09/14] powerpc: move has_transparent_hugepage() out of THP guard
Date: Fri, 29 May 2026 10:55:27 -0400
Message-ID: <70c0b587c3a40e7203189bf2b58459b0996e38f9.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: FK2JD229i_XVM2CyoF9rjqjR13L8DEPG8uK1xhOHS4Q_1780066600
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: x8hfq5hwirejnmwki5p64u6e46xke3mx
X-Rspamd-Queue-Id: C8295100010
X-Rspam-User: 
X-HE-Tag: 1780066609-222347
X-HE-Meta: U2FsdGVkX18R1bZ2JC97Q7I9IINXpBnzalBZkJCt458vc5lkatwEPLa8vEUV56nrebycrv14+Ndaxh/Qa3bFuUbh8xAXccEdzOi7WgMv7yvTCy2Dijp6hzXGzuzrjNGFlNdVnXDP4V1jrRDgsS8186QhRxVQw3OBQziOw3cgeOc7y9njRxK3bWk6jTpnrDv8R31MMEaRhjF5h985VDVHkFf4dE1/jeflaGbOVc4UUt+u7NH0SVBwMLKTcJiSs3ialau3VqbKVbeiv7e8gwW/24RoD4iwA0m4+TG84KAhU9hE8GQmEeUCu9RbFMaJAOMd7qc4I8c/HR2irNehEwaSyNQnLjd2kepdO+5MweiyWwhMVoEoVHaxz+SAWcaIkt2uBwfN58L40RWx/gTshEK43wv2CP0CyB9pWGycJU5qXZWHCrULL5ptGA4j3qQWkOuMNZZ/Rf+a/fF/W0GlS70B1+PgXhU4SyJnKMNVUhX1qVWnnHuP9PezTh1UUnq8GlgM7CabSD8g7odXm6OhrWhAMNFoeH0r+Ku2ZltCZ+0HWd8X1y5SCH+QR1P7ZUWlARVHOuyRrExI6ikpphCr5zaub7ZiwqZcNbbywDeC61yG7PQxn6Kju0I5+fJQ9PxsErh7MJRR7RYnMKIQunY31q3H2vf6b5Mub+Qm0s7UBtrVnc5R3tXX09S3UucQE/3AvlOdcZKf5zijtcuMG+0hSXuu8wnpqYqgPK6eaQEilZ3uojm+/+BbljUd//k6F3HyXKNtlDip1FJkfz+pfjOsHxz9w+hLK1o7kI2kY+lMPmYF2e+M4zlP4Y4YpVQkSuNqOCDOQkoWy9+94yfb3+W4uvXXxPQC3ohopw3rgxwFNDJ80pQ2mEvdW2SvhZrhrdYMUbRsBAhKPq3R7mYx3g+KX9qR2AHkP3I1GtINRmqg/P1+m3QTu17TbEYdhjJBg8eIGII9Vqk2RM1l7l8JHhhJtjl
 5RTxij1M
 Du28XgbRM8AE+F986eJBk9BofZhdrZbLkLYmr/z7sqJz2cwhDbe2BmykvUDmmYKexnUBuVQMOXlhiBfRMfYNeql9hVAfL6/Vh/SZqQdwSe7B/Q49TwjZvZcGhNa8LMDUlqbChVaEJtLsA/0sZjtWj5Su6ASpw1UMdTNROoEjcrUdpBFRzGEiB6tSqDpnpw9KN/pD66ZnYhZ3bAhKOsKdHkYtbpm1/d6gPIu5OnpuOoQLERn38UFbNKAUWwir7G66n21Ru2tJKUM/KZMW3GvdYWGEzcJJzIJFFuAx7pepzJfvbLcq3mFJvzMhi3fwgXIcw99VDrK9fEat1qmQmMRtxp9eVak5Z7wC6/FT4m4p59dacOJ0mPY/5ste5d6fvyaMtenI1bH3abG9e75A=
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
index e67e64ac6e8c..49c8beef96bb 100644
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
2.54.0


