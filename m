Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892D4606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7hFlUdc
Received: by kanga.kvack.org (Postfix)
	id 8C6B66B05B7; Thu, 12 Nov 2026 12:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8503A6B05B8; Thu, 12 Nov 2026 12:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1846B05B9; Thu, 12 Nov 2026 12:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45FB96B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:29:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD99F804F5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:29:28 +0000 (UTC)
X-FDA: 85427153616.04.BDC436D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C76D180009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:29:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7hFlUdc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794504567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZA4OFzaj3eAw5VAprKw61yeVsB5hZt4za95D/BJANg=;
	b=hP3m0nMFcxEmNpTztt1G2yXj/EEUy53s6q1mz/9rkO3HqPkmfAjFIOnCZEq7mp4/sJdPWd
	hpiR2nl+eV428B2kQjeUeNWzZJpltbqkL+wn8vZoWTuUWIjgw525sjmjEoDj0St/F2tZFe
	wdYy+QKOu08RjFyJ237kPTgs1fuQaH0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7hFlUdc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794504567;
	b=uyDpUSAIP1eRQliDUw32ao4RPQnHSsevoWAWPtiyOsFwH8hIkjtk90HnHuSyoMxcv1Cbm3
	hKJ1feZE5iGOAcOEiev0I5kEr/8IUVacfYUjIIhvykyVBQ/2CK6y7V4y0fY1dT3XX11IEW
	jwVk7k7FiQGr/+zU5fahY+LTN4xH4KY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DBB561819;
	Thu, 12 Nov 2026 17:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E7C1F000C5;
	Thu, 12 Nov 2026 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794504566;
	bh=MZA4OFzaj3eAw5VAprKw61yeVsB5hZt4za95D/BJANg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=c7hFlUdcGfKUf+hHVn2/yVYHZsVNy6kfPE9IT9ZZGeEfrLU6+boZ5EJZbTZl9T9mo
	 MCgGah8anRUItmb4sYVgmSk5rGvcx9VOQ86EmE1pfcU+EzCnvoBLsTN4s2GpirY/kz
	 lN9JMius9t6KWIr0b7xKmPe+Orr9jv7u/fmFzEjOLcKWdyYfBSjNpOsRW/V0mvGfp6
	 nBa/rauB0XQa/hN1YRkkOqxxLYAjIDGAwIgaxpQgRUI26AkfHCpWK36TgGbKiBenCj
	 razHIez4XGUaB9aXoddjLBMZb/axa9YTmSIPOfBOic7cVEupqmywbNSVj1U1naK1qI
	 LULqu7VG4wSag==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	media-ci@linuxtv.org
Subject: Re: [PATCH v9 02/14] mm: Zero memory during shared memory transitions
In-Reply-To: <sashiko-outbox-199540@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-3-aneesh.kumar@kernel.org>
 <sashiko-outbox-199540@kernel.org>
Date: Thu, 12 Nov 2026 22:59:05 +0530
Message-ID: <yq5av762gdr2.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0C76D180009
X-Stat-Signature: 4taoxng9wg7cb55y1q87debiquje5634
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794504566-345649
X-HE-Meta: U2FsdGVkX187IAhTXT+SdAng+bqyyTLThbnb2TQOUp3sgn/U7JdM66nIezZ025ovOXxrS7hP0zTWWQR8IyuvbZjjJprv/HsjIo0UtP6sKss7A19hd4dtXmrHFF4EY401hFJ+whH+ViGkWhrzcRSTzH5lSnkBu+l96IMAGIwoDDpmJFwy3Edpk3MlNq8rMw9oYI60zsV0whrGBEMiC4aR1A8DX2mrvjjBM27sB1jXWoOTCvLiZgJAli4/UA85hXawwGsEwGx4H3kqSlBgmK6zPHFsh00rGYWUCnguRz0hM5EkM0tfr7vHg9ENBrEXVFT9eCZZ0Klbxx0wwVAuKIrQYYH3TZNr7rVEY/AbjXds+0r51wACA0ZOZ+6ZsjCeQ+teAp3dGfdL3MLk6Sc9PO5IxF7iJqAhE26eMEQZT+tDLeLtdsDy88HjXZjuvGTEoj0RgTFJwp5qM0DYlYP1RJqHxrlxVU3dKWklFPj5UBo0Jy/dR3yo5JuGlH+GvvSQDayeQ1pAyqTAOLDZGSNI34WHffmiM027bSeClavS3PI53W0zjDgHbW4ajgUFtBCTj0Btd8q7uvFpUG3FoPozzxzKeTEp/23Ai1AkBCvssgcdAJ/a41h/lztRphJaLFIQZwKzO64PbLksBS2wbHr32eAGEOeAPXr//3aEJxRfQFwtI9kyc1hVXOkBsbX6PG3PZ4FcUYNwVKsns01DlLodB1BRtfCtAUwoeJy7kZQOBYYtNDH5hXQKstEUp6L1Q0mQFa1vGnWt2gU/FKugAj/7J0+rRX27c2rr4po/dwmTwIW3ZaQCOZjvTpNK87oZfuUVOzn9zW4fIIVA4LrykVUEJhaD2qpBqQRNGU1XRkkqgd/VJXvyaA8hRpFWJCM+Xsif6M5rmpXb0b7s4C3vv80qCbmrGbfX/q89L/79rcI+sWRh9eyBHSkMaQa3lzSuKKImsQOHse34gl/s2D5RRh1aTDT
 q78rJD6g
 7wCNYuqiY04VKofOy7PD48w8jHEEqp4rgFWMp5mslx55RgZ9EIvRDanRJBvK4kJOzUfqe1vD1MhLt0N5WTGU3oLxKXhSO7aJIxL2tPVlFENd0GMoVkyV7D/IxNt6/RtslOPEGTTec+Ydu/FQC2xwZSX45+4qOr3qR3VwtKnNdGIknb/u7RirPyhlWiGW3FzD4EtVgGgLCfebIOeIb/CrvwzFTNZrcXwayAYCl2IypLear7aPaEy9RZRLssqgumbdo2dJlGM3BjY7UXL/LPhvhMEzPuJjZnVLXgEQsm6hpd//xEPD3d1+Qam2ELQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [Critical] x86/hyperv: premature zeroing in hv_vtom_clear_present() before transition
> - [High] Drivers: hv: uninitialized SynIC pages in hv_alloc_page() on non-CoCo VMs
> - [High] dma-pool: dirty cache lines left on linear alias by set_memory_decrypted()
> - [Medium] x86/mm: set_memory_decrypted() zeroes legacy VGA VRAM/MMIO in VGA_MAP_MEM()
> - [Medium] powerpc/pseries/svm: set_memory_decrypted() zeroes private page before sharing
> --
>

I used an LLM to review the CoCo implementations and suggest the correct
sequence for clearing memory. Except on s390 and pKVM, memory must be
cleared after it is converted to shared. The resulting patch is below,
with comments explaining the architecture-specific differences.

This needs review and acknowledgment from the relevant architecture
maintainers.

modified    arch/arm64/mm/mem_encrypt.c
@@ -17,6 +17,7 @@
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/mm.h>
+#include <linux/string.h>
 
 #include <asm/mem_encrypt.h>
 
@@ -42,8 +43,13 @@ EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
-	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+	if (likely(!crypt_ops)) {
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 		return 0;
+	}
+
+	if (WARN_ON(!PAGE_ALIGNED(addr)))
+		return -EINVAL;
 
 	return crypt_ops->decrypt(addr, numpages);
 }

modified    arch/powerpc/platforms/pseries/svm.c
@@ -54,14 +54,13 @@ int set_memory_encrypted(unsigned long addr, int numpages)
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
-	if (!cc_platform_has(CC_ATTR_MEM_ENCRYPT))
-		return 0;
-
 	if (!PAGE_ALIGNED(addr))
 		return -EINVAL;
 
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		uv_share_page(PHYS_PFN(__pa(addr)), numpages);
+	/* Sharing can replace the secure backing; clear the final mapping. */
 	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
-	uv_share_page(PHYS_PFN(__pa(addr)), numpages);
 
 	return 0;
 }

modified    arch/s390/mm/init.c
@@ -130,6 +130,10 @@ int set_memory_decrypted(unsigned long vaddr, int numpages)
 {
 	int i;
 
+	/*
+	 * uv_set_shared() exposes existing contents to the host; see the data
+	 * leakage warning in share() in asm/uv.h. Clear private data first.
+	 */
 	memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
 
 	/* make specified pages shared (swiotlb, dma_alloca) */

modified    arch/x86/coco/tdx/tdx.c
@@ -980,9 +980,6 @@ static int tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
 	if (!enc && !tdx_enc_status_changed(vaddr, numpages, enc))
 		return -EIO;
 
-	if (!enc)
-		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
-
 	if (enc)
 		atomic_long_sub(numpages, &nr_shared);
 	else

modified    arch/x86/hyperv/ivm.c
@@ -755,10 +755,6 @@ static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
  */
 static int hv_vtom_clear_present(unsigned long kbuffer, int pagecount, bool enc)
 {
-	if (!enc)
-		memset((void *)kbuffer, 0,
-		       (size_t)pagecount << PAGE_SHIFT);
-
 	return set_memory_np(kbuffer, pagecount);
 }
 

modified    arch/x86/include/asm/set_memory.h
@@ -52,6 +52,7 @@ bool set_memory_enc_stop_conversion(void);
 bool set_memory_enc_stop_conversion(void);
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
+int set_memory_decrypted_nozero(unsigned long addr, int numpages);
 
 int set_memory_np_noalias(unsigned long addr, int numpages);
 int set_memory_nonglobal(unsigned long addr, int numpages);

modified    arch/x86/include/asm/vga.h
@@ -14,7 +14,7 @@
  *	On the PC, we can just recalculate addresses and then
  *	access the videoram directly without any black magic.
  *	To support memory encryption however, we need to access
- *	the videoram as decrypted memory.
+ *	the videoram as decrypted memory without clearing its contents.
  */
 
 #define VGA_MAP_MEM(x, s)					\
@@ -22,7 +22,7 @@
 	unsigned long start = (unsigned long)phys_to_virt(x);	\
 								\
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))			\
-		set_memory_decrypted(start, (s) >> PAGE_SHIFT);	\
+		set_memory_decrypted_nozero(start, (s) >> PAGE_SHIFT);	\
 								\
 	start;							\
 })

modified    arch/x86/mm/mem_encrypt_amd.c
@@ -309,9 +309,6 @@ static int amd_enc_status_change_finish(unsigned long vaddr, int npages, bool en
 	if (!cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
 		enc_dec_hypercall(vaddr, npages << PAGE_SHIFT, enc);
 
-	if (!enc)
-		memset((void *)vaddr, 0, (size_t)npages << PAGE_SHIFT);
-
 	return 0;
 }
 

modified    arch/x86/mm/pat/set_memory.c
@@ -2545,9 +2545,22 @@ EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
+	int ret = __set_memory_enc_dec(addr, numpages, false);
+
+	/* The finish callback must restore the shared mapping before clearing. */
+	if (!ret)
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(set_memory_decrypted);
+
+/* Device memory needs a decrypted mapping without writes to its contents. */
+int set_memory_decrypted_nozero(unsigned long addr, int numpages)
+{
 	return __set_memory_enc_dec(addr, numpages, false);
 }
-EXPORT_SYMBOL_GPL(set_memory_decrypted);
+EXPORT_SYMBOL_GPL(set_memory_decrypted_nozero);
 
 int set_pages_uc(struct page *page, int numpages)
 {

modified    drivers/firmware/arm_rmm/rsi.c
@@ -147,6 +147,7 @@ static int realm_set_memory_decrypted(unsigned long addr, int numpages)
 {
 	int ret = __set_memory_enc_dec(addr, numpages, false);
 
+	/* The transition invalidates private contents; clear the shared mapping. */
 	if (!ret)
 		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 

modified    drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
@@ -62,6 +62,7 @@ static int pkvm_set_memory_encrypted(unsigned long addr, int numpages)
 
 static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
 {
+	/* Sharing exposes the existing contents to the host; clear them first. */
 	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 
 	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,

modified    include/linux/set_memory.h
@@ -5,6 +5,10 @@
 #ifndef _LINUX_SET_MEMORY_H_
 #define _LINUX_SET_MEMORY_H_
 
+#include <linux/string.h>
+
+#include <asm/page.h>
+
 /**
  * DOC: Kernel page table permissions
  *
@@ -21,7 +25,8 @@
  *
  * When an architecture does not implement these APIs they succeed without
  * doing anything, so a return value of 0 does not mean that the permissions
- * were actually changed.
+ * were actually changed. set_memory_decrypted() also clears the range,
+ * including when no encryption change is needed. It is for normal RAM only.
  *
  * Callers that depend on the permissions being applied must ensure that the
  * architecture supports the required operation for the target addresses. The
@@ -186,6 +191,7 @@ static inline int set_memory_encrypted(unsigned long addr, int numpages)
 
 static inline int set_memory_decrypted(unsigned long addr, int numpages)
 {
+	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 	return 0;
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */



