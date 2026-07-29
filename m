Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7280C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96F086B0088; Wed, 29 Jul 2026 12:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7F46B00B4; Wed, 29 Jul 2026 12:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799276B00B6; Wed, 29 Jul 2026 12:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4112C6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:54:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C354A12063D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:54:36 +0000 (UTC)
X-FDA: 85042412952.09.2F0E95A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7526B1C0007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:54:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W3c6IxzF;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785344074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+t4lhvwjBq6az5KPqLj/WCEK05KayNnLzuXWhOCiv40=;
	b=cLhTRunT5gFMSjTe7oI8KkLN7o60LXPK2N2onDB54ZUCmKKJZBrzX/cnYiUfZ8J7+PWZ9g
	2D05AO72sWrjuALDLtQKgMFRY4ns/KQMg3t10KxnxjShDd9LxIo/jjQeMly9gWOvpEPeJv
	duIpM3p3O6L0jl8pxTsRacnutAwoOEI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785344074;
	b=qZX01fPzqn79pkqo/XcWxDT4VwvKao48awAnM31NHeObCxea808NXT4l9EUUaUIE9uYwCy
	XXdoUJRhUXSngK/XJe3iKpScqh26nmZ+n/Bn6hQFvD3tan6IicpGiDcMJgee+dqWURKZLd
	corq0D20oeMyVdGA/mx+tDMEILjiTLM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W3c6IxzF;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785344073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+t4lhvwjBq6az5KPqLj/WCEK05KayNnLzuXWhOCiv40=;
	b=W3c6IxzFdqnLRh1JcOHDsDglDNxhtFUozzGyr8Q7dWLHkfcM/XH2kL2e+nx45RGUf+57vq
	QblsqDeksUtWFHJwfIh7IPURaKnkIpfrh86h+34UxJpHLREK30I92fwBjqLzIvgYZk4VVz
	y9jDHVtEErAVQUZMg+5B7ZEN2Ev2/vo=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-1b221kabPmKk5K5b_dp8Tw-1; Wed, 29 Jul 2026 12:54:32 -0400
X-MC-Unique: 1b221kabPmKk5K5b_dp8Tw-1
X-Mimecast-MFC-AGG-ID: 1b221kabPmKk5K5b_dp8Tw_1785344071
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-39b1e6524e9so6623401fa.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785344071; x=1785948871;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+t4lhvwjBq6az5KPqLj/WCEK05KayNnLzuXWhOCiv40=;
        b=B+EmJK0KeVO5febB9jWwmZZ5Ul626VhhNHCYxOkBfEn7QaQ2pVSgxFtwfOuw91SNxM
         UwFhDzvqfvCdmapE2q/76BEnyXf5G6da5GSqwirMhmi7QRcanafVqY2JdGzsbeYCGsvO
         KkYCUAnddP4Cv7hERA0U/3etwv5I2j8i/3tpuSCyxMs8miXDzJqeqCvAocgYaZ+xpzK7
         i6CVW1tQszsTJRWtdCgANY3+roFVoedLojlWA7cgt4W0pi4nmBKlw5ozW0uLlSq4hmch
         SCM0S6q9u4WRj7DHSyHoZSgf7OqJHsOUdae09JBeia3sVGR2lqcpxPl93VV0IhI7Lb6t
         8qNg==
X-Forwarded-Encrypted: i=1; AHgh+Ro8m2Q9N2IGAfL2LSnWF92OZ4cYFzuURoVcvPnsoJ4ogmpanP76tDBbXUmy2YH3HPVqX7GC7HVE6Q==@kvack.org
X-Gm-Message-State: AOJu0Yws7moY7KsHaMWa1T5C7lsfVy9XYizGGZ/hSwq95yBmDDZbwLof
	w5KGr202k02QF3ej+9+sGWsZj1/zT6c9x8UtIYwRKGtHYdP2NjEa++NJP3RwhpKNy8N+wjGSEuF
	Gvf8GrYdE3HIIaf/5Dg1lEqIqR6TQ/K24YUHrQt7Lq1oaGlSRvMCcDtKwMcjWpEyTnpFN+n2fHI
	UMA7jgdj+4632vvizY/4P0vqKfOd4=
X-Gm-Gg: AR+sD11SnDApSCGL9B9ju9DgGEaw3xVjydia+x0A35LDk9pOqhnF4yRo+m4gy1VJgS4
	CpFV2OBMhqknZJsYnySWy7eObkXZF6nsjqQYhf0Zpsjf8T6IMaCL3X48x1ny4U4YKLJ838PMey3
	BTvP/VmyjNcc9aitDK6BAbmazUTJFZS6GK+kmymAqU4qluNtfJae4R+HFDsw==
X-Received: by 2002:a05:651c:a336:b0:396:9630:5ed with SMTP id 38308e7fff4ca-39f51d06dddmr14157861fa.15.1785344070654;
        Wed, 29 Jul 2026 09:54:30 -0700 (PDT)
X-Received: by 2002:a05:651c:a336:b0:396:9630:5ed with SMTP id
 38308e7fff4ca-39f51d06dddmr14157711fa.15.1785344070234; Wed, 29 Jul 2026
 09:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
 <20260609172719.803537-1-usama.arif@linux.dev> <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
 <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org> <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
 <0b268070-95d2-45bd-aea3-56cefe01dc8c@kernel.org>
In-Reply-To: <0b268070-95d2-45bd-aea3-56cefe01dc8c@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Jul 2026 10:54:02 -0600
X-Gm-Features: AUfX_myZerMnUZuo4gs_viFrQT0M6s3IRh1IxuuyrZJkehdXyh3I5OG4bLeWRTU
Message-ID: <CAA1CXcCp0z0kw9pQtj55qNGOBJOpfDsrf1GJ+EhGZCfA+dhbKQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>, ljs@kernel.org, 
	xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, yuzhao@google.com, aarcange@redhat.com, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TQKOB7_tAycqiHeLtTf4wGq7KIZxwSzgQXOYz79HTLc_1785344071
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7526B1C0007
X-Stat-Signature: rktx34wo31bf8dhhq3iwtoqk5isryshx
X-Rspam-User: 
X-HE-Tag: 1785344074-318607
X-HE-Meta: U2FsdGVkX1+tyIe2m58ySESp7iMqG4/fEgy+7eIgDp9bpXX5X4pQ45dEWqDArYL4nuVMHcxaII0dXq451AADYbMNqz6JYMymL/o/KdYmoKwrhvbTmjoo9aXvRX3l+RDbIZZRsO6Wvn7y9CKZJCZvFsHfoHo2aL0zAJgvL6VyJf2gS1uPvEKA9gjQyOALkFlPVy3Yl8aHe7rKltpnY7om/0jXxtnoZjft5rjTiVWPJPcTpNoN40LJaB9uPMhHiXkdTtqn/IovgMiWmuS2N0TOEolmc010Udds8eFNVa8pk4qetSCM/JC+D02DwGGsN5FI8Qt222NomytpUlMVzCsi0NyE/pAzG5pDqAd561BYi5nfyr7kW7ZxeD3JChHFS2Doiv4RevnWAE92NLJnIVDwAx+zYN7inBh30jmrB/952krbxSwTyOEDy/iol2raZL4gKKNM2Yp8siFEyFlDCGoodkFhH/mZiUU+HdISOJTOIlWlUDDDSaMq6utZvRel8agfSO323SBMzLyd792XMd92wUokC3Jnt+uQELofp3YIL5ieBAlfiu0sXt/TBv41I8dkH730Xgch9MgfsZAWiy7SeK1Sjf9NnCkuUFV6SN98qS7ghsvs4e4zzfjoPQw5GXLh152jIFRQVsEOb3vS/PG6UeI9DU/NFi8syF8bMdN0y/GBcHH/30Kpe3DmYL1pL3ZKgK+mnGP3EaN394DpbcVRPF+virp8Z4NAP2dCaEp1/1bufWEvB6UJ0SBnEBvVlempOXJhfOIMbzLqFnfsDnO04uDZIv7FgO+eCGsuaWS44K1DCB9Veq+s8ZugGPqnT2W5y999mjhhbg2u39KF0nYD5/N7XdDrkn4dgYScMlNNRjeky62PB8Pn8Jh0EP4MRIXvsvKpBXruGtUQ7aG4SRg/k+RddVeIblA38ChU8JaN8ytvCSvgavrwSPEaioyD8RbUNLpfdW1HmmFAHXBVrJb
 5GOD0ggX
 wIEUCYbtNHgdqAROjqF651f2cXvMz2PZHzij/vC8+ERsBvjKr0iBchcS4I1lgVpGLs3oB9dnQafV/qxE6GvOe2d44U+ueByWg2FkAvq2tpIApcrNDvlDOcZwl/WtYQeYk7fU4RvvoQ8RBf2TFrag5fqKjWJbOPh78iYjP1aeR4NRxKI5hSrifkvP4D46RGz8CNvvvmvXaJ1wpJ0ORiGLGGLnQCtyuZRSqzDl2skLMdqy92OGZ8Gwo6/l9lODGKYo8Sox4wpLmzCcqxLAI6jJ3NIDA9AX/aFBV81chChVoXKscoP5Ibo9NaXXXJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 8:02=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/20/26 17:28, Nico Pache wrote:
> > On Wed, Jul 15, 2026 at 3:30=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 7/15/26 06:05, Nico Pache wrote:
> >>>
> >>> This would be a good intermediate solution while allowing backward
> >>> compatibility.
> >>
> >> And an absolute horrible user-visible toggle :)
> >>
> >>>
> >>>
> >>> Hmm interesting. We should decide on future changes before committing
> >>> to one direction; however, i think the immediate solution would be
> >>> what I currently have prepped for v2.
> >>>
> >>> My v2 follows my RFC alternative approach: skip zeropage remapping if
> >>> the split comes from KSM. It also contains the patch (3) from this
> >>> version, which skips zeropage remapping if the shrinker is disabled.
> >>>
> >>>
> >>> This is indeed a good question but I don't know the right solution.
> >>>
> >>> Perhaps we can discuss it here.
> >>>
> >>> So far here are the potential solutions:
> >>> a) skip zeropage remapping if the split comes from KSM
> >>> b) skip zeropage remapping completely if the shrinker is disabled
> >>> c) Disable KSM THP splitting completely
> >>> d) add a skip_huge_page sysfs toggle
> >>> e) only scan THPs when memory pressure is present
> >>>
> >>> (a)+(b) would be my V2 which I can send out whenever.
> >>>
> >>> (c) is the nuclear option, but perhaps KSM for THP is rather
> >>> inefficient and pointless
> >>>
> >>> (d) could be used with (a) and (b) and allows more flexibility than (=
c)
> >>>
> >>> (e) is a more dynamic approach, and could be combined with (b) and (d=
)
> >>>
> >>> Let me know what you think :)
> >>
> >> Where does the current patch set fall into and what's the problem with=
 it?
> >
> > this series (v1) would be "dont scan VM_MERGEABLE entries when KSM is r=
unning"
> >
> > It stops all VM_MEREABLE entries from being candidates, while the V2 I
> > would like to propose goes back to my RFC's alternative solution
> > a ) "skip zeropage remapping if the split comes from KSM"
> >
> > I think (a) is better than V1 as it doesnt indiscriminately target all
> > VM_MERGEABLE mapping but rather those that are triggering the issue
> > (the split).
>
> Not sure. There could be anything else in the system triggering the split=
 before
> KSM comes around.
>
> So v1 just cleanly separates them, independent who triggers the split.

Yes but now all VM_MERGEABLEs lose the underutilized shrinker
independent from weather KSM was the one who triggered it. So if you
split a folio from another path, and its VM_MERGEABLE we lose the
ability to reclaim these underutilized pages, despite not being from
KSM (where the behavior/"bug" lives).

>
> Why is this a problem?

its not a problem, but it now affects a larger scope than where the
problem originates. We could easily shrink the scope to only include
splits coming from KSM; then KSM would respect its sysctls, while not
regressing the shrinker's functionality on VM_MERGEABLE mappings.

Perhaps I'm not properly expressing the differences, or I'm not fully
understanding your concern with my V2 proposed solution.

Cheers,
-- Nico

>
> --
> Cheers,
>
> David
>


