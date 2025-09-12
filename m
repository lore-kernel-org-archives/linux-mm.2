Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57EB8CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 23:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796AE8E0002; Fri, 12 Sep 2025 19:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E2E8E0001; Fri, 12 Sep 2025 19:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683708E0002; Fri, 12 Sep 2025 19:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56C788E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:26:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4AB9873AF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:26:36 +0000 (UTC)
X-FDA: 83882184792.28.2C12541
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69A3718000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:26:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WcQQzxrB;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757719594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYya9fW1mJvYJ3jPqwJBitUidkWXto77tPEtahloeFg=;
	b=eTEW6TqoMGxFqvpHwByMwoclRzxnGChekqUxLNo6sYtanDiPNyQtjo9p2Sr+DT+tUxlXS5
	XJwjteRiHTo4mDz2okNfM9QKKuWTK2lX+TdhRIaZyjKeSSe7bn28/uDUfZtMdtwMOy5wvP
	SOzsL1bNRXlfNxFa70QaC/egeIB73hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757719594; a=rsa-sha256;
	cv=none;
	b=JyiuJdg0s9bc+v2Cu0oCngcos3Net2IhApHntSMq105IK30RMDD805oEhMPxW3eAFwDqBF
	gCHkPBC0GoACzupLv5RubppCCDtzjk1+MMOpOJ04ONfJqyErvG06vBS0obOaro+CW+a1kW
	uMSKFW1cdPgx4W1UOMSUd39Hs8a8EIM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WcQQzxrB;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757719593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FYya9fW1mJvYJ3jPqwJBitUidkWXto77tPEtahloeFg=;
	b=WcQQzxrBgwWsB/xNMY23bzBlXh42gHTj6+VcUA31yo48Onh/QQWg+n3oMvZ3I20sn+Jby/
	CSLN0FAW520wEGNTb5/W4YAs7h+uR7c+TIVmooavyKiJr2Q1pBeFH7drzoXMVkgocLUBa3
	mlBAJ5+WZCJK1V02u3+d4B0GytTKEDI=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-ME0KirfZNsez8Ar3Gq6KAw-1; Fri, 12 Sep 2025 19:26:30 -0400
X-MC-Unique: ME0KirfZNsez8Ar3Gq6KAw-1
X-Mimecast-MFC-AGG-ID: ME0KirfZNsez8Ar3Gq6KAw_1757719590
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6119ec806f9so2137021d50.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719590; x=1758324390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYya9fW1mJvYJ3jPqwJBitUidkWXto77tPEtahloeFg=;
        b=H7MeD9HQLus+O7vgliYxh1LGj8jW3etG5gLOtQgDzkqtkLSMFTNus3tvkf1gjD4PTr
         nKaIdBxTpKNW+w/avGFJsg/2hMpioqyoIn/sTGqLLyi4Q0i/VRl9hw1/0J3cVMO0J99d
         xmEK7LHmGXcIra62IQiNUXv0Y5hf/JfzhLnDwq4/B5gVW+8dY+TCsi3RuzcZ5HSVOpzx
         FJ78TcR1TEgzuBMgh+YODQU+lmaZnct//1IcXtEgsCgBJ7G4oCm0GMUSq7N4N+xggzWp
         KGPAAWv47AAoo7CVX1RcfeHBzjDWyx42cnqLhStob/QI/c4mz1gCp4ZJ8Y7UtAz6IE/D
         VwpQ==
X-Gm-Message-State: AOJu0YyIwtX4OnBp9eTQZfFQQAGsR9BCC5M5KnwEMtC9MWJkQAqXSvv2
	zZzm0hBxPhRQu3sKJGt8083d2HSrngt4slnZnApx4eH5uNiLBBvNYaaFFq+i6Q5tyPkO7RtI0yF
	UIrxKrtBx9jsxFnKijdc5tB14hFwh13ZkM4c4l5Erg8XBKxwVHSgtaBAw/bOB8tYnBGItQkz7hk
	UxLB3w7QLrKvTcadx/H2ZFjdGUpdk=
X-Gm-Gg: ASbGncsqrMkw5pYuS590K6Ccx8M1W/gFsUuL/iaNxILfi93VvpMOESY1UQvACokyf/g
	AbOthXLq6i+bk0IjQ3099F2WpGaXW4OJQYf3RtdXIJJa+gIf+l81U9oVaEC/bZ2EFumjQ713a1e
	R1a+R4rjVSfZiaULgHyGheIx2+/Pi4EphwzRM=
X-Received: by 2002:a53:c949:0:b0:623:696e:39c6 with SMTP id 956f58d0204a3-62724632d67mr3454903d50.35.1757719589832;
        Fri, 12 Sep 2025 16:26:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4AnimwV4DJpIrzY5zDni7Ex/wppWCYlFBHUNbQWqcehb1JqlslO2cG7IpWR63nH0AcJL1oIrwAvdwGrMu0Z8=
X-Received: by 2002:a53:c949:0:b0:623:696e:39c6 with SMTP id
 956f58d0204a3-62724632d67mr3454856d50.35.1757719589379; Fri, 12 Sep 2025
 16:26:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250912032810.197475-1-npache@redhat.com> <20250912032810.197475-7-npache@redhat.com>
 <4e1fef74-f369-439e-83ff-c50f991c834e@lucifer.local>
In-Reply-To: <4e1fef74-f369-439e-83ff-c50f991c834e@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Fri, 12 Sep 2025 17:26:03 -0600
X-Gm-Features: Ac12FXw8kuzu15sT3828_sGKN1OjxWfPvlvmcTocIEno-x-VWWBe1uDeooNmQyg
Message-ID: <CAA1CXcCugu0C3s2V1GcZZC=WksiNy8vkomHCcdvtGKfhxhoyfw@mail.gmail.com>
Subject: Re: [PATCH v11 06/15] khugepaged: introduce collapse_max_ptes_none
 helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
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
X-Mimecast-MFC-PROC-ID: hRTlrqeYZ798U6LNfChvNYpvWDvg9NmUynzLeMPe39k_1757719590
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 69A3718000C
X-Stat-Signature: awxbjurw1bm4xp1u18bb46cwomp9rfou
X-Rspam-User: 
X-HE-Tag: 1757719594-100278
X-HE-Meta: U2FsdGVkX1/CBAVvzoxJNrG6jja9yeP8ULPJzjQyRWIWqC9ksibPeGSxvZf0kfrTtswB7XkPPKZvLyGHUVj8WhrBs1xH+6Rxy5P9G+hiMV4FxEvQWEeRvYcwh2nbXEsGcq4M9rmAWMaa3BI3daTVQqvi6sQYoTSFrC8E4McWCLfKFWztQ7/sZhF4niymKy3ID61A7wlP0rhtMZyaFPE3/L5UQisAqIaUR/6DbEBjK4DBdxkMVvWFVRcRxHGQYzAdCDN3NBrzCbvXsCtJglmfX6pMVhst7lctclenvZfqYOkrRb4h0aGt2cxV5zGiT6QCMM9VqJFLJWqOibTmfRwHhPvdAavgM46o8QSPmEyYqxN9bExll4S6pvT1zmXYhitxYPY3gQ3MKi/g7NbfUbPGmSbkF0PWyYo5v/iuOQllbFt8S/B0GRs0eNVsYJ9zJTzUk9ndMh3eWUs5IZymYIArk1SB4dHkKPM1u1Zo1DYAzmYQ2/na2aI7cKXWAFYNCq3mTdUlMsBDW6OoDCnfqyysqKRYThHAqnFi4ElumndTIdy5nyIHKqHGBzprXy0JciO26jbWIdi3KxCq9fzB1MUMyalH6pj6dVEJfjX4s/DqRb2Zw2krA3E5lrAaG9qzC7JQ5INV8HF7wspvCXdYTpJCzHqMCR+lh4wL9rhyFg+cF9Tb/fVEfWp1poLedOVKboH0Cg97tpaaDmcr+T8TC6chexxrGxO2X70nbcSw7zREkDRq9JLF0L06e92ogeeEm1Ju+yk3Nb7No7Ny0+8C7Oa8pmAyRESpd6PaapDwW7/Bs0ixzSojPpBnJS2rDhh2pv01cFvwO0ltUKgpcp/xuXvPk9Nr3lLSfW1Y+RUac2iWaIkcwaRlWlj6vcWMujYDWbGVy2UcQVLwuzKzjwVAspe4wKBPlTa1C5FcMiLa8RR19ucg0xZpSSWYLWy8+P74LMQf4nYjH9ozrdYLmYDTkDw
 siLYsQow
 W0WZuEKnRTwjO5QoUF5/E1LWKkgnewAkywiTKCBXq/Jp1cbJSl8JFYJMWf0w9uN+SyGY+iJgq79MTcJ9QeStQbOdIiIqaAwDoGLB65d5TYQJpLyce2dOSJJsG0X7dzC9HXf8ay+cPVxFcox+2ugKlpEeDIFYLm3ShTZfE3PiX72V39ZORTnwGbvms0SIHynpaPmW/BEEyI2w/9a3q/7nv0U3cZHx7fB85XbjrCw/kxnlmBULtMK/e3q02RJbQa2h0xQEjZSLwmnDYRQeR+NMo4UxEUmJUMAytr0QZrN+tlDruHSnVRtQcm9WkwbOoPrPshozOt1np/cPuhjHUY3c1kfQ+3G2qDD8I9JA0Oe9prlWb2Ew1B66yTd41ao1eioSBWuG1738c9qTRouIjRBlsgfuq9W/i52vVj0Bj6lhUFq2p3eewgLolC1wkqEcxIDb0RQ2vGGAXdW+dsqVF+Vyi7APWI/g20rZ+6oyPYAbYPxkYi0AE8BmrysCVyxi0yOBoSy85Lhogn9WWIeG0DCP+c6rRYEPTgPQqJF8K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 7:36=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Sep 11, 2025 at 09:28:01PM -0600, Nico Pache wrote:
> > The current mechanism for determining mTHP collapse scales the
> > khugepaged_max_ptes_none value based on the target order. This
> > introduces an undesirable feedback loop, or "creep", when max_ptes_none
> > is set to a value greater than HPAGE_PMD_NR / 2.
> >
> > With this configuration, a successful collapse to order N will populate
> > enough pages to satisfy the collapse condition on order N+1 on the next
> > scan. This leads to unnecessary work and memory churn.
> >
> > To fix this issue introduce a helper function that caps the max_ptes_no=
ne
> > to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scales
> > the max_ptes_none number by the (PMD_ORDER - target collapse order).
>
> I would say very clearly that this is only in the mTHP case.

ack, I stole most of the verbiage here from other notes I've
previously written, but it can be improved.

>
>
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> Hmm I thought we were going to wait for David to investigate different
> approaches to this?
>
> This is another issue with quickly going to another iteration. Though I d=
o think
> David explicitly said he'd come back with a solution?

Sorry I thought that was being done in lockstep. The last version was
about a month ago and I had a lot of changes queued up. Now that we
have collapse_max_pte_none() David has a much easier entry point to
work off :)

I think he will still need this groundwork for the solution he is
working on with "eagerness". if 10 -> 511, and 9 ->255, ..., 0 -> 0.
It will still have to do the scaling. Although I believe 0-10 should
be more like 0-5 mapping to 0,32,64,128,255,511

>
> So I'm not sure why we're seeing this solution here? Unless I'm missing
> something?
>
> > ---
> >  mm/khugepaged.c | 22 +++++++++++++++++++++-
> >  1 file changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b0ae0b63fc9b..4587f2def5c1 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -468,6 +468,26 @@ void __khugepaged_enter(struct mm_struct *mm)
> >               wake_up_interruptible(&khugepaged_wait);
> >  }
> >
> > +/* Returns the scaled max_ptes_none for a given order.
>
> We don't start comments at the /*, please use a normal comment format lik=
e:
ack
>
> /*
>  * xxxx
>  */
>
> > + * Caps the value to HPAGE_PMD_NR/2 - 1 in the case of mTHP collapse t=
o prevent
>
> This is super unclear.
>
> It start with 'caps the xxx' which seems like you're talking generally.
>
> You should say very clearly 'For PMD allocations we apply the
> khugepaged_max_ptes_none parameter as normal. For mTHP ... [details about=
 mTHP].
ack I will clean this up.
>
> > + * a feedback loop. If max_ptes_none is greater than HPAGE_PMD_NR/2, t=
he value
> > + * would lead to collapses that introduces 2x more pages than the orig=
inal
> > + * number of pages. On subsequent scans, the max_ptes_none check would=
 be
> > + * satisfied and the collapses would continue until the largest order =
is reached
> > + */
>
> This is a super vauge explanation. Please describe the issue with creep m=
ore
> clearly.
ok I will try to come up with something clearer.
>
> Also aren't we saying that 511 or 0 are the sensible choices? But now som=
ehow
> that's not the case?
Oh I stated I wanted to propose this, and although there was some
pushback I still thought it deserved another attempt. This still
allows for some configurability, and with David's eagerness toggle
this still seems to fit nicely.
>
> You're also not giving a kdoc info on what this returns.
Ok I'll add a kdoc here, why this function in particular, I'm trying
to understand why we dont add kdocs on other functions?
>
> > +static int collapse_max_ptes_none(unsigned int order)
>
> It's a problem that existed already, but khugepaged_max_ptes_none is an u=
nsigned
> int and this returns int.
>
> Maybe we should fix this while we're at it...
ack
>
> > +{
> > +     int max_ptes_none;
> > +
> > +     if (order !=3D HPAGE_PMD_ORDER &&
> > +         khugepaged_max_ptes_none >=3D HPAGE_PMD_NR/2)
> > +             max_ptes_none =3D HPAGE_PMD_NR/2 - 1;
> > +     else
> > +             max_ptes_none =3D khugepaged_max_ptes_none;
> > +     return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> > +
> > +}
> > +
>
> I really don't like this formulation, you're making it unnecessarily uncl=
ear and
> now, for the super common case of PMD size, you have to figure out 'oh it=
's this
> second branch and we're subtracting HPAGE_PMD_ORDER from HPAGE_PMD_ORDER =
so just
> return khugepaged_max_ptes_none'. When we could... just return it no?
>
> So something like:
>
> #define MAX_PTES_NONE_MTHP_CAP (HPAGE_PMD_NR / 2 - 1)
>
> static unsigned int collapse_max_ptes_none(unsigned int order)
> {
>         unsigned int max_ptes_none_pmd;
>
>         /* PMD-sized THPs behave precisely the same as before. */
>         if (order =3D=3D HPAGE_PMD_ORDER)
>                 return khugepaged_max_ptes_none;
>
>         /*
>         * Bizarrely, this is expressed in terms of PTEs were this PMD-siz=
ed.
>         * For the reasons stated above, we cap this value in the case of =
mTHP.
>         */
>         max_ptes_none_pmd =3D MIN(MAX_PTES_NONE_MTHP_CAP,
>                 khugepaged_max_ptes_none);
>
>         /* Apply PMD -> mTHP scaling. */
>         return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> }
yeah that's much cleaner thanks!
>
> >  void khugepaged_enter_vma(struct vm_area_struct *vma,
> >                         vm_flags_t vm_flags)
> >  {
> > @@ -554,7 +574,7 @@ static int __collapse_huge_page_isolate(struct vm_a=
rea_struct *vma,
> >       struct folio *folio =3D NULL;
> >       pte_t *_pte;
> >       int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, refer=
enced =3D 0;
> > -     int scaled_max_ptes_none =3D khugepaged_max_ptes_none >> (HPAGE_P=
MD_ORDER - order);
> > +     int scaled_max_ptes_none =3D collapse_max_ptes_none(order);
> >       const unsigned long nr_pages =3D 1UL << order;
> >
> >       for (_pte =3D pte; _pte < pte + nr_pages;
> > --
> > 2.51.0
> >
>
> Thanks, Lorenzo
>


