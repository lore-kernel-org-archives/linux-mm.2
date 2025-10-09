Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E7DCCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B4B8E0066; Thu,  9 Oct 2025 06:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2BA8E0002; Thu,  9 Oct 2025 06:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08228E0066; Thu,  9 Oct 2025 06:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFD578E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:00:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F2634639B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:00:13 +0000 (UTC)
X-FDA: 83978130306.25.235CDBB
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6080A1A0016
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:00:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N9ddSwHj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760004011; a=rsa-sha256;
	cv=none;
	b=kN2MrWK3DwmOo0nFl/7UfZvmAfcR5XNBxD6J+sU7pn8ivsRc9dcI9OCmTWPsoVVxzoSqsF
	edRPaqT3WN7+J/abmHVZdzgVy/R3fBLxFBBEQczO4vESahk26SYv7EX7eCf8C66zs33Hs5
	TLtSkFqG7i9o9SnLg5XZkq1rVtBd/K8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N9ddSwHj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760004011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsHNfh2cevZ8eaqWHX2Uah677Z7UfWqdMMb2SSbci5w=;
	b=djijFL+arkiNvbKO+mvXHTB5/b1LndIDCcrjzXNjDjltEADTdAuskH1kVuaqXrVpbiMOdl
	T6tnH/6LKSIYJtFn4mq6PZT7wa1WMqTRsaZ/spLZCXBqx82dSqzIChMeejjx47UDXPBNmG
	d9WXCDY+8WQmJrA1BsurZ3SDyR0JaXw=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7f7835f4478so6171386d6.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760004010; x=1760608810; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsHNfh2cevZ8eaqWHX2Uah677Z7UfWqdMMb2SSbci5w=;
        b=N9ddSwHj3dwfuWpA+ReP7LxFpIOhjCPJV7DWnuBcC7OUDnASAEPIs5Z3wcRiR7rALM
         UmXN05KPP5Au9j6YvANtAqvrWmxrIjY3U/S6/M4ZL/12V2+smE555O+YK68AUiTKvM5l
         jDxW5jgdUcW/VLVIwaIlmXioXoiH0un7DzRD+fgHLJ6Hpit8UnOQlSbvdfH2OqLI/PQ3
         /mEp3zGDJHsgPE1nWKFd2c/RYqMx9LhU/7a25twhRAztJGaylKZGYB9hGwswIcg8bjHn
         3v32VUSS1fuLMj7Co+jmiU/EdLrjSNLL74C8vC2MpvffdpgwgiCxjeG9aJ8jwm5Oie2o
         8CHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760004010; x=1760608810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BsHNfh2cevZ8eaqWHX2Uah677Z7UfWqdMMb2SSbci5w=;
        b=AyAZK4nHrrQ6/SvizzrcTYg6xS8WCV8xYgPOG+BNtKP9MpWmCfL/BVn7tgVZlMQiav
         OqBDPrACln0qJQApiSJrsyY2kJo7LXZ2LnGQkWX5JviK8CpBrsYSGI95FGTr+nDXovIa
         8GLxsxVWsuFbOHCxeZ98OBDzL0j/kwezvnVHzZFVnzW6kNZZy3wXbsFjVGIEN9hsEyh/
         35xg8s/YfoJU3eZkT/UaDbHe1S2rn5ZNfg10x1jZaLN5NEo9b/c2zasvLX+wRFc7QK49
         SkVvPeT8N6Ig4FAjTkh7eXYE8ZT50OpXPrrO0gz5YMvxSo/6odCui6m2PeazeF3QYHdu
         O7vQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYSAOsf2rmIhyiyJ4FMXEPdm9wAQF1Vt/uDujvvn8uNsB4DjLXFANbHB5fg2ItceNp9g5gXTu+4g==@kvack.org
X-Gm-Message-State: AOJu0YynY88JUTyaaLoK3loMfgj3qyjVWqv7cTLLKf2sUQtbZ6ZHThOq
	4cqUD/GgX7dSi21UiMg+Dr30g2h9ZuZAsqk8m+xfPMg3vB6zqY7bb/v3NI4M4/g6d1Uqgn1RNYE
	/C8IPqOYtTE60imCfv9A6o0glvdsnXLk=
X-Gm-Gg: ASbGnctj9TLW5SH31duO068Hk2y1BUHOgWG7aQlcTICN6zMqkz3Kt3Zgs9/m3K485mY
	NgrVCqrPR0PpeUlIF/HD+duTG9xQjwHarzUFyugjMmFesRdzOobCNsZ+Ep8YYbJ60+BYccq1fHO
	vvS5pQxv0yU4laFT/rMl7PbQk5xoHURw33WlHN77SoRkUZWjaF1DTy6PmjCAvkn0flQLJAEJSdU
	/qxhxuJMzHybvTGw5J4IYo/PQ6UMfwADMnfpZkd3pka5NkaV83SVS6q7hHWTVnv60D7f5U87rZa
	CgsICGZNqQ==
X-Google-Smtp-Source: AGHT+IETxQVsMJZ6FUrqxCOJXTq/1lBKlldBdCCphIo2WiWqP2OQZ5MBwrkw2Mvl/zoM5NqKDP1WjJ0VU5dCT5Ozh/c=
X-Received: by 2002:a05:6214:4003:b0:850:d233:62ab with SMTP id
 6a1803df08f44-87b2ef73213mr99406266d6.63.1760004010105; Thu, 09 Oct 2025
 03:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com> <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com> <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com> <f743cfcd-2467-42c5-9a3c-3dceb6ff7aa8@redhat.com>
 <CALOAHbAY9sjG-M=nwWRdbp3_m2cx_YJCb7DToaXn-kHNV+A5Zg@mail.gmail.com> <129379f6-18c7-4d10-8241-8c6c5596d6d5@redhat.com>
In-Reply-To: <129379f6-18c7-4d10-8241-8c6c5596d6d5@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 9 Oct 2025 17:59:33 +0800
X-Gm-Features: AS18NWBlPtBCYqodlkqsQpTW3fhlgQOczuwvYOS9Vl81gX2DcaljddI-xWUUb9I
Message-ID: <CALOAHbD8ko104PEFHPYjvnhKL50XTtpbHL_ehTLCCwSX0HG3-A@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	Matthew Wilcox <willy@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>, 
	Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, Randy Dunlap <rdunlap@infradead.org>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6080A1A0016
X-Stat-Signature: dr5cc8j168e4bge6osjsc96dy4dpzwfo
X-HE-Tag: 1760004011-467665
X-HE-Meta: U2FsdGVkX1+jek3RofyQHyHsr2yPeHvYHTYxFOh2gVpnhcykISdVj6G4gBR8FGSUrvmX5xkntsLhM6pm3kXs+ORE2n+SIFrnUSPbFkgDTEL+qT3UGGVoJnnlm/XNITFkuZ2flLZumn7fxzqryFufemPxc3cYkxjOBDGW19/cUu/uU/lGofnCkDh52582/vYRaQI/ZS5WxTrRmhWSIdg7QWS+teyGsfeuteGv0hceyBKiAqCOx0Tu+nWHyDVIvyW+JWfSC1IxK7Ru2fxuY/g3AhP+vEtwXOwMGNqg8Y513/VFV3W/cbs7b0b+SMGz28vPMdNyGWx8fIHuBrMMzEP0GFFpbj+TJA56w9Ym2sUXVbGXax+Ny61BLPjvrWXDiO3J+NgXYjBjmZWFfZCFHoo0LF5fvSp2sxdfcXpfZ97ofWikv8JWY25ruVqH+/jpLFE47MkMZUivzfs0buTisubKZECmy/Q27tKnlI92igr38PdqCgNcYawecr/jDzhbQuUU9bW0hTptYmda0xW6Q6xIjOOmckfE2QRgFYqpn2nHv0wrwWXk/617BgoRecciJBs+4lcJ0rtD/2l+Aqx8H98T0CQgl5Mn0/yf9EgKhu2VXy63Bbo5vOZygxrla35/Uyy9ZZTO6flL6zL47QCeyfGnZhY7TCxa0N5z9jUr6/d93v5yUzNKqGsNzajXlVEbyjriMuQNjvQUQjhxnE/PbmcWsFYfDcYkEcdzemUfmdThwK8Z2HTEuUr7WPDe3Qkyr7HXozM3tta6hSTDL9EjlGgRClZnM8Z7ouipWSacQ8e44OwO18QUtI7bhYqotMpngoRRmskXcgVJ3UGd3+ehL1LT1WwfB1VK32qig6EgwupXkvj1+qEJ/Gz4F+ixcK0/fZicwf5k4EGpxphiJ6xyE/zhBQV89ZGRiOGhMeSIh1K2a8bvEE4HPLNAOsUhsDUPdU1i0tRJc0fWC02YZC+SILv
 QlYrdDXu
 nsTSszeXuvz+YIaNWsEfxZlzyQ/Nexhir59cXrObrrhq5TKYMvlGBDmCiL/MFVYLjScTRVsv6D0CyCTboMMDjU7ve0+Qzw4idphRAKR6glod1qjKofVgDSUG7xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 5:19=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 08.10.25 15:11, Yafang Shao wrote:
> > On Wed, Oct 8, 2025 at 8:07=E2=80=AFPM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 08.10.25 13:27, Zi Yan wrote:
> >>> On 8 Oct 2025, at 5:04, Yafang Shao wrote:
> >>>
> >>>> On Wed, Oct 8, 2025 at 4:28=E2=80=AFPM David Hildenbrand <david@redh=
at.com> wrote:
> >>>>>
> >>>>> On 08.10.25 10:18, Yafang Shao wrote:
> >>>>>> On Wed, Oct 8, 2025 at 4:08=E2=80=AFPM David Hildenbrand <david@re=
dhat.com> wrote:
> >>>>>>>
> >>>>>>> On 03.10.25 04:18, Alexei Starovoitov wrote:
> >>>>>>>> On Mon, Sep 29, 2025 at 10:59=E2=80=AFPM Yafang Shao <laoar.shao=
@gmail.com> wrote:
> >>>>>>>>>
> >>>>>>>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *v=
ma,
> >>>>>>>>> +                                     enum tva_type type,
> >>>>>>>>> +                                     unsigned long orders)
> >>>>>>>>> +{
> >>>>>>>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
> >>>>>>>>> +       int bpf_order;
> >>>>>>>>> +
> >>>>>>>>> +       /* No BPF program is attached */
> >>>>>>>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> >>>>>>>>> +                     &transparent_hugepage_flags))
> >>>>>>>>> +               return orders;
> >>>>>>>>> +
> >>>>>>>>> +       rcu_read_lock();
> >>>>>>>>> +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_=
get_order);
> >>>>>>>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
> >>>>>>>>> +               goto out;
> >>>>>>>>> +
> >>>>>>>>> +       bpf_order =3D bpf_hook_thp_get_order(vma, type, orders)=
;
> >>>>>>>>> +       orders &=3D BIT(bpf_order);
> >>>>>>>>> +
> >>>>>>>>> +out:
> >>>>>>>>> +       rcu_read_unlock();
> >>>>>>>>> +       return orders;
> >>>>>>>>> +}
> >>>>>>>>
> >>>>>>>> I thought I explained it earlier.
> >>>>>>>> Nack to a single global prog approach.
> >>>>>>>
> >>>>>>> I agree. We should have the option to either specify a policy glo=
bally,
> >>>>>>> or more refined for cgroups/processes.
> >>>>>>>
> >>>>>>> It's an interesting question if a program would ever want to ship=
 its
> >>>>>>> own policy: I can see use cases for that.
> >>>>>>>
> >>>>>>> So I agree that we should make it more flexible right from the st=
art.
> >>>>>>
> >>>>>> To achieve per-process granularity, the struct-ops must be embedde=
d
> >>>>>> within the mm_struct as follows:
> >>>>>>
> >>>>>> +#ifdef CONFIG_BPF_MM
> >>>>>> +struct bpf_mm_ops {
> >>>>>> +#ifdef CONFIG_BPF_THP
> >>>>>> +       struct bpf_thp_ops bpf_thp;
> >>>>>> +#endif
> >>>>>> +};
> >>>>>> +#endif
> >>>>>> +
> >>>>>>     /*
> >>>>>>      * Opaque type representing current mm_struct flag state. Must=
 be accessed via
> >>>>>>      * mm_flags_xxx() helper functions.
> >>>>>> @@ -1268,6 +1281,10 @@ struct mm_struct {
> >>>>>>     #ifdef CONFIG_MM_ID
> >>>>>>                    mm_id_t mm_id;
> >>>>>>     #endif /* CONFIG_MM_ID */
> >>>>>> +
> >>>>>> +#ifdef CONFIG_BPF_MM
> >>>>>> +               struct bpf_mm_ops bpf_mm;
> >>>>>> +#endif
> >>>>>>            } __randomize_layout;
> >>>>>>
> >>>>>> We should be aware that this will involve extensive changes in mm/=
.
> >>>>>
> >>>>> That's what we do on linux-mm :)
> >>>>>
> >>>>> It would be great to use Alexei's feedback/experience to come up wi=
th
> >>>>> something that is flexible for various use cases.
> >>>>
> >>>> I'm still not entirely convinced that allowing individual processes =
or
> >>>> cgroups to run independent progs is a valid use case. However, since
> >>>> we have a consensus that this is the right direction, I will proceed
> >>>> with this approach.
> >>>>
> >>>>>
> >>>>> So I think this is likely the right direction.
> >>>>>
> >>>>> It would be great to evaluate which scenarios we could unlock with =
this
> >>>>> (global vs. per-process vs. per-cgroup) approach, and how
> >>>>> extensive/involved the changes will be.
> >>>>
> >>>> 1. Global Approach
> >>>>      - Pros:
> >>>>        Simple;
> >>>>        Can manage different THP policies for different cgroups or pr=
ocesses.
> >>>>     - Cons:
> >>>>        Does not allow individual processes to run their own BPF prog=
rams.
> >>>>
> >>>> 2. Per-Process Approach
> >>>>       - Pros:
> >>>>         Enables each process to run its own BPF program.
> >>>>       - Cons:
> >>>>         Introduces significant complexity, as it requires handling t=
he
> >>>> BPF program's lifecycle (creation, destruction, inheritance) within
> >>>> every mm_struct.
> >>>>
> >>>> 3. Per-Cgroup Approach
> >>>>       - Pros:
> >>>>          Allows individual cgroups to run their own BPF programs.
> >>>>          Less complex than the per-process model, as it can leverage=
 the
> >>>> existing cgroup operations structure.
> >>>>       - Cons:
> >>>>          Creates a dependency on the cgroup subsystem.
> >>>>          might not be easy to control at the per-process level.
> >>>
> >>> Another issue is that how and who to deal with hierarchical cgroup, w=
here one
> >>> cgroup is a parent of another. Should bpf program to do that or mm co=
de
> >>> to do that? I remember hierarchical cgroup is the main reason THP con=
trol
> >>> at cgroup level is rejected. If we do per-cgroup bpf control, wouldn'=
t we
> >>> get the same rejection from cgroup folks?
> >>
> >> Valid point.
> >>
> >> I do wonder if that problem was already encountered elsewhere with bpf
> >> and if there is already a solution.
> >
> > Our standard is to run only one instance of a BPF program type
> > system-wide to avoid conflicts. For example, we can't have both
> > systemd and a container runtime running bpf-thp simultaneously.
>
> Right, it's a good question how to combine policies, or "who wins".

From my perspective, the ideal approach is to have one BPF-THP
instance per mm_struct. This allows for separate managers in different
domains, such as systemd managing BPF-THP for system processes and
containerd for container processes, while ensuring that any single
process is managed by only one BPF-THP.

>
> >
> > Perhaps Alexei can enlighten us, though we'd need to read between his
> > characteristically brief lines. ;-)
>
> There might be some insights to be had in the bpf OOM discussion at
>
> https://lkml.kernel.org/r/CAEf4BzafXv-PstSAP6krers=3DS74ri1+zTB4Y2oT6f+33=
yznqsA@mail.gmail.com
>
> I didn't completely read through that, but that discussion also seems to
> be about interaction between cgroups and bpd programs.

I have reviewed the discussions.

Given that the OOM might be cgroup-specific, implementing a
cgroup-based BPF-OOM handler makes sense.

--=20
Regards
Yafang

