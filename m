Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA469F31E53
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3A76B0005; Thu,  9 Apr 2026 11:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B396B0089; Thu,  9 Apr 2026 11:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1276B0092; Thu,  9 Apr 2026 11:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37B386B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:57:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC9B8E30EB
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:57:55 +0000 (UTC)
X-FDA: 84639473310.01.17730DE
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id CE53240013
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:57:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jAFAFjmz;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of jyescas@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJSTtlawRgNunuP+iBc/3XE7chPGEsUsV+rdzUKnPRw=;
	b=UK25K0VHc2DmP3ikjpfvE1cpS957e5OeyHdhdEFkTYflokry5ie0XWbij/suavVOEsw5HC
	24a5SafSEsy6zRkDsLUosxWGMxd1frEJ1QPW0OhdBhCzRaPht5zqTcxUy/MuwWp5JswVHw
	8bkiBWeVuFrEpcEcv6LN0HwH6rNe4z0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775750273; a=rsa-sha256;
	cv=pass;
	b=Xa7AstVbSpl4zRXRahHis8i/AG4LINS4Z06ADPTboaxajXF+ziPPXCnaOrCF3dLsiMz+x+
	8st4Awcg5GiqYB7gszrvsFOfg9+FSC9j7VdFf8PCXSUARbptzQjD7FrIssOymMI7LziFYH
	6GGTcb/BMe9QOuA5OgHvF2+EECqpkrk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jAFAFjmz;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of jyescas@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so116495e9.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 08:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775750272; cv=none;
        d=google.com; s=arc-20240605;
        b=j5G1zDCQVwUwyIJkWNRr4KIkXFyXv64hrzy/Pf2aicQQyOt/5dA+IqQaiPuwZnnFJn
         n0zzBBc9WxrluBjW3Hgo2SuX281D1V+brZHVIVLtzzP89V4a7/iq9w1YBkiyptLqiG0x
         0+OYtY9/zbdUy1jEGGK8IQj2lA4SFTSd677Q+hELhvvczuZR75CGNaLVzvle/30PoBo8
         i9dzRK8BpXhexLs5TFthZyi3bDM0IxRMcOv4HcwWaUd2azNajjfmnAKrHmFELDPqLYOA
         UyEK8tbuMsclLhjW4tMzEVGCYOsjhdBE8tPsyWEBFNIhlFgjHRSBN4VAGSqG/wKRKQef
         /Y6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eJSTtlawRgNunuP+iBc/3XE7chPGEsUsV+rdzUKnPRw=;
        fh=BFKNqL3oHiX5v5DUER/9S19jFMd1ZOd2OI+RdNdlWjg=;
        b=MxLROCEfmjdN8gVWoIJtr0YF6cyPufauiDE9uPAPEFq0H19Xl1vXT9wSwniXi0/wRF
         /ZsX5C2TyKWDMAn3oaODdQ9gVxZuERUSyGxFrmjGjVquMnxk4pRqJIDwVnuWBI8WdfK3
         GI2qaMo0zCM9XJ33RZsYLIRsM9AkuPGZxyNqtEveTtBqgA3HaAZDIuILP336DBOGlyPT
         dVUUs7atL0VxfS6WAvqJ0cDZBdH1Nc4wGBlsN9dXp+v07JXLohV01qCnl1wFCZRQdz0o
         GtuthhVFOACam9FJlBQ2nxxg6eMvmRI4//5Lw6DUBjhWn/9sRKfNALgkiBqDWUTkCkK4
         zPiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775750272; x=1776355072; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJSTtlawRgNunuP+iBc/3XE7chPGEsUsV+rdzUKnPRw=;
        b=jAFAFjmzdSEg2WzS7Awtgah7+Rafo/1O9lw8kdMhn/DHRQhbxtYA0tWCEcQuqjaq4s
         5AQtJv+AH2W/nVWpqHRhpy9NnG7EQaH/2N7AROHoDmAPsRIZic7lTubtU/mQMk6lW12n
         f88PyDDw88QUvrypUC+jv5YcrHd95o6+NbIMGG0eCRMWvyyRCbSP14DNR5RYy2PQLAGq
         LuFWaL6KYy4ik4jzpwNwHMQmn4TVO8YR/731XN4SduCBcHL2D8REgD3CPnvl3x0z2u06
         fnhGsiPxd1WD3pB1AkrWcR4Ck/LZ8XeqnAv5TIrCJOrRwPIIGSi5+o/DN468Kp/5p4Cp
         2Urg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775750272; x=1776355072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eJSTtlawRgNunuP+iBc/3XE7chPGEsUsV+rdzUKnPRw=;
        b=dOZ9ePwUBk49fp1jCoumzKGNbfJdUhgW+zhx0hjZGTa564324c/C/c6A9XOvSbgrY4
         KtZ6terxU4DYFPYfMGUMhLO1twKy1waemYGv5/EdHgzFPn6B//uZNl6nByIgkZf0SwFC
         muKhfDpfRgY4DMjEwxlYunIKExnxW80QMiPKnCQtQjsHYeQh4Qp+4Cb/xUxQlkIdHOmf
         p/mwYKIKSrcA7hvGelPElfHCOXW5XT74vHAic55kUx0jDRhVxtR/csTTHUBYyosFaChE
         pM0mbNyMa8qK+BkUfcOaGmjMuvRyZch8vTQ+5KAICUSmVbFVkM4Uta00Ucnxhux78i73
         rm2A==
X-Forwarded-Encrypted: i=1; AJvYcCXkTi7Vvulra3efDBD1A/vmBppcBkhztrloJDw0j3MjpB17RiS90ppH32wVw3tlSncCNG6Z4Ef1IA==@kvack.org
X-Gm-Message-State: AOJu0YwlFkbWXNIORjSwIJvIaEMT44ZG2Kyr34rhqnS+cUNAno9CXVRH
	s4V3AVYpiwc7sGqJ6Y35GW3zn95yGveQUZnhbr5nAw7saf8TQYy905W8D6eN427kT2lfmQVIiUr
	lG7DqpWBArcgjgf/yWPccHx/MyANfxA3iC4X7pY/3
X-Gm-Gg: AeBDieuXzfzsZOAnWBVewNq++jQEvtUY1gBiGIXkzoNknvObhf6Ct0iU2eUy0G9RESd
	0iTjLr6jcI6r0NIaoFodJL3fCE6UUyz7Irk1j2XVb62Njchbnv8tKQA+LHBsmPXLsEvvRfkKI/V
	iV2qu9gBSx8bUbO5xp8HQuiOU5uA4Qz2zKOSKOonL+iDGU9B4i6seA8FkRuuU1Klt5ZykJuGRjB
	bZgzV7XOCsgmtABDAu2NGnQAUE+9EVvHDWrO5Cv9PLcapwVljkW+U8ZG67oxKw86ZzYlPGr9EH6
	xke/vIbsaDaB3CA1n4wwxTICiyX1oGHOkStic7W4mGqucZZI0ZRz
X-Received: by 2002:a05:600d:108:10b0:477:86fd:fb49 with SMTP id
 5b1f17b1804b1-488ce10217emr1042425e9.10.1775750271535; Thu, 09 Apr 2026
 08:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org> <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
 <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org> <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
 <e63e0ab9-75bd-4a7f-9400-a8f87c80d1f0@kernel.org> <CAJDx_rjk-5pp5Z884bnTBss19Xk0msEayR=GAMG2wWCk+WOZ=A@mail.gmail.com>
 <aa8e148f-252f-4d81-89db-b1702d9b6888@kernel.org>
In-Reply-To: <aa8e148f-252f-4d81-89db-b1702d9b6888@kernel.org>
From: Juan Yescas <jyescas@google.com>
Date: Thu, 9 Apr 2026 08:57:40 -0700
X-Gm-Features: AQROBzC2DseDS-XJ6oE-Y5WQZARE-rgVqrB1Ga_OYxeZ-BYZIW2DWalkgTGqurM
Message-ID: <CAJDx_rjgyi-L-1j2kpi1NeKj+Huynd6ZFqJDmYqN8i8L3KyBfw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via debugfs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	android-mm <android-mm@google.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CE53240013
X-Stat-Signature: u8k77oz5qf79xqumq3obft1jsz9r89xf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775750273-388639
X-HE-Meta: U2FsdGVkX1/98RI3zPaVMyZygODQYmecSWNSUtxlp7JMzchZYWj46tM9KuYTaso/fVoTwe26KHJ8MIVv4DXOkpl1UAeoK0YvuhUbRyRcgndAC9vLByr9OzwH8Y4G01YjT9TmFt+8fDQ1Y6c3S+KwJFmBajaGCPEC5gzCgKBpTUxGFSsP2gVDNWzVJ7DE53vkzgr6dU8EgDr4j3AZMYZpo8t6IsVfwT7eiELoJY5dmnPjZi3dY1/UfWxiVy6owc6vNhgNxr6dKYll7qkKr1gVx3B0cHvw4q/OD8zwHVpqmoawPZMVVxxLt3ZV4etrqVPLUkbqvnIO+CKBjA8WoS466kJYL4cPOuRhJ4bsrqeTeQwg1zJhFyhnvH1VoeciBYBb/O1VZWAjwCOYIm9kqMW8uH73VyLqMLyTqVjgHkitsOBsmzorCrJmJV4SWcqW7FjnEvVpXewQhHlvqzdg29G6WdgnIi4aw0vbtwi7/AUNJrCWiNabqX74HE0KEmuF++lESfrBCFdA64Xii2QdifAAiAaQhsHnA3CQ7pTmxU2MzF4NBZ/5+L0Sc8M2nlTzbKm5yA0Qr11idgl+ICwdFEUNlVIBiSYRYwoeR5ubrVvNovZahy58TqhJeSvd/Yd7py0N3Ex7LlVepB5X19YY4g+VTCsrDkO6r0vJaXWMBMKmLFY/nYOmrKfTDUhU9b3W4cbW1RVfFW2UKUedfNfgZctL4uXOBorL+9TkJI8yDGlSepzFZg7zZxXmvQIBfKvPslU7aAhBHBaHmHndrNwseKh1hHJcldJsUBx520fyBuKQUlR3JFUOFaDX0sfn+UPMKpEzbR+OFV7uGOL9KfCtKEg3DSpUgwj1PFXfV1GNnWvJN8QXQSNRCumGJz1A9bCKJFOuYTKsaupdak7H4vt9HjPuWBs9azHQug5YldiTquVn19Yy5f72KjdvN3MXgjmyqitQhpAL/KttQLnPlQL8mU+
 YshXz7bN
 xfsM9T7vbhPIwbotVDyqZt8J4LLj2VY8cUW4aXRZqdakbHBzZZOIqfap7F8lbaTgmocS7S0CPlrqnfMy6lx6136SJ7N/le6JuBd0l5TCDTx/jjC42F98d6NnaYM+xNTzrwkqiEAxTN4J6NWvoMGYi+jnNAxJNK1QTUJfusHhhB7VMu9+YDDJxvQKiUYXcAbyyJK8UIGNkASRMboWLeugF4U4N7Jsx1vreQvVaXrd8fTC6PI8QjAIXu6039aKrs9Qjh5/d0qflJE2/sz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 9, 2026 at 1:06=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> >>
> >> echo 1 >
> >> /sys/kernel/debug/mm/node-1/zone-movable/order-10/migrate-Movable/allo=
c
> >>
> >> You are just breaking ZONE_MOVABLE guarantees. Or what am I missing?
> >
> > I see. How should the ZONE_MOVABLE allocations be handled? Should they
> > be excluded?
>
> Well, the same applies to MIGRATE_CMA: if you end up placing unmovable
> allocations in these areas, you will break these scenarios.
>

I see what you mean. I was not understanding your point. In that case,
the driver will have to remove the unmovable or
Invalid migrate types directories from the sysfs interface. Only valid
migrate types, orders will be allowed.

The same applies to ZONE_MOVABLE. Only valid migrate types must be
included in the sysfs directories.

> Your driver would have to support page migration, but that's not
> trivial. For example, movable_ops pages currently only support order-0
> pages.
>

I agree with you. If we only allow valid migrate types, we don't have
to support page migration :)

> >
> >>
> >>>
> >>>
> >>> We could use a "nr_pages" variable, but we would also need to set the
> >>> node, zone and migrate type.
> >>>
> >>> It would be cumbersome and error prone to have something like this:
> >>>
> >>> echo "Node1/zone-Normal/MIGRATE_RECLAIMABLE/8" > /proc/kernel/debug/m=
m/nr_pages
> >>
> >> I meant something like:
> >>
> >> echo 1 >
> >> /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Umovable/nr_p=
ages
> >
> > Got it, we can do something like that. It makes more sense.
> >
> >>
> >> (not sure if we really want to specify the migratetype)
> >>
> >
> > The migrate type is important because we want to make both MIGRATE_CMA
> > and MIGRATE_RECLAIMABLE allocations.
>
> See above regarding MIGRATE_CMA.
>
> But in general, bypassing the page allocator and just allocating random
> pages is not really nice, not even for a debug feature.
>

I agree. My intent is not to bypass the page allocator. We will use
the page allocator and
This will allow only valid cases (I will remove invalid migrate types
from the sysfs directories for CMA and ZONE_MOVABLE).

> In particular for the scenarios you mentioned:
>
>         - CMA allocation failures due to pinned MIGRATE_MOVABLE pages.
>
> I think some decent user-space reproducers might be a lot more elegant.
>
> I guess for CMA, you'd want a way to allocate some ordinary *user space*
> (anonymous) memory and be able to check whether the memory was allocated
> on CMA memory, to then fire up a page pinning storm and concurrently
> trying to allocate the memory.
>
> So maybe you really want a debug mechanism to migrate a (movable) user
> space page into a CMA area?
>
One intent of this driver is to debug CMA issues (pinned MOVABLE pages). Th=
is
The driver will allow easy reproduction of the case you just
mentioned. For example,
I will allocate most of the MOVABLE pages and then trigger a CMA
allocation, that might trigger a migration.

However, the driver's main goal is to put the system into low-memory condit=
ions.
so we can reproduce OOO, kswad, lmkd issues seeing in the devices.

Thanks
Juan

> --
> Cheers,
>
> David

