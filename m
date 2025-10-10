Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2C6CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E24A8E00BD; Thu,  9 Oct 2025 21:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA0E8E0002; Thu,  9 Oct 2025 21:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF998E00BD; Thu,  9 Oct 2025 21:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2E38E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:43:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A364314013B
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:43:13 +0000 (UTC)
X-FDA: 83980506666.02.8BDCDC0
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3CB914000D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:43:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rEOIwQFn;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760060591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96az3arQQNj4x6OI7kGaXy8qdPeeaXxUJmGrbGqdnv8=;
	b=LNsn9NaRsDZd2SDNFL640tyFxiYNuueGxxdV4YZHyHzL+vdVy7h7JCLf12Mg3BrILFCkHJ
	wF6WPE0CM7513jl6FEDYwLCansOyqxSckyuWZLeMsdsdHeiN7t5S2e/VyRPaIRvjc+uB51
	KWQy6X3aEYYhG3IsQRQ8jy+IWTrq6Xs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rEOIwQFn;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760060591; a=rsa-sha256;
	cv=none;
	b=Y1QRdCwNIHkOnN4sc96/p+ToHfH8oAsJztQXMXUUYpky3cnv1tmUTkI7MO4M95JVoL1Vg5
	h2ABhFsOxL82CNWY0tU/7Y8AZqt3t7G+jDxSq26BxX5oLAwGgq94r6GvK9Mi97outnL1Yl
	Ngx9TuQZikVj05gBWxWw85nwhXERokk=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4de66881569so233981cf.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760060591; x=1760665391; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=96az3arQQNj4x6OI7kGaXy8qdPeeaXxUJmGrbGqdnv8=;
        b=rEOIwQFnprOqBuQKRbD2qy727MRGaLnpgiVqzdxZrdzej0eCPUIpRtaExPW89EeUwe
         mi+Vdknjly3MSqPpFjTsR/K6nFbtDQsYqCow79IzSbPFkG+0lsLc3SNS4Y46L/7/vd/f
         b7t9wryWF2CX9TkHjAAan2STu62gCdWx9iujS79pw+l4l+uEwTWKGeVKNCFKB2sB1s4w
         pwIriUkPZpMtq7gJkZWFmmIqmwqPodarYUX2HqwbJSP5t5ZYHaVTf3QUkbjKF8tz3PQP
         guBu/nYjrqL5Z39v7pJ9+qnp0So6d3tc36QFjyDFvu0d3/eV+tcMaHDTFWvYpJ/VctZg
         1ZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760060591; x=1760665391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=96az3arQQNj4x6OI7kGaXy8qdPeeaXxUJmGrbGqdnv8=;
        b=Up2SDEkFNCMxfUgIV3ShYV2+kBNrHaWQtkFCkAFZJpDKzL+YpNJip3GIA2caRceHgG
         naFqJzNqA5XXnukFEKXrncePhkgVWjO7JTYcKiv9pQ/pUigu1tl8KU+wRD2qVDBhrgrl
         KqfJqdFqAqGmRlSGsOi7xcKIS9I2sKgyIuBkxT6D+nL4mqlh1UeKSWiT+9+e8+VfwHf5
         WfMOvdsHyOyMM1OB7Y+5h8HG4iweURJW62Ks0gtz4S7iQtdSbkgcQFssNLYoWCv0fTO3
         9vkUgrT54mB03Re6xfQHJvmhp0RMZRyUhiBilf6ngCy7OQy2hZ2y8qKSx4wG5RPC7UTo
         Ifrg==
X-Forwarded-Encrypted: i=1; AJvYcCXYNuFo5yBby48235Jsl+t5OZ2NwKq43lohM6QsBf700xpALdd1LXQwSXfPAxw20f1PGTry9a0/4Q==@kvack.org
X-Gm-Message-State: AOJu0Yya5TAltaK1FfbtHG6HpcmAXgBAveO7Hg/cXTphm1zQXRq9rexp
	Ps0UUJlNxNhuo4LLntkLjjzzGkfJ1xF5k47cFGTsuvvEHLC1wwskIulanHJwf7wkK/zFnTkztcJ
	SqyHNc7ytmfNAQcQyHy2JnxLhilXDIalcLeX319Xz
X-Gm-Gg: ASbGncuwjk3NLUXq3OEbw977ksN7g35cXS35kX6KYGQHaI9ANJVxwWA1bsnhTiBtT4Z
	qyilhIYzDlhhfr3m2OLcMK2ZqyKMeSbWoP0PyOM0G1UcLxsccIv+6ZXdd5PVnR0HlLFadUVb/dv
	wxnUxjtYKCaF1Pli6eFMPB+YJJHOmOdsii4RX5xexUk46in6Htr/YvgiiYqRuVwmaXKPuLVTtDd
	a+S6JkohBxwiUF9bDevRH4XBxl1qZQ3y0P4MNY0MtWg92+0tzlGrOJg8T9/8bAL55K0Q9mlr9LA
	Vvg=
X-Google-Smtp-Source: AGHT+IGu0DK2CtCxN7hIIonTOKdPg8kH2c5mClv9tYOC7wcuhU0agjHl/Z5qabjh4i0XRN459MUgMBBjudlklfZKzww=
X-Received: by 2002:ac8:590c:0:b0:4b7:a72f:55d9 with SMTP id
 d75a77b69052e-4e6eac2a26bmr18693271cf.13.1760060590253; Thu, 09 Oct 2025
 18:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com> <20251010011951.2136980-2-surenb@google.com>
 <20251009183145.3ed17cb0819f8b7e7fb4ec43@linux-foundation.org>
In-Reply-To: <20251009183145.3ed17cb0819f8b7e7fb4ec43@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 9 Oct 2025 18:42:59 -0700
X-Gm-Features: AS18NWC-Nnw6mbU0XDp5pk62GdBblSXl-3NkXh8X6HtK-SeNhS47_j3D0edxdNk
Message-ID: <CAJuCfpEPOOFOtd-Vp4VtTJyqxP_5+7h7SaMT=6exY1YZOE9v5Q@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: implement cleancache
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev, 
	Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C3CB914000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bo53tfq8uctiter5198utc9j99qukhpn
X-HE-Tag: 1760060591-645590
X-HE-Meta: U2FsdGVkX19dY/mKiGbNSWu6Jjsil8L2Tf5bM+aDoYDpduTHp8x93NlZyo0KPovuVk4pMnEr6A4wApcvisFO4zAbD7Da0oMxsJT3SJFFJxcI8pUU9vlPqQvBlQMhuKEzZt7HU0a3vH4ov4msca5gspQJrweLLQ/nSkHm3X7HuYCIV8vXIw28oJnbpkmRJIJCmfC8tgFLeVqH35SiDyLScNz16dP7oebKbJuiA9CtjHsx2XVg4avcbC8r+HSmjgNCsZGVCcgLt1C+opAgihrkTYlmlgOkNeAGpIwTouv7JEbFZpfgtnGq7bV1659ZS44FCS1ujHBWKvDmXEdp1ALIzGkszvix8VpJXDfmAjkV8MdGqAnTDgtFuCitOx/wvaMNsrbTL0oLopPeUuH2a76yFfwF1vWbrZm+EOwEWdDPkvn+JUbvQ9fwvvmxbqztGqFWqJXITB/FMB0cNuWQrd1ADQ6ZSDAKwlvhb8l7C8B7plNu+Q52L6fsOxNqNmLmSm1uLXPqHlFHbqOvCVLGC8gLkJ7c1neLW2ae7S95p05FKAwgnAlZmpqDaAuxnyHGjM0HxWay4rkilKHKTn4jMPdVULCxe+I1YoScrOlkTCHAHUAAW2cf9aHjVhJ193VB96ubnnoKoNa933HZ2GCEiLzVeFUbFz2EPoLeY/CH5JL0K/cRpgtt8UgZxXdDZTHr5ZaQrZLtvKEpmTI7hxBcmkt+HqAGsuunPhF9vaxJbqvq/SglsW5ORatGY0FoY4Df5pU71on18RrC3yxF91Js8km9g2X+CzMcpDy8HGeK8FbtRPO9C4fR6s8fUWuB+wjHFY5rQVe+KT8G0mQf7YPAdb1g4BCghG7ooOU1zUTC6Z8fxBfqIqdlSSOagi6jKLSQNzjSQqE09pnCBIhoRyw/30RcRZMJ2dUJ5TSEbPbBZBx2C261AiECUpDR1qfjpz/CmWe1nRaNVsBMZqCINW0uAGy
 AzIuzCFr
 XEnRmqYoVU8zCBPpwsUFZe+sSKefrXbhZFO7reTuv7b++XM/NIeUMCQ+Cn2Kkx9MQHn0cDY6SjbfMqI58FRcdGknf64TjKo9IVzBJVGRu/c4/p1aYm1s1IW8xyK9Z+7gs8pzGbUiobO1HN1WUwRv33czUQ1GCkfNdwzd4jkibSAj95QiapMWFsiPj9S+eGecgB5usMXY+tTYspEdAo6ysolvYV1n1F4Ur97ZVOoHCz+0Nc9ajH937Dqmm5HdS7ul0n6CgR8tu+TiIlrwid0kmS/X516k2r3DuEfBrOp6I7RlMg7U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 6:31=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu,  9 Oct 2025 18:19:44 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > Subject: [PATCH 1/8] mm: implement cleancache
>
> Well that's confusing.  We removed cleancache 3+ years ago in 0a4ee518185=
e.

Yes, this version is a complete rewrite. Previous version was a thin
layer acting as a middleman and having hooks deep in the FS code. This
version implements most of the cleancache page management inside
cleancache itself and allows GCMA and future clients to be thin. It is
also much less invasive, limiting its hooks mostly to the MM code.
From the cover letter:

New implementation:
1. Avoids intrusive hooks into filesystem code, limiting them to two
hooks for filesystem mount/unmount events and a hook for bdev
invalidation.
2. Manages inode to folio association and handles pools of donated
folios inside cleancache itself, freeing backends of this burden.

The idea was presented at this year's LSF/MM and RFC was posted at
https://lore.kernel.org/all/20250320173931.1583800-1-surenb@google.com/
earlier this year.

