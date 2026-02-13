Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9272EF99DF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 21:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828DA6B0005; Fri, 13 Feb 2026 16:37:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7276B0088; Fri, 13 Feb 2026 16:37:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E30D6B008A; Fri, 13 Feb 2026 16:37:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3036B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:37:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF1CDC21C4
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 21:37:54 +0000 (UTC)
X-FDA: 84440746068.11.1C790A0
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id ABCA3140004
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 21:37:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VYCrWSxU;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771018672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGNTntAipGaFdyX8UZHJ7UbS6vmkvLFLq8n4JuySALg=;
	b=h6mcdzKfAa62SqNVX9WFySltrqUdqlryM7yP/3AfrA96oZyc39f1miXC0EeOrkM7MGoz2H
	stCBj8m0j2fOpi6ZVtH7qu1Yo3EkcAuaQ9+4cQX+VQh4QuVZSRXaQfd8XI25XiqycnN2hb
	X3mBR74ZjcokIsbkOAku27gCO8OAMiE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VYCrWSxU;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771018672; a=rsa-sha256;
	cv=pass;
	b=ZAoa2S5hsq3SJNWB3e4ScbxxdOLgBEqgUF7lQ6ABYrzo1lK0CHN7BdtOCWVnGsHVZ7r4Fq
	pOJsu/gLC2j8c6zUow6fS3uFRkUbGS0PmFARYY0CJBL/QFoHRTiF6ZxXdRTqZeh74Qm5x8
	20wrKbMVPvgEBiEN8Ho6SlgK9/YeKOE=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4362507f396so1307753f8f.0
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:37:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771018671; cv=none;
        d=google.com; s=arc-20240605;
        b=gPagpXPTJHJORWJ8dYmzj1JHBz0Dvrd8gaEOf490daQr6Edezum9ebQygs4w0uDTx4
         JQGdPjd4aVbga9/wpQRrr6RzWKIwNjKpPL43prIPhF5ZkFOq4N/QRzK+jSieBVOnN9GS
         Le16YstZwZ1yab8dR7YJnY52Ih1krIX1OSSDOF5Bb1qLYl+hjKfiKHH7mTOtMki/apzk
         jr5tbziX5Kqm4o2RGCqlIUpaLCfs1PN8jEgAxYNmUJbZYKTyBMiLkNswFlvPbYRECWtx
         xA12repfeGQcpEvAoUiqUEK4G3fyNJlh1bq+293+ZBluRZlNfefPvmtHH5dOCYv1tI2O
         fnvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tGNTntAipGaFdyX8UZHJ7UbS6vmkvLFLq8n4JuySALg=;
        fh=EGent7ca/S7TvUbUdXBluMyg3NWjrmWSc0WKWZ7/1TM=;
        b=QletYwkCpiSiR7eDRybi4D1XwDCJpm9gpF4YqxrEtSzQjNQffcTyqCj/d7NXkHumWH
         HaJ3O4xobCJpynm9RiV2AWXIDWRHiKwwUx7QbvTxgckhIYOHTzai3Wlkmm+aviDiljgv
         SLsz8MMFJNZKSr4xWHryVno4b/5OUMxtfMMfIuaWxhkd7Nh8/1bztn0LNO721KAFbXXf
         XT1daKedowPWD64I3KqvwULp62+Po0eUXr0nNf+//K4VdCYCPXBbhD9+567pf87mFRrQ
         HtLS35vUl5diWFzo/CwCYLSDsDmqaEzUIMlEuRb8lG0xKpSyriL7vT5xJ6Sn8ihmiGjL
         mhew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771018671; x=1771623471; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGNTntAipGaFdyX8UZHJ7UbS6vmkvLFLq8n4JuySALg=;
        b=VYCrWSxUFgOQnKcA9YHW8PYQ/IP+rhbFPw3FWXaXxdU68hTkBCgtBmbAp726PkMM1/
         cVSUZuvFbKpmjUVSxYvYRa+d959ELclx5gN0GFVJcatPONpwNvduc64OaMkWhCqTcbG1
         SkiEF8XK/iEoFmaV+nlDIGNkAxSkCjcnkhQTttlR03cH00TUkJL5XDFRJtxn34NDgJxu
         Ylglo78RtopVRpK0uH3TlZvRxWzzBPqFtdQzSaTMHggxPJkPgWsaiJLashdfrLLWWD2H
         CC4R98pSOzkx+XzPCsDLy6dnP3C1QP3CHB0zeRNpPx64d5l9faY2xfY534I3YLI7q+bb
         BBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771018671; x=1771623471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tGNTntAipGaFdyX8UZHJ7UbS6vmkvLFLq8n4JuySALg=;
        b=i8ufupua3zy2nvQVBSjOgo3ZKRN9VGTRQLmZAMGPm+8ytEtLXRqKYiynL2mOg0kHFM
         jeJ+SgPqeq9SkEvUjJrwR1VKrLyolQyzKjTe00lluJkO2nAeWURwk22y7PRPm6zoFWzV
         lAvgDMqiPfhGznbul3d9OGxtfuaC0PCJFTWZnbpetWrE7Pi0vkF+2X6NmZt0qyQM7tAe
         jDby2S2O8DwNqoR9H3R+pKBBCvF/9d99c6Y4e/0JYywjKLeKv4Y1+fQuc0LsHu1b79SE
         73ekWtoyczC31By2FJbOGXieMxw2Wgy7+7JJ7kcYJWdps+H4OgpiN5OzPmiQ7m8UPyML
         Y3ww==
X-Forwarded-Encrypted: i=1; AJvYcCU2PNuPYJIkF85wOOJHXb2wtZQrv0lc+hCg+qaOf4yian/m5oGwqw0z4r80hBKaf7Axhm4FyHWyZw==@kvack.org
X-Gm-Message-State: AOJu0Yx2TtiLQQ2PxXP35D9gj+0OKODSXAbl/ynCs5hKlSjU8alkQGvR
	Kv3CzQPR7z36UsgnAxAplNbEb/3CZiPUivG5LYNVNVN/OYnsiHoykeRF0S6SJLQInbnNrahNzA0
	PXt3L+jKtaFwo8ZWngo7JOzkinLgj3Sw=
X-Gm-Gg: AZuq6aJ2FxZVXn92aQWRcX3jceC7EGMhVrDZW1k+WVn1iK7vmID47JABScW25Ap9d5Z
	oyHz6/O9kmHF3k8hZWMPi0XV7c8zP8a2NT1fE9nUsgYqW3RPeL+IytPrlWLQYndzNzHceKZC/26
	yHtOgyQtKm1S0pGwYOwtZMna+DKL4/e6LhzejFZjOcegQ8nS/xQSoDroGOTvagQc8DYDWN1jQkS
	GQIVdnkonNsksQCVx0XrHrmHdmuPCZ0Dqhb7DAFtIxveryq0GnuFlY7gMxmjeGJ64Ubk1M3WCpA
	3LN1WvhBb4Sh06HlmvKQBjx93Hd5FcDdPYWiuamKyBtk1MIcUTiAYAX4dmFbFsMg46+Lq4HamV7
	YDPwrhEZhdGla2z0Yuz87NMaimA==
X-Received: by 2002:a05:6000:310d:b0:437:7589:100c with SMTP id
 ffacd0b85a97d-4379793f40dmr6215492f8f.58.1771018670782; Fri, 13 Feb 2026
 13:37:50 -0800 (PST)
MIME-Version: 1.0
References: <aY3+Raf8eZqipCd6@e129823.arm.com> <CAADnVQ+D7v+sGFFyTfSxFSEEcnGV111NeSaVtASYHfP-mDnV4w@mail.gmail.com>
 <aY4Vipl+4rGa+u6D@e129823.arm.com> <CAADnVQ+ad1Eu34hS21HNLgzA5eeFHMvQmoC33xKpP0z247MaHA@mail.gmail.com>
 <aY74MqGV4A+kwsQM@e129823.arm.com>
In-Reply-To: <aY74MqGV4A+kwsQM@e129823.arm.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 13 Feb 2026 13:37:39 -0800
X-Gm-Features: AaiRm53dkt1PoQISalig28Fltlt3-YYJ6sDHOyTEu5Ru6hEECJfSFjcsAFUNZqA
Message-ID: <CAADnVQKAv+MRNrK=2MmEFKcB0FkmtG2pchdp35xo1ya-ujqVHg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-mm <linux-mm@kvack.org>, 
	bpf <bpf@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, david@kernel.org, 
	ryan.roberts@arm.com, kevin.brodsky@arm.com, sebastian.osterlund@intel.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ABCA3140004
X-Stat-Signature: tif8n5o8e5c5s41b14g94f17cbcx8rrx
X-Rspam-User: 
X-HE-Tag: 1771018672-25912
X-HE-Meta: U2FsdGVkX1+qkU7UmuEjlIJtwVgY+2S2e815QIeofCODs3upcmWKViktkK+qy3kXhJoG/HkZzF/4wU5lc/Aks+7CbMClUgGD6rhEO33wmbH7jutFWEKR6AdK60fQEJSe9aXBC5xJwtmvHhSCPOuUQyMnYHuTmiAHRgXNME7mzRqXMr0bekI4l6UJ+yFLNQ4yQn/D13FJisL/oe+MUUeJ2fHa6q3511XC8qrqCEhssen55+IutnEAlL3bZXjMiVbiuPLy66b7WSlcwq5lHiTZAZnDTH+F49W+RuaWEkUIsHV2/AvEy6a4pxZG/XBagdzHoXWyM8gUip/rpJP+AFaaiMSdNVF/0hGf/kfCJ42ZVipBu6vN9su0hzZQoe5+suZlhFqGiJH2Dp2YYRjQIRUxsFcNEe89HmbB8VJsrkLpPdpD7GszXOe7VtSYJ/QUQIySuXv9nyPPmE6RGu5aVY5mLaC9G68pxwim/2Ku9qS0/y9q/m7ClGfx112f+9xXVL0YmqazqUv1xQ6ruxMlbIebIbIqcr9K0Px9/tY4V642F5D68F+c0Ryo6iqX/r/hU0/UjW81WEBjz3N2CcswZkJ9Bcwjg5fhOsdy8wVuppSJWAuaAJwMbhqmKMVoQ+BavZZVWmvhD7FHL1D0xZcD3sy75Bo+0vqW8pzagycPDhwXqS4DleW2lGfhOVU++dZcjPvIP78kMpUssHnUFhAY8YSpZWdQhUIgmy6OpXxehrD9ZMUmQj3CtVE5tIDzeg47lHiFGvYBeicy1jUA3X6famPR8lYaR4DHimljzrzaWkGWUaE1SbzhALaZ651fUaQ+zwLMBpZ/HRdgN+4g9EaG4BrYnsiBXn9cnber86DFqkI3Ca37nankvG49kLV9y2kHr6TLW5f2JU4/0iCzIqnDavQbiYeZwSKwxfzQB48aIEuNIANibpa0VRcwipjUNZgdlShbWE9BJmxRNyEvKiFxsZN
 U1SOMdSm
 wS4ORZhI29vdoJAC6wkCMHrFBq0v9NnJuPyr+dqfHMnrok423FUIlUS1vuM3eEMgaPIBJssA7AIGTwFW6FZyzOrUAmEkAjWuLMcjyaOQp3+MWqFJo4yPNeQSnhbKUM2uMSntz1Rzg0tqOT9iZqIjMPqK41G0qt1V36/a9+J0vWTN1V55qDuJ5M0dXzHtm6roN40PmV6OwGe6CXJtAkohLr2I2wI05yCkl7m96H2pFRRFg/Odb5d8OBjXU1/KxpySPMX+Q6ShcUTP1RYnarIysDhvd/PWEIkCMLKhEy8DXrmEfGNKtd//haPOiNXLkWyOj4XjGknylLxPiu/FJxXrNPB364hQx19uYvhBsjIlIyGNeB5fKb/EwlD6ZiIEq+RjWRbApTSRLCUirjcEPeTzT2Ah/MpQahY2zL4Gul9TiGSaUwXYkdxZEys+OIafa2uk+uYNRhY2LNi7j5Caxj3bcYuOGgs7sitX8+e7vknkBWaZ5cFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 2:10=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> Hi Alexei,
>
> > On Thu, Feb 12, 2026 at 10:03=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.c=
om> wrote:
> > >
> > > Hi Alexei,
> > >
> > > > On Thu, Feb 12, 2026 at 8:24=E2=80=AFAM Yeoreum Yun <yeoreum.yun@ar=
m.com> wrote:
> > > > >
> > > > > Hi all,
> > > > >
> > > > > I would like to propose the topic of eBPF isolation with pkeys at=
 the
> > > > > upcoming LSF/MM/BPF summit.
> > > > >
> > > > >
> > > > > Background
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > >
> > > > > Today, eBPF programs provide powerful capabilities to extend kern=
el
> > > > > functionality without requiring modifications to the kernel itsel=
f.
> > > > > These capabilities are largely enabled by the eBPF verifier, whic=
h
> > > > > enforces memory safety and other constraints to protect the kerne=
l.
> > > > >
> > > > > However, vulnerabilities in the verifier have repeatedly demonstr=
ated that
> > > > > eBPF programs can also become a serious attack surface.  In sever=
al cases,
> > > > > flaws in verifier logic have allowed malicious eBPF programs to b=
ypass
> > > > > safety guarantees and compromise kernel security.
> > > >
> > > > eBPF was restricted to root for many years, so the above is simply =
not true.
> > > >
> > > > > Representative CVEs include:
> > > > >
> > > > >      - CVE-2020-8835   [1]
> > > > >      - CVE-2021-3490   [2]
> > > > >      - CVE-2022-23222  [3]
> > > > >      - CVE-2023-2163   [4]
> > > >
> > > > None of them are security issues. They're just bugs.
> > > > Like all those found by syzbot.
> > > >
> > > > > An RFC series is planned for around Q2 2026, and the experimental
> > > > > implementations for eBPF isolation with pkey and pkey-aware memor=
y
> > > > > allocators have already been completed internally.  Using these
> > > > > implementations, we verified that eBPF programs running under iso=
lation
> > > > > successfully execute several sched_ext applications provided by
> > > > > tools/sched_ext, as well as some bpf kselftest cases.
> > > >
> > > > The stated goal is wrong, hence not interested in patches
> > > > or discussion at lsfmm.
> > > >
> > > > arm has a nice hw feature. Sure, but this is not a place to apply i=
t.
> > >
> > > That is correct =E2=80=94 this is a verifier bug.
> > > However, the concern is that such a bug can lead to a security incide=
nt.
> > > Not only root, but also users with CAP_BPF who are allowed to
> > > load eBPF programs could potentially trigger additional security issu=
es
> > > through such bugs.
> >
> > Again. They are not security issues. cap_bpf is effectively root.
> > Just like cap_perfmon in tracing space is a root.
>
> The argument is not about whether the verifier bug is a security issue
> per se.  The point is that relying solely on privilege boundaries
> (e.g., root-only loading) does not eliminate the impact of a verifier bug=
.
> Therefore, leveraging hardware isolation to further constrain
> the blast radius is a defense-in-depth measure.

I hate the reasoning that bpf somehow needs this hw feature.
It's not. Look for other use cases for pkey.

