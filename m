Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68828CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7098E0026; Thu, 16 Oct 2025 15:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87F98E0002; Thu, 16 Oct 2025 15:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F9D8E0026; Thu, 16 Oct 2025 15:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 815218E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:27:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 366914724A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:27:00 +0000 (UTC)
X-FDA: 84004960200.06.94CE613
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2037EC0009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:26:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bvH2s5W5;
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760642818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4K3CmGQhxkB24mFx9E87SF9HhnIB+xHsfgBt0vqC10=;
	b=FAu3AWJ0yZBtZotVIK7LE6onjBxW2z4ERnuz0aMDHFcK337tm6AErpLo2JmX9NHtcS7kVP
	PT1gD1vxpEXG0YZaXPBeMtw0NhLA6hvdf3K8ufTM+cwK1IysCZfruL/ZwM+abi07COBRXf
	b809nkSaoY25xxbcdLZ74ClheyYqHsk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bvH2s5W5;
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760642818; a=rsa-sha256;
	cv=none;
	b=sJ2oAxE/7xvlhjD/eX+ydRdjVYIaNazoXFhU2WF9ikOJneC+eRC+P1Gm0PXk2FRGjLo8fT
	N1fRoGUnovh1qRAhQXdii0K5PmHLj/nuOD+u/ZDiH7p1yPLbwG2mCdg+jrkExOsiIKFExw
	sXiHO/TOWtUUpcd0UYdyoxHndw1NB3w=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso80a12.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760642816; x=1761247616; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4K3CmGQhxkB24mFx9E87SF9HhnIB+xHsfgBt0vqC10=;
        b=bvH2s5W5kTuu+TENRrZOIImkylCz+SZK+1AdYqoCFKf0CNe26HqLwF7gZ9eDJ5tpLe
         LByEOvw3FCRvueAhpYTtVgeiegJXPYlV5YOnQee5xvNR3C1iBYhTnqbsbTDvQMBfaoAc
         gERwvWAA6gh16liA4Dx5Z1Dlm+yEX+MOrwNmkFjG7Jamoy4jbV3jz4nrVzwNDMZnBGFu
         /Ud1MKhQQEr+bwgAaFcLjRBocY8JuaVBWR8OhBWqY0wxZf4W7JZJ3jNUruHNl+0t3Trs
         svhGp3f+TSHuSIER3HqOY38m2QBjgLvgit6RYX1cwrjxQnPozBncJfLam4jIctCtzcLw
         ugng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760642816; x=1761247616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z4K3CmGQhxkB24mFx9E87SF9HhnIB+xHsfgBt0vqC10=;
        b=M2wZysXaQfyB9NTXd6ne5VmJBF/WhpbZiZk+78+M+hqj0dK2l4uRj2xJFUy56Uy1+W
         gcDT0i9X3cdvQZj3YW8+yzphFNCeG1sV28GjIJ7G1rSaZObavr3HoRde+1xdsFiQeGy8
         /LXpOKrqNo6TmwrIbygHyz9LNzXhD7XjjleKiBgOMpd7pJbsmS4pbDkcAdOAYCxfa38f
         jUKmeV2RjSU/7aIlsG/fFuWRWej63yMTGu7ggSlUim16vrBvyXlDTGIYtvSGouqeVSNm
         kuheFKFnsAILgn40KLpykCRgiCvSWhrdT4l3S9W3pe4zTzolJLhhR1xB2XuqKW3zi51t
         g0pw==
X-Forwarded-Encrypted: i=1; AJvYcCVhRzCEQevarK2coO7ui7eWLrY3FV85BUYI+Rqy06Y0qi9um52epDPEUapHPHlQZcvZc7J9MlQGmQ==@kvack.org
X-Gm-Message-State: AOJu0Yyc3HFCsUjOQWLE1qgtzCff/AXAzl/Sz9NPMm31gPIzIr9oDGaq
	Av935HpM720+KinMiA7hl0q4cTKG/tJtGTbLx7mlv/GYvzH7CjaZeV6p1e9G9v8+UhUyhM8L3jg
	F4HpXWzcrr9zDG6e3Kz64fbPB/qgzzyRlsAZbIoSUDMJ3L7jmX+SdEvr4
X-Gm-Gg: ASbGnctvNgu5qb5oBZzVIv8jdPyvkaJHt9cTWpo/FqfjCE9iHYd8OOzENpvtQZ5x3qT
	F14px6mpYCwaq6Q53wICw1FsFZZ3B9llru9/iMfmZ1RWJqjm6fdszy40DTuMzHLIZOAYrYklgkS
	TvLxA2gaLGAXehnemppF860CoIiqCmjsxZG2/gqESuIFhhjc7jHMtgCdY7O+V4IW+YjHOfpN3sn
	rnJQ6rzSID6kf+0stVLprFRDnjXLeN0UCcf4JBM/y15jvV4H4m0rlH787Vyzdfz5OiH99mSFyw4
	giA1AJHPjH7O2V8LHCOQirVD1A==
X-Google-Smtp-Source: AGHT+IFSkPBYjPqAaxyKpCKp2eJnQr5HaNLRzD2pbX8r+A+QqRs0jInVBDCbCWKpORR4+60IktmUfG1H/6ZHo6Vavxw=
X-Received: by 2002:a05:6402:1641:b0:624:45d0:4b33 with SMTP id
 4fb4d7f45d1cf-63bee07947dmr244804a12.7.1760642816180; Thu, 16 Oct 2025
 12:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de> <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com> <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <e4277c1a-c8d4-429d-b455-8daa9f4bbd14@redhat.com>
In-Reply-To: <e4277c1a-c8d4-429d-b455-8daa9f4bbd14@redhat.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 16 Oct 2025 21:26:19 +0200
X-Gm-Features: AS18NWDujHmIcngg16PpQMwwg8oF-_NIKvOm0btkYEtdspLHhr2gR_-TbMZsznU
Message-ID: <CAG48ez0yz2DauOuJy=-CcpQpqReWhYH1dpW3QGHPSHQ1VbAf3g@mail.gmail.com>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: David Hildenbrand <david@redhat.com>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"trix@redhat.com" <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>, 
	"nathan@kernel.org" <nathan@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "osalvador@suse.de" <osalvador@suse.de>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2037EC0009
X-Stat-Signature: gndk1jhiwmxj5zmeruj8x4yfumnrid9z
X-Rspam-User: 
X-HE-Tag: 1760642817-359086
X-HE-Meta: U2FsdGVkX19VUD8AMpY3KBvPLLX5/pP3LSiAcKwVxh15BJaPeZOB8bmUGQu1X3/m6VxBSlhZOIcLcs8oD+9Va8VlLH4sYh47BUypQ9/FXcaMKbl4a8QBv8SAOCknpm6S5+r6zBHblPk/U+kSBpO8IaoO/XsteiOPqZeuZRqfgcHEaWaJC/o5K1IdrlXRR/5QSx1EQ7q9YvL/ft6EqH7Jb05dy/aBybqndi2RfRO1lxHSeke/2UspEJr6/RnIf2KNqmByAnSsLJN5HtkRHlfaZJ0oCosqsri0TecHn88grrpj1b6Y8Tirb7ySXXfLraIQ3q9ITvgcSRsAGGHrGrRxP56Bw6ogzeLfUaK3RZPOusaSO96c0R4nqiaMpEv/weZ7a3DC4O2DyVysJMT8n+b1rByVPnoCumVCfuoZO7Bgfw4LCQf3+VmqHQKe3QPctqWse6yzyf7/0V6CO7BnHXVzkPPGGnPl/SJ2VMZQnLnNqlX1RWYOhMj8pm3oREs6AfjZaCdxy+ydcAzoP6GSb2IgZHR7DkvWNBQlkQ/9Shba1KiXl31c76kA3wBnH/Nk0Jz0flGPtOhdny/frR+enOKykO9PEbY3IiLFn/WCtbmc1LCxUg82IK2/XyNwQbZ4n2tHCnLNJDZnOkN7ZGB7BQETOJYYw512taDhvXKFp2y6fhGGAYU1HQaJ8oUA5vtwuVg3TIxqCGSImGVTMaErmwXwSmUCz8fJ/lHcqohtcXHc1SMFUY01+9I3NXd3FjHOlbkBfqwAfgRXmX39dWsFh+aekSXNo+GzkJSvdPrTKdDy+JCqZj6GunbRVcjqyj+V1s99ZS3RSDUClShsdQ9YCQLu1NjEdVrgj+7BkvTZY3yzBlZPJ7RNcPurgt1So/195m0umpadPA8cv21zmxPbl/8H1w3YfhOumCAjDuixLgpD8PYIsFpV3MgxttYfI8g94exV6h/29+MRkcQiwPwBPE3
 uuxNd57c
 VnH4KoV9nypWkP8mUxKt/cn5WqzuWgbyd3UCT823703ot4wTVy+IpH+sdh/d6mr/maruMEIymnbvyI33kf3o6mscQqNnOPvULU2PRjVKPLyH3EMynpgN9oXbwx/hvDqklvyD5uzWSZzUPNLC6C4kdfBwvJpTrujLI23bggWyDUQzMX0r4nFOWxSTla0mdtrIQXdbasnDucYwsF/FhsbtRyJM9K4PJ8zfDM+RaAXabQ9NInsPzVJKvu3yIlNE30TAn+106Omky1/4PVrpP91Q1Zdh+UcMp8dM+osfvBQ4lskMVJ5YgQBmGflKRtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 9:10=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> >> I'm currently looking at the fix and what sticks out is "Fix it with a=
n
> >> explicit broadcast IPI through tlb_remove_table_sync_one()".
> >>
> >> (I don't understand how the page table can be used for "normal,
> >> non-hugetlb". I could only see how it is used for the remaining user f=
or
> >> hugetlb stuff, but that's different question)
> >
> > If I remember correctly:
> > When a hugetlb shared page table drops to refcount 1, it turns into a
> > normal page table. If you then afterwards split the hugetlb VMA, unmap
> > one half of it, and place a new unrelated VMA in its place, the same
> > page table will be reused for PTEs of this new unrelated VMA.
>
> That makes sense.
>
> >
> > So the scenario would be:
> >
> > 1. Initially, we have a hugetlb shared page table covering 1G of
> > address space which maps hugetlb 2M pages, which is used by two
> > hugetlb VMAs in different processes (processes P1 and P2).
> > 2. A thread in P2 begins a gup_fast() walk in the hugetlb region, and
> > walks down through the PUD entry that points to the shared page table,
> > then when it reaches the loop in gup_fast_pmd_range() gets interrupted
> > for a while by an NMI or preempted by the hypervisor or something.
> > 3. P2 removes its VMA, and the hugetlb shared page table effectively
> > becomes a normal page table in P1.
> > 4. Then P1 splits the hugetlb VMA in the middle (at a 2M boundary),
> > leaving two VMAs VMA1 and VMA2.
> > 5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, for
> > example an anonymous private VMA.
> > 6. P1 populates VMA3 with page table entries.
> > 7. The gup_fast() walk in P2 continues, and gup_fast_pmd_range() now
> > uses the new PMD/PTE entries created for VMA3.
>
> Yeah, sounds possible. And nasty.
>
> >
> >> How does the fix work when an architecture does not issue IPIs for TLB
> >> shootdown? To handle gup-fast on these architectures, we use RCU.
> >
> > gup-fast disables interrupts, which synchronizes against both RCU and I=
PI.
>
> Right, but RCU is only used for prevent walking a page table that has
> been freed+reused in the meantime (prevent us from de-referencing
> garbage entries).
>
> It does not prevent walking the now-unshared page table that has been
> modified by the other process.

Hm, I'm a bit lost... which page table walk implementation are you
worried about that accesses page tables purely with RCU? I believe all
page table walks should be happening either with interrupts off (in
gup_fast()) or under the protection of higher-level locks; in
particular, hugetlb page walks take an extra hugetlb specific lock
(for hugetlb VMAs that are eligible for page table sharing, that is
the rw_sema in hugetlb_vma_lock).

Regarding gup_fast():

In the case where CONFIG_MMU_GATHER_RCU_TABLE_FREE is defined, the fix
commit 1013af4f585f uses a synchronous IPI with
tlb_remove_table_sync_one() to wait for any concurrent GUP-fast
software page table walks, and some time after the call to
huge_pmd_unshare() we will do a TLB flush that synchronizes against
hardware page table walks.

In the case where CONFIG_MMU_GATHER_RCU_TABLE_FREE is not defined, I
believe the expectation is that the TLB flush implicitly does an IPI
which synchronizes against both software and hardware page table
walks.

