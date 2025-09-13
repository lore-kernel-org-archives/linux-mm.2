Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 199DACA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A208E0007; Fri, 12 Sep 2025 20:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA228E0001; Fri, 12 Sep 2025 20:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0008E0007; Fri, 12 Sep 2025 20:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9D18E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:29:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B778A873EB
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:29:28 +0000 (UTC)
X-FDA: 83882343216.25.D166CE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 66A0FA000D
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:29:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LcNE/WBi";
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757723366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1fdhbuUsD9MQP0PGb9Ytw8aU7X4xbIFZ9UR7PMXzJY=;
	b=oC4MBEz/Wlzu7Y7tj0kcy4qF+eg/FoGrbCcEvpLq85eVCaUOBtUbqAtrOmvcvwO9UUKfo2
	hM2G3xl/q+N8RutVYYFG8StSEOd9nfMT5Ks5Shpp0NgCBJjwPR8CkQvRMQpLn50uTjybd6
	x/gsd1wxM4GhGRRW2hybJ4SWMrbI3xE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757723366; a=rsa-sha256;
	cv=none;
	b=r3lqlyTHnjzxgIP8zkX84OnKkASlDhdhrX0SvO2A7FsH/2/CJ3UnwovHUqmLawLKLvzUUc
	OoSro5H7PbVP8DEpV30nkjdo59nJ+cpkmkP8+cN1cttq9bsflofPlzCJyGXbD6+yi8hsxQ
	N3delYiQ6gVrBRJ/X58ObivEO6VCH64=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LcNE/WBi";
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757723365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s1fdhbuUsD9MQP0PGb9Ytw8aU7X4xbIFZ9UR7PMXzJY=;
	b=LcNE/WBiqzMOXRc5zebH292lco5qBXLi2Sz3pCgyawQHzxy3kTE3T4mTDW+gKZw0o64BWw
	ocGZjvCu2xy1yiG6MKHs90cx+7uSBbUpkHUgH7CzFJ0TK1qYxo1PYdTnvQNXW6o8K17OwY
	wc/W0/HrFNo/HTx+JVAwbCIr2SY7ZYQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-03EVwRfiOka007IplMDMlA-1; Fri, 12 Sep 2025 20:29:22 -0400
X-MC-Unique: 03EVwRfiOka007IplMDMlA-1
X-Mimecast-MFC-AGG-ID: 03EVwRfiOka007IplMDMlA_1757723362
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-729540b6278so26894467b3.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757723362; x=1758328162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s1fdhbuUsD9MQP0PGb9Ytw8aU7X4xbIFZ9UR7PMXzJY=;
        b=Evfcqxvp3lxCOI6psQxsnhQ63dr7QNMAK6+nQ/vgpccZlBhQ/FlY2X0JrzxI6CQl2h
         9nJKZoTC6pc6yQMPf98Rhfj+FIywvrLIHclqJJZv9Xn8KnojjvQo7LDo6Khv+GgqCn7I
         INpvqxQfPIcuQp+qMQu8Fgws3de/LZjm5lJ1tRvFPrmgphi/kgFGL10Cy+/ilnsHZ/+f
         9eCJm6HYk2Cp1Q1qI+eHtjh4XgjAhmmnc/F9hrtEzsfU5UK/BTUwrFlc/u9JQJPEn4s2
         r3H9haxz6OhiSmOn8NT342NzVkCMyLmmPeie+PNpAJslY5AeFOgSGPpNQ0ZG/Qs6tLoc
         FqXA==
X-Forwarded-Encrypted: i=1; AJvYcCXOBEZ0cAu533vluoUQXdf7gK/THydXNcw0SulTDrSURHP4uSt+4LVCWyHyGbjlrwRckEoQTW6FRQ==@kvack.org
X-Gm-Message-State: AOJu0YwZUec51di9xUw9SjqPHgbU8gQHU6U8KEX5y2lhzh/cpBrGuAoU
	vj3NM/plQhGkwRTy1/CUSofMJ6tIPRWiqYjd7GxIYr0Wo2lt8K4R1BlpG7OBgxls9DIo7kSpVws
	BFrHBQxW0aKlXGL4NAgNsBeWm5LaS5272/YIL5IG6SJvBQqQ1iSz94HXPTW+Z75kVG8RIlJ38SD
	hTLd7KoHFJAQQadL4RP9AmGAlU0WA=
X-Gm-Gg: ASbGncsOjDo4CXuvf1r9WPd5QS5gjlEsqbGpkWIH2tnQe8JNlxmU39+zNKS0IrGheiK
	eNqBwAPv+VJMVPm9p6NhTfhj7ASiilvWMWtHoKJTQvM2VV8+NDst1q/1ScrpFSlTOmxC6nHZ29E
	dOgTfXUV72ANwk86HULcVGAVBnujSEJ7wy9dU=
X-Received: by 2002:a05:690c:260a:b0:723:b6c4:3f1c with SMTP id 00721157ae682-730623e2925mr43228827b3.5.1757723361819;
        Fri, 12 Sep 2025 17:29:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP1ODcsVeOBTo/o3/Af/Xr6qV4tedAzQFkTLbisgc33kkPWRX3CWYPLhnD2DHm/8atuDvj5iDMrMVSvY62shE=
X-Received: by 2002:a05:690c:260a:b0:723:b6c4:3f1c with SMTP id
 00721157ae682-730623e2925mr43228427b3.5.1757723361261; Fri, 12 Sep 2025
 17:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250912032810.197475-1-npache@redhat.com> <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com> <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com> <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com> <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
 <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com> <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
In-Reply-To: <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Fri, 12 Sep 2025 18:28:55 -0600
X-Gm-Features: Ac12FXwNur65Nm5OvErIVCDdmRDdfURv-x3te_kyR-KK-IxwM19Wyqk2iaWoTIE
Message-ID: <CAA1CXcDyTR64jdhZPae2HPYOwsUxU1R1tj1hMeE=vV_ey9GXsg@mail.gmail.com>
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dGoFy5m0K5tc7M0byWWxy-LQfXt-yBloiMUWRqJ_8es_1757723362
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: byxqstkmcxeczw69qjdon6tsin8bdqja
X-Rspamd-Queue-Id: 66A0FA000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757723366-262345
X-HE-Meta: U2FsdGVkX1/7VhFI8DKiyzLasPw6gPyHyR8DVM+OT5a3//BUIpkK1SM0InLmSkThXF9iq+Rm1hoviSK3WaNuxSrvbEfGm22F554braJK5EnYMnAR6ErXISCNzDsjfWVmPD2AOxxwRRT+09D0vj3Obsv40IVuw2oqmN63qd7aV4Y5UiqShKb+RqxeNGh/ao8wx//oXBhzGDKfBnAT3vBT0Pr3P6VmnatcwHaUIeQCjdMQN6x+uSACKPrRBXlt7vv9gMvf2zVYZWXOuO3F0wZCZRMydJ3mKqQoOAgB370p8c+BHYRvj1ijkb+gwKM3+2bDOYGgWwGuk8sYgsTQoB/rMeRwM+EkuAeayhdMkgdCDenwm+eTjnLwH6M3I3U+CEP3muTdzV+E1Lp59H3SHWWn663fB6cCxP3sWS9gNYnREO4U3uXEkzwAWtXhfUmmTzu8EEh4+RvMPJwR6qanasGscawVGe2eNmuU+7YdGcvnXik0SrPvsZLyUSsxT24tN9O8AuIEsw/MF3WT/Ta5oltXbhiw6GH8d5liGkQh9n4C4Z/Sqo09KfEIEGdkLXa1AFk9Jabtgw8HHsOa4CGwaTomhAO8E66gMxG0wAk0f9wKfje6iQMrWJlBnGSxpfLAYVFgBrQqRY++PDCQhsTptWzCheJ6nF0IS7/kZSaHlEppMF07wtgez8mOEYwv29kNM96SBxu3l1tzHEOzKR1GRibRcovwVB+vbP+UVooP64ThviADuoFm/P1Ct6BbOA4S+GRFDqKJOmT+zCqOh2tYepvxVEAUOYJzauINyeucMe321r3yPJuGeUGP9lshYHMDkIls12JKpv9gEzM9dln50C2oit2VlbUR1EUsSsk9wvCHTDdGc7VmuedDGeXme8PFu+0whqZyzX9xMNzivQoi0Ci4u59aIUH4pco7r9Quh5opKLG9lSbkY4fIUxyfSLKy4jR+Xfa7aP5d7oVNt+wrnAm
 iBg1T/+L
 RBq3TYtVUWkrq3ld4Gpfp5gguC/XgOk5JgeqKgv8vhQoU59eWvdVmflN9iIsWeeF2RmLmc1QZOrZjZPJshuFBuIKK2yYs5rZgjM3KfCrk72y4CKL1b1W5C43IxRIXLr07zDoXy7XkRlwrxg9ol3Hqfe1lETZT66S2SCHp3qRNiniXTAs526CFNvo1UYTtkHtTByZgK44hbTcGKGlbpQh/M216d5osBLd5CRRJdYuTZ0TlukYQVSBy1tRKdLXJa52D6RBGXsQJNM1w668T5cEhuP73AOGAPtHyRX9NHzAxLR2k2NDeguFLJn89UVU7VxmiQUiX+fGkG2SAStS/RtCux4rW/uwlvUMvj3EM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 12:22=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Sep 12, 2025 at 07:53:22PM +0200, David Hildenbrand wrote:
> > On 12.09.25 17:51, Lorenzo Stoakes wrote:
> > > With all this stuff said, do we have an actual plan for what we inten=
d to do
> > > _now_?
> >
> > Oh no, no I have to use my brain and it's Friday evening.
>
> I apologise :)
>
> >
> > >
> > > As Nico has implemented a basic solution here that we all seem to agr=
ee is not
> > > what we want.
> > >
> > > Without needing special new hardware or major reworks, what would thi=
s parameter
> > > look like?
> > >
> > > What would the heuristics be? What about the eagerness scales?
> > >
> > > I'm but a simple kernel developer,
> >
> > :)
> >
> > and interested in simple pragmatic stuff :)
> > > do you have a plan right now David?
> >
> > Ehm, if you ask me that way ...
> >
> > >
> > > Maybe we can start with something simple like a rough percentage per =
eagerness
> > > entry that then gets scaled based on utilisation?
> >
> > ... I think we should probably:
> >
> > 1) Start with something very simple for mTHP that doesn't lock us into =
any particular direction.
>
> Yes.
>
> >
> > 2) Add an "eagerness" parameter with fixed scale and use that for mTHP =
as well
>
> Yes I think we're all pretty onboard with that it seems!
>
> >
> > 3) Improve that "eagerness" algorithm using a dynamic scale or #whateve=
r
>
> Right, I feel like we could start with some very simple linear thing here=
 and
> later maybe refine it?

I agree, something like 0,32,64,128,255,511 seem to map well, and is
not too different from what im doing with the scaling by
(HPAGE_PMD_ORDER - order).

>
> >
> > 4) Solve world peace and world hunger
>
> Yes! That would be pretty great ;)
This should probably be a larger priority
>
> >
> > 5) Connect it all to memory pressure / reclaim / shrinker / heuristics =
/ hw hotness / #whatever
>
> I think these are TODOs :)
>
> >
> >
> > I maintain my initial position that just using
> >
> > max_ptes_none =3D=3D 511 -> collapse mTHP always
> > max_ptes_none !=3D 511 -> collapse mTHP only if we all PTEs are non-non=
e/zero
> >
> > As a starting point is probably simple and best, and likely leaves room=
 for any
> > changes later.
>
> Yes.
>
> >
> >
> > Of course, we could do what Nico is proposing here, as 1) and change it=
 all later.
>
> Right.
>
> But that does mean for mTHP we're limited to 256 (or 255 was it?) but I g=
uess
> given the 'creep' issue that's sensible.

I dont think thats much different to what david is trying to propose,
given eagerness=3D9 would be 50%.
at 10 or 511, no matter what, you will only ever collapse to the
largest enabled order.
The difference in my approach is that technically, with PMD disabled,
and 511, you would still need 50% utilization to collapse, which is
not ideal if you always want to collapse to some mTHP size even with 1
page occupied. With davids solution this is solved by never allowing
anything in between 255-511.

>
> >
> > It's just when it comes to documenting all that stuff in patch #15 that=
 I feel like
> > "alright, we shouldn't be doing it longterm like that, so let's not mak=
e anybody
> > depend on any weird behavior here by over-domenting it".
> >
> > I mean
> >
> > "
> > +To prevent "creeping" behavior where collapses continuously promote to=
 larger
> > +orders, if max_ptes_none >=3D HPAGE_PMD_NR/2 (255 on 4K page size), it=
 is
> > +capped to HPAGE_PMD_NR/2 - 1 for mTHP collapses. This is due to the fa=
ct
> > +that introducing more than half of the pages to be non-zero it will al=
ways
> > +satisfy the eligibility check on the next scan and the region will be =
collapse.
> > "
> >
> > Is just way, way to detailed.
> >
> > I would just say "The kernel might decide to use a more conservative ap=
proach
> > when collapsing smaller THPs" etc.
> >
> >
> > Thoughts?
>
> Well I've sort of reviewed oppositely there :) well at least that it need=
s to be
> a hell of a lot clearer (I find that comment really compressed and I just=
 don't
> really understand it).

I think your review is still valid to improve the internal code
comment. I think David is suggesting to not be so specific in the
actual admin-guide docs as we move towards a more opaque tunable.

>
> I guess I didn't think about people reading that and relying on it, so ma=
ybe we
> could alternatively make that succinct.
>
> But I think it'd be better to say something like "mTHP collapse cannot cu=
rrently
> correctly function with half or more of the PTE entries empty, so we cap =
at just
> below this level" in this case.

Some middle ground might be the best answer, not too specific, but
also allude to the interworking a little.

Cheers,
-- Nico
>
> >
> > --
> > Cheers
> >
> > David / dhildenb
> >
>
> Cheers, Lorenzo
>


