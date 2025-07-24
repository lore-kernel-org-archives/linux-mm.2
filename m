Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B3BC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108558E00C0; Thu, 24 Jul 2025 18:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E03B8E007C; Thu, 24 Jul 2025 18:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D908E00C0; Thu, 24 Jul 2025 18:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E52A18E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:32:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99C8C1A02F5
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:32:09 +0000 (UTC)
X-FDA: 83700607578.26.8162AED
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id D9B8640007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:32:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uklwMYys;
	spf=pass (imf27.hostedemail.com: domain of 3ZrSCaAYKCCUTFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3ZrSCaAYKCCUTFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753396327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bh/wprVBN852sjzrFESObpUeJsN9EztK14cwI3p/3Qo=;
	b=Rkdw7KAMSpzI9e1N2KKd5C1HSjSzlS7UgK1prIpy6J+snwnY1MUzL4X1KRoUetZyYBydoz
	YiGY5BVPPGz1zsrpQ+ltJEmsRjgHr66IiVlePDGl7DBpa3Lr4isdlX35WgsqFMQ1FHKNlG
	XFfe1jzhEDOMGUAh97MI3F4vDV8bEgA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753396327; a=rsa-sha256;
	cv=none;
	b=JCA0fXVqjavloaVlR1ojvcq1nW/riHAnIbb8LXgzNMAs7v5zBe+34aLHMbiW+AdB+6NtEC
	DRNTSBZjkZoEioqwxQgVkZnPqyA9+JG+/hJ2CLP2PoB2WYeq98mpdLQzxBj3cVIbKk4uou
	8XdzKJd3Y/u1rwB2NiYArcYrIHSSKjU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uklwMYys;
	spf=pass (imf27.hostedemail.com: domain of 3ZrSCaAYKCCUTFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3ZrSCaAYKCCUTFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b3f38d3cabeso1033995a12.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396326; x=1754001126; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bh/wprVBN852sjzrFESObpUeJsN9EztK14cwI3p/3Qo=;
        b=uklwMYysu41PKNGyykusxNjmt/fI6y5Hm7Ll+rgskChH1CGDvBp0LK2BLVP2M81NsW
         AF4XhhB7kJA5212Tz+wxktkmogSuJnGCMX9nNSQgrZSQWtEsaOB/QLrlYBU4puD5FbIg
         U1zbnLQFPs3biHtujYA3WMtilhAzR2V6TZmwDqyQPqP7aUduQRmxBj3q8TJJKsSwoEup
         m4EzcVmSHx7CPBFTS3rZ0UhlSzyP36ctK5xUWXWclGLkH7CTnNJ4yGewRfxE+zk7aO5V
         PgiTjgqHinh+722kmXC9GDT9D8a73v7qt6CoiDkzzbV4pfYpXwYBpDpwsjBJN7+xWps3
         9NSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396326; x=1754001126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bh/wprVBN852sjzrFESObpUeJsN9EztK14cwI3p/3Qo=;
        b=kLSZ8GAmUNoxfGR17rMBvuGvC05e88KsuDFqUB2wNnfLAG1tuYlUMODQ9qsrJASwz1
         Dhp9/e3eOk5pz83hbLKG48X+N5s+SmUQL2HM+gsI9Y4ryVdnPWoiwz3/WCabKuDdW/4G
         W1VKz7RS7nTnpZtO/Z6W/OVnBhxMw7AV+jcoilvQr3IRclfLAgyFErmbP52uw347L1iJ
         i4T5K7oUnk7qCN5hlartRBTIkjQRgblko8/mem46hbcyBndZx5vO3jbI6steHr6yJzsC
         BD92cZ3zVw2nwZKu1U5J1D1cfRN5J2ZrlK5Szbr5YqjsIZ08Ob37W/kCu9GAwuKaCWi0
         xbJA==
X-Forwarded-Encrypted: i=1; AJvYcCW58Vth1b8bwstloJ80xIKIR69CeLyJr4MiGBGewZheUzckkUsUNmpsbS4lp2uzHzmsMiWIzpc0AA==@kvack.org
X-Gm-Message-State: AOJu0YwTqo4PSUZ+rNounrAIMFzlm5w/bAqs+iucLDQHNlVEodhs+dKE
	mzLkht0fxQys1iv/lMJtcyMYjlh7Wbf+4ut+8OzeRgj++FjL1qHDZceKmaxpwEQze/4KoVSKHta
	56QecKA==
X-Google-Smtp-Source: AGHT+IEXIwkLfUiQJXwnuBxbU39hQL5k325KMiuT8Z+LZslth4tnISdS1AUdYJ8MJLju2XbZxDVZpjWpVZw=
X-Received: from pgbfq26.prod.google.com ([2002:a05:6a02:299a:b0:b39:311c:59fd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a3:b0:235:5f88:32fc
 with SMTP id adf61e73a8af0-23d4902451emr14783922637.18.1753396326379; Thu, 24
 Jul 2025 15:32:06 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:32:05 -0700
In-Reply-To: <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com>
Message-ID: <aIK0ZcTJC96XNPvj@google.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: D9B8640007
X-Stat-Signature: jc9qp559cfme6khn5h6myuppd9mch8i7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753396327-375862
X-HE-Meta: U2FsdGVkX19+QkjF3/kBQM8sGFWRUqGdB1zxeottPT94/ClnUhITi0LxHEAgxuDTYQx9gAbLegEo66IsEiRXpV1e08HvhcADMEyDZQGZG/TNaPjCwD/3WaIGDb/21ee5DySNC1rm+XWmdywNiFaYewbQaCYWrnHaFHzGI14eWgkV4P7R1UmJELJ3bZRpWy4kIHPj7vA7POM+dnFIXM+X8e6chiIy8Ejywxf0QSHaVikRUsBtIwPXpc2V/XywHRTE5lGU5IRc9ap21MAf9GgQnSnxDadom0nzLimKN1ghQ0YohlLkhpAwi9up43I4edvvAFIvYwC7o+m+C4dBXpAH4AvkReY4Ia4PJWcoc4Y2HTZ1aREnkHAmVa8QuaBxuixUQH2YFWMDEsTbpaYaymANKvlTt0f6fh0NsXGVnlFZgKywJahXar+nBb0US+lxurao33DUztTPN7crqCC6EkfZifPIjGZLvYF9lpb2i6kuKYiz4ALFiNfmGQOhtIcHCPhLLhs/ropt2bKyNwg8Rodn6Shw4Jc5qfvi7gy5hdrR3i2Q9jH7KU+ZHKNyqKoLvR8hJ8yBZGOgagAV0jeJbI7aRf5O/UBwxhZjQDc6d0t1L3cLCA/viNa7NGgMhuSf7+Ys03V3ofhBj5Ltdy002vJJ1Xys/Q3SYiSqnbLDtslGe3DvNLcgcC2M13yAZzX71xhLMKC96ahlfuDsi1HUBKORJxnK9BRGm7xlXqDn3kL8D/OH/kaCZsBv2zpMVwucWshJfJ+ndrIrRZHIGMfAT5K9GX4wHxqBqmiSCVPOUkTyvNBAeZydysTNhlZsyZsZvZS6oTxuCPxv3kM4jsLFGoMUAlFsSfQbsiBXr1QxcqPIgzHbpBfHNHFs7erl/NTKULAOAT5N2cToHalfN1Riw4+WgezbKx4yo/hn/3Bq4P6YIv4UNsEj7aR9v1LYNqth2SL6SzJYzbXhpvXnPSoygcz
 yX07vgGP
 P2eDefzK3/ekLFZ7wAoDquVgtKyH9dvW3NwCNe/cC7iqNdSgDgVspKp9Y4p0XY+BRvqw/g/5JZKEwSEIY7r9f1eQOqhAaDiSzukcRLVvghEuBynA8R0C0Fu2j7hTIhMeLG7xvZXE0xUww1JmlXqoydy5f6syhhZCGetZ09ihk4yYR2ReLsITJ2R7Ew2b9/ncUmLmcrkUKZjwgerm9xu/4EgF4eMsdqQBdSeAd4TvGgpV/H0iwcY8ZwgAROBorjAY6J2Fp8eW36lr7/+S0bX/3TVCaj4r+CDuwXsfuzU2WypzQ/ymipE/NbUE15fFo9vW3uNME+7kf/YPr4nVqJRbSIhwbtofDmeu/XsI70TB+SFHcBYsVx0uQwuI3sdq3FMYHnSNTHJPTlsQxV1/wI/NjU+QHtJXErQnphbeTnkEelpiz6z1nCerNnwsgVbfkU1mchoe08n0bAmtSAYRhjEn1nIfX+qG3wHzYBAmUHExJ4IkNYUYKUl2GdWuAIxaGDJUfAoAW/vt2PF70GWN9yv5snUOW1O3BbeOuUFCKy/a4qU+aq4gzcviaPFQwzftNrUJUduhMcvlYJfbmifzQRE8QQikFYhGnMjxJIYOXP/FupGewAMwAMx36kKcPz92rTsL+M71dwiqeWuJ1d1JY/vxGcQs3fsFypfo83nb5172ctQ5RNV2idEbllru6mWHoxWV7uCvS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025, Xiaoyao Li wrote:
> On 7/23/2025 6:47 PM, Fuad Tabba wrote:

...

> > +	if (max_level == PG_LEVEL_4K)
> > +		return max_level;
> > +
> > +	return min(max_level,
> > +		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
> >   }
> 
> I don't mean to want a next version.
> 
> But I have to point it out that, the coco_level stuff in the next patch
> should be put in this patch actually. Because this patch does the wrong
> thing to change from
> 
> 	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> 	if (req_max_level)
> 		max_level = min(max_level, req_max_level);
> 
> to
> 
> 	return min(max_level,
> 		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));

Gah, nice catch.  Let's do one more version (knock wood).  I have no objection
to fixing up my own goof, but the selftest needs to be reworked too, and I think
it makes sense for Paolo to grab this directly.  The fewer "things" we need to
handoff to Paolo, the better.

The fixup will generate a minor conflict, but it's trivial to resolve, and the
resting state should end up identical.

As fixup:

---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6148cc96f7d4..c4ff8b4028df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3305,9 +3305,9 @@ static u8 kvm_max_level_for_order(int order)
 static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 					const struct kvm_memory_slot *slot, gfn_t gfn)
 {
+	u8 max_level, coco_level;
 	struct page *page;
 	kvm_pfn_t pfn;
-	u8 max_level;
 
 	/* For faults, use the gmem information that was resolved earlier. */
 	if (fault) {
@@ -3331,8 +3331,16 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
 	if (max_level == PG_LEVEL_4K)
 		return max_level;
 
-	return min(max_level,
-		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
+	/*
+	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
+	 * restrictions.  A return of '0' means "no additional restrictions", to
+	 * allow for using an optional "ret0" static call.
+	 */
+	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
+	if (coco_level)
+		max_level = min(max_level, coco_level);
+
+	return max_level;
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,

base-commit: f937c99dad18339773f18411f2a0193b5db8b581
-- 

Or a full patch:

From: Sean Christopherson <seanjc@google.com>
Date: Wed, 23 Jul 2025 11:47:06 +0100
Subject: [PATCH] KVM: x86/mmu: Enforce guest_memfd's max order when recovering
 hugepages

Rework kvm_mmu_max_mapping_level() to consult guest_memfd (and relevant)
vendor code when recovering hugepages, e.g. after disabling live migration.
The flaw has existed since guest_memfd was originally added, but has gone
unnoticed due to lack of guest_memfd hugepage support.

Get all information on-demand from the memslot and guest_memfd instance,
even though KVM could pull the pfn from the SPTE.  However, the max
order/level needs to come from guest_memfd, and using kvm_gmem_get_pfn()
avoids adding a new gmem API, and avoids having to retrieve the pfn and
plumb it into kvm_mmu_max_mapping_level() (the pfn is needed for SNP to
consult the RMP).

Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
of the gfn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 91 ++++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 3 files changed, 58 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 20dd9f64156e..c4ff8b4028df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,31 +3302,63 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+					const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	u8 req_max_level;
+	u8 max_level, coco_level;
+	struct page *page;
+	kvm_pfn_t pfn;
 
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+	/* For faults, use the gmem information that was resolved earlier. */
+	if (fault) {
+		pfn = fault->pfn;
+		max_level = fault->max_level;
+	} else {
+		/* TODO: Constify the guest_memfd chain. */
+		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
+		int max_order, r;
+
+		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
+		if (r)
+			return PG_LEVEL_4K;
+
+		if (page)
+			put_page(page);
+
+		max_level = kvm_max_level_for_order(max_order);
+	}
 
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
 	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+		return max_level;
 
-	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
+	/*
+	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
+	 * restrictions.  A return of '0' means "no additional restrictions", to
+	 * allow for using an optional "ret0" static call.
+	 */
+	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
+	if (coco_level)
+		max_level = min(max_level, coco_level);
 
 	return max_level;
 }
 
-static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
+	int host_level, max_level;
+	bool is_private;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (fault) {
+		max_level = fault->max_level;
+		is_private = fault->is_private;
+	} else {
+		max_level = PG_LEVEL_NUM;
+		is_private = kvm_mem_is_private(kvm, gfn);
+	}
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3335,25 +3367,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
 	if (is_private)
-		return max_level;
-
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
+		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+	else
+		host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	bool is_private = kvm_slot_has_gmem(slot) &&
-			  kvm_mem_is_private(kvm, gfn);
-
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
-}
-
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -3374,9 +3397,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						       fault->gfn, fault->max_level,
-						       fault->is_private);
+	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
+						     fault->slot, fault->gfn);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4564,8 +4586,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
 }
@@ -7165,7 +7186,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct &&
-		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
+		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_remote_tlbs_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 65f3c89d7c5d..b776be783a2f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return r;
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 			      const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..740cb06accdb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
 		if (iter.gfn < start || iter.gfn >= end)
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
 		if (max_mapping_level < iter.level)
 			continue;
 

base-commit: 84ca709e4f4d54aae3b8d4df74490d8d3d2b1272
--

