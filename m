Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F3CC83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 02:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E1C6B009D; Mon, 21 Jul 2025 22:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F85A6B00A3; Mon, 21 Jul 2025 22:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29146B00A4; Mon, 21 Jul 2025 22:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E28CC6B009D
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:40:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B42B1A0228
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:40:54 +0000 (UTC)
X-FDA: 83690348028.17.9CDEE8C
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB74F180002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:40:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BWFbfv1z;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753152052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0W8/b7p/THTjwlcU+35tCprs1mFDM/79Tl9WX9u/Ei0=;
	b=EZJxcuDgr4oigbxt+IduNp2WlnULeeKLUujUP2JFRXtL09vlDd7a5ZjQQ28SZBwyApfoe9
	roTUjkesyFFajX0UAgltbF+VlzDRV5wQJlJpfscyCcm6l51WqHSavYIPjBLCBx7AeCBfvB
	E/VNsUgD3g/DvCYBtx/hQ4srCX+F5oQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753152052; a=rsa-sha256;
	cv=none;
	b=0WGqQ912+OUbw+NkvZsezzynKKWt4Ckr2vNHanhGKGlBKg22JlE9CqSzzt/8Sx5qhrexQ2
	MGZ/y2QhMopOvTXChDRjDUp5ddezGcRTUBGiRSlNcc/dxCAqFQs3kFSFOT4WJo5oTTLsKj
	5KGPEPlbukPKOqSzXzlhraojd45Vu5I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BWFbfv1z;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6fafd3cc8f9so64877276d6.3
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753152052; x=1753756852; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0W8/b7p/THTjwlcU+35tCprs1mFDM/79Tl9WX9u/Ei0=;
        b=BWFbfv1zQY+nxFXBhQ51fs0ZGi8iZgMGhagW0Z6utPplQ3pW/XT21uYID8jzHLdvbs
         FR0r+oR5oWDtVy3I5qXKIn1fE7ZPJm4x9zD0zAbS+I6z+m1ybMRq+2BjXknfh2+mDOwG
         friWgU9us/z6fYkXHspsbXKyp9L/dnPfgjNpEsnDXPH8/dPRuHLYsTICWpQvApFzGsAq
         FLhnB+LTxD4R/guVR91JD4ZluR0bQlqFO54N76zu+E9Zx+jEOtaC09MTwFK8cYVULa58
         LiqiqWazKjfrrpYt7FXbUnzbWPkwuaTQ0XFsiXlEypSMpH//WHmYCvqyhHfAOA0x0aBS
         hfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753152052; x=1753756852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0W8/b7p/THTjwlcU+35tCprs1mFDM/79Tl9WX9u/Ei0=;
        b=dodNusRtdho/ba0e4iAYaD6XIRxhE2mW7C9kpRAaeZBPon8MaCblQ2ikdp0quTrfbw
         2Z3o8y8jC71mLcfdjMSDMeYxBIDENo2+Wj3/L9rm75BjE3GDLOs4vaR1umdmpBOBBsXP
         0L0xahak6t0pbK+8Emr/hMkP61Gor5fMnviSy2p0PQ1ahT9EXOsG8KGlabgoqg0CV0FO
         jJ7NaIdfn4Qz3/31moDA73BGvie8zfTzGblGrTGlhtAm/nfBReaeUup3xFMBJjju65MZ
         kchEkaJeet2jUCyNonqLPiRHTlzo3LoMiZcD2FBu09lVrLKOwxbSuZaS61zx0FGNGjxr
         TqcA==
X-Forwarded-Encrypted: i=1; AJvYcCUHQaZcWYgxCPk15ujFAVhy98//kALa9JW/YXed8hLGg+sEaQofdTsU7nlWeDpIXNchtd+6z+pSMQ==@kvack.org
X-Gm-Message-State: AOJu0YwX0VJVInUv6o4GDGKc5Yae4unJQykRazyEIOGciec3Ga3imdHY
	hC/wtSZAsi6Z+gGceInUAYNUkVCKCKZFtkbpRMcDusRlIZzHCMjxOtoVg4+kiHMV4UPzKpzfT94
	L+SYfCQLz3cg4yeHyUDS4/wMHK7joEik=
X-Gm-Gg: ASbGncuSItl5QS/SuVXQmc4BVzBrIy9fN8CUZQhRWMM3RbLJDNJAVb2Q+BIuLTJXrRV
	O4fYeoFtglDH6YgSBdZ6K5jFtn31pYUn1DYWRZS/3iNoxlKY6rOtUnxoMNg2FP0VE0vV3926rN/
	DFET5Slmkh3mmd11Bwj2O0+Aw6LbPjAr5qSXHq3iUC9cNRERBIi3mZjwjNFI+XHXTkPRe2JRKdf
	aUGyBY3
X-Google-Smtp-Source: AGHT+IEGWFc201OyQh04zD480T7nLL8ld9y00onwVtnc0nArBfd69dvJsFvqfwm8DoluqHOeJey2scLqr/2WpdHRZh0=
X-Received: by 2002:a05:6214:c6e:b0:6fb:4e82:6e8 with SMTP id
 6a1803df08f44-704f6afc20fmr297088226d6.14.1753152051717; Mon, 21 Jul 2025
 19:40:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250608073516.22415-1-laoar.shao@gmail.com> <b2fc85fb-1c7b-40ab-922b-9351114aa994@redhat.com>
 <CALOAHbD2-f5CRXJy6wpXuCC5P9gqqsbVbjBzgAF4e+PqWv0xNg@mail.gmail.com>
 <9bc57721-5287-416c-aa30-46932d605f63@redhat.com> <CALOAHbBoZpAartkb-HEwxJZ90Zgn+u6G4fCC0_Wq-shKqnb6iQ@mail.gmail.com>
 <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com>
In-Reply-To: <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 22 Jul 2025 10:40:15 +0800
X-Gm-Features: Ac12FXzqG_f9FxqCQ-Us7PIuGLnDR8UZt_AhkecL3qH3UEIRbE2I6E5e2BFtxm0
Message-ID: <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] mm, bpf: BPF based THP adjustment
To: David Hildenbrand <david@redhat.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BB74F180002
X-Stat-Signature: qtgydhijs4r46ezyar173mq8uo7dr75y
X-Rspam-User: 
X-HE-Tag: 1753152052-336375
X-HE-Meta: U2FsdGVkX1+71FwB7rar4LMr4u5R41W86rjs2LeL849P3sJF12thG0avYUeVbU/h6EfcDX6E/b3b9icOcfyCAcyoeu04yEOHzybab0t88l3wXDm6Wmyu9TjMUWTzlQ4JLwy+FhMD+fdCl5pfT3I5l+zpZdelPuGTIcyJqzIxfnbVkMMc95Mi50lFDLarfdVuk9Br6UeV+UURm3iOvseSbWLzz7KKo+EAvtdMNVmMTuQl6JSzBpgcckYhO8BiedccfoadoCb8C9ueFOUfbNT4kWUzB0XJNtFjAgUaaio2H0jFT71tNCdJPB7aix2cRT9liqdPlB6u49unCeVM/9lOO0GKMmo4Qs5N/VoptqQezdCm3rcpN7OcTEFqwhAmjj8cHi5Q6pYNiHGyTF98WgzI7Qam8ycNM3/LgUXIl8fe3fwQGtuA6C8U/Hv0b6pEAPlrRp85fPtPZslfHuwbV5QJXGrF62SxK1thZCJ3ULR2Jua/IDTBUaUCA02qGSgBUu1/Bgajh03Y0cfJdjXrj2taxofws1YwAKs24N4LuPDyYhjHuYlu2ahbLuFsIQ2cjRki3CsHDXOXiHKgTtSEnXgcCki5jdYd1wC+73Q9NDwgziF/VdS7xUagdexTRKT7KVALJAmFmgiO7AK8lelGlIvES6A//NzsRL/wNCBjQ2MqUqlHAxFadCjtD88T8nz/Vm6tRYunh1IJA3D7BQf7g4pPSVtsUr8zAY6bK6Eraxt+Ezy1CrVtCmmMqzIa71MNTaXYqKlbeDxT9G3ZCalDZaKDIWxHr6EIsGV+7OuMrf34CpOY3+Yv9ulMP8DitruVmMWjfpVyQQOTXIh9de1P/n37JWm+4yzas2bg9S0bhO3RFYzfuM69EmCiAJeDuU5qcj3U/whK/yRI1ipMAsUJQoY7NdV9YFRbxhwUiiNAATYbHedqO+pjkVGwPRy6EsWb8XJq0tauFuMzOEWGqZ32ajC
 +uvZO2Wn
 fd+o++mg3bT7otipqhtUg5sA2MtNcPpa3lBjL4DDrU0R+ENWh2mHQCa5r1MPFwKhJEVcLSUGctmRe10BtaTJRtjif+YmOdpI/aOCXtjnbDDSDEDpdnccIHDy8LgxrfD1S75kFdR7WkiAnq0lG1oeVkbSGnLX8ev+DiD18c3r3+izQ6v4b3V4XNfLVmYbuInFzH3bixxqT4zaOuXk0SN1+Q4jCIFPGzx7eJkIqC6i0K6h/P56HZ+OPeO814NC3OS/cP99TnDQIY14w1AiVsH54wXWiOjlgfPW0p49GEt20VRy5OqaVV/Gk4WWy6+cuzYWoLJiVsyqZk9DQq2nLUC6qy9tBbosmNOy0g3YFU9dAmkJK/LXP8gnHyX0gWDp6idEvOONfoE7nZk/zKxRHJtj8Vs/WHfi7Pt1HM6XH6ghA5OX386YAcL2yIUzWsr8jCdTKlTFgzF8wwhKsJy/VjN26uONRTVljuhzwvwkxzFvhrZ4HSV/ZXEtRSh/sEYz3GPVGNznDyxCiQ7gAXIi6hoieyZiVrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 20, 2025 at 11:56=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
>
> >>
> >> We discussed this yesterday at a THP upstream meeting, and what we
> >> should look into is:
> >>
> >> (1) Having a callback like
> >>
> >> unsigned int (*get_suggested_order)(.., bool in_pagefault);
> >
> > This interface meets our needs precisely, enabling allocation orders
> > of either 0 or 9 as required by our workloads.
> >
> >>
> >> Where we can provide some information about the fault (vma
> >> size/flags/anon_name), and whether we are in the page fault (or in
> >> khugepaged).
> >>
> >> Maybe we want a bitmap of orders to try (fallback), not sure yet.
> >>
> >> (2) Having some way to tag these callbacks as "this is absolutely
> >> unstable for now and can be changed as we please.".
> >
> > BPF has already helped us complete this, so we don=E2=80=99t need to im=
plement
> > this restriction.
> > Note that all BPF kfuncs (including struct_ops) are currently unstable
> > and may change in the future.
>  > > Alexei, could you confirm this understanding?
>
> Every MM person I talked to about this was like "as soon as it's
> actively used out there (e.g., a distro supports it), there is no way
> you can easily change these callbacks ever again - it will just silently
> become stable."
>
> That is actually the biggest concern from the MM side: being stuck with
> an interface that was promised to be "unstable" but suddenly it's
> not-so-unstable anymore, and we have to support something that is very
> likely to be changed in the future.
>
> Which guarantees do we have in the regard?
>
> How can we make it clear to anybody using this specific interface that
> "if you depend on this being stable, you should learn how to read and
> you are to blame, not the MM people" ?

As explained in the kernel document [0]:

kfuncs provide a kernel <-> kernel API, and thus are not bound by any
of the strict stability restrictions associated with kernel <-> user
UAPIs. This means they can be thought of as similar to
EXPORT_SYMBOL_GPL, and can therefore be modified or removed by a
maintainer of the subsystem they=E2=80=99re defined in when it=E2=80=99s de=
emed
necessary.

[0] https://docs.kernel.org/bpf/kfuncs.html#bpf-kfunc-lifecycle-expectation=
s

That said, users of BPF kfuncs should treat them as inherently
unstable and take responsibility for verifying their compatibility
when switching kernel versions. However, this does not imply that BPF
kfuncs can be modified arbitrarily.

For widely adopted kfuncs that deliver substantial value, changes
should be made cautiously=E2=80=94preferably through backward-compatible
extensions to ensure continued functionality across new kernel
versions. Removal should only be considered in exceptional cases, such
as:
- Severe, unfixable issues within the kernel
- Maintenance burdens that block new features or critical improvements.

--=20
Regards
Yafang

