Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDE2CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B208E000F; Mon,  8 Sep 2025 18:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523178E0009; Mon,  8 Sep 2025 18:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA6B8E000F; Mon,  8 Sep 2025 18:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20DBD8E0009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:30:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0B5B5876C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:30:24 +0000 (UTC)
X-FDA: 83867527968.07.AE2B060
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 215991C0010
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:30:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i9tuXIgj;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757370622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuBSBS77fLiZ01S6XlZstaeJabhz4EUgYXQ1pptjeNc=;
	b=Ow7M3fF907AP+wgLupEn0tV8mrp0JEe26LY1ecHw1hJ80Bty68Q3uigj1+K5uT8doX+aH/
	tgDfJl/OS9NDH9PDga1SPlYjtyfLInKpM/xhDVuYctJ8V1aa72DfDu/WQPpb1XPzVqJB0R
	X8xWQ5smsv/iaFsQHrn5B6K3qsUQFXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757370622; a=rsa-sha256;
	cv=none;
	b=gmKqjPG6IZs3A4Gphf9GaLpG2AvPCuV9jzZNLB9Cl3Wu+avmAlJIb0tLCj4uFqmLSbOE33
	g6TMiZtBbchoBkaY+hjyMMF2UbcuF/DLMWkPwtAM5bHaQjhu89mvUCHOzoTEoEDDMJGgD/
	xYbIi1CEchIjBfaj1qa3/nwoTdBKE28=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i9tuXIgj;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757370621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tuBSBS77fLiZ01S6XlZstaeJabhz4EUgYXQ1pptjeNc=;
	b=i9tuXIgj8O3iWHgjKzoXo6IDqgl8KIgFaQ2mZlStRBRMBN5uRjUCwT+riZEISu+4t7eZnI
	LQWJKYc/+S5vY4TuYxKd/RfHw5eEgCcjgOiF/Gq71M8uUmTacpwt2fJQysc61Iev5DFu5Y
	CWISyv0AfW2+q2n3CK9ykGbnlf3u0nU=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-EEhhvOj1Ovav-RvvmsQSuw-1; Mon, 08 Sep 2025 18:30:20 -0400
X-MC-Unique: EEhhvOj1Ovav-RvvmsQSuw-1
X-Mimecast-MFC-AGG-ID: EEhhvOj1Ovav-RvvmsQSuw_1757370619
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-72268d0ab97so78936607b3.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757370619; x=1757975419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tuBSBS77fLiZ01S6XlZstaeJabhz4EUgYXQ1pptjeNc=;
        b=rMnoCnzi1gDHeA37nQt93Lf/7/WvHY/WTZL3z2DQcw0ISFtGhXyQujUOaxe9jDOOyM
         0pFpWUzNaea0gc+oqZ9Oqltnq3HmzCbWOdU+029tzZDKmmZA9jHp8UrRq0QmDooVSM0S
         lGo582TxG3MsrB70rrLGxYHc8hl3/iT+APiojr9RKl1DLAbWmPDWZNB5nLEvZQ69M4+o
         IFxkIFiFkwnGgEdbuj0rcA+1LxaMYkCK264jlPrLVtscGKNGYeaCKvjNof3gYm/yGyzg
         5on7B6vFNzCiM4hYpLUXDBN++oL31gzHrJDkqPH+2bmvoSokPJ/scpTd1T9ZMyF6GN0x
         44qw==
X-Gm-Message-State: AOJu0YxNXNxkvcrW+z2+/M1Q16PR/AvZ3IaGKKaDGZjQrUdGL1TQFOKy
	5+1CB9FGXk60cOD+/I32KomkZR7JtRcokSQ0GeRRFteuDlviWu9NW3dmz/XNYp5dSC8ASgpGoPC
	V8OKuNqc/85RAGRlPGe2y5OG7OXm49Xk4JZVG6gDSQrxLk15KtaCosGv8wGCX6VmZmrpeTtLE5K
	D1IpmFYU7kdeyaSMs2r4h59Lig71Y=
X-Gm-Gg: ASbGncsy/eulP/8iBV8gko0Wn46I6UqxClKsnb74CBIZNH6zOAdGBk0YP1NRQaBq8DQ
	g5hk6OcOy20CyV/+Wb3VdneSS0R7Rc3aLSqMUB5pj1bh1ZrlHtsGmfApScsRsdN1hJYz6MDB28a
	jiZWWafAz7eXURYDDWK+CiO8iGsq/rm2sLiCA=
X-Received: by 2002:a05:690c:7408:b0:725:1bc6:7cd5 with SMTP id 00721157ae682-727f5445e67mr93170437b3.42.1757370618502;
        Mon, 08 Sep 2025 15:30:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH31H6K+ZcTASit17Y0ZxgzXeZlmrla0/fRdSn17L0x/LTaqTzhntfPc5CwoX8HS0OdRkOnof/kUpXCvOiC6FA=
X-Received: by 2002:a05:690c:7408:b0:725:1bc6:7cd5 with SMTP id
 00721157ae682-727f5445e67mr93169547b3.42.1757370617345; Mon, 08 Sep 2025
 15:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <20250819134205.622806-7-npache@redhat.com>
 <06d1b76f-039c-4d6f-a03d-9253b14b5e8f@lucifer.local> <CAA1CXcDPF5cHF8HEtc28AToyHpDeGLjgYD17X42U3ksiNAFvSQ@mail.gmail.com>
 <9df57e91-3909-4ec3-a039-3ca29f741775@lucifer.local>
In-Reply-To: <9df57e91-3909-4ec3-a039-3ca29f741775@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Mon, 8 Sep 2025 16:29:51 -0600
X-Gm-Features: Ac12FXxZI4Tmyzizo4VoVGsYt8mPUTZi2_Pj86ZlMFxW2ReT-GJxQ2ZYaYVAeKc
Message-ID: <CAA1CXcBZxk3BGu+i5=MWvQo+SPQYqHVrQswzhFQga6Y4McEbVQ@mail.gmail.com>
Subject: Re: [PATCH v10 06/13] khugepaged: add mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eoZfShhBGfYVQYBbN9G3lNypn9CAchws2AZPeIvBrJo_1757370619
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 215991C0010
X-Stat-Signature: ps8fdw1ytqjttmror8ou199nrucpjp5y
X-Rspam-User: 
X-HE-Tag: 1757370621-164114
X-HE-Meta: U2FsdGVkX1+1/eLIfsmM0aojakUO4P2drOA5c6VuRS6xHGQkz95Eju5XPwQPdgiI0q9XGyiNaOeQSRQSryuYCEpoH+JM/F5KDpuuMAD9QqaLgEY7DvGE6BKaxUx7Sc7l4dKeaXkLd2eXmsDOu/VJmgW8hXYNpdB34A5RWbuq6TyGrCwrwpd+Kx4x3A+GchEuLksSFfh22gTnyNSlNv2WAwx2kEkhOl+zQ3qU1VVw9B6xMrVunz0oER/Z4SR+5aWYl2v7KLKM2ze7UGK+Kb8VnxvAKVktkSVzvrc9TJOJ9xSW5/engL5Z+zv/yKfsYXNEf3sm6q70YwZc8X3/Ib4XKAyxNVycTOQ7l88tJXKIcXmYsMM3OzhkawuGHn2GYSWtcJHgh5S4suRHj0bQERGojxjkeRi5nIPQSCdRcyyiTIGY0pSQZQv75+mQHKWJJu/FTXnbApgVO22tbuby/DsOX4sG9CfO8DlxiqOswrmtxxgJv0F8e63aS/IYU9OcJegH35K/g01r3zoZ5ag/+o9szMT51N2KU2NJvhNtiAOQkGQqNg1pGIqY0BURQeXfzC1RDWPM+snMltV+uhc+XhywxQdi3uP37xDk2lg6eFhaqwM49t8gaDidRtsTnmhJT/+/WjW6wbAeDqU/NWf8iA2BS7H+pTvwI+avzvOAP5jSPkHwJ4pncX8wdaww32M1yJwCa5IXLzQhX831jM3SWzbe7Kp7EeDuNpE+S0KPcEwABQrl0x2HSHoQZAhFTjOrWM9VEqPxQoClfq9fG3t+GrEg42NGbTr0QiNR3abb1DNoSC0eObFPMpFq/blpRCxyX3TwvfOFlijjrYYqACofMF8EuN8gmfttwP8HMVkBiF8mercv8Wcumy1VHHhq92bWG16pEvHIdIXRlYPt4+IhSgGbXTskGFwRBfRVBo53hRDNQYTysTrQzadhhOfKmjZPlji7FNOS62NJoTy34hEiKbL
 /IXfBxfX
 leoQrw7nO5W+fGboNq2RPauzKRR8Ddecj3FM8h7cOg8QmjIq50irieOf3hBDoNlAOnzsJXtY8Z8A+zHSeMdnyY/Tzxe3SZyzZ9KeSdHP0p05x+6ikFKmVNJudkrPAriBZFCOdnevMVC/QBWVOW6moyDhRoCE12Vc9Ax7B+Wp1ZneIvTymxLlZpuS6qOSZb9ImO9rkTJ6yNh99OkJQ8FqfjkHczP2FGNVtava3jJubKDgnRS1dYZ32JVZhBUfneut1IKsJHn+WtXVYnw8nvNZHw/4IwOIYpyi/GqpRWtcdM5R+Os/e7Xej2vafqCglN+C7ClFrKv5HaOqlvMYdF4SzWYxyVI8KnK/0WWsMaUkyv4qfVsSfQ3+2Nzz4cuYWHdmN6gl0WlQ548VjI0AyCv6EtUOJxh1oyS6H3j1mh4CLrorIs5+cHHhLfygSwggk0jWo0BlQQ776ey77mjs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 4:15=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> You've not responded to a ton of comments, I'm guesing I should assume in
> those cases you're acking the comments implicitly? :) Do let me know.
Yes! If they are obvious nits, then implicit ack.

Sorry I wrote my response over a couple of days while making changes
based on the review and trying to figure out a solution to the "creep"
issue, and forgot to thoroughly review all the comments before sending
this out. I'll make sure to go through it again.
>
> On Tue, Sep 02, 2025 at 02:12:38PM -0600, Nico Pache wrote:
> > On Wed, Aug 20, 2025 at 12:30=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Tue, Aug 19, 2025 at 07:41:58AM -0600, Nico Pache wrote:
> > > > Introduce the ability for khugepaged to collapse to different mTHP =
sizes.
> > > > While scanning PMD ranges for potential collapse candidates, keep t=
rack
> > > > of pages in KHUGEPAGED_MIN_MTHP_ORDER chunks via a bitmap. Each bit
> > > > represents a utilized region of order KHUGEPAGED_MIN_MTHP_ORDER pte=
s. If
> > > > mTHPs are enabled we remove the restriction of max_ptes_none during=
 the
> > > > scan phase so we don't bailout early and miss potential mTHP candid=
ates.
> > > >
> > > > A new function collapse_scan_bitmap is used to perform binary recur=
sion on
> > > > the bitmap and determine the best eligible order for the collapse.
> > > > A stack struct is used instead of traditional recursion. max_ptes_n=
one
> > > > will be scaled by the attempted collapse order to determine how "fu=
ll" an
> > > > order must be before being considered for collapse.
> > > >
> > > > Once we determine what mTHP sizes fits best in that PMD range a col=
lapse
> > > > is attempted. A minimum collapse order of 2 is used as this is the =
lowest
> > > > order supported by anon memory.
> > > >
> > > > For orders configured with "always", we perform greedy collapsing
> > > > to that order without considering bit density.
> > > >
> > > > If a mTHP collapse is attempted, but contains swapped out, or share=
d
> > > > pages, we don't perform the collapse. This is because adding new en=
tries
> > > > can lead to new none pages, and these may lead to constant promotio=
n into
> > > > a higher order (m)THP. A similar issue can occur with "max_ptes_non=
e >
> > > > HPAGE_PMD_NR/2" due to the fact that a collapse will introduce at l=
east 2x
> > > > the number of pages, and on a future scan will satisfy the promotio=
n
> > > > condition once again.
> > > >
> > > > For non-PMD collapse we must leave the anon VMA write locked until =
after
> > > > we collapse the mTHP-- in the PMD case all the pages are isolated, =
but in
> > > > the non-PMD case this is not true, and we must keep the lock to pre=
vent
> > > > changes to the VMA from occurring.
> > > >
> > > > Currently madv_collapse is not supported and will only attempt PMD
> > > > collapse.
> > >
> > > Yes I think this has to remain the case unfortunately as we override
> > > sysfs-specified orders for MADV_COLLAPSE and there's no sensible way =
to
> > > determine what order we ought to be using.
> > >
> > > >
> > > > Signed-off-by: Nico Pache <npache@redhat.com>
> > >
> > > You've gone from small incremental changes to a huge one here... for =
the
> > > sake of reviewer sanity at least, any chance of breaking this up?
> > I had this as two patches (one for the bitmap and one for implementing
> > it), but I was asked to squash them :/
>
> Yeah it makes sense to combine those two, but maybe there's a better way =
of
> splitting things out.
I'll give it a shot but most of this patch belongs together in my eyes.
>
> > >
> > > > ---
> > > >  include/linux/khugepaged.h |   4 +
> > > >  mm/khugepaged.c            | 236 +++++++++++++++++++++++++++++----=
----
> > > >  2 files changed, 188 insertions(+), 52 deletions(-)
> > > >
> > > > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.=
h
> > > > index eb1946a70cff..d12cdb9ef3ba 100644
> > > > --- a/include/linux/khugepaged.h
> > > > +++ b/include/linux/khugepaged.h
> > > > @@ -1,6 +1,10 @@
> > > >  /* SPDX-License-Identifier: GPL-2.0 */
> > > >  #ifndef _LINUX_KHUGEPAGED_H
> > > >  #define _LINUX_KHUGEPAGED_H
> > > > +#define KHUGEPAGED_MIN_MTHP_ORDER    2
> > >
> > > I guess this makes sense as by definition 2 pages is least it could
> > > possibly be.
> > Order, so 4 pages, 16kB mTHP
>
> Right, misread that! :) sorry. I guess then in fact there is no such thin=
g
> as an order-1 mTHP? I did wonder how useful that'd be so makes more sense
Anon memory does not support order 1 THPs, im not sure if there are
any plans do so either.
>
> > >
> > > > +#define KHUGEPAGED_MIN_MTHP_NR       (1 << KHUGEPAGED_MIN_MTHP_ORD=
ER)
> > >
> > > Surely KHUGEPAGED_MIN_NR_MTHP_PTES would be more meaningful?
> > Sure!
>
> Thanks!
>
> > >
> > > > +#define MAX_MTHP_BITMAP_SIZE  (1 << (ilog2(MAX_PTRS_PER_PTE) - KHU=
GEPAGED_MIN_MTHP_ORDER))
> > >
> > > This is confusing - size of what?
> > We need it like this due to ppc64 (and maybe others?), it used to be
> > based on PMD_ORDER, but some arches fail to compile due to the PMD
> > size only being known at boot time.
>
> That really sucks. Do please put this context in a comment though (see
> below for more discussion on this).
Ok, will do. although with my most recent changes we might just be
able to get rid of this all together.
>
> >
> > This compiles to 9 on arches that have 512 ptes.
> > so 1 << (9 - 2) =3D=3D 128
>
> What I'm saying is - what is this expressed in? There's no information on
> that here.
In my next implementation its probably going to be gone, but what it
indicates is the bitmap size (128), where each bit equals a range of 4
pages. 128 *4 =3D 512.
>
> So from what you say I can see it's the number of bits required in the
> bitmap, because we're being smart and only bothering to mark entries at a
> granularity of minimum mTHP size.
>
> OK so the idea is this is the number of PTE entries per entry in the
> bitmap.
Yeah it was an optimization that I was going for, but on second
thought it's probably pretty useless and causes some inaccuracies in
the max_ptes_none scaling and collapsing.
>
> This is KEY missing context. We really need to spell things out here, the
> THP code is... confusing :) to put it politely, so we need to be especial=
ly
> careful to be mega clear.
Yeah its rather confusing, sorry, but I think my newer implementation
that gets rid of this is actually much cleaner.
>
> So please please PLEASE add a comment explaining all this. And clearly
> state that the unit here is bits.
ack, I'll be more clear with my newer implementation, and it should be
easier to understand anyways.
>
>
> > >
> > > If it's number of bits surely this should be ilog2(MAX_PTRS_PER_PTE) =
-
> > > KHUGEPAGED_MIN_MTHP_ORDER?
> > This would only be 7? We need a 128 bit bitmap
>
> Again missing context is you're storing bits per minimum mTHP as per abov=
e.
>
> > >
> > > This seems to be more so 'the maximum value that could contain the bi=
ts right?
> > >
> > > I think this is just wrong though, see below at DECLARE_BITMAP() stuf=
f.
> > >
> > > > +#define MTHP_BITMAP_SIZE  (1 << (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_=
MTHP_ORDER))
> > >
> > > Hard to know how this relates to MAX_MTHP_BITMAP_SIZE?
> > >
> > > I guess this is the current bitmap size indicating all that is possib=
le,
> > > but if these are all #define's what is this accomplishing?
> > One for compile time one for runtime. Kind of annoying but it was the
> > easiest solution given the architecture limitations.
>
> OK, this context is fantastic + important for understanding, so let's put
> it in a comment :)
Or just get rid of it ;)
>
> > >
> > > For all - please do not do (1 << xxx)! This can lead to sign-extensio=
n bugs at least
> > > in theory, use _BITUL(...), it's neater too.
> > ack, thanks!
>
> OK sorry, based on David's feedback on this - just use 1UL << xxx here in=
stead.
ack
>
> (An aside that isn't really relevant now but - also I was wrong to sugges=
t
> _BITUL() anyway BIT() is The Way (TM), for some reason I had it in my hea=
d
> that the former was better :P)
>
> > >
> > > NIT but the whitespace is all screwed up here.
> > >
> > > KHUGEPAGED_MIN_MTHP_ORDER and KHUGEPAGED_MIN_MTHP_NR
> > >
> > > >
> > > >  #include <linux/mm.h>
> > > >
> > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > index 074101d03c9d..1ad7e00d3fd6 100644
> > > > --- a/mm/khugepaged.c
> > > > +++ b/mm/khugepaged.c
> > > > @@ -94,6 +94,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_has=
h, MM_SLOTS_HASH_BITS);
> > > >
> > > >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> > > >
> > > > +struct scan_bit_state {
> > > > +     u8 order;
> > > > +     u16 offset;
> > > > +};
> > > > +
> > > >  struct collapse_control {
> > > >       bool is_khugepaged;
> > > >
> > > > @@ -102,6 +107,18 @@ struct collapse_control {
> > > >
> > > >       /* nodemask for allocation fallback */
> > > >       nodemask_t alloc_nmask;
> > > > +
> > > > +     /*
> > > > +      * bitmap used to collapse mTHP sizes.
> > > > +      * 1bit =3D order KHUGEPAGED_MIN_MTHP_ORDER mTHP
> > >
> > > I'm not sure what this '1bit =3D xxx' comment means?
> > A single bit represents 1 << MIN_MTHP_ORDER (4) pages. Ill express that=
 better
>
> Yeah again, this is the missing context that would have helped me feel a
> lot less confused here :P
>
> > >
> > > > +      */
> > > > +     DECLARE_BITMAP(mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
> > >
> > > Hmm this seems wrong.
> > Should be a bitmap with 128 bits (for 4k page size). Not sure what's wr=
ong here.
> > >
> > > DECLARE_BITMAP(..., val) is expessed as:
> > >
> > > #define DECLARE_BITMAP(name,bits) \
> > >         unsigned long name[BITS_TO_LONGS(bits)]
> > >
> > > So the 2nd param should be number of bits.
> > >
> > > But MAX_MTHP_BITMAP_SIZE is:
> > >
> > > (1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
> > >
> > > So typically:
> > >
> > > (1 << (9 - 2)) =3D 128
> > >
> > > And BITS_TO_LONGS is defined as:
> > >
> > > __KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
> > >
> > > So essentially this will be 128 / 8 on a 64-bit system so 16 bytes to
> > > store... 7 bits?
> > I think you mean 64. 8 would be BYTES_PER_TYPE
> > >
> > > Unless I'm missing something here?
> > Hmm, unless the DECLARE_BITMAP is being used incorrectly in multiple
> > places, DECLARE_BITMAP(..., # of bits) is how this is intended to be
> > used.
> >
> > I think it's an array of unsigned longs, so each part of the name[] is
> > already 64 bits. hence the divide.
>
> Yup again this is due to the missing context above.
>
> > >
> > > > +     DECLARE_BITMAP(mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
> > >
> > > Same comment as above obviously. But also this is kind of horrible, w=
hy are
> > > we putting a copy of this entire bitmap on the stack every time we de=
clare
> > > a cc?
> > The temp one is used as a scratch pad, Baolin also finds this useful
> > in his file mTHP collapse useful for another use as well.
>
> Saying 'scratch pad' is really just saying 'temporary' using different
> words :) this isn't hugely helpful.
When doing the "recursion", there is no easy way to read the bitmap
between bits N0-N1, so we must manipulate it to extract that data;
however, we still want to preserve the original state of the bitmap.
The temp_bitmap is used to do these bit manipulations while not
destroying the original state. I will see if there's a better way to
read arbitrary ranges of the bitmap so we dont need to have two
copies, but IIRC there is not-- I might have to expand the bitmap API
to include this.
>
> If we _need_ this we should give this a better name, and I also don't kno=
w
> why we need this on the stack for all collapse_control users. Can't you
> just have your 'scratch pad' local to the function that needs it or passe=
d
> as a pointer?
If I cant find a solution to the problem above I will look into moving
it to the local stack.
>
> I'm sure it'd be useful to somebody to stick various temporary things in
> vm_area_struct for instance, but it'd be hugely egregious to do so...
The reason I didnt see this as a huge issue, is there is only one
global CC that is reused for all khugepaged runs. It's a one time
allocation and does not scale.
>
> >
> > In general khugepaged always uses the same CC, so it doesn't not
> > having to constantly allocate this.
>
> You're putting a LOT of data on the stack, and kernel stacks are very
> delicate, I'm quite concerned about this.
>
> BEFORE:
>
> struct collapse_control {
>         bool                       is_khugepaged;        /*     0     1 *=
/
>
>         /* XXX 3 bytes hole, try to pack */
>
>         u32                        node_load[64];        /*     4   256 *=
/
>
>         /* XXX 4 bytes hole, try to pack */
>
>         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
>         nodemask_t                 alloc_nmask;          /*   264     8 *=
/
>
>         /* size: 272, cachelines: 5, members: 3 */
>         /* sum members: 265, holes: 2, sum holes: 7 */
>         /* last cacheline: 16 bytes */
> };
>
> 272 bytes.
>
> AFTER:
>
> struct collapse_control {
>         bool                       is_khugepaged;        /*     0     1 *=
/
>
>         /* XXX 3 bytes hole, try to pack */
>
>         u32                        node_load[64];        /*     4   256 *=
/
>
>         /* XXX 4 bytes hole, try to pack */
>
>         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
>         nodemask_t                 alloc_nmask;          /*   264     8 *=
/
>         long unsigned int          mthp_bitmap[2];       /*   272    16 *=
/
>         long unsigned int          mthp_bitmap_temp[2];  /*   288    16 *=
/
>         struct scan_bit_state      mthp_bitmap_stack[128]; /*   304   512=
 */
>
>         /* size: 816, cachelines: 13, members: 6 */
>         /* sum members: 809, holes: 2, sum holes: 7 */
>         /* last cacheline: 48 bytes */
> };
>
> 816 bytes.
>
> So you're roughly tripling the size of this struct and making this a thin=
g
> in all callstacks that reference collapse_control.
>
> Kernel stack is a _super_ finite resource.
>
> I mean I can't really review your stack implementation thing until you've
> added a comment to help me understand what you are doing there (sorry but
> it's just too fiddly for me to first principles it), but I wonder if we
> truly need to be doing this?
>
> I wonder if we can just put this into somewhere allocated...
>
> > >
> > > > +     struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_SIZE]=
;
> > > > +};
> > > > +
> > > > +struct collapse_control khugepaged_collapse_control =3D {
> > > > +     .is_khugepaged =3D true,
> > > >  };
> > >
> > > Why are we moving this here?
> > Because if not it doesn't compile.
>
> A reason as to why this is the case would be helpful :)
>
> But fair enough!
>
> > >
> > > >
> > > >  /**
> > > > @@ -854,10 +871,6 @@ static void khugepaged_alloc_sleep(void)
> > > >       remove_wait_queue(&khugepaged_wait, &wait);
> > > >  }
> > > >
> > > > -struct collapse_control khugepaged_collapse_control =3D {
> > > > -     .is_khugepaged =3D true,
> > > > -};
> > > > -
> > > >  static bool collapse_scan_abort(int nid, struct collapse_control *=
cc)
> > > >  {
> > > >       int i;
> > > > @@ -1136,17 +1149,19 @@ static int alloc_charge_folio(struct folio =
**foliop, struct mm_struct *mm,
> > > >
> > > >  static int collapse_huge_page(struct mm_struct *mm, unsigned long =
address,
> > > >                             int referenced, int unmapped,
> > > > -                           struct collapse_control *cc)
> > > > +                           struct collapse_control *cc, bool *mmap=
_locked,
> > > > +                           unsigned int order, unsigned long offse=
t)
> > > >  {
> > > >       LIST_HEAD(compound_pagelist);
> > > >       pmd_t *pmd, _pmd;
> > > > -     pte_t *pte;
> > > > +     pte_t *pte =3D NULL, mthp_pte;
> > > >       pgtable_t pgtable;
> > > >       struct folio *folio;
> > > >       spinlock_t *pmd_ptl, *pte_ptl;
> > > >       int result =3D SCAN_FAIL;
> > > >       struct vm_area_struct *vma;
> > > >       struct mmu_notifier_range range;
> > > > +     unsigned long _address =3D address + offset * PAGE_SIZE;
> > >
> > > This name is really horrible. please name it sensibly.
> > >
> > > It feels like address ought to be consistently the base of the THP or=
 mTHP
> > > we wish to collapse, and if we need something PMD aligned for some re=
ason
> > > we should rename _that_ to e.g. pmd_address.
> > >
> > > Orrr it could be mthp_address...
> > >
> > > Perhaps we could just figure that out here and pass only the
> > > address... aligning to PMD boundary shouldn't be hard/costly.
> > >
> > > But it may indicate we need further refactorisation so we don't need =
to
> > > paper over cracks + pass around a PMD address to do things when that =
may
> > > not be where the (m)THP range begins.
> > Ok i'll rename them, but we still need to know the PMD address as we
> > rely on it for a few key operations.
> > Can we leave _address and rename address to pmd_address?
>
> No, we absolutely cannot leave _address as '_address', that's terrible an=
d
> I'm just not going to live with that.
>
> I know it's trivial, but it's just such a horrid naming convention.
Ok Ill rename it to something else!
>
> > >
> > > >
> > > >       VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > > >
> > > > @@ -1155,16 +1170,20 @@ static int collapse_huge_page(struct mm_str=
uct *mm, unsigned long address,
> > > >        * The allocation can take potentially a long time if it invo=
lves
> > > >        * sync compaction, and we do not need to hold the mmap_lock =
during
> > > >        * that. We will recheck the vma after taking it again in wri=
te mode.
> > > > +      * If collapsing mTHPs we may have already released the read_=
lock.
> > > >        */
> > > > -     mmap_read_unlock(mm);
> > > > +     if (*mmap_locked) {
> > > > +             mmap_read_unlock(mm);
> > > > +             *mmap_locked =3D false;
> > > > +     }
> > > >
> > > > -     result =3D alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER=
);
> > > > +     result =3D alloc_charge_folio(&folio, mm, cc, order);
> > > >       if (result !=3D SCAN_SUCCEED)
> > > >               goto out_nolock;
> > > >
> > > >       mmap_read_lock(mm);
> > > > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, c=
c,
> > > > -                                      BIT(HPAGE_PMD_ORDER));
> > > > +     *mmap_locked =3D true;
> > > > +     result =3D hugepage_vma_revalidate(mm, address, true, &vma, c=
c, BIT(order));
> > >
> > > I mean this is kind of going back to previous commits, but it's reall=
y ugly
> > > to pass a BIT(xxx) here, is that really necessary? Can't we just pass=
 in
> > > the order?
> > Yes and no... currently we only ever pass the bit of the current order
> > so we could get away with it, but to generalize it we want the ability
> > to pass a bitmap of the available orders. Like in the case of future
> > madvise_collapse support, we would need to pass a bitmap of possible
> > orders.
>
> Can we just change that when we need it?
Sure, it was more so that I generalized it for madv_collapse and
khugepaged, but then we dropped madv_collapse support, and I never
undid the change.
>
> 'Future proofing' for an possible future implementation detail is just no=
t
> how we should implement things.
>
> Right now we don't do that, so let's just pass the order. If in future we
> want to change it we can.
ack
>
> > >
> > > It's also inconsistent with other calls like
> > > e.g. __collapse_huge_page_swapin() below which passes the order.
> > >
> > > Same goes obv. for all such invocations.
> > >
> > > >       if (result !=3D SCAN_SUCCEED) {
> > > >               mmap_read_unlock(mm);
> > > >               goto out_nolock;
> > > > @@ -1182,13 +1201,14 @@ static int collapse_huge_page(struct mm_str=
uct *mm, unsigned long address,
> > > >                * released when it fails. So we jump out_nolock dire=
ctly in
> > > >                * that case.  Continuing to collapse causes inconsis=
tency.
> > > >                */
> > > > -             result =3D __collapse_huge_page_swapin(mm, vma, addre=
ss, pmd,
> > > > -                                                  referenced, HPAG=
E_PMD_ORDER);
> > > > +             result =3D __collapse_huge_page_swapin(mm, vma, _addr=
ess, pmd,
> > > > +                                                  referenced, orde=
r);
> > > >               if (result !=3D SCAN_SUCCEED)
> > > >                       goto out_nolock;
> > > >       }
> > > >
> > > >       mmap_read_unlock(mm);
> > > > +     *mmap_locked =3D false;
> > > >       /*
> > > >        * Prevent all access to pagetables with the exception of
> > > >        * gup_fast later handled by the ptep_clear_flush and the VM
> > > > @@ -1198,8 +1218,7 @@ static int collapse_huge_page(struct mm_struc=
t *mm, unsigned long address,
> > > >        * mmap_lock.
> > > >        */
> > > >       mmap_write_lock(mm);
> > > > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, c=
c,
> > > > -                                      BIT(HPAGE_PMD_ORDER));
> > > > +     result =3D hugepage_vma_revalidate(mm, address, true, &vma, c=
c, BIT(order));
> > > >       if (result !=3D SCAN_SUCCEED)
> > > >               goto out_up_write;
> > > >       /* check if the pmd is still valid */
> > > > @@ -1210,11 +1229,12 @@ static int collapse_huge_page(struct mm_str=
uct *mm, unsigned long address,
> > > >
> > > >       anon_vma_lock_write(vma->anon_vma);
> > > >
> > > > -     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr=
ess,
> > > > -                             address + HPAGE_PMD_SIZE);
> > > > +     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, _add=
ress,
> > > > +                             _address + (PAGE_SIZE << order));
> > >
> > > This _address is horrible. That really does have to change.
> > >
> > > >       mmu_notifier_invalidate_range_start(&range);
> > > >
> > > >       pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
> > > > +
> > >
> > > Odd whitespace...
> > >
> > > >       /*
> > > >        * This removes any huge TLB entry from the CPU so we won't a=
llow
> > > >        * huge and small TLB entries for the same virtual address to
> > > > @@ -1228,19 +1248,16 @@ static int collapse_huge_page(struct mm_str=
uct *mm, unsigned long address,
> > > >       mmu_notifier_invalidate_range_end(&range);
> > > >       tlb_remove_table_sync_one();
> > > >
> > > > -     pte =3D pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> > > > +     pte =3D pte_offset_map_lock(mm, &_pmd, _address, &pte_ptl);
> > >
> > > I see we already have a 'convention' of _ prefix on the pmd param, bu=
t two
> > > wrongs don't make a right...
> > >
> > > >       if (pte) {
> > > > -             result =3D __collapse_huge_page_isolate(vma, address,=
 pte, cc,
> > > > -                                                   &compound_pagel=
ist,
> > > > -                                                   HPAGE_PMD_ORDER=
);
> > > > +             result =3D __collapse_huge_page_isolate(vma, _address=
, pte, cc,
> > > > +                                                   &compound_pagel=
ist, order);
> > > >               spin_unlock(pte_ptl);
> > > >       } else {
> > > >               result =3D SCAN_PMD_NULL;
> > > >       }
> > > >
> > > >       if (unlikely(result !=3D SCAN_SUCCEED)) {
> > > > -             if (pte)
> > > > -                     pte_unmap(pte);
> > >
> > > Why are we removing this?
>
> You're missing some of the comments, I'm guesing for most of the smaller
> stuff you're just implicitly acking them but this one was a question :)
Ah, for some of your reviews you comment, then later when you see
another piece you say something like "ah ok this is why", for a lot of
these cases I might have skipped replying because it seems that you
figured it out.
For this one we moved the pte_unmap further down, because if not, we
could be prematurely unmapping a PTE, which is later referenced during
the mTHP collapse, which was not the case when we only did PMD
collapse.
>
> > >
> > > >               spin_lock(pmd_ptl);
> > > >               BUG_ON(!pmd_none(*pmd));
> > > >               /*
> > > > @@ -1255,17 +1272,17 @@ static int collapse_huge_page(struct mm_str=
uct *mm, unsigned long address,
> > > >       }
> > > >
> > > >       /*
> > > > -      * All pages are isolated and locked so anon_vma rmap
> > > > -      * can't run anymore.
> > > > +      * For PMD collapse all pages are isolated and locked so anon=
_vma
> > > > +      * rmap can't run anymore
> > > >        */
> > > > -     anon_vma_unlock_write(vma->anon_vma);
> > > > +     if (order =3D=3D HPAGE_PMD_ORDER)
> > > > +             anon_vma_unlock_write(vma->anon_vma);
> > >
> > > Hmm this is introducing a horrible new way for things to go wrong. An=
d
> > > there's now a whole host of terrible error paths that can go wrong ve=
ry
> > > easily around rmap locks and yeah, no way we cannot do it this way.
> > >
> > > rmap locks are VERY sensitive and the ordering of the locking matters=
 a
> > > great deal (see top of mm/rmap.c). So we have to be SO careful here.
> > >
> > > I suggest you simply have a boolean 'anon_vma_locked' or something li=
ke
> > > this, and get rid of these horrible additional code paths and the sec=
ond
> > > order =3D=3D HPAGE_PMD_ORDER check.
> > >
> > > We'll track whether or not the lock is held and thereby needs releasi=
ng
> > > that way instead.
>
> You've not responded to this suggestion re: refactoring here.
I think if anything this refactoring adds complexity... we simply
postpone the unlock we normally do, to later if its mTHP collapse,
because we havent fully isolated all the pages (like we do in the PMD
case).
We arent doing anything extremely different other than hold the
already held lock for a little longer. We would still need these order
=3D=3D HPAGE_PMD_ORDER checks, but just be flipping a flag that says its
locked, essentially adding more complexity for the same outcome.
>
> I'm really not a fan of us arbitrarily messing with rmap locks like this,
> and we should very carefully keep track of whether we have/have not
> released them.
Its important to note, the code was already doing this, as I stated
above, we simply hold it for longer because we haven't isolated all
the pages.
>
> Again rmap locking is a dangerous area, I've got personal experience of
> this (see top of mm/rmap.c for an indication of complexity here as well a=
s
> https://kernel.org/doc/html/latest/mm/process_addrs.html).
>
> > >
> > > Also, and very importantly - are you 100% sure you can't possibly hav=
e a
> > > deadlock or issue beyond this point if you don't release the rmap loc=
k?
> > I double checked, this was added as a fix to an issue Hugh reported.
>
> > The gap between these callers is rather small, and I see no way that
> > it could skip the lock/unlock cycle.
>
> We're going to need more than this to be confident, you need to clearly
> justify why we won't encounter issues this way.

// WE ARE HOLDING THE LOCK ALREADY
if (order =3D=3D HPAGE_PMD_ORDER) //ONLY RELEASE IF ITS PMD
        anon_vma_unlock_write(vma->anon_vma);

    result =3D __collapse_huge_page_copy(pte, folio, pmd, _pmd,
                       vma, _address, pte_ptl,
                       order, &compound_pagelist);
    if (unlikely(result !=3D SCAN_SUCCEED))
        goto out_unlock_anon_vma; //LETS RELEASE THE LOCK IF WE FAIL

if (order =3D=3D HPAGE_PMD_ORDER) {
      ...
     // NO EXIT PATHS
    } else { /* mTHP collapse */
        ...
       // NO EXIT PATHS
    }

    folio =3D NULL;

    result =3D SCAN_SUCCEED;
out_unlock_anon_vma:
    if (order !=3D HPAGE_PMD_ORDER)
        anon_vma_unlock_write(vma->anon_vma); //RELEASE IF IT WASN'T
RELEASED EARLIER

Not sure if this is the verification you are looking for, but I really
dont see how this could go wrong, or how this is any different than
what the khugepaged code is already doing in a number of places.
>
> > >
> > > This is veeeery important, as there can be implicit assumptions aroun=
d
> > > whether or not one can acquire these locks and you basically have to =
audit
> > > ALL code over which this lock is held.
> > >
> > > I'm speaking from hard experience here having bumped into this in var=
ious
> > > attempts at work relating to this stuff...
> > >
> > > >
> > > >       result =3D __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> > > > -                                        vma, address, pte_ptl,
> > > > -                                        &compound_pagelist, HPAGE_=
PMD_ORDER);
> > > > -     pte_unmap(pte);
> > > > +                                        vma, _address, pte_ptl,
> > > > +                                        &compound_pagelist, order)=
;
> > > >       if (unlikely(result !=3D SCAN_SUCCEED))
> > > > -             goto out_up_write;
> > > > +             goto out_unlock_anon_vma;
> > >
> > > See above...
> > >
> > > >
> > > >       /*
> > > >        * The smp_wmb() inside __folio_mark_uptodate() ensures the
> > > > @@ -1273,33 +1290,115 @@ static int collapse_huge_page(struct mm_st=
ruct *mm, unsigned long address,
> > > >        * write.
> > > >        */
> > > >       __folio_mark_uptodate(folio);
> > > > -     pgtable =3D pmd_pgtable(_pmd);
> > > > -
> > > > -     _pmd =3D folio_mk_pmd(folio, vma->vm_page_prot);
> > > > -     _pmd =3D maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> > > > -
> > > > -     spin_lock(pmd_ptl);
> > > > -     BUG_ON(!pmd_none(*pmd));
> > > > -     folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
> > > > -     folio_add_lru_vma(folio, vma);
> > > > -     pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > > > -     set_pmd_at(mm, address, pmd, _pmd);
> > > > -     update_mmu_cache_pmd(vma, address, pmd);
> > > > -     deferred_split_folio(folio, false);
> > > > -     spin_unlock(pmd_ptl);
> > > > +     if (order =3D=3D HPAGE_PMD_ORDER) {
> > > > +             pgtable =3D pmd_pgtable(_pmd);
> > > > +             _pmd =3D folio_mk_pmd(folio, vma->vm_page_prot);
> > > > +             _pmd =3D maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> > > > +
> > > > +             spin_lock(pmd_ptl);
> > > > +             BUG_ON(!pmd_none(*pmd));
> > >
> > > I know you're refactoring this, but be good to change this to a
> > > WARN_ON_ONCE(), BUG_ON() is verboten unless it's absolutely definitel=
y
> > > going to be a kernel nuclear event, so worth changing things up as we=
 go.
>
> > Yeah i keep seeing those warning in checkpatch, so Ill go ahead and edi=
t it.
>
> Thanks!
>
> > >
> > > > +             folio_add_new_anon_rmap(folio, vma, _address, RMAP_EX=
CLUSIVE);
> > > > +             folio_add_lru_vma(folio, vma);
> > > > +             pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > > > +             set_pmd_at(mm, address, pmd, _pmd);
> > > > +             update_mmu_cache_pmd(vma, address, pmd);
> > > > +             deferred_split_folio(folio, false);
> > > > +             spin_unlock(pmd_ptl);
> > > > +     } else { /* mTHP collapse */
> > > > +             mthp_pte =3D mk_pte(&folio->page, vma->vm_page_prot);
> > >
> > > I guess it's a rule that each THP or mTHP range spanned must span one=
 and
> > > only one folio.
> > >
> > > Not sure &folio->page has a future though.
> > >
> > > Maybe better to use folio_page(folio, 0)?
> > Ok sounds good I'll use that.
>
> Thanks!
>
> > >
> > > > +             mthp_pte =3D maybe_mkwrite(pte_mkdirty(mthp_pte), vma=
);
> > > > +
> > > > +             spin_lock(pmd_ptl);
> > > > +             BUG_ON(!pmd_none(*pmd));
> > >
> > > having said the above, this is trictly introducing a new BUG_ON() whi=
ch is
> > > a no-no, please make it a WARN_ON_ONCE().
>
> This one is more important, please do do this.
>
> > >
> > > > +             folio_ref_add(folio, (1 << order) - 1);
> > >
> > > Again no 1 << x please.
>
> (as per David feedback elsewhere, 1UL << instead)
ack
>
> > >
> > > Do we do something similar somewhere else for mthp ref counting? Can =
we
> > > share code somehow?
>
> > Yeah but IIRC its only like 2 or 3 places that do something like
> > this... most callers to folio_add_* do things in slightly different
> > manners. Maybe something to look into for the future, but I think it
> > will be difficult to generalize it.
>
> OK.
>
> > >
> > > > +             folio_add_new_anon_rmap(folio, vma, _address, RMAP_EX=
CLUSIVE);
> > > > +             folio_add_lru_vma(folio, vma);
> > > > +             set_ptes(vma->vm_mm, _address, pte, mthp_pte, (1 << o=
rder));
> > >
> > > Please avoid 1 << order, and I think at this point since you referenc=
e it a
> > > bunch of times, just store a local var like nr_pages or sth?
>
> > yeah not a bad idea!
>
> Thanks!
>
> > >
> > > > +             update_mmu_cache_range(NULL, vma, _address, pte, (1 <=
< order));
> > > > +
> > > > +             smp_wmb(); /* make pte visible before pmd */
> > >
> > > Can you give some detail as to why this will work here and why it is
> > > necessary?
>
> > Other parts of the kernel do it when setting ptes before updating the
> > PMD. I'm not sure if it's necessary, but better safe than sorry.
>
> Unfortunately this is a _totally_ unacceptable justification. We can't pu=
t
> in barriers based on 'better safe than sorry'. You need to analysis this
> and determine whether or not it's necessary.
>
> So the comment in pmd_install() seems to give an indication:
>
>         if (likely(pmd_none(*pmd))) {   /* Has another populated it ? */
>                 mm_inc_nr_ptes(mm);
>                 /*
>                  * Ensure all pte setup (eg. pte page lock and page clear=
ing) are
>                  * visible before the pte is made visible to other CPUs b=
y being
>                  * put into page tables.
>                  *
>                  * The other side of the story is the pointer chasing in =
the page
>                  * table walking code (when walking the page table withou=
t locking;
>                  * ie. most of the time). Fortunately, these data accesse=
s consist
>                  * of a chain of data-dependent loads, meaning most CPUs =
(alpha
>                  * being the notable exception) will already guarantee lo=
ads are
>                  * seen in-order. See the alpha page table accessors for =
the
>                  * smp_rmb() barriers in page table walking code.
>                  */
>                 smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lo=
ck */
>                 pmd_populate(mm, pmd, *pte);
>                 *pte =3D NULL;
>         }

So this seems to indicate we do need it for some rare edge
cases/arches, and that's why it exists in other callers too.
>
> > >
> > > > +             pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> > >
> > > If we're updating PTE entriess why do we need to assign the PMD entry=
?
>
> > We removed the PMD entry for GUP_fast reasons, then we reinstall the
> > PMD entry after the mTHP is in place. Same as for PMD collapse.
>
> OK a comment to this effect would be useful.
Ok ill add a small comment. feel free to take a look at the failure
handling around __collapse_huge_page_isolate to see another example of
this. We remove the pmd (pmdp_collapse_flush), then if the isolation
fails, we repopulate the original PMD. In the mTHP case, because we
are not installing a new PMD, we still remove the PMD (for gup-fast
reasons), modify the PTE entries within that PMD, then reinstall the
original PMD. This prevent GUP-fast from accessing these PTEs/PMD mid
change.
>
> > >
> > > > +             spin_unlock(pmd_ptl);
> > > > +     }
> > >
> > > This deeply, badly needs to be refactored into something that both sh=
ares
> > > code and separates out these two operations.
> > >
> > > This function is disgustingly long as it is, and that's not your faul=
t, but
> > > let's try to make things better as we go.
> > >
> > > >
> > > >       folio =3D NULL;
> > > >
> > > >       result =3D SCAN_SUCCEED;
> > > > +out_unlock_anon_vma:
> > > > +     if (order !=3D HPAGE_PMD_ORDER)
> > > > +             anon_vma_unlock_write(vma->anon_vma);
> > >
> > > Obviously again as above, we need to simplify this and get rid of thi=
s
> > > whole bit.
> > >
> > > >  out_up_write:
> > > > +     if (pte)
> > > > +             pte_unmap(pte);
> > >
> > > OK I guess you moved this from above down here? Is this a valid place=
 to do this?
> > Yes if not we were potentially unmapping a pte early.
> > >
> > > >       mmap_write_unlock(mm);
> > > >  out_nolock:
> > > > +     *mmap_locked =3D false;
> > >
> > > This is kind of horrible, we now have pretty mad logic around who set=
s
> > > mmap_locked and where.
> > >
> > > Can we just do this at the call sites so we avoid that?
> > >
> > > I mean anything we do with this is hideous, but that'd be less confus=
ing It
> > > hink.
> > >
> > > >       if (folio)
> > > >               folio_put(folio);
> > > >       trace_mm_collapse_huge_page(mm, result =3D=3D SCAN_SUCCEED, r=
esult);
> > > >       return result;
> > > >  }
> > > >
> > > > +/* Recursive function to consume the bitmap */
> > >
> > > Err... please don't? Kernel stack is a seriously finite resource, we =
do not
> > > want recursion at all.
> > >
> > > But I'm not actually seeing any recursion here? Am I missing somethin=
g?
> > >
>
> Yup this was before I realised it was an iterative implementation :)
>
> Though we are putting load on the stack anyway...
Ill see if I can shrink this load!
>
> > > > +static int collapse_scan_bitmap(struct mm_struct *mm, unsigned lon=
g address,
> > > > +                     int referenced, int unmapped, struct collapse=
_control *cc,
> > > > +                     bool *mmap_locked, unsigned long enabled_orde=
rs)
> > >
> > > This is a complicated and confusing function, it requires a comment
> > > describing how it works.
> > Ok will do!
>
> This is _VERY_ key - I need this I think to be able to sanely review this
> code.
ack, im also simplifying it a bit in the next iteration.
>
> > >
> > > > +{
> > > > +     u8 order, next_order;
> > > > +     u16 offset, mid_offset;
> > > > +     int num_chunks;
> > > > +     int bits_set, threshold_bits;
> > > > +     int top =3D -1;
> > >
> > > Err why do we start at -1 then immediately increment it?
> > You are correct, it was probably a leftover bit from my development
> > phase. Seems I can just set it to 0 to begin with.
>
> Thanks!
>
> > >
> > > > +     int collapsed =3D 0;
> > > > +     int ret;
> > > > +     struct scan_bit_state state;
> > > > +     bool is_pmd_only =3D (enabled_orders =3D=3D (1 << HPAGE_PMD_O=
RDER));
> > >
> > > Extraneous outer parens.
> > ack
>
> Thanks!
>
> > >
> > > > +
> > > > +     cc->mthp_bitmap_stack[++top] =3D (struct scan_bit_state)
> > > > +             { HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0 };
> > >
> > > This is the same as
> > >
> > >         cc->mthp_bitmap_stack[0] =3D ...;
> > >         top =3D 1;
> > >
> > > No?
>
>
> > no it would be bitmap_stack[0] =3D ...
> > then top goes to -1 (at state =3D... ), and if we add more items
> > (next_order) to the stack it would go top =3D 1 (adds one for each half
> > of the split)
>
> OK, again going to need that comment to really grok all this... :)
>
> > >
> > >
> > > This is really horrible. Can we just have a helper function for this
> > > please?
>
> > Seems kinda excessive for 4 lines and one caller.
>
> It's code that's very horrible to understand using a very unusual way of
> initialising a struct within the kernel.
ok, ill see if i can clean it up.
>
> And having code be understandable when the compiler can inline for us doe=
s
> indeed justify this even in the instance of 4 lines and one caller :)
ack
>
> > >
> > > Like:
> > >
> > >         static int mthp_push_stack(struct collapse_control *cc,
> > >                 int index, u8 order, u16 offset)
> > >         {
> > >                 struct scan_bit_state *state =3D &cc->mthp_bitmap_sta=
ck[index];
> > >
> > >                 VM_WARN_ON(index >=3D MAX_MTHP_BITMAP_SIZE);
> > >
> > >                 state->order =3D order;
> > >                 state->offset =3D offset;
> > >
> > >                 return index + 1;
> > >         }
> >
> > This would not work in its current state because its ++index in the
> > current implementation. I would need to refactor, but the general idea
> > still stands
>
> OK thanks.
>
> Something _like_ this would make things a great deal clearer.
>
> > >
> > > And can invoke via:
> > >
> > >         top =3D mthp_push_stack(cc, top, order, offset);
> > >
> > > Or pass index as a pointer possibly also.
> > >
> > > > +
> > > > +     while (top >=3D 0) {
> > > > +             state =3D cc->mthp_bitmap_stack[top--];
> > >
> > > OK so this is the recursive bit...
> > >
> > > Oh man this function so needs a comment describing what it does, seri=
ously.
> > >
> > > I think honestly for sake of my own sanity I'm going to hold off revi=
ewing
> > > the rest of this until there's something describing the algorithm, in
> > > detail here, above the function.
>
> > It's basically binary recursion with a stack structure, that checks
> > regions of the bitmap in descending order (ie order 9, order 8, ...)
> > if we go to the next order we add two items to the stack (left and
> > right half). I will add a comment describing it at the top of the
> > function.
>
> Right, to reiterate - this needs a _big_ comment.
>
> I'm sorry to split the review of this patch in two on this, because once
> you do that I'm going to inevitably do the deferred review on the
> algorithm, but I just feel this is the only sensible way I can determine
> whether what you intend to do here makes sense and is correctly
> implemented.
Its all good! This pushed me to come up with a better solution, by
both removing the compression into 128 bits, and also come up with a
solution to the creep (although its not the 0/511 that you and David
were talking about).
>
> Kinda need that 'what you intend to do' bit. So it should be an expansive
> and detailed comment explicitly explaining the algorithm and why you're
> doing it.
>
> Thanks!
>
> > >
> > > > +             order =3D state.order + KHUGEPAGED_MIN_MTHP_ORDER;
> > > > +             offset =3D state.offset;
> > > > +             num_chunks =3D 1 << (state.order);
> > > > +             /* Skip mTHP orders that are not enabled */
> > > > +             if (!test_bit(order, &enabled_orders))
> > > > +                     goto next_order;
> > > > +
> > > > +             /* copy the relavant section to a new bitmap */
> > > > +             bitmap_shift_right(cc->mthp_bitmap_temp, cc->mthp_bit=
map, offset,
> > > > +                               MTHP_BITMAP_SIZE);
> > > > +
> > > > +             bits_set =3D bitmap_weight(cc->mthp_bitmap_temp, num_=
chunks);
> > > > +             threshold_bits =3D (HPAGE_PMD_NR - khugepaged_max_pte=
s_none - 1)
> > > > +                             >> (HPAGE_PMD_ORDER - state.order);
> > > > +
> > > > +             /* Check if the region is "almost full" based on the =
threshold */
> > > > +             if (bits_set > threshold_bits || is_pmd_only
> > > > +                     || test_bit(order, &huge_anon_orders_always))=
 {
> > > > +                     ret =3D collapse_huge_page(mm, address, refer=
enced, unmapped,
> > > > +                                              cc, mmap_locked, ord=
er,
> > > > +                                              offset * KHUGEPAGED_=
MIN_MTHP_NR);
> > > > +                     if (ret =3D=3D SCAN_SUCCEED) {
> > > > +                             collapsed +=3D (1 << order);
> > > > +                             continue;
> > > > +                     }
> > > > +             }
> > > > +
> > > > +next_order:
> > > > +             if (state.order > 0) {
> > > > +                     next_order =3D state.order - 1;
> > > > +                     mid_offset =3D offset + (num_chunks / 2);
> > > > +                     cc->mthp_bitmap_stack[++top] =3D (struct scan=
_bit_state)
> > > > +                             { next_order, mid_offset };
> > > > +                     cc->mthp_bitmap_stack[++top] =3D (struct scan=
_bit_state)
> > > > +                             { next_order, offset };
> > > > +             }
> > > > +     }
> > > > +     return collapsed;
> > > > +}
> > > > +
> > > >  static int collapse_scan_pmd(struct mm_struct *mm,
> > > >                            struct vm_area_struct *vma,
> > > >                            unsigned long address, bool *mmap_locked=
,
> > > > @@ -1307,31 +1406,60 @@ static int collapse_scan_pmd(struct mm_stru=
ct *mm,
> > > >  {
> > > >       pmd_t *pmd;
> > > >       pte_t *pte, *_pte;
> > > > +     int i;
> > > >       int result =3D SCAN_FAIL, referenced =3D 0;
> > > >       int none_or_zero =3D 0, shared =3D 0;
> > > >       struct page *page =3D NULL;
> > > >       struct folio *folio =3D NULL;
> > > >       unsigned long _address;
> > > > +     unsigned long enabled_orders;
> > > >       spinlock_t *ptl;
> > > >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> > > > +     bool is_pmd_only;
> > > >       bool writable =3D false;
> > > > -
> > > > +     int chunk_none_count =3D 0;
> > > > +     int scaled_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_OR=
DER - KHUGEPAGED_MIN_MTHP_ORDER);
> > > > +     unsigned long tva_flags =3D cc->is_khugepaged ? TVA_KHUGEPAGE=
D : TVA_FORCED_COLLAPSE;
> > > >       VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > > >
> > > >       result =3D find_pmd_or_thp_or_none(mm, address, &pmd);
> > > >       if (result !=3D SCAN_SUCCEED)
> > > >               goto out;
> > > >
> > > > +     bitmap_zero(cc->mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
> > > > +     bitmap_zero(cc->mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
> > >
> > > Having this 'temp' thing on the stack for everyone is just horrid.
> > As I mention above this serves a very good purpose, and is also
> > expanded in another series by Baolin to serve another similar purpose
> > too.
>
> Yeah, I'm not hugely convinced :) responded there.
>
> I can probably give more useful feedback on this once the big comment is
> added!
Ok! hopefully I find a solution so I can remove the temp one.
>
> > >
> > > >       memset(cc->node_load, 0, sizeof(cc->node_load));
> > > >       nodes_clear(cc->alloc_nmask);
> > > > +
> > > > +     if (cc->is_khugepaged)
> > > > +             enabled_orders =3D thp_vma_allowable_orders(vma, vma-=
>vm_flags,
> > > > +                     tva_flags, THP_ORDERS_ALL_ANON);
> > > > +     else
> > > > +             enabled_orders =3D BIT(HPAGE_PMD_ORDER);
> > > > +
> > > > +     is_pmd_only =3D (enabled_orders =3D=3D (1 << HPAGE_PMD_ORDER)=
);
> > >
> > > This is horrid, can we have a function broken out to do this please?
> > >
> > > In general if you keep open coding stuff, just write a static functio=
n for
> > > it, the compiler is smart enough to inline.
> > ok, we do this is a few places so perhaps its the best approach.
> > >
> > > > +
> > > >       pte =3D pte_offset_map_lock(mm, pmd, address, &ptl);
> > > >       if (!pte) {
> > > >               result =3D SCAN_PMD_NULL;
> > > >               goto out;
> > > >       }
> > > >
> > > > -     for (_address =3D address, _pte =3D pte; _pte < pte + HPAGE_P=
MD_NR;
> > > > -          _pte++, _address +=3D PAGE_SIZE) {
> > > > +     for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> > > > +             /*
> > > > +              * we are reading in KHUGEPAGED_MIN_MTHP_NR page chun=
ks. if
> > > > +              * there are pages in this chunk keep track of it in =
the bitmap
> > > > +              * for mTHP collapsing.
> > > > +              */
> > > > +             if (i % KHUGEPAGED_MIN_MTHP_NR =3D=3D 0) {
> > > > +                     if (i > 0 && chunk_none_count <=3D scaled_non=
e)
> > > > +                             bitmap_set(cc->mthp_bitmap,
> > > > +                                        (i - 1) / KHUGEPAGED_MIN_M=
THP_NR, 1);
> > > > +                     chunk_none_count =3D 0;
> > > > +             }
> > >
> > > This whole thing is really confusing and you are not explaining the
> > > algoritm here at all.
> > >
> > > This requires a comment, and really this bit should be separated out =
please.
> > This used to be its own commit, but multiple people wanted it
> > squashed... ugh. Which should we go with?
> > >
> > > > +
> > > > +             _pte =3D pte + i;
> > > > +             _address =3D address + i * PAGE_SIZE;
> > > >               pte_t pteval =3D ptep_get(_pte);
> > > >               if (is_swap_pte(pteval)) {
> > > >                       ++unmapped;
> > > > @@ -1354,10 +1482,11 @@ static int collapse_scan_pmd(struct mm_stru=
ct *mm,
> > > >                       }
> > > >               }
> > > >               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval)))=
 {
> > > > +                     ++chunk_none_count;
> > > >                       ++none_or_zero;
> > > >                       if (!userfaultfd_armed(vma) &&
> > > > -                         (!cc->is_khugepaged ||
> > > > -                          none_or_zero <=3D khugepaged_max_ptes_no=
ne)) {
> > > > +                         (!cc->is_khugepaged || !is_pmd_only ||
> > > > +                             none_or_zero <=3D khugepaged_max_ptes=
_none)) {
> > > >                               continue;
> > > >                       } else {
> > > >                               result =3D SCAN_EXCEED_NONE_PTE;
> > > > @@ -1453,6 +1582,7 @@ static int collapse_scan_pmd(struct mm_struct=
 *mm,
> > > >                                                                    =
address)))
> > > >                       referenced++;
> > > >       }
> > > > +
> > > >       if (!writable) {
> > > >               result =3D SCAN_PAGE_RO;
> > > >       } else if (cc->is_khugepaged &&
> > > > @@ -1465,10 +1595,12 @@ static int collapse_scan_pmd(struct mm_stru=
ct *mm,
> > > >  out_unmap:
> > > >       pte_unmap_unlock(pte, ptl);
> > > >       if (result =3D=3D SCAN_SUCCEED) {
> > > > -             result =3D collapse_huge_page(mm, address, referenced=
,
> > > > -                                         unmapped, cc);
> > > > -             /* collapse_huge_page will return with the mmap_lock =
released */
> > > > -             *mmap_locked =3D false;
> > > > +             result =3D collapse_scan_bitmap(mm, address, referenc=
ed, unmapped, cc,
> > > > +                                           mmap_locked, enabled_or=
ders);
> > > > +             if (result > 0)
> > > > +                     result =3D SCAN_SUCCEED;
> > > > +             else
> > > > +                     result =3D SCAN_FAIL;
> > >
> > > We're reusing result as both an enum value and as a storage for unmbe=
r
> > > colapsed PTE entries?
> > >
> > > Can we just use a new local variable? Thanks
>
> Again you've skipped a ton of review comments here. You need to respond t=
o
> everything.
Hmm we could, although it would serve no purpose in my eyes...
nr_collapsed =3D collapse_scan_bitmap()
if(nr_collapsed > 0)
    result =3D SCAN_SUCCEED.

To me that is basically the same thing with extra steps. But maybe its
better for a code readiblity standpoint.
>
> > >
> > > >       }
> > > >  out:
> > > >       trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
> > > > --
> > > > 2.50.1
> > > >
> > >
> > > I will review the bitmap/chunk stuff in more detail once the algorith=
m is
> > > commented.
> > ok thanks for the review.
>
> No problem! :)
>


