Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8ACDCCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 02:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216AD8E002B; Tue, 28 Oct 2025 22:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C77C8E0015; Tue, 28 Oct 2025 22:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08FFC8E002B; Tue, 28 Oct 2025 22:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E299F8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:49:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 895FC88CED
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:49:33 +0000 (UTC)
X-FDA: 84049621026.18.24A8AA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2400E20004
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:49:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f/HJIvex";
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761706171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h92Y7rYw8/HzWuXYRorO2diu575VdZCbMCBzaGVpQUo=;
	b=HqRELaBVCmO3WRUEAGQMvTpZA+HipfRn5VxWyZIpWITaDCb7SGagiyyYfHOIdmFb5MIKyO
	cWCnp7ZuSzVrLxSZQdwdcUA1mF5PYsRn/CH9o/sK80hjcoj6LV1yGCmvo9f2oefdYqy0Ah
	EAwBwBMvUaGVNlLgzuzm1YTfEkKg4hg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f/HJIvex";
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761706171; a=rsa-sha256;
	cv=none;
	b=kcWLfYw8i/BTVpwPwax+YBJ4jHPFM2Ef1Hj1uSRrp6K3dHYFmfmbFU8QPtyzOpL0Iuf/3g
	BBkNKgdFXMkhkVnh8Ch+ZnVXhqthPWhf0c7zibnZFQ7hSkvzzo2ki8mcwynBQy3TChudx4
	LmpAJBiYPg5cfnPQ406ZC/UqP28hCmo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761706170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h92Y7rYw8/HzWuXYRorO2diu575VdZCbMCBzaGVpQUo=;
	b=f/HJIvexjyyQImf6WSyjXt4T84a37F1o2uunEe55LtRIgEZ8o/evjF3IpDLJ2kU+QA/JDO
	pqcPud4fZnEDEBJL4c6TEiH+aNrVXvmJBRnpH92Eq5BDok3DP7UvPUlA1DFcbzPzvMhCw7
	4pwKsVCfq/PVCGLR2luJILSAcWNtsis=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-uEx1wI_zN1q-2WOklaNrKA-1; Tue, 28 Oct 2025 22:49:29 -0400
X-MC-Unique: uEx1wI_zN1q-2WOklaNrKA-1
X-Mimecast-MFC-AGG-ID: uEx1wI_zN1q-2WOklaNrKA_1761706168
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-63e0da26ae3so7894052d50.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761706168; x=1762310968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h92Y7rYw8/HzWuXYRorO2diu575VdZCbMCBzaGVpQUo=;
        b=neaX7qCmSAbmG7eAmRP0d/HrUoR0tjBDGixzA6ellMur9qquV9EQmwwan1EJIdeneC
         TCSjEdLuP+C8XSPwSEuq2DaiQ9Iks80i3RvW1Z4rPT2gXA/cVZd1SEE9JRhm1NHgTadi
         rgYrHh90bg1fwubOUwEkQTCaJoiMEt+czI+bNImlao8gDYbqrwBDfQgvYb75taOs5nKB
         fGORjQmdhY5eHR1XhtELFzE7AYPwIzysaPXGKkZZCHtPyL/EG2/2V5SP8ROa8ltny2Wl
         FLOUJMOLarqDMGj5ixwliroWISuYgQG+1hUS+90D8w6id4x9gscVo6ZsWpsb8IeR4YD3
         kB7g==
X-Forwarded-Encrypted: i=1; AJvYcCVesjr+4hMitPyNn7WIiMB/d2KeoochqxNy7fFDXLvm9kqvZY2jgBELRyqRFnst2ErVAXNVQ0mQfA==@kvack.org
X-Gm-Message-State: AOJu0YxiugEWvQA0sPjjcQSk43wSyfjh7MpehF3+OTLf/2ppw/PnphR0
	XFsFX7Y0KWptEBnPz36IlksaF4XPLfZNgc5fdGCleuKvfPNANV+NplOHB6S9B/lbMHB1Yoy/5q1
	CpM2QOqLFRzFOJPVxsDqbUFKvp4DjFXNlRz8sUqAHcgIVMbtOtVYeixDoJwVGEEALHbcTK0WDca
	hZw5YTs/KNEEmhwwLyGOZG3VSUe+0=
X-Gm-Gg: ASbGncu1BD5WvlpYDG+Vlo5IFS18Q0+L1OSJEPpjH4963z/s/jXIi6Naz4GtG3+HzpT
	0RBqnJ4B10WcSHC0SJl8kt8V0qRcB2wEYnkzMuLdCjhXU3Pie8XoV9WkxBrl6dYxeZewAKF91e3
	hTxUJSYRq7+yDe4VP8hVv3nGZGZHXXNgkEREUsJkk+6wyUL3wItLbtW68TQSrPU5iOQdpqOA==
X-Received: by 2002:a05:690e:250f:20b0:636:1fd9:1bc with SMTP id 956f58d0204a3-63f76cf06f3mr1198945d50.8.1761706168440;
        Tue, 28 Oct 2025 19:49:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2+S+SqyFRMMqZ9BBcbxZaKLM353wYfwsnFYvTcCq0eXDyRqvVmPjvLYl+RF0WlG3mbRYFqAF0GqQcXTMDS+k=
X-Received: by 2002:a05:690e:250f:20b0:636:1fd9:1bc with SMTP id
 956f58d0204a3-63f76cf06f3mr1198906d50.8.1761706167985; Tue, 28 Oct 2025
 19:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local> <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com> <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com> <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
 <b1f8c5e3-0849-4c04-9ee3-5a0183d3af9b@linux.alibaba.com>
In-Reply-To: <b1f8c5e3-0849-4c04-9ee3-5a0183d3af9b@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 28 Oct 2025 20:49:02 -0600
X-Gm-Features: AWmQ_blp9IluDmjAtMCdM5r156SzdEbYsEIrditchlutrZSTUbtfV3Xp8PTzX2E
Message-ID: <CAA1CXcDZoJEFi2_aDbOa19=zHZstV-v+i2z3bDxB8bin=6m3Dw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UUJEjJ5PPEc4mFv1z57-xGBWl8r7NW0MaZzaR-H3Rm8_1761706168
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iezau8gwwdpktzymmo4a9gxau4z78omx
X-Rspamd-Queue-Id: 2400E20004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761706170-612672
X-HE-Meta: U2FsdGVkX19RO+se3e2GbJlu3JZZzadnza7Uy+hMMXG8Zhubianijc9AgfRMMT3wwvJRpiEkCKykx55iOrmFHP8U92u8nnenCK7XAIwGDhjHlBlowTsYYds+FRO6erW51dHTZM9FsKcGKeZB1hxmRTfBTOYDRFpphJ7JEIfNGYPEpVx2R9IQG2jJXTJx4SdoQoPmWPcm4B1NGQTx5uNmJYkjxpf+NdeUBe/SouHmDZQK3ETaKTmIPeghboZKMuv+oU/ryOZUadFPvE8IP+NyxB6eKRX1Q59owwXrr21nJzwjMDL8U6n3eMT9SxDDcqa+0d0+Ue8KOhjbYq1AbL0m8Vtfgc/YrFGw23lcv5Kaz2tXYe3Zhh/Mb/8Ql8jCXpoweX6gbDDo7aolYlsmVKIKUnEIPby3xiQ9nGIawX6KZFO7PcgnPNfTIILwZXcQXFPeypk3QuaiS4v9De7RpFUCsQ7mjfzLI472+4urHavDt4/ETAuhj/m9YhN00+10/vPaTqIJ+XrL6pdeMUuToQczp7BUlNH6EA96ZdTVjHfk+4RkrKpcNxJ+/u9TVii4cu4wrmCjVibEScLD7kggOixYp6Sypk5jrO222AYH9J75rIVJHqhfkYYl/2SAlYND8g3nOOHbRUfZicEeuJ/epC3sNaJSr0st3lrPRh7FG+9wMBziDyj/5doKSvdqB05neYqhUWTL+ViYRzzu+PjNupRK4RBgDY8ONKu6saZJOxwYW7C/vQJxHXHCeTswkFMYH/0V4QHll8rVsBNBVQqqLqBxK/KPq4kXzsShww+HKfASEFJ/duAHr7fpdfWqbQ8qGrHI+gAzmE4QDGKSf9DZG1Pqt94DD8ouk8VjVAnCO8Ic2E0fz6PycIYVwjkgD1trg18oYmF53Z5ZPaTd7vHjFizwbILj9+ruUNhbf3y9zZSJ1YNEn7BYY8Ac+2A/UZibAJQLUjBbX1m/NJD1dIsyBtw
 TfZnIT5t
 hR3clcjyGKtdXJsAnM3PpTKuV6YE45CgdEVpFxMdBIShcw3hASyHJ7z48nLBKPNH4rAx8aGk1kAGmoAvm0xARhkxBQlo0O1i6nq2sG2HspA+GXvS60mHbjQ5ECODVGmHKo3W2SsZSZ1iA5eVddA6dLHMCRJWQ/sHOqdW8aDFoINfc0CzidRKdIQGVBoMfoQNallCMhyyQh9VgHN8Sk7Io9holxT0mpuRsE9h02OBU9rHgL3kSmBWXp29FgtL+fAo61KD+qte89etyaEXRpvZ+KaTWbrnr67dYoiumc3ZCfwThZm7pKmMOAZv6YvvKMNsUHxZYJegSyHndXWcL1luurC/qnrf52eQm7nmDIf65HGdPMtEzzk2aiS2hKr+CD/h2CIu98TUOdFPZc5ZjcjdJ19PNKo/Qrqt3fz03jlgcoj+HruH/M7sychysC1HJDZorJQLH0GLJK5/tM9uYjA2/UDH1umE4ZSanSvWb690BYJbthbXGo4hbfjjb0RjY5YAHPnv57dN9pRl6XpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 8:10=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/10/29 02:59, Lorenzo Stoakes wrote:
> > On Tue, Oct 28, 2025 at 07:08:38PM +0100, David Hildenbrand wrote:
> >>
> >>>>> Hey Lorenzo,
> >>>>>
> >>>>>> I mean not to beat a dead horse re: v11 commentary, but I thought =
we were going
> >>>>>> to implement David's idea re: the new 'eagerness' tunable, and aga=
in we're now just
> >>>>>> implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
> >>>>>
> >>>>> I spoke to David and he said to continue forward with this series; =
the
> >>>>> "eagerness" tunable will take some time, and may require further
> >>>>> considerations/discussion.
> >>>>
> >>>> Right, after talking to Johannes it got clearer that what we envisio=
ned with
> >>>
> >>> I'm not sure that you meant to say go ahead with the series as-is wit=
h this
> >>> silent capping?
> >>
> >> No, "go ahead" as in "let's find some way forward that works for all a=
nd is
> >> not too crazy".
> >
> > Right we clearly needed to discuss that further at the time but that's =
moot now,
> > we're figuring it out now :)
> >
> >>
> >> [...]
> >>
> >>>> "eagerness" would not be like swappiness, and we will really have to=
 be
> >>>> careful here. I don't know yet when I will have time to look into th=
at.
> >>>
> >>> I guess I missed this part of the converastion, what do you mean?
> >>
> >> Johannes raised issues with that on the list and afterwards we had an
> >> offline discussion about some of the details and why something unpredi=
ctable
> >> is not good.
> >
> > Could we get these details on-list so we can discuss them? This doesn't=
 have to
> > be urgent, but I would like to have a say in this or at least be part o=
f the
> > converastion please.
> >
> >>
> >>>
> >>> The whole concept is that we have a paramaeter whose value is _abstra=
cted_ and
> >>> which we control what it means.
> >>>
> >>> I'm not sure exactly why that would now be problematic? The fundament=
al concept
> >>> seems sound no? Last I remember of the conversation this was the case=
.
> >>
> >> The basic idea was to do something abstracted as swappiness. Turns out
> >> "swappiness" is really something predictable, not something we can ran=
domly
> >> change how it behaves under the hood.
> >>
> >> So we'd have to find something similar for "eagerness", and that's whe=
re it
> >> stops being easy.
> >
> > I think we shouldn't be too stuck on
> >
> >>
> >>>
> >>>>
> >>>> If we want to avoid the implicit capping, I think there are the foll=
owing
> >>>> possible approaches
> >>>>
> >>>> (1) Tolerate creep for now, maybe warning if the user configures it.
> >>>
> >>> I mean this seems a viable option if there is pressure to land this s=
eries
> >>> before we have a viable uAPI for configuring this.
> >>>
> >>> A part of me thinks we shouldn't rush series in for that reason thoug=
h and
> >>> should require that we have a proper control here.
> >>>
> >>> But I guess this approach is the least-worst as it leaves us with the=
 most
> >>> options moving forwards.
> >>
> >> Yes. There is also the alternative of respecting only 0 / 511 for mTHP
> >> collapse for now as discussed in the other thread.
> >
> > Yes I guess let's carry that on over there.
> >
> > I mean this is why I said it's better to try to keep things in one thre=
ad :) but
> > anyway, we've forked and can't be helped now.
> >
> > To be clear that was a criticism of - email development - not you.
> >
> > It's _extremely easy_ to have this happen because one thread naturally =
leads to
> > a broader discussion of a given topic, whereas another has questions fr=
om
> > somebody else about the same topic, to which people reply and then... y=
ou have a
> > fork and it can't be helped.
> >
> > I guess I'm saying it'd be good if we could say 'ok let's move this to =
X'.
> >
> > But that's also broken in its own way, you can't stop people from reply=
ing in
> > the other thread still and yeah. It's a limitation of this model :)
> >
> >>
> >>>
> >>>> (2) Avoid creep by counting zero-filled pages towards none_or_zero.
> >>>
> >>> Would this really make all that much difference?
> >>
> >> It solves the creep problem I think, but it's a bit nasty IMHO.
> >
> > Ah because you'd end up wtih a bunch of zeroed pages from the prior mTH=
P
> > collapses, interesting...
> >
> > Scanning for that does seem a bit nasty though yes...
> >
> >>
> >>>
> >>>> (3) Have separate toggles for each THP size. Doesn't quite solve the
> >>>>       problem, only shifts it.
> >>>
> >>> Yeah I did wonder about this as an alternative solution. But of cours=
e it then
> >>> makes it vague what the parent values means in respect of the individ=
ual levels,
> >>> unless we have an 'inherit' mode there too (possible).
> >>>
> >>> It's going to be confusing though as max_ptes_none sits at the root k=
hugepaged/
> >>> level and I don't think any other parameter from khugepaged/ is expos=
ed at
> >>> individual page size levels.
> >>>
> >>> And of course doing this means we
> >>>
> >>>>
> >>>> Anything else?
> >>>
> >>> Err... I mean I'm not sure if you missed it but I suggested an approa=
ch in the
> >>> sub-thread - exposing mthp_max_ptes_none as a _READ-ONLY_ field at:
> >>>
> >>> /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
> >>>
> >>> Then we allow the capping, but simply document that we specify what t=
he capped
> >>> value will be here for mTHP.
> >>
> >> I did not have time to read the details on that so far.
> >
> > OK. It is a bit nasty, yes. The idea is to find something that allows t=
he
> > capping to work.
> >
> >>
> >> It would be one solution forward. I dislike it because I think the who=
le
> >> capping is an intermediate thing that can be (and likely must be, when
> >> considering mTHP underused shrinking I think) solved in the future
> >> differently. That's why I would prefer adding this only if there is no
> >> other, simpler, way forward.
> >
> > Yes I agree that if we could avoid it it'd be great.
> >
> > Really I proposed this solution on the basis that we were somehow ok wi=
th the
> > capping.
> >
> > If we can avoid that'd be ideal as it reduces complexity and 'unexpecte=
d'
> > behaviour.
> >
> > We'll clarify on the other thread, but the 511/0 was compelling to me b=
efore as
> > a simplification, and if we can have a straightforward model of how mTH=
P
> > collapse across none/zero page PTEs behaves this is ideal.
> >
> > The only question is w.r.t. warnings etc. but we can handle details the=
re.
> >
> >>
> >>>
> >>> That struck me as the simplest way of getting this series landed with=
out
> >>> necessarily violating any future eagerness which:
> >>>
> >>> a. Must still support khugepaged/max_ptes_none - we aren't getting aw=
ay from
> >>>      this, it's uAPI.
> >>>
> >>> b. Surely must want to do different things for mTHP in eagerness, so =
if we're
> >>>      exposing some PTE value in max_ptes_none doing so in
> >>>      khugepaged/mthp_max_ptes_none wouldn't be problematic (note agai=
n - it's
> >>>      readonly so unlike max_ptes_none we don't have to worry about th=
e other
> >>>      direction).
> >>>
> >>> HOWEVER, eagerness might want want to change this behaviour per-mTHP =
size, in
> >>> which case perhaps mthp_max_ptes_none would be problematic in that it=
 is some
> >>> kind of average.
> >>>
> >>> Then again we could always revert to putting this parameter as in (3)=
 in that
> >>> case, ugly but kinda viable.
> >>>
> >>>>
> >>>> IIUC, creep is less of a problem when we have the underused shrinker
> >>>> enabled: whatever we over-allocated can (unless longterm-pinned etc)=
 get
> >>>> reclaimed again.
> >>>>
> >>>> So maybe having underused-shrinker support for mTHP as well would be=
 a
> >>>> solution to tackle (1) later?
> >>>
> >>> How viable is this in the short term?
> >>
> >> I once started looking into it, but it will require quite some work, b=
ecause
> >> the lists will essentially include each and every (m)THP in the system=
 ...
> >> so i think we will need some redesign.
> >
> > Ack.
> >
> > This aligns with non-0/511 settings being non-functional for mTHP atm a=
nyway.
> >
> >>
> >>>
> >>> Another possible solution:
> >>>
> >>> If mthp_max_ptes_none is not workable, we could have a toggle at, e.g=
.:
> >>>
> >>> /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_cap_collapse_none
> >>>
> >>> As a simple boolean. If switched on then we document that it caps mTH=
P as
> >>> per Nico's suggestion.
> >>>
> >>> That way we avoid the 'silent' issue I have with all this and it's an
> >>> explicit setting.
> >>
> >> Right, but it's another toggle I wish we wouldn't need. We could of co=
urse
> >> also make it some compile-time option, but not sure if that's really a=
ny
> >> better.
> >>
> >> I'd hope we find an easy way forward that doesn't require new toggles,=
 at
> >> least for now ...
> >
> > Right, well I agree if we can make this 0/511 thing work, let's do that=
.
> >
> > Toggle are just 'least worst' workarounds on assumption of the need for=
 capping.
>
> I finally finished reading through the discussions across multiple
> threads:), and it looks like we've reached a preliminary consensus (make
> 0/511 work). Great and thanks!
>
> IIUC, the strategy is, configuring it to 511 means always enabling mTHP
> collapse, configuring it to 0 means collapsing mTHP only if all PTEs are
> non-none/zero, and for other values, we issue a warning and prohibit
> mTHP collapse (avoid Lorenzo's concern about silently changing
> max_ptes_none). Then the implementation for collapse_max_ptes_none()
> should be as follows:
>
> static int collapse_max_ptes_none(unsigned int order, bool full_scan)
> {
>          /* ignore max_ptes_none limits */
>          if (full_scan)
>                  return HPAGE_PMD_NR - 1;
>
>          if (order =3D=3D HPAGE_PMD_ORDER)
>                  return khugepaged_max_ptes_none;
>
>          /*
>           * To prevent creeping towards larger order collapses for mTHP
> collapse,
>           * we restrict khugepaged_max_ptes_none to only 511 or 0,
> simplifying the
>           * logic. This means:
>           * max_ptes_none =3D=3D 511 -> collapse mTHP always
>           * max_ptes_none =3D=3D 0 -> collapse mTHP only if we all PTEs a=
re
> non-none/zero
>           */
>          if (!khugepaged_max_ptes_none || khugepaged_max_ptes_none =3D=3D
> HPAGE_PMD_NR - 1)
>                  return khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER -
> order);
>
>          pr_warn_once("mTHP collapse only supports
> khugepaged_max_ptes_none configured as 0 or %d\n", HPAGE_PMD_NR - 1);
>          return -EINVAL;
> }
>
> So what do you think?

Yes i'm glad we finally came to some consensus, despite it being a
less than ideal solution.

Hopefully the eagerness patchset re-introduces all the lost
functionality in the future.

Cheers
-- Nico

>


