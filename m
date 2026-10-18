Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11CACCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 20:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D266B009E; Sun, 18 Oct 2026 16:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF026B009F; Sun, 18 Oct 2026 16:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F205C6B00A0; Sun, 18 Oct 2026 16:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1B6D6B009E
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:38:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43D6CA8150
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 20:38:12 +0000 (UTC)
X-FDA: 85336909224.05.CD38110
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B4FA100002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 20:38:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q3MKxgws;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792355890;
	b=UNOPDgudlfxKZGUBYD9znWa45/r1GbuBzRFJNLlgb4TcFHVKETDnTUfqSiFQjqqR4h8q1c
	hj17wmQKySGMpAtscVw13ceqtsYV0RhQA7R6YFCjGWuvLP+ajobtlwC9ASEvqoTofu5Pbq
	DTeXIVADiu0rP+OMYGRZK4/WvWayS6E=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q3MKxgws;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792355890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQEuJfxQYvtnYsFieIFSsWi3xut1QyYW+h2Ko2bI0iw=;
	b=iFHMjdxmE2O8Us5nJow7nyzXebTQhMRIs1a0SA+5G6oAKqaROsoNxb2Qpo20cOEqDZGYQ5
	c8fmMuGk5P9JqCMUEIOiJUenjKRU34Td3yvlre4uASZyFbzyvjrhv4CPCATI1puIkg26SE
	ljTaliShqRU6RT9xztpCzIUv7xVwI1k=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6acba4bf65eso1568161a12.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792355889; cv=none;
        d=google.com; s=arc-20260327;
        b=HjE3AO5dLrmJdEGXv8jpUYynLD2VBbUa/3h0JtgN94I8yKUyxi3mGUuIzFu08xdZW5
         RYHQNap869r4w1XuBhuBHGnpcyBCBU0GvzXE7xG9cR2eotaVfQGamhSd/cC9IhLl3Zls
         txbQ3Mgei6VN+xWMPrhQsT40D36uZ1sqhL6Oe8lNr6ORHErKXF3tsG3ZFFAUTZdn42a8
         lJj6PKzO5U7eMrH2ukupDUUbG1tP1gAwoVsj9SuRC+geV9V1jRI+2u8/wqeMpELr53wv
         lngGVDQGFjSmlwvj0bltamSy6UxksfyImXxYKlQ/GcFqDV/eE7oWmkd73o+M2jH/naTI
         awBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JQEuJfxQYvtnYsFieIFSsWi3xut1QyYW+h2Ko2bI0iw=;
        fh=bXByUHQP4DnRpxsLhCeH/N5fokeWbEEFGLlQBShkmMU=;
        b=RB/4OH0ljcwnGfh+o5wubldfxD3WJcx2MTXvxN5Tyt45FcwkmiPFCBmJhI/m/OBc+R
         uSmT8HHK4XiVH8/unjboHD+cRiVSF0qJke7P2pGHHJkYCLsa8tV8AZlYrjNbi2Uvez2w
         2ZVs6XuPRm+LB/pNXSev6lyBkOClSmdSGMFvc3P+03jP+iSkCV35rQ4DZGcmIjfJLOtB
         UqT+S3fJs8JRCSaeY/qhHXXmCBzIanMuK07AlHc5FZYortcEp35lhLVEziFku7K6Amoy
         Fc6fmjX93fFyt+3kmaYubaQUfAl6re5t1y/Bp421MSWHcWyXibl4qKSpsnKAnNhb58K1
         /GAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792355889; x=1792960689; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JQEuJfxQYvtnYsFieIFSsWi3xut1QyYW+h2Ko2bI0iw=;
        b=Q3MKxgwsnZf2m3SQlwIyup8E5ZLgV9AM9MKDPQO943pZWPskdolKvlhlXbzZNHdxeA
         Wcf+ZSc2dvaXQIFxy9OXsfBOazvMhmY1M2Jskui2fBt8UVE7nPbgZm2qOn4SX9fWiv7O
         nFtvKI8ln99FrQrFJLclPkhnj0es5xHoAEA7cupPVedNygxdD77WCtCgMic3cC8K51NM
         mVvbo4QyQ3+LM9vyzglhRNi0eQiCknekVPGnVx1xX+oDS6HTEnvWhMuSwYdSfRvh97vp
         FywvnyPPLYzVTdg8zjs0Lex+w8iiE5vXUDCL67MiPzm8mPU62hIHJL2xG/dvRdArFOw+
         ClTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792355889; x=1792960689;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JQEuJfxQYvtnYsFieIFSsWi3xut1QyYW+h2Ko2bI0iw=;
        b=Ovn7PniR9BcGXvOF3Wqd8K/FYhLCYX1DJ/s8p1O4rkF27ouCAPNJKVHnHmCt7Ah3/N
         0Yat2AluVaFPIh6IFqRIu1bbyGIACtXRw0JyKAEioa1Y6OcGpMZCA4QDr35Xv40SMC2Q
         gb5xuFeStExM+GFq3hG4tMtaENNt5CAIyaC6bvmzyZKDFwqNMduLUgvhLHZaeRjtAWmV
         csTMHsrFZVS/bfV6p2KZ0bvnLEQLUT+AIQYnEWnV8gP/1cEaWMcAtnzNMQa8ADsy6vY4
         gSAveLURh58XKDOMV68IYdf5rYL/QeKoQGjINWBUvTl68O9tqOlIRI67h2HQOqkoLONW
         lLfA==
X-Forwarded-Encrypted: i=1; AKwUvBwIhdVDXfYyD4LNiIV+sLEp410+Xuh0rsj9o142/iQjcVpXtkryd9zzu0g57B1p/Fn2NTzbYoJyfg==@kvack.org
X-Gm-Message-State: AFq9FYJZrKtdy1JGoHlcwp/u2TCVx/z+Sg6WYoSPTMVMmz6iXYx58r1A
	QcMtNiMfiM1QAi+fiK/NGsEjr4tqym6eFKJP0TctDhx4R43LAMHGVp2zaSewKSVl5KIWO7FkygY
	N2kZOr+jZp8Xbue1J+ZIowixyeaHFH94=
X-Gm-Gg: AYBFou3CSVGd7B7OjqnKnX8FL+uAv88txH/zS5GN9GkaXzLh0xw8FSUO2e9bj1dzWLB
	izdAliRG3C11hG4lJQUpfMiDBtGmJnSF5LhKpspWHYfWQxhSQ7+MRqOgo8tddVSInU6qTIpajr5
	SrNcosTQunRDHwm4zKLdPJVhMQHT05KF5KxdkBwxSxZx9IuQ3ZfqsBj3sOLlAkpgBE0av7zaGOr
	+PwY4v1Hxj+cnnnY35EHBJrjZR/odzJoF5BpyyleJGdryNhGWXcBCQYJFdrlYcswqEwMDufNY0M
	+7kM972c7uAeKMyyuqL4XSNEqttW7ad6lmkUUBrEPdzJdgzplEUi9cpWyyOlcdgKjTIA3dL6SMl
	VpI9rW5R0KFwHiVtL2bGQtdqRLdxY9CV4ph4StpHxuw==
X-Received: by 2002:a05:6402:21c4:b0:6b3:bcb8:8a9e with SMTP id
 4fb4d7f45d1cf-6b3bcb88dd3mr1755246a12.23.1792355888546; Sun, 18 Oct 2026
 13:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20261018122734.2594904-1-stian@itx.no> <e3068b5c97884032e7cbd12c78f6b5534d75e30c.camel@physik.fu-berlin.de>
 <6e2d2b2b7aa4029c261831016d8b6c40bc335341.camel@itx.no> <4f7dacd9b4cf0a43209be84f2408e6f7e033fd3d.camel@itx.no>
In-Reply-To: <4f7dacd9b4cf0a43209be84f2408e6f7e033fd3d.camel@itx.no>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sun, 18 Oct 2026 22:37:57 +0200
X-Gm-Features: AclHuK9-5GZYJ5otQ0xBPe9DcsaMy9Ec48RLx_aOqeCX25Ag9ve1MlPXyk4JPi4
Message-ID: <CA+=Fv5R31wpXsm-7_H7ZR_U4ASubis+_zWKotpj2iNeWW_MTUg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] sparc64: Randomize mmap base and PIE executables
To: Stian Halseth <stian@itx.no>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andreas Larsson <andreas@gaisler.com>, 
	"David S . Miller" <davem@davemloft.net>, Kees Cook <kees@kernel.org>, 
	Michel Lespinasse <michel@lespinasse.org>, Jan Engelhardt <jengelh@inai.de>, sparclinux@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B4FA100002
X-Stat-Signature: fhhy5geshmh7x9d1k186wpw91y69t48r
X-HE-Tag: 1792355890-590848
X-HE-Meta: U2FsdGVkX196ZUmpMeqA1dPFcd/2Wwby9Aom+kSU2ANr/B3lHRFhhaKR/rd+d1soOBPj5ebMXfRann0RMeH62uQ5oOhuBD2ocKFgTCgj2e7eSaMuD6sxcy9lL+D/QBjXYv6dzBYQRp5Nq/wklK4ATF8P7eLItxtdRPS9fJnhgLxpuP9KQNixjKM9F5sSkbMnf95zsmbgyAkpq2I0fIQP7fLARo7xeSIyW4VDveEBe1bWI5yrWTOqLlL5SSY1zNA1LgrjO0jSDznmRx/5y3mjZuAIdLvsYxqfwTRPvLqRm3wVmc+vGxv9HxImKfpS+W4IXhlkKCMYXSDPDontrBwmliLmaUunRdGUWDPemBasFVCEFHo5SOvJDVib7hgvarVhgF4FAL/EZvfS1VHYdbT2Umtw6fFPJPPjP08PahMP+NLgNKCoABsNjqM/NkXkRPgW+/TnOfgUISMftM5KF0rP3LdOHsXrW98He2lwNlTMF0qDS4db65eUzO9oVTttMEHnx0b+uQxSo+67ToSmZNYjcPDuQuxIF/vySw509i3n04CWHJUVBTf0jbnxNJuBX5UxJP+/8klunl/eERtcQuD0E2uVG8a/eC1AumHh0e5Qka12tgwsyhnAL8aYEd3Yc78YIADPIL+F98JnDaEe6SSyjcQDBpukvdpfybWsoSDiF+52dBwkI6dzNsSGG00I5XUsDbwOuKmYAlBQYh+Aloo/dQJPqQS8BLRsq/GVa2Q+/6F+KmLcXpQE8oeBkSoo9gIrBmyYDDIdptnGK/17eKKtrmsgcnhJfLjBdN/UKtJSZEYT5wZpVtvlx3lxcrCMcdRyUc4ZLKRK53oGnAP0T2VLCwJ9c++hld2iDwR2b9VXteO0WpAle9aJgAqmGcMzK1g3v9Y1hY/qpD6p5HJz7j87uwICs4Y/++bivXstqcbPDUF0LwFKWRgbC6fchqxk3Ser7aVmQ3k9QSCTtUNvo6S
 vXgq7CQj
 gkfoyFxOoReaB4s7GJADnrsTZmWBwVdEj6nFIdpTufk5qfs2rmyNOHh2vA7B+GBLAQf31qaK6qK85hyL7Zk5zs/VnniD5kVeYgDTf7wmkWCzRV2sVEVamNKO7GZuEBXsxHIyzxfuTr5xBUeOH2nbafxO23AkKjg2aZoFvIlwMwzIq0Cp0E4wXCPXAlZgbAvWbtvFqoH6kSvB3qmT40fiWYb+4PjIdiTmlOlxfBkGrgKbUPoc9kec4GVbzDHIlfKf9HkUFvftY8uSWBQ/r7Fp6jRVuVTedh2veMLYXtA3Nk2PPgMUShhJi/HED8pNpxJm7dVI5rfn+QqxwPWL5HVpIRbXQUIeX7kfzRUPahxNhf2Vd8YAnXP3p9456C363uJmW0Q+LL27KMLxa+0hpcBhTQTLvLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, Oct 18, 2026 at 3:38=E2=80=AFPM Stian Halseth <stian@itx.no> wrote:
>
>
> On Sun, 2026-10-18 at 15:33 +0200, Stian Halseth wrote:
> > Hi Adrian,
> >
> > On Sun, 2026-10-18 at 15:09 +0200, John Paul Adrian Glaubitz wrote:
> > >
> > > What about sparc32? Does it use address base randomization at all?
> > >
> >
> > sparc32 is at the same state as sparc64 was before this series. Only
> > the stack moves.
> >
> > I've only tested 32-bit programs on sparc64. The same approach will
> > probably work, but needs testing on real sparc32. Could be possibly
> > be
> > added as a follow up, if someone with sparc32 hardware can test it.
> >
> > /Stian
> >
>
> Additionally, outside of qemu testing, I'm a bit worried about sparc32
> machines with virtually indexed caches. I've heard those can be fun,
> and I wouldn't feel confident about implementing it without testing on
> the "real thing".
>

Stian, following your exchange with Adrian, would you be willing to put
together a native sparc32 version? I can test it  on my Hypersparc SS-20.

Thanks,
Magnus

