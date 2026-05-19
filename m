Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 225F9CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FA56B0088; Tue, 19 May 2026 17:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868016B008A; Tue, 19 May 2026 17:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756C36B008C; Tue, 19 May 2026 17:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 657B06B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:32:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 337921C09C8
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:32:01 +0000 (UTC)
X-FDA: 84785467242.17.9AD3598
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA235140011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:31:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mveSY7bp;
	spf=pass (imf09.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779226319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQ8THDZ01faz2OJpFzxaxhIaM0owGhduryMkauZF9z0=;
	b=SDTTdnqoVoSC1qOmf4zRoCbN7GGSPf3EwVXiU+szNOiY2AIanBDiDXPPTJFJLhODmnX+/t
	M/gjWKJKB70PljNSyPGnFJ6Fm0e1gllCP/9HibIWlNL2FopJVtBtRk94t36BY1O380mrQl
	iL0KOA285i5RWYjLoMSTRzFAugcV9Uc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mveSY7bp;
	spf=pass (imf09.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779226319; a=rsa-sha256;
	cv=pass;
	b=Yz6gHENa/zKnEoGE+X2+4G18YYFqrXmaeustHRwq1Z5yX8tMr1Cz8J61eyXfDgAn1MyN4p
	IJmXwyBM5hxaUaL49DsywXsj8BlhJJDramIFCUeiBDQLvmMR4fQRq/Lfi/h0gB2ENcB/7N
	3SCh4p5ZWZMmY+fWKG3ULdTtS417nt4=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so9595472a12.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 14:31:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779226317; cv=none;
        d=google.com; s=arc-20240605;
        b=LzGe84aOF/oQW1lGktvUoaXiihPecl1KUqeR1CNmEWnjjradVzYTQ4gfmNF4N0sMG7
         7+qlco05h/BJ2vutboNr0t/XQzDVT4CbuXacpEl80qCKEMqrPl0V0TLg0HixkulqtEzN
         L13fS6DeVajGbDXducFC5jzVXGDS8JP8LhYWIQfKmr+vnT2/i75Rx8tF2AZCEpcljjKZ
         kqxbQKFO4Oz70PBCd92/qddu4SV26BUgPihIkUtlMMkqmDn8DkPKHph19PFE7sV9gi25
         B//R8Yxf8xw4BkDudDVitp0yRxCsTWo6w0//HpVTDOAe6GDT3crbewU03j81V7WqVCfe
         0MXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bQ8THDZ01faz2OJpFzxaxhIaM0owGhduryMkauZF9z0=;
        fh=hZR2+UcSGPdOY2oheIRn3VflgiVs2yZLoiuPN0SonEI=;
        b=FMI5oAObSvrp+GeNizDhlPD8AjJUUETkewWrTGIxqa3/+IsjA7ZiCGAhnDwZSRi8wZ
         bpPWA1eYfSHzOkajzRZy7/jp7XbyNha5dM4z/FZW9fug/cBipZLsCxqXGwr4AWHte2XY
         OBBG71Iqer+YGsnRKU/xAXFWOsxnzPiqIi3ygXn4l6ef3y/pFF5H21qqQmUZH7P7fzMX
         XurSy497pG4xf1ymGfohGh+Xrw546HfBL0BKLnRsWrtuc+7LtFuanE6iNuAzRfTFtfMO
         SNQIum9ADgJpwsVGM+ZQGo83FIQg8dDCYxdRVZ4QBOnKpa/IRd1nXLXZw4aIDY1K2Gng
         mlsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779226317; x=1779831117; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bQ8THDZ01faz2OJpFzxaxhIaM0owGhduryMkauZF9z0=;
        b=mveSY7bp/7TzxGe9qHHSggCcHT8WFIPd63qrwUeurqrVi7Qm5VfNdOXr1tj+03BJo9
         pBYZdMz+7ATwBRIsoKOOfazIraWayjHLzbdoK9nEnrBpAwPFlIy0gyxRMixSVOIyXjjb
         fvksexNa9fIEI1ihvqxvQtIJIalATSczLGafCtg7B9e+vzTwjx25rAkVOGGwuDXszw5z
         k/DKHTthmZ6vIifJPLrjgcrtQIZ8YgoRNYKIlzMjcppDHm9q5KOELSnW4ZeK4+CVvxPB
         ZXUvIUXx5u09JoVzGzlA8oPaX8A/9qBMU1EddRylWmiupewr5Tfov5PmYAbpQaegxuvs
         iP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779226317; x=1779831117;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQ8THDZ01faz2OJpFzxaxhIaM0owGhduryMkauZF9z0=;
        b=V21Lwl3ipAYZjPP/+/t8AE1PYWmjMvoKD/S/cw27V28Upe775C7+eig60enr/ZepJu
         ZNjg2agT1EuIce831o4x4GEytwc2H8Ddd81b0bTQq4MWFT8GBxYB/yNEcOxQa0MAN0eH
         /3OxpSX62JdT0Pvde6MOdkb4FClenpDMDhg16d7mbxtHbp8RTARF56rlewXum/KZUAdg
         QCGrFc7al54g0GTU/6R4lv6j0cYnjpoARBXxLe80uGJrqeFDRbfkpAy2rxUjlxaFma/Z
         TOI5dQEochvZoO/XhjZ4inrnlFxpe22+39hBMrc9fipP7WAqx246YGQe3/yAOBvO7DDQ
         pL4g==
X-Forwarded-Encrypted: i=1; AFNElJ+iPALZZl1wWXQgZOrNzx1vaqu6sClb6W2egcuKSGE7Qdn7dWV9EsdgyIisQ0k0eLOBwhsaZ/pafQ==@kvack.org
X-Gm-Message-State: AOJu0YyNrM8qJokUo7HSq6BfKU+vYELbkXn0/Aiz3fzJT43iK1Rn9+3Z
	s7s8E59SHKZmPy4cyYgyYNvxw2a2UgkCuGk8C1j6M3ZewIFESON0JWX6YHl2tL1kEhwvZJHyle2
	dRgvFuvCjikg0a4P8rGkXMpKBrvRW7vw=
X-Gm-Gg: Acq92OFSWBigzuYg7rkaFSWRSLhL6r57priLfGJX38dwVo3HheVWCFqXGjUJUr5g0IY
	637/O9FAZAVT1cjqbfo5KSs91DVhcw3WuGbMSSubwLgTeqpXZiBB8B2uzyS+bM+SVGo1A8YlYKy
	vXwMnfm4GX1IYFUuLwtODst7AaSqL+JtU9Yn1mPTjvyRxT2JOFRtQiSZvdNzmaM+DM5a+3euLFE
	xhjta3CSfs8d84cv2oUoRrtih1vXg/yXT818Qw+fP9MbmJ3u80m5a6qzrHhH5LpTePeX33r5AJg
	OYf+ryTdyb9qXlcFlG0=
X-Received: by 2002:a17:907:3e1d:b0:bd9:2b46:99b0 with SMTP id
 a640c23a62f3a-bd92b46ac04mr318962266b.49.1779226317237; Tue, 19 May 2026
 14:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com> <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
In-Reply-To: <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
From: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Date: Wed, 20 May 2026 00:31:45 +0300
X-Gm-Features: AVHnY4L4Y-5gKrbCMYxVYBedA_uSwgHTT7X14oTDJT5fjjB4iOMz-I5Pux6tIC0
Message-ID: <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000009d310f065232683c"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA235140011
X-Stat-Signature: t1j6wzzya6r9zyrxyg5f73ob5oxuzo3e
X-HE-Tag: 1779226318-761276
X-HE-Meta: U2FsdGVkX1+jw0qxOp5nB0/0tGL9pNcXqfizGVUTngPpnSbY4Q3A4SQkW1wKTdLXL1oB/Bh3K28ZqazdAaLuDQi8BTxWAtaYf7j6RFBx/pEvPlMIMUdkacFfdQzSKpef2yDPy3QpjtchxyX45j0VtaiEqGg1zH7aQQXDjnWYxoyKUVaWeFq7Ml5Dqw8zWAVnkTA54KokWiGetQjZBz3m5IVGJTDzMf/PCv8IH/zU1LcYyO9CvogF5vbvZdqUgCShobZnHQx/1W8mb3kK2gaIMo9sKJBU0HHCyAY3/jQz73H1PsvyMwZ5Bdz+DwouGsjFCKfPPxwu3v4WvDZaxnrlqlQx0Zr4WHn2MH+y+rIF7UUdSiHwVoo4g0U8vsrcu09YWMm9GgroNqhYgSWW30MrH06C2DBw3YmdhxYxwfIPzWHT/XvVqVHqz4vA2IuIqgAx7TFVJHTIixyOpZS+iygPfETyWFaYW1w3thuVwQhf6BZofEDY/neZK89DRhrRErkmOabJR/oIaT5x8g5vvdbxw0FcVicia6LKqqVwac4zEOgGjV9/8PEjGNuiWyU9Q/uNzrrakhfdn9kiBHzeJgkj2sNaZ/2iTGU+kR4d/txoaKbXGQikIkNK9avABIEGwfvTGvShSfHZ4wpZuybHsoX4fQHH6aWWmiB6wVWjsbKJixofT8sPWYVI4n/XcnkKACdqP4xkYYf23OrW7uk1CeFYhMH+UhbQdBP8eOpDrtSM+xeC2ymqYtBrBv6yHmpvm0sM41psDilBnRgacpJHKy0Wds1bLTuW3TIbTQgEV/jQRugIIqDFe5Qd1knN4PC1C+rg+C1UalvGm8pCQ1inDFaZ1eV4OJD9QPjGM3+6f3QhQ3D699LrAZw3VuQ6Fc23rH1UIn5PpKffja9c26QraUqio9s+J7d6NlPMQznBrQLN6rexKjtSo9CP3ulsbWw8d+HcytKmSHU6Etj1j9x9zb1
 36QCkAqb
 pFyuVqzVp8Ab7z3gVzfuelUcfoLwVDF0c9S0fPKmGzqh29b5t/x6pWRVTY4j7D43A3q6c3+EBpl5oFq+qlT9AOfHLD64L5Hn9C7Id2wSnXt7VgLXjOBAHzyQyRzC/obn7Jy8qVCZV31ez6deaUhXMio/i2Hc+QfuVXLaqH86wb9nukzEUZC2LddGWv+6Fds2L1YxzGQV2OezJKmXmY4jdK5gaU70tibXyjZGbrRRZ9ACpmdtFnUS/U15Kj0lCvYCrd9ekvwO1GyXF1Q7lkQ/dLV/sw4BMP9KeH7lFSSdtl1enHSOoEHvpQ4TXBYjEpTCgGGYw+UOrwi5Lv2J8tfHXpefff0HjUgoODKaxZqmzF/XKTVyg6tCh3n4TwDw06sv22GlwBuiLbkeLwF88zqpMCEUWQY8Ek4M/ets7IO2JFbFqVLwSCwC8hof8Kg6EKfb/t/4c6i4JkZ7+R7tlhhHW45Ixx+5xnpWDynwuSSs8qlomsxXKc7U4oSYygqF5+iU+l4YFKRa9ITHpST9dTnMeTwW1IUIgUtedQ22F8CQI1cCSkF66+5tRAJmQTuexDqgLSU3UU7x03D+15g2yRXJ6aDO5DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000009d310f065232683c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your questions. I'll address each one:

=3D=3D 1. Threat Model =3D=3D

The target scenario is a same-machine attacker
in multi-tenant/cloud environments where two
processes share physical L3 cache.

Example: a cryptographic service and a malicious
process running on the same host. The attacker
uses Flush+Reload to measure cache access timing
after every encryption operation =E2=80=94 no physical
access required.

This is documented with real measurements:
- Without TID: 78 cycles (Cache HIT =E2=80=94 key pattern visible)
- With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)

The 78-cycle result proves the data remains in
cache after memzero. If cache eviction happened
automatically, we would always see 286 cycles.

Full threat model: Section 2.1 of the paper.
Timing analysis: Section 5.2.

=3D=3D 2. Why Kernel Module and not userspace? =3D=3D

You are correct that CLFLUSHOPT does not require
Ring 0. However, userspace execution can be
interrupted by a Context Switch, which expands
the timing window from 372ns to 36,640ns =E2=80=94
making the attack significantly easier.

The Kernel Module guarantees:
- Non-preemption during the PROTECT+ZERO sequence
- Atomic execution across wipe + flush + barrier
- Reliable page locking via pin_user_pages_fast

This is documented in Section 5.2 and Section 5.4.

A userspace library implementation is a valid
alternative and is noted as future work =E2=80=94 the
goal is eventually integrating CLFLUSHOPT
directly into libsodium and OpenSSL.

=3D=3D 3. Why not add this directly to libraries? =3D=3D

No major security library implements CLFLUSHOPT
after wiping =E2=80=94 not OpenSSL, not libsodium, not
glibc, not memzero_explicit. This gap has existed
since Flush+Reload was published in 2014.

TID is a proof of concept that demonstrates the
PROTECT+ZERO protocol works. The next step is
proposing integration into existing libraries.

Full comparison table: Section 2.3 of the paper.

=3D=3D References =3D=3D

DOI: https://doi.org/10.5281/zenodo.17585929
GitHub: https://github.com/ahmaaaaadbntaaaaa-byte/
TID-The-Instant-Destroyer

Sections 2.1, 2.3, 5.2, 5.4 address your points
in detail.

Regards,
Ahmad Qasim Mohammad Hassan
Independent Hardware Security Researcher
ORCID: 0009-0001-4360-0802

=D9=81=D9=8A =D8=A7=D9=84=D8=AB=D9=84=D8=A7=D8=AB=D8=A7=D8=A1=D8=8C =D9=A1=
=D9=A9 =D9=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A7:=D9=A4=D9=
=A7 =D9=85 Jann Horn <jannh@google.com> =D9=83=D8=AA=D8=A8:

> On Mon, May 18, 2026 at 11:47=E2=80=AFPM Ahmed Hassan
> <ahmaaaaadbntaaaaa@gmail.com> wrote:
> >
> > Hi kernel developers,
> >
> > I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module
> > written in C that addresses a specific gap in existing security
> > libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)
> > flush CPU cache lines after memory zeroization.
> >
> >
> > =3D=3D Problem =3D=3D
> >
> > Standard zeroization functions (explicit_bzero, sodium_memzero,
> > OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do
> > not evict CPU cache lines (L1/L2/L3). This leaves residual key
> > material measurable via Flush+Reload (Yarom & Falkner, 2014) after
> > data use ends.
>
> The thing you're talking about isn't really related to the
> Flush+Reload side channel attack, right? You're just talking about
> flushing cache lines.
>
> In what threat model would this be an issue? Normally, the goal of
> memory zeroing is to ensure that sensitive data is wiped before an
> attacker has a chance to physically pull out the RAM from a machine
> and plug it into another device that can reveal RAM contents, or
> before an attacker gains physical control of a locked device and can
> connect malicious peripherals to it, or such.
>
> So for this to be an actual security problem, the device would have to
> keep running in a sufficiently high power state that data caches are
> not discarded, and at the same time not perform enough memory accesses
> to cause this memory to be discarded...
>
> Assuming that this is an actual problem, why are you using a kernel
> module for this? At least on x86, CLFLUSH is unprivileged, so crypto
> libraries should be able to just use that directly. (There is the
> caveat of what happens when the kernel migrates pages or kills a
> process, but that's a larger problem.)
>

--0000000000009d310f065232683c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Thank you for your questions. I&#39;ll address each one:<=
div dir=3D"auto"><br></div><div dir=3D"auto">=3D=3D 1. Threat Model =3D=3D<=
/div><div dir=3D"auto"><br></div><div dir=3D"auto">The target scenario is a=
 same-machine attacker=C2=A0</div><div dir=3D"auto">in multi-tenant/cloud e=
nvironments where two=C2=A0</div><div dir=3D"auto">processes share physical=
 L3 cache.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Example: a cr=
yptographic service and a malicious=C2=A0</div><div dir=3D"auto">process ru=
nning on the same host. The attacker=C2=A0</div><div dir=3D"auto">uses Flus=
h+Reload to measure cache access timing=C2=A0</div><div dir=3D"auto">after =
every encryption operation =E2=80=94 no physical=C2=A0</div><div dir=3D"aut=
o">access required.</div><div dir=3D"auto"><br></div><div dir=3D"auto">This=
 is documented with real measurements:</div><div dir=3D"auto">- Without TID=
: 78 cycles (Cache HIT =E2=80=94 key pattern visible)</div><div dir=3D"auto=
">- With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)</div><=
div dir=3D"auto"><br></div><div dir=3D"auto">The 78-cycle result proves the=
 data remains in=C2=A0</div><div dir=3D"auto">cache after memzero. If cache=
 eviction happened=C2=A0</div><div dir=3D"auto">automatically, we would alw=
ays see 286 cycles.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Full=
 threat model: Section 2.1 of the paper.</div><div dir=3D"auto">Timing anal=
ysis: Section 5.2.</div><div dir=3D"auto"><br></div><div dir=3D"auto">=3D=
=3D 2. Why Kernel Module and not userspace? =3D=3D</div><div dir=3D"auto"><=
br></div><div dir=3D"auto">You are correct that CLFLUSHOPT does not require=
=C2=A0</div><div dir=3D"auto">Ring 0. However, userspace execution can be=
=C2=A0</div><div dir=3D"auto">interrupted by a Context Switch, which expand=
s=C2=A0</div><div dir=3D"auto">the timing window from 372ns to 36,640ns =E2=
=80=94=C2=A0</div><div dir=3D"auto">making the attack significantly easier.=
</div><div dir=3D"auto"><br></div><div dir=3D"auto">The Kernel Module guara=
ntees:</div><div dir=3D"auto">- Non-preemption during the PROTECT+ZERO sequ=
ence</div><div dir=3D"auto">- Atomic execution across wipe + flush + barrie=
r</div><div dir=3D"auto">- Reliable page locking via pin_user_pages_fast</d=
iv><div dir=3D"auto"><br></div><div dir=3D"auto">This is documented in Sect=
ion 5.2 and Section 5.4.</div><div dir=3D"auto"><br></div><div dir=3D"auto"=
>A userspace library implementation is a valid=C2=A0</div><div dir=3D"auto"=
>alternative and is noted as future work =E2=80=94 the=C2=A0</div><div dir=
=3D"auto">goal is eventually integrating CLFLUSHOPT=C2=A0</div><div dir=3D"=
auto">directly into libsodium and OpenSSL.</div><div dir=3D"auto"><br></div=
><div dir=3D"auto">=3D=3D 3. Why not add this directly to libraries? =3D=3D=
</div><div dir=3D"auto"><br></div><div dir=3D"auto">No major security libra=
ry implements CLFLUSHOPT=C2=A0</div><div dir=3D"auto">after wiping =E2=80=
=94 not OpenSSL, not libsodium, not=C2=A0</div><div dir=3D"auto">glibc, not=
 memzero_explicit. This gap has existed=C2=A0</div><div dir=3D"auto">since =
Flush+Reload was published in 2014.</div><div dir=3D"auto"><br></div><div d=
ir=3D"auto">TID is a proof of concept that demonstrates the=C2=A0</div><div=
 dir=3D"auto">PROTECT+ZERO protocol works. The next step is=C2=A0</div><div=
 dir=3D"auto">proposing integration into existing libraries.</div><div dir=
=3D"auto"><br></div><div dir=3D"auto">Full comparison table: Section 2.3 of=
 the paper.</div><div dir=3D"auto"><br></div><div dir=3D"auto">=3D=3D Refer=
ences =3D=3D</div><div dir=3D"auto"><br></div><div dir=3D"auto">DOI: <a hre=
f=3D"https://doi.org/10.5281/zenodo.17585929">https://doi.org/10.5281/zenod=
o.17585929</a></div><div dir=3D"auto">GitHub: <a href=3D"https://github.com=
/ahmaaaaadbntaaaaa-byte/">https://github.com/ahmaaaaadbntaaaaa-byte/</a></d=
iv><div dir=3D"auto">TID-The-Instant-Destroyer</div><div dir=3D"auto"><br><=
/div><div dir=3D"auto">Sections 2.1, 2.3, 5.2, 5.4 address your points=C2=
=A0</div><div dir=3D"auto">in detail.</div><div dir=3D"auto"><br></div><div=
 dir=3D"auto">Regards,</div><div dir=3D"auto">Ahmad Qasim Mohammad Hassan</=
div><div dir=3D"auto">Independent Hardware Security Researcher</div><div di=
r=3D"auto">ORCID: 0009-0001-4360-0802</div></div><br><div class=3D"gmail_qu=
ote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">=D9=81=D9=
=8A =D8=A7=D9=84=D8=AB=D9=84=D8=A7=D8=AB=D8=A7=D8=A1=D8=8C =D9=A1=D9=A9 =D9=
=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A7:=D9=A4=D9=A7 =D9=85 =
Jann Horn &lt;<a href=3D"mailto:jannh@google.com">jannh@google.com</a>&gt; =
=D9=83=D8=AA=D8=A8:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Mon, May 18,=
 2026 at 11:47=E2=80=AFPM Ahmed Hassan<br>
&lt;<a href=3D"mailto:ahmaaaaadbntaaaaa@gmail.com" target=3D"_blank" rel=3D=
"noreferrer">ahmaaaaadbntaaaaa@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Hi kernel developers,<br>
&gt;<br>
&gt; I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module<b=
r>
&gt; written in C that addresses a specific gap in existing security<br>
&gt; libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)<b=
r>
&gt; flush CPU cache lines after memory zeroization.<br>
&gt;<br>
&gt;<br>
&gt; =3D=3D Problem =3D=3D<br>
&gt;<br>
&gt; Standard zeroization functions (explicit_bzero, sodium_memzero,<br>
&gt; OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do<br=
>
&gt; not evict CPU cache lines (L1/L2/L3). This leaves residual key<br>
&gt; material measurable via Flush+Reload (Yarom &amp; Falkner, 2014) after=
<br>
&gt; data use ends.<br>
<br>
The thing you&#39;re talking about isn&#39;t really related to the<br>
Flush+Reload side channel attack, right? You&#39;re just talking about<br>
flushing cache lines.<br>
<br>
In what threat model would this be an issue? Normally, the goal of<br>
memory zeroing is to ensure that sensitive data is wiped before an<br>
attacker has a chance to physically pull out the RAM from a machine<br>
and plug it into another device that can reveal RAM contents, or<br>
before an attacker gains physical control of a locked device and can<br>
connect malicious peripherals to it, or such.<br>
<br>
So for this to be an actual security problem, the device would have to<br>
keep running in a sufficiently high power state that data caches are<br>
not discarded, and at the same time not perform enough memory accesses<br>
to cause this memory to be discarded...<br>
<br>
Assuming that this is an actual problem, why are you using a kernel<br>
module for this? At least on x86, CLFLUSH is unprivileged, so crypto<br>
libraries should be able to just use that directly. (There is the<br>
caveat of what happens when the kernel migrates pages or kills a<br>
process, but that&#39;s a larger problem.)<br>
</blockquote></div>

--0000000000009d310f065232683c--

