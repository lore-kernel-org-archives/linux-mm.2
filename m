Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4D4C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868926B00CE; Mon, 31 Aug 2026 23:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8409E6B00D0; Mon, 31 Aug 2026 23:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B98E6B00D1; Mon, 31 Aug 2026 23:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2994F6B00CE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9941F16028D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:29 +0000 (UTC)
X-FDA: 85163722938.24.A08134E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id ADB1940002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N965dX+r;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crl0HXre1NIi+8woj4LEpZq1+eUcVCGkBif2epTDMXU=;
	b=WMqtqAh/jqDcyHE/1zYx8+7CjVbGZHScH0I4JEAJ2Pz0gKxK9bQ+QeftiHusD1mN0I6Cgk
	ZS15gEZg1z4kKf58szTKFH6SDLUb4393/5YHQhJwLzXPnwraLw9xd/oW+t+StcIYjYgW23
	YB1mT8VuC7ZVF310pWN1SX/i3d8oI8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232407;
	b=JSK0Ui5TFlQYymemCwl4VSl0tmGm+BUMlnv7y5pgvGlfJMBtrSiiV0I2DSQk1CVN4K5dKS
	fJs4c3Om0QN8dZUWCL/vmWPKfmZh2leMOqgEohQ8QY/SiH635BCYE8MJTN/miGDPLq+Dhp
	5EglzX29NxRSqOB12zogwVed6XxJg3E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N965dX+r;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=crl0HXre1NIi+8woj4LEpZq1+eUcVCGkBif2epTDMXU=;
	b=N965dX+rmxBm/siaxqCkdTXpoy+FJxphFMUL69/PPY+L7M4uMfs7Pd411YYuQsA6rxOSPi
	seRn2kkDnycaQXyWVFO2HuSwC1bGEtpTs3OqU9VvdM435OW55PwxOJ6BgLgoCH8LKfyAei
	pydWFtCT+Je21nQIJ6NGWDqbc5kMo34=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-352-prBHtdLwO_yvVuQfw_suXg-1; Mon,
 31 Aug 2026 23:13:20 -0400
X-MC-Unique: prBHtdLwO_yvVuQfw_suXg-1
X-Mimecast-MFC-AGG-ID: prBHtdLwO_yvVuQfw_suXg_1788232397
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACEE81860975;
	Tue,  1 Sep 2026 03:13:17 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 40F5A18005BD;
	Tue,  1 Sep 2026 03:13:14 +0000 (UTC)
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
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v7 09/14] powerpc: move has_transparent_hugepage() out of THP guard
Date: Mon, 31 Aug 2026 23:12:13 -0400
Message-ID: <5d7ed96fc5c9ffe357eca9cb48bd679d658dd8e0.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: WZp2se3XUjY2_kz5lzLjHAzR0mU8l_K-DtVA7KSPpVc_1788232397
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: awfe3ks5nkwkfjkrtnfs6ujmf4arp13o
X-Rspamd-Queue-Id: ADB1940002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788232407-590167
X-HE-Meta: U2FsdGVkX1/S/pVNym3zcx6aZYtT8ypyAU5bKGuQzrmgt0tSybAaOCQJkIAh79iZsERyNypZAgaKGwknQ4c4zOwG79EkIfPyf3vA7f/1N8JxhmvjXleA6oAovTMDkpATdn9znrvLULaIa+2TlEoFAgNFx7pXX7HO9ngqj3gPgkZhE+1rPHIPvPsUvSazrfMgRUHLnSq649N3TrbI8MH72FyWIHR8/uWd6Rpf8wIIwRCceOv10ikPmR4i1Ob7UNhiqEXuCB2vjBKxRSWFh15fEEjHWzTS92G+xfgNHwkR6zSkfdtuXxiK2+VUWD/5iQi9j8ntdDXgYWBfpRn+3nPK1guAhBskvWjE5pYSNNfpKIeeRzLyfViBqfg6SFMNVniIbMiisMYhY3YaFpGR29fCm2U8myLMuCmClu1k8Q2uMLS51ovsD5zm5gyhj3qP2CDDKuoUAfwb3+zQiG+6hFenY6JY2cL1+ettmFMf1SSReiYjTQ8o93dCPabfZ4sOnpPpI+5S521kvZDRbYsPYYTH7CSU9KdcpPg1MqLarjfcd5xI+485n+o2fHI5YUJXWOHdcavDckqaDQH9HgZdzcr6iFCmHuFkDgtPur66/1bZDFj52hg+8r2F4hOgHfHgM9JfbB2dY1WnSmGNYB8mdBMEfb5VFARDuFmDdT7T5mPzj0ZTGeLA+Bivmbs3l3s4xEM0ZwGQb2h96faennXeQayJvpSzvVPFd9vO2QE8vDnV75gb3zf3/a0/9WIQGQJZtIrVrxTnqBhB7naZb3d2g/1RwrmkhPTaBJRG3gvoz3n+cOBZ9DGJ2uHGxNix/4EoOBAntG7GtgBIkNflGqF4kAmqYmL4nO1nsL7f5KV0owQnneTyZY7zFXjpsluzZs6z7bxX7SkoI+rAikSKE7xk/2PHsnaQbpsH7dCZ56vFSOubt6MNIy+2Tq2aiaMkg5uZG4mEyGVYWDalMgwGm1RPbfi
 n/3pXsFM
 jSIWxzs7czsNAo2R6ySDv8RdVL5VS8JZVd7ejPtMMh1MvQE+8I6tpCp2B6Y/b31YF4qjaz9vtsL649chcGx1HTou5wgpOAVAp0wrn+N3WDTFSPXSDpacuVW5I09/66UjPTZ/D7fAIToNIFaw+3P3KySEeoka5+fQQCq+epA2iq3myDUf43zBMTyE61ze4bvyFmndj58IZgzFbflQJkSjEzvfJCNznNTiXqkXwNzM4i2TnnHbepuxIuCm24zEzYLzIuCQWTTzXo7qetdr4w7eZ5Hbj7tdji4rb+26qi4a0eFBusXXcRlRulzWngv41nofggl89uV1MnKn6Bzow8ykFJNnUafbPxILG+nosVQVj2mtFgzkZKUCLl9WaCye0NhPinOh80CHC47zDjt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future commit will introduce a kernel API to allow for checking if the
CPU supports PMD-sized pages. This API will be based on the
has_transparent_hugepage() implementation but will be orthogonal to THP
and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

Move its definition out of the THP guard.

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


