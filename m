Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1376ACC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 19:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7DE6B0088; Tue, 13 Oct 2026 15:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797E66B008A; Tue, 13 Oct 2026 15:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FA56B008C; Tue, 13 Oct 2026 15:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D01A6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:54:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16959C019D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:54:05 +0000 (UTC)
X-FDA: 85318654050.04.54DFABC
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BC7D100007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:54:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=irdtqI01;
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791921243;
	b=1uFnjomY3Ll68HNatqdqoW01jIdIFj5NvNYUdOXtlz+JRw+fJ0F+nopvBOtooUtxKhR8I0
	ARd2ZgnGvNqCKLDmhf+Iu5WwfNn7ZYHLF0ppXuKVVty7lmet5gt7zt60rnYAbH2lY6q5yZ
	gm52GOwaZUvBeNDGudcOdhGhwe+whgk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=irdtqI01;
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791921243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjiIk8S/1b/fq42ObdZjHlUOMsEJstLh+gvZY/xKhZA=;
	b=h/HTjzkLn+hgFhKblFhfgRTSrt74mbPY8VSj0/mSPZ37iZQZMOLs8I8/kBjYhkNB6JCrBu
	VVFCxu7zWWx3sEs4tjacIuNbKs00UDZsDki/Ti7CNs+107B5QGl8BkBYvRGeiZoo8Lsaw0
	trDak3fQVJ3o/WhlkXrH3c6tGzL/wtI=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91b83459526so25725026d6.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:54:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791921242; cv=none;
        d=google.com; s=arc-20260327;
        b=D2ik/9VJmiY31fnHP+wejI9DfdPw+WNM0lqISlK88VnA8dP0p6SM312rtW2PA61oCk
         SXGuE6Y0NSbiijmf2vOMV0CNkzK0LA3LRPyF1RQCGA71c+lMgG/w6/RxT/U7sibod1lm
         tbaB+r7CqTagMWRZ1NnrWHOQavNeETXb67YgDUAA0BEwO9o+gvv9YHhOQqJCXDQdN+KO
         NPXcFyNeFVjMPtIlOxpE/e2PFXh+GkLZuxcXFIeSbFcEQO3YBNhTJ2enUBqvu+jWHfun
         U7fUYWOIPaHy/VaxTns4VFglNtW8WM119BvXCIlwh32ViNU281pHLUkxRBzNcKVRDkFx
         dm/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=fjiIk8S/1b/fq42ObdZjHlUOMsEJstLh+gvZY/xKhZA=;
        fh=0Cr42VLDmGQ2R9wwfbIh6lMxD0tdimIf919NummJGhY=;
        b=RGFeERPIUw73w+NWWbo/daghSN2I35BEVq6CGWWpyWcfmQEHQ5k/MmS7bKWdluSPVi
         qhcuJEnAzkU4LP6uvJZsM4cFWzw9nLvsul8AJ/ePlynfGTDbTqlt5Dzhx0Hl3ZcvZLqA
         /PMBPX4qckzXYZneS/vJ4S8miNl8SzBmNyUFcOJA2VAey5BmASOkOFfJlaOOZaEtTCQx
         rZOXkNiKgEo6SS3sX86IpRbmw1hDsM7ChCx+q6CumYE2sDXdjgJurCiIILWe1mSqA7hh
         0w5TPQ3GvsehmkqzsKvVtnHueGIUKBDQoz5h5pMVXWVFNZ9E6ejty5RteRkSOo0jVewP
         bZqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791921242; x=1792526042; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fjiIk8S/1b/fq42ObdZjHlUOMsEJstLh+gvZY/xKhZA=;
        b=irdtqI015stJ0SDvDFJUs+D9PyixlNDrt3I+mA++Q7wvIhuNGXzl7XeiyGo3u6iYc7
         N63EVsYww6v9pSXm9DDGSp10N21Iv1lmiSsJpKN8YXa2umvtAwyKS9wi9Etj3AG3i91/
         B7MZ8Zke1vyAgr40neiQlxAdXnKCHocojlQKqN0jPxN3+H9BzlWjkFTxfcv0FlR9oBFO
         GaZZjAoYSJTIrQh80i7seEb8OWAcF+yE7XIsvbSTo+x9CtVQNWeSWq41PN13ADYu2fSX
         21NSuLNv8SxsJWKgGpoKzDlvPmbvcs1SEthsTbAeEPyvRarX/fyrZpWsy5+RIMTM6NvN
         NSzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791921242; x=1792526042;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fjiIk8S/1b/fq42ObdZjHlUOMsEJstLh+gvZY/xKhZA=;
        b=tIJkxruKqjSSto+827xxb0/rLHNWQ2BSkQnH7Dzb11KsYRJDgumjBpLB68Kck6PtL7
         M2rURx6ey+vz483PeeiFa/uNAjlIso59TM91dGkzeEgVxF3s5LDfozctqPU00/BodscQ
         +SvSIk8TUePlY+5Q5gMDWYd1Z+YpwUQnieMS9sWA1tr8PJqP3CY2rHl1MAOO+Oz1z40L
         SjVe1BeMkH+9qRgcxQOqEWSQCO7Xphmihd9ylnVm1tlJVy3A8DHsoyIRfKiXRwdzgCCf
         kowy0sXVTQ296MmwOat7HeSpdTWF6zlaBcp+u11+ekaiX4ZfbtUxFInmXqdiPzozMZd+
         b0Ow==
X-Forwarded-Encrypted: i=1; AKwUvBzeKB7i3PTDe76sxU9YfACuvHVlMoKstKVAdU2unlUkK9WEHDWmL8YyYhuFVHeTi1J3CI/nt0Ln0A==@kvack.org
X-Gm-Message-State: AFq9FYIYVRS8yx1juEGUTyzAKqTfAn2HG5CCEI4z2Ijd1KEhILR0M3Ok
	3Jac4YczmeOHjE1MCMvUptvWVyjA3Ha7O6cShKCG31jt+qU2Fq5HIgGd7wcxFdW2gz6bvtg1FTV
	L0iWmld81a30ObOuidIQ400ES5nKPW0ShTgkiIHo2
X-Gm-Gg: AYBFou0tgct0e+STdW9eoIdOMA0Ga35Mnm/WW/RjjT6sEJXqeRsFfW/hbn0tvU6BB9U
	hewiVBWOJwWfE29bZitNcGfzh8w/7plWCy56PV3zMuOh3vxIEezdGpbsTV5R+HMhMfLwHMBIMXo
	O71PL6khpphOzIivW9p05tg0mjlzvW0dbNbMX1l3Mr5rYg2dLNPhXk3mKsyQHpM0qlmz/i/2XVb
	pgGAhsqH43jguugSICKIVe5ZP8MgBoz95VLfxc3cMRX1u6hgyrcTKWQfW8pr0BJmnJx0URfJSww
	rd2BxE/4c0lybs0qJsPIqPxDKpXf7aKEhUap4JSJpPSmrGca8Lb1rlbSVSaub3Tov1iwAVKEZvQ
	5ohInqL0EnUyFn2EBRthecpVGBQVZxYgzwKmgxpEm6w==
X-Received: by 2002:a05:6214:5085:b0:90c:b843:d679 with SMTP id
 6a1803df08f44-91b555668b1mr241693526d6.29.1791921240685; Tue, 13 Oct 2026
 12:54:00 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 13 Oct 2026 12:53:59 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 13 Oct 2026 12:53:59 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com>
MIME-Version: 1.0
Date: Tue, 13 Oct 2026 12:53:59 -0700
X-Gm-Features: AclHuK8TQPboa9RVDrBS_-w6dTXGHf21nXTRvYl_CuU35T-tn195uLjZFRceV3k
Message-ID: <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, aik@amd.com, 
	jacob.pan@linux.microsoft.com, gourry@gourry.net, vannapurve@google.com, 
	fvdl@google.com, tabba@google.com, dave.jiang@intel.com, 
	aneesh.kumar@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0BC7D100007
X-Stat-Signature: jydger6msb9b3efrk61uxadctz733m7q
X-HE-Tag: 1791921242-249819
X-HE-Meta: U2FsdGVkX192zQxLB6S1QaKRFYv8c+lfNr1c7XQiZNqxOFVrW1NYXICArguO0aLb63aNf9KVKf8n1WMNjifjIe4J4OPiXceE8mZmzxVL6ystO5HqxMbzqC/koybk/MlltDwAhf7HPaeWE/KTNFb6jYkAkNzywu3yMYlw+nUVDb/iVriF4GFn7N31cLYbUbkHItu0kk7RpsjFN2fCFo4UtFwiCXJsX86wunygFiftO5VeHzdQyvUd+PgpOBNoTKsetcTOmvqF469+fyaDtgfRURUr3DPvxnH1WgJ+EW4FcvPa+JIuNlnh/CYBe7TMHL6yjIYtpEEsojwRC8nBQ5o7OQ4UU+9WlBpre+W1TgviNW4iKpONrYa7yFFhNole44yPNa4yzcNS/tYSDthaG0WyE8aGPmPgyGoI7kuZWD0cxQYziLQTcfVYkQ5BQ1NqDmCGv3sBCMvci7yEafUujowT7GFc1bS74ct9kf5FV8+b7//LxUSXtTYsvvZwwhGe3zStqHBBfa/LiZ6bH54xSJQLJNQyEnRq1gvH/zpsZui+dJkhtyvM7LRg5mmZSkOckmonW7Z1AZU7KkY6rjZgKfi9BpJlY1tTAfihGncIoI0PP3JX7OxaX4zqVP3K1Ubn0GlYnnoMwEq9G3DoenF+Dt9hLVEvLbMAe5ZBCKshhy3GX/FRU6xvpVJIPb11guzZLUUx+iYc74ofhe5JLc1Fh9JULd0ZdySCCnrnffbZSPR1GfmRpedBrB8JaAF++Fql3VozUhirOOk7P8wjtsKHyObDEo9k0+d/fX1Z9vPIHOTJCTro6nNT1C0vepfyFCEDX6GQMmEcS3zBpE+7tS0PtUz22Hj2eyJeMyI01uCyHEQQp0vdInVWcnNP34GIE3GlDGK4d7XvXg9nVCFfxhZy0cAB6uCUgIuqbkHtFjWZa4zd6bcNZtSOjeBgRODttNv/PFd15/vgMc8PxLwW5CLw9Zm
 WoPwJAz4
 FsJRDfEgeyKfibZFH3kuTrGkVxW5zk3GL2ZpSQLcG2sk9r09PeN+Ll1dSOwc9rlv8yzTl9/wUFR/3sTkrmzd2OrDPYsaXxk4hQrwfESBkZ+WrM2NVD6ifM940h4Ntr20ucz/AWgglsom4001YXD58fxRFpi7sF3GykeY8rtodgH9mLLdp/PbsUgi6ndk2y3ywOaqTOAYjYy2hp78VkJiTrYwax9v3TMlrClx+iRmnOLhsMXcqYmj/tFL9CQcIYFFCpaKH/QMVUOjVf5WeR/HhGRAhtDYlLmN2rPZrgwFF1xwBMX40yT2M9R2sN9pjpJ40V7x/TtOLw9Wbb0Q4djGRwuKNEoQQJ/MuwNeOAkxeQBEXyJH3blegzPLMBl3TTinVdniPVx96xzQlTm+yUjdG5Lt7sCFKUmPrshW7oL7qzppe40IllmXu62OIS7hr+YRTmKjL15Gf60aEfC5/Qlw/MPoyHFO7MeJU5Nnmsa5WdOHejWNDUDrs8SZijMDsNNJi+iqb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey David/Fred,

I took some time to read the patches, hope I got everything :) The
biggest difference between your approach and mine is who (provider or
guest_memfd) manages the zapping across all the users.

The memory users here are

1. [KVM] The guest (KVM manages the stage 2 page tables)
2. [IOMMU] The IOMMU (iommufd manages the stage 2 page tables)
3. [USERSPACE] Host userspace (guest_memfd handles faults, I guess you
   could say core mm manages host userspace page tables)
4. [DIRECTMAP] Kernel direct map. Your provider already provides PFNs
   that are presumably not in the direct map. For other providers, the
   direct map is another mapping that may need to be zapped on
   private/shared conversions. (Listing this here for completeness, I
   think this should be tackled separately.)

I'll use [LABEL] to illustrate the way notifications flow in your
approach vs mine.

When the provider wants to revoke the page, the notifications/function
calls flow this way, the last [ENTITY] in the chain actually does the
zapping.

+ [PROVIDER] -> [KVM]
+ [PROVIDER] -> [DMABUF] -> [IOMMU]
+ [PROVIDER] -> [GUEST_MEMFD] -> [USERSPACE] (AFAICT this was not
  implemented in the RFC.)

That's when the provider wants to revoke the page. IIUC guest_memfd
conversions was not illustrated in the RFC: what happens on a shared
-> private conversion?

+ [KVM]: Zap only shared pages, keep private pages mapped.
+ [IOMMU]:
    + Before Confidential IO: so far, IOMMU mappings are mapped
      indirectly via [USERSPACE] mappings. guest_memfd zaps
      [USERSPACE] mappings, then checks refcounts to ensure no other
      mappings (which includes IOMMU). See __kvm_gmem_set_attributes()
      on kvm-x86/coco [2].
    + With Confidential IO: shared IOMMU mapping need to be zapped,
      keep mappings of private pages.
+ [USERSPACE]: Zap all mappings on shared->private conversions.
+ [DIRECTMAP]: Can zap these mappings (not implemented yet, but
  discussed in the context of Direct Map Removal support for
  guest_memfd [3])

To have the conversions work, in your model, we'd need to do

+ [GUEST_MEMFD] -> [PROVIDER] -> [KVM] (zap only shared pages)
+ [GUEST_MEMFD] -> [PROVIDER] -> [DMABUF] -> [IOMMU] (zap only shared pages)
+ [GUEST_MEMFD] -> [USERSPACE] (IIUC the provider doesn't directly
  allow mapping to userspace, also in your approach the provider
  pretty much replaces all the innards of guest_memfd anyway, hence
  I'm showing this as gmem going direct to zap userspace)

With my proposal [1], we could do

+ [GUEST_MEMFD] -> [KVM] (zap only shared pages, implemented in [2])
+ [GUEST_MEMFD] -> [IOMMU] (zap only shared pages)
+ [GUEST_MEMFD] -> [USERSPACE] (implemented in [2])
+ [GUEST_MEMFD] -> [DIRECTMAP] (future)

In my proposal, I agree with you completely that the provider must be
allowed to revoke memory. Using the sample in this RFC, gmem_fd_ioctl()
called with !GMEM_PROVIDER_SET_PRESENT is where the provider wants to
revoke memory, and the revocation in my model would look like

  [PROVIDER] -> [GUEST_MEMFD]

and [GUEST_MEMFD] would then fan it out to [KVM], [IOMMU], [USERSPACE]
and [DIRECTMAP].

The [GUEST_MEMFD] -> [IOMMU] is missing from my proposal because I was
seeing that as a separate patch series. I think what we want is to have
IOMMU_IOAS_MAP_FILE be able to accept a guest_memfd file. Currently,
during the mapping process(), memfd_pin_folios() is used, which has this
check

	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
		return -EINVAL;

that disqualifies guest_memfd. Refcounting won't work for guest_memfd()
folios because of conversions (see kvm_gmem_has_outstanding_references
at [4]). The implementation I have in mind is to have the the iommufd
instance be tracked in guest_memfd during the pinning process, and
that's the pointer guest_memfd will use to get iommufd to zap during
[GUEST_MEMFD] -> [IOMMU]. This [GUEST_MEMFD] -> [IOMMU] zapping was
previously also proposed in the context of Confidential IO [5].

[1] https://lore.kernel.org/all/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com/
[2] https://github.com/kvm-x86/linux/blob/a6270ed4bec0caa25913082e71ce22254e9cd3ed/virt/kvm/guest_memfd.c#L685
[3] https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/
[4] https://github.com/kvm-x86/linux/blob/a6270ed4bec0caa25913082e71ce22254e9cd3ed/virt/kvm/guest_memfd.c#L722
[5] https://lore.kernel.org/all/20260225075211.3353194-1-aik@amd.com/

I'm intentionally avoiding the "primary manager" terminology since
that's overly broad and doesn't really explain what processes exactly
are being managed. It's really just which entity tells which other
entity to zap pages, and since shared/private-ness of memory is core to
guest_memfd, I think guest_memfd is in the best position to tell all the
other entities to zap, and what (shared/private to zap).

Does your provider need to know if some memory was transitioned between
shared/private states? The provider can be notified too, if
necessary. If not, then isn't guest_memfd doing all the coordination
better than going via the provider?

Does the revocation model work for you? If it helps, I can rebuild the
sample provider to illustrate how the revocation can be done. Let me
know what else is missing from my model [1]. :)

