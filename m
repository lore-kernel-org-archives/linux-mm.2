Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DA4C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B992C6B0092; Fri, 11 Sep 2026 11:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48286B0093; Fri, 11 Sep 2026 11:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37196B0095; Fri, 11 Sep 2026 11:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82C7E6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:32:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 197D91A02C4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:32:33 +0000 (UTC)
X-FDA: 85201873386.10.DC86CBF
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1854718000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:32:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l/pTsjLs";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789140751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tx5AyXZ3GvBAYCgk4osxeglSu6XXu49YTcUaOVz/aoc=;
	b=hMWJxdWD226z1xbNpYahBIX0ak+4aWYN0xOL6hWI+qMadbvLRxtLwAl0aGyZm5mNHAawq+
	LNlIgdNgpBTYcecScsgAUKKfTkav0FcoGv/h3/m48Fc/20OXkWw06dJSlpzW+QBCRtxIU9
	kiSOeAIgIVF/K6agGUHOPdbqa4D/I+4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l/pTsjLs";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789140751;
	b=UrBNuuHnSWZ2Zl9ZERdKthJ5CLUDTpppOBEIH72eCr8wU4JoaAHbzz1k2xZ8Ax7jNtEQRb
	ULFn0P0+LRTR5UR7l5RQ/GY7SByf2iEzXooDlS4xT1OAEwydk3dPGdKJxkM7ofHYqen7ss
	IOSTqFSHt14xQsNSnmc9q9HlCijMzQI=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e2406so128665e9.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789140749; cv=none;
        d=google.com; s=arc-20260327;
        b=id8OntqHT1EUPc6VNNMZ82yK6tFM6HpEAB+Pugo7bN1vx2Crf+Ss5urQYeb2PcKo9J
         Wo98baIzo3c4WrRp2br6PspNoZLcsQ8s3LA6hFYdjx2U4A0IgasBd2I97Jid4LH4aQC9
         KyqgOEOmgQh2CT59KaPHQfMgs0wO9+YpsJxeRH/DnHVsanTmbtJ9Ey0MYAjj2FxSc2Fg
         Gl5UEylBbSS0X0bAkRUP1528fXx7LmFffP3BgCIS0pvSerYDfcy2ZDeem8w+OOg2EYPa
         h1dw0G1o3vuHwQkMnBOadEJABg69jh/Nfz5L7KZoHMgXsJdzORTx8RJ4IEDDRUyTIMdc
         CK+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tx5AyXZ3GvBAYCgk4osxeglSu6XXu49YTcUaOVz/aoc=;
        fh=m2EWjJUm0DJR7F+Lsbfrs/9IfLs/6JIypHAYDyXTcXY=;
        b=fQXS3CFZ6A2nmLoiMvgQyE7L09Tl5Kjdd2EW9stCD8FDwr3TjbHxX5Q+e45hyL5sox
         zUTb7QWNHCT26CohN5wKKAlKr1qjCrEte33hxhPuKyDg3fsa/5g+4CcKcfMvic/2jkL+
         0IVWPDrderygp0QTpSkq9Tru4UzU1LqO9CSL0zjG21ZXbhU8AHxgtt/HTL9cpXDlHOOM
         tq91FwomS1YKKlKxKpNR8TWPfZOaOK0VN07JQXcrUnbIkPi1THSSB7HDSpFwGFc4W9TF
         SFN90mWnrktbg1v8AV6OD+eFJ7Oz5VDjteW2EfzIe9d4P5yVMCVJZSq32KnE/yzOGwpD
         D31w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789140749; x=1789745549; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tx5AyXZ3GvBAYCgk4osxeglSu6XXu49YTcUaOVz/aoc=;
        b=l/pTsjLsIvmrzRExWG38aHAwHs6hxs5sUjIuHln3eeKgqHlLcgk1eNd56k2sh1fY3j
         cbCjiRNf77gX5+vMv3/FLt7cPgY2BUGKKrPgyjXvxILIhbh1qvNNlkXqOunquqSWTXBm
         HnDSKmyNpxn0RPchDymqjo/gMd+j3R925bZb5t9aFk+qSBpinq0knAsjwK4cDcqDmxks
         8fagaLnj5SatS/w96Y42la+Gkq9tjrFgJPyWgVuf0okDRDliBhR0QzCTWtte7dsboUMh
         zAVwyofdH1Ki2Rdt5xfhTkwruunYcfNrnuh6YRqSDZ1DOGjikK2kdc/yTYqnw2DZbyXH
         qAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789140749; x=1789745549;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tx5AyXZ3GvBAYCgk4osxeglSu6XXu49YTcUaOVz/aoc=;
        b=GwnimTVBRPqSdZl3f+Uay2ewnbtVuvO0LKLEyqSx84TQf7XSlAhKKlbuV4Rm3Y/Qhy
         HpggPtaOJ2IsbBpyt2AKkWR6n4/PWJ+fNFuF89GEUGYK2UqOGCmfjWR+LCLSPEhJN12h
         Cq4Y8wxnTwx7cighA4KdDSV2a7mswMy93H9Q6VXyjB+ZZ2Kn9i0mbdSTK7HkH+kn1SwW
         66tVCCn4zV8f09PuAOhzm9CO/L9/tuj3ubEoXXdd3tIPbXhuVbytSswq51anGyND73DS
         zYRcEbc7SF1d/vwToFiAggjcD6jpP3FvPUrJdEn3yiJJwGnB0R75JRXbwTLy2orjHX6+
         l9/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxsMJs36xAKC5j4+ptlwAfDThgI0hxL4a7ffLEhv734bIouOh8YnP7kWvq+JmyX5zoBLCINaVdqhw==@kvack.org
X-Gm-Message-State: AFuF++nnCsHSwyj2T+5Fizf65nIPdawZgT+DYa0FOynFfR+CUq1flCFc
	iO6cIZp5vCl/cRYZ8N6JtGn+cEuI6hiJ1AsAEq61rO03sB9+oAzYwcD3G8gNjvGNPiYlbTvrYE0
	XM2tEomFQqyY9knPxFkRuvmkN6v6vIJg=
X-Gm-Gg: AYBFou0myGRwUQZ0jca/EEipOjyGB9d5A3NFso1wWt89eG662jMf5a4NhHHhmPcq9EP
	YVktf+9shZk2EGpHV++9L0YbFsgIrmXo78BbyHTGLoGvWYitcd+hBqeUtJt/ZT7HW8Korii2j72
	saCKIA5c3xg5DGZn3ZCYB1lyAmDU3NTzfpgkx10GouPH5YCoTjKu5/rKfCNDofGTpR3wfSatgOa
	k83NWQMFSEvRKwh1ZeDc2qDbEWJtlBErSGnuTpSBJcQxz7JMDFAtilf2GtKf92HSLqQ+JciQowh
	hMR9pDr2I09LYIyKmASmkA8ih09pphJrSXW1ibXqxAormVabo1FXPQ2NJkxe0ymiaud8EVkLiba
	l8VNQCtPeUMqC
X-Received: by 2002:a05:600c:3f08:b0:49c:f13e:e50 with SMTP id
 5b1f17b1804b1-49e6108c75dmr59294085e9.13.1789140748568; Fri, 11 Sep 2026
 08:32:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260911100427.2804601-1-kunwu.chan@gmail.com> <20260911133232.91581-1-sj@kernel.org>
In-Reply-To: <20260911133232.91581-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 11 Sep 2026 23:32:12 +0800
X-Gm-Features: AcwNN1UB2lLvhFoOalBtTq0xTCkHEalZbjYl1gPmEXSR-cXhuK4bJrIAZhw-nSE
Message-ID: <CAN_Opa95ePWNT6o2axVtvKNjC-1aNU09f_XMnUjcJFZAbYeUZA@mail.gmail.com>
Subject: Re: [PATCH REPOST 5/5] mm/damon/vaddr: support pgidle_unset probe
 filter type
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: i4kwsjni6c8j4xhxeqwudmbqk6nzompr
X-Rspamd-Queue-Id: 1854718000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1789140750-600150
X-HE-Meta: U2FsdGVkX1+a9P4ezdItcPhDAV2L/y4OlndT39l8Z0VZTrxpm8xpXdhujYtVzakw8+iYmlz3jMvmkIyjCH21ift8jbmgW+HI+itFbOOP80veSWs+yXNNwqeQ8DYCVZDBZLeLxvJ+tIOyRr9oRIFLJhsHNnAQY6laRXx+1pjy8Sz53DBVjNCNIKzT+zoPw6pcuuhCTkqLNctLM05P6gfTddJ/DQvyXeYAcWQVrDrLXjgwSjllrq3BjGR0hJKewwQHfY4AkdseDvMyE+YqFR9h0OQ4kGvQ8JhCZjgEY1DE5AMHfJC3rH1BnxXEMm8S2NOWOtKjXkC+kaqw7ZC81cqLR4EespyQF3clonVjQA6OUjXx/7hC3NiH1PhOa2o39iZlPjJq30xzouGh//flSqG/9K6+ArMZ+vEy8dax2qY1icoyJnJft2FIDXguSB8zYaoeIi1MeiWLc3hWaEVqj8npCbGXk+FT6FflZEYUE581owUP144Zq1rW8G77qNHru41ndYjx650GXcoQUGUdeNfX8mobbI6jWt3y4C0ILk3z2M1oTWgGPj2asroJ74/LXBP+fimZlE0Y1omRV9vhKZl/rw2Nxp9KXCmpcrunkv2T8C720f9henpp43xAGh3rTYTD1moPAQiDgrG/wUeHWLs8ZwfxQyUaf/kQ83X0DY4OyG+sY1b6+r+szzvWxaobDcIuC6njyz6IthZ3nAFUlIUxSpyv/wR3ffxQhMVjRBsOrWK2Gcn/0V5/+LkfXol75dLxTb6U8FonKlNA1UPdCRJgaMCkh4vghtbhFYfAjRHSdi2l8H5TB9VvfYhxu+3raWjrxfcS68cpUcU4rbyfpbp2qMJ0amH9PRygWlSyIPE8IxN6kAqofvyNTrjTUUD3HE4KpzkFg3Y+WBY1BT2twarsTafdpqRQE+Ox+CfUbrkPF2PjfBXHmG7sssfU6fSjjmFvpoIUyGLdVkcDk64r76p
 4t+Co62k
 vBdISYiqh3vqop7kIEWF9mbrZCEC5/FeWJk2l/XRWuIoBBFcU4u3rbUTY7qdkuKJ3m7tFoFgRjDNVmjrW+HTt6aPS9+jpueDiGyci+BOTWe4okBM056L203qSoYDsOUA4bPfiWmw5j/5PkShqTkL+nMv6iexi1BpWaqoazsUKCadX+FgjvihgbCzxj0XdQNIUicd02aYGytfKTx2svhdWAWMQrXhRkAHLCWYbUPtyq+EGdhKrJMTBbok4GIb1obTbpvcfXSdLX7FW1+G+DeeGnpHrRqizUhNVP1nQc8XkCXvOOfdeeZIqm6fBekADqzsSKYvd9S6fst7j+5jXi9fAqf89iYZwcqKDDYkm0OF2U55bhY5nVlTcu9k5oNRFAH8cjnQT7C3ONMOCtZIEm/Q6TvtQJ7Fy+J5J9KMtWDZX2+L12yVnVW4yVZ9DBQ+7aNtWxYHwQ8P9XLq4Bxx/C8+mQZcvCeCKfMOK5KERjCrM4rn5sCtAS/aDVrzmSy+ENST4Vz61NcijA6VQmiu9e9b8nHhYzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 9:32=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
>
> Hi Kunwu,
>
> On Fri, 11 Sep 2026 18:04:26 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrot=
e:
>
> > On Wed,  9 Sep 2026 07:04:07 -0700 SJ Park <sj@kernel.org> wrote:
> >
> > > DAMON virtual address space operation set (vaddr) does not support
> > > pgidle_unset probe filter type.  Add the support.
> > >
> > > Signed-off-by: SJ Park <sj@kernel.org>
> > > ---
> > >  mm/damon/vaddr.c | 55 ++++++++++++++++++++++++++++++++++++++++++----=
--
> > >  1 file changed, 48 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > > index 45239f05e113b..9a38dc89a156e 100644
> > > --- a/mm/damon/vaddr.c
> > > +++ b/mm/damon/vaddr.c
> > > @@ -522,13 +522,49 @@ static void damon_va_prep_probes(struct damon_c=
tx *ctx, bool set_samples)
> > >     }
> > >  }
> > >
> > > -static bool damon_va_filter_pass(struct folio *folio, struct damon_p=
robe *p)
> > > +static bool damon_va_young_addr(struct folio *folio, pte_t *pte, pmd=
_t *pmd,
> > > +           struct mm_struct *mm, unsigned long addr)
> > > +{
> > > +   bool young =3D false;
> > > +
> > > +   if (pte)
> > > +           young =3D pte_young(*pte);
> > > +   else if (pmd)
> > > +           young =3D pmd_young(*pmd);
> >
> > Hi SJ,
> > I see that all callers already check pte_present() / pmd_present()
> > before calling this helper, so I don't see a correctness issue here.
> >
> > However, the other DAMON young/accessed helpers, such as
> > damon_pte_young(), damon_hugetlb_young(), and the PMD path in
> > damon_folio_young_one(), keep the present check together with the
> > young check.
> >
> > Would it make sense to keep the same check here for consistency?
>
> In my humble opinion, it is already consistent as long as we didn't miss
> present check in callers.  If you concern a case that we call
> damon_va_young_addr() without present check in future, how about adding a
> comment noting that on damon_va_young_addr() as a followup work?
>

Thanks, SJ. That makes sense to me.

The current callers do provide the required =E2=80=98present=E2=80=99 check=
, so I agree
that documenting the assumption in a follow-up comment should be
sufficient.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

> Also, thank you for your reviews to this series!
>
>
> Thanks,
> SJ
>
> [...]

