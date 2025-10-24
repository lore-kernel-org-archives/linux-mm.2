Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 950B5CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33F78E0091; Fri, 24 Oct 2025 09:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE44E8E0042; Fri, 24 Oct 2025 09:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9F98E0091; Fri, 24 Oct 2025 09:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0A168E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:26:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 319D5140848
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:26:55 +0000 (UTC)
X-FDA: 84033083190.22.1B90A8F
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 10FA2A001A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:26:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lj6A7iDk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761312413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mvz7WfloUlP5Ojd6e1kroOswZjlfxgMGTQOUIPJaae8=;
	b=qT1e/F1nCU59F+yZFimuuXk6w6rDVRqiu3b7uWD8f7lGSGofBYMQ7JXGo41rGn7cr6fNDD
	Sf+zIF6GLOgppTUCWnHjNzsYL102BC0xWkqrAaWRIbv6I8ccana56WS479FQPFHaiqBh56
	iZ0rLued5V17rtguQ7hmGMFxYMfjewM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lj6A7iDk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761312413; a=rsa-sha256;
	cv=none;
	b=qsCM4cpMC3eK9029CmbGOjBEA7aCwFFHHrvv1k265O8WfZNgPB2FHtvsU5pZOtJWPygOk8
	KiisFMWL3Z+tKJk5EGDCgvLBHeKNjZCmqJQGwHNolnNcfgFYte3Y0zgBROXndCbCZtd/9E
	FUy1maiaRfnzPYF7rJ8gDr88ZplC9NM=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b3dbf11fa9eso417376766b.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761312411; x=1761917211; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mvz7WfloUlP5Ojd6e1kroOswZjlfxgMGTQOUIPJaae8=;
        b=Lj6A7iDkNcXHKlkfNziGCGY9P9/1bx8SZlO34hXJmQASSC2gCj89sOV89MBV7em+R3
         nY1BVAmR0wZaMSCjAB0JfYRHhhXirwn1zA9RjTVDYlId4NbAHk7UYYwdOJTYeBJgfG4w
         vDa6jHuI88T0MhZK1DREfw7px3fKMKmwEBMgN21ErDiRXx0okDqXvhgMn4e3SqKEFg/0
         9y9Zoczd0JA2kQAINlkF8b1dYPHuVY5QUbr5Sk9wKpVQInnoFTC+Do7XpSNiCIHQM2/S
         aHznuONp/OJKp78q0kDHdIzlkjfYaQYylAu6+c2Zn0SeQ6WnNdAAFJaG/yyi4iGmbXej
         0jZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761312411; x=1761917211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mvz7WfloUlP5Ojd6e1kroOswZjlfxgMGTQOUIPJaae8=;
        b=SaeEJH/xp3YgUggiCTaU8xsUoc+Re2Bkn4nXr0y0YxQ4ZGyaUxh6wuwUdPSmvS8IeW
         hXaRGylVvrBKhsfWWJt997I1gQ5YofSN8n7V1DUuGM4MUpfox7RZoiDma2Z/hCVDC7+z
         dUi3jt5/20pdM5CPL+vNskpm828uejBknWlcPnzbvKTNHJ1/vVyDP7jKdIrIeVi0bev4
         UJyoA5EqKaT8Ppt30g0Z2m+e2u80GEDgQTTzouiPggDxBlw5/78XKc6Zx5ZA3TmAsWZ2
         Rw2cmXGz0XXA6E4BqBL/B6vBRK8T+U6sNt5VD2v2NInC5E1AG9S9U4rnBtErnMQFFVFG
         r/Kw==
X-Gm-Message-State: AOJu0YzIbSbMCA0/we8pe60jClJYLVizwBHpULZwlbxhgaggHL1XEn6g
	E8Mddv4r6lbDidN23mT41bvvO5uPTcfljDIiuaItu4koWLSsOhh4rkv1JOQ9ZDqbAr8/Vk6saLJ
	7sNX4M1VcwG2Xe00MF/6bf9yS6vfyDSw=
X-Gm-Gg: ASbGncsT+lPCeseQRarWxBsETXKaDoaZW2HielJy6EXEz/Dy+FISMICWFADbFUzq2NE
	yME7bFB+OjVAJMon/Kc9s5/fDE6D8qpreOd03aPZXAfL+g1yWAodi9x4F4SFJSR0Z3wk/D9RY8F
	FhrQCpg+3aCfoQDcbvIw7fZ3eDkhK01wS1on8lxPCZWzJMBGgRWPEmS7KYRBstlIlMnK756nQWS
	dSF4utBJY455ec6GJw/QpnRRqGovWBvtA1Kive2rFlY9twGjnHJnvMhMXH1
X-Google-Smtp-Source: AGHT+IFjjTuBXN9RNE17o1HXG/pWOF0aA/eLredLJlFjVbvcwj/jjil+eqIqI4xViBT203RxM5WtOZyiRCx27mJLRPQ=
X-Received: by 2002:a17:906:7303:b0:b4e:f7cc:72f1 with SMTP id
 a640c23a62f3a-b6471f3c28emr3320963966b.22.1761312411112; Fri, 24 Oct 2025
 06:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
 <178e2579-0208-4d40-8ab2-31392aa3f920@lucifer.local>
In-Reply-To: <178e2579-0208-4d40-8ab2-31392aa3f920@lucifer.local>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Oct 2025 21:26:14 +0800
X-Gm-Features: AWmQ_bluve24JSPZEEhNHyJvd6ofuK_JksD9uA6QkIIpRPsvLrDnJBnZTAjSPIs
Message-ID: <CAMgjq7DuJp_zyW4NLHPoA8iDYC+2PaVZT4XzETV-okVUPLNzSw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm, swap: misc cleanup and bugfix
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	YoungJun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 10FA2A001A
X-Rspamd-Server: rspam03
X-Stat-Signature: 97nm1udwm4819gu779zor4cqdyy58f99
X-HE-Tag: 1761312412-952757
X-HE-Meta: U2FsdGVkX1/mesj+ElR0KlxAlrKZyteyY8eAy6vJbvGFHp8+4sZ/I/AWVo5fedYrCO+RxMpvOW0H9R6sKy7+cbc4lW1UN+ew03ZjQtJYp8jNWM+SH1OCOlq3H64dPvVSJb4jsJ8B5POM+p2WY9C/dxKUv/l2Q9zJm0GlGJGswSmCaGnkpN5R7A4pgDPzXqi9S5H/18Tnthvob1t1yZ5PSYBFHbEF+efp1Y0mwUV1CeiO7sfATHa42jfE1Lp3eQ8GEHAjHc4p+JGAnsYffwddf9sdL1aZ69EBG81gEenyknhnbbX/XVsdj+F3XNwFDBNvNRC4zDn86kc5+EzNkJKykqtZcJCYm2Thq2L15vqsNpzg+BslbmgPjyqnoPS87dl6CYb2hxYTYDvuLgFjbGDr4TRpzYyt6RsreQkKYW8BiEWUl8LZNAQYShCkl/bqAUc959Zs0Tpj/cqJJAoC8q3T06Ig4T8/BJc5gV3WD2eQjrWpVQrg5taitWpYcMCFsM77UxfaP4J5eHOxTQLvjrnp9ZimZ7o4/EiFzkV8LODupklmyRBLI5F65f2e0Anpt1GkeZneXvzlj+QvSS0q4YzGt8bCb4WLgmi+6PpeLug96dQ8apwcO2nwlKDcG9AJJr8ywyHaNI7mDWKkowBi/HHUCoNdy/xN01GVuVi5DOzpaCwjIHEP/b9Czoyhmscie2OPHQLyR88r/vvHZGzphzOfV1R5pxJnGyI8xCQFa0+SqqQXIjXRZize5PXpof0+kbLzIohVa4M5CnZheU4Lz68uYvPnvTDXhZ0wFZaYs3s6/kQstdGcoFHPduSqvYGcazejgpYcPFdJFzMUqfxxwczU0BrCp/+dfWPp4BSemHQftSNhs0igITuIfg38u8XYmHDRoT6hYH7P7bKX3NGsMSt0OVZvnFMi3PDPzdEGZPC5RmmSoE2HNtwYged98m8b3K44XUoy4oqAQCsSZwg4wX6
 ndt4lHMW
 uYj5UWlViVau+qnhOWUSZFY56JNT3L3vIo+z7y81lwkdcdp2Qfn4G/W2D7irBhYk9ZTeM+vTuv2AtHKZeS9hFkmkF5ZgbUX1UBXHuvk5y3qlbiaNrdrx+iFUhmanO70a23YNndnI11KTOEy7R1p2bBQSUaRZ3TvLmtrVPm1DAEPaI8e9UnZ5T+K+4ov9Si6Xn0LMj0uEePbNbqjxUOD9BtN5cDeY2MeMjzI6qKrBrb3tFgq7HkARDhc81CCb3JtCnB15zk9zXpeeq6TaZnAN8ipS0QjbKItToXA5H0YGg0a2OKbklN5G5C0sEegAfGxTjhq04pWePmBQIdAuufaE4vuJc41Lbj7KvZ+pIA+hl2dfjUVUSXRHjIqLLALILUPGeiYOQ36ItwvGGfBKipV+TcCYMknnrTKwdLJ4cWDu9FkypSHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 9:18=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Oct 24, 2025 at 02:00:38AM +0800, Kairui Song wrote:
> > A few cleanups and a bugfix that are either suitable after the swap
> > table phase I or found during code review.
> >
> > Patch 1 is a bugfix and needs to be included in the stable branch,
> > the rest have no behavior change.
> >
> > ---
> > Changes in v2:
> > - Update commit message for patch 1, it's a sub-optimal fix and a bette=
r
> >   fix can be done later. [ Chris Li ]
> > - Fix a lock balance issue in patch 1. [ YoungJun Park ]
> > - Add a trivial cleanup patch to remove an unused argument,
> >   no behavior change.
> > - Update kernel doc.
> > - Fix minor issue with commit message [ Nhat Pham ]
> > - Link to v1: https://lore.kernel.org/r/20251007-swap-clean-after-swap-=
table-p1-v1-0-74860ef8ba74@tencent.com
> >
> > ---
> > Kairui Song (5):
> >       mm, swap: do not perform synchronous discard during allocation
>
> FYI For some reason this commit is not present on lore, see [0]
>
> [0]: https://lore.kernel.org/all/20251024-swap-clean-after-swap-table-p1-=
v2-0-a709469052e7@tencent.com/

Thanks for letting me know, strangely, it is here:
https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-1-c5b0=
e1092927@tencent.com

But the In-reply-to id is wrong. I'm using b4 and somehow patch 1 was
blocked by gmail's SMTP so I had to try to resend patch 1 again,
something went wrong with that part. I'll try to find out the problem
and avoid that from happening again.

I'm seeing that patch 1 is being merged into mm tree just fine, I
guess that should be OK.

If anyone is reading the threads, this url above should be helpful.

