Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB83606DA2B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B2hCienY
Received: by kanga.kvack.org (Postfix)
	id A84256B07D9; Tue, 27 Oct 2026 11:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E3E6B07DB; Tue, 27 Oct 2026 11:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8879B6B07DC; Tue, 27 Oct 2026 11:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC0F6B07D9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A24C11C43E6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:00 +0000 (UTC)
X-FDA: 85368834600.27.3F709AE
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id C7E45180006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=B2hCienY;
	spf=pass (imf24.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Ywf1kYABPcYkKuVCWE8YXozL9O+0YxMyRYyN2zEgtg=;
	b=iy2E2ynavUN7ofCTsrX4OAmurBv06juqoDeUP8hwKRIcZ8n3A1E1PHtE4eHrqScCZzfuWC
	kfCUDduxPxACRqoxEv2vtcrfnYXckuycJlmi/kcXigDRhvZZYLeDS4kB3RFCJbB7ViDWpw
	n65c2yatvFASjfgLCBdi6gBmV2oqQfE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=B2hCienY;
	spf=pass (imf24.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116018;
	b=jOeK+FBjBj7kcWNNHTlaZaq2EtQHimNlad5ZGwp2cdWo8a97e+FOz7cR2xDTJeu9XxXWyI
	Riptwhar57bL95n1nqZrUs6QS/57ddh1/0rlXuNTr9IYJAelT4QWcQJE394LB9sa0TpeH4
	iYfuR9pxOdr8ehQO8fVKh5rjRD3cTvA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a215e64962so35272125e9.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116017; x=1793720817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Ywf1kYABPcYkKuVCWE8YXozL9O+0YxMyRYyN2zEgtg=;
        b=B2hCienYrgkmvjTRTe4ATqsOmOUYdkpz4ZLFfWpzGtc+UfTo0Y0T7u1ZNHb8z9biIr
         v+mzPbj6v1B6uJD43Bi+WCV/KF27mP/YhPjURh364mqbbuzWOD9FAcnYGaJpsyEsMKFQ
         lJ61zv+MCLelqmKknioRLLXlYnyk7emJA9HKxtFZaAHcqlnAyJ9Z5Z8n8+ukeFxKyF1r
         lqDjoGgh7maxWmAJeYwjb4V8DS1qQObuNkGSR5uyQZhM/yk4+P4jYbsa1+NNu9hlFogY
         0O+wg0yebp8QT098Z3i5tfg76QpXVbkWfql09Dauxl6vn/nJNKw6Zi1tNcToTY1HzAAo
         CXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116017; x=1793720817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2Ywf1kYABPcYkKuVCWE8YXozL9O+0YxMyRYyN2zEgtg=;
        b=lLaFSbmfRDfXbwIvKEcgmpz7f6WKRd/2W9S3jH3adTAJHv/AfuAU78vw9gIaAziALv
         ZWkV5xjhMOWWKvCHFboajAqo2pmptKK7xp3tL4JuKkwDluIX3fNwcFv/mX8DcjBgHgV4
         iJEheFRNEm4bT5z3J4ObI8HFNuZgDhX6z9E+aF5eFj2O1vcSqRsIWuli0LCZ39i/yA3Y
         h2mAVuwBAu5B7lXos9gq2Lck/NNy+srB4MyEMTyL/Edg3MPdzAGMd8++1uR/0D1Pc+Cc
         hES8YiQ7PJSweDRn8LxajNv+x2XIJspaYqfjtMN7wVJJHejhNGXsR+cUxwzPD3IsMa56
         iHMw==
X-Forwarded-Encrypted: i=1; AKwUvBxJjYjUrpA5guEMHHA/rnjJjORuxYZrfAx8T0KJEVwEsNnoot+DEjEMZynUxeDGtq5nDzJBtexFZA==@kvack.org
X-Gm-Message-State: AFq9FYI4pW4bRrGBc2J2wUbow9kt/Lu81gmcBbH3+a/PDL0JJdVdsk9n
	56TsZ4hAb6WgrxhRU5kF/hvE88t4CYC64lbfDJGCuYz1BpSNlFIxY6PN
X-Gm-Gg: AYBFou1PdZGjKqh8gGnFcKt2fv65sDDd0mF7IPJHsav22YHYL/vaCWILyR0/kREfQnM
	BeAG8/VjEsF3qGJJo8SOWWQFiEngu0E83ri6a7R5JF4KxOnRw4VDN4k095zGy6jSwVYYTY8pEI5
	joHL9lxbIjSWZwYXH+Ub6UOCRAxgFZ2fNGn1X9KIe9jK1VetlYpclf8pk/WKOYBbTdBXCZ5WdDL
	Z8Xw/2aulWGh3StRaTHXIbA2kiAf4HqW+Xe37tOhMcXBT4gYTc+zks/v0pjaL6hvZZSKE56/vVF
	Qgzr3yQf0iCLDYny4EIhpp8vjR1GQ1li3dz9LX/6JNv5dXDyWFyi05kOJ5yRV5eHifCv10HG3FU
	bYUf8DgwPpe9T9aRcOL+kxufsfkQc8IYAOAli90qXZbQqF18D7kHE6vkV++fOJj72bWEzbeg7a+
	1uXHlG7x1AIAjUGva4+2w6VY0SAHUNowiAUx8R/bed+iTT4OjGoo5DHSloh3/vd6TadLxmsNsvl
	dYiv8zo6V354QQWUujuzlz4O5k4j3Ac4P6nfd172TYwpDm2jaxnHZW9SzwOD9zTS6LVL2NbmSdQ
	xUwUOGlsc20WLWiJ9R9pTQjXLPBNE5Yh4szDbSxlRvupMD+IMzK6JsrUeiMTaM4Fa411iZGJAul
	uNF6YsK4KL5SXA/gv
X-Received: by 2002:a05:600c:8b41:b0:4a7:7d22:c50c with SMTP id 5b1f17b1804b1-4a77d22c51amr83981995e9.2.1793116017189;
        Tue, 27 Oct 2026 08:46:57 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.46.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:46:56 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: [RFC PATCH 02/14] KVM: guest_memfd: Support read-only frames from PFN mode providers
Date: Tue, 27 Oct 2026 15:46:37 +0000
Message-ID: <20261027154649.91571-3-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C7E45180006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 89hpjot78wwgnwbwmc8end3nhf3r8syf
X-HE-Tag: 1793116018-796750
X-HE-Meta: U2FsdGVkX1+TwyjmvZc04ru8m5fk/NXlvSi3TFnRtYjWe0miJMr5cc9H1riHaDCKep2He8sSBKZrl7rTOxQVjIs0/hvAS9oCemJdWcYBWUZ6TTP5WDje+C/7o7h048BT9Clhed8u01bdTb8A2DZb+fpIcd/McYLbaWtAStt8e9MBvVp2HlWlJ3Tim2vV/g3Q8WtwZKN7K7f6eGDImN8CRTtoRGvXxVzY3sn85dZBDE1mPShcMETzYRl8fs94MyA/R8ryz1hhLPG5StC1XHSyNup6P8rcy4g6pt/4d1sA9+guhbALDA11aPwrV6tQVrPJe6FTxpxaNRPUndj9aZ0srj8j/6T2MxKJJ33au4kw6Xj1Bd3ieBLE6Cal8st2u9xnXoQvrPmIPDKoC92WThzllItq124rV6XnwSQ+EANdwfyA8vYiKKA6VXPIm4Ey+ps32eY/Vse8Z8Q9hI+qAhSd4TNDbuEFoQIae+miBZ6LZshK4zrTh48o+cJm1p1uXIymVYIEFou84pVHwb0lVFYS930qAABJaWM350fPMGpE7KKK2RiL9oz2IC+CYwNgoCzqBvY/H5Xt8vTMGCOS8mzVdf8gDAfAZJAo4GvXnAJVV0oBaaqJjmp1J5nOnFH0DEGOs9ub5fWNgZONvJs+pPkThzZ8ogMxfOWo3o2NQreJt3KU1VhJ8U2xpgYIeeA1Fow3EEE+Xb12OpMRG81ZUCgdGznzs1ToSZRuP4gDEXOlUoAbMeS2iYEymXCuptGEfKvlMIEZNzUwMiTJKHhayutLo6rz2eaGuLmdU+tiPLIkfbxlbEnaHaVCF9Dxqd+6u9m+m0bNp+3CNCcPw4+Pnfv1e4+8m4KsCxaEM9xLdxzT2X5aops+NpuEb9aUOmei9mxFC9KnIrur2gdjoFM6ufQHPVErY0P60OcEIP36SgRBdHkZbxdlpiE2Hv/xXrtZhbn2SfujXInwYtBTxMdDotx
 6oUflvY6
 UtQ7CbhbZ7Pfojw9XR4B+OI9MgkbpJsfToKh5HCAvHYRfkVaa9giprfr8+uIHSNWxpZynOhk+WbCiAHr/frK6/eFHiODVfXPkyny6JcY7vkVpodXr39b25V/fdVmk1AQb331L8JeZc3kyCDcbPmfyKvqO21E96t7vFREE8x25KeVkq6X6tRYbbIYv+lEH1emb9ToO7s2Rg6AzM5F1nEvLl2EWnI5WdngxqJPoxm8Nk6LvNShmr2rmFZBn2NJc72zjeE03KjeSbWXs7x990c11Q2x5o14vuizVAI+RpuLs6EYZo2Oy20DB3tsjUKV///u2w/kLIF5VLy73aPYTIAWgR3ZDkV84jopsdXVz9bCUSuTta0Rz4VvcJ9YtZREY+0/v1RpQEpZ9tm3Jc59eGU60lJmwzCdlAAKcNpN6GGTfuGoBGVGfkjw/MAdrrSw6vPCgt8GGpLmD6TlPB9lyu0l2kddRFV8gn/xSr8V2jzGPskGX4c/oLxfDa3SdfALMntIiRX7aplRSZTT5j0XQPEIeCE80UDMvcPS+6sS2AP6s7oJFpgkIvK9SJZad6D0CfQAuP8pPsey24gje4ypQrlCWuZGbpJT3ZSrxTYkM/73aPIvsz2Cun1aqEY41LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

A PFN mode provider may lend a frame that the guest must not write,
e.g. one shared by several guests, but guest_memfd maps every frame
writable.

Add an attributes output to get_pfn(), with GUEST_MEMFD_PFN_READONLY as
its first bit. KVM then maps such a frame read only and exits to
userspace on a guest write, and the VMM's mapping raises SIGBUS on a
write. A read-only frame cannot back a private page or be populated.

On arm64, the new exit in gmem_abort() also restores the return after a
failed kvm_gmem_get_pfn() that a kvm/next merge dropped.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/arm64/kvm/mmu.c              |  10 ++-
 arch/arm64/kvm/nested.c           |   9 ++-
 arch/x86/kvm/mmu/mmu.c            |  15 +++-
 arch/x86/kvm/svm/sev.c            |   4 +-
 include/linux/guest_memfd.h       |  24 +++++-
 include/linux/kvm_host.h          |   6 +-
 samples/kvm/mem_provider_sample.c |   2 +-
 virt/kvm/guest_memfd.c            | 128 ++++++++++++++++++++++++++----
 8 files changed, 168 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 745cb86f9e04..cdf6d671158a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1736,7 +1736,7 @@ static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 		      struct kvm_s2_fault_result *result)
 {
-	bool write_fault, exec_fault;
+	bool write_fault, exec_fault, writable;
 	bool perm_fault = kvm_s2_fault_is_perm(s2fd);
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1773,17 +1773,19 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, NULL);
-	if (ret) {
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, NULL,
+			       &writable);
+	if (ret || (write_fault && !writable)) {
 		/* If result is non-NULL this is a synthetic fault. */
 		if (!result)
 			kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(canonical_gfn),
 						      s2vi.vma_pagesize, write_fault, exec_fault,
 						      false);
 		kfree(mapping);
+		return ret ?: -EFAULT;
 	}
 
-	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
+	if (!(s2fd->memslot->flags & KVM_MEM_READONLY) && writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (s2fd->nested)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f1c414f1c3fa..ec3bcdc230cf 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1615,12 +1615,19 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 			return -EFAULT;
 		}
 	} else {
-		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL);
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL,
+				       &writable);
 		if (ret) {
 			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
 					      write_fault, false, false);
 			return ret;
 		}
+		/* The CPU writes the VNCR page: a read-only frame cannot back it. */
+		if (!writable) {
+			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
+					      true, false, false);
+			return -EFAULT;
+		}
 
 		writable = !(memslot->flags & KVM_MEM_READONLY);
 	}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5a2cc6a17a9b..1c50955e80f9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4675,6 +4675,7 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 				    struct kvm_page_fault *fault)
 {
 	int max_order, r;
+	bool writable;
 
 	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
@@ -4682,13 +4683,23 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &max_order);
+			     &max_order, &writable);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
 	}
 
-	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+	/*
+	 * guest_memfd may report a read-only frame: map it without write
+	 * permission, and exit to userspace on a guest write rather than
+	 * install it.
+	 */
+	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY) &&
+			      writable;
+	if (fault->write && !fault->map_writable) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
 	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6427db390b1c..4125b4fd30da 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4096,7 +4096,7 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	 * The new VMSA will be private memory guest memory, so retrieve the
 	 * PFN from the gmem backend.
 	 */
-	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL, NULL))
 		return;
 
 	read_lock(&kvm->mmu_lock);
@@ -5092,7 +5092,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order, NULL);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index a38a81693422..9d8764b93af2 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_GUEST_MEMFD_H
 #define _LINUX_GUEST_MEMFD_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 
 struct file;
@@ -23,9 +24,12 @@ struct mempolicy;
  *           zeroing if necessary. On success, return 0 with the physical frame
  *           number in @pfn and, if @max_order is non-NULL, the largest order
  *           for which the naturally aligned block of 2^order pages that
- *           contains @index is backed by contiguous frames. Returns a
- *           negative error code on failure. The provider must define
- *           @lookup_pfn_range when @get_pfn is defined.
+ *           contains @index is backed by contiguous frames. @attrs, preset
+ *           to 0 by guest_memfd, receives the GUEST_MEMFD_PFN_* attributes
+ *           of the whole block. A provider that changes them must then
+ *           kvm_gmem_revoke() the range. Returns a negative error code on
+ *           failure. The provider must define @lookup_pfn_range when
+ *           @get_pfn is defined.
  * @lookup_pfn_range: Look up the PFN for a given index. Returns 0 on success
  *                    with the physical frame number in @pfn and the number of
  *                    contiguous pages the mapping is valid for in @nr_pages.
@@ -49,12 +53,24 @@ struct guest_memfd_provider_operations {
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
 	int (*get_pfn)(void *provider, pgoff_t index, unsigned long *pfn,
-		       int *max_order);
+		       int *max_order, u32 *attrs);
 	int (*lookup_pfn_range)(void *provider, pgoff_t index,
 				unsigned long *pfn, size_t *nr_pages);
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
 };
 
+/*
+ * Attributes of a PFN mode block, reported by get_pfn().  Only the provider
+ * knows them, and every mapping of the block must follow them.
+ *
+ * READONLY: the guest may read the block but not write it, e.g. a page that
+ * the provider lends to several guests.  guest_memfd maps it read only for
+ * the guest and the VMM, and never backs a private page with it.
+ */
+#define GUEST_MEMFD_PFN_READONLY	BIT(0)
+
+#define GUEST_MEMFD_PFN_ATTRS		GUEST_MEMFD_PFN_READONLY
+
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 		    const unsigned long *pfn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 345f97b110fa..3d0db49ad08b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2628,11 +2628,13 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order,
+		     bool *writable);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-				   kvm_pfn_t *pfn, int *max_order)
+				   kvm_pfn_t *pfn, int *max_order,
+				   bool *writable)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 5496e0c7864b..f30654a60dd8 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -179,7 +179,7 @@ static void mps_gmem_release(void *provider)
 }
 
 static int mps_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
-			    int *max_order)
+			    int *max_order, u32 *attrs)
 {
 	struct file *resource_file = provider;
 	struct mps_info *info = resource_file->private_data;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index be26bd16d420..1554a17906da 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -142,18 +142,25 @@ static struct folio *gmem_provider_alloc_folio(struct gmem_inode *gi,
 }
 
 static int gmem_provider_get_pfn(struct gmem_inode *gi, pgoff_t index,
-				 kvm_pfn_t *pfn, int *max_order)
+				 kvm_pfn_t *pfn, int *max_order, u32 *attrs)
 {
 	unsigned long raw_pfn;
+	u32 __attrs = 0;
 	int r;
 
 	if (max_order)
 		*max_order = 0;
-	r = gi->provider_ops->get_pfn(gi->provider, index, &raw_pfn, max_order);
+	r = gi->provider_ops->get_pfn(gi->provider, index, &raw_pfn, max_order,
+				      &__attrs);
 	if (r)
 		return r;
 
+	if (WARN_ON_ONCE(__attrs & ~GUEST_MEMFD_PFN_ATTRS))
+		return -EIO;
+
 	*pfn = raw_pfn;
+	if (attrs)
+		*attrs = __attrs;
 	return 0;
 }
 
@@ -546,7 +553,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 				break;
 			}
 
-			r = gmem_provider_get_pfn(gi, index, &pfn, &max_order);
+			r = gmem_provider_get_pfn(gi, index, &pfn, &max_order, NULL);
 			if (r)
 				break;
 
@@ -721,13 +728,71 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
 	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
+/* The protection for a host mapping of a PFN mode frame with @attrs. */
+static pgprot_t kvm_gmem_pfn_prot(struct vm_area_struct *vma, u32 attrs)
+{
+	vm_flags_t flags = vma->vm_flags;
+
+	if (attrs & GUEST_MEMFD_PFN_READONLY)
+		flags &= ~VM_WRITE;
+	return vm_get_page_prot(flags);
+}
+
+/*
+ * Map a PFN mode frame for the host.  Called with the invalidate lock held
+ * shared, so that a frame is never mapped after the revoke that removes it.
+ * A read-only frame is mapped without write permission, and a write to it
+ * raises SIGBUS.
+ */
+static vm_fault_t kvm_gmem_pfn_fault(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct vm_area_struct *vma = vmf->vma;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	kvm_pfn_t pfn;
+	u32 attrs;
+	int r;
+
+	r = gmem_provider_get_pfn(GMEM_I(inode), vmf->pgoff, &pfn, NULL, &attrs);
+	if (r)
+		return vmf_error(r);
+
+	if (write && (attrs & GUEST_MEMFD_PFN_READONLY))
+		return VM_FAULT_SIGBUS;
+
+	return vmf_insert_pfn_prot(vma, vmf->address, pfn,
+				   kvm_gmem_pfn_prot(vma, attrs));
+}
+
+/*
+ * A write to a read-only PTE, e.g. after mprotect(): allow it unless the frame
+ * is read only.  The core upgrades the PTE under its lock only if it did not
+ * change, and a provider that makes the frame read only revokes it first.
+ */
+static vm_fault_t kvm_gmem_pfn_mkwrite(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	vm_fault_t ret = 0;
+	kvm_pfn_t pfn;
+	u32 attrs;
+	int r;
+
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	r = gmem_provider_get_pfn(GMEM_I(inode), vmf->pgoff, &pfn, NULL, &attrs);
+	if (r)
+		ret = vmf_error(r);
+	else if (attrs & GUEST_MEMFD_PFN_READONLY)
+		ret = VM_FAULT_SIGBUS;
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+	return ret;
+}
+
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct gmem_inode *gi = GMEM_I(inode);
 	vm_fault_t ret = VM_FAULT_LOCKED;
 	struct folio *folio = NULL;
-	kvm_pfn_t pfn;
 	int r = 0;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
@@ -737,9 +802,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) {
 		r = -EACCES;
 	} else if (kvm_gmem_is_pfn_mode(gi)) {
-		r = gmem_provider_get_pfn(gi, vmf->pgoff, &pfn, NULL);
-		if (!r)
-			ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		ret = kvm_gmem_pfn_fault(vmf);
 	} else {
 		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 		if (IS_ERR(folio))
@@ -815,6 +878,12 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 #endif
 };
 
+/* PFN mode: a write to a page mapped read only comes back to guest_memfd. */
+static const struct vm_operations_struct kvm_gmem_pfn_vm_ops = {
+	.fault		= kvm_gmem_fault_user_mapping,
+	.pfn_mkwrite	= kvm_gmem_pfn_mkwrite,
+};
+
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gmem_inode *gi = GMEM_I(file_inode(file));
@@ -827,8 +896,11 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	if (kvm_gmem_is_pfn_mode(gi))
+	if (kvm_gmem_is_pfn_mode(gi)) {
 		vm_flags_set(vma, VM_PFNMAP);
+		vma->vm_ops = &kvm_gmem_pfn_vm_ops;
+		return 0;
+	}
 
 	vma->vm_ops = &kvm_gmem_vm_ops;
 
@@ -1503,7 +1575,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
-					int *max_order)
+					int *max_order, u32 *attrs)
 {
 	struct file *slot_file = READ_ONCE(slot->gmem.file);
 	struct gmem_inode *gi = GMEM_I(file_inode(file));
@@ -1522,7 +1594,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	}
 
 	if (kvm_gmem_is_pfn_mode(gi)) {
-		r = gmem_provider_get_pfn(gi, index, pfn, max_order);
+		r = gmem_provider_get_pfn(gi, index, pfn, max_order, attrs);
 		if (r)
 			return ERR_PTR(r);
 		return NULL;
@@ -1588,14 +1660,22 @@ static int kvm_gmem_pfn_map_order(struct inode *inode, pgoff_t index,
 	return order;
 }
 
+/*
+ * @writable, if not NULL, is set to whether the guest may write the page.  It
+ * may be NULL only for private pages, which are always writable.
+ */
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order,
+		     bool *writable)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
 	int r = 0, __order;
+	u32 attrs = 0;
 
 	max_order = max_order ?: &__order;
+	if (writable)
+		*writable = true;
 
 	CLASS(gmem_get_file, file)(slot);
 	if (!file)
@@ -1603,15 +1683,28 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order, &attrs);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out;
 	}
 
-	if (kvm_gmem_is_pfn_mode(GMEM_I(file_inode(file))))
+	if (kvm_gmem_is_pfn_mode(GMEM_I(file_inode(file)))) {
+		/*
+		 * A read-only frame is not the guest's alone, so it never
+		 * backs a private page: a private fault on it is a hole.
+		 */
+		if (attrs & GUEST_MEMFD_PFN_READONLY) {
+			if (kvm_gmem_is_private_mem(file_inode(file), index) ||
+			    WARN_ON_ONCE(!writable)) {
+				r = -EFAULT;
+				goto out;
+			}
+			*writable = false;
+		}
 		*max_order = kvm_gmem_pfn_map_order(file_inode(file), index, gfn,
 						    *pfn, *max_order);
+	}
 
 	if (kvm_arch_has_gmem_convert() &&
 	    kvm_gmem_is_private_mem(file_inode(file), index))
@@ -1637,12 +1730,13 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
+	u32 attrs = 0;
 	kvm_pfn_t pfn;
 	int ret;
 
 	filemap_invalidate_lock(file->f_mapping);
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
+	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL, &attrs);
 	if (IS_ERR(folio)) {
 		ret = PTR_ERR(folio);
 		goto out_unlock;
@@ -1651,6 +1745,12 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (folio)
 		folio_unlock(folio);
 
+	/* Populated pages are private, and are written: not a read-only frame. */
+	if (attrs & GUEST_MEMFD_PFN_READONLY) {
+		ret = -EPERM;
+		goto out_put_folio;
+	}
+
 	if (!kvm_is_private_gfn(kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
-- 
2.47.3


