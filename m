Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91081C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEFF6B00B0; Tue,  5 Aug 2025 13:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2782A6B00B1; Tue,  5 Aug 2025 13:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119C36B00B2; Tue,  5 Aug 2025 13:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1EB76B00B0
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:12:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C5981401AB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:12:50 +0000 (UTC)
X-FDA: 83743348500.28.9580E02
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id A6D9140005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:12:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GMK7eXS0;
	spf=pass (imf17.hostedemail.com: domain of jyescas@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754413968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbqWwHu/MN3vqLicN/YCVD8yPLwHYccLVOVJvse0Ql4=;
	b=NQtwuJObgLKPe+MIokgLTPisfrLkB09tbNFSSlAlmrmPIhy4cct+883NLiv8FECNST44/k
	AVtR5Q4u1ObARTPDNDwFsOoAEr+T+1KUv56+uERLfaNp0Nqd4kbNin6wnhJl05QBmY9aVI
	fPF5nXst2M35mxoVCoawOOlyn0w7VdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754413968; a=rsa-sha256;
	cv=none;
	b=NzFClSwRext2XRMUIs4DH8taQisKlWB/HpjP60cpKVBRJr05R7hJOMOqSrnBaEKn9W9M0G
	B6aZqygkFzaUDYToAM3yVCrBGzdKPyYZLRw3sHV2czG9Z1N3vUmcT3Q+tkERZNd9V3InPB
	Wi9SINaMKX1YVzdUzpUZd4fmUc+XfZ0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GMK7eXS0;
	spf=pass (imf17.hostedemail.com: domain of jyescas@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24070dd87e4so10615ad.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 10:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754413967; x=1755018767; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZbqWwHu/MN3vqLicN/YCVD8yPLwHYccLVOVJvse0Ql4=;
        b=GMK7eXS0m/sP9qf/oyU7JxPim7Ec/cNEUGZEov3xaV2yU1nPqL2XnE42FThv1qve9L
         cssud5B3kpmbGGuT1+Eq2SMzuVBYptirlLkjQEZg20IOoJEkAQ97T5mMGUHnHA6yJtBc
         WSf3JvQ2l4J7Ghf+a/dTa7ER9WdQuOxXqgq6+uBGKPUcNzMu35021tD3KZM51qVH+3Cq
         pqks00jMkL17mHSsNo4DABdwNgARXGm0LFqt4W+0CHjCle6eSAEcJfRU6Vm1EtY/NY5j
         GVxFMszEtL3p9FZ0ORM6oWVSlta0Y1F0HxfKSP6VO4Uxuucrl/ZiG8exviyfFG+56Xt/
         VqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754413967; x=1755018767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZbqWwHu/MN3vqLicN/YCVD8yPLwHYccLVOVJvse0Ql4=;
        b=s8A0EtQlN96WaZPm8d378gxZGX9nIY/nOIhRW05Fy9O1hw2fJtjnlQnkk6EnG+DkUI
         PqAm9/GidLZ5Neu2NV5kPNv8dDuUe5ODwJQyWa6pfV3phe2FG/EyxSwWQqfVRTJ1EMZq
         PWanl/6Wm7Ow4afOOIMzC0qcRLAwRaomDv8xIFkzXT3ing3ZBlZN8yqYmZvpEnQDFAHg
         a4heN61Tcy4eocwGTh+W1oVabMJVbvZ5EJosbQYcQT772YgZf6q0R32QGKBFW14F+W2f
         7VWu6j3RIlpMjhiNe6THzj+1XuFs5haNc+xSk9Xs80a46cjsbHsA9QYvmj69vpej0K6S
         YSbg==
X-Forwarded-Encrypted: i=1; AJvYcCUb81g1uWkR8jqZoPPs5wyeVlieT8bSG98fOJCl6rGiT6+oIUWuDcpo0xHQfeqHlNfuf6S2OV6hGg==@kvack.org
X-Gm-Message-State: AOJu0YyXocRkFrQlqz8IzOcU36fDdoK9E3cZWS1en8xHceqvVr4IUi8h
	qMMbO8ZDkcvzEUJBQOsTtcH7CsBsP5pZjY2PIvgFN3G9ZsTxU2zAy3F/p3rjRux74/e0oM148nX
	XmgypUni8cS2AqKVtL7ZIWNIrHYaQIlZVrwL5XsDD
X-Gm-Gg: ASbGnctfqPOigoKP93IAyT1Ea2gkZ0S+CxXv50Fpl1i4w6PAxjXO5Z7lFLnpZD/ZKG0
	NmoUSU+LUHpCa8sxWClWKKjXqVD9jUcn7uoW+u0BkU3wtV3Q7qbMnVs6uvXjlwBHz2VbhcZ0LY8
	QlOyruzvGqRw4bE8wJiO57DJdMeMTpfXUoqxG4eWXQ6OMMTrF+CWQ/u733Y5X2LuV4wELLDyTAz
	wfnj/p4wDCOtuMgnSv7xYpLemhlLGr7qtCZi/OR
X-Google-Smtp-Source: AGHT+IFqLQ/GSA1XGpDzG6V9bPnbhZrv/PKGEBMGpW4YJVcfW/eWUxu6GeLWbRSsDGK01TuGGZ4dXbAcwThguioGfg0=
X-Received: by 2002:a17:902:fa08:b0:23f:df2c:9f0d with SMTP id
 d9443c01a7336-2428eaf87a8mr2475625ad.21.1754413967127; Tue, 05 Aug 2025
 10:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <4566222d-6b91-4789-bdd6-61e3769f5dbf@suse.cz>
In-Reply-To: <4566222d-6b91-4789-bdd6-61e3769f5dbf@suse.cz>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 5 Aug 2025 10:12:34 -0700
X-Gm-Features: Ac12FXx118qPMOpTYedhO-FDr1Ci1_iGrsVIoyffTe-jrpJNkQjp-q60_k-xYAk
Message-ID: <CAJDx_rjvYdjPYHbBDKvkaWV=-OPJG=oRdSAugaOyJAXaOVu-9w@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>, akash.tyagi@mediatek.com, 
	Andrew Morton <akpm@linux-foundation.org>, angelogioacchino.delregno@collabora.com, 
	hannes@cmpxchg.org, Brendan Jackman <jackmanb@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, 
	Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, wsd_upstream@mediatek.com, Zi Yan <ziy@nvidia.com>, 
	Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6D9140005
X-Stat-Signature: gz3x9pz7fgj4748citiqfcpjqit7ubg5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754413968-352768
X-HE-Meta: U2FsdGVkX19tLOU1ZGjQ21jbzUAoOiMRnURH+QD36t70FU5YY+wDStZ3EoqFbur1AOmcegw9BmHGzBswU3q08SSz1lh6auCLgvK7tVUei+u3up7EkgLkEeoYm7AeIUo81RPflyxg0LmgHl2GucylKX9wQuFm9V46cX9VkMxImCmmi89MTdMKzHN5bfrADUlvUvJmR7mD/kVFlNOyg0DQZzF3FFhK+OAtR4qamIZ9PrytK6UUrBXLqoLl71GqWVay6GgBhiN+pTG5qVXqth0zRXTUHMOi+3NAf353EzcSw/FGNN2Olp4ObbgjA4Znakei5bJxe6qH1jGE31yszjHXjIRkpZVglfTkDXHL2vv6HnMSN5f8cxmcYJ8jLvAV+dC5Jp6agtAbnKjdVtj3FMKyNu9W4RaurkfjRBPRFs3v4e5RpncYXud4rJrc5+sj8faKTry0dDatN4UuE1VPpdKAU5WvA38QzWmvi5u0nhvzXP6WAUAlH/Z+KRHFfkBrEsTBfqWA9St3O4cqd0rQb6xUp50lijBgzd8NwuhN7yuMfZiXqUYvVoKU/st33mMyVRje3ckZLuONO1aFYFM/AettZTm0d5JRStpG8APb9VvMCkIEQOWkfPAgrZ6PI0uG09HWHLvFjK06AA5i2HK9KOFjW67HC4lWZbpSDpTpgzBXIIn2j44SROb1wMabObuNIzgb3SvQAh9TZNR8fOpGBu5tYr6fd2Vf8tcVGEQGYnlI+qyrSFlJ5pC3trkNbAOxnAi+unxdI6FUtUpnx8jL+NfCSn4jT5KvZahdyYjdTDVz02Hyv5czP6AjXJds+5YHVDuCld//qv6lu07Zc8db6xKUYhSsUuoHnTSebM4Yvu3ECvR6u+0p/nuJiKUqVTBHdInG+oZWo3X+OeEGdUv609AYWtzIuJavnycouA1snzxtIZAMAlV7z1Ja7F+TkWZrRrQzFTkWiqcowhwBC6rDlw0
 ZUA0i+8o
 Z8tny/XLbxAb71WPoYdY/LH3hV97SzVhQ3S11x/m3UldW72VZ6Oakf9POG9Wk/erhWZTEwe30bAebVrPVIWUz9GN9DKLQk0j+SBPNOGw4zmvkdC/sDOOUpj9Ox4HEp5m4bLKDCuT1L4G4tTvzGv1pFogT7DyC2V5yf97ZJOY5hYhg4fcux4UiMSBRuSekrhzmCnoamVIth2XuYm7luL5vOdSUW9sDlBHwikdiU+DVIoQp/gspytAMFwex4YSwKEOUi3WWpcuXTbOA2jWgGpurxf+DOMgsdqk/iRlSCSgf4+UhH9lw8ey8WakC4BReuGVGgfM3Xtv5uaHPb3WLo7UiN4EWH77746DRduRKWu7QyvSNo5XjnvjR95f2kUqyfkbCDZ0pCFSTlEpvhqrH89l+qasY4cEnjGbfdvNR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 2:52=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 8/5/25 3:22 AM, Juan Yescas wrote:
> > On Mon, Aug 4, 2025 at 11:50=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 04.08.25 20:20, Juan Yescas wrote:
> >>> Hi David/Zi,
> >>>
> >>> Is there any reason why the MIGRATE_CMA pages are not in the PCP list=
s?
> >>>
> >>> There are many devices that need fast allocation of MIGRATE_CMA pages=
,
> >>> and they have to get them from the buddy allocator, which is a bit
> >>> slower in comparison to the PCP lists.
> >>>
> >>> We also have cases where the MIGRATE_CMA memory requirements are big.
> >>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 5=
00MiBs.
> >>> These cases would benefit if we have THPs for CMAs.
> >>>
> >>> Could we add the support for MIGRATE_CMA pages on the PCP and THP lis=
ts?
> >>
> >> Remember how CMA memory is used:
> >>
> >> The owner allocates it through cma_alloc() and friends, where the CMA
> >> allocator will try allocating *specific physical memory regions* using
> >> alloc_contig_range(). It doesn't just go ahead and pick a random CMA
> >> page from the buddy (or PCP) lists. Doesn't work (just imagine having
> >> different CMA areas etc).
> >>
> >> Anybody else is free to use CMA pages for MOVABLE allocations. So we
> >> treat them as being MOVABLE on the PCP.
> >>
> >> Having a separate CMA PCP list doesn't solve or speedup anything, real=
ly.
> >>
> >
> > Thanks David for the quick overview.
> >
> >> I still have no clue what this patch here tried to solve: it doesn't
> >> make any sense.
> >>
> >
> > The story started with this out of tree patch that is part of Android.
> >
> > https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.o=
rg/T/#u
> >
> > This patch introduced the __GFP_CMA flag that allocates pages from
> > MIGRATE_MOVABLE
> > or MIGRATE_CMA.
>
> What kinds of allocations would then use __GFP_CMA?

The __GFP_CMA allocations are used to allocate userspace anonymous memory. =
This
was done initially in the alloc_zeroed_user_highpage_movable()
function, now it is done
in vma_alloc_zeroed_movable_folio().

> (let me try guess
> one - zswap backend?)

Yep, the __GFP_CMA pages are also used in zram block driver.

Thanks
Juan

> > What it happens then, it is that the MIGRATE_MOVABLE
> > pages in the
> > PCP lists were consumed pretty fast. To solve this issue, the PCP
> > MIGRATE_CMA list was added.
> > This list is initialized by rmqueue_bulk() when it is empty. That's
> > how we end up with the PCP MIGRATE_CMA list
> > in Android. In addition to this, the THP list for MIGRATE_MOVABLE was
> > allowed to contain
> > MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be used
> > for THP MIGRATE_MOVABLE
> > making later allocations from THP MIGRATE_CMA to fail.
>
> If you don't want THP's to use the large (THP-sized) MIGRATE_CMA pages,
> what kind of such large allocations would be ok to use MIGRATE_CMA then?
> > These workarounds are mainly because we need to solve this issue upstre=
am:
> >
> > - When devices reserve big blocks of MIGRATE_CMA pages, the
> > underutilized MIGRATE_CMA
> > can fall back to MIGRATE_MOVABLE and these pages can be pinned, so if
> > we require MIGRATE_CMA
> > pages, the allocations might fail.
> >
> > I remember that you presented the problem in LPC. Were you able to
> > make some progress on that?
> >
> > Thanks
> > Juan
> >
> >
> >
> >
> >
> >> --
> >> Cheers,
> >>
> >> David / dhildenb
> >>
>

