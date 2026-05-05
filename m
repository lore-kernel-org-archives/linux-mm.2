Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697F8CD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D056B0005; Tue,  5 May 2026 04:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FDBF6B008A; Tue,  5 May 2026 04:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC7C6B008C; Tue,  5 May 2026 04:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8CD6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:54:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C22F940469
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:54:48 +0000 (UTC)
X-FDA: 84732755856.23.40C28F3
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id C66F940004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:54:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MLFd9E57;
	spf=pass (imf12.hostedemail.com: domain of rosenp@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777971286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wdfdluDfOc56C0VjHJT7ZZqNz7mrj9b9II6s2fvnHA=;
	b=o/IAxqDdnHgdgkdah1tcknoZ4DDo2jO7k7OFwUoAVTtzjlA8ZFdV5u2RNdjyxX7FZDTcjD
	PllocxM7DImg/Up/dvaRcrR0CYLd0OXcAyH+IUGGGbjRUJUpS2JOmUxCVTm4TaCfziUASQ
	cg+t7u67kpRR6BtPHUSMocDUD27Tb34=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MLFd9E57;
	spf=pass (imf12.hostedemail.com: domain of rosenp@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777971286; a=rsa-sha256;
	cv=pass;
	b=RnJb04wfbcKr0RzHY35HM2AL9eyWEuWa3lwCp5FgBuNkzEYbbpP56i38TaICt0S/12D735
	t9/pOvByClBqns6Gbt6HlWLOU6RWWVof5x5DzG8W1x1/fqr+PDRYv7ZNLY6TnN6yx1WH8g
	eqt9pohGAHCmSzOe6chRTi7gK5CM39M=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so6200411a12.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 01:54:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777971285; cv=none;
        d=google.com; s=arc-20240605;
        b=T3caeb5c9eV+MGnvqebqd3XKYd5mIZSTEEQ122nfNBLpp0KVCJtLhtClnvPO179nhg
         0IBU4QDR4xQ5rjDvm5B6UXzlII21pqVU1cjFJNIsyHpP50yNWW6XbV7mzlx9KW4iZgLU
         J5zohdRhdYPwj6gElIbRij1VrLb4ISlR7s9F9KbP6X5BwAPu1fOaIrdyU/uRBperd6pm
         ONpSH6Hx+AP2rNktoCtIS8VenSzsf/t0PUjLI156l+B2z19R48U1doOT5kKzJYjabvGS
         xQy4zUz7gc67+xO3CGah0RHXpJj+qYoCAx0QqjBYeJmGbrOQE47rDD4eTfY9vcENgjoD
         ymig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9wdfdluDfOc56C0VjHJT7ZZqNz7mrj9b9II6s2fvnHA=;
        fh=+7l5ZePh2uEOQeb0jUJlb70iGG82g54gV+LCEjmmdBU=;
        b=A7lr+OjtpldLdWF8Fzt2o3Jf6CcKMqy252fgfvkhI+rMJvKccHaYaDINhHIG0S6nQQ
         YW0Hla3srUyL4BlDmioY01zNKiDZD9naT7EQP7L5Zb/H1aWKfJSRLFACUY8tMjGu+0+l
         S0J2TRMyaM7Z2VbB5ibFx7JbNHdmCDYbE9bnWOoIRlljU+3IAez2I4gB7xKeq+PXqGRj
         Q0WWthOimClq760jz1Gfm5u2xyxAf8DzCrOMaZ86rVlERAb3/4+ICDzXC3yg0ob8Sh4E
         xnGmE4b5kL3zpd1KCV2LFHwm9ekzJbEsLvFNWbCzeGMhPlL42kY25fQsgtQBrggYP8TH
         adhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777971285; x=1778576085; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wdfdluDfOc56C0VjHJT7ZZqNz7mrj9b9II6s2fvnHA=;
        b=MLFd9E57o3/VID/Fc3xn/DLnfDusHTxs1rFOL4giGcPA0oKs72Xf9YU51z+1TC7iT0
         Mhju4eSrjuD5A1+5IM1qr34b6Ipcq/i2S6dWe0bCSz4tri1i1rpVyM5jrHgy+FxsLEhn
         IH8Tr+QrxNdlEj/zfC8Dx2W1Cf0Jpp0HRP2XvRUjH2ct4BKhfHkIG1CKNUMbSPljRcU5
         z3Ec2OgqWbu9hMjm77oJALMb9qKpCMrpwhu+acH60CQMKxqfoypdxoZAGqh0DsuRcXBJ
         5VDV+6U807kPsNpXdamBbICV6WH74vRuGcX/olwC5IROYTIs/3HDjCGfUhmyPZHFQkOP
         Y+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777971285; x=1778576085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9wdfdluDfOc56C0VjHJT7ZZqNz7mrj9b9II6s2fvnHA=;
        b=ZbjDTmFr6z8GcPO5wursvtEhshlTEoAR01Z4mHCx/f3E2QJTWt0f4VqYsWhSQlojjl
         lJpaL2NLM4wEASvg7bSHtV4BRW4fbtZ0xC1IQAbTVtes3lsWKWFouS5TguS7WtLi51tB
         xbImkIedvbj1TGHLnqQ4vzBhd8gO3bywpb3C+UczO6Wh3eqUq+qXNZ16ajuPkRnoYS+a
         C1gqTPsqdRwnOj4QF5SENv4PqjNbdlzUNsG5bsNindPeINxPw3lxnPbdyyxBHfOkeJgA
         pdA5/ujzZP2fR4sQ4yLZxdERIXP5tLhqX9TNRnD2mkKWDlADeOARiqp9aC9uBvc0A+9t
         d/8w==
X-Gm-Message-State: AOJu0YyWsGX82p7Ex1NZkZ2nt6Wc0e3efxExCWvfejW8fWZIEJYkpiNU
	bGa8Hu2586afHofD0A6ar5Hr0NxjiCINoD1/8wq7Rnak2Btnu/iqEG/f7Cg7xkBf5FV1xj/d1nR
	6WMnt2DxfgZkHkdpJ8eQXTPN9VDULNzA=
X-Gm-Gg: AeBDiev2V0dcWJm+aVEYhtJMc4HX6m/8ySxmOQsNGKebXgABSUVu9LNY2w+lOKU//6b
	KSYr/ZqIi2xUfRHW5fSad9sG+Y7syhsBzbbBUhz6OuUWALYJMXywY6uHm24UHRsnIP2FcMTxxiW
	xt/gMOicPlqVX0cQjfOvCd7vLI9wiDEGa4JEId62TqJzwR9Rydp8FaGTIbP3s7N8SeB5yjbCIDN
	dorUsQESCqtNq3S2E3i5jJJgT2CRLThxywVOQT2/lBRuFlhcvuBXncl1lnY2NwCadJgdPEr727F
	xwthaQHSHx+I+620GZUQ+2f7XuCJc7cE0mTTkIGt/L5QYXYMbYcxc8SPGOhYFtmmDUtxoKrIIE5
	MxKrpAtNSbHSVm60lmCnjz5DZi1oCb4lY7xoNhTFpqgQ8Vt2eafk0tw1xKR7aulWnHCOC
X-Received: by 2002:aa7:d549:0:b0:67c:89f2:ae27 with SMTP id
 4fb4d7f45d1cf-67cc392dd47mr866648a12.9.1777971284861; Tue, 05 May 2026
 01:54:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260505010112.645361-1-rosenp@gmail.com> <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
 <CAKxU2N92s06-L0+e=KZ7EbtU50tCpaCk2MYJD2xTFEHEsAhXUg@mail.gmail.com> <df3e889d-ac8c-4d11-a5fe-8ed2769953f0@app.fastmail.com>
In-Reply-To: <df3e889d-ac8c-4d11-a5fe-8ed2769953f0@app.fastmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 5 May 2026 01:54:33 -0700
X-Gm-Features: AVHnY4KjRxcRwGciP2xMVdMfFUTVoMobX-8vJo-rhK4YVGeNq03NoVrlCgH7a04
Message-ID: <CAKxU2N_moR8bs=NLUcW054a=oHB--4i+M5XKCBNF9LskYcjAhA@mail.gmail.com>
Subject: Re: [PATCH] mm: move phys_mem_access_prot_allowed to header
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C66F940004
X-Rspam-User: 
X-Stat-Signature: oityon61j57ydec9q8h3nw9p16syay8x
X-HE-Tag: 1777971286-97539
X-HE-Meta: U2FsdGVkX19fqKlYnuauuLxNg8RiN6/NdM9KePTwDkh76oGgAnOK7v/6+KxGkk1w9zrPbj0horL19PXfGuWXgu+O+YlZxCAsQOuD/pNyN9Khh++J15r664zmh/mr4m24JD1/7HEEcLIp0XMMbkNA/NS0iva4wvhQX4uHEUfdbi8tHGrA2oZBG8NRJHtTVnlg5rcSS+wxu8sfDwLkY7O2owH9I9QI+G0xjg+ub9kxYrLJMvWcr5LKfQO7nuG/UTdP07l7DUvxhQUAuNACg6JWwlkEzLmPz1UOmv02zhcyg6q1hPoZ9nhJ/mZyvIybyOqyrDhMSMw0kvAPrZLgMkHPzFL6SOzDwBYKWnvki/GYIBrK3D6zujNfNNZRliSulvR6L4epqFl5tC35hLwWEVKlsRPPO/BB4cM2eHtCkQAoHGYK7z56fCB+oz402HsWTyRfd8OyRj3pyP3m959qmCbpMkDbCCRGCx9705r4Apk4wbuDuu1RaY5EED/6B7v27GlUuvob2Xyh/Zkt0LcqLkjFAepoFqEuRb8PjWI9Ao+N1nGjm5THAYQ8KszayxUSpl1cY6ZvSLyBtXKR4R37B5qd4ItBQ43thENFmk/Ej1j3ZSY7eqrrk3z48iiT0L4L7ebQ0jmkI641LicdiS5gVJvJu6aL2vHZs+KrqyCkufOWWs2gF+QBvpORmsyNIRdrdwKMlGI/dX1fIxJzm1DgtI1qbi4KwzbzzP3meh1UZzuVhiHQy34qfykyYukWIfdILyewLCuoPoFv0Bo6lTVGA7vPshMws2/PvJFUyNvWY7t5TihmQXVZI44fWFeoSH2b7dpkuLlFEUJelD+q48mtVSalDua2sO9P4DjtNCyJRo/uT8EBV8je1eN02lD4pIeTIeWyen0ReeZVrgROz4rsNwsfUBNfQGW0chjjVl8HF3/M/FJUbxArBMPAo9T8cj+S9spAAd0LiPV9k4oiKD9qffC
 nDIXT51W
 9Avm0cYQ09WYEf4j9Ce6l3LF7AH6fed4gKmJVQXtfXDhUaiR3i/owDag3FTZFVZ/TP6KfsUwQ7cYIl4wgxBwY8AFzg5mnZ9tTvWqsTHlbt8ErQCbevK+9IN2eRB/UoE3ui8Crbay9pF4HqVfLptiS5HvsMG7JE3SypHItcTJ2dQEUI5+JdU4sNAmPpdsjR6POQqlcEhie7qha22RdMX3KNsqAdjiPEldBAVLwtHkpwLakh0Bh+CYTszpNPkN+lEBuJ8zUvccnxSwUOGEVugoXlLmA+qiXeWpu/Jpm5hFKXXrfW6PnPn0sZS3vWx9cDmmYe9+j8QnlAPZ1GfySNMv0rd633N7Wi6SSNzkdPCcjR5OyAxgZx2hdUTULpmZa+OZ+RwFSWDMPQgB/AUbCM8QnZnV4Di5T6WWFs/R1itJl2ZGyO3Ryd5E9a/q7iZIG8eNpGGef3pbZf1XxNmjtPjEAoK6MVB0n8d/RqaLSJxesc9dqi1z3Eoa7Z80wPvqKzqrUsnO+bos57N2Go5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026 at 1:29=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, May 5, 2026, at 09:47, Rosen Penev wrote:
> > On Mon, May 4, 2026 at 10:54=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> w=
rote:
> >>
> >> On Tue, May 5, 2026, at 03:01, Rosen Penev wrote:
> >> > phys_mem_access_prot_allowed is only implemented for X86. For others=
, it
> >> > returns 1. Move it to header to avoid using __weak.
> >> >
> >> > Fixes compilation with make LLVM=3D1 ARCH=3Dmips
> >>
> >> Can you describe what exactly goes wrong here on mips?
> > Cannot find symbol for section 4: .text.phys_mem_access_prot_allowed.
> > drivers/char/mem.o: failed
> >
> > It's full of similar errors in drivers/pci/ as well. clang on MIPS
> > doesn't seem to like __weak.
>
> This certainly feels like a toolchain bug. I would not mind having
> the PCI code converted away from the __weak functions, but it should
> not just fail with a linker error like this.
FWIW I just tested

make LLVM=3D1 ARCH=3Dpowerpc -j 31

which results in no such errors. So probably.
>
> Does this happen with both ld.bfd and ld.lld? Which version of clang
> and lld are you using?
clang version 22.1.3
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin

lld the same.

I don't specify lld explicitly. I assume LLVM=3D1 does that.
>
>       Arnd

