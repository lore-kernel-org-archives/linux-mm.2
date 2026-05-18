Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DFACD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 22:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6006B0005; Mon, 18 May 2026 18:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985E06B0088; Mon, 18 May 2026 18:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8757A6B008C; Mon, 18 May 2026 18:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 747D76B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:41:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 176841C1EE8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:41:33 +0000 (UTC)
X-FDA: 84782013666.18.D246A46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36DBC180004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:41:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eVw2mnSZ;
	spf=pass (imf24.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779144091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IXXk7v/qEv3M4zFqHYAoDaxtXCsFGpwdyyKoLRUHheA=;
	b=BSXtxBjOaD+2PH1E8TzzmZJ1PvujEfpmNWrXTNoTyyVagOF60h9FQJJ/z9CTXXcsu6eXei
	10w2zNH2epcG1n4rNA0PgVQ69he+w4iT/nXA94hA5v6L89DCc9kKEKqn7NzsjvxjWtgdyT
	kYrTGmGh6WTd9SIvXYggtUnkQaAGIWo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eVw2mnSZ;
	spf=pass (imf24.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779144091; a=rsa-sha256;
	cv=none;
	b=WJFtkc2x4aF0493Ngqg6LyzXtStG9gMuxEowz6usb6WLsV0dDuE1+Qmc4n26MP4zKZ2BtF
	JB7XCxZec1ZKQ2wIi0q1L9LGDh8t/WqBoI5i+aRqpaycbvortcOKpdVK5NboxExpiYabeu
	DySx0ZAXjZx/mVRuiW+Ty0eR4UVKfUs=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48d146705b4so30719645e9.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 15:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779144089; x=1779748889; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:user-agent
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IXXk7v/qEv3M4zFqHYAoDaxtXCsFGpwdyyKoLRUHheA=;
        b=eVw2mnSZpSDPizoqqAI8KW89dLVciVG2g828oVajy0Z2vd8ILy+zw827XiTaheu+OD
         QgfBB4JQu+7xaux/9ZEcGQFhh/rmkQdfsA8eQkTQW17TJ6qM8MXHrIay/2py7NR2J0kB
         3kWJ0I9T8YpP6RUj4R8yVx05V2RY1m8bQoJ7RIQH0mdgcN0WMpSdfRLagnn/jH5vn2jH
         58hPK908L5QdAqxTEk3fE2FugSW9HiDeSokeBZBw5tffpr1KgksVjyaU1//MEUEKUwJc
         4qW3ktvqKqbgHjP5qL7co3A4SKI9Rnavw1nZ+41VODuuolFFxjpG6uFjmZFCn/hcWnIn
         F/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779144089; x=1779748889;
        h=content-transfer-encoding:mime-version:message-id:user-agent
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXXk7v/qEv3M4zFqHYAoDaxtXCsFGpwdyyKoLRUHheA=;
        b=pFyrDS9uOQQ0m9D5DPEd0Uj8XSWfWOaxQ2dD3D1353GYKzIZJvizZ2lPvzcsYEsP68
         zNOS4jZeMEVK2P1c0qZHt/I3r1pUBx/znc1JWO0MUSeMrSLfWKGKb+FADNQj4hG2rdj/
         HCLCKIIZDztmLpLW2jNxkTjT9ap9G8zYB3rpZ8GQIJ74M8ARsvZ2ia+sa8joJeyhYBjE
         JnwSh/KH8IDQ0vgcnZS6gIml8jnSAWkiqWVz06hbzweB68R2/2RbiTEeZePJ1qXXVAIq
         ybj6fijCIXFlYyHQ+LXIyQTtO6EZNtlXR1bghbuJy42+ku46Mi/ZzKBb+PtPb7jDSfVR
         PsWQ==
X-Gm-Message-State: AOJu0YwDNZcd+EgY7bWN62vkxyGo8CNJb92ljSpZCmut6NIk3NO1ctP1
	a0jwOU9cb3XrlNtq3iWcU0bxBnzrLPjUW3Lk7joLTdRKfQi5wKrtxjbb
X-Gm-Gg: Acq92OGvRg3Q+nLqKJGwjdUXK0ztN4fHnkXuzZv3dEpymgYqsiFVIJNzs8kDXlOBmFP
	eaCNnWwVE2JvlyHnOO5pGU2852whTFokOBWH6pdhYxTp+TqbTOWdT+fFdqMbDsJMe7T2Uujk2t7
	SgW8breJcrPYml/+TgZVwt0OhZfzcx+6beUeZUFCduyx2GpTSPTP60/zsPB3uBMi5/8U/qY3giI
	4xWpawRARkYFF9LtR98OKMs5zP2/9STF0KcHVS46MLORFr9GxOIgroSs0ZDmvM0Sqf0Epfoc2aY
	VwVhcs1juAIw9C4OF4AT5K8zFTEkLlFYIlFln7h08FfLs7olqpjATuORkWjXhze/W9k7NrQ0lUf
	Pl/lQ5P6LCjw52Xi/jARu/3YPvWo/NGhY8E9Py1u0ZVqMkQzWesFYC6RUkFuyu87qTXjHhvldL5
	swDnrUfeMA/pv8amuj0yIXOVU5GmQ5j5gUSMDFSwV+es5gBpK1T7YPTwk8
X-Received: by 2002:a05:600c:c167:b0:48f:d410:6065 with SMTP id 5b1f17b1804b1-48fe66138dfmr267818875e9.29.1779144089300;
        Mon, 18 May 2026 15:41:29 -0700 (PDT)
Received: from ehlo.thunderbird.net ([109.107.227.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5694fbfsm490779375e9.6.2026.05.18.15.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 15:41:28 -0700 (PDT)
Date: Tue, 19 May 2026 01:41:26 +0300
From: Ahmed Hassan <ahmaaaaadbntaaaaa@gmail.com>
To: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: =?US-ASCII?Q?TID_v2=2E0=3A_kernel_module_for_cache-line_zeroization_a?=
 =?US-ASCII?Q?gainst_Flush+Reload_=28CLFLUSHOPT_+_LFENCE_+_REP_STOSQ=29?=
User-Agent: K-9 Mail for Android
Message-ID: <2654EEE1-B945-4FCD-80F5-AAD8A70598F3@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----PSCRKFFTER75A87YPSE8CKSI3OYJBB
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 36DBC180004
X-Stat-Signature: wwrx536hsn5c5w7a5eqrstexd3wtjz3o
X-HE-Tag: 1779144090-677728
X-HE-Meta: U2FsdGVkX1+vvXEOvQiPu0O2L0T1XIbx1Ou427s3t4545F4+mme3RHjWVvI3AldCxKXBAp2gPkH4iHE6r+GxgzX4QWLRSbXeW9mNbc6GKfXcnSnB+la9dFl6xalsdGYPr3+b/58Wryys3wvtmYIp/u/3VMXjFXrGWy4yQ7OUxXoaTissseBwOvFt86wKyuVEbYR8jPUEiUuaKpwyQkagNDBVEHohwxXvMxaa+epCF0icEtnk4bzI2f+RLtXXgH3DEWUkYKwtN0nLxOLI1H+YG3aL1QuYFNNV0KSTQVufTQ+ZWIPwIt8Wlk3LxXy4dV5cr1YjP4kxZTEsZc8YFJjXSvXABj4OoTIhVqlLUfIyBi9xTfZMPg+dGTUFQFli3fiOPS+12CFu9KshiUB7w1XPLmX8bvKyTMnJHQIfQQTzJqhH3viPFaNVrMw4xMGQ1sbXO52c7CrIW9toBbe7WLn/5MjWDVr4ltLgd+lhxbYc98iO/dz7AyyuQnfR3HFZ+BN3widRj1gsqIwElGAfw+Lslobhz3N0E/6mu6iKJs5DlDc94QWXAvMzQq4F74ztV+q4g6mZDMxHp8cvIXAZIiPeM71TAErGH1SBTjE0iAvFwoPO28bxSQswsHDMkhwLIda7vvKSLJRS976rDH8svQ0OuUCyTu09ibaWi62XH1ghPh8WKQwtkNPHfHNo/f3T2lr7FsQIkJ5EDnvVWk6FKKvyL4JIMlbKXGTO1UAju5HMYLIYYbu4yATyZpID+nTULDUWTq1Fgu0T2zYcVuiG4t8ZYg6dQTHWJya7wnT0rEqMfxTkNMXpOxu4HEOKAytUxW1Brd+VzUQZGlbknR3NvAiW/ThSv63tzXqXPTR4ZrZWgp3SbIR2kn1bPIOT0k3NTL1Wjj2kjvLdbDnpq3wanCTRBfazyfqrMVLBqVo5ZMwuNcbT1Ab5syUl8tPiH7rwUcTWru7qP0msY+Gg2QxJhSP
 tBVdwT1H
 OGlfkytmyvkR9IOgZkcCExapPf2p/GB/vGj+OVcaqVAPsnGrg6BtdrzBpB0rcd0LKIR8MziSpDMbv+uA9gc6tctb/Dz34YDvFb6xzTiBCxJZxSbuCCEdkRJrmlIIO79dc1ff1aeUxAesJFmMBga3vqxySqSyYpZm5vA5UcD6aK6pgLfLxwHngfNl3uSfqdyRxGqC/sQdRSqRgonh/OQFFmqN7PqQvm/cAD3on/T9mPc8/VUky5ZoOavyurNCfYbNaneos3WwkWBqqNOytFqXVnZRh6/Ji7Bw9O4yzqMDbk3epzmVnRGVaKB1imnwmTozuomE3DMEC+Cw3kMj5nBukeTBt6vycco0o8kC4GahqGXWBznKoNXEpqpq/m7mjEofQ8g1eqQ0fvsjrHy2mhVPqRFY9gTosgVud5v1uqbe8SfGFIR3vVwD0F3D3CjF0UTWnyao+sXx9/mYlC/aoixtVUx6qD7OdBv1UhRe5mpNdkWcldhqOnmyBzHQSWZkGKED1ykNH1wsSGhs8/R3rllsMBTM41IU716PgFLZMQIXy/zOqlMRNB+OjIw2SYotxQdhAwDQNZOfPpn1fD4FyOsB1oR5Zvl0mY40UJuJ/nMHuXXGyHnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------PSCRKFFTER75A87YPSE8CKSI3OYJBB
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi kernel developers,


I am sharing TID (The Instant Destroyer) v2=2E0, a Linux kernel module

written in C that addresses a specific gap in existing security

libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)

flush CPU cache lines after memory zeroization=2E



=3D=3D Problem =3D=3D


Standard zeroization functions (explicit_bzero, sodium_memzero,

OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do

not evict CPU cache lines (L1/L2/L3)=2E This leaves residual key

material measurable via Flush+Reload (Yarom & Falkner, 2014) after

data use ends=2E



=3D=3D Approach: PROTECT+ZERO Protocol =3D=3D


TID combines three instructions in a single kernel module:


Phase 1 - PROTECT (before data use):

=C2=A0=C2=A0LFENCE =C2=A0 =C2=A0 <- close speculative execution window

=C2=A0=C2=A0MFENCE =C2=A0 =C2=A0 <- ensure all prior writes are complete


Phase 2 - ZERO (after data use):

=C2=A0=C2=A0LFENCE =C2=A0 =C2=A0 <- close speculation window

=C2=A0=C2=A0REP STOSQ=C2=A0 <- compiler-resistant wipe

=C2=A0=C2=A0CLFLUSHOPT <- evict all cache lines (L1/L2/L3)

=C2=A0=C2=A0MFENCE =C2=A0 =C2=A0 <- ensure eviction is complete

=C2=A0=C2=A0LFENCE =C2=A0 =C2=A0 <- close the far-side window


This follows directly the Intel Spectre Mitigation Guide (2018) and

AMD Speculative Execution Software Techniques (2018)=2E



=3D=3D Benchmark Results (AMD EPYC 9B14, Linux 6=2E14=2E11) =3D=3D


Without TID : attacker measures ~78 cycles=C2=A0 (Cache HIT)

With TID v2 : attacker measures ~286 cycles (Cache MISS)

Ratio =C2=A0 =C2=A0 =C2=A0 : 3=2E7x latency increase -- attack defeated


Physical lower bound confirmed:

=C2=A0=C2=A0LFENCE (~40ns) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)

=C2=A0=C2=A0+ MFENCE (~40ns) + LFENCE (~40ns) =3D ~320ns

=C2=A0=C2=A0(measured: 290-372ns)



=3D=3D What Distinguishes TID =3D=3D


No major security library implements CLFLUSHOPT post-wipe eviction=2E

TID is the only known kernel-module-level implementation of the

PROTECT+ZERO protocol=2E



=3D=3D Known Limitations =3D=3D


- A 372ns window during data use remains (physical lower bound);

=C2=A0=C2=A0v3=2E0 target via Intel CAT integration

- Requires same-machine attacker model (shared memory)

- Does not protect against cold-boot attacks

- Not a replacement for disk encryption



=3D=3D Project Details =3D=3D


License=C2=A0 : AGPL-3=2E0

Hardware : AMD EPYC 9B14 (Zen 4), x86_64

Kernel =C2=A0 : Linux 6=2E14=2E11

DOI=C2=A0 =C2=A0 =C2=A0 : https://doi=2Eorg/10=2E5281/zenodo=2E17585929

GitHub =C2=A0 : https://github=2Ecom/ahmaaaaadbntaaaaa-byte/The-Instant-De=
stroyer


Comments and technical criticism are welcome=2E


Regards,

Ahmad Qasim Mohammad Hassan

Independent Hardware Security Researcher

ORCID: 0009-0001-4360-0802


Ahmed Hassan 
------PSCRKFFTER75A87YPSE8CKSI3OYJBB
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html><html><body><div dir=3D"auto">Hi kernel developers,<br><br><=
br>I am sharing TID (The Instant Destroyer) v2=2E0, a Linux kernel module<b=
r><br>written in C that addresses a specific gap in existing security<br><b=
r>libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)<br><=
br>flush CPU cache lines after memory zeroization=2E<br><br><br><br>=3D=3D =
Problem =3D=3D<br><br><br>Standard zeroization functions (explicit_bzero, s=
odium_memzero,<br><br>OPENSSL_cleanse) prevent the compiler from eliding th=
e wipe, but do<br><br>not evict CPU cache lines (L1/L2/L3)=2E This leaves r=
esidual key<br><br>material measurable via Flush+Reload (Yarom &amp; Falkne=
r, 2014) after<br><br>data use ends=2E<br><br><br><br>=3D=3D Approach: PROT=
ECT+ZERO Protocol =3D=3D<br><br><br>TID combines three instructions in a si=
ngle kernel module:<br><br><br>Phase 1 - PROTECT (before data use):<br><br>=
=C2=A0=C2=A0LFENCE =C2=A0 =C2=A0 &lt;- close speculative execution window<b=
r><br>=C2=A0=C2=A0MFENCE =C2=A0 =C2=A0 &lt;- ensure all prior writes are co=
mplete<br><br><br>Phase 2 - ZERO (after data use):<br><br>=C2=A0=C2=A0LFENC=
E =C2=A0 =C2=A0 &lt;- close speculation window<br><br>=C2=A0=C2=A0REP STOSQ=
=C2=A0 &lt;- compiler-resistant wipe<br><br>=C2=A0=C2=A0CLFLUSHOPT &lt;- ev=
ict all cache lines (L1/L2/L3)<br><br>=C2=A0=C2=A0MFENCE =C2=A0 =C2=A0 &lt;=
- ensure eviction is complete<br><br>=C2=A0=C2=A0LFENCE =C2=A0 =C2=A0 &lt;-=
 close the far-side window<br><br><br>This follows directly the Intel Spect=
re Mitigation Guide (2018) and<br><br>AMD Speculative Execution Software Te=
chniques (2018)=2E<br><br><br><br>=3D=3D Benchmark Results (AMD EPYC 9B14, =
Linux 6=2E14=2E11) =3D=3D<br><br><br>Without TID : attacker measures ~78 cy=
cles=C2=A0 (Cache HIT)<br><br>With TID v2 : attacker measures ~286 cycles (=
Cache MISS)<br><br>Ratio =C2=A0 =C2=A0 =C2=A0 : 3=2E7x latency increase -- =
attack defeated<br><br><br>Physical lower bound confirmed:<br><br>=C2=A0=C2=
=A0LFENCE (~40ns) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)<br><br>=C2=A0=
=C2=A0+ MFENCE (~40ns) + LFENCE (~40ns) =3D ~320ns<br><br>=C2=A0=C2=A0(meas=
ured: 290-372ns)<br><br><br><br>=3D=3D What Distinguishes TID =3D=3D<br><br=
><br>No major security library implements CLFLUSHOPT post-wipe eviction=2E<=
br><br>TID is the only known kernel-module-level implementation of the<br><=
br>PROTECT+ZERO protocol=2E<br><br><br><br>=3D=3D Known Limitations =3D=3D<=
br><br><br>- A 372ns window during data use remains (physical lower bound);=
<br><br>=C2=A0=C2=A0v3=2E0 target via Intel CAT integration<br><br>- Requir=
es same-machine attacker model (shared memory)<br><br>- Does not protect ag=
ainst cold-boot attacks<br><br>- Not a replacement for disk encryption<br><=
br><br><br>=3D=3D Project Details =3D=3D<br><br><br>License=C2=A0 : AGPL-3=
=2E0<br><br>Hardware : AMD EPYC 9B14 (Zen 4), x86_64<br><br>Kernel =C2=A0 :=
 Linux 6=2E14=2E11<br><br>DOI=C2=A0 =C2=A0 =C2=A0 : <a href=3D"https://doi=
=2Eorg/10=2E5281/zenodo=2E17585929">https://doi=2Eorg/10=2E5281/zenodo=2E17=
585929</a><br><br>GitHub =C2=A0 : <a href=3D"https://github=2Ecom/ahmaaaaad=
bntaaaaa-byte/The-Instant-Destroyer">https://github=2Ecom/ahmaaaaadbntaaaaa=
-byte/The-Instant-Destroyer</a><br><br><br>Comments and technical criticism=
 are welcome=2E<br><br><br>Regards,<br><br>Ahmad Qasim Mohammad Hassan<br><=
br>Independent Hardware Security Researcher<br><br>ORCID: 0009-0001-4360-08=
02<br><br></div><div dir=3D"auto">Ahmed Hassan </div></body></html>
------PSCRKFFTER75A87YPSE8CKSI3OYJBB--

