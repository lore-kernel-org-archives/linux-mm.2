Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF89606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=bsqsLudo
Received: by kanga.kvack.org (Postfix)
	id 5D18C6B05BB; Mon, 26 Oct 2026 09:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A95E6B05BD; Mon, 26 Oct 2026 09:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4989F6B05BE; Mon, 26 Oct 2026 09:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB576B05BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:50:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CDC6C0715
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:50:01 +0000 (UTC)
X-FDA: 85364911002.16.B1781D2
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf22.hostedemail.com (Postfix) with ESMTP id BCB50C0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:49:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bsqsLudo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3hlrfagYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3hlrfagYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793022599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7my5rSEsn+U+kYhoFnNu7P7PE6jHz+gWSHK/wcS/Mk=;
	b=l6HCY/5exBviqFq7S+JbAu5+Q0+T9YlLz3z+MGrx6paudN3rnYEdGaCny81TUCjFaLTTtN
	7pHnJHuaKjkKatvmsZ1/4mgHGkYb2pSQW8h2+lV23qS4vXxrgLEIWo/W5PUgmRGfxqpQg4
	/nZaQ0z6N59HOQN0q62SZBdLoy1PXCY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bsqsLudo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3hlrfagYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3hlrfagYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793022599;
	b=0jMx6XLpqUG5RsrIM3KRkcKGFa8KybKGO0b2DYztizV+r3W5zfZmLt5hSST7l84RljB9M7
	W3fLijiGXN/zG9rgRW5ZKC/iQfAT/UE00nndZv7P22ry2dX0lm66RR0C35IX5IY2uKCUhR
	7pPDOnPsB1d8jH2FKrbjfeHfsrziXMc=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3addd73e66bso1976072a91.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793022598; x=1793627398; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c7my5rSEsn+U+kYhoFnNu7P7PE6jHz+gWSHK/wcS/Mk=;
        b=bsqsLudo79561g97jiGy4bFhatle1qvMjlYHRgddddmNwHyzdMZ0bahW9escQv8OG/
         GGXHGKT4/7GvlgvOLUl3cl78PxMVtGsHdM9b4v1Lm8r+a9Waa+OqGmZ9Msy1N3xgeGHi
         CmD94QJ30kC2fqOJclicgfZs9ge6ZMkFTR8bGMDXzsLluVE+o6c4464EMOuZxQo2jJKS
         4JHh9H3jC2YhrgvsbARaKaAS+HJCZY4OeIsSfkaYjP6MwdZTBfKmxhBCJdmkkXO1Owwv
         Al1FlDNuvGTuWGJuQOtntrNnUew20RK17JS9EcElKbA+afDT6jjWpRSPz9DcFq0r3r7O
         /X8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793022598; x=1793627398;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c7my5rSEsn+U+kYhoFnNu7P7PE6jHz+gWSHK/wcS/Mk=;
        b=V7ZV2wKfQCa6hazXdSw1qAyZmX/9MIWiv0WqT8Synw0L639+RjwTdKBVaYKm7i0Dtg
         y2C4TwUW8GezPHrHSLVDsE6/uvE82QwBQv0JuU2eDn/PSX3voVRDPUQ2AszJbb2J9e6u
         055uf9kGccO4XzPrlg6pN3csmKLDL5ZovnjefkTjX24LrbxFA0jQvXQy+HKL3FfMZr6P
         EUKlW3tB6tZ1H24BaWDYV9kAYiXx3FKZk82u1zrll/5M6rOHDXCDoxZdnQXryxsX1dpN
         ucNE263vN+uDlljuw9fp8KxTYz+FzC3GgDoobNKJPQNDfAvFy8v2s0OmN9gnKjkowMy/
         RTGQ==
X-Forwarded-Encrypted: i=1; AKwUvBw27+Xu1DN6B0kv9JvrlW3kra+0wc7Tnp3FwGMsHDsDPpjJ4cpIi0IM4AGZmYYKUVKH6MlOKih5EQ==@kvack.org
X-Gm-Message-State: AFq9FYL3uEzkofGG2fBoyZHROEP5X4Sa8jonkWuAY5LY+0wyRlNjv2Uo
	YxaR26uPUQ9rEY9qqdBs6D2crKFqO8Mg/twzEflL4TJuTNRJ+PCd8tG6vLGLL32PGKaFDpMTscy
	SfDkzqg==
X-Received: from pjbbu22.prod.google.com ([2002:a17:90a:ee56:b0:3ac:c43b:e322])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:564d:b0:3ac:7f4c:a690
 with SMTP id 98e67ed59e1d1-3adeafb0449mr5178332a91.35.1793022598376; Mon, 26
 Oct 2026 06:49:58 -0700 (PDT)
Date: Mon, 26 Oct 2026 06:49:56 -0700
In-Reply-To: <20260804120529.1730187-1-pbonzini@redhat.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20260804120529.1730187-1-pbonzini@redhat.com>
Message-ID: <at9ahKiYsVtH8kpU@google.com>
Subject: Re: [PATCH v2 0/6] mm, drm: fix interaction of .pfn_mkwrite() with fixup_user_fault()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Alex Williamson <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, 
	Boris Brezillon <boris.brezillon@collabora.com>, Christian Koenig <christian.koenig@amd.com>, 
	David Hildenbrand <david@kernel.org>, dri-devel@lists.freedesktop.org, 
	Fei Li <fei1.li@intel.com>, Huang Rui <ray.huang@amd.com>, linux-mm@kvack.org, 
	linux-s390@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	Sergio Lopez <slp@redhat.com>, Thomas Zimmermann <tzimmermann@suse.de>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BCB50C0006
X-Stat-Signature: odo96i5mxf6tokb9dzj7kq7h9g3dd4fp
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793022599-173731
X-HE-Meta: U2FsdGVkX18lpuwaaUgforYHy6h4NGHYoZ+0Rsk+6MamSpmSVNQ5LHEqDny3YVompchCweNF/ANglPQo0ZPXYTvUFFSOmAelTuqqZdRW+SsreaE7DqVtRrr8VTZB90h7xMnSWF0WqrpFRBrWq6tmdgPwgxnV8pTydp3GfDGh7pYRTZb/ByTirsyC6r0EXf+k73/tCL0+m7hnzdMcXxlzlMPi20wK6sqRf0xO9VkHzPhDIf+rYEW5DyAcCocmZwUIurL0/htkwXsrVmzWOvgpiiIt6jKxu+oI3kBhhcSuyt5sAbk8FjfjrQipQRBoqclpLhzh+MqMZkTfjPUVQmTPJASM2JqPmDTgSjayWokgp1Kk5Jx925PeOZLlKVHQMAFH9T3HS2fliUXez81Sm3YUIMdjCAef+61Vv/6874seVV74mHEMgJaklw2UuZlzV6iS5GgkShhCiAknWiLu3+K7Evcpq9v6eIpk+5kgunvEEdFfdCqCSvz5146JIxESNuWKudoQZPBhDQIMRFPpVrEmYWlfxaVa8woHehj1vbV/6aYvjEewNz6Lx8k1MYoVdfVipqQD11Gx+4YY+uuMFoBzQyjN/R15ruk27PTH/A7bOM2AgiJUj/gxn8iIvFqVzUPPY3YQYrRxuNYh1wvESLFs71X2Q9xK76ibJ34kFKfyUpm/1JQLfvnijfO4OD498wjJZR6Kb2gyWWH/JFEH029s2COVniJj5b8dErNqX5nGoKImoK2/6Y5lxcBpB++KRFQFoiW5anIgE8emoDKhzgv4k7inNklaZoqEEbmThxwDAeN2eoEKTIXvsodjAot6Yr0t7FvFeM9CSYgz5qb2EzOs0KlCivUFQKVwhys5UWLHS6/vxL2xH643nB3PY+YbfswvEg9C7OT7DUAK68437BizrZm9KaUZ5mEMROK+pS+/KMp+cqk/afpAm4tJiOe3TjvAlVeSdzbjNPxSRKc8yvz
 Gmo46lDl
 JUwefd2+gc5dRo3s93WzRaxdmGJ656yeXmav/Ed7jQNINTn07hHryFpV4CjaN5ORzdIOWPChtIXpAaMFil4EOB/gVCETQ2IvOoT/3wbDKaKoVaNmrlDWl1991G2F0gSfLzM+qmLS8pdAMLhaV+NAGxXw3ya28eYgDDryd4DKJ8CuBBPfe2NpRnarqNsJH7JARLLg/MEvVLPVbekvq1l+888lRP34ohqkUYRoQRTJtzrjE5uZnmvgQth5YETyy48f0lwfM/Vw4pKK4gZ78y0Tu9Ltp29FLt2QsKeJmWX1dm9FFOxUnOjgKNcPHNxpZMerOdKKtsXBNe1/lR0iHqJo8DWaN+2ut2Crf58wEoum68HNPYK6KzdPTLc50yaOTAJQ83+RJojO+C7hBd8MNKufndyW+xry0Ashms6Ao/raaK4jY40NhoJYLRA6+us1KTNpBlEbI8U4tN221NI+wiRFa6ycf7hJrWtuAr2uZUBRFzhbRobkw90Egld1RRdPgfpnvWkz4y34Tsppe82C6MDQTmRVBbyi5aFbGxlTKQeQ3VvRop+jTcYOcrRriL2eegUt8NXH+XScCLqDaK1peg5g/0WLAL9w2gVQARZNfxDoQCg46JZoeavSVsQieHs3vnxHr0JKGQaMM1jcf2LR/PkCmBWhRwu5VhqPibsv4imhAar5emqn7425KFvkck7uE4qmXlcK5lpSi9aqde/praaSHjZE+xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Aug 04, 2026, Paolo Bonzini wrote:
> This "v2" combines three series that I have previously posted separately to gather
> reviews and tests:
> 
> - kvm: apply VM_READ/VM_WRITE checks to all VMA types
>   https://lore.kernel.org/kvm/20260731175834.1121005-1-pbonzini@redhat.com/
> 
> - mm: pull writability check to follow_pfnmap_start()
>   https://lore.kernel.org/kvm/20260731160514.1101989-1-pbonzini@redhat.com/T/#u
> 
> - mm, drm: ensure .fault() does not have to be followed by .pfn_mkwrite() for write faults
>   https://lore.kernel.org/kvm/20260731164341.1109827-1-pbonzini@redhat.com/
> 
> All three, together, make it possible to write drivers that use .fault()
> and .pfn_mkwrite() callbacks for VM_IO|VM_PFNMAP regions, and that also
> interact correctly with users of fixup_user_fault().
> 
> The problem is that if you define .pfn_mkwrite(), vma_set_page_prot()
> clears the writable PTE bit in vma->vm_page_prot, at which point
> the .fault() callback has no way to create a writable PTE.  Users of
> fixup_user_fault() will then see a read-only PTE and have no clue that
> the page needs a *second* fault to reach its final status.
> 
> fixup_user_fault() itself does not have a good way to notice this, because
> vma->vm_page_prot is an opaque pgprot_t, so the fix needs to be somewhere
> else.  Other preexisting functions, namely vmf_insert_page_mkwrite()
> as well as vmf_insert_pfn_pmd(), suggest that this has to be the driver.
> In fact, of the five vm_ops that use .pfn_mkwrite() together with .fault(),
> three are in file systems and are not buggy: all of them ultimately end
> up in dax_fault_iter(), which uses vmf_insert_page_mkwrite() to correctly
> insert the PTE.
> 
> The two problematic implementations instead are both in drm code.  One, in
> drm_gem_shmem_helper, was reported as a KVM regression; the other, in
> vmwgfx, was found by inspection of .pfn_mkwrite() implementors.
> Both of these use pfn-mapped regions, but there is nothing like a
> vmf_insert_pfn_mkwrite() function that they could use; the first part of
> this series thus adjusts mm.h to provide two new functions for this
> usecase---vmf_insert_pfn_prot_mkwrite() and vmf_insert_pfn_mkwrite()---and
> then teaches drm's two users of .pfn_mkwrite() to call them.
> 
> This however leaves another case buggy where fixup_user_fault() is preceded
> by follow_pfnmap_start().  Most callers of follow_pfnmap_start(), seeing
> it return 0 for a PFN that is mapped read-only, would not attempt to
> call fixup_user_fault() on it, and thus the PTE would not be upgraded
> to writable.
> 
> This is arguably a bug in... almost all the callers of follow_pfnmap_start(),
> but fixing it is much better achieved with a small improvement to the API;
> if follow_pfnmap_start() is told by the caller that it needs the memory
> for a write, most callers are simplified because they were doing such a check
> anyway and now just see -EFAULT.  They then proceed to call fixup_user_fault()
> and everyone is happy.  This is done in patch 5.
> 
> To sum up:
> 
> - patches 1-3 introduce the new MM API, and use it in the DRM .fault()
>   callbacks to install writable PTEs in response to write faults
> 
> - patch 4 is a preparatory fix in KVM, eliminating inconsistencies in the
>   handling of !VM_READ and !VM_WRITE VMAs; these would return different
>   error codes for a !VM_WRITE VMA depending on whether the PTE happens
>   to be mapped (but with wrong permissions).  This needs to be here
>   because the next patch would introduce even more inconsistencies.
>   
> - patch 5 moves the check for writable PTEs from follow_pfnmap_start()'s
>   callers to the function itself
> 
> - finally, patch 6 is a KVM addendum that will have to wait until
>   the next merge window; it removes yet another inconsistency in
>   KVM's handling of !VM_WRITE but is technically userspace-visible,
>   and therefore it shouldn't be included in stable kernel releases
>   unlike the rest.

What happened to this series?  It seemed liked something semi-urgent, but AFAICT
it got silently dropped?

