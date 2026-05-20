Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D405CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFAE26B008A; Wed, 20 May 2026 09:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABB66B008C; Wed, 20 May 2026 09:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73466B0092; Wed, 20 May 2026 09:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B55536B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:48:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EEDAC15FE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:48:22 +0000 (UTC)
X-FDA: 84787927644.03.EA7DAB8
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5D04F40012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:48:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SQq7aj3/";
	spf=pass (imf12.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779284900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztFmjo5Zo5EuBU+qrePea2SHE7ZHtOIa9devh9QKOJ0=;
	b=y3n4EZPhRg46OGjOJyscHP+3J9J7m3OkyT2UzlntanpSx/vGK12/iZQsz8igXMa/eSVGuZ
	bkmwZDQnECqUSRxEZ6FVDKllOh45hdgycFBDijh2J1OWq5aFvX5N1ziTggipWkEDKMGdQV
	yZoUEEVgu2e9hnoXQsQcsxhGns9w2qY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SQq7aj3/";
	spf=pass (imf12.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779284900; a=rsa-sha256;
	cv=pass;
	b=OFwjlRGuLi06VsLUnCbVJ+xksdkn86CjlBgPlynp/FP2WRxuvbGc7QqpQFjmDEbuajIchs
	wMsMI7XuLeFKXkMnsBTCOlo0dc/5npiKWA70093Jci/A9fFEUVWUgbmgkeN8WIKlWoBh0B
	TPr/qtIbL8Ayw62tIVkVoBjKShMzElo=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50d6b393d60so2861cf.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 06:48:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779284899; cv=none;
        d=google.com; s=arc-20240605;
        b=YXJc0BBjOFM9337G9CtNng4fwntWZSuKn+OCs9+fFt0lQl6AA1DRvdm987QdcjrgsZ
         Ylzdc8du5XD9+TUli1gy2EKf2UkHxM7NpXH67o6uRzBqnZqJYndLqG0/oO+Dh2g2Ge9N
         sn+j/ETmB8coJNHXLiS+Ts2mzGuLTW8vTlDRpSBV8H/XWZw0a+GzsmoGo9PfUdr12F/a
         jVJ6POlpxZU8+p4fOHygINL7IEEXE2pfDmYawe0L+hZTfsT+BXK+nI/IFDCyXyKfukc+
         FNRRzQ+NwxzUwI3TsE/4VqLZjezp81dPDGLy0xcyw+8yBPnybgQBIF2L2IEu6HbPdwky
         ukeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ztFmjo5Zo5EuBU+qrePea2SHE7ZHtOIa9devh9QKOJ0=;
        fh=YGDzf1/LE3rvqu6FQEW4CTEQdHdse2t3M8+Vlf/J5Kg=;
        b=Xba6aerLJDj5mLI9X6bjUNrFWDZgC605RJnftqCKQnqRYj4jJAABleznC3lqgpBCZq
         u3V2rtyhMecs1LTWUOYVKiuPoGsN+jkkm1hW830jNxB/BaCHJxFYfFC7/+Kbcy3Jh8NG
         BrSIcJEs0dlRYSnu8X3/7+4V/lhSSKb919pcdagQTgLHkO9QvfDVaC7v2DRf6/V+7Nsb
         az+VryGe5JfIaHz0BuU2oOymoTQ9cJTrrXz4SNYe0uyQM2bgggA+z5eroombAiY+1uZ4
         ExrFYEnqRkPKO6YzOqzS9JXArJpnrIktxf/wd4pBoRx2Mk2BPbyBonhHjgTtOTafSZzq
         s1ww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779284899; x=1779889699; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ztFmjo5Zo5EuBU+qrePea2SHE7ZHtOIa9devh9QKOJ0=;
        b=SQq7aj3/wqmIqQ+zfJaGW8QFzMCUWpBdfmmMkwphjttAke1b8sytkNLbQzDyI9DuaB
         lbapkt1x0epF7RnB4CgibKeN2wVimt/lDCuG2l8FVYw/g67fOyS4XmjdrskIRmKU+7nR
         jOtuHgmQIcHNrE7tSmXa8cYUQHnQ/bu7SBM+KF+gOqKnaGZf96WI3f5Zpb810kdOUzxG
         TbZb/5W48KKlxv5HBYneias1Y6Kgyb/yFdQwL9j+/9K/R6mBc72DHW2mG4ecmFkqsPFr
         2DU4CUK0JoxC1cfqMuCBCSRwXyIgDUpwqa38a4AW4bOYBixS0eBGaPuGetBJ3aJv2J6Y
         YlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779284899; x=1779889699;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztFmjo5Zo5EuBU+qrePea2SHE7ZHtOIa9devh9QKOJ0=;
        b=gxLGJ9TfnKXxmMeHtEfK4Qyx/xpCjCvF12vLnyd8X6y/XlIJjgQac90vFTNQ4OaCEc
         DgQSqsrErjWqc0K/8b5oNs3Fcfn+vRY2s0Votc5l5nhgaVR1+590lJdG0cNjiLkkTu/A
         37gffy6c5oV3jsBL+JgBTbcvXbRUvQG17QVeL5p2du4bEsAk4jW8osy5OpVpV4DT5EJh
         gtMfIeG9ud/Mk2Ws21bLruTfiNUaKwT0RonCq85QCKsXW4nwGwSKI0aZin+0CYGrBwF7
         cf/ydqDWP0/lKE5psV0Q7OhqT2+lTXgyznZOl73CWuGq5EvNj3ERvhfR9FR5UJFhEafp
         M9nQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rSPNIBU7CR4vKR0e6AFvDWGXPlmmY0zZ1xE0yz3F5N7hOFGS59YnDZTlNx4nKF5FOdyXcQwBP5w==@kvack.org
X-Gm-Message-State: AOJu0YzjAhTrd14dNynEKMuaEPTlqIvlW4CBxPWzElAwf/SMrDdzzuwD
	kpZMpxtqbGH0p07rpgj7QbQig7urotLj215Ph8cDgMZlqGxLu3v/CUgW426i8YyBARaw4bu2lS8
	epPyy5KDuPiEUn8k6B6a24DbCM3nAuvg4wKWqnl+l
X-Gm-Gg: Acq92OFw2v0U/6DLdy60/qEZdIgeq7KkVL0EfSNv5qGvGspZIOrUjfziK2dtR1vF7oW
	vSe3WMH3ne8WYDUfiqlXdt+hwiyoB4NdDyPuOrEvtbQohM2WJ7MNmJzXmINgxLTg76iYVjGMM4c
	QMLhvWi+StiesbJJvj2FF/C0YxMhvuG7k/vCPc4JkwJ/u3JD51SvLK+Wu5pWx+L0vMul4x3nqQ2
	PJwJBRhvbX9aDbmT1XJcJzVRNM6BAegouLaKQEZsHrGldMZWzSXphRlo9viSQdlC5cwgZ1vK/jJ
	hHbDlImF5I2TOForwBKfAfuevxG1PQ==
X-Received: by 2002:ac8:7fc7:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-5167b683f38mr8972121cf.5.1779284898204; Wed, 20 May 2026
 06:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-7-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-7-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 14:47:41 +0100
X-Gm-Features: AVHnY4Lt4aJCZG7zHyyVEbse7TC1B-amOpcSsUxTZmECQsMY0Fon9T-IHHMiF9s
Message-ID: <CA+EHjTxg6f0v40EBDE3APXrF_qt=8GTx0dGKrKDLqiNwdU_dQA@mail.gmail.com>
Subject: Re: [PATCH v6 07/43] KVM: guest_memfd: Update kvm_gmem_populate() to
 use gmem attributes
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D04F40012
X-Stat-Signature: cp8grnbu1s1b5hbpd53gj7uyiy99utzs
X-HE-Tag: 1779284900-307452
X-HE-Meta: U2FsdGVkX19x0TqGqpmCJJbs8VqJ+zU+TO8EIjBrbUg2mQ8tBEWKoiCF9PSs9k66KtIjsx+NRL61bsJJnpUILo7o+k0ssR+SqPdfdMKfKNDaXoQISly8bTuJxpBo6vtTEJ56gndS3u/yi9aQItWBlwjGx+Zuv/XmDV4VrxH1eQUqD+3tQ69t+/TVmX0apHlf74RnJNADMCqu2vpT9NdZhQUcgy8Q1jtxLxhbTVjHCjyJSQPZou/PSF9CblkzblB7cePo0c2FeT+ZT3clknE4qODIwtSUHrchXHu61ctrobzBAh2auN2P6kHhaSxzdwmQcMIGvGg2d8LWUmEUEv6T0gqgwR94ZPy0oUi8n8aMLDUVUITJBhOuhecELQkuiKHqYVhx7doGQQrPlpYY2+TuYKzXlBS99wrmPQaiRizObtJIRmBBLy92bwALldmN/lPAaqrMwZuvhbwXEH66o3M+oZ1tEnYEVpFyfdCHsh91Ng129TxauqcfUHxyhz0OMTnFxsoAXRz1p+RCJNXfCuspACWVayktyfYV8tRkzgkWh/j7NQu2uQVjEsD7+ucZhtIh9mFAgaSX87H1qIpfEYrtVM/CqNNjYhDKpCDB6ZiPGrpMs71IHgGiZ9xDWeBxihJTl4hYzinGqewe8qoYmSYioxH/gKsyOiD8697R22NsU/1L0vMOjRX3rBde4KOEoqiaRs0q9vHeNM1eyQyaaVNCJw0EsKT7QeCIqE1PNkNQzCbxDWfoPM/+cZImddOCXUQ6PedtdwxE2WDwacdu4wDSiSfmb2UHBZEQtSTKDU9aHb1DvfQCMmLhoIcf81RcQXX+zbk4IvyI1XhzGnpkKj2eHVryIC6qxPBXAtmQuf1NwMVlVc+tK9k5QOXfVR0uD04ZP6dSzLtc/wVDgzXe8S1Qh/BG++wdfVE96JpmcUPG9plbjFKBeEVwcNqZxG5xIengLoTYgUv1nJLK3bHiv52
 FCN/CmSj
 MoDqnAp2c0d6xdC1V/yGxSGIjTCKr/gFeP+qDh56wQ7b9Af7JkI1Jyx4XKH2x3AgXcA5QhgZ61jCQ6S2Z/KGgzDoejM8t2GFklfUpZPylGTRzYNT8c6BulAyoqlQu3Z3xyv6WIvNk2QlGtbgSx2IUvsgqCOccJ+zPpCY62LcPY1OLvfkvh7YoIbLDvNC/LtTJ8ilZLlGu+3EAnBQYwkRDorac18UCLhFBj5w2/O9JFtwW88r/sk3zAiYSGBouR0/Og3ZmDjRJP/EzUj/ICy8+SKNjYwFzXzTLDKeVG2qOFNsfyI0js4TLIkwL4kL3Q0HJKQ9i3hhhEKsMqPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Update the guest_memfd populate() flow to pull memory attributes from the
> gmem instance instead of the VM when KVM is not configured to track
> shared/private status in the VM.
>
> Rename the per-VM API to make it clear that it retrieves per-VM
> attributes, i.e. is not suitable for use outside of flows that are
> specific to generic per-VM attributes.
>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
/fuad


> ---
>  arch/x86/kvm/mmu/mmu.c   |  2 +-
>  include/linux/kvm_host.h | 14 +++++++++++++-
>  virt/kvm/guest_memfd.c   | 24 +++++++++++++++++++++---
>  virt/kvm/kvm_main.c      |  8 +++-----
>  4 files changed, 38 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 153bcc5369985..bfcf9be25598e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7997,7 +7997,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
>         const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
>
>         if (level == PG_LEVEL_2M)
> -               return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
> +               return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
>
>         for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
>                 if (hugepage_test_mixed(slot, gfn, level - 1) ||
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 28a54298d27db..1deab76dc0a2c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2549,12 +2549,24 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #endif
>
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> +extern bool vm_memory_attributes;
> +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>                                      unsigned long mask, unsigned long attrs);
>  bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>                                         struct kvm_gfn_range *range);
>  bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>                                          struct kvm_gfn_range *range);
> +#else
> +#define vm_memory_attributes false
> +static inline bool kvm_range_has_vm_memory_attributes(struct kvm *kvm,
> +                                                     gfn_t start, gfn_t end,
> +                                                     unsigned long mask,
> +                                                     unsigned long attrs)
> +{
> +       WARN_ONCE(1, "Unexpected call to kvm_range_has_vm_memory_attributes()");
> +
> +       return false;
> +}
>  #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index f055e058a3f28..9d025f518c025 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -924,12 +924,31 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> +static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
> +                                     size_t nr_pages, struct kvm *kvm, gfn_t gfn)
> +{
> +       pgoff_t end = index + nr_pages - 1;
> +       void *entry;
> +
> +       if (vm_memory_attributes)
> +               return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
> +                                                      KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +                                                      KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +
> +       mt_for_each(&gi->attributes, entry, index, end) {
> +               if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +                       return false;
> +       }
> +
> +       return true;
> +}
>
>  static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>                                 struct file *file, gfn_t gfn, struct page *src_page,
>                                 kvm_gmem_populate_cb post_populate, void *opaque)
>  {
>         pgoff_t index = kvm_gmem_get_index(slot, gfn);
> +       struct gmem_inode *gi;
>         struct folio *folio;
>         kvm_pfn_t pfn;
>         int ret;
> @@ -944,9 +963,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>
>         folio_unlock(folio);
>
> -       if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> -                                            KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -                                            KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +       gi = GMEM_I(file_inode(file));
> +       if (!kvm_gmem_range_is_private(gi, index, 1, kvm, gfn)) {
>                 ret = -EINVAL;
>                 goto out_put_folio;
>         }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4139e903f756a..0a4024948711a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -103,9 +103,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
>
>  #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> -static bool vm_memory_attributes = true;
> -#else
> -#define vm_memory_attributes false
> +bool vm_memory_attributes = true;
>  #endif
>  DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
> @@ -2450,7 +2448,7 @@ static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
>   * Returns true if _all_ gfns in the range [@start, @end) have attributes
>   * such that the bits in @mask match @attrs.
>   */
> -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>                                      unsigned long mask, unsigned long attrs)
>  {
>         XA_STATE(xas, &kvm->mem_attr_array, start);
> @@ -2584,7 +2582,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>         mutex_lock(&kvm->slots_lock);
>
>         /* Nothing to do if the entire range has the desired attributes. */
> -       if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
> +       if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
>                 goto out_unlock;
>
>         /*
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

