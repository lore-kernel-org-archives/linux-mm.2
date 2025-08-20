Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB27ACA0EF5
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEA26B00D8; Wed, 20 Aug 2025 01:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396758E0011; Wed, 20 Aug 2025 01:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2EE6B00DB; Wed, 20 Aug 2025 01:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2C66B00D8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:21:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B10D2B8960
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:21:01 +0000 (UTC)
X-FDA: 83795986722.22.61A30ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 990E940002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:20:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JpRRz5vx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755667259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TKSY4/lXffBk1bEYwJHXHjTL22/Z+F6xZnTu/DbjOU=;
	b=svpZ/sLJYcfysA2WDBG3dbsCV+yGFQWqsytBUctVQ2Z9AFamde47VA1UqIe/bI2XUQPEFy
	jsxubcHToNjJLuyKsrmLVyO/U5A9/4w+t6ptRU+kwOMxSaURkv1EowzwgA5Q1Wi6L6iw3u
	QSQFUJY+JT4t96jhnbeR43f2cwQkXSc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JpRRz5vx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755667259; a=rsa-sha256;
	cv=none;
	b=HhroUTL7OPWZf/ubeP+1xF5VY1QGTQa+4lKSPQq1dV4qh5bZoBpR3iFZ9iUgEzVa4JUsDo
	dGhb8OBrVDdtw8mbIwxASfYJY9D0KAkafprJ2pff39QRRbp+z4J+i0ceK2k6X4PjXmh7Pc
	k/c8pcElvgxgyjJ8n4fSr0x2LRlAZgw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FD2C4321B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5238CC4AF09
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755667258;
	bh=6TKSY4/lXffBk1bEYwJHXHjTL22/Z+F6xZnTu/DbjOU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JpRRz5vxQrSl1MEhicY96+FjdH34XIXty52P5tXseuN6137NrzkFqtXtElyCdGCyu
	 IbtwUT2WOjIz7VixXUR8JU0l2IJlVOM3wLNbIfPmjTL8zH7vQ35qoxyNhVQKY+TChp
	 B0KoS8DJU1JKshRIc79/EDWETAzB1Cm6+DsU9KyDz1Ouqrw/T669Bm2qUjgUVzvy7y
	 4eYw/rPz3dRNGrQH20rG4MEb3r5iQbHcWRLuO7/Dd1JRvRIMzDLdKbEIflG5AQf6uP
	 0mSYCWlfMTTAZYzyOJUFQ4fzhfgjx0vFx5XUFj+nKcoXrGqaTzdEDCOVQnBslLBk6B
	 6EyQvAh2leiPw==
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so29925e9.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:20:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXf64imS3yVPHhXbgtvnLXoqpLDqTtJ+p81SZXgXnG6L7XmirbjDD14vY5AoUSrY6t3oZmhZXrGgw==@kvack.org
X-Gm-Message-State: AOJu0YxnyLnhxPDRa24XXERDIrJDxJ6ZGuO+eqAd9cmemO2vNKKC8zZu
	B3G0A6y3b2dSTmq6kk9vnazgZfmKpMrd5y7IMgF/rCOsj+rmCZyvQ6MqHx1lHU0UXjHuljrLja2
	iZ+j+m20a3BxVhUn9NM4pKlkxHM14vWGPqyPo6T8n
X-Google-Smtp-Source: AGHT+IEjZhoG+qzilq/U1vimpZ5Ew1PMM+qqCYeoSrlPd47GMSymNL5JWRWRWqBhefqEc/wQHyGffXE5TpqEHU9miRQ=
X-Received: by 2002:a05:600c:3f05:b0:456:e94:466c with SMTP id
 5b1f17b1804b1-45b47d0f6f0mr916805e9.3.1755667256993; Tue, 19 Aug 2025
 22:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org> <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au> <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
 <CAF8kJuNJ8s2D9NBdXDQ4vpBP0a-5k7r_=DdFuJJ95nMKmm6LBg@mail.gmail.com> <aKVYyGWiWRYgxfE-@gondor.apana.org.au>
In-Reply-To: <aKVYyGWiWRYgxfE-@gondor.apana.org.au>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 19 Aug 2025 22:20:45 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPPsLzWu8+xm2A_UPHMBhb7OTjJNErM1Kp3hPmvHXNDUQ@mail.gmail.com>
X-Gm-Features: Ac12FXx3s2d7JOW1u4QIm6NEM1DfOmwb4PMZclWUcMRycrx6dr8sdVcaQX0qtfg
Message-ID: <CAF8kJuPPsLzWu8+xm2A_UPHMBhb7OTjJNErM1Kp3hPmvHXNDUQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Barry Song <21cnbao@gmail.com>, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 990E940002
X-Stat-Signature: ea6scdrnohawtbc1scbj4jpau5xpzd6n
X-Rspam-User: 
X-HE-Tag: 1755667259-122947
X-HE-Meta: U2FsdGVkX18yVrooCY3+n9shPi4m7IUqYiQ4CtXyjYc2oki3fuFpc3jsvzyY3vA5OJAvuWByd+nK1J2CiOt8SvHEhoDcCcpjqFjPA3gqntVSppFWQjf+ya0SP3lMBdrjjeO7gVhNGcEC9vr8t1GO7LWzDU5TMLRneO61LmxahA0tkKvUKxheeuxxG/sf1BNqb5B/6HQOB5es9wxZ9RdP0Ed3JnlQ6mp5fSBjCynWILDsbRKef56hyjVfgcBCnEylJ60Eod/cOWlPweNP/TqYVypkB1Fy+m6FrD9Gb4YUtP+Xe2XEEeWkSWjsKlicxe/6+OG7GXz8nY0BDmlg9cdXxMGWEkMIjVEJEOWEzbp410qRO9yJPnqX/c8PljSDIJoq4jYfJyF8iqpJ9L3DWpU+mbe8ZCul99PvnFKSdYdHncZGySTcc3atjHOro9CCB41tWIN51fNcZurS3++WiJZlWDZAVeAwXXeePkgw8Ryc5PYoWrds5Hty6eO812M/MWqSC+6o7KTtWmHzI0cVAMu9kDEoBFI6LrWaXUwtFTJe4qnQdx1/ld8tJkNSg2TaNsLnveyON2kiDxcyGRNDbaGLUh7jnrF2PViDB2htZvivg6Z2ZKVW1ZoaB9hpvzCYzzKQAsezaiKwEoHB7E2dVzVt21Wn835SvNpxkJm8BIHULJfP4x92yJheDDKreNv+/tJZynTvCSYyXy+CMjNjoWTVJIkWQuRL1GMbdeqVp7u+8OjR2wp9VzOe9NZV6jOHjCoD0ebXgmSsaDS5ulzmRM9170ia/PpoD34vy8Ny6reNRupCphThGtlUqRPsqv7zyuHsDmwF12ubJP6vP2+KBu5UJlTYpOZ/guClrfmTPZPyF5bgrizzEq4REn6NMSy6o0ltMqlRahSUymt5e231g7I2t0hDG01u1GhtmhBSNEQ9rM4t/jMExsW96pC7CQJ2Gg2x4CEjO65GewQG0ifQtLT
 g8aJwlHv
 fgj+lxu2LfRQ+LcGrUj4d1FoR+ltT9ylaoFax2IhuPKFv/S+QdPtNl76OHWmHdEEabMh8GQkdiNziWCWdmIzUbIjLk01TSOfBiUP/sw23Lj9TGQqIfr14eeB+H5n9LAU4sLyRYtNjzLGalbEjtFHfag3ChidoBMnuBtxh2Zpktf2IfjWgSgXtficW21NV5Tz8cqRaMblAVd+NpSVZCar/6LoXRP2wSlRlk1Bljy+xMUF6daGrPeL3QGZsPTPs9xBzJKUpRs5TAmE6ymPP5KOCIsXsCkkRGykoFe6etwhRTylwIEPoxjj4OzBUiXUY44Le31DI3CL6UNxt9yvHAskNMfdf+EwREJQvzIvY/UZRGnrDfxPEklp4u0gTGyTwvF3nJUqCCBijT4vGEkg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 10:11=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Tue, Aug 19, 2025 at 10:07:57PM -0700, Chris Li wrote:
> >
> > But if that error case can never happen, we should convert the crypto
> > compression from returning error number to bool instead. It does not
> > make sense to return a free form error code and also demand the caller
> > does not check on it. If you insist that the caller should check
> > return value like a boolean, just let the API return a boolean.
>
> No we need the error value for other things, such as asynchronous
> return -EINPROGRESS.

In that case it is fair game for the caller to check for the error
other than -ENOSPC. If the return value is -EINPROGRESS during
synchronous crypto compression, it is a bug. We are not encouraged to
use WARN_ON, then having an error count to check that something truly
unlikely but possible to happen is better than folding it into
incompressible and pretend the error never happened. At least we can
know such an error case happened.

Chris

