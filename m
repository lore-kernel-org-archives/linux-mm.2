Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFBC3C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4FF6B0092; Tue, 11 Aug 2026 12:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65596B0098; Tue, 11 Aug 2026 12:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55606B00A2; Tue, 11 Aug 2026 12:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3096B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:25:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22413400FD
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:25:31 +0000 (UTC)
X-FDA: 85089514062.17.9A8FCAD
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3925F80002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:25:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jin/+Ory";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6H746CB/OnuO73WqTXpctQk5TZ3+mdwvVMiFPnzpXI=;
	b=NMYCT+2g3yU1hhCKa8ylIcw98SxsdJ+IQq/PW8SAA6fCkvujJ4PJ8RkNnbB4Rvkjdx+3q/
	UZEhifdaDQp2dwPR6KFPqF6kZ92XotNPHJc+mI05ztZr41d8xei4gl/9R7kwXY0Mcsq8I/
	UL2u60OUCMBQIuLlSuZDD4PMdBnEXP0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jin/+Ory";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786465529;
	b=FrVZP3JFQyc/QLzWvahChhDUPMhh2mGekLv/wsTJ+04OTzPquVNfnn2CroDduJOdMzItoq
	Cdig9pOEK7DdHbrsrlEgM8ViRFnyZOg7RO1vEhStX/dHnC4mSZ2b+/WSYsDQp8eocKMn/m
	742MFu1GFaG/NzNladiIM7XvJ5V0hMQ=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47fe377a217so684090f8f.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:25:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786465528; cv=none;
        d=google.com; s=arc-20260327;
        b=Sk9DmUAl0qTb8WHBXqr8IrJ9kHKLGxr3tgFO7c2fuGHegggUOVt32k5I1pC7N/ABk5
         NsgLoANfB6sroAEbPbNg431MYLkjACiyg6ebkHp/nxui+tiJvjMOk8s4uXZ4ZZRehH6u
         JFg04uQzLpGnRKf/fazCpNBnx4oKyNc8qiUJlBGTvJToZwSg6lv61ofZFhEhmlnoKYVe
         xnR2pYwg8mV7k1RB1fKBBodtzNpc5nkgrtmyDmtKWx/7oDQsIDXA07lGRdvOXBeVak0S
         lnmAL/HZEPByHpPj+c3Ean1mpYLWmXo/J/8kZ6MvrPaYXw1018VNWeZrPjUNwmmZTGa9
         TL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A6H746CB/OnuO73WqTXpctQk5TZ3+mdwvVMiFPnzpXI=;
        fh=URecTL0A3pTK3rUOsvjgpQQhhed96dKTLcrxX+CLSOw=;
        b=Q5HEDOkkG2qF5dmMXuiLO/TnaR6ri5ZkrHPykWEC9SG3/jBgsq/SrzNjYbgwzaTOp1
         GlZsY8ZLJQsaUT6lWiy13vxGTLoyC9mIqDJKxxSuyVYM7JKDe7Jcit57fqO/weYUbV8X
         pp3dXU2+IUnWTQXqtLqqGVHFHk7r8NFdG35X/z+eBpNCJj7gbxkPgtPkJKoVRywfjX+m
         8RJ0cLvS1y+zE4YduzDmWKSXvxdqsNvqEmAm1iEkNazSh0T4f00B62a+8gUNnr1NSZG9
         bpoelHEmDWl4xL5rDHEyx5W54SJYVq/pMiq3Sphs6cK+SR70RmXlFtFCbXdJPD3vTZki
         4sUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786465528; x=1787070328; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A6H746CB/OnuO73WqTXpctQk5TZ3+mdwvVMiFPnzpXI=;
        b=jin/+OryFs1W8liIOlgcW+fxo5grxh0XJaDDyHEG3uJk5Ov5ac+gmZY3RTX6K4MjeP
         Zw9pTfeXxPykvAGFgUvDPMWtNND3hdCaQxdNPnyXDz4TXDVaVKhZxXfaeHSK8hdD4SVP
         aiT5ki4Yut+0BbeIvHP2vVxo7BybZltXe2jo/J1lKJd7huflt2BYPQirHw/oWOUdo7wX
         k61QtDlEMmwWTxT3Oh4tk2/7mfOSj4jtsmYzLWXt3wpVDWVfyzGTmdNeExqaWxcMbOjy
         WFcBeHY8lP418VlcwsjRwVo6esWMPDZ05c32O/GLzHxb3MH2hXBvPU1tkNLsn1lPwj6B
         aTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786465528; x=1787070328;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A6H746CB/OnuO73WqTXpctQk5TZ3+mdwvVMiFPnzpXI=;
        b=G0TiLr+G8oBc2nG6xEk92KEuGlhYePZX09BD95vB7ccpKGLxD3DQeU8QiqdwAYC4XQ
         9cFngL1sgwr0ZDEPk9a38CgoSR3XOFG1xyhiy9QNDT3ThqQ8K1nUsNomRvni8QIMV+X6
         7zGcY7LQ/iuyLxRG8sSrWi6NHwImgNuPRrOydSazgV1xkuvTnrsPXUoceQy1WEmBZTEl
         LAmJdOAqdFUZ8RBaYFWtw4IdcXN61sankas7iraGFlweGzjpnrFbBdvGz78vLrAsg4LP
         BL0oM8Qs1h3QxAaPTGGdIIhYXmHmfdelwVhDQkJrH7hj6vQgw79mG1xzqdrWrTckEddM
         KBqA==
X-Forwarded-Encrypted: i=1; AHgh+RrcUyLxFQsyS4gtsYmq/suw5aXWJYMfQoTEoIt+a5Cu4f/jhRFrWVlE3sAJDSVjLGbLH11sXkMniA==@kvack.org
X-Gm-Message-State: AOJu0YxNeZ+WKHeMGSTeyJ52PzPyvjGYj9TwMIb2WpcqctHz8BVaoxM4
	DAN2QF/VmPZoiCfUBQVSw8iYgD6HxcvCk4bOOWUYQP0pedFeSj9e5Kx5Sw9hQTj/FDs/QC6jClz
	Mmk9+evK80+t+JjRZdm+/qk50Aqs+2LA=
X-Gm-Gg: AR+sD136/rMpg6UhY14BiFYdKBm2/JQa6outP0mJeIgolqUbGTUqqjHGxDu+cxn9t38
	a8mEyVPh9+vIRupAm+0u+1F2GHFvkWK/saN2a8iiVVgvIh1T50OjqYVUP7TW41OlrpHqGI/fSzJ
	2BdNDY9OZE2bJf8DphVOLSaP7bN9VFYtJc6E/oqmXw72YQEdAkz9eFUdm+Spv7W9xH6g6hcM9JO
	NKXbGAcRK3pkqE8qiAY9RkcZZNKwQvL51i1NO/EoFmjSxOHvrMvEFutmMuxuG2cilSWwu9UKYnQ
	X3rpMyNGne6tnoNOvh6e00S/diirZvYMKaMP1XuHfzHNefgI0p+ImR23iKN10eQEb9KG7fEFV3C
	LeLjly5LV/Tk=
X-Received: by 2002:a5d:588b:0:b0:47f:f87e:6485 with SMTP id
 ffacd0b85a97d-4814fd76b52mr2315991f8f.15.1786465527243; Tue, 11 Aug 2026
 09:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1786003779.git.xueyuan.chen@vivo.com> <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com> <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com> <7b83c51a-1777-45e3-ba38-89e12dc87b5a@vivo.com>
In-Reply-To: <7b83c51a-1777-45e3-ba38-89e12dc87b5a@vivo.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 11 Aug 2026 09:25:15 -0700
X-Gm-Features: AUfX_mzI47bUeYRbxULEPIKkxvomzIb9ULG0KeuqcVeIjh2Ci9rlsyg-OZcZv58
Message-ID: <CAKEwX=N0Ocxa3o7A+F+2_iwEPtyvXzunfNXOsq7UaPEKWSB-gA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Xueyuan Chen <xueyuan.chen@vivo.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: yqn3878mibrreww5jebn945rkjg41p8j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3925F80002
X-HE-Tag: 1786465529-540165
X-HE-Meta: U2FsdGVkX19Am7jHdybF3jZfsSrAxaXxQg8rTXM+AcFj+Y34Z6ue+/huzh42zYht7XtiKiK1xb2RhYq1Q5XQPM6U59DSdgNgnfZDgTx5T5KKjJuX7IsKCi2AK/LPLkULsO6y7BfJlYiBXJspDZnHvZ1dSLeLetxzFkR4peinRjwSQoXb/RfHwVSS2yZkSpnDrVze79qaI+nIMKgyQ2roLmDp3TidV1X7Ri6s/6QVgeARuQ54jwlQ/cxWB1vJBzn6Fyb+psnfgRY1if4Cb6sqgdH/BsWGVaM5Xj3nJn8Fs0uWUnK4O01uypYY8+89Exv6ha55UJ90jGfESBaA1/kTPnLXRa1AHkBfe7WHBrP/U+NQ0/2XABhCQPYu9/NWb8YmWrYQvaFJn8wkqVB4X2z1dI11qxZzWWorwer+XLyzVKWx6c/3fNzuENXYqGTPwfVxybKLIcbk9s8mMzeN2rZJ6MpSuvGIMpVvhyI++LDkvjSa+w6wxJ60krWQoLXxHLlK5JZoKTBG32qXBvWCu84AHnwrrvbArdET13G/AlDSectgHamXXOHxK+xFbYycrI4fydYYvpUDRL3dm/3U3HgZRuPSBSU69Btfl+XIfzIf3zD/eqEfWRU/fVBrbNMFPGTljYy2mkvb4GOxKGxfUZwQlSPVD4232bZ6tswHmcB8AOm4XnMmyuxub0JiVQtMcQlDvwVFJRUuk4xh3ewhjlT6I8ewoDwvSA8zLBksBNRM8cA5vXONNbHtKpbwiUiI01gXQwWxLur+YWsK9gtQjgKYiLpfGFo3rhCu740OPnVyEd8Z+XeP2SU8oEFyGgCewygXLqTDfXXRUnRcnSZtJt4T4gDLWvBBO/ImUgBCRr0lQQxxZpctzegDtgJGozGTvG4yvhjtroS8NLC6WWB+8cF8HbK/gjw90/8H6OQKJEkZykxNUM8Oc8gdBjrOagEvRJU12NmyFP5B7aS2IowisYH
 nK86sUGe
 8H0K/8iHuHWJrt2FBpge7n3c73seA6l0VyHiAbh39FBVPJoq+neyLxUf5tnPbSrPxZm9dkcOKipr4meoAt8M78ZpnTZykKoTvxtrZMD1w7+qibw79X5ha62rIeu7VBxjhF/vW+sE1hGvFekGJwy1nh/mrU/ay+ZLfVy1xWRMtsR6n+VxZSZ/aV9GGxmzLIwUjfhuuxVpscSH3lBj3a9xgS6VPghsbZcBnWhkK8FCrLvUGARhdVoc5SFldW90LTymg9wF0hKbxb5jGMaUR1YuSBKP1Z+tAoYS1bf/UTE05K/Qo5ueY4Z29EiFKHFK1pE/XxUrOAkCz1uGXOG9gxMk6UcuurQgpcTlH0rxyglUz/sqM/c1hxXScoB8C1JTJhH1qzeqQjHxz7C+5YY6w9mvXKioR9uNTelPRBpSDbU01uE3j3QT999VmURZe6XK92As27WVWMULlhftWQOj2wj3cpKuYW9OmT79bg4v2Wi3h938yOuJAaBX0nn4yfdmuPCVWgrJEenYqBgrQUtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 2:04=E2=80=AFAM Xueyuan Chen <xueyuan.chen@vivo.com=
> wrote:
>
>
> On 8/8/2026 12:25 AM, Nhat Pham wrote:
> > On Fri, Aug 7, 2026 at 5:12=E2=80=AFAM Sergey Senozhatsky
> > <senozhatsky@chromium.org> wrote:
> >> On (26/08/07 18:57), Xueyuan Chen wrote:
> >>> Hi Sergey,
> >>>
> >>> Here is some additional data:
> >>>
> >>> I used the following definitions:
> >>>    compactable ratio =3D freeable_pages / total_pages
> >>>    memory reclaimed  =3D pages_freed * PAGE_SIZE
> >>>
> >>> freeable_pages is the estimate before compaction, based on the same
> >>> calculation as zs_shrinker_count(), while pages_freed is the actual
> >>> number of backing pages released.
> >>>
> >>> There were 264 callbacks in the trace:
> >>>    callback elapsed time:
> >>>      median:    5.77 ms
> >>>      p95:      55.82 ms
> >>>      maximum: 271.36 ms
> >>>
> >>>    compactable ratio before compaction:
> >>>      median:   0.32%
> >>>      p95:      2.86%
> >>>      maximum:  8.33%
> >>>
> >>>    memory reclaimed per callback:
> >>>      median:    3.80 MiB
> >>>      p95:      30.45 MiB
> >>>      maximum:  92.73 MiB
> >>>
> >>> The longest callback took 271.36 ms. Its compactable ratio was 3.25%,
> >>> and it released 7,650 pages, or about 29.88 MiB.
> >>>
> >>> There was also a 241.91 ms callback (with 30 schedule-outs) with a
> >>> compactable ratio of 0.44%. It released 1,019 pages, or about
> >>> 3.98 MiB.
> >>>
> >>> Based on this data, it seems better to remove the shrinker.
> >>>
> >>> Would you prefer that I change v2 to remove the zsmalloc shrinker
> >>> callbacks directly?
> >> Let's bring in heavy artillery to this discussion, in addition to Andr=
ew
> >> and Minchan, adding Nhat, Yosry, Barry, Johannes, Brian (random order)=
.
> >>
> >> Folks, I'm bullish on removal of zsmalloc shrinker callbacks.
> >> I don't think those buy us much apart from memcpy-s and lock
> >> contention.  Systems that want to compact zsmalloc have a sysfs
> >> knob (and API) to do so (based on zram mm_stat numbers).
> > Hmm we'd need to collect more data in our workloads to determine, but
> > if we can compute compactable ratio (freeable_pages / total_pages) on
> > a per size class basis, can we just skip the size class whose ratio is
> > too bad? Would that at least cut down on the vast majority of
> > fruitless memcpys and lock acquisitions etc?
> >
> > I'm always a bit hesitant to over-rely on userspace, especially when
> > kernel has information to do something smart about it. It might not
> > react in time, and many proactive reclaiming schemes back off under
> > heavy memory pressure.
>
> Hi Nhat,
>
> I collected per size-class data. 53.7% of size classes have freeable=3D=
=3D0,
> so skipping them saves some time. However, 94.7% of zs_compact() time is
> spent on classes where freeable > 0 =E2=80=94 meaning the cost is dominat=
ed by
> the actual compaction work, not by scanning empty classes.

What's the distribution of these? Say if I were to skip all size class
with compactable ratio below 20%, or those where we can free at least
one full zspage? (IIUC, we only free any memory at all if a zspage got
freed up from our internal compaction, correct?).

