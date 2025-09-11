Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A22CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED1F8E0006; Thu, 11 Sep 2025 13:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC48D6B0008; Thu, 11 Sep 2025 13:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E020B8E0006; Thu, 11 Sep 2025 13:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF2116B0005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:04:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E5C886B4E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:04:04 +0000 (UTC)
X-FDA: 83877592008.30.3ED121A
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9330A0015
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:04:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y08OLupg;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQgslLEwd32nm06AW1hca6ZfctObnHJl9ok4oFIr7kY=;
	b=1UimRaYEHxSt8aRH2x0txhwLIcYWvB0wAiiiJQSD5I+igLfV0m0qde0i2s0B8qeIdbmTLL
	QN0FWm4wf4tH9RqYptUTZ18kNue524mF0j15T65Jr1j86RB/T+msFW7qiWMwqrDywZpLNt
	H+diyzPUohdyf15aBhruh8UFr8HwnS4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y08OLupg;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610242; a=rsa-sha256;
	cv=none;
	b=Ddu4WwxUKUeGD3kYhY9qKVomBmloIIDee3zGgoQlbnlne3GyntvvdXKKUitdyrHD5kW6X+
	vJEHYjfS8CFSrGF3PgrJqrh7nutxZWzB41l9TCb6K20EGtOWGfV+Lqj75WeURk3uPxasU+
	6vQmNR5yRehlmXRJhr+8EtiViwZ2OzM=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b4bcb9638aso31321cf.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757610242; x=1758215042; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQgslLEwd32nm06AW1hca6ZfctObnHJl9ok4oFIr7kY=;
        b=y08OLupg7KU4c2RHuDA/uqlSpQ8vVetTG1o1ITCNcI4f1i4tvXjN6OdggwxOSEISm6
         32FqOYY6u0LBydnOSyguE6MMZsowMpbVVecDnAT9m0IaRlC/gRgia7oZ7iVf/ZUI18d6
         po8kwUiSVSVomVwQXzxBy5uhAkrmykW+L45raj6RciYZeY68TFQmwofMbAS/IOoLDClr
         VxFigHTtLNdllxxhIYnRvZk0JI0IobSYle0ZaQ2zFqIb2SaIbvFwyw8xbnV2znUFnMzp
         6tjw+l9bV0kTdlJViK3CjnMC4wpu7X0hvBfeFhLqn+GfrGRXKaOPKM5OUHg4nZnkzzc5
         qsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757610242; x=1758215042;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AQgslLEwd32nm06AW1hca6ZfctObnHJl9ok4oFIr7kY=;
        b=e9Arj/X4M+Gn4kmv/zhjLP13G7HfjdJk8lCK6tL1ZZa3i+jK3RU1Py8QGszvVzIC9n
         WWtJDjC4qpeoknbKlGGB4JpMxCbcG2L8hapvnL2RE16le03XyNXBMp4DN5F5iI4FFa27
         oVGqhxesWI6ktqJZuVHbqs5zc68MkR1eg6N7oGxRS2QFAdF9RWEfWz0ynwDs/sgUzHaq
         mzrk77ICiu/sQJCT/FsZ3OsUnvpen0U4C1G0/9J1CjfI42o370N4zdDmMzMtcaE35xn4
         QSKotmxFSVgPZmh9y0fDXS6HoMK+ny7/inGN+lLUWDN8KY1DKbD5rCRDuEob9iwt5r8/
         Bqiw==
X-Forwarded-Encrypted: i=1; AJvYcCW1j/AIVGbacvfeCvB6iwjLSK80ZMXY40O/Gh9K/apIwi2s66fJd1hC7zzRcsPNiQETkfS2Kr82eQ==@kvack.org
X-Gm-Message-State: AOJu0YzynwWyq88iJo/7qrbYtTSphkHoMftKsmwUJyfsrIjmcYQvIqY3
	YCWu2O/P68YPBb50NaqiKboga1KLwu8W3plpaPys9asVnCdRuXf7iS/Mn4gP4PrrPIjY0rdPSiv
	cFSa6sodNzIKh/rAAw96hs5oQPmPqQ18P/MYqIurs
X-Gm-Gg: ASbGncsXL7NtmpyNwSm+yQgJV70NK88J29vDWpxqCN80LzToKia3qExa+wLBwhqW0vs
	kBBQmKv26pRHP9yrq1EnGPluaVQFD75dYWX+vy7eLSJ1frP5LnDryyTL6MTWqwvtOGxdORvDnGx
	DQY5E729Ikez1mYFRHAIUfsXsDIJr90+bWpDPMAmIeREU/z/VXLNI9+YnIZU+vQDeDbenSPpZTI
	g+Pdx72qyOiwHnFjUA/J/HehOsXfMEcLskrctXgawF5GYi6ShpjDu8=
X-Google-Smtp-Source: AGHT+IHqbiGah87j8zSM/09k9x/M4LWKB8k+6W9TDlBfbElMpUdW6cfAK3HgAE1jbY83Odjkmyb7AUicNQ8GOcD1nGQ=
X-Received: by 2002:ac8:5841:0:b0:4b4:979d:8764 with SMTP id
 d75a77b69052e-4b626f0f0f7mr14105241cf.19.1757610241449; Thu, 11 Sep 2025
 10:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-8-Liam.Howlett@oracle.com> <CAJuCfpG4D4ikZO1c8zN7HNgLTAco1ggk21rg9AUFwoztA95qSA@mail.gmail.com>
 <dfd8b8c6-d697-4032-be2a-569b9629c564@lucifer.local> <CAJuCfpGFXbSFnqQtikNq0RoMfc93cLLnqrApq8211H+FpZpJ1Q@mail.gmail.com>
 <aw6vbshqvskf6lwql354dc7xn4dh445uaadbqoydzai3rnbbc7@j2lm7ryywi4o>
In-Reply-To: <aw6vbshqvskf6lwql354dc7xn4dh445uaadbqoydzai3rnbbc7@j2lm7ryywi4o>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 10:03:50 -0700
X-Gm-Features: AS18NWCx7qwqt4iajy7xB4ie291-ePMvSQJ3leQlwvyqSDueOKTvF8feEM27VyY
Message-ID: <CAJuCfpEuuS+OnARDNQVcK4WnYkWJ-3t5woCN4QMOK86OSUSAog@mail.gmail.com>
Subject: Re: [PATCH v1 7/9] mm: Introduce unmap_desc struct to reduce function arguments
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C9330A0015
X-Stat-Signature: gzyb6kmk5oxhmsxr8zko5xht4ebohumk
X-HE-Tag: 1757610242-215082
X-HE-Meta: U2FsdGVkX19Nz4P9Q3lddEfLvPSm+3OI0ZCvrk4nBzfKM6YqYnaOx5Z9SvvSqYfzUjDWGQ51+FfJoKV75AMGww/2jqL2S9KiGj0WNnIqpG3BFkstQEh4iH0gWX7q3OB9D7/87NkYcqrQFT5qzVWDl/UfkVI1s2M9doF7HxMThRsdLhPezYEuJwHRTu6Dszp/5Pu3kSPG0DQk02RNYwofWsH1uvHDHlbwy9IXcUeNBwnO5jrSNmKfWeFj/7D0AJrqGQYnU6PLXwg25pQ32mZwIR1/AfOqsWn7/HyYPeZZEJ+eysPng/B8oMoUIuQPGkTwpBQm5c7CW99VMiwo2ORLMGVEjwGFujl5N9g/TJofw6ZWY5V7fsf/StlY6Uj3Cd6MOFDkP44IcSYL4hPTnEJGYjwLICJgwOzO7vUcQu0dnRNI1gjTmIL0L7oszHxNMP51RKZhukHs1yvXHn2lsiBmB2qtlfbnskJWfOqOubr37evFMYz6ReFsGtK2k6IO62Fc1pSH9Rv/G7/glFVT2D1CNS/puv5bGl85MHjeYHfQdKuGubTW+j0CaicCqUo3hdHKVMDEvlCg5UfGkp5AzUq8Kk7Gr3H1w6ji7NHzKj3e6gTcq5r6a3ykxWG95ToXeTlCenrtG7pFSnFHFkWarg+rNNTUcHOBbLqze+JqlBSjmFwqshw842csPFLAkLabV54VTsolpWGKWQH0BUyne402g4Ki4agE2WzvQ1avk26MKInGuCbvirLEXX5mPK0F0D9Y01h0jWyNmh0FZC+29s/XX/SYsf9VEo/JVwlALWD8MhXbWZk/OsmMFj8kOOdTkOxaMAitga5a3lOv+fzksN7UT9D7wVX2N5/wnozFKgm39629G0tGk5n4/Smc+5u2e8EmI2qxGJowudkmGtQsh5zFZmhr6N7hXsuJDGByZZfz8aw3LMY9ua09bUlV6bIshs6DmqjxCYQ3HVz3HOYOQ7Y
 BV1Ad5+E
 7rrjfzOHaFc1oxNlhZLf0KqyhjBRIRB6vzA34mvHQWhJnn0TZaqgH5CzsWyXpJwqgnnCFi2AaKf9eDlOCXShknIBlO4JayEM7BR10mHoOuoaQ0H0cpTYVeZjXCg2ptpsPxrqiINmqXuOo49nDOT+GtZuESeav7xTJ+yDzGEA0cW7Nl8bljnZCy6aozqy44b9d876byQNvHwFLebfIE0OPP4f7R2UBxaOs2E7u+w/oNWSD9ASIMAyxL5yOK0y1qQxAENs/j8KBY+PsdQIoM0zk3D+qDVkk0XmlvpXF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 9:56=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [250911 12:51]:
> > On Thu, Sep 11, 2025 at 2:22=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Tue, Sep 09, 2025 at 02:44:05PM -0700, Suren Baghdasaryan wrote:
> > > > On Tue, Sep 9, 2025 at 12:11=E2=80=AFPM Liam R. Howlett <Liam.Howle=
tt@oracle.com> wrote:
> > > > > +struct unmap_desc {
> > > > > +       struct  ma_state *mas;        /* the maple state point to=
 the first vma */
> > > > > +       struct vm_area_struct *first; /* The first vma */
> > > > > +       unsigned long first_pgaddr;   /* The first pagetable addr=
ess to free */
> > > > > +       unsigned long last_pgaddr;    /* The last pagetable addre=
ss to free */
> > > > > +       unsigned long vma_min;        /* The min vma address */
> > > > > +       unsigned long vma_max;        /* The max vma address */
> > > > > +       unsigned long tree_max;       /* Maximum for the vma tree=
 search */
> > > > > +       unsigned long tree_reset;     /* Where to reset the vma t=
ree walk */
> > > > > +       bool mm_wr_locked;            /* If the mmap write lock i=
s held */
> > > > > +};
> > > > > +
> > > > > +#define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev=
, _next)      \
> > > >
> > > > Maybe DEFINE_UNMAP_REGION() similar to DEFINE_PER_CPU() or DEFINE_S=
PINLOCK()?
> > >
> > > Look at MMAP_STATE(), VMG_MMAP_STATE() for precedent in vma.c
> >
> > Yeah but UNMAP_REGION() sounds like an action while MMAP_STATE(),
> > VMG_MMAP_STATE() do not. Anyway, whatever works I guess.
>
> Is UNMAP_STATE() okay?

I think so.

