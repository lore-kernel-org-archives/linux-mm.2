Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896FECD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC116B00A4; Tue,  9 Jun 2026 05:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2D26B00A5; Tue,  9 Jun 2026 05:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1C16B00A6; Tue,  9 Jun 2026 05:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93496B00A4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:31:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 354061404B4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:31:45 +0000 (UTC)
X-FDA: 84859856970.06.D67F848
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id A158B2000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:31:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hAyAPAPW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780997503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iTl0SUAAjGLBMgcBlGMkkP/SoLVtYGQlCb7tbJPhgM=;
	b=onVE86hF79qrva+DeVJ3/h3CWSGUte0LI5gOu8QnGM9j10ClfewPWcZHoKL0IJl91hUuWU
	kXe2sciDQUjJlfU7bUKymYNJ15s/2XGqSvUcV4ih9dDA4O5xeZVqh5bkTvnIr+k+KU7M7D
	e5BqbdzH4OtPo6sYrOmEQYiDfySXrFk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hAyAPAPW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780997503;
	b=lsk4cvYf1LHEo4uuarUmETaETEgqFUXcrkQTI7AjENWIsyNd1sodkj/XP0uoZZ18KWCuFD
	3RinUdji5fXNBJp8mB7aGCTSFXm2UN0mXXPaFHjO3IWm4gvxfxt7HHSMndifmG11acrPxr
	FT9ORdQxHQJCf+kzgNuZIqK1rW5uTEU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780997502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2iTl0SUAAjGLBMgcBlGMkkP/SoLVtYGQlCb7tbJPhgM=;
	b=hAyAPAPWcPnRb2uw5VhLjRupr5xEBbGkzWiodyZS//OTtmL9hJQtSz+s3i4ZklkG5PTO2o
	gzeHvlUrmnCqPrHBhCca+xtZm+NnaNpjMb194lH1HMAaZ/GbG+rgk7Ug/SQ6JUQ0kdG7G2
	HXAPQj4Oyw21GRz4uQByH/M6JjTjN1k=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-JUiSxoRwPbqfrNOldqQW7w-1; Tue, 09 Jun 2026 05:31:41 -0400
X-MC-Unique: JUiSxoRwPbqfrNOldqQW7w-1
X-Mimecast-MFC-AGG-ID: JUiSxoRwPbqfrNOldqQW7w_1780997500
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7e11b8111a3so90189847b3.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 02:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780997500; x=1781602300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2iTl0SUAAjGLBMgcBlGMkkP/SoLVtYGQlCb7tbJPhgM=;
        b=We6nJ3t3Jij6lNA+zygq8dgvO9hByaaFSwOTj63yAyT1B5aB9594prqijxOzDpv+HM
         xfnRCLLmQA9sGFNV0t3Qt4LBDih2VXio7ogui4hzMdKVEXv2vi2oejOCPX9tiWHEdDLN
         8Hnj7hOchHF7fXEhTeScefzMDggQKRvQNJFZLkGhOV25c3klfqeYkGPmtzrO9NZkUyPp
         psOZneC9ZgvID5GoXxci6I1Qq77ABCzmlT5BB1d9MO9IzEfNhF5R6Sfc/nO7z1GZ3PDr
         DbUZ8xU+GskebZ8QpfIJzKnKQx6X7RzdnbE8CmiS+LwWx6r6LXOO8v6IvgnLW8KsyO53
         HFWg==
X-Forwarded-Encrypted: i=1; AFNElJ/Qum8t7GBtG/8h86SSdNZWz4Gm/UT5kSAFiEplXIJBV8uuG/D7HaOUS3UP8xdNZjwdg6v/QVAkkg==@kvack.org
X-Gm-Message-State: AOJu0YyQBw9jJtkeQm6XuHhpt2QPpepw0l3yxuQZEOFTdYoSNkpAwwym
	ln8PUhYyHU98l/tHuMi/FWaJH4gpEzmuuGvzyfLA4soTw5JghM/VsOVvmxraJkA9SCj65JqFcqV
	lK8zBktCsvv6zgpGLD4LeXenXZFc5Zm0GByway7FW/dPhlFWUzMx7vDOZd3T+lDtYt1/nVZMesK
	2hijNS3eWxj6Q0N+aZQaiZoxnEqYg=
X-Gm-Gg: Acq92OF5XCRk3Ywk+vpgyxUZbzalLlF92WzEO9FtgOTaw1gBVYgI84yakYz8AgZUY1M
	0Iex68+qlc7tZSoHdNv8Y3fkGZNaTSmtMYTokAxZoz9qyrDBNNPf6SbyrwXQMIjVyCsmneoLYzB
	PjGe35DsJU+0IM3mhR/NfAtXhgiBA3DNFatRFNLQENOmia2e4DKjr+EHesFE+z3ICtWpcfPo+I6
	O6xzxZDvA2VBob+
X-Received: by 2002:a05:690e:4395:b0:660:6f06:ae6e with SMTP id 956f58d0204a3-661070ce78amr11702523d50.64.1780997500239;
        Tue, 09 Jun 2026 02:31:40 -0700 (PDT)
X-Received: by 2002:a05:690e:4395:b0:660:6f06:ae6e with SMTP id
 956f58d0204a3-661070ce78amr11702475d50.64.1780997499604; Tue, 09 Jun 2026
 02:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260605161422.213817-12-npache@redhat.com> <20260606102800.26940-1-lance.yang@linux.dev>
 <2553caae-9e0e-42a7-8b61-d1216f1e81fa@kernel.org> <CAA1CXcBY_2372eJru8VoCq90rUMxn7w23hHou68MmXRv48NRXg@mail.gmail.com>
 <b7fb4184-7a99-42c7-8ee2-4c7fa20827c4@kernel.org>
In-Reply-To: <b7fb4184-7a99-42c7-8ee2-4c7fa20827c4@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 9 Jun 2026 03:32:26 -0600
X-Gm-Features: AVVi8Cfncpxkxzck5Whc94MJ57VmWeE0wGEzvVhdZp86lxoGqXC5OmGR9iRBiTY
Message-ID: <CAA1CXcAhw8V+_dYcrqmtZ9ht4Pqz5PPB8EOcDrVCp4DA4y7pLg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BgQ37YyTOSBeNUxMSgHevrSxEsQ-vL5EC09sUMuxlI4_1780997500
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cai69yrr8o7g4q7m5t197qwy1kuitb67
X-Rspamd-Queue-Id: A158B2000C
X-HE-Tag: 1780997502-416626
X-HE-Meta: U2FsdGVkX1+0azEi1DNRYrSmzDop0qYBtILYAmdlEyr94R5k2SKBY+8O2iQ3g0CJaOz7/J18mR/Ox2B2MJ/hkig9TTT40omSlm3jarrc6UNBVfkAbkjK4tRGSwI3j0eKNBmB6S+rwr9MizDhoUE77fG9GLtiaKy18D9st1mX4i9nG4o5oHfeBTlf4KFIIPuh/kkTmjjq0OReZ8VIdHRdMR7TUcGvTleTuPPauZC2gQWv3Iryl0fbJGxVUqMppwonMNvAx+Wl41MM0W/ynjeKfHqEce1Ue00dhi9ux0GjlxFURERI4lgFDZH/i0EYFQPKJY53DW+jU2ox3zbvRwJT+2qXgnjBA/VvZV8Vhbu4/Y9cdoJFtrTawlMHV5TsDUCHVXuzDwd0umKEDxeQoZIC3ZInTV0qYV/TluHRn8kSGEl6A4GKGSvaTPhaTSdVpPaCzzG0xEtN/U1FHRQhkj8znzuawnByQ99rrgdp0Y2n2EdACQp5sWxUP6qg8WUqVJbVqNQlVZp2GKOtBMs8OCK2aVLrX2Yq8MZgtTJBENve1yMbHURVYFJdQ6HChMSMNu2ndStT63E36u2gS/UpGq/msITeBWwDvMf7jzyiJL35XhFlf+fojAkLmOI+gHwkEAv27SG+ojMTmB5+N/C25kcz8GnDmpIEBp9umNLKbKhdSwiHiicPAIGIlxH7gHFAXYdVons/tcbct0mVX/sQIc2R/zcay+AnIBX0CXdaiyyjxZfoICPHOXAZ5EOGNGJSgY9GN/7kYfIWcOYWnhJBDuL5vLlCZ3I0II5LPscEtzs4JsaWRLE6WB3E0VOoSFQuEgL6KZ21hwVuTJGoOrdEWVdfHp5oFudhzogZA8U8Pbcsb6+fP/uvLx0AwM7xM19bpmO5iaxCtvsaE2HQ1DkdkMy/nfkYSW/pZNLeSC6vBaZuViCy0Rgx3Cb07K7Kkm99GuZK0jhmS6Y3r6PvZr/+X+C
 t6YUddyM
 uJg6dc2RgPNcJK1BhBROrlhY/yti3yaLdMLLH3VVuP95BnG3mpB3wYcPgoLesA4trWBIUMUXMW/Ylq49vIY9ZgMIR+Hl8wuShVr51vhKSX9C9dhrvE9zZXR9n8CPxb69iqj4dKiTSiBGjDKMQ/fjq8npZdGpafy/1u7OOIbIlPnqbahFNZBAxXpUz2GJ2jb+3EMXrYnzFak5AxdmmuJ7LGDae8tKJ6xHGk4B5BiUvoDMd4wlLgT30rosUGwNsFj1OhFx8GhpVA4Wbs+oo8rVZzwlMbGsUMicFWnuOnB0P9eH0aGOs4EjOZnnLdCKLi3uYf2jdABfowFq2v6UR12aPBi55UFKk1heAyWKYEYqenh0Sj1n4rdbWYhTjEpXj9a6fxnkgoKNlyAMZpmxetuQZscxuPGt47GG4AtxCAVNfS0FMJROXfCHhuEZiPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 3:26=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 6/9/26 11:06, Nico Pache wrote:
> > On Mon, Jun 8, 2026 at 8:57=E2=80=AFAM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 6/6/26 12:28, Lance Yang wrote:
> >>>
> >>>
> >>> Looks broken for swap PTEs in PMD collapse ...
> >>>
> >>> collapse_scan_pmd() allows them up to max_ptes_swap and record them i=
n
> >>> unmapped, but they don't get a bit in mthp_present_ptes. And then
> >>> mthp_collapse() does the check above:
> >>
> >> Right. I assumed this is implicitly handled by the optimization in col=
lapse_scan_pmd:
> >>
> >>         if (enabled_orders !=3D BIT(HPAGE_PMD_ORDER))
> >>                 max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT;
> >>
> >> But we perform the check a second time.
> >>
> >>>
> >>> nr_occupied_ptes >=3D nr_ptes - max_ptes_none
> >>>
> >>> So max_ptes_none=3D0 + 511 present PTEs + one allowed swap PTE won't =
even
> >>> call collapse_huge_page() for PMD order.
> >>>
> >>> Shouldn't we account for them in the PMD-order check? Something like:
> >>>
> >>> if (is_pmd_order(order))
> >>>       nr_occupied_ptes +=3D unmapped;
> >
> > This solution seems good for a temporary fixup. but longterm we may
> > want something else. I'm still not sure how we plan on supporting
> > swapin without causing creep. So I'd be ok with adding a fix for
> > legacy PMD behavior until we know how to handle mTHP creep correctly.
> >
> >> As an alternative, we could either 1) skip the check there for
> >> pmd order (as the check was already done); or 2) introduce+maintain
> >> a bitmap that tracks non-present PTEs.
> >>
> >> @@ -1475,7 +1477,9 @@ static enum scan_result mthp_collapse(struct mm_=
struct *mm,
> >>                 nr_occupied_ptes =3D bitmap_weight_from(cc->mthp_prese=
nt_ptes, offset,
> >>                                                       offset + nr_ptes=
);
> >>
> >> -               if (nr_occupied_ptes >=3D nr_ptes - max_ptes_none) {
> >> +               /* Check was already done in the caller. */
> >> +               if (is_pmd_order(order) ||
> >> +                   nr_occupied_ptes >=3D nr_ptes - max_ptes_none) {
> >>                         enum scan_result ret;
> >>
> >>                         collapse_address =3D address + offset * PAGE_S=
IZE;
> >>
> >> 2) would probably be cleanest long-term.
> >
> > That would be best for future swapin support in mTHP, but I still
> > don't think it solves the creep issue.
>
> It wouldn't, we'd simply maintain the state we collect + rely on in separ=
ate
> bitmaps. On swapin, we'd have to update/refresh bitmaps I guess.

Yeah, I'm saying for the future, it obviously solves this issue here
as well, but if we have positional tracking of the swapout, shared,
and none PTEs, I think we can use this to determine whether the
collapse would lead to creep. If we detect creep would happen it may
be best to automatically collapse to the N+1 (or greater) candidate.
Just thinking outloud here.

>
> > Perhaps we could combine the
> > two bitmaps to determine if it would make the future collapse eligible
> > again? Not sure but ill start thinking about it.
> >
> > Should I send a fixup for this using Lance's solution? Or does Lance
> > want to send a patch out with the fixes tag?
>
> If Lance could send a fixup, explaining the situation, that would be nice=
.

OK, I'd appreciate that :)

Cheers,
-- Nico

>
> --
> Cheers,
>
> David
>


