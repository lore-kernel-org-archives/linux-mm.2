Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B52FC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A7F6B00B5; Tue, 21 Jul 2026 04:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAA96B00B6; Tue, 21 Jul 2026 04:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1496B00B7; Tue, 21 Jul 2026 04:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1CEA6B00B5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:22:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4402CA0C02
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:22:42 +0000 (UTC)
X-FDA: 85012092564.05.EC33A52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id CAE3C40006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:22:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A8f9jzak;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784622160;
	b=DJjRN+C0M1Iqx5+BNUEZOefdVTXECNgpJz+ZqH9OrzJOaC5/gaiaEZRJyeIG5/9NzZzTZh
	XIIByL3mJdMoMds3B/pV/rRuDRHqfXcvpQJHWNjRyFGGChLh62j9tR8HyzlmKwwq33qB/l
	DMfMo435kTJpyiXL+JSV2oHrTsebI9M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A8f9jzak;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784622160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwOqXY/uyBnQZFWybUAPKezRWed1w1DAnxqhA5rzeJA=;
	b=RHsT43W/dD4tGNU3pmSdkdRqiygaJ4Z06cnxyXoWpRSVSgBygAxV7L5tMaW3Qjh0VFb5zQ
	FbyiHwXyb/0NhxR4oWeknLKrBiwMqBeZiRHWIi46o+Hf1LFuwWLy0g1YtIsZfEVO+xjP22
	Ig1DSy3YwexgVylO/sdvWuoQHVsgwFc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784622159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mwOqXY/uyBnQZFWybUAPKezRWed1w1DAnxqhA5rzeJA=;
	b=A8f9jzak5m1rijbEpYcr/PP8ziYEko4BU+0ihRVFGJUur3vyCNBlJ78IFI7JFTfsWtewsM
	ArViuuNFW7ljp7PU3CqAaJoN5qrVscrMwtLoeBEpf6GywUEnaJvPQfcorhZod9OyNCqO60
	Os2Qb2UBpaiMQF6tFhOhCJUYcaX1TNU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-WZQ_YhXGN7qZGR96yxYocg-1; Tue, 21 Jul 2026 04:22:37 -0400
X-MC-Unique: WZQ_YhXGN7qZGR96yxYocg-1
X-Mimecast-MFC-AGG-ID: WZQ_YhXGN7qZGR96yxYocg_1784622156
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39eb3b2f25dso15522641fa.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784622156; x=1785226956;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mwOqXY/uyBnQZFWybUAPKezRWed1w1DAnxqhA5rzeJA=;
        b=N+NTx5u2BUl0opw8BQpEUuFFgyrav3r4wB3JkLBOk5nbcqLjd12uf3vvCxsdJQvrlH
         9xWNrSQhrKiqISkp1W/YdWWx1qvu0+fnWQ8OmJK6EPQMdK4MtVjAy2IWVixofkZKpG+l
         AUoLNZjnymN2e5qp49wneNNr7/YNxIQmR32kSfz6C0bv/9dlFGRFl/CttBj5H3AmJ68L
         wsj4WmKu0Xk6N6wHAb/8NVkADFzjy03Xp5rEgH2UfAfDQN/kBMKJktEyP+GoF/cSnuw6
         MdQHkAhqvROFomIkyhJSx4F8RRtA7uEIy+CiHymD5vYxsmMOKPCB/Ejd0dD5ZF6ypAm7
         0SJg==
X-Forwarded-Encrypted: i=1; AHgh+RpkWis05FtkzhXOUNe9bBiPH4gJa5SnxKIZvZtY6uo2ml37BMBLQD3+7qkvLFi8vV4hEVxm+jNuPw==@kvack.org
X-Gm-Message-State: AOJu0YwIvHtLAY5iR1DIEqI6jNzi3l3wz0HC8Ee2hznXKJqDwSj7MWXe
	vTf4qQx3TqU7Z7EHXmmNnEaAWYd+21NanrQXiRrUbFzZWbqEY+Zj5poENFg3MsCweCfy//4e/QL
	XT5k6T8PsUNNDKgjSkwx5tmAqYQnS6PLbJnb77cGLTm6L3KCT6hRjNIgCulw6ehm48CBFf4B1wo
	tVltdnSqvAooZKsIMOoZQ6DOiVmXs=
X-Gm-Gg: AR+sD10h790e2NHC2udnJZBMpQTY8+kvNAlAflRK9WZ0HclbRozVzLqaMjW9ENojQFc
	Gc5xEf7/uADWO7EQpWOW4/b8rEsizHtISmjXkwpruha6anm9CysQDWrOfVvr255oUH8+GLPl8vf
	HnEubPS09igltIpv8Yl8BP0uTHioxHxjcfb4IANtgdBEupA0C6vouuRw==
X-Received: by 2002:a05:6512:800b:10b0:5b0:136c:5ccd with SMTP id 2adb3069b0e04-5b28f868e00mr2521493e87.19.1784622156320;
        Tue, 21 Jul 2026 01:22:36 -0700 (PDT)
X-Received: by 2002:a05:6512:800b:10b0:5b0:136c:5ccd with SMTP id
 2adb3069b0e04-5b28f868e00mr2521472e87.19.1784622155846; Tue, 21 Jul 2026
 01:22:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260720142913.846902-1-pfalcato@suse.de> <CAA1CXcAk1SYopaokUGbT7RK9+gPNN2Jkm2UrpMaZWShjG3-z8g@mail.gmail.com>
 <al56t4zyjYlCl-20@pedro-suse.lan> <CAA1CXcD=zNg8q34DhsH8+BnXACA0TbD1+p4QEOCcY2u1qoie4g@mail.gmail.com>
 <al8k9mvfZRA27G7m@lucifer>
In-Reply-To: <al8k9mvfZRA27G7m@lucifer>
From: Nico Pache <npache@redhat.com>
Date: Tue, 21 Jul 2026 02:24:00 -0600
X-Gm-Features: AUfX_mzChMkOdwtz7T8jQTd_G1friJxmSB186B1SJoiWpZD_j9M5WJjDcjx9-rQ
Message-ID: <CAA1CXcBn4R-dFx_Hj-nmHP--KtuB096WPPfAAFSM3mywBUeLTA@mail.gmail.com>
Subject: Re: [PATCH 0/8] mm/khugepaged: collapse_file() cleanups
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DB-pAR00LZ2B-QdpsmYbzKcqdaaRMfx_EFaw3CzsaHI_1784622156
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CAE3C40006
X-Stat-Signature: ya6asxyy8te63h1quksozjwb5mtzqno8
X-Rspam-User: 
X-HE-Tag: 1784622159-325087
X-HE-Meta: U2FsdGVkX1/t19i8haZ3tdk3bJkDkPa5BO3L5v+afv/oU5m8hpGAUgYZoLAmWyhOU3O1dJp6OjcL/CtDRk1NYqaCaRMonBnz2lVxl/FfvlkX3WTVqavv5Pn91UCFpGuoY3Pdh+ANF8vQqU02QMJ/HBv7ZOlAAxX5gpq/pcYY+JKZCBoer9tce/BVY8dJds7zQBFEjWC2beWBj+B1V4hAKRHKYWctkaOLBZ5xO6h1LYAXhkJ+z4uRukcRjfgO1qipQAvSUUy/IAC8IxTpaa7XLtqF5ew45r1F5d6jFW32OaSxHacb2rkwXaNrnOBR3p4t8yFuVEZb+1+7W8RhCkODSDhifT+pseKrN3bjQ+Bj0jeBuHJYwnu7uLi2kAGhjZxBXR2XYcET4CP6FJd7fbGfCYPZppe4MxTjZ6eyTFazpeUSdl/3xTIdfIejuEtJgnLoWsrjRkjvjadsSL/SDwV55yPFu8XuCGIoklBqPm2/P8reQCYjPmrhHTrFphmXo0FF6gdP3M4nx01KRVGIGtc9dFriqtoNvZON8i3EeLHeHJ1vbh2SqKehCxHprzPjtkd1brhU/jb+miEvvoi59QsezNpUp1Qt8ZVCFZ9RMfeM/8dxbGDm8b+TT1O0gZk6FIvgM1ARRevOrU1/djFw12plLkJKXqqo3vVqdWwqoNTJ2rIXrSlMjTjmoWZbiy1dr+/7D0FdwPs1iT3xuAwv1xiHJOLDMr/Pv9SKPFPMCcSYNcLC4G1t2gUhZFK9PxHwE5ckoN1jC1i2sOVBQIPyI2hMH3+/2dvoPUvNZobWulHES1fyv3NdBuEK8OhmjQU76P8Ba6oZx6eTfm2k632yVlCFXm8Rsvmu4feu9yMzi4i2zUr3Zzj/qlN9yxQmH6N7ArZehNZuRBkBYv3SX16qXn0WDTMzqVJxUFRg1zMMqLPu0XckjV7BO2XQ71Mr9pNWVHEfZOHdY8kl3Lt7+5BvE7l
 5u93i0ZA
 IVfWv0+r+yblRMonE8zxVjaBuOQMaRkJyqA49joUN6yGomfn/gkmA2mfMkwAR1iTq+gPtZ8nsMyyXZoYW8y5vXPtZ5IS52hPFI8PUXGEv6sb238pJM+sA/h4yhpBE7DiVbmODh0KadewTelixpo1IrQVdMe3wlH8phPq2HgI3ZMRiuc0lTr85FCN89riaM97rhqn+oBEUuQQSE8MMtDP+dd15g5Qms5iZ2ZTXuIwmemlI7avWjv2U/VXJlxY3lYL2Xv/n4imgKw/YLnYMi6J1ZI2EtGueQoMkZ+XRihmjueu9saoYQiEjad6EEEvytVcur9m1Py5i/cLR89A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 1:55=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Mon, Jul 20, 2026 at 02:14:45PM -0600, Nico Pache wrote:
> > On Mon, Jul 20, 2026 at 1:49=E2=80=AFPM Pedro Falcato <pfalcato@suse.de=
> wrote:
> > >
> > > On Mon, Jul 20, 2026 at 09:21:11AM -0600, Nico Pache wrote:
> > > > On Mon, Jul 20, 2026 at 8:33=E2=80=AFAM Pedro Falcato <pfalcato@sus=
e.de> wrote:
> > > > >
> > > > > Here are a bunch of cleanups for collapse_file() that attempt to =
aid
> > > > > code readability and understanding. This is part 1 out of N, and =
only
> > > > > attempts to address the main collapse loop. The exit path is stil=
l a
> > > > > mess but I figure it's much easier to review if I send this batch=
 as-is,
> > > > > versus sending the whole thing.
> > > >
> > > > Hi Pedro,
> > > >
> > > > I have already prepped a cleanup series for collapse_file().
> > > >
> > > > I was waiting for my work here
> > > > https://lore.kernel.org/lkml/20260715025941.1571316-1-npache@redhat=
.com/
> > > > to be reviewed (and in mm-unstable) before sending it out.
> > > >
> > > > Our series have several similarities; for reference, here is my ver=
sion.
> > > > https://gitlab.com/npache/linux/-/commits/khugepaged_file_refactor?=
ref_type=3Dheads
> > >
> > > Ugh, this is awkward. Do you have any suggestions on next steps?
> >
> > Let me review your series and see what differences stand out. You
> > referenced part 1 of N; I think my series covers many of the other
> > parts. I basically broke down each stage of collapse_file() into
> > helpers, and cleaned up each part respectively.
> >
> > Whatever we decide, as long as collapse_file() gets the proper love im
> > ok with it. I did, however, communicate that I was cleaning this up to
> > David, Lorenzo, and others.
>
> Yeah I'm keen that we find a good compromise here, as I genuinely very mu=
ch
> empathise with both sides of this - being 'pipped' on a series is horribl=
e and
> we generally really want to avoid that.
>
> But I hope that some collaborative effort is possible here?

Yes definitely! Pedro's series covers only part of what my work
addresses. I think it will be pretty easy to take his work, and my
commits for the rest of the collapse_file() function.

>
> >
> > >
> > > I can try and take in some of your work on top of this series. But th=
at might
> > > be hairy.
> > >
> > > This situation really does suck (I've definitely been there), but I w=
ould
> > > prefer not to drop the patchset.
> >
> > Yeah that might be hard. However, there are other parts I cleaned up
> > that you haven't touched in this series so perhaps some of those apply
> > cleanly.
>
> It'd be ideal if you guys could figure out a way to combine both in a ser=
ies,
> perhaps with Co-Dev-By or similar?

I've reached out to him to coordinate this effort :)

Thanks,
-- Nico

>
> >
> > Cheers,
> > -- Nico
> >
> > >
> > > --
> > > Pedro
> > >
> >
>
> I'll leave it to you two to figure things out, I've left some review here
> already (the general thrust of the series is good and cleaning
> this... 'organically grown' code is a wonderful thing), but will pause un=
til you
> figure out a way forwards.
>
> Cheers, Lorenzo
>


