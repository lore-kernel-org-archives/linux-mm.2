Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE1DCCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7E180147; Tue, 28 Oct 2025 09:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F368013F; Tue, 28 Oct 2025 09:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421CC80147; Tue, 28 Oct 2025 09:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 271DB8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:37:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E27F613B087
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:37:28 +0000 (UTC)
X-FDA: 84047624976.02.E183C2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8B45E100003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:37:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U5LQPyNS;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761658646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=391BPTjMq7U4Si7/L0Y5C310VmT6EKvmZL7j8j+OpFA=;
	b=b1U7IZr2cT0aOyhikczvUE0EfyLGRs4liyLgNa4J0fDdS9kA4O8vK7mg5Q3X/aLPOyBqRU
	uYem1eCbxSTzTKdgYEnRE//acR9PmZOW6dlNDioQVCeJFyv4NvSEgrXGpvvWkkeBL8X+dy
	1/4jhL6lTVYOi2I2ElwcHc/gducJwa8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U5LQPyNS;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761658646; a=rsa-sha256;
	cv=none;
	b=xC5fhZH45dr0FTovVFvW5a5WkYzivs6rYV0b6ucgEuxfDFVXg7AyyChK8WL1T3VFHLnkyQ
	0QTvvZ9bbLKs8KDCpw27FUtfbAWADCNdjigRpyUNJJ19Bwa0Uw748B+3NU/txBMl9SyckG
	MwNFNMWinoLa8G+WlEZx51KOAkNeL5M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761658645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=391BPTjMq7U4Si7/L0Y5C310VmT6EKvmZL7j8j+OpFA=;
	b=U5LQPyNSOX7qdyvJia9PCLe5vWIuqJY21YwN0igFTOTah1vObfvqTzJxVNExH9VWGzAbQx
	aeyHJ7fZivL0VtbEin+bpdZnO0sQS2U8jqDWr2FEAOhcdkFVs4lklhgs81rfB0dQ77SoRc
	YihrePvL04P0iv3K2PTV1PJFROEmpQI=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-kc4VmQ_jNUO2CLdSlOR8tw-1; Tue, 28 Oct 2025 09:37:23 -0400
X-MC-Unique: kc4VmQ_jNUO2CLdSlOR8tw-1
X-Mimecast-MFC-AGG-ID: kc4VmQ_jNUO2CLdSlOR8tw_1761658643
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-782c219f163so83192887b3.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:37:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761658643; x=1762263443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=391BPTjMq7U4Si7/L0Y5C310VmT6EKvmZL7j8j+OpFA=;
        b=bPrNCeihQhT9/TCAJofKm3+rVnbr+rGWQLmggEyCmrXqxoysw7YAksmdx64Ps8gDjS
         xtHriEiwen5Z+iWdWC5ZmX/ls2fkUNhfxXVXYYXnFgWJgQCVsDoPcKHtzVQ8uG55Spxo
         VSiPkP/3c1dgkbQHr9tmRzNf1IAe/+TyZubWJmV+xmHz49ajOR9De9nWXD5Ql6VgfJEU
         /BH/j60gKsEBIydfGgLzS54qIlvl1XxydnYgr9rrMwwI9NZC7Bq6RyqJ2n7rx3djef8J
         k5InyJLagdVAA9YFNdfVWJJONooigXLqDjSnxsXxgczqpTOxEiN5L5SOch4uoy1GbdNT
         NQvg==
X-Forwarded-Encrypted: i=1; AJvYcCVicdEvg/zcIJ8IYONz7hHaS0qCd96OaAgq401yuryXOMXl5Z2C2TwbxOi3S0prFhnz1TfmdmYq9Q==@kvack.org
X-Gm-Message-State: AOJu0Yx3hPyPOmjhPntr+jWkgRLQQSvXkdD6RXMA+v74W5UiJIe1CCPa
	W9adj39Cubf3yqMMQatwBoy+UjEmgiKI2L4fZ4BNyzQd3yX5vaD42aqDqnP8PUC+GH1knMz94Pj
	6kBwxlyYYmb+94x9+zQkPkfoYl9z5120+5+plRCxLGigFoCyjw4yVwDWmBNlqECzyxdJNcPlNLC
	Q9tW1WWq3ePw7COPxScalEBgansJM=
X-Gm-Gg: ASbGncseUGx1QIldwNqEqmw+DFKEqlAH+y/1MMwLZ8SRAbzSauQxI80XqW4/aLQjNpP
	0nYr33bNOGGC0xjwnTGH2wOjeRdPDbsGRz3R6IlUzTKC1B7l4OY4pfWUo/resHU9Ux86quGVgum
	535fP//5t2B5LBx+oZxN26z+aapvntgUDtPpExDWopy2n58VAwusTrPl8rALkMr/F2oK4MzA==
X-Received: by 2002:a53:cd41:0:b0:63c:f5a6:f2ef with SMTP id 956f58d0204a3-63f6bab5662mr2132917d50.65.1761658641282;
        Tue, 28 Oct 2025 06:37:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHI5+9/fHp4gwqVR+X5FCEMvrHe+GcwlBX4w2Wql+/7C/fl5yLGrv62o9V5yeHttxzVZEf22GwHT7NBFpcz7XM=
X-Received: by 2002:a53:cd41:0:b0:63c:f5a6:f2ef with SMTP id
 956f58d0204a3-63f6bab5662mr2132906d50.65.1761658640837; Tue, 28 Oct 2025
 06:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
In-Reply-To: <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Tue, 28 Oct 2025 07:36:55 -0600
X-Gm-Features: AWmQ_bmW8XylmR-fGz7b8D2DLOax1IHPOfKa83653zAJ0iAfVZ2XGu7NC_3nK0A
Message-ID: <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sx65V21TPohkUIYgbdQU03OrMWr6WOh5ruvE6w5Yhlc_1761658643
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8B45E100003
X-Stat-Signature: gr5gcjfg5cw6gy8jg4zqbbzhheqxjoqn
X-Rspam-User: 
X-HE-Tag: 1761658646-398349
X-HE-Meta: U2FsdGVkX1+ORytJfdYmqaDUA+Ydbz1uEOdPLR4YVRCaPX18dqwlwiJjT146pvXPX/JkW/AemN7OHBtGWEylbKqBkiRSlPzctvsVzUyo5JyqwJQBBSzkGOnlLBoDbZDmDZbHNC0S5UE0OoB4CumuOG/Vb6hSvPO3TXv2aCChN811jK0LU2Nat6FXCo/6Lfsm4r7hohM+R4om6Wgww8GFpgGbivapM3WkyDWfGM9uf4h7HM6XIqGTocFG/CoYqgUX4+m9pFZFYcCv4wQkgGt9s6P396B1j97o1RlqYlOFHgGm9xz3JyM+1PfD0kpDO2pqOQlo6qdLXaacjFY5IEcTdspG07sGZ9OvcB4HGHGCZaCNqH22vCyB0XyDFRNOcfTe6xKXI/zf/262q23fRHUmvdwMlG2BOTmALvKoMMFm9du6riIq2HjW9rztNGx4vIASqyStAThBJc31rIgdC7pKv+ivo0M+prwYWP7PyRMeGYXGeUZSQXggqIhDuJ2gnnNnF0D5wRGF5yzf7fM24PcEhirR12FxRXLlx79otyFDje1+hlTRtpNdaH98SlMmgblBQyXsuCE0fN8OCCQf09m2FvqYYys3zI5GgwT18AzflKU7TkuJjqr640LHdMjsfMgocbfFiExnr4jIm48zvjN+qAdO84HdaQUILe5IKBA9dPXm/wLlt+wZj1vEGzMLVji0rr5yzmP64ChEjz2NaKmzZUt7fh20PWPMDoBvibaD0+AgXQcdcZkTLqjGUzpSZjSphP7sl7JvV0en8jPozGeAkUL3+YPI8RPvUTu/6B3tmE0ojw5c0er+GT9Hk0ogmJou6vt1G3mvea/YbNp5rIeEBfIZIsa4u6wpbSWDbHQIQqFNzgeebWephoi3ro6xXpAv+EKsAi7rGhAAtziJK8bQjjFxW9q9e50i6B83UhoLRuV3jgCKCFFD7nGcuLaR51C1OOPFx4OdI1GmTbcvnd2
 8lZR9XOY
 kyCDH6gFNMwX73K1s6yapFmrRJuhptLvZNSXRIqaJXBfFWZVtHZ3wx/RH2eYo+l4/NxlCePUKKzIBJ35bdqQO6kJoAbSYTu8BHeLEzCqNuyqmwqxPM5/2VYuuQdZU0WpPrpmIciha5vHEoyaUZnXP93ANfA9sQBWwrCYHawI31lCVebdpWpjTx5N63FYNroS4hjhLBvfv4B30ICiW27lBmcrfsxRh61lF2F/zlGtiySbtF5eGQdfwNcGTwQseT5GkOtjJqU0eaYhiL9MNuYZ8hh8cO6EI8z7nu9jWZkF2wcSjDBfu3dSwqDFDUnBTW0YL3BDASU+u1bVkPUcJHSH0Zta7bXp0YMx8Mu7SCZ0FAgjcO5Xg6gGMR71Q0Ll6Y7tPDx/YNNK55/FtcLQqOTeK7FnHt44rzPaOpzv8QfZ1wIlI8o8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 11:54=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 22, 2025 at 12:37:08PM -0600, Nico Pache wrote:
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
> >
> > The limits can be ignored by passing full_scan=3Dtrue, this is useful f=
or
> > madvise_collapse (which ignores limits), or in the case of
> > collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> > collapse is available.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 34 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 4ccebf5dda97..286c3a7afdee 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -459,6 +459,39 @@ void __khugepaged_enter(struct mm_struct *mm)
> >               wake_up_interruptible(&khugepaged_wait);
> >  }
> >
> > +/**
> > + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for c=
ollapse
> > + * @order: The folio order being collapsed to
> > + * @full_scan: Whether this is a full scan (ignore limits)
> > + *
> > + * For madvise-triggered collapses (full_scan=3Dtrue), all limits are =
bypassed
> > + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> > + *
> > + * For PMD-sized collapses (order =3D=3D HPAGE_PMD_ORDER), use the con=
figured
> > + * khugepaged_max_ptes_none value.
> > + *
> > + * For mTHP collapses, scale down the max_ptes_none proportionally to =
the folio
> > + * order, but caps it at HPAGE_PMD_NR/2-1 to prevent a collapse feedba=
ck loop.
> > + *
> > + * Return: Maximum number of empty PTEs allowed for the collapse opera=
tion
> > + */
> > +static unsigned int collapse_max_ptes_none(unsigned int order, bool fu=
ll_scan)
> > +{
> > +     unsigned int max_ptes_none;
> > +
> > +     /* ignore max_ptes_none limits */
> > +     if (full_scan)
> > +             return HPAGE_PMD_NR - 1;
> > +
> > +     if (order =3D=3D HPAGE_PMD_ORDER)
> > +             return khugepaged_max_ptes_none;
> > +
> > +     max_ptes_none =3D min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - =
1);
>

Hey Lorenzo,

> I mean not to beat a dead horse re: v11 commentary, but I thought we were=
 going
> to implement David's idea re: the new 'eagerness' tunable, and again we'r=
e now just
> implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?

I spoke to David and he said to continue forward with this series; the
"eagerness" tunable will take some time, and may require further
considerations/discussion.

>
> I'm still really quite uncomfortable with us silently capping this value.
>
> If we're putting forward theoretical ideas that are to be later built upo=
n, this
> series should be an RFC.
>
> But if we really intend to silently ignore user input the problem is that=
 then
> becomes established uAPI.
>
> I think it's _sensible_ to avoid this mTHP escalation problem, but the is=
sue is
> visibility I think.
>
> I think people are going to find it odd that you set it to something, but=
 then
> get something else.

The alternative solution is to not support max_ptes_none for mTHP
collapse and not allow none/zero pages. This is essentially "capping"
the value too.

>
> As an alternative we could have a new sysfs field:
>
> /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
>
> That shows the cap clearly.
>
> In fact, it could be read-only... and just expose it to the user. That re=
duces
> complexity.

I agree with Baolin here; adding another tunable will only increase
the complexity for our future goals, and also provides needless
insight into the internals when they can not be customized.

Cheers,
-- Nico

>
> We can then bring in eagerness later and have the same situation of
> max_ptes_none being a parameter that exists (plus this additional read-on=
ly
> parameter).
>
> > +
> > +     return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> > +
> > +}
> > +
> >  void khugepaged_enter_vma(struct vm_area_struct *vma,
> >                         vm_flags_t vm_flags)
> >  {
> > @@ -546,7 +579,7 @@ static int __collapse_huge_page_isolate(struct vm_a=
rea_struct *vma,
> >       pte_t *_pte;
> >       int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, refer=
enced =3D 0;
> >       const unsigned long nr_pages =3D 1UL << order;
> > -     int max_ptes_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_ORDE=
R - order);
> > +     int max_ptes_none =3D collapse_max_ptes_none(order, !cc->is_khuge=
paged);
> >
> >       for (_pte =3D pte; _pte < pte + nr_pages;
> >            _pte++, addr +=3D PAGE_SIZE) {
> > --
> > 2.51.0
> >
>


