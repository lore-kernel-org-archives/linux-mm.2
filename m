Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B410CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49406B0012; Tue,  9 Sep 2025 02:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA086B0022; Tue,  9 Sep 2025 02:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8C96B0023; Tue,  9 Sep 2025 02:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 978E06B0012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:37:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B27EB8F73
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:37:26 +0000 (UTC)
X-FDA: 83868755292.10.E1160F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id A9C41C0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:37:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OLt/T5Ej";
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757399843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqG3RTyS1kzfQKhWZN5qquD47StQlgHE41X7mr5xwLY=;
	b=t5ridEYL7awoAJ/c2T3MbxdCTPWIWVnBPI+sIPbN93J2K8YBQ2L6yaXvYazg5i0kje10b0
	J1O7oCAV9GbPRrSBGcuwFTw3cIToT/eEebHZUvocRtSl5Hu+zG+sMK4PP4m0prHgrgBDm8
	gdQedBITlySLx6coIEfUsNbtNagJpl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757399843; a=rsa-sha256;
	cv=none;
	b=63btdJnJH5x7Kg1JCRm/deZcieaWRK2y9lYxX5IQwvqRIZaW+UdbqZooK6bQwj+zBzxE2B
	+9/uILxBKfsG8PrfonJm6xu+Vt7e9cEDv6RnO6/xz+FtgQ9J/kJNBZ1lYPUzSdNiFMjMkK
	sQ/tZZFAC8GMnXFaN4SxFQFuqNvvcA0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OLt/T5Ej";
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757399843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RqG3RTyS1kzfQKhWZN5qquD47StQlgHE41X7mr5xwLY=;
	b=OLt/T5EjYi5ib5s2I1V+FW9vql64CT1dehyTaa2wqW2JBaI6Wc8Nu17YysMzqFJmeuFYN4
	KkFKvgVy99MntWpK769kjaJG20RivxMj8NhA/YO1J02foSIFVBny2QPRhNUPPylybNQv6R
	Gsmd4zDIJHdRYjMm/lFkAIbZFbFxWV0=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-2bht891bMt-IAz7hnuPWKg-1; Tue, 09 Sep 2025 02:37:21 -0400
X-MC-Unique: 2bht891bMt-IAz7hnuPWKg-1
X-Mimecast-MFC-AGG-ID: 2bht891bMt-IAz7hnuPWKg_1757399841
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-60fb0c64421so2760287d50.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 23:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757399841; x=1758004641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqG3RTyS1kzfQKhWZN5qquD47StQlgHE41X7mr5xwLY=;
        b=JB4p1VW7sjEjk1Ak3F/uYXxUMAlRcDLgaCTjUXC+rUVfja9ahJCm47es+q+XQRwmMQ
         WeLnX+vZ26FTUGv0Iyw/MFileMLce8D4/XzDW1/JudPcagnLdehJgNZeSraVjTq1QXa7
         IwmJQnF1sbjYZCQ5N1fEAWChQQecUcfKGLBvwbIUKJiViH98f403Tl+I+0Oq1w7/MJYY
         29isp8wGugtQxhkam3IdxbZfpJUA/zpv34q/BJfFoVj4ERZP44C34AKOuvZtK5I8Ofc7
         io+TYyjwwdYNt5QpZzpgzKv+jmPWyZB3VsMOtuojfIVYtbM3XZfwEzX2yRoBBmNtF3ge
         NsRQ==
X-Gm-Message-State: AOJu0Yy0FAadEoL/NK5z/3Ukzm/RjptKLfz41NOTx8455EqkBO3qg14U
	MCLfsLpqSaQLdBPyj0+DZ7emgpOp0bUI/Ap0V/KUnqHRHh/9zUTEdEfMH2SKxMufcBMM8ldfmJX
	LAv5TAEamlYO+WKTX/ADo6pPnfxoOtbwOOhSMpB7GIM2V+deMJYOJXQ/OAQCh5yBUXQZuZrkhP2
	D5ghVAQetozC16cy2pWUj/5mA7OQ4=
X-Gm-Gg: ASbGncta8NjUZN7atjzdwpgq35i+tyEMn5/41vNi13k4aRbdtsCAzOrrqXloGNPbNqk
	dKs/VzYYc+47fNuYqXC5owwAzIOkp0JECOZwTLVj0vwcWRCHv1JI8B78/QtfjB4i1GqLrM5evhr
	jTkSOV5jbzRjSzkTwIIeQ5BoK309xHwkAUUNg=
X-Received: by 2002:a05:690e:144:b0:607:623b:bc86 with SMTP id 956f58d0204a3-61022a5b6afmr7711537d50.13.1757399841045;
        Mon, 08 Sep 2025 23:37:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3RLuHOOrVUGgUVWsftrAee1GOAvhURBR+lyrsCxnC5Yz6xvo+Y7AAS0EviAsb6AHXO4uFnhEL78gIvOjZTjM=
X-Received: by 2002:a05:690e:144:b0:607:623b:bc86 with SMTP id
 956f58d0204a3-61022a5b6afmr7711492d50.13.1757399840597; Mon, 08 Sep 2025
 23:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <20250819141610.626140-1-npache@redhat.com>
 <69e9c0e9-25bb-4ff6-8469-d9137a5e5a75@lucifer.local>
In-Reply-To: <69e9c0e9-25bb-4ff6-8469-d9137a5e5a75@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Tue, 9 Sep 2025 00:36:54 -0600
X-Gm-Features: Ac12FXxx2cxmv7nW-JKof664kgo6jd1Xxe4arL1d9RHPXxyd11yOp6quCb1KZ0I
Message-ID: <CAA1CXcD+E8kSA2P5JchayQb5wrwmUVPRCK+W-qiD=Xtz03ti+Q@mail.gmail.com>
Subject: Re: [PATCH v10 12/13] khugepaged: add per-order mTHP khugepaged stats
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
X-Mimecast-MFC-PROC-ID: H-h0sm2fXKLpf7sI6HBh-oV6LZa_Taxfm9DMBeWWiTM_1757399841
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A9C41C0002
X-Stat-Signature: 6wik5zudnpp4f3pz6d445osassx3n6pa
X-Rspam-User: 
X-HE-Tag: 1757399843-745356
X-HE-Meta: U2FsdGVkX1/scd49kWvUezgWvfc17NLd715esfpRHCew5MaqYVRDd/B4kspeYzw/XVjHG8SaRSRhBBVfZOjShKUsjuZyfjbRJpKhk9VJSBxtqlJ4Z4/QZSfVMnvLKhQEFSVgFlAxAwVgIZLQcMFc2UHWM+/SpHRJdDNYq46TLfwFux25sbh96ex3XA+yni5+5Oqn5EOAExBADAKLk4Wa4UimGG13VTz4eH0yiSTWuKfGI0rvXHIuX2X6nTr2OTiesP11e0CWR9mR9YjO7eCxFcF9DBJXXidLoiPuHrgJTTMxpuTRTs4JRBhPuW61Uc3vRMlMgBnvING7XAJwVOMBdWg5iAA5djgPggRJTkxS/otifTS7usD1N+4qQneODUEeP1bMAtdzsT3ZZ4Q9ZC9DnWM8BycgUcClOJKXlgjsB+G0lgBt4BhQBwa/j3Lr63NgL7JxG5yS1Q6irzmiMKmNPjww5lXVI52z3mRXVIhdXD8JvKxPJGPHR/dd5M9Ta1jIYfbMYpIOsysWDm/9nIqsX1IGuMt6NHTt9oOTdCWx5eSRHO/ELrNZ6Q3TIkNO0nfLhK4X86NdJNrg99jmk01xp6MY0naSHlX55nCNkAEXILtFeJV/ulijpAdD9YMao1fWtqafQ72xH8RxuNaZY4HICGx40n7ZUBPWZItUdPWua1jXxUSuhCZk7LN7U2CRN+IkNxgf89T5MQLLC+5LcWZNm5jPZk7d5IcNVch5BNwlXaeC2rH2uLqg6Wu8rCRHE0fXFHSJYmespd95dva1y5brFHXT2xs6WL07RGpXceQQVm2i+vCz50QUxC1Ljjqhasiefec0V9xfDNxgjjf0xK9Ck1Hwfm33I2NrTSAynRLLJ21+P/ujGJ6ydprmX5LtMOrWaR+QFDWqxunAkHNTZK/OghjhA9st+l9x1I6Gh6KnGvD6yvree7dmbVBMfF+9LoPOVgAVoVPV8++NZgvkRAz
 up567gu7
 M/ajoGuFVcUhGN73awls/hoamPLa72jrQaSZNJAUT2Lt2S81PHX7yo2tSfFig2tO3SyDvzC3i9RxoaKHA9WEt6AeH2SQTrZzvXLVSU040JMODIqKo1xr71gE6Wbswd2xpT25Fn40LQEEjaCv7n6aQRifywa6ILPlEvXTET1WM4wXAWU0qCbTYviPhDCfEUFnKG1nNEtR+g9TfzHJCUg9yhQ+MHO24nplM/dTz0TE4NwUEW7c4uUI1fqgPhJlxa/PjqCsb5b+pwctLp1PkQSrTfL2JCGIHsc0YA/Yb4Bj1P86k4YJjReXusTKdowse+brHnxH08fRRo4/fKCZf5i2Q08K6Dx7rgzOXeqKWFN5oWT5ZYU6ZTDe9uG832p/MEA0rZ0+z4ftF3erLvYKjV4sw/pCJv+bhgjV7Pou/NkqeITTdjToTu2HOW50tM0oP6G/9f7yNEhuXQCvPliy9Z4k/WHLL4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 8:49=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 19, 2025 at 08:16:10AM -0600, Nico Pache wrote:
> > With mTHP support inplace, let add the per-order mTHP stats for
> > exceeding NONE, SWAP, and SHARED.
> >
>
> This is really not enough of a commit message. Exceeding what, where, why=
,
> how? What does 'exceeding' mean here, etc. etc. More words please :)
Ok I will add more in the next version
>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  Documentation/admin-guide/mm/transhuge.rst | 17 +++++++++++++++++
> >  include/linux/huge_mm.h                    |  3 +++
> >  mm/huge_memory.c                           |  7 +++++++
> >  mm/khugepaged.c                            | 16 +++++++++++++---
> >  4 files changed, 40 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation=
/admin-guide/mm/transhuge.rst
> > index 7ccb93e22852..b85547ac4fe9 100644
> > --- a/Documentation/admin-guide/mm/transhuge.rst
> > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > @@ -705,6 +705,23 @@ nr_anon_partially_mapped
> >         an anonymous THP as "partially mapped" and count it here, even =
though it
> >         is not actually partially mapped anymore.
> >
> > +collapse_exceed_swap_pte
> > +       The number of anonymous THP which contain at least one swap PTE=
.
>
> The number of anonymous THP what? Pages? Let's be specific.
ack
>
> > +       Currently khugepaged does not support collapsing mTHP regions t=
hat
> > +       contain a swap PTE.
>
> Wait what? So we have a counter for something that's unsupported? That
> seems not so useful?
The current implementation does not support swapped out or shared
pages. However these counters allow us to monitor when a mTHP collapse
fails due to exceeding the threshold (ie 0, hitting any swapped out or
shared page)
>
> > +
> > +collapse_exceed_none_pte
> > +       The number of anonymous THP which have exceeded the none PTE th=
reshold.
>
> THP pages. What's the 'none PTE threshold'? Do you mean
> /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none ?
ack, I will expand these descriptions
>
> Let's spell that out please, this is far too vague.
>
> > +       With mTHP collapse, a bitmap is used to gather the state of a P=
MD region
> > +       and is then recursively checked from largest to smallest order =
against
> > +       the scaled max_ptes_none count. This counter indicates that the=
 next
> > +       enabled order will be checked.
>
> I think you really need to expand upon this as this is confusing and vagu=
e.
>
> I also don't think saying 'recursive' here really benefits anything, Just
> saying that we try to collapse the largest mTHP size we can in each
> instance, and then give a more 'words-y' explanation as to how
> max_ptes_none is (in effect) converted to a ratio of a PMD, and then that
> ratio is applied to the mTHP sizes.
>
> You can then go on to say that this counter measures the number of
> occasions in which this occurred.
ack I will clean it up
>
> > +
> > +collapse_exceed_shared_pte
> > +       The number of anonymous THP which contain at least one shared P=
TE.
>
> anonymous THP pages right? :)
regions?
>
> > +       Currently khugepaged does not support collapsing mTHP regions t=
hat
> > +       contain a shared PTE.
>
> Again I don't really understand the purpose of creating a counter for
> something we don't support.
see above
>
> Let's add it when we support it.
>
> I also in this case and the exceed swap case don't understand what you me=
an
> by exceed here, you need to spell this out clearly.
>
> Perhaps the context missing here is that you _also_ count THP events in
> these counters.
>
> But again, given we have THP_... counters for the stats mTHP doesn't do
> yet, I'd say adding these is pointless.
>
> > +
> >  As the system ages, allocating huge pages may be expensive as the
> >  system uses memory compaction to copy data around memory to free a
> >  huge page for use. There are some counters in ``/proc/vmstat`` to help
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 4ada5d1f7297..6f1593d0b4b5 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -144,6 +144,9 @@ enum mthp_stat_item {
> >       MTHP_STAT_SPLIT_DEFERRED,
> >       MTHP_STAT_NR_ANON,
> >       MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> > +     MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> > +     MTHP_STAT_COLLAPSE_EXCEED_NONE,
> > +     MTHP_STAT_COLLAPSE_EXCEED_SHARED,
>
> Wh do we put 'collapse' here but not in the THP equivalents?
to indicate they come from the collapse functionality. I can shorten
it by removing COLLAPSE if youd like
>
> >       __MTHP_STAT_COUNT
> >  };
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 20d005c2c61f..9f0470c3e983 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -639,6 +639,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLI=
T_FAILED);
> >  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
> >  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
> >  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PART=
IALLY_MAPPED);
> > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXC=
EED_SWAP);
> > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXC=
EED_NONE);
> > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_E=
XCEED_SHARED);
> > +
> >
> >  static struct attribute *anon_stats_attrs[] =3D {
> >       &anon_fault_alloc_attr.attr,
> > @@ -655,6 +659,9 @@ static struct attribute *anon_stats_attrs[] =3D {
> >       &split_deferred_attr.attr,
> >       &nr_anon_attr.attr,
> >       &nr_anon_partially_mapped_attr.attr,
> > +     &collapse_exceed_swap_pte_attr.attr,
> > +     &collapse_exceed_none_pte_attr.attr,
> > +     &collapse_exceed_shared_pte_attr.attr,
> >       NULL,
> >  };
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index c13bc583a368..5a3386043f39 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -594,7 +594,9 @@ static int __collapse_huge_page_isolate(struct vm_a=
rea_struct *vma,
> >                               continue;
> >                       } else {
> >                               result =3D SCAN_EXCEED_NONE_PTE;
> > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>
> Hm so wait you were miscounting statistics in patch 10/13 when you turned
> all this one? That's not good.
>
> This should be in place _first_ before enabling the feature.
Ok I can move them around.
>
> > +                             if (order =3D=3D HPAGE_PMD_ORDER)
> > +                                     count_vm_event(THP_SCAN_EXCEED_NO=
NE_PTE);
> > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_NONE);
> >                               goto out;
> >                       }
> >               }
> > @@ -633,10 +635,17 @@ static int __collapse_huge_page_isolate(struct vm=
_area_struct *vma,
> >                        * shared may cause a future higher order collaps=
e on a
> >                        * rescan of the same range.
> >                        */
> > -                     if (order !=3D HPAGE_PMD_ORDER || (cc->is_khugepa=
ged &&
> > -                         shared > khugepaged_max_ptes_shared)) {
> > +                     if (order !=3D HPAGE_PMD_ORDER) {
>
> Hm wait what? I dont understand what's going on here? You're no longer
> actually doing any check except order !=3D HPAGE_PMD_ORDER?... am I missn=
ig
> something?
>
> Again why we are bothering to maintain a counter that doesn't mean anythi=
ng
> I don't know? I may be misinterpreting somehow however.
>
> > +                             result =3D SCAN_EXCEED_SHARED_PTE;
> > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_SHARED);
> > +                             goto out;
> > +                     }
> > +
> > +                     if (cc->is_khugepaged &&
> > +                         shared > khugepaged_max_ptes_shared) {
> >                               result =3D SCAN_EXCEED_SHARED_PTE;
> >                               count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
> > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_SHARED);
> >                               goto out;
> >                       }
> >               }
> > @@ -1084,6 +1093,7 @@ static int __collapse_huge_page_swapin(struct mm_=
struct *mm,
> >                * range.
> >                */
> >               if (order !=3D HPAGE_PMD_ORDER) {
> > +                     count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_=
SWAP);
>
> This again seems surely to not be testing for what it claims to be
> tracking? I may again be missing context here.
We are bailing out of the mTHP collapse due to it having a SWAP page.
In turn exceeding our threshold of 0.

Cheers,
-- Nico
>
> >                       pte_unmap(pte);
> >                       mmap_read_unlock(mm);
> >                       result =3D SCAN_EXCEED_SWAP_PTE;
> > --
> > 2.50.1
> >
>


