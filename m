Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A22CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D0A6B0005; Tue, 19 May 2026 12:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DDA6B0088; Tue, 19 May 2026 12:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C206B008A; Tue, 19 May 2026 12:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B29556B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:47:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6374D1C05C4
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:47:58 +0000 (UTC)
X-FDA: 84784751436.28.53F6CFA
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 563D31C0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:47:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=elQ1OIu+;
	spf=pass (imf21.hostedemail.com: domain of jannh@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779209276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
	b=RaUmc+D8YDzHXEGp07R1coySnEvGPIQZNe4UkGmaRgKqPZ8a3zQuiEF/T4wY2jEjFY1r8l
	rG+3xvaP/R7JmqCCEniOxocufRTPZy3scGonH6LJABVDouHS/9zK6qmuruIXWTU8Vwzt8y
	duoLLhGqi+UNAu/n+kmkQHmZW6W4+A4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=elQ1OIu+;
	spf=pass (imf21.hostedemail.com: domain of jannh@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779209276; a=rsa-sha256;
	cv=pass;
	b=xNIN9ysESd3N2WtzeFiqdJ6wGswCXMET1H8AzNuGN5VASamd8z0h1nABBf74CRtt+5k20/
	6SinktV4xqe2ZYtqVZFPV4WYi38miOyvb0JfDIvIPfSO+ZiPpXFvs3diVuwgtR1+fMqhvc
	krn+cWQKz4DIw9j4+sOR+DCAmS1jmck=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12c8d0945b3so101c88.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:47:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779209275; cv=none;
        d=google.com; s=arc-20240605;
        b=QrdZJElG/uX5TorJcvM3y6MLUDfp6bGcpPOD6QwY/gyTZ+mCyZt9by/FhNy9TelWxN
         Pfuzaw6TWIYKhgFUDnR92G71krmLjdCCArf0n0RzTAOM/Ex/27TtxmWh9SWxKW+H5CZy
         NZ/xTSR1ElnEwNFcSU5c7KMKwnvUbpI2wz0EhgD/lHZ7Hb7bX0rhRDs+DhOzlNdmzxmP
         m+rX10XIhp6luXv7QlB9F75onLNieUJlq26dhcpvd5i6IEibzMHpXJ3CqTbzbW9YjpwX
         75e6gs5U98xyfZQwrKeZhjNDtK/f2epsHmnePGd5BDB8L0AlfVtYyvPUXRIrSH3jU5C0
         1xXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        fh=JI3Cnjj6vGdw8T4PvVQDdmVxwwvDxn0aYFL/1hghw8U=;
        b=jldVUohVCM9+m5I/kI0AFtN6qxT5jRpvI/Wm3RKomST5YwWFeFyWil9zkY9N4WrGZ1
         RyYKDJwYOUD9/soWl9Q88gZ+owmU9/ZWpyZSHxuVcOBmt72HydvCFKUFdcMXml01c/Vq
         2AxtU6KTuYFJvhhwsrN+KqNpc9mRAD8ccqDWyGNwIHEAmdFMWW60yv9AgaL1Q+M1ewtb
         nbkzo++wv8ZJdwfGBG2NA+LZ8jyFcRkQRho47A43M2wEoKH3btjkihRHKIROu0wqod7A
         7VVYiAofsP9DjQ3pUF72WB9+PqkfepdvE5Aby91B/LemJhn3g3TemcFTW6kGo3Z+iEA7
         mDOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779209275; x=1779814075; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        b=elQ1OIu+baxZoMb/L1b+nY+rMIoFR1OuCFc5Dk5MwCrW0YIYY4HiM5bc9h9MK5AWPZ
         VbLtf39qwpon7sBpt61o+YgsneVNVdf2SfsV6vE7VynfZGSpXsZqqxoqYl8E3aZhamZj
         pmoSUi8+CtM5PUWNiQXdMpEuSR6GJUBM7gnUeV3r8yOJPGh3D5LXMLinlE4x8CZqam0O
         SCdWHtJUUWbaVhjKrZBqW7ENnAGE/QX0dbIuEHWFnnyarwXFLngkKaZUPJF/LVYGdfbe
         50RcLShKdqyMNanrGheGD8V9GQp4MY/wCBDXgXdUiAbXcb/xNYT1B6SZBv90MPE4dyHk
         UH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779209275; x=1779814075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        b=W15Brj1s+qvvJXZdmL0qgRDEkZSEHNnio1ZlXqtuNWsJav/iPTlAicVKMyC+W2tf6f
         Df/mKb57RRGl0NOWTM2b3YHHzDkRv7hZEM3raKfNz6hOjE1zDbucW+4uN9UOi8zhCIhL
         VCMYnXDi2BEsXFcvDR6s9+Bbm4Gf6SEzslxowWX+Lr8uzPcJAlVlGTNgdHcxeHO3YE/I
         mz9ArpixxfFUAobRRqGq9KKfzGjrlhej6dUWLoKfyLTa2n7wcpPqdzoChoMF5dcvqe+L
         2fZBxRj1OvwKnSMMqHB+KFdAcG2ZMy8DmYjWGU+ZOTn6ZaKbgWGCI+0osuYdeve8Usz7
         Lrlg==
X-Forwarded-Encrypted: i=1; AFNElJ9s78OXqv6i7Lom7ktaIswEsD6G1o9KIQpnBkRgHOQBwmBJXT/8vI+rzp21mt4SvAYbkgOmYv6G6A==@kvack.org
X-Gm-Message-State: AOJu0YwSa/8P0OF7DubuMVSadEe/SKbmDsWQEfie4v+64bAKFkE2ItxB
	d5rkYD+BT50Qj9fSdShgIew89n9StrBI6BhuJE/4yWw0O2ObFsP0+FNZJuRz0ZfpIIM6uILH/Is
	wC3XoClEHvxdgl/TKGoya7jtWMJY7laS+HdQVuf3C
X-Gm-Gg: Acq92OGOuc1mq2GrcOnUqFyfVVr8HXThLH1MSThEoF0DjdC0Zz5k/uGNxRldbCrHKdd
	bN/KU36rcIEJfLIx3kotrESMsNCLaLf1htnHyOVks4N7mrj0MOpnbHU7K7wtRWSqvGJouYTC2w+
	z4+VtGGErNAs/F/MPI2flm0bSVdP3xeMJBGt7HKH5gF3JeCn0Gzw0cx+NXlE8gJvGxI/JpkoZ1h
	6nL1LN4ECgCDebOvPqCNMSUgL4iQV98kPYwgq27tEyBSqpt1wOy2BbWKzRTm8t2BNuSYKdB+ooG
	hmxc2LwWZ7AvaEK1zhdb2yM0+PryKNJrCMRziKSOU/0qqtH6
X-Received: by 2002:a05:7022:41a3:b0:12c:2ed4:6314 with SMTP id
 a92af1059eb24-13557dcef85mr326451c88.1.1779209273823; Tue, 19 May 2026
 09:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
In-Reply-To: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 May 2026 18:47:15 +0200
X-Gm-Features: AVHnY4LvG4Du5d39_T67NOwKnozMptM-y7xFRUTkKn7VXkYMQfWRo6DTkXiA7Lg
Message-ID: <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Ahmed Hassan <ahmaaaaadbntaaaaa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: noftfq9jh4s1u3dpqkq161r6etsjbw9p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 563D31C0007
X-Rspam-User: 
X-HE-Tag: 1779209276-154442
X-HE-Meta: U2FsdGVkX18pxzx2WAxkFsZvUnjtG6f674rb0QI6naM+HTdImDWOVnLhwq74CAoJKmNwCqLrlfQwb7i1s5FHzwQVMuF9EHdywedLucjpY2tFF1Syl56yiWghoIiLrHqyo9tVdYXUTcoiHhAOBWLf/DczgmVk3WkHMGh865DeOQ24f+POosaHIaX9PC2YQ04iNarbUz73/z2/p1uYY0/5ZdbuYf+BntX0Slpr0mTXVpZcBBERyOW8uM3qiU7kMf6k1Wr+v6d3nn4JM0RoLP/2ZxZvdSoQGRcCIqk7EVWK1ycHt3Yc4r8gcqj9A5zVtTX9mCiLzSPgvKj+fisUdpCQizGbiw4WF7xkM5rd300rP37KLfgrJsrF7X/9KsHNxHwRfHtmuQlvefSYCX7ITUPpKD5cw6RFsIFsOBaWJuHUa0vJUwfDq754MbvsnG5pJBTcRwRpFFT1DR1jMuQ+urWZTIllLIWTNbwHWWcjX9Jdh3z21vIuwKJCDcm4KTu1P2fc+H+fFqMEaLYTTFFrCmwxCP4jenMrqQHDqpqmWL8YerkT5iJYGFQ/uAqTzr7Btd4ADdeQ4c3ObbGWEMKX0Y48ENQ5E5xCVqCn6B2uGZ4gPTga8DDANZD2wCiPfAVUjXdcZ6sJAdMNDzSH5R+Kqv+c1bkvg60OIEmuxLa/5WM/RUGo4x0GODZqqUF92/bGYU5qLbpiaO+PeFBpK50ECdr496Xb6O+35bXJFy8t0sRiBq9qpNu3gThwNv5vMKSnGZklgaVBqH7iUeULbuGYfSufq48XdnrondVbDtjYcH40OnLiG+JRRFmG5suTp9+oM/xFW8c8LjKdSDZ2ItfKi9rGAn+KYMLqGd2vJ2uycJRrRH56gyDhvCiYUXRY/HJNabGqWrn2UaDe3BvM/jHPH5BA5SAcEziI8qCLLljML/wvfKMDKepTLZdlNI2eqvDs2QVMik5+jn9PohISpNtx2jE
 I7WCD8kw
 3GKknUJbMcm1acZ/Cna1FWw1jPIACTKmQ5vctV7OnNIszEQGF8zPASG+ZaB6s23QSIAX71icnVNfLtf5B4UYsjxCPjpTYLwKSxG07Bd4YhSJc3VO9PlMm0KKA6f4lrjfQcKinbARINlliqafIH7hJoou8cSX6IsEPZoqgvuTILxL/7JmMmNAIlACXahuE3rxWd6mPeBeznJ42VY2iTKT37nztjimeByGXZSDO9m1bhGt7yAYRD0ZwlnpuRBli7Fii2Fm2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 11:47=E2=80=AFPM Ahmed Hassan
<ahmaaaaadbntaaaaa@gmail.com> wrote:
>
> Hi kernel developers,
>
> I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module
> written in C that addresses a specific gap in existing security
> libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)
> flush CPU cache lines after memory zeroization.
>
>
> =3D=3D Problem =3D=3D
>
> Standard zeroization functions (explicit_bzero, sodium_memzero,
> OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do
> not evict CPU cache lines (L1/L2/L3). This leaves residual key
> material measurable via Flush+Reload (Yarom & Falkner, 2014) after
> data use ends.

The thing you're talking about isn't really related to the
Flush+Reload side channel attack, right? You're just talking about
flushing cache lines.

In what threat model would this be an issue? Normally, the goal of
memory zeroing is to ensure that sensitive data is wiped before an
attacker has a chance to physically pull out the RAM from a machine
and plug it into another device that can reveal RAM contents, or
before an attacker gains physical control of a locked device and can
connect malicious peripherals to it, or such.

So for this to be an actual security problem, the device would have to
keep running in a sufficiently high power state that data caches are
not discarded, and at the same time not perform enough memory accesses
to cause this memory to be discarded...

Assuming that this is an actual problem, why are you using a kernel
module for this? At least on x86, CLFLUSH is unprivileged, so crypto
libraries should be able to just use that directly. (There is the
caveat of what happens when the kernel migrates pages or kills a
process, but that's a larger problem.)

