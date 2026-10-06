Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE86CA6004
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748A86B0093; Tue,  6 Oct 2026 14:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B416B0096; Tue,  6 Oct 2026 14:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C256B0093; Tue,  6 Oct 2026 14:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36F1B6B0093
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:32:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0AF8A0309
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:42 +0000 (UTC)
X-FDA: 85293047364.18.7E93DEC
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id D173A1C0005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b+gs0sfB;
	spf=pass (imf20.hostedemail.com: domain of griffoul@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791311560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLs4PxUJv4fIUSInM9yik/Vvs+kVI+eyOFS7fhQWhNw=;
	b=d11gEbBbx9byovUZ5OPFIwNHXXNhwXhLEeQspU89idoMzzxM+JXp33+TxJSyhYKEIuu+mC
	N6Dmqu/MpT0CHivI5cmUwsHaV3j7gFD4NzyLHzxDS4bOQyAT3svWMbHKV79xU5Auwegxan
	m2CukGnT36RLQJTBMPfAPKWgnv+5WVA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b+gs0sfB;
	spf=pass (imf20.hostedemail.com: domain of griffoul@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791311560;
	b=v4GALv6uuC/jA3lOqP4pp//UgQozr1dhr7WOAsm/qFwdrrBtpeBtCUQRXJj49WqfHN31u1
	zRmTKUbDEgphuiG5LDXSWYNjO4PYBwipEVzuc7pFHc43jCuMCDfNszhJeMT8zkzpQi6I66
	c1Mb4AzOV8Bff4oaIQh/BhbvIFCtYSQ=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso1987409a12.0
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311559; x=1791916359; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tLs4PxUJv4fIUSInM9yik/Vvs+kVI+eyOFS7fhQWhNw=;
        b=b+gs0sfBNLyP7/i9t1tXLhOuXbu3bNPaohyA/BokgojLWx+7AHBNSYzf4Xj8xqn+Lt
         Y5jxYk+SH39Xo9o9/SSIglJH4JI/HXINgXtR//zwSlYfe1l3b8qiPm2JN7bN6vFKxGeX
         B0JpLwFy+zJmhVZlQNYvvG6nj5m+ViC6bRjGOnLt08XWV3G73nCc+zY3oVKoRchcsVnb
         e4jXs3CjcdhC2ALV3l5QnwG8hMO4KONdd7wpOP0FFKIbtywT5REPdq4CgEMvWszDb6hC
         MqO3K52HQUM40xBSyApJZ1YRVwkbLmPJlE1LAR0qDQ7XduXvEVIazCgf05ych2mupYpy
         R9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311559; x=1791916359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tLs4PxUJv4fIUSInM9yik/Vvs+kVI+eyOFS7fhQWhNw=;
        b=YJHUy9iklzTjP+u1TK/vS16LzkNJhIpZVLy+nbW5NKBmlLtFQvhzBj5xWXuqFeZNvP
         duvA+kFx7aJzl7D1MC4Dxd+4xQo+aAXU+osevc70oAesFgAfZzH4p7xGe946veWqJVYs
         YCqjb76Hlb2QDQqsy0qjYJJi8jEAj/xpX9pEbJSsUZDN7DbWKxZs3v1bjTGUdrh8jJZG
         iEewjQ8KtPJQwEWEOog2hL54vAZ/rpbrOKkoQu3wFFNQAxFyjHJVdRKQuTEOU+OtocKb
         2l8VPG4PlSctrr+YWPZFQCC4F+AgN467gDf0aI7Lgnv8pX0puRLMLuZVuYIyAgF/ug4g
         37TA==
X-Forwarded-Encrypted: i=1; AKwUvBzNw65wsSvcPwzktwmr5xKvFrqfS/w5JxV+4BGIBDaHorfNW8uPweS+W9jOat3v8tzjJVlFxKug/w==@kvack.org
X-Gm-Message-State: AFuF++lxNxCX9dICwwAQxHBzk/atoF70gx7VQCOl5S86TWmSTYTMZgUU
	kAsY7wwf1nxEt67dGCWVGgxt3kQDXr4H/z2iH0ix99egUTlkNayE5fGR
X-Gm-Gg: AYBFou0FF9OENqYZm2MZWbEyDLUeq6/eQ9OsNaXGEIna+yi/WgAH0A2KKOQc1zK8ZwA
	EJ0zAQyms8L2MBv+I1r81JkHR7fzD3hINyIuml0m7DgHxNpDnxBuyc3oagyvVwZzpH7qNRWg/5y
	+a7OIy2h8sNr+9abkgx2b7LIupBE0+q5LwGxzlUsFFKkfaoVdb3WZUMmIkHReoYYWuPse9aVSSo
	Ef6smBMG5g52rki263V3aeLZMwAjS/+4p5ynxV+NbSesXgsBcfWQgAWtbZ/QrUIfky03mPGy5Jx
	A0qn0A2AtW3AZjncKw/ixKMde+DJZeHatW5OCxeKbLtzY1zmzR/EOht64YqObdgWrqGAMttUhJz
	iVwqs6qiingCn1FY+neb6LvQA/WPvhxp+JbI9Pd/uvCOL1ZioTVevgxos9sVPdkvAjA0dS65zG/
	w1U7OlWFZQbC460KLQAV5inJxy5QL8EiI6iz5NV8Sq6p4uX/lwEDs59vowyphnPC0g2rMvUI9HQ
	RF3GLsDjTF4zvqiLTDQfSEUOS/UzuEWLnkwT81k5szgWvM+OYn7C1+wbsZTVDZ++OvV3LyUqL1h
	qX2NEONV7tzfudnbydW1romB9FR2Qv7h5Lk=
X-Received: by 2002:a17:906:c113:b0:c2d:ba08:9092 with SMTP id a640c23a62f3a-c3169fae2b3mr238842266b.16.1791311559156;
        Tue, 06 Oct 2026 11:32:39 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:38 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
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
	Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
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
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/9] KVM: guest_memfd: Add a writable result to get_pfn()
Date: Tue,  6 Oct 2026 18:32:27 +0000
Message-ID: <20261006183235.16576-2-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D173A1C0005
X-Rspam-User: 
X-Stat-Signature: z9u1h5wkjtxft1ncpyaofgramfftaqnp
X-HE-Tag: 1791311560-640340
X-HE-Meta: U2FsdGVkX18wKZC9DWCI6CvbIJ+Kn+vvm0833kC8fzNkLrFBoOs2ZZK3MDI3phV0dAGTWRkumagSgT5XNU51Bt6zoyT+ZcEk8BrJ+tr9GSEMmAVzrxmfidE5hgL1NUqHKpAWRjgkOSicyRLY3kZnNGPxeStyIEV8LSDe0NsV0226ze6LSn7s3crTN5u9F4waf25EydwLXetRy8Mju+apamlsxSuKHh2xv4//B/b6NU8sE6U5qiqDkFCcW9IToUouDJBm6LzhPyccN+AxSjwJhhQZCL75HM9MAIJU03UAjaaVO2PABXHbOBDFoiOW3IYZ7SAhPeB8vGDe6m6FAZd+JpPZwLGGqG7QdFdq+HmTTnifGMdojLm/VExojEBpBb8K20wT1ze6Cv/HJgAcOHq6riN7HRm1kreZ317LlbInS6cJGUwJrDnnB4Dild5cQeobKB1TVHpkeb5KTvZ34GS060DHP72pbxopIXHvUVS9UKLZtKR36NxniC7dOkWkYbN+pzYLRDlt9ESj2tyaW/kLmk204eSFJnz0Jr5BpRZptekkUxDAzsZqXUZOQWy4skkFqncZCeZ/gAg6Wkq6xCXH/3NMfNVoyFxrOCwOv61JYiNiIgYfkFaRNzbKoIvOnn+Fa9gTOhgZ15QDfyvP7R4XI7sYnNm3gxx16DcaLsjTf/TecZdEndg7VgVHsOLB7cySZIxDuTwXoOD/4/2QoyjDAV0tScqn4KmcvjDdXRdLF/uVoHTOB/8kpHci6Zowr77iQz3eWB4bLCTkeoKgNPLibTJCUFVyC324hoHdBmANi+5RgNn4XLV8QJ18lFIAQjwwHnF/y1TbZ7khQxj83Qry2g2zvQFNQLo8V82zJ46SIpkzzuGA/kOp9X7f3wi7vH1LWpKt4UI0qQM8Pom/NplpEBwLwKzb57jeY1ImCVCT1RJEO2Oz2u8PtzUHdaJ7GGQBTkg5DNaS9Xe4iizPsoG
 3Kjf9NrM
 xgNAJTgQ1pu3VAIUAq/ozClK/Le/UILheIVHBR5EkKYANALZP9u65myTuqLJo8Q0YRatjw0JFINxZX0iB9tjAJ85rdkwDsivxbLFDDFd0TXi5NNpekkOZKtknHe/JvFq240mSeJAFYn+E7QY0U7T75AllpwW1cVV/4JXj3+X2Nzzh3LKaiV34BNHki3VHNgR1kt8Jep5ivt/CDqbW+5agi08Tn7OGIgmG1SwQQTAUB4XmKg/odJtw54T3fH1cROPNCM+uc4p9w6U/rhuGhZ62sGGW74N05HiZMDbS1sBgxWxSUlT1e74io3jKWjMHVt8YCcdxcVz5jzg6DwRtBRTRQnPJjM6bEZf5HEpWDophQEtgLe4yQ79XpM1vRKYSlRRGhNLQf7Ce9FUUDEBa+Y6M8Dmb6gPnW4JTROkqFtRbYY/cHZ2Q8P9x2A74WchImxowI21dIkb4NYbU6pEPjTLhIFG3HcZoBbVxOYHubXNrwtRK33ZR45o4entz0n683jwluLN3B6kTJl1lc2cTA7FLW3QbVvQ39P6oYdC76tKAPKGaeuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

A guest_memfd backing cannot map a page read-only for the guest:
get_pfn() returns only a frame, and KVM_MEM_READONLY is refused on
guest_memfd slots. A hypervisor therefore cannot give a guest a page it
may read but not write.

Let get_pfn() clear a writable result. The x86 and arm64 fault paths
then map the page without write permission, and a guest write exits
with KVM_EXIT_MEMORY_FAULT. The result covers the whole block that
max_order allows.

Callers that hand the page to something that writes it must refuse a
read-only page: the arm64 VNCR page and the SEV-SNP VMSA. populate() has
no writable result, so a backing cannot report read-only state through
it. The result does not cover KVM's own writes through the slot's host
address.

David's gmem_provider sample gains a read-only ioctl, and a selftest
checks that a guest write to such a page exits and lands once the page
is writable again.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/arm64/kvm/mmu.c                          |  13 +-
 arch/arm64/kvm/nested.c                       |  16 +-
 arch/x86/kvm/mmu/mmu.c                        |  18 ++-
 arch/x86/kvm/svm/sev.c                        |  13 +-
 include/linux/kvm_host.h                      |  16 +-
 samples/kvm/gmem_provider.c                   |  67 +++++++-
 samples/kvm/gmem_provider.h                   |  17 ++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/x86/gmem_provider_readonly_test.c     | 150 ++++++++++++++++++
 virt/kvm/guest_memfd.c                        |  21 ++-
 10 files changed, 309 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c

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
index 125779c82bc4..f4f944c7da10 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4026,6 +4026,7 @@ static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_memory_slot *slot;
 	struct page *page;
+	bool writable;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
 
@@ -4063,9 +4064,17 @@ static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
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
@@ -4996,7 +5005,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		return;
 	}
 
-	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order, NULL);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 04fa0cb126f6..7281d0e94121 100644
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
@@ -2651,12 +2661,12 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
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
diff --git a/samples/kvm/gmem_provider.c b/samples/kvm/gmem_provider.c
index 9728f5a8029b..99b288302d98 100644
--- a/samples/kvm/gmem_provider.c
+++ b/samples/kvm/gmem_provider.c
@@ -95,6 +95,7 @@ struct gmem_info {
 	gfn_t base_gfn;				/* recorded at bind, for revoke */
 	pgoff_t pgoff;				/* provider offset (pages) of the slot */
 	unsigned long *absent;			/* bitmap of currently-revoked pages */
+	unsigned long *readonly;		/* bitmap of pages the guest may not write */
 	struct list_head dmabufs;		/* struct gmem_dmabuf entries */
 	struct mutex dmabufs_lock;
 };
@@ -142,6 +143,22 @@ static int gmem_max_order(struct gmem_info *info, gfn_t gfn, unsigned long index
 		remaining = min(remaining, absent_next - index);
 	}
 
+	/*
+	 * Likewise a hugepage must be uniformly writable or uniformly
+	 * read-only: clamp at the next page whose read-only bit differs.
+	 */
+	if (info->readonly) {
+		unsigned long next;
+
+		if (test_bit(index, info->readonly))
+			next = find_next_zero_bit(info->readonly, info->npages,
+						  index + 1);
+		else
+			next = find_next_bit(info->readonly, info->npages,
+					     index + 1);
+		remaining = min(remaining, next - index);
+	}
+
 	if (IS_ALIGNED(pfn, 1UL << pud_order) &&
 	    IS_ALIGNED(gfn, 1UL << pud_order) &&
 	    remaining >= (1UL << pud_order))
@@ -157,7 +174,8 @@ static int gmem_max_order(struct gmem_info *info, gfn_t gfn, unsigned long index
 
 static int gmem_get_pfn(struct file *file, struct kvm *kvm,
 			struct kvm_memory_slot *slot, gfn_t gfn,
-			kvm_pfn_t *pfn, struct page **page, int *max_order)
+			kvm_pfn_t *pfn, struct page **page, int *max_order,
+			bool *writable)
 {
 	struct gmem_info *info = to_gmem_info(file);
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
@@ -172,6 +190,8 @@ static int gmem_get_pfn(struct file *file, struct kvm *kvm,
 	*pfn = info->base_pfn + index;
 	if (max_order)
 		*max_order = gmem_max_order(info, gfn, index);
+	if (writable)
+		*writable = !(info->readonly && test_bit(index, info->readonly));
 	return 0;
 }
 
@@ -371,6 +391,7 @@ static void gmem_release(struct file *file)
 	if (info->cma_pages)
 		free_contig_range(info->base_pfn, info->npages);
 	kvfree(info->absent);
+	kvfree(info->readonly);
 	kfree(info);
 	module_put(THIS_MODULE);
 }
@@ -581,6 +602,46 @@ static long gmem_fd_ioctl(struct file *file, unsigned int cmd, unsigned long arg
 	if (cmd == GMEM_PROVIDER_GET_DMABUF)
 		return gmem_provider_get_dmabuf(file);
 
+	if (cmd == GMEM_PROVIDER_SET_READONLY) {
+		struct gmem_provider_readonly r;
+		unsigned long clamped_start;
+
+		if (copy_from_user(&r, (void __user *)arg, sizeof(r)))
+			return -EFAULT;
+		if (!r.len || !PAGE_ALIGNED(r.offset) || !PAGE_ALIGNED(r.len) ||
+		    r.pad)
+			return -EINVAL;
+		start_index = r.offset >> PAGE_SHIFT;
+		end_index = start_index + (r.len >> PAGE_SHIFT);
+		if (end_index > info->npages || end_index < start_index)
+			return -EINVAL;
+
+		/*
+		 * Flip the bits, then drop the guest's existing mappings of the
+		 * range so the next access re-faults through get_pfn() and
+		 * picks up the new permission.  Making a range read-only must
+		 * tear down writable mappings; making it writable again is
+		 * also invalidated so a stale read-only mapping does not keep
+		 * exiting.
+		 */
+		mutex_lock(&info->lock);
+		if (r.readonly)
+			bitmap_set(info->readonly, start_index,
+				   end_index - start_index);
+		else
+			bitmap_clear(info->readonly, start_index,
+				     end_index - start_index);
+		clamped_start = max_t(unsigned long, start_index, info->pgoff);
+		if (info->kvm && end_index > clamped_start)
+			kvm_gmem_invalidate_range(info->kvm,
+						  info->base_gfn + clamped_start -
+							  info->pgoff,
+						  info->base_gfn + end_index -
+							  info->pgoff);
+		mutex_unlock(&info->lock);
+		return 0;
+	}
+
 	if (cmd != GMEM_PROVIDER_SET_PRESENT)
 		return -ENOTTY;
 	if (copy_from_user(&p, (void __user *)arg, sizeof(p)))
@@ -694,7 +755,8 @@ static long gmem_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 
 	info->absent = kvzalloc(BITS_TO_LONGS(info->npages) * sizeof(unsigned long),
 				GFP_KERNEL);
-	if (!info->absent) {
+	info->readonly = kvzalloc_objs(unsigned long, BITS_TO_LONGS(info->npages));
+	if (!info->absent || !info->readonly) {
 		ret = -ENOMEM;
 		goto err_free_pages;
 	}
@@ -733,6 +795,7 @@ static long gmem_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		free_contig_range(page_to_pfn(pages), npages);
 err_free_info:
 	kvfree(info->absent);
+	kvfree(info->readonly);
 	kfree(info);
 err_put_kvm:
 	kvm_put_kvm(kvm);
diff --git a/samples/kvm/gmem_provider.h b/samples/kvm/gmem_provider.h
index 45f1b8257f60..51b49ef9a3c5 100644
--- a/samples/kvm/gmem_provider.h
+++ b/samples/kvm/gmem_provider.h
@@ -41,6 +41,23 @@ struct gmem_provider_present {
 
 #define GMEM_PROVIDER_SET_PRESENT	_IOW(GMEM_PROVIDER_IOCTL_BASE, 2, struct gmem_provider_present)
 
+/*
+ * ioctl on a provider fd: make a byte range read-only for the guest, or
+ * writable again.  KVM maps a read-only page without write permission and a
+ * guest write to it exits to userspace with KVM_EXIT_MEMORY_FAULT.  Existing
+ * mappings of the range are dropped so the change takes effect on the next
+ * access.
+ */
+struct gmem_provider_readonly {
+	__u64 offset;	/* byte offset into the provider region, page aligned */
+	__u64 len;	/* byte length, page aligned */
+	__u32 readonly;	/* 1 = guest may not write, 0 = guest may write */
+	__u32 pad;
+};
+
+#define GMEM_PROVIDER_SET_READONLY \
+	_IOW(GMEM_PROVIDER_IOCTL_BASE, 4, struct gmem_provider_readonly)
+
 /*
  * ioctl on a provider fd (returned by SETUP): export the backing region as a
  * dynamic dma-buf and return an fd for it, suitable for
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 12004a487c32..4d7082448cea 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -81,6 +81,7 @@ TEST_GEN_PROGS_x86 += x86/fix_hypercall_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_hugepage_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_revoke_test
+TEST_GEN_PROGS_x86 += x86/gmem_provider_readonly_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_iommufd_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_vfio_test
 TEST_GEN_PROGS_x86 += x86/hwcr_msr_test
diff --git a/tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c b/tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c
new file mode 100644
index 000000000000..c3eedba7a16d
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * gmem_provider_readonly_test - exercise per-range read-only from a provider.
+ *
+ * Marks a provider-backed page read-only via an ioctl on the provider fd and
+ * checks that KVM honours the provider's answer: the guest can still read the
+ * page, a guest write exits to userspace with KVM_EXIT_MEMORY_FAULT rather than
+ * landing, and clearing the bit lets the write through. This is the mechanism
+ * a hypervisor uses to protect a page it shares with the guest, such as a
+ * sidecar's info page, without giving up the mapping.
+ *
+ * The test opens the provider with GMEM_PROVIDER_FLAG_MMAP_CAPABLE at SETUP time
+ * (gmem-only). Load the module with a backing region of at least DATA_SIZE.
+ */
+#include <fcntl.h>
+#include <errno.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+/* Mirrors samples/kvm/gmem_provider.h */
+struct gmem_provider_setup {
+	__s32 kvm_fd;
+	__u32 flags;
+	__u64 size;
+};
+
+struct gmem_provider_readonly {
+	__u64 offset;
+	__u64 len;
+	__u32 readonly;
+	__u32 pad;
+};
+
+#define GMEM_PROVIDER_SETUP		_IOW('G', 1, struct gmem_provider_setup)
+#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
+#define GMEM_PROVIDER_SET_READONLY	_IOW('G', 4, struct gmem_provider_readonly)
+
+#define DATA_SLOT	10
+#define DATA_GPA	(1ULL << 32)
+#define DATA_SIZE	0x200000ULL		/* 2 MiB region */
+#define MAGIC		0x1234abcdULL
+#define MAGIC2		0xfeedf00dULL
+
+/*
+ * Phase 1: read the page and report it.
+ * Phase 2: write to it.  With the page read-only this never returns to the
+ *          guest until userspace clears the bit; then it completes and the
+ *          guest reports what it wrote.
+ */
+static void guest_code(void)
+{
+	GUEST_SYNC(*(volatile uint64_t *)DATA_GPA);
+	*(volatile uint64_t *)DATA_GPA = MAGIC2;
+	GUEST_SYNC(*(volatile uint64_t *)DATA_GPA);
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = KVM_X86_SW_PROTECTED_VM,
+	};
+	struct gmem_provider_setup setup = { .flags = GMEM_PROVIDER_FLAG_MMAP_CAPABLE };
+	struct gmem_provider_readonly req;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	int gmem_ctl, gmem_fd, r;
+	void *hva;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
+
+	gmem_ctl = open("/dev/gmem_provider", O_RDWR);
+	__TEST_REQUIRE(gmem_ctl >= 0,
+		       "gmem_provider module not loaded (/dev/gmem_provider absent)");
+
+	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
+
+	setup.kvm_fd = vm->fd;
+	setup.size = DATA_SIZE;
+	gmem_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
+	TEST_ASSERT(gmem_fd >= 0, "GMEM_PROVIDER_SETUP failed, errno %d", errno);
+
+	hva = mmap(NULL, DATA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, gmem_fd, 0);
+	TEST_ASSERT(hva != MAP_FAILED, "mmap(provider) failed, errno %d", errno);
+
+	r = __vm_set_user_memory_region2(vm, DATA_SLOT, KVM_MEM_GUEST_MEMFD,
+					 DATA_GPA, DATA_SIZE, hva, gmem_fd, 0);
+	TEST_ASSERT(!r, "KVM_SET_USER_MEMORY_REGION2 failed: %d errno %d", r, errno);
+	virt_map(vm, DATA_GPA, DATA_GPA, 1);
+
+	/* Seed the page from the host before the guest ever touches it. */
+	*(volatile uint64_t *)hva = MAGIC;
+
+	/* 1) Make the page read-only for the guest. */
+	req = (struct gmem_provider_readonly){ .offset = 0, .len = 4096, .readonly = 1 };
+	r = ioctl(gmem_fd, GMEM_PROVIDER_SET_READONLY, &req);
+	TEST_ASSERT(!r, "set readonly ioctl failed, errno %d", errno);
+
+	/* 2) Guest read must still work and see the host's value. */
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC, "expected UCALL_SYNC");
+	TEST_ASSERT(uc.args[1] == MAGIC, "guest read 0x%lx, want MAGIC",
+		    (unsigned long)uc.args[1]);
+	pr_info("read-only: guest read 0x%llx\n", MAGIC);
+
+	/* 3) Guest write must exit to userspace, not land. */
+	r = _vcpu_run(vcpu);
+	TEST_ASSERT(r == -1 && errno == EFAULT &&
+		    vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT,
+		    "read-only write: expected KVM_EXIT_MEMORY_FAULT (r=%d errno=%d exit_reason=%u %s)",
+		    r, errno, vcpu->run->exit_reason,
+		    exit_reason_str(vcpu->run->exit_reason));
+	TEST_ASSERT(*(volatile uint64_t *)hva == MAGIC,
+		    "guest write landed on a read-only page: host sees 0x%lx",
+		    (unsigned long)*(volatile uint64_t *)hva);
+	pr_info("read-only: guest write exited with KVM_EXIT_MEMORY_FAULT, page unchanged\n");
+
+	/* 4) Make it writable again; the retried write must complete. */
+	req.readonly = 0;
+	r = ioctl(gmem_fd, GMEM_PROVIDER_SET_READONLY, &req);
+	TEST_ASSERT(!r, "clear readonly ioctl failed, errno %d", errno);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC, "expected UCALL_SYNC after clear");
+	TEST_ASSERT(uc.args[1] == MAGIC2, "after clear guest read 0x%lx, want MAGIC2",
+		    (unsigned long)uc.args[1]);
+	TEST_ASSERT(*(volatile uint64_t *)hva == MAGIC2,
+		    "host sees 0x%lx after guest write, want MAGIC2",
+		    (unsigned long)*(volatile uint64_t *)hva);
+	pr_info("writable: guest write 0x%llx landed -- read-only path works\n", MAGIC2);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE, "expected UCALL_DONE");
+
+	kvm_vm_free(vm);
+	munmap(hva, DATA_SIZE);
+	close(gmem_fd);
+	close(gmem_ctl);
+	return 0;
+}
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d284bb70fe05..a509f1a96c0b 100644
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
@@ -988,7 +988,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 static int kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   kvm_pfn_t *pfn, struct page **page,
-				   int *max_order)
+				   int *max_order, bool *writable)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
@@ -1016,7 +1016,7 @@ static int kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order)
+		     int *max_order, bool *writable)
 {
 	const struct kvm_gmem_ops *ops;
 
@@ -1029,7 +1029,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return -EFAULT;
 
 	*page = NULL;
-	return ops->get_pfn(file, kvm, slot, gfn, pfn, page, max_order);
+	if (writable)
+		*writable = true;
+	return ops->get_pfn(file, kvm, slot, gfn, pfn, page, max_order,
+			    writable);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
@@ -1080,6 +1083,7 @@ static int kvm_gmem_populate_one(const struct kvm_gmem_ops *ops,
 				      void *opaque)
 {
 	struct page *ignored_page = NULL;
+	bool writable = true;
 	kvm_pfn_t pfn;
 	int ret;
 
@@ -1093,10 +1097,17 @@ static int kvm_gmem_populate_one(const struct kvm_gmem_ops *ops,
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

