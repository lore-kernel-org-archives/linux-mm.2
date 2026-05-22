Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA156CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C246B0093; Fri, 22 May 2026 09:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC806B0095; Fri, 22 May 2026 09:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5BA6B0096; Fri, 22 May 2026 09:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 064776B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:09:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8267940456
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:09:02 +0000 (UTC)
X-FDA: 84795086124.09.3F13D4C
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id B89EB140014
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:09:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZPdBt5En;
	spf=pass (imf09.hostedemail.com: domain of 3alUQagYKCK0fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3alUQagYKCK0fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455340; a=rsa-sha256;
	cv=none;
	b=MzDRxB8Q13kF+b7Q6gkApfkTECe/Y2ivl46Ar1Ikr0qDrCdXKSMGtEqdQ4V6g/GNIognc/
	8rS7F2gPhmOorWZVcV01rBhQ7SWZg816HUHOf7fTbveO94ssKlB/5MW2+kr83fmDYNiBVV
	uqsyxxVNgl23559d3En5fu4NYKCPlDE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZPdBt5En;
	spf=pass (imf09.hostedemail.com: domain of 3alUQagYKCK0fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3alUQagYKCK0fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWpFds4KLS7xuznWHwB8ePqzzdmaeh02IGD1amL7VKc=;
	b=FdwVtbT/arTfO8uM18LniFz4x3eq51doOP/7ic+IlZqAtF4Trj3D+XEptmzIqrMoY3QRqF
	hwZuYgEsBpnhVtzFNGdXFWaps57fqZCwG9QsB4z7WryAxoQ8uc4vTaxe6RMAcFlcvsGo1t
	9jg6/Nn5ZOa37vvUF6AViSVVLuwc0k8=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b99eb06178so173059675ad.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 06:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779455339; x=1780060139; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LWpFds4KLS7xuznWHwB8ePqzzdmaeh02IGD1amL7VKc=;
        b=ZPdBt5EnDBl/w2GHyZKm3lc/bVIFqiQxhkrvBjjOX3pbFBzJKGeoRrsntEwh4UfH4G
         udU50eYFH6hsQ+VyKPR6eEI/qCkK0Ue3oTOd6RaGvxtSWJxYU6qmt3X8mbXv/QamdNUh
         xqKWzZQVCykfQ9vTXctXFjgkbA978oqmf0g0HC3TETWKG42wfWPjY0wXZI1k2tO65LeV
         zj+w7pUnBf6ID5HugHqtQaj4RbbHQ0Nx4qKuNHr9TtSo7fNPT7UUAtjJmZwy5le2lRJR
         QKmPnZfTty4ub7CRlhSIuwtETtJBNt/6rrO3LFjySjeK0UvK8vpj+Ekh5HxmiDaMEufC
         kRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779455339; x=1780060139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWpFds4KLS7xuznWHwB8ePqzzdmaeh02IGD1amL7VKc=;
        b=FSU/+DHJXeL4/uIY1+kO79yNHM2SobQ4F4z+Q6z/hzhrhE/qwum3yzIYNFQZ2MLnki
         skxC/eU6BSeVMQmY8YaRY7tjqYF30YACNBiXQh4CjHWDUDR41/28s1Hm7XI3sg4baC0g
         jg4NS4PznqexFz3bAWn0n4+UVp88awwlD98xCAKeprfjB6EM+IQFluOw0jYswEtj2oMU
         rFoHy24WISTqz1JE9qp9XgAb426UKtm7rWd7/HwS5/BFnizUCXEkQk3+W69A4PQ33pSU
         eYiulknnFQSbkhh0u51FgzqS3EHyFv5iFuUl2pbqV7pJj9QpqZH2T3QbDUXgRwnTYAMn
         +WJw==
X-Forwarded-Encrypted: i=1; AFNElJ/JhNJO3cIfKuPLLcdUHjwfHirDZsnjga6IuAyyR8OuJpArRRldh3bYM7lj1tx6S5p9+vwL6ZwwPw==@kvack.org
X-Gm-Message-State: AOJu0YxMVHvXslLsdeygiBonf0CIwEj7ai+DitheCPM2GH/bGR1v/HTp
	5I7JdARsY8oV1w5TNaRhb9nM18wnuowN1Tp/dTVZ5H5QB7J2z2zdos6i2PCNZThAb7s8d4ZQplF
	F1xv2ww==
X-Received: from pllk9.prod.google.com ([2002:a17:902:7609:b0:2b4:5bcc:fc4a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1246:b0:2bc:90b6:3e6f
 with SMTP id d9443c01a7336-2beb0347191mr37692105ad.4.1779455338970; Fri, 22
 May 2026 06:08:58 -0700 (PDT)
Date: Fri, 22 May 2026 06:08:58 -0700
In-Reply-To: <CAEvNRgFB8ydih9JTmsH06H32j38tH-iViZqN_eZ_gQAmXpw+Dw@mail.gmail.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-21-91ab5a8b19a4@google.com>
 <CA+EHjTwrygfMrZZSw4y7-ry8fidW2x0C7iuF2Q=dnPNHUmNtUg@mail.gmail.com>
 <ag8G7Wq5PbEdKloG@google.com> <CAEvNRgFB8ydih9JTmsH06H32j38tH-iViZqN_eZ_gQAmXpw+Dw@mail.gmail.com>
Message-ID: <ahBVajalNaHkNYdV@google.com>
Subject: Re: [PATCH v6 21/43] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: B89EB140014
X-Rspamd-Server: rspam03
X-Stat-Signature: bh3ew1rym3bbgusfn3yrzqjnmupjnxuf
X-HE-Tag: 1779455340-370854
X-HE-Meta: U2FsdGVkX19wtJSh1NewidxOwQc6eCStLqTmBCpC/6wrg4B8buIQf252Q/DypX39oZINJJcUJ9cpV+4ZmBGrWXs/OVFBXa0eW6xQlFJ9kro3psop+1fAU7DRMBgjaT5v0QMPrLNzUwoQYCG3xzAy2SZmPfNnoHLPSNegUJKZg0TDBrxc6RQNVmLkrYiITYWv0QlZJAuEx+i4qkFa/ZI3Im6FBrpHVCuT1tZE+IJShnhL9thyGB5QnEQovFFj2dCTDwYAv41QOPc4HesctTJvOO4T2438hRYvFKDa99239+wL/GCnxfBkxCU6H6i+nWFXm4UMr6qyUUnSytO8iY0Jqd4oPdqNda+jObxXeWwRZ7KfJBDDr/CWcXbXA1SBiWzmJvGoQhhX9Nhx/KMak23rt4mjdpOZx/D033GHCAlJyWJhDZNJ8crh4v7GNINsYr2uWaUroWQLe2f7acGogP7YlRRqIta8lyoNdBB3r8wmdG3dZmJZaKNETL/bmcNGeztCnPXl5/RshzkIcN1vOxbQ89bUiDXEgQmrEYK9DJoBk50iDsl1qQ5rtCWV5Jf/lKZyDIjg1KLolu+WPLayb8s57yyl35UbhSKQi968CC2/BEcHt8fsAati9LCClGLBrwcoLA3BnMwgVFmnw44eeSNrUceLEEA5/biBLHgIhW3IiKi1pq25cbEDwvfmJiqlXnLHUI/LdsVF2kDmpPycN+BC6Z123O3P7xaeeDjN4iVx5kpwvkQwd4aTrcsec3rO0mpysjzmwGA9gVNO9ogUjiI+2mRja9AYW0F/P5bHj60lxH0h9XUbAI57aizkk38yGPSCBwxsujI6fkb7EGATjzw8XImctloQ+5OKWD9WmuEIGZmHVyxVth4p/jzNRL1jj6w8S31DlxRgTTZXf58e3+zMzXXczY3J1t6am5DZfT7BFRi7SrnmiKrxi6psd594Mj3MFvaHb3WXOSB4dh9Kdxl
 ZE0WmJxt
 4MbhTbge6Rcn/tf2htQsuJcQcI1YC2c5RDRO0jFVZOTEa0UyBZ8e+OS3bXPOjfbbs0kOWUrL+d9z5SsRKDG+tECGycBm59RzeVCmUveSX1TmLybNpap7LUReYUU4oO7157ffdvpwt6oeyRLnEDxpeVQdkdmRA2ALWtjfYRbh/0GiTC94eFB7axX0e5Fvkro3/ebV5/1u4KOpSw7tPMLn8LUTORQaHfa6QNXdNHqtUDC3doF6hziFk29cyFp4WKZnlGt5CuWv4F8rdf4E5Ts4acVMyHGIbpJKTW71VBqWJgN0dQL8sQuo2khSWr+3TAVSUKJuiUOjeayJ0fB0V2+WUmGxKWLABAVuA3460s7aVZlDMucmk21Pspr9a1vBkpwzZl7khvWlJj1QIj1S6l9njvRRmXVT6aFiwz7qAawMoYfS+81VCU8HOfBKg55B6T0AtIiIJ6Du0Jobwl2vsyXm8TDHRT/W7uWboV5AxC0JuabDFBMZ7baf0GTjDUjNKpzZeLFi72PWdnAFYxpdwTCAED/5eil5RD12aDDas+F1yg2mzWmgE8so1eD5W6hOCJraKR2ov20dN0vdsFU6Glqiw2+GthwTSBw3iTpkxV63FhUxckvrbETNrR1wC0QilWrS7AQt6WbkjsIX/TgTvYnC2WQAII2tV9qOhW0/wS5KsZkeIXouVts9+LZoHwfEVBdQwJJvG9ewDRXzcklQK65TFSciOpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, May 21, 2026, Fuad Tabba wrote:
> >> Hi,
> >>
> >> On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
> > diff --git include/linux/kvm_host.h include/linux/kvm_host.h
> > index 61a3430957f2..b83cda2870ba 100644
> > --- include/linux/kvm_host.h
> > +++ include/linux/kvm_host.h
> > @@ -2596,7 +2596,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
> >  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >                                     struct page *page, void *opaque);
> >
> > -long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> > +long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
> > +                      long npages, bool writable,
> 
> What do you think of need_writable_src instead of just writable for the
> variable name?

How about "may_write_src" or "may_writeback_src"?

> >                        kvm_gmem_populate_cb post_populate, void *opaque);
> >  #endif
> >
> > diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
> > index a35a55571a2d..6553d4e032ce 100644
> > --- virt/kvm/guest_memfd.c
> > +++ virt/kvm/guest_memfd.c
> > @@ -858,7 +858,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> >         return ret;
> >  }
> >
> > -long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> > +long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
> > +                      long npages, bool writable,
> >                        kvm_gmem_populate_cb post_populate, void *opaque)
> >  {
> >         struct kvm_memory_slot *slot;
> > @@ -892,8 +893,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >
> >                 if (src) {
> >                         unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
> > +                       unsigned int flags = writable ? FOLL_WRITE : 0;
> 
> How about using FOLL_WRITE | FOLL_NOFAULT so if it weren't writable to
> start with, don't CoW, just error out?

Eh, I don't see any value in value in erroring out if userspace is doing something
unusual.  If breaking CoW was actually problematic somehow, then sure.  But AFAICT
it's overall harmless.

> Like you said above the CPUID page provided as src_page would have been
> written to before, so it should have been mapped as writable.

