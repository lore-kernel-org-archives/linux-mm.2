Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B2BCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081378E0053; Thu, 21 Aug 2025 16:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059D08E0048; Thu, 21 Aug 2025 16:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8798E0053; Thu, 21 Aug 2025 16:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC0188E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:42:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99A99C04FD
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:42:27 +0000 (UTC)
X-FDA: 83801937534.20.CFCCCB7
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id A32E3C000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:42:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uWyAPBk6;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755808945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOrpqfc8n93v97pF20SR6SfrUdLBJXo3INEmRyMuyqQ=;
	b=M7CwzVSPItYBYdw8GR8opUkfJHCzjA+8H1XD8EGtOMcRh67TwUAYvtFzXSJObneGAlvxwM
	rspqBM8mKSu/RfKQXni0dZwh8RuoKDqjMKDvBgVX0GaZmqdmwDfkIDjBQ/cCMhU3EUwo6j
	RyZykQFxP2gfVy4dz0RLkJOaKTC0vVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755808945; a=rsa-sha256;
	cv=none;
	b=MYE1P2yIV5obk63udszmtuHwUFOPUWcKWn1UgQ0Udn4qIbYFxXdFkeUTGLmGHtdutHJXPR
	wxo+u5u3ir04UvhREC+pcolCJBDVNQ4Ah1y0fDTNuccSBZfvprGddW6d/YNmsWfDOniq3T
	53VL+ak3lK+PapkpI38utpPobSXBcX0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uWyAPBk6;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 9711E5C0579
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428E2C116D0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755808944;
	bh=Xyr2vTQWJi84phHGI09fHiyAc/a2HiFJYMzB+7vMKUY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uWyAPBk6TQh4uZnvEeJ07eNzt1pl5zG9rmldduuxYxRyfKEAMUVD8cQsfBbfwVSBD
	 pP1s8CGg9G7iP+YLi0bLtxLzMTq+WGQl+nV13zWSNa+QvXZ+H7d0QYkfn01nKyY2nA
	 gCKFjQCOm8iOJ5JTPikff45cTnMpvdrxFPNiGbh7YGBXH41c7Ii62rLhoAXNqzTv4X
	 v4OzAQbyIUkRZgTdciycY40FqqkLhJ5mCKk9PjrojY5Xu6Vvi2gtj2EilksoznfVyJ
	 w8sHlKuVPcC9EJ6fUUf4Y+xJ0sXKFKeYdt8tlfHECs6PWt4BGAeK6/mGXjjXlBXjf1
	 T0HjMag/QYNVg==
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-459fbca0c95so21365e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:42:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVtU2n6BsgO9HFl2X28QjE88yPRSK7AETN1h6jx3oeOKQqwkf32m4OLbJJG2K1G1e5IROIyicTpAw==@kvack.org
X-Gm-Message-State: AOJu0Ywq3+/dsL79O+BfiPTZ6Ce+XCNLkmJhpe/jl1huFLq+LxAnmMUO
	fH6whcm2YJ/RIXuflk1wWNBEheaa+xjUpvQpxBToWcBcq+9CF4P4egpXnNGcPeQX0V7uF8y8rGo
	rXbo5mIcJc1I9WO6iXgPz+1N3gdxO+7CoxA7HiFBE
X-Google-Smtp-Source: AGHT+IHDZCalgfqlYi7MkLgFbyjbhsH3CZf0MNkISUXvgYgeAZsgXeUqGGDOaCg+VIv8TDFRobw1n05v/ADvT2/804M=
X-Received: by 2002:a05:600c:8b01:b0:453:79c3:91d6 with SMTP id
 5b1f17b1804b1-45b52119c8dmr9385e9.1.1755808942940; Thu, 21 Aug 2025 13:42:22
 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org> <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au> <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
 <CAF8kJuNJ8s2D9NBdXDQ4vpBP0a-5k7r_=DdFuJJ95nMKmm6LBg@mail.gmail.com>
 <aKVYyGWiWRYgxfE-@gondor.apana.org.au> <CAF8kJuPPsLzWu8+xm2A_UPHMBhb7OTjJNErM1Kp3hPmvHXNDUQ@mail.gmail.com>
 <aKVbqi6wd3Spz-TM@gondor.apana.org.au>
In-Reply-To: <aKVbqi6wd3Spz-TM@gondor.apana.org.au>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 21 Aug 2025 13:42:11 -0700
X-Gmail-Original-Message-ID: <CAF8kJuOJsZ2RbvFedfKADVqa0TUrkO-ceqrtaMXgiHAS0V19hw@mail.gmail.com>
X-Gm-Features: Ac12FXwy1vPVdOsVeHesiENd9Xc9-_4Gop9B9f4wYnWvLSSwoexOz99om6lRJM4
Message-ID: <CAF8kJuOJsZ2RbvFedfKADVqa0TUrkO-ceqrtaMXgiHAS0V19hw@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A32E3C000A
X-Stat-Signature: fuany53camzs5aeyxexew7wrhx4xwfqh
X-Rspam-User: 
X-HE-Tag: 1755808945-96567
X-HE-Meta: U2FsdGVkX1+a8JonNT3Qyqsw7DCPw6p8NQy2W8+YOw+jO43A8pcHannmpS4HnEBYdw89U/omgjGKjv9/KEpdj1HQ6ss3s8VjA+7cCuCWutkecvVGNQnBinT3qrOrz2OsPv88c1WjHnfjmUtnZnVbUra0WoPA0X1wm4I6uC1t+u4nZKqI38bv4cZsGDMOnYVBEXiS536DgACzEJomUef4VEOn8gM1BqSQAojqNWrebRNWqDsG1FmcnUhb3Wjh+5nM6ZAXGQ4Hgk0zepVfS6NopdkkT75J+8AoL71yhMswsY8AD1mdtQtFrGvePsD1CgLtDiniXnW8LIgxlyEryRGfyAs96Xodxs8NGKgOiHK9Lnh67V8CnPmQ6ECoBr3JormkVeBmCkUbpSFhxaEVWWKGFC377vKrwSx4eyZJbzh0CQbeM75VNp6jAbR3wkFHfDna2TdZOqOx15IHkM71POosKb9UQ5KvE9c9gYU5wAHkLmH3/gpPOt+aITxebIN94bFzk80IxubnGDW512sbUAPIqg/uaWcQ1kc0hdNU4Mt79Dl6oXRwyP0ibKUHEjgubK9VFNIuwFsubm4ZqF69NO/E16YL7hd0u3EeOd42dlv2O8U9UL0JWZWsyc2mZr/by2I/mgSfQhrfc6+qzGRHys4i9OwmNGpe/Qm93XaPCv+2Uo69JYZHp1W1pXr2kWEPmSCGRbEy4bA55yLNO1YoNE/fx5BAirTY2bniOZE7AxRHKjOGCn9rZ0ACNjUpcwaahh7Gd2XGwXhrphuWNFZSjXTomZVawuRI3M9mL70H8MJxOUYB+TWAnD40FQplaMtKjxr8qp4dDv1E0pvIoGyQWSiYzA4XaltwvltkoyipQpV6wOu8lsQe7AT1au2L/AbACR1yaSHZ3Kfq9VH7OaXxF8cDWt8qFR3ACNkxY23OCyzXu+WPBcekAppwoTRwduHf1i49sEGVd7wO/ZUQRe8Z0ir
 AT4gfdDv
 CzBWdhw8MYt19Vsahd3e8OrYXAgL0EFjiJspwbxPYvt31mNh8KO34iaAKEoRZPW5wvYDkSKUSAPU3wRam91I9BaGpDW3smhg1VuhxDhdSAnvNaPA4TZu+mWwDfU0Kh5WtYIyWJGcQX2odoZlBTwmg0UwqTszcrAdVROU1uQBuDLF8Edq22buFXmaJRvXb6moKcoqiLZT/zbiMVO1OZmqFtI3jvCQW+p/zv+sAJFnPEuWUGc1Y/jCZNv1SOvIer5iULysItqsWmHzWZ2qrhiXL0VUhIClkVFckoYgp+kMRnOQy+GP0wlu4YaeRDL+yqnlVo7uBLHhqcRVOMEakgMLBo3lOlgMsZrQWxc1FromdfujTscK7FaQk3vKei8pMA/WoAT13b8HImZ4pnjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 10:23=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Tue, Aug 19, 2025 at 10:20:45PM -0700, Chris Li wrote:
> >
> > In that case it is fair game for the caller to check for the error
> > other than -ENOSPC. If the return value is -EINPROGRESS during
> > synchronous crypto compression, it is a bug. We are not encouraged to
> > use WARN_ON, then having an error count to check that something truly
> > unlikely but possible to happen is better than folding it into
> > incompressible and pretend the error never happened. At least we can
> > know such an error case happened.
>
> Sure warning on -EINPROGRESS is fine.  But every other non-zero
> return value should be treated as incompressible.

Ack.

Thanks for the feedback.

Chris

