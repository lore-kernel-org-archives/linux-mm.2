Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327F0CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684CB8E009D; Fri, 24 Oct 2025 10:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C948E0042; Fri, 24 Oct 2025 10:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5992B8E009D; Fri, 24 Oct 2025 10:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 479868E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:17:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2BDB5DA5B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:17:56 +0000 (UTC)
X-FDA: 84033211752.23.9751B2E
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id E8FE04001D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:17:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jwh9uSV+;
	spf=pass (imf07.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761315475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNTn99TnA1JaXfaY3Rpqv497vvNlynqkAU5Ssl8CUuk=;
	b=oDuMrPwn+940ubXbo96EIyXlPC/ErAziTAzqWzNTVB9mdp5Sw50qIki4o3Z+zoIdWK3FiM
	9KinWEe3054eqEbW6Fcd+vRPCBtjBPaYtky3EChZTImMrQB3EB/Fxs4Jfefg4huFzCRZq9
	creSD5Y/+egevlK5G9Vtg4QGQcFiRko=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jwh9uSV+;
	spf=pass (imf07.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761315475; a=rsa-sha256;
	cv=none;
	b=3qN/jpujzXcWVfxa2NdlW6jAg09QLY48gHjaGgAWPCY8cUcPrEbkjQSpvRq4VfcV7S0Y88
	c7G+BOoQaHcyJuT6ZiFLoJRF1LSrG9JcBwu61GHIDruSgXCRLf5MDRI1BGov7Gr531U7U5
	7rqYrTDZbM26Zz4ZO9xpJ4R3TqJc4o4=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4711b95226dso24042405e9.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761315473; x=1761920273; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNTn99TnA1JaXfaY3Rpqv497vvNlynqkAU5Ssl8CUuk=;
        b=Jwh9uSV+Dbhg8BAMH1cAgkeamQzMhB2uQDWSDKukO90OXX36tk4R2K5t/dC8w0kq/I
         xTQUpGjnpipT8pSS6qHSwRYoISUAZIWodgveIb+rpwAvYcpuUt1j8Pc28rQvvmbgrQbb
         Q5QI05dBFFZg9z7swUyUHF9dn8gOzAbGMcDqF9UUQLIL/soi4YCx6Suc762bAawS1IjB
         wnY+beW9kjX3xZISXI0IGYFRzM9UQI6QqszvnmCaBdCyK3A5ygSVGtVZPlDC/dvUpuCJ
         ENTLeVWVbp+O3cK7gE5bSgv4yVDfqUypH/0L7c5TYbdmGhXO2xa+9PdFgAQ05lZ0EXLD
         KQig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761315473; x=1761920273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SNTn99TnA1JaXfaY3Rpqv497vvNlynqkAU5Ssl8CUuk=;
        b=UQPEJfNkJwkN+tNvdGuQRJTy+GqImPDcGnOga/WZ00Y+BTOdNvNQDl5m2DHe9JtNZL
         5p/JQMsxwNqoimkjGfK7xDAutGHIMwca4hDRERJ4ujwgqIU8SWTWwkZZ13uHIt5uvSVR
         ShCdbmLx058uTYSe5uH56/sO65nQVGFm9xb6TLYjUkIzUfpEICCFzK4t/XQqUGEfmITD
         Pcm4L4tBHKT3z8s5pMaojpgbxGPXGJbZrrH8be1KKQweHPjD6o7yk4ShqNXTEqdtZvkP
         Z6px+mB50qAcPPNY7fILc/3P332Sh1gYFZkWfiI5wdHg28Z6e1sULrRzbfwHm4W/3IMG
         Y/uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYHCVvkH7gHdfqRwOnCgj99Tt2qWHTvZ4wuTAF9jEUQlxR3i0T2P1iiW/BUWQPcNFzEHi8nuNvyQ==@kvack.org
X-Gm-Message-State: AOJu0Yyi2aH1SJvFdSSohkO4CnMObzuk9q1DUgk2kvayRr10hNczxSaO
	AWocX3pkO5lYwo831qtcybo80UhI0D47Oz5wjuEG7lSs0cwXI6AEQMNSfwwMvkXC5hnmDiJIY6L
	dgf01ZJ/s8p77asYBcN9nn14HnVk62jk=
X-Gm-Gg: ASbGncub6hQ66yRwq81Dn/ggJd4vFu08Mzwwxdb6I3QJ+fyz8GyYn9NCBVq3xgcDsF0
	1wh0isuG4IsXo7N1mAUofz/Y8K+nr1hBGS2JMndtpQTkyrEgyZE/Cb2to4Q1jF/xPE+QZyoTpIq
	VzGrmDqRS+tRQ/LH16L75lLiU5mVNUNVBdq82fhi2tI/vHsouFiEoTv0E+SRKGR2Nww2+VJ66TB
	+dF/CiMhohAXj6WUtGzG0ktUpMuHpYnTJNqRsNACifplF1uJxr35+CAsaEvbdBLFryq/YsYbuMz
	/KrpgRYuU4GWutNz/UCF+oqifPKBR7UxixknAHRg
X-Google-Smtp-Source: AGHT+IFX/G3bo8Uoav+A3W6y2COb3eJCl2p4q4v176xd43F6DF6xlmRapKd53ZZrE98dyTCCRF3vN4Q17nc/YbCzBW0=
X-Received: by 2002:a05:600c:34d5:b0:46f:b42e:e394 with SMTP id
 5b1f17b1804b1-4711793473fmr217356125e9.41.1761315473041; Fri, 24 Oct 2025
 07:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <20251023131600.1103431-1-harry.yoo@oracle.com>
 <aPrLF0OUK651M4dk@hyeyoo> <CA+fCnZezoWn40BaS3cgmCeLwjT+5AndzcQLc=wH3BjMCu6_YCw@mail.gmail.com>
 <aPs6Na_GUhRzPW7v@hyeyoo>
In-Reply-To: <aPs6Na_GUhRzPW7v@hyeyoo>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 24 Oct 2025 16:17:41 +0200
X-Gm-Features: AWmQ_bka8VrwR-Z0b8RrCs_zbS1hTWfVkUFTv-W6umfuWyIbEP-ZV0vS8gZH8jE
Message-ID: <CA+fCnZeMwOE1EwuP-3Xrs2e0qp_A5eo2aiXB_q243GiLFZV-=Q@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: ensure all metadata in slab object are word-aligned
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, 
	Alexander Potapenko <glider@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Feng Tang <feng.79.tang@gmail.com>, 
	Christoph Lameter <cl@gentwo.org>, Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E8FE04001D
X-Stat-Signature: sx8jdsfku38b51xfa3heq1kt5q1p7ctx
X-Rspam-User: 
X-HE-Tag: 1761315474-342625
X-HE-Meta: U2FsdGVkX1/GqpzZgsb3JXhHDityHdr6HFb4kRKcqpy1BAAyyYd9bnuVFQdjPrkBqQiiANnhtlIUCF9ma98P2UqixI86CiCR1zzvkcezVnpPN9jJjstVErwkdGXgEaScf9a5GUQijL2sYjXE0MqkmbLOB1GLHLXyB9oukZjSH3XdZya/XIdnEgqxDVUDFH66heus3WvqTCS6RcDTqRnVApzoPZ9NmSdz585LOKJebdsobbI71pub04m2rsPAViKI3Dg8jY8dzvD1ddIFjyctRgAhUxIhjpM247h1qcXWvrIEfPw1q2PA/4GOYoKOif25E965DQaQP8G7RRo8tUi+BXMYKDrI0tRyT/H98UPeO2GH/kXZvTKkAy3L47Rcgrjg5pQAijnlGvNczcDmlkGIFIX2pCva/4veEdF6N9r1bQuL0vcKstufpGjKlRul7VF5scucpfCMVmxEjPTYft598GiO3UjevcAqMzoVjB8aoFjStis/M9ryWpdglh8HRtz3vOtczbZuEWNKUqFz7JId3i9MSPLlGOE49XZZWjhzAw1UmpjjxQFkg3aBntuX9BQb4tZVCbZ0fyvJzaZ27Xb+ieBEWSjrdp7AU+FcUGidGHcpV8Py0oyxJ846Hl077RPPK/SbyxuPQ1JBbJeg6Sjnunidtrywk9ksmEFxrbCpgJjtYp+bPFrDSXLDQ7A0Hbb5s/4ta8JiC+6gQsFDa9vgozT7urpDRrU83xFlDWkaBSaDFzlq8l5H8KWM5LX4hD7ApMxKyy35WvFw/U2S05sYvxPl21trFABkKH+sLHzhLFcxJSjOK16RZbTZagRcpJXqdxM8MuuJAoGm+5Aa+g+AdZzBAyz+Jjph9a9Dpjq9vHYKNrYr8XMceBhZAAYcOZGaFX7cPb2LqgF0xCZiRE5ZM6oHdDtLziufLZwanJPva/EjtePGOmQzYnBYwvSizQLcIs+YXIPM0ydNgMFpoic
 nnCL6l4D
 UOocGdcABZd/MwrAb51F1f1fTpPBFUYXgon5qcmWWDyu+UDc1eKJsS6oATEwwjwR1jVKCO7zpWwCvruiSwoWb/GoOBrcJPxFVBC404NpQIP4+y0UJrQrVDEc7fE7HZY2yPbW5cUxQmQK7RoOeIzF7MXLJHkxbDn3mCHE46XYgM2R3DpDVMHEpykZ/9Db99utvFWuwbWqx8ns0g1ood40GaYXFE7IvVrvojoXZaemsTpTKm3fwZddrGs/Yx5DjIF2t8cvXvaghKSx/l4QC7Gc33ShaEP4Lg8/azLlMQ9FZmL2NIilANzEIZkaSF6sY3ZFN9yHAKAQamhDN1GWrz2La9SNHZKthNahAiRKsmFjI3JNkpA27hTUlycJnaDU1Iv2+9QXw1bvziqo5F0Zx/s+HnxCqgeYd+CmJxSQOJJGPvbY7nfnVonyQ1kRyPGIet3bKioruqSpV9C5m1CLmBZ1ZD/oSebrdOUPeBD3c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:35=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> w=
rote:
>
> > An alternative to unpoisoning or disabling KASAN could be to add
> > helper functions annotated with __no_sanitize_address that do the
> > required accesses. And make them inlined when KASAN is disabled to
> > avoid the performance hit.
>
> This sounds reasonable, let me try this instead of unpoisoning
> metadata. Thanks.

But note that you still need kasan_reset_tag() for HW_TAGS KASAN: this
mode is not based on compiler instrumentation and thus
__no_sanitize_address has no effect on it.

(There's been some discussion on making __no_sanitize_address work for
HW_TAGS: https://bugzilla.kernel.org/show_bug.cgi?id=3D212513#c2, but
this was never attempted.)

> > On a side note, you might also need to check whether SW_TAGS KASAN and
> > KMSAN would be unhappy with your changes:
> >
> > - When we do kasan_disable_current() or metadata_access_enable(), we
> > also do kasan_reset_tag();
> > - In metadata_access_enable(), we disable KMSAN as well.
>
> Thanks for pointing this out!
>
> Just to clarify, by calling kasan_reset_tag() we clear tag from the addre=
ss
> so that SW or HW tag based KASAN won't report access violation? (because
> there is no valid tag in the address?)

Yeah, kind of: kasan_reset_tag() sets the pointer tag (the top byte)
to 0xFF. With SW_TAGS KASAN, the compiler knows not to embed validity
checks for accesses through pointers with 0xFF in the top byte. With
HW_TAGS KASAN, the CPU is instructed to behave the same.

(This is slightly different than kasan_disable_current(): with
kasan_reset_tag(), validity checks do not happen at all. With
kasan_disable_current(), the checks happen but the bug reports are
ignored.)

Thank you!

