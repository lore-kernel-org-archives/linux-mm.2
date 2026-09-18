Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E355C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ADC56B00AA; Thu, 17 Sep 2026 21:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384AD6B00AC; Thu, 17 Sep 2026 21:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227136B00AD; Thu, 17 Sep 2026 21:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDF9D6B00AA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:47:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48B4CA5DC2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:08 +0000 (UTC)
X-FDA: 85225194936.23.D59C3E5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5D76718000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W4ykJOir;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789696026;
	b=0TP9KRy7LGPXy0wYPI3OfjWJteTXSyV1YXScpdBHJ9FDdqt7yEsrJ25RFRoMT/kzUL/M94
	qIZy3r+Pxe7I0RWcCtM9rcoQ9hadM+INochcA/hSyfx6GoOmXSk7D97Y00lZKHX58CJPjT
	gpXckXKH3pfdaV/OsJRtGWMPJE7SLnY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W4ykJOir;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789696026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhS4DUXFF2GxtdllH+jg2LhffTGPa07xf7zYS3jXJK4=;
	b=cWYS+zcIKEh/+IM/qR6kRCJwekVPTV/8DT5JzCQQO6kXW+g7uwRrqx83mxCSlpDlie02By
	KyjBQESFmxLyaDAg5XtYmx522n3isQ06B9oVeLrTOqdPwfgpwH4bjo8zejKl4kgBNjqUuB
	GeoAaudocTHHB7fyPNgY55ZDOqEdu14=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hhS4DUXFF2GxtdllH+jg2LhffTGPa07xf7zYS3jXJK4=;
	b=W4ykJOir1oye1lb5wRqY+z7ZuAL4j8cHaSca/yqmhneLqr4XEYpcN0YYvxLXK7V6dUq1cx
	bvWSN8B7VavE4JkQP4FJBBHBAb3+mY14KdyySsJc5anegOZHOIx5NFhkTKqsPH7+5EPN4u
	4rmVsadAPsQTahubgj+mOW2ut/qMB9g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-gabhxe3eMNyyF5HtJ-foZg-1; Thu,
 17 Sep 2026 21:47:01 -0400
X-MC-Unique: gabhxe3eMNyyF5HtJ-foZg-1
X-Mimecast-MFC-AGG-ID: gabhxe3eMNyyF5HtJ-foZg_1789696018
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF5691977507;
	Fri, 18 Sep 2026 01:46:57 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 45C9F18004D2;
	Fri, 18 Sep 2026 01:46:54 +0000 (UTC)
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
Subject: [PATCH v8 13/14] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Thu, 17 Sep 2026 21:45:34 -0400
Message-ID: <59028991ef703526a8e3be4c1f3875b042f328ae.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: nRAsiDNHpaqi5yizpBA1MaLC1VlOWL5iz3M87BAhbig_1789696018
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D76718000B
X-Stat-Signature: swic98zgpbp1gktfjicf8busqefxkjka
X-HE-Tag: 1789696026-28327
X-HE-Meta: U2FsdGVkX1/hRi/b32rATmg1c79N4P4swd8kATiwKACwSvpeh/pSI2NbptirT+iCk3LU9z4ZHsKSeUy27QwxkLud/qImniWpgdMmUsM9emy4LPf67Qwwl5uhdtuj5sOYn3ksRrORLPO6v6aH21JFCEC9pdb2tPpK0N1xw7gRizE6l0BO1Ukwg63acoyjDWCZKp6KGSuUtRKlxQpJWDuAIWXaThn84lYkrdYEKk1SleaDOTHv1hlYnH7k6NRyDxh/hS/wk1O0PLU3LdmEEzEmw0U8w3MA+B72eHvVcid4Mgkn6vtb7iMaMVbOVTl/grYYbtS9K0h3AOxNNsrMtHBZfpWE6EilVo99I6U1R6yF7vQNHWGdLFOC1cWA0z2kKTJ6Fslq1HTToQ0g/9LArgaGlHd/7RgKkozN0JA5Q+3gVV+z2dWYBx9l8V9TB3psW8scUfZfHRlXiUAh5WO0PTDHC8KzKoulDhpeh6CAjcoN3z7Iq9ZUDEagSsRq90n7zZY+TPuwx23LogUPa7pKZkW7CCXFdlQGE/AM7aADv5fAfGmR8aMzbfUGr99+kAUCmgzjTesv5pkUzIlbSlBWO3I4O3AbKmHM/n2J6Uh+rPfBa4GM4cNSpeuuwpSMVPmiN/hC/6RPZuRO8Pr/4f1up3nTZBLASKaCTA367mf4eJO8wvtyh0MLNjTbWro5D0WXU4JX8pEgLitcuOdPUvOh44Ic1X4jHwc831ITLRwCQq5Rjv81lfa6OUil5AEDgqlziPkMaITkW6DDOFoHnXocqxXRm9Ycw1iuMD0zsOkI7FHrzohNKGeBh+BbWjWCNOOUg9XgYSqk7ihKxHzvFms/HDZMYfhDW8Y0tA0SH6U2+3I057S0RXnDCrW76WVUB1bpLff/cdhb+zCqfsszF8kRt4BEjmmW3Wut1+7moZoTlbPaDMkQPDQenO3F7+jt5O8BnVrNGxG3uvI62wg09Co8qLC
 eVhn8VJx
 QrJnzZPzOkWfrWjE51pOMnJNmX9RHItStsBJnNsSzk6ZD+fB4IYZHaFpPD0NZw5S/b6UL/n5ZnyTSurNIGLo/VhGd2C9hU0SR4FE3yBW0gD3GyYGfWBdbldvYUj/EF2iQ1zYbgSKb6jS8PXlhJ/qvJrgQnWF7USscY+yL817NjOQbkskEMJk2/4BVD4yJWrTpnncw2YgfUlmi4Oqqdn+pz2N0ILyLXmyJQphG2orIHBN9HJyz0+Ddh3krVEPi0xTxBxJnfCY7oCRoPTwy4D3INoDpEu365d9PbPj4wZyGIZYgAHNvRAED4sxoSonj/KtwTuA13xJzuVx+dn1TEhyS+Kbz9AqPkgXPeldbzfspd26QMZZqn/NDYXkxRMvgruW0gQ79nwEea9ZzYdAiJrSJdbghtDJ87lzeX64RaRW/8sAcu39b/Obfl8X/snGh0+uqS/Gq7x94WHtaNMgnVAHQHv/5xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despite its name, thp_disabled_by_hw() just checks whether the
architecture supports PMD-sized pages. It returns true when
TRANSPARENT_HUGEPAGE_UNSUPPORTED is set in transparent_hugepage_flags,
this only occurs if the architecture implements arch_has_pmd_leaves()
and that function returns false.

Since pgtable_has_pmd_leaves() provides the same semantics, use it
instead.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/huge_mm.h | 7 -------
 mm/huge_memory.c        | 6 ++----
 mm/memory.c             | 2 +-
 mm/shmem.c              | 2 +-
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8ca0fa3be2ac..196f17afcb5d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -47,7 +47,6 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -383,12 +382,6 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 	return mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, vma->vm_mm);
 }
 
-static inline bool thp_disabled_by_hw(void)
-{
-	/* If the hardware/firmware marked hugepage support disabled. */
-	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
-}
-
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmaflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c9ee387a59f9..a06025b87e7c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -196,7 +196,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -1091,10 +1091,8 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!arch_has_pmd_leaves()) {
-		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
+	if (!pgtable_has_pmd_leaves())
 		return -EINVAL;
-	}
 
 	/*
 	 * hugepages can't be allocated by the buddy allocator
diff --git a/mm/memory.c b/mm/memory.c
index cbd9082d33a0..9e7d2d73fa5b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5694,7 +5694,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 930657d05375..bc2de3a7c1ea 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2048,7 +2048,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.55.0


