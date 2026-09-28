Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB45CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 22:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6CE86B0088; Mon, 28 Sep 2026 18:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E596B008A; Mon, 28 Sep 2026 18:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5626B008C; Mon, 28 Sep 2026 18:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBDA6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:59:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10DF81A033D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:59:31 +0000 (UTC)
X-FDA: 85264689342.27.2A3F4A7
Received: from mail-qk2-f40.google.com (mail-qk2-f40.google.com [74.125.230.232])
	by imf14.hostedemail.com (Postfix) with ESMTP id 04008100005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:59:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v+2xt+ey;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790636369;
	b=OQ+gbNIwgpmFnPaMyZCPqlwkkzKQar3ecCq0YeQJ+i6f7sEkOP7sWnGzppVYVPBr/cCuNE
	gzu2lB5GG7ScDWtXt3YZ4tdGT7d9pli5dpgnQsC1hSJcCzFH9S+ouCARNXr9FHTlCUPbU0
	MouaPOx4yRYxDzCvCFM2Eq4HcUI/J0o=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v+2xt+ey;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790636369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1XRNkq6Yhc/2nUm3L5+IvDvFRHvgBkAyzRT7XwQvCM=;
	b=h0N/uN478wG6r+aa7/CLg7ec8+idwz/fZ6pCoRITKinDQXqlT/4L+clY4kKDPSapPZtD36
	9AFFGxZUnnbVG0pX/JfdbHg9U2CTcEtxYfuZiY1n5mzpy1Ca6B8QYSNzNFC0OkvAJWH1qX
	AmNXmJGcrDe0/8BICIWM88dmtl9UeTs=
Received: by mail-qk2-f40.google.com with SMTP id af79cd13be357-93c5ce9914dso253056285a.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:59:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790636368; cv=none;
        d=google.com; s=arc-20260327;
        b=azsWsur/XD0JBoHPT7HBs5I6mo1LB7EyibnjJM2dF/pX4suNm+F8a5KitoRwKUwoTO
         5ypY35MhytpfrUjOD6A4/fTNgEj5v32Lpz9bDhXmy/0vkPyyoWAwu7d6eSc97TIhMsiw
         Ogvej+nf3qr/O3IZz/VDH3wBMpkOYAzVSTSxOxt4+ucqvbo2TRI6KlCJpvivhQVp2ZIX
         C/oCrlne4hsrmkMbogRQWW4bJYKz40RPexw8pdat9s9geXYW6T+Kbt3yFuSGDQmU7rpO
         T7u1/yJTj510A937DdnCfr1Fet8K4sL9YfAi+zVnnWkXturewxta8aWtoTtpnk42iAUb
         e5ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=h1XRNkq6Yhc/2nUm3L5+IvDvFRHvgBkAyzRT7XwQvCM=;
        fh=6atEOGKIKXq+gWibKoaeydS99hp+UpW2VgbD5sRKsVM=;
        b=gZsFX+bG/m8L4TUUgEgBqc3QYC820hossM1YeG5Jo9CpTV++wNXaAuw4Ym5yLB8nUr
         9lveioH/YfATT4UYRSd7kKTIFrSYwglqfUkcDCJ+EfNCwaFBcXlWbV8nZD1/8UOqdAjo
         8q6L3sUEqU9gWcNVLDMiWjhLDEq3jc7Nw26wKH/gDuBZfZSQYubxX7MuhS93TL0R18aJ
         Phafn/Y0whC5YO/a4lqRmZ8ck29FZAf/R4BbGAqWFRMR/xiLlmbJ2gwnQWyqna6jNjHK
         OVcgJAAcPrFUMb3Z0MZhlcDKZk5INi7STLzDxYv/WtYDbnJ9THLfSyPC1Y3GcyM7719t
         +K2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790636368; x=1791241168; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h1XRNkq6Yhc/2nUm3L5+IvDvFRHvgBkAyzRT7XwQvCM=;
        b=v+2xt+eymr3RaOdomxG9cw1aR8pCvWs5jrs96EwGgXdK4dqxkIFSPVFFAydSIddwr4
         UrtM+KI7OJ+ZUXljQkm8Q5QlaOfg677Ile0DhCrvgfu7IJ7Hmb/LTdqItHBvIAQPJsjc
         CnKL6wQNibKrRU03iaW8H74furMwRL1DXtsgz2vuobd3WuUF2HZu1VfJjEqAlvJqIbMA
         pkPpasYoeKYNsEKxyK1BA+AAVok7CvW45U20TvU9Ly/3PHuEnUjgfYHusyMhuOVz5ie+
         Ocvdu9BLfqYrFhELdapdolUWIGfUyjd9vidwkcxCpg+7N6TzuizzXGPH/ec/oxuXm3H0
         8VOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790636368; x=1791241168;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h1XRNkq6Yhc/2nUm3L5+IvDvFRHvgBkAyzRT7XwQvCM=;
        b=VNby5z13I1WVp1Tu67gzP7pmAD8ZdC9xCwmd4mqESr9xreLvMU6uA1UEIlh0CBKBn3
         B1WnkTTo0J+h7MIh7ODUisgziCXSCb4nI+LLr3FgI8zh61eO1ytR4uDT4tThC5JA7uml
         sDMbt1uriFf4u0oT7Gl5NdhPlEG9aKRCzDQXg1tHqL7n1Rt2FVjLQ7KbtCL8dRtG2Tin
         RT1zb4vPVgFns10Yv3VlsbFzq0GnVCxKbBC1lbLLHVBYkVI31Sh9Q5RYgfJb70wVCm2g
         QH+SsX6NrrD4FkaOE5L0iBy6vQy994TqeCbDbU6iBHe0aQ+cVzhxbe5HhYe2Umr03+PH
         fHOw==
X-Forwarded-Encrypted: i=1; AKwUvByUqrSMvxOeaRHngBUtM+HKjtI1YimrAvR6cd+/PYm1CzDr/VYZgPO0+bwjBGxT/OIuR+Xa8x2YrQ==@kvack.org
X-Gm-Message-State: AFuF++nOED8wkFxDu1ZI28fE5gtJJyssboRJSi82EHLfemDL6oODWy1W
	bdlD8EYbmL/qmgX/s7jD0CTVAg3aTxRJRSmQTewE9LXqiAVYNsg/tQJ/CSrgRI44OkDc9PWB1TH
	MVTP68AknrUIpex8GKCjkwf+0u+p8jhyA2zyR2iJ3
X-Gm-Gg: AYBFou0+3esi9kht68Y153FVKWAu0C7Bldxn30yIKdH6DqagZa17emOtpwwXCsQgeXb
	LPIuMjV5CeCQag2M2nnK0JA72kAQn5OFws3+h+5eqGaeAwZK2O+AKUei/i9gIZijweGi+9qqZIS
	YebcHAZ8mTxKyUgbRr7HeCF99UztMmFMo8t5gmhB8yRtR/JpjdXgXwefq+GPD5DM/aZ9bEP0L7P
	gXXojEp3p4m/kQCrWZrlNJXBkWXd98UnEnDzU0vObmigtsVZz3Vq/LBRH0QV3YbOEI3Oy83HPas
	IlhulXJRsZPqPuPikbOVEW/NRXQAJPMDvT7JerjmEujzS39yl5vMD4TVafSlmt2FurPgu0Y5aA9
	mpC9OdcUiCDf4zY+yvhy+k0i3jZGlU6badASvUTtS
X-Received: by 2002:a05:620a:7083:b0:939:6c31:2318 with SMTP id
 af79cd13be357-93c43ca0f85mr2339686185a.34.1790636367060; Mon, 28 Sep 2026
 15:59:27 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 28 Sep 2026 15:59:26 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 28 Sep 2026 15:59:26 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <d599627270c67a5334d2abced75d1d1711fb0af0.camel@infradead.org>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com> <d599627270c67a5334d2abced75d1d1711fb0af0.camel@infradead.org>
MIME-Version: 1.0
Date: Mon, 28 Sep 2026 15:59:26 -0700
X-Gm-Features: AclHuK84frc6bKnG4G1OS7cYNUmtfpFymmTftjPaGUJ8aPWmipSyf5FmbAPxTfI
Message-ID: <CAEvNRgGw_RjiGs_bbVnoRAvq49Qukm4h8XhkBd0DXxn1ZzLrQg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/17] Allow guest_memfd to be created using a
 resource (pool) fd
To: David Woodhouse <dwmw2@infradead.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Shuah Khan <shuah@kernel.org>, vannapurve@google.com, erdemaktas@google.com, 
	jxgao@google.com, rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
	tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
	Gregory Price <gourry@gourry.net>, yan.y.zhao@intel.com, michael.roth@amd.com, 
	suzuki.poulose@arm.com, Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, aik@amd.com, 
	aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	Connor Williamson <connordw@amazon.co.uk>, Fred Griffoul <fgriffo@amazon.co.uk>
Cc: kernel-team@android.com, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: ojwccjbdw3yq9k9dyrbewj4zfiw54p4b
X-Rspam-User: 
X-Rspamd-Queue-Id: 04008100005
X-HE-Tag: 1790636368-586118
X-HE-Meta: U2FsdGVkX1+YJg4orehaNZEeDw6Gf9kQYqO4rY1EmZ9rEOCoGx72dDBlo8JO+RJIPM0UN/ifGHu0BbXWcWK8Z3amAt57Q05L2PrPXxl8BGWTsTgqL/JDu6zlfLu7/fBv7S3oREvUakcUoj9kg2GWO5StaghXY3pTviX4dYOe8W/fnNt3KwMunCK8qE2fOWGCNgDwvjjjo78ORErDQQJLkmZbjN9wNd4ZC0viBRpO2PkspaxTcP4uaAVxBcQ72a5XnUs62iZZMYkUbN7lkkmgrHbNaISYjA3dy2EpUMb902fUgzHqCdWMMsqwqAMQnZBfRGXKgAYeEhptvM4kDW0o/QBEOvCg+IfNEay3q2s5yOVBSC0arOZ74iy/FFQ9olG0fH0xJs2Jr+KcDAqSIfFCY1T53n7/wwdBW2aN36Zc1YI14RxAoMA2WVI4xoy6ELj2sa3+mnnL7iYVf77HRkqFzlzBgCH+p1Dv57Vqcnb7zbxMcU8rPNpVPXhMHOO55BiOQmA5q8p5XHgimu9I/rM+W1frTSDdrYuqX1XXuBcYpUYwOxnd573+QJG+D1GHbrcXt4UsiXaA8RLYg9b7W/pO3xJ4+t5jlKnU9AQ+KYlcyMo2IQqfoIlk98RblCdasgK9f0leUN1L/XuJRrINcpq2TGPAwSP9FtA/VrnNHG+ibAXlPEoTuU9dnZw/HCmqvXfJ/ndG3FJOJqov2sZAN3kYEV7LevRvXuutmS6JCQMKOfRs81UKSKCivUHNqkYv5HIuISGqP+OCWqeLgUPGP8e89as7yyY1Ltfsh/ubJF7Symo2xxDEidCAswSqx6L2ssmwIDvT1x5a4cfcHJs6btFTS/9T1gifSs9pYEYYhgg9vVD8OVfkpPTmVSXirVaU8RzRQeJ4ZJ1hYB9A+E9eO00IuA4+uGJaUXNLNRYAcYCjjku0+RrKRHsfmMbCAZNOCwFJhT0dGWtfVwjSSQFk2LC
 6tfrHOfl
 zajuB9fnyYUHd84mUOk4oDe09nJPl9Hbi6jB08AR7a9aArVd0a+D6ylTPhXroABbPBDAAWomIVETGzPOO2hNs5siR3br5kDxhStVaQ2gh21VN1W15mu/5mrsdLpZudjXl5EVhaT8eF0c8JjtxqcSfcm09c3ACWPL9K+Mpj72AcnoEMi6+CM9LCERE9sMl4S4oDLTevgt1RHbGKrnrbsa+uTO8LNrzlmA2QhNtGaMPaC6tE1U+tHRx3o96m0ALC6v8Hm99xXWaaBmcH/6m+l95rN/TiNiMS1kKnoJoge2ayeZE+Jnj3Yq1Q6xHkeYsAhC0yX2TXJH8p+b9r/amnLyr3DoThjIwYyduljeo6iZoeYurtM/Gtp901W1Zx9HbObpSHj0MHxPJ72EAsKNEVW5J+jI5Ku+hs690Hbpktx1LhdoM3cnbts9c3bpuQxVlf7QZ6gYlsqrD35pIb/NBYp/aptdcdbzI3yT5ZVIm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Woodhouse <dwmw2@infradead.org> writes:

> On Fri, 2026-09-25 at 17:50 -0700, Ackerley Tng via B4 Relay wrote:
>>
>> =3D=3D=3D What if my provider doesn't deal with pages?
>>
>> Frank and David Woodhouse [2] have use cases for providers that use
>> PFNs, and this is definitely something a generic interface must
>> support.
>>
>> Here are some options I can think of:
>>
>> 1. Don't define .alloc_folio(), instead define .alloc_pfn()
>> 2. Refactor .alloc_folio() to .alloc_pfn()
>>
>> Either way, I think guest_memfd should still be the primary manager of
>> the memory.
>
> Thanks for working on this.
>

Thanks for the quick reply!

> I'm not sure what you mean by 'primary manager' here but my use case is

Naming is hard! See comment on revocation below.

> for the provider to be the ultimate arbiter of who owns which PFN, and
> revocation of the same. Think of it like a filesystem backed by
> external memory. Each guest's memory is a file, and a guest can
> *donate* specific pages of its memory to other guests (which in the

Putting donation aside first - I don't have a good picture of how a
guest would tell the host that it's willing to share a page - can't
comment. Would love to find out more.

> context of the *interface* only means that we need revocation).
>

Going with this revocation part, beginning with a more basic use case:
I'm thinking that the provider can notify guest_memfd that the page or
PFN is going away.

guest_memfd cannot say no, but it does have to tell KVM to zap the page
from stage 2, and for CoCo it may need to do more stuff.

The notification needs some pointer, so I was thinking that on .attach()
the provider would also note down which guest_memfd instance the
provider should notify.

The notifier could tell guest_memfd that some (offset, size) is going
away, and breaking down mappings in the EPT/NPT should be something
guest_memfd tells KVM to do, I think. Are you thinking that the provider
would directly break the mappings down in the EPT/NPT?

Does this notification mechanism work for you? IIUC regular DAX would
need it too, like if the device is unplugged for example.

> Should I be trying to rework parts of my series to live on top of this?

I hope to gather more feedback at LPC. It'd be nice to get early
feedback if you think it can work for you! The overall design still
needs feedback though, don't take this as the final direction.

> Things I have working but which I don't see here include:
>

This sounds like 4 or more different features! I think they do work with
this resource fd proposal.

>  =E2=80=A2 PFN support (which you mentioned).

Yup, guest_memfd needs some way to track PFNs in addition to folios. I
think for tracking we can reference DAX, the part I haven't looked at is
how to let guest_memfd handle events. Like if there's memory failure on
a PFN, how do we let guest_memfd handle it?

guest_memfd needs to at least be notified, so that it can handle the KVM
stuff: zapping and special stuff for CoCo. Whether the provider or
guest_memfd gets to handle it first can be worked out :)

>  =E2=80=A2 IOMMUFD support via dma-buf.

Is this about having guest_memfd work with dmabuf fds?

Fuad also brought up that Android uses dmabuf as an interface for CMA
memory. [3] IIUC the dmabuf fd is mmap()ed, then the userspace address
is set up in a memslot for the guest. To make this CMA memory
CoCo-friendly, we want to use it with guest_memfd.

Jason response was that guest_memfd should probably just directly get
memory from CMA [3].

I'm not super familiar with CMA or dmabufs, would either have a suitable
"resource fd" to pass to guest_memfd like how HugeTLBfs has a mount fd?
The "resource fd" should ideally have no way to mmap or read/write the
memory directly.

[3] https://lore.kernel.org/all/CA+EHjTxZ0N3Tfnid404B4tkb_E+Z8mODTHTgBPiF6=
=3DbwZp7Hjw@mail.gmail.com/

Or is this about letting IOMMUFD get pages to map in IOMMU page tables
via an fd+offset instead of via mmap()-ed userspace addresses as in
IOMMU_IOAS_MAP_FILE, and that guest_memfd isn't a supported kind of fd
(yet)?

I think guest_memfd should support IOMMU_IOAS_MAP_FILE. One use case is
Confidential IO [4], where SNP would need to have private memory
(guest_memfd) mapped in the IO page tables.

The missing parts here are that guest_memfd and iommufd need to
cooperate for conversions (or some other coordination in userspace). If
private memory gets converted to shared, iommufd needs to know to remap
the pages as shared in the IO page tables.

[4] https://lore.kernel.org/all/20260225075211.3353194-1-aik@amd.com/

>  =E2=80=A2 Revocation (which I've tested correctly breaks down large page=
s in
>    both EPT/NPT and IOMMU).

See above.

>  =E2=80=A2 AsyncPF support for pages requested by KVM.

Is this kind of orthogonal? IIUC today KVM MMU handles the async-ness.
KVM MMU checks that the page is not there, then since async was
configured, KVM tells the guest to schedule in something else.

guest_memfd doesn't have support for async #PFs now. I imagine it would
be something like KVM MMU firing off a kvm_gmem_get_pfn() request
asynchronously, and then guest_memfd gets the page or PFN and inserts it
in guest_memfd filemap, and then notifies KVM MMU?

Within kvm_gmem_get_pfn(), guest_memfd should get the page or PFN from
the provider.

I think it's orthogonal because guest_memfd could
have gotten a PAGE_SIZE page (existing functionality) or gotten a page
from the provider.

