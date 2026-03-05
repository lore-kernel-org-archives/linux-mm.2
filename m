Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A7AF513E9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 23:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6A596B0005; Thu,  5 Mar 2026 18:41:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55E76B0089; Thu,  5 Mar 2026 18:41:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54F76B008A; Thu,  5 Mar 2026 18:41:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C324D6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:41:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B0541A0127
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 23:41:10 +0000 (UTC)
X-FDA: 84513632700.26.9218C9C
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 654D0140008
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 23:41:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cAKi9sWH;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772754068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FucvooDZob6nIl/WUFpumjAxFjMtQ0H17REn4ry2Ric=;
	b=r2xXT0fd2j6bFeXxSrYQu+mbvpW3ltvFsm4xJl070FPg9OO3uZkUTJr/A4W0/9V1y2x6d1
	W0JPVLggPLZ1PaBnXdrv/5xSYvmjZNp5JolwD8bmRAl9kG7LZWzxuqAE0efoHTp9zYghn7
	czb8+PyHKoWTg/W2ADUJa731tjeTeGs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cAKi9sWH;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772754068; a=rsa-sha256;
	cv=pass;
	b=zLBsVXBeZ5Q8WD3KBh68j7JxoKnEFMO2Rp9U0Vz0WsN9zc/8FIuPKrfoOojc6+di3xAVDT
	jyMO5FuPZXFslILowYBOJX0jZYPjN+EUuDPvNBXN6nZwlOeRe+lzJcOk2TttYNlyQJdFvy
	tQoNOusMjZh0R6Xx/uHL8vrH7MyBjXE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5069df1de6fso72665441cf.3
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 15:41:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772754067; cv=none;
        d=google.com; s=arc-20240605;
        b=Arlm7XtB+Lox1rInuEYvUUkGIcHKMHfXi1xGipVYWzYPWmUGnO3zOoXEn2rjd/t9ve
         P8eW1UBHWAUof9VKFigN+Oj/oZ2xVIkLQhsxppH4o945VYIob27sj+aEfEoThrSVMux+
         nMb2asx3mFFECYqx9WLMO3Z2nCcabvzu9VjQcy4rfZOpdfBghzCnt3jgfhVRUXeG5MSk
         0bkA/k5oEEQu8a/cDQ7hcglNIQlhBpgp66RlkzS/lpjjRZ10eAD05OhxYWcK11hk+Sb+
         4WTSYiVJvHs3J7JqWtz4UdQ8zEu53NE8YPr0LYK4lilUCOABeWsJPQisSLgcLRXHfdyv
         McJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FucvooDZob6nIl/WUFpumjAxFjMtQ0H17REn4ry2Ric=;
        fh=gnwq4ULUuJK9GMIHdhvkQUxuWx+hweVPVy44MHbPvek=;
        b=i5tekhLSNJZ/3elmKgw5Lif2ivLZqwixqp6OshtWF0oOHrAX0P/HZsD+iOPsFKy5iF
         wB9VEOC1EzKZMzsUCf+Oerp0pMJmdGvBddgdrfNXyXetkoIE8tggZXKKV02g3BUvORPq
         RrGLInmTb4jHQpujFn/v2a03hbdcMG3Pe4rg3n1wf8aGDc3pFDku1S3B1frcMZpNgfgC
         Phg/Su1mVoz68U12evF1T3uZ1w8NqHSUSXoB5NkAFyYtYYQr09KBsjh56EHgTfx9wTiY
         LplybFsem8HuTcIRqzrxNEsOO3iCGsFv4BmYhqYLkAneCi+Gss/ArEqlbcbRHuBxiteR
         2g4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772754067; x=1773358867; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FucvooDZob6nIl/WUFpumjAxFjMtQ0H17REn4ry2Ric=;
        b=cAKi9sWHWmLSa7jUmfmJZeDr06SUfZbc8WIICfPVWJDN07m0ZS7uxKDKTXvVEDGDbI
         4w9llfhpTqorIMratyz7Tf1lUsX2CrkYgCI9Sqs2HjKPad2PXuvguOEonNDqdlbXLnD6
         D8if6Te0Hv0Wq6CuB/PrDzp34ysuQqcPCrxjKZEk7jOpbLAPgSnMJ26QS8DFN33rF6Te
         ozX5EvMPSn26q3QsRjhMOVUS9sxrj+tGg9JXmWmGowFPNVwD1Ph7wqlSCgKrQJep42qT
         BGyaoQxPQIJuVVBwv3idK6ApYfwuWNYAJR1h1dMzpy1uNqdPAwQVFne/WBuEZrfCxU6F
         w6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772754067; x=1773358867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FucvooDZob6nIl/WUFpumjAxFjMtQ0H17REn4ry2Ric=;
        b=GKZUOa6AExXKD+0Ks4G5OqneY6oDLpACmk+c5Xoy5TJ8dTyUFr41pnHKMcsef8ku3d
         hrERZPsBsIsDjEEMqLfGiCBpLTfcqCxo91w1mrrmJ4f1cPhOZlIvN5DLI2gNIoTTpn83
         mbhH8BOcxl0KP6w5Kgsj0aj/GFxHfCYz6JZTM/HZlVM9KG8kFxXcTbEwiRG8e9btk086
         +AvX4jDD4CRwxFvkFia5t8lVnIU7zJK6a043ElpPBlsXX+9tktP6xwvJxQdxMFO1PhYr
         tk4iPdCWfDGVWiRJgEkJEgSfd/OQn4/QChb3/vP4f5IqJEGyd1A+sqFMWyxXFDEi6UdT
         YFnw==
X-Forwarded-Encrypted: i=1; AJvYcCW1BgcbVVZ+LS8uS/T7tBpxKIZwOhqnA6s3h8bJ7ElyojDYrCFaCobC49LcV+O6dQrqW2wWS4Xuyw==@kvack.org
X-Gm-Message-State: AOJu0YxJYh1slfT6LwwL3EYPLiH1aar+5rb80K1CtkyD5d4MaPFhXEoz
	VmXviAfRcnyuQVRqSNnOV40/3hrIN+xk4HPD2pVytFGR5b7xYcwCJHV+08W6JWCVOXkjBghzHbZ
	KzNWNSlayZgDZzH0jsXnqlYnynRzyRfg=
X-Gm-Gg: ATEYQzxS24iJl1ukp+1L6hkJC+qaXJXv22fzgex9Nma0bno4MhDTDYI8Wg73khBELz6
	YaQ6Y/FQK0VdFoTndnmqL5Rh/GWvFbDzeAfrJ5aZDANV68w1PycMNLYUi/gxehKck063FBIDcGO
	LMJX/nksOcQUYfwagLV8+CRFrJt+1R6Yqo7XTJA5bFN8u8omlAxYU4+410ttTcGvHGW4pGQHn7O
	u2qkZe3cWI9InxWMKJUdxbLPvdGQwKzmSEP+9rt+3ifKg/uaD5H/b12FxgjF59sMoKTq39dL815
	X3tPD6l6TrmrjWWA
X-Received: by 2002:a05:622a:178c:b0:4ec:f628:ea6c with SMTP id
 d75a77b69052e-508f496f088mr3000431cf.48.1772754067180; Thu, 05 Mar 2026
 15:41:07 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <20260227033013.94901-1-21cnbao@gmail.com> <CAMgjq7CDgap5pe_xVemow+SbaRW+ERXZBZvkymhFWZQZdDM2Kw@mail.gmail.com>
 <CAGsJ_4ypfGxp5vbNaOt2i2qDmy9tCJuemDjMjwWr6hSv2RtYVA@mail.gmail.com> <aam5nOyXs1sNdjTe@google.com>
In-Reply-To: <aam5nOyXs1sNdjTe@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 6 Mar 2026 07:40:56 +0800
X-Gm-Features: AaiRm50sXjXFjJHFcMEgVSCfJsRQafHqBQpqJdmP8SK1_I1ajCtv-VmVXueptIA
Message-ID: <CAGsJ_4zLippMEwD0q3YwDVsBV6_5dvX56mXRGa90ujzi5WQMbQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF] Improving MGLRU
To: David Stevens <stevensd@google.com>
Cc: Kairui Song <ryncsn@gmail.com>, David Rientjes <rientjes@google.com>, axelrasmussen@google.com, 
	linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 654D0140008
X-Rspamd-Server: rspam08
X-Stat-Signature: ny3kjuhbksx7g9r9ezb1pzzrcwh6i8e7
X-HE-Tag: 1772754068-91126
X-HE-Meta: U2FsdGVkX1//C3HUzUOq60jSr7XWGdbmDe3lKzRay8kKg/25z88Gjmf5HGdy90+XJUfVnXrl6C6rHC7CSAIZnEuMm7683EwVNEHi8OppujUuDvgfEcDwJVnBf/mQqI7y3h0yhcYAMFCs/TJHHzf73Cdoi9MatlHEQFyKWXM0mX3jYKbaNswiJS92FmwtaluqWZT278al0UmAe4s8+U+yH8JEHdJ9GwN3ibN4FhJXY2VrY2V0xjmYU4udErxiNcRthGiPua5ON264PaUqNcbygvi37slpVioc2YCmCpb76TLmxek4WAJrEFS2oyg1MoSyd5RmujyGwq9/gZOhdFN+be+qkYWhYABxVqegDze1CB7TE80kAsdzPoxO9FEF2yjNoUOwfsC5HoNhc5bQNTLXP8apt2/Rl+kOse37r0aMg/0cTKjU2c03K045yc6h1Mu4tIQTNyApRuSm/Hok67nEwGknTrWoZjNDOoAnf8HDG/Xa8YQe+6Wyb6eGVaDuoe7m6RCBoT4jgwGffWv4EXps3Bu+6FBhNrTLqthHgwnVku7QMrYNTYygIk1je020MnOj6kB5uCDj4aGVcjunp4eFSw5eKsqqS4tazRMA7EM+uEvqkQOCBUpB6FkCw6+l9t+vWqfoWnpDb70WEyizldMBcAd8EYr/j+nwgNI2MWa+utiQbH7fDH0L1Kc/aEj8EOdE2YpdklXwuShsV/IHpw1hgIznJyzdWWzCBm0X2hiKW8O3F8h1bacwHm7oW3bgJQwI4OpGonvm9fOuUJU4jHG1i4FMHW7+PEmDbuRTMDameFOVUnjP+8n4cqdgzQpagUjkMmtMkulCU8c2Z6E0KZFp9Tcl1E6B9zW097pwmEkLujNHNqKTnZTCJBEEGE6nvgbrXghDrFYZmkA6U1Ll6M71yjzlfC4K6MYvwlCNadgNM/agxxjFqBzFhcrhJ4kBYwyOE8d6u7gmCYWKK+9HWkN
 GNgdOGLi
 Bx9FDUgmxrSbzimRCAvD3wlT/Py8bw4NSAXUsclvcxNyv1Vs99DNky5CjKoX9ztK3bBFz/HSya9CUghQHM25pa9ftxl5xRXtzvspKJNpT+CF4nE2PiP+J1J2BzT7HHebor0XGxdS92CLoiSfreipGURnvXl44/oZFsDlXaelf3/0d9GbJ6sdCUk/T38nd1Z0wPrVGwzpBX1LvzXhBNZEcJJTXNBcNOM8X7gGpSnf3L/8ZXANIcmYQO+GV2nq0krFon9MiO6dgAc1ZQtxBadTurGrI8BR00Od/PKEnvVA1qsRHAE1w9jwzZB1Ulryz6pLAGwm2wnFUtuRuPiKBN7X5KaKFb2GavJYW0tFHYtGpexV8nCxVSq8bDakA9GvOCRCOyv0XtFsNoMZ+svCxpA5fpnlRFRpamq0mH2VJaCsPvt7ge7ZXuN0YyMwrehbJMbBD5RcPEZ8koZgJZePNQv2pF+A+trw/WZYXTtvXbe9JyHMUfIAoAII/P4lsVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 1:13=E2=80=AFAM David Stevens <stevensd@google.com> =
wrote:
>
> On Tue, Mar 03, 2026 at 12:06:20PM +0800, Barry Song wrote:
> > On Mon, Mar 2, 2026 at 7:10=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> > > On Fri, Feb 27, 2026 at 11:30=E2=80=AFAM Barry Song <21cnbao@gmail.co=
m> wrote:
> > > We have an internal workaround for forces aging, and waits for sync
> > > aging if one type of folios are not reclaimable (without the wait, we
> > > still hit the MIN_NR_GEN protect again since aging is not finished).
> > > And without the MIN_NR_GEN protection we might end up over reclaiming
> > > without aging.
> >
> > I see your point=E2=80=94I did exactly the same thing in Android.
> > However, there=E2=80=99s a significant problem. If anon has two
> > generations and files have four, they end up sharing
> > generations. To age anon, we would also need to move file
> > folios between generations; otherwise, the hottest and
> > oldest generations would overlap, causing cold/hot
> > inversion. Furthermore, in inc_min_seq(), moving folios
> > means the oldest generation gets pushed into the second-
> > oldest generation:
> >
> > new_gen =3D folio_inc_gen(lruvec, folio, false);
> > list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> >
> > This is far from ideal, as it still mixes cold and hot pages
> > to some extent. Could we keep anon and file generations
> > separate instead? I feel this is a strong requirement and
> > likely the first step toward making swappiness work properly.
>
> I did some experiments with splitting anon and file generations on
> ChromeOS a bit over a year ago and got fairly positive results. Although
> shifting personal and team priorities unfortunately prevented me from
> finishing the project. It didn't get to the point where I was confident
> enough in it to send it upstream, but I think it's still worthwhile to
> mention here.
>
> For a bit of background, due to a combination of low-spec hardware and a
> complicated file system structure, many Chromebooks have poor file I/O
> performance. We found that a fairly significant contributor to jank was
> important threads being blocked on .text faults. We tried adjusting
> swappiness but found that MGLRU was unresponsive to such tuning.
> Splitting anon and file into seperate generations and then setting a
> fairly high swappiness value resulted in meaningful jank reductions,
> especially under very high memory pressure. However, there were
> regressions to some workloads that I did not get a chance to try to
> address.
>
> If anyone is interested in seeing the code, it is here [1] in ChromeOS's
> 6.1 kernel. I also have a WIP series posted to Android's 6.12 GKI kernel
> [2], but it hasn't been merged there. This version fixes some issues in
> my original series that were exposed by runing on a very different
> system, in particular around memcgs. However, it hasn't been tested as
> extensively.

Nice! Thanks! Do you still plan to continue working on this and
submit it upstream?

>
> [1] https://chromium.googlesource.com/chromiumos/third_party/kernel/+log/=
929932351492d01f0aee37a0ac3be8c7bd88f80d
> [2] https://android.googlesource.com/kernel/common/+log/49cd20cfb0da2361b=
e064f7fd70b36867065277a

