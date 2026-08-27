Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 192E6C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3A26B0088; Thu, 27 Aug 2026 07:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054B56B008A; Thu, 27 Aug 2026 07:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85246B008C; Thu, 27 Aug 2026 07:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF69E6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:21:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 546F31C1C58
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:21:44 +0000 (UTC)
X-FDA: 85146809328.26.C4B446B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63A17A0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:21:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f1LHCRVA;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787829702;
	b=e5t0azIhXVqATS8njdeBZN+/hNNP8eD9/exzm7xF1mfUiut0F7W3h4VVBkYpkgVyu7x18s
	6U1W9u5aF94dI1ihxa1/I6+PdJe+DXFKjeRrYY4DmlkKtIEecD0FciibXY08X+/aBDp5a5
	WtKDdRkmZa9PRAjl8JdGCuYNOQxGrfc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f1LHCRVA;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787829702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UIgM9wZ4RI/8wrWJM1FMTtmf/qGX7io7Fd5Y0z2gPc=;
	b=SbXjKDLBFSfUIidIeZHDBgQHSci44QqEyS3X1b6MQ5ktwJsX3O/BSc1g0zmLWOY2kK2sja
	j9ZhkKxJHYH+JLLCGjngfClJxPuS4yWlxyEyulxF6U8ENds3TZRRVbpIDSRtoDi9V0VN/2
	uhef7dL7yCG5mJxJNDC2zilY0OiKuw8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 944AA43FD1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772D01F000E9
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787829701;
	bh=0UIgM9wZ4RI/8wrWJM1FMTtmf/qGX7io7Fd5Y0z2gPc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=f1LHCRVAF0p7WV1uJK9MuRI7poMNWprYq8VQhdMPLaiNA1JpsbYvcGhkmPdy287bN
	 dXv5RTxSbqiTw0DB5Sohqd9Hp6y+Tq7qC/NngZdMVdQPGdCQwQQkpNutMcvuAZ+lOv
	 UIbFBABcSIlEgXW/LQi33OHwRK8JgsxgJM/pXdDw/O0SScLqwEBX35LVHE4j8/uhmQ
	 0ElbhxNh61iQBRebTGRcljtthxtK5++74ZLJoi4SMaNUJDMN2NfbW0oqXJlwlNQAA0
	 laeY1aqOFndAh1VnKDinpy4wIrtqvvMNFwi0HSwStga0e10SEcT9y0VuguHSvB6+7C
	 NavCRzQl330Mg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-939094306b0so28994985a.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:21:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RouTYS323x6kvKvzo0VJMkJfIphRql9IRpBxsvq/ZiRp5E8K6LlspC0ILCKKSU2AFiESE/KH/A6nw==@kvack.org
X-Gm-Message-State: AFuF++n2zMdIF85U0cOVxSd6gU9aGDusTuhr4R99tHGhRaU2dX2b0Tnz
	uAMXMBXsIqY8wkIWBd9jGQnqiSQgBDd6b9KPLgllwR4thmbVICvFmBVQXO25iK8QiBYL55zYEEj
	E1s2n+GkvA/qX6TF8Ec0dfHfW37DP/eA=
X-Received: by 2002:a05:620a:aa0e:b0:934:970a:beb2 with SMTP id
 af79cd13be357-93780490d8emr1295635785a.26.1787829700622; Thu, 27 Aug 2026
 04:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-2-baohua@kernel.org>
 <CAMgjq7AZtqdu-yJ3TSa9Zq=Cwuqv-NY+ptz3Qpive-iFXR6e0w@mail.gmail.com>
In-Reply-To: <CAMgjq7AZtqdu-yJ3TSa9Zq=Cwuqv-NY+ptz3Qpive-iFXR6e0w@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 19:21:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x1ckY2uFoOYq=Vw=d167u+-yVpt-TSWxju41ivth2iLw@mail.gmail.com>
X-Gm-Features: AcwNN1VUXhvl5pivnqOcuFtVFnj2RfhRRiUYKbPKlJdZakv6BIoplbtIqVZG-RU
Message-ID: <CAGsJ_4x1ckY2uFoOYq=Vw=d167u+-yVpt-TSWxju41ivth2iLw@mail.gmail.com>
Subject: Re: [PATCH 1/6] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63A17A0009
X-Stat-Signature: s7c9wt8yaf6iq39bmb6y87g7mpy8rotm
X-HE-Tag: 1787829702-117334
X-HE-Meta: U2FsdGVkX19VPpVdiH7eXaAObCWJ7QFa1PdQcCtohvNJru82N8+YWzTBHrjMYpXqdmaTFnxsDenkMLNYcurIT0U7XkDuUVgiCvaJ+Yp4y+rqWYkbujGnYPTfjc5QmZCkwiCP5W8c4T3FeFntDQlskQdbYTPcWW0SX3DPdUmNMdKEMU0XAAx4vHmouzqVSL8WvOdEvk0ZzcA07H7+TFXZV+v+WqqwehZt83A1xA8TP92yMetVjgVI8esDa1+ohJBwUI/WxzkGeBPDcuGpqnNH/g9skvvYdrYkjvHoI+D6pgzIX6frdtfl8PdsGfOAZuBjIrT5OHCYePCSaXTMDR3VXJOIlXJirZcRwoAbVzNlvBcs35puixKzwRPmqt7hiXDG42xkKBAHwyhhLMKAXKmmPKME+jls/gk51lhonuhbwPoINbUMfeMnsKYxVCpBpEWrC5kpExKzx5qqJCE/Ia6V9XAET7vo/AAHne1zvKUebKVzYZ53lgfOG239hzBsnqW/4hyrWuZhH5LDzvSRPgALJQqD4i2NmABFaRJidurEGswfi3lmVArlSIdRIt360AH70AHTmxsmcVg47ogReW7TeWx9dRlzVQlz1pW7xOPXr4xGQ8k4jsKfGS36TNMvDr9kr9gRNmskSSzXAqg2r9h5NPqybEPsZlIsYYjqb2dWsiw1n4tBjFce8OpgplFmR6NDqc3v5ETFIWyWSNplpGrNQERNsEFUNztJoePrZ49vtOYkQcH3sNEsLijYL6rci54rlzwok0oMI3iV1Ya4tAg0ZAlPCRcF0acecpNPQwCwReYHae4V5snZRjAXmucye7QzHbiEcwiQfFQZZ6rINPFnAnuHxWadFeRcBuy8uGfLXffQmjPB1lfJ4/4lF7NBKSB45l/dFbFiJom6C7FJAAN7ZtAzu6efBMmioWWVrQz6rAvVKkIKRCK9REKVoNYH2nnHlZ26ATZPhlqPxLt7uyX
 7Retoi0+
 dSV4s5iAXyXsatlz8TO2GqCuyZGU9PosEfr4wNDybqYGNSfM86IsugsNObjA3BLyEdia2e24z8BtTpYh+Rb++/dE1SYHCgkxcgyfwZg3naNrCqnLx635tQKx8DoaE4z/N6PEsZ5aoQO2pQuS7thQ55XdTKVJsNGUOeA/AjmUK9aLUHD37d08OQtugmfB9dCPMWZ8MsYKCNcWarBs3IX43iPFAT67dbHtiBnjGqJHYDfYQKhfrlCl+nECuYmP8Fb7cYQID33GyZZDUC+HXhLkhGLEXOlLdbsWkuHDO0wDhRUyEEE92RMD4itYTa1vdiXbaVJqljOhi82LgdzznB+EgLw715dUTKtwfLbhWYA6Qj7HAK2LcZ5/V75NYDSTnHMtRxbyQlw/Z1YmGPbAwhdiNhpwzht0ZiQSEdWufaVJS+fVfdjsVdMrT5P6xl3ihqqOQy3+QmHTrOGal67Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 11:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Fri, Aug 21, 2026 at 7:09=E2=80=AFPM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> > as it advances generations. Instead, accumulate the size changes
> > and update lrugen->nr_pages in a batch after scanning the entire
> > oldest generation, or when the scan stops because remaining reaches
> > zero.
> >
> > Since we only move folios from the oldest generation to the second
> > oldest generation, the active/inactive state cannot change. We can
> > therefore skip __lru_update_size().
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmscan.c | 46 +++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 35 insertions(+), 11 deletions(-)
>
> Hello Barry
>
> Thanks for the patch!
>
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index c1404a59523d..0d74fc00abd3 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3296,20 +3296,21 @@ static int folio_update_gen(struct folio *folio=
, int gen, const vma_flags_t *vma
> >  }
> >
> >  /* protect pages accessed multiple times through file descriptors */
> > -static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> > +static int __folio_inc_gen(struct folio *folio, int old_gen, bool *inc=
reased)
>
> I feel the naming is a bit confusing, the __ prefix doesn't tell how
> it differs from folio_inc_gen very well, maybe just name one
> folio_inc_gen (the old gen could be any gen), another one is
> folio_inc_min_gen (the old gen can only be min_seq), and with sanity
> check in folio_inc_min_gen that expects get_nr_gens =3D=3D 4, and
> lru_gen_is_active(min_seq) =3D=3D lru_gen_is_active(min_seq + 1)? This
> could be a build-time sanity check instead of a runtime debug check.

Thanks very much for your suggestion, Kairui.

I tried splitting this into two functions, folio_inc_min_gen() and
folio_inc_gen(). I tried a couple of approaches, but I think I=E2=80=99ll g=
ive up
on this direction.
folio_inc_min_gen() and folio_inc_gen() share some common code while
also having some differences. It=E2=80=99s hard to avoid ugly code duplicat=
ion
because folio_inc_gen() cannot call folio_inc_min_gen(). However,
folio_inc_gen() can call __folio_inc_gen().

The __ prefix currently indicates that we don=E2=80=99t update the LRU size=
s in
this case. The sizes can either be updated in a batch later or updated once
by folio_inc_gen().
Maybe we could add a comment to make this easier to read, or use a better
name for __folio_inc_gen()?

>
> I saw baoquan also mentioned the debug check on
> lru_gen_is_active(min_seq) =3D=3D lru_gen_is_active(min_seq + 1), which I
> agree.
>

Agreed. But I feel we only need to do this once in inc_min_seq(),
rather than for each folio.

Best Regards
Barry

