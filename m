Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F0BC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 02:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98026B0005; Fri, 10 Jul 2026 22:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D495C6B0088; Fri, 10 Jul 2026 22:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10636B008A; Fri, 10 Jul 2026 22:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE146B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:02:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D329169649
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:02:55 +0000 (UTC)
X-FDA: 84974847510.30.C0EEBE3
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 218F61C0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:02:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bWKXOUI3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783735373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+weLnb8KdPntUVzwPjPo4Z9VV1QMV/GuWmAuaODD6gw=;
	b=gAWp81Pash+d3YE08GdBik7tHwRarVjBn30sg3n+EnI7P48ObZhhG18Skyyh6sNbpzwypl
	VU1VQzqqtQAXTQ2OSjobxF+IxHX76RtmPMovVZ4/8MC1bMLO0SPCwLGN29kgjLe1d00Z7u
	qNz/sI0XNnRvaG7Qtuc+j2FJXVNGzMA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bWKXOUI3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783735373;
	b=EgxW9r2IW4Fq1LU2+z2q9re3nRkymMmU7YJLrYDww4SzxKfauaqXAfknA/C56aVCBv3hCj
	Bu+w5BAJo3jO8nt0a9uQ6jrA3S2GbUPKQhN2NdaVnFLsyma1zvz9GZyqxOq3S2nrdCou8D
	8QNLpSeMUcEyLxGOHswmXPk9PkXcAfU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c10e86e52so64831cf.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:02:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783735372; cv=none;
        d=google.com; s=arc-20260327;
        b=Nhsi9dK8Yn0hlg6T2mREBYXKMg+ECGZ9/AJb6QzWaWQdFIJVWa/CBmpjJCdNyst22q
         OG3d/YKUYxXoeQiHYJGYAPKufrzdvVhWrPs8Q0p9aCn37KX4d8P/GrQL39/pMSbYUMbi
         Ee4utru63ABy3EZSiWTXpIvO2CELt0ZgvaJ2G8J7GI8Ewm4y7MN/Hcjs60M3craDk2dp
         tE6r9HP+VNwlyN767kArb4d6rvNfPtHHT8pbTDiMq0QxuOXbgW0/6xuFU9MhgktSyd5l
         El73HWSh0lgyj3eRTcYKCHE3dXii+jOv0/wbUZFqeBpo0IglPVF0NoQeHXUCWtRqTmJc
         EiyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+weLnb8KdPntUVzwPjPo4Z9VV1QMV/GuWmAuaODD6gw=;
        fh=c703Qju1mX8ewBnEpa975PJAGPbmG6PzySPebIPHsD8=;
        b=Qce8sFA7ZuKhImzB8RmXEfQkUxQxNYLrXjxmMnoWrOhPBXuIuJtxgkh9xTGqerLsV0
         xAXE5XmRjshaV09BTDdoCPwrk4W5UallarJKMYbBS8AbkmQB758Mtty8t6xbXKV03OAN
         cEptXRfjfA1FW+oqMhyAgplgqvAIixb1+bM51ZsAuCJuOao0qcW/C7ddEyZLF/hiA9kv
         eTeRHL0oy9yGqaTiryjg1ZOxDlFVO0RC6saOsn0/f2PWZ5yWtSPOWctREXSdJlmmSpFj
         3EgfHARCs+MoDvXqwXnZxsdzZWqKx7w8ZjlbHZdHBZ71+7SJhweQiyeo2bnHe+DymIOx
         4ksw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783735372; x=1784340172; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+weLnb8KdPntUVzwPjPo4Z9VV1QMV/GuWmAuaODD6gw=;
        b=bWKXOUI3ZsxYpYL0LniqyVQKKfbY5AyJDN0vcAxrFaeU1CPIY3HpOJ7xxc/laIUTsx
         he4/xZotjmifb88kMYaeHYd5wDhCBlnf74YWv6p7w7aP4DfassgYvOO2JUnOccD+Pozk
         Zj1CYtR5UGcrKqFU7D+pizhxyc2XMY4hgxe6kVloyDgU43TNlbZTusHj0usL/fBmd76A
         ZB76gISS5UWobYwTEiSRskt7per6suY41UrDWwYAAOHK1/ekjPc1jNMESqLXceA5yASq
         KXuKe0lPFohBf//4eX8a9r/Sx64SsMDQO5Gh/mzA0d+ArZDuJPiEgwxGQ4CU16oapeAE
         6fXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783735372; x=1784340172;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+weLnb8KdPntUVzwPjPo4Z9VV1QMV/GuWmAuaODD6gw=;
        b=EU/SHecksRLSIYGAJJuacUOa8tgY2M0ssdl/5IUUsjy606+ZtIrKvJlt9GcmZIM0fW
         4pEMiq5CLltIEwTOzMkO7UU70E8Jw5RHBMrRuNFlqqZ4w/feURJB+v+uvrz5B5l0ipPh
         RuwbKp+kyrwUoCXR7b2lq6zC2Iy6gv5QNBNsVnbkVuIFGiefZOq+lg8VtTY0Cz+Z60E8
         v9HyzTrcZB+kXmt5nk9cB/ca/DoV9UTb0/cWFGk7wpR0yMWfQ20JFOwcEpdSkTD9nulF
         PcvkCq8ThqfcsgahhXZWdhWG8D40AabSzaqWI+n2mQ4FkQa89uJ5JcVJJ2/9QCJRVlbS
         560g==
X-Forwarded-Encrypted: i=1; AHgh+RpyAVMO27QiHkeHjVWWCX5SBXqXgO6dqVWgb36W3qgV4qdWqehoQNoxf5nE1l5veXO+DcdhIKtoHg==@kvack.org
X-Gm-Message-State: AOJu0Yx9/oe41MYtkKHDDgUPJ4OKmaWzao1tBf2xKk7xB36gXifmsxZb
	vCtJY7gKZRmI3oAJPWJePuDCEg2nC+9BVPbEPtAqwqxnPv+HDPJDDXg+ml1sLC4KGJZ9jPLZ4IY
	fw20d/tQN3vfD1TYjaT8DfwNZCODkfLNS8uiaFRE1
X-Gm-Gg: AfdE7cmCuMkF19tJR44E4VT3QAM/hTdBM5mvwK57bANcdKW3eTcvcAXGHpAeoSyLTrP
	whGNUIEXpW8grAgctVYONO8fLXq10tWMUAuoSK4xwgdX7aiQqCv9jXgT0zhpVJkrPww7L3zN2B/
	eMzL3LyRLDfALLVLDysm8AeF6WXOuZIhVdtJMn8v06qAHvMT2Da0hEPhQW+vCxc/k43jzfP1Meg
	hZRTWrE7Mtqz6k0L+g97x9CpD6bZLjQop7ZLkJCYQFO+bwCYGYR++B9qVyu/xQRFcK5lu0=
X-Received: by 2002:ac8:5d06:0:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-51cc046efb0mr2409301cf.1.1783735371262; Fri, 10 Jul 2026
 19:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260626075019.1833065-1-zhanghongru@xiaomi.com>
 <ak0Xl6q52exX9sBH@lucifer> <CAJuCfpFqQc+XbkpOiFb9Xap3VME1BevndWi-XyVAVKAfGMhRNg@mail.gmail.com>
In-Reply-To: <CAJuCfpFqQc+XbkpOiFb9Xap3VME1BevndWi-XyVAVKAfGMhRNg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Jul 2026 19:02:39 -0700
X-Gm-Features: AUfX_mybwxuOMAfqpbP8FID_KEEJLZWW8hVPMFuTb1AK_i14UiZawZ2mD2Jl3hY
Message-ID: <CAJuCfpEvB5+gAbS-6QLr6koeNzuaUYbzQUR6xhQGNhf9u11HhA@mail.gmail.com>
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when
 mmap_lock is not required
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	mhocko@suse.com, baohua@kernel.org, shakeel.butt@linux.dev, 
	linux-kernel@vger.kernel.org, Hongru Zhang <zhanghongru@xiaomi.com>, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 218F61C0004
X-Stat-Signature: jcrgsb4pwjz6k6mwbibqckyr6dcfhhin
X-HE-Tag: 1783735372-521019
X-HE-Meta: U2FsdGVkX18+MfyCW8fzE9kqQpBWUPyRC66IAVJeTwCySAxEYG3lZK5sWrIFpbNJOrz4EZ4dhDXQgZ/bOz1T6FK7EHwmpMbXCmxs02pfcOXEy2qo4uNp0CXkh4ZF+P2jpEffV6j8cwv6bcY4PY69WlDzAn12P8azXktGWrD4bc/dwx9MxRKMviym37Y/ZVBS+zizy1qr/1ke+nOdRuqMp58lPJzTeV/O9+SLW5bs4NtArnIK0+eQeiP2xYaM1U+mVN+AdcdQdu6dNBKDcQPfwuoYpa5xt5d7Tkpz07ZHQ5d+fkJu1mUdueXauuE3uR08l1W+razHBc5x35uh14+Fzo7m4QJoOnoCMS0GV1yMcxBtqE29W7k4ety2SUpsnvHz+hoPeDTAAN8+/9h7hBGMEIsCuNGYjEsc9y7fl4WWkRgDnC5IJdeHCfFJ0/A6WFcURHqJB6QXLMOk1Mj8EdDUXLw8paobVyR1ZrUkm1Qb6TNjrzliPS7sWck+sV6BAXu09fArn0SOVwmGY0INrIpaK1pFlbjRuKLBziSkUiQIdTS9Y8OloBQcfakh//vsdImMGCQCCqr+r8sLvd8QIuG7YsfwRSlKPP35rU8FYdOXfYEUEglUwCIetPZNOcQ0tnbMtktLIODtIPFJH2K228yYEtyWb3H6Hx4lb8Qp/GApvv8W8FJTiR3VIKTh+qnj2//zDqAlCVheReAg/dKuCzyrqdjdkqrdf8/8VOOLc7YXTeNFhdqpdc/NN3hIRziSvi6jc7xuNwlkhasfmeOG4dkUF0ocYc4oBYRMAya2F5DnnzVc5zMVkLE8tcbUqj/g46xNxWUAMFFSrL9++zXvlH1M5NCxxWI/7qvOCPRk3E6kFHdPlQPBveTIIvt3FRCkTZWmlOg7lT+bKQkN8ELKGdMwLPET6z+9Q86A2Y5y6aHDBjPH8T7lRcZqed+0SDyMKo8Krcyk37a3Ku/HLMMsptj
 iDKrDNxc
 qlJUTq2kNaO5otSaa/z5B4cbDhqJBh9GIZO0/UMJQv0fnkqSt9O5WCgetSjrPYy1xPZ6xR1GR2+Igk0PlWM2TZTC4f+VVpElOU7/Zb/To/IETIqdeyKgXxXWXj5RAovTZoo0wo5uAabl/DCMRx4xi+o8CDKZJf/EH16oObadnYbrzQYbSx5XzZgP0eM8DOfrmGWGn41vKlulVTD/UvAhndFrFLaewfs/HRqTTctoMiSmuAkbnhiDW9A29N25J1itCGqqdKPPtLPCkjYwoJPDbK8tjwfXjxnllOTOFCkz6rmQcRvznD6JhzwRWQoC5ytIsw6FJ0Q+2AOJ7A4NRz4g3TXxMdwqMUOVERdSSaRQbIKYrB/72blyJDdUNHum0sugtwwVlb5Jp9OxKQJpoaw1AUtX0/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 7:54=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Jul 7, 2026 at 9:52=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
> >
> > +cc Vlata, the only one from the MEMORY MAPPING - LOCKING people exclud=
ed,
> > and Willy as he's been heavily involved. But see below you need to cc- =
way
> > more.
> >
> > (nitty I know) Maybe subject should be 'mm: default to VMA lock on
> > VM_FAULT_RETRY' or something just to make it clear it's about the retry
> > path?
> >
> > Also I guess you and Barry agreed to you taking this over? :)
> >
> > You missed a million people from cc- by the way. This time I really can=
not
> > be bothered to add them all as I usually do, but it is MANDATORY to cc
> > maintainers and really you should be cc'ing reviewers too every time.
> >
> > Again I feel I need to write a bot that just autoreplies about this :)
> >
> > $ scripts/get_maintainer.pl --nogit --nogit-fallback your-patch.patch
> > <... ~36 people in total ...>
> > < lists >
> > < etc. >
> >
> > Please fix this on respin.
> >
> > On Fri, Jun 26, 2026 at 03:50:19PM +0800, Hongru Zhang wrote:
> > > From: Hongru Zhang <zhanghongru@xiaomi.com>
> > >
> > > Currently, when a page fault returns VM_FAULT_RETRY under the per-VMA
> > > lock due to folio_lock() failing, mainly because the folio is under
> > > I/O, the architecture fault handler unconditionally falls back to
> > > retrying with mmap_lock. This leads to mmap_lock contention.
> > >
> > > This patch introduces VM_FAULT_RETRY_HARD to mark the paths that
> >
> > I'm going to have to bikeshed the name :)
> >
> > While I like the idea of 'retry hard' like the movie 'die hard' :P I th=
ink,
> > since this is explicitly about the mmap lock, we should reference that?
> >
> > So maybe VM_FAULT_RETRY_MMAP?
> >
> > or VM_FAULT_RETRY_HARDER_WITH_A_VENGEANCE? ;)
> >
> > > require mmap_lock. Retries now stay under the per-VMA lock by default=
,
> > > and only marked paths fall back to the mmap_lock retry path.
> >
> > I think the commit message should be much clearer about the logic here.
> >
> > You are making it such that VM_FAULT_RETRY does its retry pass using a =
VMA
> > lock, but it retains the same 'retry and set FAULT_FLAG_TRIED' logic as
> > before.
> >
> > HOWEVER.
> >
> > On the VMA lock path the retry flag is only set if VM_FAULT_MAJOR. So n=
ow
> > you're allowing _unbounded_ VMA lock attempts (which is concerning and =
I
> > don't think intended by the lock code).
> >
> > None of this is clear right now, you need to documment it.
> >
> > >
> > > Based on the stress model from Kunwu Chan and Wang Lian in v2, we
> > > adapted a benchmark for a 20-core desktop environment (reduced thread
> > > count, adjusted memcg limits, 20-core Intel i7-12700). The benchmark
> > > uses concurrent page faults under memcg pressure (forcing reclaim and
> > > VM_FAULT_RETRY) with parallel munmap to amplify mmap_lock read-write
> > > contention.
> > >
> > > Throughput (higher is better):
> > > +---------+------------+------------+-------------+
> > > | Threads |  Vanilla   |  Patched   | Improvement |
> > > +---------+------------+------------+-------------+
> > > |   40    | 1071.11 /s | 1301.11 /s |   +21.5%    |
> > > +---------+------------+------------+-------------+
> > > |   60    | 1043.15 /s | 1472.36 /s |   +41.1%    |
> > > +---------+------------+------------+-------------+
> > > |   80    | 1049.39 /s | 1665.65 /s |   +58.7%    |
> > > +---------+------------+------------+-------------+
> > >
> > > mmap_lock contention count (lower is better):
> > > +---------+-----------+---------+-----------+
> > > | Threads |  Vanilla  | Patched | Reduction |
> > > +---------+-----------+---------+-----------+
> > > |   40    | 3,217,904 |  51,201 |  -98.4%   |
> > > +---------+-----------+---------+-----------+
> > > |   60    | 4,419,149 |  55,711 |  -98.7%   |
> > > +---------+-----------+---------+-----------+
> > > |   80    | 5,395,730 |  66,184 |  -98.8%   |
> > > +---------+-----------+---------+-----------+
> >
> > Yeah I worry a bit about the unbounded nature of things here, the fact
> > we're seeing such a difference could also be offset by extreme busy wai=
ting
> > with the unbounded VMA lock retries.
> >
> > Let's experiment based on limiting this surely?
> >
> > >
> > > Benchmark and test scripts:
> > > https://gist.github.com/zhr250/c36c2c54d9351df37e12fd072d4926ef
> > >
> > > Suggested-by: Barry Song <baohua@kernel.org>
> > > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > > Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> > > ---
> > > Changes since v2:
> > > - v2 required each retry path to explicitly opt in to VMA lock retry
> > >   (VM_FAULT_RETRY_VMA). This patch inverts the logic: retries default
> > >   to VMA lock, and only paths requiring mmap_lock opt out
> > >   (VM_FAULT_RETRY_HARD)
> > > - This patch corresponds to v2 patch 1/5; the remaining optimizations
> > >   will be submitted separately
> > > - Rebased on mm-unstable
> > >
> > > Link to v2:
> > > https://lore.kernel.org/all/20260430040427.4672-1-baohua@kernel.org/
> > >
> > > Link to v1:
> > > https://lore.kernel.org/all/20251127011438.6918-1-21cnbao@gmail.com/
> >
> > Hmm it's a bit odd for you to send an independent series and link to
> > somebody else's series as v1/v2 but anyway as long as Barry and you agr=
ee
> > with that approach that's fine!
> >
> > >
> > >  arch/arm/mm/fault.c       | 4 ++++
> > >  arch/arm64/mm/fault.c     | 4 ++++
> > >  arch/loongarch/mm/fault.c | 4 ++++
> > >  arch/powerpc/mm/fault.c   | 4 ++++
> > >  arch/riscv/mm/fault.c     | 4 ++++
> > >  arch/s390/mm/fault.c      | 4 ++++
> > >  arch/x86/mm/fault.c       | 4 ++++
> > >  include/linux/mm_types.h  | 9 +++++----
> > >  mm/huge_memory.c          | 2 +-
> > >  mm/memory.c               | 6 +++---
> > >  10 files changed, 37 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> > > index e62cc4be5adf..2f909fb4f7db 100644
> > > --- a/arch/arm/mm/fault.c
> > > +++ b/arch/arm/mm/fault.c
> > > @@ -391,6 +391,7 @@ do_page_fault(unsigned long addr, unsigned int fs=
r, struct pt_regs *regs)
> > >       if (!(flags & FAULT_FLAG_USER))
> > >               goto lock_mmap;
> > >
> > > +retry_vma:
> > >       vma =3D lock_vma_under_rcu(mm, addr);
> > >       if (!vma)
> > >               goto lock_mmap;
> > > @@ -420,6 +421,9 @@ do_page_fault(unsigned long addr, unsigned int fs=
r, struct pt_regs *regs)
> > >                       goto no_context;
> > >               return 0;
> > >       }
> >
> > OK so this is really important - and it seems to be the case regardless=
 of
> > arch.
> >
> > When VM_FAULT_RETRY is encountered under the VMA lock, we do:
> >
> >         if (fault & VM_FAULT_MAJOR)
> >                 flags |=3D FAULT_FLAG_TRIED;
> >
> > Which then allows _under the mmap lock_ 2 more retries.
> >
> > You're now (silently!) going to:
> >
> >         if (!(fault & VM_FAULT_MAJOR))
> >                 /* unbounded infinite VMA lock retries */
> >
> > This seems very unwise (TM).
> >
> > We should bound this somehow. A maximum number of retries? Only do the
> > minor fault thing once?
> >
> > Could you benchmark how it looks at different retry counts? We could al=
so
> > consider other strategies, but unbounded attempts here seems not good.
> >
> > Another thing - is there any way to dedupe this code...? We're open cod=
ing
> > a lot of crap now in each of the arches and it's not good.
> >
> > A series like this is the place to fix stuff like that, not keep adding=
 to
> > the technical debt.
> >
> > Hongru - could you see if that's possible as preceeding patches please?
> >
> > > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > > +             goto retry_vma;
> >
> > Maybe it's worth being explicit that this is the VM_FAULT_RETRY path? O=
therwise
> > it's not so clear.
> >
> > You happen to only fall through here if VM_FAULT_RETRY is set.
> >
> > So e.g.:
> >
> > /**
> >  * fault_can_retry_vma_lock() - Are we able to retry a page fault holdi=
ng
> >  * only the VMA lock?
> >  * @fault: The fault to check.
> >  *
> >  * We default to performing the VM_FAULT_RETRY/FAULT_FLAG_TRIED dance u=
nder
> >  * VMA lock. This allows us to avoid mmap contention on the likely case
> >  * that we encountered an ephemeral inability to VMA lock (e.g. the VMA=
 was
> >  * write locked at the time).
> >  *
> >  * Returns: true if we can retry under the VMA lock, false otherwise.
> >  */
> > static bool fault_can_retry_vma_lock(vm_fault_t fault)
> > {
> >         VM_WARN_ON_ONCE(!(fault & VM_FAULT_RETRY));
> >
> >         return fault & VM_FAULT_RETRY_HARD;
> > }
> >
> > And put that somewhere all the arch fault logic can access.
> >
> > Then:
> >
> >         if (fault_can_retry_vma_lock(fault))
> >                 goto retry_vma;
> >
> > Is self-documenting, and the assert assures that no mistake was made wi=
th
> > it.
> >
> > Same comments for all the arches, obviously.
> >
> > > +
> > >  lock_mmap:
> > >
> > >  retry:
> > > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > > index 739800835920..695a09486795 100644
> > > --- a/arch/arm64/mm/fault.c
> > > +++ b/arch/arm64/mm/fault.c
> > > @@ -673,6 +673,7 @@ static int __kprobes do_page_fault(unsigned long =
far, unsigned long esr,
> > >       if (!(mm_flags & FAULT_FLAG_USER))
> > >               goto lock_mmap;
> > >
> > > +retry_vma:
> > >       vma =3D lock_vma_under_rcu(mm, addr);
> > >       if (!vma)
> > >               goto lock_mmap;
> > > @@ -719,6 +720,9 @@ static int __kprobes do_page_fault(unsigned long =
far, unsigned long esr,
> > >                       goto no_context;
> > >               return 0;
> > >       }
> > > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > > +             goto retry_vma;
> > > +
> > >  lock_mmap:
> > >
> > >  retry:
> > > diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
> > > index 2c93d33356e5..d7dd55722e52 100644
> > > --- a/arch/loongarch/mm/fault.c
> > > +++ b/arch/loongarch/mm/fault.c
> > > @@ -219,6 +219,7 @@ static void __kprobes __do_page_fault(struct pt_r=
egs *regs,
> > >       if (!(flags & FAULT_FLAG_USER))
> > >               goto lock_mmap;
> > >
> > > +retry_vma:
> > >       vma =3D lock_vma_under_rcu(mm, address);
> > >       if (!vma)
> > >               goto lock_mmap;
> > > @@ -265,6 +266,9 @@ static void __kprobes __do_page_fault(struct pt_r=
egs *regs,
> > >                       no_context(regs, write, address);
> > >               return;
> > >       }
> > > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > > +             goto retry_vma;
> > > +
> > >  lock_mmap:
> > >
> > >  retry:
> > > diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> > > index 806c74e0d5ab..65ec9a8252e7 100644
> > > --- a/arch/powerpc/mm/fault.c
> > > +++ b/arch/powerpc/mm/fault.c
> > > @@ -487,6 +487,7 @@ static int ___do_page_fault(struct pt_regs *regs,=
 unsigned long address,
> > >       if (!(flags & FAULT_FLAG_USER))
> > >               goto lock_mmap;
> > >
> > > +retry_vma:
> > >       vma =3D lock_vma_under_rcu(mm, address);
> > >       if (!vma)
> > >               goto lock_mmap;
> > > @@ -517,6 +518,9 @@ static int ___do_page_fault(struct pt_regs *regs,=
 unsigned long address,
> > >       if (fault_signal_pending(fault, regs))
> > >               return user_mode(regs) ? 0 : SIGBUS;
> > >
> > > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > > +             goto retry_vma;
> > > +
> > >  lock_mmap:
> > >
> > >       /* When running in the kernel we expect faults to occur only to
> > > diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
> > > index 04ed6f8acae4..6c68414a1224 100644
> > > --- a/arch/riscv/mm/fault.c
> > > +++ b/arch/riscv/mm/fault.c
> > > @@ -347,6 +347,7 @@ void handle_page_fault(struct pt_regs *regs)
> > >       if (!(flags & FAULT_FLAG_USER))
> > >               goto lock_mmap;
> > >
> > > +retry_vma:
> > >       vma =3D lock_vma_under_rcu(mm, addr);
> > >       if (!vma)
> > >               goto lock_mmap;
> > > @@ -376,6 +377,9 @@ void handle_page_fault(struct pt_regs *regs)
> > >                       no_context(regs, addr);
> > >               return;
> > >       }
> > > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > > +             goto retry_vma;
> > > +
> > >  lock_mmap:
> > >
> > >  retry:
> > > diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> > > index 028aeb9c48d6..45a6c35044cc 100644
> > > --- a/arch/s390/mm/fault.c
> > > +++ b/arch/s390/mm/fault.c
> > > @@ -294,6 +294,7 @@ static void do_exception(struct pt_regs *regs, in=
t access)
> > >               flags |=3D FAULT_FLAG_WRITE;
> > >       if (!(flags & FAULT_FLAG_USER))
> > >               goto lock_mmap;
> > > +retry_vma:
> > >       vma =3D lock_vma_under_rcu(mm, address);
> > >       if (!vma)
> > >               goto lock_mmap;
> > > @@ -318,6 +319,9 @@ static void do_exception(struct pt_regs *regs, in=
t access)
> > >                       handle_fault_error_nolock(regs, 0);
> > >               return;
> > >       }
> > > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > > +             goto retry_vma;
> > > +
> > >  lock_mmap:
> > >  retry:
> > >       vma =3D lock_mm_and_find_vma(mm, address, regs);
> > > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > > index 63de8e8684f2..cb80070271d0 100644
> > > --- a/arch/x86/mm/fault.c
> > > +++ b/arch/x86/mm/fault.c
> > > @@ -1322,6 +1322,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> > >       if (!(flags & FAULT_FLAG_USER))
> > >               goto lock_mmap;
> > >
> > > +retry_vma:
> > >       vma =3D lock_vma_under_rcu(mm, address);
> > >       if (!vma)
> > >               goto lock_mmap;
> > > @@ -1351,6 +1352,9 @@ void do_user_addr_fault(struct pt_regs *regs,
> > >                                                ARCH_DEFAULT_PKEY);
> > >               return;
> > >       }
> > > +     if (!(fault & VM_FAULT_RETRY_HARD))
> > > +             goto retry_vma;
> > > +
> > >  lock_mmap:
> > >
> > >  retry:
> > > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > > index 5ef78617ce93..58db6f0af6fd 100644
> > > --- a/include/linux/mm_types.h
> > > +++ b/include/linux/mm_types.h
> >
> > Please also update the comment block to add the new flag.
> >
> > > @@ -1665,10 +1665,11 @@ enum vm_fault_reason {
> > >       VM_FAULT_NOPAGE         =3D (__force vm_fault_t)0x000100,
> > >       VM_FAULT_LOCKED         =3D (__force vm_fault_t)0x000200,
> > >       VM_FAULT_RETRY          =3D (__force vm_fault_t)0x000400,
> > > -     VM_FAULT_FALLBACK       =3D (__force vm_fault_t)0x000800,
> > > -     VM_FAULT_DONE_COW       =3D (__force vm_fault_t)0x001000,
> > > -     VM_FAULT_NEEDDSYNC      =3D (__force vm_fault_t)0x002000,
> > > -     VM_FAULT_COMPLETED      =3D (__force vm_fault_t)0x004000,
> > > +     VM_FAULT_RETRY_HARD     =3D (__force vm_fault_t)0x000800,
> > > +     VM_FAULT_FALLBACK       =3D (__force vm_fault_t)0x001000,
> > > +     VM_FAULT_DONE_COW       =3D (__force vm_fault_t)0x002000,
> > > +     VM_FAULT_NEEDDSYNC      =3D (__force vm_fault_t)0x004000,
> > > +     VM_FAULT_COMPLETED      =3D (__force vm_fault_t)0x008000,
> >
> > Hmm I suppose there's no harm in renumbering here to keep the retries
> > together :)
> >
> > I wonder if we shouldn't invert this VM_FAULT_RETRY | VM_FAULT_RETRY_HA=
RD
> > thing though and instead have:
> >
> > #define VM_FAULT_RETRY_MASK (VM_FAULT_RETRY | VM_FAULT_RETRY_MMAP)
> >
> > And convert code that checks VM_FAULT_RETRY to check VM_FAULT_RETRY_MAS=
K
> > instead, then there'd be no need for an awkward check/or confusion arou=
nd
> > the need for VM_FAULT_RETRY to always be set in both cases.
> >
> > You're already basically touching all the files that reference
> > VM_FAULT_RETRY so it's not actually much more churn.
> >
> > >       VM_FAULT_HINDEX_MASK    =3D (__force vm_fault_t)0x0f0000,
> > >  };
> > >
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 94bd656eeaf8..ad0129d579bc 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -1398,7 +1398,7 @@ vm_fault_t do_huge_pmd_device_private(struct vm=
_fault *vmf)
> > >
> > >       if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> > >               vma_end_read(vma);
> > > -             return VM_FAULT_RETRY;
> > > +             return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
> >
> > Why are we specifically wanting this for PMD device private entries?
> >
> > You should add a comment, and the commit message should say why.
> >
> > Actually, maybe in this common case of vmf->flags & FAULT_FLAG_VMA_LOCK=
 ->
> > harder you can make a helper?
> >
> > Like:
> >
> > /** blahhhh some kdoc comment */
> > static vm_fault_t retry_under_mmap_if_vma_locked(struct vm_fault *vmf)
> > {
> >         if (!(vmf->flags & FAULT_FLAG_VMA_LOCK))
> >                 return 0;
> >
> >         vma_end_read(vma);
> >         return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
> > }
> >
> > And:
> >
> >         vm_fault_t ret;
> >
> >         ret =3D retry_under_mmap_if_vma_locked(vmf);
> >         if (ret)
> >                 return ret;
> >
> > Or something like this.
> >
> > >       }
> > >
> > >       ptl =3D pmd_lock(vma->vm_mm, vmf->pmd);
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index ff338c2abe92..7f2a30b5efca 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -3797,7 +3797,7 @@ static inline vm_fault_t vmf_can_call_fault(con=
st struct vm_fault *vmf)
> > >       if (vma->vm_ops->map_pages || !(vmf->flags & FAULT_FLAG_VMA_LOC=
K))
> > >               return 0;
> > >       vma_end_read(vma);
> > > -     return VM_FAULT_RETRY;
> > > +     return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
> >
> > You could use my helper like above.
> >
> > >  }
> > >
> > >  /**
> > > @@ -3824,7 +3824,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *=
vmf)
> > >               return 0;
> > >       if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> > >               if (!mmap_read_trylock(vma->vm_mm))
> > > -                     return VM_FAULT_RETRY;
> > > +                     return VM_FAULT_RETRY | VM_FAULT_RETRY_HARD;
> >
> > This really makes me think VM_FAULT_RETRY_MMAP or something explicit wo=
uld
> > be better, otherwise you have to add a comment explaining you're doing =
this
> > because you need the mmap read lock here since the VMA lock + speculati=
ve
> > mmap read lock acquisition didn't work out.
> >
> > >       }
> > >       if (__anon_vma_prepare(vma))
> > >               ret =3D VM_FAULT_OOM;
> > > @@ -4778,7 +4778,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >                                * under VMA lock.
> > >                                */
> > >                               vma_end_read(vma);
> > > -                             ret =3D VM_FAULT_RETRY;
> > > +                             ret =3D VM_FAULT_RETRY | VM_FAULT_RETRY=
_HARD;
> >
> > Again, helper above self-documents.
> >
> > >                               goto out;
> > >                       }
> > >
> > >
> > > base-commit: 81652c5a65d4ae28e9b18c16ef917a40025c3653
> > > --
> > > 2.43.0
> > >
> >
> > Have you audited every single VM_FAULT_RETRY case? Because getting this
> > wrong could be a serious problem and break things. You should include a
> > list of call sites in your patch and explain why it's fine in each case=
.
>
> That's my main worry with this patch as well. I think a better
> approach would keep VM_FAULT_RETRY as is (falling back to mmap_lock),
> introduce VM_FAULT_RETRY_VMA (or whatever is best to indicate a retry
> with VMA lock) and then convert individual VM_FAULT_RETRY cases to
> VM_FAULT_RETRY_VMA with proper reasoning and explanation why it is
> safe. Less churn, gradual conversion, and happy reviewers.
>
> >
> > One case I noticed is uffd:
> >
> >         ret =3D VM_FAULT_RETRY;
> >         ...
> >         if (unlikely(READ_ONCE(ctx->released))) {
> >                 /*
> >                  * If a concurrent release is detected, do not return
> >                  * VM_FAULT_SIGBUS or VM_FAULT_NOPAGE, but instead alwa=
ys
> >                  * return VM_FAULT_RETRY with lock released proactively=
.
> > .       ...
> >                  * If we were to return VM_FAULT_NOPAGE, it would work =
for
> >                  * the fault path, in which the lock will be released
> >                  * later.  However for GUP, faultin_page() does nothing
> >                  * special on NOPAGE, so GUP would spin retrying withou=
t
> >                  * releasing the mmap read lock, causing possible livel=
ock.
> >                  *
> >                  * Here only VM_FAULT_RETRY would make sure the mmap lo=
ck
> >                  * be released immediately, so that the thread concurre=
ntly
> >                  * releasing the userfault would always make progress.
> >                  */
> >                  release_fault_lock(vmf);
> >                  goto out;
> >         }
> >
> > The comment needs updating (Suren?) to reflect the VMA lock, basically =
with
> > VMA lock held this is meaningless.
>
> Right, I missed it when enabling per-VMA locks for userfaultfd faults
> in [1]. The comment is true if we already fell back to mmap_lock but
> not if we are handling the fault under VMA lock. I should amend it.
>
> [1] https://lore.kernel.org/all/20230630211957.1341547-1-surenb@google.co=
m/
>
> >
> > We're actually safe here in general as if the VMA lock is contended on =
a
> > competing write lock we drop to mmap lock.
> >
> > A racing uffd release thread does an unconditional vma_start_write()
> > _after_ setting ctx->released:
> >
> > static int userfaultfd_release(struct inode *inode, struct file *file)
> > {
> >         ...
> >         WRITE_ONCE(ctx->released, true);
> >         userfaultfd_release_all(mm, ctx);
> >         ...
> > }
> >
> > userfaultfd_release_all()
> > <mmap write lock>
> > -> userfaultfd_clear_vma()
> > -> vma_modify_flags_uffd()
> > -> vma_modify()
> > -> vma_merge_existing_range()   -> vma_start_write() LIVELOCK
> > OR split_vma() -> __split_vma() -> vma_start_write() LIVELOCK
> >
> > So yeah, not sure on this one, maybe we're fine just to use VMA lock st=
ill?
> >
> > Suren - any thoughts?
>
> If we retry without falling back to mmap_lock then
> userfaultfd_release() can end up write-locking mmap_lock but losing
> the race for VMA lock to the retrying pagefault handler. This means it
> would block while holding mmap_lock for write - not good.

I was thinking more about this... Writer blocking on a VMA write lock
while holding write side of the mmap_lock is what all VMA modifyers
do, so userfaultfd_release() doing that should be fine. As long as the
usual locking order of taking mmap_lock first then locking VMA is
followed, we should be ok.

> With pagefault handler falling back to mmap_lock, either
> userfaultfd_release() wins the race for mmap_lock or pagefault
> handler, so I think we are safe.
>
> >
> > You definitely need to explain your reasoning in the commit message at
> > least.
> >
> > Also commit 29a22b9e08d7 ("mm: handle userfaults under VMA lock") did f=
ail
> > to update this comment to reflect VMA locks - we should fix that too -
> > Suren? :)
>
> Yes, I will correct my mistake and send a small fixup.
>
> >
> >
> > Also another thought - should we allow FAULT_FLAG_RETRY_NOWAIT to retry
> > with the VMA lock? As this could also be some unbounded spinning? But t=
hen
> > again, if we bound the spinning that might be ok.
>
> Hmm. If we do that, let's make it a separate series. Too many moving
> parts is never a good idea.
>
> >
> > Thanks, Lorenzo

