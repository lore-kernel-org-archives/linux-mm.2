Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 659E9C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8355D6B00E1; Tue,  4 Aug 2026 10:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E55F6B00E2; Tue,  4 Aug 2026 10:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FBD16B00E3; Tue,  4 Aug 2026 10:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4649A6B00E1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:04:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C4CEA01E9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:04:27 +0000 (UTC)
X-FDA: 85063756974.13.0E7894B
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 942412000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:04:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ocs/8K95";
	spf=pass (imf13.hostedemail.com: domain of kfastov@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kfastov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785852265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0SIB9ZNDGWSkbhYbrVPXtpZTZPzNmn29odQM0RAb0dw=;
	b=GSnP6f7Z/m74+lRWVyXtFOJbuu0bAXJhxnWr+dqYrVs0hiIsNipM+9PbpegCN2uP845vG8
	pX89cczJwuQ5Rhd91gRLDhfnCFmReFoOSg3tFlLxOYEE4U0LzyU7XWB6n9QC/MhIvAw0zW
	x7knR/tlO8yr4VCP5LolStGBsQDgVcc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ocs/8K95";
	spf=pass (imf13.hostedemail.com: domain of kfastov@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kfastov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785852265;
	b=EODGQxt+oYnyNbs63TJs98FEgTlEXtwis1keUCaGj7xV0YcvPinSTN9nT/9mr+Hs+PAcgI
	PSKu6Pa9K24RAh1nD/iy2ndpJ1Av2H6ot/jeBxdRAEAQzgqo72D8Tm1eJofSqU711Dhr7q
	zuT5kbteayWm4nXbp+1O0X+uEenNMEg=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b0148201fbso4733431e87.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785852264; x=1786457064; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0SIB9ZNDGWSkbhYbrVPXtpZTZPzNmn29odQM0RAb0dw=;
        b=ocs/8K95Vv35ApuiekqeTnAB0o0uiCJu1K8kXKOZ2HjKNPFommLWpgqc7N29bO56ip
         RK1vzeElnT8mkWlRiSAmfvNsA8F6Vw0nOsy93zpnJWseSlX707RqjEVRF27L3+fgrUAK
         nJ5C3xEMcsnu1eINNXv3ZcmI6e9yDDCoLZfSv+swwD3DsmwUOEQiSb4lgl5l2g0IMT2u
         N4RumMV1CBN8kseXdkuhlHw/P6YeGrTPONIJHYORrjDi8IsrKknnIBlHH3ulPUKyULOD
         S6h6Ih0y+BvKgostpGO/8Q6oWEWubFVlltjUT3v866t5+j6KmeNkWvjpRWOEMFPmyp1A
         zXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785852264; x=1786457064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0SIB9ZNDGWSkbhYbrVPXtpZTZPzNmn29odQM0RAb0dw=;
        b=U/urnCDyHlaIoWoNRbTrBCPbR6nYtR8uCo6zAD34mwV8UGMGTfntOjWMnCQQeJ2aEM
         l/iBw5zC5tIr0X2u8fyH9WlhLSCTl10/Xd+8x81UWCB0xW8NSmIEiCYtO9B576K9FLsT
         iyv75KNeuWcOvL6cdoRnsUYpxp4zLtWcDqJenqMuxwmGGevmFEcdy8TdQsdZh/vljo9L
         GEaZtfNAVVpCDuvsnvHa8/unmcUwJn6dWV6JSN2H94FdzDlelmGxWj10e/3Rn0QBYJI0
         MxDjPmnqbNLeHMP26cRoTtNcpj17tu+ZnIEI6fbNyWY6VSng2JQrLAJHmZ0t8QCatLZh
         9vCQ==
X-Forwarded-Encrypted: i=1; AHgh+RqwJAGurB+RfO9RvHiY5yyvplEA8ie9EkGao2hrNDGFvwg6XOxDCuGspsK5E5dZ8dAEjABY/pqNUQ==@kvack.org
X-Gm-Message-State: AOJu0YwJvHt6ByqkC8E/GgL52eOrOs/Uus8dQoO7GpgSfXfhX8Gug5wX
	BHZMf5A7T+7xNEgVtvNjNhSjyZaqNu0GEzboEgUEqVM4QNKu0Yq12Zen
X-Gm-Gg: AR+sD11JOslA/IxQ5LKV9ucqkBsxc2HnGSbfOCtQylunFytiHwROb8gwxgVFhtn4dxI
	ssC76fxVlT4anMwkaM4yJMpQJMJdS6Ohr+Z+w9+atH3IQxavuC2qELuwsCvXWCNO+qi0+01cnC9
	UR4tY2/CEdXgmuf1yo1h0pDx2b2KnAZDU5XgwNcHB/zGRBbiliBXuv1xgfmmQpR22v0zmbyO4Cz
	ZyLEuRclBP9/GjmcD5v/t4/yfc4WkoL+5Flr1RJxuKcXJlX1XTMigsGni9btmm7l3XllUca8AfU
	kxi6LDT4Pcw2tkxnQ0LNAf5+gemD1jrxMu2wB+Lj1aOW673NrAGxvAtg+ZJeUCiD/ubcMvP2THb
	ibKYEnxNvD8qorvJaF0+98TJO4oIzEt2p+NhnnTypFuvoj/anlo1PcxLT//onJMhxVT06Pag1eS
	vogaRIozaKoE4qyBGiV13jDmigWGl+aO7J3La+PO2z2Jwywx9frG+Vf96VsHK17kloR3RZPavfo
	MGGnfrhf6x7YtsIZETY4LmKc6RcA0IwpXGO/MhF
X-Received: by 2002:a05:6512:39c3:b0:5b2:a396:1793 with SMTP id 2adb3069b0e04-5b2e4f76abemr2965624e87.37.1785852263358;
        Tue, 04 Aug 2026 07:04:23 -0700 (PDT)
Received: from kfastov-mac ([91.217.3.226])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e245536dsm2669672e87.67.2026.08.04.07.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:04:22 -0700 (PDT)
From: Konstantin Fastov <kfastov@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	stable@vger.kernel.org,
	Konstantin Fastov <kfastov@gmail.com>
Subject: [PATCH] drm/gem-shmem: Install writable PTEs for write faults
Date: Tue,  4 Aug 2026 17:04:03 +0300
Message-ID: <20260804140403.16337-1-kfastov@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 942412000D
X-Stat-Signature: pe14hbisyhsesieiz7rt8x8o84fi5pmz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785852265-136322
X-HE-Meta: U2FsdGVkX1//oE7MGnGq5R7dKFHuhvu5dtOnBYB4BQYsWtssYRcVxQTm22jBOv/f9q1hnUKYffKlTUD1CXgbVaWsg07K9PqOP7SpCdrRyNT0nT/Nl159910+MD3RYeOtlKj8ku2d4RJR8wp2mjNGKyFVMh29s7HnbmmojHJwFTyldz6FXp7CcLmk2HWbOJ72ulGB+ZFpRUuq7oY9NAuoETfXSf14bzTX9Rpok/FAInug55o0B7DeIOAFBKfAzm2STjg0+zXyR+1MJ5O1CDBZLSfQJ9K/oHqx335PFS4+lFxs7UkmlsKC/YcLFneEExcpbLIuK0XUwmAI7jhlzR0bQiP42wf5bRIBMnNDOxJ6OYZ6CKYzP4SplQK3AuBldriDb6WBbPIye+fkykg6CuyhWqTplBditCze2DY6Rle0btjfIpsClJjETU0O9+Gs1nj91PkCPiVgp1QIzVOcouQQfOEfhmMpFk6q2lXrhWWYxlTTdZgoTiny9HVqvj/3MR6JplbEWztsAQKmfjdezmuNivjms39K+t8DAl0rS6nyhOC0qFq9P4NUf/DKV3BUBlQX+TrUiQ5Ly8OViBtABYuOba7n/wscHVkPObtzKbHvwKzUgzsmttUjLerEP0aM1XW2YKkaMaiVIkoppIVDgBaHPc8DNRZXKNNLCaPXqJ4oOZ9cO7I2iysRNPbcm7HnvGN8nhHW4d3RGzZx/cIYbE0wK7S0F6eCemQra4ngNN4ZAWqlBYhYeJjRZXVp+BBOGMXGBwIsCDe6176ci9fpTAwLUXM6bRdgIsZ0WK+718B7pVg6AMIlAhA7HpMLZXwKmDjCOav0l+4KeowxqyOEmGso8Dj6xb4CXEgpjc6ouUUKSAtoIQ5sqRphPjBHj65iCOax9n0+F1Ge2dY3x0NIPhhBil4HiaFrbBgzqmhkD5j+W2+dBxBsV6uvel6pMCNelXXflIjwLqIipWOL8n3DTNa
 NI4Mk1Cv
 QNXEBhfQZSdccXxcCmqusHSS3/QmDz2kPN2PeQnmJXAUESMnUQ50L1sS8gWL8sFKUCg6Cr/U3cm60srPTJNVKeiYM6XmpW52sIG1zD9/Z3fg4TvQTkrZr3u4MjmcuM6GaUpVBUfflYR9/92HwxVs1QzjO4A2pn6XSxQEkiB0kxnacVTNtJG1IJxHyOSkkhC1Oq0fV5wsOlXAVGOpc0DDlkwamUCqGA8fu/a2JZSZpEuR2zAr+wFa7qA13uIVCdwbiUZy674uiWzpeG/v4L1oNBrLFwpiM+ChaNCMu5RQupKgXKvI0IiCeE/oMXWNg5QVgyPacddtGu3+BNIs6lnGv/XGtKw+Kg2AsMKW/o9neJgk/tOel+9pDXgtt8yffWbIuoyvISBARYBvt5s7lLw/24cjG9ZQypsRX+8wsMXPNsNZ4+SmPJ2I0XBtajNjYN7Nw9yhwiIOaQIh7dku19vFtTKLFJaHSJa1MR5YDgHEsX6f0yxw117rDo8vMSkN2e6X9+INRl2a/cey5LLNoJ2zInCjagsRXG7IfARMj4SFa89/MTSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the introduction of dirty tracking, drm_gem_shmem_vm_ops has a
.pfn_mkwrite handler.  Its presence makes vma_wants_writenotify() true,
so vma_set_page_prot() removes the write bit from vm_page_prot of
shared mappings, and the vmf_insert_pfn() call in the fault handler now
installs read-only PTEs even when serving a write fault.

For regular CPU accesses this is transparent: the retried access faults
again on the present read-only PTE, goes through wp_pfn_shared() into
.pfn_mkwrite() and the PTE is upgraded to writable.  But consumers that
resolve faults through fixup_user_fault() + follow_pfnmap_start()
perform no such retry.  In particular KVM's hva_to_pfn_remapped(),
after "successfully" handling a write fault, finds a present read-only
PTE, treats it as KVM_PFN_ERR_RO_FAULT and fails the vcpu run with
EFAULT.  Observed as AsahiLinux/linux#560: muvm/libkrun microVMs
mapping virtio-gpu blob resources die with EFAULT on first GPU access.
The traced failing sequence:

  follow_pfnmap_start()        -> -EINVAL   (no PTE yet)
  fixup_user_fault(WRITE)
    drm_gem_shmem_fault()
      vmf_insert_pfn()         -> NOPAGE    (read-only PTE installed)
  fixup_user_fault()           -> 0         (fault "handled")
  follow_pfnmap_start()        -> 0, !writable
  hva_to_pfn()                 -> KVM_PFN_ERR_RO_FAULT

Fix it the same way commit cb2a2a5b37ad ("drm/shmem_helper: Make sure
PMD entries get the writeable upgrade") did for the PMD path: when the
fault is a write fault, install a writable entry directly and record
the write for dirty tracking, instead of relying on a refault that not
every fault-resolution path performs.

To do that at PTE level, add vmf_insert_pfn_mkwrite(), the VM_PFNMAP
counterpart of vmf_insert_mixed_mkwrite(): insert_pfn() already
implements the mkwrite semantics, there was just no wrapper exposing it
for pfn inserts with the default pgprot.

Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
Cc: stable@vger.kernel.org
Closes: https://github.com/AsahiLinux/linux/issues/560
Assisted-by: Claude:claude-fable-5
Signed-off-by: Konstantin Fastov <kfastov@gmail.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 20 +++++++++++++-
 include/linux/mm.h                     |  2 ++
 mm/memory.c                            | 36 +++++++++++++++++++++++---
 3 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 545933c7f712..37662f6f6ed9 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -573,7 +573,25 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
 				 unsigned long pfn)
 {
 	if (!order) {
-		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		vm_fault_t ret;
+
+		/* .pfn_mkwrite enables write-notify, so vm_page_prot lacks
+		 * the write bit and a plain vmf_insert_pfn() would install
+		 * a read-only PTE even for a write fault.  Not every fault
+		 * resolver refaults into .pfn_mkwrite() to upgrade it (KVM
+		 * doesn't), so install a writable PTE and record the write
+		 * directly, like the PMD path below.
+		 */
+		if (vmf->flags & FAULT_FLAG_WRITE) {
+			ret = vmf_insert_pfn_mkwrite(vmf->vma, vmf->address,
+						     pfn);
+			if (ret == VM_FAULT_NOPAGE)
+				drm_gem_shmem_record_mkwrite(vmf);
+		} else {
+			ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		}
+
+		return ret;
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	} else if (order == PMD_ORDER) {
 		unsigned long paddr = pfn << PAGE_SHIFT;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80fce2515930..7b76a281bdd1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4551,6 +4551,8 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 			bool write);
 vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
+vm_fault_t vmf_insert_pfn_mkwrite(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn);
 vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn, pgprot_t pgprot);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..6562a0d8bb68 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2751,8 +2751,9 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
  * Context: Process context.  May allocate using %GFP_KERNEL.
  * Return: vm_fault_t value.
  */
-vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t pgprot)
+static vm_fault_t __vmf_insert_pfn_prot(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, pgprot_t pgprot,
+		bool mkwrite)
 {
 	/*
 	 * Technically, architectures with pte_special can avoid all these
@@ -2774,10 +2775,39 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
+}
+
+vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
+			unsigned long pfn, pgprot_t pgprot)
+{
+	return __vmf_insert_pfn_prot(vma, addr, pfn, pgprot, false);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
 
+/**
+ * vmf_insert_pfn_mkwrite - insert single pfn into user vma, making it writable
+ * @vma: user vma to map to
+ * @addr: target user address of this page
+ * @pfn: source kernel pfn
+ *
+ * Similar to vmf_insert_pfn(), but the inserted PTE is made young, dirty and
+ * writable (subject to the VMA's write permission).  For use by fault
+ * handlers of write-notify VMAs (where vma->vm_page_prot has the write bit
+ * removed) that serve a write fault and do their own dirty accounting, so
+ * that a "handled" write fault always results in a writable PTE.  The
+ * VM_PFNMAP counterpart of vmf_insert_mixed_mkwrite().
+ *
+ * Context: Process context.  May allocate using %GFP_KERNEL.
+ * Return: vm_fault_t value.
+ */
+vm_fault_t vmf_insert_pfn_mkwrite(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn)
+{
+	return __vmf_insert_pfn_prot(vma, addr, pfn, vma->vm_page_prot, true);
+}
+EXPORT_SYMBOL(vmf_insert_pfn_mkwrite);
+
 /**
  * vmf_insert_pfn - insert single pfn into user vma
  * @vma: user vma to map to
-- 
2.55.0


