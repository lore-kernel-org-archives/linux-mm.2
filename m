Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A40A2CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 23:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1B86B0005; Tue, 19 May 2026 19:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962786B0088; Tue, 19 May 2026 19:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851746B008A; Tue, 19 May 2026 19:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 730CF6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:00:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0D6340BE2
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:00:23 +0000 (UTC)
X-FDA: 84785689926.24.956EFCD
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 966DD1C0018
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:00:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ESUsTBRm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779231621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpmP25iHQDurzadXyPY+hloEh/FfZWgSL0vE5FTKLlI=;
	b=TWr/yeFH9Fib+UHQo8NMGCV4pGiVFFDvnZ2s7YQG5KT+mE4G8WEHnAz3rMdk/LXUlCsjmT
	JQJgZYrhW4NKnGkFJX07J7teK69oNXiv/NsIvItrC6WodEz4X9lxFVkPi35afrgKM8nejm
	Xdobucliqmx/V29zmJXmwczLIqklpec=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779231621; a=rsa-sha256;
	cv=pass;
	b=zLh7cvZbRoJlTNPpJiSGDIKcKmmctQL29rMTzIgfZSJwqZ1LjRJPxKKQduBwtH3OPlwoG+
	BCA7nHWzvXNyaEDgn3ja1kUo5NFMzmtZJhxWajVZFresuGzJc6/O4Pp14YbfL4xfLeRfP0
	TG/1W91AesGOD4iFRtqNJVyY6M64mp0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ESUsTBRm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67be41d5eeeso7273501a12.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 16:00:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779231620; cv=none;
        d=google.com; s=arc-20240605;
        b=PPQCsRXh9BwlRHSzk2L+3w2aF84P3J9HddcxuonXY1F/HC2uBASF2+DKSpJLp7Ukfu
         wSk26sZ0nLNUPITIaK8Hp21lqvHKumFZpwE1m11TLmq46NyfE6P8RUTuD77Jx1UeGepr
         MoylyjMZMBanv3a3kfhQAq5Y+blXkyNiqFUX8k6B4owhbcDzqjHRa7pWcVdY5u5PU7et
         Pi8Ylf7XV5BbDb+aKseb/5dCYqZJUs7ozH6rh0+2kQPwNrKqIuHhUJkqa40QA4VshbTW
         NlmGyEVcN9eZok6fCbcuCz2E5kbP5iFg5GeTUI/FVrAYz6nuC1gocoaud7pOS9UZ8c9I
         6GyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FpmP25iHQDurzadXyPY+hloEh/FfZWgSL0vE5FTKLlI=;
        fh=fmAjX3rMJ+a0heu2bkBUrxW77fR9BYFm/QAQujKEcpU=;
        b=Yg++77yqnZGD/IYsK4aUnvXBKekADg66csruhJXbYLiC6h2el10EBjWQj+QZ8EA1sb
         g1MG6O2j3XQweh/Q0iMFgVEZP2PS929XkrwfnWFS7An8bE8e6BGJuneW+3muhPV97/Mr
         s6FDFQBkgG/VEkNfg+gKbDKjRa5Aik+U5gEWxFw0qONJe3FHF7yo5qSWAZqy94k2KgMi
         I/vPF2TvHCUql7Opu9Yryov+3BpDDELcQ5crOG+tWAVuefE09C9hL8taLN4cf8VzvrOD
         XofjvlCsM1nZeKDPJ2jxA9+43YKfCpJIgJRzJOQyfgioVunBwr5yMyMYOS4VmBTRLpmR
         rhNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779231620; x=1779836420; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FpmP25iHQDurzadXyPY+hloEh/FfZWgSL0vE5FTKLlI=;
        b=ESUsTBRmJ5LRMJREMY2IEN0kewOGj26oB9IiCD/czGyoFiaTW21udXPevEmmCVmyI6
         gbp7xfalzm9Z2Iq4wVcBSw2UMHA7YsU1pkXuzqg55bMcHK1yy4kZq+orVjexaAqGMTV3
         WosV2R6EZuwroakrnrHSutrUi265qR0E8V3yyKtIEYxxgzVEkPNaYm8/g8XZ6zGzmCyp
         RJMNgki1v8cxgINeZDjSboQ7Fg+BQBvY67faPXP/TQUiwOVztHo5fY+KbOsioCZWLgtW
         1yRd30F04pox/xCKJXWjY97j2Hh/FtNBTcXaiaus71Dm88JwrqBAZBISZVRAcgS2sRHl
         spOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779231620; x=1779836420;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpmP25iHQDurzadXyPY+hloEh/FfZWgSL0vE5FTKLlI=;
        b=JXEvuaYAuvWtTNHPmg+7a5QteM4QxQQpRVX9jx7L+tu7TJSTzSKki1hYApVrtmHadY
         jMB+yzs5QSHtBoM+lwkEkoEDtTHpYinGE/mcDDhy4U54uEezYlGzB2wDJ4VSkBtoHQcv
         URyyIjWUdnHZhJFUMs11LYd1YjuY7kBXRT7Kt/2Ud27JxwEHUBQieYHRT3GVAae30UHh
         lPRdF94BZlMwWinbW2UFcI0Q44yxVeQZOl0y6MjRAsv+6lTPa5Dc9RMXLdaVuB9jtBvY
         5SqnC//ZD6SOHf6KhDUJVip5VyH6/z6OqWdCGOetpU6zSsATUvsj0CARDYov+xoDGK4I
         qiKg==
X-Forwarded-Encrypted: i=1; AFNElJ+z4+aX82cmrBEX39vDOAM5zVnMLOxdqz1PnErsNOgNlYHvqMiqtM1+PAyRS8xsy+Fddt0G6hawFA==@kvack.org
X-Gm-Message-State: AOJu0YyABjED6TmY5DqiwtzvEBjrFOupZNBONJWKM8BzjmazGH1GhoBA
	/q7jPbNHsLyJl/pWvxCxLvubFL1tLnakECLRg3Io8w6CHrzANFGJUzch6PPtt3vgasunBD7M5gV
	5u70aNx776DZSEiu7En3F/P2fEBnhijo=
X-Gm-Gg: Acq92OGm3Hz2UZp1cgm0L5DcM8e6gSgjzfj/q3n5qfKO1f3EXpO4kzA/z5KNGwSaMkE
	oiv/bSp+bMj0X0pMQaoK7vL+0+8SoLRt5PZx3b6qEU9NpgJ/AZvE8G8XK0X+oIQOFKKjOsp9DsP
	yaxWJUK2AsFPvmqCyq1sxqLRDHwLIQ8v7poRrQ9YdC6s9yOfO+RutktxBZHpvAQfdYH6J3HMVU6
	pcgABUmWr1AAD7kFN6MLvR/GMcOs9o2jWQ5OvYIeURZOFS3TypbjNvaCR51xLAI3xq3cxTQKsft
	RAI2sL3pZq1aN3GxDh0=
X-Received: by 2002:a05:6402:24ce:b0:671:121e:dd4a with SMTP id
 4fb4d7f45d1cf-683bc4b12a3mr10367289a12.5.1779231619796; Tue, 19 May 2026
 16:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
 <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
 <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com> <CAG48ez3u1OCx+zCWEs-_gowDmQ=KLbXO2xZ83LCZ1o1gxRT3Ww@mail.gmail.com>
In-Reply-To: <CAG48ez3u1OCx+zCWEs-_gowDmQ=KLbXO2xZ83LCZ1o1gxRT3Ww@mail.gmail.com>
From: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Date: Wed, 20 May 2026 02:00:07 +0300
X-Gm-Features: AVHnY4L4-OydrETJiigGkvPHNEY2Fl17HZUFkF1lHlcwFyxCL0OoUgwMeQLHQUQ
Message-ID: <CAAmtCfN1Uijp70m9TnyqOSit6sXR-Lq65ctZgxtFpZgc0vJfGA@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000abd57a065233a40d"
X-Rspam-User: 
X-Rspamd-Queue-Id: 966DD1C0018
X-Rspamd-Server: rspam04
X-Stat-Signature: m9tjdrbuwz77qkkuo5gywn9m8pop91ax
X-HE-Tag: 1779231621-796235
X-HE-Meta: U2FsdGVkX1+kyy8IK+7m6bn3uqdfep9L2acWc2DM+tLStduZyxPec1v+A3pPXTSvmP7pe2yaqzb0tw/+5TcLQfrvwCGPlFP6b6CwFbjCLP6r86iZjL2sdOp3WrWp4vbIGtPdmxiUc4c7zBwt1TCBsIO1aK5ycQaMvtU5ojm7jELGQZ1AaD7qUj4boyUz8mCWMkGrEuuF38zz5IgKQT93A02Ezcl3ZND/dkocR19QmX4Uo2/GsoG8kb6YGGQn4g6CnC5wz0BcOHEHsppwEtYMYq8AYpzJVoP/oNoXXtsVrfq9ON7hM82kqx1VKFRq03ab9/brBnhNtn3dsMjArJ8kO57f+07aYaShb4hwLcEnHG/Xz1HH2YFLetTjdaooA1bgJSzMdBahuWfr+fb7qV/mf/DqNZYBNuXgZhFP+7W4J4nOgh9ghunRQS34q0th+Q7NROq6SKOInk3VYUcHw2SjGE5I53p1QP6nkceDFqe5kKMwcRNbDdto/EYRleTkXQk3kWPg/V+AS5m8nJhA0hF2VQZVcUZrVZuL0egThvIFBEOGa4LNThNdFxRBBqsXQXt2sv4bWWRjXr8raunnOnj2kd2bQjBf18XeMp6PD44LIlOKv+VSIqFJuOCrUIyffeRmg1PfdCG0JMgTrrmBaCM1EyQPGD21CSHHW1IzCHSgRJH1+kT0XmmqRdfjfDwtzVrnIkC5hGM3hssUsE1Lhmz5ODtJJdlWU6bXwF06c3B6+HYQKw0J6b1bnMWVCHk5gCmpw6Df+0HkdV5cIeUVDOWGagkHGaU4sGwScQNEgSGXlqnksu8ZLmMM0LdhARryGWo3Kcy13ZN0WiEb8nEwj3Pw9IyAJpfCvJSbxXntnt0J0CqjPpm5oMCsHjce9sUDwDAUsjJ02MhWb8X6ITblUiM1jGDhy7xjX3cItv0CHeg/shzObSyfuhMfwXqTc8+z2H/KEFKxNMBs3KsxuqKtax4
 k/e0Gjm0
 TTLs0jmdoCXTMuC0zu6+q315vDcgEzQrHrs1hXHhW3+PyRusMklmzk6GFERKONkf85pqocK0G8QcfRCjetrDCGTduXNTTaFP5G/0SAEEbvBf6YsYZ2sqfr6VE6a/+wJ6RaWwpwyZBsYgmVX77fVsovajJSUcPaOpcgb8qjH9JDrP2zjlbT3zLAqw1nqDNBvxO0hEnHJnOCoiWq7U8yqvlAlqHDIvFUbISuUrDr7kilwTiX6+w3mtGnDFWyO/HEvIgjAVq7EVrrK1Sf0K/sr2kj2tZUYTdCxFwgZ0Ezuc78rh5t4wQSdkRjX9J2jVNYAMQBfulX+sY2PtoBXO9d04PYL/B0Dai9ORoHXJpiHOne1OYwOmeb/kOdpALs7gVb8yV2fxVhqLZadEC0qsReT6ZnxNkEK/DvnN8MMNi5OV7Dcg0PmedQr3thQHsC8vkmI6oIqkzoXmvEyvgLPzlCo3/M3iytAvukATSnD0/fkLjtJbRsAIW/XjsQ8uL6qG66X8XzosC54ATvndkDhTcAZLZTmGsmpa4aO+RUPaFWCS08wYsbddtXnpULLMfuD6Uzj1pCxB6PwrQxTVPIKaTJiHe1rHWIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000abd57a065233a40d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your response.

I want to clarify one point:

TID does not address what happens during
key usage. TID addresses what happens after:

After any sensitive data (keys, passwords,
tokens) is used and memory is wiped =E2=80=94
the residual data still exists in CPU cache
(L1/L2/L3). This is what TID eliminates.

This is a different problem from what you
are describing.

The full threat model, attack simulation,
and benchmark results are documented in
the research paper and repository:

DOI: https://doi.org/10.5281/zenodo.17585929
GitHub: https://github.com/ahmaaaaadbntaaaaa-byte/TID-The-Instant-Destroyer

I welcome continuing this discussion after
reviewing the research.

Regards,
Ahmad Qasim Mohammad Hassan
ORCID: 0009-0001-4360-0802

=D9=81=D9=8A =D8=A7=D9=84=D8=A3=D8=B1=D8=A8=D8=B9=D8=A7=D8=A1=D8=8C =D9=A2=
=D9=A0 =D9=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A1=D9=A2:=D9=
=A4=D9=A2 =D8=B5 Jann Horn <jannh@google.com> =D9=83=D8=AA=D8=A8:

> On Tue, May 19, 2026 at 11:31=E2=80=AFPM Ahmad Hasan
> <ahmaaaaadbntaaaaa@gmail.com> wrote:
> > Thank you for your questions. I'll address each one:
> >
> > =3D=3D 1. Threat Model =3D=3D
> >
> > The target scenario is a same-machine attacker
> > in multi-tenant/cloud environments where two
> > processes share physical L3 cache.
> >
> > Example: a cryptographic service and a malicious
> > process running on the same host. The attacker
> > uses Flush+Reload to measure cache access timing
> > after every encryption operation =E2=80=94 no physical
> > access required.
> >
> > This is documented with real measurements:
> > - Without TID: 78 cycles (Cache HIT =E2=80=94 key pattern visible)
> > - With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)
>
> So you're assuming that the cryptographic code leaks secrets through a
> cache-based side channel? That would be a vulnerability in the crypto
> code.
>
> > =3D=3D 2. Why Kernel Module and not userspace? =3D=3D
> >
> > You are correct that CLFLUSHOPT does not require
> > Ring 0. However, userspace execution can be
> > interrupted by a Context Switch, which expands
> > the timing window from 372ns to 36,640ns =E2=80=94
> > making the attack significantly easier.
>
> Why does it matter how many hundreds of nanoseconds it takes to wipe
> the data from memory? You can also have a context switch directly
> before you enter your cache-wiping syscall, or in the middle of a
> crypto operation.
>
> > =3D=3D 3. Why not add this directly to libraries? =3D=3D
> >
> > No major security library implements CLFLUSHOPT
> > after wiping =E2=80=94 not OpenSSL, not libsodium, not
> > glibc, not memzero_explicit. This gap has existed
> > since Flush+Reload was published in 2014.
>
> I don't think that's a gap, because the standard approach to
> mitigating cache-based side channels such as FLUSH+RELOAD is to not
> access memory at secret-dependent indices in the first place.
>

--000000000000abd57a065233a40d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Thank you for your response.<div dir=3D"auto"><br></div><=
div dir=3D"auto">I want to clarify one point:</div><div dir=3D"auto"><br></=
div><div dir=3D"auto">TID does not address what happens during=C2=A0</div><=
div dir=3D"auto">key usage. TID addresses what happens after:</div><div dir=
=3D"auto"><br></div><div dir=3D"auto">After any sensitive data (keys, passw=
ords,=C2=A0</div><div dir=3D"auto">tokens) is used and memory is wiped =E2=
=80=94=C2=A0</div><div dir=3D"auto">the residual data still exists in CPU c=
ache=C2=A0</div><div dir=3D"auto">(L1/L2/L3). This is what TID eliminates.<=
/div><div dir=3D"auto"><br></div><div dir=3D"auto">This is a different prob=
lem from what you=C2=A0</div><div dir=3D"auto">are describing.</div><div di=
r=3D"auto"><br></div><div dir=3D"auto">The full threat model, attack simula=
tion,=C2=A0</div><div dir=3D"auto">and benchmark results are documented in=
=C2=A0</div><div dir=3D"auto">the research paper and repository:</div><div =
dir=3D"auto"><br></div><div dir=3D"auto">DOI: <a href=3D"https://doi.org/10=
.5281/zenodo.17585929">https://doi.org/10.5281/zenodo.17585929</a></div><di=
v dir=3D"auto">GitHub: <a href=3D"https://github.com/ahmaaaaadbntaaaaa-byte=
/TID-The-Instant-Destroyer">https://github.com/ahmaaaaadbntaaaaa-byte/TID-T=
he-Instant-Destroyer</a></div><div dir=3D"auto"><br></div><div dir=3D"auto"=
>I welcome continuing this discussion after=C2=A0</div><div dir=3D"auto">re=
viewing the research.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Re=
gards,</div><div dir=3D"auto">Ahmad Qasim Mohammad Hassan</div><div dir=3D"=
auto">ORCID: 0009-0001-4360-0802</div></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">=D9=81=D9=8A =
=D8=A7=D9=84=D8=A3=D8=B1=D8=A8=D8=B9=D8=A7=D8=A1=D8=8C =D9=A2=D9=A0 =D9=85=
=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A1=D9=A2:=D9=A4=D9=A2 =D8=
=B5 Jann Horn &lt;<a href=3D"mailto:jannh@google.com">jannh@google.com</a>&=
gt; =D9=83=D8=AA=D8=A8:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Tue, May=
 19, 2026 at 11:31=E2=80=AFPM Ahmad Hasan<br>
&lt;<a href=3D"mailto:ahmaaaaadbntaaaaa@gmail.com" target=3D"_blank" rel=3D=
"noreferrer">ahmaaaaadbntaaaaa@gmail.com</a>&gt; wrote:<br>
&gt; Thank you for your questions. I&#39;ll address each one:<br>
&gt;<br>
&gt; =3D=3D 1. Threat Model =3D=3D<br>
&gt;<br>
&gt; The target scenario is a same-machine attacker<br>
&gt; in multi-tenant/cloud environments where two<br>
&gt; processes share physical L3 cache.<br>
&gt;<br>
&gt; Example: a cryptographic service and a malicious<br>
&gt; process running on the same host. The attacker<br>
&gt; uses Flush+Reload to measure cache access timing<br>
&gt; after every encryption operation =E2=80=94 no physical<br>
&gt; access required.<br>
&gt;<br>
&gt; This is documented with real measurements:<br>
&gt; - Without TID: 78 cycles (Cache HIT =E2=80=94 key pattern visible)<br>
&gt; - With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)<br>
<br>
So you&#39;re assuming that the cryptographic code leaks secrets through a<=
br>
cache-based side channel? That would be a vulnerability in the crypto<br>
code.<br>
<br>
&gt; =3D=3D 2. Why Kernel Module and not userspace? =3D=3D<br>
&gt;<br>
&gt; You are correct that CLFLUSHOPT does not require<br>
&gt; Ring 0. However, userspace execution can be<br>
&gt; interrupted by a Context Switch, which expands<br>
&gt; the timing window from 372ns to 36,640ns =E2=80=94<br>
&gt; making the attack significantly easier.<br>
<br>
Why does it matter how many hundreds of nanoseconds it takes to wipe<br>
the data from memory? You can also have a context switch directly<br>
before you enter your cache-wiping syscall, or in the middle of a<br>
crypto operation.<br>
<br>
&gt; =3D=3D 3. Why not add this directly to libraries? =3D=3D<br>
&gt;<br>
&gt; No major security library implements CLFLUSHOPT<br>
&gt; after wiping =E2=80=94 not OpenSSL, not libsodium, not<br>
&gt; glibc, not memzero_explicit. This gap has existed<br>
&gt; since Flush+Reload was published in 2014.<br>
<br>
I don&#39;t think that&#39;s a gap, because the standard approach to<br>
mitigating cache-based side channels such as FLUSH+RELOAD is to not<br>
access memory at secret-dependent indices in the first place.<br>
</blockquote></div>

--000000000000abd57a065233a40d--

