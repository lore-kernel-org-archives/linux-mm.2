Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED6DCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339096B0005; Mon, 18 May 2026 17:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2616B0088; Mon, 18 May 2026 17:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B136B008C; Mon, 18 May 2026 17:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F03DC6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:40:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 978FF40AB8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:40:06 +0000 (UTC)
X-FDA: 84781858812.19.E366979
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0F6D180003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:40:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="i1HBGL/U";
	spf=pass (imf16.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779140404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=u3x/laSl/cXThLkBNBE4Ng9WrKRc2pOzPBZ0vXrjTrQ=;
	b=C2NoYHm0qK93QvNbQZJE1ZaIhJyrnTgV7u/1KWSu1MCe0N4Qkk/RSsYijR+dFoluMs7Epx
	D8Bqu/4HhxKujUHc8O+UdLhOze2VslVpuHU2RmGASpT/GaeqsRBJuGqBg2L5ZrExkurCt1
	NySnbLAXj9y4RQfws4gAv7dJTt7phKA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779140404; a=rsa-sha256;
	cv=none;
	b=pP7VLUD4NBCK2kvOmr0HV481AJXyg5UnQM7NjfH5502TnGHuI6SD+E8OqGCA+yarUSkE/Q
	eH2gxX1nQDC1LEDbjKYHg0WWZKIIlgxFi5g+YhnAEYlncfSw1grBOylLPd/IZS1cKpLW+h
	eHj36lxxStWBSHjb2efU8mApgnVZ8us=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="i1HBGL/U";
	spf=pass (imf16.hostedemail.com: domain of ahmaaaaadbntaaaaa@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=ahmaaaaadbntaaaaa@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48ff4f8ef0dso31887265e9.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 14:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779140403; x=1779745203; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:user-agent
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u3x/laSl/cXThLkBNBE4Ng9WrKRc2pOzPBZ0vXrjTrQ=;
        b=i1HBGL/UV3Nzj3V5U8gZXqTH8QJ0WdbLmovvADi6fxFjXAv/GMx5TEFjnN3reMkaAn
         vyG5UghOKROQkc/0T3gAixmZlNZoK/JvD+il55Sz8wX/iyKAd/WOVJL9ywqLloyFb02p
         dpAog2raKAscB3YJHvCYje6+6omp16ec+Iqc3vixXmtemvyzVAAIaUNgFSNhUEUWDtvE
         8Jn55Suj1vRtbKhDSgD8JDWZooY+BeXV5uAKRUwo8aPnZOCqgEj/LbFck77/VFxNO2Aq
         0qe8vErypdocOSpgXoSSbH4l6oWHIR4Io4yHriP51bXbIi/eJjfDZGOdFfpPBnja14Lh
         89ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779140403; x=1779745203;
        h=content-transfer-encoding:mime-version:message-id:user-agent
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3x/laSl/cXThLkBNBE4Ng9WrKRc2pOzPBZ0vXrjTrQ=;
        b=smQI2rRvcHI2bQRRkT0wOWWtdXhbZUuMj8tjaskTIRc8vmB93kEYgNyhmqV9h2PMU6
         oCa1LTqDqBj9vIAWGy/sQm8GTPE9qxsWZp3+VFvlXyEf0mYYv1gXSHgTb5HFOG/Bi5/G
         S5acpgD9+dbMWYjcwuXgG8sT1RYNpyx5+6f7Whjs558+Z8nrUH85Y4UkSH2/7pOBeT8Z
         yEBCIvslmgsvgh0RvoSEBkodQn5Ts1XDqJPmHOcghlTECmXC8x814r9Gr3CE7LtL3MBv
         KsKaZtcplmv2AgnhxZGI9tnswchPUZUpN38aPmYZzGYgY6Ai5Xkequm5257ReOph6mOX
         Z4nw==
X-Forwarded-Encrypted: i=1; AFNElJ9OVN+k0NhvPyJfvgL0X1rfTXqwNUXozw+3bnOWUNQtGlo62M203Gaz8OTfkcd0hC3Q70YMsh/CHw==@kvack.org
X-Gm-Message-State: AOJu0YzEDmKsUxpr9zoEJLw0opnVwljIyAGpEyXPvtXPJXbphoUQeh4o
	OsQIvMQElTqQ/8iKtk3wJ1v6T5Dich5CR7nhIJCK2n5mObe/R5oUTs/G
X-Gm-Gg: Acq92OHrrX2DpMS7hOlRqk+GbFbr6vcoatrWQOJP1w8S7Qi4dx+aKfxEE5d/Jq/cI9a
	s0xvp+Yhy0lc2JgcaqOmBF0nVdZL/HA0AaYmqPGe2Go7zA6rY75FNUDM7fnMQ9PX+9gI3D7PXpU
	hyj1AzwvEmsA/UYxGXUywFyVFBGwPSY1sP9Tzd9VDs1DeURsgoNlh2xhcGdNRXsxdjKTuRH/rhk
	lJLs7iPx4L6El497Fvrnr0dYZKh55Te1Lu0nNrCdACxEVoyisp7hCUiHlKUdwL+lpwddsTuYVn9
	Rw0vKprmodt8C6AJIaBr6ncrSwVxHbnNYgOXq6ByuOx20rZF5Es7dWbaCcpXucw/wxK9kxwTAzb
	ZtysYyXGZ5YfB1Vgf1OP9UuVtYE44TqWnZuBhCPW9cAMw64Y17XXke2oDrmof6E2Ag9pqT/KF0I
	ZnWAKs853U0vCK+/NZkOCtr7BZ++jYi6vW+wroTy/pX731gQ==
X-Received: by 2002:a05:600c:a010:b0:48f:e230:2a1e with SMTP id 5b1f17b1804b1-48fe66316cfmr247405255e9.33.1779140402904;
        Mon, 18 May 2026 14:40:02 -0700 (PDT)
Received: from ehlo.thunderbird.net ([109.107.227.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4900c16c744sm97088995e9.3.2026.05.18.14.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 14:40:02 -0700 (PDT)
Date: Tue, 19 May 2026 00:39:59 +0300
From: Ahmed Hassan <ahmaaaaadbntaaaaa@gmail.com>
To: linux-kernel@vger.kernel.org
CC: linux-security-module@vger.kernel.org, linux-hardening@vger.kernel.org,
 kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org,
 linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: =?US-ASCII?Q?=5BRFC=5D_TID_v2=2E0=3A_kernel_modu?=
 =?US-ASCII?Q?le_for_cache-line_zeroizatio?=
 =?US-ASCII?Q?n_against_Flush+Reload_=28CLFLUSHOPT_+_LFENCE_+_REP_STOSQ=29?=
User-Agent: K-9 Mail for Android
Message-ID: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----CDKNMF2C75Z7NW35JVKMW1L7XC4WCL
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B0F6D180003
X-Rspam-User: 
X-Stat-Signature: b17t818sfqwertdrn6357cby1sznmaax
X-HE-Tag: 1779140404-415322
X-HE-Meta: U2FsdGVkX18dipzQ6H5VJXs8Ip3hGZN3u6e665oPyAistMS/YyD+lD1HZohaBZnHoT2dk7X4A4DRq/kNnl9Zr+w6rQ0Wv7/nNFz+YOmXypY1Y0byhJr7+8ngAslIjHrFRIdvV3eQTaRIc2/qy5+uIFvTaacjkTzBWYZt7TRzBGprrhCEQR1NZGwkqi39uKUWyaMiGs5ff+asAGc0D+6MUUMvLo2Rx49c/uQdGRnK4WVuLVGJHCEHSVghvHz9sA31gP3ZabjVcHHILGF1Ou95mcMu2EQWHXWd2r4vMqTBBWbfksmd9l/KMGSPkbiEBPHBdY2v9jeOIPsRcCbnWwowbkmsoaJiKDOOaL2PzwUYvBAQOYYensWnXRRNjiDyqmniJJpPW/4RL900pwAwqgggCncj25MgT89x844qitKt8vmaaSEL0/u9UOsfEaCYxubXyICU3bnSk83e6iVaZ/aGwq4xGc5RriYUxCu92qmcW/gdFIaeUZhl7K48GpSoJrO+0i5IPe7lXvojgokGec4E0seaEXPi4l23A3Gmt57AnG4FqyxbypInRwlNBXKz3Uwhz++Of1QKRKxpEKUoA6nHZHM96l/X8fZRiuDtN9SmWFbjADOlI0HaLWkMP8AaYGdZah03woX0wVWeca6SaZjX0R0+vWB3VHR3kHV85X8IjBsx4W569UGn5ND+nff7VSmqqc5QEQuC8KoKs2qVGR2fVH+9Ag9uh20vqVF9NizFizXIRs7Yh6kHCi+cOhCnCqAtcXPBCxQG7OEJn/uIoP2yN44JQe3Y76h2NbMTbqIYjR4qwBvmjV1ZyERIknlHI1C9ujzBnw4RWUkwIytNuSA1z//mOli2y+g6iOnDSm8ju2Hhb7UIUaThySeG226EsaTCl2518YjLAQ1zpaY5tuNWlP0X6/2M7L9SPmYc63/0Q7DM7WuT7gs4UjrvcVpAM9fKttJK+6lCOG9e/GU9VWb
 463m8Xxa
 hQd/hCjAtCrumr6aCyg5QnFm2ze23Jr+iPZjf8irVd9vHeFwR42f5MZhXJc1He3q1lPqW+NXI5Zrf4Jlqxp/rAdsNOWKgyvLsKyLg0DzJT1CyP7fAv+455WOh5/fgESL57GN85FKDy46YmoCwKreD+ML8wZde0QRxF/+hZ6RDtGCjgIzGb8y4352ivOhF/nG8oJ+uTXMA06XUnYdXXzVDuXpPnMjO5kjIwmducSKSmlPCcKxNjEfFYWlhP+XAOUcT2D0+BJCFHUYcBPR39y73OaQHwCtlK1mKEfogEwxzm3vqOwJT9N3tLdZHT16uiTP+SF+sFNFhvZQ7ncDsGbsuC5gtb/d+/Lz4B+IFVpJ2m0ZodChjdZ7uqkgYWb8Uk5ibJF5Z/mRs81oqWvWdR3bxraGTfFErfOB/tcrHMIBHdfmkRNsy0SHQzHc9ek82R8vPMoaRBGcyufx+Y0Vi7QOfUthXDzwJZ9LDKTLy2i4GhQFJSIpVYAV8TxMr+oorHzaDpFFaH3uGArlVihTxp/r2y6cnJgPrwHDGb4rORKWjUGdRLptcsraubOk7GU21OE2NvsWDBUWOwbM0XTlfXtpYcItBXExqSPJbkmaFdId+sZol4uk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------CDKNMF2C75Z7NW35JVKMW1L7XC4WCL
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
  LFENCE     <- close speculative execution window
  MFENCE     <- ensure all prior writes are complete

Phase 2 - ZERO (after data use):
  LFENCE     <- close speculation window
  REP STOSQ  <- compiler-resistant wipe
  CLFLUSHOPT <- evict all cache lines (L1/L2/L3)
  MFENCE     <- ensure eviction is complete
  LFENCE     <- close the far-side window

This follows directly the Intel Spectre Mitigation Guide (2018) and
AMD Speculative Execution Software Techniques (2018)=2E


=3D=3D Benchmark Results (AMD EPYC 9B14, Linux 6=2E14=2E11) =3D=3D

Without TID : attacker measures ~78 cycles  (Cache HIT)
With TID v2 : attacker measures ~286 cycles (Cache MISS)
Ratio       : 3=2E7x latency increase -- attack defeated

Physical lower bound confirmed:
  LFENCE (~40ns) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)
  + MFENCE (~40ns) + LFENCE (~40ns) =3D ~320ns
  (measured: 290-372ns)


=3D=3D What Distinguishes TID =3D=3D

No major security library implements CLFLUSHOPT post-wipe eviction=2E
TID is the only known kernel-module-level implementation of the
PROTECT+ZERO protocol=2E


=3D=3D Known Limitations =3D=3D

- A 372ns window during data use remains (physical lower bound);
  v3=2E0 target via Intel CAT integration
- Requires same-machine attacker model (shared memory)
- Does not protect against cold-boot attacks
- Not a replacement for disk encryption


=3D=3D Project Details =3D=3D

License  : AGPL-3=2E0
Hardware : AMD EPYC 9B14 (Zen 4), x86_64
Kernel   : Linux 6=2E14=2E11
DOI      : https://doi=2Eorg/10=2E5281/zenodo=2E17585929
GitHub   : https://github=2Ecom/ahmaaaaadbntaaaaa-byte/The-Instant-Destroy=
er

Comments and technical criticism are welcome=2E

Regards,
Ahmad Qasim Mohammad Hassan
Independent Hardware Security Researcher
ORCID: 0009-0001-4360-0802
Ahmed Hassan 
------CDKNMF2C75Z7NW35JVKMW1L7XC4WCL
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html><html><body><div dir=3D"auto">Hi kernel developers,<br><br>I=
 am sharing TID (The Instant Destroyer) v2=2E0, a Linux kernel module<br>wr=
itten in C that addresses a specific gap in existing security<br>libraries:=
 none of them (libsodium, OpenSSL, glibc memzero_explicit)<br>flush CPU cac=
he lines after memory zeroization=2E<br><br><br>=3D=3D Problem =3D=3D<br><b=
r>Standard zeroization functions (explicit_bzero, sodium_memzero,<br>OPENSS=
L_cleanse) prevent the compiler from eliding the wipe, but do<br>not evict =
CPU cache lines (L1/L2/L3)=2E This leaves residual key<br>material measurab=
le via Flush+Reload (Yarom &amp; Falkner, 2014) after<br>data use ends=2E<b=
r><br><br>=3D=3D Approach: PROTECT+ZERO Protocol =3D=3D<br><br>TID combines=
 three instructions in a single kernel module:<br><br>Phase 1 - PROTECT (be=
fore data use):<br>=C2=A0 LFENCE=C2=A0=C2=A0=C2=A0=C2=A0 &lt;- close specul=
ative execution window<br>=C2=A0 MFENCE=C2=A0=C2=A0=C2=A0=C2=A0 &lt;- ensur=
e all prior writes are complete<br><br>Phase 2 - ZERO (after data use):<br>=
=C2=A0 LFENCE=C2=A0=C2=A0=C2=A0=C2=A0 &lt;- close speculation window<br>=C2=
=A0 REP STOSQ=C2=A0 &lt;- compiler-resistant wipe<br>=C2=A0 CLFLUSHOPT &lt;=
- evict all cache lines (L1/L2/L3)<br>=C2=A0 MFENCE=C2=A0=C2=A0=C2=A0=C2=A0=
 &lt;- ensure eviction is complete<br>=C2=A0 LFENCE=C2=A0=C2=A0=C2=A0=C2=A0=
 &lt;- close the far-side window<br><br>This follows directly the Intel Spe=
ctre Mitigation Guide (2018) and<br>AMD Speculative Execution Software Tech=
niques (2018)=2E<br><br><br>=3D=3D Benchmark Results (AMD EPYC 9B14, Linux =
6=2E14=2E11) =3D=3D<br><br>Without TID : attacker measures ~78 cycles=C2=A0=
 (Cache HIT)<br>With TID v2 : attacker measures ~286 cycles (Cache MISS)<br=
>Ratio=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 3=2E7x latency increase -- att=
ack defeated<br><br>Physical lower bound confirmed:<br>=C2=A0 LFENCE (~40ns=
) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)<br>=C2=A0 + MFENCE (~40ns) + LF=
ENCE (~40ns) =3D ~320ns<br>=C2=A0 (measured: 290-372ns)<br><br><br>=3D=3D W=
hat Distinguishes TID =3D=3D<br><br>No major security library implements CL=
FLUSHOPT post-wipe eviction=2E<br>TID is the only known kernel-module-level=
 implementation of the<br>PROTECT+ZERO protocol=2E<br><br><br>=3D=3D Known =
Limitations =3D=3D<br><br>- A 372ns window during data use remains (physica=
l lower bound);<br>=C2=A0 v3=2E0 target via Intel CAT integration<br>- Requ=
ires same-machine attacker model (shared memory)<br>- Does not protect agai=
nst cold-boot attacks<br>- Not a replacement for disk encryption<br><br><br=
>=3D=3D Project Details =3D=3D<br><br>License=C2=A0 : AGPL-3=2E0<br>Hardwar=
e : AMD EPYC 9B14 (Zen 4), x86_64<br>Kernel=C2=A0=C2=A0 : Linux 6=2E14=2E11=
<br>DOI=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : <a href=3D"https://doi=2Eorg/10=2E5=
281/zenodo=2E17585929">https://doi=2Eorg/10=2E5281/zenodo=2E17585929</a><br=
>GitHub=C2=A0=C2=A0 : <a href=3D"https://github=2Ecom/ahmaaaaadbntaaaaa-byt=
e/The-Instant-Destroyer">https://github=2Ecom/ahmaaaaadbntaaaaa-byte/The-In=
stant-Destroyer</a><br><br>Comments and technical criticism are welcome=2E<=
br><br>Regards,<br>Ahmad Qasim Mohammad Hassan<br>Independent Hardware Secu=
rity Researcher<br>ORCID: 0009-0001-4360-0802</div><div dir=3D"auto">Ahmed =
Hassan </div></body></html>
------CDKNMF2C75Z7NW35JVKMW1L7XC4WCL--

