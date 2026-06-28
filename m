Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A69DC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8ED6B0092; Sun, 28 Jun 2026 18:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899BA6B0095; Sun, 28 Jun 2026 18:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788556B0096; Sun, 28 Jun 2026 18:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4094D6B0092
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:42:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5DCE1A04F3
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:42:01 +0000 (UTC)
X-FDA: 84930795642.17.207A3DC
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id D2FAA140008
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:41:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r7X2+Ccp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782686519;
	b=ipRxTR5Vya7IIFNKw0ND/au1cVC3u0h5fhVqSwTyK3f8poB7vZyifLdUuQIKQ8LYFFGt0u
	ncEL+ZIfTsNIDiOQ6LWRGIp2S4DA7hVmoDerJUYJrhKslY6xrrQv+n9IyxnXJ0FzCy2NrW
	L7MecW5AqKRGFccV4xS2KODW3wNjgsY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782686519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dINDOy9QGFLOKBxf/hUzD3CsmyfJTe8s/tm74FirGv8=;
	b=T1c84kihcKIom+CSm9lsk3S3oSXIXoGtLB5QzUqf9iViYOV1Bjr057AWNKovrgsSreK+rF
	I3vDL5q3zGu/FZUVI4xG3cCUStVEgSOx/z3K2xN4iDzNWvIQMQtg4Zdpmi31b8OMAKeNqO
	kCWZiTuOugx3H7lvirp8cnjieJeDymU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r7X2+Ccp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69857dc1d5eso1307889a12.3
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 15:41:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782686518; cv=none;
        d=google.com; s=arc-20260327;
        b=JL/R28OREG7z7qt+c0mAwRQiLQukYgc0VyYpfBwf86Si0aMRGuf8N2uqUnbqjc1XL1
         T5Qaayy0XOc9mSQWlhh8vEc31N58Gsiop49Z3XkchlQHYVw0f7XLZAosuOsLdrIh3DsF
         shWrWy/Ux12GBCLjyyXhwUVMOg5en+7qWrqeilmU0vGocu1ufULlvd6PSAiw5OcywBuO
         EllNf5MKUZJiAOzI+xCnM7/coFhOGP2r2LBdXWLbcRo1Coc7pIT9ws3Ov/n1bUcoraTO
         V/ShCQMz8aP/6APcXeCduWfe8WAqXATGBz2iNDHKTer50pucqT8+/o4iA/f5jFFm6GxW
         cGHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dINDOy9QGFLOKBxf/hUzD3CsmyfJTe8s/tm74FirGv8=;
        fh=IozwpUHOgY8vsAfxAbZHPi0yJ6lfUTLgseuuA4qoYFQ=;
        b=UWFRyXzZbINR++uupTSVPuACRbNc9XM+itxPYJbUERTVO2bMddnkUkvb4cojNyot/t
         0NtVJTxvrAw7BpQunO4V9oqrhJ7LkEdPrMFFNRRuVihiYqkd1zGNwIEQMn1ic3fpZouL
         Ur6WV6pPzN22dBSJTkfYqKQbHOU0eHldBiLJJLjVRTGEehfMJEAk/3m+lf4ZPpLd/0qq
         AjZDn6hssroqGEMfDOKqjqxrUQvJX2I4THaLufzyEMQ36/zyEZ8hb7as1QKsnwwDaGqV
         /b4Ob/pTImMNyhMe/UC3VILw1F+F+iEM1M1cjD3EEdqgI+5Et3wSTW3ml4DoFA2CwLev
         taAg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782686518; x=1783291318; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dINDOy9QGFLOKBxf/hUzD3CsmyfJTe8s/tm74FirGv8=;
        b=r7X2+CcptSCR4pccfSfcpO9NVXY2qHoCFmxC3giYRnjDHU9ftJM+uqKzixtK4890QU
         zMezzl8a+d0vbLanFPtvqYzYP+OLOfipVMf9HWpQP3c0OsuvPuSTChRyueI7d3hLppj5
         CU6xOEwHVJIFVoqXbwB0BpXgqF8u8UyIfhmytgHUMem8K52HsLVl8hpsgkhVGXjsZoph
         TXEgz4oUjqSQn906Tbl/oFvdlWMrUez3HryRgY54p0dsldnO8VO+EB5oaHdnNdujQ5/A
         VFepOao87WeCNTS+O2ohYednMc9pK3LGTMveR9C/a9Z0bpkCD1lJ49rBFw2Srpbij6tz
         WXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782686518; x=1783291318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dINDOy9QGFLOKBxf/hUzD3CsmyfJTe8s/tm74FirGv8=;
        b=fvD/M1TdnQtAonh/Ntsx0WlvnRvNIFnodDfukFZVvlWwu+Ilh6KUZhjkcAkznBlpVD
         VNwZ1ULktuTtv/0eT91/e11wO+x85laMtXdKpBZ99VWjkFH+Dfkciyi4ZBX1ocWSDnzM
         dWRcUScqNKnwqJARe+zRDbdusWqOeUJc3kszV+aMuLSAYR26MdwicJkOLLbouUy6i6Xt
         KaLDHOLe58B9rj9kpTwmxfdxR3IIkbu1sSRUZq6bxcB7dvkYWNiRGJFnfSgsMie6lMFL
         u8Bm89q0GPajhfPhJvoDIrnzr/SLP8KUO+tmh9hL4Toh/nswNfGmVYFo/Edi4fM2UhjZ
         QoHw==
X-Forwarded-Encrypted: i=1; AHgh+RoROIHVPX0IVQqQZYj02XdDOWAJGEfmIYbdzFgj2sRuqhL1OVTo/FGFyviZEkt91BntkEC1Yp1EmQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2OPU49wtFsu/0mXWQNxkuRSegO72Dd30P2/9ph/K5J0zdyMgE
	FaymVO/rWOeliRZDHF9GhaUFrkUUquHIfCVi3+h/PP8Zzefh4EUCkNpCaHi7vxkwHMpMMtF++ql
	xKtWLaeAF8pRTzDOX6fds1NpFwpfdDQs=
X-Gm-Gg: AfdE7cleUMh0L6VP39JCe/7INUXTQayWnjNdam1yKZCYGv3gxfmxCsG2EO0WOsW6/nj
	FidKAPANixvPBK1k2QwcgXZoEfjZQEwrkaDehkYCIdKiMO7VnzsoaDJ6nhxaErsOQWAfTyfIZ+s
	oS1zLSDM9zrD2mhNNNrqzjH+x8B1zLxzhvvQT/MVUIFhdGaBAJkyAR19tdy55vz+LSCa2WztgQK
	SzeNMkcSFz07bjm9bLVAk4LKyIFhtVokngxNgfkjcQxxUPYZbhcfvY8mhewO1hNz7jBBUVe
X-Received: by 2002:a17:907:d78a:b0:c12:4a01:3800 with SMTP id
 a640c23a62f3a-c124a013e79mr163310066b.19.1782686518062; Sun, 28 Jun 2026
 15:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
 <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
 <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
 <CAG48ez3u1OCx+zCWEs-_gowDmQ=KLbXO2xZ83LCZ1o1gxRT3Ww@mail.gmail.com> <CAAmtCfN1Uijp70m9TnyqOSit6sXR-Lq65ctZgxtFpZgc0vJfGA@mail.gmail.com>
In-Reply-To: <CAAmtCfN1Uijp70m9TnyqOSit6sXR-Lq65ctZgxtFpZgc0vJfGA@mail.gmail.com>
From: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Date: Mon, 29 Jun 2026 01:41:45 +0300
X-Gm-Features: AVVi8CdOfWZ-KT1h2MDWvc01bdTraPpvbXhF_MlEAykWM6dLLaJyaWcHYrDc-gE
Message-ID: <CAAmtCfPLwtCahXJz502e6yiykGFgRhqvbhYSEEgH1Toi50T5xA@mail.gmail.com>
Subject: 
To: Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000a7b2b40655580c23"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D2FAA140008
X-Rspam-User: 
X-Stat-Signature: aa6dtrt7cn6g1rmu884iidh957hqu1yg
X-HE-Tag: 1782686519-367459
X-HE-Meta: U2FsdGVkX18OyfW0W9v5xVhVZbfXX0mDwnbI/w+WQ6g8XaaFMUN8ZFEEP6F2o31HPi7FiskVbwv+diF50/Q7CNJXXP4Vk6AabunJLF+sWEOKh27q0P4SD2kJ9ZVwJ2GQ5nHHR27uLgLaC0AhjZ2C9AQdsBTavnWA2AMNvdQibT4/wlrnZL/OJjUADDu0omExx2DZkBcT1FWUY+D1LeDoblSQ08fiCaJaAAq+M0Wj/wc96FnvFdnF7hWhS5v4pX53LDnlCG6MANB9SxuemtKOES17nGthBRYpv+HOnkMKjM0qpxs26u38PbGRVLLpALE6zhdwUy5XGxP+9HKRDnESNV0DcbZBpzvXPktRu2cF7OlFySa52hSa9jH40X85lTpSvUzUGsmsDaO/qn16dld4LXs7GIqEujlC+WnUgyd5W3spDDSa2fYdWeo1l4eDxEGnIuOwS8WtAUB+YBSZz+d74zpuA7HQVY9TXWsS/mWwedhdR9vzWUegPff3gUdaUtiBjfkVZlAu1Z5/xP6s09YvuFJiNpIbQbZOrTlHjlXjX6/hngEoeSI+dNTRSGEx5y3nrS3UPpM7KBTsil1+tqt9LNlTP+yyPgM3kN59AhAzkRUhe5AiEmoNRLJp/NloS42UIsR73zOlzGpayry22FqUDLeVQiQKjDC/xXoTalC47o+AnRc5SOi6E1HSSL7SeacGVwKajqksC78gNa1uaRVaI3T5sDW1GAP4qd+okfRJIML3GIkI7lI7B8hx3AkP1ktFon2YTnD5kLfs9YQ1AQfNzocXlruV4PAu7eb6VCk9lkJoHYZ8QmUPEl9iZrYA6cqNdXRm8eDMsNsgCiQpbFzue92ovtvEU2IPxHJ/iAeaEl2gzSJ7EmzArgwMPZfx6TUq1Y1fyyY8/+j4cLkf7A9mI6WNJpvrQ6Y+T6vDLDGnZEquSqtjzfZNTs1UJo4weL4WHopebpboixtXk/mRo/T
 wpsk3PQS
 tt/PlnkOkDGe1x8xHYWtteB3meWm7NClfoWFfAH55FmPoZ67uIxZrhvV/He4t6SVLQ6usQ2jZxV8IK4kelDGn5GH7hoNXyqBtyde3w9uzKcyJFVo2/ynSLJyq1hlPJp2X4wpckXnMH0DIOER6hYcC1cdP7UVS6MPsI464nGHb/Z9kPQ1OwqQLh9rjmXBtaYBurFEYO2qIqPPUsEm4Ps2I8zbabeRR2HteXVNpeCrXV+nFdzqd+UfctzQWAC7OraQCylj/MYd1qkxPHXes7RbgV0VISwTSQV9ZEPp7LnSH7gEcRqncdrgcitKOS4h2F3QWGAQB8k6fNq3mv4S15HlwMYnYiJGFez/PfziPWnsnDkS5c5He+ybklLSUdBYUYn3slqOO9Zhs1Ist4Y2G70gqHUiWC9H1lLDUxUWaDs1BIM4g8/Ve2d6w7Sz1L0MRk5UhTp7Bi6po/CseKbliPVq0A7SbpH0ktGba5Q/QKlvfNkoHUCigVqyFmCkV6poUHRucahthdvSzm+dCOfoWZEIRx1wxtC0P1Dz8AWdm81J2ZCNrJdSf/TmVlhcGYoZ4aJiSKL792aASrPQsOjvV79HYVdpvztGVdQTEyMO6PX5WnMn+GkZtPgMiDzc1F6BWAf/ClvZz51UZBzgHUY74JfKdzbleAbz58ZopK5xd1n0U/q0amXbLGIuo2T31wDvlmWtJJKe9rDJ8h40FNggkvzi0SC0FkzavLl506gn2rFZFP4kB72giVhArBSxEm+NQvMX50eJ2OLUCREJMmGFgAzKMRrtLKG3Ke+C6KFsAguS9CQvMRzA2rRGiiWX0AJ7nZ+kBvq5SHJnT5OjEo7JFvRu9LzdI6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000a7b2b40655580c23
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A relevant point Scientific excellence in AI research needs a parallel
technical track translating the EU AI Act's technical provisions into
verifiable requirements, grounded in peer-reviewed science rather than
general policy language
Article 5 =E2=80=94 the absolute red line: eight prohibited practices, no e=
xceptions
Articles 9=E2=80=9315 =E2=80=94 mandatory requirements for high-risk system=
s: risk
management, data governance, documentation, record-keeping, transparency,
human oversight, accuracy
Article 50 =E2=80=94 transparency toward the user: AI interaction notice,
watermarking
Article 53 =E2=80=94 obligations of GPAI providers: documentation, copyrigh=
t,
downstream information
Article 55 =E2=80=94 GPAI with systemic risks: evaluation, adversarial test=
ing,
incident reporting
Without that translation governance stays conceptual and never reaches an
implementable form
Available at https://lnkd.in/dKx7cW5R
Those who agree with me that solutions will remain mere marketing until
2030 if they aren't implemented according to the law won't establish
standards because there are variables in artificial intelligence systems.
Some talk about emotions some about the role of the CEO some about
infrastructure, and some about governance. You'll remain stuck in a
marketing cycle for years

=D9=81=D9=8A =D8=A7=D9=84=D8=A3=D8=B1=D8=A8=D8=B9=D8=A7=D8=A1=D8=8C =D9=A2=
=D9=A0 =D9=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A2:=D9=A0=D9=
=A0 =D8=B5 Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
=D9=83=D8=AA=D8=A8:

> Thank you for your response.
>
> I want to clarify one point:
>
> TID does not address what happens during
> key usage. TID addresses what happens after:
>
> After any sensitive data (keys, passwords,
> tokens) is used and memory is wiped =E2=80=94
> the residual data still exists in CPU cache
> (L1/L2/L3). This is what TID eliminates.
>
> This is a different problem from what you
> are describing.
>
> The full threat model, attack simulation,
> and benchmark results are documented in
> the research paper and repository:
>
> DOI: https://doi.org/10.5281/zenodo.17585929
> GitHub:
> https://github.com/ahmaaaaadbntaaaaa-byte/TID-The-Instant-Destroyer
>
> I welcome continuing this discussion after
> reviewing the research.
>
> Regards,
> Ahmad Qasim Mohammad Hassan
> ORCID: 0009-0001-4360-0802
>
> =D9=81=D9=8A =D8=A7=D9=84=D8=A3=D8=B1=D8=A8=D8=B9=D8=A7=D8=A1=D8=8C =D9=
=A2=D9=A0 =D9=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A1=D9=A2:=
=D9=A4=D9=A2 =D8=B5 Jann Horn <jannh@google.com> =D9=83=D8=AA=D8=A8:
>
>> On Tue, May 19, 2026 at 11:31=E2=80=AFPM Ahmad Hasan
>> <ahmaaaaadbntaaaaa@gmail.com> wrote:
>> > Thank you for your questions. I'll address each one:
>> >
>> > =3D=3D 1. Threat Model =3D=3D
>> >
>> > The target scenario is a same-machine attacker
>> > in multi-tenant/cloud environments where two
>> > processes share physical L3 cache.
>> >
>> > Example: a cryptographic service and a malicious
>> > process running on the same host. The attacker
>> > uses Flush+Reload to measure cache access timing
>> > after every encryption operation =E2=80=94 no physical
>> > access required.
>> >
>> > This is documented with real measurements:
>> > - Without TID: 78 cycles (Cache HIT =E2=80=94 key pattern visible)
>> > - With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)
>>
>> So you're assuming that the cryptographic code leaks secrets through a
>> cache-based side channel? That would be a vulnerability in the crypto
>> code.
>>
>> > =3D=3D 2. Why Kernel Module and not userspace? =3D=3D
>> >
>> > You are correct that CLFLUSHOPT does not require
>> > Ring 0. However, userspace execution can be
>> > interrupted by a Context Switch, which expands
>> > the timing window from 372ns to 36,640ns =E2=80=94
>> > making the attack significantly easier.
>>
>> Why does it matter how many hundreds of nanoseconds it takes to wipe
>> the data from memory? You can also have a context switch directly
>> before you enter your cache-wiping syscall, or in the middle of a
>> crypto operation.
>>
>> > =3D=3D 3. Why not add this directly to libraries? =3D=3D
>> >
>> > No major security library implements CLFLUSHOPT
>> > after wiping =E2=80=94 not OpenSSL, not libsodium, not
>> > glibc, not memzero_explicit. This gap has existed
>> > since Flush+Reload was published in 2014.
>>
>> I don't think that's a gap, because the standard approach to
>> mitigating cache-based side channels such as FLUSH+RELOAD is to not
>> access memory at secret-dependent indices in the first place.
>>
>

--000000000000a7b2b40655580c23
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">A relevant point Scientific excellence in AI research nee=
ds a parallel technical track translating the EU AI Act&#39;s technical pro=
visions into verifiable requirements, grounded in peer-reviewed science rat=
her than general policy language=C2=A0<div dir=3D"auto">Article 5 =E2=80=94=
 the absolute red line: eight prohibited practices, no exceptions</div><div=
 dir=3D"auto">Articles 9=E2=80=9315 =E2=80=94 mandatory requirements for hi=
gh-risk systems: risk management, data governance, documentation, record-ke=
eping, transparency, human oversight, accuracy</div><div dir=3D"auto">Artic=
le 50 =E2=80=94 transparency toward the user: AI interaction notice, waterm=
arking</div><div dir=3D"auto">Article 53 =E2=80=94 obligations of GPAI prov=
iders: documentation, copyright, downstream information</div><div dir=3D"au=
to">Article 55 =E2=80=94 GPAI with systemic risks: evaluation, adversarial =
testing, incident reporting</div><div dir=3D"auto">Without that translation=
 governance stays conceptual and never reaches an implementable form</div><=
div dir=3D"auto">Available at <a href=3D"https://lnkd.in/dKx7cW5R">https://=
lnkd.in/dKx7cW5R</a></div><div dir=3D"auto">Those who agree with me that so=
lutions will remain mere marketing until 2030 if they aren&#39;t implemente=
d according to the law won&#39;t establish standards because there are vari=
ables in artificial intelligence systems. Some talk about emotions some abo=
ut the role of the CEO some about infrastructure, and some about governance=
. You&#39;ll remain stuck in a marketing cycle for years</div></div><br><di=
v class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gma=
il_attr">=D9=81=D9=8A =D8=A7=D9=84=D8=A3=D8=B1=D8=A8=D8=B9=D8=A7=D8=A1=D8=
=8C =D9=A2=D9=A0 =D9=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A2:=
=D9=A0=D9=A0 =D8=B5 Ahmad Hasan &lt;<a href=3D"mailto:ahmaaaaadbntaaaaa@gma=
il.com">ahmaaaaadbntaaaaa@gmail.com</a>&gt; =D9=83=D8=AA=D8=A8:<br></div><b=
lockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px =
#ccc solid;padding-left:1ex"><div dir=3D"auto">Thank you for your response.=
<div dir=3D"auto"><br></div><div dir=3D"auto">I want to clarify one point:<=
/div><div dir=3D"auto"><br></div><div dir=3D"auto">TID does not address wha=
t happens during=C2=A0</div><div dir=3D"auto">key usage. TID addresses what=
 happens after:</div><div dir=3D"auto"><br></div><div dir=3D"auto">After an=
y sensitive data (keys, passwords,=C2=A0</div><div dir=3D"auto">tokens) is =
used and memory is wiped =E2=80=94=C2=A0</div><div dir=3D"auto">the residua=
l data still exists in CPU cache=C2=A0</div><div dir=3D"auto">(L1/L2/L3). T=
his is what TID eliminates.</div><div dir=3D"auto"><br></div><div dir=3D"au=
to">This is a different problem from what you=C2=A0</div><div dir=3D"auto">=
are describing.</div><div dir=3D"auto"><br></div><div dir=3D"auto">The full=
 threat model, attack simulation,=C2=A0</div><div dir=3D"auto">and benchmar=
k results are documented in=C2=A0</div><div dir=3D"auto">the research paper=
 and repository:</div><div dir=3D"auto"><br></div><div dir=3D"auto">DOI: <a=
 href=3D"https://doi.org/10.5281/zenodo.17585929" target=3D"_blank" rel=3D"=
noreferrer">https://doi.org/10.5281/zenodo.17585929</a></div><div dir=3D"au=
to">GitHub: <a href=3D"https://github.com/ahmaaaaadbntaaaaa-byte/TID-The-In=
stant-Destroyer" target=3D"_blank" rel=3D"noreferrer">https://github.com/ah=
maaaaadbntaaaaa-byte/TID-The-Instant-Destroyer</a></div><div dir=3D"auto"><=
br></div><div dir=3D"auto">I welcome continuing this discussion after=C2=A0=
</div><div dir=3D"auto">reviewing the research.</div><div dir=3D"auto"><br>=
</div><div dir=3D"auto">Regards,</div><div dir=3D"auto">Ahmad Qasim Mohamma=
d Hassan</div><div dir=3D"auto">ORCID: 0009-0001-4360-0802</div></div><br><=
div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">=D9=81=D9=
=8A =D8=A7=D9=84=D8=A3=D8=B1=D8=A8=D8=B9=D8=A7=D8=A1=D8=8C =D9=A2=D9=A0 =D9=
=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A1=D9=A2:=D9=A4=D9=A2 =
=D8=B5 Jann Horn &lt;<a href=3D"mailto:jannh@google.com" target=3D"_blank" =
rel=3D"noreferrer">jannh@google.com</a>&gt; =D9=83=D8=AA=D8=A8:<br></div><b=
lockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px =
#ccc solid;padding-left:1ex">On Tue, May 19, 2026 at 11:31=E2=80=AFPM Ahmad=
 Hasan<br>
&lt;<a href=3D"mailto:ahmaaaaadbntaaaaa@gmail.com" rel=3D"noreferrer norefe=
rrer" target=3D"_blank">ahmaaaaadbntaaaaa@gmail.com</a>&gt; wrote:<br>
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
</blockquote></div>

--000000000000a7b2b40655580c23--

