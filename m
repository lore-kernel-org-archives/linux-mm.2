Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24BBC79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 08:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9425E6B0095; Sun,  6 Sep 2026 04:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2B16B0096; Sun,  6 Sep 2026 04:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0D46B0098; Sun,  6 Sep 2026 04:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 598866B0095
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:27:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC73C804AB
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:39 +0000 (UTC)
X-FDA: 85182658638.24.58D8A86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C54E1A0006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEaSjZJz;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788683258;
	b=lxHhVUMMzGMGjdKiKHpkDWaq9rgWr0A5wzPYDHWSQVpYjBF5v6FPOmWrKDwcAXdYQwGZH2
	2TsT5Yxq7SALprRl5dYkpzrbjRBDjfYJX4FcpHR/2Vmz4RB+kltmc8sSLJWmrkirMAP/8i
	8AEVv9/ojuyh/4rLz/rYlvyYBgsIRw8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEaSjZJz;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788683258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9ZM75Oj1X5kSc3IVFNLWbiJNUqBfJ8HFbN3imH3XNM=;
	b=5aOjWSM0F4MDY3Ri2shcrpsnpb18MoMmJv8mqSQ1z/ravYj7e/U/mV7Cdy4oEBzWXBJwE4
	QAyyxDw7pduwZypIPcYdXGCqvK/ev9pMbWbsUJzldEela7eW5I43O5EWUxHF0FZcMgKI7K
	UhF6louIEa3c2Pf63RO+HXoVcaB7ajU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C238402CA;
	Sun,  6 Sep 2026 08:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5210C1F00A3A;
	Sun,  6 Sep 2026 08:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788683257;
	bh=s9ZM75Oj1X5kSc3IVFNLWbiJNUqBfJ8HFbN3imH3XNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LEaSjZJzcZh5DGcvXdyiiI5ZPI69KmLsiONdb27CcK2pOBlqgkoLV9ANAKT6N6QJt
	 QVJooOn5NfL8Z8krU/IidkYMfWo7mwRRGt6q1jyMMgc8fnFqs+8HJS4beV3f7vui0t
	 zDGgt1ejbZhXGLMlb0Xf0C6KPo2gj5gyKUid8F/0n33qu4cSi3mgKV2QPsM8C2k6ds
	 L7cqss+5Ej9CDdnO6SxSHcK04CLzQ/KrPrOgvhy9KZlrt4uiAbSiYACkYWXMp5RaSu
	 aly5fL+egIsPNx0EQ/fkGBZRXeUExX3kZyAOkBo7MmbvJIgHZWLCQmcz3dXghQD7VZ
	 +IB2+fC92Tr5Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 06 Sep 2026 11:27:12 +0300
Subject: [PATCH v2 4/4] KVM: s390: Replace get_zeroed_page() with kzalloc()
 for sie_page2 and CMMA
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-s390-kvm-v2-4-2cf6434e6646@kernel.org>
References: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
In-Reply-To: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
To: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, Sven Schnelle <svens@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C54E1A0006
X-Stat-Signature: 6ysrkgorfrbeizr3by4he6jwzc7zrair
X-HE-Tag: 1788683258-667765
X-HE-Meta: U2FsdGVkX1+QtYIiUFwBtSjFn7vTom5/PBz0z/kMX1r7vptTo0moyVo4Woep3LYkaOSeFzRfwnw+3PahF1rQ0m1Es4QlogF1PnIZwR+c4vsIvj/11IvucPiGnUD7kRVrmMeiGSfMtbjbam0opXNo9hMf76WYsOmXDVsatWydYccD203thOjjGKxEHS7qymbzsNJj0Q8EGFW6hBwwMF9B5zLYkKXKxl1MXciJT1Axi2WEu9lUB/6MNDSqb4hwf5N//kMgIlibTWtwRa/m1tuuZAmRHLaAbMEdr/tjRzaHYdmr3g5zMTLwtjwtU04NlHRfDeVdz+Twf9cmhCgSEN+9WX4nEiLuGJVOaOlRoB5iq8qy+nrp4O/L1MT5A2BDcTNQxhFwFLpO9JxuuvSgQaAYUsg85GxuiqqDis3yR6dgT84dMrnvYjaqbng5nvhZ/SKKeVMNWyAx2oLfB7ccvB02S55JUQFTMeDZ29kk54htD0/Hzcakuw2pyYO/l/pqAjiliIADA67LZ8QTpdivqJZUoj3YxgFtU6WMOTv9U18dwl6S8u1vNwiTN+2TkctcyBmwKlH4fQbEBZxSA8HPNuYVbU09UTYGP2LZb6kuG1to2jX/Bdlg51m2F3458Rsd/3waCPS7/kWO0h6UnQEgNjbeYyEV8btVcgLKaXHTknNxhTGcIcdzga7VSzPNWXVAW2fYupE93apEQJjwIY9Nm85EJoToWSOBrGmcK/O3x29e/KErLPmh9r/1lcnwrKvHps+upDETVx34Lb8fp/+1kPQ4zqOi9kceXG74djV1lFp1+M7Oy2lrruuXC+JAQnyCkXq6UF7dddK2piN5taf9Iq8//t0IQvpSKcKfT2fOmcZ0upe8ZKXTl7/KTruAf0p+Pt8pmDeOSGZ2+db8/IVJkAT3Pn52UKo3h/o3+f2SNhfktgwAHnJrS8HxA4rXPIFlZMb9Vq2hNnpm1pPeQic2npd
 oWbwySB1
 SmYPx743UCTOhyA/C3UvTGKeOMAg+m0PnjTPeuRn7mmD6or+mDxcE52kAJ+CuNY4YQeiYnqZQkzKgPd/lPf+T47hst4LG7tAbsSP+8iwudwigWML6GgDT8XKXChP97opjvdcD5Cn2CSu83M2D4YSXaeRFPieMQ3YItt/NcYhGlil8YUoTUWoKKiLgGY41PnkapzLuUZeSas8gIxV1kdJzACnbJDUmo7FBRADp4lCHkmXQE9LRtu9YV38fy+5rN3ozaz59goTE3CRV/ltI4cO6CXJan3419RbAhcl/vjdVdsbsaBg9uwZ7keip3qh9x63cVaRU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kvm_arch_init_vm() allocates struct sie_page2 that holds the facility
list and the crypto control block of a VM and kvm_s390_vcpu_setup_cmma()
allocates the CMMA collaborative memory management block referenced by
the SIE control block. Both are passed to the hardware as physical
addresses and must be page aligned.

kmalloc() guarantees that a power of two sized allocation is aligned to
its size, so a PAGE_SIZE allocation is page aligned as well.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

The sie_page allocated in kvm_arch_vcpu_create() is left alone because it
is mapped to userspace with virt_to_page() in kvm_arch_vcpu_fault() and
therefore really needs a struct page.

The SIE hardware stores the offset of the next CBR entry in the low bits
of cbrlo, so mask them out before converting cbrlo back to a virtual
address. free_page() did not care, kfree() needs the address kzalloc()
returned.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/kvm/s390/s390.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/s390/s390.c b/arch/s390/kvm/s390/s390.c
index b0839e887221e..1d9eea64f3dbd 100644
--- a/arch/s390/kvm/s390/s390.c
+++ b/arch/s390/kvm/s390/s390.c
@@ -3273,8 +3273,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		goto out_err;
 
 	BUILD_BUG_ON(sizeof(struct sie_page2) != 4096);
-	kvm->arch.sie_page2 =
-	     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
+	kvm->arch.sie_page2 = kzalloc_obj(*kvm->arch.sie_page2,
+					  GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!kvm->arch.sie_page2)
 		goto out_err;
 
@@ -3369,7 +3369,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	return 0;
 out_err:
-	free_page((unsigned long)kvm->arch.sie_page2);
+	kfree(kvm->arch.sie_page2);
 	debug_unregister(kvm->arch.dbf);
 	sca_dispose(kvm);
 	KVM_EVENT(3, "creation of vm failed: %d", rc);
@@ -3427,7 +3427,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		mmu_notifier_unregister(&kvm->arch.pv.mmu_notifier, kvm->mm);
 
 	debug_unregister(kvm->arch.dbf);
-	free_page((unsigned long)kvm->arch.sie_page2);
+	kfree(kvm->arch.sie_page2);
 	kvm_s390_destroy_adapters(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
@@ -3657,13 +3657,13 @@ static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.sie_block->cbrlo)
-		free_page((unsigned long)phys_to_virt(vcpu->arch.sie_block->cbrlo));
+		kfree(phys_to_virt(vcpu->arch.sie_block->cbrlo & PAGE_MASK));
 	vcpu->arch.sie_block->cbrlo = 0;
 }
 
 int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
 {
-	void *cbrlo_page = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	void *cbrlo_page = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 
 	if (!cbrlo_page)
 		return -ENOMEM;

-- 
2.53.0


