Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD463C9EC72
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 11:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E83B6B0088; Mon, 12 Jan 2026 06:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295586B0089; Mon, 12 Jan 2026 06:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A24D6B008A; Mon, 12 Jan 2026 06:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02CB86B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:09:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88D4A1609C1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:09:54 +0000 (UTC)
X-FDA: 84323041908.09.0821101
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9C3ED160005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:09:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WXqwJ3qj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768216192; a=rsa-sha256;
	cv=none;
	b=ZTWhD+2hQoMNHXB+SsJkYAz9JixYGlHFX8Wav4IV5jKCsSd/+hK1n7oT3+26D0PLfjb5qK
	TUj4FGM5j8Mcvs3xVoyJzHUWD509urCspz0WQfu7TnpkkIxbPbboVzzawQGk2m1jg3ApWb
	w9mDXpkKRDUQzO/rADqTL2oKCQW5lw0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WXqwJ3qj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768216192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D62KH7s9ntfKdLzvtrZBDFlJUAmQrrG5hhZyFBCNFfQ=;
	b=k2E7xPn9J0RNFDHI9L53fmXhfX9KOvdaLqgjj+Q3Pc7Q5wMGyqSXDqT3Zdvf6oGz29oZ0g
	1/Ucdoqa35SKJr1aKZp08Lqc3/fzW+IvFSxsgO9BuKNkxlnGBAQm3EICTPJDARznMZeb23
	+7GwjH6LhpSyQNPK5Y0ssiV/5fmP5D8=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-383122fbc9bso33298671fa.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768216191; x=1768820991; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D62KH7s9ntfKdLzvtrZBDFlJUAmQrrG5hhZyFBCNFfQ=;
        b=WXqwJ3qj9kx5CHzfxNWBERbbZ6DuC37333JX/kgt4H0Dq86BG/fGt0YncyyJvbvJji
         MR1e9EIlxquGYmsSLgpCZduLl7hAMQ/a8b89DttcwGrKf42wdiERv+iTzBsOz1FGIrqK
         Vridi0++ts6c7zCccVb9IJNwfgbpo4AcVUxnW4AZ2/NJdtyaCXXSatqiHxRmgvE50oCR
         2/p3YNnwzsucHUBGDsSfg2NsqO4e2WovT0oAZmxDdyhNT0z0jlC2kbsywHIOQvhxMEHN
         xsuTxBe5HRKpd3pEpofT2B6ztVQ7FapvictYGimQtSqzHQg6yfkkLvfoKjI52aIS/iOw
         QjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768216191; x=1768820991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D62KH7s9ntfKdLzvtrZBDFlJUAmQrrG5hhZyFBCNFfQ=;
        b=Jgw24Ov8lYCGfxa7XKw/qLv7QlipbYrabFUkHc0bf4eitHMba23WehleCJP0+YzM7S
         cOZyxzfie0rSpspsjweiY8/bNJmuu14GkoDLjgKoeLGzooJeHxuOzWqTlkjEp2RA0upJ
         FA35p8n2q+vSbx0g+YIMT9zmzcznvFWYCdzlUOGgqIHvSd/3DcqME72pZFOEfA5DsoBC
         ob7h3Z32d4eGLekSAcLsDYp8dXt2Dk846C+JpAHHIEFR9hIrQVXgzhGG5JgYrh7bGHZU
         1v2Ie3p95+UqkthXtG2mtIuNaZaZYUdrZvvMfUPFNDcSADuAgXck3rCFrOfHC9GESqeL
         +mOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQ+fhVZs2H+URQq3DfHoUTiK0gahC7sbxxjmvJNcLY/VDtdiy5NX7HOb1AhPgjpLQryLXSNCwBNQ==@kvack.org
X-Gm-Message-State: AOJu0YxDdDJS7FTQLNB9XGZHZxQGBsNT2DORG4RWhfUYDqfYIGlC34Uc
	T+hfGTKy4GXKxGIWwvLTB+sYdLE914iAbKmwKEWp6R3CXg8gF54HqPLDt2uhBhVBALy7/oxI1qo
	IGlBO7pgGlP+W6WPov07j4IPWrCxytG8=
X-Gm-Gg: AY/fxX5WkenYEwfJrxiB0TP9zAHPmUsGi+wJQZpBFmW68yjG1a7wDeE73Piwe4QQVGc
	HDqYJKlfufn+8k7S0b+5HI7r7BTYv6woDyaGI/IWBrb+kVU0vVvrwK04FEl3BKmdrvVwu8okceO
	KnqHQ3wkFaNimBp18rq9q6wXjrLJILFmvG+gdExqD/Ki9IuIFwcawfeJXA18itWxM1Bmg07eQyp
	rJi0enWlnoETGn74iQ7qt4QdqbWHKDMcsAWe3rntbmZxUBHsUYaHi22WTnAqWfI+zdIQQaR
X-Google-Smtp-Source: AGHT+IHSL8vBycNTvvL05BnSJELB44DXOnClZrUSB0/6pfdDXXc2lVKGO45NUHdVcscHeSKyJ3licgKu+aykAAFK19I=
X-Received: by 2002:a05:651c:507:b0:383:20ac:fb60 with SMTP id
 38308e7fff4ca-38320acfcffmr32957191fa.29.1768216190396; Mon, 12 Jan 2026
 03:09:50 -0800 (PST)
MIME-Version: 1.0
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-2-yanglincheng@kylinos.cn> <8c9ea6ab-02bf-4a79-bed2-2e7a0ecdfe67@linux.dev>
In-Reply-To: <8c9ea6ab-02bf-4a79-bed2-2e7a0ecdfe67@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Mon, 12 Jan 2026 19:09:39 +0800
X-Gm-Features: AZwV_Qju_WNTyGZwNaxuD4wfPtHjw8upOM4OR6RAJolJ3MOKpCw--6efi_tcGD0
Message-ID: <CACZaFFNCf=bb1S78ii8i=7RbQo3eO6+4bY-c0hmgN8kCXGNSSw@mail.gmail.com>
Subject: Re: [PATCH mm-new v4 1/6] mm: khugepaged: add trace_mm_khugepaged_scan
 event
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, akpm@linux-foundation.org, 
	dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9C3ED160005
X-Rspamd-Server: rspam06
X-Stat-Signature: inmuefbick7aux77uinqnfufskqdsij9
X-Rspam-User: 
X-HE-Tag: 1768216192-653092
X-HE-Meta: U2FsdGVkX1/IPPSDxkpGhPZ6Os8yH+94HEB8sy4FxR1MJrlg02kY4hLOkmh3yyP7XqXyxa/bnvEtqPg5oLK2faUCKDKzy6Tpd9AgF8iRcpA1zMPfaV46f7bI1WaJyY41ZEs6XsuzF5leKgZJXhQ5+2SFENpstuYiOlgd85AtO6e8AvFWAiMGjQBD0kHi+p4fOfUjeGyXvTxIUL2wmfu7ftcp++AL8zGavzj18dnDl16m666v26kcIf4DIKnLE2PbrnO7kc0DDYm49sSmlXLLTueTMFDqqKLhgTIPHn6slZJreQ9kv+Pk/QQPvkvPF3xSHEHAiVhPkuDyjafSnV4r86pNwrO48knU3i2DDdEr6IkfmfWmMB0kBNVpkw+dcocIY27CAwB8uhOIuMb5P5vmMMGoGivLLWpRWifioMUsho7gAJ8jy/sUXqv5JRxxUIASe1ht+2XY0zEI2Ag/oyK5NbMELNypzB2T9eCySxhu2jZFFNfkzU/nZXjaIMlFgQTCdnEtwNr2BtyTt/TL/wYnmOVsrauwfSwkOJSzticACETt/kMIVb8pq7Xepdb7UAyf1m2/Abva7J4y1hE7Omyvo9NzoT/X724RnUvOcwIgfpt9VrreDHlAORf6Ht2YV92+N+ZMB7hVQTkHgecZwOAlCOe/ICw5C2+fKB6/rAX3lMIwbV032HwoetBXVDD7bTLUaWAG3a+aA9ZK17hC4Q7DDrI4tFIDynbapifA28WFjw4TU5BAIk4BinKN1PlW6aaIp/hMYsbbX/p/GIBp1SeYH1ArDfWpTxRMA6hTE0hnVTgLaf5aymk//i6wOdwi2l0BVtXG8QE3f8/r/4CnrtUcAyhvVv/0jZSvSQ2P9hniD1h57Q5y5h0CP7yhJeWFTRtwVf8G85UqufqdxXS/oOEQQvwoCXbYHuHpA8VXbk14wKbDnUgxRF3LsawSax5E2T4v8wgeaEejCSag9y5mBa5
 SYLSj3ml
 hpXwVCJgyabpSZZOazvg7vawRSZ2mN/D+ErxvQoZNj4n/+gtLT2TfZGBZXTtobNAJqz1sGUp27ITl5UHxP3xkLuKrzBDcYLRoujvp1jcTTw0i1JB3p6cdrtDncXvz0FLUgvH6AaPFCIpTftlBOJ50h7M0M0rJS27p2pf56M1J+cJC71XdCaiVDc13AhXbnEBRRj4wU7u9F+AOhyE75kTHI4m8Q1FCILV2t54GQfOdry8S5neguJ/iRejrosgfgcTv0VE/rt3taQMeiceNwJOYRGTpTWIeuDGlH3xLD1gl0BADMkPY/J4sutzr3tWnVrzDdhDJJ5vn0/UjTNU38f4B9oIKM4C6R8APJ5JWxNEwILhfJHoNxdZRO8WZLKGP4JsV8+/zcxmm13FYTySC7TYxhwYAQwGmEKkFkpC36BRi5OsPC9225Ev0yPdEk1NcvSbBwyMsv5/Kfq1sR0BzMwiBGm62sB8Vj2tCe/qTgFKdZ1xGocM1gy8wUgMkZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 9:49=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> On 2026/1/11 20:19, Vernon Yang wrote:
> > Add mm_khugepaged_scan event to track the total time for full scan
> > and the total number of pages scanned of khugepaged.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > ---
> >   include/trace/events/huge_memory.h | 24 ++++++++++++++++++++++++
> >   mm/khugepaged.c                    |  2 ++
> >   2 files changed, 26 insertions(+)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/=
huge_memory.h
> > index 4e41bff31888..3d1069c3f0c5 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -237,5 +237,29 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
> >               __print_symbolic(__entry->result, SCAN_STATUS))
> >   );
> >
> > +TRACE_EVENT(mm_khugepaged_scan,
> > +
> > +     TP_PROTO(struct mm_struct *mm, int progress, bool full_scan_finis=
hed),
> > +
> > +     TP_ARGS(mm, progress, full_scan_finished),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(struct mm_struct *, mm)
> > +             __field(int, progress)
>
> Nit: progress should be unsigned int here, not int :)

Thank you for the review, I will fix it in the next version.

> Otherwise, LGTM.
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>
> > +             __field(bool, full_scan_finished)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->mm =3D mm;
> > +             __entry->progress =3D progress;
> > +             __entry->full_scan_finished =3D full_scan_finished;
> > +     ),
> > +
> > +     TP_printk("mm=3D%p, progress=3D%d, full_scan_finished=3D%d",
> > +             __entry->mm,
> > +             __entry->progress,
> > +             __entry->full_scan_finished)
> > +);
> > +
> >   #endif /* __HUGE_MEMORY_H */
> >   #include <trace/define_trace.h>
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 9f790ec34400..2e570f83778c 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2545,6 +2545,8 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, enum scan_result
> >               collect_mm_slot(slot);
> >       }
> >
> > +     trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot =
=3D=3D NULL);
> > +
> >       return progress;
> >   }
> >
>

