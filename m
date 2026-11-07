Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F017A6088F02
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KVddQq6Q
Received: by kanga.kvack.org (Postfix)
	id DCB5C6B05CE; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C4D6B05D2; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06F56B05D0; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA596B05CF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABFE5402AC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
X-FDA: 85406458536.06.1AD0BE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 80D89140006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KVddQq6Q;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011826;
	b=vN88iXOdzQ88BPwC83bg/5QJTb83UksbzwrARkoRPVuLUgTwKf8VoqdjSAmg8K1wGjRs6q
	XaGixcPMjRLWc0OafixEAnu29WqRwFMsMtFLjnFqyN+9Wj7ZSxSyynGgux0cGR5Ofo91NT
	6zjNbD6JyLaur7TG8y2iZ3Usc2rJhKw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KVddQq6Q;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011826;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCbFYcdaG9KGbwveY9Z1BWP2dFkEKeVLMBXiKf20lCk=;
	b=iPtu/GqJWMOM5XRpHxD515/1CRrNQEPKb35ByHQF9ZxHA4fwxiCXRNuEObj2q5gN5qT5dC
	tkyLmaef0PPwJxgwahPLip1bBQXsK8dORXIb5wMrcayIZNU6NNQEWjPMDWHnKdtgzocwnU
	ZxywBzv/yIEePbKC4O158pkFyU6yQeA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16C1960D69;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011825;
	b=Z7CPGMA1H95owRUD3vMaIvg0V9dOVBQEcmGb4Fh43Q3mIeKw7A0LtD45vNQBhb52F047
	 uOGkaFuZ8quEuGXvM9SgtZF5881XYMmGto56oDXh/AnZmVJwJrh8aXEudHaVzHfSFDNqM
	 /LSdcxByfxQSQzr2JKSOUUn6Kr6qHOzf0Zg3qVEIzike5Qf+Ot8k/OSdRTjksy5R64G0X
	 BjukJkK5eTS21qTp1vvB8rLZ1fyenaH3i0KW+Y2hUgPNMFZhINg3CKBMzu1+ZTU3q9hBS
	 l4NDpXQPsEMAw28gHR41OoqTKwdPwpSmU6DTlQNIYfmckCd5pVOIJRcPSV05i2Tyubw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011825;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=TCbFYcdaG9KGbwveY9Z1BWP2dFkEKeVLMBXiKf20lCk=;
	b=sQw1kzgpM0fzdkGT60E8MCTBp+3tKdNT9b/h13hLVNvR7s+qydD2RkZU6OcIVJIYNXAl
	 gMrbO2rINnXfr0ZCSUtF7Z/xKMeuxJ7WIdhDvav00akkfaBppvTyNDKUAZn5r8vglVggu
	 OAOCzDop2kNM9tuYZmykvH6WEx8c3uJ/JJ3zgIvB13zbAWXpm4YUoN1KlXrfqP5ho7VZb
	 peYWuhnJCzZ1HVfrZjWkaT3+SbUpXbCe01aAubaazwbNxANycThUpxD+gITI88guHedyn
	 3IABW/ioMqMiN6kHlc7WXLaDHnKcnvBaCMYYwK+Jf5Pk9/UTosonxDJvskUoyB7XMrw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 117AA1F0092B;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011825;
	bh=TCbFYcdaG9KGbwveY9Z1BWP2dFkEKeVLMBXiKf20lCk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KVddQq6QmhtaJFMN4cl1LYYmqp69Skzhykc6fd+g7Kdr3J62jBjjX0uGuvOWSD/F3
	 NtIQLiWEkyngFUaOLZLdK28rt969fbTRjnoVRqd+vuQGRF5ILzopbTvm725TR0VbV7
	 C5iN2r2z89AyisOtjAbbaCpayI4c4hyQo2bDkEC5qT/IhuOMt7bfK0Q/wLV7byuLDg
	 YlLVoByeVcYkckCcOMYmza3EsvRAMW+ODmXWTujrCEONhwNBYFyR0rVWzq9Ihqk1BD
	 rK1LR+EcyzeQSKz8UPSckVOx9G1rnb7ucRR+hIE4vMkDnhLxbisCNFHDbveQNr/ap9
	 4hI9lXsvwuUAQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D5FEF47983;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:02 -0800
Subject: [PATCH RFC v3 28/88] KVM: guest_memfd: Support reporting PFN
 attributes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-gmem-alternative-providers-v3-28-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=11580;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wkmBy9lgUQWs8gneS+Jj/435+mtTQvBdcBYi1FNd9Co=;
 b=znxXsRqyxlLEyPJffrgjkhe6g3qMhwtVuYQ/aUhloAjmsUQJOdOK38+pbafKwTS56VSEV39b6
 oh0h1H3CWpzAaTNyQBLSOtJHT48k8mGmc6Zy8l9JrLi33jgjzGKz+5Y
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ji1dmsrbodpzhm7j98sa84gyqmxe1i6m
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80D89140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011826-882060
X-HE-Meta: U2FsdGVkX1/7uAQCGWFm1hxglKZ16bHX/cmJUoOymjfg4s4ZAoY5lfoEQqnsWDAcPjVLeHZ9lTquD4AGAVk/vRseS2Vv6L+KzBugM6/zgtUoZ/V9MSx8gMvRGGfFLIEHoDi95XE5aW23kQefgHe1Yl1V4qix03I413HuC4B59shw0n3EAU6lCCvi/hcgD4g3XTYshIlQSrL2b8cSkd/8xol6U9Kt4d+RDXQtRUJDQeebyxivi4WIZU/DuQJg/lposKL3ohDjzzg/Z3ov3ioMNgzx+x9ECPseJextYLdEGgwGXTKWjxmY+WSho8rq+vnbsEqLPVi/bKE4g/8wdgINs6oYf+3c9FDIg7FuzwXp5oNNX80sOryL2+79rDJciRGYgtQvUPeuVOn90Xe6HpNprG5t0wEDrT1SPlAdVb0hIQaZ99Lj6zKzv4SjchF0+wsiH4kya+ZsINegpp5Yc/9xtnVJGL1H4FT4KRXN+m2avqZeqKnqE2ZXYr/V1HLBIzOnwZDzV2UBSgy+JECJAIiVi/wSHGIB0b78T60E26jbAYhctLNT6PbBb0Id2e71KiER3VuDG9oesQuf3WFCWhw2fcHD+v/XbliVN4+PL9m3qo5RIpdDmkkxeMuscmGHI9Ru6xugZwMGJo40ew5Lona5EDhpHPXDymlLf7a2C74JeAPFYqbUESd4IDDE7veVhhgP4Y+kO8AlBnHKpa7yp3uaF3qmjcW87DeRUb14iazxut5xHwepW3XGdBxBPeFPMZjArpLpBpOM5iGgh5mYsEpqj/nGBc6/s4oI0JzkIIwy6uB2eUSoRaEZbiuKeeQYRbUhQJcV0Ik0f4ja5HqEUOfQQRtNptbaF0AzVW7abnViXJl8zZDM7AyMfLcmSY3JpcetdEWEaaHZwey4+5HhCr5FxJttkqNTvzIjLAyVirEjzTslOQCD/+rChFxKAQE/fd7oPBHdZOfsp5fBRn6qCIE
 Xu8n0A9O
 QWAXkZeb2vXASGsaBA87hHPMF6J+LOFQ2FORWRXwPUwK/hLxXkxsk8FTeIDsdO5Sd18VTBcbvPSJ2Fmnv4T1gKac9UZiyuDhWxhnJ7zyfXIHVddCdtHF82EUJFE3ILKXk1glzV0l5rVXlNNVLwtwaHCU6qWBQ8UKIqeCKVvjSwumjH0oXNkAACBpeIvHWN4nSlUN9HXHb21qJlep3puFHPF0eldbwyk8HqjvQfO6MxL1TELDHmiC94yzzgM9eaxr6YrD4ZIqw+5nnF7AnAAP1dJoOWafeI2or/acFPfoYmt3HeSiHZxWwiAlO7RqoCEffoNIHH/A4XC5J57dh7ptvEpuCwI/WFBLRFOG3xXej65w6PPnR6DYaPtCfbSWa+pLEbHCYoTNEeopi/5Ak3XSMXlTEFoEkQu8bHOpQ+oq57CXQpAxrsntEhbbwY66Co3fpVqYu8bM2NNgiKwb3iPaCsM58tUp0/X5JMv/rUV39dyvrD5Hz/H6q4tLYKr6QEH4DoWIH540TX2sPy/SWgGOfb8gAkOItzE6dFyo2jL2hlsYk4NcIj0Fj6m/J+n6O11kRoVJgJL/X7ksaQWf4ou/3mKv1C9HgdwU9Wnxokwk3NpPicgPkGnJBR4FtnRpipwE3AeSeB66Z1rvFY3b4TnuB5aQI67Z4XX7UnEbyaeBZqUQ5lJ1qQqoVFrJ6ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

Support reporting physical frame attributes when retrieving PFNs from
guest_memfd backends.

Add a pfn_attrs output parameter to kvm_gmem_get_pfn and
__kvm_gmem_get_pfn. Define GUEST_MEMFD_PFN_ATTRS_READONLY as the initial
attribute bit so backends can report read-only restrictions on physical
memory ranges.

Handle GUEST_MEMFD_PFN_ATTRS_READONLY across stage 2 fault handlers in
x86 and arm64 to ensure that guest page table mappings prevent writes
when the backing physical memory is marked read-only. Exit to userspace
with a memory fault if the guest attempts to write to a read-only
frame.

Ensure that private memory invariants are preserved: reject read-only
frames for private memory faults with -EFAULT, and reject populating
read-only frames with -EPERM.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/arm64/kvm/mmu.c        | 13 +++++++++----
 arch/arm64/kvm/nested.c     | 14 ++++++++++++--
 arch/x86/kvm/mmu/mmu.c      | 10 ++++++++--
 arch/x86/kvm/svm/sev.c      | 15 +++++++++++++--
 include/linux/guest_memfd.h |  2 ++
 include/linux/kvm_host.h    |  7 +++++--
 virt/kvm/guest_memfd.c      | 32 ++++++++++++++++++++++++++++----
 7 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 705f6d84770e9..8f0217185973c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1738,6 +1738,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 {
 	bool write_fault, exec_fault;
 	bool perm_fault = kvm_s2_fault_is_perm(s2fd);
+	bool writable;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->mmu->pgt;
@@ -1746,6 +1747,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	void *memcache = NULL;
 	gfn_t canonical_gfn;
+	u64 pfn_attrs = 0;
 	int ret;
 
 	if (!perm_fault) {
@@ -1773,18 +1775,21 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, NULL);
-	if (ret) {
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, NULL,
+			       &pfn_attrs);
+	writable = !(s2fd->memslot->flags & KVM_MEM_READONLY) &&
+		   !(pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY);
+	if (ret || (write_fault && !writable)) {
 		/* If result is non-NULL this is a synthetic fault. */
 		if (!result)
 			kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(canonical_gfn),
 						      s2vi.vma_pagesize, write_fault, exec_fault,
 						      false);
 		kfree(mapping);
-		return ret;
+		return ret ?: -EFAULT;
 	}
 
-	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
+	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (s2fd->nested)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28b..4519e92d89d66 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1615,14 +1615,24 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 			return -EFAULT;
 		}
 	} else {
-		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL);
+		u64 pfn_attrs;
+
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL,
+				       &pfn_attrs);
 		if (ret) {
 			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
 					      write_fault, false, false);
 			return ret;
 		}
 
-		writable = !(memslot->flags & KVM_MEM_READONLY);
+		writable = !(memslot->flags & KVM_MEM_READONLY) &&
+			   !(pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY);
+		/* TODO: Explain why vt->wr.pw needs to be checked. */
+		if (write_fault && vt->wr.pw && !writable) {
+			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
+						      true, false, false);
+			return -EFAULT;
+		}
 	}
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5a2cc6a17a9b3..87deeeffd9919 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4674,6 +4674,7 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 				    struct kvm_page_fault *fault)
 {
+	u64 pfn_attrs;
 	int max_order, r;
 
 	if (!kvm_slot_has_gmem(fault->slot)) {
@@ -4682,13 +4683,18 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &max_order);
+			     &max_order, &pfn_attrs);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
 	}
 
-	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY) &&
+			      !(pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY);
+	if (fault->write && !fault->map_writable) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
 	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6427db390b1cd..5e37ea4bc7937 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4053,6 +4053,7 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	struct kvm *kvm = vcpu->kvm;
 	gfn_t gfn = gpa_to_gfn(gpa);
 	unsigned long mmu_seq;
+	u64 pfn_attrs;
 	kvm_pfn_t pfn;
 
 	lockdep_assert_held(&svm->sev_es.snp_vmsa_mutex);
@@ -4096,7 +4097,10 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	 * The new VMSA will be private memory guest memory, so retrieve the
 	 * PFN from the gmem backend.
 	 */
-	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL, &pfn_attrs))
+		return;
+
+	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY)
 		return;
 
 	read_lock(&kvm->mmu_lock);
@@ -5063,6 +5067,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	struct kvm *kvm = vcpu->kvm;
 	int order, rmp_level, ret;
 	unsigned long mmu_seq;
+	u64 pfn_attrs;
 	bool assigned;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
@@ -5092,13 +5097,19 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order, &pfn_attrs);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
 		return;
 	}
 
+	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, read-only backing page for GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
 	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
 	if (ret || !assigned) {
 		guard(read_lock)(&kvm->mmu_lock);
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index f3e6077c39ac3..df2db2a0bae6e 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -9,6 +9,8 @@ struct folio;
 struct inode;
 struct mempolicy;
 
+#define GUEST_MEMFD_PFN_ATTRS_READONLY	(1ULL << 0)
+
 /**
  * struct guest_memfd_provider_operations - Operations for external memory providers
  * @attach: Attach to a resource file, perform filesystem-specific validation,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d820afac49252..cf679efcf3260 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -35,6 +35,7 @@
 #include <linux/interval_tree.h>
 #include <linux/rbtree.h>
 #include <linux/xarray.h>
+#include <linux/guest_memfd.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -2627,11 +2628,13 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order,
+		     u64 *pfn_attrs);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-				   kvm_pfn_t *pfn, int *max_order)
+				   kvm_pfn_t *pfn, int *max_order,
+				   u64 *pfn_attrs)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 84877beed6701..f0bd90fd9c986 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1274,7 +1274,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
-					int *max_order)
+					int *max_order, u64 *pfn_attrs)
 {
 	struct file *slot_file = READ_ONCE(slot->gmem.file);
 	struct gmem_file *f = file->private_data;
@@ -1308,18 +1308,23 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	*pfn = folio_file_pfn(folio, index);
 	if (max_order)
 		*max_order = 0;
+	if (pfn_attrs)
+		*pfn_attrs = 0;
 
 	return folio;
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order,
+		     u64 *pfn_attrs)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
 	int r = 0, __order;
+	u64 __attrs;
 
 	max_order = max_order ?: &__order;
+	pfn_attrs = pfn_attrs ?: &__attrs;
 
 	CLASS(gmem_get_file, file)(slot);
 	if (!file)
@@ -1327,17 +1332,29 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order,
+				   pfn_attrs);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out;
 	}
 
+	/*
+	 * Private memory requires exclusive, writable guest ownership and
+	 * cannot be backed by a read-only frame.
+	 */
+	if (kvm_gmem_is_private_mem(file_inode(file), index) &&
+	    (*pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY)) {
+		r = -EFAULT;
+		goto out_put_folio;
+	}
+
 	if (kvm_arch_has_gmem_convert() &&
 	    kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
 					       (kvm_pfn_t)1 << *max_order);
 
+out_put_folio:
 	folio_unlock(folio);
 	folio_put(folio);
 
@@ -1355,12 +1372,13 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
+	u64 pfn_attrs;
 	kvm_pfn_t pfn;
 	int ret;
 
 	filemap_invalidate_lock(file->f_mapping);
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
+	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL, &pfn_attrs);
 	if (IS_ERR(folio)) {
 		ret = PTR_ERR(folio);
 		goto out_unlock;
@@ -1368,6 +1386,12 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
+	/* Populating pages initializes private memory, which cannot be read-only. */
+	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY) {
+		ret = -EPERM;
+		goto out_put_folio;
+	}
+
 	if (!kvm_is_private_gfn(kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;

-- 
2.56.0.455.g6c5a503b38-goog



