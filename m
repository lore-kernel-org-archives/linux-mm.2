Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA16CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 21:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B756B00A9; Sun, 18 Oct 2026 17:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6141E6B00AA; Sun, 18 Oct 2026 17:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A686B00AB; Sun, 18 Oct 2026 17:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25A226B00A9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:12:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEAE7A05D0
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:12:31 +0000 (UTC)
X-FDA: 85336995702.18.006DD47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id BCDC340004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:12:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oI1CuMy0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=linmag7@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792357949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EAVBbyjDy1OgZjxuIB+FMdM7v3vfb3dDBg1zMveAqQ=;
	b=EFLoHS9+BStBw1TF/a4AQI7XNwcHTndIBtEvEYNQcj+m3slx21WMn7/Qv/D3RIOtY+g5Jo
	acIoQxwlqbjsUuWO7EtRYLktIOrk+TilRpg5iRuWATZBnU6/K8Asv6f3uhBSI7N77/Z7Vl
	vlhYF/tFje7xe92j2OI+Hkf+8Fr0PAc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792357949;
	b=ypAs8FMVliAXKd2VxiIKUNDpAJZALiUGsTLyWN7NImltu44PsVOeznJhh9h9Y7ZBcAT9M/
	tZoX8vqZSTBvYa19iQiP7TZ4JyWQJ0cqqSFlI7E39TCJtIJ0B/+JB4oJjJNAdcu7HIpntG
	OwREOLstIlkv4+rAK5fmO90HAisNiMk=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oI1CuMy0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=linmag7@gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso1631352a12.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:12:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792357948; cv=none;
        d=google.com; s=arc-20260327;
        b=UR5ADzWDiKrY2GqJWnsQ8zVM7DbnNHL724s/ffU7gzhiikOFys9i94SV74CGy7ehPz
         mvnWTkct4hwFNOOW9Za3yBhuyeMOcGjcTPzFDfTsiy3vRMoi25S5bqruCptPK96L660x
         QTLYqeUi/GsOUqKSGgIB84ew1d3todK0YxHzHzPNz0Q0PY541ouoZLMX/LJRgRtXe7AT
         eq0I4Lp6hE72HAgldugbrSvI337DEOYQaL6MKNanQod/Fa+t+5VYtsJNpaOjLuIX4g/U
         Vg+Jr+LNKR5HBY0Ud84QSL0No3GGWDgCD95qKyGSiO6+T1jtRvDwREatwCOKge1APwc6
         eQvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2EAVBbyjDy1OgZjxuIB+FMdM7v3vfb3dDBg1zMveAqQ=;
        fh=YipEfTMh/p6+W4bd6YkpTBMM7A0KpjnThPaxvFiWqX8=;
        b=iJ+EWMGCU6uBsWqHiV8zHjYoQG3oRXE744o58OlHFdR6UII6vOGLyyWdBPtf06uU0e
         tTb2ZIgplwV+sLoC3okj9tzj1hxK5JQRahUn821yWTT/aMOskssZRU8NbsiRnXJkDeOK
         r3aNKSRFnmwwcpOvlxcP9b1BGJnoIHN9DGQEOoTXsU/aQ5vJAH5keuIH7Ar6EQHn57ND
         zbs38eXyX23jMZ3QZH+sfddbWvCdGXM3wT7xFB4t/7xdLfXQL0yg4AUxk8xpTYo/jfqQ
         45/EX4KuqeXA1N6Y1FmENVsvDp1/ob3o6KCvG3caPK5DIWOpCFHNKUc68qwc02pD18mU
         l31w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792357948; x=1792962748; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2EAVBbyjDy1OgZjxuIB+FMdM7v3vfb3dDBg1zMveAqQ=;
        b=oI1CuMy0tQd1uGBsUTEq/2K2pgnYOnxszkrdlfjn9Kz2c5/IZNpgLqRGjHFpSdrLyy
         HvMvT4p/yMo4Ypsq2L7BD3vvMlRCD8uyfSNXREXWpujQPG6C6oUyN2lcpuAAlPbdJwtR
         jFfHuSp77f7IRKOzGoIPCFW6SPlJWv5kyK3CrMj7X2Oo6UYw1xrH9B9YKWI3TtdFbf5k
         7IdlZ1wwexhMg7hr3xxTxZZZwUJgi1SvU1I3oQlp4gAG6aptV7h1LuVvwXI3Jsbv7W7P
         3VYr3PtUySC+GKKb1e3Uxb+kIW+LvaVCmiQYf7xRtilXww6XmRh16KfuBEcGx+XG2nHl
         u5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792357948; x=1792962748;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2EAVBbyjDy1OgZjxuIB+FMdM7v3vfb3dDBg1zMveAqQ=;
        b=digNflkDqxOXYH7f5PdPPmBt/v0PoLTfUKUaIA+xVlQVEpNK5be0NpkgcY1dDrYU4u
         P+/kpu5tQ6+Mo5xJTrKIbhYgDKMtXUaS0zPPiIklUE1vflYVhLI91hnLriMe6cuVTTN+
         0kEgxJ/gpQnX/ajdgmLajSH9tfXnF9VG51K7AQ6Fj5kbwyXMVhJB2y+R0hwIHago2QSD
         iF5RUHfqTkgerbMu/PiIi6KZQxLztdRwJVOAv5erdp1cxyXZms7DkAXg1SrmygSp1IRX
         UDoJ8kOS2um1cAtb6ONfPIycsJJykz1sISkAcmU8L2Uhjq8GGDzSbEM5ki/xBKXkFwGf
         NZLA==
X-Forwarded-Encrypted: i=1; AKwUvBwOwfP7VJ76iE8npqFfpMC3sSzGoaKNjIbviWelppOFBlcDEoRsD6rNS6ifZNEVGb6HC++aBBxreQ==@kvack.org
X-Gm-Message-State: AFq9FYJ0/bx8WXV/VpdrOEFhvmQyUgANzmqFWHFUNlGdhBymoo1xUKyK
	PkAPvgJ8WQnUa8PGmJs4Z8IL9aHkK9GUP5c5wIP7b+gUWZSw4w8MXUA0VWzB3bhPsNAm0y9A0JI
	wI74ZQA5inKushFwwZpOQOS86pYm4icU=
X-Gm-Gg: AYBFou0kqV236TzYDBHBj/EidShJPDL45e9PMO2LXmSZppmtH0WJc44I4tbg4mep/3s
	A3nRm4T8RfugpS8oHEjPxuyCrNUtBcPh8suGK/4e7H+yja1IBZjEbFSYKhn3xFxWJ3ezxxSjFzY
	eAgRr58fueUGBu7tgPT7uBcTClyOK54nSsgM9ZAg/WW3snrFL+fLStKlNb0ibpUBtIAuCTS1MHV
	ukCpogb0XPHZ+E6MTt524FoLDNYrSY480Zfclnx8fdHQTV7U56KPC3kebxQ33ZyWkojCSvaMt54
	m0vr/P/PJP2FY62jCXzVtbzbTAs4trLDqQY7XmpEwbQEXJkCCx6las9cjhxbexjKVD1roFUIUXO
	tOU5lXFG8Nb0b+C7b+o50wo8uUCsiw6K7LV/9iqzcOMrYmN8Rgeri
X-Received: by 2002:a05:6402:190e:b0:6ac:b9b5:8e8b with SMTP id
 4fb4d7f45d1cf-6b3a8176960mr3673422a12.15.1792357948108; Sun, 18 Oct 2026
 14:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20261018122734.2594904-1-stian@itx.no> <e3068b5c97884032e7cbd12c78f6b5534d75e30c.camel@physik.fu-berlin.de>
 <6e2d2b2b7aa4029c261831016d8b6c40bc335341.camel@itx.no> <4f7dacd9b4cf0a43209be84f2408e6f7e033fd3d.camel@itx.no>
 <CA+=Fv5R31wpXsm-7_H7ZR_U4ASubis+_zWKotpj2iNeWW_MTUg@mail.gmail.com> <d233287d5dcb6726403703a7b923b05a8134cb1a.camel@itx.no>
In-Reply-To: <d233287d5dcb6726403703a7b923b05a8134cb1a.camel@itx.no>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sun, 18 Oct 2026 23:12:16 +0200
X-Gm-Features: AclHuK-e2-z8ormz3qEfmYHF3HvTKszgUZZKRMKr4teyS0FgOEFwplPC8KtpOVc
Message-ID: <CA+=Fv5S1kF19rOgYjYoMP51QBvhEng+HbO9wDdj7Ue8rVrRO5g@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] sparc64: Randomize mmap base and PIE executables
To: Stian Halseth <stian@itx.no>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andreas Larsson <andreas@gaisler.com>, 
	"David S . Miller" <davem@davemloft.net>, Kees Cook <kees@kernel.org>, 
	Michel Lespinasse <michel@lespinasse.org>, Jan Engelhardt <jengelh@inai.de>, sparclinux@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BCDC340004
X-Stat-Signature: 53ocuq3tbqtj3k1bpj3y3g7hdjhj9oa9
X-Rspam-User: 
X-HE-Tag: 1792357949-441421
X-HE-Meta: U2FsdGVkX198HBLpylL/wEXhWOOJIhJRcCMG0wLgjgvU8+UtDFPugz2DqoZrTD+MrJS8DNEhlkI8xaFyKOk1AzRLVPMt2E5l118Nr8xbzrqirbeCW4evymJqj3jn4YQIpWI4QAKWXMoS9Ypnoa2x2cqDLhv/BeQgWLfbV+JaUM4OUgiV9xJDhwotNr/dfDTlHcFKiQWkXG68tOt8dfnuUMI5IyE3kfHb9mrQe8I+luIghtUzOjcdC3XDq8VH5iV4h/SAz60mDMOYPstAcrz96y7kQ38WWrwPTZK6rk2yrcvqHGMmbUkZIm0U8Q+qn9obCaq4nR8D3AvKFzJvYCKU+aEmnzEVPIa1U9Kavr5UHGAbKm0Gav8Hnkb5CgwdpPl4EOzvmvCM02820M2ayx1Wa36wDEjpv8dmVL7EHGRmsQ2AmFEg2XkQD+LcgtskKOF4POAQtVkMXAYqVkyEolXIQK7m+secqkN+QmWNM8D54U5yiqGWQyYZi8tDcE46ibou6kKujTZJ2FfF9b6fLhroEcpESFSJ1uS0sKW/NtlVgw0VVbzVc7/O9mlxzjZxHzVcXaVJJ3PpK8LfJVaefPfChPTyB7B7Gl6A+p1LXx3ciXc/xZAgYV/07Tp0W4N7fmEe91OCCW7DXZQFqTpmiBTLNW+ArO3iKC0buXV4U0BJivhCbjblnQL2uWKEi1J/iryx8vwby9w0Q+mX3s2ZoipZgFIsudUrKllhtNv+2567g4HUSBVbmi3ce3ezgr9jyB9EnvHxdr4ZqahbknWCpp53zEQb3jcdmf1Um23yWgn0105hr+I/Ue89ExZfSsRbKefueAT2BicJDuZucvfSYkm3VrcV7HSaTfTCNNJ3GufrubGfawaIyWB4tvykCbsA7xQ3K8gXliOkp/VoIMXXeztsyaA+FH/zoV5W2m0fp9SWJt6Zpe4QoUyUq9JS1Tp9YB7d5xvMTNhuOhBTY4eOPwA
 sqXr+b6X
 k6tBigA/Vh0fSCDB2Xswh31juWuO0dgUdhYR556BcCqBqONJbtxxDgwo8xLkqsQkZUL+3laYrnqtk4IR/5yoDttIrbmA0VHhRXJ6Dcq/eEdGjukinXtdfZG+9JB4O/LN509qW3b+eTxsQAMLmVNz3CsnPZfvgXqHPJlsff8ML+gY9MdcxcDhJczcdY3DFujw4vrPW3Nl92683tPOcJ/VgZHJI3fSuTxZTPkZCEIfJaq5yM+BiL4g2D2OlR/2kNbttFwpPj+CDzpxIqlLk2Sc4fQcyWlRb29w7sIyafppdocmK8wsZrpdVfPmB8HM2HOHivAet+rEx3n9tNhhfLCsPKTTT8dhqlU3iOTIWrxIQiHL27CmRL6pTAFDK6xKUMkryKvT9jrkOlJgL54xbbVNW2RGkNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Stian,

On Sun, Oct 18, 2026 at 11:08=E2=80=AFPM Stian Halseth <stian@itx.no> wrote=
:
>
> Hi Magnus,
>
> On Sun, 2026-10-18 at 22:37 +0200, Magnus Lindholm wrote:
> > >
> > > Additionally, outside of qemu testing, I'm a bit worried about
> > > sparc32
> > > machines with virtually indexed caches. I've heard those can be
> > > fun,
> > > and I wouldn't feel confident about implementing it without testing
> > > on
> > > the "real thing".
> > >
> >
> > Stian, following your exchange with Adrian, would you be willing to
> > put
> > together a native sparc32 version? I can test it  on my Hypersparc
> > SS-20.
> >
> Sure, I could do that.
>
> Ideally, I would like to get this sparc64 series through review before
> I add anything else. Could be a follow up series based on this one.
>

Agree, no need to mess with this series while it's in flight.

Magnus

