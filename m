Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32838CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813756B00A7; Wed, 14 Oct 2026 05:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9A06B00AA; Wed, 14 Oct 2026 05:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1A36B00AB; Wed, 14 Oct 2026 05:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDB0B6B00A7
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:37:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6743A1C3C66
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:41 +0000 (UTC)
X-FDA: 85320729522.05.027D2D2
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 93FFBC0003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oQhofwVI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXoOtdmnob+YnMth1qvSHm903lQEMfykmhDcceAz8kQ=;
	b=tyQ+FkISUWRhLCRVSfKzwAcCxK04qJjCSGCPqGN/Zj1h7UPk0hDhkFOdyx82aYqTNPJ2Ea
	2eaPEFarYd5kgJMRIRkhNo9SL2w7Pyv6JGgSkbeOm/NnPFR4tusz3daSGDFaZfS2RZKqpl
	MZBJv9voR3capX6Sci2uL662w+p3M/0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oQhofwVI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970659;
	b=FCsBR+twmcdZSlhRYeDSTUknQ54w5ta+hyiNUnRmEp9QGkRhX4/oXqH3qTw73lfiFkQhY7
	zWWX5yhlalkwufmY0SrAGcjmK0fkNloKdy7s/qpsOUlMIK5x1Vxp5jQk1x6sI6KBB52Han
	eVXkg9S/OS8sYsiRIdlg/u2gA8iCSt0=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48deeadb3fdso249349f8f.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970658; x=1792575458; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sXoOtdmnob+YnMth1qvSHm903lQEMfykmhDcceAz8kQ=;
        b=oQhofwVIjh08GQBnW/FO8MgJbdaISmkn5yO9XDHkgKlMMdtaTKNF1ft+nzkCCOIz36
         tQBCox3h41QAafShQ/bxb5hfvdCYXqPMl7oPbJtOHVfKjp66KsrMHl7oZxv0ANrYjAvP
         CedC02g1VoFXFIEFJRUT0WE23unWM/qataWqIzEFClArS8KcWgTeqkTANDk1Et4D9ru/
         XJxFsnwfbi9yJ2PV3NFuWZy0vQkfDA3o/QekcvOegnJyPshOg+v3aZbtyddOMvSpHGOc
         uN11OTmrlwVQ1PQN8GdQL8A3fqoq0WzWQRvkmOjb6+Gp+SH5CigqRYFnPAIsXxahW56F
         R/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970658; x=1792575458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sXoOtdmnob+YnMth1qvSHm903lQEMfykmhDcceAz8kQ=;
        b=0yscebCVaLflDTyZ8fdrCoO4+oSIoHnjpz92k4JLOsNYsXS1SjVlKZdQsV/AVNnlks
         6WIWxHjIpTAcx/Q04XrnoSAjPLJJJ4mfZVWYA0yqnc9BaJYggo57E0FHQJQETRJPZfUI
         PDAxFk5DWyF9dXhp6mlDv5MWdOn28QF5I5l1MUc7YhkDCSoFqD6GNv9E8JHEf5q/6ho9
         2a8OrbXnd4n//kK4QiHnPXPI2iElBVRphRfDGeWFO7gt4JU2eHULgRV5IB+pCG1cw1GC
         7lGNaTPsQGWia4xBXWEA4gtffq8wzEyyS69kXB4QLzcuayVytkxlo/ynSPAm3Ddh9vk9
         NaIQ==
X-Forwarded-Encrypted: i=1; AKwUvBxyQOTGp7IjeU+y/lT+uyRAGRYf8UahTD+WtXzBSarReXGEdG4jrb99NUaxJXG0oDt1T/c3euhF5g==@kvack.org
X-Gm-Message-State: AFq9FYIbWdSo7LT4yBGrykW5M4j8qXlpPjP3IOdSyQcn8sljL6XPE3MP
	wGeLTmSfRGdEEUw4kwJtfoLZyKnAPaEv24uY3NtTGR7H+4VBtWOdTFZy
X-Gm-Gg: AYBFou3KXWqAXmaz6CRhS9ad7M0lqNIMs1xn6IDj8vsFdpwu2qDNKubWXkQ4vLGlvGZ
	7ag8QkAqhNRE5EGfY7ZRZro1f1NrKhFQlAT1ylpqKXw2d9N3oztp10dm0qaqXad9/Xax/sdX2yl
	8pXfhnjkbDKvsaITItkWOPQsNf0OofC68zhkA6nFF5CPND5S2xRLNmhHF8wWQpZ9a5jGJZja0rH
	HPuBqKhLKJEnKRITSBZmv2fZ8C9E14HSzkwpZ8cbIAWMaPwDRI1IJ9TKt0CVDzdtwZTWJu3Ku3h
	Yyd3BpiAn4Ox+DYU5Vr7f8fRFnHqbhIqStLFfqNr0IPYKo+tr8fYfEH2y/x7RygC76eOMz99Gm4
	jxp4Wi1UMr+pyrX1tQCnyvxvnen6HXG+tIbK/1McJZVc3BRZJLlx8vzSHMz+qjZofZGeD7DoZVY
	4JvSzWcUToaxrujXNaF4rkw8x+4+7/AkilHku52y9ZDeHs4c5z7blUf9ZizQSnltlh0kTq3lWo5
	0+DjN1BTB8qhGplh+o9rSbM8MwVL50jMuJClXHLPU1aidFTFSZYniSWyoAiGHZh1p0ztfyzFdi+
	a49v4cxi2jXVPqK6XTu4MUNrhdca8t+JzOPLK2l22oYVPQ==
X-Received: by 2002:a5d:4381:0:b0:48c:7d67:8ee9 with SMTP id ffacd0b85a97d-48dbacec815mr21345295f8f.19.1791970658161;
        Wed, 14 Oct 2026 02:37:38 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:37 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 02/11] KVM: guest_memfd: Let get_pfn() report read-only pages
Date: Wed, 14 Oct 2026 09:37:24 +0000
Message-ID: <20261014093733.90312-3-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 93FFBC0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: wy6s5ksuzw3mc36f5j3t97c4rw3u6dun
X-HE-Tag: 1791970659-633374
X-HE-Meta: U2FsdGVkX18LbV361jkAo1WhvivDg6k30p7A65OWuAbOHuRgCP9F/XfbpPGDJO46Cr5R0Kdf8RueX++Hqaxzm3a212qLrPcvayOq67w4dy33/GWlsbUsegS6RaVN2sddn+QBk70vd3DffAyRXNTPNP9l47600kCF79RhFw1w7OYNPkxhUG81Tyxpb0c83ECPcqTjqSm269U1KiHmtB7l1/yYACwYbxyzUzEEOMd+ui85KPisRe7Y6jfYWptsz6JpEnzYOKFCH90aGRawXb6jDMRgYWKFtt7kDqWL4KXbth3FGgzzBQt7rjsXbuGeZqstQ/5YMwWGzmENM8xtsb2iUWPSMS6LMBkl+pBubGFBVcFPDtXV/z1O7v0jjnTHoJ7U/1nzYPfJ/4p/IPDQ7gX04rRP+ACngb/UmELDdSOtHkwAFDCvz98mNXW7L1+N+0qvbFx3xWrrS8Gxxe4awm2PNwgZ+vVmPqEqsShHOzgVSXr8r3s7zvkpyccTK7l9OLq+MxVVPmLceIR0Ac53cp35hE/9+TBJutITFkxk3lBYiz34PUKbQwPWPnbi/z+bd6P5Vep4yXe0hX/GJp82KguQt393E/4w/H4M7giufN+CCgO4CWCiqKRrML1AdnMDAK0vcPedH+JAqd9UA774prlwp/1fJdF0m3Q0ioF2GpDv8rzLaALYbrPKToZY3j7PnNa4t8ZY9wETe9/5/l3WoAvzKDvxnkHBS/N9ZOc8c4vyAcg3mO3HwA5b9yvW+1GlOOrqCXjgiQfB/weXSltcsN3ZCL90iSH9NRw6i21eTEDsBnnrBe98sT4hmQ+JcGK/8AB6RWqLTiSa18WKpq70gLBYof/10Tjsp1Gw3YnTQIpNunSwevlQm2hPi7Yx3m/iCU5sPlTTMJhFJFR+U87wzfLAZRPB295j5BMy3RD+4kOfpFgqsRm42Pv/ZEKas2EpLRO3yUP8NvvEjN/MOVsdG9X
 CTlf6BMq
 uRmOr4Ayr8D5vfGIEJUZ7KEldpPohalwdwUpZ7afCirlQQS8O80+hnyCxf+mcbVgdcTrcYEiSwi6D68unpXBorhTyRBthytPJBHU+kAhxd4gxTedEBuPzighB+dI4UVbbiTJKzaRvdZF/WtEqOz+qyx2t6G8XdezRzvIT4UA358IcZ0+J6OJ7vu3ngYPedOKjV2JMuxcam6nd00uW6KVW91bTcccnjfrIR7C827qnOnd6mvHsqg0pwLhP8WTXNnqKTwXuLw2mEUwsvlP/5squCTbi35shBYG245rU8BK90G/kdhfNdppXG/d5LWx2JZ8mP+UxS5WqDev7QjV2+v+IK7xk4DPkQH1RlgLO1U62zv7AyKbNJDCsMV5IV9BVrrrFXrTmuKWG33aZscu3evozKFJlbigApz0oE9TSZmrX8UH2n/DY9CoNe4sjsFm1o8yMKdg17XUIMHL/QmDQOE8/j5VnJpQ+OKhRIhTVwq5obqgr5g+oqMdQMST1qMoQF0bWxTrKJbhoNQbv7IJJAKcmFu4xOxMCBs7W1f3U+Jt5y2e4B2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

A guest_memfd backing cannot map a page read-only for the guest:
get_pfn() returns only a frame, and KVM_MEM_READONLY is refused on
guest_memfd slots. So a hypervisor cannot give a guest a page it may
read but not write.

get_pfn() gets a writable output, which it may clear. The x86 and arm64
fault paths then map the page without write permission, and a guest
write exits with KVM_EXIT_MEMORY_FAULT. A read-only answer applies to
the whole block that max_order allows.

Callers that hand the page to something that writes it must refuse a
read-only page: the arm64 VNCR page and the SEV-SNP VMSA. populate() has
no writable output, so a backing cannot report read-only state through
it. The output does not cover KVM's own writes through the slot's host
address.

The memory provider backing, later in this series, is the first user.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/arm64/kvm/mmu.c     | 13 ++++++++-----
 arch/arm64/kvm/nested.c  | 16 ++++++++++++----
 arch/x86/kvm/mmu/mmu.c   | 18 ++++++++++++++++--
 arch/x86/kvm/svm/sev.c   | 13 +++++++++++--
 include/linux/kvm_host.h | 16 +++++++++++++---
 virt/kvm/guest_memfd.c   | 21 ++++++++++++++++-----
 6 files changed, 76 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..32e591edc69d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1607,7 +1607,7 @@ struct kvm_s2_fault_desc {
 
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
-	bool write_fault, exec_fault;
+	bool write_fault, exec_fault, writable;
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1641,14 +1641,17 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
-	if (ret) {
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL,
+			       &writable);
+	if (ret || (write_fault && !writable)) {
 		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
 					      write_fault, exec_fault, false);
-		return ret;
+		if (!ret)
+			kvm_release_faultin_page(kvm, page, true, false);
+		return ret ?: -EFAULT;
 	}
 
-	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
+	if (!(s2fd->memslot->flags & KVM_MEM_READONLY) && writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (s2fd->nested)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index fb54f6dad995..fa86705df949 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1411,11 +1411,19 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
 			return -EFAULT;
 	} else {
-		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
-		if (ret) {
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL,
+				       &writable);
+		/*
+		 * The VNCR page is always written, so a read-only page cannot
+		 * back it.  Exit on the first access, even a read, rather than
+		 * map it read-only and fault on the next write.
+		 */
+		if (ret || !writable) {
 			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
-					      write_fault, false, false);
-			return ret;
+					      true, false, false);
+			if (!ret)
+				kvm_release_faultin_page(vcpu->kvm, page, true, false);
+			return ret ?: -EFAULT;
 		}
 	}
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 234d0a95abf5..f689ef5c2b46 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4612,6 +4612,7 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 				    struct kvm_page_fault *fault)
 {
+	bool writable;
 	int max_order, r;
 
 	if (!kvm_slot_has_gmem(fault->slot)) {
@@ -4620,13 +4621,26 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &fault->refcounted_page, &max_order);
+			     &fault->refcounted_page, &max_order, &writable);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
 	}
 
-	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+	/*
+	 * get_pfn() may clear writable, on top of the memslot's read-only flag:
+	 * a read-only page is mapped read-only, and a guest write to it exits to
+	 * userspace rather than being installed.
+	 */
+	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY) &&
+			      writable;
+	if (fault->write && !fault->map_writable) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		kvm_release_faultin_page(vcpu->kvm, fault->refcounted_page,
+				 true, false);
+		fault->refcounted_page = NULL;
+		return -EFAULT;
+	}
 	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 427229347876..e121441bc89c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3988,6 +3988,7 @@ static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_memory_slot *slot;
 	struct page *page;
+	bool writable;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
 
@@ -4025,9 +4026,17 @@ static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	 * The new VMSA will be private memory guest memory, so retrieve the
 	 * PFN from the gmem backend.
 	 */
-	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL,
+			     &writable))
 		return;
 
+	/* The CPU writes the VMSA on every VMRUN: a read-only page cannot be one. */
+	if (!writable) {
+		if (page)
+			kvm_release_page_clean(page);
+		return;
+	}
+
 	/*
 	 * From this point forward, the VMSA will always be a guest-mapped page
 	 * rather than the initial one allocated by KVM in svm->sev_es.vmsa. In
@@ -4958,7 +4967,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		return;
 	}
 
-	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order, NULL);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b33d2f475042..a15abd0f7fb7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -649,6 +649,15 @@ static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
  *    is responsible for put_page() after use.  If *page is left NULL the PFN
  *    is treated as non-refcounted, and its lifetime is owned by the
  *    implementation across bind()/unbind().
+ *  - *writable, when the caller passes it, is true on entry.  Clear it to
+ *    have KVM map the page read-only; a guest write then exits as a memory
+ *    fault.  It covers the whole block that *max_order allows, so that block
+ *    must be all writable or all read-only.  It applies to stage-2 mappings
+ *    only, not to KVM's own writes through the memslot's host address.  A
+ *    caller that hands the page to hardware that writes it passes @writable
+ *    and refuses a read-only page.  Only a caller that never writes the page
+ *    itself passes NULL.  populate() has no writable result, so KVM cannot
+ *    learn read-only state through it; it is used only to fill a page.
  *
  * Memory intended to back guest RAM MUST be reported as E820_TYPE_RAM by the
  * host so KVM maps it write-back (and applies the memory-encryption bit on
@@ -662,7 +671,8 @@ struct kvm_gmem_ops {
 		       struct kvm_memory_slot *slot);
 	int (*get_pfn)(struct file *file, struct kvm *kvm,
 		       struct kvm_memory_slot *slot, gfn_t gfn,
-		       kvm_pfn_t *pfn, struct page **page, int *max_order);
+		       kvm_pfn_t *pfn, struct page **page, int *max_order,
+		       bool *writable);
 	int (*populate)(struct file *file, struct kvm *kvm,
 			struct kvm_memory_slot *slot, gfn_t gfn,
 			kvm_pfn_t *pfn, struct page *src_page, int order);
@@ -2642,12 +2652,12 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order);
+		     int *max_order, bool *writable);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   kvm_pfn_t *pfn, struct page **page,
-				   int *max_order)
+				   int *max_order, bool *writable)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 057f90eb835a..c9595cc9d56e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -624,7 +624,7 @@ static void kvm_gmem_native_unbind(struct file *slot_file, struct kvm *kvm,
 static int  kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
 				    struct kvm_memory_slot *slot, gfn_t gfn,
 				    kvm_pfn_t *pfn, struct page **page,
-				    int *max_order);
+				    int *max_order, bool *writable);
 static void kvm_gmem_native_release(struct file *file);
 static int  kvm_gmem_native_mmap(struct file *file,
 				 struct vm_area_struct *vma);
@@ -936,7 +936,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 static int kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   kvm_pfn_t *pfn, struct page **page,
-				   int *max_order)
+				   int *max_order, bool *writable)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
@@ -964,7 +964,7 @@ static int kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order)
+		     int *max_order, bool *writable)
 {
 	const struct kvm_gmem_ops *ops;
 
@@ -977,7 +977,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return -EFAULT;
 
 	*page = NULL;
-	return ops->get_pfn(file, kvm, slot, gfn, pfn, page, max_order);
+	if (writable)
+		*writable = true;
+	return ops->get_pfn(file, kvm, slot, gfn, pfn, page, max_order,
+			    writable);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
@@ -1028,6 +1031,7 @@ static int kvm_gmem_populate_one(const struct kvm_gmem_ops *ops,
 				      void *opaque)
 {
 	struct page *ignored_page = NULL;
+	bool writable = true;
 	kvm_pfn_t pfn;
 	int ret;
 
@@ -1041,10 +1045,17 @@ static int kvm_gmem_populate_one(const struct kvm_gmem_ops *ops,
 				    src_page, 0);
 	else
 		ret = ops->get_pfn(file, kvm, slot, gfn, &pfn,
-				   &ignored_page, NULL);
+				   &ignored_page, NULL, &writable);
 	if (ret)
 		return ret;
 
+	/* post_populate() writes the page, so it cannot be read-only. */
+	if (!writable) {
+		if (ignored_page)
+			put_page(ignored_page);
+		return -EPERM;
+	}
+
 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
 
 	/*
-- 
2.47.3


