Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A7EE9B340
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809496B0005; Mon,  2 Mar 2026 04:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7096B0089; Mon,  2 Mar 2026 04:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698766B008A; Mon,  2 Mar 2026 04:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55CE46B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:48:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F09F11A0A9D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:48:04 +0000 (UTC)
X-FDA: 84500646888.25.704BEC0
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id E89D98000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:48:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RdQJSoex;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772444883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z16NGtCKG/sH0gOql3hP+0HDXCTAuDtexFQaAsYg+mQ=;
	b=M3Cv/GB2Rr3huAOrKOc+2GQVo6D7oKFopOB0w7IITZ0fvmJDLuR1lFvXDUyHI+Z50snvjA
	jIZbD8vHi3T3dpDT5bP9h92F1xScV/Md8kGIOQZy1jSYsuKi2qjQMGsugsBp7JlpCezTi+
	kiJ5ZWnd2j3ZuYyXQD8mbYE5jGtKCl4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RdQJSoex;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772444883; a=rsa-sha256;
	cv=pass;
	b=IjgCPTGU3AC8XcEx3I0QQjGtHsQXoFEZe/p/RgOPb+8gXC+vQEqtiOKqa0c5N0ymXTA5rD
	b6+lfcBKyNvn7ZQ7OC+7MvJqLr07cz6H8L6ZKJBLE15G6jROlh/kWgPHPcUSpRPpqvOJNL
	b697aTV8pri6H/qTUllvcyoQHvQh/z8=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9362ddbee2so569586066b.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 01:48:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772444881; cv=none;
        d=google.com; s=arc-20240605;
        b=cAa5038mNKAuZqvp8cnjJRq+N4mGekt2uVa9BME761atOMcaC7bkqonM2Qr5Q3wQmp
         15ZvqbhgNXdblS+8VNEPN8zFytfnJ+5uHEym1RWPnOuASsxzzpPYXg4CWTSSvbyRsB0l
         mHsPe9J30alhB1C4igMs6kY1H4u4bS2AKdulLTla7vljwD51Mtjr/8d4l+igiw9iyPy4
         A3/+sR/zq6cjI/BamCxeQhZ9+MG5ZGkkpMPy/vrh7Ned8Ko/fmK8umDCE7JXT14T26cD
         ByOc4S+CDcypHL4NdQAPVvpfA+3Vkh77wiMXtPTjLjtEmScK8WMb3XQeylNHUgBNpTQ+
         Z+Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z16NGtCKG/sH0gOql3hP+0HDXCTAuDtexFQaAsYg+mQ=;
        fh=1Czo0bAJgRD4KS//6VAFnySxEMtYzksb3L1HbPX/gWU=;
        b=B94S7v7f5cBGmNWGicJp8RJEBV729LuYEf2U7lOs4lT9kPXdrIrClC6gJyvS58QNRG
         gbeD6q1Q0tSTybC1kcWHakR5cPWwdEyw6HZMdIUQnmDcftX3gsXK23Fzz9xCjUdh7Fj3
         VAX5VmD7H7D60P+U6odI3xap7ZNtD/O7TDpR8fK77WNuLi+ryJ8LHQq2aF2sonp3xjK4
         ARwUDuyzlEiS/n7M0EVp7orHHSGeCPHz01fTfpu+X5C5xlfKGo1L4tCUcDzDLfwxxI4z
         3dSPyzUL3PQeaF/gYZxPkZfoheJ3nuoUn1SLKBIVDaZfmsVvFyUkjMJwKEnSTwOCC1Ux
         nHRA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772444881; x=1773049681; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z16NGtCKG/sH0gOql3hP+0HDXCTAuDtexFQaAsYg+mQ=;
        b=RdQJSoexAscHBmuJmqg55BWhwBf6sE9fD0hwgnqKJL7U6mnH55t/6XcUy4QDuS8b5T
         JdwmnqKl9/C6JjCXfWTg3uJd1keylPGNGtjl2wUpk7cbKh1I4cEnE0ZBGc616Si+yfsQ
         Mn6m1uFCU4SxCVdREsrHJsTCtTBjefMknCUwrg9sCkrlZWEwCnIZhk640xjTsJpCoTnu
         l4WclmiADrKV4ExxZmQLkn9v1IGhtXPf0gUlRcbQgaRMIT039XV61of6+w9ryHNY3y1M
         fsQrhENGZrSGuv8tLRM0EAZn/ZVCxqg8Rq+WZ1tT/8CXM1etfL4Ez6MAoc0q6b36LvRq
         zkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772444881; x=1773049681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z16NGtCKG/sH0gOql3hP+0HDXCTAuDtexFQaAsYg+mQ=;
        b=Yt08zIJL+T3118RsDmbj9OpOTdw+EWST2D3BPLBLq8kxXsCDZdlN69r/xqdu4tM0OR
         yoECmolM1fjKz4BsVQr4ahm46H5mjcfWStxB4gSXsRA1/BbwP100JL0UBUYsZw2qF4b+
         z2nP2AiblUQEsRwfz9ppVhCuKy67Lc/MYHAez968phub1h2FtBZ2SKkJRgqvKDKtl5w5
         Y68qZyJDzD0KXNJlAzG6nuTIXH5yt4xSX0jEmCwen9VIYMKZtAZ8INwUcQO0VzeaGypd
         Rmyu3TUDS4r1ju5Uclon0ymZ01f8QnMQSn4MuJ4gHezcHxL0MQBDid9KYobT5bELjZMo
         eYDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS6UjVHTbkwQmJTSaRg1H95yviMJRHPZEymu92fEAVQauOATHIUxjpTRZQym1FMSs/cuR/Rygeug==@kvack.org
X-Gm-Message-State: AOJu0YzhIlk3kIlaSmgkWcdzSePcwVaQJHTHCUodA9PB3FK63wRSwQqi
	WvIOjr97prGohNyjZQjBWYfZSTcjPhTL5EaE5JtWfNGz3MD8nmAVkLPW65MLQdNnd7mfIiIFl0C
	wb4iw0Shxaw2zLRRuiJw7pEExv7EUE+8=
X-Gm-Gg: ATEYQzwaDM2FEdnH3dGAxzPx7wRX2haPSxhIGH06wHpTU3GRtx11te97E3Ez/flLuW6
	cRB60Lk8aMCp5vURr2CWCcvX35rxFIgYNGTaTCvjcUbNllbd6Wq1KrAEVguls2VIu9RWIv/+vvU
	iBrg5riwHXbrX3bFZEo8beX2yDFXrKrvL5otl36LnHomb7ttoTqee5sJZA2lqZyAiCE37SXA0j8
	ODiQ+SGZlkhyY+g9M6xqqN4uS5HOyCfNu3rNI4w2K+KiDUnJbHSFg7muhdRGTR6m5RYMby+u8w1
	eoDjz4WvjI1l7jQmZxSBcJ4YloYxRocev705jDdn
X-Received: by 2002:a17:907:da15:b0:b8f:a68a:e85d with SMTP id
 a640c23a62f3a-b938391c161mr579702866b.23.1772444881130; Mon, 02 Mar 2026
 01:48:01 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
 <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com> <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
In-Reply-To: <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Mar 2026 17:47:24 +0800
X-Gm-Features: AaiRm52oYsG1VpW4_A-4yy9TFAxWeWKKbmV-EF2sBBxf3bsGB5wJs_psGbGDYmA
Message-ID: <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Barry Song <21cnbao@gmail.com>, Yafang Shao <laoar.shao@gmail.com>
Cc: bingfangguo@tencent.com, lenohou@gmail.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	weixugc@google.com, wjl.linux@gmail.com, yuanchu@google.com, 
	yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E89D98000A
X-Stat-Signature: xi3ajo919mjaks7pfhbzj75nujhbf1pm
X-Rspam-User: 
X-HE-Tag: 1772444882-206369
X-HE-Meta: U2FsdGVkX18BF3oKNZufRkkdF7gmcLEflsVyUlDKXJaxdEktKrb27ltqA9dhGWmrSeVmQngG3GBn+GiVpjT92BAzGnBHzcfQQH5px31DTcUtSiAUIsHPxDmXQKBcZ/jFBa34UZLqYRphVQO+qcyesL3BAla1D0oFpkSj6MaZMyYfQjgSkS3TYj8jUVAN0jEaDbzGdcJx3el5kemwOwFmiN+MMMGKfR9spuBKqbprZPr2jxJgJNCZ8Zt+01mzAVuvVwosfyTRIUv2xKM0P7cFYJ87YF89YOAY54MqwX8wc3Xd98U9a4arYolxtBnjiC0+oIxa/SpOhjEizoeSj0jpEJkoIlTg6Z1op+2AMKzSfzpAH7GPEM+SyaMazq5SUit2ftb45eFnZLpBt96cC5RalGEX4IG8/rV29+00TNW8pVmmdV3QTRcTQxQbiSyISEHMfFXJ2+wfgWAqxo0lZf30LNSyqJBT+WZRwELLsR/3q33GJTFHNBayHlRrvEfPkCrtxtmbzksCIh5TDs9JD2rKwkCrscfWcQlra+KUwIyXJfZ0va3DqBy2KW7uzyCMAKayB0ZavWTyKzrdlnwsbPmheQEZSBQE/QQiTbNejgq/9s0Qeyuxf/sij/8UfRTWDtjZ/XRoFZfXxZeOTuPYzcuKXn0F92fJ6qFzLDhxPEcXFSmcPs8P6e1k99TBpQgdqWigkUVxoAsWJ0yMZwjfmah5QSMuurk+QWI3+MP1wqEekaf8mtmjz0URrJRoDf/i5L93il00tMvTyxOqikhSm4os+xwm6imDMBDuboZSrEpid9iU8DC/mX22FdCwgjG/lOYnzwlVloQ+TwjMCHiY3Kax2vZsvsVnLN9VFSB6Bm2ofPN5yhihoYk6uO4HXiSpmFTeZ1suGA1hcyCwZZXN4pO2pOV65zZmEXK2wIl4H5XyaIBIz9xEHL22el4tzxR4p5FWxt1O4Y3dxL/Dotf4OlS
 axD4g+py
 4WuYxQjrgNTUvTrQDTRyQStqe9k3ONL4ZYZSDTA73MGDlmg5ZxG4SoZHla4tzcbEZ8aGMVFa5lFBsbAK17eL6Me4sLmaX6sSVnO708k2DxPf+8FVHQESduBdLCf11p73fuOXZohW7sNJy0halT1BU331McX1EoxIOFHZfcKtwEw7z6V/BJR4/ZZj590cVTf3mwLcAG00p7dQIfiFpndVJ1gWOP2vQJM6K0tP3CwrqIiw+4FQt2KdoUDw8gkaJY3mC3WGgbXsooAtPEbQR3EsdIz2YZItdGVxJCP2gxsGzriF83zhZU6df+y+tTApERZKSID/V5zbISyhakdZlYAr0fGidPj2Z53gZWgCfpJWQRk7UiQ6tuzSvEhSaH+Rzxm7eOe66jY3pcGrTX/OeH1GUYxzjylxihPFG6qR3XSxK2BrhmETDgBI1IA3eN+pTixyBRUlOmCc8QlEIJrb03h+oa4BJMOtZt6OHLcfnBIo+IZBdpm472VrPE8mFfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 5:20=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Mon, Mar 2, 2026 at 4:25=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > The challenge we're currently facing is that we don't yet know which
> > workloads would benefit from it ;)
> > We do want to enable mglru on our production servers, but first we
> > need to address the risk of OOM during the switch=E2=80=94that's exactl=
y why
> > we're proposing this patch.
>
> Nobody objects to your intention to fix it. I=E2=80=99m curious: to what
> extent do we want to fix it? Do we aim to merely reduce the probability
> of OOM and other mistakes, or do we want a complete fix that makes
> the dynamic on/off fully safe?

Yeah, I'm glad that more people are trying MGLRU and improving it.

We also have an downstream fix for the OOM on switch issue, but that's
mostly as a fallback in case MGLRU doesn't work well, our goal is
still try to enable MGLRU as much as possible, many issues have been
identified and I'm willing to push and fix things upstream together.

I didn't consider the the OOM on switch an upstream issue though. But
to fix that we just used a schedule_timeout when seeing the lru status
is different from the global status, very close to what Barry
suggested, with some other tweaks.

Keep doing the reclaim during the switch did result in some unexpected
behaviors, including OOM still occurring, just much more unlikely than
before. Like a typical TOCTOU problem for checking the lru's status.

Let me Cc BIngfang, maybe he can provide more detail.

