Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9131C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 12:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDBC8E0003; Tue, 22 Jul 2025 08:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E178E0001; Tue, 22 Jul 2025 08:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8738E0003; Tue, 22 Jul 2025 08:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D75578E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:17:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95A371603A4
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:17:01 +0000 (UTC)
X-FDA: 83691799842.12.A9F383D
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6B8E040005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:16:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gVrmMhvx;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753186619; a=rsa-sha256;
	cv=none;
	b=wLGOV+SS7d7uucft9X/EqIk78pdakk5YVdz4mfvuf7NzhS1rY7Vezofq/H4/dQs/xh4yZT
	MIt1fX8qZi3mypjyxt4KytXvOI013V8alT/mwKs4a0wiskuW/wuJfPTrnK8p8MgoD2rRTG
	+g7iENgcC1L/Q4qQsd8NhWrFBVQaj84=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gVrmMhvx;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753186619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2dh4GvcIefc0hFeVr2+yL7P2gWg4zPcsSe2xE6W3bs=;
	b=gqFUR7NneuVzq61sNa6WPFQszhX7jHuM3DQ/LhCrEgOh6Ud4diea3uIbR1LWCOIcWF5Q4N
	1/DJ27QOtajPTkN+BUhhF8if8In7/Ym55IfbV4/0chYuwq0VqEF24z6bUrhsV3FDUsmPrk
	WwyIaKe0f1AY0XptFay+CaxeWqS7YpU=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6fad3400ea3so50408366d6.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753186618; x=1753791418; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2dh4GvcIefc0hFeVr2+yL7P2gWg4zPcsSe2xE6W3bs=;
        b=gVrmMhvxwGItvhTubkIalH/3xxBj1IQyxnuw4wbNzVMp0Pxu2aRdWhn6UkLTGHILJ0
         /O05sUV0BDoeb9+40OHqJ0klarhaXynVThbKP9VjKg8jsQEE/FZsHgyocJWC7DyfUdRH
         LOPyNzAAUMxgS64EeMiS7AgCLb59V7ogkxRP8BuQEO5PBXYfZG/iGrs/JT0QUTn16VLP
         CXvy/w6yibFUMFDSUzj7VdZ9uTDYACsgdxMQ1+daukfRbokWnPnLE1Gh682SOCDUHxIW
         rA0QqzMSshZ2LdjhC86WJt4YHZaqg5qu7OJQH9c2Kiwo7Kwx1PHAnnFl5aI+ZxMdsSQ5
         qYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753186618; x=1753791418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d2dh4GvcIefc0hFeVr2+yL7P2gWg4zPcsSe2xE6W3bs=;
        b=ioWJg2AJsZavKbiExWQ8rLoAXsPGAEkhVi6jkyDYVI1nzq2AbWNr9FmaZWuqjQ0/Dz
         KTtGxexwX3Xxa5Z2E3scbB7lNiwomzAr1YOWOc6XsL+R0Pk6hNH+wg9Anbp9IgoA3BpW
         aNcNJJIGou6viEC0RMaPzHnMt47Km3B1qeTl0Sa5E42xTubFKCJ6gTOHWMaarNV4MDMp
         dalxeeOcIEbFZDsPOaL3eq/Sx7VCqkFgwyNH6DD/ilTOPfUA3V2+6mAg+7oUyTTGMNb4
         mycxeFMGn+0RUstvQCE4uGY5wdysZuJprtH5PLNVjxFMpClw50WXdlDryquOWhVHTr+T
         jycQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZkC49VPMUf9QudCuvXRiTnk8dqrGNkdjcoDwGBqoLKd1yxLIBdCMhvk6WgVvEdABi3jv52t8y9w==@kvack.org
X-Gm-Message-State: AOJu0Yx1GQ3h1qJumNu+mvEPwtAggYrVTSsU8HOKBaem37gTP4OJn+YF
	K0vL7kW9TePUkAYHuzfZEYO2BwC7+FlVyxCUdYXH40eU7igO2yhJoQ1xa+5fx6MjoIceuLNCfE/
	r3b2a+5sRU55o3c64M13ugxnQq6eE6SY=
X-Gm-Gg: ASbGnctbzF8VqdiVRECcDxsJH9V3sskjhWPlu8Lnp5joEHRxmYkUM9sC2GgxUZGZs0Y
	6uJ4SFUbLxwPwTp/Bu6NNW0kEY/9BIljPDE8e8xCd6tb50KfpMWNIBt6e4JGCv/U5AGbOekRGFe
	QphEvx/wATuOpmJFPJ9TGyuCTCZVhlV0mnkp/uo5Zi52V1RBT6UkJbbbwrFtgYDOHsMDVXPYc0p
	ewp/100
X-Google-Smtp-Source: AGHT+IHobXtgKhcXxKs5zE1UVYtEi4Qw+CLzI/vVtT8yLXo7N7RF6680jlqb/8T5JSOGZWQ0LwDWzc6hojOUMno0Hh4=
X-Received: by 2002:a05:6214:dc7:b0:6f8:a978:d46 with SMTP id
 6a1803df08f44-7050722961cmr354570346d6.19.1753186618099; Tue, 22 Jul 2025
 05:16:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250608073516.22415-1-laoar.shao@gmail.com> <b2fc85fb-1c7b-40ab-922b-9351114aa994@redhat.com>
 <CALOAHbD2-f5CRXJy6wpXuCC5P9gqqsbVbjBzgAF4e+PqWv0xNg@mail.gmail.com>
 <9bc57721-5287-416c-aa30-46932d605f63@redhat.com> <CALOAHbBoZpAartkb-HEwxJZ90Zgn+u6G4fCC0_Wq-shKqnb6iQ@mail.gmail.com>
 <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com> <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
 <404de270-6d00-4bb7-b84b-ae3b1be1dba8@redhat.com> <694a8b10-6082-44ac-8239-2c28b4ba8640@lucifer.local>
 <CALOAHbBepZiORN2yLvDDQWbvom38HHvCyqAqvS7uKzQqy8zgjg@mail.gmail.com> <dda67ea5-2943-497c-a8e5-d81f0733047d@lucifer.local>
In-Reply-To: <dda67ea5-2943-497c-a8e5-d81f0733047d@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 22 Jul 2025 20:16:20 +0800
X-Gm-Features: Ac12FXyMzY-ryTl9mU_SERXrlYB3V2uAa7Zc3M0QA5uuO-MZVuqrYonrF1COTzI
Message-ID: <CALOAHbDxjQrk4qjd4PouxfS=ZpR=HtL6Su53vsxvJWHckKoM_g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] mm, bpf: BPF based THP adjustment
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B8E040005
X-Stat-Signature: 8cxfsjx33wrauhusb7jzqzptyc4n54dt
X-HE-Tag: 1753186619-768226
X-HE-Meta: U2FsdGVkX19YgIi786nZxt1885WKL7gVEsNnOZ4L6QbyQ+JJsLgUM0hgu5zhQQkID4vqFL+A5KgvuydC+AtTGDwU9IQOL7uHQhQoX4hSdY4Jem5QBB3B1g8r7uMcTwJ7djqenf7qyPkQ4hNI+w55ZyfLMwGWjepQBfZBk1DZhWZEimUCzuTKV8Fqr2Jn9PoFsRvojHI0+5e31HG8ueLRpimThahu29pzvxgEnjqjomUH7KNoNX4UEPSKRzsztKn8ffzxZuZZAxrdrZnAsSZSIAvrBxxKi0kiG9YgRTQ/w2zRB5z3IWEbBd5REB/kSt8J9oXJzXJFajckCx8EuMM5kpTEL1/qs22Rh0kNXTnxB0nlmkhjJdUqaRh4tDZV/YrmNlbOIZZWeG+ydB1wXyFfspm3xDC5slV4zOFhMBRZB8AwI+vM9n+vH2lwGOkSJCGFW4CUtm8FOZ97O4x1J5WBG0uqTg49AY3LwunLqK5TXdYAaxTHQRcF+fLdK5aS4p7x+1cFmN2KMeHVpifSQnaq8Qn+5/+ELRR7D6ypcb5SnBeewcAsCY3BrzWZBDqIzgR4xjFe1iXU1hd+BvDdKJJpMxZ9Y/PMhx56q3aXDOq4m56L+7G4k7Cj2u6arCmEoQwrZTSi6QnxjDbe2Hj6z1qOT24vJsY1fHi1CjwGg7Ea377SdZ/XxEHhtwpWL+Uc0kf19Q6c7OV81ynVuxjVWK9ESYmgllKV7ZZlNvuZqiB1ajkx3uotTAMq7UgZ9JNurT+0/m1vT7kOt8r1qcUvMJ9Fl6Spo3THZ21Q+5464DHpO8Sxuo+RCE8CQv9gi+fC90L17I7SJK21JNSeT04dxWis3wouA84jph9v7Np5NCPgWPVOZ9JY8WHxvDXpvR7GrMelbNWwiag3MAVLP7x1NrJn5NvQhgZ50TEha07sK0dC1WRSE4X12jU520ycrvuVuLHZ+UMuIaC3W+Eyz0cuvn9
 ebI+qd3P
 n6Soymf2OF+IUKoQqdsE18rN+EOUQGtXYeg4AxuxdBOTs0hbpBPFmQZ+0MpaxjnEolb9l3DWyeMdN4RRZDVfFoPHwAhA8Cj37HUhbgVylXPwhF/qfu0/APuzX8ZDOTjLY0sMp9yS6JUEXY7FlGF3Gc0vhOzurjO44u15l1/Mb/5AhHHzqOGBVSpH87K3QxWloLfLZAHmkdv2SxW+0Hm5R/qgtovrozQlDfTExCHAe9Wz0kazKonUQBPHr0GipYsXhIXgxowsSA/YazPOqOzATqglEMM3tcmQgIiatNGzs78bHy0C3nYb8L2Y3+n4Wbz5tbWKheKdG5i375eeCNH6kJK71pAS5dLfyuXXWsT+JZ+vyhlokePKRim4W0cn0p7pGvRwHOLrqG/WGBJ+Ptk6YtS308gNxWD2nA9DDEdcWXOMdDp99U6d+Fl93rz/tDunPFE2jyfaLGc9Mxv1qVIidchv5Iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 8:05=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Jul 22, 2025 at 07:56:21PM +0800, Yafang Shao wrote:
> > On Tue, Jul 22, 2025 at 6:09=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Tue, Jul 22, 2025 at 09:28:02AM +0200, David Hildenbrand wrote:
> > > > On 22.07.25 04:40, Yafang Shao wrote:
> > > > > On Sun, Jul 20, 2025 at 11:56=E2=80=AFPM David Hildenbrand <david=
@redhat.com> wrote:
> > > > > >
> > > > > > > >
> > > > > > > > We discussed this yesterday at a THP upstream meeting, and =
what we
> > > > > > > > should look into is:
> > > > > > > >
> > > > > > > > (1) Having a callback like
> > > > > > > >
> > > > > > > > unsigned int (*get_suggested_order)(.., bool in_pagefault);
> > > > > > >
> > > > > > > This interface meets our needs precisely, enabling allocation=
 orders
> > > > > > > of either 0 or 9 as required by our workloads.
> > >
> > > That's great to hear, and to be clear my views align with David on th=
is - I
> > > feel like having a _carefully chosen_ BPF interface could be valuable=
 here,
> > > especially in the short to medium term where it will allow us to more
> > > rapidly iterate on an automated [m]THP mechanism.
> > >
> > > I think one key question here is - do we want to retain a _permanent_=
 BPF
> > > hook here?
> > >
> > > In any cae, for the first experiments with this we absolutely _must_ =
be
> > > able to express that this is going away, NO, not based on whether it'=
s
> > > widely used, it IS going away.
> >
> > If this BPF kfunc provides clear user value with minimal maintenance
> > overhead, what would be the rationale for removing it? That said, if
> > you and David both agree it should be deprecated, I won't object -
> > though I'd suggest following the standard deprecation process.
>
> You see herein lies the problem... :) from my point of view we want to ha=
ve
> the ability to choose, fundamentally.
>
> We may find out the proposed interface is unworkable, or sets assumptions
> we don't want to make.
>
> So I think hiding ehhind a CONFIG_ flag is the best idea here to really
> enforce that and make it clear.
>
> Personally I have a sense that we _will_ introduce something permanent. W=
e
> just need to have the 'space' to positively decide to do that once the
> experimentation is complete.

Thanks for your explanation.

>
> > > I find this documentation super contradictory. I'm sorry but you can'=
t
> > > have:
> > >
> > > "...can therefore be modified or removed by a maintainer of the subsy=
stem
> > >  they=E2=80=99re defined in when it=E2=80=99s deemed necessary."
> > >
> > > And:
> > >
> > > "kfuncs that are widely used or have been in the kernel for a long ti=
me
> > > will be more difficult to justify being changed or removed by a
> > > maintainer."
> > >
> > > At the same time. Let alone:
> > >
> > > "A kfunc will never have any hard stability guarantees. BPF APIs cann=
ot and
> > > will not ever hard-block a change in the kernel purely for stability
> > > reasons"
> > >
> > > Make your mind up!!
> > >
> > > I mean the EXPORT_SYMBOL_GPL() example isn't accurate AT ALL - we can
> > > _absolutely_ change or remove those _at will_ as we don't care about
> > > external modules.
> > >
> > > Really this seems to be saying, in not so many words, that this is
> > > basically a kAPI and you can't change it.
> > >
> > > So this strictly violates what we need here.
> >
> > The maintainers have the authority to make the final determination ;-)
>
> Well the kernel doesn't entirely work this way... pressure can come which
> impacts what others may do.
>
> If you have people saying 'hey we rely on this and removing it will break
> our cloud deployment' and 'hey I checked the docs and it says you guys ha=
ve
> to take this into account', I am not so sure Andrew or Linus will accept
> the patch.

understood.

>
> > > I wonder if we can use a CONFIG_xxx and put this behind that, which
> > > specifically says 'WE WILL REMOVE THIS'
> > > CONFIG_EXPERIMENTAL_DO_NOT_USE_THP_THINGY :P
> >
> > That's a reasonable suggestion. We could implement this function under
> > CONFIG_EXPERIMENTAL to mark it as experimental infrastructure.
>
> Thanks! Yes, I was looking for this flag :P didn't know if we still had
> that or not actually...
>
> But, yeah, putting it behind that explicitly also makes it very clearly.
>
> CONFIG_EXPERIMENTAL_BPF_FAULT_ORDER relies on CONFIG_EXPERIMENTAL makes i=
t
> you know... pretty clear ;)

Agreed. Let's move forward with the CONFIG_EXPERIMENTAL_BPF_FAULT_ORDER opt=
ion.

--=20
Regards
Yafang

