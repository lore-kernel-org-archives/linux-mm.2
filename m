Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3489C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7C46B00D6; Tue,  1 Sep 2026 04:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88796B00D7; Tue,  1 Sep 2026 04:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50386B00D8; Tue,  1 Sep 2026 04:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6E406B00D6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:42:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26FF61401DA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:42:54 +0000 (UTC)
X-FDA: 85164553068.03.5F7B95C
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9652914000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:42:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OuHX29l5;
	spf=pass (imf23.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788252172;
	b=D9WH819P/DmQeLMNIPV5Y2cQpS85po7zGi48ySD8r3HV6/VMHjfHvRPt4zcFLLEjRkoA7v
	usrsAiL3XSKBTy/4kfwjbjisX+dGa5I8m3WtLdZgdksf0E3VMmVVFVNgwrTPIp1DgUsB+A
	L5Zg1eW3JJ80z4sCutsQOU6GnsMv6a8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OuHX29l5;
	spf=pass (imf23.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHCR1vhifiqGBwmgoo6qWFbwcRhoeCm5may4xknQr0g=;
	b=mMekbre54zEMxYKSYvlu+zsOuotexHzuAEPsbc+P/siAqmPNhofqWKiD61wDRd/0slzCOy
	5TKPjYImx/vuZj+17w3Zfb6wFTXrBiIDLop4ZkxfFiCrWICyDNbTq3ikCreOLKkg75iU30
	ADigycLfJlpXE6LFEM7Vai9pjCPoDQY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NDRSGPV+38awmoPvP+Bzb90MiKF5Z4x3dNbI2Yyn7Pg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788252170; v=1; x=1788856970;
 b=OuHX29l5qU3JqHeiG7S9oUd/YNbx6wrdt4AOFZkE+d0gtYPIuXsHg3cYR4yhYd3rb+7555Cv
 4NMJb4U0fCwnjZ/jCRzsNJ25Z5pSpRy8AWovb6y4oeHD1j0ewrlWfXsj5/Qx4nqIOL87I6w6CGv
 TtxHpZNqi6o7wVT7V3Do1/7o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b796b84bbdcb9455;
	Tue, 01 Sep 2026 08:42:50 +0000
X-Mizu-Trace-ID: b796b84bbdcb9455
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so5731e87.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:42:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzHm6Oiid7XAT3MMBnS2Zk6BXLpeM1g6LrKfsete64wwkktabS9wPLzz1FFMbGHl2NKPA6eRzYBRw==@kvack.org
X-Gm-Message-State: AFuF++n3OP8XrdF6okp4H39bV5hoE8XSgbplh9tzoXugriDVLGXRz5kC
	/sPTcAgaP8qam+oG15HIXFb+n8kzFQX3jzMaX+r5sHOytcR0SRahHmXkE/i9vjrSKdtZ4GSLOHl
	DrBDMGDQuYFE+gDoa713IjoAiSjC38DOdgeM4kO1r
X-Received: by 2002:a05:6512:ac6:b0:5b5:e890:1953 with SMTP id
 2adb3069b0e04-5b5ff29f4efmr129910e87.12.1788252166683; Tue, 01 Sep 2026
 01:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-7-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-7-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 09:42:10 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyRqnXDwFTcA7k2e-CXe1zdZ674F0mXSDFsn4PuwK+0zw@mail.gmail.com>
X-Gm-Features: AcwNN1WsZWoWKD6AG_hFPG5SzyReAqSBKWje84PPAdwPIk5UDZum7IDo5_qmIa4
Message-ID: <CA+EHjTyRqnXDwFTcA7k2e-CXe1zdZ674F0mXSDFsn4PuwK+0zw@mail.gmail.com>
Subject: Re: [PATCH v12 07/45] KVM: Rename kvm_mem_is_private() to kvm_is_private_gfn()
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9652914000B
X-Stat-Signature: yxa9jq4dxber7te3in9jqh8fxiah43bh
X-Rspam-User: 
X-HE-Tag: 1788252171-814040
X-HE-Meta: U2FsdGVkX1/owqqOWRDNanljrBHc6QBu8TzWABnimkN8TyPf4U59ca0Fbgqx+j58NwGfQlDmGK+dAvO4SVApfD5FZZzfU+I3qFBVTlOb+k5+AOewtiVePk1zhyG8BAApbCqrEPICskoT97nAH7ZbuPQdDkAShi16IHoOIas0Blv0vCfn9UWQUJBnYjzdoryp2VW2j/rgygi53+PihaYBSXsG91MdqT9xXQkAJOReYcs5xC/6H1YLHfGgK9HMW9zjJjVU7vKk8XpsLa95a+rc7t7BV0goYXNEmdKUsS5yA/ImezD1i5478obF/ZPQiGcU2KcTlQ7/eJw8MjPpDSQiybp/DpD7egy4gnhHt7/RYEH95SA1dcPgWgPMP5aPl7khx0KcIaL6bafhZgVNYF8TgQe0u1i0anPiN5vKBiiMr0mGnNveVV0JuxFQaFReFzr5GtVdGE7Sn92FGl+zsoZYbI9jEwL3OBy1OHUQWdr0bb04haCTnLDzx35jxlErXeNv+WHeBzGqd3A4pLb1QCSY4l1af0yw50Id45BJO/7BOCC2ge/9J7m34bWXopfyxlfHy0lXSuRZfyCjojXIA5DsV2ZN+eBwBY9lxHUYwTqfXvTKbAkOUZkaCZ80Nnt4kh1IvJ8fSA0DvirSwwuj+E9Y1JcP35At4X+N5ojfYcDTnqdNOwad3NRwhc0V08T/ppjR5mXNs2psTipCwEtr29o5lHwE17/qZmfqV1Wfid1tIg29WUO/wL5wWyRhwOPI7YvB/qyitQOY7qT5oAAUniKNxZZhPcRfnU0lj6hHU/3hTIDnujRvkZgXDi4rOABVYs90Mf/xvZXw16nI2/qwLd89qcjt3xvEQWEkHsnFym6H/ePTnh/1huW5g2lNzgu/n8Ghc6iBgUZqt1ObgbrqSCniATbvhpSUHk0OP1C6KlEvx70dZjy7uJVxZtCUAlOWvmuRt5YTG6X0sMqRIuTIC4U
 xnqgJBx+
 GJtB63sVAfNR/mwX8PCW91DURypSx5LU/aRKfDq6vop1CipIKRFnTHItpYFsSmNf0/jD31ffDX3PUR/aObK0eHr8aLT2RQgEhsCNW/9+34K+n1gJDdjL3xlsnbNGa2tI9GT376Y7bmApeyEw/oKaRo2n2++ilXmvYOqbpIERuK/90ITxdok19R3h6J6B/zXhQD4U0/56HU9IN6gGZ0tt0QFXGbbAXEhh4liTzBilmIK9mboRMUHk6Lt8KONZPwu5/K+TzepPMG6FUa14MYrXD0xNx8Nig4xLhl5CHtGUeOlgPrM6OikbrQ7OEbK/CzCXODMR0OS0i+QFrzNgu07GeMJ30cNnykWQs7iLzFBnkBHQ2Aa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Rename kvm_mem_is_private() to kvm_is_private_gfn() to prepare for in-place
> conversion, where there will be two lookup functions,
> kvm_vm_is_private_gfn() and kvm_gmem_is_private_gfn().
>
> This renaming allows consistent prefixing of "vm" vs "gmem" for
> kvm_*_is_private_gfn(), as opposed to kvm_gmem_mem_is_private(), which
> looks like a typo.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/x86/kvm/mmu/mmu.c   | 12 ++++++------
>  arch/x86/kvm/svm/sev.c   |  2 +-
>  include/linux/kvm_host.h |  4 ++--
>  virt/kvm/guest_memfd.c   |  2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 10e59507d252f..62f751952ad8a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3421,7 +3421,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>                 is_private = fault->is_private;
>         } else {
>                 max_level = PG_LEVEL_NUM;
> -               is_private = kvm_mem_is_private(kvm, gfn);
> +               is_private = kvm_is_private_gfn(kvm, gfn);
>         }
>
>         max_level = min(max_level, max_huge_page_level);
> @@ -3634,13 +3634,13 @@ static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault
>          * guest spinning on a #PF indefinitely, so don't attempt the fast path
>          * in this case.
>          *
> -        * Note that the kvm_mem_is_private() check might race with an
> +        * Note that the kvm_is_private_gfn() check might race with an
>          * attribute update, but this will either result in the guest spinning
>          * on RET_PF_SPURIOUS until the update completes, or an actual spurious
>          * case might go down the slow path. Either case will resolve itself.
>          */
>         if (kvm->arch.has_private_mem &&
> -           fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
> +           fault->is_private != kvm_is_private_gfn(kvm, fault->gfn))
>                 return false;
>
>         /*
> @@ -4708,7 +4708,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>          * Now that we have a snapshot of mmu_invalidate_seq we can check for a
>          * private vs. shared mismatch.
>          */
> -       if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn)) {
> +       if (fault->is_private != kvm_is_private_gfn(kvm, fault->gfn)) {
>                 kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>                 return -EFAULT;
>         }
> @@ -5111,7 +5111,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>
>         direct_bits = 0;
>         if (kvm_arch_has_private_mem(vcpu->kvm) &&
> -           kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
> +           kvm_is_private_gfn(vcpu->kvm, gpa_to_gfn(range->gpa)))
>                 error_code |= PFERR_PRIVATE_ACCESS;
>         else
>                 direct_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
> @@ -6584,7 +6584,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>         if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
>             !(error_code & PFERR_RSVD_MASK) &&
>             vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
> -           kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
> +           kvm_is_private_gfn(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
>                 error_code |= PFERR_PRIVATE_ACCESS;
>
>         r = RET_PF_INVALID;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0a887f8e05d3a..dff684b88f153 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -5030,7 +5030,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>          * userspace via KVM_EXIT_MEMORY_FAULT events, however, so RMP faults
>          * for shared pages should not end up here.
>          */
> -       if (!kvm_mem_is_private(kvm, gfn)) {
> +       if (!kvm_is_private_gfn(kvm, gfn)) {
>                 pr_warn_ratelimited("SEV: Unexpected RMP fault for non-private GPA 0x%llx\n",
>                                     gpa);
>                 return;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 6ca81f5349db8..9b97266f61ec8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2573,12 +2573,12 @@ bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
>  bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
>                                             struct kvm_gfn_range *range);
>
> -static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> +static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
>  {
>         return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  }
>  #else
> -static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> +static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
>  {
>         return false;
>  }
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index e32ac2c28cbef..ce5efcacda36e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -879,7 +879,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>
>         folio_unlock(folio);
>
> -       if (!kvm_mem_is_private(kvm, gfn)) {
> +       if (!kvm_is_private_gfn(kvm, gfn)) {
>                 ret = -EINVAL;
>                 goto out_put_folio;
>         }
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

