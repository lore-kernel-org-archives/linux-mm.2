Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7229AD111BE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 23:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E4A6B000D; Wed, 26 Nov 2025 18:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF4D6B000E; Wed, 26 Nov 2025 18:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED236B0012; Wed, 26 Nov 2025 18:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC926B000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:30:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45C2D50521
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:30:04 +0000 (UTC)
X-FDA: 84154353528.26.D2F5328
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id D302B40007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:30:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E51+Mp1M;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764199802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaAYG5VDFXsv/Iixri0H6uBMNMIoUe5mbi2ivxpfSFc=;
	b=OxssJHU5a+Ki6vheVKeLDaaVo5X+6bvYM0LyvkqfnARXuwL7Bmc2mWpJS9ZQueFhuvWUZV
	iHlNgu9/llH57gKBtEiWaPq41qae+dRoM7OReK+2Xv2Xo2pOZBCl9+fYJU5LaSTKSFh69u
	+1CsAh3WrbzMi62JdQ+3IQJaxywIWHA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764199802; a=rsa-sha256;
	cv=none;
	b=V72PH9VIxLQ3TUkvHJlxJ49X7DdDTQBCPPFLkzUnrSzySF8XRL/WErl9qnYtRr3aAlVTG4
	Aee5IyraRUFgqe0FYHeVqI9rvj+AkBEbdk3FdHQGN9THqMzfNMg0rZyf0GFF+M7uFBGw9H
	26IRUTnlNcFLgXJD/EdeQ9dDpcWrU2g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E51+Mp1M;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764199801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WaAYG5VDFXsv/Iixri0H6uBMNMIoUe5mbi2ivxpfSFc=;
	b=E51+Mp1MvNc1A4a9Hij+SOhMBvkJQ/RBkGCqH+CUhDV9u+J06dGyzedtqpTRgjwTr2TZqk
	d9AhU94UbLukoPrPWK8UQMA58mv2qVO663XE6CvQrs594rKkynYuQ0DkncgiaWBwSaRSWF
	IFHl+lgZuJhNdPgqC9mizsBWnWzKi6s=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-TvKGx900M46zrHMGFt-C6g-1; Wed, 26 Nov 2025 18:29:59 -0500
X-MC-Unique: TvKGx900M46zrHMGFt-C6g-1
X-Mimecast-MFC-AGG-ID: TvKGx900M46zrHMGFt-C6g_1764199799
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-786a0fe77d9so4591867b3.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:29:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764199799; x=1764804599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WaAYG5VDFXsv/Iixri0H6uBMNMIoUe5mbi2ivxpfSFc=;
        b=VtLqvtjaE6vam8f8nmrwV6CRIMVqNDjMvBZJrlWYZNoJKeHrFXosTWn/+VsTZCItsb
         hxKZm3iu/oG7QlVBR8QPm9LbDszl5qkPOU2j0bh0vWoyJCBqXbZZtOzshelEZMYJg7k9
         iiYqWTbA/gKdns7ebAwVSEkM61Ie6FVLfgm2AYWZYYKsm17W8jIIV3df2n1PQ2xvnlIY
         xSSPkI3TioRBlxeX0NCsuBfe6DmOVN+gYOyGNbMuSYd7sc9RpjRA2vyDR2hWh/u9j7oB
         +S+IVU3E6wkcsU4xhE3mLAf2UOtSm8kmlHYJ0sOlK/LMaV916hogMmQDgIAOxBaU7MmE
         VuwQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2NnQmGMUlJaVo9gZh95g5ARVz91PEu5wgCy6qH12sjFNkzziT6OT/hgG4J9R5dzjpnIImpCJYXw==@kvack.org
X-Gm-Message-State: AOJu0YxaAhgUZNqNXObohoUETle3C/Y/jqrgGjNNygp5L8ZFF9MHCWNV
	MT+UmebiCaGB6XST2XPysbUpg07bOA55xBof21NFbUkTV2D+bwquIjlTiDzp0nJfKsjev0H1k+g
	nV27qkggyYPfZbdo7F82ilRuvI0LbF6cTZszPVegcDkr6rdsXSKCGcaK++EQBecXFzhDrMg2hw5
	b16I7RrFFyRnbpV1XvHGih0fT0zOs=
X-Gm-Gg: ASbGncsNJUFUfJZ4+r6PhSgQ9/LtFxOyf9AiTct9pA+p4C83OI8hGTkjDCal2hxMv/u
	NHHv4QPCtRniTXyE3tcPawM2c8jmFLdmMf00dwxwtWZWbfLwMQdfKNjMsnpxwcNLtHDfCTkRSyt
	U08XVyC3oNNVua/WalF/f/5KinK0C4vjg8K1JN3S169fe6JzeUJcp7LHBuAS7sqWGR1rLnTEvGJ
	kjLK1vQ
X-Received: by 2002:a05:690c:6d11:b0:786:7017:9506 with SMTP id 00721157ae682-78a8b50d225mr179507907b3.43.1764199799266;
        Wed, 26 Nov 2025 15:29:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEM04nXlhLyHhOF4P67Ng8vhtTcvmR+j3q1fjlImcKmWBZ7ursgcIGrQVIExNz7VgFRd9eGD2XP0bTyZR5NgLY=
X-Received: by 2002:a05:690c:6d11:b0:786:7017:9506 with SMTP id
 00721157ae682-78a8b50d225mr179507437b3.43.1764199798871; Wed, 26 Nov 2025
 15:29:58 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-14-npache@redhat.com>
 <541a75fe-3635-49ab-b61f-d86afc96df98@lucifer.local>
In-Reply-To: <541a75fe-3635-49ab-b61f-d86afc96df98@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 26 Nov 2025 16:29:32 -0700
X-Gm-Features: AWmQ_bmAlUVjee7DwzVRQDWabQ2jDP4iBXrMJ-Yz-HT4KcafaonxgE42edAAM08
Message-ID: <CAA1CXcBMWc04Z+7mdDAZHkSj5WGDAMc+-4p7JiTme3xCqtNXFg@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 13/15] khugepaged: avoid unnecessary mTHP
 collapse attempts
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
X-Mimecast-MFC-PROC-ID: mpOi_P5TE_QmeaGLwunespxgwWNeg99qDWOaZLF63i4_1764199799
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D302B40007
X-Stat-Signature: ppipcr6ymjdipw9zzck46rcb4tye95cf
X-HE-Tag: 1764199801-746559
X-HE-Meta: U2FsdGVkX1+qRIxDYTkhBhkbp3DKFVSC6ltGpgKdMgAfFcm65mj/CQMOqG3hlfAyRafdorDH3FNB7givuoMS1hYX0FuhnGYpBnVSkaKrC9eS2fwXLCVbmv1xphrDgezk0sdjSNple0kRj6lrUHxM7KVJmAmHbZ2DMAWb+NMre2L2rJkou/6btFZJJtzT6RJl2CUdelhINbe8s4ACji29F/I8g910VvrnjgjLwhoZAuaRiR/SeP1/RZpqVjVcvBFFwdYtcYWzc8hdr4eGhhjWe2bC+bwvFgvx0igI3GhVqsHG4Q5LZtWPFwwtAL7KqtHxxZo3qkHH8z3KKKL57n/AjsOvdmxGBwJauSdbBX4TMetua1azGioQXjkSIcqEnWzM2bC1jkaTmvspiCMDQBPSFEJaJ4GUrnNGIK9j+auwUV/wYZ5yJxkDWfFvLIu8URGagKWUBGsJSLp+DI7Iq9ulkx58DoVhbmQ8qNY6oF81AtXUzwPW+6qUsyqNtWWRDM5Fex+wFjgXBoFzPjl3nLrk9jNUWgkMtXB61Gcy6xqz8bVECAFScXF+PiR0e58EQCzglaOusqeMh63QdbdE2IRX7rA+jSsAkx/Z2F/dCQhDxjWiPKaubmEYnxA2LaTHbFPHzGCB3ptLGBo1MsIMeMH+VAAaDOkqVZgjawvjbEX79ahfWHV+GzJ8t971Uwie5gCZv/IGymKocEtDVAv5LARduptYyPfKiy7Np+HYmxlYB8u/78RGnrsQlCMy9gWGFdwG/5vWdusiFR+FPhElTv53bRDzvmcHEHZOez1pJLOLnkTKYKrtFbNC8TNYiMmITeiWgZplznWnxpyYziblblsDyXmICVtI/Yw55M5DJEmWrrM3yTPkcnLSQYQPVl6WJzvLIgR6pHC4kDgfN2K9gfcF5SSjVKFtMpEaznTo0TGIy+XtVXuFGmkP6PSMPV+7mR6zmZC/3fAWKqqme9n/6WZ
 CSpaezML
 Q4iu2oU+5eXoCJlY2K88HgMmoh0O/ZxnbQ6RfA00hq3Ufpc83CY7h2KbHMH0sUfoad/71lrRR44QqCeL95ayQqtXYH12ww77E8iTAxGD/4IJw1ifamAVXHb47m0LL65mnbIx5F1z90Z53uuJhmHlnc2tTOf4G+DB/IHNRf/DIDUW2/O7bEwG9sohIv5UyINrymyrslWemahvIh/LrFP6jwutsQgzaCc0tchCA1S9bVt8zH5va6hVi8IiaHJHa7+nwhbBwo5dtKEcz87qSlrF0VeJzlW2gaZfBP1N+TMZ2+gPI8hVK0Q2+9MR/2Kl10aj+2bIgTlqopMd/JgAXXCw2ahTSQscsUSbWLwWk5mZDWEI9uLnH1XtfE8vqJ1tAf0vZ8p8hvz4AHVDHQadEYzHarHijT9EjX/ZvJlX8Wn1wfndL4y4uQCWOSEzfj4uhkeE7pYpSwhmEqqdcXyWyacKJ2uguZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 5:06=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 22, 2025 at 12:37:15PM -0600, Nico Pache wrote:
> > There are cases where, if an attempted collapse fails, all subsequent
> > orders are guaranteed to also fail. Avoid these collapse attempts by
> > bailing out early.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
> >  1 file changed, 30 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index e2319bfd0065..54f5c7888e46 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1431,10 +1431,39 @@ static int collapse_scan_bitmap(struct mm_struc=
t *mm, unsigned long address,
> >                       ret =3D collapse_huge_page(mm, address, reference=
d,
> >                                                unmapped, cc, mmap_locke=
d,
> >                                                order, offset);
> > -                     if (ret =3D=3D SCAN_SUCCEED) {
> > +
> > +                     /*
> > +                      * Analyze failure reason to determine next actio=
n:
> > +                      * - goto next_order: try smaller orders in same =
region
> > +                      * - continue: try other regions at same order
>
> The stack is a DFS, so this isn't correct, you may have pushed a bunch of=
 higher
> order candidate mTHPs (I don't like plain 'region') which you will also t=
rue.
>
> > +                      * - break: stop all attempts (system-wide failur=
e)
> > +                      */
>
> This comment isn't hugely helpful, just put the relevant comments next to=
 each
> of the goto, continue, break (soon to be return re: review below) stateme=
nts
> please.
>
> > +                     switch (ret) {
> > +                     /* Cases were we should continue to the next regi=
on */
> > +                     case SCAN_SUCCEED:
> >                               collapsed +=3D 1UL << order;
> > +                             fallthrough;
> > +                     case SCAN_PTE_MAPPED_HUGEPAGE:
> >                               continue;
>
> Would we not run into trouble potentially in the previous patch's impleme=
ntation
> of this examing candidate mTHPs that are part of an already existing huge=
 page,
> or would a folio check in the collapse just make this wasted work?

whoops almost missed this comment.

There is a folio check in the __collapse_huge_page_isolate function
that handles this. I think Dev has some plans to try and add
partially-mapped support as the todo comment suggests (I think he
already has some patches from earlier mTHP work).

/*
* TODO: In some cases of partially-mapped folios, we'd actually
* want to collapse.
*/

>
> > +                     /* Cases were lower orders might still succeed */
> > +                     case SCAN_LACK_REFERENCED_PAGE:
> > +                     case SCAN_EXCEED_NONE_PTE:
>
> How can we, having checked the max_pte_none, still fail due to this?
>
> > +                     case SCAN_EXCEED_SWAP_PTE:
> > +                     case SCAN_EXCEED_SHARED_PTE:
> > +                     case SCAN_PAGE_LOCK:
> > +                     case SCAN_PAGE_COUNT:
> > +                     case SCAN_PAGE_LRU:
> > +                     case SCAN_PAGE_NULL:
> > +                     case SCAN_DEL_PAGE_LRU:
> > +                     case SCAN_PTE_NON_PRESENT:
> > +                     case SCAN_PTE_UFFD_WP:
> > +                     case SCAN_ALLOC_HUGE_PAGE_FAIL:
> > +                             goto next_order;
> > +                     /* All other cases should stop collapse attempts =
*/
>
> I don't love us having a catch-all, plase spell out all cases.
>
> > +                     default:
> > +                             break;
> >                       }
> > +                     break;
>
> _Hate_ this double break. Just return collapsed please.
>
> >               }
> >
> >  next_order:
> > --
> > 2.51.0
> >
>


