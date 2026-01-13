Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2FBD29DFE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404896B0005; Tue, 13 Jan 2026 05:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC316B0089; Tue, 13 Jan 2026 05:22:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8236B008A; Tue, 13 Jan 2026 05:22:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED686B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:22:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD3F01B4B8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:22:58 +0000 (UTC)
X-FDA: 84326552436.15.01A0F17
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id B95F540010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:22:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="nngp/rEI";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of smostafa@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768299776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+f//pvo+PKe+VeeiEDq3PkoxP0zliahBI3UIRJy+vU=;
	b=z+cJFQhK2FHGcYORGNBM27slWijT3HD95ffhiRgCoePNnzksq9UiEHKZngiVDYqP9KapoF
	jwAghQMmNueWpbs14FvcBANFYevYBWC3EJO2ot0JM5Lob/uEa8SNbGLGJom0Ni00kh/38V
	SREeaYJSQ9EF/p8JWmhVYoHq9LgDyCw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="nngp/rEI";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of smostafa@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768299776; a=rsa-sha256;
	cv=pass;
	b=xkK/K3hiAkCzFPcEXKz5oXESXEwjHy6l0EPiv9e1gTqH4Fb48ofNnXQC0H2oKAGh1Lexvt
	eDWC2hWki5AcAgn7m4E5jphh1+Z6kPOvsOz/gAvc0mimd1Mw9JfLLuOneXHfaNGYDnrUrX
	lIokczCf5SXZDeKtbsnvbWxFkHcQnag=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee243b98caso337791cf.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:22:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768299776; cv=none;
        d=google.com; s=arc-20240605;
        b=ZfjGhOQwLvUubtaJ9pFWMykwg+tMPobLLCOWvCyEoiF8eCKLcA1MJCuz7ryVrtOva2
         8rbVgOaGq7KwhG9f86TAxy72OPpC1rI74eFWK46mhDY8jraSFupDnFddJlkXNSjtYMRP
         X9um8QamAFqI03xGxdPyfgMmpCnZ4WX0VThKlT89vYN/pEYYgx7VeZrGayGgq8WvwH2p
         HEphPlCfTD5tuM4SUDWDl6ms7dAuYSLigY3hQPcSLSkul9bnqqIUZKlF9F+yL8hWCqlm
         8M96lTRWakjFGq3lLNOwW3sLZuYUYym+cuiAMxcldxfPi4D42Rd6sXfyoPVtbJbYEG/X
         yakg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O+f//pvo+PKe+VeeiEDq3PkoxP0zliahBI3UIRJy+vU=;
        fh=FN6rUHzZxQ6Onw+m4zzoaCjFiIfD17wPtx7VChaKFHc=;
        b=VZKbJB4m0fEnaINkRMjpNM7Ea6S1S4MFqEsA6Ak5Sje4X8Q9jHwgAIh/dEQ37GSMLk
         rglyNgiDUCHsaHrcq5TJftIbdB3oWYNr9+yFNS2jQZ2KOBO7zsk5sdHEGozRZRP6NCjD
         2Oag/gFbUneLy6LbQ6DbSPkEoIi4rhmrf6YoqdvD8FvqeoEbfzjqCVsmzGOKZiP4L/ov
         pQU2cvMoOp0iqjEYoytF6ZGl+g4lgEgo3NPU9KVUsjFqpMJknOlFSlurcDqa1Hn7eq30
         tzfkr6HBuzkwQYTr/IWaVgVHmjWhePjcbB9/hKj9IKIMYWF8G1ddwsjkfhVrSI5lRf+L
         8X9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768299776; x=1768904576; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+f//pvo+PKe+VeeiEDq3PkoxP0zliahBI3UIRJy+vU=;
        b=nngp/rEIn7KEZZs/UMDemkXhyJcYFmDq34ex0GVNod4f06t+ngCSueolh4VTh+WkhU
         vEjt7t0u1mGelIb4FZvRecBYdN1MamqRRHCRyKUzTqFzJ2/VPkOjmOgLM6suGToWzwHv
         bznNwlnVTcj+FWQLqDN8qFHSs64jalQ+a/Bersdze2FNt1++S7bVlIX5PjaE1SnUo8US
         Feqj+xkR0gANQEFECO+uJPCsOXJn1ohfTiAYioq6jchHMqNmuz3Zd76uYyDRyHbzi6wJ
         lYbN9k4BDIDPtXHIxEZLwU6vNlfrd31rJc3EfQrh+6kTOSQIAlQz3iJHYoRFgOQLvP5R
         z/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768299776; x=1768904576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O+f//pvo+PKe+VeeiEDq3PkoxP0zliahBI3UIRJy+vU=;
        b=Q7RIo4no9+dREz+rL2m4EIRBedJeHp/JFATgAAlE8HA06os7D7X7/MLk+ayAcfh3Nl
         +ruKAXj6RnivKD7BzMmBXt5EtpPtTmVlaUDWNmcCfP4THM8k8Yh+UHhWVUXi/msrvkQ9
         Rp3EeH1qOcvK9fQOyIxXHgHflyeJiy53MevqiytgcXcdZiD6cKXODFqSZ6WUGJnVvmDq
         aMkt5I72f6HXZiaplxSjiYAroMk0x2xfHDx82Ijc/uuVc1XgZVFiKUKnO5PRWamds/gP
         QhK+7N06PKPFKyewG1Mk5Bt2Fx06FVJcdyxtnG+ZvHMpfXrv7urYjWFChI7WAujonzSs
         2Gow==
X-Forwarded-Encrypted: i=1; AJvYcCUqfEamke/UjqbM/drbWxe6yVXASk1I/a1P5BkWkLTSrx+AmsUrIHugTUsobNUNuxE21HZjkKqJQw==@kvack.org
X-Gm-Message-State: AOJu0YyAW/JtSZwK5sGj0knU7Q2TvgHKse2XZ2MFRbdm9Umqq1Q7somd
	0lK+G5yQV2NTeAB7C+WGLDgHoo5DDYc40nvQ1OHTyasX07XK4ldsfWWinp1zVyT3K0U4RneR2Ov
	KwOUqzC7knnRpM51TpsWVykYzJREPjeRDAkpZknQT
X-Gm-Gg: AY/fxX4ZQQRDikld5jcl5CH2lKBT8n5Q7NA0bq2uhWTq2KAvOLaGEw8hBfpdRuPFKdu
	qi1Zb79XY76d8SrnMBCf+xIrXztMNEXyzo3uFox3uEXWO87tF1EJhfKL8h7Z7auRiMZG0NyU7Pr
	afllDrEhIxi1xbHQalauKApsyjgKRaZ1qHFXnyEWOK1xqYaAuvBKbUaHkvRXGbMMjeOzmx0kjkL
	nz9sl5ldtb2qj0tYDtWH2mQI/ImAGDm+LQfj51Iwx9ITxzBQT2CF/TBBmj1pLjwNXxGrRIqEnlQ
	dpHmPEDkyDDt3yyEozEiQZldag==
X-Received: by 2002:a05:622a:2cb:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5013af668a5mr7179931cf.1.1768299775379; Tue, 13 Jan 2026
 02:22:55 -0800 (PST)
MIME-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com> <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca> <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca> <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca> <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
 <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org>
In-Reply-To: <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 13 Jan 2026 10:22:43 +0000
X-Gm-Features: AZwV_QgLu7sBxIPXL9VWKxHh4_TpVGZL_EvYu3l8xKSz8ElTbsqiQ8JNqP1h6nI
Message-ID: <CAFgf54pbkfdFr6biE8BiNKBnTBFWxXGmvxsZ0E+C1C44c9AW_g@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: abestsf16wfidf6unjonaoyzps34b1ei
X-Rspamd-Queue-Id: B95F540010
X-Rspamd-Server: rspam04
X-HE-Tag: 1768299776-875874
X-HE-Meta: U2FsdGVkX1+SYzjezS5ZkdatqmEnK7MfnQhbg6Se7B/A2wkFIU1ezCGeAb6dOEcY+jZrWTukNpElxzmshsSVtLeS8DWjLWUuSPCEEiOSg8t8sSTsWVIpGAkAp6seUKwnQ/RTQnOT3uVvNXaG8JVMN0AOuzmH6gajva8I80pu+xkRlG5A3JdNapWvpgJ1T6rWjEs595jlA06eqBP0oMTSz+wtmCGX/AHiA41RzcY3Edukm23dxEyGw4xSV4cssegkY/zMxM6lLDtDVJxQXwCg5qCwjeYG94Mog8+lbc0tfKWDx3f7sLbEb3U81CGLuAS7HqRLFCBORneDaAw1dV3Rmy8c/Q577FNzdxw25i2OUZJLYPmE7iAH7NBsta0BTmckHnqDshknfZWaj7P5XVZ9BZCZH5obiA0av5ajcWai7bZ6fK9WHRIAZkZ03Ub4NPo66csMzyXbqFoCVY2GlOGNeWBARbsVRD0RUAKopGf29Zjbiy2uWsyw2Umacxhi7tBzO0asDiIveVClFFiPT4OZ9E8GYfKv9gUWzkl80pOVvrWi3kwixv9N2n42V4PxQ/FXQPn6yB5os/9BTf6pyf5oFP2kH835jeodDMVOSbc16V6kwh/1S0R1ovXdrbpvbMglEwgnp8f6rQZb4HxAPelOypfE40bVqLRaRKyzTvUQlTlMf1gKg3dlelQO3g8uvhI/exvlf5Z6zgl8IqNF67FvfLhpd8PoLfY2/QBfSTGS648A6HFKnKvISjZDqK4wT1r8p87o16WTFnLFcTstZV65oHslUzcAfIm/vpCHWOQFHP5i7ziKd8d9Rese+g6V6CWdh0+AGAwGyHb4rP0MVr5CfOr4XaGwbWSwNKX8TfuYBqzB9K9VfqXOFaJOdpg8ZhU1BWpliCe7CxjgoXG99LeuRaxMHft5+ZpehnIWufzBRqdrjD5qM/AIXeB8nl3ta65Ux9f/aGbxYa80bfe18BV
 921w0NgN
 eU4doOwOtvnbt9Q0EAiKtlsc+IejO+D3de0b6zeuo/dMj8sO1uof2V6TCCksCLMc6Zk3zN4lHyyqh/3/t+SRlRxg1wour4VTW+APsnTbgyO9Ij0j6wzHrp3lfBf40KYDVrbz+bk+1zajCu+jOapiD2hzWIswI3fHdWkYH5Wdjvk15LYbifhNzeaBnleBe83FIlWL+igNo4SCUPwkDJ3TKM+tvvrPQM3mv41/Cjp5YMxt9zaN4MwanlZi/C1z9IVEC/sUIaF5mdqENFf84AR6MMaAUWJsr2NWyEUMiCINxSWZaSnoHjDXPx7Qx+kLUi/2MhwNR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 7:12=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/12/26 15:58, Mostafa Saleh wrote:
> > On Mon, Jan 12, 2026 at 1:52=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> =
wrote:
> >>
> >> On Mon, Jan 12, 2026 at 01:43:41PM +0000, Mostafa Saleh wrote:
> >>> But I don=E2=80=99t see why not. from the documentation:
> >>> /**
> >>>   * pfn_valid - check if there is a valid memory map entry for a PFN
> >>>   * @pfn: the page frame number to check
> >>>   *
> >>>   * Check if there is a valid memory map entry aka struct page for th=
e @pfn.
> >>>   * Note, that availability of the memory map entry does not imply th=
at
> >>>   * there is actual usable memory at that @pfn. The struct page may
> >>>   * represent a hole or an unusable page frame.
> >>> =E2=80=A6
> >>>
> >>> That means that struct page exists, which is all what we need here.
> >>
> >> A struct page that has never been initialize shouldn't ever be read. I
> >> don't know how that relates to page_ext, but are you really sure that
> >> is all you need?
> >>
> >
> > AFAIU, if pfn_valid() returns true, it means the struct page is valid,
> > and lookup_page_ext() will check that a valid page_ext exists for this
> > entry.
>
> Not always. Offline memory blocks have a memory map but no page ext. We
> allocate the page ext at memory onlining time.
>
> Also, I'm not sure about ZONE_DEVICE memory, very likely we never
> allocate a page_ext for them?
>
> I'd assume both cases are not relevant for your use case, though.
>

From my understanding, in that case, page_ext_get() will return NULL.

So, as long as struct page exists, page_ext_get won't misbehave.

I am not sure about offline memory, but MMIO can be used. We use
pfn_valid() before getting the struct page that we pass to page_ext.
Would that be OK?

Thanks,
Mostafa


> --
> Cheers
>
> David

