Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3A6D116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EF56B0023; Fri, 28 Nov 2025 06:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175A86B0029; Fri, 28 Nov 2025 06:57:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CE26B002B; Fri, 28 Nov 2025 06:57:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED2D66B0023
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:57:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DAD2C02E0
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:57:35 +0000 (UTC)
X-FDA: 84159866070.06.BD66F70
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id C83291A000D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:57:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AsYY1WTg;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764331053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSoz5mQr0C5gRN2Ge/i9Yo5+y9sk31wpTRrQrK2SkC8=;
	b=EGF1HgAMW9demFRyn7k5N/c7gpTc2WDLuq0qsCdqGyhWnVi/NYEo6840R8FSdt/0NtlLzt
	k7MDLztrunXtQPbM/T/ZThfpgkroegBAJIJfcpkdw4lq81LwufWwZZ39dvSixc3uyU70pV
	u0ypJd265F+Nb7Cd5tDFi54nnKqIxdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764331053; a=rsa-sha256;
	cv=none;
	b=FBD6o0oHptzwWGvQkoFVTlVoSY+4Q1VgK/zBRidhSDaMe+/NhCNkQLLuuq7G9AF25qFvoy
	BLtC/UUchUHVxiqBCBbXYyAWluaKj6WXV8Ys0Prh1to9IWPdJOpia6pvu84OoEQXx+RWul
	EI2+W2GAbbx/PxXXctmvI8r300EgHzU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AsYY1WTg;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78ab039ddb4so17459447b3.3
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764331053; x=1764935853; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSoz5mQr0C5gRN2Ge/i9Yo5+y9sk31wpTRrQrK2SkC8=;
        b=AsYY1WTgfWztZ3R9PStyes6khvfClxHjvgxmNHwR6I/RqDkQC6z3MESpkd8r7oUknN
         AxyDnjUnEBCILl8lZ3min5LMicGSIZPSkFSY9BzpnCMzwRG7+iH9Fy5CdJS1hf8iG+cl
         /ZD7fG0+d+/RYBuRztar8aAQHwmhdMCNlg6NfEykZkqr8fLb5lN1jlHtea/rrmAwPmjo
         M9tcVw93w+SfkMnrd6gq+F9UbNoP3UHrSkH23lV448yHdXnE9sGbN5Dir/24I+GcoVJO
         vQIbKzUy4K6OgRZMpsObHmj957XQni3OC+aFFhBluWnX33CmxpdB2hC064ajA5d+QdE6
         q2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764331053; x=1764935853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gSoz5mQr0C5gRN2Ge/i9Yo5+y9sk31wpTRrQrK2SkC8=;
        b=GAh/Lv7v6e7LZELvCkmmsIEn4BBRFKaHo8h+ubVEFP+/JRDOFUAM1jN+E+w/UyI5Qy
         ummFmZnYB0ASyEmhJGwdfaU0QphPWIj7g/v1r4+rcBb45uRnxMC9QKWbhZuVzLKA/XII
         qEJ34lm+TqRobszx+z4A3fbGlLzg1ped1ZcVBlVxe2dkyKslVwGy9a6HzCQG4S7joagR
         0O/9LF+WYSe9TwG+30712xBGDZZ4Y9+D1EQKi/8n6pvONSFEYEKPk+P7fWGkTZ6WWm4X
         9ns8AQ9dwUtLLtgga5r1pIDrOIvSgTKeTRtytAYN8trcPpxcij/SXTLwbH8diBcIaZbQ
         TFXw==
X-Forwarded-Encrypted: i=1; AJvYcCW7DxFb0xCfmPuVF7Kpin+/z5EYBpOPtZoVm+v+l4IyPGepE/QIlVyelfkmdeUoaJFkktaKgXVoLw==@kvack.org
X-Gm-Message-State: AOJu0Yy6/jzp4IIlVRcwkdNFunUV5OmSAqm6U1Hbv5GCkI1dOp0DH2Rh
	Ul8Ecb3xuKsXtfAErYzCSAYGKrS+Nqqc54OOyuznVlnpcq7KHEe9RZCtU87iYMy5kmnQ9SeKrLA
	kQkjLe45H83l9UuCnCi/8Bgq3qHWEnOQ=
X-Gm-Gg: ASbGncs9NALyYYwBLyicqc3HFf6sXBr1E+tsnhzJZAiChwXWLX1ZuIeve5L5aXVLSF1
	ua2QOrngyiqf7Zg4NcZ27OaMaN9ae7eylmk0/sE2l8jBl+stm+7R0CcgtsnaTrSRdmRk9cAG/0y
	aSpZXz4T0qbP4d1C/dkbWdTsoP390GcaxNYWl9NHzGpe7TbA5Mj3rHziEBHpMd+6OSgeD8Okd07
	A8xJU0Lkrc4dBQ1EfiALsSlMuildT28IzX6weCW+73Ag9jbEiggIUUTvkHmt8KnnYjLnj2C
X-Google-Smtp-Source: AGHT+IFRUZUm0H2b+bWVRr2BWpWoFVKWpDn3PfEUe6fVjR2EnnNFYAQAFqsnu6tHnPe8vua5E8J/KHecd//puPJ1jS8=
X-Received: by 2002:a05:690c:fd5:b0:786:6ea6:aead with SMTP id
 00721157ae682-78a8b529371mr246113467b3.38.1764331052571; Fri, 28 Nov 2025
 03:57:32 -0800 (PST)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
 <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
 <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
 <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org> <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
 <48878c07-6e8c-47eb-bc8e-13366c06762a@lucifer.local> <CALOAHbBKxHDuGoND5xwxsScKY6aW8eiqE5QuHppd25RpYHf_pQ@mail.gmail.com>
 <f60522c2-e10f-45b1-9501-9b1e4223d8ce@lucifer.local>
In-Reply-To: <f60522c2-e10f-45b1-9501-9b1e4223d8ce@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 28 Nov 2025 19:56:48 +0800
X-Gm-Features: AWmQ_bnqWwXTq4TuyG2RQq6Xi3n6bW3cclMnGJoiJQyROyofbb3HErIQ1NShStw
Message-ID: <CALOAHbCVGX3C6mbbH+e5bB2=Cnz-UVbEVBXZWP3fvhqGe9LSXg@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C83291A000D
X-Stat-Signature: 1e1t9o4mjcfnz73ra7uew8o7wgqjyoh6
X-HE-Tag: 1764331053-973397
X-HE-Meta: U2FsdGVkX18KtmY+ELR0Uz8Ux5zUpgJQgaIOsR2OgBGkKLa1kI3BXeQriJtRCjEfPgCLBahKU9BTcB1E7hJgl2sr6wQjpP2dr4V832gkwgDv6gSokUU+7NcHhf3L8qX9x/7kKSMRmQICkW6HdBQ7WqUa9DvguqTPQzd6kpuw8MaJ2ydIqUrOexx3+dHEzT0epT4XCXBER92S8sTGMR+n2PKlcclfqgbKCsNy1SqDoD8O9FJepG5ZWvYFQWnqa2bSf+z5bbNxBxlM2kDZzgDvt6VwK+eq162KjEo0pu7fZW2kZO2e3UHmbqhr2hJNEo4g8DDf+kOeLya9WIlTuQnxu8xvchf0sz+D1bG8YIW/yD+3uFabt0OC+DDtgmEDZDV2D645IvBUx8/7WZVooE8Mjr4wGx3zq2FuQguID8RZQjJmdIs5nwMbwMgs78chBRkJAAUZbCOEt2UnLLZIkkYXPHYucz7B+DngM9413Lr5QourSyQ90Y6P7BW06B1HCajT2YZBZaewa2Fu4UO0vb8mUmMwykrJ0sIIQbHO9zwPv0G0g3jAcaqd7W/7REyBRBLVyMNo24t36rpAyR7MoPXZQBYVqCWMcfFF1NpacYdxaLH7E1TrHtva60xMU6Fp00Csolu4pgydLkXvv4on9B4tW2p514pEiXOC2WGpGxMcNwOTSbY/brzYTXJOsnSR/FCMVrEgRAcI1JYg9E9+CuqBj50P7a2j3z01yM7v9BKedgWBiC+qT0sWb9b7mxeRFVJuMn/79cBkO+N+GBa16ymiuxKt9J/KJq8D6Uz/IOh/L4y9vxMhEGSV4a+T1K/gOStodAC7uKcKkmAG4OfGA6gB/CwQOcptid5rjrQb+QjU1uZiG9bvpBRn2/RBvDEpLwUCrFVJ6yShvbpYtYQbYhuSueUEAHFUPgO3jqL2aLahCMWPveJf3zYOBzcDI61vty2/+SNpdrTFqw0lIdj9uxd
 3yu58nRU
 B7N2Bn+2O1m7MrjfpU+Av0kFO7u13KW/pEUa/kkB351X12hbe4Rlkb9pDCrx4tHKxBMNNJiRPBt7CJWHjYI+zfiiN787Za9Y8rSMmcSakEa5rygLYbTOqEQlUgEQ2LoCUdKBYkWYqBVkVQvMS35aeU4GJ7uJ7VDCwo5/31BxkR44UDcMWnvIGRCImnJglmFzmoz+DXL9vvs5yy4RtCZWy2ypnRWP4zRs9Ut0zvU4L3rOjFnbrkhbNhHcJzHQivd47uZpQQyD81JHZZaRzZda34fU7xY/wmxgPAjiVZ2uyMHsOVW/S7ICZoVT8jPxXe5a0vhQI3yOXiirpxoLYkmcoiqEFtAsJFCGRyVcO6sJeakkjclYYsHV0yI8VVXoObW3wVYJKmOoqodFZXbndQ59pw4Z1cwl8Hj1iAjGNfKgOk+tlWzwkCZSLP2y5Mf6P8lN4SrnHCo+Ctf8m9a62MiOFf0GZ+GAxw4X8u3rF0d7x8JFZZHt5CcUerRdaVTpnuNmnRmIbEVZ8UnRvHHaGwyWBwdR7tUuOxaSYke0W3EfmH7g4ZhzIRSIvwRIEHYRRmkhCYPinZsqbQQKkkpOTFF/jGko11f35xUfUWX/++QRH7DOA6r4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 4:31=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Nov 28, 2025 at 04:18:10PM +0800, Yafang Shao wrote:
> > On Fri, Nov 28, 2025 at 3:57=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > TL;DR - NAK this series as-is.
> > >
> > > On Fri, Nov 28, 2025 at 10:53:53AM +0800, Yafang Shao wrote:
> > > > Thank you for sharing this.
> > > > However, BPF-THP is already deployed across our server fleet and bo=
th
> > > > our users and my boss are satisfied with it. As such, we are not
> > > > considering a switch. The current solution also offers us a valuabl=
e
> > > > opportunity to experiment with additional policies in production.
> > >
> > > Sorry Yafang, this isn't how upstream works.
> > >
> > > I've not been paying attention to this series as I have been waiting =
for
> > > you and Alexei to reach some kind of resolution before diving back in=
.
> > >
> > > But your response here is _very_ concerning to me.
> > >
> > > Of course you're welcome to deploy unmerged arbitrary patches to your
> > > kernel (as long as you abide by the GPL naturally).
> > >
> > > But we've made it _very_ clear that this is an - experimental - featu=
re,
> > > that might go away at any time, while we iterate and determine how us=
eful
> > > it might be to users in general.
> > >
> > > Now it seems that exactly the thing I feared has already happened - p=
eople
> > > ignoring the fact we are hiding this behind an, in effect,
> > > CONFIG_EXPERIMENTAL_PLEASE_DO_NOT_RELY_ON_THIS flag.
> >
> > Thank you for your concern. We have a dedicated kernel team that
> > maintains our runtime. Our standard practice for new kernel features
> > is to first validate them in our production environment. This ensures
> > that any feature we propose to upstream has been proven in a
> > real-world, large-scale use case.
>
> This strictly contradicts the intent of the config flag. I seem to recall
> asking to put 'experimental' in the flag name also to avoid people assumi=
ng
> this is permanent or at least permanently implemented as-is. But this
> iteration of the series doesn't...

Ah, I understand your point now.

The CONFIG_EXPERIMENTAL_PLEASE_DO_NOT_RELY_ON_THIS flag was changed in v9:

  https://lore.kernel.org/linux-mm/20250930055826.9810-1-laoar.shao@gmail.c=
om/

The change was suggested by Randy and Usama:

  https://lwn.net/ml/all/a5015724-a799-4151-bcc4-000c2c5c7178@infradead.org=
/

At that time, you were on holiday, so you may have missed this update.

>
> I no longer believe this flag achieves the stated goal, which is to give =
us
> latitude to make changes in the future based on internal changes to THP
> (which so sorely needs them).
>
> I fear we will end up with users depending on it should we ship any form =
of
> BPF hook that we aren't 100% certain is 'future proof', so it raises the
> bar for this work very substantially.
>
> So I am really of a mind that we shouldn't be taking any such series at
> this point in time.

understood.

>
> >
> > >
> > > This means that I am no longer confident this approach is going to wo=
rk,
> > > which inclines me to reject this proposal outright.
> > >
> > > The bar is now a lot higher in my view, and now we're going to need
> > > extensive and overwhelming evidence that whatever BPF hook we provide=
 is
> > > both future proof as to how we intend THP to develop and of use to mo=
re
> > > than one user.
> > >
> > > Again as David mentioned, you seem to be able to achieve what you wan=
t to
> > > achieve via the extensions we added to PR_SET_THP_DISABLE.
> >
> > We see no compelling reason to switch to PR_SET_THP_DISABLE. BPF-THP
> > has proven to be perfectly stable across our production fleet, and we
> > have the full capability to maintain it.
>
> Again, this is entirely your prerogative, but it doesn't imply that other
> users will need this feature themselves.

Right, we=E2=80=99re not trying to force anyone else to use it.
We=E2=80=99re simply sharing our use case with upstream.
It=E2=80=99s up to the maintainers to decide whether to accept it.

>
> >
> > >
> > > That then reduces the number of users of this feature to 0 and again
> > > inclines me to reject this approach entirely.
> >
> > I understand your concern. Our intention is simply to contribute a
> > feature that we have found valuable in production, in the hope that it
> > may benefit others as well. We of course respect the upstream process
> > and are fully prepared for the possibility that it may not be
> > accepted.
>
> Right.
>
> >
> > >
> > > So for now it's a NAK.
> > >
> > > >
> > > > In summary, I am fine with either the per-MM or per-MEMCG method.
> > > > Furthermore, I don't believe this is an either-or decision; both ca=
n
> > > > be implemented to work together.
> > >
> > > No, it is - the global approach is broken and we won't be having that=
.
> >
> > Let me rephrase for clarity: I see the per-MM and per-MEMCG approaches
> > as compatible. They can be implemented together, potentially as a
> > hybrid approach.
>
> OK sorry I think I misread this/misinterpreted you here - the objection w=
as
> to the global approach.
>
> Yes sure perhaps we could.
>
> I mean we end up back in the silly 'THPs are not a resource' argument the
> cgroup people put forward when it comes to memcg + THP (I don't
> agree...). But let's not open that can of worms again :)
>
> >
> > --
> > Regards
> > Yafang
> >
>
> Sorry to push back so harshly on this, but I do it out of concern for our
> future ability to tame THP into something more sensible than the - frankl=
y
> - mess we have now.
>
> I feel like we must defend against painting ourselves into any kind of
> corner worse than we already have :)

Understood.

--
Regards

Yafang

