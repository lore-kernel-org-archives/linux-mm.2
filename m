Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE376C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5956B0099; Wed,  2 Sep 2026 02:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80736B009B; Wed,  2 Sep 2026 02:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FE46B009D; Wed,  2 Sep 2026 02:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7B766B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:15:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41BAF40710
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:47 +0000 (UTC)
X-FDA: 85167811134.18.72D829F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81089180008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LB8X6Imi;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788329745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0109/Wqd8Wh+hWY6seDc3gIIuk1v7uuHz7s+qR/LBc=;
	b=NHMjm06VVanwgQ/oOFy/Ht2X3t1FKfEmYGzDNdQMZSRYh+5QQm1hTixeAILupoUw25Ljk3
	Wg3loy21wtNZbs7MDFNxzbJMyXdXjVxz77RX6WtcbGmLEACk3cs+AocWGBpwqSKuwr4k/V
	2DHZMYqOOMKqv//QbyObOBWUg2emtfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788329745;
	b=ij3jHmnqR/AdrO39YcpIPQqxA1dA/HxXX1BfzpKl2hQxYB75OmNhtzb5PbJ4ch/OJqts7h
	gdLPYJwiAZvqmBBTce6OJd/H1dR9I+EYqxAf+LKvwqGpwOSQXwmnK3ZB2Xx4FW98CvQEfB
	PgWTjl40QQMM7BYu4FWcOrtIFgdxEbo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LB8X6Imi;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D073743B54;
	Wed,  2 Sep 2026 06:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986D31F00A3F;
	Wed,  2 Sep 2026 06:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788329744;
	bh=C0109/Wqd8Wh+hWY6seDc3gIIuk1v7uuHz7s+qR/LBc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LB8X6ImiwS+pRQhGYycXxWsTA/zbb8cKaDcKn7YY1YKr2eugSoSh8+GdnbU8Hm97m
	 FiQzurLzDonqCYHy6zm2G6/LjiwrvFvk7hfm5tTxrdrmbmYGOGDTSdgoNb0r8l8ycw
	 7ULkXAgHk0+8nXyq2/BFo5fzyfI9gyQgfcBNj88H8uPF4CCODMBCEzlyvKyPE/mmKj
	 oo8CZGVdYQMpVr1NgWCBveFt9ua7AkWHky6f0DmhzE8vepYpQl4m151HINIhTHBris
	 SXMfxdDFveWSrSeRL/G+vWD2zz1/0Is5/lWKXpqNmO2r7UQBhyfpaO2tDPrxpwe7F/
	 xTZgbOC/BjT4Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 02 Sep 2026 09:15:16 +0300
Subject: [PATCH 4/4] KVM: s390: Replace get_zeroed_page() with kzalloc()
 for sie_page2 and CMMA
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-s390-kvm-v1-4-3bc0986550b1@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
In-Reply-To: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81089180008
X-Stat-Signature: t1saer9io6mpz5dprmmytr4b4aebtyni
X-HE-Tag: 1788329745-708923
X-HE-Meta: U2FsdGVkX18LzcFYOm+xAFfL+BByTcpaFG3kQqC/b21OczqDySLBJ1tmb7gNgny9o/aHyCFD0sCJQvnoqJbT8kKB2s+m/lXvYuZX9izcs5911y0q0JGsbZtECZK2LLfArhdF9d/UHPGNKCmF8tRgDQjAzkHWQk5PPNFNx8DLJ5d9fGtn4f+UPemUXnj2yO6/sIsbifVpkOIQfED+/flmnerjuIt4ivlcjC09d+143g4vVFNr/w85hqbRGaMtW4bVMO2bZS8LOTSmxIPZmdZX9bvvheWhI79BSmX47+TupQ5KmgbuykySuV0CBsdOE6JAZ5DGDBeM+OOfZ6J03sOZt/FKqyB/uBDsT5IXyUKuB8gaxaaMdawUdLJ5nDdnVnxopWMwLSfvCRRI7v4thWeF1y0bKcsYKHT967POabvuxXZ4nOGwO5tg9Uv0lj4GhTPhYfY0fnR9GmSI4IcqBe3p04ScHIC+qCs2mDKTmYfwoYm1kWuwv53Id4ojRPaltX9QSv2H/wARE1XpEpuJEvmiSKge9dPEW+T4a4Vg5hD1gdCAmm29DTa6402sJkHB4wpGfaOw2CvBoudFIrhrpG9RohAGFCgXfoE7BFYzAnHwD549Y/9SdSHDdxg/QRf5S2ek3eglnQnaZdblODqu2v4STAEtgGjwByLzpVE3jiOwfQpTIzis3B4S8J8lF5Mx4KxlLn8rQUslj3lhOQ3bkCgElIcgz6HV7iGpGMrxjKmqYcQE1A9WkLhg6vOClA+FInbwI2OUf3/jmYlotoP6z3b7xIvN4y/wPYDjhLdjLGipfp1531yEzV+NfyZF1dgWiUIKCf+ijMEX2xvjQvzGhktcISNNFqygCtMj0LmkJL3FLo1Ora7gnzJdXI3C2/5VHZylHuwITH2gUY8iltTpYCwLR4TAFAPhIszDXUDolUQb1B7A/OUCa6T7Q/8tcfGaoN+iMN49x2F32Jb41XPeUxM
 b02GWwty
 1DJ5AzmKGXDMC+lTI0ki4KaOzRBXijwt1yysTeEw+CLVvodz/JKM1Xfy5iM/MRWARc9g9HGNYOoIK1Y5MYRCug7gtN5Oy8zb7GHGpo9CYY/q05C0E5CUXQHWh2PLEY+boSKHqslKinP3Y6GLXwHRHkVDJeJ874GGtXzyrDDkV55pl/6w2zWGvX41lnGLA5fmOgMxSa5CaE8vKTG25uvrU0xV2XX2lEtAebAgxyIsh9lJmFHWgHPV+RKB7//xb01vfGya667wDM4AYbZWAb6kdkxJkbOjvk0lXVSJMrHB6Zh0hFRdpTYFk/09AcXvKEyfDc5Bn
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

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/kvm/s390/s390.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/s390/s390.c b/arch/s390/kvm/s390/s390.c
index b0839e887221e..8ec505060f8c0 100644
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
+		kfree(phys_to_virt(vcpu->arch.sie_block->cbrlo));
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


