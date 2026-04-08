Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3361B1073C8D
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882A66B0092; Wed,  8 Apr 2026 07:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833216B0093; Wed,  8 Apr 2026 07:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748F06B0095; Wed,  8 Apr 2026 07:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62DF06B0092
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:00:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26DBFBC6F7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:00:49 +0000 (UTC)
X-FDA: 84635095818.03.C60B48E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1BCB6180010
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:00:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bRVBbQly;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775646047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZ2yuTZvfsrt02dodKOU1pTCiBawJg1GQIriROlTJHs=;
	b=JJdsmgXf3vCVklXZJWPPD6mGdQ31hRW35jcFEsUa4ua4EikyNm2rqxSJUV14AMbhPZXngD
	/hH1iAJstLwCrslILxCzEpbm/n88dBSrJE43lBF2fKe5/mBeUcUfBDmQmQH16hnpptZp9C
	fpFpYlthLL1o6+ANsWXovolxeZOSYJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775646047; a=rsa-sha256;
	cv=none;
	b=c6dOv1cnSo2d+u3ompOyWgcrpBSyycBnfYZEFcTKzkWUUC3MnV0iNP5CY3+9K9y4LHOGjv
	P2J9UgnWVSiS/VZQXKQ4yixzbE7IaRRG097zJPomhscOA37TCq5+o6nh52CJwcJw5U3sFF
	dAWo9iEr+rY8z8eoOF0XRb0uJhcEjWw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bRVBbQly;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 647536011F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D109C2BCB0
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775646046;
	bh=0OfgS+n/fNHdA6iHaO+uqBDCD2A8pXnvnNC61V/pXfw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bRVBbQly3XBWY1dTEzOEwlNr0HfuGL1bTGHzsMkQtqFOHYtF5lhWJKIjXAHNOSeRO
	 i3wpQ4md7jGhUCJLSyjGLBKck9fixNCf6lbZSPOQ75UYEv3KVoMz/3BTijIM1cXq1r
	 eD81XeKn/cWcQBnyVwCKQKzAoJ7FNNwT1QkF7UthrOxerX6xeaadm4akAQs/EVmAxC
	 6tQerp4BeZOZhoxYvNhcZD0ZgiblFxYTJGApIrxiSYdP+YCpkx0JUHFQ25gHNrFJH/
	 8SJSNSJwNVVWlQmyjZkupyQK2+Lx1Ua3qEllSqeH7CWAxnFEqDHNsLWfpZXWTm5tF/
	 eFUmqQg2CAcwg==
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50d59d249fbso63608351cf.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 04:00:46 -0700 (PDT)
X-Gm-Message-State: AOJu0YzDkROa9HHIyBxQuKPA49BeDAMfYRZVrt63lmBMGeqatVpKtd1i
	Dme+e2b8VIjWigN6q6+aFPg5HqdqUcSs4lgD04op7OsVuX6WcYdo2jHp4JwnN6o166kGx9hmWip
	CE4xQV8W7zixFNAAcrBXoMFjK43Iucjw=
X-Received: by 2002:a05:622a:1e9a:b0:50d:7587:dc46 with SMTP id
 d75a77b69052e-50d7587e069mr271418751cf.12.1775646045425; Wed, 08 Apr 2026
 04:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-2-baohua@kernel.org>
 <02b0464a-13f6-4e0c-ad69-0f494bfacbf4@arm.com>
In-Reply-To: <02b0464a-13f6-4e0c-ad69-0f494bfacbf4@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 8 Apr 2026 19:00:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x-73NTcef0Ep8wKUQviC=4KvGh3BfwGMqNFQt0fTPt=Q@mail.gmail.com>
X-Gm-Features: AQROBzCZTm-M-8NVQt7j0TfFWeTANOKbOR2ssF4vKWCEH8fhyZKDU6z1LoiRbbI
Message-ID: <CAGsJ_4x-73NTcef0Ep8wKUQviC=4KvGh3BfwGMqNFQt0fTPt=Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com, 
	ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org, 
	Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1BCB6180010
X-Stat-Signature: phnekiao1hs1kg9bg8tjmiywragszgmn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775646046-740664
X-HE-Meta: U2FsdGVkX19DNMBPatWomTMFMU/Rf7plO/UOYh6cNl2yrjPyFB1meoz17heFivb/ykM/MZhObSqmdVzc9kr1fi9nPHc8SOY+iL36CYlgV9t2dqC8WTYq65Og+eXncMa589piumhXlRMrQXiW/+9ASq28coQoLPcCzSULvv1g6FkFXMd0M9eimWJq3CA6Ma2wOV1h9/CW6hzpeCApR8xFwuV0EKewcigxtBHCSLIg+/VWjQV0DWN/Cc61kDGK5m7bnrlPXNakwLndk1elTwa48PzW44Za6op193Abs+54ssa1Oa52F6VuWBGfv5Wc8uS7NOQoWI1mQ9hpCQ3ZO5L44lhTwok97/78ev8dqB28dXFbqvbBXZfAOZv/N7StkW/sawEtpaWbomy92PxJtH4KA4QQ8Wl+h897DIC5Wjy+fGK/vGZpEmMAc3zrkN34EHYUZq1IeZGupAwiSY2Y7klGnS1/Baq0RybUwT/cSAlQGO3m8dxyl+b4wSyQ+K/Mtfhy8cKui011ltOICJMXK8+aqPlk9/Q0KhEdDqvkq7Rx2k2dDjbW7FuwoFAvch4k2SOBu/9/+C/RTn/RnwknnMtNuvMQ8QpHqaorh2HCXpInY+2T6j6EtD446hKgw/sOyiIDYxj6pNlqi1Q2B4e7jZtgPo2q/TuKxFXXx3udF2qwM+WYVVZ1zeerdbCUgSdrY3HC5ilMct8GvlAWPN5gq77d0cdK5SJdHyXK3EATPUV0pfXikFXLtWHGC7pjOUGTasmQ1t4aNcat6CqxvXQGuAtOSXmgCeebLUpCVmiZK78B01mDSkn2QPSu50NeVd4UBF0x7JinonMDrwsQr0I3/yVmIpGIJ8shSAyU296NF9Na5ATXnSb+dMY/fmqWlI6Ba7fIs9aU2XQBpHQ53o5QawHqEWrvDdlTC+nEUyNsnkTqIApjiXE742rOyhzKvc6PI66oMNSjtzUNU4nVURYWPd9
 JPXVt3HN
 hvyMpnOSdLkd7R4fC1AIrsAWTUMVj/il9ac+k6HS7LvKggs0F9Bkbp5KgCwWZu3A5am5ULMxIq8VycW6aughQBqhh3c5m95uptchFGXYRGVeti1UIh2roZqUMxcbikVZfhJQY8096K94GRU9E0MZ6/nr/t0uoe38FN0NKKrvaHyO2JAjwGuhozXFWYphQs5wOtte54WW18SKyoBjIYPo5y+zrr2oSnoaMQlXSqSPWMYtpnT80X13fMzMKUzJ8Hypy0X6TdeGsw5PQCwIVWF0DG0L5OcB73pBaF2Pp1bg/urFu4xCNEzlDIBUqCQRWKR4BSJlpK1qkeBZ+qQ8q+fYp7X5lSXXBb2qB1nAIeR0JMm5smyMI34WwLAhRPx17C5WgcPp+cEqszsiVxC0Jy8zTTjRq5JeY6M6ndkbnkuSnxpjxqfQSZMn0ySwKIem8OQ0Tsqp4/GDulKnW1bLnOTxeRqX5dW6mSsst96wBDcrRgjtuwds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 6:32=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> > For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> > we can batch CONT_PTE settings instead of handling them individually.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > index a42c05cf5640..bf31c11ebd3b 100644
> > --- a/arch/arm64/mm/hugetlbpage.c
> > +++ b/arch/arm64/mm/hugetlbpage.c
> > @@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long si=
ze, size_t *pgsize)
> >               contig_ptes =3D CONT_PTES;
> >               break;
> >       default:
> > +             if (size < CONT_PMD_SIZE && size > 0 &&
> > +                             IS_ALIGNED(size, CONT_PTE_SIZE)) {
>
> Nit: Having the lower bound check before upper bound is natural to
> read, so this should be size > 0 && size < CONT_PMD_SIZE (i.e written
> the other way around).

Thanks very much for reviewing, Dev. As we discussed in patch 0/8,
this should be
PMD_SIZE, not CONT_PMD_SIZE. I will use size > 0 && size < PMD_SIZE
in the next version.

>
> Also IS_ALIGNED needs to go below size.

Sure, thanks!

>
>
> > +                     contig_ptes =3D size >> PAGE_SHIFT;
> > +                     *pgsize =3D PAGE_SIZE;
> > +                     break;
> > +             }
> >               WARN_ON(!__hugetlb_valid_size(size));
> >       }
> >
> > @@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int=
 shift, vm_flags_t flags)
> >       case CONT_PTE_SIZE:
> >               return pte_mkcont(entry);
> >       default:
> > +             if (pagesize < CONT_PMD_SIZE && pagesize > 0 &&
> > +                             IS_ALIGNED(pagesize, CONT_PTE_SIZE))
> > +                     return pte_mkcont(entry);

Here it should be pagesize > 0 && pagesize < PMD_SIZE as well :-)

> > +
> >               break;
> >       }
> >       pr_warn("%s: unrecognized huge page size 0x%lx\n",
>

Best Regards
Barry

