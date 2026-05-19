Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D84CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062F96B0005; Tue, 19 May 2026 17:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03AFF6B0088; Tue, 19 May 2026 17:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C606B008A; Tue, 19 May 2026 17:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D70F16B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:42:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84EF61C09D2
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:42:37 +0000 (UTC)
X-FDA: 84785493954.18.D3242B3
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8396820005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:42:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Qz/X3sLG";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779226955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
	b=CykPlcn1QmQz6ipx9F809Vw38dYPf2GJpPNoSoFAjQj649AVCVTAVf6IH+8HzhrvNOxowg
	9bGL4NeMZaHlxVvaucnrOqBAM4bMPYR9Jl5yqp+AKaSQPN625vB3tsHp5VxfK229ZoctnN
	WzuyyTBioK+4/CAdqtXJUafCqI/N6oQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779226955; a=rsa-sha256;
	cv=pass;
	b=Ey5zZK30UourFt+SKIz+qNV30dDtS7jtx4cz8F7WBgcuRHu1kAE9MM06EOFvwaubSnixCz
	wGji60lz8N85D4hXRFu/nUBpSopeM93jTLJIXvo04gPEGS0jkqvpCQNG1HNHOslzudams8
	tRdfFK+Yk9noBbw5wMDiCWrC60T8tqY=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Qz/X3sLG";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso303a12.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 14:42:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779226954; cv=none;
        d=google.com; s=arc-20240605;
        b=EwRtNN3WRCmSaJ5hbAc0fOhLID5P0vIhBs9V3WRxoVENPus0MuQ/3iOhxbx0hcMrBE
         LnvGbm36GpQjkMaxwe5lLWniqFZp3kXya9XLJ0C/wTlx+SFImZFj5a8jMH1B2bzFlzfS
         5MynU0cFQ1ascGZ/jvKnuFZh34r07EWgj1flGbjopxjjBPug8HECqGscJvQVMGcfTEuX
         2m6L9nasAwGj6oEXo+0KY1kqjM6DNQdNwMSsKeNbWg9IAL9DAcpdi99TWLZYvgMy3+F4
         KGPT6AbgE1Taoho0L0Qxg+99TFonMNtevmmBJOvlKkaz0AR/QKnn3pcazO9nW+FUgwm1
         y4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        fh=9cknLHnwzHqS2PsRF9mr2hIwQtRG2DGWZAOoj9upi14=;
        b=aDqVj10nHgSNwLZv3CSyeX3oHoTNeimfXL9fina8zDvc55gvRwBlkvrT+5i1J3L6mj
         gFPVAVQ+pr4tnfjrtGzOKqaFmEFFcpDQmHTOvwIFqL4YzKFaZIDRUoSQvKIMtPUKj8GJ
         YgLAlYJYf8C+1ZXwi5tuu9wGT8VyC4FN0dOP5fXJPNukKpjF3SYcbHOExDc6kvXlLKnX
         IWRLbSgKPucSR6dCt6Ivg3w7ZXsr5I8irIvQcdcWEu/yas0kIJ0bt7gBuvIuxFz5BCNW
         KRrubtxIRFejvvQygST4OdakN2FmiK3b2LBtXC9RD0YG4xTJQ0CD10XE112lqwaSCHZ2
         4KNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779226954; x=1779831754; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        b=Qz/X3sLG1kPZgX9A2mv4VRkldy0bcG7M7EHLJ7x+wqkpDeU8xOS9PhPLmO4IpSwDgq
         ulZBHTgw3amB0W3zRtaTm9MLfslBZ8mgiWLXieSx+gBMnjHKECTrbBcXweuULLwmInxv
         3gkQLwmz38b4L7PzP2nBtKYd6VUY4ixmWVI3db9EUnQUpTpBVI89yg+6q5YZ1JDWrRB0
         Gxtsl5o7nvrc2q9Fduw5bcmkUVw6gzRB1VpNKqBcuOZX910fGOTxMyy2Tg5aWictrYaa
         /9lhrKQEI7rHDh7+bQKrqo95zIuwHzvvyKGrXcU8fggY9jcL5oCv5iDb3NWo+VG6Ty+J
         xRyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779226954; x=1779831754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        b=ZTJ76/8j95p3UloJQI8F7kWXR74JH6R6w0pxY7tRK6sRXMHQ8JW4q0YOjr3GuRuQX4
         q0C0MM5p9M/CiIw7QuTrZhsPqz0xDYJJ7hM4fLtt+RlisjzmjhBOx+Ts1jt4Od5VddvR
         z7u30kKY3fmWzopa/KBw6uFkF89NJZePfCSwv7srCh1y1ck/T5kTwKSPyxw0kNrdkgJw
         m7AxNJsCORuFC5v7rJ4EtCDFOVx4MQy4JJQABOUnJqsfB8246pi9t+mbAl/1Z10Xi+Nq
         WRxTtK0EF43Zvv8Hu83J79a+2DX/Z/OpP6XmggB48z4PVlNaHL110cbMRSC65xd5PMbu
         fZJg==
X-Forwarded-Encrypted: i=1; AFNElJ/8MCuyKg1+Emhz1jvgdAWIAVYbqbNc4FBZZdKQLDLqNdMfn76m6mfgDBUeUJDqb9mYihdW02fSBw==@kvack.org
X-Gm-Message-State: AOJu0YynlgSVVl34xMiyLGuwiHG7UquFQ0x/JJaWIq8JXoJEmnlavXiQ
	ijhYpPUdHMteouytNVgKxbAMziOJt87n/5kdU4MugMj3K+xKKtFnhClsHXcICliNbys5sxIE+bI
	/visKcterF0GDCCoC7+ixzteIxGpAoy0Dw3LHo5cZ
X-Gm-Gg: Acq92OGBC3+qJn4kSeHZ702/jOqaCzJ1MsslIiMsuY+eYcTGuyxvYmRSbt1aZDwlvuf
	bBTQw63FvxMpm724nj4ntCC6SweO5FfCiTmG+tQ5dhqNVdn9z3pq/EVwBT+YUUajUeTdopuagGf
	5FJ4N4nUYQR76HYE2VeDc+n2foyLOY6q2Gwf5oKiH8cA7FlFlRJ39AWLX2kPwsW1WvXQu1fHNbm
	/G3jgQ9ZOiFKWCtwOzaI9V2EQGWVal3oSSi1Ku41HDRetaqJyOmuCKZj5lrR2n2Nhy/bsAcYqf3
	QDSb8DOUY1Qz3jppSAYT82lbZwWcDXIUeZ1m2uFfPcnX9BU=
X-Received: by 2002:a05:6402:20c6:20b0:678:a5c3:4d12 with SMTP id
 4fb4d7f45d1cf-684985e277fmr173995a12.3.1779226953632; Tue, 19 May 2026
 14:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
 <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com> <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
In-Reply-To: <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 May 2026 23:41:56 +0200
X-Gm-Features: AVHnY4KelXMX0Ox3UHP6DtmSDnRxPxmxV49wSNMKd-K67wpQhqz9skVmJZNDODo
Message-ID: <CAG48ez3u1OCx+zCWEs-_gowDmQ=KLbXO2xZ83LCZ1o1gxRT3Ww@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8396820005
X-Stat-Signature: 3u1arbq7bo63szui4z1k5yy3i179prpj
X-Rspam-User: 
X-HE-Tag: 1779226955-565175
X-HE-Meta: U2FsdGVkX1/OURFLVu0/D31FA6YhEGGhvG5/mFas5f0COSHx2iaKAo8jFZw/Z963TlaWboVtPqxF8cFeSFirGI51DZqT5IsH+z8YLuz33D8r0sNB7ewOvwNR0Ihjmmnd2Zc3HTMFYHwjxjqi8UH8edvMtfKHPV0ecrigKOms36Fu61BXnWF2IsU1zTTcZRXtwnJaUAVRnwIaVT4lXaWGcRHaMUyV/FaV3uRM2DWF3jLSdWw+L/XOHw+q7+UxkArp5OjMSNm40CM32y5wcaam1BwwY0i2Gw6UjcJggl9b4WMaPPwMWl7IgIQC6pVbNFsgYqPPuCtA4omYuLlh4KI9TWncyiLfDzqzjQQmu3Y8o+P2Nj5M4bzQZWNo27dyaQqEdoOwFADbDvBFDjlRWyUYs0b281Cas9G+lZ7yTs3E3P+Ue+4jNsB2O8QzTRCJ/unnXe7tuHd8tJP1PitMJ6tw78+3/uyw19j0fM2LSMzprTlB8LitZ/HbTcX66qbWRc0NfUXURJ3tnGyxDgYL6VMmslGCQLFkD3J+ST1QLhjU+qzFujdz3qjDr7YPhsdQD0ziYNj+4wMjYTFXNSDh4iWg86A48eUqMPatY0I1ilbJPGSTvXC/W2sTXRBWS9ZUMlzgXnsPrZ9lXXdvtDe+yBbFSFTepksjpgJJZKApGiwHDVm8lXRKNmeupoAWJUG0cOVKjvA9tSY7wBpc94SVIhRIA6nhyRSkWcvVOs4OOFjRQQCTvdN6AQUII4CNE9U6tbP4M6HDEJbhswvoe3pGf8FtFKkEHIES77rVx2ry5p4yYlsNRj71WGLiQQovZUi9/TyCvwnAkrY1jovmmYiMqHEwFzYqNuIDL/24uosHGJiQnm7dU5zRDof1nJ74lPR+S0SX3z0UFXluA9tkt0MWoHAar4DD+JFwW4uLFv+rc8u1HNBDb6oUFEWn0y+nCv+H7GczMbg3S5w8csooaqX/sFd
 9l3ekOx2
 qsJVopZrgm1eio8Qf6/KdVPijBn38BI0JCOfmYYW1nySyY7Ghdz/zLxPhdfV9gi1DCKgyn2R1d9g90Bu/GzkID66uOqJH6/nP+69lEOnpLFiKoTpxlio3kpZFn80t5i8omLF/ZOBfxoamqzYbNzILUNmZSHN5X+u/ZAmW4WU+KEbZqN6xCEmnMKY/b1MTRNm1zm6b/ileP7uxxqT2DYqwzKPSo6cnI4cDkLOa3joMQk2+krKk20MQQrB4b7Oget1w+gtX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 11:31=E2=80=AFPM Ahmad Hasan
<ahmaaaaadbntaaaaa@gmail.com> wrote:
> Thank you for your questions. I'll address each one:
>
> =3D=3D 1. Threat Model =3D=3D
>
> The target scenario is a same-machine attacker
> in multi-tenant/cloud environments where two
> processes share physical L3 cache.
>
> Example: a cryptographic service and a malicious
> process running on the same host. The attacker
> uses Flush+Reload to measure cache access timing
> after every encryption operation =E2=80=94 no physical
> access required.
>
> This is documented with real measurements:
> - Without TID: 78 cycles (Cache HIT =E2=80=94 key pattern visible)
> - With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)

So you're assuming that the cryptographic code leaks secrets through a
cache-based side channel? That would be a vulnerability in the crypto
code.

> =3D=3D 2. Why Kernel Module and not userspace? =3D=3D
>
> You are correct that CLFLUSHOPT does not require
> Ring 0. However, userspace execution can be
> interrupted by a Context Switch, which expands
> the timing window from 372ns to 36,640ns =E2=80=94
> making the attack significantly easier.

Why does it matter how many hundreds of nanoseconds it takes to wipe
the data from memory? You can also have a context switch directly
before you enter your cache-wiping syscall, or in the middle of a
crypto operation.

> =3D=3D 3. Why not add this directly to libraries? =3D=3D
>
> No major security library implements CLFLUSHOPT
> after wiping =E2=80=94 not OpenSSL, not libsodium, not
> glibc, not memzero_explicit. This gap has existed
> since Flush+Reload was published in 2014.

I don't think that's a gap, because the standard approach to
mitigating cache-based side channels such as FLUSH+RELOAD is to not
access memory at secret-dependent indices in the first place.

