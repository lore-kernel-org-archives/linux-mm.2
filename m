Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CEDAC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B8F6B0088; Fri, 10 Jul 2026 08:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CE26B009F; Fri, 10 Jul 2026 08:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4B96B00A0; Fri, 10 Jul 2026 08:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02CDA6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:02:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 780FDA0430
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:02:13 +0000 (UTC)
X-FDA: 84972728946.14.EA066A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C0BFA40025
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:02:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=guCeLf94;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PP3VC/37RzTAGWL7k/+I+tmeLylhrGIoDnWfhyG+Q0c=;
	b=FjeD3n1QLyC6cXXos2BW7QPfyoikGxxK1nD1Kzc+xD5NRieA/EoWN7MTg8gU7dznVfOuOh
	l3Z62mt3l1pS6Kh/0tV62kUkga6fyHGQn75xU8fVEeko9mZWWhEC2ZIuenGpqxDyioyVpG
	bfMmFI6xSiHZJ+9/L1MmsWcmLgEuhCg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=guCeLf94;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684931;
	b=S2ONC1r9MSyDnDYbwrlXg8iH7qCWop7h/jUJkPvtuda71ZNXwuY8483jteP1/k41xFn2VY
	dXGLndugWUOZuFA0QSLIxvduOgJw+0otHKW7UTc83LPdHzjcR2+YQQv/uktiViZz+KVo5L
	kjpmGmu8WQPHa6jPPANxNcog0NH4FxY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E21EE40464;
	Fri, 10 Jul 2026 12:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E3C1F000E9;
	Fri, 10 Jul 2026 12:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783684930;
	bh=PP3VC/37RzTAGWL7k/+I+tmeLylhrGIoDnWfhyG+Q0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=guCeLf94Bg9R/kH/GNwmitbcZ9pnDfuV2KrvtxKoIIzqP/+DoqIomIHeCNsbYF3ro
	 qKp3wQ5pxTpNyQYt1whiGSQ+yjFoChrqoYDZObx4xLdK4ZH6Zwl7sUjBa8SAOvvB8o
	 GkHN6O/EYamKycKyvIzCvz09r4rK1kRkytWrj9fPaoXO291aq3SAbD9htWsQC9qF8e
	 ilfy9Xj+IlsOiuZVK0DPpJ8QkdGDUAgF/wBdnF4J6fAy8Z4xJ6RNSl3i0X8WCd31XK
	 /Da0mhyQ43cK8N+cdPKBY2//YItjHgz/aN9i+KbDo2RNaPiJvpPn658lyyQFV8rUJq
	 4wb+jt6MWPqQQ==
Date: Fri, 10 Jul 2026 13:01:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Takahiro Itazuri <itazur@amazon.com>, fvdl@google.com, 
	Liam.Howlett@oracle.com, agordeev@linux.ibm.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, alex@ghiti.fr, andrii@kernel.org, aou@eecs.berkeley.edu, 
	ast@kernel.org, baolu.lu@linux.intel.com, bp@alien8.de, chenhuacai@kernel.org, 
	corbet@lwn.net, coxu@redhat.com, daniel@iogearbox.net, 
	dave.hansen@linux.intel.com, david@kernel.org, derekmn@amazon.com, dev.jain@arm.com, 
	eddyz87@gmail.com, gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, 
	haoluo@google.com, hca@linux.ibm.com, hpa@zytor.com, itazur@amazon.co.uk, 
	jackabt@amazon.co.uk, jackmanb@google.com, jannh@google.com, jgg@ziepe.ca, 
	jgross@suse.com, jhubbard@nvidia.com, jiayuan.chen@shopee.com, 
	jmattson@google.com, joey.gouly@arm.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	jthoughton@google.com, kpsingh@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	lenb@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, luto@kernel.org, maobibo@loongson.cn, martin.lau@linux.dev, 
	maz@kernel.org, mhocko@suse.com, mingo@redhat.com, mlevitsk@redhat.com, 
	nikita.kalyazin@linux.dev, oupton@kernel.org, palmer@dabbelt.com, patrick.roy@linux.dev, 
	pavel@kernel.org, pbonzini@redhat.com, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, pjw@kernel.org, prsampat@amd.com, rafael@kernel.org, 
	riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, sdf@fomichev.me, 
	shijie@os.amperecomputing.com, skhan@linuxfoundation.org, song@kernel.org, surenb@google.com, 
	suzuki.poulose@arm.com, svens@linux.ibm.com, tabba@google.com, tglx@kernel.org, 
	thuth@redhat.com, urezki@gmail.com, vannapurve@google.com, vbabka@kernel.org, 
	will@kernel.org, willy@infradead.org, wu.fei9@sanechips.com.cn, x86@kernel.org, 
	yang@os.amperecomputing.com, yangyicong@hisilicon.com, yonghong.song@linux.dev, 
	yosry@kernel.org, yu-cheng.yu@intel.com, yuzenghui@huawei.com, 
	zhengqi.arch@bytedance.com, zulinx86@gmai.com
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <alDe8fpxdafnfuqb@lucifer>
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
 <20260508081812.12345-1-itazur@amazon.com>
 <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com>
 <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev>
 <akw1lZDEv8_Ub1zQ@google.com>
 <DJURGJEHZHFY.3SINJIME8E9RB@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJURGJEHZHFY.3SINJIME8E9RB@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0BFA40025
X-Stat-Signature: cptudf3qakrkd86wwxwktr77s6t39o8z
X-HE-Tag: 1783684931-547779
X-HE-Meta: U2FsdGVkX1/TasGdjPrIB86uaDPVuT2s+26ZouFewjYCTBDDQAq2RalzlSjEOKH2ahFHiwCAfIiG4CMcGlzLtS8H+WJH1ryyOVjVzpJCL5ejEpMRMCpOEoZRWIws1AUrwvMjv3XI4UqbscIOoHByhOE7Y458hQxsH+9car0ZmmvsRYqQy/YEW4/0jIiudBgCRm73M+a92joSxj3HTNVtdde3/t1ZHAMkO5HpeAI4r3dcH5Rkp2rgmjorNge6v1lpr42qteBmBVQ2q7Ekk9nWp/Ox12nFUgvp98rkq2hhnXSLOUkPASHjGGUmnneEAHnhr4cGysMi8Gdoshc6xMV6G/oryKAwT5uMEE4ny0jUUStTjS2DGV78eQmJ0dzPkEJwGsc9PmI/8jeoKENedPJaf5RGQzFXsvQosAv5myHdyTfTbDYlMAYpvzp4hDHzXf2ZdDfwwrK8p5VgOhkXlO7pa1oQLOLhjVWwEac2t3n1Aczh6WFRUAgBKvcerzpKEdf5P3AULcFhTbOLtQJN6kJzI3FzXg7x6OpaLN6l2qULkCZNpVsKzqD0Bj/Q4WOqabXvUrQ+zvpFJZeBd2lmVs6rjONGalJ37Dru8i8PGsP2vfe2xvvQ+kOaFHF+FbEf9XUkI19XIOH9q+lMqBBZgXwXcJf7rw5hbjfsb9Nwj+IGfEhtSm7ednzTHoSTRnJgtgk7gYu0DP3KeQo1pKlCuMjOw2CE5lXmc0+BGXlPiQINwdCk/eGkXZ9kOs1V55zyM/qz+nhm2kYr16/bi+4hFcOS8BkhMOJ1b2lOeBZ4NRg8fs6AnmqbpuFh8RQrvVmXgG94e2ck7Cc6CVp8/t/8KteDM6Bhxj/8x/oMXH2SJE+zYmX9vooHR9YhrVIll6bPkkGJKrPG3wnyzsMyX7RAINjmzzjC9kx4ezQB/qwjV6ITgCwV4NfxGGDH7MgsI0p19e6jj0M1P4dvlkZQIOD10R1
 wvxdesc4
 Yafwk5qZIk/EzA/1Hdh7VesNdOpFgdDfSjmYRg7V+sv+k2iAMVnpvl9bAtUmpt4XBgGQKP3NR6C5twhuH0vP5wmmHJQmua9EbmMVYNuUqcAtdyKauV5Nd7oMeP3B7DINdayeG2Y6Wimy9M1Ycdl6uZqxg69VF/4PqdEZgkFWzQfSCGfV28lraIVOwsFeByeCCOiUd9gSGr8U5T05m77yeGWGwZ/T9d1xRHVgiEYtaPVIq48r6EVkMqa9emIIEZPpVdVeRRtISVkXpRRVwFgnogSnkFufy8VuRN5YmiCvS+b+ATjimg92yD1/JitRXUQIoGu78yFsqXmsYQ4PHGoQOmN021PgrtwJ5TwceJTVg4G0wGV2jgcT6dB/7dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 08:50:25AM +0000, Brendan Jackman wrote:
> On Mon Jul 6, 2026 at 11:09 PM UTC, Sean Christopherson wrote:
> > On Fri, Jul 03, 2026, Brendan Jackman wrote:
> >> There are also the fault paths though; if the pages are nonpresent in
> >> the direct map for the duration of their life in the page cache (and I
> >> think they should be) then by the time we get to
> >> kvm_mmu_faultin_pfn_gmem() or kvm_gmem_fault_user_mapping() we lost the
> >> ability to zero them.
> >>
> >> My original answer for this was "that's fine, we'll use __GFP_ZERO
> >> (which will probably use the mermap under the hood)", but now I've
> >> realised there's a good reason we don't set __GFP_ZERO at the moment,
> >> namely that it's wasted if we end up doing kvm_gmem_populate()
> >
> > Eh, don't worry about the wasted cycles for populate().  The overhead of zeroing
> > a page is dwarfed by the overhead of adding (and in most cases, measuring) the
> > page.
> >
> > We (KVM folks) discussed this in the context of in-place conversions, and long
> > story short, the consensus is that shaving cycles by eliding the zeroing in the
> > host isn't worth the complexity.
>
> OK thanks, this is useful. Nonetheless because it leads to a less
> confusing dishgn, I think it still makes sense to just disallow
> __GFP_ZERO for the unmapped pages.
>
> (At least, at the page allocator level. We might want to allow it in
> address_space.gfp_mask or something and have filemap.c deal with it.
> But, overloading a GFP flag like this is yucky, if we need a flag for
> that I think it's likely neater to make it an AS_ flag or something).
>
> >> (Continued below...)
> >>
> >> > I'm a little bit uncomfortable this statement since it seems to say TDX
> >> > and SNP aren't taken care of. Would just like to discuss (for
> >> > a line of sight to SNP and TDX support):
> >>
> >> Are you saying we need NO_DIRECT_MAP support for TDX/SNP? I think that
> >> would be doable but what's the value?
> >
> > Hardening against consumption of shared memory?  Yes, the guest has explicitly
> > shared the memory so there are (very) reduced expectations around confidentiality
> > and integrity, but defense in depth and all that.
>
> Ah yeah, it did not occur to me that there was memory being set up via
> CoCo paths that is not encrypted. So yeah that makes perfect sense.
> Eventually we'll want to be able to lean on this to protect that shared
> memory against attacks by other VMs etc.
>
> > For me, the main thing is that I don't want to completely punt on the interaction
> > of the two things, and end up with an unworkable mess if there's ever a strong
> > reason for CoCo VMs to support NO_DIRECT_MAP.
>
> Yeah that makes sense.
>
> >> So that we can get a #PF instead of #MCE if we screw up?
> >
> > Note, SNP gets a #PF either way.
> >
> >> NOW, the thing I'm stuck on (again lol) is the patchset-fu. Here's all
> >> the parts we need, with dependencies indented:
> >>
> >> 0. efficient GUEST_MEMFD_FLAG_NO_DIRECT_MAP
> >>   1. AS_NO_DIRECT_MAP
> >>     2. ALLOC_UNMAPPED (formerly known as __GFP_UNMAPPED)
> >>       3. alloc_flags arg to the page allocator (I'm sneakily introducing this
> >>          in [1])
> >>       4. freetype_t
> >>   5. The mermap
> >>     6. The mm-local region
> >>
> >> I originally posted all of those in [0], except part 3. Doing all of
> >> that together in one series would be a bit too much though. Approaches I
> >> can see to avoid that:
> >>
> >> Approach X:
> >> - Do parts 1, 2 and 4 as a standalone series. The only beneficiary of
> >>   AS_NO_DIRECT_MAP would be secretmem.
> >> - Then another series that fills in 0, 5 and 6.
> >>
> >> Approach Y:
> >> - One series that does parts 0, 1, 5, and 6. AS_NO_DIRECT_MAP is
> >>   implemented by having filemap.c itself call folio_zap_direct_map(),
> >>   then guest_memfd.c zeroes it via the mermap. It works but it's really
> >>   slow.
> >> - Then another series that fills in parts 2 and 4, switches filemap.c
> >>   over from manual folio_zap_direct_map() to ALLOC_UNMAPPED, making
> >>   things fast.
> >>
> >> Approach X seems natural from a code progression perspective but leaves
> >> us with an interim phase where we have a bunch of complexity just to
> >> "optimise secretmem" which nobody cares about.
> >>
> >> Approach Y seems natural from a feature progression perspective but
> >> leaves us with an interim phase where we expensively zap a page, only to
> >> then immediately do this complex mermap dance to access it right
> >> afterwards.
> >>
> >> Any thoughts / other ideas? Personally I think I prefer X.
> >
> > I don't have preference between those options, mostly because I don't appreciate
> > the difference.  My overarching preference is to separate the mm/ work from the
> > guest_memfd as much as possible.  Beyond that, I probably don't care all that much?
>
> Cool thanks, shrugs are fine here.
>
> Main thing I'm trying to do here is generate some awareness that the
> decision is being made, so that I don't forge ahead with X and then have
> people going "ugh, why haven't you considered Y?" If nobody cares either
> way then nothing to worry about.

X seems fine to me and that seems to be the consensus here. And it seems moot if
Y relies upon mm stable branches which are not here yet :)

Cheers, Lorenzo

