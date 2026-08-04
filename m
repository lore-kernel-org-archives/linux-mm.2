Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEBFC5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0355C6B00F3; Tue,  4 Aug 2026 10:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27B06B00F5; Tue,  4 Aug 2026 10:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E167E6B00F6; Tue,  4 Aug 2026 10:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE8D26B00F3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:34:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AD89A00D5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:57 +0000 (UTC)
X-FDA: 85063458354.05.A69D0B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1489940015
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ew0qBcNR;
	spf=pass (imf17.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j37JFINyTYCydy6a1WRFKL3cyTkOscZBfjMnbKqhj70=;
	b=whIO7YPfuoMloQ6qKozk4sHk2hrHPfJQcRTC4Bj25xNvzOStSpAcIF2mJcLEcmwjpDw3of
	Of2WLfrkBHifhPpzUP0zZjtiOZ6oLFtXoigOghY6jRT1bXVbk3bzdwjWOeixwAPEg+rqA0
	MdyjYelFy8Q0UhhukV/JMULfZ4u8ge0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ew0qBcNR;
	spf=pass (imf17.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845155;
	b=wc1RMnM28Sx4qLlPvLjVJgFgWCD6rgfyVUOXfGV64rkCkuZNdlw8C3Ae5vWCRn4qzZNOnB
	WdrU4Cgnk2KTmrQw03inPsQZBurtpRNzWmT8ZwoGIs4+qTgXGXgYC/MsFDgQyOXO/zrfnz
	bckjoc+ZElMar6LwvsHuIil+ejslCSg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785845154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j37JFINyTYCydy6a1WRFKL3cyTkOscZBfjMnbKqhj70=;
	b=Ew0qBcNRMPURU0rQYS4v5oBUY0lvTeBXRmLjJI+WZfZUeqvrv6PZhR+WFzU617XP4FfJ63
	DCVS1wpQF9zTW99lKK/bVHA04C8R57yI5aPbi1+V+RHs6vFbK+qRS11sTs6xEsyeEXhaDo
	R+FmHYwqDYyrkCgl17FZY3YgCS9JaY0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-n5P_sDu5NFii5pJ6lJH2_w-1; Tue, 04 Aug 2026 08:05:50 -0400
X-MC-Unique: n5P_sDu5NFii5pJ6lJH2_w-1
X-Mimecast-MFC-AGG-ID: n5P_sDu5NFii5pJ6lJH2_w_1785845149
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f6db77430so3331654f8f.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 05:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845149; x=1786449949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j37JFINyTYCydy6a1WRFKL3cyTkOscZBfjMnbKqhj70=;
        b=RJt8EC0hBgxZFpudcgQOdfMfNVuKl4Og23xJUvnL+XCQQLuJtXGlZ2xN3WXjfi/9MD
         2dKX9XzKLD33s0aMHknCcttnanbyq3RODtSzrK5AEEPFq8yJ0z41J/guomgQNMWqnDDn
         hiou0ZlEHDZhkUEbzLKXo1jBvueT8Ui8yD8sgCwjNWuHbca2Vq6APWzz56EIf4hCwSwP
         KjBXPU/q+7SKkDiUf6emV9DGCRbSSrZXo+3lVmZoaJSLX4K8b79lQzGLs9yAzkGHiioQ
         InKtyNOyXFWd//HlT/M1k2ofGRYVGcbMKYGRzVfxBE731YsplU6hQ8cEtdSuWLtHPNNV
         Teuw==
X-Forwarded-Encrypted: i=1; AHgh+RopCiUVR35MqbcbfWNT+vt/4tZve0eV4sisKgwU0efmxV7sFTWH5ujHAT3rtkG6pte1ucu1LoMvRQ==@kvack.org
X-Gm-Message-State: AOJu0YwaTdqZ2zm5xs6HZFuzh1rHvqtaCkHCwfthtyIAaOgtr53cc4oV
	TANzu/4sQBDapO9+rvFKOYW/8RDfBzVYPPK9vwyLiezhKVq8sTaCqbj22ma1Da1EAPWuxKPhvi5
	Eq7icH0nxMF5whwc7jwcTRLS65W79sZHqCUhdKClpf/OuflPzGnOA
X-Gm-Gg: AR+sD126CaxEevnXZan2yIgpMNQDa6sHbMHJop4dARfCBtpTCPyFt8Teu+SAO5xI1sT
	UVObHiI8N+z/eY5sT2tSm/L+6/ouPv+P1EX4GqPUOTG/rp9vawXeptSHlRiBLjjh2Z6PODvJE+0
	gG9+RB/vbGCfQRuWv2EpfK+nehQbkZlfNMRIjpS2dkPkURoN1engnssGYQGC5yfk2o0dtwPa4ke
	ZK5VPPzWgw+lVNX9PhRc7DCzL2r2gH1bEFb00kvRmNx+uEilkGLdlnqtGyeIBSfERwPzHHxfZWW
	P7cbikfJvUUnau6yWgQ2/wwTDaCtitM1qBcBXWxTj0SJq+vvkQ8Ap9VN7xYtLInZfGr6vmq2tmp
	+LttVHjrY/tQ5Ho+gpiHds6Jfii8aBf7/NG092ERr42bsz81ocphfKR4Zq2ElYKKQZb8b2FO5fk
	Zqjr8=
X-Received: by 2002:adf:eb8f:0:b0:47f:97f6:d39a with SMTP id ffacd0b85a97d-47fd72c7121mr27900813f8f.17.1785845149409;
        Tue, 04 Aug 2026 05:05:49 -0700 (PDT)
X-Received: by 2002:adf:eb8f:0:b0:47f:97f6:d39a with SMTP id ffacd0b85a97d-47fd72c7121mr27900691f8f.17.1785845148854;
        Tue, 04 Aug 2026 05:05:48 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41d1756sm41086159f8f.4.2026.08.04.05.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:05:47 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alex Williamson <alex@shazbot.org>,
	bcm-kernel-feedback-list@broadcom.com,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Christian Koenig <christian.koenig@amd.com>,
	David Hildenbrand <david@kernel.org>,
	dri-devel@lists.freedesktop.org,
	Fei Li <fei1.li@intel.com>,
	Huang Rui <ray.huang@amd.com>,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>,
	Peter Xu <peterx@redhat.com>,
	Sergio Lopez <slp@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	stable@vger.kernel.org
Subject: [PATCH v2 5/6] mm: pull writability check to follow_pfnmap_start()
Date: Tue,  4 Aug 2026 14:05:27 +0200
Message-ID: <20260804120529.1730187-6-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804120529.1730187-1-pbonzini@redhat.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zf7LNI44q1axAhy5qSBJBfv-uqiCF7m_b8Qaih7Dc9Y_1785845149
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 1489940015
X-Stat-Signature: sdqtx13r36h3nni569p4ed1zohrwmpw7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785845154-524655
X-HE-Meta: U2FsdGVkX18Rpmo64+4bUBD9Tpa2tUf26ZTmO8oWE8Bn8L7Q4Cpd9lAFWNGpLmRsDwnjfG2K7WsW75YUpxBsRhbtIGPZaquvl0kFgK439EekJF/j+x5lWR39MtPFYPshmMBiqL/Byn3Jcf7qSIc0LJZwcn6YyuzJo9k9oCco4X+ENe61inKz0gX6P7Bv35muUXrFbO0N6QTl5wjwpWQW6qr4LvmbX3qPmn5+S8jKUk5JQ5hhi/X7Gteltdo6T19a8UjWx+eeEtpNwi+UqFhAoYEALPwd0PAfElf2lUlqX0hdxt2JRldmRhCPjSj0vMBUoLR7CKFqwBkS4GwEKRkE3+UCMqf15HpdJ6piOgwbHT7hkVCzVlKpKaziRP1+5mg7JhIULvk8oD1WRPGCdgjuiyK8R66Eua3njDLm1YEDtevaVtaze0i2ehSxbpmrK53amrCYZNJ/bl68AwCN+R99YSL3YNG2+NE5FinzKMOmYQcrhBQ3F8yAmhNghFDO35on4K3jtpZZGlr7AjoM37EnMAICZxz0UqKHHn/ZnhQvqE3I0OLbkJznd8pWVS2sLaupQIPWn3pG0T1cLfh6BOxX2YZcaSDq0XUmSb5fJVtztN7fLhqM7PyTMlBe5LCriutMZNgQfV8FVF48OGOym9tiDoJ62W09k3cV6aK8iRGZXJ/2K/tn+DtlFF4JhurE37Qc+DJ4JnjtXUr/WmdKJBRwbCJdFayMAz0Mp9SQf/Kr/xeVQ9eQRNsUmpIK/QWhh9HoNclExlGZlyHoohntO+20OXAFv2ivoCgCGrAc0moFi5DRSOyDKvQsqb6kr0IcHqMaHnpQs6zzekjYHk4JySmiU4i34kRZIWAo1L8fciCkqNDGVXF4CDfIzJqgd7d8kE0GImrr5vQM0FlRSgZbrVJ1WpBvUep9yskhd9ujnQ0oZPB+APEq7njjR+fiIquEzARDMWG7VFJykvuc7/ItzR0
 J4X9keEH
 IVl4Xh/Zp7a+s2Re4PA4Xj2dW10Fx6h+s2gpQIIay0ARwDBv4Yk1MEMu8bkfBs3W47CtRutaT2pZXWru6dknNdTLsHYk/kArmbyaI3u3vldgl7R6iGipM07fews8I8e+UuiNHaAMQ11+Y6I5cHCy/PcvANiaZS6NKoEUX/c0SptvZC8erZX5FFQNl3t7iT/HMHBY7GnIIQfpMharoB0p2tlYm63/uT4CBuBUHhju8+3SdZHBwer5ABKGBR6Py4gsYr/kLJK59hDjHyb+7ef2dCwHAzKD+TmgC6c08EFOmOKgNNT+mggY5sWRL+ceINdS/G1LFFKfKkqRXyF/MyDbpLpJ900VNUBkkuIaFp740PDhhsJIuPWwW3Gb+eRFCe4RdM+UTUacNNc8qW7r4L6QTacxVGXpxVYEM3MPG/3PO/AKH1jg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers of follow_pfnmap_start() except s390_pci_mmio_write()
are following it, if they are doing a write, with a check that
args.writable is true; for s390_pci_mmio_write() that's a bug.
Also, most of them return -EFAULT if it is not.  Pull the check
directly into follow_pfnmap_start() through another input parameter
args.write_fault, to eliminate the need to do it in the caller.

This also fixes an issue where follow_pfnmap_start() would return
0 for a PFN that is mapped read-only, and the caller would not
attempt to call fixup_user_fault() on it; this can happen with
vm_ops that set .pfn_mkwrite(), for example.  Instead, now the
caller (for example hva_to_pfn_remapped()) sees an error,
does attempt to fix it, and only returns -EFAULT if the
fixup was fruitless.

Reported-by: Sergio Lopez <slp@redhat.com>
Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
Link: https://lore.kernel.org/kvm/CAAiTLFU1ALsDoJoKW3d9bUvv990AozAoX=bEHmfnG54qyBAHFg@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/s390/pci/pci_mmio.c        |  2 ++
 drivers/vfio/vfio_iommu_type1.c | 17 +++++----
 drivers/virt/acrn/mm.c          | 10 +-----
 include/linux/mm.h              |  3 ++
 mm/memory.c                     | 62 ++++++++++++++++++++-------------
 virt/kvm/kvm_main.c             | 15 ++++----
 6 files changed, 58 insertions(+), 51 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 51e7a28af899..d9d5b3318cbc 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -180,6 +180,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 
 	args.address = mmio_addr;
 	args.vma = vma;
+	args.write = true;
 	ret = follow_pfnmap_start(&args);
 	if (ret) {
 		fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
@@ -332,6 +333,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 
 	args.vma = vma;
 	args.address = mmio_addr;
+	args.write = false;
 	ret = follow_pfnmap_start(&args);
 	if (ret) {
 		fixup_user_fault(current->mm, mmio_addr, 0, NULL);
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c8151ba54de3..e6d3a2311a99 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -541,7 +541,11 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    unsigned long *addr_mask, bool write_fault)
 {
-	struct follow_pfnmap_args args = { .vma = vma, .address = vaddr };
+	struct follow_pfnmap_args args = {
+		.vma = vma,
+		.address = vaddr,
+		.write = write_fault,
+	};
 	int ret;
 
 	ret = follow_pfnmap_start(&args);
@@ -563,15 +567,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			return ret;
 	}
 
-	if (write_fault && !args.writable) {
-		ret = -EFAULT;
-	} else {
-		*pfn = args.pfn;
-		*addr_mask = args.addr_mask;
-	}
-
+	*pfn = args.pfn;
+	*addr_mask = args.addr_mask;
 	follow_pfnmap_end(&args);
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
index 5bca500a83e0..2f9808399f19 100644
--- a/drivers/virt/acrn/mm.c
+++ b/drivers/virt/acrn/mm.c
@@ -177,7 +177,6 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
 		unsigned long start_pfn, cur_pfn;
-		bool writable;
 
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
 			mmap_read_unlock(current->mm);
@@ -188,6 +187,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 			struct follow_pfnmap_args args = {
 				.vma = vma,
 				.address = memmap->vma_base + i * PAGE_SIZE,
+				.write = !!(memmap->attr & ACRN_MEM_ACCESS_WRITE),
 			};
 
 			ret = follow_pfnmap_start(&args);
@@ -197,16 +197,8 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 			cur_pfn = args.pfn;
 			if (i == 0)
 				start_pfn = cur_pfn;
-			writable = args.writable;
 			follow_pfnmap_end(&args);
 
-			/* Disallow write access if the PTE is not writable. */
-			if (!writable &&
-			    (memmap->attr & ACRN_MEM_ACCESS_WRITE)) {
-				ret = -EFAULT;
-				break;
-			}
-
 			/* Disallow refcounted pages. */
 			if (pfn_valid(cur_pfn) &&
 			    !PageReserved(pfn_to_page(cur_pfn))) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 01184a4bdd6f..1659cb8f42fd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3136,9 +3136,12 @@ struct follow_pfnmap_args {
 	 * Inputs:
 	 * @vma: Pointer to @vm_area_struct struct
 	 * @address: the virtual address to walk
+	 * @write: if true, fail with -EFAULT unless the mapping is
+	 * writable
 	 */
 	struct vm_area_struct *vma;
 	unsigned long address;
+	bool write;
 	/**
 	 * Internals:
 	 *
diff --git a/mm/memory.c b/mm/memory.c
index b5555217b121..27f5dcc319c8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6774,12 +6774,15 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
-				     spinlock_t *lock, pte_t *ptep,
-				     pgprot_t pgprot, unsigned long pfn_base,
-				     unsigned long addr_mask, bool writable,
-				     bool special)
+static inline int pfnmap_args_setup(struct follow_pfnmap_args *args,
+				    spinlock_t *lock, pte_t *ptep,
+				    pgprot_t pgprot, unsigned long pfn_base,
+				    unsigned long addr_mask, bool writable,
+				    bool special)
 {
+	if (!writable && args->write)
+		return -EFAULT;
+
 	args->lock = lock;
 	args->ptep = ptep;
 	args->pfn = pfn_base + ((args->address & ~addr_mask) >> PAGE_SHIFT);
@@ -6787,6 +6790,7 @@ static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
 	args->pgprot = pgprot;
 	args->writable = writable;
 	args->special = special;
+	return 0;
 }
 
 static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
@@ -6808,8 +6812,9 @@ static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
  * @args: Pointer to struct @follow_pfnmap_args
  *
  * The caller needs to setup args->vma and args->address to point to the
- * virtual address as the target of such lookup.  On a successful return,
- * the results will be put into other output fields.
+ * virtual address as the target of such lookup, and optionally set
+ * args->write to require a writable mapping.  On a successful
+ * return, the results will be put into other output fields.
  *
  * After the caller finished using the fields, the caller must invoke
  * another follow_pfnmap_end() to proper releases the locks and resources
@@ -6832,7 +6837,8 @@ static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
  *
  * This function must not be used to modify PTE content.
  *
- * Return: zero on success, negative otherwise.
+ * Return: zero on success, -EFAULT if @args->write was set but the
+ * mapping is not writable, -EINVAL if there is no mapping at all.
  */
 int follow_pfnmap_start(struct follow_pfnmap_args *args)
 {
@@ -6845,6 +6851,7 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
 	pte_t *ptep, pte;
+	int r = -EINVAL;
 
 	pfnmap_lockdep_assert(vma);
 
@@ -6878,10 +6885,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 			spin_unlock(lock);
 			goto retry;
 		}
-		pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
-				  pud_pfn(pud), PUD_MASK, pud_write(pud),
-				  pud_special(pud));
-		return 0;
+		r = pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
+				      pud_pfn(pud), PUD_MASK, pud_write(pud),
+				      pud_special(pud));
+		if (r)
+			spin_unlock(lock);
+		return r;
 	}
 
 	pmdp = pmd_offset(pudp, address);
@@ -6899,10 +6908,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 			spin_unlock(lock);
 			goto retry;
 		}
-		pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
-				  pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
-				  pmd_special(pmd));
-		return 0;
+		r = pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
+				      pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
+				      pmd_special(pmd));
+		if (r)
+			spin_unlock(lock);
+		return r;
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, address, &lock);
@@ -6911,14 +6922,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	pte = ptep_get(ptep);
 	if (!pte_present(pte))
 		goto unlock;
-	pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
-			  pte_pfn(pte), PAGE_MASK, pte_write(pte),
-			  pte_special(pte));
+	r = pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
+			      pte_pfn(pte), PAGE_MASK, pte_write(pte),
+			      pte_special(pte));
+	if (r)
+		goto unlock;
 	return 0;
 unlock:
 	pte_unmap_unlock(ptep, lock);
 out:
-	return -EINVAL;
+	return r;
 }
 EXPORT_SYMBOL_GPL(follow_pfnmap_start);
 
@@ -6960,7 +6973,11 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
 	bool writable;
-	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
+	struct follow_pfnmap_args args = {
+		.vma = vma,
+		.address = addr,
+		.write = !!(write & FOLL_WRITE)
+	};
 
 retry:
 	if (follow_pfnmap_start(&args))
@@ -6970,9 +6987,6 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	writable = args.writable;
 	follow_pfnmap_end(&args);
 
-	if ((write & FOLL_WRITE) && !writable)
-		return -EINVAL;
-
 	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (!maddr)
 		return -ENOMEM;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 576bcb21be3a..b7c21a48a45c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2928,8 +2928,11 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       struct kvm_follow_pfn *kfp, kvm_pfn_t *p_pfn)
 {
-	struct follow_pfnmap_args args = { .vma = vma, .address = kfp->hva };
-	bool write_fault = kfp->flags & FOLL_WRITE;
+	struct follow_pfnmap_args args = {
+		.vma = vma,
+		.address = kfp->hva,
+		.write = !!(kfp->flags & FOLL_WRITE),
+	};
 	int r;
 
 	/*
@@ -2948,7 +2951,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		 */
 		bool unlocked = false;
 		r = fixup_user_fault(current->mm, kfp->hva,
-				     (write_fault ? FAULT_FLAG_WRITE : 0),
+				     (args.write ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
 		if (unlocked)
 			return -EAGAIN;
@@ -2960,13 +2963,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			return r;
 	}
 
-	if (write_fault && !args.writable) {
-		*p_pfn = KVM_PFN_ERR_RO_FAULT;
-		goto out;
-	}
-
 	*p_pfn = kvm_resolve_pfn(kfp, NULL, &args, args.writable);
-out:
 	follow_pfnmap_end(&args);
 	return r;
 }
-- 
2.55.0


