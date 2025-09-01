Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A201CCA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 18:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F4A6B000D; Mon,  1 Sep 2025 14:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FB48E0003; Mon,  1 Sep 2025 14:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41438E0001; Mon,  1 Sep 2025 14:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEEC66B000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:18:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 630E4C099C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:18:07 +0000 (UTC)
X-FDA: 83841490614.25.DDE384B
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85AB9160014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:18:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QEUxiZKo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756750685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71e9jxNAdOB08SDwtASl6UkqHHprrjxNIXBMKywL7Pc=;
	b=wpBbjkY0zJuie4KJlwVt9RBHYa6FZQJgirUCSfObdcDHZvOzT0VDxwZrYybgpocW1uCJ8g
	10DS9x/Mgve6cAPdaHR+sFM8EGSt/aQAFvqv+e8wD01ttyQGmvFPDEqnM8R8XoEZccLghi
	21FN9crRPzyxvg9pqEA/xbTHqW80v2c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QEUxiZKo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756750685; a=rsa-sha256;
	cv=none;
	b=HmQjakiIwYYbj5T79qgKSlUM5D2NW5etinFsHX+gis+zjCd82BTRLVr3Adv7MtkL7l/PEd
	znfmLFpyAVL8VRD8+VV2S722HULkOX0rOugbEIyfc9kqqfaJxMVma4yaBY5hgkDVlTQWjP
	XVl5BJpowbKotN6nFNnJ0rpF/UPDv7s=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aff0775410eso441024166b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 11:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756750684; x=1757355484; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71e9jxNAdOB08SDwtASl6UkqHHprrjxNIXBMKywL7Pc=;
        b=QEUxiZKosVG6sPYee3XMvr+Wv6SYgdcJiJSbEwnLs3p7mIF2hJzZAT6+SglXmpDx5p
         EDE5zzJddJ8Baqm9/yzwjQdYz5su4cX8FTfpN3JClxmyHA8k8FVXpPtNe6iYkJM441Mm
         f2/0rBWXyNVK59NsxT95AdD+5QCeZVjjj+/uWW9Hzgv+4893D7wuoCODKBuOP+8Sr9LF
         CPhw5K9vgpsGhVY1bk7o/qa7a7WoFr0M8koYqtmgGNOsIqsTG60g/V8Y07V1SvgADUzo
         sbTctezHKITe1cUD41ffyVTztlQ1kSNb6CWPfszFmuj3XaYXejbeB30fHkXy1+gRXX/B
         rg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756750684; x=1757355484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71e9jxNAdOB08SDwtASl6UkqHHprrjxNIXBMKywL7Pc=;
        b=qMY/XYFQ9ASkoLKaTa/RIfiXeX8DGWZZGNSp6sYzXCWhBmJJou1uOdIzDj5JIBkk2P
         b9ircojUb5crlt7rg7+gIKKjG6WGizfP7dxbsUW5ETIftpEKaxkHzKQ67v8LzqjdJJHX
         NeEbs1L7IOQTX1dDHFSc38eZhPQ/nS9gMIaMsvG/lXlWsM5CQDR8FKjS4Hy9eEi7D5Mf
         /KYWByIqrf7hzMUFDVZSex52hJD05IIT+fiq2+iK9ndx9ORHh6ThlcgBDW7fZ/i1yejn
         Bgde0ghDvnf1IcQ5sWsGgNhqgtQTq5vEp+u1l7wPTfAQ5g2eBuWT3wSehmBN4uDWiffb
         s6hA==
X-Gm-Message-State: AOJu0YzlGOnozZMmLXnjGt0C3tGDqNIkvVrIeLn3fzQ4zbdVJ56jn+mY
	jtXzPMUhQ4IX85ux6aBDQru2I580p4KEuDj3FLqwbyHs1/kQowzbnJiH9eqTvGxbmNKIOsA+9GP
	LPDSJvOV70obKsy9tKLEhcum8Kw3XKFc=
X-Gm-Gg: ASbGncsedXxRdvx36dnK6qtcpLMyaHRPLYAo/QBz3K0L8LjyjJzrMUZYv5iqGXKqfZp
	rWkd8/HKVwnRZiA+l8BjwYjUQsCrq0yRqPbyqLR9FL4LpmEkt51hvFpms4dMpQe6/Ou1vD/YAcn
	FO3rhNXxPtM5ffOeQbzsR4n1nqellyHlbLECzxsvDyywQuaVwED4yQR3Rame9gJGDJwT9ILNOko
	2PjEXKfYtw=
X-Google-Smtp-Source: AGHT+IHJbkBsvrU+7fOx7ErEa9lY9xRfRzo/H4E1Bt00rA4Vj+AuHAMEyjR/VP1EYIJblFFP3VE5gLCVpcPSPD1Nfak=
X-Received: by 2002:a17:907:6096:b0:b04:3b97:f972 with SMTP id
 a640c23a62f3a-b043b980cb7mr326658366b.3.1756750683635; Mon, 01 Sep 2025
 11:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
 <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com> <CACePvbWnsrGxUv15R4kMpc10wsBE2Bc-rapGyBYjekrqFJgJbw@mail.gmail.com>
In-Reply-To: <CACePvbWnsrGxUv15R4kMpc10wsBE2Bc-rapGyBYjekrqFJgJbw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Sep 2025 02:17:26 +0800
X-Gm-Features: Ac12FXyoPo1ppk3ETOoVUD0hcfsBLMqtHEJk2Q71pbsaNPHE5LxHxuxlF_aulQI
Message-ID: <CAMgjq7AT79NfcKtsfgOi6LQJViXOz-Xs5LOUmOiJYJS-DwQg=A@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 85AB9160014
X-Stat-Signature: fzpf8ozmsqhozahgo4muqyqrj878sg5h
X-Rspam-User: 
X-HE-Tag: 1756750685-759200
X-HE-Meta: U2FsdGVkX1/kgKzZWQP8aY9SVnXbPiXDbdDjXFQ3DFMgyKn5RniNyf1+euO9rGhpWYRNtFXVLLFefcYIilBCoJAEPpylaJZXG8ZUFWi843O+F2NRnES2TdiDzFbStwiMU/PyowtCGFVVJr9YdtNflWsUycMdLJAtL/+cWGecbP+W0DjvSLfa+MgVGB21pWmYUxY2nt8Ingw1WZGAlyaR1YBWCHDUGmv9IkpwIHHdOxK0BXmLO5BInQZGhOTqXuCPfGKFy3O+e++BS2xMvVUpInMygsQrFlmN0QyNHtRLbPbE4Mah6UG6FvQXhfBwT6ueuNxnNjCQKyIGiZpcNAukQuVhDVM4OdQo9Z5CrJxL49+K06WrvnMmKowkGQuAcUy5EicLju+ruNJUgb+Kiq20vm4WhSGPRYrfnmG8Fsd2I42f0iS4PC5L4kY1vFKObByyaXQYxV5UgY1thZAr5oi9/iC3vQ382OIvN5HaURNaEvJnrRgsN0FRPnw1L3yBSRHiEMU/eG1hey8wAQoh+U2UxaX1WQwCmUEnhsBa2ns1GYdBpHCAhPcNwLqmUfGK6Axb+UnO9hanvPPmIJANZwE1nDdfI0BDLySBw8WnQ8USp4sfodFrub1J/BdpoJfPTKTbZvb0Sq5ckdil6R6//DranW6or7H16XGXayM8o+g9Vd2yyh353RHEYyfTfLEUPstUTJpTYXKHWWB/NHaAbb4GSG0RKPvTN7RD7aKM6FIaBIh3tiEQ8vf241X1WFc8tLLTYgVhTzKdXpfSbQ/Uq53jpCeKdUX4cpq8kkdDuqzNDoE32A8Qwxyi75S0Xg5/G+J51C44o7I69PlR8Oi4ZC7TILOuWIAzo+prSZ0QzCLuTtvu0yKmsNfWcKEQ93GMmRqQTzwboooejlTfjO8ZX8mVURTr1UMudkfm477mT/J1OsM9q8MTH+/PCDnmpsNDwhiAcGol/j54daANWnI1uu/
 aKhItnMB
 OJrJmIaZ3Zo+AVwQev0FLnToIJK56DGDaxuBO5c8LlSe/gr/k5eQoh6BwNTO3QRC7iDkianBEHrslS8SqUMPDRteRuQ6bK/wdE7HzZkTXN2HXPdHu9b7Evmq8z1oNYxdvdfk2TH9j/C0HOGW4qNuK7uZ0cW60u9i6lP1/hJ37nHadYsUDO03HFwxm3+cbGUsn+Jv0FAhyUzeyqkke36ZfLjeztIH9PA1W0I/Tsv/y1LuosI5WrM/7llExvMM1IjnQPFwnut/1QuZN4TmtklmF2lQAVF7+f9OPgFLvZW7ti2DDpourKoIP+xuEROP16OwvOpLTDdpsctGht31RUhZ0icgIOtDe2zuCAinG9dFUprfeHJwn0rUjl++/X+EzDpvUUz00Nzt00Tx4M1VN+xV/qlgavg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 9:54=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Wed, Aug 27, 2025 at 7:36=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Wed, Aug 27, 2025 at 4:21=E2=80=AFPM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > > On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.co=
m> wrote:
> > >
> > > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > > index e9d0d2784cd5..b4d39f2a1e0a 100644
> > > > --- a/mm/shmem.c
> > > > +++ b/mm/shmem.c
> > > > @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *i=
node, pgoff_t index,
> > > >                         count_vm_event(PGMAJFAULT);
> > > >                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
> > > >                 }
> > > > -       } else {
> > > > -               swap_update_readahead(folio, NULL, 0);
> > >
> > > Also this update readahead move to later might have a similar problem=
.
> > > All the bail out in the move will lose the readahead status update.
> > >
> > > The readahead deed is already done. Missing the status update seems
> > > incorrect.
> >
> > Thanks for the detailed review.
> >
> > The only change I wanted here is that swap readahead update should be
> > done after checking the folio still corresponds to the swap entry
> > triggering the swapin. That should have slight to none effect compared
> > to before considering the extremely tiny time window. We are only
> > following the convention more strictly.
> >
> > In theory it might even help to reduce false updates: if the folio no
> > longer corresponds to the swap entry, we are hitting an unrelated
> > folio, doing a readahead update will either mislead vma readahead's
> > address hint, or could clean up the readahead flag of an unrelated
> > folio without actually using it. If the folio does get hit in the
> > future, due to the missing readahead flag, the statistic will go
> > wrong.
>
> So the missing readahead stats update behavior is the correct and
> better behavior. I suggest you spit that out as a separate patch with
> appropriate comments about it too. It is also easier to bisect the
> commit if that kind of the subtle change which is considered safe
> turns out causing a problem. Causing problem not happen very often but
> it does happen before.
>

Hmm, after a second thought, maybe we should keep it as it is for now.

I just realized moving the swap_update_readahead after folio_lock is
more than just ensuring the folio is still valid. It will also cause
every swapin to do a readahead update. Previously, only cache hit
swapin will do a swap readahead update.

I did some tests, and didn't see any measurable performance difference
between putting it before / after the folio_lock. But changing it for
no good reason seems not a good idea after all.

So I think I'll keep it before the folio_lock. There is no evidence of
which strategy is better, just keep the current behaviour.

Calling swap_update_readahead even if the swap cache folio
is already invalidated is not really harmful, the only thing it does
that may effect the folio is the folio_test_clear_readahead call in
it, and we have been doing for years with no problem. Calling
swap_update_readahead for every folio might not be a good idea.

