Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F01CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB9A8E002C; Wed,  8 Oct 2025 12:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3228E0002; Wed,  8 Oct 2025 12:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4920D8E002C; Wed,  8 Oct 2025 12:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE078E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:08:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8636140667
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:08:16 +0000 (UTC)
X-FDA: 83975428992.23.AC50EF3
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id E59B1A0007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:08:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NzcgO1qL;
	spf=pass (imf25.hostedemail.com: domain of fvdl@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759939694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xx00fhwWNUyltYc8OJeL1zGs0cm20MUZAIdsCByVV9g=;
	b=lL05Ph8KJR212XKfUUECGny9N8tKcJ/5izFu0z8VJuX4tyQWafq9WT65V2NbglrWmYbxjW
	oxa8JxHysjIrO0xmQCLYlHchO0ANKIUvE49x+sMvw5nbuxaHilx5A8KYKYNu5PIdX+xgTS
	j0kJ4TqEcBz98xqPFMeaKHNE+T3nAUY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NzcgO1qL;
	spf=pass (imf25.hostedemail.com: domain of fvdl@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759939694; a=rsa-sha256;
	cv=none;
	b=6AL5w8T6R0y0Bx5iBussk8REzKZ9Q486zSylbqWimqQRLJollF9z7VXp8y5ubPDuJICPqp
	PBQ3v1I2SSLYMFUQCFQNCLfhBEaOT5qpeIptDTu7qjMa9dosoLzMYKeO38x4BQPDXDtQXV
	AZZ3URjljp+mVakl/G5penoRfspfcrM=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4df3fabe9c2so424751cf.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759939694; x=1760544494; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xx00fhwWNUyltYc8OJeL1zGs0cm20MUZAIdsCByVV9g=;
        b=NzcgO1qLSZ4R9IThFnlz186SrihHcR5Xf2GNpFSPFad+xlVh+G261ITUspPIy5FwWL
         RVuxBTtlv8N+1NTT7f/hlPr8uiJAho8JXZu4+kLDlAGoKHlj5pwetDd1jslRb/N8AgWT
         zNc+UGI2augis5BTUbXTV5dCAYfPCOF/D8arCrpwFvIy90WHd8NCuSuXWuQjB0qQX5bg
         Yn3oMYV8pUD812VV+dcbfUpnJe9GnxIZJessmdRSjEKr2ihZ5rxue2+1XRUC63iw1X4Y
         sEf0v9BakB4MAwYWqB7Lw1rUmEwNlzjabaA9hgXEU4zv8rjz0yEqK5q6YWGbuYeNNjHD
         7WcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759939694; x=1760544494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xx00fhwWNUyltYc8OJeL1zGs0cm20MUZAIdsCByVV9g=;
        b=T719jy2ru1W+KtRl9eGiVKYLfFvlgKZ6pLOxhNUdu+c+wUC+lD0NKIASFLMb5qqt+M
         xsq7b1Jqk5BDr557OPOq2CZ/1dRe4ZuE5rzAggtWl+84Uw1swV9dEcDRwqX5p79+qMVd
         pa+vTjASATAL39YN223oQSNbpWtophkBauUHwJH3SjpeOapo90pAyCxxmTmR2J8fJncw
         hFAaj/YNzI9nc51IX5LhFj38oiCeUzQVhqcD7Oi6zSmQkq11Xv7CGEWWfNygJXRYk8Ha
         UDSA0AhdtUUEBdy3mCB6DrNEdHSUzn8hqzN41nyuFQT3Xlb765nqldxQOBA0/4XIdrV0
         RqQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW5T/lcOVjPAbRCYEPMNjZyd8AzphdOD80nOsvMbkW8oJ5HSOGn9YM2ErfO8UTlpw1ElUHNVSMJQ==@kvack.org
X-Gm-Message-State: AOJu0YwWnelSdzaskmRuoyrNPzv0YpTMYpfPtFkhJhxltCabZuuVs1Xl
	IfLB4L1VZo+/4l6Vf+xYaBssDM5up+SgXTIw1Tw6g6lhbx3ImBoyhdRzyu4jAnlrPJ2IHfOzrjY
	GHa2FHErZmBrggD5ndviajC4xsv8i7xwVH+kkauaE
X-Gm-Gg: ASbGncuUDrxEiaOzL9xDV2VbPy2Ezv/mw+VhqRYKieNeCEBoNUM7u6IFF1jgTOFhtwU
	VAIKnbVMcXJ691BgwEZAl/iqEkY+kurOHvJQNGig3v4a23cirV3asJZTThVP/9OKUlpk6C5Tjeg
	GYhoFZnoJ7gkC3fcplpzSO5yw0kv2LttFt/BnAAWq9TlW+D/Ok7FbwisIxmxCJBT9i/ItxX1EnB
	51DPnAaWC6BKJysL7dYbX2vAR3BTZF0v9HOm+9Ew7D7eQ==
X-Google-Smtp-Source: AGHT+IHg4hw5sOQXHJy1YTbt7WUu/bkbgzbRorviULvd8txz03043wLweps3S8qJQwjtuJ4C8ZO9kMTHYzjXrs9B5l4=
X-Received: by 2002:a05:622a:189c:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4e6eaa4fb46mr8600011cf.0.1759939693130; Wed, 08 Oct 2025
 09:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20251007214412.3832340-1-gourry@gourry.net> <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
In-Reply-To: <aOZ8PPWMchRN_t5-@tiehlicka>
From: Frank van der Linden <fvdl@google.com>
Date: Wed, 8 Oct 2025 09:08:01 -0700
X-Gm-Features: AS18NWDU62lmyrqTkj3dR1JTkOvcbXSMpXE1bJ_IYxnVWSgup_hL1VXRf4q9tR0
Message-ID: <CAPTztWaH7mJ3ACfqqYr1CFCDycw6Zm727t7wAa4n9Th22bn-yQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable sysctl"
To: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	corbet@lwn.net, muchun.song@linux.dev, osalvador@suse.de, 
	akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com, 
	brauner@kernel.org, mclapinski@google.com, joel.granados@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mel Gorman <mgorman@suse.de>, Alexandru Moise <00moses.alexander00@gmail.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cxcg68w6zw3qby3eib8iptjzrx7pcgnw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E59B1A0007
X-HE-Tag: 1759939694-974073
X-HE-Meta: U2FsdGVkX18XnFMyN59wml1t83KATLv3E9wLUAgC8YWcspqdVfq/HDrrKW6fjcTy/Ahk8sq1+Q89Jj/Levjke9Cr4NFRDKA9tulbvMXIsnHv5vm6YJ0rc8GlnekR69W2igE8SdEkpx30OTWqpRN1mBUTl/ezeMSad7d3qNH/G4Aji09xyCA74rNdcg4owGvkFsNrtGZFeDdWJJiOTA7t6ZWvzvi0rSSwRSIteLjn3gy0t9ie763mMFszv9nzXDGQo1s7rhQuIPClawtl6hwYz6Z/yka50Z2c3qh74DrqN8AJWnZ9Om/PTJ6BdEJYVqVEEVUhlVtD7WgwyHlOna0IynubUpicGXpSnebwg9DK7VhGWSZWnPhap0fcse8cVNRCXhDKNZjT8ModnaTkZ7BbC/ZjXKa0kztDTMvZz9cL6xvdp7VUcENXSYhIrPEhkppuZKIuQj/PvUN0t95IDA642YYJZ8cxV00MZvLmRBjVJiHfehNZ9PSmaPcMiGSAWfGpS/hkDDTMRA6L2iVGASNWJppJSSG8IKKiDKwXGScwVK69M7w7vyMX397t8ZWk0ciFsLbmx07EY+R3zREK/UQDYQdBojHntlQnuMc8MUhzaTbuXqdrRlsXNeIJ9UQZ2B+tTzST7nVfvRicsx8i87EPsKL8IUwelngBMaRDwgaJSfgVPzFHHI01OMQWFhmSzoiwmlD8dFEJloE9fCd1L9DaqHyNI+jsLtBvW2N2bbIXYxtx2Sjs/0OzHkjBOl1MVXFuazImg5i8ngGir54h0SnBPhWDH1ZUrBAQIT3h+c3nGCus4zdypzS7yMxkMrfggN3UHeW1NbywqbE3Ym8e04xriSgwiq0CIHetwS5i7NbQAduDquRJIznHQg+Ox0Kd3vbCr1lOtXmT8z9R0qdvJJxsb62WPjNLdACc+yAFxSCch8mb/KQCjT2uTVFGDndtkupQECWxPWkQoyTAXnR+QB9
 42xZg1Nk
 m0EXoj4Uw77n/EwdU2Q/S2loefiW1Bk/uibS86R3/gVRMptTaCGlXPuwRiHL0euENZIDeLXqoZ+oxMkD1Mx3DpFDK7rIFvUq0SYbFJKjJCl7cU0ELSILFPxtJ9cQWpDyib848Y61EzL7ljr/9BESXf0HYvaPdUWASufQGsYilomslW6esq1RU/LQQxn8KaxYwfVBEKhAST+JDGfuYQF4OSoA3uKsXPcz5KK+Slkf+U38xvpdQeqGRBZKTV1AnCet0pom9iEurEFOP3QGWjpxgnC2YG+PzxhwtfmAZ+HPafrRQpnsfKr1WX+e5nnSocHoUtIEv0HgDbCnus2nQB4Dxo7EdJMnDIhrGIpsHNowAg4ZgyUqOZ6NEdaKWog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 7:59=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Wed 08-10-25 10:58:23, David Hildenbrand wrote:
> > On 07.10.25 23:44, Gregory Price wrote:
> [...]
> > > @@ -926,7 +927,8 @@ static inline gfp_t htlb_alloc_mask(struct hstate=
 *h)
> > >   {
> > >     gfp_t gfp =3D __GFP_COMP | __GFP_NOWARN;
> > > -   gfp |=3D hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : G=
FP_HIGHUSER;
> > > +   gfp |=3D (hugepage_movable_supported(h) || hugepages_treat_as_mov=
able) ?
> > > +          GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> >
> > I mean, this is as ugly as it gets.
> >
> > Can't we just let that old approach RIP where it belongs? :)
> >
> > If something unmovable, it does not belong on ZONE_MOVABLE, as simple a=
s that.
>
> yes, I do agree. This is just muddying the semantic of the zone.
>
> Maybe what we really want is to have a configurable zone rather than a
> very specific consumer of it instead. What do I mean by that? We clearly
> have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
> zones. So rather than having a MOVABLE zone we can have a single zone
> $FOO_NAME zone with configurable attributes - like allocation
> constrains (kernel, user, movable, etc). Now that we can overlap zones
> this should allow for quite a lot flexibility. Implementation wise this
> would require some tricks as we have 2 zone types for potentially 3
> different major usecases (kernel allocations, userspace reserved ranges
> without movability and movable allocations). I haven't thought this
> through completely and mostly throwing this as an idea (maybe won't
> work). Does that make sense?
> --
> Michal Hocko
> SUSE Labs
>

Right, it's all about what the intended goal is. There are two
different goals here. If the goal is hotremove, then no, you don't
want anything in ZONE_MOVABLE that is not migratable. But if the goal
is to have normal allocations always be migratable so that you can get
'gigantic' hugepages, then it is fine to have those gigantic hugepages
not be migratable. They are the goal, after all, and won't get in the
way of other gigantic hugepage allocations.

Somewhat similar situation with CMA (currently only hugetlb_cma). Is
is never ok to pin something in MIGRATE_CMA pageblocks. But what if
you have allocated a hugetlb page through cma_alloc? There is no point
in disallowing pinning for it. That 1G page is the goal, and pinning
it won't get in the way of other cma_alloc calls for 1G pages.

I agree that having mutiple zone properties is probably the way to go.

At one point, I implemented something like this, a minimum pinnable
page order for ZONE_MOVABLE. E.g. if you set it to 9, then anything >=3D
2M can be pinned, so ZONE_MOVABLE will help get you THPs, but not
necessarily anything else. There is also the use case for CXL memory,
where you don't want any kernel allocations to come from zones on that
node.

- Frank

