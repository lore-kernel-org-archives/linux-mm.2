Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33FB3CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B848E008B; Wed, 17 Sep 2025 19:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552C68E006B; Wed, 17 Sep 2025 19:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4900C8E008B; Wed, 17 Sep 2025 19:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 392828E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:05:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C39B0871FA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:05:02 +0000 (UTC)
X-FDA: 83900274444.29.75F5696
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id DB1671A0009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:05:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1bu1QqEt;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758150300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVacp95PmJEGvpJOGbUdRRUCnkNBzPvT5lvXym+9x6g=;
	b=v0DXOa12F/3iw2E6dL1n7ReIsTokDCHC2PR2xXXmj7EmEd97zc8iXF9pNn+XrojFP3Kywt
	/J2wRK83IM834rcHAnb2MdZyH/G7cz0H+rqEZfa8V5KnaWeIRTBlQMHH73rkr21eHONk+M
	Rb5MQzol/uQ/eCGSZ5c8VAEqFLiROSA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1bu1QqEt;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758150300; a=rsa-sha256;
	cv=none;
	b=fxz84+UDJSA3qfbl3sCpd3oDw072gEW+mLYBfgxvD9m2Puv8lpdh+31I/H12RAs5yMQIxw
	D+/NvJoKeaWYXNgMCkP8COszrKSyXvJpT3zPyr4m5J/pE0MV0XF+IcnD89oyHMxpYUCzE8
	yejiJRPQqRm7J1tQL5Xd1YjPUiEJAug=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b796ff6d45so100361cf.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758150300; x=1758755100; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVacp95PmJEGvpJOGbUdRRUCnkNBzPvT5lvXym+9x6g=;
        b=1bu1QqEtHKSdfOVkx8Ewldm7gKMFmK7F+v1Yip19XkOxFB/PXXDkCIIDttlChEdGji
         grUy9G55GZvg7+Fb64etObIQUBbI21JIM2mNmIocEmETiqYilPMqWG3YvfS0D3KvIkee
         MC47haFWtqVHaihDBsQkdPAnmKhT3Ad1ntR39N/42+onboFWaKnDWsIMtY9oqEfgKFSO
         WPggRgf5ZkT+vpg6M7SzTCmG71McIOPPBU11h9GEvmPwgVomnvJEVl7NDhKPHyVKSRLa
         /guOwLty/LNRPRSRxKdcqU+o9kdlGOLKK6N3n0eELj5t+xP+Nr5fg6coW07kfH7tUIae
         SV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758150300; x=1758755100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dVacp95PmJEGvpJOGbUdRRUCnkNBzPvT5lvXym+9x6g=;
        b=EX9dwXohloMnN6ixgQ9IhLZP+gxUoPjXps3PanY/VOtG7FNxOHvKMqlLCQGG+g9JsL
         54lRLq+UslQVKGlwTiUPEQVD54zZUV+PwFCe4O/Rc4b/0lLeup8NnH8NBr1+AdBYgd6M
         /NuUMDmSxYtzTf4ruWumZvvq7ehaznF0bb7OS/UA/VGRWRpQE9KwLrHIg/SYdtW6i8EA
         52DjLnJlKOZdx3Xv9qxI6hkBSWgm43OOscVkA9/QZ5h+Y++ooTFQsXz0GoRChbkObztc
         3G9u43E0Vc9AD9xl8TIyObW6g9VYwyBy7bvRdGX7tNV+cpcPlm+qpgI5a8pn1UE2Lrlx
         3pPw==
X-Forwarded-Encrypted: i=1; AJvYcCXt4iTC6p3dibn0T4J3bJNVfTVUZ5CXnSaeCLG39jZfSKoa9M/9a38sWiUBewUq7iKuxeQB9jyF5g==@kvack.org
X-Gm-Message-State: AOJu0YwhnoFlhWCBckccECraQeGk3HhA2Eboiho9+IpbFZNBfD5rpWQx
	bSD+4Q0EG1TxwqSBi3I91pEtMDGy4qfgCLsqmHIPuIqFSRhawPM/N9RyAi4XQFhoCZOh31xfGro
	EYTPSrEjFSBCau6Cw4OHEO7aJJR4KbiYitpd+NXsi
X-Gm-Gg: ASbGnctbcKZSKdbmDqPvfNMppZoKZNlNFqN/yt4dIHN+UjW6MKPMTIOWfeCn6n2Xpml
	xRfFeF6KY7oH//s1yACr07PlN2krQMvIg50JuikwwUPmeMrX58W49UzNPlZ8tGZAHuBuOUek77X
	MveOyC2QO3vvHhHXk0iLnovYdFqlgbasC6JbmQfqzaDrO4GH8+7Wlb4PihAPV4we+1dowQRrpi0
	YrkkMgE2x255R2z0LYG25aUVJ83JYw=
X-Google-Smtp-Source: AGHT+IEpS7YuKIKyZFfw31Uu07t4KPK9fVtMAut4dTsdy4GPUFdw8RSwkUECsWmieUIlYCZPPsPBn+8xhrMusrmOb7c=
X-Received: by 2002:a05:622a:188d:b0:4b4:9590:e091 with SMTP id
 d75a77b69052e-4ba2e670206mr8111921cf.5.1758150299422; Wed, 17 Sep 2025
 16:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
 <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
 <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com> <CAJuCfpFJabb02OK8Rj08d7WU_7AM674i=vsZxzfw7i7h-PGftQ@mail.gmail.com>
 <e5e3d96a-d0aa-4466-8303-5a7e8f96bbe5@gmail.com> <CAJuCfpEULVxMixDjrk_xg7+3+97dkcMmkDd++BaR17X4tDSs6Q@mail.gmail.com>
 <CAJuCfpGgVa9X7nXhqOUZWi+p+JGz1QofiXrTJ+BF=DU3m2-64w@mail.gmail.com> <d451dce9-2217-4351-bc53-09967fa86cca@gmail.com>
In-Reply-To: <d451dce9-2217-4351-bc53-09967fa86cca@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Sep 2025 16:04:48 -0700
X-Gm-Features: AS18NWAeIVfrhOzpDwgwUeOERlQjLT1PVrBGTGH4hcV6VLZUnFIIfH2FmKLtLBU
Message-ID: <CAJuCfpFBov_2F9Kx5Csio=hOe8kY1yXjmg_z8dXU=ZUQ_-wmaQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DB1671A0009
X-Stat-Signature: nssdnao8y1i7fxu91ed5ab98dsyi6pzd
X-HE-Tag: 1758150300-296481
X-HE-Meta: U2FsdGVkX19bCTSSuaBW3/5CCxt8ufXFPQVeRBnrAVET+uUfUTqaRMKIcTSvGpgqHWhoCj6/+vO3mEqynQeg2g+8qFBiXaXtkeJX2JOUqBr3CPh9z/QFDNosg9lHsf9MyHBsJjD+bbEdy3LHykAAYx7VEaNRmyTlH+QRhtM4BafbeTe/QxtBWjFqjf2H027rC16i/j7G3UJVWQpOq4RXSzXy6UxJXUB0d27e1UD2dewcOiHB5XuKRv9dOCqygRHhiXacEzFTbfXEMKQ8gbcn6pf6kVJHDf1u+FlRJlk3ldYssrej8PldmJ3cOZtNAObtCV4ODr8fMLaBzkSn/SuynPzx/57jOoNzAA3uRLs0PXMZ4s1v2lJmbPwOsOXYIcP6fSvfY/DTVIHRRP5p2GuVLKGvM3lvzGaQC3mmfpTM30BVsoCYW9yhsgnULNkhLBaByOmmtYVthFz+BGpa5chnm6jrMkoOOrPwjlBVhQYUO5h4ISrNKywQEfpWjvsZ7/rgIawwvrB4t/uvzt1RXEzyJp9olqf/OlNg2R5UvXt1wMpqtxG0YmulaX1W+Qc8oBK+PtSzlV856yHC6+Z0GhR7I//ogryFLCDV8oaepqgJD5rfw7EIWDbqSZMmWvl/SJQILT0C7xa/LWE8Y/bRE7ol/3NGMdJo5GiDFCb6IDaqpgPzimxtOmZUUB7dts9ta9fhSxhFlZWw+5T7wDaSFIeVYEFNKOnxleXUx7jWAy0RkKrHY+RwCK16VuHiHg5O7Tn90QRv0PLcdAqrNn+0CtxaBV2fhb2FeHXknY5e1QF4mHk9X/BN/T3VuepK8GicufOzRKLHYoWJR9VPFBOdfsaWZ7ERK+JYBBTUOX93RGyqZnMTR0hhhLe1qTMPLUXo2xZZiHK9UV1qyVRgNgu6lVVW4f56S0G+d5arG8kPHeu8By1NZWnAew/OIw4F42pFCxk92e98aJrIANjlAcKKLVC
 Pa0KU/4L
 Yg/Ou8uHji5dmYCZo/qN72ThYa1S+ohUjxRSGhf6LZyMKgW5wculwDGIEKmHRPPxnFszz+7HwuE+f/FD4+J3T+L0a3kNTFRVr164Po87Ed+Cuscxuu65KYO9TiOx+aJamY4uF1qP5xh1Y5eJJDD66rdV4gPS+ohOaQZrQg08UQD5lRY5n9PbGFc0HWe/xYL1htOl5HP0rET8upcX3SX03m6zT4X4uTnvTE4pVp+afMEwAO53gbE6yDEB0wsXJJ72VADAeQ9+ye1mpsypwMMUYsb8f/g2XkvNyrr6IxQwbcJdVVo4uFGdgg5jdew8XuxbMICeFuJAkaInBcRh6QBzBUU0pHSNjNfJmJtkf89wSjAcJm1aBK61C9m9WMtksxt/4wY6XHRlD7VUGi9J5P6kzZHuPlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 2:10=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 16/09/2025 23:27, Suren Baghdasaryan wrote:
> > On Tue, Sep 16, 2025 at 10:26=E2=80=AFPM Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> >>
> >> On Tue, Sep 16, 2025 at 9:52=E2=80=AFPM Usama Arif <usamaarif642@gmail=
.com> wrote:
> >>>
> >>>
> >>>
> >>> On 16/09/2025 22:46, Suren Baghdasaryan wrote:
> >>>> On Tue, Sep 16, 2025 at 2:11=E2=80=AFPM Usama Arif <usamaarif642@gma=
il.com> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>> On 16/09/2025 16:51, Suren Baghdasaryan wrote:
> >>>>>> On Tue, Sep 16, 2025 at 5:57=E2=80=AFAM Vlastimil Babka <vbabka@su=
se.cz> wrote:
> >>>>>>>
> >>>>>>> On 9/16/25 01:02, Suren Baghdasaryan wrote:
> >>>>>>>> While rare, memory allocation profiling can contain inaccurate c=
ounters
> >>>>>>>> if slab object extension vector allocation fails. That allocatio=
n might
> >>>>>>>> succeed later but prior to that, slab allocations that would hav=
e used
> >>>>>>>> that object extension vector will not be accounted for. To indic=
ate
> >>>>>>>> incorrect counters, "accurate:no" marker is appended to the call=
 site
> >>>>>>>> line in the /proc/allocinfo output.
> >>>>>>>> Bump up /proc/allocinfo version to reflect the change in the fil=
e format
> >>>>>>>> and update documentation.
> >>>>>>>>
> >>>>>>>> Example output with invalid counters:
> >>>>>>>> allocinfo - version: 2.0
> >>>>>>>>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create=
_setup_data_nodes
> >>>>>>>>            0        0 arch/x86/kernel/alternative.c:2090 func:al=
ternatives_smp_module_add
> >>>>>>>>            0        0 arch/x86/kernel/alternative.c:127 func:__i=
ts_alloc accurate:no
> >>>>>>>>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xsta=
teregs_set
> >>>>>>>>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fps=
tate_realloc
> >>>>>>>>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:=
arch_enable_hybrid_capacity_scale
> >>>>>>>>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:25=
8 func:init_amd_l3_attrs
> >>>>>>>>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:m=
ce_device_create accurate:no
> >>>>>>>>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func=
:mce_gen_pool_create
> >>>>>>>>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mc=
e_threshold_create_device
> >>>>>>>>
> >>>>>>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >>>>>>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>>>>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >>>>>>>> Acked-by: Usama Arif <usamaarif642@gmail.com>
> >>>>>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >>>>>>>
> >>>>>>> With this format you could instead print the accumulated size of =
allocations
> >>>>>>> that could not allocate their objext (for the given tag). It shou=
ld be then
> >>>>>>> an upper bound of the actual error, because obviously we cannot r=
ecognize
> >>>>>>> moments where these allocations are freed - so we don't know for =
which tag
> >>>>>>> to decrement. Maybe it could be more useful output than the yes/n=
o
> >>>>>>> information, although of course require more storage in struct co=
detag, so I
> >>>>>>> don't know if it's worth it.
> >>>>>>
> >>>>>> Yeah, I'm reluctant to add more fields to the codetag and increase=
 the
> >>>>>> overhead until we have a usecases. If that happens and with the ne=
w
> >>>>>> format we can add something like error_size:<value> to indicate th=
e
> >>>>>> amount of the error.
> >>>>>>
> >>>>>>>
> >>>>>>> Maybe a global counter of sum size for all these missed objexts c=
ould be
> >>>>>>> also maintained, and that wouldn't be an upper bound but an actua=
l current
> >>>>>>> error, that is if we can precisely determine that when freeing an=
 object, we
> >>>>>>> don't have a tag to decrement because objext allocation had faile=
d on it and
> >>>>>>> thus that allocation had incremented this global error counter an=
d it's
> >>>>>>> correct to decrement it.
> >>>>>>
> >>>>>> That's a good idea and should be doable without too much overhead.=
 Thanks!
> >>>>>> For the UAPI... I think for this case IOCTL would work and the use
> >>>>>> scenario would be that the user sees the "accurate:no" mark and is=
sues
> >>>>>> ioctl command to retrieve this global counter value.
> >>>>>> Usama, since you initiated this feature request, do you think such=
 a
> >>>>>> counter would be useful?
> >>>>>>
> >>>>>
> >>>>>
> >>>>> hmm, I really dont like suggesting changing /proc/allocinfo as it w=
ill break parsers,
> >>>>> but it might be better to put it there?
> >>>>> If the value is in the file, I imagine people will be more prone to=
 looking at it?
> >>>>> I am not completely sure if everyone will do an ioctl to try and fi=
nd this out?
> >>>>> Especially if you just have infra that is just automatically collec=
ting info from
> >>>>> this file.
> >>>>
> >>>> The current file reports per-codetag data and not global counters. W=
e
> >>>> could report it somewhere in the header but the first question to
> >>>> answer is: would this be really useful (not in a way of  "nice to
> >>>> have" but for a concrete usecase)? If not then I would suggest keepi=
ng
> >>>> things simple until there is a need for it.
> >>>>
> >>>
> >>> I think its a nice to have. I can't think of a concrete usecase at pr=
esent.
> >>>
> >>> I guess a potential usecase is if you are trying to use memory alloca=
tion
> >>> profiling to debug OOMs and the missed objects size is very large. I =
guess we
> >>> wont know until this happens, but I would hope this number is usually=
 small.
> >>
> >> Hmm. Missing a large allocation and not knowing about it can be a prob=
lem...
> >> I'll start sketching a patch to see if tracking such a global counter
> >> has any drawbacks and in the meantime I'm open to suggestions on how
> >> to expose it to the userspace.
> >>
> >> About concerns on the IOCTL interface, would it be more usable if we
> >> get the alloctop [1] or a similar tool which can be used to easily
> >> issue such commands into kernel/tools?
> >>
> >> [1] https://android-review.git.corp.google.com/c/platform/system/memor=
y/libmeminfo/+/3431860
> >
> > Ugh, sorry. Externally accesible link would be
> > https://android-review.googlesource.com/c/platform/system/memory/libmem=
info/+/3431860
> >
>
> Yeah this would be nice to have. We do have something very similar in our=
 infra, to basically
> sort by size and store only top x entries.
>
> When doing manually, I just do sort -g /proc/allocinfo|tail -n 30|numfmt =
--to=3Diec which is copied from
> the kernel doc.

Got it. I guess if we get an upstream tool like that which is kept
in-sync with kernel's UAPI and new features, that would make the
maintenance easier for everyone.

