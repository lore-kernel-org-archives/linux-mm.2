Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB64CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F756B0088; Tue, 12 May 2026 09:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F82D6B008A; Tue, 12 May 2026 09:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CDC6B008C; Tue, 12 May 2026 09:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 739916B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:33:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16241404EF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:33:38 +0000 (UTC)
X-FDA: 84758860116.28.4A19B0C
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1E4D280003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:33:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rJ2qh8AI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778592816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1jJ/gf21v5jTsHW/66Kz9VjA9WYKFK/yu8KnI8oy8w=;
	b=nc+wyQrA3Cm1DQVJZC84Ixnbz07LjYzaYA0AVmUuZZPwu7/FtnPAsgYvqf8Qhnlgff1Jon
	JSX2w5C0bnLYBjsi8Jd7P6g6o9fwrpV7a660k9tKSezsLaKqeBKXem1BbuVDN5GR1DR0Nf
	kIWLkkRmivuJt6CpWYATsYUCmSVKkMg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778592816; a=rsa-sha256;
	cv=pass;
	b=cNyXb3ujOar6JXnbQPCkLiJi//DRwapAawO5p4PgMlRLzgr8JtrRLU1CtYvpGCtlcg3h17
	IpJUnikiiq2/vdxWokl3XLWNh7adRR+Vl6M9u5+NBWhODqjP2FKibOIMzzGxpbYgtXZov8
	SknZwCq460EQrT3cA3RcSoIx5TU8+5M=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rJ2qh8AI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-671f1a0d0c5so314a12.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 06:33:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778592814; cv=none;
        d=google.com; s=arc-20240605;
        b=f6nRJ90jzYEc9Hrw5hU3oQGs2eBAzQl4o4PiW8CQ7FfHbDTzZ60Y2rFXZWTuElFREN
         65wpx+VFbrXYvm6YwNrKAGmsmZsqKw6wmxKfhOs4yGLUhvNGK4OROlSDfF0XQfkrKZ8Z
         VJx1/Q2OzRkf3D/Irk6GMiGcDKA5XRmpYSs4yD1xDX0JMfu1Oth9C3KSG9HypKl3e9HV
         E6AaOGqn1a5EZkQglfsTiG4+KC2ZFTILZ35FQ7Qe9hdBhwokOdpvBoFxAtDjCLY+i/aF
         1J/Lrg6etu/IuVhPBGwuItFP7NpLQZmqWp8Yi2Ex/tM0kPYSJ9wHRMmr5tuFQYDyt5qP
         nj8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D1jJ/gf21v5jTsHW/66Kz9VjA9WYKFK/yu8KnI8oy8w=;
        fh=jIG//DhUFQ0VTh9OwdkkTPVL20d10npg6/zhWP7dtTA=;
        b=VQ4sV5jgPCltRou17mHHsuYV6FOSM2iCC+4jUfaQW4deqcRkxFET7vFz6AHHRtfsv6
         0p9WD0P1MKoM5thRdupBAx3dDeRCRKTaAuKGAeTLh74yt0mo+fk7tP2DBTaqPfcypF6k
         qVB3X+useRvBI8qKYyGGI6oY5vbK+45Bu30JSQfdmWMu8iOHEtRqgXsxCgU/jMHxMoOa
         Jn8QTcZfDP/nFjqgQyBK6O2IKoAqLlZBpOskiZ+VKONrVQRWIWmRqDE1SmC8LBkWTd7I
         UK1VCy9c4x9+VI6I1ZeXfqQkii3KqtODBisyzI4KhnuzhzqDWXd2n1CDaL2KwEaAvexc
         RgaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778592814; x=1779197614; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1jJ/gf21v5jTsHW/66Kz9VjA9WYKFK/yu8KnI8oy8w=;
        b=rJ2qh8AIc29BjmrRqKRsl/zZBvF2wGO0Sraex/bfV7lrKq5k1KFAaq63xTsUFWf0V3
         q3peyMldlOPNzXg9gs1lJBxehAqkBiufleJrAqXVfY9DT30TjNo8WNWwHklmy3Vn2345
         9l0mfkgBhnfQKXFumpzuum4ioXlHZjMuuwYdO8u15cBf71FWzp8hb7U4+mALEJ87G4HJ
         RvIyHiKP2p3qIj0A0sA2yaXKu0A8ff7+bS2nRjPX1E47Ozbm5rxb130oLZpfAtAMB0vN
         7iV/N/PApHTqMBOVnfudhuH1ieotzSiOpGUXIM+MpH6BL/D/kKkrw97Yw4jtMlAIbUzv
         s2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778592814; x=1779197614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D1jJ/gf21v5jTsHW/66Kz9VjA9WYKFK/yu8KnI8oy8w=;
        b=P+TQcAec/p3hcXZEFRtEFc2gKBgogZJLrlFxkm7qXrD2hY++yPZlN5I+kjOfw1KS90
         +m5BgJcFjWwUAiSdcfxAmNg4bHSMijU75jS59Ne5wRWKc+E44ih/ghzdM3Vjjg8HTSmz
         NaYMUBQ3071DX4BUWmSO9PS+FwcG8f/TnoCE0hHTE5H6qEQuvwt8ZF0SLu+O5bsPa+8h
         aYTSRcfyHJeXPVPOCr/9hA0IL+xjRpgWToWdkzNZO7YyqjUHw+NhT3B8QxWZfYct2G03
         5mEWdr4Pg4j4mRqg9gQjsMYGahKpQvDAiEO0QuubxQC4VEgzC4R4+YHnNI4Jfj3j0T/3
         Wjqw==
X-Forwarded-Encrypted: i=1; AFNElJ9emOAk46uusmDiNPHiIMxVKxOdrHLvQr2alX8Z4IG3wIm6rj+LWrRBwZr2tgEKTvUDOWo98wr8qA==@kvack.org
X-Gm-Message-State: AOJu0YwHGRIvMjHCvhTqOIctY1a2Peb1c718k1KxMtqeSqfFsHg1XmEK
	H4JZir/FUA0qiAdHNmfvdO3mQErQvW26SwtX0v0K0ojtHsIZ2FKvDJtkMQlyiM2X7DYA1UTHAY8
	SwWdSUVZB2w5oML9lGbgIChzpoU0eMX9VVNLz7nvr
X-Gm-Gg: Acq92OHt/3zfuvtbrHIMxqugYqPMJVWn62afxX/Et5Fjb+wvA4thPstXMYGlGVzNR9u
	rA7P6PUmo0NSq2nWnSnLK3xpezAgIT0hpZFmn3RPWgOAt41EQOU9qK6diQi2yBWVQiwoHFIN0+Z
	bzpAnREJXYqfT+a3yzLc+FfbgAIFHQG8ipSpp4B3x/54Z5v32X8baZvMwibbR1bxupxat12ryPq
	q1QvFoTDN5R0rz6HuwZfQiknxgQosq4qtivKla5MpD/4wS9guosuydi8AZ1pF7YoXXN/eZSsKGr
	F32N8VXMuKOHR2OabUS3XLS1JpGM9nxjL7jhBbDk9OInDJfF
X-Received: by 2002:aa7:c7cd:0:b0:67b:8283:6240 with SMTP id
 4fb4d7f45d1cf-680dab0c7c9mr39195a12.7.1778592813829; Tue, 12 May 2026
 06:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2ed44M=-qsZO7gwcz5L2njdRdk54d47jEg48MhWTkaew@mail.gmail.com>
 <20260512023129.44966-1-lance.yang@linux.dev>
In-Reply-To: <20260512023129.44966-1-lance.yang@linux.dev>
From: Jann Horn <jannh@google.com>
Date: Tue, 12 May 2026 15:32:57 +0200
X-Gm-Features: AVHnY4LZwF_WYCVPXafYsLmjKwF1Trc0n8j0sGJfDYhW6dPI4yRtQ6ztFmHrTkM
Message-ID: <CAG48ez1xdO1wkqS+eAcnAV9QJ25=t1o0-Qz4qTZdg1Mo+en2QA@mail.gmail.com>
Subject: Re: [PATCH] mm: make zeropage read-only
To: Lance Yang <lance.yang@linux.dev>
Cc: rppt@kernel.org, akpm@linux-foundation.org, arnd@arndb.de, 
	linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, ardb@kernel.org, sethjenkins@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E4D280003
X-Rspamd-Server: rspam04
X-Stat-Signature: 1mczwbhxup3dazfxkeffamf7q1p1miuo
X-HE-Tag: 1778592815-743973
X-HE-Meta: U2FsdGVkX19L6bIiWHlKXxwZWND+R8mGuY4STHTxp8bVczhC5HN7bBt1c8BIT1UHl+S4cn6sjKtHEKNGMus/IBkbPXtBQFAPUweb04LIiL4NHzb+6h7WjWEapa7zdgILWjIAMFITuA2TSvZDsg/iNavp5UURcZ6oSgiVRjEJOj3zX2WSZCgF2ygAy/O2mFdhukQ4V4aT2/hxGpDqe0YqOlejV3o3bOuQY6FNJUhYCaHk7iNP9UpPjEW/itg+xR3UKybo2ymZhi+OMHPlFDpRyY9POPJKe8lwAynDv+SEJF/2yOhvTGAd6gIgcHEhRdXFSwS3S+rTrc5oIbrY7aK9LnorMDWp2BOK1+6EC9p7GCJtbeKM/PSbctG97tCC2GCZ4bxjCN+peMMo13XVILoDgjxzJOhUAcLe/fl+m/jcyjjCWLifMKO1lQlLeQgbjpqZxl/e9jE55m37F+yflkZHMebuKxi0V2yx1A6wZX0+07h4oy6kcjtalin+i+d3aS1+vEvcQpXhPk+8F7OULkEuVd+T1gfMZVqoysVD0ZeGVU8SSXBSrdhw8M2R5ght0onvfeCgTQ2a7JlCU5fErB2eXyqnAYa0cadkID4WvRooaLETIncAllEj0p8m+W+RN9/cSIqciZtr998SIN9iTfsNtE464R2Hj9zJBm8TCMOS7JeEmYgl8PzvrTsSNkh4ZCMCZHX3b5pDTXh81aOtDdRKbrM3Owqup2r/dL7puTFPl0Ct/W7FKuFzgNVf/6bSTzyjeQN8pABJ85mhOgEP0ESGToLjbZP++p0wrhZ0qnnjeCq7YlEW5yWMk+q8KMsPspW/4KWu/vq3uUJK2wVbKpP8eGvDs1BU/htYXXp31XB2zInHi8264G9nawNZOsce7aTQHA8qMJLtpL/aDXg54sNidgSMsepm5+vIM/Nvf6gADkWktxFhFjsFzhQ2PBkCDahq7xKYmY9pr3TWK9aKJ4r
 fNC1Iz1I
 h0HCevcNbDbpXJ7bFmdYlQ6trR3o1EmXsiRo8ia0C3z6Wu7w7OR6GuVtcmZlqf9duVaIk8eOpmASLNAjVq+5I7UiDFWBviYCfGZAuTC6po91gf3SJ/GOj4kLl/Sm3O0FqZ1pUnfz+kCEWJOlo0zYDJ5wnO/3qs6n72GNoluQi9M8fcqph2/VyQ6y4QCoGl/FEcCLKZCgsqBfuZ164Rg5ebbeHa+0SdBWBj0ucD11+K2ZaS/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 4:31=E2=80=AFAM Lance Yang <lance.yang@linux.dev> w=
rote:
> Would it makes sense to apply a similar treatment to huge_zero_folio
> as well?
>
> with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=3Dy, it is allocated at boot and
> never freed, so it should never be written after initialization either :)

Oh, neat, I didn't realize that that feature exists.

I guess there are two aspects of making the huge zero folio RO that
could be problematic:

1. If the huge zero folio comes from the page allocator, making it
read-only might require splitting a huge PUD, which could have
performance implications.
2. I vaguely remember arm64 has rules about how PUD/PMD entries in the
linear mapping can't be split at runtime at all depending on hardware
capabilities, meaning the entire linear mapping may need to be mapped
without any huge PUD/PMD entries - IDK if thp_shrinker_init() runs
early enough to be excepted from that. See can_set_direct_map() and
force_pte_mapping() in arch/arm64/.

So making the huge zero folio RO in the linear map would probably
require adding a new config flag, connecting that to
ARCH_HAS_SET_DIRECT_MAP, and changing one or two places in arm64
memory management.

