Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFCE3E94614
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CD36B009E; Mon,  9 Feb 2026 17:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0706B009F; Mon,  9 Feb 2026 17:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199416B00A0; Mon,  9 Feb 2026 17:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 068306B009E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:15:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1FA41A02F8
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:08 +0000 (UTC)
X-FDA: 84426324696.19.68F339F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD4FC1A0002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RuihEPNi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675306; a=rsa-sha256;
	cv=none;
	b=PPLe+cMpAEvSIG8fazsrFfFK5zQkUb31gsdbXrb0fM2IbT0pel8pKcrlUHqe+p4JmjZ3Go
	zPZikPv8W0PXZzauunxXNFZ00z3jQHQz4SEvsE8aC78I4ZeWzYfGdHE8Qsnjuj8viwNYqj
	BlJUys7GN7crEVLsEUXVr++PVVNLsfU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RuihEPNi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67cjgvmN4wcDxnHIeyr7N4NSsVtUrHJXnKrlVxHMIvo=;
	b=P+iB+CpuCyVQ6dNi32nN3+IJfGDBt4EI4E9TvBNiHhvh77sW5y55OcotW12wmI4n77+HXQ
	xhTf6JDMJIiAcMiJFbDdR4LnxMVX+yXiSycG0EFpGmiOToHwincMlC3IFqyumu4DsNKe8Q
	fespTb++fjlABDfODP8dmpHJMV4QBKs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=67cjgvmN4wcDxnHIeyr7N4NSsVtUrHJXnKrlVxHMIvo=;
	b=RuihEPNiw2nPKy7UXr+uz44kzZ/2AT2+H3adfFiGJJxvhBxxhepgOzrQLhPmk/ti7kCBxt
	MaAbT2ewihRpTTk1AB5/KHBrhKiUPU5q8IGqDq1qIBRApbwCumpWvSm6/eylVDTE/57ggZ
	BqMEetRbNp2LojcKwn69HSEoClKlIY0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-TLr_Jra7Oci7mr7xmIMOiQ-1; Mon,
 09 Feb 2026 17:15:00 -0500
X-MC-Unique: TLr_Jra7Oci7mr7xmIMOiQ-1
X-Mimecast-MFC-AGG-ID: TLr_Jra7Oci7mr7xmIMOiQ_1770675299
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A6361955E77;
	Mon,  9 Feb 2026 22:14:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B5F72180066C;
	Mon,  9 Feb 2026 22:14:57 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 09/11] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Mon,  9 Feb 2026 17:14:31 -0500
Message-ID: <d37315e10c708f5224813f0d0b8cf6af80b9c72a.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: UM25_tWFtNQHPweCVaGs5eWKGhMYb8eYXF990EwSQ_0_1770675299
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DD4FC1A0002
X-Stat-Signature: wuefjrkn3czu87em6am7hpmfqrimc8ce
X-HE-Tag: 1770675306-448625
X-HE-Meta: U2FsdGVkX1/xcn+HLBIx/5Pm97o3SUvPnwr57Sz6azne5SiBPfUcXDT2lKhbLjfqvWKhxj9fZdBqxOEa7GxFBPBmL3nWIpDaHOFt5IkbytWJhyhSdymqPzsxIsce0oh9AT/X08Lr7eNzK+vMlWlwfBDD02plvON9g+4j+C3m4lmJS1kSsVGzb152a6ilGk+9/y/2zb2vH30pyFyuByFHYOEiLs/5bKL41onDoCMw2yxFjHmsW8DwvfJ3J6Fbps9Ju5mI0+k7gQC1navdOW9JBCUtnaeFKuX97jP/LRW+Stm7Lys25niadtGzjow40NF6Jr4sOhwzYWQhoD5QVYZdbDDayyEM/QSS80nHH4wuM3CJCmV3KF8rBDtQTNYdeF5JfihILrIPegHPNAYkXecEJe0FnKQ92D9TeMBFCwmHfQiYAJduHe26Ed+ENXaG4wLgBa6yFBsO/j9fzmxYRyNT/rSoKVnilYXq+4qG4nrjtGFnw5rRVhFAV14vWqjFbQV4ndjSTy09/tLJT/DiK61+PY7yB0xfVNMxDNeC/MzYO8pwrRjbx7dgCYUnuxUpqe/+ckE/0gb6YXz+ysFMdEX1w+y6h/Lg7LHeaIlMibMkn7r8vqidTWPbj2ZmVJtmgBlRwAijbsxLT1VOcOwealPpcNRZ+MMujolptxfXc1uvZsU118TjrDoTuUBEhgG7btMd/nCbYH2AJxgCxzOdrF6RvFCn+oKqTJ+yeAJuH9O9cFhpAB91lLs/qgRPlkQA1ZmRZPlsU3IBKMFNEJr45VHRcXDTY/4FZHi38cTOQDaygLJx+INMUorYbAlGgav+R+6/iRDD815pff1DJ6ojP5X4k0gDSdOXmwpIruhK9f9yDf0X/O0RwW7vXPiFn5Txkj9wcfY9vk4P2ustgNJpeHwFxsTXkhG8bE7ZLFD6QJMQ33qu/Z02b+H0pL5Kuwp7NqSlj5UHCHRqwXL4kgkyNip
 BipEM+3W
 sY16BsehJjMpwFMNXd7XqZMg8K7TCHGhHhNgLtp7Pdb6TQ6v1zQOQrJ6onTivZlREle7PqDkoKV1feOmNcEEDtcVa9GQeM/NTKpN+LiRlhqQ0N0WPu/80arYJikds2E8O4ThFiJ0nGd0bl+wZnAExtqO/nWvsyg6LRe15wl47AKFw915y7qe9PEz2cYEVPCdAIXU6H5k2Tazb80K8q7opR7T4reXyk83XGcD7B82ktSgk3+WWgNLvDoJzC/N53woYhqpF7f6+zdojFT/tAPuMo7znI5ssQOGhLn8ClB/yZlmH8L8DfNN0PmK0Bl9EecM/eiom9/5xTdKoszFrCaSCEk2kc+j9OOwd0G/KYuDYlW3wLDJCVaqna90plDxg95KesAIr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/huge_mm.h | 7 -------
 mm/huge_memory.c        | 6 ++----
 mm/memory.c             | 2 +-
 mm/shmem.c              | 2 +-
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..e291a650b10f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -47,7 +47,6 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -352,12 +351,6 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
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
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b80a897b9b6f..1e5ea2e47f79 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -122,7 +122,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -905,10 +905,8 @@ static int __init hugepage_init(void)
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
index 9794429df015..1e9dbec7e6eb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5386,7 +5386,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 32529586cd78..1c98e84667a4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1827,7 +1827,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.53.0


