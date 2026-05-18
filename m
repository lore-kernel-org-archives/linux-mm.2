Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA11CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414346B0005; Mon, 18 May 2026 19:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C51C6B0088; Mon, 18 May 2026 19:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B48F6B008C; Mon, 18 May 2026 19:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16AB16B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:14:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB5BB1A0A91
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:14:07 +0000 (UTC)
X-FDA: 84782095734.16.3C9845B
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE744C0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:14:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdemMpKo;
	spf=pass (imf28.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779146045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IKm5QKQR8VUeuWe4WzzPmriV1yZ8lMI2aWg9ysnRnEw=;
	b=mHqSvLrP7heqZABoTEzFxu7wIDlPRiiSM5Zz6RSuHUiW4Ul9XXLvrddRnUv12XbSrzZPjB
	FZIWG/jFk6kdcSDaFDcJkstFGi/u50y5DZ9rRyBhKoiwKEzsW0A12cOvPMJ7qzH8WvYrEA
	+lSAuPVxaTHQndqkiY7kxe7yjmbvY2M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779146045; a=rsa-sha256;
	cv=pass;
	b=fKSliQhtXwgJXliwY9XPMO9cUiSDTjLvzPuyJZwMnc/yNsBGQ4YAQL3uxP+ptdz/I+P1xE
	l+AvIDt6V+Xw2lIv8dh+qjm6gnXe3vTEaC9HL1DtcG9tkJyWN9uaKon+tzdK4nRB4Cbgc2
	SyZ0RWuh/KjTIqGLgA+dJzqG433YNx0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdemMpKo;
	spf=pass (imf28.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-686af4e582aso890764a12.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:14:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779146044; cv=none;
        d=google.com; s=arc-20240605;
        b=Xwk+TMrqskcG1CGXBY1LlRY7l+iXalW4obVxSk46Q2etbxAqG7ozVy39mfTxorvtY3
         NWPKVIetGN1I/03o9UyprA1K2UthoTLuJ4L5lOzHk2SeS+aOgIIAMdRS0biwyPpxju3U
         7J6dGDix6daPYQF+2qX+8yXQ17MUyBMePLjp/dgkDW2eZuALQKl+b12OGo4s3VhOJwfj
         1eXhTZGWJG9VWbw82hUb5iNovT6SwUNjOJSqPPSSK7mJ4R8NrhHn5JHb9HUYucR8xQEt
         KNxuHk56XljTnB2siJBZylBIC6ikBd5SSbGD/XUgMFPTw2+I88ljSvOn5Z7TgDPt27nh
         LZ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=IKm5QKQR8VUeuWe4WzzPmriV1yZ8lMI2aWg9ysnRnEw=;
        fh=uMbeTObNh8XGKCYGyWbhDNL9WCzZi3SooKA8jopGuXQ=;
        b=dgJWQOwMk05UisJlWMv+9+lpA1e+87oBX7bNRX9L3E/Q/H4qP3qqEwzzBEWa2oISKC
         m5yLAax9D5p8CDBQZQ0DjTPh+so7TN4ltcZHZJ5lH+a4NZz+xA++pj6I9KNnoXP4HRTB
         moNfnq2WhUW97Oei3k/jahnAjkBeM/PnYIXcsaZLpLKrV5mqs83IFxLjGuJdPKpSm8oN
         ++0OltslMZJbv5KzHVYO2so3VMriJykqo8txKUWF6Tuc7fgzyout/9/Q6ntL3cJ9H7qa
         diiB7Sil86okLy1MyZ/aVcxV+k8VplsrifxW7mBThgTrknEM2vi/iAZQLx52RuYG0KFM
         Edmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779146044; x=1779750844; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IKm5QKQR8VUeuWe4WzzPmriV1yZ8lMI2aWg9ysnRnEw=;
        b=kdemMpKohGoML/eWrUAqtjvwbZ+W+sVzhaxmMrrj+jZeH1s+JRJCd1W6XkOkdKroWS
         OMOkXeri/o0cgavA0Atc1S1urMnCL5b+or9NUt4Lzfcs2DksNGQlBg8OFe0esSpdRWzq
         h7Z/6ydi9Wb4o3YptV49MyZ4vnyEFvdcyV+0AzdispHYA8lhWzwq8DoT9Oq4Jxk639B3
         KHDx7aWU/GM0S/7BlBOI+aAjfjRmFBUC8iVXlYCJ3sAxOj8alDJW/68CYWUA0BkwHRTT
         Bp4iAOwiMvPmMdz/f/Oy1AdjjM/1EMkDOb+dvNdXmXSYV1l7xdVHAHWhRpDrFaZ6YBkU
         BHOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779146044; x=1779750844;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKm5QKQR8VUeuWe4WzzPmriV1yZ8lMI2aWg9ysnRnEw=;
        b=oCLwMDp0XizJSMw0k2bMIiU733lYHucTzJGjKxm0tFhOoyKCVQ9jgPE5eWj+w5ltf7
         I7UjWNRgyaLURtK4pQG3MevVhhRIdrGQOg8B2c04IH6ugHGWLeRdWyXgBJjVSVcgwXmk
         FPd894EL2yAmszslBbuh38OoQoi6lvGWd0Aey/+CHztZL3NVuUZhjWoPp8OxRZGU8wGa
         XHrXgCP96LuNUGBQ9k3I8pOve750m38/B82ZQlX/CeDo9qDpiZWTSyW1WJfFJ5xGqkZ1
         4cy5iqb57Z/bCkrEjHH9sV2Eb/EnW3Ykv17Z7lUIaBeDr3RJPzZe5ocjGmi70IIP/e2b
         EPLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/+X+94NRL9HqTA9TMiq6VeU6WNuHrBSzurdNIsRnK1me2Z2C38aB6aqsrYpDhL5yMot9c+bunmAw==@kvack.org
X-Gm-Message-State: AOJu0YxRK411cMC1bPQz8CmqGaOzksNu8GxOF99wUlZ9ds9YYDXYCp6d
	cQvI6Ncoc1mKji1GacXJfHnU6jTaPqzuWaQ3bUujemJrqE5iSMX/bXJvYbOqhTCxQpJ6DYa7qAE
	WeNe0RghqKLHLGSubZgCGCEmMHDLZe+Q=
X-Gm-Gg: Acq92OFlo/wONY+3UwkDiVHpKU1Ay2ItSNtFr86W7C501C9azVypXA6n1NHC5ynxuzj
	KMduOLe9GCmzeeekfHjgkLw8VEvaLfprKT5hkH7SkuSGBK3GFyyfnUx2W9CmWatendYVPoofKY4
	6R/elX0yVQxwieRAr8P22a4LwlZMtaGeWTwtSVqs/83jkxpYQOiVbrVsGbhRLIMcitTqrVU7CJw
	6R0CMtLdkli1VI2VhEKJplt2+4unFU+tZHaVe+VbIP+JbIt/Il56C2EkDU8UvBciyMHELF1weXQ
	4MDMy/15vlKf/JCHp2pR
X-Received: by 2002:a05:6402:a0cb:b0:676:e619:2be0 with SMTP id
 4fb4d7f45d1cf-683b4b8f9e3mr6404463a12.8.1779146044056; Mon, 18 May 2026
 16:14:04 -0700 (PDT)
MIME-Version: 1.0
From: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Date: Tue, 19 May 2026 02:13:52 +0300
X-Gm-Features: AVHnY4Kcw5tfKaz7bxQUfTVohvsHtO1JypTsC2D_N4_NdgHolnz-i1HFCs2vz9c
Message-ID: <CAAmtCfPiwDmyycoON5bTjhaT9s0yPd1wWHvT+=PEd+J4OW1+gA@mail.gmail.com>
Subject: TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000f5a75806521fb7ab"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE744C0002
X-Rspam-User: 
X-Stat-Signature: jp937qwcc76yk5bip678aemzxbckktor
X-HE-Tag: 1779146045-124544
X-HE-Meta: U2FsdGVkX1/4tSbiJLDqZYSkdSku1Ymmt2lbU+T0aHoakhL1kt4XZ6vGauitnijVs1SQUUz9sUMT5xKCr6PutLvAI0WNwK0ZxObYhuYR8g7qSiRJ/xQ2rc4YfDECBilGqdv00a4B+6mIZ/pkueRsmqt0yv+xmXuLlw/Kchv0riCoDJELEBoKHitLoyl1seL5DH3jB39DWc/YI2IiL3A8IPkVIEhXh4mSUtUp+84wrexMUUEdC/0LjcpHF5EQ2Ab99b6w3IpshWN4TWtnbQJgVC33nctLvM910k3qOKbyCLf1K3L4aKACKa6j9krmnzghokZ7XsgC0W3qBjgj1atsX4i4QlMHmfc25NEH3aHD6IrVP+D/IN9tAaHB5YThQYvjOKNpCS/PkGO1qEp8IaYB5te6PKx1zn0LnfRjrNO+MRs/ECIols0IOW/O53XbpqpDXUqhPvaFeFeXTmuxdh3Q4mfTnXz+Dv++3k8odNvBQjSw1zZLhR5B6HeDTv48Wgf+rV8muBfJlSjdrSoI4qvhQ7QUr8H1YVnkiYgtk6sFUsnzr7tm4bKfDthKbBOLvUhSwQ7A9BeqjGGGenS3wwcRe5fHVDNH0MPke087xD+5XKQCBn+Kn4t/7lRVWxeOcHInhWRekh8NjiUdOcwvqT2sj37GAfxeuZMYHMedVrM8rwsebSy6zlPiwxXJtAnpd5h8VGxbEZkPE+CR21BNuTA4aKz7xO9Gn9hiSeRwA3aRGyhMg8Z3EgcEUXoXR558ZiWYG46mJK4/YlEpSc+QCFPhFATy2TVwQMLB/P7A/FHufZpjenMYXE68kakQM9Vi0SsydRrSVsHFzbl6odxbd6AcRAax6Xf+gZxqH/0tfXwq8QCNoDk9JijzIszFz8TVGh1/dh2aosUZSTQW3Q4fCYHQ2snK/8oAqmZHyW6u28Iau4MMl7A92mG9LHnoibPNKvCBUpcRamwtWSHQlF7x9cs
 Wlk2kkcC
 FdaFVH0aj9J9fg7PCaVgeQbWOiC5qOHDEBhSN1Z7pjtrjUIKHbAgaiUK6MteykvKncItwBO7W2tDUYmSd+7I2GyIOXMdvrn/yUqtb/YKo1G/Mdiw+rmywG1h3g1V9SrPils81CmYTrTJGJHJQYYe0ZkzOJuJ4TG1XJJQk7to6l+tPoPXWmJq89VzGRPvVgkYeMjCVoDh1QftaaubWvPdhv/L8MegBrb7Zf+bzuH+NuPK92LPoWJ1dbjWmiKERtklsDqqtNihv6mTEnT5ykza5r95qKXRvX0tzj4VP4soV7IpZ8SuyYidGNSfo182rusOkGZyhuFInItgPznZLGSzlPJomXUNuemruCHnxXcmli7iOjY/u4iAPzCw5nGE5j/T34Yoe2JmqyoIBeVqS9R1aH47fA/j0NjS1l10Ca4mBZ3R11ZEbZKY+7jGz9xF2XW454ceauDfGQC6PV7lCqIwtYZemshD8XN+TS7lVXR2MMp6wL9UletqwD91ZboP57Z8RInjSSfBS7/lMnSBMN7M7a1riJyRQzMHN2mSU2msXkZ3PqjU30g3vi0fk3ks4TZCJt5UeYt3KoGSWx4UVMmObdZfU/v1kRY7/wtEgk/oUqg1L4e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f5a75806521fb7ab
Content-Type: text/plain; charset="UTF-8"

Hi kernel developers,

I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module
written in C that addresses a specific gap in existing security
libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)
flush CPU cache lines after memory zeroization.


== Problem ==

Standard zeroization functions (explicit_bzero, sodium_memzero,
OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do
not evict CPU cache lines (L1/L2/L3). This leaves residual key
material measurable via Flush+Reload (Yarom & Falkner, 2014) after
data use ends.


== Approach: PROTECT+ZERO Protocol ==

TID combines three instructions in a single kernel module:

Phase 1 - PROTECT (before data use):
  LFENCE <- close speculative execution window
  MFENCE <- ensure all prior writes are complete

Phase 2 - ZERO (after data use):
  LFENCE <- close speculation window
  REP STOSQ <- compiler-resistant wipe
  CLFLUSHOPT <- evict all cache lines (L1/L2/L3)
  MFENCE <- ensure eviction is complete
  LFENCE <- close the far-side window

This follows directly the Intel Spectre Mitigation Guide (2018) and
AMD Speculative Execution Software Techniques (2018).


== Benchmark Results (AMD EPYC 9B14, Linux 6.14.11) ==

Without TID : attacker measures ~78 cycles (Cache HIT)
With TID v2 : attacker measures ~286 cycles (Cache MISS)
Ratio : 3.7x latency increase -- attack defeated

Physical lower bound confirmed:
  LFENCE (~40ns) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)
  + MFENCE (~40ns) + LFENCE (~40ns) = ~320ns
  (measured: 290-372ns)


== What Distinguishes TID ==

No major security library implements CLFLUSHOPT post-wipe eviction.
TID is the only known kernel-module-level implementation of the
PROTECT+ZERO protocol.


== Known Limitations ==

- A 372ns window during data use remains (physical lower bound);
  v3.0 target via Intel CAT integration
- Requires same-machine attacker model (shared memory)
- Does not protect against cold-boot attacks
- Not a replacement for disk encryption


== Project Details ==

License : AGPL-3.0
Hardware : AMD EPYC 9B14 (Zen 4), x86_64
Kernel : Linux 6.14.11
DOI : https://doi.org/10.5281/zenodo.17585929
GitHub : https://github.com/ahmaaaaadbntaaaaa-byte/The-Instant-Destroyer

Comments and technical criticism are welcome.

Regards,
Ahmad Qasim Mohammad Hassan
Independent Hardware Security Researcher
ORCID: 0009-0001-4360-0802

--000000000000f5a75806521fb7ab
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"rtl">Hi kernel developers,<div><br></div><div>I am sharing TID =
(The Instant Destroyer) v2.0, a Linux kernel module</div><div>written in C =
that addresses a specific gap in existing security</div><div>libraries: non=
e of them (libsodium, OpenSSL, glibc memzero_explicit)</div><div>flush CPU =
cache lines after memory zeroization.</div><div><br></div><div><br></div><d=
iv>=3D=3D Problem =3D=3D</div><div><br></div><div>Standard zeroization func=
tions (explicit_bzero, sodium_memzero,</div><div>OPENSSL_cleanse) prevent t=
he compiler from eliding the wipe, but do</div><div>not evict CPU cache lin=
es (L1/L2/L3). This leaves residual key</div><div>material measurable via F=
lush+Reload (Yarom &amp; Falkner, 2014) after</div><div>data use ends.</div=
><div><br></div><div><br></div><div>=3D=3D Approach: PROTECT+ZERO Protocol =
=3D=3D</div><div><br></div><div>TID combines three instructions in a single=
 kernel module:</div><div><br></div><div>Phase 1 - PROTECT (before data use=
):</div><div>=C2=A0 LFENCE     &lt;- close speculative execution window</di=
v><div>=C2=A0 MFENCE     &lt;- ensure all prior writes are complete</div><d=
iv><br></div><div>Phase 2 - ZERO (after data use):</div><div>=C2=A0 LFENCE =
    &lt;- close speculation window</div><div>=C2=A0 REP STOSQ  &lt;- compil=
er-resistant wipe</div><div>=C2=A0 CLFLUSHOPT &lt;- evict all cache lines (=
L1/L2/L3)</div><div>=C2=A0 MFENCE     &lt;- ensure eviction is complete</di=
v><div>=C2=A0 LFENCE     &lt;- close the far-side window</div><div><br></di=
v><div>This follows directly the Intel Spectre Mitigation Guide (2018) and<=
/div><div>AMD Speculative Execution Software Techniques (2018).</div><div><=
br></div><div><br></div><div>=3D=3D Benchmark Results (AMD EPYC 9B14, Linux=
 6.14.11) =3D=3D</div><div><br></div><div>Without TID : attacker measures ~=
78 cycles  (Cache HIT)</div><div>With TID v2 : attacker measures ~286 cycle=
s (Cache MISS)</div><div>Ratio       : 3.7x latency increase -- attack defe=
ated</div><div><br></div><div>Physical lower bound confirmed:</div><div>=C2=
=A0 LFENCE (~40ns) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)</div><div>=C2=
=A0 + MFENCE (~40ns) + LFENCE (~40ns) =3D ~320ns</div><div>=C2=A0 (measured=
: 290-372ns)</div><div><br></div><div><br></div><div>=3D=3D What Distinguis=
hes TID =3D=3D</div><div><br></div><div>No major security library implement=
s CLFLUSHOPT post-wipe eviction.</div><div>TID is the only known kernel-mod=
ule-level implementation of the</div><div>PROTECT+ZERO protocol.</div><div>=
<br></div><div><br></div><div>=3D=3D Known Limitations =3D=3D</div><div><br=
></div><div>- A 372ns window during data use remains (physical lower bound)=
;</div><div>=C2=A0 v3.0 target via Intel CAT integration</div><div>- Requir=
es same-machine attacker model (shared memory)</div><div>- Does not protect=
 against cold-boot attacks</div><div>- Not a replacement for disk encryptio=
n</div><div><br></div><div><br></div><div>=3D=3D Project Details =3D=3D</di=
v><div><br></div><div>License  : AGPL-3.0</div><div>Hardware : AMD EPYC 9B1=
4 (Zen 4), x86_64</div><div>Kernel   : Linux 6.14.11</div><div>DOI      : <=
a href=3D"https://doi.org/10.5281/zenodo.17585929">https://doi.org/10.5281/=
zenodo.17585929</a></div><div>GitHub   : <a href=3D"https://github.com/ahma=
aaaadbntaaaaa-byte/The-Instant-Destroyer">https://github.com/ahmaaaaadbntaa=
aaa-byte/The-Instant-Destroyer</a></div><div><br></div><div>Comments and te=
chnical criticism are welcome.</div><div><br></div><div>Regards,</div><div>=
Ahmad Qasim Mohammad Hassan</div><div>Independent Hardware Security Researc=
her</div><div>ORCID: 0009-0001-4360-0802</div></div>

--000000000000f5a75806521fb7ab--

