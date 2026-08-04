Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D37BC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C97E6B00CB; Tue,  4 Aug 2026 17:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579266B00CD; Tue,  4 Aug 2026 17:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467BF6B00D2; Tue,  4 Aug 2026 17:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7E26B00CB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:15:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 884D31C08B5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:15:45 +0000 (UTC)
X-FDA: 85064843850.22.30748A4
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id CCFF540009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:15:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p1U9IteM;
	spf=pass (imf11.hostedemail.com: domain of 3flZyagYKCE89vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3flZyagYKCE89vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785878143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHQOfCFF6yaKH9HqGSLDO98Dtf8szKrkpDeyDbaXUEA=;
	b=niXTInSKZYWZG/ZN7aZHpdfa5P3jKyV4gWAPlwf6KrxUv079b5KdDffhw5tz22XE522aEF
	mUNjwHJy3hyYL5Ubr6GISUurYp28V6/Ck/7Ggnr55eFv7rUGRYrHLIUk6gmqKGyJc9bFw+
	1kSda8YZmvrZMSIRw622PELTtwndV4w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p1U9IteM;
	spf=pass (imf11.hostedemail.com: domain of 3flZyagYKCE89vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3flZyagYKCE89vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785878143;
	b=C6xaQ9/BIVfSR5zRLcKW8o5mpqx4mBCqk6QObzoTLFX2zdpOTqDMRMbhdu1Va2PW5+a/KP
	qhURAQbK2Y9AHJDoVY5YM8UxSN+HOkhK/NG0K+Fd65NSzyZ4biQE+1Qob5B3fB9FPDGwq4
	LlIYUc1Dj4o7jyq3uRI3JdN17w2HdfI=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so373683a91.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785878143; x=1786482943; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rHQOfCFF6yaKH9HqGSLDO98Dtf8szKrkpDeyDbaXUEA=;
        b=p1U9IteMVriVuCrHxao3W0TtiDlE5E2d0Qa8Hndie9rnyo+TuZke0g5DoS4Lb8KVHk
         F8CA2TeABc0QSDUdoTSsbtt5uJywkYIyPxMbPZ42WSrJbbit1oBZY4KRlqF9COg++vPf
         0NxZt7YruJbgZwo0dnFIAJcAdoSheZU0UQqKTXBO08JWkDknog9lyubQ/p36FwWc+Pu0
         hxcPha12VaRg4wAlsejxoWp63eHVyms3OmfEjKNq0PwDJA1XQn6yD/Sgh5o/tsFXK3Jm
         ptX/eOzFBCb6EDDFM8tgCUzmJ7NVYPNNrEZKx79Pz46tZlsHz2XI7Dd1r7cderljrMS1
         Td9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785878143; x=1786482943;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rHQOfCFF6yaKH9HqGSLDO98Dtf8szKrkpDeyDbaXUEA=;
        b=rb8HTW3fNofX8CaVDt3n7LZRRAbpB28RVBsoRvTcYk5yccglAQG7cNs/oaWkoyfsWJ
         qMD/hgUG8GMjjkynbqpMUH4HTrgNq5KehxRim+zgcZmh4IxlNXUWhkBzgL9Q0Ttf7+Us
         O3KUTQZQ5cS/TbEWlPh3qNPqPkK3Ub8ctYl3b3WFpALNh1d7+L2ADbxSfFlpdPGMlZDu
         3V1bmpL7WicrQpEzJ03vrD2WPnG36XNdncTc3Rw9y8d3FkVcy7FJVwpJd+9D4ibOb7XO
         150mekHayOfLNSL1pQOsm0bY5hT4lgFTyyk8lnWpmZxDZn8X0/44f9f47zQSDmtDWmrk
         p+Ew==
X-Forwarded-Encrypted: i=1; AHgh+RrdM5qt/8w7qCI7g94bEyAviFoBc2ciSKg+/QCEchhqnHXmq0PXfGZSUN13LXEoiwscuUn68grsIQ==@kvack.org
X-Gm-Message-State: AOJu0YziWjcWCj4yYoJg4oVPj1z97/q73c3/zns9r0TZnGBDvHVJbr5b
	XCEzhUV0qwo7OXQaheHIQeR0gU8aboabHC/Vc+4j9S5WJqvEtX9Gr+Of8wkd6MjDLz2yLWQCYql
	8h+x6Pg==
X-Received: from pjot9.prod.google.com ([2002:a17:90a:9509:b0:38e:1db:751c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540e:b0:38e:6a30:4bbc
 with SMTP id 98e67ed59e1d1-3903c681346mr1785320a91.21.1785878142058; Tue, 04
 Aug 2026 14:15:42 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:15:41 -0700
In-Reply-To: <20260804120529.1730187-5-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20260804120529.1730187-1-pbonzini@redhat.com> <20260804120529.1730187-5-pbonzini@redhat.com>
Message-ID: <anJWfesPj1C8fzFr@google.com>
Subject: Re: [PATCH v2 4/6] kvm: apply VM_READ/VM_WRITE checks to all VMA types
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Alex Williamson <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, 
	Boris Brezillon <boris.brezillon@collabora.com>, Christian Koenig <christian.koenig@amd.com>, 
	David Hildenbrand <david@kernel.org>, dri-devel@lists.freedesktop.org, 
	Fei Li <fei1.li@intel.com>, Huang Rui <ray.huang@amd.com>, linux-mm@kvack.org, 
	linux-s390@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	Sergio Lopez <slp@redhat.com>, Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCFF540009
X-Stat-Signature: nrq17xgnebk9js3oetk1ebd57pqfnuxc
X-HE-Tag: 1785878143-9582
X-HE-Meta: U2FsdGVkX1+PEQ9CLGqHJdquSbso8ZoQ43eeNhyqA8FWxE0xpyS3cB8r7gCPwescMJhK5le2kHC1KPIokg7b71d/2rLmno/ZBpJyWcUIGYDyBwqg0TolGEZLIkehZNo+JNz6D1KR1J4W/9CK80Y5plj6uLxyrMgYMvguryl3Rh5ax0qPFax3amsZnCzKyUrjzE5ScXprwmltoV80uAQePBBfrAzE8FeC16GcR7L7Q/9jOrjkpBQM0Yo2wJGZw3pvlOXhgY3eZLRuuX0IcdnYIRSCx+OtZb+HHK5TjyvMoQT2GAWB2UTUL+P3qftwwljyB+pAq+mB+NZuUMMOWvdTthG+NuhF12XaSCLmLg0n6Mt4cEmGzEBbsDNBRyhLaYbi2EDKl4WjRjHA19oRaHQkF3N5O2CENv4/FHl8NAsbHfm+Auriunk8mGcuAnHp+7P4ttviHwrEibe3yiL0wWwVBfVIgm7dAHSbbWi9NW5KcG4hxL82/oefA+/6nQHO2SCgpVxhNkuU2MmqBxJHukfOnzR3JXttryZ/VVmqNKoiO651GglbXTz8Tm+SjN47TTitF5Uu6zUR3nIBa7iAowV3WXS5AGPPcWaUVCUponSR120Awtou25swVuaHr2WdUobV0t/do2Ir7IVnqBlNVcmKQxCqHvaO3mDUykVllYk/nwBEmETyF2MSifLnKYO/7gVIisqygYCe3HHBd4trphxiFNOqSVULR1lzJsmEYYJeomQwZNrjLxa3BzcR7E2kHK0FWq6hZUH4H+4w1FsO0BG18Tw6hk/6dbRlIzBHtulv01bGsPQ5+4r3NmuIz5HwwvvFIYbxR+9oM/G5clVBpRl+DzJFbSgNK2o3rsE692HJPrawcEbTPMYAUFTDgu4lkJFMq0eIHQePV34nM5Y/cds+07PUxwKQ1kIPftrMcOz9RpTQkXzGW1cw5GSqjqLNFijIj1VlumF7AyPp1EVusQZ
 RnfYHeL1
 p6yf3+YMcEVW9xERg0y8yr/CUbzIogMc0ttE1hmHzEVCzUDvzeuph39OQGqg9s2bXNsTEg2M5aXlQ1i7tw+heMldvpTlgfS4j1fjjO6QlWAa3PNa6XnUPFKglNsHvtrtMmaISTULQeO3Fg+S13zKnrUfNkWR6miQ93cB5eIU32qEYSsojy+1EUx4ZVM8AqHTTPsM7FiVfeLQgKX5viLO3Px5AYbLej7CNElvg1Dt2+ZvxWKCMm0d+r6xrzVwHE9yarQU+rMFh3TwaP/LTzbDwTD0VqiohNQBQUSiPLsPrb9O+lLXRQdlqL8TugZ6KjGP/i5i88h0eU8MxiSu+TvQNuuNSfaxq7g+yrS7wzRSBvYVi1PVSUnDQZNQhpppM6oiM6ly3Xoghsf+VRKPpPwNG9Qwd0R/NiUzp2ivfnbcHue02Vzo540E1v9MmkN6jFPvr6kA8fOT/wS82VQLR7RVGzYU0Q2DZtNpZUhS1kmfNLEE6L0zUmXA+M/zTeIFDRX3139Bmrta3nmFpxFYnHFDU8RcJSkbc07sLz7dgFqNEe48HnLRowDjedcM+AYDCoVIwnW++dmL6covmu3dkJ0dcCZvmtq/IowEjfUyn1WbZF0ACiQyjslDx6TxyDXiCMam0bIRmh4Wz6DlT+D6lAUYqykH9mZ7lzzdtUEx4WsHuqXoZy8jMGn2oXtdaMDp316D3KAArGpcrh0cH5eD6S7zwKoQJRnra5gN5H1hzVo9ctSSyPj+BuYx/4fHJeNEBm3oL6QVBERSF5PPxR1r4F98A/hxHNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KVM:

On Tue, Aug 04, 2026, Paolo Bonzini wrote:
> The VM_READ and VM_WRITE flags are checked only at the very end of
> hva_to_pfn().  For both the hva_to_pfn_remapped() case and for regular
> mappings, this adds unnecessary cases and inconsistent error behavior.
> 
> For hva_to_pfn_remapped(), the code is relying on fixup_user_fault() to
> detect this situation.  This is fragile because hva_to_pfn_remapped()
> returns different error codes for a !VM_WRITE VMA depending on whether
> the PTE happens to be mapped:
> 
> * if the PTE is present, follow_pfnmap_start() sets args.writable to
>   false and KVM_PFN_ERR_RO_FAULT is returned;
> 
> * if no PTE is present, fixup_user_fault(FAULT_FLAG_WRITE) returns
>   -EFAULT after checking vma_permits_fault(), and hva_to_pfn() ends
>   up returning KVM_PFN_ERR_FAULT.
> 
> With this patch KVM_PFN_ERR_RO_FAULT is returned uniformly.  Likewise,
> a PROT_NONE pfnmap VMA would be mapped into the guest if the PTE was
> pte_present()[1] when the guest attempted to read it; with the patch
> instead KVM uniformly returns KVM_PFN_ERR_FAULT.  Doing the check early
> avoids these special cases and also sidesteps the issue pointed out at
> https://sashiko.dev/#/patchset/20260731160514.1101989-1-pbonzini%40redhat.com.
> 
> For regular mappings a PROT_READ VMA, if placed in a writable memslot,
> would return KVM_PFN_ERR_FAULT instead of KVM_PFN_ERR_RO_FAULT when
> the guest writes to it.  This would cause a -EFAULT exit to userspace,
> instead of triggering emulation as the VM_IO|VM_PFNMAP arm would do;
> however it should be considered part of the KVM API because mmu_stress_test
> relies on it.
> 
> Still, even with this snag about the returned pfn error code, pull the
> vm_flags checks in front so that they are done for all VMAs and the
> above inconsistency goes away for the VM_IO|VM_PFNMAP case.
> 
> [1] on x86, for example, such a page would have _PAGE_PRESENT clear
>   but _PAGE_PROTNONE set
> 
> Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 45e784462ec6..576bcb21be3a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2925,17 +2925,6 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
>  	return npages;
>  }
>  
> -static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
> -{
> -	if (unlikely(!(vma->vm_flags & VM_READ)))
> -		return false;
> -
> -	if (write_fault && (unlikely(!(vma->vm_flags & VM_WRITE))))
> -		return false;
> -
> -	return true;
> -}
> -
>  static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  			       struct kvm_follow_pfn *kfp, kvm_pfn_t *p_pfn)
>  {
> @@ -3008,20 +2997,29 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp)
>  retry:
>  	vma = vma_lookup(current->mm, kfp->hva);
>  
> -	if (vma == NULL)
> +	/*
> +	 * GUP failed.  It could be an inaccessible mapping, a pfnmap one,
> +	 * or the page might be absent.
> +	 */
> +

Unnecessary newline, IMO.

> +	if (vma == NULL || unlikely(!(vma->vm_flags & VM_READ))) {
>  		pfn = KVM_PFN_ERR_FAULT;
> -	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> +	} else if ((kfp->flags & FOLL_WRITE) && unlikely(!(vma->vm_flags & VM_WRITE))) {
> +		/*
> +		 * Exit to userspace for PROT_READ mappings in a writable
> +		 * memslot, as this is part of the API.

Can we say something along the lines of "for backwards compatibility" instead
of saying this is part of the API?  Because that's definitely not KVM's documented
API, and we're hoping it's not part of KVM's undocumented API either.

> +		 */
> +		pfn = vma->vm_flags & (VM_IO | VM_PFNMAP) ? KVM_PFN_ERR_RO_FAULT :
> +			KVM_PFN_ERR_FAULT;

Please align the two branches of the ternary operators:

		pfn = vma->vm_flags & (VM_IO | VM_PFNMAP) ? KVM_PFN_ERR_RO_FAULT :
							    KVM_PFN_ERR_FAULT;
	} else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
		r = hva_to_pfn_remapped(vma, kfp, &pfn);
		if (r == -EAGAIN)
			goto retry;
		if (r < 0)
			pfn = KVM_PFN_ERR_FAULT;
	} else {
		pfn = kfp->flags & FOLL_NOWAIT ? KVM_PFN_ERR_NEEDS_IO :
						 KVM_PFN_ERR_FAULT;

