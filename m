Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA3BCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 04:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6188E001D; Wed, 20 Aug 2025 00:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE508E0011; Wed, 20 Aug 2025 00:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A258E001D; Wed, 20 Aug 2025 00:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 707BD8E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:49:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B32CAB8D4A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:49:36 +0000 (UTC)
X-FDA: 83795907552.06.272F164
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AFF08140004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:49:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QOrzfHuo;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755665374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhAj4XXy0tM9jv1kyPq+fVO2FoKk8jyT12ucKiLnDhc=;
	b=tALK3hKEzp1/fBlH5rEWkcdv8l2+YbHNJUFH07U7oNBXK+e0xOgnSv88OpxwjIRvjhAg4C
	W2sfzEUySZlyHTr3+8eL3B16bb+e7YutSgGRa0VTU9jqC9oWVBJw7QS6PM+OU0ZBul8UKX
	y7cUkt5frq9XHdP6sHfwOxnwC4XyiWU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QOrzfHuo;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755665374; a=rsa-sha256;
	cv=none;
	b=bpK7d1OeHRtByuUwEasvp/+f6Qp1wvQxZTUOBBirJk8Z8j013t8TJHIceUlKtw5cK72jq6
	pWZYPiJWab79t0/5C2sT916EwMvYUrODS9VYycw6xOtBUziXDjBkgZdF9llAQRw7m16cUl
	ba9Dc+wMEV+L3Eq7U45tmzpwJQUCdZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4BBF61432
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C128C4CEEB
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755665373;
	bh=P4OZPdJzjtMd9WS2zQ1ChyG8f5e6hQg5Pc1tc9hQJyc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QOrzfHuoxKtlOSwqlv+bO5TZbkjL2fOmmPykviKXKLcMVLJVK0QmzaMreKsN1Ui/O
	 ULwduBlATxd9LryNI8x+8m8CyXz/oIp7mgygYXkSKHYHldCEAtXrTnM6CHCQ58/8Yg
	 tyr75d4llJJHTyKuPHSxVaY3B2bEK/Z6Lxx8kxXGzZVzXvcOzKK5AjrsoJ+97Wr3RG
	 pbWLl58UzaeF3qFyH1LNpaeQE0drthQn3jobMhx8kpIPvMvSyesCQgECwthMSBL9VZ
	 uDTPXMks2eCxc2DCjXhB4azIWM4ju7nnOzQnS1EdxNsxQIs/h4G+m8Wk1byHemQJyk
	 svCGGgderZCwQ==
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so27955e9.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:49:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVQA4NQ8M0sR4Jok5buRY5zYCQE+NSunx2RdEsIxy3txOt9+5Y8fg3s2rjSc+wpqUec42kpONLECQ==@kvack.org
X-Gm-Message-State: AOJu0YzyN78TdLb038YwN0YaNlOIPtK8ZK1tAuJgZDCUYKOSPqxEsZN4
	WhyqGG7NrmyEHMOtdXk/7T2/MXz2wVNdo1/qMtk8nggR6BvciDusWqjyBMp9pen1lZRCgtFDN7i
	8whe/t6TuNS81F5qFXYSu6MX0eghdvLg5SClYzNxg
X-Google-Smtp-Source: AGHT+IFCBaA1civFtdIb6102WgW1wwKDHrQ40ZAiA8MIqsnpCc72+2FUaZhCf8KxfJEP3xFxhcGRE4HbOsCbAWY3ri0=
X-Received: by 2002:a05:600c:c106:b0:459:efb0:6687 with SMTP id
 5b1f17b1804b1-45b4777c108mr750575e9.6.1755665372081; Tue, 19 Aug 2025
 21:49:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org> <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
In-Reply-To: <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 19 Aug 2025 21:49:20 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPNjZc39xHx4NEiymzO29HkLfk9dFYXSu1vZ3tu9VeDvA@mail.gmail.com>
X-Gm-Features: Ac12FXwEsBGmmhpKRLWis8jHILZsWH0UuSzOgykLKT2AqKDYJihra3lilyoboK4
Message-ID: <CAF8kJuPNjZc39xHx4NEiymzO29HkLfk9dFYXSu1vZ3tu9VeDvA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Barry Song <21cnbao@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AFF08140004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fss9poje9tds6gqwas3ejaj89bmooyxg
X-HE-Tag: 1755665374-670799
X-HE-Meta: U2FsdGVkX18wLjy1D089wC7hC1VC0JSUYKFgCVJCaPOptPssGN2qEQ1MDY5zjsNzKKQogmW/1QjIK/9kyKtasOsNLwelQH5gL0RQ68v6O8zbwJ0XDSvpc37c/CDD8jF2rPc0lHW7oHgzXtz2MmaPpGfjEEl9Z7lP7+CplJV7vDgSbhvkudj5CKAafKzP9XraCyGQ/I2h2fFkIW9DOdKMsPP/5PhZqSmzJyDHqqTRuiR8SPMAuqgD1k6A2IElcHDBFwXg6tkxkfEqqnv5dMHFZHGkslZ3smIcYOMK0akyB+bIw7eKSPqVqeVyk/NzNX2GXMyPuAnkY+4NyXWl3FJ9shHUy89vH7zanv1J08KAuAvp8twWnjgFiQxrj/tmw37Is3MU4J74Zjyg7vNUB1sSzxpc9y5LHiRlwpxIPyUnRIHvko2fZbQ5WZ298ub6PNoj7tR/uMUMfPiZCFTJYZg2gidMX9amXVSaCxMZExZDKpNUQimairlU0RfuDJkDVgmv5ExQdSzBq1p7EZ+cWklijhzfberH3Xo/VpHBCcObeC33AlovTHvYPniYbN9Sh1Zwq8xnL/S0YDapJJ+k8r8UNHmpfJCURPzt5/tD5AHSPtyeOeh3x7JCe+BUGgKaer4ImJq1rhFsRmt9twoTZGQJ29BwZRZa3Bmpt5LsYvMXYwyw+93Y2Y40ai0wInrtDfCtT/ZxeSjUCB341/cf0vjrp1lzdYTZr9xHtqSkkEV2pZxQVGSLq7Z12tm8131/DveCJPMgKavdzOxLR9+OuBVV4HclLaHHb/xFrFzmN5F8rPnd6oz9Qk/S1KbfMOslFIqyJesHyyi/QXA7fOQ5is51zEjyLF/IpZDltTfd3MfrOEo3lPX0Yt4xRNQgqdM6BNFC9wzY2bSMhZHhUZcGs6I4SoC5mveEMub95iPt/1V7eX41NjAa+bYmUvlJfqHGgciodVJAkn5z9MH6h1Rl0Ul
 rwrj42bW
 cDxRqQQoZc3IhJD/xvMsyLfrepVsWk+LP1b+I7eYNS+8vvNnUvjG3w/2eSMy0vsS5WfqqwS1mj//T7yN5gwL0/UDLUBSFjfi/P8Z9PozQpotnUwwL4IITYwKFSZsbIuW3EAHo2nsdLxFGkDL0mxGcSHiCkSFsDCg6qORIcE5KSE2D5263IQA0ZJlE1SHs8UtxMFkOW1D1XbiooidDdxkCUzd6dItonplB+Na7MsNBy3KMRnXFGyCxL+J5MrfZG7bzWfAnr+zQ8AUG9O7AWSN9sd6mjNzSRcyEDuPVNfkyF96RBtVKWQXf+18Ntl7WfOat+ScGmClbSEMhklogctaQ93GjqmDkFML0DjqTFAY/sNaU89JjNM7KFH/VHYHsfYal9njYJDnGlaj/x3gAhXAynh3F0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 6:13=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> [...]
> > +
> > +       /*
> > +        * If a page cannot be compressed into a size smaller than PAGE=
_SIZE,
> > +        * save the content as is without a compression, to keep the LR=
U order
> > +        * of writebacks.  If writeback is disabled, reject the page si=
nce it
> > +        * only adds metadata overhead.  swap_writeout() will put the p=
age back
> > +        * to the active LRU list in the case.
> > +        */
> > +       if (comp_ret || !dlen) {
> > +               zswap_crypto_compress_fail++;
> > +               dlen =3D PAGE_SIZE;
> > +       }
>
> I=E2=80=99m not entirely sure about this. As long as we pass 2*PAGE_SIZE =
as
> dst_buf, any error returned by crypto drivers should indicate a bug in
> the driver that needs to be fixed.

That is what I have in mind for that counter, if that counter is not
zero it is something with the crypto has gone wrong. If we are sure
that it can never fail, maybe we shouldn't check the error return?

> There have also been attempts to unify crypto drivers so they consistentl=
y
> return -ENOSPC when the destination buffer would overflow. If that has
> been achieved, we might be able to reduce the buffer from 2*PAGE_SIZE to
> just PAGE_SIZE in zswap. There was a long discussion on this here:
> https://lore.kernel.org/linux-mm/Z7dnPh4tPxLO1UEo@google.com/
>
> I=E2=80=99m not sure of the current status =E2=80=94 do all crypto driver=
s now return a
> consistent -ENOSPC when the compressed size exceeds PAGE_SIZE? From
> what I recall during that discussion, most drivers already behaved this
> way, but Sergey Senozhatsky pointed out one or two exceptions.
>
> Let=E2=80=99s sync with Herbert: have we reached the stage where all driv=
ers
> reliably return -ENOSPC when dst_buf is PAGE_SIZE but the compressed
> size would exceed it?

I agree -ENOSPC should treat the compression ratio the same too low.
However, is the crypto library able to return any error other than
-ENOSPC? I am tempted to do something like BUG_ON() or WARN_ONCE() if
other errors we think are never possible. However even the BUG_ON and
WARN are discouraged in the kernel so we should handle the error. The
one error is we can log it and monitor it to make sure it never
happens.

If we are absolutely sure the other error should not happen. We should
remove the free form error from the interface to reflect that. Make
the function should just return bool success or failure as a buffer
too small.

Chris

